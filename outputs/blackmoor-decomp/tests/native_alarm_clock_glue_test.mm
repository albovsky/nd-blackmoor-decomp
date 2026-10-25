/* NATIVE-06/07: real S2175 binding and actual app input callbacks. Rendering
 * and finish effects are sinks; ordinary components also sink sound. The
 * explicitly named audio components use production callbacks, a muted real
 * offline graph and owner-local descriptors. No output device is opened.
 * Normal mode runs the actual offline app. No resource payload is committed. */
#define main blackmoor_app_entry_for_clock_test
#ifndef NATIVE_ALARM_APP_SOURCE
#define NATIVE_ALARM_APP_SOURCE "../src/blackmoor_app.mm"
#endif
#include NATIVE_ALARM_APP_SOURCE
#undef main
#include <csignal>

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
static int transition_target = -1;
static int sink_transition(void *, const AlcTransition *t) { transition_target = t->scene; return 0; }
static SceneSessionCallbackStatus prepare_clock(void *, SceneConditionState *, SceneExecutorFrameInput *,
                                                SceneSessionFailure *) { return SCENE_SESSION_CALLBACK_OK; }
static SceneSessionCallbackStatus advance_clock_media(void *, SceneExecutorFrameInput *, SceneSessionFailure *)
{ return SCENE_SESSION_CALLBACK_OK; }
static int other_clock_action(void *, size_t, const SceneActionInfo *, const SceneActionRuntimeState *before,
                              SceneActionHandlerResult *out)
{
    out->phase = before->phase;
    out->disposition = SCENE_ACTION_HANDLER_PENDING;
    return SCENE_ACTION_HANDLER_OK;
}
static int clock_sound_condition(void *, const SceneConditionLeafRequest *request, int32_t *status, int *)
{
    if (request->record.opcode != 17) return SCENE_CONDITION_ERR_UNSUPPORTED_OPCODE;
    *status = 0; /* Ambient sound is not executed by the component fixture. */
    return SCENE_CONDITION_OK;
}

#define CHECK_CLOCK(condition, message) do { if (!(condition)) { \
    std::fprintf(stderr, "CHECK failed: %s\n", message); return 1; } } while (0)

struct ClockFixture {
    NativeApp app;
    SceneResource *session_scene = nullptr;
    std::vector<uint8_t> bytes;
    std::vector<int32_t> flags = std::vector<int32_t>(4096);
    std::vector<SceneSessionActionBinding> bindings;
    ActionCoreWorld world{};
    SceneConditionState conditions{};
    SceneConditionExtension extension{};
    size_t row = SIZE_MAX;
    ~ClockFixture()
    {
        scene_session_destroy(app.session);
        session_aaa_destroy(app.aaa);
        if (app.live_audio != nullptr) live_audio_destroy(app.live_audio);
        if (app.scene != session_scene) scene_resource_close(app.scene);
        scene_resource_close(session_scene);
        game_resources_close(app.resources);
        if (app.log != nullptr) std::fclose(app.log);
    }

    bool load(const char *game_directory)
    {
        app.game_directory = game_directory;
        app.log = std::tmpfile();
        if (app.log == nullptr) return false;
        int external = 0;
        if (!game_ini_configuration(app.game_directory, &external, &app.closed_captioning)) return false;
        char error[256]{};
        app.resources = game_resources_open((app.game_directory + "/Ciftree").c_str(), external, error, sizeof(error));
        if (app.resources == nullptr) return false;
        GameResourceBytes resource = GAME_RESOURCE_BYTES_INIT;
        if (!game_resources_load_bytes(app.resources, "S2175", &resource, error, sizeof(error))) return false;
        bytes.assign(resource.bytes, resource.bytes + resource.length);
        game_resource_bytes_destroy(&resource);
        session_scene = scene_resource_open_memory(bytes.data(), bytes.size(), error, sizeof(error));
        if (session_scene == nullptr) return false;
        app.scene = session_scene;
        for (size_t i = 0; i < scene_resource_action_count(session_scene); ++i) {
            SceneActionInfo action{};
            if (scene_resource_action_at(session_scene, i, &action) != SCENE_RESOURCE_OK) return false;
            if (action.type == SESSION_AAA_TYPE) {
                if (row != SIZE_MAX || action.typed_body_length != ALC_BODY_BYTES) return false;
                row = i;
            }
        }
        return row != SIZE_MAX;
    }

