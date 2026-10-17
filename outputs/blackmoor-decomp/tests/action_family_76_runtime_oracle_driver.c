/* RT-58: native side of the raw-0x76 (PASSWORD puzzle) original-x86 oracle. Links ONLY src/action_family_76_runtime.c and implements the
 * HOST side of the PwdHost contract with scripted queues (GetTickCount values, sound busy results), the view origin, the text width stand-in,
 * the event flag window and the scene-change cells. The driver decides nothing the kernel decides. It keeps two logs: the observer log
 * (PwdHost.observe) and the host-call log (what the kernel really asked of the host); the oracle requires them to agree.
 *
 * Built as a shared library and driven through ctypes by tests/action_family_76_runtime_original_oracle.py. Portable C11. */
#include "action_family_76_runtime.h"

#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#define EVENT_COUNT 4096
#define QMAX 8192
#define LOGMAX 16384

enum { HC_VIEW = 100, HC_TRANSITION = 12 /* same number as PWD_FX_XFER_5BB57B: the scene word */ };

typedef struct Triple {
    int32_t kind, a, b;
} Triple;

typedef struct Oracle {
    PwdState st;
    int64_t tick_q[QMAX];
    int32_t tick_n, tick_i, tick_under;
    int64_t busy_q[QMAX];
    int32_t busy_n, busy_i, busy_under;
    int32_t view_x, view_y;
    int32_t width_k, width_add; /* the text width stand-in */
    int32_t fail_at;            /* the n-th host call fails (0 = never) */
    int32_t host_calls;
    int32_t mode;               /* 0x583999 */
    int32_t start_flag;         /* 0x5bb1ca, from the observer */
    int32_t entry_flag;         /* 0x5d1c01, from the observer and invalidate / cleanup */
    int32_t xfer[7];            /* 0x5bb57b, 0x5bb599, 0x5bb595, 0x5c39ff, 0x5bb59b, 0x5bb59f, 0x5bb5a3 */
    int32_t events[EVENT_COUNT];
    Triple obs[LOGMAX], host[LOGMAX];
    int32_t nobs, nhost, overflow;
    int32_t errors[3]; /* sound record pointer not in the body, event flag outside the window, unexpected call order */
    const uint8_t *body;
    size_t body_len;
} Oracle;

static void log_obs(Oracle *o, int k, int32_t a, int32_t b)
{
    if (o->nobs < LOGMAX) {
        o->obs[o->nobs].kind = k;
        o->obs[o->nobs].a = a;
        o->obs[o->nobs].b = b;
        o->nobs++;
    } else {
        o->overflow = 1;
    }
}

static void log_host(Oracle *o, int k, int32_t a, int32_t b)
{
    if (o->nhost < LOGMAX) {
        o->host[o->nhost].kind = k;
        o->host[o->nhost].a = a;
        o->host[o->nhost].b = b;
        o->nhost++;
    } else {
        o->overflow = 1;
    }
}

static int failing(Oracle *o)
{
    o->host_calls++;
    return o->fail_at != 0 && o->host_calls == o->fail_at;
}

static int h_view(void *c, int32_t *x, int32_t *y)
{
    Oracle *o = c;
    if (failing(o)) return 1;
    *x = o->view_x;
    *y = o->view_y;
    log_host(o, HC_VIEW, o->view_x, o->view_y);
    return 0;
}

static int h_font_acquire(void *c, int16_t font)
{
    Oracle *o = c;
    if (failing(o)) return 1;
    log_host(o, PWD_FX_FONT_ACQUIRE, font, 0);
    return 0;
}

static int h_font_release(void *c, int16_t font)
{
    Oracle *o = c;
    if (failing(o)) return 1;
    log_host(o, PWD_FX_FONT_RELEASE, font, 0);
    return 0;
}

