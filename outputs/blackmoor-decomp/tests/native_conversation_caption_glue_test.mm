/* NATIVE-12: actual BOOT/new-game, S1800 and app conversation providers.
 * S1800 is a component, not a full story-route claim. The preview case uses
 * actual S1807 row0 with its executor's untouched fresh state.
 * No story/inventory/phase injection, oracle, window or output device. */
#define main blackmoor_app_entry_for_conversation_caption_test
#ifndef NATIVE_CONVERSATION_APP_SOURCE
#define NATIVE_CONVERSATION_APP_SOURCE "../src/blackmoor_app.mm"
#endif
#include NATIVE_CONVERSATION_APP_SOURCE
#undef main
#include "../src/action_family_3f.h"
#include "../src/caption_layout_internal.h"
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
    bool initialize(const char *directory, int16_t scene_id = 1800, bool captions_on = true)
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
        /* This is the live user setting, after the real new-game reset.
         * Game.ini, story flags, inventory and row phases remain untouched. */
        if (!captions_on) app.world_clock_session.captions_enabled_5bb202 = 0;
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
        /* Component coverage of the original reset's -1 counter path.
         * Production currently starts at zero; this explicit reset requires
         * an already seeded scene backbuffer. */
        if (!captions_on && caption_scene_reset(&app.captions.lifecycle,
                &app.captions.lifecycle_backend) != CAPTION_LIFECYCLE_OK) return false;
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
    bool saw_coalesced_restore()
    {
        std::fflush(app.log);
        const long position = std::ftell(app.log);
        std::rewind(app.log);
        bool found = false;
        char line[1024]{};
        while (std::fgets(line, sizeof(line), app.log) != nullptr)
            if (std::strstr(line, "scene_a3f_") != nullptr && std::strstr(line, "restore") != nullptr &&
                std::strstr(line, "host_coalesced=1") != nullptr) found = true;
        return std::fseek(app.log, position, SEEK_SET) == 0 && found;
    }
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

static int preview_responses(ConversationFixture &f)
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
    Convo3fManager preview{};
    Convo3fLayoutRequest request{};
    CHECK(session_a3f_preview_layout(f.app.a3f, 0u, &preview, &request) == CONVO3F_OK &&
          request.response_count == 5 && request.responses == preview.responses &&
          native_conversation_choices_validate(&request, 1, &f.app.captions.fonts,
              &f.app.captions.geometry, &f.app.captions.pixel_format) == CAPTION_OK,
          "the UI preview builds five eligible original responses without applying kernel effects");
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
          "response preview leaves no sound, surfaces, modal state, phase, transition, inventory or visible effects");
    std::printf("CONVO_PREVIEW scene=1807 row=0 primary=6 eligible=5 phase=0 kernel_visits=0 effects=0\n");
    return 0;
}

static void geometry_dword(CaptionGeometry *geometry, size_t offset, int32_t value)
{
    const uint32_t bits = static_cast<uint32_t>(value);
    for (size_t byte = 0; byte < 4u; ++byte) geometry->tbox[offset + byte] = static_cast<uint8_t>(bits >> (byte * 8u));
}

