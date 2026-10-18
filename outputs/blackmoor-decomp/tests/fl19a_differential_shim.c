/* Flat entry points for tests/test_fl19a_differential.py: each wraps one FL-19 batch-a port (src/original_methods_fl19a.c) so that ctypes can
 * drive it on the same fixture as the original bytes. A single host logs every call (callee, ecx, stack arguments, optionally the bytes
 * behind a pointer argument) and answers from a script; pointers into fixture regions are turned back into the fake original addresses by
 * the Python side, which knows the regions. The world is the Fl19aWorld struct itself (the Python side mirrors its layout and checks its
 * size with shim_world_size). */
#include <stdint.h>
#include <string.h>

#include "original_methods_fl19a.h"

typedef struct ShimRegion {
    uint32_t va;
    uint8_t *ptr;
    uint32_t len;
} ShimRegion;

typedef struct ShimCall {
    uint32_t id;          /* the original address of the callee */
    int32_t nargs;
    uint64_t this_ptr;
    uint64_t arg[8];
    uint8_t data[2][32];  /* bytes behind a pointer argument that the test asked to see (shim_script_deref) */
} ShimCall;

typedef struct ShimScript {
    uint32_t callee;
    uint32_t results[16];
    int nresults, used;
    int deref_arg, deref_bytes;
} ShimScript;

static ShimRegion g_regions[16];
static int g_region_count;
static ShimCall g_calls[128];
static int g_call_count;
static ShimScript g_script[16];
static int g_script_count;

int shim_world_size(void) { return (int)sizeof(Fl19aWorld); }

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

void shim_script_deref(uint32_t callee, int arg, int bytes)
{
    ShimScript *s = script_for(callee);
    s->deref_arg = arg + 1;
    s->deref_bytes = bytes;
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

static uint32_t shim_call(void *context, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
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
    for (i = 0; i < nargs && i < 8; i++) c->arg[i] = args[i];
    if (s->deref_arg > 0) memcpy(c->data[0], (const void *)args[s->deref_arg - 1], (size_t)s->deref_bytes);
    if (s->nresults > 0) {
        result = s->results[s->used < s->nresults ? s->used : s->nresults - 1];
        s->used++;
    }
    return result;
}

enum {
    F19_4CEB3B = 1, F19_423F57, F19_4CECF7, F19_4EA269, F19_4CCDAB, F19_47E2A5, F19_423259, F19_4E89EB, F19_4E444D, F19_4B617A,
    F19_4CCFF5, F19_48D1E8, F19_475DA4, F19_4EE2A9, F19_48BD91
};

/* Runs one port on `world` (updated in place). `self`, `p1`, `p2` are host pointers into fixture regions (NULL where unused);
 * a, b, c are the scalar stack arguments. Returns the function's result (0 for a void function). */
uint32_t shim_fl19a(int fn, uint8_t *self, uint8_t *p1, uint8_t *p2, int32_t a, int32_t b, uint32_t c, Fl19aWorld *world)
{
    Fl18Host host;
    uint32_t result = 0;
    memset(&host, 0, sizeof host);
    host.call = shim_call;
    host.resolve = shim_resolve;
    switch (fn) {
    case F19_4CEB3B: m4ceb3b_reset_state(self, (int16_t)a, world, &host); break;
    case F19_423F57: result = m423f57_load_entry(self, p1, c, world, &host); break;
    case F19_4CECF7: m4cecf7_init_descriptor(self, world); break;
    case F19_4EA269: m4ea269_select_piece(self, (int16_t)a, (int16_t)b, c, world, &host); break;
    case F19_4CCDAB: m4ccdab_reset_object(self, world); break;
    case F19_47E2A5: m47e2a5_release_surfaces(self, &host); break;
    case F19_423259: result = m423259_find_by_name(self, p1, &host); break;
    case F19_4E89EB: m4e89eb_layout_slots(self, world, &host); break;
    case F19_4E444D: result = m4e444d_find_name((int16_t)a, p1, p2, world); break;
    case F19_4B617A: m4b617a_arm_piece(self, world, &host); break;
    case F19_4CCFF5: m4ccff5_free_piece(self, world, &host); break;
    case F19_48D1E8: result = m48d1e8_hit_test(self, (int16_t)a, (int16_t)b, world, &host); break;
    case F19_475DA4: result = m475da4_hit_test(self, (int16_t)a, (int16_t)b, world, &host); break;
    case F19_4EE2A9: result = m4ee2a9_hit_slots(self, world, &host); break;
    case F19_48BD91: result = m48bd91_hit_test(self, (int16_t)a, (int16_t)b, world, &host); break;
    default: break;
    }
    return result;
}
