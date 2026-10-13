#ifndef BLACKMOOR_ACTION_FAMILY28_SURFACE_H
#define BLACKMOOR_ACTION_FAMILY28_SURFACE_H

#include "action_family_28.h"
#include "bink_player.h"

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY28_CAPTURE_WORDS_PER_PIXEL 3u
#define ACTION_FAMILY28_CAPTURE_BYTES_PER_PIXEL 12u

typedef enum action_family28_surface_status {
    ACTION_FAMILY28_SURFACE_OK = 0,
    ACTION_FAMILY28_SURFACE_ERR_ARGUMENT = 1,
    ACTION_FAMILY28_SURFACE_ERR_UNSUPPORTED = 2,
    ACTION_FAMILY28_SURFACE_ERR_BOUNDS = 3,
    ACTION_FAMILY28_SURFACE_ERR_MEMORY = 4,
    ACTION_FAMILY28_SURFACE_ERR_CALLBACK = 5
} ActionFamily28SurfaceStatus;

typedef enum action_family28_surface_format {
    ACTION_FAMILY28_SURFACE_RGB565_LE = 1
} ActionFamily28SurfaceFormat;

typedef enum action_family28_surface_scope {
    /* This adapter contains only a decoded Bink background image. It does not
     * represent the original composed DirectDraw framebuffer. */
    ACTION_FAMILY28_SURFACE_DECODED_BACKGROUND_ONLY = 1
} ActionFamily28SurfaceScope;

typedef enum action_family28_storage_lifetime {
    ACTION_FAMILY28_STORAGE_BORROWED = 0,
    ACTION_FAMILY28_STORAGE_CALLER_OWNED = 1
} ActionFamily28StorageLifetime;

typedef struct action_family28_primary_surface {
    uint8_t *pixels;
    size_t byte_length;
    size_t width;
    size_t height;
    size_t pitch_bytes;
    int32_t origin_x;
    int32_t origin_y;
    uint8_t channel_shifts[3];
    uint8_t channel_masks[3];
    ActionFamily28SurfaceFormat format;
    ActionFamily28SurfaceScope scope;
    /* This is the adapter's offscreen primary target, not evidence of the
     * original DirectDraw primary-surface identity. */
    uint8_t primary_target;
    ActionFamily28StorageLifetime storage_lifetime;
} ActionFamily28PrimarySurface;

/* Original A-28 buffers store three 32-bit masked channel words per pixel.
 * `width`/`height` describe the captured surface, `stride_pixels` is the row
 * stride, and offset_x/y locate the inclusive target rectangle in the
 * captured surface. The bytes are little-endian words, matching the pinned
 * PE32 layout without claiming that the portable RGB byte buffers are ABI
 * compatible with it. */
typedef struct action_family28_word_capture {
    uint8_t *bytes;
    size_t byte_length;
    size_t width;
    size_t height;
    size_t stride_pixels;
    size_t offset_x;
    size_t offset_y;
    ActionFamily28StorageLifetime storage_lifetime;
} ActionFamily28WordCapture;

typedef enum action_family28_surface_sequence_operation {
    ACTION_FAMILY28_SURFACE_SEQUENCE_OP_NONE = 0,
    ACTION_FAMILY28_SURFACE_SEQUENCE_OP_TICK = 1,
    ACTION_FAMILY28_SURFACE_SEQUENCE_OP_BLEND = 2,
    ACTION_FAMILY28_SURFACE_SEQUENCE_OP_PRESENT = 3,
    ACTION_FAMILY28_SURFACE_SEQUENCE_OP_GRAPHICS_TAIL_PUMP = 4,
    ACTION_FAMILY28_SURFACE_SEQUENCE_OP_SYSTEM_AUDIO_PUMP = 5,
    ACTION_FAMILY28_SURFACE_SEQUENCE_OP_CONTROLLER = 6
} ActionFamily28SurfaceSequenceOperation;

/* Host boundaries around the synchronous original-order controller. The
 * presentation callback observes the already-updated adapter surface; the
 * graphics-tail callback follows that presentation. No callback owns or
 * replaces the original GetTickCount/frame/audio order. */
typedef struct action_family28_surface_sequence_callbacks {
    void *context;
    int (*get_tick_count)(void *context, uint32_t *out_tick_count);
    int (*present_primary)(void *context,
        const ActionFamily28PrimarySurface *surface, uint32_t frame_index);
    int (*graphics_tail_pump)(void *context, uint32_t frame_index);
    int (*system_audio_pump)(void *context);
} ActionFamily28SurfaceSequenceCallbacks;

