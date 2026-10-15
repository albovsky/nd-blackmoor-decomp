/* RT-17: ASan/UBSan driver for session_navigation on bounded malformed input.
 * Every call is made with garbage globals, rectangles, row tables and NULL /
 * mismatched arguments; the module must return a status, never trap. */
#include "session_navigation.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static uint64_t rng_state = 0x9e3779b97f4a7c15ull;

static uint32_t rnd(void)
{
    rng_state ^= rng_state << 13;
    rng_state ^= rng_state >> 7;
    rng_state ^= rng_state << 17;
    return (uint32_t)(rng_state >> 16);
}

static int32_t wild(void)
{
    static const int32_t edge[] = {0, 1, -1, 2, -2, 15, 0x2d, 0x28, 10, 0x7fff, -0x8000, 0x8000,
                                   0x7fffffff, (int32_t)0x80000000, 0x14d, 0x4d, 639, 479, 374};
    return rnd() % 3 == 0 ? edge[rnd() % (sizeof(edge) / sizeof(edge[0]))] : (int32_t)rnd();
}

static void random_globals(NavGlobals *g)
{
    g->selector = (int16_t)wild(); g->frame_min = (int16_t)wild(); g->frame_max = (int16_t)wild();
    g->step = (int16_t)wild(); g->mode = (int16_t)wild(); g->arrow_width = (int16_t)wild();
    g->arrow_height = (int16_t)wild(); g->hover_delay = (int16_t)wild();
    g->key_delay = (int16_t)wild(); g->scroll_step = (int16_t)wild();
    g->scroll = wild(); g->scroll_end = wild(); g->image_bottom = wild();
    g->nav_allowed = wild(); g->auto_move = wild(); g->frames_cached = wild();
    g->cursor_mode = wild(); g->state = wild(); g->gate_deadline = (uint32_t)wild();
}

static void random_rect(SessionInputRect *r)
{
    r->left = wild(); r->top = wild(); r->right = wild(); r->bottom = wild();
}

