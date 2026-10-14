/* ASan/UBSan fixture for the RT-3 session bindings and the executor/session
 * hooks. Bounded malformed inputs only: random and boundary 0x62/0x51 bodies,
 * hostile phases/subtypes/event ids, malformed scene resources, host
 * callbacks that fail or return hostile pointers. */
#include "../src/action_family_62_interaction.h"
#include "../src/scene_executor.h"
#include "../src/scene_resource.h"
#include "../src/scene_session.h"
#include "../src/session_bindings_a51.h"
#include "../src/session_bindings_a62.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define CHECK(condition, label) do { \
    if (!(condition)) { \
        fprintf(stderr, "sanitizer fixture failed: %s\n", label); \
        return 1; \
    } \
} while (0)

static uint32_t random_state = UINT32_C(0x52543343);
static unsigned cases;
static unsigned a62_status_count[3], a51_status_count[3];

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

/* ---- scene builder ------------------------------------------------------ */

typedef struct {
    uint8_t *bytes;
    size_t length;
} Blob;

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
    header[4] = (uint8_t)(length >> 24);
    header[5] = (uint8_t)(length >> 16);
    header[6] = (uint8_t)(length >> 8);
    header[7] = (uint8_t)length;
    blob_append(blob, header, 8);
    blob_append(blob, payload, length);
    if (length & 1u) {
        const uint8_t pad = 0;
        blob_append(blob, &pad, 1);
    }
}

static Blob build_scene(const uint8_t *const *bodies, const size_t *lengths,
                        const uint8_t *types, const uint8_t *subtypes, size_t count)
{
    Blob inner = {0}, outer = {0};
    uint8_t tsum[126];
    size_t index;
    memset(tsum, 0, sizeof(tsum));
    memcpy(tsum, "Fuzz\0", 5);
    memcpy(tsum + 50, "background\0", 11);
    memcpy(tsum + 83, "sound\0", 6);
    blob_append(&inner, "SCEN", 4);
    blob_chunk(&inner, "TSUM", tsum, sizeof(tsum));
    for (index = 0; index < count; ++index) {
        uint8_t *payload = (uint8_t *)calloc(1, 50 + lengths[index]);
        memcpy(payload, "fuzz action", 11);
        payload[48] = types[index];
        payload[49] = subtypes[index];
        if (lengths[index] != 0) memcpy(payload + 50, bodies[index], lengths[index]);
        blob_chunk(&inner, "ACT\0", payload, 50 + lengths[index]);
        free(payload);
    }
    blob_append(&outer, "DATA", 4);
    {
        const uint8_t size[4] = {(uint8_t)(inner.length >> 24), (uint8_t)(inner.length >> 16),
                                 (uint8_t)(inner.length >> 8), (uint8_t)inner.length};
        blob_append(&outer, size, 4);
    }
    blob_append(&outer, inner.bytes, inner.length);
    free(inner.bytes);
    return outer;
}

/* ---- 0x62 --------------------------------------------------------------- */

static int g_selector_mode;
static int fuzz_selector(void *context, int16_t *selector)
{
    (void)context;
    if (g_selector_mode == 1) return 1;
    *selector = (int16_t)next_random();
    if (g_selector_mode == 2) *selector = (int16_t)(next_random() % 3u);
    return 0;
}

