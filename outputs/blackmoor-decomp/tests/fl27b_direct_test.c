/* FL-27 (batch b) direct tests of the action 0x35 (movie player) methods of GAME.EXE in src/original_methods_fl27b.c. Prints "PASS <name>" /
 * "FAIL <name>: <msg>"; the exit status is the failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the
 * disassembly of GAME.EXE, not from running the native code; tests/test_fl27b_differential.py additionally runs the original bytes on generated fixtures.
 *
 * Every function is checked three ways: (1) the guard matrix, each guard failing in turn (several fail values, widths probed), which must leave the object and the
 * call log untouched; (2) each arm with the whole object compared with a hand-edited copy, and the ordered host calls with their arguments and the state of the
 * object at the call; (3) the edges of every comparison (unsigned compares of the thread counts, word and dword widths), the native rejections, and the loops. */
#include "../src/original_methods_fl27b.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int g_failed;
static char g_msg[256];
#define CK(cond)                                                               \
    do {                                                                       \
        if (!(cond) && !g_failed) {                                            \
            g_failed = 1;                                                      \
            snprintf(g_msg, sizeof g_msg, "line %d: %.200s", __LINE__, #cond); \
        }                                                                      \
    } while (0)

#define SELF_SZ 0x300
#define OBJ_SZ 0x80
#define OBJ_VA 0x20010000u
#define VT_VA 0x20020000u
#define OBJ2_VA 0x20030000u
#define VT_STUB_A 0x7e000900u
#define VT_STUB_B 0x7e000a00u
#define SNAP 0x240

static void set32(uint8_t *o, size_t off, uint32_t v) { memcpy(o + off, &v, 4); }
static uint32_t get32(const uint8_t *o, size_t off)
{
    uint32_t v;
    memcpy(&v, o + off, 4);
    return v;
}

static struct {
    uint8_t self[SELF_SZ], obj[OBJ_SZ], obj2[OBJ_SZ], vt[0x100];
    Fl27bWorld w;
    Fl18Host host;
} fx;
static uint8_t exp_self[SELF_SZ], exp_obj[OBJ_SZ], exp_obj2[OBJ_SZ];

#define MAXCALL 64
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[12];
        uint8_t snap_self[SNAP];
        uint8_t snap_obj[OBJ_SZ];
        uint32_t w_value;      /* Fl27bWorld.value_63a58a at the call */
    } c[MAXCALL];
} L;

/* scripted behaviour: results per callee (the last one repeats) and an effect hook run after the call is logged */
static struct {
    uint32_t callee;
    uint32_t results[16];
    int nresults, used;
} S[8];
static int g_nscript;
static void (*g_effect)(int call_index, uint32_t callee, const uintptr_t *args);

static void script(uint32_t callee, int n, const uint32_t *results)
{
    int i;
    S[g_nscript].callee = callee;
    S[g_nscript].nresults = n;
    S[g_nscript].used = 0;
    for (i = 0; i < n; i++) S[g_nscript].results[i] = results[i];
    g_nscript++;
}

static uint32_t host_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int k, i = L.n;
    uint32_t result = 0;
    (void)ctx;
    if (L.n < MAXCALL) {
        L.c[i].callee = callee;
        L.c[i].this_ptr = this_ptr;
        L.c[i].nargs = nargs;
        for (k = 0; k < nargs && k < 12; k++) L.c[i].a[k] = args[k];
        memcpy(L.c[i].snap_self, fx.self, SNAP);
        memcpy(L.c[i].snap_obj, fx.obj, OBJ_SZ);
        L.c[i].w_value = fx.w.value_63a58a;
    }
    L.n++;
    for (k = 0; k < g_nscript; k++)
        if (S[k].callee == callee && S[k].nresults > 0) {
            result = S[k].results[S[k].used < S[k].nresults ? S[k].used : S[k].nresults - 1];
            S[k].used++;
        }
    if (g_effect != NULL) g_effect(i, callee, args);
    return result;
}

static const uint8_t *host_resolve(void *ctx, uint32_t a)
{
    (void)ctx;
    if (a >= OBJ_VA && a < OBJ_VA + OBJ_SZ) return fx.obj + (a - OBJ_VA);
    if (a >= OBJ2_VA && a < OBJ2_VA + OBJ_SZ) return fx.obj2 + (a - OBJ2_VA);
    if (a >= VT_VA && a < VT_VA + 0x100) return fx.vt + (a - VT_VA);
    return NULL;
}

static void setup(void)
{
    size_t b;
    memset(fx.self, 0xA5, sizeof fx.self);
    for (b = 0; b < OBJ_SZ; b++) {
        fx.obj[b] = (uint8_t)(b * 7 + 3);
        fx.obj2[b] = (uint8_t)(b * 5 + 9);
    }
    memset(fx.vt, 0x33, sizeof fx.vt);
    memset(&fx.w, 0, sizeof fx.w);
    memset(&fx.host, 0, sizeof fx.host);
    fx.host.call = host_call;
    fx.host.resolve = host_resolve;
    L.n = 0;
    g_nscript = 0;
    g_effect = NULL;
}

