/* NATIVE-09/10: actual app callbacks and the owner's complete S3395 body.
 * Components sink rendering, text and finish transition effects. Ordinary
 * input cases sink sound; named audio cases use production D0 callbacks and a
 * real muted offline graph. The binding, executor, pointer projection/latch
 * and piano state run intact.
 * Normal mode invokes the actual muted offline app. No resource payloads,
 * original-x86 execution, window or output device are used. */
#define main blackmoor_app_entry_for_piano_test
#ifndef NATIVE_PIANO_APP_SOURCE
#define NATIVE_PIANO_APP_SOURCE "../src/blackmoor_app.mm"
#endif
#include NATIVE_PIANO_APP_SOURCE
#undef main
#include <csignal>

#define CHECK(condition, message) do { if (!(condition)) { \
    std::fprintf(stderr, "CHECK failed: %s\n", message); return 1; } } while (0)

static int sink_slot(void *, int16_t *slot) { *slot = 24; return 0; }
static int sink_register(void *, int16_t, const char *) { return 0; }
static int sink_load(void *, const char *, uint32_t *surface) { *surface = 1; return 0; }
static int sink_surface(void *, int16_t, uint32_t) { return 0; }
static int sink_release(void *, uint32_t) { return 0; }
static int sink_slot_op(void *, int16_t) { return 0; }
static int sink_record(void *, const uint8_t *) { return 0; }
static int sink_channel(void *, int16_t) { return 0; }
static int sink_busy(void *, int16_t, int32_t *busy) { *busy = 0; return 0; }
static int sink_idle(void *) { return 0; }
static int sink_text_lookup(void *, const char *, const char **text) { *text = nullptr; return 0; }
static int sink_text_show(void *, const char *) { return 0; }
static int transition_target = -1;
static int sink_transition(void *, const D0Transition *t) { transition_target = t->scene; return 0; }
static int observed_hover = -2;
static unsigned phase2_dispatches = 0;
static int observe_piano_handler(void *context, size_t row, const SceneActionInfo *action,
                                 const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    observed_hover = session_ad0_object(app->ad0)->hover;
    if (before->phase == 2u) ++phase2_dispatches;
    return native_ad0_handler(context, row, action, before, out);
}
static SceneSessionCallbackStatus prepare_piano(void *, SceneConditionState *, SceneExecutorFrameInput *,
                                                SceneSessionFailure *) { return SCENE_SESSION_CALLBACK_OK; }
static SceneSessionCallbackStatus advance_piano_media(void *, SceneExecutorFrameInput *, SceneSessionFailure *)
{ return SCENE_SESSION_CALLBACK_OK; }
static int other_action(void *, size_t, const SceneActionInfo *, const SceneActionRuntimeState *before,
                         SceneActionHandlerResult *out)
{
    out->phase = before->phase;
    out->disposition = SCENE_ACTION_HANDLER_PENDING;
    return SCENE_ACTION_HANDLER_OK;
}
static int sound_condition(void *, const SceneConditionLeafRequest *request, int32_t *status, int *)
{
    if (request->record.opcode != 17) return SCENE_CONDITION_ERR_UNSUPPORTED_OPCODE;
    *status = 0; /* Ambient sound is outside these input components. */
    return SCENE_CONDITION_OK;
}

