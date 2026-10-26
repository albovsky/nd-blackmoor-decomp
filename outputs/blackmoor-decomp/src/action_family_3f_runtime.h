#ifndef BLACKMOOR_ACTION_FAMILY_3F_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_3F_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#include "action_sound.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0x3f "sound conversation" (RT-23).
 *
 * Original code (GAME.EXE, SHA-256 afd337a2...5c45), confirmed in the
 * disassembly:
 *   0x427a50  dispatcher arm, runtime types 0x39,0x3a,0x3b,0x3c,0x3e,0x3f: gate
 *             0x423f57 (mode 0), then 0x420c17(ECX = conversation manager
 *             0x6177e8, row).
 *   0x420c17  ONE function with the phase switch on the row phase dword
 *             (0x5bb632 + row*0x8d): 0 init, 1 running, 2 finish. Phase 0 does
 *             NOT fall through into phase 1. Runtime type 0x3f selects the
 *             "sound only" arms (same as 0x3a and 0x3c); 0x39/0x3b/0x3e select
 *             the cel-video arms. RT-25 implements the 0x3e cel arm (frame
 *             cache, reader loop, sound-synced frame choice, render plan of
 *             0x422a0a); raw 0x39/0x3b are not in the corpus and are rejected.
 *   0x4205c1  response list build, 0x420737 condition tree, 0x4209e8 secondary
 *             table, 0x41fa11/0x41fd08/0x42028e response add/replace/remove,
 *             0x41db40 object release.
 *
 * The kernel works on the constructed 0x7a5-byte object image of
 * src/action_family_3f.c (field offsets C3F_*) and on a model of the manager
 * fields it uses (Convo3fManager). Every process global the original reads or
 * writes is a field of Convo3fWorld; every call into engine/UI/sound/inventory
 * code whose body is outside this slice is a callback of Convo3fHost, one per
 * original function, in the original call order. Nothing here claims original
 * source structure.
 *
 * Contract of convo3f_step: all validation (unsupported tier, missing
 * callbacks, out-of-range indexes) happens BEFORE the first effect, so a
 * rejected visit changed nothing (ERR_UNSUPPORTED / ERR_BOUNDS). A callback that
 * fails after earlier effects were committed gives ERR_HOST (the original has no
 * recovery either); the session must stop.
 *
 * Tiers (by object bytes +0x779/+0x77a and primary count, see packet RT-23):
 *   A  hooks 0x14/0x14, no primary entries: sound, secondary flags, transition.
 *   B  hooks 0x14/0x14 with primary entries: response list, selection, response
 *      sound; needs layout_text_box + acquire_surface (host UI).
 *   C  a hook index != 0x14 (flag-dependent response builders 0x43f31a..
 *      0x44499c): explicit ERR_UNSUPPORTED, reason "hook builder".
 * Captions (world.captions_5bb202 != 0) need layout_text_box as well. */

#define CONVO3F_RUNTIME_TYPE UINT8_C(0x3f)
#define CONVO3E_RUNTIME_TYPE UINT8_C(0x3e) /* cel video conversation (RT-25) */
#define CONVO3F_IMAGE_BYTES 0x7a5u
#define CONVO3F_MAX_RESPONSES 30
#define CONVO3F_TEXT_BYTES 400u
#define CONVO3F_NAME_BYTES 33u
#define CONVO3F_NO_SELECTION 0x1f      /* [0x570374] when nothing was chosen */
#define CONVO3F_NO_HOOK 0x14           /* object +0x779/+0x77a: no hook */
#define CONVO3F_NO_SCENE 9999          /* scene word meaning "no transition" */
#define CONVO3F_SOUND_CHANNEL 0x0c     /* object sound */
#define CONVO3F_RESPONSE_CHANNEL 0x0d  /* response sound (second descriptor) */
#define CONVO3F_UI_SOUND_ROWS 60       /* table 0x5b0a9a, stride 0x29 */
#define CONVO3F_UI_SOUND_STRIDE 41
#define CONVO3F_SECONDARY_PLAN 127
#define CONVO3F_SURFACE_NORMAL_NAME "Convo - Generic DFS TextBox Normal Surface"
#define CONVO3F_SURFACE_HILITE_NAME "Convo - Generic DFS TextBox Hilite Surface"

