/* NATIVE-13: actual BOOT/new-game, S1807 and app conversation choices.
 * S1807 is a component, not a full story-route claim. It uses original
 * response resources with the executor's untouched fresh state.
 * Gameplay cases use fresh story state. A controlled pure preview restores
 * its temporary gate before any execution. No inventory/phase injection,
 * oracle, window or output device. */
#define main blackmoor_app_entry_for_conversation_choices_test
#ifndef NATIVE_CONVERSATION_CHOICES_APP_SOURCE
#define NATIVE_CONVERSATION_CHOICES_APP_SOURCE "../src/blackmoor_app.mm"
#endif
#include NATIVE_CONVERSATION_CHOICES_APP_SOURCE
#undef main
#include "../src/action_family_3f.h"
#include <csignal>

#define CHECK(condition, message) do { if (!(condition)) { \
    std::fprintf(stderr, "CHECK failed: %s\n", message); return 1; } } while (0)

struct ChoiceFixture {
    NativeApp app;
    uint32_t now = 1000;
    uint64_t muted_frames = 0;
    AutoText *expected_convo = nullptr;
    ~ChoiceFixture() { autotext_close(expected_convo); cleanup(&app); }

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
    bool initialize(const char *directory, int16_t scene_id = 1807, bool captions_on = true)
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
    bool row0(SceneActionRuntimeState *state) const
    { return scene_session_get_action_state(app.session, 0u, state) == SCENE_SESSION_OK; }
    bool finish_channel(uint16_t channel)
    {
        int busy = 0;
        if (live_audio_is_playing(app.live_audio, channel, &busy) != ACTION_SOUND_BACKEND_OK) return false;
        for (unsigned i = 0; busy != 0 && i < 800u; ++i) {
            if (!render_audio() || live_audio_is_playing(app.live_audio, channel, &busy) != ACTION_SOUND_BACKEND_OK) return false;
        }
        return busy == 0;
    }
};

static void rgba555(uint16_t word, uint8_t out[4])
{
    out[0] = static_cast<uint8_t>(((word >> 10) & 31u) * 255u / 31u);
    out[1] = static_cast<uint8_t>(((word >> 5) & 31u) * 255u / 31u);
    out[2] = static_cast<uint8_t>((word & 31u) * 255u / 31u);
    out[3] = 255u;
}

static bool choice_metadata(ChoiceFixture &f, bool captions_on)
{
    SceneActionInfo action{};
    ActionFamily3fDecoded decoded{};
    if (scene_resource_action_at(f.app.scene, 0u, &action) != SCENE_RESOURCE_OK ||
        action_family_3f_decode(action.raw_body, action.raw_body_length, &decoded) != ACTION_FAMILY_3F_OK ||
        decoded.primary_count != 6 || session_a3f_response_count(f.app.a3f) != 5 ||
        f.app.a3f_caption.result.response_count != 5 || !f.app.a3f_caption.ready) return false;
    const uint8_t *record = decoded.primary_records;
    for (unsigned i = 0; i < 6u; ++i) {
        const size_t conditions = static_cast<size_t>(record[0]);
        const uint8_t *key = record + 2u + conditions * 5u;
        if (i < 5u) {
            const uint8_t *expected = nullptr;
            size_t raw = 0, length = 0;
            if (autotext_lookup(f.expected_convo, key, std::strlen(reinterpret_cast<const char *>(key)),
                                &expected, &raw, &length) != AUTOTEXT_OK) return false;
            const uint8_t *listed = session_a3f_response_text(f.app.a3f, static_cast<int>(i));
            const auto &choice = f.app.a3f_caption.result.choices[i];
            const int first_top = captions_on ? 35 : 3;
            const int expected_rect[4] = {10, first_top + static_cast<int>(i) * 19, 574, first_top + 18 + static_cast<int>(i) * 19};
            for (unsigned side = 0; side < 4u; ++side) if (choice.rect[side] != expected_rect[side]) return false;
            if (!listed || std::strlen(reinterpret_cast<const char *>(listed)) != length ||
                std::memcmp(listed, expected, length) != 0 ||
                std::strcmp(reinterpret_cast<const char *>(choice.sound_name), reinterpret_cast<const char *>(key + 33u)) != 0 ||
                session_a3f_manager(f.app.a3f)->responses[i].scene !=
                    static_cast<int16_t>(key[66u] | static_cast<uint16_t>(key[67u]) << 8)) return false;
        } else {
            bool gated = false;
            for (size_t c = 0; c < conditions; ++c) {
                const uint8_t *condition = record + 2u + c * 5u;
                if (condition[0] == 1u && static_cast<uint16_t>(condition[1] | (condition[2] << 8)) == 1487u &&
                    condition[3] != 0u && f.app.new_game.event_flags[1487] == 0) gated = true;
            }
            if (!gated) return false;
        }
        record += 70u + conditions * 5u;
    }
    return f.app.a3f_caption.result.scroll_lines == (captions_on ? 73 : 41);
}