    bool derive_priority()
    {
        std::vector<uint8_t> types;
        for (size_t i = 0; i < scene_resource_action_count(app.scene); ++i) {
            SceneActionInfo action{};
            if (scene_resource_action_at(app.scene, i, &action) != SCENE_RESOURCE_OK) return false;
            types.push_back(action.type);
        }
        app.nav_members_idle = session_navigation_members_idle(types.data(), types.size()) != 0;
        return true;
    }

    bool initialize(const char *game_directory, bool unknown = false, bool real_audio = false)
    {
        if (!load(game_directory)) return false;
        if (unknown) {
            /* Ownership metadata only: CF executes nowhere in this fixture.
             * The executor keeps the real scene; callbacks see an opaque owner. */
            const size_t offset = bytes.size();
            if (offset < 12 || std::memcmp(bytes.data(), "DATA", 4) != 0) return false;
            bytes.resize(offset + 58u, 0);
            std::memcpy(bytes.data() + offset, "ACT", 3);
            bytes[offset + 7u] = 50;
            const char name[] = "NATIVE-06 opaque earlier owner";
            std::memcpy(bytes.data() + offset + 8u, name, sizeof(name));
            bytes[offset + 56u] = 0xcf;
            bytes[offset + 57u] = 1;
            const uint32_t length = static_cast<uint32_t>(bytes.size() - 8u);
            for (unsigned i = 0; i < 4; ++i) bytes[4u + i] = static_cast<uint8_t>(length >> (24u - 8u * i));
            char error[256]{};
            app.scene = scene_resource_open_memory(bytes.data(), bytes.size(), error, sizeof(error));
            if (app.scene == nullptr) return false;
        }
        app.current_scene_id = 2175;
        app.scene_destination = {10, 10, 629, 384};
        app.bar_missing = true;
        app.session_tick_sample = 1000;
        app.new_game.view.clock.configured_hour = 8;
        app.new_game.view.clock.configured_minute = 30;
        app.new_game.action_core.event_flags = flags.data();
        app.new_game.action_core.event_flag_count = flags.size();
        if (real_audio) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"BlackmoorAudioMuted"];
            LiveAudioConfig audio{};
            audio.game_directory = game_directory;
            audio.mode = MAC_AUDIO_MODE_OFFLINE;
            char error[256]{};
            if (live_audio_create(&audio, &app.live_audio, error, sizeof(error)) != LIVE_AUDIO_OK) {
                std::fprintf(stderr, "clock offline audio: %s\n", error);
                return false;
            }
        }
        SessionAaaHost host{};
        host.kernel.context = &app;
        host.kernel.alloc_slot = sink_slot; host.kernel.register_slot = sink_register;
        host.kernel.load_surface = sink_load; host.kernel.set_slot_surface = sink_surface;
        host.kernel.release_surface = sink_release; host.kernel.release_slot = sink_slot_op;
        host.kernel.mark_dirty = sink_slot_op; host.kernel.view_origin = native_ad1_view_origin;
        host.kernel.sound_prepare = real_audio ? native_aaa_sound_prepare : sink_record;
        host.kernel.sound_stop = real_audio ? native_aaa_sound_stop : sink_record;
        host.kernel.sound_play = real_audio ? native_aaa_sound_play : sink_channel;
        host.kernel.sound_busy = real_audio ? native_aaa_sound_busy : sink_busy;
        host.kernel.tick = native_ad1_tick; host.kernel.touch_idle_timer = sink_idle;
        host.kernel.event_flag_invalid = native_ad1_event_flag_invalid;
        host.kernel.transition = sink_transition; host.kernel.store_event_flag = native_ad1_store_event_flag;
        host.load_world = native_aaa_load_world; host.store_world = native_aaa_store_world;
        app.aaa = session_aaa_create(&host);
        if (app.aaa == nullptr || session_aaa_begin_scene(app.aaa, session_scene) != ALC_OK || !derive_priority()) return false;
        std::vector<uint8_t> bound;
        for (size_t i = 0; i < scene_resource_action_count(session_scene); ++i) {
            SceneActionInfo action{};
            if (scene_resource_action_at(session_scene, i, &action) != SCENE_RESOURCE_OK) return false;
            if (action.type == 0x61 || std::find(bound.begin(), bound.end(), action.type) != bound.end()) continue;
            bound.push_back(action.type);
            SceneSessionActionBinding binding{};
            binding.type = action.type; binding.provider = SCENE_SESSION_PROVIDER_HOST;
            binding.callback = action.type == SESSION_AAA_TYPE ? native_aaa_handler : other_clock_action;
            binding.context = &app;
            bindings.push_back(binding);
        }
        world.event_flags = flags.data(); world.event_flag_count = flags.size();
        conditions.event_flags = flags.data(); conditions.event_flag_count = flags.size();
        SceneSessionConfig config{};
        config.scene = session_scene; config.scene_id = 2175;
        config.action_core_world = &world; config.conditions = &conditions;
        config.action_bindings = bindings.data(); config.action_binding_count = bindings.size();
        config.prepare_tick = prepare_clock; config.advance_media_one = advance_clock_media;
        config.provider_context = &app;
        SceneSessionFailure failure{};
        if (scene_session_create(&config, &app.session, &failure) != SCENE_SESSION_OK) return false;
        extension.evaluate_leaf = clock_sound_condition;
        if (scene_session_set_condition_extension(app.session, &extension) != SCENE_SESSION_OK) return false;
        SceneSessionPointerHost pointer_host{};
        pointer_host.context = &app; pointer_host.consume = native_pointer_consume;
        pointer_host.scan = native_pointer_scan; pointer_host.reset = native_pointer_reset;
        if (scene_session_bind_pointer(app.session, &pointer_host) != SCENE_SESSION_OK || !tick()) return false;
        SceneActionRuntimeState state{};
        return scene_session_get_action_state(app.session, row, &state) == SCENE_SESSION_OK &&
               state.phase == 1u && object()->active != 0 && object()->state == ALC_STATE_TIME;
    }

    const AlcObject *object() const { return session_aaa_object(app.aaa); }
    int32_t value(size_t offset) const
    {
        SceneActionInfo action{};
        if (scene_resource_action_at(session_scene, row, &action) != SCENE_RESOURCE_OK) return INT32_MIN;
        const uint8_t *p = action.typed_body + offset;
        return static_cast<int32_t>(static_cast<uint32_t>(p[0]) | (static_cast<uint32_t>(p[1]) << 8) |
                                    (static_cast<uint32_t>(p[2]) << 16) | (static_cast<uint32_t>(p[3]) << 24));
    }
    void move_to(size_t rectangle)
    {
        const int32_t x = (value(rectangle) + value(rectangle + 8)) / 2 + 10 - app.cursor_provider.hot_x;
        const int32_t y = (value(rectangle + 4) + value(rectangle + 12)) / 2 + 10 - app.cursor_provider.hot_y;
        pointer(&app, BLACKMOOR_POINTER_MOVE, x, y, 0);
    }
    bool tick(uint32_t delta = 85)
    {
        app.session_tick_sample += delta;
        SceneSessionTickResult result{};
        const int status = scene_session_tick(app.session, &result);
        if (status != SCENE_SESSION_OK) std::fprintf(stderr, "clock fixture tick=%d provider=%d row=%zu detail=%d\n",
            status, result.failure.provider, result.failure.action_index, result.failure.detail_status);
        return status == SCENE_SESSION_OK;
    }
    bool hover(size_t rectangle)
    {
        move_to(rectangle);
        return tick();
    }
    bool release()
    {
        pointer(&app, BLACKMOOR_POINTER_DOWN, app.pointer_x, app.pointer_y, 0);
        pointer(&app, BLACKMOOR_POINTER_UP, app.pointer_x, app.pointer_y, 0);
        return tick(0);
    }
    bool settle(int state)
    {
        for (unsigned i = 0; i < 30; ++i) {
            if (object()->state == state) return true;
            if (!tick()) return false;
        }
        return false;
    }
};

