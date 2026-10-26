/* NATIVE-14: actual BOOT/new-game, S4408 and random-movie providers.
 * S4408 is a component, not a complete story-route claim. No story/item/phase
 * injection, original-code oracle, window or output device. */
#define main blackmoor_app_entry_for_random_movie_test
#ifndef NATIVE_RANDOM_MOVIE_APP_SOURCE
#define NATIVE_RANDOM_MOVIE_APP_SOURCE "../src/blackmoor_app.mm"
#endif
#include NATIVE_RANDOM_MOVIE_APP_SOURCE
#undef main
#include <csignal>

#define CHECK(condition, message) do { if (!(condition)) { \
    std::fprintf(stderr, "CHECK failed: %s\n", message); return 1; } } while (0)

struct RandomMovieFixture {
    NativeApp app;
    uint32_t now = 1000;
    uint64_t muted_frames = 0;
    ~RandomMovieFixture() { cleanup(&app); }

    void print_log_tail()
    {
        if (app.log == nullptr) return;
        std::fflush(app.log); std::rewind(app.log);
        char line[1024]{};
        std::vector<std::string> lines;
        while (std::fgets(line, sizeof(line), app.log) != nullptr) lines.emplace_back(line);
        for (size_t i = lines.size() > 16u ? lines.size() - 16u : 0u; i < lines.size(); ++i)
            std::fprintf(stderr, "%s", lines[i].c_str());
    }
    bool initialize(const char *directory, int16_t scene_id = 4408, uint32_t seed = 8u)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"BlackmoorAudioMuted"];
        app.game_directory = directory;
        app.log = std::tmpfile();
        app.bar_missing = true; /* Taskbar interaction is outside this component. */
        app.scene_runtime_enabled = true;
        app.condition_rand_seed = seed;
        app.condition_rand_seed_set = true; /* Existing canonical CRT RNG configuration, not a forced clip/phase. */
        if (app.log == nullptr || session_input_init(&app.input_state) != SESSION_INPUT_OK) return false;
        int external = 0;
        char error[256]{};
        if (!game_ini_configuration(app.game_directory, &external, &app.closed_captioning)) return false;
        app.resources = game_resources_open((app.game_directory + "/Ciftree").c_str(), external, error, sizeof(error));
        GameResourceBytes boot = GAME_RESOURCE_BYTES_INIT;
        if (app.resources == nullptr || !game_resources_load_bytes(app.resources, "BOOT", &boot, error, sizeof(error))) return false;
        app.boot = engine_boot_open_memory(boot.bytes, boot.length, error, sizeof(error));
        game_resource_bytes_destroy(&boot);
        if (app.boot == nullptr || world_init_cold_zero_event_flags(&app.new_game.action_core) != WORLD_INIT_OK ||
            !load_viewport(&app) || !initialize_caption_runtime(&app) || !initialize_new_game(&app, now)) return false;
        LiveAudioConfig audio{};
        audio.game_directory = directory; audio.mode = MAC_AUDIO_MODE_OFFLINE;
        if (live_audio_create(&audio, &app.live_audio, error, sizeof(error)) != LIVE_AUDIO_OK) {
            std::fprintf(stderr, "random-movie offline audio: %s\n", error);
            return false;
        }
        app.offline_audio_frames_per_update = 1u; /* Select the real mixer-derived canonical media clock. */
        app.framebuffer.resize(640u * 480u * 4u);
        /* The real S4412 -> S4408 entry carries selector/scroll0. The
         * ordinary 0b world provider requires this navigation context. */
        app.selector_entry_valid = true;
        app.selector_entry_frame = 0;
        app.selector_entry_scroll = 0;
        if (!load_scene(&app, scene_id)) return false;
        const ActionFamily28Rect view = {app.scene_destination.left, app.scene_destination.top,
                                         app.scene_destination.right, app.scene_destination.bottom};
        return session_exit_init(&app.exit_state, &view) == SESSION_EXIT_OK && create_native_scene_session(&app);
    }
    bool tick(uint64_t frames = 0)
    {
        if (frames != 0u && !render_audio(frames)) return false;
        uint32_t rate = 0, channels = 0;
        if (live_audio_offline_format(app.live_audio, &rate, &channels) != LIVE_AUDIO_OK || rate == 0u) return false;
        now = 1000u + static_cast<uint32_t>(live_audio_offline_frames_rendered(app.live_audio) * 1000u / rate);
        update(&app, now);
        if (app.failure || app.session_block_reported) { print_log_tail(); return false; }
        return true;
    }
    bool render_audio(uint64_t frames)
    {
        LiveAudioOfflineStats stats{};
        if (live_audio_advance_offline(app.live_audio, frames, &stats, nullptr, 0u) != LIVE_AUDIO_OK ||
            stats.frames != frames || stats.nonfinite_samples != 0u || stats.nonzero_samples != 0u) return false;
        muted_frames += stats.frames;
        return true;
    }
    bool row0(SceneActionRuntimeState *state) const
    { return scene_session_get_action_state(app.session, 0u, state) == SCENE_SESSION_OK; }
    bool tick_to(uint32_t target_ms)
    {
        uint32_t rate = 0, channels = 0;
        if (target_ms < now || live_audio_offline_format(app.live_audio, &rate, &channels) != LIVE_AUDIO_OK || !rate) return false;
        const uint64_t wanted = (static_cast<uint64_t>(target_ms - 1000u) * rate + 999u) / 1000u;
        const uint64_t current = live_audio_offline_frames_rendered(app.live_audio);
        return tick(wanted > current ? wanted - current : 0u) && now == target_ms;
    }
    bool start()
    {
        if (!tick()) return false;
        for (unsigned i = 0; i < 4u && session_a2d_object(app.a2d)->movie.flag_206 == 0; ++i)
            if (!tick()) return false;
        const D2Object *object = session_a2d_object(app.a2d);
        return object->movie.active && object->movie.flag_206 && object->frame_232 == 0;
    }
    bool last_frame()
    {
        for (unsigned i = 0; i < 40u && session_a2d_object(app.a2d)->movie.state_1de == 0; ++i)
            if (!tick(3200u)) return false;
        return session_a2d_object(app.a2d)->movie.state_1de == 3 && session_a2d_object(app.a2d)->frame_232 == 15;
    }
};

