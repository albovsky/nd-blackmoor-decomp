/* NATIVE-01: execute the app's actual D1 audio callbacks with original
 * descriptors and CDSound assets. No GUI or output device in the default run. */
#define main blackmoor_app_entry_for_test
#include "../src/blackmoor_app.mm"
#undef main
#include <cstdio>
#define CHECK(condition) do { if (!(condition)) { std::fprintf(stderr, "check failed: %s at line %d\n", #condition, __LINE__); return 1; } } while (0)
#include <fstream>
#include <iterator>

static int run_lifecycle(NativeApp &app, const SceneResource *scene, size_t row,
                         const SceneActionInfo &info, bool exit_path, size_t &busy_waits)
{
    /* Only non-audio host boundaries use fixtures: render handles, inventory
     * and the transition/event sinks. Every sound boundary is the real app callback. */
    SessionAd1Host host{};
    host.kernel.context = &app;
    host.kernel.alloc_slot = [](void *, int16_t *slot) { *slot = D9_SLOT_FIRST; return 0; };
    host.kernel.register_slot = [](void *, int16_t, const char *) { return 0; };
    host.kernel.load_surface = [](void *, const char *, uint32_t *surface) { *surface = 1u; return 0; };
    host.kernel.set_slot_surface = [](void *, int16_t, uint32_t) { return 0; };
    host.kernel.release_surface = [](void *, uint32_t) { return 0; };
    host.kernel.release_slot = [](void *, int16_t) { return 0; };
    host.kernel.mark_dirty = [](void *, int16_t) { return 0; };
    host.kernel.view_origin = [](void *, int32_t *x, int32_t *y) { *x = *y = 0; return 0; };
    host.kernel.clear_pending_item = [](void *) { return 0; };
    host.kernel.sound_prepare = native_ad1_sound_prepare;
    host.kernel.sound_stop = native_ad1_sound_stop;
    host.kernel.sound_play = native_ad1_sound_play;
    host.kernel.sound_busy = native_ad1_sound_busy;
    host.kernel.tick = native_ad1_tick;
    host.kernel.event_flag_invalid = [](void *, int16_t index) -> int { return index < 0 || index >= 4096; };
    host.kernel.store_event_flag = [](void *, int16_t, uint32_t) { return 0; };
    host.kernel.transition = [](void *, const D1Transition *) { return 0; };
    SessionAd1Binding *binding = session_ad1_create(&host);
    CHECK(binding && session_ad1_begin_scene(binding, scene) == D1_OK);
    uint32_t phase = 0;
    bool completed = false;
    const size_t waits_before_row = busy_waits;
    auto visit = [&]() -> bool {
        LiveAudioOfflineStats stats{};
        if (live_audio_advance_offline(app.live_audio, 4096u, &stats, nullptr, 0u) != LIVE_AUDIO_OK) return false;
        app.session_tick_sample += 86u;
        SceneActionRuntimeState before{};
        before.phase = phase;
        SceneActionHandlerResult out{};
        if (session_ad1_handler(binding, row, &info, &before, &out) != SCENE_ACTION_HANDLER_OK) return false;
        phase = out.phase;
        completed = out.disposition == SCENE_ACTION_HANDLER_COMPLETED;
        if (session_ad1_object(binding)->state == D1_STATE_WIN_SOUND && phase == 1u) {
            const uint8_t *body = info.typed_body;
            const int16_t channel = (int16_t)(body[0x366] | (uint16_t)(body[0x367] << 8));
            int32_t playing = 0;
            if (native_ad1_sound_busy(&app, channel, &playing) != 0) return false;
            if (playing) ++busy_waits;
        }
        if (stats.nonfinite_samples != 0u) return false;
        return true;
    };
    CHECK(visit() && phase == 1u);
    const uint8_t *body = info.typed_body;
    auto word = [&](size_t offset) -> int16_t { return (int16_t)(body[offset] | (uint16_t)(body[offset + 1] << 8)); };
    auto dword = [&](size_t offset) -> int32_t {
        return (int32_t)((uint32_t)body[offset] | ((uint32_t)body[offset + 1] << 8) |
                         ((uint32_t)body[offset + 2] << 16) | ((uint32_t)body[offset + 3] << 24));
    };
    if (exit_path) {
        D1PointerResult hit{};
        CHECK(session_ad1_pointer_move(binding, (int16_t)(dword(0x38fu) + 1),
                                       (int16_t)(dword(0x393u) + 1), &hit) == D1_OK);
        CHECK(hit.candidate == D1_CANDIDATE_EXIT);
        CHECK(session_ad1_click(binding, phase, hit.candidate, 1, &phase) == D1_OK && phase == 2u);
    } else {
        for (int tile = 0; tile < word(0x21u) && !completed; ++tile) {
            const int16_t target = word(0x30au + 2u * (size_t)tile);
            unsigned turns = 0;
            while (!completed && session_ad1_object(binding)->frame[tile] != target && turns++ < 100u) {
                int32_t turn_busy = 0;
                CHECK(native_ad1_sound_busy(&app, word(0x2fau), &turn_busy) == 0);
                for (unsigned wait = 0; turn_busy && wait < 800u; ++wait) {
                    CHECK(visit());
                    CHECK(native_ad1_sound_busy(&app, word(0x2fau), &turn_busy) == 0);
                }
                CHECK(!turn_busy);
                const size_t hit_offset = 0x147u + (size_t)tile * 16u;
                D1PointerResult hit{};
                CHECK(session_ad1_pointer_move(binding,
                    (int16_t)((dword(hit_offset) + dword(hit_offset + 8)) / 2),
                    (int16_t)((dword(hit_offset + 4) + dword(hit_offset + 12)) / 2), &hit) == D1_OK);
                CHECK(hit.candidate == D1_CANDIDATE_TILE);
                CHECK(session_ad1_click(binding, phase, hit.candidate, 1, &phase) == D1_OK);
                for (unsigned tick = 0; !completed && tick < 800u; ++tick) {
                    CHECK(visit());
                    const D1Object *object = session_ad1_object(binding);
                    if (object->state == D1_STATE_IDLE && object->moving[tile] == 0) break;
                }
            }
            CHECK(completed || session_ad1_object(binding)->frame[tile] == target);
        }
    }
    for (unsigned tick = 0; !completed && tick < 1600u; ++tick) CHECK(visit());
    CHECK(completed && phase == 0u && session_ad1_object(binding)->active == 0);
    LiveAudioChannelInfo channel{};
    if (std::memcmp(body + 0x2d9u, "NO SOUND", 9) != 0) {
        CHECK(live_audio_get_channel_info(app.live_audio, (uint16_t)word(0x2fau), &channel) == LIVE_AUDIO_OK);
        CHECK(!channel.loaded); /* phase 2 stopped record 0 */
    }
    if (std::memcmp(body + 0x345u, "NO SOUND", 9) != 0) {
        CHECK(live_audio_get_channel_info(app.live_audio, (uint16_t)word(0x366u), &channel) == LIVE_AUDIO_OK);
        if (exit_path) CHECK(channel.loaded && !channel.started); /* prepared win clip was never played */
        else {
            CHECK(!channel.loaded); /* WIN_SOUND waited, then stopped record 1 */
            CHECK(busy_waits > waits_before_row); /* each named win clip was observed playing */
        }
    }
    session_ad1_destroy(binding);
    /* Test isolation only: the original exit leaves the unplayed win clip
     * prepared. Do not claim an app teardown or hide its state above. */
    CHECK(live_audio_unload_sound(app.live_audio, (uint16_t)word(0x2fau)) == ACTION_SOUND_BACKEND_OK);
    CHECK(live_audio_unload_sound(app.live_audio, (uint16_t)word(0x366u)) == ACTION_SOUND_BACKEND_OK);
    return 0;
}

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
        size_t rows = 0, clips = 0, solved = 0, exited = 0, busy_waits = 0;
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
                CHECK(run_lifecycle(app, scene, row, info, false, busy_waits) == 0);
                ++solved;
                CHECK(run_lifecycle(app, scene, row, info, true, busy_waits) == 0);
                ++exited;
            }
            scene_resource_close(scene);
        }
        CHECK(rows == 11u && clips == 20u && solved == 11u && exited == 11u && busy_waits > 0u);
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
        /* Adapter host failures are explicit blockers, distinct from an absent
         * clip or unavailable output (NO_RESOURCE), which may continue silently. */
        const ActionSoundBackend real_backend = app.ad1_audio.backend;
        app.ad1_audio.backend.load_sound = [](void *, const ActionSoundAudioCommand *) {
            return ACTION_SOUND_BACKEND_ERROR;
        };
        CHECK(native_ad1_sound_prepare(&app, 0, shared_descriptor.data()) != 0);
        app.ad1_audio.backend = real_backend;
        app.ad1_audio.backend.unload_sound = [](void *, uint16_t) { return ACTION_SOUND_BACKEND_ERROR; };
        CHECK(native_ad1_sound_stop(&app, 0, shared_descriptor.data()) != 0);
        app.ad1_audio.backend = real_backend;
        CHECK(puzzle_sound_prepare(&peer, shared_descriptor.data(), shared_descriptor.size()) == PUZZLE_SOUND_OK);
        app.ad1_audio.backend.play_sound = [](void *, uint16_t) { return ACTION_SOUND_BACKEND_ERROR; };
        CHECK(native_ad1_sound_play(&app, (int16_t)shared_channel) != 0);
        app.ad1_audio.backend = real_backend;
        app.ad1_audio.backend.is_playing = [](void *, uint16_t, int *) { return ACTION_SOUND_BACKEND_ERROR; };
        shared_busy = 99;
        CHECK(native_ad1_sound_busy(&app, (int16_t)shared_channel, &shared_busy) != 0 && shared_busy == 99);
        app.ad1_audio.backend = real_backend;
        CHECK(live_audio_unload_sound(app.live_audio, shared_channel) == ACTION_SOUND_BACKEND_OK);
        CHECK(native_ad1_sound_prepare(nullptr, 0, nullptr) != 0);
        CHECK(native_ad1_sound_play(&app, -1) != 0);
        CHECK(native_ad1_sound_busy(&app, -1, nullptr) != 0);
        CHECK(live_audio_destroy(app.live_audio) == LIVE_AUDIO_OK);
        app.live_audio = nullptr;
        std::printf("D1 real-audio lifecycle: solved=%zu exited=%zu busy_wait_ticks=%zu\n", solved, exited, busy_waits);
        std::fclose(app.log);
        app.log = nullptr;
        std::printf("D1 app audio: rows=%zu clips=%zu nonzero_PCM=1 completion_gated=1 peak=%.6f output_device=none\n", rows, clips, peak);
    }
    return 0;
}
