/* RT-13 ASan/UBSan driver: bounded malformed inputs for the raw 0x79 kernel and
 * its session binding. Every array is an exact-size heap allocation so any
 * out-of-bounds access is reported. Exit 0 means every loop completed. */
#include "session_bindings_a79.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    int rebuild_calls;
    int rebuild_result;
    int observed;
} Probe;

static int rebuild(void *context, int16_t removed)
{
    Probe *probe = (Probe *)context;
    (void)removed;
    ++probe->rebuild_calls;
    return probe->rebuild_result;
}

static void observe(void *context, int effect, int32_t value)
{
    Probe *probe = (Probe *)context;
    (void)value;
    assert(effect >= ACTION79_EFFECT_VISIT && effect <= ACTION79_EFFECT_COMPLETE);
    ++probe->observed;
}

static uint32_t lcg(uint32_t *state)
{
    *state = *state * 1664525u + 1013904223u;
    return *state >> 8;
}

static void kernel_sweep(size_t item_capacity, size_t presence_capacity, uint64_t *visits,
                         uint64_t *rejections)
{
    static const int16_t counts[] = {-32768, -300, -1, 0, 1, 2, 3, 69, 70, 71, 72, 1000, 32767};
    uint32_t seed = (uint32_t)(item_capacity * 977u + presence_capacity);
    size_t c;
    for (c = 0; c < sizeof(counts) / sizeof(counts[0]); ++c) {
        uint32_t word;
        for (word = 0; word <= 0xffffu; word += (word < 300u ? 1u : 13u)) {
            int16_t *held = (int16_t *)malloc(sizeof(*held));
            int16_t *count = (int16_t *)malloc(sizeof(*count));
            uint16_t *items = (uint16_t *)malloc((item_capacity ? item_capacity : 1u) * sizeof(*items));
            int32_t *presence = (int32_t *)malloc((presence_capacity ? presence_capacity : 1u) * sizeof(*presence));
            uint16_t *before_items = (uint16_t *)malloc((item_capacity ? item_capacity : 1u) * sizeof(*items));
            int32_t *before_presence = (int32_t *)malloc((presence_capacity ? presence_capacity : 1u) * sizeof(*presence));
            Probe probe = {0, (int)(lcg(&seed) % 3u) == 0 ? 1 : 0, 0};
            Action79Model model;
            Action79Host host;
            Action79Result result;
            const char *why = NULL;
            size_t i;
            int status;
            assert(held && count && items && presence && before_items && before_presence);
            for (i = 0; i < item_capacity; ++i) {
                items[i] = (uint16_t)(lcg(&seed) % 4u == 0 ? word : lcg(&seed) % 80u);
            }
            for (i = 0; i < presence_capacity; ++i) {
                presence[i] = (int32_t)lcg(&seed);
            }
            *count = counts[c];
            *held = (int16_t)(lcg(&seed) % 2u ? (int16_t)word : -1);
            memcpy(before_items, items, item_capacity * sizeof(*items));
            memcpy(before_presence, presence, presence_capacity * sizeof(*presence));
            model.held_item = held; model.item_count = count;
            model.items = items; model.item_capacity = item_capacity;
            model.presence = presence; model.presence_capacity = presence_capacity;
            host.context = &probe;
            host.rebuild_view = (visits[0] % 11u == 5u) ? NULL : rebuild;
            host.observe = (visits[0] % 3u == 0u) ? observe : NULL;
            status = action79_visit((uint16_t)word, &model, &host, &result, &why);
            ++visits[0];
            assert(why != NULL);
            assert(status == ACTION79_OK || status == ACTION79_ERR_BOUNDS ||
                   status == ACTION79_ERR_UNSUPPORTED || status == ACTION79_ERR_HOST);
            if (status == ACTION79_ERR_BOUNDS || status == ACTION79_ERR_UNSUPPORTED) {
                ++rejections[0];
                assert(memcmp(before_items, items, item_capacity * sizeof(*items)) == 0);
                assert(memcmp(before_presence, presence, presence_capacity * sizeof(*presence)) == 0);
                assert(result.completed == 0u && probe.rebuild_calls == 0);
            } else {
                assert((status == ACTION79_OK) == (result.completed == 1u));
                assert(*count >= -32768 && (size_t)(*count > 0 ? *count : 0) <= item_capacity);
            }
            free(held); free(count); free(items); free(presence);
            free(before_items); free(before_presence);
        }
    }
}

