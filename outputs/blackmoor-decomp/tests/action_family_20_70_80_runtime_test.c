/* RT-48 unit cases for raw 0x20, 0x70 and 0x80: the kernels (src/action_family_{20,70,80}_runtime.c) and the bindings
 * (src/session_bindings_a20_a70_a80.c). Bodies are written here; prints "PASS name" / "FAIL name: reason" per case. */
#include <stdio.h>
#include <string.h>

#include "session_bindings_a20_a70_a80.h"

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
static void put32(uint8_t *p, uint32_t v)
{
    p[0] = (uint8_t)v;
    p[1] = (uint8_t)(v >> 8);
    p[2] = (uint8_t)(v >> 16);
    p[3] = (uint8_t)(v >> 24);
}

static size_t body20(uint8_t *out, uint32_t d0, uint32_t d4, size_t tail)
{
    memset(out, 0, 8u + 16u * tail);
    put32(out, d0);
    put32(out + 4, d4);
    return 8u + 16u * tail;
}

static size_t body70(uint8_t *out, uint8_t b, size_t tail)
{
    memset(out, 0, 1u + 16u * tail);
    out[0] = b;
    return 1u + 16u * tail;
}

static size_t body80(uint8_t *out, uint16_t w, size_t tail)
{
    memset(out, 0, 2u + 16u * tail);
    out[0] = (uint8_t)w;
    out[1] = (uint8_t)(w >> 8);
    return 2u + 16u * tail;
}

static void info_for(SceneActionInfo *info, uint8_t type, const uint8_t *raw, size_t len)
{
    memset(info, 0, sizeof *info);
    info->type = type;
    info->subtype = 1u;
    info->raw_body = raw;
    info->raw_body_length = len;
}

/* ---- raw 0x20 ----------------------------------------------------------------------------------------------------------- */
typedef struct {
    int erase_calls;
    int erase_result;
    uint32_t erase_count;
    Action20World seen_at_erase;
    const Action20World *live;
    int load_calls, load_result, store_calls;
    Action20World stored;
    Action20World load_value;
} Host20;

static int h20_erase(void *c, uint32_t *n)
{
    Host20 *h = (Host20 *)c;
    ++h->erase_calls;
    if (h->live != NULL) h->seen_at_erase = *h->live;
    *n = h->erase_count;
    return h->erase_result;
}

static int h20_load(void *c, Action20World *w)
{
    Host20 *h = (Host20 *)c;
    ++h->load_calls;
    *w = h->load_value;
    return h->load_result;
}

static void h20_store(void *c, const Action20World *w)
{
    Host20 *h = (Host20 *)c;
    ++h->store_calls;
    h->stored = *w;
}

static void test_20_kernel_cells(void)
{
    const char *name = "20 kernel stores the view cells, erases once and aliases the scene cells";
    ActionFamily20Decoded d;
    Action20World w;
    Action20Outcome out;
    Host20 h;
    Action20Host kh;
    uint8_t raw[8];

    memset(&h, 0, sizeof h);
    h.erase_count = 7u;
    kh.context = &h;
    kh.erase_rows = h20_erase;
    body20(raw, 4u, 1u, 0u);
    CHECK(name, action_family_20_decode(raw, 8u, &d) == ACTION_FAMILY_20_OK);
    memset(&w, 0, sizeof w);
    w.view_cell_63aa10 = 77;
    w.view_cell_55cd94 = 88;
    w.scene_5bb57b = 111;
    w.scene_5bb57f = -2;
    w.word_5c3a4f = 5;
    CHECK(name, action_family_20_runtime_visit(&d, &w, &kh, &out) == ACTION_FAMILY_20_RUNTIME_OK);
    CHECK(name, w.view_cell_63aa10 == 4 && w.view_cell_55cd94 == 1);          /* dword 0 -> 0x63aa10, dword 4 -> 0x55cd94 */
    CHECK(name, w.scene_5bb57b == -2 && w.scene_5bb57f == -2);
    CHECK(name, w.word_5c3a4f == -2);
    CHECK(name, h.erase_calls == 1 && out.rows_erased == 7u);
    PASS(name);
}

