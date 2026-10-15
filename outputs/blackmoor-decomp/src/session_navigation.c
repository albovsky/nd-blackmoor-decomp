#include "session_navigation.h"

#include <string.h>

#define SELECTOR_WRAP 1
#define SELECTOR_CLAMP 2

static int32_t wrapping_add(int32_t a, int32_t b)
{
    uint32_t raw = (uint32_t)a + (uint32_t)b;
    int32_t result;
    memcpy(&result, &raw, sizeof(result));
    return result;
}

static int32_t wrapping_sub(int32_t a, int32_t b)
{
    uint32_t raw = (uint32_t)a - (uint32_t)b;
    int32_t result;
    memcpy(&result, &raw, sizeof(result));
    return result;
}

/* 16-bit word arithmetic of the original's `add ax, [step]` (no sign check). */
static int16_t word_add(int16_t a, int16_t b)
{
    uint16_t raw = (uint16_t)((uint16_t)a + (uint16_t)b);
    int16_t result;
    memcpy(&result, &raw, sizeof(result));
    return result;
}

static int16_t word_sub(int16_t a, int16_t b)
{
    uint16_t raw = (uint16_t)((uint16_t)a - (uint16_t)b);
    int16_t result;
    memcpy(&result, &raw, sizeof(result));
    return result;
}

/* The mode test shared by the selector-moving zones: wrap (1), or clamp (2)
 * while the selector is not already at the end it would move towards. Mode 0
 * and every other value never enter a zone (0x4f1a01..0x4f1a29). */
static int selector_can_move(const NavGlobals *g, int16_t limit)
{
    return g->mode == SELECTOR_WRAP || (g->mode == SELECTOR_CLAMP && g->selector != limit);
}

static int zone_state(const NavGlobals *g, const NavZoneGeometry *geo)
{
    const int32_t w = g->arrow_width, h = g->arrow_height;
    const int32_t x = geo->hot_x, y = geo->hot_y;
    const NavBands *b = &geo->bands;
    const SessionInputRect *v = &geo->view;
    /* 0x4f192d..0x4f1987: top band, scroll up. */
    if (h != 0 && g->scroll > 0 &&
        y >= wrapping_sub(wrapping_sub(v->top, h), 10) && y <= b->y1 &&
        x >= b->x1 && x <= b->x2)
        return NAV_STATE_SCROLL_UP;
    /* 0x4f198c..0x4f19f1: bottom band, scroll down. */
    if (h != 0 && g->scroll_end != g->image_bottom &&
        y >= b->y2 && y <= wrapping_add(wrapping_add(v->bottom, h), 0x28) &&
        x >= b->x1 && x <= b->x2)
        return NAV_STATE_SCROLL_DOWN;
    /* 0x4f19f6..0x4f1a78: left band, selector +step. */
    if (w != 0 && selector_can_move(g, g->frame_max) &&
        y >= b->y1 && y <= b->y2 &&
        x >= wrapping_sub(wrapping_sub(v->left, w), 0x2d) && x <= b->x1)
        return NAV_STATE_SELECTOR_PLUS;
    /* 0x4f1a7d..0x4f1afe: right band, selector -step. */
    if (w != 0 && selector_can_move(g, g->frame_min) &&
        y >= b->y1 && y <= b->y2 &&
        x >= b->x2 && x <= wrapping_add(wrapping_add(v->right, w), 0x2d))
        return NAV_STATE_SELECTOR_MINUS;
    /* 0x4f1b03..0x4f1bb2: top-left corner. */
    if (h != 0 && w != 0 && g->scroll > 0 && selector_can_move(g, g->frame_max) &&
        y >= wrapping_sub(wrapping_sub(v->top, h), 10) && y <= b->y1 &&
        x >= wrapping_sub(wrapping_sub(v->left, w), 0x2d) && x <= b->x1)
        return NAV_STATE_UP_PLUS;
    /* 0x4f1bb7..0x4f1c64: top-right corner. */
    if (h != 0 && w != 0 && g->scroll > 0 && selector_can_move(g, g->frame_min) &&
        y >= wrapping_sub(wrapping_sub(v->top, h), 10) && y <= b->y1 &&
        x >= b->x2 && x <= wrapping_add(wrapping_add(v->right, w), 0x2d))
        return NAV_STATE_UP_MINUS;
    /* 0x4f1c69..0x4f1d15: bottom-left corner (no +0x28 / 0x2d margins). */
    if (h != 0 && w != 0 && g->scroll_end != g->image_bottom &&
        selector_can_move(g, g->frame_max) &&
        y >= b->y2 && y <= wrapping_add(v->bottom, h) &&
        x >= wrapping_sub(v->left, w) && x <= b->x1)
        return NAV_STATE_DOWN_PLUS;
    /* 0x4f1d1a..0x4f1dba: bottom-right corner. */
    if (h != 0 && w != 0 && g->scroll_end != g->image_bottom &&
        selector_can_move(g, g->frame_min) &&
        y >= b->y2 && y <= wrapping_add(v->bottom, h) &&
        x >= b->x2 && x <= wrapping_add(v->right, w))
        return NAV_STATE_DOWN_MINUS;
    return NAV_STATE_NONE;
}