int main(void)
{
    long iterations = 0, scans_ok = 0, limits = 0, invalid = 0;
    long i;
    NavZoneResult zone;
    NavStepResult step;
    for (i = 0; i < 200000; ++i) {
        NavGlobals g;
        NavKeys keys;
        NavZoneGeometry geo;
        NavCursor cursor;
        random_globals(&g);
        memset(&keys, 0, sizeof(keys));
        if (rnd() % 2) {
            uint8_t *bytes = (uint8_t *)&keys;
            size_t k;
            for (k = 0; k < sizeof(keys); ++k) bytes[k] = (uint8_t)rnd();
        }
        random_rect(&geo.view);
        geo.bands.x1 = wild(); geo.bands.y1 = wild(); geo.bands.x2 = wild(); geo.bands.y2 = wild();
        geo.hot_x = wild(); geo.hot_y = wild();
        cursor.index = wild(); cursor.variant = wild();
        if (session_navigation_zone(&g, &geo, &cursor, &zone) != SESSION_NAVIGATION_OK) return 1;
        if (zone.effect_count > NAV_EFFECT_MAX) return 2;
        if (session_navigation_step(&g, &keys, (uint32_t)wild(), (uint32_t)wild(), &step) !=
            SESSION_NAVIGATION_OK)
            return 3;
        if (step.effect_count > NAV_EFFECT_MAX) return 4;
        /* NULL and aliasing arguments. */
        if (session_navigation_zone(NULL, &geo, &cursor, &zone) == SESSION_NAVIGATION_OK) return 5;
        if (session_navigation_zone(&g, NULL, &cursor, &zone) == SESSION_NAVIGATION_OK) return 6;
        if (session_navigation_zone(&g, &geo, NULL, &zone) == SESSION_NAVIGATION_OK) return 7;
        if (session_navigation_zone(&g, &geo, &cursor, NULL) == SESSION_NAVIGATION_OK) return 8;
        if (session_navigation_step(NULL, &keys, 0, 0, &step) == SESSION_NAVIGATION_OK) return 9;
        if (session_navigation_step(&g, NULL, 0, 0, &step) == SESSION_NAVIGATION_OK) return 10;
        if (session_navigation_step(&g, &keys, 0, 0, NULL) == SESSION_NAVIGATION_OK) return 11;
        if (i % 4 == 0) {
            SessionInputState state;
            SessionInputContext context;
            SessionInputHotspot priority[6], rows[6];
            NavBands bands;
            NavPointer pointer;
            NavScanResult out;
            size_t pc = rnd() % 7, rc = rnd() % 7, k;
            int status;
            memset(&context, 0, sizeof(context));
            session_input_init(&state);
            random_rect(&context.viewport);
            if (rnd() % 2) { context.viewport.left = 10; context.viewport.top = 10;
                             context.viewport.right = 629; context.viewport.bottom = 384; }
            random_rect(&context.cursor);
            context.hot_x = wild(); context.hot_y = wild(); context.scroll_y = wild();
            context.cursor_mode = rnd() % 8; context.modal_event = (uint32_t)wild();
            context.producer_disabled = rnd() % 3 == 0;
            context.geometry_ready = rnd() % 4 != 0; context.priority_clear = rnd() % 4 != 0;
            context.excluded_0 = rnd() % 10 == 0 ? wild() : (rnd() % 3 == 0 ? (int32_t)(rnd() % 12) : -1);
            context.excluded_1 = rnd() % 10 == 0 ? wild() : -1;
            for (k = 0; k < 6; ++k) {
                memset(&priority[k], 0, sizeof(priority[k]));
                memset(&rows[k], 0, sizeof(rows[k]));
                priority[k].index = rnd() % 16 == 0 ? wild() : (int32_t)(rnd() % 240);
                rows[k].index = rnd() % 16 == 0 ? wild() : (int32_t)k * 3;
                if (rnd() % 4 != 0) {   /* mostly rectangles in the signed-short domain */
                    priority[k].rectangle.left = (int32_t)(rnd() % 700) - 30;
                    priority[k].rectangle.top = (int32_t)(rnd() % 500) - 30;
                    priority[k].rectangle.right = priority[k].rectangle.left + (int32_t)(rnd() % 400);
                    priority[k].rectangle.bottom = priority[k].rectangle.top + (int32_t)(rnd() % 400);
                    rows[k].rectangle = priority[k].rectangle;
                } else {
                    random_rect(&priority[k].rectangle);
                    random_rect(&rows[k].rectangle);
                }
                priority[k].active = rnd() & 3; rows[k].active = rnd() & 3;
            }
            bands.x1 = wild(); bands.y1 = wild(); bands.x2 = wild(); bands.y2 = wild();
            pointer.hot_x = wild(); pointer.hot_y = wild(); pointer.selected_item = wild();
            state.candidate = wild();
            status = session_navigation_scan(&state, &context, &g, &bands, &pointer, &cursor,
                                             pc ? priority : NULL, pc, rc ? rows : NULL, rc, &out);
            if (status == SESSION_INPUT_OK) ++scans_ok;
            else if (status == SESSION_INPUT_INVALID_ARGUMENT) ++invalid;
            else ++limits;
            /* Mismatched pointer/count combinations must be rejected, not read. */
            if (session_navigation_scan(&state, &context, &g, &bands, &pointer, &cursor, NULL, 3,
                                        NULL, 0, &out) == SESSION_INPUT_OK) return 12;
            if (session_navigation_scan(&state, &context, &g, &bands, &pointer, &cursor, NULL, 0,
                                        NULL, 241, &out) == SESSION_INPUT_OK) return 13;
            if (session_navigation_scan(&state, &context, &g, &bands, NULL, &cursor, NULL, 0, NULL,
                                        0, &out) == SESSION_INPUT_OK) return 14;
        }
        {
            uint8_t types[8];
            size_t k;
            for (k = 0; k < sizeof(types); ++k) types[k] = (uint8_t)rnd();
            (void)session_navigation_members_idle(types, rnd() % 9);
            (void)session_navigation_member_type((uint8_t)rnd());
        }
        ++iterations;
    }
    printf("session_navigation sanitizer run: iterations=%ld scans_ok=%ld limits=%ld invalid=%ld\n",
           iterations, scans_ok, limits, invalid);
    return 0;
}