static void test_20_kernel_dwords_are_whole(void)
{
    const char *name = "20 kernel keeps both body dwords whole (no narrowing)";
    ActionFamily20Decoded d;
    Action20World w;
    Action20Outcome out;
    Host20 h;
    Action20Host kh;
    uint8_t raw[8];

    memset(&h, 0, sizeof h);
    kh.context = &h;
    kh.erase_rows = h20_erase;
    body20(raw, 0x80000001u, 0xfffffffeu, 0u);
    CHECK(name, action_family_20_decode(raw, 8u, &d) == ACTION_FAMILY_20_OK);
    memset(&w, 0, sizeof w);
    CHECK(name, action_family_20_runtime_visit(&d, &w, &kh, &out) == ACTION_FAMILY_20_RUNTIME_OK);
    CHECK(name, w.view_cell_63aa10 == (int32_t)0x80000001u && w.view_cell_55cd94 == -2);
    PASS(name);
}

static void test_20_kernel_host_failure_changes_nothing(void)
{
    const char *name = "20 kernel host failure changes nothing";
    ActionFamily20Decoded d;
    Action20World w, before;
    Action20Outcome out;
    Host20 h;
    Action20Host kh;
    uint8_t raw[8];

    memset(&h, 0, sizeof h);
    h.erase_result = 1;
    kh.context = &h;
    kh.erase_rows = h20_erase;
    body20(raw, 3u, 1u, 0u);
    action_family_20_decode(raw, 8u, &d);
    memset(&w, 0, sizeof w);
    w.scene_5bb57b = 9;
    w.scene_5bb57f = 10;
    before = w;
    memset(&out, 0x5a, sizeof out);
    CHECK(name, action_family_20_runtime_visit(&d, &w, &kh, &out) == ACTION_FAMILY_20_RUNTIME_ERR_HOST);
    CHECK(name, memcmp(&w, &before, sizeof w) == 0);
    CHECK(name, action_family_20_runtime_visit(NULL, &w, &kh, &out) == ACTION_FAMILY_20_RUNTIME_ERR_ARGUMENT);
    CHECK(name, action_family_20_runtime_visit(&d, NULL, &kh, &out) == ACTION_FAMILY_20_RUNTIME_ERR_ARGUMENT);
    CHECK(name, action_family_20_runtime_visit(&d, &w, NULL, &out) == ACTION_FAMILY_20_RUNTIME_ERR_ARGUMENT);
    CHECK(name, action_family_20_runtime_visit(&d, &w, &kh, NULL) == ACTION_FAMILY_20_RUNTIME_ERR_ARGUMENT);
    PASS(name);
}

static void test_20_binding(void)
{
    const char *name = "20 binding - direct completion with phase 0, cells committed";
    Host20 h;
    SessionA20Host sh;
    SessionA20Binding *b;
    uint8_t raw[8 + 16];
    SceneActionInfo info;
    SceneActionRuntimeState before = {0u, 5u};
    SceneActionHandlerResult r;

    memset(&h, 0, sizeof h);
    h.erase_count = 3u;
    h.load_value.scene_5bb57f = 2877;
    sh.context = &h;
    sh.load_world = h20_load;
    sh.store_world = h20_store;
    sh.erase_rows = h20_erase;
    b = session_a20_create(&sh);
    CHECK(name, b != NULL);
    info_for(&info, SESSION_A20_TYPE, raw, body20(raw, 3u, 1u, 1u));
    r.disposition = SCENE_ACTION_HANDLER_PENDING;
    r.phase = 9u;
    CHECK(name, session_a20_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_OK);
    CHECK(name, r.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED && r.phase == 0u);
    CHECK(name, h.erase_calls == 1 && h.store_calls == 1 && session_a20_visits(b) == 1ul);
    CHECK(name, h.stored.view_cell_63aa10 == 3 && h.stored.view_cell_55cd94 == 1 && h.stored.scene_5bb57b == 2877);
    CHECK(name, session_a20_last_outcome(b)->rows_erased == 3u);
    session_a20_destroy(b);
    PASS(name);
}

