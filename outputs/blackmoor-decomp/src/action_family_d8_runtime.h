#ifndef BLACKMOOR_ACTION_FAMILY_D8_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_D8_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of runtime type 0xd8, the "Peephole puzzle" scroll view (RT-34).
 *
 * Raw 0x44 (AT_SCROLL_LIST_ENTRY) is a loader type only: its handler 0x4121b8 renders the text and then
 * 0x411b16 replaces the row with a 0xd8 record (type byte 0xd8, subtype 1, phase 0). Nothing in the scene corpus
 * carries a raw 0xd8 row; the loader 0x48bca6 ("pData for PEEPHOLE AR") would read the same record layout.
 *
 * Original code (GAME.EXE, SHA-256 afd337a2...5c45), confirmed in the disassembly:
 *   0x427a50  dispatcher arm 0xd8 (0x42a354): gate 0x423f57(deps, 0), then 0x48c1c0(ECX = 0x624686, row).
 *   0x48c1c0  the handler, a phase switch on the row phase dword: 0 init, 1 scroll, 2 finish.
 *   0x48cc70  render callback of the two generic Z entries it registers (type 10).
 *   0x48bb17  reset (constructor 0x48baa7), 0x48bb86 cleanup (scene clear 0x4381f4/0x43dec0, finish),
 *   0x48bc38  slot redraw request (0x43d9a1), 0x48bd91 pointer hit test (cascade 0x4f0059 -> 0x4f0f5f),
 *   0x48c0ac  click (0x43b2dc), 0x48c148  button press (0x43b18a).
 *
 * The record is the 0x868-byte buffer of 0x411b16 truncated to 0x868 - (100 - n) * 0x12 bytes (n = word at
 * +0x15e). Offsets used (all little endian):
 *   +0x00 name (0x21 bytes, NUL terminated)    +0x21 second name (0x21 bytes)   +0x42 mode byte (2 = restore blit)
 *   +0x44/+0x48 dwords (0 in a built record)   +0x4c/+0x50 dwords               +0x54..+0x63 view window source rect
 *   +0x64..+0x73 view window destination rect  +0x74 four button rects          +0xb4 four "down" rects
 *   +0xf4 four "inactive" rects                +0x134 frames per second byte    +0x135.. exit scene change words
 *   +0x14b/+0x14d exit event flag              +0x14e..+0x15d exit rect          +0x15e link count
 *   +0x160 link entries, 0x12 bytes each (word scene, four dwords rect).
 * Every engine call whose body lies outside this slice is a callback of D8Host in the original order. Nothing here
 * claims original source structure. */

#define D8_RUNTIME_TYPE UINT8_C(0xd8)
#define D8_RECORD_MAX_BYTES 0x868u
#define D8_RECORD_FIXED_BYTES 0x160u
#define D8_ENTRY_BYTES 0x12u
#define D8_ENTRY_MAX 100u
#define D8_NAME_BYTES 0x21u
#define D8_NO_SLOT (-1)
#define D8_NO_SCENE 9999
#define D8_TEXT_SURFACES 6u /* the text writer's surface table 0x5d0397 has six entries */

#define D8_CAND_BUTTON 0x27a7
#define D8_CAND_LINK 0x27a8
#define D8_CAND_EXIT 0x27a9

typedef enum D8Status {
    D8_OK = 0,
    D8_ERR_ARGUMENT = 1,
    D8_ERR_BODY = 2,
    D8_ERR_UNSUPPORTED = 3,
    D8_ERR_HOST = 4
} D8Status;

/* Size of a built record with `count` link entries (0x411b16), or 0 when count is outside 0..100. */
size_t d8_record_bytes(int count);

/* The singleton at 0x624686 (offsets from the object start; +0x00 is the vtable and not modelled). The object is
 * zero except for the constructor's 0x48bb17 stores. */
typedef struct D8Object {
    uint8_t dir;               /* +0x1c scroll direction 0..3, 0xff none */
    uint8_t visible;           /* +0x1d render callback draws only when nonzero */
    uint32_t surface1;         /* +0x1e */
    uint32_t surface2;         /* +0x22 */
    int16_t row;               /* +0x26 */
    int16_t hot;               /* +0x28 button or link index of the last hit, -1 none */
    int16_t slot_a;            /* +0x2e generic Z entry of the view window */
    int16_t slot_b;            /* +0x30 generic Z entry of the buttons */
    uint8_t can_move[4];       /* +0x34..+0x37 */
    uint8_t inactive_rect[4];  /* +0x38..+0x3b record rect at +0xf4 not empty */
    uint8_t down_rect[4];      /* +0x3c..+0x3f record rect at +0xb4 not empty */
    uint8_t pressed;           /* +0x40 */
    int16_t pos_41;            /* +0x41 */
    int16_t pos_43;            /* +0x43 */
    uint8_t borrowed;          /* +0x45 surface1 belongs to the text writer, not to this object */
    uint8_t active;            /* +0x46 */
    uint8_t exit_clicked;      /* +0x47 */
    int16_t limit_48;          /* +0x48 */
    int16_t limit_4a;          /* +0x4a */
    int16_t limit_4c;          /* +0x4c */
    int16_t limit_4e;          /* +0x4e */
    uint32_t tick;             /* +0x50 */
    int16_t target_scene;      /* +0x54 */
} D8Object;

