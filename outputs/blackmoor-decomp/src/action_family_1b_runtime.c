#include "action_family_1b_runtime.h"

#include <string.h>

static int16_t rd_s16(const uint8_t *p)
{
    const uint16_t bits = (uint16_t)((uint16_t)p[0] | ((uint16_t)p[1] << 8));
    return bits <= (uint16_t)INT16_MAX ? (int16_t)bits : (int16_t)(-1 - (int32_t)(UINT16_MAX - bits));
}

static int32_t rd_s32(const uint8_t *p)
{
    const uint32_t bits = (uint32_t)p[0] | ((uint32_t)p[1] << 8) | ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
    return bits <= (uint32_t)INT32_MAX ? (int32_t)bits : (int32_t)(-1 - (int32_t)(UINT32_MAX - bits));
}

static int16_t as_s16(uint16_t bits)
{
    return bits <= (uint16_t)INT16_MAX ? (int16_t)bits : (int16_t)(-1 - (int32_t)(UINT16_MAX - bits));
}

static int32_t as_s32(uint32_t bits)
{
    return bits <= (uint32_t)INT32_MAX ? (int32_t)bits : (int32_t)(-1 - (int32_t)(UINT32_MAX - bits));
}

static void fx(const Action17Host *host, int effect, int32_t value)
{
    if (host != NULL && host->observe != NULL) {
        host->observe(host->context, effect, value);
    }
}

