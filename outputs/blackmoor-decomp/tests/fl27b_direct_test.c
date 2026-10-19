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
#define NAME_VA 0x20040000u
#define SF_VA 0x20050000u
#define PX_VA 0x20060000u
#define DT_VA 0x20070000u
#define RC_VA 0x20080000u
#define OBJ2_VA 0x20030000u
#define VT_STUB_A 0x7e000900u
#define VT_STUB_B 0x7e000a00u
#define SNAP 0x260

static void set32(uint8_t *o, size_t off, uint32_t v) { memcpy(o + off, &v, 4); }
static uint32_t get32(const uint8_t *o, size_t off)
{
    uint32_t v;
    memcpy(&v, o + off, 4);
    return v;
}

static struct {
    uint8_t self[SELF_SZ], obj[OBJ_SZ], obj2[OBJ_SZ], vt[0x100], name[0x100], player[0x220], rectd[0x20], rec[6 * 0x8d], sf[0x40], px[0x100], dt[0x100], rc[0x20];
    Fl27bWorld w;
    Fl18Host host;
} fx;
static uint8_t exp_self[SELF_SZ], exp_obj[OBJ_SZ], exp_obj2[OBJ_SZ], exp_name[0x100], exp_player[0x220], exp_rectd[0x20], exp_rec[6 * 0x8d], exp_sf[0x40], exp_px[0x100], exp_dt[0x100], exp_rc[0x20];

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
        uint8_t snap_player[0x220];
        uint8_t snap_rec[6 * 0x8d];
        int has_loc;           /* a call with two host pointers (locals): their 16 bytes at the call */
        int32_t out[4], isect[4];
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
        memcpy(L.c[i].snap_player, fx.player, sizeof fx.player);
        memcpy(L.c[i].snap_rec, fx.rec, sizeof fx.rec);
        L.c[i].has_loc = 0;
        if (callee == 0x4c5377 && nargs == 5 && args[2] > 0xffffffffu && args[3] > 0xffffffffu) {
            memcpy(L.c[i].out, (const void *)args[2], 16);
            memcpy(L.c[i].isect, (const void *)args[3], 16);
            L.c[i].has_loc = 1;
        }
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
    if (a >= NAME_VA && a < NAME_VA + 0x100) return fx.name + (a - NAME_VA);
    if (a >= SF_VA && a < SF_VA + 0x40) return fx.sf + (a - SF_VA);
    if (a >= PX_VA && a < PX_VA + 0x100) return fx.px + (a - PX_VA);
    if (a >= DT_VA && a < DT_VA + 0x100) return fx.dt + (a - DT_VA);
    if (a >= RC_VA && a < RC_VA + 0x20) return fx.rc + (a - RC_VA);
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
    memset(fx.name, 0x44, sizeof fx.name);
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
    memcpy(exp_name, fx.name, sizeof exp_name);
}

