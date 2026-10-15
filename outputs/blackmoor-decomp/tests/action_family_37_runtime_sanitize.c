/* RT-18 ASan/UBSan driver: bounded malformed inputs for the raw 0x37 image builder and the
 * shared COverlay session binding. Every body, image and resource buffer is an exact-size
 * heap allocation so any out-of-bounds access is reported. A rejected build must leave the
 * output untouched. Exit 0 means every loop completed. */
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

static uint64_t builds, builds_ok, builds_rejected, scenes_opened, scenes_rejected, begin_ok,
    begin_rejected, handler_calls, handler_ok, handler_error, handler_unsupported, renders,
    priority_calls, type_mismatch_calls;

/* ---- providers ---- */
typedef struct {
    uint32_t seed;
    uint64_t calls;
} Probe;

static int p_load(void *c, const char *name, uint32_t *surface)
{
    Probe *p = (Probe *)c;
    ++p->calls;
    assert(name != NULL && memchr(name, 0, OVERLAY36_NAME_BYTES) != NULL);
    *surface = 1u + (lcg(&p->seed) & 0xffu);
    return 0;
}
static int p_tick(void *c, uint32_t *t) { *t = lcg(&((Probe *)c)->seed) * 977u; return 0; }
static int p_phase(void *c, int32_t row, uint32_t *phase) { (void)row; *phase = lcg(&((Probe *)c)->seed) % 4u; return 0; }
static int p_blit(void *c, const Overlay36Blit *op) { ((Probe *)c)->calls++; return op == NULL || op->label == NULL; }
static void p_observe(void *c, int effect, int32_t a, int32_t b)
{
    (void)c; (void)a; (void)b;
    assert(effect >= OV36_FX_BEGIN && effect <= OV36_FX_BLIT);
}

static int32_t g_events[16];
static uint32_t g_autotext;

static int b_world(void *c, Overlay36World *w)
{
    (void)c;
    w->events = g_events; w->event_count = 16; w->selector = 0; w->held_item = -1;
    w->autotext_surface[0] = w->autotext_surface[1] = w->autotext_surface[2] = g_autotext;
    return 0;
}
static void b_store(void *c, const Overlay36World *w) { (void)c; (void)w; }
static int b_transition(void *c, const SceneTransitionRequest *r) { (void)c; return r == NULL; }

/* ---- bodies ---- */
static size_t random_body(uint32_t *seed, uint8_t *out, size_t capacity)
{
    /* length: sometimes below, at, or above the 69-byte prefix, with/without a 16-byte tail */
    static const size_t lengths[] = {0, 1, 32, 33, 68, 69, 70, 84, 85, 86, 101, 133, 197, 200};
    size_t length = lengths[lcg(seed) % (sizeof(lengths) / sizeof(lengths[0]))], i;
    if (length > capacity) length = capacity;
    for (i = 0; i < length; ++i) out[i] = (uint8_t)lcg(seed);
    if (length >= 33u && lcg(seed) % 3u != 0u) {
        out[lcg(seed) % 33u] = 0; /* usually terminated inside the name field */
        if (lcg(seed) % 5u == 0u) memcpy(out, "USE_AUTOTEXT1", length >= 14u ? 14u : 0u);
    }
    return length;
}