static int fuzz_a62(void)
{
    int32_t flags[16];
    ActionCoreWorld world;
    SessionA62Host host;
    SessionA62Binding *binding;
    uint8_t body[96];
    unsigned iteration;

    memset(flags, 0, sizeof(flags));
    memset(&world, 0, sizeof(world));
    world.event_flags = flags;
    world.event_flag_count = 16u;
    memset(&host, 0, sizeof(host));
    host.current_selector = fuzz_selector;

    CHECK(session_a62_create(NULL, &host) == NULL, "a62 create null world");
    CHECK(session_a62_create(&world, NULL) == NULL, "a62 create null host");
    {
        SessionA62Host bare = {0};
        CHECK(session_a62_create(&world, &bare) == NULL, "a62 create without selector provider");
    }
    binding = session_a62_create(&world, &host);
    CHECK(binding != NULL, "a62 create");
    CHECK(session_a62_begin_scene(NULL, 1) != 0, "begin null");
    CHECK(session_a62_begin_scene(binding, SCENE_EXECUTOR_MAX_ACTIONS + 1u) != 0, "begin over limit");
    CHECK(session_a62_begin_scene(binding, 4u) == 0, "begin");

    for (iteration = 0; iteration < 30000u; ++iteration) {
        SceneActionInfo info;
        SceneActionRuntimeState state;
        SceneActionHandlerResult result;
        size_t length = next_random() % 64u;
        size_t i;
        for (i = 0; i < sizeof(body); ++i) body[i] = (uint8_t)next_random();
        if (iteration % 3u != 0u) {                          /* well-formed body */
            const unsigned count = next_random() % 4u;
            put16(body, 0, (uint16_t)(int16_t)((int)(next_random() % 26u) - 5));   /* ids -5..20 */
            put16(body, 4, (uint16_t)(int16_t)((int)(next_random() % 26u) - 5));
            put16(body, 8, (uint16_t)(int16_t)((int)(next_random() % 45u) - 2));   /* threshold */
            put16(body, 10, (uint16_t)count);
            for (i = 0; i < count; ++i) put16(body, 12u + i * 18u, (uint16_t)(next_random() % 3u));
            length = 12u + 18u * count + next_random() % 3u;
        } else {                                              /* hostile body */
            if (iteration % 7u == 0) put16(body, 10, 0x7fff);   /* huge count */
            if (iteration % 11u == 0) put16(body, 10, 0xffff);  /* negative */
        }
        memset(&info, 0, sizeof(info));
        info.type = (iteration % 17u == 0) ? (uint8_t)next_random() : 0x62u;
        info.subtype = (uint8_t)next_random();
        info.typed_body = (iteration % 13u == 0) ? NULL : body;
        info.typed_body_length = length;
        state.completed = (uint8_t)next_random();
        state.phase = (iteration % 5u == 0) ? 0xffffffffu : (next_random() % 5u);
        result.disposition = SCENE_ACTION_HANDLER_PENDING;
        result.phase = state.phase;
        g_selector_mode = (int)(next_random() % 3u);
        {
            const size_t index = (next_random() % 5u == 0u) ? next_random() % 300u : next_random() % 5u;
            const int status = session_a62_handler(binding, index, &info, &state, &result);
            CHECK(status == SCENE_ACTION_HANDLER_OK ||
                  status == SCENE_ACTION_HANDLER_UNSUPPORTED ||
                  status == SCENE_ACTION_HANDLER_ERROR, "handler status");
            ++a62_status_count[status];
            if (status == SCENE_ACTION_HANDLER_OK) {
                CHECK(result.disposition <= SCENE_ACTION_HANDLER_DIRECT_COMPLETED, "disposition");
            }
            session_a62_pre_gate(binding, index, &info, &state);
        }
        {
            ActionFamily62InteractionTarget target;
            SessionA62ScanRequest request;
            ActionFamily62InteractionScanResult scan;
            (void)session_a62_get_target(binding, next_random() % 6u, &target);
            request.coordinate_a = (int32_t)(next_random() % 64u) - 8;
            request.coordinate_b = (int32_t)(next_random() % 64u) - 8;
            request.reserved_index_a = (int32_t)(next_random() % 6u) - 1;
            request.reserved_index_b = (int32_t)(next_random() % 6u) - 1;
            request.cursor_command = (int32_t)(next_random() % 3u);
            CHECK(session_a62_scan_candidate(binding, &request, &scan) == 0, "scan");
        }
        ++cases;
    }
    {
        SceneActionInfo info; memset(&info, 0, sizeof(info));
        SceneActionRuntimeState state = {0, 0};
        SceneActionHandlerResult result = {0, 0};
        ActionFamily62InteractionTarget target;
        CHECK(session_a62_handler(NULL, 0, &info, &state, &result) == SCENE_ACTION_HANDLER_ERROR, "null context");
        CHECK(session_a62_handler(binding, 0, NULL, &state, &result) == SCENE_ACTION_HANDLER_ERROR, "null action");
        CHECK(session_a62_handler(binding, 0, &info, NULL, &result) == SCENE_ACTION_HANDLER_ERROR, "null state");
        CHECK(session_a62_handler(binding, 0, &info, &state, NULL) == SCENE_ACTION_HANDLER_ERROR, "null result");
        session_a62_pre_gate(NULL, 0, &info, &state);
        session_a62_pre_gate(binding, 0, NULL, &state);
        CHECK(session_a62_get_target(binding, 0, NULL) != 0, "get_target null");
        CHECK(session_a62_get_target(NULL, 0, &target) != 0, "get_target null binding");
        CHECK(session_a62_scan_candidate(NULL, NULL, NULL) != 0, "scan nulls");
        CHECK(session_a62_start_flag(NULL) == 0, "start flag null");
        CHECK(session_a62_last_failure(NULL) != SESSION_A62_FAIL_NONE, "last failure null");
        CHECK(session_a62_failure_string((SessionA62Failure)99) != NULL, "failure string");
    }
    session_a62_destroy(binding);
    session_a62_destroy(NULL);
    return 0;
}

