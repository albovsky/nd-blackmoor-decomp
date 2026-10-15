#include "session_bindings_a35_bink.h"

#include <libavutil/sha.h>
#include <libavutil/mem.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct SessionA35Bink {
    BinkPlayer *player;
    BinkAudio audio;
    SessionA35BinkHost host;
    BinkPlayerFrame frame;
    SessionA35BinkStats stats;
    int staged, decoded, audio_started, failed;
    char failure[320];
};

static int fail(SessionA35Bink *b, int status, const char *detail)
{
    b->failed = 1;
    (void)snprintf(b->failure, sizeof(b->failure), "player_status=%d detail=%s",
                   status, detail);
    if (b->audio_started) {
        b->host.audio_stop(b->host.context);
        b->audio_started = 0;
    }
    return 1;
}

const char *session_a35_bink_failure(const SessionA35Bink *b)
{
    return b == NULL ? "movie provider unavailable" : b->failed ? b->failure : "none";
}

static int digest(const void *bytes, size_t count, char out[65])
{
    struct AVSHA *sha = av_sha_alloc();
    uint8_t sum[32];
    size_t i;
    if (sha == NULL) return 1;
    av_sha_init(sha, 256);
    av_sha_update(sha, bytes, count);
    av_sha_final(sha, sum);
    av_free(sha);
    for (i = 0; i < sizeof(sum); ++i) (void)snprintf(out + i * 2u, 3u, "%02x", sum[i]);
    return 0;
}

void session_a35_bink_close(SessionA35Bink *b)
{
    if (b == NULL) return;
    if (b->audio_started) b->host.audio_stop(b->host.context);
    bink_audio_destroy(&b->audio);
    bink_player_close(b->player);
    free(b);
}

int session_a35_bink_open(const char *path, int mode, const SessionA35BinkHost *host,
    SessionA35Bink **out, BinkPlayerInfo *info, char *error, size_t capacity)
{
    SessionA35Bink *b;
    int status;
    if (out != NULL) *out = NULL;
    if (out == NULL || path == NULL || host == NULL || info == NULL ||
        host->clock == NULL || host->present == NULL) return A35_RUNTIME_ARGUMENT;
    b = calloc(1u, sizeof(*b));
    if (b == NULL) return A35_RUNTIME_HOST;
    b->host = *host;
    status = bink_player_open(path, &b->player, info, error, capacity);
    if (status == BINK_PLAYER_OK && info->total_frames > 32768u) {
        status = BINK_PLAYER_ERR_BOUNDS;
        if (error != NULL && capacity != 0u)
            (void)snprintf(error, capacity, "frame count exceeds signed frame index limit (32768)");
    }
    b->stats.origin_ns = host->clock(host->context);
    if (status == BINK_PLAYER_OK) status = bink_player_set_mode(b->player, mode,
        b->stats.origin_ns, error, capacity);
    if (status != BINK_PLAYER_OK) { session_a35_bink_close(b); return A35_RUNTIME_UNSUPPORTED; }
    status = bink_audio_decode_file(path, &b->audio, error, capacity);
    if (status < 0 || (b->audio.frame_count != 0u &&
        (mode == 1 || host->audio_start == NULL || host->audio_stop == NULL))) {
        if (status >= 0 && error != NULL && capacity != 0u)
            (void)snprintf(error, capacity, "soundtrack needs forward mode and mixer start/stop");
        session_a35_bink_close(b);
        return A35_RUNTIME_UNSUPPORTED;
    }
    b->stats.frame = -1;
    b->stats.audio_frames = b->audio.frame_count;
    b->stats.audio_rate = b->audio.sample_rate;
    b->stats.audio_channels = b->audio.channels;
    if (digest(b->audio.pcm, (size_t)b->audio.frame_count * b->audio.channels * sizeof(float),
               b->stats.pcm_sha256) != 0) { session_a35_bink_close(b); return A35_RUNTIME_HOST; }
    *out = b;
    return A35_RUNTIME_OK;
}

