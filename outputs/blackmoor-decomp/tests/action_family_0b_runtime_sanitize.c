/* RT-16 ASan/UBSan driver: bounded malformed inputs for the raw 0x0b loader, kernel
 * and session binding. Every body is an exact-size heap allocation so any
 * out-of-bounds access is reported. Exit 0 means every loop completed. */
#include "session_bindings_a0b.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    uint64_t effects;
    int refuse_world;
    int refuse_transition;
    uint64_t transitions;
} Probe;

static void observe(void *context, size_t row, int effect, int32_t value)
{
    Probe *probe = (Probe *)context;
    (void)row;
    (void)value;
    assert(effect >= ACTION17_FX_START_FLAG && effect <= ACTION17_FX_MODE);
    ++probe->effects;
}

static void kernel_observe(void *context, int effect, int32_t value)
{
    (void)value;
    assert(effect >= ACTION17_FX_START_FLAG && effect <= ACTION17_FX_MODE);
    ++*(uint64_t *)context;
}

static int load_world(void *context, Action17World *world)
{
    Probe *probe = (Probe *)context;
    if (probe->refuse_world) return 1;
    world->selector = 0;
    world->start_flag_5bb1ca = 0;
    world->mode_583999 = 3;
    return 0;
}

static int transition(void *context, const SceneTransitionRequest *request)
{
    Probe *probe = (Probe *)context;
    (void)request;
    ++probe->transitions;
    return probe->refuse_transition ? 1 : 0;
}

static uint32_t lcg(uint32_t *state)
{
    *state = *state * 1664525u + 1013904223u;
    return *state >> 8;
}

static void put_le16(uint8_t *p, uint16_t v) { p[0] = (uint8_t)v; p[1] = (uint8_t)(v >> 8); }
static void put_le32(uint8_t *p, uint32_t v)
{
    p[0] = (uint8_t)v; p[1] = (uint8_t)(v >> 8); p[2] = (uint8_t)(v >> 16); p[3] = (uint8_t)(v >> 24);
}

typedef struct { uint64_t loads, accepted, rejected, steps, requested, finished, hovers; } KernelStats;

/* Loader against every body length around 24 with random contents, then the kernel and the
 * hover cursor on every accepted payload. */