static void test_20_binding_refusals(void)
{
    const char *name = "20 binding - refusals and bad input have no effect";
    Host20 h;
    SessionA20Host sh;
    SessionA20Binding *b;
    uint8_t raw[8];
    SceneActionInfo info;
    SceneActionRuntimeState before = {0u, 0u};
    SceneActionHandlerResult r;

    memset(&h, 0, sizeof h);
    sh.context = &h;
    sh.load_world = h20_load;
    sh.store_world = h20_store;
    sh.erase_rows = h20_erase;
    b = session_a20_create(&sh);
    info_for(&info, SESSION_A20_TYPE, raw, body20(raw, 4u, 1u, 0u));
    h.load_result = 1;
    CHECK(name, session_a20_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    CHECK(name, h.erase_calls == 0 && h.store_calls == 0 && session_a20_visits(b) == 0ul);
    h.load_result = 0;
    h.erase_result = 1;
    CHECK(name, session_a20_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(name, h.store_calls == 0 && session_a20_visits(b) == 0ul);
    h.erase_result = 0;
    info.raw_body_length = 7u;                                                /* short body */
    CHECK(name, session_a20_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_ERROR);
    info.raw_body_length = 8u;
    info.type = SESSION_A70_TYPE;                                             /* wrong type */
    CHECK(name, session_a20_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(name, h.erase_calls == 1);
    session_a20_destroy(b);
    sh.erase_rows = NULL;
    b = session_a20_create(&sh);
    info.type = SESSION_A20_TYPE;
    CHECK(name, session_a20_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    session_a20_destroy(b);
    PASS(name);
}

/* ---- raw 0x70 ----------------------------------------------------------------------------------------------------------- */
typedef struct {
    int unload_calls, unload_result;
    Action70World seen_at_unload;
    const Action70World *live;
    int load_calls, load_result, store_calls;
    Action70World stored, load_value;
} Host70;

static int h70_unload(void *c)
{
    Host70 *h = (Host70 *)c;
    ++h->unload_calls;
    if (h->live != NULL) h->seen_at_unload = *h->live;
    return h->unload_result;
}

static int h70_load(void *c, Action70World *w)
{
    Host70 *h = (Host70 *)c;
    ++h->load_calls;
    *w = h->load_value;
    return h->load_result;
}

static void h70_store(void *c, const Action70World *w)
{
    Host70 *h = (Host70 *)c;
    ++h->store_calls;
    h->stored = *w;
}

static void test_70_kernel(void)
{
    const char *name = "70 kernel unloads the sound first, then stores the six cells";
    ActionFamily70Decoded d;
    Action70World w;
    Host70 h;
    Action70Host kh;
    uint8_t raw[1];

    memset(&h, 0, sizeof h);
    kh.context = &h;
    kh.unload_scene_sound = h70_unload;
    h.live = &w;
    body70(raw, 0x77u, 0u);
    CHECK(name, action_family_70_decode(raw, 1u, &d) == ACTION_FAMILY_70_OK);
    memset(&w, 0x11, sizeof w);
    CHECK(name, action_family_70_runtime_visit(&d, &w, &kh) == ACTION_FAMILY_70_RUNTIME_OK);
    CHECK(name, h.unload_calls == 1 && h.seen_at_unload.outer_state_583981 == 0x11111111);     /* nothing written yet */
    CHECK(name, w.outer_state_583981 == 5 && w.next_state_583985 == 6 && w.cell_583991 == 0);
    CHECK(name, w.first_render_5bb1c4 == 1 && w.engine_mode_583999 == 0 && w.cell_5bb1e2 == 0);
    PASS(name);
}

static void test_70_kernel_failure(void)
{
    const char *name = "70 kernel host failure and null arguments change nothing";
    ActionFamily70Decoded d;
    Action70World w, before;
    Host70 h;
    Action70Host kh;
    uint8_t raw[1];

    memset(&h, 0, sizeof h);
    h.unload_result = 1;
    kh.context = &h;
    kh.unload_scene_sound = h70_unload;
    body70(raw, 0u, 0u);
    action_family_70_decode(raw, 1u, &d);
    memset(&w, 0x22, sizeof w);
    before = w;
    CHECK(name, action_family_70_runtime_visit(&d, &w, &kh) == ACTION_FAMILY_70_RUNTIME_ERR_HOST);
    CHECK(name, memcmp(&w, &before, sizeof w) == 0);
    CHECK(name, action_family_70_runtime_visit(NULL, &w, &kh) == ACTION_FAMILY_70_RUNTIME_ERR_ARGUMENT);
    CHECK(name, action_family_70_runtime_visit(&d, NULL, &kh) == ACTION_FAMILY_70_RUNTIME_ERR_ARGUMENT);
    CHECK(name, action_family_70_runtime_visit(&d, &w, NULL) == ACTION_FAMILY_70_RUNTIME_ERR_ARGUMENT);
    PASS(name);
}

static void test_70_binding(void)
{
    const char *name = "70 binding - direct completion keeps the phase, cells committed";
    Host70 h;
    SessionA70Host sh;
    SessionA70Binding *b;
    uint8_t raw[1 + 16];
    SceneActionInfo info;
    SceneActionRuntimeState before = {0u, 5u};
    SceneActionHandlerResult r;

    memset(&h, 0, sizeof h);
    sh.context = &h;
    sh.load_world = h70_load;
    sh.store_world = h70_store;
    sh.unload_scene_sound = h70_unload;
    b = session_a70_create(&sh);
    info_for(&info, SESSION_A70_TYPE, raw, body70(raw, 0u, 1u));
    r.disposition = SCENE_ACTION_HANDLER_PENDING;
    r.phase = 9u;
    CHECK(name, session_a70_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_OK);
    CHECK(name, r.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED && r.phase == 5u);
    CHECK(name, h.unload_calls == 1 && h.store_calls == 1 && session_a70_visits(b) == 1ul);
    CHECK(name, h.stored.outer_state_583981 == 5 && h.stored.next_state_583985 == 6);
    h.load_result = 1;                                                        /* a refusing world provider */
    CHECK(name, session_a70_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    CHECK(name, h.unload_calls == 1 && session_a70_visits(b) == 1ul);
    h.load_result = 0;
    h.unload_result = 1;
    CHECK(name, session_a70_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(name, h.store_calls == 1);
    info.raw_body_length = 0u;                                                /* empty body: the decoder refuses */
    h.unload_result = 0;
    CHECK(name, session_a70_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_ERROR);
    session_a70_destroy(b);
    sh.unload_scene_sound = NULL;
    b = session_a70_create(&sh);
    info.raw_body_length = 1u;
    CHECK(name, session_a70_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    session_a70_destroy(b);
    PASS(name);
}

/* ---- raw 0x80 ----------------------------------------------------------------------------------------------------------- */
static Action80Object tuple_object(void)
{
    Action80Object o;
    memset(&o, 0, sizeof o);
    o.scene_6ba = 4321;
    o.word_6bc = 11;
    o.word_6be = -12;
    o.dword_6c2 = 1300;
    o.dword_6c6 = -1400;
    o.dword_6ca = 15;
    o.word_6b2 = 77;
    o.dword_6b4 = 88;
    o.dword_4530 = 99;
    o.dword_65d2 = 0;
    return o;
}

static void test_80_literal_scene(void)
{
    const char *name = "80 kernel - a literal scene word wins the scene cells, the tuple still comes from the object";
    ActionFamily80Decoded d;
    Action80Object o = tuple_object();
    Action80World w;
    uint8_t raw[2];

    body80(raw, 0x189du, 0u);
    CHECK(name, action_family_80_decode(raw, 2u, &d) == ACTION_FAMILY_80_OK);
    memset(&w, 0x33, sizeof w);
    CHECK(name, action_family_80_runtime_visit(&d, &o, &w) == ACTION_FAMILY_80_RUNTIME_OK);
    CHECK(name, w.scene_5bb57b == 6301 && w.scene_5bb57f == 6301);
    CHECK(name, w.word_5bb599 == 11 && w.word_5bb595 == -12 && w.dword_5bb59b == 1300 && w.dword_5bb59f == -1400);
    CHECK(name, w.dword_5bb5a3 == 15 && w.word_5c39ff == 1 && w.engine_mode_583999 == 4);
    CHECK(name, w.cell_583204 == 0x33333333 && w.cell_5bb22a == 0x33333333);   /* state 0: untouched */
    PASS(name);
}

static void test_80_signed_word(void)
{
    const char *name = "80 kernel - the body word is signed and only 9999 selects the stored scene";
    ActionFamily80Decoded d;
    Action80Object o = tuple_object();
    Action80World w;
    uint8_t raw[2];

    body80(raw, 0xd8f0u, 0u);                                                 /* -10000 */
    action_family_80_decode(raw, 2u, &d);
    memset(&w, 0, sizeof w);
    CHECK(name, action_family_80_runtime_visit(&d, &o, &w) == ACTION_FAMILY_80_RUNTIME_OK);
    CHECK(name, w.scene_5bb57b == -10000 && w.scene_5bb57f == -10000);
    body80(raw, 0x270eu, 0u);
    action_family_80_decode(raw, 2u, &d);
    CHECK(name, action_family_80_runtime_visit(&d, &o, &w) == ACTION_FAMILY_80_RUNTIME_OK && w.scene_5bb57b == 0x270e);
    body80(raw, 0x2710u, 0u);
    action_family_80_decode(raw, 2u, &d);
    CHECK(name, action_family_80_runtime_visit(&d, &o, &w) == ACTION_FAMILY_80_RUNTIME_OK && w.scene_5bb57b == 0x2710);
    PASS(name);
}

static void test_80_stored_scene(void)
{
    const char *name = "80 kernel - 9999 takes the object's signed scene word for both scene cells";
    ActionFamily80Decoded d;
    Action80Object o = tuple_object();
    Action80World w;
    uint8_t raw[2];

    body80(raw, 0x270fu, 0u);
    action_family_80_decode(raw, 2u, &d);
    memset(&w, 0, sizeof w);
    CHECK(name, action_family_80_runtime_visit(&d, &o, &w) == ACTION_FAMILY_80_RUNTIME_OK);
    CHECK(name, w.scene_5bb57b == 4321 && w.scene_5bb57f == 4321 && w.engine_mode_583999 == 4);
    o.scene_6ba = -5;
    CHECK(name, action_family_80_runtime_visit(&d, &o, &w) == ACTION_FAMILY_80_RUNTIME_OK);
    CHECK(name, w.scene_5bb57b == -5 && w.scene_5bb57f == -5);
    PASS(name);
}

static void test_80_object_states(void)
{
    const char *name = "80 kernel - object states 2 and 3 reset the overlay, others leave it";
    ActionFamily80Decoded d;
    Action80Object o, saved;
    Action80World w;
    uint8_t raw[2];
    int32_t state;

    body80(raw, 0x270fu, 0u);
    action_family_80_decode(raw, 2u, &d);
    for (state = 0; state <= 5; ++state) {
        o = tuple_object();
        o.state_4528 = state;
        saved = o;
        memset(&w, 0x44, sizeof w);
        CHECK(name, action_family_80_runtime_visit(&d, &o, &w) == ACTION_FAMILY_80_RUNTIME_OK);
        if (state == 2 || state == 3) {
            CHECK(name, w.cell_583204 == 5 && w.cell_5bb22a == 0);
            CHECK(name, o.dword_4530 == 0 && o.word_6b2 == 0x270f && o.dword_65d2 == 1 && o.dword_6b4 == 0);
        } else {
            CHECK(name, w.cell_583204 == 0x44444444 && w.cell_5bb22a == 0x44444444);
            CHECK(name, memcmp(&o, &saved, sizeof o) == 0);
        }
    }
    PASS(name);
}

static void test_80_object_branches(void)
{
    const char *name = "80 kernel - word +0x6b2 of 9999 and a zero dword +0x6b4 skip their stores";
    ActionFamily80Decoded d;
    Action80Object o;
    Action80World w;
    uint8_t raw[2];

    body80(raw, 0x270fu, 0u);
    action_family_80_decode(raw, 2u, &d);
    o = tuple_object();
    o.state_4528 = 2;
    o.word_6b2 = 0x270f;                                                      /* already cleared: +0x6b4 and +0x65d2 stay */
    memset(&w, 0, sizeof w);
    action_family_80_runtime_visit(&d, &o, &w);
    CHECK(name, o.dword_4530 == 0 && o.dword_6b4 == 88 && o.dword_65d2 == 0 && w.cell_583204 == 5);
    o = tuple_object();
    o.state_4528 = 3;
    o.dword_6b4 = 0;                                                          /* nothing to clear: +0x65d2 stays */
    action_family_80_runtime_visit(&d, &o, &w);
    CHECK(name, o.word_6b2 == 0x270f && o.dword_65d2 == 0 && o.dword_6b4 == 0);
    o = tuple_object();
    o.state_4528 = 2;
    o.word_6b2 = (int16_t)0x270f;
    CHECK(name, action_family_80_runtime_visit(NULL, &o, &w) == ACTION_FAMILY_80_RUNTIME_ERR_ARGUMENT);
    CHECK(name, action_family_80_runtime_visit(&d, NULL, &w) == ACTION_FAMILY_80_RUNTIME_ERR_ARGUMENT);
    CHECK(name, action_family_80_runtime_visit(&d, &o, NULL) == ACTION_FAMILY_80_RUNTIME_ERR_ARGUMENT);
    PASS(name);
}

typedef struct {
    Action80Object object;
    int load_object_calls, last_uses_stored, load_object_result;
    int transition_calls, transition_result;
    SceneTransitionRequest request;
    int store_object_calls, store_world_calls;
    Action80Object stored_object;
    Action80World stored_world, load_world_value;
    int load_world_result;
} Host80;

static int h80_load_object(void *c, int uses, Action80Object *o)
{
    Host80 *h = (Host80 *)c;
    ++h->load_object_calls;
    h->last_uses_stored = uses;
    *o = h->object;
    return h->load_object_result;
}

static int h80_load_world(void *c, Action80World *w)
{
    Host80 *h = (Host80 *)c;
    *w = h->load_world_value;
    return h->load_world_result;
}

static void h80_store_object(void *c, const Action80Object *o)
{
    Host80 *h = (Host80 *)c;
    ++h->store_object_calls;
    h->stored_object = *o;
}

static void h80_store_world(void *c, const Action80World *w)
{
    Host80 *h = (Host80 *)c;
    ++h->store_world_calls;
    h->stored_world = *w;
}

static int h80_transition(void *c, const SceneTransitionRequest *r)
{
    Host80 *h = (Host80 *)c;
    ++h->transition_calls;
    h->request = *r;
    return h->transition_result;
}

static void host80_init(Host80 *h, SessionA80Host *sh)
{
    memset(h, 0, sizeof *h);
    h->object = tuple_object();
    sh->context = h;
    sh->load_object = h80_load_object;
    sh->load_world = h80_load_world;
    sh->store_object = h80_store_object;
    sh->store_world = h80_store_world;
    sh->transition = h80_transition;
}

static void test_80_binding(void)
{
    const char *name = "80 binding - scene-change request from the cells, direct completion keeps the phase";
    Host80 h;
    SessionA80Host sh;
    SessionA80Binding *b;
    uint8_t raw[2 + 16];
    SceneActionInfo info;
    SceneActionRuntimeState before = {0u, 5u};
    SceneActionHandlerResult r;

    host80_init(&h, &sh);
    h.object.state_4528 = 2;
    b = session_a80_create(&sh);
    info_for(&info, SESSION_A80_TYPE, raw, body80(raw, 0x270fu, 1u));
    r.disposition = SCENE_ACTION_HANDLER_PENDING;
    r.phase = 9u;
    CHECK(name, session_a80_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_OK);
    CHECK(name, r.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED && r.phase == 5u);
    CHECK(name, h.last_uses_stored == 1 && h.transition_calls == 1 && h.store_object_calls == 1 && h.store_world_calls == 1);
    CHECK(name, h.request.target_scene == 4321 && h.request.opaque_words[0] == 11 && h.request.opaque_words[1] == -12);
    CHECK(name, h.request.opaque_words[2] == 1 && h.request.opaque_dwords[0] == 1300 && h.request.opaque_dwords[1] == -1400);
    CHECK(name, h.request.opaque_dwords[2] == 15);
    CHECK(name, h.stored_object.word_6b2 == 0x270f && h.stored_world.cell_583204 == 5 && h.stored_world.engine_mode_583999 == 4);
    CHECK(name, session_a80_visits(b) == 1ul && session_a80_last_world(b)->scene_5bb57b == 4321);
    info_for(&info, SESSION_A80_TYPE, raw, body80(raw, 6301u, 0u));
    CHECK(name, session_a80_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_OK);
    CHECK(name, h.last_uses_stored == 0 && h.request.target_scene == 6301);
    session_a80_destroy(b);
    PASS(name);
}

static void test_80_binding_refusals(void)
{
    const char *name = "80 binding - refusals commit nothing";
    Host80 h;
    SessionA80Host sh;
    SessionA80Binding *b;
    uint8_t raw[2];
    SceneActionInfo info;
    SceneActionRuntimeState before = {0u, 0u};
    SceneActionHandlerResult r;

    host80_init(&h, &sh);
    b = session_a80_create(&sh);
    info_for(&info, SESSION_A80_TYPE, raw, body80(raw, 0x270fu, 0u));
    h.load_object_result = 1;                                                 /* no stored return tuple in the app */
    CHECK(name, session_a80_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    CHECK(name, h.transition_calls == 0 && h.store_object_calls == 0 && h.store_world_calls == 0);
    h.load_object_result = 0;
    h.load_world_result = 1;
    CHECK(name, session_a80_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    CHECK(name, h.transition_calls == 0);
    h.load_world_result = 0;
    h.transition_result = 1;
    CHECK(name, session_a80_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(name, h.store_object_calls == 0 && h.store_world_calls == 0 && session_a80_visits(b) == 0ul);
    h.transition_result = 0;
    info.raw_body_length = 1u;                                                /* short body */
    CHECK(name, session_a80_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_ERROR);
    info.raw_body_length = 2u;
    info.type = SESSION_A20_TYPE;
    CHECK(name, session_a80_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_ERROR);
    session_a80_destroy(b);
    sh.transition = NULL;
    b = session_a80_create(&sh);
    info.type = SESSION_A80_TYPE;
    CHECK(name, session_a80_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    session_a80_destroy(b);
    PASS(name);
}

int main(void)
{
    test_20_kernel_cells();
    test_20_kernel_dwords_are_whole();
    test_20_kernel_host_failure_changes_nothing();
    test_20_binding();
    test_20_binding_refusals();
    test_70_kernel();
    test_70_kernel_failure();
    test_70_binding();
    test_80_literal_scene();
    test_80_signed_word();
    test_80_stored_scene();
    test_80_object_states();
    test_80_object_branches();
    test_80_binding();
    test_80_binding_refusals();
    return failures == 0 ? 0 : 1;
}
