/* RT-1 live audio channel provider.
 *
 * Native platform/codec adapter, not a reconstruction of the original CSound
 * stream protocol (S04-2.2 stays paused). See live_audio.h for the contract;
 * everything the original decides from state this adapter does not model is
 * reported there as unverified rather than guessed. */

#include "live_audio.h"

#include <dirent.h>
#include <errno.h>
#include <math.h>
#include <pthread.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

#include "his_audio.h"

/* The command, the sound-control kernel and this provider must agree on the
 * channel and category counts; they are one table in the original. */
_Static_assert(LIVE_AUDIO_CHANNEL_COUNT == SOUND_CONTROL_CHANNEL_COUNT,
               "channel count must match the recovered sound-control kernel");
_Static_assert(LIVE_AUDIO_CATEGORY_COUNT == 4u, "four independent volume categories");

#define HOST_SLOTS_PER_CHANNEL 2u
/* Startup x87 control word of the recovered attenuation path (S04-1). */
#define REFERENCE_X87_CONTROL_WORD 0x027fu
#define MAX_SUFFIX_BYTES 4u /* ".his" */

typedef struct Channel {
    uint8_t loaded;
    uint8_t started;
    uint8_t finished;
    uint8_t volume_category;
    uint8_t mode;
    uint64_t generation;
    /* Counts loads on this channel. Its parity picks the host slot, so a
     * replacement sound never shares a host slot with the sound it replaced:
     * a late completion for the old sound cannot be mistaken for the new
     * one's even by a host that does not tag completions itself. */
    uint64_t load_serial;
    /* offline_frames_rendered when the host accepted play */
    uint64_t play_mark;
    uint32_t host_slot;
    uint32_t control_word;
    int16_t first_percent;
    int16_t second_percent;
    float first_gain;
    float second_gain;
    float final_gain;
    int32_t reference_first_attenuation;
    uint8_t reference_first_attenuation_valid;
    HisAudio audio;
} Channel;

struct LiveAudio {
    LiveAudioHostOps ops;
    MacAudioHost *host;
    MacAudioMode mode;
    char *game_directory;
    LiveAudioLogFn log;
    void *log_context;
    float category_scalar[LIVE_AUDIO_CATEGORY_COUNT];
    uint32_t offline_sample_rate;
    uint32_t offline_channels;
    uint64_t offline_frames_rendered;
    /* AVAudioEngine's manual render faults until a player node exists, so
     * offline advances before the first host play are virtual. */
    uint8_t host_played;
    Channel channels[LIVE_AUDIO_CHANNEL_COUNT];
};

/* ---- helpers ------------------------------------------------------------ */
static int on_main_thread(void)
{
    return pthread_main_np() != 0;
}

static void logf_line(const LiveAudio *audio, const char *format, ...)
{
    char line[640];
    va_list arguments;

    if (audio == NULL || audio->log == NULL) return;
    va_start(arguments, format);
    (void)vsnprintf(line, sizeof(line), format, arguments);
    va_end(arguments);
    audio->log(audio->log_context, line);
}

static void set_error(char *error, size_t capacity, const char *format, ...)
{
    va_list arguments;

    if (error == NULL || capacity == 0u) return;
    va_start(arguments, format);
    (void)vsnprintf(error, capacity, format, arguments);
    va_end(arguments);
}

static unsigned char fold(unsigned char value)
{
    return (value >= 'a' && value <= 'z') ? (unsigned char)(value - 'a' + 'A') : value;
}

/* Does `name` equal stem + ".his", ASCII case-insensitively? */
static int name_matches(const char *stem, size_t stem_length, const char *name)
{
    static const char suffix[] = ".his";
    size_t index;

    for (index = 0u; index < stem_length; ++index) {
        if (name[index] == '\0' || fold((unsigned char)name[index]) != fold((unsigned char)stem[index]))
            return 0;
    }
    for (index = 0u; index < MAX_SUFFIX_BYTES; ++index) {
        if (name[stem_length + index] == '\0' ||
            fold((unsigned char)name[stem_length + index]) != fold((unsigned char)suffix[index]))
            return 0;
    }
    return name[stem_length + MAX_SUFFIX_BYTES] == '\0';
}

