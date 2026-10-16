/* RT-36 unit tests of raw 0x2d, the random-movie set: the kernel (src/action_family_2d_runtime.c) and its binding to raw 0x2e
 * (src/session_bindings_a2d.c, src/session_bindings_a2e.c). Prints "PASS <name>" / "FAIL <name>: <message>"; the exit status is
 * the failure count. Fixtures are synthetic (no original bytes). tests/test_action_family_2d_runtime.py builds and runs this
 * plainly, under ASan/UBSan and under source mutations; the original-x86 oracle is
 * tests/action_family_2d_runtime_original_oracle.py. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "session_bindings_a2d.h"

static int g_failed;
static char g_msg[320];
#define CHECK(cond)                                                       \
    do {                                                                  \
        if (!(cond) && !g_failed) {                                       \
            g_failed = 1;                                                 \
            snprintf(g_msg, sizeof g_msg, "line %d: %s", __LINE__, #cond); \
        }                                                                 \
    } while (0)

#define LOG_MAX 128
typedef struct {
    int op[LOG_MAX];
    int32_t a[LOG_MAX];
    int32_t b[LOG_MAX];
    char name[LOG_MAX][34];
    unsigned n;
    /* scripts */
    int32_t rand_value;
    uint32_t tick_value;
    int exists[4];         /* FILE_EXISTS by variant */
    int32_t surface_handle;
    int32_t thread_handle;
    int32_t bink_open_result;
    int32_t bink_prepare_result;
    int32_t bink_ready, bink_more, bink_frame;
    int16_t surface_w, surface_h;
    int32_t rand_queue[8];
    unsigned rand_n, rand_i;
} Rig;

static int host_op(void *context, int op, const D2OpArgs *args, int32_t *ret)
{
    Rig *r = (Rig *)context;
    *ret = 0;
    if (r->n < LOG_MAX) {
        r->op[r->n] = op;
        r->a[r->n] = args->a;
        r->b[r->n] = args->b;
        r->name[r->n][0] = 0;
        if (args->name != NULL) {
            snprintf(r->name[r->n], sizeof r->name[r->n], "%s", args->name);
        }
        ++r->n;
    }
    switch (op) {
    case D2_OP_RAND:
        *ret = r->rand_i < r->rand_n ? r->rand_queue[r->rand_i++] : r->rand_value;
        break;
    case D2_OP_TICK: *ret = (int32_t)r->tick_value; break;
    case D2_OP_FILE_EXISTS: *ret = r->exists[args->a & 3]; break;
    case D2_OP_SURFACE_CREATE: *ret = r->surface_handle; break;
    case D2_OP_THREAD_CREATE: *ret = r->thread_handle; break;
    case D2_OP_BINK_OPEN: *ret = r->bink_open_result; break;
    case D2_OP_BINK_PREPARE: *ret = r->bink_prepare_result; break;
    case D2_OP_BINK_READY: *ret = r->bink_ready; break;
    case D2_OP_BINK_MORE: *ret = r->bink_more; break;
    case D2_OP_BINK_FRAME: *ret = r->bink_frame; break;
    default: break;
    }
    return 0;
}

static int host_dims(void *context, uint32_t surface, int16_t *w, int16_t *h)
{
    Rig *r = (Rig *)context;
    (void)surface;
    *w = r->surface_w;
    *h = r->surface_h;
    return 0;
}

static unsigned count_op(const Rig *r, int op)
{
    unsigned c = 0;
    for (unsigned i = 0; i < r->n; ++i) {
        c += r->op[i] == op;
    }
    return c;
}

/* ----- body builder: header 39, entries 49 + 35 per record, groups 34 ----- */
typedef struct {
    uint8_t bytes[1024];
    size_t len;
} Body;

