// Pure deadline policy for the device-free 441-frame / 44.1 kHz producer.
#ifndef BLACKMOOR_RECOMP_MUTED_AUDIO_PACER_H
#define BLACKMOOR_RECOMP_MUTED_AUDIO_PACER_H

#include <chrono>
#include <cstdint>

namespace blackmoor_recomp {
class MutedAudioPacer {
public:
    using Clock = std::chrono::steady_clock;
    using Time = Clock::time_point;

    explicit MutedAudioPacer(Time start) : next_(start + period()) {}

    Time next_after_render(Time finished) {
        if (finished > next_) {
            // Forget missed deadlines; never queue historical render work.
            next_ = finished + period();
            ++rebases_;
        }
        const Time result = next_;
        next_ += period();
        return result;
    }

    std::uint64_t rebases() const { return rebases_; }

private:
    static constexpr std::chrono::milliseconds period() {
        return std::chrono::milliseconds(10);
    }
    Time next_;
    std::uint64_t rebases_ = 0;
};
} // namespace blackmoor_recomp

#endif