static int stem_is_valid(const char *stem, size_t *length)
{
    size_t index;

    if (stem == NULL) return 0;
    for (index = 0u; index <= LIVE_AUDIO_MAX_STEM_CHARS; ++index) {
        if (stem[index] == '\0') {
            *length = index;
            return 1;
        }
        if (stem[index] == '/' || stem[index] == '\\') return 0;
    }
    return 0; /* more than LIVE_AUDIO_MAX_STEM_CHARS characters */
}

LiveAudioNameMatch live_audio_match_asset_name(const char *stem,
                                               const char *const *names,
                                               size_t name_count,
                                               size_t *match_index)
{
    size_t stem_length = 0u;
    size_t matches = 0u;
    size_t index;
    size_t found = 0u;

    if (!stem_is_valid(stem, &stem_length)) return LIVE_AUDIO_MATCH_INVALID;
    if (stem_length == 0u || names == NULL) return LIVE_AUDIO_MATCH_NONE;
    for (index = 0u; index < name_count; ++index) {
        if (names[index] != NULL && name_matches(stem, stem_length, names[index])) {
            if (matches == 0u) found = index;
            ++matches;
        }
    }
    if (matches == 0u) return LIVE_AUDIO_MATCH_NONE;
    if (matches > 1u) return LIVE_AUDIO_MATCH_AMBIGUOUS;
    if (match_index != NULL) *match_index = found;
    return LIVE_AUDIO_MATCH_ONE;
}

typedef enum resolve_status {
    RESOLVE_FOUND,
    RESOLVE_MISSING,
    RESOLVE_AMBIGUOUS,
    RESOLVE_FAILED
} ResolveStatus;

/* Scans <game>/CDSound once. Only regular files count as candidates. On
 * RESOLVE_FOUND, *path is a malloc'd full path owned by the caller. */
static ResolveStatus resolve_asset(const LiveAudio *audio, const char *stem,
                                   size_t stem_length, char **path)
{
    size_t directory_length = strlen(audio->game_directory) + 1u + strlen(LIVE_AUDIO_SOUND_DIRECTORY);
    char *directory_path = malloc(directory_length + 1u);
    DIR *directory;
    size_t matches = 0u;
    char *match_path = NULL;
    struct dirent *entry;
    ResolveStatus result = RESOLVE_MISSING;

    *path = NULL;
    if (directory_path == NULL) return RESOLVE_FAILED;
    (void)snprintf(directory_path, directory_length + 1u, "%s/%s", audio->game_directory,
                   LIVE_AUDIO_SOUND_DIRECTORY);
    directory = opendir(directory_path);
    if (directory == NULL) {
        free(directory_path);
        return (errno == ENOENT || errno == ENOTDIR) ? RESOLVE_MISSING : RESOLVE_FAILED;
    }
    while ((entry = readdir(directory)) != NULL) {
        char *candidate;
        size_t candidate_length;
        struct stat info;

        if (!name_matches(stem, stem_length, entry->d_name)) continue;
        candidate_length = directory_length + 1u + strlen(entry->d_name);
        candidate = malloc(candidate_length + 1u);
        if (candidate == NULL) {
            result = RESOLVE_FAILED;
            matches = 0u;
            free(match_path);
            match_path = NULL;
            break;
        }
        (void)snprintf(candidate, candidate_length + 1u, "%s/%s", directory_path, entry->d_name);
        if (stat(candidate, &info) != 0 || !S_ISREG(info.st_mode)) {
            free(candidate);
            continue;
        }
        ++matches;
        if (matches == 1u) {
            match_path = candidate;
        } else {
            free(candidate);
        }
    }
    (void)closedir(directory);
    free(directory_path);
    if (result == RESOLVE_FAILED) return RESOLVE_FAILED;
    if (matches == 0u) return RESOLVE_MISSING;
    if (matches > 1u) {
        free(match_path);
        return RESOLVE_AMBIGUOUS;
    }
    *path = match_path;
    return RESOLVE_FOUND;
}

static uint32_t host_slot_for(uint16_t channel, uint64_t load_serial)
{
    return (uint32_t)channel + LIVE_AUDIO_CHANNEL_COUNT * (uint32_t)(load_serial % HOST_SLOTS_PER_CHANNEL);
}

static float compose_gain(float first, float second, float category_scalar)
{
    volatile float product = first * second;
    volatile float final_gain = product * category_scalar;
    return final_gain;
}

