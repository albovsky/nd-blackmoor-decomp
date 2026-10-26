/* NATIVE-15/16: actual S4408 -> NO_ART_SCENE ownership and font tags.
 * Component coverage uses real BOOT/new-game, original resources, pointer input
 * and muted offline audio. No story/item/phase/frame injection or GUI/device. */
#define main blackmoor_app_entry_for_no_art_test
#ifndef NATIVE_NO_ART_APP_SOURCE
#define NATIVE_NO_ART_APP_SOURCE "../src/blackmoor_app.mm"
#endif
#include NATIVE_NO_ART_APP_SOURCE
#undef main
#include <csignal>

#define CHECK(condition, message) do { if (!(condition)) { \
    std::fprintf(stderr, "CHECK failed: %s\n", message); return 1; } } while (0)

struct NoArtFixture {
    NativeApp app;
    uint32_t now = 1000;
    uint64_t muted_frames = 0;
    ~NoArtFixture() { cleanup(&app); }

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
            std::fprintf(stderr, "no-art offline audio: %s\n", error);
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
    bool start()
    {
        if (!tick()) return false;
        for (unsigned i = 0; i < 4u && session_a2d_object(app.a2d)->movie.flag_206 == 0; ++i)
            if (!tick()) return false;
        const D2Object *object = session_a2d_object(app.a2d);
        return object->movie.active && object->movie.flag_206 && object->frame_232 == 0;
    }
};

template<class T> static std::array<uint8_t, sizeof(T)> object_bytes(const T &value)
{
    std::array<uint8_t, sizeof(T)> copy{};
    std::memcpy(copy.data(), &value, copy.size());
    return copy;
}

