/* NATIVE-02: actual app pointer callbacks and a complete, local S4376 scene.
 * No window, output device, original-x86 execution or copied resource fixture.
 * Rendering and sound host operations are inert; input and D1 state are real.
 * Failures use ordinary exit codes, never assert/abort. */
#define main blackmoor_app_entry_for_pointer_test
#ifndef NATIVE_POINTER_APP_SOURCE
#define NATIVE_POINTER_APP_SOURCE "../src/blackmoor_app.mm"
#endif
#include NATIVE_POINTER_APP_SOURCE
#undef main
#include <fstream>
#include <iterator>
#include <csignal>

static int overlay_slot(void *, int16_t *slot) { *slot = 0x18; return 0; }
static int overlay_register(void *, int16_t, const char *) { return 0; }
static int overlay_load(void *, const char *, uint32_t *surface) { *surface = 1; return 0; }
static int overlay_surface(void *, int16_t, uint32_t) { return 0; }
static int overlay_release(void *, uint32_t) { return 0; }
static int overlay_slot_op(void *, int16_t) { return 0; }
static int clear_item(void *) { return 0; }
static int sound_record(void *, int, const uint8_t *) { return 0; }
static int sound_channel(void *, int16_t) { return 0; }
static int sound_idle(void *, int16_t, int32_t *busy) { *busy = 0; return 0; }
static int flag_invalid(void *, int16_t flag) { return flag < 0 || flag >= 4096; }
static int transition_unused(void *, const D1Transition *) { return 1; }
static int flag_unused(void *, int16_t, uint32_t) { return 1; }
static SceneSessionCallbackStatus prepare(void *, SceneConditionState *, SceneExecutorFrameInput *,
                                           SceneSessionFailure *)
{ return SCENE_SESSION_CALLBACK_OK; }
static SceneSessionCallbackStatus media(void *, SceneExecutorFrameInput *, SceneSessionFailure *)
{ return SCENE_SESSION_CALLBACK_OK; }

/* S4376's overlay and ambient-sound actions are outside this input regression. */
static int other_action(void *, size_t, const SceneActionInfo *, const SceneActionRuntimeState *before,
                         SceneActionHandlerResult *out)
{
    out->phase = before->phase;
    out->disposition = SCENE_ACTION_HANDLER_PENDING;
    return SCENE_ACTION_HANDLER_OK;
}

static int background_sound_condition(void *, const SceneConditionLeafRequest *request,
                                       int32_t *status, int *)
{
    if (request->record.opcode != 17) {
        std::fprintf(stderr, "fixture needs non-input dependency opcode=%u\n", request->record.opcode);
        return SCENE_CONDITION_ERR_UNSUPPORTED_OPCODE;
    }
    *status = 0; /* The ambient sound action is outside this input fixture. */
    return SCENE_CONDITION_OK;
}

static void put_be32(std::vector<uint8_t> &bytes, size_t offset, uint32_t value)
{
    for (size_t i = 0; i < 4; ++i) bytes[offset + i] = static_cast<uint8_t>(value >> (24 - 8 * i));
}

static bool add_unknown_earlier_member(std::vector<uint8_t> &bytes)
{
    if (bytes.size() < 12 || std::memcmp(bytes.data(), "DATA", 4) != 0 ||
        std::memcmp(bytes.data() + 8, "SCEN", 4) != 0) return false;
    const size_t start = bytes.size();
    bytes.resize(start + 8 + 50, 0);
    std::memcpy(bytes.data() + start, "ACT", 3);
    put_be32(bytes, start + 4, 50);
    const char label[] = "NATIVE-02 opaque earlier receiver";
    std::memcpy(bytes.data() + start + 8, label, sizeof(label));
    bytes[start + 8 + 48] = 0xcf; /* Tangram precedes D1 in 0x4f0059. */
    bytes[start + 8 + 49] = 1;
    put_be32(bytes, 4, static_cast<uint32_t>(bytes.size() - 8));
    return true;
}

struct Fixture {
    NativeApp app;
    SceneResource *session_scene = nullptr;
    ActionCoreWorld world{};
    SceneConditionState conditions{};
    SceneConditionExtension extension{}; /* The session borrows this for every tick. */
    std::vector<int32_t> flags = std::vector<int32_t>(4096);
    std::vector<SceneSessionActionBinding> bindings;
    std::vector<uint8_t> bytes;
    ~Fixture()
    {
        scene_session_destroy(app.session);
        session_ad1_destroy(app.ad1);
        if (app.scene != session_scene) scene_resource_close(app.scene);
        scene_resource_close(session_scene);
        if (app.log != nullptr) std::fclose(app.log);
    }

