/* FL-11 direct tests of the static helpers of the raw 0xda Bul puzzle kernel (src/action_family_da_runtime.c). The kernel is
 * pulled in as a translation unit (same shim pattern as tests/action_family_28_x87_division_fixture.c) so that reset_work,
 * step_check and caption_pick can be called directly. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values are derived by hand from the original GAME.EXE
 * functions 0x45ba0b, 0x45bcc1 and 0x45be7f (helper 0x45be3f), not by running the kernel; body and object offsets below are
 * written down from the original's displacements. The kernel's own macros CHECK / HOST are in scope, so this file uses CK. */
#include "../src/action_family_da_runtime.c"

#include <stdio.h>
#include <stdlib.h>

static int g_failed;
static char g_msg[256];
#define CK(cond)                                                               \
    do {                                                                       \
        if (!(cond) && !g_failed) {                                            \
            g_failed = 1;                                                      \
            snprintf(g_msg, sizeof g_msg, "line %d: %.200s", __LINE__, #cond); \
        }                                                                      \
    } while (0)

/* Body displacements of the original: start positions, position rectangles, work source rectangles (stride 0x20), marker
 * images (before / after a step), caption entries (stride 0x2dc, word channel, words +2 +4, names of 0x21 bytes from +6) and
 * the 4 step-score names (0x6e1 = 0x591 + 0x150). */
enum {
    Q_START_P = 0x29,
    Q_START_C = 0x2b,
    Q_POS = 0xad,
    Q_WORK = 0x36d,
    Q_MARK = 0x3ed,
    Q_MARK_AFTER = 0x40d,
    Q_CAP = 0x591,
    Q_CAP_STRIDE = 0x2dc,
    Q_STEP_NAMES = 0x6e1,
    Q_NAME = 0x21
};

typedef struct {
    BulObject o;
    BulWorld w;
    BulHost host;
    uint8_t body[BUL_BODY_BYTES];
    Ctx c;
    char log[1024];
    int32_t rq[32];
    int nq, iq, exhausted;
    uint32_t now;
    const char *text;
    char *long_text;
} TF;

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
static void t_name(uint8_t *b, size_t off, const char *s)
{
    memset(b + off, 0, Q_NAME);
    memcpy(b + off, s, strlen(s));
}
static int t_rect_is(const BulRect *r, int32_t l, int32_t t, int32_t rr, int32_t bt)
{
    return r->left == l && r->top == t && r->right == rr && r->bottom == bt;
}

static void t_log(TF *f, const char *fmt, const char *s, int n)
{
    char tmp[160];
    snprintf(tmp, sizeof tmp, fmt, s, n);
    if (f->log[0] != '\0') strncat(f->log, ",", sizeof f->log - strlen(f->log) - 1u);
    strncat(f->log, tmp, sizeof f->log - strlen(f->log) - 1u);
}
static int32_t m_random(void *c)
{
    TF *f = (TF *)c;
    t_log(f, "rand%s", "", 0);
    if (f->iq >= f->nq) {
        f->exhausted = 1;
        return -1; /* the kernel refuses a draw outside 0..32767 */
    }
    return f->rq[f->iq++];
}
static uint32_t m_tick(void *c)
{
    TF *f = (TF *)c;
    t_log(f, "tick%s", "", 0);
    return f->now;
}
static int m_prepare(void *c, const uint8_t *name)
{
    t_log((TF *)c, "prep:%s", (const char *)name, 0);
    return 0;
}
static int m_play(void *c, int16_t channel)
{
    t_log((TF *)c, "play:%s%d", "", channel);
    return 0;
}
static const char *m_text(void *c, const char *name)
{
    TF *f = (TF *)c;
    t_log(f, "text:%s", name, 0);
    return f->long_text != NULL ? f->long_text : f->text;
}
static int m_show(void *c, const char *text)
{
    TF *f = (TF *)c;
    char tmp[64];
    if (strlen(text) > 40) {
        snprintf(tmp, sizeof tmp, "len%zu", strlen(text));
        t_log(f, "show:%s", tmp, 0);
    } else {
        t_log(f, "show:%s", text, 0);
    }
    return 0;
}

/* A fresh fixture: object bytes 0x5a (so untouched and cleared fields are recognisable), caption channels 30 / 31, words +2 / +4
 * 70 / 71 and 90 / 91, all 22 names of both entries "N<e>_<i>". */
static void tf_init(TF *f)
{
    memset(f, 0, sizeof *f);
    memset(&f->o, 0x5a, sizeof f->o);
    f->o.slot = 3;
    f->o.row = 4;
    f->now = 1000000u;
    f->text = "TEXT";
    f->host.context = f;
    f->host.random = m_random;
    f->host.tick = m_tick;
    f->host.sound_prepare = m_prepare;
    f->host.sound_play = m_play;
    f->host.caption_text = m_text;
    f->host.caption_show = m_show;
    f->c.o = &f->o;
    f->c.body = f->body;
    f->c.w = &f->w;
    f->c.host = &f->host;
    for (int e = 0; e < 2; ++e) {
        t_put16(f->body, Q_CAP + (size_t)e * Q_CAP_STRIDE, 30 + e);
        t_put16(f->body, Q_CAP + (size_t)e * Q_CAP_STRIDE + 2, 70 + e);
        t_put16(f->body, Q_CAP + (size_t)e * Q_CAP_STRIDE + 4, 90 + e);
        for (int i = 0; i < 22; ++i) {
            char s[16];
            snprintf(s, sizeof s, "N%d_%d", e, i);
            t_name(f->body, Q_CAP + (size_t)e * Q_CAP_STRIDE + 6u + (size_t)i * Q_NAME, s);
        }
    }
}
static void tf_rand(TF *f, int n, const int32_t *v)
{
    for (int i = 0; i < n; ++i) f->rq[i] = v[i];
    f->nq = n;
    f->iq = 0;
}

/* 0x45ba0b: copy the 4 work rectangles (16 bytes at 0x36d + 0x20 * i; the second rectangle of each pair is not used) into both
 * roll sets, start positions 0x29 / 0x2b into +0x178 / +0x17a, mode := 0, current rectangles from 0xad + (pos - 1) * 16, marker
 * images from 0x3ed / 0x3fd, and zero the button animation block (+0x28..+0x35). Nothing else changes. */
static void test_reset_work(void)
{
    TF f;
    BulObject before;
    int rc;
    tf_init(&f);
    for (int i = 0; i < 4; ++i) {
        t_put_rect(f.body, Q_WORK + (size_t)i * 0x20, 100 * i + 1, 100 * i + 2, 100 * i + 3, 100 * i + 4);
        t_put_rect(f.body, Q_WORK + (size_t)i * 0x20 + 0x10, -1, -2, -3, -4);
    }
    for (int k = 1; k <= 15; ++k) t_put_rect(f.body, Q_POS + (size_t)(k - 1) * 16, 5000 + 10 * k, 5001 + 10 * k, 5002 + 10 * k, 5003 + 10 * k);
    t_put_rect(f.body, Q_MARK, 7001, 7002, 7003, 7004);
    t_put_rect(f.body, Q_MARK + 16, 7101, 7102, 7103, 7104);
    t_put16(f.body, Q_START_P, 2);
    t_put16(f.body, Q_START_C, 15); /* last position slot */
    f.o.mode = 3;
    f.o.anim_active = 1;
    f.o.button_kind = 2;
    f.o.anim_deadline = 0xdeadbeefu;
    f.o.button_down = 1;
    before = f.o;
    rc = reset_work(&f.c);
    CK(rc == BUL_OK);
    for (int i = 0; i < 4; ++i) {
        CK(t_rect_is(&f.o.roll_a[i], 100 * i + 1, 100 * i + 2, 100 * i + 3, 100 * i + 4));
        CK(t_rect_is(&f.o.roll_b[i], 100 * i + 1, 100 * i + 2, 100 * i + 3, 100 * i + 4));
    }
    CK(f.o.pos_player == 2);
    CK(f.o.pos_computer == 15);
    CK(f.o.mode == 0);
    CK(t_rect_is(&f.o.cur_player, 5020, 5021, 5022, 5023));        /* 0xad + 1 * 16 */
    CK(t_rect_is(&f.o.cur_computer, 5150, 5151, 5152, 5153));      /* 0xad + 14 * 16 */
    CK(t_rect_is(&f.o.image_player, 7001, 7002, 7003, 7004));
    CK(t_rect_is(&f.o.image_computer, 7101, 7102, 7103, 7104));
    CK(f.o.anim_active == 0 && f.o.button_kind == 0 && f.o.anim_deadline == 0u && f.o.button_down == 0);
    /* everything else is untouched */
    CK(f.o.state == before.state && f.o.score_player == before.score_player && f.o.score_computer == before.score_computer);
    CK(f.o.slot == 3 && f.o.row == 4 && f.o.surface == before.surface && f.o.side == before.side);
    CK(memcmp(&f.o.moving, &before.moving, sizeof before.moving) == 0);
    CK(memcmp(&f.o.erase, &before.erase, sizeof before.erase) == 0);
    CK(memcmp(f.o.clear, before.clear, sizeof before.clear) == 0);
    CK(f.o.deadline_16e == before.deadline_16e && f.o.deadline_17c == before.deadline_17c && f.o.next_state == before.next_state);
    CK(f.log[0] == '\0'); /* no host call */

    /* first position slot: both markers on position 1 read the first position rectangle */
    tf_init(&f);
    for (int k = 1; k <= 15; ++k) t_put_rect(f.body, Q_POS + (size_t)(k - 1) * 16, 5000 + 10 * k, 5001 + 10 * k, 5002 + 10 * k, 5003 + 10 * k);
    t_put16(f.body, Q_START_P, 1);
    t_put16(f.body, Q_START_C, 1);
    rc = reset_work(&f.c);
    CK(rc == BUL_OK);
    CK(f.o.pos_player == 1 && f.o.pos_computer == 1);
    CK(t_rect_is(&f.o.cur_player, 5010, 5011, 5012, 5013));
    CK(t_rect_is(&f.o.cur_computer, 5010, 5011, 5012, 5013));

    /* native-only guard (the original reads past the table): start position outside 1..15 */
    tf_init(&f);
    t_put16(f.body, Q_START_P, 16);
    t_put16(f.body, Q_START_C, 1);
    CK(reset_work(&f.c) == BUL_ERR_BOUNDS);
    tf_init(&f);
    t_put16(f.body, Q_START_P, 1);
    t_put16(f.body, Q_START_C, 0);
    CK(reset_work(&f.c) == BUL_ERR_BOUNDS);
}

/* 0x45bcc1: compare the two position words (+0x178 / +0x17a); when different return 0 and touch nothing. When equal: caption
 * pick (names 0x6e1 + side * 0x2dc, count 4, entry = side), state := 6, deadline +0x17c := GetTickCount() + 0x4b0, the side's
 * marker image (+0xec + side * 16) := body 0x40d + side * 16, the side's score word (+0xb6 + side * 2) += 1, return 1. */
static void test_step_check(void)
{
    TF f;
    int matched = 99, rc;
    BulObject before;
    const int32_t r6[1] = {6};

    /* positions differ (also when only the high byte differs): no effect */
    tf_init(&f);
    f.o.pos_player = 0x0101;
    f.o.pos_computer = 0x0001;
    before = f.o;
    rc = step_check(&f.c, 0, &matched);
    CK(rc == BUL_OK && matched == 0);
    CK(memcmp(&f.o, &before, sizeof before) == 0);
    CK(f.log[0] == '\0');

    /* equal, side 0: rand 6 % 4 = name 2 of the step list; order prepare, play(entry 0 channel 30), lookup, show, then tick */
    tf_init(&f);
    t_name(f.body, Q_STEP_NAMES, "S0_0");
    t_name(f.body, Q_STEP_NAMES + 1 * Q_NAME, "S0_1");
    t_name(f.body, Q_STEP_NAMES + 2 * Q_NAME, "S0_2");
    t_name(f.body, Q_STEP_NAMES + 3 * Q_NAME, "S0_3");
    t_put_rect(f.body, Q_MARK_AFTER, 8001, 8002, 8003, 8004);
    t_put_rect(f.body, Q_MARK_AFTER + 16, 8101, 8102, 8103, 8104);
    f.o.pos_player = 7;
    f.o.pos_computer = 7;
    f.o.score_player = 32767;
    f.o.score_computer = 1;
    f.o.state = 3;
    f.now = 5000u;
    tf_rand(&f, 1, r6);
    before = f.o;
    rc = step_check(&f.c, 0, &matched);
    CK(rc == BUL_OK && matched == 1);
    CK(strcmp(f.log, "rand,prep:S0_2,play:30,text:S0_2,show:TEXT<e>,tick") == 0);
    CK(f.o.state == 6); /* caption_pick set 10, step_check overrides it */
    CK(f.o.deadline_17c == 5000u + 0x4b0u);
    CK(t_rect_is(&f.o.image_player, 8001, 8002, 8003, 8004));
    CK(memcmp(&f.o.image_computer, &before.image_computer, sizeof before.image_computer) == 0);
    CK(f.o.score_player == -32768); /* 16-bit word add */
    CK(f.o.score_computer == 1);
    CK(strcmp((const char *)f.o.sound_name, "S0_2") == 0);
    CK(f.o.cap_channel == 30 && f.o.cap_1b1 == 70 && f.o.cap_1b3 == 90);

    /* equal, side 1: names at 0x6e1 + 0x2dc, entry 1 channel 31, image 0x41d, computer score; deadline wraps in 32 bits */
    tf_init(&f);
    t_name(f.body, Q_STEP_NAMES + Q_CAP_STRIDE, "S1_0");
    t_name(f.body, Q_STEP_NAMES + Q_CAP_STRIDE + 1 * Q_NAME, "S1_1");
    t_put_rect(f.body, Q_MARK_AFTER, 8001, 8002, 8003, 8004);
    t_put_rect(f.body, Q_MARK_AFTER + 16, 8101, 8102, 8103, 8104);
    f.o.pos_player = -3;
    f.o.pos_computer = -3;
    f.o.score_player = 2;
    f.o.score_computer = -1;
    f.now = 0xfffffff0u;
    {
        const int32_t r1[1] = {1};
        tf_rand(&f, 1, r1);
    }
    before = f.o;
    rc = step_check(&f.c, 1, &matched);
    CK(rc == BUL_OK && matched == 1);
    CK(strcmp(f.log, "rand,prep:S1_1,play:31,text:S1_1,show:TEXT<e>,tick") == 0);
    CK(f.o.state == 6);
    CK(f.o.deadline_17c == 0xfffffff0u + 0x4b0u); /* wraps */
    CK(t_rect_is(&f.o.image_computer, 8101, 8102, 8103, 8104));
    CK(memcmp(&f.o.image_player, &before.image_player, sizeof before.image_player) == 0);
    CK(f.o.score_computer == 0);
    CK(f.o.score_player == 2);
    CK(f.o.cap_channel == 31 && f.o.cap_1b1 == 71 && f.o.cap_1b3 == 91);

    /* equal, but the caption finds no real name (all four "NO SOUND"): the step still scores, no sound, state 6 */
    tf_init(&f);
    for (int i = 0; i < 4; ++i) {
        t_name(f.body, Q_STEP_NAMES + (size_t)i * Q_NAME, "NO SOUND");
    }
    t_put_rect(f.body, Q_MARK_AFTER, 8001, 8002, 8003, 8004);
    f.o.pos_player = 1;
    f.o.pos_computer = 1;
    f.o.score_player = 0;
    f.o.state = 0;
    f.now = 77u;
    {
        const int32_t rr[4] = {0, 1, 2, 3};
        tf_rand(&f, 4, rr);
    }
    rc = step_check(&f.c, 0, &matched);
    CK(rc == BUL_OK && matched == 1);
    CK(strcmp(f.log, "rand,rand,rand,rand,tick") == 0);
    CK(f.o.state == 6 && f.o.deadline_17c == 77u + 0x4b0u && f.o.score_player == 1);
    CK(t_rect_is(&f.o.image_player, 8001, 8002, 8003, 8004));

    /* caption_pick refuses an entry outside 0..1: the error propagates and nothing is scored */
    tf_init(&f);
    f.o.pos_player = 5;
    f.o.pos_computer = 5;
    f.o.score_player = 4;
    f.o.state = 3;
    before = f.o;
    rc = step_check(&f.c, 2, &matched);
    CK(rc == BUL_ERR_BOUNDS && matched == 0);
    CK(f.o.state == 3 && f.o.score_player == 4 && f.o.score_computer == before.score_computer);
    CK(f.log[0] == '\0');
}

/* 0x45be7f: fill the caption descriptor (+0x1a5 = word at entry +0, +0x1a7 = 2, +0x1a9 = 1, +0x1ab = 1, dword +0x1ad = 1,
 * +0x1b1 / +0x1b3 = entry words +2 / +4), then pick a name: count < 2 tests the single name (real = not "NO SOUND\0" in the
 * first 9 bytes and not empty), else draws _rand % count until a real name is found or every index was seen as non-real. On
 * a hit: copy the name (strlen + 1 bytes) to +0x184, prepare, play the entry channel, look the caption up, show text + "<e>"
 * unless the text is longer than 0x9c40 bytes, state := 10; returns 1. Otherwise returns 0 and changes nothing more. */
static void test_caption_pick(void)
{
    TF f;
    int found = 99, rc;
    const size_t names = 0x7e9; /* any name list; the single names below sit at its start */

    /* count 1, entry 0, a real name: no draw; descriptor, name copy (strlen + 1 only), host order, state 10 */
    tf_init(&f);
    t_name(f.body, names, "HELLO");
    memset(f.o.sound_name, 'Z', sizeof f.o.sound_name);
    rc = caption_pick(&f.c, names, 1, 0, &found);
    CK(rc == BUL_OK && found == 1);
    CK(strcmp(f.log, "prep:HELLO,play:30,text:HELLO,show:TEXT<e>") == 0);
    CK(f.o.cap_channel == 30 && f.o.cap_1a7 == 2 && f.o.cap_1a9 == 1 && f.o.cap_1ab == 1 && f.o.cap_1ad == 1);
    CK(f.o.cap_1b1 == 70 && f.o.cap_1b3 == 90);
    CK(memcmp(f.o.sound_name, "HELLO\0ZZZ", 9) == 0);
    CK(f.o.state == 10);

    /* count 1, entry 1: descriptor words come from the second entry (stride 0x2dc); count 0 behaves like count 1 */
    tf_init(&f);
    t_name(f.body, names, "BYE");
    rc = caption_pick(&f.c, names, 0, 1, &found);
    CK(rc == BUL_OK && found == 1);
    CK(strcmp(f.log, "prep:BYE,play:31,text:BYE,show:TEXT<e>") == 0);
    CK(f.o.cap_channel == 31 && f.o.cap_1b1 == 71 && f.o.cap_1b3 == 91 && f.o.state == 10);

    /* count 1, not a real name: "NO SOUND", empty, and the descriptor is still written; state and name untouched */
    tf_init(&f);
    t_name(f.body, names, "NO SOUND");
    f.o.state = 3;
    memset(f.o.sound_name, 'Z', sizeof f.o.sound_name);
    rc = caption_pick(&f.c, names, 1, 1, &found);
    CK(rc == BUL_OK && found == 0);
    CK(f.log[0] == '\0' && f.o.state == 3 && f.o.sound_name[0] == 'Z');
    CK(f.o.cap_channel == 31 && f.o.cap_1a7 == 2 && f.o.cap_1b1 == 71 && f.o.cap_1b3 == 91);
    tf_init(&f);
    t_name(f.body, names, "");
    f.o.state = 3;
    rc = caption_pick(&f.c, names, 1, 0, &found);
    CK(rc == BUL_OK && found == 0 && f.o.state == 3 && f.log[0] == '\0');

    /* "NO SOUND2" differs from "NO SOUND\0" within the 9 compared bytes, so it is a real name */
    tf_init(&f);
    t_name(f.body, names, "NO SOUND2");
    rc = caption_pick(&f.c, names, 1, 0, &found);
    CK(rc == BUL_OK && found == 1 && strcmp((const char *)f.o.sound_name, "NO SOUND2") == 0);
    CK(strcmp(f.log, "prep:NO SOUND2,play:30,text:NO SOUND2,show:TEXT<e>") == 0);

    /* count 4: the first draw (6 % 4 = 2) is a real name: one draw, that name */
    tf_init(&f);
    t_name(f.body, names + 0 * Q_NAME, "A0");
    t_name(f.body, names + 1 * Q_NAME, "A1");
    t_name(f.body, names + 2 * Q_NAME, "A2");
    t_name(f.body, names + 3 * Q_NAME, "A3");
    {
        const int32_t r[1] = {6};
        tf_rand(&f, 1, r);
    }
    rc = caption_pick(&f.c, names, 4, 0, &found);
    CK(rc == BUL_OK && found == 1 && f.iq == 1);
    CK(strcmp(f.log, "rand,prep:A2,play:30,text:A2,show:TEXT<e>") == 0);
    CK(f.o.state == 10);

    /* count 4, hit on the third draw: draws 0 ("NO SOUND") and 4 (0 again), then 7 % 4 = 3 (real); entry 1 */
    tf_init(&f);
    t_name(f.body, names + 0 * Q_NAME, "NO SOUND");
    t_name(f.body, names + 1 * Q_NAME, "");
    t_name(f.body, names + 2 * Q_NAME, "NO SOUND");
    t_name(f.body, names + 3 * Q_NAME, "REAL3");
    {
        const int32_t r[3] = {0, 4, 7};
        tf_rand(&f, 3, r);
    }
    rc = caption_pick(&f.c, names, 4, 1, &found);
    CK(rc == BUL_OK && found == 1 && f.iq == 3);
    CK(strcmp(f.log, "rand,rand,rand,prep:REAL3,play:31,text:REAL3,show:TEXT<e>") == 0);
    CK(strcmp((const char *)f.o.sound_name, "REAL3") == 0 && f.o.state == 10);

    /* count 4, every name non-real: the loop ends exactly when all four indexes were seen (draws 1 1 0 3 2 = five draws,
     * the empty name counts as non-real too); nothing is prepared and the state stays */
    tf_init(&f);
    t_name(f.body, names + 0 * Q_NAME, "NO SOUND");
    t_name(f.body, names + 1 * Q_NAME, "NO SOUND");
    t_name(f.body, names + 2 * Q_NAME, "");
    t_name(f.body, names + 3 * Q_NAME, "NO SOUND");
    {
        const int32_t r[6] = {1, 1, 0, 3, 2, 0};
        tf_rand(&f, 6, r);
    }
    f.o.state = 3;
    rc = caption_pick(&f.c, names, 4, 0, &found);
    CK(rc == BUL_OK && found == 0 && f.iq == 5);
    CK(strcmp(f.log, "rand,rand,rand,rand,rand") == 0);
    CK(f.o.state == 3 && f.o.cap_channel == 30);

    /* count 2 is the smallest drawn count: 32767 % 2 = 1 picks name 1 */
    tf_init(&f);
    t_name(f.body, names + 0 * Q_NAME, "NO SOUND");
    t_name(f.body, names + 1 * Q_NAME, "TWO");
    {
        const int32_t r[1] = {32767};
        tf_rand(&f, 1, r);
    }
    rc = caption_pick(&f.c, names, 2, 0, &found);
    CK(rc == BUL_OK && found == 1 && strcmp(f.log, "rand,prep:TWO,play:30,text:TWO,show:TEXT<e>") == 0);

    /* caption text missing: no show, the state is still 10 */
    tf_init(&f);
    t_name(f.body, names, "QUIET");
    f.text = NULL;
    rc = caption_pick(&f.c, names, 1, 0, &found);
    CK(rc == BUL_OK && found == 1 && f.o.state == 10);
    CK(strcmp(f.log, "prep:QUIET,play:30,text:QUIET") == 0);

    /* caption text of exactly 200 characters is shown with the suffix (203 characters) */
    {
        char t200[201];
        memset(t200, 'x', 200);
        t200[200] = '\0';
        tf_init(&f);
        t_name(f.body, names, "LONG");
        f.text = t200;
        rc = caption_pick(&f.c, names, 1, 0, &found);
        CK(rc == BUL_OK && found == 1 && f.o.state == 10);
        CK(strcmp(f.log, "prep:LONG,play:30,text:LONG,show:len203") == 0);
    }

    /* text longer than 0x9c40 bytes is not shown, but the state still becomes 10 */
    {
        char *big = (char *)malloc(0x9c41u + 2u);
        CK(big != NULL);
        if (big != NULL) {
            memset(big, 'y', 0x9c41u);
            big[0x9c41u] = '\0';
            tf_init(&f);
            t_name(f.body, names, "HUGE");
            f.long_text = big;
            rc = caption_pick(&f.c, names, 1, 0, &found);
            CK(rc == BUL_OK && found == 1 && f.o.state == 10);
            CK(strcmp(f.log, "prep:HUGE,play:30,text:HUGE") == 0);
            /* length 0x9c40 passes the original's length test (it would overflow its 204-byte buffer); the kernel refuses with
             * BUL_ERR_BOUNDS after the lookup. Same for length 201. */
            big[0x9c40u] = '\0';
            tf_init(&f);
            t_name(f.body, names, "HUGE");
            f.long_text = big;
            rc = caption_pick(&f.c, names, 1, 0, &found);
            CK(rc == BUL_ERR_BOUNDS && found == 0);
            CK(strcmp(f.log, "prep:HUGE,play:30,text:HUGE") == 0);
            big[201] = '\0';
            tf_init(&f);
            t_name(f.body, names, "HUGE");
            f.long_text = big;
            rc = caption_pick(&f.c, names, 1, 0, &found);
            CK(rc == BUL_ERR_BOUNDS && found == 0);
            free(big);
        }
    }

    /* native-only guards: entry outside 0..1 or count > 10 return BUL_ERR_BOUNDS before any write or host call */
    tf_init(&f);
    t_name(f.body, names, "G");
    f.o.state = 3;
    rc = caption_pick(&f.c, names, 1, 2, &found);
    CK(rc == BUL_ERR_BOUNDS && found == 0 && f.o.state == 3 && f.log[0] == '\0' && f.o.cap_1a7 == 0x5a5a);
    rc = caption_pick(&f.c, names, 1, -1, &found);
    CK(rc == BUL_ERR_BOUNDS && found == 0);
    rc = caption_pick(&f.c, names, 11, 0, &found);
    CK(rc == BUL_ERR_BOUNDS && found == 0 && f.log[0] == '\0');
}

int main(void)
{
    static const struct {
        const char *name;
        void (*fn)(void);
    } cases[] = {{"test_reset_work", test_reset_work}, {"test_step_check", test_step_check}, {"test_caption_pick", test_caption_pick}};
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