int session_navigation_zone(const NavGlobals *globals, const NavZoneGeometry *geometry,
                            const NavCursor *cursor, NavZoneResult *out)
{
    NavZoneResult result;
    int32_t state;
    if (globals == NULL || geometry == NULL || cursor == NULL || out == NULL)
        return SESSION_NAVIGATION_INVALID_ARGUMENT;
    memset(&result, 0, sizeof(result));
    state = globals->state;
    /* 0x4f18fa..0x4f1919: [0x5a4c1c] == 0 skips every zone test (local +0x72). */
    if (globals->nav_allowed != 0) {
        int32_t found = zone_state(globals, geometry);
        if (found != NAV_STATE_NONE) state = found;
    }
    result.state = state;
    result.cursor = *cursor;
    if (state == NAV_STATE_NONE) {
        /* 0x4f1e7d..0x4f1eae: variant 0, table pointer, layer flag; the generic
         * row loop follows. */
        result.cursor.variant = 0;
        result.claimed = 0;
    } else {
        /* 0x4f1dc4..0x4f1e73. The arrow cursors depend on [0x5bb2d0] == 0x4d. */
        if (state == NAV_STATE_SELECTOR_PLUS) {
            result.cursor.index = globals->key_delay == 0x4d ? 0x11 : 0xe;
            result.surface_default = 1;
        } else if (state == NAV_STATE_SELECTOR_MINUS) {
            result.cursor.index = globals->key_delay == 0x4d ? 0x10 : 0xf;
            result.surface_default = 1;
        } else {
            result.cursor.index = 0;
        }
        result.claimed = 1;
    }
    result.table_offset = ((uint32_t)result.cursor.index << 5) +
                          ((uint32_t)result.cursor.variant << 4);
    result.layer_flag = 1;
    *out = result;
    return SESSION_NAVIGATION_OK;
}

/* ---- tick step ---------------------------------------------------------- */

/* 0x43c1f4 and 0x43c216: the two entry gates of the navigation block. */
static int step_wanted(const NavGlobals *g, const NavKeys *k, uint32_t tick_time)
{
    int to_1f4 = 0;
    int cached = g->frames_cached != 0;
    int after_deadline = tick_time > g->gate_deadline; /* jbe: unsigned */
    if (k->f1d != 0) {
        if (k->f1e == 0) to_1f4 = 1;
    }
    if (!to_1f4) {
        /* 0x43c14e */
        if (k->f1d == 0 && k->f1e != 0 && cached) to_1f4 = 1;
    }
    if (!to_1f4) {
        /* 0x43c173..0x43c1e9 */
        if (k->f15 != 0 || k->f16 != 0 || k->f13 != 0 || k->f14 != 0) to_1f4 = 1;
        else if ((k->f27 != 0 || k->f28 != 0 || k->f25 != 0 || k->f26 != 0) && cached) to_1f4 = 1;
    }
    if (to_1f4) {
        /* 0x43c1f4: state, deadline, then the always-zero stub 0x493a47. */
        if (g->state != 0 && after_deadline) return 1;
    }
    /* 0x43c216 */
    if (g->hover_delay == 0x14d) return 0;
    if (g->auto_move == 0) return 0;
    if (!after_deadline) return 0;
    if (g->state == 0) return 0;
    return 1;
}

