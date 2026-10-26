/* NATIVE-22: direct entry to original S1217 row0, fresh BOOT/new-game state.
 * This is a native component, not a campaign route. No story, inventory,
 * row-phase or response injection; no window, output device or x86 oracle.
 * The separate local list assertions below use explicitly fabricated values.
 */
#define main blackmoor_app_entry_for_jane_hook_test
#ifndef NATIVE_JANE_HOOK_APP_SOURCE
#define NATIVE_JANE_HOOK_APP_SOURCE "../src/blackmoor_app.mm"
#endif
#include NATIVE_JANE_HOOK_APP_SOURCE
#undef main

#define CHECK(condition, message) do { if (!(condition)) { \
    std::fprintf(stderr, "CHECK failed: %s\n", message); return 1; } } while (0)

struct JaneHookFixture {
    NativeApp app{};
    AutoText *expected_convo = nullptr;
    uint32_t now = 1000u;
    uint64_t muted_frames = 0u;
    ~JaneHookFixture() { autotext_close(expected_convo); cleanup(&app); }

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
            std::fprintf(stderr, "Jane independent CONVO load: %s\n", error); return false;
        }
        const int text_status = autotext_open_memory(convo.bytes, convo.length, 0, &expected_convo, error, sizeof error);
        game_resource_bytes_destroy(&convo);
        if (text_status != AUTOTEXT_OK || autotext_entry_count(expected_convo) != 1244u) {
            std::fprintf(stderr, "Jane independent CONVO status=%d entries=%zu detail=%s\n",
                text_status, autotext_entry_count(expected_convo), error); return false;
        }
        LiveAudioConfig audio{};
        audio.game_directory = directory; audio.mode = MAC_AUDIO_MODE_OFFLINE;
        if (live_audio_create(&audio, &app.live_audio, error, sizeof error) != LIVE_AUDIO_OK) {
            std::fprintf(stderr, "Jane offline audio initialization: %s\n", error); return false;
        }
        app.offline_audio_frames_per_update = 1u;
        app.framebuffer.resize(640u * 480u * 4u);
        app.selector_entry_valid = true;
        app.selector_entry_frame = 0;
        app.selector_entry_scroll = 0;
        if (!load_scene(&app, 1217)) {
            std::fprintf(stderr, "Jane direct-entry scene load failed\n"); return false;
        }
        const ActionFamily28Rect view = {app.scene_destination.left, app.scene_destination.top,
                                         app.scene_destination.right, app.scene_destination.bottom};
        return session_exit_init(&app.exit_state, &view) == SESSION_EXIT_OK && create_native_scene_session(&app);
    }

    bool tick(uint64_t frames = 0u)
    {
        if (frames) {
            LiveAudioOfflineStats stats{};
            if (live_audio_advance_offline(app.live_audio, frames, &stats, nullptr, 0u) != LIVE_AUDIO_OK ||
                stats.frames != frames || stats.nonfinite_samples || stats.nonzero_samples) return false;
            muted_frames += stats.frames;
        }
        uint32_t rate = 0u, channels = 0u;
        if (live_audio_offline_format(app.live_audio, &rate, &channels) != LIVE_AUDIO_OK || !rate) return false;
        now = 1000u + static_cast<uint32_t>(live_audio_offline_frames_rendered(app.live_audio) * 1000u / rate);
        update(&app, now);
        if (app.failure || app.session_block_reported) { print_log_tail(); return false; }
        return true;
    }
};

static int original_row(JaneHookFixture &f, ActionFamily3eDecoded *decoded)
{
    SceneActionInfo row{};
    SceneActionRuntimeState state{};
    CHECK(f.app.current_scene_id == 1217 &&
          scene_resource_action_at(f.app.scene, 0u, &row) == SCENE_RESOURCE_OK &&
          row.type == SESSION_A3E_TYPE && row.dependency_count == 0u &&
          action_family_3e_decode(row.raw_body, row.raw_body_length, decoded) == ACTION_FAMILY_3E_OK &&
          decoded->option_a9 == 1u && decoded->option_aa == 1u &&
          decoded->primary_count == 0 && decoded->secondary_count == 0 && decoded->word_63 == 182u,
          "original S1217 row0 is a naturally eligible hook1/1 CEL with no primary/secondary entries");
    CHECK(scene_session_get_action_state(f.app.session, 0u, &state) == SCENE_SESSION_OK &&
          state.phase == 0u && !state.completed && f.app.condition_rand.holdrand == 1u,
          "fresh direct-entry executor state and configured CRT seed remain untouched");
    return 0;
}