/* Object image offsets (A-3F.1 constructor 0x41c7f4 model). Words are LE. */
enum {
    C3F_SOUND = 0x000,         /* sound descriptor: name[33], see C3F_SND_* */
    C3F_CAPTION = 0x16b,       /* caption text, resolved CONVO key (<= 1499) */
    C3F_SOUND2 = 0x747,        /* second descriptor, literal name "dummy" */
    C3F_FLAG_778 = 0x778,      /* u8: 0 -> 0x41f986 (list reset) at phase 0 */
    C3F_HOOK_A = 0x779,        /* u8, 0x14 none */
    C3F_HOOK_B = 0x77a,        /* u8, 0x14 none */
    C3F_DEFAULT_ENABLE = 0x77b,/* u8: 1 -> default transition */
    C3F_POP_FLAG = 0x77c,      /* u8: 1 -> scene stack pop 0x42e493 */
    C3F_DEFAULT_SCENE = 0x77d, /* s16 -> 0x5bb57b (movsx) */
    C3F_DEFAULT_W1 = 0x77f,    /* s16 -> 0x5bb599 */
    C3F_DEFAULT_W2 = 0x781,    /* s16 -> 0x5bb595 */
    C3F_DEFAULT_W3 = 0x783,    /* s16 -> 0x5c39ff */
    C3F_DEFAULT_D1 = 0x785,    /* s32 -> 0x5bb59b */
    C3F_DEFAULT_D2 = 0x789,    /* s32 -> 0x5bb59f */
    C3F_DEFAULT_D3 = 0x78d,    /* s32 -> 0x5bb5a3 */
    C3F_PRIMARY_COUNT = 0x793, /* s16 */
    C3F_PRIMARY_TABLE = 0x795, /* u32 arena handle, stride 0x1d1 */
    C3F_INTER_COUNT = 0x799,   /* s16 (always 0 for raw 0x3f) */
    C3F_INTER_TABLE = 0x79b,   /* u32 handle, stride 0x1c */
    C3F_SECONDARY_COUNT = 0x79f,/* s16 */
    C3F_SECONDARY_TABLE = 0x7a1 /* u32 handle, stride 10 */
};
/* Sound descriptor fields relative to a descriptor base (0 or C3F_SOUND2). */
enum {
    C3F_SND_NAME = 0x00,     /* 33 bytes */
    C3F_SND_CHANNEL = 0x21,  /* u16, < 32 */
    C3F_SND_FLAGS = 0x23,    /* s16, passed to 0x4fc62d (constant 2 in raw 0x3f) */
    C3F_SND_MODE = 0x25,     /* s16, == 2 selects looping (constant 1 in raw 0x3f) */
    C3F_SND_DWORD = 0x29,    /* u32 stored at channel state +0x134 */
    C3F_SND_GAIN1 = 0x2d,    /* s16 percent */
    C3F_SND_GAIN2 = 0x2f     /* s16 percent */
};
/* Primary (response) entry, stride 0x1d1. */
enum {
    C3F_PE_COND_COUNT = 0x000, /* s16 */
    C3F_PE_COND_TABLE = 0x002, /* u32 handle, 5-byte conditions */
    C3F_PE_TEXT = 0x006,       /* 400 bytes */
    C3F_PE_SOUND_NAME = 0x196, /* 33 bytes */
    C3F_PE_KIND = 0x1b7,       /* u8: 0 add, 1 replace, 2 remove */
    C3F_PE_SCENE = 0x1b8,      /* s16 */
    C3F_PE_W1 = 0x1ba, C3F_PE_W2 = 0x1bc, C3F_PE_W3 = 0x1be,
    C3F_PE_D1 = 0x1c0, C3F_PE_D2 = 0x1c4, C3F_PE_D3 = 0x1c8,
    C3F_PE_EVENT_INDEX = 0x1cc, /* s16, -1 none */
    C3F_PE_EVENT_VALUE = 0x1ce, /* u8 */
    C3F_PE_WORD_1CF = 0x1cf     /* u16 */
};
/* Secondary entry, stride 10: cond count s16, cond handle u32, then: */
enum { C3F_SE_KIND = 6, C3F_SE_ID = 7, C3F_SE_VALUE = 9 };

