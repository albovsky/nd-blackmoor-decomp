/* RT-48 native side of the raw 0x20 / 0x70 / 0x80 oracle (tests/action_family_20_70_80_runtime_original_oracle.py).
 *
 * One handle owns the process cells the three arms touch (as the host stores them), the 0x57975c object fields the 0x80 method
 * reads or writes, a small row model for the 0x20 erase (loaded dword +0x59, unloaded dword +0x55, retired flag, body pointer
 * present) and the three real session bindings. a2o_visit() performs what the executor does for a true gate: it calls the
 * binding handler and derives the row's completion byte and phase from the returned disposition (scene_executor.c
 * apply_external_handler; the only disposition the three handlers may return is DIRECT_COMPLETED, anything else is reported
 * to the caller untranslated).
 *
 * Host behaviour modelled here (it is the host's, not the kernels'): the erase 0x43e96c + 0x43e8b8 over the row model, the sound
 * unload 0x4fb018 (a recorder that snapshots the world the kernel is mutating), the scene-change request. */
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "session_bindings_a20_a70_a80.h"

#define MAXROWS 96
#define LOGMAX 1024

enum {
    V_63AA10, V_55CD94, V_5BB57B, V_5BB57F, V_5C3A4F, V_5C39E3, V_583981, V_583985, V_583991, V_5BB1C4, V_583999, V_5BB1E2,
    V_583204, V_5BB22A, V_5BB599, V_5BB595, V_5C39FF, V_5BB59B, V_5BB59F, V_5BB5A3,
    V_O6BA, V_O6BC, V_O6BE, V_O6C2, V_O6C6, V_O6CA, V_O4528, V_O6B2, V_O6B4, V_O4530, V_O65D2,
    NV
};

static const char *const NAMES[NV] = {
    "63aa10", "55cd94", "5bb57b", "5bb57f", "5c3a4f", "5c39e3", "583981", "583985", "583991", "5bb1c4", "583999", "5bb1e2",
    "583204", "5bb22a", "5bb599", "5bb595", "5c39ff", "5bb59b", "5bb59f", "5bb5a3",
    "o6ba", "o6bc", "o6be", "o6c2", "o6c6", "o6ca", "o4528", "o6b2", "o6b4", "o4530", "o65d2"};

enum { FAIL_LOAD20 = 1, FAIL_ERASE = 2, FAIL_UNLOAD = 4, FAIL_TRANSITION = 8, FAIL_OBJECT = 16, FAIL_LOAD70 = 32, FAIL_LOAD80 = 64 };

typedef struct {
    int32_t loaded, unloaded, retired, has_body;
} RowModel;

typedef struct {
    int64_t v[NV];
    RowModel row[MAXROWS];
    int erased[LOGMAX], nerased;
    int freed[LOGMAX], nfreed;
    int sound_calls;
    int64_t snap70[6];
    Action70World *live70;
    int transitions;
    SceneTransitionRequest req;
    int uses_stored;
    int object_loads;
    int fail;
    SessionA20Binding *b20;
    SessionA70Binding *b70;
    SessionA80Binding *b80;
} Handle;

/* ---- raw 0x20 host ---------------------------------------------------------------------------------------------------- */
static int load20(void *ctx, Action20World *w)
{
    Handle *h = (Handle *)ctx;
    if (h->fail & FAIL_LOAD20) return 1;
    w->view_cell_63aa10 = (int32_t)h->v[V_63AA10];
    w->view_cell_55cd94 = (int32_t)h->v[V_55CD94];
    w->scene_5bb57b = (int32_t)h->v[V_5BB57B];
    w->scene_5bb57f = (int32_t)h->v[V_5BB57F];
    w->word_5c3a4f = (int16_t)h->v[V_5C3A4F];
    return 0;
}

static void store20(void *ctx, const Action20World *w)
{
    Handle *h = (Handle *)ctx;
    h->v[V_63AA10] = w->view_cell_63aa10;
    h->v[V_55CD94] = w->view_cell_55cd94;
    h->v[V_5BB57B] = w->scene_5bb57b;
    h->v[V_5BB57F] = w->scene_5bb57f;
    h->v[V_5C3A4F] = w->word_5c3a4f;
}

/* 0x43e96c: every row below the high-water count whose loaded dword is nonzero is erased (body freed, retired);
 * 0x43e8b8: the count becomes the start of the trailing run of unloaded rows, unchanged when there is none. */
