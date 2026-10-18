/* Flat entry points for tests/test_fl_differential.py: each wraps one native port (src/original_methods_fl*.c) so that ctypes can
 * drive it on the same fixture as the original bytes. Pointers into fixture regions are turned back into the fake original
 * addresses (shim_va) so that the call log is comparable with the log of the Unicorn run. */
#include <stdint.h>
#include <string.h>

#include "original_methods_fl16.h"
#include "original_methods_fl17.h"
#include "original_methods_fl18.h"

typedef struct ShimRegion {
    uint32_t va;
    uint8_t *ptr;
    uint32_t len;
} ShimRegion;

typedef struct ShimCall {
    uint32_t id;          /* FL-17: CALL_*; FL-18: the original address of the callee */
    int32_t nargs;
    uint64_t this_ptr;
    uint64_t arg[8];
    uint8_t data[2][32];  /* bytes behind a pointer argument that the test asked to see (shim_script_deref) */
} ShimCall;

enum { CALL_FREE = 1, CALL_UNMAP = 2, CALL_CLOSE = 3, CALL_4EA06C = 4 };

static ShimRegion g_regions[16];
static int g_region_count;
static ShimCall g_calls[128];
static int g_call_count;

void shim_reset(void)
{
    g_region_count = 0;
    g_call_count = 0;
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

static uint32_t shim_va(const uint8_t *p)
{
    int i;
    for (i = 0; i < g_region_count; i++)
        if (p >= g_regions[i].ptr && p < g_regions[i].ptr + g_regions[i].len)
            return g_regions[i].va + (uint32_t)(p - g_regions[i].ptr);
    return 0xdeadbeefu;
}

const uint8_t *shim_resolve(void *context, uint32_t address)
{
    int i;
    (void)context;
    for (i = 0; i < g_region_count; i++)
        if (address >= g_regions[i].va && address < g_regions[i].va + g_regions[i].len)
            return g_regions[i].ptr + (address - g_regions[i].va);
    return NULL;
}

static void record(uint32_t id, uint32_t a0, uint32_t a1)
{
    ShimCall *c = &g_calls[g_call_count++];
    memset(c, 0, sizeof *c);
    c->id = id;
    c->arg[0] = a0;
    c->arg[1] = a1;
}

static void host_free(void *context, uint32_t address) { (void)context; record(CALL_FREE, address, 0); }
static void host_unmap(void *context, uint32_t address) { (void)context; record(CALL_UNMAP, address, 0); }
static void host_close(void *context, uint32_t handle) { (void)context; record(CALL_CLOSE, handle, 0); }
static void host_4ea06c(void *context, uint8_t *self, uint16_t value)
{
    (void)context;
    record(CALL_4EA06C, shim_va(self), value);
}

static void host_init(Fl17Host *host)
{
    memset(host, 0, sizeof *host);
    host->resolve = shim_resolve;
    host->free_51dc6c = host_free;
    host->unmap_view = host_unmap;
    host->close_handle = host_close;
    host->call_4ea06c = host_4ea06c;
}

/* 0x42ca22: key is the word at 0x5b4e00; a NULL table or owner stands for a zero dword. flags points at the dword table's
 * address 0x585801 (the caller leaves slack below it for negative indexes). */
void shim_m42ca22(int16_t key, const uint8_t *table, const uint8_t *owner, uint8_t *flags)
{
    Fl17World world;
    memset(&world, 0, sizeof world);
    world.key_5b4e00 = key;
    world.table_5b4ea5 = table;
    world.owner_5b4ead = owner;
    world.flags_585801 = flags;
    m42ca22_apply_event_flags(&world);
}

/* 0x48c0ac: records points at the address 0x5bb5e5 (with slack below for record -1). */
void shim_m48c0ac(uint8_t *self, uint32_t value_5c39e5, uint8_t *records)
{
    Fl17World world;
    Fl17Host host;
    memset(&world, 0, sizeof world);
    host_init(&host);
    world.value_5c39e5 = value_5c39e5;
    world.records_5bb5e5 = records;
    m48c0ac_accept_piece(self, &world, &host);
}

void shim_m415011(uint8_t *arg)
{
    Fl17Host host;
    host_init(&host);
    m415011_close_handles(arg, &host);
}

/* 0x4eac4c: value_583a29 is read and written through *word_583a29. */
void shim_m4eac4c(uint8_t *self, int16_t index, int16_t *word_583a29, uint8_t *records)
{
    Fl17World world;
    Fl17Host host;
    memset(&world, 0, sizeof world);
    host_init(&host);
    world.value_583a29 = *word_583a29;
    world.records_5bb5e5 = records;
    m4eac4c_use_item(self, index, &world, &host);
    *word_583a29 = world.value_583a29;
}

/* ---- FL-18: one generic host that logs every call, and a script that tells it what to return / write ---------------------- */
typedef struct ShimScript {
    uint32_t callee;
    uint32_t results[16];
    int nresults, used;
    int has_out, out_is_pointer;
    uint64_t out_value;
    int deref_arg, deref_bytes;
} ShimScript;

static ShimScript g_script[16];
static int g_script_count;
static uint32_t g_tick;

void shim_script_reset(void)
{
    g_script_count = 0;
    memset(g_script, 0, sizeof g_script);
}

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

/* the callee writes `value` through args[0]: a dword, or (is_pointer) a host pointer made from the original address `value` */
void shim_script_out(uint32_t callee, uint64_t value, int is_pointer)
{
    ShimScript *s = script_for(callee);
    s->has_out = 1;
    s->out_value = value;
    s->out_is_pointer = is_pointer;
}

void shim_script_deref(uint32_t callee, int arg, int bytes)
{
    ShimScript *s = script_for(callee);
    s->deref_arg = arg + 1;
    s->deref_bytes = bytes;
}

void shim_set_tick(uint32_t tick) { g_tick = tick; }

static uint32_t host18_call(void *context, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
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
    if (s->deref_arg > 0) memcpy(c->data[0], (const void *)args[s->deref_arg - 1], (size_t)s->deref_bytes);
    if (s->has_out) {
        if (s->out_is_pointer) {
            uint8_t *p = (uint8_t *)(uintptr_t)shim_resolve(NULL, (uint32_t)s->out_value);
            memcpy((void *)args[0], &p, sizeof p);
        } else {
            uint32_t v = (uint32_t)s->out_value;
            memcpy((void *)args[0], &v, sizeof v);
        }
    }
    if (s->nresults > 0) {
        result = s->results[s->used < s->nresults ? s->used : s->nresults - 1];
        s->used++;
    }
    return result;
}

static uint32_t host18_tick(void *context)
{
    (void)context;
    return g_tick;
}

typedef struct ShimWorld {
    uint8_t *records, *words_5afbda, *dwords_5d032f, *table_5a1e62, *table_5d1599, *bytes_5495b0, *bytes_54b158, *flags_585801, *string_5b618e;
    uint32_t value_5cf665;
    int32_t word_61d467, word_61d465;
    uint32_t word_5a1e5c;
    uint32_t value_5c39e5, value_5d0377, value_5d162d, value_5b44f0, value_5b44f4, value_5d1631, value_5d1639;
    uint32_t value_638483, value_63848d;
    int32_t origin_x, origin_y;
    uint32_t value_5bb1ca;
    uint32_t value_5d19fb, value_5839a9, value_5c39f9, value_5bb57b, value_5bb59b, value_5bb59f, value_5bb5a3, value_583999;
    uint32_t word_5bb599, word_5bb595, word_5c39ff;
    int32_t word_5b61b0;
    uint32_t value_5d15e3, word_5b61dd, word_5b61d1, word_5b61e1, word_5b61ed;
    int32_t result;
} ShimWorld;

enum {
    F18_4C924D = 1, F18_4121B8, F18_4E7BF3, F18_4B7051, F18_4B7F3B, F18_4B7FF4, F18_4E7253, F18_4E8DC8, F18_45B7A8, F18_4B81FF,
    F18_423B51, F18_4CC79A, F18_4B6097, F18_4B8D5E, F18_410F99, F18_44D624, F18_4631D1,
    F18_41632B, F18_4C08D3, F18_4C0774, F18_4D07E7
};

/* Runs one FL-18 method. For 0x410f99 `self` is dst and `src` comes through the world's bytes_5495b0 field. */
void shim_fl18(int fn, uint8_t *self, int32_t a, int32_t b, ShimWorld *sw)
{
    Fl18World w;
    Fl18Host host;
    memset(&w, 0, sizeof w);
    memset(&host, 0, sizeof host);
    host.call = host18_call;
    host.resolve = shim_resolve;
    host.tick = host18_tick;
    w.records_5bb5e5 = sw->records;
    w.words_5afbda = sw->words_5afbda;
    w.dwords_5d032f = sw->dwords_5d032f;
    w.flags_585801 = sw->flags_585801;
    w.string_5b618e = sw->string_5b618e;
    w.table_5a1e62 = sw->table_5a1e62;
    w.table_5d1599 = sw->table_5d1599;
    w.bytes_5495b0 = sw->bytes_5495b0;
    w.bytes_54b158 = sw->bytes_54b158;
    w.value_5cf665 = sw->value_5cf665;
    w.word_61d467 = (int16_t)sw->word_61d467;
    w.word_61d465 = (int16_t)sw->word_61d465;
    w.word_5a1e5c = (uint16_t)sw->word_5a1e5c;
    w.value_5c39e5 = sw->value_5c39e5;
    w.value_5d0377 = sw->value_5d0377;
    w.value_5d162d = sw->value_5d162d;
    w.value_5b44f0 = sw->value_5b44f0;
    w.value_5b44f4 = sw->value_5b44f4;
    w.value_5d1631 = sw->value_5d1631;
    w.value_5d1639 = sw->value_5d1639;
    w.value_638483 = sw->value_638483;
    w.value_63848d = sw->value_63848d;
    w.origin_x_583186 = sw->origin_x;
    w.origin_y_58318a = sw->origin_y;
    w.value_5bb1ca = sw->value_5bb1ca;
    w.value_5d19fb = sw->value_5d19fb;
    w.value_5839a9 = sw->value_5839a9;
    w.value_5c39f9 = sw->value_5c39f9;
    w.value_5bb57b = sw->value_5bb57b;
    w.value_5bb59b = sw->value_5bb59b;
    w.value_5bb59f = sw->value_5bb59f;
    w.value_5bb5a3 = sw->value_5bb5a3;
    w.value_583999 = sw->value_583999;
    w.word_5bb599 = (uint16_t)sw->word_5bb599;
    w.word_5bb595 = (uint16_t)sw->word_5bb595;
    w.word_5c39ff = (uint16_t)sw->word_5c39ff;
    w.word_5b61b0 = (int16_t)sw->word_5b61b0;
    w.value_5d15e3 = sw->value_5d15e3;
    w.word_5b61dd = (uint16_t)sw->word_5b61dd;
    w.word_5b61d1 = (uint16_t)sw->word_5b61d1;
    w.word_5b61e1 = (uint16_t)sw->word_5b61e1;
    w.word_5b61ed = (uint16_t)sw->word_5b61ed;
    switch (fn) {
    case F18_4C924D: m4c924d_count_up((int16_t)a, &w, &host); break;
    case F18_4121B8: m4121b8_start_piece(self, (int16_t)a, &w, &host); break;
    case F18_4E7BF3: m4e7bf3_close_slots(self, &host); break;
    case F18_4B7051: m4b7051_draw_list(&w, &host); break;
    case F18_4B7F3B: m4b7f3b_reset(self); break;
    case F18_4B7FF4: m4b7ff4_release(self, &host); break;
    case F18_4E7253: m4e7253_store_record(self, (int16_t)a, &w, &host); break;
    case F18_4E8DC8: m4e8dc8_check_slots(self, &host); break;
    case F18_45B7A8: m45b7a8_arm_hotspot(self, (int16_t)a, (int16_t)b, &w); break;
    case F18_4B81FF: sw->result = m4b81ff_hit_test(self, (int16_t)a, (int16_t)b, &w, &host); break;
    case F18_423B51: m423b51_reset_record(self, a, &w, &host); break;
    case F18_4CC79A: m4cc79a_draw_rects(&w, &host); break;
    case F18_4B6097: m4b6097_arm_hotspot(self, (int16_t)a, (int16_t)b, &w); break;
    case F18_4B8D5E: m4b8d5e_expire_slots(self, &host); break;
    case F18_410F99: m410f99_init_entry(self, sw->bytes_5495b0, (int16_t)a, (uint8_t)b); break;
    case F18_44D624: m44d624_arm_timer(self, &w, &host); break;
    case F18_4631D1: m4631d1_check_piece(self, &w, &host); break;
    case F18_41632B: m41632b_free_buffers(self, &host); break;
    case F18_4C08D3: m4c08d3_shift_rects(self, &w, &host); break;
    case F18_4C0774: m4c0774_open_piece(self, (int16_t)a, &w, &host); break;
    case F18_4D07E7: m4d07e7_draw_texts(&w, &host); break;
    default: break;
    }
    sw->word_5a1e5c = w.word_5a1e5c;
    sw->value_5c39e5 = w.value_5c39e5;
    sw->value_5d162d = w.value_5d162d;
    sw->value_5b44f0 = w.value_5b44f0;
    sw->value_5b44f4 = w.value_5b44f4;
    sw->value_5d1631 = w.value_5d1631;
    sw->value_5d1639 = w.value_5d1639;
    sw->value_638483 = w.value_638483;
    sw->value_5bb1ca = w.value_5bb1ca;
    sw->value_5d19fb = w.value_5d19fb;
    sw->value_5839a9 = w.value_5839a9;
    sw->value_5c39f9 = w.value_5c39f9;
    sw->value_5bb57b = w.value_5bb57b;
    sw->value_5bb59b = w.value_5bb59b;
    sw->value_5bb59f = w.value_5bb59f;
    sw->value_5bb5a3 = w.value_5bb5a3;
    sw->value_583999 = w.value_583999;
    sw->word_5bb599 = w.word_5bb599;
    sw->word_5bb595 = w.word_5bb595;
    sw->word_5c39ff = w.word_5c39ff;
}

/* ---- FL-16 ports (src/original_methods_fl16.c) ---- */
static uint32_t host16_tick(void *context)
{
    (void)context;
    return g_tick;
}

static void host16_4b8a27(void *context, uint8_t *self, int32_t arg)
{
    ShimCall *c = &g_calls[g_call_count++];
    (void)context;
    memset(c, 0, sizeof *c);
    c->id = 0x4b8a27;
    c->nargs = 1;
    c->this_ptr = (uint64_t)(uintptr_t)self;
    c->arg[0] = (uint32_t)arg;
}

uint32_t shim16_434773(const uint8_t *text) { return m434773_is_data_tag(text); }
uint32_t shim16_4347b8(const uint8_t *bytes) { return m4347b8_read_be32(bytes); }

void shim16_43f04b(uint8_t *dst, const uint8_t *src, int32_t rows, uint32_t row_bytes, int32_t src_stride)
{
    m43f04b_copy_rows(dst, src, rows, row_bytes, src_stride);
}

void shim16_rect(int which, const int32_t *src, int32_t *dst, int32_t origin_x, int32_t origin_y)
{
    Fl16World world;
    memset(&world, 0, sizeof world);
    world.origin_x_583186 = origin_x;
    world.origin_y_58318a = origin_y;
    if (which == 0x44d9b5) m44d9b5_shift_rect(src, dst, &world);
    else m45b568_shift_rect(src, dst, &world);
}

void shim16_4b8e42(uint8_t *self, int16_t slot, const uint8_t *deadlines, uint32_t tick)
{
    Fl16World world;
    Fl16Host host;
    memset(&world, 0, sizeof world);
    memset(&host, 0, sizeof host);
    world.deadlines_61eee1 = deadlines;
    host.tick = host16_tick;
    host.call_4b8a27 = host16_4b8a27;
    g_tick = tick;
    m4b8e42_expire_slot(self, slot, &world, &host);
}
