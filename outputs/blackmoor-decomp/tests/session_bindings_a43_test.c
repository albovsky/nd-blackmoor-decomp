/* RT-32 integration check of the raw 0x43 binding with the production scene executor and the 0x36 overlay binding.
 * A synthetic scene of keyed and inline 0x43 rows runs through scene_executor_step_frame: the first visit renders (a
 * recorder replaces the text writer through the write_text seam) and converts the row, later visits are served by the
 * overlay binding, and the row's completion uses subtype 1 whatever the raw subtype was. Prints "PASS" or "FAIL line N". */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_executor.h"
#include "session_bindings_a36.h"
#include "session_bindings_a43.h"

#define EXPECT(cond)                                           \
    do {                                                       \
        if (!(cond)) {                                         \
            printf("FAIL line %d: %s\n", __LINE__, #cond);     \
            return 1;                                          \
        }                                                      \
    } while (0)

static int32_t g_events[16];
static int g_modes[16], g_mode_count;

/* Extension opcode 20 leaf: records the evaluation mode the executor gates the row with (0x423f57 stores it). */
static int leaf(void *c, const SceneConditionLeafRequest *request, int32_t *status, int *provider)
{
    (void)c; (void)provider;
    if (g_mode_count < 16) g_modes[g_mode_count++] = request->evaluation_mode;
    *status = 1;
    return SCENE_CONDITION_OK;
}
static void pass_started(void *c) { (void)c; }
static unsigned g_writes, g_blits, g_fail_write;
static char g_last_text[64];

static int lookup(void *c, const uint8_t *key, size_t n, const uint8_t **text, size_t *len)
{
    (void)c;
    if (n == 5u && memcmp(key, "HELLO", 5) == 0) {
        *text = (const uint8_t *)"Hello caption";
        *len = 13u;
        return 0;
    }
    return 1;
}
static int write_text(void *c, uint8_t *entry, const char *text, size_t cap)
{
    (void)c; (void)entry; (void)cap;
    if (g_fail_write) return 1;
    ++g_writes;
    snprintf(g_last_text, sizeof g_last_text, "%s", text);
    return 0;
}
static int load_world(void *c, Overlay36World *w)
{
    (void)c;
    w->events = g_events;
    w->event_count = 16;
    w->selector = 0;
    w->held_item = -1;
    w->autotext_surface[0] = w->autotext_surface[1] = w->autotext_surface[2] = 0x500u;
    return 0;
}
static void store_world(void *c, const Overlay36World *w) { (void)c; (void)w; }
static int transition(void *c, const SceneTransitionRequest *r) { (void)c; return r == NULL; }
static int load_surface(void *c, const char *name, uint32_t *s) { (void)c; (void)name; *s = 0x600u; return 0; }
static int tick_count(void *c, uint32_t *t) { (void)c; *t = 1000u; return 0; }
static int blit(void *c, const Overlay36Blit *op) { (void)c; (void)op; ++g_blits; return 0; }

static size_t put_chunk(uint8_t *out, size_t at, const char *id, const uint8_t *payload, size_t length)
{
    memcpy(out + at, id, 4);
    out[at + 4] = (uint8_t)(length >> 24); out[at + 5] = (uint8_t)(length >> 16);
    out[at + 6] = (uint8_t)(length >> 8); out[at + 7] = (uint8_t)length;
    memcpy(out + at + 8, payload, length);
    at += 8 + length;
    if (length & 1u) out[at++] = 0;
    return at;
}

static size_t put_act(uint8_t *out, size_t at, uint8_t subtype, const uint8_t *body, size_t length)
{
    uint8_t act[1024];
    memset(act, 0, sizeof act);
    memcpy(act, "row", 4);
    act[48] = 0x43;
    act[49] = subtype;
    memcpy(act + 50, body, length);
    return put_chunk(out, at, "ACT\0", act, 50u + length);
}

static void keyed_body(uint8_t *b, int16_t surface, const char *key)
{
    memset(b, 0, 301u);
    b[2] = (uint8_t)surface;
    b[0xe9] = 10; b[0xed] = 20; b[0xf1] = 110; b[0xf5] = 60; /* rectangle left top right bottom */
    b[0x109] = 1;
    memcpy(b + 0x10a, key, strlen(key));
}

int main(void)
{
    uint8_t bytes[8192], tsum[126], body[320];
    size_t at = 12u;
    SceneResource *scene;
    char err[128];
    ActionCoreWorld world;
    SceneConditionState state;
    SceneActionExecutor *ex = NULL;
    size_t failed;
    SessionA36Host a36_host;
    SessionA43Host a43_host;
    SessionA36Binding *a36;
    SessionA43Binding *a43;
    SceneActionHandler handler;
    SceneExecutorStepInfo info;
    SceneExecutorFrameInput frame;
    SceneActionRuntimeState st;
    size_t n;

    memset(bytes, 0, sizeof bytes);
    memset(tsum, 0, sizeof tsum);
    memcpy(tsum, "Test", 5);
    memcpy(tsum + 50, "background", 11);
    memcpy(tsum + 83, "sound", 6);
    memcpy(bytes + 8, "SCEN", 4);
    at = put_chunk(bytes, at, "TSUM", tsum, sizeof tsum);
    keyed_body(body, 0, "HELLO");
    at = put_act(bytes, at, 2u, body, 301u);  /* row 0: raw subtype 2 */
    keyed_body(body, 1, "HELLO");
    at = put_act(bytes, at, 0u, body, 301u);  /* row 1: raw subtype 0 */
    keyed_body(body, 2, "MISSING");
    at = put_act(bytes, at, 1u, body, 301u);  /* row 2: key not in AUTOTEXT */
    memcpy(bytes, "DATA", 4);
    n = at - 8u;
    bytes[4] = (uint8_t)(n >> 24); bytes[5] = (uint8_t)(n >> 16); bytes[6] = (uint8_t)(n >> 8); bytes[7] = (uint8_t)n;
    scene = scene_resource_open_memory(bytes, at, err, sizeof err);
    EXPECT(scene != NULL);

    memset(&world, 0, sizeof world);
    world.event_flags = g_events;
    world.event_flag_count = 16;
    memset(&state, 0, sizeof state);
    state.event_flags = g_events;
    state.event_flag_count = 16;
    memset(&a36_host, 0, sizeof a36_host);
    a36_host.kernel.load_surface = load_surface;
    a36_host.kernel.tick_count = tick_count;
    a36_host.kernel.blit = blit;
    a36_host.load_world = load_world;
    a36_host.store_world = store_world;
    a36_host.transition = transition;
    a36 = session_a36_create(&a36_host);
    EXPECT(a36 != NULL);
    memset(&a43_host, 0, sizeof a43_host);
    a43_host.lookup = lookup;
    a43_host.write_text = write_text;
    a43 = session_a43_create(&a43_host, a36);
    EXPECT(a43 != NULL);
    EXPECT(session_a36_begin_scene(a36, scene) == OVERLAY36_OK);
    EXPECT(session_a36_image(a36, 0u) == NULL);
    handler.type = SESSION_A43_TYPE;
    handler.callback = session_a43_handler;
    handler.context = a43;
    memset(&frame, 0, sizeof frame);
    EXPECT(scene_executor_create(scene, &world, 0u, &ex, &failed) == SCENE_EXECUTOR_OK);

    /* tick 1, writer refused: the executor stops on the first row, nothing converted */
    g_fail_write = 1;
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_ERR_UNSUPPORTED);
    EXPECT(session_a36_image(a36, 0u) == NULL && g_writes == 0u);
    EXPECT(scene_executor_get_action_state(ex, 0u, &st) == SCENE_EXECUTOR_OK && st.phase == 0u);
    { int ov = 1; EXPECT(scene_executor_get_action_overlay36(ex, 0u, &ov) == SCENE_EXECUTOR_OK && !ov); }
    g_fail_write = 0;

    /* tick 1 again: row 0 renders and converts (subtype 2: its dependencies reset), row 1 is not visited yet because
     * the executor stops at the first applied action of the pass only on transitions; both convert in one pass */
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_ERR_UNSUPPORTED);
    EXPECT(g_writes == 2u && strcmp(g_last_text, "Hello caption") == 0);
    EXPECT(session_a36_image(a36, 0u) != NULL && session_a36_image(a36, 1u) != NULL && session_a36_image(a36, 2u) == NULL);
    EXPECT(strcmp(session_a36_row_name(a36, 0u), "USE_AUTOTEXT1") == 0);
    EXPECT(strcmp(session_a36_row_name(a36, 1u), "USE_AUTOTEXT2") == 0);
    EXPECT(session_a36_row_raw_type(a36, 0u) == SESSION_A43_ROW_TYPE);
    EXPECT(scene_executor_get_action_state(ex, 0u, &st) == SCENE_EXECUTOR_OK && st.phase == 0u && st.completed == 0u);
    { int ov = 0; EXPECT(scene_executor_get_action_overlay36(ex, 0u, &ov) == SCENE_EXECUTOR_OK && ov); }
    { int ov = 1; EXPECT(scene_executor_get_action_overlay36(ex, 2u, &ov) == SCENE_EXECUTOR_OK && !ov); }
    EXPECT(strcmp(session_a43_failure(a43), "AUTOTEXT key not found (original fallback unverified)") == 0);

    /* The third row's missing key blocks the pass every tick; the converted rows are served by the overlay binding. */
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_ERR_UNSUPPORTED);
    EXPECT(session_a36_registered(a36) == 2u);
    EXPECT(g_writes == 2u);
    EXPECT(scene_executor_get_action_state(ex, 0u, &st) == SCENE_EXECUTOR_OK && st.phase != 0u && st.completed == 0u);

    /* phase 2 (a pointer activation) completes with the subtype 0x411f24 stored (1), not the raw one */
    EXPECT(scene_executor_accept_action_candidate(ex, 0u) == SCENE_EXECUTOR_OK);
    EXPECT(scene_executor_accept_action_candidate(ex, 1u) == SCENE_EXECUTOR_OK);
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_ERR_UNSUPPORTED);
    EXPECT(scene_executor_get_action_state(ex, 0u, &st) == SCENE_EXECUTOR_OK && st.completed == 1u && st.phase == 0u);
    EXPECT(scene_executor_get_action_state(ex, 1u, &st) == SCENE_EXECUTOR_OK && st.completed == 1u && st.phase == 0u);
    EXPECT(g_writes == 2u);

    scene_executor_destroy(ex);
    scene_resource_close(scene);

    /* A row with a dependency leaf that reads the evaluation mode: gated with mode 0 while it is a raw 0x43 row, and
     * with mode 1 (the 0x36 arm) on the visit after the handler converted it. */
    {
        uint8_t tail[16];
        SceneConditionExtension extension;
        memset(bytes, 0, sizeof bytes);
        memcpy(bytes + 8, "SCEN", 4);
        at = 12u;
        at = put_chunk(bytes, at, "TSUM", tsum, sizeof tsum);
        keyed_body(body, 0, "HELLO");
        memset(tail, 0, sizeof tail);
        tail[0] = 20; /* opcode 20: an extension leaf */
        memcpy(body + 301, tail, sizeof tail);
        at = put_act(bytes, at, 1u, body, 301u + sizeof tail);
        memcpy(bytes, "DATA", 4);
        n = at - 8u;
        bytes[4] = (uint8_t)(n >> 24); bytes[5] = (uint8_t)(n >> 16); bytes[6] = (uint8_t)(n >> 8); bytes[7] = (uint8_t)n;
        scene = scene_resource_open_memory(bytes, at, err, sizeof err);
        EXPECT(scene != NULL);
        EXPECT(session_a36_begin_scene(a36, scene) == OVERLAY36_OK);
        memset(&extension, 0, sizeof extension);
        extension.evaluate_leaf = leaf;
        extension.pass_started = pass_started;
        g_mode_count = 0;
        EXPECT(scene_executor_create(scene, &world, 0u, &ex, &failed) == SCENE_EXECUTOR_OK);
        EXPECT(scene_executor_set_condition_extension(ex, &extension) == SCENE_EXECUTOR_OK);
        EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK);
        EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK);
        EXPECT(g_mode_count == 2 && g_modes[0] == 0 && g_modes[1] == 1);
        scene_executor_destroy(ex);
        scene_resource_close(scene);
    }
    session_a43_destroy(a43);
    session_a36_destroy(a36);
    printf("PASS\n");
    return 0;
}
