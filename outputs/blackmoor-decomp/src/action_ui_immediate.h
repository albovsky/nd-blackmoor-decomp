#ifndef BLACKMOOR_ACTION_UI_IMMEDIATE_H
#define BLACKMOOR_ACTION_UI_IMMEDIATE_H

#include "action_ui.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Original 0x4e13e4 code1 and permission/teardown helper0x4e1305.
 * The three flags are the requests583232/3/4, consumed next tick after
 * screen1 is normalized to0. This API does not open a popup inline. */
typedef struct ActionUIImmediateWorld {
    int32_t screen_583204;
    uint8_t request[3];
    int16_t phone_scene_579e0e;
    int32_t phone_mode_579e10;
} ActionUIImmediateWorld;

typedef struct ActionUIImmediateHost {
    void *context;
    /* Existing screen3 inventory,4 journal or5 phone teardown. A missing
     * boundary refuses before effects. Failure is terminal for the caller. */
    int (*close_screen)(void *context, int32_t screen);
} ActionUIImmediateHost;

/* Eight-byte raw1d body. body[2] must be1; body[3] is ignored here as in
 * the original. Group0/4 and a denied switch complete without UI writes.
 * A permitted group1..3 closes the other current popup first, raises its
 * request, then writes screen1. Group3 with start!=9999 additionally stores
 * signed start/end as forced scene and auto-close mode. No table mutation.
 * Host failure may have partial host effects; world is committed only on
 * success. Other failures leave world unchanged. */
int action_ui_apply_immediate(ActionUIImmediateWorld *world,
    const uint8_t *body, size_t length, const ActionUIImmediateHost *host);

#ifdef __cplusplus
}
#endif
#endif