struct MovieSet {
    D2Set set{};
    ~MovieSet() { d2_set_free(&set); }
    bool load(NativeApp *app, int scene_id, size_t row)
    {
        GameResourceBytes bytes = GAME_RESOURCE_BYTES_INIT;
        char error[256]{};
        const std::string name = "S" + std::to_string(scene_id);
        if (!game_resources_load_bytes(app->resources, name.c_str(), &bytes, error, sizeof(error))) return false;
        SceneResource *scene = scene_resource_open_memory(bytes.bytes, bytes.length, error, sizeof(error));
        game_resource_bytes_destroy(&bytes);
        if (!scene) return false;
        SceneActionInfo action{};
        const char *why = nullptr;
        const bool okay = scene_resource_action_at(scene, row, &action) == SCENE_RESOURCE_OK && action.type == SESSION_A2D_TYPE &&
            d2_set_parse(action.typed_body, action.typed_body_length, &set, &why) == D2_OK;
        scene_resource_close(scene);
        return okay;
    }
};

static std::string movie_asset(const std::string &game, const std::string &name, const char *extension)
{
    const std::string directory = game + "/CDVideo", wanted = name + "." + extension;
    DIR *dir = opendir(directory.c_str());
    if (!dir) return {};
    std::string found;
    unsigned count = 0;
    while (dirent *entry = readdir(dir)) {
        const std::string candidate = entry->d_name;
        if (candidate.size() != wanted.size()) continue;
        bool same = true;
        for (size_t i = 0; i < wanted.size(); ++i) {
            unsigned char a = candidate[i], b = wanted[i];
            if (a >= 'a' && a <= 'z') a -= 'a' - 'A';
            if (b >= 'a' && b <= 'z') b -= 'a' - 'A';
            if (a != b) { same = false; break; }
        }
        if (same) { found = directory + "/" + candidate; ++count; }
    }
    closedir(dir);
    return count == 1u ? found : std::string{};
}