static int actual_no_art_retention(NoArtFixture &f)
{
    CHECK(f.start(), "actual S4408 starts its original random-movie row and decodes frame0");
    CHECK(scene_resource_action_count(f.app.scene) == 5u && scene_session_action_high_water(f.app.session) == 5u,
          "actual source resource and canonical active table both have five rows before the no-art load");
    Action0bPayload payload{};
    SessionInputHotspot hotspot{};
    CHECK(session_a0b_payload(f.app.a0b, 1u, &payload) == 0 && payload.target == 1100 &&
          session_a0b_pointer_row(f.app.a0b, 1u, &hotspot) == 1,
          "real row1 supplies the S1100 request and live hotspot");
    const int x = (hotspot.rectangle.left + hotspot.rectangle.right) / 2 + f.app.scene_destination.left - f.app.cursor_provider.hot_x;
    const int y = (hotspot.rectangle.top + hotspot.rectangle.bottom) / 2 + f.app.scene_destination.top -
                  f.app.nav.scroll - f.app.cursor_provider.hot_y;
    pointer(&f.app, BLACKMOOR_POINTER_MOVE, x, y, 0);
    CHECK(f.tick() && f.app.input_state.candidate == 1, "actual MOVE selects the real row1 hotspot");
    pointer(&f.app, BLACKMOOR_POINTER_DOWN, x, y, 0);
    pointer(&f.app, BLACKMOOR_POINTER_UP, x, y, 0);
    SceneTransitionRequest pending{};
    for (unsigned i = 0; !scene_session_get_pending_transition(f.app.session, &pending) && i < 5u; ++i)
        CHECK(f.tick(), "real row1 release advances naturally to a pending scene transition");
    CHECK(scene_session_get_pending_transition(f.app.session, &pending) && pending.target_scene == 1100 &&
          f.app.current_scene_id == 4408 && session_a2d_object(f.app.a2d)->movie.active,
          "pending S1100 is captured while the original source movie is live, before the load");
    std::array<SceneActionRuntimeState, 5> rows{};
    std::array<SceneExecutorSlotInfo, 5> slots{};
    std::array<uint8_t, 240> occupied{};
    const SceneResource *const source_resource = f.app.scene;
    const size_t source_high_water = scene_session_action_high_water(f.app.session);
    for (size_t i = 0; i < rows.size(); ++i) {
        SceneActionInfo action{};
        CHECK(scene_resource_action_at(f.app.scene, i, &action) == SCENE_RESOURCE_OK &&
              scene_session_get_action_state(f.app.session, i, &rows[i]) == SCENE_SESSION_OK &&
              scene_session_get_slot(f.app.session, i, &slots[i]) == SCENE_EXECUTOR_OK && slots[i].occupied &&
              slots[i].source == source_resource && slots[i].source_index == i && slots[i].action.type == action.type &&
              slots[i].action.raw_body == action.raw_body && slots[i].action.typed_body == action.typed_body &&
              slots[i].runtime_type == (action.type == 0x97u ? 0x9fu : action.type),
              "canonical source slot preserves resource identity and exposes current runtime97 as9f");
        occupied[i] = slots[i].occupied;
        std::printf("NO_ART_SOURCE_ROW source=4408 local=%zu global=%zu occupied=%u raw=0x%02x runtime=0x%02x phase=%u completed=%u dependencies=%zu selected97=%d\n",
                    i, i, slots[i].occupied, action.type, slots[i].runtime_type, rows[i].phase, rows[i].completed,
                    action.dependency_count, session_a97_selected(f.app.a97, i));
    }
    /* None of these actual source runtime types belongs to the recovered
     * retirement set. Completion alone therefore cannot free row1's slot.
     * Derive incoming indices from captured occupancy, without using the
     * production slot planner or assuming append indices5..21. */
    CHECK(rows[1].completed && slots[1].occupied, "completed source hotspot remains occupied before selective no-art clear");
    std::array<size_t, 17> incoming_slots{};
    size_t expected_high_water = source_high_water;
    while (expected_high_water && !occupied[expected_high_water - 1u]) --expected_high_water;
    for (size_t local = 0; local < incoming_slots.size(); ++local) {
        CHECK(expected_high_water < occupied.size(), "actual incoming rows fit below the original high-water bound");
        size_t global = 0;
        while (global < expected_high_water && occupied[global]) ++global;
        incoming_slots[local] = global;
        occupied[global] = 1u;
        if (global == expected_high_water) ++expected_high_water;
    }
    const D2Object *const object = session_a2d_object(f.app.a2d);
    const D2Set *const set = object->set;
    const uint32_t surface = object->surface_212;
    const int32_t stream = object->bink_id_18e;
    NativeRandomMovieFrame before{};
    CHECK(native_random_movie_frame(f.app.a2d_media, surface, &before) == 0 && before.rgba && before.current_frame == 0,
          "real owned frame and stream are available immediately before the no-art load");
    const auto nav = object_bytes(f.app.nav);
    const auto rng = object_bytes(f.app.condition_rand);
    const int selection = session_a97_selected(f.app.a97, 4u);
    const auto video = f.app.video;
    const auto nav_player = f.app.nav_player;
    const auto art_path = f.app.scene_video_path;
    const auto source_rect = object_bytes(f.app.scene_source);
    const auto destination_rect = object_bytes(f.app.scene_destination);
    const auto input = object_bytes(f.app.input_state);
    const auto caption = object_bytes(f.app.captions.lifecycle.g);
    const auto writer = object_bytes(f.app.captions.writer_globals);
    const auto loaded_words = object_bytes(f.app.loaded_words);
    auto visits = f.app.new_game.scene_visits;
    visits[1100] = static_cast<uint16_t>(visits[1100] + 1u);
    CHECK(f.app.first_load_5bb210 == 1u && f.app.last_art_scene_id == 4408,
          "the ordinary initial load already completed the common tail and owns the retained art identity");
    SceneSession *const session = f.app.session;
    const uint64_t generation = scene_session_scene_generation(session);
    std::printf("NO_ART_PENDING source=4408 target=%d rows=%zu exit_state=%u selected97=%d movie_frame=%d movie_generation=%llu stream=%d surface=%u selector=%d scroll=%d\n",
                pending.target_scene, rows.size(), f.app.exit_state.g.game_state, selection, before.current_frame,
                (unsigned long long)before.generation, stream, surface, f.app.nav.selector, f.app.nav.scroll);
    std::fflush(stdout);
    for (unsigned i = 0; f.app.current_scene_id != 1100 && i < 8u; ++i)
        CHECK(f.tick(), "normal exit/load state machine supports S1100 while retaining the live source movie");
    NativeRandomMovieFrame after{};
    CHECK(f.app.current_scene_id == 1100 && f.app.session == session && scene_session_scene_generation(session) > generation &&
          session_a2d_object(f.app.a2d) == object && object->movie.active && object->set == set &&
          object->surface_212 == surface && object->bink_id_18e == stream &&
          session_a97_selected(f.app.a97, 4u) == selection && object_bytes(f.app.condition_rand) == rng &&
          object_bytes(f.app.nav) == nav && f.app.video == video && f.app.nav_player == nav_player &&
          f.app.scene_video_path == art_path && object_bytes(f.app.scene_source) == source_rect &&
          object_bytes(f.app.scene_destination) == destination_rect &&
          native_random_movie_frame(f.app.a2d_media, surface, &after) == 0 && after.generation == before.generation &&
          after.current_frame == before.current_frame && f.app.last_art_scene_id == 4408 &&
          f.app.first_load_5bb210 == 1u && f.app.new_game.scene_visits == visits &&
          object_bytes(f.app.input_state) == input && object_bytes(f.app.captions.lifecycle.g) == caption &&
          object_bytes(f.app.captions.writer_globals) == writer && object_bytes(f.app.loaded_words) == loaded_words,
          "logical S1100 retains original controller, set, stream, surface, navigation, art and constructor RNG selection");
    CHECK(scene_session_action_high_water(session) == expected_high_water,
          "actual incoming no-art rows extend the canonical table to the independently derived high-water");
    for (size_t i = 0; i < slots.size(); ++i) {
        SceneExecutorSlotInfo retained{};
        SceneActionRuntimeState state{};
        CHECK(scene_session_get_slot(session, i, &retained) == SCENE_EXECUTOR_OK && retained.occupied &&
              retained.source == slots[i].source && retained.source_index == slots[i].source_index &&
              retained.runtime_type == slots[i].runtime_type && retained.action.raw_body == slots[i].action.raw_body &&
              retained.action.typed_body == slots[i].action.typed_body &&
              retained.action.dependency_records == slots[i].action.dependency_records &&
              scene_session_get_action_state(session, i, &state) == SCENE_SESSION_OK &&
              state.phase == rows[i].phase && state.completed == rows[i].completed,
              "every surviving global slot keeps its original source, borrowed body, dependency records and natural state");
    }
    const SceneResource *incoming_resource = nullptr;
    unsigned conversations = 0;
    for (size_t local = 0; local < incoming_slots.size(); ++local) {
        SceneExecutorSlotInfo incoming{};
        SceneActionInfo action{};
        CHECK(scene_session_get_slot(session, incoming_slots[local], &incoming) == SCENE_EXECUTOR_OK && incoming.occupied &&
              incoming.source != source_resource && incoming.source_index == local,
              "incoming resource-local ACT is installed at the first slot derived from actual live occupancy");
        if (!local) incoming_resource = incoming.source;
        CHECK(incoming.source == incoming_resource && scene_resource_action_count(incoming_resource) == incoming_slots.size() &&
              scene_resource_action_at(incoming_resource, local, &action) == SCENE_RESOURCE_OK &&
              incoming.action.type == action.type && incoming.action.raw_body == action.raw_body,
              "all17 actual S1100 records retain their own resource owner and local order");
        if (action.type == 0x3fu) ++conversations;
        std::printf("NO_ART_INCOMING source=1100 local=%zu global=%zu raw=0x%02x runtime=0x%02x\n",
                    local, incoming_slots[local], incoming.action.type, incoming.runtime_type);
    }
    CHECK(conversations == 11u, "actual incoming S1100 resource installs eleven conversation objects");
    CHECK(f.tick(3200u) && native_random_movie_frame(f.app.a2d_media, surface, &after) == 0 &&
          after.generation > before.generation && after.current_frame == 1,
          "actual retained movie decodes its next real frame on the normal S1100 update");
    std::printf("NO_ART_RETAIN source=4408 target=1100 movie_frame=1 stream_retained=1 surface_retained=1 selection_retained=1\n");
    return 0;
}

