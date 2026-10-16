/* RT-23 unit tests of the raw 0x3f conversation kernel (src/action_family_3f_runtime.c).
 * Prints "PASS <name>" / "FAIL <name>: <message>" per test; exit status is the
 * failure count. Fixtures are synthetic raw bodies run through the A-3F.1
 * constructor; no original bytes are used. tests/test_action_family_3f_runtime.py
 * builds and runs this with and without ASan/UBSan. */
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_3f.h"
#include "action_family_3f_runtime.h"

/* ---- tiny framework ---- */
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
            snprintf(g_msg, sizeof g_msg, "line %d: log \"%.100s\" != \"%.100s\"", __LINE__, (f)->log, (expected)); \
        }                                                                    \
    } while (0)

/* ---- fixture ---- */
typedef struct { uint8_t kind; int16_t index; uint8_t value; uint8_t link; } Cond;
typedef struct { int n; Cond c[8]; const char *text; const char *sound; int16_t scene; } PSpec;
typedef struct { int n; Cond c[8]; uint8_t kind; int16_t id; uint8_t value; } SSpec;
typedef struct {
    const char *name;
    const char *caption;
    uint16_t percent;
    uint8_t hook_a, hook_b, default_enable;
    int16_t default_scene, default_w1;
    int np, ns;
    PSpec p[40];
    SSpec s[8];
} Spec;

typedef struct Fx {
    Convo3fManager m;
    Convo3fWorld w;
    int32_t events[64], presence[64];
    uint8_t *arena;
    size_t arena_bytes;
    Convo3fObject obj;
    Convo3fHost host;
    ActionSoundBackend snd;
    char log[2048];
    int playing_for[32];  /* is_playing returns 1 this many times, then 0 */
    int load_status;      /* ActionSoundBackendStatus for load_sound */
    int fail_keys, pop_fail, fail_playing;
    uint8_t key_value;
    const char *resp_sound[40];
    int next_slot;
    Convo3fStepResult r;
    const char *why;
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
    Fx *f = c;
    logf_(f, "isplay(%u)", ch);
    if (f->fail_playing) {
        return ACTION_SOUND_BACKEND_ERROR;
    }
    *still = f->playing_for[ch] > 0;
    if (f->playing_for[ch] > 0) {
        --f->playing_for[ch];
    }
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
static int cb_hot(void *c, int32_t x, int32_t y) { logf_(c, "hot(%d,%d)", (int)x, (int)y); return 0; }
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
    Fx *f = c;
    int i;
    logf_(f, "layout(%d,%d)", (int)q->response_count, (int)q->caption_length);
    for (i = 0; i < q->response_count; ++i) {
        if (f->resp_sound[i] != NULL) {
            strcpy((char *)w->ui_sound_names[i], f->resp_sound[i]);
        }
    }
    return 0;
}
static int cb_refresh(void *c, int16_t slot) { logf_(c, "refresh(%d)", slot); return 0; }
static int cb_keys(void *c, uint8_t *skip, uint8_t *other)
{
    Fx *f = c;
    if (f->fail_keys) {
        return 1;
    }
    *skip = f->key_value;
    *other = 0;
    logf_(f, "keys");
    return 0;
}
static int cb_pop(void *c, Convo3fWorld *w)
{
    Fx *f = c;
    logf_(f, "pop");
    if (f->pop_fail) {
        return 1;
    }
    w->xfer_5bb57b = 77;
    w->xfer_5c39ff = 1;
    w->start_5bb1ca = 1;
    w->mode_583999 = 4;
    return 0;
}
static int cb_ui(void *c, int32_t v) { logf_(c, "ui%d", (int)v); return 0; }
static int cb_restore(void *c) { logf_(c, "restore"); return 0; }

static void put_name(uint8_t *dst, const char *s)
{
    memset(dst, 0, 33u);
    memcpy(dst, s, strlen(s));
}

static size_t make_body(const Spec *sp, uint8_t *b)
{
    size_t n = 0, i, k;
    memset(b, 0, 77u);
    put_name(b, sp->name);
    b[33] = (uint8_t)sp->percent; b[34] = (uint8_t)(sp->percent >> 8);
    put_name(b + 35, "K");
    b[68] = sp->hook_a; b[69] = sp->hook_b; b[70] = sp->default_enable;
    b[71] = (uint8_t)sp->default_scene; b[72] = (uint8_t)((uint16_t)sp->default_scene >> 8);
    b[73] = (uint8_t)sp->default_w1; b[74] = (uint8_t)((uint16_t)sp->default_w1 >> 8);
    b[75] = (uint8_t)sp->np; b[76] = (uint8_t)(sp->np >> 8);
    n = 77u;
    for (i = 0; i < (size_t)sp->np; ++i) {
        const PSpec *p = &sp->p[i];
        b[n] = (uint8_t)p->n; b[n + 1] = 0;
        n += 2u;
        for (k = 0; k < (size_t)p->n; ++k, n += 5u) {
            b[n] = p->c[k].kind; b[n + 1] = (uint8_t)p->c[k].index;
            b[n + 2] = (uint8_t)((uint16_t)p->c[k].index >> 8);
            b[n + 3] = p->c[k].value; b[n + 4] = p->c[k].link;
        }
        put_name(b + n, "RK"); n += 33u;
        put_name(b + n, p->sound != NULL ? p->sound : "NO SOUND"); n += 33u;
        b[n] = (uint8_t)p->scene; b[n + 1] = (uint8_t)((uint16_t)p->scene >> 8); n += 2u;
    }
    b[n] = (uint8_t)sp->ns; b[n + 1] = 0; n += 2u;
    for (i = 0; i < (size_t)sp->ns; ++i) {
        const SSpec *s = &sp->s[i];
        b[n] = (uint8_t)s->n; b[n + 1] = 0; n += 2u;
        for (k = 0; k < (size_t)s->n; ++k, n += 5u) {
            b[n] = s->c[k].kind; b[n + 1] = (uint8_t)s->c[k].index;
            b[n + 2] = (uint8_t)((uint16_t)s->c[k].index >> 8);
            b[n + 3] = s->c[k].value; b[n + 4] = s->c[k].link;
        }
        b[n] = s->kind; b[n + 1] = (uint8_t)s->id; b[n + 2] = (uint8_t)((uint16_t)s->id >> 8);
        b[n + 3] = s->value; n += 4u;
    }
    return n;
}

