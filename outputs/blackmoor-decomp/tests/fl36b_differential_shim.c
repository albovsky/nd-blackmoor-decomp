/* Flat entry points for tests/test_fl36b_differential.py: each wraps one FL-36 (batch b) port (src/original_methods_fl36b.c) so that
 * ctypes can drive it on the same fixture as the original bytes run under Unicorn. One generic host logs every call (callee, ecx,
 * stack arguments, the bytes behind a pointer argument when the test asked for them) and a per-callee script tells it what to return
 * and which dwords / words / byte strings to store through a pointer argument. Pointers into fixture regions are turned back into the
 * fake original addresses by the test, pointers to a local of the function stay host pointers. */
#include <stdint.h>
#include <string.h>

#include "original_methods_fl36b.h"

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
    uint8_t world[256];   /* the first bytes of the Fl36bWorld snapshot at the call */
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

enum { F36B_40104E = 1, F36B_4010B0, F36B_40148A, F36B_40167F, F36B_402952, F36B_4030AA, F36B_40339B, F36B_4033CB, F36B_404ABA, F36B_404B39, F36B_405B62, F36B_407BAA, F36B_407C97, F36B_407D90, F36B_408A1A, F36B_40906B, F36B_40909B, F36B_414527, F36B_41A4BE, F36B_41BE0A, F36B_4229FA, F36B_426510, F36B_43EB1A, F36B_43EB2A, F36B_43EF00, F36B_446F67, F36B_447E17, F36B_447E78, F36B_448853, F36B_448871, F36B_44AFA7, F36B_44D087, F36B_44E025, F36B_44E6E7, F36B_44E80B, F36B_44F4EA, F36B_454D0A, F36B_456506, F36B_456C87, F36B_457BC8, F36B_457EFA, F36B_4595E1, F36B_459A6A, F36B_45AE5E, F36B_45B36A, F36B_45D2B6, F36B_45DC0A, F36B_460F16, F36B_4617A7, F36B_463B00, F36B_463F9A, F36B_4657D7, F36B_465A87, F36B_465BD3, F36B_466E04, F36B_468DDA, F36B_46AB6F, F36B_46B50A, F36B_46DEA0, F36B_46E5EA, F36B_470A63, F36B_470CFA, F36B_472A4C, F36B_47575A, F36B_4778CF, F36B_47817A, F36B_47AC23, F36B_47D477, F36B_47D677, F36B_47DF47, F36B_47E1DA, F36B_481CA9, F36B_4820FA, F36B_483AC9, F36B_483EEA, F36B_4876DD, F36B_487A9A, F36B_487BCC, F36B_4889E0, F36B_488D5A, F36B_48A3CB, F36B_48A68A, F36B_48B720, F36B_48BA97, F36B_48BC9B, F36B_48CC60, F36B_48CFE7, F36B_48DEC7, F36B_48E20A, F36B_49026C, F36B_4904EA, F36B_494F14, F36B_49C45C, F36B_49C52A, F36B_4A1BC7, F36B_4A35C7, F36B_4A370A, F36B_4A5EDA, F36B_4A630A, F36B_4A64AE, F36B_4A7A19, F36B_4A7BFA, F36B_4A9B1B, F36B_4A9EA7, F36B_4AAEF5, F36B_4AB327, F36B_4AC488, F36B_4AC85A, F36B_4AFA0E, F36B_4AFCBA, F36B_4AFDFE, F36B_4B371C, F36B_4B3BDA, F36B_4B5838, F36B_4B5B0A, F36B_4B7041, F36B_4B7177, F36B_4B7DDD, F36B_4C0F60, F36B_4CC917, F36B_4D3B0A, F36B_4D3B8A, F36B_4D3D3D, F36B_4D4192, F36B_4D51F7, F36B_4D529B, F36B_4DBF0A, F36B_4DD3EB, F36B_4F003B };

