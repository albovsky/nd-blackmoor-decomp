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
 *             the cel-video arms, which this module does not implement.
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

/* The conversation manager 0x6177e8, only the fields modelled here. Fields of
 * the cel-video arms (0x39/0x3b/0x3e) are NOT modelled. */
typedef struct {
    int16_t row;            /* +0x75b, -1 none */
    uint8_t type;           /* +0x75a runtime type of the row in progress */
    uint32_t sub_state;     /* +0x6b6: 4 running, 5 stop first sound, 6 response sound */
    int16_t response_count; /* +0xf21 */
    int16_t textbox_slot[2];/* +0xf73 normal, +0xf75 hilite; -1 none */
    int32_t cel_thread;     /* +0x6b2: nonzero only after a cel-video row (unsupported) */
    uint8_t display_name[CONVO3F_NAME_BYTES]; /* +0x75d, '_' shown as ' ' */
    Convo3fResponse responses[CONVO3F_MAX_RESPONSES];
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

/* One visit of row `row` of runtime type 0x3f (dispatcher arm 0x427a50 after the
 * dependency gate was true and the row was not completed). `phase` is the row's
 * phase dword at entry. Returns a Convo3fStatus; *why names the first reason on
 * any non-OK status (static string). */
int convo3f_step(Convo3fManager *manager, const Convo3fObject *object, int32_t row,
                 uint32_t phase, Convo3fWorld *world, const Convo3fHost *host,
                 Convo3fStepResult *result, const char **why);

#ifdef __cplusplus
}
#endif
#endif
