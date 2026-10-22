/* FL-39 (batch b) direct tests of the 20 GAME.EXE functions in src/original_methods_fl39b.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl39b_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl39b.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define UNUSED_FN __attribute__((unused))

static int g_failed;
static char g_msg[256];
#define CK(cond)                                                               \
    do {                                                                       \
        if (!(cond) && !g_failed) {                                            \
            g_failed = 1;                                                      \
            snprintf(g_msg, sizeof g_msg, "line %d: %.200s", __LINE__, #cond); \
        }                                                                      \
    } while (0)

#define SELF_SIZE 0x400
static uint8_t g_self[SELF_SIZE];
#define SELF g_self
static Fl18Host g_host;
static Fl39bWorld g_w;

UNUSED_FN static void put32(uint8_t *p, size_t off, uint32_t v)
{
    p[off] = (uint8_t)v;
    p[off + 1] = (uint8_t)(v >> 8);
    p[off + 2] = (uint8_t)(v >> 16);
    p[off + 3] = (uint8_t)(v >> 24);
}

UNUSED_FN static void put16(uint8_t *p, size_t off, uint16_t v)
{
    p[off] = (uint8_t)v;
    p[off + 1] = (uint8_t)(v >> 8);
}

UNUSED_FN static uint32_t get32(const uint8_t *p, size_t off)
{
    return (uint32_t)p[off] | (uint32_t)p[off + 1] << 8 | (uint32_t)p[off + 2] << 16 | (uint32_t)p[off + 3] << 24;
}

#define MAXCALL 16
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[8];
        uint32_t first_dword;   /* the dword at [this] at the call (host pointers only) */
    } c[MAXCALL];
} L;
static uint32_t g_ret;           /* the answer of every callee without an entry in g_ans */
#define MAXANS 8
static struct {
    int n;
    uint32_t callee[MAXANS], value[MAXANS];
} g_ans;                         /* per-callee answers: the callee, and the value it returns (every call) */

/* regions of fake original memory behind addresses: {address, host pointer, length} */
static struct {
    int n;
    struct {
        uint32_t va;
        uint8_t *p;
        uint32_t len;
    } r[8];
} g_reg;

UNUSED_FN static void answer(uint32_t callee, uint32_t value)
{
    g_ans.callee[g_ans.n] = callee;
    g_ans.value[g_ans.n++] = value;
}

UNUSED_FN static void region_add(uint32_t va, uint8_t *p, uint32_t len)
{
    g_reg.r[g_reg.n].va = va;
    g_reg.r[g_reg.n].p = p;
    g_reg.r[g_reg.n++].len = len;
}

static uint32_t host_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int k, i = L.n;
    (void)ctx;
    if (L.n < MAXCALL) {
        L.c[i].callee = callee;
        L.c[i].this_ptr = this_ptr;
        L.c[i].nargs = nargs;
        for (k = 0; k < nargs && k < 8; k++) L.c[i].a[k] = args[k];
        L.c[i].first_dword = this_ptr > 0xffffffffu ? get32((const uint8_t *)this_ptr, 0) : 0;
    }
    L.n++;
    for (k = 0; k < g_ans.n; k++)
        if (g_ans.callee[k] == callee) return g_ans.value[k];
    return g_ret;
}

static const uint8_t *host_resolve(void *ctx, uint32_t a)
{
    int k;
    (void)ctx;
    for (k = 0; k < g_reg.n; k++)
        if (a >= g_reg.r[k].va && a < g_reg.r[k].va + g_reg.r[k].len) return g_reg.r[k].p + (a - g_reg.r[k].va);
    return NULL;
}

static void setup(void)
{
    size_t i;
    for (i = 0; i < SELF_SIZE; i++) g_self[i] = (uint8_t)(i * 7 + 3);
    memset(&g_host, 0, sizeof g_host);
    g_host.call = host_call;
    g_host.resolve = host_resolve;
    L.n = 0;
    g_ret = 0;
    g_ans.n = 0;
    g_reg.n = 0;
}

static const uint32_t RETS[] UNUSED_FN = {0, 0x80000000u, 0xcafef00du, 0xffffffffu};
#define NRETS (sizeof RETS / sizeof RETS[0])

typedef int32_t (*CloneFn)(uint32_t, uint32_t, uint32_t, Fl39bWorld *, const Fl18Host *);
#define CL_CELLS 0x20010000u
#define CL_SRC 0x20020000u
#define CL_BLK 0x20030000u
/* The three arguments are the original addresses of three dword cells: the block cell (receives the allocation), the source cursor and the counter. The block of `size` bytes is allocated
 * by 0x51dc43(size); non-zero result: size bytes are copied from the cursor to the block, the counter and the cursor advance by size, and a non-zero debug word calls 0x44a2b7(p3).
 * Null result: 0x50ca3e(0x63888b, p1, dword 0x5bb57b, sign-extended word 0x5c39e3), 0x42639d(this 0x583979, p2, 0x63888b), 0x4c97b4(this 0x5cf659) and then either the native rejection
 * (return 1) or, for the row that exits (`exits`), dword 0x63a58a = 5 before 0x4c97b4 and a normal return (0) with nothing copied.
 * All blocks are exactly sized heap blocks, so that a sanitiser reports a read or write outside the bytes the function touches. */
