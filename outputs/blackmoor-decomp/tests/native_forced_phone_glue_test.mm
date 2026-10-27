/* N27: original BOOT/fresh world and labeled FIRST direct entry S3337.
 * Ordinary updates/rendering/silent audio drive the genuine group3 forced call.
 * No story, visit, phase, candidate, popup-state or midgame RNG injection.
 * Fresh S1600's unavailable/farewell branch is separate from hook6 topics.
 * The separately labeled manual-request guard case supplies unit input/state. */
#define main blackmoor_app_entry_for_forced_phone_test
#ifndef NATIVE_FORCED_PHONE_APP_SOURCE
#define NATIVE_FORCED_PHONE_APP_SOURCE "../src/blackmoor_app.mm"
#endif
#include NATIVE_FORCED_PHONE_APP_SOURCE
#undef main

#define CHECK(condition, message) do { if (!(condition)) { \
    std::fprintf(stderr, "CHECK failed: %s\n", message); return 1; } } while (0)

static int16_t forced_phone_word(const uint8_t *bytes)
{
    return static_cast<int16_t>(static_cast<uint16_t>(bytes[0] | bytes[1] << 8));
}

struct PhoneFixture {
    NativeApp app{};
    const SceneResource *room = nullptr;
    HostImage room_art{};
    std::vector<uint8_t> room_backbuffer;
    uint64_t initial_voice_frames = 0u, pickup_frames = 0u;
    uint32_t now = 1000u;
    uint64_t muted_frames = 0u;
    ~PhoneFixture() { cleanup(&app); }
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
            std::fprintf(stderr, "Phone offline audio initialization: %s\n", error); return false;
        }
        app.offline_audio_frames_per_update = 1u;
        app.framebuffer.resize(640u * 480u * 4u);
        app.selector_entry_valid = true;
        app.selector_entry_frame = 0; /* Labeled direct scene/selector entry. */
        app.selector_entry_scroll = 0;
        if (!load_scene(&app, 3337)) return false;
        const ActionFamily28Rect view = {app.scene_destination.left, app.scene_destination.top,
                                         app.scene_destination.right, app.scene_destination.bottom};
        room = app.scene; room_art = app.scene_frame;
        return session_exit_init(&app.exit_state, &view) == SESSION_EXIT_OK && create_native_scene_session(&app);
    }
    bool render_audio(uint64_t frames)
    {
        if (frames != 0u) {
            LiveAudioOfflineStats stats{};
            if (live_audio_advance_offline(app.live_audio, frames, &stats, nullptr, 0u) != LIVE_AUDIO_OK ||
                stats.frames != frames || stats.nonfinite_samples != 0u || stats.nonzero_samples != 0u) return false;
            muted_frames += stats.frames;
        }
        return true;
    }
    bool tick(uint64_t frames = 0u)
    {
        if (!render_audio(frames)) return false;
        uint32_t rate = 0u, channels = 0u;
        if (live_audio_offline_format(app.live_audio, &rate, &channels) != LIVE_AUDIO_OK || rate == 0u) return false;
        now = 1000u + static_cast<uint32_t>(live_audio_offline_frames_rendered(app.live_audio) * 1000u / rate);
        update(&app, now);
        if (app.failure || app.session_block_reported) { print_log_tail(); return false; }
        return true;
    }
    bool finish_audio(uint16_t channel, uint64_t generation, LiveAudioPlaybackCursor *last)
    {
        for (unsigned i = 0u; i < 1800u; ++i) {
            if (live_audio_get_playback_cursor(app.live_audio, channel, generation, last) != LIVE_AUDIO_OK) return false;
            if (!last->playing) return last->source_frames == last->source_frame_count && last->source_frames > 0u;
            if (!render_audio(1600u) ||
                live_audio_get_playback_cursor(app.live_audio, channel, generation, last) != LIVE_AUDIO_OK) return false;
            if (last->playing && !tick()) return false;
        }
        return false;
    }
};