static void spec_default(Spec *s)
{
    memset(s, 0, sizeof(*s));
    s->name = "hello_world";
    s->caption = "caption";
    s->percent = 85;
    s->hook_a = s->hook_b = CONVO3F_NO_HOOK;
    s->default_enable = 1;
    s->default_scene = 1052;
    s->default_w1 = 0;
}

static void fx_build(Fx *f, const Spec *sp)
{
    uint8_t body[16384];
    ActionFamily3fText texts[41];
    ActionFamily3fConstructed layout, built;
    size_t n = make_body(sp, body), i;
    memset(f, 0, sizeof(*f));
    texts[0].bytes = (const uint8_t *)sp->caption;
    texts[0].length = strlen(sp->caption);
    for (i = 0; i < (size_t)sp->np; ++i) {
        texts[i + 1].bytes = (const uint8_t *)sp->p[i].text;
        texts[i + 1].length = strlen(sp->p[i].text);
    }
    if (action_family_3f_construct(body, n, texts, (size_t)sp->np + 1u, 0u, 1u, NULL, 0u, &layout) != 0) {
        fprintf(stderr, "fixture layout failed\n");
        exit(2);
    }
    f->arena = calloc(layout.arena_bytes, 1u);
    f->arena_bytes = layout.arena_bytes;
    if (action_family_3f_construct(body, n, texts, (size_t)sp->np + 1u, 0u, 1u, f->arena,
                                   f->arena_bytes, &built) != 0) {
        fprintf(stderr, "fixture construct failed\n");
        exit(2);
    }
    f->obj.arena = f->arena;
    f->obj.arena_bytes = f->arena_bytes;
    f->obj.handle_base = 1u;
    convo3f_manager_reset(&f->m);
    f->w.events = f->events; f->w.event_count = 64u;
    f->w.presence = f->presence; f->w.presence_count = 64u;
    f->w.held_item = -1;
    f->w.mode_583999 = 3;
    f->w.selected_570374 = 0;
    f->w.ui_5b0a76 = 100; f->w.ui_5b0a1e = 50; f->w.ui_5b0a16 = 10;
    f->snd.context = f;
    f->snd.load_sound = cb_load; f->snd.play_sound = cb_play;
    f->snd.is_playing = cb_isplaying; f->snd.unload_sound = cb_unload;
    f->host.context = f;
    f->host.sound = &f->snd;
    f->host.release_engine_view = cb_view; f->host.engine_mode = cb_mode; f->host.engine_aux = cb_aux;
    f->host.cursor_hotspot = cb_hot; f->host.inventory_add = cb_add; f->host.inventory_remove = cb_rm;
    f->host.acquire_surface = cb_acq; f->host.release_surface = cb_rel;
    f->host.layout_text_box = cb_layout; f->host.refresh_hotspot_surface = cb_refresh;
    f->host.poll_keys = cb_keys; f->host.scene_stack_pop = cb_pop;
    f->host.release_ui_hook = cb_ui; f->host.engine_restore = cb_restore;
    f->next_slot = 5;
}
static void fx_free(Fx *f) { free(f->arena); f->arena = NULL; }

static int step(Fx *f, uint32_t phase)
{
    f->log[0] = 0;
    return convo3f_step(&f->m, &f->obj, 3, phase, &f->w, &f->host, &f->r, &f->why);
}

/* Drives a tier A conversation to the end; returns the final status. */
static void run_to_phase2(Fx *f)
{
    CHECK(step(f, 0) == CONVO3F_OK);
    CHECK(f->r.phase_after == 1u);
    CHECK(step(f, 1) == CONVO3F_OK); /* sound not playing: sub 5 */
    CHECK(f->m.sub_state == 5u);
    CHECK(step(f, 1) == CONVO3F_OK);
    CHECK(f->r.phase_after == 2u);
}

