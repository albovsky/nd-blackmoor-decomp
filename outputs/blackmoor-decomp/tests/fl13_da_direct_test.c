/* FL-13 direct test of score_check (original GAME.EXE 0x45bda7) in the raw 0xda Bul puzzle kernel. The kernel is pulled in as
 * a translation unit (same pattern as tests/fl11_da_direct_test.c). Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status
 * is the failure count. Fixtures are synthetic. Expected values come from the original's pseudocode, not from the kernel:
 *   if (*(short*)(this+0xb6) == piece_count) { *(int*)(this+0x16a)=1; *(int*)(this+0x24)=7; *(int*)(this+0x162)=1; return 1; }
 *   else if (*(short*)(this+0xb8) == piece_count) { *(int*)(this+0x24)=8; *(int*)(this+0x162)=1; return 1; }
 *   else return 0;
 * with piece_count = the short at body +0x23. The native BulObject is not laid out at the original offsets, so fields are named: score_player = +0xb6, score_computer = +0xb8,
 * state = +0x24, finish_kind = +0x162, won = +0x16a; the piece count is the body word at +0x23 (literal below). */
#include "../src/action_family_da_runtime.c"

#include <stddef.h>
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

typedef struct {
    BulObject o;
    BulWorld w;
    BulHost host;
    uint8_t body[BUL_BODY_BYTES];
    Ctx c;
} TF;

static void tf_init(TF *f, int pieces, int sp, int sc)
{
    memset(f, 0, sizeof *f);
    memset(&f->o, 0x5a, sizeof f->o);
    f->c.o = &f->o;
    f->c.body = f->body;
    f->c.w = &f->w;
    f->c.host = &f->host;
    f->body[0x23] = (uint8_t)pieces;
    f->body[0x24] = (uint8_t)((unsigned)pieces >> 8);
    f->o.score_player = (int16_t)sp;
    f->o.score_computer = (int16_t)sc;
}

static void test_score_check(void)
{
    TF f;
    BulObject before;
    int r;
    /* player reaches the piece count: won := 1, state := 7, finish kind := 1, return 1 */
    tf_init(&f, 6, 6, 2);
    before = f.o;
    r = score_check(&f.c);
    CK(r == 1);
    CK(f.o.won == 1 && f.o.state == 7 && f.o.finish_kind == 1);
    CK(f.o.score_player == 6 && f.o.score_computer == 2);
    CK(memcmp(&f.o.moving, &before.moving, sizeof before.moving) == 0 && f.o.slot == before.slot && f.o.mode == before.mode);

    /* computer reaches the count: state := 8, finish kind := 1, won untouched, return 1 */
    tf_init(&f, 6, 3, 6);
    r = score_check(&f.c);
    CK(r == 1);
    CK(f.o.state == 8 && f.o.finish_kind == 1 && f.o.won == 0x5a5a5a5a);

    /* both at the count: the player branch is tested first */
    tf_init(&f, 4, 4, 4);
    r = score_check(&f.c);
    CK(r == 1 && f.o.won == 1 && f.o.state == 7 && f.o.finish_kind == 1);

    /* neither: return 0 and not one field changes */
    tf_init(&f, 6, 5, 5);
    before = f.o;
    r = score_check(&f.c);
    CK(r == 0);
    CK(memcmp(&f.o, &before, sizeof before) == 0);

    /* 16-bit comparison: a score above the count (or negative) is not a win; a count read as a signed word */
    tf_init(&f, 6, 7, -6);
    before = f.o;
    r = score_check(&f.c);
    CK(r == 0 && memcmp(&f.o, &before, sizeof before) == 0);
    tf_init(&f, 0x0101, 0x0101, 0);
    r = score_check(&f.c);
    CK(r == 1 && f.o.state == 7);
    tf_init(&f, 1, 0x0101, 0x0001); /* only the low byte equal: the word compare must not match the player */
    r = score_check(&f.c);
    CK(r == 1 && f.o.state == 8 && f.o.won == 0x5a5a5a5a);
    tf_init(&f, 0, 0, 0); /* zero count, zero score: equal, player first */
    r = score_check(&f.c);
    CK(r == 1 && f.o.state == 7 && f.o.won == 1);
}

int main(void)
{
    static const struct {
        const char *name;
        void (*fn)(void);
    } cases[] = {{"test_score_check", test_score_check}};
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
