#ifndef BLACKMOOR_CAPTION_LIFECYCLE_H
#define BLACKMOOR_CAPTION_LIFECYCLE_H

/* Caption and framed text-box lifecycle (S05-2).
 *
 * The framed text box is a CScrollTextBox (CUIPopup subclass) at 0x61f864,
 * configured by the BOOT SCTB chunk and driven by:
 *   boot            0x426063 BootGameEngine -> 0x4de227 init, 0x4de4f9 poll
 *   open / close    0x4de24f / 0x4de2d8 (A-51 0x4282df / 0x428406)
 *   per-frame poll  0x43cfb2 -> 0x4de4f9 (only when no overlay UI is active)
 *   cursor hover    0x4d30ee -> 0x4de322, click 0x43b223 -> 0x4de413
 *   draw            0x4cfbca -> 0x4de584 (inside RenderMainDisplay 0x4cf9f4)
 * Captions are presented by render-list layer 10 (keyed blit of the caption
 * surface) and cleared through layer 11 (CUITaskBar::RestoreCCTextBox) by the
 * main-loop flag block 0x43d0b4..0x43d125 and the two-frame clear 0x42ae0a.
 * The framed surface is shared with the conversation UI, whose request
 * 0x5b15c8 runs the framed two-frame clear 0x42ad27 (render layer 9).
 *
 * Objects are kept as byte images with the original layout so every field
 * offset below is the original one. Process globals that the S05-1 writer
 * also uses live in CaptionGlobals (caption_layout.h); this module never
 * keeps a second copy of them.
 */

#include <stddef.h>
#include <stdint.h>

#include "caption_layout.h"