static int layout_boundaries(ConversationFixture &f)
{
    CaptionGeometry geometry = f.app.captions.geometry;
    std::vector<uint8_t> pixels[2];
    CaptionSurface surfaces[2]{};
    std::array<int16_t, CAPTION_MAX_FONTS> refs_before{};
    std::copy(std::begin(f.app.captions.writer_globals.sheet_refcount),
              std::end(f.app.captions.writer_globals.sheet_refcount), refs_before.begin());
    for (unsigned pass = 0; pass < 2u; ++pass) {
        pixels[pass].assign(578u * 1001u * 2u, 0x5au);
        surfaces[pass] = {pixels[pass].data(), 578, 1001, 1156};
    }
    int16_t widths[2]{};
    CHECK(caption_internal_text_width(&f.app.captions.fonts, 8, "WWWWWWWWWW", &widths[0]) == CAPTION_OK &&
          caption_internal_text_width(&f.app.captions.fonts, 9, "WWWWWWWWWW", &widths[1]) == CAPTION_OK,
          "original FONT primitive measures the self-authored whole word");
    const int32_t left = 10;
    const int32_t right_pad = 3;
    geometry_dword(&geometry, 0x18u, left + std::max(widths[0], widths[1]) + 1 + right_pad);
    NativeConversationCaptionResult result{};
    static const uint8_t wrap[] = "<i>abc <c1>WWWWWWWWWW<c0><n><o>";
    const int status = native_conversation_caption_write(wrap, sizeof(wrap) - 1u, &f.app.captions.fonts,
        &geometry, &f.app.captions.pixel_format, &f.app.captions.writer_globals,
        &f.app.captions.writer_backend, surfaces, &result);
    std::printf("CONVO_WRAP status=%d normal_glyphs=%u hilite_glyphs=%u bottom=%d,%d\n",
                status, result.glyphs[0], result.glyphs[1], result.bottom[0], result.bottom[1]);
    CHECK(status == CAPTION_OK, "a word that fits a fresh line wraps from a partly occupied line instead of being refused");
    for (unsigned pass = 0; pass < 2u; ++pass) {
        const int h = f.app.captions.fonts.glyph_size[8u + pass][0][1];
        CHECK(result.glyphs[pass] == 13u && result.bottom[pass] == 15 + 2 * (h + h / 9) + 30,
              "mid-line retry preserves all thirteen glyphs and both source-derived full-line advances");
    }
    CHECK(result.scroll_lines == (result.bottom[1] > 80 ? result.bottom[1] - 80 : 1),
          "wrap scroll follows the original viewport bottom80");
    geometry = f.app.captions.geometry;
    auto write = [&](const char *text, NativeConversationCaptionResult *out) {
        return native_conversation_caption_write(reinterpret_cast<const uint8_t *>(text), std::strlen(text),
            &f.app.captions.fonts, &geometry, &f.app.captions.pixel_format, &f.app.captions.writer_globals,
            &f.app.captions.writer_backend, surfaces, out);
    };
    CHECK(write("<i>A<n><w>B<c0><o>", &result) == CAPTION_OK,
          "full newline then half newline is accepted");
    for (unsigned pass = 0; pass < 2u; ++pass) {
        const int h = f.app.captions.fonts.glyph_size[8u + pass][0][1];
        const int advance = h + h / 9;
        CHECK(result.glyphs[pass] == 2u && result.bottom[pass] == 15 + advance + advance / 2 + 30,
              "n/w preserves the independently calculated full and truncated half advances");
    }
    CHECK(write("<i>A<o><e>", &result) == CAPTION_OK && result.glyphs[0] == 0u && result.glyphs[1] == 0u &&
          result.bottom[0] == 45 && result.bottom[1] == 45 && result.scroll_lines == 1,
          "e terminates without flushing buffered text or consuming a pending newline");
    auto refuses_without_effects = [&](const char *text, int expected_status) {
        std::fill(pixels[0].begin(), pixels[0].end(), 0x5au);
        std::fill(pixels[1].begin(), pixels[1].end(), 0xa6u);
        const std::vector<uint8_t> before[2] = {pixels[0], pixels[1]};
        NativeConversationCaptionResult untouched;
        std::memset(&untouched, 0xa5, sizeof(untouched));
        std::array<uint8_t, sizeof(untouched)> result_before{};
        std::memcpy(result_before.data(), &untouched, sizeof(untouched));
        const size_t cached_images = f.app.captions.raw_images.size();
        const int refused = write(text, &untouched);
        return (expected_status < 0 ? refused != CAPTION_OK : refused == expected_status) &&
            pixels[0] == before[0] && pixels[1] == before[1] &&
            std::memcmp(&untouched, result_before.data(), sizeof(untouched)) == 0 &&
            std::equal(refs_before.begin(), refs_before.end(), std::begin(f.app.captions.writer_globals.sheet_refcount)) &&
            f.app.captions.raw_images.size() == cached_images;
    };
    geometry_dword(&geometry, 0x1cu, 55); /* limit45; final45 must reject on >=. */
    CHECK(refuses_without_effects("<i>A<o><e>", CAPTION_ERR_TOO_LONG),
          "final y equal to the original limit refuses before pixels, result, font references or sheet loads change");
    geometry = f.app.captions.geometry;
    CHECK(refuses_without_effects("<i>A<c123456789012345678901234567890><o>", CAPTION_ERR_FORMAT),
          "oversize tag argument refuses before pixels, result or font references change");
    static const uint8_t stray[] = "<i>A><n><o>";
    CHECK(native_conversation_caption_validate(stray, sizeof(stray) - 1u, &f.app.captions.fonts,
          &geometry, &f.app.captions.pixel_format) != CAPTION_OK &&
          refuses_without_effects(reinterpret_cast<const char *>(stray), -1),
          "stray greater-than is explicitly refused during preflight before any visible effects");
    CHECK(std::equal(refs_before.begin(), refs_before.end(), std::begin(f.app.captions.writer_globals.sheet_refcount)),
          "successful boundary writes balance both original font references");
    std::printf("CONVO_BOUNDARIES wrap_glyphs=13 full_half_spacing=1 stop_without_flush=1 preflight_refusals=3 refs_balanced=1\n");
    return 0;
}

