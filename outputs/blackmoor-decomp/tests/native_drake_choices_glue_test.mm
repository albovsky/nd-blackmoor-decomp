/* Drake hook0: original BOOT/new-game and labeled direct S1087 row0.
 * Actual non-CEL component plus pointer-selected response and following scene.
 * Supported seed1 startup replay; no story, inventory, row, response, candidate
 * or midgame RNG injection. No campaign, window, output device or x86 claim. */
#define main blackmoor_app_entry_for_drake_choices_test
#ifndef NATIVE_DRAKE_CHOICES_APP_SOURCE
#define NATIVE_DRAKE_CHOICES_APP_SOURCE "../src/blackmoor_app.mm"
#endif
#include NATIVE_DRAKE_CHOICES_APP_SOURCE
#undef main

#define CHECK(condition, message) do { if (!(condition)) { \
    std::fprintf(stderr, "CHECK failed: %s\n", message); return 1; } } while (0)

struct DrakeChoiceFixture {
    NativeApp app{};
    AutoText *expected_convo = nullptr;
    uint32_t now = 1000u;
    uint64_t muted_frames = 0u;
    ~DrakeChoiceFixture() { autotext_close(expected_convo); cleanup(&app); }

    void print_log_tail()
    {
        if (!app.log) return;
        std::fflush(app.log); std::rewind(app.log);
        char line[1024]{};
        std::vector<std::string> lines;
        while (std::fgets(line, sizeof line, app.log)) lines.emplace_back(line);
        for (size_t i = lines.size() > 12u ? lines.size() - 12u : 0u; i < lines.size(); ++i)
            std::fprintf(stderr, "%s", lines[i].c_str());
    }

    bool initialize(const char *directory)
    {
        NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
        NSMutableDictionary *arguments = [[defaults volatileDomainForName:NSArgumentDomain] mutableCopy];
        if (!arguments) arguments = [NSMutableDictionary dictionary];
        arguments[@"BlackmoorAudioMuted"] = @YES;
        [defaults setVolatileDomain:arguments forName:NSArgumentDomain];
        app.game_directory = directory;
        app.log = std::tmpfile();
        app.bar_missing = true;
        app.scene_runtime_enabled = true;
        app.condition_rand_seed = 1u;
        app.condition_rand_seed_set = true; /* Existing --rand-seed replay configuration. */
        if (!app.log || session_input_init(&app.input_state) != SESSION_INPUT_OK) return false;
        int external = 0;
        char error[256]{};
        if (!game_ini_configuration(app.game_directory, &external, &app.closed_captioning)) return false;
        app.closed_captioning = true; /* Supported user preference. */
        app.resources = game_resources_open((app.game_directory + "/Ciftree").c_str(), external, error, sizeof error);
        GameResourceBytes boot = GAME_RESOURCE_BYTES_INIT;
        if (!app.resources || !game_resources_load_bytes(app.resources, "BOOT", &boot, error, sizeof error)) return false;
        app.boot = engine_boot_open_memory(boot.bytes, boot.length, error, sizeof error);
        game_resource_bytes_destroy(&boot);
        if (!app.boot || world_init_cold_zero_event_flags(&app.new_game.action_core) != WORLD_INIT_OK ||
            !load_viewport(&app) || !initialize_caption_runtime(&app) || !initialize_new_game(&app, now)) return false;
        GameResourceBytes convo = GAME_RESOURCE_BYTES_INIT;
        if (!game_resources_load_bytes(app.resources, "CONVO", &convo, error, sizeof error)) {
            std::fprintf(stderr, "Drake independent CONVO load: %s\n", error); return false;
        }
        const int text_status = autotext_open_memory(convo.bytes, convo.length, 0, &expected_convo, error, sizeof error);
        game_resource_bytes_destroy(&convo);
        if (text_status != AUTOTEXT_OK || autotext_entry_count(expected_convo) != 1244u) {
            std::fprintf(stderr, "Drake independent CONVO status=%d entries=%zu detail=%s\n",
                text_status, autotext_entry_count(expected_convo), error); return false;
        }
        LiveAudioConfig audio{};
        audio.game_directory = directory; audio.mode = MAC_AUDIO_MODE_OFFLINE;
        if (live_audio_create(&audio, &app.live_audio, error, sizeof error) != LIVE_AUDIO_OK) {
            std::fprintf(stderr, "Drake offline audio initialization: %s\n", error); return false;
        }
        app.offline_audio_frames_per_update = 1u;
        app.framebuffer.resize(640u * 480u * 4u);
        app.selector_entry_valid = true;
        app.selector_entry_frame = 0;
        app.selector_entry_scroll = 0;
        if (!load_scene(&app, 1087)) {
            std::fprintf(stderr, "Drake direct-entry scene load failed\n"); return false;
        }
        const ActionFamily28Rect view = {app.scene_destination.left, app.scene_destination.top,
                                         app.scene_destination.right, app.scene_destination.bottom};
        return session_exit_init(&app.exit_state, &view) == SESSION_EXIT_OK && create_native_scene_session(&app);
    }