    bool initialize(const char *path, bool unknown)
    {
        std::ifstream input(path, std::ios::binary);
        bytes.assign(std::istreambuf_iterator<char>(input), {});
        if (bytes.empty()) return false;
        app.log = std::tmpfile();
        if (app.log == nullptr) return false;
        char error[256]{};
        session_scene = scene_resource_open_memory(bytes.data(), bytes.size(), error, sizeof(error));
        if (session_scene == nullptr) {
            std::fprintf(stderr, "fixture scene: %s\n", error);
            return false;
        }
        app.scene = session_scene;
        if (unknown) {
            /* The executor correctly refuses opaque CF rows. Keep the real
             * S4376 session and binding, and give the actual app callbacks a
             * parsed scene view containing that possible earlier owner. This
             * is a negative scope fixture, not a claim CF can execute. */
            if (!add_unknown_earlier_member(bytes)) return false;
            app.scene = scene_resource_open_memory(bytes.data(), bytes.size(), error, sizeof(error));
            if (app.scene == nullptr) return false;
        }
        app.current_scene_id = 4376;
        app.scene_destination = {10, 10, 629, 384};
        app.bar_missing = true; /* No taskbar/BOOT assets; pointer is inside the scene. */
        app.session_tick_sample = 1000;
        SessionAd1Host host{};
        host.kernel.context = &app;
        host.kernel.alloc_slot = overlay_slot;
        host.kernel.register_slot = overlay_register;
        host.kernel.load_surface = overlay_load;
        host.kernel.set_slot_surface = overlay_surface;
        host.kernel.release_surface = overlay_release;
        host.kernel.release_slot = overlay_slot_op;
        host.kernel.mark_dirty = overlay_slot_op;
        host.kernel.view_origin = native_ad1_view_origin;
        host.kernel.clear_pending_item = clear_item;
        host.kernel.sound_prepare = sound_record;
        host.kernel.sound_stop = sound_record;
        host.kernel.sound_play = sound_channel;
        host.kernel.sound_busy = sound_idle;
        host.kernel.tick = native_ad1_tick;
        host.kernel.event_flag_invalid = flag_invalid;
        host.kernel.transition = transition_unused;
        host.kernel.store_event_flag = flag_unused;
        host.store_world = native_ad1_store_world;
        app.ad1 = session_ad1_create(&host);
        if (app.ad1 == nullptr || session_ad1_begin_scene(app.ad1, session_scene) != D1_OK) return false;

        std::vector<uint8_t> types;
        for (size_t row = 0; row < scene_resource_action_count(session_scene); ++row) {
            SceneActionInfo info{};
            if (scene_resource_action_at(session_scene, row, &info) != SCENE_RESOURCE_OK) return false;
            if (std::find(types.begin(), types.end(), info.type) == types.end()) {
                types.push_back(info.type);
                SceneSessionActionBinding binding{};
                binding.type = info.type;
                binding.provider = SCENE_SESSION_PROVIDER_HOST;
                binding.callback = info.type == SESSION_AD1_TYPE ? native_ad1_handler : other_action;
                binding.context = &app;
                bindings.push_back(binding);
            }
        }
        if (unknown) types.push_back(0xcf);
        /* Same scene-derived guard used by nav_begin_scene, never forced clear. */
        app.nav_members_idle = session_navigation_members_idle(types.data(), types.size()) != 0;
        world.event_flags = flags.data(); world.event_flag_count = flags.size();
        conditions.event_flags = flags.data(); conditions.event_flag_count = flags.size();
        SceneSessionConfig config{};
        config.scene = session_scene; config.scene_id = 4376;
        config.action_core_world = &world; config.conditions = &conditions;
        config.action_bindings = bindings.data(); config.action_binding_count = bindings.size();
        config.prepare_tick = prepare; config.advance_media_one = media;
        config.provider_context = &app;
        SceneSessionFailure failure{};
        const int create_status = scene_session_create(&config, &app.session, &failure);
        if (create_status != SCENE_SESSION_OK) {
            std::fprintf(stderr, "fixture session create=%d provider=%d row=%zu detail=%d\n", create_status,
                         failure.provider, failure.action_index, failure.detail_status);
            return false;
        }
        extension.evaluate_leaf = background_sound_condition;
        if (scene_session_set_condition_extension(app.session, &extension) != SCENE_SESSION_OK) return false;
        SceneSessionPointerHost pointer_host{};
        pointer_host.context = &app;
        pointer_host.consume = native_pointer_consume;
        pointer_host.scan = native_pointer_scan;
        pointer_host.reset = native_pointer_reset;
        if (scene_session_bind_pointer(app.session, &pointer_host) != SCENE_SESSION_OK || !tick()) return false;
        const D1Object *object = session_ad1_object(app.ad1);
        SceneActionRuntimeState state{};
        const int state_status = scene_session_get_action_state(app.session, 1, &state);
        if (object == nullptr || object->active == 0 || object->row != 1 || object->state != D1_STATE_IDLE ||
            state_status != SCENE_SESSION_OK || state.phase != 1) {
            std::fprintf(stderr, "fixture initialized active=%d row=%d state=%d phase_status=%d phase=%u\n",
                         object == nullptr ? -1 : object->active, object == nullptr ? -1 : object->row,
                         object == nullptr ? -1 : object->state, state_status, state.phase);
            return false;
        }
        return true;
    }

