/* RT-57 native side of the raw 0x6d / 0x9a oracle (tests/action_family_6d_9a_runtime_original_oracle.py).
 *
 * One handle owns the process cells the two arms read or write (as the host stores them), the event flag table (window
 * [0, FLAG_WINDOW)), an ordered log of every host call (this is the order a host can observe) and the two real session bindings
 * of src/session_bindings_a6d_a9a.c. a6o_visit() performs what the executor does for a true gate: it calls the binding handler
 * and derives the row's completion byte and phase from the returned disposition (scene_executor.c apply_external_handler; the
 * only dispositions the two handlers may return are PENDING and DIRECT_COMPLETED, anything else is reported untranslated).
 *
 * Host behaviour modelled here (it is the host's, not the kernels'): the sound stop 0x4fc878 and unload 0x4fb018 (recorders),
 * the popup teardown (a recorder that tells which of the three wrappers 0x4eb96e / 0x4e7d04 / 0x4e303b the kernel selected),
 * the event flag table and window, the scene-change request. Failures and missing optional hosts can be injected to check the
 * native-only refusals. */
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "session_bindings_a6d_a9a.h"

#define LOGMAX 256
#define FLAG_WINDOW 4096

enum {
    V_5BB57B, V_5BB599, V_5BB595, V_5C39FF, V_5BB59B, V_5BB59F, V_5BB5A3, V_5BB1CA, V_583999,
    V_583204, V_5BB22A, V_O6B2, V_583981, V_5839A1, V_5BB1E2,
    NV
};

static const char *const NAMES[NV] = {
    "5bb57b", "5bb599", "5bb595", "5c39ff", "5bb59b", "5bb59f", "5bb5a3", "5bb1ca", "583999",
    "583204", "5bb22a", "o6b2", "583981", "5839a1", "5bb1e2"};

/* failure injection bits */
enum {
    F_LOAD9A = 1, F_STORE_FLAG = 2, F_TRANSITION = 4, F_UNLOAD = 8, F_TEARDOWN = 16, F_LOAD6D = 32
};
/* omitted optional or required hosts (the binding is recreated) */
enum {
    O_TEARDOWN = 1, O_STORE6D = 2, O_TRANSITION = 4, O_STOP = 8, O_FLAGQ = 16, O_FLAGSTORE = 32, O_UNLOAD = 64, O_LOAD6D = 128,
    O_LOAD9A = 256, O_STORE9A = 512
};
/* log kinds */
enum { L_STOP = 1, L_FLAG = 2, L_STORE9A = 3, L_TRANSITION = 4, L_TEARDOWN = 5, L_UNLOAD = 6, L_STORE6D = 7, L_FLAGQ = 8 };

typedef struct {
    int64_t kind, a, b;
} LogRec;

typedef struct {
    int64_t v[NV];
    int64_t flags[FLAG_WINDOW];
    LogRec log[LOGMAX];
    int nlog;
    SceneTransitionRequest req;
    int fail, omit;
    int fail_stop_n; /* the Nth stop call (1-based) fails; 0 never */
    int stops;
    SessionA6dBinding *b6d;
    SessionA9aBinding *b9a;
} Handle;

static void add_log(Handle *h, int64_t kind, int64_t a, int64_t b)
{
    if (h->nlog < LOGMAX) {
        h->log[h->nlog].kind = kind;
        h->log[h->nlog].a = a;
        h->log[h->nlog].b = b;
        ++h->nlog;
    }
}

/* ---- raw 0x9a host ---------------------------------------------------------------------------------------------------- */
static int load9a(void *ctx, Action9AWorld *w)
{
    Handle *h = (Handle *)ctx;
    if (h->fail & F_LOAD9A) return 1;
    w->scene_5bb57b = (int32_t)h->v[V_5BB57B];
    w->word_5bb599 = (int16_t)h->v[V_5BB599];
    w->word_5bb595 = (int16_t)h->v[V_5BB595];
    w->word_5c39ff = (int16_t)h->v[V_5C39FF];
    w->dword_5bb59b = (int32_t)h->v[V_5BB59B];
    w->dword_5bb59f = (int32_t)h->v[V_5BB59F];
    w->dword_5bb5a3 = (int32_t)h->v[V_5BB5A3];
    w->start_flag_5bb1ca = (int32_t)h->v[V_5BB1CA];
    w->engine_mode_583999 = (int32_t)h->v[V_583999];
    return 0;
}