static bool popup_border_matches(ConversationFixture &f)
{
    const uint8_t *ui = nullptr;
    size_t length = 0;
    if (!find_boot_payload(&f.app, "UICO", &ui, &length) || length < 0x57u) return false;
    char name[34]{};
    std::memcpy(name, ui, 33u);
    NativeRaw555Image *popup = load_native_raw555_image(&f.app, name);
    NativeRaw555Image *frame = load_native_raw555_image(&f.app, "Frame");
    const int32_t sx = read_i32_le(ui + 0x27u), sy = read_i32_le(ui + 0x2bu);
    const int32_t dx = read_i32_le(ui + 0x47u), dy = read_i32_le(ui + 0x4bu);
    const int32_t width = read_i32_le(ui + 0x2fu) - sx + 1, height = read_i32_le(ui + 0x33u) - sy + 1;
    if (!popup || !frame || sx < 0 || sy < 0 || dx < 0 || dy < 0 || width <= 0 || height <= 0 ||
        sx + width > static_cast<int32_t>(popup->width) || sy + height > static_cast<int32_t>(popup->height) ||
        dx + width > 640 || dy + height > 480 || frame->width != 640u || frame->height != 480u) return false;
    /* Stock slider pixels now overlay the frame. Compute the initial thumb
     * from original UICO geometry, independently of the candidate box. */
    const uint8_t *slider = ui + CTB_SLIDER_CONFIG - CTB_CONFIG;
    if (read_i32_le(slider + SLD_ORIENTATION - SLD_CONFIG) != 1 ||
        read_i32_le(slider + SLD_DIRECTION - SLD_CONFIG) != 2 ||
        read_i32_le(slider + SLD_RELATIVE - SLD_CONFIG) != 0) return false;
    char slider_name[34]{}, background_name[34]{};
    std::memcpy(slider_name, slider, 33); std::memcpy(background_name, slider + 33, 33);
    NativeRaw555Image *art = load_native_raw555_image(&f.app, slider_name);
    NativeRaw555Image *background = load_native_raw555_image(&f.app, background_name);
    if (!art || !background) return false;
    const uint8_t *track = slider + SLD_TRACK_RAW - SLD_CONFIG;
    const uint8_t *bgsrc = slider + SLD_BG_SRC - SLD_CONFIG;
    const uint8_t *thumbsrc = slider + SLD_SRC_RECTS - SLD_CONFIG;
    const int32_t tx = read_i32_le(track), ty = read_i32_le(track + 4);
    const int32_t tw = read_i32_le(track + 8) - tx + 1, th = read_i32_le(track + 12) - ty + 1;
    const int32_t ax = read_i32_le(thumbsrc), ay = read_i32_le(thumbsrc + 4);
    const int32_t aw = read_i32_le(thumbsrc + 8) - ax + 1, ah = read_i32_le(thumbsrc + 12) - ay + 1;
    const int32_t ux = tx + tw / 2 - aw / 2, uy = ty;
    const int state = read_i32_le(f.app.a3f_caption.popup.box + CTB_STATE);
    const bool controls = state == 2 || state == 3;
    auto pixel = [](const NativeRaw555Image *image, int32_t x, int32_t y, uint16_t *out) {
        if (x < 0 || y < 0 || x >= static_cast<int32_t>(image->width) || y >= static_cast<int32_t>(image->height)) return false;
        const uint8_t *p = image->pixels.data() + static_cast<size_t>(y) * image->pitch + static_cast<size_t>(x) * 2u;
        *out = static_cast<uint16_t>(p[0] | p[1] << 8); return true;
    };
    size_t changed_from_frame = 0;
    for (int32_t y = 0; y < height; ++y) for (int32_t x = 0; x < width; ++x) {
        const int32_t screen_x = dx + x, screen_y = dy + y;
        /* The original popup border lies outside the 578x81 text viewport. */
        if (screen_x >= 51 && screen_x <= 628 && screen_y >= 392 && screen_y <= 472) continue;
        const uint8_t *source = popup->pixels.data() + static_cast<size_t>(sy + y) * popup->pitch + static_cast<size_t>(sx + x) * 2u;
        const uint8_t *base = frame->pixels.data() + static_cast<size_t>(screen_y) * frame->pitch + static_cast<size_t>(screen_x) * 2u;
        if (source[0] != base[0] || source[1] != base[1]) ++changed_from_frame;
        uint16_t word = static_cast<uint16_t>(source[0] | (source[1] << 8));
        if (controls && screen_x >= tx && screen_x < tx + tw && screen_y >= ty && screen_y < ty + th) {
            if (!pixel(background, read_i32_le(bgsrc) + screen_x - tx,
                read_i32_le(bgsrc + 4) + screen_y - ty, &word)) return false;
        }
        if (controls && screen_x >= ux && screen_x < ux + aw && screen_y >= uy && screen_y < uy + ah) {
            uint16_t top = 0;
            if (!pixel(art, ax + screen_x - ux, ay + screen_y - uy, &top)) return false;
            if (read_i32_le(slider + SLD_INIT_TRANSPARENT - SLD_CONFIG) != 1 ||
                top != f.app.captions.pixel_format.color_key) word = top;
        }
        const uint8_t wanted[4] = {static_cast<uint8_t>(((word >> 10) & 31u) * 255u / 31u),
            static_cast<uint8_t>(((word >> 5) & 31u) * 255u / 31u), static_cast<uint8_t>((word & 31u) * 255u / 31u), 255u};
        if (std::memcmp(f.app.framebuffer.data() + (static_cast<size_t>(screen_y) * 640u + static_cast<size_t>(screen_x)) * 4u,
                        wanted, sizeof(wanted)) != 0) return false;
    }
    return changed_from_frame != 0u;
}

