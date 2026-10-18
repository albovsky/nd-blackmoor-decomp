/* FL-11 direct tests of the static helpers of the raw 0xeb Multibuild puzzle kernel (src/action_family_eb_runtime.c).
 * The kernel is pulled in as a translation unit (same shim pattern as tests/action_family_28_x87_division_fixture.c) so that
 * translate, follow_pointer, rotate_piece and multi_pick can be called directly. Prints "PASS <name>" / "FAIL <name>: <msg>";
 * the exit status is the failure count. Fixtures are synthetic (no original bytes). Expected values are derived by hand from
 * the original GAME.EXE functions 0x47e52f, 0x47f275, 0x47fa11, 0x47fb76 (helpers 0x47e99e, 0x47f19d), not by running the
 * kernel; the object offsets below are written down from the original's displacements (this + 0x....). */
#include "../src/action_family_eb_runtime.c"

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

/* Original displacements: lift flag, previous/moving/previous-translated/moving-translated rectangles, saved rectangle,
 * pointer rectangle, hand width/height (int16), entry table, piece array. */
enum {
    Q_LIFT = 0x134c,
    Q_PREV = 0x1352,
    Q_MOVE = 0x1362,
    Q_PREV_T = 0x1372,
    Q_MOVE_T = 0x1382,
    Q_SAVED = 0x1392,
    Q_PTR = 0x13cf,
    Q_HW = 0x13e3,
    Q_HH = 0x13e5
};
#define QPIECE(i) ((size_t)0x7b4 + (size_t)(i) * 0x25u)
#define QENT(t, k) ((size_t)0x20 + (size_t)(t) * 0x60u + (size_t)(k) * 0x18u)
#define QTYPE(t) ((size_t)0x99 + (size_t)(t) * 0x53u)

typedef struct {
    size_t off, len;
} TRange;

typedef struct {
    EbObject o;
    uint8_t body[EB_BODY_BYTES];
    EbHost host;
    EbView view;
    int calls, fail_at;
    char log[64];
} TF;

