/* NATIVE-12: actual BOOT/new-game, S1800 and app conversation providers.
 * S1800 is a component, not a full story-route claim. The refusal case uses
 * actual S1807 row0 with its executor's untouched fresh state.
 * No story/inventory/phase injection, oracle, window or output device. */
#define main blackmoor_app_entry_for_conversation_caption_test
#ifndef NATIVE_CONVERSATION_APP_SOURCE
#define NATIVE_CONVERSATION_APP_SOURCE "../src/blackmoor_app.mm"
#endif
#include NATIVE_CONVERSATION_APP_SOURCE
#undef main
#include "../src/action_family_3f.h"
#include <csignal>

#define CHECK(condition, message) do { if (!(condition)) { \
    std::fprintf(stderr, "CHECK failed: %s\n", message); return 1; } } while (0)

struct ConversationFixture {
    NativeApp app;
    uint32_t now = 1000;
    uint64_t muted_frames = 0;
    AutoText *expected_convo = nullptr;
    ~ConversationFixture() { autotext_close(expected_convo); cleanup(&app); }

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
    bool initialize(const char *directory, int16_t scene_id = 1800)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"BlackmoorAudioMuted"];
        app.game_directory = directory;
        app.log = std::tmpfile();
        app.bar_missing = true; /* Taskbar interaction is outside this component. */
        app.scene_runtime_enabled = true;
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
        GameResourceBytes convo = GAME_RESOURCE_BYTES_INIT;
        if (!game_resources_load_bytes(app.resources, "CONVO", &convo, error, sizeof(error))) return false;
        const int text_status = autotext_open_memory(convo.bytes, convo.length, 0, &expected_convo, error, sizeof(error));
        game_resource_bytes_destroy(&convo);
        if (text_status != AUTOTEXT_OK || autotext_entry_count(expected_convo) != 1244u) return false;
        LiveAudioConfig audio{};
        audio.game_directory = directory; audio.mode = MAC_AUDIO_MODE_OFFLINE;
        if (live_audio_create(&audio, &app.live_audio, error, sizeof(error)) != LIVE_AUDIO_OK) {
            std::fprintf(stderr, "conversation offline audio: %s\n", error);
            return false;
        }
        app.framebuffer.resize(640u * 480u * 4u);
        if (!load_scene(&app, scene_id)) return false;
        const ActionFamily28Rect view = {app.scene_destination.left, app.scene_destination.top,
                                         app.scene_destination.right, app.scene_destination.bottom};
        return session_exit_init(&app.exit_state, &view) == SESSION_EXIT_OK && create_native_scene_session(&app);
    }
    bool tick()
    {
        update(&app, ++now);
        if (app.failure || app.session_block_reported) { print_log_tail(); return false; }
        return true;
    }
    bool render_audio()
    {
        LiveAudioOfflineStats stats{};
        if (live_audio_advance_offline(app.live_audio, 4096u, &stats, nullptr, 0u) != LIVE_AUDIO_OK ||
            stats.frames != 4096u || stats.nonfinite_samples != 0u || stats.nonzero_samples != 0u) return false;
        muted_frames += stats.frames;
        return true;
    }
    bool row9(SceneActionRuntimeState *state) const
    { return scene_session_get_action_state(app.session, 9u, state) == SCENE_SESSION_OK; }
};

/* Expectations use the owned FONT record and sheet directly. The source
 * recovery fixes the first B of TTP00a at local left10/baseline15, color1,
 * FONT8 normal / FONT9 hilite. This does not call the candidate text writer
 * to calculate expected positions or pixels. No resource pixels are stored. */