static int erase20(void *ctx, uint32_t *rows_erased)
{
    Handle *h = (Handle *)ctx;
    int count = (int16_t)h->v[V_5C39E3];
    int i, start = -1, inrun = 0;
    uint32_t n = 0u;
    if (h->fail & FAIL_ERASE) return 1;
    for (i = 0; i < count && i < MAXROWS; ++i) {
        if (h->row[i].loaded != 0) {
            if (h->row[i].has_body) {
                if (h->nfreed < LOGMAX) h->freed[h->nfreed++] = i;
                h->row[i].has_body = 0;
            }
            h->row[i].loaded = 0;
            h->row[i].unloaded = 1;
            h->row[i].retired = 1;
            if (h->nerased < LOGMAX) h->erased[h->nerased++] = i;
            ++n;
        }
    }
    for (i = 0; i < count && i < MAXROWS; ++i) {
        if (h->row[i].unloaded != 0) {
            if (!inrun) {
                inrun = 1;
                start = i;
            }
        } else {
            inrun = 0;
            start = -1;
        }
    }
    if (start != -1) h->v[V_5C39E3] = start;
    *rows_erased = n;
    return 0;
}

/* ---- raw 0x70 host ---------------------------------------------------------------------------------------------------- */
static int load70(void *ctx, Action70World *w)
{
    Handle *h = (Handle *)ctx;
    if (h->fail & FAIL_LOAD70) return 1;
    w->outer_state_583981 = (int32_t)h->v[V_583981];
    w->next_state_583985 = (int32_t)h->v[V_583985];
    w->cell_583991 = (int32_t)h->v[V_583991];
    w->first_render_5bb1c4 = (int16_t)h->v[V_5BB1C4];
    w->engine_mode_583999 = (int32_t)h->v[V_583999];
    w->cell_5bb1e2 = (int32_t)h->v[V_5BB1E2];
    h->live70 = w;
    return 0;
}

static void store70(void *ctx, const Action70World *w)
{
    Handle *h = (Handle *)ctx;
    h->v[V_583981] = w->outer_state_583981;
    h->v[V_583985] = w->next_state_583985;
    h->v[V_583991] = w->cell_583991;
    h->v[V_5BB1C4] = w->first_render_5bb1c4;
    h->v[V_583999] = w->engine_mode_583999;
    h->v[V_5BB1E2] = w->cell_5bb1e2;
}

/* 0x4fb018 is a recorder; it snapshots the world the kernel is working on (the original runs it before any cell write). */
static int unload70(void *ctx)
{
    Handle *h = (Handle *)ctx;
    if (h->fail & FAIL_UNLOAD) return 1;
    ++h->sound_calls;
    if (h->live70 != NULL) {
        h->snap70[0] = h->live70->outer_state_583981;
        h->snap70[1] = h->live70->next_state_583985;
        h->snap70[2] = h->live70->cell_583991;
        h->snap70[3] = h->live70->first_render_5bb1c4;
        h->snap70[4] = h->live70->engine_mode_583999;
        h->snap70[5] = h->live70->cell_5bb1e2;
    }
    return 0;
}

/* ---- raw 0x80 host ---------------------------------------------------------------------------------------------------- */
static int load_object80(void *ctx, int uses_stored_scene, Action80Object *o)
{
    Handle *h = (Handle *)ctx;
    if (h->fail & FAIL_OBJECT) return 1;
    h->uses_stored = uses_stored_scene;
    ++h->object_loads;
    o->scene_6ba = (int16_t)h->v[V_O6BA];
    o->word_6bc = (int16_t)h->v[V_O6BC];
    o->word_6be = (int16_t)h->v[V_O6BE];
    o->dword_6c2 = (int32_t)h->v[V_O6C2];
    o->dword_6c6 = (int32_t)h->v[V_O6C6];
    o->dword_6ca = (int32_t)h->v[V_O6CA];
    o->state_4528 = (int32_t)h->v[V_O4528];
    o->word_6b2 = (int16_t)h->v[V_O6B2];
    o->dword_6b4 = (int32_t)h->v[V_O6B4];
    o->dword_4530 = (int32_t)h->v[V_O4530];
    o->dword_65d2 = (int32_t)h->v[V_O65D2];
    return 0;
}

static int load_world80(void *ctx, Action80World *w)
{
    Handle *h = (Handle *)ctx;
    if (h->fail & FAIL_LOAD80) return 1;
    w->scene_5bb57b = (int32_t)h->v[V_5BB57B];
    w->scene_5bb57f = (int32_t)h->v[V_5BB57F];
    w->word_5bb599 = (int16_t)h->v[V_5BB599];
    w->word_5bb595 = (int16_t)h->v[V_5BB595];
    w->dword_5bb59b = (int32_t)h->v[V_5BB59B];
    w->dword_5bb59f = (int32_t)h->v[V_5BB59F];
    w->dword_5bb5a3 = (int32_t)h->v[V_5BB5A3];
    w->word_5c39ff = (int16_t)h->v[V_5C39FF];
    w->engine_mode_583999 = (int32_t)h->v[V_583999];
    w->cell_583204 = (int32_t)h->v[V_583204];
    w->cell_5bb22a = (int32_t)h->v[V_5BB22A];
    return 0;
}

