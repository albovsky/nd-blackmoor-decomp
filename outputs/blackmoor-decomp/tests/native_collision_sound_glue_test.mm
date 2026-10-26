/* NATIVE18: direct component setup with owner-local S3450 D3 descriptors.
 * Actual native callbacks/live audio, muted offline only; no campaign claim. */
#define main blackmoor_app_entry_for_collision_test
#ifndef NATIVE_COLLISION_APP_SOURCE
#define NATIVE_COLLISION_APP_SOURCE "../src/blackmoor_app.mm"
#endif
#include NATIVE_COLLISION_APP_SOURCE
#undef main
#include <csignal>

#define CHECK(condition, message) do { if (!(condition)) { \
    std::fprintf(stderr, "CHECK failed: %s\n", message); return 1; } } while (0)

static int collision_target = -1;
static int collision_transitions = 0;
static int collision_sink_slot(void *, int16_t *slot) { *slot = 24; return 0; }
static int collision_sink_register(void *, int16_t, const char *) { return 0; }
static int collision_sink_load(void *, const char *, uint32_t *surface) { *surface = 1; return 0; }
static int collision_sink_surface(void *, int16_t, uint32_t) { return 0; }
static int collision_sink_release(void *, uint32_t) { return 0; }
static int collision_sink_slot_op(void *, int16_t) { return 0; }
static int collision_sink_idle(void *) { return 0; }
static int collision_sink_transition(void *, const CpzTransition *request)
{
    collision_target = request->scene;
    ++collision_transitions;
    return 0;
}