/* ---- tier A ---- */
static void t_gate_flags(void)
{
    Spec sp; Fx f;
    spec_default(&sp); fx_build(&f, &sp);
    f.w.flag_5c39e9 = 1;
    CHECK(step(&f, 0) == CONVO3F_OK);
    CHECK(f.r.ran == 0 && f.r.phase_after == 0u && f.log[0] == 0 && f.m.row == -1);
    f.w.flag_5c39e9 = 0; f.w.flag_5c39ed = 1;
    CHECK(step(&f, 0) == CONVO3F_OK);
    CHECK(f.r.ran == 0 && f.log[0] == 0 && f.m.row == -1 && f.w.flag_5c39e9 == 0);
    fx_free(&f);
}
static void t_mode_not_3(void)
{
    Spec sp; Fx f;
    spec_default(&sp); fx_build(&f, &sp);
    f.w.mode_583999 = 2;
    CHECK(step(&f, 0) == CONVO3F_OK);
    CHECK(f.r.phase_after == 0u && f.r.started == 0 && f.log[0] == 0);
    CHECK(f.w.flag_5c39e9 == 0 && f.m.row == 3); /* the original stores the row first */
    fx_free(&f);
}
static void t_phase0_effects(void)
{
    Spec sp; Fx f;
    spec_default(&sp); fx_build(&f, &sp);
    f.w.engine_583204 = 4;
    f.w.held_item = 12;
    f.w.cursor_583106 = 1; f.w.limit_5b3788 = 5;
    f.w.hotspot_x_5b378c = 20; f.w.hotspot_y_5b378e = -7;
    f.w.selected_570374 = 9;
    f.w.chosen_5839b1[3] = 1;
    CHECK(step(&f, 0) == CONVO3F_OK);
    CHECK_LOG(&f, "view4 mode2 aux0 hot(20,-7) add(12,0) acq(N,5) acq(H,6) load(hello_world,12) play(12)");
    CHECK(f.w.flag_5c39e9 == 1 && f.w.flag_5c39ed == 1);
    CHECK(f.w.engine_583204 == 2 && f.w.held_item == -1);
    CHECK(f.w.selected_570374 == CONVO3F_NO_SELECTION && f.w.chosen_5839b1[3] == 0);
    CHECK(f.m.sub_state == 4u && f.r.phase_after == 1u && f.m.row == 3);
    CHECK(memcmp(f.m.display_name, "hello world", 12) == 0); /* '_' shown as ' ' */
    CHECK(f.m.textbox_slot[0] == 5 && f.m.textbox_slot[1] == 6);
    CHECK(f.w.ui_5b0a7c == 59 && f.w.ui_5b15c8 == 1 && f.w.redraw_5831c8 == 1);
    CHECK(f.r.skipped_optional == 0u);
    f.w.engine_583204 = 3; f.m.row = -1; f.w.flag_5c39e9 = f.w.flag_5c39ed = 0; f.w.cursor_583106 = 9;
    CHECK(step(&f, 0) == CONVO3F_OK);
    CHECK(strncmp(f.log, "view3 mode2 aux0 acq", 20) == 0 && strstr(f.log, "hot(") == NULL);
    fx_free(&f);
}
static void t_optional_skips(void)
{
    Spec sp; Fx f;
    spec_default(&sp); fx_build(&f, &sp);
    memset(&f.host.release_engine_view, 0, sizeof(f.host) - offsetof(Convo3fHost, release_engine_view));
    f.host.inventory_add = NULL;
    f.w.engine_583204 = 3;
    f.w.cursor_583106 = 1; f.w.limit_5b3788 = 5;
    CHECK(step(&f, 0) == CONVO3F_OK);
    CHECK_LOG(&f, "load(hello_world,12) play(12)");
    CHECK((f.r.skipped_optional & CONVO3F_SKIP_ENGINE_VIEW) && (f.r.skipped_optional & CONVO3F_SKIP_SURFACES));
    CHECK((f.r.skipped_optional & CONVO3F_SKIP_CURSOR) && f.m.textbox_slot[0] == -1);
    fx_free(&f);
}
static void t_load_failure_advances(void)
{
    Spec sp; Fx f;
    spec_default(&sp); fx_build(&f, &sp);
    f.load_status = ACTION_SOUND_BACKEND_NO_RESOURCE;
    CHECK(step(&f, 0) == CONVO3F_OK);
    CHECK(strstr(f.log, "load(hello_world,12)") != NULL && strstr(f.log, "play(") == NULL);
    CHECK(f.r.phase_after == 1u && f.m.sub_state == 4u);
    f.load_status = ACTION_SOUND_BACKEND_ERROR; f.m.row = -1; f.w.flag_5c39e9 = f.w.flag_5c39ed = 0;
    CHECK(step(&f, 0) == CONVO3F_ERR_HOST);
    fx_free(&f);
}
static void t_sound_end_flow(void)
{
    Spec sp; Fx f;
    spec_default(&sp); fx_build(&f, &sp);
    CHECK(step(&f, 0) == CONVO3F_OK);
    f.playing_for[12] = 2;
    CHECK(step(&f, 1) == CONVO3F_OK);
    CHECK_LOG(&f, "keys isplay(12)");
    CHECK(f.m.sub_state == 4u && f.r.phase_after == 1u && f.w.start_5bb1ca == 1);
    CHECK(step(&f, 1) == CONVO3F_OK && f.m.sub_state == 4u);
    CHECK(step(&f, 1) == CONVO3F_OK); /* third query: ended */
    CHECK(f.m.sub_state == 5u && f.w.selected_570374 == CONVO3F_NO_SELECTION);
    CHECK(step(&f, 1) == CONVO3F_OK);
    CHECK_LOG(&f, "keys unload(12)");
    CHECK(f.r.phase_after == 2u);
    fx_free(&f);
}
static void t_fast_convo(void)
{
    Spec sp; Fx f;
    spec_default(&sp); fx_build(&f, &sp);
    CHECK(step(&f, 0) == CONVO3F_OK);
    f.w.fast_convo_58322a = 1;
    f.playing_for[12] = 100;
    f.key_value = 0;
    CHECK(step(&f, 1) == CONVO3F_OK && f.m.sub_state == 4u); /* playing, no key */
    f.playing_for[12] = 0;
    CHECK(step(&f, 1) == CONVO3F_OK && f.m.sub_state == 4u); /* ended, Fast Convo: key still required */
    f.key_value = 1; f.playing_for[12] = 100;
    CHECK(step(&f, 1) == CONVO3F_OK && f.m.sub_state == 5u); /* key while playing skips */
    CHECK(f.w.selected_570374 == CONVO3F_NO_SELECTION);
    CHECK(step(&f, 1) == CONVO3F_OK && f.r.phase_after == 2u);
    fx_free(&f);
}
static void t_is_playing_error(void)
{
    Spec sp; Fx f;
    spec_default(&sp); fx_build(&f, &sp);
    CHECK(step(&f, 0) == CONVO3F_OK);
    f.fail_playing = 1;
    CHECK(step(&f, 1) == CONVO3F_ERR_HOST);
    f.fail_playing = 0; f.fail_keys = 1;
    CHECK(step(&f, 1) == CONVO3F_ERR_HOST);
    fx_free(&f);
}
static void t_default_transition_and_completion(void)
{
    Spec sp; Fx f;
    spec_default(&sp); sp.default_w1 = 321; fx_build(&f, &sp);
    run_to_phase2(&f);
    f.w.engine_583204 = 2;
    CHECK(step(&f, 2) == CONVO3F_OK);
    CHECK(f.w.xfer_5bb57b == 1052 && f.w.xfer_5bb599 == 321 && f.w.xfer_5bb595 == 0 && f.w.xfer_5c39ff == 1);
    CHECK(f.w.xfer_5bb59b == 0 && f.w.xfer_5bb59f == 0 && f.w.xfer_5bb5a3 == 1);
    CHECK(f.w.mode_583999 == 4 && f.r.scene_change == 1 && f.r.finished == 1 && f.r.object_released == 1);
    CHECK(f.r.phase_after == 0u && f.m.row == -1);
    CHECK(f.w.flag_5c39e9 == 0 && f.w.flag_5c39ed == 0 && f.w.start_5bb1ca == 0 && f.w.engine_583204 == 0);
    CHECK_LOG(&f, "rel(5) rel(6) ui0 restore");
    CHECK(f.m.textbox_slot[0] == -1 && f.m.textbox_slot[1] == -1);
    fx_free(&f);
}
static void t_no_transition(void)
{
    Spec sp; Fx f;
    spec_default(&sp); sp.default_enable = 0; fx_build(&f, &sp);
    run_to_phase2(&f);
    CHECK(step(&f, 2) == CONVO3F_OK);
    CHECK(f.w.mode_583999 == 3 && f.r.scene_change == 0 && f.r.finished == 1);
    CHECK(f.w.xfer_5bb57b == 0);
    fx_free(&f);
}
static void t_pop_paths(void)
{
    Spec sp; Fx f;
    spec_default(&sp); sp.default_enable = 0; fx_build(&f, &sp);
    f.arena[C3F_POP_FLAG] = 1;
    run_to_phase2(&f);
    CHECK(step(&f, 2) == CONVO3F_OK);
    CHECK(strstr(f.log, "pop") != NULL && f.w.xfer_5bb57b == 77 && f.r.scene_change == 1);
    fx_free(&f);
    /* default enabled wins over the pop flag */
    spec_default(&sp); fx_build(&f, &sp);
    f.arena[C3F_POP_FLAG] = 1;
    run_to_phase2(&f);
    CHECK(step(&f, 2) == CONVO3F_OK && strstr(f.log, "pop") == NULL && f.w.xfer_5bb57b == 1052);
    fx_free(&f);
    /* the exit flag overrides everything */
    spec_default(&sp); fx_build(&f, &sp);
    run_to_phase2(&f);
    f.w.exit_58322b = 1;
    CHECK(step(&f, 2) == CONVO3F_OK && strstr(f.log, "pop") != NULL && f.w.xfer_5bb57b == 77);
    fx_free(&f);
    /* missing pop provider: unsupported before any effect */
    spec_default(&sp); fx_build(&f, &sp);
    run_to_phase2(&f);
    f.w.exit_58322b = 1; f.host.scene_stack_pop = NULL;
    {
        Convo3fWorld before = f.w; Convo3fManager mb = f.m;
        CHECK(step(&f, 2) == CONVO3F_ERR_UNSUPPORTED && f.log[0] == 0);
        CHECK(memcmp(&before, &f.w, sizeof before) == 0 && memcmp(&mb, &f.m, sizeof mb) == 0);
    }
    f.host.scene_stack_pop = cb_pop; f.pop_fail = 1;
    CHECK(step(&f, 2) == CONVO3F_ERR_HOST);
    fx_free(&f);
}
static void t_secondary_flags(void)
{
    Spec sp; Fx f;
    spec_default(&sp);
    sp.ns = 5;
    sp.s[0].kind = 1; sp.s[0].id = 7; sp.s[0].value = 9;                 /* event 7 := 9 */
    sp.s[1].kind = 2; sp.s[1].id = 41; sp.s[1].value = 1;                /* inventory add(41,1) */
    sp.s[2].kind = 2; sp.s[2].id = 42; sp.s[2].value = 0;                /* inventory remove(42) */
    sp.s[3].n = 1; sp.s[3].c[0] = (Cond){1, 3, 5, 0};                    /* false: event 3 != 5 */
    sp.s[3].kind = 1; sp.s[3].id = 8; sp.s[3].value = 1;
    sp.s[4].n = 1; sp.s[4].c[0] = (Cond){2, 4, 6, 0};                    /* true: presence 4 == 6 */
    sp.s[4].kind = 1; sp.s[4].id = 9; sp.s[4].value = 2;
    fx_build(&f, &sp);
    f.presence[4] = 6;
    run_to_phase2(&f);
    CHECK(step(&f, 2) == CONVO3F_OK);
    CHECK(f.events[7] == 9 && f.events[8] == 0 && f.events[9] == 2);
    CHECK(strstr(f.log, "add(41,1) rm(42)") != NULL);
    fx_free(&f);
    /* missing inventory provider and out-of-range event index: nothing is changed */
    fx_build(&f, &sp);
    f.presence[4] = 6;
    run_to_phase2(&f);
    f.host.inventory_remove = NULL;
    {
        Convo3fWorld before = f.w;
        CHECK(step(&f, 2) == CONVO3F_ERR_UNSUPPORTED && f.log[0] == 0 && memcmp(&before, &f.w, sizeof before) == 0);
    }
    f.host.inventory_remove = cb_rm; f.w.event_count = 8;
    CHECK(step(&f, 2) == CONVO3F_ERR_BOUNDS && f.log[0] == 0 && f.events[7] == 0);
    fx_free(&f);
}
static void t_condition_chain(void)
{
    /* 0x420737: link byte 1 ties a condition to its neighbours (fix point over both directions). */
    Convo3fWorld w; int32_t ev[16] = {0}; uint8_t flags[8]; int result = -1;
    Cond a[3];
    uint8_t raw[15];
    int i;
    memset(&w, 0, sizeof w); w.events = ev; w.event_count = 16u;
    /* three plain conditions: all must hold */
    a[0] = (Cond){1, 0, 1, 0}; a[1] = (Cond){1, 1, 1, 0}; a[2] = (Cond){1, 2, 1, 0};
#define PACK() for (i = 0; i < 3; ++i) { raw[i*5] = a[i].kind; raw[i*5+1] = (uint8_t)a[i].index; raw[i*5+2] = 0; raw[i*5+3] = a[i].value; raw[i*5+4] = a[i].link; }
    PACK();
    ev[0] = ev[1] = 1; ev[2] = 0;
    CHECK(convo3f_condition_tree(raw, 3, &w, flags, &result, NULL) == 0 && result == 0);
    ev[2] = 1;
    CHECK(convo3f_condition_tree(raw, 3, &w, flags, &result, NULL) == 0 && result == 1);
    /* linking 0 and 1: condition 1 false but 0 true -> 1 becomes true (OR within the pair) */
    a[0].link = 1; PACK();
    ev[0] = 1; ev[1] = 0; ev[2] = 1;
    CHECK(convo3f_condition_tree(raw, 3, &w, flags, &result, NULL) == 0 && result == 1);
    CHECK(flags[0] == 1 && flags[1] == 1 && flags[2] == 1);
    /* the other direction: 1 true, 0 false */
    ev[0] = 0; ev[1] = 1;
    CHECK(convo3f_condition_tree(raw, 3, &w, flags, &result, NULL) == 0 && result == 1);
    /* both false in the linked pair: still false */
    ev[1] = 0;
    CHECK(convo3f_condition_tree(raw, 3, &w, flags, &result, NULL) == 0 && result == 0);
    /* no link: a false middle condition is never rescued */
    a[0].link = 0; PACK(); ev[0] = 1; ev[1] = 0;
    CHECK(convo3f_condition_tree(raw, 3, &w, flags, &result, NULL) == 0 && result == 0);
    /* a chain of links 1,1,0: one true condition spreads both ways through the whole chain */
    a[0] = (Cond){1, 0, 1, 1}; a[1] = (Cond){1, 1, 1, 1}; a[2] = (Cond){1, 2, 1, 0}; PACK();
    ev[0] = 1; ev[1] = 0; ev[2] = 0;
    CHECK(convo3f_condition_tree(raw, 3, &w, flags, &result, NULL) == 0 && result == 1);
    ev[0] = 0; ev[2] = 1;
    CHECK(convo3f_condition_tree(raw, 3, &w, flags, &result, NULL) == 0 && result == 1);
    ev[2] = 0;
    CHECK(convo3f_condition_tree(raw, 3, &w, flags, &result, NULL) == 0 && result == 0);
    /* count 0 and unknown kinds */
    CHECK(convo3f_condition_tree(raw, 0, &w, flags, &result, NULL) == 0 && result == 1);
    a[0] = (Cond){3, 0, 0, 0}; PACK();
    CHECK(convo3f_condition_tree(raw, 1, &w, flags, &result, NULL) == 0 && result == 0);
    /* index outside the event array */
    a[0] = (Cond){1, 99, 0, 0}; PACK();
    CHECK(convo3f_condition_tree(raw, 1, &w, flags, &result, NULL) == CONVO3F_ERR_BOUNDS);
#undef PACK
}