/* The selector end handling shared by states 1/2 (no dirty mark) and 5..8. */
static void selector_plus(NavGlobals *g, int mark_dirty, uint8_t *dirty)
{
    g->selector = word_add(g->selector, g->step);
    if (g->selector > g->frame_max) {
        if (g->mode == SELECTOR_WRAP) {
            g->selector = g->frame_min;
        } else if (g->mode == SELECTOR_CLAMP) {
            g->selector = g->frame_max;
            if (mark_dirty) *dirty = 1;
        } else if (g->mode == 0) {
            g->selector = g->frame_max;
            if (mark_dirty) *dirty = 1;
        }
    }
}

static void selector_minus(NavGlobals *g, int mark_dirty, uint8_t *dirty)
{
    g->selector = word_sub(g->selector, g->step);
    if (g->selector < g->frame_min) {
        if (g->mode == SELECTOR_WRAP) {
            g->selector = g->frame_max;
        } else if (g->mode == SELECTOR_CLAMP) {
            g->selector = g->frame_min;
            if (mark_dirty) *dirty = 1;
        } else if (g->mode == 0) {
            g->selector = g->frame_min;
            if (mark_dirty) *dirty = 1;
        }
    }
}

/* 0x43c3c2..0x43c425: scroll up by one step, clamped at the top. */
static void scroll_up(NavGlobals *g)
{
    int32_t target = wrapping_sub(g->scroll, g->scroll_step);
    if (target < 0) {
        g->scroll = 0;
        g->scroll_end = wrapping_sub(wrapping_sub(g->scroll_end, g->scroll_step), target);
    } else {
        g->scroll = wrapping_sub(g->scroll, g->scroll_step);
        g->scroll_end = wrapping_sub(g->scroll_end, g->scroll_step);
    }
}

/* 0x43c444..0x43c4ba: scroll down by one step, clamped at the image bottom. */
static void scroll_down(NavGlobals *g)
{
    int32_t target = wrapping_add(g->scroll_end, g->scroll_step);
    if (target > g->image_bottom) {
        target = wrapping_sub(target, g->image_bottom);
        g->scroll = wrapping_sub(wrapping_add(g->scroll, g->scroll_step), target);
        g->scroll_end = g->image_bottom;
    } else {
        g->scroll = wrapping_add(g->scroll, g->scroll_step);
        g->scroll_end = wrapping_add(g->scroll_end, g->scroll_step);
    }
}

int session_navigation_step(NavGlobals *globals, const NavKeys *keys, uint32_t tick_time,
                            uint32_t now, NavStepResult *out)
{
    NavStepResult result;
    NavGlobals *g = globals;
    uint32_t delay;
    if (globals == NULL || keys == NULL || out == NULL)
        return SESSION_NAVIGATION_INVALID_ARGUMENT;
    memset(&result, 0, sizeof(result));
    result.selector_before = g->selector;
    if (!step_wanted(g, keys, tick_time)) {
        *out = result;
        return SESSION_NAVIGATION_OK;
    }
    /* 0x43c251: the UI cursor modes 2..5 jump to 0x43c941 (no step, no deadline). */
    if (g->cursor_mode >= 2 && g->cursor_mode <= 5) {
        *out = result;
        return SESSION_NAVIGATION_OK;
    }
    result.entered = 1;
    switch (g->state) {
    case NAV_STATE_SELECTOR_PLUS:
        selector_plus(g, 0, &result.view_dirty);
        break;
    case NAV_STATE_SELECTOR_MINUS:
        selector_minus(g, 0, &result.view_dirty);
        break;
    case NAV_STATE_SCROLL_UP:
        result.view_dirty = 1;
        if (g->scroll != 0) scroll_up(g);
        break;
    case NAV_STATE_SCROLL_DOWN:
        result.view_dirty = 1;
        if (g->scroll_end != g->image_bottom) scroll_down(g);
        break;
    case NAV_STATE_UP_PLUS:
        scroll_up(g);
        selector_plus(g, 1, &result.view_dirty);
        break;
    case NAV_STATE_UP_MINUS:
        scroll_up(g);
        selector_minus(g, 1, &result.view_dirty);
        break;
    case NAV_STATE_DOWN_PLUS:
        scroll_down(g);
        selector_plus(g, 1, &result.view_dirty);
        break;
    case NAV_STATE_DOWN_MINUS:
        scroll_down(g);
        selector_minus(g, 1, &result.view_dirty);
        break;
    default:
        break; /* 0x43c2a4: an out-of-range state goes straight to the deadline update */
    }
    /* 0x43c88d..0x43c93c: the next deadline. Key groups choose the delay. */
    if (keys->f1d != 0 || keys->f15 != 0 || keys->f16 != 0 || keys->f13 != 0 || keys->f14 != 0)
        delay = (uint32_t)(int32_t)g->hover_delay;
    else if (keys->f1e != 0 || keys->f27 != 0 || keys->f28 != 0 || keys->f25 != 0 ||
             keys->f26 != 0)
        delay = (uint32_t)(int32_t)g->key_delay;
    else
        delay = (uint32_t)(int32_t)g->hover_delay;
    g->gate_deadline = now + delay;
    result.selector_changed = g->selector != result.selector_before;
    *out = result;
    return SESSION_NAVIGATION_OK;
}