static void expect_begin(void)
{
    memcpy(exp_self, fx.self, sizeof exp_self);
    memcpy(exp_obj, fx.obj, sizeof exp_obj);
    memcpy(exp_obj2, fx.obj2, sizeof exp_obj2);
}

static void expect_end_at(int line)
{
    if (!g_failed && (memcmp(exp_self, fx.self, sizeof exp_self) != 0 || memcmp(exp_obj, fx.obj, sizeof exp_obj) != 0 || memcmp(exp_obj2, fx.obj2, sizeof exp_obj2) != 0)) {
        g_failed = 1;
        snprintf(g_msg, sizeof g_msg, "line %d: an object differs from the expected copy", line);
    }
}

#define expect_end() expect_end_at(__LINE__)

static void ck_call_at(int line, int n, uint32_t callee, uintptr_t this_ptr, int nargs, const uintptr_t *want)
{
    int k;
    if (g_failed) return;
    if (n >= L.n || n >= MAXCALL) {
        g_failed = 1;
        snprintf(g_msg, sizeof g_msg, "line %d: call %d missing (log has %d)", line, n, L.n);
        return;
    }
    if (L.c[n].callee != callee || L.c[n].this_ptr != this_ptr || L.c[n].nargs != nargs) {
        g_failed = 1;
        snprintf(g_msg, sizeof g_msg, "line %d: call %d is %x this %lx nargs %d, want %x this %lx nargs %d", line, n, (unsigned)L.c[n].callee,
                 (unsigned long)L.c[n].this_ptr, L.c[n].nargs, (unsigned)callee, (unsigned long)this_ptr, nargs);
        return;
    }
    for (k = 0; k < nargs; k++)
        if (L.c[n].a[k] != want[k]) {
            g_failed = 1;
            snprintf(g_msg, sizeof g_msg, "line %d: call %d arg %d is %lx, want %lx", line, n, k, (unsigned long)L.c[n].a[k], (unsigned long)want[k]);
            return;
        }
}

/* CKC(n, callee, this, args...): the n-th logged call; the argument list may be empty */
#define CKC(n, callee, thisp, ...)                                                         \
    do {                                                                                   \
        const uintptr_t w_[] = {0, __VA_ARGS__};                                           \
        ck_call_at(__LINE__, (n), (callee), (uintptr_t)(thisp), (int)(sizeof w_ / sizeof w_[0]) - 1, w_ + 1); \
    } while (0)
#define CKC0(n, callee, thisp) ck_call_at(__LINE__, (n), (callee), (uintptr_t)(thisp), 0, NULL)
#define CKN(count) CK(L.n == (count))

#define SELFP ((uintptr_t)fx.self)

static void effect_to_obj2(int i, uint32_t callee, const uintptr_t *args)
{
    (void)args;
    if (i == 0 && callee == 0x52a284) set32(fx.self, 0x36, OBJ2_VA);
}

/* ---- 0x449bff -------------------------------------------------------------------------------------------------------------------- */

