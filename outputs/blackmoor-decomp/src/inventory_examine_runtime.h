#ifndef BLACKMOOR_INVENTORY_EXAMINE_RUNTIME_H
#define BLACKMOOR_INVENTORY_EXAMINE_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#include "action_family_7d_runtime.h"
#include "inventory_view_runtime.h"
#include "scene_stack.h"

#ifdef __cplusplus
extern "C" {
#endif

/* RT-43: the inventory examine step 0x4ea269 (thiscall on the inventory view 0x571442; three stack arguments, callee
 * cleans: item word [ebp+8], take word [ebp+0xc], sound dword [ebp+0x10]).
 *
 * Callers: the view's click branch 0x4e8f0e (item = hot item, take 1, sound 1) and the action handler 0x4eaca8 (item
 * and take from the row's two words, sound 0; the matching action type is still unported). In order:
 *   1. when movsx word [0x583f1d] != -1 (an examined item is still pending) 0x4e9e84(selector, 1) puts it back into the
 *      list (the add step with flag 1: sound 0x17, view rebuild, UI animation as RT-19 recovered it);
 *   2. when the selector is -1 AFTER that (it is read again; the add step never writes it, so this is the complement of
 *      step 1) the saver 0x4eb70f(2) copies the running scene's words into the second saved-scene record
 *      0x5c3a1b..0x5c3a30 (the record raw 0x7d pops);
 *   3. word [0x583f1d] := (movsx word take == 1 ? item : -1);
 *   4. 0x4ea06c(item) removes the item from the list (the remove step of RT-13; view rebuild);
 *   5. when sound != 0, the sound request 0x4fb2e3(0x17);
 *   6. the scene change request: dword [0x5bb57b] := movsx word [view + item * 0x16d + 0x780] (the item's text/scene
 *      word), words [0x5bb599] := [0x5bb595] := 0, word [0x5c39ff] := word [view + item * 0x16d + 0x782], dwords
 *      [0x5bb59b] := [0x5bb59f] := 0, [0x5bb5a3] := 1, dword [0x583999] := 4 (engine mode: scene change). Unlike the
 *      pop 0x4eb5f2 it does not write 0x5bb57f or the start flag 0x5bb1ca;
 *   7. the view close 0x4e7d04 (reset 0x4e7bf3, screen state 0x583204 := 0, teardown 0x4edb97 and 0x4d36ed).
 * The item word indexes the item records with its sign; the native refuses an item outside 0..69.
 *
 * Modeled: the selector, the record, the inventory model of RT-19, the scene words handed to the host as one request,
 * the view state. NOT modeled: what 0x4e812f, 0x4e0559 and 0x4fb2e3 do, the teardown, and the loader's consumption of
 * the request words (host). */

#define INVEXAM_ITEMS INVVIEW_ITEMS
#define INVEXAM_SOUND_SLOT 0x17u
#define INVEXAM_SAVE_TYPE 2
#define INVEXAM_FLAG_OFFSET 0x34u       /* item record +0x34 = view +0x782 */

/* Ordered effect markers delivered through inventory.inventory.observe next to the Action78/79 and view markers. */
typedef enum {
    INVEXAM_EFFECT_ENTER = 0x50,    /* 0x4ea269 entered; value = item */
    INVEXAM_EFFECT_SAVE = 0x51,     /* 0x4eb70f(2) called; value = scene word stored in the record */
    INVEXAM_EFFECT_SELECTOR = 0x52, /* word 0x583f1d stored; value = signed word stored */
    INVEXAM_EFFECT_SOUND = 0x53,    /* 0x4fb2e3(0x17); value = slot */
    INVEXAM_EFFECT_SCENE = 0x54,    /* the scene change request words stored; value = scene */
    INVEXAM_EFFECT_CLOSE = 0x55     /* 0x4e7d04; value = 0 */
} InventoryExamineEffect;

/* The scene change request the step stores (everything else the loader copies at the next load is left alone). */
typedef struct {
    int32_t scene_5bb57b;     /* movsx word [view + item * 0x16d + 0x780] */
    int16_t word_5bb599;      /* 0 */
    int16_t word_5bb595;      /* 0 */
    int16_t word_5c39ff;      /* word [view + item * 0x16d + 0x782] */
    int32_t dword_5bb59b;     /* 0 */
    int32_t dword_5bb59f;     /* 0 */
    int32_t dword_5bb5a3;     /* 1 */
    int32_t mode_583999;      /* 4 */
} InventoryExamineRequest;

typedef struct {
    void *context;
    /* REQUIRED when the step saves (selector -1): the running scene's words for the saver 0x4eb70f (the same
     * words 0x42e560 reads). Nonzero: refused. */
    int (*load_current)(void *context, SceneStackCurrent *current);
    /* REQUIRED. Performs the scene change request (mode 4). Called once, after the remove step and the sound request,
     * before the view closes. Nonzero: refused, a host failure after the earlier effects. */
    int (*scene_change)(void *context, const InventoryExamineRequest *request);
} InventoryExamineHost;

/* Everything the step reads and writes outside the inventory model. Borrowed. */
typedef struct InventoryExamine {
    int16_t *selector;            /* word 0x583f1d */
    SceneRestoreSlot *slot;       /* record 0x5c3a1b..0x5c3a30 */
    const int16_t *flag_word;     /* INVEXAM_ITEMS words: item record +0x34 (view +0x782) */
    InventoryExamineHost host;
} InventoryExamine;

typedef struct {
    uint8_t put_back;             /* step 1 ran (a pending item was added back) */
    uint8_t added;                /* ... and the add step inserted it (0: it was already listed) */
    uint8_t saved;                /* step 2 ran (the record was filled) */
    uint8_t removed;              /* the remove step found the item */
    uint8_t sound_requested;
    uint8_t closed;
    uint8_t request_made;
    InventoryExamineRequest request;
} InventoryExamineResult;

/* Item record +0x34 words (the `flag_word` table) from the 25727-byte INV chunk; records of 0x16d bytes at +0xb1. */
int inventory_examine_words_from_inv(const uint8_t *inv, size_t length, int16_t flag_word[INVEXAM_ITEMS]);

/* One call of 0x4ea269. model carries the live view mode and slot flag for the add step of 1. data->text is the scene
 * word table (+0x780 = record +0x32). Every rejection happens before any effect: NULL arguments, an item outside
 * 0..69, a missing provider the path needs (rebuild, sound, UI animation, load_current, scene_change; a missing close_view skips the teardown), and
 * everything the add and remove steps refuse (checked on private copies of the inventory first). A provider failure in
 * the real run is ERR_HOST with the earlier effects committed (no rollback, as in the original). On success *view is
 * closed (screen state 0). *failure names the reason. */
int inventory_examine(InventoryView *view, const InventoryViewItemData *data, const Action78Model *model,
                      const InventoryViewHost *host, const InventoryExamine *examine, int16_t item, int16_t take,
                      int32_t sound, InventoryExamineResult *result, const char **failure);

#ifdef __cplusplus
}
#endif
#endif
