/* NATIVE-01: execute the app's actual D1 audio callbacks with original
 * descriptors and CDSound assets. No GUI or output device in the default run. */
#define main blackmoor_app_entry_for_test
#include "../src/blackmoor_app.mm"
#undef main
#include <cstdio>
#define CHECK(condition) do { if (!(condition)) { std::fprintf(stderr, "check failed: %s at line %d\n", #condition, __LINE__); return 1; } } while (0)
#include <fstream>
#include <iterator>

int main(int argc, char **argv)
{
    @autoreleasepool {
        CHECK(argc >= 3);
        NativeApp app;
        app.log = tmpfile();
        CHECK(app.log);
        LiveAudioConfig config{};
        config.game_directory = argv[1];
        config.mode = MAC_AUDIO_MODE_OFFLINE;
        char error[512] = {};
        CHECK(live_audio_create(&config, &app.live_audio, error, sizeof(error)) == LIVE_AUDIO_OK);
        size_t rows = 0, clips = 0;
        double peak = 0;
        std::array<uint8_t, PUZZLE_SOUND_RECORD_BYTES> shared_descriptor{};
        for (int file = 2; file < argc; ++file) {
            std::ifstream input(argv[file], std::ios::binary);
            std::vector<uint8_t> bytes((std::istreambuf_iterator<char>(input)), {});
            if (bytes.empty()) continue;
            SceneResource *scene = scene_resource_open_memory(bytes.data(), bytes.size(), error, sizeof(error));
            if (!scene) continue;
            for (size_t row = 0; row < scene_resource_action_count(scene); ++row) {
                SceneActionInfo info{};
                CHECK(scene_resource_action_at(scene, row, &info) == SCENE_RESOURCE_OK);
                if (info.type != SESSION_AD1_TYPE) continue;
                ++rows;
                CHECK(info.typed_body_length >= 0x376u);
                for (int record_index = 0; record_index < 2; ++record_index) {
                    const uint8_t *descriptor = info.typed_body + (record_index == 0 ? 0x2d9u : 0x345u);
                    if (std::memcmp(descriptor, "NO SOUND", 9) == 0) continue;
                    const uint16_t channel = descriptor[0x21] | (uint16_t)(descriptor[0x22] << 8);
                    CHECK(native_ad1_sound_prepare(&app, record_index, descriptor) == 0);
                    LiveAudioChannelInfo loaded{};
                    CHECK(live_audio_get_channel_info(app.live_audio, channel, &loaded) == LIVE_AUDIO_OK);
                    CHECK(loaded.loaded == 1u); /* regression: old callback returned success without loading */
                    CHECK(native_ad1_sound_play(&app, (int16_t)channel) == 0);
                    int32_t busy = -1;
                    CHECK(native_ad1_sound_busy(&app, (int16_t)channel, &busy) == 0 && busy == 1);
                    uint64_t nonzero = 0;
                    for (uint64_t rendered = 0; busy && rendered < 48000u * 60u; rendered += 4096u) {
                        LiveAudioOfflineStats stats{};
                        CHECK(live_audio_advance_offline(app.live_audio, 4096u, &stats, nullptr, 0u) == LIVE_AUDIO_OK);
                        CHECK(stats.nonfinite_samples == 0u);
                        nonzero += stats.nonzero_samples;
                        peak = std::fmax(peak, stats.peak);
                        CHECK(native_ad1_sound_busy(&app, (int16_t)channel, &busy) == 0);
                    }
                    CHECK(busy == 0 && nonzero > 0u);
                    CHECK(native_ad1_sound_stop(&app, record_index, descriptor) == 0);
                    CHECK(live_audio_get_channel_info(app.live_audio, channel, &loaded) == LIVE_AUDIO_OK && !loaded.loaded);
                    std::memcpy(shared_descriptor.data(), descriptor, shared_descriptor.size());
                    ++clips;
                }
            }
            scene_resource_close(scene);
        }
        CHECK(rows == 11u && clips == 20u);
        /* A scene action may replace the same original channel. Failed/missing
         * prepares must not make the puzzle's readiness mask hide that load. */
        auto missing = shared_descriptor;
        std::memset(missing.data(), 0, 33u);
        std::memcpy(missing.data(), "__NATIVE_MISSING_AUDIO__", 24u);
        CHECK(native_ad1_sound_prepare(&app, 0, missing.data()) == 0);
        const uint16_t shared_channel = shared_descriptor[0x21] | (uint16_t)(shared_descriptor[0x22] << 8);
        CHECK(native_ad1_sound_play(&app, (int16_t)shared_channel) == 0); /* unloaded is a silent absence */
        ActionSoundBackend shared_backend{};
        CHECK(live_audio_bind_backend(app.live_audio, &shared_backend) == LIVE_AUDIO_OK);
        PuzzleSound peer{};
        CHECK(puzzle_sound_init(&peer, &shared_backend) == PUZZLE_SOUND_OK);
        CHECK(puzzle_sound_prepare(&peer, shared_descriptor.data(), shared_descriptor.size()) == PUZZLE_SOUND_OK);
        CHECK(native_ad1_sound_play(&app, (int16_t)shared_channel) == 0);
        int32_t shared_busy = -1;
        CHECK(native_ad1_sound_busy(&app, (int16_t)shared_channel, &shared_busy) == 0 && shared_busy == 1);
        CHECK(live_audio_unload_sound(app.live_audio, shared_channel) == ACTION_SOUND_BACKEND_OK);
        CHECK(native_ad1_sound_busy(&app, (int16_t)shared_channel, &shared_busy) == 0 && shared_busy == 0);
        CHECK(native_ad1_sound_play(&app, (int16_t)shared_channel) == 0);
        CHECK(native_ad1_sound_prepare(nullptr, 0, nullptr) != 0);
        CHECK(native_ad1_sound_play(&app, -1) != 0);
        CHECK(native_ad1_sound_busy(&app, -1, nullptr) != 0);
        CHECK(live_audio_destroy(app.live_audio) == LIVE_AUDIO_OK);
        app.live_audio = nullptr;
        std::fclose(app.log);
        app.log = nullptr;
        std::printf("D1 app audio: rows=%zu clips=%zu nonzero_PCM=1 completion_gated=1 peak=%.6f output_device=none\n", rows, clips, peak);
    }
    return 0;
}