static int controls(ClockFixture &f)
{
    CHECK_CLOCK(f.hover(0x61), "Alarm hover tick must succeed");
    SceneSessionPointerResult pointer_result{};
    CHECK_CLOCK(scene_session_get_pointer_result(f.app.session, &pointer_result) == SCENE_SESSION_OK, "pointer result available");
    std::printf("CLOCK_HOVER consume=%d scan=%d candidate=%d button=%d state=%d\n", pointer_result.consume_status,
        pointer_result.scan_status, f.app.input_state.candidate, f.object()->button, f.object()->state);
    CHECK_CLOCK(f.app.input_state.candidate == ALC_CANDIDATE_BUTTON && f.object()->button == 1,
                "real Alarm hover must publish 0x276e before overlay/navigation/generic");
    /* A generic rectangle under the same button must not replace the clock. */
    SessionInputHotspot generic{}; generic.index = 0; generic.active = 1; generic.rectangle = {0, 0, 619, 374};
    int32_t candidate = -1;
    CHECK_CLOCK(native_pointer_scan(&f.app, &generic, 1u, &candidate) == SESSION_INPUT_OK &&
                candidate == ALC_CANDIDATE_BUTTON, "clock hit must precede generic fallback");
    SceneActionInfo action{};
    CHECK_CLOCK(scene_resource_action_at(f.session_scene, f.row, &action) == SCENE_RESOURCE_OK, "clock row available");
    const int cursor = static_cast<int16_t>(action.typed_body[0x263] | (action.typed_body[0x264] << 8));
    CHECK_CLOCK(f.app.nav_cursor.index == cursor && f.app.nav_cursor.variant == 1, "clock hit publishes original cursor cells");
    CHECK_CLOCK(f.release() && f.object()->state == ALC_STATE_PRESSED, "Alarm release enters timed PRESSED state");
    const uint32_t deadline = f.object()->press_deadline;
    CHECK_CLOCK(f.app.session_tick_sample < deadline && f.tick(0) && f.object()->state == ALC_STATE_PRESSED,
                "button delay must retain PRESSED before deadline");
    CHECK_CLOCK(f.settle(ALC_STATE_ALARM), "Alarm press completes into alarm mode");
    const int16_t hour = f.object()->alarm_hour;
    const int32_t am = f.object()->alarm_am;
    CHECK_CLOCK(f.hover(0x91) && f.object()->button == 3 && f.release() && f.settle(ALC_STATE_ALARM), "Increase gesture completes");
    CHECK_CLOCK(f.object()->alarm_hour == (hour + 1) % 12, "Increase changes the alarm hour");
    CHECK_CLOCK(f.hover(0xa1) && f.object()->button == 4 && f.release() && f.settle(ALC_STATE_ALARM), "Decrease gesture completes");
    CHECK_CLOCK(f.object()->alarm_hour == hour && f.object()->alarm_am == am, "Decrease restores the hour and AM/PM");
    CHECK_CLOCK(f.hover(0x51) && f.object()->button == 0 && f.release() && f.settle(ALC_STATE_TIME), "Time mode gesture completes");
    std::printf("CLOCK_CONTROLS alarm_hour=%d restored_hour=%d press_deadline=%u mode=%d\n", hour, f.object()->alarm_hour,
                deadline, f.object()->state);
    return 0;
}

