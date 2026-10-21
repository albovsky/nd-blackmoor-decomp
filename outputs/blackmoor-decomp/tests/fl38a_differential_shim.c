/* Flat entry points for tests/test_fl38a_differential.py: each wraps one FL-38 (batch a) port (src/original_methods_fl38a.c) so that
 * ctypes can drive it on the same fixture as the original bytes run under Unicorn. One generic host logs every call (callee, ecx,
 * stack arguments, the bytes behind a pointer argument when the test asked for them) and a per-callee script tells it what to return
 * and which dwords / words / byte strings to store through a pointer argument. Pointers into fixture regions are turned back into the
 * fake original addresses by the test, pointers to a local of the function stay host pointers. */
#include <stdint.h>
#include <string.h>

#include "original_methods_fl38a.h"

#define WORLD_SIZE sizeof(Fl38aWorld)

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
    uint8_t world[256];   /* the first bytes of the Fl38aWorld snapshot at the call */
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

enum { F38A_414C6D = 1, F38A_447CC4, F38A_4487DE, F38A_44BE44, F38A_4542B5, F38A_4542F2, F38A_45441D, F38A_454DE6, F38A_454E39, F38A_456D2E, F38A_456D77, F38A_457FC2, F38A_458045, F38A_459B87, F38A_45DD4D, F38A_464076, F38A_4640C9, F38A_465B9F, F38A_467651, F38A_468F19, F38A_468F68, F38A_46B707, F38A_46E7A6, F38A_46E7EF, F38A_470DDC, F38A_47823E, F38A_478287 };

/* Runs one port on `self` (this). `result` is the return value of the port (the eax of its last callee, the constant, or for the `guard` ports 0 when they return self and 1 when they do not). The
 * host context is the world (so that each logged call keeps a snapshot of it). */
void shim_fl38a(int fn, uint8_t *self, const uintptr_t *a, void *w, int32_t *result)
{
    Fl18Host host;
    *result = 0;
    memset(&host, 0, sizeof host);
    host.context = w;
    host.call = host_call;
    host.resolve = shim_resolve;
    host.tick = host_tick;
    (void)a;

    switch (fn) {
    case F38A_414C6D: *result = (int32_t)m414c6d_get_constant(self); break;
    case F38A_447CC4: *result = (int32_t)m447cc4_get_constant(self); break;
    case F38A_4487DE: *result = (int32_t)m4487de_get_constant(self); break;
    case F38A_44BE44: *result = (int32_t)m44be44_get_constant(self); break;
    case F38A_4542B5: *result = (int32_t)m4542b5_check_no_sound_call(self, &host); break;
    case F38A_4542F2: *result = (int32_t)m4542f2_check_no_sound_call(self, &host); break;
    case F38A_45441D: *result = (int32_t)m45441d_check_no_sound_call(self, &host); break;
    case F38A_454DE6: *result = (int32_t)m454de6_release_surface_clear_call_tail(self, &host); break;
    case F38A_454E39: *result = m454e39_guard_set_table_flag(self, (const Fl38aWorld *)w) == self ? 0 : 1; break;
    case F38A_456D2E: *result = (int32_t)m456d2e_release_surface_call_tail(self, &host); break;
    case F38A_456D77: *result = m456d77_guard_set_table_flag(self, (const Fl38aWorld *)w) == self ? 0 : 1; break;
    case F38A_457FC2: *result = (int32_t)m457fc2_release_surface_clear_call_tail(self, &host); break;
    case F38A_458045: *result = m458045_guard_set_table_flag(self, (const Fl38aWorld *)w) == self ? 0 : 1; break;
    case F38A_459B87: *result = (int32_t)m459b87_release_surface_call_tail(self, &host); break;
    case F38A_45DD4D: *result = (int32_t)m45dd4d_release_surface_call_tail(self, &host); break;
    case F38A_464076: *result = (int32_t)m464076_release_surface_clear_call_tail(self, &host); break;
    case F38A_4640C9: *result = m4640c9_guard_set_table_flag(self, (const Fl38aWorld *)w) == self ? 0 : 1; break;
    case F38A_465B9F: *result = m465b9f_guard_set_table_flag(self, (const Fl38aWorld *)w) == self ? 0 : 1; break;
    case F38A_467651: *result = m467651_guard_set_table_flag(self, (const Fl38aWorld *)w) == self ? 0 : 1; break;
    case F38A_468F19: *result = (int32_t)m468f19_release_surface_call_tail(self, &host); break;
    case F38A_468F68: *result = m468f68_guard_set_table_flag(self, (const Fl38aWorld *)w) == self ? 0 : 1; break;
    case F38A_46B707: *result = m46b707_guard_set_table_flag(self, (const Fl38aWorld *)w) == self ? 0 : 1; break;
    case F38A_46E7A6: *result = (int32_t)m46e7a6_release_surface_call_tail(self, &host); break;
    case F38A_46E7EF: *result = m46e7ef_guard_set_table_flag(self, (const Fl38aWorld *)w) == self ? 0 : 1; break;
    case F38A_470DDC: *result = (int32_t)m470ddc_release_surface_call_tail(self, &host); break;
    case F38A_47823E: *result = (int32_t)m47823e_release_surface_call_tail(self, &host); break;
    case F38A_478287: *result = m478287_guard_set_table_flag(self, (const Fl38aWorld *)w) == self ? 0 : 1; break;
    default: break;
    }
}