static void put16(Body *b, int16_t v) { b->bytes[b->len++] = (uint8_t)v; b->bytes[b->len++] = (uint8_t)((uint16_t)v >> 8); }
static void put32(Body *b, int32_t v) { put16(b, (int16_t)v); put16(b, (int16_t)((uint32_t)v >> 16)); }
static void putname(Body *b, const char *s)
{
    uint8_t span[33];
    memset(span, 0, sizeof span);
    memcpy(span, s, strlen(s));
    memcpy(b->bytes + b->len, span, sizeof span);
    b->len += sizeof span;
}
static void header(Body *b, const char *name, int16_t mode, int16_t entries, int16_t groups)
{
    b->len = 0;
    putname(b, name);
    put16(b, mode);
    put16(b, entries);
    put16(b, groups);
}
static void entry(Body *b, const char *name, int16_t f21, int16_t f23, int32_t dmin, int32_t dmax, int16_t weight,
                  int16_t records)
{
    putname(b, name);
    put16(b, f21);
    put16(b, f23);
    put32(b, dmin);
    put32(b, dmax);
    put16(b, weight);
    put16(b, records);
}
static void record(Body *b, const char *name, int16_t weight)
{
    putname(b, name);
    put16(b, weight);
}
static void group(Body *b, int16_t key, int32_t s0, int32_t s1, int32_t s2, int32_t s3, int32_t d0, int32_t d1,
                  int32_t d2, int32_t d3)
{
    put16(b, key);
    put32(b, s0); put32(b, s1); put32(b, s2); put32(b, s3);
    put32(b, d0); put32(b, d1); put32(b, d2); put32(b, d3);
}

typedef struct {
    Rig rig;
    D2Host host;
    D2Object obj;
    D2World world;
    D2Set set;
    Body body;
} Fix;

static void fix_init(Fix *f)
{
    memset(f, 0, sizeof(*f));
    f->host.context = &f->rig;
    f->host.op = host_op;
    f->host.surface_dims = host_dims;
    d2_object_reset(&f->obj);
    d2_world_init(&f->world);
    f->rig.surface_handle = 0x5000;
    f->rig.thread_handle = 0x7000;
    f->rig.bink_prepare_result = 1;
    f->obj.rect_1b2 = 0; f->obj.rect_1ba = 63;   /* width 64 */
    f->obj.rect_1b6 = 0; f->obj.rect_1be = 47;   /* height 48 */
    f->obj.period_24 = 100;
    f->rig.surface_w = 64;
    f->rig.surface_h = 48;
    f->world.view_x = 10;
    f->world.view_y = 20;
    f->world.scene_key = 7;
    f->world.thread_arg = 3;
    f->world.g_5839a9 = 5;
}

static int fix_parse(Fix *f)
{
    const char *why = NULL;
    d2_set_free(&f->set);
    return d2_set_parse(f->body.bytes, f->body.len, &f->set, &why);
}

/* A named set with two entries; entry 0 has two records (weights 3 and 2) and its own weight 4, delays 100..300. */
static void sample(Fix *f, const char *name, int16_t mode)
{
    header(&f->body, name, mode, 2, 2);
    entry(&f->body, "CLIPA", 5, 9, 100, 300, 4, 2);
    record(&f->body, "CLIPB", 3);
    record(&f->body, "CLIPA", 2);
    entry(&f->body, "CLIPB", 1, 4, 50, 50, 1, 0);
    group(&f->body, 7, 1, 2, 3, 4, 100, 110, 120, 130);
    group(&f->body, 9, 0, 0, 0, 0, 0, 0, 0, 0);
    CHECK(fix_parse(f) == D2_OK);
}

static int step(Fix *f, int16_t row, uint32_t phase, D2StepResult *res)
{
    return d2_step(&f->obj, &f->set, row, phase, &f->world, &f->host, res, NULL);
}

static void test_parse_rules(void)
{
    Fix f;
    D2Set tmp;
    const char *why = NULL;
    fix_init(&f);
    sample(&f, "CLIPA", 1);
    CHECK(f.set.entry_count == 2 && f.set.group_count == 2 && f.set.mode_word == 1);
    CHECK(f.set.entries[0].record_count == 2 && f.set.entries[0].records[1].weight == 2);
    CHECK(f.set.entries[0].delay_min == 100 && f.set.entries[0].delay_max == 300 && f.set.entries[0].weight == 4);
    CHECK(f.set.groups[0].key == 7 && f.set.groups[0].src[3] == 4 && f.set.groups[0].dst[2] == 120);
    CHECK(d2_set_parse(f.body.bytes, f.body.len - 1u, &tmp, &why) == D2_ERR_BODY);
    CHECK(d2_set_parse(f.body.bytes, 10u, &tmp, &why) == D2_ERR_BODY);
    f.body.bytes[0x23] = 0xff; f.body.bytes[0x24] = 0xff; /* entry count -1 */
    CHECK(d2_set_parse(f.body.bytes, f.body.len, &tmp, &why) == D2_ERR_BODY);
    sample(&f, "CLIPA", 1);
    memset(f.body.bytes, 'x', 33); /* header name without a NUL */
    CHECK(d2_set_parse(f.body.bytes, f.body.len, &tmp, &why) == D2_ERR_BODY);
    d2_set_free(&f.set);
}