struct MovieMetadata {
    uint32_t frames = 0, width = 0, height = 0, rate_num = 0, rate_den = 0, audio = 0;
};
static bool movie_metadata(const std::string &path, MovieMetadata *out)
{
    std::unique_ptr<FILE, decltype(&std::fclose)> input(std::fopen(path.c_str(), "rb"), &std::fclose);
    uint8_t header[44]{};
    if (!input || std::fread(header, 1u, sizeof(header), input.get()) != sizeof(header) || std::memcmp(header, "BIKi", 4u)) return false;
    auto word = [&](size_t at) { return static_cast<uint32_t>(header[at]) | static_cast<uint32_t>(header[at + 1]) << 8 |
        static_cast<uint32_t>(header[at + 2]) << 16 | static_cast<uint32_t>(header[at + 3]) << 24; };
    *out = {word(8), word(20), word(24), word(28), word(32), word(40)};
    return true;
}

struct MoviePixels {
    std::vector<uint8_t> rgba;
    uint32_t width = 0, height = 0;
    int32_t frame = -1;
    uint64_t generation = 0;
};
static bool copied_movie_frame(RandomMovieFixture &f, MoviePixels *out)
{
    NativeRandomMovieFrame frame{};
    const D2Object *object = session_a2d_object(f.app.a2d);
    if (native_random_movie_frame(f.app.a2d_media, object->surface_212, &frame) || !frame.rgba ||
        frame.width != 620u || frame.height != 375u || frame.stride < frame.width * 4u ||
        frame.rgba_bytes < static_cast<size_t>(frame.height - 1) * frame.stride + frame.width * 4u) return false;
    out->width = frame.width; out->height = frame.height; out->frame = frame.current_frame; out->generation = frame.generation;
    out->rgba.resize(static_cast<size_t>(frame.width) * frame.height * 4u);
    for (size_t y = 0; y < frame.height; ++y)
        std::memcpy(out->rgba.data() + y * frame.width * 4u, frame.rgba + y * frame.stride, frame.width * 4u);
    return true;
}

/* Independent player instance verifies adapter frame order/copy lifetime.
 * Both use the native decoder; this is not original Bink SDK codec parity. */
static bool reference_frame(const std::string &path, uint32_t zero_based, MoviePixels *out)
{
    BinkPlayer *raw = nullptr;
    BinkPlayerInfo info{};
    char error[256]{};
    if (bink_player_open(path.c_str(), &raw, &info, error, sizeof(error)) != BINK_PLAYER_OK) return false;
    std::unique_ptr<BinkPlayer, decltype(&bink_player_close)> player(raw, &bink_player_close);
    BinkPlayerFrame frame{};
    if (bink_player_seek(player.get(), zero_based + 1u, 0u, error, sizeof(error)) != BINK_PLAYER_OK ||
        bink_player_advance(player.get(), 0u, &frame, error, sizeof(error)) != BINK_PLAYER_OK ||
        frame.current_frame != static_cast<int32_t>(zero_based)) return false;
    out->width = frame.width; out->height = frame.height; out->frame = frame.current_frame;
    out->rgba.resize(static_cast<size_t>(frame.width) * frame.height * 4u);
    for (size_t y = 0; y < frame.height; ++y)
        std::memcpy(out->rgba.data() + y * frame.width * 4u, frame.rgba + y * frame.stride, frame.width * 4u);
    return true;
}

static bool viewport_matches(RandomMovieFixture &f, const MoviePixels &frame)
{
    D2RenderPlan plan{};
    if (session_a2d_render_plan(f.app.a2d, &plan) != D2_OK || !plan.valid ||
        plan.src[0] != 0 || plan.src[1] != 0 || plan.src[2] != 619 || plan.src[3] != 374 ||
        plan.dst[0] != 10 || plan.dst[1] != 10 || plan.dst[2] != 629 || plan.dst[3] != 384) return false;
    for (size_t y = 0; y < frame.height; ++y) for (size_t x = 0; x < frame.width; ++x) {
        const uint8_t *source = frame.rgba.data() + (y * frame.width + x) * 4u;
        const uint8_t *actual = f.app.framebuffer.data() + ((y + 10u) * 640u + x + 10u) * 4u;
        const uint8_t expected[4] = {static_cast<uint8_t>((source[0] >> 3) * 255u / 31u),
            static_cast<uint8_t>((source[1] >> 3) * 255u / 31u), static_cast<uint8_t>((source[2] >> 3) * 255u / 31u), 255u};
        if (std::memcmp(actual, expected, sizeof(expected))) return false;
    }
    return true;
}

