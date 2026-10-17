#include "action_family_33_runtime.h"

#include <stdlib.h>
#include <string.h>

/* Reconstruction of the observed behaviour of GAME.EXE 0x42c221 and its pure callees (see the header), not original C++ or
 * compiler provenance. */

#define BODY_FIXED 0x71u
#define BODY_ENTRY 6u
#define BODY_HOTSPOT 0x42u

static int16_t rd16(const uint8_t *p)
{
    return (int16_t)(uint16_t)((unsigned)p[0] | ((unsigned)p[1] << 8));
}

static int32_t rd32(const uint8_t *p)
{
    return (int32_t)((uint32_t)p[0] | ((uint32_t)p[1] << 8) | ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24));
}

static int name_ok(const uint8_t *p, char *dst)
{
    size_t n = 0u;
    while (n < A33_NAME_BYTES && p[n] != 0u) {
        ++n;
    }
    if (n == A33_NAME_BYTES) {
        return 0;
    }
    memset(dst, 0, A33_NAME_BYTES);
    memcpy(dst, p, n);
    return 1;
}

int a33_set_parse(const uint8_t *body, size_t length, A33Set *out, const char **why)
{
    A33Set set;
    size_t need;
    const char *reason = "0x33-body";
    if (out == NULL) {
        return A33_ERR_ARGUMENT;
    }
    memset(out, 0, sizeof(*out));
    if (body == NULL || length < BODY_FIXED) {
        reason = "0x33-body-too-short";
        goto bad;
    }
    memset(&set, 0, sizeof(set));
    set.entry_count = rd16(body + 0x6d);
    set.hotspot_count = rd16(body + 0x6f);
    if (set.entry_count < 0 || set.hotspot_count < 0) {
        reason = "0x33-negative-count";
        goto bad;
    }
    need = BODY_FIXED + (size_t)set.entry_count * BODY_ENTRY + (size_t)set.hotspot_count * BODY_HOTSPOT;
    if (length < need) {
        reason = "0x33-body-shorter-than-counts";
        goto bad;
    }
    if (!name_ok(body, set.clip) || !name_ok(body + 0x21, set.overlay)) {
        reason = "0x33-name-without-terminator";
        goto bad;
    }
    set.w42 = rd16(body + 0x42);
    set.w44 = rd16(body + 0x44);
    set.kind_46 = rd16(body + 0x46);
    set.anim_48 = rd16(body + 0x48);
    set.w4a = rd16(body + 0x4a);
    set.w4c = rd16(body + 0x4c);
    set.w4e = rd16(body + 0x4e);
    set.w50 = rd16(body + 0x50);
    set.w52 = rd16(body + 0x52);
    set.w54 = rd16(body + 0x54);
    set.w56 = rd16(body + 0x56);
    set.scene_58 = rd16(body + 0x58);
    set.w5a = rd16(body + 0x5a);
    set.w5c = rd16(body + 0x5c);
    set.w5e = rd16(body + 0x5e);
    set.d60 = rd32(body + 0x60);
    set.d64 = rd32(body + 0x64);
    set.d68 = rd32(body + 0x68);
    set.push_6c = body[0x6c];
    if (set.entry_count > 0) {
        set.entries = (A33Entry *)calloc((size_t)set.entry_count, sizeof(A33Entry));
    }
    if (set.hotspot_count > 0) {
        set.hotspots = (A33Hotspot *)calloc((size_t)set.hotspot_count, sizeof(A33Hotspot));
    }
    if ((set.entry_count > 0 && set.entries == NULL) || (set.hotspot_count > 0 && set.hotspots == NULL)) {
        a33_set_free(&set);
        reason = "0x33-allocation";
        goto bad;
    }
    for (int16_t i = 0; i < set.entry_count; ++i) {
        const uint8_t *e = body + BODY_FIXED + (size_t)i * BODY_ENTRY;
        set.entries[i].key = rd16(e);
        set.entries[i].index = rd16(e + 2);
        set.entries[i].value = rd16(e + 4);
    }
    for (int16_t i = 0; i < set.hotspot_count; ++i) {
        const uint8_t *h = body + BODY_FIXED + (size_t)set.entry_count * BODY_ENTRY + (size_t)i * BODY_HOTSPOT;
        set.hotspots[i].key = rd16(h);
        for (int k = 0; k < 4; ++k) {
            set.hotspots[i].src1[k] = rd32(h + 2 + 4 * k);
            set.hotspots[i].dst1[k] = rd32(h + 0x12 + 4 * k);
            set.hotspots[i].src2[k] = rd32(h + 0x22 + 4 * k);
            set.hotspots[i].dst2[k] = rd32(h + 0x32 + 4 * k);
        }
    }
    *out = set;
    return A33_OK;
bad:
    if (why != NULL) {
        *why = reason;
    }
    return A33_ERR_BODY;
}