/* The text width stand-in: the same function as the Python hook of 0x4d3836 (tests/action_family_76_runtime_original_oracle.py). */
static int32_t width_of(const Oracle *o, int16_t font, const char *text)
{
    int32_t sum = 0;
    const unsigned char *p;
    for (p = (const unsigned char *)text; *p != 0; ++p) sum += 5 + (*p % 7) + (font % 3);
    return (int16_t)(uint16_t)(uint32_t)(o->width_k * sum + o->width_add);
}

static int h_text_width(void *c, int16_t font, const char *text, int16_t *width)
{
    Oracle *o = c;
    if (failing(o)) return 1;
    *width = (int16_t)width_of(o, font, text);
    log_host(o, PWD_FX_TEXT_WIDTH, *width, 0);
    return 0;
}

static uint32_t h_tick(void *c)
{
    Oracle *o = c;
    uint32_t v = 0;
    o->host_calls++;
    if (o->tick_i < o->tick_n) {
        v = (uint32_t)o->tick_q[o->tick_i++];
    } else {
        o->tick_under = 1;
    }
    log_host(o, PWD_FX_TICK, (int32_t)v, 0);
    return v;
}

static int record_offset(Oracle *o, const uint8_t *record, int32_t *off)
{
    if (o->body == NULL || record < o->body || record >= o->body + o->body_len) {
        o->errors[0]++;
        *off = -1;
        return 1;
    }
    *off = (int32_t)(record - o->body);
    return 0;
}

static int h_sound_prepare(void *c, const uint8_t *record)
{
    Oracle *o = c;
    int32_t off;
    if (failing(o)) return 1;
    if (record_offset(o, record, &off)) return 1;
    log_host(o, PWD_FX_SOUND_PREPARE, off, 0);
    return 0;
}

static int h_sound_stop(void *c, const uint8_t *record)
{
    Oracle *o = c;
    int32_t off;
    if (failing(o)) return 1;
    if (record_offset(o, record, &off)) return 1;
    log_host(o, PWD_FX_SOUND_STOP, off, 0);
    return 0;
}

static int h_sound_play(void *c, int16_t channel)
{
    Oracle *o = c;
    if (failing(o)) return 1;
    log_host(o, PWD_FX_SOUND_PLAY, channel, 0);
    return 0;
}

static int h_sound_busy(void *c, int16_t channel, int32_t *result)
{
    Oracle *o = c;
    if (failing(o)) return 1;
    if (o->busy_i < o->busy_n) {
        *result = (int32_t)o->busy_q[o->busy_i++];
    } else {
        o->busy_under = 1;
        *result = 0;
    }
    log_host(o, PWD_FX_SOUND_BUSY, channel, *result);
    return 0;
}

static int h_flag_invalid(void *c, int16_t index)
{
    (void)c;
    return index < 0 || index >= EVENT_COUNT;
}

static int h_transition(void *c, const PwdTransition *t)
{
    Oracle *o = c;
    if (failing(o)) return 1;
    o->xfer[0] = t->scene;
    o->xfer[1] = t->word[0];
    o->xfer[2] = t->word[1];
    o->xfer[3] = t->word[2];
    o->xfer[4] = t->dword[0];
    o->xfer[5] = t->dword[1];
    o->xfer[6] = t->dword[2];
    o->mode = 4;
    log_host(o, HC_TRANSITION, t->scene, 0);
    return 0;
}

static int h_store_flag(void *c, int16_t index, uint32_t value)
{
    Oracle *o = c;
    if (failing(o)) return 1;
    if (index < 0 || index >= EVENT_COUNT) {
        o->errors[1]++;
        return 1;
    }
    o->events[index] = (int32_t)value;
    log_host(o, PWD_FX_EVENT_FLAG, index, (int32_t)value);
    return 0;
}

static void h_observe(void *c, int effect, int32_t a, int32_t b)
{
    Oracle *o = c;
    log_obs(o, effect, a, b);
    if (effect == PWD_FX_START_FLAG) o->start_flag = a;
    if (effect == PWD_FX_ENTRY_VISIBLE) o->entry_flag = a;
}

