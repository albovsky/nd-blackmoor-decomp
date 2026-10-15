/* Native integration harness for the recovered startup. This is an incomplete
 * engine, not a playable game. No original x86 code is executed by this app. */
#include "macos_platform.h"
#include "game_resources.h"
#include "engine_boot.h"
#include "startup_menu.h"
#include "scene_resource.h"
#include "bink_player.h"
#include "scene_executor.h"
#include "action_ui.h"
#include "action_sound.h"
#include "his_audio.h"
#include "macos_audio.h"
#include "live_audio.h"
#include "scene_inspector.h"
#include "world_init.h"
#include "world_clock.h"
#include "action_family28_surface.h"
#include "scene_conditions.h"
#include "scene_session.h"
#include "session_bindings_a62.h"
#include "session_bindings_a51.h"
#include "session_bindings_a35.h"
#include "session_bindings_a35_bink.h"
#include "session_bindings_a79.h"
#include "session_bindings_a78.h"
#include "inventory_view_runtime.h"
#include "inventory_button_runtime.h"
#include "session_bindings_a36.h"
#include "session_bindings_a17.h"
#include "session_bindings_a0b.h"
#include "session_bindings_a0c.h"
#include "session_bindings_a97.h"
#include "session_bindings_aa1.h"
#include "session_bindings_a83.h"
#include "session_bindings_conditions.h"
#include "session_bindings_conditions_audio.h"
#include "session_bindings_a28.h"
#include "session_exit.h"
#include "session_input.h"
#include "session_navigation.h"
#include "caption_layout.h"
#include "caption_lifecycle.h"
#include "caption_compositor.h"
#include "cif_pixels.h"
#include "hiff.h"
#include "autotext.h"

#import <AppKit/AppKit.h>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cstdarg>
#include <ctime>
#include <climits>
#include <string>
#include <utility>
#include <vector>
#include <map>
#include <new>
#include <algorithm>
#include <array>
#include <stdexcept>
#include <unistd.h>
#include <dirent.h>
#include <cmath>
#include <chrono>
#include <memory>

static const char *default_game_directory =
    "/Applications/Nancy Drew - Curse of Blackmoor Manor.app/Contents/Resources/game/"
    "Nancy Drew Curse of the Blackmoor Manor.app/Contents/Resources/drive_c/GOG Games/"
    "Nancy Drew - Curse of Blackmoor Manor";

struct HostImage {
    uint32_t width = 0, height = 0;
    std::vector<uint8_t> rgba;
    int32_t frame_index = -1;
};

struct NativeRaw555Image {
    uint32_t width = 0, height = 0;
    uint32_t pitch = 0;
    std::vector<uint8_t> pixels;
};

struct NativeCaptionRuntime {
    CaptionFonts fonts{};
    CaptionGeometry geometry{};
    CaptionPixelFormat pixel_format{};
    CaptionTextBox writer_box{};
    CaptionGlobals writer_globals{};
    CaptionLifecycle lifecycle{};
    CaptionBackend writer_backend{};
    CaptionLifecycleBackend lifecycle_backend{};
    CaptionCompositorFormat compositor_format = CAPTION_COMPOSITOR_RGB555_LE;
    CaptionSurface caption_surface{};
    CaptionSurface framed_surface{};
    std::vector<uint8_t> caption_pixels;
    std::vector<uint8_t> framed_pixels;
    std::vector<uint8_t> backbuffer_pixels;
    CaptionRect framed_destination{};
    std::map<std::string, uint32_t> image_handles;
    std::map<uint32_t, NativeRaw555Image> raw_images;
    AutoText *auto_text = nullptr;
    size_t auto_text_entry_count = 0u;
    uint32_t next_image_handle = 1u;
    uint32_t caption_surface_handle = UINT32_C(0xf0000001);
    uint32_t framed_surface_handle = UINT32_C(0xf0000002);
    bool initialized = false;
    bool transfer_blocked = false;
    bool transfer_failed_sticky = false;
    bool backbuffer_ready = false;
    uint64_t backbuffer_seed_count = 0u;
    bool action_caption_attempted = false;
    bool action_caption_lookup_attempted = false;
    bool action_caption_present_succeeded = false;
    int last_writer_status = CAPTION_OK;
    int last_lifecycle_status = CAPTION_LIFECYCLE_OK;
    CaptionResult last_writer_result{};
    uint64_t transfer_attempts = 0u;
    uint64_t transfer_successes = 0u;
    uint64_t transfer_tick = 0u;
    uint64_t composed_session_tick = 0u;
#ifdef BLACKMOOR_NATIVE_APP_TEST_HOOKS
    uint32_t test_fail_blit_index = 0u;
    bool test_reset_after_composition = false;
    bool test_reset_probe_done = false;
    bool test_reseed_visible_caption = false;
    bool test_reseed_probe_done = false;
#endif
};

/* Exact bounded spans proven by the New Game reset paths. These counts are
 * caller-view sizes, not declarations of original global capacities. */
struct NativeNewGameState {
    std::vector<int32_t> event_flags;
    std::vector<int32_t> opaque_state;
    std::vector<uint16_t> scene_visits;
    std::array<uint16_t, 3> selector_words{};
    int16_t selected_item_candidate = 0;
    int16_t opaque_selector = 0;
    std::vector<int32_t> inventory_presence;
    std::array<uint16_t, WORLD_INIT_INVENTORY_ENTRY_COUNT> inventory_ids_a{};
    std::array<uint16_t, WORLD_INIT_INVENTORY_ENTRY_COUNT> inventory_ids_b{};
    std::array<uint16_t, WORLD_INIT_INVENTORY_ENTRY_COUNT> inventory_ids_c{};
    std::array<uint32_t, WORLD_INIT_INVENTORY_ENTRY_COUNT> inventory_aux_a{};
    std::array<uint32_t, WORLD_INIT_INVENTORY_ENTRY_COUNT> inventory_aux_b{};
    std::array<uint8_t, WORLD_INIT_TIME_RECORD_BYTES> time_records{};
    ActionCoreWorld action_core{};
    ActionFamily64World action64_world{};
    WorldInitState view{};

    NativeNewGameState()
        : event_flags(WORLD_INIT_EVENT_NEW_GAME_FIRST_ID +
                      WORLD_INIT_EVENT_NEW_GAME_COUNT, 0),
          opaque_state(WORLD_INIT_STATE_DWORD_COUNT, 0),
          scene_visits(WORLD_INIT_VISIT_RESET_COUNT, 0),
          inventory_presence(WORLD_INIT_INVENTORY_ENTRY_COUNT, 0)
    {
        action_core.event_flags = event_flags.data();
        action_core.event_flag_count = event_flags.size();
        view.action_core = &action_core;
        view.opaque_state_dwords_5839b1 = {opaque_state.data(), opaque_state.size()};
        view.scene_visit_counts_587b2d = {scene_visits.data(), scene_visits.size()};
        view.inventory.selected_item_candidate = &selected_item_candidate;
        view.inventory.opaque_selector_583f1d = &opaque_selector;
        view.inventory.selector_words_583a2b = {selector_words.data(), selector_words.size()};
        view.inventory.presence_583bd5 = {inventory_presence.data(), inventory_presence.size()};
        view.inventory.item_ids_583a31 = {inventory_ids_a.data(), inventory_ids_a.size()};
        view.inventory.item_ids_583abd = {inventory_ids_b.data(), inventory_ids_b.size()};
        view.inventory.item_ids_583b49 = {inventory_ids_c.data(), inventory_ids_c.size()};
        view.inventory.auxiliary_583ced = {inventory_aux_a.data(), inventory_aux_a.size()};
        view.inventory.auxiliary_583e05 = {inventory_aux_b.data(), inventory_aux_b.size()};
        view.time_records_585d65 = time_records.data();
        view.time_records_size = time_records.size();
    }
};

/* RT-6: the ONE explicitly provisional cursor provider. The composed cursor
 * sprite size, the selected hot point (table 0x5b30cc/0x5b30d0), the scroll
 * word 0x5bb587 and the early UI/puzzle priority paths of 0x4f0059 are not
 * recovered. These values reproduce the pre-RT-6 S0 numbers exactly: the
 * sprite is the single pixel at the last WM_MOUSEMOVE point, the hot point is
 * (0,0), scroll is 0, so the transformed cursor is (x - viewport.left,
 * y - viewport.top) as before. They are NOT claimed to be the original
 * values; every pointer log line says "provisional".
 * The guards are the S0 values of the bytes/dword 4f0059 tests before it
 * reaches its generic scan: [0x5b5158], [0x5b61af], [0x5b615e] (each cleared
 * by ClearSceneData 0x43dd5e/0x43ddde/0x43ddbe; set only by action types
 * 0x77, 0x76 and 0x75, which have no native handler so the session freezes
 * before they could run) and [0x5a4c18] (reset by 0x4d3073 each update).
 * RT-17: result_5a4c18 is no longer an input (the zone tests produce the
 * state, session_navigation) and priority_clear additionally requires that no
 * scene row has the runtime type of a cascade member (nav_members_idle); the
 * ~40 UI hit-test callees are verified to miss on their power-on objects by the
 * RT-17 oracle, not individually reconstructed. */
struct ProvisionalCursorProvider {
    int32_t sprite_width = 1, sprite_height = 1;
    int32_t hot_x = 0, hot_y = 0;
    int32_t scroll_y = 0;
    uint8_t guard_5b5158 = 0, guard_5b61af = 0, guard_5b615e = 0;
    int32_t result_5a4c18 = 0;
};

struct NativeApp {
    BlackmoorMacPlatform *platform = nullptr;
    GameResources *resources = nullptr;
    EngineBoot *boot = nullptr;
    StartupMenu *startup = nullptr;
    SceneResource *scene = nullptr;
    /* The previous scene resource stays open while a session executor still
     * borrows it; it is closed after scene_session_replace_scene succeeds. */
    SceneResource *retired_scene = nullptr;
    BinkPlayer *video = nullptr;
    SceneSession *session = nullptr;
    LiveAudio *live_audio = nullptr;
    /* RT-3 session bindings (host providers are the static native_a62_* /
     * native_a51_* callbacks below). */
    SessionA62Binding *a62 = nullptr;
    SessionA51Binding *a51 = nullptr;
    SessionA35Binding *a35 = nullptr;
    SessionA97Binding *a97 = nullptr;
    /* RT-21: raw 0xa1 "Sound" (loader arm 0x40f069, dispatcher arm 0x4297be). */
    SessionAa1Binding *aa1 = nullptr;
    SessionA83Binding *a83 = nullptr;
    /* Native bounds; not a declaration of original global capacities. */
    uint8_t phone_mail[100][A83_MAIL_BYTES]{};
    uint8_t phone_web[100][A83_WEB_BYTES]{};
    A83World phone_lists{};
    SessionA79Binding *a79 = nullptr;
    /* RT-14: raw 0x36 static overlays (COverlay). */
    SessionA36Binding *a36 = nullptr;
    /* RT-15: raw 0x16/0x17 multiframe scene hotspots (handler 0x42b07e). */
    SessionA17Binding *a17 = nullptr;
    int32_t a17_rect[4]{};          /* rectangle being assembled from the kernel effects */
    int32_t a17_logged_rect[4]{};
    bool a17_logged_valid = false;  /* last rectangle already reported */
    /* RT-16: raw 0x0b scene-change hotspots (handler 0x42ae73); the host is RT-15's. */
    SessionA0bBinding *a0b = nullptr;
    int32_t a0b_rect[4]{};
    int32_t a0b_logged_rect[4]{};
    bool a0b_logged_valid = false;
    size_t a0b_finish_row = 0;      /* row of the visit that reached the finish effect */
    /* RT-20: raw 0x0c multi-frame scene-change hotspots (handler 0x42b2e4); the host is RT-15's. */
    SessionA0cBinding *a0c = nullptr;
    int32_t a0c_rect[4]{};
    /* Last rectangle reported per action row (4 values each; the flag marks a reported row): the
     * rows of one scene take turns in the same tick, so the log dedupe must be per row. */
    std::vector<int32_t> a0c_logged_rects;
    std::vector<uint8_t> a0c_logged_valid;
    size_t a0c_finish_row = 0;      /* row of the visit that reached the finish effect */
    std::array<uint64_t, OVERLAY36_MAX_ROWS> a36_blit_signature{};
    uint64_t a36_blits = 0u;
    /* RT-13: count of 0x4e812f view rebuilds requested by raw 0x79 (the native
     * app has no inventory view model yet; see native_a79_rebuild_view). */
    uint64_t inventory_view_rebuilds = 0u;
    /* RT-19: raw 0x78 (add inventory item, handler 0x4eaadc). Its sound request
     * (0x4fb2e3) and UI animation request (0x4e0559) are logged and counted, not
     * performed: the app has no sound-effect backend and no UI button table. */
    SessionA78Binding *a78 = nullptr;
    uint64_t a78_sound_requests = 0u, a78_ui_requests = 0u;
    /* RT-22: the inventory view (object 0x571442): screen state 0x583204, slots,
     * pointer routing. Geometry comes from the boot chunks UIIV/INV/CURS (copies,
     * read once). The task bar button (0x4e0f91 / 0x4e1450 set byte 0x583232) is recovered
     * (inventory_button_runtime, see the bar members below); the open request is its consumer
     * (0x43a862) and the stand-in for --live-pick-item. */
    InventoryView inv_view{};
    InventoryViewLayout inv_layout{};
    bool inv_view_initialized = false;
    int16_t inv_kind[INVVIEW_ITEMS]{}, inv_text[INVVIEW_ITEMS]{};
    std::vector<uint8_t> inv_uiiv, inv_curs;
    bool inv_data_ready = false;
    uint64_t inv_view_sounds = 0u;
    std::vector<std::pair<int32_t, int32_t>> live_pick_items;
    /* RT-22 follow-up: the task bar (object 0x570508, chunk TASK) whose button 1 sets byte
     * 0x583232. Scripted pointer gestures for --live-click-at SCENE:X,Y. */
    TaskbarLayout bar_layout{};
    Taskbar bar{};
    bool bar_ready = false, bar_missing = false;
    bool bar_swallow_up = false;
    int32_t bar_last_hit = -2;
    uint64_t bar_sound_requests = 0u;
    struct LiveClickAt { int32_t scene, x, y; };
    std::vector<LiveClickAt> live_click_ats;
    A35World movie_world{};
    /* Process globals mirrored by the controller, alongside the owning
     * caption module's cursor_layer_enabled (0x5d1639). Phase 2 restores
     * modal state only; it does not restore cleared layer words. */
    int32_t layer_5d16cd = 0, layer_5d1683 = 0, movie_visible_5d19fb = 0;
    SessionA35Bink *movie_bink = nullptr;
    BinkPlayerFrame movie_frame{};
    std::vector<uint8_t> movie_surface;
    A35Rect movie_source{}, movie_destination{};
    uint64_t movie_generation = 0, movie_composed = 0;
    uint32_t movie_mix_captures = 0;
    /* RT-4 dependency leaves 11..21. */
    SessionConditions *conditions_binding = nullptr;
    SessionConditionsCrtRand condition_rand{};
    uint32_t condition_rand_seed = 0;
    bool condition_rand_seed_set = false;
    /* RT-5: scene-exit state machine (0x583999 states 1..4), the CSpecialEffect
     * object shared with the 0x28 leaf, and the host-side capture buffers the
     * effect controller reads (0x447ac7 targets). */
    SessionExit exit_state{};
    SessionA28Binding *a28 = nullptr;
    std::vector<uint8_t> exit_primary_rgb565;
    std::vector<uint8_t> exit_source_words;
    std::vector<uint8_t> exit_destination_words;
    uint32_t exit_sequence_audio_pumps = 0, exit_sequence_graphics_pumps = 0;
    uint32_t exit_sequence_presents = 0;
    /* DAT_005bb1ca, shared "cursor allowed" process global written by 0x62. */
    int32_t start_flag_5bb1ca = 0;
    /* DAT_005bb50b as set at scene entry (0x439f20..0x439f41 copies
     * DAT_005bb599, the frame word of the scene-change request). */
    int32_t selector_entry_frame = 0;
    /* DAT_005bb595 -> 0x5bb593 -> 0x5bb587 (0x439f2e, 0x43a3a0): the vertical
     * scroll word of the same scene-change request. After entry the live
     * selector is owned by the navigation globals (nav.selector) and mirrored
     * here for the providers that read it. */
    int32_t selector_entry_scroll = 0;
    bool selector_entry_valid = false;
    bool selector_logged = false;
#ifdef BLACKMOOR_NATIVE_APP_TEST_HOOKS
    /* Test hook: stands in for the RT-2 pointer path with one synthetic
     * accepted event (scan + accept reducers + candidate store). */
    bool test_a62_accept = false;
    bool test_a62_accept_done = false;
    /* RT-17 test hook: pretend the scene has a row of a cascade-member type, so the app-level
     * priority_clear wiring (named limit instead of a zone/generic scan) can be observed. */
    bool test_members_busy = false;
    /* RT-13 test hook: seed the New Game inventory (item ids in list order and
     * the held item) right after world_init_apply_new_game, so the raw 0x79
     * removal can be followed through the real app wiring. */
    std::vector<int16_t> test_inventory;
    int test_held = -2;
    /* RT-5 test hook: load this scene instead of the requested target so the
     * exit effect can be followed into a successor the executor can create.
     * It changes game flow and exists only in the test-hooks build. */
    int32_t test_exit_redirect_from = -1;
    int32_t test_exit_redirect = -1;
    /* RT-15 test hook: on entering SCENE the selector 0x5bb50b becomes FRAME,
     * standing in for the navigation producer (0x43c2b7.., unbound) that moves
     * it in the original. Test-hooks build only. */
    /* RT-16: the option may repeat (one pair per scene). */
    std::vector<std::pair<int32_t, int32_t>> test_selectors;
    /* RT-20 test hook: the world provider of the raw 0x0c binding refuses (the selector and start
     * flag cannot be read), which stops the session at the first 0x0c row before any effect. It
     * stands in for a host failure and exists only in the test-hooks build. */
    bool test_a0c_refuse_world = false;
    /* RT-21 test hook: on entering SCENE the held (selected) inventory item becomes ITEM,
     * standing in for the unbound inventory UI that selects it in the original. May repeat.
     * Test-hooks build only. */
    std::vector<std::pair<int32_t, int32_t>> test_held_at;
#endif
    /* Headless runs render the offline audio graph a fixed amount per update;
     * live runs leave this zero and let the output device pace playback. */
    uint32_t offline_audio_frames_per_update = 0;
    NativeNewGameState new_game;
    WorldClockSession world_clock_session{};
    WorldClockEffectSink world_clock_effect_sink{};
    SceneConditionState session_conditions{};
    NativeCaptionRuntime captions;
    ActionFamily64Backend action64_backend{};
    FILE *log = nullptr;
    std::map<std::string, HostImage> images;
    std::vector<uint8_t> framebuffer;
    uint32_t started = 0, stop_after = 0;
    uint32_t session_tick_sample = 0;
    int32_t post_clock_object_enabled_001c = 0;
    uint8_t post_clock_aux_enabled_61c6ad = 0;
    int32_t post_clock_aux_value_61c7bd = 0;
    uint8_t closed_captioning = 0;
    int32_t pointer_x = -1, pointer_y = -1;
    /* RT-6: the recovered pointer producer (RT-2). One retained candidate
     * (0x5c39e5) lives in input_state; the session sequences it. */
    SessionInputState input_state{};
    ProvisionalCursorProvider cursor_provider{};
    int32_t logged_candidate = -2;
    /* RT-17: the view-navigation producer (session_navigation). The globals
     * are those of the original named in session_navigation.h; the values the
     * scene setup 0x4381f4 derives are rebuilt at every scene entry by
     * nav_begin_scene. gate_deadline (0x63a5c8) persists across scenes. */
    NavGlobals nav{};
    NavBands nav_bands{};
    NavCursor nav_cursor{};
    bool nav_boot_read = false;
    int16_t nav_band_words[2] = {0, 0};         /* 0x5b0260 / 0x5b0262 (BSUM[333], [335]) */
    bool nav_delay_override = false;            /* 0x5b0288 (BSUM[373]) */
    int16_t nav_delay_words[2] = {0, 0};        /* 0x5b0289 / 0x5b028b (BSUM[374], [376]) */
    int32_t nav_auto_move = 1;                  /* Game.ini AutoMove, default 1 */
    bool nav_auto_move_from_ini = false;
    bool nav_members_idle = true;               /* no row of a cascade-member type */
    int32_t scene_native_frames = 0;            /* BIK frame count of the current scene */
    int32_t scene_native_width = 0, scene_native_height = 0;
    int32_t logged_nav_state = -1;
    uint64_t nav_steps = 0, nav_selector_moves = 0;
    bool nav_scene_ready = false;
    /* RT-17: frame-hold presentation of a multi-frame scene. The original shows
     * frame [0x5bb50b] of the scene movie (0x43ce92..0x43cf12, 0x4f7c36); a
     * second player seeks to it (BinkGoto equivalent) once navigation or the
     * scene entry selects a frame. */
    BinkPlayer *nav_player = nullptr;
    std::string scene_video_path;
    int32_t nav_shown_frame = -1;
    uint64_t nav_frame_failures = 0;
    /* RT-14: the overlay hot-rectangle failure is logged once per scene. */
    bool a36_hot_rects_failure_logged = false;
    bool primary_down = false;
    bool primary_pressed = false, primary_released = false;
    bool failure = false;
    bool command_reported = false;
    bool scene_runtime_enabled = false;
    bool session_block_reported = false;
    bool session_transition_reported = false;
    /* RT-13: a blocked session stops every later tick, so pointer input is
     * ignored. The block is reported once; ignored input is counted. */
    uint64_t blocked_input_ignored = 0u;
    int last_stage = -1, last_hover = -2;
    int16_t initial_scene = 0;
    int16_t current_scene_id = 0;
    int16_t transition_source_scene_id = 0;
    int32_t scene_current_frame = 0;
    std::array<int32_t, 12> view_words{};
    std::string game_directory;
    HostImage scene_frame;
    HostImage transition_source_frame;
    bool has_scene_frame = false;
    bool has_transition_source_frame = false;
    std::vector<uint8_t> a28_primary_rgb565;
    std::vector<uint8_t> a28_target_rgb565;
    std::vector<uint8_t> a28_source_capture_words;
    std::vector<uint8_t> a28_destination_capture_words;
    bool a28_capture_pair_ready = false;
    StartupMenuFrame last_frame{};
    StartupMenuRect scene_source{}, scene_destination{};
};

static void record(NativeApp *app, const char *format, ...)
{
    va_list arguments;
    va_start(arguments, format);
    if (app->log) {
        std::vfprintf(app->log, format, arguments);
        std::fputc('\n', app->log);
        std::fflush(app->log);
    }
    va_end(arguments);
}

static std::string trim(const std::string &value)
{
    const size_t begin = value.find_first_not_of(" \t\r\n");
    if (begin == std::string::npos) return {};
    return value.substr(begin, value.find_last_not_of(" \t\r\n") - begin + 1);
}

/* Narrow host configuration adapter. It reads the original patch-loading
 * switch and the ClosedCaptioning integer consumed by 0x4348b0. Missing
 * ClosedCaptioning uses the source GetPrivateProfileIntA default of zero. */
static bool game_ini_configuration(const std::string &directory,
                                   int *external_cif_enabled,
                                   uint8_t *captions_enabled)
{
    FILE *file = std::fopen((directory + "/Game.ini").c_str(), "rb");
    if (!file) return false;
    char line[4096];
    bool data_section = false, found_external = false;
    bool found_captions = false;
    *captions_enabled = 0u;
    while (std::fgets(line, sizeof(line), file)) {
        std::string value = trim(line);
        const size_t comment = value.find(';');
        if (comment != std::string::npos) value = trim(value.substr(0, comment));
        if (value.empty()) continue;
        if (value.front() == '[') {
            data_section = value == "[Nancy Data]";
            continue;
        }
        const size_t equal = value.find('=');
        if (!data_section || equal == std::string::npos) continue;
        const std::string key = trim(value.substr(0, equal));
        const std::string setting = trim(value.substr(equal + 1));
        if (key == "ExternalCifFileChecking" && !found_external) {
            if (setting != "0" && setting != "1") {
                std::fclose(file);
                return false;
            }
            *external_cif_enabled = setting == "1";
            found_external = true;
        } else if (key == "ClosedCaptioning" && !found_captions) {
            char *end = nullptr;
            const long parsed = std::strtol(setting.c_str(), &end, 10);
            if (setting.empty() || end == setting.c_str() || *end != '\0' ||
                parsed < INT_MIN || parsed > INT_MAX) {
                std::fclose(file);
                return false;
            }
            *captions_enabled = parsed != 0 ? 1u : 0u;
            found_captions = true;
        }
    }
    const bool success = found_external && !std::ferror(file);
    std::fclose(file);
    return success;
}

static HostImage *image(NativeApp *app, const char *name)
{
    auto found = app->images.find(name);
    if (found != app->images.end()) return &found->second;
    cif_image raw = CIF_IMAGE_INIT;
    GameResourceSource source;
    char error[256];
    if (!game_resources_load_image(app->resources, name, &raw, &source, error, sizeof(error))) {
        record(app, "image_error name=%s detail=%s", name, error);
        return nullptr;
    }
    HostImage value;
    value.width = raw.width;
    value.height = raw.height;
    try { value.rgba.resize((size_t)raw.width * raw.height * 4); }
    catch (...) { cif_image_destroy(&raw); throw; }
    const bool converted = cif_image_to_rgba(&raw, value.rgba.data(), value.rgba.size()) != 0;
    cif_image_destroy(&raw);
    if (!converted) { record(app, "image_error name=%s detail=RGBA conversion", name); return nullptr; }
    record(app, "image_loaded name=%s width=%u height=%u source=%s", name,
           value.width, value.height, source == GAME_RESOURCE_EXTERNAL_CIF ? "external-CIF" : "CIFTREE");
    return &app->images.emplace(name, std::move(value)).first->second;
}

static uint32_t read_u32_le(const uint8_t *bytes)
{
    return (uint32_t)bytes[0] | ((uint32_t)bytes[1] << 8) |
           ((uint32_t)bytes[2] << 16) | ((uint32_t)bytes[3] << 24);
}

static int32_t read_i32_le(const uint8_t *bytes)
{
    const uint32_t bits = read_u32_le(bytes);
    int32_t value;
    std::memcpy(&value, &bits, sizeof(value));
    return value;
}

static bool selected_boot_data_index(const NativeApp *app, size_t *data_index)
{
    if (app == nullptr || app->boot == nullptr || data_index == nullptr) return false;
    EngineBootSummary summary{};
    HiffChunkInfo bsum{};
    const uint8_t *payload = nullptr;
    size_t payload_size = 0;
    if (engine_boot_get_summary(app->boot, &summary) != ENGINE_BOOT_OK ||
        engine_boot_chunk_at(app->boot, summary.bsum_chunk_index, &bsum,
                             &payload, &payload_size) != ENGINE_BOOT_OK ||
        std::strcmp(bsum.id, "BSUM") != 0 ||
        payload_size < ENGINE_BOOT_BSUM_SIZE) return false;
    *data_index = bsum.data_index;
    return true;
}

/* Caption records must come from the DATA record selected by EngineBoot,
 * which is the one whose BSUM supplied the initial settings. */
static bool find_boot_payload(const NativeApp *app, const char *id,
                              const uint8_t **payload, size_t *payload_size)
{
    size_t selected_data = SIZE_MAX;
    size_t matches = 0;
    if (app == nullptr || id == nullptr || payload == nullptr ||
        payload_size == nullptr || !selected_boot_data_index(app, &selected_data)) {
        return false;
    }
    *payload = nullptr;
    *payload_size = 0u;
    for (size_t index = 0; index < engine_boot_chunk_count(app->boot); ++index) {
        HiffChunkInfo chunk{};
        const uint8_t *candidate = nullptr;
        size_t candidate_size = 0;
        if (engine_boot_chunk_at(app->boot, index, &chunk, &candidate,
                                 &candidate_size) != ENGINE_BOOT_OK) return false;
        if (chunk.data_index != selected_data || std::strcmp(chunk.id, id) != 0) continue;
        ++matches;
        *payload = candidate;
        *payload_size = candidate_size;
    }
    return matches == 1u;
}

static bool find_font_payload(GameResources *resources,
                              const uint8_t **font_payload,
                              size_t *font_payload_size,
                              Hiff **font_container,
                              GameResourceBytes *font_bytes,
                              char *error, size_t error_capacity)
{
    Hiff *hiff = nullptr;
    HiffSelectionInfo data_selection{};
    HiffSelectionInfo selected_info{};
    size_t font_data_index = SIZE_MAX;
    const uint8_t *payload = nullptr;
    size_t payload_size = 0;
    size_t matching_chunks = 0;

    if (resources == nullptr || font_payload == nullptr || font_payload_size == nullptr ||
        font_container == nullptr || font_bytes == nullptr) return false;
    *font_payload = nullptr;
    *font_payload_size = 0u;
    *font_container = nullptr;
    if (!game_resources_load_bytes(resources, "FONT", font_bytes,
                                   error, error_capacity)) return false;
    hiff = hiff_open_memory(font_bytes->bytes, font_bytes->length,
                            error, error_capacity);
    if (hiff == nullptr || hiff_select_data(hiff, "FONT") != HIFF_OK ||
        hiff_get_selected_data(hiff, nullptr, nullptr, &data_selection) != HIFF_OK) {
        hiff_close(hiff);
        return false;
    }
    font_data_index = data_selection.data_index;
    for (size_t index = 0; index < hiff_chunk_count(hiff); ++index) {
        HiffChunkInfo chunk{};
        if (hiff_chunk_at(hiff, index, &chunk) != HIFF_OK) {
            hiff_close(hiff);
            return false;
        }
        if (chunk.data_index == data_selection.data_index &&
            std::strcmp(chunk.id, "FONT") == 0) {
            ++matching_chunks;
        }
    }
    if (matching_chunks != 1u) {
        hiff_close(hiff);
        return false;
    }
    if (hiff_select_first(hiff, "FONT") != HIFF_OK ||
        hiff_get_selected_chunk(hiff, &payload, &payload_size,
                                &selected_info) != HIFF_OK) {
        hiff_close(hiff);
        return false;
    }
    /* The resource may contain other DATA records with a same-named chunk;
     * walk the id cursor until the exact selected FONT record is reached. */
    while (selected_info.data_index != font_data_index) {
        if (hiff_select_next(hiff, "FONT") != HIFF_OK ||
            hiff_get_selected_chunk(hiff, &payload, &payload_size,
                                    &selected_info) != HIFF_OK) {
            hiff_close(hiff);
            return false;
        }
    }
    if (payload == nullptr || payload_size == 0u) {
        hiff_close(hiff);
        return false;
    }
    *font_payload = payload;
    *font_payload_size = payload_size;
    *font_container = hiff;
    return true;
}

static NativeRaw555Image *load_native_raw555_image(NativeApp *app,
                                                   const char *requested_name)
{
    if (app == nullptr || requested_name == nullptr || app->resources == nullptr) return nullptr;
    std::string name(requested_name);
    if (name.size() > 0x18u) name.resize(0x18u); /* 0x4c2790 name bound. */
    auto found = app->captions.image_handles.find(name);
    if (found != app->captions.image_handles.end()) {
        auto image_found = app->captions.raw_images.find(found->second);
        return image_found == app->captions.raw_images.end() ? nullptr : &image_found->second;
    }

    cif_image decoded = CIF_IMAGE_INIT;
    GameResourceSource source = GAME_RESOURCE_ARCHIVE;
    char error[256] = {};
    if (!game_resources_load_image(app->resources, name.c_str(), &decoded, &source,
                                   error, sizeof(error))) {
        record(app, "caption_image_error name=%s detail=%s", name.c_str(), error);
        return nullptr;
    }
    const size_t row_bytes = (size_t)decoded.width * 2u;
    const size_t required = decoded.height == 0u ? SIZE_MAX :
        (size_t)(decoded.height - 1u) * decoded.pitch + row_bytes;
    if (decoded.depth != 16u || decoded.width == 0u || decoded.height == 0u ||
        decoded.pitch < row_bytes || decoded.pixels == nullptr ||
        required > decoded.byte_count || decoded.byte_count > UINT32_MAX ||
        decoded.pitch > INT16_MAX || decoded.width > INT16_MAX ||
        decoded.height > INT16_MAX) {
        record(app, "caption_image_error name=%s detail=unsupported-or-truncated-RGB555",
               name.c_str());
        cif_image_destroy(&decoded);
        return nullptr;
    }

    NativeRaw555Image raw;
    raw.width = decoded.width;
    raw.height = decoded.height;
    raw.pitch = decoded.pitch;
    try { raw.pixels.assign(decoded.pixels, decoded.pixels + decoded.byte_count); }
    catch (...) {
        cif_image_destroy(&decoded);
        throw;
    }
    cif_image_destroy(&decoded);
    cif_pixel_format conversion{};
    conversion.enabled = 1u;
    for (size_t channel = 0; channel < 3u; ++channel) {
        conversion.shifts[channel] = app->captions.pixel_format.shifts[channel];
        conversion.channel_bits[channel] =
            (int8_t)app->captions.pixel_format.channel_bits[channel];
    }
    cif_pixels_convert_555(raw.pixels.data(), (uint32_t)raw.pixels.size(), &conversion);
    if (app->captions.next_image_handle == 0u ||
        app->captions.next_image_handle >= UINT32_C(0xf0000000)) {
        record(app, "caption_image_error name=%s detail=handle-space-exhausted", name.c_str());
        return nullptr;
    }
    const uint32_t handle = app->captions.next_image_handle++;
    auto inserted = app->captions.raw_images.emplace(handle, std::move(raw));
    app->captions.image_handles.emplace(name, handle);
    record(app, "caption_image_loaded name=%s handle=%u width=%u height=%u pitch=%u "
           "format=RGB555 source=%s raw_bytes=%zu",
           name.c_str(), handle, inserted.first->second.width,
           inserted.first->second.height, inserted.first->second.pitch,
           source == GAME_RESOURCE_EXTERNAL_CIF ? "external-CIF" : "CIFTREE",
           inserted.first->second.pixels.size());
    return &inserted.first->second;
}

static uint32_t native_caption_load_image(void *context, const char *name,
                                         const char *purpose)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    NativeRaw555Image *loaded = load_native_raw555_image(app, name);
    if (loaded == nullptr) return 0u;
    (void)purpose;
    auto found = app->captions.image_handles.find(name);
    if (found == app->captions.image_handles.end()) {
        std::string bounded(name);
        if (bounded.size() > 0x18u) bounded.resize(0x18u);
        found = app->captions.image_handles.find(bounded);
    }
    return found == app->captions.image_handles.end() ? 0u : found->second;
}

static CaptionBackendStatus native_caption_load_font_sheet(
    void *context, int16_t font, const char *name, CaptionSurface *sheet)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    NativeRaw555Image *image = load_native_raw555_image(app, name);
    if (app == nullptr || image == nullptr || sheet == nullptr ||
        image->width > INT16_MAX || image->height > INT16_MAX ||
        image->pitch > INT16_MAX) return CAPTION_BACKEND_ERROR;
    sheet->pixels = image->pixels.data();
    sheet->width = (int16_t)image->width;
    sheet->height = (int16_t)image->height;
    sheet->pitch = (int16_t)image->pitch;
    record(app, "caption_font_sheet_acquired font=%d name=%s width=%u height=%u "
           "pitch=%u format=RGB555", font, name, image->width, image->height,
           image->pitch);
    return CAPTION_BACKEND_OK;
}

static void native_caption_release_font_sheet(void *context, int16_t font,
                                              CaptionSurface *sheet)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app != nullptr) record(app, "caption_font_sheet_released font=%d", font);
    if (sheet != nullptr) std::memset(sheet, 0, sizeof(*sheet));
}

static bool native_caption_pack_rgba(const NativeCaptionRuntime &captions,
                                     const uint8_t *rgba, uint8_t *packed)
{
    if (rgba == nullptr || packed == nullptr) return false;
    uint16_t word = 0u;
    for (size_t channel = 0; channel < 3u; ++channel) {
        const uint8_t bits = captions.pixel_format.channel_bits[channel];
        const uint8_t shift = captions.pixel_format.shifts[channel];
        const uint8_t mask = captions.pixel_format.masks[channel];
        if (bits == 0u || bits > 8u || shift >= 16u || mask == 0u ||
            (unsigned)shift + bits > 16u) return false;
        const size_t rgba_channel = channel == 0u ? 2u : channel == 2u ? 0u : 1u;
        const uint16_t value = (uint16_t)((rgba[rgba_channel] >> (8u - bits)) & mask);
        word = (uint16_t)(word | (uint16_t)(value << shift));
    }
    packed[0] = (uint8_t)word;
    packed[1] = (uint8_t)(word >> 8);
    return true;
}

static bool native_caption_unpack_rgba(const NativeCaptionRuntime &captions,
                                       uint16_t word, uint8_t *rgba)
{
    if (rgba == nullptr) return false;
    for (size_t channel = 0; channel < 3u; ++channel) {
        const uint8_t bits = captions.pixel_format.channel_bits[channel];
        const uint8_t shift = captions.pixel_format.shifts[channel];
        const uint8_t mask = captions.pixel_format.masks[channel];
        if (bits == 0u || bits > 8u || shift >= 16u || mask == 0u ||
            (unsigned)shift + bits > 16u) return false;
        const uint32_t value = (word >> shift) & mask;
        const uint8_t expanded = (uint8_t)((value * 255u) / mask);
        const size_t rgba_channel = channel == 0u ? 2u : channel == 2u ? 0u : 1u;
        rgba[rgba_channel] = expanded;
    }
    rgba[3] = 255u;
    return true;
}

static bool native_caption_view_for_handle(NativeApp *app, uint32_t handle,
                                            CaptionCompositorView *view)
{
    if (app == nullptr || view == nullptr) return false;
    NativeCaptionRuntime &captions = app->captions;
    if (handle == captions.caption_surface_handle) {
        if (captions.caption_surface.pixels == nullptr ||
            captions.caption_surface.width <= 0 || captions.caption_surface.height <= 0 ||
            captions.caption_surface.pitch <= 0) return false;
        view->pixels = captions.caption_surface.pixels;
        view->byte_capacity = captions.caption_pixels.size();
        view->width = captions.caption_surface.width;
        view->height = captions.caption_surface.height;
        view->pitch_bytes = captions.caption_surface.pitch;
        view->format = captions.compositor_format;
        return true;
    }
    if (handle == captions.framed_surface_handle) {
        if (captions.framed_surface.pixels == nullptr ||
            captions.framed_surface.width <= 0 || captions.framed_surface.height <= 0 ||
            captions.framed_surface.pitch <= 0) return false;
        view->pixels = captions.framed_surface.pixels;
        view->byte_capacity = captions.framed_pixels.size();
        view->width = captions.framed_surface.width;
        view->height = captions.framed_surface.height;
        view->pitch_bytes = captions.framed_surface.pitch;
        view->format = captions.compositor_format;
        return true;
    }
    const auto found = captions.raw_images.find(handle);
    if (found == captions.raw_images.end() || found->second.pixels.empty() ||
        found->second.width == 0u || found->second.height == 0u ||
        found->second.width > INT32_MAX || found->second.height > INT32_MAX ||
        found->second.pitch == 0u || found->second.pitch > INT32_MAX) return false;
    view->pixels = const_cast<uint8_t *>(found->second.pixels.data());
    view->byte_capacity = found->second.pixels.size();
    view->width = (int32_t)found->second.width;
    view->height = (int32_t)found->second.height;
    view->pitch_bytes = (int32_t)found->second.pitch;
    view->format = captions.compositor_format;
    return true;
}

/* Build the host's persistent RGB555/565 destination from the actual saved
 * Frame surface, then overlay only the decoded Bink scene viewport. The Frame
 * is a CIFTREE taskbar image; it is not treated as a captured scene frame. */
static bool native_a35_compose(NativeApp *app);

static bool seed_native_caption_backbuffer(NativeApp *app)
{
    if (app == nullptr || !app->captions.initialized || !app->has_scene_frame ||
        app->captions.transfer_failed_sticky) return false;
    NativeCaptionRuntime &captions = app->captions;
    CaptionCompositorView frame_view{};
    if (!native_caption_view_for_handle(app, captions.lifecycle.taskbar.saved_surface,
                                        &frame_view) ||
        frame_view.width != 640 || frame_view.height != 480 ||
        frame_view.format != captions.compositor_format ||
        captions.backbuffer_pixels.size() != 640u * 480u * 2u) return false;

    const size_t row_bytes = 640u * 2u;
    if (frame_view.pitch_bytes < (int32_t)row_bytes ||
        frame_view.byte_capacity < (size_t)(frame_view.height - 1) *
            (size_t)frame_view.pitch_bytes + row_bytes) return false;
    for (size_t row = 0; row < 480u; ++row) {
        std::memcpy(captions.backbuffer_pixels.data() + row * row_bytes,
                    frame_view.pixels + row * (size_t)frame_view.pitch_bytes,
                    row_bytes);
    }

    const int64_t copy_width = (int64_t)app->scene_source.right -
                               app->scene_source.left + 1;
    const int64_t copy_height = (int64_t)app->scene_source.bottom -
                                app->scene_source.top + 1;
    const int64_t dest_width = (int64_t)app->scene_destination.right -
                               app->scene_destination.left + 1;
    const int64_t dest_height = (int64_t)app->scene_destination.bottom -
                                app->scene_destination.top + 1;
    if (copy_width <= 0 || copy_height <= 0 || copy_width != dest_width ||
        copy_height != dest_height || app->scene_source.left < 0 ||
        app->scene_source.top < 0 || app->scene_destination.left < 0 ||
        app->scene_destination.top < 0 || app->scene_destination.right >= 640 ||
        app->scene_destination.bottom >= 480 ||
        app->scene_source.right >= (int32_t)app->scene_frame.width ||
        app->scene_source.bottom >= (int32_t)app->scene_frame.height ||
        app->scene_frame.width == 0u || app->scene_frame.height == 0u ||
        (size_t)app->scene_frame.width > SIZE_MAX / 4u ||
        (size_t)app->scene_frame.height > SIZE_MAX /
            ((size_t)app->scene_frame.width * 4u) ||
        app->scene_frame.rgba.size() < (size_t)app->scene_frame.width *
            (size_t)app->scene_frame.height * 4u) return false;

    for (int64_t row = 0; row < copy_height; ++row) {
        const int32_t source_y = app->scene_source.top + (int32_t)row;
        const int32_t dest_y = app->scene_destination.top + (int32_t)row;
        for (int64_t column = 0; column < copy_width; ++column) {
            const int32_t source_x = app->scene_source.left + (int32_t)column;
            const int32_t dest_x = app->scene_destination.left + (int32_t)column;
            const size_t rgba_offset = ((size_t)source_y * app->scene_frame.width +
                                        (size_t)source_x) * 4u;
            const size_t destination_offset = ((size_t)dest_y * 640u +
                                               (size_t)dest_x) * 2u;
            if (!native_caption_pack_rgba(captions, app->scene_frame.rgba.data() +
                                          rgba_offset,
                                          captions.backbuffer_pixels.data() +
                                          destination_offset)) return false;
        }
    }
    if (!native_a35_compose(app)) return false;
    captions.backbuffer_ready = true;
    ++captions.backbuffer_seed_count;
    record(app, "caption_backbuffer_seeded width=640 height=480 format=%s pitch=1280 "
           "base=CIFTREE-Frame overlay=decoded-background-viewport viewport=%d,%d,%d,%d "
           "scope=host-adapter-original-composed-framebuffer=unverified",
           captions.compositor_format == CAPTION_COMPOSITOR_RGB555_LE ? "RGB555" : "RGB565",
           app->scene_destination.left, app->scene_destination.top,
           app->scene_destination.right, app->scene_destination.bottom);
    return true;
}

static bool native_caption_region_metrics(NativeApp *app, size_t *frame_equal,
                                         size_t *frame_different,
                                         size_t *caption_non_key,
                                         uint64_t *region_hash)
{
    if (app == nullptr || frame_equal == nullptr || frame_different == nullptr ||
        caption_non_key == nullptr || region_hash == nullptr ||
        !app->captions.backbuffer_ready) return false;
    CaptionCompositorView frame_view{};
    if (!native_caption_view_for_handle(app, app->captions.lifecycle.taskbar.saved_surface,
                                        &frame_view)) return false;
    const CaptionRect &rect = app->captions.lifecycle.taskbar.cc_rect;
    if (rect.left < 0 || rect.top < 0 || rect.right < rect.left ||
        rect.bottom < rect.top || rect.right >= 640 || rect.bottom >= 480 ||
        frame_view.width != 640 || frame_view.height != 480) return false;
    *frame_equal = 0u;
    *frame_different = 0u;
    *caption_non_key = 0u;
    uint64_t hash = UINT64_C(14695981039346656037);
    for (int32_t y = rect.top; y <= rect.bottom; ++y) {
        for (int32_t x = rect.left; x <= rect.right; ++x) {
            const size_t offset = ((size_t)y * 640u + (size_t)x) * 2u;
            const uint8_t *pixel = app->captions.backbuffer_pixels.data() + offset;
            const uint8_t *saved = frame_view.pixels + (size_t)y *
                (size_t)frame_view.pitch_bytes + (size_t)x * 2u;
            if (pixel[0] == saved[0] && pixel[1] == saved[1]) ++*frame_equal;
            else ++*frame_different;
            hash ^= pixel[0]; hash *= UINT64_C(1099511628211);
            hash ^= pixel[1]; hash *= UINT64_C(1099511628211);
        }
    }
    /* The writer's caption source rectangle is TBOX + 0x28. */
    const uint8_t *tbox = app->captions.geometry.tbox;
    CaptionRect source_rect{read_i32_le(tbox + 0x28u), read_i32_le(tbox + 0x2cu),
                            read_i32_le(tbox + 0x30u), read_i32_le(tbox + 0x34u)};
    if (source_rect.left < 0 || source_rect.top < 0 ||
        source_rect.right < source_rect.left || source_rect.bottom < source_rect.top ||
        source_rect.right >= app->captions.caption_surface.width ||
        source_rect.bottom >= app->captions.caption_surface.height) return false;
    for (int32_t y = source_rect.top; y <= source_rect.bottom; ++y) {
        for (int32_t x = source_rect.left; x <= source_rect.right; ++x) {
            const uint8_t *pixel = app->captions.caption_pixels.data() +
                (size_t)y * (size_t)app->captions.caption_surface.pitch +
                (size_t)x * 2u;
            const uint16_t value = (uint16_t)(pixel[0] | ((uint16_t)pixel[1] << 8));
            if (value != app->captions.pixel_format.color_key) ++*caption_non_key;
        }
    }
    *region_hash = hash;
    return true;
}

static bool native_caption_present_rgba(NativeApp *app)
{
    if (app == nullptr || !app->captions.backbuffer_ready ||
        app->framebuffer.size() != 640u * 480u * 4u) return false;
    for (size_t index = 0; index < 640u * 480u; ++index) {
        const uint8_t *packed = app->captions.backbuffer_pixels.data() + index * 2u;
        const uint16_t word = (uint16_t)(packed[0] | ((uint16_t)packed[1] << 8));
        if (!native_caption_unpack_rgba(app->captions, word,
                                        app->framebuffer.data() + index * 4u)) return false;
    }
    return true;
}

static CaptionLifecycleBackendStatus native_caption_lifecycle_blit(
    void *context, const CaptionBlit *blit)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || blit == nullptr) return CAPTION_LIFECYCLE_BACKEND_ERROR;
    NativeCaptionRuntime &captions = app->captions;
    ++captions.transfer_attempts;
    const uint64_t attempt = captions.transfer_attempts;
    CaptionCompositorView source{};
    CaptionCompositorView destination{};
    destination.pixels = captions.backbuffer_pixels.data();
    destination.byte_capacity = captions.backbuffer_pixels.size();
    destination.width = 640;
    destination.height = 480;
    destination.pitch_bytes = 1280;
    destination.format = captions.compositor_format;
    int status = CAPTION_COMPOSITOR_OK;
    if (captions.transfer_failed_sticky || !captions.backbuffer_ready ||
        !native_caption_view_for_handle(app, blit->surface, &source)) {
        status = CAPTION_COMPOSITOR_ERR_UNSUPPORTED;
    }
#ifdef BLACKMOOR_NATIVE_APP_TEST_HOOKS
    if (status == CAPTION_COMPOSITOR_OK && captions.test_fail_blit_index != 0u &&
        attempt == captions.test_fail_blit_index) {
        status = CAPTION_COMPOSITOR_ERR_UNSUPPORTED;
        record(app, "caption_transfer_test_injected_failure attempt=%llu",
               (unsigned long long)attempt);
    }
#endif
    if (status == CAPTION_COMPOSITOR_OK) {
        status = caption_compositor_blit(&source, &destination, blit->kind,
                                         &blit->src, &blit->dst,
                                         captions.pixel_format.color_key);
    }
    if (status != CAPTION_COMPOSITOR_OK) {
        captions.transfer_blocked = true;
        captions.transfer_failed_sticky = true;
        record(app, "caption_transfer_failed tick=%llu attempt=%llu successes=%llu "
               "kind=%d handle=%u label=%s status=%d src=%d,%d,%d,%d dst=%d,%d,%d,%d "
               "prefix_preserved=1 retry=disabled",
               (unsigned long long)captions.transfer_tick,
               (unsigned long long)attempt,
               (unsigned long long)captions.transfer_successes,
               blit->kind, blit->surface, blit->label ? blit->label : "unknown",
               status, blit->src.left, blit->src.top, blit->src.right, blit->src.bottom,
               blit->dst.left, blit->dst.top, blit->dst.right, blit->dst.bottom);
        return CAPTION_LIFECYCLE_BACKEND_ERROR;
    }
    ++captions.transfer_successes;
    record(app, "caption_transfer_applied tick=%llu attempt=%llu success=%llu "
           "kind=%d handle=%u label=%s src=%d,%d,%d,%d dst=%d,%d,%d,%d "
           "format=%s destination=full-640x480-raw-backbuffer",
           (unsigned long long)captions.transfer_tick,
           (unsigned long long)attempt,
           (unsigned long long)captions.transfer_successes,
           blit->kind, blit->surface, blit->label ? blit->label : "unknown",
           blit->src.left, blit->src.top, blit->src.right, blit->src.bottom,
           blit->dst.left, blit->dst.top, blit->dst.right, blit->dst.bottom,
           captions.compositor_format == CAPTION_COMPOSITOR_RGB555_LE ? "RGB555" : "RGB565");
    return CAPTION_LIFECYCLE_BACKEND_OK;
}

#ifdef BLACKMOOR_NATIVE_APP_TEST_HOOKS
static bool native_caption_region_matches_frame(NativeApp *app,
                                                const CaptionRect &rect,
                                                size_t *matched_pixels)
{
    if (app == nullptr || matched_pixels == nullptr || !app->captions.backbuffer_ready)
        return false;
    CaptionCompositorView frame{};
    if (!native_caption_view_for_handle(app,
            app->captions.lifecycle.taskbar.saved_surface, &frame) ||
        rect.left < 0 || rect.top < 0 || rect.right < rect.left ||
        rect.bottom < rect.top || rect.right >= frame.width ||
        rect.bottom >= frame.height) return false;
    *matched_pixels = 0u;
    for (int32_t y = rect.top; y <= rect.bottom; ++y) {
        for (int32_t x = rect.left; x <= rect.right; ++x) {
            const size_t back_offset = ((size_t)y * 640u + (size_t)x) * 2u;
            const uint8_t *back = app->captions.backbuffer_pixels.data() + back_offset;
            const uint8_t *saved = frame.pixels + (size_t)y *
                (size_t)frame.pitch_bytes + (size_t)x * 2u;
            if (back[0] == saved[0] && back[1] == saved[1]) ++*matched_pixels;
        }
    }
    return true;
}
#endif

static bool native_caption_reset_probe(NativeApp *app)
{
#ifdef BLACKMOOR_NATIVE_APP_TEST_HOOKS
    if (app == nullptr || !app->captions.test_reset_after_composition ||
        app->captions.test_reset_probe_done) return true;
    NativeCaptionRuntime &captions = app->captions;
    uint8_t *caption_owner = captions.caption_pixels.data();
    uint8_t *framed_owner = captions.framed_pixels.data();
    uint8_t *backbuffer_owner = captions.backbuffer_pixels.data();
    auto frame_it = captions.raw_images.find(captions.lifecycle.taskbar.saved_surface);
    if (frame_it == captions.raw_images.end()) return false;
    uint8_t *frame_owner = frame_it->second.pixels.data();
    const int reset_status = caption_scene_reset(&captions.lifecycle,
                                                 &captions.lifecycle_backend);
    const int flags_status = reset_status == CAPTION_LIFECYCLE_OK
        ? caption_main_loop_flags(&captions.lifecycle) : reset_status;
    const int draw_status = flags_status == CAPTION_LIFECYCLE_OK
        ? caption_present_layers(&captions.lifecycle, &captions.lifecycle_backend,
                                 captions.caption_surface_handle,
                                 captions.framed_surface_handle,
                                 &captions.framed_destination)
        : flags_status;
    size_t area_matched = 0u;
    const bool area_compared = native_caption_region_matches_frame(
        app, captions.lifecycle.taskbar.area_dst, &area_matched);
    const size_t area_pixels =
        (size_t)(captions.lifecycle.taskbar.area_dst.right -
                 captions.lifecycle.taskbar.area_dst.left + 1) *
        (size_t)(captions.lifecycle.taskbar.area_dst.bottom -
                 captions.lifecycle.taskbar.area_dst.top + 1);
    const bool owners_stable = caption_owner == captions.caption_pixels.data() &&
        framed_owner == captions.framed_pixels.data() &&
        backbuffer_owner == captions.backbuffer_pixels.data() &&
        frame_owner == frame_it->second.pixels.data();
    const bool flags_reset = captions.writer_globals.caption_visible_flag == 0 &&
        captions.writer_globals.caption_finish_flag == 0 &&
        captions.writer_globals.frame_open == 0u &&
        captions.lifecycle.shared->framed_ready == 0;
    record(app, "caption_injected_reset_probe injected=1 actual_scene_replacement=0 "
           "reset_api=caption_scene_reset reset=%d flags=%d draw=%d owners_stable=%d "
           "flags_reset=%d area_frame_matches=%zu/%zu transfer_attempts=%llu "
           "transfer_successes=%llu order=RestoreCCTextBox,caption-layer,"
           "scene-reset-RestoreTaskbarArea,post-reset-layers",
           reset_status, flags_status, draw_status, owners_stable, flags_reset,
           area_matched, area_pixels,
           (unsigned long long)captions.transfer_attempts,
           (unsigned long long)captions.transfer_successes);
    captions.test_reset_probe_done = true;
    if (reset_status != CAPTION_LIFECYCLE_OK || flags_status != CAPTION_LIFECYCLE_OK ||
        draw_status != CAPTION_LIFECYCLE_OK || !owners_stable || !flags_reset ||
        !area_compared || area_matched != area_pixels) {
        captions.transfer_failed_sticky = true;
        return false;
    }
#else
    (void)app;
#endif
    return true;
}

static bool native_caption_reseed_visible_probe(NativeApp *app)
{
#ifdef BLACKMOOR_NATIVE_APP_TEST_HOOKS
    if (app == nullptr || !app->captions.test_reseed_visible_caption ||
        app->captions.test_reseed_probe_done) return true;
    NativeCaptionRuntime &captions = app->captions;
    if (captions.writer_globals.caption_visible_flag == 0 ||
        captions.writer_globals.caption_finish_flag != 0) {
        record(app, "caption_reseed_probe_failed reason=caption-not-active");
        return false;
    }
    size_t before_equal = 0u, before_different = 0u, before_non_key = 0u;
    uint64_t before_hash = 0u;
    if (!native_caption_region_metrics(app, &before_equal, &before_different,
                                       &before_non_key, &before_hash) ||
        before_different == 0u || before_non_key == 0u) {
        record(app, "caption_reseed_probe_failed reason=initial-caption-pixels-missing");
        return false;
    }
    uint8_t *backbuffer_owner = captions.backbuffer_pixels.data();
    const uint64_t seed_before = captions.backbuffer_seed_count;
    if (!seed_native_caption_backbuffer(app)) {
        record(app, "caption_reseed_probe_failed reason=source-seed-failed");
        return false;
    }
    const int flags_status = caption_main_loop_flags(&captions.lifecycle);
    const int draw_status = flags_status == CAPTION_LIFECYCLE_OK
        ? caption_present_layers(&captions.lifecycle, &captions.lifecycle_backend,
                                 captions.caption_surface_handle,
                                 captions.framed_surface_handle,
                                 &captions.framed_destination)
        : flags_status;
    size_t after_equal = 0u, after_different = 0u, after_non_key = 0u;
    uint64_t after_hash = 0u;
    const bool measured = native_caption_region_metrics(app, &after_equal,
        &after_different, &after_non_key, &after_hash);
    const bool stable_owner = backbuffer_owner == captions.backbuffer_pixels.data();
    const bool caption_retained = captions.writer_globals.caption_visible_flag != 0 &&
        captions.writer_globals.caption_finish_flag == 0 &&
        captions.lifecycle.g.caption_layer_enabled != 0;
    const bool pixels_retained = measured && after_different != 0u &&
        after_non_key != 0u && before_hash == after_hash;
    record(app, "caption_reseed_probe provider=seed-current-Frame-and-decoded-background "
           "second_scene_session_tick=0 seeds=%llu->%llu flags=%d draw=%d "
           "caption_retained=%d pixels_retained=%d frame_equal=%zu frame_different=%zu "
           "caption_non_key=%zu hash=%016llx owner_stable=%d",
           (unsigned long long)seed_before,
           (unsigned long long)captions.backbuffer_seed_count,
           flags_status, draw_status, caption_retained, pixels_retained,
           after_equal, after_different, after_non_key,
           (unsigned long long)after_hash, stable_owner);
    captions.test_reseed_probe_done = true;
    return flags_status == CAPTION_LIFECYCLE_OK &&
        draw_status == CAPTION_LIFECYCLE_OK && stable_owner &&
        caption_retained && pixels_retained &&
        captions.backbuffer_seed_count == seed_before + 1u;
#else
    (void)app;
    return true;
#endif
}

static bool native_caption_finish_tick(NativeApp *app, uint8_t dispatch_attempted)
{
    if (app == nullptr || !app->captions.initialized) return true;
    NativeCaptionRuntime &captions = app->captions;
    if (!captions.backbuffer_ready && !seed_native_caption_backbuffer(app)) {
        record(app, "caption_composition_blocked reason=backbuffer-seed-unavailable");
        captions.transfer_failed_sticky = true;
        return false;
    }
    if (app->a36 != nullptr && session_a36_registered(app->a36) != 0u) {
        /* RT-14: the overlay entries of the render pass 0x4cf9f4 (layers 0..20),
         * drawn into the seeded back buffer before the caption layers. */
        size_t drawn = 0u;
        const int status = session_a36_render(app->a36, 0, 20, &drawn);
        if (status != OVERLAY36_OK) {
            record(app, "scene_a36_render_error status=%d detail=%s", status,
                   session_a36_failure(app->a36));
            captions.transfer_failed_sticky = true;
            return false;
        }
    }
    if (dispatch_attempted != 0u && captions.action_caption_attempted &&
        captions.last_writer_status != CAPTION_OK) {
        record(app, "caption_composition_stopped reason=writer-failed status=%d "
               "partial_backbuffer_prefix_preserved=1",
               captions.last_writer_status);
    } else if (!captions.transfer_failed_sticky) {
        int status = caption_main_loop_flags(&captions.lifecycle);
        if (status == CAPTION_LIFECYCLE_OK) {
            status = caption_present_layers(&captions.lifecycle,
                &captions.lifecycle_backend, captions.caption_surface_handle,
                captions.framed_surface_handle, &captions.framed_destination);
        }
        captions.last_lifecycle_status = status;
        if (status != CAPTION_LIFECYCLE_OK) {
            captions.transfer_failed_sticky = true;
            record(app, "caption_composition_blocked lifecycle_status=%d detail=%s "
                   "attempts=%llu successes=%llu partial_backbuffer_prefix_preserved=1 "
                   "retry=disabled",
                   status, caption_lifecycle_status_string(status),
                   (unsigned long long)captions.transfer_attempts,
                   (unsigned long long)captions.transfer_successes);
        }
    } else {
        record(app, "caption_composition_stopped reason=sticky-backend-failure "
               "attempts=%llu successes=%llu",
               (unsigned long long)captions.transfer_attempts,
               (unsigned long long)captions.transfer_successes);
    }
    if (!captions.transfer_failed_sticky &&
        dispatch_attempted != 0u && captions.action_caption_attempted &&
        captions.last_writer_status == CAPTION_OK &&
        !native_caption_reset_probe(app)) {
        record(app, "caption_reset_probe_failed prefix_preserved=1");
        captions.transfer_failed_sticky = true;
    }
    size_t frame_equal = 0u, frame_different = 0u, caption_non_key = 0u;
    uint64_t region_hash = 0u;
    if (!native_caption_region_metrics(app, &frame_equal, &frame_different,
                                       &caption_non_key, &region_hash)) {
        record(app, "caption_composition_metrics unavailable");
        captions.transfer_failed_sticky = true;
        return false;
    }
    record(app, "caption_composition_pixels tick=%llu attempts=%llu successes=%llu "
           "cc_rect=%d,%d,%d,%d frame_equal=%zu frame_different=%zu "
           "caption_non_key=%zu cc_fnv64=%016llx flags_visible=%d flags_finish=%d "
           "caption_layer=%d reset_layer=%d scope=Frame-plus-decoded-background",
           (unsigned long long)captions.transfer_tick,
           (unsigned long long)captions.transfer_attempts,
           (unsigned long long)captions.transfer_successes,
           captions.lifecycle.taskbar.cc_rect.left,
           captions.lifecycle.taskbar.cc_rect.top,
           captions.lifecycle.taskbar.cc_rect.right,
           captions.lifecycle.taskbar.cc_rect.bottom,
           frame_equal, frame_different, caption_non_key,
           (unsigned long long)region_hash,
           captions.writer_globals.caption_visible_flag,
           captions.writer_globals.caption_finish_flag,
           captions.lifecycle.g.caption_layer_enabled,
           captions.lifecycle.g.caption_restore_layer);
    if (!captions.transfer_failed_sticky &&
        dispatch_attempted != 0u && captions.action_caption_attempted &&
        captions.last_writer_status == CAPTION_OK &&
        !native_caption_reseed_visible_probe(app)) {
        captions.transfer_failed_sticky = true;
        record(app, "caption_reseed_probe_failed prefix_preserved=1");
        return false;
    }
    return native_caption_present_rgba(app);
}

static CaptionBackendStatus native_caption_restore_box(void *context)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr) return CAPTION_BACKEND_ERROR;
    const int status = caption_taskbar_restore_cc(&app->captions.lifecycle,
                                                   &app->captions.lifecycle_backend);
    app->captions.last_lifecycle_status = status;
    return status == CAPTION_LIFECYCLE_OK ? CAPTION_BACKEND_OK :
                                            CAPTION_BACKEND_ERROR;
}

static CaptionBackendStatus native_caption_close_frame(void *context)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr) return CAPTION_BACKEND_ERROR;
    const int status = caption_ctb_close(&app->captions.lifecycle,
                                          &app->captions.lifecycle_backend);
    app->captions.last_lifecycle_status = status;
    return status == CAPTION_LIFECYCLE_OK ? CAPTION_BACKEND_OK :
                                            CAPTION_BACKEND_ERROR;
}

static void native_caption_debug_log(void *context, const char *message)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app != nullptr) record(app, "caption_debug=%s", message ? message : "");
}

static ActionSoundBackendStatus native_action_sound_present_caption(
    void *context, const ActionSoundCaptionRequest *caption)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || caption == nullptr || !app->captions.initialized) {
        return ACTION_SOUND_BACKEND_ERROR;
    }
    app->captions.action_caption_attempted = true;
    app->captions.transfer_blocked = false;
    const size_t max_text_bytes = caption->kind == ACTION_SOUND_CAPTION_LITERAL
        ? ACTION_SOUND_MAX_LITERAL_BYTES
        : caption->kind == ACTION_SOUND_CAPTION_RESOLVED_AUTO_TEXT
            ? (size_t)INT16_MAX : 0u;
    if (max_text_bytes == 0u ||
        (caption->length != 0u && caption->bytes == nullptr) ||
        caption->terminator == nullptr || caption->terminator_length != 3u ||
        std::memcmp(caption->terminator, "<e>", 3u) != 0 ||
        caption->length > max_text_bytes ||
        caption->length > SIZE_MAX - caption->terminator_length - 1u) {
        return ACTION_SOUND_BACKEND_UNSUPPORTED;
    }
    std::vector<uint8_t> text;
    try { text.resize(caption->length + caption->terminator_length + 1u); }
    catch (...) { return ACTION_SOUND_BACKEND_ERROR; }
    if (caption->length != 0u)
        std::memcpy(text.data(), caption->bytes, caption->length);
    std::memcpy(text.data() + caption->length, caption->terminator,
                caption->terminator_length);
    text.back() = 0u;
    CaptionRequest request{text.data(), text.size(), CAPTION_MODE_CAPTION, 0u, 0u};
    const int status = caption_layout_write(&app->captions.fonts,
        &app->captions.geometry, &app->captions.pixel_format,
        &app->captions.writer_box, &app->captions.writer_globals,
        &app->captions.writer_backend, &app->captions.caption_surface,
        &request, &app->captions.last_writer_result);
    app->captions.last_writer_status = status;
    app->captions.action_caption_present_succeeded = status == CAPTION_OK;
    record(app, "caption_action_writer kind=%d bytes=%zu status=%d lines=%d glyphs=%u "
           "terminator_appended=%u surface_cleared=%u visible=%d finish=%d "
           "transfer_blocked=%d partial_surface_retained=1",
           caption->kind, caption->length, status,
           app->captions.last_writer_result.lines,
           app->captions.last_writer_result.glyphs_drawn,
           app->captions.last_writer_result.terminator_appended,
           app->captions.last_writer_result.surface_cleared,
           app->captions.writer_globals.caption_visible_flag,
           app->captions.writer_globals.caption_finish_flag,
           app->captions.transfer_blocked);
    if (status == CAPTION_OK) return ACTION_SOUND_BACKEND_OK;
    if (status == CAPTION_ERR_BACKEND && app->captions.transfer_blocked)
        return ACTION_SOUND_BACKEND_UNSUPPORTED;
    return ACTION_SOUND_BACKEND_ERROR;
}

static ActionSoundBackendStatus native_action_sound_resolve_auto_text(
    void *context, const uint8_t *key, size_t key_length,
    const uint8_t **text, size_t *text_length)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    size_t raw_length = 0u;
    if (text != nullptr) *text = nullptr;
    if (text_length != nullptr) *text_length = 0u;
    if (app == nullptr || key == nullptr || text == nullptr || text_length == nullptr ||
        app->captions.auto_text == nullptr) {
        return ACTION_SOUND_BACKEND_UNSUPPORTED;
    }
    app->captions.action_caption_lookup_attempted = true;
    const int status = autotext_lookup(app->captions.auto_text, key, key_length,
                                       text, &raw_length, text_length);
    if (status == AUTOTEXT_ERR_NOT_FOUND) {
        record(app, "caption_action_lookup result=missing key_bytes=%zu", key_length);
        return ACTION_SOUND_BACKEND_NO_RESOURCE;
    }
    if (status == AUTOTEXT_ERR_UNSUPPORTED) {
        record(app, "caption_action_lookup result=unsupported status=%d key_bytes=%zu",
               status, key_length);
        return ACTION_SOUND_BACKEND_UNSUPPORTED;
    }
    if (status != AUTOTEXT_OK) {
        record(app, "caption_action_lookup result=error status=%d key_bytes=%zu",
               status, key_length);
        return ACTION_SOUND_BACKEND_ERROR;
    }
    record(app, "caption_action_lookup result=found key_bytes=%zu text_bytes=%zu raw_bytes=%zu",
           key_length, *text_length, raw_length);
    return ACTION_SOUND_BACKEND_OK;
}

static ActionSoundBackendStatus native_action_sound_load(
    void *context, const ActionSoundAudioCommand *command)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || command == nullptr || app->live_audio == nullptr)
        return ACTION_SOUND_BACKEND_ERROR;
    return live_audio_load_sound(app->live_audio, command);
}

static ActionSoundBackendStatus native_action_sound_play(void *context,
                                                          uint16_t channel)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || app->live_audio == nullptr) return ACTION_SOUND_BACKEND_ERROR;
    return live_audio_play_sound(app->live_audio, channel);
}

static ActionSoundBackendStatus native_action_sound_is_playing(
    void *context, uint16_t channel, int *still_playing)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || app->live_audio == nullptr) return ACTION_SOUND_BACKEND_ERROR;
    return live_audio_is_playing(app->live_audio, channel, still_playing);
}

static ActionSoundBackendStatus native_action_sound_unload(void *context,
                                                            uint16_t channel)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || app->live_audio == nullptr) return ACTION_SOUND_BACKEND_ERROR;
    return live_audio_unload_sound(app->live_audio, channel);
}

static CaptionLifecycleBackendStatus native_caption_write_framed(
    void *context, uint8_t *text, size_t capacity)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || text == nullptr || !app->captions.initialized) {
        return CAPTION_LIFECYCLE_BACKEND_ERROR;
    }
    CaptionRequest request{text, capacity, CAPTION_MODE_FRAMED, 0u, 0u};
    const int status = caption_layout_write(&app->captions.fonts,
        &app->captions.geometry, &app->captions.pixel_format,
        &app->captions.writer_box, &app->captions.writer_globals,
        &app->captions.writer_backend, &app->captions.framed_surface,
        &request, &app->captions.last_writer_result);
    app->captions.last_writer_status = status;
    record(app, "caption_framed_writer status=%d lines=%d glyphs=%u "
           "surface_cleared=%u frame_open=%u",
           status, app->captions.last_writer_result.lines,
           app->captions.last_writer_result.glyphs_drawn,
           app->captions.last_writer_result.surface_cleared,
           app->captions.writer_globals.frame_open);
    return status == CAPTION_OK ? CAPTION_LIFECYCLE_BACKEND_OK :
                                  CAPTION_LIFECYCLE_BACKEND_ERROR;
}

static void native_caption_fatal(void *context, const char *message)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app != nullptr) record(app, "caption_lifecycle_fatal=%s", message ? message : "");
}

static bool initialize_caption_runtime(NativeApp *app)
{
    if (app == nullptr || app->boot == nullptr || app->resources == nullptr) return false;
    const uint8_t *tbox = nullptr, *sctb = nullptr, *task = nullptr, *font = nullptr;
    size_t tbox_size = 0, sctb_size = 0, task_size = 0, font_size = 0;
    GameResourceBytes font_bytes = GAME_RESOURCE_BYTES_INIT;
    Hiff *font_container = nullptr;
    char error[256] = {};
    EngineBootSummary summary{};
    if (engine_boot_get_summary(app->boot, &summary) != ENGINE_BOOT_OK ||
        !find_boot_payload(app, "TBOX", &tbox, &tbox_size) ||
        !find_boot_payload(app, "SCTB", &sctb, &sctb_size) ||
        !find_boot_payload(app, "TASK", &task, &task_size) ||
        task_size < 0x61u ||
        !find_font_payload(app->resources, &font, &font_size, &font_container,
                            &font_bytes, error, sizeof(error))) {
        record(app, "caption_runtime_error provider=resources detail=%s",
               error[0] ? error : "selected BOOT DATA missing TBOX/SCTB/TASK or FONT");
        hiff_close(font_container);
        game_resource_bytes_destroy(&font_bytes);
        return false;
    }
    if (app->closed_captioning != 0u) {
        GameResourceBytes text_bytes = GAME_RESOURCE_BYTES_INIT;
        if (!game_resources_load_bytes(app->resources, "AUTOTEXT", &text_bytes,
                                       error, sizeof(error))) {
            record(app, "caption_runtime_error provider=autotext detail=%s", error);
            return false;
        }
        const int text_status = autotext_open_memory(
            text_bytes.bytes, text_bytes.length, 0, &app->captions.auto_text,
            error, sizeof(error));
        game_resource_bytes_destroy(&text_bytes);
        if (text_status != AUTOTEXT_OK) {
            record(app, "caption_runtime_error provider=autotext status=%d detail=%s",
                   text_status, error);
            return false;
        }
        app->captions.auto_text_entry_count =
            autotext_entry_count(app->captions.auto_text);
    }
    const int pixel_status = caption_pixel_format_from_masks(
        UINT32_C(0x7c00), UINT32_C(0x03e0), UINT32_C(0x001f),
        summary.bsum_raw + 324u, &app->captions.pixel_format);
    const int compositor_status = pixel_status == CAPTION_OK
        ? caption_compositor_format_from_pixel_format(&app->captions.pixel_format,
                                                       &app->captions.compositor_format)
        : CAPTION_COMPOSITOR_ERR_FORMAT;
    const int fonts_status = pixel_status == CAPTION_OK
        ? caption_fonts_init(font, font_size, summary.font_count,
                             &app->captions.fonts) : pixel_status;
    const int geometry_status = fonts_status == CAPTION_OK
        ? caption_geometry_init(tbox, tbox_size, &app->captions.geometry)
        : fonts_status;
    hiff_close(font_container);
    game_resource_bytes_destroy(&font_bytes);
    if (geometry_status != CAPTION_OK || compositor_status != CAPTION_COMPOSITOR_OK) {
        record(app, "caption_runtime_error provider=layout pixel=%d compositor=%d "
               "fonts=%d geometry=%d",
               pixel_status, compositor_status, fonts_status, geometry_status);
        return false;
    }
    const int32_t caption_width = app->captions.geometry.caption_surface_width;
    const int32_t caption_height = app->captions.geometry.caption_surface_height;
    const int32_t framed_width = app->captions.geometry.framed_surface_width;
    const int32_t framed_height = app->captions.geometry.framed_surface_height;
    if (caption_width <= 0 || caption_height <= 0 || framed_width <= 0 ||
        framed_height <= 0 || caption_width > INT16_MAX / 2 ||
        framed_width > INT16_MAX / 2 ||
        (size_t)caption_width > SIZE_MAX / (size_t)caption_height / 2u ||
        (size_t)framed_width > SIZE_MAX / (size_t)framed_height / 2u) {
        record(app, "caption_runtime_error provider=surface detail=invalid TBOX dimensions");
        return false;
    }
    try {
        app->captions.caption_pixels.assign((size_t)caption_width *
                                            (size_t)caption_height * 2u, 0u);
        app->captions.framed_pixels.assign((size_t)framed_width *
                                           (size_t)framed_height * 2u, 0u);
        app->captions.backbuffer_pixels.assign(640u * 480u * 2u, 0u);
    } catch (...) {
        record(app, "caption_runtime_error provider=host detail=surface allocation");
        return false;
    }
    app->captions.caption_surface = {
        app->captions.caption_pixels.data(), (int16_t)caption_width,
        (int16_t)caption_height, (int16_t)(caption_width * 2)};
    app->captions.framed_surface = {
        app->captions.framed_pixels.data(), (int16_t)framed_width,
        (int16_t)framed_height, (int16_t)(framed_width * 2)};

    app->captions.lifecycle.shared = &app->captions.writer_globals;
    app->captions.lifecycle.geometry = &app->captions.geometry;
    app->captions.lifecycle.view_origin[0] = app->scene_destination.left;
    app->captions.lifecycle.view_origin[1] = app->scene_destination.top;
    app->captions.lifecycle_backend.context = app;
    app->captions.lifecycle_backend.load_image = native_caption_load_image;
    app->captions.lifecycle_backend.blit = native_caption_lifecycle_blit;
    app->captions.lifecycle_backend.write_framed_text = native_caption_write_framed;
    app->captions.lifecycle_backend.fatal = native_caption_fatal;
    app->captions.writer_backend.context = app;
    app->captions.writer_backend.load_font_sheet = native_caption_load_font_sheet;
    app->captions.writer_backend.release_font_sheet = native_caption_release_font_sheet;
    app->captions.writer_backend.close_frame_text = native_caption_close_frame;
    app->captions.writer_backend.restore_caption_box = native_caption_restore_box;
    app->captions.writer_backend.debug_log = native_caption_debug_log;

    const size_t frame_name_length = strnlen((const char *)task, 33u);
    if (frame_name_length == 0u || frame_name_length == 33u) {
        record(app, "caption_runtime_error provider=taskbar detail=invalid saved-image name");
        return false;
    }
    const std::string frame_name((const char *)task, frame_name_length);
    const uint32_t frame_handle = native_caption_load_image(app, frame_name.c_str(),
                                                             "CUITaskBar saved surface");
    if (frame_handle == 0u) {
        record(app, "caption_runtime_error provider=taskbar detail=Frame image unavailable");
        return false;
    }
    app->captions.lifecycle.taskbar.saved_surface = frame_handle;
    CaptionRect *taskbar_rects[] = {
        &app->captions.lifecycle.taskbar.area_src,
        &app->captions.lifecycle.taskbar.area_dst,
        &app->captions.lifecycle.taskbar.cc_rect
    };
    const size_t task_offsets[] = {0x21u, 0x31u, 0x51u};
    for (size_t rect = 0; rect < 3u; ++rect) {
        taskbar_rects[rect]->left = read_i32_le(task + task_offsets[rect]);
        taskbar_rects[rect]->top = read_i32_le(task + task_offsets[rect] + 4u);
        taskbar_rects[rect]->right = read_i32_le(task + task_offsets[rect] + 8u);
        taskbar_rects[rect]->bottom = read_i32_le(task + task_offsets[rect] + 12u);
    }
    app->captions.framed_destination = {
        read_i32_le(summary.bsum_raw + 0x114u),
        read_i32_le(summary.bsum_raw + 0x118u),
        read_i32_le(summary.bsum_raw + 0x11cu),
        read_i32_le(summary.bsum_raw + 0x120u)};
    if (app->captions.framed_destination.left < 0 ||
        app->captions.framed_destination.top < 0 ||
        app->captions.framed_destination.right < app->captions.framed_destination.left ||
        app->captions.framed_destination.bottom < app->captions.framed_destination.top ||
        app->captions.framed_destination.right >= 640 ||
        app->captions.framed_destination.bottom >= 480) {
        record(app, "caption_runtime_error provider=bsum detail=invalid framed destination");
        return false;
    }
    if (caption_ctb_load_chunk(&app->captions.lifecycle,
            &app->captions.lifecycle_backend, sctb, sctb_size) != CAPTION_LIFECYCLE_OK) {
        record(app, "caption_runtime_error provider=sctb detail=chunk load failed");
        return false;
    }
    const int lifecycle_status = caption_ctb_init(&app->captions.lifecycle,
                                                   &app->captions.lifecycle_backend);
    app->captions.last_lifecycle_status = lifecycle_status;
    if (lifecycle_status != CAPTION_LIFECYCLE_OK) {
        record(app, "caption_runtime_error provider=sctb status=%d", lifecycle_status);
        return false;
    }
    app->captions.initialized = true;
    record(app, "caption_runtime_initialized fonts=%d tbox=%zu sctb=%zu task=%zu "
           "view_bytes=48 view_origin=%d,%d format=%s caption_surface=%dx%d/%zu framed_surface=%dx%d/%zu "
           "saved_surface=Frame handle=%u bytes=%zu autotext_entries=%zu "
           "task_cc=%d,%d,%d,%d framed_dst=%d,%d,%d,%d popup_state=%d slider=%u modal=%d "
           "transfer=source-backed-RGB555/565 "
           "composition=decoded-background-plus-Frame-taskbar-only",
           app->captions.fonts.count, tbox_size, sctb_size, task_size,
           app->captions.lifecycle.view_origin[0], app->captions.lifecycle.view_origin[1],
           app->captions.compositor_format == CAPTION_COMPOSITOR_RGB555_LE ? "RGB555" : "RGB565",
           app->captions.caption_surface.width, app->captions.caption_surface.height,
           app->captions.caption_pixels.size(), app->captions.framed_surface.width,
           app->captions.framed_surface.height, app->captions.framed_pixels.size(),
           frame_handle, app->captions.raw_images.at(frame_handle).pixels.size(),
           app->captions.auto_text_entry_count,
           app->captions.lifecycle.taskbar.cc_rect.left,
           app->captions.lifecycle.taskbar.cc_rect.top,
           app->captions.lifecycle.taskbar.cc_rect.right,
           app->captions.lifecycle.taskbar.cc_rect.bottom,
           app->captions.framed_destination.left,
           app->captions.framed_destination.top,
           app->captions.framed_destination.right,
           app->captions.framed_destination.bottom,
           (int)(app->captions.lifecycle.box[CTB_STATE] |
               ((uint32_t)app->captions.lifecycle.box[CTB_STATE + 1u] << 8) |
               ((uint32_t)app->captions.lifecycle.box[CTB_STATE + 2u] << 16) |
               ((uint32_t)app->captions.lifecycle.box[CTB_STATE + 3u] << 24)),
           (unsigned)app->captions.lifecycle.box[CTB_HAS_SLIDER],
           app->captions.lifecycle.g.modal_input);
    return true;
}

/* Host-side opaque RGBA copy. The recovered 0x4c5377 blit uses inclusive
 * rectangle endpoints. Reject malformed coordinates instead of retaining its
 * unchecked memory accesses. No scaling, transparency or guessed color keys. */
static bool copy_rectangle(NativeApp *app, const HostImage &source,
                           int32_t left, int32_t top, int32_t right, int32_t bottom,
                           int32_t destination_x, int32_t destination_y)
{
    if (left < 0 || top < 0 || right < left || bottom < top ||
        (uint32_t)right >= source.width || (uint32_t)bottom >= source.height) return false;
    const int64_t width = (int64_t)right - left + 1;
    const int64_t height = (int64_t)bottom - top + 1;
    if (destination_x < 0 || destination_y < 0 ||
        (int64_t)destination_x + width > 640 || (int64_t)destination_y + height > 480) return false;
    for (int64_t row = 0; row < height; ++row) {
        const size_t source_offset = ((size_t)(top + row) * source.width + (size_t)left) * 4;
        const size_t destination_offset = ((size_t)(destination_y + row) * 640 + (size_t)destination_x) * 4;
        std::memcpy(app->framebuffer.data() + destination_offset,
                    source.rgba.data() + source_offset, (size_t)width * 4);
    }
    return true;
}

/* A macOS left mouseDown with an even clickCount is the WM_LBUTTONDBLCLK the
 * original receives instead of the second WM_LBUTTONDOWN. The platform layer
 * (not owned by this slice) passes only DOWN/UP/MOVE, so the count is read
 * from the event being dispatched; headless runs have none and report 1. The
 * scripted driver injects kPointerDoubleClick directly. */
static const int kPointerDoubleClick = 3;

static unsigned current_left_click_count()
{
    NSEvent *event = [NSApp currentEvent];
    if (event == nil || event.type != NSEventTypeLeftMouseDown) return 1;
    return (unsigned)event.clickCount;
}

static void inventory_view_pointer_event(NativeApp *app, int event_kind, int32_t x, int32_t y);
static bool taskbar_pointer_event(NativeApp *app, int event_kind, unsigned button, int32_t x,
                                  int32_t y);

static void pointer(void *context, BlackmoorPointerKind kind,
                    int32_t x, int32_t y, unsigned button)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    const int event_kind = static_cast<int>(kind);
    /* RT-22 follow-up: a left press on a task bar button (0x4e0978) is taken before the scene's
     * own hotspots; so is the release of that press. */
    if (taskbar_pointer_event(app, event_kind, button, x, y)) return;
    /* RT-22: while the inventory screen is up (0x583204 == 3) the left click goes to
     * the view (0x43b19e -> 0x43c0aa) instead of the scene's hotspots; moves reach
     * its hover and still update the pointer. */
    if (app->inv_view.screen_state == INVVIEW_STATE_INVENTORY && button == 0 &&
        (event_kind == BLACKMOOR_POINTER_MOVE || event_kind == BLACKMOOR_POINTER_DOWN ||
         event_kind == kPointerDoubleClick)) {
        if (event_kind == BLACKMOOR_POINTER_MOVE) {
            app->pointer_x = x;
            app->pointer_y = y;
        }
        inventory_view_pointer_event(app, event_kind, x, y);
        if (event_kind != BLACKMOOR_POINTER_MOVE) {
            /* The release of a press the view took must not reach the scene's input latch (it
             * would register a second click on a hotspot under the slot), same as the bar's.
             * NOT original: the original acts on the release (see the RT-22 handoff). */
            app->bar_swallow_up = true;
            return;
        }
    }
    /* The original message-map helper stores coordinates for WM_MOUSEMOVE.
     * Button down/up notify the input latch without replacing that last move. */
    if (event_kind == BLACKMOOR_POINTER_MOVE) {
        app->pointer_x = x;
        app->pointer_y = y;
    }
    /* RT-6: feed the recovered message wrappers straight from the platform
     * event (0x43ed71 move, 0x43ec85 down, 0x43ec4a up, 0x43ecc0 dblclk).
     * Right-button messages are not part of this producer. */
    if (event_kind == BLACKMOOR_POINTER_MOVE || button == 0) {
        SessionInputEvent input_event = SESSION_INPUT_MOVE;
        if (event_kind == BLACKMOOR_POINTER_DOWN)
            input_event = (current_left_click_count() % 2u == 0u) ? SESSION_INPUT_PRIMARY_DBLCLK
                                                            : SESSION_INPUT_PRIMARY_DOWN;
        else if (event_kind == kPointerDoubleClick) input_event = SESSION_INPUT_PRIMARY_DBLCLK;
        else if (event_kind == BLACKMOOR_POINTER_UP) input_event = SESSION_INPUT_PRIMARY_UP;
        if (session_input_feed(&app->input_state, input_event, 0u, x, y, nullptr, nullptr) !=
                SESSION_INPUT_OK)
            record(app, "pointer_feed_error event=%d", static_cast<int>(input_event));
        if (input_event != SESSION_INPUT_MOVE)
            record(app, "pointer_input event=%s candidate_at_message=%d latch_edge=%u",
                   input_event == SESSION_INPUT_PRIMARY_DOWN ? "DOWN" :
                   input_event == SESSION_INPUT_PRIMARY_UP ? "UP" : "DBLCLK",
                   app->input_state.candidate, (unsigned)app->input_state.latch[0]);
    }
    /* The startup menu keeps its own edge flags; the scene session never reads
     * them (it consumes the latch in session_input_tick). */
    if (app->session == nullptr) {
        if (button == 0 && event_kind == BLACKMOOR_POINTER_DOWN) {
            app->primary_down = true; app->primary_pressed = true;
        }
        if (button == 0 && event_kind == BLACKMOOR_POINTER_UP) {
            app->primary_down = false; app->primary_released = true;
        }
    } else {
        if (button == 0 && event_kind == BLACKMOOR_POINTER_DOWN) app->primary_down = true;
        if (button == 0 && event_kind == BLACKMOOR_POINTER_UP) app->primary_down = false;
    }
    if (event_kind != BLACKMOOR_POINTER_MOVE)
        record(app, "pointer kind=%d x=%d y=%d button=%u", event_kind, x, y, button);
    if (app->session != nullptr && app->session_block_reported &&
        event_kind != BLACKMOOR_POINTER_MOVE && button == 0u) {
        ++app->blocked_input_ignored;
        /* First and every 20th, so a long freeze stays visible without flooding. */
        if (app->blocked_input_ignored == 1u || app->blocked_input_ignored % 20u == 0u)
            record(app, "session_frozen_input_ignored scene=%d count=%llu "
                   "reason=scene-session-blocked (see session_frozen above)",
                   app->current_scene_id, (unsigned long long)app->blocked_input_ignored);
    }
}

static void key(void *context, unsigned virtual_key, int down, int repeat)
{
    (void)repeat;
    NativeApp *app = static_cast<NativeApp *>(context);
    if (virtual_key == 0x1b && down) blackmoor_macos_stop(app->platform);
}

static void closed(void *context)
{
    record(static_cast<NativeApp *>(context), "window_closed");
}

static void cleanup(NativeApp *app)
{
    if (app->session) scene_session_destroy(app->session);
    session_a62_destroy(app->a62);
    session_a51_destroy(app->a51);
    session_a35_destroy(app->a35);
    session_a97_destroy(app->a97);
    session_aa1_destroy(app->aa1);
    session_a83_destroy(app->a83);
    session_a79_destroy(app->a79);
    session_a78_destroy(app->a78);
    session_a36_destroy(app->a36);
    session_a17_destroy(app->a17);
    session_a0b_destroy(app->a0b);
    session_a0c_destroy(app->a0c);
    session_conditions_destroy(app->conditions_binding);
    session_a28_destroy(app->a28);
    app->a28 = nullptr;
    if (app->live_audio) live_audio_destroy(app->live_audio);
    app->live_audio = nullptr;
    if (app->platform) blackmoor_macos_close(app->platform);
    if (app->startup) startup_menu_destroy(app->startup);
    if (app->scene) scene_resource_close(app->scene);
    if (app->retired_scene) scene_resource_close(app->retired_scene);
    if (app->video) bink_player_close(app->video);
    if (app->nav_player) bink_player_close(app->nav_player);
    app->nav_player = nullptr;
    if (app->boot) engine_boot_close(app->boot);
    autotext_close(app->captions.auto_text);
    app->captions.auto_text = nullptr;
    if (app->resources) game_resources_close(app->resources);
    if (app->log) std::fclose(app->log);
    app->platform = nullptr;
    app->session = nullptr;
    app->startup = nullptr;
    app->scene = nullptr;
    app->retired_scene = nullptr;
    app->video = nullptr;
    app->boot = nullptr;
    app->resources = nullptr;
    app->log = nullptr;
}

/* Startup integration and main are kept below the host adapters so their
 * recovered state transitions remain separate from native windowing. */

static void clear_framebuffer(NativeApp *app)
{
    std::fill(app->framebuffer.begin(), app->framebuffer.end(), 0);
    for (size_t alpha = 3; alpha < app->framebuffer.size(); alpha += 4)
        app->framebuffer[alpha] = 255;
}

static bool render_startup(NativeApp *app, const StartupMenuFrame &frame)
{
    HostImage *sheet = image(app, frame.resource_name);
    if (!sheet) return false;
    clear_framebuffer(app);
    if (frame.full_screen_image) {
        if (sheet->width != 640 || sheet->height != 480) return false;
        app->framebuffer = sheet->rgba;
    } else if (frame.has_background) {
        const StartupMenuRect &src = frame.background_source;
        const StartupMenuRect &dst = frame.background_destination;
        if ((int64_t)src.right - src.left != (int64_t)dst.right - dst.left ||
            (int64_t)src.bottom - src.top != (int64_t)dst.bottom - dst.top ||
            !copy_rectangle(app, *sheet, src.left, src.top, src.right, src.bottom, dst.left, dst.top)) return false;
    }
    for (size_t i = 0; i < frame.button_count; ++i) {
        const StartupMenuButtonFrame &button = frame.buttons[i];
        if (button.visual == STARTUP_MENU_BUTTON_NORMAL) continue;
        const StartupMenuRect &src = button.source_rect;
        const StartupMenuRect &dst = button.destination_rect;
        if ((int64_t)src.right - src.left != (int64_t)dst.right - dst.left ||
            (int64_t)src.bottom - src.top != (int64_t)dst.bottom - dst.top ||
            !copy_rectangle(app, *sheet, src.left, src.top, src.right, src.bottom, dst.left, dst.top)) return false;
    }
    return true;
}

/* 0x435015 copies VIEW's three inclusive RECTs to 0x583186. Scene setup at
 * 0x439822 uses the first as screen destination and the second as source. */
static bool load_viewport(NativeApp *app)
{
    const uint8_t *payload = nullptr;
    size_t length = 0;
    if (!find_boot_payload(app, "VIEW", &payload, &length) ||
        payload == nullptr || length != 48u) return false;
    for (size_t field = 0; field < app->view_words.size(); ++field)
        app->view_words[field] = read_i32_le(payload + field * 4u);
    app->scene_destination = {app->view_words[0], app->view_words[1],
                              app->view_words[2], app->view_words[3]};
    app->scene_source = {app->view_words[4], app->view_words[5],
                         app->view_words[6], app->view_words[7]};
    record(app, "scene_view_loaded bytes=%zu viewport=%d,%d,%d,%d source=%d,%d,%d,%d "
           "third_rect=%d,%d,%d,%d",
           length, app->scene_destination.left, app->scene_destination.top,
           app->scene_destination.right, app->scene_destination.bottom,
           app->scene_source.left, app->scene_source.top,
           app->scene_source.right, app->scene_source.bottom,
           app->view_words[8], app->view_words[9],
           app->view_words[10], app->view_words[11]);
    return true;
}

static bool render_scene_preview(NativeApp *app)
{
    clear_framebuffer(app);
    const StartupMenuRect &src = app->scene_source, &dst = app->scene_destination;
    if ((int64_t)src.right - src.left != (int64_t)dst.right - dst.left ||
        (int64_t)src.bottom - src.top != (int64_t)dst.bottom - dst.top) return false;
    return copy_rectangle(app, app->scene_frame,
        src.left, src.top, src.right, src.bottom, dst.left, dst.top);
}

static uint64_t monotonic_now_ns()
{
    return static_cast<uint64_t>(std::chrono::duration_cast<std::chrono::nanoseconds>(
        std::chrono::steady_clock::now().time_since_epoch()).count());
}

static bool copy_player_frame(NativeApp *app, const BinkPlayerFrame &frame)
{
    if (frame.rgba == nullptr || frame.width == 0 || frame.height == 0 ||
        static_cast<size_t>(frame.width) > SIZE_MAX / 4u) return false;
    const size_t row_bytes = static_cast<size_t>(frame.width) * 4u;
    if (frame.stride < row_bytes || frame.height > SIZE_MAX / frame.stride ||
        static_cast<size_t>(frame.width) > SIZE_MAX / frame.height / 4u) return false;
    const size_t required = static_cast<size_t>(frame.height - 1u) * frame.stride + row_bytes;
    const size_t image_bytes = static_cast<size_t>(frame.width) * frame.height * 4u;
    if (frame.rgba_bytes < required) return false;
    try { app->scene_frame.rgba.resize(image_bytes); }
    catch (...) { return false; }
    app->scene_frame.width = frame.width;
    app->scene_frame.height = frame.height;
    app->scene_frame.frame_index = frame.current_frame;
    for (uint32_t row = 0; row < frame.height; ++row) {
        std::memcpy(app->scene_frame.rgba.data() + static_cast<size_t>(row) * row_bytes,
                    frame.rgba + static_cast<size_t>(row) * frame.stride, row_bytes);
    }
    app->scene_current_frame = frame.current_frame;
    return true;
}

static ActionFamily64BackendStatus session_get_tick_count(void *context,
                                                               uint32_t *tick_count)
{
    if (context == nullptr || tick_count == nullptr) return ACTION_FAMILY64_BACKEND_ERROR;
    *tick_count = blackmoor_macos_monotonic_ms();
    return ACTION_FAMILY64_BACKEND_OK;
}

static void sync_action64_clock_from_new_game(NativeApp *app)
{
    if (app == nullptr) return;
    app->new_game.action64_world.clock_value_585d51 =
        app->new_game.view.clock.configured_hour;
    app->new_game.action64_world.clock_value_585d4f =
        app->new_game.view.clock.configured_minute;
    app->new_game.action64_world.clock_total_585d4b =
        app->new_game.view.clock.total_minutes;
    app->new_game.action64_world.clock_deadline_585d55 =
        app->new_game.view.clock.next_update_tick;
    app->new_game.action64_world.deadline_offset_5b0280 =
        app->new_game.view.clock.update_interval_ms;
}

static void mirror_action64_clock_commit(void *context,
                                         const ActionFamily64World *world)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || world == nullptr) return;
    /* WorldInitClock is the session's authoritative civil clock. This callback
     * runs synchronously after an accepted A-64 write and before the next ACT
     * row, so later providers cannot observe a stale copy. */
    app->new_game.view.clock.configured_hour = world->clock_value_585d51;
    app->new_game.view.clock.configured_minute = world->clock_value_585d4f;
    app->new_game.view.clock.total_minutes = world->clock_total_585d4b;
    app->new_game.view.clock.next_update_tick = world->clock_deadline_585d55;
}

static SceneSessionProvider world_clock_failure_provider(
    const WorldClockResult *clock_result)
{
    if (clock_result == nullptr) return SCENE_SESSION_PROVIDER_WORLD_CLOCK;
    switch (clock_result->trigger) {
    case WORLD_CLOCK_TRIGGER_SOUND_DESCRIPTOR:
    case WORLD_CLOCK_TRIGGER_SOUND_CHANNEL_PLAY:
        return SCENE_SESSION_PROVIDER_ACTION_SOUND;
    case WORLD_CLOCK_TRIGGER_CAPTION_LOOKUP:
    case WORLD_CLOCK_TRIGGER_CAPTION_PRESENT:
        return SCENE_SESSION_PROVIDER_CAPTION;
    default:
        return SCENE_SESSION_PROVIDER_WORLD_CLOCK;
    }
}

static int native_action_sound_handler(
    void *context, size_t action_index, const SceneActionInfo *info,
    const SceneActionRuntimeState *before, SceneActionHandlerResult *result)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || info == nullptr || before == nullptr || result == nullptr)
        return SCENE_ACTION_HANDLER_ERROR;
    app->captions.action_caption_attempted = false;
    app->captions.action_caption_lookup_attempted = false;
    app->captions.action_caption_present_succeeded = false;
    ActionSoundAction action{};
    action.type = info->type;
    action.subtype = info->subtype;
    action.eligible = 1u;
    action.completed_before = before->completed;
    action.phase_before = before->phase;
    /* The original 0x427a50 switch calls 0x432d1a(row, 1, 0) for 0x9f. */
    action.scene_dispatch_argument = 1u;
    action.captions_enabled = app->world_clock_session.captions_enabled_5bb202;
    action.body = info->typed_body;
    action.body_length = info->typed_body_length;
    ActionSoundStepResult effect{};
    ActionSoundBackend backend{};
    backend.context = app;
    backend.resolve_auto_text = native_action_sound_resolve_auto_text;
    backend.present_caption = native_action_sound_present_caption;
    backend.load_sound = native_action_sound_load;
    backend.play_sound = native_action_sound_play;
    backend.is_playing = native_action_sound_is_playing;
    backend.unload_sound = native_action_sound_unload;
    const int status = action_sound_step(&action, &backend, &effect);
    const bool has_selector = info->typed_body != nullptr &&
        info->typed_body_length >= 48u &&
        (info->typed_body[46] != 0u || info->typed_body[47] != 0u);
    const bool caption_gate = status == ACTION_SOUND_ERR_UNSUPPORTED &&
        ((app->captions.action_caption_attempted &&
          !app->captions.action_caption_present_succeeded) ||
         (app->captions.action_caption_lookup_attempted &&
          !app->captions.action_caption_attempted)) &&
        action.captions_enabled != 0u && action.scene_dispatch_argument != 0u &&
        has_selector;
    record(app, "scene_action_sound row=%zu phase=%u kernel_status=%d "
           "captions=%u dispatch_argument=%u boundary=%s lookup_attempted=%u writer_status=%d "
           "audio_provider=live-audio transfer_blocked=%d",
           action_index, action.phase_before, status, action.captions_enabled,
           action.scene_dispatch_argument,
           caption_gate
               ? (app->captions.action_caption_attempted
                      ? "caption-presentation" : "caption-lookup")
               : status == ACTION_SOUND_ERR_UNSUPPORTED
                     ? "audio-backend" : "kernel",
           app->captions.action_caption_lookup_attempted,
           app->captions.last_writer_status, app->captions.transfer_blocked);
    if (status == ACTION_SOUND_ERR_UNSUPPORTED)
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    if (status != ACTION_SOUND_OK) return SCENE_ACTION_HANDLER_ERROR;
    if (effect.has_transition != 0u) {
        /* Mode-0 completion ends the scene with the 0x9f transition tuple.
         * The handler also sets engine state 4 and DAT_005bb1ca; the engine
         * state is the exit path (session_exit) and the start-flag mirror is
         * not wired for this route (named gap). */
        SceneTransitionRequest request{};
        request.target_scene = effect.transition.target_scene;
        for (int i = 0; i < 3; ++i) {
            request.opaque_words[i] = effect.transition.opaque_words[i];
            request.opaque_dwords[i] = effect.transition.opaque_dwords[i];
        }
        if (app->session == nullptr ||
            scene_session_request_transition(app->session, &request) != SCENE_SESSION_OK) {
            record(app, "scene_action_sound_transition_error row=%zu target=%d",
                   action_index, request.target_scene);
            return SCENE_ACTION_HANDLER_ERROR;
        }
        record(app, "scene_action_sound_transition row=%zu target=%d", action_index,
               request.target_scene);
    }
    result->phase = effect.phase;
    if (effect.reset_dependencies != 0u) {
        result->disposition = SCENE_ACTION_HANDLER_RESET_DEPENDENCIES;
    } else if (effect.completion_valid != 0u && effect.completed != 0u) {
        result->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;
    } else {
        result->disposition = SCENE_ACTION_HANDLER_PENDING;
    }
    return SCENE_ACTION_HANDLER_OK;
}

static SceneSessionCallbackStatus prepare_native_session_tick(
    void *context,
    SceneConditionState *conditions,
    SceneExecutorFrameInput *frame_input,
    SceneSessionFailure *failure)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || conditions == nullptr || frame_input == nullptr ||
        failure == nullptr) return SCENE_SESSION_CALLBACK_ERROR;
    if (app->captions.transfer_failed_sticky) {
        failure->stage = SCENE_SESSION_STAGE_PREPARE;
        failure->provider = SCENE_SESSION_PROVIDER_CAPTION;
        failure->action_index = SIZE_MAX;
        failure->action_type = 0u;
        failure->detail_status = app->captions.last_lifecycle_status;
        return SCENE_SESSION_CALLBACK_BLOCKED;
    }
    std::memset(conditions, 0, sizeof(*conditions));
    conditions->event_flags = app->new_game.action_core.event_flags;
    conditions->event_flag_count = app->new_game.action_core.event_flag_count;
    conditions->inventory_presence =
        app->new_game.view.inventory.presence_583bd5.values;
    conditions->inventory_count =
        app->new_game.view.inventory.presence_583bd5.count;
    conditions->selected_inventory_item =
        app->new_game.view.inventory.selected_item_candidate
            ? *app->new_game.view.inventory.selected_item_candidate : -1;
    conditions->scene_visit_counts = reinterpret_cast<const int16_t *>(
        app->new_game.view.scene_visit_counts_587b2d.values);
    conditions->scene_visit_count =
        app->new_game.view.scene_visit_counts_587b2d.count;
    WorldClockResult clock_result{};
    const int clock_status = world_clock_update_normal(
        &app->world_clock_session, app->session_tick_sample,
        &app->world_clock_effect_sink, &clock_result);
    record(app, "scene_clock_tick sample=%u delta=%u status=%d trigger=%d "
           "record=%u event=%d partial=%u total_minutes=%d "
           "outside_window=%d continuation=0x%08x",
           app->session_tick_sample, clock_result.delta_ms, clock_status,
           clock_result.trigger, clock_result.record_index,
           clock_result.event_flag_id, clock_result.partial_state_committed,
           app->new_game.view.clock.total_minutes,
           app->world_clock_session.outside_window_flag_5bb20a,
           clock_result.continuation_va);
    if (clock_status != WORLD_CLOCK_OK) {
        failure->stage = SCENE_SESSION_STAGE_PREPARE;
        failure->provider = world_clock_failure_provider(&clock_result);
        failure->action_index = SIZE_MAX;
        failure->action_type = 0u;
        failure->detail_status = clock_status;
        return SCENE_SESSION_CALLBACK_BLOCKED;
    }

    /* These are the two original post-clock gates at 0x43b13d. The cold
     * constructor sets object+0x1c to zero; event 0x2711 activation and the
     * auxiliary 0x61c6ad/0x61c7bd route remain explicit blockers if a future
     * accepted input provider mutates them. */
    if (app->post_clock_object_enabled_001c != 0) {
        failure->stage = SCENE_SESSION_STAGE_PREPARE;
        failure->provider = SCENE_SESSION_PROVIDER_POST_CLOCK;
        failure->action_index = SIZE_MAX;
        failure->action_type = 0u;
        failure->detail_status = 0x4d3d48;
        return SCENE_SESSION_CALLBACK_BLOCKED;
    }
    if (app->post_clock_aux_enabled_61c6ad != 0u &&
        app->post_clock_aux_value_61c7bd != 0) {
        failure->stage = SCENE_SESSION_STAGE_PREPARE;
        failure->provider = SCENE_SESSION_PROVIDER_POST_CLOCK;
        failure->action_index = SIZE_MAX;
        failure->action_type = 0u;
        failure->detail_status = 0x4d4043;
        return SCENE_SESSION_CALLBACK_BLOCKED;
    }

    int32_t clock_value = 0;
    for (uint16_t opcode = 4u; opcode <= 6u; ++opcode) {
        if (world_clock_condition_read(&app->new_game.view, opcode,
                                       &clock_value) != WORLD_CLOCK_OK) {
            failure->stage = SCENE_SESSION_STAGE_PREPARE;
            failure->provider = SCENE_SESSION_PROVIDER_WORLD_CLOCK;
            failure->action_index = SIZE_MAX;
            failure->action_type = 0u;
            failure->detail_status = opcode;
            return SCENE_SESSION_CALLBACK_BLOCKED;
        }
        if (opcode == 4u) conditions->timer_4_value = clock_value;
        else if (opcode == 5u) conditions->timer_5_value = clock_value;
        else conditions->time_of_day_minutes = clock_value;
    }

    /* The clock kernel mutates the authoritative WorldInitState first. Only
     * now refresh the A-64 snapshot, immediately before the ordered ACT scan;
     * A-64 commits mirror back synchronously before later dependency rows. */
    sync_action64_clock_from_new_game(app);
    frame_input->current_frame = app->scene_current_frame;
    /* Pointer and activation members are produced by the session's pointer
     * boundary (session_input_tick at the consume point), not here. */
    failure->stage = SCENE_SESSION_STAGE_PREPARE;
    failure->provider = SCENE_SESSION_PROVIDER_NONE;
    failure->action_index = SIZE_MAX;
    failure->action_type = 0u;
    failure->detail_status = 0;
    return SCENE_SESSION_CALLBACK_OK;
}

static SceneSessionCallbackStatus advance_native_session_media_one(
    void *context,
    SceneExecutorFrameInput *frame_input,
    SceneSessionFailure *failure)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || frame_input == nullptr || failure == nullptr)
        return SCENE_SESSION_CALLBACK_ERROR;
    if (app->captions.transfer_failed_sticky) {
        failure->stage = SCENE_SESSION_STAGE_MEDIA;
        failure->provider = SCENE_SESSION_PROVIDER_CAPTION;
        failure->action_index = SIZE_MAX;
        failure->detail_status = CAPTION_COMPOSITOR_ERR_UNSUPPORTED;
        return SCENE_SESSION_CALLBACK_BLOCKED;
    }
    ++app->captions.transfer_tick;
    app->captions.transfer_attempts = 0u;
    app->captions.transfer_successes = 0u;
    app->captions.transfer_blocked = false;
    if (app->video != nullptr) {
        BinkPlayerFrame next{};
        char error[256] = {};
        const int status = bink_player_advance(app->video, monotonic_now_ns(),
                                                &next, error, sizeof(error));
        if (status == BINK_PLAYER_OK) {
            if (!copy_player_frame(app, next)) {
                failure->stage = SCENE_SESSION_STAGE_MEDIA;
                failure->provider = SCENE_SESSION_PROVIDER_MEDIA;
                failure->action_index = SIZE_MAX;
                failure->detail_status = BINK_PLAYER_ERR_BOUNDS;
                return SCENE_SESSION_CALLBACK_ERROR;
            }
        } else if (status == BINK_PLAYER_EOS) {
            record(app, "scene_session_media_eos frame=%d", app->scene_current_frame);
            bink_player_close(app->video);
            app->video = nullptr;
        } else if (status != BINK_PLAYER_NOT_DUE) {
            record(app, "scene_session_media_error status=%d detail=%s", status, error);
            failure->stage = SCENE_SESSION_STAGE_MEDIA;
            failure->provider = SCENE_SESSION_PROVIDER_MEDIA;
            failure->action_index = SIZE_MAX;
            failure->detail_status = status;
            return SCENE_SESSION_CALLBACK_ERROR;
        }
    }
    frame_input->current_frame = app->scene_current_frame;
    if (!seed_native_caption_backbuffer(app)) {
        failure->stage = SCENE_SESSION_STAGE_MEDIA;
        failure->provider = SCENE_SESSION_PROVIDER_CAPTION;
        failure->action_index = SIZE_MAX;
        failure->detail_status = CAPTION_COMPOSITOR_ERR_BOUNDS;
        record(app, "caption_backbuffer_seed_failed scene=%d frame=%d",
               app->current_scene_id, app->scene_current_frame);
        return SCENE_SESSION_CALLBACK_BLOCKED;
    }
    return SCENE_SESSION_CALLBACK_OK;
}


/* ---- RT-3: host providers for the 0x62 and 0x51 session bindings ---------- */

/* DAT_005bb50b, the signed selector 0x42ea87 compares at 0x42ebb0. Its only
 * stores are 0x439f41 (scene entry: DAT_005bb599, the frame word copied from
 * the scene-change request, guarded by the restore flag 0x5e32b5 == 0) and the
 * navigation block 0x43c2b7..0x43c87f of 0x43a7ca. RT-17 binds the edge-zone
 * command (cascade 0x4f197d..0x4f1dba, hover) and the tick step; the value
 * returned here is the live selector (selector_entry_frame mirrors nav.selector
 * after every step). The keyboard path 0x437774 is still unbound. The New Game
 * entry scene has no proven entry frame, so it is reported as unavailable. */
static int native_a62_current_selector(void *context, int16_t *selector)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || selector == nullptr || !app->selector_entry_valid ||
        app->selector_entry_frame < INT16_MIN || app->selector_entry_frame > INT16_MAX)
        return 1;
    *selector = static_cast<int16_t>(app->selector_entry_frame);
    if (!app->selector_logged) {
        app->selector_logged = true;
        record(app, "scene_a62_selector scene=%d value=%d source=scene-change-frame-word "
               "(0x439f20..0x439f41 DAT_005bb50b=DAT_005bb599) navigation_producers=edge-zone+tick-step"
               "(RT-17) keyboard=unbound",
               app->current_scene_id, *selector);
    }
    return 0;
}

static void native_a62_set_start_flag(void *context, int32_t value)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr) return;
    app->start_flag_5bb1ca = value;
    record(app, "scene_a62_start_flag DAT_005bb1ca=%d writer=0x42eb04", value);
}

static std::vector<uint8_t> native_a51_text_copy(const uint8_t *text, size_t length)
{
    std::vector<uint8_t> copy(length + 8u, 0u);
    if (length != 0u) std::memcpy(copy.data(), text, length);
    return copy;
}

static ActionFamily51BackendStatus native_a51_measure(void *context, const uint8_t *text, size_t length,
                              int16_t *lines)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || text == nullptr || lines == nullptr || !app->captions.initialized)
        return ACTION_FAMILY_51_BACKEND_ERROR;
    std::vector<uint8_t> copy = native_a51_text_copy(text, length);
    CaptionRequest request{copy.data(), copy.size(), CAPTION_MODE_CAPTION, 1u, 0u};
    CaptionResult result{};
    const int status = caption_layout_write(&app->captions.fonts,
        &app->captions.geometry, &app->captions.pixel_format,
        &app->captions.writer_box, &app->captions.writer_globals,
        &app->captions.writer_backend, nullptr, &request, &result);
    app->captions.last_writer_status = status;
    record(app, "scene_a51_measure status=%d lines=%d bytes=%zu", status, result.lines, length);
    if (status != CAPTION_OK) return ACTION_FAMILY_51_BACKEND_ERROR;
    *lines = result.lines;
    return ACTION_FAMILY_51_BACKEND_OK;
}

static ActionFamily51BackendStatus native_a51_write_caption(void *context, const uint8_t *text, size_t length)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || text == nullptr || !app->captions.initialized)
        return ACTION_FAMILY_51_BACKEND_ERROR;
    app->captions.action_caption_attempted = true;
    app->captions.transfer_blocked = false;
    std::vector<uint8_t> copy = native_a51_text_copy(text, length);
    CaptionRequest request{copy.data(), copy.size(), CAPTION_MODE_CAPTION, 0u, 0u};
    const int status = caption_layout_write(&app->captions.fonts,
        &app->captions.geometry, &app->captions.pixel_format,
        &app->captions.writer_box, &app->captions.writer_globals,
        &app->captions.writer_backend, &app->captions.caption_surface,
        &request, &app->captions.last_writer_result);
    app->captions.last_writer_status = status;
    app->captions.action_caption_present_succeeded = status == CAPTION_OK;
    record(app, "scene_a51_write_caption status=%d bytes=%zu lines=%d glyphs=%u",
           status, length, app->captions.last_writer_result.lines,
           app->captions.last_writer_result.glyphs_drawn);
    return status == CAPTION_OK ? ACTION_FAMILY_51_BACKEND_OK
                                : ACTION_FAMILY_51_BACKEND_ERROR;
}

static ActionFamily51BackendStatus native_a51_open_frame_text(void *context, int32_t mode, const uint8_t *text,
                                      size_t length)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || text == nullptr || !app->captions.initialized)
        return ACTION_FAMILY_51_BACKEND_ERROR;
    std::vector<uint8_t> copy = native_a51_text_copy(text, length);
    const int status = caption_ctb_open(&app->captions.lifecycle,
        &app->captions.lifecycle_backend, mode, copy.data(), copy.size());
    app->captions.last_lifecycle_status = status;
    record(app, "scene_a51_open_frame_text mode=%d bytes=%zu status=%d detail=%s "
           "frame_open=%u framed_layer=%d",
           mode, length, status, caption_lifecycle_status_string(status),
           app->captions.writer_globals.frame_open,
           app->captions.lifecycle.g.framed_layer_enabled);
    return status == CAPTION_LIFECYCLE_OK ? ACTION_FAMILY_51_BACKEND_OK
                                          : ACTION_FAMILY_51_BACKEND_ERROR;
}

static ActionFamily51BackendStatus native_a51_close_frame_text(void *context)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || !app->captions.initialized) return ACTION_FAMILY_51_BACKEND_ERROR;
    const int status = caption_ctb_close(&app->captions.lifecycle,
                                          &app->captions.lifecycle_backend);
    app->captions.last_lifecycle_status = status;
    record(app, "scene_a51_close_frame_text status=%d", status);
    return status == CAPTION_LIFECYCLE_OK ? ACTION_FAMILY_51_BACKEND_OK
                                          : ACTION_FAMILY_51_BACKEND_ERROR;
}

static ActionFamily51BackendStatus native_a51_is_channel_playing(void *context, int16_t channel, int *playing)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || playing == nullptr || channel < 0 || app->live_audio == nullptr)
        return ACTION_FAMILY_51_BACKEND_ERROR;
    int still_playing = 0;
    if (live_audio_is_playing(app->live_audio, static_cast<uint16_t>(channel),
                              &still_playing) != ACTION_SOUND_BACKEND_OK)
        return ACTION_FAMILY_51_BACKEND_ERROR;
    *playing = still_playing;
    return ACTION_FAMILY_51_BACKEND_OK;
}

static ActionFamily51BackendStatus native_a51_tick_count(void *context, uint32_t *now)
{
    if (context == nullptr || now == nullptr) return ACTION_FAMILY_51_BACKEND_ERROR;
    *now = blackmoor_macos_monotonic_ms();
    return ACTION_FAMILY_51_BACKEND_OK;
}

static ActionFamily51LookupStatus native_a51_autotext_lookup(
    void *context, const uint8_t *key, size_t key_length,
    const uint8_t **text, size_t *text_length)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    size_t raw_length = 0u;
    if (app == nullptr || app->captions.auto_text == nullptr)
        return ACTION_FAMILY_51_LOOKUP_ERROR;
    const int status = autotext_lookup(app->captions.auto_text, key, key_length,
                                       text, &raw_length, text_length);
    record(app, "scene_a51_autotext_lookup status=%d key_bytes=%zu text_bytes=%zu",
           status, key_length, status == AUTOTEXT_OK ? *text_length : (size_t)0);
    if (status == AUTOTEXT_OK) return ACTION_FAMILY_51_LOOKUP_FOUND;
    if (status == AUTOTEXT_ERR_NOT_FOUND) return ACTION_FAMILY_51_LOOKUP_NOT_FOUND;
    return ACTION_FAMILY_51_LOOKUP_ERROR;
}

/* 0x5b1606 and 0x5b1602 live in the caption renderer's CaptionGlobals; the
 * A-51 kernel's world mirrors them, so copy them across each kernel step. */
static void native_a51_load_world(void *context, ActionFamily51World *world)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || world == nullptr) return;
    world->frame_text_flag = app->captions.writer_globals.caption_visible_flag;
    world->caption_finish_flag = app->captions.writer_globals.caption_finish_flag;
}

static void native_a51_store_world(void *context, const ActionFamily51World *world)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || world == nullptr) return;
    app->captions.writer_globals.caption_visible_flag = world->frame_text_flag;
    app->captions.writer_globals.caption_finish_flag = world->caption_finish_flag;
}

/* RT-4 host providers for the dependency leaves (see
 * session_bindings_conditions.h for what each one proves). */
static ConditionExtraHostStatus native_cond_channel_record(
    void *context, uint16_t channel, SessionConditionsChannelRecord *record)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || app->live_audio == nullptr) return CONDITION_EXTRA_HOST_UNAVAILABLE;
    return session_conditions_live_audio_channel_record(app->live_audio, channel, record);
}

static ConditionExtraHostStatus native_cond_next_random(void *context, uint32_t *raw)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr) return CONDITION_EXTRA_HOST_UNAVAILABLE;
    return session_conditions_crt_rand_host(&app->condition_rand, raw);
}

/* 0x58c94f is the difficulty word: action 0x71 stores it (0x4292b3) and New
 * Game zeroes it (0x4383af); ActionCoreWorld.difficulty is that word. */
static ConditionExtraHostStatus native_cond_context_58c94f(void *context, int16_t *value)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || value == nullptr) return CONDITION_EXTRA_HOST_UNAVAILABLE;
    *value = app->new_game.action_core.difficulty;
    return CONDITION_EXTRA_HOST_OK;
}

/* Loader table word 0x5adb81 + 2*idx for opcode 13/14 leaves whose
 * fields[6] >= 5000. The BOOT loader copies the 402-byte BSUM payload over
 * 0x5b0113..0x5b02a4 (0x4356eb..0x4356fc), so the words for indexes
 * 5000..5003 (0x5b0291..0x5b0297) are BSUM[382..389] = 300, 180, 1500, 60;
 * no instruction writes them afterwards (scan of every .text operand). */
static int native_cond_variable_word(void *context, int16_t index, int16_t *value)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    EngineBootSummary summary{};
    if (app == nullptr || app->boot == nullptr ||
        engine_boot_get_summary(app->boot, &summary) != ENGINE_BOOT_OK) return 0;
    return session_conditions_bsum_variable_word(summary.bsum_raw, ENGINE_BOOT_BSUM_SIZE,
                                                 index, value);
}

/* Creates the RT-4 binding (idempotent). The CRT seed defaults to time(NULL),
 * as the original's srand(time(NULL)) at 0x43504f; --rand-seed N replaces it
 * for replayable scripts. Seed parity with an original run is unprovable. */
static bool create_native_conditions_binding(NativeApp *app)
{
    if (app->conditions_binding != nullptr) return true;
    SessionConditionsConfig cond{};
    cond.world = &app->new_game.view;
    cond.clock = &app->world_clock_session;
    cond.host.context = app;
    cond.host.channel_record = native_cond_channel_record;
    cond.host.next_random = native_cond_next_random;
    cond.host.read_context_58c94f = native_cond_context_58c94f;
    cond.host.read_variable_word = native_cond_variable_word;
    int cond_status = 0;
    app->conditions_binding = session_conditions_create(&cond, &cond_status);
    const bool fixed = app->condition_rand_seed_set;
    const uint32_t seed = fixed ? app->condition_rand_seed
                                : static_cast<uint32_t>(std::time(nullptr));
    session_conditions_crt_srand(&app->condition_rand, seed);
    record(app, "scene_conditions_binding status=%d rand=msvc-crt-lcg seed=%u seed-source=%s "
           "seed-parity=unproven", cond_status, seed,
           fixed ? "--rand-seed" : "time(NULL)");
    return app->conditions_binding != nullptr;
}

/* Builds both bindings and loads their per-scene tables for app->scene. */
/* RT-9: the existing timed player supplies codec frames, while RT-7 owns
 * tick ordering, event stores and completion. Offline media clock shares the
 * mixer render clock; no output device is opened by inspection mode. */
static uint64_t native_a35_clock(void *context)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    uint32_t rate = 0, channels = 0;
    if (app->offline_audio_frames_per_update != 0 && app->live_audio != nullptr &&
        live_audio_offline_format(app->live_audio, &rate, &channels) == LIVE_AUDIO_OK && rate != 0)
        return live_audio_offline_frames_rendered(app->live_audio) * 1000000000ull / rate;
    return monotonic_now_ns();
}

static int native_a35_audio_start(void *context, const BinkAudio *audio)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    const int status = live_audio_movie_start(app->live_audio, audio->pcm, audio->frame_count,
                                               audio->channels, audio->sample_rate);
    record(app, "scene_a35_audio_start status=%d clock_ns=%llu", status,
           (unsigned long long)native_a35_clock(app));
    return status;
}

static void native_a35_audio_stop(void *context)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    const int status = live_audio_movie_stop(app->live_audio);
    record(app, "scene_a35_audio_stop status=%d clock_ns=%llu last_frame=%d", status,
           (unsigned long long)native_a35_clock(app), app->movie_frame.current_frame);
    if (status != LIVE_AUDIO_OK) app->failure = true;
}

static int native_a35_present(void *context, const BinkPlayerFrame *frame,
                               const A35Rect *src, const A35Rect *dst)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (dst->left < 0 || dst->top < 0 || dst->right >= 640 || dst->bottom >= 480 ||
        frame->rgba == nullptr || frame->stride == 0 || static_cast<size_t>(frame->width) > SIZE_MAX / 4u ||
        frame->height > SIZE_MAX / frame->stride ||
        frame->rgba_bytes < (size_t)frame->height * frame->stride) return 1;
    try { app->movie_surface.assign(frame->rgba, frame->rgba + frame->rgba_bytes); }
    catch (...) { return 1; }
    app->movie_frame = *frame;
    app->movie_frame.rgba = app->movie_surface.data();
    app->movie_source = *src;
    app->movie_destination = *dst;
    ++app->movie_generation;
    return 0;
}

static bool native_a35_compose(NativeApp *app)
{
    if (!app->movie_visible_5d19fb || app->movie_frame.rgba == nullptr) return true;
    const A35Rect &src = app->movie_source, &dst = app->movie_destination;
    NativeCaptionRuntime &captions = app->captions;
    for (int32_t y = 0; y <= src.bottom - src.top; ++y) {
        for (int32_t x = 0; x <= src.right - src.left; ++x) {
            const size_t at = (size_t)(src.top + y) * app->movie_frame.stride +
                              (size_t)(src.left + x) * 4u;
            const size_t to = ((size_t)(dst.top + y) * 640u + (size_t)(dst.left + x)) * 2u;
            if (!native_caption_pack_rgba(captions, app->movie_frame.rgba + at,
                                          captions.backbuffer_pixels.data() + to)) return false;
        }
    }
    if (app->movie_composed != app->movie_generation) {
        SessionA35BinkStats stats{};
        if (session_a35_bink_stats(app->movie_bink, &stats) != 0) return false;
        app->movie_composed = app->movie_generation;
        /* Hash the composed destination viewport, row by row, independently
         * of the source-frame SHA. Includes background where the crop leaves
         * pixels untouched. This is software presentation evidence only. */
        uint64_t viewport_hash = UINT64_C(14695981039346656037);
        for (int32_t y = app->scene_destination.top; y <= app->scene_destination.bottom; ++y) {
            for (int32_t x = app->scene_destination.left * 2;
                 x < (app->scene_destination.right + 1) * 2; ++x) {
                viewport_hash ^= captions.backbuffer_pixels[(size_t)y * 1280u + (size_t)x];
                viewport_hash *= UINT64_C(1099511628211);
            }
        }
        record(app, "scene_a35_frame_presented frame=%d count=%llu rgba_sha256=%s "
               "src=%d,%d,%d,%d dst=%d,%d,%d,%d surface=scene-viewport-RGB555 "
               "viewport_fnv1a64=%016llx clock_ns=%llu origin_ns=%llu pts_ns=%lld "
               "codec-parity=unverified", stats.frame, (unsigned long long)stats.presented,
               stats.rgba_sha256, src.left, src.top, src.right, src.bottom,
               dst.left, dst.top, dst.right, dst.bottom, (unsigned long long)viewport_hash,
               (unsigned long long)stats.clock_ns, (unsigned long long)stats.origin_ns,
               (long long)stats.pts_ns);
    }
    return true;
}

static void native_a35_close(void *context)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app->movie_bink != nullptr) {
        SessionA35BinkStats stats{};
        session_a35_bink_stats(app->movie_bink, &stats);
        record(app, "scene_a35_close decoded=%llu presented=%llu last_frame=%d "
               "pcm_sha256=%s audio_frames=%llu rate=%u channels=%u not_due=%llu clock_ns=%llu",
               (unsigned long long)stats.decoded, (unsigned long long)stats.presented,
               stats.frame, stats.pcm_sha256, (unsigned long long)stats.audio_frames,
               stats.audio_rate, stats.audio_channels, (unsigned long long)stats.not_due,
               (unsigned long long)native_a35_clock(app));
        session_a35_bink_close(app->movie_bink);
    }
    app->movie_bink = nullptr;
    app->movie_frame = {};
    app->movie_surface.clear();
}

static int native_a35_open(void *context, const ActionFamily35Decoded *body,
                           AvfStream **stream)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    (void)stream;
    if (body->words[0] != 1u) {
        record(app, "scene_a35_open branch=AVF status=unsupported detail=AVF-surface-host-unbound");
        return A35_RUNTIME_UNSUPPORTED;
    }
    const auto reject = [&](const char *detail) {
        record(app, "scene_a35_open branch=Bink name=%s status=%d detail=%s",
               body->name, A35_RUNTIME_UNSUPPORTED, detail);
        return A35_RUNTIME_UNSUPPORTED;
    };
    if (app->movie_bink != nullptr) return A35_RUNTIME_HOST;
    const std::string wanted = std::string(reinterpret_cast<const char *>(body->name)) + ".bik";
    if (wanted.find_first_of("/\\") != std::string::npos) return reject("invalid-asset-name");
    const std::string directory_name = app->game_directory + "/CDVideo";
    DIR *directory = opendir(directory_name.c_str());
    if (directory == nullptr) return reject("CDVideo-directory-unavailable");
    std::string path;
    unsigned matches = 0;
    while (dirent *entry = readdir(directory)) {
        const std::string candidate = entry->d_name;
        if (candidate.size() != wanted.size()) continue;
        bool same = true;
        for (size_t i = 0; i < wanted.size(); ++i) {
            unsigned char a = static_cast<unsigned char>(candidate[i]);
            unsigned char b = static_cast<unsigned char>(wanted[i]);
            if (a >= 'a' && a <= 'z') a -= 'a' - 'A';
            if (b >= 'a' && b <= 'z') b -= 'a' - 'A';
            if (a != b) { same = false; break; }
        }
        if (same) { ++matches; path = directory_name + "/" + candidate; }
    }
    closedir(directory);
    if (matches != 1u) return reject(matches == 0u ? "missing-file" : "ambiguous-file");
    BinkPlayerInfo info{};
    SessionA35BinkHost host{app, native_a35_clock, native_a35_audio_start,
                             native_a35_audio_stop, native_a35_present};
    char error[256] = {};
    app->movie_mix_captures = 0;
    const int status = session_a35_bink_open(path.c_str(), body->words[4] == 2u ? 1 : 0,
        &host, &app->movie_bink, &info, error, sizeof(error));
    SessionA35BinkStats stats{};
    if (app->movie_bink) session_a35_bink_stats(app->movie_bink, &stats);
    record(app, "scene_a35_open branch=Bink name=%s status=%d width=%u height=%u frames=%u "
           "video-adapter=FFmpeg embedded-audio=single-track-native "
           "audio_frames=%llu rate=%u channels=%u pcm_sha256=%s detail=%s",
           body->name, status, info.width, info.height, info.total_frames,
           (unsigned long long)stats.audio_frames, stats.audio_rate, stats.audio_channels,
           stats.pcm_sha256, error);
    return status;
}

static int native_a35_due(void *context, int *due)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    const int status = session_a35_bink_due(app->movie_bink, due);
    if (status == 0 && !*due) {
        SessionA35BinkStats stats{}; session_a35_bink_stats(app->movie_bink, &stats);
        record(app, "scene_a35_not_due frame=%d clock_ns=%llu origin_ns=%llu",
               stats.frame, (unsigned long long)stats.clock_ns, (unsigned long long)stats.origin_ns);
    }
    return status;
}
static int native_a35_decode(void *context, int16_t *frame)
{ return session_a35_bink_decode(static_cast<NativeApp *>(context)->movie_bink, frame); }
static int native_a35_next(void *context, int *more)
{ return session_a35_bink_next(static_cast<NativeApp *>(context)->movie_bink, more); }
static int native_a35_rect(void *context, const A35Rect *src, const A35Rect *dst)
{ return session_a35_bink_rect(static_cast<NativeApp *>(context)->movie_bink, src, dst); }

/* Observe committed event values without replacing the recovered kernel's
 * ordered stores. Duplicate same-frame writes are checked by the x86 oracle. */
static int native_a35_handler(void *context, size_t row, const SceneActionInfo *a,
    const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    std::vector<int32_t> previous;
    try { previous.assign(app->movie_world.event_flags,
                          app->movie_world.event_flags + app->movie_world.event_flag_count); }
    catch (...) { return SCENE_ACTION_HANDLER_ERROR; }
    const int status = session_a35_handler(app->a35, row, a, before, out);
    SessionA35BinkStats stats{};
    stats.frame = -1;
    if (app->movie_bink) session_a35_bink_stats(app->movie_bink, &stats);
    for (size_t i = 0; i < previous.size(); ++i) {
        if (previous[i] != app->movie_world.event_flags[i])
            record(app, "scene_a35_event row=%zu phase=%u id=%zu before=%d value=%d frame=%d",
                   row, before->phase, i, previous[i], app->movie_world.event_flags[i], stats.frame);
    }
    if (status == SCENE_ACTION_HANDLER_OK && before->phase == 2u &&
        out->disposition == SCENE_ACTION_HANDLER_COMPLETED)
        record(app, "scene_a35_finished row=%zu phase=2 next_phase=%u", row, out->phase);
    return status;
}

static int native_a35_input(void *context, A35Input *input)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (native_a62_current_selector(app, &input->selector) != 0) return 1;
    input->origin_x = app->scene_destination.left;
    input->origin_y = app->scene_destination.top;
    return 0;
}

static void native_a35_load_world(void *context, A35World *world)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    world->active = app->exit_state.g.latch_5c39f9;
    world->modal = app->captions.lifecycle.g.modal_input;
    world->start = app->start_flag_5bb1ca;
    world->layers[0] = app->captions.lifecycle.g.cursor_layer_enabled;
    world->layers[1] = app->layer_5d16cd;
    world->layers[2] = app->layer_5d1683;
    world->visible = app->movie_visible_5d19fb;
    world->redraw = app->exit_state.g.redraw_request;
    world->cursor = app->exit_state.g.redraw_counter;
}

static void native_a35_store_world(void *context, const A35World *world)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    app->exit_state.g.latch_5c39f9 = world->active;
    app->captions.lifecycle.g.modal_input = world->modal;
    app->start_flag_5bb1ca = world->start;
    app->captions.lifecycle.g.cursor_layer_enabled = world->layers[0];
    app->layer_5d16cd = world->layers[1];
    app->layer_5d1683 = world->layers[2];
    app->movie_visible_5d19fb = world->visible;
    app->exit_state.g.redraw_request = world->redraw;
    app->exit_state.g.redraw_counter = static_cast<uint16_t>(world->cursor);
    record(app, "scene_a35_world active=%d modal=%d start=%d visible=%d redraw=%d cursor=%d",
           world->active, world->modal, world->start, world->visible, world->redraw, world->cursor);
}

static int native_a35_transition(void *context, const A35Result *result)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    SceneTransitionRequest request{};
    request.target_scene = result->scene;
    request.opaque_words[0] = result->frame;
    request.opaque_words[1] = result->vertical;
    request.opaque_words[2] = result->word;
    std::memcpy(request.opaque_dwords, result->dwords, sizeof(request.opaque_dwords));
    return scene_session_request_transition(app->session, &request) == SCENE_SESSION_OK ? 0 : 1;
}

/* RT-8: AUTOTEXT resolves during 0x40f532 scene construction. The caption
 * visit receives the complete selected text, including its existing <e>. */
static ActionFamily97LookupStatus native_a97_lookup(void *context,
    const uint8_t *key, size_t length, const uint8_t **text, size_t *text_length)
{
    const int status = native_a51_autotext_lookup(context, key, length, text, text_length);
    if (status == ACTION_FAMILY_51_LOOKUP_FOUND) return ACTION_FAMILY_97_LOOKUP_FOUND;
    if (status == ACTION_FAMILY_51_LOOKUP_NOT_FOUND) return ACTION_FAMILY_97_LOOKUP_MISSING;
    return ACTION_FAMILY_97_LOOKUP_FAILED;
}

static ActionSoundBackendStatus native_a97_caption(void *context,
    const ActionSoundCaptionRequest *request)
{
    if (request == nullptr || request->terminator_length != 0u)
        return ACTION_SOUND_BACKEND_ERROR;
    const int status = native_a51_write_caption(context, request->bytes, request->length);
    if (status == ACTION_FAMILY_51_BACKEND_OK) return ACTION_SOUND_BACKEND_OK;
    NativeApp *app = static_cast<NativeApp *>(context);
    return app != nullptr && app->captions.transfer_blocked
        ? ACTION_SOUND_BACKEND_UNSUPPORTED : ACTION_SOUND_BACKEND_ERROR;
}

static int native_a97_captions_enabled(void *context, uint8_t *enabled)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || enabled == nullptr) return 1;
    *enabled = app->world_clock_session.captions_enabled_5bb202;
    return 0;
}

static int native_a97_transition(void *context, const ActionSoundTransition *effect)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || app->session == nullptr || effect == nullptr) return 1;
    SceneTransitionRequest request{};
    request.target_scene = effect->target_scene;
    std::memcpy(request.opaque_words, effect->opaque_words, sizeof(request.opaque_words));
    std::memcpy(request.opaque_dwords, effect->opaque_dwords, sizeof(request.opaque_dwords));
    if (scene_session_request_transition(app->session, &request) != SCENE_SESSION_OK) return 1;
    app->start_flag_5bb1ca = effect->scene_flag_value;
    record(app, "scene_a97_transition target=%d start=%u engine-state=%u",
           request.target_scene, effect->scene_flag_value, effect->engine_state_value);
    return 0;
}

/* RT-21: raw 0xa1 shares the caption writer and the caption flag with raw 0x97 (0x432d1a is
 * one function). Its transition is the same tuple; only the log line names the family. */
static int native_aa1_transition(void *context, const ActionSoundTransition *effect)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || app->session == nullptr || effect == nullptr) return 1;
    SceneTransitionRequest request{};
    request.target_scene = effect->target_scene;
    std::memcpy(request.opaque_words, effect->opaque_words, sizeof(request.opaque_words));
    std::memcpy(request.opaque_dwords, effect->opaque_dwords, sizeof(request.opaque_dwords));
    if (scene_session_request_transition(app->session, &request) != SCENE_SESSION_OK) return 1;
    app->start_flag_5bb1ca = effect->scene_flag_value;
    record(app, "scene_aa1_transition target=%d start=%u engine-state=%u",
           request.target_scene, effect->scene_flag_value, effect->engine_state_value);
    return 0;
}

/* RT-21: the event dword table 0x585801 + id*4 (0x432e0e..0x432e35) is the same vector the
 * dependency leaves and raw 0x61/0x62/0x36 write: the New Game event flag view. */
static int native_aa1_load_events(void *context, A97EventTable *events)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || events == nullptr || app->new_game.action_core.event_flags == nullptr)
        return 1;
    events->flags = app->new_game.action_core.event_flags;
    events->count = app->new_game.action_core.event_flag_count;
    return 0;
}

/* One log line per visit of a raw 0xa1 row (phase before -> after, handler status), like
 * scene_action_sound for raw 0x9f. */
static int native_aa1_handler(void *context, size_t index, const SceneActionInfo *info,
                              const SceneActionRuntimeState *before,
                              SceneActionHandlerResult *result)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || before == nullptr || result == nullptr) return SCENE_ACTION_HANDLER_ERROR;
    const uint32_t phase_before = before->phase;
    const int status = session_aa1_handler(app->aa1, index, info, before, result);
    record(app, "scene_aa1_visit row=%zu phase=%u status=%d phase_after=%u disposition=%d "
           "(0x4297be -> 0x432d1a)", index, phase_before, status,
           status == SCENE_ACTION_HANDLER_OK ? result->phase : phase_before,
           status == SCENE_ACTION_HANDLER_OK ? (int)result->disposition : -1);
    return status;
}

static void native_aa1_event_stored(void *context, size_t row, int16_t id, int32_t value,
                                    int32_t previous)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr) return;
    record(app, "scene_aa1_event_write row=%zu event=%d value=%d previous=%d "
           "(dword 0x585801+id*4 := byte +0xa7, 0x432e35)", row, (int)id, value, previous);
}

static int native_a83_refresh(void *context, int16_t group, int32_t active, int16_t child)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (active != 1) return 2;
    const int status = scene_session_mark_ui_dirty(app->session, group, child);
    record(app, "scene_a83_refresh group=%d active=%d child=%d mail_count=%d web_count=%d status=%d",
           group, active, child, app->phone_lists.mail_count, app->phone_lists.web_count, status);
    return status == SCENE_SESSION_OK ? 0 : 2;
}

static int native_a83_handler(void *context, size_t row, const SceneActionInfo *action,
                              const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    const int status = session_a83_handler(app->a83, row, action, before, out);
    if (status == SCENE_ACTION_HANDLER_OK && out->disposition != SCENE_ACTION_HANDLER_DIRECT_COMPLETED) {
        record(app, "scene_a83_not_applied row=%zu disposition=%d phase=%u", row, out->disposition, out->phase);
    } else if (status == SCENE_ACTION_HANDLER_OK) {
        const A83Result *last = session_a83_last_result(app->a83);
        record(app, "scene_a83_applied row=%zu list=%s selected=%d inserted=%u mail_count=%d web_count=%d disposition=%d phase=%u",
               row, last != nullptr && last->list != 0u ? "web" : "mail",
               last != nullptr ? last->selected : -1, last != nullptr ? last->inserted : 0u,
               app->phone_lists.mail_count, app->phone_lists.web_count, out->disposition, out->phase);
    } else
        record(app, "scene_a83_blocker row=%zu status=%d detail=%s", row, status,
               session_a83_failure(app->a83));
    return status;
}

/* The 0x83 phone lists: bind the native storage, run the UICL initializer
 * (0x4e4337 / 0x4e2e64..0x4e2fa4) and create the binding. A previous binding
 * (a repeated call) is destroyed first so it is neither leaked nor left
 * pointing at the re-initialized lists. Capacities are native bounds, not
 * original globals. */
static bool create_phone_list_binding(NativeApp *app, const uint8_t *uicl, size_t uicl_length)
{
    if (app->a83 != nullptr) {
        record(app, "scene_a83_replaced_previous_binding");
        session_a83_destroy(app->a83);
        app->a83 = nullptr;
    }
    app->phone_lists.mail = app->phone_mail;
    app->phone_lists.mail_capacity = 100u;
    app->phone_lists.web = app->phone_web;
    app->phone_lists.web_capacity = 100u;
    if (action83_initialize(&app->phone_lists, uicl, uicl_length) != A83_OK) return false;
    SessionA83Host a83_host{&app->phone_lists, {app, native_a83_refresh}};
    app->a83 = session_a83_create(&a83_host);
    if (app->a83 == nullptr) return false;
    record(app, "scene_a83_initialized source=BOOT/UICL mail_count=%d web_count=%d",
           app->phone_lists.mail_count, app->phone_lists.web_count);
    return true;
}

/* RT-13: 0x4e812f is the original inventory view rebuild that follows a list
 * change. The native app has no inventory view model (and no item type table),
 * so this provider only records that the original would have rebuilt the view.
 * What 0x4e812f derives (lists 0x583abd/0x583b49, words 0x583a2d/0x583a2f, the
 * per-page slot table, paging floats) is therefore NOT maintained: UNVERIFIED,
 * nothing in the native app reads it yet. */
static void inventory_view_sync(NativeApp *app);

static int native_a79_rebuild_view(void *context, int16_t removed_item)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr) return 1;
    ++app->inventory_view_rebuilds;
    inventory_view_sync(app);   /* RT-22: the slot fill of 0x4e812f (rest not modeled) */
    record(app, "scene_a79_inventory_removed item=%d count=%d view-rebuild=requested-not-modeled "
           "rebuilds=%llu", removed_item,
           (int)static_cast<int16_t>(app->new_game.selector_words[0]),
           (unsigned long long)app->inventory_view_rebuilds);
    return 0;
}

/* ---- RT-19: host providers for the raw 0x78 (add inventory item) binding ----
 * 0x4e9e84 / 0x4ea06c request the same 0x4e812f view rebuild as raw 0x79 (counted
 * with it, still not modeled). The two requests below are the original's host
 * effects and are only recorded: 0x4fb2e3(0x17) starts the sound-manager slot 0x17
 * (a validity probe 0x4f6059 plus a store of 1 into the slot's trigger word;
 * which clip slot 0x17 holds is unrecovered and this app has no sound-effect
 * backend), and 0x4e0559(1, 1, 0) sets two dword flags of the UI button table
 * at 0x5a17b4 (+0x1a4 per button) that the interface renderer reads (the app
 * renders no such buttons). Both are UNVERIFIED host effects, never silent, and
 * neither blocks the session (the original does not wait for them). */
static int native_a78_rebuild_view(void *context, int16_t item)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr) return 1;
    ++app->inventory_view_rebuilds;
    inventory_view_sync(app);   /* RT-22 */
    record(app, "scene_a78_inventory_changed item=%d count=%d view-rebuild=requested-not-modeled "
           "rebuilds=%llu", item,
           (int)static_cast<int16_t>(app->new_game.view.inventory.selector_words_583a2b.values[0]),
           (unsigned long long)app->inventory_view_rebuilds);
    return 0;
}

static int native_a78_request_sound(void *context, uint16_t slot)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr) return 1;
    ++app->a78_sound_requests;
    record(app, "scene_a78_sound_request slot=0x%02x (0x4fb2e3 trigger; NOT PLAYED: no sound-effect "
           "backend, slot clip unrecovered, unverified) requests=%llu", slot,
           (unsigned long long)app->a78_sound_requests);
    return 0;
}

static int native_a78_request_ui_animation(void *context, int16_t index, int32_t enable, int16_t sub)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr) return 1;
    ++app->a78_ui_requests;
    record(app, "scene_a78_ui_animation_request button=%d enable=%d sub=%d (0x4e0559 on 0x570508: "
           "UI button flags 0x5a17b4/0x5a17b8; NOT RENDERED, unverified) requests=%llu", index, enable,
           sub, (unsigned long long)app->a78_ui_requests);
    return 0;
}

/* ---- RT-22: the inventory view (object 0x571442) ------------------------
 * See inventory_view_runtime.h for the recovered addresses. Rendering (icons,
 * highlight, taskbar), the open transition (0x4e94c1 modes 0/4/5), the tab lists
 * 0x65/0x66, paging, keyboard arrows and every sound are NOT implemented: sounds
 * and the teardown are logged as NOT PLAYED / NOT RENDERED. */
static Action79Model inventory_model(NativeApp *app)
{
    WorldInitInventory &inventory = app->new_game.view.inventory;
    Action79Model model{};
    model.held_item = inventory.selected_item_candidate;
    model.item_count = reinterpret_cast<int16_t *>(inventory.selector_words_583a2b.values);
    model.items = inventory.item_ids_583a31.values;
    model.item_capacity = inventory.item_ids_583a31.count;
    model.presence = inventory.presence_583bd5.values;
    model.presence_capacity = inventory.presence_583bd5.count;
    return model;
}

static void inventory_view_ensure(NativeApp *app)
{
    if (!app->inv_view_initialized) {
        inventory_view_init(&app->inv_view);
        app->inv_view_initialized = true;
    }
    if (app->inv_data_ready) return;
    const uint8_t *uiiv = nullptr, *inv = nullptr, *curs = nullptr;
    size_t uiiv_size = 0, inv_size = 0, curs_size = 0;
    if (!find_boot_payload(app, "UIIV", &uiiv, &uiiv_size) ||
        !find_boot_payload(app, "INV", &inv, &inv_size) ||
        !find_boot_payload(app, "CURS", &curs, &curs_size) ||
        inventory_view_items_from_inv(inv, inv_size, app->inv_kind, app->inv_text) != INVVIEW_OK) {
        record(app, "inventory_view_data_missing (BOOT chunks UIIV/INV/CURS)");
        return;
    }
    app->inv_uiiv.assign(uiiv, uiiv + uiiv_size);
    app->inv_curs.assign(curs, curs + curs_size);
    app->inv_data_ready = true;
}

static void inventory_view_sync(NativeApp *app)
{
    inventory_view_ensure(app);
    const Action79Model model = inventory_model(app);
    const char *why = "none";
    const int status = inventory_view_rebuild(&app->inv_view, &model, &why);
    if (status != INVVIEW_OK)
        record(app, "inventory_view_rebuild_error status=%d detail=%s", status, why);
}

static int native_inv_view_sound(void *context, uint16_t slot)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr) return 1;
    ++app->inv_view_sounds;
    record(app, "inventory_view_sound_request slot=0x%02x (0x4fb2e3 trigger; NOT PLAYED: no sound-effect "
           "backend, unverified) requests=%llu", slot, (unsigned long long)app->inv_view_sounds);
    return 0;
}

static int native_inv_view_close(void *context)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr) return 1;
    record(app, "inventory_view_close (0x4e7d04: teardown 0x4edb97 and 0x4d36ed NOT RENDERED)");
    return 0;
}

static void inventory_view_hover_now(NativeApp *app)
{
    const int16_t held = *app->new_game.view.inventory.selected_item_candidate;
    int32_t index = 0, variant = 0, dx = 0, dy = 0;
    inventory_view_cursor_choice(held, 0, 0, &index, &variant);   /* 0x5c39e9 / 0x5b44f8: no producer */
    if (inventory_view_cursor_hotspot(app->inv_curs.data(), app->inv_curs.size(), index, variant,
                                      &dx, &dy) != INVVIEW_OK)
        return;
    int ran = 0;
    const int32_t before = app->inv_view.hot;
    inventory_view_hover(&app->inv_view, &app->inv_layout, app->pointer_x + dx, app->pointer_y + dy,
                         held, 0, &ran);
    if (ran && app->inv_view.hot != before)
        record(app, "inventory_view_hover pointer=%d,%d hot_point=%d,%d cursor=%d/%d hot_item=%d event=0x%x "
               "(0x4e8bb4; cursor sprite not drawn)", app->pointer_x, app->pointer_y, dx, dy, index,
               variant, app->inv_view.hot, app->inv_view.event);
}

/* The open request (byte 0x583232 consumed by 0x43a7ca). */
static bool inventory_view_open_request(NativeApp *app, const char *source)
{
    inventory_view_ensure(app);
    if (!app->inv_data_ready) return false;
    if (inventory_view_layout_from_uiiv(app->inv_uiiv.data(), app->inv_uiiv.size(),
                                        app->scene_destination.left, app->scene_destination.top,
                                        &app->inv_layout) != INVVIEW_OK) {
        record(app, "inventory_view_open_error layout");
        return false;
    }
    int opened = 0;
    inventory_view_open(&app->inv_view, &app->inv_layout, &opened);
    const int32_t *slots = app->inv_view.slot_item;
    record(app, "inventory_view_open source=%s opened=%d state=%d mode=%d tab=%d slots=%d,%d,%d,%d "
           "origin=%d,%d (open transition 0x4e94c1 modes 0/4/5 NOT RECOVERED, entered at mode 2; "
           "view NOT RENDERED)",
           source, opened, app->inv_view.screen_state, app->inv_view.mode, app->inv_view.tab,
           slots[0], slots[1], slots[2], slots[3], app->scene_destination.left,
           app->scene_destination.top);
    if (opened) inventory_view_hover_now(app);   /* the first tick's hover (0x4d3106) */
    return opened != 0;
}

static void inventory_view_pointer_event(NativeApp *app, int event_kind, int32_t x, int32_t y)
{
    (void)x; (void)y;
    if (!app->inv_data_ready) return;
    if (event_kind == BLACKMOOR_POINTER_MOVE) {
        inventory_view_hover_now(app);
        return;
    }
    /* A left button down or double click: 0x4e8dc8 -> 0x4e8e78 with the hot item of the
     * last hover (the original runs the click branch instead of the hover in that tick). */
    const WorldInitInventory &inventory = app->new_game.view.inventory;
    Action78Model model{};
    model.inventory = inventory_model(app);
    model.view.mode = app->inv_view.mode;
    model.view.slot_flag = app->inv_layout.slot_flag;
    InventoryViewItemData data{};
    data.kind = app->inv_kind;
    data.text = app->inv_text;
    data.aux_a = inventory.auxiliary_583ced.values;
    data.aux_b = inventory.auxiliary_583e05.values;
    data.aux_count = inventory.auxiliary_583ced.count < inventory.auxiliary_583e05.count
                         ? inventory.auxiliary_583ced.count : inventory.auxiliary_583e05.count;
    InventoryViewHost host{};
    host.inventory.inventory.context = app;
    host.inventory.inventory.rebuild_view = native_a79_rebuild_view;
    host.inventory.request_sound = native_a78_request_sound;
    host.inventory.request_ui_animation = native_a78_request_ui_animation;
    host.inventory.context = app;
    host.request_sound = native_inv_view_sound;
    host.close_view = native_inv_view_close;
    host.context = app;
    InventoryViewClickResult result{};
    const char *why = "none";
    const int32_t hot = app->inv_view.hot;
    const int status = inventory_view_click(&app->inv_view, &app->inv_layout, &data, &model, &host, 0,
                                            &result, &why);
    record(app, "inventory_view_click status=%d hot_item=%d event=0x%x handled=%u picked=%u put_back=%u "
           "closed=%u held=%d count=%d detail=%s (0x4e8e78)", status, hot, app->inv_view.event,
           result.handled, result.picked, result.put_back, result.closed,
           (int)*inventory.selected_item_candidate,
           (int)static_cast<int16_t>(inventory.selector_words_583a2b.values[0]), why);
    if (result.picked)
        record(app, "inventory_view_held_item_set item=%d (word 0x583a29; the scene dependency opcode 11 "
               "'held item == N' reads it)", (int)*inventory.selected_item_candidate);
}

/* ---- RT-22 follow-up: the task bar (0x570508) and its inventory button ----
 * See inventory_button_runtime.h for the recovered addresses. The bar runs while the
 * screen state 0x583204 is 0 (0x43cf9c); its button 1 raises byte 0x583232, which the next
 * tick turns into the inventory view (0x43a862..0x43a8ad). Sounds are logged NOT PLAYED
 * (no effect backend), the frame image is not drawn, the locked-button message, the lock
 * table producers and the other four buttons' actions are not modelled. */
static int native_bar_hotspot(void *context, int32_t index, int32_t variant, int32_t *dx,
                              int32_t *dy)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || dx == nullptr || dy == nullptr) return 1;
    return inventory_view_cursor_hotspot(app->inv_curs.data(), app->inv_curs.size(), index,
                                         variant, dx, dy) == INVVIEW_OK ? 0 : 1;
}

static int native_bar_sound(void *context, const char *name, uint16_t slot)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || name == nullptr) return 1;
    ++app->bar_sound_requests;
    record(app, "taskbar_sound_request name=%s slot=0x%02x (0x4fb77a/0x4fb2e3 trigger; NOT PLAYED: no "
           "sound-effect backend, unverified) requests=%llu", name, slot,
           (unsigned long long)app->bar_sound_requests);
    return 0;
}

static int native_bar_sound_busy(void *context, uint16_t slot, int *busy)
{
    (void)slot;
    if (context == nullptr || busy == nullptr) return 1;
    *busy = 0;   /* nothing plays, so a click sound is always finished (0x4f6334 stand-in) */
    return 0;
}

static TaskbarHost bar_host(NativeApp *app)
{
    TaskbarHost host{};
    host.hotspot = native_bar_hotspot;
    host.request_sound = native_bar_sound;
    host.sound_busy = native_bar_sound_busy;
    host.context = app;
    return host;
}

static bool taskbar_ready_now(NativeApp *app)
{
    if (app->bar_ready) return true;
    if (app->bar_missing) return false;
    inventory_view_ensure(app);   /* CURS (hot points) comes with the inventory data */
    if (!app->inv_data_ready) return false;
    const uint8_t *task = nullptr;
    size_t task_size = 0;
    if (!find_boot_payload(app, "TASK", &task, &task_size) ||
        taskbar_layout_from_task(task, task_size, app->scene_destination.left,
                                 app->scene_destination.top, &app->bar_layout) != TASKBAR_OK ||
        taskbar_init(&app->bar, &app->bar_layout) != TASKBAR_OK) {
        record(app, "taskbar_data_missing (BOOT chunk TASK)");
        app->bar_missing = true;
        return false;
    }
    app->bar_ready = true;
    const TaskbarLayout &layout = app->bar_layout;
    record(app, "taskbar_ready bounds=%d,%d,%d,%d inventory_button=%d,%d,%d,%d delay_ms=%u "
           "sound=%s slot=0x%02x (chunk TASK; frame image NOT RENDERED)", layout.bounds[0],
           layout.bounds[1], layout.bounds[2], layout.bounds[3],
           layout.button[TASKBAR_BUTTON_INVENTORY].rect[0], layout.button[TASKBAR_BUTTON_INVENTORY].rect[1],
           layout.button[TASKBAR_BUTTON_INVENTORY].rect[2], layout.button[TASKBAR_BUTTON_INVENTORY].rect[3],
           layout.button[TASKBAR_BUTTON_INVENTORY].delay_ms,
           layout.button[TASKBAR_BUTTON_INVENTORY].sound_name,
           layout.button[TASKBAR_BUTTON_INVENTORY].sound_slot);
    return true;
}

/* The bar belongs to a running scene session; a blocked session is frozen as before. */
static bool taskbar_active(NativeApp *app)
{
    return app->session != nullptr && !app->session_block_reported && taskbar_ready_now(app);
}

/* 0x4d3073 -> 0x4e075a with the cursor rectangle of the last pointer position. */
static void taskbar_hover_at(NativeApp *app, int32_t x, int32_t y)
{
    if (x < 0 || y < 0) return;
    const ProvisionalCursorProvider &cursor = app->cursor_provider;
    const int32_t rect[4] = {x, y, x + cursor.sprite_width - 1, y + cursor.sprite_height - 1};
    TaskbarHost host = bar_host(app);
    int32_t dx = 0, dy = 0;
    /* 0x5b44f0/f4 of the previous tick: the scene cascade's cursor (nav zones), else 0/0. */
    int32_t index = app->nav_cursor.index, variant = app->nav_cursor.variant;
    if (native_bar_hotspot(app, index, variant, &dx, &dy) != 0) { index = 0; variant = 0; }
    app->bar.cursor_index = index;
    app->bar.cursor_variant = variant;
    TaskbarHoverResult result{};
    const int status = taskbar_hover(&app->bar, &app->bar_layout, rect, &host, &result);
    if (status != TASKBAR_OK) {
        record(app, "taskbar_hover_error status=%d", status);
        return;
    }
    if (result.ran && result.hit != app->bar_last_hit) {
        app->bar_last_hit = result.hit;
        record(app, "taskbar_hover pointer=%d,%d hot_point=%d,%d hit=%d state=%d cursor=%d/%d "
               "event=0x%x (0x4e075a/0x4e22fd; cursor sprite not drawn)", x, y, result.x - x,
               result.y - y, result.hit,
               result.hit >= 0 ? (int)app->bar.button[result.hit].state : -1, result.cursor_index,
               result.cursor_variant, (unsigned)result.event);
    }
}

/* Start of a tick (0x43a7ca): the inventory byte opens the view while 0x583204 is 0;
 * otherwise the per-tick hover (0x4d3073). */
static void taskbar_pre_tick(NativeApp *app)
{
    if (app->inv_view.screen_state != INVVIEW_STATE_NONE || !taskbar_active(app)) return;
    if (app->bar.flag[TASKBAR_BUTTON_INVENTORY]) {
        app->bar.flag[TASKBAR_BUTTON_INVENTORY] = 0;     /* 0x43a875 */
        record(app, "taskbar_inventory_flag_consumed byte=0x583232 (0x43a858)");
        inventory_view_open_request(app, "taskbar button 1 (byte 0x583232)");
        return;
    }
    taskbar_hover_at(app, app->pointer_x, app->pointer_y);
}

/* End of a tick (0x43cf9c): 0x4e0e2b while 0x583204 is 0. */
static void taskbar_post_tick(NativeApp *app, uint32_t now)
{
    if (app->inv_view.screen_state != INVVIEW_STATE_NONE || !taskbar_active(app)) return;
    TaskbarHost host = bar_host(app);
    TaskbarProcessResult result{};
    const int status = taskbar_process(&app->bar, &app->bar_layout,
                                       (int16_t)app->exit_state.g.scene_request, now, &host,
                                       &result);
    if (status != TASKBAR_OK) {
        record(app, "taskbar_process_error status=%d", status);
        return;
    }
    if (result.loaded)
        record(app, "taskbar_loaded scene_request=%d (0x4e0e6b: frame image 'game frame' load "
               "NOT RENDERED)", (int)(int16_t)app->exit_state.g.scene_request);
    for (unsigned i = 0; i < TASKBAR_BUTTONS; ++i) {
        if (result.completed[i])
            record(app, "taskbar_button_completed index=%u (0x4e2b10: press timer expired)", i);
        if (result.flag_set[i]) {
            static const unsigned bytes[TASKBAR_BUTTONS] = {0x583220u, 0x583232u, 0x583233u,
                                                            0x583234u, 0x58321fu};
            record(app, "taskbar_flag index=%u byte=0x%x%s", i, bytes[i],
                   i == TASKBAR_BUTTON_INVENTORY ? " (opens the inventory view next tick)"
                                                 : " (action NOT modelled)");
        }
    }
}

/* A pointer message while no sub-screen is up. Returns true when the bar consumed it. */
static bool taskbar_pointer_event(NativeApp *app, int event_kind, unsigned button, int32_t x,
                                  int32_t y)
{
    if (app->inv_view.screen_state == INVVIEW_STATE_INVENTORY && button == 1u &&
        event_kind == BLACKMOOR_POINTER_DOWN) {
        /* NOT original: the in-view close controls (frame button 0x4ee517, keys) are not
         * recovered, so a right click closes the view to keep the session usable. */
        record(app, "inventory_view_close_fallback right-click (NOT in the original: frame close "
               "button 0x4ee517 and the key table are not recovered)");
        inventory_view_close(&app->inv_view);
        native_inv_view_close(app);
        return true;
    }
    if (button == 0u && event_kind == BLACKMOOR_POINTER_UP && app->bar_swallow_up) {
        app->bar_swallow_up = false;   /* the release of a press the bar took */
        return true;
    }
    if (button != 0u || app->inv_view.screen_state != INVVIEW_STATE_NONE || !taskbar_active(app))
        return false;
    if (event_kind != BLACKMOOR_POINTER_DOWN && event_kind != kPointerDoubleClick) return false;
    /* The hover of the preceding tick, for a pointer that has settled on x,y. */
    taskbar_hover_at(app, x, y);
    TaskbarHost host = bar_host(app);
    TaskbarClickResult result{};
    const int status = taskbar_click(&app->bar, &app->bar_layout, app->session_tick_sample, &host,
                                     &result);
    if (status != TASKBAR_OK) {
        record(app, "taskbar_click_error status=%d", status);
        return false;
    }
    if (result.pressed >= 0 || result.locked_click >= 0)
        record(app, "taskbar_click pointer=%d,%d pressed=%d locked=%d deadline=%u event=0x%x "
               "(0x4e0978/0x4e26fc; locked-button message NOT modelled)", x, y, result.pressed,
               result.locked_click,
               result.pressed >= 0 ? (unsigned)app->bar.button[result.pressed].deadline : 0u,
               (unsigned)app->bar.event);
    /* 0x43b1fc: the scene's own click is not raised while the event is 0x27d8. */
    if (app->bar.event == TASKBAR_EVENT_BUTTON) {
        app->bar_swallow_up = true;
        return true;
    }
    return false;
}

/* ---- RT-14: host providers for the raw 0x36 overlay binding -------------
 * COverlay (0x4899ca) registers a render entry per row, draws it every frame
 * through 0x48a3db and is hit-tested by the pointer cascade (0x4f104f ->
 * 0x4897cd). Surfaces are the game's own CIFTREE images (0x4c2790), blits are
 * the recovered 0x4c5377/0x4c5d4b into the host back buffer. Sounds named by an
 * overlay (0x4fb77a family) have no native backend here: such a row is an
 * explicit UNSUPPORTED blocker before it registers. */
static int native_a36_load_surface(void *context, const char *name, uint32_t *surface)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || name == nullptr || surface == nullptr) return 1;
    const uint32_t handle = native_caption_load_image(app, name, "overlay");
    if (handle == 0u) {
        record(app, "scene_a36_surface_error name=%s detail=CIFTREE-image-unavailable", name);
        return 1;
    }
    *surface = handle;
    return 0;
}

static int native_a36_tick_count(void *context, uint32_t *ticks)
{
    if (context == nullptr || ticks == nullptr) return 1;
    *ticks = blackmoor_macos_monotonic_ms();
    return 0;
}

static int native_a36_row_phase(void *context, int32_t row, uint32_t *phase)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    SceneActionRuntimeState state{};
    if (app == nullptr || app->session == nullptr || phase == nullptr || row < 0 ||
        scene_session_get_action_state(app->session, static_cast<size_t>(row), &state) !=
            SCENE_SESSION_OK) return 1;
    *phase = state.phase;
    return 0;
}

static int native_a36_blit(void *context, const Overlay36Blit *op)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || op == nullptr) return 1;
    NativeCaptionRuntime &captions = app->captions;
    CaptionCompositorView source{};
    CaptionCompositorView destination{};
    destination.pixels = captions.backbuffer_pixels.data();
    destination.byte_capacity = captions.backbuffer_pixels.size();
    destination.width = 640;
    destination.height = 480;
    destination.pitch_bytes = 1280;
    destination.format = captions.compositor_format;
    int status = CAPTION_COMPOSITOR_OK;
    if (!captions.backbuffer_ready || op->source_surface == 0u ||
        !native_caption_view_for_handle(app, op->source_surface, &source))
        status = CAPTION_COMPOSITOR_ERR_UNSUPPORTED;
    const CaptionRect src{op->src[0], op->src[1], op->src[2], op->src[3]};
    const CaptionRect dst{op->dst[0], op->dst[1], op->dst[2], op->dst[3]};
    if (status == CAPTION_COMPOSITOR_OK)
        status = caption_compositor_blit(&source, &destination,
            op->kind == OVERLAY36_BLIT_PLAIN ? CAPTION_BLIT_OPAQUE : CAPTION_BLIT_KEYED,
            &src, &dst, captions.pixel_format.color_key);
    if (status != CAPTION_COMPOSITOR_OK) {
        record(app, "scene_a36_blit_error row=%d slot=%d kind=%d surface=%u status=%d src=%d,%d,%d,%d "
               "dst=%d,%d,%d,%d label=%s", op->row, op->slot, op->kind, op->source_surface, status,
               op->src[0], op->src[1], op->src[2], op->src[3], op->dst[0], op->dst[1], op->dst[2],
               op->dst[3], op->label ? op->label : "unknown");
        return 1;
    }
    ++app->a36_blits;
    /* One line per distinct blit of a row, not one per frame. */
    uint64_t signature = UINT64_C(14695981039346656037);
    for (int value : {op->kind, static_cast<int>(op->source_surface), op->src[0], op->src[1], op->src[2],
                      op->src[3], op->dst[0], op->dst[1], op->dst[2], op->dst[3]}) {
        signature ^= static_cast<uint32_t>(value);
        signature *= UINT64_C(1099511628211);
    }
    if (op->row >= 0 && static_cast<size_t>(op->row) < app->a36_blit_signature.size() &&
        app->a36_blit_signature[static_cast<size_t>(op->row)] != signature) {
        app->a36_blit_signature[static_cast<size_t>(op->row)] = signature;
        record(app, "scene_a36_blit row=%d slot=%d kind=%s surface=%u src=%d,%d,%d,%d dst=%d,%d,%d,%d "
               "composed=RGB555-backbuffer scope=host-adapter (layer order vs UI unverified)",
               op->row, op->slot, op->kind == OVERLAY36_BLIT_PLAIN ? "plain" : "keyed",
               op->source_surface, op->src[0], op->src[1], op->src[2], op->src[3],
               op->dst[0], op->dst[1], op->dst[2], op->dst[3]);
    }
    return 0;
}

static void native_a36_observe(void *context, int effect, int32_t a, int32_t b)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr) return;
    switch (effect) {
    case OV36_FX_LIST_PUSH:
        record(app, "scene_a36_register row=%d list_index=%d (COverlay::Process phase 0, 0x4899ca)", b, a);
        break;
    case OV36_FX_CACHE_REUSE:
        record(app, "scene_a36_surface_reuse cache_slot=%d surface=%u", a, static_cast<uint32_t>(b));
        break;
    case OV36_FX_SURFACE_LOAD:
        record(app, "scene_a36_surface_load cache_slot=%d surface=%u source=CIFTREE", a,
               static_cast<uint32_t>(b));
        break;
    case OV36_FX_RENDER_STORE:
        record(app, "scene_a36_render_entry slot=%d layer=%d callback=0x48a3db", a, b);
        break;
    case OV36_FX_PHASE:
        record(app, "scene_a36_phase new_phase=%d", a);
        break;
    case OV36_FX_EVENT_WRITE:
        record(app, "scene_a36_event_write event=%d value=%d", a, b);
        break;
    case OV36_FX_TRANSFER:
        record(app, "scene_a36_scene_change_words target=%d (0x5bb57b.., mode 0x583999 := 4)", a);
        break;
    case OV36_FX_FINISH:
        record(app, "scene_a36_finish row=%d (0x42ba3a)", a);
        break;
    default:
        break;
    }
}

static int native_a36_load_world(void *context, Overlay36World *world)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || world == nullptr || app->new_game.action_core.event_flags == nullptr ||
        !app->selector_entry_valid || app->selector_entry_frame < INT16_MIN ||
        app->selector_entry_frame > INT16_MAX) return 1;
    world->events = app->new_game.action_core.event_flags;
    world->event_count = app->new_game.action_core.event_flag_count;
    /* DAT_005bb50b, see native_a62_current_selector. */
    world->selector = static_cast<int16_t>(app->selector_entry_frame);
    const int16_t *held = app->new_game.view.inventory.selected_item_candidate;
    world->held_item = held != nullptr ? *held : static_cast<int16_t>(-1);
    world->start_flag_5bb1ca = app->start_flag_5bb1ca;
    world->mode_583999 = 3;
    /* 0x583186 / 0x58318a: left/top of the VIEW destination rectangle. */
    world->view_x_583186 = app->scene_destination.left;
    world->view_y_58318a = app->scene_destination.top;
    /* 0x5d15e3 (saved background of the transparent-restore blit) and the
     * AUTOTEXT surface globals are not modeled: a blit that needs them fails
     * explicitly (surface 0). */
    return 0;
}

static void native_a36_store_world(void *context, const Overlay36World *world)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || world == nullptr) return;
    app->start_flag_5bb1ca = world->start_flag_5bb1ca;
}

static int native_a36_transition(void *context, const SceneTransitionRequest *request)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || app->session == nullptr || request == nullptr) return 1;
    if (scene_session_request_transition(app->session, request) != SCENE_SESSION_OK) return 1;
    record(app, "scene_a36_transition target=%d opaque_words=%d,%d,%d opaque_dwords=%d,%d,%d",
           request->target_scene, request->opaque_words[0], request->opaque_words[1],
           request->opaque_words[2], request->opaque_dwords[0], request->opaque_dwords[1],
           request->opaque_dwords[2]);
    return 0;
}

/* ---- RT-15: raw 0x16/0x17 multiframe scene hotspot (handler 0x42b07e) ----- */
static int native_a17_load_world(void *context, Action17World *world)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || world == nullptr || !app->selector_entry_valid ||
        app->selector_entry_frame < INT16_MIN || app->selector_entry_frame > INT16_MAX) return 1;
    /* DAT_005bb50b, see native_a62_current_selector. */
    world->selector = static_cast<int16_t>(app->selector_entry_frame);
    world->start_flag_5bb1ca = app->start_flag_5bb1ca;
    world->mode_583999 = 3;
    return 0;
}

static void native_a17_store_world(void *context, const Action17World *world)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || world == nullptr) return;
    app->start_flag_5bb1ca = world->start_flag_5bb1ca;
}

static int native_a17_transition(void *context, const SceneTransitionRequest *request)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || app->session == nullptr || request == nullptr) return 1;
    if (scene_session_request_transition(app->session, request) != SCENE_SESSION_OK) return 1;
    record(app, "scene_a17_transition target=%d opaque_words=%d,%d,%d opaque_dwords=%d,%d,%d "
           "(0x42b217 scene-change cells, mode 0x583999 := 4)",
           request->target_scene, request->opaque_words[0], request->opaque_words[1],
           request->opaque_words[2], request->opaque_dwords[0], request->opaque_dwords[1],
           request->opaque_dwords[2]);
    return 0;
}

static void native_a17_observe(void *context, size_t row, int effect, int32_t value)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    switch (effect) {
    case ACTION17_FX_START_FLAG:
        record(app, "scene_a17_register row=%zu start_flag_5bb1ca=%d (0x42b0b2)", row, value);
        break;
    case ACTION17_FX_REQUEST:
        break;
    case ACTION17_FX_LEFT: app->a17_rect[0] = value; break;
    case ACTION17_FX_TOP: app->a17_rect[1] = value; break;
    case ACTION17_FX_RIGHT: app->a17_rect[2] = value; break;
    case ACTION17_FX_BOTTOM:
        app->a17_rect[3] = value;
        if (!app->a17_logged_valid || std::memcmp(app->a17_rect, app->a17_logged_rect,
                                                  sizeof(app->a17_rect)) != 0) {
            std::memcpy(app->a17_logged_rect, app->a17_rect, sizeof(app->a17_rect));
            app->a17_logged_valid = true;
            record(app, "scene_a17_frame_hit row=%zu request=1 rect=%d,%d,%d,%d selector=%d (0x42b14d)",
                   row, app->a17_rect[0], app->a17_rect[1], app->a17_rect[2], app->a17_rect[3],
                   static_cast<int>(app->selector_entry_frame));
        }
        break;
    case ACTION17_FX_DONE:
        record(app, "scene_a17_finish row=%zu completion_byte=1 (0x42b221)", row);
        break;
    default:
        break;
    }
}

static int native_a0b_transition(void *context, const SceneTransitionRequest *request)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || app->session == nullptr || request == nullptr) return 1;
    if (scene_session_request_transition(app->session, request) != SCENE_SESSION_OK) {
        record(app, "scene_a0b_transition_refused row=%zu target=%d (completion byte not committed)",
               app->a0b_finish_row, request->target_scene);
        return 1;
    }
    record(app, "scene_a0b_finish row=%zu completion_byte=1 (0x42afb3)", app->a0b_finish_row);
    record(app, "scene_a0b_transition target=%d opaque_words=%d,%d,%d opaque_dwords=%d,%d,%d "
           "(0x42afb3 scene-change cells, mode 0x583999 := 4)",
           request->target_scene, request->opaque_words[0], request->opaque_words[1],
           request->opaque_words[2], request->opaque_dwords[0], request->opaque_dwords[1],
           request->opaque_dwords[2]);
    return 0;
}

/* RT-16: the same cells as the 0x42b07e handler; own log names. */
static void native_a0b_observe(void *context, size_t row, int effect, int32_t value)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    switch (effect) {
    case ACTION17_FX_START_FLAG:
        record(app, "scene_a0b_register row=%zu start_flag_5bb1ca=%d (0x42aea9)", row, value);
        break;
    case ACTION17_FX_LEFT: app->a0b_rect[0] = value; break;
    case ACTION17_FX_TOP: app->a0b_rect[1] = value; break;
    case ACTION17_FX_RIGHT: app->a0b_rect[2] = value; break;
    case ACTION17_FX_BOTTOM:
        app->a0b_rect[3] = value;
        if (!app->a0b_logged_valid || std::memcmp(app->a0b_rect, app->a0b_logged_rect,
                                                  sizeof(app->a0b_rect)) != 0) {
            std::memcpy(app->a0b_logged_rect, app->a0b_rect, sizeof(app->a0b_rect));
            app->a0b_logged_valid = true;
            record(app, "scene_a0b_rect row=%zu rect=%d,%d,%d,%d (0x42aed1..0x42af40)", row,
                   app->a0b_rect[0], app->a0b_rect[1], app->a0b_rect[2], app->a0b_rect[3]);
        }
        break;
    case ACTION17_FX_PHASE:
        break;
    case ACTION17_FX_DONE:
        /* Reported by native_a0b_transition once the scene-change request was accepted: a
         * refused request rolls the visit back (the completion byte is not committed). */
        app->a0b_finish_row = row;
        break;
    default:
        break;
    }
}

/* ---- RT-20: raw 0x0c multi-frame scene-change hotspot (handler 0x42b2e4) ----- */
static int native_a0c_load_world(void *context, Action17World *world)
{
#ifdef BLACKMOOR_NATIVE_APP_TEST_HOOKS
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app != nullptr && app->test_a0c_refuse_world) return 1;
#endif
    return native_a17_load_world(context, world);
}

static int native_a0c_transition(void *context, const SceneTransitionRequest *request)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || app->session == nullptr || request == nullptr) return 1;
    if (scene_session_request_transition(app->session, request) != SCENE_SESSION_OK) {
        record(app, "scene_a0c_transition_refused row=%zu target=%d (completion byte not committed)",
               app->a0c_finish_row, request->target_scene);
        return 1;
    }
    record(app, "scene_a0c_finish row=%zu completion_byte=1 (0x42b487)", app->a0c_finish_row);
    record(app, "scene_a0c_transition target=%d opaque_words=%d,%d,%d opaque_dwords=%d,%d,%d "
           "(0x42b49e..0x42b4f8 scene-change cells, mode 0x583999 := 4)",
           request->target_scene, request->opaque_words[0], request->opaque_words[1],
           request->opaque_words[2], request->opaque_dwords[0], request->opaque_dwords[1],
           request->opaque_dwords[2]);
    return 0;
}

static void native_a0c_observe(void *context, size_t row, int effect, int32_t value)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    switch (effect) {
    case ACTION17_FX_START_FLAG:
        record(app, "scene_a0c_register row=%zu start_flag_5bb1ca=%d (0x42b318)", row, value);
        break;
    case ACTION17_FX_LEFT: app->a0c_rect[0] = value; break;
    case ACTION17_FX_TOP: app->a0c_rect[1] = value; break;
    case ACTION17_FX_RIGHT: app->a0c_rect[2] = value; break;
    case ACTION17_FX_BOTTOM:
        app->a0c_rect[3] = value;
        if (row < app->a0c_logged_valid.size() &&
            (app->a0c_logged_valid[row] == 0u ||
             std::memcmp(app->a0c_rect, &app->a0c_logged_rects[row * 4u], sizeof(app->a0c_rect)) != 0)) {
            std::memcpy(&app->a0c_logged_rects[row * 4u], app->a0c_rect, sizeof(app->a0c_rect));
            app->a0c_logged_valid[row] = 1u;
            record(app, "scene_a0c_frame_hit row=%zu request=1 rect=%d,%d,%d,%d selector=%d "
                   "(0x42b3b3..0x42b46a)",
                   row, app->a0c_rect[0], app->a0c_rect[1], app->a0c_rect[2], app->a0c_rect[3],
                   static_cast<int>(app->selector_entry_frame));
        }
        break;
    case ACTION17_FX_DONE:
        /* Reported by native_a0c_transition once the scene-change request was accepted: a
         * refused request rolls the visit back (the completion byte is not committed). */
        app->a0c_finish_row = row;
        break;
    default:
        break;
    }
}

static bool create_native_session_bindings(NativeApp *app)
{
    SessionA62Host a62_host{};
    a62_host.context = app;
    a62_host.current_selector = native_a62_current_selector;
    a62_host.set_start_flag = native_a62_set_start_flag;
    app->a62 = session_a62_create(&app->new_game.action_core, &a62_host);
    SessionA51Host a51_host{};
    a51_host.backend.context = app;
    a51_host.backend.measure_caption_lines = native_a51_measure;
    a51_host.backend.write_caption = native_a51_write_caption;
    a51_host.backend.open_frame_text = native_a51_open_frame_text;
    a51_host.backend.close_frame_text = native_a51_close_frame_text;
    a51_host.backend.is_channel_playing = native_a51_is_channel_playing;
    a51_host.backend.tick_count = native_a51_tick_count;
    /* Without AUTOTEXT (ClosedCaptioning=0 skips the load) the lookup stays
     * unbound and selector -1 rows are a named blocker if visited. */
    a51_host.lookup = app->captions.auto_text != nullptr ? native_a51_autotext_lookup : nullptr;
    a51_host.lookup_context = app;
    a51_host.world_context = app;
    a51_host.load_world = native_a51_load_world;
    a51_host.store_world = native_a51_store_world;
    app->a51 = session_a51_create(&a51_host);
    app->movie_world.event_flags = app->new_game.action_core.event_flags;
    app->movie_world.event_flag_count = app->new_game.action_core.event_flag_count;
    SessionA35Host a35_host{};
    a35_host.movie.context = app;
    a35_host.movie.open = native_a35_open;
    a35_host.movie.close = native_a35_close;
    a35_host.movie.bink_due = native_a35_due;
    a35_host.movie.bink_decode = native_a35_decode;
    a35_host.movie.bink_next = native_a35_next;
    a35_host.movie.rect = native_a35_rect;
    a35_host.input = native_a35_input;
    a35_host.load_world = native_a35_load_world;
    a35_host.store_world = native_a35_store_world;
    a35_host.transition = native_a35_transition;
    app->a35 = session_a35_create(&app->movie_world, &a35_host);
    create_native_conditions_binding(app);
    SessionA97Host a97_host{};
    a97_host.sound.context = app;
    a97_host.sound.present_caption = native_a97_caption;
    a97_host.sound.load_sound = native_action_sound_load;
    a97_host.sound.play_sound = native_action_sound_play;
    a97_host.sound.is_playing = native_action_sound_is_playing;
    a97_host.sound.unload_sound = native_action_sound_unload;
    a97_host.lookup = app->captions.auto_text != nullptr ? native_a97_lookup : nullptr;
    a97_host.lookup_context = app;
    a97_host.random_state = &app->condition_rand.holdrand;
    a97_host.captions_enabled = native_a97_captions_enabled;
    a97_host.transition = native_a97_transition;
    app->a97 = session_a97_create(&a97_host);
    SessionAa1Host aa1_host{};
    aa1_host.sound = a97_host.sound;
    aa1_host.lookup = a97_host.lookup;
    aa1_host.lookup_context = app;
    aa1_host.captions_enabled = native_a97_captions_enabled;
    aa1_host.transition = native_aa1_transition;
    aa1_host.load_events = native_aa1_load_events;
    aa1_host.event_stored = native_aa1_event_stored;
    app->aa1 = session_aa1_create(&aa1_host);
    const uint8_t *uicl = nullptr;
    size_t uicl_length = 0;
    if (!find_boot_payload(app, "UICL", &uicl, &uicl_length) ||
        !create_phone_list_binding(app, uicl, uicl_length)) {
        record(app, "scene_session_create_error provider=action-family-83 detail=UICL-initial-lists");
        return false;
    }
    SessionA79Host a79_host{};
    {
        const WorldInitInventory &inventory = app->new_game.view.inventory;
        a79_host.model.held_item = inventory.selected_item_candidate;
        a79_host.model.item_count = reinterpret_cast<int16_t *>(inventory.selector_words_583a2b.values);
        a79_host.model.items = inventory.item_ids_583a31.values;
        a79_host.model.item_capacity = inventory.item_ids_583a31.count;
        a79_host.model.presence = inventory.presence_583bd5.values;
        a79_host.model.presence_capacity = inventory.presence_583bd5.count;
    }
    a79_host.view.context = app;
    a79_host.view.rebuild_view = native_a79_rebuild_view;
    app->a79 = session_a79_create(&a79_host);
    SessionA78Host a78_host{};
    a78_host.model.inventory = a79_host.model;   /* RT-19: the same arrays as raw 0x79 */
    /* The native app has no inventory screen that can open, so the view stays in its
     * constructor state: mode 0x764c = 0 (0x4e7bb1) and slot byte 0x7010 = 0. */
    a78_host.model.view.mode = 0;
    a78_host.model.view.slot_flag = 0;
    a78_host.view.inventory.context = app;
    a78_host.view.inventory.rebuild_view = native_a78_rebuild_view;
    a78_host.view.context = app;
    a78_host.view.request_sound = native_a78_request_sound;
    a78_host.view.request_ui_animation = native_a78_request_ui_animation;
    app->a78 = session_a78_create(&a78_host);
    SessionA36Host a36_host{};
    a36_host.kernel.context = app;
    a36_host.kernel.load_surface = native_a36_load_surface;
    a36_host.kernel.tick_count = native_a36_tick_count;
    a36_host.kernel.row_phase = native_a36_row_phase;
    a36_host.kernel.blit = native_a36_blit;
    a36_host.kernel.observe = native_a36_observe;
    a36_host.load_world = native_a36_load_world;
    a36_host.store_world = native_a36_store_world;
    a36_host.transition = native_a36_transition;
    app->a36 = session_a36_create(&a36_host);
    SessionA17Host a17_host{};
    a17_host.context = app;
    a17_host.load_world = native_a17_load_world;
    a17_host.store_world = native_a17_store_world;
    a17_host.transition = native_a17_transition;
    a17_host.observe = native_a17_observe;
    app->a17 = session_a17_create(&a17_host);
    SessionA0bHost a0b_host = a17_host;   /* RT-16: same selector, start flag and scene-change request */
    a0b_host.observe = native_a0b_observe;
    a0b_host.transition = native_a0b_transition;
    app->a0b = session_a0b_create(&a0b_host);
    SessionA0cHost a0c_host = a17_host;   /* RT-20: same selector, start flag and scene-change request */
    a0c_host.load_world = native_a0c_load_world;
    a0c_host.observe = native_a0c_observe;
    a0c_host.transition = native_a0c_transition;
    app->a0c = session_a0c_create(&a0c_host);
    {
        const ActionFamily28Rect view = {app->scene_destination.left, app->scene_destination.top,
                                         app->scene_destination.right, app->scene_destination.bottom};
        session_exit_init(&app->exit_state, &view);
        app->a28 = session_a28_create(&app->exit_state);
    }
    if (app->a62 == nullptr || app->a51 == nullptr || app->a28 == nullptr || app->a35 == nullptr || app->a97 == nullptr || app->aa1 == nullptr || app->a83 == nullptr || app->a79 == nullptr || app->a78 == nullptr || app->a36 == nullptr || app->a17 == nullptr || app->a0b == nullptr || app->a0c == nullptr ||
        app->conditions_binding == nullptr) {
        record(app, "scene_session_create_error provider=host detail=binding allocation");
        return false;
    }
    return true;
}

/* ---- RT-17: view navigation (session_navigation) --------------------------- */

/* Game.ini AutoMove: the original reads GetPrivateProfileIntA("Nancy Data",
 * "AutoMove", 1, ...) into 0x5bb206 at 0x434c3b..0x434c52; the hover stepping
 * block 0x43c216 requires it nonzero. A missing key keeps the default 1. */
static int32_t game_ini_auto_move(const std::string &directory, bool *found)
{
    *found = false;
    FILE *file = std::fopen((directory + "/Game.ini").c_str(), "rb");
    if (!file) return 1;
    char line[4096];
    bool data_section = false;
    int32_t result = 1;
    while (std::fgets(line, sizeof(line), file)) {
        std::string value = trim(line);
        const size_t comment = value.find(';');
        if (comment != std::string::npos) value = trim(value.substr(0, comment));
        if (value.empty()) continue;
        if (value.front() == '[') { data_section = value == "[Nancy Data]"; continue; }
        const size_t equal = value.find('=');
        if (!data_section || equal == std::string::npos) continue;
        if (trim(value.substr(0, equal)) == "AutoMove") {
            const std::string setting = trim(value.substr(equal + 1));
            char *end = nullptr;
            const long parsed = std::strtol(setting.c_str(), &end, 10);
            if (!setting.empty() && end != setting.c_str() && *end == '\0') {
                result = static_cast<int32_t>(parsed);
                *found = true;
            }
            break;
        }
    }
    std::fclose(file);
    return result;
}

/* The BOOT BSUM payload is copied over 0x5b0113..0x5b02a4 (0x4356eb), so a
 * global at 0x5b0113+n is BSUM[n]: the band words 0x5b0260 / 0x5b0262 are
 * BSUM[333] / BSUM[335]; the optional hover/key delay override is the byte
 * 0x5b0288 = BSUM[373] and the words 0x5b0289 / 0x5b028b = BSUM[374] / [376]
 * (read at 0x43a6d1..0x43a6ef). */
static bool nav_read_boot(NativeApp *app)
{
    if (app->nav_boot_read) return true;
    EngineBootSummary summary{};
    if (app->boot == nullptr || engine_boot_get_summary(app->boot, &summary) != ENGINE_BOOT_OK)
        return false;
    const uint8_t *b = summary.bsum_raw;
    const auto word = [&](size_t offset) {
        return static_cast<int16_t>(static_cast<uint16_t>(b[offset] | (b[offset + 1u] << 8)));
    };
    app->nav_band_words[0] = word(0x5b0260u - 0x5b0113u);
    app->nav_band_words[1] = word(0x5b0262u - 0x5b0113u);
    app->nav_delay_override = b[0x5b0288u - 0x5b0113u] != 0u;
    app->nav_delay_words[0] = word(0x5b0289u - 0x5b0113u);
    app->nav_delay_words[1] = word(0x5b028bu - 0x5b0113u);
    app->nav_auto_move = game_ini_auto_move(app->game_directory, &app->nav_auto_move_from_ini);
    app->nav_boot_read = true;
    record(app, "nav_provider band_words[0x5b0260,0x5b0262]=%d,%d delay_override[0x5b0288]=%d "
           "delay_words[0x5b0289,0x5b028b]=%d,%d auto_move[0x5bb206]=%d (%s) "
           "source=BOOT-BSUM+Game.ini mode[0x5bb2b6]=1(default,never rewritten) step[0x5bb2c6]=1",
           app->nav_band_words[0], app->nav_band_words[1], app->nav_delay_override ? 1 : 0,
           app->nav_delay_words[0], app->nav_delay_words[1], app->nav_auto_move,
           app->nav_auto_move_from_ini ? "Game.ini" : "default 1, key absent");
    return true;
}

/* Present frame `selector` of the scene movie and stop the background movie
 * from playing past it. The original keeps the frame set of a scene as loaded
 * surfaces and shows [0x5bb50b] (0x43ce92: when 0x5bb509 differs from the
 * selector it points the view at that surface); the movie is never played as a
 * background. The native background player only exists to fetch frame 0, so
 * for a multi-frame scene it is stopped and a second player decodes the
 * requested frame (seek is one-based, BinkGoto-like). Single-frame scenes are
 * untouched (their EOS handling is a separate, tested path). */
static bool nav_show_frame(NativeApp *app, int16_t selector, const char *why)
{
    if (app->scene_native_frames <= 1) return true;
    char error[256] = {};
    if (app->video != nullptr) {
        /* The background player already holds every decoded frame: hand it over (no second
         * decode) and stop advancing it. This happens before any failure below, so a failed
         * frame change never leaves the old movie playing under a different selector. */
        if (app->nav_player != nullptr) bink_player_close(app->nav_player);
        app->nav_player = app->video;
        app->video = nullptr;
        record(app, "nav_background_hold scene=%d reason=%s (frame-hold scene: background movie stopped)",
               app->current_scene_id, why);
    }
    if (selector < 0 || selector >= app->scene_native_frames) {
        ++app->nav_frame_failures;
        record(app, "nav_frame_unavailable selector=%d frames=%d reason=%s failures=%llu (selector outside the "
               "movie: the original would fail the frame load; native keeps the last shown frame, "
               "movie stopped)", selector, app->scene_native_frames, why,
               (unsigned long long)app->nav_frame_failures);
        return false;
    }
    if (app->nav_shown_frame == selector) return true;
    if (app->nav_player == nullptr) {
        BinkPlayerInfo info{};
        if (bink_player_open(app->scene_video_path.c_str(), &app->nav_player, &info, error,
                             sizeof(error)) != BINK_PLAYER_OK) {
            app->nav_player = nullptr;
            ++app->nav_frame_failures;
            record(app, "nav_frame_error stage=open selector=%d reason=%s failures=%llu detail=%s "
                   "(last shown frame kept, movie stopped)", selector, why,
                   (unsigned long long)app->nav_frame_failures, error);
            return false;
        }
    }
    const uint64_t now_ns = monotonic_now_ns();
    BinkPlayerFrame frame{};
    if (bink_player_seek(app->nav_player, static_cast<uint32_t>(selector) + 1u, now_ns, error,
                         sizeof(error)) != BINK_PLAYER_OK ||
        bink_player_advance(app->nav_player, now_ns, &frame, error, sizeof(error)) != BINK_PLAYER_OK ||
        frame.current_frame != selector || !copy_player_frame(app, frame)) {
        ++app->nav_frame_failures;
        record(app, "nav_frame_error stage=seek selector=%d reason=%s failures=%llu detail=%s "
               "(last shown frame kept, movie stopped)", selector, why,
               (unsigned long long)app->nav_frame_failures, error);
        return false;
    }
    app->nav_shown_frame = selector;
    uint64_t fnv = 1469598103934665603ull;   /* FNV-1a over the decoded RGBA, to tell frames apart */
    for (const uint8_t byte : app->scene_frame.rgba) fnv = (fnv ^ byte) * 1099511628211ull;
    record(app, "nav_frame_shown selector=%d frames=%d reason=%s rgba_fnv1a=%016llx", selector,
           app->scene_native_frames, why, (unsigned long long)fnv);
    return true;
}

/* Rebuild the navigation globals the scene setup 0x4381f4 derives. Called at
 * every scene entry (initial scene and each transition) after the entry
 * selector/scroll words are known. Unbound producers are named in the log. */
static void nav_begin_scene(NativeApp *app)
{
    app->nav_scene_ready = false;
    if (!nav_read_boot(app)) {
        /* No navigation globals: the zone tests cannot run and the member check was not made,
         * so do not keep a previous scene's "idle" verdict (priority_clear would be assumed). */
        app->nav_members_idle = false;
        record(app, "nav_scene_error detail=boot-summary-unavailable cascade_members_idle=0");
        return;
    }
    const int32_t frames = app->scene_native_frames;
    NavGlobals g{};
    g.gate_deadline = app->nav.gate_deadline;      /* 0x63a5c8 is process-wide */
    g.selector = app->selector_entry_valid ? static_cast<int16_t>(app->selector_entry_frame)
                                           : static_cast<int16_t>(0);
    g.frame_min = 0;                               /* 0x416873 */
    g.frame_max = static_cast<int16_t>(frames - 1);/* 0x416897: count - 1 */
    g.step = 1;                                    /* 0x439e0f */
    g.mode = 1;                                    /* 0x439ddf */
    g.arrow_width = frames == 1 ? 0 : 15;          /* 0x439e21, zeroed by 0x439f05 when one frame */
    g.hover_delay = 400;                           /* 0x439e33 */
    g.key_delay = 66;                              /* 0x439e3c */
    if (app->nav_delay_override) {                 /* 0x43a6d1..0x43a6ef */
        g.hover_delay = app->nav_delay_words[0];
        g.key_delay = app->nav_delay_words[1];
    }
    g.scroll_step = 10;                            /* 0x439e18 -> 0x5c39fd at 0x43a3e7 */
    g.scroll = static_cast<int32_t>(static_cast<int16_t>(app->selector_entry_scroll)); /* 0x43a3a0 */
    const StartupMenuRect image_view = {app->view_words[8], app->view_words[9],
                                        app->view_words[10], app->view_words[11]};
    g.scroll_end = g.scroll + (image_view.bottom - image_view.top);   /* 0x43a3ad..0x43a3c0 */
    g.image_bottom = app->scene_native_height - 1; /* 0x4168c4: movie height - 1 */
    const bool view_is_whole_image =
        image_view.left == 0 && image_view.top == 0 &&
        image_view.right == app->scene_native_width - 1 &&
        image_view.bottom == app->scene_native_height - 1;
    g.arrow_height = view_is_whole_image ? 0 : 15; /* 0x439e2a, zeroed by 0x43a4f3 */
    g.nav_allowed = 1;                             /* 0x438d0c (types 0x1e/0x1f unbound) */
    g.auto_move = app->nav_auto_move;
    g.frames_cached = 0;                           /* 0x439efb */
    g.cursor_mode = app->captions.lifecycle.g.overlay_ui;
    g.state = 0;
    app->nav = g;
    const StartupMenuRect &view = app->scene_destination;
    app->nav_bands.x1 = view.left + app->nav_band_words[0] - 1;    /* 0x4371da */
    app->nav_bands.y1 = view.top + app->nav_band_words[1] - 1;     /* 0x4371ac */
    app->nav_bands.x2 = view.right - app->nav_band_words[0] + 1;   /* 0x4371ef */
    app->nav_bands.y2 = view.bottom - app->nav_band_words[1] + 1;  /* 0x4371c0 */
    app->logged_nav_state = -1;
    /* Cascade members before the zone tests: any row of their runtime types may
     * enable a UI hit test that native does not model. */
    std::vector<uint8_t> types;
    for (size_t row = 0; row < scene_resource_action_count(app->scene); ++row) {
        SceneActionInfo info{};
        if (scene_resource_action_at(app->scene, row, &info) == SCENE_RESOURCE_OK)
            types.push_back(info.type);
    }
    app->nav_members_idle = session_navigation_members_idle(types.data(), types.size()) != 0;
#ifdef BLACKMOOR_NATIVE_APP_TEST_HOOKS
    if (app->test_members_busy) {
        app->nav_members_idle = false;
        record(app, "test_members_busy applied (test hook: scene treated as having a cascade-member row)");
    }
#endif
    app->nav_scene_ready = true;
    (void)nav_show_frame(app, g.selector, "scene-entry");
    record(app, "nav_scene_begin scene=%d selector=%d%s range=%d..%d mode=%d step=%d arrows=%d,%d "
           "delays=%d,%d scroll=%d/%d image_bottom=%d bands=%d,%d,%d,%d auto_move=%d "
           "cascade_members_idle=%d keyboard_producer=unbound",
           app->current_scene_id, g.selector, app->selector_entry_valid ? "" : "(unbound: initial scene)",
           g.frame_min, g.frame_max, g.mode, g.step, g.arrow_width, g.arrow_height, g.hover_delay,
           g.key_delay, g.scroll, g.scroll_end, g.image_bottom, app->nav_bands.x1, app->nav_bands.y1,
           app->nav_bands.x2, app->nav_bands.y2, g.auto_move, app->nav_members_idle ? 1 : 0);
}

static bool begin_native_session_bindings_scene(NativeApp *app)
{
    size_t failed_row = SIZE_MAX;
    int kernel_status = 0;
    const int a51_status = session_a51_begin_scene(app->a51, app->scene, &failed_row,
                                                   &kernel_status);
    if (a51_status != SESSION_A51_OK) {
        record(app, "scene_session_create_error provider=caption detail=0x51-loader "
               "status=%d row=%zu kernel_status=%d", a51_status, failed_row, kernel_status);
        return false;
    }
    if (session_a62_begin_scene(app->a62, scene_resource_action_count(app->scene)) != SESSION_A62_OK) {
        record(app, "scene_session_create_error provider=action-family-62 detail=row-table");
        return false;
    }
    if (session_a35_begin_scene(app->a35, app->scene) != A35_RUNTIME_OK) return false;
    if (session_a83_begin_scene(app->a83, app->scene) != A83_OK) {
        record(app, "scene_session_create_error provider=action-family-83 detail=%s",
               session_a83_failure(app->a83));
        return false;
    }
    if (session_a97_begin_scene(app->a97, app->scene) != ACTION_SOUND_OK) {
        record(app, "scene_session_create_error provider=action-sound detail=%s",
               session_a97_failure(app->a97));
        return false;
    }
    if (session_aa1_begin_scene(app->aa1, app->scene) != ACTION_SOUND_OK) {
        record(app, "scene_session_create_error provider=action-sound detail=%s",
               session_aa1_failure(app->aa1));
        return false;
    }
    if (session_a79_begin_scene(app->a79, app->scene) != ACTION79_OK) {
        record(app, "scene_session_create_error provider=action-kernel detail=%s",
               session_a79_failure(app->a79));
        return false;
    }
    if (session_a78_begin_scene(app->a78, app->scene) != ACTION78_OK) {
        record(app, "scene_session_create_error provider=action-kernel detail=%s",
               session_a78_failure(app->a78));
        return false;
    }
    for (size_t row = 0; row < scene_resource_action_count(app->scene); ++row) {
        SceneActionInfo info{};
        Action78Object a78_object{};
        if (scene_resource_action_at(app->scene, row, &info) == SCENE_RESOURCE_OK &&
            info.type == SESSION_A78_TYPE && session_a78_object(app->a78, row, &a78_object) == 1)
            record(app, "scene_a78_construct row=%zu item=%d take=%u swap=%u (add-inventory-item, 0x4eaadc)",
                   row, (int)static_cast<int16_t>(a78_object.item_word), (unsigned)a78_object.take_flag,
                   (unsigned)a78_object.swap_flag);
        if (scene_resource_action_at(app->scene, row, &info) == SCENE_RESOURCE_OK &&
            info.type == SESSION_A79_TYPE)
            record(app, "scene_a79_construct row=%zu item=%d (remove-inventory-item, 0x4eac4c)",
                   row, session_a79_item_word(app->a79, row));
        if (scene_resource_action_at(app->scene, row, &info) == SCENE_RESOURCE_OK &&
            info.type == SESSION_A97_TYPE)
            record(app, "scene_a97_construct row=%zu selected=%d runtime=0x9f seed-parity=unproven",
                   row, session_a97_selected(app->a97, row));
        if (scene_resource_action_at(app->scene, row, &info) == SCENE_RESOURCE_OK &&
            info.type == SESSION_AA1_TYPE) {
            SessionAa1Row aa1_row{};
            if (session_aa1_row(app->aa1, row, &aa1_row) == 1)
                record(app, "scene_aa1_construct row=%zu stem=%s channel=%u control-mode=%u "
                       "scene=%d event=%d value=%u key_missing=%u runtime=0xa1 (loader 0x40f069)",
                       row, aa1_row.stem, (unsigned)aa1_row.channel, (unsigned)aa1_row.mode,
                       (int)aa1_row.transition_scene, (int)aa1_row.event_id,
                       (unsigned)aa1_row.event_value, (unsigned)aa1_row.key_missing);
            else
                record(app, "scene_aa1_construct row=%zu deferred=loader-AUTOTEXT-provider-unavailable",
                       row);
        }
    }
    if (session_a36_begin_scene(app->a36, app->scene) != OVERLAY36_OK) {
        record(app, "scene_session_create_error provider=action-kernel detail=%s",
               session_a36_failure(app->a36));
        return false;
    }
    app->a17_logged_valid = false;
    if (session_a17_begin_scene(app->a17, app->scene) != ACTION17_OK) {
        record(app, "scene_session_create_error provider=action-kernel detail=%s",
               session_a17_failure(app->a17));
        return false;
    }
    for (size_t row = 0; row < scene_resource_action_count(app->scene); ++row) {
        SceneActionInfo info{};
        Action17Cursor cursor{};
        if (scene_resource_action_at(app->scene, row, &info) != SCENE_RESOURCE_OK ||
            (info.type != SESSION_A17_TYPE && info.type != SESSION_A16_TYPE) ||
            info.typed_body == nullptr || info.typed_body_length < ACTION17_PREFIX_BYTES) continue;
        const auto word = [&](size_t offset) {
            return static_cast<int>(static_cast<int16_t>(info.typed_body[offset] |
                                                        (info.typed_body[offset + 1u] << 8)));
        };
        (void)session_a17_hover_cursor(app->a17, row, -1, &cursor);
        record(app, "scene_a17_construct row=%zu type=0x%02x target=%d frame_records=%d "
               "hover_cursor_index=%d (multiframe scene hotspot, handler 0x42b07e)",
               row, static_cast<unsigned>(info.type), word(0), word(20), cursor.cursor_index);
    }
    app->a0b_logged_valid = false;
    if (session_a0b_begin_scene(app->a0b, app->scene) != ACTION17_OK) {
        record(app, "scene_session_create_error provider=action-kernel detail=%s",
               session_a0b_failure(app->a0b));
        return false;
    }
    for (size_t row = 0; row < scene_resource_action_count(app->scene); ++row) {
        Action0bPayload payload{};
        Action17Cursor cursor{};
        if (session_a0b_payload(app->a0b, row, &payload) != ACTION17_OK) continue;
        (void)session_a0b_hover_cursor(app->a0b, row, -1, &cursor);
        record(app, "scene_a0b_construct row=%zu target=%d entry_frame=%d word8=%d rect=%d,%d,%d,%d "
               "hover_cursor_index=%d (scene-change hotspot, loader 0x40b7d4, handler 0x42ae73)",
               row, payload.target, payload.word_04, payload.word_08, payload.rect[0],
               payload.rect[1], payload.rect[2], payload.rect[3], cursor.cursor_index);
    }
    app->a0c_logged_valid.assign(scene_resource_action_count(app->scene), 0u);
    app->a0c_logged_rects.assign(scene_resource_action_count(app->scene) * 4u, 0);
    if (session_a0c_begin_scene(app->a0c, app->scene) != ACTION17_OK) {
        record(app, "scene_session_create_error provider=action-kernel detail=%s",
               session_a0c_failure(app->a0c));
        return false;
    }
    for (size_t row = 0; row < scene_resource_action_count(app->scene); ++row) {
        SessionA0cRowInfo info{};
        Action17Cursor cursor{};
        if (session_a0c_row_info(app->a0c, row, &info) != ACTION17_OK) continue;
        (void)session_a0c_hover_cursor(app->a0c, row, -1, &cursor);
        record(app, "scene_a0c_construct row=%zu target=%d entry_frame=%d word6=%d frame_records=%d "
               "hover_cursor_index=%d (multi-frame scene-change hotspot, loader 0x40bafd, handler 0x42b2e4)",
               row, info.target, info.entry_word, info.word_06, info.count, cursor.cursor_index);
    }
    app->a36_blit_signature.fill(0u);
    app->a36_hot_rects_failure_logged = false;
    for (size_t row = 0; row < scene_resource_action_count(app->scene); ++row) {
        const char *name = session_a36_row_name(app->a36, row);
        const uint8_t *image = session_a36_image(app->a36, row);
        if (name == nullptr || image == nullptr) continue;
        const auto word = [&](size_t offset) {
            return static_cast<int>(static_cast<int16_t>(image[offset] | (image[offset + 1u] << 8)));
        };
        if (session_a36_row_raw_type(app->a36, row) == SESSION_A37_TYPE) {
            /* RT-18: raw 0x37 (loader 0x40c446, constructor 0x4895cc, runtime type 0x36). The
             * record has hot word 2, so the pointer cascade never hits it (0x4897cd wants 1). */
            const auto dword = [&](size_t offset) {
                return static_cast<int32_t>(static_cast<uint32_t>(image[offset]) |
                                            (static_cast<uint32_t>(image[offset + 1u]) << 8) |
                                            (static_cast<uint32_t>(image[offset + 2u]) << 16) |
                                            (static_cast<uint32_t>(image[offset + 3u]) << 24));
            };
            record(app, "scene_a37_construct row=%zu name=%s layer=%d plain_blit=%d "
                   "rect=%d,%d,%d,%d geometry=%d,%d,%d,%d hot=%d never_completes=%d "
                   "(raw 0x37 static overlay, ctor 0x4895cc, runtime type 0x36)",
                   row, name, word(OV36_LAYER), word(OV36_PLAIN_23),
                   dword(OV36_SECONDARY + OV36_SEC_DST_LEFT), dword(OV36_SECONDARY + OV36_SEC_DST_TOP),
                   dword(OV36_SECONDARY + OV36_SEC_DST_RIGHT),
                   dword(OV36_SECONDARY + OV36_SEC_DST_BOTTOM), dword(OV36_PRIMARY),
                   dword(OV36_PRIMARY + 4u), dword(OV36_PRIMARY + 8u), dword(OV36_PRIMARY + 12u),
                   word(OV36_SECONDARY + OV36_SEC_HOT), word(OV36_EVENT_INDEX) == -1 ? 1 : 0);
            continue;
        }
        record(app, "scene_a36_construct row=%zu name=%s layer=%d marker=%d plain_blit=%d "
               "event=%d/%d scene_change_option=%d primaries=%d secondaries=%d (static overlay, 0x4899ca)",
               row, name, word(OV36_LAYER), word(OV36_MARKER), word(OV36_PLAIN_23),
               word(OV36_EVENT_INDEX), word(OV36_EVENT_VALUE), word(OV36_ACTION_25),
               word(OV36_PRIMARY_COUNT), word(OV36_SECONDARY_COUNT));
    }
    /* ClearSceneData 0x43dbe3 resets 0x5c39f9 before the new ACT table runs. */
    app->movie_world.active = 0;
    nav_begin_scene(app);
    return true;
}

/* ---- RT-6: pointer boundary callbacks (SceneSessionPointerHost) ----------
 * Thin wrappers over session_input; every decision (latch, consume, mode /
 * modal / range guards, 4f0059 transform and first-hit scan) is the module's.
 * The geometry comes from ProvisionalCursorProvider and the process mirrors
 * the caption lifecycle already keeps for 0x583204 / 0x5c39e9 / 0x5839a9. */
static void native_pointer_context(NativeApp *app, SessionInputContext *out)
{
    std::memset(out, 0, sizeof(*out));
    const ProvisionalCursorProvider &cursor = app->cursor_provider;
    out->viewport.left = app->scene_destination.left;
    out->viewport.top = app->scene_destination.top;
    out->viewport.right = app->scene_destination.right;
    out->viewport.bottom = app->scene_destination.bottom;
    out->cursor.left = app->pointer_x;
    out->cursor.top = app->pointer_y;
    out->cursor.right = app->pointer_x + cursor.sprite_width - 1;
    out->cursor.bottom = app->pointer_y + cursor.sprite_height - 1;
    out->hot_x = cursor.hot_x;
    out->hot_y = cursor.hot_y;
    /* 0x5bb587 is the navigation scroll (RT-17); the display does not scroll yet
     * (no tutorial scene has a view smaller than its image: arrow_height 0). */
    out->scroll_y = app->nav_scene_ready ? app->nav.scroll : cursor.scroll_y;
    const CaptionLifecycleGlobals &g = app->captions.lifecycle.g;
    out->cursor_mode = g.overlay_ui;            /* 0x583204 */
    out->modal_event = (uint32_t)g.cursor_override; /* 0x5c39e9 */
    out->producer_disabled = (uint32_t)g.modal_input; /* 0x5839a9 */
    /* No pointer has moved yet: there is no composed sprite to project. */
    out->geometry_ready = (app->pointer_x >= 0 && app->pointer_y >= 0) ? 1u : 0u;
    /* RT-17: the cascade members before the overlay hit test and the zone tests
     * (44 call sites, RT-17.cascade-members.json) are each enabled only by the
     * handler of one runtime row type; no row of those types exists in the
     * scene (nav_begin_scene), so every member sees its power-on object. The
     * edge state 0x5a4c18 is no longer an input: the zone tests produce it. */
    out->priority_clear = (cursor.guard_5b5158 == 0 && cursor.guard_5b61af == 0 &&
                           cursor.guard_5b615e == 0 && app->nav_members_idle) ? 1u : 0u;
    out->excluded_0 = -1; /* 0x5b4e89 / 0x5b5100: set only by types 0x33/0x34 */
    out->excluded_1 = -1;
}

static int native_pointer_consume(void *context, SceneExecutorFrameInput *frame,
                                  int32_t *candidate)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    SessionInputContext input{};
    native_pointer_context(app, &input);
    const uint8_t edge_before = app->input_state.latch[0];
    const int status = session_input_tick(&app->input_state, &input, frame);
    *candidate = app->input_state.candidate;
    /* RT-17: 0x43b199 found no primary edge, the secondary consumer 0x4daf6e is
     * absent (no right button), so the tick reaches the navigation block
     * 0x43c133..0x43c941 before the ACT dispatcher (0x43cf2f). A tick that
     * consumed a click skips it (0x43b19e falls into the click handling). */
    if (edge_before == 0u && app->nav_scene_ready) {
        NavKeys keys{};   /* keyboard producer (0x437774) unbound: no key flag is ever set */
        NavStepResult step{};
        app->nav.cursor_mode = input.cursor_mode;
        if (session_navigation_step(&app->nav, &keys, app->session_tick_sample,
                                    app->session_tick_sample, &step) == SESSION_NAVIGATION_OK &&
            step.entered != 0u) {
            ++app->nav_steps;
            if (step.selector_changed != 0u) {
                ++app->nav_selector_moves;
                app->selector_entry_frame = app->nav.selector;
            }
            record(app, "nav_step state=%d selector=%d->%d scroll=%d scroll_end=%d deadline=%u dirty=%u "
                   "tick=%u step=%llu (tick block 0x43c251..0x43c941)", app->nav.state,
                   step.selector_before, app->nav.selector, app->nav.scroll, app->nav.scroll_end,
                   app->nav.gate_deadline, step.view_dirty, app->session_tick_sample,
                   (unsigned long long)app->nav_steps);
            /* 0x43ce92..0x43cf2f: the view is pointed at the new selector's frame and
             * [0x5c3a51] := selector BEFORE the dispatcher call in the same tick. The frame
             * input was filled by the prepare callback with the old frame, so refresh it
             * here, and reseed the caption backbuffer from the new frame (the media step
             * of this tick already ran with the old one). */
            if (step.selector_changed != 0u) {
                if (nav_show_frame(app, app->nav.selector, "navigation")) {
                    frame->current_frame = app->scene_current_frame;
                    const bool reseeded = seed_native_caption_backbuffer(app);
                    record(app, "nav_frame_input current_frame=%d caption_backbuffer_reseed=%s "
                           "(dispatcher of this tick sees the new frame)", frame->current_frame,
                           reseeded ? "ok" : "failed");
                } else {
                    record(app, "nav_frame_kept selector=%d shown=%d (frame change refused or failed; "
                           "the executor keeps the previous frame)", app->nav.selector,
                           app->nav_shown_frame);
                }
            }
        }
    }
    if (edge_before != 0u || status != SESSION_INPUT_OK) {
        record(app, "pointer_consume status=%d edge=%u candidate=%d activation=%u "
               "modal=%u mode=%d provisional-geometry=1 projected=%d,%d valid=%u",
               status, (unsigned)edge_before, *candidate,
               (unsigned)frame->hotspot_activation_event, input.modal_event,
               input.cursor_mode, frame->pointer_x, frame->pointer_y,
               (unsigned)frame->pointer_valid);
    }
    return status;
}

static int native_pointer_scan(void *context, const SessionInputHotspot *rows,
                               size_t count, int32_t *candidate)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    SessionInputContext input{};
    native_pointer_context(app, &input);
    /* 0x4d3073 resets the global candidate before the 0x4f0059 scan. */
    (void)session_input_publish_candidate(&app->input_state, -1);
    /* RT-14: the overlay hit test (0x4897cd) runs inside the 0x4f0059 cascade
     * before its generic row loop, in overlay-list order. */
    std::vector<SessionInputHotspot> overlay_rows(OVERLAY36_LIST_LIMIT * 25u);
    size_t overlay_count = 0u;
    if (app->a36 != nullptr && session_a36_registered(app->a36) != 0u &&
        session_a36_priority_rows(app->a36, overlay_rows.data(), overlay_rows.size(),
                                  &overlay_count) != OVERLAY36_OK) {
        if (!app->a36_hot_rects_failure_logged) {
            app->a36_hot_rects_failure_logged = true;
            record(app, "scene_a36_hot_rects_unavailable detail=%s (overlay hit test skipped "
                   "on every tick that fails; logged once per scene)",
                   session_a36_failure(app->a36));
        }
        overlay_count = 0u;
    }
    /* RT-17: the whole cascade as one pipeline in the original's order (overlap
     * guard, held-item prelude, UI members via priority_clear, overlay hit test,
     * edge/arrow zone tests, generic row loop). A zone hit returns before the
     * generic loop (0x4f1e78) and leaves the candidate at -1. */
    const int16_t *held_item = app->new_game.view.inventory.selected_item_candidate;
    NavPointer nav_pointer{};
    nav_pointer.hot_x = input.cursor.left + input.hot_x;   /* 0x58316e (provisional hot point) */
    nav_pointer.hot_y = input.cursor.top + input.hot_y;    /* 0x58316a */
    nav_pointer.selected_item = held_item != nullptr ? *held_item : -1;
    NavScanResult nav_scan{};
    app->nav.cursor_mode = input.cursor_mode;
    int status = SESSION_INPUT_INVALID_ARGUMENT;
    if (app->nav_scene_ready) {
        status = session_navigation_scan(&app->input_state, &input, &app->nav, &app->nav_bands,
                                         &nav_pointer, &app->nav_cursor, overlay_rows.data(),
                                         overlay_count, rows, count, &nav_scan);
    } else {
        /* No navigation globals yet (no scene entered): the plain scan. */
        status = session_input_scan_priority(&app->input_state, &input, overlay_rows.data(),
                                             overlay_count, rows, count);
    }
    *candidate = app->input_state.candidate;
    if (status == SESSION_INPUT_OK && app->nav_scene_ready) {
        if (nav_scan.state != app->logged_nav_state) {
            if (nav_scan.state != 0 || app->logged_nav_state > 0)
                record(app, "nav_zone state=%d claimed=%d hot=%d,%d cursor_index=%d variant=%d "
                       "table_offset=0x%x surface_default=%d candidate=%d arrows=%d,%d selector=%d "
                       "(zone test 0x4f18fa; cascade %s; cursor sprite not drawn by the app)",
                       nav_scan.state, nav_scan.claimed_by_zone, nav_pointer.hot_x, nav_pointer.hot_y,
                       app->nav_cursor.index, app->nav_cursor.variant,
                       static_cast<unsigned>(nav_scan.zone.table_offset),
                       nav_scan.zone.surface_default, *candidate, app->nav.arrow_width,
                       app->nav.arrow_height, app->nav.selector,
                       nav_scan.claimed_by_zone ? "returned at 0x4f1e78 before the generic loop"
                                                : "fell through");
            app->logged_nav_state = nav_scan.state;
        }
    }
    if (status != SESSION_INPUT_OK) {
        record(app, "pointer_scan_limit status=%d rows=%zu (candidate cleared)", status, count);
    } else if (*candidate != app->logged_candidate) {
        record(app, "pointer_candidate candidate=%d rows=%zu cursor=%d,%d "
               "provisional-geometry=1", *candidate, count, app->pointer_x, app->pointer_y);
        if (overlay_count != 0u)
            record(app, "scene_a36_hot_rows candidate=%d overlay_hot_rects=%zu", *candidate,
                   overlay_count);
        if (*candidate >= 0 && app->a17 != nullptr) {
            /* RT-15: the cascade's hover cursor for a hit on a 0x16/0x17 row (0x4f1ff3 /
             * 0x4f22ef). The app draws no game cursor yet; the selection is reported. */
            Action17Cursor cursor{};
            const int16_t *held = app->new_game.view.inventory.selected_item_candidate;
            if (session_a17_hover_cursor(app->a17, static_cast<size_t>(*candidate),
                                         held != nullptr ? *held : static_cast<int16_t>(-1),
                                         &cursor) == ACTION17_OK)
                record(app, "scene_a17_hover_cursor row=%d index=%d variant=%d table_offset=0x%x "
                       "held_flag=%d surface=%d (cursor sprite not drawn by the app)",
                       *candidate, cursor.cursor_index, cursor.variant,
                       static_cast<unsigned>(cursor.table_offset), cursor.held_flag, cursor.surface);
            else if (session_a0b_hover_cursor(app->a0b, static_cast<size_t>(*candidate),
                                              held != nullptr ? *held : static_cast<int16_t>(-1),
                                              &cursor) == ACTION17_OK)
                record(app, "scene_a0b_hover_cursor row=%d index=%d variant=%d table_offset=0x%x "
                       "held_flag=%d surface=%d (0x4f221e; cursor sprite not drawn by the app)",
                       *candidate, cursor.cursor_index, cursor.variant,
                       static_cast<unsigned>(cursor.table_offset), cursor.held_flag, cursor.surface);
            else if (session_a0c_hover_cursor(app->a0c, static_cast<size_t>(*candidate),
                                              held != nullptr ? *held : static_cast<int16_t>(-1),
                                              &cursor) == ACTION17_OK)
                record(app, "scene_a0c_hover_cursor row=%d index=%d variant=%d table_offset=0x%x "
                       "held_flag=%d surface=%d (0x4f2033; cursor sprite not drawn by the app)",
                       *candidate, cursor.cursor_index, cursor.variant,
                       static_cast<unsigned>(cursor.table_offset), cursor.held_flag, cursor.surface);
        }
        if (*candidate >= 0) {
            for (size_t i = 0; i < overlay_count; ++i)
                if (overlay_rows[i].index == *candidate) {
                    record(app, "scene_a36_hot_hit row=%d rect=%d,%d,%d,%d (0x4897cd before the generic scan)",
                           *candidate, overlay_rows[i].rectangle.left, overlay_rows[i].rectangle.top,
                           overlay_rows[i].rectangle.right, overlay_rows[i].rectangle.bottom);
                    break;
                }
        }
    }
    app->logged_candidate = *candidate;
    return status;
}

static int native_pointer_reset(void *context)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    const int status = session_input_init(&app->input_state);
    app->logged_candidate = -2;
    /* The loaders also store [0x5c39e9] = 0 (the caption lifecycle's mirror). */
    app->captions.lifecycle.g.cursor_override = 0;
    record(app, "pointer_input_reset status=%d candidate=%d (latch constructor 0x4dad60)",
           status, app->input_state.candidate);
    return status;
}

/* Rows 4f0059 hit-tests that the executor does not export: the 0x62 request /
 * response table (slot +0x43 request, +0x47..+0x4d signed rectangle words). */
static int native_pointer_external_row(void *context, size_t action_index,
                                       SessionInputHotspot *row)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    ActionFamily62InteractionTarget target{};
    /* RT-15: a 0x16/0x17 row whose frame record matched the selector (0x4f1f16
     * reads the same request dword and rectangle words). */
    if (session_a17_pointer_row(app->a17, action_index, row) == 1) return 1;
    /* RT-16: a raw 0x0b row whose frame word matched the selector (same cells). */
    if (session_a0b_pointer_row(app->a0b, action_index, row) == 1) return 1;
    /* RT-20: a raw 0x0c row whose frame record matched the selector (same cells). */
    if (session_a0c_pointer_row(app->a0c, action_index, row) == 1) return 1;
    if (app->a62 == nullptr ||
        session_a62_get_target(app->a62, action_index, &target) != SESSION_A62_OK ||
        target.request_pending == 0u) return 0;
    row->index = (int32_t)action_index;
    row->rectangle.left = target.response_words[0];
    row->rectangle.top = target.response_words[1];
    row->rectangle.right = target.response_words[2];
    row->rectangle.bottom = target.response_words[3];
    row->active = 1u;
    return 1;
}

static bool bind_native_pointer(NativeApp *app)
{
    SceneSessionPointerHost host{};
    host.context = app;
    host.consume = native_pointer_consume;
    host.scan = native_pointer_scan;
    host.reset = native_pointer_reset;
    host.external_row = native_pointer_external_row;
    if (scene_session_bind_pointer(app->session, &host) != SCENE_SESSION_OK) return false;
    const ProvisionalCursorProvider &c = app->cursor_provider;
    const bool clear = c.guard_5b5158 == 0 && c.guard_5b61af == 0 && c.guard_5b615e == 0 &&
                       app->nav_members_idle;
    record(app, "pointer_provider provisional sprite=%dx%d hot=%d,%d scroll=%d "
           "guards[5b5158,5b61af,5b615e]=%u,%u,%u cascade_members_idle=%d priority_clear=%d "
           "excluded=-1,-1 reason=cursor-sprite-size/hot-point/scroll-unrecovered "
           "edge_state[5a4c18]=produced-by-zone-tests(RT-17)",
           c.sprite_width, c.sprite_height, c.hot_x, c.hot_y, c.scroll_y,
           c.guard_5b5158, c.guard_5b61af, c.guard_5b615e, app->nav_members_idle ? 1 : 0,
           clear ? 1 : 0);
    return true;
}

static bool create_native_scene_session(NativeApp *app)
{
    if (app == nullptr || app->scene == nullptr || app->session != nullptr) return false;
    size_t phone_count = 0;
    if (engine_boot_get_phone_count(app->boot, &phone_count) != ENGINE_BOOT_OK ||
        phone_count > SIZE_MAX / sizeof(std::array<uint8_t, ACTION_UI_PHONE_RECORD_SIZE>)) {
        record(app, "scene_session_create_error provider=action-ui detail=BOOT UICL unavailable");
        return false;
    }
    std::vector<std::array<uint8_t, ACTION_UI_PHONE_RECORD_SIZE>> phone_rows;
    try { phone_rows.resize(phone_count); }
    catch (...) {
        record(app, "scene_session_create_error provider=host detail=phone rows allocation");
        return false;
    }
    for (size_t row = 0; row < phone_count; ++row) {
        if (engine_boot_phone_row_at(app->boot, row, phone_rows[row].data()) != ENGINE_BOOT_OK) {
            record(app, "scene_session_create_error provider=action-ui row=%zu", row);
            return false;
        }
    }
    app->session_conditions = {};
    app->session_conditions.event_flags = app->new_game.action_core.event_flags;
    app->session_conditions.event_flag_count = app->new_game.action_core.event_flag_count;
    app->session_conditions.inventory_presence =
        app->new_game.view.inventory.presence_583bd5.values;
    app->session_conditions.inventory_count =
        app->new_game.view.inventory.presence_583bd5.count;
    app->session_conditions.selected_inventory_item =
        app->new_game.view.inventory.selected_item_candidate
            ? *app->new_game.view.inventory.selected_item_candidate : -1;
    app->session_conditions.scene_visit_counts = reinterpret_cast<const int16_t *>(
        app->new_game.view.scene_visit_counts_587b2d.values);
    app->session_conditions.scene_visit_count =
        app->new_game.view.scene_visit_counts_587b2d.count;
    app->session_conditions.time_of_day_minutes = app->new_game.view.clock.total_minutes;
    app->action64_backend.context = app;
    app->action64_backend.get_tick_count = session_get_tick_count;

    SceneSessionConfig config{};
    config.scene = app->scene;
    config.scene_id = app->current_scene_id;
    config.action_core_world = &app->new_game.action_core;
    config.conditions = &app->session_conditions;
    config.action64_world = &app->new_game.action64_world;
    config.action64_backend = &app->action64_backend;
    config.initial_phone_rows = phone_rows.empty() ? nullptr :
        reinterpret_cast<const uint8_t (*)[ACTION_UI_PHONE_RECORD_SIZE]>(phone_rows.data());
    config.initial_phone_count = phone_rows.size();
    config.prepare_tick = prepare_native_session_tick;
    config.advance_media_one = advance_native_session_media_one;
    config.provider_context = app;
    config.action64_world_commit_observer = mirror_action64_clock_commit;
    config.action64_world_commit_context = app;
    SceneSessionActionBinding action_sound_binding{};
    action_sound_binding.type = ACTION_SOUND_TYPE;
    action_sound_binding.provider = SCENE_SESSION_PROVIDER_ACTION_SOUND;
    action_sound_binding.callback = native_action_sound_handler;
    action_sound_binding.context = app;
    if (!create_native_session_bindings(app)) return false;
    SceneSessionActionBinding bindings[16]{};
    bindings[0] = action_sound_binding;
    bindings[1].type = SESSION_A62_TYPE;
    bindings[1].provider = SCENE_SESSION_PROVIDER_A62;
    bindings[1].callback = session_a62_handler;
    bindings[1].context = app->a62;
    bindings[2].type = SESSION_A51_TYPE;
    bindings[2].provider = SCENE_SESSION_PROVIDER_CAPTION;
    bindings[2].callback = session_a51_handler;
    bindings[2].context = app->a51;
    bindings[3].type = SESSION_A28_TYPE;
    bindings[3].provider = SCENE_SESSION_PROVIDER_A28;
    bindings[3].callback = session_a28_handler;
    bindings[3].context = app->a28;
    bindings[4].type = SESSION_A35_TYPE;
    bindings[4].provider = SCENE_SESSION_PROVIDER_A35;
    bindings[4].callback = native_a35_handler;
    bindings[4].context = app;
    bindings[5].type = SESSION_A97_TYPE;
    bindings[5].provider = SCENE_SESSION_PROVIDER_ACTION_SOUND;
    bindings[5].callback = session_a97_handler;
    bindings[5].context = app->a97;
    config.action_bindings = bindings;
    bindings[6].type = SESSION_A79_TYPE;
    bindings[6].provider = SCENE_SESSION_PROVIDER_ACTION_KERNEL;
    bindings[6].callback = session_a79_handler;
    bindings[6].context = app->a79;
    bindings[7].type = SESSION_A36_TYPE;
    bindings[7].provider = SCENE_SESSION_PROVIDER_ACTION_KERNEL;
    bindings[7].callback = session_a36_handler;
    bindings[7].context = app->a36;
    bindings[8].type = SESSION_A17_TYPE;
    bindings[8].provider = SCENE_SESSION_PROVIDER_ACTION_KERNEL;
    bindings[8].callback = session_a17_handler;
    bindings[8].context = app->a17;
    bindings[9].type = SESSION_A16_TYPE;
    bindings[9].provider = SCENE_SESSION_PROVIDER_ACTION_KERNEL;
    bindings[9].callback = session_a17_handler;
    bindings[9].context = app->a17;
    bindings[10].type = SESSION_A0B_TYPE;
    bindings[10].provider = SCENE_SESSION_PROVIDER_ACTION_KERNEL;
    bindings[10].callback = session_a0b_handler;
    bindings[10].context = app->a0b;
    bindings[11].type = SESSION_A83_TYPE;
    bindings[11].provider = SCENE_SESSION_PROVIDER_A83;
    bindings[11].callback = native_a83_handler;
    bindings[11].context = app;
    bindings[12].type = SESSION_A0C_TYPE;
    bindings[12].provider = SCENE_SESSION_PROVIDER_ACTION_KERNEL;
    bindings[12].callback = session_a0c_handler;
    bindings[12].context = app->a0c;
    /* RT-18: raw 0x37 rows run through the same COverlay handler (runtime type 0x36). */
    bindings[13].type = SESSION_A37_TYPE;
    bindings[13].provider = SCENE_SESSION_PROVIDER_ACTION_KERNEL;
    bindings[13].callback = session_a36_handler;
    bindings[13].context = app->a36;
    /* RT-19: raw 0x78 add inventory item (dispatcher arm 0x42944b, gate mode 0). */
    bindings[14].type = SESSION_A78_TYPE;
    bindings[14].provider = SCENE_SESSION_PROVIDER_ACTION_KERNEL;
    bindings[14].callback = session_a78_handler;
    bindings[14].context = app->a78;
    /* RT-21: raw 0xa1 Sound (dispatcher arm 0x4297be shared with 0x9f; provider as raw 0x97). */
    bindings[15].type = SESSION_AA1_TYPE;
    bindings[15].provider = SCENE_SESSION_PROVIDER_ACTION_SOUND;
    bindings[15].callback = native_aa1_handler;
    bindings[15].context = app;
    config.action_binding_count = 16u;
    SceneSessionFailure failure{};
    const int status = scene_session_create(&config, &app->session, &failure);
    if (status != SCENE_SESSION_OK) {
        record(app, "scene_session_create_error status=%d provider=%s stage=%d action=%zu type=0x%02x detail=%d",
               status, scene_session_provider_string(failure.provider), failure.stage,
               failure.action_index, failure.action_type, failure.detail_status);
        return false;
    }
    if (scene_session_set_pre_gate(app->session, SESSION_A62_TYPE, session_a62_pre_gate,
                                   app->a62) != SCENE_SESSION_OK ||
        scene_session_set_pre_gate(app->session, SESSION_A17_TYPE, session_a17_pre_gate,
                                   app->a17) != SCENE_SESSION_OK ||
        scene_session_set_pre_gate(app->session, SESSION_A16_TYPE, session_a17_pre_gate,
                                   app->a17) != SCENE_SESSION_OK ||
        scene_session_set_pre_gate(app->session, SESSION_A0B_TYPE, session_a0b_pre_gate,
                                   app->a0b) != SCENE_SESSION_OK ||
        scene_session_set_pre_gate(app->session, SESSION_A0C_TYPE, session_a0c_pre_gate,
                                   app->a0c) != SCENE_SESSION_OK ||
        scene_session_set_condition_extension(
            app->session, session_conditions_extension(app->conditions_binding)) !=
            SCENE_SESSION_OK ||
        !begin_native_session_bindings_scene(app)) {
        record(app, "scene_session_create_error provider=host detail=binding registration");
        return false;
    }
    if (!bind_native_pointer(app)) {
        record(app, "scene_session_create_error provider=pointer-input detail=bind");
        return false;
    }
    record(app, "scene_session_created scene=%d generation=%llu ui_phone_rows=%zu "
           "world=borrowed lifetime=app-owned transition=opaque-tuple-retained "
           "clock=world-clock-normal+timer-records post-clock-gates=guarded "
           "pointer=session_input(RT-6)+provisional-cursor-geometry caption_writer=bound-RGB555 "
           "caption_transfer=bound-RGB555-Frame-plus-decoded-background "
           "audio_provider=live-audio",
           app->current_scene_id,
           (unsigned long long)scene_session_scene_generation(app->session),
           phone_count);
    return true;
}

static bool advance_scene_video(NativeApp *app)
{
    if (app->video == nullptr) return true;
    char error[256] = {};
    bool ended = false;
    for (uint32_t count = 0; count < 100001u; ++count) {
        BinkPlayerFrame next{};
        const int status = bink_player_advance(app->video, monotonic_now_ns(),
                                                &next, error, sizeof(error));
        if (status == BINK_PLAYER_OK) {
            /* The player invalidates its borrowed RGBA view on the next
             * advance; copy each due frame before asking for another. */
            if (!copy_player_frame(app, next)) {
                record(app, "scene_video_error invalid-frame-buffer frame=%d",
                       next.current_frame);
                return false;
            }
            continue;
        }
        if (status == BINK_PLAYER_NOT_DUE) break;
        if (status == BINK_PLAYER_EOS) { ended = true; break; }
        record(app, "scene_video_error status=%d detail=%s", status, error);
        return false;
    }
    if (ended) {
        record(app, "scene_video_eos last_frame=%d", app->scene_current_frame);
        bink_player_close(app->video);
        app->video = nullptr;
    }
    return true;
}

/* With a live session the previous scene is parked in app->retired_scene
 * instead of closed, because the session executor still borrows it. */
static bool load_scene(NativeApp *app, int16_t scene_id, bool keep_previous_open = false)
{
    char name[33], error[256];
    std::snprintf(name, sizeof(name), "S%d", scene_id);
    GameResourceBytes resource = GAME_RESOURCE_BYTES_INIT;
    if (!game_resources_load_bytes(app->resources, name, &resource, error, sizeof(error))) {
        record(app, "scene_error name=%s detail=%s", name, error); return false;
    }
    if (keep_previous_open && app->scene != nullptr) {
        if (app->retired_scene != nullptr) scene_resource_close(app->retired_scene);
        app->retired_scene = app->scene;
    } else {
        scene_resource_close(app->scene);
    }
    app->scene = nullptr;
    if (app->video) bink_player_close(app->video);
    app->video = nullptr;
    if (app->nav_player) bink_player_close(app->nav_player);
    app->nav_player = nullptr;
    app->nav_shown_frame = -1;
    app->has_scene_frame = false;
    app->scene = scene_resource_open_memory(resource.bytes, resource.length, error, sizeof(error));
    game_resource_bytes_destroy(&resource);
    if (!app->scene) { record(app, "scene_error name=%s detail=%s", name, error); return false; }
    app->current_scene_id = scene_id;
    SceneResourceSummary summary{};
    if (scene_resource_get_summary(app->scene, &summary) != SCENE_RESOURCE_OK) return false;
    if (app->new_game.view.action_core != nullptr) {
        const int visit_status = world_init_record_successful_scene_load(
            &app->new_game.view, scene_id, 0);
        if (visit_status != WORLD_INIT_OK) {
            record(app, "world_init_visit_error scene=%d status=%d", scene_id, visit_status);
            return false;
        }
    }
    record(app, "scene_parsed name=%s title=%s background=%s audio=%s actions=%zu",
           name, summary.title, summary.background, summary.audio, summary.action_count);
    /* The original opener probes BIK before AVF. This adapter currently covers
     * the BIK branch only. File lookup follows Windows ASCII case folding. */
    const std::string wanted = std::string(summary.background) + ".bik";
    if (wanted.size() > 37 || wanted.find_first_of("/\\") != std::string::npos) return false;
    const std::string video_directory = app->game_directory + "/CDVideo";
    DIR *directory = opendir(video_directory.c_str());
    if (!directory) return false;
    std::string path;
    unsigned matches = 0;
    while (dirent *entry = readdir(directory)) {
        const std::string candidate = entry->d_name;
        if (candidate.size() != wanted.size()) continue;
        bool same = true;
        for (size_t i = 0; i < wanted.size(); ++i) {
            unsigned char a = (unsigned char)candidate[i], b = (unsigned char)wanted[i];
            if (a >= 'a' && a <= 'z') a -= 'a' - 'A';
            if (b >= 'a' && b <= 'z') b -= 'a' - 'A';
            if (a != b) { same = false; break; }
        }
        if (same) { ++matches; path = video_directory + "/" + candidate; }
    }
    closedir(directory);
    if (matches != 1) { record(app, "scene_media_error missing-or-ambiguous=%s", wanted.c_str()); return false; }
    BinkPlayer *opened_player = nullptr;
    std::unique_ptr<BinkPlayer, decltype(&bink_player_close)> player(
        nullptr, &bink_player_close);
    BinkPlayerInfo info{};
    int video_status = bink_player_open(path.c_str(), &opened_player, &info,
                                        error, sizeof(error));
    player.reset(opened_player);
    if (video_status != BINK_PLAYER_OK) {
        record(app, "scene_media_error status=%d detail=%s", video_status, error);
        return false;
    }
    const uint64_t playback_origin_ns = monotonic_now_ns();
    video_status = bink_player_set_mode(player.get(), 0, playback_origin_ns,
                                        error, sizeof(error));
    if (video_status != BINK_PLAYER_OK) {
        record(app, "scene_media_error status=%d detail=%s", video_status, error);
        return false;
    }
    BinkPlayerFrame first_frame{};
    video_status = bink_player_advance(player.get(), playback_origin_ns,
                                       &first_frame, error, sizeof(error));
    if (video_status != BINK_PLAYER_OK || !copy_player_frame(app, first_frame)) {
        record(app, "scene_media_error status=%d detail=%s", video_status,
               video_status == BINK_PLAYER_OK ? "invalid first-frame buffer" : error);
        return false;
    }
    app->video = player.release();
    /* RT-17: the BIK branch of 0x4163b4 (0x416870..0x4169b4) derives the frame
     * range [0, frames-1] and the image extent from the movie header. */
    app->scene_video_path = path;
    app->scene_native_frames = static_cast<int32_t>(info.total_frames);
    app->scene_native_width = static_cast<int32_t>(info.width);
    app->scene_native_height = static_cast<int32_t>(info.height);
    record(app, "scene_video_open width=%u height=%u frames=%u rate=%d/%d retained_bytes=%llu "
           "mode=0 pacing=native-FFmpeg-timestamps BinkWait-parity=unverified",
           info.width, info.height, info.total_frames, info.frame_rate_num,
           info.frame_rate_den, (unsigned long long)info.decoded_frame_storage_bytes);
    record(app, "scene_frame_decoded width=%u height=%u frame=%d codec=native-FFmpeg original-Bink-equivalence=unverified",
           app->scene_frame.width, app->scene_frame.height, app->scene_current_frame);
    app->has_scene_frame = true;
    if (!render_scene_preview(app) ||
        (app->scene_runtime_enabled &&
         (!seed_native_caption_backbuffer(app) ||
          !native_caption_present_rgba(app)))) {
        app->has_scene_frame = false;
        return false;
    }
    record(app, "scene_preview viewport=%d,%d,%d,%d actions=not-executed audio=absent",
        app->scene_destination.left, app->scene_destination.top,
        app->scene_destination.right, app->scene_destination.bottom);
    /* Action execution is a separate, still-unimplemented boundary. */
    return true;
}

/* KNOWN GAP (RT-4 review): this re-evaluates the outgoing 0x28 row's gate on
 * a throwaway tree built from the scene records, WITHOUT the RT-4 extension.
 * Dependency opcodes 11..21 therefore stay explicitly unsupported here
 * (scene_a28_gate_error ... extension=none), and the original's own tree state
 * (opcode-20 cached sample, opcode-11 slot, the 0x5c3a47 store) is not shared
 * with the row pass. Using the extension on a fresh tree would draw new random
 * samples and write 0x5c3a47 / the sound-manager fields, none of which is
 * proven for the exit handler, so it is left out until the exit path evaluates
 * the executor's existing tree. */
static bool evaluate_a28_dependency_gate(NativeApp *app,
                                         const SceneResource *scene,
                                         size_t action_index,
                                         const SceneActionInfo &action,
                                         int *satisfied)
{
    if (!app || !satisfied || !scene || !app->new_game.view.action_core ||
        action.dependency_count > SIZE_MAX / sizeof(SceneDependencyInfo)) return false;
    std::vector<SceneDependencyInfo> dependencies(action.dependency_count);
    for (size_t i = 0; i < action.dependency_count; ++i) {
        if (scene_resource_dependency_at(scene, action_index, i,
                                         &dependencies[i]) != SCENE_RESOURCE_OK) {
            return false;
        }
    }
    SceneConditionTree *tree = nullptr;
    const int built = scene_conditions_build(dependencies.data(),
        dependencies.size(), &tree);
    if (built != SCENE_CONDITION_OK) return false;

    const ActionCoreWorld &world = *app->new_game.view.action_core;
    SceneConditionState conditions{};
    conditions.event_flags = world.event_flags;
    conditions.event_flag_count = world.event_flag_count;
    conditions.inventory_presence =
        app->new_game.view.inventory.presence_583bd5.values;
    conditions.inventory_count =
        app->new_game.view.inventory.presence_583bd5.count;
    conditions.selected_inventory_item =
        app->new_game.view.inventory.selected_item_candidate
            ? *app->new_game.view.inventory.selected_item_candidate : -1;
    conditions.scene_visit_counts = reinterpret_cast<const int16_t *>(
        app->new_game.view.scene_visit_counts_587b2d.values);
    conditions.scene_visit_count =
        app->new_game.view.scene_visit_counts_587b2d.count;
    conditions.time_of_day_minutes = app->new_game.view.clock.total_minutes;
    uint16_t unsupported_opcode = 0;
    const int status = scene_conditions_evaluate(tree, &conditions, satisfied,
                                                  &unsupported_opcode);
    scene_conditions_destroy(tree);
    if (status != SCENE_CONDITION_OK) {
        record(app, "scene_a28_gate_error status=%d unsupported_opcode=%u extension=none",
               status, unsupported_opcode);
        return false;
    }
    return true;
}

/* RT-5: the 0x28 row that blends two scenes belongs to the OUTGOING scene (it is
 * queued by the leaf 0x44727a and run from the state-4 handler 0x43d227 through
 * 0x447c36, see session_exit.h). The pairing is therefore: the outgoing scene's
 * row, the outgoing scene's last frame as source, the successor's first frame
 * as target. This diagnostic path still has no dispatcher and does not run the
 * effect; the live session does (exit_state_tick). */
static bool prepare_a28_handoff_frames(NativeApp *app, const SceneResource *outgoing)
{
    if (!app || !app->scene || !outgoing || !app->has_scene_frame ||
        !app->has_transition_source_frame) return false;
    app->a28_capture_pair_ready = false;
    size_t action_index = SIZE_MAX;
    SceneActionInfo action{};
    const size_t outgoing_rows = scene_resource_action_count(outgoing);
    size_t type28_rows = 0;
    for (size_t i = 0; i < outgoing_rows; ++i) {
        SceneActionInfo candidate{};
        if (scene_resource_action_at(outgoing, i, &candidate) != SCENE_RESOURCE_OK) {
            return false;
        }
        if (candidate.type == ACTION_FAMILY_28_TYPE) {
            if (type28_rows++ == 0) {
                action_index = i;
                action = candidate;
            }
        }
    }
    record(app, "scene_a28_scan outgoing_scene=%d rows=%zu type28_rows=%zu successor_scene=%d "
           "pairing=outgoing-row(RT-5)", app->transition_source_scene_id, outgoing_rows,
           type28_rows, app->current_scene_id);
    if (action_index == SIZE_MAX) {
        record(app, "scene_a28_handoff=not-applicable no-type-28-row-in-outgoing-scene "
               "outgoing_scene=%d", app->transition_source_scene_id);
        return true;
    }

    ActionFamily28Decoded decoded{};
    size_t consumed = 0;
    if (action_family28_decode(action.typed_body, action.typed_body_length,
                               &decoded, &consumed) != ACTION_FAMILY28_OK ||
        consumed != ACTION_FAMILY_28_BODY_BYTES) {
        record(app, "scene_a28_handoff=unsupported malformed-action index=%zu",
               action_index);
        return true;
    }
    int dependency_satisfied = 0;
    int entry_gate_known = 0;
    if (!evaluate_a28_dependency_gate(app, outgoing, action_index, action,
                                      &dependency_satisfied)) {
        record(app, "scene_a28_entry_gate=unresolved action=%zu dependency_records=%zu "
               "phase=pre-dispatch",
               action_index, action.dependency_count);
    } else {
        entry_gate_known = 1;
        const int32_t flag_1000 =
            app->new_game.action_core.event_flag_count > 1000u
                ? app->new_game.action_core.event_flags[1000] : INT32_MIN;
        record(app, "scene_a28_entry_gate action=%zu subtype=%u dependency=%d "
               "event_flag_1000=%d clock_minutes=%d visit_span_count=%zu "
               "status=pre-dispatch-snapshot-only",
               action_index, action.subtype, dependency_satisfied, flag_1000,
               app->new_game.view.clock.total_minutes,
               app->new_game.view.scene_visit_counts_587b2d.count);
    }

    /* S5900's recovered A-28 uses a zero-sized body rectangle, which the
     * original leaf expands to the full BOOT destination canvas. Other A-28
     * geometry needs a source-backed scene-state transform and stays explicit. */
    if (decoded.rect.right != decoded.rect.left ||
        decoded.rect.bottom != decoded.rect.top) {
        record(app, "scene_a28_handoff=unsupported non-full-canvas-body-rect="
               "%d,%d,%d,%d", decoded.rect.left, decoded.rect.top,
               decoded.rect.right, decoded.rect.bottom);
        return true;
    }
    const int64_t source_width = (int64_t)app->scene_source.right -
                                 app->scene_source.left + 1;
    const int64_t source_height = (int64_t)app->scene_source.bottom -
                                  app->scene_source.top + 1;
    const int64_t destination_width = (int64_t)app->scene_destination.right -
                                      app->scene_destination.left + 1;
    const int64_t destination_height = (int64_t)app->scene_destination.bottom -
                                       app->scene_destination.top + 1;
    if (source_width <= 0 || source_height <= 0 ||
        source_width != destination_width || source_height != destination_height ||
        (uint64_t)source_width > SIZE_MAX / (uint64_t)source_height ||
        (uint64_t)source_width * (uint64_t)source_height > SIZE_MAX / 12u ||
        app->scene_source.left < 0 || app->scene_source.top < 0 ||
        app->transition_source_frame.width == 0u ||
        app->scene_frame.width == 0u ||
        (int64_t)app->scene_source.right >=
            (int64_t)app->transition_source_frame.width ||
        (int64_t)app->scene_source.bottom >=
            (int64_t)app->transition_source_frame.height ||
        (int64_t)app->scene_source.right >= (int64_t)app->scene_frame.width ||
        (int64_t)app->scene_source.bottom >= (int64_t)app->scene_frame.height ||
        decoded.rect.left < 0 || decoded.rect.top < 0) {
        record(app, "scene_a28_handoff=unsupported viewport-or-frame-bounds");
        return true;
    }
    const size_t width = static_cast<size_t>(source_width);
    const size_t height = static_cast<size_t>(source_height);
    const size_t pixel_count = width * height;
    if (pixel_count > SIZE_MAX / 2u) {
        record(app, "scene_a28_handoff=unsupported rgb565-overflow");
        return true;
    }
    const size_t rgb_bytes = pixel_count * 2u;
    size_t capture_bytes = 0;
    if (action_family28_capture_required_bytes(width, height, width,
                                               &capture_bytes) !=
        ACTION_FAMILY28_SURFACE_OK) {
        record(app, "scene_a28_handoff=unsupported capture-size");
        return true;
    }
    app->a28_primary_rgb565.resize(rgb_bytes);
    app->a28_target_rgb565.resize(rgb_bytes);
    app->a28_source_capture_words.resize(capture_bytes);
    app->a28_destination_capture_words.resize(capture_bytes);
    BinkPlayerFrame source_frame{};
    source_frame.rgba = app->transition_source_frame.rgba.data();
    source_frame.rgba_bytes = app->transition_source_frame.rgba.size();
    source_frame.width = app->transition_source_frame.width;
    source_frame.height = app->transition_source_frame.height;
    source_frame.stride = source_frame.width * 4u;
    source_frame.current_frame = app->transition_source_frame.frame_index;
    BinkPlayerFrame target_frame{};
    target_frame.rgba = app->scene_frame.rgba.data();
    target_frame.rgba_bytes = app->scene_frame.rgba.size();
    target_frame.width = app->scene_frame.width;
    target_frame.height = app->scene_frame.height;
    target_frame.stride = target_frame.width * 4u;
    target_frame.current_frame = app->scene_frame.frame_index;
    ActionFamily28PrimarySurface source_surface{};
    ActionFamily28PrimarySurface target_surface{};
    int status = action_family28_surface_from_rgba_rect(&source_frame,
        static_cast<size_t>(app->scene_source.left),
        static_cast<size_t>(app->scene_source.top), width, height,
        app->a28_primary_rgb565.data(), app->a28_primary_rgb565.size(),
        app->scene_destination.left, app->scene_destination.top,
        &source_surface);
    if (status == ACTION_FAMILY28_SURFACE_OK) {
        status = action_family28_surface_from_rgba_rect(&target_frame,
            static_cast<size_t>(app->scene_source.left),
            static_cast<size_t>(app->scene_source.top), width, height,
            app->a28_target_rgb565.data(), app->a28_target_rgb565.size(),
            app->scene_destination.left, app->scene_destination.top,
            &target_surface);
    }
    if (status != ACTION_FAMILY28_SURFACE_OK) {
        record(app, "scene_a28_handoff=unsupported surface-conversion status=%d",
               status);
        app->a28_primary_rgb565.clear();
        app->a28_target_rgb565.clear();
        app->a28_source_capture_words.clear();
        app->a28_destination_capture_words.clear();
        return true;
    }
    const ActionFamily28Rect target_rect = {
        app->scene_destination.left, app->scene_destination.top,
        app->scene_destination.right, app->scene_destination.bottom};
    ActionFamily28WordCapture source_capture{
        app->a28_source_capture_words.data(),
        app->a28_source_capture_words.size(), width, height, width,
        static_cast<size_t>(decoded.rect.left),
        static_cast<size_t>(decoded.rect.top),
        ACTION_FAMILY28_STORAGE_CALLER_OWNED};
    ActionFamily28WordCapture destination_capture{
        app->a28_destination_capture_words.data(),
        app->a28_destination_capture_words.size(), width, height, width,
        static_cast<size_t>(decoded.rect.left),
        static_cast<size_t>(decoded.rect.top),
        ACTION_FAMILY28_STORAGE_CALLER_OWNED};
    status = action_family28_surface_capture_words_at(&source_surface,
        &target_rect, static_cast<size_t>(decoded.rect.left),
        static_cast<size_t>(decoded.rect.top), &source_capture);
    if (status == ACTION_FAMILY28_SURFACE_OK) {
        status = action_family28_surface_capture_words_at(&target_surface,
            &target_rect, static_cast<size_t>(decoded.rect.left),
            static_cast<size_t>(decoded.rect.top), &destination_capture);
    }
    if (status != ACTION_FAMILY28_SURFACE_OK) {
        record(app, "scene_a28_handoff=unsupported word-capture status=%d", status);
        app->a28_primary_rgb565.clear();
        app->a28_target_rgb565.clear();
        app->a28_source_capture_words.clear();
        app->a28_destination_capture_words.clear();
        return true;
    }
    app->a28_capture_pair_ready = true;
    record(app, "scene_a28_capture_pair current_scene=%d current_frame=%d "
           "target_scene=%d target_frame=%d source_view=%d,%d,%d,%d "
           "target_view=%d,%d,%d,%d crop=%d,%d canvas=%zux%zu "
           "capture_bytes_each=%zu scope=decoded-background-only "
           "original-composed-framebuffer=not-represented",
           app->transition_source_scene_id, app->transition_source_frame.frame_index,
           app->current_scene_id, app->scene_frame.frame_index,
           app->scene_source.left, app->scene_source.top,
           app->scene_source.right, app->scene_source.bottom,
           app->scene_destination.left, app->scene_destination.top,
           app->scene_destination.right, app->scene_destination.bottom,
           decoded.rect.left, decoded.rect.top, width, height, capture_bytes);
    record(app, "scene_a28_execution=not-run reason=diagnostic-path-has-no-dispatcher "
           "(live session runs the exit effect) entry_gate_known=%d entry_gate=%d",
           entry_gate_known, dependency_satisfied);
    return true;
}

static bool initialize_new_game(NativeApp *app, uint32_t now_tick)
{
    EngineBootStartupSettings settings{};
    WorldInitStartupOverrides overrides{};
    overrides.forced_scene_id = -1;
    if (engine_boot_get_startup_settings(app->boot, &settings) != ENGINE_BOOT_OK) {
        record(app, "world_init_error startup-settings");
        return false;
    }
    const int status = world_init_apply_new_game(&app->new_game.view, &settings,
                                                  &overrides, now_tick);
    if (status != WORLD_INIT_OK) {
        record(app, "world_init_error new-game status=%d", status);
        return false;
    }
#ifdef BLACKMOOR_NATIVE_APP_TEST_HOOKS
    if (!app->test_inventory.empty() || app->test_held != -2) {
        WorldInitInventory &inv = app->new_game.view.inventory;
        for (size_t i = 0; i < app->test_inventory.size() && i < inv.item_ids_583a31.count; ++i) {
            inv.item_ids_583a31.values[i] = static_cast<uint16_t>(app->test_inventory[i]);
            if (app->test_inventory[i] >= 0 &&
                static_cast<size_t>(app->test_inventory[i]) < inv.presence_583bd5.count)
                inv.presence_583bd5.values[app->test_inventory[i]] = 1;
        }
        inv.selector_words_583a2b.values[0] = static_cast<uint16_t>(app->test_inventory.size());
        if (app->test_held != -2) *inv.selected_item_candidate = static_cast<int16_t>(app->test_held);
        record(app, "test_inventory_seeded count=%zu held=%d", app->test_inventory.size(),
               (int)*inv.selected_item_candidate);
    }
#endif
    inventory_view_sync(app);   /* RT-22: 0x4e7e15 -> 0x4e812f fills the view slots after New Game */
    app->world_clock_session.world = &app->new_game.view;
    /* The two signed window bounds are in the PE zero-filled data tail and
     * have no direct .text stores in the pinned image. The session object is
     * zero-initialized to those cold values; the clock update owns the flag. */
    app->world_clock_session.outside_window_flag_5bb20a = 0;
    app->world_clock_session.time_window_start_5b0284 = 0;
    app->world_clock_session.time_window_end_5b0286 = 0;
    /* 0x4348b0 reads [Nancy Data] ClosedCaptioning with default zero. */
    app->world_clock_session.captions_enabled_5bb202 = app->closed_captioning;
    if (app->new_game.view.start_tuple.scene_id < INT16_MIN ||
        app->new_game.view.start_tuple.scene_id > INT16_MAX) {
        record(app, "world_init_error scene-id-out-of-host-range=%d",
               app->new_game.view.start_tuple.scene_id);
        return false;
    }
    app->initial_scene = static_cast<int16_t>(app->new_game.view.start_tuple.scene_id);
    app->new_game.action64_world.clock_value_585d51 =
        app->new_game.view.clock.configured_hour;
    app->new_game.action64_world.clock_value_585d4f =
        app->new_game.view.clock.configured_minute;
    app->new_game.action64_world.clock_total_585d4b =
        app->new_game.view.clock.total_minutes;
    app->new_game.action64_world.clock_deadline_585d55 =
        app->new_game.view.clock.next_update_tick;
    app->new_game.action64_world.deadline_offset_5b0280 =
        app->new_game.view.clock.update_interval_ms;
    record(app, "new_game_initialized scene=%d coordinate_words=%d,%d source=%u "
           "clock=%d:%02d tick=%u flags_view=%zu visits_view=%zu inventory_view=%zu "
           "original-global-capacities=unknown",
           app->new_game.view.start_tuple.scene_id,
           app->new_game.view.start_tuple.coordinate_word_a,
           app->new_game.view.start_tuple.coordinate_word_b,
           app->new_game.view.start_tuple.source,
           app->new_game.view.clock.configured_hour,
           app->new_game.view.clock.configured_minute,
           now_tick, app->new_game.action_core.event_flag_count,
           app->new_game.view.scene_visit_counts_587b2d.count,
           app->new_game.view.inventory.presence_583bd5.count);
    return true;
}

static bool clear_before_scene_entry(NativeApp *app, uint32_t now_tick)
{
    const int status = world_init_apply_scene_clear(&app->new_game.view, 0, now_tick);
    if (status != WORLD_INIT_OK) {
        record(app, "world_init_error scene-clear status=%d", status);
        return false;
    }
    app->new_game.action64_world.clock_deadline_585d55 =
        app->new_game.view.clock.next_update_tick;
    /* ClearSceneData 0x43dbe3 also stores [0x5839a9] = 0 (0x43dff8) and, through
     * the latch constructor call (0x43e230) and the loaders, [0x5c39e9] = 0.
     * The caption lifecycle keeps the app's mirror of both words. */
    app->captions.lifecycle.g.modal_input = 0;
    app->captions.lifecycle.g.cursor_override = 0;
    return true;
}

/* ---- RT-5: scene exit (states 4, 1, 2 of 0x438150) ----------------------
 *
 * The decisions live in session_exit.c (oracle-compared against 0x43d227,
 * 0x447c36, 0x4473be, 0x447418, 0x4474cf and the ClearSceneData windows). This
 * block only supplies the host boundaries: capturing the composed viewport
 * into the A-28 capture layout, running the A-28 surface sequence and
 * presenting its frames.
 *
 * Named gaps (also in the RT-5 handoff): the nested state-3 tick of the stage-0
 * setup (0x447440) is not re-run; the capture source is the frame composed by
 * the last session tick. The x87 control word is the Win32 thread default
 * 0x027f and is unverified. Only the viewport rectangle is captured; the
 * original composed framebuffer outside it is not part of the effect. */
static const uint16_t kAmbientX87ControlWord = ACTION_FAMILY28_X87_CW_DOUBLE;

static bool exit_viewport_size(NativeApp *app, size_t *width, size_t *height)
{
    const int64_t w = (int64_t)app->scene_destination.right - app->scene_destination.left + 1;
    const int64_t h = (int64_t)app->scene_destination.bottom - app->scene_destination.top + 1;
    if (w <= 0 || h <= 0 || app->scene_destination.left < 0 || app->scene_destination.top < 0 ||
        app->scene_destination.right >= 640 || app->scene_destination.bottom >= 480 ||
        app->framebuffer.size() != 640u * 480u * 4u) return false;
    *width = static_cast<size_t>(w);
    *height = static_cast<size_t>(h);
    return true;
}

/* The composed 640x480 frame (app->framebuffer is the last presented frame,
 * refreshed from the caption back buffer after every session tick and after
 * every scene load) cropped to the viewport as the A-28 RGB565 primary. */
static bool exit_build_primary(NativeApp *app, ActionFamily28PrimarySurface *surface,
                               size_t *width, size_t *height)
{
    if (!exit_viewport_size(app, width, height) || *width > SIZE_MAX / *height / 2u) return false;
    BinkPlayerFrame frame{};
    frame.rgba = app->framebuffer.data();
    frame.rgba_bytes = app->framebuffer.size();
    frame.width = 640u;
    frame.height = 480u;
    frame.stride = 640u * 4u;
    frame.current_frame = -1;
    app->exit_primary_rgb565.resize(*width * *height * 2u);
    return action_family28_surface_from_rgba_rect(&frame,
        static_cast<size_t>(app->scene_destination.left),
        static_cast<size_t>(app->scene_destination.top), *width, *height,
        app->exit_primary_rgb565.data(), app->exit_primary_rgb565.size(),
        app->scene_destination.left, app->scene_destination.top, surface) ==
        ACTION_FAMILY28_SURFACE_OK;
}

static bool exit_payload_crop(NativeApp *app, size_t *crop_x, size_t *crop_y)
{
    ActionFamily28Decoded decoded{};
    size_t consumed = 0;
    if (action_family28_decode(app->exit_state.effect.active_payload,
                               ACTION_FAMILY_28_BODY_BYTES, &decoded, &consumed) !=
            ACTION_FAMILY28_OK || decoded.rect.left < 0 || decoded.rect.top < 0) return false;
    /* Same guard as the diagnostic handoff: only the zero-sized rectangle the
     * original expands to the full canvas is recovered (types 1/3 and other
     * geometry stay explicit rather than silently cropping). */
    if (decoded.rect.right != decoded.rect.left || decoded.rect.bottom != decoded.rect.top) {
        record(app, "scene_exit_effect_unsupported non-full-canvas-body-rect=%d,%d,%d,%d",
               decoded.rect.left, decoded.rect.top, decoded.rect.right, decoded.rect.bottom);
        return false;
    }
    *crop_x = static_cast<size_t>(decoded.rect.left);
    *crop_y = static_cast<size_t>(decoded.rect.top);
    return true;
}

static int exit_host_nested_tick(void *context)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    record(app, "scene_exit_nested_state3_tick executed=no reason=0x43a7ca-not-re-run "
           "source=last-composed-frame effect_type=%u", app->exit_state.effect.active_payload[0]);
    return 0;
}

static int exit_host_capture(void *context, SessionExitCapture which)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    ActionFamily28PrimarySurface surface{};
    size_t width = 0, height = 0, crop_x = 0, crop_y = 0, bytes = 0;
    if (!exit_build_primary(app, &surface, &width, &height) ||
        !exit_payload_crop(app, &crop_x, &crop_y) ||
        action_family28_capture_required_bytes(width, height, width, &bytes) !=
            ACTION_FAMILY28_SURFACE_OK) {
        record(app, "scene_exit_capture_error which=%d detail=viewport-or-payload", (int)which);
        return 1;
    }
    std::vector<uint8_t> &words = which == SESSION_EXIT_CAPTURE_SOURCE
        ? app->exit_source_words : app->exit_destination_words;
    words.assign(bytes, 0u);
    const ActionFamily28Rect target = {app->scene_destination.left, app->scene_destination.top,
                                       app->scene_destination.right, app->scene_destination.bottom};
    ActionFamily28WordCapture capture{words.data(), words.size(), width, height, width,
                                      crop_x, crop_y, ACTION_FAMILY28_STORAGE_CALLER_OWNED};
    const int status = action_family28_surface_capture_words_at(&surface, &target, crop_x,
                                                                crop_y, &capture);
    record(app, "scene_exit_capture which=%s status=%d canvas=%zux%zu bytes=%zu crop=%zu,%zu "
           "scope=composed-viewport-from-last-presented-frame "
           "original-composed-framebuffer=viewport-only",
           which == SESSION_EXIT_CAPTURE_SOURCE ? "source" : "destination", status, width,
           height, bytes, crop_x, crop_y);
    return status == ACTION_FAMILY28_SURFACE_OK ? 0 : 1;
}

static int exit_host_clear_destination(void *context)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    size_t width = 0, height = 0, bytes = 0;
    if (!exit_viewport_size(app, &width, &height) ||
        action_family28_capture_required_bytes(width, height, width, &bytes) !=
            ACTION_FAMILY28_SURFACE_OK) return 1;
    app->exit_destination_words.assign(bytes, 0u);
    record(app, "scene_exit_clear_destination bytes=%zu", bytes);
    return 0;
}

static int exit_sequence_tick(void *, uint32_t *out)
{
    *out = blackmoor_macos_monotonic_ms();
    return 0;
}

static int exit_sequence_present(void *context, const ActionFamily28PrimarySurface *surface,
                                 uint32_t frame_index)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    (void)frame_index;
    if (surface == nullptr || surface->pixels == nullptr ||
        surface->origin_x != app->scene_destination.left ||
        surface->origin_y != app->scene_destination.top) return 1;
    for (size_t y = 0; y < surface->height; ++y) {
        for (size_t x = 0; x < surface->width; ++x) {
            const uint8_t *packed = surface->pixels + y * surface->pitch_bytes + x * 2u;
            const uint16_t word = static_cast<uint16_t>(packed[0] | (packed[1] << 8));
            const unsigned r5 = (word >> 11) & 31u, g6 = (word >> 5) & 63u, b5 = word & 31u;
            uint8_t *out = app->framebuffer.data() +
                ((static_cast<size_t>(app->scene_destination.top) + y) * 640u +
                 static_cast<size_t>(app->scene_destination.left) + x) * 4u;
            out[0] = static_cast<uint8_t>((r5 << 3) | (r5 >> 2));
            out[1] = static_cast<uint8_t>((g6 << 2) | (g6 >> 4));
            out[2] = static_cast<uint8_t>((b5 << 3) | (b5 >> 2));
            out[3] = 255u;
        }
    }
    ++app->exit_sequence_presents;
    if (app->platform && !blackmoor_macos_present(app->platform, app->framebuffer.data(),
                                                  app->framebuffer.size(), 640 * 4)) return 1;
    return 0;
}

static int exit_sequence_graphics_pump(void *context, uint32_t)
{
    ++static_cast<NativeApp *>(context)->exit_sequence_graphics_pumps;
    return 0;
}

static int exit_sequence_audio_pump(void *context)
{
    ++static_cast<NativeApp *>(context)->exit_sequence_audio_pumps;
    return 0;
}

static int exit_host_run_sequence(void *context, ActionFamily28SequenceState *state)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    ActionFamily28PrimarySurface surface{};
    size_t width = 0, height = 0, crop_x = 0, crop_y = 0, bytes = 0;
    if (!exit_build_primary(app, &surface, &width, &height) ||
        !exit_payload_crop(app, &crop_x, &crop_y) ||
        action_family28_capture_required_bytes(width, height, width, &bytes) !=
            ACTION_FAMILY28_SURFACE_OK ||
        app->exit_source_words.size() != bytes || app->exit_destination_words.size() != bytes) {
        record(app, "scene_exit_sequence_error detail=capture-buffers-missing source_bytes=%zu "
               "destination_bytes=%zu expected=%zu", app->exit_source_words.size(),
               app->exit_destination_words.size(), bytes);
        return 1;
    }
    state->source_capture = {app->exit_source_words.data(), app->exit_source_words.size()};
    state->destination_capture = {app->exit_destination_words.data(),
                                  app->exit_destination_words.size()};
    state->capture_width_pixels = width;
    state->capture_height_pixels = height;
    state->capture_stride_pixels = width;
    state->capture_offset_x_pixels = crop_x;
    state->capture_offset_y_pixels = crop_y;
    state->primary_target = 1u;
    ActionFamily28SurfaceSequenceCallbacks callbacks{};
    callbacks.context = app;
    callbacks.get_tick_count = exit_sequence_tick;
    callbacks.present_primary = exit_sequence_present;
    callbacks.graphics_tail_pump = exit_sequence_graphics_pump;
    callbacks.system_audio_pump = exit_sequence_audio_pump;
    ActionFamily28SurfaceSequenceReport report{};
    app->exit_sequence_audio_pumps = app->exit_sequence_graphics_pumps = 0u;
    app->exit_sequence_presents = 0u;
    const uint8_t type = state->subtype;
    const int status = action_family28_surface_run_sequence(&surface, state, &callbacks,
                                                            kAmbientX87ControlWord, &report);
    /* Subtype 3 swaps the two capture spans (0x447756); keep the buffers with them. */
    if (status == ACTION_FAMILY28_SURFACE_OK &&
        state->source_capture.data == app->exit_destination_words.data()) {
        app->exit_source_words.swap(app->exit_destination_words);
    }
    record(app, "scene_exit_sequence type=%u status=%d selected_frames=%d planned_frames=%u "
           "first_frame_ms=%u blends=%u presents=%u graphics_pumps=%u audio_pumps=%u "
           "completion=%u x87_cw=0x%04x(unverified) curve=non-bit-exact "
           "scope=decoded-composed-viewport",
           type, status, report.controller.selected_frame_count,
           report.controller.planned_frame_count, report.controller.first_frame_elapsed_ms,
           report.blend_successes, app->exit_sequence_presents,
           app->exit_sequence_graphics_pumps, app->exit_sequence_audio_pumps,
           report.controller.completion_committed, kAmbientX87ControlWord);
    return status == ACTION_FAMILY28_SURFACE_OK ? 0 : 1;
}

static SessionExitHost make_exit_host(NativeApp *app)
{
    SessionExitHost host{};
    host.context = app;
    host.nested_scene_tick = exit_host_nested_tick;
    host.capture = exit_host_capture;
    host.clear_destination_capture = exit_host_clear_destination;
    host.run_sequence = exit_host_run_sequence;
    return host;
}

/* LoadNewSceneData (0x439822) for a pending scene change, run from state 1.
 * Order of the proven ClearSceneData (0x43dbe3) subset and the load:
 *   sounds (blanket unload: the original's sound reset sits in the unrecovered
 *   first half of 0x43dbe3, its placement is unverified), world scene clear,
 *   frame text box close + caption flags (0x43e1bd..0x43e221), action table
 *   replacement (session replace; the original keeps rows of type 0x2d, which
 *   the native executor does not), input latches (0x43e3d5..0x43e433), then
 *   the target resource load. Unrecovered ClearSceneData resets (the object
 *   reset calls of 0x43dbe3, 0x4dad60, the frame-visited words 0x5bb50d) are
 *   not performed. The old scene resource closes after the replacement. */
static bool perform_session_transition(NativeApp *app,
                                       const SceneTransitionRequest &requested,
                                       uint32_t now)
{
    SceneTransitionRequest transition = requested;
#ifdef BLACKMOOR_NATIVE_APP_TEST_HOOKS
    if (app->test_exit_redirect >= 0 && app->test_exit_redirect <= INT16_MAX &&
        requested.target_scene == app->test_exit_redirect_from) {
        record(app, "test_exit_redirect requested=%d loaded=%d (test hook; not game flow)",
               requested.target_scene, app->test_exit_redirect);
        transition.target_scene = static_cast<int16_t>(app->test_exit_redirect);
    }
#endif
    if (transition.target_scene < 0) {
        record(app, "scene_transition_error target=%d detail=negative-scene", transition.target_scene);
        return false;
    }
    const int16_t source = app->current_scene_id;
    if (app->live_audio != nullptr && live_audio_unload_all(app->live_audio) != LIVE_AUDIO_OK) {
        record(app, "scene_transition_error source=%d target=%d detail=audio-unload-failed",
               source, transition.target_scene);
        return false;
    }
    if (!clear_before_scene_entry(app, now)) {
        record(app, "scene_transition_error source=%d target=%d detail=scene-clear",
               source, transition.target_scene);
        return false;
    }
    const int caption_status = session_exit_clear_caption(&app->exit_state, &app->captions.lifecycle,
                                                          &app->captions.lifecycle_backend);
    record(app, "scene_clear_caption status=%d order=close-frame-text-0x4de2d8,scroll-lines,"
           "0x5b15c8,0x5b15d6,0x5b15da,0x5b1602,0x5b1606,0x5bb1da,0x5831c8 frame_open=%u "
           "caption_visible=%d caption_finish=%d framed_ready=%d",
           caption_status, app->captions.writer_globals.frame_open,
           app->captions.writer_globals.caption_visible_flag,
           app->captions.writer_globals.caption_finish_flag,
           app->captions.writer_globals.framed_ready);
    if (caption_status != SESSION_EXIT_OK) {
        record(app, "scene_transition_error source=%d target=%d detail=caption-clear status=%d",
               source, transition.target_scene, caption_status);
        return false;
    }
    if (!load_scene(app, transition.target_scene, true)) {
        record(app, "scene_transition_error source=%d target=%d detail=target-load-failed",
               source, transition.target_scene);
        return false;
    }
    SceneSessionFailure failure{};
    /* The session checks the id against its pending request; the test redirect
     * therefore passes the requested id with the redirected resource. */
    const int status = scene_session_replace_scene(app->session, app->scene,
                                                    requested.target_scene, &failure);
    if (status != SCENE_SESSION_OK) {
        record(app, "scene_transition_error source=%d target=%d detail=session-replace status=%d provider=%s "
               "action=%zu type=0x%02x detail_status=%d",
               source, transition.target_scene, status,
               scene_session_provider_string(failure.provider), failure.action_index,
               failure.action_type, failure.detail_status);
        return false;
    }
    if (app->retired_scene != nullptr) {
        scene_resource_close(app->retired_scene);
        app->retired_scene = nullptr;
    }
    session_exit_clear_latches(&app->exit_state);
    record(app, "scene_clear_latches order=0x5c39ff,0x5c39e9,0x5c39ed,0x5c39f1,0x5c39f5,0x5c39f9,"
           "0x5c39e5,0x5bb1c4,0x63a5c0,0x63a5c4 input_latch_5c39e5=%d cursor_override_5c39e9=%d "
           "consumer=session_input(RT-6) session_input_candidate=%d "
           "(exit_state copies are unread mirrors; the module state is authoritative)",
           app->exit_state.g.input_latch, app->exit_state.g.cursor_override,
           app->input_state.candidate);
    /* DAT_005bb50b := DAT_005bb599 (0x439f20..0x439f41), the frame word of the
     * scene-change request (0x427a50 case 0x0a copies body+2 into it). */
    app->selector_entry_frame = transition.opaque_words[0];
    app->selector_entry_scroll = transition.opaque_words[1];
#ifdef BLACKMOOR_NATIVE_APP_TEST_HOOKS
    for (const auto &pair : app->test_selectors)
        if (pair.first == transition.target_scene) {
            app->selector_entry_frame = pair.second;
            record(app, "test_selector_applied scene=%d frame=%d (stands in for the unbound navigation "
                   "producer 0x43c2b7..)", transition.target_scene, pair.second);
        }
    for (const auto &pair : app->test_held_at)
        if (pair.first == transition.target_scene &&
            app->new_game.view.inventory.selected_item_candidate != nullptr) {
            *app->new_game.view.inventory.selected_item_candidate = static_cast<int16_t>(pair.second);
            record(app, "test_held_applied scene=%d item=%d (stands in for the unbound inventory "
                   "selection UI)", transition.target_scene, pair.second);
        }
#endif
    app->selector_entry_valid = true;
    app->selector_logged = false;
    if (!begin_native_session_bindings_scene(app)) {
        record(app, "scene_transition_error source=%d target=%d detail=binding-scene-load",
               source, transition.target_scene);
        return false;
    }
    app->session_block_reported = false;
    app->session_transition_reported = false;
    record(app, "scene_transition_applied source=%d target=%d generation=%llu",
           source, transition.target_scene,
           (unsigned long long)scene_session_scene_generation(app->session));
    return true;
}

/* RT-13: say why the session stopped, in terms a player or developer can act on. */
static void describe_session_block(const NativeApp *app, const SceneSessionTickResult &r,
                                   char *out, size_t capacity)
{
    const char *detail = "";
    if (r.failure.action_type == SESSION_A79_TYPE) detail = session_a79_failure(app->a79);
    else if (r.failure.action_type == SESSION_A78_TYPE) detail = session_a78_failure(app->a78);
    else if (r.failure.action_type == SESSION_A97_TYPE) detail = session_a97_failure(app->a97);
    else if (r.failure.action_type == SESSION_AA1_TYPE) detail = session_aa1_failure(app->aa1);
    else if (r.failure.action_type == SESSION_A36_TYPE ||
             r.failure.action_type == SESSION_A37_TYPE) detail = session_a36_failure(app->a36);
    else if (r.failure.action_type == SESSION_A17_TYPE ||
             r.failure.action_type == SESSION_A16_TYPE) detail = session_a17_failure(app->a17);
    else if (r.failure.action_type == SESSION_A0B_TYPE) detail = session_a0b_failure(app->a0b);
    else if (r.failure.action_type == SESSION_A0C_TYPE) detail = session_a0c_failure(app->a0c);
    if (r.failure.stage == SCENE_SESSION_STAGE_DISPATCH &&
        r.failure.detail_status == SCENE_ACTION_HANDLER_UNSUPPORTED &&
        (detail[0] == '\0' || std::strcmp(detail, "none") == 0))
        std::snprintf(out, capacity, "action type 0x%02x at row %zu has no native runtime yet",
                      r.failure.action_type, r.failure.action_index);
    else if (r.failure.stage == SCENE_SESSION_STAGE_DISPATCH)
        std::snprintf(out, capacity, "action type 0x%02x at row %zu stopped: %s (detail %d)",
                      r.failure.action_type, r.failure.action_index,
                      detail[0] != '\0' && std::strcmp(detail, "none") != 0 ? detail
                          : scene_session_provider_string(r.failure.provider),
                      r.failure.detail_status);
    else
        std::snprintf(out, capacity, "stage %d provider %s failed (detail %d)",
                      r.failure.stage, scene_session_provider_string(r.failure.provider),
                      r.failure.detail_status);
}

enum class ExitTick { Run, Consumed, Failed };

/* One main-loop step for the non-running states of 0x438150. */
static ExitTick exit_state_tick(NativeApp *app, uint32_t now)
{
    SessionExit &x = app->exit_state;
    switch (x.g.game_state) {
    case SESSION_EXIT_STATE_EXIT: {
        const SessionExitHost host = make_exit_host(app);
        SessionExitStepInfo info{};
        const int status = session_exit_state4(&x, &host, &info);
        record(app, "scene_exit_state4 status=%d controller_ran=%u stage_before=%u effect_busy=%u "
               "effect_type=%u state_after=%u unsupported=%s boundary=%d",
               status, info.controller_ran, info.stage_before, x.effect.busy,
               x.effect.active_payload[0], x.g.game_state,
               session_exit_unsupported_string(info.unsupported), (int)info.failed_boundary);
        if (status != SESSION_EXIT_OK) {
            record(app, "scene_transition_error source=%d target=%d detail=exit-handler "
                   "status=%d reason=%s", app->current_scene_id, x.g.scene_request, status,
                   session_exit_status_string(status));
            return ExitTick::Failed;
        }
        return ExitTick::Consumed;
    }
    case SESSION_EXIT_STATE_LOAD: {
        SceneTransitionRequest pending{};
        if (!scene_session_get_pending_transition(app->session, &pending)) {
            record(app, "scene_transition_error detail=load-state-without-pending-transition");
            return ExitTick::Failed;
        }
        session_exit_begin_load(&x);
        record(app, "scene_load_state next_state=%u transition_word_5c39ff=%d",
               x.g.game_state, x.g.scene_request_flag);
        return perform_session_transition(app, pending, now) ? ExitTick::Consumed
                                                             : ExitTick::Failed;
    }
    case SESSION_EXIT_STATE_INTRO:
        record(app, "scene_intro_state executed=no reason=0x4fb018/0x4fc341-scene-sound-start-"
               "not-reproduced scene=%d", app->current_scene_id);
        session_exit_finish_intro(&x);
        return ExitTick::Consumed;
    default:
        return ExitTick::Run;
    }
}

static void update(NativeApp *app, uint32_t now)
{
    app->session_tick_sample = now;
    if (app->session != nullptr) {
        /* States 4 (exit handler), 1 (load) and 2 (intro) of 0x438150 take the
         * place of the scene tick, one state per host update like the original
         * main loop; only state 3 runs the dispatcher. */
        const ExitTick exit_tick = exit_state_tick(app, now);
        if (exit_tick == ExitTick::Failed) {
            app->failure = true;
            if (app->platform) blackmoor_macos_stop(app->platform);
            return;
        }
        SceneSessionTickResult session_result{};
        if (app->live_audio != nullptr && app->offline_audio_frames_per_update != 0u) {
            const bool capture_movie = app->movie_bink != nullptr &&
                app->movie_frame.rgba != nullptr && app->movie_mix_captures < 3u;
            std::array<float, LIVE_AUDIO_RENDER_CHUNK_FRAMES * 2u> pcm{};
            LiveAudioOfflineStats stats{};
            if (live_audio_advance_offline(app->live_audio, app->offline_audio_frames_per_update,
                    &stats, capture_movie ? pcm.data() : nullptr,
                    capture_movie ? LIVE_AUDIO_RENDER_CHUNK_FRAMES : 0u) != LIVE_AUDIO_OK) {
                app->failure = true;
                record(app, "live_audio_offline_advance_failed");
                if (app->platform) blackmoor_macos_stop(app->platform);
                return;
            }
            if (capture_movie) {
                uint32_t rate = 0, channels = 0;
                live_audio_offline_format(app->live_audio, &rate, &channels);
                const size_t count = std::min<size_t>(stats.frames, LIVE_AUDIO_RENDER_CHUNK_FRAMES) * channels;
                const uint8_t *bytes = reinterpret_cast<const uint8_t *>(pcm.data());
                uint64_t hash = UINT64_C(14695981039346656037);
                for (size_t i = 0; i < count * sizeof(float); ++i) {
                    hash ^= bytes[i]; hash *= UINT64_C(1099511628211);
                }
                record(app, "scene_a35_mix_capture index=%u frames=%llu rate=%u channels=%u "
                       "nonzero=%llu peak=%.8f nonfinite=%llu pcm_fnv1a64=%016llx "
                       "scope=native-mixer-including-scene-sounds output-device=none",
                       app->movie_mix_captures++, (unsigned long long)stats.frames, rate, channels,
                       (unsigned long long)stats.nonzero_samples, stats.peak,
                       (unsigned long long)stats.nonfinite_samples, (unsigned long long)hash);
            }
        }
        if (exit_tick == ExitTick::Consumed) {
            if (app->platform && !blackmoor_macos_present(app->platform,
                    app->framebuffer.data(), app->framebuffer.size(), 640 * 4)) {
                app->failure = true;
                blackmoor_macos_stop(app->platform);
                return;
            }
            if (app->platform && app->stop_after &&
                (uint32_t)(now - app->started) > app->stop_after)
                blackmoor_macos_stop(app->platform);
            return;
        }
        taskbar_pre_tick(app);   /* RT-22 follow-up: inventory byte -> view, bar hover */
        const int session_status = scene_session_tick(app->session, &session_result);
        if (session_status != SCENE_SESSION_BLOCKED) taskbar_post_tick(app, now);   /* 0x43cf9c */
        if (session_status == SCENE_SESSION_BLOCKED && !app->session_block_reported) {
            record(app, "scene_session_blocked stage=%d provider=%s action=%zu type=0x%02x detail=%d "
                   "effects_before_block=%zu dispatch_attempted=%u",
                   session_result.failure.stage,
                   scene_session_provider_string(session_result.failure.provider),
                   session_result.failure.action_index, session_result.failure.action_type,
                   session_result.failure.detail_status,
                   session_result.executor.actions_applied,
                   session_result.dispatch_attempted);
            if (session_result.failure.provider == SCENE_SESSION_PROVIDER_A35)
                record(app, "scene_a35_blocker detail=%s %s", session_a35_failure(app->a35),
                       session_a35_bink_failure(app->movie_bink));
            if (session_result.failure.action_type == SESSION_A97_TYPE)
                record(app, "scene_a97_blocker detail=%s", session_a97_failure(app->a97));
            if (session_result.failure.action_type == SESSION_AA1_TYPE)
                record(app, "scene_aa1_blocker detail=%s", session_aa1_failure(app->aa1));
            if (session_result.failure.action_type == SESSION_A79_TYPE)
                record(app, "scene_a79_blocker detail=%s", session_a79_failure(app->a79));
            if (session_result.failure.action_type == SESSION_A78_TYPE)
                record(app, "scene_a78_blocker detail=%s", session_a78_failure(app->a78));
            if (session_result.failure.action_type == SESSION_A36_TYPE ||
                session_result.failure.action_type == SESSION_A37_TYPE)
                record(app, "scene_a36_blocker detail=%s", session_a36_failure(app->a36));
            if (session_result.failure.action_type == SESSION_A17_TYPE ||
                session_result.failure.action_type == SESSION_A16_TYPE)
                record(app, "scene_a17_blocker detail=%s", session_a17_failure(app->a17));
            if (session_result.failure.action_type == SESSION_A0B_TYPE)
                record(app, "scene_a0b_blocker detail=%s", session_a0b_failure(app->a0b));
            if (session_result.failure.action_type == SESSION_A0C_TYPE)
                record(app, "scene_a0c_blocker detail=%s", session_a0c_failure(app->a0c));
            SceneConditionFailure condition_failure{};
            if (scene_session_get_condition_failure(app->session, &condition_failure) ==
                    SCENE_SESSION_OK && condition_failure.opcode != 0u) {
                record(app, "scene_session_dependency_failure opcode=%u record=%zu provider_status=%d",
                       condition_failure.opcode, condition_failure.record_index,
                       condition_failure.provider_status);
            }
            {
                /* RT-13: the silent freeze. One persistent log line with the scene,
                 * row, type and reason, and the same facts in the window title. */
                char reason[192];
                describe_session_block(app, session_result, reason, sizeof(reason));
                record(app, "session_frozen scene=%d generation=%llu row=%zu type=0x%02x "
                       "provider=%s stage=%d reason=\"%s\" ticks_after_block=stopped "
                       "pointer_input=ignored",
                       app->current_scene_id,
                       (unsigned long long)scene_session_scene_generation(app->session),
                       session_result.failure.action_index, session_result.failure.action_type,
                       scene_session_provider_string(session_result.failure.provider),
                       session_result.failure.stage, reason);
                if (app->platform) {
                    char title[320];
                    std::snprintf(title, sizeof(title),
                                  "Blackmoor reconstruction — STOPPED in scene %d: %s; input ignored",
                                  app->current_scene_id, reason);
                    blackmoor_macos_set_title(app->platform, title);
                }
            }
            app->blocked_input_ignored = 0u;
            app->session_block_reported = true;
        } else if (session_status == SCENE_SESSION_TRANSITION_PENDING &&
                   !app->session_transition_reported) {
            SceneTransitionRequest transition{};
            if (scene_session_get_pending_transition(app->session, &transition)) {
                record(app, "scene_session_transition_pending source=%d target=%d "
                       "opaque_words=%d,%d,%d opaque_dwords=%d,%d,%d "
                       "target_loader=state-1",
                       app->current_scene_id, transition.target_scene,
                       transition.opaque_words[0], transition.opaque_words[1],
                       transition.opaque_words[2], transition.opaque_dwords[0],
                       transition.opaque_dwords[1], transition.opaque_dwords[2]);
                /* Dispatcher case 0x0a: the scene request and state := 4. */
                session_exit_request_transition(&app->exit_state, &transition);
                record(app, "scene_exit_requested state=%u effect_busy=%u effect_type=%u "
                       "effect_stage=%u", app->exit_state.g.game_state,
                       app->exit_state.effect.busy, app->exit_state.effect.active_payload[0],
                       app->exit_state.effect.sequence_counter);
            }
            app->session_transition_reported = true;
        } else if (session_status != SCENE_SESSION_OK &&
                   session_status != SCENE_SESSION_BLOCKED &&
                   session_status != SCENE_SESSION_TRANSITION_PENDING) {
            app->failure = true;
            record(app, "scene_session_error status=%d", session_status);
            if (app->platform) blackmoor_macos_stop(app->platform);
            return;
        }
        if (session_result.media_succeeded != 0u &&
            session_result.tick_index != 0u &&
            session_result.tick_index != app->captions.composed_session_tick) {
            /* A frozen session returns its last result on later host updates.
             * Do not replay its completed media/composition side effects. */
            app->captions.composed_session_tick = session_result.tick_index;
            if (!native_caption_finish_tick(app, session_result.dispatch_attempted)) {
                app->failure = true;
                record(app, "scene_session_render_error scope=caption-Frame-decoded-background");
                if (app->platform) blackmoor_macos_stop(app->platform);
                return;
            }
            /* Render pass tail (0x4d00ae): the CSpecialEffect gate runs after
             * the layers are composed, only in state 3 (the exit tick that set
             * state 4 does not reach it in the original). */
            if (app->exit_state.g.game_state == SESSION_EXIT_STATE_RUN) {
                const SessionExitHost host = make_exit_host(app);
                SessionExitStepInfo info{};
                const int status = session_exit_render_pass(&app->exit_state, &host, &info);
                if (info.controller_ran != 0u || status != SESSION_EXIT_OK) {
                    record(app, "scene_exit_render_pass status=%d controller_ran=%u "
                           "stage_before=%u effect_busy=%u boundary=%d", status,
                           info.controller_ran, info.stage_before, app->exit_state.effect.busy,
                           (int)info.failed_boundary);
                }
                if (status != SESSION_EXIT_OK) {
                    app->failure = true;
                    if (app->platform) blackmoor_macos_stop(app->platform);
                    return;
                }
            }
        }
        if (app->platform && !blackmoor_macos_present(app->platform,
                app->framebuffer.data(), app->framebuffer.size(), 640 * 4)) {
            app->failure = true;
            blackmoor_macos_stop(app->platform);
            return;
        }
        if (app->platform && app->stop_after &&
            (uint32_t)(now - app->started) > app->stop_after)
            blackmoor_macos_stop(app->platform);
        return;
    }
    if (!advance_scene_video(app)) {
        app->failure = true;
        if (app->platform) blackmoor_macos_stop(app->platform);
        return;
    }
    StartupMenuInput input{};
    input.tick_ms = now;
    input.logical_x = app->pointer_x; input.logical_y = app->pointer_y;
    input.pointer_valid = app->pointer_x >= 0 && app->pointer_y >= 0;
    input.primary_down = app->primary_down;
    input.primary_pressed = app->primary_pressed;
    input.primary_released = app->primary_released;
    input.click_sound_complete = 1; // Menu click feedback is not yet connected to playback.
    app->primary_pressed = app->primary_released = false;
    StartupMenuFrame frame{};
    if (startup_menu_step(app->startup, &input, &frame) != STARTUP_MENU_OK ||
        !(app->has_scene_frame ? render_scene_preview(app) : render_startup(app, frame))) {
        app->failure = true;
        record(app, "startup_error step-or-render");
        if (app->platform) blackmoor_macos_stop(app->platform);
        return;
    }
    app->last_frame = frame;
    if (app->last_stage != frame.stage) {
        record(app, "stage=%d resource=%s", frame.stage, frame.resource_name);
        app->last_stage = frame.stage;
    }
    if (app->last_hover != frame.hovered_button) {
        record(app, "hover=%d pressed=%d", frame.hovered_button, frame.pressed_button);
        app->last_hover = frame.hovered_button;
    }
    if (frame.command_ready && !app->command_reported) {
        app->command_reported = true;
        record(app, "command_requested=%d", frame.requested_command);
        if (frame.requested_command == STARTUP_MENU_COMMAND_NEW_GAME) {
            if (!initialize_new_game(app, now) ||
                !clear_before_scene_entry(app, now) ||
                !load_scene(app, app->initial_scene) ||
                (app->scene_runtime_enabled && !create_native_scene_session(app))) {
                app->failure = true;
                record(app, "scene_setup_failed");
                if (app->platform) {
                    blackmoor_macos_set_title(app->platform, "Blackmoor reconstruction — scene load failed");
                    blackmoor_macos_stop(app->platform);
                }
                return;
            }
            if (app->platform) blackmoor_macos_set_title(app->platform,
                app->session ? "Blackmoor reconstruction — persistent scene session; providers incomplete"
                             : "Blackmoor reconstruction — scene preview; actions and audio incomplete");
        } else if (frame.requested_command == STARTUP_MENU_COMMAND_EXIT_GAME) {
            if (app->platform) blackmoor_macos_stop(app->platform);
        } else {
            record(app, "downstream_command_not_implemented=%d", frame.requested_command);
            if (app->platform) blackmoor_macos_set_title(app->platform,
                "Blackmoor reconstruction — requested screen not implemented");
        }
    }
    if (app->platform && !blackmoor_macos_present(app->platform, app->framebuffer.data(),
        app->framebuffer.size(), 640 * 4)) {
        app->failure = true; blackmoor_macos_stop(app->platform);
    }
    if (app->platform && app->stop_after && (uint32_t)(now - app->started) > app->stop_after)
        blackmoor_macos_stop(app->platform);
}

static void tick(void *context, uint32_t now)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    try { update(app, now); }
    catch (const std::exception &error) {
        app->failure = true; record(app, "host_error=%s", error.what());
        blackmoor_macos_stop(app->platform);
    }
}

#ifdef BLACKMOOR_NATIVE_APP_TEST_HOOKS
/* One synthetic accepted event for the first row with a published 0x62 request:
 * the scan and accept reducers run on the binding's own request/response table
 * with a coordinate at the middle of the published rectangle, then the
 * candidate store 0x43c054 is applied. The coordinates are not a pointer
 * transform; this stands in for the RT-2 path only to show the next stop. */
static void synthetic_a62_accept(NativeApp *app)
{
    if (!app->test_a62_accept || app->test_a62_accept_done || app->session == nullptr ||
        app->a62 == nullptr) return;
    const size_t rows = scene_resource_action_count(app->scene);
    for (size_t row = 0; row < rows; ++row) {
        ActionFamily62InteractionTarget target{};
        if (session_a62_get_target(app->a62, row, &target) != SESSION_A62_OK ||
            target.request_pending == 0u) continue;
        SessionA62ScanRequest request{};
        request.coordinate_a = ((int32_t)target.response_words[1] + target.response_words[3]) / 2;
        request.coordinate_b = ((int32_t)target.response_words[0] + target.response_words[2]) / 2;
        request.reserved_index_a = -1;
        request.reserved_index_b = -1;
        ActionFamily62InteractionScanResult scan{};
        ActionFamily62InteractionAcceptResult accept{};
        ActionFamily62InteractionAcceptInput accept_input{};
        accept_input.dependency_child_index = -1;
        if (session_a62_scan_candidate(app->a62, &request, &scan) != SESSION_A62_OK ||
            !scan.candidate_found) {
            record(app, "test_a62_synthetic_accept result=no-candidate row=%zu", row);
            app->test_a62_accept_done = true;
            return;
        }
        accept_input.candidate_action_index = scan.candidate_action_index;
        /* control word and suppression are caller-supplied zero: the row has no
         * dependency records and no suppression producer is bound. */
        if (action_family_62_interaction_accept(&accept_input, &accept) !=
                ACTION_FAMILY_62_INTERACTION_OK || !accept.phase2_requested ||
            scene_session_accept_action_candidate(app->session,
                (size_t)scan.candidate_action_index) != SCENE_SESSION_OK) {
            record(app, "test_a62_synthetic_accept result=rejected row=%zu", row);
            app->test_a62_accept_done = true;
            return;
        }
        record(app, "test_a62_synthetic_accept result=phase2 row=%d coordinates=%d,%d "
               "pointer_path=session_input(RT-6)", scan.candidate_action_index,
               request.coordinate_a, request.coordinate_b);
        app->test_a62_accept_done = true;
        return;
    }
}
#endif

struct InspectUIContext {
    NativeApp *app;
    ActionUIWorld *world;
};

static int inspect_ui_action(void *context, size_t action_index,
                             const SceneActionInfo *action,
                             const SceneActionRuntimeState *before,
                             SceneActionHandlerResult *result)
{
    InspectUIContext *inspection = static_cast<InspectUIContext *>(context);
    ActionUIActionResult effect{};
    const int status = action_ui_dispatch(inspection->world, action->type,
        action->subtype, action->typed_body, action->typed_body_length,
        before->phase, &effect);
    if (status != ACTION_UI_OK) {
        record(inspection->app, "action_ui_error index=%zu type=0x%02x detail=%s",
            action_index, action->type, action_ui_status_string(status));
        return status == ACTION_UI_ERR_UNSUPPORTED ? SCENE_ACTION_HANDLER_UNSUPPORTED
                                                  : SCENE_ACTION_HANDLER_ERROR;
    }
    result->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;
    result->phase = effect.phase;
    return SCENE_ACTION_HANDLER_OK;
}

/* Analysis entrypoint for the real parsed ACT table. This deliberately stops
 * at the first unavailable executor. Selected value/control resets are
 * recovered; remaining caller state is analysis-only and is never gameplay. */
/* --inspect-condition-providers: pins the app-side providers of the RT-4
 * binding (BSUM variable words, difficulty context, live-audio channel record,
 * timer thresholds through a real tree) as log lines for test_native_app. */
static bool inspect_condition_providers_fn(NativeApp *app)
{
    if (!create_native_conditions_binding(app)) return false;
    app->world_clock_session.world = &app->new_game.view;
    for (int16_t index : {5000, 5001, 5002, 5003, 5009, 5010}) {
        int16_t word = 0;
        const int ok = native_cond_variable_word(app, index, &word);
        record(app, "condition_provider variable_word index=%d available=%d value=%d bsum_offset=%d",
               index, ok, ok ? word : 0, 2 * index - 9618);
    }
    app->new_game.action_core.difficulty = 3;
    int16_t context = -1;
    const ConditionExtraHostStatus context_status = native_cond_context_58c94f(app, &context);
    record(app, "condition_provider context_58c94f status=%d value=%d", context_status, context);

    const SceneConditionExtension *extension = session_conditions_extension(app->conditions_binding);
    SceneConditionState state{};
    auto evaluate = [&](const SceneDependencyInfo &row, int *satisfied, SceneConditionFailure *failure) {
        SceneConditionTree *tree = nullptr;
        int status = scene_conditions_build(&row, 1u, &tree);
        if (status != SCENE_CONDITION_OK) return status;
        uint16_t unsupported = 0u;
        status = scene_conditions_evaluate_ex(tree, &state, extension, 0, satisfied, &unsupported, failure);
        scene_conditions_destroy(tree);
        return status;
    };
    auto record_row = [](uint16_t opcode, int16_t index, int16_t expected, int16_t seconds) {
        SceneDependencyInfo row{};
        row.opcode = opcode;
        row.fields[0] = static_cast<int16_t>(opcode);
        row.fields[1] = index;
        row.fields[2] = expected;
        row.fields[6] = seconds;
        return row;
    };
    uint8_t *timers = app->new_game.view.time_records_585d65;
    bool ok = timers != nullptr && app->new_game.view.time_records_size >= 2u * WORLD_INIT_TIME_RECORD_SIZE;
    if (ok) {
        const uint32_t cases[] = {120000u, 300000u, 300001u};
        for (uint32_t elapsed : cases) {
            uint8_t *record_bytes = timers + 1u * WORLD_INIT_TIME_RECORD_SIZE;
            record_bytes[0] = 1u; record_bytes[1] = record_bytes[2] = record_bytes[3] = 0u;
            for (int byte = 0; byte < 4; ++byte)
                record_bytes[4 + byte] = static_cast<uint8_t>(elapsed >> (8 * byte));
            for (uint16_t opcode : {13, 14}) {
                int satisfied = -1;
                SceneConditionFailure failure{};
                const int status = evaluate(record_row(opcode, 1, 1, 5000), &satisfied, &failure);
                record(app, "condition_provider timer op=%u variable=5000 elapsed=%u status=%d satisfied=%d",
                       opcode, elapsed, status, satisfied);
            }
        }
    }
    {
        int satisfied = -1;
        SceneConditionFailure failure{};
        const int status = evaluate(record_row(15, 0, 3, 0), &satisfied, &failure);
        record(app, "condition_provider op15 difficulty=3 status=%d satisfied=%d", status, satisfied);
        satisfied = -1;
        const int sound = evaluate(record_row(17, 4, 0, 0), &satisfied, &failure);
        SessionConditionsSoundManager manager{};
        session_conditions_get_sound_manager(app->conditions_binding, &manager);
        record(app, "condition_provider op17 channel=4 unloaded status=%d idle_gate=%d "
               "manager_error=0x%x loaded=0", sound, satisfied, manager.error_3c2);
        const int out_of_table = evaluate(record_row(17, 32, 0, 0), &satisfied, &failure);
        record(app, "condition_provider op17 channel=32 status=%d", out_of_table);
    }
    return ok;
}

static bool inspect_action_kernel(NativeApp *app)
{
    std::vector<int32_t> flags(4096, 0), inventory(70, 0);
    std::vector<int16_t> visits(10001, 0);
    ActionCoreWorld world{};
    world.event_flags = flags.data(); world.event_flag_count = flags.size();
    if (action_core_initialize_values(&world) != ACTION_CORE_OK) return false;
    record(app, "action_values_initial shorts=9999 floats=9999 seed=analysis-only");
    using PhoneRecord = uint8_t[ACTION_UI_PHONE_RECORD_SIZE];
    const size_t phone_capacity = scene_resource_action_count(app->scene);
    std::unique_ptr<PhoneRecord[]> phone_records(new PhoneRecord[phone_capacity]{});
    ActionUIWorld ui{};
    ui.phone_records = phone_records.get(); ui.phone_capacity = phone_capacity;
    if (action_ui_initialize_controls(&ui) != ACTION_UI_OK) return false;
    InspectUIContext inspection{app, &ui};
    const SceneActionHandler handlers[] = {
        {0x82, inspect_ui_action, &inspection}, {0x1d, inspect_ui_action, &inspection}
    };
    SceneConditionState conditions{};
    conditions.event_flags = flags.data(); conditions.event_flag_count = flags.size();
    conditions.inventory_presence = inventory.data(); conditions.inventory_count = inventory.size();
    conditions.selected_inventory_item = -1;
    conditions.scene_visit_counts = visits.data(); conditions.scene_visit_count = visits.size();
    SceneActionExecutor *executor = nullptr;
    size_t failed_index = SIZE_MAX;
    int status = scene_executor_create(app->scene, &world, 0, &executor, &failed_index);
    if (status != SCENE_EXECUTOR_OK) {
        record(app, "action_kernel_create status=%d index=%zu", status, failed_index);
        return false;
    }
    SceneExecutorStepInfo step{};
    status = scene_executor_step(executor, &conditions, handlers,
                                sizeof(handlers) / sizeof(handlers[0]), &step);
    record(app, "action_kernel status=%d failed_index=%zu failed_type=0x%02x actions_applied=%zu seed=analysis-only-partial-reset",
        status, step.failed_action_index, step.failed_action_type, step.actions_applied);
    record(app, "action_ui phone_contacts=%zu caller_phone_capacity=%zu nls_mode=0", ui.phone_count, ui.phone_capacity);
    for (size_t i = 0; i < ui.phone_count; ++i)
        record(app, "phone_contact index=%zu name=%.*s", i, (int)ACTION_UI_PHONE_NAME_SIZE,
               (const char *)ui.phone_records[i] + ACTION_UI_PHONE_NAME_OFFSET);
    for (unsigned i = 0; i < ACTION_UI_CONTROL_GROUP_COUNT; ++i)
        record(app, "control_group index=%u first_range=%d,%d code=%d availability=%d",
            i, ui.controls[i].starts[0], ui.controls[i].ends[0],
            ui.controls[i].codes[0], ui.controls[i].availability);
    scene_executor_destroy(executor);
    return status == SCENE_EXECUTOR_OK;
}

/* Render the actual scene sound through the native graph without an output
 * device. Unity gain here is diagnostic, not a recovered DirectSound volume. */
static bool inspect_audio_graph(NativeApp *app)
{
    SceneResourceSummary summary{};
    if (scene_resource_get_summary(app->scene, &summary) != SCENE_RESOURCE_OK) return false;
    if (std::strcmp(summary.audio, "NO SOUND") == 0) {
        record(app, "audio_graph scene_sound=NO SOUND"); return true;
    }
    const std::string wanted = std::string(summary.audio) + ".his";
    if (wanted.size() > 37 || wanted.find_first_of("/\\") != std::string::npos) return false;
    const std::string directory_path = app->game_directory + "/CDSound";
    DIR *directory = opendir(directory_path.c_str());
    if (!directory) return false;
    std::string path;
    unsigned matches = 0;
    while (dirent *entry = readdir(directory)) {
        const std::string candidate = entry->d_name;
        if (candidate.size() != wanted.size()) continue;
        bool equal = true;
        for (size_t i = 0; i < wanted.size(); ++i) {
            unsigned char a = (unsigned char)candidate[i], b = (unsigned char)wanted[i];
            if (a >= 'a' && a <= 'z') a -= 'a' - 'A';
            if (b >= 'a' && b <= 'z') b -= 'a' - 'A';
            if (a != b) { equal = false; break; }
        }
        if (equal) { ++matches; path = directory_path + "/" + candidate; }
    }
    closedir(directory);
    if (matches != 1) { record(app, "audio_graph missing-or-ambiguous=%s", wanted.c_str()); return false; }
    char error[512] = {};
    HisAudio audio = HIS_AUDIO_INIT;
    if (his_audio_decode_file(path.c_str(), &audio, error, sizeof(error)) != HIS_AUDIO_OK) {
        record(app, "audio_decode_error=%s", error); return false;
    }
    record(app, "audio_decoded name=%s rate=%u channels=%u frames=%llu original_decoder_equivalence=unverified",
        summary.audio, audio.sample_rate, audio.channels, (unsigned long long)audio.frame_count);
    MacAudioHost *host = nullptr;
    MacAudioRender rendered = MAC_AUDIO_RENDER_INIT;
    int status = mac_audio_host_open(MAC_AUDIO_MODE_OFFLINE, audio.sample_rate, 2,
                                    &host, error, sizeof(error));
    if (status == MAC_AUDIO_OK)
        status = mac_audio_play(host, 0, audio.interleaved_pcm, audio.frame_count,
            audio.channels, audio.sample_rate, 1.0f, 0, error, sizeof(error));
    if (status == MAC_AUDIO_OK)
        status = mac_audio_host_render_offline(host, 4096, &rendered, error, sizeof(error));
    if (status == MAC_AUDIO_OK) {
        double squares = 0;
        bool finite = true;
        const size_t samples = (size_t)rendered.frame_count * rendered.channels;
        for (size_t i = 0; i < samples; ++i) {
            finite = finite && std::isfinite(rendered.interleaved_pcm[i]);
            squares += (double)rendered.interleaved_pcm[i] * rendered.interleaved_pcm[i];
        }
        record(app, "audio_graph rendered_frames=%llu channels=%u rms=%.8f finite=%d mode=offline gain=diagnostic-unity",
            (unsigned long long)rendered.frame_count, rendered.channels,
            samples ? std::sqrt(squares / samples) : 0, finite);
        if (!finite) status = MAC_AUDIO_ERR_FORMAT;
    } else record(app, "audio_graph_error status=%d detail=%s", status, error);
    mac_audio_render_destroy(&rendered);
    if (host && mac_audio_host_close(host, error, sizeof(error)) != MAC_AUDIO_OK) status = MAC_AUDIO_ERR_ENGINE;
    his_audio_destroy(&audio);
    return status == MAC_AUDIO_OK;
}

int main(int argc, char **argv)
{
    @autoreleasepool {
        NativeApp app;
        (void)session_input_init(&app.input_state);
        app.game_directory = default_game_directory;
        std::string log_path;
        bool inspect_only = false;
        bool inspect_actions = false;
        bool inspect_audio = false;
        bool inspect_scene_runtime = false;
        bool inspect_session_boundary = false;
        bool inspect_live_session = false;
        bool inspect_condition_providers = false;
        uint32_t live_ticks = 600, live_tick_ms = 85;
        bool live_tick_ms_set = false;
        long live_click_row = -1;
        bool live_click_blocked = false;
        bool live_double_click = false, live_hover_only = false;
        long live_scene = -1, live_scene_row = -1;
        /* RT-15: --live-scene-row may repeat; each pair applies in its own scene. */
        std::vector<std::pair<long, long>> live_scene_rows;
        /* RT-17: --live-nav SCENE:left|right[:COUNT] hovers the pointer on that edge
         * band of SCENE until the selector has moved COUNT times (default 1), then
         * leaves the band; the row gesture waits for it. */
        struct LiveNav {
            long scene; bool left; long remaining; bool started; int16_t last_selector;
            bool click; bool clicked;   /* optional ":click": press and release once inside the band */
        };
        std::vector<LiveNav> live_navs;
        long dump_scene = -1;
        for (int i = 1; i < argc; ++i) {
            const std::string argument = argv[i];
            if (argument == "--live-double-click") { live_double_click = true; continue; }
            if (argument == "--live-hover-only") { live_hover_only = true; continue; }
            /* RT-13: after the session blocks, deliver ordinary clicks at the last
             * pointer position (what a player does at a frozen window) so the
             * "input ignored" report can be checked headlessly. */
            if (argument == "--live-click-blocked") { live_click_blocked = true; continue; }
            if (argument == "--inspect-startup") { inspect_only = true; continue; }
            if (argument == "--inspect-actions") { inspect_only = inspect_actions = true; continue; }
            if (argument == "--inspect-audio") { inspect_only = inspect_audio = true; continue; }
            if (argument == "--inspect-scene-runtime") { inspect_only = inspect_scene_runtime = true; continue; }
            if (argument == "--inspect-session-boundary") { inspect_only = inspect_session_boundary = true; continue; }
            if (argument == "--inspect-live-session") { inspect_only = inspect_live_session = true; continue; }
            if (argument == "--inspect-condition-providers") { inspect_only = inspect_condition_providers = true; continue; }
#ifdef BLACKMOOR_NATIVE_APP_TEST_HOOKS
            if (argument == "--test-a62-accept") {
                app.test_a62_accept = true;
                continue;
            }
            if (argument == "--test-members-busy") {
                app.test_members_busy = true;
                continue;
            }
            if (argument == "--test-a0c-refuse-world") {
                app.test_a0c_refuse_world = true;
                continue;
            }
            if (argument == "--test-caption-reset-after-compose") {
                app.captions.test_reset_after_composition = true;
                continue;
            }
            if (argument == "--test-caption-reseed-visible") {
                app.captions.test_reseed_visible_caption = true;
                continue;
            }
            if (argument == "--test-caption-fail-blit") {
                if (i + 1 == argc) { std::fprintf(stderr, "Missing argument value\n"); return 2; }
                char *end = nullptr;
                const unsigned long index = std::strtoul(argv[++i], &end, 10);
                if (!*argv[i] || *end || index == 0u || index > UINT32_MAX) return 2;
                app.captions.test_fail_blit_index = (uint32_t)index;
                continue;
            }
#endif
            if (i + 1 == argc) { std::fprintf(stderr, "Missing argument value\n"); return 2; }
            const char *value = argv[++i];
            if (argument == "--dump-scene-actions") {
                char *end = nullptr;
                dump_scene = std::strtol(value, &end, 10);
                if (!*value || *end || dump_scene < 0) return 2;
                inspect_only = true;
            } else if (argument == "--live-scene-row") {
                /* SCENE:ROW. In that scene the scripted gesture targets ROW
                 * (an executor hotspot or a 0x62 request row) instead of
                 * --live-click-row. */
                char *end = nullptr;
                live_scene = std::strtol(value, &end, 10);
                if (!*value || *end != ':' || live_scene < 0) return 2;
                live_scene_row = std::strtol(end + 1, &end, 10);
                if (*end || live_scene_row < 0) return 2;
                live_scene_rows.emplace_back(live_scene, live_scene_row);
            } else if (argument == "--live-pick-item") {
                /* RT-22: SCENE:ITEM. In that scene, once it has settled for a few ticks, the
                 * script opens the inventory view (stand-in for the taskbar button), moves the
                 * pointer onto the slot holding ITEM and left-clicks it. May repeat. */
                char *end = nullptr;
                const long pick_scene = std::strtol(value, &end, 10);
                if (!*value || *end != ':' || pick_scene < 0 || pick_scene > INT32_MAX) return 2;
                const long pick_item = std::strtol(end + 1, &end, 10);
                if (*end || pick_item < 0 || pick_item >= (long)INVVIEW_ITEMS) return 2;
                app.live_pick_items.emplace_back((int32_t)pick_scene, (int32_t)pick_item);
            } else if (argument == "--live-click-at") {
                /* RT-22 follow-up: SCENE:X,Y. In that scene, once it has settled, the script
                 * moves the pointer to the window point (X, Y), presses and releases the left
                 * button through the app's real pointer path (the task bar, then the scene).
                 * May repeat. */
                char *end = nullptr;
                const long click_scene = std::strtol(value, &end, 10);
                if (!*value || *end != ':' || click_scene < 0 || click_scene > INT32_MAX) return 2;
                const long click_x = std::strtol(end + 1, &end, 10);
                if (*end != ',' || click_x < 0 || click_x > 639) return 2;
                const long click_y = std::strtol(end + 1, &end, 10);
                if (*end || click_y < 0 || click_y > 479) return 2;
                app.live_click_ats.push_back({(int32_t)click_scene, (int32_t)click_x,
                                              (int32_t)click_y});
            } else if (argument == "--live-nav") {
                char *end = nullptr;
                const long nav_scene = std::strtol(value, &end, 10);
                if (!*value || *end != ':' || nav_scene < 0) return 2;
                const std::string rest = end + 1;
                const size_t colon = rest.find(':');
                const std::string side = rest.substr(0, colon);
                long nav_count = 1;
                bool nav_click = false;
                if (colon != std::string::npos) {
                    const size_t second = rest.find(':', colon + 1);
                    const std::string count_text = rest.substr(colon + 1, second == std::string::npos
                                                                              ? std::string::npos
                                                                              : second - colon - 1);
                    char *count_end = nullptr;
                    nav_count = std::strtol(count_text.c_str(), &count_end, 10);
                    if (count_text.empty() || *count_end || nav_count < 1 || nav_count > 100) return 2;
                    if (second != std::string::npos) {
                        if (rest.substr(second + 1) != "click") return 2;
                        nav_click = true;
                    }
                }
                if (side != "left" && side != "right") return 2;
                live_navs.push_back({nav_scene, side == "left", nav_count, false, 0, nav_click, false});
            } else if (argument == "--live-click-row") {
                char *end = nullptr;
                live_click_row = std::strtol(value, &end, 10);
                if (!*value || *end || live_click_row < 0) return 2;
#ifdef BLACKMOOR_NATIVE_APP_TEST_HOOKS
            } else if (argument == "--test-inventory" || argument == "--test-held") {
                if (argument == "--test-held") {
                    char *end = nullptr;
                    const long held = std::strtol(value, &end, 10);
                    if (!*value || *end || held < -1 || held > 32767) return 2;
                    app.test_held = (int)held;
                } else {
                    std::string list = value;
                    size_t position = 0;
                    while (position < list.size()) {
                        char *end = nullptr;
                        const long item = std::strtol(list.c_str() + position, &end, 10);
                        if (end == list.c_str() + position || item < 0 || item > 32767) return 2;
                        app.test_inventory.push_back(static_cast<int16_t>(item));
                        position = static_cast<size_t>(end - list.c_str());
                        if (position < list.size()) {
                            if (list[position] != ',') return 2;
                            ++position;
                        }
                    }
                }
            } else if (argument == "--test-selector") {
                char *end = nullptr;
                const long scene = std::strtol(value, &end, 10);
                if (!*value || end == value || *end != ':' || scene < 0 || scene > INT16_MAX) return 2;
                const char *frame_text = end + 1;
                const long frame = std::strtol(frame_text, &end, 10);
                if (end == frame_text || *end || frame < INT16_MIN || frame > INT16_MAX) return 2;
                app.test_selectors.emplace_back((int32_t)scene, (int32_t)frame);
            } else if (argument == "--test-held-at") {
                char *end = nullptr;
                const long scene = std::strtol(value, &end, 10);
                if (!*value || end == value || *end != ':' || scene < 0 || scene > INT16_MAX) return 2;
                const char *item_text = end + 1;
                const long item = std::strtol(item_text, &end, 10);
                if (end == item_text || *end || item < -1 || item > 32767) return 2;
                app.test_held_at.emplace_back((int32_t)scene, (int32_t)item);
            } else if (argument == "--test-exit-redirect") {
                char *end = nullptr;
                const long from = std::strtol(value, &end, 10);
                if (!*value || *end != ':' || from < 0 || from > INT16_MAX) return 2;
                const long scene = std::strtol(end + 1, &end, 10);
                if (*end || scene < 0 || scene > INT16_MAX) return 2;
                app.test_exit_redirect_from = (int32_t)from;
                app.test_exit_redirect = (int32_t)scene;
#endif
            } else if (argument == "--rand-seed") {
                char *end = nullptr;
                const unsigned long long seed = std::strtoull(value, &end, 10);
                if (!*value || *end || seed > UINT32_MAX) return 2;
                app.condition_rand_seed = static_cast<uint32_t>(seed);
                app.condition_rand_seed_set = true;
            } else if (argument == "--live-tick-ms") {
                char *end = nullptr;
                const unsigned long duration = std::strtoul(value, &end, 10);
                if (!*value || *end || duration == 0 || duration > 1000) return 2;
                live_tick_ms = (uint32_t)duration;
                live_tick_ms_set = true;
            } else if (argument == "--live-ticks") {
                char *end = nullptr;
                const unsigned long count = std::strtoul(value, &end, 10);
                if (!*value || *end || count == 0 || count > 1000000) return 2;
                live_ticks = (uint32_t)count;
            } else if (argument == "--game-dir") app.game_directory = value;
            else if (argument == "--log") log_path = value;
            else if (argument == "--stop-after-ms") {
                char *end = nullptr;
                const unsigned long duration = std::strtoul(value, &end, 10);
                if (!*value || *end || duration == 0 || duration > 3600000) return 2;
                app.stop_after = (uint32_t)duration;
            } else { std::fprintf(stderr, "Unknown option: %s\n", argument.c_str()); return 2; }
        }
#ifdef BLACKMOOR_NATIVE_APP_TEST_HOOKS
        if (app.test_a62_accept && !inspect_live_session) {
            std::fprintf(stderr, "--test-a62-accept requires --inspect-live-session\n");
            return 2;
        }
        if ((app.captions.test_fail_blit_index != 0u ||
             app.captions.test_reset_after_composition ||
             app.captions.test_reseed_visible_caption) && !inspect_session_boundary) {
            std::fprintf(stderr, "Caption test hooks require --inspect-session-boundary\n");
            return 2;
        }
        if ((app.captions.test_reset_after_composition &&
             app.captions.test_reseed_visible_caption) ||
            (app.captions.test_fail_blit_index != 0u &&
             (app.captions.test_reset_after_composition ||
              app.captions.test_reseed_visible_caption))) {
            std::fprintf(stderr, "Caption test probes must run separately\n");
            return 2;
        }
#endif
        if (live_tick_ms_set && !inspect_live_session) {
            std::fprintf(stderr, "--live-tick-ms requires --inspect-live-session\n");
            return 2;
        }
        app.scene_runtime_enabled = !inspect_only || inspect_session_boundary || inspect_live_session ||
                                    inspect_condition_providers;
        if (log_path.empty()) {
            NSString *directory = NSTemporaryDirectory();
            std::string pattern = std::string(directory.fileSystemRepresentation) + "blackmoor-startup-XXXXXX";
            std::vector<char> path(pattern.begin(), pattern.end()); path.push_back('\0');
            const int descriptor = mkstemp(path.data());
            if (descriptor < 0) return 3;
            app.log = fdopen(descriptor, "w");
            if (!app.log) { close(descriptor); return 3; }
            log_path = path.data();
        } else app.log = std::fopen(log_path.c_str(), "wx");
        if (!app.log) return 3;
        NSLog(@"Blackmoor reconstruction log: %s", log_path.c_str());
        int external = 0;
        char error[256] = {};
        GameResourceBytes boot_bytes = GAME_RESOURCE_BYTES_INIT;
        int result = 1;
        try {
            if (!game_ini_configuration(app.game_directory, &external,
                                        &app.closed_captioning))
                throw std::runtime_error("Cannot read original game configuration");
            record(&app, "external_cif_checking=%d closed_captioning=%u "
                   "gameplay_audio=absent engine=incomplete",
                   external, app.closed_captioning);
            app.resources = game_resources_open((app.game_directory + "/Ciftree").c_str(), external, error, sizeof(error));
            if (!app.resources) throw std::runtime_error(error);
            if (!game_resources_load_bytes(app.resources, "BOOT", &boot_bytes, error, sizeof(error)))
                throw std::runtime_error(error);
            record(&app, "BOOT bytes=%zu source=%s", boot_bytes.length,
                boot_bytes.source == GAME_RESOURCE_EXTERNAL_CIF ? "external-CIF" : "CIFTREE");
            app.boot = engine_boot_open_memory(boot_bytes.bytes, boot_bytes.length, error, sizeof(error));
            game_resource_bytes_destroy(&boot_bytes);
            if (!app.boot) throw std::runtime_error(error);
            EngineBootSummary summary{};
            if (engine_boot_get_summary(app.boot, &summary) != ENGINE_BOOT_OK)
                throw std::runtime_error("BOOT summary unavailable");
            app.initial_scene = summary.initial_scene;
            if (world_init_cold_zero_event_flags(&app.new_game.action_core) != WORLD_INIT_OK)
                throw std::runtime_error("Cannot initialize bounded cold event-flag view");
            if (!load_viewport(&app)) throw std::runtime_error("BOOT VIEW configuration unavailable");
            if (!initialize_caption_runtime(&app))
                throw std::runtime_error("Original caption BOOT resources or RGB555 surfaces unavailable");
            if (app.scene_runtime_enabled) {
                LiveAudioConfig audio_config{};
                audio_config.game_directory = app.game_directory.c_str();
                audio_config.mode = inspect_only ? MAC_AUDIO_MODE_OFFLINE : MAC_AUDIO_MODE_OUTPUT;
                audio_config.log = [](void *context, const char *message) {
                    record(static_cast<NativeApp *>(context), "%s", message);
                };
                audio_config.log_context = &app;
                if (live_audio_create(&audio_config, &app.live_audio, error, sizeof(error)) != LIVE_AUDIO_OK)
                    throw std::runtime_error(error);
                if (inspect_only) app.offline_audio_frames_per_update = live_tick_ms_set
                    ? live_tick_ms * (LIVE_AUDIO_DEFAULT_OFFLINE_SAMPLE_RATE / 1000u) : 4096u;
            }
            StartupMenuConfig config{};
            config.disabled_button_mask = (1u << 3) | (1u << 4); // Fresh session, no save restoration implemented.
            config.click_feedback_ms = 0;
            app.started = blackmoor_macos_monotonic_ms();
            app.startup = startup_menu_create(app.boot, &config, app.started, error, sizeof(error));
            if (!app.startup) throw std::runtime_error(error);
            app.framebuffer.resize(640 * 480 * 4);
            if (inspect_only) {
                update(&app, app.started);
                update(&app, app.started + 4001);
                update(&app, app.started + 8002);
                if (app.last_frame.stage != STARTUP_MENU_MAIN_MENU || app.last_frame.button_count < 2)
                    throw std::runtime_error("Headless startup did not reach the original menu");
                const StartupMenuRect rectangle = app.last_frame.buttons[1].hit_rect;
                app.pointer_x = (int32_t)(((int64_t)rectangle.left + rectangle.right) / 2);
                app.pointer_y = (int32_t)(((int64_t)rectangle.top + rectangle.bottom) / 2);
                record(&app, "headless_input=NewGame x=%d y=%d", app.pointer_x, app.pointer_y);
                update(&app, app.started + 8003);
                app.primary_down = app.primary_pressed = true;
                update(&app, app.started + 8004);
                app.primary_down = false; app.primary_released = true;
                update(&app, app.started + 8005);
                if (!app.scene || app.last_frame.requested_command != STARTUP_MENU_COMMAND_NEW_GAME)
                    throw std::runtime_error("Headless New Game did not load the original initial scene");
                if (inspect_session_boundary) {
                    if (!app.session) throw std::runtime_error("Persistent scene session was not created");
                    update(&app, app.started + 8006);
                    update(&app, app.started + 8007);
                    SceneSessionTickResult session_result{};
                    if (scene_session_get_last_result(app.session, &session_result) != SCENE_SESSION_OK)
                        throw std::runtime_error("Persistent scene session result unavailable");
                    record(&app, "scene_session_probe status=%d provider=%s tick_index=%llu "
                           "tick_count=%llu generation=%llu media_attempted=%u dispatch_attempted=%u "
                           "same_path=app-update",
                           session_result.status,
                           scene_session_provider_string(session_result.failure.provider),
                           (unsigned long long)session_result.tick_index,
                           (unsigned long long)scene_session_tick_count(app.session),
                           (unsigned long long)scene_session_scene_generation(app.session),
                           session_result.media_attempted, session_result.dispatch_attempted);
                    /* Tick 1 applies rows 0-30 and starts the row-31 sound;
                     * tick 2 polls it while it plays: no block, no transition. */
#ifdef BLACKMOOR_NATIVE_APP_TEST_HOOKS
                    const bool injected_caption_failure =
                        app.captions.test_fail_blit_index != 0u &&
                        session_result.status == SCENE_SESSION_BLOCKED &&
                        session_result.failure.provider == SCENE_SESSION_PROVIDER_CAPTION;
#else
                    const bool injected_caption_failure = false;
#endif
                    if ((session_result.status != SCENE_SESSION_OK && !injected_caption_failure) ||
                        scene_session_tick_count(app.session) != 2u ||
                        (!injected_caption_failure &&
                         (session_result.media_attempted != 1u ||
                          session_result.dispatch_attempted != 1u))) {
                        app.failure = true;
                    }
                }
                if (inspect_live_session) {
                    if (!app.session) throw std::runtime_error("Persistent scene session was not created");
                    /* Inspection-only cadence control. Explicit tick lengths
                     * advance both the session and offline mixer by that duration;
                     * default retains the historical 85ms/4096-frame probe. */
                    record(&app, "live_session_cadence tick_ms=%u audio_frames_per_tick=%u",
                           live_tick_ms, app.offline_audio_frames_per_update);
                    uint32_t clock = app.started + 8006u;
                    int scripted_clicks = 0;
                    uint32_t clicked_at = 0;
                    int16_t last_scene = app.current_scene_id;
                    uint32_t stalled = 0;
                    uint32_t scene_ticks = 0;
                    uint64_t last_progress_tick = 0;
                    for (uint32_t step = 0; step < live_ticks && !app.failure; ++step) {
                        clock += live_tick_ms;
                        update(&app, clock);
#ifdef BLACKMOOR_NATIVE_APP_TEST_HOOKS
                        synthetic_a62_accept(&app);
#endif
                        if (app.current_scene_id != last_scene) {
                            record(&app, "live_session_scene_changed from=%d to=%d step=%u",
                                   last_scene, app.current_scene_id, step);
                            last_scene = app.current_scene_id;
                            scripted_clicks = 0;
                            stalled = 0;
                            scene_ticks = 0;
                        }
                        SceneSessionTickResult tick{};
                        if (scene_session_get_last_result(app.session, &tick) == SCENE_SESSION_OK &&
                            tick.status == SCENE_SESSION_BLOCKED) {
                            ++stalled;
                            if (live_click_blocked && (stalled == 2u || stalled == 3u)) {
                                pointer(&app, BLACKMOOR_POINTER_DOWN, app.pointer_x, app.pointer_y, 0);
                                clock += live_tick_ms; update(&app, clock);
                                pointer(&app, BLACKMOOR_POINTER_UP, app.pointer_x, app.pointer_y, 0);
                                clock += live_tick_ms; update(&app, clock);
                                record(&app, "live_session_click_while_blocked pointer=%d,%d",
                                       app.pointer_x, app.pointer_y);
                            }
                            if (stalled > 3u) break;
                        } else stalled = 0;
                        (void)last_progress_tick;
                        /* RT-22: scripted inventory pick (open, hover, click). Two ticks apart so
                         * each message is processed by its own tick. */
                        ++scene_ticks;
                        for (auto it = app.live_click_ats.begin(); it != app.live_click_ats.end(); ++it) {
                            if (it->scene != app.current_scene_id) continue;
                            if (scene_ticks == 12u) {
                                pointer(&app, BLACKMOOR_POINTER_MOVE, it->x, it->y, 0);
                                record(&app, "live_click_at_move scene=%d pointer=%d,%d",
                                       app.current_scene_id, it->x, it->y);
                            } else if (scene_ticks == 14u) {
                                pointer(&app, BLACKMOOR_POINTER_DOWN, it->x, it->y, 0);
                                record(&app, "live_click_at_down scene=%d pointer=%d,%d",
                                       app.current_scene_id, it->x, it->y);
                            } else if (scene_ticks == 15u) {
                                pointer(&app, BLACKMOOR_POINTER_UP, it->x, it->y, 0);
                                record(&app, "live_click_at_up scene=%d pointer=%d,%d",
                                       app.current_scene_id, it->x, it->y);
                                app.live_click_ats.erase(it);
                            }
                            break;
                        }
                        {
                            bool pick_active = false;
                            for (auto it = app.live_pick_items.begin(); it != app.live_pick_items.end(); ++it) {
                                if (it->first != app.current_scene_id) continue;
                                pick_active = true;
                                if (scene_ticks == 20u) {
                                    /* A view already opened by the task bar button (real click
                                     * path, --live-click-at) is used as it is. */
                                    if (app.inv_view.screen_state != INVVIEW_STATE_INVENTORY &&
                                        !inventory_view_open_request(&app, "scripted --live-pick-item"))
                                        app.live_pick_items.erase(it);
                                } else if (scene_ticks == 22u) {
                                    int slot = -1;
                                    for (int i = 0; i < (int)INVVIEW_SLOTS; ++i)
                                        if (app.inv_view.slot_item[i] == it->second) { slot = i; break; }
                                    if (slot < 0 || app.inv_view.screen_state != INVVIEW_STATE_INVENTORY) {
                                        record(&app, "live_pick_item_missing scene=%d item=%d slot=%d state=%d",
                                               app.current_scene_id, it->second, slot,
                                               app.inv_view.screen_state);
                                    } else {
                                        const int32_t cx = (app.inv_layout.rect[slot][0] + app.inv_layout.rect[slot][2]) / 2 - 9;
                                        const int32_t cy = (app.inv_layout.rect[slot][1] + app.inv_layout.rect[slot][3]) / 2 - 9;
                                        pointer(&app, BLACKMOOR_POINTER_MOVE, cx, cy, 0);
                                        record(&app, "live_pick_item_hover scene=%d item=%d slot=%d pointer=%d,%d",
                                               app.current_scene_id, it->second, slot, cx, cy);
                                    }
                                } else if (scene_ticks == 24u) {
                                    if (app.inv_view.screen_state == INVVIEW_STATE_INVENTORY) {
                                        pointer(&app, BLACKMOOR_POINTER_DOWN, app.pointer_x, app.pointer_y, 0);
                                        pointer(&app, BLACKMOOR_POINTER_UP, app.pointer_x, app.pointer_y, 0);
                                        record(&app, "live_pick_item_click scene=%d item=%d held=%d",
                                               app.current_scene_id, it->second,
                                               (int)*app.new_game.view.inventory.selected_item_candidate);
                                    }
                                    app.live_pick_items.erase(it);
                                }
                                break;
                            }
                            (void)pick_active;
                        }
                        /* RT-17: scripted edge hover. The selector is moved by the recovered
                         * navigation block (nav_step in the log), never set directly. */
                        bool nav_pending = false;
                        for (LiveNav &nv : live_navs) {
                            if (nv.scene != app.current_scene_id || nv.remaining <= 0 ||
                                !app.nav_scene_ready) continue;
                            nav_pending = true;
                            if (!nv.started) {
                                nv.started = true;
                                nv.last_selector = app.nav.selector;
                                const int32_t hover_x = nv.left ? app.scene_destination.left + 2
                                                                : app.scene_destination.right - 2;
                                const int32_t hover_y = (app.scene_destination.top +
                                                         app.scene_destination.bottom) / 2;
                                pointer(&app, BLACKMOOR_POINTER_MOVE, hover_x, hover_y, 0);
                                record(&app, "live_session_nav_hover scene=%d side=%s window=%d,%d "
                                       "selector=%d remaining=%ld", app.current_scene_id,
                                       nv.left ? "left" : "right", app.pointer_x, app.pointer_y,
                                       app.nav.selector, nv.remaining);
                            } else if (nv.click && !nv.clicked && app.nav.state != 0) {
                                /* One press/release inside the band, issued after the tick that set
                                 * the zone state and before the step is due: the consuming tick
                                 * must not step (0x43b19e skips the navigation block). */
                                nv.clicked = true;
                                pointer(&app, BLACKMOOR_POINTER_DOWN, app.pointer_x, app.pointer_y, 0);
                                pointer(&app, BLACKMOOR_POINTER_UP, app.pointer_x, app.pointer_y, 0);
                                record(&app, "live_session_nav_click scene=%d state=%d selector=%d",
                                       app.current_scene_id, app.nav.state, app.nav.selector);
                            } else if (app.nav.selector != nv.last_selector) {
                                nv.last_selector = app.nav.selector;
                                --nv.remaining;
                                record(&app, "live_session_nav_moved scene=%d selector=%d remaining=%ld",
                                       app.current_scene_id, app.nav.selector, nv.remaining);
                                if (nv.remaining == 0) {
                                    pointer(&app, BLACKMOOR_POINTER_MOVE,
                                            (app.scene_destination.left + app.scene_destination.right) / 2,
                                            (app.scene_destination.top + app.scene_destination.bottom) / 2, 0);
                                    record(&app, "live_session_nav_done scene=%d selector=%d window=%d,%d",
                                           app.current_scene_id, app.nav.selector, app.pointer_x,
                                           app.pointer_y);
                                    nav_pending = false;
                                }
                            }
                            break;
                        }
                        if (nav_pending) continue;
                        if (scripted_clicks == 0 || (scripted_clicks == 1 && clock - clicked_at > 255u)) {
                            const size_t actions = scene_resource_action_count(app.scene);
                            long scene_row = -1;
                            bool scene_listed = false;
                            for (const auto &pair : live_scene_rows)
                                if (pair.first == app.current_scene_id) {
                                    scene_row = pair.second; scene_listed = true;
                                }
                            const long wanted = scene_listed ? scene_row : live_click_row;
                            if (!live_scene_rows.empty() && live_click_row < 0 && !scene_listed) continue;
                            for (size_t row = 0; row < actions; ++row) {
                                /* Executor hotspot, else a pending 0x62 request row. */
                                int32_t left = 0, top = 0, right = 0, bottom = 0;
                                bool found = false;
                                SceneExecutorHotspotState hotspot{};
                                ActionFamily62InteractionTarget target{};
                                SessionInputHotspot a17_row{};
                                SessionInputHotspot a0b_row{};
                                SessionInputHotspot a0c_row{};
                                if (scene_session_get_hotspot_state(app.session, row, &hotspot) ==
                                        SCENE_EXECUTOR_OK && hotspot.active && hotspot.rectangle_valid) {
                                    left = hotspot.left; top = hotspot.top;
                                    right = hotspot.right; bottom = hotspot.bottom; found = true;
                                } else if (session_a17_pointer_row(app.a17, row, &a17_row) == 1) {
                                    /* RT-15: multiframe scene hotspot of the current frame. */
                                    left = a17_row.rectangle.left; top = a17_row.rectangle.top;
                                    right = a17_row.rectangle.right; bottom = a17_row.rectangle.bottom;
                                    found = true;
                                } else if (session_a0b_pointer_row(app.a0b, row, &a0b_row) == 1) {
                                    /* RT-16: raw 0x0b scene-change hotspot. */
                                    left = a0b_row.rectangle.left; top = a0b_row.rectangle.top;
                                    right = a0b_row.rectangle.right; bottom = a0b_row.rectangle.bottom;
                                    found = true;
                                } else if (session_a0c_pointer_row(app.a0c, row, &a0c_row) == 1) {
                                    /* RT-20: raw 0x0c multi-frame scene-change hotspot. */
                                    left = a0c_row.rectangle.left; top = a0c_row.rectangle.top;
                                    right = a0c_row.rectangle.right; bottom = a0c_row.rectangle.bottom;
                                    found = true;
                                } else if (session_a62_get_target(app.a62, row, &target) == SESSION_A62_OK &&
                                           target.request_pending != 0u) {
                                    left = target.response_words[0]; top = target.response_words[1];
                                    right = target.response_words[2]; bottom = target.response_words[3];
                                    found = true;
                                } else if (app.a36 != nullptr && session_a36_registered(app.a36) != 0u) {
                                    /* RT-14: a hot record of a registered raw 0x36 overlay. */
                                    std::vector<SessionInputHotspot> overlay_rows(OVERLAY36_LIST_LIMIT * 25u);
                                    size_t overlay_count = 0u;
                                    if (session_a36_priority_rows(app.a36, overlay_rows.data(),
                                            overlay_rows.size(), &overlay_count) == OVERLAY36_OK)
                                        for (size_t i = 0; i < overlay_count; ++i)
                                            if (overlay_rows[i].index == static_cast<int32_t>(row)) {
                                                left = overlay_rows[i].rectangle.left;
                                                top = overlay_rows[i].rectangle.top;
                                                right = overlay_rows[i].rectangle.right;
                                                bottom = overlay_rows[i].rectangle.bottom;
                                                found = true;
                                                break;
                                            }
                                }
                                if (!found) continue;
                                if (wanted >= 0 && (long)row != wanted) continue;
                                if (scripted_clicks == 0) {
                                    /* Window point whose provisional transform lands mid-rectangle. */
                                    const int32_t window_x = (left + right) / 2 + app.scene_destination.left;
                                    const int32_t window_y = (top + bottom) / 2 + app.scene_destination.top;
                                    pointer(&app, BLACKMOOR_POINTER_MOVE, window_x, window_y, 0);
                                    record(&app, "live_session_hover row=%zu rect=%d,%d,%d,%d window=%d,%d",
                                           row, left, top, right, bottom, app.pointer_x, app.pointer_y);
                                    scripted_clicks = 1; clicked_at = clock;
                                } else if (live_hover_only && (live_scene_rows.empty() || scene_listed)) {
                                    scripted_clicks = 2;
                                } else {
                                    pointer(&app, BLACKMOOR_POINTER_DOWN, app.pointer_x, app.pointer_y, 0);
                                    clock += live_tick_ms; update(&app, clock);
                                    pointer(&app, BLACKMOOR_POINTER_UP, app.pointer_x, app.pointer_y, 0);
                                    clock += live_tick_ms; update(&app, clock);
                                    record(&app, "live_session_click row=%zu", row);
                                    if (live_double_click) {
                                        /* Windows delivers DBLCLK instead of the second DOWN:
                                         * DOWN, UP, tick, DBLCLK, UP, tick. The second release must
                                         * not activate again. */
                                        SceneSessionPointerResult first{};
                                        if (app.session != nullptr)
                                            scene_session_get_pointer_result(app.session, &first);
                                        pointer(&app, static_cast<BlackmoorPointerKind>(kPointerDoubleClick),
                                                app.pointer_x, app.pointer_y, 0);
                                        pointer(&app, BLACKMOOR_POINTER_UP, app.pointer_x, app.pointer_y, 0);
                                        const unsigned edge_after_second_up = app.input_state.latch[0];
                                        const int32_t candidate_at_second_up = app.input_state.candidate;
                                        clock += live_tick_ms; update(&app, clock);
                                        SceneSessionPointerResult second{};
                                        if (app.session != nullptr)
                                            scene_session_get_pointer_result(app.session, &second);
                                        /* In S0 the first activation ends the tick in a scene
                                         * transition, which freezes the session's pointer result at
                                         * the first activation tick; the latch is the evidence. */
                                        record(&app, "live_session_double_click first_activation_tick=%llu "
                                               "candidate_at_second_up=%d edge_after_second_up=%u "
                                               "second_release_activation=%s",
                                               (unsigned long long)first.tick_index, candidate_at_second_up,
                                               edge_after_second_up,
                                               (edge_after_second_up == 0u &&
                                                second.tick_index == first.tick_index) ? "rejected" :
                                               (second.tick_index != first.tick_index && second.activation_event)
                                                   ? "ACCEPTED" : "no-new-activation");
                                    }
                                    scripted_clicks = 2;
                                }
                                break;
                            }
                        }
                    }
                    SceneSessionTickResult tick{};
                    scene_session_get_last_result(app.session, &tick);
                    {
                        SessionConditionsStats cond_stats{};
                        SessionConditionsSoundManager cond_manager{};
                        if (session_conditions_get_stats(app.conditions_binding, &cond_stats) ==
                                SESSION_CONDITIONS_OK &&
                            session_conditions_get_sound_manager(app.conditions_binding,
                                                                 &cond_manager) ==
                                SESSION_CONDITIONS_OK) {
                            record(&app, "scene_conditions_stats leaves=%llu sound_queries=%llu "
                                   "rand_draws=%llu passes=%llu trees=%llu global_5c3a47=%d "
                                   "sound_manager_error=0x%x",
                                   (unsigned long long)cond_stats.leaf_evaluations,
                                   (unsigned long long)cond_stats.sound_queries,
                                   (unsigned long long)cond_stats.random_draws,
                                   (unsigned long long)cond_stats.passes_started,
                                   (unsigned long long)cond_stats.trees_evaluated,
                                   session_conditions_global_5c3a47(app.conditions_binding),
                                   cond_manager.error_3c2);
                        }
                    }
                    {
                        const WorldInitInventory &inv = app.new_game.view.inventory;
                        size_t present = 0;
                        for (size_t i = 0; i < inv.presence_583bd5.count; ++i)
                            present += inv.presence_583bd5.values[i] != 0;
                        record(&app, "live_session_inventory count=%d held=%d presence_nonzero=%zu "
                               "view_rebuilds_requested=%llu",
                               (int)static_cast<int16_t>(inv.selector_words_583a2b.values[0]),
                               (int)*inv.selected_item_candidate, present,
                               (unsigned long long)app.inventory_view_rebuilds);
                        /* RT-19: host requests of raw 0x78 that the app records but does not perform. */
                        record(&app, "live_session_inventory_requests sound_requests=%llu "
                               "ui_animation_requests=%llu (not played / not rendered, unverified)",
                               (unsigned long long)app.a78_sound_requests,
                               (unsigned long long)app.a78_ui_requests);
                    }
                    {
                        /* RT-17: what the window would show at the end of the run (the
                         * composed 640x480 framebuffer), so a frame change is visible in logs. */
                        uint64_t fnv = 1469598103934665603ull;
                        for (const uint8_t byte : app.framebuffer) fnv = (fnv ^ byte) * 1099511628211ull;
                        record(&app, "live_session_framebuffer bytes=%zu fnv1a=%016llx", app.framebuffer.size(),
                               (unsigned long long)fnv);
                    }
                    record(&app, "live_session_end scene=%d ticks=%llu status=%d provider=%s "
                           "stage=%d action=%zu type=0x%02x detail=%d applied=%zu",
                           app.current_scene_id,
                           (unsigned long long)scene_session_tick_count(app.session),
                           tick.status, scene_session_provider_string(tick.failure.provider),
                           tick.failure.stage, tick.failure.action_index,
                           tick.failure.action_type, tick.failure.detail_status,
                           tick.executor.actions_applied);
                }
                if (dump_scene >= 0) {
                    /* Developer inspector: one line per ACT row, no bodies. */
                    char name[33];
                    std::snprintf(name, sizeof(name), "S%ld", dump_scene);
                    GameResourceBytes bytes = GAME_RESOURCE_BYTES_INIT;
                    if (!game_resources_load_bytes(app.resources, name, &bytes, error, sizeof(error)))
                        throw std::runtime_error(error);
                    SceneResource *dump = scene_resource_open_memory(bytes.bytes, bytes.length,
                                                                      error, sizeof(error));
                    game_resource_bytes_destroy(&bytes);
                    if (!dump) throw std::runtime_error(error);
                    for (size_t row = 0; row < scene_resource_action_count(dump); ++row) {
                        SceneActionInfo info{};
                        if (scene_resource_action_at(dump, row, &info) != SCENE_RESOURCE_OK) continue;
                        record(&app, "dump_action scene=%ld row=%zu type=0x%02x subtype=%u kind=%d "
                               "body=%zu typed=%zu deps=%zu desc=%s", dump_scene, row, info.type,
                               info.subtype, (int)info.payload_kind, info.raw_body_length,
                               info.typed_body_length, info.dependency_count, info.description);
                    }
                    scene_resource_close(dump);
                }
                if (inspect_actions && !inspect_action_kernel(&app)) app.failure = true;
                if (inspect_condition_providers && !inspect_condition_providers_fn(&app)) app.failure = true;
                if (inspect_audio && !inspect_audio_graph(&app)) app.failure = true;
                if (inspect_scene_runtime) {
                    SceneTransitionRequest transition{};
                    SceneInspectorFrameSnapshot snapshot{};
                    SceneInspectorFrameView initial_frame{};
                    if (!app.has_scene_frame ||
                        app.scene_frame.width > UINT32_MAX / 4u) {
                        throw std::runtime_error("Headless source scene frame unavailable");
                    }
                    initial_frame.rgba = app.scene_frame.rgba.data();
                    initial_frame.byte_length = app.scene_frame.rgba.size();
                    initial_frame.width = app.scene_frame.width;
                    initial_frame.height = app.scene_frame.height;
                    initial_frame.stride = static_cast<size_t>(app.scene_frame.width) * 4u;
                    initial_frame.frame_index = app.scene_frame.frame_index;
                    if (!scene_inspector_run(app.resources, app.boot, app.scene, app.video,
                            app.game_directory.c_str(), &app.new_game.view,
                            &app.new_game.action64_world, app.log, &initial_frame,
                            &transition, &snapshot)) {
                        scene_inspector_frame_snapshot_destroy(&snapshot);
                        app.failure = true;
                    } else {
                        std::unique_ptr<uint8_t, decltype(&std::free)> snapshot_owner(
                            snapshot.rgba, &std::free);
                        snapshot.rgba = nullptr;
                        const size_t snapshot_row_bytes =
                            static_cast<size_t>(snapshot.width) * 4u;
                        if (!snapshot_owner || snapshot.width == 0u ||
                            snapshot.height == 0u ||
                            snapshot.width > UINT32_MAX / 4u ||
                            snapshot.stride < snapshot_row_bytes ||
                            static_cast<size_t>(snapshot.height - 1u) >
                                (SIZE_MAX - snapshot_row_bytes) / snapshot.stride ||
                            static_cast<size_t>(snapshot.height - 1u) * snapshot.stride +
                                snapshot_row_bytes > snapshot.byte_length) {
                            throw std::runtime_error("Headless transition frame is invalid");
                        }
                        app.transition_source_frame.width = snapshot.width;
                        app.transition_source_frame.height = snapshot.height;
                        app.transition_source_frame.frame_index = snapshot.frame_index;
                        app.transition_source_frame.rgba.assign(
                            snapshot_owner.get(),
                            snapshot_owner.get() + snapshot.byte_length);
                        app.has_transition_source_frame = true;
                        app.transition_source_scene_id = app.current_scene_id;
                        if (!clear_before_scene_entry(&app,
                                blackmoor_macos_monotonic_ms()) ||
                            !load_scene(&app, transition.target_scene, true) ||
                            !prepare_a28_handoff_frames(&app, app.retired_scene)) {
                            app.failure = true;
                        }
                        if (app.retired_scene != nullptr) {
                            scene_resource_close(app.retired_scene);
                            app.retired_scene = nullptr;
                        }
                    }
                }
            } else {
                BlackmoorPlatformCallbacks callbacks{};
                callbacks.tick = tick; callbacks.pointer = pointer;
                callbacks.key = key; callbacks.closed = closed;
                app.platform = blackmoor_macos_open("Blackmoor reconstruction — startup; gameplay incomplete",
                    640, 480, &callbacks, &app, error, sizeof(error));
                if (!app.platform) throw std::runtime_error(error);
                update(&app, app.started);
                if (!app.failure) blackmoor_macos_run(app.platform);
            }
            record(&app, "stopped failure=%d", app.failure);
            result = app.failure ? 1 : 0;
        } catch (const std::exception &exception) {
            record(&app, "host_error=%s", exception.what());
            std::fprintf(stderr, "%s\n", exception.what());
        }
        game_resource_bytes_destroy(&boot_bytes);
        cleanup(&app);
        return result;
    }
}
