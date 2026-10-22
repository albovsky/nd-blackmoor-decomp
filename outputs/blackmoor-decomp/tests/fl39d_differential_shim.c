/* Flat entry points for tests/test_fl39d_differential.py: each wraps one FL-39 (batch d) port (src/original_methods_fl39d.c) so that
 * ctypes can drive it on the same fixture as the original bytes run under Unicorn. One generic host logs every call (callee, ecx,
 * stack arguments, the bytes behind a pointer argument when the test asked for them) and a per-callee script tells it what to return
 * and which dwords / words / byte strings to store through a pointer argument. Pointers into fixture regions are turned back into the
 * fake original addresses by the test, pointers to a local of the function stay host pointers. */
#include <stdint.h>
#include <string.h>

#include "original_methods_fl39d.h"

#define WORLD_SIZE sizeof(Fl39dWorld)

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
    uint8_t world[256];   /* the first bytes of the Fl39dWorld snapshot at the call */
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
size_t shim_world_size(void) { return WORLD_SIZE; }

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
    if (context != NULL) memcpy(c->world, context, WORLD_SIZE < sizeof c->world ? WORLD_SIZE : sizeof c->world);
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

/* GetTickCount (import 0x52a23c) is an ordered event of the call log (id = its import slot, no arguments); its answers come from the script of that id */
static uint32_t host_tick(void *context)
{
    return host_call(context, 0x52a23c, 0, NULL, 0);
}

enum { F39D_48217A = 1, F39D_4821AB, F39D_487DCF, F39D_488E54, F39D_48A70A, F39D_48AA66, F39D_48E28A, F39D_4911CA, F39D_491422, F39D_491885, F39D_4921A1, F39D_493A54, F39D_493AF0, F39D_493B2E, F39D_493C34, F39D_495A5B, F39D_49C46C, F39D_49C68A, F39D_4A1D14, F39D_4A1E93, F39D_4A1FD1, F39D_4A378A, F39D_4A39C4, F39D_4A3BEB, F39D_4A63DC, F39D_4A7994, F39D_4A7C7A, F39D_4A7D1D, F39D_4A7DF9, F39D_4A8007, F39D_4A9F63, F39D_4AB706, F39D_4ACCAB, F39D_4AD1E5, F39D_4B3C5A, F39D_4B3F98, F39D_4B450F, F39D_4B72A9, F39D_4B9E3B, F39D_4BA07F, F39D_4BA262, F39D_4BA486, F39D_4BE2C6, F39D_4BED70, F39D_4BF63B, F39D_4BF8A7, F39D_4C139A, F39D_4C4B12, F39D_4C4C2B, F39D_4C9428, F39D_4C9B66, F39D_4C9C10, F39D_4CA92E, F39D_4CAEC0, F39D_4CAFF5, F39D_4CCA0E, F39D_4CCC50, F39D_4CD645, F39D_4D00D2, F39D_4D3723, F39D_4D3B95, F39D_4D3C9A, F39D_4D3CBA, F39D_4D3CED, F39D_4D4043, F39D_4D4645, F39D_4D47B0, F39D_4D56E2, F39D_4D57E8, F39D_4D5834, F39D_4D6787, F39D_4D794D, F39D_4D79C7, F39D_4D8F8D, F39D_4D912A, F39D_4D920C, F39D_4D9D70, F39D_4DB066, F39D_4DB780, F39D_4DB817, F39D_4DBC77, F39D_4DBFBF, F39D_4DD28D, F39D_4DD409, F39D_4DE009, F39D_4DE0CF, F39D_4DE4F9, F39D_4DE6D7, F39D_4DE6FC, F39D_4E01B3, F39D_4E023B, F39D_4E0377, F39D_4E0619, F39D_4E06C0, F39D_4E119B, F39D_4E1C9F, F39D_4E2913, F39D_4E29B7, F39D_4E2DD3, F39D_4E35E8, F39D_4E364A, F39D_4E3691, F39D_4E36FC, F39D_4E3772, F39D_4E3A64, F39D_4E40A6, F39D_4E49E2, F39D_4E7970, F39D_4E79CA, F39D_4E7C72, F39D_4E7DAD, F39D_4E8D72, F39D_4E94A9, F39D_4EA1CB, F39D_4EA361, F39D_4EB5F2, F39D_4EB9C8, F39D_4EDA10, F39D_4EDAE5, F39D_4EE517, F39D_4EE572, F39D_4EE598, F39D_4EE5F2, F39D_4EE9BB, F39D_4EEAD0, F39D_4EF3ED, F39D_4EF4F0, F39D_4F67BE, F39D_4F6810, F39D_4F8A17, F39D_4FAFC7, F39D_4FB018, F39D_4FB071, F39D_4FB086, F39D_4FB1C6, F39D_4FB737, F39D_4FBA86, F39D_4FBD7E, F39D_4FCE90 };

