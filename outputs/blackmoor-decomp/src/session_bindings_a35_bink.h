#ifndef BLACKMOOR_SESSION_BINDINGS_A35_BINK_H
#define BLACKMOOR_SESSION_BINDINGS_A35_BINK_H

#include "action_family_35_runtime.h"
#include "bink_player.h"
#include "bink_audio.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Native codec/surface adapter for RT-7's original-order controller. One
 * owner at a time, main thread only. No scene flags or phase decisions here.
 * clock is monotonic ns (offline uses the same clock as the mixer).
 * present borrows RGBA until it returns; stop must consume any audio borrow.
 * The single Bink soundtrack uses a separate mixer bus, never a game channel.
 * Unity gain/no pan is a host adaptation; original SDK mixer parity is unknown.
 * Audio starts once on the first decode and free-runs on the mixer clock,
 * including NOT_DUE and unmatched-selector visits; DoFrame does not pump or
 * pause it. This sync rule is UNPROVEN against the original Bink SDK. */
typedef struct SessionA35BinkHost {
    void *context;
    uint64_t (*clock)(void *);
    int (*audio_start)(void *, const BinkAudio *);
    void (*audio_stop)(void *);
    int (*present)(void *, const BinkPlayerFrame *, const A35Rect *, const A35Rect *);
} SessionA35BinkHost;
typedef struct SessionA35Bink SessionA35Bink;
typedef struct SessionA35BinkStats {
    uint64_t decoded, presented, not_due;
    uint64_t origin_ns, clock_ns;
    int64_t pts_ns;
    int32_t frame;
    char rgba_sha256[65];
    char pcm_sha256[65];
    uint64_t audio_frames;
    uint32_t audio_rate, audio_channels;
} SessionA35BinkStats;

/* original_mode is the 0x4bef11 argument: 1 reverse, others forward.
 * Audio in reverse mode is explicitly unsupported: SDK seek audio is unknown.
 * Failure leaves *out NULL and releases all partially allocated resources. */
int session_a35_bink_open(const char *path, int original_mode,
    const SessionA35BinkHost *, SessionA35Bink **out, BinkPlayerInfo *,
    char *error, size_t capacity);
void session_a35_bink_close(SessionA35Bink *);
/* Match A35Host callbacks (0 success, nonzero terminal host failure). due
 * stages the next frame without exposing it. decode starts audio once and
 * exposes the staged frame; rect copies it; next consumes it. A NOT_DUE
 * visit never advances a visible frame or fires an event. */
int session_a35_bink_due(SessionA35Bink *, int *due);
int session_a35_bink_decode(SessionA35Bink *, int16_t *frame);
int session_a35_bink_rect(SessionA35Bink *, const A35Rect *, const A35Rect *);
int session_a35_bink_next(SessionA35Bink *, int *more);
int session_a35_bink_stats(const SessionA35Bink *, SessionA35BinkStats *);
const char *session_a35_bink_failure(const SessionA35Bink *);
#ifdef __cplusplus
}
#endif
#endif
