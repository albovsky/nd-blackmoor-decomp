/* RT-16: failing session_a0b_begin_scene with a stub scene resource.
 *
 * The shared parser (scene_resource.c) refuses any raw 0x0b object that is not 24 bytes, so a failing
 * begin cannot be reached through a parsed scene. This test links the binding against a stub of the
 * two scene_resource entry points it uses and checks the documented contract: a begin that fails
 * returns nonzero with a reason and KEEPS the rows of the previous scene (slots, payloads, count).
 * Built with ASan/UBSan by scripts/test_action_family_0b_runtime_sanitizers.sh. */
#include "session_bindings_a0b.h"

#include <assert.h>
#include <stdio.h>
#include <string.h>

typedef struct {
    uint8_t type;
    const uint8_t *body;
    size_t length;
} StubRow;

struct SceneResource {
    const StubRow *rows;
    size_t count;
};

size_t scene_resource_action_count(const SceneResource *scene)
{
    return scene->count;
}

int scene_resource_action_at(const SceneResource *scene, size_t index, SceneActionInfo *info)
{
    if (index >= scene->count) return SCENE_RESOURCE_ERR_BOUNDS;
    memset(info, 0, sizeof(*info));
    info->type = scene->rows[index].type;
    info->typed_body = scene->rows[index].body;
    info->typed_body_length = scene->rows[index].length;
    return SCENE_RESOURCE_OK;
}

static int load_world(void *context, Action17World *world)
{
    (void)context;
    world->selector = 0;
    world->start_flag_5bb1ca = 0;
    world->mode_583999 = 3;
    return 0;
}

int main(void)
{
    static const uint8_t good[24] = {9, 0, 0x04, 0x19, 4, 0, 1, 0, 1, 0, 0, 0, 0x45, 1, 0, 0,
                                     0x6b, 2, 0, 0, 0x76, 1, 0, 0};
    static const uint8_t other[24] = {5, 0, 0x01, 0x19, 0, 0, 1, 0, 2, 0, 0, 0, 3, 0, 0, 0,
                                      4, 0, 0, 0, 5, 0, 0, 0};
    uint8_t shortbody[23];
    uint8_t longbody[25];
    const StubRow scene_a_rows[] = {{0x61, good, 4}, {0x0b, good, 24}, {0x0b, other, 24}};
    const StubRow bad_short[] = {{0x0b, good, 24}, {0x0b, shortbody, sizeof(shortbody)}};
    const StubRow bad_long[] = {{0x0b, longbody, sizeof(longbody)}};
    const StubRow bad_null[] = {{0x0b, NULL, 0}};
    const StubRow scene_b_rows[] = {{0x0b, other, 24}};
    const SceneResource scene_a = {scene_a_rows, 3}, short_scene = {bad_short, 2},
                        long_scene = {bad_long, 1}, null_scene = {bad_null, 1},
                        scene_b = {scene_b_rows, 1};
    SessionA0bHost host;
    SessionA0bBinding *binding;
    Action17Slot slot_before, slot_after;
    Action0bPayload payload_before, payload_after;
    SceneActionInfo info;
    SceneActionRuntimeState state = {0u, 0u};
    SceneActionHandlerResult out = {0, 0u};

    memset(shortbody, 0, sizeof(shortbody));
    memset(longbody, 0, sizeof(longbody));
    memset(&host, 0, sizeof(host));
    host.load_world = load_world;
    binding = session_a0b_create(&host);
    assert(binding != NULL);

    assert(session_a0b_begin_scene(binding, &scene_a) == ACTION17_OK);
    assert(session_a0b_row_count(binding) == 3u);
    /* A visit gives the row a nonzero slot to preserve across the failing begin. */
    assert(scene_resource_action_at(&scene_a, 1, &info) == SCENE_RESOURCE_OK);
    assert(session_a0b_handler(binding, 1, &info, &state, &out) == SCENE_ACTION_HANDLER_OK);
    assert(session_a0b_slot(binding, 1, &slot_before) == ACTION17_OK && slot_before.request == 1);
    assert(session_a0b_payload(binding, 2, &payload_before) == ACTION17_OK);

    {
        const SceneResource *bad[] = {&short_scene, &long_scene, &null_scene};
        size_t i;
        for (i = 0; i < 3u; ++i) {
            assert(session_a0b_begin_scene(binding, bad[i]) != ACTION17_OK);
            assert(strcmp(session_a0b_failure(binding), "none") != 0);
            /* The previous scene's rows are still there, untouched. */
            assert(session_a0b_row_count(binding) == 3u);
            assert(session_a0b_slot(binding, 1, &slot_after) == ACTION17_OK);
            assert(memcmp(&slot_before, &slot_after, sizeof(slot_before)) == 0);
            assert(session_a0b_payload(binding, 2, &payload_after) == ACTION17_OK);
            assert(memcmp(&payload_before, &payload_after, sizeof(payload_before)) == 0);
            assert(session_a0b_payload(binding, 0, &payload_after) != ACTION17_OK);  /* the 0x61 row */
        }
    }
    /* A good begin afterwards replaces the rows and zeroes the slots. */
    assert(session_a0b_begin_scene(binding, &scene_b) == ACTION17_OK);
    assert(session_a0b_row_count(binding) == 1u);
    assert(session_a0b_slot(binding, 0, &slot_after) == ACTION17_OK && slot_after.request == 0);
    session_a0b_destroy(binding);
    printf("stub_scene_failing_begins=3 rows_kept=3\n");
    return 0;
}
