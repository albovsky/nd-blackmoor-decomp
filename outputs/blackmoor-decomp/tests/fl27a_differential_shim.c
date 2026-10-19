/* Flat entry points for tests/test_fl27a_differential.py: each wraps one FL-27 (batch a) port (src/original_methods_fl27a.c) so that
 * ctypes can drive it on the same fixture as the original bytes run under Unicorn. One generic host logs every call (callee, ecx,
 * stack arguments, the memory at the probed host addresses and a snapshot of the world, both taken at the call) and a per-callee script
 * tells it what to return and which values to store at which host addresses at its n-th call (the other thread that a waiting loop waits
 * for, or the effect of a call on a handle). Pointers into fixture regions are turned back into the fake original addresses by the
 * test, pointers into the function's own objects stay host pointers. */
#include <stdint.h>
#include <string.h>

#include "original_methods_fl27a.h"

typedef struct ShimRegion {
    uint32_t va;
    uint8_t *ptr;
    uint32_t len;
} ShimRegion;

typedef struct ShimCall {
    uint32_t id;          /* the original address of the callee (an import: its IAT slot) */
    int32_t nargs;
    uint64_t this_ptr;
    uint64_t arg[12];
    uint8_t data[64];     /* unused (the layout of the FL-26 shim) */
    uint8_t probe[4096];  /* bytes at the probed host addresses (shim_script_probe), concatenated, read at the call */
    uint8_t world[256];   /* the first bytes of the Fl27aWorld snapshot at the call */
} ShimCall;

typedef struct ShimPoke {
    int call, size;
    uint8_t *ptr;
    uint32_t value;
} ShimPoke;

typedef struct ShimScript {
    uint32_t callee;
    uint32_t results[512];
    int nresults, used;
    const uint8_t *probe_ptr[8];
    int probe_len[8], nprobe;
    ShimPoke pokes[256];
    int npokes;
} ShimScript;

static ShimRegion g_regions[16];
static int g_region_count;
static ShimCall g_calls[1024];
static int g_call_count;
static ShimScript g_script[24];
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
size_t shim_world_size(void) { return sizeof(Fl27aWorld); }

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

/* the bytes at the host address `p` (`bytes` of them) are copied into every logged call of `callee`, as they are at the call */
void shim_script_probe(uint32_t callee, const uint8_t *p, int bytes)
{
    ShimScript *s = script_for(callee);
    s->probe_ptr[s->nprobe] = p;
    s->probe_len[s->nprobe] = bytes;
    s->nprobe++;
}

/* the call number `call` (0 based) of `callee` stores `size` bytes (2 or 4, or 1) of `value` at the host address `p`, after the probes were read */
void shim_script_poke(uint32_t callee, int call, uint8_t *p, int size, uint32_t value)
{
    ShimScript *s = script_for(callee);
    ShimPoke *w = &s->pokes[s->npokes++];
    w->call = call;
    w->ptr = p;
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
    memset(c, 0, sizeof *c);
    if (context != NULL) memcpy(c->world, context, sizeof(Fl27aWorld) < sizeof c->world ? sizeof(Fl27aWorld) : sizeof c->world);
    c->id = callee;
    c->nargs = nargs;
    c->this_ptr = this_ptr;
    for (i = 0; i < nargs && i < 12; i++) c->arg[i] = args[i];
    {
        int at = 0;
        for (i = 0; i < s->nprobe; i++) {
            memcpy(c->probe + at, s->probe_ptr[i], (size_t)s->probe_len[i]);
            at += s->probe_len[i];
        }
    }
    for (i = 0; i < s->npokes; i++) {
        const ShimPoke *w = &s->pokes[i];
        if (w->call == s->used) memcpy(w->ptr, &w->value, (size_t)w->size);
    }
    if (s->nresults > 0) result = s->results[s->used < s->nresults ? s->used : s->nresults - 1];
    s->used++;
    return result;
}

enum { F27A_4DE1F5 = 1 , F27A_4DE214 , F27A_4DE2D8 , F27A_449D90 , F27A_44C479 , F27A_4BEE2C , F27A_4BEF85 , F27A_4BEE5F , F27A_4BEFC8 /*ENUM*/ };

/* Runs one port. `self` is `this` (NULL for the functions without one), a[0..7] the stack arguments as the original passes them (an original
 * address, a value). `result` is the return value of the ports that have one (a pointer is returned as its host address). The world is the
 * host context, so that each logged call keeps a snapshot of it. */
void shim_fl27a(int fn, uint8_t *self, const uint64_t *a, Fl27aWorld *w, uint64_t *result)
{
    Fl18Host host;
    *result = 0;
    memset(&host, 0, sizeof host);
    host.context = w;
    host.call = host_call;
    host.resolve = shim_resolve;

    (void)a;
    switch (fn) {
    case F27A_4DE1F5: m4de1f5_clear_flags(self, w); break;
    case F27A_4DE214: m4de214_clear_flags_thunk(self, w); break;
    case F27A_4DE2D8: m4de2d8_reset_caption(self, w, &host); break;
    case F27A_449D90: *result = (uint32_t)m449d90_file_exists((uint32_t)a[0], &host); break;
    case F27A_44C479: *result = (uint32_t)m44c479_wait_state((uint32_t)a[0], w, &host); break;
    case F27A_4BEE2C: *result = (uint32_t)m4bee2c_get_field(self, (uint32_t)a[0], &host); break;
    case F27A_4BEF85: *result = (uint32_t)m4bef85_bink_wait(self, (uint32_t)a[0], &host); break;
    case F27A_4BEE5F: *result = (uint64_t)(uintptr_t)m4bee5f_bink_summary(self, (uint32_t)a[0], &host); break;
    case F27A_4BEFC8: *result = (uint32_t)m4befc8_bink_do_frame(self, (uint32_t)a[0], &host); break;
    /*CASES*/
    default: break;
    }
}