static void refresh_gain(const LiveAudio *audio, Channel *channel)
{
    float scalar = audio->category_scalar[channel->volume_category];
    int32_t attenuation = 0;

    channel->final_gain = compose_gain(channel->first_gain, channel->second_gain, scalar);
    channel->reference_first_attenuation_valid =
        sound_control_calculate_attenuation(channel->first_gain, scalar, REFERENCE_X87_CONTROL_WORD,
                                            &attenuation) == SOUND_CONTROL_OK;
    channel->reference_first_attenuation = channel->reference_first_attenuation_valid ? attenuation : 0;
}

/* Stops the host slot of a started sound and frees the channel's PCM.
 * The channel's generation moves on either way. */
static int release_channel(LiveAudio *audio, uint16_t index)
{
    Channel *channel = &audio->channels[index];
    char error[256] = "";
    int status = MAC_AUDIO_OK;

    if (channel->started) {
        status = audio->ops.stop(audio->host, channel->host_slot, error, sizeof(error));
        if (status != MAC_AUDIO_OK)
            logf_line(audio, "live_audio stop_failed channel=%u slot=%u status=%d detail=%s", index,
                      channel->host_slot, status, error);
    }
    his_audio_destroy(&channel->audio);
    channel->loaded = 0u;
    channel->started = 0u;
    channel->finished = 0u;
    channel->final_gain = 0.0f;
    channel->reference_first_attenuation = 0;
    channel->reference_first_attenuation_valid = 0u;
    ++channel->generation;
    return status;
}

/* ---- lifecycle ----------------------------------------------------------- */
void live_audio_default_host_ops(LiveAudioHostOps *ops)
{
    if (ops == NULL) return;
    ops->open = mac_audio_host_open;
    ops->close = mac_audio_host_close;
    ops->play = mac_audio_play;
    ops->stop = mac_audio_stop;
    ops->set_gain = mac_audio_set_gain;
    ops->is_playing = mac_audio_is_playing;
    ops->render_offline = mac_audio_host_render_offline;
    ops->render_destroy = mac_audio_render_destroy;
}

static int ops_complete(const LiveAudioHostOps *ops)
{
    return ops->open && ops->close && ops->play && ops->stop && ops->set_gain &&
           ops->is_playing && ops->render_offline && ops->render_destroy;
}

int live_audio_create(const LiveAudioConfig *config, LiveAudio **audio_out,
                      char *error, size_t error_capacity)
{
    LiveAudio *audio;
    uint32_t rate;
    uint32_t channels;
    unsigned index;
    int status;
    char host_error[256] = "";

    if (audio_out != NULL) *audio_out = NULL;
    set_error(error, error_capacity, "%s", "");
    if (config == NULL || audio_out == NULL || config->game_directory == NULL ||
        config->game_directory[0] == '\0') {
        set_error(error, error_capacity, "game directory and output pointer are required");
        return LIVE_AUDIO_ERR_ARGUMENT;
    }
    if (!on_main_thread()) {
        set_error(error, error_capacity, "live audio must be created on the main thread");
        return LIVE_AUDIO_ERR_THREAD;
    }
    if (config->mode != MAC_AUDIO_MODE_OUTPUT && config->mode != MAC_AUDIO_MODE_OFFLINE) {
        set_error(error, error_capacity, "unknown audio mode");
        return LIVE_AUDIO_ERR_ARGUMENT;
    }
    rate = config->offline_sample_rate != 0u ? config->offline_sample_rate
                                             : LIVE_AUDIO_DEFAULT_OFFLINE_SAMPLE_RATE;
    channels = config->offline_channels != 0u ? config->offline_channels
                                              : LIVE_AUDIO_DEFAULT_OFFLINE_CHANNELS;
    if (config->mode == MAC_AUDIO_MODE_OFFLINE && (channels < 1u || channels > 2u)) {
        set_error(error, error_capacity, "offline render must be mono or stereo");
        return LIVE_AUDIO_ERR_ARGUMENT;
    }
    audio = calloc(1u, sizeof(*audio));
    if (audio == NULL) {
        set_error(error, error_capacity, "allocation failed");
        return LIVE_AUDIO_ERR_MEMORY;
    }
    if (config->host_ops != NULL) {
        audio->ops = *config->host_ops;
    } else {
        live_audio_default_host_ops(&audio->ops);
    }
    if (!ops_complete(&audio->ops)) {
        free(audio);
        set_error(error, error_capacity, "host operations are incomplete");
        return LIVE_AUDIO_ERR_ARGUMENT;
    }
    audio->game_directory = strdup(config->game_directory);
    if (audio->game_directory == NULL) {
        free(audio);
        set_error(error, error_capacity, "allocation failed");
        return LIVE_AUDIO_ERR_MEMORY;
    }
    audio->mode = config->mode;
    audio->log = config->log;
    audio->log_context = config->log_context;
    audio->offline_sample_rate = config->mode == MAC_AUDIO_MODE_OFFLINE ? rate : 0u;
    audio->offline_channels = config->mode == MAC_AUDIO_MODE_OFFLINE ? channels : 0u;
    for (index = 0u; index < LIVE_AUDIO_CATEGORY_COUNT; ++index) audio->category_scalar[index] = 1.0f;
    for (index = 0u; index < LIVE_AUDIO_CHANNEL_COUNT; ++index) {
        audio->channels[index].audio = (HisAudio)HIS_AUDIO_INIT;
        audio->channels[index].host_slot = host_slot_for((uint16_t)index, 0u);
    }
    status = audio->ops.open(config->mode, audio->offline_sample_rate, audio->offline_channels,
                             &audio->host, host_error, sizeof(host_error));
    if (status != MAC_AUDIO_OK || audio->host == NULL) {
        set_error(error, error_capacity, "audio host open failed: %s (%s)",
                  mac_audio_status_string(status), host_error);
        free(audio->game_directory);
        free(audio);
        return LIVE_AUDIO_ERR_HOST;
    }
    *audio_out = audio;
    return LIVE_AUDIO_OK;
}

