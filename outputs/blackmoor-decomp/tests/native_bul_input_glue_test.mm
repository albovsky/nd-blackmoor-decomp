/* NATIVE25: actual BOOT/new-game and the original S1261 Bul row.
 * Labeled direct component entry and supported --rand-seed1 startup replay.
 * Only normal pointer/update/render/offline-audio calls advance the game.
 * No story, board, phase, candidate, ready or midgame RNG writes; no GUI/device.
 * This bounded flow leaves normally; full win/loss and harder row3 are unverified. */
#define main blackmoor_app_entry_for_bul_test
#ifndef NATIVE_BUL_APP_SOURCE
#define NATIVE_BUL_APP_SOURCE "../src/blackmoor_app.mm"
#endif
#include NATIVE_BUL_APP_SOURCE
#undef main

#define CHECK(condition, message) do { if (!(condition)) { \
    std::fprintf(stderr, "CHECK failed: %s\n", message); return 1; } } while (0)

static int16_t bul_word(const uint8_t *bytes)
{
    return static_cast<int16_t>(static_cast<uint16_t>(bytes[0] | (bytes[1] << 8)));
}

struct BulFixture {
    NativeApp app{};
    std::array<uint8_t, BUL_BODY_BYTES> body{};
    size_t row = SIZE_MAX;
    uint8_t subtype = 0u;
    uint32_t now = 1000u;
    uint64_t muted_frames = 0u;
    ~BulFixture() { cleanup(&app); }
    const BulObject *object() const { return session_ada_object(app.ada); }
    void print_log_tail()
    {
        if (app.log == nullptr) return;
        std::fflush(app.log); std::rewind(app.log);
        char line[1024]{};
        std::vector<std::string> lines;
        while (std::fgets(line, sizeof line, app.log) != nullptr) lines.emplace_back(line);
        for (size_t i = lines.size() > 12u ? lines.size() - 12u : 0u; i < lines.size(); ++i)
            std::fprintf(stderr, "%s", lines[i].c_str());
    }
    bool initialize(const char *directory)
    {
        NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
        NSMutableDictionary *arguments = [[defaults volatileDomainForName:NSArgumentDomain] mutableCopy];
        if (arguments == nil) arguments = [NSMutableDictionary dictionary];
        arguments[@"BlackmoorAudioMuted"] = @YES;
        [defaults setVolatileDomain:arguments forName:NSArgumentDomain];
        app.game_directory = directory;
        app.log = std::tmpfile();
        app.bar_missing = true;
        app.scene_runtime_enabled = true;
        app.condition_rand_seed = 1u;
        app.condition_rand_seed_set = true; /* Existing --rand-seed replay configuration. */
        if (app.log == nullptr || session_input_init(&app.input_state) != SESSION_INPUT_OK) return false;
        int external = 0;
        char error[256]{};
        if (!game_ini_configuration(app.game_directory, &external, &app.closed_captioning)) return false;
        app.closed_captioning = 1u; /* Supported user preference. */
        app.resources = game_resources_open((app.game_directory + "/Ciftree").c_str(), external, error, sizeof error);
        GameResourceBytes boot = GAME_RESOURCE_BYTES_INIT;
        if (app.resources == nullptr || !game_resources_load_bytes(app.resources, "BOOT", &boot, error, sizeof error)) return false;
        app.boot = engine_boot_open_memory(boot.bytes, boot.length, error, sizeof error);
        game_resource_bytes_destroy(&boot);
        if (app.boot == nullptr || world_init_cold_zero_event_flags(&app.new_game.action_core) != WORLD_INIT_OK ||
            !load_viewport(&app) || !initialize_caption_runtime(&app) || !initialize_new_game(&app, now) ||
            !clear_before_scene_entry(&app, now)) return false;
        LiveAudioConfig audio{};
        audio.game_directory = directory; audio.mode = MAC_AUDIO_MODE_OFFLINE;
        if (live_audio_create(&audio, &app.live_audio, error, sizeof error) != LIVE_AUDIO_OK) {
            std::fprintf(stderr, "Bul offline audio initialization: %s\n", error); return false;
        }
        app.offline_audio_frames_per_update = 1u;
        app.framebuffer.resize(640u * 480u * 4u);
        app.selector_entry_valid = true;
        app.selector_entry_frame = 0; /* Labeled direct scene/selector entry. */
        app.selector_entry_scroll = 0;
        if (!load_scene(&app, 1261)) return false;
        const ActionFamily28Rect view = {app.scene_destination.left, app.scene_destination.top,
                                         app.scene_destination.right, app.scene_destination.bottom};
        return session_exit_init(&app.exit_state, &view) == SESSION_EXIT_OK && create_native_scene_session(&app);
    }
    bool tick(uint64_t frames = 0u)
    {
        if (frames != 0u) {
            LiveAudioOfflineStats stats{};
            if (live_audio_advance_offline(app.live_audio, frames, &stats, nullptr, 0u) != LIVE_AUDIO_OK ||
                stats.frames != frames || stats.nonfinite_samples != 0u || stats.nonzero_samples != 0u) return false;
            muted_frames += stats.frames;
        }
        uint32_t rate = 0u, channels = 0u;
        if (live_audio_offline_format(app.live_audio, &rate, &channels) != LIVE_AUDIO_OK || rate == 0u) return false;
        now = 1000u + static_cast<uint32_t>(live_audio_offline_frames_rendered(app.live_audio) * 1000u / rate);
        update(&app, now);
        if (app.failure || app.session_block_reported) { print_log_tail(); return false; }
        return true;
    }
    bool advance_to(uint32_t target)
    {
        uint32_t rate = 0u, channels = 0u;
        if (target < 1000u || live_audio_offline_format(app.live_audio, &rate, &channels) != LIVE_AUDIO_OK) return false;
        const uint64_t goal = (static_cast<uint64_t>(target - 1000u) * rate + 999u) / 1000u;
        const uint64_t rendered = live_audio_offline_frames_rendered(app.live_audio);
        return tick(goal > rendered ? goal - rendered : 0u);
    }
    void point_for(size_t rectangle, int32_t *x, int32_t *y) const
    {
        const uint8_t *r = body.data() + rectangle;
        *x = (read_i32_le(r) + read_i32_le(r + 8u)) / 2 +
            app.scene_destination.left - app.cursor_provider.hot_x;
        *y = (read_i32_le(r + 4u) + read_i32_le(r + 12u)) / 2 +
            app.scene_destination.top - app.nav.scroll - app.cursor_provider.hot_y;
    }
    bool hover(size_t rectangle)
    {
        int32_t x = 0, y = 0;
        point_for(rectangle, &x, &y);
        pointer(&app, BLACKMOOR_POINTER_MOVE, x, y, 0u);
        return tick();
    }
    bool release(bool move_to_pass = false)
    {
        pointer(&app, BLACKMOOR_POINTER_DOWN, app.pointer_x, app.pointer_y, 0u);
        if (!tick()) return false;
        int32_t x = 0, y = 0;
        if (move_to_pass) point_for(BUL_B_BUTTON_RECT + 16u, &x, &y);
        pointer(&app, BLACKMOOR_POINTER_MOVE, x, y, 0u); /* No intervening scan. */
        pointer(&app, BLACKMOOR_POINTER_UP, 0, 0, 0u); /* Original UP ignores these coordinates. */
        return tick();
    }
    bool wait_sound(uint16_t channel, uint64_t generation)
    {
        for (unsigned step = 0u; step < 1200u; ++step) {
            LiveAudioPlaybackCursor cursor{};
            if (live_audio_get_playback_cursor(app.live_audio, channel, generation, &cursor) != LIVE_AUDIO_OK) return false;
            if (!cursor.playing) return cursor.source_frames == cursor.source_frame_count && cursor.source_frames > 0u;
            if (!tick(2048u)) return false;
        }
        return false;
    }
    bool wait_caption(uint64_t generation, int32_t next_state)
    {
        for (unsigned step = 0u; step < 1200u; ++step) {
            LiveAudioPlaybackCursor cursor{};
            if (live_audio_get_playback_cursor(app.live_audio, 11u, generation, &cursor) != LIVE_AUDIO_OK) return false;
            if (!cursor.playing)
                return cursor.source_frames == cursor.source_frame_count && cursor.source_frames > 0u &&
                       object()->state == next_state;
            if (object()->state != BUL_STATE_CAPTION_WAIT || !tick(2048u)) return false;
        }
        return false;
    }
};