static int actual_random_movie(RandomMovieFixture &f)
{
    SceneActionInfo action{};
    CHECK(f.app.current_scene_id == 4408 && scene_resource_action_at(f.app.scene, 0u, &action) == SCENE_RESOURCE_OK &&
          action.type == SESSION_A2D_TYPE && action.typed_body_length == 1144u && action.dependency_count == 0u,
          "actual S4408 row0 is the dependency-free nine-entry mode1 RandomMovie set");
    D2Set set{};
    const char *why = nullptr;
    const int parsed = d2_set_parse(action.typed_body, action.typed_body_length, &set, &why);
    const bool correct_set = parsed == D2_OK && set.mode_word == 1 && set.entry_count == 9 && set.group_count == 1;
    d2_set_free(&set);
    CHECK(correct_set, "actual S4408 mode/entry/group metadata matches the original set");
    CHECK(f.start(), "actual S4408 random movie starts and decodes through the native media provider");
    SceneActionRuntimeState state{};
    CHECK(f.row0(&state) && state.phase == 1u && state.completed == 0u && session_a2d_object(f.app.a2d)->movie.active != 0,
          "the actual random-movie kernel enters active running phase1");
    D2RenderPlan plan{};
    CHECK(session_a2d_object(f.app.a2d)->movie.flag_206 != 0 && session_a2d_render_plan(f.app.a2d, &plan) == D2_OK && plan.valid,
          "actual selected movie produces a decoded frame and valid native render plan");
    const D2Object *object = session_a2d_object(f.app.a2d);
    const std::string path = movie_asset(f.app.game_directory, object->name_159, "bik");
    MovieMetadata metadata{};
    MoviePixels first{}, reference{}, current{};
    CHECK(object->clip_246 == 0 && movie_metadata(path, &metadata) && metadata.frames == 76u && metadata.audio == 0u &&
          copied_movie_frame(f, &first) && first.frame == 0 && reference_frame(path, 0u, &reference) &&
          first.rgba == reference.rgba && viewport_matches(f, reference),
          "canonical seed8 naturally selects real AA: frame0 pixels match an independent player and original view10,10 crop");
    for (unsigned i = 0; i < 3u; ++i)
        CHECK(f.tick() && copied_movie_frame(f, &current) && current.frame == 0 && current.generation == first.generation && current.rgba == first.rgba,
              "not-due canonical mixer clock ticks neither decode nor advance the current copied frame");
    CHECK(f.last_frame() && copied_movie_frame(f, &current) && current.frame == 15 &&
          reference_frame(path, 15u, &reference) && current.rgba == reference.rgba && viewport_matches(f, reference),
          "entry frame15 is actually presented and ends the kernel clip despite AA's76-frame container");
    std::printf("RANDOM_MOVIE_FRAMES scene=4408 clip=0 container_frames=76 first=0 final=15 pixels_each=232500 not_due_stable=1 viewport=10,10,629,384\n");
    return 0;
}