typedef enum D8Effect {
    D8_FX_ACTIVE = 1,          /* +0x46 := a */
    D8_FX_START_FLAG = 2,      /* 0x5bb1ca := a */
    D8_FX_ROW = 3,             /* +0x26 := a */
    D8_FX_SLOT = 4,            /* 0x4d39f9 returned a; b = 0 slot A, 1 slot B */
    D8_FX_SLOT_REGISTER = 5,   /* type 10 entry a with callback 0x48cc70, current surface b */
    D8_FX_SURFACE_LOAD = 6,    /* 0x4c2790 returned a; b = 0 first surface, 1 second */
    D8_FX_TEXT_SURFACE = 7,    /* +0x1e := text writer surface a (index b) */
    D8_FX_SLOT_SURFACE = 8,    /* entry a surface := b */
    D8_FX_PHASE = 9,           /* row phase := a */
    D8_FX_SCENE_CELLS = 10,    /* 0x5bb57b := a and the rest of the scene change (see D8Host.scene_change) */
    D8_FX_ENGINE_MODE = 11,    /* 0x583999 := 4 */
    D8_FX_EVENT_FLAG = 12,     /* [0x585801 + 4 * a] := b */
    D8_FX_COMPLETE = 13,       /* 0x42ba3a(row a) */
    D8_FX_RELEASE_SURFACE = 14,/* 0x4c2dfb of surface a (b = 0 second, 1 first) */
    D8_FX_RELEASE_SLOT = 15,   /* 0x4d3992(a) */
    D8_FX_RESET = 16,          /* 0x48bb17 */
    D8_FX_CLEAR_5D1A8F = 17,   /* 0x5d1a8f := 0 */
    D8_FX_TICK = 18            /* +0x50 := a */
} D8Effect;

/* The scene-change cells of the original: 0x5bb57b dword, 0x5bb599/0x5bb595/0x5c39ff words and
 * 0x5bb59b/0x5bb59f/0x5bb5a3 dwords, followed by the engine mode 0x583999 := 4. */
typedef struct D8SceneChange {
    int16_t scene;
    int16_t word[3];
    int32_t dword[3];
} D8SceneChange;

typedef struct D8Host {
    void *context;
    /* 0x4d39f9: first free generic Z entry. Zero on success. */
    int (*alloc_slot)(void *, int16_t *slot);
    /* Entry stores 0x5d1591..0x5d15b3: type 10, callback 0x48cc70, surface, flags 0, 0, 1, 1, word 0, label. */
    int (*register_slot)(void *, int16_t slot, uint32_t surface, const char *label);
    /* 0x4c2790("CIFTREE", name, 6, label). */
    int (*load_surface)(void *, const char *name, const char *label, uint32_t *surface);
    /* Entry surface store (0x5d1599). */
    int (*set_slot_surface)(void *, int16_t slot, uint32_t surface);
    /* 0x4c2dfb(&surface). */
    int (*release_surface)(void *, uint32_t surface);
    /* 0x4d3992: entry flags +0x14 and +0x18 := 0. */
    int (*release_slot)(void *, int16_t slot);
    /* Entry +0x14 := 1 (redraw request, 0x48bc38). */
    int (*mark_dirty)(void *, int16_t slot);
    /* Text writer outputs: surface 0x5d0397[index] and height 0x619a53[index], index 0..5. */
    int (*text_surface)(void *, int index, uint32_t *surface, int32_t *height);
    /* GetTickCount. */
    uint32_t (*tick)(void *);
    /* 0x5bb1ca := value. */
    int (*set_start_flag)(void *, int32_t value);
    /* The scene-change cells and the engine mode. */
    int (*scene_change)(void *, const D8SceneChange *change);
    /* dword [0x585801 + 4 * index] := value (the caller validates the index). */
    int (*set_event_flag)(void *, int16_t index, int32_t value);
    /* Optional ordered effect observer (production may leave it NULL). */
    void (*observe)(void *, int effect, int32_t a, int32_t b);
} D8Host;

typedef struct D8Result {
    uint32_t phase_after;
    uint8_t initialized; /* phase 0 ran */
    uint8_t finished;    /* phase 2 ran: 0x42ba3a was called, the object was cleaned up */
} D8Result;

