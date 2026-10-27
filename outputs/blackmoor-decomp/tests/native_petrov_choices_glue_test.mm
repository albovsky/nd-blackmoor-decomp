/* Petrov hook6: original BOOT/new-game, real S1087 room frame, then a
 * labeled direct host-transition component into dependency-free S1605 NO_ART.
 * Actual source/response voices and pointer-selected offered topic follow.
 * Supported seed1 startup replay; no story, inventory, row, phase, response,
 * candidate or midgame RNG injection. No campaign/phone-return or x86 claim. */
#define main blackmoor_app_entry_for_petrov_choices_test
#ifndef NATIVE_PETROV_CHOICES_APP_SOURCE
#define NATIVE_PETROV_CHOICES_APP_SOURCE "../src/blackmoor_app.mm"
#endif
#include NATIVE_PETROV_CHOICES_APP_SOURCE
#undef main

#define CHECK(condition, message) do { if (!(condition)) { \
    std::fprintf(stderr, "CHECK failed: %s\n", message); return 1; } } while (0)

struct PetrovChoiceFixture {
    NativeApp app{};
    AutoText *expected_convo = nullptr;
    size_t row = 0u;
    HostImage room_art{};
    uint32_t now = 1000u;
    uint64_t muted_frames = 0u;
    ~PetrovChoiceFixture() { autotext_close(expected_convo); cleanup(&app); }

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
            std::fprintf(stderr, "Petrov independent CONVO load: %s\n", error); return false;
        }
        const int text_status = autotext_open_memory(convo.bytes, convo.length, 0, &expected_convo, error, sizeof error);
        game_resource_bytes_destroy(&convo);
        if (text_status != AUTOTEXT_OK || autotext_entry_count(expected_convo) != 1244u) {
            std::fprintf(stderr, "Petrov independent CONVO status=%d entries=%zu detail=%s\n",
                text_status, autotext_entry_count(expected_convo), error); return false;
        }
        LiveAudioConfig audio{};
        audio.game_directory = directory; audio.mode = MAC_AUDIO_MODE_OFFLINE;
        if (live_audio_create(&audio, &app.live_audio, error, sizeof error) != LIVE_AUDIO_OK) {
            std::fprintf(stderr, "Petrov offline audio initialization: %s\n", error); return false;
        }
        app.offline_audio_frames_per_update = 1u;
        app.framebuffer.resize(640u * 480u * 4u);
        app.selector_entry_valid = true;
        app.selector_entry_frame = 0;
        app.selector_entry_scroll = 0;
        if (!load_scene(&app, 1087)) {
            std::fprintf(stderr, "Petrov direct-entry scene load failed\n"); return false;
        }
        const ActionFamily28Rect view = {app.scene_destination.left, app.scene_destination.top,
                                         app.scene_destination.right, app.scene_destination.bottom};
        if (session_exit_init(&app.exit_state, &view) != SESSION_EXIT_OK || !create_native_scene_session(&app)) return false;
        room_art = app.scene_frame;
        SceneTransitionRequest direct{};
        direct.target_scene = 1605; direct.opaque_words[2] = 1; direct.opaque_dwords[2] = 1;
        /* Explicit direct component entry through the public host boundary;
         * no S1087 row is dispatched and no campaign route is claimed. */
        if (scene_session_request_external_transition(app.session, &direct) != SCENE_SESSION_OK ||
            !perform_session_transition(&app, direct, now)) return false;
        for (size_t index = 0; index < scene_session_action_high_water(app.session); ++index) {
            SceneExecutorSlotInfo slot{};
            if (scene_session_get_slot(app.session, index, &slot) != SCENE_SESSION_OK) return false;
            if (slot.occupied && slot.source == app.scene && slot.source_index == 0u) {
                row = index;
                return true;
            }
        }
        return false;
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

