#include "session_bindings_a2d.h"

#include <stdlib.h>
#include <string.h>

struct SessionA2dBinding {
    SessionA2dHost host;
    SessionA2EBinding *a2e;
    D2Object object;
    D2World world;
    D2Set *sets; /* indexed by scene row; only the raw 0x2d row has entries */
    uint8_t *present;
    size_t count;
    const char *failure;
};

SessionA2dBinding *session_a2d_create(const SessionA2dHost *host)
{
    SessionA2dBinding *b;
    if (host == NULL) {
        return NULL;
    }
    b = (SessionA2dBinding *)calloc(1u, sizeof(*b));
    if (b != NULL) {
        b->host = *host;
        d2_object_reset(&b->object);
        d2_world_init(&b->world);
        b->failure = "none";
        d2_register_entry(&b->object, &b->world); /* world init: 0x4cecf7 at 0x439500 */
    }
    return b;
}

static void free_sets(SessionA2dBinding *b)
{
    for (size_t i = 0u; i < b->count; ++i) {
        if (b->present != NULL && b->present[i] != 0u) {
            d2_set_free(&b->sets[i]);
        }
    }
    free(b->sets);
    free(b->present);
    b->sets = NULL;
    b->present = NULL;
    b->count = 0u;
}

void session_a2d_destroy(SessionA2dBinding *b)
{
    int32_t erased;
    if (b == NULL) {
        return;
    }
    (void)d2_destruct(&b->object, &b->host.kernel, &erased);
    free_sets(b);
    free(b);
}

void session_a2d_attach_a2e(SessionA2dBinding *b, SessionA2EBinding *a2e)
{
    if (b == NULL) {
        return;
    }
    b->a2e = a2e;
    if (a2e != NULL) {
        session_a2e_set_movie(a2e, &b->object.movie);
    }
}

/* Bring the host-owned state in before a kernel call and the raw 0x2e copy of the shared fields. */
static void load_state(SessionA2dBinding *b)
{
    if (b->host.load_world != NULL) {
        b->host.load_world(b->host.kernel.context, &b->world);
    }
    if (b->host.load_stream != NULL) {
        b->host.load_stream(b->host.kernel.context, &b->object);
    }
    if (b->a2e != NULL) {
        b->object.movie = *session_a2e_movie(b->a2e);
    }
}

static void store_state(SessionA2dBinding *b)
{
    if (b->a2e != NULL) {
        session_a2e_set_movie(b->a2e, &b->object.movie);
    }
    if (b->host.store_stream != NULL) {
        b->host.store_stream(b->host.kernel.context, &b->object);
    }
    if (b->host.store_world != NULL) {
        b->host.store_world(b->host.kernel.context, &b->world);
    }
}

int session_a2d_begin_scene(SessionA2dBinding *b, const SceneResource *scene)
{
    D2Set *sets = NULL;
    uint8_t *present = NULL;
    size_t count;
    size_t rows_2d = 0u;
    if (b == NULL || scene == NULL) {
        return D2_ERR_ARGUMENT;
    }
    /* The original destroys and registers the object once, at world init (0x4381f4: 0x4cd218 at 0x4383f2, 0x4cecf7 at
     * 0x439500), not at a scene load, and its handlers keep the object across scene loads. What happens to a live movie's
     * tables when the scene's rows are replaced is not recovered, so a scene load with an active movie is refused before any
     * effect and the old tables stay. */
    load_state(b);
    if (b->object.movie.active != 0) {
        b->failure = "0x2d: a scene load while the random movie is active is not modelled";
        return D2_ERR_UNSUPPORTED;
    }
    count = scene_resource_action_count(scene);
    if (count != 0u) {
        sets = (D2Set *)calloc(count, sizeof(*sets));
        present = (uint8_t *)calloc(count, 1u);
        if (sets == NULL || present == NULL) {
            free(sets);
            free(present);
            b->failure = "0x2d-row-allocation";
            return D2_ERR_BODY;
        }
    }
    for (size_t i = 0u; i < count; ++i) {
        SceneActionInfo info;
        const char *why = NULL;
        if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) {
            b->failure = "0x2d-scene-row";
            goto bad;
        }
        if (info.type != SESSION_A2D_TYPE) {
            continue;
        }
        if (++rows_2d > 1u) {
            b->failure = "0x2d: a scene with two raw 0x2d rows (the object is a singleton)";
            goto bad;
        }
        if (d2_set_parse(info.typed_body, info.typed_body_length, &sets[i], &why) != D2_OK) {
            b->failure = why != NULL ? why : "0x2d-body";
            goto bad;
        }
        present[i] = 1u;
    }
    /* The inactive object owns no tables (its stop erased them), so the old ones are dropped with the old scene. */
    free_sets(b);
    b->sets = sets;
    b->present = present;
    b->count = count;
    b->failure = "none";
    return D2_OK;
bad:
    /* A failed build leaves the new scene's rows unowned: the old scene's tables must not answer for them. */
    free_sets(b);
    for (size_t i = 0u; i < count; ++i) {
        if (present != NULL && present[i] != 0u) {
            d2_set_free(&sets[i]);
        }
    }
    free(sets);
    free(present);
    return D2_ERR_BODY;
}

int session_a2d_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionA2dBinding *b = (SessionA2dBinding *)context;
    D2StepResult result;
    const char *why = NULL;
    int status;
    if (b == NULL) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (action == NULL || before == NULL || out == NULL || action->type != SESSION_A2D_TYPE || index >= b->count ||
        b->present[index] == 0u || index > 0x7fffu) {
        b->failure = "0x2d-row-not-owned";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (before->phase == 0u && (b->host.media_available == NULL || b->host.media_available(b->host.kernel.context) == 0)) {
        b->failure = "random-movie media backend (AVF decode thread, Bink player, clip file probes) is not available";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    load_state(b);
    status = d2_step(&b->object, &b->sets[index], (int16_t)index, before->phase, &b->world, &b->host.kernel, &result,
                     &why);
    store_state(b);
    b->failure = why != NULL ? why : "none";
    if (status == D2_ERR_UNSUPPORTED) {
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    if (status != D2_OK) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    out->phase = result.phase_after;
    /* Phase 2: the stop erased the row and stored its completion byte (0x4ccff5, 0x4ceb75), no 0x42ba3a. */
    out->disposition = result.stopped != 0u ? SCENE_ACTION_HANDLER_DIRECT_COMPLETED : SCENE_ACTION_HANDLER_PENDING;
    return SCENE_ACTION_HANDLER_OK;
}

int session_a2d_stop(SessionA2dBinding *b, int32_t *retire_row)
{
    int status;
    if (b == NULL) {
        return D2_ERR_ARGUMENT;
    }
    load_state(b);
    status = d2_stop(&b->object, &b->world, &b->host.kernel, retire_row);
    store_state(b);
    b->failure = status == D2_OK ? "none" : "0x2d-stop";
    return status;
}

int session_a2d_render_plan(SessionA2dBinding *b, D2RenderPlan *plan)
{
    if (b == NULL) {
        return D2_ERR_ARGUMENT;
    }
    load_state(b); /* flag 0x206 and the active word are shared with raw 0x2e, which may have run in this pass */
    return d2_render_plan(&b->object, &b->world, plan);
}

const D2Object *session_a2d_object(const SessionA2dBinding *b)
{
    return b == NULL ? NULL : &b->object;
}

const D2World *session_a2d_world(const SessionA2dBinding *b)
{
    return b == NULL ? NULL : &b->world;
}

const char *session_a2d_failure(const SessionA2dBinding *b)
{
    return b == NULL ? "invalid binding" : b->failure;
}