static int weighted_hold(RandomMovieFixture &f)
{
    CHECK(f.start() && session_a2d_object(f.app.a2d)->clip_246 == 0 && f.last_frame(), "canonical RNG naturally reaches AA's final frame");
    MoviePixels held{}, current{};
    CHECK(copied_movie_frame(f, &held) && held.frame == 15 && f.tick(), "actual final frame is copied before weighted repick");
    const D2Object *object = session_a2d_object(f.app.a2d);
    CHECK(object->movie.state_1de == 1 && object->record_256 == -1 && object->bink_id_18e == 0 &&
          object->delay_252 >= object->set->entries[0].delay_min && object->delay_252 < object->set->entries[0].delay_max &&
          copied_movie_frame(f, &current) && current.generation == held.generation && current.rgba == held.rgba && viewport_matches(f, held),
          "weighted stay closes the decoder and retains the actual final surface for the original delay range");
    const uint32_t deadline = object->deadline_24e;
    CHECK(f.tick_to(deadline - 1u) && session_a2d_object(f.app.a2d)->movie.state_1de == 1 &&
          copied_movie_frame(f, &current) && current.generation == held.generation && current.rgba == held.rgba,
          "real mixer time before deadline holds frame15 without replay or decoder ownership");
    CHECK(f.tick_to(deadline) && session_a2d_object(f.app.a2d)->movie.state_1de == 3,
          "deadline equality returns the original kernel to weighted repick rather than replaying the pose");
    unsigned repicks = 0;
    while (session_a2d_object(f.app.a2d)->movie.state_1de != 0 && repicks++ < 16u) {
        object = session_a2d_object(f.app.a2d);
        if (object->movie.state_1de == 1) CHECK(f.tick_to(object->deadline_24e), "further weighted stays finish through real mixer deadlines");
        CHECK(f.tick(), "the real kernel performs the next weighted selection");
    }
    object = session_a2d_object(f.app.a2d);
    CHECK(object->movie.state_1de == 0 && object->clip_246 != 0 && object->record_256 >= 0 &&
          std::strcmp(object->name_159, object->set->entries[0].records[object->record_256].name) == 0 && f.tick() &&
          copied_movie_frame(f, &current) && current.frame == 0 && current.generation > held.generation,
          "a natural weighted outgoing record opens its named clip and publishes its real first frame");
    std::printf("RANDOM_MOVIE_HOLD retained_frame=15 decoder_closed=1 delay_boundary=1 repicks=%u reloaded_frame=0\n", repicks);
    return 0;
}

static int selector_visibility(RandomMovieFixture &f)
{
    CHECK(f.start() && f.app.nav_scene_ready, "actual first-frame surface and navigation selector exist");
    MoviePixels before{}, after{};
    CHECK(copied_movie_frame(f, &before), "selected movie frame is owned");
    const auto flags = f.app.new_game.event_flags;
    SceneActionInfo action{};
    SceneActionRuntimeState state{};
    CHECK(scene_resource_action_at(f.app.scene, 0u, &action) == SCENE_RESOURCE_OK && f.row0(&state) && state.phase == 1u,
          "component selector test uses the live row's natural phase1");
    /* D2 input-leaf component only: restore the navigation selector before
     * any normal navigation/session update, without changing story/phase. */
    const int16_t selector = f.app.nav.selector;
    f.app.nav.selector = 1;
    SceneActionHandlerResult result{};
    const int hidden = native_a2d_handler(&f.app, 0u, &action, &state, &result);
    f.app.nav.selector = selector;
    D2RenderPlan plan{};
    CHECK(hidden == SCENE_ACTION_HANDLER_OK && session_a2d_world(f.app.a2d)->entry_flag == 0 &&
          session_a2d_render_plan(f.app.a2d, &plan) == D2_OK && plan.valid && seed_native_caption_backbuffer(&f.app),
          "unmatched selector clears the outer entry gate while the retained callback plan remains valid");
    const auto base = f.app.captions.backbuffer_pixels;
    CHECK(native_a2d_compose(&f.app) && f.app.captions.backbuffer_pixels == base,
          "outer entry gate prevents a stale valid movie surface from painting on selector miss");
    CHECK(native_a2d_handler(&f.app, 0u, &action, &state, &result) == SCENE_ACTION_HANDLER_OK &&
          session_a2d_world(f.app.a2d)->entry_flag == 1 && seed_native_caption_backbuffer(&f.app) &&
          native_a2d_compose(&f.app) && native_caption_present_rgba(&f.app) && copied_movie_frame(f, &after) &&
          after.generation == before.generation && after.rgba == before.rgba && viewport_matches(f, before) && f.app.new_game.event_flags == flags,
          "restored selector shows the same owned frame at the BOOT view offset without re-decoding or story effects");
    std::printf("RANDOM_MOVIE_SELECTOR miss_hidden=1 retained_plan_valid=1 restored_same_generation=1\n");
    return 0;
}