static void t_put16(uint8_t *b, size_t off, int v)
{
    b[off] = (uint8_t)v;
    b[off + 1] = (uint8_t)(v >> 8);
}
static int32_t t_get32(const uint8_t *b, size_t off)
{
    return (int32_t)((uint32_t)b[off] | ((uint32_t)b[off + 1] << 8) | ((uint32_t)b[off + 2] << 16) | ((uint32_t)b[off + 3] << 24));
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
static int t_rect_is(const uint8_t *b, size_t off, int32_t l, int32_t t, int32_t r, int32_t bt)
{
    return t_get32(b, off) == l && t_get32(b, off + 4) == t && t_get32(b, off + 8) == r && t_get32(b, off + 12) == bt;
}

/* Number of bytes that differ between two object images outside the listed ranges (stray writes). */
static size_t t_stray(const uint8_t *a, const uint8_t *b, size_t n, const TRange *ranges, size_t nranges)
{
    size_t bad = 0;
    for (size_t i = 0; i < n; ++i) {
        int allowed = 0;
        for (size_t r = 0; r < nranges; ++r)
            if (i >= ranges[r].off && i < ranges[r].off + ranges[r].len) allowed = 1;
        if (!allowed && a[i] != b[i]) ++bad;
    }
    return bad;
}

/* Host mock: the only seam these helpers use is the view (origin and clip). It logs every call in order. */
static int t_view(void *context, EbView *v)
{
    TF *f = (TF *)context;
    size_t used = strlen(f->log);
    ++f->calls;
    snprintf(f->log + used, sizeof f->log - used, "%sview", used == 0 ? "" : ",");
    if (f->calls == f->fail_at) return 1;
    *v = f->view;
    return 0;
}

static void t_init(TF *f, int32_t ox, int32_t oy, int32_t cl, int32_t ct, int32_t cr, int32_t cb)
{
    memset(f, 0, sizeof *f);
    f->host.context = f;
    f->host.view = t_view;
    f->view.origin_x = ox;
    f->view.origin_y = oy;
    f->view.clip[0] = cl;
    f->view.clip[1] = ct;
    f->view.clip[2] = cr;
    f->view.clip[3] = cb;
}

static void t_set_entry(TF *f, int type, int k, int w, int h, int right, int bottom)
{
    const size_t e = QENT(type, k);
    t_put16(f->o.b, e + 0x14, w);
    t_put16(f->o.b, e + 0x16, h);
    t_put32(f->o.b, e + 0xc, right);
    t_put32(f->o.b, e + 0x10, bottom);
}

static void t_set_piece(TF *f, int i, int type, int orient, int32_t l, int32_t t, int32_t r, int32_t bt)
{
    const size_t p = QPIECE(i);
    f->o.b[p + 0x22] = (uint8_t)orient;
    f->o.b[p + 0x23] = (uint8_t)type;
    t_put_rect(f->o.b, p + 2, l, t, r, bt);
    t_put_rect(f->o.b, p + 0x12, 0x11, 0x22, 0x33, 0x44); /* sentinel translated rectangle */
}

/* 0x47e52f: out = in + view origin (left/right += origin_x, top/bottom += origin_y); in the original it reads the two globals
 * 0x583186 / 0x58318a, here the view seam. */
static void test_translate(void)
{
    TF f;
    uint8_t before[EB_OBJECT_BYTES];
    const TRange only_dest[] = {{Q_MOVE_T, 16}};
    int rc;

    /* distinct origin on both axes: x pairs with left and right, y with top and bottom */
    t_init(&f, 10, 20, 0, 0, 0, 0);
    t_put_rect(f.o.b, Q_MOVE, 1, 2, 3, 4);
    t_put_rect(f.o.b, Q_MOVE_T, -9, -9, -9, -9);
    memcpy(before, f.o.b, sizeof before);
    rc = translate(f.o.b, Q_MOVE, Q_MOVE_T, &f.host);
    CK(rc == EB_OK);
    CK(t_rect_is(f.o.b, Q_MOVE_T, 11, 22, 13, 24));
    CK(t_rect_is(f.o.b, Q_MOVE, 1, 2, 3, 4)); /* the source rectangle is not changed */
    CK(strcmp(f.log, "view") == 0);
    CK(t_stray(before, f.o.b, sizeof before, only_dest, 1) == 0);

    /* negative origin and negative coordinates */
    t_init(&f, -100, -7, 0, 0, 0, 0);
    t_put_rect(f.o.b, Q_MOVE, 50, 60, -70, 80);
    rc = translate(f.o.b, Q_MOVE, Q_MOVE_T, &f.host);
    CK(rc == EB_OK && t_rect_is(f.o.b, Q_MOVE_T, -50, 53, -170, 73));

    /* zero origin copies the rectangle */
    t_init(&f, 0, 0, 0, 0, 0, 0);
    t_put_rect(f.o.b, Q_PREV, 5, 6, 7, 8);
    rc = translate(f.o.b, Q_PREV, Q_PREV_T, &f.host);
    CK(rc == EB_OK && t_rect_is(f.o.b, Q_PREV_T, 5, 6, 7, 8));

    /* 32-bit two's complement wrap of the add */
    t_init(&f, 1, 1, 0, 0, 0, 0);
    t_put_rect(f.o.b, Q_MOVE, INT32_MAX, INT32_MAX, INT32_MIN, -1);
    rc = translate(f.o.b, Q_MOVE, Q_MOVE_T, &f.host);
    CK(rc == EB_OK && t_rect_is(f.o.b, Q_MOVE_T, INT32_MIN, INT32_MIN, INT32_MIN + 1, 0));

    /* a failing view leaves the destination alone and reports the host failure (native seam; the original reads globals) */
    t_init(&f, 10, 20, 0, 0, 0, 0);
    f.fail_at = 1;
    t_put_rect(f.o.b, Q_MOVE, 1, 2, 3, 4);
    t_put_rect(f.o.b, Q_MOVE_T, -9, -8, -7, -6);
    rc = translate(f.o.b, Q_MOVE, Q_MOVE_T, &f.host);
    CK(rc == EB_ERR_HOST && t_rect_is(f.o.b, Q_MOVE_T, -9, -8, -7, -6) && strcmp(f.log, "view") == 0);
}

/* 0x47f275: prev := move, prev_t := move_t; move := pointer-rect centre minus half the hand size (halves truncate toward zero),
 * size hand width/height; clamp (0x47f19d); move_t := move + origin; if the copied prev top and bottom are both zero,
 * prev := move and prev_t := move_t. */
static void test_follow_pointer(void)
{
    TF f;
    uint8_t before[EB_OBJECT_BYTES];
    const TRange rects[] = {{Q_PREV, 0x40}};
    int rc;

    /* previous rectangles nonzero: they are the old moving rectangles; centre (320,440), half hand (15,10) */
    t_init(&f, 7, 9, 0, 0, 1000, 1000);
    t_put_rect(f.o.b, Q_PREV, 1, 2, 3, 4);
    t_put_rect(f.o.b, Q_MOVE, 100, 200, 150, 260);
    t_put_rect(f.o.b, Q_PREV_T, 5, 6, 7, 8);
    t_put_rect(f.o.b, Q_MOVE_T, 110, 210, 160, 270);
    t_put_rect(f.o.b, Q_PTR, 300, 400, 340, 480);
    t_put16(f.o.b, Q_HW, 30);
    t_put16(f.o.b, Q_HH, 20);
    memcpy(before, f.o.b, sizeof before);
    rc = follow_pointer(f.o.b, &f.host);
    CK(rc == EB_OK);
    CK(t_rect_is(f.o.b, Q_PREV, 100, 200, 150, 260));
    CK(t_rect_is(f.o.b, Q_PREV_T, 110, 210, 160, 270));
    CK(t_rect_is(f.o.b, Q_MOVE, 305, 430, 335, 450));
    CK(t_rect_is(f.o.b, Q_MOVE_T, 312, 439, 342, 459));
    CK(strcmp(f.log, "view,view") == 0); /* clamp reads the view, then the translate */
    CK(t_stray(before, f.o.b, sizeof before, rects, 1) == 0);

    /* previous top and bottom both zero after the copy: previous rectangles are seeded from the new moving ones */
    t_init(&f, 7, 9, 0, 0, 1000, 1000);
    t_put_rect(f.o.b, Q_MOVE, 5, 0, 6, 0);
    t_put_rect(f.o.b, Q_MOVE_T, 1, 2, 3, 4);
    t_put_rect(f.o.b, Q_PTR, 300, 400, 340, 480);
    t_put16(f.o.b, Q_HW, 30);
    t_put16(f.o.b, Q_HH, 20);
    rc = follow_pointer(f.o.b, &f.host);
    CK(rc == EB_OK && t_rect_is(f.o.b, Q_MOVE, 305, 430, 335, 450) && t_rect_is(f.o.b, Q_MOVE_T, 312, 439, 342, 459));
    CK(t_rect_is(f.o.b, Q_PREV, 305, 430, 335, 450) && t_rect_is(f.o.b, Q_PREV_T, 312, 439, 342, 459));

    /* all-zero old rectangle also seeds */
    t_init(&f, 0, 0, 0, 0, 1000, 1000);
    t_put_rect(f.o.b, Q_PTR, 300, 400, 340, 480);
    t_put16(f.o.b, Q_HW, 30);
    t_put16(f.o.b, Q_HH, 20);
    rc = follow_pointer(f.o.b, &f.host);
    CK(rc == EB_OK && t_rect_is(f.o.b, Q_PREV, 305, 430, 335, 450) && t_rect_is(f.o.b, Q_PREV_T, 305, 430, 335, 450));

    /* only the top zero (bottom nonzero): no seed, previous keeps the old moving rectangle */
    t_init(&f, 7, 9, 0, 0, 1000, 1000);
    t_put_rect(f.o.b, Q_MOVE, 100, 0, 150, 260);
    t_put_rect(f.o.b, Q_MOVE_T, 110, 3, 160, 270);
    t_put_rect(f.o.b, Q_PTR, 300, 400, 340, 480);
    t_put16(f.o.b, Q_HW, 30);
    t_put16(f.o.b, Q_HH, 20);
    rc = follow_pointer(f.o.b, &f.host);
    CK(rc == EB_OK && t_rect_is(f.o.b, Q_PREV, 100, 0, 150, 260) && t_rect_is(f.o.b, Q_PREV_T, 110, 3, 160, 270));
    CK(t_rect_is(f.o.b, Q_MOVE, 305, 430, 335, 450));

    /* only the bottom zero (top nonzero): no seed */
    t_init(&f, 7, 9, 0, 0, 1000, 1000);
    t_put_rect(f.o.b, Q_MOVE, 100, 200, 150, 0);
    t_put_rect(f.o.b, Q_MOVE_T, 110, 210, 160, 4);
    t_put_rect(f.o.b, Q_PTR, 300, 400, 340, 480);
    t_put16(f.o.b, Q_HW, 30);
    t_put16(f.o.b, Q_HH, 20);
    rc = follow_pointer(f.o.b, &f.host);
    CK(rc == EB_OK && t_rect_is(f.o.b, Q_PREV, 100, 200, 150, 0) && t_rect_is(f.o.b, Q_PREV_T, 110, 210, 160, 4));

    /* odd sizes: half of an odd hand size and of an odd pointer extent truncates; centre (12,12), hand 5x7 */
    t_init(&f, 1, 1, -1000, -1000, 1000, 1000);
    t_put_rect(f.o.b, Q_MOVE, 1, 1, 2, 2);
    t_put_rect(f.o.b, Q_PTR, 10, 10, 15, 14);
    t_put16(f.o.b, Q_HW, 5);
    t_put16(f.o.b, Q_HH, 7);
    rc = follow_pointer(f.o.b, &f.host);
    /* x: (15-10)/2=2, +10=12, -5/2=2 -> left 10 (not 9), right 15; y: (14-10)/2=2, +10=12, -7/2=3 -> top 9, bottom 16 */
    CK(rc == EB_OK && t_rect_is(f.o.b, Q_MOVE, 10, 9, 15, 16) && t_rect_is(f.o.b, Q_MOVE_T, 11, 10, 16, 17));

    /* the hand size is a signed 16-bit word and its half truncates toward zero: -5/2 = -2, -7/2 = -3 (centre 12,12) */
    t_init(&f, 0, 0, -1000, -1000, 1000, 1000);
    t_put_rect(f.o.b, Q_MOVE, 1, 1, 2, 2);
    t_put_rect(f.o.b, Q_PTR, 10, 10, 15, 14);
    t_put16(f.o.b, Q_HW, -5);
    t_put16(f.o.b, Q_HH, -7);
    rc = follow_pointer(f.o.b, &f.host);
    CK(rc == EB_OK && t_rect_is(f.o.b, Q_MOVE, 14, 15, 9, 8));

    /* a pointer rectangle with right < left: the half extent is negative and truncates toward zero ((15-20)/2 = -2) */
    t_init(&f, 0, 0, -1000, -1000, 1000, 1000);
    t_put_rect(f.o.b, Q_MOVE, 1, 1, 2, 2);
    t_put_rect(f.o.b, Q_PTR, 20, 20, 15, 15);
    t_put16(f.o.b, Q_HW, 4);
    t_put16(f.o.b, Q_HH, 4);
    rc = follow_pointer(f.o.b, &f.host);
    CK(rc == EB_OK && t_rect_is(f.o.b, Q_MOVE, 16, 16, 20, 20)); /* centre 18, minus 2 */

    /* the pointer rectangle extent is a full 32-bit difference (no 16-bit truncation) */
    t_init(&f, 0, 0, -1000, -1000, 1000, 1000);
    t_put_rect(f.o.b, Q_MOVE, 1, 1, 2, 2);
    t_put_rect(f.o.b, Q_PTR, -100000, -60000, 100000, 60000);
    t_put16(f.o.b, Q_HW, 10);
    t_put16(f.o.b, Q_HH, 10);
    rc = follow_pointer(f.o.b, &f.host);
    CK(rc == EB_OK && t_rect_is(f.o.b, Q_MOVE, -5, -5, 5, 5));

    /* clamp at the top-left of the clip rectangle keeps the size: 40x30 hand at centre (5,5) */
    t_init(&f, 1, 2, 50, 60, 400, 500);
    t_put_rect(f.o.b, Q_MOVE, 1, 1, 2, 2);
    t_put_rect(f.o.b, Q_PTR, 0, 0, 10, 10);
    t_put16(f.o.b, Q_HW, 40);
    t_put16(f.o.b, Q_HH, 30);
    rc = follow_pointer(f.o.b, &f.host);
    CK(rc == EB_OK && t_rect_is(f.o.b, Q_MOVE, 50, 60, 90, 90) && t_rect_is(f.o.b, Q_MOVE_T, 51, 62, 91, 92));

    /* clamp at the bottom-right: unclamped (975,980,1015,1010) */
    t_init(&f, 1, 2, 0, 0, 400, 500);
    t_put_rect(f.o.b, Q_MOVE, 1, 1, 2, 2);
    t_put_rect(f.o.b, Q_PTR, 990, 990, 1000, 1000);
    t_put16(f.o.b, Q_HW, 40);
    t_put16(f.o.b, Q_HH, 30);
    rc = follow_pointer(f.o.b, &f.host);
    CK(rc == EB_OK && t_rect_is(f.o.b, Q_MOVE, 360, 470, 400, 500) && t_rect_is(f.o.b, Q_MOVE_T, 361, 472, 401, 502));

    /* host failure in the clamp: previous already copied, translated moving rectangle untouched */
    t_init(&f, 7, 9, 0, 0, 1000, 1000);
    f.fail_at = 1;
    t_put_rect(f.o.b, Q_MOVE, 100, 200, 150, 260);
    t_put_rect(f.o.b, Q_MOVE_T, 110, 210, 160, 270);
    t_put_rect(f.o.b, Q_PTR, 300, 400, 340, 480);
    t_put16(f.o.b, Q_HW, 30);
    t_put16(f.o.b, Q_HH, 20);
    rc = follow_pointer(f.o.b, &f.host);
    CK(rc == EB_ERR_HOST && t_rect_is(f.o.b, Q_PREV, 100, 200, 150, 260) && t_rect_is(f.o.b, Q_MOVE_T, 110, 210, 160, 270));
    CK(strcmp(f.log, "view") == 0);

    /* host failure in the translate: moving rectangle clamped, translated one untouched */
    t_init(&f, 7, 9, 0, 0, 1000, 1000);
    f.fail_at = 2;
    t_put_rect(f.o.b, Q_MOVE, 100, 200, 150, 260);
    t_put_rect(f.o.b, Q_MOVE_T, 110, 210, 160, 270);
    t_put_rect(f.o.b, Q_PTR, 300, 400, 340, 480);
    t_put16(f.o.b, Q_HW, 30);
    t_put16(f.o.b, Q_HH, 20);
    rc = follow_pointer(f.o.b, &f.host);
    CK(rc == EB_ERR_HOST && t_rect_is(f.o.b, Q_MOVE, 305, 430, 335, 450) && t_rect_is(f.o.b, Q_MOVE_T, 110, 210, 160, 270));
    CK(strcmp(f.log, "view,view") == 0);
}

/* 0x47fa11: lift := 1; saved := piece rect; orientation := (orientation + 1) mod 4; the rectangle is re-centred with the old
 * and new entry widths/heights (16-bit sums, halves truncate), right/bottom := left/top + the new entry rect's right/bottom,
 * clamp (0x47f19d), translate into the second rectangle. */
static void test_rotate_piece(void)
{
    TF f;
    uint8_t before[EB_OBJECT_BYTES];
    size_t p;
    int rc;

    /* piece 2, type 3, orientation 0 -> 1: old entry 40x20, new entry 20x40 (rect right 19, bottom 39) */
    t_init(&f, 5, 6, 0, 0, 1000, 1000);
    t_set_entry(&f, 3, 0, 40, 20, 39, 19);
    t_set_entry(&f, 3, 1, 20, 40, 19, 39);
    t_set_entry(&f, 3, 2, 99, 99, 98, 98); /* neighbours that a wrong index or type would pick */
    t_set_entry(&f, 2, 0, 77, 77, 76, 76);
    t_set_entry(&f, 2, 1, 66, 66, 65, 65);
    t_set_piece(&f, 1, 3, 0, 1, 1, 2, 2);
    t_set_piece(&f, 2, 3, 0, 100, 200, 140, 220);
    t_set_piece(&f, 3, 3, 0, 7, 7, 8, 8);
    memcpy(before, f.o.b, sizeof before);
    p = QPIECE(2);
    rc = rotate_piece(f.o.b, 2, &f.host);
    CK(rc == EB_OK);
    CK(t_get32(f.o.b, Q_LIFT) == 1);
    CK(t_rect_is(f.o.b, Q_SAVED, 100, 200, 140, 220));
    CK(f.o.b[p + 0x22] == 1 && f.o.b[p + 0x23] == 3);
    /* left 100 + 40/2 - 20/2 = 110, top 200 + 20/2 - 40/2 = 190, right 110 + 19, bottom 190 + 39 */
    CK(t_rect_is(f.o.b, p + 2, 110, 190, 129, 229));
    CK(t_rect_is(f.o.b, p + 0x12, 115, 196, 134, 235));
    CK(strcmp(f.log, "view,view") == 0);
    {
        const TRange ranges[] = {{Q_LIFT, 4}, {Q_SAVED, 16}, {p + 2, 0x21}};
        CK(t_stray(before, f.o.b, sizeof before, ranges, 3) == 0);
    }

    /* orientation 3 wraps to 0; entries 30x10 -> 16x8 (rect right 15, bottom 7) */
    t_init(&f, 0, 0, 0, 0, 1000, 1000);
    t_set_entry(&f, 0, 3, 30, 10, 29, 9);
    t_set_entry(&f, 0, 0, 16, 8, 15, 7);
    t_set_entry(&f, 0, 1, 55, 55, 54, 54);
    t_set_piece(&f, 0, 0, 3, 50, 60, 80, 70);
    rc = rotate_piece(f.o.b, 0, &f.host);
    p = QPIECE(0);
    CK(rc == EB_OK && f.o.b[p + 0x22] == 0);
    CK(t_rect_is(f.o.b, Q_SAVED, 50, 60, 80, 70));
    CK(t_rect_is(f.o.b, p + 2, 57, 61, 72, 68)); /* 50 + 15 - 8, 60 + 5 - 4, +15, +7 */
    CK(t_rect_is(f.o.b, p + 0x12, 57, 61, 72, 68));

    /* orientation 1 -> 2 with odd entry sizes and a 16-bit wrap of the centre sum: 41x21 -> 9x11 */
    t_init(&f, 1, 1, -100000, -100000, 100000, 100000);
    t_set_entry(&f, 1, 1, 41, 21, 40, 20);
    t_set_entry(&f, 1, 2, 9, 11, 8, 10);
    t_set_piece(&f, 1, 1, 1, 0x10064, 0x7ffa, 70000, 40000);
    rc = rotate_piece(f.o.b, 1, &f.host);
    p = QPIECE(1);
    CK(rc == EB_OK && f.o.b[p + 0x22] == 2);
    /* left: (int16)(65636 + 20) = 120, - 9/2 = 116; top: (int16)(32762 + 10) = -32764, - 11/2 = -32769 */
    CK(t_rect_is(f.o.b, p + 2, 116, -32769, 124, -32759));
    CK(t_rect_is(f.o.b, p + 0x12, 117, -32768, 125, -32758));

    /* clamp at the bottom: unclamped (160,120,179,159) -> bottom 150, top 150 - 39 */
    t_init(&f, 3, 4, 0, 0, 200, 150);
    t_set_entry(&f, 1, 0, 40, 20, 39, 19);
    t_set_entry(&f, 1, 1, 20, 40, 19, 39);
    t_set_piece(&f, 0, 1, 0, 150, 130, 190, 150);
    rc = rotate_piece(f.o.b, 0, &f.host);
    p = QPIECE(0);
    CK(rc == EB_OK && t_rect_is(f.o.b, p + 2, 160, 111, 179, 150) && t_rect_is(f.o.b, p + 0x12, 163, 115, 182, 154));

    /* clamp at the left: unclamped (20,120,39,159) with clip left 30 -> left 30, right 30 + 19 */
    t_init(&f, 0, 0, 30, 0, 200, 1000);
    t_set_entry(&f, 1, 0, 40, 20, 39, 19);
    t_set_entry(&f, 1, 1, 20, 40, 19, 39);
    t_set_piece(&f, 0, 1, 0, 10, 130, 50, 150);
    rc = rotate_piece(f.o.b, 0, &f.host);
    p = QPIECE(0);
    CK(rc == EB_OK && t_rect_is(f.o.b, p + 2, 30, 120, 49, 159) && t_rect_is(f.o.b, p + 0x12, 30, 120, 49, 159));

    /* host failure in the clamp: the state stores before it stay, the translated rectangle is untouched */
    t_init(&f, 5, 6, 0, 0, 1000, 1000);
    f.fail_at = 1;
    t_set_entry(&f, 3, 0, 40, 20, 39, 19);
    t_set_entry(&f, 3, 1, 20, 40, 19, 39);
    t_set_piece(&f, 0, 3, 0, 100, 200, 140, 220);
    rc = rotate_piece(f.o.b, 0, &f.host);
    p = QPIECE(0);
    CK(rc == EB_ERR_HOST && t_get32(f.o.b, Q_LIFT) == 1 && f.o.b[p + 0x22] == 1);
    CK(t_rect_is(f.o.b, p + 0x12, 0x11, 0x22, 0x33, 0x44) && strcmp(f.log, "view") == 0);

    /* host failure in the translate: rectangle clamped, translated one untouched */
    t_init(&f, 5, 6, 0, 0, 1000, 1000);
    f.fail_at = 2;
    t_set_entry(&f, 3, 0, 40, 20, 39, 19);
    t_set_entry(&f, 3, 1, 20, 40, 19, 39);
    t_set_piece(&f, 0, 3, 0, 100, 200, 140, 220);
    rc = rotate_piece(f.o.b, 0, &f.host);
    p = QPIECE(0);
    CK(rc == EB_ERR_HOST && t_rect_is(f.o.b, p + 2, 110, 190, 129, 229));
    CK(t_rect_is(f.o.b, p + 0x12, 0x11, 0x22, 0x33, 0x44) && strcmp(f.log, "view,view") == 0);
}

/* Body type record fields (original: body + 0x99 + type * 0x53; D rectangle at +0x30, E rectangle at +0x40). */
static void t_set_type_rects(TF *f, int type, const int32_t d[4], const int32_t e[4])
{
    t_put_rect(f->body, QTYPE(type) + 0x30, d[0], d[1], d[2], d[3]);
    t_put_rect(f->body, QTYPE(type) + 0x40, e[0], e[1], e[2], e[3]);
}

/* 0x47fb76: lift := 1; saved := piece rect; if the type's E rectangle is invalid (0x47e99e: top == bottom or left == right)
 * the piece is re-centred on the D rectangle (16-bit centre sums, halves of the D extents truncate), clamped and translated;
 * otherwise the piece rectangle := E and is only translated (no clamp). */
static void test_multi_pick(void)
{
    TF f;
    uint8_t before[EB_OBJECT_BYTES];
    const int32_t d[4] = {10, 20, 45, 50};
    const int32_t d_other[4] = {1000, 1000, 2000, 2000};
    const int32_t e_valid_other[4] = {900, 901, 902, 903};
    const int32_t e_variants[3][4] = {{0, 0, 0, 0}, {5, 7, 50, 7}, {5, 7, 5, 40}};
    size_t p;
    int rc;

    /* E invalid in each of its three ways (all zero, top == bottom, left == right): D-centred. Piece 1 type 1 orientation 2,
     * entry 60x30: left 100 + 30 - (45-10)/2 = 113, top 100 + 15 - (50-20)/2 = 100, right 113 + 35, bottom 100 + 30 */
    for (int v = 0; v < 3; ++v) {
        t_init(&f, 2, 3, 0, 0, 1000, 1000);
        t_set_type_rects(&f, 1, d, e_variants[v]);
        t_set_type_rects(&f, 0, d_other, e_valid_other);
        t_set_entry(&f, 1, 2, 60, 30, 59, 29);
        t_set_entry(&f, 1, 0, 11, 11, 10, 10); /* wrong orientation */
        t_set_entry(&f, 0, 2, 13, 13, 12, 12); /* wrong type */
        t_set_piece(&f, 0, 1, 0, 5, 5, 6, 6);
        t_set_piece(&f, 1, 1, 2, 100, 100, 160, 130);
        memcpy(before, f.o.b, sizeof before);
        p = QPIECE(1);
        rc = multi_pick(f.o.b, f.body, 1, &f.host);
        CK(rc == EB_OK);
        CK(t_get32(f.o.b, Q_LIFT) == 1);
        CK(t_rect_is(f.o.b, Q_SAVED, 100, 100, 160, 130));
        CK(t_rect_is(f.o.b, p + 2, 113, 100, 148, 130));
        CK(t_rect_is(f.o.b, p + 0x12, 115, 103, 150, 133));
        CK(f.o.b[p + 0x22] == 2); /* orientation unchanged */
        CK(strcmp(f.log, "view,view") == 0);
        {
            const TRange ranges[] = {{Q_LIFT, 4}, {Q_SAVED, 16}, {p + 2, 0x20}};
            CK(t_stray(before, f.o.b, sizeof before, ranges, 3) == 0);
        }
    }

    /* E valid: the piece rectangle becomes E, translated, not clamped (clip is tiny) */
    {
        const int32_t e[4] = {300, 310, 340, 360};
        t_init(&f, 2, 3, 0, 0, 100, 100);
        t_set_type_rects(&f, 1, d, e);
        t_set_type_rects(&f, 0, d_other, e_valid_other);
        t_set_entry(&f, 1, 2, 60, 30, 59, 29);
        t_set_piece(&f, 1, 1, 2, 100, 100, 160, 130);
        memcpy(before, f.o.b, sizeof before);
        p = QPIECE(1);
        rc = multi_pick(f.o.b, f.body, 1, &f.host);
        CK(rc == EB_OK && t_get32(f.o.b, Q_LIFT) == 1);
        CK(t_rect_is(f.o.b, Q_SAVED, 100, 100, 160, 130));
        CK(t_rect_is(f.o.b, p + 2, 300, 310, 340, 360));
        CK(t_rect_is(f.o.b, p + 0x12, 302, 313, 342, 363));
        CK(strcmp(f.log, "view") == 0);
        {
            const TRange ranges[] = {{Q_LIFT, 4}, {Q_SAVED, 16}, {p + 2, 0x20}};
            CK(t_stray(before, f.o.b, sizeof before, ranges, 3) == 0);
        }
    }

    /* E (0,0,10,10) has zero edges but nonzero extents: valid */
    {
        const int32_t e[4] = {0, 0, 10, 10};
        t_init(&f, 2, 3, 0, 0, 1000, 1000);
        t_set_type_rects(&f, 1, d, e);
        t_set_piece(&f, 1, 1, 0, 100, 100, 160, 130);
        rc = multi_pick(f.o.b, f.body, 1, &f.host);
        p = QPIECE(1);
        CK(rc == EB_OK && t_rect_is(f.o.b, p + 2, 0, 0, 10, 10) && t_rect_is(f.o.b, p + 0x12, 2, 3, 12, 13));
    }

    /* D path clamped: unclamped (113,100,148,130) with clip right 140 and bottom 120 -> (105,90,140,120) */
    {
        const int32_t e[4] = {0, 0, 0, 0};
        t_init(&f, 2, 3, 0, 0, 140, 120);
        t_set_type_rects(&f, 1, d, e);
        t_set_entry(&f, 1, 2, 60, 30, 59, 29);
        t_set_piece(&f, 1, 1, 2, 100, 100, 160, 130);
        rc = multi_pick(f.o.b, f.body, 1, &f.host);
        p = QPIECE(1);
        CK(rc == EB_OK && t_rect_is(f.o.b, p + 2, 105, 90, 140, 120) && t_rect_is(f.o.b, p + 0x12, 107, 93, 142, 123));
    }

    /* 16-bit wrap of the centre sum: left (int16)(65636 + 30) = 130 - 17 = 113; top (int16)(32762 + 15) = -32759 - 15 */
    {
        const int32_t e[4] = {0, 0, 0, 0};
        t_init(&f, 0, 0, -100000, -100000, 100000, 100000);
        t_set_type_rects(&f, 1, d, e);
        t_set_entry(&f, 1, 2, 60, 30, 59, 29);
        t_set_piece(&f, 1, 1, 2, 0x10064, 0x7ffa, 70000, 40000);
        rc = multi_pick(f.o.b, f.body, 1, &f.host);
        p = QPIECE(1);
        CK(rc == EB_OK && t_rect_is(f.o.b, p + 2, 113, -32774, 148, -32744));
    }

    /* the D extent is a full 32-bit difference: (100000 - -100000)/2 = 100000, left 130 - 100000, right left + 200000 */
    {
        const int32_t dw[4] = {-100000, 20, 100000, 50};
        const int32_t e[4] = {0, 0, 0, 0};
        t_init(&f, 0, 0, -1000000, -1000000, 1000000, 1000000);
        t_set_type_rects(&f, 1, dw, e);
        t_set_entry(&f, 1, 2, 60, 30, 59, 29);
        t_set_piece(&f, 1, 1, 2, 100, 100, 160, 130);
        rc = multi_pick(f.o.b, f.body, 1, &f.host);
        p = QPIECE(1);
        CK(rc == EB_OK && t_rect_is(f.o.b, p + 2, -99870, 100, 100130, 130));
    }

    /* a D extent of -25 halves to -12 (toward zero): left 130 + 12 = 142, right 142 - 25 = 117 */
    {
        const int32_t dn[4] = {70, 20, 45, 50};
        const int32_t e[4] = {0, 0, 0, 0};
        t_init(&f, 0, 0, -1000, -1000, 1000, 1000);
        t_set_type_rects(&f, 1, dn, e);
        t_set_entry(&f, 1, 2, 60, 30, 59, 29);
        t_set_piece(&f, 1, 1, 2, 100, 100, 160, 130);
        rc = multi_pick(f.o.b, f.body, 1, &f.host);
        p = QPIECE(1);
        CK(rc == EB_OK && t_rect_is(f.o.b, p + 2, 142, 100, 117, 130));
    }

    /* host failure: E valid path fails in its only translate (rectangle already E); D path fails in the clamp / translate */
    {
        const int32_t e_ok[4] = {300, 310, 340, 360};
        const int32_t e_bad[4] = {0, 0, 0, 0};
        t_init(&f, 2, 3, 0, 0, 1000, 1000);
        f.fail_at = 1;
        t_set_type_rects(&f, 1, d, e_ok);
        t_set_piece(&f, 1, 1, 2, 100, 100, 160, 130);
        rc = multi_pick(f.o.b, f.body, 1, &f.host);
        p = QPIECE(1);
        CK(rc == EB_ERR_HOST && t_rect_is(f.o.b, p + 2, 300, 310, 340, 360) && t_rect_is(f.o.b, p + 0x12, 0x11, 0x22, 0x33, 0x44));
        CK(strcmp(f.log, "view") == 0);

        t_init(&f, 2, 3, 0, 0, 1000, 1000);
        f.fail_at = 2;
        t_set_type_rects(&f, 1, d, e_bad);
        t_set_entry(&f, 1, 2, 60, 30, 59, 29);
        t_set_piece(&f, 1, 1, 2, 100, 100, 160, 130);
        rc = multi_pick(f.o.b, f.body, 1, &f.host);
        p = QPIECE(1);
        CK(rc == EB_ERR_HOST && t_rect_is(f.o.b, p + 2, 113, 100, 148, 130) && t_rect_is(f.o.b, p + 0x12, 0x11, 0x22, 0x33, 0x44));
        CK(strcmp(f.log, "view,view") == 0);
    }
}

int main(void)
{
    static const struct {
        const char *name;
        void (*fn)(void);
    } cases[] = {
        {"test_translate", test_translate},
        {"test_follow_pointer", test_follow_pointer},
        {"test_rotate_piece", test_rotate_piece},
        {"test_multi_pick", test_multi_pick},
    };
    int failures = 0;
    for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        g_failed = 0;
        g_msg[0] = '\0';
        cases[i].fn();
        if (g_failed) {
            ++failures;
            printf("FAIL %s: %s\n", cases[i].name, g_msg);
        } else {
            printf("PASS %s\n", cases[i].name);
        }
    }
    return failures;
}
