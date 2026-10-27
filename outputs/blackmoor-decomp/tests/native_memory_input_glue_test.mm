/* NATIVE24: actual BOOT/new-game and original S1206 memory row.
 * Labeled direct component entry and ordinary --rand-seed1 replay input.
 * Cells are read only to select legal gestures. No story, inventory, cell,
 * phase, candidate, controller or sound-completion writes; no GUI/device. */
#define main blackmoor_app_entry_for_memory_test
#ifndef NATIVE_MEMORY_APP_SOURCE
#define NATIVE_MEMORY_APP_SOURCE "../src/blackmoor_app.mm"
#endif
#include NATIVE_MEMORY_APP_SOURCE
#undef main

#define CHECK(condition, message) do { if (!(condition)) { \
    std::fprintf(stderr, "CHECK failed: %s\n", message); return 1; } } while (0)

static int16_t memory_word(const uint8_t *bytes)
{
    return static_cast<int16_t>(static_cast<uint16_t>(bytes[0] | (bytes[1] << 8)));
}

struct MemoryFixture {
    NativeApp app{};
    std::array<uint8_t, MP_BODY_BYTES> body{};
    size_t row = SIZE_MAX;
    uint8_t subtype = 0u;
    uint32_t now = 1000u;
    uint64_t muted_frames = 0u;
    ~MemoryFixture() { cleanup(&app); }
    const MpObject *object() const { return session_aee_object(app.aee); }
    int32_t value(size_t offset) const { return read_i32_le(object()->b + offset); }
    int32_t cell(int index, size_t offset) const
    { return read_i32_le(object()->cells + static_cast<size_t>(index) * MP_CELL_BYTES + offset); }
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
        app.condition_rand_seed = 1u;
        app.condition_rand_seed_set = true; /* Existing --rand-seed replay configuration. */
        if (app.log == nullptr || session_input_init(&app.input_state) != SESSION_INPUT_OK) return false;
        int external = 0;
        char error[256]{};
        if (!game_ini_configuration(app.game_directory, &external, &app.closed_captioning)) return false;
        app.closed_captioning = 1u; /* Supported user preference. */
        app.resources = game_resources_open((app.game_directory + "/Ciftree").c_str(), external, error, sizeof error);
        GameResourceBytes boot = GAME_RESOURCE_BYTES_INIT;
        if (app.resources == nullptr || !game_resources_load_bytes(app.resources, "BOOT", &boot, error, sizeof error)) return false;
        app.boot = engine_boot_open_memory(boot.bytes, boot.length, error, sizeof error);
        game_resource_bytes_destroy(&boot);
        if (app.boot == nullptr || world_init_cold_zero_event_flags(&app.new_game.action_core) != WORLD_INIT_OK ||
            !load_viewport(&app) || !initialize_caption_runtime(&app) || !initialize_new_game(&app, now) ||
            !clear_before_scene_entry(&app, now)) return false;
        LiveAudioConfig audio{};
        audio.game_directory = directory; audio.mode = MAC_AUDIO_MODE_OFFLINE;
        if (live_audio_create(&audio, &app.live_audio, error, sizeof error) != LIVE_AUDIO_OK) {
            std::fprintf(stderr, "Memory offline audio initialization: %s\n", error); return false;
        }
        app.offline_audio_frames_per_update = 1u;
        app.framebuffer.resize(640u * 480u * 4u);
        app.selector_entry_valid = true;
        app.selector_entry_frame = 0; /* Labeled direct scene/selector entry. */
        app.selector_entry_scroll = 0;
        if (!load_scene(&app, 1206)) return false;
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
    bool advance_to(uint32_t target)
    {
        uint32_t rate = 0u, channels = 0u;
        if (target < 1000u || live_audio_offline_format(app.live_audio, &rate, &channels) != LIVE_AUDIO_OK) return false;
        const uint64_t goal = (static_cast<uint64_t>(target - 1000u) * rate + 999u) / 1000u;
        const uint64_t rendered = live_audio_offline_frames_rendered(app.live_audio);
        return tick(goal > rendered ? goal - rendered : 0u);
    }
    bool hover(size_t rectangle)
    {
        const uint8_t *r = body.data() + rectangle;
        const int32_t x = (read_i32_le(r) + read_i32_le(r + 8u)) / 2 +
            app.scene_destination.left - app.cursor_provider.hot_x;
        const int32_t y = (read_i32_le(r + 4u) + read_i32_le(r + 12u)) / 2 +
            app.scene_destination.top - app.nav.scroll - app.cursor_provider.hot_y;
        pointer(&app, BLACKMOOR_POINTER_MOVE, x, y, 0u);
        return tick();
    }
    bool release(bool move_off = false)
    {
        pointer(&app, BLACKMOOR_POINTER_DOWN, app.pointer_x, app.pointer_y, 0u);
        if (!tick()) return false;
        if (move_off) pointer(&app, BLACKMOOR_POINTER_MOVE, 0, 0, 0u); /* No intervening scan. */
        pointer(&app, BLACKMOOR_POINTER_UP, 0, 0, 0u); /* Original UP ignores these coordinates. */
        return tick();
    }
    bool page(int desired)
    {
        if (value(0x28cu) == desired) return true;
        const int current = value(0x28cu);
        if (desired < 0 || desired >= read_i32_le(body.data() + 0x347u) || body[0x35bu] == 0u ||
            !hover(0x2a1u + static_cast<size_t>(current) * 0x30u + static_cast<size_t>(desired) * 16u) ||
            app.input_state.candidate != MP_CANDIDATE_TAB || !release()) return false;
        return value(0x28cu) == desired;
    }
    bool hover_cell(int index)
    {
        const int per_page = value(0x280u);
        return index >= 0 && index < value(0x284u) && per_page > 0 && page(index / per_page) &&
            hover(0x111u + static_cast<size_t>(index % per_page) * 16u);
    }
    bool click_cell(int index, bool move_off = false)
    { return hover_cell(index) && app.input_state.candidate == MP_CANDIDATE_TILE && release(move_off); }
    bool wait_sound(uint16_t channel, uint64_t generation)
    {
        for (unsigned step = 0u; step < 600u; ++step) {
            LiveAudioPlaybackCursor cursor{};
            if (live_audio_get_playback_cursor(app.live_audio, channel, generation, &cursor) != LIVE_AUDIO_OK) return false;
            if (!cursor.playing) return cursor.source_frames == cursor.source_frame_count && cursor.source_frames > 0u;
            if (!tick(2048u)) return false;
        }
        return false;
    }
};