/* ---- 0x51 --------------------------------------------------------------- */

static unsigned g_lookup_mode;
static ActionFamily51LookupStatus fuzz_lookup(void *context, const uint8_t *key, size_t key_length,
                                              const uint8_t **text, size_t *text_length)
{
    static const uint8_t sample[] = "Some caption text\0tail";
    (void)context; (void)key; (void)key_length;
    switch (g_lookup_mode % 5u) {
    case 0: *text = sample; *text_length = 17u; return ACTION_FAMILY_51_LOOKUP_FOUND;
    case 1: *text = sample; *text_length = sizeof(sample) - 1u; return ACTION_FAMILY_51_LOOKUP_FOUND;
    case 2: *text = NULL; *text_length = 0u; return ACTION_FAMILY_51_LOOKUP_FOUND;
    case 3: return ACTION_FAMILY_51_LOOKUP_NOT_FOUND;
    default: return ACTION_FAMILY_51_LOOKUP_ERROR;
    }
}

static ActionFamily51BackendStatus fuzz_measure(void *c, const uint8_t *t, size_t n, int16_t *lines)
{ (void)c; (void)t; (void)n; *lines = (int16_t)(next_random() % 5u); return ACTION_FAMILY_51_BACKEND_OK; }
static ActionFamily51BackendStatus fuzz_write(void *c, const uint8_t *t, size_t n)
{ (void)c; (void)t; (void)n; return (next_random() % 9u) ? ACTION_FAMILY_51_BACKEND_OK : ACTION_FAMILY_51_BACKEND_ERROR; }
static ActionFamily51BackendStatus fuzz_open(void *c, int32_t m, const uint8_t *t, size_t n)
{ (void)c; (void)m; (void)t; (void)n; return ACTION_FAMILY_51_BACKEND_OK; }
static ActionFamily51BackendStatus fuzz_close(void *c)
{ (void)c; return ACTION_FAMILY_51_BACKEND_OK; }
static ActionFamily51BackendStatus fuzz_playing(void *c, int16_t ch, int *p)
{ (void)c; (void)ch; *p = (int)(next_random() & 1u); return ACTION_FAMILY_51_BACKEND_OK; }
static ActionFamily51BackendStatus fuzz_tick(void *c, uint32_t *now)
{ (void)c; *now = next_random(); return ACTION_FAMILY_51_BACKEND_OK; }
static void fuzz_load(void *c, ActionFamily51World *w) { (void)c; (void)w; }
static void fuzz_store(void *c, const ActionFamily51World *w) { (void)c; (void)w; }