/* 0x48bb17 plus the constructor state of a power-on object. */
void d8_object_reset(D8Object *object);

/* Native safety check of a record (the original trusts its loader). Rejects a length that is not exactly the
 * record size of its link count, a link count above 100, names not terminated within 0x21 bytes. */
int d8_validate_record(const uint8_t *record, size_t length, const char **failure);

/* One true-gate visit of 0x48c1c0 for a record of the row. Validation precedes the first effect. A status other
 * than D8_OK before the first effect leaves everything untouched; a host failure after effects returns
 * D8_ERR_HOST (the original has no recovery). Phase 1 needs the frame rate byte (+0x134) nonzero (the original
 * divides by it). Phases above 2 do nothing. `exit_event_flag_count` bounds the exit event flag store. */
int d8_step(D8Object *object, const uint8_t *record, size_t length, int16_t row, uint32_t phase,
            size_t event_flag_count, const D8Host *host, D8Result *result, const char **failure);

/* 0x48bb86: release surfaces and entries, then the 0x48bb17 reset. */
int d8_cleanup(D8Object *object, const D8Host *host);

/* 0x48bc38: redraw requests for both entries. */
int d8_mark_dirty(D8Object *object, const D8Host *host);

/* The process globals 0x48bd91 reads and writes. */
typedef struct D8HitInput {
    int16_t item_583a29;  /* selected item word, -1 none */
    int32_t flag_5b44f8;
    int32_t value_5d0377;
    int32_t value_571ad3;
    int32_t cursor_5b44f0; /* current value, used when the hit does not write it */
} D8HitInput;

typedef struct D8HitOutput {
    uint8_t hit;
    uint8_t cursor_written;    /* 0x5b44f0 was written */
    int32_t cursor_5b44f0;
    int32_t flag_5b44f4;       /* 1 on a hit */
    int32_t candidate_5c39e5;  /* D8_CAND_* on a hit */
    uint8_t has_5d162d;        /* 0x5d162d was written */
    int32_t value_5d162d;
    uint32_t table_5d1631;     /* 0x5b160c + 0x20 * cursor + 0x10 * flag_5b44f4 */
    int32_t flag_5d1639;       /* 1 on a hit */
} D8HitOutput;

/* 0x48bd91(x, y) with x = [ptr+0x5e], y = [ptr+0x5a] of the pointer cascade. `record` is the object's row record
 * (nothing is read when the object is not active). Writes object->hot like the original. */
int d8_hit_test(D8Object *object, const uint8_t *record, size_t length, int16_t x, int16_t y,
                const D8HitInput *in, D8HitOutput *out);

/* 0x48c0ac (click) with the candidate 0x5c39e5 set by the hit test. `row_phase` receives the phase store of the
 * original (2) when it happens. */
typedef struct D8ClickOutput {
    uint8_t phase_written;
    uint32_t phase;
} D8ClickOutput;
int d8_click(D8Object *object, const uint8_t *record, size_t length, int32_t candidate,
             D8ClickOutput *out);

/* 0x48c148 (button press): `row_phase` is the phase dword of object->row. */
int d8_press(D8Object *object, uint32_t row_phase, int32_t candidate, const D8Host *host);

/* Geometry of one render callback 0x48cc70. Blits are issued in order; `valid` is 0 when the object is not
 * visible. Rectangles are left, top, right, bottom. */
typedef enum D8BlitKind {
    D8_BLIT_COPY = 0,  /* 0x4c5377 (opaque copy, label last) */
    D8_BLIT_TRANS = 1  /* 0x4c5d4b (transparent blit) */
} D8BlitKind;

typedef enum D8Source {
    D8_SRC_SAVED_FRAME = 0, /* [0x5d15e3] */
    D8_SRC_SLOT_A = 1,      /* surface of entry slot_a (0x5d1599) */
    D8_SRC_SLOT_B = 2       /* surface of entry slot_b */
} D8Source;

#define D8_RENDER_MAX_BLITS 6u

typedef struct D8Blit {
    D8BlitKind kind;
    D8Source source;
    int32_t src[4];
    int32_t dst[4];
    const char *label;
} D8Blit;

typedef struct D8RenderPlan {
    uint8_t valid;
    size_t count;
    D8Blit blit[D8_RENDER_MAX_BLITS];
} D8RenderPlan;

typedef struct D8View {
    int32_t origin_x; /* 0x583186 */
    int32_t origin_y; /* 0x58318a */
} D8View;

int d8_render_plan(const D8Object *object, const uint8_t *record, size_t length, const D8View *view,
                   D8RenderPlan *plan);

#ifdef __cplusplus
}
#endif
#endif
