/* Flat entry points for tests/test_fl38c_differential.py: wraps each FL-38 (batch c) port (src/original_methods_fl38c.c) so that ctypes can drive it on the same fixture as the original
 * bytes run under Unicorn. One generic host logs every call (callee, ecx, stack arguments, the bytes behind a pointer argument when the test asked for them) and a per-callee script tells
 * it what to return and which byte string to store through a pointer argument (0x51d5b2 fills the local of the function). Pointers into fixture regions are turned back into the fake
 * original addresses by the test, pointers to a local of the function stay host pointers. The cells and blocks of new_zeroed are original addresses (`shim_resolve`). */
#include <stdint.h>
#include <string.h>

#include "original_methods_fl38c.h"

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
    uint8_t data[256];    /* bytes behind the pointer argument that the test asked to see (shim_script_deref) */
    uint8_t probe[4096];  /* bytes at the probed host addresses (shim_script_probe), concatenated, read at the call */
    uint8_t world[256];   /* the first bytes of the Fl38cWorld snapshot at the call */
} ShimCall;

typedef struct ShimWrite {
    int call, arg, offset;
    uint8_t bytes[256];
    int nbytes;
} ShimWrite;

typedef struct ShimScript {
    uint32_t callee;
    uint32_t results[512];
    int nresults, used;
    int deref_arg, deref_bytes;
    const uint8_t *probe_ptr[8];
    int probe_len[8], nprobe;
    ShimWrite writes[8];
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
size_t shim_world_size(void) { return sizeof(Fl38cWorld); }

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

/* the bytes behind the host pointer args[arg] (`bytes` of them) are copied into every logged call of `callee`, as they are at the call */
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

/* the call number `call` (0 based) of `callee` stores `nbytes` bytes at args[arg] + offset */
void shim_script_write_bytes(uint32_t callee, int call, int arg, int offset, const uint8_t *bytes, int nbytes)
{
    ShimScript *s = script_for(callee);
    ShimWrite *w = &s->writes[s->nwrites++];
    w->call = call;
    w->arg = arg;
    w->offset = offset;
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

static uint32_t host_call(void *context, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    ShimCall *c = &g_calls[g_call_count++];
    ShimScript *s = script_for(callee);
    uint32_t result = 0;
    int i;
    memset(c, 0, sizeof *c);
    if (context != NULL) memcpy(c->world, context, sizeof(Fl38cWorld) < sizeof c->world ? sizeof(Fl38cWorld) : sizeof c->world);
    c->id = callee;
    c->nargs = nargs;
    c->this_ptr = this_ptr;
    for (i = 0; i < nargs && i < 16; i++) c->arg[i] = args[i];
    /* only a host pointer (a local of the function under test) is read; any other value is an original address or a constant and is logged as such */
    if (s->deref_arg > 0 && args[s->deref_arg - 1] > 0xffffffffu) memcpy(c->data, (const void *)args[s->deref_arg - 1], (size_t)s->deref_bytes);
    {
        int at = 0;
        for (i = 0; i < s->nprobe; i++) {
            memcpy(c->probe + at, s->probe_ptr[i], (size_t)s->probe_len[i]);
            at += s->probe_len[i];
        }
    }
    for (i = 0; i < s->nwrites; i++) {
        const ShimWrite *w = &s->writes[i];
        if (w->call == s->used) memcpy((uint8_t *)args[w->arg] + w->offset, w->bytes, (size_t)w->nbytes);
    }
    if (s->nresults > 0) result = s->results[s->used < s->nresults ? s->used : s->nresults - 1];
    s->used++;
    return result;
}

enum { F38C_40430E = 1, F38C_404349, F38C_40492F, F38C_40496A, F38C_4049A5, F38C_4049E0, F38C_40893F, F38C_4043B6, F38C_40445A, F38C_4044FE, F38C_4045A2, F38C_404646, F38C_4046EA, F38C_454F29, F38C_457071, F38C_458137, F38C_46453B, F38C_466DB1, F38C_479D98, F38C_4465FD, F38C_4547BC, F38C_454F7C, F38C_46458E, F38C_46B855 };

/* Runs one port. `self` is the host memory of the object (the original ecx), `a` the stack arguments (host pointers for shift_rect, original values for new_zeroed), `w` the Fl38cWorld.
 * `result` is the return value (the eax of the last callee) of the ports that return one. */
void shim_fl38c(int fn, uint8_t *self, const uintptr_t *a, void *w, int32_t *result)
{
    Fl18Host host;
    Fl38cWorld *world = (Fl38cWorld *)w;
    *result = 0;
    memset(&host, 0, sizeof host);
    host.context = world;
    host.call = host_call;
    host.resolve = shim_resolve;
    (void)self;
    (void)a;
    
    switch (fn) {
    case F38C_40430E: *result = (int32_t)m40430e_read_word_setting(self, world, &host); break;
    case F38C_404349: *result = (int32_t)m404349_read_word_setting(self, world, &host); break;
    case F38C_40492F: *result = (int32_t)m40492f_read_word_setting(self, world, &host); break;
    case F38C_40496A: *result = (int32_t)m40496a_read_word_setting(self, world, &host); break;
    case F38C_4049A5: *result = (int32_t)m4049a5_read_word_setting(self, world, &host); break;
    case F38C_4049E0: *result = (int32_t)m4049e0_read_word_setting(self, world, &host); break;
    case F38C_40893F: *result = (int32_t)m40893f_read_word_setting(self, world, &host); break;
    case F38C_4043B6: *result = (int32_t)m4043b6_read_time_setting(self, world, &host); break;
    case F38C_40445A: *result = (int32_t)m40445a_read_time_setting(self, world, &host); break;
    case F38C_4044FE: *result = (int32_t)m4044fe_read_time_setting(self, world, &host); break;
    case F38C_4045A2: *result = (int32_t)m4045a2_read_time_setting(self, world, &host); break;
    case F38C_404646: *result = (int32_t)m404646_read_time_setting(self, world, &host); break;
    case F38C_4046EA: *result = (int32_t)m4046ea_read_time_setting(self, world, &host); break;
    case F38C_454F29: m454f29_shift_rect((const uint8_t *)a[0], (uint8_t *)a[1], world); break;
    case F38C_457071: m457071_shift_rect((const uint8_t *)a[0], (uint8_t *)a[1], world); break;
    case F38C_458137: m458137_shift_rect((const uint8_t *)a[0], (uint8_t *)a[1], world); break;
    case F38C_46453B: m46453b_shift_rect((const uint8_t *)a[0], (uint8_t *)a[1], world); break;
    case F38C_466DB1: m466db1_shift_rect((const uint8_t *)a[0], (uint8_t *)a[1], world); break;
    case F38C_479D98: m479d98_shift_rect((const uint8_t *)a[0], (uint8_t *)a[1], world); break;
    case F38C_4465FD: m4465fd_new_zeroed((uint32_t)a[0], (uint32_t)a[1], world, &host); break;
    case F38C_4547BC: m4547bc_new_zeroed((uint32_t)a[0], (uint32_t)a[1], world, &host); break;
    case F38C_454F7C: m454f7c_clamp_to_bounds(self, world); break;
    case F38C_46458E: m46458e_clamp_to_bounds(self, world); break;
    case F38C_46B855: m46b855_clamp_to_bounds(self, world); break;
    default: break;
    }
}
