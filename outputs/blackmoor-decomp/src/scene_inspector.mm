#include "scene_inspector.h"
#include "action_sound.h"
#include "action_ui.h"
#include "autotext.h"
#include "his_audio.h"
#include "macos_audio.h"

#include <algorithm>
#include <cmath>
#include <cstdlib>
#include <cstring>
#include <dirent.h>
#include <map>
#include <memory>
#include <string>
#include <vector>

namespace {
using PhoneRow = uint8_t[ACTION_UI_PHONE_RECORD_SIZE];
struct Inspector {
    FILE *log;
    std::string directory;
    ActionUIWorld ui{};
    AutoText *text = nullptr;
    MacAudioHost *audio = nullptr;
    SceneActionExecutor *executor = nullptr;
    std::map<uint16_t, HisAudio> loaded;
    std::map<uint16_t, float> gains;
    float masters[3]{};
    bool captions = false;
    size_t captions_presented = 0;
    uint64_t frames_rendered = 0;
    Inspector(FILE *output, const char *game_directory) : log(output), directory(game_directory) {}
    ~Inspector() {
        scene_executor_destroy(executor);
        if (audio) (void)mac_audio_host_close(audio, nullptr, 0);
        for (auto &entry : loaded) his_audio_destroy(&entry.second);
        autotext_close(text);
    }
};

/* Read only the original keys required by this diagnostic. Values remain
 * configuration inputs; no preferences are written to the installed game. */
bool configuration(Inspector &state)
{
    std::unique_ptr<FILE, decltype(&std::fclose)> file(
        std::fopen((state.directory + "/Game.ini").c_str(), "rb"), std::fclose);
    if (!file) return false;
    char line[4096];
    bool section = false;
    unsigned found = 0;
    while (std::fgets(line, sizeof(line), file.get())) {
        std::string value(line);
        value.resize(value.find(';') == std::string::npos ? value.size() : value.find(';'));
        const auto trim = [](const std::string &s) {
            const size_t first = s.find_first_not_of(" \t\r\n");
            return first == std::string::npos ? std::string() :
                s.substr(first, s.find_last_not_of(" \t\r\n") - first + 1);
        };
        value = trim(value);
        if (value.empty()) continue;
        if (value.front() == '[') { section = value == "[Nancy Data]"; continue; }
        const size_t equal = value.find('=');
        if (!section || equal == std::string::npos) continue;
        const std::string name = trim(value.substr(0, equal));
        const std::string raw = trim(value.substr(equal + 1));
        int index = -1;
        if (name == "VoiceMasterVolume") index = 0;
        else if (name == "MusicMasterVolume") index = 1;
        else if (name == "SpecialEffectsMasterVolume") index = 2;
        else if (name != "ClosedCaptioning") continue;
        char *end = nullptr;
        const long number = std::strtol(raw.c_str(), &end, 10);
        if (raw.empty() || *end || number < 0 || number > 100) return false;
        if (index >= 0) { state.masters[index] = (float)number / 100.0f; found |= 1u << index; }
        else { state.captions = number != 0; found |= 8; }
    }
    return found == 15 && !std::ferror(file.get());
}

bool sound_path(const Inspector &state, const char *stem, std::string &path)
{
    const std::string wanted = std::string(stem) + ".his";
    if (wanted.size() > 37 || wanted.find_first_of("/\\") != std::string::npos) return false;
    const std::string directory = state.directory + "/CDSound";
    std::unique_ptr<DIR, int (*)(DIR *)> entries(opendir(directory.c_str()), closedir);
    if (!entries) return false;
    unsigned matches = 0;
    while (dirent *entry = readdir(entries.get())) {
        const std::string candidate(entry->d_name);
        if (candidate.size() != wanted.size()) continue;
        bool equal = true;
        for (size_t i = 0; i < wanted.size(); ++i) {
            auto fold = [](unsigned char c) { return c >= 'a' && c <= 'z' ? c - 'a' + 'A' : c; };
            if (fold(candidate[i]) != fold(wanted[i])) { equal = false; break; }
        }
        if (equal) { path = directory + "/" + candidate; ++matches; }
    }
    return matches == 1;
}

ActionSoundBackendStatus resolve(void *context, const uint8_t *key, size_t length,
                                 const uint8_t **bytes, size_t *caption_length)
{
    auto &state = *static_cast<Inspector *>(context);
    size_t raw_length = 0;
    const int status = autotext_lookup(state.text, key, length, bytes, &raw_length, caption_length);
    if (status == AUTOTEXT_ERR_NOT_FOUND) return ACTION_SOUND_BACKEND_NO_RESOURCE;
    return status == AUTOTEXT_OK ? ACTION_SOUND_BACKEND_OK : ACTION_SOUND_BACKEND_ERROR;
}

ActionSoundBackendStatus caption(void *context, const ActionSoundCaptionRequest *request)
{
    auto &state = *static_cast<Inspector *>(context);
    if (!request || (!request->bytes && request->length) ||
        request->terminator_length != 3 || std::memcmp(request->terminator, "<e>", 3))
        return ACTION_SOUND_BACKEND_ERROR;
    ++state.captions_presented;
    std::fprintf(state.log, "scene_inspect caption=%zu bytes=%zu terminator=<e> destination=diagnostic-recorder renderer=unimplemented\n",
        state.captions_presented, request->length);
    return ACTION_SOUND_BACKEND_OK;
}

ActionSoundBackendStatus load(void *context, const ActionSoundAudioCommand *command)
{
    auto &state = *static_cast<Inspector *>(context);
    /* This host boundary implements the tested one-shot, mode-zero path.
     * Other raw controls can select original repeat/fade/stream behaviors. */
    if (command->control_word != 1 || command->mode != 0 || command->volume_category >= 3 ||
        command->first_percent != command->second_percent)
        return ACTION_SOUND_BACKEND_UNSUPPORTED;
    std::string path;
    if (!sound_path(state, command->asset_stem, path)) return ACTION_SOUND_BACKEND_ERROR;
    char error[256];
    HisAudio &decoded = state.loaded[command->channel];
    his_audio_destroy(&decoded);
    if (his_audio_decode_file(path.c_str(), &decoded, error, sizeof(error)) != HIS_AUDIO_OK) {
        std::fprintf(state.log, "scene_inspect sound_decode_error=%s\n", error);
        return ACTION_SOUND_BACKEND_ERROR;
    }
    /* 4fadc4 uses x87 arithmetic and __ftol truncation. This selected finite
     * fixture is away from an integer boundary; arbitrary bit parity of x87
     * attenuation expressions is not claimed by this host approximation. */
    const double expression = (double)command->first_gain * state.masters[command->volume_category] *
        2857.142822265625 - 2857.142857142857;
    const int attenuation = std::max(-2857, std::min(0, (int)std::trunc(expression)));
    state.gains[command->channel] = (float)std::pow(10.0, attenuation / 2000.0);
    std::fprintf(state.log, "scene_inspect sound_loaded stem=%s channel=%u frames=%llu rate=%u attenuation_mB=%d decoder=native-FFmpeg original-decoder-equivalence=unverified\n",
        command->asset_stem, command->channel, (unsigned long long)decoded.frame_count,
        decoded.sample_rate, attenuation);
    return ACTION_SOUND_BACKEND_OK;
}

ActionSoundBackendStatus play(void *context, uint16_t channel)
{
    auto &state = *static_cast<Inspector *>(context);
    const auto entry = state.loaded.find(channel);
    if (entry == state.loaded.end()) return ACTION_SOUND_BACKEND_ERROR;
    const HisAudio &sound = entry->second;
    char error[256];
    return mac_audio_play(state.audio, channel, sound.interleaved_pcm, sound.frame_count,
        sound.channels, sound.sample_rate, state.gains.at(channel), 0, error, sizeof(error)) == MAC_AUDIO_OK
        ? ACTION_SOUND_BACKEND_OK : ACTION_SOUND_BACKEND_ERROR;
}

ActionSoundBackendStatus playing(void *context, uint16_t channel, int *value)
{
    auto &state = *static_cast<Inspector *>(context);
    char error[256];
    return mac_audio_is_playing(state.audio, channel, value, error, sizeof(error)) == MAC_AUDIO_OK
        ? ACTION_SOUND_BACKEND_OK : ACTION_SOUND_BACKEND_ERROR;
}

ActionSoundBackendStatus unload(void *context, uint16_t channel)
{
    auto &state = *static_cast<Inspector *>(context);
    char error[256];
    if (mac_audio_stop(state.audio, channel, error, sizeof(error)) != MAC_AUDIO_OK)
        return ACTION_SOUND_BACKEND_ERROR;
    auto entry = state.loaded.find(channel);
    if (entry != state.loaded.end()) { his_audio_destroy(&entry->second); state.loaded.erase(entry); }
    state.gains.erase(channel);
    return ACTION_SOUND_BACKEND_OK;
}

int ui_action(void *context, size_t, const SceneActionInfo *action,
               const SceneActionRuntimeState *before, SceneActionHandlerResult *result)
{
    auto &state = *static_cast<Inspector *>(context);
    ActionUIActionResult effect{};
    const int status = action_ui_dispatch(&state.ui, action->type, action->subtype,
        action->typed_body, action->typed_body_length, before->phase, &effect);
    if (status != ACTION_UI_OK) return status == ACTION_UI_ERR_UNSUPPORTED ?
        SCENE_ACTION_HANDLER_UNSUPPORTED : SCENE_ACTION_HANDLER_ERROR;
    result->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;
    result->phase = effect.phase;
    return SCENE_ACTION_HANDLER_OK;
}

int sound_action(void *context, size_t, const SceneActionInfo *info,
                  const SceneActionRuntimeState *before, SceneActionHandlerResult *result)
{
    auto &state = *static_cast<Inspector *>(context);
    ActionSoundAction action{};
    action.type = info->type; action.subtype = info->subtype; action.eligible = 1;
    action.completed_before = before->completed; action.phase_before = before->phase;
    action.scene_dispatch_argument = 1; action.captions_enabled = state.captions;
    action.body = info->typed_body; action.body_length = info->typed_body_length;
    ActionSoundBackend backend{&state, resolve, caption, load, play, playing, unload};
    ActionSoundStepResult effect{};
    const int status = action_sound_step(&action, &backend, &effect);
    if (status != ACTION_SOUND_OK) return status == ACTION_SOUND_ERR_UNSUPPORTED ?
        SCENE_ACTION_HANDLER_UNSUPPORTED : SCENE_ACTION_HANDLER_ERROR;
    result->phase = effect.phase;
    result->disposition = effect.reset_dependencies ? SCENE_ACTION_HANDLER_RESET_DEPENDENCIES :
        (effect.completion_valid && effect.completed ? SCENE_ACTION_HANDLER_DIRECT_COMPLETED :
                                                     SCENE_ACTION_HANDLER_PENDING);
    if (effect.has_transition) {
        SceneTransitionRequest transition{};
        transition.target_scene = effect.transition.target_scene;
        std::memcpy(transition.opaque_words, effect.transition.opaque_words, sizeof(transition.opaque_words));
        std::memcpy(transition.opaque_dwords, effect.transition.opaque_dwords, sizeof(transition.opaque_dwords));
        if (scene_executor_request_transition(state.executor, &transition) != SCENE_EXECUTOR_OK)
            return SCENE_ACTION_HANDLER_ERROR;
    }
    return SCENE_ACTION_HANDLER_OK;
}
}