static PwdHost make_host(Oracle *o)
{
    PwdHost h;
    memset(&h, 0, sizeof h);
    h.context = o;
    h.view_origin = h_view;
    h.font_acquire = h_font_acquire;
    h.font_release = h_font_release;
    h.text_width = h_text_width;
    h.tick = h_tick;
    h.sound_prepare = h_sound_prepare;
    h.sound_stop = h_sound_stop;
    h.sound_play = h_sound_play;
    h.sound_busy = h_sound_busy;
    h.event_flag_invalid = h_flag_invalid;
    h.transition = h_transition;
    h.store_event_flag = h_store_flag;
    h.observe = h_observe;
    return h;
}

/* ---- exported API ------------------------------------------------------------------------------------------------------------- */
void *p76o_new(void)
{
    Oracle *o = calloc(1, sizeof *o);
    if (o != NULL) {
        o->width_k = 1;
        o->mode = 3;
    }
    return o;
}

void p76o_free(void *h)
{
    free(h);
}

void p76o_reset(void *h)
{
    Oracle *o = h;
    memset(o, 0, sizeof *o);
    memset(o->st.b, 0xA5, sizeof o->st.b);
    pwd_state_reset(&o->st); /* must give the power-on (all zero) state */
    o->width_k = 1;
    o->mode = 3;
}

/* The contract constants of the header, for the oracle to compare with the values the original and the packet fix. */
void p76o_constants(int32_t *out)
{
    out[0] = PWD_RUNTIME_TYPE;
    out[1] = PWD_BODY_BYTES;
    out[2] = PWD_STATE_BYTES;
    out[3] = PWD_TEXT_BYTES;
    out[4] = PWD_MAX_ACCEPTED;
    out[5] = PWD_MAX_FONT;
    out[6] = PWD_NO_SCENE;
    out[7] = PWD_NO_FLAG;
    out[8] = PWD_CANDIDATE_CANCEL;
    out[9] = PWD_CURSOR_KIND_CANCEL;
    out[10] = PWD_MAX_OPS;
    out[11] = PWD_OK;
    out[12] = PWD_ERR_ARGUMENT;
    out[13] = PWD_ERR_BODY;
    out[14] = PWD_ERR_UNSUPPORTED;
    out[15] = PWD_ERR_HOST;
    out[16] = PWD_ERR_BOUNDS;
    out[17] = (int32_t)sizeof(PwdTransition);
    out[18] = (int32_t)sizeof(PwdState);
    out[19] = PWD_OP_BLIT;
    out[20] = PWD_OP_TEXT;
    out[21] = PWD_STATE_FIELD1;
    out[22] = PWD_STATE_FIELD2;
    out[23] = PWD_STATE_WRONG_SOUND;
    out[24] = PWD_STATE_SUCCESS_WAIT;
    out[25] = PWD_STATE_WRONG_WAIT;
    out[26] = PWD_STATE_SUCCESS_SOUND;
    out[27] = PWD_S_KEY_PENDING;
    out[28] = PWD_S_KEY;
    out[29] = PWD_S_FIELD1;
    out[30] = PWD_S_FIELD2;
    out[31] = PWD_S_ACTIVE;
    out[32] = PWD_S_ROW;
    out[33] = PWD_S_CANCEL;
    out[34] = PWD_S_WRONG;
    out[35] = PWD_S_STATE;
    out[36] = PWD_S_BLINK;
    out[37] = PWD_S_CORRECT;
    out[38] = PWD_S_DEADLINE;
    out[39] = PWD_S_RECT_BG;
    out[40] = PWD_S_RECT_F1;
    out[41] = PWD_S_RECT_F2;
    out[42] = (int32_t)sizeof(PwdOp);
    out[43] = (int32_t)sizeof(PwdRenderResult);
}

void p76o_clear_logs(void *h)
{
    Oracle *o = h;
    o->nobs = o->nhost = 0;
    o->overflow = 0;
    o->host_calls = 0;
}

