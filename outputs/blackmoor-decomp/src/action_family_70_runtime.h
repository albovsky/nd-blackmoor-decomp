#ifndef BLACKMOOR_ACTION_FAMILY_70_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_70_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#include "action_family_70.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0x70, "leave the game for outer state 5, then 6" (RT-48; 2 corpus rows in 2 scenes).
 *
 * Original code (GAME.EXE, SHA-256 afd337a2...5c45), confirmed in the disassembly and by the original-x86 oracle:
 *   0x40e3d9  loader arm (action_family_70.c): the one-byte body is never read afterwards.
 *   0x427a50  dispatcher arm 0x4291f8 (type 0x70, gate 0x423f57 mode 0). For a true gate, in this order:
 *               0x4fb018 on the scene sound object 0x5c3a67 (unload the MSND channel and sound channels 0..13),
 *               [0x583985] := 6 (next outer state), [0x583981] := 5 (outer state), [0x583991] := 0,
 *               0x43dbd5: word [0x5bb1c4] := 1, [0x583999] := 0 (engine mode "none"), [0x5bb1e2] := 0,
 *               the row's completion byte := 1 directly (0x429269): no generic completion, no dependency reset, the phase
 *               word is not written.
 *             With the debug flag 0x63a4cd set 0x4fb018 first logs (0x44a2b7); the native module models the flag as 0.
 * The same triple (state 5, next 6, 0x583991 := 0, 0x43dbd5) is what the startup menu's first command stores (0x4da9c6..0x4daa02).
 * Outer states are switched by 0x426148; what states 5 and 6 do is host behaviour (the native app has no outer state machine).
 * Nothing here claims original source structure. */

#define ACTION_FAMILY_70_RUNTIME_OK 0
#define ACTION_FAMILY_70_RUNTIME_ERR_ARGUMENT 1
#define ACTION_FAMILY_70_RUNTIME_ERR_HOST 2

typedef struct {
    int32_t outer_state_583981;   /* := 5 */
    int32_t next_state_583985;    /* := 6 */
    int32_t cell_583991;          /* := 0 */
    int16_t first_render_5bb1c4;  /* := 1 (0x43dbd5) */
    int32_t engine_mode_583999;   /* := 0 */
    int32_t cell_5bb1e2;          /* := 0 */
} Action70World;

typedef struct {
    void *context;
    /* REQUIRED. 0x4fb018 on 0x5c3a67. Nonzero return = failure (the visit then changes nothing). */
    int (*unload_scene_sound)(void *context);
} Action70Host;

/* One true-gate visit. ACTION_FAMILY_70_RUNTIME_OK; _ERR_ARGUMENT on a null pointer; _ERR_HOST when the sound unload failed.
 * Nothing in *world changes unless OK is returned. */
int action_family_70_runtime_visit(const ActionFamily70Decoded *decoded, Action70World *world, const Action70Host *host);

#ifdef __cplusplus
}
#endif
#endif