/* ---- gates of unsupported tiers, hooks and captions ---- */
static void t_tier_c_unsupported(void)
{
    Spec sp; Fx f;
    spec_default(&sp); sp.hook_a = 3; fx_build(&f, &sp);
    {
        Convo3fWorld before = f.w; Convo3fManager mb = f.m;
        CHECK(step(&f, 0) == CONVO3F_ERR_UNSUPPORTED);
        CHECK(strstr(f.why, "hook builder") != NULL && f.log[0] == 0);
        CHECK(memcmp(&before, &f.w, sizeof before) == 0 && memcmp(&mb, &f.m, sizeof mb) == 0);
    }
    fx_free(&f);
    spec_default(&sp); sp.hook_b = 0; fx_build(&f, &sp);
    CHECK(step(&f, 0) == CONVO3F_ERR_UNSUPPORTED && strstr(f.why, "hook builder") != NULL);
    fx_free(&f);
}
static void t_missing_sound_backend(void)
{
    Spec sp; Fx f;
    spec_default(&sp); fx_build(&f, &sp);
    f.host.sound = NULL;
    CHECK(step(&f, 0) == CONVO3F_ERR_UNSUPPORTED && f.w.flag_5c39e9 == 0);
    f.host.sound = &f.snd; f.snd.play_sound = NULL;
    CHECK(step(&f, 0) == CONVO3F_ERR_UNSUPPORTED && f.w.flag_5c39e9 == 0);
    fx_free(&f);
}
static void t_captions(void)
{
    Spec sp; Fx f;
    spec_default(&sp); fx_build(&f, &sp);
    f.w.captions_5bb202 = 1; f.host.layout_text_box = NULL;
    {
        Convo3fWorld before = f.w;
        CHECK(step(&f, 0) == CONVO3F_ERR_UNSUPPORTED && strstr(f.why, "captions") != NULL);
        CHECK(memcmp(&before, &f.w, sizeof before) == 0 && f.log[0] == 0);
    }
    f.host.layout_text_box = cb_layout;
    CHECK(step(&f, 0) == CONVO3F_OK);
    CHECK(strstr(f.log, "acq(H,6) layout(0,7) load(") != NULL); /* caption "caption" is 7 bytes */
    CHECK(f.w.ui_5b15c8 == 0); /* the no-caption fast path was not taken */
    fx_free(&f);
}
static void t_bounds_and_ownership(void)
{
    Spec sp; Fx f;
    spec_default(&sp); fx_build(&f, &sp);
    CHECK(step(&f, 0) == CONVO3F_OK);
    CHECK(convo3f_step(&f.m, &f.obj, 4, 1u, &f.w, &f.host, &f.r, &f.why) == CONVO3F_ERR_BOUNDS);
    CHECK(convo3f_step(&f.m, &f.obj, 3, 7u, &f.w, &f.host, &f.r, &f.why) == CONVO3F_OK && f.r.ran == 0);
    f.obj.arena_bytes = 100u;
    CHECK(convo3f_step(&f.m, &f.obj, 3, 1u, &f.w, &f.host, &f.r, &f.why) == CONVO3F_ERR_BOUNDS);
    CHECK(convo3f_step(NULL, &f.obj, 3, 1u, &f.w, &f.host, &f.r, &f.why) == CONVO3F_ERR_ARGUMENT);
    fx_free(&f);
    /* a sound channel outside the 32 channel states is refused before any effect */
    spec_default(&sp); fx_build(&f, &sp);
    f.arena[C3F_SND_CHANNEL] = 40;
    CHECK(step(&f, 0) == CONVO3F_ERR_BOUNDS && f.log[0] == 0 && f.w.flag_5c39e9 == 0);
    fx_free(&f);
    /* an unterminated sound name */
    spec_default(&sp); fx_build(&f, &sp);
    memset(f.arena, 'A', 33u);
    CHECK(step(&f, 0) == CONVO3F_ERR_BOUNDS && f.log[0] == 0);
    fx_free(&f);
}