void p76o_set_fail(void *h, int n)
{
    ((Oracle *)h)->fail_at = n;
}

void p76o_set_view(void *h, int32_t x, int32_t y)
{
    Oracle *o = h;
    o->view_x = x;
    o->view_y = y;
}

void p76o_set_width(void *h, int32_t k, int32_t add)
{
    Oracle *o = h;
    o->width_k = k;
    o->width_add = add;
}

int32_t p76o_width_of(void *h, int32_t font, const char *text)
{
    return width_of(h, (int16_t)font, text);
}

void p76o_set_ticks(void *h, const int64_t *v, int n)
{
    Oracle *o = h;
    o->tick_n = n > QMAX ? QMAX : n;
    memcpy(o->tick_q, v, sizeof(int64_t) * (size_t)o->tick_n);
    o->tick_i = 0;
    o->tick_under = 0;
}

void p76o_set_busy(void *h, const int64_t *v, int n)
{
    Oracle *o = h;
    o->busy_n = n > QMAX ? QMAX : n;
    memcpy(o->busy_q, v, sizeof(int64_t) * (size_t)o->busy_n);
    o->busy_i = 0;
    o->busy_under = 0;
}

/* out: tick position, tick underflow, busy position, busy underflow, overflow, error counts (3) */
void p76o_queues(void *h, int32_t *out)
{
    Oracle *o = h;
    out[0] = o->tick_i;
    out[1] = o->tick_under;
    out[2] = o->busy_i;
    out[3] = o->busy_under;
    out[4] = o->overflow;
    out[5] = o->errors[0];
    out[6] = o->errors[1];
    out[7] = o->errors[2];
}

void p76o_state_get(void *h, uint8_t *out)
{
    memcpy(out, ((Oracle *)h)->st.b, PWD_STATE_BYTES);
}

void p76o_state_set(void *h, const uint8_t *in)
{
    memcpy(((Oracle *)h)->st.b, in, PWD_STATE_BYTES);
}

/* cells: mode, start flag, entry flag, xfer[7] */
void p76o_cells_get(void *h, int32_t *out)
{
    Oracle *o = h;
    out[0] = o->mode;
    out[1] = o->start_flag;
    out[2] = o->entry_flag;
    memcpy(out + 3, o->xfer, sizeof o->xfer);
}

void p76o_cells_set(void *h, const int32_t *in)
{
    Oracle *o = h;
    o->mode = in[0];
    o->start_flag = in[1];
    o->entry_flag = in[2];
    memcpy(o->xfer, in + 3, sizeof o->xfer);
}

void p76o_events_get(void *h, int32_t *out)
{
    memcpy(out, ((Oracle *)h)->events, sizeof(int32_t) * EVENT_COUNT);
}

void p76o_events_set(void *h, const int32_t *in)
{
    memcpy(((Oracle *)h)->events, in, sizeof(int32_t) * EVENT_COUNT);
}

/* which: 0 observer log, 1 host log. Returns the count, -1 on overflow. */
int p76o_log(void *h, int which, int32_t *out, int max)
{
    Oracle *o = h;
    const Triple *t = which == 0 ? o->obs : o->host;
    int n = which == 0 ? o->nobs : o->nhost;
    int i;
    if (o->overflow || n > max) return -1;
    for (i = 0; i < n; ++i) {
        out[3 * i] = t[i].kind;
        out[3 * i + 1] = t[i].a;
        out[3 * i + 2] = t[i].b;
    }
    return n;
}

/* out: status, phase_after, initialized, completed. no_observer != 0 leaves PwdHost.observe NULL (production may). */
void p76o_step_ex(void *h, const uint8_t *body, int length, int row, uint32_t phase, int no_observer, int32_t *out)
{
    Oracle *o = h;
    PwdHost host = make_host(o);
    if (no_observer) host.observe = NULL;
    PwdResult res;
    const char *failure = NULL;
    o->body = body;
    o->body_len = (size_t)length;
    out[0] = pwd_step(&o->st, body, (size_t)length, (int16_t)row, phase, &host, &res, &failure);
    out[1] = (int32_t)res.phase_after;
    out[2] = res.initialized;
    out[3] = res.completed;
    o->body = NULL;
}

