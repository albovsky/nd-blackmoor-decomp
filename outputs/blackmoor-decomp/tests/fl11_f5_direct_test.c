/* FL-11 direct tests of the static helpers of the raw 0xf5 Typing Quiz kernel (src/action_family_f5_runtime.c).
 * The kernel is pulled in as a translation unit (same shim pattern as tests/action_family_28_x87_division_fixture.c) so that
 * clock_update, score_update, pick_char, pick_position and first_wave can be called directly. Prints "PASS <name>" /
 * "FAIL <name>: <msg>"; the exit status is the failure count. Fixtures are synthetic (no original bytes). Expected values
 * are derived by hand from the original GAME.EXE functions 0x4b832c, 0x4b844d, 0x4b85f6, 0x4b866e and 0x4b8783 (Ghidra
 * pseudocode and capstone disassembly, helper 0x4b8520 and __ftol 0x50ce04), not by running the kernel. Body offsets below are
 * the original's displacements from the typed body (obj+8): +0x21 variant count, +0x23 variant rectangles, +0x173 position
 * count, +0x175 position rectangles, +0x432 digits flag, +0x434 extra characters (30 bytes), +0x452/+0x454 lifetime range,
 * +0x456/+0x458 balloon count range, +0x45a time limit, +0x45c score factor. */
#include "../src/action_family_f5_runtime.c"

#include <stdio.h>

