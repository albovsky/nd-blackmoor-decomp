/* Bink video API (BINKW32 exports) over the platform's movie decoder. The original decoder is a binary x86 DLL, so the platform decodes the
 * file (the macOS app through FFmpeg, the headless harness through the ffmpeg tool) and the shim serves RGB565 frames. The BINK structure
 * the game reads (width, height, frame counts, rates) is kept in guest memory. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "rc.h"
#include "rc_internal.h"

#define API(name) static int api_##name(Fl41Regs *r, const uint32_t *a, uint32_t *ret)
#define UNUSED (void)r; (void)a; (void)ret
#define RET(v) do { *ret = (uint32_t)(v); return 0; } while (0)

typedef struct Movie {
    uint32_t guest, w, h, frames, rate, div;
    void *handle;
    int voice;                    /* the soundtrack's voice in the mixer, or -1 */
    uint32_t shown_at;            /* clock when the current frame was handed out */
    int started;
    uint32_t start_clock;
} Movie;

static Movie *movies[64];
static const char *bink_error = "ok";
static uint32_t bink_error_ptr;


static Movie *movie_of(uint32_t p)
{
    for (int i = 0; i < 64; i++) if (movies[i] && movies[i]->guest == p) return movies[i];
    return NULL;
}

/* the soundtrack starts with the first frame and follows a seek */
static void start_sound(Movie *m, uint32_t frame0)
{
    const float *pcm;
    uint64_t frames;
    uint32_t channels, rate;
    rc_voice_stop(m->voice);
    m->voice = -1;
    if (!rc_plat.bink_audio || rc_plat.bink_audio(rc_plat.user, m->handle, &pcm, &frames, &channels, &rate) != 0) return;
    uint64_t at = m->rate ? (uint64_t)frame0 * 1000u * m->div / m->rate * rate / 1000u : 0;
    m->voice = rc_voice_start(pcm, frames, channels, rate, at);
}