static int retained_release(ClockFixture &f)
{
    CHECK_CLOCK(f.hover(0x61) && f.app.input_state.candidate == ALC_CANDIDATE_BUTTON, "accepted edge starts at real Alarm button");
    pointer(&f.app, BLACKMOOR_POINTER_DOWN, f.app.pointer_x, f.app.pointer_y, 0);
    pointer(&f.app, BLACKMOOR_POINTER_UP, f.app.pointer_x, f.app.pointer_y, 0);
    CHECK_CLOCK(f.app.input_state.latch[0] != 0, "real UP must produce the accepted edge");
    /* Callback interleaving contract, not a normal app-loop ordering claim:
     * a real post-ACT scan clears the candidate while retaining over/button.
     * Its copy projection must leave the already accepted edge untouched. */
    f.move_to(0x21);
    int32_t candidate = -2;
    CHECK_CLOCK(native_pointer_scan(&f.app, nullptr, 0, &candidate) == SESSION_INPUT_OK && candidate == -1 &&
                f.object()->over != 0 && f.object()->button == 1 && f.app.input_state.latch[0] != 0,
                "digit miss must retain clock button and accepted edge without candidate");
    SceneExecutorFrameInput frame{};
    const int status = native_pointer_consume(&f.app, &frame, &candidate);
    std::printf("CLOCK_RETAINED status=%d candidate=%d state=%d edge=%u\n", status, candidate, f.object()->state,
                f.app.input_state.latch[0]);
    CHECK_CLOCK(status == SESSION_INPUT_OK && f.object()->state == ALC_STATE_PRESSED && f.app.input_state.latch[0] == 0,
                "accepted release must call clock without an extra candidate gate");
    return 0;
}