typedef enum {
    CONVO3F_OK = 0,
    CONVO3F_ERR_ARGUMENT = 1,
    /* A tier or a required host callback is missing. Nothing was changed. */
    CONVO3F_ERR_UNSUPPORTED = 2,
    /* Unsafe original behaviour refused (see convo3f_step). Nothing changed. */
    CONVO3F_ERR_BOUNDS = 3,
    /* A callback failed after earlier effects were committed. */
    CONVO3F_ERR_HOST = 4
} Convo3fStatus;

/* The constructed object: arena[0..0x7a5) is the object image, the tables the
 * image points to live at arena offsets (handle - handle_base). The kernel
 * WRITES the response sound name into the image (+0x747), exactly as the
 * original does, so the arena is mutable. */
typedef struct {
    uint8_t *arena;
    size_t arena_bytes;
    uint32_t handle_base; /* logical handle of arena[0] (never 0) */
} Convo3fObject;


/* ---- cel video arm (raw 0x3e, RT-25) ----
 * Object image offsets of the 0x3e constructor (action_family_3e.c). The sound
 * descriptor of a 0x3e row sits at +0x13a (the first 0x21 bytes name the CIFTREE
 * cel header file, +0x21/+0x42 name the layers). */
#define CONVO3F_CEL_SLOTS 0x4b
#define CONVO3F_CEL_SLOT_LAYERS 4          /* header objects per cache slot */
#define CONVO3F_CEL_MAX_LAYERS 2           /* names at object +0x21 and +0x42 */
#define CONVO3F_CEL_HEADER_BYTES 0x2a      /* copied from the CIFTREE file at +0xf77 */
#define CONVO3F_CEL_FRAME_STRIDE 0x8c      /* names: block + 0x2a + frame*0x8c + layer*0x21 */
#define CONVO3F_CEL_MIN_SLOTS 4
#define CONVO3F_CEL_NO_FRAME (-10)         /* [0x77e]/[0x782] after phase 0 (0xfff6) */
#define CONVO3F_CEL_SOUND_CHANNEL 0x0c
#define CONVO3F_CEL_MAX_BLITS 16
enum {
    C3E_STEP_TABLE = 0x0a5, /* u8[3]: frame step per [0x786] (constructor 1,2,3) */
    C3E_LAYER_NAME = 0x021, /* layer image names, 0x21 bytes each (two) */
    C3E_FIRST = 0x0a8,      /* s16 first frame (constructor 0) */
    C3E_LAST = 0x0aa,       /* s16 last frame (body word 0x63) */
    C3E_PERCENT = 0x0ac,    /* s16[3]: cache percent per [0x786] (constructor 1,2,3) */
    C3E_PRIORITY = 0x0b2,   /* u8[4]: draw order of the layers (constructor 1,0,2,3) */
    C3E_MODE = 0x0b6,       /* u8[4]: 2 selects object rectangles (constructor 1) */
    C3E_RECT_SRC = 0x0ba,   /* 4 x 16 bytes (constructor 0) */
    C3E_RECT_DST = 0x0fa,   /* 4 x 16 bytes (constructor 0) */
    C3E_SOUND = 0x13a       /* sound descriptor, channel word at +0x15b (12) */
};

/* One header object of the frame cache (0x417b04 fills it; field offsets are
 * those of the original 0x55-byte header). `surface` is the host handle of the
 * decoded image (the original stores the data pointer in the first dword);
 * loaded means that dword is nonzero. */