static void build_sweep(uint32_t seed)
{
    int round;
    for (round = 0; round < 400; ++round) {
        uint8_t scratch[256];
        size_t length = random_body(&seed, scratch, sizeof(scratch));
        uint8_t *body = (uint8_t *)malloc(length != 0u ? length : 1u);
        uint8_t *image = (uint8_t *)malloc(OVERLAY36_IMAGE_BYTES);
        uint8_t guard[OVERLAY36_IMAGE_BYTES];
        int status;
        uint8_t raw_type = (uint8_t)(lcg(&seed) % 4u == 0u ? 0x36u : lcg(&seed) % 5u == 0u ? 0x38u : 0x37u);
        assert(body != NULL && image != NULL);
        memcpy(body, scratch, length);
        memset(image, 0xA5, OVERLAY36_IMAGE_BYTES);
        memcpy(guard, image, sizeof(guard));
        status = session_a36_build_image(raw_type, body, length, image);
        ++builds;
        if (status == OVERLAY36_OK) {
            ++builds_ok;
            if (raw_type == SESSION_A37_TYPE) {
                /* 0x37 postconditions that hold for every accepted body */
                assert(memchr(image, 0, OVERLAY36_NAME_BYTES) != NULL);
                assert(image[OV36_MARKER] == 1 && image[OV36_MARKER + 1] == 0);
                assert(image[OV36_SECONDARY + OV36_SEC_HOT] == 2);
                assert(image[OV36_EVENT_INDEX] == 0xff && image[OV36_EVENT_INDEX + 1] == 0xff);
                assert(memcmp(image + OV36_SOUND, "NO SOUND", 9) == 0);
                assert(image[OV36_RT_ENABLED] == 0 && image[OV36_RT_SURFACE] == 0);
            }
        } else {
            ++builds_rejected;
            assert(memcmp(image, guard, sizeof(guard)) == 0);
        }
        free(body);
        free(image);
    }
    /* NULL arguments */
    {
        uint8_t image[OVERLAY36_IMAGE_BYTES], body[69] = {0};
        assert(session_a36_build_image(SESSION_A37_TYPE, NULL, 69u, image) != OVERLAY36_OK);
        assert(session_a36_build_image(SESSION_A37_TYPE, body, sizeof(body), NULL) != OVERLAY36_OK);
    }
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

static void binding_sweep(uint32_t seed)
{
    SessionA36Host host;
    SessionA36Binding *binding;
    int scene_index;
    Probe probe = {seed, 0};
    memset(g_events, 0, sizeof(g_events));
    g_autotext = (seed & 1u) ? 0u : 0x500u;
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
        size_t rows_n = 1u + lcg(&seed) % 5u, row, at;
        uint8_t *bytes = (uint8_t *)malloc(65536);
        uint8_t tsum[126];
        uint8_t *act = (uint8_t *)malloc(4096);
        uint8_t *exact;
        size_t body_total;
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
            uint8_t body[256];
            size_t len = random_body(&seed, body, sizeof(body));
            uint32_t kind = lcg(&seed) % 8u;
            memset(act, 0, 4096);
            memcpy(act, "san", 4);
            act[48] = kind == 0u ? 0x61u : kind == 1u ? 0x38u : kind == 2u ? 0x36u : 0x37u;
            act[49] = (uint8_t)(1u + lcg(&seed) % 2u);
            if (act[48] == 0x37u && lcg(&seed) % 4u != 0u) {
                /* mostly a well-formed prefix so the builder and the handlers see real rows */
                len = 69u + 16u * (lcg(&seed) % 3u);
                memset(body, 0, sizeof(body));
                memcpy(body, "SAN_OVL", 8);
                if (lcg(&seed) % 6u == 0u) memcpy(body, "USE_AUTOTEXT2", 14);
                body[0x21] = (uint8_t)(1u + lcg(&seed) % 2u);
                body[0x23] = (uint8_t)(10u + lcg(&seed) % 2u);
                for (size_t k = 0x25; k < 0x45; ++k) body[k] = (uint8_t)(lcg(&seed) % 7u == 0u ? lcg(&seed) : 0);
            }
            memcpy(act + 50, body, len);
            at = put_chunk(bytes, at, "ACT\0", act, 50 + len);
        }
        body_total = at - 8;
        memcpy(bytes, "DATA", 4);
        bytes[4] = (uint8_t)(body_total >> 24); bytes[5] = (uint8_t)(body_total >> 16);
        bytes[6] = (uint8_t)(body_total >> 8); bytes[7] = (uint8_t)body_total;
        exact = (uint8_t *)malloc(at);
        memcpy(exact, bytes, at);
        scene = scene_resource_open_memory(exact, at, error, sizeof(error));
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
                    for (round = 0; round < 10; ++round) {
                        SceneActionRuntimeState before;
                        SceneActionHandlerResult out;
                        SceneActionInfo wrong = info;
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
                        /* the action's raw type must match the image's raw type */
                        wrong.type = info.type == SESSION_A37_TYPE ? SESSION_A36_TYPE : SESSION_A37_TYPE;
                        out.phase = 77u;
                        status = session_a36_handler(binding, row, &wrong, &before, &out);
                        ++type_mismatch_calls;
                        assert(status == SCENE_ACTION_HANDLER_ERROR && out.phase == 77u);
                        {
                            SessionInputHotspot spots[OVERLAY36_LIST_LIMIT * 25];
                            size_t count = 0;
                            (void)session_a36_priority_rows(binding, spots, 1u + lcg(&seed) % 8u, &count);
                            ++priority_calls;
                            (void)session_a36_render(binding, 0, 20, NULL);
                            ++renders;
                            assert(session_a36_row_raw_type(binding, row) == 0u ||
                                   session_a36_row_raw_type(binding, row) == info.type);
                        }
                    }
                }
            } else {
                ++begin_rejected;
            }
            scene_resource_close(scene);
        }
        free(exact);
        free(bytes);
        free(act);
    }
    session_a36_destroy(binding);
}

int main(void)
{
    uint32_t s;
    for (s = 1; s <= 600; ++s) build_sweep(s * 2654435761u);
    for (s = 1; s <= 60; ++s) binding_sweep(s * 40503u);
    printf("builds=%llu builds_ok=%llu builds_rejected=%llu\n", (unsigned long long)builds,
           (unsigned long long)builds_ok, (unsigned long long)builds_rejected);
    printf("binding_scenes_opened=%llu scenes_rejected_by_parser=%llu begin_ok=%llu begin_rejected=%llu "
           "handler_calls=%llu handler_ok=%llu handler_error=%llu handler_unsupported=%llu "
           "type_mismatch_calls=%llu priority_calls=%llu renders=%llu\n",
           (unsigned long long)scenes_opened, (unsigned long long)scenes_rejected,
           (unsigned long long)begin_ok, (unsigned long long)begin_rejected,
           (unsigned long long)handler_calls, (unsigned long long)handler_ok,
           (unsigned long long)handler_error, (unsigned long long)handler_unsupported,
           (unsigned long long)type_mismatch_calls, (unsigned long long)priority_calls,
           (unsigned long long)renders);
    assert(builds_ok != 0u && builds_rejected != 0u && begin_ok != 0u);
    return 0;
}