/* ---- tier B ---- */
static Spec tierb_spec(void)
{
    Spec sp;
    spec_default(&sp);
    sp.np = 3;
    sp.p[0].text = "Ask about the key"; sp.p[0].scene = 500; sp.p[0].sound = "ASK_ONE";
    sp.p[1].text = "Say goodbye";       sp.p[1].scene = 9999; sp.p[1].sound = "NO SOUND";
    sp.p[2].text = "Threaten him";      sp.p[2].scene = 700;  sp.p[2].sound = "";
    return sp;
}
static void t_list_conditions(void)
{
    Spec sp = tierb_spec(); Fx f;
    sp.p[0].n = 1; sp.p[0].c[0] = (Cond){1, 5, 1, 0};      /* needs event 5 == 1 */
    sp.p[2].n = 2; sp.p[2].c[0] = (Cond){1, 6, 1, 1};      /* linked pair: event 6 or presence 7 */
    sp.p[2].c[1] = (Cond){2, 7, 1, 0};
    fx_build(&f, &sp);
    CHECK(step(&f, 0) == CONVO3F_OK);
    CHECK(f.m.response_count == 1 && convo3f_text_equal(f.m.responses[0].text, (const uint8_t *)"say goodbye"));
    CHECK(strstr(f.log, "layout(1,7)") != NULL);
    fx_free(&f);
    fx_build(&f, &sp);
    f.events[5] = 1; f.presence[7] = 1;
    CHECK(step(&f, 0) == CONVO3F_OK);
    CHECK(f.m.response_count == 3);
    CHECK(f.m.responses[0].scene == 500 && f.m.responses[1].scene == 9999 && f.m.responses[2].scene == 700);
    CHECK(strcmp((char *)f.m.responses[0].name, "ASK_ONE") == 0);
    fx_free(&f);
}
/* Entry i of the primary table inside the arena (kinds/events are patched there: the
 * A-3F.1 constructor always writes kind 0 and event index -1, other types share this model). */
