#ifndef BLACKMOOR_INTERACTIVE_VIDEO_INPUT_H
#define BLACKMOOR_INTERACTIVE_VIDEO_INPUT_H

#include "action_family_1c_runtime.h"
#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

enum InteractiveVideoInputStatus {
    IVI_OK = 0,
    IVI_ERR_ARGUMENT = 1,
    IVI_ERR_BOUNDS = 2,
    IVI_ERR_HOST = 3,
    IVI_ERR_STALE = 4
};
enum InteractiveVideoInputSelection { IVI_NONE = 0, IVI_RECTANGLE = 1, IVI_OUTER = 2 };
enum InteractiveVideoCursorSource { IVI_CURSOR_STANDARD = 0, IVI_CURSOR_HELD_ITEM = 1 };

/* Native retention for original +0x154. The +0x158 flag-pair pointer is
 * resolved from the bounded body at release. No host pointer is stored in
 * either 32-bit C1cObject field; both remain untouched. The retained rectangle
 * may belong to a preceding IV frame record. */
typedef struct {
    uint64_t generation;
    const C1cObject *object;
    const C1cIv *iv;
    const uint8_t *body;
    size_t entry_index;
    size_t rectangle_index;
    uint32_t selection;
} InteractiveVideoInputState;

typedef struct {
    C1cObject *object;
    size_t body_length; /* exactly C1C_BODY_BYTES when the body is read */
    uint64_t generation;
    /* Current player's selected record +0x12/+0x16/+0x1a/+0x1e, in the
     * view-relative comparison space. The handler already translated IV
     * rectangles in place. Do not add the viewport origin again. */
    int32_t player_rectangle[4];
} InteractiveVideoInputView;

typedef struct {
    int16_t held_item; /* 0x583a29; commit after the call, even on a later refusal */
    int32_t cursor_index;
    uint32_t cursor_variant;
    int32_t cursor_source; /* standard 0x5d0377 or held-item 0x571ad3 */
    uint32_t cursor_table_offset; /* (index << 5) + (variant << 4), wrapping u32 */
    uint32_t cursor_enabled;
    int32_t candidate;
    int32_t *event_flags;
    size_t event_flag_count;
} InteractiveVideoInputWorld;

typedef struct {
    void *context;
    /* Original 0x4ea06c(saved item), before the held word is restored. Needed
     * only when current != saved, cursor[0] == 200 and saved != -1.
     * Nonzero reports a host refusal. Must not mutate/free borrowed IV state
     * or recurse into this helper. Cursor drawing is outside this API. */
    int (*restore_held_item)(void *context, int16_t item);
} InteractiveVideoInputHost;

typedef struct {
    uint32_t hit;
    int32_t candidate; /* -1 on miss; world.candidate is preserved on miss */
    int32_t rectangle_index; /* -1 for outer/miss */
    uint32_t flag_written;
    int16_t flag_index; /* -1 unless written */
    int32_t flag_value;
} InteractiveVideoInputResult;

/* Required on scene/IV lifetime replacement, even if allocation addresses are
 * reused. Generation is caller-owned. Ordinary frame-record changes do not
 * invalidate the retained rectangle. Borrowed storage stays alive through
 * release; this module owns/frees none of it. Reset clears only the sidecar. */
void interactive_video_input_reset(InteractiveVideoInputState *state, uint64_t generation);

/* 0x4cb058: clears selection/outer marker, performs held-item prelude, then
 * first inclusive rectangle hit, then optional outer hit. Only hits publish a
 * candidate. Call at original post-ACT cascade position, AFTER overlay miss.
 * Root owns mode/producer/geometry/priority gates and pointer projection.
 * Input coordinates are signed words, as in the original.
 * State/view/world/result storage must be separate. All borrowed arrays must
 * be readable for their declared lengths; this API cannot validate arbitrary
 * host addresses. The existing IV loader establishes those allocation spans.
 * Native safety refusals: malformed borrowed spans/indices, stale lifetimes,
 * absent/failing restore host. A hover refusal invalidates retained selection;
 * earlier successful held-item restoration is not rolled back. */
int interactive_video_input_hover(InteractiveVideoInputState *state,
    const InteractiveVideoInputView *view, InteractiveVideoInputWorld *world,
    const InteractiveVideoInputHost *host, int16_t x, int16_t y,
    InteractiveVideoInputResult *result);

/* 0x4cb3ab: caller invokes on accepted primary release, BEFORE ACT. Original
 * armed/record/body/origin guards remain. Rectangle release uses retained
 * identity; outer release uses the CURRENT record's word_5. No coordinate or
 * candidate re-hit-test, no state consumption: another accepted release may
 * repeat the same flag store. Bounds checks are native limits, not new oracle
 * or raw-storage equality claims. The original debug logger is not modeled. */
int interactive_video_input_release(InteractiveVideoInputState *state,
    const InteractiveVideoInputView *view, InteractiveVideoInputWorld *world,
    InteractiveVideoInputResult *result);

#ifdef __cplusplus
}
#endif
#endif