/* Original GAME.EXE 0x414947: the raw 0x1b object method (phases 0 to 2 and the no-effect phases). */
int action1b_step(const ActionFamily1bDecoded *decoded, uint32_t phase, Action17Slot *slot, Action1bWorld *world,
                  const Action17Host *host, Action17Result *result)
{
    Action17Slot s;
    Action1bWorld w;
    Action17Result r;
    int phase_one = 0;
    int16_t i;

    if (decoded == NULL || slot == NULL || world == NULL || result == NULL) {
        return ACTION17_ERR_ARGUMENT;
    }
    s = *slot;
    w = *world;
    memset(&r, 0, sizeof(r));
    r.phase_after = phase;
    r.matched_record = -1;

    if (phase == 0u) {
        /* 0x4149b2: start flag, then phase := 1 and fall into phase 1. */
        w.start_flag_5bb1ca = 1;
        fx(host, ACTION17_FX_START_FLAG, 1);
        r.phase_after = 1u;
        fx(host, ACTION17_FX_PHASE, 1);
        phase_one = 1;
    } else if (phase == 1u) {
        phase_one = 1;
    } else if (phase == 2u) {
        const ActionFamily1bDecoded *d = decoded;
        int hit = 0;
        /* 0x414ada: direct completion, then the primary scan on the held-item word. */
        s.done = 1u;
        fx(host, ACTION17_FX_DONE, 1);
        for (i = 0; i < d->primary_count; ++i) {
            const uint8_t *rec = d->primary_records + (size_t)i * 22u;
            if (rd_s16(rec) != w.held_item) {
                continue;
            }
            w.xfer_5bb57b = rd_s16(rec + 2);
            fx(host, ACTION17_FX_XFER_5BB57B, w.xfer_5bb57b);
            w.xfer_5bb599 = rd_s16(rec + 4);
            fx(host, ACTION17_FX_XFER_5BB599, w.xfer_5bb599);
            w.xfer_5bb595 = rd_s16(rec + 6);
            fx(host, ACTION17_FX_XFER_5BB595, w.xfer_5bb595);
            w.xfer_5c39ff = rd_s16(rec + 8);
            fx(host, ACTION17_FX_XFER_5C39FF, w.xfer_5c39ff);
            w.xfer_5bb59b = rd_s32(rec + 10);
            fx(host, ACTION17_FX_XFER_5BB59B, w.xfer_5bb59b);
            w.xfer_5bb59f = rd_s32(rec + 14);
            fx(host, ACTION17_FX_XFER_5BB59F, w.xfer_5bb59f);
            w.xfer_5bb5a3 = rd_s32(rec + 18);
            fx(host, ACTION17_FX_XFER_5BB5A3, w.xfer_5bb5a3);
            r.matched_record = i;
            hit = 1;
            break;
        }
        if (!hit) {
            /* 0x414bf4: the object's fixed block (words +8, +0xa, +0xc, +0xe, dwords +0x10, +0x14, +0x18). */
            w.xfer_5bb57b = as_s16(d->fixed_words[1]);
            fx(host, ACTION17_FX_XFER_5BB57B, w.xfer_5bb57b);
            w.xfer_5bb599 = as_s16(d->fixed_words[2]);
            fx(host, ACTION17_FX_XFER_5BB599, w.xfer_5bb599);
            w.xfer_5bb595 = as_s16(d->fixed_words[3]);
            fx(host, ACTION17_FX_XFER_5BB595, w.xfer_5bb595);
            w.xfer_5c39ff = as_s16(d->fixed_words[4]);
            fx(host, ACTION17_FX_XFER_5C39FF, w.xfer_5c39ff);
            w.xfer_5bb59b = as_s32(d->fixed_dwords[0]);
            fx(host, ACTION17_FX_XFER_5BB59B, w.xfer_5bb59b);
            w.xfer_5bb59f = as_s32(d->fixed_dwords[1]);
            fx(host, ACTION17_FX_XFER_5BB59F, w.xfer_5bb59f);
            w.xfer_5bb5a3 = as_s32(d->fixed_dwords[2]);
            fx(host, ACTION17_FX_XFER_5BB5A3, w.xfer_5bb5a3);
        }
        w.mode_583999 = 4;
        fx(host, ACTION17_FX_MODE, 4);
        r.finished = 1u;
    }

    if (phase_one) {
        /* 0x4149d0: request := 0, then the first secondary record on the selector word. */
        s.request = 0;
        fx(host, ACTION17_FX_REQUEST, 0);
        for (i = 0; i < decoded->secondary_count; ++i) {
            const uint8_t *rec = decoded->secondary_records + (size_t)i * 18u;
            if (rd_s16(rec) != w.selector) {
                continue;
            }
            s.request = 1;
            fx(host, ACTION17_FX_REQUEST, 1);
            s.left = rd_s16(rec + 2);
            fx(host, ACTION17_FX_LEFT, s.left);
            s.top = rd_s16(rec + 6);
            fx(host, ACTION17_FX_TOP, s.top);
            s.right = rd_s16(rec + 10);
            fx(host, ACTION17_FX_RIGHT, s.right);
            s.bottom = rd_s16(rec + 14);
            fx(host, ACTION17_FX_BOTTOM, s.bottom);
            r.matched_record = i;
            break;
        }
    }

    r.requested = s.request == 1 ? 1u : 0u;
    *slot = s;
    *world = w;
    *result = r;
    return ACTION17_OK;
}

int action1b_hover_cursor(const ActionFamily1bDecoded *decoded, int16_t held_item, Action17Cursor *out)
{
    Action17Cursor c;
    if (decoded == NULL || out == NULL) {
        return ACTION17_ERR_ARGUMENT;
    }
    memset(&c, 0, sizeof(c));
    c.surface = ACTION17_SURFACE_UNCHANGED;
    /* 0x4f22ad: with no held item the index is the object's first fixed word (+6, sign-extended); the shared tail
     * (0x4f2305..) then maps a held item to its own cursor (item + 0x25, held-item surface). */
    if (held_item == -1) {
        c.cursor_index = as_s16(decoded->fixed_words[0]);
    } else {
        c.cursor_index = (int32_t)held_item + 0x25;
        c.surface = ACTION17_SURFACE_HELD;
    }
    c.variant = 1;
    c.table_offset = c.cursor_index * 32 + c.variant * 16;
    *out = c;
    return ACTION17_OK;
}