    bool render_audio(uint64_t frames)
    {
        if (frames) {
            LiveAudioOfflineStats stats{};
            if (live_audio_advance_offline(app.live_audio, frames, &stats, nullptr, 0u) != LIVE_AUDIO_OK ||
                stats.frames != frames || stats.nonfinite_samples || stats.nonzero_samples) return false;
            muted_frames += stats.frames;
        }
        return true;
    }

    bool tick(uint64_t frames = 0u)
    {
        if (!render_audio(frames)) return false;
        uint32_t rate = 0u, channels = 0u;
        if (live_audio_offline_format(app.live_audio, &rate, &channels) != LIVE_AUDIO_OK || !rate) return false;
        now = 1000u + static_cast<uint32_t>(live_audio_offline_frames_rendered(app.live_audio) * 1000u / rate);
        update(&app, now);
        if (app.failure || app.session_block_reported) { print_log_tail(); return false; }
        return true;
    }
};

static int original_row(DrakeChoiceFixture &f, ActionFamily3fDecoded *decoded)
{
    SceneActionInfo row{};
    SceneActionRuntimeState state{};
    CHECK(f.app.current_scene_id == 1087 &&
          scene_resource_action_at(f.app.scene, 0u, &row) == SCENE_RESOURCE_OK &&
          row.type == SESSION_A3F_TYPE && row.dependency_count == 0u &&
          action_family_3f_decode(row.raw_body, row.raw_body_length, decoded) == ACTION_FAMILY_3F_OK &&
          decoded->option_44 == 0u && decoded->option_45 == 0u &&
          decoded->primary_count == 0 && decoded->secondary_count == 0 && decoded->word_47 == 9999u,
          "original S1087 row0 is naturally eligible hook0/0 non-CEL with no primary/secondary entries");
    CHECK(scene_session_get_action_state(f.app.session, 0u, &state) == SCENE_SESSION_OK &&
          state.phase == 0u && !state.completed && f.app.condition_rand.holdrand == 1u,
          "fresh direct-entry executor and supported startup CRT seed remain untouched");
    return 0;
}

static int default_responses(DrakeChoiceFixture &f, const Convo3fManager *manager)
{
    const char *keys[] = {"NDC08d", "NMD62", "NDE90"};
    const int16_t scenes[] = {1061, 1062, 1092}; /* seed1 -> CRT41 -> remainder2. */
    CHECK(manager && manager->response_count == 3,
          "fresh Drake world offers the two original A topics followed by the one B response");
    CHECK(f.app.new_game.event_flags[1519] == 0 && f.app.new_game.event_flags[1529] == 0,
          "default unasked topics come from untouched fresh-world event predicates");
    for (size_t i = 0u; i < 3u; ++i) {
        const uint8_t *text = nullptr;
        size_t raw = 0u, length = 0u;
        CHECK(autotext_lookup(f.expected_convo, reinterpret_cast<const uint8_t *>(keys[i]),
                  std::strlen(keys[i]), &text, &raw, &length) == AUTOTEXT_OK &&
              text && length && length < CONVO3F_TEXT_BYTES,
              "every actual Drake key resolves in independently loaded original CONVO");
        std::array<uint8_t, CONVO3F_TEXT_BYTES> owned{};
        std::memcpy(owned.data(), text, length);
        const Convo3fResponse &response = manager->responses[i];
        CHECK(std::memcmp(response.text, owned.data(), owned.size()) == 0 &&
              std::strcmp(reinterpret_cast<const char *>(response.name), keys[i]) == 0 &&
              response.scene == scenes[i] && response.word_23 == 0 && response.word_25 == 0 &&
              response.word_27 == 1 && response.dword_29 == 0 && response.dword_2d == 0 &&
              response.dword_31 == 1 && response.event_index == -1 && !response.event_value && response.word_38 == 2,
              "owned real text, exact mixed-case sound key and transition metadata preserve A/A/B order");
    }
    return 0;
}

