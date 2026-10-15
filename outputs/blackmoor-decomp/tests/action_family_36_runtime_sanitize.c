/* RT-14 ASan/UBSan driver: bounded malformed inputs for the COverlay kernel and
 * its session binding. Every image, event array and row table is an exact-size
 * heap allocation so any out-of-bounds access is reported. A rejection
 * (anything but OK / HOST) must leave manager, world, events and images
 * byte-identical. Exit 0 means every loop completed. */
#include "session_bindings_a36.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static uint32_t lcg(uint32_t *state)
{
    *state = *state * 1664525u + 1013904223u;
    return *state >> 8;
}

typedef struct {
    uint32_t seed;
    int fail_load, fail_tick;
    uint64_t calls;
} Probe;

static int p_load(void *c, const char *name, uint32_t *surface)
{
    Probe *p = (Probe *)c;
    ++p->calls;
    assert(name != NULL && memchr(name, 0, OVERLAY36_NAME_BYTES) != NULL);
    *surface = 1u + (lcg(&p->seed) & 0xffu);
    return p->fail_load;
}
static int p_sound_start(void *c, const uint8_t *r, uint16_t w) { (void)w; ((Probe *)c)->calls++; return r == NULL; }
static int p_sound_playing(void *c, uint16_t w, int *playing) { (void)w; *playing = (int)(lcg(&((Probe *)c)->seed) & 1u); return 0; }
static int p_sound_stop(void *c, const uint8_t *r) { ((Probe *)c)->calls++; return r == NULL; }
static int p_tick(void *c, uint32_t *t) { Probe *p = (Probe *)c; *t = lcg(&p->seed) * 977u; return p->fail_tick; }
static int p_phase(void *c, int32_t row, uint32_t *phase) { (void)row; *phase = lcg(&((Probe *)c)->seed) % 4u; return 0; }
static int p_blit(void *c, const Overlay36Blit *op) { ((Probe *)c)->calls++; return op == NULL || op->label == NULL; }
static void p_observe(void *c, int effect, int32_t a, int32_t b) { (void)c; (void)a; (void)b; assert(effect >= OV36_FX_BEGIN && effect <= OV36_FX_BLIT); }

static void fill_image(uint8_t *image, uint32_t *seed, int structured)
{
    size_t i;
    for (i = 0; i < OVERLAY36_IMAGE_BYTES; ++i) image[i] = (uint8_t)lcg(seed);
    if (structured) {
        static const int16_t small[] = {-1, 0, 1, 2, 3, 5, 25, 26, 100, 255, 32767, -32768};
        static const size_t words[] = {OV36_FLAG_21, OV36_PLAIN_23, OV36_ACTION_25, OV36_LAYER, OV36_MARKER,
            OV36_DIRECTION, OV36_LOOP, OV36_FRAME_INIT, OV36_FRAME_FIRST, OV36_FRAME_LAST, OV36_FPS,
            OV36_EVENT_INDEX, OV36_EVENT_VALUE, OV36_SECONDARY_COUNT, OV36_RT_ROW, OV36_RT_FRAME,
            OV36_RT_SLOT, OV36_RT_CACHE, OV36_SEC_PRIMARY + OV36_SECONDARY, OV36_SEC_HOT + OV36_SECONDARY,
            OV36_SEC_FRAME + OV36_SECONDARY};
        size_t k;
        for (k = 0; k < sizeof(words) / sizeof(words[0]); ++k) {
            if (lcg(seed) % 3u != 0u) {
                int16_t v = small[lcg(seed) % (sizeof(small) / sizeof(small[0]))];
                image[words[k]] = (uint8_t)v;
                image[words[k] + 1u] = (uint8_t)((uint16_t)v >> 8);
            }
        }
        if (lcg(seed) % 4u != 0u) {
            memcpy(image + OV36_NAME, "SAN_OVL", 8);
        }
        if (lcg(seed) % 2u == 0u) memcpy(image + OV36_SOUND, "NO SOUND", 9);
        if (lcg(seed) % 2u == 0u) { image[OV36_RT_ENABLED] = 1; image[OV36_RT_ENABLED + 1] = 0; image[OV36_RT_ENABLED + 2] = 0; image[OV36_RT_ENABLED + 3] = 0; }
    }
}

static uint64_t kernel_visits, kernel_rejections, hit_calls, hit_rejections, draw_calls, draw_rejections,
    hot_calls, hot_rejections, scan_calls, scan_rejections, scan_right_above_short;