typedef struct {
    uint8_t loaded;
    uint32_t surface;
    int16_t key_2f;     /* +0x2f, passed to the blit */
    int32_t src[4];     /* +0x35..+0x41 */
    int32_t dst[4];     /* +0x45..+0x51 */
} Convo3fCelLayer;

typedef struct {
    int16_t frame;      /* +0x1c, -1 empty */
    Convo3fCelLayer layer[CONVO3F_CEL_SLOT_LAYERS];
} Convo3fCelSlot;

/* Manager fields of the cel arm (0x6177e8 + offset in the comments). */
typedef struct {
    int16_t loaded;     /* +0x68e frames in the cache */
    int16_t slot;       /* +0x690 slot shown, -1 none */
    int16_t next;       /* +0x692 next frame the reader loads */
    int16_t forced;     /* +0x694 frame the reader jumps to, -1 none */
    int16_t capacity;   /* +0x696 usable slots (4..0x4b) */
    int32_t lock;       /* +0x698 0 free, 1 held, 2 closing */
    int16_t frame;      /* +0x69c current frame from the sound sync */
    uint32_t sync_param;/* +0x69e header dword +0x26 */
    int16_t first, last;/* +0x6a2, +0x6a4 */
    uint8_t step_table[4]; /* +0x6a6 -> object +0xa5 (read through the pointer) */
    int32_t sound_offset; /* +0x6aa as an offset into the object (0x13a), 0 for 0x3f */
    int16_t drawn;      /* +0x77e frame last announced to the renderer */
    int16_t target;     /* +0x782 frame to draw */
    int16_t final_seen; /* +0x784 */
    int16_t index_786;  /* +0x786, never written: 0 */
    int16_t stall;      /* +0x788 */
    int16_t relax;      /* +0x78a */
    int16_t boost;      /* +0x78c */
    int16_t layer_count;/* header +0x24 -> +0xf9b */
    int16_t layer_tree[CONVO3F_CEL_MAX_LAYERS]; /* +0xfb5 CIFTREE index per layer */
    uint8_t header[CONVO3F_CEL_HEADER_BYTES];  /* +0xf77 */
    const uint8_t *block;     /* +0xfa5 CIFTREE file image (host owned), NULL none */
    size_t block_bytes;
    int32_t saved_src[CONVO3F_CEL_SLOT_LAYERS][4]; /* +0x6da + layer*0x10 */
    int32_t saved_dst[CONVO3F_CEL_SLOT_LAYERS][4]; /* +0x71a + layer*0x10 */
    int32_t sync_count; /* channel state +0x17a */
    int32_t sync_last;  /* channel state +0x182 */
    uint8_t sound_loaded;
    Convo3fCelSlot slots[CONVO3F_CEL_SLOTS];
} Convo3fCel;

/* One response list entry: the 0x3a-byte record at manager +0x7d9 + i*0x3a
 * plus the CString pool slot i that holds its text (0x41fa11). */
typedef struct {
    uint8_t name[CONVO3F_NAME_BYTES]; /* +0x00 response sound name copy */
    int16_t scene;                    /* +0x21 (0x7fa) transition scene word */
    int16_t word_23, word_25, word_27;/* 0x7fc, 0x7fe, 0x800 */
    int32_t dword_29, dword_2d, dword_31; /* 0x802, 0x806, 0x80a */
    int16_t event_index;              /* +0x35 (0x80e), -1 none */
    uint8_t event_value;              /* +0x37 (0x810) */
    uint16_t word_38;                 /* +0x38 (0x811) */
    uint8_t text[CONVO3F_TEXT_BYTES]; /* pool string, compared case-insensitively */
} Convo3fResponse;

/* The conversation manager 0x6177e8, only the fields modelled here. `cel` holds
 * the fields of the 0x3e cel arm; it stays zero for raw 0x3f. */