struct CollisionSoundFixture {
    NativeApp app{};
    std::vector<uint8_t> bytes;
    SceneResource *scene = nullptr;
    const uint8_t *body = nullptr;
    std::vector<int32_t> flags = std::vector<int32_t>(4096);
    CpzObject object{};
    CpzWorld world{};
    CpzHost host{};
    uint32_t phase = 0;
    unsigned completions = 0;
    uint64_t muted_frames = 0;
    int16_t word(size_t offset) const
    {
        const uint8_t *p = body + offset;
        return static_cast<int16_t>(p[0] | static_cast<uint16_t>(p[1] << 8));
    }
    bool visit()
    {
        CpzResult result{};
        const char *why = nullptr;
        const int status = cpz_step(&object, body, CPZ_BODY_BYTES, 2, phase, &world, &host, &result, &why);
        if (status != CPZ_OK) {
            std::fprintf(stderr, "collision kernel status=%d detail=%s\n", status, why != nullptr ? why : "none");
            return false;
        }
        phase = result.phase_after;
        completions += result.completed;
        return true;
    }
    bool render_audio(uint64_t frames)
    {
        LiveAudioOfflineStats stats{};
        if (live_audio_advance_offline(app.live_audio, frames, &stats, nullptr, 0) != LIVE_AUDIO_OK ||
            stats.frames != frames || stats.nonfinite_samples != 0 || stats.nonzero_samples != 0) return false;
        muted_frames += stats.frames;
        return true;
    }
    ~CollisionSoundFixture()
    {
        if (app.live_audio != nullptr) live_audio_destroy(app.live_audio);
        scene_resource_close(scene);
        game_resources_close(app.resources);
        if (app.log != nullptr) std::fclose(app.log);
    }
    bool initialize(const char *directory)
    {
        app.game_directory = directory;
        app.log = std::tmpfile();
        if (app.log == nullptr) return false;
        int external = 0;
        if (!game_ini_configuration(app.game_directory, &external, &app.closed_captioning)) return false;
        char error[256]{};
        app.resources = game_resources_open((app.game_directory + "/Ciftree").c_str(), external, error, sizeof error);
        if (app.resources == nullptr) return false;
        GameResourceBytes resource = GAME_RESOURCE_BYTES_INIT;
        if (!game_resources_load_bytes(app.resources, "S3450", &resource, error, sizeof error)) return false;
        bytes.assign(resource.bytes, resource.bytes + resource.length);
        game_resource_bytes_destroy(&resource);
        scene = scene_resource_open_memory(bytes.data(), bytes.size(), error, sizeof error);
        if (scene == nullptr) return false;
        for (size_t row = 0; row < scene_resource_action_count(scene); ++row) {
            SceneActionInfo action{};
            if (scene_resource_action_at(scene, row, &action) != SCENE_RESOURCE_OK) return false;
            if (action.type == SESSION_AD3_TYPE && action.typed_body_length == CPZ_BODY_BYTES) {
                body = action.typed_body;
                break;
            }
        }
        if (body == nullptr) return false;
        NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
        NSMutableDictionary *arguments = [[defaults volatileDomainForName:NSArgumentDomain] mutableCopy];
        if (arguments == nil) arguments = [NSMutableDictionary dictionary];
        arguments[@"BlackmoorAudioMuted"] = @YES;
        [defaults setVolatileDomain:arguments forName:NSArgumentDomain];
        LiveAudioConfig audio{};
        audio.game_directory = directory;
        audio.mode = MAC_AUDIO_MODE_OFFLINE;
        if (live_audio_create(&audio, &app.live_audio, error, sizeof error) != LIVE_AUDIO_OK) {
            std::fprintf(stderr, "collision offline audio: %s\n", error);
            return false;
        }
        app.session_tick_sample = 1000u;
        app.new_game.action_core.event_flags = flags.data();
        app.new_game.action_core.event_flag_count = flags.size();
        host.context = &app;
        host.alloc_slot = collision_sink_slot; host.register_slot = collision_sink_register;
        host.load_surface = collision_sink_load; host.set_slot_surface = collision_sink_surface;
        host.release_surface = collision_sink_release; host.release_slot = collision_sink_slot_op;
        host.mark_dirty = collision_sink_slot_op; host.view_origin = native_ad1_view_origin;
        host.clear_pending_item = collision_sink_idle;
        host.sound_prepare = native_ad3_sound_prepare; host.sound_stop = native_ad3_sound_stop;
        host.sound_play = native_ad3_sound_play; host.sound_busy = native_ad3_sound_busy;
        host.tick = native_ad1_tick;
        host.event_flag_invalid = native_ad1_event_flag_invalid;
        host.store_event_flag = native_ad1_store_event_flag;
        host.transition = collision_sink_transition;
        cpz_object_reset(&object);
        return true;
    }
};

