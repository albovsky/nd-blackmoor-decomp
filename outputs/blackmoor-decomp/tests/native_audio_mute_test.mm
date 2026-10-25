/* Master mute integration: synthetic PCM and offline rendering only.
 * NSArgumentDomain is volatile and process-local; no saved preferences change. */
#import <Foundation/Foundation.h>
#include "../src/macos_audio.h"

#include <algorithm>
#include <cmath>
#include <csignal>
#include <cstdio>
#include <unistd.h>
#include <vector>

#define CHECK(condition) do { if (!(condition)) { \
    std::fprintf(stderr, "check failed: %s at line %d; audio=%s\n", \
                 #condition, __LINE__, error); return 1; \
} } while (0)

static void fixture_signal(int number)
{
    /* Report unexpected native faults without invoking macOS crash reporting.
     * The handler uses only async-signal-safe calls. */
    static const char prefix[] = "mute fixture signal failure number=";
    const char digits[] = {static_cast<char>('0' + number / 10),
                           static_cast<char>('0' + number % 10), '\n'};
    (void)write(STDERR_FILENO, prefix, sizeof(prefix) - 1);
    (void)write(STDERR_FILENO, digits, sizeof(digits));
    _exit(128 + number);
}

static int exercise(bool muted)
{
    char error[512] = {};
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    NSMutableDictionary *arguments = [[defaults volatileDomainForName:NSArgumentDomain] mutableCopy];
    if (arguments == nil) arguments = [NSMutableDictionary dictionary];
    arguments[@"BlackmoorAudioMuted"] = @(muted);
    [defaults setVolatileDomain:arguments forName:NSArgumentDomain];
    CHECK([defaults boolForKey:@"BlackmoorAudioMuted"] == muted);

    MacAudioHost *host = nullptr;
    CHECK(mac_audio_host_open(MAC_AUDIO_MODE_OFFLINE, 48000u, 2u,
                               &host, error, sizeof error) == MAC_AUDIO_OK);
    /* Ordinary game channels occupy paired slots below 64; the Bink-style
     * movie path uses its dedicated slot 64 on this same host mixer. Put each
     * clip in a different stereo channel so the unmuted control observes both. */
    const uint32_t slots[] = {8u, 64u};
    constexpr uint32_t source_frames = 2048u;
    std::vector<float> ordinary(source_frames * 2u, 0.0f);
    std::vector<float> movie(source_frames * 2u, 0.0f);
    for (uint32_t frame = 0; frame < source_frames; ++frame) {
        ordinary[frame * 2u] = 0.25f;
        movie[frame * 2u + 1u] = 0.375f;
    }
    CHECK(mac_audio_play(host, slots[0], ordinary.data(), source_frames, 2u, 48000u,
                         1.0f, 0, error, sizeof error) == MAC_AUDIO_OK);
    CHECK(mac_audio_play(host, slots[1], movie.data(), source_frames, 2u, 48000u,
                         1.0f, 0, error, sizeof error) == MAC_AUDIO_OK);
    int playing[2] = {};
    for (size_t slot = 0; slot < 2; ++slot) {
        CHECK(mac_audio_is_playing(host, slots[slot], &playing[slot],
                                   error, sizeof error) == MAC_AUDIO_OK);
        CHECK(playing[slot] == 1);
    }

    float peak[2] = {};
    uint32_t blocks = 0;
    /* The only route to idle here is each non-looping player's natural
     * DataRendered completion. Muting must leave that lifecycle working. */
    for (; blocks < 128u; ++blocks) {
        MacAudioRender render = MAC_AUDIO_RENDER_INIT;
        CHECK(mac_audio_host_render_offline(host, 256u, &render,
                                            error, sizeof error) == MAC_AUDIO_OK);
        CHECK(render.frame_count == 256u && render.channels == 2u && render.sample_rate == 48000u);
        for (uint64_t frame = 0; frame < render.frame_count; ++frame) {
            for (size_t channel = 0; channel < 2; ++channel) {
                const float sample = render.interleaved_pcm[frame * 2u + channel];
                CHECK(std::isfinite(sample));
                peak[channel] = std::max(peak[channel], std::fabs(sample));
            }
        }
        mac_audio_render_destroy(&render);
        /* Completion delivery occurs on an AVAudioEngine callback queue. */
        [NSThread sleepForTimeInterval:0.001];
        for (size_t slot = 0; slot < 2; ++slot) {
            CHECK(mac_audio_is_playing(host, slots[slot], &playing[slot],
                                       error, sizeof error) == MAC_AUDIO_OK);
        }
        if (playing[0] == 0 && playing[1] == 0) break;
    }
    CHECK(blocks < 128u && playing[0] == 0 && playing[1] == 0);
    CHECK(mac_audio_host_close(host, error, sizeof error) == MAC_AUDIO_OK);
    std::printf("MUTE muted=%d ordinary_peak=%.6f movie_peak=%.6f natural_completion=2\n",
                muted ? 1 : 0, peak[0], peak[1]);
    if (muted) {
        CHECK(peak[0] == 0.0f && peak[1] == 0.0f);
    } else {
        CHECK(peak[0] > 0.1f && peak[1] > 0.1f);
    }
    return 0;
}

int main()
{
    std::signal(SIGBUS, fixture_signal);
    std::signal(SIGSEGV, fixture_signal);
    std::signal(SIGABRT, fixture_signal);
    std::signal(SIGILL, fixture_signal);
    std::signal(SIGFPE, fixture_signal);
    @autoreleasepool {
        NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
        NSDictionary *saved_arguments = [defaults volatileDomainForName:NSArgumentDomain];
        const int muted = exercise(true);
        /* Allow the first offline graph's internal queues to tear down. */
        [NSThread sleepForTimeInterval:0.05];
        const int unmuted = exercise(false);
        [defaults setVolatileDomain:saved_arguments != nil ? saved_arguments : @{} forName:NSArgumentDomain];
        return muted != 0 ? muted : unmuted;
    }
}
