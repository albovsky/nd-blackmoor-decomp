#ifndef BLACKMOOR_INVENTORY_BUTTON_RUNTIME_H
#define BLACKMOOR_INVENTORY_BUTTON_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* RT-22 follow-up: the bottom task bar (UI object 0x570508, boot chunk TASK) and its five
 * buttons, as far as it takes a real left click to reach the inventory view.
 *
 * Original code recovered (GAME.EXE, SHA-256 afd337a2...485c45), all from the disassembly:
 *
 *   chunk     TASK (1867 bytes, copied to object+4 by 0x4e069c, called at 0x4363b2 right after
 *             the VIEW chunk is copied to 0x583186). Chunk +0x31: bar bounds left, top, right,
 *             bottom (object +0x35.. = 0, 385, 639, 479 in the owned game). Chunk +0x61: five
 *             records of 0x162 bytes, loaded into the button objects (stride 0x18f at object
 *             +0x757) by 0x4e06c0 -> 0x4e1db3. Record fields used here: +0x42 id (0..4),
 *             +0x96/+0x9a/+0x9e/+0xa2 left, top, right, bottom (button +4/+8/+0xc/+0x10), +0xa6
 *             relative flag (add the VIEW origin 0x583186/0x58318a), +0xaa hover changes the
 *             state, +0xae hover selects the button cursor and event 0x27d8, +0xb6 initial
 *             state, +0xba click delay in ms, +0xbe sound name (9 bytes, "NO SOUND" means
 *             none), +0xdf sound slot word.
 *   hover     0x4d3073 (per tick, while 0x583204 is not 2..5): event 0x5c39e5 := -1, then
 *             0x4e075a (needs object state +0xf2a == 1): when the cursor rectangle
 *             (0x583102, 0x583106, 0x58310a, 0x58310e) lies inside the bar bounds the cursor
 *             becomes index 4 / variant 0 (0x5b44f0/f4), the hot point (x, y) of the current
 *             cursor (CURS chunk table 0x5b30cc/d0) is added to the cursor rectangle's left/top
 *             (object +0xf22/+0xf26) and every button is hit-tested in order by 0x4e22fd until
 *             one hits. Inclusive rectangle test on the low words. Mode 0 buttons in state 0,
 *             1 or 3 only: a hit sets the hovered flag +0x183, state := 1 when the record says
 *             so (and the state is not 3), and with the cursor flag event := 0x27d8 and cursor
 *             variant := 1; a miss in state 1 returns to state 0. A pressed (2) or disabled (4)
 *             button never reports a hit.
 *   click     0x43b19e/0x43b1dc (left click pending, 0x583204 not 2..5): 0x4e0978 (needs +0xf2a
 *             == 1) asks every button in order (0x4e26fc): hovered, no pending click flag
 *             +0x17b and state 0 or 1 -> state := 2, deadline +0x2c := GetTickCount() + delay,
 *             and when the record names a sound the sound name/slot are requested; a hovered
 *             button in state 3 (locked) returns 1 without effect. The first button that
 *             returns 1 ends the loop. The scene's own click flag 0x5e32b9 is not set while the
 *             event is 0x27d8 (0x43b1fc).
 *   process   0x43cf34..0x43cf9c (per tick at the end of the main loop while 0x583204 is 0 or
 *             above 5): 0x4e0e2b. First 0x4e18e5(word 0x5bb57b) applies the lock table
 *             0x5a1620 (stride 0x1a4) to the five buttons; then object state 0 loads the frame
 *             image and becomes 1, state 1 runs the button timers (0x4e29ec: stage 0 -> 1 on the
 *             first call; a pressed button whose deadline has passed and whose sound (if any)
 *             is no longer busy returns to state 0 and sets +0x17b), clears the five byte flags
 *             and sets the one of every button whose +0x17b it consumes (0x4e2913): button 0
 *             -> 0x583220, 1 -> 0x583232 (inventory), 2 -> 0x583233, 3 -> 0x583234, 4 ->
 *             0x58321f.
 *   open      0x43a7ca (start of the next main-loop tick) consumes 0x583232 while 0x583204 is 0.
 *             That part is in inventory_view_runtime.h / the app.
 *
 * Not modelled: the lock table producers (the scene action handler 0x4e13e4 and 0x4e1305), the
 * locked-button message (0x4e0a22.., a text pick by table 0x4e1b79), the second text-bar
 * table, button modes other than 0, drawing, the key and menu triggers, the other four
 * buttons' actions (their flags are produced and reported only). */

