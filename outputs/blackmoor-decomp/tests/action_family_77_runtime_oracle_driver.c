/* RT-49 native side of the raw 0x77 Ordering Puzzle oracle (tests/action_family_77_runtime_original_oracle.py).
 *
 * One handle owns an A77State, an A77World and the host side of the A77Host contract: scripted queues (rand values, tick
 * values, sound-busy answers, surface handles), the event flag window (4096 dwords), the seven scene-change cells and the
 * engine mode as the transition request stores them, and the view origin. Two logs are kept for every call:
 *   - the OBSERVER log: what the kernel reports through A77Host.observe (effect, a, b);
 *   - the HOST-CALL log: what the kernel actually asked of the host, encoded as the effect it corresponds to, so the oracle can
 *     check that the observer neither invents nor omits an effect.
 * Everything here is test scaffolding (no kernel logic is repeated): the driver never decides anything the kernel decides.
 * The functions are called through ctypes; every buffer layout is documented at the function. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_77_runtime.h"

#define LOGMAX 512
#define QMAX 64
#define EVENTS 4096
#define NAMES 8

enum { Q_RAND, Q_TICK, Q_BUSY, Q_HANDLE, QKINDS };
enum { F_LOAD = 1, F_RELEASE = 2, F_PREPARE = 4, F_STOP = 8, F_PLAY = 16, F_BUSY = 32, F_TRANSITION = 64, F_FLAG = 128, F_ORIGIN = 256 };

typedef struct {
    int64_t v[QMAX];
    int n, pos, underflow;
} Queue;

typedef struct {
    A77State st;
    A77World world;
    Queue q[QKINDS];
    uint32_t events[EVENTS];
    int32_t mode;
    int32_t c57b;
    int16_t c599, c595, c39ff;
    int32_t c59b, c59f, c5a3;
    int32_t org_x, org_y;
    int32_t fx[LOGMAX][3];
    int nfx;
    int32_t hc[LOGMAX][3];
    int nhc;
    char names[NAMES][40];
    int nnames;
    int transitions;
    int fail;
    const uint8_t *body; /* the body of the current call, to turn record pointers into offsets */
    A77Host host;
} Drv;

static int32_t q_pop(Drv *d, int kind, int *ok)
{
    Queue *q = &d->q[kind];
    if (q->pos >= q->n) {
        q->underflow = 1;
        *ok = 0;
        return 0;
    }
    return (int32_t)(uint32_t)(uint64_t)q->v[q->pos++];
}

static void hc(Drv *d, int kind, int32_t a, int32_t b)
{
    if (d->nhc < LOGMAX) {
        d->hc[d->nhc][0] = kind;
        d->hc[d->nhc][1] = a;
        d->hc[d->nhc][2] = b;
        ++d->nhc;
    }
}

static int32_t h_random(void *c)
{
    Drv *d = (Drv *)c;
    int ok = 1;
    int32_t v = q_pop(d, Q_RAND, &ok);
    hc(d, A77_FX_RANDOM, v, 0);
    return v;
}

static int h_load(void *c, const char *name, uint32_t *surface)
{
    Drv *d = (Drv *)c;
    int ok = 1;
    int32_t v = q_pop(d, Q_HANDLE, &ok);
    if (d->nnames < NAMES) {
        strncpy(d->names[d->nnames], name, 39);
        d->names[d->nnames][39] = 0;
    }
    ++d->nnames;
    if (d->fail & F_LOAD) return 1;
    *surface = (uint32_t)v;
    hc(d, A77_FX_SURFACE_LOAD, v, 0);
    return 0;
}

static int h_release(void *c, uint32_t surface)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_RELEASE) return 1;
    hc(d, A77_FX_RELEASE_SURFACE, (int32_t)surface, 0);
    return 0;
}

static int h_prepare(void *c, const uint8_t *rec)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_PREPARE) return 1;
    hc(d, A77_FX_SOUND_PREPARE, (int32_t)(rec - d->body), 0);
    return 0;
}

