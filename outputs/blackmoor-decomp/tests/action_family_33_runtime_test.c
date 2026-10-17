/* RT-46 unit cases for raw 0x33 (secondary video with hotspots): the body parser and the step function
 * (src/action_family_33_runtime.c) over a scripted host. Prints "PASS name" / "FAIL name: reason" per case. */
#include <stdio.h>
#include <string.h>

#include "action_family_33_runtime.h"

static int failures;

#define CHECK(name, cond)                                                 \
    do {                                                                  \
        if (!(cond)) {                                                    \
            printf("FAIL %s: %s (line %d)\n", name, #cond, __LINE__);     \
            ++failures;                                                   \
            return;                                                       \
        }                                                                 \
    } while (0)

#define MAX_LOG 64

typedef struct {
    int op;
    int32_t a, b;
} LogEntry;

typedef struct {
    LogEntry log[MAX_LOG];
    int count;
    const A33State *watch; /* when set, the stream word 0x5b4c3a is sampled at THREAD_STOP */
    int32_t stream_at_stop;
    int fail_op;          /* 0 = none */
    int32_t surface_ret, thread_ret, overlay_ret;
    int32_t ticks[4];
    int tick_pos;
} Script;

static int script_op(void *context, int op, const A33OpArgs *args, int32_t *ret)
{
    Script *s = (Script *)context;
    if (s->count < MAX_LOG) {
        s->log[s->count].op = op;
        s->log[s->count].a = args->a;
        s->log[s->count].b = args->b;
        ++s->count;
    }
    if (op == A33_OP_THREAD_STOP && s->watch != NULL) {
        s->stream_at_stop = s->watch->stream_5b4c3a;
    }
    if (op == s->fail_op) {
        return 1;
    }
    *ret = 0;
    switch (op) {
    case A33_OP_SURFACE_CREATE: *ret = s->surface_ret; break;
    case A33_OP_THREAD_CREATE: *ret = s->thread_ret; break;
    case A33_OP_OVERLAY_LOAD: *ret = s->overlay_ret; break;
    case A33_OP_TICK: *ret = s->ticks[s->tick_pos < 3 ? s->tick_pos++ : 3]; break;
    default: break;
    }
    return 0;
}

static void script_init(Script *s, A33Host *host)
{
    memset(s, 0, sizeof *s);
    s->surface_ret = 0x1000;
    s->thread_ret = 0x2000;
    s->overlay_ret = 0x3000;
    host->context = s;
    host->op = script_op;
}

static int has_op(const Script *s, int op)
{
    for (int i = 0; i < s->count; ++i) {
        if (s->log[i].op == op) {
            return 1;
        }
    }
    return 0;
}

/* Body builder: fixed fields and tables, little-endian. */
typedef struct {
    const char *clip, *overlay;
    int16_t w42, w44, kind, anim, w4a, w4c, w4e, w50, w52, w54, w56, scene, w5a, w5c, w5e;
    int32_t d60, d64, d68;
    uint8_t push;
    int entries;
    int16_t ent[4][3];
    int hotspots;
    int32_t hs[4][17]; /* key, src1[4], dst1[4], src2[4], dst2[4] */
} BodySpec;

static void put16(uint8_t *p, int16_t v)
{
    p[0] = (uint8_t)(uint16_t)v;
    p[1] = (uint8_t)((uint16_t)v >> 8);
}

static void put32(uint8_t *p, int32_t v)
{
    uint32_t u = (uint32_t)v;
    p[0] = (uint8_t)u;
    p[1] = (uint8_t)(u >> 8);
    p[2] = (uint8_t)(u >> 16);
    p[3] = (uint8_t)(u >> 24);
}

static size_t build(uint8_t *out, const BodySpec *s)
{
    size_t n = 0x71u + 6u * (size_t)s->entries + 66u * (size_t)s->hotspots;
    memset(out, 0, n);
    strcpy((char *)out, s->clip);
    strcpy((char *)out + 0x21, s->overlay);
    put16(out + 0x42, s->w42);
    put16(out + 0x44, s->w44);
    put16(out + 0x46, s->kind);
    put16(out + 0x48, s->anim);
    put16(out + 0x4a, s->w4a);
    put16(out + 0x4c, s->w4c);
    put16(out + 0x4e, s->w4e);
    put16(out + 0x50, s->w50);
    put16(out + 0x52, s->w52);
    put16(out + 0x54, s->w54);
    put16(out + 0x56, s->w56);
    put16(out + 0x58, s->scene);
    put16(out + 0x5a, s->w5a);
    put16(out + 0x5c, s->w5c);
    put16(out + 0x5e, s->w5e);
    put32(out + 0x60, s->d60);
    put32(out + 0x64, s->d64);
    put32(out + 0x68, s->d68);
    out[0x6c] = s->push;
    put16(out + 0x6d, (int16_t)s->entries);
    put16(out + 0x6f, (int16_t)s->hotspots);
    for (int i = 0; i < s->entries; ++i) {
        for (int k = 0; k < 3; ++k) {
            put16(out + 0x71 + 6 * i + 2 * k, s->ent[i][k]);
        }
    }
    for (int i = 0; i < s->hotspots; ++i) {
        uint8_t *h = out + 0x71 + 6 * s->entries + 66 * i;
        put16(h, (int16_t)s->hs[i][0]);
        for (int k = 0; k < 16; ++k) {
            put32(h + 2 + 4 * k, s->hs[i][1 + k]);
        }
    }
    return n;
}

/* A hotspot whose rectangles lie inside a clip rectangle (0,0)-(639,479). */
static void inside_hotspot(BodySpec *s, int i, int key)
{
    static const int32_t v[16] = {1, 2, 11, 12, 100, 120, 160, 150, 21, 22, 31, 32, 200, 220, 260, 250};
    s->hs[i][0] = key;
    for (int k = 0; k < 16; ++k) {
        s->hs[i][1 + k] = v[k];
    }
}

static void base_spec(BodySpec *s)
{
    memset(s, 0, sizeof *s);
    s->clip = "CLIP01";
    s->overlay = "OVER01";
    s->w42 = 7;
    s->w44 = 2;
    s->kind = 1;
    s->anim = 1;
    s->w4a = 1;
    s->w4c = 3;
    s->w4e = 5;
    s->w50 = 4;
    s->w52 = 9;
    s->w54 = 11;
    s->w56 = 13;
    s->scene = 1234;
    s->w5a = 5;
    s->w5c = 6;
    s->w5e = 7;
    s->d60 = 70;
    s->d64 = 80;
    s->d68 = 90;
    s->push = 1;
}

typedef struct {
    A33Set set;
    A33State st;
    A33Row row;
    Script script;
    A33Host host;
    uint8_t buf[2048];
} Rig;

static int rig_init(Rig *r, const BodySpec *spec)
{
    size_t n;
    memset(r, 0, sizeof *r);
    n = build(r->buf, spec);
    script_init(&r->script, &r->host);
    a33_state_init(&r->st);
    r->st.surface_5d03bf = 0x1000u;
    r->st.selector_5bb50b = 3;
    r->st.thread_arg_5b016f = 9;
    r->st.scene_5bb57b = 55;
    r->st.vrect_5b4de8 = 10;
    r->st.vrect_5b4dec = 20;
    r->st.vrect_5b4df0 = 109;
    r->st.vrect_5b4df4 = 99;
    r->st.clip_5bb583[0] = 0;
    r->st.clip_5bb583[1] = 0;
    r->st.clip_5bb583[2] = 639;
    r->st.clip_5bb583[3] = 479;
    r->st.delay_5b4c5a = 40;
    r->st.view_x_583186 = 5;
    r->st.view_y_58318a = 6;
    return a33_set_parse(r->buf, n, &r->set, NULL) == A33_OK ? 0 : 1;
}

static int step(Rig *r, uint32_t phase, A33StepResult *res)
{
    return a33_step(&r->st, &r->set, 0, &r->row, phase, &r->host, res, NULL);
}

static void test_parse(void)
{
    BodySpec s;
    uint8_t buf[2048];
    A33Set set;
    size_t n;
    const char *why = NULL;
    base_spec(&s);
    s.entries = 2;
    s.ent[0][0] = 3; s.ent[0][1] = 4; s.ent[0][2] = -2;
    s.ent[1][0] = 5; s.ent[1][1] = -1; s.ent[1][2] = 9;
    s.hotspots = 1;
    inside_hotspot(&s, 0, 3);
    n = build(buf, &s);
    CHECK("parse", a33_set_parse(buf, n, &set, &why) == A33_OK);
    CHECK("parse", strcmp(set.clip, "CLIP01") == 0 && strcmp(set.overlay, "OVER01") == 0);
    CHECK("parse", set.w44 == 2 && set.scene_58 == 1234 && set.d68 == 90 && set.push_6c == 1u);
    CHECK("parse", set.entry_count == 2 && set.entries[0].value == -2 && set.entries[1].index == -1);
    CHECK("parse", set.hotspot_count == 1 && set.hotspots[0].key == 3 && set.hotspots[0].dst2[3] == 250);
    a33_set_free(&set);
    CHECK("parse-short", a33_set_parse(buf, n - 1u, &set, &why) == A33_ERR_BODY && why != NULL);
    put16(buf + 0x6f, -1);
    CHECK("parse-negative", a33_set_parse(buf, n, &set, &why) == A33_ERR_BODY);
    put16(buf + 0x6f, 1);
    memset(buf, 'x', 33);
    CHECK("parse-name", a33_set_parse(buf, n, &set, &why) == A33_ERR_BODY);
}

static void test_init_sequence(void)
{
    BodySpec s;
    Rig r;
    A33StepResult res;
    static const int expect[] = {A33_OP_Z_UNREGISTER, A33_OP_STREAM_RESET, A33_OP_SURFACE_CREATE, A33_OP_LOG,
                                 A33_OP_THREAD_CREATE, A33_OP_THREAD_RESUME};
    base_spec(&s);
    s.hotspots = 1;
    inside_hotspot(&s, 0, 3);
    CHECK("init", rig_init(&r, &s) == 0);
    r.st.surface_5d03bf = 0u;
    r.row.request = 1;
    CHECK("init", step(&r, 0u, &res) == A33_OK);
    CHECK("init-ops", r.script.count == 6);
    for (int i = 0; i < 6; ++i) {
        CHECK("init-ops", r.script.log[i].op == expect[i]);
    }
    CHECK("init-surface-size", r.script.log[2].a == 100 && r.script.log[2].b == 80);
    CHECK("init-log", r.script.log[3].a == A33_LOG_THREAD_START && r.script.log[3].b == 55);
    CHECK("init-thread-arg", r.script.log[4].a == 9 && r.script.log[5].a == 0x2000);
    CHECK("init-state", r.st.active_5c39f1 == 1 && r.st.row_5b4e89 == 0 && r.st.kind_5b4e8b == 1 && r.st.mode_5b4ea3 == 1);
    CHECK("init-surface", r.st.surface_5d03bf == 0x1000u && r.st.surface_5d195b == 0x1000u && r.st.thread_5b4e0c == 0x2000u);
    CHECK("init-anim1", r.st.frame_5b4e00 == 3 && r.st.state_5b4e10 == 0 && r.st.anim_5b4e14 == 0);
    CHECK("init-names", strcmp(r.st.clip_5b4d8f, "CLIP01") == 0 && r.st.w_5b4e02 == 7 && r.st.present_5b4e04 == 2);
    CHECK("init-request-cleared", r.row.request == 0);
    CHECK("init-result", res.initialized == 1u && res.phase_after == 1u && res.finished == 0u);
    CHECK("init-no-overlay", r.st.surface_5d03c7 == 0u);

    base_spec(&s);
    s.anim = 2;
    s.kind = 2;
    s.hotspots = 1;
    inside_hotspot(&s, 0, 3);
    CHECK("init2", rig_init(&r, &s) == 0);
    r.st.surface_5d03bf = 0u;
    CHECK("init2", step(&r, 0u, &res) == A33_OK);
    CHECK("init2-overlay", r.script.count == 7 && r.script.log[2].op == A33_OP_OVERLAY_LOAD);
    CHECK("init2-state", r.st.surface_5d03c7 == 0x3000u && strcmp(r.st.overlay_5b4e68, "OVER01") == 0);
    CHECK("init2-anim2", r.st.frame_5b4e00 == 11 && r.st.anim_5b4e14 == 3);
}

static void test_teardown(void)
{
    BodySpec s;
    Rig r;
    A33StepResult res;
    static const int expect[] = {A33_OP_STREAM_LOCK, A33_OP_THREAD_STOP, A33_OP_THREAD_DELETE, A33_OP_STREAM_UNLOCK,
                                 A33_OP_FREE, A33_OP_Z_UNREGISTER, A33_OP_SURFACE_RELEASE, A33_OP_SURFACE_RELEASE};
    base_spec(&s);
    s.hotspots = 1;
    inside_hotspot(&s, 0, 3);
    CHECK("teardown", rig_init(&r, &s) == 0);
    r.st.thread_5b4e0c = 0x77u;
    r.st.buf_5b4db8 = 0x500u;
    r.st.flags_5b4dc0 = 0u;
    r.st.buf_5b4dbc = 0x600u;
    r.st.flags_5b4dc2 = 8u; /* not freeable */
    r.st.surface_5d03bf = 0x41u;
    r.st.surface_5d03c7 = 0x42u;
    CHECK("teardown", step(&r, 0u, &res) == A33_OK);
    for (int i = 0; i < 8; ++i) {
        CHECK("teardown-ops", r.script.log[i].op == expect[i]);
    }
    CHECK("teardown-args", r.script.log[1].a == 0x77 && r.script.log[4].a == 0x500 && r.script.log[6].a == 0x41 &&
                               r.script.log[6].b == 0 && r.script.log[7].a == 0x42 && r.script.log[7].b == 1);
    CHECK("teardown-state", r.st.buf_5b4db8 == 0u && r.st.buf_5b4dbc == 0u && r.st.flags_5b4dc2 == 0u &&
                                r.st.stream_5b4c3a == 0 && r.st.surface_5d03c7 == 0u);
    CHECK("teardown-new-thread", r.st.thread_5b4e0c == 0x2000u);
    CHECK("teardown", rig_init(&r, &s) == 0);
    r.st.surface_5d03bf = 0u;
    r.st.thread_5b4e0c = 0x77u;
    r.script.watch = &r.st;
    CHECK("teardown-stream", step(&r, 0u, &res) == A33_OK && r.script.stream_at_stop == 2);
}

static void test_fatal(void)
{
    BodySpec s;
    Rig r;
    A33StepResult res;
    base_spec(&s);
    s.hotspots = 1;
    inside_hotspot(&s, 0, 3);
    CHECK("fatal", rig_init(&r, &s) == 0);
    r.st.active_5c39f1 = 1;
    CHECK("fatal-second-video", step(&r, 0u, &res) == A33_ERR_FATAL);
    CHECK("fatal-second-video", r.script.count == 1 && r.script.log[0].a == A33_LOG_SECOND_VIDEO && r.st.row_5b4e89 == 0);

    CHECK("fatal", rig_init(&r, &s) == 0);
    r.st.surface_5d03bf = 0u;
    r.script.thread_ret = 0;
    CHECK("fatal-thread", step(&r, 0u, &res) == A33_ERR_FATAL);
    CHECK("fatal-thread", r.script.log[r.script.count - 1].a == A33_LOG_THREAD_MEMORY && r.st.thread_5b4e0c == 0u);

    base_spec(&s);
    s.hotspots = 0;
    CHECK("fatal", rig_init(&r, &s) == 0);
    CHECK("fatal-no-hotspots", step(&r, 1u, &res) == A33_ERR_FATAL);
    CHECK("fatal-no-hotspots", r.script.count == 1 && r.script.log[0].a == A33_LOG_MISSING_HOTSPOTS);

    base_spec(&s);
    s.hotspots = 1;
    inside_hotspot(&s, 0, 3);
    CHECK("host-failure", rig_init(&r, &s) == 0);
    r.script.fail_op = A33_OP_STREAM_RESET;
    CHECK("host-failure", step(&r, 0u, &res) == A33_ERR_HOST);
    CHECK("other-phase", rig_init(&r, &s) == 0);
    CHECK("other-phase", step(&r, 3u, &res) == A33_OK && r.script.count == 0 && res.phase_after == 3u);
}

static void test_first_frame(void)
{
    BodySpec s;
    Rig r;
    A33StepResult res;
    base_spec(&s);
    s.entries = 2;
    s.ent[0][0] = 3; s.ent[0][1] = 4; s.ent[0][2] = -2;     /* matches the frame 3 */
    s.ent[1][0] = 3; s.ent[1][1] = -1; s.ent[1][2] = 9;     /* index -1: skipped */
    s.hotspots = 2;
    inside_hotspot(&s, 0, 8);
    inside_hotspot(&s, 1, 3);
    CHECK("first", rig_init(&r, &s) == 0);
    r.st.state_5b4e10 = 0;
    r.st.present_5b4e04 = 2;
    r.st.frame_5b4e00 = 3;
    r.st.ready_5b4e0a = 1;
    r.script.ticks[0] = 1000;
    CHECK("first", step(&r, 1u, &res) == A33_OK);
    CHECK("first-ops", r.script.count == 5 && r.script.log[4].op == A33_OP_TICK);
    CHECK("first-ops", r.script.log[0].op == A33_OP_EVENT_FLAG && r.script.log[0].a == 4 && r.script.log[0].b == -2);
    CHECK("first-ops", r.script.log[1].op == A33_OP_STREAM_LOCK && r.script.log[2].op == A33_OP_SURFACE_PIXELS &&
                           r.script.log[3].op == A33_OP_STREAM_UNLOCK);
    CHECK("first-state", r.st.state_5b4e10 == 4 && r.st.ready_5b4e0a == 0 && r.st.start_5bb1ca == 1);
    CHECK("first-page", r.st.page_5b4dc8 == 1);
    CHECK("first-frame", r.st.frame_5b4e00 == 4);
    CHECK("first-deadline", r.st.deadline_5b4dfc == 1040u);
    /* inside rectangles: the source copies, the destination takes the view origin, the latch is set */
    CHECK("first-rects", r.st.src1_5b4e18[0] == 1 && r.st.src1_5b4e18[1] == 2 && r.st.src1_5b4e18[2] == 11 &&
                             r.st.src1_5b4e18[3] == 12);
    CHECK("first-rects", r.st.dst1_5b4e28[0] == 105 && r.st.dst1_5b4e28[1] == 126 && r.st.dst1_5b4e28[2] == 165 &&
                             r.st.dst1_5b4e28[3] == 156);
    CHECK("first-rel", r.st.rel_dst1_5b4e58[0] == 100 && r.st.rel_dst1_5b4e58[1] == 120 && r.st.rel_dst1_5b4e58[2] == 160 &&
                           r.st.rel_dst1_5b4e58[3] == 150);
    CHECK("first-latch", r.st.latch_5d1967 == 1 && r.st.flag_5b4e8d == 0);

    /* a selector that matches no hotspot still moves 0 -> 4 without effects */
    CHECK("first-nomatch", rig_init(&r, &s) == 0);
    r.st.ready_5b4e0a = 1;
    r.st.selector_5bb50b = 99;
    CHECK("first-nomatch", step(&r, 1u, &res) == A33_OK);
    CHECK("first-nomatch", r.script.count == 0 && r.st.state_5b4e10 == 4 && r.st.ready_5b4e0a == 1 && r.st.start_5bb1ca == 0);

    /* not ready: nothing happens and the state stays 0 */
    CHECK("first-notready", rig_init(&r, &s) == 0);
    CHECK("first-notready", step(&r, 1u, &res) == A33_OK && r.script.count == 0 && r.st.state_5b4e10 == 0);
}

static void test_running(void)
{
    BodySpec s;
    Rig r;
    A33StepResult res;
    base_spec(&s);
    s.hotspots = 1;
    inside_hotspot(&s, 0, 3);
    s.w44 = 1; /* no page buffers shown */
    CHECK("running", rig_init(&r, &s) == 0);
    r.st.state_5b4e10 = 4;
    r.st.deadline_5b4dfc = 500u;
    r.st.ready_5b4e0a = 1;
    r.script.ticks[0] = 499; /* before the deadline: only the rectangles, the frame stays flagged */
    CHECK("running-early", step(&r, 1u, &res) == A33_OK);
    CHECK("running-early", r.script.count == 1 && r.st.ready_5b4e0a == 1 && r.st.frame_5b4e00 == 0 && r.st.latch_5d1967 == 1);

    CHECK("running", rig_init(&r, &s) == 0);
    r.st.state_5b4e10 = 4;
    r.st.deadline_5b4dfc = 500u;
    r.st.ready_5b4e0a = 1;
    r.st.frame_5b4e00 = 5;
    r.script.ticks[0] = 500; /* at the deadline (unsigned compare): flip, flags, advance (5 -> 6 wraps to 3), new deadline */
    r.script.ticks[1] = (int32_t)0xfffffff0u; /* the new deadline wraps past 2^32 */
    CHECK("running-due", step(&r, 1u, &res) == A33_OK);
    CHECK("running-due", r.script.count == 4 && r.script.log[0].op == A33_OP_TICK && r.script.log[1].op == A33_OP_STREAM_LOCK);
    CHECK("running-due", r.script.log[2].op == A33_OP_STREAM_UNLOCK && r.script.log[3].op == A33_OP_TICK);
    CHECK("running-due-state", r.st.ready_5b4e0a == 0 && r.st.frame_5b4e00 == 3 && r.st.deadline_5b4dfc == 0x18u);
}

static void test_finish(void)
{
    BodySpec s;
    Rig r;
    A33StepResult res;
    base_spec(&s);
    s.hotspots = 1;
    inside_hotspot(&s, 0, 3);
    CHECK("finish", rig_init(&r, &s) == 0);
    r.st.active_5c39f1 = 1;
    r.st.row_5b4e89 = 0;
    CHECK("finish-not-ready", step(&r, 2u, &res) == A33_OK && res.finished == 0u && r.script.count == 0 &&
                                  r.st.active_5c39f1 == 1);
    r.st.ready_5b4e0a = 1;
    CHECK("finish", step(&r, 2u, &res) == A33_OK && res.finished == 1u);
    CHECK("finish-push", r.script.count == 1 && r.script.log[0].op == A33_OP_PUSH_SCENE && r.script.log[0].a == 2);
    CHECK("finish-cells", r.st.scene_5bb57b == 1234 && r.st.w_5bb599 == 5 && r.st.w_5bb595 == 6 && r.st.w_5c39ff == 7 &&
                              r.st.d_5bb59b == 70 && r.st.d_5bb59f == 80 && r.st.d_5bb5a3 == 90 && r.st.mode_583999 == 4);
    CHECK("finish-state", r.st.row_5b4e89 == -1 && r.st.kind_5b4e8b == 1 && r.st.mode_5b4ea3 == 1 && r.st.active_5c39f1 == 0);
    s.push = 0;
    CHECK("finish", rig_init(&r, &s) == 0);
    r.st.ready_5b4e0a = 1;
    CHECK("finish-no-push", step(&r, 2u, &res) == A33_OK && r.script.count == 0 && res.finished == 1u);
}

static void test_clipping(void)
{
    BodySpec s;
    Rig r;
    A33StepResult res;
    base_spec(&s);
    s.kind = 2;
    s.w4a = 2;
    s.hotspots = 1;
    inside_hotspot(&s, 0, 3);
    /* destination rectangle 1 straddles the bottom edge of the clip rectangle (top 440, bottom 500, clip bottom 479) */
    s.hs[0][1 + 4 + 1] = 440;
    s.hs[0][1 + 4 + 3] = 500;
    s.hs[0][1 + 0 + 1] = 10;  /* src1 top */
    s.hs[0][1 + 0 + 3] = 70;  /* src1 bottom */
    /* destination rectangle 2 lies fully above the clip rectangle's top (-50..-10) */
    s.hs[0][1 + 12 + 1] = -50;
    s.hs[0][1 + 12 + 3] = -10;
    CHECK("clip", rig_init(&r, &s) == 0);
    r.st.row_5b4e89 = 0;
    r.st.kind_5b4e8b = 2;
    r.st.mode_5b4ea3 = 2;
    r.st.state_5b4e10 = 4;
    r.st.deadline_5b4dfc = 10u;
    r.script.ticks[0] = 5;
    CHECK("clip", step(&r, 1u, &res) == A33_OK);
    CHECK("clip-request", r.row.request == 1 && r.row.rect[0] == 100 && r.row.rect[1] == 440 && r.row.rect[3] == 500);
    CHECK("clip-src", r.st.src1_5b4e18[1] == 10 && r.st.src1_5b4e18[3] == 70 - (500 - 479));
    CHECK("clip-dst", r.st.dst1_5b4e28[1] == 440 + 6 && r.st.dst1_5b4e28[3] == 479 + 6);
    CHECK("clip-rel", r.st.rel_dst1_5b4e58[1] == 440 && r.st.rel_dst1_5b4e58[3] == 479);
    CHECK("clip-second-outside", r.st.flag_5b4e8d == 0);
    CHECK("clip-latch", r.st.latch_5d1967 == 1);
}

/* One due pass of state 4 (the tick is at or past the deadline) with a flagged frame, so the advance runs. */
static void due_pass(Rig *r, int16_t frame, int32_t anim, int32_t candidate)
{
    A33StepResult res;
    r->st.state_5b4e10 = 4;
    r->st.deadline_5b4dfc = 100u;
    r->st.ready_5b4e0a = 1;
    r->st.frame_5b4e00 = frame;
    r->st.anim_5b4e14 = anim;
    r->st.latch_5c39e5 = candidate;
    r->st.row_5b4e89 = 0;
    r->script.tick_pos = 0;
    r->script.ticks[0] = 200;
    r->script.ticks[1] = 300;
    (void)step(r, 1u, &res);
}

static void test_advance(void)
{
    BodySpec s;
    Rig r;
    base_spec(&s); /* loop 3..5, hold end 9, end 13 */
    s.hotspots = 1;
    inside_hotspot(&s, 0, 3);
    CHECK("advance", rig_init(&r, &s) == 0);
    due_pass(&r, 5, 0, 0);
    CHECK("advance-loop-wrap", r.st.frame_5b4e00 == 3 && r.st.anim_5b4e14 == 0);
    CHECK("advance", rig_init(&r, &s) == 0);
    due_pass(&r, 4, 0, 0);
    CHECK("advance-loop-last", r.st.frame_5b4e00 == 5);
    CHECK("advance", rig_init(&r, &s) == 0);
    due_pass(&r, 9, 1, 0);
    CHECK("advance-hold-clamp", r.st.frame_5b4e00 == 9 && r.st.anim_5b4e14 == 1);
    CHECK("advance", rig_init(&r, &s) == 0);
    due_pass(&r, 8, 1, 0);
    CHECK("advance-hold-last", r.st.frame_5b4e00 == 9 && r.st.anim_5b4e14 == 1);
    CHECK("advance", rig_init(&r, &s) == 0);
    due_pass(&r, 8, 1, 7); /* the candidate names another row: hold turns to reverse */
    CHECK("advance-hold-to-reverse", r.st.anim_5b4e14 == 2);
    CHECK("advance", rig_init(&r, &s) == 0);
    due_pass(&r, 4, 2, 0);
    CHECK("advance-reverse", r.st.frame_5b4e00 == 3 && r.st.anim_5b4e14 == 2);
    CHECK("advance", rig_init(&r, &s) == 0);
    due_pass(&r, 3, 2, 0);
    CHECK("advance-reverse-snap", r.st.frame_5b4e00 == 3 && r.st.anim_5b4e14 == 0);
    CHECK("advance", rig_init(&r, &s) == 0);
    due_pass(&r, 13, 3, 0);
    CHECK("advance-end-clamp", r.st.frame_5b4e00 == 13 && r.st.anim_5b4e14 == 3);
    CHECK("advance", rig_init(&r, &s) == 0);
    due_pass(&r, 12, 3, 0);
    CHECK("advance-end-last", r.st.frame_5b4e00 == 13);
}

static void test_pages_and_deadline(void)
{
    BodySpec s;
    Rig r;
    A33StepResult res;
    base_spec(&s);
    s.hotspots = 1;
    inside_hotspot(&s, 0, 3);
    CHECK("pages", rig_init(&r, &s) == 0);
    r.st.present_5b4e04 = 2;
    r.st.buf_5b4db8 = 0x500u;
    r.st.buf_5b4dbc = 0x600u;
    due_pass(&r, 3, 0, 0);
    CHECK("pages-first", r.st.page_5b4dc8 == 1 && r.script.log[2].op == A33_OP_SURFACE_PIXELS &&
                             r.script.log[2].a == 0x1000 && r.script.log[2].b == 0x600);
    r.script.count = 0;
    due_pass(&r, 3, 0, 0);
    CHECK("pages-second", r.st.page_5b4dc8 == 0 && r.script.log[2].b == 0x500);
    CHECK("pages", rig_init(&r, &s) == 0);
    r.st.present_5b4e04 = 1;
    due_pass(&r, 3, 0, 0);
    CHECK("pages-no-pixels", r.st.page_5b4dc8 == 1 && !has_op(&r.script, A33_OP_SURFACE_PIXELS));
    CHECK("pages", rig_init(&r, &s) == 0);
    r.st.surface_5d03bf = 0u;
    due_pass(&r, 3, 0, 0);
    CHECK("pages-no-surface", r.st.page_5b4dc8 == 0 && !has_op(&r.script, A33_OP_STREAM_LOCK));
    /* the deadline compare is unsigned: a deadline past 2^31 is still in the future for a small tick */
    CHECK("deadline", rig_init(&r, &s) == 0);
    r.st.state_5b4e10 = 4;
    r.st.deadline_5b4dfc = 0x80000010u;
    r.st.ready_5b4e0a = 1;
    r.script.ticks[0] = 5;
    CHECK("deadline-early", step(&r, 1u, &res) == A33_OK && r.script.count == 1 && r.st.ready_5b4e0a == 1);
}

static void test_clip_cuts(void)
{
    BodySpec s;
    Rig r;
    A33StepResult res;
    base_spec(&s);
    s.kind = 2;
    s.hotspots = 1;
    inside_hotspot(&s, 0, 3);
    CHECK("cuts", rig_init(&r, &s) == 0);
    r.st.kind_5b4e8b = 2;
    r.st.state_5b4e10 = 4;
    r.st.deadline_5b4dfc = 10u;
    r.script.ticks[0] = 5;
    CHECK("cuts-inside", step(&r, 1u, &res) == A33_OK && r.st.flag_5b4e8d == 1);
    CHECK("cuts-second", r.st.src2_5b4e38[0] == 21 && r.st.src2_5b4e38[3] == 32 && r.st.dst2_5b4e48[0] == 205 &&
                             r.st.dst2_5b4e48[1] == 226 && r.st.dst2_5b4e48[2] == 265 && r.st.dst2_5b4e48[3] == 256);
    CHECK("cuts-second-rel", r.st.rel_dst2_5b4e93[0] == 200 && r.st.rel_dst2_5b4e93[1] == 220 && r.st.rel_dst2_5b4e93[2] == 260 &&
                                 r.st.rel_dst2_5b4e93[3] == 250);
    /* destination rectangle 1 straddles the top edge: top -30, bottom 50, source rows 100..180 */
    s.hs[0][1 + 4 + 1] = -30;
    s.hs[0][1 + 4 + 3] = 50;
    s.hs[0][1 + 0 + 1] = 100;
    s.hs[0][1 + 0 + 3] = 180;
    CHECK("cuts", rig_init(&r, &s) == 0);
    r.st.kind_5b4e8b = 1;
    r.st.state_5b4e10 = 4;
    r.st.deadline_5b4dfc = 10u;
    r.script.ticks[0] = 5;
    CHECK("cuts-top", step(&r, 1u, &res) == A33_OK);
    CHECK("cuts-top-src", r.st.src1_5b4e18[1] == 130 && r.st.src1_5b4e18[3] == 180);
    CHECK("cuts-top-dst", r.st.dst1_5b4e28[1] == 0 + 6 && r.st.dst1_5b4e28[3] == 50 + 6);
    /* fully outside above the clip rectangle: nothing is accepted, the relative rectangle follows the old working one */
    s.hs[0][1 + 4 + 1] = -90;
    s.hs[0][1 + 4 + 3] = -40;
    CHECK("cuts", rig_init(&r, &s) == 0);
    r.st.state_5b4e10 = 4;
    r.st.deadline_5b4dfc = 10u;
    r.script.ticks[0] = 5;
    CHECK("cuts-outside", step(&r, 1u, &res) == A33_OK && r.st.latch_5d1967 == 0 && r.st.dst1_5b4e28[1] == 0 &&
                              r.st.rel_dst1_5b4e58[1] == -6);
}

static void test_scene_clear(void)
{
    BodySpec s;
    Rig r;
    A33StepResult res;
    base_spec(&s);
    s.hotspots = 1;
    inside_hotspot(&s, 0, 3);
    CHECK("clear", rig_init(&r, &s) == 0);
    r.st.active_5c39f1 = 1;
    r.st.row_5b4e89 = 0;
    r.st.kind_5b4e8b = 2;
    r.st.latch_5d1967 = 1;
    r.st.flag_5b4e8d = 1;
    r.st.latch_5c39e5 = 4;
    r.st.surface_5d03c7 = 0x42u;
    r.st.thread_5b4e0c = 0x77u;
    CHECK("clear", a33_scene_clear(&r.st, &r.host) == A33_OK);
    CHECK("clear-ops", r.script.count == 2 && r.script.log[0].op == A33_OP_SURFACE_RELEASE && r.script.log[0].a == 0x42 &&
                           r.script.log[0].b == 1 && r.script.log[1].a == 0x1000 && r.script.log[1].b == 0);
    CHECK("clear-state", r.st.active_5c39f1 == 0 && r.st.row_5b4e89 == -1 && r.st.kind_5b4e8b == 1 && r.st.latch_5d1967 == 0 &&
                             r.st.flag_5b4e8d == 0 && r.st.latch_5c39e5 == -1 && r.st.surface_5d03c7 == 0u &&
                             r.st.surface_5d03bf == 0u);
    CHECK("clear-thread-stays", r.st.thread_5b4e0c == 0x77u);
    /* a phase 0 after the clear releases nothing twice */
    r.script.count = 0;
    CHECK("clear-then-init", step(&r, 0u, &res) == A33_OK && !has_op(&r.script, A33_OP_SURFACE_RELEASE));
}

int main(void)
{
    test_parse();
    test_init_sequence();
    test_teardown();
    test_fatal();
    test_first_frame();
    test_running();
    test_finish();
    test_clipping();
    test_advance();
    test_pages_and_deadline();
    test_clip_cuts();
    test_scene_clear();
    (void)has_op;
    printf(failures == 0 ? "ALL PASS\n" : "FAILURES\n");
    return failures == 0 ? 0 : 1;
}