typedef struct {
    Overlay36Manager manager;
    Overlay36World world;
} Snapshot;

static void kernel_sweep(uint32_t seed)
{
    size_t rows_n = 1u + lcg(&seed) % 4u;
    size_t events_n = lcg(&seed) % 3u == 0u ? 0u : (size_t)(1u + lcg(&seed) % 70u);
    uint8_t **images = (uint8_t **)malloc(rows_n * sizeof(*images));
    uint8_t **backup = (uint8_t **)malloc(rows_n * sizeof(*backup));
    int32_t *events = (int32_t *)malloc((events_n ? events_n : 1u) * sizeof(*events));
    int32_t *events_backup = (int32_t *)malloc((events_n ? events_n : 1u) * sizeof(*events));
    Overlay36Manager *manager = (Overlay36Manager *)malloc(sizeof(*manager));
    Overlay36World *world = (Overlay36World *)malloc(sizeof(*world));
    Probe probe = {seed ^ 0x5a5a, 0, 0, 0};
    Overlay36Host host;
    size_t r, i;
    int round;
    for (r = 0; r < rows_n; ++r) {
        images[r] = lcg(&seed) % 5u == 0u ? NULL : (uint8_t *)malloc(OVERLAY36_IMAGE_BYTES);
        backup[r] = (uint8_t *)malloc(OVERLAY36_IMAGE_BYTES);
        if (images[r] != NULL) fill_image(images[r], &seed, (int)(lcg(&seed) % 4u != 0u));
    }
    for (i = 0; i < events_n; ++i) events[i] = (int32_t)(lcg(&seed) % 7u) - 2;
    overlay36_manager_reset(manager);
    memset(world, 0, sizeof(*world));
    world->events = events;
    world->event_count = events_n;
    world->selector = (int16_t)(lcg(&seed) % 4u);
    world->held_item = (int16_t)((int)(lcg(&seed) % 5u) - 1);
    memset(&host, 0, sizeof(host));
    host.context = &probe;
    host.load_surface = p_load;
    host.sound_start = p_sound_start;
    host.sound_is_playing = p_sound_playing;
    host.sound_stop = p_sound_stop;
    host.tick_count = p_tick;
    host.row_phase = p_phase;
    host.blit = p_blit;
    host.observe = p_observe;
    if (lcg(&seed) % 11u == 0u) manager->count = (int32_t)(lcg(&seed) % 100u) - 20;
    if (lcg(&seed) % 11u == 0u) {
        for (i = 0; i < OVERLAY36_SLOTS; ++i) { manager->render[i].active = (int32_t)(lcg(&seed) & 1u); manager->render[i].row = (int32_t)(lcg(&seed) % 6u) - 1; manager->render[i].callback = 1; manager->render[i].visible = 1; manager->render[i].layer = (int32_t)(lcg(&seed) % 3u); memcpy(manager->render[i].tag, OVERLAY36_TAG, sizeof(OVERLAY36_TAG)); manager->render[i].surface = lcg(&seed) % 4u; }
        for (i = 0; i < OVERLAY36_CACHE_SLOTS; ++i) manager->cache[i] = lcg(&seed) % 4u;
    }
    for (round = 0; round < 40; ++round) {
        Overlay36Rows rows;
        Overlay36Manager before_manager;
        Overlay36World before_world;
        const char *why = NULL;
        int status, hit = 0;
        int32_t row_out = -1, row = (int32_t)(lcg(&seed) % (rows_n + 2u)) - 1;
        probe.fail_load = lcg(&seed) % 17u == 0u;
        probe.fail_tick = lcg(&seed) % 23u == 0u;
        if (lcg(&seed) % 9u == 0u) host.load_surface = NULL; else host.load_surface = p_load;
        if (lcg(&seed) % 9u == 0u) host.tick_count = NULL; else host.tick_count = p_tick;
        if (lcg(&seed) % 9u == 0u) host.sound_start = NULL; else host.sound_start = p_sound_start;
        if (lcg(&seed) % 9u == 0u) host.blit = NULL; else host.blit = p_blit;
        rows.images = (uint8_t *const *)images;
        rows.count = rows_n;
        before_manager = *manager;
        before_world = *world;
        memcpy(events_backup, events, events_n * sizeof(*events));
        for (r = 0; r < rows_n; ++r) if (images[r] != NULL) memcpy(backup[r], images[r], OVERLAY36_IMAGE_BYTES);
        switch (lcg(&seed) % 6u) {
        case 0: case 1: case 2: {
            Overlay36StepResult result;
            uint32_t phase = lcg(&seed) % 5u;
            status = overlay36_step(manager, &rows, row, phase, world, &host, &result, &why);
            ++kernel_visits;
            if (status == OVERLAY36_ERR_UNSUPPORTED || status == OVERLAY36_ERR_BOUNDS ||
                status == OVERLAY36_ERR_ARGUMENT) {
                ++kernel_rejections;
                assert(memcmp(manager, &before_manager, sizeof(*manager)) == 0);
                assert(memcmp(world, &before_world, sizeof(*world)) == 0);
                assert(events_n == 0u || memcmp(events, events_backup, events_n * sizeof(*events)) == 0);
                for (r = 0; r < rows_n; ++r) if (images[r] != NULL) assert(memcmp(backup[r], images[r], OVERLAY36_IMAGE_BYTES) == 0);
                assert(why != NULL);
            }
            break;
        }
        case 3: {
            status = overlay36_hit_test(manager, &rows, (int16_t)(lcg(&seed) % 700u) - 20, (int16_t)(lcg(&seed) % 500u) - 20,
                                        world, &host, &hit, &row_out, &why);
            ++hit_calls;
            if (status != OVERLAY36_OK) {
                ++hit_rejections;
                assert(memcmp(manager, &before_manager, sizeof(*manager)) == 0);
            }
            break;
        }
        case 4: {
            Overlay36HotRect out[8];
            size_t count = 0;
            const size_t capacity = 1u + lcg(&seed) % 8u;
            status = overlay36_hot_rects(manager, &rows, (int16_t)(lcg(&seed) % 4u), &host, out, capacity, &count);
            ++hot_calls;
            if (status != OVERLAY36_OK) ++hot_rejections;
            assert(memcmp(manager, &before_manager, sizeof(*manager)) == 0);
            {
                /* The production pointer path: exported rectangles become priority
                 * rows of session_input_scan_priority (rectangles of any int32
                 * value, row indices possibly out of range). */
                SessionInputHotspot rows_out[8];
                SessionInputState input;
                SessionInputContext context;
                size_t used = count < capacity ? count : capacity, k;
                const int32_t extremes[] = {INT32_MIN, -40000, -32769, -32768, -1, 0, 1, 300, 32767, 32768,
                                            40000, INT32_MAX};
                int scan_status;
                memset(&context, 0, sizeof(context));
                context.geometry_ready = 1u;
                context.priority_clear = 1u;
                context.excluded_0 = context.excluded_1 = -1;
                context.hot_x = (int32_t)(lcg(&seed) % 700u) - 20;
                context.hot_y = (int32_t)(lcg(&seed) % 500u) - 20;
                for (k = 0; k < used; ++k) {
                    memset(&rows_out[k], 0, sizeof(rows_out[k]));
                    rows_out[k].index = lcg(&seed) % 9u == 0u ? 240 : out[k].row;
                    rows_out[k].rectangle.left = out[k].left;
                    rows_out[k].rectangle.top = out[k].top;
                    rows_out[k].rectangle.right = lcg(&seed) % 5u == 0u ? INT32_MAX : out[k].right;
                    rows_out[k].rectangle.bottom = out[k].bottom;
                    rows_out[k].active = 1u;
                    if (rows_out[k].rectangle.right > INT16_MAX) ++scan_right_above_short;
                }
                /* A few synthetic rows: indices around the valid range, extreme corners. */
                for (k = used; k < 8u && k < used + 2u; ++k) {
                    memset(&rows_out[k], 0, sizeof(rows_out[k]));
                    rows_out[k].index = (int32_t)(lcg(&seed) % 244u) - 2;
                    rows_out[k].rectangle.left = extremes[lcg(&seed) % 12u];
                    rows_out[k].rectangle.top = extremes[lcg(&seed) % 12u];
                    rows_out[k].rectangle.right = extremes[lcg(&seed) % 12u];
                    rows_out[k].rectangle.bottom = extremes[lcg(&seed) % 12u];
                    rows_out[k].active = lcg(&seed) % 4u != 0u;
                    if (rows_out[k].rectangle.right > INT16_MAX) ++scan_right_above_short;
                }
                used = k;
                assert(session_input_init(&input) == SESSION_INPUT_OK);
                scan_status = session_input_scan_priority(&input, &context, rows_out, used, NULL, 0u);
                ++scan_calls;
                if (scan_status != SESSION_INPUT_OK) ++scan_rejections;
                assert(scan_status == SESSION_INPUT_OK || scan_status == SESSION_INPUT_INVALID_ARGUMENT);
                assert(scan_status != SESSION_INPUT_OK || (input.candidate >= -1 && input.candidate < 240));
            }
            break;
        }
        default: {
            size_t drawn = 0;
            int32_t lo = (int32_t)(lcg(&seed) % 3u);
            status = lcg(&seed) % 2u == 0u
                ? overlay36_render_layers(manager, &rows, lo, lo + 2, world, &host, &drawn, &why)
                : overlay36_draw_slot(manager, &rows, (int)(lcg(&seed) % (OVERLAY36_SLOTS + 2u)) - 1, world, &host, &why);
            ++draw_calls;
            if (status != OVERLAY36_OK) ++draw_rejections;
            assert(memcmp(manager, &before_manager, sizeof(*manager)) == 0);
            for (r = 0; r < rows_n; ++r) if (images[r] != NULL) assert(memcmp(backup[r], images[r], OVERLAY36_IMAGE_BYTES) == 0);
            break;
        }
        }
        /* re-randomise a row now and then so later rounds see new shapes */
        if (lcg(&seed) % 7u == 0u) {
            r = lcg(&seed) % rows_n;
            if (images[r] != NULL) fill_image(images[r], &seed, 1);
        }
    }
    for (r = 0; r < rows_n; ++r) { free(images[r]); free(backup[r]); }
    free(images); free(backup); free(events); free(events_backup); free(manager); free(world);
}