/* Original FONT8/9 color0 first-response glyph, independently read from
 * owned metadata/sheets. Source-derived pen: left10, bottom47 with CC,15
 * without CC. Only the actual resource's first visible character is used. */
static bool first_response_glyph(ChoiceFixture &f, unsigned variant, bool captions_on, bool visible)
{
    const uint8_t *text = session_a3f_response_text(f.app.a3f, 0);
    if (!text) return false;
    while (*text == '<') {
        const char *end = std::strchr(reinterpret_cast<const char *>(text), '>');
        if (!end) return false;
        text = reinterpret_cast<const uint8_t *>(end + 1);
    }
    const uint8_t character = *text;
    const uint8_t *record = f.app.captions.fonts.records[8u + variant];
    unsigned index = 0;
    if (character >= 'A' && character <= 'Z') index = static_cast<unsigned>(record[0x53] | (record[0x54] << 8)) + character - 'A';
    else if (character >= 'a' && character <= 'z') index = static_cast<unsigned>(record[0x55] | (record[0x56] << 8)) + character - 'a';
    else return false;
    if (index >= CAPTION_FONT_GLYPHS) return false;
    const size_t rect = 0xc3u + index * 16u;
    const int32_t sx = read_i32_le(record + rect) + read_i32_le(record + 0x3fu);
    const int32_t sy = read_i32_le(record + rect + 4u) + read_i32_le(record + 0x43u);
    const int32_t width = read_i32_le(record + rect + 8u) - read_i32_le(record + rect) + 1;
    const int32_t height = read_i32_le(record + rect + 12u) - read_i32_le(record + rect + 4u) + 1;
    const int32_t top = (captions_on ? 47 : 15) - height + 1;
    const CaptionSurface &surface = f.app.a3f_caption.surface[variant];
    NativeRaw555Image *sheet = load_native_raw555_image(&f.app, reinterpret_cast<const char *>(record));
    if (!sheet || !surface.pixels || surface.width != 578 || surface.height != 1001 || surface.pitch != 1156 ||
        sx < 0 || sy < 0 || width <= 0 || height <= 0 || sx + width > static_cast<int32_t>(sheet->width) ||
        sy + height > static_cast<int32_t>(sheet->height) || top < 0 || top + height > 81) return false;
    size_t ink = 0;
    for (int32_t y = 0; y < height; ++y) for (int32_t x = 0; x < width; ++x) {
        const uint8_t *source = sheet->pixels.data() + static_cast<size_t>(sy + y) * sheet->pitch + static_cast<size_t>(sx + x) * 2u;
        const uint16_t word = static_cast<uint16_t>(source[0] | (source[1] << 8));
        if (word == f.app.captions.pixel_format.color_key) continue;
        ++ink;
        const uint8_t *actual = surface.pixels + static_cast<size_t>(top + y) * surface.pitch + static_cast<size_t>(10 + x) * 2u;
        if (actual[0] != source[0] || actual[1] != source[1]) return false;
        if (visible) {
            uint8_t rgba[4]{}; rgba555(word, rgba);
            if (std::memcmp(f.app.framebuffer.data() + (static_cast<size_t>(392 + top + y) * 640u + static_cast<size_t>(61 + x)) * 4u,
                            rgba, sizeof(rgba)) != 0) return false;
        }
    }
    return ink != 0u;
}

