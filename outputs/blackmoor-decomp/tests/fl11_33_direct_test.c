/* FL-11 direct tests of the static helpers of the raw 0x33 secondary-video kernel (src/action_family_33_runtime.c). The kernel
 * is pulled in as a translation unit (same shim pattern as tests/action_family_28_x87_division_fixture.c) so that second_rects
 * and frame_advance can be called directly. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the failure count.
 * Fixtures are synthetic (no original bytes). Expected values are derived by hand from the original GAME.EXE functions
 * 0x42cecd and 0x42d215, not by running the kernel. Rectangles are (left, top, right, bottom); the hotspot's second pair is the
 * source rectangle at +0x22 and the destination rectangle at +0x32 of the 0x42-byte record. */
#include "../src/action_family_33_runtime.c"

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

static int same4(const int32_t *a, int32_t l, int32_t t, int32_t r, int32_t b)
{
    return a[0] == l && a[1] == t && a[2] == r && a[3] == b;
}

typedef struct {
    A33State st;
    A33Hotspot hs;
} SF;

/* View origin (100, 1000); the clip rectangle is {0, 50, 640, 150}. Working rectangles start at a recognisable sentinel. The
 * first pair (src1 / dst1) holds values that must never be touched by the second pair. */
static void sf_init(SF *f, int32_t src_top, int32_t src_bottom, int32_t dst_top, int32_t dst_bottom)
{
    memset(f, 0, sizeof *f);
    f->st.view_x_583186 = 100;
    f->st.view_y_58318a = 1000;
    for (int k = 0; k < 4; ++k) {
        f->st.src2_5b4e38[k] = 7000 + k;
        f->st.dst2_5b4e48[k] = 7010 + k;
        f->st.src1_5b4e18[k] = 7020 + k;
        f->st.dst1_5b4e28[k] = 7030 + k;
        f->st.rel_dst1_5b4e58[k] = 7040 + k;
        f->hs.src1[k] = 9000 + k;
        f->hs.dst1[k] = 9010 + k;
    }
    f->hs.src2[0] = 11;
    f->hs.src2[1] = src_top;
    f->hs.src2[2] = 33;
    f->hs.src2[3] = src_bottom;
    f->hs.dst2[0] = 10;
    f->hs.dst2[1] = dst_top;
    f->hs.dst2[2] = 30;
    f->hs.dst2[3] = dst_bottom;
}

static const int32_t K_RECT[4] = {0, 50, 640, 150};

/* The first-pair arrays and the first relative rectangle are never written by the second pair. */
static int first_pair_untouched(const SF *f)
{
    for (int k = 0; k < 4; ++k) {
        if (f->st.src1_5b4e18[k] != 7020 + k || f->st.dst1_5b4e28[k] != 7030 + k || f->st.rel_dst1_5b4e58[k] != 7040 + k) return 0;
    }
    return 1;
}

/* 0x42cecd: clip the hotspot's second destination rectangle against the clip rectangle's top (rect[1]) and bottom (rect[3]).
 * Entirely inside (top >= rect top and bottom <= rect bottom): source copied whole, destination = (dst - rect top + view y) and
 * (dst + view x), flag 0x5b4e8d := 1. Partially inside: cut at the clip edges, source top/bottom adjusted by the cut amounts.
 * Outside: working rectangles and flag stay as they were. In all cases the relative rectangle (0x5b4e93..) := working
 * destination - view origin. */
