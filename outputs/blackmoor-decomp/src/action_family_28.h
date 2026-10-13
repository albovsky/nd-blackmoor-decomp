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
#ifdef __cplusplus
}
#endif
#endif