typedef struct {
    int16_t row;            /* +0x75b, -1 none */
    uint8_t type;           /* +0x75a runtime type of the row in progress */
    uint32_t sub_state;     /* +0x6b6: 4 running, 5 stop first sound, 6 response sound */
    int16_t response_count; /* +0xf21 */
    int16_t textbox_slot[2];/* +0xf73 normal, +0xf75 hilite; -1 none */
    int32_t cel_thread;     /* +0x6b2: reader thread exists (cel arm only) */
    uint8_t display_name[CONVO3F_NAME_BYTES]; /* +0x75d, '_' shown as ' ' */
    Convo3fResponse responses[CONVO3F_MAX_RESPONSES];
    Convo3fCel cel;
} Convo3fManager;

/* Process globals read or written by 0x420c17 (address in the name). The host
 * copies them in and out around a call (like Overlay36World). Arrays and counts
 * bound the modelled storage; an index outside them is ERR_BOUNDS. */
typedef struct {
    int32_t *events;          /* 0x585801 dwords: event flags */
    size_t event_count;
    int32_t *presence;        /* 0x583bd5 dwords: inventory presence */
    size_t presence_count;
    int16_t held_item;        /* 0x583a29, -1 none */
    int32_t mode_583999;      /* engine mode; phase 0 needs 3, finish writes 4 */
    int32_t flag_5c39e9;      /* conversation active (modal) */
    int32_t flag_5c39ed;      /* second guard */
    int32_t engine_583204;    /* cursor/view state word: 3, 4 released at phase 0 */
    int32_t cursor_583106;    /* compared signed with limit_5b3788 */
    int32_t limit_5b3788;
    int16_t hotspot_x_5b378c, hotspot_y_5b378e;
    int32_t captions_5bb202;  /* captions enabled setting */
    uint8_t fast_convo_58322a;/* Fast Convo setting */
    uint8_t skip_key_58321d;  /* skip key held (written by poll_keys) */
    uint8_t key_58321e;       /* second polled key (written by poll_keys) */
    uint8_t exit_58322b;      /* nonzero: finish pops the scene stack */
    int16_t selected_570374;  /* chosen response index, 0x1f none */
    int32_t chosen_5839b1[CONVO3F_MAX_RESPONSES]; /* set to 1 by the pointer path 0x4e78c2 */
    int32_t start_5bb1ca;
    int16_t stall_limit_5b028e; /* cel arm: stalled ticks before the reader is pushed ahead */
    int32_t view_x_583186, view_y_58318a; /* view origin added to the cel blits */
    /* scene change words written by the finish branches / 0x42e493 */
    int32_t xfer_5bb57b;
    int16_t xfer_5bb599, xfer_5bb595, xfer_5c39ff;
    int32_t xfer_5bb59b, xfer_5bb59f, xfer_5bb5a3;
    /* redraw / UI words (plain stores, never branched on by the kernel) */
    int32_t flag_5bb1c4;      /* 0x43dbd5 := 1 */
    int32_t redraw_5831c8;    /* 0x4d36ed := 1 */
    int16_t redraw_5831c6;    /* 0x4d36ed := 0 */
    int32_t ui_5d191d, ui_5b15da, ui_5b15c8, ui_5b15d6;
    int16_t ui_5b0a8e, ui_5b0a90, ui_5b0a7c;
    int16_t ui_5b0a74, ui_5b0a76; /* text box surface words, read */
    int32_t ui_5b0a1e, ui_5b0a16; /* read (text box extent) */
    uint8_t ui_5b1436[10];    /* byte 0 of ten 0x29-byte cells at 0x5b1436, zeroed at phase 0 */
    /* 0x5b0a9a: per-line sound names filled by the layout markup ('s' command
     * of 0x41e647). The kernel zeroes it at phase 0 and reads row [selected]. */
    uint8_t ui_sound_names[CONVO3F_UI_SOUND_ROWS][CONVO3F_UI_SOUND_STRIDE];
} Convo3fWorld;

/* Request handed to layout_text_box (0x41e3c0, 0x41e647 x2, 0x4c51a5). */
typedef struct {
    int32_t row;
    const uint8_t *caption;        /* object +0x16b */
    size_t caption_length;         /* visible length */
    int16_t response_count;
    const Convo3fResponse *responses;
    int16_t slot_normal, slot_hilite;
} Convo3fLayoutRequest;

