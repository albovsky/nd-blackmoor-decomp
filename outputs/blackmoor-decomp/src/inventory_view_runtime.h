#ifndef BLACKMOOR_INVENTORY_VIEW_RUNTIME_H
#define BLACKMOOR_INVENTORY_VIEW_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#include "action_family_78_runtime.h"

#ifdef __cplusplus
extern "C" {
#endif

/* RT-22: the full-screen inventory view (class object 0x571442) as far as the
 * tutorial needs it: open, pointer hit test, pick an item up, put it back.
 *
 * Original code recovered (all addresses in GAME.EXE, SHA-256 afd337a2...485c45):
 *
 *   open      0x43a7ca (main message loop) sees byte 0x583232 != 0 while the screen
 *             state dword 0x583204 is 0: it clears the byte, stores 3 into 0x583204,
 *             then runs 0x4e8622 (view setup: reset 0x4e7ba7, slot rectangles from
 *             the UIIV chunk, tab selection), 0x4e8994(2) (target mode 2) and the
 *             mode machine 0x4e94c1. The machine leaves modes 0/4/5 and reaches
 *             mode 2 (view dword +0x764c); the transition (0x4ee5cd.., fades) is NOT
 *             recovered: the native open enters mode 2 directly.
 *   hover     0x4d3106 calls 0x4e89eb every tick while 0x583204 == 3 and no click is
 *             pending. For modes 2 and 3 it adds the cursor hot point to the pointer
 *             (view +0x823a / +0x823e), then 0x4e8bb4: hot item +0x6b1c := -1,
 *             event [0x5c39e5] := 0x2717 when the held item 0x583a29 is -1, else
 *             0x2718, then the 16-slot scan (stride 0x28 at +0x7fae): a slot with an
 *             item hits when x in [left + 11, right] and y in [top + 10, bottom - 10];
 *             the first hit sets +0x6b1c := its item id and highlights the slot, every
 *             slot before it is un-highlighted, slots after it are not touched.
 *   click     0x43c0aa calls 0x4e8dc8 (modes 2 and 3; the frame control 0x4ee517 and
 *             the six tab buttons +0x7012 may consume the click first), which calls
 *             0x4e8e78. Branches in order: (a) item kind word == 3, text word not 0
 *             and not 0x270f, aux 0x583ced[hot] == 0: read/examine 0x4ea269; (b) aux
 *             0x583ced[hot] == 1 and aux 0x583e05[hot] == 1: use text; (c) event 0x2717,
 *             hot != -1, aux 0x583ced[hot] == 0, held == -1: PICK UP (0x4e93da):
 *             held := hot (0x4e941b), remove from the list 0x4ea06c, sound 0x4fb2e3(0x17),
 *             and when view byte +0x7011 != 0 the view closes (0x4e7d04: teardown
 *             0x4edb97, 0x4e7bf3 resets mode/tab/scroll, 0x583204 := 0, 0x4d36ed);
 *             (d) event 0x2718, held != -1: PUT BACK (0x4e945c): add 0x4e9e84(held, 1),
 *             held := -1 (0x4e9485), sound 0x4fb2e3(0x14). Otherwise the click is
 *             ignored (0x4e94a1).
 *
 * Branches (a) and (b) are recovered as conditions only; their effects (text boxes,
 * sounds) are not implemented and the native click reports
 * INVVIEW_ERR_UNMODELED without any effect. The tab lists 0x65/0x66 (derived lists
 * 0x583abd/0x583b49) and page scrolling are not modelled: the rebuild fills the
 * slots from the full list only (tab -1 or 0x64), page 0.
 */

#define INVVIEW_SLOTS 16u
#define INVVIEW_PANELS 6u
#define INVVIEW_ITEMS 70u            /* INV chunk records of 0x16d bytes */
#define INVVIEW_UIIV_BYTES 2860u     /* chunk copied to view +0x6b20 (0x2cb dwords) */
#define INVVIEW_INV_BYTES 25727u     /* chunk copied to view +0x69d */
#define INVVIEW_MODE_OPEN 2
#define INVVIEW_STATE_NONE 0         /* 0x583204 */
#define INVVIEW_STATE_INVENTORY 3
#define INVVIEW_EVENT_PICK 0x2717
#define INVVIEW_EVENT_PUT 0x2718
#define INVVIEW_SOUND_PICK 0x17u
#define INVVIEW_SOUND_PUT 0x14u

typedef enum {
    INVVIEW_OK = 0,
    INVVIEW_ERR_ARGUMENT = 1,
    INVVIEW_ERR_UNSUPPORTED = 2,   /* provider absent; nothing changed */
    INVVIEW_ERR_BOUNDS = 3,        /* state the original would read/write outside its arrays */
    INVVIEW_ERR_HOST = 4,          /* provider failed after earlier effects (no rollback) */
    INVVIEW_ERR_UNMODELED = 5,     /* recovered branch whose effects are not implemented */
    INVVIEW_ERR_TAB = 6            /* rebuild for a tab list that is not modelled */
} InventoryViewStatus;

/* Resolved geometry and flags, from the UIIV boot chunk (view +0x6b20..) and the
 * VIEW origin 0x583186 / 0x58318a. */
typedef struct {
    int32_t relative;              /* view +0x6b87: add the origin to every rectangle */
    uint8_t slot_flag;             /* view +0x7010 (item-last layout together with mode 2) */
    uint8_t close_flag;            /* view +0x7011 (close after a pick up) */
    int32_t first_tab;             /* tab id of the first enabled panel (+0x7012, id +0x7016), -1 none */
    int32_t rect[INVVIEW_SLOTS][4];/* left, top, right, bottom after the origin (0x4e8725..0x4e87bb) */
} InventoryViewLayout;

/* uiiv: the 2860-byte UIIV chunk payload. origin: 0x583186 / 0x58318a. */
int inventory_view_layout_from_uiiv(const uint8_t *uiiv, size_t length, int32_t origin_x,
                                    int32_t origin_y, InventoryViewLayout *out);

/* Item kind (record +0x30 = view +0x77e) and text word (+0x32 = +0x780) of the INV
 * chunk records (base +0xb1, stride 0x16d). */
int inventory_view_items_from_inv(const uint8_t *inv, size_t length,
                                  int16_t kind[INVVIEW_ITEMS], int16_t text[INVVIEW_ITEMS]);

typedef struct {
    int32_t screen_state;          /* dword 0x583204 */
    int32_t mode;                  /* view +0x764c */
    int32_t tab;                   /* +0x8232 (-1 after the reset 0x4e7ba7) */
    int32_t tab_applied;           /* +0x8236 */
    int32_t page;                  /* +0x825e (0: scroll value +0x8252 is 0 after the reset) */
    int32_t hot;                   /* +0x6b1c */
    int32_t event;                 /* dword 0x5c39e5 as written by the hover */
    int32_t cursor_variant;        /* dword 0x5b44f4 (1 after a hit) */
    int32_t slot_item[INVVIEW_SLOTS];  /* +0x7fae + 0x28*i */
    int32_t slot_lit[INVVIEW_SLOTS];   /* +0x7fb2 + 0x28*i */
} InventoryView;

/* The state after load: every slot -1 and un-lit, hot -1 (0x4e7e15..0x4e7f6b),
 * the reset 0x4e7ba7 (mode 0, tab -1). Does not rebuild. */
void inventory_view_init(InventoryView *view);

/* 0x4e812f restricted to the full list: slots[i] := list[page * 16 + i] for the
 * indices below min(count, 0x46), others -1. Tabs 0x65..0x69 return INVVIEW_ERR_TAB. */
int inventory_view_rebuild(InventoryView *view, const Action79Model *inventory, const char **failure);

/* Open (0x43a7ca branch). Requires screen_state 0 (else nothing happens and
 * *opened is 0). */
int inventory_view_open(InventoryView *view, const InventoryViewLayout *layout, int *opened);

/* 0x4e89eb + 0x4e8bb4. (px, py) is the pointer plus the cursor hot point. Nothing
 * happens (hover_ran 0) unless screen_state is 3 and mode is 2 or 3. */
int inventory_view_hover(InventoryView *view, const InventoryViewLayout *layout, int32_t px,
                         int32_t py, int16_t held_item, int frame_consumed, int *hover_ran);

/* 0x4ee2a9 (called first by 0x4e89eb): the cursor the frame selects. override is
 * dword 0x5c39e9, held_flag is dword 0x5b44f8. Writes 0x5b44f0 / 0x5b44f4. A nonzero
 * return of 0x4ee2a9 (the pointer is on a frame control, 0x4e22fd / 0x4ef2d1) is the
 * hover's frame_consumed argument: the native app has no frame controls. */
void inventory_view_cursor_choice(int16_t held_item, int32_t override, int32_t held_flag,
                                  int32_t *index, int32_t *variant);

/* Hot point (dx, dy) of cursor (index, variant): dwords at CURS chunk +0x1ac0 +
 * index * 16 + variant * 8 (table 0x5b30cc / 0x5b30d0; the chunk is copied to
 * 0x5b160c, 8580 bytes, 107 cursors x 2 variants). */
int inventory_view_cursor_hotspot(const uint8_t *curs, size_t length, int32_t index,
                                  int32_t variant, int32_t *dx, int32_t *dy);

/* Pure hit test of one slot (0x4e8c53..0x4e8cea). */
int inventory_view_slot_hit(const InventoryViewLayout *layout, size_t slot, int32_t px, int32_t py);

/* Ordered effect markers (delivered through the inventory observer together with
 * the Action79/Action78 markers of the shared steps). */
typedef enum {
    INVVIEW_EFFECT_PICK = 0x40,    /* 0x4e93da taken; value = hot item */
    INVVIEW_EFFECT_PUT = 0x41,     /* 0x4e945c taken; value = held item */
    INVVIEW_EFFECT_SOUND = 0x42,   /* 0x4fb2e3 request from the view; value = slot */
    INVVIEW_EFFECT_CLOSE = 0x43    /* 0x4e7d04; value = 0 */
} InventoryViewEffect;

typedef struct {
    const int16_t *kind;           /* item record +0x30, INVVIEW_ITEMS words */
    const int16_t *text;           /* item record +0x32 */
    const uint32_t *aux_a;         /* dwords 0x583ced */
    const uint32_t *aux_b;         /* dwords 0x583e05 */
    size_t aux_count;
} InventoryViewItemData;

typedef struct {
    Action78Host inventory;        /* rebuild_view, observe, sound 0x17, UI request (add step) */
    /* 0x4fb2e3(slot) made by the view itself (pick up 0x17, put back 0x14). */
    int (*request_sound)(void *context, uint16_t slot);
    /* 0x4e7d04 host part: UI teardown 0x4edb97 and 0x4d36ed. */
    int (*close_view)(void *context);
    void *context;
} InventoryViewHost;

typedef struct {
    uint8_t gate_open;             /* mode was 2 or 3 and nothing consumed the click */
    uint8_t handled;               /* 0x4e8e78 returned 1 */
    uint8_t picked;
    uint8_t put_back;
    uint8_t closed;
    uint8_t sound_requests;        /* by the view itself */
    uint8_t removed;               /* the shared remove step found the item */
    uint8_t added;                 /* the shared add step inserted the item */
} InventoryViewClickResult;

/* One left click (0x4e8dc8 -> 0x4e8e78). frame_consumed: 0x4ee517 or a tab button
 * returned nonzero first (host-provided; the native app has no such controls and
 * passes 0). Rejections happen before any effect except that a pick-up whose shared
 * remove step is rejected restores the held item. */
int inventory_view_click(InventoryView *view, const InventoryViewLayout *layout,
                         const InventoryViewItemData *data, const Action78Model *model,
                         const InventoryViewHost *host, int frame_consumed,
                         InventoryViewClickResult *result, const char **failure);

/* 0x4e7d04 without its host part: 0x4e7bf3 -> 0x4e7ba7 (mode 0, tab -1, scroll 0)
 * and screen_state := 0. The slots and hot item are untouched. */
void inventory_view_close(InventoryView *view);

#ifdef __cplusplus
}
#endif
#endif
