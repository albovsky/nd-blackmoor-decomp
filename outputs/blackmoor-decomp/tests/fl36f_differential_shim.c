/* Flat entry points for tests/test_fl36f_differential.py: each wraps one FL-36 (batch f) port (src/original_methods_fl36f.c) so that
 * ctypes can drive it on the same fixture as the original bytes run under Unicorn. One generic host logs every call (callee, ecx,
 * stack arguments, the bytes behind a pointer argument when the test asked for them) and a per-callee script tells it what to return
 * and which dwords / words / byte strings to store through a pointer argument. Pointers into fixture regions are turned back into the
 * fake original addresses by the test, pointers to a local of the function stay host pointers. */
#include <stdint.h>
#include <string.h>

#include "original_methods_fl36f.h"

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
    uint8_t world[256];   /* the first bytes of the Fl36fWorld snapshot at the call */
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

enum { F36F_401420 = 1, F36F_403040, F36F_404A50, F36F_407B40, F36F_4089B0, F36F_4144C0, F36F_414537, F36F_41BDA0, F36F_43EAB0, F36F_446F00, F36F_447DB0, F36F_44AF40, F36F_44D020, F36F_44D097, F36F_44E680, F36F_44E6F7, F36F_454CA0, F36F_454D1A, F36F_456C20, F36F_456C97, F36F_457E90, F36F_457F0A, F36F_459A00, F36F_459A7A, F36F_45B300, F36F_45B37A, F36F_45DBA0, F36F_45DC1A, F36F_461740, F36F_4617B7, F36F_463F30, F36F_463FAA, F36F_465A20, F36F_465A97, F36F_468D70, F36F_468DEA, F36F_46B4A0, F36F_46B51A, F36F_46E580, F36F_470C90, F36F_470D0A, F36F_4756F0, F36F_47576A, F36F_478110, F36F_47818A, F36F_47D410, F36F_47D487, F36F_47E170, F36F_47E1EA, F36F_482090, F36F_48210A, F36F_483E80, F36F_483EFA, F36F_487A30, F36F_487AAA, F36F_488CF0, F36F_48A620, F36F_48A69A, F36F_48BA30, F36F_48BAA7, F36F_48CF80, F36F_48CFF7, F36F_48E1A0, F36F_48E21A, F36F_490480, F36F_49C4C0, F36F_4A1B60, F36F_4A1BD7, F36F_4A36A0, F36F_4A371A, F36F_4A62A0, F36F_4A631A, F36F_4A7B90, F36F_4A7C0A, F36F_4A9E40, F36F_4A9EB7, F36F_4AB2C0, F36F_4AB337, F36F_4AC7F0, F36F_4AC86A, F36F_4AFC50, F36F_4AFCCA, F36F_4B3B70, F36F_4B3BEA, F36F_4B5AA0, F36F_4B5B1A, F36F_4B7110, F36F_4B7187, F36F_4CC8B0, F36F_4D3AA0, F36F_4D3B1A, F36F_4DBEA0, F36F_4DBF1A, F36F_4DE150, F36F_4E7630 };

/* Runs one port on `self` (this). `result` is the return value of the port (the eax of its last callee; for the ports that return this, 0 when they do and 1 when they do not). The
 * host context is the world when the batch has one (so that each logged call keeps a snapshot of it), else NULL. */