static int fuzz_a51(void)
{
    unsigned iteration;
    for (iteration = 0; iteration < 3000u; ++iteration) {
        uint8_t body[3u * 64u];
        const uint8_t *bodies[3];
        size_t lengths[3];
        uint8_t types[3] = {0x51, 0x51, 0x51};
        uint8_t subtypes[3];
        size_t row;
        Blob scene_bytes;
        SceneResource *scene;
        char error[128];
        SessionA51Host host;
        SessionA51Binding *binding;
        size_t failed_row = 0;
        int kernel_status = 0;

        memset(body, 0, sizeof(body));
        for (row = 0; row < 3u; ++row) {
            uint8_t *record = body + row * 64u;   /* 3 records of up to 64 bytes */
            const unsigned shape = next_random() % 5u;
            put16(record, 0, (uint16_t)(next_random() % 4u));         /* renderer */
            put16(record, 2, (uint16_t)(next_random() % 4u));         /* wait mode */
            put16(record, 4, (uint16_t)(next_random() % 16u));        /* channel */
            put16(record, 6, (uint16_t)(next_random() % 4000u));      /* wait ms low */
            subtypes[row] = (uint8_t)(next_random() % 4u);
            bodies[row] = record;
            if (shape <= 1u) {                                        /* AUTOTEXT key */
                size_t key = 1u + next_random() % 12u, k;
                put16(record, 10, 0xffff);
                if (shape == 1u) key = 33u;                            /* unterminated */
                for (k = 0; k < key; ++k) record[12 + k] = (uint8_t)('A' + next_random() % 26u);
                lengths[row] = 45u;
            } else if (shape <= 3u) {                                 /* inline text with NUL */
                size_t count = 1u + next_random() % 15u, k;
                put16(record, 10, (uint16_t)count);
                for (k = 0; k + 1u < count; ++k) record[12 + k] = (uint8_t)('a' + next_random() % 26u);
                record[12 + count - 1u] = (shape == 3u) ? 'z' : 0u;   /* shape 3: no NUL */
                lengths[row] = 12u + count;
            } else {                                                  /* hostile selector */
                put16(record, 10, (uint16_t)(next_random() % 3u == 0u ? 10000u : next_random()));
                lengths[row] = 12u + next_random() % 8u;
            }
        }
        scene_bytes = build_scene(bodies, lengths, types, subtypes, 3u);
        scene = scene_resource_open_memory(scene_bytes.bytes, scene_bytes.length, error, sizeof(error));
        free(scene_bytes.bytes);
        if (scene == NULL) { ++cases; continue; }

        memset(&host, 0, sizeof(host));
        host.backend.measure_caption_lines = fuzz_measure;
        host.backend.write_caption = fuzz_write;
        host.backend.open_frame_text = fuzz_open;
        host.backend.close_frame_text = fuzz_close;
        host.backend.is_channel_playing = fuzz_playing;
        host.backend.tick_count = fuzz_tick;
        host.lookup = (iteration % 4u == 3u) ? NULL : fuzz_lookup;
        host.load_world = fuzz_load;
        host.store_world = fuzz_store;
        g_lookup_mode = next_random();
        binding = session_a51_create(&host);
        CHECK(binding != NULL, "a51 create");
        if (session_a51_begin_scene(binding, scene, &failed_row, &kernel_status) == SESSION_A51_OK) {
            unsigned visit;
            for (visit = 0; visit < 24u; ++visit) {
                SceneActionInfo info;
                SceneActionRuntimeState state;
                SceneActionHandlerResult result = {0, 0};
                size_t index = next_random() % 3u;
                if (scene_resource_action_at(scene, index, &info) != SCENE_RESOURCE_OK) continue;
                state.completed = (uint8_t)(next_random() & 1u);
                state.phase = next_random() % 5u;
                {
                    const int status = session_a51_handler(binding, index, &info, &state, &result);
                    CHECK(status == SCENE_ACTION_HANDLER_OK || status == SCENE_ACTION_HANDLER_UNSUPPORTED ||
                          status == SCENE_ACTION_HANDLER_ERROR, "a51 handler status");
                    ++a51_status_count[status];
                }
                (void)session_a51_row_state(binding, index);
                (void)session_a51_record_renderer(binding, index);
            }
        } else {
            CHECK(failed_row < 3u, "a51 failed row bounded");
        }
        {
            SceneActionInfo info; memset(&info, 0, sizeof(info));
            SceneActionRuntimeState state = {0, 0};
            SceneActionHandlerResult result = {0, 0};
            CHECK(session_a51_handler(NULL, 0, &info, &state, &result) == SCENE_ACTION_HANDLER_ERROR, "a51 null ctx");
            CHECK(session_a51_handler(binding, 99, &info, &state, &result) == SCENE_ACTION_HANDLER_ERROR, "a51 oob row");
            CHECK(session_a51_begin_scene(binding, NULL, NULL, NULL) != 0, "a51 null scene");
            CHECK(session_a51_row_state(binding, 99) == SESSION_A51_ROW_NOT_A51, "a51 oob state");
            CHECK(session_a51_record_renderer(NULL, 0) == -1, "a51 null renderer");
        }
        session_a51_destroy(binding);
        scene_resource_close(scene);
        ++cases;
    }
    CHECK(session_a51_create(NULL) == NULL, "a51 create null");
    session_a51_destroy(NULL);
    return 0;
}

/* ---- executor/session hooks -------------------------------------------- */

static unsigned g_hook_calls;
static void count_hook(void *context, size_t index, const SceneActionInfo *action,
                       const SceneActionRuntimeState *state)
{
    (void)context; (void)index; (void)action; (void)state;
    ++g_hook_calls;
}

static SceneSessionCallbackStatus ok_prepare(void *context, SceneConditionState *c,
                                             SceneExecutorFrameInput *f, SceneSessionFailure *x)
{ (void)context; (void)c; (void)f; (void)x; return SCENE_SESSION_CALLBACK_OK; }
static SceneSessionCallbackStatus ok_media(void *context, SceneExecutorFrameInput *f, SceneSessionFailure *x)
{ (void)context; (void)f; (void)x; return SCENE_SESSION_CALLBACK_OK; }

