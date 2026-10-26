/* NATIVE20: real S1200/BOOT/new-game component with silent offline audio.
 * Direct scene entry only; no campaign route, story/phase/clock injection,
 * window, output device or original-x86 execution. */
#define main blackmoor_app_entry_for_cel_test
#ifndef NATIVE_CEL_APP_SOURCE
#define NATIVE_CEL_APP_SOURCE "../src/blackmoor_app.mm"
#endif
#include NATIVE_CEL_APP_SOURCE
#undef main
#include <csignal>

#define CHECK(condition, message) do { if (!(condition)) { \
    std::fprintf(stderr, "CHECK failed: %s\n", message); return 1; } } while (0)

struct CelFixture {
    NativeApp app{};
    uint32_t now = 1000u;
    uint64_t muted_frames = 0u;
    ~CelFixture() { cleanup(&app); }
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
    bool initialize(const char *directory, bool captions)
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
        if (app.log == nullptr || session_input_init(&app.input_state) != SESSION_INPUT_OK) return false;
        int external = 0;
        char error[256]{};
        if (!game_ini_configuration(app.game_directory, &external, &app.closed_captioning)) return false;
        app.closed_captioning = captions; /* Supported user preference, not a story flag. */
        app.resources = game_resources_open((app.game_directory + "/Ciftree").c_str(), external, error, sizeof error);
        GameResourceBytes boot = GAME_RESOURCE_BYTES_INIT;
        if (app.resources == nullptr || !game_resources_load_bytes(app.resources, "BOOT", &boot, error, sizeof error)) return false;
        app.boot = engine_boot_open_memory(boot.bytes, boot.length, error, sizeof error);
        game_resource_bytes_destroy(&boot);
        if (app.boot == nullptr || world_init_cold_zero_event_flags(&app.new_game.action_core) != WORLD_INIT_OK ||
            !load_viewport(&app) || !initialize_caption_runtime(&app) || !initialize_new_game(&app, now)) return false;
        LiveAudioConfig audio{};
        audio.game_directory = directory;
        audio.mode = MAC_AUDIO_MODE_OFFLINE;
        if (live_audio_create(&audio, &app.live_audio, error, sizeof error) != LIVE_AUDIO_OK) {
            std::fprintf(stderr, "CEL offline audio initialization: %s\n", error);
            return false;
        }
        app.offline_audio_frames_per_update = 1u;
        app.framebuffer.resize(640u * 480u * 4u);
        app.selector_entry_valid = true;
        app.selector_entry_frame = 0;
        app.selector_entry_scroll = 0;
        if (!load_scene(&app, 1200)) return false;
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
};

static uint64_t cel_pixels_hash(const NativeApp &app)
{
    uint64_t hash = UINT64_C(14695981039346656037);
    /* Use only the game viewport, so caption/popup changes cannot stand in
     * for character pixels. The surface is the real app render target. */
    for (int y = app.scene_destination.top; y <= app.scene_destination.bottom; ++y)
        for (int x = app.scene_destination.left; x <= app.scene_destination.right; ++x)
            for (size_t byte = 0; byte < 2u; ++byte) {
                hash ^= app.captions.backbuffer_pixels[static_cast<size_t>(y) * 1280u +
                    static_cast<size_t>(x) * 2u + byte];
                hash *= UINT64_C(1099511628211);
            }
    return hash;
}