static bool first_glyph_matches(ConversationFixture &f, unsigned variant, size_t *ink_out)
{
    const int font = variant == 0u ? 8 : 9;
    const uint8_t *record = f.app.captions.fonts.records[font];
    const unsigned upper = static_cast<unsigned>(record[0x53u] | (record[0x54u] << 8));
    const unsigned glyph = upper + static_cast<unsigned>('B' - 'A');
    if (glyph >= CAPTION_FONT_GLYPHS) return false;
    const size_t rect = 0xc3u + glyph * 16u;
    const int32_t sx = read_i32_le(record + rect) + read_i32_le(record + 0x47u);
    const int32_t sy = read_i32_le(record + rect + 4u) + read_i32_le(record + 0x4bu);
    const int32_t width = read_i32_le(record + rect + 8u) - read_i32_le(record + rect) + 1;
    const int32_t height = read_i32_le(record + rect + 12u) - read_i32_le(record + rect + 4u) + 1;
    const int32_t dy = 16 - height;
    const CaptionSurface &dst = f.app.a3f_caption.surface[variant];
    NativeRaw555Image *sheet = load_native_raw555_image(&f.app, reinterpret_cast<const char *>(record));
    if (sheet == nullptr || sx < 0 || sy < 0 || width <= 0 || height <= 0 ||
        sx + width > static_cast<int32_t>(sheet->width) || sy + height > static_cast<int32_t>(sheet->height) ||
        dst.pixels == nullptr || dst.width != 578 || dst.height != 1001 || dst.pitch != 1156 ||
        dy < 0 || dy + height > 81 || 10 + width > 578) return false;
    size_t ink = 0;
    for (int32_t y = 0; y < height; ++y) for (int32_t x = 0; x < width; ++x) {
        const uint8_t *source = sheet->pixels.data() + static_cast<size_t>(sy + y) * sheet->pitch + static_cast<size_t>(sx + x) * 2u;
        const uint16_t word = static_cast<uint16_t>(source[0] | (source[1] << 8));
        const uint8_t *actual = dst.pixels + static_cast<size_t>(dy + y) * static_cast<size_t>(dst.pitch) + static_cast<size_t>(10 + x) * 2u;
        const uint16_t wanted = word == f.app.captions.pixel_format.color_key ? 0u : word;
        if (static_cast<uint16_t>(actual[0] | (actual[1] << 8)) != wanted) return false;
        if (word == f.app.captions.pixel_format.color_key) continue;
        ++ink;
        if (variant == 0u) {
            /* The caption backbuffer's established RGB555 -> RGBA adapter
             * uses floor scaling. Only non-key glyph pixels are compared. */
            const uint8_t wanted_rgba[4] = {static_cast<uint8_t>(((word >> 10) & 31u) * 255u / 31u),
                static_cast<uint8_t>(((word >> 5) & 31u) * 255u / 31u), static_cast<uint8_t>((word & 31u) * 255u / 31u), 255u};
            const uint8_t *visible = f.app.framebuffer.data() + (static_cast<size_t>(392 + dy + y) * 640u + static_cast<size_t>(61 + x)) * 4u;
            if (std::memcmp(visible, wanted_rgba, sizeof(wanted_rgba)) != 0) return false;
        }
    }
    if (ink_out != nullptr) *ink_out = ink;
    return ink != 0u;
}

static bool caption_region_restored(ConversationFixture &f)
{
    NativeRaw555Image *frame = load_native_raw555_image(&f.app, "Frame");
    if (frame == nullptr || frame->width != 640u || frame->height != 480u) return false;
    for (size_t y = 392u; y <= 472u; ++y) for (size_t x = 51u; x <= 628u; ++x) {
        const uint8_t *source = frame->pixels.data() + y * frame->pitch + x * 2u;
        const uint16_t word = static_cast<uint16_t>(source[0] | (source[1] << 8));
        const uint8_t wanted[4] = {static_cast<uint8_t>(((word >> 10) & 31u) * 255u / 31u),
            static_cast<uint8_t>(((word >> 5) & 31u) * 255u / 31u), static_cast<uint8_t>((word & 31u) * 255u / 31u), 255u};
        if (std::memcmp(f.app.framebuffer.data() + (y * 640u + x) * 4u, wanted, sizeof(wanted)) != 0) return false;
    }
    return true;
}

