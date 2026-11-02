// Synthetic PCM only: this executable does not link or open an audio device.
#include "audio_capture.h"

#include <atomic>
#include <chrono>
#include <cstdio>
#include <pthread.h>
#include <stdexcept>
#include <string>
#include <thread>
#include <time.h>
#include <vector>

static void require(bool condition, const std::string &message)
{
    if (!condition) throw std::runtime_error(message);
}

static void await_frames(const AudioCapture &capture, uint64_t frames)
{
    auto deadline = std::chrono::steady_clock::now() + std::chrono::seconds(2);
    while (capture.frames_written() < frames && std::chrono::steady_clock::now() < deadline)
        std::this_thread::sleep_for(std::chrono::milliseconds(1));
    require(capture.frames_written() == frames, "writer did not consume queued frames");
}

static std::atomic<bool> drain_race_enabled{false}, drain_race_failed{false};
static pthread_mutex_t drain_race_lock = PTHREAD_MUTEX_INITIALIZER;
static pthread_cond_t drain_race_changed = PTHREAD_COND_INITIALIZER;
static bool drain_race_empty, drain_race_stopping, drain_race_release;

static bool race_deadline(struct timespec &deadline)
{
    if (clock_gettime(CLOCK_REALTIME, &deadline) != 0) {
        drain_race_failed.store(true);
        return false;
    }
    deadline.tv_sec += 2;
    return true;
}

static void race_notify()
{
    if (pthread_cond_broadcast(&drain_race_changed) != 0) drain_race_failed.store(true);
}

// Called by the writer and closer. Synchronization failures are recorded, never
// thrown on either thread; the main thread checks them after joining the closer.
void audio_capture_test_phase(unsigned phase)
{
    if (!drain_race_enabled.load()) return;
    if (pthread_mutex_lock(&drain_race_lock) != 0) {
        drain_race_failed.store(true);
        return;
    }
    if (phase == 1 && !drain_race_empty) {
        drain_race_empty = true;
        race_notify();
        struct timespec deadline;
        if (!race_deadline(deadline)) drain_race_release = true;
        while (!drain_race_release) {
            if (pthread_cond_timedwait(&drain_race_changed, &drain_race_lock, &deadline) != 0) {
                drain_race_failed.store(true);
                drain_race_release = true;
            }
        }
    } else if (phase == 2) {
        drain_race_stopping = true;
        race_notify();
    }
    if (pthread_mutex_unlock(&drain_race_lock) != 0) drain_race_failed.store(true);
}

static bool await_race_phase(unsigned phase)
{
    if (pthread_mutex_lock(&drain_race_lock) != 0) {
        drain_race_failed.store(true);
        return false;
    }
    const bool &seen = phase == 1 ? drain_race_empty : drain_race_stopping;
    struct timespec deadline;
    bool ok = race_deadline(deadline);
    while (ok && !seen) {
        if (pthread_cond_timedwait(&drain_race_changed, &drain_race_lock, &deadline) != 0) {
            drain_race_failed.store(true);
            ok = false;
        }
    }
    ok = ok && seen;
    if (pthread_mutex_unlock(&drain_race_lock) != 0) drain_race_failed.store(true);
    return ok;
}

static void release_race_writer()
{
    if (pthread_mutex_lock(&drain_race_lock) != 0) {
        drain_race_failed.store(true);
        return;
    }
    drain_race_release = true;
    race_notify();
    if (pthread_mutex_unlock(&drain_race_lock) != 0) drain_race_failed.store(true);
}

static void finish_empty_snapshot_race(AudioCapture &capture, const char *path)
{
    drain_race_enabled.store(true);
    std::string error;
    require(capture.start(path, 44100, error, 3), error);
    const bool paused = await_race_phase(1);
    const int16_t pcm[] = {101, -202, 303, -404, 505, -606};
    const bool appended = paused && capture.append(pcm, 3);
    bool finished = false, finish_threw = false;
    std::thread closer([&] {
        try { finished = capture.finish(error); }
        catch (...) { finish_threw = true; }
    });
    const bool stopping = await_race_phase(2);
    release_race_writer();
    closer.join();
    drain_race_enabled.store(false);

    // All failure checks occur after release/join, including bounded-wait
    // failures, so exception unwinding cannot destroy a joinable closer.
    require(paused && stopping && !drain_race_failed.load(), "drain race synchronization failed");
    require(appended, "final stereo frames were not accepted");
    require(!finish_threw, "finish threw on closer thread");
    require(finished, error);
    require(capture.frames_written() == 3, "finish lost accepted final stereo frames");
}

int main(int argc, char **argv)
{
    try {
        require(argc == 3, "expected MODE WAV");
        std::string mode = argv[1], error;
        AudioCapture capture;
        if (mode == "invalid") {
            require(!capture.start(argv[2], 0, error), "zero sample rate accepted");
            require(!error.empty(), "missing argument error");
            require(!capture.start("", 44100, error), "empty path accepted");
            require(!capture.start(argv[2], UINT32_MAX, error), "overflowing byte rate accepted");
            require(capture.finish(error), error);
            return 0;
        }
        if (mode == "bad-path") {
            require(!capture.start(argv[2], 44100, error), "invalid output path accepted");
            require(!error.empty(), "missing open error");
            return 0;
        }
        if (mode == "finish-race") {
            finish_empty_snapshot_race(capture, argv[2]);
            return 0;
        }
        size_t capacity = mode == "wrap" ? 4 : (mode == "overflow" ? 2 : 8192);
        require(capture.start(argv[2], 44100, error, capacity), error);
        if (mode == "wrap") {
            const int16_t pcm[] = {-32768, 32767, -1, 1, 0, 0};
            for (unsigned block = 0; block < 32; block++) {
                require(capture.append(pcm, 3), "PCM rejected before queue was full");
                await_frames(capture, (uint64_t)(block + 1) * 3);
            }
        } else if (mode == "drain" || mode == "destructor") {
            std::vector<int16_t> pcm(8192 * 2);
            for (size_t i = 0; i < pcm.size(); i++) pcm[i] = (int16_t)((int)(i % 65536) - 32768);
            require(capture.append(pcm.data(), 8192), "full queue rejected");
            if (mode == "destructor") return 0;
        } else if (mode == "overflow") {
            const int16_t pcm[] = {123, -456, 5, 6, 7, 8};
            require(capture.append(pcm, 1), "prefix rejected");
            require(!capture.append(pcm, 3), "oversized callback accepted");
            require(!capture.append(pcm, 1), "capture resumed after losing audio");
            require(!capture.finish(error), "overflow reported as successful capture");
            require(error.find("overflow") != std::string::npos, error);
            require(capture.frames_written() == 1, "accepted prefix was not drained");
            require(!capture.finish(error), "overflow lost on repeated finish");
            return 0;
        } else require(mode == "empty", "unknown mode");
        require(capture.finish(error), error);
        require(capture.finish(error), "repeated finish failed");
        require(!capture.append(nullptr, 0), "producer remained open after finish");
    } catch (const std::exception &e) {
        fprintf(stderr, "%s\n", e.what());
        return 1;
    }
    return 0;
}