static int actual_cel_conversation(CelFixture &fixture)
{
    NativeApp &app = fixture.app;
    NativeCelStats baseline{};
    native_cel_resources_stats(app.cel_resources, &baseline);
    SceneActionInfo row{};
    CHECK(app.new_game.event_flags[1567] == 0 &&
          scene_resource_action_at(app.scene, 6u, &row) == SCENE_RESOURCE_OK && row.type == SESSION_A3E_TYPE,
          "fresh original S1200 has its naturally eligible row6 cel greeting");
    ActionFamily3eDecoded greeting{};
    CHECK(action_family_3e_decode(row.raw_body, row.raw_body_length, &greeting) == ACTION_FAMILY_3E_OK &&
          std::memcmp(greeting.name, "JPJ00a", sizeof("JPJ00a")) == 0 &&
          std::memcmp(greeting.name_21, "JPJBody", sizeof("JPJBody")) == 0 &&
          std::memcmp(greeting.name_42, "JPJHead", sizeof("JPJHead")) == 0,
          "actual row6 references JPJ00a XSHEET and JPJBody/JPJHead CAL trees");
    CHECK(fixture.tick(), "actual eligible S1200 row6 must start with native cel callbacks");
    const Convo3fManager *manager = session_a3f_manager(app.a3f);
    LiveAudioPlaybackCursor voice{};
    CHECK(manager != nullptr && manager->row == 6 && manager->type == SESSION_A3E_TYPE &&
          manager->sub_state == 1u && manager->cel.last == 171 && manager->cel.loaded == 0 &&
          app.cel_reader_running, "first tick creates original JPJ00a reader before cache prefill");
    CHECK(live_audio_get_playback_cursor(app.live_audio, 12u, 0u, &voice) == LIVE_AUDIO_OK &&
          voice.loaded && !voice.started && !voice.playing && voice.source_frames == 0u,
          "first tick loads real voice channel12 without starting it");
    NativeCelStats initial{};
    native_cel_resources_stats(app.cel_resources, &initial);
    CHECK(initial.headers == baseline.headers + 1u && initial.layers == baseline.layers &&
          initial.trees >= 2u, "JPJ00a header and JPJBody/JPJHead CAL trees are owned before decode");
    int16_t body_tree = -1, head_tree = -1;
    CHECK(native_cel_resources_tree_index(app.cel_resources, "JPJBody", &body_tree) == NATIVE_CEL_OK &&
          native_cel_resources_tree_index(app.cel_resources, "JPJHead", &head_tree) == NATIVE_CEL_OK &&
          body_tree != head_tree && manager->cel.layer_tree[0] == body_tree && manager->cel.layer_tree[1] == head_tree,
          "active cel owns the actual named body and head tree identities");
    CHECK(fixture.tick(), "following media tick prefills and starts actual cel voice");
    CHECK(manager->cel.loaded == 4 && manager->cel.capacity == 4 && manager->cel.target == 0 &&
          manager->sub_state == 4u, "next tick prefills four cached frames and starts original first target");
    CHECK(live_audio_get_playback_cursor(app.live_audio, 12u, app.cel_sync_generation, &voice) == LIVE_AUDIO_OK &&
          voice.loaded && voice.started && voice.playing && voice.position_valid && voice.source_frames == 0u,
          "prefill starts actual native voice at source position zero");
    CHECK(app.cel_sync_divisor == static_cast<int32_t>(voice.sample_rate * voice.channels *
          (voice.bits_per_sample / 8u) / 15u) && app.cel_sync_divisor != 66,
          "cel sync divisor comes from original HIS byte format at15fps");
    const uint64_t generation = voice.generation;
    const uint64_t playback_render_start = live_audio_offline_frames_rendered(app.live_audio);
    uint32_t output_rate = 0u, output_channels = 0u;
    CHECK(live_audio_offline_format(app.live_audio, &output_rate, &output_channels) == LIVE_AUDIO_OK &&
          output_rate != 0u && output_channels == 2u, "actual offline native render format is available");
    CHECK(fixture.tick(), "following normal running tick announces original first frame");
    CHECK(app.cel_plan_valid && manager->cel.drawn == 0 && app.cel_draw_count == 1u,
          "normal state4 render presents original first frame0");
    const uint64_t first_pixels = cel_pixels_hash(app);
    const uint64_t first_draw_count = app.cel_draw_count;
    CHECK(fixture.tick(), "clean normal tick retains the current cel render plan");
    CHECK(cel_pixels_hash(app) == first_pixels && app.cel_draw_count == first_draw_count,
          "clean backbuffer reseed preserves character pixels without a new dirty cel plan");
    uint64_t previous_source = voice.source_frames;
    uint64_t previous_pixels = cel_pixels_hash(app);
    unsigned changed_frames = 0u, changed_pixels = 0u;
    int16_t previous_drawn = manager->cel.drawn;
    bool final_seen = false;
    for (unsigned step = 0u; step < 600u && !final_seen; ++step) {
        CHECK(fixture.tick(1600u), "real offline audio advances S1200 cel without a blocked provider");
        CHECK(live_audio_get_playback_cursor(app.live_audio, 12u, generation, &voice) == LIVE_AUDIO_OK &&
              voice.position_valid && voice.source_frames >= previous_source,
              "cel voice keeps its generation and monotone real source position");
        const uint64_t rendered_delta = live_audio_offline_frames_rendered(app.live_audio) - playback_render_start;
        const uint64_t consumed = std::min<uint64_t>(rendered_delta * voice.sample_rate / output_rate,
            voice.source_frame_count);
        CHECK(voice.source_frames == consumed && voice.decoded_byte_position == consumed *
              voice.channels * (voice.bits_per_sample / 8u),
              "voice source position follows frames actually rendered since the accepted play");
        const int16_t source_frame = voice.playing ? static_cast<int16_t>(std::min<uint64_t>(
            voice.decoded_byte_position / static_cast<uint32_t>(app.cel_sync_divisor), 171u)) : 171;
        CHECK(manager->cel.frame == source_frame,
              "kernel cel target follows the real decoded source-byte position at15fps");
        const uint64_t pixels = cel_pixels_hash(app);
        if (manager->cel.drawn != previous_drawn) {
            ++changed_frames;
            if (pixels != previous_pixels) ++changed_pixels;
            previous_drawn = manager->cel.drawn;
        }
        previous_pixels = pixels;
        previous_source = voice.source_frames;
        final_seen = manager->cel.drawn == 171 && manager->cel.final_seen != 0;
    }
    if (!final_seen) fixture.print_log_tail();
    CHECK(final_seen && changed_frames > 2u && changed_pixels > 2u && voice.source_frames > 0u,
          "real source audio changes cel frames and rendered pixels through last171");
    CHECK(session_a3f_response_count(app.a3f) > 0 && app.a3f_caption.ready,
          "original greeting offers actual caption response controls");
    int choice = -1;
    int16_t target_scene = 0;
    int32_t pointer_x = 0, pointer_y = 0;
    for (int i = 0; i < manager->response_count; ++i) {
        if (manager->responses[i].scene != 1202 && manager->responses[i].scene != 1222) continue;
        const int16_t *r = app.a3f_caption.result.choices[i].rect;
        const CaptionRect &dst = app.captions.framed_destination;
        const CaptionRect &scroll = app.a3f_caption.popup.g.scroll_src;
        const int32_t x = (r[0] + r[2]) / 2 + dst.left - scroll.left;
        const int32_t y = (r[1] + r[3]) / 2 + dst.top - scroll.top;
        if (x < dst.left || x > dst.right || y < dst.top || y > dst.bottom) continue;
        choice = i; target_scene = manager->responses[i].scene; pointer_x = x; pointer_y = y; break;
    }
    CHECK(choice >= 0, "an actual S1202/S1222 response is visible in original popup geometry");
    pointer(&app, BLACKMOOR_POINTER_MOVE, pointer_x, pointer_y, 0u);
    CHECK(fixture.tick(), "real pointer hover reaches response UI");
    CHECK(app.a3f_caption.hover == choice, "actual popup hit test selects original response rectangle");
    pointer(&app, BLACKMOOR_POINTER_DOWN, pointer_x, pointer_y, 0u);
    CHECK(fixture.tick(), "real response primary down advances normally");
    pointer(&app, BLACKMOOR_POINTER_UP, pointer_x, pointer_y, 0u);
    CHECK(fixture.tick(), "real response release reaches the conversation kernel");
    bool following_started = false;
    for (unsigned step = 0u; step < 900u && !following_started; ++step) {
        CHECK(fixture.tick(1600u), "actual response voice and scene transition advance normally");
        manager = session_a3f_manager(app.a3f);
        LiveAudioPlaybackCursor following{};
        following_started = app.current_scene_id == target_scene && manager &&
            manager->type == SESSION_A3E_TYPE && manager->sub_state == 4u &&
            app.cel_reader_running && manager->cel.loaded >= 4 &&
            live_audio_get_playback_cursor(app.live_audio, 12u, app.cel_sync_generation, &following) == LIVE_AUDIO_OK &&
            following.started && following.playing && following.generation != generation;
    }
    if (!following_started) fixture.print_log_tail();
    CHECK(following_started, "actual selected scene loads and starts its following cel conversation");
    LiveAudioPlaybackCursor stale{};
    CHECK(live_audio_get_playback_cursor(app.live_audio, 12u, generation, &stale) == LIVE_AUDIO_ERR_STALE,
          "following real voice replaces the prior source-cursor generation");
    std::printf("CEL_PROGRESS captions=%u scene=1200 row=6 prefill=4 last=%d frame_changes=%u pixel_changes=%u source_frames=%llu generation=%llu\n",
        app.closed_captioning, 171, changed_frames, changed_pixels,
        static_cast<unsigned long long>(voice.source_frames), static_cast<unsigned long long>(generation));
    /* Exercise the production cleanup order while the following cel still
     * owns a header and cache. Keep adapters alive to inspect release counts. */
    scene_session_destroy(app.session); app.session = nullptr;
    session_a3f_destroy(app.a3f); app.a3f = nullptr;
    NativeCelStats released{};
    native_cel_resources_stats(app.cel_resources, &released);
    CHECK(released.headers == baseline.headers && released.header_bytes == baseline.header_bytes &&
          released.layers == baseline.layers && released.layer_bytes == baseline.layer_bytes &&
          app.cel_images.empty() && !app.cel_reader_created && !app.cel_reader_running &&
          !app.cel_plan_valid && app.cel_sync_generation == 0u,
          "normal kernel cleanup returns owned headers/layers and app render handles to baseline");
    std::printf("CEL_RESPONSE captions=%u choice=%d target=%d following_started=1 cleanup_headers=%zu cleanup_layers=%zu muted_frames=%llu\n",
        app.closed_captioning, choice, target_scene, released.headers, released.layers,
        static_cast<unsigned long long>(fixture.muted_frames));
    return 0;
}

static void cel_fixture_signal(int number)
{
    static const char prefix[] = "cel fixture/native signal failure number=";
    const char digits[] = {static_cast<char>('0' + number / 10), static_cast<char>('0' + number % 10), '\n'};
    (void)write(STDERR_FILENO, prefix, sizeof(prefix) - 1u);
    (void)write(STDERR_FILENO, digits, sizeof digits);
    _exit(128 + number);
}

int main(int argc, char **argv)
{
    std::signal(SIGBUS, cel_fixture_signal); std::signal(SIGSEGV, cel_fixture_signal);
    std::signal(SIGABRT, cel_fixture_signal); std::signal(SIGILL, cel_fixture_signal);
    @autoreleasepool {
        CHECK(argc == 3, "owner-local game directory and caption setting required");
        CelFixture fixture;
        const bool initialized = fixture.initialize(argv[1], std::strcmp(argv[2], "on") == 0);
        if (!initialized) fixture.print_log_tail();
        CHECK(initialized, "actual S1200 component initializes");
        return actual_cel_conversation(fixture);
    }
}
