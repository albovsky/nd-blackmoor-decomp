/* RT-57 unit cases for raw 0x1c, the interactive video: the kernel (src/action_family_1c_runtime.c, the ".IV" loader 0x4cbba9, the
 * handler 0x4cb586 and the render callback 0x4cc79a) and the binding (src/session_bindings_a1c.c). The ".IV" files are game data
 * and are not in the repository: this file writes synthetic ones (33-byte name, entry count dword, then per entry a 9-byte header
 * {id word, hotspot count word, byte, word, word} and count * 24 bytes of rectangles). Prints "PASS name" / "FAIL name: reason". */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "session_bindings_a1c.h"

static int failures;

#define CHECK(name, cond)                                             \
    do {                                                              \
        if (!(cond)) {                                                \
            printf("FAIL %s: %s (line %d)\n", name, #cond, __LINE__); \
            ++failures;                                               \
            return;                                                   \
        }                                                             \
    } while (0)
#define PASS(name) printf("PASS %s\n", name)

/* ---- byte helpers ------------------------------------------------------------------------------------------------------- */
typedef struct {
    uint8_t *p;
    size_t n, cap;
} Bytes;

static void bput(Bytes *b, const void *data, size_t n)
{
    if (b->n + n > b->cap) {
        b->cap = (b->n + n) * 2u + 64u;
        b->p = (uint8_t *)realloc(b->p, b->cap);
        if (b->p == NULL) abort();
    }
    memcpy(b->p + b->n, data, n);
    b->n += n;
}

static void b8(Bytes *b, uint8_t v)
{
    bput(b, &v, 1u);
}

static void b16(Bytes *b, uint16_t v)
{
    uint8_t t[2];
    t[0] = (uint8_t)v;
    t[1] = (uint8_t)(v >> 8);
    bput(b, t, 2u);
}

static void b32(Bytes *b, uint32_t v)
{
    b16(b, (uint16_t)v);
    b16(b, (uint16_t)(v >> 16));
}

static void put16(uint8_t *p, unsigned at, uint16_t v)
{
    p[at] = (uint8_t)v;
    p[at + 1u] = (uint8_t)(v >> 8);
}

/* A file name field (33 bytes, NUL padded) and the entry count. */
static void iv_header(Bytes *b, const char *name, int32_t entries)
{
    uint8_t field[C1C_NAME_BYTES];
    memset(field, 0, sizeof field);
    memcpy(field, name, strlen(name) > 32u ? 32u : strlen(name));
    bput(b, field, sizeof field);
    b32(b, (uint32_t)entries);
}

static void iv_entry(Bytes *b, int16_t id, int16_t count, uint8_t byte4, int16_t w5, int16_t w7)
{
    b16(b, (uint16_t)id);
    b16(b, (uint16_t)count);
    b8(b, byte4);
    b16(b, (uint16_t)w5);
    b16(b, (uint16_t)w7);
}

static void iv_rect(Bytes *b, const int32_t d[6])
{
    int k;
    for (k = 0; k < 6; ++k) b32(b, (uint32_t)d[k]);
}

/* Deterministic rectangle j of entry i. */
static void rect_value(int32_t d[6], int i, int j)
{
    d[0] = 7 * i + j;
    d[1] = 100 * i + j;
    d[2] = 200 * i + 2 * j;
    d[3] = 300 * i + 3 * j;
    d[4] = 400 * i + 4 * j;
    d[5] = -(i + j);
}

/* name, `entries` entries with ids 10 + i and `rects` rectangles each. */
static void iv_simple(Bytes *b, const char *name, int entries, int rects)
{
    int i, j;
    iv_header(b, name, entries);
    for (i = 0; i < entries; ++i) {
        iv_entry(b, (int16_t)(10 + i), (int16_t)rects, (uint8_t)(i + 1), (int16_t)(i * 3), (int16_t)(-i));
        for (j = 0; j < rects; ++j) {
            int32_t d[6];
            rect_value(d, i, j);
            iv_rect(b, d);
        }
    }
}

/* ---- scripted host ------------------------------------------------------------------------------------------------------ */
enum { EV_OPEN = 1, EV_READ, EV_CLOSE, EV_STATE, EV_NAME, EV_HOTSPOT, EV_ORIGIN, EV_ALLOC, EV_REGISTER, EV_RELEASE, EV_CELL };

typedef struct {
    int ev[96];
    int nev;
    /* player */
    int32_t state;
    uint8_t name[C1C_NAME_BYTES];
    int16_t hotspot;
    int origin_present;
    int32_t dx, dy;
    int state_calls, override_call;
    int32_t override_state;
    int fail_state_call; /* the Nth state call fails (1-based) */
    int fail_name, fail_hotspot, fail_origin, fail_cell;
    int16_t cell;
    /* file */
    const uint8_t *data;
    size_t len, pos;
    int open_fail, open_null;
    int opens, closes, reads;
    char opened_name[160];
    size_t read_sizes[16];
    /* z entry */
    int16_t next_slot;
    int fail_alloc, fail_register, fail_release;
    int allocs, registers, releases;
    int16_t registered_slot, released_slot;
    char label[48];
} Rig;

static void ev(Rig *r, int e)
{
    if (r->nev < (int)(sizeof r->ev / sizeof r->ev[0])) r->ev[r->nev++] = e;
}

static int h_state(void *c, int32_t *s)
{
    Rig *r = (Rig *)c;
    ev(r, EV_STATE);
    ++r->state_calls;
    if (r->fail_state_call == r->state_calls) return 1;
    *s = (r->override_call == r->state_calls) ? r->override_state : r->state;
    return 0;
}

static int h_name(void *c, uint8_t name[C1C_NAME_BYTES])
{
    Rig *r = (Rig *)c;
    ev(r, EV_NAME);
    if (r->fail_name) return 1;
    memcpy(name, r->name, C1C_NAME_BYTES);
    return 0;
}

static int h_hotspot(void *c, int16_t *index)
{
    Rig *r = (Rig *)c;
    ev(r, EV_HOTSPOT);
    if (r->fail_hotspot) return 1;
    *index = r->hotspot;
    return 0;
}

static int h_origin(void *c, int *present, int32_t *dx, int32_t *dy)
{
    Rig *r = (Rig *)c;
    ev(r, EV_ORIGIN);
    if (r->fail_origin) return 1;
    *present = r->origin_present;
    *dx = r->dx;
    *dy = r->dy;
    return 0;
}

static int h_open(void *c, const char *name, void **file)
{
    Rig *r = (Rig *)c;
    ev(r, EV_OPEN);
    ++r->opens;
    strncpy(r->opened_name, name, sizeof r->opened_name - 1u);
    if (r->open_fail) return 1;
    r->pos = 0u;
    *file = r->open_null ? NULL : (void *)r;
    return 0;
}

static size_t h_read(void *c, void *file, void *buffer, size_t size)
{
    Rig *r = (Rig *)c;
    size_t left = r->len - r->pos;
    size_t n = size < left ? size : left;
    (void)file;
    if (r->reads < 16) r->read_sizes[r->reads] = size;
    ++r->reads;
    memcpy(buffer, r->data + r->pos, n);
    r->pos += n;
    return n;
}

static void h_close(void *c, void *file)
{
    Rig *r = (Rig *)c;
    (void)file;
    ev(r, EV_CLOSE);
    ++r->closes;
}

static int h_alloc(void *c, int16_t *slot)
{
    Rig *r = (Rig *)c;
    ev(r, EV_ALLOC);
    ++r->allocs;
    if (r->fail_alloc) return 1;
    *slot = r->next_slot;
    return 0;
}

static int h_register(void *c, int16_t slot, const char *label)
{
    Rig *r = (Rig *)c;
    ev(r, EV_REGISTER);
    ++r->registers;
    r->registered_slot = slot;
    strncpy(r->label, label, sizeof r->label - 1u);
    return r->fail_register;
}

static int h_release(void *c, int16_t slot)
{
    Rig *r = (Rig *)c;
    ev(r, EV_RELEASE);
    ++r->releases;
    r->released_slot = slot;
    return r->fail_release;
}

static int h_cell(void *c, int16_t *value)
{
    Rig *r = (Rig *)c;
    ev(r, EV_CELL);
    if (r->fail_cell) return 1;
    *value = r->cell;
    return 0;
}

static void rig_init(Rig *r, const char *name, const Bytes *file)
{
    memset(r, 0, sizeof *r);
    r->hotspot = -1;
    r->state = 2;
    r->cell = -1;
    r->next_slot = 0x18;
    memcpy(r->name, name, strlen(name));
    r->data = file != NULL ? file->p : NULL;
    r->len = file != NULL ? file->n : 0u;
}

static void rig_clear_counts(Rig *r)
{
    r->nev = 0;
    r->state_calls = 0;
    r->opens = r->closes = r->reads = 0;
    r->allocs = r->registers = r->releases = 0;
}

static C1cHost host_of(Rig *r)
{
    C1cHost h;
    memset(&h, 0, sizeof h);
    h.context = r;
    h.player_state = h_state;
    h.player_name = h_name;
    h.player_hotspot = h_hotspot;
    h.player_origin = h_origin;
    h.open_iv = h_open;
    h.read = h_read;
    h.close = h_close;
    h.alloc_slot = h_alloc;
    h.register_slot = h_register;
    h.release_slot = h_release;
    h.cell_583a29 = h_cell;
    return h;
}

static void drop_callback(C1cHost *h, size_t i)
{
    switch (i) {
    case 0: h->player_state = NULL; break;
    case 1: h->player_name = NULL; break;
    case 2: h->player_hotspot = NULL; break;
    case 3: h->player_origin = NULL; break;
    case 4: h->open_iv = NULL; break;
    case 5: h->read = NULL; break;
    case 6: h->close = NULL; break;
    case 7: h->alloc_slot = NULL; break;
    case 8: h->register_slot = NULL; break;
    case 9: h->release_slot = NULL; break;
    default: h->cell_583a29 = NULL; break;
    }
}

/* A 105-byte row body: the name at 0, the render word at 0x21. */
static void make_body(uint8_t body[C1C_BODY_BYTES], const char *name, uint16_t render)
{
    memset(body, 0, C1C_BODY_BYTES);
    memcpy(body, name, strlen(name));
    put16(body, C1C_BODY_RENDER_WORD, render);
}

static void info_for(SceneActionInfo *info, const uint8_t *raw, size_t len)
{
    memset(info, 0, sizeof *info);
    info->type = SESSION_A1C_TYPE;
    info->subtype = 1u;
    info->raw_body = raw;
    info->raw_body_length = len;
}

static int events_are(const Rig *r, const int *expected, int n)
{
    return r->nev == n && memcmp(r->ev, expected, (size_t)n * sizeof(int)) == 0;
}

/* A ready kernel object after one phase 0 visit that matched (state 2, equal names). */
static int ready(C1cObject *o, Rig *r, const C1cHost *h, const uint8_t *body, C1cOutcome *out)
{
    (void)r;
    c1c_object_reset(o);
    return c1c_visit(o, body, 0u, h, out);
}

/* ---- loading ------------------------------------------------------------------------------------------------------------ */
static void test_load_layouts(void)
{
    const char *n = "load layouts";
    static const int shapes[][2] = {{0, 0}, {1, 1}, {1, 3}, {5, 2}, {40, 1}, {3, 7}};
    size_t s;
    for (s = 0; s < sizeof shapes / sizeof shapes[0]; ++s) {
        Bytes f = {0, 0, 0};
        Rig r;
        C1cObject o;
        C1cHost h;
        C1cOutcome out;
        uint8_t body[C1C_BODY_BYTES];
        int i, j;
        iv_simple(&f, "MOVIE_A", shapes[s][0], shapes[s][1]);
        rig_init(&r, "MOVIE_A", &f);
        h = host_of(&r);
        make_body(body, "IVFILE", 0);
        CHECK(n, ready(&o, &r, &h, body, &out) == C1C_OK);
        CHECK(n, o.iv != NULL && o.iv->count == shapes[s][0]);
        CHECK(n, memcmp(o.iv->name, "MOVIE_A", 7) == 0 && o.iv->name[7] == 0);
        CHECK(n, strcmp(r.opened_name, "IVFILE") == 0 && r.opens == 1 && r.closes == 1);
        for (i = 0; i < shapes[s][0]; ++i) {
            const C1cEntry *e = &o.iv->entries[i];
            CHECK(n, e->id == 10 + i && e->count == shapes[s][1] && e->byte_4 == (uint8_t)(i + 1));
            CHECK(n, e->word_5 == i * 3 && e->word_7 == -i);
            for (j = 0; j < shapes[s][1]; ++j) {
                int32_t d[6];
                int k;
                rect_value(d, i, j);
                for (k = 0; k < 6; ++k) CHECK(n, e->rects[j].d[k] == d[k]);
            }
        }
        o.record = shapes[s][0] > 0 ? &o.iv->entries[0] : NULL;
        if (o.record == NULL) o.record = (const C1cEntry *)&o; /* a stale pointer either way */
        c1c_free_iv(&o);
        CHECK(n, o.iv == NULL && o.record == NULL);
        free(f.p);
    }
    PASS(n);
}

static void test_ids_are_signed_words(void)
{
    const char *n = "entry ids are signed 16-bit words";
    static const int16_t ids[] = {0x1234, -1, -2, 0x7fff, -32768, 0x0100, 0x00ff};
    Bytes f = {0, 0, 0};
    Rig r;
    C1cObject o;
    C1cHost h;
    C1cOutcome out;
    uint8_t body[C1C_BODY_BYTES];
    size_t i;
    iv_header(&f, "M", (int32_t)(sizeof ids / sizeof ids[0]));
    for (i = 0; i < sizeof ids / sizeof ids[0]; ++i) {
        int32_t d[6] = {0, (int32_t)i, 0, 0, 0, 0};
        iv_entry(&f, ids[i], 1, 0, 0, 0);
        iv_rect(&f, d);
    }
    rig_init(&r, "M", &f);
    h = host_of(&r);
    make_body(body, "X", 0);
    CHECK(n, ready(&o, &r, &h, body, &out) == C1C_OK && o.record == NULL); /* hotspot -1 is "none" even when an entry has id -1 */
    for (i = 0; i < sizeof ids / sizeof ids[0]; ++i) {
        if (ids[i] == -1) continue;
        r.hotspot = ids[i];
        CHECK(n, c1c_visit(&o, body, 1u, &h, &out) == C1C_OK);
        CHECK(n, o.record == &o.iv->entries[i] && o.last_index == ids[i]);
    }
    c1c_free_iv(&o);
    free(f.p);
    PASS(n);
}

static void test_phase1_without_file(void)
{
    const char *n = "phase 1 on an object with no file";
    Rig r;
    C1cObject o;
    C1cHost h;
    C1cOutcome out;
    uint8_t body[C1C_BODY_BYTES];
    rig_init(&r, "M", NULL);
    r.hotspot = 10;
    h = host_of(&r);
    make_body(body, "X", 0);
    c1c_object_reset(&o);
    CHECK(n, c1c_visit(&o, body, 1u, &h, &out) == C1C_OK && out.phase == 1u && o.record == NULL && o.changed == 0);
    PASS(n);
}

static void test_load_read_sizes(void)
{
    const char *n = "load read sizes";
    Bytes f = {0, 0, 0};
    Rig r;
    C1cObject o;
    C1cHost h;
    C1cOutcome out;
    uint8_t body[C1C_BODY_BYTES];
    static const size_t expected[] = {33u, 4u, 2u, 2u, 1u, 2u, 2u, 24u};
    iv_simple(&f, "M", 1, 1);
    rig_init(&r, "M", &f);
    h = host_of(&r);
    make_body(body, "X", 0);
    CHECK(n, ready(&o, &r, &h, body, &out) == C1C_OK);
    CHECK(n, r.reads == 8 && memcmp(r.read_sizes, expected, sizeof expected) == 0);
    CHECK(n, r.pos == f.n);
    c1c_free_iv(&o);
    free(f.p);
    PASS(n);
}

static void test_repeated_ids(void)
{
    const char *n = "repeated ids first match wins";
    Bytes f = {0, 0, 0};
    Rig r;
    C1cObject o;
    C1cHost h;
    C1cOutcome out;
    uint8_t body[C1C_BODY_BYTES];
    int32_t d[6];
    memset(d, 0, sizeof d);
    iv_header(&f, "M", 4);
    iv_entry(&f, 77, 1, 1, 0, 0);
    d[1] = 111;
    iv_rect(&f, d);
    iv_entry(&f, 77, 1, 2, 0, 0);
    d[1] = 222;
    iv_rect(&f, d);
    iv_entry(&f, 5, 1, 3, 0, 0);
    iv_rect(&f, d);
    iv_entry(&f, 77, 1, 4, 0, 0);
    d[1] = 444;
    iv_rect(&f, d);
    rig_init(&r, "M", &f);
    r.hotspot = 77;
    h = host_of(&r);
    make_body(body, "X", 0);
    CHECK(n, ready(&o, &r, &h, body, &out) == C1C_OK);
    CHECK(n, o.record == &o.iv->entries[0] && o.record->byte_4 == 1 && o.record->rects[0].d[1] == 111);
    CHECK(n, o.changed == 1 && o.last_index == 77);
    c1c_free_iv(&o);
    free(f.p);
    PASS(n);
}

static void test_rect_and_entry_limits(void)
{
    const char *n = "rectangle and entry count limits";
    struct {
        int32_t entries;
        int16_t rects;
        int ok;
    } cases[] = {{1, 1, 1}, {1, C1C_MAX_RECTS, 1}, {1, C1C_MAX_RECTS + 1, 0}, {1, 0, 0}, {1, -1, 0}, {1, -32768, 0},
                 {C1C_MAX_ENTRIES, 1, 1}, {C1C_MAX_ENTRIES + 1, 1, 0}, {-1, 1, 0}, {INT32_MIN, 1, 0}, {INT32_MAX, 1, 0}};
    size_t s;
    for (s = 0; s < sizeof cases / sizeof cases[0]; ++s) {
        Bytes f = {0, 0, 0};
        Rig r;
        C1cObject o;
        C1cHost h;
        C1cOutcome out;
        uint8_t body[C1C_BODY_BYTES];
        int32_t i;
        int32_t made = cases[s].entries > 0 && cases[s].entries <= C1C_MAX_ENTRIES ? cases[s].entries : 1;
        iv_header(&f, "M", cases[s].entries);
        for (i = 0; i < made; ++i) {
            int j, total = cases[s].rects > 0 ? cases[s].rects : 0;
            iv_entry(&f, (int16_t)i, cases[s].rects, 0, 0, 0);
            for (j = 0; j < total; ++j) {
                int32_t d[6] = {0, j, i, j, i, 0};
                iv_rect(&f, d);
            }
        }
        rig_init(&r, "M", &f);
        h = host_of(&r);
        make_body(body, "X", 0);
        {
            const int status = ready(&o, &r, &h, body, &out);
            CHECK(n, status == (cases[s].ok ? C1C_OK : C1C_ERR_FILE));
            CHECK(n, (o.iv != NULL) == cases[s].ok);
            CHECK(n, r.opens == 1 && r.closes == 1);
            if (cases[s].ok) {
                CHECK(n, o.iv->count == cases[s].entries);
                CHECK(n, o.iv->entries[0].count == cases[s].rects);
            }
        }
        c1c_free_iv(&o);
        free(f.p);
    }
    PASS(n);
}

static void test_short_reads(void)
{
    const char *n = "short reads leave nothing loaded";
    Bytes f = {0, 0, 0};
    size_t cut;
    iv_simple(&f, "M", 2, 2);
    for (cut = 0; cut < f.n; ++cut) {
        Rig r;
        C1cObject o;
        C1cHost h;
        C1cOutcome out;
        uint8_t body[C1C_BODY_BYTES];
        rig_init(&r, "M", &f);
        r.len = cut;
        h = host_of(&r);
        make_body(body, "X", 0);
        CHECK(n, ready(&o, &r, &h, body, &out) == C1C_ERR_FILE);
        CHECK(n, o.iv == NULL && o.record == NULL);
        CHECK(n, r.opens == 1 && r.closes == 1);
        CHECK(n, r.state_calls == 0);
    }
    {
        Rig r;
        C1cObject o;
        C1cHost h;
        C1cOutcome out;
        uint8_t body[C1C_BODY_BYTES];
        rig_init(&r, "M", &f);
        h = host_of(&r);
        make_body(body, "X", 0);
        CHECK(n, ready(&o, &r, &h, body, &out) == C1C_OK);
        c1c_free_iv(&o);
    }
    free(f.p);
    PASS(n);
}

static void test_names(void)
{
    const char *n = "file names";
    Bytes f = {0, 0, 0};
    Rig r;
    C1cObject o;
    C1cHost h;
    C1cOutcome out;
    uint8_t body[C1C_BODY_BYTES];
    char longname[C1C_BODY_BYTES];
    iv_simple(&f, "M", 1, 1);
    rig_init(&r, "M", &f);
    h = host_of(&r);
    memset(longname, 'B', sizeof longname);
    /* empty name: refused before any host call */
    make_body(body, "", 0);
    CHECK(n, ready(&o, &r, &h, body, &out) == C1C_ERR_FILE && r.opens == 0 && r.nev == 0 && o.iv == NULL);
    /* unterminated name (all 105 bytes nonzero) is refused */
    memset(body, 'A', sizeof body);
    CHECK(n, ready(&o, &r, &h, body, &out) == C1C_ERR_FILE && r.opens == 0 && r.nev == 0 && o.iv == NULL);
    /* a name of 33 bytes (the width of the file's own name field and the most that stays clear of the render word) is passed whole */
    memset(body, 0, sizeof body);
    memcpy(body, longname, 33u);
    CHECK(n, ready(&o, &r, &h, body, &out) == C1C_OK && r.opens == 1);
    CHECK(n, strlen(r.opened_name) == 33u && r.opened_name[32] == 'B');
    c1c_free_iv(&o);
    /* the longest terminated name, 104 bytes, is passed whole (the kernel copies it into a 105-byte buffer) */
    memset(body, 0, sizeof body);
    memcpy(body, longname, C1C_BODY_BYTES - 1u);
    CHECK(n, ready(&o, &r, &h, body, &out) == C1C_OK && strlen(r.opened_name) == C1C_BODY_BYTES - 1u);
    c1c_free_iv(&o);
    /* a one-byte name */
    rig_clear_counts(&r);
    make_body(body, "Z", 0);
    CHECK(n, ready(&o, &r, &h, body, &out) == C1C_OK && strcmp(r.opened_name, "Z") == 0);
    c1c_free_iv(&o);
    /* open failures */
    r.open_fail = 1;
    rig_clear_counts(&r);
    CHECK(n, ready(&o, &r, &h, body, &out) == C1C_ERR_FILE && o.iv == NULL && r.opens == 1 && r.reads == 0 && r.closes == 0);
    r.open_fail = 0;
    r.open_null = 1;
    rig_clear_counts(&r);
    CHECK(n, ready(&o, &r, &h, body, &out) == C1C_ERR_FILE && o.iv == NULL && r.reads == 0 && r.closes == 0);
    free(f.p);
    PASS(n);
}

/* ---- phases ------------------------------------------------------------------------------------------------------------- */
static void test_phase_other(void)
{
    const char *n = "phases above 2 do nothing";
    static const uint32_t phases[] = {3u, 4u, 7u, 0x80000000u, 0xffffffffu};
    size_t s;
    for (s = 0; s < sizeof phases / sizeof phases[0]; ++s) {
        Rig r;
        C1cObject o;
        C1cHost h;
        C1cOutcome out;
        uint8_t body[C1C_BODY_BYTES];
        rig_init(&r, "M", NULL);
        h = host_of(&r);
        make_body(body, "X", 1);
        c1c_object_reset(&o);
        CHECK(n, c1c_visit(&o, body, phases[s], &h, &out) == C1C_OK);
        CHECK(n, out.phase == phases[s] && out.disposition == SCENE_ACTION_HANDLER_PENDING);
        CHECK(n, r.nev == 0 && o.body == body && o.iv == NULL); /* the body pointer is stored on every visit (0x4cb5a4) */
    }
    PASS(n);
}

static void test_phase0_waits_for_player(void)
{
    const char *n = "phase 0 waits until the player is in state 2 with the file's name";
    Bytes f = {0, 0, 0};
    static const int32_t states[] = {-1, 0, 1, 3, 4, 5, 6, 0x10000};
    size_t s;
    Rig r;
    C1cObject o;
    C1cHost h;
    C1cOutcome out;
    uint8_t body[C1C_BODY_BYTES];
    iv_simple(&f, "MOVIE", 2, 1);
    rig_init(&r, "MOVIE", &f);
    h = host_of(&r);
    make_body(body, "X", 1);
    c1c_object_reset(&o);
    for (s = 0; s < sizeof states / sizeof states[0]; ++s) {
        r.state = states[s];
        rig_clear_counts(&r);
        CHECK(n, c1c_visit(&o, body, 0u, &h, &out) == C1C_OK);
        CHECK(n, out.phase == 0u && out.disposition == SCENE_ACTION_HANDLER_PENDING);
        CHECK(n, r.allocs == 0 && r.registers == 0 && r.state_calls == 1 && o.armed == 0);
        CHECK(n, o.iv != NULL && o.body == body);
        CHECK(n, r.opens == (s == 0 ? 1 : 0)); /* loaded once, kept while waiting */
    }
    /* state 2 but a different name: still waiting */
    r.state = 2;
    memset(r.name, 0, sizeof r.name);
    memcpy(r.name, "MOVI", 4);
    rig_clear_counts(&r);
    CHECK(n, c1c_visit(&o, body, 0u, &h, &out) == C1C_OK && out.phase == 0u && r.allocs == 0 && o.armed == 0);
    memcpy(r.name, "MOVIEX", 6);
    CHECK(n, c1c_visit(&o, body, 0u, &h, &out) == C1C_OK && out.phase == 0u && o.armed == 0);
    memcpy(r.name, "movie", 6);
    CHECK(n, c1c_visit(&o, body, 0u, &h, &out) == C1C_OK && out.phase == 0u && o.armed == 0);
    /* equal name: moves on, with trailing bytes after the NUL ignored */
    memset(r.name, 0x55, sizeof r.name);
    memcpy(r.name, "MOVIE", 6);
    CHECK(n, c1c_visit(&o, body, 0u, &h, &out) == C1C_OK && out.phase == 1u && o.armed == 1);
    c1c_free_iv(&o);
    free(f.p);
    PASS(n);
}

static void test_name_without_terminator(void)
{
    const char *n = "a 33-byte name without a terminator compares whole";
    Bytes f = {0, 0, 0};
    Rig r;
    C1cObject o;
    C1cHost h;
    C1cOutcome out;
    uint8_t body[C1C_BODY_BYTES];
    uint8_t field[C1C_NAME_BYTES];
    memset(field, 'N', sizeof field);
    bput(&f, field, sizeof field);
    b32(&f, 0u);
    rig_init(&r, "", &f);
    memset(r.name, 'N', sizeof r.name);
    h = host_of(&r);
    make_body(body, "X", 0);
    CHECK(n, ready(&o, &r, &h, body, &out) == C1C_OK && out.phase == 1u);
    c1c_free_iv(&o);
    r.name[32] = 'M';
    CHECK(n, ready(&o, &r, &h, body, &out) == C1C_OK && out.phase == 0u);
    c1c_free_iv(&o);
    free(f.p);
    PASS(n);
}

static void test_phase0_match(void)
{
    const char *n = "phase 0 match sets up the object and continues with phase 1";
    Bytes f = {0, 0, 0};
    Rig r;
    C1cObject o;
    C1cHost h;
    C1cOutcome out;
    uint8_t body[C1C_BODY_BYTES];
    static const int expected[] = {EV_OPEN, EV_CLOSE, EV_STATE, EV_NAME, EV_ALLOC, EV_REGISTER, EV_CELL, EV_STATE, EV_HOTSPOT};
    iv_simple(&f, "M", 2, 2);
    rig_init(&r, "M", &f);
    r.cell = 321;
    r.next_slot = 0x2a;
    h = host_of(&r);
    make_body(body, "X", 1);
    c1c_object_reset(&o);
    o.changed = 9;
    o.dword_154 = 8;
    o.dword_14e = 7;
    o.origin_present = 6;
    o.record = (const C1cEntry *)&o; /* stale values the visit must clear */
    CHECK(n, c1c_visit(&o, body, 0u, &h, &out) == C1C_OK);
    CHECK(n, out.phase == 1u && out.disposition == SCENE_ACTION_HANDLER_PENDING);
    CHECK(n, o.body == body && o.slot == 0x2a && o.armed == 1 && o.word_152 == 321 && o.last_index == -1);
    CHECK(n, o.changed == 0 && o.record == NULL && o.dword_154 == 0 && o.dword_14e == 0 && o.origin_present == 0);
    CHECK(n, r.registered_slot == 0x2a && strcmp(r.label, C1C_LABEL) == 0 && r.allocs == 1 && r.registers == 1);
    CHECK(n, events_are(&r, expected, (int)(sizeof expected / sizeof expected[0])));
    c1c_free_iv(&o);
    /* stale slot and last index left by a scene that was abandoned mid-way: a row without the render word still clears both */
    rig_init(&r, "M", &f);
    h = host_of(&r);
    make_body(body, "X", 0);
    c1c_object_reset(&o);
    o.slot = 7;
    o.last_index = 9;
    CHECK(n, c1c_visit(&o, body, 0u, &h, &out) == C1C_OK);
    CHECK(n, o.slot == -1 && o.last_index == -1 && r.allocs == 0);
    c1c_free_iv(&o);
    free(f.p);
    PASS(n);
}

static void test_render_word(void)
{
    const char *n = "z entry only when the body render word is nonzero";
    static const uint16_t words[] = {0u, 1u, 0x0100u, 0x8000u, 0xffffu};
    size_t s;
    for (s = 0; s < sizeof words / sizeof words[0]; ++s) {
        Bytes f = {0, 0, 0};
        Rig r;
        C1cObject o;
        C1cHost h;
        C1cOutcome out;
        uint8_t body[C1C_BODY_BYTES];
        iv_simple(&f, "M", 1, 1);
        rig_init(&r, "M", &f);
        h = host_of(&r);
        make_body(body, "X", words[s]);
        CHECK(n, ready(&o, &r, &h, body, &out) == C1C_OK && out.phase == 1u);
        CHECK(n, (r.allocs == 1) == (words[s] != 0u) && r.registers == r.allocs);
        CHECK(n, o.slot == (words[s] != 0u ? 0x18 : -1));
        c1c_free_iv(&o);
        free(f.p);
    }
    /* neighbouring bytes do not count */
    {
        Bytes f = {0, 0, 0};
        Rig r;
        C1cObject o;
        C1cHost h;
        C1cOutcome out;
        uint8_t body[C1C_BODY_BYTES];
        iv_simple(&f, "M", 1, 1);
        rig_init(&r, "M", &f);
        h = host_of(&r);
        make_body(body, "X", 0);
        body[C1C_BODY_RENDER_WORD - 1u] = 0xff;
        body[C1C_BODY_RENDER_WORD + 2u] = 0xff;
        CHECK(n, ready(&o, &r, &h, body, &out) == C1C_OK && r.allocs == 0 && o.slot == -1);
        c1c_free_iv(&o);
        free(f.p);
    }
    PASS(n);
}

static void test_phase1_states(void)
{
    const char *n = "phase 1 follows the player state";
    static const struct {
        int32_t state;
        uint32_t phase;
    } cases[] = {{-1, 2u}, {0, 2u}, {1, 2u}, {2, 1u}, {3, 1u}, {4, 2u}, {5, 2u}, {6, 2u}, {0x20002, 2u}};
    size_t s;
    for (s = 0; s < sizeof cases / sizeof cases[0]; ++s) {
        Bytes f = {0, 0, 0};
        Rig r;
        C1cObject o;
        C1cHost h;
        C1cOutcome out;
        uint8_t body[C1C_BODY_BYTES];
        iv_simple(&f, "M", 2, 1);
        rig_init(&r, "M", &f);
        h = host_of(&r);
        make_body(body, "X", 0);
        CHECK(n, ready(&o, &r, &h, body, &out) == C1C_OK && out.phase == 1u);
        o.changed = 1;
        o.record = &o.iv->entries[0];
        r.state = cases[s].state;
        r.hotspot = 11;
        rig_clear_counts(&r);
        CHECK(n, c1c_visit(&o, body, 1u, &h, &out) == C1C_OK);
        CHECK(n, out.phase == cases[s].phase && out.disposition == SCENE_ACTION_HANDLER_PENDING);
        CHECK(n, o.changed == (cases[s].state == 2 ? 1 : 0)); /* the stale flag is cleared, then set again only for a new hotspot */
        CHECK(n, (o.record != NULL) == (cases[s].state == 2));
        CHECK(n, r.releases == 0 && r.opens == 0);
        /* state 3 never reads the hotspot */
        CHECK(n, (r.nev >= 2 && r.ev[1] == EV_HOTSPOT) == (cases[s].state == 2));
        c1c_free_iv(&o);
        free(f.p);
    }
    PASS(n);
}

static void test_phase2(void)
{
    const char *n = "phase 2 frees and completes";
    Bytes f = {0, 0, 0};
    Rig r;
    C1cObject o;
    C1cHost h;
    C1cOutcome out;
    uint8_t body[C1C_BODY_BYTES];
    iv_simple(&f, "M", 2, 2);
    rig_init(&r, "M", &f);
    r.hotspot = 10;
    r.origin_present = 1;
    r.dx = 5;
    r.dy = 6;
    h = host_of(&r);
    make_body(body, "X", 1);
    CHECK(n, ready(&o, &r, &h, body, &out) == C1C_OK && out.phase == 1u && o.slot == 0x18 && o.changed == 1);
    rig_clear_counts(&r);
    CHECK(n, c1c_visit(&o, body, 2u, &h, &out) == C1C_OK);
    CHECK(n, out.disposition == SCENE_ACTION_HANDLER_COMPLETED && out.phase == 0u); /* the generic completion leaves the phase word 0 */
    CHECK(n, r.releases == 1 && r.released_slot == 0x18 && r.nev == 1);
    CHECK(n, o.iv == NULL && o.body == NULL && o.slot == -1 && o.armed == 0 && o.changed == 0 && o.record == NULL);
    CHECK(n, o.dword_14e == 0 && o.dword_154 == 0 && o.dword_158 == 0 && o.last_index == -1 && o.origin_present == 0);
    /* a second phase 0 reloads the file */
    rig_clear_counts(&r);
    r.hotspot = -1;
    CHECK(n, c1c_visit(&o, body, 0u, &h, &out) == C1C_OK && r.opens == 1 && out.phase == 1u);
    /* no z entry: nothing to release */
    c1c_free_iv(&o);
    {
        uint8_t plain[C1C_BODY_BYTES];
        make_body(plain, "X", 0);
        CHECK(n, ready(&o, &r, &h, plain, &out) == C1C_OK && o.slot == -1);
        rig_clear_counts(&r);
        CHECK(n, c1c_visit(&o, plain, 2u, &h, &out) == C1C_OK && out.disposition == SCENE_ACTION_HANDLER_COMPLETED);
        CHECK(n, r.releases == 0 && r.nev == 0 && o.iv == NULL);
    }
    /* release failure */
    CHECK(n, ready(&o, &r, &h, body, &out) == C1C_OK && o.slot == 0x18);
    r.fail_release = 1;
    CHECK(n, c1c_visit(&o, body, 2u, &h, &out) == C1C_ERR_HOST);
    c1c_free_iv(&o);
    free(f.p);
    PASS(n);
}

/* ---- hotspot changes and translation ------------------------------------------------------------------------------------ */
static void test_hotspot_changes(void)
{
    const char *n = "hotspot index handling";
    Bytes f = {0, 0, 0};
    Rig r;
    C1cObject o;
    C1cHost h;
    C1cOutcome out;
    uint8_t body[C1C_BODY_BYTES];
    iv_simple(&f, "M", 3, 2);
    rig_init(&r, "M", &f);
    r.origin_present = 1;
    r.dx = 1000;
    r.dy = -50;
    h = host_of(&r);
    make_body(body, "X", 0);
    CHECK(n, ready(&o, &r, &h, body, &out) == C1C_OK && out.phase == 1u && o.changed == 0 && o.record == NULL);
    /* -1: nothing */
    r.hotspot = -1;
    rig_clear_counts(&r);
    CHECK(n, c1c_visit(&o, body, 1u, &h, &out) == C1C_OK && out.phase == 1u && o.record == NULL && o.changed == 0);
    CHECK(n, r.nev == 2 && r.ev[1] == EV_HOTSPOT); /* no origin read */
    /* an id that is not in the file: no record, no change, last index unchanged (id 0 is not the zero entry after the table) */
    r.hotspot = 99;
    CHECK(n, c1c_visit(&o, body, 1u, &h, &out) == C1C_OK && o.record == NULL && o.changed == 0 && o.last_index == -1);
    r.hotspot = 0;
    CHECK(n, c1c_visit(&o, body, 1u, &h, &out) == C1C_OK && o.record == NULL && o.changed == 0 && o.last_index == -1);
    /* a hit: translated once */
    r.hotspot = 11;
    rig_clear_counts(&r);
    CHECK(n, c1c_visit(&o, body, 1u, &h, &out) == C1C_OK && out.phase == 1u);
    CHECK(n, o.record == &o.iv->entries[1] && o.changed == 1 && o.last_index == 11 && o.origin_present == 1);
    CHECK(n, r.ev[r.nev - 1] == EV_ORIGIN);
    {
        int32_t d[6];
        int j;
        for (j = 0; j < 2; ++j) {
            rect_value(d, 1, j);
            CHECK(n, o.record->rects[j].d[0] == d[0] && o.record->rects[j].d[5] == d[5]);
            CHECK(n, o.record->rects[j].d[1] == d[1] + 1000 && o.record->rects[j].d[3] == d[3] + 1000);
            CHECK(n, o.record->rects[j].d[2] == d[2] - 50 && o.record->rects[j].d[4] == d[4] - 50);
        }
        /* the other entries are untouched */
        rect_value(d, 0, 0);
        CHECK(n, o.iv->entries[0].rects[0].d[1] == d[1] && o.iv->entries[2].rects[0].d[2] == 200 * 2 + 0);
    }
    /* the same index again: the record is found, no second translation, no change flag, no origin read */
    rig_clear_counts(&r);
    CHECK(n, c1c_visit(&o, body, 1u, &h, &out) == C1C_OK);
    CHECK(n, o.record == &o.iv->entries[1] && o.changed == 0 && r.nev == 2);
    CHECK(n, o.record->rects[0].d[1] == 100 + 1000);
    /* another index, then back: translated again each time the index changes */
    r.hotspot = 12;
    CHECK(n, c1c_visit(&o, body, 1u, &h, &out) == C1C_OK && o.changed == 1 && o.last_index == 12);
    r.hotspot = 11;
    CHECK(n, c1c_visit(&o, body, 1u, &h, &out) == C1C_OK && o.changed == 1 && o.last_index == 11);
    CHECK(n, o.record->rects[0].d[1] == 100 + 2000 && o.record->rects[0].d[2] == 200 - 100);
    /* a -1 in between does not reset the last index */
    r.hotspot = -1;
    CHECK(n, c1c_visit(&o, body, 1u, &h, &out) == C1C_OK && o.last_index == 11);
    r.hotspot = 11;
    CHECK(n, c1c_visit(&o, body, 1u, &h, &out) == C1C_OK && o.changed == 0 && o.record != NULL);
    /* state 3 does not look at the hotspot */
    r.state = 3;
    rig_clear_counts(&r);
    CHECK(n, c1c_visit(&o, body, 1u, &h, &out) == C1C_OK && out.phase == 1u && o.record == NULL && o.changed == 0 && r.nev == 1);
    c1c_free_iv(&o);
    free(f.p);
    PASS(n);
}

static void test_origin_absent_and_wrap(void)
{
    const char *n = "origin absent, and wrap-around coordinates";
    Bytes f = {0, 0, 0};
    Rig r;
    C1cObject o;
    C1cHost h;
    C1cOutcome out;
    uint8_t body[C1C_BODY_BYTES];
    int32_t d[6] = {1, INT32_MAX, INT32_MIN, INT32_MAX - 1, 70000, 9};
    iv_header(&f, "M", 1);
    iv_entry(&f, 4, 1, 0, 0, 0);
    iv_rect(&f, d);
    rig_init(&r, "M", &f);
    r.hotspot = 4;
    r.origin_present = 0;
    r.dx = 123;
    r.dy = 456;
    h = host_of(&r);
    make_body(body, "X", 0);
    CHECK(n, ready(&o, &r, &h, body, &out) == C1C_OK && o.changed == 1 && o.origin_present == 0);
    CHECK(n, o.record->rects[0].d[1] == INT32_MAX && o.record->rects[0].d[2] == INT32_MIN); /* no translation without the object */
    c1c_free_iv(&o);
    r.origin_present = 7; /* any nonzero value counts as present */
    r.dx = 1;
    r.dy = -1;
    CHECK(n, ready(&o, &r, &h, body, &out) == C1C_OK && o.origin_present == 1);
    CHECK(n, o.record->rects[0].d[1] == INT32_MIN && o.record->rects[0].d[2] == INT32_MAX);
    CHECK(n, o.record->rects[0].d[3] == INT32_MAX && o.record->rects[0].d[4] == 69999);
    CHECK(n, o.record->rects[0].d[0] == 1 && o.record->rects[0].d[5] == 9);
    c1c_free_iv(&o);
    free(f.p);
    PASS(n);
}

/* ---- render ------------------------------------------------------------------------------------------------------------- */
static void test_render(void)
{
    const char *n = "render colors, offsets and the changed flag";
    C1cObject o;
    C1cEntry e;
    C1cRect rects[70];
    C1cFill fills[70];
    size_t count = 99u;
    int i;
    memset(rects, 0, sizeof rects);
    for (i = 0; i < 70; ++i) {
        rects[i].d[1] = i;
        rects[i].d[2] = 2 * i;
        rects[i].d[3] = 3 * i;
        rects[i].d[4] = 4 * i;
        rects[i].d[0] = 555;
        rects[i].d[5] = 666;
    }
    memset(&e, 0, sizeof e);
    e.count = 70;
    e.rects = rects;
    c1c_object_reset(&o);
    /* not changed: nothing */
    CHECK(n, c1c_render(&o, 5, 6, fills, 70u, &count) == C1C_OK && count == 0u);
    o.record = &e;
    CHECK(n, c1c_render(&o, 5, 6, fills, 70u, &count) == C1C_OK && count == 0u);
    o.changed = 1;
    CHECK(n, c1c_render(&o, 100, -200, fills, 70u, &count) == C1C_OK && count == 70u && o.changed == 0);
    for (i = 0; i < 70; ++i) {
        CHECK(n, fills[i].left == i + 100 && fills[i].top == 2 * i - 200 && fills[i].right == 3 * i + 100);
        CHECK(n, fills[i].bottom == 4 * i - 200);
        CHECK(n, fills[i].color == (uint16_t)(0x10 + 0x400 * i)); /* 16-bit wrap after 64 rectangles */
    }
    CHECK(n, fills[0].color == 0x10 && fills[1].color == 0x410 && fills[63].color == 0xfc10 && fills[64].color == 0x0010);
    /* the flag is cleared: a second call draws nothing */
    CHECK(n, c1c_render(&o, 100, -200, fills, 70u, &count) == C1C_OK && count == 0u);
    /* a smaller capacity still counts everything and writes only what fits */
    memset(fills, 0xaa, sizeof fills);
    o.changed = 1;
    CHECK(n, c1c_render(&o, 0, 0, fills, 3u, &count) == C1C_OK && count == 70u && o.changed == 0);
    CHECK(n, fills[2].left == 2 && fills[2].color == 0x810 && fills[3].color == 0xaaaa);
    /* capacity 0 with no buffer */
    o.changed = 1;
    CHECK(n, c1c_render(&o, 0, 0, NULL, 0u, &count) == C1C_OK && count == 70u && o.changed == 0);
    /* wrap of the view offset */
    rects[0].d[1] = INT32_MAX;
    rects[0].d[3] = INT32_MIN;
    rects[0].d[2] = INT32_MAX;
    rects[0].d[4] = -1;
    o.changed = 1;
    CHECK(n, c1c_render(&o, 1, 1, fills, 70u, &count) == C1C_OK);
    CHECK(n, fills[0].left == INT32_MIN && fills[0].right == INT32_MIN + 1 && fills[0].top == INT32_MIN && fills[0].bottom == 0);
    /* a single rectangle */
    e.count = 1;
    o.changed = 1;
    CHECK(n, c1c_render(&o, 0, 0, fills, 70u, &count) == C1C_OK && count == 1u && fills[0].color == 0x10);
    PASS(n);
}

static void test_render_errors(void)
{
    const char *n = "render refusals";
    C1cObject o;
    C1cFill fills[2];
    size_t count = 5u;
    c1c_object_reset(&o);
    o.changed = 1;
    o.record = NULL; /* changed without a record: the original would read through a null pointer */
    CHECK(n, c1c_render(&o, 0, 0, fills, 2u, &count) == C1C_ERR_BODY && count == 0u && o.changed == 1);
    CHECK(n, c1c_render(NULL, 0, 0, fills, 2u, &count) == C1C_ERR_ARGUMENT);
    CHECK(n, c1c_render(&o, 0, 0, fills, 2u, NULL) == C1C_ERR_ARGUMENT);
    CHECK(n, c1c_render(&o, 0, 0, NULL, 2u, &count) == C1C_ERR_ARGUMENT);
    PASS(n);
}

/* ---- failures ------------------------------------------------------------------------------------------------------------ */
static void test_alloc_and_register_failures(void)
{
    const char *n = "z entry failures";
    Bytes f = {0, 0, 0};
    Rig r;
    C1cObject o;
    C1cHost h;
    C1cOutcome out;
    uint8_t body[C1C_BODY_BYTES];
    iv_simple(&f, "M", 1, 1);
    rig_init(&r, "M", &f);
    h = host_of(&r);
    make_body(body, "X", 1);
    r.fail_alloc = 1;
    CHECK(n, ready(&o, &r, &h, body, &out) == C1C_ERR_HOST && r.allocs == 1 && r.registers == 0 && o.armed == 0);
    c1c_free_iv(&o);
    r.fail_alloc = 0;
    r.fail_register = 1;
    rig_clear_counts(&r);
    CHECK(n, ready(&o, &r, &h, body, &out) == C1C_ERR_HOST && r.registers == 1 && r.ev[r.nev - 1] == EV_REGISTER && o.armed == 0);
    c1c_free_iv(&o);
    free(f.p);
    PASS(n);
}

static void test_host_failures(void)
{
    const char *n = "player and cell failures";
    Bytes f = {0, 0, 0};
    uint8_t body[C1C_BODY_BYTES];
    int which;
    iv_simple(&f, "M", 1, 1);
    make_body(body, "X", 1);
    for (which = 0; which < 6; ++which) {
        Rig r;
        C1cObject o;
        C1cHost h;
        C1cOutcome out;
        rig_init(&r, "M", &f);
        r.hotspot = 10;
        r.origin_present = 1;
        h = host_of(&r);
        switch (which) {
        case 0: r.fail_state_call = 1; break;       /* phase 0 state */
        case 1: r.fail_name = 1; break;
        case 2: r.fail_cell = 1; break;
        case 3: r.fail_state_call = 2; break;       /* the phase 1 state read inside the first visit */
        case 4: r.fail_hotspot = 1; break;
        default: r.fail_origin = 1; break;
        }
        CHECK(n, ready(&o, &r, &h, body, &out) == C1C_ERR_HOST);
        c1c_free_iv(&o);
    }
    /* phase 1 alone */
    {
        Rig r;
        C1cObject o;
        C1cHost h;
        C1cOutcome out;
        rig_init(&r, "M", &f);
        h = host_of(&r);
        CHECK(n, ready(&o, &r, &h, body, &out) == C1C_OK && out.phase == 1u);
        r.state_calls = 0;
        r.fail_state_call = 1;
        CHECK(n, c1c_visit(&o, body, 1u, &h, &out) == C1C_ERR_HOST);
        c1c_free_iv(&o);
    }
    free(f.p);
    PASS(n);
}

static void test_kernel_arguments(void)
{
    const char *n = "kernel argument checks";
    Rig r;
    C1cObject o;
    C1cHost h;
    C1cOutcome out;
    uint8_t body[C1C_BODY_BYTES];
    size_t i;
    rig_init(&r, "M", NULL);
    h = host_of(&r);
    make_body(body, "X", 0);
    c1c_object_reset(&o);
    CHECK(n, c1c_visit(NULL, body, 0u, &h, &out) == C1C_ERR_ARGUMENT);
    CHECK(n, c1c_visit(&o, NULL, 0u, &h, &out) == C1C_ERR_ARGUMENT);
    CHECK(n, c1c_visit(&o, body, 0u, NULL, &out) == C1C_ERR_ARGUMENT);
    CHECK(n, c1c_visit(&o, body, 0u, &h, NULL) == C1C_ERR_ARGUMENT);
    for (i = 0; i < 11; ++i) {
        C1cHost bad = h;
        drop_callback(&bad, i);
        CHECK(n, c1c_visit(&o, body, 3u, &bad, &out) == C1C_ERR_ARGUMENT); /* even for a phase that does nothing */
        CHECK(n, r.nev == 0);
    }
    c1c_object_reset(NULL);
    c1c_free_iv(NULL);
    c1c_free_iv(&o);
    PASS(n);
}

static void test_event_order_with_hit(void)
{
    const char *n = "event order of a first visit that already has a hotspot";
    Bytes f = {0, 0, 0};
    Rig r;
    C1cObject o;
    C1cHost h;
    C1cOutcome out;
    uint8_t body[C1C_BODY_BYTES];
    static const int expected[] = {EV_OPEN, EV_CLOSE, EV_STATE, EV_NAME, EV_ALLOC, EV_REGISTER, EV_CELL, EV_STATE, EV_HOTSPOT, EV_ORIGIN};
    iv_simple(&f, "M", 1, 1);
    rig_init(&r, "M", &f);
    r.hotspot = 10;
    r.origin_present = 1;
    h = host_of(&r);
    make_body(body, "X", 1);
    CHECK(n, ready(&o, &r, &h, body, &out) == C1C_OK && out.phase == 1u);
    CHECK(n, events_are(&r, expected, (int)(sizeof expected / sizeof expected[0])));
    c1c_free_iv(&o);
    free(f.p);
    PASS(n);
}

/* ---- binding ------------------------------------------------------------------------------------------------------------ */
static void test_binding_flow(void)
{
    const char *n = "binding drives phases 0 -> 1 -> 2";
    Bytes f = {0, 0, 0};
    Rig r;
    C1cHost h;
    SessionA1cBinding *b;
    uint8_t body[C1C_BODY_BYTES + 16u];
    SceneActionInfo info;
    SceneActionRuntimeState before = {0u, 0u};
    SceneActionHandlerResult res;
    C1cFill fills[8];
    size_t count = 0u;
    iv_simple(&f, "MOVIE", 2, 2);
    rig_init(&r, "MOVIE", &f);
    r.state = 0;
    r.origin_present = 1;
    r.dx = 10;
    r.dy = 20;
    h = host_of(&r);
    b = session_a1c_create(&h);
    CHECK(n, b != NULL && session_a1c_visits(b) == 0ul && strcmp(session_a1c_failure(b), "none") == 0);
    CHECK(n, session_a1c_object(b) != NULL && session_a1c_object(b)->iv == NULL);
    memset(body, 0, sizeof body);
    make_body(body, "IVNAME", 1);
    info_for(&info, body, C1C_BODY_BYTES + 16u);
    /* the player is idle: the row loads the file and waits in phase 0 */
    CHECK(n, session_a1c_handler(b, 0u, &info, &before, &res) == SCENE_ACTION_HANDLER_OK);
    CHECK(n, res.phase == 0u && res.disposition == SCENE_ACTION_HANDLER_PENDING && session_a1c_visits(b) == 1ul);
    CHECK(n, session_a1c_object(b)->iv != NULL && r.opens == 1 && strcmp(r.opened_name, "IVNAME") == 0);
    /* the object keeps its own copy of the body */
    memset(body, 0xee, sizeof body);
    CHECK(n, session_a1c_object(b)->body != body && memcmp(session_a1c_object(b)->body, "IVNAME", 6) == 0);
    make_body(body, "IVNAME", 1);
    CHECK(n, session_a1c_handler(b, 0u, &info, &before, &res) == SCENE_ACTION_HANDLER_OK && res.phase == 0u && r.opens == 1);
    /* the player reaches state 2 with the right clip and a hotspot */
    r.state = 2;
    r.hotspot = 11;
    CHECK(n, session_a1c_handler(b, 0u, &info, &before, &res) == SCENE_ACTION_HANDLER_OK);
    CHECK(n, res.phase == 1u && res.disposition == SCENE_ACTION_HANDLER_PENDING);
    CHECK(n, session_a1c_object(b)->changed == 1 && session_a1c_object(b)->record != NULL && session_a1c_object(b)->slot == 0x18);
    CHECK(n, session_a1c_render(b, 1, 2, fills, 8u, &count) == C1C_OK && count == 2u && session_a1c_object(b)->changed == 0);
    CHECK(n, fills[0].left == 100 + 10 + 1 && fills[0].top == 200 + 20 + 2 && fills[0].color == 0x10 && fills[1].color == 0x410);
    before.phase = 1u;
    CHECK(n, session_a1c_handler(b, 0u, &info, &before, &res) == SCENE_ACTION_HANDLER_OK && res.phase == 1u);
    /* the player leaves state 2/3: phase 2, then the completion */
    r.state = 4;
    CHECK(n, session_a1c_handler(b, 0u, &info, &before, &res) == SCENE_ACTION_HANDLER_OK);
    CHECK(n, res.phase == 2u && res.disposition == SCENE_ACTION_HANDLER_PENDING);
    before.phase = 2u;
    CHECK(n, session_a1c_handler(b, 0u, &info, &before, &res) == SCENE_ACTION_HANDLER_OK);
    CHECK(n, res.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED && res.phase == 0u && r.releases == 1);
    CHECK(n, session_a1c_object(b)->iv == NULL && session_a1c_visits(b) == 6ul);
    before.phase = 9u;
    CHECK(n, session_a1c_handler(b, 0u, &info, &before, &res) == SCENE_ACTION_HANDLER_OK);
    CHECK(n, res.phase == 9u && res.disposition == SCENE_ACTION_HANDLER_PENDING);
    session_a1c_destroy(b);
    free(f.p);
    PASS(n);
}

static void test_binding_completion_by_subtype(void)
{
    const char *n = "completion disposition by subtype";
    static const uint8_t subtypes[] = {0u, 1u, 2u, 3u, 0x7fu, 0xffu};
    size_t s;
    for (s = 0; s < sizeof subtypes; ++s) {
        Bytes f = {0, 0, 0};
        Rig r;
        C1cHost h;
        SessionA1cBinding *b;
        uint8_t body[C1C_BODY_BYTES];
        SceneActionInfo info;
        SceneActionRuntimeState before = {0u, 0u};
        SceneActionHandlerResult res;
        iv_simple(&f, "M", 1, 1);
        rig_init(&r, "M", &f);
        h = host_of(&r);
        b = session_a1c_create(&h);
        make_body(body, "X", 0);
        info_for(&info, body, sizeof body);
        info.subtype = subtypes[s];
        CHECK(n, b != NULL);
        before.phase = 2u;
        /* the original stores the completion byte itself; only subtype 2 (a repeating row) goes through the generic completion */
        CHECK(n, session_a1c_handler(b, 0u, &info, &before, &res) == SCENE_ACTION_HANDLER_OK);
        CHECK(n, res.phase == 0u);
        CHECK(n, res.disposition == (subtypes[s] == 2u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_DIRECT_COMPLETED));
        /* the pending phases are not completions, whatever the subtype */
        before.phase = 0u;
        r.state = 0;
        CHECK(n, session_a1c_handler(b, 0u, &info, &before, &res) == SCENE_ACTION_HANDLER_OK);
        CHECK(n, res.disposition == SCENE_ACTION_HANDLER_PENDING && res.phase == 0u);
        before.phase = 3u;
        CHECK(n, session_a1c_handler(b, 0u, &info, &before, &res) == SCENE_ACTION_HANDLER_OK);
        CHECK(n, res.disposition == SCENE_ACTION_HANDLER_PENDING && res.phase == 3u);
        session_a1c_destroy(b);
        free(f.p);
    }
    PASS(n);
}

static void test_binding_destroy_frees_file(void)
{
    const char *n = "destroy frees a loaded file";
    Bytes f = {0, 0, 0};
    Rig r;
    C1cHost h;
    SessionA1cBinding *b;
    uint8_t body[C1C_BODY_BYTES];
    SceneActionInfo info;
    SceneActionRuntimeState before = {0u, 0u};
    SceneActionHandlerResult res;
    iv_simple(&f, "M", 3, 3);
    rig_init(&r, "M", &f);
    r.state = 0;
    h = host_of(&r);
    b = session_a1c_create(&h);
    make_body(body, "X", 0);
    info_for(&info, body, sizeof body);
    CHECK(n, b != NULL && session_a1c_handler(b, 0u, &info, &before, &res) == SCENE_ACTION_HANDLER_OK);
    CHECK(n, session_a1c_object(b)->iv != NULL);
    session_a1c_destroy(b); /* leak and use-after-free checks come from the sanitizers */
    session_a1c_destroy(NULL);
    free(f.p);
    PASS(n);
}

static void test_binding_refusals(void)
{
    const char *n = "binding refusals and failure strings";
    Bytes f = {0, 0, 0};
    Rig r;
    C1cHost h;
    SessionA1cBinding *b;
    uint8_t body[C1C_BODY_BYTES + 3u];
    SceneActionInfo info;
    SceneActionRuntimeState before = {0u, 0u};
    SceneActionHandlerResult res;
    size_t i;
    iv_simple(&f, "M", 1, 1);
    rig_init(&r, "M", &f);
    h = host_of(&r);
    CHECK(n, session_a1c_create(NULL) == NULL);
    b = session_a1c_create(&h);
    CHECK(n, b != NULL);
    memset(body, 0, sizeof body);
    make_body(body, "X", 0);
    info_for(&info, body, C1C_BODY_BYTES);
    CHECK(n, session_a1c_handler(NULL, 0u, &info, &before, &res) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(n, session_a1c_handler(b, 0u, NULL, &before, &res) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(n, session_a1c_handler(b, 0u, &info, NULL, &res) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(n, session_a1c_handler(b, 0u, &info, &before, NULL) == SCENE_ACTION_HANDLER_ERROR);
    info.type = 0x1du;
    CHECK(n, session_a1c_handler(b, 0u, &info, &before, &res) == SCENE_ACTION_HANDLER_ERROR);
    info.type = SESSION_A1C_TYPE;
    info.raw_body_length = C1C_BODY_BYTES - 1u; /* short body */
    CHECK(n, session_a1c_handler(b, 0u, &info, &before, &res) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(n, strcmp(session_a1c_failure(b), "invalid raw-0x1c body") == 0 && r.nev == 0);
    info.raw_body_length = C1C_BODY_BYTES + 3u; /* ragged dependency tail */
    CHECK(n, session_a1c_handler(b, 0u, &info, &before, &res) == SCENE_ACTION_HANDLER_ERROR && r.nev == 0);
    info.raw_body_length = C1C_BODY_BYTES;
    CHECK(n, session_a1c_visits(b) == 0ul);
    /* all 105 body bytes nonzero: the name has no terminator, the binding's copy must keep the last byte too */
    {
        uint8_t full[C1C_BODY_BYTES];
        SceneActionInfo full_info;
        memset(full, 'A', sizeof full);
        info_for(&full_info, full, sizeof full);
        CHECK(n, session_a1c_handler(b, 0u, &full_info, &before, &res) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(n, r.opens == 0 && strstr(session_a1c_failure(b), "the original shuts the game down") != NULL);
        CHECK(n, session_a1c_object(b)->body != NULL && session_a1c_object(b)->body[C1C_BODY_BYTES - 1u] == 'A');
    }
    /* file errors: ERROR with the shut-down message, nothing counted */
    r.open_fail = 1;
    CHECK(n, session_a1c_handler(b, 0u, &info, &before, &res) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(n, strstr(session_a1c_failure(b), "the original shuts the game down") != NULL && session_a1c_visits(b) == 0ul);
    r.open_fail = 0;
    /* a host callback failure has the other message */
    r.state = 2;
    r.fail_cell = 1;
    CHECK(n, session_a1c_handler(b, 0u, &info, &before, &res) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(n, strcmp(session_a1c_failure(b), "raw-0x1c host callback failed") == 0 && session_a1c_visits(b) == 0ul);
    r.fail_cell = 0;
    /* a success clears the message */
    CHECK(n, session_a1c_handler(b, 0u, &info, &before, &res) == SCENE_ACTION_HANDLER_OK);
    CHECK(n, strcmp(session_a1c_failure(b), "none") == 0 && session_a1c_visits(b) == 1ul);
    session_a1c_destroy(b);
    CHECK(n, strcmp(session_a1c_failure(NULL), "invalid binding") == 0 && session_a1c_object(NULL) == NULL);
    CHECK(n, session_a1c_visits(NULL) == 0ul);
    {
        C1cFill fills[1];
        size_t count;
        CHECK(n, session_a1c_render(NULL, 0, 0, fills, 1u, &count) == C1C_ERR_ARGUMENT);
    }
    /* every missing callback makes the visit UNSUPPORTED before any effect */
    for (i = 0; i < 11; ++i) {
        C1cHost bad = h;
        SessionA1cBinding *bb;
        drop_callback(&bad, i);
        rig_clear_counts(&r);
        bb = session_a1c_create(&bad);
        CHECK(n, bb != NULL);
        CHECK(n, session_a1c_handler(bb, 0u, &info, &before, &res) == SCENE_ACTION_HANDLER_UNSUPPORTED);
        CHECK(n, r.nev == 0 && session_a1c_visits(bb) == 0ul && session_a1c_object(bb)->iv == NULL);
        CHECK(n, strcmp(session_a1c_failure(bb), "movie player, .IV file or z entry provider") == 0);
        session_a1c_destroy(bb);
    }
    free(f.p);
    PASS(n);
}

static void test_binding_slot_failures(void)
{
    const char *n = "binding reports z entry failures as errors";
    Bytes f = {0, 0, 0};
    Rig r;
    C1cHost h;
    SessionA1cBinding *b;
    uint8_t body[C1C_BODY_BYTES];
    SceneActionInfo info;
    SceneActionRuntimeState before = {0u, 0u};
    SceneActionHandlerResult res;
    iv_simple(&f, "M", 1, 1);
    rig_init(&r, "M", &f);
    r.fail_alloc = 1;
    h = host_of(&r);
    b = session_a1c_create(&h);
    make_body(body, "X", 1);
    info_for(&info, body, sizeof body);
    CHECK(n, b != NULL && session_a1c_handler(b, 0u, &info, &before, &res) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(n, session_a1c_visits(b) == 0ul);
    r.fail_alloc = 0;
    r.fail_release = 1;
    CHECK(n, session_a1c_handler(b, 0u, &info, &before, &res) == SCENE_ACTION_HANDLER_OK && res.phase == 1u);
    before.phase = 2u;
    CHECK(n, session_a1c_handler(b, 0u, &info, &before, &res) == SCENE_ACTION_HANDLER_ERROR);
    session_a1c_destroy(b);
    free(f.p);
    PASS(n);
}

static void test_binding_render_without_record(void)
{
    const char *n = "binding render before any hotspot";
    Rig r;
    C1cHost h;
    SessionA1cBinding *b;
    C1cFill fills[2];
    size_t count = 7u;
    rig_init(&r, "M", NULL);
    h = host_of(&r);
    b = session_a1c_create(&h);
    CHECK(n, b != NULL && session_a1c_render(b, 0, 0, fills, 2u, &count) == C1C_OK && count == 0u);
    CHECK(n, session_a1c_render(b, 0, 0, fills, 2u, NULL) == C1C_ERR_ARGUMENT);
    session_a1c_destroy(b);
    PASS(n);
}

int main(void)
{
    test_load_layouts();
    test_ids_are_signed_words();
    test_phase1_without_file();
    test_load_read_sizes();
    test_repeated_ids();
    test_rect_and_entry_limits();
    test_short_reads();
    test_names();
    test_phase_other();
    test_phase0_waits_for_player();
    test_name_without_terminator();
    test_phase0_match();
    test_render_word();
    test_phase1_states();
    test_phase2();
    test_hotspot_changes();
    test_origin_absent_and_wrap();
    test_render();
    test_render_errors();
    test_alloc_and_register_failures();
    test_host_failures();
    test_kernel_arguments();
    test_event_order_with_hit();
    test_binding_flow();
    test_binding_completion_by_subtype();
    test_binding_destroy_frees_file();
    test_binding_refusals();
    test_binding_slot_failures();
    test_binding_render_without_record();
    return failures == 0 ? 0 : 1;
}
