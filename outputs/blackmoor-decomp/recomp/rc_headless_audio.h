/* Device-free real-clock headless consumer; not linked by the Mac frontend. */
#ifndef RC_HEADLESS_AUDIO_H
#define RC_HEADLESS_AUDIO_H
#include <stddef.h>
#include <stdint.h>

typedef struct RcHeadlessAudio RcHeadlessAudio;
typedef struct RcHeadlessAudioStats {
    uint64_t calls, frames, rebases;
    int error;
} RcHeadlessAudioStats;

/* Call after rc_start, before rc_main, only with a real platform clock.
 * NULL reports startup failure; no consumer is left running. */
RcHeadlessAudio *rc_headless_audio_start(char *error, size_t capacity);
/* Request stop and join before inspecting stats or releasing host resources.
 * Returns0 on success. A join error is fatal to the caller; the live object is
 * retained rather than freed. NULL is a no-op. No detached threads. */
int rc_headless_audio_stop(RcHeadlessAudio *pump, RcHeadlessAudioStats *stats,
                           char *error, size_t capacity);
#endif
