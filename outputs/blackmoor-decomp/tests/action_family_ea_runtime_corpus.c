/* RT-45 corpus check: runs every raw 0xea row of the decoded scene resources given on the command line through the
 * production parser, the session binding and the kernel with a scripted host. Pass 0 solves the puzzle by dragging
 * every piece onto its target (pointer moves, clicks, phase 1 visits with advancing ticks), clicks the animation/exit
 * area when the puzzle asks for it and runs the finish; pass 1 takes the exit button instead. Output is derived counts
 * only ("ROW ..." diagnostics on failure and a final "SUMMARY ..." line); resource bytes stay in work/. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_resource.h"
#include "session_bindings_aea.h"

typedef struct {
    int loads, creates, releases, plays, scene_changes, flag_stores, captions;
    uint32_t now;
    uint32_t next, seed;
    int16_t dw[1024], dh[1024];
} Ctx;

static int view(void *c, EaView *v)
{
    (void)c;
    v->origin_x = 0;
    v->origin_y = 0;
    v->clip[0] = 0;
    v->clip[1] = 0;
    v->clip[2] = 639;
    v->clip[3] = 479;
    return 0;
}
static int alloc_slot(void *c, int16_t *s) { (void)c; *s = 0x18; return 0; }
static int register_slot(void *c, int16_t s, const char *label)
{
    (void)c; (void)s;
    return strcmp(label, "ONEBUILD_PUZZLE_OVERLAYS") != 0;
}
static int release_slot(void *c, int16_t s) { (void)c; (void)s; return 0; }
static int mark_dirty(void *c, int16_t s) { (void)c; (void)s; return 0; }
static int load_surface(void *c, const char *n, const char *tag, uint32_t *s)
{
    (void)tag;
    ((Ctx *)c)->loads++;
    *s = n[0] != '\0' ? 5u : 0u;
    return 0;
}
static int create_surface(void *c, int16_t w, int16_t h, const char *tag, uint32_t *s)
{
    Ctx *x = (Ctx *)c;
    (void)tag;
    *s = 100u + x->next++;
    x->dw[*s & 1023u] = w;
    x->dh[*s & 1023u] = h;
    x->creates++;
    return 0;
}
static int blit(void *c, uint32_t a, uint32_t b, const int32_t sr[4], const int32_t dr[4])
{
    (void)c; (void)a; (void)b; (void)sr; (void)dr;
    return 0;
}
static int copy_surface(void *c, uint32_t d, uint32_t s)
{
    Ctx *x = (Ctx *)c;
    x->dw[d & 1023u] = x->dw[s & 1023u];
    x->dh[d & 1023u] = x->dh[s & 1023u];
    return 0;
}
static int rotate_surface(void *c, uint32_t s, int16_t *w, int16_t *h)
{
    Ctx *x = (Ctx *)c;
    const int16_t t = x->dw[s & 1023u];
    x->dw[s & 1023u] = x->dh[s & 1023u];
    x->dh[s & 1023u] = t;
    *w = x->dw[s & 1023u];
    *h = x->dh[s & 1023u];
    return 0;
}
static int release_surface(void *c, uint32_t s) { (void)s; ((Ctx *)c)->releases++; return 0; }
static int clear_item(void *c) { (void)c; return 0; }
static int sound_prepare(void *c, uint32_t r, const uint8_t *b) { (void)c; (void)r; (void)b; return 0; }
static int sound_stop(void *c, uint32_t r, const uint8_t *b) { (void)c; (void)r; (void)b; return 0; }
static int sound_play(void *c, int16_t ch) { (void)ch; ((Ctx *)c)->plays++; return 0; }
static int sound_busy(void *c, int16_t ch, int32_t *r) { (void)c; (void)ch; *r = 0; return 0; }
static uint32_t tick(void *c) { Ctx *x = (Ctx *)c; x->now += 700u; return x->now; }
/* The alternate-sound picks re-roll until they land on a usable record, so the draw must vary. */
static int rand_value(void *c, int32_t *v)
{
    Ctx *x = (Ctx *)c;
    x->seed = x->seed * 1103515245u + 12345u;
    *v = (int32_t)((x->seed >> 16) & 0x7fff);
    return 0;
}
static int captions_enabled(void *c, int32_t *e) { (void)c; *e = 1; return 0; }
static int autotext(void *c, const char *k, const char **t) { (void)c; (void)k; *t = NULL; return 0; }
static int caption_show(void *c, const char *t) { (void)t; ((Ctx *)c)->captions++; return 0; }
static int flag_invalid(void *c, int16_t i) { (void)c; return i < 0 || i >= 4096; }
static int transition(void *c, const EaTransition *t) { (void)t; ((Ctx *)c)->scene_changes++; return 0; }
static int store_flag(void *c, int16_t i, uint32_t v) { (void)i; (void)v; ((Ctx *)c)->flag_stores++; return 0; }
static int complete(void *c, int16_t row) { (void)c; (void)row; return 0; }