static uint8_t *pentry(Fx *f, int i)
{
    uint32_t handle = (uint32_t)f->arena[C3F_PRIMARY_TABLE] | ((uint32_t)f->arena[C3F_PRIMARY_TABLE + 1] << 8) |
                      ((uint32_t)f->arena[C3F_PRIMARY_TABLE + 2] << 16) | ((uint32_t)f->arena[C3F_PRIMARY_TABLE + 3] << 24);
    return f->arena + (handle - 1u) + (size_t)i * 0x1d1u;
}
static int resp_is(const Fx *f, int i, const char *text)
{
    return convo3f_text_equal(f->m.responses[i].text, (const uint8_t *)text);
}

static void t_list_kinds_and_duplicates(void)
{
    /* replace_response (0x41fd08, kind 1) and remove_response (0x42028e, kind 2) of src/action_family_3f_runtime.c. */
    Spec sp = tierb_spec(); Fx f;
    sp.np = 6;
    sp.p[3] = sp.p[0]; sp.p[3].text = "ASK ABOUT THE KEY";   /* kind 0, duplicate (case-insensitive): not added */
    sp.p[4] = sp.p[1]; sp.p[4].text = "Say Goodbye";         /* kind 1: removes the old entry, appends */
    sp.p[5] = sp.p[2]; sp.p[5].text = "Nothing";             /* kind 2 of a missing text: no effect */
    fx_build(&f, &sp);
    pentry(&f, 4)[C3F_PE_KIND] = 1;
    pentry(&f, 5)[C3F_PE_KIND] = 2;
    CHECK(step(&f, 0) == CONVO3F_OK);
    CHECK(f.m.response_count == 3);
    CHECK(resp_is(&f, 0, "ask about the key") && resp_is(&f, 1, "threaten him") && resp_is(&f, 2, "say goodbye"));
    CHECK(f.m.responses[2].scene == 9999 && f.m.responses[1].scene == 700);
    fx_free(&f);
    /* kind 2 removes an existing text; kind 1 of a missing text just appends */
    sp = tierb_spec(); sp.np = 5;
    sp.p[3] = sp.p[1]; sp.p[3].text = "SAY GOODBYE";          /* kind 2: removes entry 1 */
    sp.p[4] = sp.p[2]; sp.p[4].text = "Brand new";             /* kind 1, not found: appended */
    fx_build(&f, &sp);
    pentry(&f, 3)[C3F_PE_KIND] = 2;
    pentry(&f, 4)[C3F_PE_KIND] = 1;
    CHECK(step(&f, 0) == CONVO3F_OK);
    CHECK(f.m.response_count == 3);
    CHECK(resp_is(&f, 0, "ask about the key") && resp_is(&f, 1, "threaten him") && resp_is(&f, 2, "brand new"));
    fx_free(&f);
}
static void t_list_overflow_and_retention(void)
{
    Spec sp; Fx f; int i;
    static char texts[40][24];
    spec_default(&sp);
    sp.np = 35;
    for (i = 0; i < 35; ++i) {
        snprintf(texts[i], sizeof texts[i], "line %d", i);
        sp.p[i].text = texts[i]; sp.p[i].scene = (int16_t)(100 + i); sp.p[i].sound = "";
    }
    fx_build(&f, &sp);
    CHECK(step(&f, 0) == CONVO3F_OK);
    CHECK(f.m.response_count == 30); /* entries 30..34 are dropped (0x41fa11: count + 1 < 0x1f) */
    CHECK(resp_is(&f, 29, "line 29") && f.m.responses[29].scene == 129);
    /* +0x778 != 0: the list is not reset, so a second conversation keeps it (and dedups against it) */
    fx_free(&f);
    sp = tierb_spec(); fx_build(&f, &sp);
    f.arena[C3F_FLAG_778] = 1;
    CHECK(step(&f, 0) == CONVO3F_OK && f.m.response_count == 3);
    f.m.row = -1; f.w.flag_5c39e9 = f.w.flag_5c39ed = 0; f.m.textbox_slot[0] = f.m.textbox_slot[1] = -1;
    CHECK(step(&f, 0) == CONVO3F_OK && f.m.response_count == 3); /* all duplicates */
    f.arena[C3F_FLAG_778] = 0; f.m.row = -1; f.w.flag_5c39e9 = f.w.flag_5c39ed = 0;
    CHECK(step(&f, 0) == CONVO3F_OK && f.m.response_count == 3 && resp_is(&f, 0, "ask about the key"));
    fx_free(&f);
}
static void t_tier_b_needs_ui(void)
{
    Spec sp = tierb_spec(); Fx f;
    fx_build(&f, &sp);
    f.host.layout_text_box = NULL;
    {
        Convo3fWorld before = f.w;
        CHECK(step(&f, 0) == CONVO3F_ERR_UNSUPPORTED && strstr(f.why, "tier B") != NULL);
        CHECK(memcmp(&before, &f.w, sizeof before) == 0 && f.log[0] == 0);
    }
    f.host.layout_text_box = cb_layout; f.host.acquire_surface = NULL;
    CHECK(step(&f, 0) == CONVO3F_ERR_UNSUPPORTED && f.log[0] == 0);
    fx_free(&f);
}
static void tierb_to_selection(Fx *f, int pick)
{
    CHECK(step(f, 0) == CONVO3F_OK);
    f->playing_for[12] = 1000;
    CHECK(step(f, 1) == CONVO3F_OK && f->m.sub_state == 4u); /* still playing, no pick */
    f->playing_for[12] = 0;
    CHECK(step(f, 1) == CONVO3F_OK && f->m.sub_state == 4u); /* ended: waits for a response */
    f->w.chosen_5839b1[pick] = 1;
    CHECK(step(f, 1) == CONVO3F_OK && f->m.sub_state == 5u && f->w.selected_570374 == pick);
}
static void t_tier_b_selection_and_response_sound(void)
{
    Spec sp = tierb_spec(); Fx f;
    fx_build(&f, &sp);
    f.resp_sound[0] = "ASK_ONE"; f.resp_sound[1] = "NO SOUND"; f.resp_sound[2] = "";
    tierb_to_selection(&f, 0);
    /* sub-state 5: unload the first sound, load the response sound into the second descriptor */
    CHECK(step(&f, 1) == CONVO3F_OK);
    CHECK(strstr(f.log, "unload(12) load(ASK_ONE,13) play(13)") != NULL);
    CHECK(f.m.sub_state == 6u && f.r.phase_after == 1u);
    CHECK(strcmp((char *)f.arena + C3F_SOUND2, "ASK_ONE") == 0); /* "dummy" was replaced in the image */
    f.playing_for[13] = 2;
    CHECK(step(&f, 1) == CONVO3F_OK && f.m.sub_state == 6u);
    CHECK(step(&f, 1) == CONVO3F_OK && f.m.sub_state == 6u);
    CHECK(step(&f, 1) == CONVO3F_OK && f.r.phase_after == 2u);
    CHECK(strstr(f.log, "unload(13)") != NULL);
    /* chosen response 0 has scene 500: its words become the transition */
    CHECK(step(&f, 2) == CONVO3F_OK);
    CHECK(f.w.xfer_5bb57b == 500 && f.w.mode_583999 == 4 && f.r.scene_change == 1);
    CHECK(f.w.xfer_5bb599 == 0 && f.w.xfer_5c39ff == 1 && f.w.xfer_5bb5a3 == 1);
    fx_free(&f);
    /* "NO SOUND" and an empty name go straight to the finish */
    fx_build(&f, &sp);
    f.resp_sound[1] = "NO SOUND";
    tierb_to_selection(&f, 1);
    CHECK(step(&f, 1) == CONVO3F_OK && f.r.phase_after == 2u && strstr(f.log, "play(") == NULL);
    /* scene 9999: falls back to the default transition */
    CHECK(step(&f, 2) == CONVO3F_OK && f.w.xfer_5bb57b == 1052);
    fx_free(&f);
    fx_build(&f, &sp);
    tierb_to_selection(&f, 2);
    CHECK(step(&f, 1) == CONVO3F_OK && f.r.phase_after == 2u && strstr(f.log, "play(") == NULL);
    CHECK(step(&f, 2) == CONVO3F_OK && f.w.xfer_5bb57b == 700);
    fx_free(&f);
}
static void t_tier_b_event_write_and_exit(void)
{
    Spec sp = tierb_spec(); Fx f;
    fx_build(&f, &sp);
    f.resp_sound[0] = "";
    pentry(&f, 0)[C3F_PE_EVENT_INDEX] = 12; pentry(&f, 0)[C3F_PE_EVENT_INDEX + 1] = 0;
    pentry(&f, 0)[C3F_PE_EVENT_VALUE] = 4;
    tierb_to_selection(&f, 0);
    CHECK(step(&f, 1) == CONVO3F_OK && f.r.phase_after == 2u);
    f.w.exit_58322b = 1;
    CHECK(step(&f, 2) == CONVO3F_OK);
    CHECK(f.events[12] == 4);                       /* written even though the exit flag pops */
    CHECK(strstr(f.log, "pop") != NULL && f.w.xfer_5bb57b == 77);
    fx_free(&f);
    /* event index outside the modelled array: refused with nothing changed */
    fx_build(&f, &sp);
    f.resp_sound[0] = "";
    pentry(&f, 0)[C3F_PE_EVENT_INDEX] = 200; pentry(&f, 0)[C3F_PE_EVENT_INDEX + 1] = 0;
    tierb_to_selection(&f, 0);
    CHECK(step(&f, 1) == CONVO3F_OK && f.r.phase_after == 2u);
    CHECK(step(&f, 2) == CONVO3F_ERR_BOUNDS && f.log[0] == 0 && f.w.flag_5c39e9 == 1);
    fx_free(&f);
}
static void t_tier_b_refusals(void)
{
    Spec sp = tierb_spec(); Fx f;
    fx_build(&f, &sp);
    f.resp_sound[0] = "THIS_NAME_IS_MUCH_TOO_LONG_FOR_THE_FIELD";
    tierb_to_selection(&f, 0);
    CHECK(step(&f, 1) == CONVO3F_ERR_BOUNDS && f.log[0] == 0 && f.m.sub_state == 5u); /* would overrun +0x768 */
    fx_free(&f);
    /* a condition count above the original scratch (75) is refused before any effect */
    sp = tierb_spec();
    sp.p[0].n = 8;
    fx_build(&f, &sp);
    pentry(&f, 0)[0] = 90;
    CHECK(step(&f, 0) == CONVO3F_ERR_BOUNDS && f.w.flag_5c39e9 == 0 && f.log[0] == 0);
    fx_free(&f);
    /* a condition handle outside the arena */
    fx_build(&f, &sp);
    pentry(&f, 0)[2] = 0xff; pentry(&f, 0)[3] = 0xff; pentry(&f, 0)[4] = 0xff;
    CHECK(step(&f, 0) == CONVO3F_ERR_BOUNDS && f.log[0] == 0);
    fx_free(&f);
    /* hotspot refresh needed at phase 1 */
    spec_default(&sp); fx_build(&f, &sp);
    CHECK(step(&f, 0) == CONVO3F_OK);
    f.w.ui_5b15da = 1; f.host.refresh_hotspot_surface = NULL;
    CHECK(step(&f, 1) == CONVO3F_ERR_UNSUPPORTED && f.w.ui_5b15da == 1 && f.log[0] == 0);
    f.host.refresh_hotspot_surface = cb_refresh;
    CHECK(step(&f, 1) == CONVO3F_OK && f.w.ui_5b15da == 0 && strncmp(f.log, "refresh(5) keys", 15) == 0);
    fx_free(&f);
}
static void t_row_release_and_rerun(void)
{
    Spec sp; Fx f;
    spec_default(&sp); fx_build(&f, &sp);
    run_to_phase2(&f);
    CHECK(step(&f, 2) == CONVO3F_OK && f.r.object_released == 1);
    /* the manager is free again: a second conversation of the same image may start */
    CHECK(f.m.row == -1);
    f.w.mode_583999 = 3; /* the finish stored mode 4 for the transition */
    CHECK(step(&f, 0) == CONVO3F_OK && f.r.started == 1);
    fx_free(&f);
}

