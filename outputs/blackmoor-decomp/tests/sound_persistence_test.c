/* Real provider, synthetic HIS assets and a device-free recording mixer. */
#define main rt1_fixture_main
#include "live_audio_fixture.c"
#undef main
#include "session_exit.h"
#include <assert.h>

static void scenario(LiveAudio *audio, int16_t flag, uint16_t special)
{
    SessionExit x;
    SessionExitAudioPlan plan;
    ActionFamily28Rect view = {0, 0, 639, 479};
    LiveAudioChannelInfo before[32], after;
    assert(session_exit_init(&x, &view) == 0);
    x.g.game_state = SESSION_EXIT_STATE_LOAD;
    x.g.scene_request_flag = flag;
    assert(session_exit_begin_load(&x) == 0);
    for (uint16_t i = 0; i < 32; ++i) {
        ActionSoundAudioCommand cmd = make_command("Tone", i, (uint8_t)(i % 4), 1, 1, 1);
        cmd.mode = (uint8_t)(i % 3); /* Reset is independent of mode/category. */
        assert(live_audio_load_sound(audio, &cmd) == ACTION_SOUND_BACKEND_OK);
        if (i % 2) assert(live_audio_play_sound(audio, i) == ACTION_SOUND_BACKEND_OK);
        assert(live_audio_get_channel_info(audio, i, &before[i]) == 0);
    }
    g_fake->event_count = 0; /* Bound the recording log independently per edge. */
    int stops_before = fake_count(g_fake, 'S');
    int gains_before = fake_count(g_fake, 'G');
    assert(session_exit_plan_audio(&x, special, &plan) == 0);
    assert(live_audio_unload_channels(audio, plan.channels, plan.count) == 0);
    int expected_stops = 0;
    for (uint16_t i = 0; i < 32; ++i) {
        int reset = flag == 0 && (i < 14 || i == special);
        assert(live_audio_get_channel_info(audio, i, &after) == 0);
        if (reset) {
            assert(!after.loaded && !after.started);
            assert(after.generation > before[i].generation);
            expected_stops += i % 2;
        } else {
            assert(memcmp(&before[i], &after, sizeof(after)) == 0);
            if (i % 2) assert(playing(audio, i));
        }
    }
    assert(fake_count(g_fake, 'S') - stops_before == expected_stops);
    assert(fake_count(g_fake, 'G') == gains_before); /* No transition fade. */
}

/* Host failure: the mixer refuses Stop for one channel's slot. The original
 * loop has no error branch (0x4fb041..0x4fb06b ignores each unload), so the
 * remaining channels in the ordered plan must still be released; the failure
 * is only surfaced to the caller as LIVE_AUDIO_ERR_HOST. */
static uint32_t g_fail_slot = 0xffffffffu;
static int g_failed_stops;
static int failing_stop(MacAudioHost *host, uint32_t slot, char *error, size_t capacity)
{
    if (slot == g_fail_slot) {
        ++g_failed_stops;
        return MAC_AUDIO_ERR_ENGINE;
    }
    return fake_stop(host, slot, error, capacity);
}

static void host_failure(const char *game_dir)
{
    LiveAudio *audio = NULL;
    LiveAudioHostOps ops = fake_ops();
    LiveAudioConfig config = {0};
    SessionExit x;
    SessionExitAudioPlan plan;
    ActionFamily28Rect view = {0, 0, 639, 479};
    LiveAudioChannelInfo before[32], after;
    char error[128];
    ops.stop = failing_stop;
    config.game_directory = game_dir;
    config.mode = MAC_AUDIO_MODE_OFFLINE;
    config.host_ops = &ops;
    assert(live_audio_create(&config, &audio, error, sizeof(error)) == 0);
    assert(session_exit_init(&x, &view) == 0);
    x.g.game_state = SESSION_EXIT_STATE_LOAD;
    x.g.scene_request_flag = 0;
    assert(session_exit_begin_load(&x) == 0);
    for (uint16_t i = 0; i < 32; ++i) {
        ActionSoundAudioCommand cmd = make_command("Tone", i, (uint8_t)(i % 4), 1, 1, 1);
        assert(live_audio_load_sound(audio, &cmd) == ACTION_SOUND_BACKEND_OK);
        assert(live_audio_play_sound(audio, i) == ACTION_SOUND_BACKEND_OK);
        assert(live_audio_get_channel_info(audio, i, &before[i]) == 0);
    }
    g_fail_slot = before[5].host_slot; /* inside 0..13, between two good stops */
    g_failed_stops = 0;
    assert(session_exit_plan_audio(&x, 27, &plan) == 0);
    assert(live_audio_unload_channels(audio, plan.channels, plan.count) == LIVE_AUDIO_ERR_HOST);
    assert(g_failed_stops == 1);
    for (uint16_t i = 0; i < 32; ++i) {
        int reset = i < 14 || i == 27;
        assert(live_audio_get_channel_info(audio, i, &after) == 0);
        if (reset) {
            /* A refused Stop still releases the channel: no stale loaded slot. */
            assert(!after.loaded && !after.started);
            assert(after.generation == before[i].generation + 1u);
        } else {
            assert(memcmp(&before[i], &after, sizeof(after)) == 0);
        }
    }
    g_fail_slot = 0xffffffffu;
    assert(live_audio_destroy(audio) == 0);
    fake_free();
}

int main(int argc, char **argv)
{
    LiveAudio *audio = NULL;
    LiveAudioHostOps ops = fake_ops();
    LiveAudioConfig config = {0};
    char error[128];
    assert(argc == 2);
    config.game_directory = argv[1];
    config.mode = MAC_AUDIO_MODE_OFFLINE;
    config.host_ops = &ops;
    assert(live_audio_create(&config, &audio, error, sizeof(error)) == 0);
    /* S0->5900, 5900->5907, 5907->5901..5906, 5906->4700,
     * 4700->4710->4701. The scenario asserts all 32 channels at every edge. */
    const int16_t flags[] = {0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1};
    for (size_t i = 0; i < sizeof(flags) / sizeof(flags[0]); ++i)
        scenario(audio, flags[i], 27); /* Owned BOOT MSND channel. */
    scenario(audio, -1, 19);
    scenario(audio, 0, 7); /* duplicate MSND channel in 0..13 */
    scenario(audio, 0, 31);
    scenario(audio, 1, 19);
    /* Validation occurs before the first release. */
    const uint16_t bad[] = {0, 32};
    LiveAudioChannelInfo before, after;
    assert(live_audio_get_channel_info(audio, 0, &before) == 0);
    assert(live_audio_unload_channels(audio, bad, 2) == LIVE_AUDIO_ERR_ARGUMENT);
    assert(live_audio_unload_channels(audio, NULL, 1) == LIVE_AUDIO_ERR_ARGUMENT);
    assert(live_audio_unload_channels(audio, NULL, 0) == LIVE_AUDIO_OK);
    assert(live_audio_get_channel_info(audio, 0, &after) == 0);
    assert(memcmp(&before, &after, sizeof(after)) == 0);
    assert(live_audio_destroy(audio) == 0);
    fake_free();
    host_failure(argv[1]);
    puts("RT-11 scenarios passed: 15 edges, all 32 channels, reset subset, mode/category independence, no fade, host stop failure");
    return 0;
}