static int preview_purity(DrakeChoiceFixture &f)
{
    ActionFamily3fDecoded decoded{};
    CHECK(original_row(f, &decoded) == 0, "original direct-entry Drake row is fresh");
    const auto flags = f.app.new_game.event_flags;
    const auto inventory = f.app.new_game.inventory_presence;
    const auto framebuffer = f.app.framebuffer;
    for (unsigned repeat = 0u; repeat < 4u; ++repeat) {
        Convo3fManager preview{};
        Convo3fLayoutRequest request{};
        CHECK(session_a3f_preview_layout(f.app.a3f, 0u, &preview, &request) == CONVO3F_OK &&
              default_responses(f, &preview) == 0 && request.response_count == 3 &&
              native_conversation_choices_validate(&request, 1, &f.app.captions.fonts,
                  &f.app.captions.geometry, &f.app.captions.pixel_format) == CAPTION_OK,
              "real hook0 preview resolves original owned CONVO text and validates its caption layout");
        CHECK(f.app.condition_rand.holdrand == 1u && f.app.new_game.event_flags == flags &&
              f.app.new_game.inventory_presence == inventory && f.app.framebuffer == framebuffer &&
              session_a3f_response_count(f.app.a3f) == 0 && !f.app.a3f_caption.ready,
              "repeated previews preserve shared CRT, story, inventory, live manager and visible surfaces");
    }
    LiveAudioChannelInfo voice{};
    SceneActionRuntimeState state{};
    CHECK(scene_session_get_action_state(f.app.session, 0u, &state) == SCENE_SESSION_OK &&
          state.phase == 0u && !state.completed &&
          live_audio_get_channel_info(f.app.live_audio, 12u, &voice) == LIVE_AUDIO_OK && !voice.loaded && !voice.started,
          "pure Drake previews execute no row and load no source voice");
    std::printf("DRAKE_CHOICES_PREVIEW direct_entry=1087 row=0 hooks=0,0 repeats=4 live_seed=1 responses=3 B_scene=1092\n");
    return 0;
}

