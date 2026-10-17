#include "session_bindings_a6d_a9a.h"

#include <stdlib.h>
#include <string.h>

/* ---- raw 0x6d ---------------------------------------------------------------------------------------------------------- */
struct SessionA6dBinding {
    SessionA6dHost host;
    Action6DWorld last_world;
    const char *failure;
    unsigned long visits;
};

SessionA6dBinding *session_a6d_create(const SessionA6dHost *host)
{
    SessionA6dBinding *b;
    if (host == NULL) {
        return NULL;
    }
    b = (SessionA6dBinding *)calloc(1u, sizeof(*b));
    if (b != NULL) {
        b->host = *host;
        b->failure = "none";
    }
    return b;
}

void session_a6d_destroy(SessionA6dBinding *b)
{
    free(b);
}

int session_a6d_handler(void *context, size_t index, const SceneActionInfo *action, const SceneActionRuntimeState *before,
                        SceneActionHandlerResult *out)
{
    SessionA6dBinding *b = (SessionA6dBinding *)context;
    ActionFamily6DDecoded decoded;
    Action6DWorld world;
    Action6DHost kernel_host;
    int status;

    (void)index;
    if (b == NULL || action == NULL || before == NULL || out == NULL || action->type != SESSION_A6D_TYPE) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (action_family_6d_decode(action->raw_body, action->raw_body_length, &decoded) != ACTION_FAMILY_6D_OK) {
        b->failure = "invalid raw-0x6d body";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    memset(&world, 0, sizeof(world));
    if (b->host.load_world == NULL || b->host.load_world(b->host.context, &world) != 0) {
        b->failure = "world provider (cells 0x583204, 0x5bb22a)";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    if (b->host.unload_scene_sound == NULL) {
        b->failure = "scene sound unload (0x4fb018)";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    kernel_host.context = b->host.context;
    kernel_host.unload_scene_sound = b->host.unload_scene_sound;
    kernel_host.teardown = b->host.teardown;
    status = action_family_6d_runtime_visit(&decoded, &world, &kernel_host);
    if (status == ACTION_FAMILY_6D_RUNTIME_ERR_TEARDOWN) {
        b->failure = "popup teardown (0x4eb96e / 0x4e7d04 / 0x4e303b) has no host";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    if (status != ACTION_FAMILY_6D_RUNTIME_OK) {
        b->failure = "raw-0x6d teardown or sound unload failed";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    b->failure = "none";
    b->last_world = world;
    ++b->visits;
    if (b->host.store_world != NULL) {
        b->host.store_world(b->host.context, &world);
    }
    out->phase = before->phase;                                  /* the phase word is not written */
    out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;    /* 0x429163: completion byte := 1 */
    return SCENE_ACTION_HANDLER_OK;
}

const char *session_a6d_failure(const SessionA6dBinding *b)
{
    return b == NULL ? "invalid binding" : b->failure;
}

const Action6DWorld *session_a6d_last_world(const SessionA6dBinding *b)
{
    return b == NULL ? NULL : &b->last_world;
}

unsigned long session_a6d_visits(const SessionA6dBinding *b)
{
    return b == NULL ? 0ul : b->visits;
}

/* ---- raw 0x9a ---------------------------------------------------------------------------------------------------------- */
struct SessionA9aBinding {
    SessionA9aHost host;
    Action9AWorld last_world;
    const char *failure;
    unsigned long visits;
};

SessionA9aBinding *session_a9a_create(const SessionA9aHost *host)
{
    SessionA9aBinding *b;
    if (host == NULL) {
        return NULL;
    }
    b = (SessionA9aBinding *)calloc(1u, sizeof(*b));
    if (b != NULL) {
        b->host = *host;
        b->failure = "none";
    }
    return b;
}

void session_a9a_destroy(SessionA9aBinding *b)
{
    free(b);
}

int session_a9a_handler(void *context, size_t index, const SceneActionInfo *action, const SceneActionRuntimeState *before,
                        SceneActionHandlerResult *out)
{
    SessionA9aBinding *b = (SessionA9aBinding *)context;
    ActionFamily9ADecoded decoded;
    Action9AWorld world;
    Action9AHost kernel_host;
    Action9AOutcome outcome;
    SceneTransitionRequest request;
    int status;

    (void)index;
    if (b == NULL || action == NULL || before == NULL || out == NULL || action->type != SESSION_A9A_TYPE) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (action_family_9a_decode(action->raw_body, action->raw_body_length, &decoded) != ACTION_FAMILY_9A_OK) {
        b->failure = "invalid raw-0x9a body";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (b->host.stop_channel == NULL || b->host.event_flag_invalid == NULL || b->host.store_event_flag == NULL) {
        b->failure = "sound channel stop (0x4fc878) or event flag provider";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    if ((int16_t)decoded.word[1] != ACTION_FAMILY_9A_SCENE_NONE && b->host.transition == NULL) {
        b->failure = "scene-change provider (cells 0x5bb57b.., engine mode 0x583999)";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    memset(&world, 0, sizeof(world));
    if (b->host.load_world != NULL && b->host.load_world(b->host.context, &world) != 0) {
        b->failure = "world provider (scene cells)";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    kernel_host.context = b->host.context;
    kernel_host.stop_channel = b->host.stop_channel;
    kernel_host.event_flag_invalid = b->host.event_flag_invalid;
    kernel_host.store_event_flag = b->host.store_event_flag;
    status = action_family_9a_runtime_visit(&decoded, before->phase, &world, &kernel_host, &outcome);
    if (status == ACTION_FAMILY_9A_RUNTIME_ERR_FLAG) {
        b->failure = "event flag index outside the window";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (status != ACTION_FAMILY_9A_RUNTIME_OK) {
        b->failure = "raw-0x9a channel stop or event flag store failed";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (outcome.worked != 0u) {
        b->last_world = world;
        if (b->host.store_world != NULL) {
            b->host.store_world(b->host.context, &world);
        }
        if (outcome.transition != 0u) {
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
        }
    }
    b->failure = "none";
    ++b->visits;
    out->phase = outcome.phase;
    out->disposition = outcome.disposition;
    return SCENE_ACTION_HANDLER_OK;
}

const char *session_a9a_failure(const SessionA9aBinding *b)
{
    return b == NULL ? "invalid binding" : b->failure;
}

const Action9AWorld *session_a9a_last_world(const SessionA9aBinding *b)
{
    return b == NULL ? NULL : &b->last_world;
}

unsigned long session_a9a_visits(const SessionA9aBinding *b)
{
    return b == NULL ? 0ul : b->visits;
}