static int bottom_stop_reentry(RandomMovieFixture &f)
{
    const int32_t initial_modal = f.app.captions.lifecycle.g.modal_input;
    CHECK(f.start() && session_a2d_object(f.app.a2d)->saved_202 == initial_modal && f.app.captions.lifecycle.g.modal_input == 0,
          "mode1 starts with the original canonical modal cell saved and cleared");
    const uint32_t surface = session_a2d_object(f.app.a2d)->surface_212;
    pointer(&f.app, BLACKMOOR_POINTER_MOVE, 320, 370, 0);
    CHECK(f.tick() && f.app.input_state.candidate == 2, "real bottom hotspot is selected through actual pointer input");
    pointer(&f.app, BLACKMOOR_POINTER_DOWN, 320, 370, 0);
    pointer(&f.app, BLACKMOOR_POINTER_UP, 320, 370, 0);
    CHECK(f.tick(), "real bottom release executes original event/2e stop sequence");
    SceneActionRuntimeState row{};
    SceneTransitionRequest transition{};
    NativeRandomMovieFrame absent{};
    CHECK(f.row0(&row) && row.completed == 1u && row.phase == 0u && !session_a2d_object(f.app.a2d)->movie.active &&
          f.app.captions.lifecycle.g.modal_input == initial_modal && session_a2d_world(f.app.a2d)->entry_flag == 0 &&
          native_random_movie_frame(f.app.a2d_media, surface, &absent) != 0 &&
          scene_session_get_pending_transition(f.app.session, &transition) != 0 && transition.target_scene == 4412,
          "raw2e stop retires the original row, releases its media/surface, restores canonical modal and requests4412");
    for (unsigned i = 0; f.app.current_scene_id != 4412 && i < 8u; ++i) CHECK(f.tick(), "normal exit/load completes the bottom transition");
    CHECK(f.app.current_scene_id == 4412, "actual backout loads4412");
    transition = {}; transition.target_scene = 4408;
    CHECK(scene_session_request_external_transition(f.app.session, &transition) == SCENE_SESSION_OK,
          "stopped component requests re-entry through the ordinary external-transition path");
    for (unsigned i = 0; f.app.current_scene_id != 4408 && i < 8u; ++i) CHECK(f.tick(), "inactive movie permits normal scene replacement");
    pointer(&f.app, BLACKMOOR_POINTER_MOVE, 0, 0, 0);
    for (unsigned i = 0; !session_a2d_object(f.app.a2d)->movie.flag_206 && i < 6u; ++i) CHECK(f.tick(), "real intro/dispatcher reconstructs the new random movie");
    MoviePixels frame{};
    CHECK(f.app.current_scene_id == 4408 && session_a2d_object(f.app.a2d)->movie.active && copied_movie_frame(f, &frame) &&
          frame.frame == 0 && session_a2d_object(f.app.a2d)->surface_212 != 0,
          "re-entry owns a fresh real first frame without stale retired-row or released-surface state");
    std::printf("RANDOM_MOVIE_STOP pointer_row=2 retired_row=0 target=4412 modal_restored=1 reentry=4408 frame=0\n");
    return 0;
}

static int corpus_metadata(RandomMovieFixture &f)
{
    std::map<std::string, MovieMetadata> assets;
    const int scenes[3] = {3336, 3440, 4408};
    const size_t rows[3] = {3u, 0u, 0u};
    size_t references = 0, long_containers = 0;
    for (unsigned which = 0; which < 3u; ++which) {
        MovieSet owned;
        CHECK(owned.load(&f.app, scenes[which], rows[which]), "actual raw2d resource row parses");
        const D2Set &set = owned.set;
        CHECK(set.mode_word == 1 && set.entry_count == (which == 2u ? 9 : 40) && set.group_count == 1 &&
              native_random_movie_validate_set(f.app.a2d_media, &set) == 0,
              "every actual set passes the real silent-Bink metadata preflight");
        size_t records = 0;
        for (int i = 0; i < set.entry_count; ++i) {
            const D2Entry &entry = set.entries[i];
            MovieMetadata meta{};
            CHECK(entry.word_21 == 0 && entry.word_23 == (which == 2u ? 15 : 14) &&
                  movie_metadata(movie_asset(f.app.game_directory, entry.name, "bik"), &meta) &&
                  meta.width == 620u && meta.height == 375u && meta.rate_num == 15u && meta.rate_den == 1u && meta.audio == 0u &&
                  meta.frames > static_cast<uint32_t>(entry.word_23),
                  "original file headers independently confirm each entry's dimensions, frame bounds, rate and silence");
            if (assets.emplace(entry.name, meta).second && meta.frames == 76u) ++long_containers;
            records += static_cast<size_t>(entry.record_count); ++references;
        }
        CHECK(records == (which == 2u ? 18u : 136u), "actual weighted record tables remain complete");
    }
    CHECK(assets.size() == 49u && references == 89u && long_containers == 1u,
          "all3 original sets cover exactly49unique silent Binks and the single longer AA container");
    std::printf("RANDOM_MOVIE_CORPUS sets=3 references=89 unique_assets=49 audio_tracks=0 linda_last=15 loulou_last=14 long_containers=1\n");
    return 0;
}

