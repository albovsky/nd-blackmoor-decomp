/* FL-11 direct tests of the static helpers of the raw 0x2d random-movie kernel (src/action_family_2d_runtime.c).
 * The kernel is pulled in as a translation unit (same shim pattern as tests/action_family_28_x87_division_fixture.c) so that
 * rand_mod and pick_record can be called directly. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the failure
 * count. Fixtures are synthetic (no original bytes). Expected values are derived by hand from the original GAME.EXE functions
 * 0x4cf0a9 (FUN_004cf0a9) and 0x4cf0ce (FUN_004cf0ce), not by running the kernel. In the original, entry weights and record
 * weights are signed words (entry +0x2d, record +0x21), the entry record count is the word at +0x2f. */
#include "../src/action_family_2d_runtime.c"

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

/* Host mock: logs every engine op in order and answers D2_OP_RAND from a scripted queue (the original's _rand, 0x50cd50). */
typedef struct {
    int ops[16];
    unsigned n;
    int32_t queue[8];
    unsigned qn, qi;
    int fail_at; /* 1-based call number that fails, 0 = never */
} Rig;

static int t_op(void *context, int op, const D2OpArgs *args, int32_t *ret)
{
    Rig *r = (Rig *)context;
    (void)args;
    if (r->n < sizeof r->ops / sizeof r->ops[0]) r->ops[r->n] = op;
    ++r->n;
    if (r->fail_at != 0 && (int)r->n == r->fail_at) return 1;
    *ret = 0;
    if (op == D2_OP_RAND) *ret = r->qi < r->qn ? r->queue[r->qi++] : 0x7ffffff;
    return 0;
}

static void t_rig(Rig *r, D2Host *h, int32_t value)
{
    memset(r, 0, sizeof *r);
    memset(h, 0, sizeof *h);
    h->context = r;
    h->op = t_op;
    r->queue[r->qn++] = value;
}

/* Exactly one engine op, a _rand, and the scripted value was consumed. */
static int t_one_rand(const Rig *r) { return r->n == 1 && r->ops[0] == D2_OP_RAND && r->qi == 1; }

/* 0x4cf0a9: one _rand; for the parameter -1 the raw value is returned, otherwise _rand() % param (idiv: the remainder takes
 * the dividend's sign). The original faults on a zero divisor after drawing; the native reports D2_ERR_BODY (expected
 * difference E1 of the oracle). */
static int test_rand_mod(void)
{
    static const struct {
        int32_t count, r, expect;
    } k[] = {
        {-1, 12345, 12345}, {-1, 0, 0},    {-1, 32767, 32767}, /* raw value */
        {1, 999, 0},        {7, 100, 2},   {7, 6, 6},          {7, 7, 0},       {7, 0, 0},
        {50000, 123, 123},  {32767, 32767, 0}, {32768, 32767, 32767},
        {-5, 13, 3},        {-7, 20, 6},   /* negative divisor other than -1: the remainder keeps the dividend's sign */
        {-2, 4, 0},
    };
    Rig r;
    D2Host h;
    const char *why = NULL;
    int32_t out;
    g_failed = 0;

    for (size_t i = 0; i < sizeof k / sizeof k[0]; ++i) {
        t_rig(&r, &h, k[i].r);
        out = -1234;
        CK(rand_mod(&h, k[i].count, &out, &why) == D2_OK);
        CK(out == k[i].expect);
        CK(t_one_rand(&r));
    }

    /* Zero divisor: the draw happens first (same order as the original), then the error; the output is untouched. */
    t_rig(&r, &h, 5);
    out = -1234;
    why = "unset";
    CK(rand_mod(&h, 0, &out, &why) == D2_ERR_BODY);
    CK(out == -1234 && t_one_rand(&r) && strcmp(why, "unset") != 0);

    /* A failing host draw stops before any result is produced. */
    t_rig(&r, &h, 5);
    r.fail_at = 1;
    out = -1234;
    CK(rand_mod(&h, 7, &out, &why) == D2_ERR_HOST);
    CK(out == -1234 && r.n == 1);
    return g_failed;
}

/* Entries (clip weight w, record weights): the index passed to pick_record is o->clip_246.
 *   0: w 3, records 5, 2         total 10: clip [0,3) -> -1, record 0 [3,8), record 1 [8,10)
 *   1: w 0, records 4, 0, 6      total 10: record 0 [0,4), record 1 skipped (weight 0), record 2 [4,10)
 *   2: w -2, records 5           total 3:  no clip window (negative weight), record 0 [0,5)
 *   3: w 3, records 5, -2, 4     total 10: clip [0,3), record 0 [3,8), record 1 skipped, record 2 [8,12)
 *   4: w 0, records 4, -5        total -1: no modulo (raw draw), record 0 [0,4)
 *   5: w 0, no records           total 0:  divide by zero after the draw
 *   6: w 4, no records           total 4:  only the clip window
 *   7: w 1, records 1, 1, 1      total 4:  windows of one each
 *   8: w 32767, records 32767 x2 total 98301: windows at the int16 maximum */
static D2Record rec_e0[] = {{"", 5}, {"", 2}};
static D2Record rec_e1[] = {{"", 4}, {"", 0}, {"", 6}};
static D2Record rec_e2[] = {{"", 5}};
static D2Record rec_e3[] = {{"", 5}, {"", -2}, {"", 4}};
static D2Record rec_e4[] = {{"", 4}, {"", -5}};
static D2Record rec_e7[] = {{"", 1}, {"", 1}, {"", 1}};
static D2Record rec_e8[] = {{"", 32767}, {"", 32767}};