static int caption_start(ConversationFixture &f)
{
    CHECK(f.app.closed_captioning == 1u && f.app.world_clock_session.captions_enabled_5bb202 == 1,
          "real Game.ini enables conversation captions");
    SceneActionInfo action{};
    ActionFamily3fDecoded decoded{};
    CHECK(scene_resource_action_at(f.app.scene, 9u, &action) == SCENE_RESOURCE_OK &&
          action.type == SESSION_A3F_TYPE && action_family_3f_decode(action.raw_body, action.raw_body_length, &decoded) == ACTION_FAMILY_3F_OK &&
          decoded.primary_count == 0 && std::strcmp(reinterpret_cast<const char *>(decoded.name), "TTP00a") == 0,
          "actual S1800 row9 is the zero-response TTP00a conversation");
    CHECK(f.tick(), "fresh S1800 row9 starts with real enabled captions instead of freezing at missing callbacks");
    SceneActionRuntimeState state{};
    CHECK(scene_session_get_action_state(f.app.session, 9u, &state) == SCENE_SESSION_OK && state.phase == 1u && state.completed == 0u &&
          session_a3f_modal_active(f.app.a3f) != 0 && session_a3f_manager(f.app.a3f)->row == 9,
          "fresh flags naturally select row9 and leave the real kernel running in phase1");
    const uint8_t *expected = nullptr;
    size_t raw = 0, length = 0;
    CHECK(autotext_lookup(f.expected_convo, decoded.text_key, std::strlen(reinterpret_cast<const char *>(decoded.text_key)),
                          &expected, &raw, &length) == AUTOTEXT_OK && length > 0u,
          "the actual row key resolves in the independent CONVO TEXT/CVTX table");
    const uint8_t *image = session_a3f_image(f.app.a3f, 9u);
    CHECK(f.app.a3f_text != nullptr && autotext_entry_count(f.app.a3f_text) == 1244u && image != nullptr &&
          std::strlen(reinterpret_cast<const char *>(image + C3F_CAPTION)) == length &&
          std::memcmp(image + C3F_CAPTION, expected, length) == 0 &&
          std::strncmp(reinterpret_cast<const char *>(image + C3F_CAPTION), "Missing closed captioning", 24u) != 0,
          "the app resolves the unique real CONVO caption rather than the missing-key fallback");
    CHECK(f.app.a3f_caption.active[0] && f.app.a3f_caption.active[1] && f.app.a3f_caption.ready &&
          f.app.a3f_caption.row == 9 && f.app.a3f_caption.result.glyphs[0] > 0u && f.app.a3f_caption.result.glyphs[1] > 0u,
          "the real binding owns and publishes both original font surfaces");
    size_t normal_ink = 0, hilite_ink = 0;
    CHECK(first_glyph_matches(f, 0u, &normal_ink) && first_glyph_matches(f, 1u, &hilite_ink),
          "normal FONT8 is visibly composed at the original position and FONT9 hilite has exact original glyph pixels");
    std::printf("CONVO_START scene=1800 row=9 sound=TTP00a captions=1 phase=1 responses=0 text_bytes=%zu normal_ink=%zu hilite_ink=%zu\n",
                length, normal_ink, hilite_ink);
    return 0;
}

