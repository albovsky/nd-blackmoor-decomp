/* Load GAME.EXE (read only) into the guest address space, bind the imports to the host stubs, register the lifted functions, and run the
 * game from its entry point. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "rc.h"
#include "rc_internal.h"
#include "rc_generated.h"

static uint32_t entry_point;
static uint32_t image_size;

static void set_error(char *error, size_t cap, const char *fmt, const char *arg)
{
    if (error && cap) snprintf(error, cap, fmt, arg);
}

static uint32_t rd16(const uint8_t *b, size_t o) { return (uint32_t)b[o] | (uint32_t)b[o + 1] << 8; }
static uint32_t rd32(const uint8_t *b, size_t o) { return rd16(b, o) | rd16(b, o + 2) << 16; }

static int load_image(const char *path, char *error, size_t cap)
{
    FILE *f = fopen(path, "rb");
    if (!f) { set_error(error, cap, "cannot open %s", path); return -1; }
    fseek(f, 0, SEEK_END);
    long len = ftell(f);
    fseek(f, 0, SEEK_SET);
    uint8_t *file = (uint8_t *)malloc((size_t)len);
    if (!file || fread(file, 1, (size_t)len, f) != (size_t)len) { fclose(f); free(file); set_error(error, cap, "cannot read %s", path); return -1; }
    fclose(f);
    if (len < 0x100 || rd16(file, 0) != 0x5a4d) { free(file); set_error(error, cap, "%s is not a PE file", path); return -1; }
    uint32_t pe = rd32(file, 0x3c);
    if ((long)pe + 0xf8 > len || rd32(file, pe) != 0x4550) { free(file); set_error(error, cap, "%s has no PE header", path); return -1; }
    uint32_t nsec = rd16(file, pe + 6), opt = pe + 24, optsize = rd16(file, pe + 20);
    uint32_t base = rd32(file, opt + 28), entry = rd32(file, opt + 16), hdrs = rd32(file, opt + 60), size = rd32(file, opt + 56);
    if (base != RC_IMAGE_BASE) { free(file); set_error(error, cap, "%s: unexpected image base", path); return -1; }
    size = (size + RC_PAGE - 1u) & ~(RC_PAGE - 1u);
    uint8_t *img = (uint8_t *)rc_map_new(RC_IMAGE_BASE, size);
    if (!img) { free(file); set_error(error, cap, "cannot map the image for %s", path); return -1; }
    memcpy(img, file, hdrs < (uint32_t)len ? hdrs : (uint32_t)len);
    for (uint32_t i = 0; i < nsec; i++) {
        uint32_t sh = opt + optsize + 40u * i;
        uint32_t va = rd32(file, sh + 12), raw = rd32(file, sh + 20), rawsize = rd32(file, sh + 16), vsize = rd32(file, sh + 8);
        uint32_t n = rawsize < vsize || !vsize ? rawsize : vsize;
        if (va >= size) continue;
        if (n > size - va) n = size - va;
        if ((long)raw + n > len) n = raw < (uint32_t)len ? (uint32_t)len - raw : 0;
        memcpy(img + va, file + raw, n);
    }
    free(file);
    entry_point = RC_IMAGE_BASE + entry;
    image_size = size;
    return 0;
}

static uint32_t stub_of_slot[1024];

int rc_start(const char *game_exe, char *error, size_t error_capacity)
{
    rc_core_init();
    if (load_image(game_exe, error, error_capacity)) return -1;
    rc_win32_init();
    rc_ddraw_init();
    rc_dsound_init();
    rc_bink_init();
    for (uint32_t i = 0; i < rc_gen_import_count && i < 1024; i++) {
        const RcGenImport *im = &rc_gen_imports[i];
        RcApiFn fn = NULL;
        if (!rc_win32_resolve(im->dll, im->name, &fn)) fn = rc_unimpl_api;
        stub_of_slot[i] = rc_stub_for(im->name, im->dll, fn, im->cleanup);
        rc_w32(im->slot, stub_of_slot[i]);
        rc_slot_add(im->slot, stub_of_slot[i]);
    }
    for (uint32_t i = 0; i < rc_gen_thunk_count; i++)
        for (uint32_t k = 0; k < rc_gen_import_count && k < 1024; k++)
            if (rc_gen_imports[k].slot == rc_gen_thunks[i].slot) { rc_thunk_add(rc_gen_thunks[i].va, stub_of_slot[k]); break; }
    rc_register_all();
    rc_unlifted_register();
    rc_log("%u imports, %u lifted registered", rc_gen_import_count, rc_gen_lifted_count);
    return 0;
}

int rc_main(char *why, size_t why_capacity)
{
    rc_log("entry 0x%x", entry_point);
    uint32_t eax = 0;
    int rc = rc_call_raw(entry_point, 0, NULL, 0, &eax);
    if (rc) snprintf(why, why_capacity, "%s", rc_abort_reason());
    else snprintf(why, why_capacity, "returned from the entry point (eax=%u)", eax);
    return rc;
}

void rc_get_stats(uint64_t *native_calls, uint64_t *fallback_calls, uint64_t *imports)
{
    uint64_t s[4];
    rc_stats(s);
    if (native_calls) *native_calls = s[0];
    if (fallback_calls) *fallback_calls = s[1];
    if (imports) *imports = s[2];
}

uint32_t rc_image_size(void) { return image_size; }
