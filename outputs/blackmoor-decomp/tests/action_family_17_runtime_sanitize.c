/* RT-15 ASan/UBSan driver: bounded malformed inputs for the raw 0x16..0x19
 * kernel and its session binding. Every body is an exact-size heap allocation
 * so any out-of-bounds access is reported. Exit 0 means every loop completed. */
#include "session_bindings_a17.h"

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

typedef struct { uint64_t calls, accepted, rejected, hits, finished; } KernelStats;

static void kernel_one(const uint8_t *source, size_t declared_length, size_t allocated_length,
                       uint32_t phase, int16_t selector, uint32_t *seed, KernelStats *stats)
{
    uint8_t *body = (uint8_t *)malloc(allocated_length ? allocated_length : 1u);
    Action17Slot slot, slot_before;
    Action17World world, world_before;
    Action17Result result;
    Action17Host host;
    uint64_t effects = 0;
    const char *why = NULL;
    int status;
    assert(body != NULL);
    memcpy(body, source, allocated_length);
    memset(&slot, 0x5a, sizeof(slot));
    memset(&world, 0xa5, sizeof(world));
    world.selector = selector;
    slot_before = slot;
    world_before = world;
    host.context = &effects;
    host.observe = (lcg(seed) & 3u) ? kernel_observe : NULL;
    if (host.observe == NULL) host.context = NULL;
    status = action17_step(body, declared_length > allocated_length ? allocated_length : declared_length,
                           phase, &slot, &world, lcg(seed) % 5u ? &host : NULL, &result, &why);
    ++stats->calls;
    assert(why != NULL);
    assert(status == ACTION17_OK || status == ACTION17_ERR_BOUNDS);
    if (status == ACTION17_ERR_BOUNDS) {
        ++stats->rejected;
        assert(memcmp(&slot, &slot_before, sizeof(slot)) == 0);
        assert(memcmp(&world, &world_before, sizeof(world)) == 0);
        assert(effects == 0u);
    } else {
        ++stats->accepted;
        if (result.requested && result.matched_record >= 0) ++stats->hits;
        if (result.finished) { ++stats->finished; assert(world.mode_583999 == 4 && slot.done == 1u); }
        assert(result.phase_after == (phase == 0u ? 1u : phase));
    }
    free(body);
}

static KernelStats kernel_sweep(void)
{
    KernelStats stats;
    uint32_t seed = 0x15u;
    uint32_t count_word;
    static const uint32_t phases[] = {0u, 1u, 2u, 3u, 7u, 0xffffffffu};
    memset(&stats, 0, sizeof(stats));
    /* Every encoding of the count word against a short body, then the exact
     * body for each count whose declared size fits a bounded buffer. */
    for (count_word = 0; count_word <= 0xffffu; ++count_word) {
        uint8_t proto[22 + 18 * 3 + 2];
        size_t index;
        memset(proto, 0, sizeof(proto));
        put_le16(proto, 6402u);
        put_le16(proto + 20, (uint16_t)count_word);
        for (index = 0; index < 3u; ++index) {
            put_le16(proto + 22 + 18 * index, (uint16_t)(index + 2u));
            put_le32(proto + 24 + 18 * index, 7u + (uint32_t)index);
            put_le32(proto + 28 + 18 * index, 9u);
            put_le32(proto + 32 + 18 * index, 11u);
            put_le32(proto + 36 + 18 * index, 13u);
        }
        kernel_one(proto, sizeof(proto), sizeof(proto), phases[count_word % 6u],
                   (int16_t)(count_word % 5u + 2u), &seed, &stats);
        if (count_word <= 1819u) {
            size_t exact = 22u + 18u * count_word;
            uint8_t *full = (uint8_t *)calloc(exact, 1u);
            size_t phase_index;
            assert(full != NULL);
            put_le16(full, 6402u);
            put_le16(full + 20, (uint16_t)count_word);
            for (index = 0; index < count_word; ++index) {
                put_le16(full + 22 + 18 * index, (uint16_t)(index % 9u));
                put_le32(full + 24 + 18 * index, (uint32_t)index);
            }
            for (phase_index = 0; phase_index < 6u; ++phase_index) {
                kernel_one(full, exact, exact, phases[phase_index], (int16_t)(count_word % 9u), &seed, &stats);
                /* one byte short and one byte long both change the count/length relation */
                if (exact > 22u) kernel_one(full, exact - 1u, exact, phases[phase_index], 3, &seed, &stats);
                kernel_one(full, exact, exact, phases[phase_index], 99, &seed, &stats);
            }
            free(full);
        }
    }
    /* Every length around a small valid body. */
    {
        uint8_t valid[22 + 18 * 2];
        size_t length;
        memset(valid, 0, sizeof(valid));
        put_le16(valid + 20, 2u);
        put_le16(valid + 22, 4u);
        put_le16(valid + 40, 5u);
        for (length = 0; length <= sizeof(valid) + 3u; ++length) {
            size_t phase_index;
            for (phase_index = 0; phase_index < 6u; ++phase_index) {
                uint8_t *copy = (uint8_t *)malloc(length ? length : 1u);
                Action17Slot slot;
                Action17World world;
                Action17Result result;
                const char *why = NULL;
                int status;
                assert(copy != NULL);
                memcpy(copy, valid, length < sizeof(valid) ? length : sizeof(valid));
                memset(&slot, 0, sizeof(slot));
                memset(&world, 0, sizeof(world));
                world.selector = 4;
                status = action17_step(copy, length, phases[phase_index], &slot, &world, NULL, &result, &why);
                ++stats.calls;
                assert((status == ACTION17_OK) == (length == sizeof(valid)));
                free(copy);
            }
        }
    }
    {
        Action17Slot slot; Action17World world; Action17Result result; const char *why = NULL;
        uint8_t body[22] = {0};
        assert(action17_step(NULL, 22, 0, &slot, &world, NULL, &result, &why) != ACTION17_OK);
        assert(action17_step(body, 22, 0, NULL, &world, NULL, &result, &why) == ACTION17_ERR_ARGUMENT);
        assert(action17_step(body, 22, 0, &slot, NULL, NULL, &result, &why) == ACTION17_ERR_ARGUMENT);
        assert(action17_step(body, 22, 0, &slot, &world, NULL, NULL, &why) == ACTION17_ERR_ARGUMENT);
        assert(action17_step(body, 22, 0, &slot, &world, NULL, &result, NULL) == ACTION17_OK);
    }
    return stats;
}

