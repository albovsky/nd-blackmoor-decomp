#include "session_bindings_a45.h"

#include <stdlib.h>
#include <string.h>

#define MS_PER_HOUR 0x36ee80u
#define MS_PER_MINUTE 0xea60u
#define MS_PER_SECOND 0x3e8u
#define PAIR_COUNT 10u
#define NAME_BYTES 49u
#define TEXT_BYTES 33u
#define PAYLOAD_BYTES 100u

struct SessionA45Binding {
    SessionA45Host host;
    const char *failure;
    unsigned long completed;
    unsigned long pending;
};

SessionA45Binding *session_a45_create(const SessionA45Host *host)
{
    SessionA45Binding *b;
    if (host == NULL) {
        return NULL;
    }
    b = (SessionA45Binding *)calloc(1u, sizeof(*b));
    if (b != NULL) {
        b->host = *host;
        b->failure = "none";
    }
    return b;
}

void session_a45_destroy(SessionA45Binding *b)
{
    free(b);
}

static int16_t body_s16(const uint8_t *body, unsigned offset)
{
    return (int16_t)(uint16_t)(body[offset] | (body[offset + 1u] << 8));
}

static uint32_t rec_get(const uint8_t *record, unsigned offset)
{
    return (uint32_t)record[offset] | ((uint32_t)record[offset + 1u] << 8) | ((uint32_t)record[offset + 2u] << 16) |
           ((uint32_t)record[offset + 3u] << 24);
}

static void rec_put(uint8_t *record, unsigned offset, uint32_t value)
{
    record[offset] = (uint8_t)value;
    record[offset + 1u] = (uint8_t)(value >> 8);
    record[offset + 2u] = (uint8_t)(value >> 16);
    record[offset + 3u] = (uint8_t)(value >> 24);
}

/* The 32-bit wrapping sum of 0x428978..0x4289a6 (three imul and two add). */
static uint32_t milliseconds(uint32_t hours, uint32_t minutes, uint32_t seconds)
{
    return hours * MS_PER_HOUR + minutes * MS_PER_MINUTE + seconds * MS_PER_SECOND;
}

/* The seconds operand: the word itself, or, from 5000 on, the loader table word (0x428928..0x42894f). */
static int seconds_operand(SessionA45Binding *b, const uint8_t *body, int32_t *value)
{
    int16_t word = body_s16(body, SESSION_A45_BODY_SECONDS);
    int16_t table;

    if (word < SESSION_A45_VARIABLE_BASE) {
        *value = word;
        return 1;
    }
    if (b->host.variable_word == NULL || !b->host.variable_word(b->host.context, word, &table)) {
        b->failure = "loader word table 0x5adb81 (seconds word >= 5000)";
        return 0;
    }
    *value = table;
    return 1;
}

static int state_counts(uint32_t state)
{
    return state == 1u || state == 2u || state == 5u || state == 6u; /* 0x4288bb..0x4288e5 */
}

static void adjust(uint8_t *r, const uint8_t *body, int32_t seconds, int subtract)
{
    const int32_t h = body_s16(body, SESSION_A45_BODY_HOURS);
    const int32_t m = body_s16(body, SESSION_A45_BODY_MINUTES);
    uint32_t hours = rec_get(r, SESSION_TIMER_HOURS), minutes = rec_get(r, SESSION_TIMER_MINUTES);
    uint32_t secs = rec_get(r, SESSION_TIMER_SECONDS);

    hours = subtract ? hours - (uint32_t)h : hours + (uint32_t)h;
    minutes = subtract ? minutes - (uint32_t)m : minutes + (uint32_t)m;
    secs = subtract ? secs - (uint32_t)seconds : secs + (uint32_t)seconds;
    if (subtract) {                                                 /* 0x428a77..0x428ac2: each below zero becomes zero */
        hours = (int32_t)hours < 0 ? 0u : hours;
        minutes = (int32_t)minutes < 0 ? 0u : minutes;
        secs = (int32_t)secs < 0 ? 0u : secs;
    }
    rec_put(r, SESSION_TIMER_HOURS, hours);
    rec_put(r, SESSION_TIMER_MINUTES, minutes);
    rec_put(r, SESSION_TIMER_SECONDS, secs);
    rec_put(r, SESSION_TIMER_ELAPSED_MS, milliseconds(hours, minutes, secs));
}