void shim_fl36f(int fn, uint8_t *self, const uintptr_t *a, void *w, int32_t *result)
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
    (void)self;

    switch (fn) {
    case F36F_401420: *result = (int32_t)m401420_new_and_construct(&host); break;
    case F36F_403040: *result = (int32_t)m403040_new_and_construct(&host); break;
    case F36F_404A50: *result = (int32_t)m404a50_new_and_construct(&host); break;
    case F36F_407B40: *result = (int32_t)m407b40_new_and_construct(&host); break;
    case F36F_4089B0: *result = (int32_t)m4089b0_new_and_construct(&host); break;
    case F36F_4144C0: *result = (int32_t)m4144c0_new_and_construct(&host); break;
    case F36F_414537: *result = m414537_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_41BDA0: *result = (int32_t)m41bda0_new_and_construct(&host); break;
    case F36F_43EAB0: *result = (int32_t)m43eab0_new_and_construct(&host); break;
    case F36F_446F00: *result = (int32_t)m446f00_new_and_construct(&host); break;
    case F36F_447DB0: *result = (int32_t)m447db0_new_and_construct(&host); break;
    case F36F_44AF40: *result = (int32_t)m44af40_new_and_construct(&host); break;
    case F36F_44D020: *result = (int32_t)m44d020_new_and_construct(&host); break;
    case F36F_44D097: *result = m44d097_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_44E680: *result = (int32_t)m44e680_new_and_construct(&host); break;
    case F36F_44E6F7: *result = m44e6f7_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_454CA0: *result = (int32_t)m454ca0_new_and_construct(&host); break;
    case F36F_454D1A: *result = m454d1a_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_456C20: *result = (int32_t)m456c20_new_and_construct(&host); break;
    case F36F_456C97: *result = m456c97_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_457E90: *result = (int32_t)m457e90_new_and_construct(&host); break;
    case F36F_457F0A: *result = m457f0a_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_459A00: *result = (int32_t)m459a00_new_and_construct(&host); break;
    case F36F_459A7A: *result = m459a7a_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_45B300: *result = (int32_t)m45b300_new_and_construct(&host); break;
    case F36F_45B37A: *result = m45b37a_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_45DBA0: *result = (int32_t)m45dba0_new_and_construct(&host); break;
    case F36F_45DC1A: *result = m45dc1a_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_461740: *result = (int32_t)m461740_new_and_construct(&host); break;
    case F36F_4617B7: *result = m4617b7_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_463F30: *result = (int32_t)m463f30_new_and_construct(&host); break;
    case F36F_463FAA: *result = m463faa_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_465A20: *result = (int32_t)m465a20_new_and_construct(&host); break;
    case F36F_465A97: *result = m465a97_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_468D70: *result = (int32_t)m468d70_new_and_construct(&host); break;
    case F36F_468DEA: *result = m468dea_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_46B4A0: *result = (int32_t)m46b4a0_new_and_construct(&host); break;
    case F36F_46B51A: *result = m46b51a_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_46E580: *result = (int32_t)m46e580_new_and_construct(&host); break;
    case F36F_470C90: *result = (int32_t)m470c90_new_and_construct(&host); break;
    case F36F_470D0A: *result = m470d0a_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_4756F0: *result = (int32_t)m4756f0_new_and_construct(&host); break;
    case F36F_47576A: *result = m47576a_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_478110: *result = (int32_t)m478110_new_and_construct(&host); break;
    case F36F_47818A: *result = m47818a_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_47D410: *result = (int32_t)m47d410_new_and_construct(&host); break;
    case F36F_47D487: *result = m47d487_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_47E170: *result = (int32_t)m47e170_new_and_construct(&host); break;
    case F36F_47E1EA: *result = m47e1ea_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_482090: *result = (int32_t)m482090_new_and_construct(&host); break;
    case F36F_48210A: *result = m48210a_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_483E80: *result = (int32_t)m483e80_new_and_construct(&host); break;
    case F36F_483EFA: *result = m483efa_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_487A30: *result = (int32_t)m487a30_new_and_construct(&host); break;
    case F36F_487AAA: *result = m487aaa_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_488CF0: *result = (int32_t)m488cf0_new_and_construct(&host); break;
    case F36F_48A620: *result = (int32_t)m48a620_new_and_construct(&host); break;
    case F36F_48A69A: *result = m48a69a_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_48BA30: *result = (int32_t)m48ba30_new_and_construct(&host); break;
    case F36F_48BAA7: *result = m48baa7_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_48CF80: *result = (int32_t)m48cf80_new_and_construct(&host); break;
    case F36F_48CFF7: *result = m48cff7_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_48E1A0: *result = (int32_t)m48e1a0_new_and_construct(&host); break;
    case F36F_48E21A: *result = m48e21a_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_490480: *result = (int32_t)m490480_new_and_construct(&host); break;
    case F36F_49C4C0: *result = (int32_t)m49c4c0_new_and_construct(&host); break;
    case F36F_4A1B60: *result = (int32_t)m4a1b60_new_and_construct(&host); break;
    case F36F_4A1BD7: *result = m4a1bd7_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_4A36A0: *result = (int32_t)m4a36a0_new_and_construct(&host); break;
    case F36F_4A371A: *result = m4a371a_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_4A62A0: *result = (int32_t)m4a62a0_new_and_construct(&host); break;
    case F36F_4A631A: *result = m4a631a_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_4A7B90: *result = (int32_t)m4a7b90_new_and_construct(&host); break;
    case F36F_4A7C0A: *result = m4a7c0a_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_4A9E40: *result = (int32_t)m4a9e40_new_and_construct(&host); break;
    case F36F_4A9EB7: *result = m4a9eb7_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_4AB2C0: *result = (int32_t)m4ab2c0_new_and_construct(&host); break;
    case F36F_4AB337: *result = m4ab337_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_4AC7F0: *result = (int32_t)m4ac7f0_new_and_construct(&host); break;
    case F36F_4AC86A: *result = m4ac86a_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_4AFC50: *result = (int32_t)m4afc50_new_and_construct(&host); break;
    case F36F_4AFCCA: *result = m4afcca_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_4B3B70: *result = (int32_t)m4b3b70_new_and_construct(&host); break;
    case F36F_4B3BEA: *result = m4b3bea_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_4B5AA0: *result = (int32_t)m4b5aa0_new_and_construct(&host); break;
    case F36F_4B5B1A: *result = m4b5b1a_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_4B7110: *result = (int32_t)m4b7110_new_and_construct(&host); break;
    case F36F_4B7187: *result = m4b7187_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_4CC8B0: *result = (int32_t)m4cc8b0_new_and_construct(&host); break;
    case F36F_4D3AA0: *result = (int32_t)m4d3aa0_new_and_construct(&host); break;
    case F36F_4D3B1A: *result = m4d3b1a_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_4DBEA0: *result = (int32_t)m4dbea0_new_and_construct(&host); break;
    case F36F_4DBF1A: *result = m4dbf1a_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_4DE150: *result = m4de150_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36F_4E7630: *result = m4e7630_construct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    default: break;
    }
}
