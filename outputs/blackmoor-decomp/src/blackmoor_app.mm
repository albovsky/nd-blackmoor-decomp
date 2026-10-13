/* Native integration harness for the recovered startup. This is an incomplete
 * engine, not a playable game. No original x86 code is executed by this app. */
#include "macos_platform.h"
#include "game_resources.h"
#include "engine_boot.h"
#include "startup_menu.h"
#include "scene_resource.h"
#include "bink_adapter.h"
#include "scene_executor.h"
#include "action_ui.h"
#include "his_audio.h"
#include "macos_audio.h"
#include "scene_inspector.h"

#import <AppKit/AppKit.h>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cstdarg>
#include <climits>
#include <string>
#include <vector>
#include <map>
#include <new>
#include <algorithm>
#include <stdexcept>
#include <unistd.h>
#include <dirent.h>
#include <cmath>
#include <memory>

static const char *default_game_directory =
    "/Applications/Nancy Drew - Curse of Blackmoor Manor.app/Contents/Resources/game/"
    "Nancy Drew Curse of the Blackmoor Manor.app/Contents/Resources/drive_c/GOG Games/"
    "Nancy Drew - Curse of Blackmoor Manor";

struct HostImage {
    uint32_t width = 0, height = 0;
    std::vector<uint8_t> rgba;
};