int live_audio_destroy(LiveAudio *audio)
{
    unsigned index;
    char error[256] = "";
    int status;

    if (audio == NULL) return LIVE_AUDIO_OK;
    if (!on_main_thread()) return LIVE_AUDIO_ERR_THREAD;
    for (index = 0u; index < LIVE_AUDIO_CHANNEL_COUNT; ++index) (void)release_channel(audio, (uint16_t)index);
    status = audio->ops.close(audio->host, error, sizeof(error));
    if (status != MAC_AUDIO_OK) logf_line(audio, "live_audio close_failed status=%d detail=%s", status, error);
    free(audio->game_directory);
    free(audio);
    return status == MAC_AUDIO_OK ? LIVE_AUDIO_OK : LIVE_AUDIO_ERR_HOST;
}

int live_audio_bind_backend(LiveAudio *audio, ActionSoundBackend *backend)
{
    if (audio == NULL || backend == NULL) return LIVE_AUDIO_ERR_ARGUMENT;
    backend->context = audio;
    backend->load_sound = live_audio_load_sound;
    backend->play_sound = live_audio_play_sound;
    backend->is_playing = live_audio_is_playing;
    backend->unload_sound = live_audio_unload_sound;
    return LIVE_AUDIO_OK;
}

/* ---- sound callbacks ----------------------------------------------------- */
static int gain_is_valid(float value)
{
    return isfinite(value) && value >= 0.0f && value <= 1.0f;
}