typedef struct action_family28_surface_sequence_report {
    ActionFamily28SequenceReport controller;
    uint32_t blend_attempts, blend_successes;
    uint32_t present_attempts, present_successes;
    uint32_t graphics_tail_pump_attempts, graphics_tail_pump_successes;
    uint32_t system_audio_pump_attempts, system_audio_pump_successes;
    ActionFamily28SurfaceSequenceOperation failed_operation;
    int32_t callback_status;
    int32_t controller_status;
} ActionFamily28SurfaceSequenceReport;

/* Convert a rectangular crop from a borrowed RGBA frame into caller-owned
 * tightly packed little-endian RGB565 storage. `source_x/source_y` are in the
 * decoded frame; origin_x/origin_y locate the crop in the adapter surface.
 * Each channel is truncated to the declared 5/6/5 bit width and alpha is
 * ignored. This is a named native adapter conversion, not original
 * decoder/display-format equivalence. Pixel bytes and output metadata are
 * committed only after all source/output spans validate. */
int action_family28_surface_from_rgba_rect(const BinkPlayerFrame *frame,
                                      size_t source_x,
                                      size_t source_y,
                                      size_t width,
                                      size_t height,
                                      uint8_t *rgb565,
                                      size_t output_capacity,
                                      int32_t origin_x,
                                      int32_t origin_y,
                                      ActionFamily28PrimarySurface *out_surface);
/* Full-frame wrapper around action_family28_surface_from_rgba_rect. */
int action_family28_surface_from_rgba(const BinkPlayerFrame *frame,
                                      uint8_t *rgb565,
                                      size_t output_capacity,
                                      int32_t origin_x,
                                      int32_t origin_y,
                                      ActionFamily28PrimarySurface *out_surface);

/* Return the minimum original-layout capture allocation size. */
int action_family28_capture_required_bytes(size_t width,
                                          size_t height,
                                          size_t stride_pixels,
                                          size_t *out_bytes);

/* Capture the entire decoded-background surface into a bounded original-layout
 * RGB-word buffer. The target rectangle is inclusive destination-surface
 * coordinates. The source offset in the resulting capture is independent and
 * supplied from the effect object's original +0x4e/+0x52 fields. */
int action_family28_surface_capture_words_at(
    const ActionFamily28PrimarySurface *surface,
    const ActionFamily28Rect *target_rect,
    size_t capture_offset_x,
    size_t capture_offset_y,
    ActionFamily28WordCapture *capture);
/* Compatibility convenience: use the target rectangle's top-left as source
 * crop origin. Call *_at when the original crop offsets differ. */
int action_family28_surface_capture_words(
    const ActionFamily28PrimarySurface *surface,
    const ActionFamily28Rect *target_rect,
    ActionFamily28WordCapture *capture);

/* Blend the two original-layout capture spans using the portable A-28 math,
 * then update the inclusive rectangle in the declared offscreen primary
 * surface. All input bounds and RGB values validate before any surface write.
 * The original loop uses a shared capture crop index; differing source and
 * target offset_x/offset_y values are explicitly unsupported.
 * A non-primary target or unsupported composition scope fails explicitly. */
int action_family28_surface_blend_present_words(
    ActionFamily28PrimarySurface *surface,
    const ActionFamily28Rect *target_rect,
    const ActionFamily28WordCapture *source,
    const ActionFamily28WordCapture *target,
    double weight,
    uint16_t x87_control_word,
    uint8_t present_primary);

/* Run the decoded-background adapter through the original synchronous A-28
 * controller order. The primary surface must be a caller-owned, tightly
 * packed full-canvas RGB565 adapter; captures must be caller-owned full-canvas
 * 12-byte-per-pixel spans. `state` supplies the independent source crop and
 * inclusive destination rectangle. The startup-derived x87 word must be
 * passed explicitly. On callback failure the surface and host may contain
 * earlier frame/presentation effects; the report preserves them and this
 * function performs no rollback or retry. */
int action_family28_surface_run_sequence(
    ActionFamily28PrimarySurface *surface,
    ActionFamily28SequenceState *state,
    const ActionFamily28SurfaceSequenceCallbacks *callbacks,
    uint16_t x87_control_word,
    ActionFamily28SurfaceSequenceReport *out_report);

const char *action_family28_surface_status_string(int status);

#ifdef __cplusplus
}
#endif

#endif