static void store9a(void *ctx, const Action9AWorld *w)
{
    Handle *h = (Handle *)ctx;
    add_log(h, L_STORE9A, 0, 0);
    h->v[V_5BB57B] = w->scene_5bb57b;
    h->v[V_5BB599] = w->word_5bb599;
    h->v[V_5BB595] = w->word_5bb595;
    h->v[V_5C39FF] = w->word_5c39ff;
    h->v[V_5BB59B] = w->dword_5bb59b;
    h->v[V_5BB59F] = w->dword_5bb59f;
    h->v[V_5BB5A3] = w->dword_5bb5a3;
    h->v[V_5BB1CA] = w->start_flag_5bb1ca;
    h->v[V_583999] = w->engine_mode_583999;
}

static int stop_channel(void *ctx, uint16_t channel)
{
    Handle *h = (Handle *)ctx;
    ++h->stops;
    if (h->fail_stop_n != 0 && h->stops == h->fail_stop_n) return 1;
    add_log(h, L_STOP, channel, 0);
    return 0;
}

static int flag_invalid(void *ctx, int16_t index)
{
    Handle *h = (Handle *)ctx;
    add_log(h, L_FLAGQ, index, 0);
    return index < 0 || index >= FLAG_WINDOW;
}

static int store_flag(void *ctx, int16_t index, uint32_t value)
{
    Handle *h = (Handle *)ctx;
    if (h->fail & F_STORE_FLAG) return 1;
    if (index < 0 || index >= FLAG_WINDOW) return 1;
    add_log(h, L_FLAG, index, value);
    h->flags[index] = (int32_t)value;
    return 0;
}

static int transition9a(void *ctx, const SceneTransitionRequest *request)
{
    Handle *h = (Handle *)ctx;
    if (h->fail & F_TRANSITION) return 1;
    add_log(h, L_TRANSITION, 0, 0);
    h->req = *request;
    return 0;
}

/* ---- raw 0x6d host ---------------------------------------------------------------------------------------------------- */
static int load6d(void *ctx, Action6DWorld *w)
{
    Handle *h = (Handle *)ctx;
    if (h->fail & F_LOAD6D) return 1;
    w->popup_mode_583204 = (int32_t)h->v[V_583204];
    w->overlay_flag_5bb22a = (int32_t)h->v[V_5BB22A];
    w->overlay_return_6b2 = (int16_t)h->v[V_O6B2];
    w->outer_state_583981 = (int32_t)h->v[V_583981];
    w->cell_5839a1 = (int32_t)h->v[V_5839A1];
    w->engine_mode_583999 = (int32_t)h->v[V_583999];
    w->cell_5bb1e2 = (int32_t)h->v[V_5BB1E2];
    return 0;
}

static void store6d(void *ctx, const Action6DWorld *w)
{
    Handle *h = (Handle *)ctx;
    add_log(h, L_STORE6D, 0, 0);
    h->v[V_583204] = w->popup_mode_583204;
    h->v[V_5BB22A] = w->overlay_flag_5bb22a;
    h->v[V_O6B2] = w->overlay_return_6b2;
    h->v[V_583981] = w->outer_state_583981;
    h->v[V_5839A1] = w->cell_5839a1;
    h->v[V_583999] = w->engine_mode_583999;
    h->v[V_5BB1E2] = w->cell_5bb1e2;
}

static int unload6d(void *ctx)
{
    Handle *h = (Handle *)ctx;
    if (h->fail & F_UNLOAD) return 1;
    add_log(h, L_UNLOAD, 0, 0);
    return 0;
}

