#include "score_time_display.h"

#include <stdio.h>
#include <string.h>

/* Wrapping 32-bit arithmetic: the original adds without overflow checks. */
static int32_t add32(int32_t a, int32_t b)
{
    return (int32_t)((uint32_t)a + (uint32_t)b);
}

static int32_t sub32(int32_t a, int32_t b)
{
    return (int32_t)((uint32_t)a - (uint32_t)b);
}

/* Signed division by two as compiled (truncates toward zero). */
static int32_t half(int32_t v)
{
    return v / 2;
}

static void fx(const StdHost *host, int effect, int32_t a, int32_t b)
{
    if (host != NULL && host->observe != NULL) host->observe(host->context, effect, a, b);
}

/* FL-12: original FUN_00445f53 is this function (function ledger acceptance). */
void std_reset_score(StdDisplay *d)
{
    d->score_enabled = 0;
    d->score_ready = 0;
    d->score = 0;
    d->score_str[0] = 0;
    d->prev_score_str[0] = 0;
    memset(d->score_w, 0, sizeof d->score_w);
    memset(d->score_h, 0, sizeof d->score_h);
    memset(d->score_block, 0, sizeof d->score_block);
}

/* FL-12: original FUN_00445fc5 is this function (function ledger acceptance). */
void std_reset_clock(StdDisplay *d)
{
    d->clock_enabled = 0;
    d->clock_ready = 0;
    d->colon_w = 0;
    d->colon_h = 0;
    d->minutes = 0;
    d->seconds = 0;
    d->minutes_str[0] = 0;
    d->seconds_str[0] = 0;
    d->prev_minutes_str[0] = 0;
    d->prev_seconds_str[0] = 0;
    memset(d->clock_w, 0, sizeof d->clock_w);
    memset(d->clock_h, 0, sizeof d->clock_h);
    memset(d->clock_block, 0, sizeof d->clock_block);
}

/* FL-12: original FUN_00446532 is this function (function ledger acceptance). */
void std_enable_score(StdDisplay *d, int32_t value)
{
    d->score_enabled = value;
}

/* FL-12: original FUN_00446548 is this function (function ledger acceptance). */
void std_enable_clock(StdDisplay *d, int32_t value)
{
    d->clock_enabled = value;
}

/* FL-12: original FUN_0044655e is this function (function ledger acceptance). */
int std_set_score(StdDisplay *d, int32_t score)
{
    if (score < 0 || score > 99999999) return STD_ERR_BOUNDS;
    d->score = score;
    (void)snprintf(d->score_str, sizeof d->score_str, "%d", score);
    return STD_OK;
}

/* FL-12: original FUN_00446598 is this function (function ledger acceptance). */
int std_set_clock(StdDisplay *d, int32_t minutes, int32_t seconds)
{
    if (minutes < 0 || minutes > 99 || seconds < 0 || seconds > 99) return STD_ERR_BOUNDS;
    d->minutes = minutes;
    d->seconds = seconds;
    (void)snprintf(d->minutes_str, sizeof d->minutes_str, "%02d", minutes);
    (void)snprintf(d->seconds_str, sizeof d->seconds_str, "%02d", seconds);
    return STD_OK;
}

int std_init_score(StdDisplay *d, const int32_t block[0x2e], const StdHost *host)
{
    memcpy(d->score_block, block, sizeof d->score_block);
    for (int k = 0; k < STD_DIGITS; ++k) {
        d->score_w[k] = add32(sub32(d->score_block[k * 4 + 2], d->score_block[k * 4]), 1);
        d->score_h[k] = add32(sub32(d->score_block[k * 4 + 3], d->score_block[k * 4 + 1]), 1);
    }
    d->loop_counter = STD_DIGITS;
    if (host == NULL || host->register_slot == NULL ||
        host->register_slot(host->context, (int16_t)d->score_block[44], d->score_block[45], STD_CALLBACK_SCORE,
                            (uint32_t)d->score_block[43], "SCORE DISPLAY") != 0) {
        return STD_ERR_HOST;
    }
    fx(host, STD_FX_INIT_SCORE, d->score_block[44], d->score_block[43]);
    d->score = 0;
    d->score_str[0] = 0;
    d->prev_score_str[0] = 0;
    d->score_enabled = 0;
    d->score_ready = 1;
    return STD_OK;
}

