/* Flat entry points for tests/test_fl35a_differential.py: each wraps one FL-35 (batch a) port (src/original_methods_fl35a.c) so that
 * ctypes can drive it on the same fixture as the original bytes run under Unicorn. One generic host logs every call (callee, ecx,
 * stack arguments, the bytes behind a pointer argument when the test asked for them) and a per-callee script tells it what to return
 * and which dwords / words / byte strings to store through a pointer argument. Pointers into fixture regions are turned back into the
 * fake original addresses by the test, pointers to a local of the function stay host pointers. */
#include <stdint.h>
#include <string.h>

#include "original_methods_fl35a.h"

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
    uint8_t world[256];   /* the first bytes of the Fl35aWorld snapshot at the call */
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
size_t shim_world_size(void) { return sizeof(Fl35aWorld); }

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
    if (context != NULL) memcpy(c->world, context, sizeof(Fl35aWorld) < sizeof c->world ? sizeof(Fl35aWorld) : sizeof c->world);
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

enum { F35A_40A5C1 = 1, F35A_40A6B7, F35A_40A709, F35A_40A75B, F35A_40A7AD, F35A_40A7FF, F35A_40A851, F35A_40A8A3, F35A_40A8F5, F35A_40A947, F35A_40A999, F35A_40A9EB, F35A_40AA3D, F35A_40AA8F, F35A_40AAE1, F35A_40AB33, F35A_40AB85, F35A_40ABD7, F35A_40AC29, F35A_40AC7B, F35A_40ACCD, F35A_40AD1F, F35A_40AD71, F35A_40ADC3, F35A_40AE15, F35A_40AE67, F35A_40AEB9, F35A_40AF0B };

/* Runs one port on `self` (this). `result` is the return value of the port (the eax of its last callee). The world is the host context, so that each logged call keeps a snapshot of it. */
void shim_fl35a(int fn, uint8_t *self, const uintptr_t *a, Fl35aWorld *w, int32_t *result)
{
    Fl18Host host;
    (void)a;
    *result = 0;
    memset(&host, 0, sizeof host);
    host.context = w;
    host.call = host_call;
    host.resolve = shim_resolve;
    host.tick = host_tick;

    switch (fn) {
    case F35A_40A5C1: *result = (int32_t)m40a5c1_read_tag_word(self, w, &host); break;
    case F35A_40A6B7: *result = (int32_t)m40a6b7_read_tag_word(self, w, &host); break;
    case F35A_40A709: *result = (int32_t)m40a709_read_tag_word(self, w, &host); break;
    case F35A_40A75B: *result = (int32_t)m40a75b_read_tag_word(self, w, &host); break;
    case F35A_40A7AD: *result = (int32_t)m40a7ad_read_tag_word(self, w, &host); break;
    case F35A_40A7FF: *result = (int32_t)m40a7ff_read_tag_word(self, w, &host); break;
    case F35A_40A851: *result = (int32_t)m40a851_read_tag_word(self, w, &host); break;
    case F35A_40A8A3: *result = (int32_t)m40a8a3_read_tag_word(self, w, &host); break;
    case F35A_40A8F5: *result = (int32_t)m40a8f5_read_tag_word(self, w, &host); break;
    case F35A_40A947: *result = (int32_t)m40a947_read_tag_word(self, w, &host); break;
    case F35A_40A999: *result = (int32_t)m40a999_read_tag_word(self, w, &host); break;
    case F35A_40A9EB: *result = (int32_t)m40a9eb_read_tag_word(self, w, &host); break;
    case F35A_40AA3D: *result = (int32_t)m40aa3d_read_tag_word(self, w, &host); break;
    case F35A_40AA8F: *result = (int32_t)m40aa8f_read_tag_word(self, w, &host); break;
    case F35A_40AAE1: *result = (int32_t)m40aae1_read_tag_word(self, w, &host); break;
    case F35A_40AB33: *result = (int32_t)m40ab33_read_tag_word(self, w, &host); break;
    case F35A_40AB85: *result = (int32_t)m40ab85_read_tag_word(self, w, &host); break;
    case F35A_40ABD7: *result = (int32_t)m40abd7_read_tag_word(self, w, &host); break;
    case F35A_40AC29: *result = (int32_t)m40ac29_read_tag_word(self, w, &host); break;
    case F35A_40AC7B: *result = (int32_t)m40ac7b_read_tag_word(self, w, &host); break;
    case F35A_40ACCD: *result = (int32_t)m40accd_read_tag_word(self, w, &host); break;
    case F35A_40AD1F: *result = (int32_t)m40ad1f_read_tag_word(self, w, &host); break;
    case F35A_40AD71: *result = (int32_t)m40ad71_read_tag_word(self, w, &host); break;
    case F35A_40ADC3: *result = (int32_t)m40adc3_read_tag_word(self, w, &host); break;
    case F35A_40AE15: *result = (int32_t)m40ae15_read_tag_word(self, w, &host); break;
    case F35A_40AE67: *result = (int32_t)m40ae67_read_tag_word(self, w, &host); break;
    case F35A_40AEB9: *result = (int32_t)m40aeb9_read_tag_word(self, w, &host); break;
    case F35A_40AF0B: *result = (int32_t)m40af0b_read_tag_word(self, w, &host); break;
    default: break;
    }
}
