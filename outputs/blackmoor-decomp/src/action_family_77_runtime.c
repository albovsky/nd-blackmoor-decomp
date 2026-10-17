#include "action_family_77_runtime.h"

#include <string.h>

/* Body offsets (see the header). */
enum {
    B_NAME_BYTES = 0x21,
    B_COUNT = 0x21,
    B_SELECTED_SRC = 0x23,
    B_BUTTON_RECT = 0x123,
    B_SOLUTION_LEN = 0x223,
    B_SOLUTION = 0x225,
    B_SOUND_A = 0x235,
    B_CLICK_CHANNEL = 0x256,
    B_SOLVED_BLOCK = 0x266,
    B_SOLVED_START = 0x27a,
    B_EVENT_FLAG = 0x27c,
    B_EVENT_VALUE = 0x27e,
    B_DELAY = 0x27f,
    B_SOUND_B = 0x281,
    B_WIN_CHANNEL = 0x2a2,
    B_EXIT_BLOCK = 0x2b2,
    B_EXIT_START = 0x2c6,
    B_EXIT_FLAG = 0x2c8,
    B_EXIT_VALUE = 0x2ca,
    B_EXIT_RECT = 0x2cb
};

/* Offsets inside a scene block (solved block at 0x266, exit block at 0x2b2). */
enum { SB_SCENE = 0, SB_W1 = 2, SB_W2 = 4, SB_W3 = 6, SB_D1 = 8, SB_D2 = 12, SB_D3 = 16 };

static int16_t rd_s16(const uint8_t *b, size_t off)
{
    return (int16_t)(uint16_t)(b[off] | (b[off + 1] << 8));
}

static int32_t rd_s32(const uint8_t *b, size_t off)
{
    return (int32_t)((uint32_t)b[off] | ((uint32_t)b[off + 1] << 8) | ((uint32_t)b[off + 2] << 16) |
                     ((uint32_t)b[off + 3] << 24));
}

static void fx(const A77Host *host, int effect, int32_t a, int32_t b)
{
    if (host->observe != NULL) host->observe(host->context, effect, a, b);
}

