/* Flat entry points for tests/test_fl19b_differential.py: each wraps one FL-19 (batch b) port (src/original_methods_fl19b.c) so that
 * ctypes can drive it on the same fixture as the original bytes run under Unicorn. One generic host logs every call (callee, ecx,
 * stack arguments, the bytes behind a pointer argument when the test asked for them) and a per-callee script tells it what to return
 * and which dwords / words to store through a pointer argument. Pointers into fixture regions are turned back into the fake original
 * addresses by the test, pointers to a local of the function stay host pointers. */
#include <stdint.h>
#include <string.h>

#include "original_methods_fl19b.h"

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
    uint8_t data[32];     /* bytes behind a pointer argument that the test asked to see (shim_script_deref) */
} ShimCall;

typedef struct ShimWrite {
    int call, arg, offset, size;
    uint32_t value;
} ShimWrite;

typedef struct ShimScript {
    uint32_t callee;
    uint32_t results[512];
    int nresults, used;
    int deref_arg, deref_bytes;
    ShimWrite writes[16];
    int nwrites;
} ShimScript;

static ShimRegion g_regions[16];
static int g_region_count;
static ShimCall g_calls[1024];
static int g_call_count;
static ShimScript g_script[16];
static int g_script_count;
static uint32_t g_tick;
static int g_tick_count;

void shim_reset(void)
{
    g_region_count = 0;
    g_call_count = 0;
    g_script_count = 0;
    g_tick_count = 0;
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
int shim_tick_count(void) { return g_tick_count; }
void shim_set_tick(uint32_t tick) { g_tick = tick; }
size_t shim_world_size(void) { return sizeof(Fl19bWorld); }

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

/* the call number `call` (0 based) of `callee` stores `size` bytes (2 or 4) of `value` at args[arg] + offset (a host pointer) */
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
    for (i = 0; i < nargs && i < 8; i++) c->arg[i] = args[i];
    if (s->deref_arg > 0) memcpy(c->data, (const void *)args[s->deref_arg - 1], (size_t)s->deref_bytes);
    for (i = 0; i < s->nwrites; i++) {
        const ShimWrite *w = &s->writes[i];
        if (w->call == s->used) {
            uint8_t *p = (uint8_t *)args[w->arg] + w->offset;
            if (w->size == 2) {
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

static uint32_t host_tick(void *context)
{
    (void)context;
    g_tick_count++;
    return g_tick;
}

enum { F19B_44D597 = 1, F19B_41F986, F19B_4D00F4, F19B_447AC7, F19B_45B872, F19B_434630, F19B_4C7481, F19B_4D3836, F19B_4460D6, F19B_48DED7, F19B_45B5BB, F19B_4462D3, F19B_412787, F19B_4FCA60 };

/* Runs one port. `self` is the object (this); a, b, c, d are the stack arguments / buffers as each function documents; the result
 * of a function that returns a value comes back in *result. */
void shim_fl19b(int fn, uint8_t *self, uintptr_t a, uintptr_t b, uintptr_t c, uintptr_t d, Fl19bWorld *w, int32_t *result)
{
    Fl18Host host;
    (void)b;
    (void)c;
    (void)d;
    (void)result;
    memset(&host, 0, sizeof host);
    host.call = host_call;
    host.resolve = shim_resolve;
    host.tick = host_tick;
    switch (fn) {
    case F19B_44D597: m44d597_press(self, (int32_t)a, w, &host); break;
    case F19B_41F986: m41f986_init_strings(self, &host); break;
    case F19B_4D00F4: m4d00f4_draw_list(w, &host); break;
    case F19B_447AC7: m447ac7_split_pixels(self, a, (uint8_t *)b, w, &host); break;
    case F19B_45B872: m45b872_click(self, w, &host); break;
    case F19B_434630: *result = m434630_find_name(self, (const uint8_t *)a, &host); break;
    case F19B_4C7481: m4c7481_pack_555(self, (uint8_t *)a, (uint32_t)b); break;
    case F19B_4D3836: *result = m4d3836_text_width((const uint8_t *)a, (const uint8_t *)b, (const uint8_t *)c, &host); break;
    case F19B_4460D6: m4460d6_load_layout(self, (const uint8_t *)a, w); break;
    case F19B_48DED7: m48ded7_draw_hover(w, &host); break;
    case F19B_45B5BB: *result = m45b5bb_pointer_move(self, (int16_t)a, (int16_t)b, w, &host); break;
    case F19B_4462D3: m4462d3_load_layout(self, (const uint8_t *)a, w); break;
    case F19B_412787: m412787_register_name((int16_t)a, w, &host); break;
    case F19B_4FCA60: m4fca60_set_channel_scalars(self, (int16_t)a, (uint32_t)b, (uint32_t)c, w, &host); break;
    default: break;
    }
}
