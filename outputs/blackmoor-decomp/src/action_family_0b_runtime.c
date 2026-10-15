#include "action_family_0b_runtime.h"

#include <string.h>

static int16_t rd_s16(const uint8_t *p)
{
    const uint16_t bits = (uint16_t)((uint16_t)p[0] | ((uint16_t)p[1] << 8));
    return bits <= (uint16_t)INT16_MAX ? (int16_t)bits : (int16_t)(-1 - (int32_t)(UINT16_MAX - bits));
}

static int32_t rd_s32(const uint8_t *p)
{
    const uint32_t bits = (uint32_t)p[0] | ((uint32_t)p[1] << 8) | ((uint32_t)p[2] << 16) |
                          ((uint32_t)p[3] << 24);
    return bits <= (uint32_t)INT32_MAX ? (int32_t)bits : (int32_t)(-1 - (int32_t)(UINT32_MAX - bits));
}

/* mov dx, word [dword]: the low word of a dword, as a signed word. */
static int16_t low_word(int32_t value)
{
    const uint16_t bits = (uint16_t)((uint32_t)value & 0xffffu);
    return bits <= (uint16_t)INT16_MAX ? (int16_t)bits : (int16_t)(-1 - (int32_t)(UINT16_MAX - bits));
}

static void fx(const Action17Host *host, int effect, int32_t value)
{
    if (host != NULL && host->observe != NULL) {
        host->observe(host->context, effect, value);
    }
}

int action0b_load(const uint8_t *body, size_t body_length, Action0bPayload *out,
                  const char **failure)
{
    Action0bPayload p;
    size_t i;
    if (failure != NULL) {
        *failure = "none";
    }
    if (body == NULL || out == NULL) {
        if (failure != NULL) {
            *failure = "null argument";
        }
        return ACTION17_ERR_ARGUMENT;
    }
    if (body_length != ACTION0B_BODY_BYTES) {
        if (failure != NULL) {
            *failure = "raw 0x0b typed body is not 24 bytes";
        }
        return ACTION17_ERR_BOUNDS;
    }
    memset(&p, 0, sizeof(p));
    /* 0x40b860..0x40b8bc: word copies body+0 -> +0, +2 -> +2, +4 -> +4, +6 -> +8. */
    p.cursor = rd_s16(body);
    p.target = rd_s16(body + 2);
    p.word_04 = rd_s16(body + 4);
    p.word_08 = rd_s16(body + 6);
    /* 0x40b8c0..0x40b8ef: four dword copies body+8.. -> +0x18.. */
    for (i = 0; i < 4u; ++i) {
        p.rect[i] = rd_s32(body + 8u + 4u * i);
    }
    /* 0x40b8f2..0x40b96c: loader constants. */
    p.word_06 = 0;
    p.dword_0a = 0;
    p.dword_0e = 0;
    p.dword_12 = 1;
    p.frame = 0;
    *out = p;
    return ACTION17_OK;
}

int action0b_step(const Action0bPayload *payload, uint32_t phase, Action17Slot *slot,
                  Action17World *world, const Action17Host *host, Action17Result *result)
{
    Action17Slot s;
    Action17World w;
    Action17Result r;
    int phase_one = 0;

    if (payload == NULL || slot == NULL || world == NULL || result == NULL) {
        return ACTION17_ERR_ARGUMENT;
    }
    s = *slot;
    w = *world;
    memset(&r, 0, sizeof(r));
    r.phase_after = phase;
    r.matched_record = -1;

    if (phase == 0u) {
        /* 0x42aea9: start flag, the rectangle cells (mov dx, word [payload + 0x18/0x1c/0x20/0x24]),
         * then phase := 1 and fall into phase 1. */
        w.start_flag_5bb1ca = 1;
        fx(host, ACTION17_FX_START_FLAG, 1);
        s.left = low_word(payload->rect[0]);
        fx(host, ACTION17_FX_LEFT, s.left);
        s.top = low_word(payload->rect[1]);
        fx(host, ACTION17_FX_TOP, s.top);
        s.right = low_word(payload->rect[2]);
        fx(host, ACTION17_FX_RIGHT, s.right);
        s.bottom = low_word(payload->rect[3]);
        fx(host, ACTION17_FX_BOTTOM, s.bottom);
        r.phase_after = 1u;
        fx(host, ACTION17_FX_PHASE, 1);
        phase_one = 1;
    } else if (phase == 1u) {
        phase_one = 1;
    } else if (phase == 2u) {
        /* 0x42afa9: direct completion, the scene-change cells from the payload, mode 4. */
        s.done = 1u;
        fx(host, ACTION17_FX_DONE, 1);
        w.xfer_5bb57b = payload->target;
        fx(host, ACTION17_FX_XFER_5BB57B, w.xfer_5bb57b);
        w.xfer_5bb599 = payload->word_04;
        fx(host, ACTION17_FX_XFER_5BB599, w.xfer_5bb599);
        w.xfer_5bb595 = payload->word_06;
        fx(host, ACTION17_FX_XFER_5BB595, w.xfer_5bb595);
        w.xfer_5c39ff = payload->word_08;
        fx(host, ACTION17_FX_XFER_5C39FF, w.xfer_5c39ff);
        w.xfer_5bb59b = payload->dword_0a;
        fx(host, ACTION17_FX_XFER_5BB59B, w.xfer_5bb59b);
        w.xfer_5bb59f = payload->dword_0e;
        fx(host, ACTION17_FX_XFER_5BB59F, w.xfer_5bb59f);
        w.xfer_5bb5a3 = payload->dword_12;
        fx(host, ACTION17_FX_XFER_5BB5A3, w.xfer_5bb5a3);
        w.mode_583999 = 4;
        fx(host, ACTION17_FX_MODE, 4);
        r.finished = 1u;
    }

    if (phase_one) {
        /* 0x42af5b: movsx word [payload + 0x16] against movsx word [0x5bb50b]. */
        s.request = payload->frame == w.selector ? 1 : 0;
        fx(host, ACTION17_FX_REQUEST, s.request);
    }

    r.requested = s.request == 1 ? 1u : 0u;
    *slot = s;
    *world = w;
    *result = r;
    return ACTION17_OK;
}

int action0b_hover_cursor(const Action0bPayload *payload, int16_t held_item, Action17Cursor *out)
{
    Action17Cursor c;
    if (payload == NULL || out == NULL) {
        return ACTION17_ERR_ARGUMENT;
    }
    memset(&c, 0, sizeof(c));
    c.surface = ACTION17_SURFACE_UNCHANGED;
    /* 0x4f221e: with a held item and 3 < word < 0x1b the word is the index and
     * the item flag 0x5b44f8 is set; with no item the word is the index. */
    if (payload->cursor > 3 && payload->cursor < 0x1b && held_item != -1) {
        c.held_flag = 1;
        c.cursor_index = payload->cursor;
    } else if (held_item == -1) {
        c.cursor_index = payload->cursor;
    }
    c.variant = 1;
    /* 0x4f2305 onward: the shared tail of the cascade cases. */
    if (held_item != -1 && c.held_flag != 0) {
        c.surface = ACTION17_SURFACE_DEFAULT;
    } else if (held_item != -1) {
        c.cursor_index = (int32_t)held_item + 0x25;
        c.surface = ACTION17_SURFACE_HELD;
    }
    c.table_offset = c.cursor_index * 32 + c.variant * 16;
    *out = c;
    return ACTION17_OK;
}