static void test_m449bff_resume_thread(void)
{
    uint32_t r1[1] = {1}, r0[1] = {0}, rfail[1] = {0xffffffffu};
    uint32_t d;
    int32_t ret;
    /* guard: the object address [+0x36] clear (the dword: a non-zero upper part counts as non-zero, see below) */
    setup();
    set32(fx.self, 0x36, 0);
    expect_begin();
    CK(m449bff_resume_thread(fx.self, &fx.w, &fx.host) == 0);
    CKN(0);
    expect_end();
    /* a dword whose low word is zero is non-zero: the object is read (VA 0x20010000 itself has a zero low word) */
    setup();
    set32(fx.self, 0x36, OBJ_VA);
    set32(fx.obj, 0x28, 0x1234);
    script(0x52a284, 1, r1);
    expect_begin();
    CK(m449bff_resume_thread(fx.self, &fx.w, &fx.host) == 0);
    set32(exp_self, 0x42, 2);
    CKN(1);
    CKC(0, 0x52a284, 0, 0x1234);
    expect_end();
    /* a result of 0 and of 1 end the function without the loop; [+0x42] = 2; the debug word is off */
    for (d = 0; d < 2; d++) {
        setup();
        set32(fx.self, 0x36, OBJ_VA);
        set32(fx.obj, 0x28, 0xdeadbeefu);
        script(0x52a284, 1, d ? r1 : r0);
        expect_begin();
        CK(m449bff_resume_thread(fx.self, &fx.w, &fx.host) == 0);
        set32(exp_self, 0x42, 2);
        CKN(1);
        CKC(0, 0x52a284, 0, 0xdeadbeefu);
        expect_end();
    }
    /* the debug word is a word (movsx): 0x100, 0x8000, 0xffff, 1 are on; the upper word does not count */
    {
        static const int16_t on[] = {1, 0x100, -32768, -1};
        unsigned k;
        for (k = 0; k < sizeof on / sizeof on[0]; k++) {
            setup();
            fx.w.word_63a4cd = on[k];
            set32(fx.self, 0x36, OBJ_VA);
            set32(fx.self, 0x3a, 0xcafe0001u);
            set32(fx.obj, 0x28, 0x77);
            script(0x52a284, 1, r1);
            expect_begin();
            CK(m449bff_resume_thread(fx.self, &fx.w, &fx.host) == 0);
            set32(exp_self, 0x42, 2);
            CKN(3);
            CKC(0, 0x52a284, 0, 0x77);
            CKC(1, 0x50ca3e, 0, 0x63888b, 0x5489e4, 0xcafe0001u, SELFP + 4, 1);
            CKC(2, 0x44a2b7, 0, 0x63888b);
            expect_end();
        }
    }
    /* the failure result 0xffffffff: trace (debug on), 0x4264e8(this 0x583979, 0x548a38), 0x4c97b4(this 0x5cf659); [+0x42] is not stored */
    setup();
    fx.w.word_63a4cd = 1;
    set32(fx.self, 0x36, OBJ_VA);
    set32(fx.self, 0x3a, 0x55);
    set32(fx.obj, 0x28, 9);
    script(0x52a284, 1, rfail);
    expect_begin();
    CK(m449bff_resume_thread(fx.self, &fx.w, &fx.host) == 0);
    CKN(5);
    CKC(0, 0x52a284, 0, 9);
    CKC(1, 0x50ca3e, 0, 0x63888b, 0x5489e4, 0x55, SELFP + 4, 0xffffffffu);
    CKC(2, 0x44a2b7, 0, 0x63888b);
    CKC(3, 0x4264e8, 0x583979, 0x548a38);
    CKC0(4, 0x4c97b4, 0x5cf659);
    expect_end();
    setup();
    set32(fx.self, 0x36, OBJ_VA);
    script(0x52a284, 1, rfail);
    expect_begin();
    CK(m449bff_resume_thread(fx.self, &fx.w, &fx.host) == 0);
    CKN(3);
    CKC(1, 0x4264e8, 0x583979, 0x548a38);
    CKC0(2, 0x4c97b4, 0x5cf659);
    expect_end();
    /* the loop: results 3, 2, 1 -> three imports; the trace of each pass uses the format 0x548a54 and the new result */
    {
        uint32_t seq[3] = {3, 2, 1};
        setup();
        fx.w.word_63a4cd = 7;
        set32(fx.self, 0x36, OBJ_VA);
        set32(fx.self, 0x3a, 0x66);
        set32(fx.obj, 0x28, 0xa1);
        script(0x52a284, 3, seq);
        expect_begin();
        CK(m449bff_resume_thread(fx.self, &fx.w, &fx.host) == 0);
        set32(exp_self, 0x42, 2);
        CKN(9);
        CKC(0, 0x52a284, 0, 0xa1);
        CKC(1, 0x50ca3e, 0, 0x63888b, 0x5489e4, 0x66, SELFP + 4, 3);
        CKC(2, 0x44a2b7, 0, 0x63888b);
        CKC(3, 0x52a284, 0, 0xa1);
        CKC(4, 0x50ca3e, 0, 0x63888b, 0x548a54, 0x66, SELFP + 4, 2);
        CKC(5, 0x44a2b7, 0, 0x63888b);
        CKC(6, 0x52a284, 0, 0xa1);
        CKC(7, 0x50ca3e, 0, 0x63888b, 0x548a54, 0x66, SELFP + 4, 1);
        CKC(8, 0x44a2b7, 0, 0x63888b);
        CK(L.c[7].snap_self[0x42] == 0xA5);      /* [+0x42] is stored after the loop */
        expect_end();
    }
    /* the unsigned compare: 0x80000000 and 0xfffffffe loop, 2 loops, 1 does not */
    {
        static const uint32_t firsts[] = {0x80000000u, 0xfffffffeu, 2, 0x7fffffffu};
        unsigned k;
        for (k = 0; k < sizeof firsts / sizeof firsts[0]; k++) {
            uint32_t seq2[2];
            seq2[0] = firsts[k];
            seq2[1] = 1;
            setup();
            set32(fx.self, 0x36, OBJ_VA);
            script(0x52a284, 2, seq2);
            expect_begin();
            CK(m449bff_resume_thread(fx.self, &fx.w, &fx.host) == 0);
            set32(exp_self, 0x42, 2);
            CKN(2);
            expect_end();
        }
    }
    /* the loop reads [+0x36] again on every pass: the first import changes it to the second object, whose handle the next call uses */
    setup();
    {
        uint32_t seq[2] = {2, 0};
        set32(fx.self, 0x36, OBJ_VA);
        set32(fx.obj, 0x28, 0x11);
        set32(fx.obj2, 0x28, 0x22);
        script(0x52a284, 2, seq);
        g_effect = effect_to_obj2;
        expect_begin();
        CK(m449bff_resume_thread(fx.self, &fx.w, &fx.host) == 0);
        set32(exp_self, 0x36, OBJ2_VA);
        set32(exp_self, 0x42, 2);
        CKN(2);
        CKC(0, 0x52a284, 0, 0x11);
        CKC(1, 0x52a284, 0, 0x22);
        expect_end();
    }
    /* native rejection: a second 0xffffffff (the original would loop for ever): 1 is returned, [+0x42] untouched */
    setup();
    {
        uint32_t seq[2] = {2, 0xffffffffu};
        set32(fx.self, 0x36, OBJ_VA);
        script(0x52a284, 2, seq);
        expect_begin();
        ret = m449bff_resume_thread(fx.self, &fx.w, &fx.host);
        CK(ret == 1);
        CKN(2);
        expect_end();
    }
}