static int h_stop(void *c, const uint8_t *rec)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_STOP) return 1;
    hc(d, A77_FX_SOUND_STOP, (int32_t)(rec - d->body), 0);
    return 0;
}

static int h_play(void *c, int16_t channel)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_PLAY) return 1;
    hc(d, A77_FX_SOUND_PLAY, channel, 0);
    return 0;
}

static int h_busy(void *c, int16_t channel, int32_t *result)
{
    Drv *d = (Drv *)c;
    int ok = 1;
    int32_t v = q_pop(d, Q_BUSY, &ok);
    if (d->fail & F_BUSY) return 1;
    *result = v;
    hc(d, A77_FX_SOUND_BUSY, channel, v);
    return 0;
}

static uint32_t h_tick(void *c)
{
    Drv *d = (Drv *)c;
    int ok = 1;
    int32_t v = q_pop(d, Q_TICK, &ok);
    hc(d, A77_FX_TICK, v, 0);
    return (uint32_t)v;
}

static int h_flag_invalid(void *c, int16_t index)
{
    (void)c;
    return index < 0 || index >= EVENTS;
}

static int h_transition(void *c, const A77Transition *t)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_TRANSITION) return 1;
    d->c57b = (int32_t)t->scene;
    d->c599 = t->word[0];
    d->c595 = t->word[1];
    d->c39ff = t->word[2];
    d->c59b = t->dword[0];
    d->c59f = t->dword[1];
    d->c5a3 = t->dword[2];
    d->mode = 4;
    ++d->transitions;
    return 0;
}

static int h_store_flag(void *c, int16_t index, uint32_t value)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_FLAG) return 1;
    if (index < 0 || index >= EVENTS) return 1;
    d->events[index] = value;
    hc(d, A77_FX_EVENT_FLAG, index, (int32_t)value);
    return 0;
}

static int h_origin(void *c, int32_t *x, int32_t *y)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_ORIGIN) return 1;
    *x = d->org_x;
    *y = d->org_y;
    return 0;
}

static void h_observe(void *c, int effect, int32_t a, int32_t b)
{
    Drv *d = (Drv *)c;
    if (d->nfx < LOGMAX) {
        d->fx[d->nfx][0] = effect;
        d->fx[d->nfx][1] = a;
        d->fx[d->nfx][2] = b;
        ++d->nfx;
    }
}

void *a77o_new(void)
{
    Drv *d = (Drv *)calloc(1, sizeof(Drv));
    if (d == NULL) return NULL;
    d->host.context = d;
    d->host.random = h_random;
    d->host.load_surface = h_load;
    d->host.release_surface = h_release;
    d->host.sound_prepare = h_prepare;
    d->host.sound_stop = h_stop;
    d->host.sound_play = h_play;
    d->host.sound_busy = h_busy;
    d->host.tick = h_tick;
    d->host.event_flag_invalid = h_flag_invalid;
    d->host.transition = h_transition;
    d->host.store_event_flag = h_store_flag;
    d->host.view_origin = h_origin;
    d->host.observe = h_observe;
    return d;
}

void a77o_free(void *h) { free(h); }

void a77o_reset(void *h)
{
    Drv *d = (Drv *)h;
    A77Host host = d->host;
    memset(d, 0, sizeof(*d));
    d->host = host;
    d->host.context = d;
    a77_state_reset(&d->st);
}

void a77o_clear_logs(void *h)
{
    Drv *d = (Drv *)h;
    d->nfx = d->nhc = 0;
    d->nnames = 0;
}

void a77o_set_fail(void *h, int mask) { ((Drv *)h)->fail = mask; }
void a77o_set_origin(void *h, int32_t x, int32_t y) { ((Drv *)h)->org_x = x, ((Drv *)h)->org_y = y; }