enum { O_HAND = 0xa9e, O_STATE = 0xbac, O_DONE = 0xbb0, O_PW = 0xbc5, O_PH = 0xbc7, O_PLACED_N = 0xc25, O_PIECES = 0x28 };

static int32_t s32(const uint8_t *b, size_t o)
{
    return (int32_t)((uint32_t)b[o] | ((uint32_t)b[o + 1] << 8) | ((uint32_t)b[o + 2] << 16) | ((uint32_t)b[o + 3] << 24));
}
static int16_t s16(const uint8_t *b, size_t o) { return (int16_t)(b[o] | (b[o + 1] << 8)); }

typedef struct { SessionAeaBinding *b; const SceneActionInfo *info; size_t row; uint32_t phase; } Run;

static int visit(Run *r, SceneActionHandlerResult *out, int *completed)
{
    SceneActionRuntimeState st;
    memset(&st, 0, sizeof st);
    memset(out, 0, sizeof *out);
    st.phase = r->phase;
    if (session_aea_handler(r->b, r->row, r->info, &st, out) != SCENE_ACTION_HANDLER_OK) return 0;
    r->phase = out->phase;
    *completed = out->disposition == SCENE_ACTION_HANDLER_COMPLETED;
    return 1;
}

static int move_to(Run *r, int x, int y, EaPointerResult *pr)
{
    const int32_t rect[4] = {x - 8, y - 8, x + 8, y + 8};
    return session_aea_pointer_move(r->b, (int16_t)x, (int16_t)y, rect, pr) == EA_OK;
}

/* Visit until the sound/wait states are idle again (state 0) or the row left phase 1. */
static int settle(Run *r, SceneActionHandlerResult *out, int *completed)
{
    for (int v = 0; v < 60; ++v) {
        if (r->phase != 1u) return 1;
        if (s32(session_aea_object(r->b)->b, O_STATE) == 0) return 1;
        if (!visit(r, out, completed)) return 0;
        if (*completed) return 1;
    }
    return 0;
}

