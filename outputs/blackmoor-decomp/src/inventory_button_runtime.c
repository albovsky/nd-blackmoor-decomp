#include "inventory_button_runtime.h"

#include <string.h>

static int32_t rd_i32(const uint8_t *p)
{
    return (int32_t)((uint32_t)p[0] | ((uint32_t)p[1] << 8) | ((uint32_t)p[2] << 16) |
                     ((uint32_t)p[3] << 24));
}

static uint16_t rd_u16(const uint8_t *p)
{
    return (uint16_t)(p[0] | (p[1] << 8));
}

int taskbar_layout_from_task(const uint8_t *chunk, size_t length, int32_t origin_x,
                             int32_t origin_y, TaskbarLayout *out)
{
    static const uint8_t no_sound[TASKBAR_SOUND_NAME_BYTES] = {'N', 'O', ' ', 'S', 'O', 'U', 'N',
                                                               'D', 0};
    if (chunk == NULL || out == NULL) return TASKBAR_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    if (length < TASKBAR_CHUNK_BYTES) return TASKBAR_ERR_FORMAT;
    for (unsigned i = 0; i < 4u; ++i) out->bounds[i] = rd_i32(chunk + TASKBAR_BOUNDS_OFFSET + 4u * i);
    for (unsigned i = 0; i < TASKBAR_BUTTONS; ++i) {
        const uint8_t *r = chunk + TASKBAR_RECORDS_OFFSET + (size_t)i * TASKBAR_RECORD_BYTES;
        TaskbarButtonLayout *b = &out->button[i];
        b->id = rd_i32(r + 0x42);
        b->relative = rd_i32(r + 0xa6);
        /* 0x4e1f64..0x4e1fc1: left = +0xce (+x0), right = +0xd6 (+x0), top = +0xd2 (+y0),
         * bottom = +0xda (+y0) of the button object; the record is copied to object +0x38. */
        const int32_t left = rd_i32(r + 0x96), top = rd_i32(r + 0x9a);
        const int32_t right = rd_i32(r + 0x9e), bottom = rd_i32(r + 0xa2);
        if (b->relative != 0) {
            b->rect[0] = (int32_t)((uint32_t)left + (uint32_t)origin_x);
            b->rect[2] = (int32_t)((uint32_t)right + (uint32_t)origin_x);
            b->rect[1] = (int32_t)((uint32_t)top + (uint32_t)origin_y);
            b->rect[3] = (int32_t)((uint32_t)bottom + (uint32_t)origin_y);
        } else {
            b->rect[0] = left; b->rect[1] = top; b->rect[2] = right; b->rect[3] = bottom;
        }
        b->hover_changes_state = rd_i32(r + 0xaa);
        b->cursor_flag = rd_i32(r + 0xae);
        b->initial_state = rd_i32(r + 0xb6);
        b->delay_ms = (uint32_t)rd_i32(r + 0xba);
        memcpy(b->sound_name, r + 0xbe, TASKBAR_SOUND_NAME_BYTES);
        b->sound_name[TASKBAR_SOUND_NAME_BYTES] = 0;
        b->has_sound = memcmp(r + 0xbe, no_sound, TASKBAR_SOUND_NAME_BYTES) != 0;
        b->sound_slot = rd_u16(r + 0xdf);
    }
    return TASKBAR_OK;
}

int taskbar_init(Taskbar *bar, const TaskbarLayout *layout)
{
    if (bar == NULL || layout == NULL) return TASKBAR_ERR_ARGUMENT;
    memset(bar, 0, sizeof(*bar));
    for (unsigned i = 0; i < TASKBAR_BUTTONS; ++i) bar->button[i].state = layout->button[i].initial_state;
    bar->event = TASKBAR_EVENT_NONE;
    bar->hover_id = -1;
    return TASKBAR_OK;
}

/* 0x4e2940: unconditional store of the state. */
static void set_state(Taskbar *bar, unsigned i, int32_t state)
{
    bar->button[i].state = state;
}

