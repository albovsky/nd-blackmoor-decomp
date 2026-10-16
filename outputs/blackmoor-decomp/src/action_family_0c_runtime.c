#include "action_family_0c_runtime.h"

#include <string.h>

static int16_t rd_s16(const uint8_t *p)
{
    const uint16_t bits = (uint16_t)((uint16_t)p[0] | ((uint16_t)p[1] << 8));
    return bits <= (uint16_t)INT16_MAX ? (int16_t)bits : (int16_t)(-1 - (int32_t)(UINT16_MAX - bits));
}

static void fx(const Action17Host *host, int effect, int32_t value)
{
    if (host != NULL && host->observe != NULL) {
        host->observe(host->context, effect, value);
    }
}

static int reject(const char **failure, const char *reason, int status)
{
    if (failure != NULL) {
        *failure = reason;
    }
    return status;
}

int action0c_validate_body(const uint8_t *body, size_t body_length, const char **failure)
{
    int16_t count;
    if (failure != NULL) {
        *failure = "none";
    }
    if (body == NULL) {
        return reject(failure, "null argument", ACTION17_ERR_ARGUMENT);
    }
    if (body_length < ACTION0C_PREFIX_BYTES) {
        return reject(failure, "typed body is shorter than the 10-byte prefix", ACTION17_ERR_BOUNDS);
    }
    count = rd_s16(body + 8);
    if (count < 0 || count > ACTION0C_MAX_COUNT) {
        return reject(failure, "record count outside 0..1819", ACTION17_ERR_BOUNDS);
    }
    if (body_length != ACTION0C_PREFIX_BYTES + (size_t)count * ACTION0C_RECORD_BYTES) {
        return reject(failure, "typed body length is not 10 + 18 * count", ACTION17_ERR_BOUNDS);
    }
    return ACTION17_OK;
}

/* 0x42b2e4 (FUN_0042b2e4): raw 0x0c step. */
int action0c_step(const uint8_t *body, size_t body_length, uint32_t phase, Action17Slot *slot,
                  Action17World *world, const Action17Host *host, Action17Result *result,
                  const char **failure)
{
    Action17Slot s;
    Action17World w;
    Action17Result r;
    int16_t count;
    int phase_one;
    int status;

    if (slot == NULL || world == NULL || result == NULL) {
        if (failure != NULL) {
            *failure = "null argument";
        }
        return ACTION17_ERR_ARGUMENT;
    }
    status = action0c_validate_body(body, body_length, failure);
    if (status != ACTION17_OK) {
        return status;
    }
    count = rd_s16(body + 8);

    s = *slot;
    w = *world;
    memset(&r, 0, sizeof(r));
    r.phase_after = phase;
    r.matched_record = -1;

    phase_one = 0;
    if (phase == 0u) {
        /* 0x42b318: both stores, then the phase-1 body in the same call. */
        w.start_flag_5bb1ca = 1;
        fx(host, ACTION17_FX_START_FLAG, 1);
        r.phase_after = 1u;
        fx(host, ACTION17_FX_PHASE, 1);
        phase_one = 1;
    } else if (phase == 1u) {
        phase_one = 1;
    } else if (phase == 2u) {
        /* 0x42b47d: direct completion, then the scene-change cells from the body, mode 4. */
        s.done = 1u;
        fx(host, ACTION17_FX_DONE, 1);
        w.xfer_5bb57b = rd_s16(body + 2);
        fx(host, ACTION17_FX_XFER_5BB57B, w.xfer_5bb57b);
        w.xfer_5bb599 = rd_s16(body + 4);
        fx(host, ACTION17_FX_XFER_5BB599, w.xfer_5bb599);
        w.xfer_5c39ff = rd_s16(body + 6);
        fx(host, ACTION17_FX_XFER_5C39FF, w.xfer_5c39ff);
        w.xfer_5bb595 = 0;
        fx(host, ACTION17_FX_XFER_5BB595, 0);
        w.xfer_5bb59b = 0;
        fx(host, ACTION17_FX_XFER_5BB59B, 0);
        w.xfer_5bb59f = 0;
        fx(host, ACTION17_FX_XFER_5BB59F, 0);
        w.xfer_5bb5a3 = 1;
        fx(host, ACTION17_FX_XFER_5BB5A3, 1);
        w.mode_583999 = 4;
        fx(host, ACTION17_FX_MODE, 4);
        r.finished = 1u;
    }

    if (phase_one) {
        int16_t i;
        /* 0x42b336: the request is cleared on every visit, before the scan. */
        s.request = 0;
        fx(host, ACTION17_FX_REQUEST, 0);
        for (i = 0; i < count; ++i) {
            const uint8_t *record = body + ACTION0C_PREFIX_BYTES + (size_t)i * ACTION0C_RECORD_BYTES;
            if (rd_s16(record) != w.selector) {
                continue;
            }
            s.request = 1;
            fx(host, ACTION17_FX_REQUEST, 1);
            /* mov dx, word [record + 2/6/10/14]: the low word of each dword. */
            s.left = rd_s16(record + 2);
            fx(host, ACTION17_FX_LEFT, s.left);
            s.top = rd_s16(record + 6);
            fx(host, ACTION17_FX_TOP, s.top);
            s.right = rd_s16(record + 10);
            fx(host, ACTION17_FX_RIGHT, s.right);
            s.bottom = rd_s16(record + 14);
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

int action0c_hover_cursor(const uint8_t *body, size_t body_length, int16_t held_item,
                          Action17Cursor *out)
{
    Action17Cursor c;
    int16_t word;
    int status;
    if (out == NULL) {
        return ACTION17_ERR_ARGUMENT;
    }
    status = action0c_validate_body(body, body_length, NULL);
    if (status != ACTION17_OK) {
        return status;
    }
    word = rd_s16(body);
    memset(&c, 0, sizeof(c));
    c.surface = ACTION17_SURFACE_UNCHANGED;
    /* 0x4f2033: with a held item and 3 < word < 0x1b the word is the index and the item flag
     * 0x5b44f8 is set; with no item the word is the index. */
    if (word > 3 && word < 0x1b && held_item != -1) {
        c.held_flag = 1;
        c.cursor_index = word;
    } else if (held_item == -1) {
        c.cursor_index = word;
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