static void cursor_sweep(void)
{
    unsigned type;
    int held;
    Action17Cursor cursor;
    assert(action17_hover_cursor(0x17, -1, NULL) == ACTION17_ERR_ARGUMENT);
    for (type = 0; type < 256u; ++type) {
        (void)action17_cursor_index_for_type((uint8_t)type);
        for (held = -3; held <= 70; held += 1) {
            int status = action17_hover_cursor((uint8_t)type, (int16_t)held, &cursor);
            assert((status == ACTION17_OK) == (type >= 0x16u && type <= 0x19u));
        }
        (void)action17_hover_cursor((uint8_t)type, INT16_MIN, &cursor);
        (void)action17_hover_cursor((uint8_t)type, INT16_MAX, &cursor);
    }
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
    uint8_t good[22 + 18 * 3];
    uint8_t shortbody[10];
    uint8_t wrap[22];
    BindingStats stats;
    size_t variant, offset;
    memset(&stats, 0, sizeof(stats));
    memset(good, 0, sizeof(good));
    put_le16(good, 6402u); put_le16(good + 20, 3u);
    put_le16(good + 22, 4u); put_le32(good + 24, 5u); put_le32(good + 28, 6u);
    put_le32(good + 32, 7u); put_le32(good + 36, 8u);
    put_le16(good + 40, 5u); put_le16(good + 58, 4u);
    memset(shortbody, 0, sizeof(shortbody));
    memset(wrap, 0, sizeof(wrap));
    put_le16(wrap + 20, 0xffffu);
    for (variant = 0; variant < 6; ++variant) {
        const uint8_t types[4] = {0x17, 0x16, 0x61, 0x17};
        const uint8_t *test_bodies[4] = {good, good, good, good};
        size_t test_lengths[4] = {sizeof(good), sizeof(good), 4, sizeof(good)};
        uint8_t *data;
        size_t length;
        if (variant == 1) { test_bodies[0] = shortbody; test_lengths[0] = sizeof(shortbody); }
        if (variant == 2) { test_bodies[1] = wrap; test_lengths[1] = sizeof(wrap); }
        if (variant == 3) { test_lengths[3] = sizeof(good) - 1u; }
        data = build_scene(types, test_bodies, test_lengths, 4, &length);
        for (offset = 0; offset < (variant >= 4 ? length : 1u); ++offset) {
            size_t scene_length = length - (variant == 5 ? offset : 0u);
            uint8_t *scene_copy = (uint8_t *)malloc(scene_length ? scene_length : 1u);
            SceneResource *scene;
            char error[128];
            SessionA17Host host;
            SessionA17Binding *binding;
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
            binding = session_a17_create(&host);
            assert(binding != NULL);
            if (scene == NULL) {
                ++stats.scenes_rejected_by_parser;
            } else {
                int status = session_a17_begin_scene(binding, scene);
                ++stats.scenes_opened;
                if (status == ACTION17_OK) ++stats.begin_ok; else ++stats.begin_rejected;
                for (row = 0; row < scene_resource_action_count(scene) + 2u; ++row) {
                    SceneActionInfo info;
                    SceneActionRuntimeState before = {0u, 0u};
                    SceneActionHandlerResult out = {0, 0u};
                    SessionInputHotspot spot;
                    Action17Cursor cursor;
                    Action17Slot slot;
                    uint32_t phase;
                    memset(&info, 0, sizeof(info));
                    if (row < scene_resource_action_count(scene)) {
                        (void)scene_resource_action_at(scene, row, &info);
                    }
                    for (phase = 0; phase < 4u; ++phase) {
                        int handled;
                        before.phase = phase;
                        session_a17_pre_gate(binding, row, &info, &before);
                        ++stats.pre_gates;
                        handled = session_a17_handler(binding, row, &info, &before, &out);
                        assert(handled == SCENE_ACTION_HANDLER_OK || handled == SCENE_ACTION_HANDLER_ERROR ||
                               handled == SCENE_ACTION_HANDLER_UNSUPPORTED);
                        if (handled == SCENE_ACTION_HANDLER_OK) ++stats.handler_ok;
                        else if (handled == SCENE_ACTION_HANDLER_ERROR) ++stats.handler_error;
                        else ++stats.handler_unsupported;
                        ++stats.handler_calls;
                        if (session_a17_pointer_row(binding, row, &spot) == 1) ++stats.pointer_rows;
                    }
                    if (session_a17_hover_cursor(binding, row, 5, &cursor) == ACTION17_OK) ++stats.hovers;
                    (void)session_a17_slot(binding, row, &slot);
                }
                (void)session_a17_failure(binding);
                scene_resource_close(scene);
            }
            stats.transitions += probe.transitions;
            session_a17_destroy(binding);
            free(scene_copy);
            if (variant >= 4 && offset > 1500u) break;
        }
        free(data);
    }
    assert(session_a17_create(NULL) == NULL);
    assert(session_a17_begin_scene(NULL, NULL) != ACTION17_OK);
    assert(strcmp(session_a17_failure(NULL), "invalid binding") == 0);
    assert(session_a17_row_count(NULL) == 0u);
    assert(session_a17_pointer_row(NULL, 0, NULL) == 0);
    session_a17_destroy(NULL);
    return stats;
}