int session_a35_bink_due(SessionA35Bink *b, int *due)
{
    char error[256] = "";
    int status;
    if (b == NULL || due == NULL || b->failed) return 1;
    *due = 0;
    if (b->staged) { *due = 1; return 0; }
    /* 0x4bef85/BinkWait. The combined native player stages a borrowed frame;
     * no pixels/audio/events are committed until the decode callback. */
    b->stats.clock_ns = b->host.clock(b->host.context);
    status = bink_player_advance(b->player, b->stats.clock_ns,
                                 &b->frame, error, sizeof(error));
    if (status == BINK_PLAYER_NOT_DUE) { ++b->stats.not_due; return 0; }
    if (status != BINK_PLAYER_OK) return fail(b, status, error);
    b->staged = 1;
    *due = 1;
    return 0;
}

int session_a35_bink_decode(SessionA35Bink *b, int16_t *frame)
{
    if (b == NULL || frame == NULL || b->failed || !b->staged || b->decoded ||
        b->frame.current_frame < 0 || b->frame.current_frame > INT16_MAX) return 1;
    /* 0x4bf056 DoFrame/CopyToBuffer; the codec soundtrack starts with the
     * first decoded frame. This native extraction is not SDK PCM parity. */
    if (!b->audio_started && b->audio.frame_count != 0u) {
        /* Stop even a partially failed start; host failures never retry. */
        b->audio_started = 1;
        if (b->host.audio_start(b->host.context, &b->audio) != 0)
            return fail(b, A35_RUNTIME_HOST, "soundtrack mixer start failed");
    }
    if (digest(b->frame.rgba, b->frame.rgba_bytes, b->stats.rgba_sha256) != 0) {
        return fail(b, A35_RUNTIME_HOST, "frame digest allocation failed");
    }
    b->stats.pts_ns = b->frame.pts_ns;
    b->decoded = 1;
    ++b->stats.decoded;
    b->stats.frame = b->frame.current_frame;
    *frame = (int16_t)b->frame.current_frame;
    return 0;
}

int session_a35_bink_rect(SessionA35Bink *b, const A35Rect *src, const A35Rect *dst)
{
    int64_t w, h;
    if (b == NULL || src == NULL || dst == NULL || b->failed || !b->decoded) return 1;
    /* 0x4c08d3 stores INCLUSIVE rectangles, render-list copy 0x4c0d3f.
     * No scaling or clipping is silently substituted for an unsupported span. */
    w = (int64_t)src->right - src->left + 1;
    h = (int64_t)src->bottom - src->top + 1;
    if (w <= 0 || h <= 0 || src->left < 0 || src->top < 0 ||
        src->right >= (int64_t)b->frame.width || src->bottom >= (int64_t)b->frame.height ||
        (int64_t)dst->right - dst->left + 1 != w ||
        (int64_t)dst->bottom - dst->top + 1 != h)
        return fail(b, BINK_PLAYER_ERR_BOUNDS, "inclusive source/destination span rejected");
    if (b->host.present(b->host.context, &b->frame, src, dst) != 0)
        return fail(b, A35_RUNTIME_HOST, "viewport presentation failed");
    ++b->stats.presented;
    return 0;
}

int session_a35_bink_next(SessionA35Bink *b, int *more)
{
    if (b == NULL || more == NULL || b->failed || !b->decoded) return 1;
    /* 0x4bf10f checks terminal BEFORE NextFrame/Goto. Last decoded frame is
     * visible this visit, phase 2 executes on the next controller visit. */
    *more = !b->frame.is_terminal;
    /* Multiple matching view records can revisit the terminal SDK frame in
     * this SAME controller pass, even after it stored phase 2. Preserve the
     * borrow until close rather than asking the timed player for EOS. */
    b->staged = !*more;
    b->decoded = 0;
    return 0;
}

int session_a35_bink_stats(const SessionA35Bink *b, SessionA35BinkStats *stats)
{
    if (b == NULL || stats == NULL) return 1;
    *stats = b->stats;
    return 0;
}
