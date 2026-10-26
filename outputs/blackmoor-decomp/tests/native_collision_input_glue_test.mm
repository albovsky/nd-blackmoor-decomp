/* NATIVE21: real S3450/BOOT/new-game collision input with silent offline audio.
 * Direct scene entry only; no campaign route, story/phase/clock injection,
 * window, output device or original-x86 execution. */
#define main blackmoor_app_entry_for_collision_input_test
#ifndef NATIVE_COLLISION_INPUT_APP_SOURCE
#define NATIVE_COLLISION_INPUT_APP_SOURCE "../src/blackmoor_app.mm"
#endif
#include NATIVE_COLLISION_INPUT_APP_SOURCE
#undef main
#include <csignal>

#define CHECK(condition, message) do { if (!(condition)) { \
    std::fprintf(stderr, "CHECK failed: %s\n", message); return 1; } } while (0)

struct CollisionInputFixture {
    NativeApp app{};
    uint32_t now = 1000u;
    uint64_t muted_frames = 0u;
    ~CollisionInputFixture() { cleanup(&app); }
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
        if (app.log == nullptr || session_input_init(&app.input_state) != SESSION_INPUT_OK) return false;
        int external = 0;
        char error[256]{};
        if (!game_ini_configuration(app.game_directory, &external, &app.closed_captioning)) return false;
        app.closed_captioning = 1u;
        app.resources = game_resources_open((app.game_directory + "/Ciftree").c_str(), external, error, sizeof error);
        GameResourceBytes boot = GAME_RESOURCE_BYTES_INIT;
        if (app.resources == nullptr || !game_resources_load_bytes(app.resources, "BOOT", &boot, error, sizeof error)) return false;
        app.boot = engine_boot_open_memory(boot.bytes, boot.length, error, sizeof error);
        game_resource_bytes_destroy(&boot);
        if (app.boot == nullptr || world_init_cold_zero_event_flags(&app.new_game.action_core) != WORLD_INIT_OK ||
            !load_viewport(&app) || !initialize_caption_runtime(&app) || !initialize_new_game(&app, now) ||
            !clear_before_scene_entry(&app, now)) return false;
        LiveAudioConfig audio{};
        audio.game_directory = directory;
        audio.mode = MAC_AUDIO_MODE_OFFLINE;
        if (live_audio_create(&audio, &app.live_audio, error, sizeof error) != LIVE_AUDIO_OK) {
            std::fprintf(stderr, "Collision offline audio initialization: %s\n", error);
            return false;
        }
        app.offline_audio_frames_per_update = 1u;
        app.framebuffer.resize(640u * 480u * 4u);
        app.selector_entry_valid = true;
        app.selector_entry_frame = 0;
        app.selector_entry_scroll = 0;
        if (!load_scene(&app, 3450)) return false;
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

struct CollisionGesture {
    int row = -1, col = -1, piece = 0, candidate = -1;
    int32_t x = 0, y = 0;
};

static SceneActionInfo collision_action(const CollisionInputFixture &fixture)
{
    SceneActionInfo action{};
    const CpzObject *object = session_ad3_object(fixture.app.ad3);
    if (object && object->row >= 0) (void)native_action_at(&fixture.app, static_cast<size_t>(object->row), &action);
    return action;
}
static int16_t collision_word(const uint8_t *body, size_t at)
{
    return static_cast<int16_t>(static_cast<uint16_t>(body[at]) | (static_cast<uint16_t>(body[at + 1u]) << 8));
}
static bool collision_started(CollisionInputFixture &fixture)
{
    if (!fixture.tick() || !fixture.tick() || !fixture.tick()) return false;
    const CpzObject *object = session_ad3_object(fixture.app.ad3);
    size_t alternatives = 0u;
    for (size_t row = 0; row < native_action_count(&fixture.app); ++row) {
        SceneActionInfo action{};
        if (native_action_at(&fixture.app, row, &action) == SCENE_RESOURCE_OK && action.type == SESSION_AD3_TYPE) ++alternatives;
    }
    return alternatives == 2u && object && object->active && (object->row == 2 || object->row == 3) &&
        object->state == CPZ_STATE_IDLE && session_ad3_world(fixture.app.ad3)->grid_ready &&
        session_ad3_registered(fixture.app.ad3);
}
static void collision_cancel_hover(CollisionInputFixture &fixture)
{
    NativeApp &app = fixture.app;
    const uint8_t *body = collision_action(fixture).raw_body;
    pointer(&app, BLACKMOOR_POINTER_MOVE,
        (read_i32_le(body + 0x347u) + read_i32_le(body + 0x34fu)) / 2 + app.scene_destination.left - app.cursor_provider.hot_x,
        (read_i32_le(body + 0x34bu) + read_i32_le(body + 0x353u)) / 2 + app.scene_destination.top - app.cursor_provider.hot_y, 0u);
}
static bool collision_legal_gesture(const CollisionInputFixture &fixture, CollisionGesture *gesture)
{
    const NativeApp &app = fixture.app;
    const uint8_t *body = collision_action(fixture).raw_body;
    const CpzWorld *world = session_ad3_world(app.ad3);
    const int rows = collision_word(body, 0x22u), cols = collision_word(body, 0x24u);
    const int dr[] = {-1, 0, 1, 0}, dc[] = {0, 1, 0, -1};
    const int direction[] = {CPZ_DIR_UP, CPZ_DIR_RIGHT, CPZ_DIR_DOWN, CPZ_DIR_LEFT};
    const int opposite[] = {CPZ_DIR_DOWN, CPZ_DIR_LEFT, CPZ_DIR_UP, CPZ_DIR_RIGHT};
    const int candidate[] = {CPZ_CANDIDATE_UP, CPZ_CANDIDATE_RIGHT, CPZ_CANDIDATE_DOWN, CPZ_CANDIDATE_LEFT};
    /* Select one immediately legal adjacent cell from the actual initialized
     * grid. This is one input gesture, not a puzzle solver or grid edit. */
    for (int row = 0; row < rows; ++row) for (int col = 0; col < cols; ++col) {
        const CpzCell &cell = world->cell[row][col];
        if (cell.piece == 0) continue;
        for (int d = 0; d < 4; ++d) {
            const int r = row + dr[d], c = col + dc[d];
            if (r < 0 || r >= rows || c < 0 || c >= cols || cell.type == direction[d]) continue;
            const CpzCell &next = world->cell[r][c];
            if (next.piece != 0 || next.type == CPZ_CELL_WALL || next.type == opposite[d]) continue;
            int32_t x = (cell.rect[0] + cell.rect[2]) / 2, y = (cell.rect[1] + cell.rect[3]) / 2;
            if (d == 0) y = cell.rect[1] + 1;
            if (d == 1) x = cell.rect[2] - 1;
            if (d == 2) y = cell.rect[3] - 1;
            if (d == 3) x = cell.rect[0] + 1;
            *gesture = {row, col, cell.piece, candidate[d], x - app.cursor_provider.hot_x, y - app.cursor_provider.hot_y};
            return true;
        }
    }
    return false;
}
static bool collision_release(CollisionInputFixture &fixture)
{
    NativeApp &app = fixture.app;
    pointer(&app, BLACKMOOR_POINTER_DOWN, app.pointer_x, app.pointer_y, 0u);
    pointer(&app, BLACKMOOR_POINTER_UP, app.pointer_x, app.pointer_y, 0u);
    return fixture.tick();
}
static SessionInputHotspot collision_generic()
{
    SessionInputHotspot generic{};
    generic.index = 0; generic.active = 1u; generic.rectangle = {0, 0, 619, 374};
    return generic;
}
static int actual_hover(CollisionInputFixture &fixture)
{
    NativeApp &app = fixture.app;
    /* The first ACT initializes the singleton; only a post-ACT hover can
     * recognize it on this same tick. No puzzle state is preloaded. */
    pointer(&app, BLACKMOOR_POINTER_MOVE, 320, 338, 0u);
    CHECK(fixture.tick(), "actual D3 phase0 and same-tick post-ACT hover succeed");
    const CpzObject *object = session_ad3_object(app.ad3);
    CHECK(object && object->active && object->row == 2 && session_ad3_world(app.ad3)->grid_ready &&
          session_ad3_registered(app.ad3), "actual first-visit S3450 row2 initializes");
    SceneSessionPointerResult result{};
    CHECK(scene_session_get_pointer_result(app.session, &result) == SCENE_SESSION_OK, "actual pointer result is available");
    std::printf("COLLISION_HOVER scene=%d row=%d consume=%d scan=%d candidate=%d hit=%u direct_component_entry=1\n",
        app.current_scene_id, object->row, result.consume_status, result.scan_status, app.input_state.candidate, app.ad3_pointer.hit);
    CHECK(result.consume_status == SESSION_INPUT_OK && result.scan_status == SESSION_INPUT_OK &&
          app.ad3_pointer.hit && app.input_state.candidate == CPZ_CANDIDATE_CANCEL,
          "first post-ACT S3450 hover reaches D3 through guarded native cascade");
    return 0;
}
static int actual_move(CollisionInputFixture &fixture, bool retained)
{
    NativeApp &app = fixture.app;
    CHECK(collision_started(fixture), "two original alternative rows share one naturally initialized controller");
    CollisionGesture gesture{};
    CHECK(collision_legal_gesture(fixture, &gesture), "actual initialized grid offers one legal move");
    pointer(&app, BLACKMOOR_POINTER_MOVE, gesture.x, gesture.y, 0u);
    CHECK(fixture.tick() && app.input_state.candidate == gesture.candidate && app.ad3_pointer.hit,
          "real piece edge hover publishes its legal direction");
    const SessionInputHotspot generic = collision_generic();
    int32_t candidate = -1;
    CHECK(native_pointer_scan(&app, &generic, 1u, &candidate) == SESSION_INPUT_OK && candidate == gesture.candidate &&
          app.nav_cursor.index == app.ad3_pointer.cursor_kind && app.nav_cursor.variant == app.ad3_pointer.cursor_sub,
          "D3 hover and original cursor precede a conflicting generic hotspot");
    if (retained) {
        pointer(&app, BLACKMOOR_POINTER_DOWN, app.pointer_x, app.pointer_y, 0u);
        pointer(&app, BLACKMOOR_POINTER_MOVE, 11, 11, 0u); /* No tick: old direction is still retained. */
        pointer(&app, BLACKMOOR_POINTER_UP, 11, 11, 0u);
        CHECK(fixture.tick(), "move-off release consumes normally");
    } else CHECK(collision_release(fixture), "real release starts one legal piece slide");
    const CpzObject *object = session_ad3_object(app.ad3);
    CHECK(object->state == CPZ_STATE_MOVING && object->piece == gesture.piece,
          "release starts the genuine pending direction without piece/phase injection");
    SceneSessionPointerResult result{};
    CHECK(scene_session_get_pointer_result(app.session, &result) == SCENE_SESSION_OK &&
          result.candidate_at_consume == gesture.candidate && result.candidate_after_scan == -1 && app.input_state.latch[0] == 0u,
          "release uses retained candidate before post-ACT moving/miss scan clears it");
    LiveAudioChannelInfo audio{};
    CHECK(live_audio_get_channel_info(app.live_audio, 8u, &audio) == LIVE_AUDIO_OK && audio.loaded && audio.started,
          "actual piece move starts the real prepared source sound");
    for (unsigned step = 0u; step < 300u && object->state != CPZ_STATE_IDLE; ++step)
        CHECK(fixture.tick(1600u), "one piece slide and its real sound advance to rest");
    CHECK(object->state == CPZ_STATE_IDLE && session_ad3_world(app.ad3)->cell[gesture.row][gesture.col].piece != gesture.piece,
          "actual piece leaves its old cell and comes to rest naturally");
    std::printf("COLLISION_MOVE row=%d piece=%d consumed=%d scanned=%d retained=%d muted_frames=%llu\n",
        object->row, gesture.piece, result.candidate_at_consume,
        result.candidate_after_scan, retained, static_cast<unsigned long long>(fixture.muted_frames));
    return 0;
}
static int actual_cancel(CollisionInputFixture &fixture)
{
    NativeApp &app = fixture.app;
    CHECK(collision_started(fixture), "actual collision controller initializes before cancel");
    const uint8_t *body = collision_action(fixture).raw_body;
    const int target = collision_word(body, 0x32eu), owner = session_ad3_object(app.ad3)->row;
    collision_cancel_hover(fixture);
    CHECK(fixture.tick() && app.input_state.candidate == CPZ_CANDIDATE_CANCEL, "real cancel rectangle claims hover");
    CHECK(collision_release(fixture), "real cancel release reaches phase2 and completion");
    SceneActionRuntimeState state{}; SceneTransitionRequest transition{};
    CHECK(scene_session_get_action_state(app.session, static_cast<size_t>(owner), &state) == SCENE_SESSION_OK && state.completed &&
          !session_ad3_object(app.ad3)->active && !session_ad3_registered(app.ad3) &&
          scene_session_get_pending_transition(app.session, &transition) && transition.target_scene == target,
          "cancel completes its actual row, releases ownership and requests the original target");
    const SessionInputHotspot generic = collision_generic();
    int32_t candidate = -1;
    CHECK(native_pointer_scan(&app, &generic, 1u, &candidate) == SESSION_INPUT_OK && candidate == 0,
          "inactive D3 safely falls through without retaining a stale cancel hit");
    for (unsigned step = 0u; step < 20u && app.current_scene_id != target; ++step)
        CHECK(fixture.tick(1600u), "real cancel transition uses ordinary exit/load states");
    CHECK(app.current_scene_id == target, "cancel loads the original target scene");
    std::printf("COLLISION_CANCEL row=%d completed=1 target=%d inactive_fallthrough=%d muted_frames=%llu\n",
        owner, target, candidate, static_cast<unsigned long long>(fixture.muted_frames));
    return 0;
}
static int actual_miss(CollisionInputFixture &fixture)
{
    NativeApp &app = fixture.app;
    CHECK(collision_started(fixture), "actual controller initializes before safe miss");
    const CpzWorld before = *session_ad3_world(app.ad3);
    pointer(&app, BLACKMOOR_POINTER_MOVE, 11, 11, 0u);
    const SessionInputHotspot generic = collision_generic();
    int32_t candidate = -1;
    CHECK(native_pointer_scan(&app, &generic, 1u, &candidate) == SESSION_INPUT_OK && candidate == 0 && !app.ad3_pointer.hit &&
          std::memcmp(&before, session_ad3_world(app.ad3), sizeof before) == 0,
          "active D3 miss preserves the grid and safely falls through to a generic row");
    std::printf("COLLISION_MISS generic=%d unchanged_grid=1\n", candidate);
    return 0;
}
static int collision_guards(CollisionInputFixture &fixture)
{
    NativeApp &app = fixture.app;
    CHECK(collision_started(fixture), "actual controller initializes before guarded input checks");
    const SessionInputHotspot generic = collision_generic();
    for (unsigned index = 0u; index < 9u; ++index) {
        collision_cancel_hover(fixture);
        if (index == 0u) app.cursor_provider.guard_5b5158 = 1u;
        if (index == 1u) app.cursor_provider.guard_5b61af = 1u;
        if (index == 2u) app.cursor_provider.guard_5b615e = 1u;
        if (index >= 3u && index <= 6u) app.captions.lifecycle.g.overlay_ui = static_cast<int32_t>(index - 1u);
        if (index == 7u) app.captions.lifecycle.g.modal_input = 1;
        if (index == 8u) pointer(&app, BLACKMOOR_POINTER_MOVE, 0, 0, 0u);
        const CpzObject before = *session_ad3_object(app.ad3);
        int32_t candidate = -1;
        const int status = native_pointer_scan(&app, &generic, 1u, &candidate);
        CHECK(status == (index < 3u ? SESSION_INPUT_LIMIT_PRIORITY_PATH : SESSION_INPUT_OK) && candidate == -1 &&
              session_ad3_object(app.ad3)->state == before.state && session_ad3_object(app.ad3)->piece == before.piece &&
              session_ad3_object(app.ad3)->dir == before.dir,
              "priority/UI/disabled/outside guards suppress collision hover and generic selection");
        app.cursor_provider.guard_5b5158 = app.cursor_provider.guard_5b61af = app.cursor_provider.guard_5b615e = 0u;
        app.captions.lifecycle.g.overlay_ui = 0; app.captions.lifecycle.g.modal_input = 0;
    }
    std::printf("COLLISION_GUARDS priority=3 ui_modes=4 disabled=1 outside=1\n");
    return 0;
}
static int collision_owners(CollisionInputFixture &fixture)
{
    NativeApp &app = fixture.app;
    CHECK(collision_started(fixture), "actual controller initializes before ownership metadata checks");
    collision_cancel_hover(fixture);
    /* Negative ownership metadata only. No injected row runs or produces
     * puzzle effects; the live binding still holds the unmodified S3450. */
    GameResourceBytes bytes = GAME_RESOURCE_BYTES_INIT; char error[256]{};
    CHECK(game_resources_load_bytes(app.resources, "S3450", &bytes, error, sizeof error), "negative metadata source loads");
    std::vector<uint8_t> metadata(bytes.bytes, bytes.bytes + bytes.length);
    game_resource_bytes_destroy(&bytes);
    const size_t start = metadata.size(); metadata.resize(start + 58u, 0u);
    std::memcpy(metadata.data() + start, "ACT", 3u);
    auto put_be = [&](size_t offset, uint32_t value) {
        for (unsigned i = 0u; i < 4u; ++i) metadata[offset + i] = static_cast<uint8_t>(value >> (24u - i * 8u));
    };
    put_be(start + 4u, 50u); metadata[start + 56u] = 0xcf; metadata[start + 57u] = 1u;
    put_be(4u, static_cast<uint32_t>(metadata.size() - 8u));
    SceneResource *negative = scene_resource_open_memory(metadata.data(), metadata.size(), error, sizeof error);
    CHECK(negative, "negative possible-receiver metadata is a valid bounded scene");
    SceneResource *original_scene = app.scene; SceneSession *original_session = app.session;
    app.scene = negative; app.session = nullptr;
    const SessionInputHotspot generic = collision_generic(); int32_t candidate = -1;
    const int extra_owner = native_pointer_scan(&app, &generic, 1u, &candidate);
    app.scene = original_scene; app.session = original_session; scene_resource_close(negative);
    CHECK(extra_owner == SESSION_INPUT_LIMIT_PRIORITY_PATH && candidate == -1,
          "another possible receiver preserves explicit priority refusal");
    CpzObject *object = const_cast<CpzObject *>(session_ad3_object(app.ad3));
    const int16_t original_row = object->row; object->row = 0; /* Negative owner identity only; no dispatch. */
    const int wrong_owner = native_pointer_scan(&app, &generic, 1u, &candidate);
    object->row = original_row;
    CHECK(wrong_owner == SESSION_INPUT_LIMIT_PRIORITY_PATH && candidate == -1,
          "active collision owner must map to an actual D3 row");
    std::printf("COLLISION_OWNERS actual_alternatives=2 extra_receiver_refused=1 wrong_owner_refused=1\n");
    return 0;
}
static void collision_fixture_signal(int number)
{
    static const char message[] = "collision input fixture/native signal failure\n";
    (void)write(STDERR_FILENO, message, sizeof(message) - 1u); _exit(128 + number);
}
int main(int argc, char **argv)
{
    std::signal(SIGBUS, collision_fixture_signal); std::signal(SIGSEGV, collision_fixture_signal);
    std::signal(SIGABRT, collision_fixture_signal); std::signal(SIGILL, collision_fixture_signal);
    @autoreleasepool {
        CHECK(argc == 3, "owner-local game directory and component mode required");
        CollisionInputFixture fixture;
        const char *mode = argv[2];
        const bool initialized = fixture.initialize(argv[1]);
        if (!initialized) fixture.print_log_tail();
        CHECK(initialized, "actual BOOT/new-game direct-entry S3450 initializes");
        if (std::strcmp(mode, "hover") == 0) return actual_hover(fixture);
        if (std::strcmp(mode, "move") == 0) return actual_move(fixture, false);
        if (std::strcmp(mode, "retained") == 0) return actual_move(fixture, true);
        if (std::strcmp(mode, "cancel") == 0) return actual_cancel(fixture);
        if (std::strcmp(mode, "miss") == 0) return actual_miss(fixture);
        if (std::strcmp(mode, "guards") == 0) return collision_guards(fixture);
        if (std::strcmp(mode, "owners") == 0) return collision_owners(fixture);
        return 2;
    }
}