static void check_clone(CloneFn fn, uint32_t size, uint32_t p1, uint32_t p2, uint32_t p3, int exits)
{
    static const uint16_t dbgs[] = {0, 1, 0x100, 0x8000, 0xffff};
    static const uint32_t offs[] = {0, 1, 3, 8};
    static const int16_t words[] = {0, -1, 0x7fff, -0x8000, 0x1234};
    size_t d, o, k;
    int fail;
    for (fail = 0; fail < 2 && !g_failed; fail++)
        for (d = 0; d < 5 && !g_failed; d++)
            for (o = 0; o < 4 && !g_failed; o++) {
                const uint32_t off = offs[o], cnt0 = (uint32_t)(0xfffffff0u + 7u * d);
                uint8_t *cells = (uint8_t *)malloc(12), *src = (uint8_t *)malloc(off + size), *blk = (uint8_t *)malloc(size), *srcsnap = (uint8_t *)malloc(off + size);
                int32_t ret;
                uint32_t n = 0;
                CK(cells != NULL && src != NULL && blk != NULL && srcsnap != NULL);
                if (cells == NULL || src == NULL || blk == NULL || srcsnap == NULL) return;
                setup();
                for (k = 0; k < off + size; k++) src[k] = (uint8_t)(0x40 + k * 13);
                memcpy(srcsnap, src, off + size);
                memset(blk, 0xa5, size);
                put32(cells, 0, 0x11223344u);
                put32(cells, 4, CL_SRC + off);
                put32(cells, 8, cnt0);
                region_add(CL_CELLS, cells, 12);
                region_add(CL_SRC, src, off + size);
                region_add(CL_BLK, blk, size);
                g_ans.n = 0;
                answer(0x51dc43, fail ? 0u : CL_BLK);
                g_ret = 0xcafef00du;
                memset(&g_w, 0, sizeof g_w);
                g_w.value_5bb57b = 0xcafe0000u + (uint32_t)d;
                g_w.word_5c39e3 = words[d];
                g_w.word_63a4cd = (int16_t)dbgs[d];
                g_w.value_63a58a = 0x77u;
                ret = fn(CL_CELLS, CL_CELLS + 4, CL_CELLS + 8, &g_w, &g_host);
                CK(L.c[0].callee == 0x51dc43 && L.c[0].this_ptr == 0 && L.c[0].nargs == 1 && L.c[0].a[0] == size);
                CK(get32(cells, 4) == (fail ? CL_SRC + off : CL_SRC + off + size) && get32(cells, 8) == (fail ? cnt0 : cnt0 + size));
                CK(memcmp(src, srcsnap, off + size) == 0);
                if (!fail) {
                    CK(ret == 0 && get32(cells, 0) == CL_BLK && memcmp(blk, src + off, size) == 0);
                    CK(L.n == (dbgs[d] != 0 ? 2 : 1));
                    if (dbgs[d] != 0) CK(L.c[1].callee == 0x44a2b7 && L.c[1].this_ptr == 0 && L.c[1].nargs == 1 && L.c[1].a[0] == p3);
                    CK(g_w.value_63a58a == 0x77u);
                } else {
                    for (k = 0; k < size; k++) n += blk[k] != 0xa5;
                    CK(ret == (exits ? 0 : 1) && get32(cells, 0) == 0 && n == 0);
                    CK(L.n == 4);
                    CK(L.c[1].callee == 0x50ca3e && L.c[1].this_ptr == 0 && L.c[1].nargs == 4 && L.c[1].a[0] == 0x63888b && L.c[1].a[1] == p1 && L.c[1].a[2] == 0xcafe0000u + (uint32_t)d &&
                       L.c[1].a[3] == (uint32_t)(int32_t)words[d]);
                    CK(L.c[2].callee == 0x42639d && L.c[2].this_ptr == 0x583979 && L.c[2].nargs == 2 && L.c[2].a[0] == p2 && L.c[2].a[1] == 0x63888b);
                    CK(L.c[3].callee == 0x4c97b4 && L.c[3].this_ptr == 0x5cf659 && L.c[3].nargs == 0);
                    CK(g_w.value_63a58a == (exits ? 5u : 0x77u));
                    if (exits) CK(get32(cells, 4) == CL_SRC + off && get32(cells, 8) == cnt0);
                }
                free(cells);
                free(src);
                free(blk);
                free(srcsnap);
            }
}

static void test_m484110_clone_record(void)
{
    check_clone(m484110_clone_record, 0xf07, 0x54da20, 0x54da4c, 0x54da68, 0);
}

