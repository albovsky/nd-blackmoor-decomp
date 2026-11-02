#define _POSIX_C_SOURCE 200809L
#include "rc_headless_audio.h"
#include "rc_platform.h"
#include <errno.h>
#include <pthread.h>
#include <stdatomic.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define AUDIO_PERIOD_NS UINT64_C(10000000)
#define AUDIO_RATE 44100u
#define AUDIO_FRAMES 441u

/* Same fixed-deadline/one-rebase policy as Mac's MutedAudioPacer. */
typedef struct RcAudioDeadline { uint64_t next_ns, rebases; } RcAudioDeadline;
static uint64_t rc_audio_deadline_next(RcAudioDeadline *p, uint64_t finished)
{
    if (finished > p->next_ns) {
        p->next_ns = finished + AUDIO_PERIOD_NS;
        p->rebases++;
    }
    uint64_t result = p->next_ns;
    p->next_ns += AUDIO_PERIOD_NS;
    return result;
}

struct RcHeadlessAudio {
    pthread_t thread;
    atomic_int stop;
    RcAudioDeadline deadline;
    RcHeadlessAudioStats stats; /* producer-local, read only after join */
};

static int monotonic_ns(uint64_t *value)
{
    struct timespec now;
    if (clock_gettime(CLOCK_MONOTONIC, &now)) return errno;
    *value = (uint64_t)now.tv_sec * UINT64_C(1000000000) + (uint64_t)now.tv_nsec;
    return 0;
}

static void describe_error(char *buffer, size_t capacity, int error)
{
    if (buffer && capacity) snprintf(buffer, capacity, "headless audio: %s", strerror(error));
}

static int wait_until(RcHeadlessAudio *p, uint64_t deadline)
{
    while (!atomic_load_explicit(&p->stop, memory_order_acquire)) {
        uint64_t now;
        int error = monotonic_ns(&now);
        if (error) return error;
        if (now >= deadline) return 0;
        uint64_t left = deadline - now;
        struct timespec delay = {(time_t)(left / UINT64_C(1000000000)),
                                 (long)(left % UINT64_C(1000000000))};
        if (nanosleep(&delay, NULL) && errno != EINTR) return errno;
    }
    return 0;
}

static void *consume_audio(void *context)
{
    RcHeadlessAudio *p = context;
    int16_t stereo[AUDIO_FRAMES * 2];
    while (!atomic_load_explicit(&p->stop, memory_order_acquire)) {
        uint32_t written = rc_audio_render(stereo, AUDIO_FRAMES, AUDIO_RATE);
        p->stats.calls++;
        p->stats.frames += written;
        if (written != AUDIO_FRAMES) { p->stats.error = EIO; break; }
        uint64_t finished;
        p->stats.error = monotonic_ns(&finished);
        if (p->stats.error) break;
        uint64_t wake = rc_audio_deadline_next(&p->deadline, finished);
        p->stats.error = wait_until(p, wake);
        if (p->stats.error) break;
    }
    p->stats.rebases = p->deadline.rebases;
    /* A failed consumer cannot leave a real-clock guest waiting on a sound. */
    if (p->stats.error) rc_request_stop();
    return NULL;
}

RcHeadlessAudio *rc_headless_audio_start(char *error, size_t capacity)
{
    RcHeadlessAudio *p = calloc(1, sizeof *p);
    if (!p) { describe_error(error, capacity, ENOMEM); return NULL; }
    uint64_t start;
    int status = monotonic_ns(&start);
    if (!status) {
        atomic_init(&p->stop, 0);
        p->deadline.next_ns = start + AUDIO_PERIOD_NS;
        status = pthread_create(&p->thread, NULL, consume_audio, p);
    }
    if (status) { describe_error(error, capacity, status); free(p); return NULL; }
    return p;
}

int rc_headless_audio_stop(RcHeadlessAudio *p, RcHeadlessAudioStats *stats,
                           char *error, size_t capacity)
{
    if (stats) memset(stats, 0, sizeof *stats);
    if (!p) return 0;
    atomic_store_explicit(&p->stop, 1, memory_order_release);
    int status = pthread_join(p->thread, NULL);
    if (status) {
        if (stats) stats->error = status;
        describe_error(error, capacity, status);
        return -1;
    }
    if (stats) *stats = p->stats;
    status = p->stats.error;
    free(p);
    if (status) { describe_error(error, capacity, status); return -1; }
    return 0;
}
