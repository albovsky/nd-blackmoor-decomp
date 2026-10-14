/* ASan/UBSan fixture for the RT-6 pointer boundary: the real session_input
 * module behind the session's consume / scan / reset host over random and
 * hostile geometry, events, candidates, hotspot rectangles and scene
 * replacements. Bounded; the executor and session must keep every invariant
 * and never touch memory out of range. */
#include "../src/scene_executor.h"
#include "../src/scene_resource.h"
#include "../src/scene_session.h"
#include "../src/session_input.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ITERATIONS 20000u
#define CHECK(condition, label) do { \
    if (!(condition)) { \
        fprintf(stderr, "sanitizer fixture failed: %s (iteration %u)\n", label, iteration); \
        return 1; \
    } \
} while (0)

static uint32_t random_state = UINT32_C(0x52543621);
static unsigned iteration;

static uint32_t next_random(void)
{
    uint32_t value = random_state;
    value ^= value << 13;
    value ^= value >> 17;
    value ^= value << 5;
    random_state = value;
    return value;
}

static void put16(uint8_t *bytes, size_t offset, uint16_t value)
{
    bytes[offset] = (uint8_t)value;
    bytes[offset + 1u] = (uint8_t)(value >> 8);
}

typedef struct { uint8_t *bytes; size_t length; } Blob;

static void blob_append(Blob *blob, const void *data, size_t length)
{
    blob->bytes = (uint8_t *)realloc(blob->bytes, blob->length + length);
    memcpy(blob->bytes + blob->length, data, length);
    blob->length += length;
}

static void blob_chunk(Blob *blob, const char id[4], const uint8_t *payload, size_t length)
{
    uint8_t header[8];
    memcpy(header, id, 4);
    header[4] = (uint8_t)(length >> 24); header[5] = (uint8_t)(length >> 16);
    header[6] = (uint8_t)(length >> 8); header[7] = (uint8_t)length;
    blob_append(blob, header, 8);
    blob_append(blob, payload, length);
    if (length & 1u) { const uint8_t pad = 0; blob_append(blob, &pad, 1); }
}

/* Random 0x6a hotspots (hostile signed rectangles, frames 0..1) and 0x15 raw
 * scene hotspots, with the frame-0 record so rows become active at once. */
static SceneResource *random_scene(size_t *count_out)
{
    const size_t count = 1u + next_random() % 6u;
    Blob inner = {0}, outer = {0};
    uint8_t tsum[126];
    size_t index;
    char error[128];
    SceneResource *scene;
    memset(tsum, 0, sizeof(tsum));
    memcpy(tsum, "Fuzz\0", 5);
    memcpy(tsum + 50, "background\0", 11);
    memcpy(tsum + 83, "sound\0", 6);
    blob_append(&inner, "SCEN", 4);
    blob_chunk(&inner, "TSUM", tsum, sizeof(tsum));
    for (index = 0; index < count; ++index) {
        uint8_t payload[50 + 62];
        size_t body_length;
        memset(payload, 0, sizeof(payload));
        memcpy(payload, "fuzz hotspot", 12);
        if (next_random() % 5u == 0u) { /* raw 0x15 scene hotspot (0x0d) */
            payload[48] = 0x15; payload[49] = 1;
            payload[50] = 0x0d; payload[51] = 0xfe;
            put16(payload, 52, (uint16_t)(next_random() % 9000u));
            for (size_t k = 0; k < 4; ++k) {
                const int32_t value = (int32_t)(next_random() % 700u) - 40;
                memcpy(payload + 54 + k * 4, &value, 4);
            }
            body_length = 20u;
        } else {
            payload[48] = 0x6a; payload[49] = (uint8_t)(1u + next_random() % 2u);
            for (size_t k = 0; k < 10; ++k) put16(payload, 50 + k * 4, 0xffff);
            put16(payload, 50, (uint16_t)(1 + next_random() % 15u));
            put16(payload, 52, (uint16_t)(1 + next_random() % 9u));
            put16(payload, 90, 1u);
            put16(payload, 92, 0u);                         /* frame 0 */
            for (size_t k = 0; k < 4; ++k) {                /* l, t, r, b as i16 + pad */
                const uint16_t v = (next_random() % 11u == 0u)
                    ? (uint16_t)next_random() : (uint16_t)(next_random() % 640u);
                put16(payload, 94 + k * 4, v);
            }
            body_length = 60u;
        }
        blob_chunk(&inner, "ACT\0", payload, 50u + body_length);
    }
    blob_append(&outer, "DATA", 4);
    {
        const uint8_t size[4] = {(uint8_t)(inner.length >> 24), (uint8_t)(inner.length >> 16),
                                 (uint8_t)(inner.length >> 8), (uint8_t)inner.length};
        blob_append(&outer, size, 4);
    }
    blob_append(&outer, inner.bytes, inner.length);
    free(inner.bytes);
    scene = scene_resource_open_memory(outer.bytes, outer.length, error, sizeof(error));
    free(outer.bytes);
    *count_out = count;
    return scene;
}