void p76o_step(void *h, const uint8_t *body, int length, int row, uint32_t phase, int32_t *out)
{
    p76o_step_ex(h, body, length, row, phase, 0, out);
}

/* mode bit 0: no observer; bit 1: pass a failure pointer. out[4] = 1 when *failure was set to a string (copied to buf, 96 bytes). */
void p76o_step_msg(void *h, const uint8_t *body, int length, int row, uint32_t phase, int mode, char *buf, int32_t *out)
{
    Oracle *o = h;
    PwdHost host = make_host(o);
    PwdResult res;
    const char *failure = (const char *)0x1; /* a stale value: the kernel must set it to NULL or a string */
    int rc;
    if (mode & 1) host.observe = NULL;
    o->body = body;
    o->body_len = (size_t)length;
    rc = pwd_step(&o->st, body, (size_t)length, (int16_t)row, phase, &host, &res, (mode & 2) ? &failure : NULL);
    out[0] = rc;
    out[4] = 0;
    buf[0] = 0;
    if (mode & 2) {
        if (failure == (const char *)0x1) {
            out[4] = -1;
        } else if (failure != NULL) {
            out[4] = 1;
            strncpy(buf, failure, 95);
            buf[95] = 0;
        }
    }
    o->body = NULL;
}

int p76o_validate_msg(const uint8_t *body, int length, int mode, char *buf)
{
    const char *failure = (const char *)0x1;
    int rc = pwd_validate_body(body, (size_t)length, (mode & 2) ? &failure : NULL);
    buf[0] = 0;
    if ((mode & 2) && failure != NULL && failure != (const char *)0x1) {
        strncpy(buf, failure, 95);
        buf[95] = 0;
    }
    if ((mode & 2) && failure == (const char *)0x1) buf[0] = '?';
    return rc;
}

/* The argument guards: every NULL pointer and every missing host callback of pwd_step must give PWD_ERR_ARGUMENT before any effect;
 * the other entry points must survive NULL. out[0..] = status codes (see the oracle's refusal_checks for the expected values). */
#define NULL_CALLBACK(field)                                                                                                         \
    do {                                                                                                                              \
        PwdHost part = full;                                                                                                          \
        part.field = NULL;                                                                                                            \
        out[n++] = pwd_step(&o->st, body, (size_t)length, 0, 0, &part, &res, NULL);                                                   \
    } while (0)
void p76o_null_checks(void *h, const uint8_t *body, int length, int32_t *out)
{
    Oracle *o = h;
    PwdHost full = make_host(o);
    PwdResult res;
    PwdPointerResult pr;
    PwdClickResult cr;
    PwdRenderResult rr;
    int n = 0;
    out[n++] = pwd_step(NULL, body, (size_t)length, 0, 0, &full, &res, NULL);
    out[n++] = pwd_step(&o->st, NULL, (size_t)length, 0, 0, &full, &res, NULL);
    out[n++] = pwd_step(&o->st, body, (size_t)length, 0, 0, NULL, &res, NULL);
    out[n++] = pwd_step(&o->st, body, (size_t)length, 0, 0, &full, NULL, NULL);
    NULL_CALLBACK(view_origin);
    NULL_CALLBACK(font_acquire);
    NULL_CALLBACK(font_release);
    NULL_CALLBACK(text_width);
    NULL_CALLBACK(tick);
    NULL_CALLBACK(sound_prepare);
    NULL_CALLBACK(sound_stop);
    NULL_CALLBACK(sound_play);
    NULL_CALLBACK(sound_busy);
    NULL_CALLBACK(event_flag_invalid);
    NULL_CALLBACK(transition);
    NULL_CALLBACK(store_event_flag);
    out[n++] = pwd_pointer(NULL, body, (size_t)length, 0, 0, &pr);
    out[n++] = pwd_pointer(&o->st, NULL, (size_t)length, 0, 0, &pr);
    out[n++] = pwd_pointer(&o->st, body, (size_t)length, 0, 0, NULL);
    out[n++] = pwd_click(NULL, 0, &cr);
    out[n++] = pwd_click(&o->st, 0, NULL);
    out[n++] = pwd_render(NULL, body, (size_t)length, &rr);
    out[n++] = pwd_render(&o->st, NULL, (size_t)length, &rr);
    out[n++] = pwd_render(&o->st, body, (size_t)length, NULL);
    out[n++] = pwd_key(NULL, 'a');
    out[n++] = pwd_invalidate(NULL);
    pwd_cleanup(NULL);
    pwd_new_game(NULL);
    pwd_state_reset(NULL);
    out[n++] = pwd_validate_body(NULL, (size_t)length, NULL);
}