void a33_set_free(A33Set *set)
{
    if (set == NULL) {
        return;
    }
    free(set->entries);
    free(set->hotspots);
    memset(set, 0, sizeof(*set));
}

void a33_state_init(A33State *state)
{
    if (state != NULL) {
        memset(state, 0, sizeof(*state));
    }
}

static int call_op(const A33Host *host, int op, int32_t a, int32_t b, int32_t *ret)
{
    A33OpArgs args;
    int32_t scratch = 0;
    args.a = a;
    args.b = b;
    return host->op(host->context, op, &args, ret != NULL ? ret : &scratch) != 0 ? A33_ERR_HOST : A33_OK;
}

#define OP(host, op, a, b, ret)                                \
    do {                                                       \
        int op_status_ = call_op((host), (op), (a), (b), (ret)); \
        if (op_status_ != A33_OK) {                            \
            return op_status_;                                 \
        }                                                      \
    } while (0)

static void copy_name(char *dst, const char *src)
{
    memcpy(dst, src, strlen(src) + 1u);
}

static uint32_t add32(uint32_t a, uint32_t b)
{
    return a + b;
}

static int32_t sub32(int32_t a, int32_t b)
{
    return (int32_t)((uint32_t)a - (uint32_t)b);
}

static int32_t addi32(int32_t a, int32_t b)
{
    return (int32_t)((uint32_t)a + (uint32_t)b);
}

/* 0x42ca22 */
static int event_flags(A33State *st, const A33Set *set, const A33Host *host)
{
    if (st->has_entries_5b4ea5 == 0 || set->entry_count == 0) {
        return A33_OK;
    }
    for (int32_t i = 0; i < set->entry_count; ++i) {
        const A33Entry *e = &set->entries[i];
        if (e->index != -1 && e->key == st->frame_5b4e00) {
            OP(host, A33_OP_EVENT_FLAG, e->index, e->value, NULL);
        }
    }
    return A33_OK;
}

/* 0x42e72c */
static int page_flip(A33State *st, const A33Host *host)
{
    if (st->surface_5d03bf == 0u) {
        return A33_OK;
    }
    OP(host, A33_OP_STREAM_LOCK, 0, 0, NULL);
    st->page_5b4dc8 = st->page_5b4dc8 != 0 ? 0 : 1;
    if (st->present_5b4e04 == 2) {
        OP(host, A33_OP_SURFACE_PIXELS, (int32_t)st->surface_5d03bf,
           (int32_t)(st->page_5b4dc8 != 0 ? st->buf_5b4dbc : st->buf_5b4db8), NULL);
    }
    OP(host, A33_OP_STREAM_UNLOCK, 0, 0, NULL);
    return A33_OK;
}

