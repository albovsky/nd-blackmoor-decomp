/* NATIVE20: accepted-render source cursors, silent offline native components.
 * No output device, wall clock, original execution or deliberate fault tests. */
#import <Foundation/Foundation.h>
#include "../src/macos_audio.h"
#include "../src/live_audio.h"
#include <csignal>
#include <cstdio>
#include <cstring>
#include <unistd.h>
#include <vector>

#define CHECK(condition) do { if (!(condition)) { \
    std::fprintf(stderr, "CHECK failed line=%d: %s\n", __LINE__, #condition); return 1; } } while (0)

static bool render(MacAudioHost *host, uint32_t frames)
{
    MacAudioRender output = MAC_AUDIO_RENDER_INIT;
    char error[256]{};
    if (mac_audio_host_render_offline(host, frames, &output, error, sizeof error) != MAC_AUDIO_OK) return false;
    bool silent = output.frame_count == frames;
    for (uint64_t i = 0; i < output.frame_count * output.channels; ++i)
        if (output.interleaved_pcm[i] != 0.0f) silent = false;
    mac_audio_render_destroy(&output);
    return silent;
}
static bool advance(LiveAudio *audio, uint64_t frames)
{
    LiveAudioOfflineStats stats{};
    return live_audio_advance_offline(audio, frames, &stats, nullptr, 0) == LIVE_AUDIO_OK &&
           stats.frames == frames && stats.nonfinite_samples == 0 && stats.nonzero_samples == 0;
}
static ActionSoundAudioCommand command(const char *stem)
{
    ActionSoundAudioCommand c{};
    std::snprintf(c.asset_stem, sizeof c.asset_stem, "%s", stem);
    c.channel = 12; c.volume_category = 0; c.control_word = 1; c.mode = 1;
    c.first_gain = c.second_gain = 1; c.first_percent = c.second_percent = 100;
    c.transition_scene = 9999;
    return c;
}
static int host_cursor()
{
    MacAudioHost *host = nullptr;
    char error[256]{};
    CHECK(mac_audio_host_open(MAC_AUDIO_MODE_OFFLINE, 48000, 2, &host, error, sizeof error) == MAC_AUDIO_OK);
    std::vector<float> pcm(2400u * 2u, 0.25f);
    CHECK(mac_audio_play(host, 7, pcm.data(), 2400, 2, 24000, 1, 0, error, sizeof error) == MAC_AUDIO_OK);
    MacAudioPlaybackCursor cursor{};
    CHECK(mac_audio_get_playback_cursor(host, 7, 0, &cursor, error, sizeof error) == MAC_AUDIO_OK);
    CHECK(cursor.generation > 0 && cursor.started && cursor.playing && cursor.position_valid && cursor.source_frames == 0);
    const uint64_t first = cursor.generation;
    CHECK(render(host, 480));
    CHECK(mac_audio_get_playback_cursor(host, 7, first, &cursor, error, sizeof error) == MAC_AUDIO_OK);
    CHECK(cursor.source_frames == 240 && cursor.source_frame_count == 2400 && cursor.sample_rate == 24000);
    CHECK(mac_audio_stop(host, 7, error, sizeof error) == MAC_AUDIO_OK);
    MacAudioPlaybackCursor unchanged{}; std::memset(&unchanged, 0x5a, sizeof unchanged);
    MacAudioPlaybackCursor sentinel = unchanged;
    CHECK(mac_audio_get_playback_cursor(host, 7, first, &unchanged, error, sizeof error) == MAC_AUDIO_ERR_STALE);
    CHECK(std::memcmp(&unchanged, &sentinel, sizeof sentinel) == 0);
    CHECK(mac_audio_get_playback_cursor(host, 7, 0, &cursor, error, sizeof error) == MAC_AUDIO_OK);
    CHECK(cursor.generation != first && !cursor.started && !cursor.playing && cursor.source_frames == 0);
    CHECK(mac_audio_play(host, 7, pcm.data(), 2400, 2, 24000, 1, 0, error, sizeof error) == MAC_AUDIO_OK);
    CHECK(mac_audio_get_playback_cursor(host, 7, 0, &cursor, error, sizeof error) == MAC_AUDIO_OK && cursor.source_frames == 0);
    const uint64_t replay = cursor.generation;
    CHECK(replay != first);
    CHECK(render(host, 9600));
    for (unsigned i = 0; i < 100; ++i) {
        CHECK(mac_audio_get_playback_cursor(host, 7, replay, &cursor, error, sizeof error) == MAC_AUDIO_OK);
        if (!cursor.playing) break;
        usleep(1000);
    }
    CHECK(!cursor.playing && cursor.started && cursor.source_frames == 2400);
    CHECK(mac_audio_play(host, 7, pcm.data(), 2400, 2, 24000, 1, 1, error, sizeof error) == MAC_AUDIO_OK);
    CHECK(render(host, 9600));
    CHECK(mac_audio_get_playback_cursor(host, 7, 0, &cursor, error, sizeof error) == MAC_AUDIO_OK &&
          cursor.playing && cursor.source_frames == 2400); /* clamp position, retain loop lifetime */
    CHECK(mac_audio_host_close(host, error, sizeof error) == MAC_AUDIO_OK);
    std::puts("HOST_CURSOR source_rate=24000 rendered=480 consumed=240 stop_replay_stale=1 natural_clamp=1");
    return 0;
}
static int live_cursor(const char *game, const char *stem, bool real)
{
    LiveAudioConfig config{}; config.game_directory = game; config.mode = MAC_AUDIO_MODE_OFFLINE;
    LiveAudio *audio = nullptr; char error[256]{};
    CHECK(live_audio_create(&config, &audio, error, sizeof error) == LIVE_AUDIO_OK);
    CHECK(advance(audio, 4800)); /* no accepted play: this must never count as source progress */
    const auto cmd = command(stem);
    CHECK(live_audio_load_sound(audio, &cmd) == ACTION_SOUND_BACKEND_OK);
    LiveAudioPlaybackCursor cursor{};
    CHECK(live_audio_get_playback_cursor(audio, 12, 0, &cursor) == LIVE_AUDIO_OK);
    CHECK(cursor.loaded && !cursor.started && !cursor.playing && cursor.position_valid && cursor.source_frames == 0);
    CHECK(cursor.channels == 1 && cursor.bits_per_sample == 16 && cursor.sample_rate == (real ? 44100u : 22050u));
    CHECK(cursor.decoded_byte_count == (real ? 1003300u : 88200u));
    const uint64_t loaded = cursor.generation;
    CHECK(live_audio_play_sound(audio, 12) == ACTION_SOUND_BACKEND_OK);
    CHECK(live_audio_get_playback_cursor(audio, 12, 0, &cursor) == LIVE_AUDIO_OK && cursor.started && cursor.playing && cursor.source_frames == 0);
    const uint64_t playing = cursor.generation;
    CHECK(playing != loaded);
    CHECK(advance(audio, 4800));
    CHECK(live_audio_get_playback_cursor(audio, 12, playing, &cursor) == LIVE_AUDIO_OK);
    CHECK(cursor.position_valid && cursor.source_frames == (real ? 4410u : 2205u) && cursor.decoded_byte_position == (real ? 8820u : 4410u));
    const uint64_t frames = cursor.source_frame_count;
    for (unsigned i = 0; cursor.playing && i < 800; ++i) {
        CHECK(advance(audio, 4096));
        CHECK(live_audio_get_playback_cursor(audio, 12, playing, &cursor) == LIVE_AUDIO_OK);
    }
    CHECK(!cursor.playing && cursor.source_frames == frames && cursor.decoded_byte_position <= cursor.decoded_byte_count);
    CHECK(live_audio_stop_channel(audio, 12) == LIVE_AUDIO_OK);
    LiveAudioPlaybackCursor sentinel{}; std::memset(&sentinel, 0x5a, sizeof sentinel);
    LiveAudioPlaybackCursor saved = sentinel;
    CHECK(live_audio_get_playback_cursor(audio, 12, playing, &sentinel) == LIVE_AUDIO_ERR_STALE);
    CHECK(std::memcmp(&saved, &sentinel, sizeof saved) == 0);
    CHECK(live_audio_get_playback_cursor(audio, 12, 0, &cursor) == LIVE_AUDIO_OK && cursor.loaded && !cursor.started && cursor.source_frames == 0);
    CHECK(live_audio_play_sound(audio, 12) == ACTION_SOUND_BACKEND_OK);
    CHECK(live_audio_get_playback_cursor(audio, 12, 0, &cursor) == LIVE_AUDIO_OK && cursor.source_frames == 0 && cursor.generation != playing);
    const uint64_t replay = cursor.generation;
    CHECK(live_audio_load_sound(audio, &cmd) == ACTION_SOUND_BACKEND_OK);
    CHECK(live_audio_get_playback_cursor(audio, 12, replay, &sentinel) == LIVE_AUDIO_ERR_STALE);
    CHECK(live_audio_unload_sound(audio, 12) == ACTION_SOUND_BACKEND_OK);
    CHECK(live_audio_get_playback_cursor(audio, 12, 0, &cursor) == LIVE_AUDIO_OK && !cursor.loaded && !cursor.started && !cursor.playing && cursor.source_frames == 0);
    CHECK(live_audio_get_playback_cursor(audio, 32, 0, &sentinel) == LIVE_AUDIO_ERR_ARGUMENT);
    if (!real) {
        const auto stereo = command("Stereo8");
        CHECK(live_audio_load_sound(audio, &stereo) == ACTION_SOUND_BACKEND_OK);
        CHECK(live_audio_get_playback_cursor(audio, 12, 0, &cursor) == LIVE_AUDIO_OK &&
              cursor.channels == 2 && cursor.bits_per_sample == 8 && cursor.sample_rate == 32000 &&
              cursor.decoded_byte_count == 64000 && cursor.source_frame_count == 32000);
        CHECK(live_audio_play_sound(audio, 12) == ACTION_SOUND_BACKEND_OK && advance(audio, 4800));
        CHECK(live_audio_get_playback_cursor(audio, 12, 0, &cursor) == LIVE_AUDIO_OK &&
              cursor.source_frames == 3200 && cursor.decoded_byte_position == 6400);
    }
    CHECK(live_audio_destroy(audio) == MAC_AUDIO_OK);
    std::printf("LIVE_CURSOR real=%d original_mono=1 bytes_match=1 accepted_render_delta=1 stop_replay_replace_stale=1\n", real ? 1 : 0);
    return 0;
}
static int custom_cursor(const char *game)
{
    LiveAudioHostOps ops{}; live_audio_default_host_ops(&ops);
    LiveAudioConfig config{}; config.game_directory = game; config.mode = MAC_AUDIO_MODE_OFFLINE; config.host_ops = &ops;
    LiveAudio *audio = nullptr; char error[256]{};
    CHECK(live_audio_create(&config, &audio, error, sizeof error) == LIVE_AUDIO_OK);
    LiveAudioPlaybackCursor cursor{}; std::memset(&cursor, 0x5a, sizeof cursor);
    const LiveAudioPlaybackCursor saved = cursor;
    CHECK(live_audio_get_playback_cursor(audio, 12, 0, &cursor) == LIVE_AUDIO_ERR_UNSUPPORTED);
    CHECK(std::memcmp(&saved, &cursor, sizeof saved) == 0);
    CHECK(live_audio_destroy(audio) == MAC_AUDIO_OK);
    std::puts("CUSTOM_CURSOR unsupported=1 output_unchanged=1"); return 0;
}
static void guarded_signal(int number)
{
    static const char message[] = "audio cursor component signal failure\n";
    (void)write(STDERR_FILENO, message, sizeof(message) - 1); _exit(128 + number);
}
int main(int argc, char **argv)
{
    std::signal(SIGABRT, guarded_signal); std::signal(SIGBUS, guarded_signal);
    std::signal(SIGSEGV, guarded_signal); std::signal(SIGILL, guarded_signal);
    @autoreleasepool {
        CHECK(argc >= 2);
        [NSUserDefaults.standardUserDefaults setVolatileDomain:@{@"BlackmoorAudioMuted": @YES} forName:NSArgumentDomain];
        if (!std::strcmp(argv[1], "host")) return host_cursor();
        CHECK(argc == 3);
        if (!std::strcmp(argv[1], "synthetic")) return live_cursor(argv[2], "Mono", false);
        if (!std::strcmp(argv[1], "real")) return live_cursor(argv[2], "JPJ00a", true);
        if (!std::strcmp(argv[1], "custom")) return custom_cursor(argv[2]);
        return 2;
    }
}