struct NativeApp {
    BlackmoorMacPlatform *platform = nullptr;
    GameResources *resources = nullptr;
    EngineBoot *boot = nullptr;
    StartupMenu *startup = nullptr;
    SceneResource *scene = nullptr;
    FILE *log = nullptr;
    std::map<std::string, HostImage> images;
    std::vector<uint8_t> framebuffer;
    uint32_t started = 0, stop_after = 0;
    int32_t pointer_x = -1, pointer_y = -1;
    bool primary_down = false;
    bool primary_pressed = false, primary_released = false;
    bool failure = false;
    bool command_reported = false;
    int last_stage = -1, last_hover = -2;
    int16_t initial_scene = 0;
    std::string game_directory;
    HostImage scene_frame;
    bool has_scene_frame = false;
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

/* Narrow host configuration adapter. This reads the original patch-loading
 * switch only; it does not claim to implement Windows profile APIs in full. */
static bool external_cif_configuration(const std::string &directory, int *enabled)
{
    FILE *file = std::fopen((directory + "/Game.ini").c_str(), "rb");
    if (!file) return false;
    char line[4096];
    bool data_section = false, found = false;
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
        if (!data_section || equal == std::string::npos ||
            trim(value.substr(0, equal)) != "ExternalCifFileChecking") continue;
        const std::string setting = trim(value.substr(equal + 1));
        if (setting != "0" && setting != "1") { std::fclose(file); return false; }
        *enabled = setting == "1";
        found = true;
        break;
    }
    const bool success = found && !std::ferror(file);
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

static void pointer(void *context, BlackmoorPointerKind kind,
                    int32_t x, int32_t y, unsigned button)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    app->pointer_x = x;
    app->pointer_y = y;
    if (button == 0 && kind == BLACKMOOR_POINTER_DOWN) {
        app->primary_down = true; app->primary_pressed = true;
    }
    if (button == 0 && kind == BLACKMOOR_POINTER_UP) {
        app->primary_down = false; app->primary_released = true;
    }
    if (kind != BLACKMOOR_POINTER_MOVE) record(app, "pointer kind=%d x=%d y=%d button=%u", kind, x, y, button);
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
    if (app->platform) blackmoor_macos_close(app->platform);
    if (app->startup) startup_menu_destroy(app->startup);
    if (app->scene) scene_resource_close(app->scene);
    if (app->boot) engine_boot_close(app->boot);
    if (app->resources) game_resources_close(app->resources);
    if (app->log) std::fclose(app->log);
    app->platform = nullptr;
    app->startup = nullptr;
    app->scene = nullptr;
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
    unsigned matches = 0;
    for (size_t i = 0; i < engine_boot_chunk_count(app->boot); ++i) {
        HiffChunkInfo chunk{};
        const uint8_t *payload = nullptr;
        size_t length = 0;
        if (engine_boot_chunk_at(app->boot, i, &chunk, &payload, &length) != ENGINE_BOOT_OK) return false;
        if (std::strcmp(chunk.id, "VIEW") != 0) continue;
        if (++matches > 1 || length != 48) return false;
        int32_t coordinates[8];
        for (size_t field = 0; field < 8; ++field) {
            const uint8_t *bytes = payload + field * 4;
            const uint32_t value = (uint32_t)bytes[0] | ((uint32_t)bytes[1] << 8) |
                ((uint32_t)bytes[2] << 16) | ((uint32_t)bytes[3] << 24);
            std::memcpy(&coordinates[field], &value, sizeof(value));
        }
        app->scene_destination = {coordinates[0], coordinates[1], coordinates[2], coordinates[3]};
        app->scene_source = {coordinates[4], coordinates[5], coordinates[6], coordinates[7]};
    }
    return matches == 1;
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

static bool load_scene(NativeApp *app, int16_t scene_id)
{
    char name[33], error[256];
    std::snprintf(name, sizeof(name), "S%d", scene_id);
    GameResourceBytes resource = GAME_RESOURCE_BYTES_INIT;
    if (!game_resources_load_bytes(app->resources, name, &resource, error, sizeof(error))) {
        record(app, "scene_error name=%s detail=%s", name, error); return false;
    }
    scene_resource_close(app->scene);
    app->scene = nullptr;
    app->has_scene_frame = false;
    app->scene = scene_resource_open_memory(resource.bytes, resource.length, error, sizeof(error));
    game_resource_bytes_destroy(&resource);
    if (!app->scene) { record(app, "scene_error name=%s detail=%s", name, error); return false; }
    SceneResourceSummary summary{};
    if (scene_resource_get_summary(app->scene, &summary) != SCENE_RESOURCE_OK) return false;
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
    BinkFrame frame = BINK_FRAME_INIT;
    if (bink_adapter_decode_first_frame(path.c_str(), &frame, error, sizeof(error)) != BINK_ADAPTER_OK) {
        record(app, "scene_media_error=%s", error); return false;
    }
    try {
        app->scene_frame.width = frame.width; app->scene_frame.height = frame.height;
        app->scene_frame.rgba.resize((size_t)frame.width * frame.height * 4);
        for (uint32_t row = 0; row < frame.height; ++row)
            std::memcpy(app->scene_frame.rgba.data() + (size_t)row * frame.width * 4,
                        frame.rgba + (size_t)row * frame.stride, (size_t)frame.width * 4);
    } catch (...) { bink_adapter_destroy(&frame); throw; }
    bink_adapter_destroy(&frame);
    record(app, "scene_frame_decoded width=%u height=%u codec=native-FFmpeg original-Bink-equivalence=unverified",
           app->scene_frame.width, app->scene_frame.height);
    app->has_scene_frame = true;
    if (!render_scene_preview(app)) { app->has_scene_frame = false; return false; }
    record(app, "scene_preview viewport=%d,%d,%d,%d actions=not-executed audio=absent",
        app->scene_destination.left, app->scene_destination.top,
        app->scene_destination.right, app->scene_destination.bottom);
    /* Action execution is a separate, still-unimplemented boundary. */
    return true;
}

static void update(NativeApp *app, uint32_t now)
{
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
            if (!load_scene(app, app->initial_scene)) {
                app->failure = true;
                record(app, "scene_setup_failed");
                if (app->platform) {
                    blackmoor_macos_set_title(app->platform, "Blackmoor reconstruction — scene load failed");
                    blackmoor_macos_stop(app->platform);
                }
                return;
            }
            if (app->platform) blackmoor_macos_set_title(app->platform,
                "Blackmoor reconstruction — scene preview; actions and audio incomplete");
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
        app.game_directory = default_game_directory;
        std::string log_path;
        bool inspect_only = false;
        bool inspect_actions = false;
        bool inspect_audio = false;
        bool inspect_scene_runtime = false;
        for (int i = 1; i < argc; ++i) {
            const std::string argument = argv[i];
            if (argument == "--inspect-startup") { inspect_only = true; continue; }
            if (argument == "--inspect-actions") { inspect_only = inspect_actions = true; continue; }
            if (argument == "--inspect-audio") { inspect_only = inspect_audio = true; continue; }
            if (argument == "--inspect-scene-runtime") { inspect_only = inspect_scene_runtime = true; continue; }
            if (i + 1 == argc) { std::fprintf(stderr, "Missing argument value\n"); return 2; }
            const char *value = argv[++i];
            if (argument == "--game-dir") app.game_directory = value;
            else if (argument == "--log") log_path = value;
            else if (argument == "--stop-after-ms") {
                char *end = nullptr;
                const unsigned long duration = std::strtoul(value, &end, 10);
                if (!*value || *end || duration == 0 || duration > 3600000) return 2;
                app.stop_after = (uint32_t)duration;
            } else { std::fprintf(stderr, "Unknown option: %s\n", argument.c_str()); return 2; }
        }
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
            if (!external_cif_configuration(app.game_directory, &external))
                throw std::runtime_error("Cannot read original external-CIF configuration");
            record(&app, "external_cif_checking=%d gameplay_audio=absent engine=incomplete", external);
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
            if (!load_viewport(&app)) throw std::runtime_error("BOOT VIEW configuration unavailable");
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
                if (inspect_actions && !inspect_action_kernel(&app)) app.failure = true;
                if (inspect_audio && !inspect_audio_graph(&app)) app.failure = true;
                if (inspect_scene_runtime) {
                    SceneTransitionRequest transition{};
                    if (!scene_inspector_run(app.resources, app.boot, app.scene,
                            app.game_directory.c_str(), app.log, &transition) ||
                        !load_scene(&app, transition.target_scene)) app.failure = true;
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
