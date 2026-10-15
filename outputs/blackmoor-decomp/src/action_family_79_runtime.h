#ifndef BLACKMOOR_ACTION_FAMILY_79_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_79_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0x79 "Remove Inventory Item, No Hotspot" (RT-13).
 *
 * Original: dispatcher arm 0x429486 evaluates the row's dependency tree
 * (0x423f57, mode 0). Only when it is true does it call 0x4eac4c on the
 * inventory view object 0x571442 with the row index. 0x4eac4c reads the
 * 16-bit item id (the two-byte object built at load time, A-79.1), calls
 * 0x4ea06c(id), then stores -1 into the held item 0x583a29 when that word
 * equals the id, then stores 1 into the row's completion byte 0x5bb625+row*0x8d
 * (direct store: NOT 0x42ba3a, so the subtype is never consulted and
 * dependencies are never reset). A false gate performs none of this.
 *
 * 0x4ea06c: searches the item list (word array 0x583a31, signed count word
 * 0x583a2b) for the FIRST entry equal to the sign-extended id. Not found: it
 * returns with no effect at all. Found: the remaining entries are copied in
 * order into a scratch array in the view object (+0x828a), the count word
 * becomes the number of kept entries, only that many words are copied back
 * (stale words beyond the new count keep their old values), presence dword
 * 0x583bd5[id] becomes 0, and 0x4e812f (view rebuild) is called.
 *
 * Modeled here: held item, item count, item list, presence. NOT modeled
 * (UNVERIFIED, scratch / derived): view scratch +0x822e/+0x8316/+0x828a, and
 * everything 0x4e812f derives (lists 0x583abd/0x583b49, words
 * 0x583a2d/0x583a2f, per-page slot table +0x7fae, paging floats). */

#define ACTION79_RAW_TYPE UINT8_C(0x79)

typedef enum {
    ACTION79_OK = 0,
    ACTION79_ERR_ARGUMENT = 1,
    /* A required host provider is absent; nothing was changed. */
    ACTION79_ERR_UNSUPPORTED = 2,
    /* Model state the native model refuses (original would read or write
     * outside the recovered arrays); nothing was changed. */
    ACTION79_ERR_BOUNDS = 3,
    /* The view-rebuild provider failed AFTER the list/count/presence were
     * committed (as in the original, where the rebuild follows them). The
     * held item and completion are not touched. */
    ACTION79_ERR_HOST = 4
} Action79Status;

typedef struct {
    int16_t *held_item;        /* 0x583a29 (-1: none) */
    int16_t *item_count;       /* 0x583a2b, signed word */
    uint16_t *items;           /* 0x583a31, words */
    size_t item_capacity;      /* words readable and writable at items */
    int32_t *presence;         /* 0x583bd5, dwords */
    size_t presence_capacity;
} Action79Model;

/* Ordered effect markers for oracles and tests; each is reported right after
 * the corresponding store in the original's order. */
typedef enum {
    ACTION79_EFFECT_VISIT = 1,    /* 0x4ea06c entered; value = sign-extended id */
    ACTION79_EFFECT_COUNT = 2,    /* 0x583a2b stored; value = new count */
    ACTION79_EFFECT_LIST = 3,     /* kept words copied back; value = how many */
    ACTION79_EFFECT_PRESENCE = 4, /* 0x583bd5[id] stored 0; value = id */
    ACTION79_EFFECT_REBUILD = 5,  /* 0x4e812f about to run; value = id */
    ACTION79_EFFECT_HELD = 6,     /* 0x583a29 stored -1 */
    ACTION79_EFFECT_COMPLETE = 7  /* completion byte store requested (value 1) */
} Action79Effect;

typedef struct {
    void *context;
    /* 0x4e812f(ECX=0x571442). Called after the list, count and presence are
     * committed and BEFORE the held item is cleared. A nonzero return is a
     * host failure. */
    int (*rebuild_view)(void *context, int16_t removed_item);
    /* Optional diagnostic observer (may be NULL; production leaves it NULL). */
    void (*observe)(void *context, int effect, int32_t value);
} Action79Host;

typedef struct {
    uint8_t found;          /* 0x4ea06c reached the compaction path */
    uint8_t rebuild_called;
    uint8_t held_cleared;   /* 0x4eac4c stored -1 into 0x583a29 */
    uint8_t completed;      /* 0x4eac4c stored 1 into the completion byte */
    int32_t found_index;    /* -1 when not found */
} Action79Result;

/* One true-gate visit (0x4eac4c) of a row whose item word is `item_word`.
 * Rejections happen before any effect: null arguments; capacity smaller than
 * the signed count (the original would scan into the adjacent arrays); a
 * found id outside the presence array (original writes 0x583bd5+4*id for
 * any signed id); found with a NULL rebuild provider. A negative count scans
 * nothing, exactly as the original's signed compare. */
int action79_visit(uint16_t item_word, const Action79Model *model,
                   const Action79Host *host, Action79Result *result,
                   const char **failure);

#ifdef __cplusplus
}
#endif
#endif