static int cancel_clock(ClockFixture &f)
{
    transition_target = -1;
    CHECK_CLOCK(f.hover(0x81) && f.app.input_state.candidate == ALC_CANDIDATE_BUTTON && f.object()->button == 8,
                "real Cancel rectangle must hover");
    CHECK_CLOCK(f.release(), "Cancel release tick succeeds");
    for (unsigned i = 0; i < 35 && f.object()->active != 0; ++i) CHECK_CLOCK(f.tick(), "Cancel timed progression succeeds");
    SceneActionRuntimeState state{};
    CHECK_CLOCK(scene_session_get_action_state(f.app.session, f.row, &state) == SCENE_SESSION_OK, "completed clock row available");
    std::printf("CLOCK_CANCEL target=%d completed=%u active=%d registered=%u\n", transition_target, state.completed,
                f.object()->active, session_aaa_registered(f.app.aaa));
    CHECK_CLOCK(transition_target == 2020 && state.completed == 1u && f.object()->active == 0 &&
                session_aaa_registered(f.app.aaa) == 0u, "Cancel must finish through the real body block and clear clock ownership");
    /* Completed/inactive clock must permit generic fallback without stale hit. */
    SessionInputHotspot generic{}; generic.index = 0; generic.active = 1; generic.rectangle = {0, 0, 619, 374};
    int32_t candidate = -1;
    CHECK_CLOCK(native_pointer_scan(&f.app, &generic, 1u, &candidate) == SESSION_INPUT_OK && candidate == 0,
                "inactive clock must not retain a stale button candidate");
    return 0;
}

