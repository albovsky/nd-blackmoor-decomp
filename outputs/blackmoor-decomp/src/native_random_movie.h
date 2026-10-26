#ifndef BLACKMOOR_NATIVE_RANDOM_MOVIE_H
#define BLACKMOOR_NATIVE_RANDOM_MOVIE_H

#include "action_family_2d_runtime.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Silent-Bink media and surface adapter for the recovered raw 0x2d kernel.
 * One owner, on the session thread. The kernel retains all clip selection,
 * weights, delays, entry frame limits, rectangles and gameplay state.
 * FFmpeg decoding and timestamp pacing are native host policy, not original
 * Bink SDK codec, RGB555 or BinkWait timing equivalence. No audio device,
 * worker thread, scene controller or cursor/global state is owned here. */
typedef struct NativeRandomMovie NativeRandomMovie;

typedef struct NativeRandomMovieHost {
    void *context;
    uint64_t (*clock_ns)(void *context);
    uint32_t (*tick_ms)(void *context);
    /* Zero on success. Supply the session's canonical original-CRT RNG. */
    int (*next_random)(void *context, uint32_t *value);
} NativeRandomMovieHost;

typedef struct NativeRandomMovieFrame {
    const uint8_t *rgba;
    size_t rgba_bytes;
    uint32_t width, height, stride;
    uint64_t generation; /* increases on each successful BLIT */
    int32_t current_frame; /* zero based */
} NativeRandomMovieFrame;

/* All int results use zero for success, nonzero for failure. create leaves
 * *out NULL on failure. game_directory is an existing absolute or relative
 * local directory, resolved once without changing the process directory.
 * Required host callbacks are copied; their context must outlive the owner. */
int native_random_movie_create(const char *game_directory,
    const NativeRandomMovieHost *host, NativeRandomMovie **out);
void native_random_movie_destroy(NativeRandomMovie *media);

/* Before phase-0 effects: resolve EVERY entry in original priority order
 * HDVideo BIK, CDVideo BIK, HDVideo AVF, CDVideo AVF, with unique Windows
 * ASCII case matching in each tier. Probe file metadata without decoding all
 * clips. Refuse AVF, soundtracks, invalid frame bounds, differing clip sizes,
 * dimensions above 4096x4096 or container counts outside 1..32768.
 * Apart from failure diagnostics, no live player/surface/callback state is
 * changed. All mode words are accepted: the binding owns their world stores. */
int native_random_movie_validate_set(NativeRandomMovie *media, const D2Set *set);

/* state is read-only, used by STREAM_RESET to select name_159/kind_21a.
 * Op results follow D2Op's original conventions, including BINK_OPEN's zero
 * success and PREPARE's nonzero success. Unsupported AVF/thread ops fail.
 * STREAM_RESET really opens the selected stream synchronously. The engine
 * op host MUST refresh load_stream immediately after STREAM_RESET and BINK_RELEASE so
 * the kernel sees its host-owned metadata in the same call, without a cast. */
int native_random_movie_op(NativeRandomMovie *media, const D2Object *state,
    int op, const D2OpArgs *args, int32_t *ret);

/* Writes ONLY period_24, decoder_172, buffers_182, bink_id_18e, buffer_192,
 * rect_1b2/1b6/1ba/1be and ready_1d4. An absent stream clears those fields.
 * Does not overwrite surface, kernel/controller or shared raw 0x2e fields. */
int native_random_movie_load_stream(NativeRandomMovie *media, D2Object *state);
int native_random_movie_surface_dims(NativeRandomMovie *media, uint32_t surface,
    int16_t *width, int16_t *height);

/* Returns borrowed pixels in the adapter's OWNED COPY of a decoded frame.
 * The borrow survives BINK_RELEASE and idle delays. It expires on the next
 * successful BLIT, SURFACE_RELEASE or destroy; callers must copy if retained
 * longer. A surface with no BLIT yet has no available frame. */
int native_random_movie_frame(NativeRandomMovie *media, uint32_t surface,
    NativeRandomMovieFrame *frame);
const char *native_random_movie_failure(const NativeRandomMovie *media);

#ifdef __cplusplus
}
#endif
#endif
