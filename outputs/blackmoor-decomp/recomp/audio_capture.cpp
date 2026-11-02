#include "audio_capture.h"

#include <algorithm>
#include <array>
#include <atomic>
#include <cerrno>
#include <chrono>
#include <cstdio>
#include <cstring>
#include <limits>
#include <thread>
#include <unistd.h>
#include <vector>

#ifdef RC_AUDIO_CAPTURE_TESTING
extern void audio_capture_test_phase(unsigned phase);
#endif

namespace {
constexpr size_t kFrameBytes = 4; // two little-endian signed 16-bit samples
constexpr size_t kWriteFrames = 4096;
constexpr uint64_t kMaxFrames = (UINT32_MAX - 36u) / kFrameBytes;
enum Failure { none, queue_full, write_error, size_limit, invalid_samples };
static_assert(std::atomic<uint64_t>::is_always_lock_free, "capture requires lock-free frame counters");
static_assert(std::atomic<bool>::is_always_lock_free, "capture requires a lock-free stop flag");
static_assert(std::atomic<Failure>::is_always_lock_free, "capture requires lock-free error reporting");

void put16(uint8_t *p, uint16_t v) { p[0] = (uint8_t)v; p[1] = (uint8_t)(v >> 8); }
void put32(uint8_t *p, uint32_t v) { put16(p, (uint16_t)v); put16(p + 2, (uint16_t)(v >> 16)); }

bool write_header(FILE *file, uint32_t rate, uint64_t frames)
{
    uint8_t h[44] = {};
    memcpy(h, "RIFF", 4); put32(h + 4, 36u + (uint32_t)(frames * kFrameBytes));
    memcpy(h + 8, "WAVEfmt ", 8); put32(h + 16, 16);
    put16(h + 20, 1); put16(h + 22, 2); put32(h + 24, rate);
    put32(h + 28, rate * kFrameBytes); put16(h + 32, kFrameBytes); put16(h + 34, 16);
    memcpy(h + 36, "data", 4); put32(h + 40, (uint32_t)(frames * kFrameBytes));
    return fseek(file, 0, SEEK_SET) == 0 && fwrite(h, 1, sizeof h, file) == sizeof h;
}
} // namespace

struct AudioCapture::State {
    FILE *file = nullptr;
    uint32_t rate = 0;
    size_t capacity = 0;
    std::vector<int16_t> queue;
    std::atomic<uint64_t> read{0}, write{0}, written{0};
    std::atomic<bool> stopping{false};
    std::atomic<Failure> failure{none};
    std::thread writer;
    int io_errno = 0; // writer only, read after join

    void fail(Failure why) noexcept
    {
        Failure expected = none;
        failure.compare_exchange_strong(expected, why, std::memory_order_relaxed);
    }

    void io_failed()
    {
        if (!io_errno) io_errno = errno ? errno : EIO;
        fail(write_error);
    }

    void run()
    {
        std::array<uint8_t, kWriteFrames * kFrameBytes> bytes;
        for (;;) {
            // Observe stop before the queue. Seeing stop also makes the final
            // producer writes visible; an earlier empty snapshot cannot end it.
            bool stopping_now = stopping.load(std::memory_order_acquire);
            uint64_t at = read.load(std::memory_order_relaxed);
            uint64_t available = write.load(std::memory_order_acquire) - at;
            if (!available) {
#ifdef RC_AUDIO_CAPTURE_TESTING
                audio_capture_test_phase(1);
#endif
                if (stopping_now) break;
                std::this_thread::sleep_for(std::chrono::milliseconds(2));
                continue;
            }
            uint64_t done = written.load(std::memory_order_relaxed);
            size_t count = (size_t)std::min<uint64_t>(available, kWriteFrames);
            if (count > kMaxFrames - done) { fail(size_limit); break; }
            for (size_t f = 0; f < count; f++) {
                size_t pos = (size_t)((at + f) % capacity) * 2;
                put16(bytes.data() + f * kFrameBytes, (uint16_t)queue[pos]);
                put16(bytes.data() + f * kFrameBytes + 2, (uint16_t)queue[pos + 1]);
            }
            read.store(at + count, std::memory_order_release);
            size_t saved = fwrite(bytes.data(), kFrameBytes, count, file);
            written.store(done + saved, std::memory_order_release);
            if (saved != count) { io_failed(); break; }
        }

        // A short fwrite can leave a partial frame. Keep only complete frames.
        uint64_t frames = written.load(std::memory_order_relaxed);
        if (fflush(file) != 0) io_failed();
        if (ftruncate(fileno(file), (off_t)(44 + frames * kFrameBytes)) != 0) io_failed();
        clearerr(file);
        if (!write_header(file, rate, frames)) io_failed();
        if (fclose(file) != 0) io_failed();
        file = nullptr;
    }
};

