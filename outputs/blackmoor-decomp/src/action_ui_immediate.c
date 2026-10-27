#include "action_ui_immediate.h"

/* GAME.EXE afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45.
 * Original code1 stores4e1412..4e14b0, helper4e1305..4e13e4;
 * REA provenance ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772.
 * Instruction widths/order come from the immutable original and mnemonic
 * asm, not inferred intent or generated function-ledger translations. */

static int16_t word(const uint8_t *p)
{
    const uint16_t bits = (uint16_t)((uint16_t)p[0] | ((uint16_t)p[1] << 8));
    return bits <= INT16_MAX ? (int16_t)bits : (int16_t)(-1 - (int32_t)(UINT16_MAX - bits));
}

int action_ui_apply_immediate(ActionUIImmediateWorld *world,
    const uint8_t *body, size_t length, const ActionUIImmediateHost *host)
{
    ActionUIImmediateWorld next;
    int16_t group;
    int32_t close = 0;
    if (world == NULL || body == NULL) return ACTION_UI_ERR_ARGUMENT;
    if (length != 8u) return ACTION_UI_ERR_BODY;
    group = word(body);
    if (group < 0 || (size_t)group >= ACTION_UI_CONTROL_GROUP_COUNT) return ACTION_UI_ERR_GROUP_BOUNDS;
    if (body[2] != 1u) return ACTION_UI_ERR_UNSUPPORTED;
    next = *world;
    /* The caller passes only the low word of583204 to the helper; the
     * helper's later comparisons read the full global dword. */
    if ((uint16_t)next.screen_583204 != 0u) {
        switch (group) {
        case 1:
            if (next.screen_583204 == 4 || next.screen_583204 == 5) close = next.screen_583204;
            else return ACTION_UI_OK;
            break;
        case 2:
            if (next.screen_583204 == 3 || next.screen_583204 == 5) close = next.screen_583204;
            else return ACTION_UI_OK;
            break;
        case 3:
            if (next.screen_583204 == 3 || next.screen_583204 == 4) close = next.screen_583204;
            else return ACTION_UI_OK;
            break;
        default: break;
        }
    }
    if (close != 0) {
        if (host == NULL || host->close_screen == NULL) return ACTION_UI_ERR_UNSUPPORTED;
        if (host->close_screen(host->context, close) != 0) return ACTION_UI_ERR_HOST;
    }
    if (group >= 1 && group <= 3) {
        next.request[(size_t)group - 1u] = 1u;
        next.screen_583204 = 1;
        if (group == 3 && word(body + 4) != 9999) {
            next.phone_scene_579e0e = word(body + 4);
            next.phone_mode_579e10 = word(body + 6);
        }
    }
    *world = next;
    return ACTION_UI_OK;
}