static void test_second_rects(void)
{
    SF f;

    /* fully inside: top 60 >= 50, bottom 140 <= 150 */
    sf_init(&f, 22, 44, 60, 140);
    second_rects(&f.st, &f.hs, K_RECT);
    CK(same4(f.st.src2_5b4e38, 11, 22, 33, 44));
    CK(same4(f.st.dst2_5b4e48, 110, 1010, 130, 1090));
    CK(f.st.flag_5b4e8d == 1);
    CK(same4(f.st.rel_dst2_5b4e93, 10, 10, 30, 90));
    CK(first_pair_untouched(&f));

    /* exactly on both clip edges is still fully inside */
    sf_init(&f, 22, 44, 50, 150);
    second_rects(&f.st, &f.hs, K_RECT);
    CK(same4(f.st.src2_5b4e38, 11, 22, 33, 44));
    CK(same4(f.st.dst2_5b4e48, 110, 1000, 130, 1100));
    CK(f.st.flag_5b4e8d == 1);

    /* negative view origin and a clip that starts below zero: dst - rect top + view y with signed arithmetic */
    {
        static const int32_t neg_rect[4] = {0, -20, 640, 40};
        sf_init(&f, 22, 44, -10, 30);
        f.st.view_x_583186 = -5;
        f.st.view_y_58318a = -300;
        second_rects(&f.st, &f.hs, neg_rect);
        CK(same4(f.st.dst2_5b4e48, 5, -290, 25, -250)); /* top -10 + 20 - 300, bottom 30 + 20 - 300 */
        CK(same4(f.st.rel_dst2_5b4e93, 10, 10, 30, 50));
        CK(f.st.flag_5b4e8d == 1);
    }

    /* top cut: dst 20..100 against clip 50..150 -> cut 50..100; source top 22 + (50 - 20), bottom 44 - (100 - 100) */
    sf_init(&f, 22, 44, 20, 100);
    second_rects(&f.st, &f.hs, K_RECT);
    CK(same4(f.st.src2_5b4e38, 11, 52, 33, 44));
    CK(same4(f.st.dst2_5b4e48, 110, 1000, 130, 1050));
    CK(f.st.flag_5b4e8d == 1);
    CK(same4(f.st.rel_dst2_5b4e93, 10, 0, 30, 50));

    /* bottom cut: dst 100..200 -> cut 100..150; source top unchanged 22, bottom 44 - (200 - 150) */
    sf_init(&f, 22, 44, 100, 200);
    second_rects(&f.st, &f.hs, K_RECT);
    CK(same4(f.st.src2_5b4e38, 11, 22, 33, -6));
    CK(same4(f.st.dst2_5b4e48, 110, 1050, 130, 1100));
    CK(f.st.flag_5b4e8d == 1);

    /* both cut: dst 20..200 spans the clip -> cut 50..150; source top 22 + 30, bottom 44 - 50 */
    sf_init(&f, 22, 44, 20, 200);
    second_rects(&f.st, &f.hs, K_RECT);
    CK(same4(f.st.src2_5b4e38, 11, 52, 33, -6));
    CK(same4(f.st.dst2_5b4e48, 110, 1000, 130, 1100));
    CK(f.st.flag_5b4e8d == 1);
    CK(same4(f.st.rel_dst2_5b4e93, 10, 0, 30, 100));

    /* touching edges count as partial: dst 150..300 touches the clip bottom, dst 0..50 touches the clip top */
    sf_init(&f, 22, 44, 150, 300);
    second_rects(&f.st, &f.hs, K_RECT);
    CK(same4(f.st.src2_5b4e38, 11, 22, 33, -106)); /* 44 - (300 - 150) */
    CK(same4(f.st.dst2_5b4e48, 110, 1100, 130, 1100));
    CK(f.st.flag_5b4e8d == 1);
    sf_init(&f, 22, 44, 0, 50);
    second_rects(&f.st, &f.hs, K_RECT);
    CK(same4(f.st.src2_5b4e38, 11, 72, 33, 44)); /* 22 + (50 - 0), bottom 44 - (50 - 50) */
    CK(same4(f.st.dst2_5b4e48, 110, 1000, 130, 1000));
    CK(f.st.flag_5b4e8d == 1);

    /* outside above (bottom 49 < clip top): working rectangles and the flag keep their old values, the relative rectangle is
     * recomputed from the stale destination; a flag that was already 1 stays 1 */
    sf_init(&f, 22, 44, 0, 49);
    second_rects(&f.st, &f.hs, K_RECT);
    CK(same4(f.st.src2_5b4e38, 7000, 7001, 7002, 7003));
    CK(same4(f.st.dst2_5b4e48, 7010, 7011, 7012, 7013));
    CK(f.st.flag_5b4e8d == 0);
    CK(same4(f.st.rel_dst2_5b4e93, 7010 - 100, 7011 - 1000, 7012 - 100, 7013 - 1000));
    CK(first_pair_untouched(&f));
    sf_init(&f, 22, 44, 0, 49);
    f.st.flag_5b4e8d = 1;
    second_rects(&f.st, &f.hs, K_RECT);
    CK(f.st.flag_5b4e8d == 1 && same4(f.st.dst2_5b4e48, 7010, 7011, 7012, 7013));

    /* outside below (top 151 > clip bottom) */
    sf_init(&f, 22, 44, 151, 300);
    second_rects(&f.st, &f.hs, K_RECT);
    CK(same4(f.st.src2_5b4e38, 7000, 7001, 7002, 7003));
    CK(same4(f.st.dst2_5b4e48, 7010, 7011, 7012, 7013));
    CK(f.st.flag_5b4e8d == 0);
    CK(same4(f.st.rel_dst2_5b4e93, 7010 - 100, 7011 - 1000, 7012 - 100, 7013 - 1000));
}

