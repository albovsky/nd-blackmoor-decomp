/* Flat entry points for tests/test_fl23b_differential.py: each wraps one FL-24 (batch b) port (src/original_methods_fl23b.c) so that
 * ctypes can drive it on the same fixture as the original bytes run under Unicorn. One generic host logs every call (callee, ecx,
 * stack arguments, the bytes behind a pointer argument when the test asked for them) and a per-callee script tells it what to return
 * and which dwords / words to store through a pointer argument. Pointers into fixture regions are turned back into the fake original
 * addresses by the test, pointers to a local of the function stay host pointers. */
#include <stdint.h>
#include <string.h>

#include "original_methods_fl24b.h"

#define SHIM_TICK_ID 0x52a23cu   /* the import slot of GetTickCount in the original */

typedef struct ShimRegion {
    uint32_t va;
    uint8_t *ptr;
    uint32_t len;
} ShimRegion;

typedef struct ShimCall {
    uint32_t id;          /* the original address of the callee */
    int32_t nargs;
    uint64_t this_ptr;
    uint64_t arg[12];
    uint8_t data[64];     /* bytes behind pointer arguments that the test asked to see: [0..32) shim_script_deref, [32..64) shim_script_deref2 */
    uint8_t probe[4096];  /* bytes at the probed host addresses (shim_script_probe), concatenated, read at the call */
} ShimCall;

typedef struct ShimWrite {
    int call, arg, offset, size;
    uint32_t value;
} ShimWrite;

typedef struct ShimScript {
    uint32_t callee;
    uint32_t results[512];
    int nresults, used;
    int deref_arg, deref_bytes, deref_arg2, deref_bytes2;
    const uint8_t *probe_ptr[8];
    int probe_len[8], nprobe;
    ShimWrite writes[256];
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
size_t shim_world_size(void) { return sizeof(Fl24bWorld); }

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
    (void)context;
    memset(c, 0, sizeof *c);
    c->id = callee;
    c->nargs = nargs;
    c->this_ptr = this_ptr;
    for (i = 0; i < nargs && i < 12; i++) c->arg[i] = args[i];
    /* a pointer argument is a host pointer (a local of the function) or an original address inside a fixture region */
    if (s->deref_arg > 0) memcpy(c->data, deref_ptr(args[s->deref_arg - 1]), (size_t)s->deref_bytes);
    if (s->deref_arg2 > 0) memcpy(c->data + 32, deref_ptr(args[s->deref_arg2 - 1]), (size_t)s->deref_bytes2);
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

/* GetTickCount is an ordered event of the call log (id = its import slot, no arguments), so that a read before or after a neighbouring
 * call is seen as a different sequence; the test names it 'tick' on both sides */
static uint32_t host_tick(void *context)
{
    ShimCall *c = &g_calls[g_call_count++];
    (void)context;
    memset(c, 0, sizeof *c);
    c->id = SHIM_TICK_ID;
    g_tick_count++;
    return g_tick;
}

enum { F24B_4DAD60 = 1, F24B_466073, F24B_467740, F24B_4B7563, F24B_459E49 /* F24B-ENUM-END */ };

/* Runs one port on `self` (this) with the stack arguments a, b, c, d (as dwords; a word argument is cut by the port). *result is eax
 * where the function returns a value. */
void shim_fl24b(int fn, uint8_t *self, uintptr_t a, uintptr_t b, uintptr_t c, uintptr_t d, Fl24bWorld *w, int32_t *result)
{
    Fl18Host host;
    (void)a;
    (void)b;
    (void)c;
    (void)d;
    *result = 0;
    memset(&host, 0, sizeof host);
    host.call = host_call;
    host.resolve = shim_resolve;
    host.tick = host_tick;
    switch (fn) {
    case F24B_4DAD60: m4dad60_init_swap_buttons(self, w, &host); break;
    case F24B_466073: m466073_click_27d2_27d3(self, w, &host); break;
    case F24B_467740: *result = m467740_hit_test(self, (int16_t)a, (int16_t)b, w, &host); break;
    case F24B_4B7563: m4b7563_click_27bf_27c1(self, w, &host); break;
    case F24B_459E49: m459e49_click_2742(self, w, &host); break;
    /* F24B-CASE-END */
    default: break;
    }
}
