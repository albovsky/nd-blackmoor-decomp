/* RT-19 ASan/UBSan driver: bounded malformed inputs for the raw 0x78 kernel and its
 * session binding. Every array is an exact-size heap allocation so any out-of-bounds
 * access is reported. Exit 0 means every loop completed and every rejection left the
 * model and the providers untouched. */
#include "session_bindings_a78.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    int rebuild_calls, sound_calls, ui_calls;
    int rebuild_result, sound_result, ui_result;
    int observed;
} Probe;

static int rebuild(void *context, int16_t item)
{
    Probe *probe = (Probe *)context;
    (void)item;
    ++probe->rebuild_calls;
    return probe->rebuild_result;
}

static int sound(void *context, uint16_t slot)
{
    Probe *probe = (Probe *)context;
    assert(slot == ACTION78_SOUND_SLOT);
    ++probe->sound_calls;
    return probe->sound_result;
}

static int ui(void *context, int16_t index, int32_t enable, int16_t sub)
{
    Probe *probe = (Probe *)context;
    assert(index == 1 && enable == 1 && sub == 0);
    ++probe->ui_calls;
    return probe->ui_result;
}

static void observe(void *context, int effect, int32_t value)
{
    Probe *probe = (Probe *)context;
    (void)value;
    assert((effect >= ACTION79_EFFECT_VISIT && effect <= ACTION79_EFFECT_COMPLETE) ||
           (effect >= ACTION78_EFFECT_ENTER && effect <= ACTION78_EFFECT_HELD));
    ++probe->observed;
}

static uint32_t lcg(uint32_t *state)
{
    *state = *state * 1664525u + 1013904223u;
    return *state >> 8;
}