static void test_phase0_named_avf(void)
{
    Fix f;
    D2StepResult res;
    fix_init(&f);
    sample(&f, "CLIPB", 1);
    f.rig.exists[2] = 1; /* only the first AVF probe hits */
    CHECK(step(&f, 4, 0, &res) == D2_OK);
    CHECK(res.phase_after == 1 && res.initialized == 1);
    CHECK(f.obj.clip_246 == 1 && f.obj.kind_21a == 0 && f.obj.kind_17e == 0);
    CHECK(strcmp(f.obj.name_159, "CLIPB") == 0);
    CHECK(f.obj.movie.active == 1 && f.world.start_flag == 1 && f.obj.saved_202 == 5);
    CHECK(f.world.g_5839a9 == 0 && f.obj.ring_17a == 1 && f.obj.action_23e == 4);
    CHECK(f.obj.surface_212 == 0x5000 && f.world.entry_surface == 0x5000 && f.obj.thread_1d6 == 0x7000);
    CHECK(f.obj.frame_1ca == 1 && f.obj.ready_1d4 == 0 && f.obj.state_1da == 0 && f.obj.frame_232 == -1);
    CHECK(f.obj.word_1cc == 1 && f.obj.word_1ce == 2);
    /* teardown ops (no thread yet), then four probes up to the hit (variant order BIK, BIK2, AVF, AVF2), reset, create... */
    CHECK(f.rig.op[0] == D2_OP_Z_UNREGISTER_A && f.rig.op[1] == D2_OP_Z_UNREGISTER_B && f.rig.op[2] == D2_OP_BINK_RELEASE);
    CHECK(f.rig.op[3] == D2_OP_FILE_EXISTS && f.rig.a[3] == 0 && f.rig.a[4] == 1 && f.rig.a[5] == 2);
    CHECK(strcmp(f.rig.name[3], "CLIPB") == 0);
    CHECK(f.rig.op[6] == D2_OP_STREAM_RESET && f.rig.op[7] == D2_OP_SURFACE_CREATE);
    CHECK(f.rig.a[7] == 64 && f.rig.b[7] == 48);
    CHECK(f.rig.op[8] == D2_OP_Z_REGISTER && f.rig.op[9] == D2_OP_THREAD_CREATE && f.rig.a[9] == 3);
    CHECK(f.rig.op[10] == D2_OP_THREAD_RESUME && f.rig.n == 11);
    d2_set_free(&f.set);
}

static void active_avf(Fix *f);