API(BinkDDSurfaceType) { UNUSED; RET(10); }                         /* BINKSURFACE565 */
API(BinkOpen)
{
    (void)r;
    char win[1024], host[1536];
    rc_cstr(a[0], win, sizeof win);
    rc_fs_log("bink", win);
    if (!rc_plat.bink_open || !rc_fs_resolve(win, 1, host, sizeof host)) { bink_error = "file not found"; RET(0); }
    RcBinkInfo info;
    void *handle = NULL;
    if (rc_plat.bink_open(rc_plat.user, host, &info, &handle) != 0) { bink_error = "not a Bink file"; RET(0); }
    int slot = -1;
    for (int i = 0; i < 64; i++) if (!movies[i]) { slot = i; break; }
    if (slot < 0) { rc_plat.bink_close(rc_plat.user, handle); bink_error = "too many open movies"; RET(0); }
    Movie *m = (Movie *)calloc(1, sizeof *m);
    m->guest = rc_alloc(0x400);
    m->voice = -1;
    m->w = info.width; m->h = info.height; m->frames = info.frames ? info.frames : 1; m->handle = handle;
    m->rate = info.rate * 1000u / (info.rate_div ? info.rate_div : 1u); m->div = 1000;
    rc_zero(m->guest, 0x400);
    rc_w32(m->guest, m->w); rc_w32(m->guest + 4, m->h); rc_w32(m->guest + 8, m->frames); rc_w32(m->guest + 12, 1);
    rc_w32(m->guest + 16, 0); rc_w32(m->guest + 20, m->rate); rc_w32(m->guest + 24, m->div); rc_w32(m->guest + 32, a[1]);
    movies[slot] = m;
    rc_log("  BinkOpen %s -> %ux%u, %u frames", win, m->w, m->h, m->frames);
    bink_error = "ok";
    RET(m->guest);
}
API(BinkGetError)
{
    UNUSED;
    if (!bink_error_ptr) bink_error_ptr = rc_alloc(64);
    rc_put_cstr(bink_error_ptr, bink_error);
    RET(bink_error_ptr);
}
API(BinkClose)
{
    (void)r;
    for (int i = 0; i < 64; i++)
        if (movies[i] && movies[i]->guest == a[0]) {
            rc_voice_stop(movies[i]->voice);
            if (rc_plat.bink_close) rc_plat.bink_close(rc_plat.user, movies[i]->handle);
            free(movies[i]);
            movies[i] = NULL;
        }
    RET(0);
}
API(BinkDoFrame)
{
    (void)r;
    Movie *m = movie_of(a[0]);
    rc_w32(a[0] + 16, rc_u32(a[0] + 12));
    if (m && !m->started) {
        m->started = 1; m->start_clock = rc_clock();
        start_sound(m, 0);
    }
    RET(0);
}
API(BinkNextFrame)
{
    (void)r;
    uint32_t n = rc_u32(a[0] + 12) + 1u;
    rc_w32(a[0] + 12, n <= rc_u32(a[0] + 8) ? n : 1u);
    RET(0);
}
/* The movie is due its next frame when the clock has passed the frame's slot; the virtual clock never waits. */
API(BinkWait)
{
    (void)r;
    Movie *m = movie_of(a[0]);
    if (!m || rc_clock_is_virtual() || !m->started) RET(0);
    uint32_t fn = rc_u32(a[0] + 12);
    uint64_t due = (uint64_t)(fn - 1u) * 1000u * m->div / (m->rate ? m->rate : 1000u);
    RET((rc_clock() - m->start_clock) < due ? 1 : 0);
}
API(BinkGoto)
{
    (void)r;
    uint32_t n = rc_u32(a[0] + 8), f = a[1] < n ? a[1] : n;
    rc_w32(a[0] + 12, f < 1 ? 1 : f);
    Movie *m = movie_of(a[0]);
    if (m) {
        m->start_clock = rc_clock() - (uint32_t)((uint64_t)(f < 1 ? 0 : f - 1) * 1000u * m->div / (m->rate ? m->rate : 1000u));
        if (m->started) start_sound(m, f < 1 ? 0 : f - 1);
    }
    RET(0);
}
API(BinkCopyToBuffer)
{
    (void)r;
    Movie *m = movie_of(a[0]);
    if (!m || !rc_plat.bink_frame) RET(0);
    uint32_t last = rc_u32(a[0] + 16);
    uint32_t frame = last ? last : 1u;
    if (frame > m->frames) frame = m->frames;
    uint16_t *img = (uint16_t *)malloc((size_t)m->w * m->h * 2u);
    if (!img) RET(0);
    if (rc_plat.bink_frame(rc_plat.user, m->handle, frame, img, m->w) == 0) {
        int32_t x = (int32_t)a[4], y = (int32_t)a[5];
        for (uint32_t j = 0; j < m->h; j++) {
            int32_t ty = y + (int32_t)j;
            if (ty < 0 || ty >= (int32_t)a[3]) continue;
            rc_write(a[1] + (uint32_t)ty * a[2] + (uint32_t)x * 2u, img + (size_t)j * m->w, (size_t)m->w * 2u);
        }
    }
    free(img);
    RET(0);
}
API(BinkGetSummary)
{
    (void)r;
    rc_zero(a[1], 0x100);
    uint32_t w = rc_u32(a[0]), h = rc_u32(a[0] + 4), n = rc_u32(a[0] + 8), rate = rc_u32(a[0] + 20), div = rc_u32(a[0] + 24);
    uint32_t v[10] = {w, h, (uint32_t)((uint64_t)n * 1000u * div / (rate ? rate : 1u)), rate, div, rate, div, 0, n, 0};
    rc_write(a[1], v, sizeof v);
    RET(0);
}
API(BinkGetRealtime) { (void)r; rc_zero(a[1], 0x40); RET(0); }
API(One) { UNUSED; RET(1); }

typedef struct BinkName { const char *name; RcApiFn fn; } BinkName;
static const BinkName names[] = {
    {"_BinkDDSurfaceType@4", api_BinkDDSurfaceType}, {"_BinkOpen@8", api_BinkOpen}, {"_BinkGetError@0", api_BinkGetError}, {"_BinkClose@4", api_BinkClose},
    {"_BinkDoFrame@4", api_BinkDoFrame}, {"_BinkNextFrame@4", api_BinkNextFrame}, {"_BinkWait@4", api_BinkWait}, {"_BinkGoto@12", api_BinkGoto},
    {"_BinkCopyToBuffer@28", api_BinkCopyToBuffer}, {"_BinkGetSummary@8", api_BinkGetSummary}, {"_BinkGetRealtime@12", api_BinkGetRealtime},
    {"_BinkOpenDirectSound@4", api_One}, {"_BinkSetSoundSystem@8", api_One},
};

int rc_bink_resolve(const char *name, RcApiFn *fn)
{
    for (size_t i = 0; i < sizeof names / sizeof names[0]; i++)
        if (!strcmp(names[i].name, name)) { *fn = names[i].fn; return 1; }
    return 0;
}

void rc_bink_init(void) {}
