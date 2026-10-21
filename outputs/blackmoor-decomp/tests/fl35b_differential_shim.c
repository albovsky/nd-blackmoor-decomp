/* Flat entry points for tests/test_fl35b_differential.py: each wraps one FL-35 (batch b) port (src/original_methods_fl35b.c) so that
 * ctypes can drive it on the same fixture as the original bytes run under Unicorn. One generic host logs every call (callee, ecx,
 * stack arguments, the bytes behind a pointer argument when the test asked for them) and a per-callee script tells it what to return
 * and which dwords / words / byte strings to store through a pointer argument. Pointers into fixture regions are turned back into the
 * fake original addresses by the test, pointers to a local of the function stay host pointers. */
#include <stdint.h>
#include <string.h>

#include "original_methods_fl35b.h"

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
    uint8_t world[256];   /* the first bytes of the Fl35bWorld snapshot at the call */
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
size_t shim_world_size(void) { return sizeof(Fl35bWorld); }

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
    if (context != NULL) memcpy(c->world, context, sizeof(Fl35bWorld) < sizeof c->world ? sizeof(Fl35bWorld) : sizeof c->world);
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

enum { F35B_4080FC = 1, F35B_40812E, F35B_408169, F35B_4081A4, F35B_4081DF, F35B_40821A, F35B_408255, F35B_408290, F35B_4082CB, F35B_408306, F35B_408341, F35B_40837C, F35B_4083B7, F35B_4083F2, F35B_40842D, F35B_408468, F35B_4084A3, F35B_4084DE, F35B_408519, F35B_408554, F35B_40858F, F35B_4085CA, F35B_408605, F35B_408640, F35B_40867B, F35B_4086B6, F35B_4086F1, F35B_40872C, F35B_408767, F35B_4087A2, F35B_4087DD, F35B_408818, F35B_408853, F35B_40888E, F35B_4088C9, F35B_408904 };

/* Runs one port on `self` (this). `result` is the return value of the port (the eax of its last callee). The world is the host context, so that each logged call keeps a snapshot of it. */
void shim_fl35b(int fn, uint8_t *self, const uintptr_t *a, Fl35bWorld *w, int32_t *result)
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
    case F35B_4080FC: *result = (int32_t)m4080fc_toggle_5ec28c(self, w, &host); break;
    case F35B_40812E: *result = (int32_t)m40812e_read_text_word(self, w, &host); break;
    case F35B_408169: *result = (int32_t)m408169_read_text_word(self, w, &host); break;
    case F35B_4081A4: *result = (int32_t)m4081a4_read_text_word(self, w, &host); break;
    case F35B_4081DF: *result = (int32_t)m4081df_read_text_word(self, w, &host); break;
    case F35B_40821A: *result = (int32_t)m40821a_read_text_word(self, w, &host); break;
    case F35B_408255: *result = (int32_t)m408255_read_text_word(self, w, &host); break;
    case F35B_408290: *result = (int32_t)m408290_read_text_word(self, w, &host); break;
    case F35B_4082CB: *result = (int32_t)m4082cb_read_text_word(self, w, &host); break;
    case F35B_408306: *result = (int32_t)m408306_read_text_word(self, w, &host); break;
    case F35B_408341: *result = (int32_t)m408341_read_text_word(self, w, &host); break;
    case F35B_40837C: *result = (int32_t)m40837c_read_text_word(self, w, &host); break;
    case F35B_4083B7: *result = (int32_t)m4083b7_read_text_word(self, w, &host); break;
    case F35B_4083F2: *result = (int32_t)m4083f2_read_text_word(self, w, &host); break;
    case F35B_40842D: *result = (int32_t)m40842d_read_text_word(self, w, &host); break;
    case F35B_408468: *result = (int32_t)m408468_read_text_word(self, w, &host); break;
    case F35B_4084A3: *result = (int32_t)m4084a3_read_text_word(self, w, &host); break;
    case F35B_4084DE: *result = (int32_t)m4084de_read_text_word(self, w, &host); break;
    case F35B_408519: *result = (int32_t)m408519_read_text_word(self, w, &host); break;
    case F35B_408554: *result = (int32_t)m408554_read_text_word(self, w, &host); break;
    case F35B_40858F: *result = (int32_t)m40858f_read_text_word(self, w, &host); break;
    case F35B_4085CA: *result = (int32_t)m4085ca_read_text_word(self, w, &host); break;
    case F35B_408605: *result = (int32_t)m408605_read_text_word(self, w, &host); break;
    case F35B_408640: *result = (int32_t)m408640_read_text_word(self, w, &host); break;
    case F35B_40867B: *result = (int32_t)m40867b_read_text_word(self, w, &host); break;
    case F35B_4086B6: *result = (int32_t)m4086b6_read_text_word(self, w, &host); break;
    case F35B_4086F1: *result = (int32_t)m4086f1_read_text_word(self, w, &host); break;
    case F35B_40872C: *result = (int32_t)m40872c_read_text_word(self, w, &host); break;
    case F35B_408767: *result = (int32_t)m408767_read_text_word(self, w, &host); break;
    case F35B_4087A2: *result = (int32_t)m4087a2_read_text_word(self, w, &host); break;
    case F35B_4087DD: *result = (int32_t)m4087dd_read_text_word(self, w, &host); break;
    case F35B_408818: *result = (int32_t)m408818_read_text_word(self, w, &host); break;
    case F35B_408853: *result = (int32_t)m408853_read_text_word(self, w, &host); break;
    case F35B_40888E: *result = (int32_t)m40888e_read_text_word(self, w, &host); break;
    case F35B_4088C9: *result = (int32_t)m4088c9_read_text_word(self, w, &host); break;
    case F35B_408904: *result = (int32_t)m408904_read_text_word(self, w, &host); break;
    default: break;
    }
}