static int started_sound(BulFixture &f, uint16_t channel, int16_t first, int16_t second,
                         LiveAudioPlaybackCursor *cursor)
{
    LiveAudioChannelInfo info{};
    CHECK(live_audio_get_channel_info(f.app.live_audio, channel, &info) == LIVE_AUDIO_OK &&
          live_audio_get_playback_cursor(f.app.live_audio, channel, 0u, cursor) == LIVE_AUDIO_OK &&
          info.loaded && info.started && cursor->loaded && cursor->started && cursor->playing &&
          cursor->source_frame_count > 0u && info.control_word == 1u && info.volume_category == 2u &&
          info.first_percent == first && info.second_percent == second,
          "actual Bul audio starts decoded source with its original channel, control and independent gains");
    return 0;
}

static int start_bul(BulFixture &f)
{
    CHECK(f.tick(), "first actual S1261 visit runs the eligible original Bul row");
    CHECK(f.app.current_scene_id == 1261 && f.object() && f.object()->active &&
          f.object()->row == 2 && session_ada_registered(f.app.ada),
          "labeled direct S1261 entry naturally activates original row2 without story injection");
    f.row = static_cast<size_t>(f.object()->row);
    SceneActionInfo action{};
    SceneActionRuntimeState runtime{}, other{};
    CHECK(native_action_at(&f.app, f.row, &action) == SCENE_RESOURCE_OK && action.type == SESSION_ADA_TYPE &&
          action.typed_body_length == BUL_BODY_BYTES &&
          scene_session_get_action_state(f.app.session, f.row, &runtime) == SCENE_SESSION_OK && runtime.phase == 1u &&
          scene_session_get_action_state(f.app.session, 3u, &other) == SCENE_SESSION_OK && other.phase == 0u,
          "active canonical row owns the original complete body while its difficulty alternative stays inactive");
    std::memcpy(f.body.data(), action.typed_body, f.body.size());
    f.subtype = action.subtype;
    CHECK(bul_word(f.body.data() + BUL_B_POSITIONS) == 12 && bul_word(f.body.data() + BUL_B_PIECES) == 4 &&
          f.body[BUL_B_TWO_PLAYERS] == 0u && f.body[BUL_B_SMART] == 0u &&
          f.object()->pos_player == 1 && f.object()->pos_computer == 12 &&
          f.object()->score_player == 0 && f.object()->score_computer == 0 &&
          f.object()->state == BUL_STATE_CAPTION_WAIT && f.object()->next_state == BUL_STATE_IDLE,
          "original normal-difficulty initial board enters its genuine greeting wait");
    LiveAudioPlaybackCursor greeting{};
    CHECK(started_sound(f, 11u, 85, 85, &greeting) == 0 && f.object()->cap_channel == 11 &&
          f.object()->cap_1a7 == 2 && f.object()->cap_1a9 == 1 && f.object()->cap_1ab == 1 &&
          f.object()->cap_1ad == 1 && f.object()->cap_1b1 == 85 && f.object()->cap_1b3 == 85,
          "native caption fields serialize into the real original greeting descriptor despite native ABI padding");
    CHECK(f.tick() && f.object()->state == BUL_STATE_CAPTION_WAIT &&
          f.wait_caption(greeting.generation, BUL_STATE_IDLE),
          "greeting stays in caption wait until real channel11 reaches natural source completion");
    std::printf("BUL_START scene=1261 row=%zu subtype=%u direct_component_entry=1 seed=1 greeting_frames=%llu greeting_completed=1\n",
        f.row, f.subtype, static_cast<unsigned long long>(greeting.source_frame_count));
    std::fflush(stdout);
    return 0;
}