#define TASKBAR_BUTTONS 5u
#define TASKBAR_CHUNK_BYTES 1867u      /* 0x1d2 dwords + word + byte copied by 0x4e069c */
#define TASKBAR_BOUNDS_OFFSET 0x31u
#define TASKBAR_RECORDS_OFFSET 0x61u
#define TASKBAR_RECORD_BYTES 0x162u
#define TASKBAR_LOCK_RANGES 50u        /* word pairs per lock entry (0x5a1624 / 0x5a1688) */
#define TASKBAR_LOCK_RANGE_INIT 0x270f /* lo and hi word fill of 0x4e1a7e */
#define TASKBAR_BUTTON_INVENTORY 1u    /* sets byte 0x583232 */
#define TASKBAR_EVENT_NONE (-1)
#define TASKBAR_EVENT_BUTTON 0x27d8
#define TASKBAR_BAR_CURSOR_INDEX 4
#define TASKBAR_BAR_CURSOR_VARIANT 0
#define TASKBAR_SOUND_NAME_BYTES 9u

typedef enum {
    TASKBAR_OK = 0,
    TASKBAR_ERR_ARGUMENT = 1,
    TASKBAR_ERR_FORMAT = 2,        /* chunk shorter than the original's fixed copy */
    TASKBAR_ERR_HOST = 3           /* a host callback failed or is missing */
} TaskbarStatus;

typedef enum {
    TASKBAR_STATE_NORMAL = 0,
    TASKBAR_STATE_HOVER = 1,
    TASKBAR_STATE_PRESSED = 2,
    TASKBAR_STATE_LOCKED = 3,
    TASKBAR_STATE_DISABLED = 4
} TaskbarButtonState;

typedef struct {
    int32_t id;                    /* record +0x42 */
    int32_t rect[4];               /* left, top, right, bottom after the optional origin */
    int32_t relative;              /* record +0xa6 */
    int32_t hover_changes_state;   /* record +0xaa */
    int32_t cursor_flag;           /* record +0xae */
    int32_t initial_state;         /* record +0xb6 */
    uint32_t delay_ms;             /* record +0xba */
    uint8_t has_sound;             /* record +0xbe differs from "NO SOUND\0" */
    char sound_name[TASKBAR_SOUND_NAME_BYTES + 1u];
    uint16_t sound_slot;           /* record +0xdf */
} TaskbarButtonLayout;

typedef struct {
    int32_t bounds[4];             /* chunk +0x31: left, top, right, bottom */
    TaskbarButtonLayout button[TASKBAR_BUTTONS];
} TaskbarLayout;

int taskbar_layout_from_task(const uint8_t *chunk, size_t length, int32_t origin_x,
                             int32_t origin_y, TaskbarLayout *out);

typedef struct {
    int32_t kind;                  /* dword 0x5a1620 + i * 0x1a4: 0 ranges, 1 locked, 2 unlock */
    int16_t lo[TASKBAR_LOCK_RANGES];   /* words 0x5a1624 + i * 0x1a4 */
    int16_t hi[TASKBAR_LOCK_RANGES];   /* words 0x5a1688 + i * 0x1a4 */
} TaskbarLock;

typedef struct {
    int32_t state;                 /* +0x30 */
    int32_t stage;                 /* +0x14: 0 not started, 1 running */
    uint8_t hovered;               /* +0x183 */
    uint8_t click_flag;            /* +0x17b */
    uint32_t deadline;             /* +0x2c */
} TaskbarButton;