int std_init_clock(StdDisplay *d, const int32_t block[0x32], const StdHost *host)
{
    memcpy(d->clock_block, block, sizeof d->clock_block);
    for (int k = 0; k < STD_DIGITS; ++k) {
        d->clock_w[k] = add32(sub32(d->clock_block[k * 4 + 2], d->clock_block[k * 4]), 1);
        d->clock_h[k] = add32(sub32(d->clock_block[k * 4 + 3], d->clock_block[k * 4 + 1]), 1);
    }
    d->loop_counter = STD_DIGITS;
    d->colon_w = add32(sub32(d->clock_block[42], d->clock_block[40]), 1);
    d->colon_h = add32(sub32(d->clock_block[43], d->clock_block[41]), 1);
    if (host == NULL || host->register_slot == NULL ||
        host->register_slot(host->context, (int16_t)d->clock_block[48], d->clock_block[49], STD_CALLBACK_CLOCK,
                            (uint32_t)d->clock_block[47], "TIME DISPLAY") != 0) {
        return STD_ERR_HOST;
    }
    fx(host, STD_FX_INIT_CLOCK, d->clock_block[48], d->clock_block[47]);
    d->minutes = 0;
    d->seconds = 0;
    d->minutes_str[0] = 0;
    d->seconds_str[0] = 0;
    d->prev_minutes_str[0] = 0;
    d->prev_seconds_str[0] = 0;
    d->clock_enabled = 0;
    d->clock_ready = 1;
    return STD_OK;
}

/* The original copies the string up to and including its NUL; the bytes after it keep their old values. */
static void copy_string(char *dst, const char *src)
{
    size_t n = 0;
    while (n < STD_STRING_BYTES - 1 && src[n] != 0) ++n;
    memcpy(dst, src, n + 1);
}

static int digit_of(char ch)
{
    return (ch >= '0' && ch <= '9') ? ch - '0' : -1;
}

static int push(StdBlit *out, size_t capacity, size_t *count, int32_t kind, uint32_t surface, const int32_t src[4],
                const int32_t dst[4], int32_t a)
{
    StdBlit *b;
    if (*count >= capacity) return STD_ERR_BOUNDS;
    b = &out[(*count)++];
    memset(b, 0, sizeof *b);
    b->kind = kind;
    b->surface = surface;
    memcpy(b->src, src, sizeof b->src);
    memcpy(b->dst, dst, sizeof b->dst);
    b->a = a;
    return STD_OK;
}

/* One digit cell: dst = (x, y, x - 1 + w, y - 1 + h). */
static void digit_rect(int32_t x, int32_t y, int32_t w, int32_t h, int32_t r[4])
{
    r[0] = x;
    r[1] = y;
    r[2] = add32(sub32(x, 1), w);
    r[3] = add32(sub32(y, 1), h);
}

/* Erase the digits of `prev`: restore blits (source = destination minus the view origin), advancing like the draw. */
static int erase_string(const char *prev, const int32_t *wd, const int32_t *ht, int32_t gap, int32_t *cx, int32_t y,
                        int32_t view_x, int32_t view_y, int32_t kind, StdBlit *out, size_t capacity, size_t *count)
{
    for (size_t i = 0; prev[i] != 0 && i < STD_STRING_BYTES; ++i) {
        const int d = digit_of(prev[i]);
        int32_t dst[4], src[4];
        if (d < 0) return STD_ERR_BOUNDS;
        digit_rect(*cx, y, wd[d], ht[d], dst);
        src[0] = sub32(*cx, view_x);
        src[1] = sub32(y, view_y);
        src[2] = sub32(dst[2], view_x);
        src[3] = sub32(dst[3], view_y);
        if (push(out, capacity, count, kind, 0, src, dst, d) != STD_OK) return STD_ERR_BOUNDS;
        *cx = add32(add32(*cx, wd[d]), gap);
    }
    return STD_OK;
}

static int draw_string(const char *cur, const int32_t *wd, const int32_t *ht, const int32_t *rects, int32_t gap, int32_t *cx,
                       int32_t y, uint32_t surface, int32_t kind, StdBlit *out, size_t capacity, size_t *count)
{
    for (size_t i = 0; cur[i] != 0 && i < STD_STRING_BYTES; ++i) {
        const int d = digit_of(cur[i]);
        int32_t dst[4];
        if (d < 0) return STD_ERR_BOUNDS;
        digit_rect(*cx, y, wd[d], ht[d], dst);
        if (push(out, capacity, count, kind, surface, &rects[d * 4], dst, d) != STD_OK) return STD_ERR_BOUNDS;
        *cx = add32(add32(*cx, wd[d]), gap);
    }
    return STD_OK;
}

