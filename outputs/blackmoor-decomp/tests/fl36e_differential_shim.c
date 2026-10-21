/* Flat entry points for tests/test_fl36e_differential.py: each wraps one FL-36 (batch e) port (src/original_methods_fl36e.c) so that
 * ctypes can drive it on the same fixture as the original bytes run under Unicorn. One generic host logs every call (callee, ecx,
 * stack arguments, the bytes behind a pointer argument when the test asked for them) and a per-callee script tells it what to return
 * and which dwords / words / byte strings to store through a pointer argument. Pointers into fixture regions are turned back into the
 * fake original addresses by the test, pointers to a local of the function stay host pointers. */
#include <stdint.h>
#include <string.h>

#include "original_methods_fl36e.h"

#define WORLD_SIZE sizeof(Fl36eWorld)

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
    uint8_t world[256];   /* the first bytes of the Fl36eWorld snapshot at the call */
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

enum { F36E_402945 = 1, F36E_40338E, F36E_4033AB, F36E_404B0C, F36E_404B19, F36E_407C8A, F36E_407D70, F36E_40905E, F36E_40907B, F36E_414CB0, F36E_423450, F36E_423467, F36E_4234B5, F36E_426B5D, F36E_426B7E, F36E_43772F, F36E_43EB3A, F36E_43EF10, F36E_43EF27, F36E_445F40, F36E_447D4B, F36E_447E27, F36E_447E62, F36E_44883F, F36E_44885E, F36E_44AFB7, F36E_44BE90, F36E_44BEA7, F36E_454D8A, F36E_456DAB, F36E_46401A, F36E_4674FF, F36E_46B73E, F36E_470E71, F36E_4712B0, F36E_4782BE, F36E_488D6A, F36E_48D119, F36E_493AD8, F36E_4A7DDC, F36E_4AB459, F36E_4B5C48, F36E_4BF3A4, F36E_4C0C40, F36E_4CAEEF, F36E_4CC927, F36E_4D3705, F36E_4D3714, F36E_4D3C1D, F36E_4D51EA, F36E_4D52A6, F36E_4DAE66, F36E_4DAE77, F36E_4DAEF1, F36E_4DAF02, F36E_4DAF18, F36E_4DAF29, F36E_4DB377, F36E_4DD3F6, F36E_4E0742, F36E_4E2940, F36E_4E2956, F36E_4E2967, F36E_4E2978, F36E_4E2990, F36E_4E29A6, F36E_4E40FB, F36E_4E4114, F36E_4E779F, F36E_4E89B9, F36E_4E89D2, F36E_4E9E6C, F36E_4EBD53, F36E_4EBD6C, F36E_4EE602, F36E_4EE630, F36E_4EF4C9, F36E_4EF4DF, F36E_4EF516, F36E_4F0046 };

/* Runs one port on `self` (this). `result` is the return value of the port (the eax of its last callee; for the ports that return this, 0 when they do and 1 when they do not). The
 * host context is the world when the batch has one (so that each logged call keeps a snapshot of it), else NULL. */
