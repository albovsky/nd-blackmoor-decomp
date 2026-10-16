/* RT-25 unit tests of the raw 0x3e cel-video arm of the conversation kernel
 * (src/action_family_3f_runtime.c, handler 0x420c17 cel arms, reader loop 0x422e4a,
 * render callback 0x422a0a). Prints "PASS <name>" / "FAIL <name>: <message>" per
 * test; exit status is the failure count. Fixtures are synthetic raw bodies run
 * through the A-3E.1 constructor; no original bytes are used.
 * tests/test_action_family_3e_runtime.py builds and runs this. */
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_3e.h"
#include "action_family_3f.h"
#include "action_family_3f_runtime.h"

static const char *g_name;
static int g_failed;
static char g_msg[256];
#define CHECK(cond)                                                          \
    do {                                                                     \
        if (!(cond) && !g_failed) {                                          \
            g_failed = 1;                                                    \
            snprintf(g_msg, sizeof g_msg, "line %d: %s", __LINE__, #cond);    \
        }                                                                    \
    } while (0)
#define CHECK_LOG(f, expected)                                                \
    do {                                                                     \
        if (strcmp((f)->log, (expected)) != 0 && !g_failed) {                 \
            g_failed = 1;                                                    \
            snprintf(g_msg, sizeof g_msg, "line %d: log \"%.110s\" != \"%.110s\"", __LINE__, (f)->log, (expected)); \
        }                                                                    \
    } while (0)

#define HDR_BYTES 0x2a
#define MAX_FRAMES 400

typedef struct Fx {
    Convo3fManager m;
    Convo3fWorld w;
    int32_t events[8], presence[8];
    uint8_t *arena;
    size_t arena_bytes;
    Convo3fObject obj;
    Convo3fHost host;
    ActionSoundBackend snd;
    char log[4096];
    uint8_t block[HDR_BYTES + MAX_FRAMES * CONVO3F_CEL_FRAME_STRIDE];
    size_t block_bytes;
    int load_status;
    int fail_header, fail_layer_index, fail_sync_init, fail_load_layer_at, layer_unloaded;
    int tree_kind[8], tree_transp[8];
    int sync_playing;
    int32_t sync_raw;
    int next_slot;
    Convo3fStepResult r;
    const char *why;
    int loads;
} Fx;

static void logf_(Fx *f, const char *fmt, ...)
{
    char tmp[96];
    va_list ap;
    size_t n = strlen(f->log);
    va_start(ap, fmt);
    vsnprintf(tmp, sizeof tmp, fmt, ap);
    va_end(ap);
    if (n != 0u && n + 1u < sizeof f->log) {
        f->log[n++] = ' ';
        f->log[n] = 0;
    }
    if (n + strlen(tmp) + 1u < sizeof f->log) {
        strcat(f->log, tmp);
    }
}

static ActionSoundBackendStatus cb_load(void *c, const ActionSoundAudioCommand *cmd)
{
    Fx *f = c;
    logf_(f, "load(%s,%u)", cmd->asset_stem, cmd->channel);
    return (ActionSoundBackendStatus)f->load_status;
}
static ActionSoundBackendStatus cb_play(void *c, uint16_t ch)
{
    logf_((Fx *)c, "play(%u)", ch);
    return ACTION_SOUND_BACKEND_OK;
}
static ActionSoundBackendStatus cb_isplaying(void *c, uint16_t ch, int *still)
{
    logf_((Fx *)c, "isplay(%u)", ch);
    *still = 0;
    return ACTION_SOUND_BACKEND_OK;
}
static ActionSoundBackendStatus cb_unload(void *c, uint16_t ch)
{
    logf_((Fx *)c, "unload(%u)", ch);
    return ACTION_SOUND_BACKEND_OK;
}
static int cb_view(void *c, int which) { logf_(c, "view%d", which); return 0; }
static int cb_mode(void *c, int32_t v) { logf_(c, "mode%d", (int)v); return 0; }
static int cb_aux(void *c, int32_t v) { logf_(c, "aux%d", (int)v); return 0; }
static int cb_add(void *c, int16_t item, int flag) { logf_(c, "add(%d,%d)", item, flag); return 0; }
static int cb_rm(void *c, int16_t item) { logf_(c, "rm(%d)", item); return 0; }
static int cb_acq(void *c, const char *name, int16_t a, int16_t b, int16_t *slot)
{
    Fx *f = c;
    (void)a;
    (void)b;
    *slot = (int16_t)f->next_slot++;
    logf_(f, "acq(%c,%d)", strstr(name, "Hilite") != NULL ? 'H' : 'N', *slot);
    return 0;
}
static int cb_rel(void *c, int16_t slot) { logf_(c, "rel(%d)", slot); return 0; }
static int cb_layout(void *c, const Convo3fLayoutRequest *q, Convo3fWorld *w)
{
    (void)q;
    (void)w;
    logf_(c, "layout");
    return 0;
}
static int cb_pop(void *c, Convo3fWorld *w)
{
    (void)w;
    logf_(c, "pop");
    return 0;
}
static int cb_ui(void *c, int32_t v) { logf_(c, "ui%d", (int)v); return 0; }
static int cb_restore(void *c) { logf_(c, "restore"); return 0; }

static int cb_header(void *c, const uint8_t *name, const uint8_t **block, size_t *size)
{
    Fx *f = c;
    logf_(f, "hdr(%s)", (const char *)name);
    if (f->fail_header) {
        return 1;
    }
    *block = f->block;
    *size = f->block_bytes;
    return 0;
}
static int cb_tree_index(void *c, const uint8_t *name, int16_t *index)
{
    Fx *f = c;
    logf_(f, "idx(%s)", (const char *)name);
    *index = (int16_t)(name[5] == 'A' ? 1 : 2);
    if (f->fail_layer_index) {
        *index = -1;
    }
    return 0;
}
static int cb_tree_info(void *c, int16_t index, uint8_t *kind, uint8_t *transp)
{
    Fx *f = c;
    *kind = (uint8_t)f->tree_kind[index];
    *transp = (uint8_t)f->tree_transp[index];
    return 0;
}
static int cb_load_layer(void *c, int16_t tree, const uint8_t *name, Convo3fCelLayer *layer)
{
    Fx *f = c;
    f->loads++;
    logf_(f, "ld(%d,%s)", (int)tree, (const char *)name);
    if (f->fail_load_layer_at != 0 && f->loads == f->fail_load_layer_at) {
        return 1;
    }
    layer->loaded = f->layer_unloaded ? 0u : 1u;
    layer->surface = (uint32_t)(tree * 1000 + f->loads);
    layer->key_2f = (int16_t)(tree + 7);
    layer->src[0] = 0; layer->src[1] = 0; layer->src[2] = 63; layer->src[3] = 47;
    layer->dst[0] = 10 * tree; layer->dst[1] = 20 * tree; layer->dst[2] = 10 * tree + 64; layer->dst[3] = 20 * tree + 48;
    return 0;
}
static int cb_free_layer(void *c, int16_t slot, int layer, uint32_t surface)
{
    logf_(c, "fr(%d,%d,%u)", slot, layer, surface);
    return 0;
}
static int cb_release_header(void *c) { logf_(c, "relhdr"); return 0; }
static int cb_rd_create(void *c) { logf_(c, "rdcreate"); return 0; }
static int cb_rd_resume(void *c) { logf_(c, "rdresume"); return 0; }
static int cb_rd_destroy(void *c) { logf_(c, "rddestroy"); return 0; }
static int cb_sync_init(void *c, uint16_t ch, uint16_t frames, uint32_t param)
{
    Fx *f = c;
    logf_(f, "sync(%u,%u,%u)", ch, frames, param);
    return f->fail_sync_init;
}
static int cb_sync_frame(void *c, uint16_t ch, int *playing, int32_t *raw)
{
    Fx *f = c;
    (void)ch;
    *playing = f->sync_playing;
    *raw = f->sync_raw;
    return 0;
}

static void put_name(uint8_t *dst, const char *s)
{
    memset(dst, 0, 33u);
    memcpy(dst, s, strlen(s));
}

/* Raw 0x3e body: 178-byte prefix, no primary records, secondary count 0. */
static size_t make_body(uint8_t *b, uint16_t last)
{
    memset(b, 0, 180u);
    put_name(b, "cel_hdr");
    put_name(b + 33, "layerA");
    put_name(b + 66, "layerB");
    b[99] = (uint8_t)last; b[100] = (uint8_t)(last >> 8);
    put_name(b + 101, "talk_line");
    b[134] = 85;
    put_name(b + 136, "K");
    b[169] = b[170] = CONVO3F_NO_HOOK;
    b[171] = 1;           /* default transition enabled */
    b[172] = 0x1c; b[173] = 0x04; /* default scene 1052 */
    return 180u;
}

static void fx_build(Fx *f, uint16_t last, int layers)
{
    uint8_t body[256];
    ActionFamily3eText text;
    ActionFamily3eConstructed layout, built;
    size_t n = make_body(body, last), i;
    memset(f, 0, sizeof(*f));
    text.bytes = (const uint8_t *)"caption";
    text.length = 7u;
    if (action_family_3e_construct(body, n, &text, 1u, 0u, 1u, NULL, 0u, &layout) != 0) {
        fprintf(stderr, "fixture layout failed\n");
        exit(2);
    }
    f->arena = calloc(layout.arena_bytes, 1u);
    f->arena_bytes = layout.arena_bytes;
    if (action_family_3e_construct(body, n, &text, 1u, 0u, 1u, f->arena, f->arena_bytes, &built) != 0) {
        fprintf(stderr, "fixture construct failed\n");
        exit(2);
    }
    f->obj.arena = f->arena;
    f->obj.arena_bytes = f->arena_bytes;
    f->obj.handle_base = 1u;
    convo3f_manager_reset(&f->m);
    f->w.events = f->events; f->w.event_count = 8u;
    f->w.presence = f->presence; f->w.presence_count = 8u;
    f->w.held_item = -1;
    f->w.mode_583999 = 3;
    f->w.selected_570374 = 0;
    f->w.ui_5b0a76 = 100; f->w.ui_5b0a1e = 50; f->w.ui_5b0a16 = 10;
    f->w.view_x_583186 = 0; f->w.view_y_58318a = 0;
    f->snd.context = f;
    f->snd.load_sound = cb_load; f->snd.play_sound = cb_play;
    f->snd.is_playing = cb_isplaying; f->snd.unload_sound = cb_unload;
    f->host.context = f;
    f->host.sound = &f->snd;
    f->host.release_engine_view = cb_view; f->host.engine_mode = cb_mode; f->host.engine_aux = cb_aux;
    f->host.inventory_add = cb_add; f->host.inventory_remove = cb_rm;
    f->host.acquire_surface = cb_acq; f->host.release_surface = cb_rel;
    f->host.layout_text_box = cb_layout;
    f->host.scene_stack_pop = cb_pop;
    f->host.release_ui_hook = cb_ui; f->host.engine_restore = cb_restore;
    f->host.cel_load_header = cb_header; f->host.cel_tree_index = cb_tree_index;
    f->host.cel_tree_info = cb_tree_info; f->host.cel_load_layer = cb_load_layer;
    f->host.cel_free_layer = cb_free_layer; f->host.cel_release_header = cb_release_header;
    f->host.cel_reader_create = cb_rd_create; f->host.cel_reader_resume = cb_rd_resume;
    f->host.cel_reader_destroy = cb_rd_destroy;
    f->host.sound_sync_init = cb_sync_init; f->host.sound_sync_frame = cb_sync_frame;
    f->next_slot = 5;
    /* CIFTREE header block: layer count at +0x24, sync param at +0x26, names per frame. */
    f->block[0x24] = (uint8_t)layers;
    f->block[0x26] = 0x39; f->block[0x27] = 0x30; /* 12345 */
    for (i = 0; i < (size_t)last + 1u && i < MAX_FRAMES; ++i) {
        uint8_t *fr = f->block + HDR_BYTES + i * CONVO3F_CEL_FRAME_STRIDE;
        snprintf((char *)fr, 33u, "fA%03zu", i);
        snprintf((char *)fr + 33, 33u, "fB%03zu", i);
    }
    f->block_bytes = sizeof(f->block);
    f->tree_kind[1] = 0; f->tree_transp[1] = 1;
    f->tree_kind[2] = 1; f->tree_transp[2] = 2;
    f->load_status = ACTION_SOUND_BACKEND_OK;
    f->sync_playing = 1;
}
static void fx_free(Fx *f) { free(f->arena); f->arena = NULL; }

static int step(Fx *f, uint32_t phase)
{
    f->log[0] = 0;
    return convo3f_step_type(&f->m, &f->obj, CONVO3E_RUNTIME_TYPE, 3, phase, &f->w, &f->host, &f->r,
                             &f->why);
}
static int pass(Fx *f, int n)
{
    int i, ran = 0, status = CONVO3F_OK;
    f->log[0] = 0;
    for (i = 0; i < n && status == CONVO3F_OK; ++i) {
        status = convo3f_cel_reader_iteration(&f->m, &f->host, &ran, &f->why);
    }
    return status;
}

static void t_capacity(void)
{
    static const struct { int16_t first, last, pct; int expect; } k[] = {
        {0, 99, 1, 4},      /* 100 * 0.01 = 1 -> floor 4 */
        {0, 999, 1, 10},    /* 1000 * 0.01 = 10 */
        {0, 399, 50, 75},   /* 400 * 0.5 = 200 -> cap 0x4b */
        {10, 109, 3, 4},    /* 100 * 0.03 = 3 -> 4 */
        {0, 599, 3, 18},    /* 600 * 0.03 = 18 */
        {0, 299, -5, 4},    /* not positive: stays 0 -> 4 */
    };
    size_t i;
    for (i = 0; i < sizeof(k) / sizeof(k[0]); ++i) {
        Fx f;
        fx_build(&f, (uint16_t)(k[i].last < 1 ? 1 : k[i].last), 2);
        f.arena[0xa8] = (uint8_t)k[i].first; f.arena[0xa9] = (uint8_t)((uint16_t)k[i].first >> 8);
        f.arena[0xac] = (uint8_t)k[i].pct; f.arena[0xad] = (uint8_t)((uint16_t)k[i].pct >> 8);
        f.arena[0xaa] = (uint8_t)k[i].last; f.arena[0xab] = (uint8_t)((uint16_t)k[i].last >> 8);
        CHECK(step(&f, 0) == CONVO3F_OK);
        CHECK(f.m.cel.capacity == k[i].expect);
        fx_free(&f);
    }
}

static void t_phase0(void)
{
    Fx f;
    fx_build(&f, 120, 2);
    f.w.engine_583204 = 4;
    CHECK(step(&f, 0) == CONVO3F_OK);
    CHECK_LOG(&f, "view4 mode2 aux0 acq(N,5) acq(H,6) load(talk_line,12) hdr(cel_hdr) idx(layerA) idx(layerB) rdcreate rdresume");
    CHECK(f.r.phase_after == 1u && f.m.sub_state == 1u && f.m.cel_thread == 1);
    CHECK(f.m.cel.sound_offset == 0x13a && f.m.cel.capacity == 4);
    CHECK(f.m.cel.first == 0 && f.m.cel.last == 120 && f.m.cel.frame == 0 && f.m.cel.next == 0);
    CHECK(f.m.cel.drawn == -10 && f.m.cel.target == -10 && f.m.cel.final_seen == 0);
    CHECK(f.m.cel.layer_count == 2 && f.m.cel.layer_tree[0] == 1 && f.m.cel.layer_tree[1] == 2);
    CHECK(f.m.cel.sync_param == 12345u && f.m.cel.slot == -1 && f.m.cel.loaded == 0);
    CHECK(memcmp(f.m.display_name, "cel hdr", 8) == 0);
    CHECK(f.w.flag_5c39e9 == 1 && f.w.flag_5c39ed == 1);
    CHECK(f.m.cel.saved_src[2][2] == 1 && f.m.cel.saved_dst[3][3] == 1);
    fx_free(&f);
}

static void t_phase0_failures(void)
{
    Fx f;
    fx_build(&f, 50, 2);
    f.fail_header = 1;
    CHECK(step(&f, 0) == CONVO3F_ERR_HOST);
    fx_free(&f);
    fx_build(&f, 50, 2);
    f.fail_layer_index = 1;
    CHECK(step(&f, 0) == CONVO3F_ERR_HOST && f.m.cel_thread == 0);
    fx_free(&f);
    fx_build(&f, 50, 3); /* above two layers: names exist for two only */
    CHECK(step(&f, 0) == CONVO3F_ERR_BOUNDS && f.m.cel_thread == 0);
    fx_free(&f);
    fx_build(&f, 50, 2);
    f.arena[0xa8] = 9; f.arena[0xaa] = 3; /* last < first */
    CHECK(step(&f, 0) == CONVO3F_ERR_BOUNDS && f.log[0] == 0 && f.w.flag_5c39e9 == 0);
    fx_free(&f);
}

static void t_unsupported_without_callbacks(void)
{
    Fx f;
    fx_build(&f, 50, 2);
    f.host.cel_reader_resume = NULL;
    CHECK(step(&f, 0) == CONVO3F_ERR_UNSUPPORTED);
    CHECK(f.log[0] == 0 && f.w.flag_5c39e9 == 0 && f.m.row == -1);
    fx_free(&f);
    fx_build(&f, 50, 2);
    f.host.sound_sync_frame = NULL;
    CHECK(step(&f, 0) == CONVO3F_ERR_UNSUPPORTED && f.log[0] == 0);
    fx_free(&f);
    fx_build(&f, 50, 2);
    f.obj.arena[0x779] = 3; /* hook builder (tier C) */
    CHECK(step(&f, 0) == CONVO3F_ERR_UNSUPPORTED && f.log[0] == 0);
    fx_free(&f);
}

static void t_teardown_of_old_reader(void)
{
    Fx f;
    fx_build(&f, 50, 2);
    CHECK(step(&f, 0) == CONVO3F_OK);
    CHECK(pass(&f, 3) == CONVO3F_OK);
    CHECK(f.m.cel.loaded == 3);
    /* A second conversation starts while the first reader still exists. */
    f.w.flag_5c39e9 = f.w.flag_5c39ed = 0;
    f.m.cel.block = NULL; /* the header block of the previous row was released by the host */
    CHECK(step(&f, 0) == CONVO3F_OK);
    CHECK(strstr(f.log, "rddestroy") != NULL && strstr(f.log, "fr(0,0,") != NULL);
    CHECK(strstr(f.log, "rddestroy") < strstr(f.log, "fr(0,0,"));
    CHECK(f.m.cel.loaded == 0 && f.m.cel_thread == 1 && f.m.cel.lock == 0);
    fx_free(&f);
}

static void t_reader_and_start(void)
{
    Fx f;
    fx_build(&f, 120, 2);
    CHECK(step(&f, 0) == CONVO3F_OK);
    /* state 1: nothing cached yet (loaded 0 != capacity 4 and last 120 > 0) */
    CHECK(step(&f, 1) == CONVO3F_OK && f.m.sub_state == 1u && f.log[0] == 0);
    /* the reader loads frame 0 (two layers) and advances by the step byte 1 */
    CHECK(pass(&f, 1) == CONVO3F_OK);
    CHECK_LOG(&f, "ld(1,fA000) ld(2,fB000)");
    CHECK(f.m.cel.loaded == 1 && f.m.cel.slots[0].frame == 0 && f.m.cel.next == 1);
    CHECK(pass(&f, 3) == CONVO3F_OK);
    CHECK(f.m.cel.loaded == 4 && f.m.cel.next == 4); /* full cache: 0x696 == 4 */
    CHECK(pass(&f, 2) == CONVO3F_OK && f.m.cel.next == 4 && f.m.cel.loaded == 4 && f.log[0] == 0);
    CHECK(step(&f, 1) == CONVO3F_OK);
    CHECK_LOG(&f, "sync(12,121,12345)");
    CHECK(f.m.sub_state == 4u && f.m.cel.slot == 0 && f.m.cel.target == 0 && f.m.cel.sync_count == 121);
    fx_free(&f);
    /* sound without a resource: SyncInit fails and the original aborts */
    fx_build(&f, 120, 2);
    f.load_status = ACTION_SOUND_BACKEND_NO_RESOURCE;
    CHECK(step(&f, 0) == CONVO3F_OK);
    CHECK(pass(&f, 4) == CONVO3F_OK);
    CHECK(step(&f, 1) == CONVO3F_ERR_HOST);
    fx_free(&f);
    fx_build(&f, 120, 2);
    CHECK(step(&f, 0) == CONVO3F_OK);
    CHECK(pass(&f, 4) == CONVO3F_OK);
    f.fail_sync_init = 1;
    CHECK(step(&f, 1) == CONVO3F_ERR_HOST);
    fx_free(&f);
}

static void start_running(Fx *f, uint16_t last)
{
    fx_build(f, last, 2);
    CHECK(step(f, 0) == CONVO3F_OK);
    CHECK(pass(f, 8) == CONVO3F_OK);
    CHECK(step(f, 1) == CONVO3F_OK && f->m.sub_state == 4u);
}

static void t_frame_choice(void)
{
    /* cel_set_target (0x422970): target follows the frame; cel_announce (0x4229b5):
     * drawn follows target and the flag rises only on a change (checks below). */
    Fx f;
    start_running(&f, 120);
    f.m.cel.next = 120; /* keep the reader from moving: loaded slots hold frames 0..3 */
    /* sound at frame 2: slot found, shown, flag raised */
    f.sync_raw = 2;
    CHECK(step(&f, 1) == CONVO3F_OK);
    CHECK(f.m.cel.frame == 2 && f.m.cel.slot == 2 && f.m.cel.target == 2 && f.m.cel.drawn == 2);
    CHECK(f.w.ui_5d191d == 1 && f.w.start_5bb1ca == 1 && f.m.sub_state == 4u);
    /* the position can only grow: raw 1 after 2 stays at 2 */
    f.w.ui_5d191d = 0;
    f.sync_raw = 1;
    CHECK(step(&f, 1) == CONVO3F_OK);
    CHECK(f.m.cel.frame == 2 && f.w.ui_5d191d == 0);
    /* not playing: frame -> last; the frame is not cached: stall, boost, jump */
    f.sync_playing = 0;
    CHECK(step(&f, 1) == CONVO3F_OK);
    CHECK(f.m.cel.frame == 120 && f.m.cel.stall == 0 && f.m.cel.boost == 1 && f.m.cel.forced == 120);
    CHECK(f.m.sub_state == 4u && f.m.cel.drawn == 2);
    /* the position never exceeds the frame count - 1 */
    f.sync_playing = 1;
    f.sync_raw = 500;
    CHECK(step(&f, 1) == CONVO3F_OK && f.m.cel.sync_last == 120);
    fx_free(&f);
}

static void t_stall_boost_decay(void)
{
    Fx f;
    int i;
    start_running(&f, 120);
    f.m.cel.next = 120;
    f.sync_raw = 50; /* never cached */
    for (i = 0; i < 8; ++i) {
        CHECK(step(&f, 1) == CONVO3F_OK);
    }
    /* stall limit 0: every miss raises the boost, capped at 5 */
    CHECK(f.m.cel.boost == 5 && f.m.cel.forced == 55);
    f.w.stall_limit_5b028e = 3;
    f.m.cel.boost = 0; f.m.cel.stall = 0;
    for (i = 0; i < 3; ++i) {
        CHECK(step(&f, 1) == CONVO3F_OK);
    }
    CHECK(f.m.cel.boost == 1 && f.m.cel.stall == 0);
    /* a hit decays the boost once relax reaches the limit */
    f.sync_raw = 0; f.m.cel.boost = 2; f.m.cel.relax = 0;
    f.m.cel.sync_last = 0;
    f.m.cel.frame = 0;
    for (i = 0; i < 3; ++i) {
        CHECK(step(&f, 1) == CONVO3F_OK);
    }
    CHECK(f.m.cel.boost == 1 && f.m.cel.relax == 0);
    fx_free(&f);
}

static void t_finish_and_fast_convo(void)
{
    /* cel_set_target (0x422970) marks final_seen once the frame reaches last. */
    Fx f;
    start_running(&f, 3); /* frames 0..3, capacity 4: all cached after the passes */
    f.sync_raw = 3;
    CHECK(step(&f, 1) == CONVO3F_OK);
    CHECK(f.m.cel.drawn == 3 && f.m.cel.final_seen == 1 && f.m.sub_state == 4u);
    CHECK(step(&f, 1) == CONVO3F_OK); /* drawn == last: end condition, no responses */
    CHECK(f.m.sub_state == 5u && f.w.selected_570374 == CONVO3F_NO_SELECTION);
    CHECK(step(&f, 1) == CONVO3F_OK);
    CHECK_LOG(&f, "unload(12)");
    CHECK(f.r.phase_after == 2u);
    fx_free(&f);
    /* Fast Convo ends only with the skip key, even before the last frame */
    start_running(&f, 120);
    f.w.fast_convo_58322a = 1;
    f.sync_raw = 1;
    CHECK(step(&f, 1) == CONVO3F_OK && f.m.sub_state == 4u);
    f.w.skip_key_58321d = 1;
    f.host.poll_keys = NULL;
    CHECK(step(&f, 1) == CONVO3F_OK && f.m.sub_state == 5u);
    fx_free(&f);
}

static void t_reader_rules(void)
{
    /* cel_evict_pass (0x41dfd2) and cel_find_slot (0x41e1e4) of src/action_family_3f_runtime.c, observed through
     * convo3f_cel_reader_iteration: eviction below the shown frame (not the shown slot), slot lookup by frame;
     * the eviction frees each loaded layer through cel_free_layer_header (0x4c2e5b), the fr(...) log entries. */
    Fx f;
    fx_build(&f, 120, 2);
    CHECK(step(&f, 0) == CONVO3F_OK);
    CHECK(pass(&f, 4) == CONVO3F_OK && f.m.cel.loaded == 4);
    /* forced jump: one load of the target frame is not possible without a free slot */
    f.m.cel.forced = 10;
    f.m.cel.next = 5;
    CHECK(pass(&f, 1) == CONVO3F_OK && f.m.cel.next == 5 && f.m.cel.forced == 10 && f.log[0] == 0);
    /* the sound reached frame 3 and slot 1 is shown: frames below 3 are evicted except the shown slot */
    f.m.cel.frame = 3;
    f.m.cel.slot = 1;
    CHECK(pass(&f, 1) == CONVO3F_OK);
    CHECK(strstr(f.log, "fr(0,") != NULL && strstr(f.log, "fr(2,") != NULL && strstr(f.log, "fr(1,") == NULL);
    CHECK(f.m.cel.slots[1].frame == 1 && f.m.cel.next == 10 && f.m.cel.forced == -1);
    CHECK(f.m.cel.slots[0].frame == 5 && f.m.cel.loaded == 3); /* load of frame 5, then the jump */
    /* boost adds to the step */
    f.m.cel.boost = 4;
    f.m.cel.next = 100;
    f.m.cel.frame = 119;
    f.m.cel.slot = -1;
    CHECK(pass(&f, 1) == CONVO3F_OK && f.m.cel.next == 105);
    /* the advance is clamped to the last frame */
    f.m.cel.next = 119;
    CHECK(pass(&f, 1) == CONVO3F_OK && f.m.cel.next == 120);
    /* closing lock: no work */
    f.m.cel.lock = 2;
    f.m.cel.next = 20;
    CHECK(pass(&f, 1) == CONVO3F_OK && f.m.cel.next == 20 && f.log[0] == 0);
    /* no reader thread: no work */
    f.m.cel.lock = 0;
    f.m.cel_thread = 0;
    CHECK(pass(&f, 1) == CONVO3F_OK && f.log[0] == 0);
    fx_free(&f);
}

static int blits_equal(const Convo3fBlit *b, uint8_t kind, uint32_t surface, int16_t key,
                       int32_t d0, int32_t d1, int32_t d2, int32_t d3)
{
    return b->kind == kind && b->surface == surface && b->key == key && b->dst[0] == d0 &&
           b->dst[1] == d1 && b->dst[2] == d2 && b->dst[3] == d3;
}

static void t_render(void)
{
    Fx f;
    Convo3fRenderPlan plan;
    start_running(&f, 120);
    f.m.cel.next = 120;
    f.sync_raw = 1;
    CHECK(step(&f, 1) == CONVO3F_OK && f.w.ui_5d191d == 1);
    f.w.view_x_583186 = 100;
    f.w.view_y_58318a = 50;
    CHECK(convo3f_cel_render(&f.m, &f.obj, &f.w, &f.host, &plan, &f.why) == CONVO3F_OK);
    /* priorities 1,0: layer 1 (kind 1, opaque) first, then layer 0 (kind 0, keyed with restore) */
    CHECK(f.w.ui_5d191d == 0 && plan.count == 3u);
    CHECK(plan.blits[0].kind == CONVO3F_BLIT_OPAQUE && plan.blits[0].key == 9);
    CHECK(blits_equal(&plan.blits[0], CONVO3F_BLIT_OPAQUE, f.m.cel.slots[1].layer[1].surface, 9, 120, 90,
                      184, 138));
    CHECK(plan.blits[1].kind == CONVO3F_BLIT_RESTORE && plan.blits[2].kind == CONVO3F_BLIT_TRANSPARENT);
    CHECK(plan.blits[1].src[0] == 10 && plan.blits[1].src[2] == 74); /* the unshifted destination */
    CHECK(plan.blits[1].dst[0] == 110 && plan.blits[1].dst[3] == 118);
    /* equal priorities: the scan moves to the next order value after the first layer (0x422e20) */
    f.arena[0xb2] = 0; f.arena[0xb3] = 0;
    f.w.ui_5d191d = 1;
    CHECK(convo3f_cel_render(&f.m, &f.obj, &f.w, &f.host, &plan, &f.why) == CONVO3F_OK);
    CHECK(plan.count == 2u && plan.blits[1].kind == CONVO3F_BLIT_TRANSPARENT);
    f.arena[0xb2] = 1; f.arena[0xb3] = 0;
    /* independent layer kind 2: restore of the saved rectangles, then they are updated */
    f.tree_kind[2] = 2;
    f.w.ui_5d191d = 1;
    CHECK(convo3f_cel_render(&f.m, &f.obj, &f.w, &f.host, &plan, &f.why) == CONVO3F_OK);
    CHECK(plan.blits[0].kind == CONVO3F_BLIT_RESTORE && plan.blits[0].src[2] == 1 && plan.blits[0].dst[0] == 0 + 0);
    CHECK(f.m.cel.saved_src[1][0] == f.m.cel.slots[1].layer[1].dst[0]);
    CHECK(f.m.cel.saved_dst[1][0] == f.m.cel.slots[1].layer[1].dst[0] + 100);
    /* not a cel row: only the flag is cleared */
    f.m.type = CONVO3F_RUNTIME_TYPE;
    f.w.ui_5d191d = 1;
    CHECK(convo3f_cel_render(&f.m, &f.obj, &f.w, &f.host, &plan, &f.why) == CONVO3F_OK && plan.count == 0u);
    CHECK(f.w.ui_5d191d == 0);
    fx_free(&f);
}

static void t_finish(void)
{
    Fx f;
    start_running(&f, 3);
    f.sync_raw = 3;
    CHECK(step(&f, 1) == CONVO3F_OK && step(&f, 1) == CONVO3F_OK && step(&f, 1) == CONVO3F_OK);
    CHECK(f.r.phase_after == 2u);
    CHECK(step(&f, 2) == CONVO3F_OK);
    CHECK(strstr(f.log, "rddestroy") != NULL && strstr(f.log, "relhdr") != NULL);
    CHECK(strstr(f.log, "rddestroy") < strstr(f.log, "fr(0,0,"));
    CHECK(strstr(f.log, "fr(0,0,") < strstr(f.log, "rel(5)"));
    CHECK(strstr(f.log, "rel(6)") < strstr(f.log, "relhdr"));
    CHECK(f.r.finished == 1u && f.r.object_released == 1u && f.r.scene_change == 1u);
    CHECK(f.w.xfer_5bb57b == 1052 && f.w.mode_583999 == 4);
    CHECK(f.m.cel_thread == 0 && f.m.cel.loaded == 0 && f.m.cel.block == NULL);
    CHECK(f.m.cel.layer_count == 0 && f.m.cel.header[0x24] == 0 && f.m.cel.slots[0].frame == -1 && f.m.cel.forced == -1);
    fx_free(&f);
}

static void t_release_all_and_type(void)
{
    Fx f;
    start_running(&f, 120);
    f.log[0] = 0;
    CHECK(convo3f_cel_release_all(&f.m, &f.host, &f.why) == CONVO3F_OK);
    CHECK(strstr(f.log, "rddestroy") != NULL && strstr(f.log, "relhdr") != NULL);
    CHECK(f.m.cel_thread == 0 && f.m.cel.loaded == 0 && f.m.cel.block == NULL);
    fx_free(&f);
    /* a 0x3f step against a 0x3e row is refused at phase 1 */
    start_running(&f, 120);
    CHECK(convo3f_step_type(&f.m, &f.obj, CONVO3F_RUNTIME_TYPE, 3, 1, &f.w, &f.host, &f.r, &f.why) ==
          CONVO3F_ERR_BOUNDS);
    CHECK(convo3f_step_type(&f.m, &f.obj, 0x39, 3, 0, &f.w, &f.host, &f.r, &f.why) ==
          CONVO3F_ERR_UNSUPPORTED);
    fx_free(&f);
}

static void t_layer_load_failures(void)
{
    Fx f;
    /* the second layer of the first frame fails: the first layer is released, no half-loaded slot stays */
    fx_build(&f, 120, 2);
    CHECK(step(&f, 0) == CONVO3F_OK);
    f.fail_load_layer_at = 2;
    CHECK(pass(&f, 1) == CONVO3F_ERR_HOST);
    CHECK(strstr(f.log, "fr(0,0,") != NULL);
    CHECK(f.m.cel.loaded == 0 && f.m.cel.slots[0].frame == -1 && f.m.cel.slots[0].layer[0].loaded == 0u);
    fx_free(&f);
    /* a host that reports success but leaves the layer unloaded is refused */
    fx_build(&f, 120, 2);
    CHECK(step(&f, 0) == CONVO3F_OK);
    f.layer_unloaded = 1;
    CHECK(pass(&f, 1) == CONVO3F_ERR_HOST);
    CHECK(f.m.cel.loaded == 0 && f.m.cel.slots[0].frame == -1);
    fx_free(&f);
}

/* A raw 0x3f row after a finished 0x3e row must not inherit the cel sound descriptor offset. */
static void t_sound_offset_resets(void)
{
    Fx f;
    uint8_t body[80];
    ActionFamily3fText text;
    ActionFamily3fConstructed layout;
    Convo3fObject obj3f;
    uint8_t *arena;
    int status;
    start_running(&f, 3);
    f.sync_raw = 3;
    CHECK(step(&f, 1) == CONVO3F_OK && step(&f, 1) == CONVO3F_OK && step(&f, 1) == CONVO3F_OK);
    CHECK(step(&f, 2) == CONVO3F_OK && f.m.cel.sound_offset == C3E_SOUND);
    /* a minimal raw 0x3f body: 77-byte prefix, no primary entries, no secondary entries */
    memset(body, 0, sizeof body);
    put_name(body, "hello_world");
    body[33] = 85;
    put_name(body + 35, "K");
    body[68] = body[69] = CONVO3F_NO_HOOK;
    body[70] = 1;
    body[71] = 0x1c; body[72] = 0x04;
    text.bytes = (const uint8_t *)"caption";
    text.length = 7u;
    CHECK(action_family_3f_construct(body, 79u, &text, 1u, 0u, 1u, NULL, 0u, &layout) == 0);
    arena = calloc(layout.arena_bytes, 1u);
    CHECK(action_family_3f_construct(body, 79u, &text, 1u, 0u, 1u, arena, layout.arena_bytes, &layout) == 0);
    obj3f.arena = arena;
    obj3f.arena_bytes = layout.arena_bytes;
    obj3f.handle_base = 1u;
    f.w.flag_5c39e9 = f.w.flag_5c39ed = 0;
    f.w.mode_583999 = 3;
    status = convo3f_step_type(&f.m, &obj3f, CONVO3F_RUNTIME_TYPE, 4, 0, &f.w, &f.host, &f.r, &f.why);
    CHECK(status == CONVO3F_OK && f.m.type == CONVO3F_RUNTIME_TYPE);
    CHECK(f.m.cel.sound_offset == 0);
    free(arena);
    fx_free(&f);
}

typedef void (*TestFn)(void);
static const struct { const char *name; TestFn fn; } TESTS[] = {
    {"capacity_formula", t_capacity},
    {"phase0_cel_init", t_phase0},
    {"phase0_failures", t_phase0_failures},
    {"unsupported_without_callbacks", t_unsupported_without_callbacks},
    {"teardown_of_old_reader", t_teardown_of_old_reader},
    {"reader_loads_and_state1_starts_sync", t_reader_and_start},
    {"frame_choice_clamp_and_stall", t_frame_choice},
    {"stall_boost_and_decay", t_stall_boost_decay},
    {"finish_and_fast_convo", t_finish_and_fast_convo},
    {"reader_rules", t_reader_rules},
    {"render_plan", t_render},
    {"phase2_cleanup", t_finish},
    {"release_all_and_type_guard", t_release_all_and_type},
    {"layer_load_failures", t_layer_load_failures},
    {"sound_offset_resets_for_0x3f", t_sound_offset_resets},
};

int main(void)
{
    size_t i, failures = 0;
    for (i = 0; i < sizeof(TESTS) / sizeof(TESTS[0]); ++i) {
        g_name = TESTS[i].name;
        g_failed = 0;
        g_msg[0] = 0;
        TESTS[i].fn();
        if (g_failed) {
            printf("FAIL %s: %s\n", g_name, g_msg);
            ++failures;
        } else {
            printf("PASS %s\n", g_name);
        }
    }
    return (int)failures;
}
