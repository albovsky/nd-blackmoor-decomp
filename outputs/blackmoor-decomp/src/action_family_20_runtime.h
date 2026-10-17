#ifndef BLACKMOOR_ACTION_FAMILY_20_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_20_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#include "action_family_20.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0x20, "set the overlay view cells, erase every action row" (RT-48; 2 corpus rows in 2 scenes).
 *
 * Original code (GAME.EXE, SHA-256 afd337a2...5c45), confirmed in the disassembly and by the original-x86 oracle:
 *   0x40bd12  loader arm (action_family_20.c): the 8-byte body is two dwords.
 *   0x427a50  dispatcher arm 0x429373 (type 0x20, gate 0x423f57 mode 0). For a true gate, in this order:
 *               [0x63aa10] := dword at body+0, [0x55cd94] := dword at body+4 (0x4293b4..0x4293cb),
 *               the row's completion byte := 1 (0x4293dd; erased again by the next step for this row),
 *               0x43e96c: every row below the high-water count 0x5c39e3 whose loaded dword (+0x59, 0x5bb63c) is nonzero is
 *                         erased (body freed when non-null and the pointer cleared, type byte := 0 (0x43e9f6), completion byte,
 *                         request dword, phase, rectangle word 0x5bb636 := -1,
 *                         0x5bb638 := 1 "not loaded", 0x5bb63c := 0, dependency reset 0x423b51),
 *               0x43e8b8: the high-water count becomes the start of the trailing run of unloaded rows (0 when every row was
 *                         erased),
 *               [0x5bb57b] := [0x5bb57f] (0x4293ee..0x4293f4), word [0x5c3a4f] := low word of [0x5bb57b] (0x4293fa..0x429401).
 *             With the debug flag 0x63a4cd set the arm then logs through 0x50ca3e/0x44a2b7; the native module models the flag
 *             as 0.
 *             There is no generic completion call. The row itself is among the erased ones only when its loaded dword is
 *             nonzero (the loader sets it to 1 only when [0x5c3a01] == 2, 0x410ad7/0x410af0); otherwise the original leaves
 *             completion = 1 and the phase unchanged, while the native binding always returns phase 0 (the one recorded
 *             native/original difference; the dispatcher skips completed rows either way). The recount leaves the count
 *             unchanged when there is no trailing unloaded run.
 * The cells 0x63aa10 and 0x55cd94 are read by the overlay view object (0x4ee572 and friends) and by the exit handler 0x43d227
 * (0x55cd94 != 0 skips the next-scene summary check); who consumes them in the app is host behaviour.
 * Nothing here claims original source structure. */

#define ACTION_FAMILY_20_RUNTIME_OK 0
#define ACTION_FAMILY_20_RUNTIME_ERR_ARGUMENT 1
#define ACTION_FAMILY_20_RUNTIME_ERR_HOST 2

/* Process globals the arm reads or writes, with their original addresses and widths. */
typedef struct {
    int32_t view_cell_63aa10;   /* := body dword 0 */
    int32_t view_cell_55cd94;   /* := body dword 4 */
    int32_t scene_5bb57b;       /* := scene_5bb57f */
    int32_t scene_5bb57f;       /* read */
    int16_t word_5c3a4f;        /* := low word of scene_5bb57b after the copy */
} Action20World;

typedef struct {
    void *context;
    /* REQUIRED. 0x43e96c + 0x43e8b8: erase every loaded action row and recompute the high-water count. Stores the number of
     * rows erased; nonzero return = failure (the visit then changes nothing). */
    int (*erase_rows)(void *context, uint32_t *rows_erased);
} Action20Host;

typedef struct {
    uint32_t rows_erased;       /* what the host reported */
} Action20Outcome;

/* One true-gate visit on a decoded row. ACTION_FAMILY_20_RUNTIME_OK; _ERR_ARGUMENT on a null pointer; _ERR_HOST when the host
 * erase failed. Nothing in *world or *out changes unless OK is returned. */
int action_family_20_runtime_visit(const ActionFamily20Decoded *decoded, Action20World *world, const Action20Host *host,
                                   Action20Outcome *out);

#ifdef __cplusplus
}
#endif
#endif