static bool visible_choice_matches(ChoiceFixture &f, int index, unsigned variant)
{
    const auto &choice = f.app.a3f_caption.result.choices[index];
    const CaptionSurface &surface = f.app.a3f_caption.surface[variant];
    const int scroll = f.app.captions.lifecycle.g.scroll_src.top;
    const int top = std::max<int>(choice.rect[1], scroll), bottom = std::min<int>(choice.rect[3], scroll + 80);
    if (!surface.pixels || top > bottom) return false;
    for (int y = top; y <= bottom; ++y) for (int x = choice.rect[0]; x <= choice.rect[2]; ++x) {
        const uint8_t *source = surface.pixels + static_cast<size_t>(y) * surface.pitch + static_cast<size_t>(x) * 2u;
        uint8_t rgba[4]{}; rgba555(static_cast<uint16_t>(source[0] | (source[1] << 8)), rgba);
        const uint8_t *actual = f.app.framebuffer.data() + (static_cast<size_t>(392 + y - scroll) * 640u + static_cast<size_t>(51 + x)) * 4u;
        if (std::memcmp(actual, rgba, sizeof(rgba)) != 0) return false;
    }
    return true;
}

static bool hover_choice(ChoiceFixture &f, int index)
{
    const auto &choice = f.app.a3f_caption.result.choices[index];
    const int scroll = f.app.captions.lifecycle.g.scroll_src.top;
    const int top = std::max<int>(choice.rect[1] - scroll, 0), bottom = std::min<int>(choice.rect[3] - scroll, 80);
    if (top > bottom) return false;
    pointer(&f.app, BLACKMOOR_POINTER_MOVE, 51 + (choice.rect[0] + choice.rect[2]) / 2, 392 + (top + bottom) / 2, 0);
    return f.tick() && f.app.a3f_caption.hover == index && visible_choice_matches(f, index, 1u);
}

static bool scroll_choices(ChoiceFixture &f, bool bottom)
{
    const uint8_t *slider = f.app.a3f_caption.popup.box + CTB_SLIDER;
    const int32_t tx = read_i32_le(slider + SLD_THUMB), ty = read_i32_le(slider + SLD_THUMB + 4u);
    const int32_t tr = read_i32_le(slider + SLD_THUMB + 8u), tb = read_i32_le(slider + SLD_THUMB + 12u);
    const int32_t track_top = read_i32_le(slider + SLD_TRACK + 4u), track_bottom = read_i32_le(slider + SLD_TRACK + 12u);
    if (tx > tr || ty > tb || track_top > track_bottom || track_bottom >= 480) return false;
    const int32_t x = (tx + tr) / 2, y = (ty + tb) / 2;
    const int32_t target = bottom ? track_bottom : track_top;
    pointer(&f.app, BLACKMOOR_POINTER_MOVE, x, y, 0);
    if (!f.tick()) return false;
    pointer(&f.app, BLACKMOOR_POINTER_DOWN, x, y, 0);
    if (!f.tick()) return false;
    pointer(&f.app, BLACKMOOR_POINTER_MOVE, x, target, 0);
    if (!f.tick()) return false;
    pointer(&f.app, BLACKMOOR_POINTER_UP, x, target, 0);
    if (!f.tick()) return false;
    return f.app.captions.lifecycle.g.scroll_src.top == (bottom ? f.app.a3f_caption.result.scroll_lines : 0);
}