static SessionInputState g_state;
static SessionInputContext g_context;
static unsigned g_hostile_external;

static int host_consume(void *context, SceneExecutorFrameInput *frame, int32_t *candidate)
{
    int status;
    (void)context;
    status = session_input_tick(&g_state, &g_context, frame);
    *candidate = g_state.candidate;
    return status;
}

static int host_scan(void *context, const SessionInputHotspot *rows, size_t count,
                     int32_t *candidate)
{
    int status;
    (void)context;
    session_input_publish_candidate(&g_state, -1);
    status = session_input_scan(&g_state, &g_context, rows, count);
    *candidate = g_state.candidate;
    return status;
}

static int host_reset(void *context) { (void)context; return session_input_init(&g_state); }

static int host_external(void *context, size_t index, SessionInputHotspot *row)
{
    (void)context;
    if (next_random() % 7u != 0u) return 0;
    row->index = (int32_t)index;
    row->active = 1u;
    row->rectangle.left = (int32_t)(next_random() % 300u);
    row->rectangle.top = (int32_t)(next_random() % 300u);
    row->rectangle.right = row->rectangle.left + (int32_t)(next_random() % 300u);
    row->rectangle.bottom = row->rectangle.top + (int32_t)(next_random() % 300u);
    if (next_random() % 97u == 0u) { row->rectangle.left = 70000; ++g_hostile_external; }
    return 1;
}

static SceneSessionCallbackStatus ok_prepare(void *context, SceneConditionState *c,
                                             SceneExecutorFrameInput *f, SceneSessionFailure *x)
{
    (void)context; (void)c; (void)x;
    f->current_frame = (int32_t)(next_random() % 2u);
    /* hostile forged pointer members must be discarded while bound */
    f->hotspot_activation_event = (uint8_t)next_random();
    f->activation_candidate_valid = (uint8_t)next_random();
    f->activation_candidate = (int32_t)next_random();
    return SCENE_SESSION_CALLBACK_OK;
}

static SceneSessionCallbackStatus ok_media(void *context, SceneExecutorFrameInput *f, SceneSessionFailure *x)
{ (void)context; (void)f; (void)x; return SCENE_SESSION_CALLBACK_OK; }

static void randomize_context(void)
{
    SessionInputContext *c = &g_context;
    c->viewport.left = (int32_t)(next_random() % 20u);
    c->viewport.top = (int32_t)(next_random() % 20u);
    c->viewport.right = c->viewport.left + 619;
    c->viewport.bottom = c->viewport.top + 374;
    if (next_random() % 53u == 0u) { c->viewport.right = c->viewport.left - 5; }  /* hostile order */
    c->cursor.left = (int32_t)(next_random() % 700u) - 30;
    c->cursor.top = (int32_t)(next_random() % 500u) - 30;
    c->cursor.right = c->cursor.left + (int32_t)(next_random() % 3u);
    c->cursor.bottom = c->cursor.top + (int32_t)(next_random() % 3u);
    c->hot_x = (next_random() % 9u == 0u) ? (int32_t)next_random() : 0;
    c->hot_y = (next_random() % 9u == 0u) ? (int32_t)next_random() : 0;
    c->scroll_y = (next_random() % 9u == 0u) ? (int32_t)next_random() : 0;
    c->cursor_mode = (int32_t)(next_random() % 8u);
    if (next_random() % 4u != 0u) c->cursor_mode = 0;
    c->modal_event = next_random() % 17u == 0u;
    c->producer_disabled = next_random() % 19u == 0u;
    c->geometry_ready = next_random() % 13u != 0u;
    c->priority_clear = next_random() % 11u != 0u;
    c->excluded_0 = (next_random() % 5u == 0u) ? (int32_t)(next_random() % 8u) : -1;
    c->excluded_1 = (next_random() % 5u == 0u) ? (int32_t)(next_random() % 8u) : -1;
    if (next_random() % 211u == 0u) c->excluded_0 = 500;  /* hostile */
}