static int captions_off(ConversationFixture &f)
{
    CHECK(f.app.closed_captioning == 1u && f.app.world_clock_session.captions_enabled_5bb202 == 0 && f.tick(),
          "only the live user caption setting changes after real new-game initialization");
    LiveAudioChannelInfo sound{};
    int busy = 0;
    CHECK(live_audio_get_channel_info(f.app.live_audio, 12, &sound) == LIVE_AUDIO_OK && sound.loaded == 1u &&
          sound.started == 1u && sound.frame_count > 0u &&
          live_audio_is_playing(f.app.live_audio, 12, &busy) == ACTION_SOUND_BACKEND_OK && busy == 1 &&
          f.app.a3f_caption.active[0] && f.app.a3f_caption.active[1] && !f.app.a3f_caption.ready &&
          f.app.captions.writer_globals.framed_ready == 0 && f.app.captions.lifecycle.g.framed_layer_enabled == 0 &&
          f.app.captions.lifecycle.g.overlay_ui == 2,
          "captions off still acquires both surfaces and starts the actual channel12 voice without a text layer");
    const bool popup = popup_border_matches(f);
    std::printf("CONVO_CAPTIONS_OFF_INITIAL popup=%d clear_request=%d\n", popup,
                f.app.captions.lifecycle.g.framed_clear_request);
    int32_t clear[4]{};
    for (unsigned i = 0; i < 4u; ++i) {
        SceneActionRuntimeState state{};
        CHECK(f.tick() && f.row9(&state) && state.phase == 1u && state.completed == 0u &&
              f.app.a3f_caption.active[0] && f.app.a3f_caption.active[1] && !f.app.a3f_caption.ready &&
              f.app.captions.lifecycle.g.framed_layer_enabled == 0,
              "busy captions-off voice keeps phase1 and its surfaces without publishing text");
        clear[i] = f.app.captions.lifecycle.g.framed_clear_request;
    }
    std::printf("CONVO_CAPTIONS_OFF popup=%d clear=%d,%d,%d,%d\n", popup, clear[0], clear[1], clear[2], clear[3]);
    CHECK(popup, "captions-off mode2 draws the exact original UICO popup border and stock slider independently of text readiness");
    CHECK(clear[2] == 0 && clear[3] == 0, "the ordinary two-frame text clear drains without being re-armed by busy conversation visits");
    CHECK(f.saw_coalesced_restore(), "the first clear invokes the explicit host restore already performed by scene reseeding and popup redraw");
    for (unsigned i = 0; busy != 0 && i < 800u; ++i) {
        CHECK(f.render_audio(), "captions-off speech renders finite allzero post-master PCM");
        CHECK(live_audio_is_playing(f.app.live_audio, 12, &busy) == ACTION_SOUND_BACKEND_OK, "captions-off busy query succeeds");
    }
    SceneActionRuntimeState state{};
    CHECK(busy == 0 && f.tick() && f.tick() && f.tick() && f.row9(&state) && state.completed == 1u && state.phase == 0u &&
          !f.app.a3f_caption.active[0] && !f.app.a3f_caption.active[1] && !f.app.a3f_caption.ready &&
          f.app.a3f_caption.pixels[0].empty() && f.app.a3f_caption.pixels[1].empty() && caption_region_restored(f),
          "captions-off real voice completes naturally and releases both surfaces with no stale popup or text");
    SceneTransitionRequest transition{};
    CHECK(scene_session_get_pending_transition(f.app.session, &transition) != 0 && transition.target_scene == 1810,
          "captions-off preserves the original row9 default transition");
    std::printf("CONVO_CAPTIONS_OFF_DONE channel=12 muted_frames=%llu released=2 target=1810\n",
                static_cast<unsigned long long>(f.muted_frames));
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
        const bool preview = std::strcmp(argv[3], "preview") == 0;
        const bool captions_disabled = std::strcmp(argv[3], "captions-off") == 0;
        if (!fixture.initialize(argv[2], preview ? 1807 : 1800, !captions_disabled)) { fixture.print_log_tail(); CHECK(false, "actual BOOT/new-game/scene component initializes"); }
        if (std::strcmp(argv[3], "start") == 0) return caption_start(fixture);
        if (std::strcmp(argv[3], "sound") == 0) return sound_completion(fixture);
        if (std::strcmp(argv[3], "reset") == 0) return reset_reentry(fixture);
        if (preview) return preview_responses(fixture);
        if (std::strcmp(argv[3], "boundaries") == 0) return layout_boundaries(fixture);
        if (captions_disabled) return captions_off(fixture);
        return 2;
    }
}