static void test_phase0_bink_and_failures(void)
{
    Fix f;
    D2StepResult res;
    fix_init(&f);
    sample(&f, "CLIPA", 0);
    f.rig.exists[1] = 1; /* second BIK directory */
    CHECK(step(&f, 0, 0, &res) == D2_OK);
    CHECK(f.obj.kind_21a == 1 && f.obj.clip_246 == 0 && f.obj.ring_17a == 0 && f.world.g_5839a9 == 1);
    CHECK(count_op(&f.rig, D2_OP_FILE_EXISTS) == 2 && count_op(&f.rig, D2_OP_BINK_OPEN) == 1);
    CHECK(count_op(&f.rig, D2_OP_BINK_PREPARE) == 1 && f.rig.b[f.rig.n - 1] == 6); /* word21 5 + 1 */
    CHECK(f.obj.thread_1d6 == 0);

    /* no file: the clip does not load, fatal */
    fix_init(&f);
    sample(&f, "CLIPA", 1);
    CHECK(step(&f, 0, 0, &res) == D2_ERR_FATAL);
    CHECK(count_op(&f.rig, D2_OP_FILE_EXISTS) == 4 && f.obj.movie.active == 1);
    /* surface of the wrong size */
    active_avf(&f);
    f.obj.movie.state_1de = 3;
    f.rig.rand_n = 1;
    f.rig.rand_queue[0] = 4; /* record 0: the next clip */
    f.rig.exists[0] = 1;
    f.rig.surface_w = 65; /* the surface kept from the first clip no longer fits */
    CHECK(step(&f, 2, 1, &res) == D2_ERR_FATAL);
    /* Bink open failure */
    fix_init(&f);
    sample(&f, "CLIPA", 1);
    f.rig.exists[0] = 1;
    f.rig.bink_open_result = 1;
    CHECK(step(&f, 0, 0, &res) == D2_ERR_FATAL && count_op(&f.rig, D2_OP_BINK_PREPARE) == 0);
    /* thread creation failure */
    fix_init(&f);
    sample(&f, "CLIPA", 1);
    f.rig.exists[2] = 1;
    f.rig.thread_handle = 0;
    CHECK(step(&f, 0, 0, &res) == D2_ERR_FATAL && f.obj.thread_1d6 == 0);
    /* unknown name, double init */
    fix_init(&f);
    sample(&f, "NOPE", 1);
    CHECK(step(&f, 0, 0, &res) == D2_ERR_FATAL && f.rig.n == 3u && f.obj.clip_246 == -1);
    fix_init(&f);
    sample(&f, "CLIPA", 1);
    f.rig.exists[0] = 1;
    CHECK(step(&f, 0, 0, &res) == D2_OK);
    f.rig.n = 0;
    CHECK(step(&f, 0, 0, &res) == D2_ERR_FATAL && f.rig.n == 0u);
    d2_set_free(&f.set);
}

static void test_random_set(void)
{
    Fix f;
    D2StepResult res;
    fix_init(&f);
    sample(&f, "RandomMovie", 1);
    f.rig.exists[0] = 1;
    f.rig.rand_n = 1;
    f.rig.rand_queue[0] = 7; /* 7 % 2 entries = 1 */
    CHECK(step(&f, 0, 0, &res) == D2_OK && f.obj.clip_246 == 1);
    CHECK(count_op(&f.rig, D2_OP_RAND) == 1);
    /* one entry: no rand */
    fix_init(&f);
    header(&f.body, "RandomMovie", 1, 1, 0);
    entry(&f.body, "ONLY", 1, 2, 0, 0, 1, 0);
    CHECK(fix_parse(&f) == D2_OK);
    f.rig.exists[0] = 1;
    CHECK(step(&f, 0, 0, &res) == D2_OK && f.obj.clip_246 == 0 && count_op(&f.rig, D2_OP_RAND) == 0);
    /* no entries: fatal */
    fix_init(&f);
    header(&f.body, "RandomMovie", 1, 0, 0);
    CHECK(fix_parse(&f) == D2_OK);
    CHECK(step(&f, 0, 0, &res) == D2_ERR_FATAL);
    d2_set_free(&f.set);
}

static void active_avf(Fix *f)
{
    D2StepResult res;
    fix_init(f);
    sample(f, "CLIPA", 1);
    f->rig.exists[2] = 1;
    CHECK(step(f, 2, 0, &res) == D2_OK);
    f->rig.n = 0;
}