static int initial_request(PhoneFixture &f)
{
    SceneActionInfo voice_row{}, request_row{};
    SceneActionRuntimeState request_state{};
    CHECK(f.app.current_scene_id == 3337 && f.app.new_game.scene_visits[3337u] == 1u &&
          scene_resource_action_at(f.app.scene, 0u, &voice_row) == SCENE_RESOURCE_OK && voice_row.type == 0x9fu &&
          scene_resource_action_at(f.app.scene, 4u, &request_row) == SCENE_RESOURCE_OK && request_row.type == 0x1du &&
          request_row.typed_body_length == 8u && request_row.dependency_count == 2u &&
          request_row.typed_body[0] == 3u && request_row.typed_body[1] == 0u && request_row.typed_body[2] == 1u &&
          request_row.typed_body[3] == 1u && forced_phone_word(request_row.typed_body + 4u) == 1600 &&
          forced_phone_word(request_row.typed_body + 6u) == 1 &&
          f.app.new_game.event_flags[1570u] == 0 && f.app.new_game.event_flags[1574u] == 0,
          "first direct S3337 entry owns original voice and naturally gated group3/code1/1600/1 body in fresh world");
    CHECK(f.tick(), "original S3337 first-entry voice starts before its forced-call dependency is true");
    LiveAudioPlaybackCursor voice{};
    CHECK(live_audio_get_playback_cursor(f.app.live_audio, 13u, 0u, &voice) == LIVE_AUDIO_OK &&
          voice.loaded && voice.started && voice.playing && voice.source_frame_count > 0u &&
          scene_session_get_action_state(f.app.session, 4u, &request_state) == SCENE_SESSION_OK && !request_state.completed &&
          f.app.captions.lifecycle.g.overlay_ui == 0 && !f.app.bar.flag[3],
          "real channel13 initial voice keeps row4 uncompleted while it is still playing");
    CHECK(f.finish_audio(13u, voice.generation, &voice), "real S3337 channel13 reaches natural source completion");
    f.initial_voice_frames = voice.source_frames;
    std::printf("FORCED_PHONE_INITIAL direct_entry=3337 first_visit=1 voice13_frames=%llu naturally_finished=1\n",
        static_cast<unsigned long long>(f.initial_voice_frames));
    std::fflush(stdout);
    CHECK(f.tick() && f.app.current_scene_id == 3337 &&
          scene_session_get_action_state(f.app.session, 4u, &request_state) == SCENE_SESSION_OK && request_state.completed &&
          f.app.captions.lifecycle.g.overlay_ui == 1 && f.app.bar.flag[3] == 1u,
          "real sound/visit dependencies execute row4 and defer phone opening as screen1 plus taskbar flag3");
    f.room_backbuffer = f.app.captions.backbuffer_pixels;
    return 0;
}

#ifndef NATIVE_FORCED_PHONE_BASELINE
static int taskbar_request_guard(PhoneFixture &f)
{
    SceneActionRuntimeState first{};
    CHECK(f.app.current_scene_id == 3337 && f.app.captions.lifecycle.g.overlay_ui == 0 &&
          f.app.a80_object.word_6b2 == 9999 && f.app.phone_unavailable_5a1e58 == 0 &&
          scene_session_tick_count(f.app.session) == 0u &&
          scene_session_get_action_state(f.app.session, 0u, &first) == SCENE_SESSION_OK &&
          first.phase == 0u && !first.completed,
          "manual-request unit guard starts in actual BOOT/direct fixture before any story dispatch");
    const auto owner_cells = [](const Action80Object &o) {
        return std::array<int64_t, 11>{o.scene_6ba, o.word_6bc, o.word_6be,
            o.dword_6c2, o.dword_6c6, o.dword_6ca, o.state_4528, o.word_6b2,
            o.dword_6b4, o.dword_4530, o.dword_65d2};
    };
    for (unsigned variant = 0u; variant < 2u; ++variant) {
        /* Labeled unit input: a pending taskbar phone request. Variant1 is
         * explicit unit state isolating unavailable with a non-sentinel target;
         * neither variant is a positive gameplay or story-route fixture. */
        f.app.bar.flag[3] = 1u;
        if (variant == 1u) {
            f.app.a80_object.word_6b2 = 1600;
            f.app.phone_unavailable_5a1e58 = 1;
        }
        const auto owner = owner_cells(f.app.a80_object);
        const auto backbuffer = f.app.captions.backbuffer_pixels;
        const auto frame = f.app.framebuffer;
        const size_t images = f.app.captions.raw_images.size();
        const uint64_t generation = scene_session_scene_generation(f.app.session);
        CHECK(!f.app.phone.active && !f.app.phone.pickup_loaded && !f.app.phone_base_surface &&
              !f.app.phone_extras_surface && !f.app.a80_object_valid && !f.app.failure,
              "guard starts without a popup, host assets, saved return tuple or app failure");
        CHECK(native_phone_pre_tick(&f.app) == 0 && f.app.captions.lifecycle.g.overlay_ui == 0 &&
              f.app.bar.flag[3] == 1u && !f.app.bar.flag[0] && !f.app.bar.flag[1] && !f.app.bar.flag[2] &&
              owner_cells(f.app.a80_object) == owner && !f.app.phone.active && !f.app.phone.pickup_loaded &&
              !f.app.phone_base_surface && !f.app.phone_extras_surface && !f.app.a80_object_valid &&
              f.app.captions.raw_images.size() == images && f.app.captions.backbuffer_pixels == backbuffer &&
              f.app.framebuffer == frame && !f.app.failure && !f.app.session_block_reported &&
              scene_session_tick_count(f.app.session) == 0u &&
              scene_session_scene_generation(f.app.session) == generation,
              "unsupported manual/unavailable taskbar request remains an unconsumed no-op before screen, owner or host asset effects");
    }
    std::printf("FORCED_PHONE_REQUEST_GUARD unit_cases=manual-sentinel,unavailable variants=2 request_retained=1 screen=0 host_open=0 story_dispatch=0\n");
    return 0;
}