static void configure(uint8_t *r, const uint8_t *body, int32_t seconds, int32_t mode, unsigned count)
{
    const uint32_t hours = (uint32_t)(int32_t)body_s16(body, SESSION_A45_BODY_HOURS);
    const uint32_t minutes = (uint32_t)(int32_t)body_s16(body, SESSION_A45_BODY_MINUTES);
    unsigned k;

    rec_put(r, SESSION_TIMER_LIMIT_HOURS, hours);                   /* 0x428b24..0x428b68 */
    rec_put(r, SESSION_TIMER_LIMIT_MINUTES, minutes);
    rec_put(r, SESSION_TIMER_LIMIT_SECONDS, (uint32_t)seconds);
    rec_put(r, SESSION_TIMER_LIMIT_MS, milliseconds(hours, minutes, (uint32_t)seconds));
    memcpy(r + 0x28u, body + SESSION_A45_BODY_NAME, NAME_BYTES);    /* 0x428bb7..0x428bcd */
    memcpy(r + 0x59u, body + SESSION_A45_BODY_TEXT, TEXT_BYTES);    /* 0x428bce..0x428be4 */
    memcpy(r + 0x7au, body + SESSION_A45_BODY_PAYLOAD, PAYLOAD_BYTES); /* 0x428be5..0x428bf9 */
    for (k = 0u; k < PAIR_COUNT; ++k) {                             /* 0x428c05..0x428c35: the word at +0xde + 4k only */
        r[0xdeu + 4u * k] = 0xffu;
        r[0xdeu + 4u * k + 1u] = 0xffu;
    }
    for (k = 0u; k < count; ++k) {                                  /* 0x428c37..0x428c9c: whole dwords */
        memcpy(r + 0xdeu + 4u * k, body + SESSION_A45_BODY_ENTRIES + 4u * k, 4u);
    }
    rec_put(r, SESSION_TIMER_RESERVED_14, 0u);                      /* 0x428c9e */
    rec_put(r, SESSION_TIMER_STATE, (uint32_t)mode);                /* 0x428cab..0x428cb8 */
}

int session_a45_handler(void *context, size_t index, const SceneActionInfo *action, const SceneActionRuntimeState *before,
                        SceneActionHandlerResult *out)
{
    SessionA45Binding *b = (SessionA45Binding *)context;
    const uint8_t *body;
    uint8_t *r;
    int32_t seconds = 0;
    int16_t record_index, mode, count;
    int done = 1;

    (void)index;
    if (b == NULL || action == NULL || before == NULL || out == NULL || action->type != SESSION_A45_TYPE) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    body = action->typed_body;
    if (body == NULL || action->typed_body_length < ACTION_FAMILY_45_PREFIX_BYTES) {
        b->failure = "invalid raw 0x45 body";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    count = body_s16(body, SESSION_A45_BODY_COUNT);
    if (count < 0 || (unsigned)count > ACTION_FAMILY_45_MAX_ENTRIES ||
        action->typed_body_length != ACTION_FAMILY_45_PREFIX_BYTES + (size_t)count * ACTION_FAMILY_45_ENTRY_BYTES) {
        b->failure = "invalid raw 0x45 entry count";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (b->host.time_record == NULL) {
        b->failure = "timer record table 0x585d65";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    record_index = body_s16(body, SESSION_A45_BODY_RECORD);         /* movsx 0x428810 */
    r = record_index < 0 ? NULL : b->host.time_record(b->host.context, (unsigned)record_index);
    if (r == NULL) {
        b->failure = "timer index outside the 10 records the port holds";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    mode = body_s16(body, SESSION_A45_BODY_MODE);                   /* movsx 0x428825; `ja` is unsigned, so negative: no case */
    out->phase = before->phase;                                     /* the phase word is never written */
    if (mode < 0 || (unsigned)mode >= SESSION_A45_MODE_COUNT) {
        done = 0;
    } else if (mode == 0) {
        session_timer_record_clear(r);                              /* 0x428850 */
    } else if (mode == 1 || mode == 2) {
        rec_put(r, SESSION_TIMER_STATE, (uint32_t)mode);            /* 0x428877, 0x42889c */
    } else if (mode <= 4) {
        if (!state_counts(rec_get(r, SESSION_TIMER_STATE))) {
            done = 0;
        } else {
            if (!seconds_operand(b, body, &seconds)) {
                return SCENE_ACTION_HANDLER_UNSUPPORTED;
            }
            adjust(r, body, seconds, mode == 4);
        }
    } else if (rec_get(r, SESSION_TIMER_STATE) != 1u) {              /* 0x428b1b */
        done = 0;
    } else {
        if (!seconds_operand(b, body, &seconds)) {
            return SCENE_ACTION_HANDLER_UNSUPPORTED;
        }
        configure(r, body, seconds, mode, (unsigned)count);
    }
    b->failure = "none";
    if (done) {
        ++b->completed;
        out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;   /* the completion byte := 1 by the arm itself */
    } else {
        ++b->pending;
        out->disposition = SCENE_ACTION_HANDLER_PENDING;            /* the row is visited again next tick */
    }
    return SCENE_ACTION_HANDLER_OK;
}

const char *session_a45_failure(const SessionA45Binding *b)
{
    return b == NULL ? "invalid binding" : b->failure;
}

unsigned long session_a45_completed(const SessionA45Binding *b)
{
    return b == NULL ? 0ul : b->completed;
}

unsigned long session_a45_pending(const SessionA45Binding *b)
{
    return b == NULL ? 0ul : b->pending;
}
