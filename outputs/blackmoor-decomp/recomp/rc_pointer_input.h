#ifndef RC_POINTER_INPUT_H
#define RC_POINTER_INPUT_H
#include <stdint.h>
#ifdef __cplusplus
extern "C" {
#endif

enum {
    RC_POINTER_LEFT = 0x0001u, RC_POINTER_RIGHT = 0x0002u,
    RC_POINTER_SHIFT = 0x0004u, RC_POINTER_CONTROL = 0x0008u
};
/* Complete current left/right state, in logical 640x480 client coordinates.
 * Uses the host queue, never OS input. Unrecognized button bits are ignored.
 * The existing rc_input_mouse API still updates only the left button. */
void rc_input_pointer_mask(int32_t x, int32_t y, uint32_t buttons);

typedef struct RcPointerMessage { uint32_t message, wparam, lparam; } RcPointerMessage;
/* Finite host adapter, shared with a plain-C fake-queue fixture. At most three
 * messages, no state, I/O or callbacks. Preserves the old hover-before-down
 * behavior. If both edges arrive together, left then right is adapter order. */
static inline unsigned rc_pointer_plan(uint32_t before, uint32_t after,
                                       uint32_t modifiers, int32_t x, int32_t y,
                                       RcPointerMessage messages[3])
{
    if (!messages) return 0;
    before &= RC_POINTER_LEFT | RC_POINTER_RIGHT;
    after &= RC_POINTER_LEFT | RC_POINTER_RIGHT;
    modifiers &= RC_POINTER_SHIFT | RC_POINTER_CONTROL;
    uint32_t lp = ((uint32_t)y << 16) | ((uint32_t)x & 0xffffu);
    unsigned count = 0;
    if (before == after || (after & ~before)) {
        RcPointerMessage move = {0x0200u, before | modifiers, lp};
        messages[count++] = move;
    }
    uint32_t state = before;
    for (uint32_t bit = RC_POINTER_LEFT; bit <= RC_POINTER_RIGHT; bit <<= 1) {
        if (!((before ^ after) & bit)) continue;
        state ^= bit;
        uint32_t message = bit == RC_POINTER_LEFT
            ? ((after & bit) ? 0x0201u : 0x0202u)
            : ((after & bit) ? 0x0204u : 0x0205u);
        RcPointerMessage edge = {message, state | modifiers, lp};
        messages[count++] = edge;
    }
    return count;
}
#ifdef __cplusplus
}
#endif
#endif