static int teardown6d(void *ctx, Action6DTeardown kind)
{
    Handle *h = (Handle *)ctx;
    if (h->fail & F_TEARDOWN) return 1;
    add_log(h, L_TEARDOWN, (int64_t)kind, 0);
    return 0;
}

/* ---- handle ----------------------------------------------------------------------------------------------------------- */
static int make_bindings(Handle *h)
{
    SessionA6dHost h6;
    SessionA9aHost h9;
    memset(&h6, 0, sizeof h6);
    memset(&h9, 0, sizeof h9);
    h6.context = h9.context = h;
    h6.load_world = (h->omit & O_LOAD6D) ? NULL : load6d;
    h6.store_world = (h->omit & O_STORE6D) ? NULL : store6d;
    h6.unload_scene_sound = (h->omit & O_UNLOAD) ? NULL : unload6d;
    h6.teardown = (h->omit & O_TEARDOWN) ? NULL : teardown6d;
    h9.load_world = (h->omit & O_LOAD9A) ? NULL : load9a;
    h9.store_world = (h->omit & O_STORE9A) ? NULL : store9a;
    h9.stop_channel = (h->omit & O_STOP) ? NULL : stop_channel;
    h9.event_flag_invalid = (h->omit & O_FLAGQ) ? NULL : flag_invalid;
    h9.store_event_flag = (h->omit & O_FLAGSTORE) ? NULL : store_flag;
    h9.transition = (h->omit & O_TRANSITION) ? NULL : transition9a;
    session_a6d_destroy(h->b6d);
    session_a9a_destroy(h->b9a);
    h->b6d = session_a6d_create(&h6);
    h->b9a = session_a9a_create(&h9);
    return h->b6d != NULL && h->b9a != NULL;
}

Handle *a6o_new(void)
{
    Handle *h = (Handle *)calloc(1u, sizeof(*h));
    if (h == NULL) return NULL;
    if (!make_bindings(h)) {
        session_a6d_destroy(h->b6d);
        session_a9a_destroy(h->b9a);
        free(h);
        return NULL;
    }
    return h;
}

void a6o_free(Handle *h)
{
    if (h != NULL) {
        session_a6d_destroy(h->b6d);
        session_a9a_destroy(h->b9a);
        free(h);
    }
}

void a6o_reset(Handle *h)
{
    memset(h->v, 0, sizeof h->v);
    memset(h->flags, 0, sizeof h->flags);
    memset(&h->req, 0, sizeof h->req);
    h->nlog = 0;
    h->fail = 0;
    h->fail_stop_n = 0;
    h->stops = 0;
    h->omit = 0;
    make_bindings(h);
}

void a6o_clear_logs(Handle *h)
{
    h->nlog = 0;
    h->stops = 0;
}

int a6o_nv(void) { return NV; }
int a6o_flag_window(void) { return FLAG_WINDOW; }
const char *a6o_name(int i) { return i >= 0 && i < NV ? NAMES[i] : NULL; }
int64_t a6o_get(const Handle *h, int i) { return h->v[i]; }
void a6o_set(Handle *h, int i, int64_t value) { h->v[i] = value; }
void a6o_set_fail(Handle *h, int mask, int fail_stop_n)
{
    h->fail = mask;
    h->fail_stop_n = fail_stop_n;
}
void a6o_set_omit(Handle *h, int mask)
{
    h->omit = mask;
    make_bindings(h);
}
/* the whole table as 32-bit values (the original stores a dword per flag) */
void a6o_flags_get(const Handle *h, int32_t *out)
{
    int i;
    for (i = 0; i < FLAG_WINDOW; ++i) out[i] = (int32_t)h->flags[i];
}

void a6o_flags_load(Handle *h, const int32_t *in)
{
    int i;
    for (i = 0; i < FLAG_WINDOW; ++i) h->flags[i] = in[i];
}