static void test_phase1_avf_playback(void)
{
    Fix f;
    D2StepResult res;
    active_avf(&f);
    f.world.scene_key = 8; /* no group matches: nothing plays */
    CHECK(step(&f, 2, 1, &res) == D2_OK && f.obj.group_hit_236 == 0 && f.world.entry_flag == 0 && f.rig.n == 0u);
    CHECK(f.obj.scan_22e == 2);
    f.world.scene_key = 7;
    CHECK(step(&f, 2, 1, &res) == D2_OK && f.obj.group_hit_236 == 1 && f.world.entry_flag == 1 && f.obj.group_24a == 0);
    CHECK(f.rig.n == 0u); /* no frame ready yet */
    f.obj.ready_1d4 = 1;
    f.rig.tick_value = 1000;
    CHECK(step(&f, 2, 1, &res) == D2_OK);
    CHECK(f.rig.op[0] == D2_OP_FRAME_COPY && f.rig.a[0] == 0); /* mode word 1: the ring, index +0x192 = 0 */
    CHECK(f.obj.frame_232 == 5 && f.obj.frame_1ca == 6 && f.obj.movie.flag_206 == 1 && f.obj.flag_20a == 1);
    CHECK(f.obj.deadline_1c6 == 1100u && f.obj.ready_1d4 == 0 && f.obj.state_1da == 4);
    CHECK(f.obj.rects[0] == 1 && f.obj.rects[3] == 4 && f.obj.rects[4] == 110 && f.obj.rects[5] == 130 &&
          f.obj.rects[6] == 130 && f.obj.rects[7] == 150);
    /* before the deadline nothing happens (unsigned compare) */
    f.obj.ready_1d4 = 1;
    f.rig.tick_value = 1099;
    f.rig.n = 0;
    CHECK(step(&f, 2, 1, &res) == D2_OK && f.obj.ready_1d4 == 1 && count_op(&f.rig, D2_OP_FRAME_COPY) == 0);
    f.rig.tick_value = 1100;
    CHECK(step(&f, 2, 1, &res) == D2_OK && f.obj.frame_232 == 6 && f.obj.frame_1ca == 7 && f.obj.ready_1d4 == 0);
    /* the last frame (word23 = 9) ends the clip: flag 20e, then state 1de := 3 at the next deadline */
    f.obj.frame_1ca = 9;
    f.obj.ready_1d4 = 1;
    f.rig.tick_value = 1200;
    CHECK(step(&f, 2, 1, &res) == D2_OK && f.obj.frame_232 == 9 && f.obj.flag_20e == 1 && f.obj.ready_1d4 == 1);
    CHECK(f.obj.movie.state_1de == 0);
    f.rig.tick_value = 1300;
    CHECK(step(&f, 2, 1, &res) == D2_OK && f.obj.movie.state_1de == 3);
    d2_set_free(&f.set);
}

static void test_ring_buffer_selector(void)
{
    Fix f;
    D2StepResult res;
    fix_init(&f);
    sample(&f, "CLIPA", 1); /* mode word 1: ring */
    f.rig.exists[2] = 1;
    CHECK(step(&f, 0, 0, &res) == D2_OK && f.obj.ring_17a == 1);
    f.obj.buffer_192 = 2;
    f.obj.ready_1d4 = 1;
    f.rig.n = 0;
    CHECK(step(&f, 0, 1, &res) == D2_OK && f.rig.a[0] == 2);
    /* any other mode word: the single buffer (-1), and the four entry globals are cleared on every pass */
    fix_init(&f);
    sample(&f, "CLIPA", 0);
    f.rig.exists[2] = 1;
    f.world.g_5d1639 = 5; f.world.g_5d16cd = 6; f.world.g_5d1683 = 7;
    CHECK(step(&f, 0, 0, &res) == D2_OK && f.obj.ring_17a == 0 && f.world.g_5839a9 == 1 && f.world.g_5d1639 == 0);
    f.world.g_5d1683 = 9;
    f.obj.ready_1d4 = 1;
    f.rig.n = 0;
    CHECK(step(&f, 0, 1, &res) == D2_OK && f.rig.a[0] == -1 && f.world.g_5d1683 == 0 && f.world.g_5839a9 == 1);
    d2_set_free(&f.set);
}

static void test_phase1_bink_playback(void)
{
    Fix f;
    D2StepResult res;
    fix_init(&f);
    sample(&f, "CLIPA", 1);
    f.rig.exists[0] = 1;
    CHECK(step(&f, 0, 0, &res) == D2_OK && f.obj.kind_21a == 1);
    f.rig.n = 0;
    CHECK(step(&f, 0, 1, &res) == D2_OK);
    CHECK(f.rig.n == 1u && f.rig.op[0] == D2_OP_BINK_READY); /* ready 0: wait */
    f.rig.bink_ready = 1;
    f.rig.bink_more = 1;
    f.rig.bink_frame = 3;
    f.rig.n = 0;
    CHECK(step(&f, 0, 1, &res) == D2_OK);
    CHECK(f.rig.op[1] == D2_OP_BINK_NEXT && f.rig.op[2] == D2_OP_BINK_BLIT && f.rig.op[3] == D2_OP_BINK_FRAME &&
          f.rig.op[4] == D2_OP_BINK_MORE);
    CHECK(f.obj.frame_232 == 2 && f.obj.state_1da == 4 && f.obj.movie.state_1de == 0 && f.obj.flag_20a == 1);
    /* the last frame, or no frames remain, ends the clip */
    f.rig.bink_frame = 10; /* frame_232 = 9 = word23 */
    CHECK(step(&f, 0, 1, &res) == D2_OK && f.obj.movie.state_1de == 3);
    f.obj.movie.state_1de = 0;
    f.rig.bink_frame = 3;
    f.rig.bink_more = 0;
    CHECK(step(&f, 0, 1, &res) == D2_OK && f.obj.movie.state_1de == 3);
    d2_set_free(&f.set);
}