/* Wait only by rendering actual muted PCM and running ordinary app updates.
 * A pending transition ends the wait before its loader can run. */
static int wait_for_pending(NoArtFixture &f, int16_t target)
{
    SceneTransitionRequest pending{};
    for (unsigned i = 0; !scene_session_get_pending_transition(f.app.session, &pending) && i < 1800u; ++i)
        CHECK(f.tick(4096u), "natural voice/controller updates continue until the actual transition request");
    CHECK(scene_session_get_pending_transition(f.app.session, &pending) && pending.target_scene == target,
          "naturally completed actual dialogue requests its resource-defined next scene");
    return 0;
}

/* This route retires only conversation slots. Derive first-hole placement
 * independently from the live table rather than using the production planner. */
static int load_next_no_art(NoArtFixture &f, int16_t target, size_t *new_row)
{
    SceneTransitionRequest pending{};
    CHECK(scene_session_get_pending_transition(f.app.session, &pending) && pending.target_scene == target,
          "no-art retention check starts from a real pending transition");
    const size_t high = scene_session_action_high_water(f.app.session);
    std::array<SceneExecutorSlotInfo, 240> slots{};
    std::array<SceneActionRuntimeState, 240> states{};
    std::array<uint8_t, 240> occupied{}, retired{};
    unsigned released_before = 0, incomplete_before = 0;
    for (size_t i = 0; i < high; ++i) {
        CHECK(scene_session_get_slot(f.app.session, i, &slots[i]) == SCENE_EXECUTOR_OK &&
              scene_session_get_action_state(f.app.session, i, &states[i]) == SCENE_SESSION_OK,
              "live canonical slot and state can be captured before selective retirement");
        occupied[i] = slots[i].occupied;
        if (slots[i].occupied && slots[i].runtime_type == 0x3fu) {
            retired[i] = 1u; occupied[i] = 0u;
            const uint8_t *image = session_a3f_image(f.app.a3f, i);
            if (states[i].completed) {
                CHECK(image == nullptr, "completed conversation arena was already released before no-art retirement");
                ++released_before;
            } else {
                CHECK(image != nullptr, "incomplete conversation still owns its arena before selective retirement");
                ++incomplete_before;
            }
        }
    }
    CHECK(released_before == 1u, "one naturally completed conversation is distinct from its still-occupied slot");
    size_t final_high = high;
    while (final_high && !occupied[final_high - 1u]) --final_high;
    size_t assigned = 0;
    while (assigned < final_high && occupied[assigned]) ++assigned;
    if (assigned == final_high) ++final_high;
    const auto input = object_bytes(f.app.input_state);
    const auto caption = object_bytes(f.app.captions.lifecycle.g);
    const auto writer = object_bytes(f.app.captions.writer_globals);
    const auto nav = object_bytes(f.app.nav);
    const auto rng = object_bytes(f.app.condition_rand);
    const auto words = object_bytes(f.app.loaded_words);
    const auto clock = object_bytes(f.app.new_game.view.clock);
    const int start_flag = f.app.start_flag_5bb1ca;
    auto visits = f.app.new_game.scene_visits;
    visits[target] = static_cast<uint16_t>(visits[target] + 1u);
    const D2Object *const object = session_a2d_object(f.app.a2d);
    const auto movie = object_bytes(*object);
    NativeRandomMovieFrame frame{}, after{};
    CHECK(native_random_movie_frame(f.app.a2d_media, object->surface_212, &frame) == 0,
          "actual retained movie surface remains available at the dialogue transition");
    const int16_t source = f.app.current_scene_id;
    for (unsigned i = 0; f.app.current_scene_id != target && i < 8u; ++i)
        CHECK(f.tick(), "ordinary exit/load states commit the next no-art resource");
    CHECK(f.app.current_scene_id == target && f.app.last_art_scene_id == 4408 && f.app.first_load_5bb210 == 1u &&
          f.app.new_game.scene_visits == visits && f.app.start_flag_5bb1ca == start_flag &&
          object_bytes(f.app.input_state) == input && object_bytes(f.app.captions.lifecycle.g) == caption &&
          object_bytes(f.app.captions.writer_globals) == writer && object_bytes(f.app.nav) == nav &&
          object_bytes(f.app.condition_rand) == rng && object_bytes(f.app.loaded_words) == words &&
          object_bytes(f.app.new_game.view.clock) == clock && object_bytes(*session_a2d_object(f.app.a2d)) == movie &&
          native_random_movie_frame(f.app.a2d_media, object->surface_212, &after) == 0 &&
          after.generation == frame.generation && after.current_frame == frame.current_frame && after.rgba == frame.rgba &&
          scene_session_action_high_water(f.app.session) == final_high,
          "successful no-art common tail increments only its visit while preserving first-load, art, input, caption, clock, nav, RNG and movie ownership");
    for (size_t i = 0; i < high; ++i) {
        if (!slots[i].occupied) continue;
        if (retired[i]) {
            if (i != assigned) CHECK(session_a3f_image(f.app.a3f, i) == nullptr,
                                    "each retired conversation loses its old arena while the reused slot owns only its new object");
            continue;
        }
        SceneExecutorSlotInfo survivor{};
        SceneActionRuntimeState state{};
        CHECK(scene_session_get_slot(f.app.session, i, &survivor) == SCENE_EXECUTOR_OK && survivor.occupied &&
              survivor.source == slots[i].source && survivor.source_index == slots[i].source_index &&
              survivor.runtime_type == slots[i].runtime_type && survivor.action.raw_body == slots[i].action.raw_body &&
              survivor.action.dependency_records == slots[i].action.dependency_records &&
              scene_session_get_action_state(f.app.session, i, &state) == SCENE_SESSION_OK &&
              state.phase == states[i].phase && state.completed == states[i].completed,
              "selective no-art clear preserves every nonconversation survivor in its exact global slot and state");
    }
    SceneExecutorSlotInfo incoming{};
    CHECK(scene_session_get_slot(f.app.session, assigned, &incoming) == SCENE_EXECUTOR_OK && incoming.occupied &&
          incoming.source == f.app.scene && incoming.source_index == 0u && incoming.action.type == 0x3fu &&
          scene_resource_action_count(incoming.source) == 1u && session_a3f_image(f.app.a3f, assigned) != nullptr,
          "the actual next one-row conversation reuses the independently derived first hole with a new resource owner");
    if (new_row) *new_row = assigned;
    std::printf("NO_ART_CLEANUP source=%d target=%d retained_art=4408 old_completed_released=%u old_incomplete_retired=%u incoming_global=%zu high_water=%zu visit_once=1 first_load=1\n",
                source, target, released_before, incomplete_before, assigned, final_high);
    return 0;
}