static int start_memory(MemoryFixture &f)
{
    CHECK(f.tick(), "first actual S1206 visit runs the eligible original memory row");
    CHECK(f.app.current_scene_id == 1206 && f.object() && mp_object_active(f.object()) &&
          mp_object_row(f.object()) == 1 && session_aee_registered(f.app.aee),
          "fresh labeled direct S1206 entry naturally activates original row1 without story injection");
    f.row = static_cast<size_t>(mp_object_row(f.object()));
    SceneActionInfo action{};
    SceneActionRuntimeState runtime{};
    CHECK(native_action_at(&f.app, f.row, &action) == SCENE_RESOURCE_OK && action.type == SESSION_AEE_TYPE &&
          action.typed_body_length == MP_BODY_BYTES &&
          scene_session_get_action_state(f.app.session, f.row, &runtime) == SCENE_SESSION_OK && runtime.phase == 1u,
          "active canonical row owns the complete original memory body and natural phase1");
    std::memcpy(f.body.data(), action.typed_body, f.body.size());
    f.subtype = action.subtype;
    CHECK(f.value(0x280u) > 0 && f.value(0x280u) <= MP_MAX_TILES_PER_PAGE &&
          f.value(0x284u) >= f.value(0x280u) && f.value(0x284u) <= MP_MAX_CELLS &&
          f.value(0x2a0u) >= 2 && f.value(0x2a0u) <= f.value(0x284u) / 2,
          "original deal respects actual page, cell and pair bounds");
    std::printf("MEMORY_START scene=1206 row=%zu subtype=%u direct_component_entry=1 seed=1 pages=%d per_page=%d total=%d needed=%d tries_allowed=%d flip_ms=%d\n",
        f.row, f.subtype, read_i32_le(f.body.data() + 0x347u), f.value(0x280u), f.value(0x284u), f.value(0x2a0u),
        read_i32_le(f.body.data() + 0x341u), read_i32_le(f.body.data() + 0x331u));
    std::fflush(stdout);
    return 0;
}