static void put_be32(uint8_t *p, uint32_t v)
{
    p[0] = (uint8_t)(v >> 24); p[1] = (uint8_t)(v >> 16); p[2] = (uint8_t)(v >> 8); p[3] = (uint8_t)v;
}

/* DATA/SCEN with a TSUM chunk and ACT chunks (type, subtype, body). */
static uint8_t *build_scene(const uint8_t *bodies[], const size_t lengths[], size_t rows,
                            size_t *out_length)
{
    size_t capacity = 8u + 4u + 8u + 126u + rows * (8u + 50u + 40u), used = 0, i;
    uint8_t *data = (uint8_t *)calloc(capacity, 1u);
    uint8_t tsum[126] = {0};
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
        chunk[8 + 48] = 0x79; chunk[8 + 49] = (uint8_t)(1u + i % 3u);
        memcpy(chunk + 8 + 50, bodies[i], lengths[i]);
        used += 8u + payload + (payload & 1u);
    }
    put_be32(data + 4, (uint32_t)(used - 8u));
    *out_length = used;
    return data;
}

typedef struct {
    uint64_t handler_calls, scenes_opened, scenes_rejected_by_parser, begin_ok,
        begin_rejected, handler_ok, handler_error, handler_unsupported;
} BindingStats;

static BindingStats binding_sweep(void)
{
    static const uint8_t two[2] = {23, 0}, wrap[2] = {0xff, 0xff};
    uint8_t eighteen[18] = {4, 0};
    uint8_t one[1] = {1}, three[3] = {1, 2, 3}, seventeen[17] = {5};
    BindingStats stats;
    size_t variant;
    memset(&stats, 0, sizeof(stats));
    for (variant = 0; variant < 7; ++variant) {
        const uint8_t *test_bodies[4] = {two, wrap, eighteen, two};
        size_t test_lengths[4] = {2, 2, 18, 2};
        uint8_t *data;
        size_t length, offset;
        int16_t held = 23, count = 3;
        uint16_t items[70] = {4, 23, 9};
        int32_t presence[70] = {0};
        SessionA79Host host;
        SessionA79Binding *binding;
        Probe probe = {0, 0, 0};
        if (variant == 1) { test_bodies[0] = one; test_lengths[0] = 1; }
        if (variant == 2) { test_bodies[0] = three; test_lengths[0] = 3; }
        if (variant == 3) { test_bodies[2] = seventeen; test_lengths[2] = 17; }
        if (variant == 4) { test_lengths[0] = 0; }
        data = build_scene(test_bodies, test_lengths, 4, &length);
        for (offset = 0; offset < (variant >= 5 ? length : 1u); ++offset) {
            uint8_t *scene_copy = (uint8_t *)malloc(length - (variant == 6 ? offset : 0u));
            SceneResource *scene;
            char error[128];
            size_t row, scene_length = length - (variant == 6 ? offset : 0u);
            assert(scene_copy != NULL);
            memcpy(scene_copy, data, scene_length);
            if (variant == 5) scene_copy[offset] ^= 0x5au;
            scene = scene_resource_open_memory(scene_copy, scene_length, error, sizeof(error));
            memset(&host, 0, sizeof(host));
            host.model.held_item = &held; host.model.item_count = &count;
            host.model.items = items; host.model.item_capacity = 70u;
            host.model.presence = presence; host.model.presence_capacity = 70u;
            host.view.context = &probe; host.view.rebuild_view = rebuild;
            binding = session_a79_create(&host);
            assert(binding != NULL);
            if (scene == NULL) {
                ++stats.scenes_rejected_by_parser;
            } else {
                int status = session_a79_begin_scene(binding, scene);
                ++stats.scenes_opened;
                if (status == ACTION79_OK) { ++stats.begin_ok; } else { ++stats.begin_rejected; }
                for (row = 0; row < scene_resource_action_count(scene) + 2u; ++row) {
                    SceneActionInfo info;
                    SceneActionRuntimeState before = {0u, 0u};
                    SceneActionHandlerResult out = {0, 0u};
                    int handled;
                    memset(&info, 0, sizeof(info));
                    if (row < scene_resource_action_count(scene)) {
                        (void)scene_resource_action_at(scene, row, &info);
                    }
                    handled = session_a79_handler(binding, row, &info, &before, &out);
                    assert(handled == SCENE_ACTION_HANDLER_OK || handled == SCENE_ACTION_HANDLER_ERROR ||
                           handled == SCENE_ACTION_HANDLER_UNSUPPORTED);
                    if (handled == SCENE_ACTION_HANDLER_OK) ++stats.handler_ok;
                    else if (handled == SCENE_ACTION_HANDLER_ERROR) ++stats.handler_error;
                    else ++stats.handler_unsupported;
                    (void)session_a79_item_word(binding, row);
                    ++stats.handler_calls;
                }
                (void)session_a79_failure(binding);
                scene_resource_close(scene);
            }
            session_a79_destroy(binding);
            free(scene_copy);
            if (variant < 5) break;
            if (variant == 5 && offset > 1500u) break;
        }
        free(data);
    }
    assert(session_a79_create(NULL) == NULL);
    assert(session_a79_begin_scene(NULL, NULL) != ACTION79_OK);
    assert(session_a79_item_word(NULL, 0) == -1);
    assert(strcmp(session_a79_failure(NULL), "invalid binding") == 0);
    session_a79_destroy(NULL);
    return stats;
}