static void test_m487bd7_clone_record(void)
{
    check_clone(m487bd7_clone_record, 0x5b3, 0x54dd88, 0x54ddb4, 0x54ddd0, 0);
}

static void test_m48a865_clone_record(void)
{
    check_clone(m48a865_clone_record, 0x41b, 0x54e2e4, 0x54e310, 0x54e32c, 0);
}

static void test_m48d12d_clone_record(void)
{
    check_clone(m48d12d_clone_record, 0x7bb, 0x54e814, 0x54e840, 0x54e85c, 0);
}

static void test_m493b7a_clone_record(void)
{
    check_clone(m493b7a_clone_record, 0xc6, 0x54f784, 0x54f7b0, 0x54f7cc, 0);
}

static void test_m4a3a33_clone_record(void)
{
    check_clone(m4a3a33_clone_record, 0x6c1, 0x5504f0, 0x55051c, 0x550538, 0);
}

static void test_m4a64b9_clone_record(void)
{
    check_clone(m4a64b9_clone_record, 0x3d7, 0x5508f0, 0x55091c, 0x550938, 0);
}

static void test_m4a7e50_clone_record(void)
{
    check_clone(m4a7e50_clone_record, 0x44c, 0x550b2c, 0x550b58, 0x550b74, 0);
}

static void test_m4ab46d_clone_record(void)
{
    check_clone(m4ab46d_clone_record, 0xbbf, 0x550f40, 0x550f6c, 0x550f88, 0);
}

static void test_m4acbf1_clone_record(void)
{
    check_clone(m4acbf1_clone_record, 0x33a, 0x551158, 0x551184, 0x5511a0, 0);
}

static void test_m4afe09_clone_record(void)
{
    check_clone(m4afe09_clone_record, 0x37c, 0x5516e8, 0x551714, 0x551730, 0);
}

static void test_m4b3ddf_clone_record(void)
{
    check_clone(m4b3ddf_clone_record, 0x8ae, 0x5518e0, 0x55190c, 0x551928, 0);
}

static void test_m4b72cf_clone_record(void)
{
    check_clone(m4b72cf_clone_record, 0x3c6, 0x551bd8, 0x551c04, 0x551c20, 0);
}

static void test_m4b80d9_clone_record(void)
{
    check_clone(m4b80d9_clone_record, 0x56e, 0x551d34, 0x551d60, 0x551d7c, 0);
}

static void test_m4ba2bd_clone_record(void)
{
    check_clone(m4ba2bd_clone_record, 0xae2, 0x551edc, 0x551f08, 0x551f24, 0);
}

static void test_m4e9a2c_clone_record(void)
{
    check_clone(m4e9a2c_clone_record, 0x72, 0x55c7b0, 0x55c7dc, 0x55c7f8, 0);
}

static void test_m4e9add_clone_record(void)
{
    check_clone(m4e9add_clone_record, 0x2, 0x55c834, 0x55c860, 0x55c87c, 0);
}

static void test_m4e9b87_clone_record(void)
{
    check_clone(m4e9b87_clone_record, 0x4, 0x55c8b8, 0x55c8e4, 0x55c900, 0);
}

static void test_m4e9cdf_clone_record(void)
{
    check_clone(m4e9cdf_clone_record, 0x6, 0x55c9b4, 0x55c9e0, 0x55c9fc, 0);
}

static void test_m4fcda1_clone_record(void)
{
    check_clone(m4fcda1_clone_record, 0x16, 0x5609f0, 0x560a1c, 0x560a38, 1);
}

#define RUN(fn)                                                                \
    do {                                                                       \
        g_failed = 0;                                                          \
        g_msg[0] = 0;                                                          \
        fn();                                                                  \
        if (g_failed) {                                                        \
            printf("FAIL %s: %s\n", #fn, g_msg);                               \
            failures++;                                                        \
        } else {                                                               \
            printf("PASS %s\n", #fn);                                           \
        }                                                                      \
    } while (0)

int main(void)
{
    int failures = 0;
    RUN(test_m484110_clone_record);
    RUN(test_m487bd7_clone_record);
    RUN(test_m48a865_clone_record);
    RUN(test_m48d12d_clone_record);
    RUN(test_m493b7a_clone_record);
    RUN(test_m4a3a33_clone_record);
    RUN(test_m4a64b9_clone_record);
    RUN(test_m4a7e50_clone_record);
    RUN(test_m4ab46d_clone_record);
    RUN(test_m4acbf1_clone_record);
    RUN(test_m4afe09_clone_record);
    RUN(test_m4b3ddf_clone_record);
    RUN(test_m4b72cf_clone_record);
    RUN(test_m4b80d9_clone_record);
    RUN(test_m4ba2bd_clone_record);
    RUN(test_m4e9a2c_clone_record);
    RUN(test_m4e9add_clone_record);
    RUN(test_m4e9b87_clone_record);
    RUN(test_m4e9cdf_clone_record);
    RUN(test_m4fcda1_clone_record);
    return failures;
}