ActionSoundBackendStatus live_audio_load_sound(void *context,
                                               const ActionSoundAudioCommand *command)
{
    LiveAudio *audio = context;
    Channel *channel;
    size_t stem_length = 0u;
    char *path = NULL;
    char error[512] = "";
    HisAudio decoded = HIS_AUDIO_INIT;
    ResolveStatus resolved;
    int status;

    if (audio == NULL || command == NULL || !on_main_thread()) return ACTION_SOUND_BACKEND_ERROR;
    if (command->channel >= LIVE_AUDIO_CHANNEL_COUNT) {
        logf_line(audio, "live_audio load_rejected reason=channel-out-of-range channel=%u", command->channel);
        return ACTION_SOUND_BACKEND_ERROR;
    }
    if (memchr(command->asset_stem, '\0', sizeof(command->asset_stem)) == NULL ||
        !stem_is_valid(command->asset_stem, &stem_length)) {
        logf_line(audio, "live_audio load_rejected reason=malformed-stem channel=%u", command->channel);
        return ACTION_SOUND_BACKEND_ERROR;
    }
    if (command->volume_category >= LIVE_AUDIO_CATEGORY_COUNT ||
        !gain_is_valid(command->first_gain) || !gain_is_valid(command->second_gain)) {
        logf_line(audio, "live_audio load_rejected reason=bad-category-or-gain channel=%u category=%u",
                  command->channel, command->volume_category);
        return ACTION_SOUND_BACKEND_ERROR;
    }

    channel = &audio->channels[command->channel];
    /* Reloading replaces whatever the channel held, whether or not the new
     * sound can be found. */
    (void)release_channel(audio, command->channel);

    if (stem_length == 0u) {
        logf_line(audio, "live_audio no_resource stem=<empty> channel=%u", command->channel);
        return ACTION_SOUND_BACKEND_NO_RESOURCE;
    }
    resolved = resolve_asset(audio, command->asset_stem, stem_length, &path);
    if (resolved == RESOLVE_MISSING) {
        logf_line(audio, "live_audio no_resource stem=%s channel=%u", command->asset_stem, command->channel);
        return ACTION_SOUND_BACKEND_NO_RESOURCE;
    }
    if (resolved == RESOLVE_AMBIGUOUS) {
        logf_line(audio, "live_audio load_failed reason=ambiguous-asset stem=%s channel=%u",
                  command->asset_stem, command->channel);
        return ACTION_SOUND_BACKEND_ERROR;
    }
    if (resolved != RESOLVE_FOUND) {
        logf_line(audio, "live_audio load_failed reason=directory-scan stem=%s channel=%u",
                  command->asset_stem, command->channel);
        return ACTION_SOUND_BACKEND_ERROR;
    }
    status = his_audio_decode_file(path, &decoded, error, sizeof(error));
    free(path);
    if (status != HIS_AUDIO_OK) {
        logf_line(audio, "live_audio decode_failed stem=%s channel=%u status=%s detail=%s",
                  command->asset_stem, command->channel, his_audio_status_string(status), error);
        his_audio_destroy(&decoded);
        return ACTION_SOUND_BACKEND_ERROR;
    }
    if (decoded.frame_count == 0u || decoded.channels < 1u || decoded.channels > 2u ||
        decoded.interleaved_pcm == NULL) {
        logf_line(audio, "live_audio decode_failed stem=%s channel=%u reason=unsupported-pcm-shape",
                  command->asset_stem, command->channel);
        his_audio_destroy(&decoded);
        return ACTION_SOUND_BACKEND_ERROR;
    }

    /* The AVAudioEngine graph is stereo and its mono-to-stereo centre pan
     * attenuates a mono source by 1/sqrt(2); the host caps gain at 1.0 so it
     * cannot be compensated afterwards. Duplicate mono into both channels so a
     * mono HIS (NSHT01) plays at unity, as a DirectSound centre would. */
    if (decoded.channels == 1u) {
        float *stereo;
        if (decoded.frame_count > SIZE_MAX / (2u * sizeof(float))) {
            his_audio_destroy(&decoded);
            return ACTION_SOUND_BACKEND_ERROR;
        }
        stereo = malloc((size_t)decoded.frame_count * 2u * sizeof(float));
        if (stereo == NULL) {
            his_audio_destroy(&decoded);
            return ACTION_SOUND_BACKEND_ERROR;
        }
        for (uint64_t frame = 0; frame < decoded.frame_count; ++frame) {
            stereo[frame * 2u] = decoded.interleaved_pcm[frame];
            stereo[frame * 2u + 1u] = decoded.interleaved_pcm[frame];
        }
        free(decoded.interleaved_pcm);
        decoded.interleaved_pcm = stereo;
        decoded.channels = 2u;
    }

    channel->audio = decoded;
    channel->loaded = 1u;
    channel->volume_category = command->volume_category;
    channel->mode = command->mode;
    channel->control_word = command->control_word;
    channel->first_percent = command->first_percent;
    channel->second_percent = command->second_percent;
    channel->first_gain = command->first_gain;
    channel->second_gain = command->second_gain;
    ++channel->load_serial;
    channel->host_slot = host_slot_for(command->channel, channel->load_serial);
    refresh_gain(audio, channel);
    logf_line(audio, "live_audio loaded stem=%s channel=%u frames=%llu rate=%u channels=%u category=%u "
              "control_word=0x%08x%s gain=%.6f",
              command->asset_stem, command->channel, (unsigned long long)decoded.frame_count,
              decoded.sample_rate, decoded.channels, command->volume_category, command->control_word,
              command->control_word == 0u ? " restart-on-completion=unsupported" : "",
              (double)channel->final_gain);
    return ACTION_SOUND_BACKEND_OK;
}

