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
    ACTION_FAMILY28_ERR_BOUNDS = 4, ACTION_FAMILY28_ERR_MEMORY = 5 }
    ActionFamily28Status;
typedef enum {
    ACTION_FAMILY28_X87_CW_DOUBLE = 0x027f,
    ACTION_FAMILY28_X87_CW_EXTENDED = 0x037f
} ActionFamily28X87ControlWord;
typedef struct { int32_t left, top, right, bottom; } ActionFamily28Rect;
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