int p76o_key(void *h, int ch)
{
    return pwd_key(&((Oracle *)h)->st, (int8_t)ch);
}

int p76o_key_filter(int ch)
{
    return pwd_char_accepted((int8_t)ch);
}

/* out: status, hit, candidate, cursor kind */
void p76o_pointer(void *h, const uint8_t *body, int length, int32_t x, int32_t y, int32_t *out)
{
    Oracle *o = h;
    PwdPointerResult r;
    memset(&r, 0xA5, sizeof r); /* the kernel must set every field */
    out[0] = pwd_pointer(&o->st, body, (size_t)length, x, y, &r);
    out[1] = r.hit;
    out[2] = r.candidate;
    out[3] = r.cursor_kind;
}

/* out: status, fired, row, phase */
void p76o_click(void *h, int32_t candidate, int32_t *out)
{
    Oracle *o = h;
    PwdClickResult r;
    out[0] = pwd_click(&o->st, candidate, &r);
    out[1] = r.fired;
    out[2] = r.row;
    out[3] = (int32_t)r.phase;
}

/* The invalidate / cleanup / new game blocks, with their effect on the entry flag cell. */
int p76o_invalidate(void *h)
{
    Oracle *o = h;
    int r = pwd_invalidate(&o->st);
    if (r) o->entry_flag = 1;
    return r;
}

void p76o_cleanup(void *h)
{
    Oracle *o = h;
    pwd_cleanup(&o->st);
    o->entry_flag = 0;
}

void p76o_new_game(void *h)
{
    pwd_new_game(&((Oracle *)h)->st);
}

int p76o_validate(const uint8_t *body, int length)
{
    return pwd_validate_body(body, (size_t)length, NULL);
}

/* out: status, count, then per op 14 ints (kind, src[4], dst[4], font, x, y, field, 2 spare) ; texts: 3 x 34 bytes */
void p76o_render(void *h, const uint8_t *body, int length, int32_t *out, char *texts)
{
    Oracle *o = h;
    PwdRenderResult r;
    int i, k;
    memset(&r, 0xA5, sizeof r); /* stale bytes: the kernel must clear the whole result itself */
    out[0] = pwd_render(&o->st, body, (size_t)length, &r);
    out[1] = r.count;
    for (i = 0; i < PWD_MAX_OPS; ++i) {
        int32_t *p = out + 2 + 14 * i;
        const PwdOp *op = &r.op[i];
        p[0] = op->kind;
        for (k = 0; k < 4; ++k) {
            p[1 + k] = op->src[k];
            p[5 + k] = op->dst[k];
        }
        p[9] = op->font;
        p[10] = op->x;
        p[11] = op->y;
        p[12] = op->field;
        {
            const unsigned char *raw = (const unsigned char *)op;
            size_t z;
            p[13] = 1;                      /* 1: every byte of this op is zero */
            for (z = 0; z < sizeof *op; ++z) {
                if (raw[z] != 0) p[13] = 0;
            }
        }
        memcpy(texts + 34 * i, op->text, PWD_TEXT_BYTES + 1);
    }
}