#ifdef __cplusplus
extern "C" {
#endif

#define CTB_OBJECT_BYTES 0x995u
#define CTB_SCTB_BYTES 0x300u

/* CUIPopup / CScrollTextBox fields (offsets into the 0x995-byte object). */
#define CTB_HOT_X 0x04u              /* cursor hot point (0x4ee2a9) */
#define CTB_HOT_Y 0x08u
#define CTB_CURSOR_RECT 0x0cu        /* left, top, right, bottom */
#define CTB_NORMAL_DST 0x1cu         /* resolved normal destination rect */
#define CTB_CONFIG 0x2cu             /* 752-byte copy of SCTB */
#define CTB_IMAGE_NAME 0x2cu
#define CTB_SCENE 0x51u              /* int16; 9999 = no scene change */
#define CTB_NORMAL_SRC 0x53u
#define CTB_MAX_SRC 0x63u
#define CTB_NORMAL_DST_RAW 0x73u
#define CTB_MAX_DST_RAW 0x83u
#define CTB_RELATIVE 0x93u           /* rects relative to VIEW origin */
#define CTB_SOUND0 0x9bu             /* four 49-byte sound descriptors */
#define CTB_SOUND_STRIDE 0x31u
#define CTB_SOUND0_CHANNEL 0xbcu     /* int16 */
#define CTB_HAS_BUTTON 0x15fu
#define CTB_BUTTON_CONFIG 0x163u
#define CTB_HAS_SLIDER 0x252u
#define CTB_SLIDER_CONFIG 0x256u
#define CTB_BUTTON 0x31cu            /* CUIButton */
#define CTB_POPUP_IMAGE 0x4abu       /* sheet handle */
#define CTB_STATE 0x4afu             /* 0 load, 4 wait, 5 apply, 2 normal, 3 max */
#define CTB_REQUESTED 0x4b3u
#define CTB_SLIDER 0x4b7u            /* CUISlider */
#define CTB_MAX_DST 0x665u
#define CTB_SOUND_LOADED 0x675u      /* four int32 flags */
#define CTB_PRESSED 0x685u
#define CTB_RESTORE_CURSOR 0x689u    /* x, y */
#define CTB_SCTB 0x691u              /* raw SCTB (0x300 bytes) */
#define CTB_MODE 0x991u              /* UI mode written by open/close */

/* CUISlider fields (offsets from CTB_SLIDER). */
#define SLD_LOADED 0x04u
#define SLD_IMAGE 0x08u
#define SLD_BACKGROUND 0x0cu
#define SLD_VISUAL 0x10u             /* 0 normal, 1 hover, 2 drag, 4 hidden */
#define SLD_TRANSPARENT 0x14u
#define SLD_CONFIG 0x18u             /* 0xc6 bytes */
#define SLD_ID 0x5au
#define SLD_SRC_RECTS 0x5eu
#define SLD_BG_SRC 0x9eu
#define SLD_TRACK_RAW 0xaeu
#define SLD_RELATIVE 0xbeu
#define SLD_HOVER_STATE 0xc2u
#define SLD_DRAG_STATE 0xc6u
#define SLD_CURSOR_CHANGE 0xcau
#define SLD_ORIENTATION 0xceu        /* 0 horizontal, 1 vertical */
#define SLD_DIRECTION 0xd2u
#define SLD_INIT_TRANSPARENT 0xd6u
#define SLD_INIT_VISUAL 0xdau
#define SLD_DRAW_SRC 0xdeu           /* four resolved 16-byte rects */
#define SLD_TRACK 0x12eu
#define SLD_THUMB 0x13eu
#define SLD_DRAG_THUMB 0x14eu
#define SLD_RANGE 0x15eu
#define SLD_POSITION 0x162u          /* 0..100 */
#define SLD_OFFSET 0x166u
#define SLD_FRACTION 0x16au          /* float */
#define SLD_DRAGGING 0x16eu
#define SLD_TRACK_W 0x172u
#define SLD_TRACK_H 0x176u
#define SLD_THUMB_W 0x17au
#define SLD_THUMB_H 0x17eu
#define SLD_PRESS_X 0x182u
#define SLD_PRESS_Y 0x186u
#define SLD_CURSOR_X 0x18au
#define SLD_CURSOR_Y 0x18eu
#define SLD_DELTA_X 0x192u
#define SLD_DELTA_Y 0x196u
#define SLD_HOVER 0x19au
#define SLD_DIRTY 0x19eu
#define SLD_SHARED_ART 0x1a2u
#define SLD_FILLS_H 0x1a6u
#define SLD_FILLS_W 0x1aau

typedef enum caption_lifecycle_status {
    CAPTION_LIFECYCLE_OK = 0,
    CAPTION_LIFECYCLE_ERR_ARGUMENT = 1,
    CAPTION_LIFECYCLE_ERR_FORMAT = 2,
    /* A branch that is unreachable with shipped data and not ported
     * (CUIButton: SCTB has_button is 0). */
    CAPTION_LIFECYCLE_ERR_UNSUPPORTED = 3,
    /* The original reports and quits (0x4c97b4); state written before the
     * failing call is kept, in source order. */
    CAPTION_LIFECYCLE_ERR_FATAL = 4,
    CAPTION_LIFECYCLE_ERR_BACKEND = 5
} CaptionLifecycleStatus;

typedef struct caption_rect {
    int32_t left, top, right, bottom;
} CaptionRect;

/* Process globals owned by this lifecycle (not shared with S05-1). */
typedef struct caption_lifecycle_globals {
    int32_t framed_layer_enabled;   /* 0x5d17f5 (render layer 8) */
    int32_t caption_layer_enabled;  /* 0x5d1889 (render layer 10) */
    int32_t caption_restore_layer;  /* 0x5d18d3 (render layer 11) */
    int16_t caption_clear_counter;  /* 0x5b160a */
    int16_t first_render_level;     /* 0x5bb1c4 */
    int32_t popup_gate;             /* 0x55cd94 */
    int32_t popup_aux;              /* 0x63aa10 */
    int32_t modal_input;            /* 0x5839a9 */
    int32_t overlay_ui;             /* 0x583204 */
    int32_t framed_clear_request;   /* 0x5b15c8 (set by convo 0x420c17) */
    int16_t framed_clear_counter;   /* 0x5b15d4 */
    int32_t convo_restore_layer;    /* 0x5d183f (render layer 9) */
    float scroll_fraction;          /* 0x5b0a78 */
    CaptionRect scroll_src;         /* 0x5b0a7e (render layer 8 source) */
    int32_t taskbar_mode;           /* 0x570508 + 0xf2a */
    int32_t scene_request;          /* 0x5bb57b */
    int32_t scene_request_flag;     /* 0x5c39ff */
    int32_t engine_state;           /* 0x583999 */
    /* Input object 0x5830a6 and its globals. */
    int32_t mouse_vk[2];            /* 0x5830c6 / 0x5830ca */
    int32_t input_cursor[2];        /* 0x5830be / 0x5830c2 */
    uint8_t mouse_down[2];          /* 0x58321d / 0x58321e */
    /* Cursor layer (render layer 2) state used by the hover path. */
    CaptionRect cursor_rect;        /* 0x583102: cursor layer destination */
    int32_t cursor_type;            /* 0x5b44f0 */
    int32_t cursor_variant;         /* 0x5b44f4 */
    int32_t cursor_override;        /* 0x5c39e9 */
    int32_t held_item;              /* 0x583a29 (-1: none) */
    int32_t cursor_alt;             /* 0x5b44f8 */
    uint32_t cursor_surface;        /* 0x5d162d */
    uint32_t default_cursor_surface;/* 0x5d0377 */
    uint32_t item_cursor_surface;   /* 0x571ad3 */
    int32_t cursor_src_index;       /* 0x5d1631, as (address-0x5b160c)/4 */
    int32_t cursor_layer_enabled;   /* 0x5d1639 */
    int32_t cursor_hot[2];          /* 0x5c3a5b / 0x5c3a5f */
    int32_t slider_cursor_scene;    /* 0x5c39e5 */
    /* Timed caption dismiss on object 0x571442. */
    int32_t timed_armed;            /* 0x571442 + 0x8256 */
    uint32_t timed_deadline;        /* 0x571442 + 0x8286 */
    uint32_t game_clock;            /* 0x585d37 */
} CaptionLifecycleGlobals;

/* CUITaskBar 0x570508 fields used by caption presentation. */
typedef struct caption_taskbar {
    uint32_t saved_surface;         /* +0x74f */
    CaptionRect area_src;           /* +0x25 */
    CaptionRect area_dst;           /* +0x35 */
    CaptionRect cc_rect;            /* +0x55 */
} CaptionTaskbar;

typedef enum caption_blit_kind {
    CAPTION_BLIT_OPAQUE = 1,        /* 0x4c5377 DFBltNoTrans */
    CAPTION_BLIT_KEYED = 2          /* 0x4c5d4b DFBltSrcTrans */
} CaptionBlitKind;

typedef struct caption_blit {
    CaptionBlitKind kind;
    uint32_t surface;               /* source handle; destination is the back buffer */
    CaptionRect src;
    CaptionRect dst;
    const char *label;              /* original debug label */
} CaptionBlit;

/* Cursor geometry from the CURS tables (0x5b30cc hot point, 0x5b3e40
 * offset, 0x5b3ae8 size) for one (type, variant). */
typedef struct caption_cursor_geometry {
    int32_t hot_dx, hot_dy;
    int32_t rect_dx, rect_dy;
    int16_t width, height;
} CaptionCursorGeometry;

typedef enum caption_lifecycle_backend_status {
    CAPTION_LIFECYCLE_BACKEND_OK = 0,
    CAPTION_LIFECYCLE_BACKEND_ERROR = 1
} CaptionLifecycleBackendStatus;

typedef struct caption_lifecycle_backend {
    void *context;
    /* 0x4c2790: returns a nonzero handle, 0 on failure (original fatal). */
    uint32_t (*load_image)(void *context, const char *name, const char *purpose);
    /* 0x4fb77a / 0x4fba69 with a 49-byte sound descriptor; 0x4fb2e3 play. */
    CaptionLifecycleBackendStatus (*load_sound)(void *context, const uint8_t *descriptor);
    void (*unload_sound)(void *context, const uint8_t *descriptor);
    CaptionLifecycleBackendStatus (*play_sound)(void *context, int16_t channel);
    /* GetAsyncKeyState(vk) high bit, GetCursorPos. */
    int (*key_down)(void *context, int32_t vk);
    void (*cursor_pos)(void *context, int32_t *x, int32_t *y);
    CaptionLifecycleBackendStatus (*cursor_geometry)(void *context, int32_t type,
                                                     int32_t variant,
                                                     CaptionCursorGeometry *geometry);
    /* 0x4c5377 / 0x4c5d4b to the back buffer 0x5cf665. */
    CaptionLifecycleBackendStatus (*blit)(void *context, const CaptionBlit *blit);
    /* 0x448d11(*0x5d03af, text, -2, 0): the S05-1 writer. */
    CaptionLifecycleBackendStatus (*write_framed_text)(void *context, uint8_t *text,
                                                       size_t capacity);
    /* Layer 9 callback 0x4d3705 -> 0x4e79ca CUIConvo::RestoreTextBox
     * (conversation-owned; required only while convo_restore_layer). */
    CaptionLifecycleBackendStatus (*convo_restore)(void *context);
    /* Report + quit paths (0x4264e8/0x42639d, 0x4c97b4). */
    void (*fatal)(void *context, const char *message);
} CaptionLifecycleBackend;

typedef struct caption_lifecycle {
    uint8_t box[CTB_OBJECT_BYTES];  /* object 0x61f864 */
    CaptionLifecycleGlobals g;
    CaptionGlobals *shared;         /* 0x5b1602 0x5b1606 0x5b15d6 0x5b0a7c 0x5a161f */
    const CaptionGeometry *geometry;/* TBOX at 0x5b0a12 */
    int32_t view_origin[2];         /* VIEW 0x583186 / 0x58318a */
    CaptionTaskbar taskbar;
} CaptionLifecycle;

/* 0x4de394 CScrollTextBox::LoadChunk: copy SCTB (needs >= 0x300 bytes). */
int caption_ctb_load_chunk(CaptionLifecycle *life, const CaptionLifecycleBackend *backend,
                           const uint8_t *sctb, size_t length);
/* 0x4de227: 0x4edcb1(+0x691, 1) then 0x4ee6c7(0). */
int caption_ctb_init(CaptionLifecycle *life, const CaptionLifecycleBackend *backend);
/* 0x4de24f(mode, text). The text is the caller's mutable C string. */
int caption_ctb_open(CaptionLifecycle *life, const CaptionLifecycleBackend *backend,
                     int32_t mode, uint8_t *text, size_t capacity);
/* 0x4de2d8. */
int caption_ctb_close(CaptionLifecycle *life, const CaptionLifecycleBackend *backend);
/* 0x4de4f9: 0x4ee6c7(0) in modes 2..3, close on 0, then 0x4de440. */
int caption_ctb_poll(CaptionLifecycle *life, const CaptionLifecycleBackend *backend);
/* 0x4de322 (hover; reads modal_input and cursor_pos). */
int caption_ctb_hover(CaptionLifecycle *life, const CaptionLifecycleBackend *backend);
/* 0x4de413 (click). */
int caption_ctb_click(CaptionLifecycle *life, const CaptionLifecycleBackend *backend);
/* 0x4de584 (draw; emits blits). */
int caption_ctb_draw(CaptionLifecycle *life, const CaptionLifecycleBackend *backend);

/* Main-loop caption block 0x43d0b4..0x43d125 (also calls 0x42ae0a and
 * 0x4ea361); 0x42ae0a / 0x42ad90 two-frame clear; 0x4ea361 timed dismiss;
 * arming as at 0x4e93ae..0x4e93cf (deadline = clock + delay). */
int caption_main_loop_flags(CaptionLifecycle *life);
/* 0x42ad27: framed two-frame clear requested by the conversation UI. */
void caption_framed_clear_step(CaptionLifecycle *life);
/* InitStaticSceneData 0x4381f4 caption/frame writes 0x438da2..0x438f4d:
 * closes the frame box (0x4de2d8) and resets clear state, scroll source and
 * caption flags. */
int caption_scene_reset(CaptionLifecycle *life, const CaptionLifecycleBackend *backend);
void caption_clear_step(CaptionLifecycle *life);
/* 0x42ad90: like 0x42ae0a, and on its final frame marks `slot` done. */
int caption_clear_slot_step(CaptionLifecycle *life, int16_t slot, int *slot_done);
void caption_timed_dismiss(CaptionLifecycle *life);
void caption_timed_arm(CaptionLifecycle *life, int16_t delay);

/* RenderMainDisplay 0x4cf9f4 view of the caption-related layers in its
 * original order: z 0x11 layer 9 (convo restore callback) and layer 11
 * (0x4e1157 restore callback), then z 0x12 layer 8 (framed text, opaque)
 * and layer 10 (caption, keyed); each only when enabled. */
int caption_present_layers(CaptionLifecycle *life, const CaptionLifecycleBackend *backend,
                           uint32_t caption_surface, uint32_t framed_surface,
                           const CaptionRect *framed_dst);
/* 0x4e1157 / 0x4e1113 taskbar restores. */
int caption_taskbar_restore_cc(CaptionLifecycle *life, const CaptionLifecycleBackend *backend);
int caption_taskbar_restore_area(CaptionLifecycle *life,
                                 const CaptionLifecycleBackend *backend);

const char *caption_lifecycle_status_string(int status);

#ifdef __cplusplus
}
#endif

#endif
