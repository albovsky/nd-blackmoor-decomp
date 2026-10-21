/* Flat entry points for tests/test_fl36d_differential.py: each wraps one FL-36 (batch d) port (src/original_methods_fl36d.c) so that
 * ctypes can drive it on the same fixture as the original bytes run under Unicorn. One generic host logs every call (callee, ecx,
 * stack arguments, the bytes behind a pointer argument when the test asked for them) and a per-callee script tells it what to return
 * and which dwords / words / byte strings to store through a pointer argument. Pointers into fixture regions are turned back into the
 * fake original addresses by the test, pointers to a local of the function stay host pointers. */
#include <stdint.h>
#include <string.h>

#include "original_methods_fl36d.h"

#define WORLD_SIZE 0

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
    uint8_t world[256];   /* the first bytes of the Fl36dWorld snapshot at the call */
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

enum { F36D_401100 = 1, F36D_401190, F36D_401C40, F36D_403010, F36D_404A20, F36D_407B10, F36D_408980, F36D_40B2A0, F36D_414490, F36D_414C80, F36D_416E60, F36D_41A480, F36D_422FB0, F36D_425F70, F36D_4273F0, F36D_434880, F36D_438120, F36D_43EED0, F36D_43F1E0, F36D_446ED0, F36D_447CE0, F36D_447D80, F36D_4487F0, F36D_449770, F36D_449D60, F36D_44BE60, F36D_44C2B0, F36D_44E650, F36D_44F620, F36D_454C70, F36D_456BF0, F36D_457E60, F36D_4599D0, F36D_45B2D0, F36D_45DB70, F36D_461710, F36D_463F00, F36D_4659F0, F36D_4674B0, F36D_468D40, F36D_46B470, F36D_46E550, F36D_470C60, F36D_472ED0, F36D_4756C0, F36D_4780E0, F36D_47B1D0, F36D_47D3E0, F36D_47E140, F36D_482060, F36D_483E50, F36D_487A00, F36D_488CC0, F36D_48A5F0, F36D_48BA00, F36D_48CF50, F36D_48E170, F36D_490450, F36D_49C490, F36D_4A1B30, F36D_4A3670, F36D_4A6270, F36D_4A7B60, F36D_4A9E10, F36D_4AB290, F36D_4AC7C0, F36D_4AFC20, F36D_4B3B40, F36D_4B5A70, F36D_4B70E0, F36D_4B7ED0, F36D_4B9DD0, F36D_4BED40, F36D_4BF5D0, F36D_4C0F30, F36D_4CAE90, F36D_4CC880, F36D_4CCD40, F36D_4CF7B0, F36D_4D42B0, F36D_4D5230, F36D_4D5880, F36D_4D9D40, F36D_4DBCA0, F36D_4DD380, F36D_4DE120, F36D_4DE5C0, F36D_4E03E0, F36D_4E1C20, F36D_4E2CB0, F36D_4E7600, F36D_4E7A40, F36D_4EB840, F36D_4ED9E0, F36D_4EE950, F36D_4EFFD0, F36D_4F2610 };

/* Runs one port on `self` (this). `result` is the return value of the port (the eax of its last callee; for the ports that return this, 0 when they do and 1 when they do not). The
 * host context is the world when the batch has one (so that each logged call keeps a snapshot of it), else NULL. */
void shim_fl36d(int fn, uint8_t *self, const uintptr_t *a, void *w, int32_t *result)
{
    Fl18Host host;
    *result = 0;
    memset(&host, 0, sizeof host);
    host.context = NULL;
    host.call = host_call;
    host.resolve = shim_resolve;
    host.tick = host_tick;
    (void)a;
    (void)w;

    switch (fn) {
    case F36D_401100: *result = m401100_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_401190: *result = m401190_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_401C40: *result = m401c40_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_403010: *result = m403010_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_404A20: *result = m404a20_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_407B10: *result = m407b10_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_408980: *result = m408980_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_40B2A0: *result = m40b2a0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_414490: *result = m414490_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_414C80: *result = m414c80_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_416E60: *result = m416e60_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_41A480: *result = m41a480_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_422FB0: *result = m422fb0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_425F70: *result = m425f70_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4273F0: *result = m4273f0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_434880: *result = m434880_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_438120: *result = m438120_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_43EED0: *result = m43eed0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_43F1E0: *result = m43f1e0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_446ED0: *result = m446ed0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_447CE0: *result = m447ce0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_447D80: *result = m447d80_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4487F0: *result = m4487f0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_449770: *result = m449770_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_449D60: *result = m449d60_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_44BE60: *result = m44be60_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_44C2B0: *result = m44c2b0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_44E650: *result = m44e650_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_44F620: *result = m44f620_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_454C70: *result = m454c70_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_456BF0: *result = m456bf0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_457E60: *result = m457e60_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4599D0: *result = m4599d0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_45B2D0: *result = m45b2d0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_45DB70: *result = m45db70_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_461710: *result = m461710_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_463F00: *result = m463f00_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4659F0: *result = m4659f0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4674B0: *result = m4674b0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_468D40: *result = m468d40_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_46B470: *result = m46b470_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_46E550: *result = m46e550_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_470C60: *result = m470c60_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_472ED0: *result = m472ed0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4756C0: *result = m4756c0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4780E0: *result = m4780e0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_47B1D0: *result = m47b1d0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_47D3E0: *result = m47d3e0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_47E140: *result = m47e140_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_482060: *result = m482060_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_483E50: *result = m483e50_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_487A00: *result = m487a00_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_488CC0: *result = m488cc0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_48A5F0: *result = m48a5f0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_48BA00: *result = m48ba00_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_48CF50: *result = m48cf50_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_48E170: *result = m48e170_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_490450: *result = m490450_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_49C490: *result = m49c490_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4A1B30: *result = m4a1b30_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4A3670: *result = m4a3670_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4A6270: *result = m4a6270_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4A7B60: *result = m4a7b60_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4A9E10: *result = m4a9e10_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4AB290: *result = m4ab290_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4AC7C0: *result = m4ac7c0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4AFC20: *result = m4afc20_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4B3B40: *result = m4b3b40_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4B5A70: *result = m4b5a70_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4B70E0: *result = m4b70e0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4B7ED0: *result = m4b7ed0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4B9DD0: *result = m4b9dd0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4BED40: *result = m4bed40_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4BF5D0: *result = m4bf5d0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4C0F30: *result = m4c0f30_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4CAE90: *result = m4cae90_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4CC880: *result = m4cc880_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4CCD40: *result = m4ccd40_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4CF7B0: *result = m4cf7b0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4D42B0: *result = m4d42b0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4D5230: *result = m4d5230_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4D5880: *result = m4d5880_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4D9D40: *result = m4d9d40_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4DBCA0: *result = m4dbca0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4DD380: *result = m4dd380_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4DE120: *result = m4de120_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4DE5C0: *result = m4de5c0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4E03E0: *result = m4e03e0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4E1C20: *result = m4e1c20_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4E2CB0: *result = m4e2cb0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4E7600: *result = m4e7600_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4E7A40: *result = m4e7a40_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4EB840: *result = m4eb840_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4ED9E0: *result = m4ed9e0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4EE950: *result = m4ee950_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4EFFD0: *result = m4effd0_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    case F36D_4F2610: *result = m4f2610_scalar_deleting_dtor(self, (uint32_t)a[0], &host) == self ? 0 : 1; break;
    default: break;
    }
}