static int actual_sound(MemoryFixture &f, size_t offset, LiveAudioPlaybackCursor *cursor)
{
    const uint8_t *record = f.body.data() + offset;
    const int16_t channel = memory_word(record + 0x21u);
    LiveAudioChannelInfo info{};
    CHECK(std::strcmp(reinterpret_cast<const char *>(record), "NO SOUND") != 0 && channel >= 0 &&
          static_cast<unsigned>(channel) < LIVE_AUDIO_CHANNEL_COUNT && MP_SOUND_HOST_BYTES == 0x31u,
          "selected original sound record names an actual channel and0x31-byte descriptor prefix");
    CHECK(live_audio_get_channel_info(f.app.live_audio, static_cast<uint16_t>(channel), &info) == LIVE_AUDIO_OK &&
          live_audio_get_playback_cursor(f.app.live_audio, static_cast<uint16_t>(channel), 0u, cursor) == LIVE_AUDIO_OK &&
          info.loaded && info.started && cursor->loaded && cursor->started && cursor->playing &&
          cursor->source_frame_count > 0u && info.control_word == static_cast<uint32_t>(read_i32_le(record + 0x29u)) &&
          info.first_percent == memory_word(record + 0x2du) && info.second_percent == memory_word(record + 0x2fu),
          "actual memory descriptor loads and starts real native audio with original independent gains/control");
    return 0;
}

static bool original_no_sound_group(const MemoryFixture &f, size_t base, int count)
{
    for (int i = 0; i < count; ++i)
        if (std::strcmp(reinterpret_cast<const char *>(f.body.data() + base +
            static_cast<size_t>(i) * MP_SOUND_RECORD_BYTES), "NO SOUND") != 0) return false;
    return true;
}