struct PianoFixture {
    NativeApp app;
    SceneResource *session_scene = nullptr;
    std::vector<uint8_t> bytes;
    std::vector<int32_t> flags = std::vector<int32_t>(4096);
    std::vector<SceneSessionActionBinding> bindings;
    ActionCoreWorld world{};
    SceneConditionState conditions{};
    SceneConditionExtension extension{};
    size_t row = SIZE_MAX;
    uint64_t muted_frames = 0;
    ~PianoFixture()
    {
        scene_session_destroy(app.session);
        session_ad0_destroy(app.ad0);
        if (app.live_audio != nullptr) live_audio_destroy(app.live_audio);
        if (app.scene != session_scene) scene_resource_close(app.scene);
        scene_resource_close(session_scene);
        game_resources_close(app.resources);
        if (app.log != nullptr) std::fclose(app.log);
    }
    SceneActionInfo action() const
    {
        SceneActionInfo info{};
        (void)scene_resource_action_at(session_scene, row, &info);
        return info;
    }
    int16_t word(size_t offset) const
    {
        const uint8_t *p = action().typed_body + offset;
        return static_cast<int16_t>(p[0] | static_cast<uint16_t>(p[1] << 8));
    }
    int32_t value(size_t offset) const
    {
        const uint8_t *p = action().typed_body + offset;
        return static_cast<int32_t>(static_cast<uint32_t>(p[0]) | (static_cast<uint32_t>(p[1]) << 8) |
                                    (static_cast<uint32_t>(p[2]) << 16) | (static_cast<uint32_t>(p[3]) << 24));
    }
    bool contains(int32_t x, int32_t y, size_t rectangle) const
    {
        return value(rectangle) <= x && x <= value(rectangle + 8) &&
               value(rectangle + 4) <= y && y <= value(rectangle + 12);
    }
    bool load(const char *directory, int scene_id = 3395)
    {
        app.game_directory = directory;
        app.log = std::tmpfile();
        if (app.log == nullptr) return false;
        int external = 0;
        if (!game_ini_configuration(app.game_directory, &external, &app.closed_captioning)) return false;
        char error[256]{};
        app.resources = game_resources_open((app.game_directory + "/Ciftree").c_str(), external, error, sizeof(error));
        if (app.resources == nullptr) return false;
        GameResourceBytes resource = GAME_RESOURCE_BYTES_INIT;
        const std::string scene_name = "S" + std::to_string(scene_id);
        if (!game_resources_load_bytes(app.resources, scene_name.c_str(), &resource, error, sizeof(error))) return false;
        bytes.assign(resource.bytes, resource.bytes + resource.length);
        game_resource_bytes_destroy(&resource);
        session_scene = scene_resource_open_memory(bytes.data(), bytes.size(), error, sizeof(error));
        if (session_scene == nullptr) return false;
        app.scene = session_scene;
        for (size_t i = 0; i < scene_resource_action_count(session_scene); ++i) {
            SceneActionInfo a{};
            if (scene_resource_action_at(session_scene, i, &a) != SCENE_RESOURCE_OK) return false;
            if (a.type == SESSION_AD0_TYPE) {
                if (row != SIZE_MAX || a.typed_body_length != D0_BODY_BYTES) return false;
                row = i;
            }
        }
        return row != SIZE_MAX;
    }
    bool add_owner(bool duplicate)
    {
        /* Negative ownership metadata only; the real executor still uses the
         * original scene. No injected row executes or produces puzzle effects. */
        const SceneActionInfo original = action();
        const size_t body_size = duplicate ? original.typed_body_length : 0u;
        const size_t start = bytes.size();
        if (start < 12 || std::memcmp(bytes.data(), "DATA", 4) != 0) return false;
        bytes.resize(start + 58u + body_size + (body_size & 1u), 0); /* HIFF odd-payload pad. */
        std::memcpy(bytes.data() + start, "ACT", 3);
        auto put_be32 = [&](size_t offset, uint32_t value) {
            for (unsigned i = 0; i < 4; ++i) bytes[offset + i] = static_cast<uint8_t>(value >> (24u - 8u * i));
        };
        put_be32(start + 4u, static_cast<uint32_t>(50u + body_size));
        const char name[] = "NATIVE09 ownership-negative";
        std::memcpy(bytes.data() + start + 8u, name, sizeof(name));
        bytes[start + 56u] = duplicate ? SESSION_AD0_TYPE : 0xcf;
        bytes[start + 57u] = 1;
        if (duplicate) std::memcpy(bytes.data() + start + 58u, original.typed_body, body_size);
        put_be32(4u, static_cast<uint32_t>(bytes.size() - 8u));
        char error[256]{};
        app.scene = scene_resource_open_memory(bytes.data(), bytes.size(), error, sizeof(error));
        if (app.scene == nullptr) std::fprintf(stderr, "piano owner metadata: %s\n", error);
        return app.scene != nullptr;
    }
    bool initialize(const char *directory, const char *owner = nullptr, bool real_audio = false, int scene_id = 3395)
    {
        if (!load(directory, scene_id) || (owner != nullptr && !add_owner(std::strcmp(owner, "duplicate") == 0))) { std::fprintf(stderr, "piano fixture resource load failed\n"); return false; }
        app.current_scene_id = scene_id;
        app.scene_destination = {10, 10, 629, 384};
        app.bar_missing = true;
        app.session_tick_sample = 1000;
        app.new_game.action_core.event_flags = flags.data();
        app.new_game.action_core.event_flag_count = flags.size();
        if (real_audio) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"BlackmoorAudioMuted"];
            LiveAudioConfig audio{};
            audio.game_directory = directory;
            audio.mode = MAC_AUDIO_MODE_OFFLINE;
            char error[256]{};
            if (live_audio_create(&audio, &app.live_audio, error, sizeof(error)) != LIVE_AUDIO_OK) {
                std::fprintf(stderr, "piano offline audio: %s\n", error);
                return false;
            }
        }
        SessionAd0Host host{};
        host.kernel.context = &app;
        host.kernel.alloc_slot = sink_slot; host.kernel.register_slot = sink_register;
        host.kernel.load_surface = sink_load; host.kernel.set_slot_surface = sink_surface;
        host.kernel.release_surface = sink_release; host.kernel.release_slot = sink_slot_op;
        host.kernel.mark_dirty = sink_slot_op; host.kernel.view_origin = native_ad1_view_origin;
        host.kernel.clear_pending_item = sink_idle;
        host.kernel.sound_prepare = real_audio ? native_ad0_sound_prepare : sink_record;
        host.kernel.sound_stop = real_audio ? native_ad0_sound_stop : sink_record;
        host.kernel.sound_play = real_audio ? native_ad0_sound_play : sink_channel;
        host.kernel.sound_busy = real_audio ? native_ad0_sound_busy : sink_busy;
        host.kernel.tick = native_ad1_tick;
        host.kernel.text_lookup = sink_text_lookup; host.kernel.text_show = sink_text_show;
        host.kernel.event_flag_invalid = native_ad1_event_flag_invalid;
        host.kernel.transition = sink_transition; host.kernel.store_event_flag = native_ad1_store_event_flag;
        host.store_world = native_ad0_store_world;
        app.ad0 = session_ad0_create(&host);
        if (app.ad0 == nullptr || session_ad0_begin_scene(app.ad0, session_scene) != D0_OK) { std::fprintf(stderr, "piano binding init failed\n"); return false; }
        std::vector<uint8_t> types;
        for (size_t i = 0; i < scene_resource_action_count(app.scene); ++i) {
            SceneActionInfo a{};
            if (scene_resource_action_at(app.scene, i, &a) != SCENE_RESOURCE_OK) return false;
            types.push_back(a.type);
        }
        app.nav_members_idle = session_navigation_members_idle(types.data(), types.size()) != 0;
        std::vector<uint8_t> bound;
        for (size_t i = 0; i < scene_resource_action_count(session_scene); ++i) {
            SceneActionInfo a{};
            if (scene_resource_action_at(session_scene, i, &a) != SCENE_RESOURCE_OK) return false;
            if (a.type == 0x0a || a.type == 0x15 || a.type == 0x4d || a.type == 0x61 || a.type == 0x64 ||
                a.type == 0x6a || a.type == 0x6b || a.type == 0x71 ||
                std::find(bound.begin(), bound.end(), a.type) != bound.end()) continue;
            bound.push_back(a.type);
            SceneSessionActionBinding binding{};
            binding.type = a.type; binding.provider = SCENE_SESSION_PROVIDER_HOST;
            binding.callback = a.type == SESSION_AD0_TYPE ? observe_piano_handler : other_action;
            binding.context = &app; bindings.push_back(binding);
        }
        world.event_flags = flags.data(); world.event_flag_count = flags.size();
        conditions.event_flags = flags.data(); conditions.event_flag_count = flags.size();
        SceneSessionConfig config{};
        config.scene = session_scene; config.scene_id = scene_id;
        config.action_core_world = &world; config.conditions = &conditions;
        config.action_bindings = bindings.data(); config.action_binding_count = bindings.size();
        config.prepare_tick = prepare_piano; config.advance_media_one = advance_piano_media; config.provider_context = &app;
        SceneSessionFailure failure{};
        const int create_status = scene_session_create(&config, &app.session, &failure);
        if (create_status != SCENE_SESSION_OK) { std::fprintf(stderr, "piano session create failed status=%d provider=%d row=%zu detail=%d\n", create_status, failure.provider, failure.action_index, failure.detail_status); return false; }
        extension.evaluate_leaf = sound_condition;
        if (scene_session_set_condition_extension(app.session, &extension) != SCENE_SESSION_OK) { std::fprintf(stderr, "piano extension failed\n"); return false; }
        SceneSessionPointerHost pointer_host{};
        pointer_host.context = &app; pointer_host.consume = native_pointer_consume;
        pointer_host.scan = native_pointer_scan; pointer_host.reset = native_pointer_reset;
        if (scene_session_bind_pointer(app.session, &pointer_host) != SCENE_SESSION_OK || !tick()) { std::fprintf(stderr, "piano bind/tick failed\n"); return false; }
        SceneActionRuntimeState state{};
        const int state_status = scene_session_get_action_state(app.session, row, &state);
        if (state_status != SCENE_SESSION_OK || state.phase != 1u || object()->active == 0 || object()->state != D0_STATE_IDLE)
            std::fprintf(stderr, "piano fixture row=%zu phase=%u active=%d state=%d status=%d\n", row, state.phase, object()->active, object()->state, state_status);
        return state_status == SCENE_SESSION_OK && state.phase == 1u && object()->active != 0 && object()->state == D0_STATE_IDLE;
    }
    const D0Object *object() const { return session_ad0_object(app.ad0); }
    void move_to(size_t rectangle)
    {
        pointer(&app, BLACKMOOR_POINTER_MOVE,
                (value(rectangle) + value(rectangle + 8)) / 2 + 10 - app.cursor_provider.hot_x,
                (value(rectangle + 4) + value(rectangle + 12)) / 2 + 10 - app.cursor_provider.hot_y, 0);
    }
    bool tick(uint32_t delta = 85)
    {
        app.session_tick_sample += delta;
        SceneSessionTickResult result{};
        const int status = scene_session_tick(app.session, &result);
        if (status != SCENE_SESSION_OK) std::fprintf(stderr, "piano fixture tick=%d provider=%d row=%zu detail=%d\n",
            status, result.failure.provider, result.failure.action_index, result.failure.detail_status);
        D0RenderResult render{};
        const int rendered = session_ad0_render(app.ad0, &render);
        return status == SCENE_SESSION_OK && rendered == D0_OK;
    }
    bool render_audio(uint64_t frames)
    {
        LiveAudioOfflineStats stats{};
        if (app.live_audio == nullptr || live_audio_advance_offline(app.live_audio, frames, &stats, nullptr, 0) != LIVE_AUDIO_OK ||
            stats.frames != frames || stats.nonfinite_samples != 0 || stats.nonzero_samples != 0) return false;
        muted_frames += stats.frames;
        return true;
    }
    bool hover(size_t rectangle) { move_to(rectangle); return tick(); }
    bool release()
    {
        pointer(&app, BLACKMOOR_POINTER_DOWN, app.pointer_x, app.pointer_y, 0);
        pointer(&app, BLACKMOOR_POINTER_UP, app.pointer_x, app.pointer_y, 0);
        return tick(0);
    }
    bool miss_point(int32_t *x, int32_t *y) const
    {
        for (int32_t py = 0; py < 375; ++py) for (int32_t px = 0; px < 620; ++px) {
            bool hit = contains(px, py, 0x7abu);
            for (int key = 0; key < word(0x21u); ++key)
                hit = hit || contains(px, py, 0x203u + static_cast<size_t>(key) * 16u);
            if (!hit) { *x = px + 10; *y = py + 10; return true; }
        }
        return false;
    }
};