/* Queues: a77o_q_set replaces a queue, a77o_q_pos returns {consumed, underflowed}. */
void a77o_q_set(void *h, int kind, const int64_t *vals, int n)
{
    Queue *q = &((Drv *)h)->q[kind];
    if (n > QMAX) n = QMAX;
    memset(q, 0, sizeof(*q));
    for (int i = 0; i < n; ++i) q->v[i] = vals[i];
    q->n = n;
}
int a77o_q_pos(void *h, int kind) { return ((Drv *)h)->q[kind].pos; }
int a77o_q_underflow(void *h, int kind) { return ((Drv *)h)->q[kind].underflow; }

/* The 67-byte process image 0x5b5128..0x5b516a: selected[16], order[16] (int16), active, row (int16), hover (int16),
 * exit_requested, deadline (u32), step (u32), count (int16), limit (int16), solved. */
void a77o_state_get(void *h, uint8_t *b)
{
    const A77State *s = &((Drv *)h)->st;
    memcpy(b, s->selected, 16);
    memcpy(b + 16, s->order, 32);
    b[48] = s->active;
    memcpy(b + 49, &s->row, 2);
    memcpy(b + 51, &s->hover, 2);
    b[53] = s->exit_requested;
    memcpy(b + 54, &s->deadline, 4);
    memcpy(b + 58, &s->step, 4);
    memcpy(b + 62, &s->count, 2);
    memcpy(b + 64, &s->limit, 2);
    b[66] = s->solved;
}

void a77o_state_set(void *h, const uint8_t *b)
{
    A77State *s = &((Drv *)h)->st;
    memcpy(s->selected, b, 16);
    memcpy(s->order, b + 16, 32);
    s->active = b[48];
    memcpy(&s->row, b + 49, 2);
    memcpy(&s->hover, b + 51, 2);
    s->exit_requested = b[53];
    memcpy(&s->deadline, b + 54, 4);
    memcpy(&s->step, b + 58, 4);
    memcpy(&s->count, b + 62, 2);
    memcpy(&s->limit, b + 64, 2);
    s->solved = b[66];
}

/* out: surface (0x5d03cf), overlay_surface (0x5d1a83), overlay_active (0x5d1a8f), initialized (native only), start flag 0x5bb1ca. */
void a77o_extra_get(void *h, uint32_t *o)
{
    const Drv *d = (Drv *)h;
    o[0] = d->st.surface;
    o[1] = d->st.overlay_surface;
    o[2] = d->st.overlay_active;
    o[3] = d->st.initialized;
    o[4] = (uint32_t)d->world.start_flag_5bb1ca;
}

void a77o_extra_set(void *h, const uint32_t *o)
{
    Drv *d = (Drv *)h;
    d->st.surface = o[0];
    d->st.overlay_surface = o[1];
    d->st.overlay_active = o[2];
    d->st.initialized = (uint8_t)o[3];
    d->world.start_flag_5bb1ca = (int32_t)o[4];
}

/* cells: mode, 5bb57b, 5bb599, 5bb595, 5c39ff, 5bb59b, 5bb59f, 5bb5a3, transitions made */
void a77o_cells_get(void *h, int32_t *o)
{
    const Drv *d = (Drv *)h;
    o[0] = d->mode;
    o[1] = d->c57b;
    o[2] = d->c599;
    o[3] = d->c595;
    o[4] = d->c39ff;
    o[5] = d->c59b;
    o[6] = d->c59f;
    o[7] = d->c5a3;
    o[8] = d->transitions;
}

void a77o_cells_set(void *h, const int32_t *o)
{
    Drv *d = (Drv *)h;
    d->mode = o[0];
    d->c57b = o[1];
    d->c599 = (int16_t)o[2];
    d->c595 = (int16_t)o[3];
    d->c39ff = (int16_t)o[4];
    d->c59b = o[5];
    d->c59f = o[6];
    d->c5a3 = o[7];
}