static KernelStats kernel_sweep(void)
{
    KernelStats stats;
    uint32_t seed = 0x16u;
    static const uint32_t phases[] = {0u, 1u, 2u, 3u, 7u, 0xffffffffu};
    unsigned round;
    size_t length;
    memset(&stats, 0, sizeof(stats));
    for (round = 0; round < 400u; ++round) {
        for (length = 0; length <= 40u; ++length) {
            uint8_t *body = (uint8_t *)malloc(length ? length : 1u);
            Action0bPayload payload, before;
            const char *why = NULL;
            int status;
            size_t i;
            assert(body != NULL);
            for (i = 0; i < length; ++i) body[i] = (uint8_t)lcg(&seed);
            memset(&payload, 0x5a, sizeof(payload));
            before = payload;
            status = action0b_load(body, length, &payload, (round & 1u) ? &why : NULL);
            ++stats.loads;
            if (length != ACTION0B_BODY_BYTES) {
                assert(status == ACTION17_ERR_BOUNDS);
                assert(memcmp(&payload, &before, sizeof(payload)) == 0);
                ++stats.rejected;
            } else {
                size_t phase_index;
                int held;
                assert(status == ACTION17_OK);
                ++stats.accepted;
                for (phase_index = 0; phase_index < 6u; ++phase_index) {
                    Action17Slot slot;
                    Action17World world;
                    Action17Result result;
                    Action17Host host;
                    uint64_t effects = 0;
                    memset(&slot, 0x5a, sizeof(slot));
                    memset(&world, 0xa5, sizeof(world));
                    world.selector = (int16_t)(lcg(&seed) % 3u) - 1;
                    host.context = &effects;
                    host.observe = (lcg(&seed) & 3u) ? kernel_observe : NULL;
                    status = action0b_step(&payload, phases[phase_index], &slot, &world,
                                           (lcg(&seed) % 5u) ? &host : NULL, &result);
                    assert(status == ACTION17_OK);
                    ++stats.steps;
                    if (result.requested) ++stats.requested;
                    if (result.finished) {
                        ++stats.finished;
                        assert(world.mode_583999 == 4 && slot.done == 1u);
                    }
                    assert(result.phase_after == (phases[phase_index] == 0u ? 1u : phases[phase_index]));
                }
                for (held = -3; held <= 70; ++held) {
                    Action17Cursor cursor;
                    assert(action0b_hover_cursor(&payload, (int16_t)held, &cursor) == ACTION17_OK);
                    ++stats.hovers;
                }
                {
                    Action17Cursor cursor;
                    assert(action0b_hover_cursor(&payload, INT16_MIN, &cursor) == ACTION17_OK);
                    assert(action0b_hover_cursor(&payload, INT16_MAX, &cursor) == ACTION17_OK);
                }
            }
            free(body);
        }
    }
    /* Every value of the cursor word (and of the frame-bearing word) against the hover rules. */
    {
        uint32_t word;
        uint8_t body[ACTION0B_BODY_BYTES];
        memset(body, 0, sizeof(body));
        for (word = 0; word <= 0xffffu; ++word) {
            Action0bPayload payload;
            Action17Cursor cursor;
            put_le16(body, (uint16_t)word);
            assert(action0b_load(body, sizeof(body), &payload, NULL) == ACTION17_OK);
            assert(action0b_hover_cursor(&payload, -1, &cursor) == ACTION17_OK);
            assert(cursor.cursor_index == payload.cursor && cursor.surface == ACTION17_SURFACE_UNCHANGED);
            assert(action0b_hover_cursor(&payload, 3, &cursor) == ACTION17_OK);
            ++stats.hovers;
        }
    }
    {
        Action0bPayload payload;
        Action17Slot slot;
        Action17World world;
        Action17Result result;
        Action17Cursor cursor;
        uint8_t body[ACTION0B_BODY_BYTES] = {0};
        const char *why = NULL;
        assert(action0b_load(NULL, 24, &payload, &why) == ACTION17_ERR_ARGUMENT);
        assert(action0b_load(body, 24, NULL, &why) == ACTION17_ERR_ARGUMENT);
        assert(action0b_load(body, 24, &payload, NULL) == ACTION17_OK);
        assert(action0b_step(NULL, 0, &slot, &world, NULL, &result) == ACTION17_ERR_ARGUMENT);
        assert(action0b_step(&payload, 0, NULL, &world, NULL, &result) == ACTION17_ERR_ARGUMENT);
        assert(action0b_step(&payload, 0, &slot, NULL, NULL, &result) == ACTION17_ERR_ARGUMENT);
        assert(action0b_step(&payload, 0, &slot, &world, NULL, NULL) == ACTION17_ERR_ARGUMENT);
        assert(action0b_hover_cursor(NULL, -1, &cursor) == ACTION17_ERR_ARGUMENT);
        assert(action0b_hover_cursor(&payload, -1, NULL) == ACTION17_ERR_ARGUMENT);
    }
    return stats;
}

static void put_be32(uint8_t *p, uint32_t v)
{
    p[0] = (uint8_t)(v >> 24); p[1] = (uint8_t)(v >> 16); p[2] = (uint8_t)(v >> 8); p[3] = (uint8_t)v;
}