/* ---- cascade pipeline --------------------------------------------------- */

static int normal_mode(int32_t mode)
{
    return mode < 2 || mode > 5;
}

/* 0x4f0062..0x4f0126, the same inclusive guard session_input applies. */
static int sprite_overlaps_viewport(const SessionInputContext *c)
{
    if (c->cursor.left < c->viewport.left && c->cursor.right < c->viewport.left) return 0;
    if (c->cursor.left > c->viewport.right && c->cursor.right > c->viewport.right) return 0;
    if (c->cursor.top < c->viewport.top && c->cursor.bottom < c->viewport.top) return 0;
    if (c->cursor.top > c->viewport.bottom && c->cursor.bottom > c->viewport.bottom) return 0;
    return 1;
}

int session_navigation_scan(SessionInputState *input, const SessionInputContext *context,
                            NavGlobals *nav, const NavBands *bands, NavCursor *cursor,
                            const SessionInputHotspot *priority, size_t priority_count,
                            const SessionInputHotspot *rows, size_t row_count,
                            NavScanResult *out)
{
    SessionInputContext snapshot;
    NavScanResult result;
    NavZoneGeometry geometry;
    NavZoneResult zone;
    NavGlobals scratch;
    int status;
    if (input == NULL || context == NULL || nav == NULL || bands == NULL || cursor == NULL ||
        out == NULL)
        return SESSION_NAVIGATION_INVALID_ARGUMENT;
    snapshot = *context;
    memset(&result, 0, sizeof(result));
    result.candidate = -1;
    /* 0x4d3081 clears the state before the cascade; a UI mode (2..5) skips the
     * cascade and a producer-disabled tick skips 0x4d3073 altogether. */
    nav->state = NAV_STATE_NONE;
    if (!normal_mode(snapshot.cursor_mode) || snapshot.producer_disabled != 0) {
        status = session_input_scan_priority(input, &snapshot, NULL, 0, NULL, 0);
        result.candidate = input->candidate;
        *out = result;
        return status;
    }
    /* Overlay hit test (0x4f104f) and the UI members before it. This also
     * validates every row and returns the named limits. */
    status = session_input_scan_priority(input, &snapshot, priority, priority_count, NULL, 0);
    if (status != SESSION_INPUT_OK) return status;
    if (input->candidate >= 0) {
        result.candidate = input->candidate;
        *out = result;
        return SESSION_INPUT_OK;
    }
    if (!sprite_overlaps_viewport(&snapshot) || snapshot.geometry_ready == 0) {
        /* 0x4f2576: the overlap guard returned before everything. */
        *out = result;
        return SESSION_INPUT_OK;
    }
    geometry.view = snapshot.viewport;
    geometry.bands = *bands;
    geometry.hot_x = wrapping_add(snapshot.cursor.left, snapshot.hot_x);
    geometry.hot_y = wrapping_add(snapshot.cursor.top, snapshot.hot_y);
    scratch = *nav;
    scratch.state = NAV_STATE_NONE;
    if (session_navigation_zone(&scratch, &geometry, cursor, &zone) != SESSION_NAVIGATION_OK)
        return SESSION_NAVIGATION_INVALID_ARGUMENT;
    result.zone = zone;
    result.zone_evaluated = 1;
    result.state = zone.state;
    *cursor = zone.cursor;
    nav->state = zone.state;
    if (zone.claimed) {
        /* 0x4f1e78: returns before the generic loop; the candidate stays -1. */
        result.claimed_by_zone = 1;
        (void)session_input_publish_candidate(input, -1);
        result.candidate = -1;
        *out = result;
        return SESSION_INPUT_OK;
    }
    status = session_input_scan_priority(input, &snapshot, NULL, 0, rows, row_count);
    result.candidate = input->candidate;
    *out = result;
    return status;
}