AudioCapture::AudioCapture() = default;
AudioCapture::~AudioCapture() { std::string ignored; finish(ignored); }

bool AudioCapture::start(const char *path, uint32_t sample_rate, std::string &error, size_t queue_frames)
{
    error.clear();
    if (state_) { error = "capture already started"; return false; }
    if (!path || !*path || !sample_rate || sample_rate > UINT32_MAX / kFrameBytes) {
        error = "invalid capture path or sample rate"; return false;
    }
    if (!queue_frames) queue_frames = (size_t)sample_rate * 4;
    if (queue_frames > std::numeric_limits<size_t>::max() / (2 * sizeof(int16_t))) {
        error = "capture queue too large"; return false;
    }
    auto state = std::make_unique<State>();
    state->rate = sample_rate;
    state->capacity = queue_frames;
    try { state->queue.resize(queue_frames * 2); }
    catch (const std::exception &e) { error = e.what(); return false; }
    state->file = fopen(path, "wb");
    if (!state->file) { error = std::string("cannot open capture: ") + strerror(errno); return false; }
    if (!write_header(state->file, sample_rate, 0)) {
        error = std::string("cannot write capture header: ") + strerror(errno);
        fclose(state->file);
        return false;
    }
    try { state->writer = std::thread([s = state.get()] { s->run(); }); }
    catch (const std::exception &e) { fclose(state->file); error = e.what(); return false; }
    state_ = std::move(state);
    return true;
}

bool AudioCapture::append(const int16_t *stereo, uint32_t frames) noexcept
{
    State *s = state_.get();
    if (!s || s->stopping.load(std::memory_order_relaxed) || s->failure.load(std::memory_order_relaxed) != none) return false;
    if (!frames) return true;
    if (!stereo) { s->fail(invalid_samples); return false; }
    uint64_t at = s->write.load(std::memory_order_relaxed);
    uint64_t queued = at - s->read.load(std::memory_order_acquire);
    if (frames > s->capacity - queued) { s->fail(queue_full); return false; }
    size_t pos = (size_t)(at % s->capacity);
    size_t first = std::min<size_t>(frames, s->capacity - pos);
    memcpy(s->queue.data() + pos * 2, stereo, first * kFrameBytes);
    if (first < frames) memcpy(s->queue.data(), stereo + first * 2, (frames - first) * kFrameBytes);
    s->write.store(at + frames, std::memory_order_release);
    return true;
}

bool AudioCapture::finish(std::string &error)
{
    error.clear();
    if (!state_) return true;
    State &s = *state_;
    s.stopping.store(true, std::memory_order_release);
#ifdef RC_AUDIO_CAPTURE_TESTING
    audio_capture_test_phase(2);
#endif
    if (s.writer.joinable()) s.writer.join();
    switch (s.failure.load(std::memory_order_relaxed)) {
        case none: return true;
        case queue_full: error = "capture queue overflow; WAV contains only the accepted prefix"; break;
        case size_limit: error = "capture exceeds the 4 GiB WAV limit"; break;
        case invalid_samples: error = "capture received a null sample buffer"; break;
        case write_error: error = std::string("capture file I/O failed: ") + strerror(s.io_errno); break;
    }
    if (s.io_errno && s.failure.load(std::memory_order_relaxed) != write_error)
        error += std::string("; file I/O failed: ") + strerror(s.io_errno);
    return false;
}

uint64_t AudioCapture::frames_written() const noexcept
{
    return state_ ? state_->written.load(std::memory_order_acquire) : 0;
}