/* DATA/SCEN with a TSUM chunk and ACT chunks (type, subtype, body). */
static uint8_t *build_scene(const uint8_t types[], const uint8_t *bodies[], const size_t lengths[],
                            size_t rows, size_t *out_length)
{
    size_t capacity = 8u + 4u + 8u + 126u + rows * (8u + 50u + 40u), used = 0, i;
    uint8_t *data;
    uint8_t tsum[126] = {0};
    for (i = 0; i < rows; ++i) capacity += lengths[i];
    data = (uint8_t *)calloc(capacity, 1u);
    assert(data != NULL);
    memcpy(data, "DATA", 4); memcpy(data + 8, "SCEN", 4); used = 12u;
    memcpy(tsum, "Session", 7); memcpy(tsum + 50, "background", 10); memcpy(tsum + 83, "sound", 5);
    memcpy(data + used, "TSUM", 4); put_be32(data + used + 4, 126u);
    memcpy(data + used + 8, tsum, 126u); used += 8u + 126u;
    for (i = 0; i < rows; ++i) {
        uint8_t *chunk = data + used;
        size_t payload = 50u + lengths[i];
        memcpy(chunk, "ACT\0", 4); put_be32(chunk + 4, (uint32_t)payload);
        memcpy(chunk + 8, "sanitize", 8);
        chunk[8 + 48] = types[i]; chunk[8 + 49] = 1u;
        memcpy(chunk + 8 + 50, bodies[i], lengths[i]);
        used += 8u + payload + (payload & 1u);
    }
    put_be32(data + 4, (uint32_t)(used - 8u));
    *out_length = used;
    return data;
}

typedef struct {
    uint64_t scenes_opened, scenes_rejected_by_parser, begin_ok, begin_rejected, handler_calls,
        handler_ok, handler_error, handler_unsupported, pre_gates, pointer_rows, hovers, transitions;
} BindingStats;

static BindingStats binding_sweep(void)
{
    uint8_t good[24];
    uint8_t shortbody[10];
    uint8_t longbody[25];
    BindingStats stats;
    size_t variant, offset;
    memset(&stats, 0, sizeof(stats));
    memset(good, 0, sizeof(good));
    put_le16(good, 9u); put_le16(good + 2, 6404u); put_le16(good + 4, 4u); put_le16(good + 6, 1u);
    put_le32(good + 8, 1u); put_le32(good + 12, 325u); put_le32(good + 16, 619u);
    put_le32(good + 20, 374u);
    memset(shortbody, 0, sizeof(shortbody));
    memcpy(longbody, good, sizeof(good));
    longbody[24] = 0;
    for (variant = 0; variant < 6; ++variant) {
        const uint8_t types[4] = {0x0b, 0x0b, 0x61, 0x0b};
        const uint8_t *test_bodies[4] = {good, good, good, good};
        size_t test_lengths[4] = {sizeof(good), sizeof(good), 4, sizeof(good)};
        uint8_t *data;
        size_t length;
        if (variant == 1) { test_bodies[0] = shortbody; test_lengths[0] = sizeof(shortbody); }
        if (variant == 2) { test_bodies[1] = longbody; test_lengths[1] = sizeof(longbody); }
        if (variant == 3) { test_lengths[3] = sizeof(good) - 1u; }
        data = build_scene(types, test_bodies, test_lengths, 4, &length);
        for (offset = 0; offset < (variant >= 4 ? length : 1u); ++offset) {
            size_t scene_length = length - (variant == 5 ? offset : 0u);
            uint8_t *scene_copy = (uint8_t *)malloc(scene_length ? scene_length : 1u);
            SceneResource *scene;
            char error[128];
            SessionA0bHost host;
            SessionA0bBinding *binding;
            Probe probe;
            size_t row;
            memset(&probe, 0, sizeof(probe));
            assert(scene_copy != NULL);
            memcpy(scene_copy, data, scene_length);
            if (variant == 4) scene_copy[offset] ^= 0x5au;
            scene = scene_resource_open_memory(scene_copy, scene_length, error, sizeof(error));
            memset(&host, 0, sizeof(host));
            host.context = &probe;
            host.load_world = (offset % 7u == 3u) ? NULL : load_world;
            host.transition = (offset % 11u == 5u) ? NULL : transition;
            host.observe = (offset % 3u == 0u) ? observe : NULL;
            probe.refuse_world = offset % 13u == 4u;
            probe.refuse_transition = offset % 17u == 6u;
            binding = session_a0b_create(&host);
            assert(binding != NULL);
            if (scene == NULL) {
                ++stats.scenes_rejected_by_parser;
            } else {
                int status = session_a0b_begin_scene(binding, scene);
                ++stats.scenes_opened;
                if (status == ACTION17_OK) ++stats.begin_ok; else ++stats.begin_rejected;
                for (row = 0; row < scene_resource_action_count(scene) + 2u; ++row) {
                    SceneActionInfo info;
                    SceneActionRuntimeState before = {0u, 0u};
                    SceneActionHandlerResult out = {0, 0u};
                    SessionInputHotspot spot;
                    Action17Cursor cursor;
                    Action17Slot slot;
                    Action0bPayload payload;
                    uint32_t phase;
                    memset(&info, 0, sizeof(info));
                    if (row < scene_resource_action_count(scene)) {
                        (void)scene_resource_action_at(scene, row, &info);
                    }
                    for (phase = 0; phase < 4u; ++phase) {
                        int handled;
                        before.phase = phase;
                        session_a0b_pre_gate(binding, row, &info, &before);
                        ++stats.pre_gates;
                        handled = session_a0b_handler(binding, row, &info, &before, &out);
                        assert(handled == SCENE_ACTION_HANDLER_OK || handled == SCENE_ACTION_HANDLER_ERROR ||
                               handled == SCENE_ACTION_HANDLER_UNSUPPORTED);
                        if (handled == SCENE_ACTION_HANDLER_OK) ++stats.handler_ok;
                        else if (handled == SCENE_ACTION_HANDLER_ERROR) ++stats.handler_error;
                        else ++stats.handler_unsupported;
                        ++stats.handler_calls;
                        if (session_a0b_pointer_row(binding, row, &spot) == 1) ++stats.pointer_rows;
                    }
                    if (session_a0b_hover_cursor(binding, row, 5, &cursor) == ACTION17_OK) ++stats.hovers;
                    (void)session_a0b_slot(binding, row, &slot);
                    (void)session_a0b_payload(binding, row, &payload);
                }
                (void)session_a0b_failure(binding);
                scene_resource_close(scene);
            }
            stats.transitions += probe.transitions;
            session_a0b_destroy(binding);
            free(scene_copy);
            if (variant >= 4 && offset > 1500u) break;
        }
        free(data);
    }
    assert(session_a0b_create(NULL) == NULL);
    assert(session_a0b_begin_scene(NULL, NULL) != ACTION17_OK);
    assert(strcmp(session_a0b_failure(NULL), "invalid binding") == 0);
    assert(session_a0b_row_count(NULL) == 0u);
    assert(session_a0b_pointer_row(NULL, 0, NULL) == 0);
    session_a0b_destroy(NULL);
    return stats;
}