int taskbar_apply_locks(Taskbar *bar, int16_t scene_request)
{
    if (bar == NULL) return TASKBAR_ERR_ARGUMENT;
    for (unsigned i = 0; i < TASKBAR_BUTTONS; ++i) {
        const TaskbarLock *lock = &bar->lock[i];
        if (lock->kind == 1) {                       /* 0x4e1919 */
            set_state(bar, i, TASKBAR_STATE_LOCKED);
            continue;
        }
        if (bar->button[i].state == TASKBAR_STATE_LOCKED && lock->kind == 2) {   /* 0x4e195b */
            set_state(bar, i, TASKBAR_STATE_NORMAL);
            continue;
        }
        if (lock->kind != 0) continue;               /* 0x4e199d */
        int found = 0;
        for (unsigned k = 0; k < TASKBAR_LOCK_RANGES && !found; ++k) {
            if (scene_request >= lock->lo[k] && scene_request <= lock->hi[k]) {
                set_state(bar, i, TASKBAR_STATE_LOCKED);
                found = 1;
            }
        }
        if (!found && bar->button[i].state == TASKBAR_STATE_LOCKED)
            set_state(bar, i, TASKBAR_STATE_NORMAL);
    }
    return TASKBAR_OK;
}

/* 0x4e22fd, mode 0 only. x and y are the low words 0x4e075a pushes. */
static int button_hover(Taskbar *bar, const TaskbarLayout *layout, unsigned i, int16_t x,
                        int16_t y)
{
    TaskbarButton *b = &bar->button[i];
    const TaskbarButtonLayout *l = &layout->button[i];
    b->hovered = 0;
    if (b->state == TASKBAR_STATE_DISABLED) return 0;
    if (b->state != TASKBAR_STATE_NORMAL && b->state != TASKBAR_STATE_HOVER &&
        b->state != TASKBAR_STATE_LOCKED) return 0;
    if (y >= l->rect[1] && y <= l->rect[3] && x >= l->rect[0] && x <= l->rect[2]) {
        b->hovered = 1;
        if (l->hover_changes_state != 0 && b->state != TASKBAR_STATE_LOCKED)
            b->state = TASKBAR_STATE_HOVER;
        if (l->cursor_flag != 0) {
            bar->event = TASKBAR_EVENT_BUTTON;
            bar->cursor_variant = 1;
        }
        return 1;
    }
    if (b->state == TASKBAR_STATE_HOVER) b->state = TASKBAR_STATE_NORMAL;
    return 0;
}

int taskbar_hover(Taskbar *bar, const TaskbarLayout *layout, const int32_t pointer_rect[4],
                  const TaskbarHost *host, TaskbarHoverResult *result)
{
    if (bar == NULL || layout == NULL || pointer_rect == NULL || host == NULL ||
        host->hotspot == NULL || result == NULL) return TASKBAR_ERR_ARGUMENT;
    memset(result, 0, sizeof(*result));
    result->hit = -1;
    bar->event = TASKBAR_EVENT_NONE;                 /* 0x4d308b */
    result->cursor_index = bar->cursor_index;
    result->cursor_variant = bar->cursor_variant;
    result->event = bar->event;
    if (bar->state != 1) return TASKBAR_OK;          /* 0x4e0767 */
    result->ran = 1;
    if (pointer_rect[0] >= layout->bounds[0] && pointer_rect[2] <= layout->bounds[2] &&
        pointer_rect[1] >= layout->bounds[1] && pointer_rect[3] <= layout->bounds[3]) {
        bar->cursor_index = TASKBAR_BAR_CURSOR_INDEX;       /* 0x4e07ab */
        bar->cursor_variant = TASKBAR_BAR_CURSOR_VARIANT;
        result->cursor_forced = 1;
    }
    int32_t dx = 0, dy = 0;
    if (host->hotspot(host->context, bar->cursor_index, bar->cursor_variant, &dx, &dy) != 0)
        return TASKBAR_ERR_HOST;
    result->x = (int32_t)((uint32_t)pointer_rect[0] + (uint32_t)dx);   /* 0x4e0805 */
    result->y = (int32_t)((uint32_t)pointer_rect[1] + (uint32_t)dy);   /* 0x4e0829 */
    for (unsigned i = 0; i < TASKBAR_BUTTONS; ++i) {
        if (button_hover(bar, layout, i, (int16_t)result->x, (int16_t)result->y) != 0) {
            result->hit = (int32_t)i;
            bar->hover_id = layout->button[i].id;
            break;
        }
    }
    result->cursor_index = bar->cursor_index;
    result->cursor_variant = bar->cursor_variant;
    result->event = bar->event;
    return TASKBAR_OK;
}