static int default_responses(JaneHookFixture &f, const Convo3fManager *manager)
{
    const char *keys[] = {"NJP65", "NJP79", "NJP90"};
    const int16_t scenes[] = {1265, 1279, 1291}; /* seed1 -> CRT41 -> B case1. */
    CHECK(manager && manager->response_count == 3, "fresh Jane world offers two A topics then one B response");
    CHECK(f.app.new_game.event_flags[1332] == 0 && f.app.new_game.event_flags[1383] == 0,
          "the two default unasked-topic predicates come from unchanged fresh story state");
    for (size_t i = 0u; i < 3u; ++i) {
        const uint8_t *text = nullptr;
        size_t raw = 0u, length = 0u;
        CHECK(autotext_lookup(f.expected_convo, reinterpret_cast<const uint8_t *>(keys[i]),
                  std::strlen(keys[i]), &text, &raw, &length) == AUTOTEXT_OK &&
              text && length && length < CONVO3F_TEXT_BYTES,
              "every actual Jane response key resolves in independently loaded CONVO");
        std::array<uint8_t, CONVO3F_TEXT_BYTES> owned{};
        std::memcpy(owned.data(), text, length);
        const Convo3fResponse &response = manager->responses[i];
        CHECK(std::memcmp(response.text, owned.data(), owned.size()) == 0 &&
              std::strcmp(reinterpret_cast<const char *>(response.name), keys[i]) == 0 &&
              response.scene == scenes[i] && response.word_23 == 0 && response.word_25 == 0 &&
              response.word_27 == 1 && response.dword_29 == 0 && response.dword_2d == 0 &&
              response.dword_31 == 1 && response.event_index == -1 && !response.event_value && response.word_38 == 2,
              "owned real response text, sound key and transition metadata preserve A/A/B order");
    }
    return 0;
}

static int local_list_contract()
{
    Convo3fManager manager{};
    for (auto &response : manager.responses) std::memset(response.name, 0x5a, sizeof response.name);
    Convo3fResponse entry{};
    std::memcpy(entry.text, "same", 5u); std::memcpy(entry.name, "a", 2u); entry.scene = 100;
    CHECK(convo3f_apply_hook_response(&manager, &entry, 0) == CONVO3F_OK &&
          manager.response_count == 1 && manager.responses[0].name[2] == 0x5au,
          "local add copies only the sound-name C string and preserves its stale tail");
    std::memcpy(entry.text, "SAME", 5u); entry.scene = 101;
    CHECK(convo3f_apply_hook_response(&manager, &entry, 0) == CONVO3F_OK &&
          manager.response_count == 1 && manager.responses[0].scene == 100,
          "local add deduplicates text case-insensitively without replacing metadata");
    std::memcpy(entry.text, "other", 6u); entry.scene = 200;
    CHECK(convo3f_apply_hook_response(&manager, &entry, 0) == CONVO3F_OK, "local second topic appends");
    manager.responses[2] = manager.responses[0]; manager.responses[2].scene = 300; manager.response_count = 3;
    std::memset(entry.text, 0, sizeof entry.text); std::memcpy(entry.text, "same", 5u);
    std::memcpy(entry.name, "r", 2u); entry.scene = 400;
    CHECK(convo3f_apply_hook_response(&manager, &entry, 1) == CONVO3F_OK && manager.response_count == 3 &&
          manager.responses[0].scene == 200 && manager.responses[1].scene == 300 &&
          manager.responses[2].scene == 400 && manager.responses[2].name[2] == 0x5au,
          "local replace removes only first equal text, compacts, and appends with name-tail preservation");
    manager.response_count = CONVO3F_MAX_RESPONSES;
    for (int i = 0; i < CONVO3F_MAX_RESPONSES; ++i) {
        auto &response = manager.responses[i];
        std::memset(&response, 0, sizeof response);
        std::snprintf(reinterpret_cast<char *>(response.text), sizeof response.text, "entry%02d", i);
        std::memset(response.name, 0x6b, sizeof response.name);
        std::memcpy(response.name, "old", 4u); response.scene = static_cast<int16_t>(i);
    }
    std::array<uint8_t, sizeof manager> before{}; std::memcpy(before.data(), &manager, sizeof manager);
    std::memset(entry.text, 0, sizeof entry.text); std::memcpy(entry.text, "absent", 7u);
    CHECK(convo3f_apply_hook_response(&manager, &entry, 0) == CONVO3F_OK &&
          std::memcmp(before.data(), &manager, sizeof manager) == 0 &&
          convo3f_apply_hook_response(&manager, &entry, 1) == CONVO3F_OK &&
          std::memcmp(before.data(), &manager, sizeof manager) == 0,
          "local full list ignores unmatched add and replacement without modifying records");
    std::memset(entry.text, 0, sizeof entry.text); std::memcpy(entry.text, "ENTRY03", 8u); entry.scene = 999;
    CHECK(convo3f_apply_hook_response(&manager, &entry, 0) == CONVO3F_OK &&
          std::memcmp(before.data(), &manager, sizeof manager) == 0 &&
          convo3f_apply_hook_response(&manager, &entry, 1) == CONVO3F_OK &&
          manager.response_count == CONVO3F_MAX_RESPONSES && manager.responses[3].scene == 4 &&
          manager.responses[29].scene == 999 && manager.responses[29].name[2] == 'd' &&
          manager.responses[29].name[4] == 0x6bu,
          "local full-list replacement removes the first match before appending into its freed capacity");
    return 0;
}