static int clock_audio(ClockFixture &f)
{
    LiveAudioChannelInfo button{};
    CHECK_CLOCK(live_audio_get_channel_info(f.app.live_audio, 9, &button) == LIVE_AUDIO_OK, "real clock channel query succeeds");
    std::printf("CLOCK_AUDIO_PREPARE loaded=%u started=%u frames=%llu rate=%u\n", button.loaded, button.started,
                static_cast<unsigned long long>(button.frame_count), button.sample_rate);
    CHECK_CLOCK(button.loaded == 1u && button.started == 0u && button.frame_count > 0,
                "phase0 must prepare real Beep12 without playing it");
    CHECK_CLOCK(f.hover(0x61) && f.release(), "real Alarm release starts button sound");
    int32_t busy = -1;
    CHECK_CLOCK(native_aaa_sound_busy(&f.app, 9, &busy) == 0 && busy == 1, "real Beep12 must report busy after the release");
    uint64_t muted_frames = 0;
    for (unsigned i = 0; busy != 0 && i < 800u; ++i) {
        LiveAudioOfflineStats stats{};
        CHECK_CLOCK(live_audio_advance_offline(f.app.live_audio, 4096, &stats, nullptr, 0) == LIVE_AUDIO_OK &&
                    stats.nonfinite_samples == 0 && stats.nonzero_samples == 0, "muted offline button rendering succeeds");
        muted_frames += stats.frames;
        CHECK_CLOCK(native_aaa_sound_busy(&f.app, 9, &busy) == 0, "button completion query succeeds");
    }
    CHECK_CLOCK(busy == 0, "Beep12 must complete naturally without a forced stop");
    CHECK_CLOCK(live_audio_get_channel_info(f.app.live_audio, 9, &button) == LIVE_AUDIO_OK && button.finished == 1u,
                "button host must record natural completion");
    CHECK_CLOCK(f.settle(ALC_STATE_ALARM) && f.hover(0x71) && f.release() && f.settle(ALC_STATE_WAIT_SET),
                "actual Set gesture enters the original one-second wait");
    CHECK_CLOCK(f.app.new_game.view.clock.configured_hour == 8 && f.app.new_game.view.clock.configured_minute == 30,
                "clock words must not change before final sound completion");
    CHECK_CLOCK(f.settle(ALC_STATE_FINAL_SOUND), "wait expiry must prepare/play real SILENCE descriptor");
    LiveAudioChannelInfo final{};
    CHECK_CLOCK(live_audio_get_channel_info(f.app.live_audio, 9, &final) == LIVE_AUDIO_OK && final.loaded == 1u &&
                final.started == 1u && final.frame_count > 0 && final.generation > button.generation,
                "final descriptor replaces the button sound on real channel9");
    CHECK_CLOCK(native_aaa_sound_busy(&f.app, 9, &busy) == 0 && busy == 1 && f.tick(0) &&
                f.object()->state == ALC_STATE_FINAL_SOUND, "FINAL_SOUND must wait while the real channel is busy");
    SceneActionRuntimeState row{};
    CHECK_CLOCK(scene_session_get_action_state(f.app.session, f.row, &row) == SCENE_SESSION_OK && row.phase == 1u,
                "playing final sound retains phase1");
    unsigned held_ticks = 0;
    for (unsigned i = 0; busy != 0 && i < 800u; ++i) {
        LiveAudioOfflineStats stats{};
        CHECK_CLOCK(live_audio_advance_offline(f.app.live_audio, 4096, &stats, nullptr, 0) == LIVE_AUDIO_OK &&
                    stats.nonfinite_samples == 0 && stats.nonzero_samples == 0, "muted final rendering succeeds");
        muted_frames += stats.frames;
        CHECK_CLOCK(native_aaa_sound_busy(&f.app, 9, &busy) == 0, "final completion query succeeds");
        if (busy != 0) {
            CHECK_CLOCK(f.tick(0) && f.object()->state == ALC_STATE_FINAL_SOUND &&
                        f.app.new_game.view.clock.configured_minute == 30, "busy final channel must continue to gate ACT");
            ++held_ticks;
        }
    }
    CHECK_CLOCK(busy == 0, "SILENCE must complete naturally after the observed busy phase");
    transition_target = -1;
    for (unsigned i = 0; f.object()->active != 0 && i < 5u; ++i) CHECK_CLOCK(f.tick(0), "idle final sound allows phase finish");
    LiveAudioChannelInfo stopped{};
    CHECK_CLOCK(live_audio_get_channel_info(f.app.live_audio, 9, &stopped) == LIVE_AUDIO_OK && stopped.loaded == 0u,
                "phase finish must unload the shared channel");
    CHECK_CLOCK(scene_session_get_action_state(f.app.session, f.row, &row) == SCENE_SESSION_OK && row.completed == 1u &&
                f.object()->active == 0 && transition_target == 2176 &&
                f.app.new_game.view.clock.configured_hour == 9 && f.app.new_game.view.clock.configured_minute == 0,
                "natural final completion must set 09:00 and request the real set target2176");
    std::printf("CLOCK_AUDIO_FINISH held_ticks=%u muted_frames=%llu final_frames=%llu target=%d clock=%d:%02d\n",
                held_ticks, static_cast<unsigned long long>(muted_frames), static_cast<unsigned long long>(final.frame_count),
                transition_target, f.app.new_game.view.clock.configured_hour, f.app.new_game.view.clock.configured_minute);
    return 0;
}

