#ifndef BLACKMOOR_ACTION_FAMILY_28_H
#define BLACKMOOR_ACTION_FAMILY_28_H
#include <stddef.h>
#include <stdint.h>
#ifdef __cplusplus
extern "C" {
#endif
#define ACTION_FAMILY_28_TYPE UINT8_C(0x28)
#define ACTION_FAMILY_28_BODY_BYTES 21u

typedef enum { ACTION_FAMILY28_OK = 0, ACTION_FAMILY28_ERR_ARGUMENT = 1,
    ACTION_FAMILY28_ERR_BODY = 2, ACTION_FAMILY28_ERR_UNSUPPORTED = 3,
    ACTION_FAMILY28_ERR_BOUNDS = 4, ACTION_FAMILY28_ERR_MEMORY = 5,
    ACTION_FAMILY28_ERR_CALLBACK = 6 }
    ActionFamily28Status;
typedef enum {
    ACTION_FAMILY28_X87_CW_DOUBLE = 0x027f,
    ACTION_FAMILY28_X87_CW_EXTENDED = 0x037f
} ActionFamily28X87ControlWord;
typedef struct { int32_t left, top, right, bottom; } ActionFamily28Rect;
typedef struct {
    const uint8_t *data;
    size_t byte_length;
} ActionFamily28Capture;
/* Inputs and observable controller globals for 0x44753b. target_rect is the
 * inclusive effect rectangle from object +0x1d..+0x29, as 0x4477d1 uses
 * right-left+1/bottom-top+1. Captures are full-canvas, tightly packed arrays
 * of 3 little-endian 32-bit channel words per pixel (12 bytes). The 0x446ffb
 * initializer sets object +0x39 to width*height, +0x3d to width, +0x41 to
 * height and +0x45 to width*source-bytes-per-pixel; it allocates +0x31/+0x35
 * as +0x39*12 bytes. 0x447ac7 captures the full canvas using the +0x3d pixel
 * stride. The shared crop origin mirrors body-loaded +0x4e/+0x52 and remains
 * independent of target_rect. A chained nonzero-subrect fixture confirms
 * full-canvas capture spans and the separate crop origin. The controller
 * borrows these immutable spans for the synchronous call. */
typedef struct {
    uint8_t subtype, busy, render_guard, redraw_flag;
    int16_t sequence_budget_ms, pause_ms;
    ActionFamily28Rect target_rect;
    ActionFamily28Capture source_capture, destination_capture;
    size_t capture_width_pixels, capture_height_pixels, capture_stride_pixels;
    size_t capture_offset_x_pixels, capture_offset_y_pixels;
    uint8_t primary_target;
    uint32_t stage, scene_state, finalizer_global_5831c8;
    uint16_t finalizer_global_5831c6;
} ActionFamily28SequenceState;
/* Full synchronous 0x4477d1 frame boundary. It blends the two captures into
 * the target, conditionally presents when primary_target is true, and runs
 * the original unconditional graphics-tail pump before returning. The final
 * frame count is deliberately absent: frame zero is drawn before it is known. */
typedef struct {
    uint32_t frame_index;
    double weight;
    uint16_t x87_control_word;
    ActionFamily28Rect target_rect;
    ActionFamily28Capture source_capture, destination_capture;
    size_t capture_width_pixels, capture_height_pixels, capture_stride_pixels;
    size_t capture_offset_x_pixels, capture_offset_y_pixels;
    uint8_t primary_target;
} ActionFamily28SequenceFrame;
typedef enum {
    ACTION_FAMILY28_SEQUENCE_CALLBACK_NONE = 0,
    ACTION_FAMILY28_SEQUENCE_CALLBACK_TICK = 1,
    ACTION_FAMILY28_SEQUENCE_CALLBACK_BLEND_PRESENT = 2,
    ACTION_FAMILY28_SEQUENCE_CALLBACK_SYSTEM_AUDIO_PUMP = 3
} ActionFamily28SequenceCallbackKind;
/* Callbacks return zero on success; a nonzero return is copied into the
 * failure report and aborts the sequence without synthetic cleanup. */
typedef struct {
    void *context;
    int (*get_tick_count)(void *context, uint32_t *out_tick_count);
    int (*blend_present)(void *context,
                         const ActionFamily28SequenceFrame *frame);
    int (*system_audio_pump)(void *context);
} ActionFamily28SequenceCallbacks;
typedef struct {
    int32_t selected_frame_count; /* original signed local value */
    uint32_t planned_frame_count; /* 0 until the second tick selects the loop */
    uint32_t first_frame_elapsed_ms;
    uint32_t get_tick_calls, blend_present_calls, system_audio_pump_calls;
    uint32_t completed_frame_count, failed_frame_index;
    uint8_t failed_callback, completion_committed;
    int32_t callback_status;
} ActionFamily28SequenceReport;
typedef struct {
    uint8_t effect_type;
    int16_t sequence_budget_ms, pause_ms;
    ActionFamily28Rect rect;
    uint8_t source_bytes[ACTION_FAMILY_28_BODY_BYTES];
} ActionFamily28Decoded;
/* Original CSpecialEffect fields +0x1c, +0x1d..29, +0x2d, +0x49..5d.
 * full_canvas is the four globals at 0x583186..0x583192. */
typedef struct {
    uint8_t busy;
    ActionFamily28Rect full_canvas, current_rect;
    uint32_t sequence_counter;
    uint8_t active_payload[ACTION_FAMILY_28_BODY_BYTES];
} ActionFamily28World;
typedef struct {
    uint8_t type, subtype, eligible, completed_before;
    uint32_t phase_before;
    const uint8_t *body;
    size_t body_length;
} ActionFamily28Input;
typedef struct {
    uint8_t recognized, applied, job_started, completion_valid, completed,
            reset_dependencies;
    uint32_t phase;
    ActionFamily28World world;
} ActionFamily28Result;
/* Decode a bounded loader prefix; consumed=21 excludes dependency tails.
 * Both outputs remain unchanged on failure. */
int action_family28_decode(const uint8_t *, size_t, ActionFamily28Decoded *, size_t *);
/* Dispatcher leaf only. Starting a job queues the original payload, resets
 * sequence_counter and enters action phase 2. Completion on a later phase-2
 * call does not imply the visual sequence has ended. The caller owns actual
 * framebuffer capture, controller scheduling and dependency reset. */
int action_family28_step(const ActionFamily28Input *, const ActionFamily28World *,
                         ActionFamily28Result *);
/* Exact 0x447c36 outer render-gate predicate. `out_should_run` is unchanged
 * on error; a zero result means the controller is not called this tick. */
int action_family28_render_gate(uint8_t busy, uint8_t subtype,
    uint32_t scene_state, uint32_t stage, uint8_t *out_should_run);
/* Number of executed sequence iterations selected after timing the first
 * rendered frame; the mandatory first iteration means this is at least one.
 * The elapsed milliseconds are the wrapped DWORD difference returned by
 * GetTickCount. */
int action_family28_sequence_frame_count(int16_t sequence_budget_ms,
    uint32_t first_frame_elapsed_ms, uint32_t *out_frame_count);
/* Explicit x87 precision variants of the original curve. Intermediate
 * arithmetic is rounded to the selected significand precision in software;
 * native binary64 exp() substitutes for the original x86 CRT helper. The
 * residual curve drift is not isolated to exp(), so bit-exact parity is not
 * promised. */
int action_family28_sequence_weight_for_cw(uint32_t frame_index,
    uint32_t selected_frame_count, uint16_t control_word, double *out_weight);
/* Synchronous native controller. The explicit x87 CW is used for both curve
 * arithmetic and blend callbacks; curve exp() uses native binary64/libm (see
 * above), and remaining curve drift is not attributed solely to exp().
 * Invalid inputs
 * leave state and report unchanged. Callback failures report prior host
 * effects and stop before the original completion/final-state writes. */
int action_family28_run_sequence(ActionFamily28SequenceState *state,
    const ActionFamily28SequenceCallbacks *callbacks,
    uint16_t x87_control_word, ActionFamily28SequenceReport *out_report);
/* Explicit original x87 control-word variants: CW=0x027f uses 53-bit
 * significand precision; CW=0x037f uses 64-bit. Other words are unsupported.
 * Output has 4096 entries indexed a*64+b; failures leave it unchanged. */
int action_family28_blend_table_for_cw(double weight, uint16_t control_word,
    int32_t *table, size_t capacity);
/* Compatibility entrypoint fixed to CW=0x037f. A caller must use the _for_cw
 * entrypoint when the original runtime precision policy is not established. */
int action_family28_blend_table(double weight, int32_t *table, size_t capacity);
/* Bounded packed-word adapter over normalized 0..63 RGB triples. Shift bytes
 * are masked with 31 as in 0x4477d1. Pixel words keep their low 16 bits. */
int action_family28_blend_pixels(const uint8_t *first_rgb, const uint8_t *second_rgb,
    size_t pixels, double weight, const uint8_t shifts[3], uint16_t *output,
    size_t output_capacity);
int action_family28_blend_pixels_for_cw(const uint8_t *first_rgb,
    const uint8_t *second_rgb, size_t pixels, double weight,
    uint16_t control_word, const uint8_t shifts[3], uint16_t *output,
    size_t output_capacity);
/* Bounded 16-bit surface capture equivalent to 0x447ac7's shift/mask step.
 * The requested rectangle is copied as RGB triples with caller-provided
 * channel shifts/masks. Each mask must be <= 63; captured values are raw
 * masked channel values and are not rescaled. Source and output spans must
 * not overlap. */
int action_family28_unpack_rgb16(const uint8_t *surface, size_t surface_length,
    size_t surface_width, size_t surface_height, size_t source_pitch_bytes,
    size_t left, size_t top, size_t width, size_t height,
    const uint8_t shifts[3], const uint8_t masks[3], uint8_t *rgb,
    size_t output_capacity);
#ifdef __cplusplus
}
#endif
#endif
