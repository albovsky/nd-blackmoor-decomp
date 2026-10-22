/* Flat entry points for tests/test_fl39f_differential.py: each wraps one FL-39 (batch f) port (src/original_methods_fl39f.c) so that
 * ctypes can drive it on the same fixture as the original bytes run under Unicorn. One generic host logs every call (callee, ecx,
 * stack arguments, the bytes behind a pointer argument when the test asked for them) and a per-callee script tells it what to return
 * and which dwords / words / byte strings to store through a pointer argument. Pointers into fixture regions are turned back into the
 * fake original addresses by the test, pointers to a local of the function stay host pointers. */
#include <stdint.h>
#include <string.h>

#include "original_methods_fl39f.h"

#define WORLD_SIZE sizeof(Fl39fWorld)

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
    uint8_t world[256];   /* the first bytes of the Fl39fWorld snapshot at the call */
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

enum { F39F_48EF40 = 1, F39F_4904FA, F39F_49192B, F39F_495608, F39F_49C53A, F39F_49CF80, F39F_4A0C7F, F39F_4AC8DA, F39F_4BEEB3, F39F_4C9CDD, F39F_4D52B9, F39F_4D6AD1, F39F_4D8F0A, F39F_4DC13F, F39F_4DE5F0, F39F_4E0410, F39F_4E069C, F39F_4E1C50, F39F_4E4428, F39F_4E498D, F39F_4E7A70, F39F_4EB77D, F39F_4EB870, F39F_4EC005, F39F_4FA8D2, F39F_4FA980 };

/* Runs one port on `self` (this); `a` holds the stack arguments of the function as 64-bit values. `result` is the return value of the port (the eax of its last callee;
 * for the ports that return this, 0 when they do and 1 when they do not). The host context is the world when the batch has one (so that each logged call keeps a snapshot of it). */
void shim_fl39f(int fn, uint8_t *self, const uintptr_t *a, void *w, int32_t *result)
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
    case F39F_48EF40: m48ef40_advance_slot(self, (const Fl39fWorld *)w, &host); break;
    case F39F_4904FA: *result = m4904fa_construct_record(self, &host) != self; break;
    case F39F_49192B: m49192b_clear_block(self, &host); break;
    case F39F_495608: m495608_check_object(self, (const Fl39fWorld *)w, &host); break;
    case F39F_49C53A: *result = m49c53a_construct_record(self, &host) != self; break;
    case F39F_49CF80: m49cf80_fill_cells(self, &host); break;
    case F39F_4A0C7F: m4a0c7f_count_nonempty(self); break;
    case F39F_4AC8DA: m4ac8da_init_record(self); break;
    case F39F_4BEEB3: { uint8_t *p = m4beeb3_bind_buffer(self, (uint32_t)a[0], &host); *result = p == NULL ? 0 : (int32_t)(0x20000000u + (uint32_t)(p - self)); }   /* this = region 0 = 0x20000000 */ break;
    case F39F_4C9CDD: *result = (int32_t)m4c9cdd_find_zero_record((uint8_t *)a[0]); break;
    case F39F_4D52B9: m4d52b9_init_record(self); break;
    case F39F_4D6AD1: m4d6ad1_start_timer(self, &host); break;
    case F39F_4D8F0A: m4d8f0a_release_list(self, &host); break;
    case F39F_4DC13F: m4dc13f_copy_counted(self, (const uint8_t *)a[0], (uint32_t)a[1], (const Fl39fWorld *)w, &host); break;
    case F39F_4DE5F0: *result = m4de5f0_construct_record(self, &host) != self; break;
    case F39F_4E0410: *result = m4e0410_construct_record(self, &host) != self; break;
    case F39F_4E069C: m4e069c_copy_in(self, (const uint8_t *)a[0]); break;
    case F39F_4E1C50: *result = m4e1c50_construct_record(self, &host) != self; break;
    case F39F_4E4428: m4e4428_copy_in(self, (const uint8_t *)a[0]); break;
    case F39F_4E498D: m4e498d_set_name(self, (const uint8_t *)a[0]); break;
    case F39F_4E7A70: *result = m4e7a70_construct_record(self, &host) != self; break;
    case F39F_4EB77D: m4eb77d_fill_name_table(self, (const Fl39fWorld *)w); break;
    case F39F_4EB870: *result = m4eb870_construct_record(self, &host) != self; break;
    case F39F_4EC005: m4ec005_copy_checked(self, (const uint8_t *)a[0], (int32_t)(uint32_t)a[1], &host); break;
    case F39F_4FA8D2: *result = (int32_t)m4fa8d2_check_name((uint32_t)a[0], (const uint8_t *)a[1], (uint32_t)a[2], (uint8_t *)a[3], (const Fl39fWorld *)w, &host); break;
    case F39F_4FA980: *result = m4fa980_construct_record(self) != self; break;
    default: break;
    }
}
