/* NATIVE23: actual S3510 secondary AVF app component with silent offline audio.
 * Direct scene entry only; no campaign route, story/phase/clock injection,
 * window, output device or original-x86 execution. */
#define main blackmoor_app_entry_for_secondary_test
#ifndef NATIVE_SECONDARY_APP_SOURCE
#define NATIVE_SECONDARY_APP_SOURCE "../src/blackmoor_app.mm"
#endif
#include NATIVE_SECONDARY_APP_SOURCE
#undef main
#include <csignal>

#define CHECK(condition, message) do { if (!(condition)) { \
    std::fprintf(stderr, "CHECK failed: %s\n", message); return 1; } } while (0)

struct SecondaryFixture {
    NativeApp app{};
    uint32_t now = 1000u;
    uint64_t muted_frames = 0u;
    ~SecondaryFixture() { cleanup(&app); }
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
    bool logged(const char *message)
    {
        if (app.log == nullptr) return false;
        std::fflush(app.log); std::rewind(app.log);
        bool found = false;
        char line[1024]{};
        while (std::fgets(line, sizeof line, app.log) != nullptr)
            found = found || std::strstr(line, message) != nullptr;
        return found;
    }
    bool initialize(const char *directory, int selector)
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
            !load_viewport(&app) || !initialize_caption_runtime(&app) || !initialize_new_game(&app, now) || !clear_before_scene_entry(&app, now)) return false;
        LiveAudioConfig audio{};
        audio.game_directory = directory;
        audio.mode = MAC_AUDIO_MODE_OFFLINE;
        if (live_audio_create(&audio, &app.live_audio, error, sizeof error) != LIVE_AUDIO_OK) {
            std::fprintf(stderr, "Secondary offline audio initialization: %s\n", error);
            return false;
        }
        app.offline_audio_frames_per_update = 1u;
        app.framebuffer.resize(640u * 480u * 4u);
        app.selector_entry_valid = true;
        app.selector_entry_frame = selector; /* Labeled normal entry configuration. */
        app.selector_entry_scroll = 0;
        if (!load_scene(&app, 3510)) return false;
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
    bool tick_ms(uint32_t milliseconds)
    {
        uint32_t rate = 0u, channels = 0u;
        return live_audio_offline_format(app.live_audio, &rate, &channels) == LIVE_AUDIO_OK && rate != 0u &&
            tick((static_cast<uint64_t>(rate) * milliseconds + 999u) / 1000u);
    }
};

static int actual_secondary_start(SecondaryFixture &fixture)
{
    const A33State *before=session_a33_state(fixture.app.a33);
    CHECK(before && !before->active_5c39f1 && !before->surface_5d03bf && !before->thread_5b4e0c,
          "secondary controller has no fabricated ready/media state before its actual first visit");
    CHECK(fixture.tick(), "actual S3510 row6 must initialize its real native secondary AVF backend");
    const A33State *state=session_a33_state(fixture.app.a33);
    CHECK(state && state->active_5c39f1 && state->row_5b4e89==6 && state->surface_5d03bf && state->thread_5b4e0c,
          "actual row6 owns real secondary stream, surface and reader after phase0");
    CHECK(state->delay_5b4c5a == 66 && state->ready_5b4e0a == 0 && state->state_5b4e10 == 0 &&
          state->frame_5b4e00 == 0 && state->vrect_5b4df0 == 104 && state->vrect_5b4df4 == 108 &&
          state->buf_5b4db8 != 0 && state->buf_5b4dbc != 0 && state->buf_5b4db8 != state->buf_5b4dbc,
          "actual AVF publishes105x109 dimensions,66ms period and two buffers before first ready");
    CHECK(fixture.tick(), "next ordinary media pass decodes original JAN frame0");
    state = session_a33_state(fixture.app.a33);
    NativeSecondaryVideoFrame frame{};
    CHECK(state->state_5b4e10 == 4 && state->frame_5b4e00 == 1 && state->ready_5b4e0a == 0 &&
          state->latch_5d1967 && native_secondary_video_frame(fixture.app.a33_media, state->surface_5d195b, &frame) == 0 &&
          frame.frame_index == 0 && frame.width == 105u && frame.height == 109u && frame.pitch == 210u && frame.bytes == 22890u,
          "original ready acknowledgement flips actual frame0 before requesting frame1");
    std::printf("SECONDARY_START scene=3510 row=6 selector=%d direct_component_entry=1\n",fixture.app.nav.selector);
    return 0;
}