static void test_wait_and_pick(void)
{
    Fix f;
    D2StepResult res;
    active_avf(&f);
    f.obj.movie.state_1de = 1;
    f.obj.deadline_24e = 500;
    f.rig.tick_value = 499;
    CHECK(step(&f, 2, 1, &res) == D2_OK && f.obj.movie.state_1de == 1);
    f.rig.tick_value = 500;
    CHECK(step(&f, 2, 1, &res) == D2_OK && f.obj.movie.state_1de == 3);
    /* weights: stay 4, record 0 = 3, record 1 = 2, total 9. r in 0..3 stays, 4..6 record 0, 7..8 record 1 */
    static const int32_t want[9] = {-1, -1, -1, -1, 0, 0, 0, 1, 1};
    for (int r = 0; r < 9; ++r) {
        Fix g;
        active_avf(&g);
        g.obj.movie.state_1de = 3;
        g.obj.clip_246 = 0;
        g.rig.exists[0] = 1;
        g.rig.rand_n = 3;
        g.rig.rand_queue[0] = r;
        g.rig.rand_queue[1] = 50; /* delay roll */
        g.rig.tick_value = 2000;
        CHECK(step(&g, 2, 1, &res) == D2_OK);
        CHECK(g.obj.record_256 == want[r]);
        if (want[r] == -1) {
            /* stay: delay 100 + 50 % 200 = 150, deadline 2150, state 1, pending flag */
            CHECK(g.obj.delay_252 == 150 && g.obj.deadline_24e == 2150u && g.obj.movie.state_1de == 1 &&
                  g.obj.movie.pending_25a == 1);
        } else if (want[r] == 0) {
            CHECK(g.obj.clip_246 == 1 && g.obj.movie.state_1de == 0 && strcmp(g.obj.name_159, "CLIPB") == 0);
        } else {
            CHECK(g.obj.clip_246 == 0 && g.obj.movie.state_1de == 0 && strcmp(g.obj.name_159, "CLIPA") == 0);
        }
        /* the stream is torn down first */
        CHECK(g.rig.op[0] == D2_OP_STREAM_POLL && g.rig.op[1] == D2_OP_THREAD_STOP && g.rig.op[2] == D2_OP_THREAD_DELETE &&
              g.rig.op[3] == D2_OP_STREAM_RELEASE);
        d2_set_free(&g.set);
    }
    d2_set_free(&f.set);
}

static void test_delay_forms(void)
{
    Fix f;
    D2StepResult res;
    fix_init(&f);
    header(&f.body, "CLIPA", 1, 1, 1);
    entry(&f.body, "CLIPA", 1, 2, 300, 300, 1, 0); /* weight 1: always stays, delay min >= max: no roll */
    group(&f.body, 7, 0, 0, 0, 0, 0, 0, 0, 0);
    CHECK(fix_parse(&f) == D2_OK);
    f.rig.exists[2] = 1;
    CHECK(step(&f, 0, 0, &res) == D2_OK);
    f.obj.movie.state_1de = 3;
    f.rig.n = 0;
    f.rig.rand_value = 0;
    f.rig.tick_value = 0xfffffff0u; /* the deadline wraps */
    CHECK(step(&f, 0, 1, &res) == D2_OK);
    CHECK(f.obj.delay_252 == 300 && f.obj.deadline_24e == 0x11cu && count_op(&f.rig, D2_OP_RAND) == 1);
    d2_set_free(&f.set);
}