/* Runs one port on `self` (this). `result` is the return value of the port (the eax of its last callee; for the ports that return this, 0 when they do and 1 when they do not). The
 * host context is the world when the batch has one (so that each logged call keeps a snapshot of it), else NULL. */
void shim_fl36b(int fn, uint8_t *self, const uintptr_t *a, void *w, int32_t *result)
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
    case F36B_40104E: *result = (int32_t)m40104e_get_constant(self); break;
    case F36B_4010B0: *result = (int32_t)m4010b0_get_constant(self); break;
    case F36B_40148A: *result = (int32_t)m40148a_get_constant(self); break;
    case F36B_40167F: *result = (int32_t)m40167f_get_constant(self); break;
    case F36B_402952: *result = (int32_t)m402952_get_constant(self); break;
    case F36B_4030AA: *result = (int32_t)m4030aa_get_constant(self); break;
    case F36B_40339B: *result = (int32_t)m40339b_get_constant(self); break;
    case F36B_4033CB: *result = (int32_t)m4033cb_get_constant(self); break;
    case F36B_404ABA: *result = (int32_t)m404aba_get_constant(self); break;
    case F36B_404B39: *result = (int32_t)m404b39_get_constant(self); break;
    case F36B_405B62: *result = (int32_t)m405b62_get_constant(self); break;
    case F36B_407BAA: *result = (int32_t)m407baa_get_constant(self); break;
    case F36B_407C97: *result = (int32_t)m407c97_get_constant(self); break;
    case F36B_407D90: *result = (int32_t)m407d90_get_constant(self); break;
    case F36B_408A1A: *result = (int32_t)m408a1a_get_constant(self); break;
    case F36B_40906B: *result = (int32_t)m40906b_get_constant(self); break;
    case F36B_40909B: *result = (int32_t)m40909b_get_constant(self); break;
    case F36B_414527: *result = (int32_t)m414527_get_constant(self); break;
    case F36B_41A4BE: m41a4be_empty_method(self); break;
    case F36B_41BE0A: *result = (int32_t)m41be0a_get_constant(self); break;
    case F36B_4229FA: *result = (int32_t)m4229fa_get_constant(self); break;
    case F36B_426510: *result = (int32_t)m426510_get_constant(self); break;
    case F36B_43EB1A: *result = (int32_t)m43eb1a_get_constant(self); break;
    case F36B_43EB2A: *result = (int32_t)m43eb2a_get_constant(self); break;
    case F36B_43EF00: *result = (int32_t)m43ef00_get_constant(self); break;
    case F36B_446F67: *result = (int32_t)m446f67_get_constant(self); break;
    case F36B_447E17: *result = (int32_t)m447e17_get_constant(self); break;
    case F36B_447E78: m447e78_empty_method(self); break;
    case F36B_448853: m448853_empty_method(self); break;
    case F36B_448871: m448871_empty_method(self); break;
    case F36B_44AFA7: *result = (int32_t)m44afa7_get_constant(self); break;
    case F36B_44D087: *result = (int32_t)m44d087_get_constant(self); break;
    case F36B_44E025: *result = (int32_t)m44e025_get_constant(self); break;
    case F36B_44E6E7: *result = (int32_t)m44e6e7_get_constant(self); break;
    case F36B_44E80B: m44e80b_empty_method(self); break;
    case F36B_44F4EA: *result = (int32_t)m44f4ea_get_constant(self); break;
    case F36B_454D0A: *result = (int32_t)m454d0a_get_constant(self); break;
    case F36B_456506: *result = (int32_t)m456506_get_constant(self); break;
    case F36B_456C87: *result = (int32_t)m456c87_get_constant(self); break;
    case F36B_457BC8: *result = (int32_t)m457bc8_get_constant(self); break;
    case F36B_457EFA: *result = (int32_t)m457efa_get_constant(self); break;
    case F36B_4595E1: *result = (int32_t)m4595e1_get_constant(self); break;
    case F36B_459A6A: *result = (int32_t)m459a6a_get_constant(self); break;
    case F36B_45AE5E: *result = (int32_t)m45ae5e_get_constant(self); break;
    case F36B_45B36A: *result = (int32_t)m45b36a_get_constant(self); break;
    case F36B_45D2B6: *result = (int32_t)m45d2b6_get_constant(self); break;
    case F36B_45DC0A: *result = (int32_t)m45dc0a_get_constant(self); break;
    case F36B_460F16: *result = (int32_t)m460f16_get_constant(self); break;
    case F36B_4617A7: *result = (int32_t)m4617a7_get_constant(self); break;
    case F36B_463B00: *result = (int32_t)m463b00_get_constant(self); break;
    case F36B_463F9A: *result = (int32_t)m463f9a_get_constant(self); break;
    case F36B_4657D7: *result = (int32_t)m4657d7_get_constant(self); break;
    case F36B_465A87: *result = (int32_t)m465a87_get_constant(self); break;
    case F36B_465BD3: m465bd3_empty_method(self); break;
    case F36B_466E04: *result = (int32_t)m466e04_get_constant(self); break;
    case F36B_468DDA: *result = (int32_t)m468dda_get_constant(self); break;
    case F36B_46AB6F: *result = (int32_t)m46ab6f_get_constant(self); break;
    case F36B_46B50A: *result = (int32_t)m46b50a_get_constant(self); break;
    case F36B_46DEA0: *result = (int32_t)m46dea0_get_constant(self); break;
    case F36B_46E5EA: *result = (int32_t)m46e5ea_get_constant(self); break;
    case F36B_470A63: *result = (int32_t)m470a63_get_constant(self); break;
    case F36B_470CFA: *result = (int32_t)m470cfa_get_constant(self); break;
    case F36B_472A4C: *result = (int32_t)m472a4c_get_constant(self); break;
    case F36B_47575A: *result = (int32_t)m47575a_get_constant(self); break;
    case F36B_4778CF: *result = (int32_t)m4778cf_get_constant(self); break;
    case F36B_47817A: *result = (int32_t)m47817a_get_constant(self); break;
    case F36B_47AC23: *result = (int32_t)m47ac23_get_constant(self); break;
    case F36B_47D477: *result = (int32_t)m47d477_get_constant(self); break;
    case F36B_47D677: m47d677_empty_method(self); break;
    case F36B_47DF47: *result = (int32_t)m47df47_get_constant(self); break;
    case F36B_47E1DA: *result = (int32_t)m47e1da_get_constant(self); break;
    case F36B_481CA9: *result = (int32_t)m481ca9_get_constant(self); break;
    case F36B_4820FA: *result = (int32_t)m4820fa_get_constant(self); break;
    case F36B_483AC9: *result = (int32_t)m483ac9_get_constant(self); break;
    case F36B_483EEA: *result = (int32_t)m483eea_get_constant(self); break;
    case F36B_4876DD: *result = (int32_t)m4876dd_get_constant(self); break;
    case F36B_487A9A: *result = (int32_t)m487a9a_get_constant(self); break;
    case F36B_487BCC: m487bcc_empty_method(self); break;
    case F36B_4889E0: *result = (int32_t)m4889e0_get_constant(self); break;
    case F36B_488D5A: *result = (int32_t)m488d5a_get_constant(self); break;
    case F36B_48A3CB: *result = (int32_t)m48a3cb_get_constant(self); break;
    case F36B_48A68A: *result = (int32_t)m48a68a_get_constant(self); break;
    case F36B_48B720: *result = (int32_t)m48b720_get_constant(self); break;
    case F36B_48BA97: *result = (int32_t)m48ba97_get_constant(self); break;
    case F36B_48BC9B: m48bc9b_empty_method(self); break;
    case F36B_48CC60: *result = (int32_t)m48cc60_get_constant(self); break;
    case F36B_48CFE7: *result = (int32_t)m48cfe7_get_constant(self); break;
    case F36B_48DEC7: *result = (int32_t)m48dec7_get_constant(self); break;
    case F36B_48E20A: *result = (int32_t)m48e20a_get_constant(self); break;
    case F36B_49026C: *result = (int32_t)m49026c_get_constant(self); break;
    case F36B_4904EA: *result = (int32_t)m4904ea_get_constant(self); break;
    case F36B_494F14: m494f14_empty_method(self); break;
    case F36B_49C45C: *result = (int32_t)m49c45c_get_constant(self); break;
    case F36B_49C52A: *result = (int32_t)m49c52a_get_constant(self); break;
    case F36B_4A1BC7: *result = (int32_t)m4a1bc7_get_constant(self); break;
    case F36B_4A35C7: *result = (int32_t)m4a35c7_get_constant(self); break;
    case F36B_4A370A: *result = (int32_t)m4a370a_get_constant(self); break;
    case F36B_4A5EDA: *result = (int32_t)m4a5eda_get_constant(self); break;
    case F36B_4A630A: *result = (int32_t)m4a630a_get_constant(self); break;
    case F36B_4A64AE: m4a64ae_empty_method(self); break;
    case F36B_4A7A19: *result = (int32_t)m4a7a19_get_constant(self); break;
    case F36B_4A7BFA: *result = (int32_t)m4a7bfa_get_constant(self); break;
    case F36B_4A9B1B: *result = (int32_t)m4a9b1b_get_constant(self); break;
    case F36B_4A9EA7: *result = (int32_t)m4a9ea7_get_constant(self); break;
    case F36B_4AAEF5: *result = (int32_t)m4aaef5_get_constant(self); break;
    case F36B_4AB327: *result = (int32_t)m4ab327_get_constant(self); break;
    case F36B_4AC488: *result = (int32_t)m4ac488_get_constant(self); break;
    case F36B_4AC85A: *result = (int32_t)m4ac85a_get_constant(self); break;
    case F36B_4AFA0E: *result = (int32_t)m4afa0e_get_constant(self); break;
    case F36B_4AFCBA: *result = (int32_t)m4afcba_get_constant(self); break;
    case F36B_4AFDFE: m4afdfe_empty_method(self); break;
    case F36B_4B371C: *result = (int32_t)m4b371c_get_constant(self); break;
    case F36B_4B3BDA: *result = (int32_t)m4b3bda_get_constant(self); break;
    case F36B_4B5838: *result = (int32_t)m4b5838_get_constant(self); break;
    case F36B_4B5B0A: *result = (int32_t)m4b5b0a_get_constant(self); break;
    case F36B_4B7041: *result = (int32_t)m4b7041_get_constant(self); break;
    case F36B_4B7177: *result = (int32_t)m4b7177_get_constant(self); break;
    case F36B_4B7DDD: *result = (int32_t)m4b7ddd_get_constant(self); break;
    case F36B_4C0F60: *result = (int32_t)m4c0f60_get_constant(self); break;
    case F36B_4CC917: *result = (int32_t)m4cc917_get_constant(self); break;
    case F36B_4D3B0A: *result = (int32_t)m4d3b0a_get_constant(self); break;
    case F36B_4D3B8A: m4d3b8a_empty_method(self); break;
    case F36B_4D3D3D: m4d3d3d_empty_method(self); break;
    case F36B_4D4192: *result = (int32_t)m4d4192_get_constant(self); break;
    case F36B_4D51F7: *result = (int32_t)m4d51f7_get_constant(self); break;
    case F36B_4D529B: m4d529b_empty_method(self); break;
    case F36B_4DBF0A: *result = (int32_t)m4dbf0a_get_constant(self); break;
    case F36B_4DD3EB: m4dd3eb_empty_method(self); break;
    case F36B_4F003B: m4f003b_empty_method(self); break;
    default: break;
    }
}