/* ---- binding over synthetic scenes ---- */
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

static uint64_t scenes_opened, scenes_rejected, begin_ok, begin_rejected, handler_calls, handler_ok, handler_error,
    handler_unsupported;

static int32_t g_events[8];

static int b_world(void *c, Overlay36World *w)
{
    (void)c;
    w->events = g_events; w->event_count = 8; w->selector = 0; w->held_item = -1;
    return 0;
}
static void b_store(void *c, const Overlay36World *w) { (void)c; (void)w; }
static int b_transition(void *c, const SceneTransitionRequest *r) { (void)c; return r == NULL; }

static void binding_sweep(uint32_t seed)
{
    SessionA36Host host;
    SessionA36Binding *binding;
    int scene_index;
    Probe probe = {seed, 0, 0, 0};
    memset(g_events, 0, sizeof(g_events));
    memset(&host, 0, sizeof(host));
    host.kernel.context = &probe;
    host.kernel.load_surface = p_load;
    host.kernel.tick_count = p_tick;
    host.kernel.row_phase = p_phase;
    host.kernel.blit = p_blit;
    host.kernel.observe = p_observe;
    host.load_world = b_world;
    host.store_world = b_store;
    host.transition = b_transition;
    binding = session_a36_create(&host);
    assert(binding != NULL);
    for (scene_index = 0; scene_index < 40; ++scene_index) {
        size_t rows_n = 1u + lcg(&seed) % 3u, total = 0, row;
        uint8_t *bytes = (uint8_t *)malloc(65536);
        uint8_t tsum[126];
        uint8_t *act = (uint8_t *)malloc(4096);
        size_t at = 8, body_total;
        SceneResource *scene;
        char error[256];
        memset(tsum, 0, sizeof(tsum));
        memcpy(tsum, "Session", 8);
        memcpy(tsum + 50, "background", 11);
        memcpy(tsum + 83, "sound", 6);
        memcpy(bytes + 8, "SCEN", 4);
        at = 12;
        at = put_chunk(bytes, at, "TSUM", tsum, sizeof(tsum));
        for (row = 0; row < rows_n; ++row) {
            size_t n = lcg(&seed) % 4u, m = lcg(&seed) % 4u, len = 0xacu + 16u * n + 38u * m, i;
            memset(act, 0, 4096);
            memcpy(act, "san", 4);
            act[48] = lcg(&seed) % 6u == 0u ? 0x61 : 0x36;
            act[49] = (uint8_t)(1u + lcg(&seed) % 2u);
            for (i = 0; i < len; ++i) act[50 + i] = (uint8_t)lcg(&seed);
            act[50 + OV36_MARKER] = (uint8_t)(1u + lcg(&seed) % 2u); act[50 + OV36_MARKER + 1] = 0;
            act[50 + OV36_PRIMARY_COUNT] = (uint8_t)n; act[50 + OV36_PRIMARY_COUNT + 1] = 0;
            act[50 + OV36_FRAME_FIRST] = 0; act[50 + OV36_FRAME_FIRST + 1] = 0;
            act[50 + OV36_FRAME_LAST] = (uint8_t)(n ? n - 1u : 0xffu); act[50 + OV36_FRAME_LAST + 1] = n ? 0 : 0xff;
            act[50 + OV36_SECONDARY_COUNT] = (uint8_t)m; act[50 + OV36_SECONDARY_COUNT + 1] = 0;
            act[50 + OV36_NAME + 5] = 0;
            act[50 + OV36_EVENT_INDEX] = (uint8_t)(lcg(&seed) % 3u == 0u ? 0xffu : lcg(&seed) % 12u);
            act[50 + OV36_EVENT_INDEX + 1] = act[50 + OV36_EVENT_INDEX] == 0xffu ? 0xff : 0;
            memcpy(act + 50 + OV36_SOUND, "NO SOUND", 9);
            at = put_chunk(bytes, at, "ACT\0", act, 50 + len);
            total += len;
        }
        body_total = at - 8;
        memcpy(bytes, "DATA", 4);
        bytes[4] = (uint8_t)(body_total >> 24); bytes[5] = (uint8_t)(body_total >> 16);
        bytes[6] = (uint8_t)(body_total >> 8); bytes[7] = (uint8_t)body_total;
        (void)total;
        scene = scene_resource_open_memory(bytes, at, error, sizeof(error));
        if (scene == NULL) {
            ++scenes_rejected;
        } else {
            ++scenes_opened;
            if (session_a36_begin_scene(binding, scene) == OVERLAY36_OK) {
                ++begin_ok;
                for (row = 0; row < scene_resource_action_count(scene); ++row) {
                    SceneActionInfo info;
                    int round;
                    if (scene_resource_action_at(scene, row, &info) != SCENE_RESOURCE_OK) continue;
                    for (round = 0; round < 12; ++round) {
                        SceneActionRuntimeState before;
                        SceneActionHandlerResult out;
                        int status;
                        before.completed = 0;
                        before.phase = lcg(&seed) % 4u;
                        out.disposition = SCENE_ACTION_HANDLER_PENDING;
                        out.phase = 99u;
                        status = session_a36_handler(binding, row, &info, &before, &out);
                        ++handler_calls;
                        if (status == SCENE_ACTION_HANDLER_OK) ++handler_ok;
                        else if (status == SCENE_ACTION_HANDLER_UNSUPPORTED) ++handler_unsupported;
                        else { ++handler_error; assert(out.phase == 99u); }
                        {
                            SessionInputHotspot spots[OVERLAY36_LIST_LIMIT * 25];
                            size_t count = 0;
                            (void)session_a36_priority_rows(binding, spots, 1u + lcg(&seed) % 8u, &count);
                            (void)session_a36_render(binding, 0, 20, NULL);
                        }
                    }
                }
            } else {
                ++begin_rejected;
            }
        }
        free(bytes); free(act);
        if (scene != NULL) scene_resource_close(scene);
    }
    session_a36_destroy(binding);
}