static int gesture_and_mismatch(MemoryFixture &f)
{
    CHECK(start_memory(f) == 0 && f.cell(0, 4u) == 0 && f.cell(0, 8u) == 0,
          "actual first card begins face down and unmatched");
    CHECK(f.hover_cell(0), "real card0 pointer move reaches the actual app cascade");
    SceneSessionPointerResult pointer_result{};
    CHECK(scene_session_get_pointer_result(f.app.session, &pointer_result) == SCENE_SESSION_OK,
          "actual card0 hover exposes the session input boundary");
    std::printf("MEMORY_HOVER consume=%d scan=%d candidate=%d cursor=%d/%d tile=%d face_up=%d\n",
        pointer_result.consume_status, pointer_result.scan_status, f.app.input_state.candidate,
        f.app.nav_cursor.index, f.app.nav_cursor.variant, f.value(0x27cu), f.cell(0, 4u));
    CHECK(
          pointer_result.consume_status == SESSION_INPUT_OK && pointer_result.scan_status == SESSION_INPUT_OK &&
          f.app.input_state.candidate == MP_CANDIDATE_TILE && f.app.nav_cursor.index == 0 &&
          f.app.nav_cursor.variant == 1 && f.value(0x27cu) == 0,
          "actual card0 hover publishes memory candidate/cursor after ACT without priority-path refusal");
    CHECK(f.release(true) && f.cell(0, 4u) == 1 && f.value(0x1cu) == static_cast<int32_t>(MP_GUEST_CELLS) &&
          f.app.input_state.candidate == -1,
          "same-tick move-off release flips the retained card before the subsequent scan clears its candidate");
    LiveAudioPlaybackCursor first{};
    CHECK(actual_sound(f, 0x35cu, &first) == 0 &&
          f.wait_sound(static_cast<uint16_t>(memory_word(f.body.data() + 0x35cu + 0x21u)), first.generation),
          "first actual flip plays its original sound record through natural source completion");
    CHECK(f.hover_cell(0) && f.app.input_state.candidate == -1 && f.release() && f.value(0x20u) == 0,
          "already face-up tile cannot become the second card through ordinary input");
    int wrong = -1, blocked = -1;
    for (int i = 1; i < f.value(0x280u); ++i) {
        if (wrong < 0 && f.cell(i, 0u) != f.cell(0, 0u)) wrong = i;
        else if (blocked < 0) blocked = i;
    }
    CHECK(wrong >= 0 && blocked >= 0 && f.click_cell(wrong) && f.cell(wrong, 4u) == 1 &&
          f.value(0x34u) == 1 && f.value(0x290u) == 0 && f.value(0x294u) == 1,
          "read-only real cell identities select a legal mismatch, one try and original flip-back wait");
    CHECK(original_no_sound_group(f, 0x856u, 10) && f.value(0x2bcu) == -1,
          "actual S1206 wrong group is entirely NO SOUND and the controller preserves its silent pick");
    LiveAudioPlaybackCursor second{};
    CHECK(actual_sound(f, 0x412u, &second) == 0, "second actual flip starts its original real sound despite silent wrong response");
    const uint32_t deadline = static_cast<uint32_t>(f.value(0x38u));
    CHECK(f.hover_cell(blocked) && f.app.input_state.candidate == MP_CANDIDATE_TILE && f.release() &&
          f.cell(blocked, 4u) == 0 && f.value(0x294u) == 1,
          "a third normal card gesture is ignored during original flip-back pending state");
    CHECK(deadline > f.now && f.advance_to(deadline) && f.cell(0, 4u) == 1 && f.cell(wrong, 4u) == 1 &&
          f.value(0x34u) == 1 && f.advance_to(deadline + 1u) && f.cell(0, 4u) == 0 &&
          f.cell(wrong, 4u) == 0 && f.value(0x34u) == 0 && f.value(0x1cu) == 0 && f.value(0x20u) == 0,
          "strict original flip-back deadline retains both cards at equality and clears them after it");
    const uint16_t channel = static_cast<uint16_t>(memory_word(f.body.data() + 0x412u + 0x21u));
    CHECK(f.wait_sound(channel, second.generation), "real second flip reaches its natural source end without fake idle");
    std::printf("MEMORY_GESTURE retained_release=1 wrong=%d third_guard=1 exact_deadline=1 flip_sounds_completed=2 wrong_no_sound=1 muted_frames=%llu\n",
        wrong, static_cast<unsigned long long>(f.muted_frames));
    return 0;
}