static int natural_second_load(NoArtFixture &f)
{
    CHECK(actual_no_art_retention(f) == 0 && f.app.new_game.event_flags[1570] == 0,
          "fresh real S1100 greeting starts with its actual event gate false");
    LiveAudioChannelInfo sound{};
    int busy = 0;
    const int row = session_a3f_manager(f.app.a3f)->row;
    CHECK(row >= 0 && live_audio_get_channel_info(f.app.live_audio, 12, &sound) == LIVE_AUDIO_OK &&
          sound.loaded && sound.started && sound.frame_count &&
          live_audio_is_playing(f.app.live_audio, 12, &busy) == ACTION_SOUND_BACKEND_OK && busy,
          "naturally eligible S1100 greeting owns a real busy channel12 voice");
    SceneTransitionRequest premature{};
    CHECK(f.tick() && f.tick() && !scene_session_get_pending_transition(f.app.session, &premature),
          "busy greeting voice cannot finish or request the next no-art scene early");
    CHECK(wait_for_pending(f, 1137) == 0 && f.app.new_game.event_flags[1570] == 1,
          "real greeting completion applies its actual secondary event then requests1137");
    SceneActionRuntimeState completed{};
    CHECK(scene_session_get_action_state(f.app.session, static_cast<size_t>(row), &completed) == SCENE_SESSION_OK &&
          completed.completed && completed.phase == 0u && session_a3f_image(f.app.a3f, static_cast<size_t>(row)) == nullptr,
          "finished greeting releases its own arena before the special loader retires its still-occupied slot");
    size_t incoming = 0;
    CHECK(load_next_no_art(f, 1137, &incoming) == 0, "natural second no-art load trims and reuses the actual conversation holes");
    return 0;
}

static int choose_first_response(NoArtFixture &f, int16_t target)
{
    int busy = 1;
    for (unsigned i = 0; i < 1800u; ++i) {
        CHECK(f.tick(4096u), "real initial dialogue voice and UI advance toward response readiness");
        CHECK(live_audio_is_playing(f.app.live_audio, 12, &busy) == ACTION_SOUND_BACKEND_OK,
              "real initial voice busy state is observable");
        if (!busy && session_a3f_response_count(f.app.a3f) == 2 && f.app.a3f_caption.ready) break;
    }
    CHECK(!busy && session_a3f_response_count(f.app.a3f) == 2 && f.app.a3f_caption.result.response_count == 2 &&
          session_a3f_manager(f.app.a3f)->responses[0].scene == target &&
          f.app.a3f_caption.active[0] && f.app.a3f_caption.active[1],
          "actual two-choice conversation presents original normal/hilite surfaces and resource-defined first target");
    const auto choice = f.app.a3f_caption.result.choices[0];
    int scroll = f.app.captions.lifecycle.g.scroll_src.top;
    if (choice.rect[1] - scroll > 80 || choice.rect[3] - scroll < 0) {
        const uint8_t *slider = f.app.a3f_caption.popup.box + CTB_SLIDER;
        const int32_t tx = read_i32_le(slider + SLD_THUMB), ty = read_i32_le(slider + SLD_THUMB + 4u);
        const int32_t tr = read_i32_le(slider + SLD_THUMB + 8u), tb = read_i32_le(slider + SLD_THUMB + 12u);
        const int32_t bottom = read_i32_le(slider + SLD_TRACK + 12u);
        const int32_t x = (tx + tr) / 2, y = (ty + tb) / 2;
        pointer(&f.app, BLACKMOOR_POINTER_MOVE, x, y, 0); CHECK(f.tick(), "actual popup thumb receives MOVE");
        pointer(&f.app, BLACKMOOR_POINTER_DOWN, x, y, 0); CHECK(f.tick(), "actual popup thumb receives DOWN");
        pointer(&f.app, BLACKMOOR_POINTER_MOVE, x, bottom, 0); CHECK(f.tick(), "actual stock slider exposes the lower response text");
        pointer(&f.app, BLACKMOOR_POINTER_UP, x, bottom, 0); CHECK(f.tick(), "actual popup slider release keeps response ownership");
        scroll = f.app.captions.lifecycle.g.scroll_src.top;
    }
    const int top = std::max<int>(choice.rect[1] - scroll, 0), bottom = std::min<int>(choice.rect[3] - scroll, 80);
    CHECK(top <= bottom, "actual first response has a visible pointer target after stock scroll");
    const int x = 51 + (choice.rect[0] + choice.rect[2]) / 2, y = 392 + (top + bottom) / 2;
    pointer(&f.app, BLACKMOOR_POINTER_MOVE, x, y, 0);
    CHECK(f.tick() && f.app.a3f_caption.hover == 0, "real MOVE highlights first response at its original rendered rectangle");
    pointer(&f.app, BLACKMOOR_POINTER_DOWN, x, y, 0);
    pointer(&f.app, BLACKMOOR_POINTER_UP, x, y, 0);
    for (unsigned i = 0; session_a3f_manager(f.app.a3f)->sub_state != 6u && i < 8u; ++i)
        CHECK(f.tick(), "real response release reaches the original selected-voice state");
    LiveAudioChannelInfo response{};
    CHECK(session_a3f_manager(f.app.a3f)->sub_state == 6u &&
          live_audio_get_channel_info(f.app.live_audio, 13, &response) == LIVE_AUDIO_OK &&
          response.loaded && response.started && response.frame_count &&
          live_audio_is_playing(f.app.live_audio, 13, &busy) == ACTION_SOUND_BACKEND_OK && busy,
          "actual selected response starts real channel13 playback before its target can load");
    SceneTransitionRequest premature{};
    CHECK(f.tick() && f.tick() && session_a3f_manager(f.app.a3f)->sub_state == 6u &&
          !scene_session_get_pending_transition(f.app.session, &premature),
          "real busy response voice prevents early response transition");
    const int source = f.app.current_scene_id;
    CHECK(wait_for_pending(f, target) == 0 && load_next_no_art(f, target, nullptr) == 0,
          "natural selected-response voice completion loads its actual next no-art scene");
    std::printf("NO_ART_RESPONSE source=%d choice=0 target=%d channel=13 natural_completion=1\n", source, target);
    return 0;
}