/* ---- 0x449a94 -------------------------------------------------------------------------------------------------------------------- */

static uint32_t g_codes[8];
static int g_ncodes, g_codeidx;

/* the import 0x52a280 stores the next scripted code through its second argument (the local dword of the function) */
static void effect_codes(int i, uint32_t callee, const uintptr_t *args)
{
    (void)i;
    if (callee == 0x52a280 && g_ncodes > 0) {
        uint32_t v = g_codes[g_codeidx < g_ncodes ? g_codeidx : g_ncodes - 1];
        memcpy((void *)args[1], &v, 4);
        g_codeidx++;
    }
}

static void effect_clear_on_poll(int i, uint32_t callee, const uintptr_t *args)
{
    (void)i;
    (void)args;
    if (callee == 0x52a280) set32(fx.self, 0x36, 0);
}

static void effect_clear_on_second_sleep(int i, uint32_t callee, const uintptr_t *args)
{
    (void)args;
    if (callee == 0x52a2b0 && i == 1) set32(fx.self, 0x36, 0);
}

static void setup_stop(uint32_t state42)
{
    setup();
    set32(fx.self, 0x36, OBJ_VA);
    set32(fx.self, 0x42, state42);
    set32(fx.self, 0x3a, 0x4242);
    set32(fx.obj, 0, VT_VA);
    set32(fx.obj, 0x28, 0xbeef);
    set32(fx.obj, 0x24, 0x99);
    set32(fx.vt, 0x78, VT_STUB_B);
    g_ncodes = 0;
    g_codeidx = 0;
}

static void finish_stop(void)
{
    set32(exp_self, 0x3e, 1);
    set32(exp_self, 0x36, 0);
    set32(exp_self, 0x42, 3);
    set32(exp_obj, 0x24, 1);
}