int main(void)
{
    KernelStats kernel = kernel_sweep();
    BindingStats stats = binding_sweep();
    assert(kernel.accepted > 0 && kernel.rejected > 0 && kernel.requested > 0 && kernel.finished > 0);
    assert(stats.scenes_opened > 0 && stats.begin_ok > 0 && stats.handler_ok > 0 &&
           stats.handler_error > 0 && stats.pointer_rows > 0 && stats.transitions > 0);
    printf("loads=%llu accepted=%llu rejected=%llu steps=%llu requested=%llu finished=%llu "
           "kernel_hovers=%llu binding_scenes_opened=%llu scenes_rejected_by_parser=%llu begin_ok=%llu "
           "begin_rejected=%llu handler_calls=%llu handler_ok=%llu handler_error=%llu "
           "handler_unsupported=%llu pre_gates=%llu pointer_rows=%llu hovers=%llu transitions=%llu\n",
           (unsigned long long)kernel.loads, (unsigned long long)kernel.accepted,
           (unsigned long long)kernel.rejected, (unsigned long long)kernel.steps,
           (unsigned long long)kernel.requested, (unsigned long long)kernel.finished,
           (unsigned long long)kernel.hovers, (unsigned long long)stats.scenes_opened,
           (unsigned long long)stats.scenes_rejected_by_parser, (unsigned long long)stats.begin_ok,
           (unsigned long long)stats.begin_rejected, (unsigned long long)stats.handler_calls,
           (unsigned long long)stats.handler_ok, (unsigned long long)stats.handler_error,
           (unsigned long long)stats.handler_unsupported, (unsigned long long)stats.pre_gates,
           (unsigned long long)stats.pointer_rows, (unsigned long long)stats.hovers,
           (unsigned long long)stats.transitions);
    return 0;
}