static int natural_response(NoArtFixture &f)
{
    CHECK(natural_second_load(f) == 0 && choose_first_response(f, 1101) == 0,
          "actual greeting, selective second load and original first choice reach1101");
    return 0;
}

static int actual_font_caption_start(NoArtFixture &f, const char *key, const uint8_t tag[4])
{
    size_t row = scene_session_action_high_water(f.app.session);
    SceneExecutorSlotInfo slot{};
    for (size_t i = 0; i < scene_session_action_high_water(f.app.session); ++i) {
        SceneExecutorSlotInfo candidate{};
        CHECK(scene_session_get_slot(f.app.session, i, &candidate) == SCENE_EXECUTOR_OK,
              "current canonical table exposes retained and incoming row identities");
        if (candidate.occupied && candidate.source == f.app.scene && candidate.source_index == 0u) {
            row = i; slot = candidate; break;
        }
    }
    CHECK(row < scene_session_action_high_water(f.app.session) && slot.action.type == 0x3fu,
          "actual conversation is found through its canonical source identity");
    ActionFamily3fDecoded decoded{};
    Convo3fManager preview{};
    Convo3fLayoutRequest request{};
    CHECK(action_family_3f_decode(slot.action.raw_body, slot.action.raw_body_length, &decoded) == ACTION_FAMILY_3F_OK &&
          std::strcmp(reinterpret_cast<const char *>(decoded.text_key), key) == 0 &&
          session_a3f_preview_layout(f.app.a3f, row, &preview, &request) == CONVO3F_OK && request.response_count == 0 &&
          request.caption && request.caption_length >= 4u &&
          std::search(request.caption, request.caption + request.caption_length, tag, tag + 4u) != request.caption + request.caption_length,
          "actual CONVO caption contains the original font tag rather than a substituted or stripped text");
    LiveAudioChannelInfo before{}, sound{};
    CHECK(live_audio_get_channel_info(f.app.live_audio, 12, &before) == LIVE_AUDIO_OK,
          "original voice generation before the font-tag caption starts is observable");
    CHECK(f.tick(), "ordinary actual font-tag conversation passes preflight and starts successfully");
    SceneActionRuntimeState state{};
    int busy = 0;
    CHECK(scene_session_get_action_state(f.app.session, row, &state) == SCENE_SESSION_OK && state.phase == 1u && !state.completed &&
          session_a3f_manager(f.app.a3f)->row == static_cast<int16_t>(row) &&
          f.app.a3f_caption.row == static_cast<int>(row) && f.app.a3f_caption.ready &&
          f.app.a3f_caption.active[0] && f.app.a3f_caption.active[1] &&
          f.app.a3f_caption.result.glyphs[0] && f.app.a3f_caption.result.glyphs[1] &&
          live_audio_get_channel_info(f.app.live_audio, 12, &sound) == LIVE_AUDIO_OK && sound.generation > before.generation &&
          sound.loaded && sound.started && sound.frame_count &&
          live_audio_is_playing(f.app.live_audio, 12, &busy) == ACTION_SOUND_BACKEND_OK && busy &&
          f.app.last_art_scene_id == 4408 && session_a2d_object(f.app.a2d)->movie.active,
          "actual original FONT sheets draw both caption surfaces while real voice and retained movie remain active");
    std::printf("NO_ART_FONT scene=%d key=%s tag=f%c normal_glyphs=%u hilite_glyphs=%u voice_channel=12\n",
                f.app.current_scene_id, key, tag[2], f.app.a3f_caption.result.glyphs[0], f.app.a3f_caption.result.glyphs[1]);
    return 0;
}

static bool log_contains(NativeApp &app, const char *wanted)
{
    if (!app.log) return false;
    std::fflush(app.log);
    const long position = std::ftell(app.log);
    std::rewind(app.log);
    char line[1024]{};
    bool found = false;
    while (std::fgets(line, sizeof(line), app.log)) if (std::strstr(line, wanted)) { found = true; break; }
    if (position >= 0) (void)std::fseek(app.log, position, SEEK_SET);
    return found;
}