static void test_m449a94_stop_thread(void)
{
    uint32_t r1[1] = {1};
    int32_t ret;
    /* guard: [+0x36] clear: nothing at all, also with [+0x42] == 1 */
    setup_stop(1);
    set32(fx.self, 0x36, 0);
    expect_begin();
    CK(m449a94_stop_thread(fx.self, &fx.w, &fx.host) == 0);
    CKN(0);
    expect_end();
    /* [+0x42] == 1: 0x449bff(this self) and a Sleep(0) first; [+0x3e] = 1 is stored before the second Sleep; code starts at 0, so a result of 1 leaves the loop */
    setup_stop(1);
    script(0x52a280, 1, r1);
    expect_begin();
    CK(m449a94_stop_thread(fx.self, &fx.w, &fx.host) == 0);
    finish_stop();
    CKN(5);
    CKC0(0, 0x449bff, SELFP);
    CKC(1, 0x52a2b0, 0, 0);
    CKC(2, 0x52a2b0, 0, 0);
    CKC(3, 0x52a280, 0, 0xbeef, L.c[3].a[1]);
    CK(L.c[3].a[1] != 0);
    CKC0(4, VT_STUB_B, OBJ_VA);
    CK(L.c[1].snap_self[0x3e] == 0xA5 && L.c[2].snap_self[0x3e] == 1);
    CK(L.c[4].snap_obj[0x24] == 1);          /* [object + 0x24] = 1 comes before the virtual call */
    CK(get32(L.c[4].snap_self, 0x36) == OBJ_VA && get32(L.c[4].snap_self, 0x42) == 1);
    expect_end();
    /* [+0x42] is compared as a dword with 1: other values, also 0x101 and 0xffffffff, skip the first part */
    {
        static const uint32_t others[] = {0, 2, 3, 0x101, 0x10001, 0xffffffffu, 0x80000001u};
        unsigned k;
        for (k = 0; k < sizeof others / sizeof others[0]; k++) {
            setup_stop(others[k]);
            script(0x52a280, 1, r1);
            expect_begin();
            CK(m449a94_stop_thread(fx.self, &fx.w, &fx.host) == 0);
            finish_stop();
            CKN(3);
            CKC(0, 0x52a2b0, 0, 0);
            CKC(1, 0x52a280, 0, 0xbeef, L.c[1].a[1]);
            CKC0(2, VT_STUB_B, OBJ_VA);
            expect_end();
        }
    }
    /* poll results: 0 with the debug word on: 0x426367(this 0x583979) -> 0x1234 passed to 0x44a2b7; then Sleep; the next result 1 with code 0 ends it */
    {
        uint32_t seq[2] = {0, 1};
        uint32_t t[1] = {0x1234};
        setup_stop(0);
        fx.w.word_63a4cd = 0x100;
        script(0x52a280, 2, seq);
        script(0x426367, 1, t);
        expect_begin();
        CK(m449a94_stop_thread(fx.self, &fx.w, &fx.host) == 0);
        finish_stop();
        CKN(9);
        CKC(0, 0x52a2b0, 0, 0);
        CKC(1, 0x52a280, 0, 0xbeef, L.c[1].a[1]);
        CKC0(2, 0x426367, 0x583979);
        CKC(3, 0x44a2b7, 0, 0x1234);
        CKC(4, 0x52a2b0, 0, 0);
        CKC(5, 0x52a280, 0, 0xbeef, L.c[5].a[1]);
        CKC0(6, VT_STUB_B, OBJ_VA);
        CKC(7, 0x50ca3e, 0, L.c[7].a[0], 0x5489a0, 0x4242, SELFP + 4);
        CKC(8, 0x44a2b7, 0, L.c[7].a[0]);
        CK(L.c[7].a[0] != 0 && L.c[1].a[1] == L.c[5].a[1]);      /* the buffer and the code are locals of the function */
        expect_end();
        /* debug off: the zero result only sleeps */
        setup_stop(0);
        script(0x52a280, 2, seq);
        expect_begin();
        CK(m449a94_stop_thread(fx.self, &fx.w, &fx.host) == 0);
        finish_stop();
        CKN(5);
        CKC(2, 0x52a2b0, 0, 0);
        CKC(3, 0x52a280, 0, 0xbeef, L.c[3].a[1]);
        CKC0(4, VT_STUB_B, OBJ_VA);
        expect_end();
    }
    /* a non-zero result with a non-zero code (259, 0x100: the dword is tested, not its low byte) keeps polling after a Sleep; the results 0x100 / 0x80000000 count as non-zero */
    {
        uint32_t seq[3] = {1, 0x100, 0x80000000u};
        setup_stop(0);
        g_codes[0] = 259;
        g_codes[1] = 0x100;
        g_codes[2] = 0;
        g_ncodes = 3;
        script(0x52a280, 3, seq);
        g_effect = effect_codes;
        expect_begin();
        CK(m449a94_stop_thread(fx.self, &fx.w, &fx.host) == 0);
        finish_stop();
        CKN(7);
        CKC(0, 0x52a2b0, 0, 0);
        CKC(1, 0x52a280, 0, 0xbeef, L.c[1].a[1]);
        CKC(2, 0x52a2b0, 0, 0);
        CKC(3, 0x52a280, 0, 0xbeef, L.c[3].a[1]);
        CKC(4, 0x52a2b0, 0, 0);
        CKC(5, 0x52a280, 0, 0xbeef, L.c[5].a[1]);
        CKC0(6, VT_STUB_B, OBJ_VA);
        expect_end();
    }
    /* a result of 0 never looks at the code (here 0): it sleeps and polls again */
    {
        uint32_t seq[2] = {0, 1};
        setup_stop(0);
        g_codes[0] = 0;
        g_ncodes = 1;
        script(0x52a280, 2, seq);
        g_effect = effect_codes;
        expect_begin();
        CK(m449a94_stop_thread(fx.self, &fx.w, &fx.host) == 0);
        finish_stop();
        CKN(5);
        expect_end();
    }
    /* native rejection: a callee cleared [+0x36] while the code was 0 (the original stores through the null object at 0x24): 1, nothing more stored, no virtual call */
    setup_stop(0);
    script(0x52a280, 1, r1);
    g_effect = effect_clear_on_poll;
    expect_begin();
    ret = m449a94_stop_thread(fx.self, &fx.w, &fx.host);
    CK(ret == 1);
    set32(exp_self, 0x3e, 1);
    set32(exp_self, 0x36, 0);
    CKN(2);
    expect_end();
    /* the same through the loop head: the second Sleep clears [+0x36] */
    setup_stop(1);
    script(0x52a280, 1, r1);
    g_effect = effect_clear_on_second_sleep;
    expect_begin();
    ret = m449a94_stop_thread(fx.self, &fx.w, &fx.host);
    CK(ret == 1);
    set32(exp_self, 0x3e, 1);
    set32(exp_self, 0x36, 0);
    CKN(3);
    expect_end();
}

