#ifndef BLACKMOOR_ACTION_FAMILY_0B_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_0B_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#include "action_family_17_runtime.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0x0b "scene change", the main navigation hotspot family
 * (RT-16, the tutorial's S6403 row 2; 1,275 corpus rows).
 *
 * Original code (GAME.EXE, SHA-256 afd337a2...5c45), confirmed in the
 * disassembly and by the original-x86 oracle:
 *   0x40b7d4  loader arm for raw type 0x0b (jump table 0x410ca4, byte map
 *             0x410e9c; no other type shares it): allocates a 0x28-byte payload
 *             and fills it from the 24-byte typed body
 *   0x427ba4  dispatcher arm: gate 0x423f57 mode 1, then the handler
 *   0x42ae73  the handler (also reached from the 0x0d arm 0x427b33 and the
 *             0x0e..0x14 arm 0x427b6b; raw 0x15 is the loader's wrapper for
 *             those types and not served here)
 *   0x4f1f16  the GENERIC row loop of the pointer cascade 0x4f0059 hits a
 *             row whose request dword (0x5bb626) is nonzero and whose
 *             rectangle words (0x5bb62a/2c/2e/30) contain the pointer
 *   0x4f221e  its type-0x0b case: the hover cursor
 *
 * Payload (offsets in the original object) from the body: +0 word body+0 (the
 * cursor word), +2 body+2 (target scene), +4 body+4 (the selector the target
 * scene starts with), +6 zero, +8 body+6, +0xa/+0xe zero dwords, +0x12 one,
 * +0x16 the frame word (zero), +0x18..+0x27 the four rectangle dwords
 * body+8..+23.
 *
 * Handler, by the row phase dword:
 *   0 (0x42aea9): 0x5bb1ca := 1, the low words of the rectangle dwords into the
 *      row rectangle cells (left, top, right, bottom), phase := 1, then phase 1
 *      in the same call;
 *   1 (0x42af5b): request := 1 when the frame word equals the selector 0x5bb50b
 *      (both sign-extended), else 0: a single store, no clear first (the
 *      dispatcher prologue already cleared it);
 *   2 (0x42afa9): completion byte := 1 (direct store: no 0x42ba3a, no
 *      dependency reset, phase stays 2), payload +2/+4/+6/+8/+0xa/+0xe/+0x12 into
 *      0x5bb57b (sign-extended dword), 0x5bb599, 0x5bb595, 0x5c39ff, 0x5bb59b,
 *      0x5bb59f, 0x5bb5a3, and the engine mode 0x583999 := 4;
 *   other: no effect.
 *
 * The cells and effects are the RT-15 ones (the same dispatcher, the same
 * row slot and the same scene-change cells): see action_family_17_runtime.h.
 *
 * Native safety rejection (reported separately from valid behaviour): the
 * typed body must be exactly 24 bytes. The original loader reads 24 bytes of
 * the body; a shorter object is outside the parser's contract. */

#define ACTION0B_RAW_TYPE UINT8_C(0x0b)
#define ACTION0B_BODY_BYTES 24u
#define ACTION0B_PAYLOAD_BYTES 0x28u

/* Decoded payload (natural layout, not the unaligned original object; the
 * 0x28-byte image can be reproduced field by field). */
typedef struct {
    int16_t cursor;    /* +0x00: hover cursor word */
    int16_t target;    /* +0x02 */
    int16_t word_04;   /* +0x04 */
    int16_t word_06;   /* +0x06: loader zero */
    int16_t word_08;   /* +0x08: body+6 */
    int32_t dword_0a;  /* +0x0a: loader zero */
    int32_t dword_0e;  /* +0x0e: loader zero */
    int32_t dword_12;  /* +0x12: loader one */
    int16_t frame;     /* +0x16: loader zero */
    int32_t rect[4];   /* +0x18, +0x1c, +0x20, +0x24: left, top, right, bottom dwords */
} Action0bPayload;

/* 0x40b7d4: build the payload from the typed body. ACTION17_OK;
 * ACTION17_ERR_ARGUMENT on null; ACTION17_ERR_BOUNDS unless the body is
 * exactly 24 bytes (nothing is written). `failure` is optional. */
int action0b_load(const uint8_t *body, size_t body_length, Action0bPayload *out,
                  const char **failure);

/* One true-gate visit of 0x42ae73 (phase = the row phase dword). Nothing is
 * changed unless ACTION17_OK is returned. result->matched_record is -1. */
int action0b_step(const Action0bPayload *payload, uint32_t phase, Action17Slot *slot,
                  Action17World *world, const Action17Host *host, Action17Result *result);

/* Hover cursor of a hit on the row (cascade case 0x4f221e) while the held-item
 * word 0x583a29 is `held_item` (-1 none). */
int action0b_hover_cursor(const Action0bPayload *payload, int16_t held_item, Action17Cursor *out);

#ifdef __cplusplus
}
#endif
#endif