static int sound_completion(ConversationFixture &f)
{
    CHECK(f.tick(), "actual caption line starts");
    LiveAudioChannelInfo sound{};
    int busy = 0;
    CHECK(live_audio_get_channel_info(f.app.live_audio, 12, &sound) == LIVE_AUDIO_OK && sound.loaded == 1u &&
          sound.started == 1u && sound.frame_count > 0u &&
          live_audio_is_playing(f.app.live_audio, 12, &busy) == ACTION_SOUND_BACKEND_OK && busy == 1,
          "real TTP00a starts on channel12");
    const auto flags_before = f.app.new_game.event_flags;
    for (unsigned i = 0; i < 3u; ++i) {
        SceneActionRuntimeState state{};
        CHECK(f.tick() && f.row9(&state) && state.phase == 1u && state.completed == 0u &&
              session_a3f_manager(f.app.a3f)->sub_state == 4u && f.app.new_game.event_flags == flags_before &&
              f.app.a3f_caption.ready && f.app.a3f_caption.active[0] && f.app.a3f_caption.active[1],
              "busy real sound cannot prematurely finish or release the caption");
    }
    for (unsigned i = 0; busy != 0 && i < 800u; ++i) {
        CHECK(f.render_audio(), "real speech renders only finite allzero post-master PCM");
        CHECK(live_audio_is_playing(f.app.live_audio, 12, &busy) == ACTION_SOUND_BACKEND_OK, "real sound busy query succeeds");
    }
    CHECK(busy == 0 && f.muted_frames >= sound.frame_count, "TTP00a reaches its genuine rendered completion");
    SceneActionRuntimeState state{};
    CHECK(f.tick() && f.row9(&state) && state.phase == 1u && state.completed == 0u &&
          session_a3f_manager(f.app.a3f)->sub_state == 5u, "natural idle advances running substate4 to5 without completing the row");
    CHECK(f.tick() && f.row9(&state) && state.phase == 2u && state.completed == 0u,
          "the stop-first-sound visit enters phase2 before the finish visit");
    CHECK(f.tick() && f.row9(&state) && state.phase == 0u && state.completed == 1u &&
          session_a3f_image(f.app.a3f, 9u) == nullptr && session_a3f_modal_active(f.app.a3f) == 0,
          "phase2 naturally completes and releases the actual conversation object");
    SceneTransitionRequest transition{};
    CHECK(scene_session_get_pending_transition(f.app.session, &transition) != 0 && transition.target_scene == 1810 &&
          transition.opaque_words[0] == 0 && transition.opaque_words[1] == 0 && transition.opaque_words[2] == 1 &&
          transition.opaque_dwords[0] == 0 && transition.opaque_dwords[1] == 0 && transition.opaque_dwords[2] == 1,
          "the real default transition tuple survives the caption adapter");
    CHECK(!f.app.a3f_caption.ready && !f.app.a3f_caption.active[0] && !f.app.a3f_caption.active[1] &&
          f.app.a3f_caption.pixels[0].empty() && f.app.a3f_caption.pixels[1].empty() &&
          session_a3f_manager(f.app.a3f)->textbox_slot[0] == -1 && session_a3f_manager(f.app.a3f)->textbox_slot[1] == -1 &&
          f.app.new_game.event_flags == flags_before && caption_region_restored(f),
          "zero-secondary row9 releases both surfaces without unrelated flag effects");
    std::printf("CONVO_SOUND channel=12 busy_gate=1 phases=1,1,2,0 target=1810 muted_frames=%llu released=2\n",
                static_cast<unsigned long long>(f.muted_frames));
    return 0;
}

static int reset_reentry(ConversationFixture &f)
{
    CHECK(f.tick() && f.app.a3f_caption.ready, "real caption is active before scene replacement");
    const auto flags_before = f.app.new_game.event_flags;
    for (int target : {2098, 1800}) {
        SceneTransitionRequest transition{};
        transition.target_scene = static_cast<int16_t>(target);
        CHECK(scene_session_request_external_transition(f.app.session, &transition) == SCENE_SESSION_OK,
              "component scene replacement enters the real external-transition path");
        for (unsigned i = 0; f.app.current_scene_id != target && i < 8u; ++i)
            CHECK(f.tick(), "real exit/load states replace the component scene");
        CHECK(f.app.current_scene_id == target && !f.app.a3f_caption.ready &&
              !f.app.a3f_caption.active[0] && !f.app.a3f_caption.active[1] &&
              f.app.a3f_caption.pixels[0].empty() && f.app.a3f_caption.pixels[1].empty() && caption_region_restored(f),
              "scene replacement releases both active caption surfaces before target ACT execution");
    }
    for (unsigned i = 0; !f.app.a3f_caption.ready && i < 3u; ++i)
        CHECK(f.tick(), "normal scene intro and dispatcher permit caption re-entry");
    SceneActionRuntimeState state{};
    CHECK(f.row9(&state) && state.phase == 1u && state.completed == 0u && f.app.a3f_caption.ready &&
          f.app.a3f_caption.active[0] && f.app.a3f_caption.active[1] && f.app.new_game.event_flags == flags_before &&
          first_glyph_matches(f, 0u, nullptr) && first_glyph_matches(f, 1u, nullptr),
          "returning to S1800 rebuilds clean original glyph surfaces through natural row9 eligibility");
    std::printf("CONVO_REENTRY via=2098 active_cleanup=2 rebuilt=2 flags_unchanged=1\n");
    return 0;
}