static int actual_pair_solution(MemoryFixture &f)
{
    CHECK(start_memory(f) == 0, "actual memory component starts before legal pair gestures");
    const int needed = f.value(0x2a0u), total = f.value(0x284u);
    const int16_t target = memory_word(f.body.data() + 0x168eu);
    const int16_t flag = memory_word(f.body.data() + 0x168eu + 0x16u);
    const int16_t flag_value = memory_word(f.body.data() + 0x168eu + 0x18u);
    const int16_t slot = mp_object_slot(f.object());
    CHECK(original_no_sound_group(f, 0x4c8u, 5) && original_no_sound_group(f, 0x856u, 10) &&
          original_no_sound_group(f, 0xf72u, 10),
          "actual S1206 match/wrong/win groups are all original NO SOUND records");
    unsigned pages_seen = 1u;
    for (int pair = 0; pair < needed; ++pair) {
        int first = -1, second = -1;
        for (int i = 0; i < total && first < 0; ++i) {
            if (f.cell(i, 8u) != 0) continue;
            for (int j = i + 1; j < total; ++j)
                if (f.cell(j, 8u) == 0 && f.cell(i, 0u) == f.cell(j, 0u)) { first = i; second = j; break; }
        }
        CHECK(first >= 0 && second >= 0 && f.click_cell(first) && f.click_cell(second),
              "read-only dealt identities select an actual legal pair through original page tabs and pointer releases");
        pages_seen |= 1u << static_cast<unsigned>(first / f.value(0x280u));
        pages_seen |= 1u << static_cast<unsigned>(second / f.value(0x280u));
        CHECK(f.cell(first, 4u) == 1 && f.cell(second, 4u) == 1 && f.cell(first, 8u) == 1 &&
              f.cell(second, 8u) == 1 && f.value(0x290u) == pair + 1 && f.value(0x294u) == pair + 1 &&
              f.value(0x1cu) == 0 && f.value(0x20u) == 0 && f.value(0x2b8u) == -1,
              "real equal pictures remain face up and matched, increasing original pairs/tries exactly once");
    }
    CHECK(f.value(0x28u) == 1 && mp_object_state(f.object()) == MP_STATE_WIN_PICK,
          "real required pairs enter the original win-pick state");
    LiveAudioPlaybackCursor last_flip{};
    CHECK(actual_sound(f, 0x412u, &last_flip) == 0,
          "last winning pair still plays its real second-flip sound");
    SceneTransitionRequest pending{};
    SceneActionRuntimeState runtime{};
    CHECK(f.tick() && f.value(0x2c0u) == -1 && mp_object_state(f.object()) == MP_STATE_WIN_PICK &&
          scene_session_get_action_state(f.app.session, f.row, &runtime) == SCENE_SESSION_OK && runtime.phase == 2u &&
          !scene_session_get_pending_transition(f.app.session, &pending) && f.tick(),
          "original NO SOUND win picks-1 and advances directly through phase2 to its finish block");
    CHECK(target != MP_NO_SCENE && scene_session_get_pending_transition(f.app.session, &pending) &&
          pending.target_scene == target && scene_session_get_action_state(f.app.session, f.row, &runtime) == SCENE_SESSION_OK &&
          runtime.completed == (f.subtype == 1u ? 1u : 0u) && !mp_object_active(f.object()) && !session_aee_registered(f.app.aee) &&
          mp_object_row(f.object()) == -1 && mp_object_slot(f.object()) == -1 && f.value(0x08u) == 0 &&
          f.value(0x14u) == 0 && f.value(0x18u) == 0 && !f.app.aee_slot_used[static_cast<size_t>(slot)] &&
          (flag == MP_NO_FLAG || f.app.new_game.event_flags[static_cast<size_t>(flag)] == flag_value),
          "original silent win scene/event block, generic completion and surface/cell/slot retirement follow legal matching");
    std::printf("MEMORY_SOLVE pairs=%d tries=%d pages_mask=%u real_last_flip_frames=%llu win_no_sound=1 target=%d flag=%d cleanup=1 muted_frames=%llu\n",
        needed, needed, pages_seen, static_cast<unsigned long long>(last_flip.source_frame_count), target, flag,
        static_cast<unsigned long long>(f.muted_frames));
    return 0;
}

int main(int argc, char **argv)
{
    @autoreleasepool {
        CHECK(argc == 3, "owner-local game directory and bounded memory case required");
        MemoryFixture fixture;
        const bool initialized = fixture.initialize(argv[1]);
        if (!initialized) fixture.print_log_tail();
        CHECK(initialized, "actual BOOT/new-game labeled direct S1206 component initializes");
        if (std::strcmp(argv[2], "gesture") == 0) return gesture_and_mismatch(fixture);
        if (std::strcmp(argv[2], "solve") == 0) return actual_pair_solution(fixture);
        return 2;
    }
}
