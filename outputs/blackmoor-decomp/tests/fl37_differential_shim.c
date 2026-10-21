/* Flat entry points for tests/test_fl37_differential.py: each wraps one FL-37 port (src/original_methods_fl37.c) so that
 * ctypes can drive it on the same fixture as the original bytes run under Unicorn. One generic host logs every call (callee, ecx,
 * stack arguments, the bytes behind a pointer argument when the test asked for them) and a per-callee script tells it what to return
 * and which dwords / words / byte strings to store through a pointer argument. Pointers into fixture regions are turned back into the
 * fake original addresses by the test, pointers to a local of the function stay host pointers. */
#include <stdint.h>
#include <string.h>

#include "original_methods_fl37.h"

typedef struct ShimRegion {
    uint32_t va;
    uint8_t *ptr;
    uint32_t len;
} ShimRegion;

typedef struct ShimCall {
    uint32_t id;          /* the original address of the callee */
    int32_t nargs;
    uint64_t this_ptr;
    uint64_t arg[16];
    uint8_t data[256];    /* bytes behind pointer arguments that the test asked to see: [0..128) shim_script_deref, [128..256) shim_script_deref2 */
    uint8_t probe[4096];  /* bytes at the probed host addresses (shim_script_probe), concatenated, read at the call */
    uint8_t world[256];   /* the first bytes of the Fl37World snapshot at the call */
} ShimCall;

typedef struct ShimWrite {
    int call, arg, offset, size;
    uint32_t value;
    uint8_t bytes[256];
    int nbytes;
} ShimWrite;

typedef struct ShimScript {
    uint32_t callee;
    uint32_t results[512];
    int nresults, used;
    int deref_arg, deref_bytes, deref_arg2, deref_bytes2;
    const uint8_t *probe_ptr[8];
    int probe_len[8], nprobe;
    ShimWrite writes[64];
    int nwrites;
} ShimScript;

static ShimRegion g_regions[16];
static int g_region_count;
static ShimCall g_calls[1024];
static int g_call_count;
static ShimScript g_script[64];
static int g_script_count;

void shim_reset(void)
{
    g_region_count = 0;
    g_call_count = 0;
    g_script_count = 0;
    memset(g_script, 0, sizeof g_script);
}

void shim_add_region(uint32_t va, uint8_t *ptr, uint32_t len)
{
    g_regions[g_region_count].va = va;
    g_regions[g_region_count].ptr = ptr;
    g_regions[g_region_count].len = len;
    g_region_count++;
}

int shim_call_count(void) { return g_call_count; }
const ShimCall *shim_calls(void) { return g_calls; }
size_t shim_world_size(void) { return sizeof(Fl37World); }

static ShimScript *script_for(uint32_t callee)
{
    int i;
    for (i = 0; i < g_script_count; i++)
        if (g_script[i].callee == callee) return &g_script[i];
    g_script[g_script_count].callee = callee;
    return &g_script[g_script_count++];
}

void shim_script_return(uint32_t callee, uint32_t value)
{
    ShimScript *s = script_for(callee);
    s->results[s->nresults++] = value;
}

void shim_script_deref2(uint32_t callee, int arg, int bytes)
{
    ShimScript *s = script_for(callee);
    s->deref_arg2 = arg + 1;
    s->deref_bytes2 = bytes;
}

void shim_script_deref(uint32_t callee, int arg, int bytes)
{
    ShimScript *s = script_for(callee);
    s->deref_arg = arg + 1;
    s->deref_bytes = bytes;
}

/* the bytes at the host address `p` (`bytes` of them) are copied into every logged call of `callee`, as they are at the call */
void shim_script_probe(uint32_t callee, const uint8_t *p, int bytes)
{
    ShimScript *s = script_for(callee);
    s->probe_ptr[s->nprobe] = p;
    s->probe_len[s->nprobe] = bytes;
    s->nprobe++;
}

/* the call number `call` (0 based) of `callee` stores `size` bytes (2 or 4) of `value` at args[arg] + offset (a host pointer or a fixture address), or, with arg < 0, at the fixture address `offset` */
void shim_script_write(uint32_t callee, int call, int arg, int offset, int size, uint32_t value)
{
    ShimScript *s = script_for(callee);
    ShimWrite *w = &s->writes[s->nwrites++];
    w->call = call;
    w->arg = arg;
    w->offset = offset;
    w->size = size;
    w->value = value;
}

/* the same with a byte string (`nbytes` bytes, up to 256) instead of a scalar */
void shim_script_write_bytes(uint32_t callee, int call, int arg, int offset, const uint8_t *bytes, int nbytes)
{
    ShimScript *s = script_for(callee);
    ShimWrite *w = &s->writes[s->nwrites++];
    w->call = call;
    w->arg = arg;
    w->offset = offset;
    w->size = 0;
    memcpy(w->bytes, bytes, (size_t)nbytes);
    w->nbytes = nbytes;
}