static void kernel_sweep(size_t item_capacity, size_t presence_capacity, uint64_t *visits,
                         uint64_t *rejections, uint64_t *completed)
{
    static const int16_t counts[] = {-32768, -300, -2, -1, 0, 1, 2, 3, 69, 70, 71, 72, 1000, 32767};
    static const uint16_t flags[][2] = {{0, 0}, {1, 1}, {1, 0}, {0, 1}, {0x100, 0x100}, {0xffff, 1}};
    static const int32_t modes[] = {0, 2, 3, -1};
    uint32_t seed = (uint32_t)(item_capacity * 977u + presence_capacity);
    size_t c, f, m;
    for (c = 0; c < sizeof(counts) / sizeof(counts[0]); ++c) {
        uint32_t word;
        for (word = 0; word <= 0xffffu; word += (word < 100u ? 1u : 0x1ffu)) {
            for (f = 0; f < sizeof(flags) / sizeof(flags[0]); ++f) {
                for (m = 0; m < sizeof(modes) / sizeof(modes[0]); ++m) {
                    int16_t *held = (int16_t *)malloc(sizeof(*held));
                    int16_t *count = (int16_t *)malloc(sizeof(*count));
                    uint16_t *items = (uint16_t *)malloc((item_capacity ? item_capacity : 1u) * sizeof(*items));
                    int32_t *presence = (int32_t *)malloc((presence_capacity ? presence_capacity : 1u) * sizeof(*presence));
                    uint16_t *before_items = (uint16_t *)malloc((item_capacity ? item_capacity : 1u) * sizeof(*items));
                    int32_t *before_presence = (int32_t *)malloc((presence_capacity ? presence_capacity : 1u) * sizeof(*presence));
                    Probe probe;
                    Action78Model model;
                    Action78Host host;
                    Action78Object object;
                    Action78Result result;
                    const char *why = NULL;
                    size_t i;
                    int status;
                    int16_t held_before, count_before;
                    assert(held && count && items && presence && before_items && before_presence);
                    memset(&probe, 0, sizeof(probe));
                    probe.rebuild_result = (int)(lcg(&seed) % 9u) == 0 ? 1 : 0;
                    probe.sound_result = (int)(lcg(&seed) % 13u) == 0 ? 1 : 0;
                    probe.ui_result = (int)(lcg(&seed) % 17u) == 0 ? 1 : 0;
                    for (i = 0; i < item_capacity; ++i) {
                        items[i] = (uint16_t)(lcg(&seed) % 4u == 0 ? word : lcg(&seed) % 80u);
                    }
                    for (i = 0; i < presence_capacity; ++i) {
                        presence[i] = (int32_t)lcg(&seed);
                    }
                    *count = counts[c];
                    *held = (int16_t)(lcg(&seed) % 3u == 0 ? (int16_t)word
                                      : lcg(&seed) % 2u ? -1 : (int16_t)(lcg(&seed) % 80u));
                    held_before = *held;
                    count_before = *count;
                    memcpy(before_items, items, item_capacity * sizeof(*items));
                    memcpy(before_presence, presence, presence_capacity * sizeof(*presence));
                    memset(&model, 0, sizeof(model));
                    model.inventory.held_item = held; model.inventory.item_count = count;
                    model.inventory.items = items; model.inventory.item_capacity = item_capacity;
                    model.inventory.presence = presence; model.inventory.presence_capacity = presence_capacity;
                    model.view.mode = modes[m];
                    model.view.slot_flag = (uint8_t)(lcg(&seed) % 2u);
                    memset(&host, 0, sizeof(host));
                    host.inventory.context = &probe;
                    host.context = &probe;
                    host.inventory.rebuild_view = (visits[0] % 11u == 5u) ? NULL : rebuild;
                    host.inventory.observe = (visits[0] % 3u == 0u) ? observe : NULL;
                    host.request_sound = (visits[0] % 7u == 3u) ? NULL : sound;
                    host.request_ui_animation = (visits[0] % 5u == 1u) ? NULL : ui;
                    object.item_word = (uint16_t)word;
                    object.take_flag = flags[f][0];
                    object.swap_flag = flags[f][1];
                    status = action78_visit(&object, &model, visits[0] % 97u == 0u ? NULL : &host,
                                            &result, &why);
                    ++visits[0];
                    assert(why != NULL);
                    assert(status == ACTION78_OK || status == ACTION78_ERR_BOUNDS ||
                           status == ACTION78_ERR_UNSUPPORTED || status == ACTION78_ERR_HOST);
                    if (status == ACTION78_ERR_BOUNDS || status == ACTION78_ERR_UNSUPPORTED) {
                        ++rejections[0];
                        assert(memcmp(before_items, items, item_capacity * sizeof(*items)) == 0);
                        assert(memcmp(before_presence, presence, presence_capacity * sizeof(*presence)) == 0);
                        assert(*held == held_before && *count == count_before);
                        assert(result.completed == 0u);
                        assert(probe.rebuild_calls == 0 && probe.sound_calls == 0 && probe.ui_calls == 0);
                    } else if (status == ACTION78_OK) {
                        ++completed[0];
                        assert(result.completed == 1u);
                        /* A visit that never touches the list leaves any count alone; one that
                         * does keeps it inside the array (new count >= -1 + 1). */
                        assert(*count == count_before ||
                               (*count >= -1 && (size_t)(*count > 0 ? *count : 0) <= item_capacity));
                        assert(result.added <= 2u && result.duplicates <= 2u && result.held_changed <= 2u);
                        assert(probe.sound_calls == result.sound_requests);
                        assert(probe.ui_calls == result.ui_requests);
                    } else {
                        assert(result.completed == 0u);
                    }
                    free(held); free(count); free(items); free(presence);
                    free(before_items); free(before_presence);
                }
            }
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
        chunk[8 + 48] = 0x78; chunk[8 + 49] = (uint8_t)(1u + i % 3u);
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
    static const uint8_t six[6] = {23, 0, 1, 0, 0, 0}, wrap[6] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
    uint8_t twentytwo[22] = {4, 0, 1, 0, 1, 0};
    uint8_t one[1] = {1}, five[5] = {1, 2, 3, 4, 5}, seven[7] = {5, 0, 0, 0, 0, 0, 9};
    uint8_t twentyone[21] = {5};
    BindingStats stats;
    size_t variant;
    memset(&stats, 0, sizeof(stats));
    for (variant = 0; variant < 7; ++variant) {
        const uint8_t *test_bodies[4] = {six, wrap, twentytwo, six};
        size_t test_lengths[4] = {6, 6, 22, 6};
        uint8_t *data;
        size_t length, offset;
        int16_t held = 23, count = 3;
        uint16_t items[70] = {4, 23, 9};
        int32_t presence[70] = {0};
        SessionA78Host host;
        SessionA78Binding *binding;
        Probe probe;
        memset(&probe, 0, sizeof(probe));
        if (variant == 1) { test_bodies[0] = one; test_lengths[0] = 1; }
        if (variant == 2) { test_bodies[0] = five; test_lengths[0] = 5; }
        if (variant == 3) { test_bodies[2] = twentyone; test_lengths[2] = 21; }
        if (variant == 4) { test_bodies[1] = seven; test_lengths[1] = 7; }
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
            host.model.inventory.held_item = &held; host.model.inventory.item_count = &count;
            host.model.inventory.items = items; host.model.inventory.item_capacity = 70u;
            host.model.inventory.presence = presence; host.model.inventory.presence_capacity = 70u;
            host.view.inventory.context = &probe; host.view.inventory.rebuild_view = rebuild;
            host.view.context = &probe; host.view.request_sound = sound;
            host.view.request_ui_animation = ui;
            binding = session_a78_create(&host);
            assert(binding != NULL);
            if (scene == NULL) {
                ++stats.scenes_rejected_by_parser;
            } else {
                int status = session_a78_begin_scene(binding, scene);
                ++stats.scenes_opened;
                if (status == ACTION78_OK) { ++stats.begin_ok; } else { ++stats.begin_rejected; }
                for (row = 0; row < scene_resource_action_count(scene) + 2u; ++row) {
                    SceneActionInfo info;
                    SceneActionRuntimeState before = {0u, 0u};
                    SceneActionHandlerResult out = {0, 0u};
                    Action78Object object;
                    int handled;
                    memset(&info, 0, sizeof(info));
                    if (row < scene_resource_action_count(scene)) {
                        (void)scene_resource_action_at(scene, row, &info);
                    }
                    handled = session_a78_handler(binding, row, &info, &before, &out);
                    assert(handled == SCENE_ACTION_HANDLER_OK || handled == SCENE_ACTION_HANDLER_ERROR ||
                           handled == SCENE_ACTION_HANDLER_UNSUPPORTED);
                    if (handled == SCENE_ACTION_HANDLER_OK) ++stats.handler_ok;
                    else if (handled == SCENE_ACTION_HANDLER_ERROR) ++stats.handler_error;
                    else ++stats.handler_unsupported;
                    (void)session_a78_object(binding, row, &object);
                    ++stats.handler_calls;
                }
                (void)session_a78_failure(binding);
                (void)session_a78_last_result(binding);
                scene_resource_close(scene);
            }
            session_a78_destroy(binding);
            free(scene_copy);
            if (variant < 5) break;
            if (variant == 5 && offset > 1500u) break;
        }
        free(data);
    }
    assert(session_a78_create(NULL) == NULL);
    assert(session_a78_begin_scene(NULL, NULL) != ACTION78_OK);
    assert(session_a78_object(NULL, 0, NULL) == 0);
    assert(strcmp(session_a78_failure(NULL), "invalid binding") == 0);
    session_a78_destroy(NULL);
    return stats;
}

int main(void)
{
    uint64_t visits[1] = {0}, rejections[1] = {0}, completed[1] = {0};
    BindingStats stats;
    static const size_t item_caps[] = {0, 1, 2, 3, 70};
    static const size_t presence_caps[] = {0, 1, 2, 70};
    size_t a, b;
    Action78Result result;
    const char *why;
    Action78Model model;
    Action78Object object = {1, 0, 0}, parsed;
    uint8_t short_body[5] = {0};
    memset(&model, 0, sizeof(model));
    assert(action78_visit(NULL, &model, NULL, &result, &why) == ACTION78_ERR_ARGUMENT);
    assert(action78_visit(&object, NULL, NULL, &result, &why) == ACTION78_ERR_ARGUMENT);
    assert(action78_visit(&object, &model, NULL, NULL, &why) == ACTION78_ERR_ARGUMENT);
    assert(action78_visit(&object, &model, NULL, &result, NULL) == ACTION78_ERR_ARGUMENT);
    assert(action78_object_from_body(NULL, 6u, &parsed) == ACTION78_ERR_ARGUMENT);
    assert(action78_object_from_body(short_body, sizeof(short_body), &parsed) == ACTION78_ERR_ARGUMENT);
    assert(action78_object_from_body(short_body, 5u, NULL) == ACTION78_ERR_ARGUMENT);
    for (a = 0; a < sizeof(item_caps) / sizeof(item_caps[0]); ++a) {
        for (b = 0; b < sizeof(presence_caps) / sizeof(presence_caps[0]); ++b) {
            kernel_sweep(item_caps[a], presence_caps[b], visits, rejections, completed);
        }
    }
    stats = binding_sweep();
    assert(stats.scenes_opened > 0 && stats.begin_ok > 0 && stats.scenes_rejected_by_parser > 0 &&
           stats.handler_ok > 0 && stats.handler_error > 0);
    printf("kernel_visits=%llu kernel_rejections=%llu kernel_completed=%llu binding_scenes_opened=%llu "
           "scenes_rejected_by_parser=%llu begin_ok=%llu begin_rejected=%llu "
           "handler_calls=%llu handler_ok=%llu handler_error=%llu handler_unsupported=%llu\n",
           (unsigned long long)visits[0], (unsigned long long)rejections[0],
           (unsigned long long)completed[0],
           (unsigned long long)stats.scenes_opened, (unsigned long long)stats.scenes_rejected_by_parser,
           (unsigned long long)stats.begin_ok, (unsigned long long)stats.begin_rejected,
           (unsigned long long)stats.handler_calls, (unsigned long long)stats.handler_ok,
           (unsigned long long)stats.handler_error, (unsigned long long)stats.handler_unsupported);
    return 0;
}
