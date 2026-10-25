/* NATIVE-11: actual BOOT artwork, AddInventory78 and app composition/input.
 * This component loads a real static scene and keeps its unrelated piano ACT
 * pending. Item17 is acquired from the real S3398 AddInventory78 payload;
 * that component setup is not a claim of reaching S3398 through gameplay.
 * The close component alone uses real muted offline audio. No window,
 * output device, oracle or copied resource fixture. */
#define main blackmoor_app_entry_for_inventory_test
#ifndef NATIVE_INVENTORY_APP_SOURCE
#define NATIVE_INVENTORY_APP_SOURCE "../src/blackmoor_app.mm"
#endif
#include NATIVE_INVENTORY_APP_SOURCE
#undef main
#include <csignal>

#define CHECK(condition, message) do { if (!(condition)) { \
    std::fprintf(stderr, "CHECK failed: %s\n", message); return 1; } } while (0)

static SceneSessionCallbackStatus prepare_component(void *, SceneConditionState *, SceneExecutorFrameInput *,
                                                    SceneSessionFailure *)
{ return SCENE_SESSION_CALLBACK_OK; }
static int hold_unrelated_action(void *, size_t, const SceneActionInfo *, const SceneActionRuntimeState *before,
                                  SceneActionHandlerResult *out)
{
    out->phase = before->phase;
    out->disposition = SCENE_ACTION_HANDLER_PENDING;
    return SCENE_ACTION_HANDLER_OK;
}

static int component_sound_condition(void *, const SceneConditionLeafRequest *request, int32_t *status, int *)
{
    if (request->record.opcode != 17) return SCENE_CONDITION_ERR_UNSUPPORTED_OPCODE;
    *status = 0; /* Unrelated scene sound is not executed by this rendering component. */
    return SCENE_CONDITION_OK;
}

struct InventoryFixture {
    NativeApp app;
    uint32_t now = 1000;
    std::vector<uint8_t> base;
    NativeRaw555Image *ui = nullptr;
    NativeRaw555Image *tools = nullptr;
    SceneConditionExtension extension{};
    uint64_t muted_frames = 0;
    ~InventoryFixture() { cleanup(&app); }