static int g_failed;
static char g_msg[256];
#define CK(cond)                                                               \
    do {                                                                       \
        if (!(cond) && !g_failed) {                                            \
            g_failed = 1;                                                      \
            snprintf(g_msg, sizeof g_msg, "line %d: %.200s", __LINE__, #cond); \
        }                                                                      \
    } while (0)

enum {
    Q_VARIANTS = 0x21,
    Q_VARIANT_RECT = 0x23,
    Q_POSITIONS = 0x173,
    Q_POSITION_RECT = 0x175,
    Q_DIGITS = 0x432,
    Q_EXTRA = 0x434,
    Q_LIFE_MIN = 0x452,
    Q_LIFE_MAX = 0x454,
    Q_COUNT_MIN = 0x456,
    Q_COUNT_MAX = 0x458,
    Q_LIMIT = 0x45a,
    Q_FACTOR = 0x45c
};

typedef struct {
    TqzObject o;
    TqzWorld world;
    uint8_t body[TQZ_BODY_BYTES];
    TqzHost host;
    int32_t rq[64]; /* scripted _rand results */
    unsigned rn, ri;
    uint32_t tq[8]; /* scripted GetTickCount results */
    unsigned tn, ti;
    int overrun;
    int32_t view[4];
    char log[512];
} F;

static void t_put16(uint8_t *b, size_t off, int v)
{
    b[off] = (uint8_t)v;
    b[off + 1] = (uint8_t)((unsigned)v >> 8);
}
static void t_put32(uint8_t *b, size_t off, int32_t v)
{
    for (int i = 0; i < 4; ++i) b[off + (size_t)i] = (uint8_t)((uint32_t)v >> (8 * i));
}
static void t_put_rect(uint8_t *b, size_t off, int32_t l, int32_t t, int32_t r, int32_t bt)
{
    t_put32(b, off, l);
    t_put32(b, off + 4, t);
    t_put32(b, off + 8, r);
    t_put32(b, off + 12, bt);
}

static void t_append(F *f, const char *text)
{
    size_t used = strlen(f->log);
    snprintf(f->log + used, sizeof f->log - used, "%s%s", used == 0 ? "" : " ", text);
}

/* Ordered effect observer: the kernel reports every GetTickCount / _rand result and the display / state stores. */
static void t_observe(void *context, int effect, int32_t a, int32_t b)
{
    F *f = (F *)context;
    char text[64];
    switch (effect) {
    case TQZ_FX_TICK: snprintf(text, sizeof text, "tick=%d", (int)a); break;
    case TQZ_FX_RANDOM: snprintf(text, sizeof text, "rand=%d", (int)a); break;
    case TQZ_FX_SET_CLOCK: snprintf(text, sizeof text, "clock=%d:%d", (int)a, (int)b); break;
    case TQZ_FX_SET_SCORE: snprintf(text, sizeof text, "score=%d", (int)a); break;
    case TQZ_FX_STATE: snprintf(text, sizeof text, "state=%d", (int)a); break;
    default: snprintf(text, sizeof text, "fx%d", effect); break;
    }
    t_append(f, text);
}

static int32_t t_random(void *context)
{
    F *f = (F *)context;
    if (f->ri >= f->rn) {
        f->overrun = 1;
        return 0;
    }
    return f->rq[f->ri++];
}

static uint32_t t_tick(void *context)
{
    F *f = (F *)context;
    if (f->ti >= f->tn) {
        f->overrun = 1;
        return 0;
    }
    return f->tq[f->ti++];
}

static int t_view_rects(void *context, int32_t absolute[4], int32_t local[4])
{
    F *f = (F *)context;
    for (int i = 0; i < 4; ++i) {
        absolute[i] = f->view[i];
        local[i] = 0;
    }
    return 0;
}

static void t_init(F *f)
{
    memset(f, 0, sizeof *f);
    f->host.context = f;
    f->host.tick = t_tick;
    f->host.random = t_random;
    f->host.view_rects = t_view_rects;
    f->host.observe = t_observe;
}

static void t_rand(F *f, int count, const int32_t *values)
{
    for (int i = 0; i < count; ++i) f->rq[f->rn++] = values[i];
}

static int t_log_is(const F *f, const char *expected) { return strcmp(f->log, expected) == 0; }

/* All scripted values consumed and none missing. */
static int t_script_done(const F *f) { return f->ri == f->rn && f->ti == f->tn && !f->overrun; }

/* ---- 0x4b832c clock_update ---------------------------------------------------------------------------------------- */

static void clock_run(F *f, int limit, uint32_t start, uint32_t tick, int32_t old_min, int32_t old_sec, int *rc)
{
    t_init(f);
    t_put16(f->body, Q_LIMIT, limit);
    f->o.start_tick = start;
    f->o.minutes = old_min;
    f->o.seconds = old_sec;
    f->tq[f->tn++] = tick;
    *rc = clock_update(&f->o, f->body, &f->world, &f->host);
}

/* 0x4b832c: elapsed = GetTickCount - start (stored at +0x632); remaining = (short)limit - elapsed/1000 (unsigned div);
 * minutes = remaining / 60 (idiv, truncating) clamped to 59; seconds = remaining - minutes*60 clamped to 59; when either
 * differs from the stored +0x626 / +0x62a the pair is stored, negatives are clamped to 0 and 0x446598 (set clock) is called. */
static int test_clock_update(void)
{
    static F f;
    int rc;
    g_failed = 0;

    /* 10500 ms -> 10 s; 125 - 10 = 115 s = 1:55. Old display 0:00 -> changed. */
    clock_run(&f, 125, 1000, 11500, 0, 0, &rc);
    CK(rc == TQZ_OK);
    CK(f.o.elapsed == 10500u);
    CK(f.o.minutes == 1 && f.o.seconds == 55);
    CK(f.world.display.minutes == 1 && f.world.display.seconds == 55);
    CK(t_log_is(&f, "tick=11500 clock=1:55"));

    /* Unchanged pair: no clock call, elapsed still stored. */
    clock_run(&f, 125, 1000, 11500, 1, 55, &rc);
    CK(rc == TQZ_OK && f.o.elapsed == 10500u && t_log_is(&f, "tick=11500"));
    /* Each of the two comparisons alone triggers the update. */
    clock_run(&f, 125, 1000, 11500, 0, 55, &rc);
    CK(rc == TQZ_OK && t_log_is(&f, "tick=11500 clock=1:55") && f.o.minutes == 1 && f.o.seconds == 55);
    clock_run(&f, 125, 1000, 11500, 1, 54, &rc);
    CK(rc == TQZ_OK && t_log_is(&f, "tick=11500 clock=1:55") && f.o.minutes == 1 && f.o.seconds == 55);

    /* Milliseconds truncate: 10999 ms is still 10 s, 11000 ms is 11 s. */
    clock_run(&f, 125, 1000, 1000 + 10999, 1, 55, &rc);
    CK(rc == TQZ_OK && f.o.elapsed == 10999u && t_log_is(&f, "tick=11999"));
    clock_run(&f, 125, 1000, 1000 + 11000, 1, 55, &rc);
    CK(rc == TQZ_OK && t_log_is(&f, "tick=12000 clock=1:54"));

    /* Exact minute boundaries. */
    clock_run(&f, 60, 777, 777, 0, 0, &rc);
    CK(rc == TQZ_OK && f.o.elapsed == 0u && f.o.minutes == 1 && f.o.seconds == 0 && t_log_is(&f, "tick=777 clock=1:0"));
    clock_run(&f, 59, 777, 777, 1, 0, &rc);
    CK(rc == TQZ_OK && f.o.minutes == 0 && f.o.seconds == 59 && t_log_is(&f, "tick=777 clock=0:59"));

    /* Clamps to 59 before the comparison: 3600 s would be 60:00 -> minutes 59, seconds 60 -> 59. */
    clock_run(&f, 3600, 0, 0, 0, 0, &rc);
    CK(rc == TQZ_OK && f.o.minutes == 59 && f.o.seconds == 59 && t_log_is(&f, "tick=0 clock=59:59"));
    clock_run(&f, 3600, 0, 0, 59, 59, &rc);
    CK(rc == TQZ_OK && t_log_is(&f, "tick=0"));
    clock_run(&f, 3599, 0, 0, 59, 59, &rc);
    CK(rc == TQZ_OK && t_log_is(&f, "tick=0"));
    clock_run(&f, 32767, 0, 0, 0, 0, &rc);
    CK(rc == TQZ_OK && f.o.minutes == 59 && f.o.seconds == 59 && t_log_is(&f, "tick=0 clock=59:59"));

    /* Negative remaining: idiv truncates, so -5 s is minutes 0, seconds -5 (!= stored 0 -> update), stored clamped to 0:0. */
    clock_run(&f, 10, 0, 15000, 0, 0, &rc);
    CK(rc == TQZ_OK && f.o.minutes == 0 && f.o.seconds == 0 && t_log_is(&f, "tick=15000 clock=0:0"));
    CK(f.world.display.minutes == 0 && f.world.display.seconds == 0);
    /* -65 s: minutes -1, seconds -5, both clamped to 0. -60 s: minutes -1 differs from stored 0. */
    clock_run(&f, 10, 0, 75000, 0, 0, &rc);
    CK(rc == TQZ_OK && f.o.minutes == 0 && f.o.seconds == 0 && t_log_is(&f, "tick=75000 clock=0:0"));
    clock_run(&f, 10, 0, 70000, 0, 0, &rc);
    CK(rc == TQZ_OK && f.o.minutes == 0 && f.o.seconds == 0 && t_log_is(&f, "tick=70000 clock=0:0"));
    /* The time limit is a signed short. */
    clock_run(&f, -30, 0, 0, 5, 5, &rc);
    CK(rc == TQZ_OK && f.o.minutes == 0 && f.o.seconds == 0 && t_log_is(&f, "tick=0 clock=0:0"));

    /* Unsigned arithmetic: start 5, tick 4 -> elapsed 0xFFFFFFFF, 4294967 s, remaining far below zero -> 0:00. */
    clock_run(&f, 100, 5, 4, 1, 40, &rc);
    CK(rc == TQZ_OK && f.o.elapsed == 0xFFFFFFFFu && f.o.minutes == 0 && f.o.seconds == 0 && t_log_is(&f, "tick=4 clock=0:0"));
    /* Tick counter wrap: start 0xFFFFFFFB, tick 5 -> elapsed 10 ms; 125 s -> 2:05. */
    clock_run(&f, 125, 0xFFFFFFFBu, 5, 0, 0, &rc);
    CK(rc == TQZ_OK && f.o.elapsed == 10u && f.o.minutes == 2 && f.o.seconds == 5 && t_log_is(&f, "tick=5 clock=2:5"));

    CK(t_script_done(&f));
    return g_failed;
}

/* ---- 0x4b844d score_update ---------------------------------------------------------------------------------------- */

static void score_run(F *f, uint32_t elapsed, int32_t hits, int factor, int limit, int32_t score0, int32_t prev, int32_t state0,
                      int *rc)
{
    t_init(f);
    t_put16(f->body, Q_FACTOR, factor);
    t_put16(f->body, Q_LIMIT, limit);
    f->o.elapsed = elapsed;
    f->o.hits = hits;
    f->o.score = score0;
    f->o.prev_score = prev;
    f->o.state = state0;
    *rc = score_update(&f->o, f->body, &f->world, &f->host);
}

/* 0x4b844d: secs = elapsed/1000 (unsigned); when secs > 0 and hits != 0: score = (short)__ftol(float(hits as a qword) /
 * (float(factor) * float(secs)) * 60.0f stored as a float); when score != prev (+0x556) 0x44655e (set score) is called;
 * when (short)limit <= secs the state (+0x10) becomes 1. */
static int test_score_update(void)
{
    static F f;
    int rc;
    g_failed = 0;

    /* 3 hits / (2 * 10 s) * 60 = 9. */
    score_run(&f, 10000, 3, 2, 100, 0, 0, 0, &rc);
    CK(rc == TQZ_OK && f.o.score == 9 && f.o.state == 0 && t_log_is(&f, "score=9") && f.world.display.score == 9);
    score_run(&f, 10000, 3, 2, 100, 0, 9, 0, &rc);
    CK(rc == TQZ_OK && f.o.score == 9 && t_log_is(&f, ""));

    /* __ftol truncates toward zero: 1/7*60 = 8.57 -> 8, 11/(1*7)*60 = 94.28 -> 94. Milliseconds below a second are dropped. */
    score_run(&f, 1999, 1, 7, 100, 0, 8, 0, &rc);
    CK(rc == TQZ_OK && f.o.score == 8 && t_log_is(&f, ""));
    score_run(&f, 7500, 11, 1, 100, 0, 94, 0, &rc);
    CK(rc == TQZ_OK && f.o.score == 94 && t_log_is(&f, ""));

    /* secs == 0 or hits == 0: the score is not recomputed, only compared with the previous one. */
    score_run(&f, 999, 5, 1, 100, 77, 77, 0, &rc);
    CK(rc == TQZ_OK && f.o.score == 77 && t_log_is(&f, ""));
    score_run(&f, 999, 5, 1, 100, 77, 0, 0, &rc);
    CK(rc == TQZ_OK && f.o.score == 77 && t_log_is(&f, "score=77"));
    score_run(&f, 5000, 0, 1, 100, 33, 0, 0, &rc);
    CK(rc == TQZ_OK && f.o.score == 33 && t_log_is(&f, "score=33"));

    /* The factor is a signed word: 3 / (-2 * 10) * 60 = -9. */
    score_run(&f, 10000, 3, -2, 100, 0, -9, 0, &rc);
    CK(rc == TQZ_OK && f.o.score == -9 && t_log_is(&f, ""));

    /* The result is the low 16 bits of the 64-bit __ftol result, sign extended (movsx edx, ax):
     * 1100 * 60 = 66000 -> 464; 600 * 60 = 36000 -> -29536. */
    score_run(&f, 1000, 1100, 1, 100, 0, 464, 0, &rc);
    CK(rc == TQZ_OK && f.o.score == 464 && t_log_is(&f, ""));
    score_run(&f, 1000, 600, 1, 100, 0, -29536, 0, &rc);
    CK(rc == TQZ_OK && f.o.score == -29536 && t_log_is(&f, ""));

    /* The hits dword is loaded as a qword with a zero high half (fild qword): 0xFFFFFFFF is 4294967295, not -1.
     * float(4294967295) = 2^32, * 60 = 60 * 2^32 whose low 16 bits are 0. */
    score_run(&f, 1000, -1, 1, 100, 123, 5, 0, &rc);
    CK(rc == TQZ_OK && f.o.score == 0 && t_log_is(&f, "score=0"));
    /* Zero factor: x87 divide by zero gives +inf, __ftol stores the integer indefinite 0x8000000000000000, low word 0. */
    score_run(&f, 10000, 3, 0, 100, 123, 7, 0, &rc);
    CK(rc == TQZ_OK && f.o.score == 0 && t_log_is(&f, "score=0"));
    /* hits is rounded to a float first (fstp dword): 16777217 -> 16777216, * 60 = 15 * 2^26, low word 0 (an exact double
     * product would give 60). */
    score_run(&f, 1000, 16777217, 1, 100, 99, 0, 0, &rc);
    CK(rc == TQZ_OK && f.o.score == 0 && t_log_is(&f, ""));
    /* The scaled value is rounded to a float before the truncation: 3355443 * 60 = 201326580 -> 201326576 (ulp 16),
     * low word 65520 = -16 (the exact value would give -12). */
    score_run(&f, 1000, 3355443, 1, 100, 0, -16, 0, &rc);
    CK(rc == TQZ_OK && f.o.score == -16 && t_log_is(&f, ""));

    /* End of time: limit <= secs sets the state to 1 (signed compare), also from state 2; otherwise it is untouched. */
    score_run(&f, 10000, 0, 1, 10, 0, 0, 0, &rc);
    CK(rc == TQZ_OK && f.o.state == 1 && t_log_is(&f, "state=1"));
    score_run(&f, 10000, 0, 1, 10, 0, 0, 2, &rc);
    CK(rc == TQZ_OK && f.o.state == 1 && t_log_is(&f, "state=1"));
    score_run(&f, 10999, 0, 1, 11, 0, 0, 0, &rc);
    CK(rc == TQZ_OK && f.o.state == 0 && t_log_is(&f, ""));
    score_run(&f, 0, 0, 1, 0, 0, 0, 0, &rc);
    CK(rc == TQZ_OK && f.o.state == 1 && t_log_is(&f, "state=1"));
    score_run(&f, 0, 0, 1, -1, 0, 0, 0, &rc);
    CK(rc == TQZ_OK && f.o.state == 1 && t_log_is(&f, "state=1"));
    score_run(&f, 0, 0, 1, 1, 0, 0, 0, &rc);
    CK(rc == TQZ_OK && f.o.state == 0 && t_log_is(&f, ""));
    /* Order: the score store precedes the state change. */
    score_run(&f, 10000, 3, 2, 10, 0, 0, 0, &rc);
    CK(rc == TQZ_OK && f.o.score == 9 && f.o.state == 1 && t_log_is(&f, "score=9 state=1"));
    /* Unsigned seconds: elapsed 0xFFFFFFFF is 4294967 s, so 1/4294967*60 truncates to 0 and the time is up. */
    score_run(&f, 0xFFFFFFFFu, 1, 1, 100, 5, 4, 0, &rc);
    CK(rc == TQZ_OK && f.o.score == 0 && f.o.state == 1 && t_log_is(&f, "score=0 state=1"));

    CK(t_script_done(&f));
    return g_failed;
}

/* ---- 0x4b85f6 pick_char ------------------------------------------------------------------------------------------- */

typedef struct {
    int rc;
    uint8_t ch;
} PC;

static PC pc_run(F *f, int max_char, int digits, int count, const int32_t *values)
{
    PC r;
    t_init(f);
    f->o.max_char = (int16_t)max_char;
    f->body[Q_DIGITS] = (uint8_t)digits;
    t_rand(f, count, values);
    r.ch = 0xee;
    r.rc = pick_char(&f->o, f->body, &f->host, &r.ch);
    return r;
}

/* 0x4b85f6: repeat { c = _rand() % (max_char - base) + base (base 0x30 when body+0x432 is set, else 0x41; max_char the word at
 * obj+0x63b; idiv, the low byte kept) } until 0x4b8520 accepts c (letters; digits when the flag is set; any of the 30 bytes
 * at body+0x434 when its first byte is nonzero); returns c. */
static int test_pick_char(void)
{
    static F f;
    PC r;
    g_failed = 0;

    /* Letters only: base 'A', span 26 (max_char 0x5b). */
    {
        const int32_t a[] = {0}, z[] = {25}, w[] = {26}, big[] = {32767};
        r = pc_run(&f, 0x5b, 0, 1, a);
        CK(r.rc == TQZ_OK && r.ch == 'A' && t_log_is(&f, "rand=0") && t_script_done(&f));
        r = pc_run(&f, 0x5b, 0, 1, z);
        CK(r.rc == TQZ_OK && r.ch == 'Z' && t_script_done(&f));
        r = pc_run(&f, 0x5b, 0, 1, w);
        CK(r.rc == TQZ_OK && r.ch == 'A' && t_script_done(&f)); /* 26 % 26 = 0 */
        r = pc_run(&f, 0x5b, 0, 1, big);
        CK(r.rc == TQZ_OK && r.ch == 'H' && t_script_done(&f)); /* 32767 % 26 = 7 */
    }
    /* Rejected characters redraw: span 58 (max_char 0x7b). 26 -> '[' rejected, 40 -> 'i'. */
    {
        const int32_t a[] = {26, 40}, b[] = {31, 32}, c[] = {57}, d[] = {58};
        r = pc_run(&f, 0x7b, 0, 2, a);
        CK(r.rc == TQZ_OK && r.ch == 'i' && t_log_is(&f, "rand=26 rand=40") && t_script_done(&f));
        r = pc_run(&f, 0x7b, 0, 2, b); /* 0x60 '`' rejected, 0x61 'a' accepted */
        CK(r.rc == TQZ_OK && r.ch == 'a' && t_log_is(&f, "rand=31 rand=32") && t_script_done(&f));
        r = pc_run(&f, 0x7b, 0, 1, c);
        CK(r.rc == TQZ_OK && r.ch == 'z' && t_script_done(&f));
        r = pc_run(&f, 0x7b, 0, 1, d); /* 58 % 58 = 0 */
        CK(r.rc == TQZ_OK && r.ch == 'A' && t_script_done(&f));
    }
    /* Digits flag: base '0'. max_char 0x3a gives span 10. */
    {
        const int32_t a[] = {10}, b[] = {19}, c[] = {10, 17}, d[] = {0};
        r = pc_run(&f, 0x3a, 1, 1, a);
        CK(r.rc == TQZ_OK && r.ch == '0' && t_script_done(&f));
        r = pc_run(&f, 0x3a, 1, 1, b);
        CK(r.rc == TQZ_OK && r.ch == '9' && t_script_done(&f));
        /* span 43 (max_char 0x5b): 10 -> ':' rejected, 17 -> 'A'; 0 -> '0'. */
        r = pc_run(&f, 0x5b, 1, 2, c);
        CK(r.rc == TQZ_OK && r.ch == 'A' && t_log_is(&f, "rand=10 rand=17") && t_script_done(&f));
        r = pc_run(&f, 0x5b, 1, 1, d);
        CK(r.rc == TQZ_OK && r.ch == '0' && t_script_done(&f));
    }
    /* Extra characters: accepted only when body[+0x434] is nonzero; the first byte is itself part of the list, the list is
     * 30 bytes long (index 30 is not compared). span 62 (max_char 0x7f). */
    {
        const int32_t first[] = {26}, last[] = {29}, beyond[] = {30, 0}, off[] = {26, 0};
        t_init(&f);
        f.o.max_char = 0x7f;
        f.body[Q_EXTRA] = '[';
        t_rand(&f, 1, first);
        r.rc = pick_char(&f.o, f.body, &f.host, &r.ch);
        CK(r.rc == TQZ_OK && r.ch == '[' && t_script_done(&f));

        t_init(&f);
        f.o.max_char = 0x7f;
        f.body[Q_EXTRA] = '[';
        f.body[Q_EXTRA + 29] = '^';
        t_rand(&f, 1, last);
        r.rc = pick_char(&f.o, f.body, &f.host, &r.ch);
        CK(r.rc == TQZ_OK && r.ch == '^' && t_script_done(&f));

        t_init(&f);
        f.o.max_char = 0x7f;
        f.body[Q_EXTRA] = '[';
        f.body[Q_EXTRA + 30] = '_'; /* body+0x452, outside the 30-byte list */
        t_rand(&f, 2, beyond);
        r.rc = pick_char(&f.o, f.body, &f.host, &r.ch);
        CK(r.rc == TQZ_OK && r.ch == 'A' && t_log_is(&f, "rand=30 rand=0") && t_script_done(&f));

        t_init(&f);
        f.o.max_char = 0x7f;
        f.body[Q_EXTRA + 1] = '['; /* first byte zero: the extra list is ignored */
        t_rand(&f, 2, off);
        r.rc = pick_char(&f.o, f.body, &f.host, &r.ch);
        CK(r.rc == TQZ_OK && r.ch == 'A' && t_log_is(&f, "rand=26 rand=0") && t_script_done(&f));
    }
    /* The character is the low byte: max_char 0x200, span 447, 65 + 257 = 322 = 0x142 -> 'B'. */
    {
        const int32_t a[] = {257};
        r = pc_run(&f, 0x200, 0, 1, a);
        CK(r.rc == TQZ_OK && r.ch == 'B' && t_script_done(&f));
    }
    /* max_char is a signed word: -1 gives span -66 and idiv keeps the dividend's sign: 70 % -66 = 4 -> 'E'. */
    {
        const int32_t a[] = {70};
        r = pc_run(&f, -1, 0, 1, a);
        CK(r.rc == TQZ_OK && r.ch == 'E' && t_script_done(&f));
    }
    return g_failed;
}

/* ---- 0x4b866e pick_position --------------------------------------------------------------------------------------- */

/* Position rectangle c: left 40 + 20c, top 60 + 30c (right and bottom are not compared). View origin (10, 20), so a balloon on
 * position c has dst left 50 + 20c and top 80 + 30c. */
static void pp_setup(F *f, int n)
{
    t_init(f);
    t_put16(f->body, Q_POSITIONS, n);
    for (int c = 0; c < n; ++c) t_put_rect(f->body, Q_POSITION_RECT + (size_t)c * 16u, 40 + 20 * c, 60 + 30 * c, 90 + 20 * c, 100 + 30 * c);
}

static void pp_balloon(F *f, int k, int state, int32_t left, int32_t top)
{
    f->o.balloon[k].state = state;
    f->o.balloon[k].dst[0] = left;
    f->o.balloon[k].dst[1] = top;
}

static int pp_run(F *f, int count, const int32_t *values, int16_t *out)
{
    *out = -99;
    t_rand(f, count, values);
    return pick_position(&f->o, f->body, &f->host, 10, 20, out);
}

/* 0x4b866e: c = _rand() % N (word at body+0x173); while some balloon (index < N) has state != 0 and (dst top - view y,
 * dst left - view x) equal to the top / left of position rectangle c, draw again; returns c. */
static int test_pick_position(void)
{
    static F f;
    int16_t c;
    g_failed = 0;

    /* Free: one draw, c = 13 % 5 = 3. */
    {
        const int32_t q[] = {13};
        pp_setup(&f, 5);
        CK(pp_run(&f, 1, q, &c) == TQZ_OK && c == 3 && t_log_is(&f, "rand=13") && t_script_done(&f));
    }
    /* Occupied by a flying balloon on position 3 (left 110, top 170): redraw, 7 % 5 = 2. */
    {
        const int32_t q[] = {13, 7};
        pp_setup(&f, 5);
        pp_balloon(&f, 1, TQZ_BALLOON_FLYING, 110, 170);
        CK(pp_run(&f, 2, q, &c) == TQZ_OK && c == 2 && t_log_is(&f, "rand=13 rand=7") && t_script_done(&f));
    }
    /* Any nonzero state blocks (popping, gone); state 0 does not. */
    {
        const int32_t q2[] = {13, 7}, q1[] = {13};
        pp_setup(&f, 5);
        pp_balloon(&f, 0, TQZ_BALLOON_POPPING, 110, 170);
        CK(pp_run(&f, 2, q2, &c) == TQZ_OK && c == 2 && t_script_done(&f));
        pp_setup(&f, 5);
        pp_balloon(&f, 4, TQZ_BALLOON_GONE, 110, 170);
        CK(pp_run(&f, 2, q2, &c) == TQZ_OK && c == 2 && t_script_done(&f));
        pp_setup(&f, 5);
        pp_balloon(&f, 2, TQZ_BALLOON_FREE, 110, 170);
        CK(pp_run(&f, 1, q1, &c) == TQZ_OK && c == 3 && t_script_done(&f));
    }
    /* Both coordinates must match: left only, top only, and the unshifted rectangle (view origin not subtracted) do not block. */
    {
        const int32_t q[] = {13};
        pp_setup(&f, 5);
        pp_balloon(&f, 0, TQZ_BALLOON_FLYING, 110, 171);
        pp_balloon(&f, 1, TQZ_BALLOON_FLYING, 111, 170);
        pp_balloon(&f, 2, TQZ_BALLOON_FLYING, 100, 150);
        CK(pp_run(&f, 1, q, &c) == TQZ_OK && c == 3 && t_log_is(&f, "rand=13") && t_script_done(&f));
    }
    /* Only balloons below the position count are scanned (N = 3): balloon 5 on position 1 does not block, balloon 2 does. */
    {
        const int32_t q1[] = {1}, q2[] = {1, 2};
        pp_setup(&f, 3);
        pp_balloon(&f, 5, TQZ_BALLOON_FLYING, 70, 110);
        CK(pp_run(&f, 1, q1, &c) == TQZ_OK && c == 1 && t_script_done(&f));
        pp_setup(&f, 3);
        pp_balloon(&f, 2, TQZ_BALLOON_FLYING, 70, 110);
        CK(pp_run(&f, 2, q2, &c) == TQZ_OK && c == 2 && t_log_is(&f, "rand=1 rand=2") && t_script_done(&f));
    }
    /* Chain of redraws: positions 3 and 2 taken, 13 -> 3, 12 -> 2, 11 -> 1. */
    {
        const int32_t q[] = {13, 12, 11};
        pp_setup(&f, 5);
        pp_balloon(&f, 0, TQZ_BALLOON_FLYING, 110, 170);
        pp_balloon(&f, 1, TQZ_BALLOON_FLYING, 90, 140);
        CK(pp_run(&f, 3, q, &c) == TQZ_OK && c == 1 && t_log_is(&f, "rand=13 rand=12 rand=11") && t_script_done(&f));
    }
    /* Modulo edges: N = 1 always gives 0; 32767 % 6 = 1. */
    {
        const int32_t q1[] = {32767}, q6[] = {32767};
        pp_setup(&f, 1);
        CK(pp_run(&f, 1, q1, &c) == TQZ_OK && c == 0 && t_script_done(&f));
        pp_setup(&f, 6);
        CK(pp_run(&f, 1, q6, &c) == TQZ_OK && c == 1 && t_script_done(&f));
    }
    return g_failed;
}

/* ---- 0x4b8783 first_wave ------------------------------------------------------------------------------------------ */

/* Body: balloon count 2..4, 4 positions, 3 variants, lifetime 5..9, view origin (7, 11), letters only.
 * Position rectangles (left, top, right, bottom): c0 10,20,41,45; c1 60,60,91,85; c2 110,100,141,125; c3 200,100,213,87.
 * Variant rectangle v: 100 + 10v .. 103 + 10v. */
static void fw_setup(F *f, int cmin, int cmax)
{
    static const int32_t pr[4][4] = {{10, 20, 41, 45}, {60, 60, 91, 85}, {110, 100, 141, 125}, {200, 100, 213, 87}};
    t_init(f);
    f->view[0] = 7;
    f->view[1] = 11;
    t_put16(f->body, Q_COUNT_MIN, cmin);
    t_put16(f->body, Q_COUNT_MAX, cmax);
    t_put16(f->body, Q_POSITIONS, 4);
    t_put16(f->body, Q_VARIANTS, 3);
    t_put16(f->body, Q_LIFE_MIN, 5);
    t_put16(f->body, Q_LIFE_MAX, 9);
    for (int c = 0; c < 4; ++c) t_put_rect(f->body, Q_POSITION_RECT + (size_t)c * 16u, pr[c][0], pr[c][1], pr[c][2], pr[c][3]);
    for (int v = 0; v < 3; ++v) t_put_rect(f->body, Q_VARIANT_RECT + (size_t)v * 16u, 100 + 10 * v, 101 + 10 * v, 102 + 10 * v, 103 + 10 * v);
    /* Stale balloons from an earlier wave, every one on position 0 of this view. */
    for (int k = 0; k < TQZ_BALLOONS; ++k) {
        TqzBalloon *b = &f->o.balloon[k];
        b->state = TQZ_BALLOON_FLYING;
        b->dst[0] = 17;
        b->dst[1] = 31;
        b->dst[2] = 48;
        b->dst[3] = 56;
        b->ch = 'Q';
        b->lifetime = 33;
        b->spawn = 1234;
    }
}

static int fw_balloon_is(const TqzBalloon *b, const int32_t src[4], const int32_t dst[4], int32_t text_x, int32_t text_y, uint8_t ch,
                         uint32_t spawn, int16_t life)
{
    return memcmp(b->src, src, sizeof b->src) == 0 && memcmp(b->dst, dst, sizeof b->dst) == 0 && b->text_x == text_x &&
           b->text_y == text_y && b->ch == ch && b->spawn == spawn && b->lifetime == life && b->state == TQZ_BALLOON_FLYING;
}

static int fw_cleared_from(const TqzObject *o, int from)
{
    for (int k = from; k < TQZ_BALLOONS; ++k) {
        const TqzBalloon *b = &o->balloon[k];
        if (b->state != 0 || b->ch != 0 || b->lifetime != 0 || b->spawn != 0 || b->deadline != 0 || b->text_x != 0 ||
            b->text_y != 0)
            return 0;
        for (int i = 0; i < 4; ++i)
            if (b->src[i] != 0 || b->dst[i] != 0) return 0;
    }
    return 1;
}

/* 0x4b8783: count = _rand() % (max - min + 1) + min (words at body+0x458 / +0x456) stored at +0x48; the 20 balloon records
 * (0x113 dwords) are cleared; then for each balloon in turn: pick position (0x4b866e), copy its rectangle and add the view
 * origin (x to left / right, y to top / bottom), text_y = bottom - (bottom - top) / 2 + 6 and text_x = right - (right - left) / 2
 * - 8 (truncating), _rand % variants selects the source rectangle, state := 1, character (0x4b85f6), GetTickCount, lifetime =
 * _rand() % (max - min + 1) + min. */
static int test_first_wave(void)
{
    static F f;
    g_failed = 0;

    /* Two balloons; the second first draws the position the first took and has to redraw; the third character draw is
     * rejected ('[' with max_char 0x7b). */
    {
        const int32_t q[] = {3, 4, 7, 12, 13, 8, 5, 2, 26, 40, 4};
        const int32_t src1[4] = {110, 111, 112, 113}, dst0[4] = {17, 31, 48, 56};
        const int32_t src2[4] = {120, 121, 122, 123}, dst1[4] = {67, 71, 98, 96};
        fw_setup(&f, 2, 4);
        f.o.max_char = 0x7b;
        f.o.count = 17;
        t_rand(&f, 11, q);
        f.tq[f.tn++] = 5000;
        f.tq[f.tn++] = 5100;
        CK(first_wave(&f.o, f.body, &f.host) == TQZ_OK);
        CK(f.o.count == 2); /* 3 % 3 + 2 */
        CK(fw_balloon_is(&f.o.balloon[0], src1, dst0, 25, 50, 'M', 5000, 8));
        CK(fw_balloon_is(&f.o.balloon[1], src2, dst1, 75, 90, 'i', 5100, 9));
        CK(fw_cleared_from(&f.o, 2));
        CK(t_log_is(&f, "rand=3 rand=4 rand=7 rand=12 tick=5000 rand=13 rand=8 rand=5 rand=2 rand=26 rand=40 tick=5100 rand=4"));
        CK(t_script_done(&f));
    }
    /* Maximum count 4 (2 % 3 + 2), each position once; position 3 has bottom above top, where the halving truncates toward
     * zero: (98 - 111) / 2 = -6, text_y = 98 + 6 + 6 = 110. Per balloon: position draw 4 + k, variant draw 3 + k (variants
     * 0, 1, 2, 0), character draw 2k ('A', 'C', 'E', 'G'), lifetime draw 7 + k (7, 8, 9, 5). */
    {
        const int32_t s0[4] = {100, 101, 102, 103}, s1[4] = {110, 111, 112, 113}, s2[4] = {120, 121, 122, 123};
        const int32_t d0[4] = {17, 31, 48, 56}, d1[4] = {67, 71, 98, 96}, d2[4] = {117, 111, 148, 136}, d3[4] = {207, 111, 220, 98};
        int32_t seq[17];
        int n = 0;
        fw_setup(&f, 2, 4);
        f.o.max_char = 0x5b;
        seq[n++] = 2;
        for (int k = 0; k < 4; ++k) {
            seq[n++] = 4 + k;
            seq[n++] = 3 + k;
            seq[n++] = 2 * k;
            seq[n++] = 7 + k;
        }
        t_rand(&f, n, seq);
        for (uint32_t k = 0; k < 4; ++k) f.tq[f.tn++] = 100 * (k + 1);
        CK(first_wave(&f.o, f.body, &f.host) == TQZ_OK);
        CK(f.o.count == 4);
        CK(fw_balloon_is(&f.o.balloon[0], s0, d0, 25, 50, 'A', 100, 7));
        CK(fw_balloon_is(&f.o.balloon[1], s1, d1, 75, 90, 'C', 200, 8));
        CK(fw_balloon_is(&f.o.balloon[2], s2, d2, 125, 130, 'E', 300, 9));
        CK(fw_balloon_is(&f.o.balloon[3], s0, d3, 206, 110, 'G', 400, 5));
        CK(fw_cleared_from(&f.o, 4));
        CK(t_script_done(&f));
    }
    /* Count 0 (min = max = 0): only the count draw happens and every stale record is cleared. */
    {
        const int32_t q[] = {9};
        fw_setup(&f, 0, 0);
        f.o.count = 5;
        t_rand(&f, 1, q);
        CK(first_wave(&f.o, f.body, &f.host) == TQZ_OK);
        CK(f.o.count == 0 && fw_cleared_from(&f.o, 0));
        CK(t_log_is(&f, "rand=9") && t_script_done(&f));
    }
    return g_failed;
}

typedef int (*TestFn)(void);
static int run_one(const char *name, TestFn fn)
{
    memset(g_msg, 0, sizeof g_msg);
    if (fn() == 0) {
        printf("PASS %s\n", name);
        return 0;
    }
    printf("FAIL %s: %s\n", name, g_msg);
    return 1;
}

int main(void)
{
    int failures = 0;
    failures += run_one("test_clock_update", test_clock_update);
    failures += run_one("test_score_update", test_score_update);
    failures += run_one("test_pick_char", test_pick_char);
    failures += run_one("test_pick_position", test_pick_position);
    failures += run_one("test_first_wave", test_first_wave);
    return failures;
}