/* ---- 0x4bf773 -------------------------------------------------------------------------------------------------------------------- */

static uint32_t g_effect_value;

static void effect_449a94_to(int i, uint32_t callee, const uintptr_t *args)
{
    (void)i;
    (void)args;
    if (callee == 0x449a94) set32(fx.self, 0x1d6, g_effect_value);
}

static void setup_release(void)
{
    setup();
    set32(fx.self, 0x1d6, OBJ_VA);
    set32(fx.self, 0x222, 0);
    set32(fx.obj, 0, VT_VA);
    set32(fx.obj2, 0, VT_VA + 0x10);
    set32(fx.vt, 0, VT_STUB_A);
    set32(fx.vt, 0x10, VT_STUB_B);
}

static void test_m4bf773_release_player(void)
{
    /* the player object present, debug off, [+0x222] clear */
    setup_release();
    expect_begin();
    m4bf773_release_player(fx.self, &fx.w, &fx.host);
    set32(exp_self, 0x1d6, 0);
    set32(exp_self, 4, 0);
    CKN(7);
    CKC(0, 0x44c479, 0, SELFP + 4);
    CKC0(1, 0x449a94, OBJ_VA);
    CKC(2, VT_STUB_A, OBJ_VA, 1);
    CKC(3, 0x44c4ab, 0, SELFP + 4);
    CKC(4, 0x415011, 0x5e2dbe, SELFP + 8);
    CKC(5, 0x41632b, 0x5e2dbe, SELFP + 8);
    CKC(6, 0x4bedfa, 0x6201f9, SELFP + 0x18e);
    CK(get32(L.c[0].snap_self, 4) == 0xA5A5A5A5u);
    CK(get32(L.c[1].snap_self, 4) == 2 && get32(L.c[1].snap_self, 0x1d6) == OBJ_VA);
    CK(get32(L.c[2].snap_self, 4) == 2 && get32(L.c[2].snap_self, 0x1d6) == OBJ_VA);
    CK(get32(L.c[3].snap_self, 4) == 2 && get32(L.c[3].snap_self, 0x1d6) == 0);
    CK(get32(L.c[4].snap_self, 4) == 0);
    expect_end();
    /* [+0x222] is a dword: any non-zero value (0x100, 0x10000, 0x01000000, 0xffffffff) calls 0x4c2dfb(this 0x5cf659, self + 0x222) before 0x41632b */
    {
        static const uint32_t g222[] = {1, 0x100, 0x10000, 0x01000000, 0xffffffffu};
        unsigned k;
        for (k = 0; k < sizeof g222 / sizeof g222[0]; k++) {
            setup_release();
            set32(fx.self, 0x222, g222[k]);
            expect_begin();
            m4bf773_release_player(fx.self, &fx.w, &fx.host);
            set32(exp_self, 0x1d6, 0);
            set32(exp_self, 4, 0);
            CKN(8);
            CKC(4, 0x415011, 0x5e2dbe, SELFP + 8);
            CKC(5, 0x4c2dfb, 0x5cf659, SELFP + 0x222);
            CKC(6, 0x41632b, 0x5e2dbe, SELFP + 8);
            expect_end();
        }
    }
    /* debug on: the traces 0x5525dc / 0x552620 / 0x552664 around the calls, in order (0x4c2dfb present) */
    setup_release();
    fx.w.word_63a4cd = -32768;
    set32(fx.self, 0x222, 5);
    expect_begin();
    m4bf773_release_player(fx.self, &fx.w, &fx.host);
    set32(exp_self, 0x1d6, 0);
    set32(exp_self, 4, 0);
    CKN(11);
    CKC(3, 0x44c4ab, 0, SELFP + 4);
    CKC(4, 0x44a2b7, 0, 0x5525dc);
    CKC(5, 0x415011, 0x5e2dbe, SELFP + 8);
    CKC(6, 0x44a2b7, 0, 0x552620);
    CKC(7, 0x4c2dfb, 0x5cf659, SELFP + 0x222);
    CKC(8, 0x44a2b7, 0, 0x552664);
    CKC(9, 0x41632b, 0x5e2dbe, SELFP + 8);
    CKC(10, 0x4bedfa, 0x6201f9, SELFP + 0x18e);
    expect_end();
    /* the object address clear: the block is skipped (only the tail), [+4] untouched */
    setup_release();
    set32(fx.self, 0x1d6, 0);
    set32(fx.self, 4, 0x77);
    fx.w.word_63a4cd = 1;
    expect_begin();
    m4bf773_release_player(fx.self, &fx.w, &fx.host);
    CKN(6);
    CKC(0, 0x44a2b7, 0, 0x5525dc);
    CKC(1, 0x415011, 0x5e2dbe, SELFP + 8);
    CKC(2, 0x44a2b7, 0, 0x552620);
    CKC(3, 0x44a2b7, 0, 0x552664);
    CKC(4, 0x41632b, 0x5e2dbe, SELFP + 8);
    CKC(5, 0x4bedfa, 0x6201f9, SELFP + 0x18e);
    expect_end();
    /* 0x449a94 clears [+0x1d6]: the object address is read again, no virtual call */
    setup_release();
    g_effect_value = 0;
    g_effect = effect_449a94_to;
    expect_begin();
    m4bf773_release_player(fx.self, &fx.w, &fx.host);
    set32(exp_self, 0x1d6, 0);
    set32(exp_self, 4, 0);
    CKN(6);
    CKC0(1, 0x449a94, OBJ_VA);
    CKC(2, 0x44c4ab, 0, SELFP + 4);
    expect_end();
    /* 0x449a94 replaces [+0x1d6] by the second object: the virtual call uses its vtable (the entry at +0x10 of the vtable region) and its address as ecx */
    setup_release();
    g_effect_value = OBJ2_VA;
    g_effect = effect_449a94_to;
    expect_begin();
    m4bf773_release_player(fx.self, &fx.w, &fx.host);
    set32(exp_self, 0x1d6, 0);
    set32(exp_self, 4, 0);
    CKN(7);
    CKC(2, VT_STUB_B, OBJ2_VA, 1);
    expect_end();
}