/* Host callbacks, one per original function whose body is outside this slice.
 * Return 0 on success; nonzero is a host failure (ERR_HOST). A NULL callback is
 * either REQUIRED (the visit is ERR_UNSUPPORTED before any effect when the path
 * needs it; stated per member) or OPTIONAL (the host has no such engine state;
 * the skip is recorded in Convo3fStepResult.skipped_optional). */
typedef struct {
    void *context;
    ActionSoundBackend *sound; /* REQUIRED: load_sound/play_sound/is_playing/unload_sound.
                                * 0x4fb77a(descriptor)+0x4fb2e3(ch), 0x4f6334(ch), 0x4fba69. */
    /* OPTIONAL. 0x4e7d04 (which = 3) or 0x4eb96e (which = 4) when [0x583204] is 3/4. */
    int (*release_engine_view)(void *context, int which);
    /* OPTIONAL. host part of 0x4e7728(value) (called with 2). */
    int (*engine_mode)(void *context, int32_t value);
    /* OPTIONAL. 0x4e7786(value) (called with 0). */
    int (*engine_aux)(void *context, int32_t value);
    /* OPTIONAL. 0x4db993(x, y) when cursor_583106 < limit_5b3788. */
    int (*cursor_hotspot)(void *context, int32_t x, int32_t y);
    /* REQUIRED when a held item must be put back or a secondary entry of kind 2
     * with value 1 fires. 0x4e9e84(item, flag). */
    int (*inventory_add)(void *context, int16_t item, int flag);
    /* REQUIRED when a secondary entry of kind 2 with value != 1 fires. 0x4ea06c. */
    int (*inventory_remove)(void *context, int16_t item);
    /* REQUIRED for tier B and captions. 0x4c948f + 0x4c2898 (name, 8). Called
     * twice at phase 0 (normal, hilite); *slot receives the cache slot. If it is
     * NULL and no text box is needed, the surfaces are not acquired. */
    int (*acquire_surface)(void *context, const char *name, int16_t word_5b0a74,
                           int16_t word_5b0a76, int16_t *slot);
    /* REQUIRED when a slot was acquired. 0x4c946b(slot). */
    int (*release_surface)(void *context, int16_t slot);
    /* REQUIRED for tier B and captions. Fills world->ui_sound_names. */
    int (*layout_text_box)(void *context, const Convo3fLayoutRequest *request,
                           Convo3fWorld *world);
    /* REQUIRED when world->ui_5b15da != 0 at phase 1. 0x420b9e. */
    int (*refresh_hotspot_surface)(void *context, int16_t slot_normal);
    /* OPTIONAL. 0x4dadff: GetAsyncKeyState of two keys. When NULL the world
     * values skip_key_58321d/key_58321e are left to the host. */
    int (*poll_keys)(void *context, uint8_t *skip_key, uint8_t *other_key);
    /* REQUIRED when finish pops the scene stack (exit_58322b or +0x77c == 1).
     * Performs EXACTLY 0x42e493 on the world: the xfer words from the stack top,
     * xfer_5c39ff := 1, start_5bb1ca := (stack flag != 1), mode := 4. Nonzero
     * means the stack is empty (the original aborts the program there). */
    int (*scene_stack_pop)(void *context, Convo3fWorld *world);
    /* OPTIONAL. 0x4ee673(0). */
    int (*release_ui_hook)(void *context, int32_t value);
    /* OPTIONAL. host part of 0x4e7757 (engine mode word := 1, 0x4e76ed). */
    int (*engine_restore)(void *context);
    /* ---- cel arm (raw 0x3e). All REQUIRED for a 0x3e visit; a missing one is
     * ERR_UNSUPPORTED before any effect. Nonzero return = host failure. ---- */
    /* 0x418e52("CIFTREE", name, &size): the CIFTREE file image of the cel header
     * (0x2a-byte header, then frames of 0x8c bytes). `name` is the 33-byte field at
     * object +0x00. The block stays valid until cel_release_header. NULL block or
     * a size below 0x2a is the original's fatal failure. */
    int (*cel_load_header)(void *context, const uint8_t *name, const uint8_t **block,
                           size_t *size);
    /* 0x41a216(name): CIFTREE directory index of a layer image file (33-byte name),
     * -1 when absent (the original logs and aborts). */
    int (*cel_tree_index)(void *context, const uint8_t *name, int16_t *index);
    /* Bytes 0x5d34ef/0x5d34f0 of the directory record `index`: layer kind (0,1,3 or 2)
     * and transparency (1 colour key, 2 opaque), read by the render callback. */
    int (*cel_tree_info)(void *context, int16_t index, uint8_t *kind, uint8_t *transparency);
    /* 0x417b04(tree_index, name, header): decode one layer image of one frame and fill
     * the header object (loaded := 1). */
    int (*cel_load_layer)(void *context, int16_t tree_index, const uint8_t *name,
                          Convo3fCelLayer *layer);
    /* 0x4c2e5b: release the decoded data of a loaded layer header. */
    int (*cel_free_layer)(void *context, int16_t slot, int layer, uint32_t surface);
    /* 0x51dc6c of the header block, only when a block is held. */
    int (*cel_release_header)(void *context);
    /* 0x51dc43(0x46) + 0x4497a0(0x422e4a, ...): create the SUSPENDED reader thread. The
     * host may schedule convo3f_cel_reader_iteration however it likes. */
    int (*cel_reader_create)(void *context);
    /* 0x449bff: resume the reader. */
    int (*cel_reader_resume)(void *context);
    /* 0x449a94 plus the virtual delete of the thread object. */
    int (*cel_reader_destroy)(void *context);
    /* 0x4f6cdc(channel, frames, param): start the sound with frame sync. Nonzero is the
     * original's 0 return (fatal). */
    int (*sound_sync_init)(void *context, uint16_t channel, uint16_t frames, uint32_t param);
    /* 0x4f6334 and 0x4f81fa plus the ftol of 0x4f6ef4: *playing is the is-playing
     * answer; when playing, *raw_frame is the unclamped frame (>= 0) or -1 when
     * the position cannot be read. The kernel applies the monotonic clamp. */
    int (*sound_sync_frame)(void *context, uint16_t channel, int *playing, int32_t *raw_frame);
} Convo3fHost;