static uint64_t secondary_hash(const uint8_t *pixels, size_t bytes)
{
    uint64_t hash = UINT64_C(1469598103934665603);
    for (size_t i = 0u; i < bytes; ++i) hash = (hash ^ pixels[i]) * UINT64_C(1099511628211);
    return hash;
}

static int actual_composition(SecondaryFixture &fixture, bool cropped)
{
    NativeApp &app = fixture.app;
    const A33State *state = session_a33_state(app.a33);
    NativeSecondaryVideoFrame frame{};
    CHECK(native_secondary_video_frame(app.a33_media, state->surface_5d195b, &frame) == 0,
          "live app surface borrows the actual decoded raw555 frame");
    std::printf("SECONDARY_RECT selector=%d clip=%d,%d,%d,%d src=%d,%d,%d,%d dst=%d,%d,%d,%d\n",
        app.nav.selector, state->clip_5bb583[0], state->clip_5bb583[1], state->clip_5bb583[2], state->clip_5bb583[3],
        state->src1_5b4e18[0], state->src1_5b4e18[1], state->src1_5b4e18[2], state->src1_5b4e18[3],
        state->dst1_5b4e28[0], state->dst1_5b4e28[1], state->dst1_5b4e28[2], state->dst1_5b4e28[3]);
    const int32_t expected_source[4] = {cropped ? 66 : 0, 0, 104, 108};
    const int32_t expected_destination[4] = {cropped ? 10 : 270, cropped ? 184 : 189,
                                            cropped ? 48 : 374, cropped ? 292 : 297};
    CHECK(std::memcmp(state->src1_5b4e18, expected_source, sizeof expected_source) == 0 &&
          std::memcmp(state->dst1_5b4e28, expected_destination, sizeof expected_destination) == 0,
          "actual original selector2 crop or selector4 full-frame rectangle reaches the app compositor");
    CHECK(state->dst1_5b4e28[2] - state->dst1_5b4e28[0] == state->src1_5b4e18[2] - state->src1_5b4e18[0] &&
          state->dst1_5b4e28[3] - state->dst1_5b4e28[1] == state->src1_5b4e18[3] - state->src1_5b4e18[1],
          "recovered cropped source and screen destination have the same inclusive extent");
    std::vector<uint8_t> converted(frame.pixels, frame.pixels + frame.bytes);
    cif_pixel_format format{}; format.enabled = 1;
    for (size_t channel = 0u; channel < 3u; ++channel) {
        format.shifts[channel] = app.captions.pixel_format.shifts[channel];
        format.channel_bits[channel] = static_cast<int8_t>(app.captions.pixel_format.channel_bits[channel]);
    }
    cif_pixels_convert_555(converted.data(), static_cast<uint32_t>(converted.size()), &format);
    size_t opaque = 0u, keyed = 0u;
    for (int32_t y = state->dst1_5b4e28[1]; y <= state->dst1_5b4e28[3]; ++y) {
        for (int32_t x = state->dst1_5b4e28[0]; x <= state->dst1_5b4e28[2]; ++x) {
            const int32_t sx = state->src1_5b4e18[0] + x - state->dst1_5b4e28[0];
            const int32_t sy = state->src1_5b4e18[1] + y - state->dst1_5b4e28[1];
            CHECK(x >= 0 && x < 640 && y >= 0 && y < 480 && sx >= 0 && sx < 105 && sy >= 0 && sy < 109,
                  "every actual cropped pixel stays inside source and destination storage");
            const size_t source = static_cast<size_t>(sy) * frame.pitch + static_cast<size_t>(sx) * 2u;
            const size_t destination = static_cast<size_t>(y) * 1280u + static_cast<size_t>(x) * 2u;
            const uint16_t word = static_cast<uint16_t>(converted[source] | (converted[source + 1u] << 8));
            const uint8_t *expected = converted.data() + source;
            if (word == app.captions.pixel_format.color_key) { expected = app.a33_background.data() + destination; ++keyed; }
            else ++opaque;
            CHECK(std::memcmp(expected, app.captions.backbuffer_pixels.data() + destination, 2u) == 0,
                  "actual slot13 render restores background under key pixels and composites the cropped AVF pixels");
        }
    }
    CHECK(opaque > 0u && keyed > 0u, "real JAN crop contains both visible and transparent pixels");
    std::printf("SECONDARY_COMPOSITION selector=%d src=%d,%d,%d,%d dst=%d,%d,%d,%d opaque=%zu keyed=%zu\n",
        app.nav.selector, state->src1_5b4e18[0], state->src1_5b4e18[1], state->src1_5b4e18[2], state->src1_5b4e18[3],
        state->dst1_5b4e28[0], state->dst1_5b4e28[1], state->dst1_5b4e28[2], state->dst1_5b4e28[3], opaque, keyed);
    return 0;
}