typedef struct {
    int32_t state;                 /* object +0xf2a: 0 not loaded, 1 running */
    TaskbarButton button[TASKBAR_BUTTONS];
    TaskbarLock lock[TASKBAR_BUTTONS];   /* power-on (0x4e1a7e): kind 0, every lo/hi word 0x270f */
    uint8_t flag[TASKBAR_BUTTONS]; /* bytes 0x583220, 0x583232, 0x583233, 0x583234, 0x58321f */
    int32_t event;                 /* dword 0x5c39e5 as left by the bar */
    int32_t cursor_index;          /* dword 0x5b44f0 (host input before a hover) */
    int32_t cursor_variant;        /* dword 0x5b44f4 */
    int32_t hover_id;              /* object +0xf32: id of the last hit button, -1 none */
} Taskbar;

typedef struct {
    /* Hot point (dx, dy) of cursor (index, variant): CURS chunk table 0x5b30cc/0x5b30d0. */
    int (*hotspot)(void *context, int32_t index, int32_t variant, int32_t *dx, int32_t *dy);
    /* 0x4fb77a(name) + 0x4fb2e3(slot) at a press. */
    int (*request_sound)(void *context, const char *name, uint16_t slot);
    /* 0x4f6334(slot): nonzero while the sound still plays. */
    int (*sound_busy)(void *context, uint16_t slot, int *busy);
    void *context;
} TaskbarHost;

/* Power-on state of the bar object after 0x4e06c0: object state 0, buttons in their record
 * state, stage 0, no hover, no flag, the lock table as 0x4e1a7e fills it (kind 0, every
 * range word 0x270f: nothing below scene request 9999 is locked), event -1, hover id -1. */
int taskbar_init(Taskbar *bar, const TaskbarLayout *layout);

/* 0x4e18e5: apply the lock table for the word 0x5bb57b (scene request). */
int taskbar_apply_locks(Taskbar *bar, int16_t scene_request);

typedef struct {
    uint8_t ran;                   /* object state was 1 */
    int32_t cursor_index;          /* after the bar-bounds test */
    int32_t cursor_variant;        /* after the button hit */
    uint8_t cursor_forced;         /* the bar-bounds test chose index 4 / variant 0 */
    int32_t x, y;                  /* object +0xf22 / +0xf26: cursor rectangle left/top + hot point */
    int32_t hit;                   /* index of the button that hit, -1 none */
    int32_t event;                 /* 0x5c39e5 after */
} TaskbarHoverResult;

/* 0x4d308b + 0x4e075a. pointer_rect: 0x583102, 0x583106, 0x58310a, 0x58310e
 * (left, top, right, bottom). bar->cursor_index/variant must hold the cursor of the previous
 * tick (0x5b44f0/f4) and are updated. */
int taskbar_hover(Taskbar *bar, const TaskbarLayout *layout, const int32_t pointer_rect[4],
                  const TaskbarHost *host, TaskbarHoverResult *result);

typedef struct {
    uint8_t ran;                   /* object state was 1 */
    int32_t pressed;               /* button index that started its press, -1 none */
    int32_t locked_click;          /* button index of a click on a locked button, -1 none */
    uint8_t sound_requested;
} TaskbarClickResult;

/* 0x4e0978 for one left click, now = GetTickCount(). */
int taskbar_click(Taskbar *bar, const TaskbarLayout *layout, uint32_t now,
                  const TaskbarHost *host, TaskbarClickResult *result);

typedef struct {
    uint8_t loaded;                /* object state 0 -> 1 this call (frame image load) */
    uint8_t flags_cleared;
    uint8_t flag_set[TASKBAR_BUTTONS];   /* flags produced by this call */
    uint8_t completed[TASKBAR_BUTTONS];  /* presses whose timer expired this call */
} TaskbarProcessResult;

/* 0x4e0e2b (with 0x4e18e5 first). */
int taskbar_process(Taskbar *bar, const TaskbarLayout *layout, int16_t scene_request,
                    uint32_t now, const TaskbarHost *host, TaskbarProcessResult *result);

#ifdef __cplusplus
}
#endif
#endif