void shim_fl36e(int fn, uint8_t *self, const uintptr_t *a, Fl36eWorld *w, int32_t *result)
{
    Fl18Host host;
    *result = 0;
    memset(&host, 0, sizeof host);
    host.context = w;
    host.call = host_call;
    host.resolve = shim_resolve;
    host.tick = host_tick;
    (void)a;
    (void)w;
    (void)self;

    switch (fn) {
    case F36E_402945: m402945_empty_method_args(self); break;
    case F36E_40338E: m40338e_empty_method_args(self); break;
    case F36E_4033AB: *result = (int32_t)m4033ab_call_two_return_const(self, &host); break;
    case F36E_404B0C: m404b0c_empty_method_args(self); break;
    case F36E_404B19: *result = (int32_t)m404b19_call_two_return_const(self, &host); break;
    case F36E_407C8A: m407c8a_empty_method_args(self); break;
    case F36E_407D70: *result = (int32_t)m407d70_call_two_return_const(self, &host); break;
    case F36E_40905E: m40905e_empty_method_args(self); break;
    case F36E_40907B: *result = (int32_t)m40907b_call_two_return_const(self, &host); break;
    case F36E_414CB0: *result = m414cb0_destruct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36E_423450: *result = m423450_init_vtable_ret_self(self) == self ? 0 : 1; break;
    case F36E_423467: *result = m423467_init_vtable_ret_self(self) == self ? 0 : 1; break;
    case F36E_4234B5: *result = (int32_t)m4234b5_forward_call(self, &host); break;
    case F36E_426B5D: *result = (int32_t)m426b5d_call_global_object(&host); break;
    case F36E_426B7E: *result = (int32_t)m426b7e_call_global_object(&host); break;
    case F36E_43772F: *result = m43772f_init_vtable_ret_self(self) == self ? 0 : 1; break;
    case F36E_43EB3A: *result = m43eb3a_destruct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36E_43EF10: *result = m43ef10_init_vtable_ret_self(self) == self ? 0 : 1; break;
    case F36E_43EF27: *result = m43ef27_init_vtable_ret_self(self) == self ? 0 : 1; break;
    case F36E_445F40: *result = (int32_t)m445f40_forward_call(self, &host); break;
    case F36E_447D4B: *result = m447d4b_set_field_const(self) == self ? 0 : 1; break;
    case F36E_447E27: *result = m447e27_destruct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36E_447E62: *result = m447e62_set_field_arg(self, (uint32_t)a[0]) == self ? 0 : 1; break;
    case F36E_44883F: *result = m44883f_init_vtable_ret_self(self) == self ? 0 : 1; break;
    case F36E_44885E: *result = (int32_t)m44885e_forward_call(self, &host); break;
    case F36E_44AFB7: *result = m44afb7_destruct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36E_44BE90: *result = m44be90_init_vtable_ret_self(self) == self ? 0 : 1; break;
    case F36E_44BEA7: *result = m44bea7_init_vtable_ret_self(self) == self ? 0 : 1; break;
    case F36E_454D8A: m454d8a_set_word(w); break;
    case F36E_456DAB: m456dab_set_two_words(w); break;
    case F36E_46401A: m46401a_set_word(w); break;
    case F36E_4674FF: *result = m4674ff_init_vtable_ret_self(self) == self ? 0 : 1; break;
    case F36E_46B73E: m46b73e_set_two_words(w); break;
    case F36E_470E71: m470e71_set_two_words(w); break;
    case F36E_4712B0: m4712b0_empty_method_args(self); break;
    case F36E_4782BE: m4782be_set_two_words(w); break;
    case F36E_488D6A: *result = m488d6a_destruct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36E_48D119: m48d119_set_word(w); break;
    case F36E_493AD8: *result = m493ad8_set_field_const(self) == self ? 0 : 1; break;
    case F36E_4A7DDC: m4a7ddc_set_two_words(w); break;
    case F36E_4AB459: m4ab459_set_word(w); break;
    case F36E_4B5C48: m4b5c48_set_word(w); break;
    case F36E_4BF3A4: *result = (int32_t)m4bf3a4_get_field(self); break;
    case F36E_4C0C40: *result = (int32_t)m4c0c40_get_field(self); break;
    case F36E_4CAEEF: *result = m4caeef_init_vtable_ret_self(self) == self ? 0 : 1; break;
    case F36E_4CC927: *result = m4cc927_destruct_base_set_vtable(self, &host) == self ? 0 : 1; break;
    case F36E_4D3705: *result = (int32_t)m4d3705_call_global_object(&host); break;
    case F36E_4D3714: *result = (int32_t)m4d3714_call_global_object(&host); break;
    case F36E_4D3C1D: *result = (int32_t)m4d3c1d_get_field(self); break;
    case F36E_4D51EA: m4d51ea_empty_method_args(self); break;
    case F36E_4D52A6: *result = (int32_t)m4d52a6_forward_call(self, &host); break;
    case F36E_4DAE66: *result = (int32_t)m4dae66_get_field(self); break;
    case F36E_4DAE77: *result = (int32_t)m4dae77_get_field(self); break;
    case F36E_4DAEF1: *result = (int32_t)m4daef1_get_field(self); break;
    case F36E_4DAF02: *result = m4daf02_set_field_arg(self, (uint32_t)a[0]) == self ? 0 : 1; break;
    case F36E_4DAF18: *result = (int32_t)m4daf18_get_field(self); break;
    case F36E_4DAF29: *result = m4daf29_set_field_arg(self, (uint32_t)a[0]) == self ? 0 : 1; break;
    case F36E_4DB377: *result = (int32_t)m4db377_forward_call(self, &host); break;
    case F36E_4DD3F6: *result = (int32_t)m4dd3f6_forward_call(self, &host); break;
    case F36E_4E0742: *result = m4e0742_set_field_const(self) == self ? 0 : 1; break;
    case F36E_4E2940: *result = m4e2940_set_field_arg(self, (uint32_t)a[0]) == self ? 0 : 1; break;
    case F36E_4E2956: *result = (int32_t)m4e2956_get_field(self); break;
    case F36E_4E2967: *result = (int32_t)m4e2967_get_field(self); break;
    case F36E_4E2978: *result = m4e2978_set_field_const(self) == self ? 0 : 1; break;
    case F36E_4E2990: *result = m4e2990_set_field_arg(self, (uint32_t)a[0]) == self ? 0 : 1; break;
    case F36E_4E29A6: *result = (int32_t)m4e29a6_get_field(self); break;
    case F36E_4E40FB: *result = (int32_t)m4e40fb_forward_call_arg(self, (uint32_t)a[0], &host); break;
    case F36E_4E4114: *result = (int32_t)m4e4114_forward_call_arg(self, (uint32_t)a[0], &host); break;
    case F36E_4E779F: *result = (int32_t)m4e779f_forward_call_arg(self, (uint32_t)a[0], &host); break;
    case F36E_4E89B9: *result = (int32_t)m4e89b9_forward_call_arg(self, (uint32_t)a[0], &host); break;
    case F36E_4E89D2: *result = (int32_t)m4e89d2_forward_call_arg(self, (uint32_t)a[0], &host); break;
    case F36E_4E9E6C: *result = m4e9e6c_set_field_const(self) == self ? 0 : 1; break;
    case F36E_4EBD53: *result = (int32_t)m4ebd53_forward_call_arg(self, (uint32_t)a[0], &host); break;
    case F36E_4EBD6C: *result = (int32_t)m4ebd6c_forward_call_arg(self, (uint32_t)a[0], &host); break;
    case F36E_4EE602: *result = (int32_t)m4ee602_get_field(self); break;
    case F36E_4EE630: *result = (int32_t)m4ee630_get_field(self); break;
    case F36E_4EF4C9: *result = m4ef4c9_set_field_arg(self, (uint32_t)a[0]) == self ? 0 : 1; break;
    case F36E_4EF4DF: *result = (int32_t)m4ef4df_get_field(self); break;
    case F36E_4EF516: *result = (int32_t)m4ef516_get_field(self); break;
    case F36E_4F0046: *result = (int32_t)m4f0046_forward_call(self, &host); break;
    default: break;
    }
}