static int clock_audio_cancel(ClockFixture &f)
{
    LiveAudioChannelInfo prepared{};
    CHECK_CLOCK(live_audio_get_channel_info(f.app.live_audio, 9, &prepared) == LIVE_AUDIO_OK && prepared.loaded == 1u,
                "Cancel cleanup begins with a real prepared Beep12 channel");
    const int status = cancel_clock(f);
    if (status != 0) return status;
    LiveAudioChannelInfo channel{};
    CHECK_CLOCK(live_audio_get_channel_info(f.app.live_audio, 9, &channel) == LIVE_AUDIO_OK && channel.loaded == 0u,
                "Cancel must unload its prepared/playing Beep12 channel");
    return 0;
}

static int clock_audio_shared(ClockFixture &f)
{
    SceneActionInfo row{};
    CHECK_CLOCK(scene_resource_action_at(f.session_scene, f.row, &row) == SCENE_RESOURCE_OK, "real descriptor row available");
    std::vector<uint8_t> missing(row.typed_body + ALC_OFFSET_BUTTON_SOUND,
                                 row.typed_body + ALC_OFFSET_BUTTON_SOUND + PUZZLE_SOUND_RECORD_BYTES);
    std::memset(missing.data(), 0, 33);
    const char absent[] = "NATIVE07_MISSING_RESOURCE";
    std::memcpy(missing.data(), absent, sizeof(absent));
    CHECK_CLOCK(native_aaa_sound_prepare(&f.app, missing.data()) == 0, "missing finite descriptor is a supported no-resource boundary");
    LiveAudioChannelInfo channel{};
    int32_t busy = -1;
    CHECK_CLOCK(live_audio_get_channel_info(f.app.live_audio, 9, &channel) == LIVE_AUDIO_OK && channel.loaded == 0u &&
                native_aaa_sound_play(&f.app, 9) == 0 && native_aaa_sound_busy(&f.app, 9, &busy) == 0 && busy == 0,
                "missing resource must clear eligibility and remain idle");
    /* A different scene owner loads the same channel after that miss. The
     * clock must query the authoritative provider rather than cached state. */
    ActionSoundAudioCommand command{};
    std::memcpy(command.asset_stem, "Beep12", 7);
    command.channel = 9; command.volume_category = 2; command.mode = 1;
    command.first_percent = 100; command.second_percent = 100;
    command.first_gain = 1; command.second_gain = 1; command.transition_scene = 9999;
    CHECK_CLOCK(live_audio_load_sound(f.app.live_audio, &command) == ACTION_SOUND_BACKEND_OK &&
                native_aaa_sound_play(&f.app, 9) == 0 && native_aaa_sound_busy(&f.app, 9, &busy) == 0 && busy == 1,
                "external shared-channel load must become playable after refresh");
    CHECK_CLOCK(live_audio_unload_sound(f.app.live_audio, 9) == ACTION_SOUND_BACKEND_OK &&
                native_aaa_sound_play(&f.app, 9) == 0 && native_aaa_sound_busy(&f.app, 9, &busy) == 0 && busy == 0,
                "external shared-channel unload must revoke stale playback eligibility");
    std::printf("CLOCK_AUDIO_SHARED missing_idle=1 external_load_busy=1 external_unload_idle=1\n");
    return 0;
}

static int miss(ClockFixture &f)
{
    CHECK_CLOCK(f.hover(0x61) && f.object()->over != 0, "initial hit sets clock over");
    pointer(&f.app, BLACKMOOR_POINTER_MOVE, 11, 11, 0);
    SessionInputHotspot generic{}; generic.index = 0; generic.active = 1; generic.rectangle = {0, 0, 619, 374};
    int32_t candidate = -1;
    const int status = native_pointer_scan(&f.app, &generic, 1u, &candidate);
    std::printf("CLOCK_MISS status=%d fallback=%d over=%d state=%d\n", status, candidate, f.object()->over, f.object()->state);
    CHECK_CLOCK(status == SESSION_INPUT_OK && candidate == 0 && f.object()->over == 0,
                "clock miss must update over and reach guarded generic fallback");
    CHECK_CLOCK(f.release() && f.object()->state == ALC_STATE_TIME, "outside-clock release cannot press retained button");
    return 0;
}

