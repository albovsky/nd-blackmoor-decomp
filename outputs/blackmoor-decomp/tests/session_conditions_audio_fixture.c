/* RT-4: opcode 17 against the real offline live-audio host.
 *
 * usage: session_conditions_audio_fixture <fixture_dir>
 *
 * <fixture_dir> holds a synthetic CDSound tree (tests/test_live_audio.py
 * build_fixture_tree). Each test builds a one-leaf dependency tree for opcode
 * 17, evaluates it through the real binding + live_audio adapter and checks
 * the answer while a real AVAudioEngine offline graph plays, finishes or never
 * started. Output: "TEST <name> PASS|FAIL <detail>"; nonzero exit on failure. */

#include <stdio.h>
#include <string.h>
#include <unistd.h>

#include "action_sound.h"
#include "live_audio.h"
#include "scene_conditions.h"
#include "session_bindings_conditions.h"
#include "session_bindings_conditions_audio.h"

#define TONE_FRAMES 20000u

typedef struct Ctx { const char *dir; int failed; char detail[256]; } Ctx;

#define CHECK(ctx, cond) \
    do { if (!(cond) && !(ctx)->failed) { (ctx)->failed = 1; \
        snprintf((ctx)->detail, sizeof((ctx)->detail), "line %d: %s", __LINE__, #cond); } } while (0)

static ActionSoundAudioCommand command(const char *stem, uint16_t channel,
                                       uint32_t control)
{
    ActionSoundAudioCommand c;
    memset(&c, 0, sizeof(c));
    snprintf(c.asset_stem, sizeof(c.asset_stem), "%s", stem);
    c.channel = channel;
    c.volume_category = 1;
    c.control_word = control;
    c.first_gain = c.second_gain = 1.0f;
    c.first_percent = c.second_percent = 100;
    return c;
}

typedef struct Rig {
    LiveAudio *audio;
    SessionConditions *binding;
} Rig;

static int rig_open(Ctx *ctx, Rig *rig)
{
    LiveAudioConfig config;
    SessionConditionsConfig bind;
    char error[256] = "";
    int status = 0;
    memset(rig, 0, sizeof(*rig));
    memset(&config, 0, sizeof(config));
    config.game_directory = ctx->dir;
    config.mode = MAC_AUDIO_MODE_OFFLINE;
    config.offline_sample_rate = 48000;
    config.offline_channels = 2;
    CHECK(ctx, live_audio_create(&config, &rig->audio, error, sizeof(error)) == LIVE_AUDIO_OK);
    if (ctx->failed) return 0;
    memset(&bind, 0, sizeof(bind));
    bind.host.context = rig->audio;
    bind.host.channel_record = session_conditions_live_audio_channel_record;
    rig->binding = session_conditions_create(&bind, &status);
    CHECK(ctx, rig->binding != NULL && status == SESSION_CONDITIONS_OK);
    return !ctx->failed;
}

static void rig_close(Rig *rig)
{
    session_conditions_destroy(rig->binding);
    if (rig->audio != NULL) live_audio_destroy(rig->audio);
}

/* Evaluates "17(channel) == expected"; returns the SceneConditionStatus and
 * stores the tree answer. */
static int query(Rig *rig, int16_t channel, int16_t expected, int *answer)
{
    SceneDependencyInfo record;
    SceneConditionTree *tree = NULL;
    SceneConditionState state;
    uint16_t unsupported = 0;
    int status;
    memset(&record, 0, sizeof(record));
    record.opcode = 17;
    record.fields[0] = 17;
    record.fields[1] = channel;
    record.fields[2] = expected;
    if (scene_conditions_build(&record, 1, &tree) != SCENE_CONDITION_OK) return -1;
    memset(&state, 0, sizeof(state));
    *answer = -1;
    status = scene_conditions_evaluate_ex(tree, &state,
                                          session_conditions_extension(rig->binding),
                                          0, answer, &unsupported, NULL);
    scene_conditions_destroy(tree);
    return status;
}

static void t_unloaded_channel_is_idle_with_the_missing_resource_error(Ctx *ctx)
{
    Rig rig; int answer = -1; SessionConditionsSoundManager m;
    if (!rig_open(ctx, &rig)) return;
    CHECK(ctx, query(&rig, 4, 0, &answer) == SCENE_CONDITION_OK && answer == 1);
    CHECK(ctx, query(&rig, 4, 1, &answer) == SCENE_CONDITION_OK && answer == 0);
    CHECK(ctx, session_conditions_get_sound_manager(rig.binding, &m) == SESSION_CONDITIONS_OK);
    CHECK(ctx, m.error_3c2 == 0x3efu && m.state_3be == 0u && m.host_result_3ca == 0);
    rig_close(&rig);
}

static void t_real_offline_play_to_completion_control_one(Ctx *ctx)
{
    Rig rig; int answer = -1; uint64_t rendered = 0; int done = 0;
    ActionSoundAudioCommand c = command("tone", 4, 1);
    LiveAudioOfflineStats stats;
    SessionConditionsSoundManager m;
    if (!rig_open(ctx, &rig)) return;
    CHECK(ctx, live_audio_load_sound(rig.audio, &c) == ACTION_SOUND_BACKEND_OK);
    /* loaded, not started: GetStatus bit 0 clear -> idle */
    CHECK(ctx, query(&rig, 4, 0, &answer) == SCENE_CONDITION_OK && answer == 1);
    CHECK(ctx, session_conditions_get_sound_manager(rig.binding, &m) == SESSION_CONDITIONS_OK);
    CHECK(ctx, m.error_3c2 == 0x3e8u && m.host_result_3ca == 0);
    CHECK(ctx, live_audio_play_sound(rig.audio, 4) == ACTION_SOUND_BACKEND_OK);
    CHECK(ctx, query(&rig, 4, 1, &answer) == SCENE_CONDITION_OK && answer == 1);
    while (rendered < 8u * TONE_FRAMES && !done && !ctx->failed) {
        CHECK(ctx, live_audio_advance_offline(rig.audio, 2500, &stats, NULL, 0) == LIVE_AUDIO_OK);
        rendered += 2500u;
        if (rendered < TONE_FRAMES) {
            CHECK(ctx, query(&rig, 4, 1, &answer) == SCENE_CONDITION_OK && answer == 1);
        } else {
            for (int i = 0; i < 200 && !done; ++i) {
                CHECK(ctx, query(&rig, 4, 0, &answer) == SCENE_CONDITION_OK);
                done = answer == 1;
                if (!done) usleep(5000);
            }
        }
    }
    CHECK(ctx, done);
    CHECK(ctx, query(&rig, 4, 1, &answer) == SCENE_CONDITION_OK && answer == 0);
    /* unload clears resource-ready: idle with the 0x3ef error again */
    CHECK(ctx, live_audio_unload_sound(rig.audio, 4) == ACTION_SOUND_BACKEND_OK);
    CHECK(ctx, query(&rig, 4, 0, &answer) == SCENE_CONDITION_OK && answer == 1);
    CHECK(ctx, session_conditions_get_sound_manager(rig.binding, &m) == SESSION_CONDITIONS_OK);
    CHECK(ctx, m.error_3c2 == 0x3efu);
    rig_close(&rig);
}

static void t_control_zero_after_completion_is_idle_then_restarted_by_the_pump(Ctx *ctx)
{
    Rig rig; int answer = -1; uint64_t rendered = 0; int finished = 0;
    ActionSoundAudioCommand c = command("tone", 6, 0);
    LiveAudioOfflineStats stats;
    SessionConditionsSoundManager before, after;
    if (!rig_open(ctx, &rig)) return;
    CHECK(ctx, live_audio_load_sound(rig.audio, &c) == ACTION_SOUND_BACKEND_OK);
    CHECK(ctx, query(&rig, 6, 0, &answer) == SCENE_CONDITION_OK && answer == 1);   /* not started */
    CHECK(ctx, live_audio_play_sound(rig.audio, 6) == ACTION_SOUND_BACKEND_OK);
    CHECK(ctx, query(&rig, 6, 1, &answer) == SCENE_CONDITION_OK && answer == 1);   /* playing */
    while (rendered < 8u * TONE_FRAMES && !finished && !ctx->failed) {
        int is_playing = 1;
        CHECK(ctx, live_audio_advance_offline(rig.audio, 2500, &stats, NULL, 0) == LIVE_AUDIO_OK);
        rendered += 2500u;
        for (int i = 0; i < 200 && rendered >= TONE_FRAMES && is_playing; ++i) {
            CHECK(ctx, live_audio_is_playing(rig.audio, 6, &is_playing) == ACTION_SOUND_BACKEND_OK);
            if (is_playing) usleep(5000);
        }
        finished = is_playing == 0;
    }
    CHECK(ctx, finished);
    /* RT-11.1: between the end of the buffer and the pump the original's
     * GetStatus reads "stopped" (a faithful idle, no longer a refusal) ... */
    CHECK(ctx, session_conditions_get_sound_manager(rig.binding, &before) == SESSION_CONDITIONS_OK);
    CHECK(ctx, query(&rig, 6, 0, &answer) == SCENE_CONDITION_OK && answer == 1);
    CHECK(ctx, session_conditions_get_sound_manager(rig.binding, &after) == SESSION_CONDITIONS_OK);
    CHECK(ctx, after.error_3c2 == 0x3e8u && after.host_result_3ca == 0);
    (void)before;
    /* ... and the pump (0x4f52a9 -> 0x4f55d5) restarts the raw-control-0 channel. */
    CHECK(ctx, live_audio_service(rig.audio, 1000u, NULL) == LIVE_AUDIO_OK);
    CHECK(ctx, query(&rig, 6, 1, &answer) == SCENE_CONDITION_OK && answer == 1);
    /* A completed channel whose update was refused (fade flag 0x20, reachable
     * only through the test setter) stays unavailable, never a false idle. */
    {
        ActionSoundAudioCommand refused = command("tone", 7, 0);
        int is_playing = 1;
        CHECK(ctx, live_audio_load_sound(rig.audio, &refused) == ACTION_SOUND_BACKEND_OK);
        CHECK(ctx, live_audio_set_channel_flags(rig.audio, 7, 0x20u) == LIVE_AUDIO_OK);
        CHECK(ctx, live_audio_play_sound(rig.audio, 7) == ACTION_SOUND_BACKEND_OK);
        rendered = 0u;
        while (rendered < 8u * TONE_FRAMES && is_playing && !ctx->failed) {
            CHECK(ctx, live_audio_advance_offline(rig.audio, 2500, &stats, NULL, 0) == LIVE_AUDIO_OK);
            rendered += 2500u;
            for (int i = 0; i < 200 && rendered >= TONE_FRAMES && is_playing; ++i) {
                CHECK(ctx, live_audio_is_playing(rig.audio, 7, &is_playing) == ACTION_SOUND_BACKEND_OK);
                if (is_playing) usleep(5000);
            }
        }
        CHECK(ctx, is_playing == 0);
        CHECK(ctx, live_audio_service(rig.audio, 2000u, NULL) == LIVE_AUDIO_OK);
        CHECK(ctx, query(&rig, 7, 0, &answer) == SCENE_CONDITION_ERR_HOST_UNAVAILABLE);
    }
    rig_close(&rig);
}

static void t_channel_outside_the_table_and_missing_audio_are_unavailable(Ctx *ctx)
{
    Rig rig; int answer = -1; SessionConditions *bare; SessionConditionsConfig bind;
    int status = 0;
    if (!rig_open(ctx, &rig)) return;
    CHECK(ctx, query(&rig, 32, 0, &answer) == SCENE_CONDITION_ERR_HOST_UNAVAILABLE);
    CHECK(ctx, query(&rig, 32767, 1, &answer) == SCENE_CONDITION_ERR_HOST_UNAVAILABLE);
    memset(&bind, 0, sizeof(bind));
    bind.host.context = NULL;                      /* no LiveAudio at all */
    bind.host.channel_record = session_conditions_live_audio_channel_record;
    bare = session_conditions_create(&bind, &status);
    CHECK(ctx, bare != NULL);
    {
        Rig no_audio; no_audio.audio = NULL; no_audio.binding = bare;
        CHECK(ctx, query(&no_audio, 4, 0, &answer) == SCENE_CONDITION_ERR_HOST_UNAVAILABLE);
    }
    session_conditions_destroy(bare);
    rig_close(&rig);
}

typedef struct { const char *name; void (*run)(Ctx *); } Test;
static const Test tests[] = {
    {"unloaded_channel_is_idle_with_the_missing_resource_error",
     t_unloaded_channel_is_idle_with_the_missing_resource_error},
    {"real_offline_play_to_completion_control_one",
     t_real_offline_play_to_completion_control_one},
    {"control_zero_after_completion_is_idle_then_restarted_by_the_pump",
     t_control_zero_after_completion_is_idle_then_restarted_by_the_pump},
    {"channel_outside_the_table_and_missing_audio_are_unavailable",
     t_channel_outside_the_table_and_missing_audio_are_unavailable},
};

int main(int argc, char **argv)
{
    int failures = 0;
    if (argc < 2) { fprintf(stderr, "usage: %s <fixture_dir>\n", argv[0]); return 2; }
    for (size_t i = 0; i < sizeof(tests) / sizeof(tests[0]); ++i) {
        Ctx ctx;
        memset(&ctx, 0, sizeof(ctx));
        ctx.dir = argv[1];
        tests[i].run(&ctx);
        printf("TEST %s %s %s\n", tests[i].name, ctx.failed ? "FAIL" : "PASS", ctx.detail);
        fflush(stdout);
        if (ctx.failed) ++failures;
    }
    return failures == 0 ? 0 : 1;
}