static int pointer_follow(DrakeChoiceFixture &f)
{
    ActionFamily3fDecoded decoded{};
    CHECK(original_row(f, &decoded) == 0, "original direct-entry Drake row is fresh");
    CHECK(f.tick(), "naturally eligible S1087 hook0 row starts");
    const Convo3fManager *manager = session_a3f_manager(f.app.a3f);
    CHECK(default_responses(f, manager) == 0 && f.app.condition_rand.holdrand == 2745024u &&
          manager->row == 0 && manager->type == SESSION_A3F_TYPE && manager->sub_state == 4u &&
          !f.app.cel_reader_running && f.app.a3f_caption.ready && f.app.a3f_caption.result.response_count == 3,
          "actual phase0 consumes one shared CRT draw41 and builds the original non-CEL caption choices");
    LiveAudioPlaybackCursor voice{};
    CHECK(live_audio_get_playback_cursor(f.app.live_audio, 12u, 0u, &voice) == LIVE_AUDIO_OK &&
          voice.loaded && voice.started && voice.playing && voice.position_valid && voice.source_frame_count > 0u,
          "actual original non-CEL source voice starts on channel12 with a valid native source cursor");
    const uint64_t generation = voice.generation;
    bool finished = false;
    for (unsigned step = 0u; step < 900u && !finished; ++step) {
        CHECK(f.tick(1600u), "natural silent offline updates advance the original non-CEL voice");
        CHECK(f.app.condition_rand.holdrand == 2745024u && manager->sub_state == 4u &&
              live_audio_get_playback_cursor(f.app.live_audio, 12u, generation, &voice) == LIVE_AUDIO_OK,
              "running non-CEL ticks preserve the one B draw, real source generation and unchosen-response wait");
        finished = !voice.playing;
    }
    CHECK(finished && voice.source_frames == voice.source_frame_count && voice.source_frames > 0u,
          "actual non-CEL source reaches natural completion before normal response selection");
    const int16_t *r = f.app.a3f_caption.result.choices[0].rect;
    const CaptionRect &dst = f.app.captions.framed_destination;
    const CaptionRect &scroll = f.app.a3f_caption.popup.g.scroll_src;
    const int top = std::max<int>(r[1], scroll.top), bottom = std::min<int>(r[3], scroll.bottom);
    const int32_t x = (r[0] + r[2]) / 2 + dst.left - scroll.left;
    const int32_t y = (top + bottom) / 2 + dst.top - scroll.top;
    CHECK(top <= bottom && x >= dst.left && x <= dst.right && y >= dst.top && y <= dst.bottom,
          "first original mixed-case-key topic is visible through the real popup geometry");
    pointer(&f.app, BLACKMOOR_POINTER_MOVE, x, y, 0u);
    CHECK(f.tick() && f.app.a3f_caption.hover == 0, "real pointer hover reaches the first original Drake response");
    pointer(&f.app, BLACKMOOR_POINTER_DOWN, x, y, 0u);
    CHECK(f.tick(), "real Drake response pointer down is accepted");
    pointer(&f.app, BLACKMOOR_POINTER_UP, 0, 0, 0u); /* UP retains the MOVE hotpoint. */
    CHECK(f.tick(), "actual response release reaches the unchanged conversation kernel");
    for (unsigned step = 0u; step < 8u && manager->sub_state != 6u; ++step)
        CHECK(f.tick(), "selected original response advances through normal sound states");
    LiveAudioPlaybackCursor response{};
    SceneActionRuntimeState state{};
    CHECK(manager->sub_state == 6u && f.app.condition_rand.holdrand == 2745024u &&
          scene_session_get_action_state(f.app.session, 0u, &state) == SCENE_SESSION_OK && state.phase == 1u &&
          live_audio_get_playback_cursor(f.app.live_audio, 13u, 0u, &response) == LIVE_AUDIO_OK &&
          response.loaded && response.started && response.playing && response.source_frame_count > 0u,
          "pointer-selected original topic starts its actual channel13 response voice without another B draw");
    const uint64_t response_generation = response.generation;
    for (unsigned step = 0u; step < 3u; ++step)
        CHECK(f.tick() && manager->sub_state == 6u &&
              scene_session_get_action_state(f.app.session, 0u, &state) == SCENE_SESSION_OK && state.phase == 1u,
              "busy real response voice cannot request its following scene early");
    for (unsigned step = 0u; step < 900u && response.playing; ++step)
        CHECK(f.render_audio(1600u) &&
              live_audio_get_playback_cursor(f.app.live_audio, 13u, response_generation, &response) == LIVE_AUDIO_OK,
              "actual response source advances silently to its natural end before the next controller visit");
    CHECK(!response.playing && response.source_frames == response.source_frame_count && response.source_frames > 0u &&
          f.tick() && scene_session_get_action_state(f.app.session, 0u, &state) == SCENE_SESSION_OK && state.phase == 2u &&
          f.tick(), "real response completion enters phase2 and performs the original selected-response transition");
    SceneTransitionRequest transition{};
    CHECK(scene_session_get_pending_transition(f.app.session, &transition) && transition.target_scene == 1061 &&
          transition.opaque_words[0] == 0 && transition.opaque_words[1] == 0 && transition.opaque_words[2] == 1 &&
          transition.opaque_dwords[0] == 0 && transition.opaque_dwords[1] == 0 && transition.opaque_dwords[2] == 1 &&
          !f.app.a3f_caption.ready && !f.app.a3f_caption.active[0] && !f.app.a3f_caption.active[1] &&
          f.app.condition_rand.holdrand == 2745024u,
          "original first-topic tuple targets S1061 and releases both response surfaces without an extra random draw");
    bool following_started = false;
    for (unsigned step = 0u; step < 900u && !following_started; ++step) {
        CHECK(f.tick(1600u), "actual selected response follows its normal scene transition and CEL startup");
        manager = session_a3f_manager(f.app.a3f);
        LiveAudioPlaybackCursor following{};
        following_started = f.app.current_scene_id == 1061 && manager &&
            manager->type == SESSION_A3E_TYPE && manager->sub_state == 4u &&
            f.app.cel_reader_running && manager->cel.loaded >= 4 &&
            live_audio_get_playback_cursor(f.app.live_audio, 12u, f.app.cel_sync_generation, &following) == LIVE_AUDIO_OK &&
            following.started && following.playing && following.generation != generation;
    }
    CHECK(following_started, "actual pointer-selected topic loads S1061 and starts its original following CEL voice");
    std::printf("DRAKE_CHOICES_FOLLOW direct_entry=1087 row=0 hooks=0,0 crt_return=41 seed_after=2745024 B_scene=1092 selected=0 target=1061 source_frames=%llu response_frames=%llu following_cel=1 muted_frames=%llu\n",
        static_cast<unsigned long long>(voice.source_frames), static_cast<unsigned long long>(response.source_frames),
        static_cast<unsigned long long>(f.muted_frames));
    return 0;
}

int main(int argc, char **argv)
{
    @autoreleasepool {
        CHECK(argc == 3, "owner-local game directory and bounded Drake component case required");
        DrakeChoiceFixture fixture;
        const bool initialized = fixture.initialize(argv[1]);
        if (!initialized) fixture.print_log_tail();
        CHECK(initialized, "fresh original BOOT/new-game/S1087 labeled direct-entry component initializes");
        int result = 1;
        if (std::strcmp(argv[2], "preview") == 0) result = preview_purity(fixture);
        else if (std::strcmp(argv[2], "follow") == 0) result = pointer_follow(fixture);
        else std::fprintf(stderr, "CHECK failed: unknown bounded Drake case\n");
        if (result) fixture.print_log_tail();
        return result;
    }
}