/* The 9-byte comparison against "NO SOUND\0" (repe cmpsb with ecx = 9). */
static int no_sound(const uint8_t *name)
{
    static const uint8_t k[9] = {'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0};
    return memcmp(name, k, sizeof k) == 0;
}

#define HOST(call) do { if ((call) != 0) { return A77_ERR_HOST; } } while (0)

void a77_state_reset(A77State *state)
{
    if (state != NULL) memset(state, 0, sizeof(*state));
}

int a77_validate_body(const uint8_t *body, size_t length, const char **failure)
{
    const char *why = NULL;
    int16_t n, l;
    if (body == NULL || length != A77_BODY_BYTES) {
        why = "0x77-body-length";
    } else if (memchr(body, 0, B_NAME_BYTES) == NULL) {
        why = "0x77-name-unterminated";
    } else if ((n = rd_s16(body, B_COUNT)) < 0 || n > A77_MAX_BUTTONS) {
        why = "0x77-button-count";
    } else if ((l = rd_s16(body, B_SOLUTION_LEN)) < 0 || l > A77_MAX_BUTTONS) {
        why = "0x77-solution-length";
    }
    if (failure != NULL) *failure = why;
    return why == NULL ? A77_OK : A77_ERR_BODY;
}

/* The two 16-entry clears of phase 0 and of the unsolved reset in phase 1: byte 0x5b5128+i := 0, word 0x5b5138+2i := 0xffff. */
static void clear_selection(A77State *s)
{
    for (int i = 0; i < A77_MAX_BUTTONS; ++i) {
        s->selected[i] = 0u;
        s->order[i] = -1;
    }
}

/* The scene block shared by the solved and exit paths of phase 2. The transition host call carries the seven cells and the
 * engine mode as one request; the effects follow in the original order. */
static int apply_block(const uint8_t *blk, int16_t start_word, A77World *world, const A77Host *host)
{
    A77Transition t;
    if (rd_s16(blk, SB_SCENE) == A77_NO_SCENE) return A77_OK;
    t.scene = rd_s16(blk, SB_SCENE);
    t.word[0] = rd_s16(blk, SB_W1);
    t.word[1] = rd_s16(blk, SB_W2);
    t.word[2] = rd_s16(blk, SB_W3);
    t.dword[0] = rd_s32(blk, SB_D1);
    t.dword[1] = rd_s32(blk, SB_D2);
    t.dword[2] = rd_s32(blk, SB_D3);
    HOST(host->transition(host->context, &t));
    fx(host, A77_FX_XFER_5BB57B, t.scene, 0);
    fx(host, A77_FX_XFER_5BB599, t.word[0], 0);
    fx(host, A77_FX_XFER_5BB595, t.word[1], 0);
    fx(host, A77_FX_XFER_5C39FF, t.word[2], 0);
    fx(host, A77_FX_XFER_5BB59B, t.dword[0], 0);
    fx(host, A77_FX_XFER_5BB59F, t.dword[1], 0);
    fx(host, A77_FX_XFER_5BB5A3, t.dword[2], 0);
    world->start_flag_5bb1ca = start_word == 1 ? 0 : 1;
    fx(host, A77_FX_START_FLAG, world->start_flag_5bb1ca, 0);
    fx(host, A77_FX_ENGINE_MODE, 4, 0);
    return A77_OK;
}

/* 0x4c2dfb(&0x5d03cf) as phase 0 and phase 2 call it: unconditional, the handle held (possibly 0) is reported. */
static int release_held(A77State *s, const A77Host *host)
{
    const uint32_t held = s->surface;
    HOST(host->release_surface(host->context, held));
    s->surface = 0u;
    fx(host, A77_FX_RELEASE_SURFACE, (int32_t)held, 0);
    return A77_OK;
}

static int phase0(A77State *s, const uint8_t *body, int16_t row, A77World *world, const A77Host *host)
{
    const int16_t n = rd_s16(body, B_COUNT);
    const int16_t l = rd_s16(body, B_SOLUTION_LEN);
    int32_t raw;
    int16_t r, limit;
    s->active = 1u;
    fx(host, A77_FX_ACTIVE, 1, 0);
    s->solved = 0u;
    world->start_flag_5bb1ca = 1;
    fx(host, A77_FX_START_FLAG, 1, 0);
    s->row = row;
    s->exit_requested = 0u;
    raw = host->random(host->context);
    fx(host, A77_FX_RANDOM, raw, 0);
    r = (int16_t)(raw % 5); /* signed idiv; the remainder is stored as a word */
    if (r == 0 || r == 1) r = 2;
    limit = (int16_t)(uint16_t)((uint16_t)l + (uint16_t)r);
    if (limit > n) limit = n;
    s->limit = limit;
    clear_selection(s);
    s->count = 0;
    {
        const int rc = release_held(s, host);
        if (rc != A77_OK) return rc;
    }
    {
        uint32_t surface = 0u;
        HOST(host->load_surface(host->context, (const char *)body, &surface));
        s->surface = surface;
        fx(host, A77_FX_SURFACE_LOAD, (int32_t)surface, 0);
        s->overlay_surface = surface;
        fx(host, A77_FX_OVERLAY_SURFACE, (int32_t)surface, 0);
        s->overlay_active = 1u;
        fx(host, A77_FX_OVERLAY_ACTIVE, 1, 0);
    }
    if (!no_sound(body + B_SOUND_A)) {
        HOST(host->sound_prepare(host->context, body + B_SOUND_A));
        fx(host, A77_FX_SOUND_PREPARE, B_SOUND_A, 0);
    }
    s->step = 0u;
    fx(host, A77_FX_STEP, 0, 0);
    s->initialized = 1u;
    return A77_OK;
}

static int phase1(A77State *s, const uint8_t *body, uint32_t *row_phase, const A77Host *host)
{
    switch (s->step) {
    case 0: {
        const int16_t l = rd_s16(body, B_SOLUTION_LEN);
        s->solved = 1u;
        for (int16_t i = 0; i < l; ++i) {
            if (s->order[i] != (int16_t)body[B_SOLUTION + (size_t)i]) {
                s->solved = 0u;
                break;
            }
        }
        if (s->solved != 0u) {
            s->step = 1u;
            fx(host, A77_FX_STEP, 1, 0);
        } else if (s->count >= s->limit) {
            clear_selection(s);
            s->count = 0;
        }
        break;
    }
    case 1: {
        const int16_t flag = rd_s16(body, B_EVENT_FLAG);
        uint32_t now;
        if (flag != A77_NO_FLAG) {
            HOST(host->store_event_flag(host->context, flag, body[B_EVENT_VALUE]));
            fx(host, A77_FX_EVENT_FLAG, flag, body[B_EVENT_VALUE]);
        }
        now = host->tick(host->context);
        fx(host, A77_FX_TICK, (int32_t)now, 0);
        s->deadline = now + (uint32_t)((int32_t)rd_s16(body, B_DELAY) * 1000);
        s->step = 2u;
        fx(host, A77_FX_STEP, 2, 0);
        break;
    }
    case 2: {
        const uint32_t now = host->tick(host->context);
        fx(host, A77_FX_TICK, (int32_t)now, 0);
        if (now >= s->deadline) {
            if (!no_sound(body + B_SOUND_B)) {
                const int16_t ch = rd_s16(body, B_WIN_CHANNEL);
                HOST(host->sound_prepare(host->context, body + B_SOUND_B));
                fx(host, A77_FX_SOUND_PREPARE, B_SOUND_B, 0);
                HOST(host->sound_play(host->context, ch));
                fx(host, A77_FX_SOUND_PLAY, ch, 0);
                s->step = 3u;
                fx(host, A77_FX_STEP, 3, 0);
            } else {
                *row_phase = 2u;
                fx(host, A77_FX_PHASE, 2, 0);
            }
        }
        break;
    }
    case 3: {
        const int16_t ch = rd_s16(body, B_WIN_CHANNEL);
        int32_t busy = 0;
        HOST(host->sound_busy(host->context, ch, &busy));
        fx(host, A77_FX_SOUND_BUSY, ch, busy);
        if (busy == 0) {
            HOST(host->sound_stop(host->context, body + B_SOUND_B));
            fx(host, A77_FX_SOUND_STOP, B_SOUND_B, 0);
            *row_phase = 2u;
            fx(host, A77_FX_PHASE, 2, 0);
        }
        break;
    }
    default:
        break; /* the jump table at 0x42f500 has four entries; anything above does nothing */
    }
    return A77_OK;
}

static int phase2(A77State *s, const uint8_t *body, A77World *world, const A77Host *host)
{
    world->start_flag_5bb1ca = 1;
    fx(host, A77_FX_START_FLAG, 1, 0);
    s->active = 0u;
    fx(host, A77_FX_ACTIVE, 0, 0);
    {
        const int rc = release_held(s, host);
        if (rc != A77_OK) return rc;
    }
    s->overlay_active = 0u; /* overlay_surface keeps the stale handle */
    fx(host, A77_FX_OVERLAY_ACTIVE, 0, 0);
    if (!no_sound(body + B_SOUND_A)) {
        HOST(host->sound_stop(host->context, body + B_SOUND_A));
        fx(host, A77_FX_SOUND_STOP, B_SOUND_A, 0);
    }
    if (s->exit_requested != 0u) {
        const int rc = apply_block(body + B_EXIT_BLOCK, rd_s16(body, B_EXIT_START), world, host);
        if (rc != A77_OK) return rc;
        {
            const int16_t flag = rd_s16(body, B_EXIT_FLAG);
            if (flag != A77_NO_FLAG) {
                HOST(host->store_event_flag(host->context, flag, body[B_EXIT_VALUE]));
                fx(host, A77_FX_EVENT_FLAG, flag, body[B_EXIT_VALUE]);
            }
        }
    } else {
        const int rc = apply_block(body + B_SOLVED_BLOCK, rd_s16(body, B_SOLVED_START), world, host);
        if (rc != A77_OK) return rc;
    }
    return A77_OK;
}

static int step_host_complete(const A77Host *host)
{
    return host != NULL && host->random != NULL && host->load_surface != NULL && host->release_surface != NULL &&
           host->sound_prepare != NULL && host->sound_stop != NULL && host->sound_play != NULL &&
           host->sound_busy != NULL && host->tick != NULL && host->event_flag_invalid != NULL &&
           host->transition != NULL && host->store_event_flag != NULL;
}

int a77_step(A77State *state, const uint8_t *body, size_t body_length, int16_t row, uint32_t phase, A77World *world,
             const A77Host *host, A77Result *result, const char **failure)
{
    const char *why = NULL;
    uint32_t row_phase = phase;
    int rc;
    if (failure != NULL) *failure = NULL;
    if (state == NULL || body == NULL || world == NULL || result == NULL || !step_host_complete(host)) {
        if (failure != NULL) *failure = "0x77-argument";
        return A77_ERR_ARGUMENT;
    }
    memset(result, 0, sizeof(*result));
    result->phase_after = phase;
    if (a77_validate_body(body, body_length, &why) != A77_OK) {
        if (failure != NULL) *failure = why;
        return A77_ERR_BODY;
    }
    if (phase == 0u) {
        if (row < 0) {
            if (failure != NULL) *failure = "0x77-row";
            return A77_ERR_ARGUMENT;
        }
        rc = phase0(state, body, row, world, host);
        if (rc == A77_OK) {
            row_phase = 1u;
            fx(host, A77_FX_PHASE, 1, 0);
            result->initialized = 1u;
        }
    } else if (phase == 1u || phase == 2u) {
        int16_t flag = A77_NO_FLAG;
        if (state->initialized == 0u || state->row != row) {
            if (failure != NULL) *failure = phase == 1u ? "0x77-phase-1-without-init" : "0x77-phase-2-without-init";
            return A77_ERR_UNSUPPORTED;
        }
        /* Refuse before any effect when the visit would store an event flag the host cannot hold. */
        if (phase == 1u && state->step == 1u)
            flag = rd_s16(body, B_EVENT_FLAG);
        else if (phase == 2u && state->exit_requested != 0u)
            flag = rd_s16(body, B_EXIT_FLAG);
        if (flag != A77_NO_FLAG && host->event_flag_invalid(host->context, flag) != 0) {
            if (failure != NULL) *failure = "0x77-event-flag-index";
            return A77_ERR_BOUNDS;
        }
        if (phase == 1u) {
            rc = phase1(state, body, &row_phase, host);
        } else {
            rc = phase2(state, body, world, host);
            if (rc == A77_OK) {
                fx(host, A77_FX_COMPLETE, row, 0);
                result->completed = 1u;
                row_phase = 0u; /* 0x42ba3a stores phase 0 */
            }
        }
    } else {
        rc = A77_OK; /* any other phase falls out of the switch */
    }
    if (rc != A77_OK && failure != NULL && *failure == NULL) *failure = "0x77-host";
    result->phase_after = row_phase;
    return rc;
}

static int in_rect(const uint8_t *body, size_t rect, int32_t x, int32_t y)
{
    return rd_s32(body, rect + 4) <= y && y <= rd_s32(body, rect + 12) && rd_s32(body, rect) <= x &&
           x <= rd_s32(body, rect + 8);
}

int a77_pointer(A77State *state, const uint8_t *body, size_t body_length, int32_t x, int32_t y, A77PointerResult *out)
{
    int16_t n;
    if (state == NULL || body == NULL || out == NULL || a77_validate_body(body, body_length, NULL) != A77_OK)
        return A77_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    out->candidate = -1;
    out->hover = -1;
    if (state->active == 0u) return A77_OK;
    n = rd_s16(body, B_COUNT);
    for (int16_t i = 0; i < n; ++i) {
        if (in_rect(body, B_BUTTON_RECT + (size_t)i * 16u, x, y)) {
            state->hover = i; /* word 0x5b515b */
            out->hit = 1u;
            out->candidate = A77_CANDIDATE_BUTTON;
            out->hover = i;
            out->cursor_sub = 1u;
            return A77_OK;
        }
    }
    if (in_rect(body, B_EXIT_RECT, x, y)) {
        out->hit = 1u;
        out->candidate = A77_CANDIDATE_EXIT;
        out->cursor_kind = A77_CURSOR_EXIT;
    }
    return A77_OK;
}

int a77_click(A77State *state, const uint8_t *body, size_t body_length, uint32_t row_phase, int32_t candidate,
              int32_t start_flag, const A77Host *host, A77ClickResult *out)
{
    int16_t n;
    if (state == NULL || body == NULL || out == NULL || host == NULL ||
        a77_validate_body(body, body_length, NULL) != A77_OK)
        return A77_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    out->new_phase = row_phase;
    if (state->active == 0u || state->solved != 0u) return A77_OK;
    n = rd_s16(body, B_COUNT);
    if (candidate == A77_CANDIDATE_BUTTON) {
        const int16_t h = state->hover;
        const int want_sound = start_flag != 0 && !no_sound(body + B_SOUND_A);
        if (h < 0 || h >= n || state->count < 0 || state->count > A77_MAX_BUTTONS) return A77_ERR_BOUNDS;
        if (want_sound && host->sound_play == NULL) return A77_ERR_ARGUMENT;
        if (state->selected[h] != 0u) {
            int16_t t = (int16_t)(state->count - 1);
            state->selected[h] = 0u;
            if (t < 0) t = 0;
            if (state->order[t] == h) {
                state->count = (int16_t)(state->count - 1);
                if (state->count < 0) state->count = 0;
                state->order[state->count] = -1;
            }
        } else {
            state->selected[h] = 1u;
            if (state->count <= n - 1) state->order[state->count] = h;
            state->count = (int16_t)(state->count + 1);
            if (state->count > n) state->count = n;
        }
        out->toggled = 1u;
        if (want_sound) {
            const int16_t ch = rd_s16(body, B_CLICK_CHANNEL);
            out->click_sound = 1u;
            HOST(host->sound_play(host->context, ch));
            fx(host, A77_FX_SOUND_PLAY, ch, 0);
        }
    } else if (candidate == A77_CANDIDATE_EXIT) {
        state->exit_requested = 1u;
        out->exit_asked = 1u;
        out->new_phase = 2u;
        fx(host, A77_FX_PHASE, 2, 0);
    }
    return A77_OK;
}

int a77_clear(A77State *state, const A77Host *host)
{
    if (state == NULL || host == NULL || (state->surface != 0u && host->release_surface == NULL))
        return A77_ERR_ARGUMENT;
    state->active = 0u;
    fx(host, A77_FX_ACTIVE, 0, 0);
    state->overlay_active = 0u;
    fx(host, A77_FX_OVERLAY_ACTIVE, 0, 0);
    state->initialized = 0u; /* native only: the scene's rows are gone, the next visit starts at phase 0 */
    if (state->surface != 0u) {
        const uint32_t held = state->surface;
        HOST(host->release_surface(host->context, held));
        state->surface = 0u;
        fx(host, A77_FX_RELEASE_SURFACE, (int32_t)held, 0);
    }
    return A77_OK;
}

int a77_render_plan(const A77State *state, const uint8_t *body, size_t body_length, const A77Host *host, A77RenderPlan *plan)
{
    int32_t vx = 0, vy = 0;
    int16_t n;
    if (state == NULL || body == NULL || plan == NULL || host == NULL || host->view_origin == NULL ||
        a77_validate_body(body, body_length, NULL) != A77_OK)
        return A77_ERR_ARGUMENT;
    memset(plan, 0, sizeof(*plan));
    if (state->overlay_active == 0u) return A77_OK;
    if (host->view_origin(host->context, &vx, &vy) != 0) return A77_ERR_HOST;
    n = rd_s16(body, B_COUNT);
    plan->valid = 1u;
    plan->surface = state->overlay_surface;
    plan->count = n;
    for (int16_t i = 0; i < n; ++i) {
        const size_t rect = B_BUTTON_RECT + (size_t)i * 16u;
        A77RenderBlit *b = &plan->blit[i];
        b->dst[0] = (int32_t)((uint32_t)rd_s32(body, rect) + (uint32_t)vx);
        b->dst[1] = (int32_t)((uint32_t)rd_s32(body, rect + 4) + (uint32_t)vy);
        b->dst[2] = (int32_t)((uint32_t)rd_s32(body, rect + 8) + (uint32_t)vx);
        b->dst[3] = (int32_t)((uint32_t)rd_s32(body, rect + 12) + (uint32_t)vy);
        b->selected = state->selected[i] != 0u ? 1u : 0u;
        {
            const size_t src = b->selected != 0u ? B_SELECTED_SRC + (size_t)i * 16u : rect;
            for (int k = 0; k < 4; ++k) b->src[k] = rd_s32(body, src + (size_t)k * 4u);
        }
    }
    return A77_OK;
}