/* Runs one port on `self` (this); `a` holds the stack arguments of the function as 64-bit values. `result` is the return value of the port (the eax of its last callee;
 * for the ports that return this, 0 when they do and 1 when they do not). The host context is the world when the batch has one (so that each logged call keeps a snapshot of it). */
void shim_fl39d(int fn, uint8_t *self, const uintptr_t *a, void *w, int32_t *result)
{
    Fl18Host host;
    *result = 0;
    memset(&host, 0, sizeof host);
    host.context = w;
    host.call = host_call;
    host.resolve = shim_resolve;
    host.tick = host_tick;
    (void)a;
    (void)w;
    (void)self;

    switch (fn) {
    case F39D_48217A: *result = m48217a_lifted(self, &host) == self ? 0 : 1; break;
    case F39D_4821AB: *result = (int32_t)m4821ab_lifted(self, &host); break;
    case F39D_487DCF: *result = (int32_t)m487dcf_lifted(self, (uint32_t)a[0], (uint32_t)a[1], &host, (Fl39dWorld *)w); break;
    case F39D_488E54: *result = (int32_t)m488e54_lifted(self, &host); break;
    case F39D_48A70A: *result = (int32_t)m48a70a_lifted(self, &host); break;
    case F39D_48AA66: *result = (int32_t)m48aa66_lifted(self, (uint32_t)a[0], (uint32_t)a[1], &host, (Fl39dWorld *)w); break;
    case F39D_48E28A: *result = m48e28a_lifted(self, &host) == self ? 0 : 1; break;
    case F39D_4911CA: *result = (int32_t)m4911ca_lifted(self, &host); break;
    case F39D_491422: *result = (int32_t)m491422_lifted(self, &host); break;
    case F39D_491885: *result = (int32_t)m491885_lifted(self, &host); break;
    case F39D_4921A1: *result = m4921a1_lifted(self, &host, (Fl39dWorld *)w) == self ? 0 : 1; break;
    case F39D_493A54: *result = (int32_t)m493a54_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_493AF0: *result = (int32_t)m493af0_lifted(self, &host); break;
    case F39D_493B2E: *result = (int32_t)m493b2e_lifted(self, &host); break;
    case F39D_493C34: *result = (int32_t)m493c34_lifted(self, &host); break;
    case F39D_495A5B: *result = (int32_t)m495a5b_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_49C46C: *result = (int32_t)m49c46c_lifted(&host); break;
    case F39D_49C68A: *result = (int32_t)m49c68a_lifted(self, &host); break;
    case F39D_4A1D14: *result = (int32_t)m4a1d14_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_4A1E93: *result = (int32_t)m4a1e93_lifted(self, (uint32_t)a[0], &host, (Fl39dWorld *)w); break;
    case F39D_4A1FD1: *result = m4a1fd1_lifted(self, &host, (Fl39dWorld *)w) == self ? 0 : 1; break;
    case F39D_4A378A: *result = (int32_t)m4a378a_lifted(self, &host); break;
    case F39D_4A39C4: *result = m4a39c4_lifted(self, &host) == self ? 0 : 1; break;
    case F39D_4A3BEB: *result = m4a3beb_lifted(self, &host, (Fl39dWorld *)w) == self ? 0 : 1; break;
    case F39D_4A63DC: *result = (int32_t)m4a63dc_lifted(self, &host); break;
    case F39D_4A7994: *result = (int32_t)m4a7994_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_4A7C7A: *result = m4a7c7a_lifted(self, &host) == self ? 0 : 1; break;
    case F39D_4A7D1D: *result = (int32_t)m4a7d1d_lifted(self, &host); break;
    case F39D_4A7DF9: *result = m4a7df9_lifted(self, &host) == self ? 0 : 1; break;
    case F39D_4A8007: *result = m4a8007_lifted(self, &host, (Fl39dWorld *)w) == self ? 0 : 1; break;
    case F39D_4A9F63: *result = (int32_t)m4a9f63_lifted(self, &host); break;
    case F39D_4AB706: *result = (int32_t)m4ab706_lifted(self, (uint32_t)a[0], (uint32_t)a[1], &host, (Fl39dWorld *)w); break;
    case F39D_4ACCAB: *result = (int32_t)m4accab_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_4AD1E5: *result = (int32_t)m4ad1e5_lifted(self, (uint32_t)a[0], &host, (Fl39dWorld *)w); break;
    case F39D_4B3C5A: *result = m4b3c5a_lifted(self, &host) == self ? 0 : 1; break;
    case F39D_4B3F98: *result = (int32_t)m4b3f98_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_4B450F: *result = m4b450f_lifted(self, (uint32_t)a[0], &host, (Fl39dWorld *)w) == self ? 0 : 1; break;
    case F39D_4B72A9: *result = (int32_t)m4b72a9_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_4B9E3B: *result = (int32_t)m4b9e3b_lifted(self, &host); break;
    case F39D_4BA07F: *result = (int32_t)m4ba07f_lifted(self, &host); break;
    case F39D_4BA262: *result = (int32_t)m4ba262_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_4BA486: *result = (int32_t)m4ba486_lifted(self, (uint32_t)a[0], &host, (Fl39dWorld *)w); break;
    case F39D_4BE2C6: *result = (int32_t)m4be2c6_lifted(self, (uint8_t *)a[0], &host); break;
    case F39D_4BED70: *result = m4bed70_lifted(self, &host) == self ? 0 : 1; break;
    case F39D_4BF63B: *result = m4bf63b_lifted(self, &host, (Fl39dWorld *)w) == self ? 0 : 1; break;
    case F39D_4BF8A7: *result = (int32_t)m4bf8a7_lifted(self, &host); break;
    case F39D_4C139A: *result = (int32_t)m4c139a_lifted(self, &host); break;
    case F39D_4C4B12: *result = (int32_t)m4c4b12_lifted(self, (uint8_t *)a[0], (uint32_t)a[1], (uint8_t *)a[2], &host, (Fl39dWorld *)w); break;
    case F39D_4C4C2B: *result = (int32_t)m4c4c2b_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_4C9428: *result = (int32_t)m4c9428_lifted(self, &host); break;
    case F39D_4C9B66: *result = (int32_t)m4c9b66_lifted(self, &host); break;
    case F39D_4C9C10: *result = (int32_t)m4c9c10_lifted(self, &host); break;
    case F39D_4CA92E: *result = (int32_t)m4ca92e_lifted(self, (uint8_t *)a[0], &host); break;
    case F39D_4CAEC0: *result = (int32_t)m4caec0_lifted(self, &host); break;
    case F39D_4CAFF5: *result = (int32_t)m4caff5_lifted(self, (uint8_t *)a[0], (uint8_t *)a[1], (uint8_t *)a[2], &host, (Fl39dWorld *)w); break;
    case F39D_4CCA0E: *result = (int32_t)m4cca0e_lifted(self, (uint8_t *)a[0], (uint32_t)a[1], (uint32_t)a[2], (uint32_t)a[3], &host); break;
    case F39D_4CCC50: *result = (int32_t)m4ccc50_lifted(self, (uint32_t)a[0], (uint32_t)a[1], (uint8_t *)a[2], &host); break;
    case F39D_4CD645: *result = (int32_t)m4cd645_lifted(self, (uint8_t *)a[0], (uint8_t *)a[1], (uint8_t *)a[2], &host, (Fl39dWorld *)w); break;
    case F39D_4D00D2: *result = (int32_t)m4d00d2_lifted(&host, (Fl39dWorld *)w); break;
    case F39D_4D3723: *result = (int32_t)m4d3723_lifted(&host); break;
    case F39D_4D3B95: *result = (int32_t)m4d3b95_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_4D3C9A: *result = (int32_t)m4d3c9a_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_4D3CBA: *result = m4d3cba_lifted(self, &host, (Fl39dWorld *)w) == self ? 0 : 1; break;
    case F39D_4D3CED: *result = m4d3ced_lifted(self, &host, (Fl39dWorld *)w) == self ? 0 : 1; break;
    case F39D_4D4043: *result = (int32_t)m4d4043_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_4D4645: *result = (int32_t)m4d4645_lifted(&host, (Fl39dWorld *)w); break;
    case F39D_4D47B0: *result = (int32_t)m4d47b0_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_4D56E2: *result = (int32_t)m4d56e2_lifted(self, (uint8_t *)a[0], (uint8_t *)a[1], (uint8_t *)a[2], &host); break;
    case F39D_4D57E8: *result = (int32_t)m4d57e8_lifted(self, (uint8_t *)a[0], (uint8_t *)a[1], &host); break;
    case F39D_4D5834: *result = (int32_t)m4d5834_lifted(self, (uint8_t *)a[0], (uint8_t *)a[1], &host); break;
    case F39D_4D6787: *result = m4d6787_lifted(self, &host, (Fl39dWorld *)w) == self ? 0 : 1; break;
    case F39D_4D794D: *result = (int32_t)m4d794d_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_4D79C7: *result = (int32_t)m4d79c7_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_4D8F8D: *result = (int32_t)m4d8f8d_lifted(self, (uint32_t)a[0], &host); break;
    case F39D_4D912A: *result = (int32_t)m4d912a_lifted(self, &host); break;
    case F39D_4D920C: *result = (int32_t)m4d920c_lifted(self, &host); break;
    case F39D_4D9D70: *result = (int32_t)m4d9d70_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_4DB066: *result = m4db066_lifted(self, (uint32_t)a[0], (uint32_t)a[1], &host) == self ? 0 : 1; break;
    case F39D_4DB780: *result = (int32_t)m4db780_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_4DB817: *result = (int32_t)m4db817_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_4DBC77: *result = m4dbc77_lifted(self, &host) == self ? 0 : 1; break;
    case F39D_4DBFBF: *result = m4dbfbf_lifted(self, &host) == self ? 0 : 1; break;
    case F39D_4DD28D: *result = (int32_t)m4dd28d_lifted(self, &host); break;
    case F39D_4DD409: *result = (int32_t)m4dd409_lifted(self, (uint32_t)a[0], (uint32_t)a[1], &host, (Fl39dWorld *)w); break;
    case F39D_4DE009: *result = (int32_t)m4de009_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_4DE0CF: *result = (int32_t)m4de0cf_lifted(&host, (Fl39dWorld *)w); break;
    case F39D_4DE4F9: *result = (int32_t)m4de4f9_lifted(self, &host); break;
    case F39D_4DE6D7: *result = m4de6d7_lifted(self, &host) == self ? 0 : 1; break;
    case F39D_4DE6FC: *result = (int32_t)m4de6fc_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_4E01B3: *result = (int32_t)m4e01b3_lifted(&host, (Fl39dWorld *)w); break;
    case F39D_4E023B: *result = (int32_t)m4e023b_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_4E0377: *result = (int32_t)m4e0377_lifted(&host, (Fl39dWorld *)w); break;
    case F39D_4E0619: *result = (int32_t)m4e0619_lifted(self, &host); break;
    case F39D_4E06C0: *result = (int32_t)m4e06c0_lifted(self, &host); break;
    case F39D_4E119B: *result = (int32_t)m4e119b_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_4E1C9F: *result = m4e1c9f_lifted(self, &host) == self ? 0 : 1; break;
    case F39D_4E2913: *result = (int32_t)m4e2913_lifted(self, &host); break;
    case F39D_4E29B7: *result = m4e29b7_lifted(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F39D_4E2DD3: *result = m4e2dd3_lifted(self, &host) == self ? 0 : 1; break;
    case F39D_4E35E8: *result = (int32_t)m4e35e8_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_4E364A: *result = (int32_t)m4e364a_lifted(self, &host); break;
    case F39D_4E3691: *result = (int32_t)m4e3691_lifted(self, &host); break;
    case F39D_4E36FC: *result = (int32_t)m4e36fc_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_4E3772: *result = (int32_t)m4e3772_lifted(self, &host); break;
    case F39D_4E3A64: *result = m4e3a64_lifted(self, &host, (Fl39dWorld *)w) == self ? 0 : 1; break;
    case F39D_4E40A6: *result = m4e40a6_lifted(self, (uint32_t)a[0], (uint32_t)a[1], (uint32_t)a[2], (uint32_t)a[3], (uint32_t)a[4], (uint8_t *)a[5], (uint32_t)a[6], &host) == self ? 0 : 1; break;
    case F39D_4E49E2: *result = (int32_t)m4e49e2_lifted(self, &host); break;
    case F39D_4E7970: *result = (int32_t)m4e7970_lifted(self, &host); break;
    case F39D_4E79CA: *result = (int32_t)m4e79ca_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_4E7C72: *result = (int32_t)m4e7c72_lifted(self, &host); break;
    case F39D_4E7DAD: *result = (int32_t)m4e7dad_lifted(self, (uint8_t *)a[0], &host); break;
    case F39D_4E8D72: *result = m4e8d72_lifted(self, &host) == self ? 0 : 1; break;
    case F39D_4E94A9: *result = (int32_t)m4e94a9_lifted(self, &host); break;
    case F39D_4EA1CB: *result = (int32_t)m4ea1cb_lifted(self, (uint32_t)a[0], &host, (Fl39dWorld *)w); break;
    case F39D_4EA361: *result = m4ea361_lifted(self, &host, (Fl39dWorld *)w) == self ? 0 : 1; break;
    case F39D_4EB5F2: *result = m4eb5f2_lifted(self, &host, (Fl39dWorld *)w) == self ? 0 : 1; break;
    case F39D_4EB9C8: *result = (int32_t)m4eb9c8_lifted(self, &host); break;
    case F39D_4EDA10: *result = m4eda10_lifted(self, &host) == self ? 0 : 1; break;
    case F39D_4EDAE5: *result = (int32_t)m4edae5_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_4EE517: *result = (int32_t)m4ee517_lifted(self, &host); break;
    case F39D_4EE572: *result = (int32_t)m4ee572_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_4EE598: *result = (int32_t)m4ee598_lifted(self, &host); break;
    case F39D_4EE5F2: *result = (int32_t)m4ee5f2_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_4EE9BB: *result = (int32_t)m4ee9bb_lifted(self, &host); break;
    case F39D_4EEAD0: *result = (int32_t)m4eead0_lifted(self, &host); break;
    case F39D_4EF3ED: *result = (int32_t)m4ef3ed_lifted(self, (uint32_t)a[0], &host, (Fl39dWorld *)w); break;
    case F39D_4EF4F0: *result = m4ef4f0_lifted(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F39D_4F67BE: *result = (int32_t)m4f67be_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_4F6810: *result = (int32_t)m4f6810_lifted(self, &host); break;
    case F39D_4F8A17: *result = (int32_t)m4f8a17_lifted(self, &host); break;
    case F39D_4FAFC7: *result = (int32_t)m4fafc7_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_4FB018: *result = (int32_t)m4fb018_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_4FB071: *result = (int32_t)m4fb071_lifted(self, &host); break;
    case F39D_4FB086: *result = (int32_t)m4fb086_lifted(self, &host); break;
    case F39D_4FB1C6: *result = (int32_t)m4fb1c6_lifted(self, (uint32_t)a[0], &host, (Fl39dWorld *)w); break;
    case F39D_4FB737: *result = (int32_t)m4fb737_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_4FBA86: *result = (int32_t)m4fba86_lifted(self, (uint8_t *)a[0], &host); break;
    case F39D_4FBD7E: *result = (int32_t)m4fbd7e_lifted(self, &host, (Fl39dWorld *)w); break;
    case F39D_4FCE90: *result = m4fce90_lifted(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    default: break;
    }
}
