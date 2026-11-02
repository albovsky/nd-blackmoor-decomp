/* Catches a missing/wrong-quantum consumer, work-relative pacing drift,
 * unbounded catch-up, or a stop that leaves its render callback running.
 * Synthetic signed stereo only; no guest, audio backend or device. */
#define _POSIX_C_SOURCE 200809L
#include <errno.h>
#include <pthread.h>
#include <stdatomic.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

#ifndef RC_HEADLESS_AUDIO_SOURCE
#define RC_HEADLESS_AUDIO_SOURCE "../recomp/rc_headless_audio.c"
#endif
#include RC_HEADLESS_AUDIO_SOURCE

static int failures;
#define CHECK(c) do { if (!(c)) { \
    fprintf(stderr, "CHECK failed at line %d: %s\n", __LINE__, #c); failures++; \
} } while (0)

static pthread_mutex_t observed_lock = PTHREAD_MUTEX_INITIALIZER;
static pthread_cond_t observed_cond = PTHREAD_COND_INITIALIZER;
static unsigned observed_calls, observed_frames, remaining, bad_arguments;
static int in_render;
static atomic_int unexpected_stop;

uint32_t rc_audio_render(int16_t *stereo, uint32_t frames, uint32_t rate)
{
    pthread_mutex_lock(&observed_lock);
    in_render++;
    if (!stereo || frames != 441 || rate != 44100) bad_arguments++;
    if (stereo) for (uint32_t i = 0; i < frames && i < 441; ++i) {
        stereo[2 * i] = 1234;
        stereo[2 * i + 1] = -1234;
    }
    remaining -= remaining < frames ? remaining : frames;
    observed_calls++;
    observed_frames += frames;
    in_render--;
    pthread_cond_broadcast(&observed_cond);
    pthread_mutex_unlock(&observed_lock);
    return frames;
}

void rc_request_stop(void) { atomic_fetch_add(&unexpected_stop, 1); }

static int wait_for_consumption(void)
{
    struct timespec limit;
    if (clock_gettime(CLOCK_REALTIME, &limit)) return 0;
    limit.tv_sec += 3; /* generous bounded liveness, not an FPS benchmark */
    pthread_mutex_lock(&observed_lock);
    int error = 0;
    while (remaining && !error)
        error = pthread_cond_timedwait(&observed_cond, &observed_lock, &limit);
    int done = remaining == 0;
    pthread_mutex_unlock(&observed_lock);
    return done && !error;
}

static void lifecycle(void)
{
    /* Restart after join: the former thread must not consume the next run. */
    for (int run = 0; run < 2; ++run) {
        pthread_mutex_lock(&observed_lock);
        observed_calls = observed_frames = bad_arguments = 0;
        remaining = 1323; /* exactly three required 441-frame quanta */
        pthread_mutex_unlock(&observed_lock);
        char error[160] = "";
        RcHeadlessAudio *pump = rc_headless_audio_start(error, sizeof error);
        CHECK(pump != NULL);
        if (!pump) { fprintf(stderr, "%s\n", error); return; }
        int consumed = wait_for_consumption();
        RcHeadlessAudioStats stats = {0};
        int stopped = rc_headless_audio_stop(pump, &stats, error, sizeof error);
        /* Always stop/join before checking the bounded wait's result. */
        CHECK(stopped == 0);
        if (stopped) { fprintf(stderr, "%s\n", error); return; }
        CHECK(consumed);
        pthread_mutex_lock(&observed_lock);
        CHECK(remaining == 0);
        CHECK(observed_calls >= 3);
        CHECK(observed_frames == observed_calls * 441u);
        CHECK(stats.calls == observed_calls);
        CHECK(stats.frames == observed_frames);
        CHECK(bad_arguments == 0 && in_render == 0);
        pthread_mutex_unlock(&observed_lock);
        CHECK(stats.error == 0);
        CHECK(atomic_load(&unexpected_stop) == 0);
    }
}

static void deadline_check(RcAudioDeadline *p, uint64_t finished_ms,
                           uint64_t want_ms, uint64_t want_rebases)
{
    CHECK(rc_audio_deadline_next(p, finished_ms * 1000000u) == want_ms * 1000000u);
    CHECK(p->rebases == want_rebases);
}

static void deadlines(void)
{
    RcAudioDeadline p = {10000000u, 0};
    deadline_check(&p, 2, 10, 0);
    deadline_check(&p, 12, 20, 0);
    deadline_check(&p, 23, 30, 0);
    deadline_check(&p, 32, 40, 0);
    /* Late work rebases once; following work returns to fixed deadlines. */
    deadline_check(&p, 87, 97, 1);
    deadline_check(&p, 99, 107, 1);
    deadline_check(&p, 109, 117, 1);
    deadline_check(&p, 140, 150, 2);
    deadline_check(&p, 160, 160, 2);
    RcAudioDeadline long_gap = {10000000u, 0};
    deadline_check(&long_gap, 86400000, 86400010, 1);
    deadline_check(&long_gap, 86400012, 86400020, 1);
    RcAudioDeadline shifted = {13000000u, 0};
    deadline_check(&shifted, 4, 13, 0);
}

int main(int argc, char **argv)
{
    if (argc != 2) return 1;
    if (!strcmp(argv[1], "lifecycle")) lifecycle();
    else if (!strcmp(argv[1], "deadlines")) deadlines();
    else return 1;
    if (failures) return 1;
    printf("HEADLESS_AUDIO %s passed\n", argv[1]);
    return 0;
}
