// Offline capture of interleaved stereo PCM16. No sound device is used here.
#ifndef RC_AUDIO_CAPTURE_H
#define RC_AUDIO_CAPTURE_H

#include <cstddef>
#include <cstdint>
#include <memory>
#include <string>

class AudioCapture {
public:
    AudioCapture();
    ~AudioCapture();
    AudioCapture(const AudioCapture &) = delete;
    AudioCapture &operator=(const AudioCapture &) = delete;

    // Open before starting the producer. Zero queue_frames selects four seconds.
    bool start(const char *path, uint32_t sample_rate, std::string &error, size_t queue_frames = 0);
    // One producer only. Bounded copies and lock-free atomics; no I/O, allocation
    // or waiting. An overflow fails capture rather than silently dropping audio.
    bool append(const int16_t *stereo, uint32_t frames) noexcept;
    // Stop the producer first. Drain the queue, finalize the WAV and join its writer.
    // On failure the WAV contains the accepted prefix, subject to filesystem errors.
    bool finish(std::string &error);
    uint64_t frames_written() const noexcept;

private:
    struct State;
    std::unique_ptr<State> state_;
};

#endif