/* FL-12: original FUN_00446688 is this function (function ledger acceptance). */
int std_render_score(StdDisplay *d, int32_t view_x, int32_t view_y, StdBlit *out, size_t capacity, size_t *count)
{
    int32_t x, y;
    *count = 0;
    if (d->score_enabled == 0 || d->score_ready == 0) return STD_OK;
    x = d->score_block[40];
    y = d->score_block[41];
    if (strncmp(d->score_str, d->prev_score_str, STD_STRING_BYTES) != 0) {
        int32_t cx = x;
        int rc = erase_string(d->prev_score_str, d->score_w, d->score_h, d->score_block[42], &cx, y, view_x, view_y,
                              STD_BLIT_SCORE_ERASE, out, capacity, count);
        if (rc != STD_OK) return rc;
    }
    {
        int32_t cx = x;
        int rc = draw_string(d->score_str, d->score_w, d->score_h, d->score_block, d->score_block[42], &cx, y,
                             (uint32_t)d->score_block[43], STD_BLIT_SCORE_DIGIT, out, capacity, count);
        if (rc != STD_OK) return rc;
    }
    copy_string(d->prev_score_str, d->score_str);
    return STD_OK;
}

/* FL-12: original FUN_004468fe is this function (function ledger acceptance). */
int std_render_clock(StdDisplay *d, int32_t view_x, int32_t view_y, StdBlit *out, size_t capacity, size_t *count)
{
    const int32_t x = d->clock_block[44], y = d->clock_block[45], gap = d->clock_block[46];
    const uint32_t surface = (uint32_t)d->clock_block[47];
    int32_t cx, colon_y, dst[4], src[4];
    int rc;
    *count = 0;
    if (d->clock_enabled == 0 || d->clock_ready == 0) return STD_OK;
    colon_y = add32(y, half(sub32(d->clock_h[0], d->colon_h)));
    if (strncmp(d->minutes_str, d->prev_minutes_str, STD_STRING_BYTES) != 0 ||
        strncmp(d->seconds_str, d->prev_seconds_str, STD_STRING_BYTES) != 0) {
        cx = x;
        rc = erase_string(d->prev_minutes_str, d->clock_w, d->clock_h, gap, &cx, y, view_x, view_y,
                          STD_BLIT_CLOCK_ERASE_MIN, out, capacity, count);
        if (rc != STD_OK) return rc;
        dst[0] = cx;
        dst[1] = colon_y;
        dst[2] = add32(sub32(cx, 1), d->colon_w);
        dst[3] = add32(sub32(dst[1], 1), d->colon_h);
        src[0] = sub32(cx, view_x);
        src[1] = sub32(dst[1], view_y);
        src[2] = sub32(dst[2], view_x);
        src[3] = sub32(dst[3], view_y);
        if (push(out, capacity, count, STD_BLIT_CLOCK_ERASE_COLON, 0, src, dst, 0) != STD_OK) return STD_ERR_BOUNDS;
        cx = add32(add32(cx, d->colon_w), gap);
        rc = erase_string(d->prev_seconds_str, d->clock_w, d->clock_h, gap, &cx, y, view_x, view_y,
                          STD_BLIT_CLOCK_ERASE_SEC, out, capacity, count);
        if (rc != STD_OK) return rc;
    }
    cx = x;
    rc = draw_string(d->minutes_str, d->clock_w, d->clock_h, d->clock_block, gap, &cx, y, surface, STD_BLIT_CLOCK_MIN, out,
                     capacity, count);
    if (rc != STD_OK) return rc;
    dst[0] = cx;
    dst[1] = colon_y;
    dst[2] = add32(sub32(cx, 1), d->colon_w);
    dst[3] = add32(sub32(dst[1], 1), d->colon_h);
    if (push(out, capacity, count, STD_BLIT_CLOCK_COLON, surface, &d->clock_block[40], dst, 0) != STD_OK) {
        return STD_ERR_BOUNDS;
    }
    cx = add32(add32(cx, d->colon_w), gap);
    rc = draw_string(d->seconds_str, d->clock_w, d->clock_h, d->clock_block, gap, &cx, y, surface, STD_BLIT_CLOCK_SEC, out,
                     capacity, count);
    if (rc != STD_OK) return rc;
    copy_string(d->prev_minutes_str, d->minutes_str);
    copy_string(d->prev_seconds_str, d->seconds_str);
    return STD_OK;
}
