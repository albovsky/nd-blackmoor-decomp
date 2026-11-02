// Finite synthetic times only; no clock reads or sleeps.
#include "../recomp/muted_audio_pacer.h"
#include <cstdio>

using Pacer = blackmoor_recomp::MutedAudioPacer;

static Pacer::Time at(long long ms) {
    return Pacer::Time{} + std::chrono::milliseconds(ms);
}

static bool check(Pacer &pacer, long long finished, long long expected,
                  unsigned long long rebases) {
    if (pacer.next_after_render(at(finished)) != at(expected) ||
        pacer.rebases() != rebases) {
        std::fprintf(stderr, "deadline policy failed at synthetic %lld ms\n", finished);
        return false;
    }
    return true;
}

int main() {
    // Render cost and modest wake jitter do not shift the 10 ms phase.
    Pacer regular(at(0));
    if (!check(regular, 2, 10, 0) || !check(regular, 12, 20, 0) ||
        !check(regular, 23, 30, 0) || !check(regular, 32, 40, 0) ||
        !check(regular, 42, 50, 0)) return 1;

    // A stall produces a single future deadline, not a backlog loop.
    Pacer stalled(at(0));
    if (!check(stalled, 2, 10, 0) || !check(stalled, 87, 97, 1) ||
        !check(stalled, 99, 107, 1) || !check(stalled, 109, 117, 1) ||
        !check(stalled, 140, 150, 2) || !check(stalled, 160, 160, 2)) return 1;

    Pacer long_stall(at(0));
    if (!check(long_stall, 86400000, 86400010, 1) ||
        !check(long_stall, 86400012, 86400020, 1)) return 1;

    Pacer shifted(at(3));
    if (!check(shifted, 4, 13, 0)) return 1;
    std::puts("finite synthetic muted-pacer checks passed");
    return 0;
}