static int preview_purity(JaneHookFixture &f)
{
    ActionFamily3eDecoded decoded{};
    CHECK(original_row(f, &decoded) == 0 && local_list_contract() == 0, "original row and local list contract pass");
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
              "real Jane hook preview resolves owned CONVO text and validates caption layout");
        CHECK(f.app.condition_rand.holdrand == 1u && f.app.new_game.event_flags == flags &&
              f.app.new_game.inventory_presence == inventory && f.app.framebuffer == framebuffer &&
              session_a3f_response_count(f.app.a3f) == 0 && !f.app.a3f_caption.ready,
              "repeated preview leaves shared CRT, story, inventory, manager and visible surfaces unchanged");
    }
    LiveAudioChannelInfo voice{};
    SceneActionRuntimeState state{};
    CHECK(scene_session_get_action_state(f.app.session, 0u, &state) == SCENE_SESSION_OK &&
          state.phase == 0u && !state.completed &&
          live_audio_get_channel_info(f.app.live_audio, 12u, &voice) == LIVE_AUDIO_OK && !voice.loaded && !voice.started,
          "pure Jane previews execute no row and load no source voice");
    std::printf("JANE_HOOK_PREVIEW direct_entry=1217 row=0 hooks=1,1 repeats=4 live_seed=1 responses=3 local_list_contract=1\n");
    return 0;
}

