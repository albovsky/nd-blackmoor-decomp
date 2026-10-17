#include "session_bindings_a20_a70_a80.h"

#include <stdlib.h>
#include <string.h>

/* ---- raw 0x20 ---------------------------------------------------------------------------------------------------------- */
struct SessionA20Binding {
    SessionA20Host host;
    Action20Outcome last;
    const char *failure;
    unsigned long visits;
};

SessionA20Binding *session_a20_create(const SessionA20Host *host)
{
    SessionA20Binding *b;
    if (host == NULL) {
        return NULL;
    }
    b = (SessionA20Binding *)calloc(1u, sizeof(*b));
    if (b != NULL) {
        b->host = *host;
        b->failure = "none";
    }
    return b;
}

void session_a20_destroy(SessionA20Binding *b)
{
    free(b);
}

int session_a20_handler(void *context, size_t index, const SceneActionInfo *action, const SceneActionRuntimeState *before,
                        SceneActionHandlerResult *out)
{
    SessionA20Binding *b = (SessionA20Binding *)context;
    ActionFamily20Decoded decoded;
    Action20World world;
    Action20Host kernel_host;
    Action20Outcome outcome;

    (void)index;
    if (b == NULL || action == NULL || before == NULL || out == NULL || action->type != SESSION_A20_TYPE) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (action_family_20_decode(action->raw_body, action->raw_body_length, &decoded) != ACTION_FAMILY_20_OK) {
        b->failure = "invalid raw-0x20 body";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    memset(&world, 0, sizeof(world));
    if (b->host.load_world == NULL || b->host.load_world(b->host.context, &world) != 0) {
        b->failure = "world provider (scene cells 0x5bb57b/0x5bb57f)";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    if (b->host.erase_rows == NULL) {
        b->failure = "row eraser (0x43e96c + 0x43e8b8)";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    kernel_host.context = b->host.context;
    kernel_host.erase_rows = b->host.erase_rows;
    if (action_family_20_runtime_visit(&decoded, &world, &kernel_host, &outcome) != ACTION_FAMILY_20_RUNTIME_OK) {
        b->failure = "raw-0x20 row erase failed";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    b->failure = "none";
    b->last = outcome;
    ++b->visits;
    if (b->host.store_world != NULL) {
        b->host.store_world(b->host.context, &world);
    }
    out->phase = 0u;                                             /* 0x43ea29: the erase clears the phase dword */
    out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;
    return SCENE_ACTION_HANDLER_OK;
}

const char *session_a20_failure(const SessionA20Binding *b)
{
    return b == NULL ? "invalid binding" : b->failure;
}

const Action20Outcome *session_a20_last_outcome(const SessionA20Binding *b)
{
    return b == NULL ? NULL : &b->last;
}

unsigned long session_a20_visits(const SessionA20Binding *b)
{
    return b == NULL ? 0ul : b->visits;
}

/* ---- raw 0x70 ---------------------------------------------------------------------------------------------------------- */
struct SessionA70Binding {
    SessionA70Host host;
    const char *failure;
    unsigned long visits;
};

SessionA70Binding *session_a70_create(const SessionA70Host *host)
{
    SessionA70Binding *b;
    if (host == NULL) {
        return NULL;
    }
    b = (SessionA70Binding *)calloc(1u, sizeof(*b));
    if (b != NULL) {
        b->host = *host;
        b->failure = "none";
    }
    return b;
}

void session_a70_destroy(SessionA70Binding *b)
{
    free(b);
}

int session_a70_handler(void *context, size_t index, const SceneActionInfo *action, const SceneActionRuntimeState *before,
                        SceneActionHandlerResult *out)
{
    SessionA70Binding *b = (SessionA70Binding *)context;
    ActionFamily70Decoded decoded;
    Action70World world;
    Action70Host kernel_host;

    (void)index;
    if (b == NULL || action == NULL || before == NULL || out == NULL || action->type != SESSION_A70_TYPE) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (action_family_70_decode(action->raw_body, action->raw_body_length, &decoded) != ACTION_FAMILY_70_OK) {
        b->failure = "invalid raw-0x70 body";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    memset(&world, 0, sizeof(world));
    if (b->host.load_world != NULL && b->host.load_world(b->host.context, &world) != 0) {
        b->failure = "world provider (outer state cells)";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    if (b->host.unload_scene_sound == NULL) {
        b->failure = "scene sound unload (0x4fb018 on 0x5c3a67)";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    kernel_host.context = b->host.context;
    kernel_host.unload_scene_sound = b->host.unload_scene_sound;
    if (action_family_70_runtime_visit(&decoded, &world, &kernel_host) != ACTION_FAMILY_70_RUNTIME_OK) {
        b->failure = "raw-0x70 scene sound unload failed";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    b->failure = "none";
    ++b->visits;
    if (b->host.store_world != NULL) {
        b->host.store_world(b->host.context, &world);
    }
    out->phase = before->phase;                                  /* the phase word is not written */
    out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;   /* 0x429269: completion byte := 1 */
    return SCENE_ACTION_HANDLER_OK;
}

const char *session_a70_failure(const SessionA70Binding *b)
{
    return b == NULL ? "invalid binding" : b->failure;
}

unsigned long session_a70_visits(const SessionA70Binding *b)
{
    return b == NULL ? 0ul : b->visits;
}

/* ---- raw 0x80 ---------------------------------------------------------------------------------------------------------- */
struct SessionA80Binding {
    SessionA80Host host;
    Action80World last_world;
    const char *failure;
    unsigned long visits;
};

SessionA80Binding *session_a80_create(const SessionA80Host *host)
{
    SessionA80Binding *b;
    if (host == NULL) {
        return NULL;
    }
    b = (SessionA80Binding *)calloc(1u, sizeof(*b));
    if (b != NULL) {
        b->host = *host;
        b->failure = "none";
    }
    return b;
}

void session_a80_destroy(SessionA80Binding *b)
{
    free(b);
}

int session_a80_handler(void *context, size_t index, const SceneActionInfo *action, const SceneActionRuntimeState *before,
                        SceneActionHandlerResult *out)
{
    SessionA80Binding *b = (SessionA80Binding *)context;
    ActionFamily80Decoded decoded;
    Action80Object object;
    Action80World world;
    SceneTransitionRequest request;

    (void)index;
    if (b == NULL || action == NULL || before == NULL || out == NULL || action->type != SESSION_A80_TYPE) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (action_family_80_decode(action->raw_body, action->raw_body_length, &decoded) != ACTION_FAMILY_80_OK) {
        b->failure = "invalid raw-0x80 body";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (b->host.load_object == NULL || b->host.transition == NULL) {
        b->failure = "object or scene-change provider (object 0x57975c, 0x4e386e scene-change cells)";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    memset(&object, 0, sizeof(object));
    memset(&world, 0, sizeof(world));
    if (b->host.load_object(b->host.context, (int16_t)decoded.word_0 == ACTION_FAMILY_80_SCENE_NONE, &object) != 0) {
        b->failure = "overlay object 0x57975c has no stored return tuple";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    if (b->host.load_world != NULL && b->host.load_world(b->host.context, &world) != 0) {
        b->failure = "world provider (scene cells)";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    if (action_family_80_runtime_visit(&decoded, &object, &world) != ACTION_FAMILY_80_RUNTIME_OK) {
        b->failure = "raw-0x80 kernel refused the visit";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    /* The 0x0a arm's shape: target word, three words, three dwords (0x5bb57b, 0x5bb599/0x5bb595/0x5c39ff, 0x5bb59b/9f/a3). */
    memset(&request, 0, sizeof(request));
    request.target_scene = (int16_t)world.scene_5bb57b;
    request.opaque_words[0] = world.word_5bb599;
    request.opaque_words[1] = world.word_5bb595;
    request.opaque_words[2] = world.word_5c39ff;
    request.opaque_dwords[0] = world.dword_5bb59b;
    request.opaque_dwords[1] = world.dword_5bb59f;
    request.opaque_dwords[2] = world.dword_5bb5a3;
    if (b->host.transition(b->host.context, &request) != 0) {
        b->failure = "scene-change request was refused";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    b->failure = "none";
    b->last_world = world;
    ++b->visits;
    if (b->host.store_object != NULL) {
        b->host.store_object(b->host.context, &object);
    }
    if (b->host.store_world != NULL) {
        b->host.store_world(b->host.context, &world);
    }
    out->phase = before->phase;                                  /* the phase word is not written */
    out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;   /* 0x42964e: completion byte := 1 */
    return SCENE_ACTION_HANDLER_OK;
}

const char *session_a80_failure(const SessionA80Binding *b)
{
    return b == NULL ? "invalid binding" : b->failure;
}

const Action80World *session_a80_last_world(const SessionA80Binding *b)
{
    return b == NULL ? NULL : &b->last_world;
}

unsigned long session_a80_visits(const SessionA80Binding *b)
{
    return b == NULL ? 0ul : b->visits;
}