int main(void)
{
    uint32_t s;
    for (s = 1; s <= 3000; ++s) kernel_sweep(s * 2654435761u);
    for (s = 1; s <= 40; ++s) binding_sweep(s * 40503u);
    printf("kernel_visits=%llu kernel_rejections=%llu hit_calls=%llu hit_rejections=%llu draw_calls=%llu draw_rejections=%llu hot_calls=%llu hot_rejections=%llu\n",
           (unsigned long long)kernel_visits, (unsigned long long)kernel_rejections, (unsigned long long)hit_calls,
           (unsigned long long)hit_rejections, (unsigned long long)draw_calls, (unsigned long long)draw_rejections,
           (unsigned long long)hot_calls, (unsigned long long)hot_rejections);
    printf("priority_scan_calls=%llu priority_scan_rejections=%llu rows_with_right_above_short=%llu\n",
           (unsigned long long)scan_calls, (unsigned long long)scan_rejections,
           (unsigned long long)scan_right_above_short);
    printf("binding_scenes_opened=%llu scenes_rejected_by_parser=%llu begin_ok=%llu begin_rejected=%llu handler_calls=%llu handler_ok=%llu handler_error=%llu handler_unsupported=%llu\n",
           (unsigned long long)scenes_opened, (unsigned long long)scenes_rejected, (unsigned long long)begin_ok,
           (unsigned long long)begin_rejected, (unsigned long long)handler_calls, (unsigned long long)handler_ok,
           (unsigned long long)handler_error, (unsigned long long)handler_unsupported);
    return 0;
}