/* 0x42d215 */
static void frame_advance(A33State *st, const A33Set *set)
{
    switch ((uint32_t)st->anim_5b4e14) {
    case 0:
        st->frame_5b4e00 = (int16_t)(st->frame_5b4e00 + 1);
        if (st->frame_5b4e00 > set->w4e) {
            st->frame_5b4e00 = set->w4c;
        }
        break;
    case 1:
        st->frame_5b4e00 = (int16_t)(st->frame_5b4e00 + 1);
        if (st->frame_5b4e00 > set->w52) {
            st->frame_5b4e00 = set->w52;
        }
        break;
    case 2:
        st->frame_5b4e00 = (int16_t)(st->frame_5b4e00 - 1);
        if (st->frame_5b4e00 < set->w4c) {
            st->frame_5b4e00 = set->w4c;
            st->anim_5b4e14 = 0;
        }
        break;
    case 3:
        st->frame_5b4e00 = (int16_t)(st->frame_5b4e00 + 1);
        if (st->frame_5b4e00 > set->w56) {
            st->frame_5b4e00 = set->w56;
        }
        break;
    default:
        break;
    }
    if (st->anim_5b4e14 == 1 && st->latch_5c39e5 != (int32_t)st->row_5b4e89) {
        st->anim_5b4e14 = 2;
    }
}

/* The shared clip of 0x42caa8 / 0x42cecd. Rectangles are (left, top, right, bottom). `dst` is the hotspot's destination
 * rectangle, `src` its source rectangle; the outputs are the working source / destination rectangles. Returns 1 when the
 * rectangle was accepted (the latch is set by the caller), 0 when it lies outside the clip rectangle. */
static int clip_rect(const A33State *st, const int32_t *src, const int32_t *dst, const int32_t *rect, int32_t *out_src,
                     int32_t *out_dst)
{
    const int32_t top = dst[1];
    const int32_t bottom = dst[3];
    if (bottom <= rect[3] && top >= rect[1]) {
        out_src[1] = src[1];
        out_src[3] = src[3];
        out_src[0] = src[0];
        out_src[2] = src[2];
        out_dst[1] = addi32(sub32(top, rect[1]), st->view_y_58318a);
        out_dst[3] = addi32(sub32(bottom, rect[1]), st->view_y_58318a);
        out_dst[0] = addi32(dst[0], st->view_x_583186);
        out_dst[2] = addi32(dst[2], st->view_x_583186);
        return 1;
    }
    if (!((top <= rect[3] && bottom >= rect[3]) || (top <= rect[1] && bottom >= rect[1]))) {
        return 0;
    }
    {
        const int32_t cut_top = top < rect[1] ? rect[1] : top;
        const int32_t cut_bottom = bottom > rect[3] ? rect[3] : bottom;
        out_src[1] = addi32(src[1], sub32(cut_top, top));
        out_src[3] = sub32(src[3], sub32(bottom, cut_bottom));
        out_src[0] = src[0];
        out_src[2] = src[2];
        out_dst[1] = addi32(sub32(cut_top, rect[1]), st->view_y_58318a);
        out_dst[3] = addi32(sub32(cut_bottom, rect[1]), st->view_y_58318a);
        out_dst[0] = addi32(dst[0], st->view_x_583186);
        out_dst[2] = addi32(dst[2], st->view_x_583186);
    }
    return 1;
}

/* 0x42cecd: the second rectangle pair (kind 2). */
static void second_rects(A33State *st, const A33Hotspot *hs, const int32_t *rect)
{
    if (clip_rect(st, hs->src2, hs->dst2, rect, st->src2_5b4e38, st->dst2_5b4e48) != 0) {
        st->flag_5b4e8d = 1;
    }
    st->rel_dst2_5b4e93[1] = sub32(st->dst2_5b4e48[1], st->view_y_58318a);
    st->rel_dst2_5b4e93[3] = sub32(st->dst2_5b4e48[3], st->view_y_58318a);
    st->rel_dst2_5b4e93[0] = sub32(st->dst2_5b4e48[0], st->view_x_583186);
    st->rel_dst2_5b4e93[2] = sub32(st->dst2_5b4e48[2], st->view_x_583186);
}