static int actual_choices(ChoiceFixture &f)
{
    SceneActionInfo action{};
    ActionFamily3fDecoded decoded{};
    CHECK(f.app.current_scene_id == 1807 && scene_resource_action_at(f.app.scene, 0u, &action) == SCENE_RESOURCE_OK &&
          action.type == SESSION_A3F_TYPE && action_family_3f_decode(action.raw_body, action.raw_body_length, &decoded) == ACTION_FAMILY_3F_OK &&
          decoded.primary_count == 6 && decoded.option_44 == CONVO3F_NO_HOOK && decoded.option_45 == CONVO3F_NO_HOOK &&
          f.app.new_game.event_flags[1487] == 0,
          "actual S1807 row0 has six original primary definitions with its sixth event gate naturally false");
    CHECK(f.tick(), "actual S1807 response UI presents the naturally eligible choices instead of freezing as unimplemented");
    SceneActionRuntimeState state{};
    CHECK(f.row0(&state) && state.phase == 1u && state.completed == 0u &&
          session_a3f_manager(f.app.a3f)->row == 0 && session_a3f_response_count(f.app.a3f) == 5,
          "the real kernel lists all five eligible original responses in running phase1");
    for (int i = 0; i < 5; ++i)
        CHECK(session_a3f_response_text(f.app.a3f, i) != nullptr && session_a3f_response_text(f.app.a3f, i)[0] != 0,
              "every eligible original response has real text");
    CHECK(choice_metadata(f, true), "all five original texts, rectangles, scene targets and sound mappings preserve the real resource order");
    CHECK(first_response_glyph(f, 0u, true, true) && first_response_glyph(f, 1u, true, false),
          "response text uses exact original FONT8/9 color0 glyphs at left10/baseline47");
    CHECK(hover_choice(f, 0) && first_response_glyph(f, 1u, true, true) && hover_choice(f, 1),
          "actual MOVE displays exact original hilite pixels for the visible choices");
    pointer(&f.app, BLACKMOOR_POINTER_MOVE, 0, 0, 0);
    CHECK(f.tick() && f.app.a3f_caption.hover == -1 && visible_choice_matches(f, 1, 0u),
          "moving out restores the normal surface without sticky response highlight");
    std::printf("CHOICES_START scene=1807 row=0 definitions=6 eligible=5 gated_event1487=0\n");
    return 0;
}

static int scroll_select(ChoiceFixture &f)
{
    CHECK(f.tick() && choice_metadata(f, true), "real S1807 response list initializes");
    CHECK(hover_choice(f, 2) && scroll_choices(f, true) && hover_choice(f, 3) && hover_choice(f, 4),
          "stock slider drag exposes both lower choices through real pointer hover and visible hilite");
    CHECK(scroll_choices(f, false) && hover_choice(f, 0) && f.finish_channel(12),
          "dragging back to the top preserves first-choice ownership and lets real initial voice finish");
    const auto *manager = session_a3f_manager(f.app.a3f);
    CHECK(manager->responses[0].scene == 1809, "the first actual choice targets original reply scene1809");
    const uint64_t response_frames_before = f.muted_frames;
    pointer(&f.app, BLACKMOOR_POINTER_DOWN, f.app.pointer_x, f.app.pointer_y, 0);
    pointer(&f.app, BLACKMOOR_POINTER_UP, 639, 479, 0); /* UP does not replace the actual MOVE hotpoint. */
    for (unsigned i = 0; session_a3f_manager(f.app.a3f)->sub_state != 6u && i < 8u; ++i)
        CHECK(f.tick(), "accepted actual release advances selection through the real conversation kernel");
    LiveAudioChannelInfo sound{};
    int busy = 0;
    SceneActionRuntimeState state{};
    CHECK(session_a3f_manager(f.app.a3f)->sub_state == 6u && f.row0(&state) && state.phase == 1u && state.completed == 0u &&
          live_audio_get_channel_info(f.app.live_audio, 13, &sound) == LIVE_AUDIO_OK && sound.loaded == 1u && sound.started == 1u &&
          sound.frame_count > 0u && live_audio_is_playing(f.app.live_audio, 13, &busy) == ACTION_SOUND_BACKEND_OK && busy == 1 &&
          f.app.input_state.latch[0] == 0u,
          "release at retained MOVE hotpoint selects first real channel13 response and owns its input edge");
    for (unsigned i = 0; i < 3u; ++i)
        CHECK(f.tick() && f.row0(&state) && state.phase == 1u && state.completed == 0u &&
              session_a3f_manager(f.app.a3f)->sub_state == 6u,
              "busy real response voice cannot complete or request a reply scene early");
    CHECK(f.finish_channel(13) && f.tick() && f.row0(&state) && state.phase == 2u && state.completed == 0u &&
          f.tick() && f.row0(&state) && state.phase == 0u && state.completed == 1u,
          "real muted response completion enters phase2 before naturally finishing");
    SceneTransitionRequest transition{};
    CHECK(scene_session_get_pending_transition(f.app.session, &transition) != 0 && transition.target_scene == 1809 &&
          transition.opaque_words[0] == 0 && transition.opaque_words[1] == 0 && transition.opaque_words[2] == 1 &&
          transition.opaque_dwords[0] == 0 && transition.opaque_dwords[1] == 0 && transition.opaque_dwords[2] == 1 &&
          !f.app.a3f_caption.ready && !f.app.a3f_caption.active[0] && !f.app.a3f_caption.active[1] &&
          f.app.a3f_caption.pixels[0].empty() && f.app.a3f_caption.pixels[1].empty(),
          "selected first-choice tuple reaches1809 after releasing both response surfaces");
    std::printf("CHOICES_SELECT lower_hover=2,3,4 first_selected=0 scroll=73 response_channel=13 target=1809 response_muted_frames=%llu\n",
                static_cast<unsigned long long>(f.muted_frames - response_frames_before));
    return 0;
}