ActionSoundBackendStatus live_audio_play_sound(void *context, uint16_t index)
{
    LiveAudio *audio = context;
    Channel *channel;
    char error[256] = "";
    int status;

    if (audio == NULL || !on_main_thread() || index >= LIVE_AUDIO_CHANNEL_COUNT)
        return ACTION_SOUND_BACKEND_ERROR;
    channel = &audio->channels[index];
    if (!channel->loaded) {
        logf_line(audio, "live_audio play_rejected reason=channel-not-loaded channel=%u", index);
        return ACTION_SOUND_BACKEND_ERROR;
    }
    channel->finished = 0u;
    status = audio->ops.play(audio->host, channel->host_slot, channel->audio.interleaved_pcm,
                             channel->audio.frame_count, channel->audio.channels,
                             channel->audio.sample_rate, channel->final_gain, 0, error, sizeof(error));
    if (status != MAC_AUDIO_OK) {
        logf_line(audio, "live_audio play_failed channel=%u slot=%u status=%d detail=%s", index,
                  channel->host_slot, status, error);
        (void)audio->ops.stop(audio->host, channel->host_slot, error, sizeof(error));
        channel->started = 0u;
        /* The original play wrapper logs a device failure and carries on; the
         * channel then reads as not playing, so the action advances. A missing
         * output device must not end the game. */
        return ACTION_SOUND_BACKEND_NO_RESOURCE;
    }
    channel->started = 1u;
    channel->play_mark = audio->offline_frames_rendered;
    audio->host_played = 1u;
    return ACTION_SOUND_BACKEND_OK;
}

ActionSoundBackendStatus live_audio_is_playing(void *context, uint16_t index, int *still_playing)
{
    LiveAudio *audio = context;
    Channel *channel;
    char error[256] = "";
    int host_playing = 0;
    int status;

    if (still_playing != NULL) *still_playing = 0;
    if (audio == NULL || still_playing == NULL || !on_main_thread() ||
        index >= LIVE_AUDIO_CHANNEL_COUNT)
        return ACTION_SOUND_BACKEND_ERROR;
    channel = &audio->channels[index];
    if (!channel->loaded || !channel->started || channel->finished) return ACTION_SOUND_BACKEND_OK;
    status = audio->ops.is_playing(audio->host, channel->host_slot, &host_playing, error, sizeof(error));
    if (status != MAC_AUDIO_OK) {
        logf_line(audio, "live_audio poll_failed channel=%u slot=%u status=%d detail=%s", index,
                  channel->host_slot, status, error);
        return ACTION_SOUND_BACKEND_ERROR;
    }
    if (host_playing == 0) {
        channel->finished = 1u;
        return ACTION_SOUND_BACKEND_OK;
    }
    *still_playing = 1;
    return ACTION_SOUND_BACKEND_OK;
}

int live_audio_unload_all(LiveAudio *audio)
{
    uint16_t index;
    int result = LIVE_AUDIO_OK;

    if (audio == NULL) return LIVE_AUDIO_ERR_ARGUMENT;
    if (!on_main_thread()) return LIVE_AUDIO_ERR_THREAD;
    for (index = 0u; index < LIVE_AUDIO_CHANNEL_COUNT; ++index)
        if (audio->channels[index].loaded && release_channel(audio, index) != MAC_AUDIO_OK)
            result = LIVE_AUDIO_ERR_HOST;
    return result;
}

ActionSoundBackendStatus live_audio_unload_sound(void *context, uint16_t index)
{
    LiveAudio *audio = context;

    if (audio == NULL || !on_main_thread() || index >= LIVE_AUDIO_CHANNEL_COUNT)
        return ACTION_SOUND_BACKEND_ERROR;
    return release_channel(audio, index) == MAC_AUDIO_OK ? ACTION_SOUND_BACKEND_OK
                                                         : ACTION_SOUND_BACKEND_ERROR;
}

int live_audio_stop_channel(LiveAudio *audio, uint16_t index)
{
    Channel *channel;
    char error[256] = "";
    int status = MAC_AUDIO_OK;

    if (audio == NULL || index >= LIVE_AUDIO_CHANNEL_COUNT) return LIVE_AUDIO_ERR_ARGUMENT;
    if (!on_main_thread()) return LIVE_AUDIO_ERR_THREAD;
    channel = &audio->channels[index];
    if (channel->started)
        status = audio->ops.stop(audio->host, channel->host_slot, error, sizeof(error));
    channel->started = 0u;
    channel->finished = 0u;
    ++channel->generation;
    if (status != MAC_AUDIO_OK) {
        logf_line(audio, "live_audio stop_failed channel=%u status=%d detail=%s", index, status, error);
        return LIVE_AUDIO_ERR_HOST;
    }
    return LIVE_AUDIO_OK;
}