static int first_legal_roll(BulFixture &f)
{
    CHECK(f.hover(BUL_B_BUTTON_RECT), "real roll pointer move reaches the actual app cascade");
    SceneSessionPointerResult pointer_result{};
    CHECK(scene_session_get_pointer_result(f.app.session, &pointer_result) == SCENE_SESSION_OK,
          "actual roll hover exposes the session input boundary");
    std::printf("BUL_HOVER consume=%d scan=%d candidate=%d cursor=%d/%d pending=%d\n",
        pointer_result.consume_status, pointer_result.scan_status, f.app.input_state.candidate,
        f.app.nav_cursor.index, f.app.nav_cursor.variant, f.object()->pending_button);
    CHECK(pointer_result.consume_status == SESSION_INPUT_OK && pointer_result.scan_status == SESSION_INPUT_OK &&
          f.app.input_state.candidate == BUL_CANDIDATE_BUTTON && f.app.nav_cursor.index == 0x16 &&
          f.app.nav_cursor.variant == 1 && f.object()->pending_button == 0,
          "post-ACT Bul hover publishes its actual candidate/cursor without priority-path refusal");
    const uint32_t shared_before = f.app.condition_rand.holdrand;
    CHECK(f.release() && f.object()->anim_active == 1 && f.object()->button_kind == 0 &&
          f.object()->button_down == 1 && f.object()->state == BUL_STATE_IDLE &&
          f.app.input_state.candidate == -1 && f.app.condition_rand.holdrand == shared_before,
          "same-tick move-off release starts the retained legal roll before the later scan clears its candidate");
    LiveAudioPlaybackCursor button{};
    CHECK(started_sound(f, 9u, 85, 85, &button) == 0, "real roll button starts channel9");
    const uint32_t animation_deadline = f.object()->anim_deadline;
    CHECK(f.advance_to(animation_deadline) && f.object()->state == BUL_STATE_IDLE && f.object()->button_down == 1 &&
          f.advance_to(animation_deadline + 1u) && f.object()->state == BUL_STATE_PICK_MOVES &&
          f.object()->button_down == 0 && f.tick() && f.object()->state == BUL_STATE_MOVING && f.object()->step == 0,
          "original strict button deadline and normal render retire animation before the move pick");
    uint32_t shared_after = shared_before;
    for (unsigned draw = 0u; draw < 8u; ++draw) shared_after = shared_after * 214013u + 2531011u;
    const int16_t moves = f.object()->moves;
    CHECK(moves >= 1 && moves <= 5 && f.app.condition_rand.holdrand == shared_after,
          "legal first roll consumes exactly eight draws from the already-running shared CRT stream");
    CHECK(f.advance_to(f.object()->deadline_16e) && f.object()->state == BUL_STATE_WAIT &&
          f.object()->step == 1 && f.object()->pos_player == 2 && f.object()->pos_computer == 12,
          "actual first legal movement advances the player marker once at the original move deadline");
    LiveAudioPlaybackCursor step{};
    CHECK(started_sound(f, 8u, 100, 100, &step) == 0, "real movement starts the original step channel8");
    for (unsigned i = 0u; i < 200u && !(f.object()->state == BUL_STATE_IDLE && f.object()->mode == 1); ++i)
        CHECK(f.tick(2400u), "bounded ordinary updates complete the first player movement");
    CHECK(f.object()->state == BUL_STATE_IDLE && f.object()->mode == 1 && f.object()->anim_active == 0 &&
          f.object()->step == moves && f.object()->pos_player == 1 + moves &&
          f.object()->score_player == 0 && f.object()->score_computer == 0 &&
          f.app.condition_rand.holdrand == shared_after,
          "all rolled movement completes naturally before another legal player gesture");
    LiveAudioPlaybackCursor last_step{};
    CHECK(live_audio_get_playback_cursor(f.app.live_audio, 8u, 0u, &last_step) == LIVE_AUDIO_OK &&
          f.wait_sound(8u, last_step.generation), "actual movement sound completes without fake idle");
    std::printf("BUL_ROLL moves=%d player=%d shared_draws=8 button_frames=%llu first_step_frames=%llu\n",
        moves, f.object()->pos_player, static_cast<unsigned long long>(button.source_frame_count),
        static_cast<unsigned long long>(step.source_frame_count));
    return 0;
}