static void ps_build(D2Set *set, D2Entry *e)
{
    memset(e, 0, 9 * sizeof *e);
    e[0].weight = 3, e[0].record_count = 2, e[0].records = rec_e0;
    e[1].weight = 0, e[1].record_count = 3, e[1].records = rec_e1;
    e[2].weight = -2, e[2].record_count = 1, e[2].records = rec_e2;
    e[3].weight = 3, e[3].record_count = 3, e[3].records = rec_e3;
    e[4].weight = 0, e[4].record_count = 2, e[4].records = rec_e4;
    e[5].weight = 0, e[5].record_count = 0;
    e[6].weight = 4, e[6].record_count = 0;
    e[7].weight = 1, e[7].record_count = 3, e[7].records = rec_e7;
    e[8].weight = 32767, e[8].record_count = 2, e[8].records = rec_e8;
    memset(set, 0, sizeof *set);
    set->entries = e;
    set->entry_count = 9;
}

typedef struct {
    int entry, r, expect;
} PickCase;

static int test_pick_record(void)
{
    static const PickCase cases[] = {
        /* entry 0: clip [0,3), record 0 [3,8), record 1 [8,10); the draw is taken modulo 10 */
        {0, 0, -1}, {0, 2, -1}, {0, 3, 0}, {0, 7, 0}, {0, 8, 1}, {0, 9, 1}, {0, 10, -1}, {0, 17, 0}, {0, 19, 1},
        /* entry 1: zero clip weight, a zero-weight record is skipped */
        {1, 0, 0}, {1, 3, 0}, {1, 4, 2}, {1, 9, 2},
        /* entry 2: a negative clip weight opens no window and reduces the total: r % 3 always lands in record 0 */
        {2, 0, 0}, {2, 1, 0}, {2, 2, 0}, {2, 5, 0},
        /* entry 3: a negative record weight reduces the total and is skipped: the last record starts at 8 */
        {3, 2, -1}, {3, 3, 0}, {3, 7, 0}, {3, 8, 2}, {3, 9, 2},
        /* entry 4: total -1 means the raw draw (no modulo): 100 is outside [0,4) -> stay (-1); modulo would give record 0 */
        {4, 100, -1}, {4, 3, 0}, {4, 4, -1},
        /* entry 6: only the clip window: always stay */
        {6, 0, -1}, {6, 3, -1}, {6, 5, -1},
        /* entry 7: clip [0,1), records [1,2), [2,3), [3,4) */
        {7, 0, -1}, {7, 1, 0}, {7, 2, 1}, {7, 3, 2},
        /* entry 8: windows around the int16 maximum, total 98301 */
        {8, 32766, -1}, {8, 32767, 0},
    };
    D2Set set;
    D2Entry entries[9];
    D2Object o;
    Rig r;
    D2Host h;
    const char *why = NULL;
    int32_t out;
    g_failed = 0;

    ps_build(&set, entries);
    memset(&o, 0, sizeof o);
    o.set = &set;
    for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        t_rig(&r, &h, cases[i].r);
        o.clip_246 = cases[i].entry;
        out = -77;
        CK(pick_record(&o, &h, &out, &why) == D2_OK);
        if (out != cases[i].expect) {
            snprintf(g_msg, sizeof g_msg, "entry %d draw %d: got %d want %d", cases[i].entry, cases[i].r, (int)out, cases[i].expect);
            g_failed = 1;
        }
        CK(t_one_rand(&r)); /* exactly one _rand per pick */
    }

    /* Entry 8 with draws beyond rand's 32767 (only to reach its upper windows), taken modulo the total 98301:
     * 98301 % 98301 = 0 -> clip window; 163835 % 98301 = 65534 -> record 1 [65534, 98301). */
    t_rig(&r, &h, 98301);
    o.clip_246 = 8;
    out = -77;
    CK(pick_record(&o, &h, &out, &why) == D2_OK && out == -1 && t_one_rand(&r));
    t_rig(&r, &h, 98301 + 65534);
    out = -77;
    CK(pick_record(&o, &h, &out, &why) == D2_OK && out == 1 && t_one_rand(&r));

    /* Entry 5: total 0, the divide fault of the original (D2_ERR_BODY natively) happens after the draw. */
    t_rig(&r, &h, 4);
    o.clip_246 = 5;
    out = -77;
    CK(pick_record(&o, &h, &out, &why) == D2_ERR_BODY && out == -77 && t_one_rand(&r));

    /* A failing host draw stops the pick. */
    t_rig(&r, &h, 4);
    r.fail_at = 1;
    o.clip_246 = 0;
    out = -77;
    CK(pick_record(&o, &h, &out, &why) == D2_ERR_HOST && out == -77 && r.n == 1);

    /* Native-only argument checks (no original counterpart): no draw is taken. */
    t_rig(&r, &h, 4);
    o.clip_246 = 9;
    CK(pick_record(&o, &h, &out, &why) == D2_ERR_ARGUMENT && r.n == 0);
    o.clip_246 = -1;
    CK(pick_record(&o, &h, &out, &why) == D2_ERR_ARGUMENT && r.n == 0);
    o.clip_246 = 0;
    o.set = NULL;
    CK(pick_record(&o, &h, &out, &why) == D2_ERR_ARGUMENT && r.n == 0);
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
    failures += run_one("test_rand_mod", test_rand_mod);
    failures += run_one("test_pick_record", test_pick_record);
    return failures;
}