static int original_row(PetrovChoiceFixture &f, ActionFamily3fDecoded *decoded)
{
    SceneActionInfo original{};
    SceneExecutorSlotInfo slot{};
    SceneActionRuntimeState state{};
    SceneResourceSummary summary{};
    CHECK(f.app.current_scene_id == 1605 && f.app.last_art_scene_id == 1087 &&
          f.app.has_scene_frame && f.app.scene_frame.rgba == f.room_art.rgba &&
          scene_resource_get_summary(f.app.scene, &summary) == SCENE_RESOURCE_OK &&
          std::strcmp(summary.background, "NO_ART_SCENE") == 0 &&
          scene_resource_action_at(f.app.scene, 0u, &original) == SCENE_RESOURCE_OK &&
          original.type == SESSION_A3F_TYPE && original.dependency_count == 0u &&
          scene_session_get_slot(f.app.session, f.row, &slot) == SCENE_SESSION_OK && slot.occupied &&
          slot.source == f.app.scene && slot.source_index == 0u && slot.runtime_type == SESSION_A3F_TYPE &&
          action_family_3f_decode(original.raw_body, original.raw_body_length, decoded) == ACTION_FAMILY_3F_OK &&
          decoded->option_44 == 6u && decoded->option_45 == 6u &&
          decoded->primary_count == 0 && decoded->secondary_count == 0,
          "original S1605 row0 is naturally eligible hook6/6 non-CEL while the real S1087 room frame is retained");
    CHECK(scene_session_get_action_state(f.app.session, f.row, &state) == SCENE_SESSION_OK &&
          state.phase == 0u && !state.completed && f.app.condition_rand.holdrand == 1u &&
          f.app.new_game.scene_visits[1087u] == 1u && f.app.new_game.scene_visits[1605u] == 1u,
          "direct retained transition starts an untouched Petrov executor and preserves supported startup CRT seed");
    return 0;
}

static int default_responses(PetrovChoiceFixture &f, const Convo3fManager *manager)
{
    const char *keys[] = {"NMP50", "NMP55", "NMP90"};
    const int16_t scenes[] = {1650, 1655, 1692}; /* seed1 -> CRT41 -> remainder2. */
    CHECK(manager && manager->response_count == 3,
          "fresh Petrov world offers the two original A topics followed by the one B response");
    CHECK(f.app.new_game.event_flags[1416] == 0 && f.app.new_game.event_flags[1610] == 0 &&
          f.app.new_game.event_flags[1601] == 0 && f.app.new_game.event_flags[1498] == 0 &&
          f.app.new_game.event_flags[1242] == 0 && f.app.new_game.event_flags[1493] == 0 &&
          f.app.new_game.event_flags[2014] == 0,
          "default unasked topics come from untouched fresh-world event predicates");
    for (size_t i = 0u; i < 3u; ++i) {
        const uint8_t *text = nullptr;
        size_t raw = 0u, length = 0u;
        CHECK(autotext_lookup(f.expected_convo, reinterpret_cast<const uint8_t *>(keys[i]),
                  std::strlen(keys[i]), &text, &raw, &length) == AUTOTEXT_OK &&
              text && length && length < CONVO3F_TEXT_BYTES,
              "every actual Petrov key resolves in independently loaded original CONVO");
        std::array<uint8_t, CONVO3F_TEXT_BYTES> owned{};
        std::memcpy(owned.data(), text, length);
        const Convo3fResponse &response = manager->responses[i];
        CHECK(std::memcmp(response.text, owned.data(), owned.size()) == 0 &&
              std::strcmp(reinterpret_cast<const char *>(response.name), keys[i]) == 0 &&
              response.scene == scenes[i] && response.word_23 == 0 && response.word_25 == 0 &&
              response.word_27 == 1 && response.dword_29 == 0 && response.dword_2d == 0 &&
              response.dword_31 == 1 && response.event_index == -1 && !response.event_value && response.word_38 == 2,
              "owned real text, exact original sound key and transition metadata preserve A/A/B order");
    }
    return 0;
}