static const uint8_t *shim_resolve(void *context, uint32_t address)
{
    int i;
    (void)context;
    for (i = 0; i < g_region_count; i++)
        if (address >= g_regions[i].va && address < g_regions[i].va + g_regions[i].len)
            return g_regions[i].ptr + (address - g_regions[i].va);
    return NULL;
}

static const void *deref_ptr(uintptr_t value)
{
    return value > 0xffffffffu ? (const void *)value : (const void *)shim_resolve(NULL, (uint32_t)value);
}

static uint32_t host_call(void *context, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    ShimCall *c = &g_calls[g_call_count++];
    ShimScript *s = script_for(callee);
    uint32_t result = 0;
    int i;
    memset(c, 0, sizeof *c);
    if (context != NULL) memcpy(c->world, context, sizeof(Fl37World) < sizeof c->world ? sizeof(Fl37World) : sizeof c->world);
    c->id = callee;
    c->nargs = nargs;
    c->this_ptr = this_ptr;
    for (i = 0; i < nargs && i < 16; i++) c->arg[i] = args[i];
    /* only a host pointer (a local of the function under test) is read; any other value is an original address or a constant and is logged as such */
    if (s->deref_arg > 0 && args[s->deref_arg - 1] > 0xffffffffu) memcpy(c->data, (const void *)args[s->deref_arg - 1], (size_t)s->deref_bytes);
    if (s->deref_arg2 > 0 && args[s->deref_arg2 - 1] > 0xffffffffu) memcpy(c->data + 128, (const void *)args[s->deref_arg2 - 1], (size_t)s->deref_bytes2);
    {
        int at = 0;
        for (i = 0; i < s->nprobe; i++) {
            memcpy(c->probe + at, s->probe_ptr[i], (size_t)s->probe_len[i]);
            at += s->probe_len[i];
        }
    }
    for (i = 0; i < s->nwrites; i++) {
        const ShimWrite *w = &s->writes[i];
        if (w->call == s->used) {
            uint8_t *p = w->arg < 0 ? (uint8_t *)shim_resolve(NULL, (uint32_t)w->offset) : (uint8_t *)deref_ptr(args[w->arg]) + w->offset;
            if (w->size == 0) {
                memcpy(p, w->bytes, (size_t)w->nbytes);
            } else if (w->size == 2) {
                uint16_t v = (uint16_t)w->value;
                memcpy(p, &v, 2);
            } else {
                memcpy(p, &w->value, 4);
            }
        }
    }
    if (s->nresults > 0) result = s->results[s->used < s->nresults ? s->used : s->nresults - 1];
    s->used++;
    return result;
}

enum { F37_406B3F = 1, F37_406B86, F37_406BCD, F37_406C14, F37_406C5B, F37_406CA2, F37_406CE9, F37_406D30, F37_406D77, F37_406DBE, F37_406E05, F37_406E4C, F37_406E93, F37_406EDA, F37_406F21, F37_406F68, F37_406FAF, F37_406FF6, F37_40703D, F37_407084, F37_4070CB, F37_407112, F37_407159, F37_4071A0, F37_4071E7, F37_40722E, F37_407275, F37_4072BC, F37_407303, F37_40734A, F37_407391, F37_4073D8, F37_40741F, F37_407466, F37_4074AD, F37_4074F4, F37_40753B, F37_407582, F37_4075C9, F37_407610, F37_407657, F37_40769E, F37_4076E5, F37_40772C, F37_407773, F37_4077BA, F37_407801, F37_407848, F37_40788F, F37_4078D6, F37_40791D, F37_407964, F37_4079AB, F37_4079F2, F37_407A39, F37_407A80, F37_407AC7 /*ENUM*/ };

/* Runs one port on `self` (this). None of the 57 has a stack argument or a return value; `a` and `result` are kept for the shape of the shared test code. The world is the host
 * context, so that each logged call keeps a snapshot of it (the probes of the globals read it). */