static void test_stop_and_destruct(void)
{
    Fix f;
    D2StepResult res;
    int32_t retire = 99;
    active_avf(&f);
    CHECK(d2_stop(&f.obj, &f.world, &f.host, &retire) == D2_OK);
    CHECK(retire == 2 && f.obj.movie.active == 0 && f.world.g_5839a9 == 5 && f.world.entry_flag == 0);
    CHECK(f.world.g_5831c8 == 1 && f.world.g_5831c6 == 0);
    CHECK(f.obj.action_23e == -1 && f.obj.movie.row == -1 && f.obj.movie.mode == 2 && f.obj.set == NULL);
    CHECK(f.obj.surface_212 == 0 && f.obj.thread_1d6 == 0 && f.obj.clip_246 == -1 && f.obj.group_24a == -1);
    CHECK(count_op(&f.rig, D2_OP_SURFACE_RELEASE) == 1 && count_op(&f.rig, D2_OP_THREAD_DELETE) == 1);
    /* a second stop has nothing to erase */
    CHECK(d2_stop(&f.obj, &f.world, &f.host, &retire) == D2_OK && retire == D2_NO_ROW);
    /* phase 2 stops the object and completes its own row */
    active_avf(&f);
    CHECK(step(&f, 2, 2, &res) == D2_OK && res.stopped == 1 && res.retire_row == 2 && res.phase_after == 0);
    CHECK(f.obj.movie.active == 0);
    d2_set_free(&f.set);
}

static void test_render_and_register(void)
{
    Fix f;
    D2RenderPlan plan;
    active_avf(&f);
    d2_register_entry(&f.obj, &f.world);
    CHECK(f.world.entry_type == 0xb && f.world.entry_flag_49 == 1 && strcmp(f.world.entry_label, "RAMDOM MOVIE") == 0);
    CHECK(f.world.entry_surface == 0 && f.world.entry_flag == 0);
    CHECK(d2_render_plan(&f.obj, &f.world, &plan) == D2_OK && plan.valid == 0);
    f.obj.movie.flag_206 = 1;
    f.world.entry_surface = 0x5000;
    f.world.back_buffer = 0x9000;
    f.obj.rects[0] = 1; f.obj.rects[7] = 8;
    CHECK(d2_render_plan(&f.obj, &f.world, &plan) == D2_OK && plan.valid == 1 && plan.surface == 0x5000 &&
          plan.target == 0x9000 && plan.src[0] == 1 && plan.dst[3] == 8);
    f.obj.movie.active = 0;
    CHECK(d2_render_plan(&f.obj, &f.world, &plan) == D2_OK && plan.valid == 0);
    d2_set_free(&f.set);
}

/* ----- raw 0x2e mode 0 through the binding pair ----- */
typedef struct {
    Fix fix;
    SessionA2dBinding *a2d;
    SessionA2EBinding *a2e;
    ActionCoreWorld core;
    int32_t flags[8];
    int32_t start_flag;
    int retire_called;
    int32_t retired;
} Pair;

static void p_start(void *c, int32_t v) { ((Pair *)c)->start_flag = v; }
static int p_transition(void *c, const SceneTransitionRequest *r) { (void)c; (void)r; return 0; }
static int p_stop(void *c, int32_t *retire)
{
    Pair *p = (Pair *)c;
    p->retire_called = 1;
    return session_a2d_stop(p->a2d, retire) == D2_OK ? 0 : 1;
}
static void p_load_world(void *c, D2World *w) { *w = ((Pair *)c)->fix.world; }
static void p_store_world(void *c, const D2World *w) { ((Pair *)c)->fix.world = *w; }
static int p_media(void *c) { (void)c; return 1; }