static void store_object80(void *ctx, const Action80Object *o)
{
    Handle *h = (Handle *)ctx;
    h->v[V_O6BA] = o->scene_6ba;
    h->v[V_O6BC] = o->word_6bc;
    h->v[V_O6BE] = o->word_6be;
    h->v[V_O6C2] = o->dword_6c2;
    h->v[V_O6C6] = o->dword_6c6;
    h->v[V_O6CA] = o->dword_6ca;
    h->v[V_O4528] = o->state_4528;
    h->v[V_O6B2] = o->word_6b2;
    h->v[V_O6B4] = o->dword_6b4;
    h->v[V_O4530] = o->dword_4530;
    h->v[V_O65D2] = o->dword_65d2;
}

static void store_world80(void *ctx, const Action80World *w)
{
    Handle *h = (Handle *)ctx;
    h->v[V_5BB57B] = w->scene_5bb57b;
    h->v[V_5BB57F] = w->scene_5bb57f;
    h->v[V_5BB599] = w->word_5bb599;
    h->v[V_5BB595] = w->word_5bb595;
    h->v[V_5BB59B] = w->dword_5bb59b;
    h->v[V_5BB59F] = w->dword_5bb59f;
    h->v[V_5BB5A3] = w->dword_5bb5a3;
    h->v[V_5C39FF] = w->word_5c39ff;
    h->v[V_583999] = w->engine_mode_583999;
    h->v[V_583204] = w->cell_583204;
    h->v[V_5BB22A] = w->cell_5bb22a;
}

static int transition80(void *ctx, const SceneTransitionRequest *request)
{
    Handle *h = (Handle *)ctx;
    if (h->fail & FAIL_TRANSITION) return 1;
    ++h->transitions;
    h->req = *request;
    return 0;
}

/* ---- handle ----------------------------------------------------------------------------------------------------------- */
Handle *a2o_new(void)
{
    SessionA20Host h20;
    SessionA70Host h70;
    SessionA80Host h80;
    Handle *h = (Handle *)calloc(1u, sizeof(*h));
    if (h == NULL) return NULL;
    memset(&h20, 0, sizeof h20);
    memset(&h70, 0, sizeof h70);
    memset(&h80, 0, sizeof h80);
    h20.context = h70.context = h80.context = h;
    h20.load_world = load20;
    h20.store_world = store20;
    h20.erase_rows = erase20;
    h70.load_world = load70;
    h70.store_world = store70;
    h70.unload_scene_sound = unload70;
    h80.load_object = load_object80;
    h80.load_world = load_world80;
    h80.store_object = store_object80;
    h80.store_world = store_world80;
    h80.transition = transition80;
    h->b20 = session_a20_create(&h20);
    h->b70 = session_a70_create(&h70);
    h->b80 = session_a80_create(&h80);
    if (h->b20 == NULL || h->b70 == NULL || h->b80 == NULL) {
        session_a20_destroy(h->b20);
        session_a70_destroy(h->b70);
        session_a80_destroy(h->b80);
        free(h);
        return NULL;
    }
    h->uses_stored = -1;
    return h;
}

void a2o_free(Handle *h)
{
    if (h != NULL) {
        session_a20_destroy(h->b20);
        session_a70_destroy(h->b70);
        session_a80_destroy(h->b80);
        free(h);
    }
}

void a2o_reset(Handle *h)
{
    memset(h->v, 0, sizeof h->v);
    memset(h->row, 0, sizeof h->row);
    h->nerased = h->nfreed = 0;
    h->sound_calls = 0;
    memset(h->snap70, 0, sizeof h->snap70);
    h->live70 = NULL;
    h->transitions = 0;
    memset(&h->req, 0, sizeof h->req);
    h->uses_stored = -1;
    h->object_loads = 0;
    h->fail = 0;
}

void a2o_clear_logs(Handle *h)
{
    h->nerased = h->nfreed = 0;
    h->sound_calls = 0;
    h->transitions = 0;
    h->uses_stored = -1;
    h->object_loads = 0;
}

int a2o_nv(void) { return NV; }
const char *a2o_name(int i) { return i >= 0 && i < NV ? NAMES[i] : NULL; }
int64_t a2o_get(const Handle *h, int i) { return h->v[i]; }
void a2o_set(Handle *h, int i, int64_t value) { h->v[i] = value; }
void a2o_set_fail(Handle *h, int mask) { h->fail = mask; }