    bool tick()
    {
        SceneSessionTickResult result{};
        const int status = scene_session_tick(app.session, &result);
        if (status != SCENE_SESSION_OK)
            std::fprintf(stderr, "fixture tick status=%d provider=%d row=%zu detail=%d\n", status,
                         result.failure.provider, result.failure.action_index, result.failure.detail_status);
        return status == SCENE_SESSION_OK;
    }
};

static int exercise_miss(Fixture &f)
{
    SceneActionInfo action{};
    if (scene_resource_action_at(f.session_scene, 1, &action) != SCENE_RESOURCE_OK) return 2;
    auto dword = [&](size_t offset) -> int32_t {
        const uint8_t *b = action.typed_body + offset;
        return static_cast<int32_t>(static_cast<uint32_t>(b[0]) | (static_cast<uint32_t>(b[1]) << 8) |
                                    (static_cast<uint32_t>(b[2]) << 16) | (static_cast<uint32_t>(b[3]) << 24));
    };
    auto inside = [&](int32_t x, int32_t y, size_t offset) {
        return dword(offset) <= x && x <= dword(offset + 8) &&
               dword(offset + 4) <= y && y <= dword(offset + 12);
    };
    const int count = action.typed_body[0x21] | (action.typed_body[0x22] << 8);
    int32_t miss_x = -1, miss_y = -1;
    for (int32_t y = 0; y < 375 && miss_x < 0; ++y) {
        for (int32_t x = 0; x < 620; ++x) {
            bool hit = inside(x, y, 0x38fu);
            for (int tile = 0; tile < count; ++tile)
                hit = hit || inside(x, y, 0x147u + static_cast<size_t>(tile) * 16u);
            if (!hit) { miss_x = x; miss_y = y; break; }
        }
    }
    if (miss_x < 0) return 2;
    pointer(&f.app, BLACKMOOR_POINTER_MOVE, miss_x + 10, miss_y + 10, 0);
    if (!f.tick()) return 2;
    SceneSessionPointerResult missed{};
    if (scene_session_get_pointer_result(f.app.session, &missed) != SCENE_SESSION_OK) return 2;
    /* A valid generic host row may claim only after the D1 receiver missed. */
    SessionInputHotspot generic{};
    generic.index = 0;
    generic.rectangle = {0, 0, 619, 374};
    generic.active = 1;
    int32_t candidate = -1;
    const int status = native_pointer_scan(&f.app, &generic, 1u, &candidate);
    const D1Object *object = session_ad1_object(f.app.ad1);
    std::printf("D1_MISS consume=%d scan=%d fallback=%d candidate=%d tile=%d\n",
                missed.consume_status, missed.scan_status, status, candidate, object->last_tile);
    if (missed.consume_status != SESSION_INPUT_OK || missed.scan_status != SESSION_INPUT_OK ||
        status != SESSION_INPUT_OK || candidate != 0 || object->last_tile != -1 || object->moving[0] != 0) {
        std::fprintf(stderr, "FAIL: a D1 miss must preserve guarded generic fallthrough without moving tiles\n");
        return 1;
    }
    return 0;
}

