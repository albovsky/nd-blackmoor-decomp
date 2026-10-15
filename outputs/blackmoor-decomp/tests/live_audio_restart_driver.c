/* RT-11.1 oracle driver: runs scripted scenarios against live_audio over a
 * substitute host and prints every ordered host effect and the update state
 * of every loaded channel after each command, for comparison with the
 * original x86 pump running under Unicorn
 * (tests/live_audio_restart_original_oracle.py).
 *
 * usage: live_audio_restart_driver <game_dir>   (commands on stdin)
 *
 *   load <channel> <control> <stem>   flags <channel> <hex>   rand <value>
 *   play <channel>   complete <channel>   stop <channel>   unload <channel>
 *   pump <tick>
 *
 * Output per command: "E play <channel> <loop>" / "E random <value>" lines in
 * call order, then "S <channel> <marker> <delay> <due> <gate287> <loaded>
 * <playing>" for every loaded channel, then "END". The substitute host stands
 * in only for the AVAudioEngine boundary. */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_sound.h"
#include "live_audio.h"
#include "macos_audio.h"

typedef struct FakeHost { int active[64]; } FakeHost;
static FakeHost *g_host;
static uint32_t g_random_value;

static int fake_open(MacAudioMode mode, uint32_t rate, uint32_t channels, MacAudioHost **host,
                     char *error, size_t capacity)
{
    (void)mode; (void)rate; (void)channels; (void)error; (void)capacity;
    g_host = calloc(1, sizeof(*g_host));
    if (g_host == NULL) return MAC_AUDIO_ERR_MEMORY;
    *host = (MacAudioHost *)g_host;
    return MAC_AUDIO_OK;
}
static int fake_close(MacAudioHost *host, char *error, size_t capacity)
{ (void)host; (void)error; (void)capacity; return MAC_AUDIO_OK; }
static int fake_play(MacAudioHost *host, uint32_t slot, const float *pcm, uint64_t frames,
                     uint32_t channels, uint32_t rate, float gain, int loop, char *error,
                     size_t capacity)
{
    (void)pcm; (void)frames; (void)channels; (void)rate; (void)gain; (void)error; (void)capacity;
    ((FakeHost *)host)->active[slot] = 1;
    printf("E play %u %d\n", slot % LIVE_AUDIO_CHANNEL_COUNT, loop);
    return MAC_AUDIO_OK;
}
static int fake_stop(MacAudioHost *host, uint32_t slot, char *error, size_t capacity)
{ (void)error; (void)capacity; ((FakeHost *)host)->active[slot] = 0; return MAC_AUDIO_OK; }
static int fake_set_gain(MacAudioHost *host, uint32_t slot, float gain, char *error, size_t capacity)
{ (void)host; (void)slot; (void)gain; (void)error; (void)capacity; return MAC_AUDIO_OK; }
static int fake_is_playing(MacAudioHost *host, uint32_t slot, int *playing, char *error,
                           size_t capacity)
{ (void)error; (void)capacity; *playing = ((FakeHost *)host)->active[slot]; return MAC_AUDIO_OK; }
static int fake_render(MacAudioHost *host, uint32_t frames, MacAudioRender *render, char *error,
                       size_t capacity)
{ (void)host; (void)frames; (void)render; (void)error; (void)capacity; return MAC_AUDIO_ERR_MODE; }
static void fake_render_destroy(MacAudioRender *render) { (void)render; }

static uint32_t random_source(void *context)
{
    (void)context;
    printf("E random %u\n", g_random_value);
    return g_random_value;
}

static void print_state(LiveAudio *audio)
{
    for (uint16_t channel = 0; channel < LIVE_AUDIO_CHANNEL_COUNT; ++channel) {
        LiveAudioChannelInfo info;
        int playing = 0;
        if (live_audio_get_channel_info(audio, channel, &info) != LIVE_AUDIO_OK || !info.loaded) continue;
        /* playing is read from the host directly so the state print has no
         * side effect on the completion latch */
        playing = g_host->active[info.host_slot];
        printf("S %u %u %u %u %u %u %d\n", channel, info.repeat_marker, info.repeat_delay,
               info.repeat_due_tick, info.update_gate_287, info.loaded, playing);
    }
    printf("END\n");
    fflush(stdout);
}