static int completion_sound(CollisionSoundFixture &f)
{
    CHECK(f.visit() && f.phase == 1u, "real D3 phase0 initializes with production sound callbacks");
    LiveAudioChannelInfo move{};
    CHECK(live_audio_get_channel_info(f.app.live_audio, 8u, &move) == LIVE_AUDIO_OK,
          "actual move channel is inspectable");
    std::printf("COLLISION_AUDIO loaded=%u frames=%llu direct_setup=1\n", move.loaded,
                static_cast<unsigned long long>(move.frame_count));
    CHECK(move.loaded == 1u && move.frame_count > 0,
          "real D3 prepare must load Rock_Scrape06 instead of silently succeeding");
    CHECK(f.word(CPZ_OFFSET_SOUND_D + 0x21u) == 9 && f.word(0x2fbu) == 1,
          "installed S3450 has its named channel9 completion sound and one-second delay");
    /* Deliberately enter the solved component state. No grid solve, campaign
     * route, dependency bypass or replacement of the original body is claimed. */
    f.object.solved = 1;
    CHECK(f.visit() && f.object.state == CPZ_STATE_SOLVED, "solved component enters original delay path");
    CHECK(f.visit() && f.object.state == CPZ_STATE_WAIT_DELAY && f.object.deadline == 2000u,
          "kernel retains original one-second completion delay");
    f.app.session_tick_sample = 1999u;
    CHECK(f.visit() && f.object.state == CPZ_STATE_WAIT_DELAY && f.phase == 1u,
          "sound does not start before the delay deadline");
    LiveAudioChannelInfo win{};
    CHECK(live_audio_get_channel_info(f.app.live_audio, 9u, &win) == LIVE_AUDIO_OK && win.loaded == 0u,
          "final sound is not loaded before its original boundary");
    f.app.session_tick_sample = 2000u;
    CHECK(f.visit() && f.object.state == CPZ_STATE_WAIT_SOUND && f.phase == 1u,
          "deadline prepares and plays the original completion sound");
    int32_t busy = -1;
    CHECK(live_audio_get_channel_info(f.app.live_audio, 9u, &win) == LIVE_AUDIO_OK &&
          win.loaded == 1u && win.started == 1u && win.frame_count > 512u &&
          native_ad3_sound_busy(&f.app, 9, &busy) == 0 && busy == 1,
          "actual Rock_Hit_Short01 must be loaded, started and busy");
    CHECK(f.visit() && f.phase == 1u && f.completions == 0 && collision_transitions == 0,
          "kernel must wait while completion audio has not been consumed");
    CHECK(f.render_audio(256u) && native_ad3_sound_busy(&f.app, 9, &busy) == 0 && busy == 1 &&
          f.visit() && f.phase == 1u && f.completions == 0,
          "partial muted PCM consumption must not complete the puzzle");
    for (unsigned i = 0; busy != 0 && i < 800u; ++i) {
        CHECK(f.render_audio(4096u), "real completion PCM advances as finite muted frames");
        CHECK(native_ad3_sound_busy(&f.app, 9, &busy) == 0, "production callback observes natural completion");
    }
    CHECK(busy == 0 && live_audio_get_channel_info(f.app.live_audio, 9u, &win) == LIVE_AUDIO_OK &&
          win.loaded == 1u && win.finished == 1u && f.completions == 0,
          "natural playback completion remains loaded until the kernel unloads it");
    CHECK(f.visit() && f.phase == 2u && f.completions == 0 &&
          live_audio_get_channel_info(f.app.live_audio, 9u, &win) == LIVE_AUDIO_OK && win.loaded == 0u,
          "idle completion sound is unloaded before phase2 completion");
    CHECK(f.visit() && f.phase == 0u && f.completions == 1u && collision_transitions == 1 &&
          collision_target == f.word(0x2e2u), "phase2 finishes only after the real sound wait");
    const int16_t flag = f.word(0x2f8u);
    CHECK(flag >= 0 && static_cast<size_t>(flag) < f.flags.size() && f.flags[flag] == f.body[0x2fau],
          "real solved-block flag is applied at completion");
    CHECK(live_audio_get_channel_info(f.app.live_audio, 8u, &move) == LIVE_AUDIO_OK && move.loaded == 0u,
          "kernel finish stops its actual move-sound descriptor");
    std::printf("COLLISION_COMPLETION direct_setup=1 delay_ms=1000 busy_wait=1 natural_finish=1 target=%d muted_frames=%llu\n",
                collision_target, static_cast<unsigned long long>(f.muted_frames));
    return 0;
}