static int exercise(const char *path, const char *kind)
{
    const bool unknown = std::strcmp(kind, "unknown") == 0;
    Fixture f;
    if (!f.initialize(path, unknown)) {
        std::fprintf(stderr, "fixture initialization failed\n");
        return 2;
    }
    if (std::strcmp(kind, "miss") == 0) return exercise_miss(f);
    /* S4376 row 1 tile 0: original inclusive hit rect (200,238,249,303).
     * Coordinates include the app's (10,10) viewport origin. Expectations are
     * derived from immutable body bytes, not from the native hit-test output. */
    pointer(&f.app, BLACKMOOR_POINTER_MOVE, 234, 280, 0);
    if (!f.tick()) return 2;
    SceneSessionPointerResult hover{};
    if (scene_session_get_pointer_result(f.app.session, &hover) != SCENE_SESSION_OK) return 2;
    const int32_t retained = f.app.input_state.candidate;
    const int16_t hovered_tile = session_ad1_object(f.app.ad1)->last_tile;
    SceneActionInfo action{};
    if (scene_resource_action_at(f.session_scene, 1, &action) != SCENE_RESOURCE_OK) return 2;
    auto word = [&](size_t offset) -> int16_t {
        return static_cast<int16_t>(action.typed_body[offset] |
                                    static_cast<uint16_t>(action.typed_body[offset + 1] << 8));
    };
    const int16_t tile_count = word(0x21u), frame_count = word(0x23u);
    if (tile_count != 6 || frame_count != 7 || word(0x25u) != 1) return 2;
    std::array<int16_t, D1_MAX_TILES> frames_before{};
    for (int tile = 0; tile < tile_count; ++tile)
        frames_before[static_cast<size_t>(tile)] = session_ad1_object(f.app.ad1)->frame[tile];
    /* Actual platform callback -> latch -> actual consume callback. No direct
     * candidate publication, latch writes, or D1 pointer/click calls here. */
    pointer(&f.app, BLACKMOOR_POINTER_DOWN, 234, 280, 0);
    pointer(&f.app, BLACKMOOR_POINTER_UP, 11, 11, 0); /* Button coordinates do not replace the last MOVE. */
    if (!f.tick()) return 2;
    const D1Object *object = session_ad1_object(f.app.ad1);
    SceneSessionPointerResult release{};
    if (scene_session_get_pointer_result(f.app.session, &release) != SCENE_SESSION_OK) return 2;
    std::printf("D1_PATH fixture=%s hover_consume=%d hover_scan=%d candidate=%d tile=%d "
                "release_consume=%d state=%d moving0=%d frame0=%d->%d\n", unknown ? "unknown-earlier" : "real-S4376",
                hover.consume_status, hover.scan_status, retained, hovered_tile, release.consume_status,
                object->state, object->moving[0], frames_before[0], object->frame[0]);
    bool exact_frames = true;
    for (int tile = 0; tile < tile_count; ++tile) {
        bool linked = tile == 0;
        for (int link = 0; link < 4; ++link)
            if (word(0x254u + static_cast<size_t>(link) * 2u) == tile + 1) linked = true;
        const int16_t expected = !unknown && linked
            ? static_cast<int16_t>((frames_before[static_cast<size_t>(tile)] + 1) % frame_count)
            : frames_before[static_cast<size_t>(tile)];
        if (object->frame[tile] != expected) exact_frames = false;
    }
    /* S4376 has one animation substep. ACT advances linked tiles and clears
     * moving in this same release tick; assert the resulting frames, rather
     * than requiring the transient ANIMATE state to survive dispatch. */
    const bool passed = unknown
        ? hover.scan_status == SESSION_INPUT_LIMIT_PRIORITY_PATH && retained == -1 &&
            object->state == D1_STATE_IDLE && object->moving[0] == 0 && exact_frames
        : retained == 0x276c && hovered_tile == 0 && exact_frames &&
            object->state == D1_STATE_IDLE && object->moving[0] == 0;
    if (!passed) {
        std::fprintf(stderr, "%s\n", unknown
            ? "FAIL: an unimplemented earlier receiver must remain explicitly limited and cannot turn a D1 tile"
            : "FAIL: a real D1 tile must publish candidate 0x276c and advance exactly its linked tiles through the actual app release path");
        return 1;
    }
    return 0;
}

static void fixture_signal(int number)
{
    /* A fixture/native fault is still a failed test, but must not create a
     * macOS crash-report dialog. Only async-signal-safe operations here. */
    static const char prefix[] = "fixture/native signal failure number=";
    const char digits[] = {static_cast<char>('0' + number / 10), static_cast<char>('0' + number % 10), '\n'};
    (void)write(STDERR_FILENO, prefix, sizeof(prefix) - 1);
    (void)write(STDERR_FILENO, digits, sizeof(digits));
    _exit(128 + number);
}

int main(int argc, char **argv)
{
    std::signal(SIGBUS, fixture_signal);
    std::signal(SIGSEGV, fixture_signal);
    std::signal(SIGABRT, fixture_signal);
    @autoreleasepool {
        if (argc != 3 || (std::strcmp(argv[2], "real") != 0 && std::strcmp(argv[2], "unknown") != 0 &&
                          std::strcmp(argv[2], "miss") != 0)) return 2;
        return exercise(argv[1], argv[2]);
    }
}