static int retained_room(PhoneFixture &f)
{
    SceneExecutorSlotInfo voice{}, request{};
    SceneActionRuntimeState completed{};
    CHECK(f.app.last_art_scene_id == 3337 && f.app.scene_frame.rgba == f.room_art.rgba &&
          f.app.scene_destination.left == 10 && f.app.scene_destination.top == 10 &&
          f.app.scene_destination.right == 629 && f.app.scene_destination.bottom == 384 &&
          scene_session_get_slot(f.app.session, 0u, &voice) == SCENE_SESSION_OK && voice.occupied &&
          voice.runtime_type == 0x9fu && voice.source == f.room && voice.source_index == 0u &&
          scene_session_get_slot(f.app.session, 4u, &request) == SCENE_SESSION_OK && request.occupied &&
          request.runtime_type == 0x1du && request.source == f.room && request.source_index == 4u &&
          scene_session_get_action_state(f.app.session, 4u, &completed) == SCENE_SESSION_OK && completed.completed == 1u,
          "NO_ART phone scenes retain original room art/viewport and canonical row0 voice plus completed row4 control owner");
    return 0;
}

static int open_pickup(PhoneFixture &f, LiveAudioPlaybackCursor *pickup)
{
    CHECK(initial_request(f) == 0 && !f.app.phone.active && !f.app.a80_object_valid &&
          f.app.a80_object.word_6b2 == 1600 && f.app.a80_object.dword_6b4 == 1,
          "deferred request preserves genuine forced target/autoclose without manufacturing a saved return tuple");
    const uint64_t ticks = scene_session_tick_count(f.app.session);
    CHECK(f.tick() && f.app.phone.active && f.app.captions.lifecycle.g.overlay_ui == 5 && !f.app.bar.flag[3] &&
          f.app.a80_object.state_4528 == 5 && !f.app.a80_object_valid &&
          scene_session_tick_count(f.app.session) == ticks && f.app.phone_base_surface && f.app.phone_extras_surface,
          "next tick normalizes screen1, opens original phone surfaces and skips ACT before pickup");
    CHECK(f.tick() && f.app.a80_object.state_4528 == 2 && f.app.a80_object.dword_4530 == 5 &&
          f.app.phone.pickup_loaded && !f.app.a80_object_valid &&
          scene_session_tick_count(f.app.session) == ticks + 1u &&
          std::strcmp(reinterpret_cast<const char *>(f.app.phone.pickup), "TelPickUp01") == 0 &&
          forced_phone_word(f.app.phone.pickup + 0x21u) == 3 &&
          live_audio_get_playback_cursor(f.app.live_audio, 3u, 0u, pickup) == LIVE_AUDIO_OK &&
          pickup->loaded && pickup->started && pickup->playing && pickup->source_frame_count > 0u,
          "normal post-ACT phone process starts actual BOOT TelPickUp01 on channel3 with real native source frames");
    return retained_room(f);
}

