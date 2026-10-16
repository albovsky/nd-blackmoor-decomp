#include "session_bindings_a2e.h"

#include <stdlib.h>
#include <string.h>

struct SessionA2EBinding {
    SessionA2EHost host;
    ActionCoreWorld *world;
    SessionA2EMovie movie;
    const char *failure;
    unsigned long visits;
};

SessionA2EBinding *session_a2e_create(const SessionA2EHost *host, ActionCoreWorld *world)
{
    SessionA2EBinding *b;
    if (host == NULL || world == NULL) {
        return NULL;
    }
    b = (SessionA2EBinding *)calloc(1u, sizeof(*b));
    if (b != NULL) {
        b->host = *host;
        b->world = world;
        b->failure = "none";
    }
    return b;
}

void session_a2e_destroy(SessionA2EBinding *b)
{
    free(b);
}

static void fx(const SessionA2EBinding *b, size_t row, int effect, int32_t value)
{
    if (b->host.observe != NULL) {
        b->host.observe(b->host.context, row, effect, value);
    }
}

int session_a2e_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionA2EBinding *b = (SessionA2EBinding *)context;
    ActionFamily2eDecoded body;
    int32_t mode;

    if (b == NULL || action == NULL || before == NULL || out == NULL || action->type != SESSION_A2E_TYPE) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    b->failure = "none";
    if (action_family_2e_decode(action->typed_body, action->typed_body_length, &body) != ACTION_FAMILY_2E_OK ||
        action->typed_body_length != ACTION_FAMILY_2E_BODY_BYTES) {
        b->failure = "invalid raw-0x2e body";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    mode = (int32_t)(int8_t)body.option_00;                                  /* 0x4cedb5 movsx byte */
    if (b->movie.active != 0) {
        /* Refuse before any effect, so a refused visit leaves the object untouched. */
        if (mode == 0) {
            b->failure = "random movie stop (0x4ceb3b release of the movie set) is not modelled";
            return SCENE_ACTION_HANDLER_UNSUPPORTED;
        }
        if (mode == 1) {
            const int16_t flag = (int16_t)body.word[4];
            if (b->host.set_start_flag == NULL) {
                b->failure = "start flag sink (0x4ced84 stores DAT_005bb1ca)";
                return SCENE_ACTION_HANDLER_UNSUPPORTED;
            }
            if ((int16_t)body.word[0] != SESSION_A2E_NO_SCENE && b->host.transition == NULL) {
                b->failure = "scene-change transition provider (raw 0x2e mode 1)";
                return SCENE_ACTION_HANDLER_UNSUPPORTED;
            }
            if (flag != SESSION_A2E_NO_FLAG && (flag < 0 || (size_t)flag >= b->world->event_flag_count ||
                                                 b->world->event_flags == NULL)) {
                b->failure = "event flag index outside the event flag table";
                return SCENE_ACTION_HANDLER_ERROR;
            }
        }
    }
    b->movie.row = (int32_t)(int16_t)index;                                  /* 0x4ced94 */
    fx(b, index, SESSION_A2E_FX_ROW, b->movie.row);
    b->movie.mode = mode;                                                    /* 0x4cedbb */
    fx(b, index, SESSION_A2E_FX_MODE, mode);
    if (b->movie.active != 0) {
        if (mode == 1) {                                                     /* 0x4ceefd */
            const int16_t flag = (int16_t)body.word[4];
            const int16_t scene = (int16_t)body.word[0];
            if (flag != SESSION_A2E_NO_FLAG) {
                b->world->event_flags[flag] = (int32_t)(int16_t)body.word[5];
                fx(b, index, SESSION_A2E_FX_EVENT_FLAG, flag);
                fx(b, index, SESSION_A2E_FX_EVENT_VALUE, (int32_t)(int16_t)body.word[5]);
            }
            if (scene != SESSION_A2E_NO_SCENE) {
                SceneTransitionRequest request;
                memset(&request, 0, sizeof(request));
                request.target_scene = scene;
                request.opaque_words[0] = (int16_t)body.word[1];
                request.opaque_words[1] = (int16_t)body.word[2];
                request.opaque_words[2] = (int16_t)body.word[3];
                request.opaque_dwords[0] = 0;
                request.opaque_dwords[1] = 0;
                request.opaque_dwords[2] = 1;
                if (b->host.transition(b->host.context, &request) != 0) {
                    b->failure = "scene-change request was refused";
                    return SCENE_ACTION_HANDLER_ERROR;
                }
                fx(b, index, SESSION_A2E_FX_XFER_5BB57B, request.target_scene);
                fx(b, index, SESSION_A2E_FX_XFER_5BB599, request.opaque_words[0]);
                fx(b, index, SESSION_A2E_FX_XFER_5BB595, request.opaque_words[1]);
                fx(b, index, SESSION_A2E_FX_XFER_5C39FF, request.opaque_words[2]);
                fx(b, index, SESSION_A2E_FX_XFER_5BB59B, request.opaque_dwords[0]);
                fx(b, index, SESSION_A2E_FX_XFER_5BB59F, request.opaque_dwords[1]);
                fx(b, index, SESSION_A2E_FX_XFER_5BB5A3, request.opaque_dwords[2]);
                fx(b, index, SESSION_A2E_FX_ENGINE_MODE, 4);
            }
            {
                const int32_t start = (int16_t)body.word[6] != 1 ? 1 : 0;   /* 0x4cef8d..0x4cefac */
                b->host.set_start_flag(b->host.context, start);
                fx(b, index, SESSION_A2E_FX_START_FLAG, start);
            }
            b->movie.state_1de = 2;                                          /* 0x4cefaf */
            fx(b, index, SESSION_A2E_FX_STATE_1DE, 2);
            b->movie.flag_206 = 0;                                           /* 0x4cefb9 */
            fx(b, index, SESSION_A2E_FX_FLAG_206, 0);
        } else if (mode == 2) {                                              /* 0x4cefc8 */
            if (b->movie.pending_25a == 0) {
                b->movie.state_1de = 0;
                fx(b, index, SESSION_A2E_FX_STATE_1DE, 0);
            } else {
                b->movie.state_1de = 3;
                fx(b, index, SESSION_A2E_FX_STATE_1DE, 3);
                b->movie.pending_25a = 0;
                fx(b, index, SESSION_A2E_FX_PENDING_25A, 0);
            }
            b->movie.flag_206 = 1;
            fx(b, index, SESSION_A2E_FX_FLAG_206, 1);
        }
    }
    fx(b, index, SESSION_A2E_FX_DONE, 1);                                    /* 0x4cf019 */
    ++b->visits;
    out->phase = before->phase;                                              /* the phase word is not written */
    out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;
    return SCENE_ACTION_HANDLER_OK;
}

const char *session_a2e_failure(const SessionA2EBinding *b)
{
    return b == NULL ? "invalid binding" : b->failure;
}

const SessionA2EMovie *session_a2e_movie(const SessionA2EBinding *b)
{
    return b == NULL ? NULL : &b->movie;
}

void session_a2e_set_movie(SessionA2EBinding *b, const SessionA2EMovie *movie)
{
    if (b != NULL && movie != NULL) {
        b->movie = *movie;
    }
}

unsigned long session_a2e_visits(const SessionA2EBinding *b)
{
    return b == NULL ? 0ul : b->visits;
}
