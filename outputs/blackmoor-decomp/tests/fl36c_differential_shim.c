/* Flat entry points for tests/test_fl36c_differential.py: each wraps one FL-36 (batch c) port (src/original_methods_fl36c.c) so that
 * ctypes can drive it on the same fixture as the original bytes run under Unicorn. One generic host logs every call (callee, ecx,
 * stack arguments, the bytes behind a pointer argument when the test asked for them) and a per-callee script tells it what to return
 * and which dwords / words / byte strings to store through a pointer argument. Pointers into fixture regions are turned back into the
 * fake original addresses by the test, pointers to a local of the function stay host pointers. */
#include <stdint.h>
#include <string.h>

#include "original_methods_fl36c.h"

#define WORLD_SIZE sizeof(Fl36cWorld)

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
    uint8_t world[256];   /* the first bytes of the Fl36cWorld snapshot at the call */
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

enum { F36C_401032 = 1, F36C_4014F5, F36C_40168F, F36C_4016AC, F36C_4016C9, F36C_4016E6, F36C_401703, F36C_401720, F36C_40173D, F36C_40175A, F36C_401777, F36C_401794, F36C_4017B1, F36C_4017CE, F36C_4017EB, F36C_401808, F36C_401825, F36C_401842, F36C_40185F, F36C_40187C, F36C_401899, F36C_4018B6, F36C_4018D3, F36C_4018F0, F36C_40190D, F36C_40192A, F36C_401947, F36C_401964, F36C_401981, F36C_40199E, F36C_4019BB, F36C_4019D8, F36C_4019F5, F36C_401A12, F36C_401A2F, F36C_401A4C, F36C_401A69, F36C_401A86, F36C_401AA3, F36C_401AC0, F36C_401ADD, F36C_401AFA, F36C_401B17, F36C_401B34, F36C_401B51, F36C_401B6E, F36C_401B8B, F36C_401BA8, F36C_401BC5, F36C_401BE2, F36C_401BFF, F36C_404AF0, F36C_41458B, F36C_414CCF, F36C_437710, F36C_43EB59, F36C_445DF0, F36C_445E0F, F36C_447D10, F36C_447D2F, F36C_447E46, F36C_448820, F36C_449A78, F36C_44AFD6, F36C_44D0EB, F36C_44E74B, F36C_44F650, F36C_44F66F, F36C_454D6E, F36C_456CEB, F36C_457F5E, F36C_459ACE, F36C_45B3CE, F36C_45DC6E, F36C_46180B, F36C_463FFE, F36C_465AEB, F36C_4674E0, F36C_468E3E, F36C_46B56E, F36C_470D5E, F36C_4757BE, F36C_4781DE, F36C_47B21F, F36C_47D4DB, F36C_47E23E, F36C_48215E, F36C_483F4E, F36C_487AFE, F36C_488D89, F36C_48A6EE, F36C_48BAFB, F36C_48D04B, F36C_48E26E, F36C_4A1C2B, F36C_4A376E, F36C_4A636E, F36C_4A7C5E, F36C_4A9F0B, F36C_4AB38B, F36C_4AC8BE, F36C_4AFD1E, F36C_4B3C3E, F36C_4B5B6E, F36C_4B71DB, F36C_4B7F00, F36C_4B7F1F, F36C_4B9E00, F36C_4B9E1F, F36C_4BED99, F36C_4BF600, F36C_4BF61F, F36C_4CAED0, F36C_4CC946, F36C_4CCD8F, F36C_4D3B6E, F36C_4D5260, F36C_4D527F, F36C_4D58B0, F36C_4D58CF, F36C_4DB260, F36C_4DB27F, F36C_4DD3B0, F36C_4DD3CF, F36C_4E1C83, F36C_4EE980, F36C_4EE99F, F36C_4F0000, F36C_4F001F, F36C_4FA9E7 };

/* Runs one port on `self` (this). `result` is the return value of the port (the eax of its last callee; for the ports that return this, 0 when they do and 1 when they do not). The
 * host context is the world when the batch has one (so that each logged call keeps a snapshot of it), else NULL. */