static int captions_off_choices(ChoiceFixture &f)
{
    CHECK(f.app.closed_captioning == 1u && f.app.world_clock_session.captions_enabled_5bb202 == 0 && f.tick() && choice_metadata(f, false),
          "live captions-off setting still lays out all five original choices with original geometry and sound mappings");
    CHECK(first_response_glyph(f, 0u, false, true) && first_response_glyph(f, 1u, false, false) &&
          hover_choice(f, 0) && first_response_glyph(f, 1u, false, true),
          "captions-off choices retain exact original normal/hilite fonts at baseline15");
    CHECK(scroll_choices(f, true) && hover_choice(f, 4) && f.app.new_game.event_flags[1487] == 0,
          "captions-off stock slider reaches the last eligible choice without changing its story gate");
    std::printf("CHOICES_CAPTIONS_OFF eligible=5 first_top=3 scroll=41 last_hover=4\n");
    return 0;
}

static bool frame_region_restored(ChoiceFixture &f)
{
    NativeRaw555Image *frame = load_native_raw555_image(&f.app, "Frame");
    if (!frame || frame->width != 640u || frame->height != 480u) return false;
    for (size_t y = 392; y <= 472; ++y) for (size_t x = 51; x <= 628; ++x) {
        const uint8_t *source = frame->pixels.data() + y * frame->pitch + x * 2u;
        uint8_t rgba[4]{}; rgba555(static_cast<uint16_t>(source[0] | (source[1] << 8)), rgba);
        if (std::memcmp(f.app.framebuffer.data() + (y * 640u + x) * 4u, rgba, sizeof(rgba)) != 0) return false;
    }
    return true;
}

