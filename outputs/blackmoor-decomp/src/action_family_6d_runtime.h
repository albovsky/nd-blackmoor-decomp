#ifndef BLACKMOOR_ACTION_FAMILY_6D_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_6D_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#include "action_family_6d.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0x6d, "close the popup screen, then leave the game for outer state 6" (RT-57; 1 corpus row, scene S6301).
 *
 * Original code (GAME.EXE, SHA-256 afd337a2...5c45), confirmed in the disassembly:
 *   0x40e18b  loader arm (action_family_6d.c): the one-byte body is never read afterwards.
 *   0x427a50  dispatcher arm 0x4290c0 (type 0x6d, gate 0x423f57 mode 0). For a true gate, in this order:
 *               [0x5bb22a] != 0  : 0x4e303b on the overlay object 0x57975c;
 *               else [0x583204] == 4 : 0x4eb96e on the object 0x57fd34;
 *               else [0x583204] == 3 : 0x4e7d04 on the object 0x571442;
 *               otherwise no teardown;
 *             then 0x4fb018 on the scene sound object 0x5c3a67 (unload the MSND channel and sound channels 0..13),
 *             [0x583981] := 6, [0x5839a1] := 0, [0x583999] := 0, [0x5bb1e2] := 0, and the row's completion byte := 1 directly
 *             (0x429163): no generic completion, no dependency reset, the phase word is not written.
 *   The three teardown functions each call their object's cleanups (0x4edb97, 0x4eba54 / 0x4e7bf3 / 0x4e2faa, 0x4d36ed, image
 *   releases 0x4c2dfb on the cells 0x5d03a3, 0x5d03a7, 0x5d039f, 0x4e1d34 and sound unloads 0x4fba69 on their members) and
 *   store directly: [0x583204] := 0 in all three; the overlay one also [0x5bb22a] := 0 and word [0x57975c + 0x6b2] := 9999
 *   (the stored return scene the raw 0x80 arm reads). The cleanups belong to the host: the native app has no popup screens,
 *   so its cells stay 0 and only the tail runs.
 * With the debug flag 0x63a4cd set 0x4fb018 first logs (0x44a2b7); the native module models the flag as 0.
 * Nothing here claims original source structure. */

#define ACTION_FAMILY_6D_RUNTIME_OK 0
#define ACTION_FAMILY_6D_RUNTIME_ERR_ARGUMENT 1
#define ACTION_FAMILY_6D_RUNTIME_ERR_HOST 2
/* Native-only refusal: a popup teardown is needed and the host has none; nothing happened. */
#define ACTION_FAMILY_6D_RUNTIME_ERR_TEARDOWN 3

#define ACTION_FAMILY_6D_STORED_RETURN_SCENE 9999

typedef enum {
    ACTION_FAMILY_6D_TEARDOWN_NONE = 0,
    ACTION_FAMILY_6D_TEARDOWN_MODE4 = 1,   /* 0x4eb96e on 0x57fd34 */
    ACTION_FAMILY_6D_TEARDOWN_MODE3 = 2,   /* 0x4e7d04 on 0x571442 */
    ACTION_FAMILY_6D_TEARDOWN_OVERLAY = 3  /* 0x4e303b on 0x57975c */
} Action6DTeardown;

typedef struct {
    int32_t popup_mode_583204;        /* read: 4 or 3 select a teardown; written 0 by each teardown */
    int32_t overlay_flag_5bb22a;      /* read: nonzero selects the overlay teardown; written 0 by it */
    int16_t overlay_return_6b2;       /* word [0x57975c + 0x6b2]; written 9999 by the overlay teardown */
    int32_t outer_state_583981;       /* := 6 */
    int32_t cell_5839a1;              /* := 0 */
    int32_t engine_mode_583999;       /* := 0 */
    int32_t cell_5bb1e2;              /* := 0 */
} Action6DWorld;

typedef struct {
    void *context;
    /* REQUIRED. 0x4fb018 on 0x5c3a67. Nonzero return = failure (the visit then changes nothing in *world). */
    int (*unload_scene_sound)(void *context);
    /* The popup object cleanups for the selected teardown (the callees listed above). Optional: without it a visit that needs
     * a teardown is refused before any effect. Nonzero return = failure. */
    int (*teardown)(void *context, Action6DTeardown kind);
} Action6DHost;

/* The teardown the arm selects for the cells (0x4290e7..0x429118). */
Action6DTeardown action_family_6d_runtime_select(const Action6DWorld *world);

/* One true-gate visit. ACTION_FAMILY_6D_RUNTIME_OK; _ERR_ARGUMENT on a null pointer or a missing unload; _ERR_TEARDOWN when a
 * teardown is selected and the host has none; _ERR_HOST when the teardown or the unload failed. Nothing in *world changes
 * unless OK is returned. */
int action_family_6d_runtime_visit(const ActionFamily6DDecoded *decoded, Action6DWorld *world, const Action6DHost *host);

#ifdef __cplusplus
}
#endif
#endif