static int preview_purity(PetrovChoiceFixture &f)
{
    ActionFamily3fDecoded decoded{};
    CHECK(original_row(f, &decoded) == 0, "original direct-entry Petrov row is fresh");
    const auto flags = f.app.new_game.event_flags;
    const auto inventory = f.app.new_game.inventory_presence;
    const auto framebuffer = f.app.framebuffer;
    for (unsigned repeat = 0u; repeat < 4u; ++repeat) {
        Convo3fManager preview{};
        Convo3fLayoutRequest request{};
        CHECK(session_a3f_preview_layout(f.app.a3f, f.row, &preview, &request) == CONVO3F_OK &&
              default_responses(f, &preview) == 0 && request.response_count == 3 &&
              native_conversation_choices_validate(&request, 1, &f.app.captions.fonts,
                  &f.app.captions.geometry, &f.app.captions.pixel_format) == CAPTION_OK,
              "real hook6 preview resolves original owned CONVO text and validates its caption layout");
        CHECK(f.app.condition_rand.holdrand == 1u && f.app.new_game.event_flags == flags &&
              f.app.new_game.inventory_presence == inventory && f.app.framebuffer == framebuffer &&
              session_a3f_response_count(f.app.a3f) == 0 && !f.app.a3f_caption.ready,
              "repeated previews preserve shared CRT, story, inventory, live manager and visible surfaces");
    }
    LiveAudioChannelInfo voice{};
    SceneActionRuntimeState state{};
    CHECK(scene_session_get_action_state(f.app.session, f.row, &state) == SCENE_SESSION_OK &&
          state.phase == 0u && !state.completed &&
          live_audio_get_channel_info(f.app.live_audio, 12u, &voice) == LIVE_AUDIO_OK && !voice.loaded && !voice.started,
          "pure Petrov previews execute no row and load no source voice");
    std::printf("PETROV_CHOICES_PREVIEW direct_entry=1605 retained_art=1087 row=0 hooks=6,6 repeats=4 live_seed=1 responses=3 B_scene=1692\n");
    return 0;
}