/* ---- 0x4161d1 -------------------------------------------------------------------------------------------------------------------- */

static void setup_alloc(uint32_t kind)
{
    setup();
    set32(fx.self, 0x172, kind);
    set32(fx.self, 0x1c8, 0x1000);
    fx.w.value_63a58a = 7;
}

static void finish_alloc(void)
{
    exp_self[0x182] = exp_self[0x183] = exp_self[0x184] = exp_self[0x185] = 0;
}

static void test_m4161d1_alloc_buffers(void)
{
    uint32_t ok[1] = {0x55}, nul[1] = {0};
    /* kind 0, allocation succeeds: one call with the size [arg+0x1c8], [arg+0x17a] = the result, the two words cleared (the bytes around them are not) */
    setup_alloc(0);
    set32(fx.self, 0x1c8, 0x1234);
    script(0x51dc43, 1, ok);
    expect_begin();
    m4161d1_alloc_buffers(fx.self, &fx.w, &fx.host);
    set32(exp_self, 0x17a, 0x55);
    finish_alloc();
    CKN(1);
    CKC(0, 0x51dc43, 0, 0x1234);
    CK(fx.w.value_63a58a == 7);
    expect_end();
    /* kind 0, allocation fails: [arg+0x17a] = 0 is stored before the failure path; the path: 0x50ca3e(0x63888b, 0x541e7c), 0x52139c(0x63888b, 0, 0), [0x63a58a] = 4, 0x4c97b4 */
    setup_alloc(0);
    script(0x51dc43, 1, nul);
    expect_begin();
    m4161d1_alloc_buffers(fx.self, &fx.w, &fx.host);
    set32(exp_self, 0x17a, 0);
    finish_alloc();
    CKN(4);
    CKC(0, 0x51dc43, 0, 0x1000);
    CKC(1, 0x50ca3e, 0, 0x63888b, 0x541e7c);
    CKC(2, 0x52139c, 0, 0x63888b, 0, 0);
    CKC0(3, 0x4c97b4, 0x5cf659);
    CK(get32(L.c[1].snap_self, 0x17a) == 0 && L.c[1].w_value == 7 && L.c[2].w_value == 7 && L.c[3].w_value == 4);
    CK(fx.w.value_63a58a == 4);
    expect_end();
    /* kind 1: both succeed / the first fails / the second fails / both fail, in the order of the original (the second allocation is attempted after a failed first one) */
    {
        uint32_t seq_ok[2] = {0x31, 0x32}, seq_f1[2] = {0, 0x32}, seq_f2[2] = {0x31, 0}, seq_f12[2] = {0, 0};
        setup_alloc(1);
        script(0x51dc43, 2, seq_ok);
        expect_begin();
        m4161d1_alloc_buffers(fx.self, &fx.w, &fx.host);
        set32(exp_self, 0x17a, 0x31);
        set32(exp_self, 0x17e, 0x32);
        finish_alloc();
        CKN(2);
        CKC(0, 0x51dc43, 0, 0x1000);
        CKC(1, 0x51dc43, 0, 0x1000);
        CK(get32(L.c[1].snap_self, 0x17a) == 0x31);
        expect_end();
        setup_alloc(1);
        script(0x51dc43, 2, seq_f1);
        expect_begin();
        m4161d1_alloc_buffers(fx.self, &fx.w, &fx.host);
        set32(exp_self, 0x17a, 0);
        set32(exp_self, 0x17e, 0x32);
        finish_alloc();
        CKN(5);
        CKC(1, 0x50ca3e, 0, 0x63888b, 0x541ed4);
        CKC(2, 0x52139c, 0, 0x63888b, 0, 0);
        CKC0(3, 0x4c97b4, 0x5cf659);
        CKC(4, 0x51dc43, 0, 0x1000);
        expect_end();
        setup_alloc(1);
        script(0x51dc43, 2, seq_f2);
        expect_begin();
        m4161d1_alloc_buffers(fx.self, &fx.w, &fx.host);
        set32(exp_self, 0x17a, 0x31);
        set32(exp_self, 0x17e, 0);
        finish_alloc();
        CKN(5);
        CKC(2, 0x50ca3e, 0, 0x63888b, 0x541f2c);
        CKC(3, 0x52139c, 0, 0x63888b, 0, 0);
        CKC0(4, 0x4c97b4, 0x5cf659);
        expect_end();
        setup_alloc(1);
        script(0x51dc43, 2, seq_f12);
        expect_begin();
        m4161d1_alloc_buffers(fx.self, &fx.w, &fx.host);
        set32(exp_self, 0x17a, 0);
        set32(exp_self, 0x17e, 0);
        finish_alloc();
        CKN(8);
        CKC(1, 0x50ca3e, 0, 0x63888b, 0x541ed4);
        CKC0(3, 0x4c97b4, 0x5cf659);
        CKC(4, 0x51dc43, 0, 0x1000);
        CKC(5, 0x50ca3e, 0, 0x63888b, 0x541f2c);
        CKC0(7, 0x4c97b4, 0x5cf659);
        expect_end();
    }
    /* any other kind (the compare is on the whole dword): only the words are cleared, nothing is called */
    {
        static const uint32_t others[] = {2, 3, 0x100, 0x10000, 0x01000000, 0x80000000u, 0xffffffffu, 0x101};
        unsigned k;
        for (k = 0; k < sizeof others / sizeof others[0]; k++) {
            setup_alloc(others[k]);
            expect_begin();
            m4161d1_alloc_buffers(fx.self, &fx.w, &fx.host);
            finish_alloc();
            CKN(0);
            expect_end();
        }
    }
}