static int key_press(PianoFixture &f)
{
    CHECK(f.hover(0x203u), "real key hover tick succeeds");
    SceneSessionPointerResult result{};
    CHECK(scene_session_get_pointer_result(f.app.session, &result) == SCENE_SESSION_OK, "pointer result available");
    std::printf("PIANO_KEY hover=%d/%d candidate=%d key=%d observed_pre_ACT=%d\n", result.consume_status,
                result.scan_status, f.app.input_state.candidate, f.object()->hover, observed_hover);
    CHECK(f.app.input_state.candidate == 0x2765 && f.object()->hover == 0,
          "real S3395 key0 must publish candidate 0x2765");
    /* The original reset leaves hover0. Move to another real key so the
     * observed ACT value distinguishes pre-consume hover from post-ACT hover. */
    CHECK(f.hover(0x213u) && observed_hover == 0 && f.object()->hover == 1,
          "key1 hover must run after ACT sees the previous key0");
    CHECK(f.hover(0x203u) && f.object()->hover == 0, "return to real key0 before release");
    SessionInputHotspot generic{}; generic.index = 0; generic.active = 1; generic.rectangle = {0, 0, 619, 374};
    int32_t candidate = -1;
    CHECK(native_pointer_scan(&f.app, &generic, 1u, &candidate) == SESSION_INPUT_OK && candidate == 0x2765,
          "piano hit must precede a conflicting generic hotspot");
    CHECK(f.app.nav_cursor.variant == 1 && f.app.nav_cursor.index == 18, "key publishes original cursor cells");
    const D0Object before = *f.object();
    CHECK(f.app.start_flag_5bb1ca == 1, "phase0 store_world must enable the key sound branch");
    CHECK(f.release(), "real release succeeds");
    const D0Object *after = f.object();
    const int length = f.word(0x317u);
    bool order = after->order[length - 1] == 0;
    for (int i = 0; i < length - 1; ++i) order = order && after->order[i] == before.order[i + 1];
    CHECK(after->last == 0 && after->pressed == 1u && order,
          "accepted key release must press key0 and shift the real sequence");
    CHECK(result.consume_status == SESSION_INPUT_OK && result.scan_status == SESSION_INPUT_OK,
          "sole piano scope admits guarded input");
    CHECK(after->deadline == f.app.session_tick_sample + 500u,
          "key sound branch must set the original 500ms deadline");
    CHECK(f.tick(499u) && f.object()->pressed == 1u && f.object()->state == D0_STATE_RELEASE,
          "key must stay pressed before its deadline");
    CHECK(f.tick(1u) && f.object()->pressed == 0u && f.object()->state == D0_STATE_IDLE,
          "key releases at its real deadline with the sound sink");
    std::printf("PIANO_PRESS last=%d order_last=%d released=%d\n", after->last, after->order[length - 1], after->pressed == 0u);
    return 0;
}
static int exit_piano(PianoFixture &f)
{
    transition_target = -1; phase2_dispatches = 0;
    CHECK(f.hover(0x7abu), "real exit hover succeeds");
    std::printf("PIANO_EXIT candidate=%d hover=%d\n", f.app.input_state.candidate, f.object()->hover);
    CHECK(f.app.input_state.candidate == 0x2766 && f.object()->hover == -1,
          "real exit must publish candidate 0x2766");
    CHECK(f.app.nav_cursor.index == 9 && f.app.nav_cursor.variant == 1, "exit publishes cursor9/sub1");
    CHECK(f.release(), "real exit release succeeds");
    SceneActionRuntimeState row{};
    CHECK(scene_session_get_action_state(f.app.session, f.row, &row) == SCENE_SESSION_OK, "completed row available");
    CHECK(phase2_dispatches == 1u && row.completed == 1u && f.object()->active == 0 &&
          session_ad0_registered(f.app.ad0) == 0u && transition_target == f.word(0x792u),
          "exit release must dispatch phase2, finish the real exit block and clear ownership");
    SessionInputHotspot generic{}; generic.index = 0; generic.active = 1; generic.rectangle = {0, 0, 619, 374};
    int32_t candidate = -1;
    CHECK(native_pointer_scan(&f.app, &generic, 1u, &candidate) == SESSION_INPUT_OK && candidate == 0,
          "inactive piano falls through without a stale exit candidate");
    std::printf("PIANO_EXIT_COMPLETE target=%d completed=%u inactive=%d\n", transition_target, row.completed, f.object()->active == 0);
    return 0;
}
static int retained_release(PianoFixture &f)
{
    CHECK(f.hover(0x203u) && f.app.input_state.candidate == 0x2765, "retained release begins over real key0");
    pointer(&f.app, BLACKMOOR_POINTER_DOWN, f.app.pointer_x, f.app.pointer_y, 0);
    int32_t x = -1, y = -1;
    CHECK(f.miss_point(&x, &y), "a real miss point exists");
    pointer(&f.app, BLACKMOOR_POINTER_MOVE, x, y, 0); /* No tick: retain prior hit. */
    pointer(&f.app, BLACKMOOR_POINTER_UP, 11, 11, 0);
    CHECK(f.app.input_state.latch[0] != 0u && f.tick(0), "actual UP produces and consumes a release edge");
    SceneSessionPointerResult result{};
    CHECK(scene_session_get_pointer_result(f.app.session, &result) == SCENE_SESSION_OK, "retained result available");
    CHECK(result.candidate_at_consume == 0x2765 && result.candidate_after_scan == -1 &&
          f.object()->last == 0 && f.object()->pressed == 1u && f.app.input_state.latch[0] == 0u,
          "consume must use prior key candidate before post-ACT miss clears it");
    std::printf("PIANO_RETAINED consumed=%d scanned=%d last=%d edge=%u\n", result.candidate_at_consume,
                result.candidate_after_scan, f.object()->last, f.app.input_state.latch[0]);
    return 0;
}
static int projection(PianoFixture &f)
{
    f.app.cursor_provider.hot_x = 7; f.app.cursor_provider.hot_y = 3;
    CHECK(f.hover(0x203u) && f.app.input_state.candidate == 0x2765 && f.object()->hover == 0,
          "piano receives guarded viewport-relative hot-point projection");
    pointer(&f.app, BLACKMOOR_POINTER_DOWN, f.app.pointer_x, f.app.pointer_y, 0);
    pointer(&f.app, BLACKMOOR_POINTER_UP, f.app.pointer_x, f.app.pointer_y, 0);
    CHECK(f.app.input_state.latch[0] != 0u, "actual callback latches edge");
    int32_t candidate = -1;
    CHECK(native_pointer_scan(&f.app, nullptr, 0u, &candidate) == SESSION_INPUT_OK && candidate == 0x2765 &&
          f.app.input_state.latch[0] != 0u, "private hover projection must preserve accepted release edge");
    SceneExecutorFrameInput frame{};
    CHECK(native_pointer_consume(&f.app, &frame, &candidate) == SESSION_INPUT_OK &&
          f.object()->last == 0 && f.object()->pressed == 1u && f.app.input_state.latch[0] == 0u,
          "real consume must accept piano candidates outside generic0..239");
    std::printf("PIANO_PROJECTION hot=7,3 private_edge_preserved=1 pressed=%u\n", f.object()->pressed);
    return 0;
}
static int miss(PianoFixture &f)
{
    int32_t x = -1, y = -1;
    CHECK(f.miss_point(&x, &y), "real miss point exists");
    const D0Object before = *f.object();
    pointer(&f.app, BLACKMOOR_POINTER_MOVE, x, y, 0);
    int16_t held = 2;
    f.app.new_game.view.inventory.selected_item_candidate = &held;
    f.app.nav_cursor = {91, 7};
    SessionInputHotspot generic{}; generic.index = 0; generic.active = 1; generic.rectangle = {0, 0, 619, 374};
    int32_t candidate = -1;
    CHECK(native_pointer_scan(&f.app, &generic, 1u, &candidate) == SESSION_INPUT_OK && candidate == 0 &&
          f.object()->pressed == 0u && f.object()->last == before.last,
          "piano miss must preserve generic fallthrough without playing a key");
    CHECK(f.app.nav_cursor.index == 2 + 0x25 && f.app.nav_cursor.variant == 7,
          "miss preserves held-item cursor prelude without an unwritten piano cursor");
    f.app.new_game.view.inventory.selected_item_candidate = nullptr;
    std::printf("PIANO_MISS candidate=%d held_cursor=%d variant=%d\n", candidate, f.app.nav_cursor.index, f.app.nav_cursor.variant);
    return 0;
}
static int restricted(const char *directory, const char *kind)
{
    const bool owner = std::strcmp(kind, "owners") == 0;
    const unsigned count = owner ? 2u : (std::strcmp(kind, "guards") == 0 ? 3u : 6u);
    for (unsigned index = 0; index < count; ++index) {
        PianoFixture f;
        CHECK(f.initialize(directory, owner ? (index == 0 ? "unknown" : "duplicate") : nullptr), "restricted fixture initializes");
        const D0Object before = *f.object();
        if (!owner && std::strcmp(kind, "guards") == 0) {
            if (index == 0) f.app.cursor_provider.guard_5b5158 = 1;
            if (index == 1) f.app.cursor_provider.guard_5b61af = 1;
            if (index == 2) f.app.cursor_provider.guard_5b615e = 1;
        } else if (!owner) {
            if (index < 4) f.app.captions.lifecycle.g.overlay_ui = static_cast<int32_t>(index) + 2;
            if (index == 4) f.app.captions.lifecycle.g.modal_input = 1;
            if (index == 5) pointer(&f.app, BLACKMOOR_POINTER_MOVE, 0, 0, 0);
        }
        if (owner || std::strcmp(kind, "guards") == 0 || index != 5) f.move_to(0x203u);
        CHECK(f.tick() && f.release(), "restricted hover/release ticks succeed without fixture faults");
        SceneSessionPointerResult result{};
        CHECK(scene_session_get_pointer_result(f.app.session, &result) == SCENE_SESSION_OK, "restricted pointer result available");
        const bool limit = owner || std::strcmp(kind, "guards") == 0;
        CHECK((!limit || (result.consume_status == SESSION_INPUT_LIMIT_PRIORITY_PATH &&
                         result.scan_status == SESSION_INPUT_LIMIT_PRIORITY_PATH)) &&
              f.app.input_state.candidate == -1 && f.object()->hover == before.hover && f.object()->last == before.last &&
              f.object()->pressed == 0u, "guards, modes and unknown/duplicate owners must not play or hover piano");
        std::printf("PIANO_RESTRICTED kind=%s index=%u status=%d/%d unchanged=1\n", kind, index,
                    result.consume_status, result.scan_status);
    }
    return 0;
}
static int audio_key(PianoFixture &f)
{
    CHECK(f.word(0x736u) == 8 && f.hover(0x203u) && f.release(), "actual key0 release reaches the real sound callbacks");
    LiveAudioChannelInfo key{};
    int32_t busy = -1;
    CHECK(live_audio_get_channel_info(f.app.live_audio, 8, &key) == LIVE_AUDIO_OK, "real key channel is inspectable");
    CHECK(native_ad0_sound_busy(&f.app, 8, &busy) == 0, "real busy callback succeeds");
    std::printf("PIANO_AUDIO_KEY loaded=%u started=%u frames=%llu busy=%d state=%d\n", key.loaded, key.started,
                static_cast<unsigned long long>(key.frame_count), busy, f.object()->state);
    CHECK(key.loaded == 1u && key.started == 1u && key.frame_count > 0 && busy == 1,
          "actual key0 release must load/play Boat_A and expose authoritative busy1");
    CHECK(f.render_audio(256u), "post-master piano PCM is finite and allzero while playback advances");
    CHECK(f.tick(499u) && f.object()->pressed == 1u && f.object()->state == D0_STATE_RELEASE,
          "key remains pressed before its original 500ms deadline");
    CHECK(f.tick(1u) && f.object()->pressed == 0u && f.object()->state == D0_STATE_IDLE,
          "deadline releases the real key");
    CHECK(live_audio_get_channel_info(f.app.live_audio, 8, &key) == LIVE_AUDIO_OK && key.loaded == 0u &&
          native_ad0_sound_busy(&f.app, 8, &busy) == 0 && busy == 0,
          "500ms release must stop/unload the key clip and report idle");
    std::printf("PIANO_AUDIO_RELEASE loaded=%u busy=%d muted_frames=%llu\n", key.loaded, busy,
                static_cast<unsigned long long>(f.muted_frames));
    CHECK(f.word(0x21u) == 7, "installed piano has seven real key sounds");
    uint64_t generation = key.generation;
    for (int note = 1; note < 7; ++note) {
        CHECK(f.hover(0x203u + static_cast<size_t>(note) * 16u) && f.release(),
              "remaining real key gesture succeeds");
        CHECK(f.object()->last == note && f.object()->pressed == 1u &&
              live_audio_get_channel_info(f.app.live_audio, 8, &key) == LIVE_AUDIO_OK &&
              key.loaded == 1u && key.started == 1u && key.frame_count > 0 && key.generation > generation &&
              native_ad0_sound_busy(&f.app, 8, &busy) == 0 && busy == 1,
              "each Boat_B..Boat_G key must load a fresh real clip and report busy1");
        CHECK(f.render_audio(256u) && f.tick(500u) && f.object()->pressed == 0u &&
              live_audio_get_channel_info(f.app.live_audio, 8, &key) == LIVE_AUDIO_OK && key.loaded == 0u &&
              native_ad0_sound_busy(&f.app, 8, &busy) == 0 && busy == 0,
              "each remaining key renders silently and unloads at its real 500ms deadline");
        generation = key.generation;
    }
    std::printf("PIANO_AUDIO_NOTES count=7 fresh_generations=1 all_stopped=1 muted_frames=%llu\n",
                static_cast<unsigned long long>(f.muted_frames));
    /* The original cleanup frees only surfaces/slots. Exit from idle after
     * the real release deadline; do not invent an exit-time audio unload. */
    return exit_piano(f);
}
static int audio_natural_completion(PianoFixture &f)
{
    /* Both installed win descriptors are NO SOUND. This exercises natural
     * completion of a real key clip through D0's production callbacks; it is
     * not an invented audible-win route or a substituted puzzle body. */
    CHECK(f.hover(0x203u) && f.release(), "real key starts natural-completion component");
    int32_t busy = -1;
    LiveAudioChannelInfo key{};
    CHECK(native_ad0_sound_busy(&f.app, 8, &busy) == 0 && busy == 1,
          "natural-completion observation begins while real Boat_A is busy");
    for (unsigned i = 0; busy != 0 && i < 800u; ++i) {
        CHECK(f.render_audio(4096u), "muted key audio advances with finite allzero PCM");
        CHECK(native_ad0_sound_busy(&f.app, 8, &busy) == 0, "production callback polls authoritative key completion");
    }
    CHECK(busy == 0 && live_audio_get_channel_info(f.app.live_audio, 8, &key) == LIVE_AUDIO_OK &&
          key.loaded == 1u && key.started == 1u && key.finished == 1u && key.frame_count > 0,
          "real clip must finish naturally while remaining loaded until the kernel stop boundary");
    const uint64_t decoded_frames = key.frame_count;
    CHECK(f.tick(0) && f.object()->pressed == 1u && f.object()->state == D0_STATE_RELEASE,
          "natural audio completion alone does not bypass the original key deadline");
    CHECK(f.tick(500u) && f.object()->pressed == 0u &&
          live_audio_get_channel_info(f.app.live_audio, 8, &key) == LIVE_AUDIO_OK && key.loaded == 0u,
          "original key release subsequently unloads the naturally completed clip");
    std::printf("PIANO_AUDIO_NATURAL finished=1 deadline_retained=1 frames=%llu muted_frames=%llu\n",
                static_cast<unsigned long long>(decoded_frames), static_cast<unsigned long long>(f.muted_frames));
    return 0;
}
static int audio_solve(PianoFixture &f)
{
    transition_target = -1; phase2_dispatches = 0;
    const SceneActionInfo action = f.action();
    const int length = f.word(0x317u);
    CHECK(length == 8 && f.word(0x746u) == 3396 && f.word(0x75cu) == 2013 &&
          action.typed_body[0x75eu] == 1u && f.word(0x75fu) == 1 && f.flags[2013] == 0,
          "real solved block begins with target3396, flag2013/value1 and one-second delay");
    CHECK(std::strcmp(reinterpret_cast<const char *>(action.typed_body + 0x761u), "NO SOUND") == 0 &&
          f.word(0x782u) == 9, "installed S3395 genuinely has a silent win descriptor on channel9");
    for (int step = 0; step < length; ++step) {
        const int key = f.word(0x319u + static_cast<size_t>(step) * 2u);
        CHECK(key >= 0 && key < f.word(0x21u), "real solution key is in range");
        CHECK(f.hover(0x203u + static_cast<size_t>(key) * 16u) && f.release(), "real solution gesture succeeds");
        LiveAudioChannelInfo sound{};
        int32_t busy = -1;
        CHECK(f.object()->last == key && f.object()->pressed == 1u &&
              live_audio_get_channel_info(f.app.live_audio, 8, &sound) == LIVE_AUDIO_OK && sound.loaded == 1u &&
              sound.started == 1u && sound.frame_count > 0 && native_ad0_sound_busy(&f.app, 8, &busy) == 0 && busy == 1,
              "every solution gesture must play its real named clip through the production callbacks");
        CHECK(f.render_audio(256u) && f.tick(500u), "real solution key completes its original release deadline");
        CHECK(f.object()->pressed == 0u && live_audio_get_channel_info(f.app.live_audio, 8, &sound) == LIVE_AUDIO_OK &&
              sound.loaded == 0u && f.flags[2013] == 0 && phase2_dispatches == 0u,
              "each real key stop unloads sound without prematurely applying the solved block");
    }
    CHECK(f.object()->solved == 1u && f.object()->state == D0_STATE_START_WIN,
          "real last-L-key comparison in the render callback starts win flow");
    CHECK(f.tick(0) && f.object()->state == D0_STATE_WAIT_WIN,
          "solved handler starts its real one-second wait");
    CHECK(f.tick(999u) && f.object()->state == D0_STATE_WAIT_WIN && f.flags[2013] == 0 && transition_target == -1,
          "delay gate must keep phase1 and the flag/transition unchanged before expiry");
    SceneActionRuntimeState row{};
    CHECK(scene_session_get_action_state(f.app.session, f.row, &row) == SCENE_SESSION_OK && row.phase == 1u,
          "real solved row remains phase1 during the delay");
    CHECK(f.tick(1u) && scene_session_get_action_state(f.app.session, f.row, &row) == SCENE_SESSION_OK &&
          row.phase == 2u && row.completed == 0u && f.flags[2013] == 0,
          "NO SOUND branch advances to phase2 only when the original delay expires");
    LiveAudioChannelInfo win{};
    CHECK(live_audio_get_channel_info(f.app.live_audio, 9, &win) == LIVE_AUDIO_OK && win.loaded == 0u,
          "silent installed win branch must not fabricate a loaded win clip");
    CHECK(f.tick(0) && scene_session_get_action_state(f.app.session, f.row, &row) == SCENE_SESSION_OK &&
          row.completed == 1u && phase2_dispatches == 1u && transition_target == 3396 && f.flags[2013] == 1 &&
          f.object()->active == 0 && session_ad0_registered(f.app.ad0) == 0u,
          "phase2 must apply the actual solved transition/flag once and clean the piano surface/slot");
    std::printf("PIANO_AUDIO_SOLVE keys=%d silent_win=1 delay_ms=1000 target=%d flag2013=%d completed=%u muted_frames=%llu\n",
                length, transition_target, f.flags[2013], row.completed, static_cast<unsigned long long>(f.muted_frames));
    return 0;
}
static int audio_shared(PianoFixture &f)
{
    CHECK(f.hover(0x203u) && f.release(), "shared-channel case starts with a real piano press");
    const uint8_t *body = f.action().typed_body;
    std::vector<uint8_t> descriptor(body + 0x715u, body + 0x715u + PUZZLE_SOUND_RECORD_BYTES);
    std::memset(descriptor.data(), 0, 33u);
    const char absent[] = "NATIVE10_MISSING_RESOURCE";
    std::memcpy(descriptor.data(), absent, sizeof(absent));
    CHECK(native_ad0_sound_prepare(&f.app, descriptor.data()) == 0, "missing descriptor is an honest no-resource result");
    LiveAudioChannelInfo channel{};
    int32_t busy = -1;
    CHECK(live_audio_get_channel_info(f.app.live_audio, 8, &channel) == LIVE_AUDIO_OK && channel.loaded == 0u &&
          native_ad0_sound_play(&f.app, 8) == 0 && native_ad0_sound_busy(&f.app, 8, &busy) == 0 && busy == 0,
          "missing resource must revoke stale cached playback eligibility and remain idle");
    /* External provider changes model another channel owner, not puzzle
     * state. The app must refresh eligibility before play and before busy. */
    ActionSoundAudioCommand command{};
    std::memcpy(command.asset_stem, body + 0x337u + 0x42u, 33u); /* real Boat_B */
    command.channel = 8; command.volume_category = 2; command.mode = 1; command.control_word = 1;
    command.first_percent = 100; command.second_percent = 100;
    command.first_gain = 1; command.second_gain = 1; command.transition_scene = 9999;
    CHECK(live_audio_load_sound(f.app.live_audio, &command) == ACTION_SOUND_BACKEND_OK &&
          native_ad0_sound_play(&f.app, 8) == 0 && native_ad0_sound_busy(&f.app, 8, &busy) == 0 && busy == 1,
          "authoritative external load must become playable despite the D0 cache's prior miss");
    CHECK(f.render_audio(256u), "shared-channel rendering stays finite and muted");
    CHECK(live_audio_unload_sound(f.app.live_audio, 8) == ACTION_SOUND_BACKEND_OK &&
          native_ad0_sound_play(&f.app, 8) == 0 && native_ad0_sound_busy(&f.app, 8, &busy) == 0 && busy == 0,
          "authoritative external unload must revoke the stale D0 prepared state");
    std::printf("PIANO_AUDIO_SHARED missing_idle=1 external_load_busy=1 external_unload_idle=1 muted_frames=%llu\n",
                static_cast<unsigned long long>(f.muted_frames));
    return 0;
}
static int metadata(PianoFixture &f)
{
    std::printf("PIANO_METADATA row=%zu count=%d key0=%d,%d,%d,%d exit=%d,%d,%d,%d key_window=%d,%d exit_window=%d,%d target=%d kinds=%d,%d\n",
                f.row, f.word(0x21u), f.value(0x203u), f.value(0x207u), f.value(0x20bu), f.value(0x20fu),
                f.value(0x7abu), f.value(0x7afu), f.value(0x7b3u), f.value(0x7b7u),
                (f.value(0x203u) + f.value(0x20bu)) / 2 + 10, (f.value(0x207u) + f.value(0x20fu)) / 2 + 10,
                (f.value(0x7abu) + f.value(0x7b3u)) / 2 + 10, (f.value(0x7afu) + f.value(0x7b7u)) / 2 + 10,
                f.word(0x792u), f.word(0x2f3u), f.word(0x305u));
    std::printf("PIANO_SOLUTION length=%d keys=", f.word(0x317u));
    for (int i = 0; i < f.word(0x317u); ++i) std::printf("%s%d", i == 0 ? "" : ",", f.word(0x319u + static_cast<size_t>(i) * 2u));
    std::printf("\n");
    for (int key = 0; key < f.word(0x21u); ++key) {
        const size_t rect = 0x203u + static_cast<size_t>(key) * 16u;
        std::printf("PIANO_KEY_METADATA key=%d window=%d,%d sound=%.*s\n", key,
                    (f.value(rect) + f.value(rect + 8u)) / 2 + 10,
                    (f.value(rect + 4u) + f.value(rect + 12u)) / 2 + 10,
                    33, reinterpret_cast<const char *>(f.action().typed_body + 0x337u + static_cast<size_t>(key) * 0x42u));
    }
    for (size_t offset : {0x715u, 0x761u})
        std::printf("PIANO_DESCRIPTOR kind=%s name=%.*s channel=%d flags=%d loop=%d unused=%d control=%d gain=%d,%d\n",
                    offset == 0x715u ? "key" : "win", 33, reinterpret_cast<const char *>(f.action().typed_body + offset),
                    f.word(offset + 0x21u), f.word(offset + 0x23u), f.word(offset + 0x25u), f.word(offset + 0x27u),
                    f.value(offset + 0x29u), f.word(offset + 0x2du), f.word(offset + 0x2fu));
    for (size_t offset : {0x746u, 0x792u})
        std::printf("PIANO_BLOCK kind=%s target=%d words=%d,%d,%d dwords=%d,%d,%d start=%d flag=%d value=%u\n",
                    offset == 0x746u ? "solved" : "exit", f.word(offset), f.word(offset + 2u), f.word(offset + 4u), f.word(offset + 6u),
                    f.value(offset + 8u), f.value(offset + 12u), f.value(offset + 16u), f.word(offset + 20u), f.word(offset + 22u),
                    f.action().typed_body[offset + 24u]);
    std::printf("PIANO_DELAY seconds=%d\n", f.word(0x75fu));
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
        if (argc != 4 || std::strcmp(argv[1], "--piano-component") != 0)
            return blackmoor_app_entry_for_piano_test(argc, argv);
        const char *kind = argv[3];
        if (std::strcmp(kind, "guards") == 0 || std::strcmp(kind, "owners") == 0 || std::strcmp(kind, "ui") == 0)
            return restricted(argv[2], kind);
        PianoFixture f;
        if (std::strcmp(kind, "metadata") == 0 || std::strcmp(kind, "metadata3394") == 0) {
            CHECK(f.load(argv[2], std::strcmp(kind, "metadata3394") == 0 ? 3394 : 3395), "metadata scene loads"); return metadata(f);
        }
        CHECK(f.initialize(argv[2], nullptr, std::strncmp(kind, "audio-", 6) == 0), "real S3395 fixture initializes");
        if (std::strcmp(kind, "audio-key") == 0) return audio_key(f);
        if (std::strcmp(kind, "audio-natural") == 0) return audio_natural_completion(f);
        if (std::strcmp(kind, "audio-solve") == 0) return audio_solve(f);
        if (std::strcmp(kind, "audio-shared") == 0) return audio_shared(f);
        if (std::strcmp(kind, "key") == 0) return key_press(f);
        if (std::strcmp(kind, "exit") == 0) return exit_piano(f);
        if (std::strcmp(kind, "retained") == 0) return retained_release(f);
        if (std::strcmp(kind, "projection") == 0) return projection(f);
        if (std::strcmp(kind, "miss") == 0) return miss(f);
        if (std::strcmp(kind, "metadata") == 0) return metadata(f);
        return 2;
    }
}