void shim_fl37(int fn, uint8_t *self, const uintptr_t *a, Fl37World *w, int32_t *result)
{
    Fl18Host host;
    (void)a;
    *result = 0;
    memset(&host, 0, sizeof host);
    host.context = w;
    host.call = host_call;
    host.resolve = shim_resolve;

    switch (fn) {
    case F37_406B3F: m406b3f_toggle_5e353e(self, w, &host); break;
    case F37_406B86: m406b86_toggle_5e3542(self, w, &host); break;
    case F37_406BCD: m406bcd_toggle_5e3546(self, w, &host); break;
    case F37_406C14: m406c14_toggle_5e354a(self, w, &host); break;
    case F37_406C5B: m406c5b_toggle_5e354e(self, w, &host); break;
    case F37_406CA2: m406ca2_toggle_5e3552(self, w, &host); break;
    case F37_406CE9: m406ce9_toggle_5e3556(self, w, &host); break;
    case F37_406D30: m406d30_toggle_5e355a(self, w, &host); break;
    case F37_406D77: m406d77_toggle_5e355e(self, w, &host); break;
    case F37_406DBE: m406dbe_toggle_5e3562(self, w, &host); break;
    case F37_406E05: m406e05_toggle_5e3566(self, w, &host); break;
    case F37_406E4C: m406e4c_toggle_5e356a(self, w, &host); break;
    case F37_406E93: m406e93_toggle_5e356e(self, w, &host); break;
    case F37_406EDA: m406eda_toggle_5e3572(self, w, &host); break;
    case F37_406F21: m406f21_toggle_5e3576(self, w, &host); break;
    case F37_406F68: m406f68_toggle_5e357a(self, w, &host); break;
    case F37_406FAF: m406faf_toggle_5e357e(self, w, &host); break;
    case F37_406FF6: m406ff6_toggle_5e3582(self, w, &host); break;
    case F37_40703D: m40703d_toggle_5e3586(self, w, &host); break;
    case F37_407084: m407084_toggle_5e358a(self, w, &host); break;
    case F37_4070CB: m4070cb_toggle_5e358e(self, w, &host); break;
    case F37_407112: m407112_toggle_5e3592(self, w, &host); break;
    case F37_407159: m407159_toggle_5e3596(self, w, &host); break;
    case F37_4071A0: m4071a0_toggle_5e359a(self, w, &host); break;
    case F37_4071E7: m4071e7_toggle_5e359e(self, w, &host); break;
    case F37_40722E: m40722e_toggle_5e35a2(self, w, &host); break;
    case F37_407275: m407275_toggle_5e35a6(self, w, &host); break;
    case F37_4072BC: m4072bc_toggle_5e35aa(self, w, &host); break;
    case F37_407303: m407303_toggle_5e35ae(self, w, &host); break;
    case F37_40734A: m40734a_toggle_5e35b2(self, w, &host); break;
    case F37_407391: m407391_toggle_5e35b6(self, w, &host); break;
    case F37_4073D8: m4073d8_toggle_5e35ba(self, w, &host); break;
    case F37_40741F: m40741f_toggle_5e35be(self, w, &host); break;
    case F37_407466: m407466_toggle_5e35c2(self, w, &host); break;
    case F37_4074AD: m4074ad_toggle_5e35c6(self, w, &host); break;
    case F37_4074F4: m4074f4_toggle_5e35ca(self, w, &host); break;
    case F37_40753B: m40753b_toggle_5e35ce(self, w, &host); break;
    case F37_407582: m407582_toggle_5e35d2(self, w, &host); break;
    case F37_4075C9: m4075c9_toggle_5e35d6(self, w, &host); break;
    case F37_407610: m407610_toggle_5e35da(self, w, &host); break;
    case F37_407657: m407657_toggle_5e35de(self, w, &host); break;
    case F37_40769E: m40769e_toggle_5e35e2(self, w, &host); break;
    case F37_4076E5: m4076e5_toggle_5e35e6(self, w, &host); break;
    case F37_40772C: m40772c_toggle_5e35ea(self, w, &host); break;
    case F37_407773: m407773_toggle_5e35ee(self, w, &host); break;
    case F37_4077BA: m4077ba_toggle_5e35f2(self, w, &host); break;
    case F37_407801: m407801_toggle_5e35f6(self, w, &host); break;
    case F37_407848: m407848_toggle_5e35fa(self, w, &host); break;
    case F37_40788F: m40788f_toggle_5e35fe(self, w, &host); break;
    case F37_4078D6: m4078d6_toggle_5e3602(self, w, &host); break;
    case F37_40791D: m40791d_toggle_5e3606(self, w, &host); break;
    case F37_407964: m407964_toggle_5e360a(self, w, &host); break;
    case F37_4079AB: m4079ab_toggle_5e360e(self, w, &host); break;
    case F37_4079F2: m4079f2_toggle_5e3612(self, w, &host); break;
    case F37_407A39: m407a39_toggle_5e3616(self, w, &host); break;
    case F37_407A80: m407a80_toggle_5e361a(self, w, &host); break;
    case F37_407AC7: m407ac7_toggle_5e361e(self, w, &host); break;
    /*CASES*/
    default: break;
    }
}
