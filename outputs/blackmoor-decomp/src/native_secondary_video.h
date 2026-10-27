#ifndef BLACKMOOR_NATIVE_SECONDARY_VIDEO_H
#define BLACKMOOR_NATIVE_SECONDARY_VIDEO_H

#include "action_family_33_runtime.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Single session-thread owner for the AVF branch of 0x44c4c1/0x44cde2.
 * The existing A33 kernel alone chooses frames, deadlines, pages and effects.
 * No output device, controller tick or OS worker is created here. */
typedef struct NativeSecondaryVideo NativeSecondaryVideo;

typedef struct NativeSecondaryVideoFrame {
    const uint8_t *pixels; /* raw little-endian RGB555, borrowed */
    size_t bytes;
    uint32_t width, height, pitch;
    uint64_t generation;
    int16_t frame_index;
} NativeSecondaryVideoFrame;

/* All int results use zero for success. The directory is resolved/copied.
 * Each instance has one owner; all methods and borrowed-pixel consumers must
 * finish before another method starts. No callback or background task remains
 * after return. destroy invalidates all handles and pixel borrows. */
int native_secondary_video_create(const char *game_directory, NativeSecondaryVideo **out);
void native_secondary_video_destroy(NativeSecondaryVideo *media);

/* Pure preflight apart from diagnostic text: reads file/header/table metadata,
 * never decodes or changes a live stream, surface or readiness. Resolves AVF
 * explicitly in HDVideo then CDVideo, with unique Windows ASCII-case matching
 * per tier. This bounded family supports kind1/present2/anim1/mode2 and full
 * RGB555 type0 keyframes, as used by the three current secondary-video sets.
 * Bink, overlays, empty/partial/command records and other variants refuse.
 * Names are components, not paths. Frame ranges must fit the actual file. */
int native_secondary_video_validate_set(NativeSecondaryVideo *media, const A33Set *set);

/* Handles media A33 ops2..13 and15 only; app supplies log/tick/event/push.
 * State is borrowed read-only, including the latest kernel clip/frame/page.
 * STREAM_RESET publishes dimensions before the next SURFACE_CREATE: root
 * must call its narrow binding refresh -> load_world after that op succeeds.
 * Thread ops implement suspended/runnable/parked lifetime of explicit passes.
 * FREE retires a slot handle; storage remains until the later STREAM_RESET or
 * destroy, so original FREE-before-surface-release ordering cannot dangle. */
int native_secondary_video_op(NativeSecondaryVideo *media, const A33State *state,
    int opcode, const A33OpArgs *args, int32_t *ret);

/* Writes ONLY ready, delay, slot handles/flags, video rect and w_5b4e02 (the
 * stream open's value1). It never overwrites kernel frame/page/controller or
 * shared world/input fields. Absent stream clears only those owned fields. */
int native_secondary_video_load_world(NativeSecondaryVideo *media, A33State *state);
/* Accept kernel ready acknowledgement. No fabricated ready1 is accepted.
 * A cleared row/active flag or released surface parks explicit polling while
 * retaining stream, reader and decode storage until original next-init work. */
int native_secondary_video_store_world(NativeSecondaryVideo *media, const A33State *state);
/* One original reader iteration, with no sleep. Decode requested frame into
 * hidden slot only, then publish ready1 after decode/release. No frame advance,
 * page flip, deadline or controller effect is performed. */
int native_secondary_video_reader_pass(NativeSecondaryVideo *media, const A33State *state, int *ran);

/* A visible borrow exists only after SURFACE_PIXELS on a live surface. It is
 * valid until the next SURFACE_PIXELS, SURFACE_RELEASE, STREAM_RESET or destroy.
 * Decode of the other slot preserves it; callers must not retain it after a
 * swap because the next reader pass may refill that now-hidden slot. */
int native_secondary_video_frame(NativeSecondaryVideo *media, uint32_t surface,
    NativeSecondaryVideoFrame *frame);
const char *native_secondary_video_failure(const NativeSecondaryVideo *media);

#ifdef __cplusplus
}
#endif
#endif
