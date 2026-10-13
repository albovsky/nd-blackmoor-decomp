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
#include "scene_inspector.h"
#include "world_init.h"
#include "world_clock.h"
#include "action_family28_surface.h"
#include "scene_conditions.h"
#include "scene_session.h"
#include "caption_layout.h"
#include "caption_lifecycle.h"
#include "cif_pixels.h"
#include "hiff.h"
#include "autotext.h"

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
    CaptionSurface caption_surface{};
    CaptionSurface framed_surface{};
    std::vector<uint8_t> caption_pixels;
    std::vector<uint8_t> framed_pixels;
    std::map<std::string, uint32_t> image_handles;
    std::map<uint32_t, NativeRaw555Image> raw_images;
    AutoText *auto_text = nullptr;
    size_t auto_text_entry_count = 0u;
    uint32_t next_image_handle = 1u;
    uint32_t caption_surface_handle = UINT32_C(0xf0000001);
    uint32_t framed_surface_handle = UINT32_C(0xf0000002);
    bool initialized = false;
    bool transfer_blocked = false;
    bool action_caption_attempted = false;
    bool action_caption_lookup_attempted = false;
    int last_writer_status = CAPTION_OK;
    int last_lifecycle_status = CAPTION_LIFECYCLE_OK;
    CaptionResult last_writer_result{};
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

struct NativeApp {
    BlackmoorMacPlatform *platform = nullptr;
    GameResources *resources = nullptr;
    EngineBoot *boot = nullptr;
    StartupMenu *startup = nullptr;
    SceneResource *scene = nullptr;
    BinkPlayer *video = nullptr;
    SceneSession *session = nullptr;
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
    bool primary_down = false;
    bool primary_pressed = false, primary_released = false;
    bool failure = false;
    bool command_reported = false;
    bool scene_runtime_enabled = false;
    bool session_block_reported = false;
    bool session_transition_reported = false;
    int last_stage = -1, last_hover = -2;
    int16_t initial_scene = 0;
    int16_t current_scene_id = 0;
    int16_t transition_source_scene_id = 0;
    int32_t scene_current_frame = 0;
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

static CaptionLifecycleBackendStatus native_caption_lifecycle_blit(
    void *context, const CaptionBlit *blit)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app == nullptr || blit == nullptr) return CAPTION_LIFECYCLE_BACKEND_ERROR;
    app->captions.transfer_blocked = true;
    record(app, "caption_transfer_blocked kind=%d handle=%u label=%s "
           "src=%d,%d,%d,%d dst=%d,%d,%d,%d reason=s05-3-transfer-contract-pending "
           "destination=full-640x480-composition-unavailable",
           blit->kind, blit->surface, blit->label ? blit->label : "unknown",
           blit->src.left, blit->src.top, blit->src.right, blit->src.bottom,
           blit->dst.left, blit->dst.top, blit->dst.right, blit->dst.bottom);
    return CAPTION_LIFECYCLE_BACKEND_ERROR;
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
    if (app == nullptr || command == nullptr) return ACTION_SOUND_BACKEND_ERROR;
    record(app, "action_sound_load_blocked stem=%s channel=%u category=%u "
           "control_word=0x%08x reason=live-audio-channel-provider-unavailable",
           command->asset_stem, command->channel, command->volume_category,
           command->control_word);
    return ACTION_SOUND_BACKEND_UNSUPPORTED;
}