/* 0x42caa8 */
static int hotspot_rects(A33State *st, const A33Set *set, A33Row *cells, int16_t row, int16_t index, const int32_t *rect)
{
    const A33Hotspot *hs = &set->hotspots[index];
    if (st->mode_5b4ea3 == 2) {
        if (st->row_5b4e89 != row) {
            return A33_ERR_UNSUPPORTED;
        }
        cells->request = 1;
        cells->rect[0] = (int16_t)hs->dst1[0];
        cells->rect[1] = (int16_t)hs->dst1[1];
        cells->rect[2] = (int16_t)hs->dst1[2];
        cells->rect[3] = (int16_t)hs->dst1[3];
    }
    if (clip_rect(st, hs->src1, hs->dst1, rect, st->src1_5b4e18, st->dst1_5b4e28) != 0) {
        st->latch_5d1967 = 1;
    }
    st->rel_dst1_5b4e58[1] = sub32(st->dst1_5b4e28[1], st->view_y_58318a);
    st->rel_dst1_5b4e58[3] = sub32(st->dst1_5b4e28[3], st->view_y_58318a);
    st->rel_dst1_5b4e58[0] = sub32(st->dst1_5b4e28[0], st->view_x_583186);
    st->rel_dst1_5b4e58[2] = sub32(st->dst1_5b4e28[2], st->view_x_583186);
    if (st->kind_5b4e8b == 2) {
        second_rects(st, hs, rect);
    }
    return A33_OK;
}

static int first_hit(const A33Set *set, int16_t selector)
{
    for (int32_t i = 0; i < set->hotspot_count; ++i) {
        if (set->hotspots[i].key == selector) {
            return (int)i;
        }
    }
    return -1;
}

/* Phase 0 (0x42c33d .. 0x42c71a). */
static int phase_init(A33State *st, const A33Set *set, int16_t row, A33Row *cells, const A33Host *host, A33StepResult *result)
{
    int32_t ret = 0;
    if (st->active_5c39f1 != 0) {
        OP(host, A33_OP_LOG, A33_LOG_SECOND_VIDEO, 0, NULL);
        return A33_ERR_FATAL;
    }
    st->page_5b4dc8 = 0;
    st->row_5b4e89 = row;
    st->kind_5b4e8b = set->kind_46;
    st->mode_5b4ea3 = set->w4a;
    st->active_5c39f1 = 1;
    cells->request = 0;
    st->latch_5d1967 = 0;
    st->flag_5b4e8d = 0;
    if (st->thread_5b4e0c != 0u) {
        OP(host, A33_OP_STREAM_LOCK, 0, 0, NULL);
        st->stream_5b4c3a = 2;
        OP(host, A33_OP_THREAD_STOP, (int32_t)st->thread_5b4e0c, 0, NULL);
        OP(host, A33_OP_THREAD_DELETE, (int32_t)st->thread_5b4e0c, 0, NULL);
        st->thread_5b4e0c = 0u;
        OP(host, A33_OP_STREAM_UNLOCK, 0, 0, NULL);
        st->stream_5b4c3a = 0;
    }
    if (st->buf_5b4db8 != 0u) {
        if ((st->flags_5b4dc0 & 8u) == 0u) {
            OP(host, A33_OP_FREE, (int32_t)st->buf_5b4db8, 0, NULL);
        }
        st->flags_5b4dc0 = 0u;
        st->buf_5b4db8 = 0u;
    }
    if (st->buf_5b4dbc != 0u) {
        if ((st->flags_5b4dc2 & 8u) == 0u) {
            OP(host, A33_OP_FREE, (int32_t)st->buf_5b4dbc, 0, NULL);
        }
        st->flags_5b4dc2 = 0u;
        st->buf_5b4dbc = 0u;
    }
    OP(host, A33_OP_Z_UNREGISTER, 0, 0, NULL);
    if (st->surface_5d03bf != 0u) {
        OP(host, A33_OP_SURFACE_RELEASE, (int32_t)st->surface_5d03bf, 0, NULL);
    }
    st->surface_5d03bf = 0u;
    if (st->surface_5d03c7 != 0u) {
        OP(host, A33_OP_SURFACE_RELEASE, (int32_t)st->surface_5d03c7, 1, NULL);
    }
    st->surface_5d03c7 = 0u;
    copy_name(st->clip_5b4d8f, set->clip);
    st->w_5b4e02 = set->w42;
    st->present_5b4e04 = set->w44;
    OP(host, A33_OP_STREAM_RESET, 0, 0, NULL);
    if (st->kind_5b4e8b == 2) {
        copy_name(st->overlay_5b4e68, set->overlay);
        OP(host, A33_OP_OVERLAY_LOAD, 0, 0, &ret);
        if (st->surface_5d03c7 == 0u) {
            st->surface_5d03c7 = (uint32_t)ret;
        }
    }
    OP(host, A33_OP_SURFACE_CREATE, addi32(sub32(st->vrect_5b4df0, st->vrect_5b4de8), 1),
       addi32(sub32(st->vrect_5b4df4, st->vrect_5b4dec), 1), &ret);
    st->surface_5d03bf = (uint32_t)ret;
    st->surface_5d195b = st->surface_5d03bf;
    if (st->thread_5b4e0c == 0u) {
        OP(host, A33_OP_LOG, A33_LOG_THREAD_START, st->scene_5bb57b, NULL);
        OP(host, A33_OP_THREAD_CREATE, (int32_t)st->thread_arg_5b016f, 0, &ret);
        st->thread_5b4e0c = (uint32_t)ret;
        if (st->thread_5b4e0c == 0u) {
            OP(host, A33_OP_LOG, A33_LOG_THREAD_MEMORY, 0, NULL);
            return A33_ERR_FATAL;
        }
    }
    if (set->anim_48 == 1) {
        st->frame_5b4e00 = set->w4c;
        st->state_5b4e10 = 0;
        st->anim_5b4e14 = 0;
    } else if (set->anim_48 == 2) {
        st->frame_5b4e00 = set->w54;
        st->state_5b4e10 = 0;
        st->anim_5b4e14 = 3;
    }
    st->ready_5b4e0a = 0;
    OP(host, A33_OP_THREAD_RESUME, (int32_t)st->thread_5b4e0c, 0, NULL);
    result->initialized = 1u;
    result->phase_after = 1u;
    return A33_OK;
}

