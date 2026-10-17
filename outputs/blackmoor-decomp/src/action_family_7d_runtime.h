#ifndef BLACKMOOR_ACTION_FAMILY_7D_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_7D_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#include "action_family_78_runtime.h"
#include "scene_stack.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0x7d (RT-41): "return from the examined item's scene".
 *
 * Original: dispatcher arm 0x42950b of 0x427a50 evaluates the row's dependency tree (0x423f57, mode 0). Only for a
 * true gate does it call 0x4eb5f2 (thiscall, no arguments) on the inventory view object 0x571442, then store the
 * word 0xffff into 0x583f1d (0x429539) and the row's completion byte 1 directly (0x42954f). The generic completion
 * 0x42ba3a and the dependency reset 0x423d33 never run, whatever the subtype, and the phase word is untouched. The
 * loader arm (A-7D.1) copies one body byte that is never read again.
 *
 * 0x4eb5f2 is the pop that pairs with 0x4eb70f (the inventory examine step 0x4ea269, RT-43, saves into it): the second of
 * the three "return to this scene" records, 0x5c3a1b..0x5c3a2f. In order:
 *   1. if movsx word [0x5c3a1b] == 9999 the record is empty: with the debug flag 0x63a4cd set it logs through
 *      0x52139c, then it stores 0 into [0x5c3a1b] and CARRIES ON with the (empty) values;
 *   2. [0x5bb57b] := [0x5bb57f] := movsx word [0x5c3a1d] (the scene is read from the second word, twice),
 *      [0x5bb599] := word [0x5c3a1f], [0x5bb595] := word [0x5c3a21], dwords [0x5bb59b] := [0x5c3a25],
 *      [0x5bb59f] := [0x5c3a29], [0x5bb5a3] := [0x5c3a2d], [0x5c39ff] := 1,
 *      [0x5bb1ca] := (movsx word [0x5c3a23] == 1 ? 0 : 1);
 *   3. if movsx word [0x583f1d] != -1 (an item was taken along): 0x4e9e84(item, 0) (the inventory add step with flag
 *      0, which ends with the view rebuild 0x4e812f), then 0x4e0559(1, 0, 0) on the task bar object 0x570508 (the UI
 *      animation request, enable 0), whether or not the add found a duplicate;
 *   4. [0x583999] := 4 (engine mode: scene change), words [0x5c3a1b] := [0x5c3a1d] := 9999 (the record is empty
 *      again; the other words keep their values);
 *   5. when byte [view + 0x7011] == 0, byte [0x583232] := 1 (the task bar inventory flag: the inventory screen
 *      opens next tick).
 * The arm then stores -1 into 0x583f1d and completes the row.
 *
 * Modeled here: the record, the scene-change request words, the held-selector word 0x583f1d, the inventory model of
 * RT-19 (add step), the UI animation request, the inventory-open request. NOT modeled: what 0x4e812f, 0x4e0559 and
 * the main loop's consumer of 0x583232 do (host requests, as for raw 0x78), the debug log of step 1. */

#define ACTION7D_RAW_TYPE UINT8_C(0x7d)
#define ACTION7D_BODY_BYTES 1u
#define SCENE_RESTORE_EMPTY_MARKER 0x270f

/* The record at 0x5c3a1b..0x5c3a2f. dword_5c3a2d is read by the pop but never written by the saver 0x4eb70f. The C
 * struct is padded: never memcpy it to or from original memory. */
typedef struct scene_restore_slot {
    int16_t marker_5c3a1b;   /* 9999: nothing saved */
    int16_t scene_5c3a1d;
    int16_t word_5c3a1f;
    int16_t word_5c3a21;
    int16_t word_5c3a23;     /* 1: the start flag 0x5bb1ca becomes 0 on the pop */
    int32_t dword_5c3a25;
    int32_t dword_5c3a29;
    int32_t dword_5c3a2d;
} SceneRestoreSlot;

/* Process start state (the image holds zeros there). */
void scene_restore_slot_clear(SceneRestoreSlot *slot);