int32_t a2o_row_get(const Handle *h, int i, int field)
{
    const RowModel *r = &h->row[i];
    return field == 0 ? r->loaded : field == 1 ? r->unloaded : field == 2 ? r->retired : r->has_body;
}

void a2o_row_set(Handle *h, int i, int field, int32_t value)
{
    RowModel *r = &h->row[i];
    if (field == 0) r->loaded = value;
    else if (field == 1) r->unloaded = value;
    else if (field == 2) r->retired = value;
    else r->has_body = value;
}

/* which: 0 erased rows, 1 rows whose body was freed (in call order since the last clear) */
int a2o_log(const Handle *h, int which, int *out, int max)
{
    const int *src = which == 0 ? h->erased : h->freed;
    int n = which == 0 ? h->nerased : h->nfreed;
    int i;
    for (i = 0; i < n && i < max; ++i) out[i] = src[i];
    return n;
}

/* 0 sound unload calls, 1 transition requests, 2 uses_stored_scene flag, 3 object loads, 4 erased count of the last 0x20 outcome,
 * 5/6/7 visits of the bindings */
int64_t a2o_info(const Handle *h, int which)
{
    const Action20Outcome *o;
    switch (which) {
    case 0: return h->sound_calls;
    case 1: return h->transitions;
    case 2: return h->uses_stored;
    case 3: return h->object_loads;
    case 4:
        o = session_a20_last_outcome(h->b20);
        return o == NULL ? -1 : (int64_t)o->rows_erased;
    case 5: return (int64_t)session_a20_visits(h->b20);
    case 6: return (int64_t)session_a70_visits(h->b70);
    case 7: return (int64_t)session_a80_visits(h->b80);
    default: return -1;
    }
}

void a2o_snap70(const Handle *h, int64_t *out)
{
    memcpy(out, h->snap70, sizeof h->snap70);
}

/* target, words 0..2, dwords 0..2 */
void a2o_req(const Handle *h, int64_t *out)
{
    out[0] = h->req.target_scene;
    out[1] = h->req.opaque_words[0];
    out[2] = h->req.opaque_words[1];
    out[3] = h->req.opaque_words[2];
    out[4] = h->req.opaque_dwords[0];
    out[5] = h->req.opaque_dwords[1];
    out[6] = h->req.opaque_dwords[2];
}

/* Returns the handler status (SCENE_ACTION_HANDLER_*), or 200 + the disposition when it is not one the executor maps here. */
int a2o_visit(Handle *h, int type, int row, int subtype, const uint8_t *raw, unsigned rawlen, int completed_before,
              uint32_t phase_before, int *completed_after, int *reset, uint32_t *phase_after, int *disposition)
{
    SceneActionInfo info;
    SceneActionRuntimeState before;
    SceneActionHandlerResult out;
    unsigned body = type == 0x20 ? 8u : type == 0x70 ? 1u : 2u;
    int status;

    memset(&info, 0, sizeof info);
    info.type = (uint8_t)type;
    info.subtype = (uint8_t)subtype;
    info.raw_body = raw;
    info.raw_body_length = rawlen;
    info.typed_body = raw;
    info.typed_body_length = rawlen < body ? rawlen : body;
    info.dependency_records = rawlen > body ? raw + body : NULL;
    info.dependency_count = rawlen > body ? (rawlen - body) / 16u : 0u;
    before.completed = (uint8_t)completed_before;
    before.phase = phase_before;
    out.disposition = SCENE_ACTION_HANDLER_PENDING;
    out.phase = phase_before;
    *completed_after = completed_before;
    *reset = 0;
    *phase_after = phase_before;
    if (type == 0x20) status = session_a20_handler(h->b20, (size_t)row, &info, &before, &out);
    else if (type == 0x70) status = session_a70_handler(h->b70, (size_t)row, &info, &before, &out);
    else status = session_a80_handler(h->b80, (size_t)row, &info, &before, &out);
    *disposition = (int)out.disposition;
    if (status != SCENE_ACTION_HANDLER_OK) return status;
    switch (out.disposition) {
    case SCENE_ACTION_HANDLER_PENDING:
        *phase_after = out.phase;
        break;
    case SCENE_ACTION_HANDLER_DIRECT_COMPLETED:
        *completed_after = 1;
        *phase_after = out.phase;
        break;
    case SCENE_ACTION_HANDLER_RESET_DEPENDENCIES:
        *phase_after = 0u;
        *reset = 1;
        break;
    default:
        return 200 + (int)out.disposition;
    }
    return 0;
}

const char *a2o_failure(const Handle *h, int type)
{
    return type == 0x20 ? session_a20_failure(h->b20) : type == 0x70 ? session_a70_failure(h->b70) : session_a80_failure(h->b80);
}