int main(void)
{
    uint64_t visits[1] = {0}, rejections[1] = {0};
    BindingStats stats;
    static const size_t item_caps[] = {0, 1, 2, 3, 70};
    static const size_t presence_caps[] = {0, 1, 2, 70};
    size_t a, b;
    Action79Result result;
    const char *why;
    Action79Model model;
    memset(&model, 0, sizeof(model));
    assert(action79_visit(1, NULL, NULL, &result, &why) == ACTION79_ERR_ARGUMENT);
    assert(action79_visit(1, &model, NULL, NULL, &why) == ACTION79_ERR_ARGUMENT);
    assert(action79_visit(1, &model, NULL, &result, NULL) == ACTION79_ERR_ARGUMENT);
    for (a = 0; a < sizeof(item_caps) / sizeof(item_caps[0]); ++a) {
        for (b = 0; b < sizeof(presence_caps) / sizeof(presence_caps[0]); ++b) {
            kernel_sweep(item_caps[a], presence_caps[b], visits, rejections);
        }
    }
    stats = binding_sweep();
    assert(stats.scenes_opened > 0 && stats.begin_ok > 0 && stats.scenes_rejected_by_parser > 0 &&
           stats.handler_ok > 0 && stats.handler_error > 0);
    printf("kernel_visits=%llu kernel_rejections=%llu binding_scenes_opened=%llu "
           "scenes_rejected_by_parser=%llu begin_ok=%llu begin_rejected=%llu "
           "handler_calls=%llu handler_ok=%llu handler_error=%llu handler_unsupported=%llu\n",
           (unsigned long long)visits[0], (unsigned long long)rejections[0],
           (unsigned long long)stats.scenes_opened, (unsigned long long)stats.scenes_rejected_by_parser,
           (unsigned long long)stats.begin_ok, (unsigned long long)stats.begin_rejected,
           (unsigned long long)stats.handler_calls, (unsigned long long)stats.handler_ok,
           (unsigned long long)stats.handler_error, (unsigned long long)stats.handler_unsupported);
    return 0;
}