int a6o_log_count(const Handle *h) { return h->nlog; }
void a6o_log_get(const Handle *h, int i, int64_t *out)
{
    out[0] = h->log[i].kind;
    out[1] = h->log[i].a;
    out[2] = h->log[i].b;
}

/* target, words 0..2, dwords 0..2 */
void a6o_req(const Handle *h, int64_t *out)
{
    out[0] = h->req.target_scene;
    out[1] = h->req.opaque_words[0];
    out[2] = h->req.opaque_words[1];
    out[3] = h->req.opaque_words[2];
    out[4] = h->req.opaque_dwords[0];
    out[5] = h->req.opaque_dwords[1];
    out[6] = h->req.opaque_dwords[2];
}

/* The bindings' own copy of the world the last working visit committed, in the order of the cell table (cells the family does not
 * carry are -1 << 40, never a real cell value); the visit counters. */
void a6o_last_world(const Handle *h, int family, int64_t *out)
{
    int i;
    const Action9AWorld *w9;
    const Action6DWorld *w6;
    for (i = 0; i < NV; ++i) out[i] = (-INT64_C(0x10000000000));
    if (family == 0x9a) {
        w9 = session_a9a_last_world(h->b9a);
        out[V_5BB57B] = w9->scene_5bb57b;
        out[V_5BB599] = w9->word_5bb599;
        out[V_5BB595] = w9->word_5bb595;
        out[V_5C39FF] = w9->word_5c39ff;
        out[V_5BB59B] = w9->dword_5bb59b;
        out[V_5BB59F] = w9->dword_5bb59f;
        out[V_5BB5A3] = w9->dword_5bb5a3;
        out[V_5BB1CA] = w9->start_flag_5bb1ca;
        out[V_583999] = w9->engine_mode_583999;
    } else {
        w6 = session_a6d_last_world(h->b6d);
        out[V_583204] = w6->popup_mode_583204;
        out[V_5BB22A] = w6->overlay_flag_5bb22a;
        out[V_O6B2] = w6->overlay_return_6b2;
        out[V_583981] = w6->outer_state_583981;
        out[V_5839A1] = w6->cell_5839a1;
        out[V_583999] = w6->engine_mode_583999;
        out[V_5BB1E2] = w6->cell_5bb1e2;
    }
}

int64_t a6o_visits(const Handle *h, int family)
{
    return family == 0x9a ? (int64_t)session_a9a_visits(h->b9a) : (int64_t)session_a6d_visits(h->b6d);
}

/* Returns the handler status (SCENE_ACTION_HANDLER_*), or 200 + the disposition when it is not one the executor maps here. */
int a6o_visit(Handle *h, int binding, int type, int row, int subtype, const uint8_t *raw, unsigned rawlen, int completed_before,
              uint32_t phase_before, int *completed_after, uint32_t *phase_after, int *disposition)
{
    SceneActionInfo info;
    SceneActionRuntimeState before;
    SceneActionHandlerResult out;
    unsigned body = binding == 0x9a ? 27u : 1u;
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
    *phase_after = phase_before;
    *disposition = -1;
    if (binding == 0x6d) status = session_a6d_handler(h->b6d, (size_t)row, &info, &before, &out);
    else status = session_a9a_handler(h->b9a, (size_t)row, &info, &before, &out);
    if (status != SCENE_ACTION_HANDLER_OK) return status;
    *disposition = (int)out.disposition;
    switch (out.disposition) {
    case SCENE_ACTION_HANDLER_PENDING:
        *phase_after = out.phase;
        break;
    case SCENE_ACTION_HANDLER_DIRECT_COMPLETED:
        *completed_after = 1;
        *phase_after = out.phase;
        break;
    default:
        return 200 + (int)out.disposition;
    }
    return 0;
}

const char *a6o_failure(const Handle *h, int type)
{
    return type == 0x6d ? session_a6d_failure(h->b6d) : session_a9a_failure(h->b9a);
}