/* ---- sweep (for the sanitiser builds) -------------------------------------------------------------------------------------------- */

static uint32_t g_rng = 12345;
static uint32_t rnd(void)
{
    g_rng = g_rng * 1664525u + 1013904223u;
    return g_rng >> 8;
}

static void test_sweep_bounded(void)
{
    int it;
    for (it = 0; it < 3000; it++) {
        uint32_t seq[4];
        int k;
        setup();
        for (k = 0; k < SELF_SZ; k++) fx.self[k] = (uint8_t)rnd();
        for (k = 0; k < OBJ_SZ; k++) {
            fx.obj[k] = (uint8_t)rnd();
            fx.obj2[k] = (uint8_t)rnd();
        }
        set32(fx.obj, 0, VT_VA);
        set32(fx.obj2, 0, VT_VA);
        set32(fx.vt, 0, VT_STUB_A);
        set32(fx.vt, 0x78, VT_STUB_B);
        set32(fx.self, 0x36, (rnd() & 3) ? OBJ_VA : 0);
        set32(fx.self, 0x1d6, (rnd() & 3) ? OBJ_VA : 0);
        fx.w.word_63a4cd = (int16_t)((rnd() & 1) ? rnd() : 0);
        seq[0] = rnd() & 7;
        seq[1] = rnd() & 7;
        seq[2] = rnd() & 1;
        seq[3] = 1;
        script(0x52a284, 4, seq);
        script(0x52a280, 4, seq);
        (void)m449bff_resume_thread(fx.self, &fx.w, &fx.host);
        L.n = 0;
        g_nscript = 0;
        seq[0] = rnd() & 1;
        script(0x52a280, 4, seq);
        if (get32(fx.self, 0x36) != 0) (void)m449a94_stop_thread(fx.self, &fx.w, &fx.host);
        L.n = 0;
        m4bf773_release_player(fx.self, &fx.w, &fx.host);
        L.n = 0;
        g_nscript = 0;
        seq[0] = rnd() & 1;
        seq[1] = rnd() & 1;
        script(0x51dc43, 2, seq);
        set32(fx.self, 0x172, rnd() & 3);
        m4161d1_alloc_buffers(fx.self, &fx.w, &fx.host);
    }
}

#define RUN(fn)                                  \
    do {                                         \
        g_failed = 0;                            \
        g_msg[0] = 0;                            \
        fn();                                    \
        if (g_failed) {                          \
            printf("FAIL %s: %s\n", #fn, g_msg); \
            failures++;                          \
        } else {                                 \
            printf("PASS %s\n", #fn);            \
        }                                        \
    } while (0)

int main(void)
{
    int failures = 0;
    RUN(test_m449bff_resume_thread);
    RUN(test_m449a94_stop_thread);
    RUN(test_m4bf773_release_player);
    RUN(test_m4161d1_alloc_buffers);
    /* TESTS-END */
    RUN(test_sweep_bounded);
    return failures;
}