static int refuse(ClockFixture &f, const char *mode)
{
    f.move_to(0x61);
    const AlcObject before = *f.object();
    if (std::strcmp(mode, "guards") == 0) {
        for (unsigned guard = 0; guard < 3; ++guard) {
            f.app.cursor_provider.guard_5b5158 = guard == 0 ? 1 : 0;
            f.app.cursor_provider.guard_5b61af = guard == 1 ? 1 : 0;
            f.app.cursor_provider.guard_5b615e = guard == 2 ? 1 : 0;
            int32_t candidate = -2;
            CHECK_CLOCK(native_pointer_scan(&f.app, nullptr, 0, &candidate) == SESSION_INPUT_LIMIT_PRIORITY_PATH && candidate == -1,
                        "each nonzero original guard retains explicit priority limit");
        }
    } else if (std::strcmp(mode, "unknown") == 0) {
        int32_t candidate = -2;
        const int status = native_pointer_scan(&f.app, nullptr, 0, &candidate);
        std::printf("CLOCK_UNKNOWN status=%d candidate=%d\n", status, candidate);
        CHECK_CLOCK(status == SESSION_INPUT_LIMIT_PRIORITY_PATH && candidate == -1, "opaque owner retains explicit priority limit");
    } else {
        for (unsigned mode_index = 0; mode_index < 2; ++mode_index) {
            f.app.captions.lifecycle.g.overlay_ui = mode_index == 0 ? 2 : 0;
            f.app.captions.lifecycle.g.modal_input = mode_index == 1 ? 1 : 0;
            int32_t candidate = -2;
            CHECK_CLOCK(native_pointer_scan(&f.app, nullptr, 0, &candidate) == SESSION_INPUT_OK && candidate == -1,
                        "UI mode or disabled producer prevents clock hover");
        }
    }
    CHECK_CLOCK(f.object()->state == before.state && f.object()->button == before.button && f.object()->over == before.over,
                "refused hover must leave clock input state unchanged");
    return 0;
}

static void clock_signal(int number)
{
    static const char prefix[] = "clock fixture/native signal failure number=";
    const char digits[] = {static_cast<char>('0' + number / 10), static_cast<char>('0' + number % 10), '\n'};
    (void)write(STDERR_FILENO, prefix, sizeof(prefix) - 1u);
    (void)write(STDERR_FILENO, digits, sizeof(digits));
    _exit(128 + number);
}

int main(int argc, char **argv)
{
    std::signal(SIGBUS, clock_signal);
    std::signal(SIGSEGV, clock_signal);
    std::signal(SIGABRT, clock_signal);
    std::signal(SIGILL, clock_signal);
    @autoreleasepool {
        if (argc == 3 && std::strcmp(argv[1], "--clock-metadata") == 0) {
            ClockFixture f;
            if (!f.load(argv[2])) return 2;
            std::printf("CLOCK_METADATA row=%zu cancel=%d,%d,%d,%d window=%d,%d\n", f.row,
                f.value(0x81), f.value(0x85), f.value(0x89), f.value(0x8d),
                (f.value(0x81) + f.value(0x89)) / 2 + 10,
                (f.value(0x85) + f.value(0x8d)) / 2 + 10);
            return 0;
        }
        if (argc == 4 && std::strcmp(argv[1], "--clock-component") == 0) {
            ClockFixture f;
            const bool audio = std::strncmp(argv[3], "audio", 5) == 0;
            if (!f.initialize(argv[2], std::strcmp(argv[3], "unknown") == 0, audio)) {
                std::fprintf(stderr, "clock component initialization failed\n"); return 2;
            }
            if (std::strcmp(argv[3], "controls") == 0) return controls(f);
            if (std::strcmp(argv[3], "retained") == 0) return retained_release(f);
            if (std::strcmp(argv[3], "cancel") == 0) return cancel_clock(f);
            if (std::strcmp(argv[3], "miss") == 0) return miss(f);
            if (std::strcmp(argv[3], "audio") == 0) return clock_audio(f);
            if (std::strcmp(argv[3], "audio-cancel") == 0) return clock_audio_cancel(f);
            if (std::strcmp(argv[3], "audio-shared") == 0) return clock_audio_shared(f);
            return refuse(f, argv[3]);
        }
        return blackmoor_app_entry_for_clock_test(argc, argv);
    }
}