/* Bounded malformed input: random byte flips in the object image and its tables (counts, handles,
 * kinds, names, channels); every visit must end in a defined status without touching memory outside
 * the arena (the sanitizer build runs this). */
static void t_malformed_arena_fuzz(void)
{
    Spec sp = tierb_spec(); Fx f; uint8_t *pristine; unsigned long seed = 12345ul; int iter, ok_runs = 0;
    sp.ns = 2;
    sp.s[0].kind = 1; sp.s[0].id = 3; sp.s[0].value = 1;
    sp.s[1].n = 1; sp.s[1].c[0] = (Cond){1, 2, 0, 0}; sp.s[1].kind = 2; sp.s[1].id = 9; sp.s[1].value = 1;
    sp.p[0].n = 2; sp.p[0].c[0] = (Cond){1, 1, 0, 1}; sp.p[0].c[1] = (Cond){2, 2, 0, 0};
    fx_build(&f, &sp);
    pristine = malloc(f.arena_bytes);
    memcpy(pristine, f.arena, f.arena_bytes);
    for (iter = 0; iter < 3000; ++iter) {
        int flips = 1 + (int)(seed % 4u), k, step_no, st;
        memcpy(f.arena, pristine, f.arena_bytes);
        for (k = 0; k < flips; ++k) {
            size_t pos;
            seed = seed * 1103515245ul + 12345ul;
            pos = (seed >> 8) % (iter % 2 == 0 ? CONVO3F_IMAGE_BYTES : f.arena_bytes);
            if ((seed >> 4) % 3u == 0u) { pos = 0x779u + (seed >> 12) % 0x30u; } /* the control block */
            seed = seed * 1103515245ul + 12345ul;
            f.arena[pos] = (uint8_t)(seed >> 16);
        }
        convo3f_manager_reset(&f.m);
        f.w.flag_5c39e9 = f.w.flag_5c39ed = 0; f.w.mode_583999 = 3; f.w.held_item = -1;
        f.w.selected_570374 = CONVO3F_NO_SELECTION; f.w.exit_58322b = 0;
        memset(f.w.chosen_5839b1, 0, sizeof f.w.chosen_5839b1);
        memset(f.events, 0, sizeof f.events); memset(f.presence, 0, sizeof f.presence);
        f.m.textbox_slot[0] = f.m.textbox_slot[1] = -1;
        st = step(&f, 0);
        CHECK(st >= CONVO3F_OK && st <= CONVO3F_ERR_HOST);
        if (st != CONVO3F_OK || f.r.started == 0) { continue; }
        for (step_no = 0; step_no < 8; ++step_no) {
            if (f.m.response_count > 0) { f.w.chosen_5839b1[(step_no + iter) % f.m.response_count] = 1; }
            st = step(&f, 1);
            CHECK(st >= CONVO3F_OK && st <= CONVO3F_ERR_HOST);
            if (st != CONVO3F_OK || f.r.phase_after == 2u) { break; }
        }
        if (st == CONVO3F_OK && f.r.phase_after == 2u) {
            st = step(&f, 2);
            CHECK(st >= CONVO3F_OK && st <= CONVO3F_ERR_HOST);
            ok_runs += st == CONVO3F_OK;
        }
    }
    CHECK(ok_runs > 100); /* the mutations are not all rejected at the first step */
    free(pristine);
    fx_free(&f);
}