static int make_session(SceneResource **scene, int32_t *flags, ActionCoreWorld *world,
                        SceneConditionState *conditions, SceneSession **session)
{
    SceneSessionConfig config;
    SceneSessionFailure failure;
    SceneSessionPointerHost host;
    size_t count;
    *scene = random_scene(&count);
    if (*scene == NULL) return 1;
    memset(flags, 0, 16u * sizeof(*flags));
    memset(world, 0, sizeof(*world));
    world->event_flags = flags;
    world->event_flag_count = 16u;
    memset(conditions, 0, sizeof(*conditions));
    conditions->event_flags = flags;
    conditions->event_flag_count = 16u;
    memset(&config, 0, sizeof(config));
    config.scene = *scene;
    config.scene_id = 1;
    config.action_core_world = world;
    config.conditions = conditions;
    config.prepare_tick = ok_prepare;
    config.advance_media_one = ok_media;
    if (scene_session_create(&config, session, &failure) != SCENE_SESSION_OK) return 2;
    memset(&host, 0, sizeof(host));
    host.consume = host_consume; host.scan = host_scan; host.reset = host_reset;
    host.external_row = host_external;
    if (scene_session_bind_pointer(*session, &host) != SCENE_SESSION_OK) return 3;
    return 0;
}

int main(void)
{
    SceneResource *scene = NULL;
    int32_t flags[16];
    ActionCoreWorld world;
    SceneConditionState conditions;
    SceneSession *session = NULL;
    unsigned activations = 0, limits = 0, replacements = 0, freezes = 0, hits = 0;
    int rc;

    rc = make_session(&scene, flags, &world, &conditions, &session);
    if (rc != 0) { fprintf(stderr, "setup failed %d\n", rc); return 1; }
    for (iteration = 0; iteration < ITERATIONS; ++iteration) {
        SceneSessionTickResult result;
        SceneSessionPointerResult pointer;
        const uint32_t pick = next_random() % 10u;
        randomize_context();
        if (pick < 3u) session_input_feed(&g_state, SESSION_INPUT_PRIMARY_DOWN, 0u, 1, 1, NULL, NULL);
        if (pick >= 2u && pick < 6u) session_input_feed(&g_state, SESSION_INPUT_PRIMARY_UP, 0u, 1, 1, NULL, NULL);
        if (pick == 6u) session_input_feed(&g_state, SESSION_INPUT_PRIMARY_DBLCLK, 0u, 1, 1, NULL, NULL);
        if (pick == 7u) session_input_feed(&g_state, SESSION_INPUT_MOVE, next_random(), (int32_t)next_random(), (int32_t)next_random(), NULL, NULL);
        if (next_random() % 23u == 0u)  /* hostile candidate published by a host */
            session_input_publish_candidate(&g_state, (int32_t)(next_random() % 600u) - 100);
        (void)scene_session_tick(session, &result);
        CHECK(scene_session_get_pointer_result(session, &pointer) == SCENE_SESSION_OK, "result");
        CHECK(pointer.candidate_after_scan >= -1 && pointer.candidate_after_scan < 240, "scan range");
        if (pointer.activation_event) {
            ++activations;
            CHECK(pointer.candidate_at_consume >= 0 && pointer.candidate_at_consume < 240, "activation range");
        }
        if (pointer.consume_status > 0 && pointer.consume_status != SESSION_INPUT_INVALID_ARGUMENT) ++limits;
        if (pointer.candidate_after_scan >= 0) ++hits;
        if (result.status == SCENE_SESSION_BLOCKED || result.status == SCENE_SESSION_ERR_EXECUTOR ||
            result.status == SCENE_SESSION_ERR_STATE) {
            /* sticky freeze (hostile geometry or rectangle): must stay frozen, then start over */
            CHECK((int)scene_session_tick(session, &result) == (int)result.status, "sticky");
            ++freezes;
            scene_session_destroy(session);
            scene_resource_close(scene);
            rc = make_session(&scene, flags, &world, &conditions, &session);
            CHECK(rc == 0, "recreate");
        } else if (result.status == SCENE_SESSION_TRANSITION_PENDING || next_random() % 40u == 0u) {
            SceneResource *next;
            size_t count;
            SceneSessionFailure failure;
            next = random_scene(&count);
            CHECK(next != NULL, "next scene");
            CHECK(scene_session_replace_scene(session, next, result.status == SCENE_SESSION_TRANSITION_PENDING
                                              ? (int32_t)result.executor.transition.target_scene : 1,
                                              &failure) == SCENE_SESSION_OK, "replace");
            scene_resource_close(scene);
            scene = next;
            ++replacements;
            CHECK(g_state.candidate == -1, "candidate reset on replace");
        }
    }
    scene_session_destroy(session);
    scene_resource_close(scene);
    printf("session pointer sanitizer fixtures passed: %u iterations, %u activations, %u scan hits, "
           "%u projection limits, %u replacements, %u freezes, %u hostile external rows\n",
           ITERATIONS, activations, hits, limits, replacements, freezes, g_hostile_external);
    return 0;
}