static int natural_font_chain_boundary(NoArtFixture &f)
{
    CHECK(natural_response(f) == 0, "ordinary dialogue route reaches1101 without injected state");
    const int16_t targets[] = {1102, 1103, 1104, 1105};
    for (int16_t target : targets)
        CHECK(wait_for_pending(f, target) == 0 && load_next_no_art(f, target, nullptr) == 0,
              "ordinary resource-defined dialogue chain keeps the source room and actual movie alive");
    static const uint8_t font_one[] = {'<', 'f', '1', '>'}, font_nine[] = {'<', 'f', '9', '>'};
    CHECK(actual_font_caption_start(f, "LPL05", font_one) == 0 && wait_for_pending(f, 1134) == 0 &&
          load_next_no_art(f, 1134, nullptr) == 0 && actual_font_caption_start(f, "LPL34X", font_nine) == 0,
          "actual f1 and later f9 captions both execute through the retained-room dialogue path");
    const int16_t later_targets[] = {1135, 1136};
    for (int16_t target : later_targets)
        CHECK(wait_for_pending(f, target) == 0 && load_next_no_art(f, target, nullptr) == 0,
              "font-tag support permits the next original dialogue scenes without a bypass");
    CHECK(choose_first_response(f, 1106) == 0 && wait_for_pending(f, 1107) == 0 &&
          load_next_no_art(f, 1107, nullptr) == 0 && wait_for_pending(f, 4408) == 0,
          "second actual choice and following voices naturally request the normal-art room return");
    const SceneResource *const source = f.app.scene;
    const uint64_t generation = scene_session_scene_generation(f.app.session);
    const D2Object *const movie = session_a2d_object(f.app.a2d);
    const auto object = object_bytes(*movie);
    const auto nav = object_bytes(f.app.nav);
    const auto rng = object_bytes(f.app.condition_rand);
    const auto input = object_bytes(f.app.input_state);
    const auto caption = object_bytes(f.app.captions.lifecycle.g);
    const auto visits = f.app.new_game.scene_visits;
    const auto source_rect = object_bytes(f.app.scene_source);
    const auto destination_rect = object_bytes(f.app.scene_destination);
    const size_t high_water = scene_session_action_high_water(f.app.session);
    std::array<SceneExecutorSlotInfo, 240> slots{};
    std::array<SceneActionRuntimeState, 240> states{};
    for (size_t i = 0; i < high_water; ++i)
        CHECK(scene_session_get_slot(f.app.session, i, &slots[i]) == SCENE_EXECUTOR_OK &&
              scene_session_get_action_state(f.app.session, i, &states[i]) == SCENE_SESSION_OK,
              "all live source rows can be captured before the normal-art ownership boundary");
    bool failed = false;
    for (unsigned i = 0; !failed && i < 8u; ++i) failed = !f.tick();
    SceneTransitionRequest pending{};
    NativeRandomMovieFrame frame{};
    CHECK(failed && f.app.failure && !f.app.session_block_reported && f.app.current_scene_id == 1107 && f.app.scene == source &&
          scene_session_scene_generation(f.app.session) == generation && scene_session_action_high_water(f.app.session) == high_water &&
          f.app.last_art_scene_id == 4408 && f.app.first_load_5bb210 == 1u &&
          session_a2d_object(f.app.a2d) == movie && movie->movie.active && object_bytes(*movie) == object &&
          native_random_movie_frame(f.app.a2d_media, movie->surface_212, &frame) == 0 && frame.rgba &&
          object_bytes(f.app.nav) == nav && object_bytes(f.app.condition_rand) == rng &&
          object_bytes(f.app.input_state) == input && object_bytes(f.app.captions.lifecycle.g) == caption &&
          f.app.new_game.scene_visits == visits && object_bytes(f.app.scene_source) == source_rect &&
          object_bytes(f.app.scene_destination) == destination_rect &&
          scene_session_get_pending_transition(f.app.session, &pending) && pending.target_scene == 4408 &&
          log_contains(f.app, "active-random-movie-retention-unimplemented before_clear=1"),
          "active-D2 normal-art return4408 is explicitly refused before clear/load/source replacement or target visit effects");
    for (size_t i = 0; i < high_water; ++i) {
        SceneExecutorSlotInfo slot{};
        SceneActionRuntimeState state{};
        CHECK(scene_session_get_slot(f.app.session, i, &slot) == SCENE_EXECUTOR_OK && slot.occupied == slots[i].occupied &&
              scene_session_get_action_state(f.app.session, i, &state) == SCENE_SESSION_OK &&
              state.phase == states[i].phase && state.completed == states[i].completed &&
              (!slot.occupied || (slot.source == slots[i].source && slot.source_index == slots[i].source_index &&
                slot.action.raw_body == slots[i].action.raw_body && slot.action.dependency_records == slots[i].action.dependency_records)),
              "normal-art refusal preserves every retained source slot, resource borrow and completion state");
    }
    std::printf("NO_ART_FONT_BOUNDARY source=1107 target=4408 f1_success=1 f9_success=1 active_D2_refused_before_clear=1 target_visit_unchanged=1 successful_return=0\n");
    return 0;
}