/* Bits of Convo3fStepResult.skipped_optional. */
enum {
    CONVO3F_SKIP_ENGINE_VIEW = 1u << 0,
    CONVO3F_SKIP_ENGINE_MODE = 1u << 1,
    CONVO3F_SKIP_ENGINE_AUX = 1u << 2,
    CONVO3F_SKIP_CURSOR = 1u << 3,
    CONVO3F_SKIP_SURFACES = 1u << 4,
    CONVO3F_SKIP_KEYS = 1u << 5,
    CONVO3F_SKIP_UI_HOOK = 1u << 6,
    CONVO3F_SKIP_ENGINE_RESTORE = 1u << 7
};

typedef struct {
    uint32_t phase_after;     /* row phase dword after the visit */
    uint8_t ran;              /* the visit did something (false: a gate refused) */
    uint8_t started;          /* phase 0 init ran */
    uint8_t finished;         /* phase 2 ran: completion byte := 1, phase := 0 */
    uint8_t scene_change;     /* mode := 4 with the xfer words set */
    uint8_t object_released;  /* 0x41db40: the object image must not be used again */
    uint32_t skipped_optional;/* CONVO3F_SKIP_* */
} Convo3fStepResult;

/* Condition tree 0x420737(conditions, count, scratch): count 5-byte records
 * {kind u8 (1 event flag, 2 presence), index s16, value u8, link u8}. count == 0
 * and count < 0 are true. Needs count bytes of scratch. Index outside the
 * world arrays is ERR_BOUNDS. *result is 0/1. */
int convo3f_condition_tree(const uint8_t *conditions, int16_t count, const Convo3fWorld *world,
                           uint8_t *scratch, int *result, const char **why);