static int fuzz_session(void)
{
    uint8_t body[30];
    const uint8_t *bodies[2] = {body, body};
    size_t lengths[2] = {30u, 30u};
    uint8_t types[2] = {0x62, 0x62};
    uint8_t subtypes[2] = {1, 2};
    Blob scene_bytes;
    SceneResource *scene;
    char error[128];
    int32_t flags[16];
    ActionCoreWorld world;
    SceneConditionState conditions;
    SceneSessionConfig config;
    SceneSession *session = NULL;
    SceneSessionFailure failure;
    SessionA62Binding *binding;
    SessionA62Host host;
    SceneSessionActionBinding action_binding;
    unsigned tick;

    memset(body, 0, sizeof(body));
    put16(body, 0, 3);
    put16(body, 2, 1);
    put16(body, 4, 0xffff);
    put16(body, 10, 1);
    scene_bytes = build_scene(bodies, lengths, types, subtypes, 2u);
    scene = scene_resource_open_memory(scene_bytes.bytes, scene_bytes.length, error, sizeof(error));
    free(scene_bytes.bytes);
    CHECK(scene != NULL, "session scene");
    memset(flags, 0, sizeof(flags));
    memset(&world, 0, sizeof(world));
    world.event_flags = flags;
    world.event_flag_count = 16u;
    memset(&conditions, 0, sizeof(conditions));
    conditions.event_flags = flags;
    conditions.event_flag_count = 16u;
    memset(&host, 0, sizeof(host));
    host.current_selector = fuzz_selector;
    g_selector_mode = 2;
    binding = session_a62_create(&world, &host);
    CHECK(binding != NULL && session_a62_begin_scene(binding, 2u) == 0, "session binding");
    memset(&action_binding, 0, sizeof(action_binding));
    action_binding.type = SESSION_A62_TYPE;
    action_binding.provider = SCENE_SESSION_PROVIDER_A62;
    action_binding.callback = session_a62_handler;
    action_binding.context = binding;
    memset(&config, 0, sizeof(config));
    config.scene = scene;
    config.scene_id = 1;
    config.action_core_world = &world;
    config.conditions = &conditions;
    config.action_bindings = &action_binding;
    config.action_binding_count = 1u;
    config.prepare_tick = ok_prepare;
    config.advance_media_one = ok_media;
    CHECK(scene_session_create(&config, &session, &failure) == SCENE_SESSION_OK, "session create");
    CHECK(scene_session_set_pre_gate(session, SESSION_A62_TYPE, session_a62_pre_gate, binding) == SCENE_SESSION_OK, "pre-gate");
    CHECK(scene_session_set_pre_gate(session, SESSION_A62_TYPE, count_hook, NULL) != SCENE_SESSION_OK, "duplicate pre-gate");
    CHECK(scene_session_set_pre_gate(session, 0x61, NULL, NULL) != SCENE_SESSION_OK, "null pre-gate");
    CHECK(scene_session_set_pre_gate(NULL, 0x61, count_hook, NULL) != SCENE_SESSION_OK, "null session");
    CHECK(scene_session_set_pre_gate(session, 0x70, count_hook, NULL) == SCENE_SESSION_OK, "second pre-gate");
    CHECK(scene_session_accept_action_candidate(session, 99) != SCENE_SESSION_OK, "accept oob");
    CHECK(scene_session_accept_action_candidate(NULL, 0) != SCENE_SESSION_OK, "accept null");
    for (tick = 0; tick < 200u; ++tick) {
        SceneSessionTickResult result;
        const int status = scene_session_tick(session, &result);
        if (status == SCENE_SESSION_ERR_EXECUTOR || status == SCENE_SESSION_BLOCKED) {
            /* A sticky failure (for example an out-of-range event id) is fine;
             * the session stays frozen and must keep answering. */
            CHECK(scene_session_tick(session, &result) == status, "sticky failure");
            break;
        }
        if (next_random() % 3u == 0u) (void)scene_session_accept_action_candidate(session, next_random() % 2u);
        ++cases;
    }
    scene_session_destroy(session);
    session_a62_destroy(binding);
    scene_resource_close(scene);
    return 0;
}

int main(void)
{
    if (fuzz_a62() != 0 || fuzz_a51() != 0 || fuzz_session() != 0) return 1;
    printf("session bindings sanitizer fixtures passed: %u cases; 0x62 handler ok/unsupported/error "
           "%u/%u/%u; 0x51 handler ok/unsupported/error %u/%u/%u\n", cases,
           a62_status_count[0], a62_status_count[1], a62_status_count[2],
           a51_status_count[0], a51_status_count[1], a51_status_count[2]);
    return 0;
}