int main(void)
{
    KernelStats kernel = kernel_sweep();
    BindingStats stats;
    cursor_sweep();
    stats = binding_sweep();
    assert(kernel.accepted > 0 && kernel.rejected > 0 && kernel.hits > 0 && kernel.finished > 0);
    assert(stats.scenes_opened > 0 && stats.begin_ok > 0 && stats.handler_ok > 0 &&
           stats.handler_error > 0 && stats.pointer_rows > 0 && stats.transitions > 0);
    printf("kernel_calls=%llu kernel_accepted=%llu kernel_rejected=%llu kernel_hits=%llu "
           "kernel_finished=%llu binding_scenes_opened=%llu scenes_rejected_by_parser=%llu begin_ok=%llu "
           "begin_rejected=%llu handler_calls=%llu handler_ok=%llu handler_error=%llu "
           "handler_unsupported=%llu pre_gates=%llu pointer_rows=%llu hovers=%llu transitions=%llu\n",
           (unsigned long long)kernel.calls, (unsigned long long)kernel.accepted,
           (unsigned long long)kernel.rejected, (unsigned long long)kernel.hits,
           (unsigned long long)kernel.finished, (unsigned long long)stats.scenes_opened,
           (unsigned long long)stats.scenes_rejected_by_parser, (unsigned long long)stats.begin_ok,
           (unsigned long long)stats.begin_rejected, (unsigned long long)stats.handler_calls,
           (unsigned long long)stats.handler_ok, (unsigned long long)stats.handler_error,
           (unsigned long long)stats.handler_unsupported, (unsigned long long)stats.pre_gates,
           (unsigned long long)stats.pointer_rows, (unsigned long long)stats.hovers,
           (unsigned long long)stats.transitions);
    return 0;
}