/* ---- gain table and inspection ------------------------------------------ */
int live_audio_set_category_scalar(LiveAudio *audio, uint8_t category, float scalar)
{
    unsigned index;
    int result = LIVE_AUDIO_OK;

    if (audio == NULL || category >= LIVE_AUDIO_CATEGORY_COUNT || !gain_is_valid(scalar))
        return LIVE_AUDIO_ERR_ARGUMENT;
    if (!on_main_thread()) return LIVE_AUDIO_ERR_THREAD;
    audio->category_scalar[category] = scalar;
    for (index = 0u; index < LIVE_AUDIO_CHANNEL_COUNT; ++index) {
        Channel *channel = &audio->channels[index];
        char error[256] = "";

        if (!channel->loaded || channel->volume_category != category) continue;
        refresh_gain(audio, channel);
        if (channel->started && !channel->finished) {
            int status = audio->ops.set_gain(audio->host, channel->host_slot, channel->final_gain,
                                             error, sizeof(error));
            if (status != MAC_AUDIO_OK) {
                logf_line(audio, "live_audio set_gain_failed channel=%u status=%d detail=%s", index,
                          status, error);
                result = LIVE_AUDIO_ERR_HOST;
            }
        }
    }
    return result;
}

int live_audio_get_category_scalar(const LiveAudio *audio, uint8_t category, float *scalar)
{
    if (audio == NULL || scalar == NULL || category >= LIVE_AUDIO_CATEGORY_COUNT)
        return LIVE_AUDIO_ERR_ARGUMENT;
    *scalar = audio->category_scalar[category];
    return LIVE_AUDIO_OK;
}

int live_audio_get_channel_info(const LiveAudio *audio, uint16_t index, LiveAudioChannelInfo *info)
{
    const Channel *channel;

    if (audio == NULL || info == NULL || index >= LIVE_AUDIO_CHANNEL_COUNT) return LIVE_AUDIO_ERR_ARGUMENT;
    channel = &audio->channels[index];
    memset(info, 0, sizeof(*info));
    info->loaded = channel->loaded;
    info->started = channel->started;
    info->finished = channel->finished;
    info->generation = channel->generation;
    info->host_slot = channel->host_slot;
    if (!channel->loaded) return LIVE_AUDIO_OK;
    info->volume_category = channel->volume_category;
    info->control_word = channel->control_word;
    info->mode = channel->mode;
    info->first_percent = channel->first_percent;
    info->second_percent = channel->second_percent;
    info->first_gain = channel->first_gain;
    info->second_gain = channel->second_gain;
    info->category_scalar = audio->category_scalar[channel->volume_category];
    info->final_gain = channel->final_gain;
    info->sample_rate = channel->audio.sample_rate;
    info->channels = channel->audio.channels;
    info->frame_count = channel->audio.frame_count;
    info->reference_first_attenuation = channel->reference_first_attenuation;
    info->reference_first_attenuation_valid = channel->reference_first_attenuation_valid;
    return LIVE_AUDIO_OK;
}

/* ---- offline rendering --------------------------------------------------- */
int live_audio_offline_format(const LiveAudio *audio, uint32_t *sample_rate, uint32_t *channels)
{
    if (audio == NULL || sample_rate == NULL || channels == NULL) return LIVE_AUDIO_ERR_ARGUMENT;
    if (audio->mode != MAC_AUDIO_MODE_OFFLINE) return LIVE_AUDIO_ERR_MODE;
    *sample_rate = audio->offline_sample_rate;
    *channels = audio->offline_channels;
    return LIVE_AUDIO_OK;
}

uint64_t live_audio_offline_frames_rendered(const LiveAudio *audio)
{
    return audio != NULL ? audio->offline_frames_rendered : 0u;
}

/* The host reports natural completion from its own callback thread, a moment
 * after the render that consumed the last frame. Once the frames rendered
 * since a channel started cover its length, wait (bounded) for that flip so a
 * headless run observes completion on the same tick every time. */