static int call_scene(PhoneFixture &f, LiveAudioPlaybackCursor *pickup)
{
    CHECK(open_pickup(f, pickup) == 0, "genuine deferred phone opening precedes call-scene transfer");
    const NativePhoneWorld before = native_phone_world(&f.app);
    CHECK(f.finish_audio(3u, pickup->generation, pickup), "actual pickup reaches natural native source end");
    f.pickup_frames = pickup->source_frames;
    CHECK(f.tick() && f.app.a80_object.dword_4530 == 6 && !f.app.phone.pickup_loaded && !f.app.a80_object_valid,
          "completed real pickup unloads before saving the return tuple or requesting a call scene");
    LiveAudioChannelInfo unloaded{};
    CHECK(live_audio_get_channel_info(f.app.live_audio, 3u, &unloaded) == LIVE_AUDIO_OK && !unloaded.loaded,
          "original pickup ownership unloads channel3 after its natural completion");
    CHECK(f.tick() && f.app.a80_object_valid && f.app.phone.active &&
          f.app.phone.saved_current_scene_6b8 == 3337 && f.app.a80_object.scene_6ba == 3337 &&
          f.app.a80_object.word_6bc == before.frame_5bb50b && f.app.a80_object.word_6be == before.vertical_5bb593 &&
          f.app.a80_object.dword_6c2 == before.dword_5bb5a7 &&
          f.app.a80_object.dword_6c6 == before.dword_5bb5af && f.app.a80_object.dword_6ca == 0 &&
          f.app.captions.lifecycle.g.overlay_ui == 0 && f.app.exit_state.g.load_game_flag == 1,
          "actual pickup controller captures authoritative original return mirrors, including duplicate6c6 and untouched6ca");
    SceneTransitionRequest pending{};
    CHECK(scene_session_get_pending_transition(f.app.session, &pending) && pending.target_scene == 1600 &&
          pending.opaque_words[2] == 1 && pending.opaque_dwords[2] == 1,
          "actual controller requests original automatic S1600 transition with retained-popup tuple");
    for (unsigned i = 0u; i < 40u && f.app.current_scene_id == 3337; ++i)
        CHECK(f.tick(1600u), "normal exit/load updates apply the original retained NO_ART call transition");
    CHECK(f.app.current_scene_id == 1600 && retained_room(f) == 0 && f.app.phone.active &&
          f.app.a80_object.state_4528 == 2 && f.app.a80_object.dword_4530 == 0 &&
          f.app.captions.lifecycle.g.overlay_ui == 0 && f.app.exit_state.g.load_game_flag == 1,
          "S1600 call scene retains the real popup and its shared raw80 owner while preserving the room");
    return 0;
}

struct PhoneCrop { unsigned sheet; int sx, sy, dx, dy, width, height; };