static int secondary_pointer(SecondaryFixture &fixture, BlackmoorPointerKind kind, uint32_t milliseconds = 0u)
{
    SessionInputHotspot hotspot{};
    CHECK(session_a33_pointer_row(fixture.app.a33, 6u, &hotspot) == 1,
          "actual row6 publishes its original request rectangle");
    const int32_t left = std::max<int32_t>(hotspot.rectangle.left, 0);
    const int32_t right = std::min<int32_t>(hotspot.rectangle.right,
        fixture.app.scene_destination.right - fixture.app.scene_destination.left);
    const int32_t top = std::max<int32_t>(hotspot.rectangle.top, fixture.app.nav.scroll);
    const int32_t bottom = std::min<int32_t>(hotspot.rectangle.bottom, fixture.app.nav.scroll +
        fixture.app.scene_destination.bottom - fixture.app.scene_destination.top);
    CHECK(left <= right && top <= bottom, "original secondary request has a visible pointer target");
    const int32_t x = (left + right) / 2 +
        fixture.app.scene_destination.left - fixture.app.cursor_provider.hot_x;
    const int32_t y = (top + bottom) / 2 +
        fixture.app.scene_destination.top - fixture.app.nav.scroll - fixture.app.cursor_provider.hot_y;
    pointer(&fixture.app, kind, x, y, 0u);
    CHECK(milliseconds ? fixture.tick_ms(milliseconds) : fixture.tick(),
          "actual pointer event advances through the app input/session boundary");
    return 0;
}