typedef struct { const char *name; void (*fn)(void); } Test;
#define T(n) {#n, n}
int main(void)
{
    static const Test tests[] = {
        T(t_gate_flags), T(t_mode_not_3), T(t_phase0_effects), T(t_optional_skips),
        T(t_load_failure_advances), T(t_sound_end_flow), T(t_fast_convo), T(t_is_playing_error),
        T(t_default_transition_and_completion), T(t_no_transition), T(t_pop_paths),
        T(t_secondary_flags), T(t_condition_chain), T(t_tier_c_unsupported),
        T(t_missing_sound_backend), T(t_captions), T(t_bounds_and_ownership),
        T(t_list_conditions), T(t_list_kinds_and_duplicates), T(t_list_overflow_and_retention),
        T(t_tier_b_needs_ui), T(t_tier_b_selection_and_response_sound),
        T(t_tier_b_event_write_and_exit), T(t_tier_b_refusals), T(t_row_release_and_rerun),
        T(t_malformed_arena_fuzz)
    };
    size_t i;
    int failures = 0;
    for (i = 0; i < sizeof(tests) / sizeof(tests[0]); ++i) {
        g_name = tests[i].name;
        g_failed = 0;
        tests[i].fn();
        if (g_failed) {
            printf("FAIL %s: %s\n", g_name, g_msg);
            ++failures;
        } else {
            printf("PASS %s\n", g_name);
        }
    }
    return failures;
}