/* Case-insensitive 400-byte compare 0x50d550(a, b, 400) == 0 (ASCII A-Z fold,
 * the DAT_0063cb1c == 0 branch). */
int convo3f_text_equal(const uint8_t *a, const uint8_t *b);

void convo3f_manager_reset(Convo3fManager *manager);
/* Native UI preflight: build the exact eligible response list on a private
 * manager copy. No world/object/manager writes or host callbacks. Output is
 * committed only on success; hook builders remain unsupported. */
int convo3f_preview_responses(const Convo3fManager *manager, const Convo3fObject *object,
    const Convo3fWorld *world, Convo3fManager *preview, const char **why);


typedef enum {
    CONVO3F_BLIT_RESTORE = 1,     /* 0x4c5377: saved frame -> back buffer */
    CONVO3F_BLIT_TRANSPARENT = 2, /* 0x4c609b: colour keyed layer */
    CONVO3F_BLIT_OPAQUE = 3       /* 0x4c5770: opaque layer */
} Convo3fBlitKind;

/* One call of the render callback 0x422a0a. RESTORE copies `src` of the saved scene
 * frame [0x5d15e3] to `dst` of the back buffer [0x5cf665]; the other kinds draw
 * `surface` (rectangle `src`) to `dst` with `key`. All rectangles are
 * {left, top, right, bottom} as the original stores them (x at +0, y at +4). */
typedef struct {
    uint8_t kind;
    uint32_t surface;
    int16_t key;
    int32_t src[4];
    int32_t dst[4];
} Convo3fBlit;

typedef struct {
    size_t count;
    Convo3fBlit blits[CONVO3F_CEL_MAX_BLITS];
} Convo3fRenderPlan;

/* The Z entry callback 0x422a0a (entry flag world->ui_5d191d set by 0x4229b5):
 * builds the blit list of the current cache slot and clears the flag. Updates the
 * saved rectangles of the independent layers. Needs host->cel_tree_info. */
int convo3f_cel_render(Convo3fManager *manager, const Convo3fObject *object, Convo3fWorld *world,
                       const Convo3fHost *host, Convo3fRenderPlan *plan, const char **why);

/* Native-only cleanup for a scene replaced while a cel row is in flight: destroys the
 * reader, frees every cached layer and the header block (the original's scene clear
 * runs only the cache reset 0x41de29 and leaves the thread to the process). */
int convo3f_cel_release_all(Convo3fManager *manager, const Convo3fHost *host, const char **why);

/* One pass of the reader thread loop 0x422e4a (without its Sleep): the cache
 * eviction pass 0x41dfd2, then at most one frame load 0x41e0b4 and the advance
 * of the next frame. `ran` reports whether the pass did the load/advance branch.
 * The host calls it while a conversation with a cel reader is active
 * (manager->cel_thread != 0); it does nothing while the lock reads 2. */
int convo3f_cel_reader_iteration(Convo3fManager *manager, const Convo3fHost *host, int *ran,
                                 const char **why);

/* One visit of row `row` of runtime type 0x3f (dispatcher arm 0x427a50 after the
 * dependency gate was true and the row was not completed). `phase` is the row's
 * phase dword at entry. Returns a Convo3fStatus; *why names the first reason on
 * any non-OK status (static string). */
int convo3f_step(Convo3fManager *manager, const Convo3fObject *object, int32_t row,
                 uint32_t phase, Convo3fWorld *world, const Convo3fHost *host,
                 Convo3fStepResult *result, const char **why);

/* Same visit for a given runtime type: 0x3f (sound arm) or 0x3e (cel arm). At
 * phase 1 and 2 `type` must equal the type stored at phase 0 (manager->type). */
int convo3f_step_type(Convo3fManager *manager, const Convo3fObject *object, uint8_t type,
                      int32_t row, uint32_t phase, Convo3fWorld *world, const Convo3fHost *host,
                      Convo3fStepResult *result, const char **why);

#ifdef __cplusplus
}
#endif
#endif