/* The code shared by phase 1 and the tail of phase 0 (0x42c724 .. 0x42c93c). */
static int phase_play(A33State *st, const A33Set *set, int16_t row, A33Row *cells, const A33Host *host)
{
    int32_t rect[4];
    int32_t tick = 0;
    int status;
    cells->request = 0;
    st->latch_5d1967 = 0;
    st->flag_5b4e8d = 0;
    rect[0] = st->clip_5bb583[0];
    rect[1] = st->clip_5bb583[1];
    rect[2] = st->clip_5bb583[2];
    rect[3] = st->clip_5bb583[3];
    if (st->state_5b4e10 == 0) {
        if (st->ready_5b4e0a != 0) {
            const int hit = first_hit(set, st->selector_5bb50b);
            if (hit >= 0) {
                st->start_5bb1ca = 1;
                status = event_flags(st, set, host);
                if (status != A33_OK) {
                    return status;
                }
                status = page_flip(st, host);
                if (status != A33_OK) {
                    return status;
                }
                frame_advance(st, set);
                status = hotspot_rects(st, set, cells, row, (int16_t)hit, rect);
                if (status != A33_OK) {
                    return status;
                }
                st->ready_5b4e0a = 0;
                OP(host, A33_OP_TICK, 0, 0, &tick);
                st->deadline_5b4dfc = add32((uint32_t)tick, (uint32_t)st->delay_5b4c5a);
            }
            st->state_5b4e10 = 4;
        }
    } else if (st->state_5b4e10 == 4) {
        const int hit = first_hit(set, st->selector_5bb50b);
        OP(host, A33_OP_TICK, 0, 0, &tick);
        if ((uint32_t)tick < st->deadline_5b4dfc) {
            if (hit >= 0) {
                return hotspot_rects(st, set, cells, row, (int16_t)hit, rect);
            }
        } else if (hit >= 0) {
            if (st->ready_5b4e0a != 0) {
                status = page_flip(st, host);
                if (status != A33_OK) {
                    return status;
                }
                status = event_flags(st, set, host);
                if (status != A33_OK) {
                    return status;
                }
                frame_advance(st, set);
                OP(host, A33_OP_TICK, 0, 0, &tick);
                st->deadline_5b4dfc = add32((uint32_t)tick, (uint32_t)st->delay_5b4c5a);
                st->ready_5b4e0a = 0;
            }
            return hotspot_rects(st, set, cells, row, (int16_t)hit, rect);
        }
    }
    return A33_OK;
}