static int scene_cleanup(ChoiceFixture &f)
{
    CHECK(f.tick() && choice_metadata(f, true) && scroll_choices(f, true) && hover_choice(f, 4),
          "actual response surfaces, lower scroll and hover exist before scene replacement");
    const auto flags = f.app.new_game.event_flags;
    for (int target : {2098, 1807}) {
        SceneTransitionRequest transition{};
        transition.target_scene = static_cast<int16_t>(target);
        CHECK(scene_session_request_external_transition(f.app.session, &transition) == SCENE_SESSION_OK,
              "component replacement requests the existing external scene-transition path");
        for (unsigned i = 0; f.app.current_scene_id != target && i < 8u; ++i)
            CHECK(f.tick(), "normal exit/load states replace the response scene");
        CHECK(f.app.current_scene_id == target && !f.app.a3f_caption.ready && !f.app.a3f_caption.active[0] &&
              !f.app.a3f_caption.active[1] && f.app.a3f_caption.pixels[0].empty() && f.app.a3f_caption.pixels[1].empty() &&
              f.app.a3f_caption.hover == -1 && f.app.a3f_caption.result.response_count == 0 &&
              session_a3f_response_count(f.app.a3f) == 0 && frame_region_restored(f),
              "replacement clears response ownership, hover, list and visible text before target ACT dispatch");
        pointer(&f.app, BLACKMOOR_POINTER_MOVE, 0, 0, 0);
    }
    for (unsigned i = 0; !f.app.a3f_caption.ready && i < 3u; ++i)
        CHECK(f.tick(), "ordinary intro and row dispatch rebuild response UI");
    CHECK(choice_metadata(f, true) && f.app.a3f_caption.hover == -1 && f.app.captions.lifecycle.g.scroll_src.top == 0 &&
          f.app.new_game.event_flags == flags && first_response_glyph(f, 0u, true, true),
          "re-entry rebuilds fresh five-choice geometry at scroll0 without story-state changes");
    std::printf("CHOICES_CLEANUP via=2098 released=2 list_reset=1 hover_reset=1 scroll_reset=1 rebuilt=5\n");
    return 0;
}