int taskbar_click(Taskbar *bar, const TaskbarLayout *layout, uint32_t now,
                  const TaskbarHost *host, TaskbarClickResult *result)
{
    if (bar == NULL || layout == NULL || host == NULL || result == NULL) return TASKBAR_ERR_ARGUMENT;
    memset(result, 0, sizeof(*result));
    result->pressed = -1;
    result->locked_click = -1;
    if (bar->state != 1) return TASKBAR_OK;          /* 0x4e0994 */
    result->ran = 1;
    for (unsigned i = 0; i < TASKBAR_BUTTONS; ++i) {
        TaskbarButton *b = &bar->button[i];
        const TaskbarButtonLayout *l = &layout->button[i];
        if (b->state == TASKBAR_STATE_DISABLED) continue;            /* 0x4e2709 */
        if (b->hovered && !b->click_flag &&
            (b->state == TASKBAR_STATE_NORMAL || b->state == TASKBAR_STATE_HOVER)) {
            if (l->has_sound && host->request_sound == NULL) return TASKBAR_ERR_HOST;
            b->state = TASKBAR_STATE_PRESSED;                         /* 0x4e276d */
            b->deadline = now + l->delay_ms;
            if (l->has_sound) {
                if (host->request_sound(host->context, l->sound_name, l->sound_slot) != 0)
                    return TASKBAR_ERR_HOST;
                result->sound_requested = 1;
            }
            result->pressed = (int32_t)i;
            return TASKBAR_OK;
        }
        if (b->hovered && b->state == TASKBAR_STATE_LOCKED) {         /* 0x4e284d */
            result->locked_click = (int32_t)i;
            return TASKBAR_OK;
        }
    }
    return TASKBAR_OK;
}

/* 0x4e29ec, mode 0. */
static int button_animate(Taskbar *bar, const TaskbarLayout *layout, unsigned i, uint32_t now,
                          const TaskbarHost *host, uint8_t *completed)
{
    TaskbarButton *b = &bar->button[i];
    const TaskbarButtonLayout *l = &layout->button[i];
    if (b->state == TASKBAR_STATE_DISABLED) return TASKBAR_OK;       /* 0x4e29f8 */
    if (b->stage == 0) { b->stage = 1; return TASKBAR_OK; }          /* 0x4e2a21..0x4e2a99 */
    if (b->state != TASKBAR_STATE_PRESSED) return TASKBAR_OK;        /* 0x4e2ac2 */
    if (!(now > b->deadline)) return TASKBAR_OK;                     /* 0x4e2ad1 jbe */
    if (l->has_sound) {                                              /* 0x4e2ad9 */
        int busy = 0;
        if (host == NULL || host->sound_busy == NULL ||
            host->sound_busy(host->context, l->sound_slot, &busy) != 0) return TASKBAR_ERR_HOST;
        if (busy != 0) return TASKBAR_OK;                            /* 0x4e2b0b */
    }
    b->state = TASKBAR_STATE_NORMAL;                                 /* 0x4e2b10 */
    b->click_flag = 1;                                               /* 0x4e2b1a */
    *completed = 1;
    return TASKBAR_OK;
}

int taskbar_process(Taskbar *bar, const TaskbarLayout *layout, int16_t scene_request,
                    uint32_t now, const TaskbarHost *host, TaskbarProcessResult *result)
{
    if (bar == NULL || layout == NULL || result == NULL) return TASKBAR_ERR_ARGUMENT;
    memset(result, 0, sizeof(*result));
    taskbar_apply_locks(bar, scene_request);                        /* 0x4e0e3f */
    if (bar->state == 0) {                                          /* 0x4e0e6b */
        bar->state = 1;
        result->loaded = 1;
        return TASKBAR_OK;
    }
    if (bar->state == 1) {                                          /* 0x4e0eaf */
        for (unsigned i = 0; i < TASKBAR_BUTTONS; ++i) {
            const int status = button_animate(bar, layout, i, now, host, &result->completed[i]);
            if (status != TASKBAR_OK) return status;
        }
        memset(bar->flag, 0, sizeof(bar->flag));                    /* 0x4e0ee1.. */
        result->flags_cleared = 1;
        for (unsigned i = 0; i < TASKBAR_BUTTONS; ++i) {
            if (bar->button[i].click_flag) {                        /* 0x4e2913 */
                bar->button[i].click_flag = 0;
                bar->flag[i] = 1;
                result->flag_set[i] = 1;
            }
        }
        return TASKBAR_OK;
    }
    if (bar->state == 2) {                                          /* 0x4e10d7 */
        memset(bar->flag, 0, sizeof(bar->flag));
        result->flags_cleared = 1;
    }
    return TASKBAR_OK;
}