struct ScratchMovieDirectory {
    std::string root;
    std::vector<std::string> links;
    ~ScratchMovieDirectory() {
        for (const auto &path : links) unlink(path.c_str());
        if (!root.empty()) { rmdir((root + "/HDVideo").c_str()); rmdir((root + "/CDVideo").c_str()); rmdir(root.c_str()); }
    }
    bool create() {
        char pattern[] = "/private/tmp/blackmoor-random-preflight-XXXXXX";
        char *path = mkdtemp(pattern);
        if (!path) return false;
        root = path;
        return mkdir((root + "/HDVideo").c_str(), 0700) == 0 && mkdir((root + "/CDVideo").c_str(), 0700) == 0;
    }
    bool link(const std::string &source, const char *relative) {
        const std::string path = root + "/" + relative;
        if (source.empty() || symlink(source.c_str(), path.c_str()) != 0) return false;
        links.push_back(path); return true;
    }
};

static std::string avf_background_name(NativeApp *app)
{
    GameResourceBytes bytes = GAME_RESOURCE_BYTES_INIT;
    char error[256]{};
    if (!game_resources_load_bytes(app->resources, "S3395", &bytes, error, sizeof(error))) return {};
    SceneResource *scene = scene_resource_open_memory(bytes.bytes, bytes.length, error, sizeof(error));
    game_resource_bytes_destroy(&bytes);
    if (!scene) return {};
    SceneResourceSummary summary{};
    const bool okay = scene_resource_get_summary(scene, &summary) == SCENE_RESOURCE_OK;
    scene_resource_close(scene);
    return okay ? std::string(summary.background) : std::string{};
}

