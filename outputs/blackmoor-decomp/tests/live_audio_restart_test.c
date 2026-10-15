/* RT-11.1: completed-channel restart (original 0x4f55d5 via the 0x4f52a9
 * pump) and the 0x4f7207 delayed-repeat pass, over a substitute host.
 *
 * usage: live_audio_restart_test <fixture_dir> [list | test...]
 *
 * <fixture_dir> holds the synthetic CDSound tree of tests/test_live_audio.py
 * plus the four stream-threshold assets of tests/test_live_audio_restart.py.
 * Output: "TEST <name> PASS|FAIL <detail>" per test; nonzero exit on failure.
 *
 * The substitute host stands in only for the AVAudioEngine boundary: it
 * records every play (with its loop flag), stop and query, and a test marks
 * a slot finished to emulate the host's natural-completion report. */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_sound.h"
#include "live_audio.h"
#include "macos_audio.h"
#include "session_bindings_conditions_audio.h"

typedef struct Ctx { const char *dir; int failed; char detail[320]; } Ctx;

#define CHECK(ctx, cond) \
    do { if (!(cond) && !(ctx)->failed) { (ctx)->failed = 1; \
        snprintf((ctx)->detail, sizeof((ctx)->detail), "line %d: %s", __LINE__, #cond); } } while (0)

/* ---- substitute host ---------------------------------------------------- */
typedef struct FakeSlot { int active; int plays; int stops; int last_loop; int loop_plays; } FakeSlot;
typedef struct FakeHost {
    FakeSlot slots[64];
    char order[256];       /* "P<slot>" per play in call order */
    int order_count;
    int fail_play;
} FakeHost;
static FakeHost *g_host;

static int fake_open(MacAudioMode mode, uint32_t rate, uint32_t channels,
                     MacAudioHost **host, char *error, size_t capacity)
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
    FakeHost *h = (FakeHost *)host;
    (void)pcm; (void)frames; (void)channels; (void)rate; (void)gain; (void)error; (void)capacity;
    if (h->fail_play) return MAC_AUDIO_ERR_ENGINE;
    h->slots[slot].active = 1;
    ++h->slots[slot].plays;
    h->slots[slot].last_loop = loop;
    if (loop != 0) ++h->slots[slot].loop_plays;
    if (h->order_count < 250) h->order[h->order_count++] = (char)('0' + slot % 10);
    return MAC_AUDIO_OK;
}
static int fake_stop(MacAudioHost *host, uint32_t slot, char *error, size_t capacity)
{
    FakeHost *h = (FakeHost *)host;
    (void)error; (void)capacity;
    h->slots[slot].active = 0;
    ++h->slots[slot].stops;
    return MAC_AUDIO_OK;
}
static int fake_set_gain(MacAudioHost *host, uint32_t slot, float gain, char *error, size_t capacity)
{ (void)host; (void)slot; (void)gain; (void)error; (void)capacity; return MAC_AUDIO_OK; }
static int fake_is_playing(MacAudioHost *host, uint32_t slot, int *playing, char *error,
                           size_t capacity)
{
    (void)error; (void)capacity;
    *playing = ((FakeHost *)host)->slots[slot].active;
    return MAC_AUDIO_OK;
}
static int fake_render(MacAudioHost *host, uint32_t frames, MacAudioRender *render, char *error,
                       size_t capacity)
{ (void)host; (void)frames; (void)render; (void)error; (void)capacity; return MAC_AUDIO_ERR_MODE; }
static void fake_render_destroy(MacAudioRender *render) { (void)render; }

static uint32_t g_random_value;
static int g_random_draws;
static uint32_t fake_random(void *context)
{
    (void)context;
    ++g_random_draws;
    return g_random_value;
}

typedef struct Rig { LiveAudio *audio; } Rig;

static int rig_open(Ctx *ctx, Rig *rig, int with_random)
{
    LiveAudioHostOps ops;
    LiveAudioConfig config;
    char error[256] = "";
    memset(rig, 0, sizeof(*rig));
    memset(&ops, 0, sizeof(ops));
    ops.open = fake_open; ops.close = fake_close; ops.play = fake_play; ops.stop = fake_stop;
    ops.set_gain = fake_set_gain; ops.is_playing = fake_is_playing;
    ops.render_offline = fake_render; ops.render_destroy = fake_render_destroy;
    memset(&config, 0, sizeof(config));
    config.game_directory = ctx->dir;
    config.mode = MAC_AUDIO_MODE_OFFLINE;
    config.offline_sample_rate = 48000u;
    config.offline_channels = 2u;
    config.host_ops = &ops;
    if (with_random) config.random_value = fake_random;
    g_random_draws = 0;
    CHECK(ctx, live_audio_create(&config, &rig->audio, error, sizeof(error)) == LIVE_AUDIO_OK);
    return !ctx->failed;
}
static void rig_close(Rig *rig) { if (rig->audio != NULL) (void)live_audio_destroy(rig->audio); }

static ActionSoundAudioCommand command(const char *stem, uint16_t channel, uint32_t control)
{
    ActionSoundAudioCommand c;
    memset(&c, 0, sizeof(c));
    snprintf(c.asset_stem, sizeof(c.asset_stem), "%s", stem);
    c.channel = channel;
    c.volume_category = 2;
    c.control_word = control;
    c.first_gain = c.second_gain = 1.0f;
    c.first_percent = c.second_percent = 100;
    return c;
}

static int start(Rig *rig, const char *stem, uint16_t channel, uint32_t control)
{
    ActionSoundAudioCommand c = command(stem, channel, control);
    return live_audio_load_sound(rig->audio, &c) == ACTION_SOUND_BACKEND_OK &&
           live_audio_play_sound(rig->audio, channel) == ACTION_SOUND_BACKEND_OK;
}
static uint32_t slot_of(Rig *rig, uint16_t channel)
{
    LiveAudioChannelInfo info;
    memset(&info, 0, sizeof(info));
    (void)live_audio_get_channel_info(rig->audio, channel, &info);
    return info.host_slot;
}
static void finish(Rig *rig, uint16_t channel) { g_host->slots[slot_of(rig, channel)].active = 0; }
static int playing(Rig *rig, uint16_t channel)
{
    int p = -1;
    (void)live_audio_is_playing(rig->audio, channel, &p);
    return p;
}
static LiveAudioChannelInfo info_of(Rig *rig, uint16_t channel)
{
    LiveAudioChannelInfo info;
    memset(&info, 0, sizeof(info));
    (void)live_audio_get_channel_info(rig->audio, channel, &info);
    return info;
}
static LiveAudioServiceStats service(Rig *rig, uint32_t tick)
{
    LiveAudioServiceStats stats;
    memset(&stats, 0x5a, sizeof(stats));
    if (live_audio_service(rig->audio, tick, &stats) != LIVE_AUDIO_OK) memset(&stats, 0xff, sizeof(stats));
    return stats;
}

/* ---- the recovered rule -------------------------------------------------- */
static void t_control_zero_nonstream_restarts_after_completion(Ctx *ctx)
{
    Rig rig; LiveAudioServiceStats s; LiveAudioChannelInfo info; uint32_t slot;
    if (!rig_open(ctx, &rig, 1)) return;
    CHECK(ctx, start(&rig, "Tone", 4, 0));
    slot = slot_of(&rig, 4);
    info = info_of(&rig, 4);
    CHECK(ctx, info.stream_class == 0u && info.looping == 0u && info.raw_flags == 0u);
    CHECK(ctx, info.repeat_min == 500u && info.repeat_max == 2000u);
    CHECK(ctx, g_host->slots[slot].plays == 1 && g_host->slots[slot].last_loop == 0);
    s = service(&rig, 100u);                       /* still playing: nothing */
    CHECK(ctx, s.completions == 0u && s.restarts == 0u && g_host->slots[slot].plays == 1);
    finish(&rig, 4);
    s = service(&rig, 200u);
    CHECK(ctx, s.completions == 1u && s.restarts == 1u && s.refused == 0u);
    CHECK(ctx, g_host->slots[slot].plays == 2 && g_host->slots[slot].last_loop == 0);
    CHECK(ctx, playing(&rig, 4) == 1);
    info = info_of(&rig, 4);
    CHECK(ctx, info.started == 1u && info.finished == 0u && info.restarts == 1u &&
               info.stop_event_pending == 0u && info.repeat_marker == 0u);
    s = service(&rig, 300u);                       /* no new completion */
    CHECK(ctx, s.completions == 0u && s.restarts == 0u && g_host->slots[slot].plays == 2);
    rig_close(&rig);
}

static void t_control_one_never_restarts(Ctx *ctx)
{
    Rig rig; LiveAudioServiceStats s; uint32_t slot;
    if (!rig_open(ctx, &rig, 1)) return;
    CHECK(ctx, start(&rig, "Tone", 4, 1));
    slot = slot_of(&rig, 4);
    finish(&rig, 4);
    s = service(&rig, 200u);
    CHECK(ctx, s.completions == 1u && s.restarts == 0u && s.refused == 0u);
    CHECK(ctx, g_host->slots[slot].plays == 1);
    CHECK(ctx, playing(&rig, 4) == 0 && info_of(&rig, 4).finished == 1u);
    s = service(&rig, 300u);
    CHECK(ctx, s.completions == 0u && g_host->slots[slot].plays == 1);
    rig_close(&rig);
}

static void t_other_control_words_never_restart(Ctx *ctx)
{
    static const uint32_t words[] = {2u, 0x100u, 0x80000000u, 0xffffffffu};
    for (size_t i = 0; i < sizeof(words) / sizeof(words[0]); ++i) {
        Rig rig; LiveAudioServiceStats s; uint32_t slot;
        if (!rig_open(ctx, &rig, 1)) return;
        CHECK(ctx, start(&rig, "Tone", 5, words[i]));
        slot = slot_of(&rig, 5);
        finish(&rig, 5);
        s = service(&rig, 200u);
        CHECK(ctx, s.restarts == 0u && g_host->slots[slot].plays == 1);
        rig_close(&rig);
    }
}

static void t_control_zero_stream_loops_on_the_host_and_never_completes(Ctx *ctx)
{
    Rig rig; LiveAudioServiceStats s; LiveAudioChannelInfo info; uint32_t slot;
    if (!rig_open(ctx, &rig, 1)) return;
    CHECK(ctx, start(&rig, "Big", 4, 0));
    slot = slot_of(&rig, 4);
    info = info_of(&rig, 4);
    CHECK(ctx, info.stream_class == 1u && info.looping == 1u);
    CHECK(ctx, info.decoded_bytes == 400000u);
    CHECK(ctx, g_host->slots[slot].plays == 1 && g_host->slots[slot].last_loop == 1);
    s = service(&rig, 100u);
    CHECK(ctx, s.completions == 0u && s.restarts == 0u && playing(&rig, 4) == 1);
    rig_close(&rig);
}

static void t_control_one_stream_plays_once_and_is_not_restarted(Ctx *ctx)
{
    Rig rig; LiveAudioServiceStats s; uint32_t slot;
    if (!rig_open(ctx, &rig, 1)) return;
    CHECK(ctx, start(&rig, "Big", 4, 1));
    slot = slot_of(&rig, 4);
    CHECK(ctx, info_of(&rig, 4).stream_class == 1u && info_of(&rig, 4).looping == 0u);
    CHECK(ctx, g_host->slots[slot].last_loop == 0);
    finish(&rig, 4);
    s = service(&rig, 100u);
    CHECK(ctx, s.completions == 1u && s.restarts == 0u && g_host->slots[slot].plays == 1);
    CHECK(ctx, playing(&rig, 4) == 0);
    rig_close(&rig);
}

static void t_stream_threshold_is_0x56220_signed_greater_than(Ctx *ctx)
{
    Rig rig;
    if (!rig_open(ctx, &rig, 1)) return;
    CHECK(ctx, start(&rig, "Edge", 3, 1));       /* exactly 0x56220 bytes */
    CHECK(ctx, info_of(&rig, 3).decoded_bytes == 0x56220u && info_of(&rig, 3).stream_class == 0u);
    CHECK(ctx, start(&rig, "EdgePlus", 6, 1));   /* 0x56224 bytes */
    CHECK(ctx, info_of(&rig, 6).decoded_bytes == 0x56224u && info_of(&rig, 6).stream_class == 1u);
    rig_close(&rig);
}

static void t_explicit_stop_and_unload_are_not_restarted(Ctx *ctx)
{
    Rig rig; LiveAudioServiceStats s; uint32_t slot;
    if (!rig_open(ctx, &rig, 1)) return;
    CHECK(ctx, start(&rig, "Tone", 4, 0));
    slot = slot_of(&rig, 4);
    CHECK(ctx, live_audio_stop_channel(rig.audio, 4) == LIVE_AUDIO_OK);
    CHECK(ctx, info_of(&rig, 4).update_gate_287 == 1u);
    finish(&rig, 4);
    s = service(&rig, 100u);
    CHECK(ctx, s.restarts == 0u && g_host->slots[slot].plays == 1);
    /* a later play clears the gate (the Play wrapper writes +0x287 = 0) */
    CHECK(ctx, live_audio_play_sound(rig.audio, 4) == ACTION_SOUND_BACKEND_OK);
    CHECK(ctx, info_of(&rig, 4).update_gate_287 == 0u);
    finish(&rig, 4);
    s = service(&rig, 200u);
    CHECK(ctx, s.restarts == 1u && g_host->slots[slot].plays == 3);
    CHECK(ctx, live_audio_unload_sound(rig.audio, 4) == ACTION_SOUND_BACKEND_OK);
    s = service(&rig, 300u);
    CHECK(ctx, s.restarts == 0u && g_host->slots[slot].plays == 3 && info_of(&rig, 4).loaded == 0u);
    rig_close(&rig);
}

static void t_completion_latched_by_a_poll_is_still_serviced(Ctx *ctx)
{
    Rig rig; LiveAudioServiceStats s; uint32_t slot;
    if (!rig_open(ctx, &rig, 1)) return;
    CHECK(ctx, start(&rig, "Tone", 4, 0));
    slot = slot_of(&rig, 4);
    finish(&rig, 4);
    CHECK(ctx, playing(&rig, 4) == 0);              /* an action poll latches it first */
    CHECK(ctx, info_of(&rig, 4).finished == 1u && info_of(&rig, 4).stop_event_pending == 1u);
    CHECK(ctx, playing(&rig, 4) == 0);              /* still idle before the pump drains it */
    s = service(&rig, 100u);
    CHECK(ctx, s.completions == 1u && s.restarts == 1u && g_host->slots[slot].plays == 2);
    CHECK(ctx, playing(&rig, 4) == 1);
    rig_close(&rig);
}

static void t_reload_resets_flags_gate_and_pending_state(Ctx *ctx)
{
    Rig rig;
    if (!rig_open(ctx, &rig, 1)) return;
    CHECK(ctx, start(&rig, "Tone", 4, 0));
    CHECK(ctx, live_audio_set_channel_flags(rig.audio, 4, 0x10u) == LIVE_AUDIO_OK);
    CHECK(ctx, info_of(&rig, 4).raw_flags == 0x10u);
    finish(&rig, 4);
    CHECK(ctx, playing(&rig, 4) == 0);
    CHECK(ctx, start(&rig, "Tone", 4, 0));
    CHECK(ctx, info_of(&rig, 4).raw_flags == 0u && info_of(&rig, 4).stop_event_pending == 0u &&
               info_of(&rig, 4).update_gate_287 == 0u && info_of(&rig, 4).restarts == 0u);
    rig_close(&rig);
}

static void t_ascending_channel_order(Ctx *ctx)
{
    Rig rig; LiveAudioServiceStats s;
    if (!rig_open(ctx, &rig, 1)) return;
    CHECK(ctx, start(&rig, "Tone", 9, 0));
    CHECK(ctx, start(&rig, "Tone", 2, 0));
    CHECK(ctx, start(&rig, "Tone", 7, 1));
    g_host->order_count = 0;
    finish(&rig, 9); finish(&rig, 2); finish(&rig, 7);
    s = service(&rig, 100u);
    CHECK(ctx, s.completions == 3u && s.restarts == 2u);
    CHECK(ctx, g_host->order_count == 2);
    CHECK(ctx, g_host->order[0] == (char)('0' + slot_of(&rig, 2) % 10) &&
               g_host->order[1] == (char)('0' + slot_of(&rig, 9) % 10));
    rig_close(&rig);
}

static void t_restart_host_failure_is_reported_and_state_neutral(Ctx *ctx)
{
    Rig rig; LiveAudioServiceStats s;
    if (!rig_open(ctx, &rig, 1)) return;
    CHECK(ctx, start(&rig, "Tone", 4, 0));
    finish(&rig, 4);
    g_host->fail_play = 1;
    s = service(&rig, 100u);
    CHECK(ctx, s.completions == 1u && s.restarts == 0u && s.host_failures == 1u);
    CHECK(ctx, info_of(&rig, 4).loaded == 1u && playing(&rig, 4) == 0);
    CHECK(ctx, info_of(&rig, 4).stop_event_pending == 0u);
    g_host->fail_play = 0;
    s = service(&rig, 200u);                         /* the event was consumed */
    CHECK(ctx, s.completions == 0u && s.restarts == 0u);
    rig_close(&rig);
}

/* ---- raw flags (not reachable from scene data; recovered all the same) --- */
static void t_flag_one_and_0x100_choose_the_host_loop(Ctx *ctx)
{
    struct { uint32_t control; uint16_t flags; int loop; } cases[] = {
        {0u, 0x0001u, 1}, {1u, 0x0001u, 0}, {0u, 0x0000u, 0}, {1u, 0x0100u, 1}, {0u, 0x0100u, 1},
    };
    for (size_t i = 0; i < sizeof(cases) / sizeof(cases[0]); ++i) {
        Rig rig; uint32_t slot;
        if (!rig_open(ctx, &rig, 1)) return;
        {
            ActionSoundAudioCommand c = command("Tone", 4, cases[i].control);
            CHECK(ctx, live_audio_load_sound(rig.audio, &c) == ACTION_SOUND_BACKEND_OK);
            CHECK(ctx, live_audio_set_channel_flags(rig.audio, 4, cases[i].flags) == LIVE_AUDIO_OK);
            CHECK(ctx, live_audio_play_sound(rig.audio, 4) == ACTION_SOUND_BACKEND_OK);
        }
        slot = slot_of(&rig, 4);
        CHECK(ctx, g_host->slots[slot].last_loop == cases[i].loop);
        CHECK(ctx, info_of(&rig, 4).looping == (uint8_t)cases[i].loop);
        rig_close(&rig);
    }
}

static void t_flag_0x10_arms_the_random_delay_then_plays_after_the_due_tick(Ctx *ctx)
{
    Rig rig; LiveAudioServiceStats s; LiveAudioChannelInfo info; uint32_t slot;
    if (!rig_open(ctx, &rig, 1)) return;
    CHECK(ctx, start(&rig, "Tone", 4, 0));
    slot = slot_of(&rig, 4);
    CHECK(ctx, live_audio_set_channel_flags(rig.audio, 4, 0x10u) == LIVE_AUDIO_OK);
    g_random_value = 1234u;                          /* 1234 % (2000-500) + 500 */
    finish(&rig, 4);
    s = service(&rig, 10000u);
    CHECK(ctx, s.completions == 1u && s.repeats_armed == 1u && s.restarts == 0u);
    CHECK(ctx, g_random_draws == 1);
    info = info_of(&rig, 4);
    CHECK(ctx, info.repeat_marker == 1u && info.repeat_delay == 1734u && info.repeat_due_tick == 11734u);
    CHECK(ctx, g_host->slots[slot].plays == 1 && playing(&rig, 4) == 0);
    s = service(&rig, 11734u);                       /* equal tick: unsigned strictly-greater */
    CHECK(ctx, s.repeats_fired == 0u && g_host->slots[slot].plays == 1);
    s = service(&rig, 11735u);
    CHECK(ctx, s.repeats_fired == 1u && g_host->slots[slot].plays == 2 && playing(&rig, 4) == 1);
    CHECK(ctx, info_of(&rig, 4).repeat_marker == 0u && g_random_draws == 1);
    s = service(&rig, 20000u);
    CHECK(ctx, s.repeats_fired == 0u && g_host->slots[slot].plays == 2);
    rig_close(&rig);
}

static void t_flag_0x10_tick_wrap_uses_the_unsigned_compare(Ctx *ctx)
{
    Rig rig; LiveAudioServiceStats s; LiveAudioChannelInfo info;
    if (!rig_open(ctx, &rig, 1)) return;
    CHECK(ctx, start(&rig, "Tone", 4, 0));
    CHECK(ctx, live_audio_set_channel_flags(rig.audio, 4, 0x10u) == LIVE_AUDIO_OK);
    g_random_value = 23u;                            /* 23 % 1500 + 500 = 523 */
    finish(&rig, 4);
    s = service(&rig, 0xfffffff8u);
    /* 0xfffffff8 + 523 wraps to 515, and the original's compare is unsigned
     * (0x4f72a7 `cmp eax, [edx+8]; jbe`): the repeat pass that follows the
     * drain in the same pump call already sees tick > due and plays. */
    CHECK(ctx, s.repeats_armed == 1u && s.repeats_fired == 1u);
    info = info_of(&rig, 4);
    CHECK(ctx, info.repeat_delay == 523u && info.repeat_due_tick == 515u);   /* 32-bit wrap */
    CHECK(ctx, info.repeat_marker == 0u && playing(&rig, 4) == 1);
    rig_close(&rig);
}

static void t_flag_0x10_without_a_random_source_is_refused_state_neutral(Ctx *ctx)
{
    Rig rig; LiveAudioServiceStats s; LiveAudioChannelInfo info;
    if (!rig_open(ctx, &rig, 0)) return;
    CHECK(ctx, start(&rig, "Tone", 4, 0));
    CHECK(ctx, live_audio_set_channel_flags(rig.audio, 4, 0x10u) == LIVE_AUDIO_OK);
    finish(&rig, 4);
    s = service(&rig, 100u);
    CHECK(ctx, s.refused == 1u && s.repeats_armed == 0u && s.restarts == 0u);
    info = info_of(&rig, 4);
    CHECK(ctx, info.update_refused == 1u && info.repeat_marker == 0u);
    rig_close(&rig);
}

static void t_flag_0x20_fade_is_refused(Ctx *ctx)
{
    Rig rig; LiveAudioServiceStats s; uint32_t slot;
    if (!rig_open(ctx, &rig, 1)) return;
    CHECK(ctx, start(&rig, "Tone", 4, 0));
    slot = slot_of(&rig, 4);
    CHECK(ctx, live_audio_set_channel_flags(rig.audio, 4, 0x20u) == LIVE_AUDIO_OK);
    finish(&rig, 4);
    s = service(&rig, 100u);
    CHECK(ctx, s.refused == 1u && s.restarts == 0u && g_host->slots[slot].plays == 1);
    CHECK(ctx, info_of(&rig, 4).update_refused == 1u);
    rig_close(&rig);
}

/* Independent decision table for the update, written from the disassembly
 * (0x4f5617..0x4f5725) rather than from the implementation: gates first
 * (stream class), then flag 0x20 fade, then control != 0, then flag 0x10,
 * else Play. Runs every combination of the four recovered flag bits. */
static void t_flag_matrix_decision_table(Ctx *ctx)
{
    static const uint16_t bits[] = {0x0001u, 0x0010u, 0x0020u, 0x0100u};
    static const uint32_t controls[] = {0u, 1u};
    static const char *const stems[] = {"Tone", "Big"};
    for (unsigned combo = 0u; combo < 16u; ++combo) {
        uint16_t flags = 0u;
        for (unsigned b = 0u; b < 4u; ++b) if (combo & (1u << b)) flags = (uint16_t)(flags | bits[b]);
        for (size_t c = 0u; c < 2u; ++c) {
            for (size_t s = 0u; s < 2u; ++s) {
                Rig rig; LiveAudioServiceStats st; LiveAudioChannelInfo info;
                ActionSoundAudioCommand cmd = command(stems[s], 8, controls[c]);
                uint32_t slot;
                unsigned want_restart = 0u, want_arm = 0u, want_refused = 0u;
                const int stream = s == 1u;
                if (!rig_open(ctx, &rig, 1)) return;
                g_random_value = 77u;
                CHECK(ctx, live_audio_load_sound(rig.audio, &cmd) == ACTION_SOUND_BACKEND_OK);
                CHECK(ctx, live_audio_set_channel_flags(rig.audio, 8, flags) == LIVE_AUDIO_OK);
                CHECK(ctx, live_audio_play_sound(rig.audio, 8) == ACTION_SOUND_BACKEND_OK);
                slot = slot_of(&rig, 8);
                info = info_of(&rig, 8);
                {   /* Play wrapper 0x4f6059 loop bit, stream override of the ring */
                    int loop_play = (controls[c] == 0u && (flags & 0x0001u)) || (flags & 0x0100u);
                    int expected_loop = stream ? (controls[c] == 0u) : loop_play;
                    CHECK(ctx, g_host->slots[slot].last_loop == expected_loop);
                    CHECK(ctx, info.looping == (uint8_t)expected_loop);
                }
                if (!(g_host->slots[slot].last_loop)) {
                    finish(&rig, 8);
                    st = service(&rig, 5000u);
                    if (!stream) {
                        if (flags & 0x0020u) want_refused = 1u;
                        else if (controls[c] == 0u) {
                            if (flags & 0x0010u) want_arm = 1u; else want_restart = 1u;
                        }
                    }
                    CHECK(ctx, st.completions == 1u);
                    CHECK(ctx, st.restarts == want_restart);
                    CHECK(ctx, st.repeats_armed == want_arm);
                    CHECK(ctx, st.refused == want_refused);
                    CHECK(ctx, g_host->slots[slot].plays == (int)(1u + want_restart));
                    CHECK(ctx, g_random_draws == (int)want_arm);
                } else {
                    /* a looped host slot does not complete on its own */
                    st = service(&rig, 5000u);
                    CHECK(ctx, st.completions == 0u && st.restarts == 0u && st.refused == 0u);
                }
                rig_close(&rig);
            }
        }
    }
}

static void t_argument_checks(Ctx *ctx)
{
    Rig rig;
    if (!rig_open(ctx, &rig, 1)) return;
    CHECK(ctx, live_audio_service(NULL, 0u, NULL) == LIVE_AUDIO_ERR_ARGUMENT);
    CHECK(ctx, live_audio_service(rig.audio, 0u, NULL) == LIVE_AUDIO_OK);
    CHECK(ctx, live_audio_set_channel_flags(rig.audio, 32, 0u) == LIVE_AUDIO_ERR_ARGUMENT);
    CHECK(ctx, live_audio_set_channel_flags(rig.audio, 4, 0u) == LIVE_AUDIO_ERR_ARGUMENT);   /* unloaded */
    CHECK(ctx, live_audio_set_channel_flags(NULL, 4, 0u) == LIVE_AUDIO_ERR_ARGUMENT);
    rig_close(&rig);
}

/* ---- opcode 17 adapter ---------------------------------------------------- */
static ConditionExtraHostStatus record_of(Rig *rig, uint16_t channel, SessionConditionsChannelRecord *r)
{
    return session_conditions_live_audio_channel_record(rig->audio, channel, r);
}

static void t_adapter_reports_the_looping_clock_as_playing_forever(Ctx *ctx)
{
    Rig rig; SessionConditionsChannelRecord r;
    if (!rig_open(ctx, &rig, 1)) return;
    CHECK(ctx, start(&rig, "Big", 4, 0));
    for (uint32_t tick = 100u; tick < 5000u; tick += 700u) {
        (void)service(&rig, tick);
        memset(&r, 0xee, sizeof(r));
        CHECK(ctx, record_of(&rig, 4, &r) == CONDITION_EXTRA_HOST_OK);
        CHECK(ctx, r.resource_ready_162 == 1u && r.buffer_available_28f == 1u && r.get_status_flags == 1u);
    }
    rig_close(&rig);
}

static void t_adapter_answers_a_completed_restartable_channel_without_refusing(Ctx *ctx)
{
    Rig rig; SessionConditionsChannelRecord r;
    if (!rig_open(ctx, &rig, 1)) return;
    CHECK(ctx, start(&rig, "Tone", 6, 0));
    finish(&rig, 6);
    /* between the stop notification and the pump the original's GetStatus
     * reads "stopped": a faithful idle, not a refusal */
    memset(&r, 0xee, sizeof(r));
    CHECK(ctx, record_of(&rig, 6, &r) == CONDITION_EXTRA_HOST_OK);
    CHECK(ctx, r.resource_ready_162 == 1u && r.buffer_available_28f == 1u && r.get_status_flags == 0u);
    (void)service(&rig, 100u);
    CHECK(ctx, record_of(&rig, 6, &r) == CONDITION_EXTRA_HOST_OK && r.get_status_flags == 1u);
    rig_close(&rig);
}

static void t_adapter_control_one_and_unloaded_are_unchanged(Ctx *ctx)
{
    Rig rig; SessionConditionsChannelRecord r;
    if (!rig_open(ctx, &rig, 1)) return;
    CHECK(ctx, record_of(&rig, 4, &r) == CONDITION_EXTRA_HOST_OK);
    CHECK(ctx, r.resource_ready_162 == 0u && r.buffer_available_28f == 0u && r.get_status_flags == 0u);
    CHECK(ctx, start(&rig, "Tone", 4, 1));
    finish(&rig, 4);
    (void)service(&rig, 100u);
    CHECK(ctx, record_of(&rig, 4, &r) == CONDITION_EXTRA_HOST_OK);
    CHECK(ctx, r.resource_ready_162 == 1u && r.buffer_available_28f == 1u && r.get_status_flags == 0u);
    rig_close(&rig);
}

static void t_adapter_reports_an_armed_repeat_as_busy(Ctx *ctx)
{
    Rig rig; SessionConditionsChannelRecord r;
    if (!rig_open(ctx, &rig, 1)) return;
    CHECK(ctx, start(&rig, "Tone", 4, 0));
    CHECK(ctx, live_audio_set_channel_flags(rig.audio, 4, 0x10u) == LIVE_AUDIO_OK);
    g_random_value = 900u;
    finish(&rig, 4);
    (void)service(&rig, 100u);
    memset(&r, 0xee, sizeof(r));
    CHECK(ctx, record_of(&rig, 4, &r) == CONDITION_EXTRA_HOST_OK);
    CHECK(ctx, r.repeat_marker_19e == 1u && r.get_status_flags == 0u);   /* 0x4f6334 marker branch */
    (void)service(&rig, 100u + 1400u + 1u);
    CHECK(ctx, record_of(&rig, 4, &r) == CONDITION_EXTRA_HOST_OK);
    CHECK(ctx, r.repeat_marker_19e == 0u && r.get_status_flags == 1u);
    rig_close(&rig);
}

static void t_adapter_still_refuses_what_it_cannot_prove(Ctx *ctx)
{
    Rig rig; SessionConditionsChannelRecord r;
    if (!rig_open(ctx, &rig, 1)) return;
    CHECK(ctx, start(&rig, "Tone", 4, 0));
    CHECK(ctx, live_audio_set_channel_flags(rig.audio, 4, 0x20u) == LIVE_AUDIO_OK);
    finish(&rig, 4);
    (void)service(&rig, 100u);                      /* refused update */
    CHECK(ctx, record_of(&rig, 4, &r) == CONDITION_EXTRA_HOST_UNAVAILABLE);
    rig_close(&rig);
}

typedef struct { const char *name; void (*run)(Ctx *); } Test;
static const Test tests[] = {
    {"control_zero_nonstream_restarts_after_completion", t_control_zero_nonstream_restarts_after_completion},
    {"control_one_never_restarts", t_control_one_never_restarts},
    {"other_control_words_never_restart", t_other_control_words_never_restart},
    {"control_zero_stream_loops_on_the_host_and_never_completes",
     t_control_zero_stream_loops_on_the_host_and_never_completes},
    {"control_one_stream_plays_once_and_is_not_restarted", t_control_one_stream_plays_once_and_is_not_restarted},
    {"stream_threshold_is_0x56220_signed_greater_than", t_stream_threshold_is_0x56220_signed_greater_than},
    {"explicit_stop_and_unload_are_not_restarted", t_explicit_stop_and_unload_are_not_restarted},
    {"completion_latched_by_a_poll_is_still_serviced", t_completion_latched_by_a_poll_is_still_serviced},
    {"reload_resets_flags_gate_and_pending_state", t_reload_resets_flags_gate_and_pending_state},
    {"ascending_channel_order", t_ascending_channel_order},
    {"restart_host_failure_is_reported_and_state_neutral", t_restart_host_failure_is_reported_and_state_neutral},
    {"flag_one_and_0x100_choose_the_host_loop", t_flag_one_and_0x100_choose_the_host_loop},
    {"flag_0x10_arms_the_random_delay_then_plays_after_the_due_tick",
     t_flag_0x10_arms_the_random_delay_then_plays_after_the_due_tick},
    {"flag_0x10_tick_wrap_uses_the_unsigned_compare", t_flag_0x10_tick_wrap_uses_the_unsigned_compare},
    {"flag_0x10_without_a_random_source_is_refused_state_neutral",
     t_flag_0x10_without_a_random_source_is_refused_state_neutral},
    {"flag_0x20_fade_is_refused", t_flag_0x20_fade_is_refused},
    {"flag_matrix_decision_table", t_flag_matrix_decision_table},
    {"argument_checks", t_argument_checks},
    {"adapter_reports_the_looping_clock_as_playing_forever",
     t_adapter_reports_the_looping_clock_as_playing_forever},
    {"adapter_answers_a_completed_restartable_channel_without_refusing",
     t_adapter_answers_a_completed_restartable_channel_without_refusing},
    {"adapter_control_one_and_unloaded_are_unchanged", t_adapter_control_one_and_unloaded_are_unchanged},
    {"adapter_reports_an_armed_repeat_as_busy", t_adapter_reports_an_armed_repeat_as_busy},
    {"adapter_still_refuses_what_it_cannot_prove", t_adapter_still_refuses_what_it_cannot_prove},
};

int main(int argc, char **argv)
{
    int failures = 0;
    if (argc < 2) { fprintf(stderr, "usage: %s <fixture_dir> [list|test...]\n", argv[0]); return 2; }
    if (argc >= 3 && strcmp(argv[2], "list") == 0) {
        for (size_t i = 0; i < sizeof(tests) / sizeof(tests[0]); ++i) printf("%s\n", tests[i].name);
        return 0;
    }
    for (size_t i = 0; i < sizeof(tests) / sizeof(tests[0]); ++i) {
        Ctx ctx;
        int selected = argc < 3;
        for (int a = 2; a < argc && !selected; ++a) selected = strcmp(argv[a], tests[i].name) == 0;
        if (!selected) continue;
        memset(&ctx, 0, sizeof(ctx));
        ctx.dir = argv[1];
        tests[i].run(&ctx);
        printf("TEST %s %s %s\n", tests[i].name, ctx.failed ? "FAIL" : "PASS", ctx.detail);
        fflush(stdout);
        if (ctx.failed) ++failures;
    }
    return failures == 0 ? 0 : 1;
}