static int actual_period_hover_and_greeting(SecondaryFixture &fixture)
{
    CHECK(actual_secondary_start(fixture) == 0 && actual_composition(fixture, true) == 0,
          "actual selector2 AVF starts and composites its original crop");
    NativeApp &app = fixture.app;
    const A33State *state = session_a33_state(app.a33);
    NativeSecondaryVideoFrame visible{}, next{};
    CHECK(native_secondary_video_frame(app.a33_media, state->surface_5d195b, &visible) == 0 &&
          secondary_hash(visible.pixels, visible.bytes) == UINT64_C(0xa1f8333e796b9594),
          "actual app frame0 matches independently expanded immutable JAN pixels");
    const std::vector<uint8_t> snapshot(visible.pixels, visible.pixels + visible.bytes);
    CHECK(fixture.tick(), "ordinary reader prefetches frame1 into the hidden slot before the deadline");
    CHECK(state->ready_5b4e0a == 1 && native_secondary_video_frame(app.a33_media, state->surface_5d195b, &next) == 0 &&
          next.generation == visible.generation && next.pixels == visible.pixels &&
          std::memcmp(snapshot.data(), visible.pixels, visible.bytes) == 0,
          "hidden decode leaves the visible borrow stable while real readiness waits");
    CHECK(fixture.tick_ms(65u), "real offline time advances to one millisecond before frame deadline");
    CHECK(native_secondary_video_frame(app.a33_media, state->surface_5d195b, &next) == 0 &&
          next.generation == visible.generation && state->ready_5b4e0a == 1,
          "66ms frame period prevents early presentation");
    unsigned frames_seen = 1u;
    for (int expected = 1; expected <= 3; ++expected) {
        CHECK(fixture.tick_ms(expected == 1 ? 1u : 66u), "ordinary time and reader handshake advance the initial idle frames");
        CHECK(native_secondary_video_frame(app.a33_media, state->surface_5d195b, &next) == 0,
              "actual idle surface remains readable");
        CHECK(next.frame_index == expected && next.generation == visible.generation + 1u &&
              state->frame_5b4e00 == expected + 1 && state->anim_5b4e14 == 0,
              "actual idle displays original frames0..3 in order at66ms");
        visible = next; ++frames_seen;
    }
    CHECK(secondary_pointer(fixture, BLACKMOOR_POINTER_MOVE) == 0 && app.input_state.candidate == -1 &&
          app.nav.state == NAV_STATE_SELECTOR_PLUS && app.nav_cursor.index == 14,
          "original navigation band wins over the cropped actor's midpoint before the generic row scan");
    CHECK(fixture.tick() && app.nav.selector == 3 && state->selector_5bb50b == 3,
          "ordinary following navigation tick turns from selector2 to selector3 without selector injection");
    /* Hover at the next real deadline: the previously prepared idle frame
     * retires before the scan writes46, so the following reader pass can
     * decode46. Hover between deadlines may validly retain an older ready
     * idle frame until its next flip. No ready/page state is changed here. */
    CHECK(secondary_pointer(fixture, BLACKMOOR_POINTER_MOVE, 66u) == 0 && app.input_state.candidate == 6 &&
          app.nav_cursor.index == 3 && app.nav_cursor.variant == 1 && state->anim_5b4e14 == 1 && state->frame_5b4e00 == 46,
          "real selector3 winning row6 hover selects cursor3/1 and starts original hover frame46");
    bool hover_frame = false;
    for (unsigned i = 0u; i < 4u && !hover_frame; ++i) {
        CHECK(fixture.tick_ms(66u), "real hover frame is decoded and presented through the ordinary handshake");
        CHECK(native_secondary_video_frame(app.a33_media, state->surface_5d195b, &next) == 0,
              "live secondary surface remains available during hover");
        hover_frame = next.frame_index == 46;
    }
    CHECK(hover_frame, "actual hover presents JAN frame46");
    pointer(&app, BLACKMOOR_POINTER_MOVE, 0, 0, 0u);
    CHECK(fixture.tick() && app.input_state.candidate == -1, "real pointer move off scene clears the canonical candidate");
    bool reverse_seen = false, reverse_frame_seen = false;
    int16_t previous = next.frame_index;
    for (unsigned i = 0u; i < 4u && !reverse_frame_seen; ++i) {
        CHECK(fixture.tick_ms(66u), "unhover advances the original reverse range before the automatic greeting transition");
        CHECK(native_secondary_video_frame(app.a33_media, state->surface_5d195b, &next) == 0,
              "secondary pixels remain owned while the reverse controller is live");
        reverse_seen = reverse_seen || state->anim_5b4e14 == 2;
        reverse_frame_seen = reverse_seen && next.frame_index < previous;
        previous = next.frame_index;
    }
    CHECK(reverse_frame_seen && app.current_scene_id == 3510,
          "unhover naturally enters reverse mode and presents a descending frame before the greeting ends");
    /* Fresh direct-entry story state runs original sound row8's greeting.
     * Its real completion leaves S3510 before a full45->0 wrap or reverse
     * return to0. Do not suppress it or claim those app branches here. */
    for (unsigned i = 0u; i < 24u && app.current_scene_id != 1200; ++i)
        CHECK(fixture.tick_ms(66u), "real greeting completion and normal exit/load proceed without a pointer activation");
    CHECK(app.current_scene_id == 1200 && app.last_art_scene_id == 1200 &&
          fixture.logged("scene_action_sound_transition row=8 target=1200") &&
          !fixture.logged("scene_a33_transition target=1200"),
          "fresh direct-entry's actual sound row8 loads S1200 normally before an entire secondary idle loop");
    std::printf("SECONDARY_GREETING entry_selector=2 displayed_idle=%u period_ms=66 idle_range=0..3 ordinary_turn=3 hover=46 reverse_observed=1 auto_row=8 target=1200 app_wrap_unverified=1 muted_frames=%llu\n",
        frames_seen, static_cast<unsigned long long>(fixture.muted_frames));
    return 0;
}