static int unsupported_preflight(RandomMovieFixture &f)
{
    CHECK(f.start(), "actual live movie supplies a retained-frame witness for pure preflight checks");
    MoviePixels before{}, after{};
    CHECK(copied_movie_frame(f, &before), "live movie frame exists before unsupported media queries");
    const auto flags = f.app.new_game.event_flags;
    std::array<uint8_t, sizeof(f.app.condition_rand)> rng{};
    std::memcpy(rng.data(), &f.app.condition_rand, rng.size());
    const std::string audio_name = "EXT_OpnCin_ANIM", avf_name = avf_background_name(&f.app);
    const std::string audio_path = movie_asset(f.app.game_directory, audio_name, "bik");
    const std::string avf_path = movie_asset(f.app.game_directory, avf_name, "avf");
    MovieMetadata audio{};
    CHECK(movie_metadata(audio_path, &audio) && audio.audio > 0u && !avf_path.empty(),
          "unsupported fixtures are valid owner-local soundtrack Bink and AVF assets, with no corrupted files");
    D2Entry entry{};
    D2Set set{};
    std::memcpy(set.name, "RandomMovie", 12u); set.mode_word = 1; set.entry_count = 1; set.entries = &entry;
    std::memcpy(entry.name, audio_name.c_str(), audio_name.size() + 1u);
    CHECK(native_random_movie_validate_set(f.app.a2d_media, &set) != 0 &&
          std::strstr(native_random_movie_failure(f.app.a2d_media), "soundtrack"),
          "valid embedded-audio Bink is explicitly refused before gameplay effects");
    CHECK(avf_name.size() < sizeof(entry.name), "actual AVF name fits the original resource field");
    std::memset(entry.name, 0, sizeof(entry.name)); std::memcpy(entry.name, avf_name.c_str(), avf_name.size() + 1u);
    CHECK(native_random_movie_validate_set(f.app.a2d_media, &set) != 0 &&
          std::strstr(native_random_movie_failure(f.app.a2d_media), "AVF"), "valid AVF is explicitly refused by preflight");
    const D2Object *object = session_a2d_object(f.app.a2d);
    const std::string silent_path = movie_asset(f.app.game_directory, object->name_159, "bik");
    std::memset(entry.name, 0, sizeof(entry.name)); std::memcpy(entry.name, object->name_159, sizeof(entry.name)); entry.word_23 = 76;
    CHECK(native_random_movie_validate_set(f.app.a2d_media, &set) != 0 &&
          std::strstr(native_random_movie_failure(f.app.a2d_media), "frame bounds"), "out-of-container entry end is refused without opening/replacing a live stream");
    ScratchMovieDirectory scratch;
    CHECK(scratch.create() && scratch.link(audio_path, "HDVideo/fixture.BIK") && scratch.link(silent_path, "CDVideo/fixture.bik"),
          "private priority fixture links valid original assets without copying or changing their bytes");
    NativeRandomMovieHost host{&f.app, native_a35_clock, native_a2d_tick, native_a2d_random};
    NativeRandomMovie *raw = nullptr;
    CHECK(native_random_movie_create(scratch.root.c_str(), &host, &raw) == 0, "private metadata-only media owner initializes");
    std::unique_ptr<NativeRandomMovie, decltype(&native_random_movie_destroy)> media(raw, &native_random_movie_destroy);
    std::memset(entry.name, 0, sizeof(entry.name)); std::memcpy(entry.name, "fixture", 8u); entry.word_23 = 0;
    CHECK(native_random_movie_validate_set(media.get(), &set) != 0 && std::strstr(native_random_movie_failure(media.get()), "soundtrack"),
          "higher-priority HD Bink wins over silent CD Bink even when both names exist");
    CHECK(unlink((scratch.root + "/HDVideo/fixture.BIK").c_str()) == 0 && scratch.link(avf_path, "HDVideo/fixture.avf") &&
          native_random_movie_validate_set(media.get(), &set) == 0, "CD Bink takes priority over HD AVF in original four-tier probe order");
    CHECK(copied_movie_frame(f, &after) && after.generation == before.generation && after.rgba == before.rgba &&
          f.app.new_game.event_flags == flags && std::memcmp(rng.data(), &f.app.condition_rand, rng.size()) == 0 &&
          session_a2d_object(f.app.a2d)->movie.active && !f.app.failure,
          "unsupported metadata and priority queries preserve live copied pixels, stream/controller, RNG and story state");
    std::printf("RANDOM_MOVIE_PREFLIGHT audio_refused=1 avf_refused=1 bounds_refused=1 HD_BIK_before_CD_BIK=1 CD_BIK_before_HD_AVF=1 live_unchanged=1\n");
    return 0;
}
static void fixture_signal(int number)
{
    static const char prefix[] = "fixture/native signal failure number=";
    const char digits[] = {static_cast<char>('0' + number / 10), static_cast<char>('0' + number % 10), '\n'};
    (void)write(STDERR_FILENO, prefix, sizeof(prefix) - 1);
    (void)write(STDERR_FILENO, digits, sizeof(digits));
    _exit(128 + number);
}
int main(int argc, char **argv)
{
    std::signal(SIGBUS, fixture_signal); std::signal(SIGSEGV, fixture_signal);
    std::signal(SIGABRT, fixture_signal); std::signal(SIGILL, fixture_signal);
    @autoreleasepool {
        if (argc != 4 || std::strcmp(argv[1], "--random-movie-component") != 0) return 2;
        RandomMovieFixture fixture;
        if (!fixture.initialize(argv[2])) { fixture.print_log_tail(); CHECK(false, "actual BOOT/new-game/S4408 component initializes"); }
        if (std::strcmp(argv[3], "start") == 0) return actual_random_movie(fixture);
        if (std::strcmp(argv[3], "hold") == 0) return weighted_hold(fixture);
        if (std::strcmp(argv[3], "selector") == 0) return selector_visibility(fixture);
        if (std::strcmp(argv[3], "stop") == 0) return bottom_stop_reentry(fixture);
        if (std::strcmp(argv[3], "corpus") == 0) return corpus_metadata(fixture);
        if (std::strcmp(argv[3], "preflight") == 0) return unsupported_preflight(fixture);
        return 2;
    }
}
