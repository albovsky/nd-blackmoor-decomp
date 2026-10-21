/* Flat entry points for tests/test_fl38b_differential.py: wraps each FL-38 (batch b) port (src/original_methods_fl38b.c) so that ctypes can drive it on the same fixture as the original
 * bytes run under Unicorn. One generic host logs every call (callee, ecx, stack arguments) and a per-callee script tells it what to return. The three stack arguments of the ports
 * are original addresses of cells; `shim_resolve` maps them (and the dwords stored in the cells) to the fixture arrays. */
#include <stdint.h>
#include <string.h>

#include "original_methods_fl38b.h"

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
    uint8_t data[256];
    uint8_t probe[4096];
    uint8_t world[256];
} ShimCall;

typedef struct ShimScript {
    uint32_t callee;
    uint32_t results[512];
    int nresults, used;
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
size_t shim_world_size(void) { return sizeof(Fl38bWorld); }

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

static const uint8_t *shim_resolve(void *context, uint32_t address)
{
    int i;
    (void)context;
    for (i = 0; i < g_region_count; i++)
        if (address >= g_regions[i].va && address < g_regions[i].va + g_regions[i].len)
            return g_regions[i].ptr + (address - g_regions[i].va);
    return NULL;
}

static uint32_t host_call(void *context, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    ShimCall *c = &g_calls[g_call_count++];
    ShimScript *s = script_for(callee);
    uint32_t result = 0;
    int i;
    (void)context;
    memset(c, 0, sizeof *c);
    c->id = callee;
    c->nargs = nargs;
    c->this_ptr = this_ptr;
    for (i = 0; i < nargs && i < 16; i++) c->arg[i] = args[i];
    if (s->nresults > 0) result = s->results[s->used < s->nresults ? s->used : s->nresults - 1];
    s->used++;
    return result;
}

enum { F38B_44D1D1 = 1, F38B_456FB6, F38B_45807C, F38B_464100, F38B_465BDE, F38B_46B79A, F38B_47314B, F38B_4782DB, F38B_475964, F38B_44FBE3, F38B_467688, F38B_468F9F, F38B_47E477, F38B_44E8A2, F38B_454E70, F38B_459C10, F38B_45DDD0, F38B_47B3F0 };

/* Runs one port on the three cell addresses a[0..2]. `result` is the return value of the port (0 normal, 1 stopped at the failure-branch callee 0x4c97b4). */
void shim_fl38b(int fn, uint8_t *self, const uintptr_t *a, void *w, int32_t *result)
{
    Fl18Host host;
    const Fl38bWorld *world = (const Fl38bWorld *)w;
    *result = 0;
    memset(&host, 0, sizeof host);
    host.context = NULL;
    host.call = host_call;
    host.resolve = shim_resolve;
    (void)self;

    switch (fn) {
    case F38B_44D1D1: *result = m44d1d1_clone_record((uint32_t)a[0], (uint32_t)a[1], (uint32_t)a[2], world, &host); break;
    case F38B_456FB6: *result = m456fb6_clone_record((uint32_t)a[0], (uint32_t)a[1], (uint32_t)a[2], world, &host); break;
    case F38B_45807C: *result = m45807c_clone_record((uint32_t)a[0], (uint32_t)a[1], (uint32_t)a[2], world, &host); break;
    case F38B_464100: *result = m464100_clone_record((uint32_t)a[0], (uint32_t)a[1], (uint32_t)a[2], world, &host); break;
    case F38B_465BDE: *result = m465bde_clone_record((uint32_t)a[0], (uint32_t)a[1], (uint32_t)a[2], world, &host); break;
    case F38B_46B79A: *result = m46b79a_clone_record((uint32_t)a[0], (uint32_t)a[1], (uint32_t)a[2], world, &host); break;
    case F38B_47314B: *result = m47314b_clone_record((uint32_t)a[0], (uint32_t)a[1], (uint32_t)a[2], world, &host); break;
    case F38B_4782DB: *result = m4782db_clone_record((uint32_t)a[0], (uint32_t)a[1], (uint32_t)a[2], world, &host); break;
    case F38B_475964: *result = m475964_clone_record((uint32_t)a[0], (uint32_t)a[1], (uint32_t)a[2], world, &host); break;
    case F38B_44FBE3: *result = m44fbe3_clone_record((uint32_t)a[0], (uint32_t)a[1], (uint32_t)a[2], world, &host); break;
    case F38B_467688: *result = m467688_clone_record((uint32_t)a[0], (uint32_t)a[1], (uint32_t)a[2], world, &host); break;
    case F38B_468F9F: *result = m468f9f_clone_record((uint32_t)a[0], (uint32_t)a[1], (uint32_t)a[2], world, &host); break;
    case F38B_47E477: *result = m47e477_clone_record((uint32_t)a[0], (uint32_t)a[1], (uint32_t)a[2], world, &host); break;
    case F38B_44E8A2: *result = m44e8a2_clone_record((uint32_t)a[0], (uint32_t)a[1], (uint32_t)a[2], world, &host); break;
    case F38B_454E70: *result = m454e70_clone_record((uint32_t)a[0], (uint32_t)a[1], (uint32_t)a[2], world, &host); break;
    case F38B_459C10: *result = m459c10_clone_record((uint32_t)a[0], (uint32_t)a[1], (uint32_t)a[2], world, &host); break;
    case F38B_45DDD0: *result = m45ddd0_clone_record((uint32_t)a[0], (uint32_t)a[1], (uint32_t)a[2], world, &host); break;
    case F38B_47B3F0: *result = m47b3f0_clone_record((uint32_t)a[0], (uint32_t)a[1], (uint32_t)a[2], world, &host); break;
    default: break;
    }
}