static int unsupported_responses(ConversationFixture &f)
{
    SceneActionInfo action{};
    ActionFamily3fDecoded decoded{};
    SceneActionRuntimeState before{}, after{};
    CHECK(f.app.current_scene_id == 1807 && scene_resource_action_at(f.app.scene, 0u, &action) == SCENE_RESOURCE_OK &&
          action.type == SESSION_A3F_TYPE && action_family_3f_decode(action.raw_body, action.raw_body_length, &decoded) == ACTION_FAMILY_3F_OK &&
          decoded.primary_count == 6 && decoded.option_44 == CONVO3F_NO_HOOK && decoded.option_45 == CONVO3F_NO_HOOK &&
          scene_session_get_action_state(f.app.session, 0u, &before) == SCENE_SESSION_OK && before.phase == 0u && before.completed == 0u,
          "actual S1807 row0 has six primary responses and its natural fresh phase0");
    const auto flags_before = f.app.new_game.event_flags;
    const auto inventory_before = f.app.new_game.inventory_presence;
    const auto framebuffer_before = f.app.framebuffer;
    SceneActionHandlerResult result{};
    CHECK(native_a3f_handler(&f.app, 0u, &action, &before, &result) == SCENE_ACTION_HANDLER_UNSUPPORTED,
          "the real app explicitly refuses the original primary-response row before kernel effects");
    LiveAudioChannelInfo sound{};
    SceneTransitionRequest transition{};
    CHECK(scene_session_get_action_state(f.app.session, 0u, &after) == SCENE_SESSION_OK &&
          after.phase == before.phase && after.completed == before.completed && session_a3f_last_result(f.app.a3f) == nullptr &&
          session_a3f_modal_active(f.app.a3f) == 0 && session_a3f_manager(f.app.a3f)->row == -1 &&
          !f.app.a3f_caption.ready && !f.app.a3f_caption.active[0] && !f.app.a3f_caption.active[1] &&
          f.app.a3f_caption.pixels[0].empty() && f.app.a3f_caption.pixels[1].empty() &&
          live_audio_get_channel_info(f.app.live_audio, 12, &sound) == LIVE_AUDIO_OK && sound.loaded == 0u && sound.started == 0u &&
          scene_session_get_pending_transition(f.app.session, &transition) == 0 && f.app.framebuffer == framebuffer_before &&
          f.app.new_game.event_flags == flags_before && f.app.new_game.inventory_presence == inventory_before &&
          *f.app.new_game.view.inventory.selected_item_candidate == -1,
          "unsupported responses leave no sound, surfaces, modal state, phase, transition, inventory or visible effects");
    std::printf("CONVO_UNSUPPORTED scene=1807 row=0 primary=6 phase=0 kernel_visits=0 effects=0\n");
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
        if (argc != 4 || std::strcmp(argv[1], "--conversation-component") != 0) return 2;
        ConversationFixture fixture;
        const bool unsupported = std::strcmp(argv[3], "unsupported") == 0;
        if (!fixture.initialize(argv[2], unsupported ? 1807 : 1800)) { fixture.print_log_tail(); CHECK(false, "actual BOOT/new-game/scene component initializes"); }
        if (std::strcmp(argv[3], "start") == 0) return caption_start(fixture);
        if (std::strcmp(argv[3], "sound") == 0) return sound_completion(fixture);
        if (std::strcmp(argv[3], "reset") == 0) return reset_reentry(fixture);
        if (unsupported) return unsupported_responses(fixture);
        return 2;
    }
}