static int shared_channels(CollisionSoundFixture &f)
{
    const uint8_t *real = f.body + CPZ_OFFSET_SOUND_A;
    CHECK(native_ad3_sound_prepare(&f.app, real) == 0 && native_ad3_sound_play(&f.app, 8) == 0,
          "shared component starts the actual move clip");
    int32_t busy = -1;
    CHECK(native_ad3_sound_busy(&f.app, 8, &busy) == 0 && busy == 1, "real shared clip initially reports busy");
    std::vector<uint8_t> missing(real, real + PUZZLE_SOUND_RECORD_BYTES);
    std::memset(missing.data(), 0, 33u);
    const char absent[] = "NATIVE18_MISSING_RESOURCE";
    std::memcpy(missing.data(), absent, sizeof absent);
    CHECK(native_ad3_sound_prepare(&f.app, missing.data()) == 0, "missing native descriptor is an honest no-resource result");
    LiveAudioChannelInfo info{};
    CHECK(live_audio_get_channel_info(f.app.live_audio, 8u, &info) == LIVE_AUDIO_OK && info.loaded == 0u &&
          native_ad3_sound_play(&f.app, 8) == 0 && native_ad3_sound_busy(&f.app, 8, &busy) == 0 && busy == 0,
          "missing replacement must not replay the previous clip");
    ActionSoundBackend backend{};
    PuzzleSound other{};
    CHECK(live_audio_bind_backend(f.app.live_audio, &backend) == LIVE_AUDIO_OK &&
          puzzle_sound_init(&other, &backend) == PUZZLE_SOUND_OK &&
          puzzle_sound_prepare(&other, real, PUZZLE_SOUND_RECORD_BYTES) == PUZZLE_SOUND_OK,
          "another owner loads the actual descriptor in the shared provider");
    CHECK(native_ad3_sound_play(&f.app, 8) == 0 && native_ad3_sound_busy(&f.app, 8, &busy) == 0 && busy == 1,
          "D3 play must refresh stale missing-resource eligibility from the shared provider");
    CHECK(f.render_audio(256u), "shared PCM advances silently");
    CHECK(live_audio_unload_sound(f.app.live_audio, 8u) == ACTION_SOUND_BACKEND_OK &&
          native_ad3_sound_busy(&f.app, 8, &busy) == 0 && busy == 0 && native_ad3_sound_play(&f.app, 8) == 0,
          "external unload must make D3 idle and suppress stale play");
    CHECK(puzzle_sound_prepare(&other, real, PUZZLE_SOUND_RECORD_BYTES) == PUZZLE_SOUND_OK &&
          puzzle_sound_play(&other, 8u) == PUZZLE_SOUND_OK &&
          native_ad3_sound_busy(&f.app, 8, &busy) == 0 && busy == 1,
          "D3 busy must observe an external reload/play without a D3 prepare or play");
    CHECK(native_ad3_sound_stop(&f.app, real) == 0 &&
          live_audio_get_channel_info(f.app.live_audio, 8u, &info) == LIVE_AUDIO_OK && info.loaded == 0u &&
          native_ad3_sound_busy(&f.app, 8, &busy) == 0 && busy == 0,
          "D3 stop unloads the descriptor channel and reports idle");
    std::printf("COLLISION_SHARED direct_setup=1 missing_idle=1 external_play_refresh=1 external_busy_refresh=1 stopped=1\n");
    return 0;
}

static void collision_fixture_signal(int number)
{
    static const char prefix[] = "collision fixture/native signal failure number=";
    const char digits[] = {static_cast<char>('0' + number / 10), static_cast<char>('0' + number % 10), '\n'};
    (void)write(STDERR_FILENO, prefix, sizeof(prefix) - 1);
    (void)write(STDERR_FILENO, digits, sizeof(digits));
    _exit(128 + number);
}
int main(int argc, char **argv)
{
    std::signal(SIGBUS, collision_fixture_signal); std::signal(SIGSEGV, collision_fixture_signal);
    std::signal(SIGABRT, collision_fixture_signal); std::signal(SIGILL, collision_fixture_signal);
    @autoreleasepool {
        CHECK(argc == 3, "owner-local game directory and named component required");
        CollisionSoundFixture fixture;
        CHECK(fixture.initialize(argv[1]), "owner-local D3 descriptor/offline provider initializes");
        if (std::strcmp(argv[2], "completion") == 0) return completion_sound(fixture);
        if (std::strcmp(argv[2], "shared") == 0) return shared_channels(fixture);
        CHECK(false, "unknown collision component");
    }
}