    bool tick(uint32_t delta = 1)
    {
        now += delta;
        update(&app, now);
        const bool okay = !app.failure && !app.session_block_reported && app.captions.backbuffer_ready;
        if (!okay) print_log_tail();
        return okay;
    }
    bool initialize(const char *directory, bool real_audio = false)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"BlackmoorAudioMuted"];
        app.game_directory = directory;
        app.log = std::tmpfile();
        app.bar_missing = true; /* Taskbar interaction is outside this component. */
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
        app.framebuffer.resize(640u * 480u * 4u);
        if (!load_scene(&app, 3395)) return false; /* Original one-frame AVF, no ACT execution here. */
        const ActionFamily28Rect view = {app.scene_destination.left, app.scene_destination.top,
                                         app.scene_destination.right, app.scene_destination.bottom};
        session_exit_init(&app.exit_state, &view);
        std::vector<SceneSessionActionBinding> bindings;
        std::vector<uint8_t> bound;
        for (size_t row = 0; row < scene_resource_action_count(app.scene); ++row) {
            SceneActionInfo action{};
            if (scene_resource_action_at(app.scene, row, &action) != SCENE_RESOURCE_OK) return false;
            const uint8_t type = action.type;
            if (type == 0x0a || type == 0x15 || type == 0x4d || type == 0x61 || type == 0x64 ||
                type == 0x6a || type == 0x6b || type == 0x71 ||
                std::find(bound.begin(), bound.end(), type) != bound.end()) continue;
            bound.push_back(type);
            SceneSessionActionBinding binding{};
            binding.type = type; binding.provider = SCENE_SESSION_PROVIDER_HOST;
            binding.callback = hold_unrelated_action; binding.context = &app;
            bindings.push_back(binding);
        }
        app.session_conditions.event_flags = app.new_game.action_core.event_flags;
        app.session_conditions.event_flag_count = app.new_game.action_core.event_flag_count;
        SceneSessionConfig config{};
        config.scene = app.scene; config.scene_id = 3395;
        config.action_core_world = &app.new_game.action_core;
        config.conditions = &app.session_conditions;
        config.action_bindings = bindings.data(); config.action_binding_count = bindings.size();
        config.prepare_tick = prepare_component;
        config.advance_media_one = advance_native_session_media_one;
        config.provider_context = &app;
        SceneSessionFailure failure{};
        const int created = scene_session_create(&config, &app.session, &failure);
        if (created != SCENE_SESSION_OK) {
            std::fprintf(stderr, "inventory fixture session=%d provider=%d detail=%d\n", created, failure.provider, failure.detail_status);
            return false;
        }
        extension.evaluate_leaf = component_sound_condition;
        if (scene_session_set_condition_extension(app.session, &extension) != SCENE_SESSION_OK || !tick()) return false;
        ui = load_native_raw555_image(&app, "UIInventory_OVL");
        tools = load_native_raw555_image(&app, "TOOL");
        if (ui == nullptr || tools == nullptr || ui->width != 548u || ui->height != 377u ||
            tools->width != 379u || tools->height != 1465u) return false;
        base = app.framebuffer;
        if (real_audio) {
            LiveAudioConfig config{};
            config.game_directory = directory; config.mode = MAC_AUDIO_MODE_OFFLINE;
            if (live_audio_create(&config, &app.live_audio, error, sizeof(error)) != LIVE_AUDIO_OK) {
                std::fprintf(stderr, "inventory offline audio: %s\n", error);
                return false;
            }
        }
        return app.inv_data_ready && app.inv_view.screen_state == INVVIEW_STATE_NONE &&
               *app.new_game.view.inventory.selected_item_candidate == -1;
    }
    bool render_audio(uint64_t frames)
    {
        LiveAudioOfflineStats stats{};
        if (app.live_audio == nullptr || live_audio_advance_offline(app.live_audio, frames, &stats, nullptr, 0u) != LIVE_AUDIO_OK ||
            stats.frames != frames || stats.nonfinite_samples != 0u || stats.nonzero_samples != 0u) return false;
        muted_frames += stats.frames;
        return true;
    }
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
    bool add_real_item17()
    {
        GameResourceBytes bytes = GAME_RESOURCE_BYTES_INIT;
        char error[256]{};
        if (!game_resources_load_bytes(app.resources, "S3398", &bytes, error, sizeof(error))) return false;
        SceneResource *scene = scene_resource_open_memory(bytes.bytes, bytes.length, error, sizeof(error));
        game_resource_bytes_destroy(&bytes);
        if (scene == nullptr) return false;
        SessionA78Host host{};
        host.model.inventory = inventory_model(&app);
        host.model.view.mode = app.inv_view.mode;
        host.model.view.slot_flag = app.inv_layout.slot_flag;
        host.view.inventory.context = &app;
        host.view.inventory.rebuild_view = native_a78_rebuild_view;
        host.view.request_sound = native_a78_request_sound;
        host.view.request_ui_animation = native_a78_request_ui_animation;
        host.view.context = &app;
        app.a78 = session_a78_create(&host);
        bool added = false;
        if (app.a78 != nullptr && session_a78_begin_scene(app.a78, scene) == ACTION78_OK) {
            for (size_t row = 0; row < scene_resource_action_count(scene); ++row) {
                SceneActionInfo action{};
                Action78Object object{};
                if (scene_resource_action_at(scene, row, &action) != SCENE_RESOURCE_OK || action.type != SESSION_A78_TYPE ||
                    action78_object_from_body(action.typed_body, action.typed_body_length, &object) != ACTION78_OK ||
                    object.item_word != 17u) continue;
                SceneActionRuntimeState before{};
                SceneActionHandlerResult result{};
                added = session_a78_handler(app.a78, row, &action, &before, &result) == SCENE_ACTION_HANDLER_OK &&
                        result.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED;
                std::printf("INV_COMPONENT_ADD source=S3398 row=%zu item=%u take=%u swap=%u added=%d\n",
                            row, object.item_word, object.take_flag, object.swap_flag, added);
                break;
            }
        }
        scene_resource_close(scene);
        return added && inventory_model(&app).item_count != nullptr && *inventory_model(&app).item_count == 1 &&
               app.inv_view.slot_item[0] == 17 && *app.new_game.view.inventory.selected_item_candidate == -1;
    }
    bool open()
    {
        pointer(&app, BLACKMOOR_POINTER_MOVE, 0, 0, 0);
        return inventory_view_open_request(&app, "NATIVE11 component") && tick();
    }
    bool crop_matches(const NativeRaw555Image &source, int32_t sx, int32_t sy, int32_t dx, int32_t dy,
                      int32_t width, int32_t height, size_t *different = nullptr) const
    {
        if (width <= 0 || height <= 0 || sx < 0 || sy < 0 || dx < 0 || dy < 0 ||
            sx + width > static_cast<int32_t>(source.width) || sy + height > static_cast<int32_t>(source.height) ||
            dx + width > 640 || dy + height > 480) return false;
        size_t mismatches = 0;
        for (int32_t y = 0; y < height; ++y) for (int32_t x = 0; x < width; ++x) {
            const size_t offset = static_cast<size_t>(sy + y) * source.pitch + static_cast<size_t>(sx + x) * 2u;
            uint8_t rgba[4]{};
            /* Inventory uses the established HostImage CIF adapter's exact
             * bit replication, not the caption unpacker's floor scaling.
             * No original DirectDraw framebuffer/color parity is claimed. */
            if (!cif_pixels_rgb555_to_rgba(source.pixels.data() + offset, 2u, rgba, sizeof(rgba))) return false;
            const uint8_t *actual = app.framebuffer.data() + (static_cast<size_t>(dy + y) * 640u + static_cast<size_t>(dx + x)) * 4u;
            if (std::memcmp(actual, rgba, sizeof(rgba)) != 0) ++mismatches;
        }
        if (different != nullptr) *different = mismatches;
        return mismatches == 0;
    }
    bool hover_item17()
    {
        int32_t cursor = 0, variant = 0, hx = 0, hy = 0;
        inventory_view_cursor_choice(*app.new_game.view.inventory.selected_item_candidate, 0, 0, &cursor, &variant);
        if (inventory_view_cursor_hotspot(app.inv_curs.data(), app.inv_curs.size(), cursor, variant, &hx, &hy) != INVVIEW_OK) return false;
        const int32_t *r = app.inv_layout.rect[0];
        pointer(&app, BLACKMOOR_POINTER_MOVE, (r[0] + 11 + r[2]) / 2 - hx, (r[1] + r[3]) / 2 - hy, 0);
        return tick();
    }
};