void shim_fl36c(int fn, uint8_t *self, const uintptr_t *a, Fl36cWorld *w, int32_t *result)
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
    case F36C_401032: *result = (int32_t)m401032_init_vtable_call(self, &host); break;
    case F36C_4014F5: *result = (int32_t)m4014f5_init_vtable_call(self, &host); break;
    case F36C_40168F: *result = (int32_t)m40168f_set_mode_call(self, w, &host); break;
    case F36C_4016AC: *result = (int32_t)m4016ac_set_mode_call(self, w, &host); break;
    case F36C_4016C9: *result = (int32_t)m4016c9_set_mode_call(self, w, &host); break;
    case F36C_4016E6: *result = (int32_t)m4016e6_set_mode_call(self, w, &host); break;
    case F36C_401703: *result = (int32_t)m401703_set_mode_call(self, w, &host); break;
    case F36C_401720: *result = (int32_t)m401720_set_mode_call(self, w, &host); break;
    case F36C_40173D: *result = (int32_t)m40173d_set_mode_call(self, w, &host); break;
    case F36C_40175A: *result = (int32_t)m40175a_set_mode_call(self, w, &host); break;
    case F36C_401777: *result = (int32_t)m401777_set_mode_call(self, w, &host); break;
    case F36C_401794: *result = (int32_t)m401794_set_mode_call(self, w, &host); break;
    case F36C_4017B1: *result = (int32_t)m4017b1_set_mode_call(self, w, &host); break;
    case F36C_4017CE: *result = (int32_t)m4017ce_set_mode_call(self, w, &host); break;
    case F36C_4017EB: *result = (int32_t)m4017eb_set_mode_call(self, w, &host); break;
    case F36C_401808: *result = (int32_t)m401808_set_mode_call(self, w, &host); break;
    case F36C_401825: *result = (int32_t)m401825_set_mode_call(self, w, &host); break;
    case F36C_401842: *result = (int32_t)m401842_set_mode_call(self, w, &host); break;
    case F36C_40185F: *result = (int32_t)m40185f_set_mode_call(self, w, &host); break;
    case F36C_40187C: *result = (int32_t)m40187c_set_mode_call(self, w, &host); break;
    case F36C_401899: *result = (int32_t)m401899_set_mode_call(self, w, &host); break;
    case F36C_4018B6: *result = (int32_t)m4018b6_set_mode_call(self, w, &host); break;
    case F36C_4018D3: *result = (int32_t)m4018d3_set_mode_call(self, w, &host); break;
    case F36C_4018F0: *result = (int32_t)m4018f0_set_mode_call(self, w, &host); break;
    case F36C_40190D: *result = (int32_t)m40190d_set_mode_call(self, w, &host); break;
    case F36C_40192A: *result = (int32_t)m40192a_set_mode_call(self, w, &host); break;
    case F36C_401947: *result = (int32_t)m401947_set_mode_call(self, w, &host); break;
    case F36C_401964: *result = (int32_t)m401964_set_mode_call(self, w, &host); break;
    case F36C_401981: *result = (int32_t)m401981_set_mode_call(self, w, &host); break;
    case F36C_40199E: *result = (int32_t)m40199e_set_mode_call(self, w, &host); break;
    case F36C_4019BB: *result = (int32_t)m4019bb_set_mode_call(self, w, &host); break;
    case F36C_4019D8: *result = (int32_t)m4019d8_set_mode_call(self, w, &host); break;
    case F36C_4019F5: *result = (int32_t)m4019f5_set_mode_call(self, w, &host); break;
    case F36C_401A12: *result = (int32_t)m401a12_set_mode_call(self, w, &host); break;
    case F36C_401A2F: *result = (int32_t)m401a2f_set_mode_call(self, w, &host); break;
    case F36C_401A4C: *result = (int32_t)m401a4c_set_mode_call(self, w, &host); break;
    case F36C_401A69: *result = (int32_t)m401a69_set_mode_call(self, w, &host); break;
    case F36C_401A86: *result = (int32_t)m401a86_set_mode_call(self, w, &host); break;
    case F36C_401AA3: *result = (int32_t)m401aa3_set_mode_call(self, w, &host); break;
    case F36C_401AC0: *result = (int32_t)m401ac0_set_mode_call(self, w, &host); break;
    case F36C_401ADD: *result = (int32_t)m401add_set_mode_call(self, w, &host); break;
    case F36C_401AFA: *result = (int32_t)m401afa_set_mode_call(self, w, &host); break;
    case F36C_401B17: *result = (int32_t)m401b17_set_mode_call(self, w, &host); break;
    case F36C_401B34: *result = (int32_t)m401b34_set_mode_call(self, w, &host); break;
    case F36C_401B51: *result = (int32_t)m401b51_set_mode_call(self, w, &host); break;
    case F36C_401B6E: *result = (int32_t)m401b6e_set_mode_call(self, w, &host); break;
    case F36C_401B8B: *result = (int32_t)m401b8b_set_mode_call(self, w, &host); break;
    case F36C_401BA8: *result = (int32_t)m401ba8_set_mode_call(self, w, &host); break;
    case F36C_401BC5: *result = (int32_t)m401bc5_set_mode_call(self, w, &host); break;
    case F36C_401BE2: *result = (int32_t)m401be2_set_mode_call(self, w, &host); break;
    case F36C_401BFF: *result = (int32_t)m401bff_set_mode_call(self, w, &host); break;
    case F36C_404AF0: *result = (int32_t)m404af0_init_vtable_call(self, &host); break;
    case F36C_41458B: *result = (int32_t)m41458b_init_vtable_call(self, &host); break;
    case F36C_414CCF: *result = (int32_t)m414ccf_init_vtable_call(self, &host); break;
    case F36C_437710: *result = m437710_init_vtable_call_ret_self(self, &host) == self ? 0 : 1; break;
    case F36C_43EB59: *result = (int32_t)m43eb59_init_vtable_call(self, &host); break;
    case F36C_445DF0: *result = m445df0_init_vtable_call_ret_self(self, &host) == self ? 0 : 1; break;
    case F36C_445E0F: *result = (int32_t)m445e0f_init_vtable_call(self, &host); break;
    case F36C_447D10: *result = m447d10_init_vtable_call_ret_self(self, &host) == self ? 0 : 1; break;
    case F36C_447D2F: *result = (int32_t)m447d2f_init_vtable_call(self, &host); break;
    case F36C_447E46: *result = (int32_t)m447e46_init_vtable_call(self, &host); break;
    case F36C_448820: *result = m448820_init_vtable_call_ret_self(self, &host) == self ? 0 : 1; break;
    case F36C_449A78: *result = (int32_t)m449a78_init_vtable_call(self, &host); break;
    case F36C_44AFD6: *result = (int32_t)m44afd6_init_vtable_call(self, &host); break;
    case F36C_44D0EB: *result = (int32_t)m44d0eb_init_vtable_call(self, &host); break;
    case F36C_44E74B: *result = (int32_t)m44e74b_init_vtable_call(self, &host); break;
    case F36C_44F650: *result = m44f650_init_vtable_call_ret_self(self, &host) == self ? 0 : 1; break;
    case F36C_44F66F: *result = (int32_t)m44f66f_init_vtable_call(self, &host); break;
    case F36C_454D6E: *result = (int32_t)m454d6e_init_vtable_call(self, &host); break;
    case F36C_456CEB: *result = (int32_t)m456ceb_init_vtable_call(self, &host); break;
    case F36C_457F5E: *result = (int32_t)m457f5e_init_vtable_call(self, &host); break;
    case F36C_459ACE: *result = (int32_t)m459ace_init_vtable_call(self, &host); break;
    case F36C_45B3CE: *result = (int32_t)m45b3ce_init_vtable_call(self, &host); break;
    case F36C_45DC6E: *result = (int32_t)m45dc6e_init_vtable_call(self, &host); break;
    case F36C_46180B: *result = (int32_t)m46180b_init_vtable_call(self, &host); break;
    case F36C_463FFE: *result = (int32_t)m463ffe_init_vtable_call(self, &host); break;
    case F36C_465AEB: *result = (int32_t)m465aeb_init_vtable_call(self, &host); break;
    case F36C_4674E0: *result = m4674e0_init_vtable_call_ret_self(self, &host) == self ? 0 : 1; break;
    case F36C_468E3E: *result = (int32_t)m468e3e_init_vtable_call(self, &host); break;
    case F36C_46B56E: *result = (int32_t)m46b56e_init_vtable_call(self, &host); break;
    case F36C_470D5E: *result = (int32_t)m470d5e_init_vtable_call(self, &host); break;
    case F36C_4757BE: *result = (int32_t)m4757be_init_vtable_call(self, &host); break;
    case F36C_4781DE: *result = (int32_t)m4781de_init_vtable_call(self, &host); break;
    case F36C_47B21F: *result = (int32_t)m47b21f_init_vtable_call(self, &host); break;
    case F36C_47D4DB: *result = (int32_t)m47d4db_init_vtable_call(self, &host); break;
    case F36C_47E23E: *result = (int32_t)m47e23e_init_vtable_call(self, &host); break;
    case F36C_48215E: *result = (int32_t)m48215e_init_vtable_call(self, &host); break;
    case F36C_483F4E: *result = (int32_t)m483f4e_init_vtable_call(self, &host); break;
    case F36C_487AFE: *result = (int32_t)m487afe_init_vtable_call(self, &host); break;
    case F36C_488D89: *result = (int32_t)m488d89_init_vtable_call(self, &host); break;
    case F36C_48A6EE: *result = (int32_t)m48a6ee_init_vtable_call(self, &host); break;
    case F36C_48BAFB: *result = (int32_t)m48bafb_init_vtable_call(self, &host); break;
    case F36C_48D04B: *result = (int32_t)m48d04b_init_vtable_call(self, &host); break;
    case F36C_48E26E: *result = (int32_t)m48e26e_init_vtable_call(self, &host); break;
    case F36C_4A1C2B: *result = (int32_t)m4a1c2b_init_vtable_call(self, &host); break;
    case F36C_4A376E: *result = (int32_t)m4a376e_init_vtable_call(self, &host); break;
    case F36C_4A636E: *result = (int32_t)m4a636e_init_vtable_call(self, &host); break;
    case F36C_4A7C5E: *result = (int32_t)m4a7c5e_init_vtable_call(self, &host); break;
    case F36C_4A9F0B: *result = (int32_t)m4a9f0b_init_vtable_call(self, &host); break;
    case F36C_4AB38B: *result = (int32_t)m4ab38b_init_vtable_call(self, &host); break;
    case F36C_4AC8BE: *result = (int32_t)m4ac8be_init_vtable_call(self, &host); break;
    case F36C_4AFD1E: *result = (int32_t)m4afd1e_init_vtable_call(self, &host); break;
    case F36C_4B3C3E: *result = (int32_t)m4b3c3e_init_vtable_call(self, &host); break;
    case F36C_4B5B6E: *result = (int32_t)m4b5b6e_init_vtable_call(self, &host); break;
    case F36C_4B71DB: *result = (int32_t)m4b71db_init_vtable_call(self, &host); break;
    case F36C_4B7F00: *result = m4b7f00_init_vtable_call_ret_self(self, &host) == self ? 0 : 1; break;
    case F36C_4B7F1F: *result = (int32_t)m4b7f1f_init_vtable_call(self, &host); break;
    case F36C_4B9E00: *result = m4b9e00_init_vtable_call_ret_self(self, &host) == self ? 0 : 1; break;
    case F36C_4B9E1F: *result = (int32_t)m4b9e1f_init_vtable_call(self, &host); break;
    case F36C_4BED99: *result = (int32_t)m4bed99_init_vtable_call(self, &host); break;
    case F36C_4BF600: *result = m4bf600_init_vtable_call_ret_self(self, &host) == self ? 0 : 1; break;
    case F36C_4BF61F: *result = (int32_t)m4bf61f_init_vtable_call(self, &host); break;
    case F36C_4CAED0: *result = m4caed0_init_vtable_call_ret_self(self, &host) == self ? 0 : 1; break;
    case F36C_4CC946: *result = (int32_t)m4cc946_init_vtable_call(self, &host); break;
    case F36C_4CCD8F: *result = (int32_t)m4ccd8f_init_vtable_call(self, &host); break;
    case F36C_4D3B6E: *result = (int32_t)m4d3b6e_init_vtable_call(self, &host); break;
    case F36C_4D5260: *result = m4d5260_init_vtable_call_ret_self(self, &host) == self ? 0 : 1; break;
    case F36C_4D527F: *result = (int32_t)m4d527f_init_vtable_call(self, &host); break;
    case F36C_4D58B0: *result = m4d58b0_init_vtable_call_ret_self(self, &host) == self ? 0 : 1; break;
    case F36C_4D58CF: *result = (int32_t)m4d58cf_init_vtable_call(self, &host); break;
    case F36C_4DB260: *result = m4db260_init_vtable_call_ret_self(self, &host) == self ? 0 : 1; break;
    case F36C_4DB27F: *result = (int32_t)m4db27f_init_vtable_call(self, &host); break;
    case F36C_4DD3B0: *result = m4dd3b0_init_vtable_call_ret_self(self, &host) == self ? 0 : 1; break;
    case F36C_4DD3CF: *result = (int32_t)m4dd3cf_init_vtable_call(self, &host); break;
    case F36C_4E1C83: *result = (int32_t)m4e1c83_init_vtable_call(self, &host); break;
    case F36C_4EE980: *result = m4ee980_init_vtable_call_ret_self(self, &host) == self ? 0 : 1; break;
    case F36C_4EE99F: *result = (int32_t)m4ee99f_init_vtable_call(self, &host); break;
    case F36C_4F0000: *result = m4f0000_init_vtable_call_ret_self(self, &host) == self ? 0 : 1; break;
    case F36C_4F001F: *result = (int32_t)m4f001f_init_vtable_call(self, &host); break;
    case F36C_4FA9E7: *result = (int32_t)m4fa9e7_init_vtable_call(self, &host); break;
    default: break;
    }
}