static int phone_pixels(PhoneFixture &f, bool during_call)
{
    CaptionCompositorView base{}, extras{};
    CHECK(native_caption_view_for_handle(&f.app, f.app.phone_base_surface, &base) &&
          native_caption_view_for_handle(&f.app, f.app.phone_extras_surface, &extras) &&
          base.format == CAPTION_COMPOSITOR_RGB555_LE && extras.format == CAPTION_COMPOSITOR_RGB555_LE &&
          f.app.captions.compositor_format == CAPTION_COMPOSITOR_RGB555_LE &&
          f.room_backbuffer.size() == 640u * 480u * 2u,
          "real BOOT phone sheets and room snapshot supply native RGB555 pixels for independent comparison");
    // Literal original UICL crops, independently read from the owner-local BOOT.
    // Empty-screen source subtracts popup377,0 AND VIEW10,10 from destination.
    const PhoneCrop common[] = {{0,1,1,387,10,243,375}, {1,265,195,604,15,20,19}, {0,31,27,418,37,170,183}};
    const PhoneCrop pickup[] = {{1,245,29,483,23,47,11}, {1,1,70,467,101,74,37}};
    const PhoneCrop calling[] = {{1,201,29,557,23,21,12}, {1,362,29,491,205,21,15}, {1,384,29,534,205,53,15}};
    std::vector<uint8_t> expected = f.room_backbuffer;
    auto copy_crop = [&](const PhoneCrop &crop) {
        const CaptionCompositorView &sheet = crop.sheet ? extras : base;
        if (crop.sx < 0 || crop.sy < 0 || crop.sx + crop.width > sheet.width || crop.sy + crop.height > sheet.height) return false;
        for (int y = 0; y < crop.height; ++y)
            std::memcpy(expected.data() + (static_cast<size_t>(crop.dy + y) * 640u + static_cast<size_t>(crop.dx)) * 2u,
                sheet.pixels + static_cast<size_t>(crop.sy + y) * static_cast<size_t>(sheet.pitch_bytes) +
                static_cast<size_t>(crop.sx) * 2u, static_cast<size_t>(crop.width) * 2u);
        return true;
    };
    for (const PhoneCrop &crop : common) CHECK(copy_crop(crop), "original common phone crop is inside the loaded sheet");
    if (during_call) {
        for (const PhoneCrop &crop : calling) CHECK(copy_crop(crop), "original retained-call status crop is inside extras");
    } else {
        for (const PhoneCrop &crop : pickup) CHECK(copy_crop(crop), "original pickup signal/welcome crop is inside extras");
    }
    uint64_t signature = UINT64_C(14695981039346656037);
    for (size_t y = 10u; y <= 384u; ++y) for (size_t x = 387u; x <= 629u; ++x) {
        const size_t at = (y * 640u + x) * 2u;
        CHECK(f.app.captions.backbuffer_pixels[at] == expected[at] &&
              f.app.captions.backbuffer_pixels[at + 1u] == expected[at + 1u],
              "actual phone frame and absolute extras match independent original sheet crops in the software backbuffer");
        const uint16_t word = static_cast<uint16_t>(expected[at] | expected[at + 1u] << 8);
        const uint8_t rgba[] = {static_cast<uint8_t>(((word >> 10) & 31u) * 255u / 31u),
            static_cast<uint8_t>(((word >> 5) & 31u) * 255u / 31u), static_cast<uint8_t>((word & 31u) * 255u / 31u), 255u};
        CHECK(std::memcmp(f.app.framebuffer.data() + (y * 640u + x) * 4u, rgba, sizeof rgba) == 0,
              "actual phone software frame reaches the native RGBA framebuffer with original crop pixels");
        signature ^= word; signature *= UINT64_C(1099511628211);
    }
    std::printf("FORCED_PHONE_FRAME mode=%s pixels=91125 crops=%u fnv64=%016llx viewport=10,10,629,384\n",
        during_call ? "retained-call" : "pickup", during_call ? 6u : 5u, static_cast<unsigned long long>(signature));
    return 0;
}

static int frames(PhoneFixture &f)
{
    LiveAudioPlaybackCursor pickup{};
    CHECK(open_pickup(f, &pickup) == 0 && phone_pixels(f, false) == 0,
          "actual first-entry forced pickup displays original phone frame, close button, empty screen, signal and welcome art");
    CHECK(f.finish_audio(3u, pickup.generation, &pickup) && f.tick() && f.tick(),
          "actual pickup completes and the phone controller requests its call scene");
    for (unsigned i = 0u; i < 40u && f.app.current_scene_id == 3337; ++i)
        CHECK(f.tick(1600u), "normal updates retain phone art across S1600 loading");
    CHECK(f.app.current_scene_id == 1600 && f.tick() && retained_room(f) == 0 && phone_pixels(f, true) == 0,
          "real S1600 greeting draws retained base/close/empty and battery/web/directory crops before its caption layer");
    return 0;
}