/* Original draw0x4e97ad: opaque inclusive blits. UIIV frame source+0x27,
 * destination+0x47 and relative+0x67; INV record17 at0xb1+17*0x16d uses
 * normal+0x36/lit+0x46. Expectations below come from the owned BOOT metadata,
 * independently of the candidate compositor's draw plan. */
static int open_pixels(InventoryFixture &f)
{
    CHECK(f.add_real_item17() && f.open(), "real item17 acquisition and inventory open succeed");
    CHECK(f.app.inv_view.screen_state == 3 && f.app.inv_view.mode == 2 && f.app.inv_view.tab == 100 &&
          f.app.inv_view.slot_item[0] == 17, "real existing open path selects full-list mode2 with owned key17");
    const int32_t *slot = f.app.inv_layout.rect[0];
    CHECK(slot[0] == 27 && slot[1] == 74 && slot[2] == 88 && slot[3] == 133, "original slot0 bounds include VIEW origin");
    size_t icon_miss = 0, frame_miss = 0;
    const bool icon = f.crop_matches(*f.tools, 127, 306, 27, 74, 62, 60, &icon_miss);
    const bool frame = f.crop_matches(*f.ui, 1, 91, 10, 100, 11, 101, &frame_miss);
    std::printf("INV_OPEN state=%d mode=%d slot0=%d icon_mismatches=%zu/3720 frame_mismatches=%zu/1111\n",
                f.app.inv_view.screen_state, f.app.inv_view.mode, f.app.inv_view.slot_item[0], icon_miss, frame_miss);
    CHECK(icon && frame, "open inventory must draw the actual TOOL key crop and original UIInventory_OVL frame");
    return 0;
}
static int hover_pick(InventoryFixture &f)
{
    CHECK(f.add_real_item17() && f.open(), "real owned key view opens");
    const std::vector<uint8_t> normal = f.app.framebuffer;
    CHECK(f.hover_item17() && f.app.inv_view.hot == 17 && f.app.inv_view.slot_lit[0] == 1,
          "actual MOVE and cursor hotspot select the owned slot");
    CHECK(f.crop_matches(*f.tools, 316, 306, 27, 74, 62, 60) && f.app.framebuffer != normal,
          "hover must draw the exact original lit TOOL crop");
    pointer(&f.app, BLACKMOOR_POINTER_MOVE, 0, 0, 0);
    CHECK(f.tick() && f.app.inv_view.slot_lit[0] == 0 && f.app.framebuffer == normal,
          "moving off the slot restores the exact unlit frame without sticky highlight pixels");
    CHECK(f.hover_item17(), "owned key re-hovers for pick");
    pointer(&f.app, BLACKMOOR_POINTER_DOWN, f.app.pointer_x, f.app.pointer_y, 0);
    pointer(&f.app, BLACKMOOR_POINTER_UP, f.app.pointer_x, f.app.pointer_y, 0);
    CHECK(f.tick() && *f.app.new_game.view.inventory.selected_item_candidate == 17 &&
          *inventory_model(&f.app).item_count == 0 && f.app.inv_view.screen_state == INVVIEW_STATE_NONE &&
          f.app.input_state.latch[0] == 0u, "existing pick path owns the release and closes with held17/list empty");
    CHECK(f.app.framebuffer == f.base, "pick/close restores underlying real scene without inventory pixels");
    CHECK(f.open() && f.app.inv_view.slot_item[0] == -1 &&
          f.crop_matches(*f.ui, 18, 65, 27, 74, 62, 60),
          "reopening after pick draws the original empty-slot crop rather than a stale key");
    std::printf("INV_HOVER_PICK lit_crop=3720 off_restored=1 held=17 scene_restored=1 empty_reopen=1\n");
    return 0;
}
static int close_empty(InventoryFixture &f)
{
    CHECK(*inventory_model(&f.app).item_count == 0 && f.open() && f.app.inv_view.slot_item[0] == -1,
          "empty real new-game inventory opens without manufacturing an item");
    CHECK(f.crop_matches(*f.ui, 18, 65, 27, 74, 62, 60) &&
          f.crop_matches(*f.ui, 441, 93, 356, 16, 20, 19),
          "empty slot and absolute stock close control use their actual original crops");
    /* Logical356,16 plus original CURS hotspot9,9 is the X centre365,25. */
    pointer(&f.app, BLACKMOOR_POINTER_MOVE, 356, 16, 0);
    CHECK(f.tick() && f.crop_matches(*f.ui, 462, 93, 356, 16, 20, 19), "X hover draws original hover crop");
    pointer(&f.app, BLACKMOOR_POINTER_DOWN, 356, 16, 0);
    pointer(&f.app, BLACKMOOR_POINTER_MOVE, 639, 479, 0);
    pointer(&f.app, BLACKMOOR_POINTER_UP, 639, 479, 0);
    CHECK(f.tick() && f.app.inv_view.screen_state == INVVIEW_STATE_INVENTORY &&
          *inventory_model(&f.app).item_count == 0 && *f.app.new_game.view.inventory.selected_item_candidate == -1 &&
          f.app.input_state.latch[0] == 0u, "MOVE outside before accepted UP must not start close or leak a scene release");
    for (unsigned gate = 0; gate < 2u; ++gate) {
        if (gate != 0u) CHECK(f.open(), "empty inventory reopens through the actual request after close");
        pointer(&f.app, BLACKMOOR_POINTER_MOVE, 356, 16, 0);
        CHECK(f.tick(), "X re-hover succeeds");
        pointer(&f.app, BLACKMOOR_POINTER_DOWN, 356, 16, 0);
        pointer(&f.app, BLACKMOOR_POINTER_UP, 356, 16, 0);
        CHECK(f.tick(0) && f.app.inv_view.screen_state == INVVIEW_STATE_INVENTORY &&
              f.crop_matches(*f.ui, 483, 93, 356, 16, 20, 19), "accepted X draws pressed art while close remains pending");
        LiveAudioChannelInfo click{};
        int busy = -1;
        CHECK(live_audio_get_channel_info(f.app.live_audio, 3, &click) == LIVE_AUDIO_OK &&
              click.loaded == 1u && click.started == 1u && click.frame_count > 0 &&
              live_audio_is_playing(f.app.live_audio, 3, &busy) == ACTION_SOUND_BACKEND_OK && busy == 1,
              "accepted X plays the real UIIV click01 descriptor on channel3");
        /* Two genuine open/close cycles isolate the gates. First finish sound
         * before200ms to test strict time comparison; then hold real sound busy
         * past201ms. Neither cycle injects a deadline or completion state. */
        if (gate != 0u)
            CHECK(f.tick(201u) && f.app.inv_view.screen_state == INVVIEW_STATE_INVENTORY,
                  "past deadline the real busy sound must keep the inventory open");
        for (unsigned i = 0; busy != 0 && i < 800u; ++i) {
            CHECK(f.render_audio(4096u), "close audio advances as finite allzero post-master PCM");
            CHECK(live_audio_is_playing(f.app.live_audio, 3, &busy) == ACTION_SOUND_BACKEND_OK,
                  "real close sound completion query succeeds");
        }
        CHECK(busy == 0, "real click01 finishes naturally without a synthetic completion");
        if (gate == 0u)
            CHECK(f.tick(200u) && f.app.inv_view.screen_state == INVVIEW_STATE_INVENTORY && f.tick(1u),
                  "with sound already idle stock X still waits for strict now>deadline");
        else CHECK(f.tick(0), "idle sound permits the pending close update");
        CHECK(f.app.inv_view.screen_state == INVVIEW_STATE_NONE && f.app.inv_view.mode == 0 &&
              *inventory_model(&f.app).item_count == 0 && *f.app.new_game.view.inventory.selected_item_candidate == -1 &&
              f.app.input_state.latch[0] == 0u, "timed close leaves inventory model unchanged and owns its release");
        CHECK(f.tick(0) && f.app.framebuffer == f.base, "closed X leaves no sticky inventory pixels");
    }
    std::printf("INV_CLOSE empty_art=1 cancel_before_UP=1 delay_ms=200 sound_idle_gate=1 unchanged_model=1 restored=1 muted_frames=%llu\n",
                static_cast<unsigned long long>(f.muted_frames));
    return 0;
}
static int bounds(const char *directory)
{
    for (unsigned kind = 0; kind < 2u; ++kind) {
        InventoryFixture f;
        CHECK(f.initialize(directory) && f.add_real_item17() && f.open(), "negative bounds fixture opens a real owned key");
        /* Explicit invalid derived-view states only. The original new-game
         * inventory list/ownership remains untouched; these are not gameplay. */
        if (kind == 0) f.app.inv_view.mode = 4;
        else f.app.inv_view.slot_item[0] = static_cast<int32_t>(INVVIEW_ITEMS);
        const bool rendered = f.tick();
        CHECK(!rendered && f.app.failure && f.app.framebuffer == f.base,
              "unsupported mode or invalid item must refuse explicitly after restoring the scene, without stale item pixels");
        std::printf("INV_BOUNDS kind=%u refused=1 stale_pixels=0\n", kind);
    }
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
        if (argc != 4 || std::strcmp(argv[1], "--inventory-component") != 0) return 2;
        if (std::strcmp(argv[3], "bounds") == 0) return bounds(argv[2]);
        InventoryFixture f;
        if (!f.initialize(argv[2], std::strcmp(argv[3], "close") == 0)) { f.print_log_tail(); CHECK(false, "actual BOOT/new-game/static-scene component initializes"); }
        if (std::strcmp(argv[3], "open") == 0) return open_pixels(f);
        if (std::strcmp(argv[3], "hover-pick") == 0) return hover_pick(f);
        if (std::strcmp(argv[3], "close") == 0) return close_empty(f);
        return 2;
    }
}
