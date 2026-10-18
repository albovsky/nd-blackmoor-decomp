/* Flat entry points for tests/test_fl20a_differential.py: each wraps one FL-20 (batch a) port (src/original_methods_fl20a.c) so that
 * ctypes can drive it on the same fixture as the original bytes run under Unicorn. One generic host logs every call (callee, ecx,
 * stack arguments, the bytes behind a pointer argument when the test asked for them) and a per-callee script tells it what to return
 * and which dwords / words to store through a pointer argument. Pointers into fixture regions are turned back into the fake original
 * addresses by the test, pointers to a local of the function stay host pointers. */
#include <stdint.h>
#include <string.h>

#include "original_methods_fl20a.h"

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
size_t shim_world_size(void) { return sizeof(Fl20aWorld); }

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

enum { F20A_4D3C88 = 1, F20A_4D3C5F, F20A_41C509, F20A_43EC4A, F20A_43EC85, F20A_43ECC0, F20A_43ED71, F20A_475885, F20A_4CAF03, F20A_41C770,
       F20A_4757DA, F20A_48BB86, F20A_483FB5, F20A_4343A2, F20A_44727A, F20A_42B87A };

/* Runs one port. `self` is the object (this); a, b, c, d are the stack arguments / buffers as each function documents (for the four
 * sibling methods a, b, c are the stack dwords and d is the value of this); the result of a function that returns a value comes back
 * in *result. */
void shim_fl20a(int fn, uint8_t *self, uintptr_t a, uintptr_t b, uintptr_t c, uintptr_t d, Fl20aWorld *w, int32_t *result)
{
    Fl18Host host;
    memset(&host, 0, sizeof host);
    host.call = host_call;
    host.resolve = shim_resolve;
    host.tick = host_tick;
    switch (fn) {
    case F20A_4D3C88: m4d3c88_clear_flag(w); break;
    case F20A_4D3C5F: m4d3c5f_set_ready(self, &host); break;
    case F20A_41C509: m41c509_init_fields((uint8_t *)a); break;
    case F20A_43EC4A: m43ec4a_forward_4db000(d, (uint32_t)a, (uint32_t)b, (uint32_t)c, &host); break;
    case F20A_43EC85: m43ec85_forward_4dafc3(d, (uint32_t)a, (uint32_t)b, (uint32_t)c, &host); break;
    case F20A_43ECC0: m43ecc0_forward_4db04f(d, (uint32_t)a, (uint32_t)b, (uint32_t)c, &host); break;
    case F20A_43ED71: m43ed71_forward_4daf9f(d, (uint32_t)a, (uint32_t)b, (uint32_t)c, &host); break;
    case F20A_475885: m475885_release(self, &host); break;
    case F20A_4CAF03: m4caf03_reset(self); break;
    case F20A_41C770: m41c770_init_fields((uint8_t *)a); break;
    case F20A_4757DA: m4757da_clear_grid(self); break;
    case F20A_48BB86: m48bb86_release(self, &host); break;
    case F20A_483FB5: m483fb5_release_all(self, &host); break;
    case F20A_4343A2: *result = m4343a2_find_name(self, (const uint8_t *)a, &host); break;
    case F20A_44727A: m44727a_start_record(self, (int16_t)a, w, &host); break;
    case F20A_42B87A: m42b87a_apply_record((int16_t)a, w, &host); break;
    default: (void)b; (void)c; (void)d; (void)result; break;
    }
}