static int pure_preflight(ChoiceFixture &f)
{
    const auto flags = f.app.new_game.event_flags;
    const auto inventory = f.app.new_game.inventory_presence;
    const auto framebuffer = f.app.framebuffer;
    std::array<uint8_t, sizeof(Convo3fManager)> manager_before{};
    std::memcpy(manager_before.data(), session_a3f_manager(f.app.a3f), manager_before.size());
    Convo3fWorld world_before{}, world_after{};
    std::memset(&world_before, 0, sizeof(world_before));
    std::memset(&world_after, 0, sizeof(world_after));
    CHECK(native_a3f_load_world(&f.app, &world_before) == 0, "pure preview snapshots the real host world");
    Convo3fManager preview{};
    Convo3fLayoutRequest request{};
    CHECK(session_a3f_preview_layout(f.app.a3f, 0u, &preview, &request) == CONVO3F_OK && request.response_count == 5,
          "unmodified original row previews five eligible responses without execution");
    /* Controlled condition test only: no tick, handler, pointer or selection
     * runs while the temporary gate differs from real new-game state. */
    const int32_t saved_gate = f.app.new_game.event_flags[1487];
    f.app.new_game.event_flags[1487] = 1;
    const int gated_status = session_a3f_preview_layout(f.app.a3f, 0u, &preview, &request);
    f.app.new_game.event_flags[1487] = saved_gate;
    CHECK(gated_status == CONVO3F_OK && request.response_count == 6,
          "the pure kernel preview includes the actual sixth entry when its controlled gate is true");
    CHECK(session_a3f_preview_layout(f.app.a3f, 0u, &preview, &request) == CONVO3F_OK && request.response_count == 5 &&
          native_a3f_load_world(&f.app, &world_after) == 0 && std::memcmp(&world_before, &world_after, sizeof(world_before)) == 0 &&
          std::memcmp(manager_before.data(), session_a3f_manager(f.app.a3f), manager_before.size()) == 0,
          "restoring the gate restores five choices while persistent manager and host world remain unchanged");
    std::vector<uint8_t> pixels[2];
    CaptionSurface surfaces[2]{};
    std::array<int16_t, CAPTION_MAX_FONTS> refs{};
    std::copy(std::begin(f.app.captions.writer_globals.sheet_refcount), std::end(f.app.captions.writer_globals.sheet_refcount), refs.begin());
    for (unsigned pass = 0; pass < 2u; ++pass) {
        pixels[pass].assign(578u * 1001u * 2u, static_cast<uint8_t>(pass == 0u ? 0x5a : 0xa6));
        surfaces[pass] = {pixels[pass].data(), 578, 1001, 1156};
    }
    static const char *malformed[] = {
        "A",                         /* builder h00 remains unterminated */
        "<h01>A<h><n>",             /* nested response span */
        "A<h><h02>B<h><n>",         /* sparse response id */
        "<e>",                      /* ends inside builder h00 prefix */
        "A<h><n><s30voice>",         /* voice id beyond the 30-entry table */
        "<svoice>A<h><n>"            /* missing two-digit voice id */
    };
    static const uint8_t caption[] = "<i><o>";
    for (unsigned i = 0; i < sizeof(malformed) / sizeof(malformed[0]); ++i) {
        Convo3fResponse response{};
        static const uint8_t name[] = "fixture_voice";
        std::memcpy(response.name, name, sizeof(name));
        std::memcpy(response.text, malformed[i], std::strlen(malformed[i]));
        const Convo3fLayoutRequest bad = {0, caption, sizeof(caption) - 1u, 1, &response, 0, 1};
        NativeConversationCaptionResult output;
        std::memset(&output, 0xa5, sizeof(output));
        std::array<uint8_t, sizeof(output)> output_before{};
        std::memcpy(output_before.data(), &output, sizeof(output));
        const size_t cached_sheets = f.app.captions.raw_images.size();
        const int dry = native_conversation_choices_validate(&bad, 1, &f.app.captions.fonts,
            &f.app.captions.geometry, &f.app.captions.pixel_format);
        const int drawn = native_conversation_choices_write(&bad, 1, &f.app.captions.fonts, &f.app.captions.geometry,
            &f.app.captions.pixel_format, &f.app.captions.writer_globals, &f.app.captions.writer_backend, surfaces, &output);
        std::printf("CHOICES_PREFLIGHT kind=%u validate=%d write=%d\n", i, dry, drawn);
        CHECK(dry != CAPTION_OK && drawn != CAPTION_OK &&
              std::all_of(pixels[0].begin(), pixels[0].end(), [](uint8_t v) { return v == 0x5au; }) &&
              std::all_of(pixels[1].begin(), pixels[1].end(), [](uint8_t v) { return v == 0xa6u; }) &&
              std::memcmp(output_before.data(), &output, sizeof(output)) == 0 &&
              std::equal(refs.begin(), refs.end(), std::begin(f.app.captions.writer_globals.sheet_refcount)) &&
              f.app.captions.raw_images.size() == cached_sheets,
              "malformed response spans and ids refuse before pixels, result, references or sheet loads change");
    }
    LiveAudioChannelInfo initial{}, response{};
    SceneActionRuntimeState state{};
    CHECK(f.row0(&state) && state.phase == 0u && state.completed == 0u &&
          live_audio_get_channel_info(f.app.live_audio, 12, &initial) == LIVE_AUDIO_OK && initial.loaded == 0u && initial.started == 0u &&
          live_audio_get_channel_info(f.app.live_audio, 13, &response) == LIVE_AUDIO_OK && response.loaded == 0u && response.started == 0u &&
          f.app.new_game.event_flags == flags && f.app.new_game.inventory_presence == inventory && f.app.framebuffer == framebuffer &&
          !f.app.a3f_caption.ready && !f.app.a3f_caption.active[0] && !f.app.a3f_caption.active[1] &&
          session_a3f_last_result(f.app.a3f) == nullptr,
          "pure previews and malformed layout checks execute no game row or sound and publish no visible effects");
    std::printf("CHOICES_PURE preview_counts=5,6,5 malformed_refusals=6 executed_rows=0 sound_effects=0\n");
    return 0;
}