static void expect_end_at(int line)
{
    if (!g_failed && (memcmp(exp_self, fx.self, sizeof exp_self) != 0 || memcmp(exp_obj, fx.obj, sizeof exp_obj) != 0 || memcmp(exp_obj2, fx.obj2, sizeof exp_obj2) != 0 || memcmp(exp_name, fx.name, sizeof exp_name) != 0)) {
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

/* ---- 0x4c2c3a -------------------------------------------------------------------------------------------------------------------- */

static void set16(uint8_t *o, size_t off, uint16_t v) { memcpy(o + off, &v, 2); }

static void setup_make(const char *name)
{
    setup();
    memset(fx.name, 0, sizeof fx.name);
    memcpy(fx.name, name, strlen(name) + 1);
    memset(fx.name + strlen(name) + 1, 0x7e, 8);
    fx.w.word_639895 = 3;
    fx.w.word_639893 = 0x77;
}

/* the record bytes of the success path, as hand-derived from the stores of the disassembly: size = a * w895 * b */
static void expect_record(uint32_t size, int16_t a, int16_t b, int32_t w895, uint32_t v10, uint32_t flags, uint32_t buffer, const char *name)
{
    size_t n = strlen(name);
    memset(exp_obj, 0, 0x59);
    set32(exp_obj, 0, buffer);
    set32(exp_obj, 4, v10);
    memcpy(exp_obj + 8, name, n + 1);
    set16(exp_obj, 0x21, 0x59);
    set32(exp_obj, 0x23, size);
    set32(exp_obj, 0x27, size + 0x59);
    set16(exp_obj, 0x2b, (uint16_t)a);
    set16(exp_obj, 0x2d, (uint16_t)b);
    set16(exp_obj, 0x2f, (uint16_t)((int32_t)a * w895));
    set16(exp_obj, 0x31, (uint16_t)b);
    set16(exp_obj, 0x33, 0x77);
    set32(exp_obj, 0x3d, (uint32_t)((int32_t)a - 1));
    set32(exp_obj, 0x41, (uint32_t)((int32_t)b - 1));
    set32(exp_obj, 0x55, flags);
}

static void test_m4c2c3a_make_record(void)
{
    uint32_t none[1] = {0}, two[2] = {OBJ_VA, 0x2222}, one[1] = {OBJ_VA}, nobuf[2] = {OBJ_VA, 0};
    uint32_t r;
    /* the first allocation fails: the error call with the name, then 0x4c97b4(this self); 0 is returned and nothing else is touched */
    setup_make("movie");
    script(0x51dc43, 1, none);
    expect_begin();
    r = m4c2c3a_make_record(fx.self, 16, 32, 0xabcd, 3, NAME_VA, &fx.w, &fx.host);
    CK(r == 0);
    CKN(3);
    CKC(0, 0x51dc43, 0, 0x59);
    CKC(1, 0x42639d, 0x583979, 0x553e68, NAME_VA);
    CKC0(2, 0x4c97b4, SELFP);
    expect_end();
    /* success with bit 0 of the flags set: one allocation, [rec] = 0, no second allocation; the record is zeroed, then filled */
    setup_make("abc");
    script(0x51dc43, 1, one);
    expect_begin();
    r = m4c2c3a_make_record(fx.self, 16, 32, 0xabcd, 3, NAME_VA, &fx.w, &fx.host);
    CK(r == OBJ_VA);
    expect_record(16 * 3 * 32, 16, 32, 3, 0xabcd, 3, 0, "abc");
    CKN(1);
    CKC(0, 0x51dc43, 0, 0x59);
    expect_end();
    /* bit 0 clear: the second allocation of `size` bytes comes after the zeroing, its result is stored at [rec] */
    {
        static const uint32_t clear_flags[] = {0, 2, 0x100, 0xfffffffeu, 0x10000};
        unsigned k;
        for (k = 0; k < sizeof clear_flags / sizeof clear_flags[0]; k++) {
            setup_make("abc");
            script(0x51dc43, 2, two);
            expect_begin();
            r = m4c2c3a_make_record(fx.self, 16, 32, 0xabcd, clear_flags[k], NAME_VA, &fx.w, &fx.host);
            CK(r == OBJ_VA);
            expect_record(0x600, 16, 32, 3, 0xabcd, clear_flags[k], 0x2222, "abc");
            CKN(2);
            CKC(1, 0x51dc43, 0, 0x600);
            CK(L.c[1].snap_obj[0x30] == 0 && L.c[1].snap_obj[0] == 0 && L.c[1].snap_obj[0x58] == 0);     /* zeroed before the second allocation */
            expect_end();
        }
    }
    /* the flags test is on bit 0 only: every odd value skips the second allocation */
    {
        static const uint32_t odd[] = {1, 3, 0x101, 0x80000001u, 0xffffffffu};
        unsigned k;
        for (k = 0; k < sizeof odd / sizeof odd[0]; k++) {
            setup_make("abc");
            script(0x51dc43, 1, one);
            expect_begin();
            r = m4c2c3a_make_record(fx.self, 1, 1, 5, odd[k], NAME_VA, &fx.w, &fx.host);
            CK(r == OBJ_VA);
            expect_record(3, 1, 1, 3, 5, odd[k], 0, "abc");
            CKN(1);
            expect_end();
        }
    }
    /* the second allocation fails: [rec] = 0 stored, the record zeroed and nothing else filled; error call with 0x553ec0, 0x4c97b4; returns 0 */
    setup_make("abc");
    script(0x51dc43, 2, nobuf);
    expect_begin();
    r = m4c2c3a_make_record(fx.self, 16, 32, 0xabcd, 0, NAME_VA, &fx.w, &fx.host);
    CK(r == 0);
    memset(exp_obj, 0, 0x59);
    CKN(4);
    CKC(1, 0x51dc43, 0, 0x600);
    CKC(2, 0x42639d, 0x583979, 0x553ec0, NAME_VA);
    CKC0(3, 0x4c97b4, SELFP);
    expect_end();
    /* the name: up to 0x18 characters are copied whole; 0x19 or more are cut at 0x18 in the caller's string (and the copy has 0x19 bytes) */
    {
        static const char *names[] = {"", "a", "123456789012345678901234", "1234567890123456789012345", "12345678901234567890123456", "1234567890123456789012345678901234567890123456789012345678901234"};
        unsigned k;
        for (k = 0; k < sizeof names / sizeof names[0]; k++) {
            char cut[0x20];
            size_t n = strlen(names[k]);
            setup_make(names[k]);
            script(0x51dc43, 1, one);
            expect_begin();
            r = m4c2c3a_make_record(fx.self, 2, 2, 0, 1, NAME_VA, &fx.w, &fx.host);
            CK(r == OBJ_VA);
            memcpy(cut, names[k], n < 0x18 ? n + 1 : 0x18);
            cut[n < 0x18 ? n + 1 : 0x18] = 0;
            if (n >= 0x19) exp_name[0x18] = 0;
            expect_record(12, 2, 2, 3, 0, 1, 0, n >= 0x19 ? cut : names[k]);
            expect_end();
        }
    }
    /* signed and wrapping arithmetic: a = b = -1, w = 3 and w = -32768; a = b = w = 0x7fff wraps in 32 bits; a = 0 */
    setup_make("abc");
    script(0x51dc43, 1, one);
    fx.w.word_639895 = -32768;
    expect_begin();
    r = m4c2c3a_make_record(fx.self, -1, -1, 1, 1, NAME_VA, &fx.w, &fx.host);
    CK(r == OBJ_VA);
    expect_record(0xffff8000u, -1, -1, -32768, 1, 1, 0, "abc");
    CK(get32(fx.obj, 0x3d) == 0xfffffffeu && get32(fx.obj, 0x23) == 0xffff8000u && get32(fx.obj, 0x27) == 0xffff8059u);
    expect_end();
    setup_make("abc");
    script(0x51dc43, 1, one);
    fx.w.word_639895 = 0x7fff;
    expect_begin();
    r = m4c2c3a_make_record(fx.self, 0x7fff, 0x7fff, 1, 1, NAME_VA, &fx.w, &fx.host);
    CK(r == OBJ_VA);
    expect_record(0x40017fffu, 0x7fff, 0x7fff, 0x7fff, 1, 1, 0, "abc");
    CK(get32(fx.obj, 0x23) == 0x40017fffu && get32(fx.obj, 0x27) == 0x40018058u && (uint16_t)get32(fx.obj, 0x2f) == 0x7fff * 0x7fff % 0x10000);
    expect_end();
}

/* ---- 0x4c0d3f -------------------------------------------------------------------------------------------------------------------- */

#define PLAYER_SZ 0x220

static void setup_rect(void)
{
    size_t b;
    setup();
    for (b = 0; b < PLAYER_SZ; b++) fx.player[b] = (uint8_t)(b * 3 + 1);
    memset(fx.rectd, 0x66, sizeof fx.rectd);
    fx.w.player_637fd7 = fx.player;
    fx.w.rect_583122 = fx.rectd;
    fx.w.value_5d19ef = 0x1111;
    fx.w.value_5cf665 = 0x2222;
    fx.w.value_5d19f3 = 0x3333;
    fx.w.value_5d19f7 = 0x4444;
    set32(fx.player, 0x20e, 0);
    set32(fx.player, 0x212, 1);
    set32(fx.player, 0x216, 0);
    set32(fx.player, 0x176, 1);
    set32(fx.player, 0x172, 0);
}

static void set_rects(const int32_t *c, const int32_t *d, int32_t bx, int32_t by)
{
    int i;
    for (i = 0; i < 4; i++) {
        set32(fx.player, 0x1e6 + 4 * (size_t)i, (uint32_t)c[i]);
        set32(fx.rectd, 4 * (size_t)i, (uint32_t)d[i]);
    }
    set32(fx.player, 0x1d6, (uint32_t)bx);
    set32(fx.player, 0x1d6 + 4, (uint32_t)by);
}

static void expect_player_begin(void)
{
    expect_begin();
    memcpy(exp_player, fx.player, sizeof exp_player);
    memcpy(exp_rectd, fx.rectd, sizeof exp_rectd);
}

static void expect_player_end_at(int line)
{
    if (!g_failed && (memcmp(exp_player, fx.player, sizeof exp_player) != 0 || memcmp(exp_rectd, fx.rectd, sizeof exp_rectd) != 0)) {
        g_failed = 1;
        snprintf(g_msg, sizeof g_msg, "line %d: the player object or the rectangle differs from the expected copy", line);
    }
}

#define expect_player_end() expect_player_end_at(__LINE__)

static void effect_set_216(int i, uint32_t callee, const uintptr_t *args)
{
    (void)i;
    (void)args;
    if (callee == 0x4c5377) set32(fx.player, 0x216, 7);
}

/* runs the function on the current setup and checks that a rectangle call with these four out values and these four intersection values was made (or none) */
static void ck_rect_call(const int32_t *out, const int32_t *isect)
{
    CKN(1);
    CKC(0, 0x4c5377, 0x5cf659, 0x1111, 0x2222, L.c[0].a[2], L.c[0].a[3], 0x552b90);
    CK(L.c[0].a[2] > 0xffffffffu && L.c[0].a[3] > 0xffffffffu && L.c[0].has_loc);
    CK(memcmp(L.c[0].out, out, 16) == 0);
    CK(memcmp(L.c[0].isect, isect, 16) == 0);
}

static void test_m4c0d3f_present_rect(void)
{
    static const int32_t C0[4] = {10, 20, 100, 200};
    unsigned k;
    /* neither flag: nothing at all (both dwords tested whole: the low word is zero in the first, the high word in the second) */
    setup_rect();
    set32(fx.player, 0x212, 0);
    set_rects(C0, C0, 0, 0);
    expect_player_begin();
    m4c0d3f_present_rect(&fx.w, &fx.host);
    CKN(0);
    expect_player_end();
    /* the first flag [0x6381e5] (any non-zero dword): cleared, then 0x4c5377(this 0x5cf659, [0x5d19ef], [0x5cf665], [0x5d19f3], [0x5d19f7], 0x552b7c); [0x6381ed] clear: the word at +0x1cc is cleared */
    {
        static const uint32_t firsts[] = {1, 0x100, 0x10000, 0x01000000, 0xffffffffu};
        for (k = 0; k < sizeof firsts / sizeof firsts[0]; k++) {
            setup_rect();
            set32(fx.player, 0x20e, firsts[k]);
            set32(fx.player, 0x212, k & 1);
            expect_player_begin();
            m4c0d3f_present_rect(&fx.w, &fx.host);
            set32(exp_player, 0x20e, 0);
            exp_player[0x1cc] = exp_player[0x1cd] = 0;
            CKN(1);
            CKC(0, 0x4c5377, 0x5cf659, 0x1111, 0x2222, 0x3333, 0x4444, 0x552b7c);
            CK(get32(L.c[0].snap_player, 0x20e) == 0);
            expect_player_end();
        }
    }
    /* [0x6381ed] is a dword: 1, 0x100, 0x10000 and 0x01000000 all keep the word */
    {
        static const uint32_t thirds[] = {1, 0x100, 0x10000, 0x01000000, 0xffffffffu};
        for (k = 0; k < sizeof thirds / sizeof thirds[0]; k++) {
            setup_rect();
            set32(fx.player, 0x20e, 1);
            set32(fx.player, 0x216, thirds[k]);
            expect_player_begin();
            m4c0d3f_present_rect(&fx.w, &fx.host);
            set32(exp_player, 0x20e, 0);
            CKN(1);
            expect_player_end();
        }
    }
    /* the flag is read after the call: a callee that sets it keeps the word */
    setup_rect();
    set32(fx.player, 0x20e, 1);
    g_effect = effect_set_216;
    expect_player_begin();
    m4c0d3f_present_rect(&fx.w, &fx.host);
    set32(exp_player, 0x20e, 0);
    set32(exp_player, 0x216, 7);
    CKN(1);
    expect_player_end();
    /* the second branch: the rectangle D (50,60,150,250) against C (10,20,100,200) with B = (1000, 2000): isect (50,60,100,200), out (1040, 2040, 1090, 2180) */
    {
        static const int32_t D1[4] = {50, 60, 150, 250}, I1[4] = {50, 60, 100, 200}, O1[4] = {1040, 2040, 1090, 2180};
        setup_rect();
        set_rects(C0, D1, 1000, 2000);
        expect_player_begin();
        m4c0d3f_present_rect(&fx.w, &fx.host);
        ck_rect_call(O1, I1);
        expect_player_end();
    }
    /* D inside C on the low side: isect (10, 20, 60, 60) -> out (1000, 2000, 1050, 2040); D inside C entirely: isect = D */
    {
        static const int32_t D2[4] = {0, 0, 60, 60}, I2[4] = {10, 20, 60, 60}, O2[4] = {1000, 2000, 1050, 2040};
        static const int32_t D3[4] = {20, 30, 90, 150}, O3[4] = {1010, 2010, 1080, 2130};
        setup_rect();
        set_rects(C0, D2, 1000, 2000);
        expect_player_begin();
        m4c0d3f_present_rect(&fx.w, &fx.host);
        ck_rect_call(O2, I2);
        expect_player_end();
        L.n = 0;
        setup_rect();
        set_rects(C0, D3, 1000, 2000);
        expect_player_begin();
        m4c0d3f_present_rect(&fx.w, &fx.host);
        ck_rect_call(O3, D3);
        expect_player_end();
    }
    /* the four rejections, each at its boundary: D.x0 = 100 (= C.x1) still overlaps, 101 does not; D.x1 = 10 overlaps, 9 does not; D.y0 = 200 overlaps, 201 not; D.y1 = 20 overlaps, 19 not */
    {
        static const int32_t miss[4][4] = {{101, 30, 110, 40}, {0, 30, 9, 40}, {20, 201, 30, 210}, {20, 0, 30, 19}};
        static const int32_t touch[4][4] = {{100, 30, 110, 40}, {0, 30, 10, 40}, {20, 200, 30, 210}, {20, 0, 30, 20}};
        int32_t isect[4], out[4];
        for (k = 0; k < 4; k++) {
            setup_rect();
            set_rects(C0, miss[k], 7, 9);
            expect_player_begin();
            m4c0d3f_present_rect(&fx.w, &fx.host);
            CKN(0);
            expect_player_end();
            L.n = 0;
            setup_rect();
            set_rects(C0, touch[k], 7, 9);
            expect_player_begin();
            m4c0d3f_present_rect(&fx.w, &fx.host);
            isect[0] = touch[k][0] < 10 ? 10 : touch[k][0];
            isect[1] = touch[k][1] < 20 ? 20 : touch[k][1];
            isect[2] = touch[k][2] > 100 ? 100 : touch[k][2];
            isect[3] = touch[k][3] > 200 ? 200 : touch[k][3];
            out[0] = isect[0] - 10 + 7;
            out[1] = isect[1] - 20 + 9;
            out[2] = isect[2] - 10 + 7;
            out[3] = isect[3] - 20 + 9;
            ck_rect_call(out, isect);
            expect_player_end();
        }
    }
    /* signed compares: negative rectangles overlap (unsigned compares would reject them) */
    {
        static const int32_t Cn[4] = {-100, -100, -50, -50}, Dn[4] = {-60, -60, 0, 0}, In[4] = {-60, -60, -50, -50}, On[4] = {-60 + 100 + 3, -60 + 100 + 4, -50 + 100 + 3, -50 + 100 + 4};
        setup_rect();
        set_rects(Cn, Dn, 3, 4);
        expect_player_begin();
        m4c0d3f_present_rect(&fx.w, &fx.host);
        ck_rect_call(On, In);
        expect_player_end();
    }
    /* 32-bit wrap of the sums: C = D = (INT_MIN, 0, INT_MAX, 10), B = (5, 7): out = (5, 7, 4, 17) */
    {
        static const int32_t Cw[4] = {(int32_t)0x80000000u, 0, 0x7fffffff, 10}, Ow[4] = {5, 7, 4, 17};
        setup_rect();
        set_rects(Cw, Cw, 5, 7);
        expect_player_begin();
        m4c0d3f_present_rect(&fx.w, &fx.host);
        ck_rect_call(Ow, Cw);
        expect_player_end();
    }
    /* the second branch's own gates: [0x6381e9] clear, and the pair of dwords: (+0x176, +0x172) = (0, 1) and (1, any) pass; (0, 0), (0, 2), (2, x), (0x100, x), (0xffffffff, x) and (0, 0x100) do not */
    {
        static const uint32_t pairs[][2] = {{0, 1}, {1, 0}, {1, 1}, {1, 7}, {1, 0xffffffffu}, {0, 0}, {0, 2}, {0, 0x100}, {0, 0xffffffffu}, {2, 1}, {2, 0}, {0x100, 1}, {0x100, 0}, {0xffffffffu, 1}, {0x10000, 1}};
        static const int pass[] = {1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
        static const int32_t D1[4] = {50, 60, 150, 250};
        for (k = 0; k < sizeof pass / sizeof pass[0]; k++) {
            setup_rect();
            set32(fx.player, 0x176, pairs[k][0]);
            set32(fx.player, 0x172, pairs[k][1]);
            set_rects(C0, D1, 0, 0);
            expect_player_begin();
            m4c0d3f_present_rect(&fx.w, &fx.host);
            CKN(pass[k]);
            expect_player_end();
        }
        setup_rect();
        set32(fx.player, 0x212, 0);
        set_rects(C0, D1, 0, 0);
        expect_player_begin();
        m4c0d3f_present_rect(&fx.w, &fx.host);
        CKN(0);
        expect_player_end();
    }
}

/* ---- 0x4c5377 -------------------------------------------------------------------------------------------------------------------- */

static struct {
    uint32_t dst_base, stride;
} g_desc;

/* the lock call 0x4c4067 fills the local descriptor behind its third argument: the stride at +0x10 and the destination base at +0x24 */
static void effect_desc(int i, uint32_t callee, const uintptr_t *args)
{
    (void)i;
    if (callee == 0x4c4067) {
        memcpy((void *)(args[2] + 0x10), &g_desc.stride, 4);
        memcpy((void *)(args[2] + 0x24), &g_desc.dst_base, 4);
    }
}

static void setup_blit(uint32_t src_off, int16_t pitch, const int32_t *r1, const int32_t *r2, int16_t bpp, uint32_t dst_off, uint32_t stride)
{
    size_t b;
    int i;
    setup();
    for (b = 0; b < sizeof fx.px; b++) fx.px[b] = (uint8_t)(b * 7 + 1);
    memset(fx.dt, 0xEE, sizeof fx.dt);
    memset(fx.sf, 0x5A, sizeof fx.sf);
    set32(fx.sf, 0, PX_VA + src_off);
    set16(fx.sf, 0x2f, (uint16_t)pitch);
    for (i = 0; i < 4; i++) {
        set32(fx.rc, 4 * (size_t)i, (uint32_t)r1[i]);
        set32(fx.rc, 0x10 + 4 * (size_t)i, (uint32_t)r2[i]);
    }
    fx.w.word_639895 = bpp;
    g_desc.dst_base = DT_VA + dst_off;
    g_desc.stride = stride;
    g_effect = effect_desc;
    set32(fx.self, 0xc, 0x42);
}

static void expect_blit_begin(void)
{
    expect_begin();
    memcpy(exp_px, fx.px, sizeof exp_px);
    memcpy(exp_dt, fx.dt, sizeof exp_dt);
    memcpy(exp_sf, fx.sf, sizeof exp_sf);
    memcpy(exp_rc, fx.rc, sizeof exp_rc);
}

static void expect_blit_end_at(int line)
{
    if (!g_failed && (memcmp(exp_px, fx.px, sizeof exp_px) != 0 || memcmp(exp_dt, fx.dt, sizeof exp_dt) != 0 || memcmp(exp_sf, fx.sf, sizeof exp_sf) != 0 ||
                      memcmp(exp_rc, fx.rc, sizeof exp_rc) != 0)) {
        g_failed = 1;
        snprintf(g_msg, sizeof g_msg, "line %d: a pixel buffer, the surface or the rectangles differ from the expected copy", line);
    }
}

#define expect_blit_end() expect_blit_end_at(__LINE__)

/* the rows the original copies, hand-derived: row i of rowbytes bytes from src_off + i * pitch to dst_off + i * stride (non-overlapping buffers) */
static void expect_rows(int rows, uint32_t rowbytes, uint32_t src_off, int32_t pitch, uint32_t dst_off, int32_t stride)
{
    int i;
    uint32_t k;
    for (i = 0; i < rows; i++)
        for (k = 0; k < rowbytes; k++) exp_dt[(uint32_t)((int32_t)dst_off + i * stride) + k] = fx.px[(uint32_t)((int32_t)src_off + i * pitch) + k];
}

static void test_m4c5377_blit_rows(void)
{
    int32_t r1[4] = {1, 1, 3, 2}, r2[4] = {5, 6, 7, 7};
    int32_t r1w[4];
    int32_t ret;
    unsigned k;
    /* the normal path: x 1..3 (3 pixels of 2 bytes = 6 bytes), y 1..2 (2 rows); src = base 0 + 1 * 16 + 1 * 2 = 18, the next row at 34; dst base 4, stride 8; idx 7 differs from [self+0xc] = 0x42 */
    setup_blit(0, 16, r1, r2, 2, 4, 8);
    expect_blit_begin();
    ret = m4c5377_blit_rows(fx.self, SF_VA, 7, RC_VA, RC_VA + 0x10, 0xabcd, &fx.w, &fx.host);
    CK(ret == 0);
    expect_rows(2, 6, 18, 16, 4, 8);
    CK(fx.dt[4] == fx.px[18] && fx.dt[9] == fx.px[23] && fx.dt[10] == 0xEE && fx.dt[12] == fx.px[34] && fx.dt[17] == fx.px[39] && fx.dt[18] == 0xEE);
    CKN(2);
    CKC(0, 0x4c4067, SELFP, 7, RC_VA + 0x10, L.c[0].a[2], 0xabcd, 0x20);
    CK(L.c[0].a[2] > 0xffffffffu);
    CKC(1, 0x4c4202, SELFP, 7, RC_VA + 0x10, 0x554990);
    expect_blit_end();
    /* idx equal to [self+0xc]: 0x4c952f(this self, r2) follows; the compare is on the dword (0x10000 + 0x42 is not equal) */
    setup_blit(0, 16, r1, r2, 2, 4, 8);
    expect_blit_begin();
    ret = m4c5377_blit_rows(fx.self, SF_VA, 0x42, RC_VA, RC_VA + 0x10, 1, &fx.w, &fx.host);
    CK(ret == 0);
    expect_rows(2, 6, 18, 16, 4, 8);
    CKN(3);
    CKC(2, 0x4c952f, SELFP, RC_VA + 0x10);
    expect_blit_end();
    setup_blit(0, 16, r1, r2, 2, 4, 8);
    set32(fx.self, 0xc, 0x10042u);
    expect_blit_begin();
    ret = m4c5377_blit_rows(fx.self, SF_VA, 0x42, RC_VA, RC_VA + 0x10, 1, &fx.w, &fx.host);
    CK(ret == 0);
    expect_rows(2, 6, 18, 16, 4, 8);
    CKN(2);
    expect_blit_end();
    /* every row length 0..9 bytes (bpp 1): the dword part and the byte tail are exactly rowbytes bytes */
    for (k = 0; k < 10; k++) {
        r1w[0] = 0;
        r1w[1] = 0;
        r1w[2] = (int32_t)k - 1;
        r1w[3] = 2;
        setup_blit(0, 16, r1w, r2, 1, 0, 16);
        expect_blit_begin();
        ret = m4c5377_blit_rows(fx.self, SF_VA, 7, RC_VA, RC_VA + 0x10, 1, &fx.w, &fx.host);
        CK(ret == 0);
        expect_rows(3, k, 0, 16, 0, 16);
        CKN(2);
        expect_blit_end();
    }
    /* no rows: y1 = y0 - 1 (zero rows) and y1 = y0 - 2 (negative: the signed compare), the callees are still called, nothing copied */
    for (k = 0; k < 2; k++) {
        r1w[0] = 0;
        r1w[1] = 3;
        r1w[2] = 4;
        r1w[3] = 3 - 1 - (int32_t)k;
        setup_blit(0, 16, r1w, r2, 2, 0, 16);
        expect_blit_begin();
        ret = m4c5377_blit_rows(fx.self, SF_VA, 7, RC_VA, RC_VA + 0x10, 1, &fx.w, &fx.host);
        CK(ret == 0);
        CKN(2);
        expect_blit_end();
    }
    /* a negative pitch (movsx of the word) walks upwards: base 0x80, pitch -16, y 1..2: the first row at 0x80 - 16 + 0 (x 0) = 0x70, the second at 0x60 */
    r1w[0] = 0;
    r1w[1] = 1;
    r1w[2] = 3;
    r1w[3] = 2;
    setup_blit(0x80, -16, r1w, r2, 1, 0, 16);
    expect_blit_begin();
    ret = m4c5377_blit_rows(fx.self, SF_VA, 7, RC_VA, RC_VA + 0x10, 1, &fx.w, &fx.host);
    CK(ret == 0);
    expect_rows(2, 4, 0x70, -16, 0, 16);
    expect_blit_end();
    /* a negative stride from the callee: the destination rows walk downwards */
    setup_blit(0, 16, r1, r2, 2, 0x40, 0xfffffff0u);
    expect_blit_begin();
    ret = m4c5377_blit_rows(fx.self, SF_VA, 7, RC_VA, RC_VA + 0x10, 1, &fx.w, &fx.host);
    CK(ret == 0);
    expect_rows(2, 6, 18, 16, 0x40, -16);
    expect_blit_end();
    /* source and destination overlap (the same buffer, destination one byte after the source, 8 bytes): `rep movsd` forward gives a0 a0 a1 a2 a3 a3 a5 a6 a7 where memmove would give ... a4 ... */
    setup_blit(0, 16, (const int32_t[4]){0, 0, 7, 0}, r2, 1, 0, 0);
    g_desc.dst_base = PX_VA + 1;
    expect_blit_begin();
    ret = m4c5377_blit_rows(fx.self, SF_VA, 7, RC_VA, RC_VA + 0x10, 1, &fx.w, &fx.host);
    CK(ret == 0);
    /* hand-derived expectation from the original source bytes: b0 b0 b1 b2 b3 b3 b5 b6 b7 (b = the original px[0..7]) */
    {
        uint8_t b[8];
        int j;
        for (j = 0; j < 8; j++) b[j] = (uint8_t)(j * 7 + 1);
        exp_px[0] = b[0];
        exp_px[1] = b[0];
        exp_px[2] = b[1];
        exp_px[3] = b[2];
        exp_px[4] = b[3];
        exp_px[5] = b[3];
        exp_px[6] = b[5];
        exp_px[7] = b[6];
        exp_px[8] = b[7];
    }
    expect_blit_end();
    /* the pitch is read again after every row: the first row (4 bytes) is copied over the surface at +0x2d, which replaces the pitch word at +0x2f by bytes 2..3 of the row */
    r1w[0] = 0;
    r1w[1] = 0;
    r1w[2] = 3;
    r1w[3] = 1;
    setup_blit(0, 16, r1w, r2, 1, 0, 0);
    fx.px[2] = 0x20;      /* the new pitch word: 0x0020 */
    fx.px[3] = 0x00;
    g_desc.dst_base = SF_VA + 0x2d;
    g_desc.stride = 0;
    expect_blit_begin();
    ret = m4c5377_blit_rows(fx.self, SF_VA, 7, RC_VA, RC_VA + 0x10, 1, &fx.w, &fx.host);
    CK(ret == 0);
    /* row 0: px[0..3] -> sf[0x2d..0x30]; the new pitch is 0x20, so row 1 comes from 0x20 .. 0x23 (px[0x20 + j]) and is copied to the same place (stride 0) */
    exp_sf[0x2d] = fx.px[0x20];
    exp_sf[0x2e] = fx.px[0x21];
    exp_sf[0x2f] = fx.px[0x22];
    exp_sf[0x30] = fx.px[0x23];
    expect_blit_end();
    /* the debug word on, rectangles of the same size, surf and idx non-zero: the normal path (every non-zero word value is on) */
    {
        static const int16_t on[] = {1, 0x100, -32768, -1};
        for (k = 0; k < sizeof on / sizeof on[0]; k++) {
            setup_blit(0, 16, r1, (const int32_t[4]){5, 6, 7, 7}, 2, 4, 8);
            fx.w.word_63a4cd = on[k];
            expect_blit_begin();
            ret = m4c5377_blit_rows(fx.self, SF_VA, 7, RC_VA, RC_VA + 0x10, 1, &fx.w, &fx.host);
            CK(ret == 0);
            expect_rows(2, 6, 18, 16, 4, 8);
            CKN(2);
            expect_blit_end();
        }
    }
    /* the debug word on and one condition failing: the diagnostic, no copy; the text is a local buffer; r2 = (5, 6, 7, 7) is 2 x 1 big, r1 is 2 x 1 (x1 - x0 = 2, y1 - y0 = 1) */
    {
        struct {
            int32_t r2[4];
            uint32_t surf, idx;
        } bad[] = {{{5, 6, 8, 7}, SF_VA, 7}, {{5, 6, 7, 8}, SF_VA, 7}, {{5, 6, 7, 7}, 0, 7}, {{5, 6, 7, 7}, SF_VA, 0}, {{5, 6, 8, 9}, 0, 0}};
        for (k = 0; k < sizeof bad / sizeof bad[0]; k++) {
            setup_blit(0, 16, r1, bad[k].r2, 2, 4, 8);
            fx.w.word_63a4cd = 0x100;
            expect_blit_begin();
            ret = m4c5377_blit_rows(fx.self, bad[k].surf, bad[k].idx, RC_VA, RC_VA + 0x10, 0x77, &fx.w, &fx.host);
            CK(ret == 0);
            CKN(3);
            CKC(0, 0x50ca3e, 0, L.c[0].a[0], 0x5548ec, 0x77, 1, 1, 3, 2, (uintptr_t)bad[k].r2[0], (uintptr_t)bad[k].r2[1], (uintptr_t)bad[k].r2[2], (uintptr_t)bad[k].r2[3]);
            CK(L.c[0].a[0] > 0xffffffffu);
            CKC(1, 0x52139c, 0, L.c[0].a[0], 0, 0);
            CKC0(2, 0x4c97b4, SELFP);
            expect_blit_end();
        }
    }
    /* the debug word off: the extents are not checked */
    setup_blit(0, 16, r1, (const int32_t[4]){0, 0, 99, 99}, 2, 4, 8);
    expect_blit_begin();
    ret = m4c5377_blit_rows(fx.self, SF_VA, 0, RC_VA, RC_VA + 0x10, 1, &fx.w, &fx.host);
    CK(ret == 0);
    expect_rows(2, 6, 18, 16, 4, 8);
    CKN(2);
    expect_blit_end();
    /* native rejections: surf == 0 without the debug word (nothing happens at all), and a negative width with rows to copy (after the lock call) */
    setup_blit(0, 16, r1, r2, 2, 4, 8);
    expect_blit_begin();
    ret = m4c5377_blit_rows(fx.self, 0, 7, RC_VA, RC_VA + 0x10, 1, &fx.w, &fx.host);
    CK(ret == 1);
    CKN(0);
    expect_blit_end();
    r1w[0] = 3;
    r1w[1] = 0;
    r1w[2] = 1;
    r1w[3] = 1;
    setup_blit(0, 16, r1w, r2, 2, 4, 8);
    expect_blit_begin();
    ret = m4c5377_blit_rows(fx.self, SF_VA, 7, RC_VA, RC_VA + 0x10, 1, &fx.w, &fx.host);
    CK(ret == 1);
    CKN(1);
    expect_blit_end();
    /* a negative width with no rows is not rejected */
    r1w[3] = -1;
    setup_blit(0, 16, r1w, r2, 2, 4, 8);
    expect_blit_begin();
    ret = m4c5377_blit_rows(fx.self, SF_VA, 7, RC_VA, RC_VA + 0x10, 1, &fx.w, &fx.host);
    CK(ret == 0);
    CKN(2);
    expect_blit_end();
}

/* ---- 0x4c04e3 -------------------------------------------------------------------------------------------------------------------- */

static void setup_movie(uint32_t state, uint32_t ok, uint32_t f, uint32_t r_ee2c, int16_t dbg)
{
    uint32_t okv[1], fv[1], rv[1];
    size_t b;
    setup();
    for (b = 0; b < sizeof fx.rec; b++) fx.rec[b] = 0xA5;
    fx.w.records_5bb5e5 = fx.rec + 0x8d;
    fx.w.word_63a4cd = dbg;
    set32(fx.self, 0x1da, state);
    set32(fx.self, 0x18e, 0x1357);
    set32(fx.self, 0x222, OBJ_VA);
    set32(fx.obj, 0, 0xaabbccddu);
    set16(fx.obj, 0x2d, 0xfffe);
    set16(fx.obj, 0x2f, 0x8001);
    okv[0] = ok;
    fv[0] = f;
    rv[0] = r_ee2c;
    script(0x4bef85, 1, okv);
    script(0x4bf10f, 1, fv);
    script(0x4bee2c, 1, rv);
}

static void expect_movie_begin(void)
{
    expect_begin();
    memcpy(exp_rec, fx.rec, sizeof exp_rec);
}

static void expect_movie_end_at(int line)
{
    expect_end_at(line);
    if (!g_failed && memcmp(exp_rec, fx.rec, sizeof exp_rec) != 0) {
        g_failed = 1;
        snprintf(g_msg, sizeof g_msg, "line %d: the record table differs from the expected copy", line);
    }
}

#define expect_movie_end() expect_movie_end_at(__LINE__)

#define H 0x6201f9u

/* the calls of the shared sequence from index n on (0x4befc8, 0x4bf098, 0x4bee2c, 0x4c0ab1, 0x4c08d3, 0x4bf10f) */
static void ck_sequence(int n)
{
    CKC(n, 0x4befc8, H, 0x1357);
    CKC(n + 1, 0x4bf098, H, 0x1357, 0xaabbccddu, 0xffff8001u, 0xfffffffeu, 0, 0);
    CKC(n + 2, 0x4bee2c, H, 0x1357);
    CKC0(n + 3, 0x4c0ab1, SELFP);
    CKC0(n + 4, 0x4c08d3, SELFP);
    CKC(n + 5, 0x4bf10f, H, 0x1357);
}

static void test_m4c04e3_start_movie(void)
{
    static const int16_t idxs[] = {-1, 0, 2, 4};
    unsigned k;
    /* state 0, 0x4bef85 non-zero, 0x4bf10f non-zero, debug off: the sequence; [+0x244] = result - 1 (word), [+0x216] = 1, [+0x240] = 2, [+0x21a] = 1, then [+0x1da] = 4; no record store */
    setup_movie(0, 1, 1, 0x10005, 0);
    expect_movie_begin();
    m4c04e3_start_movie(fx.self, 2, &fx.w, &fx.host);
    set16(exp_self, 0x244, 4);
    set32(exp_self, 0x216, 1);
    set32(exp_self, 0x240, 2);
    set32(exp_self, 0x21a, 1);
    set32(exp_self, 0x1da, 4);
    CKN(7);
    CKC(0, 0x4bef85, H, 0x1357);
    ck_sequence(1);
    CK(get32(L.c[4].snap_self, 0x216) == 0xA5A5A5A5u && L.c[4].snap_self[0x244] == 4);          /* 0x4c0ab1 comes after the word store, before [+0x216] */
    CK(get32(L.c[5].snap_self, 0x216) == 1 && get32(L.c[5].snap_self, 0x240) == 2 && get32(L.c[5].snap_self, 0x21a) == 1 && get32(L.c[5].snap_self, 0x1da) == 0);
    CK(get32(L.c[6].snap_self, 0x1da) == 0);
    expect_movie_end();
    /* 0x4bf10f zero: the record `rec` (signed word, stride 0x8d) gets the dword 2 at +0x4d; [+0x1da] stays 0 */
    for (k = 0; k < sizeof idxs / sizeof idxs[0]; k++) {
        setup_movie(0, 1, 0, 1, 0);
        expect_movie_begin();
        m4c04e3_start_movie(fx.self, idxs[k], &fx.w, &fx.host);
        set16(exp_self, 0x244, 0);
        set32(exp_self, 0x216, 1);
        set32(exp_self, 0x240, 2);
        set32(exp_self, 0x21a, 1);
        set32(exp_rec, (size_t)((idxs[k] + 1) * 0x8d + 0x4d), 2);
        CKN(7);
        expect_movie_end();
    }
    /* the word store wraps: a result of 0 gives 0xffff, 0x10000 gives 0xffff, 0xffffffff gives 0xfffe */
    {
        static const uint32_t rs[] = {0, 0x10000, 0xffffffffu, 0x12345};
        static const uint16_t want[] = {0xffff, 0xffff, 0xfffe, 0x2344};
        for (k = 0; k < 4; k++) {
            setup_movie(0, 1, 1, rs[k], 0);
            expect_movie_begin();
            m4c04e3_start_movie(fx.self, 0, &fx.w, &fx.host);
            set16(exp_self, 0x244, want[k]);
            set32(exp_self, 0x216, 1);
            set32(exp_self, 0x240, 2);
            set32(exp_self, 0x21a, 1);
            set32(exp_self, 0x1da, 4);
            expect_movie_end();
        }
    }
    /* debug on (any non-zero word): the first trace 0x50ca3e(0x63888b, 0x5529e0), 0x44a2b7(0x63888b) before 0x4bef85; the closing trace after the 0x4bf10f branch (0x552a14 when it is non-zero) */
    {
        static const int16_t on[] = {1, 0x100, -32768, -1};
        for (k = 0; k < sizeof on / sizeof on[0]; k++) {
            setup_movie(0, 1, 1, 3, on[k]);
            expect_movie_begin();
            m4c04e3_start_movie(fx.self, 1, &fx.w, &fx.host);
            set16(exp_self, 0x244, 2);
            set32(exp_self, 0x216, 1);
            set32(exp_self, 0x240, 2);
            set32(exp_self, 0x21a, 1);
            set32(exp_self, 0x1da, 4);
            CKN(10);
            CKC(0, 0x50ca3e, 0, 0x63888b, 0x5529e0);
            CKC(1, 0x44a2b7, 0, 0x63888b);
            CKC(2, 0x4bef85, H, 0x1357);
            ck_sequence(3);
            CKC(9, 0x44a2b7, 0, 0x552a14);
            CK(get32(L.c[9].snap_self, 0x1da) == 4);
            expect_movie_end();
        }
    }
    /* debug on, 0x4bf10f zero: the record is stored before the trace 0x552a58 */
    setup_movie(0, 1, 0, 3, 1);
    expect_movie_begin();
    m4c04e3_start_movie(fx.self, 3, &fx.w, &fx.host);
    set16(exp_self, 0x244, 2);
    set32(exp_self, 0x216, 1);
    set32(exp_self, 0x240, 2);
    set32(exp_self, 0x21a, 1);
    set32(exp_rec, (size_t)((3 + 1) * 0x8d + 0x4d), 2);
    CKN(10);
    CKC(9, 0x44a2b7, 0, 0x552a58);
    CK(get32(L.c[9].snap_rec, (4 * 0x8d) + 0x4d) == 2);
    expect_movie_end();
    /* 0x4bef85 zero (every dword: 0x4bef85 non-zero is the test of the whole eax): nothing else happens in either state, also with the debug word on (state 0 traces first) */
    {
        static const uint32_t oks[] = {1, 0x100, 0x80000000u, 0xffffffffu};
        for (k = 0; k < sizeof oks / sizeof oks[0]; k++) {
            setup_movie(0, oks[k], 1, 3, 0);
            expect_movie_begin();
            m4c04e3_start_movie(fx.self, 1, &fx.w, &fx.host);
            set16(exp_self, 0x244, 2);
            set32(exp_self, 0x216, 1);
            set32(exp_self, 0x240, 2);
            set32(exp_self, 0x21a, 1);
            set32(exp_self, 0x1da, 4);
            CKN(7);
            expect_movie_end();
        }
    }
    setup_movie(0, 0, 1, 3, 1);
    expect_movie_begin();
    m4c04e3_start_movie(fx.self, 1, &fx.w, &fx.host);
    CKN(3);
    CKC(2, 0x4bef85, H, 0x1357);
    expect_movie_end();
    setup_movie(4, 0, 1, 3, 1);
    expect_movie_begin();
    m4c04e3_start_movie(fx.self, 1, &fx.w, &fx.host);
    CKN(1);
    CKC(0, 0x4bef85, H, 0x1357);
    expect_movie_end();
    /* state 4: no first trace, no [+0x21a], the state stays 4; with 0x4bf10f non-zero nothing more */
    setup_movie(4, 1, 1, 0x10005, 1);
    expect_movie_begin();
    m4c04e3_start_movie(fx.self, 2, &fx.w, &fx.host);
    set16(exp_self, 0x244, 4);
    set32(exp_self, 0x216, 1);
    set32(exp_self, 0x240, 2);
    CKN(7);
    CKC(0, 0x4bef85, H, 0x1357);
    ck_sequence(1);
    CK(get32(L.c[5].snap_self, 0x216) == 1 && get32(L.c[5].snap_self, 0x240) == 2 && get32(L.c[5].snap_self, 0x21a) == 0xA5A5A5A5u);
    expect_movie_end();
    /* state 4 and 0x4bf10f zero: the record store and the trace 0x552ac4 */
    setup_movie(4, 1, 0, 0x10005, 1);
    expect_movie_begin();
    m4c04e3_start_movie(fx.self, 2, &fx.w, &fx.host);
    set16(exp_self, 0x244, 4);
    set32(exp_self, 0x216, 1);
    set32(exp_self, 0x240, 2);
    set32(exp_rec, (size_t)((2 + 1) * 0x8d + 0x4d), 2);
    CKN(8);
    CKC(7, 0x44a2b7, 0, 0x552ac4);
    CK(get32(L.c[7].snap_rec, 3 * 0x8d + 0x4d) == 2);
    expect_movie_end();
    setup_movie(4, 1, 0, 3, 0);
    expect_movie_begin();
    m4c04e3_start_movie(fx.self, -1, &fx.w, &fx.host);
    set16(exp_self, 0x244, 2);
    set32(exp_self, 0x216, 1);
    set32(exp_self, 0x240, 2);
    set32(exp_rec, 0x4d, 2);
    CKN(7);
    expect_movie_end();
    /* any other state (a dword compare: 0x100, 0x10000, 0x01000000, 0x80000000 and 0xffffffff are not 0 or 4): nothing is called or stored */
    {
        static const uint32_t others[] = {1, 2, 3, 5, 0x100, 0x10000, 0x01000000, 0x80000000u, 0xffffffffu, 0x104, 0x10004};
        for (k = 0; k < sizeof others / sizeof others[0]; k++) {
            setup_movie(others[k], 1, 1, 3, 1);
            expect_movie_begin();
            m4c04e3_start_movie(fx.self, 1, &fx.w, &fx.host);
            CKN(0);
            expect_movie_end();
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
        /* 0x4c2c3a: a random terminated name, random dimensions */
        L.n = 0;
        g_nscript = 0;
        for (k = 0; k < 0x80; k++) fx.name[k] = (uint8_t)(1 + rnd() % 255);
        fx.name[rnd() % 0x40] = 0;
        fx.name[0x7f] = 0;
        seq[0] = (rnd() & 3) ? OBJ_VA : 0;
        seq[1] = (rnd() & 3) ? 0x5555 : 0;
        script(0x51dc43, 2, seq);
        fx.w.word_639895 = (int16_t)rnd();
        (void)m4c2c3a_make_record(fx.self, (int16_t)rnd(), (int16_t)rnd(), rnd(), rnd(), NAME_VA, &fx.w, &fx.host);
        /* 0x4c0d3f: random player object and rectangles */
        L.n = 0;
        g_nscript = 0;
        for (k = 0; k < 0x220; k++) fx.player[k] = (uint8_t)rnd();
        for (k = 0; k < 0x20; k++) fx.rectd[k] = (uint8_t)rnd();
        fx.w.player_637fd7 = fx.player;
        fx.w.rect_583122 = fx.rectd;
        if (rnd() & 1) set32(fx.player, 0x20e, 0);
        set32(fx.player, 0x176, rnd() & 1);
        m4c0d3f_present_rect(&fx.w, &fx.host);
        /* 0x4c5377: random small rectangles inside the buffers (the caller-validated bounds are respected), the debug word on in half of the runs */
        L.n = 0;
        g_nscript = 0;
        {
            int32_t q1[4], q2[4];
            int bpp = 1 + (int)(rnd() % 4);
            q1[0] = (int32_t)(rnd() % 4);
            q1[1] = (int32_t)(rnd() % 3);
            q1[2] = q1[0] + (int32_t)(rnd() % 5) - 1;
            q1[3] = q1[1] + (int32_t)(rnd() % 3) - 1;
            q2[0] = (int32_t)(rnd() % 4);
            q2[1] = (int32_t)(rnd() % 3);
            q2[2] = q2[0] + (int32_t)(rnd() % 5) - 1;
            q2[3] = q2[1] + (int32_t)(rnd() % 3) - 1;
            setup_blit(rnd() % 0x10, (int16_t)(0x10 + rnd() % 0x10), q1, q2, (int16_t)bpp, rnd() % 0x20, rnd() % 0x20);
            fx.w.word_63a4cd = (int16_t)(rnd() & 1);
            (void)m4c5377_blit_rows(fx.self, (rnd() & 7) ? SF_VA : 0, rnd() & 3, RC_VA, RC_VA + 0x10, rnd(), &fx.w, &fx.host);
        }
        /* 0x4c04e3 */
        L.n = 0;
        g_nscript = 0;
        setup_movie((uint32_t)((rnd() & 1) ? 4 : (rnd() & 1) ? 0 : rnd()), rnd() & 1, rnd() & 1, rnd(), (int16_t)(rnd() & 1));
        m4c04e3_start_movie(fx.self, (int16_t)((int)(rnd() % 6) - 1), &fx.w, &fx.host);
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
    RUN(test_m4c2c3a_make_record);
    RUN(test_m4c0d3f_present_rect);
    RUN(test_m4c5377_blit_rows);
    RUN(test_m4c04e3_start_movie);
    /* TESTS-END */
    RUN(test_sweep_bounded);
    return failures;
}
