#ifndef BLACKMOOR_ACTION_FAMILY_78_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_78_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#include "action_family_79_runtime.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0x78 "Add Inventory Item, No Hot Spot" (RT-19).
 *
 * Loader: 0x40e56a -> 0x4e9c2f copies a six-byte object (one dword, one word)
 * and advances the source cursor by six. The object is three little-endian
 * words: item (+0), take-in-hand flag (+2), swap flag (+4).
 *
 * Dispatcher arm 0x42944b (jump table 0x42a9b4, byte map 0x42aba4: runtime
 * type 0x78 -> table entry 57) evaluates the row's dependency tree with 0x423f57
 * mode 0 and only on a true gate calls 0x4eaadc(row) on the inventory view
 * 0x571442. Decision tree of 0x4eaadc (all widths signed words):
 *
 *   if (flag_take != 0) {
 *       held = word 0x583a29
 *       if (held == -1) {                       // 0x4eabc3
 *           0x4ea06c(item)                      // remove from the list (RT-13)
 *           held = item                         // 0x4eabef, the raw word
 *       } else if (flag_swap != 0) {            // 0x4eab27
 *           if (held != item) {
 *               0x4e8d96()                      // add(held, 0), held = -1
 *               0x4ea06c(item); held = item
 *           }
 *       } else if (held != item) {              // 0x4eab85
 *           0x4e9e84(item, 0)
 *       }
 *   }
 *   if (word 0x583a29 != item) 0x4e9e84(item, 1) // 0x4eabf9
 *   completion byte := 1                         // 0x4eac3f, direct store
 *
 * 0x4e9e84(item, flag) "add": searches the first count list words for the
 * sign-extended item; a duplicate returns with no effect at all (0x4e9edc).
 * Otherwise: flag != 0 requests sound 0x17 from the sound manager 0x4fb2e3;
 * the new list is item-first (scratch +0x828c shifted by one) unless the view
 * byte +0x7010 is nonzero AND the view dword +0x764c is 2, when it is item-last;
 * count word += 1 (0x4ea006), the count*2 bytes are copied back to 0x583a31,
 * presence dword 0x583bd5[item] := 1, the view rebuild 0x4e812f runs, and when
 * the view mode is not 2 and flag != 0 the UI animation 0x4e0559(1, 1, 0) is
 * requested on object 0x570508.
 *
 * Host effects: the view rebuild, the sound request and the UI animation are
 * requests (providers in Action78Host). What 0x4fb2e3 does (a validity probe
 * and a store of 1 into the sound slot's trigger word) and what 0x4e0559 does
 * (two global dword stores) are not modeled here. */

#define ACTION78_RAW_TYPE UINT8_C(0x78)
#define ACTION78_BODY_BYTES 6u
#define ACTION78_SOUND_SLOT 0x17u

typedef enum {
    ACTION78_OK = ACTION79_OK,
    ACTION78_ERR_ARGUMENT = ACTION79_ERR_ARGUMENT,
    /* A required host provider is absent; nothing was changed. */
    ACTION78_ERR_UNSUPPORTED = ACTION79_ERR_UNSUPPORTED,
    /* Model state the native model refuses (the original would read or write
     * outside the recovered arrays); nothing was changed. */
    ACTION78_ERR_BOUNDS = ACTION79_ERR_BOUNDS,
    /* A provider failed after earlier effects were committed (no rollback, as
     * in the original); the completion is not stored. */
    ACTION78_ERR_HOST = ACTION79_ERR_HOST
} Action78Status;

/* The six-byte object built at load time (0x4e9c2f). */
typedef struct {
    uint16_t item_word;   /* +0 */
    uint16_t take_flag;   /* +2: nonzero routes the item through the held slot */
    uint16_t swap_flag;   /* +4: nonzero returns a different held item to the list */
} Action78Object;

/* body must hold at least six bytes (the parser guarantees exactly six typed
 * bytes before any dependency records). Rejects NULL and short bodies. */
int action78_object_from_body(const uint8_t *body, size_t length, Action78Object *out);

/* View fields the add step reads. The native app has no inventory view that
 * can open (the original raises mode 2 only while the full inventory screen
 * is open), so it passes mode 0 and slot flag 0; both layouts are covered by
 * the original-x86 oracle. */
typedef struct {
    int32_t mode;          /* view dword +0x764c (2: the inventory screen is open) */
    uint8_t slot_flag;     /* view byte +0x7010 */
} Action78View;

typedef struct {
    Action79Model inventory;   /* held 0x583a29, count 0x583a2b, list 0x583a31, presence 0x583bd5 */
    Action78View view;
} Action78Model;

/* Ordered effect markers (delivered through inventory.observe together with
 * the Action79 markers of the shared remove step, in the original's order). */
typedef enum {
    ACTION78_EFFECT_ENTER = 0x20,      /* 0x4eaadc entered, gate true; value = sign-extended item */
    ACTION78_EFFECT_PUTBACK = 0x21,    /* 0x4e8d96 entered with a held item; value = held item */
    ACTION78_EFFECT_ADD = 0x22,        /* 0x4e9e84 entered, flag 0; value = sign-extended item */
    ACTION78_EFFECT_ADD_FLAGGED = 0x23,/* 0x4e9e84 entered, flag != 0 */
    ACTION78_EFFECT_DUPLICATE = 0x24,  /* 0x4e9edc: already listed, returns; value = list index */
    ACTION78_EFFECT_SOUND = 0x25,      /* 0x4fb2e3 request; value = slot (0x17) */
    ACTION78_EFFECT_COUNT = 0x26,      /* 0x4ea006 count stored; value = new count */
    ACTION78_EFFECT_LIST = 0x27,       /* count*2 bytes copied to the list; value = words */
    ACTION78_EFFECT_PRESENCE = 0x28,   /* 0x4ea02f presence[item] := 1; value = item */
    ACTION78_EFFECT_UI = 0x29,         /* 0x4e0559(1, 1, 0) request; value = 1 */
    ACTION78_EFFECT_HELD = 0x2a        /* 0x583a29 stored; value = signed word stored */
} Action78Effect;

typedef struct {
    /* inventory.rebuild_view = 0x4e812f; inventory.observe = ordered effects
     * (optional, production leaves it NULL). */
    Action79Host inventory;
    /* 0x4fb2e3(slot): the sound request made before the list stores. */
    int (*request_sound)(void *context, uint16_t slot);
    /* 0x4e0559(index, enable, sub) on object 0x570508 after the rebuild. */
    int (*request_ui_animation)(void *context, int16_t index, int32_t enable, int16_t sub);
    void *context;   /* passed to the two requests above */
} Action78Host;

typedef struct {
    uint8_t took_in_hand;     /* flag_take != 0 branch executed */
    uint8_t put_back;         /* 0x4e8d96 returned the held item to the list */
    uint8_t removed;          /* 0x4ea06c found and removed the item */
    uint8_t added;            /* number of 0x4e9e84 calls that inserted an item (0..2) */
    uint8_t duplicates;       /* number of 0x4e9e84 calls that found a duplicate (0..2) */
    uint8_t sound_requests;
    uint8_t ui_requests;
    uint8_t held_changed;     /* number of stores to 0x583a29 */
    uint8_t completed;        /* 0x4eac3f stored 1 into the completion byte */
} Action78Result;

/* One true-gate visit (0x4eaadc). Every rejection happens before any effect:
 * a dry run over private copies of the model predicts each sub-step (null
 * arguments; count above the item array; count below -1 (the original would
 * copy a negative length); no room for the new word (the original overflows
 * into the adjacent array 0x583abd); an item outside the presence array when it
 * has to be written; a missing rebuild/sound/UI provider when the path needs
 * one). A provider failure in the real run is ACTION78_ERR_HOST with the
 * earlier effects committed. */
int action78_visit(const Action78Object *object, const Action78Model *model,
                   const Action78Host *host, Action78Result *result,
                   const char **failure);

#ifdef __cplusplus
}
#endif
#endif