/* Phase 2 (0x42c941 ..): the finish. */
static int phase_finish(A33State *st, const A33Set *set, const A33Host *host, A33StepResult *result)
{
    if (st->ready_5b4e0a == 0) {
        return A33_OK;
    }
    st->row_5b4e89 = (int16_t)-1;
    st->kind_5b4e8b = 1;
    st->mode_5b4ea3 = 1;
    st->active_5c39f1 = 0;
    if (set->push_6c == 1u) {
        OP(host, A33_OP_PUSH_SCENE, 2, 0, NULL);
    }
    st->scene_5bb57b = (int32_t)set->scene_58;
    st->w_5bb599 = set->w5a;
    st->w_5bb595 = set->w5c;
    st->w_5c39ff = set->w5e;
    st->d_5bb59b = set->d60;
    st->d_5bb59f = set->d64;
    st->d_5bb5a3 = set->d68;
    st->mode_583999 = 4;
    result->finished = 1u;
    return A33_OK;
}

int a33_step(A33State *state, const A33Set *set, int16_t row, A33Row *row_cells, uint32_t phase, const A33Host *host,
             A33StepResult *result, const char **failure)
{
    int status = A33_OK;
    A33StepResult local;
    if (failure != NULL) {
        *failure = "none";
    }
    if (state == NULL || set == NULL || row_cells == NULL || host == NULL || host->op == NULL || row < 0 ||
        set->entry_count < 0 || set->hotspot_count < 0 || (set->entry_count > 0 && set->entries == NULL) ||
        (set->hotspot_count > 0 && set->hotspots == NULL)) {
        return A33_ERR_ARGUMENT;
    }
    memset(&local, 0, sizeof(local));
    local.phase_after = phase;
    state->has_entries_5b4ea5 = set->entry_count > 0 ? 1 : 0;
    if (set->hotspot_count < 1) {
        state->has_hotspots_5b4ea9 = 0;
        status = call_op(host, A33_OP_LOG, A33_LOG_MISSING_HOTSPOTS, 0, NULL);
        if (status == A33_OK) {
            status = A33_ERR_FATAL;
        }
        goto done;
    }
    state->has_hotspots_5b4ea9 = 1;
    if (phase == 0u) {
        status = phase_init(state, set, row, row_cells, host, &local);
        if (status != A33_OK) {
            goto done;
        }
        status = phase_play(state, set, row, row_cells, host);
    } else if (phase == 1u) {
        status = phase_play(state, set, row, row_cells, host);
    } else if (phase == 2u) {
        status = phase_finish(state, set, host, &local);
    }
done:
    if (status == A33_ERR_FATAL && failure != NULL) {
        *failure = "0x33: the original reaches its fatal exit 0x4c97b4";
    } else if (status == A33_ERR_HOST && failure != NULL) {
        *failure = "0x33: a host operation failed";
    } else if (status == A33_ERR_UNSUPPORTED && failure != NULL) {
        *failure = "0x33: hotspot request cells for a row other than the running one";
    }
    if (result != NULL) {
        *result = local;
    }
    return status;
}