int main(int argc, char **argv)
{
    LiveAudioHostOps ops;
    LiveAudioConfig config;
    LiveAudio *audio = NULL;
    char error[256] = "";
    char line[256];

    if (argc < 2) { fprintf(stderr, "usage: %s <game_dir>\n", argv[0]); return 2; }
    memset(&ops, 0, sizeof(ops));
    ops.open = fake_open; ops.close = fake_close; ops.play = fake_play; ops.stop = fake_stop;
    ops.set_gain = fake_set_gain; ops.is_playing = fake_is_playing;
    ops.render_offline = fake_render; ops.render_destroy = fake_render_destroy;
    memset(&config, 0, sizeof(config));
    config.game_directory = argv[1];
    config.mode = MAC_AUDIO_MODE_OFFLINE;
    config.offline_sample_rate = 48000u;
    config.offline_channels = 2u;
    config.host_ops = &ops;
    config.random_value = random_source;
    if (live_audio_create(&config, &audio, error, sizeof(error)) != LIVE_AUDIO_OK) {
        fprintf(stderr, "create failed: %s\n", error);
        return 1;
    }
    while (fgets(line, sizeof(line), stdin) != NULL) {
        char verb[16] = "", stem[64] = "";
        unsigned channel = 0, control = 0, flags = 0, value = 0;
        int status = 0;
        LiveAudioChannelInfo info;
        if (sscanf(line, "%15s", verb) != 1) continue;
        if (strcmp(verb, "load") == 0 && sscanf(line, "%*s %u %u %63s", &channel, &control, stem) == 3) {
            ActionSoundAudioCommand command;
            memset(&command, 0, sizeof(command));
            snprintf(command.asset_stem, sizeof(command.asset_stem), "%s", stem);
            command.channel = (uint16_t)channel;
            command.volume_category = 2;
            command.control_word = control;
            command.first_gain = command.second_gain = 1.0f;
            command.first_percent = command.second_percent = 100;
            status = live_audio_load_sound(audio, &command) == ACTION_SOUND_BACKEND_OK ? 0 : 1;
        } else if (strcmp(verb, "flags") == 0 && sscanf(line, "%*s %u %x", &channel, &flags) == 2) {
            status = live_audio_set_channel_flags(audio, (uint16_t)channel, (uint16_t)flags);
        } else if (strcmp(verb, "rand") == 0 && sscanf(line, "%*s %u", &value) == 1) {
            g_random_value = value;
        } else if (strcmp(verb, "play") == 0 && sscanf(line, "%*s %u", &channel) == 1) {
            status = live_audio_play_sound(audio, (uint16_t)channel) == ACTION_SOUND_BACKEND_OK ? 0 : 1;
        } else if (strcmp(verb, "complete") == 0 && sscanf(line, "%*s %u", &channel) == 1) {
            if (live_audio_get_channel_info(audio, (uint16_t)channel, &info) == LIVE_AUDIO_OK)
                g_host->active[info.host_slot] = 0;
        } else if (strcmp(verb, "stop") == 0 && sscanf(line, "%*s %u", &channel) == 1) {
            status = live_audio_stop_channel(audio, (uint16_t)channel);
        } else if (strcmp(verb, "unload") == 0 && sscanf(line, "%*s %u", &channel) == 1) {
            status = live_audio_unload_sound(audio, (uint16_t)channel) == ACTION_SOUND_BACKEND_OK ? 0 : 1;
        } else if (strcmp(verb, "pump") == 0 && sscanf(line, "%*s %u", &value) == 1) {
            status = live_audio_service(audio, value, NULL);
        } else {
            fprintf(stderr, "bad command: %s", line);
            return 2;
        }
        printf("R %d\n", status);
        print_state(audio);
    }
    (void)live_audio_destroy(audio);
    return 0;
}