static ActionSoundBackendStatus native_action_sound_play(void *context,
                                                          uint16_t channel)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    if (app != nullptr)
        record(app, "action_sound_play_blocked channel=%u reason=live-audio-channel-provider-unavailable",
               channel);
    return ACTION_SOUND_BACKEND_UNSUPPORTED;
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
    const int fonts_status = pixel_status == CAPTION_OK
        ? caption_fonts_init(font, font_size, summary.font_count,
                             &app->captions.fonts) : pixel_status;
    const int geometry_status = fonts_status == CAPTION_OK
        ? caption_geometry_init(tbox, tbox_size, &app->captions.geometry)
        : fonts_status;
    hiff_close(font_container);
    game_resource_bytes_destroy(&font_bytes);
    if (geometry_status != CAPTION_OK) {
        record(app, "caption_runtime_error provider=layout pixel=%d fonts=%d geometry=%d",
               pixel_status, fonts_status, geometry_status);
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
           "view_origin=%d,%d format=RGB555 caption_surface=%dx%d/%zu framed_surface=%dx%d/%zu "
           "saved_surface=Frame handle=%u bytes=%zu autotext_entries=%zu popup_state=%d slider=%u modal=%d "
           "transfer=source-backed-kernel-pending composition=not-certified",
           app->captions.fonts.count, tbox_size, sctb_size, task_size,
           app->captions.lifecycle.view_origin[0], app->captions.lifecycle.view_origin[1],
           app->captions.caption_surface.width, app->captions.caption_surface.height,
           app->captions.caption_pixels.size(), app->captions.framed_surface.width,
           app->captions.framed_surface.height, app->captions.framed_pixels.size(),
           frame_handle, app->captions.raw_images.at(frame_handle).pixels.size(),
           app->captions.auto_text_entry_count,
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

static void pointer(void *context, BlackmoorPointerKind kind,
                    int32_t x, int32_t y, unsigned button)
{
    NativeApp *app = static_cast<NativeApp *>(context);
    /* The original message-map helper stores coordinates for WM_MOUSEMOVE.
     * Button down/up notify the input latch without replacing that last move. */
    if (kind == BLACKMOOR_POINTER_MOVE) {
        app->pointer_x = x;
        app->pointer_y = y;
    }
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
    if (app->session) scene_session_destroy(app->session);
    if (app->platform) blackmoor_macos_close(app->platform);
    if (app->startup) startup_menu_destroy(app->startup);
    if (app->scene) scene_resource_close(app->scene);
    if (app->video) bink_player_close(app->video);
    if (app->boot) engine_boot_close(app->boot);
    autotext_close(app->captions.auto_text);
    app->captions.auto_text = nullptr;
    if (app->resources) game_resources_close(app->resources);
    if (app->log) std::fclose(app->log);
    app->platform = nullptr;
    app->session = nullptr;
    app->startup = nullptr;
    app->scene = nullptr;
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
    if (!find_boot_payload(app, "VIEW", &payload, &length) || length != 48u) return false;
    int32_t coordinates[8];
    for (size_t field = 0; field < 8u; ++field)
        coordinates[field] = read_i32_le(payload + field * 4u);
    app->scene_destination = {coordinates[0], coordinates[1], coordinates[2], coordinates[3]};
    app->scene_source = {coordinates[4], coordinates[5], coordinates[6], coordinates[7]};
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
    const int status = action_sound_step(&action, &backend, &effect);
    const bool has_selector = info->typed_body != nullptr &&
        info->typed_body_length >= 48u &&
        (info->typed_body[46] != 0u || info->typed_body[47] != 0u);
    const bool caption_gate = status == ACTION_SOUND_ERR_UNSUPPORTED &&
        (app->captions.action_caption_attempted ||
         app->captions.action_caption_lookup_attempted) &&
        action.captions_enabled != 0u && action.scene_dispatch_argument != 0u &&
        has_selector;
    record(app, "scene_action_sound row=%zu phase=%u kernel_status=%d "
           "captions=%u dispatch_argument=%u boundary=%s lookup_attempted=%u writer_status=%d "
           "audio_provider=unavailable transfer_blocked=%d",
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
    if (status != ACTION_SOUND_OK || effect.has_transition != 0u)
        return SCENE_ACTION_HANDLER_ERROR;
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
    return SCENE_SESSION_CALLBACK_OK;
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
    config.action_bindings = &action_sound_binding;
    config.action_binding_count = 1u;
    SceneSessionFailure failure{};
    const int status = scene_session_create(&config, &app->session, &failure);
    if (status != SCENE_SESSION_OK) {
        record(app, "scene_session_create_error status=%d provider=%s stage=%d action=%zu type=0x%02x detail=%d",
               status, scene_session_provider_string(failure.provider), failure.stage,
               failure.action_index, failure.action_type, failure.detail_status);
        return false;
    }
    record(app, "scene_session_created scene=%d generation=%llu ui_phone_rows=%zu "
           "world=borrowed lifetime=app-owned transition=opaque-tuple-retained "
           "clock=world-clock-normal+timer-records post-clock-gates=guarded "
           "pointer_transform=unverified caption_writer=bound-RGB555 "
           "caption_transfer=unavailable audio_provider=unavailable",
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
    if (app->video) bink_player_close(app->video);
    app->video = nullptr;
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
    record(app, "scene_video_open width=%u height=%u frames=%u rate=%d/%d retained_bytes=%llu "
           "mode=0 pacing=native-FFmpeg-timestamps BinkWait-parity=unverified",
           info.width, info.height, info.total_frames, info.frame_rate_num,
           info.frame_rate_den, (unsigned long long)info.decoded_frame_storage_bytes);
    record(app, "scene_frame_decoded width=%u height=%u frame=%d codec=native-FFmpeg original-Bink-equivalence=unverified",
           app->scene_frame.width, app->scene_frame.height, app->scene_current_frame);
    app->has_scene_frame = true;
    if (!render_scene_preview(app)) { app->has_scene_frame = false; return false; }
    record(app, "scene_preview viewport=%d,%d,%d,%d actions=not-executed audio=absent",
        app->scene_destination.left, app->scene_destination.top,
        app->scene_destination.right, app->scene_destination.bottom);
    /* Action execution is a separate, still-unimplemented boundary. */
    return true;
}

static bool evaluate_a28_dependency_gate(NativeApp *app,
                                         size_t action_index,
                                         const SceneActionInfo &action,
                                         int *satisfied)
{
    if (!app || !satisfied || !app->scene || !app->new_game.view.action_core ||
        action.dependency_count > SIZE_MAX / sizeof(SceneDependencyInfo)) return false;
    std::vector<SceneDependencyInfo> dependencies(action.dependency_count);
    for (size_t i = 0; i < action.dependency_count; ++i) {
        if (scene_resource_dependency_at(app->scene, action_index, i,
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
        record(app, "scene_a28_gate_error status=%d unsupported_opcode=%u",
               status, unsupported_opcode);
        return false;
    }
    return true;
}

static bool prepare_a28_handoff_frames(NativeApp *app)
{
    if (!app || !app->scene || !app->has_scene_frame ||
        !app->has_transition_source_frame) return false;
    app->a28_capture_pair_ready = false;
    size_t action_index = SIZE_MAX;
    SceneActionInfo action{};
    for (size_t i = 0; i < scene_resource_action_count(app->scene); ++i) {
        SceneActionInfo candidate{};
        if (scene_resource_action_at(app->scene, i, &candidate) != SCENE_RESOURCE_OK) {
            return false;
        }
        if (candidate.type != ACTION_FAMILY_28_TYPE) {
            record(app, "scene_a28_prefix row=%zu type=0x%02x subtype=%u "
                   "payload_kind=%d body_bytes=%zu dependency_records=%zu "
                   "dispatch=not-run-by-handoff-inspector",
                   i, candidate.type, candidate.subtype, candidate.payload_kind,
                   candidate.typed_body_length, candidate.dependency_count);
        }
        if (candidate.type == ACTION_FAMILY_28_TYPE) {
            action_index = i;
            action = candidate;
            break;
        }
    }
    if (action_index == SIZE_MAX) {
        record(app, "scene_a28_handoff=unsupported no-type-28-action");
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
    if (!evaluate_a28_dependency_gate(app, action_index, action,
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
    record(app, "scene_a28_execution=not-run reason=successor-scene-dispatch-"
           "not-integrated gate=not-evaluated-after-prefix entry_gate_known=%d "
           "entry_gate=%d", entry_gate_known, dependency_satisfied);
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
    return true;
}

static void update(NativeApp *app, uint32_t now)
{
    app->session_tick_sample = now;
    if (app->session != nullptr) {
        SceneSessionTickResult session_result{};
        const int session_status = scene_session_tick(app->session, &session_result);
        if (session_status == SCENE_SESSION_BLOCKED && !app->session_block_reported) {
            record(app, "scene_session_blocked stage=%d provider=%s action=%zu type=0x%02x detail=%d "
                   "effects_before_block=%zu dispatch_attempted=%u",
                   session_result.failure.stage,
                   scene_session_provider_string(session_result.failure.provider),
                   session_result.failure.action_index, session_result.failure.action_type,
                   session_result.failure.detail_status,
                   session_result.executor.actions_applied,
                   session_result.dispatch_attempted);
            app->session_block_reported = true;
        } else if (session_status == SCENE_SESSION_TRANSITION_PENDING &&
                   !app->session_transition_reported) {
            SceneTransitionRequest transition{};
            if (scene_session_get_pending_transition(app->session, &transition)) {
                record(app, "scene_session_transition_pending source=%d target=%d "
                       "opaque_words=%d,%d,%d opaque_dwords=%d,%d,%d "
                       "target_loader=not-integrated",
                       app->current_scene_id, transition.target_scene,
                       transition.opaque_words[0], transition.opaque_words[1],
                       transition.opaque_words[2], transition.opaque_dwords[0],
                       transition.opaque_dwords[1], transition.opaque_dwords[2]);
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
        if (app->has_scene_frame && !render_scene_preview(app)) {
            app->failure = true;
            record(app, "scene_session_render_error scope=decoded-background-only");
            if (app->platform) blackmoor_macos_stop(app->platform);
            return;
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
        bool inspect_session_boundary = false;
        for (int i = 1; i < argc; ++i) {
            const std::string argument = argv[i];
            if (argument == "--inspect-startup") { inspect_only = true; continue; }
            if (argument == "--inspect-actions") { inspect_only = inspect_actions = true; continue; }
            if (argument == "--inspect-audio") { inspect_only = inspect_audio = true; continue; }
            if (argument == "--inspect-scene-runtime") { inspect_only = inspect_scene_runtime = true; continue; }
            if (argument == "--inspect-session-boundary") { inspect_only = inspect_session_boundary = true; continue; }
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
        app.scene_runtime_enabled = !inspect_only || inspect_session_boundary;
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
                    if (session_result.status != SCENE_SESSION_BLOCKED ||
                        session_result.failure.provider != SCENE_SESSION_PROVIDER_ACTION_SOUND ||
                        scene_session_tick_count(app.session) != 1u ||
                        session_result.media_attempted != 1u ||
                        session_result.dispatch_attempted != 1u ||
                        session_result.executor.actions_applied != 31u) {
                        app.failure = true;
                    }
                }
                if (inspect_actions && !inspect_action_kernel(&app)) app.failure = true;
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
                            !load_scene(&app, transition.target_scene) ||
                            !prepare_a28_handoff_frames(&app)) {
                            app.failure = true;
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
