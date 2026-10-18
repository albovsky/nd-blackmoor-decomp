/* FL-11 direct tests of the static helpers of the raw 0xea Onebuild puzzle kernel (src/action_family_ea_runtime.c).
 *
 * The helpers are `static`, so this test includes the kernel source (the precedent is
 * tests/action_family_28_x87_division_fixture.c) and calls each helper itself. Prints "PASS <name>" /
 * "FAIL <name>: <message>"; the exit status is the failure count. Fixtures are synthetic object and body byte images
 * (no original bytes). Offsets below are literal and hand-derived from the Ghidra pseudocode of the original GAME.EXE
 * functions, not taken from the kernel's own enums. Every case also checks that no byte outside the fields the original
 * writes was changed. */
#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "../src/action_family_ea_runtime.c"

static int g_failed;
static char g_msg[400];

static void note(int line, const char *fmt, ...)
{
    char tmp[300];
    va_list ap;
    if (g_failed) return;
    g_failed = 1;
    va_start(ap, fmt);
    vsnprintf(tmp, sizeof tmp, fmt, ap);
    va_end(ap);
    snprintf(g_msg, sizeof g_msg, "line %d: %s", line, tmp);
}

#define EXPECT(cond)                                      \
    do {                                                  \
        if (!(cond)) note(__LINE__, "%s", #cond);         \
    } while (0)
#define EXPECT_EQ(a, b)                                                                \
    do {                                                                               \
        const long long a_ = (long long)(a), b_ = (long long)(b);                      \
        if (a_ != b_) note(__LINE__, "%s = %lld, expected %lld", #a, a_, b_);          \
    } while (0)
#define EXPECT_LOG(mk, text)                                                                     \
    do {                                                                                         \
        if (strcmp((mk)->log, (text)) != 0)                                                      \
            note(__LINE__, "log \"%s\" expected \"%s\"", (mk)->log, (text));                     \
    } while (0)

/* Little-endian field access, independent of the kernel's rd_s32 / wr_32. */
static int32_t g32(const uint8_t *b, size_t o)
{
    return (int32_t)((uint32_t)b[o] | ((uint32_t)b[o + 1] << 8) | ((uint32_t)b[o + 2] << 16) | ((uint32_t)b[o + 3] << 24));
}
static void p32(uint8_t *b, size_t o, int32_t v)
{
    for (size_t k = 0; k < 4; ++k) b[o + k] = (uint8_t)((uint32_t)v >> (8u * k));
}
static int16_t g16(const uint8_t *b, size_t o) { return (int16_t)(uint16_t)(b[o] | (b[o + 1] << 8)); }
static void p16(uint8_t *b, size_t o, int v)
{
    b[o] = (uint8_t)(v & 0xff);
    b[o + 1] = (uint8_t)((v >> 8) & 0xff);
}
static void put_rect(uint8_t *b, size_t o, int32_t l, int32_t t, int32_t r, int32_t bt)
{
    p32(b, o, l);
    p32(b, o + 4, t);
    p32(b, o + 8, r);
    p32(b, o + 12, bt);
}

static void rect_check(int line, const uint8_t *b, size_t o, int32_t l, int32_t t, int32_t r, int32_t bt)
{
    if (g32(b, o) != l || g32(b, o + 4) != t || g32(b, o + 8) != r || g32(b, o + 12) != bt)
        note(line, "rect at 0x%zx = (%d,%d,%d,%d), expected (%d,%d,%d,%d)", o, g32(b, o), g32(b, o + 4), g32(b, o + 8),
             g32(b, o + 12), l, t, r, bt);
}
#define EXPECT_RECT(b, o, l, t, r, bt) rect_check(__LINE__, (b), (o), (l), (t), (r), (bt))

/* Bytes that differ between two object images must lie in an allowed [lo, hi) span. */
typedef struct Span {
    size_t lo, hi;
} Span;
#define SP(lo, hi) {(size_t)(lo), (size_t)(hi)}

static void only_check(int line, const uint8_t *before, const uint8_t *after, const Span *spans, size_t ns)
{
    for (size_t i = 0; i < EA_OBJECT_BYTES; ++i) {
        int allowed = 0;
        if (before[i] == after[i]) continue;
        for (size_t s = 0; s < ns; ++s)
            if (i >= spans[s].lo && i < spans[s].hi) allowed = 1;
        if (!allowed) {
            note(line, "stray write at object offset 0x%zx", i);
            return;
        }
    }
}
#define EXPECT_NO_CHANGE(before, after) only_check(__LINE__, (before), (after), NULL, 0)
#define EXPECT_ONLY(before, after, ...)                                                    \
    do {                                                                                   \
        const Span s_[] = {__VA_ARGS__};                                                   \
        only_check(__LINE__, (before), (after), s_, sizeof s_ / sizeof s_[0]);             \
    } while (0)

static void obj_fill(uint8_t *o)
{
    for (size_t i = 0; i < EA_OBJECT_BYTES; ++i) o[i] = (uint8_t)(0x31u + i * 13u);
}

/* Host mock: view cells, surface calls with a log in call order. */
typedef struct Mk {
    int32_t ox, oy, clip[4];
    int fail_view, fail_create_nth, creates;
    uint32_t next;
    int16_t dw[1024], dh[1024];
    char log[1024];
} Mk;

static void mk_log(Mk *m, const char *fmt, ...)
{
    char tmp[160];
    va_list ap;
    va_start(ap, fmt);
    vsnprintf(tmp, sizeof tmp, fmt, ap);
    va_end(ap);
    if (m->log[0] != '\0') strncat(m->log, ";", sizeof m->log - strlen(m->log) - 1u);
    strncat(m->log, tmp, sizeof m->log - strlen(m->log) - 1u);
}

static int mk_view(void *c, EaView *v)
{
    const Mk *m = (const Mk *)c;
    if (m->fail_view) return 1;
    v->origin_x = m->ox;
    v->origin_y = m->oy;
    for (int k = 0; k < 4; ++k) v->clip[k] = m->clip[k];
    return 0;
}
static int mk_create(void *c, int16_t w, int16_t h, const char *tag, uint32_t *s)
{
    Mk *m = (Mk *)c;
    (void)tag;
    m->creates++;
    if (m->fail_create_nth == m->creates) return 1;
    *s = m->next++;
    m->dw[*s] = w;
    m->dh[*s] = h;
    mk_log(m, "create:%dx%d=%u", w, h, *s);
    return 0;
}
static int mk_blit(void *c, uint32_t src, uint32_t dst, const int32_t sr[4], const int32_t dr[4])
{
    mk_log((Mk *)c, "blit:%u>%u:%d,%d,%d,%d>%d,%d,%d,%d", src, dst, sr[0], sr[1], sr[2], sr[3], dr[0], dr[1], dr[2], dr[3]);
    return 0;
}
static int mk_copy(void *c, uint32_t dst, uint32_t src)
{
    Mk *m = (Mk *)c;
    m->dw[dst] = m->dw[src];
    m->dh[dst] = m->dh[src];
    mk_log(m, "copy:%u<%u", dst, src);
    return 0;
}
/* The real 0x4c7070 turns the surface a quarter turn: width and height swap. */
static int mk_rotate(void *c, uint32_t s, int16_t *w, int16_t *h)
{
    Mk *m = (Mk *)c;
    const int16_t t = m->dw[s];
    m->dw[s] = m->dh[s];
    m->dh[s] = t;
    *w = m->dw[s];
    *h = m->dh[s];
    mk_log(m, "rot:%u=%dx%d", s, *w, *h);
    return 0;
}

static void mk_init(Mk *m, EaHost *h)
{
    memset(m, 0, sizeof *m);
    memset(h, 0, sizeof *h);
    m->ox = 10;
    m->oy = 20;
    m->clip[0] = 0;
    m->clip[1] = 0;
    m->clip[2] = 639;
    m->clip[3] = 479;
    m->next = 100u;
    h->context = m;
    h->view = mk_view;
    h->create_surface = mk_create;
    h->blit = mk_blit;
    h->copy_surface = mk_copy;
    h->rotate_surface = mk_rotate;
}

/* Literal layout (from the pseudocode): piece i at 0x28 + i * 0x85, body piece i at 0x7f + i * 0x42. */
#define XP(i) (0x28u + (size_t)(i) * 0x85u)
#define XB(i) (0x7fu + (size_t)(i) * 0x42u)

/* ------------------------------------------------------------------------------------------------------------- */

/* 0x4841cb FUN_004841cb: dst = src rectangle plus the view origin (x origin to left/right, y origin to top/bottom). */
static void t_translate(void)
{
    uint8_t obj[EA_OBJECT_BYTES], before[EA_OBJECT_BYTES];
    Mk mk;
    EaHost h;
    mk_init(&mk, &h);

    /* origin (10, 20): (1,2,3,4) -> (11,22,13,24); the source stays. */
    obj_fill(obj);
    put_rect(obj, 0x100, 1, 2, 3, 4);
    memcpy(before, obj, sizeof obj);
    EXPECT_EQ(translate(obj, 0x100, 0x200, &h), EA_OK);
    EXPECT_RECT(obj, 0x200, 11, 22, 13, 24);
    EXPECT_RECT(obj, 0x100, 1, 2, 3, 4);
    EXPECT_ONLY(before, obj, SP(0x200, 0x210));

    /* negative origin, negative and large coordinates. */
    mk.ox = -5;
    mk.oy = -7;
    put_rect(obj, 0x100, -100, 50, 100, 70000);
    memcpy(before, obj, sizeof obj);
    EXPECT_EQ(translate(obj, 0x100, 0x300, &h), EA_OK);
    EXPECT_RECT(obj, 0x300, -105, 43, 95, 69993);
    EXPECT_ONLY(before, obj, SP(0x300, 0x310));

    /* in place (the original's four stores are independent). */
    mk.ox = 10;
    mk.oy = 20;
    put_rect(obj, 0x100, 1, 2, 3, 4);
    memcpy(before, obj, sizeof obj);
    EXPECT_EQ(translate(obj, 0x100, 0x100, &h), EA_OK);
    EXPECT_RECT(obj, 0x100, 11, 22, 13, 24);
    EXPECT_ONLY(before, obj, SP(0x100, 0x110));

    /* the adds wrap in 32 bits like the original's `add`. */
    mk.ox = 1;
    mk.oy = 1;
    put_rect(obj, 0x100, INT32_MAX, INT32_MAX, INT32_MIN, INT32_MIN);
    EXPECT_EQ(translate(obj, 0x100, 0x200, &h), EA_OK);
    EXPECT_RECT(obj, 0x200, INT32_MIN, INT32_MIN, INT32_MIN + 1, INT32_MIN + 1);

    /* a failing view seam returns the host error and leaves the destination alone. */
    mk.fail_view = 1;
    put_rect(obj, 0x400, 7, 7, 7, 7);
    memcpy(before, obj, sizeof obj);
    EXPECT_EQ(translate(obj, 0x100, 0x400, &h), EA_ERR_HOST);
    EXPECT_NO_CHANGE(before, obj);
}

/* 0x484caf FUN_00484caf: keep the rectangle's 16-bit size and clamp it into the clip rect (left 0x583196, top
 * 0x58319a, right 0x58319e, bottom 0x5831a2), in the order top, bottom, left, right. */
static void clamp_case(int line, Mk *mk, const EaHost *h, size_t off, int32_t l, int32_t t, int32_t r, int32_t b,
                       int32_t el, int32_t et, int32_t er, int32_t eb)
{
    uint8_t obj[EA_OBJECT_BYTES], before[EA_OBJECT_BYTES];
    (void)mk;
    obj_fill(obj);
    put_rect(obj, off, l, t, r, b);
    memcpy(before, obj, sizeof obj);
    if (clamp_rect(obj, off, h) != EA_OK) note(line, "clamp_rect failed");
    rect_check(line, obj, off, el, et, er, eb);
    only_check(line, before, obj, (const Span[]){SP(off, off + 16)}, 1);
}
#define CLAMP(off, l, t, r, b, el, et, er, eb) clamp_case(__LINE__, &mk, &h, (off), l, t, r, b, el, et, er, eb)

static void t_clamp_rect(void)
{
    uint8_t obj[EA_OBJECT_BYTES], before[EA_OBJECT_BYTES];
    Mk mk;
    EaHost h;
    mk_init(&mk, &h);
    mk.clip[0] = 10;  /* left */
    mk.clip[1] = 20;  /* top */
    mk.clip[2] = 300; /* right */
    mk.clip[3] = 200; /* bottom */

    CLAMP(0xab0, 50, 60, 90, 100, 50, 60, 90, 100);    /* inside: unchanged */
    /* each edge is compared with its own clip value: left 15 is past clip left (10) though before clip top (20); right
     * 250 is inside clip right (300) though past clip bottom (200); top 15 is before clip top (20). */
    CLAMP(0xab0, 15, 60, 55, 100, 15, 60, 55, 100);
    CLAMP(0xab0, 210, 60, 250, 100, 210, 60, 250, 100);
    CLAMP(0xab0, 50, 15, 90, 55, 50, 20, 90, 60);
    CLAMP(0xab0, 50, 5, 90, 45, 50, 20, 90, 60);       /* above: top = 20, bottom = top + 40 */
    CLAMP(0xab0, 50, 180, 90, 220, 50, 160, 90, 200);  /* below: bottom = 200, top = bottom - 40 */
    CLAMP(0xab0, 0, 50, 40, 90, 10, 50, 50, 90);       /* left of the clip */
    CLAMP(0xab0, 280, 50, 320, 90, 260, 50, 300, 90);  /* right of the clip */
    CLAMP(0xab0, 0, 5, 40, 45, 10, 20, 50, 60);        /* top-left corner */
    CLAMP(0xab0, 270, 170, 330, 230, 240, 140, 300, 200); /* bottom-right corner */
    /* the comparisons are strict: a rectangle on the clip edge stays, one pixel past it moves by one. */
    CLAMP(0xab0, 10, 20, 300, 200, 10, 20, 300, 200);
    CLAMP(0xab0, 10, 20, 50, 60, 10, 20, 50, 60);
    CLAMP(0xab0, 50, 19, 90, 59, 50, 20, 90, 60);
    CLAMP(0xab0, 50, 141, 90, 201, 50, 140, 90, 200);
    CLAMP(0xab0, 9, 50, 49, 90, 10, 50, 50, 90);
    CLAMP(0xab0, 261, 50, 301, 90, 260, 50, 300, 90);
    /* taller than the clip: the top clamp runs first, then the bottom clamp wins (top = 200 - 300). */
    CLAMP(0xab0, 50, 0, 90, 300, 50, -100, 90, 200);
    /* the size is the low 16 bits of the extent: 70000 -> 4464 (left clamp gives right 4474, right clamp left -4164). */
    CLAMP(XP(1) + 2, -5, 100, 69995, 140, -4164, 100, 300, 140);
    /* a negative extent is kept as a negative size. */
    CLAMP(0xab0, 100, 100, 60, 60, 100, 100, 60, 60);
    CLAMP(0xab0, 5, 5, -35, -35, 10, 20, -30, -20);

    /* a failing view seam: host error, rectangle untouched. */
    mk.fail_view = 1;
    obj_fill(obj);
    put_rect(obj, 0xab0, 0, 0, 40, 40);
    memcpy(before, obj, sizeof obj);
    EXPECT_EQ(clamp_rect(obj, 0xab0, &h), EA_ERR_HOST);
    EXPECT_NO_CHANGE(before, obj);
}

/* 0x484d87 FUN_00484d87: copy +0xab0 -> +0xaa0 and +0xad0 -> +0xac0, recentre the moving rect (+0xab0) on the pointer
 * rect (+0xbb1) using signed /2 and the short sizes at +0xbc5 / +0xbc7, clamp it, translate it into +0xad0. */
static void follow_setup(uint8_t *obj, int32_t pl, int32_t pt, int32_t pr, int32_t pb, int pw, int ph)
{
    obj_fill(obj);
    put_rect(obj, 0xab0, 1, 2, 3, 4);
    put_rect(obj, 0xad0, 5, 6, 7, 8);
    put_rect(obj, 0xbb1, pl, pt, pr, pb);
    p16(obj, 0xbc5, pw);
    p16(obj, 0xbc7, ph);
}

static void t_follow_pointer(void)
{
    uint8_t obj[EA_OBJECT_BYTES], before[EA_OBJECT_BYTES];
    Mk mk;
    EaHost h;
    mk_init(&mk, &h);

    /* ptr (100,200,160,260), 30 x 20: left (60/2)+100-15 = 115, top (60/2)+200-10 = 220. */
    follow_setup(obj, 100, 200, 160, 260, 30, 20);
    memcpy(before, obj, sizeof obj);
    EXPECT_EQ(follow_pointer(obj, &h), EA_OK);
    EXPECT_RECT(obj, 0xaa0, 1, 2, 3, 4);
    EXPECT_RECT(obj, 0xac0, 5, 6, 7, 8);
    EXPECT_RECT(obj, 0xab0, 115, 220, 145, 240);
    EXPECT_RECT(obj, 0xad0, 125, 240, 155, 260);
    EXPECT_ONLY(before, obj, SP(0xaa0, 0xae0));

    /* odd halves and a clamp at the top-left: left (101/2)-101-15 = -66, top (51/2)-51-10 = -36 -> clamped to 0. */
    follow_setup(obj, -101, -51, 0, 0, 31, 21);
    memcpy(before, obj, sizeof obj);
    EXPECT_EQ(follow_pointer(obj, &h), EA_OK);
    EXPECT_RECT(obj, 0xab0, 0, 0, 31, 21);
    EXPECT_RECT(obj, 0xad0, 10, 20, 41, 41);
    EXPECT_RECT(obj, 0xaa0, 1, 2, 3, 4);
    EXPECT_ONLY(before, obj, SP(0xaa0, 0xae0));

    /* negative extents divide toward zero: (5-10)/2 = -2 (not -3), (4-10)/2 = -3, -3/2 = -1, -5/2 = -2. */
    follow_setup(obj, 10, 10, 5, 4, -3, -5);
    EXPECT_EQ(follow_pointer(obj, &h), EA_OK);
    EXPECT_RECT(obj, 0xab0, 9, 9, 6, 4);
    EXPECT_RECT(obj, 0xad0, 19, 29, 16, 24);

    /* clamp at the bottom-right: (590,430,650,490) -> bottom 479 / top 419, right 639 / left 579. */
    follow_setup(obj, 600, 440, 640, 480, 60, 60);
    EXPECT_EQ(follow_pointer(obj, &h), EA_OK);
    EXPECT_RECT(obj, 0xab0, 579, 419, 639, 479);
    EXPECT_RECT(obj, 0xad0, 589, 439, 649, 499);

    /* a failing view seam: the history copy and the recentred (unclamped) rect are already stored, MOVE_T is not. */
    mk.fail_view = 1;
    follow_setup(obj, 600, 440, 640, 480, 60, 60);
    EXPECT_EQ(follow_pointer(obj, &h), EA_ERR_HOST);
    EXPECT_RECT(obj, 0xaa0, 1, 2, 3, 4);
    EXPECT_RECT(obj, 0xac0, 5, 6, 7, 8);
    EXPECT_RECT(obj, 0xab0, 590, 430, 650, 490);
    EXPECT_RECT(obj, 0xad0, 5, 6, 7, 8);
}

/* Piece entry k at piece + 0x24 + k * 0x18: rect at +4, width short at +0x14, height short at +0x16. */
static void set_entry(uint8_t *o, size_t P, int k, int w, int h, int32_t rr, int32_t rb)
{
    const size_t e = P + 0x24u + (size_t)k * 0x18u;
    put_rect(o, e + 4, 0, 0, rr, rb);
    p16(o, e + 0x14, w);
    p16(o, e + 0x16, h);
}

/* Four orientation entries: 40 x 30, 30 x 40, 40 x 30, 30 x 40. */
static void rot_fixture(uint8_t *o, size_t P, int orient, int32_t l, int32_t t, int32_t r, int32_t b)
{
    obj_fill(o);
    set_entry(o, P, 0, 40, 30, 39, 29);
    set_entry(o, P, 1, 30, 40, 29, 39);
    set_entry(o, P, 2, 40, 30, 39, 29);
    set_entry(o, P, 3, 30, 40, 29, 39);
    put_rect(o, P + 2, l, t, r, b);
    o[P + 0x22] = (uint8_t)orient;
}

/* 0x4853b0 FUN_004853b0: lift flag := 1, save the rect to +0xae0, turn the orientation (4 wraps to 0), recentre the
 * rect on the old centre (short arithmetic, /2), clamp it, translate it into the piece's second rect (+0x12). */
static void t_rotate_piece(void)
{
    uint8_t obj[EA_OBJECT_BYTES], before[EA_OBJECT_BYTES];
    Mk mk;
    EaHost h;
    size_t P;
    mk_init(&mk, &h);

    /* piece 2, orientation 0 -> 1: centre (120,115); the new 30 x 40 rect is (105,95,134,134). */
    P = XP(2);
    rot_fixture(obj, P, 0, 100, 100, 139, 129);
    memcpy(before, obj, sizeof obj);
    EXPECT_EQ(rotate_piece(obj, 2, &h), EA_OK);
    EXPECT_EQ(g32(obj, 0xa9a), 1);
    EXPECT_RECT(obj, 0xae0, 100, 100, 139, 129);
    EXPECT_EQ(obj[P + 0x22], 1);
    EXPECT_RECT(obj, P + 2, 105, 95, 134, 134);
    EXPECT_RECT(obj, P + 0x12, 115, 115, 144, 154);
    EXPECT_ONLY(before, obj, SP(0xa9a, 0xa9e), SP(0xae0, 0xaf0), SP(P + 2, P + 0x23));

    /* orientation 3 wraps to 0: from (105,95,134,134) back to (100,100,139,129). */
    P = XP(0);
    rot_fixture(obj, P, 3, 105, 95, 134, 134);
    memcpy(before, obj, sizeof obj);
    EXPECT_EQ(rotate_piece(obj, 0, &h), EA_OK);
    EXPECT_EQ(obj[P + 0x22], 0);
    EXPECT_RECT(obj, 0xae0, 105, 95, 134, 134);
    EXPECT_RECT(obj, P + 2, 100, 100, 139, 129);
    EXPECT_RECT(obj, P + 0x12, 110, 120, 149, 149);
    EXPECT_ONLY(before, obj, SP(0xa9a, 0xa9e), SP(0xae0, 0xaf0), SP(P + 2, P + 0x23));

    /* orientation 2 -> 3 (no wrap yet). */
    P = XP(1);
    rot_fixture(obj, P, 2, 100, 100, 139, 129);
    EXPECT_EQ(rotate_piece(obj, 1, &h), EA_OK);
    EXPECT_EQ(obj[P + 0x22], 3);
    EXPECT_RECT(obj, P + 2, 105, 95, 134, 134);

    /* odd sizes and an entry rect that is not width-1: centre (100+41/2, 100+31/2) = (120,115); the new left is
     * 120 - 31/2 = 105, top 115 - 41/2 = 95, right/bottom add the entry rect's own right (33) / bottom (44). */
    rot_fixture(obj, P, 0, 100, 100, 140, 130);
    set_entry(obj, P, 0, 41, 31, 40, 30);
    set_entry(obj, P, 1, 31, 41, 33, 44);
    EXPECT_EQ(rotate_piece(obj, 1, &h), EA_OK);
    EXPECT_RECT(obj, P + 2, 105, 95, 138, 139);
    EXPECT_RECT(obj, P + 0x12, 115, 115, 148, 159);

    /* clamp then translate: (5,-5,34,34) is pulled down to (5,0,34,39); second rect adds the origin (10,20). */
    P = XP(0);
    rot_fixture(obj, P, 0, 0, 0, 39, 29);
    EXPECT_EQ(rotate_piece(obj, 0, &h), EA_OK);
    EXPECT_RECT(obj, P + 2, 5, 0, 34, 39);
    EXPECT_RECT(obj, P + 0x12, 15, 20, 44, 59);

    /* the centre is a short: left 70000 is 4464 as a short, centre x 4484, new left 4469, right 4498; the clamp then
     * pins the right edge to 639 (left 610). */
    rot_fixture(obj, P, 0, 70000, 100, 70039, 129);
    EXPECT_EQ(rotate_piece(obj, 0, &h), EA_OK);
    EXPECT_RECT(obj, P + 2, 610, 95, 639, 134);
    EXPECT_RECT(obj, P + 0x12, 620, 115, 649, 154);

    /* a failing view seam: lift flag, saved rect and the turned orientation are stored before the clamp fails. */
    mk.fail_view = 1;
    rot_fixture(obj, P, 0, 100, 100, 139, 129);
    EXPECT_EQ(rotate_piece(obj, 0, &h), EA_ERR_HOST);
    EXPECT_EQ(g32(obj, 0xa9a), 1);
    EXPECT_RECT(obj, 0xae0, 100, 100, 139, 129);
    EXPECT_EQ(obj[P + 0x22], 1);
}

/* 0x4866b4 FUN_004866b4: 1 when the rect lies inside the body area rect (left 0x5a7, top 0x5ab, right 0x5af, bottom
 * 0x5b3); any of top < area.top, area.bottom < bottom, left < area.left, area.right < right gives 0. */
static void inside_run(int line, size_t off, int32_t l, int32_t t, int32_t r, int32_t b, int expect)
{
    uint8_t obj[EA_OBJECT_BYTES], body[EA_BODY_BYTES];
    int got;
    obj_fill(obj);
    memset(body, 0, sizeof body);
    put_rect(body, 0x5a7, 10, 20, 300, 200);
    put_rect(obj, off, l, t, r, b);
    got = inside_area(obj, body, off);
    if (got != expect) note(line, "inside_area(%d,%d,%d,%d) = %d, expected %d", l, t, r, b, got, expect);
}
#define INSIDE(off, l, t, r, b, e) inside_run(__LINE__, (off), l, t, r, b, e)

static void t_inside_area(void)
{
    INSIDE(0xab0, 50, 60, 90, 100, 1);
    INSIDE(0xab0, 250, 150, 280, 190, 1);
    INSIDE(0xab0, 10, 20, 300, 200, 1); /* exactly the area: all four compares are strict */
    INSIDE(0xab0, 10, 20, 10, 20, 1);
    INSIDE(0xab0, 9, 60, 90, 100, 0);   /* left */
    INSIDE(0xab0, 50, 19, 90, 100, 0);  /* top */
    INSIDE(0xab0, 50, 60, 301, 100, 0); /* right */
    INSIDE(0xab0, 50, 60, 90, 201, 0);  /* bottom */
    INSIDE(0xab0, -5, -5, 0, 0, 0);
    INSIDE(0xab0, 90, 100, 50, 60, 1);  /* inverted extents are only compared edge by edge */
    INSIDE(XP(1) + 2, 50, 60, 90, 100, 1); /* the rect is addressed by offset */
    INSIDE(XP(1) + 2, 50, 60, 90, 201, 0);
}

/* 0x486725 FUN_00486725: for every piece below the body's count whose placed byte (+0x4b + k * 0x85) is 0 the body
 * piece's rect C top (+0xa3 + k * 0x42) and bottom (+0xab + k * 0x42) must be 0; if all pass, state (+0xbac) := 6 and
 * done (+0xbb0) := 1, otherwise nothing is written. */
static void solved_fixture(uint8_t *obj, uint8_t *body, int n)
{
    obj_fill(obj);
    memset(body, 0, EA_BODY_BYTES);
    p16(body, 0x21, n);
    p32(obj, 0xbac, 3);
    obj[0xbb0] = 0;
    for (int k = 0; k < 8; ++k) obj[0x4b + (size_t)k * 0x85] = 0;
}

static void solved_run(int line, const uint8_t *obj0, const uint8_t *body, int expect_solved)
{
    uint8_t obj[EA_OBJECT_BYTES];
    memcpy(obj, obj0, sizeof obj);
    check_solved(obj, body);
    if (expect_solved) {
        if (g32(obj, 0xbac) != 6 || obj[0xbb0] != 1) note(line, "expected solved, state %d done %d", g32(obj, 0xbac), obj[0xbb0]);
    } else if (g32(obj, 0xbac) != 3 || obj[0xbb0] != 0) {
        note(line, "expected unsolved, state %d done %d", g32(obj, 0xbac), obj[0xbb0]);
    }
    only_check(line, obj0, obj, (const Span[]){SP(0xbac, 0xbb1)}, 1);
}
#define SOLVED(obj, body, e) solved_run(__LINE__, (obj), (body), (e))

static void t_check_solved(void)
{
    uint8_t obj[EA_OBJECT_BYTES], body[EA_BODY_BYTES];

    /* every piece placed: the body's C rects are not consulted. */
    solved_fixture(obj, body, 3);
    for (int k = 0; k < 3; ++k) {
        obj[0x4b + (size_t)k * 0x85] = 1;
        p32(body, 0xa3 + (size_t)k * 0x42, 77);
        p32(body, 0xab + (size_t)k * 0x42, 77);
    }
    SOLVED(obj, body, 1);

    /* no piece placed, all C tops and bottoms zero. */
    solved_fixture(obj, body, 3);
    SOLVED(obj, body, 1);

    /* an empty puzzle is solved at once. */
    solved_fixture(obj, body, 0);
    p32(body, 0xa3, 5);
    SOLVED(obj, body, 1);

    /* an unplaced piece with a nonzero C top blocks, wherever it is in the list. */
    solved_fixture(obj, body, 3);
    obj[0x4b] = 1;
    obj[0x4b + 2 * 0x85] = 1;
    p32(body, 0xa3 + 1 * 0x42, 1);
    SOLVED(obj, body, 0);
    solved_fixture(obj, body, 3);
    p32(body, 0xa3 + 2 * 0x42, 1); /* the last piece is checked too */
    SOLVED(obj, body, 0);
    solved_fixture(obj, body, 3);
    p32(body, 0xa3, 0x10000); /* the whole 32-bit word counts, not its low half */
    SOLVED(obj, body, 0);

    /* a nonzero C bottom blocks as well. */
    solved_fixture(obj, body, 3);
    p32(body, 0xab + 1 * 0x42, -1);
    SOLVED(obj, body, 0);
    solved_fixture(obj, body, 3);
    p32(body, 0xab, 1);
    SOLVED(obj, body, 0);

    /* a placed piece with nonzero C values does not block while an unplaced one with zeros passes. */
    solved_fixture(obj, body, 2);
    obj[0x4b] = 1;
    p32(body, 0xa3, 9);
    p32(body, 0xab, 9);
    SOLVED(obj, body, 1);

    /* pieces at or beyond the body's count are not examined. */
    solved_fixture(obj, body, 2);
    p32(body, 0xa3 + 2 * 0x42, 9);
    p32(body, 0xab + 2 * 0x42, 9);
    SOLVED(obj, body, 1);
}

/* Piece p's rect (second 16 bytes of the piece: +2 left, +6 top, +0xa right, +0xe bottom) and layer word (+0). */
static void set_piece(uint8_t *o, int i, int z, int32_t l, int32_t t, int32_t r, int32_t b)
{
    p16(o, XP(i), z);
    put_rect(o, XP(i) + 2, l, t, r, b);
}

static void layer_fixture(uint8_t *obj, uint8_t *body, int n)
{
    obj_fill(obj);
    memset(body, 0, EA_BODY_BYTES);
    p16(body, 0x21, n);
    for (int i = 0; i < 4; ++i) set_piece(obj, i, 0, 1000 + i * 100, 1000, 1050 + i * 100, 1050); /* disjoint */
}

static void layer_run(int line, uint8_t *obj, const uint8_t *body, int16_t i, int expect_z)
{
    uint8_t before[EA_OBJECT_BYTES];
    memcpy(before, obj, sizeof before);
    set_layer(obj, body, i);
    if (g16(obj, XP(i)) != expect_z) note(line, "piece %d layer = %d, expected %d", i, g16(obj, XP(i)), expect_z);
    only_check(line, before, obj, (const Span[]){SP(XP(i), XP(i) + 2)}, 1);
}
#define LAYER(obj, body, i, z) layer_run(__LINE__, (obj), (body), (i), (z))

/* 0x484935 FUN_00484935: with the body's layer flag (+0x56) clear, the piece's layer word becomes the largest layer of
 * the other pieces (below the body's count) whose rects overlap it (0x484762), or its own, plus 1 (16-bit); with the
 * flag set, it becomes the index k of the layer table entry (+0x57 + 2k) equal to i + 1 (the last match wins). */
static void t_set_layer(void)
{
    uint8_t obj[EA_OBJECT_BYTES], body[EA_BODY_BYTES];

    /* flag clear: piece 0 overlaps piece 1 only -> max(2, 5) + 1 = 6; piece 2 (layer 9) is far away. */
    layer_fixture(obj, body, 3);
    set_piece(obj, 0, 2, 0, 0, 50, 50);
    set_piece(obj, 1, 5, 40, 40, 90, 90);
    set_piece(obj, 2, 9, 200, 200, 250, 250);
    LAYER(obj, body, 0, 6);
    EXPECT_EQ(g16(obj, XP(1)), 5);
    EXPECT_EQ(g16(obj, XP(2)), 9);

    /* no overlaps: own layer + 1. */
    LAYER(obj, body, 2, 10);

    /* its own layer is the larger one: 8 + 1. */
    set_piece(obj, 0, 8, 0, 0, 50, 50);
    LAYER(obj, body, 0, 9);

    /* two overlapping pieces: the maximum of both (9) plus one. */
    set_piece(obj, 0, 2, 0, 0, 50, 50);
    set_piece(obj, 1, 5, 40, 40, 90, 90);
    set_piece(obj, 2, 9, 45, 45, 60, 60);
    LAYER(obj, body, 0, 10);

    /* rects touching on an edge overlap (the reject tests are strict), a one-pixel gap does not. */
    layer_fixture(obj, body, 3);
    set_piece(obj, 0, 2, 0, 0, 50, 50);
    set_piece(obj, 1, 7, 50, 0, 100, 50);
    LAYER(obj, body, 0, 8);
    set_piece(obj, 0, 2, 0, 0, 50, 50);
    set_piece(obj, 1, 7, 51, 0, 100, 50);
    LAYER(obj, body, 0, 3);
    set_piece(obj, 0, 2, 0, 0, 50, 50);
    set_piece(obj, 1, 7, 0, 50, 50, 100); /* touching below */
    LAYER(obj, body, 0, 8);
    set_piece(obj, 1, 7, 0, 51, 50, 100);
    set_piece(obj, 0, 2, 0, 0, 50, 50);
    LAYER(obj, body, 0, 3);

    /* the 16-bit layer wraps: 32767 + 1 = -32768. */
    layer_fixture(obj, body, 3);
    set_piece(obj, 1, 0x7fff, 1100, 1000, 1150, 1050);
    LAYER(obj, body, 1, -32768);

    /* only the first n pieces are scanned: piece 3 (layer 100) overlaps piece 0 but n = 3. */
    layer_fixture(obj, body, 3);
    set_piece(obj, 0, 2, 0, 0, 50, 50);
    set_piece(obj, 3, 100, 10, 10, 20, 20);
    LAYER(obj, body, 0, 3);

    /* an overlap whose clipped x/y bound is exactly -1 is rejected by 0x484762: identical rects at left -1. */
    layer_fixture(obj, body, 3);
    set_piece(obj, 0, 2, -1, 0, 50, 50);
    set_piece(obj, 1, 5, -1, 0, 50, 50);
    LAYER(obj, body, 0, 3);

    /* flag set: layer = k of the table entry equal to i + 1; table {3, 1, 2}. */
    layer_fixture(obj, body, 3);
    body[0x56] = 1;
    p16(body, 0x57, 3);
    p16(body, 0x59, 1);
    p16(body, 0x5b, 2);
    for (int i = 0; i < 3; ++i) p16(obj, XP(i), 77);
    LAYER(obj, body, 0, 1);
    LAYER(obj, body, 1, 2);
    LAYER(obj, body, 2, 0);

    /* flag set, no entry matches: the layer word is left alone (7). */
    layer_fixture(obj, body, 3);
    body[0x56] = 1;
    p16(body, 0x57, 9);
    p16(body, 0x59, 9);
    p16(body, 0x5b, 9);
    p16(obj, XP(0), 7);
    LAYER(obj, body, 0, 7);

    /* flag set, two matches: the last one wins (table {1, 0, 1} for piece 0 gives 2). */
    layer_fixture(obj, body, 3);
    body[0x56] = 1;
    p16(body, 0x57, 1);
    p16(body, 0x59, 0);
    p16(body, 0x5b, 1);
    LAYER(obj, body, 0, 2);

    /* flag set: overlapping rects are not consulted. */
    layer_fixture(obj, body, 3);
    body[0x56] = 1;
    set_piece(obj, 0, 4, 0, 0, 50, 50);
    set_piece(obj, 1, 9, 10, 10, 60, 60);
    LAYER(obj, body, 0, 4);

    /* flag set: table entries at or beyond n are ignored (n = 2, entry 2 matches piece 0). */
    layer_fixture(obj, body, 2);
    body[0x56] = 1;
    p16(body, 0x59, 0);
    p16(body, 0x5b, 1);
    p16(obj, XP(0), 6);
    LAYER(obj, body, 0, 6);
}

/* Body piece i: rect A +0, B +0x10, C +0x20, D +0x30, start orientation +0x40, loose flag +0x41. */
static void piece_body(uint8_t *b)
{
    memset(b, 0, EA_BODY_BYTES);
    p16(b, 0x21, 3);
    put_rect(b, XB(0) + 0x00, 1, 1, 40, 30);
    put_rect(b, XB(0) + 0x20, 100, 100, 139, 129);
    put_rect(b, XB(0) + 0x30, 300, 200, 339, 229);
    put_rect(b, XB(1) + 0x00, 2, 2, 31, 21);
    put_rect(b, XB(1) + 0x10, 5, 5, 24, 14);
    put_rect(b, XB(1) + 0x20, 400, 50, 419, 59);
    put_rect(b, XB(1) + 0x30, 500, 60, 519, 69);
    put_rect(b, XB(2) + 0x00, 7, 7, 16, 26);
    put_rect(b, XB(2) + 0x20, 200, 300, 209, 319);
    put_rect(b, XB(2) + 0x30, 220, 320, 229, 339);
}

static void piece_obj(uint8_t *o, size_t P)
{
    obj_fill(o);
    p32(o, 0x22, 5); /* source surface handle */
    p16(o, P, 77);   /* stale layer, must be reset */
}

static void ent_check(int line, const uint8_t *o, size_t P, int k, uint32_t surf, int w, int h)
{
    const size_t e = P + 0x24u + (size_t)k * 0x18u;
    if ((uint32_t)g32(o, e) != surf || g16(o, e + 0x14) != w || g16(o, e + 0x16) != h || g32(o, e + 4) != 0 ||
        g32(o, e + 8) != 0 || g32(o, e + 0xc) != w - 1 || g32(o, e + 0x10) != h - 1)
        note(line, "entry %d: surf %u size %dx%d rect (%d,%d,%d,%d)", k, (unsigned)g32(o, e), g16(o, e + 0x14), g16(o, e + 0x16),
             g32(o, e + 4), g32(o, e + 8), g32(o, e + 0xc), g32(o, e + 0x10));
}
#define EXPECT_ENT(o, P, k, surf, w, h) ent_check(__LINE__, (o), (P), (k), (surf), (w), (h))

/* 0x48421e FUN_0048421e: z := 0, orientation (+0x22) and placed flag (+0x23) from body +0x40 / +0x41; loose = 0 takes
 * rect D, loose = 1 takes rect C, forces orientation 0 and (layer flag set) takes the layer index; the two rects get
 * the view origin (0x4841cb); source rect is B when its width and height edges differ, else A (+0x84 := 1); entry 0
 * is a fresh w x h surface filled by a blit of the source image (+0x22); with rotation allowed (body +0x24) or a start
 * orientation, entries 1..3 are create+copy+rotate surfaces of the previous (rotated) size for loose = 0, else null. */
static void t_piece_init(void)
{
    uint8_t obj[EA_OBJECT_BYTES], body[EA_BODY_BYTES], before[EA_OBJECT_BYTES];
    Mk mk;
    EaHost h;
    size_t P;
    const uint32_t junk = 0x0badf00du;

    /* piece 0, unplaced, no rotation: rect A, rect D, one entry. */
    mk_init(&mk, &h);
    piece_body(body);
    P = XP(0);
    piece_obj(obj, P);
    memcpy(before, obj, sizeof obj);
    EXPECT_EQ(piece_init(obj, body, 0, &h), EA_OK);
    EXPECT_EQ(g16(obj, P), 0);
    EXPECT_EQ(obj[P + 0x22], 0);
    EXPECT_EQ(obj[P + 0x23], 0);
    EXPECT_RECT(obj, P + 2, 300, 200, 339, 229);
    EXPECT_RECT(obj, P + 0x12, 310, 220, 349, 249);
    EXPECT_EQ(obj[P + 0x84], 1);
    EXPECT_ENT(obj, P, 0, 100, 40, 30);
    EXPECT_LOG(&mk, "create:40x30=100;blit:5>100:1,1,40,30>0,0,39,29");
    EXPECT_ONLY(before, obj, SP(P, P + 0x3c), SP(P + 0x84, P + 0x85));

    /* piece 1, unplaced, rotation allowed: rect B (20 x 10), rect D, entries 1..3 are rotated copies of the previous. */
    mk_init(&mk, &h);
    body[0x24] = 1;
    P = XP(1);
    piece_obj(obj, P);
    memcpy(before, obj, sizeof obj);
    EXPECT_EQ(piece_init(obj, body, 1, &h), EA_OK);
    EXPECT_EQ(g16(obj, P), 0);
    EXPECT_EQ(obj[P + 0x22], 0);
    EXPECT_EQ(obj[P + 0x23], 0);
    EXPECT_RECT(obj, P + 2, 500, 60, 519, 69);
    EXPECT_RECT(obj, P + 0x12, 510, 80, 529, 89);
    EXPECT_EQ(obj[P + 0x84], 0);
    EXPECT_ENT(obj, P, 0, 100, 20, 10);
    EXPECT_ENT(obj, P, 1, 101, 10, 20);
    EXPECT_ENT(obj, P, 2, 102, 20, 10);
    EXPECT_ENT(obj, P, 3, 103, 10, 20);
    EXPECT_LOG(&mk,
               "create:20x10=100;blit:5>100:5,5,24,14>0,0,19,9;create:20x10=101;copy:101<100;rot:101=10x20;"
               "create:10x20=102;copy:102<101;rot:102=20x10;create:20x10=103;copy:103<102;rot:103=10x20");
    EXPECT_ONLY(before, obj, SP(P, P + 0x85));

    /* piece 2, unplaced, rotation off but start orientation 2: orientation kept, rotated entries still built. */
    mk_init(&mk, &h);
    body[0x24] = 0;
    body[XB(2) + 0x40] = 2;
    P = XP(2);
    piece_obj(obj, P);
    EXPECT_EQ(piece_init(obj, body, 2, &h), EA_OK);
    EXPECT_EQ(obj[P + 0x22], 2);
    EXPECT_EQ(obj[P + 0x23], 0);
    EXPECT_RECT(obj, P + 2, 220, 320, 229, 339);
    EXPECT_RECT(obj, P + 0x12, 230, 340, 239, 359);
    EXPECT_EQ(obj[P + 0x84], 1);
    EXPECT_ENT(obj, P, 0, 100, 10, 20);
    EXPECT_ENT(obj, P, 1, 101, 20, 10);
    EXPECT_ENT(obj, P, 2, 102, 10, 20);
    EXPECT_ENT(obj, P, 3, 103, 20, 10);
    EXPECT_LOG(&mk,
               "create:10x20=100;blit:5>100:7,7,16,26>0,0,9,19;create:10x20=101;copy:101<100;rot:101=20x10;"
               "create:20x10=102;copy:102<101;rot:102=10x20;create:10x20=103;copy:103<102;rot:103=20x10");

    /* piece 0, placed (loose = 1), start orientation 3, rotation allowed: rect C, orientation forced to 0, entries 1..3
     * are null and no surface is created for them. */
    mk_init(&mk, &h);
    body[0x24] = 1;
    body[XB(0) + 0x40] = 3;
    body[XB(0) + 0x41] = 1;
    P = XP(0);
    piece_obj(obj, P);
    for (int k = 1; k < 4; ++k) p32(obj, P + 0x24u + (size_t)k * 0x18u, (int32_t)junk);
    memcpy(before, obj, sizeof obj);
    EXPECT_EQ(piece_init(obj, body, 0, &h), EA_OK);
    EXPECT_EQ(g16(obj, P), 0);
    EXPECT_EQ(obj[P + 0x22], 0);
    EXPECT_EQ(obj[P + 0x23], 1);
    EXPECT_RECT(obj, P + 2, 100, 100, 139, 129);
    EXPECT_RECT(obj, P + 0x12, 110, 120, 149, 149);
    EXPECT_EQ(obj[P + 0x84], 1);
    EXPECT_ENT(obj, P, 0, 100, 40, 30);
    for (int k = 1; k < 4; ++k) EXPECT_EQ(g32(obj, P + 0x24u + (size_t)k * 0x18u), 0);
    EXPECT_LOG(&mk, "create:40x30=100;blit:5>100:1,1,40,30>0,0,39,29");
    EXPECT_ONLY(before, obj, SP(P, P + 0x3c), SP(P + 0x3c, P + 0x40), SP(P + 0x54, P + 0x58), SP(P + 0x6c, P + 0x70),
                SP(P + 0x84, P + 0x85));

    /* placed piece with the layer table on: layer = k where table[k] == i + 1, last match; table {3, 2, 2} for piece 1. */
    mk_init(&mk, &h);
    piece_body(body);
    body[XB(1) + 0x41] = 1;
    body[0x56] = 1;
    p16(body, 0x57, 3);
    p16(body, 0x59, 2);
    p16(body, 0x5b, 2);
    P = XP(1);
    piece_obj(obj, P);
    EXPECT_EQ(piece_init(obj, body, 1, &h), EA_OK);
    EXPECT_EQ(g16(obj, P), 2);
    EXPECT_RECT(obj, P + 2, 400, 50, 419, 59);
    EXPECT_RECT(obj, P + 0x12, 410, 70, 429, 79);
    /* ... no matching entry leaves the (reset) layer at 0 ... */
    p16(body, 0x57, 9);
    p16(body, 0x59, 9);
    p16(body, 0x5b, 9);
    piece_obj(obj, P);
    EXPECT_EQ(piece_init(obj, body, 1, &h), EA_OK);
    EXPECT_EQ(g16(obj, P), 0);
    /* ... and an unplaced piece never takes a layer from the table. */
    body[XB(1) + 0x41] = 0;
    p16(body, 0x57, 2);
    p16(body, 0x59, 2);
    p16(body, 0x5b, 2);
    piece_obj(obj, P);
    EXPECT_EQ(piece_init(obj, body, 1, &h), EA_OK);
    EXPECT_EQ(g16(obj, P), 0);

    /* a rect B with a zero width or zero height is invalid: rect A is used and +0x84 := 1. */
    piece_body(body);
    mk_init(&mk, &h);
    put_rect(body, XB(0) + 0x10, 5, 5, 5, 14);
    P = XP(0);
    piece_obj(obj, P);
    EXPECT_EQ(piece_init(obj, body, 0, &h), EA_OK);
    EXPECT_EQ(obj[P + 0x84], 1);
    EXPECT_LOG(&mk, "create:40x30=100;blit:5>100:1,1,40,30>0,0,39,29");
    mk_init(&mk, &h);
    put_rect(body, XB(0) + 0x10, 5, 5, 24, 5);
    piece_obj(obj, P);
    EXPECT_EQ(piece_init(obj, body, 0, &h), EA_OK);
    EXPECT_EQ(obj[P + 0x84], 1);
    EXPECT_LOG(&mk, "create:40x30=100;blit:5>100:1,1,40,30>0,0,39,29");

    /* host failures: the first create fails before any blit; the second create (rotated copy) fails after the blit. */
    piece_body(body);
    mk_init(&mk, &h);
    mk.fail_create_nth = 1;
    P = XP(1);
    piece_obj(obj, P);
    EXPECT_EQ(piece_init(obj, body, 1, &h), EA_ERR_HOST);
    EXPECT_LOG(&mk, "");
    mk_init(&mk, &h);
    mk.fail_create_nth = 2;
    body[0x24] = 1;
    piece_obj(obj, P);
    EXPECT_EQ(piece_init(obj, body, 1, &h), EA_ERR_HOST);
    EXPECT_LOG(&mk, "create:20x10=100;blit:5>100:5,5,24,14>0,0,19,9");
}

/* ------------------------------------------------------------------------------------------------------------- */

typedef struct Case {
    const char *name;
    void (*fn)(void);
} Case;

int main(void)
{
    static const Case cases[] = {
        {"translate", t_translate},     {"piece_init", t_piece_init},     {"set_layer", t_set_layer},
        {"clamp_rect", t_clamp_rect},   {"follow_pointer", t_follow_pointer}, {"rotate_piece", t_rotate_piece},
        {"inside_area", t_inside_area}, {"check_solved", t_check_solved},
    };
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