static int run_inspection(GameResources *resources, const EngineBoot *boot,
                         const SceneResource *scene, const char *game_directory,
                         FILE *log, SceneTransitionRequest *transition)
{
    if (!resources || !boot || !scene || !game_directory || !log || !transition) return 0;
    Inspector state(log, game_directory);
    if (!configuration(state)) return 0;
    EngineBootStartupSettings settings{};
    size_t phone_count = 0;
    if (engine_boot_get_startup_settings(boot, &settings) != ENGINE_BOOT_OK ||
        engine_boot_get_phone_count(boot, &phone_count) != ENGINE_BOOT_OK) return 0;
    const size_t actions = scene_resource_action_count(scene);
    if (actions > SIZE_MAX - phone_count) return 0;
    std::unique_ptr<PhoneRow[]> seed(new PhoneRow[phone_count]{}), rows(new PhoneRow[phone_count + actions]{});
    for (size_t i = 0; i < phone_count; ++i)
        if (engine_boot_phone_row_at(boot, i, seed[i]) != ENGINE_BOOT_OK) return 0;
    state.ui.phone_records = rows.get(); state.ui.phone_capacity = phone_count + actions;
    if (action_ui_initialize_controls(&state.ui) != ACTION_UI_OK ||
        action_ui_initialize_phone(&state.ui, seed.get(), phone_count) != ACTION_UI_OK) return 0;
    std::fprintf(log, "scene_inspect boot_scene=%d coordinate_words=%d,%d clock_minutes=%d phone_rows=%zu caller_phone_capacity=%zu initialization=selected-recovered-fields\n",
        settings.ordinary_initial_scene, settings.ordinary_coordinate_word_a, settings.ordinary_coordinate_word_b,
        settings.initial_hour * 60 + settings.initial_minute, state.ui.phone_count, state.ui.phone_capacity);
    char error[256];
    GameResourceBytes text_bytes = GAME_RESOURCE_BYTES_INIT;
    if (!game_resources_load_bytes(resources, "AUTOTEXT", &text_bytes, error, sizeof(error))) return 0;
    const int text_status = autotext_open_memory(text_bytes.bytes, text_bytes.length, 0, &state.text, error, sizeof(error));
    game_resource_bytes_destroy(&text_bytes);
    if (text_status != AUTOTEXT_OK) return 0;
    if (mac_audio_host_open(MAC_AUDIO_MODE_OFFLINE, 44100, 2, &state.audio, error, sizeof(error)) != MAC_AUDIO_OK)
        return 0;
    /* The observed flag clear ends at ID2250. This diagnostic supplies that
     * bounded view; it does not infer the original allocation capacity. */
    std::vector<int32_t> flags(2251, 0), inventory(70, 0);
    std::vector<int16_t> visits(10001, 0);
    ActionCoreWorld world{};
    world.event_flags = flags.data(); world.event_flag_count = flags.size();
    if (action_core_initialize_values(&world) != ACTION_CORE_OK) return 0;
    SceneConditionState conditions{};
    conditions.event_flags = flags.data(); conditions.event_flag_count = flags.size();
    conditions.inventory_presence = inventory.data(); conditions.inventory_count = inventory.size();
    conditions.selected_inventory_item = -1;
    conditions.scene_visit_counts = visits.data(); conditions.scene_visit_count = visits.size();
    conditions.time_of_day_minutes = settings.initial_hour * 60 + settings.initial_minute;
    size_t failed_index = SIZE_MAX;
    if (scene_executor_create(scene, &world, 0, &state.executor, &failed_index) != SCENE_EXECUTOR_OK) return 0;
    const SceneActionHandler handlers[] = {
        {0x82, ui_action, &state}, {0x1d, ui_action, &state}, {0x9f, sound_action, &state}
    };
    SceneExecutorFrameInput input{};
    input.cursor_context_allowed = 1;
    SceneExecutorStepInfo step{};
    auto dispatch = [&]() {
        const int status = scene_executor_step_frame(state.executor, &conditions, handlers,
            sizeof(handlers) / sizeof(handlers[0]), &input, &step);
        if (status != SCENE_EXECUTOR_OK)
            std::fprintf(log, "scene_inspect executor_error=%d row=%zu type=0x%02x detail=%d\n",
                status, step.failed_action_index, step.failed_action_type, step.detail_status);
        return status == SCENE_EXECUTOR_OK;
    };
    if (!dispatch()) return 0;
    for (unsigned pass = 0; !state.loaded.empty(); ++pass) {
        if (pass >= 1024) return 0;
        MacAudioRender rendered = MAC_AUDIO_RENDER_INIT;
        if (mac_audio_host_render_offline(state.audio, 4096, &rendered, error, sizeof(error)) != MAC_AUDIO_OK)
            return 0;
        state.frames_rendered += rendered.frame_count;
        bool finite = true;
        for (uint64_t i = 0; i < rendered.frame_count * rendered.channels; ++i)
            if (!std::isfinite(rendered.interleaved_pcm[i])) { finite = false; break; }
        mac_audio_render_destroy(&rendered);
        if (!finite || !dispatch() || step.kind == SCENE_EXECUTOR_STEP_TRANSITION) return 0;
    }
    std::fprintf(log, "scene_inspect audio_completed frames_rendered=%llu captions=%zu device=offline completion=DataRendered\n",
        (unsigned long long)state.frames_rendered, state.captions_presented);
    for (size_t i = 0; i < actions; ++i) {
        SceneExecutorHotspotState hotspot{};
        if (scene_executor_get_hotspot_state(state.executor, i, &hotspot) != SCENE_EXECUTOR_OK ||
            !hotspot.active || !hotspot.rectangle_valid || hotspot.runtime_type != 0x6a) continue;
        input.pointer_valid = 1;
        input.pointer_x = (int32_t)(((int64_t)hotspot.left + hotspot.right) / 2);
        input.pointer_y = (int32_t)(((int64_t)hotspot.top + hotspot.bottom) / 2);
        std::fprintf(log, "scene_inspect fixture_hotspot=%zu rect=%d,%d,%d,%d frame=%d input=hover-then-accepted-primary-release\n",
            i, hotspot.left, hotspot.top, hotspot.right, hotspot.bottom, input.current_frame);
        if (!dispatch() || step.kind == SCENE_EXECUTOR_STEP_TRANSITION) return 0;
        input.hotspot_activation_event = 1;
        if (!dispatch() || step.kind != SCENE_EXECUTOR_STEP_TRANSITION) return 0;
        *transition = step.transition;
        std::fprintf(log, "scene_inspect transition_target=%d difficulty=%d phone_rows=%zu boundary=resource-driven incomplete_game=1\n",
            transition->target_scene, world.difficulty, state.ui.phone_count);
        return 1;
    }
    std::fprintf(log, "scene_inspect no-supported-active-flag-hotspot\n");
    return 0;
}

int scene_inspector_run(GameResources *resources, const EngineBoot *boot,
                         const SceneResource *scene, const char *game_directory,
                         FILE *log, SceneTransitionRequest *transition)
{
    try {
        return run_inspection(resources, boot, scene, game_directory, log, transition);
    } catch (const std::exception &error) {
        if (log) std::fprintf(log, "scene_inspect host_error=%s\n", error.what());
        return 0;
    } catch (...) {
        if (log) std::fprintf(log, "scene_inspect host_error=unknown-exception\n");
        return 0;
    }
}
