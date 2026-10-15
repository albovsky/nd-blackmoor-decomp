/* RT-20 ASan/UBSan driver: bounded malformed inputs for the raw 0x0c kernel and session binding.
 * Every body is an exact-size heap allocation so any out-of-bounds access is reported. Exit 0
 * means every loop completed. */
#include "session_bindings_a0c.h"

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
    world->selector = 4;
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

typedef struct { uint64_t validations, accepted, rejected, steps, requested, finished, hovers; } KernelStats;

/* Valid-looking bodies: the count word is forced to a chosen value and the length is swept around
 * 10 + 18 * count, so the kernel sees exact, short, long and ragged objects. */
static KernelStats kernel_sweep(void)
{
    KernelStats stats;
    uint32_t seed = 0x0cu;
    static const uint32_t phases[] = {0u, 1u, 2u, 3u, 7u, 0xffffffffu};
    static const int32_t counts[] = {0, 1, 2, 3, 5, 7, 20, 100, 1818, 1819, 1820, 3641, 32767, -1, -2,
                                     -32768};
    unsigned round;
    size_t ci;
    memset(&stats, 0, sizeof(stats));
    for (round = 0; round < 24u; ++round) {
        for (ci = 0; ci < sizeof(counts) / sizeof(counts[0]); ++ci) {
            int32_t count = counts[ci];
            size_t exact = 10u + 18u * (size_t)(uint16_t)(int16_t)count;
            int delta;
            if (count < 0 || count > 1819) exact = 10u + 18u * (size_t)(count < 0 ? 0 : 3);
            for (delta = -20; delta <= 20; ++delta) {
                size_t length = exact + (size_t)delta;
                uint8_t *body;
                const char *why = NULL;
                int status, valid;
                size_t i;
                if ((delta < 0 && (size_t)(-delta) > exact) || length > 40000u) continue;
                body = (uint8_t *)malloc(length ? length : 1u);
                assert(body != NULL);
                for (i = 0; i < length; ++i) body[i] = (uint8_t)lcg(&seed);
                if (length >= 10u) put_le16(body + 8, (uint16_t)(int16_t)count);
                if (length >= 10u) put_le16(body, (uint16_t)lcg(&seed));
                status = action0c_validate_body(body, length, (round & 1u) ? &why : NULL);
                ++stats.validations;
                valid = length >= 10u && count >= 0 && count <= 1819 &&
                        length == 10u + 18u * (size_t)count;
                if (!valid) {
                    size_t phase_index;
                    assert(status == ACTION17_ERR_BOUNDS);
                    ++stats.rejected;
                    for (phase_index = 0; phase_index < 6u; ++phase_index) {
                        Action17Slot slot, slot_before;
                        Action17World world, world_before;
                        Action17Result result;
                        memset(&slot, 0x5a, sizeof(slot));
                        memset(&world, 0xa5, sizeof(world));
                        slot_before = slot;
                        world_before = world;
                        assert(action0c_step(body, length, phases[phase_index], &slot, &world, NULL,
                                             &result, NULL) == ACTION17_ERR_BOUNDS);
                        assert(memcmp(&slot, &slot_before, sizeof(slot)) == 0);
                        assert(memcmp(&world, &world_before, sizeof(world)) == 0);
                    }
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
                        /* pick frames that hit: the first record's frame, then misses */
                        world.selector = (count > 0 && (lcg(&seed) & 1u))
                                             ? (int16_t)(body[10] | (body[11] << 8))
                                             : (int16_t)(lcg(&seed) % 3u) - 1;
                        host.context = &effects;
                        host.observe = (lcg(&seed) & 3u) ? kernel_observe : NULL;
                        status = action0c_step(body, length, phases[phase_index], &slot, &world,
                                               (lcg(&seed) % 5u) ? &host : NULL, &result, NULL);
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
                        assert(action0c_hover_cursor(body, length, (int16_t)held, &cursor) == ACTION17_OK);
                        ++stats.hovers;
                    }
                    {
                        Action17Cursor cursor;
                        assert(action0c_hover_cursor(body, length, INT16_MIN, &cursor) == ACTION17_OK);
                        assert(action0c_hover_cursor(body, length, INT16_MAX, &cursor) == ACTION17_OK);
                    }
                }
                free(body);
            }
        }
    }
    /* Every value of the cursor word against the hover rules (10-byte empty body). */
    {
        uint32_t word;
        uint8_t body[10];
        memset(body, 0, sizeof(body));
        for (word = 0; word <= 0xffffu; ++word) {
            Action17Cursor cursor;
            put_le16(body, (uint16_t)word);
            assert(action0c_hover_cursor(body, sizeof(body), -1, &cursor) == ACTION17_OK);
            assert(cursor.cursor_index == (int16_t)(uint16_t)word &&
                   cursor.surface == ACTION17_SURFACE_UNCHANGED);
            assert(action0c_hover_cursor(body, sizeof(body), 3, &cursor) == ACTION17_OK);
            ++stats.hovers;
        }
    }
    {
        Action17Slot slot;
        Action17World world;
        Action17Result result;
        Action17Cursor cursor;
        uint8_t body[10] = {0};
        const char *why = NULL;
        assert(action0c_validate_body(NULL, 10, &why) == ACTION17_ERR_ARGUMENT);
        assert(action0c_validate_body(body, 10, NULL) == ACTION17_OK);
        assert(action0c_step(NULL, 10, 0, &slot, &world, NULL, &result, &why) == ACTION17_ERR_ARGUMENT);
        assert(action0c_step(body, 10, 0, NULL, &world, NULL, &result, &why) == ACTION17_ERR_ARGUMENT);
        assert(action0c_step(body, 10, 0, &slot, NULL, NULL, &result, &why) == ACTION17_ERR_ARGUMENT);
        assert(action0c_step(body, 10, 0, &slot, &world, NULL, NULL, &why) == ACTION17_ERR_ARGUMENT);
        assert(action0c_hover_cursor(NULL, 10, -1, &cursor) == ACTION17_ERR_ARGUMENT);
        assert(action0c_hover_cursor(body, 10, -1, NULL) == ACTION17_ERR_ARGUMENT);
        assert(action0c_hover_cursor(body, 9, -1, &cursor) == ACTION17_ERR_BOUNDS);
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
    uint8_t good[28];
    uint8_t shortbody[9];
    uint8_t countbody[28];
    BindingStats stats;
    size_t variant, offset;
    memset(&stats, 0, sizeof(stats));
    memset(good, 0, sizeof(good));
    put_le16(good, 8u); put_le16(good + 2, 2008u); put_le16(good + 4, 0u); put_le16(good + 6, 1u);
    put_le16(good + 8, 1u);
    put_le16(good + 10, 4u); put_le32(good + 12, 3u); put_le32(good + 16, 2u);
    put_le32(good + 20, 200u); put_le32(good + 24, 114u);
    memset(shortbody, 0, sizeof(shortbody));
    memcpy(countbody, good, sizeof(good));
    put_le16(countbody + 8, 0xffffu);     /* count -1 */
    for (variant = 0; variant < 6; ++variant) {
        const uint8_t types[4] = {0x0c, 0x0c, 0x61, 0x0c};
        const uint8_t *test_bodies[4] = {good, good, good, good};
        size_t test_lengths[4] = {sizeof(good), sizeof(good), 4, sizeof(good)};
        uint8_t *data;
        size_t length;
        if (variant == 1) { test_bodies[0] = shortbody; test_lengths[0] = sizeof(shortbody); }
        if (variant == 2) { test_bodies[1] = countbody; test_lengths[1] = sizeof(countbody); }
        if (variant == 3) { test_lengths[3] = sizeof(good) - 1u; }
        data = build_scene(types, test_bodies, test_lengths, 4, &length);
        for (offset = 0; offset < (variant >= 4 ? length : 1u); ++offset) {
            size_t scene_length = length - (variant == 5 ? offset : 0u);
            uint8_t *scene_copy = (uint8_t *)malloc(scene_length ? scene_length : 1u);
            SceneResource *scene;
            char error[128];
            SessionA0cHost host;
            SessionA0cBinding *binding;
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
            binding = session_a0c_create(&host);
            assert(binding != NULL);
            if (scene == NULL) {
                ++stats.scenes_rejected_by_parser;
            } else {
                int status = session_a0c_begin_scene(binding, scene);
                ++stats.scenes_opened;
                if (status == ACTION17_OK) ++stats.begin_ok; else ++stats.begin_rejected;
                for (row = 0; row < scene_resource_action_count(scene) + 2u; ++row) {
                    SceneActionInfo info;
                    SceneActionRuntimeState before = {0u, 0u};
                    SceneActionHandlerResult out = {0, 0u};
                    SessionInputHotspot spot;
                    Action17Cursor cursor;
                    Action17Slot slot;
                    SessionA0cRowInfo row_info;
                    size_t body_length;
                    uint32_t phase;
                    memset(&info, 0, sizeof(info));
                    if (row < scene_resource_action_count(scene)) {
                        (void)scene_resource_action_at(scene, row, &info);
                    }
                    for (phase = 0; phase < 4u; ++phase) {
                        int handled;
                        before.phase = phase;
                        session_a0c_pre_gate(binding, row, &info, &before);
                        ++stats.pre_gates;
                        handled = session_a0c_handler(binding, row, &info, &before, &out);
                        assert(handled == SCENE_ACTION_HANDLER_OK || handled == SCENE_ACTION_HANDLER_ERROR ||
                               handled == SCENE_ACTION_HANDLER_UNSUPPORTED);
                        if (handled == SCENE_ACTION_HANDLER_OK) ++stats.handler_ok;
                        else if (handled == SCENE_ACTION_HANDLER_ERROR) ++stats.handler_error;
                        else ++stats.handler_unsupported;
                        ++stats.handler_calls;
                        if (session_a0c_pointer_row(binding, row, &spot) == 1) ++stats.pointer_rows;
                    }
                    if (session_a0c_hover_cursor(binding, row, 5, &cursor) == ACTION17_OK) ++stats.hovers;
                    (void)session_a0c_slot(binding, row, &slot);
                    (void)session_a0c_row_info(binding, row, &row_info);
                    (void)session_a0c_body(binding, row, &body_length);
                    (void)session_a0c_body(binding, row, NULL);
                }
                (void)session_a0c_failure(binding);
                scene_resource_close(scene);
            }
            stats.transitions += probe.transitions;
            session_a0c_destroy(binding);
            free(scene_copy);
            if (variant >= 4 && offset > 1500u) break;
        }
        free(data);
    }
    assert(session_a0c_create(NULL) == NULL);
    assert(session_a0c_begin_scene(NULL, NULL) != ACTION17_OK);
    assert(strcmp(session_a0c_failure(NULL), "invalid binding") == 0);
    assert(session_a0c_row_count(NULL) == 0u);
    assert(session_a0c_pointer_row(NULL, 0, NULL) == 0);
    assert(session_a0c_body(NULL, 0, NULL) == NULL);
    session_a0c_destroy(NULL);
    return stats;
}

int main(void)
{
    KernelStats kernel = kernel_sweep();
    BindingStats stats = binding_sweep();
    assert(kernel.accepted > 0 && kernel.rejected > 0 && kernel.requested > 0 && kernel.finished > 0);
    assert(stats.scenes_opened > 0 && stats.begin_ok > 0 && stats.handler_ok > 0 &&
           stats.handler_error > 0 && stats.pointer_rows > 0 && stats.transitions > 0);
    printf("validations=%llu accepted=%llu rejected=%llu steps=%llu requested=%llu finished=%llu "
           "kernel_hovers=%llu binding_scenes_opened=%llu scenes_rejected_by_parser=%llu begin_ok=%llu "
           "begin_rejected=%llu handler_calls=%llu handler_ok=%llu handler_error=%llu "
           "handler_unsupported=%llu pre_gates=%llu pointer_rows=%llu hovers=%llu transitions=%llu\n",
           (unsigned long long)kernel.validations, (unsigned long long)kernel.accepted,
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