static int retained_button_and_leave(BulFixture &f)
{
    CHECK(start_bul(f) == 0 && first_legal_roll(f) == 0, "genuine greeting and first legal roll precede retained-release case");
    CHECK(f.hover(BUL_B_BUTTON_RECT) && f.object()->pending_button == 0 &&
          f.app.input_state.candidate == BUL_CANDIDATE_BUTTON && f.release(true) &&
          f.object()->anim_active == 1 && f.object()->button_kind == 0 && f.object()->pending_button == 0,
          "a MOVE onto the now-legal pass button before UP cannot replace the retained roll button");
    bool computer_seen = false;
    for (unsigned i = 0u; i < 1600u; ++i) {
        computer_seen = computer_seen || f.object()->mode >= 2;
        if (computer_seen && f.object()->active && f.object()->mode < 2 &&
            f.object()->state == BUL_STATE_IDLE && f.object()->anim_active == 0) break;
        CHECK(f.tick(2400u), "bounded normal updates run the second roll and actual computer response");
    }
    CHECK(computer_seen && f.object()->active && f.object()->mode < 2 &&
          f.object()->state == BUL_STATE_IDLE && f.object()->anim_active == 0 && f.object()->finish_kind == 0,
          "unchanged controller and AI naturally return a legal player turn for leaving");
    CHECK(f.hover(BUL_B_FINISH_RECT) && f.app.input_state.candidate == BUL_CANDIDATE_FINISH &&
          f.app.nav_cursor.index == 9 && f.app.nav_cursor.variant == 1,
          "actual finish rectangle publishes its distinct cursor and retained candidate");
    const int16_t slot = f.object()->slot;
    const int32_t event_before = f.app.new_game.event_flags[1969u];
    const uint64_t generation = scene_session_scene_generation(f.app.session);
    CHECK(f.release() && f.object()->state == BUL_STATE_CAPTION_WAIT &&
          f.object()->next_state == BUL_STATE_EXIT_DELAY && f.object()->finish_kind == 0,
          "actual accepted finish release starts its real leave voice and original exit-delay order");
    LiveAudioPlaybackCursor finish{};
    SceneTransitionRequest pending{};
    SceneActionRuntimeState runtime{};
    CHECK(started_sound(f, 11u, 85, 85, &finish) == 0 && f.tick() &&
          f.object()->state == BUL_STATE_CAPTION_WAIT && !scene_session_get_pending_transition(f.app.session, &pending) &&
          f.wait_caption(finish.generation, BUL_STATE_EXIT_DELAY),
          "real finish voice completes before exit delay and cannot become a synthetic idle completion");
    if (f.now < f.object()->deadline_16e)
        CHECK(f.advance_to(f.object()->deadline_16e), "natural offline time reaches the original exit-delay deadline");
    else
        CHECK(f.tick(), "next original visit processes the elapsed exit delay");
    CHECK(scene_session_get_action_state(f.app.session, f.row, &runtime) == SCENE_SESSION_OK && runtime.phase == 2u &&
          !scene_session_get_pending_transition(f.app.session, &pending) && f.tick(),
          "real leave enters phase2 before applying its original transition and cleanup");
    CHECK(scene_session_get_pending_transition(f.app.session, &pending) && pending.target_scene == 1255 &&
          pending.opaque_words[0] == 0 && pending.opaque_words[1] == 0 && pending.opaque_words[2] == 1 &&
          pending.opaque_dwords[0] == 0 && pending.opaque_dwords[1] == 0 && pending.opaque_dwords[2] == 0 &&
          f.app.exit_state.g.game_state == SESSION_EXIT_STATE_EXIT && f.app.exit_state.g.scene_request == 1255 &&
          scene_session_get_action_state(f.app.session, f.row, &runtime) == SCENE_SESSION_OK &&
          runtime.completed == (f.subtype == 1u ? 1u : 0u) && !f.object()->active &&
          !session_ada_registered(f.app.ada) && f.object()->row == -1 && f.object()->slot == -1 &&
          f.object()->surface == 0u && !f.app.ada_slot_used[static_cast<size_t>(slot)] &&
          f.app.start_flag_5bb1ca == 1 && f.app.new_game.event_flags[1969u] == event_before,
          "actual leave block requests S1255, preserves the win event and retires its surface/slot through generic completion");
    LiveAudioChannelInfo step{}, roll{}, pass{}, caption{};
    CHECK(live_audio_get_channel_info(f.app.live_audio, 8u, &step) == LIVE_AUDIO_OK && step.loaded &&
          live_audio_get_channel_info(f.app.live_audio, 9u, &roll) == LIVE_AUDIO_OK && !roll.loaded &&
          live_audio_get_channel_info(f.app.live_audio, 10u, &pass) == LIVE_AUDIO_OK && !pass.loaded &&
          live_audio_get_channel_info(f.app.live_audio, 11u, &caption) == LIVE_AUDIO_OK && caption.loaded,
          "phase2 stops the two real button descriptors while retaining step and completed caption channel ownership");
    for (unsigned i = 0u; i < 40u && f.app.current_scene_id == 1261; ++i)
        CHECK(f.tick(2400u), "actual exit/load updates apply the accepted leave transition");
    CHECK(f.app.current_scene_id == 1255 && scene_session_scene_generation(f.app.session) > generation,
          "real transition handoff loads original S1255 without a fabricated exit scene");
    std::printf("BUL_LEAVE retained_button=1 computer_response=1 finish_frames=%llu target=1255 cleanup=1 loaded=1 full_win_unverified=1 harder_row3_unverified=1 muted_frames=%llu\n",
        static_cast<unsigned long long>(finish.source_frame_count), static_cast<unsigned long long>(f.muted_frames));
    return 0;
}

int main(int argc, char **argv)
{
    @autoreleasepool {
        CHECK(argc == 3, "owner-local game directory and bounded Bul case required");
        BulFixture fixture;
        const bool initialized = fixture.initialize(argv[1]);
        if (!initialized) fixture.print_log_tail();
        CHECK(initialized, "actual BOOT/new-game labeled direct S1261 component initializes");
        int result = 1;
        if (std::strcmp(argv[2], "voice") == 0) result = start_bul(fixture);
        else if (std::strcmp(argv[2], "leave") == 0) result = retained_button_and_leave(fixture);
        else std::fprintf(stderr, "CHECK failed: unknown bounded Bul case\n");
        if (result != 0) fixture.print_log_tail();
        return result;
    }
}