int main(int argc, char **argv)
{
    static Ctx ctx;
    SessionAeaHost host;
    unsigned long rows = 0, solved = 0, exited = 0, error = 0, scenes = 0, pieces = 0;
    memset(&host, 0, sizeof host);
    host.kernel.context = &ctx;
    host.kernel.view = view;
    host.kernel.alloc_slot = alloc_slot;
    host.kernel.register_slot = register_slot;
    host.kernel.release_slot = release_slot;
    host.kernel.mark_dirty = mark_dirty;
    host.kernel.load_surface = load_surface;
    host.kernel.create_surface = create_surface;
    host.kernel.blit = blit;
    host.kernel.copy_surface = copy_surface;
    host.kernel.rotate_surface = rotate_surface;
    host.kernel.release_surface = release_surface;
    host.kernel.clear_pending_item = clear_item;
    host.kernel.sound_prepare = sound_prepare;
    host.kernel.sound_stop = sound_stop;
    host.kernel.sound_play = sound_play;
    host.kernel.sound_busy = sound_busy;
    host.kernel.tick = tick;
    host.kernel.rand_value = rand_value;
    host.kernel.captions_enabled = captions_enabled;
    host.kernel.autotext_lookup = autotext;
    host.kernel.caption_show = caption_show;
    host.kernel.event_flag_invalid = flag_invalid;
    host.kernel.transition = transition;
    host.kernel.store_event_flag = store_flag;
    host.kernel.complete = complete;
    for (int a = 1; a < argc; ++a) {
        FILE *f = fopen(argv[a], "rb");
        long n;
        unsigned char *bytes;
        char err[128] = {0};
        SceneResource *scene;
        size_t count, earows = 0;
        if (f == NULL) continue;
        fseek(f, 0, SEEK_END);
        n = ftell(f);
        fseek(f, 0, SEEK_SET);
        bytes = (unsigned char *)malloc((size_t)n);
        if (bytes == NULL || fread(bytes, 1, (size_t)n, f) != (size_t)n) { fclose(f); free(bytes); continue; }
        fclose(f);
        scene = scene_resource_open_memory(bytes, (size_t)n, err, sizeof err);
        if (scene == NULL) { free(bytes); continue; }
        count = scene_resource_action_count(scene);
        for (size_t i = 0; i < count; ++i) {
            SceneActionInfo info;
            if (scene_resource_action_at(scene, i, &info) == 0 && info.type == SESSION_AEA_TYPE) ++earows;
        }
        if (earows == 0) { scene_resource_close(scene); free(bytes); continue; }
        ++scenes;
        for (int pass = 0; pass < 2; ++pass) {
            SessionAeaBinding *binding = session_aea_create(&host);
            if (binding == NULL || session_aea_begin_scene(binding, scene) != EA_OK) {
                printf("SCENE_FAIL %s %s\n", argv[a], binding ? session_aea_failure(binding) : "create");
                if (pass == 0) { error += earows; rows += earows; }
                session_aea_destroy(binding);
                break;
            }
            for (size_t i = 0; i < count; ++i) {
                SceneActionInfo info;
                SceneActionHandlerResult out;
                Run run;
                int good = 1, completed = 0;
                const char *step = "init";
                if (scene_resource_action_at(scene, i, &info) != 0 || info.type != SESSION_AEA_TYPE) continue;
                if (pass == 0) ++rows;
                run.b = binding;
                run.info = &info;
                run.row = i;
                run.phase = 0u;
                good = visit(&run, &out, &completed) && run.phase == 1u;
                if (good && pass == 0) {
                    const uint8_t *body = info.typed_body;
                    const int16_t np = s16(body, 0x21);
                    const EaObject *obj = session_aea_object(binding);
                    int guard = 0;
                    step = "solve";
                    while (good && guard++ < 400 && !completed) {
                        int placed = 0, next = -1;
                        for (int k = 0; k < np; ++k)
                            if (obj->b[O_PIECES + k * 0x85 + 0x23] != 0) ++placed;
                        if (s32(obj->b, O_STATE) != 0) {
                            good = visit(&run, &out, &completed);
                            continue;
                        }
                        if (placed == np || (obj->b[O_DONE] != 0)) {
                            /* everything is down: ask for the check through the animation/exit area, else visit */
                            EaPointerResult pr;
                            const int32_t *unused = NULL;
                            (void)unused;
                            if (s32(body, 0x5f8 + 12) != s32(body, 0x5f8 + 4) &&
                                move_to(&run, (s32(body, 0x5f8) + s32(body, 0x5f8 + 8)) / 2, (s32(body, 0x5f8 + 4) + s32(body, 0x5f8 + 12)) / 2, &pr) &&
                                pr.candidate == EA_CANDIDATE_ANIM) {
                                uint32_t npz;
                                good = session_aea_click(binding, run.phase, pr.candidate, &npz) == EA_OK;
                                run.phase = npz;
                            }
                            good = good && visit(&run, &out, &completed);
                            continue;
                        }
                        /* choose the next piece to place: the first unplaced one (ordered puzzles name it) */
                        if (body[0x2d] != 0) next = s16(body, 0x2e + (size_t)s16(obj->b, O_PLACED_N) * 2u) - 1;
                        for (int k = 0; next < 0 && k < np; ++k)
                            if (obj->b[O_PIECES + k * 0x85 + 0x23] == 0 && s32(body, 0x7f + (size_t)k * 0x42 + 0x20 + 4) != 0) next = k;
                        if (next < 0) {
                            for (int k = 0; next < 0 && k < np; ++k)
                                if (obj->b[O_PIECES + k * 0x85 + 0x23] == 0) next = k;
                        }
                        if (next < 0 || next >= np) { good = 0; break; }
                        {
                            const size_t P = O_PIECES + (size_t)next * 0x85u;
                            const size_t BP = 0x7fu + (size_t)next * 0x42u;
                            EaPointerResult pr;
                            uint32_t npz;
                            const int cx = (s32(obj->b, P + 2) + s32(obj->b, P + 10)) / 2;
                            const int cy = (s32(obj->b, P + 6) + s32(obj->b, P + 14)) / 2;
                            int tries = 0;
                            ++pieces;
                            good = move_to(&run, cx, cy, &pr) && pr.candidate == EA_CANDIDATE_PICK;
                            good = good && session_aea_click(binding, run.phase, pr.candidate, &npz) == EA_OK;
                            if (!good) { step = "pick"; break; }
                            good = settle(&run, &out, &completed);
                            if (good && s16(obj->b, O_HAND) != next) {
                                /* a piece above it was picked: put that one back and try again from the top */
                                good = move_to(&run, 600, 460, &pr) && move_to(&run, 600, 460, &pr);
                                if (good && pr.candidate == EA_CANDIDATE_DROP_BAD)
                                    good = session_aea_click(binding, run.phase, pr.candidate, &npz) == EA_OK;
                                else
                                    good = 0;
                                if (!good) { step = "unpick"; break; }
                                (void)settle(&run, &out, &completed);
                                continue;
                            }
                            while (good && obj->b[P + 0x22] != 0 && tries++ < 4)
                                good = session_aea_rotate_key(binding, run.phase) == EA_OK;
                            {
                                const int pw = s16(obj->b, O_PW), ph = s16(obj->b, O_PH);
                                const int tx = s32(body, BP + 0x20) + pw / 2, ty = s32(body, BP + 0x20 + 4) + ph / 2;
                                good = good && move_to(&run, tx, ty, &pr) && move_to(&run, tx, ty, &pr);
                                if (!good || pr.candidate != EA_CANDIDATE_DROP_GOOD) { good = 0; step = "target"; break; }
                            }
                            good = session_aea_click(binding, run.phase, pr.candidate, &npz) == EA_OK;
                            if (good) good = settle(&run, &out, &completed);
                        }
                    }
                    good = good && completed && out.phase == 0u && !session_aea_object(binding)->b[0xba7];
                    if (good) ++solved;
                } else if (good) {
                    EaPointerResult pr;
                    uint32_t npz = 1u;
                    step = "exit";
                    good = move_to(&run, (s32(info.typed_body, 0xef7) + s32(info.typed_body, 0xef7 + 8)) / 2,
                                   (s32(info.typed_body, 0xef7 + 4) + s32(info.typed_body, 0xef7 + 12)) / 2, &pr) &&
                           pr.candidate == EA_CANDIDATE_EXIT && session_aea_click(binding, run.phase, pr.candidate, &npz) == EA_OK &&
                           npz == 2u;
                    run.phase = npz;
                    good = good && visit(&run, &out, &completed) && completed && out.phase == 0u;
                    if (good) ++exited;
                }
                if (!good) {
                    ++error;
                    printf("ROW_FAIL %s %zu pass=%d step=%s %s\n", argv[a], i, pass, step, session_aea_failure(binding));
                }
            }
            session_aea_destroy(binding);
        }
        scene_resource_close(scene);
        free(bytes);
    }
    printf("SUMMARY scenes=%lu rows=%lu solved=%lu exited=%lu error=%lu pieces=%lu loads=%d creates=%d releases=%d scene_changes=%d flag_stores=%d\n",
           scenes, rows, solved, exited, error, pieces, ctx.loads, ctx.creates, ctx.releases, ctx.scene_changes,
           ctx.flag_stores);
    return error == 0 ? 0 : 1;
}