static void settle_completions(LiveAudio *audio)
{
    uint16_t index;

    for (index = 0u; index < LIVE_AUDIO_CHANNEL_COUNT; ++index) {
        Channel *channel = &audio->channels[index];
        uint64_t needed;
        unsigned attempt;

        if (!channel->loaded || !channel->started || channel->finished ||
            channel->audio.sample_rate == 0u)
            continue;
        needed = (channel->audio.frame_count * audio->offline_sample_rate +
                  channel->audio.sample_rate - 1u) / channel->audio.sample_rate;
        if (audio->offline_frames_rendered - channel->play_mark < needed) continue;
        for (attempt = 0u; attempt < 100u; ++attempt) {
            char error[64] = "";
            int playing = 1;

            if (audio->ops.is_playing(audio->host, channel->host_slot, &playing, error,
                                      sizeof(error)) != MAC_AUDIO_OK || playing == 0)
                break;
            usleep(1000u);
        }
    }
}

int live_audio_advance_offline(LiveAudio *audio, uint64_t frames, LiveAudioOfflineStats *stats,
                               float *capture, uint64_t capture_capacity_frames)
{
    uint64_t remaining = frames;
    uint64_t captured = 0u;

    if (stats != NULL) memset(stats, 0, sizeof(*stats));
    if (audio == NULL || (capture == NULL && capture_capacity_frames != 0u)) return LIVE_AUDIO_ERR_ARGUMENT;
    if (!on_main_thread()) return LIVE_AUDIO_ERR_THREAD;
    if (audio->mode != MAC_AUDIO_MODE_OFFLINE) return LIVE_AUDIO_ERR_MODE;
    if (!audio->host_played) {
        if (capture != NULL && capture_capacity_frames != 0u) {
            uint64_t zero = frames < capture_capacity_frames ? frames : capture_capacity_frames;
            memset(capture, 0, (size_t)zero * audio->offline_channels * sizeof(float));
        }
        audio->offline_frames_rendered += frames;
        if (stats != NULL) stats->frames = frames;
        return LIVE_AUDIO_OK;
    }
    while (remaining > 0u) {
        uint32_t chunk = remaining > LIVE_AUDIO_RENDER_CHUNK_FRAMES ? LIVE_AUDIO_RENDER_CHUNK_FRAMES
                                                                    : (uint32_t)remaining;
        MacAudioRender render = MAC_AUDIO_RENDER_INIT;
        char error[256] = "";
        size_t samples;
        size_t index;
        int status = audio->ops.render_offline(audio->host, chunk, &render, error, sizeof(error));

        if (status != MAC_AUDIO_OK) {
            logf_line(audio, "live_audio render_failed status=%d detail=%s", status, error);
            return LIVE_AUDIO_ERR_HOST;
        }
        if (render.frame_count != chunk || render.channels != audio->offline_channels ||
            render.interleaved_pcm == NULL) {
            logf_line(audio, "live_audio render_failed reason=unexpected-render-shape");
            audio->ops.render_destroy(&render);
            return LIVE_AUDIO_ERR_HOST;
        }
        samples = (size_t)chunk * render.channels;
        for (index = 0u; index < samples; ++index) {
            float sample = render.interleaved_pcm[index];
            if (!isfinite(sample)) {
                if (stats != NULL) ++stats->nonfinite_samples;
                continue;
            }
            if (stats != NULL) {
                double magnitude = fabs((double)sample);
                if (sample != 0.0f) ++stats->nonzero_samples;
                if (magnitude > stats->peak) stats->peak = magnitude;
                stats->sum_squares += (double)sample * (double)sample;
            }
        }
        if (capture != NULL && captured < capture_capacity_frames) {
            uint64_t room = capture_capacity_frames - captured;
            uint64_t copy = room < chunk ? room : chunk;
            memcpy(capture + captured * render.channels, render.interleaved_pcm,
                   (size_t)copy * render.channels * sizeof(float));
            captured += copy;
        }
        audio->ops.render_destroy(&render);
        audio->offline_frames_rendered += chunk;
        if (stats != NULL) stats->frames += chunk;
        remaining -= chunk;
    }
    settle_completions(audio);
    return LIVE_AUDIO_OK;
}

const char *live_audio_status_string(int status)
{
    switch (status) {
    case LIVE_AUDIO_OK: return "ok";
    case LIVE_AUDIO_ERR_ARGUMENT: return "invalid argument";
    case LIVE_AUDIO_ERR_THREAD: return "wrong thread";
    case LIVE_AUDIO_ERR_MODE: return "operation unavailable in this mode";
    case LIVE_AUDIO_ERR_HOST: return "audio host failure";
    case LIVE_AUDIO_ERR_MEMORY: return "allocation failed";
    default: return "unknown live audio status";
    }
}