static int mode2_ui_ownership(ChoiceFixture &f)
{
    CHECK(f.tick() && choice_metadata(f, true) && f.app.captions.lifecycle.g.overlay_ui == 2,
          "actual live response conversation owns mode2 before taskbar/render boundary checks");
    const int32_t original_popup_state = read_i32_le(f.app.a3f_caption.popup.box + CTB_STATE);
    bool hidden_popup_unchanged = true;
    for (int state : {4, 0}) {
        CHECK(seed_native_caption_backbuffer(&f.app), "actual Frame/scene is freshly seeded for controlled UI draw-state check");
        const auto original_backbuffer = f.app.captions.backbuffer_pixels;
        /* UI object state only: restore immediately without any game tick,
         * scene flag, row phase or selected-response mutation. */
        for (size_t byte = 0; byte < 4u; ++byte)
            f.app.a3f_caption.popup.box[CTB_STATE + byte] = static_cast<uint8_t>(static_cast<uint32_t>(state) >> (byte * 8u));
        const bool rendered = native_a3f_caption_render(&f.app);
        hidden_popup_unchanged = hidden_popup_unchanged && rendered && f.app.captions.backbuffer_pixels == original_backbuffer;
        for (size_t byte = 0; byte < 4u; ++byte)
            f.app.a3f_caption.popup.box[CTB_STATE + byte] = static_cast<uint8_t>(static_cast<uint32_t>(original_popup_state) >> (byte * 8u));
    }
    f.app.bar_missing = false;
    CHECK(taskbar_ready_now(&f.app), "the real BOOT taskbar initializes instead of being hidden by the component fixture");
    TaskbarHost host = bar_host(&f.app);
    TaskbarProcessResult initialized{};
    CHECK(taskbar_process(&f.app.bar, &f.app.bar_layout, 1807, f.now, &host, &initialized) == TASKBAR_OK &&
          f.app.bar.state == 1, "real taskbar initialization establishes running button timers before controlled pending UI state");
    f.app.bar.flag[TASKBAR_BUTTON_INVENTORY] = 1; /* Pending UI byte, not an inventory/story item. */
    std::array<uint8_t, sizeof(Taskbar)> before{};
    std::memcpy(before.data(), &f.app.bar, before.size());
    taskbar_pre_tick(&f.app);
    taskbar_post_tick(&f.app, f.now + 1000u);
    const bool inventory_preserved = f.app.bar.flag[TASKBAR_BUTTON_INVENTORY] == 1u &&
        f.app.inv_view.screen_state == INVVIEW_STATE_NONE;
    const bool bar_unchanged = std::memcmp(before.data(), &f.app.bar, before.size()) == 0;
    std::printf("CHOICES_MODE2_GUARDS hidden_popup_unchanged=%d inventory_pending=%d bar_timers_unchanged=%d\n",
                hidden_popup_unchanged, inventory_preserved, bar_unchanged);
    CHECK(hidden_popup_unchanged, "popup states4/0 must preserve the freshly seeded backbuffer even while conversation mode2 is active");
    CHECK(inventory_preserved && bar_unchanged,
          "mode2 skips taskbar pre/post so pending inventory requests and button timers remain unconsumed");
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
        if (argc != 4 || std::strcmp(argv[1], "--conversation-choices-component") != 0) return 2;
        ChoiceFixture fixture;
        const bool captions_off = std::strcmp(argv[3], "captions-off") == 0;
        if (!fixture.initialize(argv[2], 1807, !captions_off)) { fixture.print_log_tail(); CHECK(false, "actual BOOT/new-game/S1807 choices component initializes"); }
        if (std::strcmp(argv[3], "start") == 0) return actual_choices(fixture);
        if (std::strcmp(argv[3], "select") == 0) return scroll_select(fixture);
        if (captions_off) return captions_off_choices(fixture);
        if (std::strcmp(argv[3], "cleanup") == 0) return scene_cleanup(fixture);
        if (std::strcmp(argv[3], "preflight") == 0) return pure_preflight(fixture);
        if (std::strcmp(argv[3], "mode2-guards") == 0) return mode2_ui_ownership(fixture);
        return 2;
    }
}