static void test_2e_stop_through_the_binding_pair(void)
{
    Pair p;
    SessionA2dHost dh;
    SessionA2EHost eh;
    D2StepResult res;
    uint8_t body[ACTION_FAMILY_2E_BODY_BYTES];
    SceneActionInfo info;
    SceneActionRuntimeState before = {0, 4u};
    SceneActionHandlerResult out = {SCENE_ACTION_HANDLER_COMPLETED, 9u};
    SessionA2EMovie movie;
    memset(&p, 0, sizeof p);
    fix_init(&p.fix);
    sample(&p.fix, "CLIPA", 1);
    p.fix.rig.exists[2] = 1;
    memset(&dh, 0, sizeof dh);
    dh.kernel = p.fix.host;
    dh.kernel.context = &p.fix.rig;
    dh.load_world = NULL;
    dh.media_available = p_media;
    p.a2d = session_a2d_create(&dh);
    p.core.event_flags = p.flags;
    p.core.event_flag_count = 8u;
    memset(&eh, 0, sizeof eh);
    eh.context = &p;
    eh.set_start_flag = p_start;
    eh.transition = p_transition;
    eh.stop_movie = p_stop;
    p.a2e = session_a2e_create(&eh, &p.core);
    CHECK(p.a2d != NULL && p.a2e != NULL);
    session_a2d_attach_a2e(p.a2d, p.a2e);
    (void)p_load_world; (void)p_store_world;
    /* bring the object up through the kernel on the binding's own object (the binding's rows come from a scene) */
    {
        D2Object *o = (D2Object *)session_a2d_object(p.a2d);
        D2World *w = (D2World *)session_a2d_world(p.a2d);
        w->g_5839a9 = 5;
        w->thread_arg = 3;
        o->rect_1ba = 63; o->rect_1be = 47;
        CHECK(d2_step(o, &p.fix.set, 2, 0, w, &dh.kernel, &res, NULL) == D2_OK && o->movie.active == 1);
        session_a2e_set_movie(p.a2e, &o->movie); /* what the binding does around every call */
    }
    /* a raw 0x2e row, mode 0, scene 9999, flag -1, start word 0 */
    memset(body, 0, sizeof body);
    body[0] = 0;
    body[1] = 0x0f; body[2] = 0x27; /* word 0 = 9999 */
    body[9] = 0xff; body[10] = 0xff; /* word 4 = -1 */
    memset(&info, 0, sizeof info);
    info.type = SESSION_A2E_TYPE;
    info.subtype = 1;
    info.typed_body = body;
    info.typed_body_length = ACTION_FAMILY_2E_BODY_BYTES;
    CHECK(session_a2e_handler(p.a2e, 6, &info, &before, &out) == SCENE_ACTION_HANDLER_OK);
    CHECK(p.retire_called == 1);
    CHECK(out.disposition == SCENE_ACTION_HANDLER_PENDING && out.phase == 4u); /* the completion store lands on row -1 */
    CHECK(p.start_flag == 1);
    movie = *session_a2e_movie(p.a2e);
    CHECK(movie.active == 0 && movie.row == -1 && movie.mode == 2);
    CHECK(session_a2d_object(p.a2d)->movie.active == 0 && session_a2d_object(p.a2d)->action_23e == -1);
    /* the next visit finds the object inactive and completes the row */
    out.disposition = SCENE_ACTION_HANDLER_PENDING;
    CHECK(session_a2e_handler(p.a2e, 6, &info, &before, &out) == SCENE_ACTION_HANDLER_OK);
    CHECK(out.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED);
    session_a2e_destroy(p.a2e);
    session_a2d_destroy(p.a2d);
    d2_set_free(&p.fix.set);
}

typedef void (*TestFn)(void);
int main(void)
{
    static const struct { const char *name; TestFn fn; } tests[] = {
        {"parse_rules", test_parse_rules},
        {"phase0_named_avf", test_phase0_named_avf},
        {"phase0_bink_and_failures", test_phase0_bink_and_failures},
        {"random_set", test_random_set},
        {"phase1_avf_playback", test_phase1_avf_playback},
        {"ring_buffer_selector", test_ring_buffer_selector},
        {"phase1_bink_playback", test_phase1_bink_playback},
        {"wait_and_pick", test_wait_and_pick},
        {"delay_forms", test_delay_forms},
        {"stop_and_destruct", test_stop_and_destruct},
        {"render_and_register", test_render_and_register},
        {"2e_stop_through_the_binding_pair", test_2e_stop_through_the_binding_pair},
    };
    int failures = 0;
    for (size_t i = 0; i < sizeof tests / sizeof tests[0]; ++i) {
        g_failed = 0;
        g_msg[0] = 0;
        tests[i].fn();
        if (g_failed) {
            printf("FAIL %s: %s\n", tests[i].name, g_msg);
            ++failures;
        } else {
            printf("PASS %s\n", tests[i].name);
        }
    }
    return failures;
}