void a77o_events_get(void *h, uint8_t *out) { memcpy(out, ((Drv *)h)->events, sizeof(((Drv *)h)->events)); }
void a77o_events_set(void *h, const uint8_t *in) { memcpy(((Drv *)h)->events, in, sizeof(((Drv *)h)->events)); }

int a77o_log(void *h, int which, int32_t *out, int max)
{
    const Drv *d = (Drv *)h;
    const int n = which == 0 ? d->nfx : d->nhc;
    const int32_t(*src)[3] = which == 0 ? d->fx : d->hc;
    if (n > max) return -1;
    memcpy(out, src, (size_t)n * 12);
    return n;
}

const char *a77o_name(void *h, int i)
{
    const Drv *d = (Drv *)h;
    return (i >= 0 && i < d->nnames && i < NAMES) ? d->names[i] : NULL;
}
int a77o_nnames(void *h) { return ((Drv *)h)->nnames; }

/* One true-gate visit of 0x42ed54. out: status, phase_after, initialized, completed. The start flag is in a77o_extra_get[4]. */
void a77o_step(void *h, const uint8_t *body, int len, int row, uint32_t phase, int32_t *out)
{
    Drv *d = (Drv *)h;
    A77Result r;
    const char *why = NULL;
    memset(&r, 0, sizeof(r));
    d->body = body;
    out[0] = a77_step(&d->st, body, (size_t)len, (int16_t)row, phase, &d->world, &d->host, &r, &why);
    out[1] = (int32_t)r.phase_after;
    out[2] = r.initialized;
    out[3] = r.completed;
    d->body = NULL;
}

/* out: status, hit, candidate, hover, cursor_kind, cursor_sub */
void a77o_pointer(void *h, const uint8_t *body, int len, int32_t x, int32_t y, int32_t *out)
{
    Drv *d = (Drv *)h;
    A77PointerResult r;
    memset(&r, 0, sizeof(r));
    out[0] = a77_pointer(&d->st, body, (size_t)len, x, y, &r);
    out[1] = r.hit;
    out[2] = r.candidate;
    out[3] = r.hover;
    out[4] = r.cursor_kind;
    out[5] = r.cursor_sub;
}

/* out: status, toggled, exit_asked, new_phase, click_sound */
void a77o_click(void *h, const uint8_t *body, int len, uint32_t row_phase, int32_t candidate, int32_t start_flag, int32_t *out)
{
    Drv *d = (Drv *)h;
    A77ClickResult r;
    memset(&r, 0, sizeof(r));
    d->body = body;
    out[0] = a77_click(&d->st, body, (size_t)len, row_phase, candidate, start_flag, &d->host, &r);
    out[1] = r.toggled;
    out[2] = r.exit_asked;
    out[3] = (int32_t)r.new_phase;
    out[4] = r.click_sound;
    d->body = NULL;
}

int a77o_clear(void *h) { return a77_clear(&((Drv *)h)->st, &((Drv *)h)->host); }

int a77o_validate(const uint8_t *body, int len) { return a77_validate_body(body, (size_t)len, NULL); }

/* out: status, valid, surface, count, then 16 x (selected, src[4], dst[4]) = 9 ints each. */
void a77o_render(void *h, const uint8_t *body, int len, int32_t *out)
{
    Drv *d = (Drv *)h;
    A77RenderPlan p;
    memset(&p, 0xA5, sizeof(p));
    out[0] = a77_render_plan(&d->st, body, (size_t)len, &d->host, &p);
    out[1] = p.valid;
    out[2] = (int32_t)p.surface;
    out[3] = p.count;
    for (int i = 0; i < A77_MAX_BUTTONS; ++i) {
        int32_t *o = out + 4 + 9 * i;
        o[0] = p.blit[i].selected;
        for (int k = 0; k < 4; ++k) o[1 + k] = p.blit[i].src[k];
        for (int k = 0; k < 4; ++k) o[5 + k] = p.blit[i].dst[k];
    }
}