static int pointer_follow(PetrovChoiceFixture &f)
{
    ActionFamily3fDecoded decoded{};
    CHECK(original_row(f, &decoded) == 0, "original direct-entry Petrov row is fresh");
    CHECK(f.tick(), "naturally eligible S1605 hook6 row starts");
    const Convo3fManager *manager = session_a3f_manager(f.app.a3f);
    CHECK(default_responses(f, manager) == 0 && f.app.condition_rand.holdrand == 2745024u &&
          manager->row == static_cast<int32_t>(f.row) && manager->type == SESSION_A3F_TYPE && manager->sub_state == 4u &&
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
          "offered original A0 topic is visible through the real popup geometry");
    pointer(&f.app, BLACKMOOR_POINTER_MOVE, x, y, 0u);
    CHECK(f.tick() && f.app.a3f_caption.hover == 0, "real pointer hover reaches the first original Petrov response");
    pointer(&f.app, BLACKMOOR_POINTER_DOWN, x, y, 0u);
    CHECK(f.tick(), "real Petrov response pointer down is accepted");
    pointer(&f.app, BLACKMOOR_POINTER_UP, 0, 0, 0u); /* UP retains the MOVE hotpoint. */
    CHECK(f.tick(), "actual response release reaches the unchanged conversation kernel");
    for (unsigned step = 0u; step < 8u && manager->sub_state != 6u; ++step)
        CHECK(f.tick(), "selected original response advances through normal sound states");
    LiveAudioPlaybackCursor response{};
    SceneActionRuntimeState state{};
    CHECK(manager->sub_state == 6u && f.app.condition_rand.holdrand == 2745024u &&
          scene_session_get_action_state(f.app.session, f.row, &state) == SCENE_SESSION_OK && state.phase == 1u &&
          live_audio_get_playback_cursor(f.app.live_audio, 13u, 0u, &response) == LIVE_AUDIO_OK &&
          response.loaded && response.started && response.playing && response.source_frame_count > 0u,
          "pointer-selected original topic starts its actual channel13 response voice without another B draw");
    const uint64_t response_generation = response.generation;
    for (unsigned step = 0u; step < 3u; ++step)
        CHECK(f.tick() && manager->sub_state == 6u &&
              scene_session_get_action_state(f.app.session, f.row, &state) == SCENE_SESSION_OK && state.phase == 1u,
              "busy real response voice cannot request its following scene early");
    for (unsigned step = 0u; step < 900u && response.playing; ++step)
        CHECK(f.render_audio(1600u) &&
              live_audio_get_playback_cursor(f.app.live_audio, 13u, response_generation, &response) == LIVE_AUDIO_OK,
              "actual response source advances silently to its natural end before the next controller visit");
    CHECK(!response.playing && response.source_frames == response.source_frame_count && response.source_frames > 0u &&
          f.tick() && scene_session_get_action_state(f.app.session, f.row, &state) == SCENE_SESSION_OK && state.phase == 2u &&
          f.tick(), "real response completion enters phase2 and performs the original selected-response transition");
    SceneTransitionRequest transition{};
    CHECK(scene_session_get_pending_transition(f.app.session, &transition) && transition.target_scene == 1650 &&
          transition.opaque_words[0] == 0 && transition.opaque_words[1] == 0 && transition.opaque_words[2] == 1 &&
          transition.opaque_dwords[0] == 0 && transition.opaque_dwords[1] == 0 && transition.opaque_dwords[2] == 1 &&
          !f.app.a3f_caption.ready && !f.app.a3f_caption.active[0] && !f.app.a3f_caption.active[1] &&
          f.app.condition_rand.holdrand == 2745024u,
          "original offered-topic tuple targets S1650 and releases both response surfaces without an extra random draw");
    const auto flags_before_following = f.app.new_game.event_flags;
    bool following_started = false;
    int following_response_count = -1;
    for (unsigned step = 0u; step < 900u && !following_started; ++step) {
        CHECK(f.tick(1600u), "actual selected response follows its normal scene transition and following non-CEL voice startup");
        manager = session_a3f_manager(f.app.a3f);
        LiveAudioPlaybackCursor following{};
        SceneExecutorSlotInfo following_owner{};
        following_started = f.app.current_scene_id == 1650 && manager && manager->row >= 0 &&
            manager->type == SESSION_A3F_TYPE && manager->sub_state == 4u && !f.app.cel_reader_running &&
            scene_session_get_slot(f.app.session, static_cast<size_t>(manager->row), &following_owner) == SCENE_SESSION_OK &&
            following_owner.occupied && following_owner.source == f.app.scene &&
            following_owner.action.type == SESSION_A3F_TYPE &&
            live_audio_get_playback_cursor(f.app.live_audio, 12u, 0u, &following) == LIVE_AUDIO_OK &&
            following.loaded && following.started && following.playing && following.position_valid &&
            following.source_frame_count > 0u && following.generation != generation;
        if (following_started) following_response_count = manager->response_count;
    }
    CHECK(following_started, "actual pointer-selected topic loads S1650 and starts its original following non-CEL voice");
    SceneActionInfo flag_row{};
    CHECK(scene_resource_action_at(f.app.scene, 2u, &flag_row) == SCENE_RESOURCE_OK &&
          flag_row.type == 0x61u && flag_row.typed_body_length == 8u,
          "actual S1650 owns the original two-pair event-flags body at local row2");
    unsigned changed_flags = 0u;
    for (size_t pair = 0u; pair < 2u; ++pair) {
        const uint8_t *body = flag_row.typed_body + pair * 4u;
        const int16_t index = static_cast<int16_t>(static_cast<uint16_t>(body[0] | body[1] << 8));
        const int16_t value = static_cast<int16_t>(static_cast<uint16_t>(body[2] | body[3] << 8));
        if (index == -1) continue;
        CHECK(index >= 0 && static_cast<size_t>(index) < f.app.new_game.event_flags.size() &&
              f.app.new_game.event_flags[static_cast<size_t>(index)] == value,
              "genuine following-scene updates apply the original raw61 flag index/value without injection");
        if (flags_before_following[static_cast<size_t>(index)] != value) ++changed_flags;
    }
    CHECK(changed_flags > 0u, "original S1650 raw61 effects change at least one fresh-world flag");
    std::printf("PETROV_CHOICES_FOLLOW direct_entry=1605 retained_art=1087 row=0 hooks=6,6 crt_return=41 seed_after=2745024 B_scene=1692 selected=0 target=1650 source_frames=%llu response_frames=%llu following_non_cel=1 following_responses=%d raw61_changed_flags=%u phone_return_unverified=1 muted_frames=%llu\n",
        static_cast<unsigned long long>(voice.source_frames), static_cast<unsigned long long>(response.source_frames),
        following_response_count, changed_flags, static_cast<unsigned long long>(f.muted_frames));
    return 0;
}

int main(int argc, char **argv)
{
    @autoreleasepool {
        CHECK(argc == 3, "owner-local game directory and bounded Petrov component case required");
        PetrovChoiceFixture fixture;
        const bool initialized = fixture.initialize(argv[1]);
        if (!initialized) fixture.print_log_tail();
        CHECK(initialized, "fresh original BOOT/new-game/S1087 room and direct S1605 retained component initialize");
        int result = 1;
        if (std::strcmp(argv[2], "preview") == 0) result = preview_purity(fixture);
        else if (std::strcmp(argv[2], "follow") == 0) result = pointer_follow(fixture);
        else std::fprintf(stderr, "CHECK failed: unknown bounded Petrov case\n");
        if (result) fixture.print_log_tail();
        return result;
    }
}