static int actual_click_to_jane(SecondaryFixture &fixture)
{
    CHECK(actual_secondary_start(fixture) == 0 && actual_composition(fixture, false) == 0,
          "actual selector4 AVF starts before pointer activation");
    NativeApp &app = fixture.app;
    const A33State *state = session_a33_state(app.a33);
    const uint32_t surface = state->surface_5d195b, thread = state->thread_5b4e0c;
    const uint32_t buffer0 = state->buf_5b4db8, buffer1 = state->buf_5b4dbc;
    CHECK(secondary_pointer(fixture, BLACKMOOR_POINTER_MOVE) == 0 && app.input_state.candidate == 6 &&
          app.nav_cursor.index == 3 && app.nav_cursor.variant == 1,
          "real selector4 hover reaches the original secondary row6 through the first-hit scan");
    CHECK(secondary_pointer(fixture, BLACKMOOR_POINTER_DOWN) == 0 &&
          secondary_pointer(fixture, BLACKMOOR_POINTER_UP) == 0,
          "real primary down/up activates the recovered secondary completion path");
    bool cel_started = false;
    for (unsigned step = 0u; step < 24u && !cel_started; ++step) {
        CHECK(fixture.tick_ms(66u), "normal secondary completion, exit, art load and CEL startup proceed");
        const Convo3fManager *manager = session_a3f_manager(app.a3f);
        LiveAudioPlaybackCursor voice{};
        cel_started = app.current_scene_id == 1200 && manager && manager->row == 6 &&
            manager->type == SESSION_A3E_TYPE && manager->sub_state == 4u && app.cel_reader_running &&
            manager->cel.loaded >= 4 && live_audio_get_playback_cursor(app.live_audio, 12u,
                app.cel_sync_generation, &voice) == LIVE_AUDIO_OK && voice.started && voice.playing;
    }
    if (!cel_started) fixture.print_log_tail();
    CHECK(cel_started && app.last_art_scene_id == 1200 && app.scene != nullptr &&
          app.scene_video_path.find("NO_ART_SCENE") == std::string::npos &&
          fixture.logged("scene_a33_transition target=1200") &&
          !fixture.logged("scene_action_sound_transition row=8 target=1200"),
          "accepted original row6 loads normal S1200 art and starts its real Jane CEL/voice");
    state = session_a33_state(app.a33);
    NativeSecondaryVideoFrame retired{};
    CHECK(!state->active_5c39f1 && state->row_5b4e89 == -1 && !state->latch_5d1967 &&
          state->surface_5d03bf == 0 &&
          native_secondary_video_frame(app.a33_media, surface, &retired) != 0,
          "normal scene clear releases the visible surface and removes the secondary render enable");
    A33State owned{};
    CHECK(native_secondary_video_load_world(app.a33_media, &owned) == 0 &&
          owned.buf_5b4db8 == buffer0 && owned.buf_5b4dbc == buffer1 && state->thread_5b4e0c == thread,
          "original scene clear retains reader/decode storage until next secondary init");
    int ran = -1;
    CHECK(native_secondary_video_reader_pass(app.a33_media, state, &ran) == 0 && ran == 0 && fixture.tick_ms(66u),
          "retired secondary reader stays parked during the next real CEL scene");
    std::printf("SECONDARY_CLICK selector=4 source=3510 row=6 target=1200 normal_art=1 cel_started=1 surface_retired=1 reader_parked=1\n");
    return 0;
}
static void secondary_fixture_signal(int number)
{
    static const char message[]="secondary video fixture/native signal failure\n";
    (void)write(STDERR_FILENO,message,sizeof(message)-1u); _exit(128+number);
}
int main(int argc,char **argv)
{
    std::signal(SIGBUS,secondary_fixture_signal); std::signal(SIGSEGV,secondary_fixture_signal);
    std::signal(SIGABRT,secondary_fixture_signal); std::signal(SIGILL,secondary_fixture_signal);
    @autoreleasepool {
        CHECK(argc==3,"owner-local game directory and component case required");
        const bool loop = std::strcmp(argv[2], "loop") == 0;
        CHECK(loop || std::strcmp(argv[2], "click") == 0, "known bounded actual component case required");
        SecondaryFixture fixture;
        const bool initialized=fixture.initialize(argv[1],loop ? 2 : 4);
        if(!initialized) fixture.print_log_tail();
        CHECK(initialized,"actual BOOT/new-game S3510 direct entry with labeled original selector initializes");
        return loop ? actual_period_hover_and_greeting(fixture) : actual_click_to_jane(fixture);
    }
}
