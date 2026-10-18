/* FL-13 direct test of the solved check of the raw 0xd1 kernel (src/action_family_d1_runtime.c).
 *
 * solved_check is `static`, so this test includes the kernel source and calls it. Prints "PASS <name>" / "FAIL <name>:
 * <message>"; the exit status is the failure count. Fixtures are synthetic bodies and objects (no original bytes). Expected
 * values come from the Ghidra pseudocode of GAME.EXE 0x4b642d FUN_004b642d (thiscall on the singleton, no arguments):
 *   for (i = 0; ; ++i) {
 *     if (count_word(row body + 0x21) <= i) { *(byte *)(this + 0x22a) = 1; *(dword *)(this + 0x274) = 1; return; }
 *     if (*(short *)(this + 0x254 + 2*i) != *(short *)(row body + 0x30a + 2*i)) return; }
 * with literal offsets: the tile count is the signed word at body +0x21, the targets are signed words from body +0x30a,
 * the frames are the signed words at object +0x254, the solved byte is object +0x22a and the state dword object +0x274
 * (D1Object is a field-per-offset model, not a byte image, so the fields solved / frame / state stand for them). Nothing else is written. */
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "../src/action_family_d1_runtime.c"

static int g_failed;
static char g_msg[400];

#define EXPECT(cond)                                                                       \
    do {                                                                                   \
        if (!g_failed && !(cond)) {                                                        \
            g_failed = 1;                                                                  \
            snprintf(g_msg, sizeof g_msg, "line %d: %s", __LINE__, #cond);                 \
        }                                                                                  \
    } while (0)

typedef struct {
    int effects;
    int last_effect, last_a, last_b;
} Obs;

static void observe(void *context, int effect, int32_t a, int32_t b)
{
    Obs *o = (Obs *)context;
    o->effects += 1;
    o->last_effect = effect;
    o->last_a = a;
    o->last_b = b;
}

static void put16(uint8_t *b, unsigned at, int16_t v)
{
    b[at] = (uint8_t)(uint16_t)v;
    b[at + 1] = (uint8_t)((uint16_t)v >> 8);
}

/* One run. frames/targets: n values each. Returns solved after the call; checks the rest of the object too. */
static void run_case(int n, const int16_t *frames, const int16_t *targets, int expect_solved)
{
    uint8_t body[0x400];
    D1Object o, before;
    D1Host host;
    Obs obs = {0, 0, 0, 0};
    int i;

    memset(body, 0x5c, sizeof body);
    put16(body, 0x21, (int16_t)n);
    for (i = 0; i < n; ++i) put16(body, 0x30a + 2u * (unsigned)i, targets[i]);
    memset(&o, 0x11, sizeof o);
    o.solved = 0;
    o.state = 0;
    for (i = 0; i < n; ++i) o.frame[i] = frames[i];
    before = o;
    memset(&host, 0, sizeof host);
    host.observe = observe;
    host.context = &obs;
    solved_check(&o, body, &host);
    if (expect_solved) {
        before.solved = 1;
        before.state = 1;
        EXPECT(obs.effects == 1 && obs.last_effect == D1_FX_STATE && obs.last_a == 1);
    } else {
        EXPECT(obs.effects == 0);
    }
    EXPECT(memcmp(&before, &o, sizeof o) == 0);
    EXPECT(o.solved == (expect_solved ? 1 : 0));
    EXPECT(o.state == (expect_solved ? 1 : 0));
}

static void t_solved_check(void)
{
    const int16_t a[] = {1, 2, 3, 4};
    const int16_t neg[] = {-1, -32768, 32767, 0};
    int16_t b[4];

    run_case(4, a, a, 1);                       /* every frame equals its target */
    run_case(0, a, b, 1);                       /* no tiles: the first loop test already ends it */
    memcpy(b, a, sizeof b);
    b[0] = 9;
    run_case(4, a, b, 0);                       /* first differs */
    memcpy(b, a, sizeof b);
    b[3] = 9;
    run_case(4, a, b, 0);                       /* only the last differs */
    memcpy(b, a, sizeof b);
    b[2] = 3 + 256;
    run_case(4, a, b, 0);                       /* a difference in the high byte of a word */
    run_case(4, neg, neg, 1);                   /* signed words compare equal bit for bit */
    memcpy(b, neg, sizeof b);
    b[1] = 32767;
    run_case(4, neg, b, 0);
    /* only the first n tiles are compared: a difference past the count is ignored */
    {
        int16_t f[4] = {5, 6, 7, 8}, t[4] = {5, 6, 0, 0};
        run_case(2, f, t, 1);
        run_case(3, f, t, 0);
    }
}

typedef struct Case {
    const char *name;
    void (*fn)(void);
} Case;

int main(void)
{
    static const Case cases[] = {{"solved_check", t_solved_check}};
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