static int active_conversation_load_refusal(NoArtFixture &f)
{
    CHECK(actual_no_art_retention(f) == 0, "ordinary first no-art load starts the real S1100 greeting");
    const int row = session_a3f_manager(f.app.a3f)->row;
    SceneActionRuntimeState active{};
    LiveAudioChannelInfo sound{};
    int busy = 0;
    CHECK(row >= 0 && scene_session_get_action_state(f.app.session, static_cast<size_t>(row), &active) == SCENE_SESSION_OK &&
          active.phase == 1u && !active.completed && live_audio_get_channel_info(f.app.live_audio, 12, &sound) == LIVE_AUDIO_OK &&
          sound.loaded && sound.started && live_audio_is_playing(f.app.live_audio, 12, &busy) == ACTION_SOUND_BACKEND_OK && busy,
          "real greeting naturally owns an incomplete phase1 row and busy voice, without a forced phase");
    const SceneResource *const source = f.app.scene;
    const size_t high = scene_session_action_high_water(f.app.session);
    std::array<SceneExecutorSlotInfo, 240> slots{};
    std::array<SceneActionRuntimeState, 240> states{};
    for (size_t i = 0; i < high; ++i)
        CHECK(scene_session_get_slot(f.app.session, i, &slots[i]) == SCENE_EXECUTOR_OK &&
              scene_session_get_action_state(f.app.session, i, &states[i]) == SCENE_SESSION_OK,
              "busy-conversation refusal snapshots the actual canonical source table");
    const uint8_t *const image = session_a3f_image(f.app.a3f, static_cast<size_t>(row));
    CHECK(image != nullptr, "busy greeting retains its live original constructed image");
    const std::vector<uint8_t> image_bytes(image, image + CONVO3F_IMAGE_BYTES);
    const auto manager = object_bytes(*session_a3f_manager(f.app.a3f));
    const auto nav = object_bytes(f.app.nav);
    const auto input = object_bytes(f.app.input_state);
    const auto caption = object_bytes(f.app.captions.lifecycle.g);
    const auto writer = object_bytes(f.app.captions.writer_globals);
    const auto normal = f.app.a3f_caption.pixels[0], hilite = f.app.a3f_caption.pixels[1];
    const auto rng = object_bytes(f.app.condition_rand);
    const auto visits = f.app.new_game.scene_visits;
    const auto flags = f.app.new_game.event_flags;
    const auto movie = object_bytes(*session_a2d_object(f.app.a2d));
    const uint64_t generation = scene_session_scene_generation(f.app.session), ticks = scene_session_tick_count(f.app.session);
    const size_t retained_count = f.app.retained_scenes.size();
    NativeRandomMovieFrame frame{}, after{};
    const uint32_t surface = session_a2d_object(f.app.a2d)->surface_212;
    CHECK(native_random_movie_frame(f.app.a2d_media, surface, &frame) == 0, "live source movie has owned pixels before the boundary request");
    ActionFamily3fDecoded decoded{};
    CHECK(action_family_3f_decode(slots[static_cast<size_t>(row)].action.raw_body,
              slots[static_cast<size_t>(row)].action.raw_body_length, &decoded) == ACTION_FAMILY_3F_OK && decoded.word_47 == 1137,
          "direct loader component uses the actual greeting's next no-art target");
    SceneTransitionRequest request{};
    request.target_scene = static_cast<int16_t>(decoded.word_47);
    request.opaque_words[0] = static_cast<int16_t>(decoded.word_49);
    request.opaque_words[2] = 1; request.opaque_dwords[2] = 1;
    /* Authorized loader-boundary component: no pending transfer, phase, flag
     * or input state is fabricated. Stop immediately if old code commits;
     * never dispatch through a retired live-manager object in the RED case. */
    const bool accepted = perform_session_transition(&f.app, request, f.now);
    CHECK(!accepted, "no-art loader refuses retiring a naturally started incomplete conversation before any commit");
    LiveAudioChannelInfo after_sound{};
    SceneTransitionRequest absent{};
    CHECK(!f.app.failure && !f.app.session_block_reported && f.app.current_scene_id == 1100 && f.app.scene == source &&
          f.app.retained_scenes.size() == retained_count && scene_session_action_high_water(f.app.session) == high &&
          scene_session_scene_generation(f.app.session) == generation && scene_session_tick_count(f.app.session) == ticks &&
          session_a3f_image(f.app.a3f, static_cast<size_t>(row)) == image && std::memcmp(image, image_bytes.data(), image_bytes.size()) == 0 &&
          object_bytes(*session_a3f_manager(f.app.a3f)) == manager && object_bytes(f.app.nav) == nav &&
          object_bytes(f.app.input_state) == input && object_bytes(f.app.captions.lifecycle.g) == caption &&
          object_bytes(f.app.captions.writer_globals) == writer && f.app.a3f_caption.pixels[0] == normal && f.app.a3f_caption.pixels[1] == hilite &&
          object_bytes(f.app.condition_rand) == rng && f.app.new_game.scene_visits == visits && f.app.new_game.event_flags == flags &&
          object_bytes(*session_a2d_object(f.app.a2d)) == movie && native_random_movie_frame(f.app.a2d_media, surface, &after) == 0 &&
          after.rgba == frame.rgba && after.generation == frame.generation && after.current_frame == frame.current_frame &&
          live_audio_get_channel_info(f.app.live_audio, 12, &after_sound) == LIVE_AUDIO_OK &&
          after_sound.generation == sound.generation && after_sound.loaded == sound.loaded && after_sound.started == sound.started &&
          live_audio_is_playing(f.app.live_audio, 12, &busy) == ACTION_SOUND_BACKEND_OK && busy &&
          !scene_session_get_pending_transition(f.app.session, &absent),
          "busy-conversation refusal leaves current resource, slots, image, manager, voice, caption/input/nav, RNG and movie untouched");
    for (size_t i = 0; i < high; ++i) {
        SceneExecutorSlotInfo slot{}; SceneActionRuntimeState state{};
        CHECK(scene_session_get_slot(f.app.session, i, &slot) == SCENE_EXECUTOR_OK && slot.occupied == slots[i].occupied &&
              scene_session_get_action_state(f.app.session, i, &state) == SCENE_SESSION_OK && state.phase == states[i].phase && state.completed == states[i].completed &&
              (!slot.occupied || (slot.source == slots[i].source && slot.source_index == slots[i].source_index &&
                slot.action.raw_body == slots[i].action.raw_body && slot.action.dependency_records == slots[i].action.dependency_records)),
              "every source identity and naturally reached state survives the refused loader boundary");
    }
    std::printf("NO_ART_BUSY_REFUSAL source=1100 requested=1137 phase=1 completed=0 voice_busy=1 before_commit=1\n");
    return 0;
}

