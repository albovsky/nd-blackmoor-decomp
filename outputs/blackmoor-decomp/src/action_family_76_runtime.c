#include "action_family_76_runtime.h"

#include <string.h>

/* Body offsets (see the header). */
enum {
    B_FONT = 0x000,
    B_BLINK = 0x002,
    B_RECT_F1 = 0x004,
    B_RECT_F2 = 0x014,
    B_RECT_BG = 0x024,
    B_COUNT_A = 0x034,
    B_WORDS_A = 0x036,
    B_COUNT_B = 0x0db,
    B_WORDS_B = 0x0dd,
    B_CORRECT = 0x182,
    B_SUCCESS_SOUND = 0x19b,
    B_SUCCESS_CHANNEL = 0x1bc,
    B_WRONG = 0x1cc,
    B_WRONG_SOUND = 0x1e5,
    B_WRONG_CHANNEL = 0x206,
    B_CANCEL = 0x216,
    B_CANCEL_RECT = 0x22f
};

#define WORD_STRIDE 0x21u
#define KEY_BACKSPACE 0x08
#define KEY_ENTER 0x0d
#define CURSOR '-'

static const char NO_SOUND[9] = {'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0};

static inline uint32_t rd32u(const uint8_t *p, size_t off)
{
    return (uint32_t)pwd_rd32(p, off);
}

static inline void wr32(uint8_t *p, size_t off, uint32_t v)
{
    p[off] = (uint8_t)v;
    p[off + 1] = (uint8_t)(v >> 8);
    p[off + 2] = (uint8_t)(v >> 16);
    p[off + 3] = (uint8_t)(v >> 24);
}

static void observe(const PwdHost *host, int effect, int32_t a, int32_t b)
{
    if (host != NULL && host->observe != NULL) host->observe(host->context, effect, a, b);
}

void pwd_state_reset(PwdState *state)
{
    if (state != NULL) memset(state->b, 0, sizeof state->b);
}

void pwd_new_game(PwdState *state)
{
    if (state != NULL) state->b[PWD_S_ACTIVE] = 0;
}

static int has_nul(const uint8_t *p, size_t off, size_t n)
{
    return memchr(p + off, 0, n) != NULL;
}

int pwd_validate_body(const uint8_t *body, size_t length, const char **failure)
{
    const char *why = NULL;
    if (body == NULL) {
        why = "no body";
    } else if (length != PWD_BODY_BYTES) {
        why = "body length is not 575";
    } else if (pwd_rd16(body, B_FONT) < 0 || pwd_rd16(body, B_FONT) > PWD_MAX_FONT) {
        why = "font index outside 0..17";
    } else if (pwd_rd16(body, B_COUNT_A) < 0 || pwd_rd16(body, B_COUNT_A) > PWD_MAX_ACCEPTED) {
        why = "accepted word count A outside 0..5";
    } else if (pwd_rd16(body, B_COUNT_B) < 0 || pwd_rd16(body, B_COUNT_B) > PWD_MAX_ACCEPTED) {
        why = "accepted word count B outside 0..5";
    } else if (!has_nul(body, B_SUCCESS_SOUND, WORD_STRIDE) || !has_nul(body, B_WRONG_SOUND, WORD_STRIDE)) {
        why = "unterminated sound name";
    } else {
        int i;
        for (i = 0; i < pwd_rd16(body, B_COUNT_A); ++i) {
            if (!has_nul(body, B_WORDS_A + (size_t)i * WORD_STRIDE, WORD_STRIDE)) why = "unterminated accepted word of field 1";
        }
        for (i = 0; i < pwd_rd16(body, B_COUNT_B); ++i) {
            if (!has_nul(body, B_WORDS_B + (size_t)i * WORD_STRIDE, WORD_STRIDE)) why = "unterminated accepted word of field 2";
        }
    }
    if (failure != NULL) *failure = why;
    return why == NULL ? PWD_OK : PWD_ERR_BODY;
}

int pwd_char_accepted(int8_t ch)
{
    const int c = ch;
    if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9')) return 1;
    switch (c) {
    case '\b': case '\r': case ' ': case '.': case ',': case '?': case '!': case '/': case '$': case '(': case ')':
    case '&': case ':': case ';': case '+': case '%': case '=': case '-':
    case -0x20: case -0x19: case -0x18: case -0x17: case -0x16: case -0x15: case -0xc: case -0x40: case -0x1e: case -0x12:
    case -7: case -0x3c: case -0x1c: case -0x2a: case -10: case -0x24: case -4: case -0x5f: case -0x41: case -0x2f:
    case -0xf: case -0x37: case -0x1f: case -0x13: case -0xd: case -6: case -0x21:
        return 1;
    default:
        return 0;
    }
}

int pwd_key(PwdState *state, int8_t ch)
{
    if (state == NULL) return 0;
    if (state->b[PWD_S_ACTIVE] != 0 && state->b[PWD_S_KEY_PENDING] == 0 && pwd_char_accepted(ch)) {
        state->b[PWD_S_KEY] = (uint8_t)ch;
        state->b[PWD_S_KEY_PENDING] = 1;
        return 1;
    }
    return 0;
}

/* 0x50d0bc in the C locale: 'a'..'z' to upper case. */
static void upper(char *s)
{
    for (; *s != '\0'; ++s) {
        if (*s > '`' && *s < '{') *s = (char)(*s - 0x20);
    }
}

/* 0x50d8e0 reduced to its use here: non-NULL when `needle` occurs in `hay` (an empty needle always does). */
static int contains(const char *hay, const char *needle)
{
    return strstr(hay, needle) != NULL;
}

static uint32_t state_dword(const PwdState *s, size_t off)
{
    return rd32u(s->b, off);
}

static int16_t state_row(const PwdState *s)
{
    return pwd_rd16(s->b, PWD_S_ROW);
}

/* 0x430b9a: the blinking cursor of one field. */
static int blink(PwdState *state, const uint8_t *body, uint8_t *field, const PwdHost *host)
{
    const size_t len = strlen((const char *)field);
    const uint32_t phase = state_dword(state, PWD_S_BLINK);
    uint32_t now;
    if (phase == 0) {
        if (len == 0) {
            field[0] = CURSOR;
        } else if (field[len - 1] != CURSOR) {
            field[len] = CURSOR;
        }
    } else if (phase == 1) {
        if (len != 0 && field[len - 1] == CURSOR) field[len - 1] = 0;
    }
    now = host->tick(host->context);
    observe(host, PWD_FX_TICK, (int32_t)now, 0);
    if (rd32u(state->b, PWD_S_DEADLINE) <= now) {
        wr32(state->b, PWD_S_BLINK, phase == 0 ? 1u : 0u);
        now = host->tick(host->context);
        observe(host, PWD_FX_TICK, (int32_t)now, 0);
        wr32(state->b, PWD_S_DEADLINE, now + (uint32_t)(int32_t)pwd_rd16(body, B_BLINK));
    }
    return PWD_OK;
}

/* One Enter on a field: 1 when the typed text (upper case) contains one of the accepted words (upper case). The original stops at
 * the first hit. For field 2 (the loop of state 1) the miss test sits inside the loop body: a miss before the hit already declares
 * the answer wrong, and a later hit still stores correct and state 5 while the wrong flag stays. */
static int check_words(const uint8_t *body, const uint8_t *field, size_t words_off, int count, PwdState *state, int second)
{
    char typed[PWD_TEXT_BYTES + 1];
    int matched = 0;
    int i;
    memcpy(typed, field, PWD_TEXT_BYTES);
    typed[PWD_TEXT_BYTES] = 0;
    upper(typed);
    for (i = 0; i < count; ++i) {
        char word[PWD_TEXT_BYTES + 1];
        memcpy(word, body + words_off + (size_t)i * WORD_STRIDE, PWD_TEXT_BYTES);
        word[PWD_TEXT_BYTES] = 0;
        upper(word);
        if (contains(typed, word)) {
            matched = 1;
            if (!second && pwd_rd16(body, B_COUNT_B) != 0) {
                wr32(state->b, PWD_S_STATE, PWD_STATE_FIELD2); /* 0x430137: a hit in field 1 with a second field only moves on to field 2 */
            } else {
                state->b[PWD_S_CORRECT] = 1;
                wr32(state->b, PWD_S_STATE, PWD_STATE_SUCCESS_SOUND);
            }
            break;
        }
        if (second) {
            state->b[PWD_S_WRONG] = 1;
            wr32(state->b, PWD_S_STATE, PWD_STATE_WRONG_SOUND);
        }
    }
    return matched;
}

static int step_phase0(PwdState *state, const uint8_t *body, int16_t row, const PwdHost *host)
{
    int32_t vx = 0, vy = 0;
    int32_t j;
    uint32_t t;
    if (host->view_origin(host->context, &vx, &vy) != 0) return PWD_ERR_HOST;
    state->b[PWD_S_ACTIVE] = 1;
    state->b[PWD_S_CORRECT] = 0;
    observe(host, PWD_FX_START_FLAG, 1, 0);
    state->b[PWD_S_ROW] = (uint8_t)row;
    state->b[PWD_S_ROW + 1] = (uint8_t)((uint16_t)row >> 8);
    state->b[PWD_S_WRONG] = 0;
    state->b[PWD_S_CANCEL] = 0;
    state->b[PWD_S_KEY_PENDING] = 0;
    if (host->font_acquire(host->context, pwd_rd16(body, B_FONT)) != 0) return PWD_ERR_HOST;
    observe(host, PWD_FX_FONT_ACQUIRE, pwd_rd16(body, B_FONT), 0);
    /* rectangles: background (0x24), field 1 (4), field 2 (0x14); even words shift by x, odd by y */
    for (j = 0; j < 12; ++j) {
        const size_t src = (j < 4) ? (size_t)(0x24 + 4 * j) : (size_t)(4 + 4 * (j - 4));
        const size_t dst = PWD_S_RECT_BG + (size_t)4 * (size_t)j;
        const uint32_t origin = (uint32_t)((j & 1) ? vy : vx);
        wr32(state->b, dst, rd32u(body, src) + origin);
    }
    memset(state->b + PWD_S_FIELD1, 0, PWD_TEXT_BYTES);
    memset(state->b + PWD_S_FIELD2, 0, PWD_TEXT_BYTES);
    observe(host, PWD_FX_ENTRY_VISIBLE, 1, 0);
    t = host->tick(host->context);
    observe(host, PWD_FX_TICK, (int32_t)t, 0);
    wr32(state->b, PWD_S_DEADLINE, t + (uint32_t)(int32_t)pwd_rd16(body, B_BLINK));
    wr32(state->b, PWD_S_STATE, 0);
    wr32(state->b, PWD_S_BLINK, 0);
    return PWD_OK;
}

/* The typed key of field 1 (index 0) or field 2 (index 1) in states 0 and 1. */
static int step_typing(PwdState *state, const uint8_t *body, const PwdHost *host, int second)
{
    uint8_t *field = state->b + (second ? PWD_S_FIELD2 : PWD_S_FIELD1);
    const size_t rect = second ? 0x14u : 0x04u;
    const size_t words = second ? B_WORDS_B : B_WORDS_A;
    const int count = second ? pwd_rd16(body, B_COUNT_B) : pwd_rd16(body, B_COUNT_A);
    const int16_t font = pwd_rd16(body, B_FONT);
    if (state->b[PWD_S_KEY_PENDING] != 0) {
        const uint8_t key = state->b[PWD_S_KEY];
        size_t len = strlen((const char *)field);
        if (len != 0 && field[len - 1] == CURSOR) field[len - 1] = 0;
        if (key == KEY_BACKSPACE) {
            len = strlen((const char *)field);
            if (len != 0) field[len - 1] = 0;
        } else if (key == KEY_ENTER) {
            if (!check_words(body, field, words, count, state, second) && !second) {
                state->b[PWD_S_WRONG] = 1;
                wr32(state->b, PWD_S_STATE, PWD_STATE_WRONG_SOUND);
            }
        } else {
            len = strlen((const char *)field);
            if (len + 2 < PWD_TEXT_BYTES) {
                int16_t width = 0;
                int32_t limit;
                if (host->text_width(host->context, font, (const char *)field, &width) != 0) return PWD_ERR_HOST;
                observe(host, PWD_FX_TEXT_WIDTH, width, 0);
                limit = (int32_t)(rd32u(body, rect + 8) - rd32u(body, rect) - 0x14u);
                if ((int32_t)width < limit) field[len] = key;
            }
        }
        state->b[PWD_S_KEY_PENDING] = 0;
    }
    if (second) {
        if (state->b[PWD_S_WRONG] == 0 && state->b[PWD_S_CORRECT] == 0) return blink(state, body, field, host);
    } else if (state->b[PWD_S_WRONG] == 0 && state_dword(state, PWD_S_STATE) != 1) {
        return blink(state, body, field, host);
    }
    return PWD_OK;
}

static int sound_start(PwdState *state, const uint8_t *body, size_t name, size_t channel, uint32_t next, uint32_t *phase,
                       const PwdHost *host)
{
    if (memcmp(body + name, NO_SOUND, sizeof NO_SOUND) == 0) {
        *phase = 2;
        observe(host, PWD_FX_PHASE, 2, 0);
        return PWD_OK;
    }
    if (host->sound_prepare(host->context, body + name) != 0) return PWD_ERR_HOST;
    observe(host, PWD_FX_SOUND_PREPARE, (int32_t)name, 0);
    if (host->sound_play(host->context, pwd_rd16(body, channel)) != 0) return PWD_ERR_HOST;
    observe(host, PWD_FX_SOUND_PLAY, pwd_rd16(body, channel), 0);
    wr32(state->b, PWD_S_STATE, next);
    return PWD_OK;
}

static int sound_wait(const uint8_t *body, size_t name, size_t channel, uint32_t *phase, const PwdHost *host)
{
    int32_t busy = 0;
    if (host->sound_busy(host->context, pwd_rd16(body, channel), &busy) != 0) return PWD_ERR_HOST;
    observe(host, PWD_FX_SOUND_BUSY, pwd_rd16(body, channel), busy);
    if (busy == 0) {
        if (host->sound_stop(host->context, body + name) != 0) return PWD_ERR_HOST;
        observe(host, PWD_FX_SOUND_STOP, (int32_t)name, 0);
        *phase = 2;
        observe(host, PWD_FX_PHASE, 2, 0);
    }
    return PWD_OK;
}

/* A finish block at `base` (scene cells, start flag, mode) and the event flag at base + 0x16 / base + 0x18. */
static int finish_block(const uint8_t *body, size_t base, const PwdHost *host)
{
    if (pwd_rd16(body, base) != PWD_NO_SCENE) {
        PwdTransition t;
        t.scene = pwd_rd16(body, base);
        t.word[0] = pwd_rd16(body, base + 2);
        t.word[1] = pwd_rd16(body, base + 4);
        t.word[2] = pwd_rd16(body, base + 6);
        t.dword[0] = pwd_rd32(body, base + 8);
        t.dword[1] = pwd_rd32(body, base + 12);
        t.dword[2] = pwd_rd32(body, base + 16);
        observe(host, PWD_FX_XFER_5BB57B, t.scene, 0);
        observe(host, PWD_FX_XFER_5BB599, t.word[0], 0);
        observe(host, PWD_FX_XFER_5BB595, t.word[1], 0);
        observe(host, PWD_FX_XFER_5C39FF, t.word[2], 0);
        observe(host, PWD_FX_XFER_5BB59B, t.dword[0], 0);
        observe(host, PWD_FX_XFER_5BB59F, t.dword[1], 0);
        observe(host, PWD_FX_XFER_5BB5A3, t.dword[2], 0);
        observe(host, PWD_FX_START_FLAG, pwd_rd16(body, base + 20) != 1, 0);
        observe(host, PWD_FX_ENGINE_MODE, 4, 0);
        if (host->transition(host->context, &t) != 0) return PWD_ERR_HOST;
    }
    if (pwd_rd16(body, base + 22) != PWD_NO_FLAG) {
        const int16_t index = pwd_rd16(body, base + 22);
        const uint32_t value = body[base + 24];
        observe(host, PWD_FX_EVENT_FLAG, index, (int32_t)value);
        if (host->store_event_flag(host->context, index, value) != 0) return PWD_ERR_HOST;
    }
    return PWD_OK;
}

int pwd_step(PwdState *state, const uint8_t *body, size_t body_length, int16_t row, uint32_t phase, const PwdHost *host,
             PwdResult *result, const char **failure)
{
    int rc;
    uint32_t next = phase;
    if (failure != NULL) *failure = NULL;
    if (state == NULL || body == NULL || host == NULL || result == NULL || host->view_origin == NULL || host->font_acquire == NULL ||
        host->font_release == NULL || host->text_width == NULL || host->tick == NULL || host->sound_prepare == NULL ||
        host->sound_stop == NULL || host->sound_play == NULL || host->sound_busy == NULL || host->event_flag_invalid == NULL ||
        host->transition == NULL || host->store_event_flag == NULL)
        return PWD_ERR_ARGUMENT;
    memset(result, 0, sizeof *result);
    rc = pwd_validate_body(body, body_length, failure);
    if (rc != PWD_OK) return rc;
    if (phase > 2) {
        if (failure != NULL) *failure = "row phase outside 0..2";
        return PWD_ERR_UNSUPPORTED;
    }
    if (phase != 0 && (state->b[PWD_S_ACTIVE] == 0 || state_row(state) != row)) {
        if (failure != NULL) *failure = "phase 1 or 2 without phase 0 for this row";
        return PWD_ERR_UNSUPPORTED;
    }
    if (phase == 2) {
        const size_t block = state->b[PWD_S_CANCEL] != 0 ? (size_t)B_CANCEL : state->b[PWD_S_WRONG] != 0 ? (size_t)B_WRONG : (size_t)B_CORRECT;
        const int16_t flag = pwd_rd16(body, block + 0x16);
        const int used = state->b[PWD_S_CANCEL] != 0 || state->b[PWD_S_WRONG] != 0 || state->b[PWD_S_CORRECT] != 0;
        if (used && flag != PWD_NO_FLAG && host->event_flag_invalid(host->context, flag)) {
            if (failure != NULL) *failure = "event flag index outside the host window";
            return PWD_ERR_UNSUPPORTED;
        }
    }
    switch (phase) {
    case 0:
        rc = step_phase0(state, body, row, host);
        if (rc != PWD_OK) return rc;
        next = 1;
        observe(host, PWD_FX_PHASE, 1, 0);
        result->initialized = 1;
        break;
    case 1:
        switch (state_dword(state, PWD_S_STATE)) {
        case PWD_STATE_FIELD1:
            rc = step_typing(state, body, host, 0);
            break;
        case PWD_STATE_FIELD2:
            rc = step_typing(state, body, host, 1);
            break;
        case PWD_STATE_WRONG_SOUND:
            rc = sound_start(state, body, B_WRONG_SOUND, B_WRONG_CHANNEL, PWD_STATE_WRONG_WAIT, &next, host);
            break;
        case PWD_STATE_WRONG_WAIT:
            rc = sound_wait(body, B_WRONG_SOUND, B_WRONG_CHANNEL, &next, host);
            break;
        case PWD_STATE_SUCCESS_WAIT:
            rc = sound_wait(body, B_SUCCESS_SOUND, B_SUCCESS_CHANNEL, &next, host);
            break;
        case PWD_STATE_SUCCESS_SOUND:
            rc = sound_start(state, body, B_SUCCESS_SOUND, B_SUCCESS_CHANNEL, PWD_STATE_SUCCESS_WAIT, &next, host);
            break;
        default:
            rc = PWD_OK; /* the original switch has no other case */
            break;
        }
        if (rc != PWD_OK) return rc;
        break;
    default: { /* phase 2 */
        const int16_t font = pwd_rd16(body, B_FONT);
        observe(host, PWD_FX_START_FLAG, 1, 0);
        state->b[PWD_S_ACTIVE] = 0;
        if (host->font_release(host->context, font) != 0) return PWD_ERR_HOST;
        observe(host, PWD_FX_FONT_RELEASE, font, 0);
        observe(host, PWD_FX_ENTRY_VISIBLE, 0, 0);
        if (state->b[PWD_S_CANCEL] == 0) {
            if (state->b[PWD_S_WRONG] == 0) {
                if (state->b[PWD_S_CORRECT] != 0) rc = finish_block(body, B_CORRECT, host);
                else rc = PWD_OK;
            } else {
                rc = finish_block(body, B_WRONG, host);
            }
        } else {
            rc = finish_block(body, B_CANCEL, host);
        }
        if (rc != PWD_OK) return rc;
        observe(host, PWD_FX_COMPLETE, row, 0);
        result->completed = 1;
        break;
    }
    }
    result->phase_after = next;
    return PWD_OK;
}

int pwd_pointer(const PwdState *state, const uint8_t *body, size_t body_length, int32_t x, int32_t y, PwdPointerResult *out)
{
    if (state == NULL || body == NULL || out == NULL) return PWD_ERR_ARGUMENT;
    out->hit = 0;
    out->candidate = -1;
    out->cursor_kind = -1;
    if (state->b[PWD_S_ACTIVE] == 0) return PWD_OK;
    if (body_length != PWD_BODY_BYTES) return PWD_ERR_BODY;
    if (y >= pwd_rd32(body, B_CANCEL_RECT + 4) && y <= pwd_rd32(body, B_CANCEL_RECT + 12) &&
        x >= pwd_rd32(body, B_CANCEL_RECT) && x <= pwd_rd32(body, B_CANCEL_RECT + 8)) {
        out->hit = 1;
        out->candidate = PWD_CANDIDATE_CANCEL;
        out->cursor_kind = PWD_CURSOR_KIND_CANCEL;
    }
    return PWD_OK;
}

int pwd_click(PwdState *state, int32_t candidate, PwdClickResult *out)
{
    if (state == NULL || out == NULL) return PWD_ERR_ARGUMENT;
    memset(out, 0, sizeof *out);
    if (state->b[PWD_S_ACTIVE] != 0 && state->b[PWD_S_CORRECT] == 0 && candidate == PWD_CANDIDATE_CANCEL) {
        state->b[PWD_S_CANCEL] = 1;
        out->fired = 1;
        out->row = state_row(state);
        out->phase = 2;
    }
    return PWD_OK;
}

int pwd_invalidate(const PwdState *state)
{
    return state != NULL && state->b[PWD_S_ACTIVE] != 0;
}

void pwd_cleanup(PwdState *state)
{
    if (state != NULL) state->b[PWD_S_ACTIVE] = 0;
}

/* FL-12: original FUN_004d07e7 is this function (function ledger acceptance). */
int pwd_render(const PwdState *state, const uint8_t *body, size_t body_length, PwdRenderResult *out)
{
    PwdOp *op;
    int i;
    if (state == NULL || body == NULL || out == NULL) return PWD_ERR_ARGUMENT;
    memset(out, 0, sizeof *out);
    if (body_length != PWD_BODY_BYTES) return PWD_ERR_BODY;
    op = &out->op[0];
    op->kind = PWD_OP_BLIT;
    for (i = 0; i < 4; ++i) {
        op->src[i] = pwd_rd32(body, B_RECT_BG + (size_t)4 * i);
        op->dst[i] = pwd_rd32(state->b, PWD_S_RECT_BG + (size_t)4 * i);
    }
    out->count = 1;
    op = &out->op[1];
    op->kind = PWD_OP_TEXT;
    op->field = 1;
    op->font = pwd_rd16(body, B_FONT);
    op->x = (int16_t)pwd_rd32(state->b, PWD_S_RECT_F1);
    op->y = (int16_t)pwd_rd32(state->b, PWD_S_RECT_F1 + 12);
    memcpy(op->text, state->b + PWD_S_FIELD1, PWD_TEXT_BYTES);
    op->text[PWD_TEXT_BYTES] = 0;
    out->count = 2;
    if (state->b[PWD_S_FIELD2] != 0) {
        op = &out->op[2];
        op->kind = PWD_OP_TEXT;
        op->field = 2;
        op->font = pwd_rd16(body, B_FONT);
        op->x = (int16_t)pwd_rd32(state->b, PWD_S_RECT_F2);
        op->y = (int16_t)pwd_rd32(state->b, PWD_S_RECT_F2 + 12);
        memcpy(op->text, state->b + PWD_S_FIELD2, PWD_TEXT_BYTES);
        op->text[PWD_TEXT_BYTES] = 0;
        out->count = 3;
    }
    return PWD_OK;
}