static int pointer_follow(JaneHookFixture &f)
{
    ActionFamily3eDecoded decoded{};
    CHECK(original_row(f, &decoded) == 0, "original direct-entry Jane row is fresh");
    CHECK(f.tick(), "naturally eligible S1217 hook row starts");
    const Convo3fManager *manager = session_a3f_manager(f.app.a3f);
    CHECK(default_responses(f, manager) == 0 && f.app.condition_rand.holdrand == 2745024u &&
          manager->row == 0 && manager->type == SESSION_A3E_TYPE && manager->sub_state == 1u &&
          manager->cel.last == 182 && f.app.cel_reader_running && f.app.a3f_caption.ready &&
          f.app.a3f_caption.result.response_count == 3,
          "real phase0 consumes exactly CRT seed1 draw41 and builds its original caption choices");
    int16_t body = -1, head = -1;
    CHECK(native_cel_resources_tree_index(f.app.cel_resources, reinterpret_cast<const char *>(decoded.name_21), &body) == NATIVE_CEL_OK &&
          native_cel_resources_tree_index(f.app.cel_resources, reinterpret_cast<const char *>(decoded.name_42), &head) == NATIVE_CEL_OK &&
          body != head && manager->cel.layer_tree[0] == body && manager->cel.layer_tree[1] == head,
          "real original row loads its named body/head CAL trees");
    CHECK(f.tick() && manager->cel.loaded == 4 && manager->sub_state == 4u,
          "normal media tick prefills actual Jane CEL and starts the source voice");
    LiveAudioPlaybackCursor voice{};
    CHECK(live_audio_get_playback_cursor(f.app.live_audio, 12u, f.app.cel_sync_generation, &voice) == LIVE_AUDIO_OK &&
          voice.loaded && voice.started && voice.playing && voice.position_valid && voice.source_frame_count > 0u,
          "real source voice supplies a valid native cursor after CEL prefill");
    const uint64_t generation = voice.generation;
    bool finished = false;
    for (unsigned step = 0u; step < 800u && !finished; ++step) {
        CHECK(f.tick(1600u), "natural muted source voice and CEL advance");
        CHECK(f.app.condition_rand.holdrand == 2745024u &&
              live_audio_get_playback_cursor(f.app.live_audio, 12u, generation, &voice) == LIVE_AUDIO_OK,
              "running Jane ticks consume no extra hook random draw and preserve source generation");
        finished = !voice.playing && manager->cel.drawn == 182 && manager->cel.final_seen;
    }
    CHECK(finished && voice.source_frames > 0u && f.app.cel_draw_count > 1u,
          "real source audio reaches the original final CEL frame before choosing");
    const int16_t *r = f.app.a3f_caption.result.choices[0].rect;
    const CaptionRect &dst = f.app.captions.framed_destination;
    const CaptionRect &scroll = f.app.a3f_caption.popup.g.scroll_src;
    const int top = std::max<int>(r[1], scroll.top), bottom = std::min<int>(r[3], scroll.bottom);
    const int32_t x = (r[0] + r[2]) / 2 + dst.left - scroll.left;
    const int32_t y = (top + bottom) / 2 + dst.top - scroll.top;
    CHECK(top <= bottom && x >= dst.left && x <= dst.right && y >= dst.top && y <= dst.bottom,
          "first original Jane topic is visible through real popup geometry");
    pointer(&f.app, BLACKMOOR_POINTER_MOVE, x, y, 0u);
    CHECK(f.tick() && f.app.a3f_caption.hover == 0, "real pointer hover reaches the first original Jane response");
    pointer(&f.app, BLACKMOOR_POINTER_DOWN, x, y, 0u);
    CHECK(f.tick(), "real response pointer down is accepted");
    pointer(&f.app, BLACKMOOR_POINTER_UP, x, y, 0u);
    CHECK(f.tick(), "real response pointer release reaches the conversation kernel");
    for (unsigned step = 0u; step < 8u && manager->sub_state != 6u; ++step)
        CHECK(f.tick(), "selected Jane response advances through normal sound states");
    LiveAudioChannelInfo response{};
    CHECK(manager->sub_state == 6u &&
          live_audio_get_channel_info(f.app.live_audio, 13u, &response) == LIVE_AUDIO_OK &&
          response.loaded && response.started && response.frame_count > 0u,
          "actual pointer-selected Jane response starts its real channel13 voice");
    bool following_started = false;
    for (unsigned step = 0u; step < 900u && !following_started; ++step) {
        CHECK(f.tick(1600u), "actual selected response naturally reaches its following scene");
        manager = session_a3f_manager(f.app.a3f);
        LiveAudioPlaybackCursor following{};
        following_started = f.app.current_scene_id == 1265 && manager &&
            manager->type == SESSION_A3E_TYPE && manager->sub_state == 4u &&
            f.app.cel_reader_running && manager->cel.loaded >= 4 &&
            live_audio_get_playback_cursor(f.app.live_audio, 12u, f.app.cel_sync_generation, &following) == LIVE_AUDIO_OK &&
            following.started && following.playing && following.generation != generation;
    }
    CHECK(following_started, "actual response selection loads S1265 and starts its following original CEL voice");
    std::printf("JANE_HOOK_FOLLOW direct_entry=1217 row=0 hooks=1,1 crt_return=41 seed_after=2745024 B_scene=1291 selected=0 target=1265 source_frames=%llu muted_frames=%llu\n",
        static_cast<unsigned long long>(voice.source_frames), static_cast<unsigned long long>(f.muted_frames));
    return 0;
}

int main(int argc, char **argv)
{
    @autoreleasepool {
        CHECK(argc == 3, "owner-local game directory and Jane component case required");
        JaneHookFixture fixture;
        const bool initialized = fixture.initialize(argv[1]);
        if (!initialized) fixture.print_log_tail();
        CHECK(initialized, "fresh BOOT/new-game/S1217 direct-entry component initializes");
        if (std::strcmp(argv[2], "preview") == 0) return preview_purity(fixture);
        if (std::strcmp(argv[2], "follow") == 0) return pointer_follow(fixture);
        return 2;
    }
}