static int host_stop_after_no_art_cleanup(NoArtFixture &f)
{
    CHECK(natural_second_load(f) == 0 && f.app.current_scene_id == 1137 &&
          session_a3f_modal_active(f.app.a3f) == 0 && !f.app.retained_scenes.empty(),
          "actual completed greeting and second no-art load provide inherited movie ownership before the next conversation starts");
    SceneExecutorSlotInfo control{};
    ActionFamily2eDecoded body{};
    CHECK(scene_session_get_slot(f.app.session, 3u, &control) == SCENE_EXECUTOR_OK && control.occupied && control.action.type == 0x2eu &&
          action_family_2e_decode(control.action.raw_body, control.action.raw_body_length, &body) == ACTION_FAMILY_2E_OK &&
          body.option_00 == 0u && static_cast<int16_t>(body.word[0]) == 4412,
          "retained source resource supplies the actual movie-stop row's normal-art target");
    const uint32_t surface = session_a2d_object(f.app.a2d)->surface_212;
    const uint64_t generation = scene_session_scene_generation(f.app.session);
    int32_t erased_row = SESSION_A2E_NO_ROW;
    /* Authorized direct host-boundary component, not a natural UI exit:
     * use the real controller/media erase callback, then the public external
     * transition path. No phase, event, modal gate or candidate is changed. */
    CHECK(native_a2e_stop_movie(&f.app, &erased_row) == 0 && erased_row == 0,
          "actual host stop runs the retained D2 controller/media teardown and canonical row erase");
    SceneExecutorSlotInfo erased{}; SceneActionRuntimeState state{};
    NativeRandomMovieFrame absent{};
    CHECK(scene_session_get_slot(f.app.session, 0u, &erased) == SCENE_EXECUTOR_OK && !erased.occupied &&
          scene_session_get_action_state(f.app.session, 0u, &state) == SCENE_SESSION_OK && state.completed && state.phase == 0u &&
          !session_a2d_object(f.app.a2d)->movie.active && native_random_movie_frame(f.app.a2d_media, surface, &absent) != 0,
          "stop makes the source D2 slot vacant independently of completion and releases its actual movie pixels");
    auto visits = f.app.new_game.scene_visits;
    visits[4412] = static_cast<uint16_t>(visits[4412] + 1u);
    SceneTransitionRequest request{};
    request.target_scene = static_cast<int16_t>(body.word[0]);
    request.opaque_words[0] = static_cast<int16_t>(body.word[1]);
    request.opaque_words[1] = static_cast<int16_t>(body.word[2]);
    request.opaque_words[2] = static_cast<int16_t>(body.word[3]);
    request.opaque_dwords[2] = 1;
    CHECK(scene_session_request_external_transition(f.app.session, &request) == SCENE_SESSION_OK,
          "stopped no-art component requests its actual normal-art target through the public session boundary");
    for (unsigned i = 0; f.app.current_scene_id != 4412 && i < 8u; ++i)
        CHECK(f.tick(), "ordinary exit/load state updates replace the stopped retained-room component");
    CHECK(f.app.current_scene_id == 4412 && f.app.last_art_scene_id == 4412 &&
          scene_session_scene_generation(f.app.session) > generation && f.app.new_game.scene_visits == visits &&
          f.app.retained_scenes.empty() && f.app.retired_scene == nullptr &&
          session_a2d_object(f.app.a2d)->set == nullptr && !session_a2d_object(f.app.a2d)->movie.active &&
          session_a3f_modal_active(f.app.a3f) == 0 && session_a3f_manager(f.app.a3f)->row == -1 &&
          !f.app.a3f_caption.ready && !f.app.a3f_caption.active[0] && !f.app.a3f_caption.active[1] &&
          f.app.a3f_caption.pixels[0].empty() && f.app.a3f_caption.pixels[1].empty() &&
          scene_session_action_high_water(f.app.session) == scene_resource_action_count(f.app.scene),
          "normal-art replacement releases all retained source owners and old provider/caption resources before recording its successful visit");
    SceneTransitionRequest reentry{};
    bool found_reentry = false;
    for (size_t i = 0; i < scene_session_action_high_water(f.app.session); ++i) {
        SceneExecutorSlotInfo slot{};
        CHECK(scene_session_get_slot(f.app.session, i, &slot) == SCENE_EXECUTOR_OK && slot.occupied &&
              slot.source == f.app.scene && slot.source_index == i,
              "normal-art canonical table contains only the new scene's resource owners");
        Action0bPayload payload{};
        if (slot.action.type == 0x0bu && session_a0b_payload(f.app.a0b, i, &payload) == 0 && payload.target == 4408) {
            reentry.target_scene = payload.target;
            reentry.opaque_words[0] = payload.word_04; reentry.opaque_words[1] = payload.word_06; reentry.opaque_words[2] = payload.word_08;
            reentry.opaque_dwords[0] = payload.dword_0a; reentry.opaque_dwords[1] = payload.dword_0e; reentry.opaque_dwords[2] = payload.dword_12;
            found_reentry = true;
        }
    }
    CHECK(found_reentry && scene_session_request_external_transition(f.app.session, &reentry) == SCENE_SESSION_OK,
          "normal room supplies its actual re-entry tuple to the ordinary public session boundary");
    for (unsigned i = 0; f.app.current_scene_id != 4408 && i < 8u; ++i)
        CHECK(f.tick(), "normal loader re-enters the source room after retained-source cleanup");
    pointer(&f.app, BLACKMOOR_POINTER_MOVE, 0, 0, 0);
    for (unsigned i = 0; !session_a2d_object(f.app.a2d)->movie.flag_206 && i < 8u; ++i)
        CHECK(f.tick(), "normal dispatcher starts the fresh re-entry movie");
    NativeRandomMovieFrame fresh{};
    CHECK(f.app.current_scene_id == 4408 && f.app.last_art_scene_id == 4408 && f.app.retained_scenes.empty() &&
          session_a2d_object(f.app.a2d)->movie.active &&
          native_random_movie_frame(f.app.a2d_media, session_a2d_object(f.app.a2d)->surface_212, &fresh) == 0 && fresh.current_frame == 0,
          "re-entry owns actual first-frame pixels without retired source slots or dangling prior movie ownership");
    std::printf("NO_ART_HOST_STOP source=1137 host_boundary=1 natural_UI_exit=0 erased_row=0 target=4412 reentry=4408 frame=0 retained_sources=0\n");
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
        if (argc != 4 || std::strcmp(argv[1], "--no-art-component") != 0) return 2;
        NoArtFixture fixture;
        if (!fixture.initialize(argv[2])) { fixture.print_log_tail(); CHECK(false, "actual BOOT/new-game/S4408 component initializes"); }
        if (std::strcmp(argv[3], "busy-refusal") == 0) return active_conversation_load_refusal(fixture);
        if (std::strcmp(argv[3], "host-stop-cleanup") == 0) return host_stop_after_no_art_cleanup(fixture);
        if (std::strcmp(argv[3], "first") == 0) return actual_no_art_retention(fixture);
        if (std::strcmp(argv[3], "cleanup") == 0) return natural_second_load(fixture);
        if (std::strcmp(argv[3], "response") == 0) return natural_response(fixture);
        if (std::strcmp(argv[3], "font-chain-boundary") == 0) return natural_font_chain_boundary(fixture);
        return 2;
    }
}