/* 0x42d215: switch on the animation state 0x5b4e14 (frame word 0x5b4e00, body words +0x4c start, +0x4e loop end, +0x52 hold
 * end, +0x56 end-hold): 0 loop (+1, > end wraps to start), 1 hold (+1, > hold end clamps), 2 reverse (-1, < start snaps to
 * start and state 0), 3 end hold (+1, > +0x56 clamps), other values change nothing. Afterwards state 1 with the 32-bit
 * latch 0x5c39e5 != the sign-extended row word 0x5b4e89 becomes 2. */
static void adv(A33State *st, const A33Set *set, int32_t anim, int16_t frame)
{
    st->anim_5b4e14 = anim;
    st->frame_5b4e00 = frame;
    frame_advance(st, set);
}

static void test_frame_advance(void)
{
    A33Set set;
    A33State st;
    memset(&set, 0, sizeof set);
    set.w4c = 3; /* loop start */
    set.w4e = 8; /* loop end */
    set.w52 = 6; /* hold end */
    set.w56 = 9; /* end-hold limit */
    memset(&st, 0, sizeof st);
    st.row_5b4e89 = 5;
    st.latch_5c39e5 = 5;

    /* 0: loop */
    adv(&st, &set, 0, 5);
    CK(st.frame_5b4e00 == 6 && st.anim_5b4e14 == 0);
    adv(&st, &set, 0, 7);
    CK(st.frame_5b4e00 == 8 && st.anim_5b4e14 == 0); /* equal to the end does not wrap */
    adv(&st, &set, 0, 8);
    CK(st.frame_5b4e00 == 3 && st.anim_5b4e14 == 0); /* 9 > 8 wraps to the start */
    adv(&st, &set, 0, 100);
    CK(st.frame_5b4e00 == 3);
    adv(&st, &set, 0, 32767); /* the word increment wraps to -32768, which is not above the end */
    CK(st.frame_5b4e00 == -32768);
    st.latch_5c39e5 = 99; /* state 0 ignores the latch */
    adv(&st, &set, 0, 5);
    CK(st.frame_5b4e00 == 6 && st.anim_5b4e14 == 0);
    st.latch_5c39e5 = 5;

    /* 1: hold at +0x52 (6), latch equal to the row keeps state 1 */
    adv(&st, &set, 1, 4);
    CK(st.frame_5b4e00 == 5 && st.anim_5b4e14 == 1);
    adv(&st, &set, 1, 5);
    CK(st.frame_5b4e00 == 6 && st.anim_5b4e14 == 1);
    adv(&st, &set, 1, 6);
    CK(st.frame_5b4e00 == 6 && st.anim_5b4e14 == 1); /* 7 > 6 clamps */
    adv(&st, &set, 1, 20);
    CK(st.frame_5b4e00 == 6 && st.anim_5b4e14 == 1);
    /* 1: a candidate different from the row moves to state 2 after the frame step; the comparison is 32-bit against the
     * sign-extended row word */
    st.latch_5c39e5 = 6;
    adv(&st, &set, 1, 4);
    CK(st.frame_5b4e00 == 5 && st.anim_5b4e14 == 2);
    st.latch_5c39e5 = -1;
    st.row_5b4e89 = (int16_t)-1;
    adv(&st, &set, 1, 4);
    CK(st.frame_5b4e00 == 5 && st.anim_5b4e14 == 1); /* -1 == sign-extended 0xffff */
    st.latch_5c39e5 = 0xffff;
    adv(&st, &set, 1, 4);
    CK(st.anim_5b4e14 == 2); /* 0xffff != -1 as a 32-bit value */
    st.row_5b4e89 = 5;
    st.latch_5c39e5 = 5;

    /* 2: reverse, snaps to the start with state 0 */
    adv(&st, &set, 2, 6);
    CK(st.frame_5b4e00 == 5 && st.anim_5b4e14 == 2);
    adv(&st, &set, 2, 4);
    CK(st.frame_5b4e00 == 3 && st.anim_5b4e14 == 2); /* 3 is not below 3 */
    adv(&st, &set, 2, 3);
    CK(st.frame_5b4e00 == 3 && st.anim_5b4e14 == 0); /* 2 < 3: frame := 3, state := 0 */
    adv(&st, &set, 2, -32768); /* the word decrement wraps to 32767, not below the start */
    CK(st.frame_5b4e00 == 32767 && st.anim_5b4e14 == 2);
    st.latch_5c39e5 = 77; /* state 2 ignores the latch */
    adv(&st, &set, 2, 6);
    CK(st.frame_5b4e00 == 5 && st.anim_5b4e14 == 2);
    st.latch_5c39e5 = 5;

    /* 3: end hold at +0x56 (9) */
    adv(&st, &set, 3, 5);
    CK(st.frame_5b4e00 == 6 && st.anim_5b4e14 == 3);
    adv(&st, &set, 3, 8);
    CK(st.frame_5b4e00 == 9 && st.anim_5b4e14 == 3);
    adv(&st, &set, 3, 9);
    CK(st.frame_5b4e00 == 9 && st.anim_5b4e14 == 3);
    adv(&st, &set, 3, 50);
    CK(st.frame_5b4e00 == 9);
    st.latch_5c39e5 = 77; /* state 3 ignores the latch */
    adv(&st, &set, 3, 5);
    CK(st.frame_5b4e00 == 6 && st.anim_5b4e14 == 3);
    st.latch_5c39e5 = 5;

    /* any other state value: the frame and the state stay (switch default), even with a differing latch */
    st.latch_5c39e5 = 77;
    adv(&st, &set, 4, 5);
    CK(st.frame_5b4e00 == 5 && st.anim_5b4e14 == 4);
    adv(&st, &set, 9, 5);
    CK(st.frame_5b4e00 == 5 && st.anim_5b4e14 == 9);
    adv(&st, &set, -1, 5);
    CK(st.frame_5b4e00 == 5 && st.anim_5b4e14 == -1);

    /* the loop uses +0x4c / +0x4e only: change the limits and check a state-0 wrap lands on the new start */
    set.w4c = -4;
    set.w4e = -2;
    adv(&st, &set, 0, -2);
    CK(st.frame_5b4e00 == -4 && st.anim_5b4e14 == 0);
    adv(&st, &set, 0, -4);
    CK(st.frame_5b4e00 == -3);
}

int main(void)
{
    static const struct {
        const char *name;
        void (*fn)(void);
    } cases[] = {{"test_second_rects", test_second_rects}, {"test_frame_advance", test_frame_advance}};
    int failures = 0;
    for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        g_failed = 0;
        g_msg[0] = '\0';
        cases[i].fn();
        if (g_failed) {
            printf("FAIL %s: %s\n", cases[i].name, g_msg);
            ++failures;
        } else {
            printf("PASS %s\n", cases[i].name);
        }
    }
    return failures;
}
