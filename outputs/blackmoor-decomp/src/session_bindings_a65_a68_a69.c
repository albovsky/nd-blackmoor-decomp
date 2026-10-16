#include "session_bindings_a65_a68_a69.h"

#include <stdlib.h>
#include <string.h>

#define RECORD_STATE_OFFSET 0x00u
#define RECORD_SOUND_OFFSET 0x28u
#define RECORD_FLAG_PAIR_OFFSET 0xdeu
#define RECORD_FLAG_PAIR_COUNT 10u

struct SessionA65Binding {
    SessionA65Host host;
    const char *failure;
    unsigned long visits65;
    unsigned long visits68;
    unsigned long visits69;
};

SessionA65Binding *session_a65_create(const SessionA65Host *host)
{
    SessionA65Binding *b;
    if (host == NULL) {
        return NULL;
    }
    b = (SessionA65Binding *)calloc(1u, sizeof(*b));
    if (b != NULL) {
        b->host = *host;
        b->failure = "none";
    }
    return b;
}

void session_a65_destroy(SessionA65Binding *b)
{
    free(b);
}

void session_timer_record_clear(uint8_t *record)
{
    static const char no_sound[] = "NO SOUND"; /* the string at 0x545dd4 copied by 0x433c21..0x433c49 */
    unsigned k;

    memset(record, 0, SESSION_TIMER_RECORD_BYTES);                     /* 0x433be0..0x433bec: 0x41 dwords and a word */
    for (k = 0u; k < RECORD_FLAG_PAIR_COUNT; ++k) {                    /* 0x433bee..0x433c16 */
        record[RECORD_FLAG_PAIR_OFFSET + 4u * k] = 0xffu;
        record[RECORD_FLAG_PAIR_OFFSET + 4u * k + 1u] = 0xffu;
    }
    memcpy(record + RECORD_SOUND_OFFSET, no_sound, sizeof no_sound);   /* 0x433c21..0x433c49 (the NUL included) */
}

static int check(SessionA65Binding *b, const SceneActionInfo *action, const SceneActionRuntimeState *before,
                 SceneActionHandlerResult *out, uint8_t type, size_t body_bytes)
{
    if (b == NULL || action == NULL || before == NULL || out == NULL || action->type != type) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (action->typed_body_length != body_bytes || action->typed_body == NULL) {
        b->failure = "invalid one-byte body";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    return SCENE_ACTION_HANDLER_OK;
}

static int finish(SessionA65Binding *b, const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    b->failure = "none";
    out->phase = before->phase;                                    /* the phase word is not written */
    out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;     /* the completion byte := 1 by the arm itself */
    return SCENE_ACTION_HANDLER_OK;
}

int session_a65_handler(void *context, size_t index, const SceneActionInfo *action, const SceneActionRuntimeState *before,
                        SceneActionHandlerResult *out)
{
    SessionA65Binding *b = (SessionA65Binding *)context;
    int status;

    (void)index;
    status = check(b, action, before, out, SESSION_A65_TYPE, ACTION_FAMILY_65_BODY_BYTES);
    if (status != SCENE_ACTION_HANDLER_OK) {
        return status;
    }
    if (b->host.save_game == NULL) {
        b->failure = "save routine 0x4d7a15 (SAVE CONTINUE)";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    b->host.save_game(b->host.context, SESSION_A65_SAVE_NAME, 0); /* 0x428623..0x42862d; the body byte is never read */
    ++b->visits65;
    return finish(b, before, out);
}

static int timer_handler(SessionA65Binding *b, const SceneActionInfo *action, const SceneActionRuntimeState *before,
                         SceneActionHandlerResult *out, uint8_t type, int start)
{
    uint8_t *record;
    int status = check(b, action, before, out, type, ACTION_FAMILY_68_BODY_BYTES);

    if (status != SCENE_ACTION_HANDLER_OK) {
        return status;
    }
    if (b->host.time_record == NULL) {
        b->failure = "timer record table 0x585d65";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    record = b->host.time_record(b->host.context, (unsigned)action->typed_body[0]); /* an unsigned byte, 0x428715 */
    if (record == NULL) {
        b->failure = "timer index outside the 10 records the port holds";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    session_timer_record_clear(record);                                              /* 0x433bd2 */
    if (start) {
        record[RECORD_STATE_OFFSET] = (uint8_t)SESSION_A68_STATE_RUNNING;           /* 0x428744: dword := 1 */
    }
    return finish(b, before, out);
}

int session_a68_handler(void *context, size_t index, const SceneActionInfo *action, const SceneActionRuntimeState *before,
                        SceneActionHandlerResult *out)
{
    SessionA65Binding *b = (SessionA65Binding *)context;
    int status;

    (void)index;
    status = timer_handler(b, action, before, out, SESSION_A68_TYPE, 1);
    if (status == SCENE_ACTION_HANDLER_OK) {
        ++b->visits68;
    }
    return status;
}

int session_a69_handler(void *context, size_t index, const SceneActionInfo *action, const SceneActionRuntimeState *before,
                        SceneActionHandlerResult *out)
{
    SessionA65Binding *b = (SessionA65Binding *)context;
    int status;

    (void)index;
    status = timer_handler(b, action, before, out, SESSION_A69_TYPE, 0);
    if (status == SCENE_ACTION_HANDLER_OK) {
        ++b->visits69;
    }
    return status;
}

const char *session_a65_failure(const SessionA65Binding *b)
{
    return b == NULL ? "invalid binding" : b->failure;
}

unsigned long session_a65_visits(const SessionA65Binding *b)
{
    return b == NULL ? 0ul : b->visits65;
}

unsigned long session_a68_visits(const SessionA65Binding *b)
{
    return b == NULL ? 0ul : b->visits68;
}

unsigned long session_a69_visits(const SessionA65Binding *b)
{
    return b == NULL ? 0ul : b->visits69;
}