/* 0x437011..0x43703b, run by the game initializer: marker and scene 9999, words 0, 0, type word 2. */
void scene_restore_slot_init_words(SceneRestoreSlot *slot);

/* 0x4eb70f (thiscall, one stack argument whose low word is stored): copies the running scene's words into the
 * record. Like 0x42e560 it stores 0x5bb5ab into the second dword and overwrites it with 0x5bb5af: the third dword is
 * never written. */
void scene_restore_slot_save(SceneRestoreSlot *slot, const SceneStackCurrent *current, int32_t type_argument);

#define SCENE_RESTORE_POP_OK 0
/* The marker word is 9999. *out and the slot are filled exactly as the original does (it carries on); the callers of
 * the native runtime refuse the visit instead of requesting scene 9999. */
#define SCENE_RESTORE_POP_EMPTY 1
#define SCENE_RESTORE_POP_ARGUMENT -1

/* Steps 1, 2 and 4 of 0x4eb5f2 (the globals and the record; not the item or the flags). Fills *out with the values
 * the original stores (the same shape as the 0x42e493 pop) and empties the record: both words 9999, the others kept.
 * Returns OK, or EMPTY when the marker was 9999 on entry (everything done as above). NULL arguments change nothing. */
int scene_restore_slot_pop(SceneRestoreSlot *slot, SceneStackPop *out);

typedef enum {
    ACTION7D_OK = 0,
    ACTION7D_ERR_ARGUMENT = 1,
    /* A required provider is absent; nothing was changed. */
    ACTION7D_ERR_UNSUPPORTED = 2,
    /* Inventory model state the native model refuses; nothing was changed. */
    ACTION7D_ERR_BOUNDS = 3,
    /* A provider refused after earlier effects (no rollback, as in the original). */
    ACTION7D_ERR_HOST = 4,
    /* The record is empty (marker 9999); nothing was changed. */
    ACTION7D_ERR_EMPTY = 5
} Action7dStatus;

typedef struct {
    SceneRestoreSlot *slot;           /* 0x5c3a1b record */
    int16_t *held_selector;           /* word 0x583f1d (-1: no item taken along) */
    Action78Model inventory;          /* held 0x583a29, count 0x583a2b, list 0x583a31, presence 0x583bd5, view mode/flag */
    const uint8_t *view_close_flag;   /* view byte +0x7011 */
} Action7dModel;

typedef struct {
    void *context;
    /* The inventory add step's providers: inventory.inventory.rebuild_view (0x4e812f) is REQUIRED when an item is
     * re-added; request_ui_animation (0x4e0559) is REQUIRED then too and is called as (1, 0, 0). request_sound is
     * never called (flag 0). Each provider gets the context stored next to it (inventory.inventory.context for the
     * rebuild, inventory.context for the UI request). */
    Action78Host inventory;
    /* REQUIRED. The scene change the pop asks for (mode 4). Nonzero: refused, the visit is an ERROR_HOST and the
     * record is unchanged. Called once, after the re-add. */
    int (*scene_change)(void *context, const SceneStackPop *pop);
    /* REQUIRED when the view close flag is 0: byte 0x583232 := 1. */
    int (*open_inventory)(void *context);
} Action7dHost;

typedef struct {
    uint8_t readded;                /* an item was added back to the list (not a duplicate) */
    uint8_t item_taken_along;       /* the selector held an item: the add step and the UI request ran */
    int16_t item;                   /* that item */
    uint8_t inventory_open_requested;
    uint8_t selector_cleared;
    uint8_t completed;              /* the completion byte store (0x42954f) */
    SceneStackPop pop;
} Action7dResult;

/* One true-gate visit (arm 0x42950b). Every rejection happens before any effect: NULL arguments, an empty record,
 * a missing provider the path needs, an item the add step refuses (full list, bounds). A provider failure in the real
 * run is ACTION7D_ERR_HOST with the earlier effects committed. *failure names the reason. */
int action7d_visit(const Action7dModel *model, const Action7dHost *host, Action7dResult *result, const char **failure);

#ifdef __cplusplus
}
#endif
#endif