static int flow(PhoneFixture &f)
{
    LiveAudioPlaybackCursor pickup{};
    CHECK(call_scene(f, &pickup) == 0 && f.tick(), "original fresh-world call begins its natural S1600 dialogue visit");
    const Convo3fManager *manager = session_a3f_manager(f.app.a3f);
    SceneExecutorSlotInfo greeting_owner{};
    LiveAudioPlaybackCursor greeting{};
    CHECK(manager && manager->row >= 0 && manager->type == 0x3fu && manager->sub_state == 4u &&
          manager->response_count == 0 &&
          scene_session_get_slot(f.app.session, static_cast<size_t>(manager->row), &greeting_owner) == SCENE_SESSION_OK &&
          greeting_owner.source == f.app.scene && greeting_owner.source_index == 6u &&
          live_audio_get_playback_cursor(f.app.live_audio, 12u, 0u, &greeting) == LIVE_AUDIO_OK &&
          greeting.started && greeting.playing && greeting.source_frame_count > 0u,
          "fresh E1570/E1574 zeros select original S1600 row6 unavailable/farewell voice without topic or story injection");
    CHECK(f.finish_audio(12u, greeting.generation, &greeting), "actual original fresh-call dialogue voice naturally completes");
    bool returned = false, hangup_seen = false, raw80_completed = false;
    for (unsigned i = 0u; i < 500u && !returned; ++i) {
        CHECK(f.tick(1600u), "normal original dialogue/NO_ART/raw80 updates return and close the forced phone");
        if (f.app.current_scene_id == 6310) {
            hangup_seen = true;
            SceneTransitionRequest pending{};
            if (scene_session_get_pending_transition(f.app.session, &pending)) {
                for (size_t row = 0; row < scene_session_action_high_water(f.app.session); ++row) {
                    SceneExecutorSlotInfo slot{}; SceneActionRuntimeState state{};
                    if (scene_session_get_slot(f.app.session, row, &slot) == SCENE_SESSION_OK && slot.occupied &&
                        slot.action.type == 0x80u && slot.source_index == 1u &&
                        scene_session_get_action_state(f.app.session, row, &state) == SCENE_SESSION_OK && state.completed)
                        raw80_completed = pending.target_scene == 3337;
                }
                CHECK(!f.app.phone.active && !f.app.phone_base_surface && !f.app.phone_extras_surface &&
                      f.app.a80_object.state_4528 == 0 && f.app.a80_object.word_6b2 == 9999 &&
                      f.app.a80_object.dword_6b4 == 0 && f.app.a80_object.dword_65d2 == 1 &&
                      f.app.captions.lifecycle.g.overlay_ui == 0 && f.app.exit_state.g.load_game_flag == 0,
                      "original S6310 raw80 consumes the shared captured owner and really closes popup/resources before return");
            }
        }
        returned = f.app.current_scene_id == 3308;
    }
    CHECK(hangup_seen && raw80_completed && returned && f.app.new_game.scene_visits[3337u] == 2u &&
          f.app.new_game.scene_visits[3308u] == 1u && !f.app.phone.active &&
          !f.app.phone_base_surface && !f.app.phone_extras_surface,
          "genuine fresh-world farewell returns through S6310/raw80 to S3337 visit2 and naturally reaches original S3308");
    LiveAudioChannelInfo released{};
    CHECK(live_audio_get_channel_info(f.app.live_audio, 12u, &released) == LIVE_AUDIO_OK && !released.loaded &&
          !f.app.a3f_caption.ready && !f.app.a3f_caption.active[0] && !f.app.a3f_caption.active[1],
          "real conversation voice and response surfaces retire after the automatic fresh-world return");
    std::printf("FORCED_PHONE_FLOW direct_entry=3337 initial_voice_frames=%llu pickup_frames=%llu greeting_frames=%llu fresh_farewell_row=6 target_chain=1600,6310,3337,3308 raw80_return=1 cleanup=1 hook6_topics_unverified=1 muted_frames=%llu\n",
        static_cast<unsigned long long>(f.initial_voice_frames), static_cast<unsigned long long>(f.pickup_frames),
        static_cast<unsigned long long>(greeting.source_frames), static_cast<unsigned long long>(f.muted_frames));
    return 0;
}
#endif

int main(int argc, char **argv)
{
    @autoreleasepool {
        CHECK(argc == 3, "owner-local game directory and bounded forced-phone case required");
        PhoneFixture fixture;
        const bool initialized = fixture.initialize(argv[1]);
        if (!initialized) fixture.print_log_tail();
        CHECK(initialized, "actual BOOT/new-game and labeled FIRST S3337 component initialize");
#ifdef NATIVE_FORCED_PHONE_BASELINE
        const int result = initial_request(fixture); /* Frozen app has no new phone fields; same real failure seam. */
#else
        int result = 1;
        if (std::strcmp(argv[2], "frame") == 0) result = frames(fixture);
        else if (std::strcmp(argv[2], "flow") == 0) result = flow(fixture);
        else if (std::strcmp(argv[2], "request-guard") == 0) result = taskbar_request_guard(fixture);
        else std::fprintf(stderr, "CHECK failed: unknown bounded forced-phone case\n");
#endif
        if (result) fixture.print_log_tail();
        return result;
    }
}
