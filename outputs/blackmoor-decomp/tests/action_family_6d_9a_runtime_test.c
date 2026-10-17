/* RT-57 unit cases for raw 0x6d and raw 0x9a: the kernels (src/action_family_{6d,9a}_runtime.c) and the bindings
 * (src/session_bindings_a6d_a9a.c). Bodies are written here; prints "PASS name" / "FAIL name: reason" per case. */
#include <stdio.h>
#include <string.h>

#include "session_bindings_a6d_a9a.h"

static int failures;

#define CHECK(name, cond)                                      \
    do {                                                       \
        if (!(cond)) {                                         \
            printf("FAIL %s: %s (line %d)\n", name, #cond, __LINE__); \
            ++failures;                                        \
            return;                                            \
        }                                                      \
    } while (0)
#define PASS(name) printf("PASS %s\n", name)

/* ---- helpers ------------------------------------------------------------------------------------------------------------ */
static void put16(uint8_t *p, unsigned byte_offset, uint16_t v)
{
    p[byte_offset] = (uint8_t)v;
    p[byte_offset + 1u] = (uint8_t)(v >> 8);
}

static void put32(uint8_t *p, unsigned byte_offset, uint32_t v)
{
    put16(p, byte_offset, (uint16_t)v);
    put16(p, byte_offset + 2u, (uint16_t)(v >> 16));
}

static void info_for(SceneActionInfo *info, uint8_t type, const uint8_t *raw, size_t len)
{
    memset(info, 0, sizeof *info);
    info->type = type;
    info->subtype = 1u;
    info->raw_body = raw;
    info->raw_body_length = len;
}

/* The 27-byte body of raw 0x9a. Layout (byte offsets): 0 sound, 2 scene, 4/6/8 words, 10/14/18 dwords, 22 flag index, 24 flag
 * value byte, 25..26 start word. */
typedef struct {
    int16_t sound, scene;
    int16_t w4, w6, w8;
    uint32_t d10, d14, d18;
    int16_t flag_index;
    uint8_t flag_value;
    uint16_t start_word;
} Body9a;

static size_t body9a(uint8_t *out, const Body9a *b, size_t tail)
{
    memset(out, 0, 27u + 16u * tail);
    put16(out, 0u, (uint16_t)b->sound);
    put16(out, 2u, (uint16_t)b->scene);
    put16(out, 4u, (uint16_t)b->w4);
    put16(out, 6u, (uint16_t)b->w6);
    put16(out, 8u, (uint16_t)b->w8);
    put32(out, 10u, b->d10);
    put32(out, 14u, b->d14);
    put32(out, 18u, b->d18);
    put16(out, 22u, (uint16_t)b->flag_index);
    out[24] = b->flag_value;
    put16(out, 25u, b->start_word);
    return 27u + 16u * tail;
}

static Body9a plain9a(void)
{
    Body9a b;
    memset(&b, 0, sizeof b);
    b.sound = 5;
    b.scene = ACTION_FAMILY_9A_SCENE_NONE;
    b.flag_index = -1;
    return b;
}

/* ---- raw 0x6d ----------------------------------------------------------------------------------------------------------- */
typedef struct {
    int events[16];
    int n;
    int unload_calls, teardown_calls;
    int unload_result, teardown_result;
    Action6DTeardown last_kind;
    int load_calls, load_result, store_calls;
    Action6DWorld load_value, stored;
} Host6d;

enum { EV_TEARDOWN = 100, EV_UNLOAD = 101 };

static int h6d_unload(void *c)
{
    Host6d *h = (Host6d *)c;
    ++h->unload_calls;
    h->events[h->n++] = EV_UNLOAD;
    return h->unload_result;
}

static int h6d_teardown(void *c, Action6DTeardown kind)
{
    Host6d *h = (Host6d *)c;
    ++h->teardown_calls;
    h->last_kind = kind;
    h->events[h->n++] = EV_TEARDOWN;
    return h->teardown_result;
}

static int h6d_load(void *c, Action6DWorld *w)
{
    Host6d *h = (Host6d *)c;
    ++h->load_calls;
    *w = h->load_value;
    return h->load_result;
}

static void h6d_store(void *c, const Action6DWorld *w)
{
    Host6d *h = (Host6d *)c;
    ++h->store_calls;
    h->stored = *w;
}

static Action6DWorld world6d(int32_t mode, int32_t overlay)
{
    Action6DWorld w;
    memset(&w, 0, sizeof w);
    w.popup_mode_583204 = mode;
    w.overlay_flag_5bb22a = overlay;
    w.overlay_return_6b2 = 1234;
    w.outer_state_583981 = 77;
    w.cell_5839a1 = 78;
    w.engine_mode_583999 = 79;
    w.cell_5bb1e2 = 80;
    return w;
}

static void decode6d(ActionFamily6DDecoded *d, uint8_t *raw)
{
    raw[0] = 0x5au;
    (void)action_family_6d_decode(raw, 1u, d);
}

static void test_6d_select(void)
{
    const char *name = "6d select - overlay flag first, then mode 4, then mode 3, else none";
    Action6DWorld w;
    static const int32_t modes[] = {0, 1, 2, 3, 4, 5, -1, 0x10000, 0x10004, 0x10003};
    size_t i;

    for (i = 0; i < sizeof modes / sizeof modes[0]; ++i) {
        const int32_t m = modes[i];
        const Action6DTeardown expect = m == 4 ? ACTION_FAMILY_6D_TEARDOWN_MODE4
                                      : m == 3 ? ACTION_FAMILY_6D_TEARDOWN_MODE3
                                               : ACTION_FAMILY_6D_TEARDOWN_NONE;
        w = world6d(m, 0);
        CHECK(name, action_family_6d_runtime_select(&w) == expect);
        w = world6d(m, 1);
        CHECK(name, action_family_6d_runtime_select(&w) == ACTION_FAMILY_6D_TEARDOWN_OVERLAY);
        w = world6d(m, -1);
        CHECK(name, action_family_6d_runtime_select(&w) == ACTION_FAMILY_6D_TEARDOWN_OVERLAY);
        w = world6d(m, 0x100);
        CHECK(name, action_family_6d_runtime_select(&w) == ACTION_FAMILY_6D_TEARDOWN_OVERLAY);
    }
    PASS(name);
}

static void test_6d_kernel_no_teardown(void)
{
    const char *name = "6d kernel without a teardown runs the tail only";
    ActionFamily6DDecoded d;
    Action6DWorld w;
    Host6d h;
    Action6DHost kh;
    uint8_t raw[1];
    static const int32_t modes[] = {0, 1, 2, 5, -1, 6};
    size_t i;

    decode6d(&d, raw);
    for (i = 0; i < sizeof modes / sizeof modes[0]; ++i) {
        memset(&h, 0, sizeof h);
        kh.context = &h;
        kh.unload_scene_sound = h6d_unload;
        kh.teardown = NULL;                                                   /* not needed when no kind is selected */
        w = world6d(modes[i], 0);
        CHECK(name, action_family_6d_runtime_visit(&d, &w, &kh) == ACTION_FAMILY_6D_RUNTIME_OK);
        CHECK(name, h.unload_calls == 1 && h.n == 1);
        CHECK(name, w.popup_mode_583204 == modes[i] && w.overlay_flag_5bb22a == 0 && w.overlay_return_6b2 == 1234);
        CHECK(name, w.outer_state_583981 == 6 && w.cell_5839a1 == 0 && w.engine_mode_583999 == 0 && w.cell_5bb1e2 == 0);
    }
    PASS(name);
}

static void test_6d_kernel_teardowns(void)
{
    const char *name = "6d kernel teardowns run before the sound unload and clear their cells";
    ActionFamily6DDecoded d;
    Action6DWorld w;
    Host6d h;
    Action6DHost kh;
    uint8_t raw[1];

    decode6d(&d, raw);
    kh.unload_scene_sound = h6d_unload;
    kh.teardown = h6d_teardown;

    memset(&h, 0, sizeof h);
    kh.context = &h;
    w = world6d(4, 0);
    CHECK(name, action_family_6d_runtime_visit(&d, &w, &kh) == ACTION_FAMILY_6D_RUNTIME_OK);
    CHECK(name, h.last_kind == ACTION_FAMILY_6D_TEARDOWN_MODE4 && h.n == 2 && h.events[0] == EV_TEARDOWN && h.events[1] == EV_UNLOAD);
    CHECK(name, w.popup_mode_583204 == 0 && w.overlay_flag_5bb22a == 0 && w.overlay_return_6b2 == 1234);
    CHECK(name, w.outer_state_583981 == 6 && w.cell_5839a1 == 0 && w.engine_mode_583999 == 0 && w.cell_5bb1e2 == 0);

    memset(&h, 0, sizeof h);
    w = world6d(3, 0);
    CHECK(name, action_family_6d_runtime_visit(&d, &w, &kh) == ACTION_FAMILY_6D_RUNTIME_OK);
    CHECK(name, h.last_kind == ACTION_FAMILY_6D_TEARDOWN_MODE3 && h.teardown_calls == 1 && h.events[0] == EV_TEARDOWN);
    CHECK(name, w.popup_mode_583204 == 0 && w.overlay_return_6b2 == 1234);

    memset(&h, 0, sizeof h);
    w = world6d(4, 1);                                                        /* the overlay wins over mode 4 */
    CHECK(name, action_family_6d_runtime_visit(&d, &w, &kh) == ACTION_FAMILY_6D_RUNTIME_OK);
    CHECK(name, h.last_kind == ACTION_FAMILY_6D_TEARDOWN_OVERLAY && h.teardown_calls == 1);
    CHECK(name, w.popup_mode_583204 == 0 && w.overlay_flag_5bb22a == 0 && w.overlay_return_6b2 == ACTION_FAMILY_6D_STORED_RETURN_SCENE);
    CHECK(name, w.outer_state_583981 == 6 && w.cell_5bb1e2 == 0);

    memset(&h, 0, sizeof h);
    w = world6d(0, 1);                                                        /* the overlay alone */
    CHECK(name, action_family_6d_runtime_visit(&d, &w, &kh) == ACTION_FAMILY_6D_RUNTIME_OK);
    CHECK(name, h.last_kind == ACTION_FAMILY_6D_TEARDOWN_OVERLAY && w.overlay_return_6b2 == 9999);
    PASS(name);
}

static void test_6d_kernel_failures(void)
{
    const char *name = "6d kernel failures and refusals change nothing";
    ActionFamily6DDecoded d;
    Action6DWorld w, before;
    Host6d h;
    Action6DHost kh;
    uint8_t raw[1];

    decode6d(&d, raw);
    memset(&h, 0, sizeof h);
    kh.context = &h;
    kh.unload_scene_sound = h6d_unload;
    kh.teardown = h6d_teardown;

    w = world6d(4, 0);
    before = w;
    h.teardown_result = 1;
    CHECK(name, action_family_6d_runtime_visit(&d, &w, &kh) == ACTION_FAMILY_6D_RUNTIME_ERR_HOST);
    CHECK(name, memcmp(&w, &before, sizeof w) == 0 && h.unload_calls == 0);   /* a failed teardown stops before the unload */
    h.teardown_result = 0;
    h.unload_result = 1;
    CHECK(name, action_family_6d_runtime_visit(&d, &w, &kh) == ACTION_FAMILY_6D_RUNTIME_ERR_HOST);
    CHECK(name, memcmp(&w, &before, sizeof w) == 0 && h.unload_calls == 1 && h.teardown_calls == 2);
    w = world6d(0, 0);
    before = w;
    CHECK(name, action_family_6d_runtime_visit(&d, &w, &kh) == ACTION_FAMILY_6D_RUNTIME_ERR_HOST);
    CHECK(name, memcmp(&w, &before, sizeof w) == 0);                          /* the unload failure alone */
    h.unload_result = 0;

    kh.teardown = NULL;
    w = world6d(3, 0);
    before = w;
    memset(&h.events, 0, sizeof h.events);
    h.n = 0;
    h.unload_calls = 0;
    CHECK(name, action_family_6d_runtime_visit(&d, &w, &kh) == ACTION_FAMILY_6D_RUNTIME_ERR_TEARDOWN);
    CHECK(name, memcmp(&w, &before, sizeof w) == 0 && h.unload_calls == 0);   /* refused before any effect */
    w = world6d(0, 1);
    CHECK(name, action_family_6d_runtime_visit(&d, &w, &kh) == ACTION_FAMILY_6D_RUNTIME_ERR_TEARDOWN);

    kh.teardown = h6d_teardown;
    w = world6d(0, 0);
    CHECK(name, action_family_6d_runtime_visit(NULL, &w, &kh) == ACTION_FAMILY_6D_RUNTIME_ERR_ARGUMENT);
    CHECK(name, action_family_6d_runtime_visit(&d, NULL, &kh) == ACTION_FAMILY_6D_RUNTIME_ERR_ARGUMENT);
    CHECK(name, action_family_6d_runtime_visit(&d, &w, NULL) == ACTION_FAMILY_6D_RUNTIME_ERR_ARGUMENT);
    kh.unload_scene_sound = NULL;
    CHECK(name, action_family_6d_runtime_visit(&d, &w, &kh) == ACTION_FAMILY_6D_RUNTIME_ERR_ARGUMENT);
    PASS(name);
}

static void host6d_init(Host6d *h, SessionA6dHost *sh)
{
    memset(h, 0, sizeof *h);
    memset(sh, 0, sizeof *sh);
    sh->context = h;
    sh->load_world = h6d_load;
    sh->store_world = h6d_store;
    sh->unload_scene_sound = h6d_unload;
    h->load_value = world6d(0, 0);
}

static void test_6d_binding(void)
{
    const char *name = "6d binding - direct completion keeps the phase, cells committed";
    Host6d h;
    SessionA6dHost sh;
    SessionA6dBinding *b;
    uint8_t raw[1 + 16];
    SceneActionInfo info;
    SceneActionRuntimeState before = {0u, 5u};
    SceneActionHandlerResult r;

    host6d_init(&h, &sh);
    b = session_a6d_create(&sh);
    CHECK(name, b != NULL && session_a6d_visits(b) == 0ul);
    memset(raw, 0, sizeof raw);
    info_for(&info, SESSION_A6D_TYPE, raw, sizeof raw);                       /* body plus one dependency row */
    r.disposition = SCENE_ACTION_HANDLER_PENDING;
    r.phase = 9u;
    CHECK(name, session_a6d_handler(b, 3u, &info, &before, &r) == SCENE_ACTION_HANDLER_OK);
    CHECK(name, r.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED && r.phase == 5u);
    CHECK(name, h.unload_calls == 1 && h.load_calls == 1 && h.store_calls == 1 && session_a6d_visits(b) == 1ul);
    CHECK(name, h.stored.outer_state_583981 == 6 && h.stored.engine_mode_583999 == 0 && h.stored.cell_5bb1e2 == 0);
    CHECK(name, session_a6d_last_world(b) != NULL && session_a6d_last_world(b)->outer_state_583981 == 6);
    CHECK(name, strcmp(session_a6d_failure(b), "none") == 0);
    before.phase = 0u;
    CHECK(name, session_a6d_handler(b, 3u, &info, &before, &r) == SCENE_ACTION_HANDLER_OK && r.phase == 0u);
    CHECK(name, session_a6d_visits(b) == 2ul);
    session_a6d_destroy(b);

    sh.store_world = NULL;                                                    /* the commit is optional */
    b = session_a6d_create(&sh);
    CHECK(name, session_a6d_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_OK);
    session_a6d_destroy(b);
    CHECK(name, session_a6d_create(NULL) == NULL);
    CHECK(name, strcmp(session_a6d_failure(NULL), "invalid binding") == 0);
    CHECK(name, session_a6d_last_world(NULL) == NULL && session_a6d_visits(NULL) == 0ul);
    session_a6d_destroy(NULL);
    PASS(name);
}

static void test_6d_binding_teardown_host(void)
{
    const char *name = "6d binding - a selected teardown needs the host and its result is honoured";
    Host6d h;
    SessionA6dHost sh;
    SessionA6dBinding *b;
    uint8_t raw[1] = {0};
    SceneActionInfo info;
    SceneActionRuntimeState before = {0u, 0u};
    SceneActionHandlerResult r;

    host6d_init(&h, &sh);
    h.load_value = world6d(4, 0);
    b = session_a6d_create(&sh);                                              /* no teardown host */
    info_for(&info, SESSION_A6D_TYPE, raw, 1u);
    CHECK(name, session_a6d_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    CHECK(name, h.unload_calls == 0 && h.store_calls == 0 && session_a6d_visits(b) == 0ul);
    CHECK(name, strstr(session_a6d_failure(b), "teardown") != NULL);
    session_a6d_destroy(b);

    sh.teardown = h6d_teardown;
    b = session_a6d_create(&sh);
    CHECK(name, session_a6d_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_OK);
    CHECK(name, h.last_kind == ACTION_FAMILY_6D_TEARDOWN_MODE4 && h.events[0] == EV_TEARDOWN && h.stored.popup_mode_583204 == 0);
    h.teardown_result = 1;
    CHECK(name, session_a6d_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(name, h.store_calls == 1 && session_a6d_visits(b) == 1ul);
    CHECK(name, strstr(session_a6d_failure(b), "failed") != NULL);
    session_a6d_destroy(b);
    PASS(name);
}

static void test_6d_binding_refusals(void)
{
    const char *name = "6d binding - refusals commit nothing";
    Host6d h;
    SessionA6dHost sh;
    SessionA6dBinding *b;
    uint8_t raw[1] = {0};
    SceneActionInfo info;
    SceneActionRuntimeState before = {0u, 0u};
    SceneActionHandlerResult r;

    host6d_init(&h, &sh);
    b = session_a6d_create(&sh);
    info_for(&info, SESSION_A6D_TYPE, raw, 1u);
    h.load_result = 1;
    CHECK(name, session_a6d_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    CHECK(name, h.unload_calls == 0 && h.store_calls == 0 && session_a6d_visits(b) == 0ul);
    h.load_result = 0;
    h.unload_result = 1;
    CHECK(name, session_a6d_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(name, h.store_calls == 0 && session_a6d_visits(b) == 0ul);
    h.unload_result = 0;
    info.raw_body_length = 0u;                                                /* an empty body is refused */
    CHECK(name, session_a6d_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_ERROR);
    info.raw_body_length = 1u;
    info.type = SESSION_A9A_TYPE;
    CHECK(name, session_a6d_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_ERROR);
    info.type = SESSION_A6D_TYPE;
    CHECK(name, session_a6d_handler(NULL, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(name, session_a6d_handler(b, 0u, NULL, &before, &r) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(name, session_a6d_handler(b, 0u, &info, NULL, &r) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(name, session_a6d_handler(b, 0u, &info, &before, NULL) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(name, h.unload_calls == 1 && h.store_calls == 0);
    CHECK(name, strcmp(session_a6d_failure(b), "none") != 0);
    CHECK(name, session_a6d_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_OK);    /* success clears the text */
    CHECK(name, strcmp(session_a6d_failure(b), "none") == 0 && session_a6d_visits(b) == 1ul);
    session_a6d_destroy(b);

    sh.load_world = NULL;
    b = session_a6d_create(&sh);
    CHECK(name, session_a6d_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    session_a6d_destroy(b);
    sh.load_world = h6d_load;
    sh.unload_scene_sound = NULL;
    h.store_calls = 0;
    b = session_a6d_create(&sh);
    CHECK(name, session_a6d_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    CHECK(name, h.store_calls == 0);
    session_a6d_destroy(b);
    PASS(name);
}

/* ---- raw 0x9a ----------------------------------------------------------------------------------------------------------- */
typedef struct {
    int events[64];
    int n;
    int stop_calls, invalid_calls, store_flag_calls, transition_calls, load_calls, store_calls;
    int stop_fail_at;                      /* fail when this channel is stopped (-1 never) */
    int invalid_result, store_flag_result, transition_result, load_result;
    int16_t invalid_index_seen, stored_index;
    uint32_t stored_value;
    Action9AWorld load_value, stored;
    SceneTransitionRequest request;
} Host9a;

enum { EV_STOP = 0x1000, EV_INVALID = 0x2000, EV_FLAG = 0x3000, EV_STORE_WORLD = 0x4000, EV_TRANSITION = 0x5000 };

static int h9_stop(void *c, uint16_t channel)
{
    Host9a *h = (Host9a *)c;
    ++h->stop_calls;
    h->events[h->n++] = EV_STOP + (int)channel;
    return (int)channel == h->stop_fail_at ? 1 : 0;
}

static int h9_invalid(void *c, int16_t index)
{
    Host9a *h = (Host9a *)c;
    ++h->invalid_calls;
    h->invalid_index_seen = index;
    h->events[h->n++] = EV_INVALID;
    return h->invalid_result;
}

static int h9_store_flag(void *c, int16_t index, uint32_t value)
{
    Host9a *h = (Host9a *)c;
    ++h->store_flag_calls;
    h->stored_index = index;
    h->stored_value = value;
    h->events[h->n++] = EV_FLAG;
    return h->store_flag_result;
}

static int h9_load(void *c, Action9AWorld *w)
{
    Host9a *h = (Host9a *)c;
    ++h->load_calls;
    *w = h->load_value;
    return h->load_result;
}

static void h9_store(void *c, const Action9AWorld *w)
{
    Host9a *h = (Host9a *)c;
    ++h->store_calls;
    h->stored = *w;
    h->events[h->n++] = EV_STORE_WORLD;
}

static int h9_transition(void *c, const SceneTransitionRequest *r)
{
    Host9a *h = (Host9a *)c;
    ++h->transition_calls;
    h->request = *r;
    h->events[h->n++] = EV_TRANSITION;
    return h->transition_result;
}

static void host9a_init(Host9a *h, Action9AHost *kh)
{
    memset(h, 0, sizeof *h);
    h->stop_fail_at = -1;
    kh->context = h;
    kh->stop_channel = h9_stop;
    kh->event_flag_invalid = h9_invalid;
    kh->store_event_flag = h9_store_flag;
}

static Action9AWorld world9a(void)
{
    Action9AWorld w;
    memset(&w, 0, sizeof w);
    w.scene_5bb57b = 1001;
    w.word_5bb599 = 1002;
    w.word_5bb595 = 1003;
    w.word_5c39ff = 1004;
    w.dword_5bb59b = 1005;
    w.dword_5bb59f = 1006;
    w.dword_5bb5a3 = 1007;
    w.start_flag_5bb1ca = 1008;
    w.engine_mode_583999 = 1009;
    return w;
}

static void test_9a_phases(void)
{
    const char *name = "9a kernel phases - 0 becomes 2 pending, other values than 2 do nothing";
    ActionFamily9ADecoded d;
    Action9AWorld w, before;
    Action9AOutcome out;
    Action9AHost kh;
    Host9a h;
    Body9a b = plain9a();
    uint8_t raw[27];
    static const uint32_t others[] = {1u, 3u, 4u, 5u, 0x102u, 0x80000002u, 0xffffffffu};
    size_t i;

    b.flag_index = 7;
    b.scene = 40;
    body9a(raw, &b, 0u);
    CHECK(name, action_family_9a_decode(raw, 27u, &d) == ACTION_FAMILY_9A_OK);
    host9a_init(&h, &kh);
    w = before = world9a();
    memset(&out, 0x77, sizeof out);
    CHECK(name, action_family_9a_runtime_visit(&d, 0u, &w, &kh, &out) == ACTION_FAMILY_9A_RUNTIME_OK);
    CHECK(name, out.phase == 2u && out.disposition == SCENE_ACTION_HANDLER_PENDING && out.worked == 0 && out.transition == 0);
    CHECK(name, h.n == 0 && memcmp(&w, &before, sizeof w) == 0);
    for (i = 0; i < sizeof others / sizeof others[0]; ++i) {
        memset(&out, 0x77, sizeof out);
        CHECK(name, action_family_9a_runtime_visit(&d, others[i], &w, &kh, &out) == ACTION_FAMILY_9A_RUNTIME_OK);
        CHECK(name, out.phase == others[i] && out.disposition == SCENE_ACTION_HANDLER_PENDING && out.worked == 0 && out.transition == 0);
        CHECK(name, h.n == 0 && memcmp(&w, &before, sizeof w) == 0);
    }
    PASS(name);
}

static void test_9a_sound_stops(void)
{
    const char *name = "9a kernel sound stop - 0x14 is 0..13, 0x15 is 1..13, anything else one channel";
    ActionFamily9ADecoded d;
    Action9AWorld w;
    Action9AOutcome out;
    Action9AHost kh;
    Host9a h;
    Body9a b = plain9a();
    uint8_t raw[27];
    static const int16_t singles[] = {0, 1, 5, 13, 14, 19, 22, 0x7fff, -1, -32768, 0x16, 0x13};
    int ch, k;
    size_t i;

    host9a_init(&h, &kh);
    b.sound = 0x14;
    body9a(raw, &b, 0u);
    action_family_9a_decode(raw, 27u, &d);
    w = world9a();
    CHECK(name, action_family_9a_runtime_visit(&d, 2u, &w, &kh, &out) == ACTION_FAMILY_9A_RUNTIME_OK);
    CHECK(name, h.stop_calls == 14 && h.n == 14);
    for (ch = 0; ch < 14; ++ch) CHECK(name, h.events[ch] == EV_STOP + ch);
    CHECK(name, out.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED && out.worked == 1 && out.phase == 2u);

    host9a_init(&h, &kh);
    b.sound = 0x15;
    body9a(raw, &b, 0u);
    action_family_9a_decode(raw, 27u, &d);
    CHECK(name, action_family_9a_runtime_visit(&d, 2u, &w, &kh, &out) == ACTION_FAMILY_9A_RUNTIME_OK);
    CHECK(name, h.stop_calls == 13 && h.n == 13);
    for (k = 0; k < 13; ++k) CHECK(name, h.events[k] == EV_STOP + 1 + k);

    for (i = 0; i < sizeof singles / sizeof singles[0]; ++i) {
        host9a_init(&h, &kh);
        b.sound = singles[i];
        body9a(raw, &b, 0u);
        action_family_9a_decode(raw, 27u, &d);
        CHECK(name, action_family_9a_runtime_visit(&d, 2u, &w, &kh, &out) == ACTION_FAMILY_9A_RUNTIME_OK);
        CHECK(name, h.stop_calls == 1 && h.events[0] == EV_STOP + (int)(uint16_t)singles[i]);   /* the low 16 bits */
    }
    PASS(name);
}

static void test_9a_no_scene(void)
{
    const char *name = "9a kernel without a scene (word 9999) leaves the cells alone and still stores the event flag";
    ActionFamily9ADecoded d;
    Action9AWorld w, before;
    Action9AOutcome out;
    Action9AHost kh;
    Host9a h;
    Body9a b = plain9a();
    uint8_t raw[27];

    host9a_init(&h, &kh);
    b.flag_index = 12;
    b.flag_value = 0xfeu;
    b.w4 = 99;
    b.start_word = 5;
    body9a(raw, &b, 0u);
    action_family_9a_decode(raw, 27u, &d);
    w = before = world9a();
    CHECK(name, action_family_9a_runtime_visit(&d, 2u, &w, &kh, &out) == ACTION_FAMILY_9A_RUNTIME_OK);
    CHECK(name, memcmp(&w, &before, sizeof w) == 0 && out.transition == 0 && out.worked == 1);
    CHECK(name, h.invalid_calls == 1 && h.invalid_index_seen == 12 && h.store_flag_calls == 1);
    CHECK(name, h.stored_index == 12 && h.stored_value == 0xfeu);
    /* order: invalid query, the stop, then the store */
    CHECK(name, h.n == 3 && h.events[0] == EV_INVALID && h.events[1] == EV_STOP + 5 && h.events[2] == EV_FLAG);
    PASS(name);
}

static void test_9a_scene_cells(void)
{
    const char *name = "9a kernel scene change copies every cell from its body bytes";
    ActionFamily9ADecoded d;
    Action9AWorld w;
    Action9AOutcome out;
    Action9AHost kh;
    Host9a h;
    Body9a b = plain9a();
    uint8_t raw[27];

    host9a_init(&h, &kh);
    b.scene = 2877;
    b.w4 = 11;
    b.w6 = -12;
    b.w8 = 13;
    b.d10 = 0x80000001u;
    b.d14 = 0x0102a3f4u;
    b.d18 = 0xfffffffeu;
    b.start_word = 1;                                                         /* equal to 1: start flag 0 */
    body9a(raw, &b, 0u);
    action_family_9a_decode(raw, 27u, &d);
    w = world9a();
    CHECK(name, action_family_9a_runtime_visit(&d, 2u, &w, &kh, &out) == ACTION_FAMILY_9A_RUNTIME_OK);
    CHECK(name, out.transition == 1 && out.worked == 1 && out.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED);
    CHECK(name, w.scene_5bb57b == 2877 && w.word_5bb599 == 11 && w.word_5bb595 == -12 && w.word_5c39ff == 13);
    CHECK(name, w.dword_5bb59b == (int32_t)0x80000001u && w.dword_5bb59f == 0x0102a3f4 && w.dword_5bb5a3 == -2);
    CHECK(name, w.start_flag_5bb1ca == 0 && w.engine_mode_583999 == 4);
    CHECK(name, h.stop_calls == 1 && h.store_flag_calls == 0 && h.invalid_calls == 0);   /* flag index -1: no query, no store */

    b.scene = -1;                                                             /* signed compare: -1 is a scene */
    body9a(raw, &b, 0u);
    action_family_9a_decode(raw, 27u, &d);
    w = world9a();
    CHECK(name, action_family_9a_runtime_visit(&d, 2u, &w, &kh, &out) == ACTION_FAMILY_9A_RUNTIME_OK);
    CHECK(name, out.transition == 1 && w.scene_5bb57b == -1);
    b.scene = 9998;
    body9a(raw, &b, 0u);
    action_family_9a_decode(raw, 27u, &d);
    CHECK(name, action_family_9a_runtime_visit(&d, 2u, &w, &kh, &out) == ACTION_FAMILY_9A_RUNTIME_OK && out.transition == 1);
    b.scene = 10000;
    body9a(raw, &b, 0u);
    action_family_9a_decode(raw, 27u, &d);
    CHECK(name, action_family_9a_runtime_visit(&d, 2u, &w, &kh, &out) == ACTION_FAMILY_9A_RUNTIME_OK && out.transition == 1);
    PASS(name);
}

static void test_9a_start_word(void)
{
    const char *name = "9a kernel start flag is the signed word at bytes 25..26 compared with 1";
    ActionFamily9ADecoded d;
    Action9AWorld w;
    Action9AOutcome out;
    Action9AHost kh;
    Host9a h;
    Body9a b = plain9a();
    uint8_t raw[27];
    static const struct { uint16_t word; int expect; } cases[] = {
        {1u, 0}, {0u, 1}, {2u, 1}, {0x0100u, 1}, {0x0101u, 1}, {0xff01u, 1}, {0x8001u, 1}, {0xffffu, 1}, {0x0001u, 0}};
    size_t i;

    b.scene = 50;
    for (i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        host9a_init(&h, &kh);
        b.start_word = cases[i].word;
        b.flag_value = 0x33u;                                                 /* must not leak into the start word */
        body9a(raw, &b, 0u);
        action_family_9a_decode(raw, 27u, &d);
        w = world9a();
        w.start_flag_5bb1ca = 55;
        CHECK(name, action_family_9a_runtime_visit(&d, 2u, &w, &kh, &out) == ACTION_FAMILY_9A_RUNTIME_OK);
        CHECK(name, w.start_flag_5bb1ca == cases[i].expect);
    }
    PASS(name);
}

static void test_9a_event_flag(void)
{
    const char *name = "9a kernel event flag - zero-extended byte 24, validated before any effect";
    ActionFamily9ADecoded d;
    Action9AWorld w, before;
    Action9AOutcome out;
    Action9AHost kh;
    Host9a h;
    Body9a b = plain9a();
    uint8_t raw[27];
    static const uint8_t values[] = {0, 1, 2, 0x7f, 0x80, 0xff};
    static const int16_t indexes[] = {0, 1, 300, 0x7fff, -2, -32768};
    size_t i;

    for (i = 0; i < sizeof values / sizeof values[0]; ++i) {
        host9a_init(&h, &kh);
        b.flag_index = indexes[i];
        b.flag_value = values[i];
        b.start_word = 0xab00u;                                               /* byte 25 is not the flag value */
        body9a(raw, &b, 0u);
        action_family_9a_decode(raw, 27u, &d);
        w = world9a();
        CHECK(name, action_family_9a_runtime_visit(&d, 2u, &w, &kh, &out) == ACTION_FAMILY_9A_RUNTIME_OK);
        CHECK(name, h.store_flag_calls == 1 && h.stored_index == indexes[i] && h.stored_value == (uint32_t)values[i]);
        CHECK(name, h.invalid_calls == 1 && h.invalid_index_seen == indexes[i]);
    }

    host9a_init(&h, &kh);                                                     /* invalid index: refused before any stop */
    h.invalid_result = 1;
    b.flag_index = 9;
    b.flag_value = 1;
    b.scene = 70;
    b.sound = 0x14;
    body9a(raw, &b, 0u);
    action_family_9a_decode(raw, 27u, &d);
    w = before = world9a();
    memset(&out, 0, sizeof out);
    CHECK(name, action_family_9a_runtime_visit(&d, 2u, &w, &kh, &out) == ACTION_FAMILY_9A_RUNTIME_ERR_FLAG);
    CHECK(name, h.stop_calls == 0 && h.store_flag_calls == 0 && memcmp(&w, &before, sizeof w) == 0);
    CHECK(name, h.n == 1 && h.events[0] == EV_INVALID);
    /* phase 0 and other phases never query */
    h.n = 0;
    h.invalid_calls = 0;
    CHECK(name, action_family_9a_runtime_visit(&d, 0u, &w, &kh, &out) == ACTION_FAMILY_9A_RUNTIME_OK && h.invalid_calls == 0);
    CHECK(name, action_family_9a_runtime_visit(&d, 3u, &w, &kh, &out) == ACTION_FAMILY_9A_RUNTIME_OK && h.invalid_calls == 0);
    PASS(name);
}

static void test_9a_failures(void)
{
    const char *name = "9a kernel host failures leave the world untouched";
    ActionFamily9ADecoded d;
    Action9AWorld w, before;
    Action9AOutcome out;
    Action9AHost kh;
    Host9a h;
    Body9a b = plain9a();
    uint8_t raw[27];

    b.sound = 0x14;
    b.scene = 70;
    b.flag_index = 4;
    b.flag_value = 3;
    body9a(raw, &b, 0u);
    action_family_9a_decode(raw, 27u, &d);

    host9a_init(&h, &kh);
    h.stop_fail_at = 6;                                                       /* the loop stops at the failing channel */
    w = before = world9a();
    CHECK(name, action_family_9a_runtime_visit(&d, 2u, &w, &kh, &out) == ACTION_FAMILY_9A_RUNTIME_ERR_HOST);
    CHECK(name, h.stop_calls == 7 && h.store_flag_calls == 0 && memcmp(&w, &before, sizeof w) == 0);

    host9a_init(&h, &kh);
    h.store_flag_result = 1;
    CHECK(name, action_family_9a_runtime_visit(&d, 2u, &w, &kh, &out) == ACTION_FAMILY_9A_RUNTIME_ERR_HOST);
    CHECK(name, h.stop_calls == 14 && h.store_flag_calls == 1 && memcmp(&w, &before, sizeof w) == 0);

    b.sound = 3;                                                              /* the single-channel path fails too */
    body9a(raw, &b, 0u);
    action_family_9a_decode(raw, 27u, &d);
    host9a_init(&h, &kh);
    h.stop_fail_at = 3;
    CHECK(name, action_family_9a_runtime_visit(&d, 2u, &w, &kh, &out) == ACTION_FAMILY_9A_RUNTIME_ERR_HOST);
    CHECK(name, h.store_flag_calls == 0 && memcmp(&w, &before, sizeof w) == 0);

    host9a_init(&h, &kh);
    CHECK(name, action_family_9a_runtime_visit(NULL, 2u, &w, &kh, &out) == ACTION_FAMILY_9A_RUNTIME_ERR_ARGUMENT);
    CHECK(name, action_family_9a_runtime_visit(&d, 2u, NULL, &kh, &out) == ACTION_FAMILY_9A_RUNTIME_ERR_ARGUMENT);
    CHECK(name, action_family_9a_runtime_visit(&d, 2u, &w, NULL, &out) == ACTION_FAMILY_9A_RUNTIME_ERR_ARGUMENT);
    CHECK(name, action_family_9a_runtime_visit(&d, 2u, &w, &kh, NULL) == ACTION_FAMILY_9A_RUNTIME_ERR_ARGUMENT);
    kh.stop_channel = NULL;
    CHECK(name, action_family_9a_runtime_visit(&d, 2u, &w, &kh, &out) == ACTION_FAMILY_9A_RUNTIME_ERR_ARGUMENT);
    kh.stop_channel = h9_stop;
    kh.event_flag_invalid = NULL;
    CHECK(name, action_family_9a_runtime_visit(&d, 2u, &w, &kh, &out) == ACTION_FAMILY_9A_RUNTIME_ERR_ARGUMENT);
    kh.event_flag_invalid = h9_invalid;
    kh.store_event_flag = NULL;
    CHECK(name, action_family_9a_runtime_visit(&d, 2u, &w, &kh, &out) == ACTION_FAMILY_9A_RUNTIME_ERR_ARGUMENT);
    CHECK(name, h.n == 0);
    PASS(name);
}

static void host9a_session_init(Host9a *h, SessionA9aHost *sh)
{
    memset(h, 0, sizeof *h);
    memset(sh, 0, sizeof *sh);
    h->stop_fail_at = -1;
    h->load_value = world9a();
    sh->context = h;
    sh->load_world = h9_load;
    sh->store_world = h9_store;
    sh->stop_channel = h9_stop;
    sh->event_flag_invalid = h9_invalid;
    sh->store_event_flag = h9_store_flag;
    sh->transition = h9_transition;
}

static void test_9a_binding_phases(void)
{
    const char *name = "9a binding - phase 0 pends with phase 2, phase 2 completes directly";
    Host9a h;
    SessionA9aHost sh;
    SessionA9aBinding *b;
    Body9a body = plain9a();
    uint8_t raw[27 + 16];
    SceneActionInfo info;
    SceneActionRuntimeState before = {0u, 0u};
    SceneActionHandlerResult r;

    host9a_session_init(&h, &sh);
    b = session_a9a_create(&sh);
    CHECK(name, b != NULL && session_a9a_visits(b) == 0ul);
    info_for(&info, SESSION_A9A_TYPE, raw, body9a(raw, &body, 1u));           /* body plus one dependency row */
    r.disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;
    r.phase = 99u;
    CHECK(name, session_a9a_handler(b, 2u, &info, &before, &r) == SCENE_ACTION_HANDLER_OK);
    CHECK(name, r.disposition == SCENE_ACTION_HANDLER_PENDING && r.phase == 2u);
    CHECK(name, h.stop_calls == 0 && h.store_calls == 0 && h.transition_calls == 0 && session_a9a_visits(b) == 1ul);
    before.phase = 2u;
    CHECK(name, session_a9a_handler(b, 2u, &info, &before, &r) == SCENE_ACTION_HANDLER_OK);
    CHECK(name, r.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED && r.phase == 2u);
    CHECK(name, h.stop_calls == 1 && h.events[0] == EV_STOP + 5 && h.store_calls == 1 && h.transition_calls == 0);
    CHECK(name, session_a9a_last_world(b) != NULL && session_a9a_last_world(b)->start_flag_5bb1ca == 1008);   /* loaded cells kept */
    CHECK(name, h.stored.scene_5bb57b == 1001 && session_a9a_visits(b) == 2ul && strcmp(session_a9a_failure(b), "none") == 0);
    before.phase = 1u;                                                        /* other phases: nothing, phase kept */
    h.stop_calls = 0;
    h.store_calls = 0;
    CHECK(name, session_a9a_handler(b, 2u, &info, &before, &r) == SCENE_ACTION_HANDLER_OK);
    CHECK(name, r.disposition == SCENE_ACTION_HANDLER_PENDING && r.phase == 1u && h.stop_calls == 0 && h.store_calls == 0);
    session_a9a_destroy(b);
    CHECK(name, session_a9a_create(NULL) == NULL);
    CHECK(name, strcmp(session_a9a_failure(NULL), "invalid binding") == 0);
    CHECK(name, session_a9a_last_world(NULL) == NULL && session_a9a_visits(NULL) == 0ul);
    session_a9a_destroy(NULL);
    PASS(name);
}

static void test_9a_binding_transition(void)
{
    const char *name = "9a binding - the scene change becomes one transition request after the world commit";
    Host9a h;
    SessionA9aHost sh;
    SessionA9aBinding *b;
    Body9a body = plain9a();
    uint8_t raw[27];
    SceneActionInfo info;
    SceneActionRuntimeState before = {0u, 2u};
    SceneActionHandlerResult r;

    host9a_session_init(&h, &sh);
    b = session_a9a_create(&sh);
    body.sound = 0x15;
    body.scene = 6301;
    body.w4 = 21;
    body.w6 = -22;
    body.w8 = 23;
    body.d10 = 0x80000001u;
    body.d14 = 0x7654u;
    body.d18 = 0xfffffff0u;
    body.flag_index = 4;
    body.flag_value = 0x90u;
    body.start_word = 3;
    info_for(&info, SESSION_A9A_TYPE, raw, body9a(raw, &body, 0u));
    CHECK(name, session_a9a_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_OK);
    CHECK(name, r.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED && r.phase == 2u);
    CHECK(name, h.transition_calls == 1 && h.stop_calls == 13 && h.store_flag_calls == 1 && h.stored_value == 0x90u);
    CHECK(name, h.request.target_scene == 6301 && h.request.opaque_words[0] == 21 && h.request.opaque_words[1] == -22 &&
                    h.request.opaque_words[2] == 23);
    CHECK(name, h.request.opaque_dwords[0] == (int32_t)0x80000001u && h.request.opaque_dwords[1] == 0x7654 &&
                    h.request.opaque_dwords[2] == (int32_t)0xfffffff0u);
    CHECK(name, h.stored.start_flag_5bb1ca == 1 && h.stored.engine_mode_583999 == 4 && h.stored.scene_5bb57b == 6301);
    /* ordered: invalid query, 13 stops, event flag store, world commit, transition */
    CHECK(name, h.n == 17 && h.events[0] == EV_INVALID && h.events[1] == EV_STOP + 1 && h.events[13] == EV_STOP + 13);
    CHECK(name, h.events[14] == EV_FLAG && h.events[15] == EV_STORE_WORLD && h.events[16] == EV_TRANSITION);

    body.scene = -5;                                                          /* signed target */
    body9a(raw, &body, 0u);
    CHECK(name, session_a9a_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_OK);
    CHECK(name, h.request.target_scene == -5 && h.transition_calls == 2);
    session_a9a_destroy(b);
    PASS(name);
}

static void test_9a_binding_refusals(void)
{
    const char *name = "9a binding - refusals happen before any effect or report the host failure";
    Host9a h;
    SessionA9aHost sh;
    SessionA9aBinding *b;
    Body9a body = plain9a();
    uint8_t raw[27];
    SceneActionInfo info;
    SceneActionRuntimeState before = {0u, 2u};
    SceneActionHandlerResult r;

    body.scene = 77;
    body.flag_index = 3;
    body.flag_value = 1;
    host9a_session_init(&h, &sh);
    b = session_a9a_create(&sh);
    info_for(&info, SESSION_A9A_TYPE, raw, body9a(raw, &body, 0u));

    h.load_result = 1;
    CHECK(name, session_a9a_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    CHECK(name, h.stop_calls == 0 && h.store_calls == 0 && h.transition_calls == 0 && session_a9a_visits(b) == 0ul);
    h.load_result = 0;

    h.invalid_result = 1;                                                     /* native refusal: ERROR, before any stop */
    CHECK(name, session_a9a_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(name, h.stop_calls == 0 && h.store_calls == 0 && h.transition_calls == 0 && session_a9a_visits(b) == 0ul);
    CHECK(name, strstr(session_a9a_failure(b), "outside the window") != NULL);
    h.invalid_result = 0;

    h.stop_fail_at = 5;
    h.stop_calls = 0;
    CHECK(name, session_a9a_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(name, h.store_calls == 0 && h.transition_calls == 0 && session_a9a_visits(b) == 0ul);
    h.stop_fail_at = -1;

    h.store_flag_result = 1;
    CHECK(name, session_a9a_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(name, h.store_calls == 0 && h.transition_calls == 0 && session_a9a_visits(b) == 0ul);
    h.store_flag_result = 0;

    h.transition_result = 1;                                                  /* the kernel already ran: ERROR, not counted */
    CHECK(name, session_a9a_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(name, h.transition_calls == 1 && session_a9a_visits(b) == 0ul);
    CHECK(name, strstr(session_a9a_failure(b), "refused") != NULL);
    h.transition_result = 0;

    info.raw_body_length = 26u;                                               /* short body */
    CHECK(name, session_a9a_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_ERROR);
    info.raw_body_length = 27u;
    info.type = SESSION_A6D_TYPE;
    CHECK(name, session_a9a_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_ERROR);
    info.type = SESSION_A9A_TYPE;
    CHECK(name, session_a9a_handler(NULL, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(name, session_a9a_handler(b, 0u, NULL, &before, &r) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(name, session_a9a_handler(b, 0u, &info, NULL, &r) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(name, session_a9a_handler(b, 0u, &info, &before, NULL) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(name, session_a9a_visits(b) == 0ul);
    body.scene = ACTION_FAMILY_9A_SCENE_NONE;                                 /* a later success clears the failure text */
    info.raw_body_length = 27u;
    body9a(raw, &body, 0u);
    CHECK(name, session_a9a_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_OK);
    CHECK(name, strcmp(session_a9a_failure(b), "none") == 0 && session_a9a_visits(b) == 1ul);
    session_a9a_destroy(b);
    PASS(name);
}

static void test_9a_binding_hosts(void)
{
    const char *name = "9a binding - missing required hosts are UNSUPPORTED, optional ones are not";
    Host9a h;
    SessionA9aHost sh;
    SessionA9aBinding *b;
    Body9a body = plain9a();
    uint8_t raw[27];
    SceneActionInfo info;
    SceneActionRuntimeState before = {0u, 2u};
    SceneActionHandlerResult r;

    host9a_session_init(&h, &sh);
    sh.stop_channel = NULL;
    b = session_a9a_create(&sh);
    info_for(&info, SESSION_A9A_TYPE, raw, body9a(raw, &body, 0u));
    CHECK(name, session_a9a_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    session_a9a_destroy(b);
    host9a_session_init(&h, &sh);
    sh.event_flag_invalid = NULL;
    b = session_a9a_create(&sh);
    CHECK(name, session_a9a_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    session_a9a_destroy(b);
    host9a_session_init(&h, &sh);
    sh.store_event_flag = NULL;
    b = session_a9a_create(&sh);
    CHECK(name, session_a9a_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    CHECK(name, h.stop_calls == 0);
    session_a9a_destroy(b);

    /* a row with a scene needs the transition host before any effect; a row without one does not */
    host9a_session_init(&h, &sh);
    sh.transition = NULL;
    b = session_a9a_create(&sh);
    body.scene = 30;
    body9a(raw, &body, 0u);
    CHECK(name, session_a9a_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    CHECK(name, h.stop_calls == 0 && h.load_calls == 0 && h.store_calls == 0);
    body.scene = ACTION_FAMILY_9A_SCENE_NONE;
    body9a(raw, &body, 0u);
    CHECK(name, session_a9a_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_OK);
    CHECK(name, h.stop_calls == 1 && r.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED);
    session_a9a_destroy(b);

    /* no world provider and no commit: zero cells, still completes */
    host9a_session_init(&h, &sh);
    sh.load_world = NULL;
    sh.store_world = NULL;
    b = session_a9a_create(&sh);
    body.scene = 30;
    body.start_word = 1;
    body9a(raw, &body, 0u);
    CHECK(name, session_a9a_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_OK);
    CHECK(name, h.transition_calls == 1 && h.request.target_scene == 30 && session_a9a_last_world(b)->engine_mode_583999 == 4);
    CHECK(name, session_a9a_last_world(b)->dword_5bb5a3 == 0 && session_a9a_last_world(b)->start_flag_5bb1ca == 0);
    CHECK(name, session_a9a_last_world(b)->scene_5bb57b == 30 && session_a9a_last_world(b)->word_5bb599 == 0);
    session_a9a_destroy(b);
    PASS(name);
}

int main(void)
{
    test_6d_select();
    test_6d_kernel_no_teardown();
    test_6d_kernel_teardowns();
    test_6d_kernel_failures();
    test_6d_binding();
    test_6d_binding_teardown_host();
    test_6d_binding_refusals();
    test_9a_phases();
    test_9a_sound_stops();
    test_9a_no_scene();
    test_9a_scene_cells();
    test_9a_start_word();
    test_9a_event_flag();
    test_9a_failures();
    test_9a_binding_phases();
    test_9a_binding_transition();
    test_9a_binding_refusals();
    test_9a_binding_hosts();
    return failures == 0 ? 0 : 1;
}
