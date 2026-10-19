/* FL-27 (batch c) direct tests of the movie-player methods of GAME.EXE in src/original_methods_fl27c.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit
 * status is the failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running
 * the native code; tests/test_fl27c_differential.py additionally runs the original bytes on generated fixtures.
 *
 * Every function is checked three ways: (1) the guard matrix, each guard failing in turn, which must leave the object and the call log as the original does;
 * (2) each arm with the whole object compared with a hand-edited copy, and the ordered host calls with their arguments and the state of the object at the call;
 * (3) widths, signedness and the edges of every comparison, the native rejections, and the loops. */
#include "../src/original_methods_fl27c.h"

#include <math.h>
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
#define NAME_VA 0x20030000u
#define VT_STUB_B 0x7e000a00u
#define SNAP 0x300

static void set32(uint8_t *o, size_t off, uint32_t v) { memcpy(o + off, &v, 4); }
__attribute__((unused)) static void set16(uint8_t *o, size_t off, uint16_t v) { memcpy(o + off, &v, 2); }
static uint32_t get32(const uint8_t *o, size_t off)
{
    uint32_t v;
    memcpy(&v, o + off, 4);
    return v;
}
__attribute__((unused)) static uint16_t get16(const uint8_t *o, size_t off)
{
    uint16_t v;
    memcpy(&v, o + off, 2);
    return v;
}

static struct {
    uint8_t self[SELF_SZ], obj[OBJ_SZ], vt[0x100], name[0x200];
    Fl27cWorld w;
    Fl18Host host;
} fx;
static uint8_t exp_self[SELF_SZ], exp_obj[OBJ_SZ];

#define MAXCALL 64
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[16];
        uint8_t snap_self[SNAP];
        uint8_t snap_obj[OBJ_SZ];
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
        for (k = 0; k < nargs && k < 16; k++) L.c[i].a[k] = args[k];
        memcpy(L.c[i].snap_self, fx.self, SNAP);
        memcpy(L.c[i].snap_obj, fx.obj, OBJ_SZ);
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
    if (a >= VT_VA && a < VT_VA + 0x100) return fx.vt + (a - VT_VA);
    if (a >= NAME_VA && a < NAME_VA + 0x200) return fx.name + (a - NAME_VA);
    return NULL;
}

static void setup(void)
{
    size_t b;
    memset(fx.self, 0xA5, sizeof fx.self);
    for (b = 0; b < OBJ_SZ; b++) fx.obj[b] = (uint8_t)(b * 7 + 3);
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
}

static void expect_end_at(int line)
{
    if (!g_failed && (memcmp(exp_self, fx.self, sizeof exp_self) != 0 || memcmp(exp_obj, fx.obj, sizeof exp_obj) != 0)) {
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

/* CKC(n, callee, this, args...): the n-th logged call; CKC0 for no arguments */
#define CKC(n, callee, thisp, ...)                                                         \
    do {                                                                                   \
        const uintptr_t w_[] = {0, __VA_ARGS__};                                           \
        ck_call_at(__LINE__, (n), (callee), (uintptr_t)(thisp), (int)(sizeof w_ / sizeof w_[0]) - 1, w_ + 1); \
    } while (0)
#define CKC0(n, callee, thisp) ck_call_at(__LINE__, (n), (callee), (uintptr_t)(thisp), 0, NULL)
#define CKN(count) CK(L.n == (count))

#define SELFP ((uintptr_t)fx.self)

/* ---- 0x4497a0 -------------------------------------------------------------------------------------------------------------------- */

static void put_name(const char *s)
{
    memset(fx.name, 0x44, sizeof fx.name);
    memcpy(fx.name, s, strlen(s) + 1);
}

/* the object of 0x4497a0 scenarios: vtable at VT_VA, entry 0x78 = VT_STUB_B, handle [+0x28], value [+0x2c] */
static void ctor_object(void)
{
    set32(fx.obj, 0, VT_VA);
    set32(fx.obj, 0x28, 0x1234abcdu);
    set32(fx.obj, 0x2c, 0x0badf00du);
    set32(fx.vt, 0x78, VT_STUB_B);
}

static void ctor_scripts(uint32_t alloc, uint32_t objres, uint32_t init, uint32_t wait, uint32_t resume)
{
    script(0x51dc43, 1, &alloc);
    script(0x524aff, 1, &objres);
    script(0x51ed8c, 1, &init);
    script(0x52a2ac, 1, &wait);
    script(0x52a284, 1, &resume);
}

static uint32_t g_clear_at;
static void clear_self_at_call(int i, uint32_t callee, const uintptr_t *args)
{
    (void)i;
    (void)args;
    if (callee == g_clear_at) set32(fx.self, 0x36, 0);
}

static void test_m4497a0_construct(void)
{
    uint32_t k;
    uint8_t *r;
    /* the string copy: forward, the terminator included, over 0x3a/0x3e/0x42 that were initialised before it (a 0x37-character string reaches +0x3b..) */
    setup();
    ctor_object();
    put_name("");
    ctor_scripts(0, 0, 0, 0, 0);
    expect_begin();
    r = m4497a0_construct(fx.self, 0x11111111u, NAME_VA, 0x22222222u, 4, &fx.w, &fx.host);
    CK(r == fx.self);
    set32(exp_self, 0, 0x52cb5c);
    set32(exp_self, 0x36, 0);
    set32(exp_self, 0x42, 3);
    set32(exp_self, 0x3a, 0xffffffffu);
    set32(exp_self, 0x3e, 0);
    exp_self[4] = 0;
    /* guard: 0x51dc43 gives 0, so 0x524aff is not called; obj == 0: the two reports, then the return */
    CKN(3);
    CKC(0, 0x51dc43, 0, 0x68);
    CKC(1, 0x4264e8, 0x583979, 0x548844);
    CKC0(2, 0x4c97b4, 0x5cf659);
    expect_end();
    /* the copy covers the terminator and the following bytes stay: 1, 3, 4, 5, 7 characters (dword and byte tails) */
    for (k = 0; k < 6; k++) {
        static const char *names[] = {"a", "abc", "abcd", "abcde", "abcdefg", "abcdefgh"};
        setup();
        ctor_object();
        put_name(names[k]);
        ctor_scripts(0, 0, 0, 0, 0);
        expect_begin();
        CK(m4497a0_construct(fx.self, 0, NAME_VA, 0, 0, &fx.w, &fx.host) == fx.self);
        set32(exp_self, 0, 0x52cb5c);
        set32(exp_self, 0x36, 0);
        set32(exp_self, 0x42, 3);
        set32(exp_self, 0x3a, 0xffffffffu);
        set32(exp_self, 0x3e, 0);
        memcpy(exp_self + 4, names[k], strlen(names[k]) + 1);
        expect_end();
    }
    /* a 0x3d-character string reaches +0x41: the initial stores at +0x3a / +0x3e (made BEFORE the copy) are overwritten by the string bytes, +0x42 keeps 3 only below +0x42 */
    {
        char longname[0x40];
        memset(longname, 'x', sizeof longname);
        longname[0x3c] = 0;
        longname[0x38] = 'y';
        setup();
        ctor_object();
        put_name(longname);
        ctor_scripts(0, 0, 0, 0, 0);
        expect_begin();
        CK(m4497a0_construct(fx.self, 0, NAME_VA, 0, 0, &fx.w, &fx.host) == fx.self);
        set32(exp_self, 0, 0x52cb5c);
        set32(exp_self, 0x42, 3);
        set32(exp_self, 0x3a, 0xffffffffu);
        set32(exp_self, 0x3e, 0);
        memcpy(exp_self + 4, longname, 0x3d);       /* the copy comes AFTER the initial stores ... */
        set32(exp_self, 0x36, 0);                   /* ... and [+0x36] = obj after the copy */
        expect_end();
    }
    /* allocation succeeds, the constructor returns 0: the call carries this = the allocation, arg8 and the host pointer self + 0x3e */
    setup();
    ctor_object();
    put_name("m");
    ctor_scripts(0x30000000u, 0, 0, 0, 0);
    expect_begin();
    CK(m4497a0_construct(fx.self, 0xcafef00du, NAME_VA, 7, 0, &fx.w, &fx.host) == fx.self);
    set32(exp_self, 0, 0x52cb5c);
    set32(exp_self, 0x36, 0);
    set32(exp_self, 0x42, 3);
    set32(exp_self, 0x3a, 0xffffffffu);
    set32(exp_self, 0x3e, 0);
    memcpy(exp_self + 4, "m", 2);
    CKN(4);
    CKC(0, 0x51dc43, 0, 0x68);
    CKC(1, 0x524aff, 0x30000000u, 0xcafef00du, SELFP + 0x3e);
    CKC(2, 0x4264e8, 0x583979, 0x548844);
    CKC0(3, 0x4c97b4, 0x5cf659);
    expect_end();
    /* success path, flags 4: no resume call, [+0x42] = 1, [obj+0x24] = 0 at the end, [+0x3a] = [obj+0x2c], this of 0x51ed8c = the object, flags | 4 */
    setup();
    ctor_object();
    put_name("mv");
    ctor_scripts(0x30000000u, OBJ_VA, 1, 0x102, 0xffffffffu);
    expect_begin();
    CK(m4497a0_construct(fx.self, 5, NAME_VA, 0x1388, 4, &fx.w, &fx.host) == fx.self);
    set32(exp_self, 0, 0x52cb5c);
    set32(exp_self, 0x36, OBJ_VA);
    set32(exp_self, 0x3e, 0);
    set32(exp_self, 0x3a, 0x0badf00du);
    set32(exp_self, 0x42, 1);
    memcpy(exp_self + 4, "mv", 3);
    set32(exp_obj, 0x24, 0);
    CKN(4);
    CKC(0, 0x51dc43, 0, 0x68);
    CKC(1, 0x524aff, 0x30000000u, 5, SELFP + 0x3e);
    CKC(2, 0x51ed8c, OBJ_VA, 4, 0, 0);
    CKC(3, 0x52a2ac, 0, 0x1234abcdu, 0x1388);
    /* [obj+0x24] was 1 at the 0x51ed8c call */
    CK(get32(L.c[2].snap_obj, 0x24) == 1);
    expect_end();
    /* flags 0 (bit 2 clear): flags | 4 passed, the resume import is called; result != 0xffffffff: [+0x42] = 2 (also for flags 5 -> only != 4 decides, 1 -> 2) */
    {
        static const uint32_t flags[] = {0, 1, 2, 5, 0xc, 0x80000004u, 0xfffffffbu, 0xffffffffu, 8, 0x100};
        for (k = 0; k < sizeof flags / sizeof flags[0]; k++) {
            int resume_called = (flags[k] & 4) == 0;
            setup();
            ctor_object();
            put_name("q");
            ctor_scripts(0x30000000u, OBJ_VA, 1, 5, 0xfffffffeu);
            expect_begin();
            CK(m4497a0_construct(fx.self, 5, NAME_VA, 0x1388, flags[k], &fx.w, &fx.host) == fx.self);
            set32(exp_self, 0, 0x52cb5c);
            set32(exp_self, 0x36, OBJ_VA);
            set32(exp_self, 0x3e, 0);
            set32(exp_self, 0x3a, 0x0badf00du);
            set32(exp_self, 0x42, flags[k] == 4 ? 1 : 2);
            memcpy(exp_self + 4, "q", 2);
            set32(exp_obj, 0x24, 0);
            CKN(resume_called ? 5 : 4);
            CKC(2, 0x51ed8c, OBJ_VA, flags[k] | 4u, 0, 0);
            if (resume_called) CKC(4, 0x52a284, 0, 0x1234abcdu);
            expect_end();
        }
    }
    /* the three failure reports after the constructor: 0x51ed8c = 0, 0x52a2ac = 0, 0x52a284 = 0xffffffff, each with the virtual call (this = the object) and its own message */
    for (k = 0; k < 3; k++) {
        static const uint32_t msg[] = {0x548894, 0x5488d8, 0x548920};
        int base = 3 + (int)k;      /* index of the virtual call: after 0x51dc43, 0x524aff, 0x51ed8c and the imports that ran */
        setup();
        ctor_object();
        put_name("f");
        ctor_scripts(0x30000000u, OBJ_VA, k == 0 ? 0 : 1, k == 1 ? 0 : 3, k == 2 ? 0xffffffffu : 0);
        expect_begin();
        CK(m4497a0_construct(fx.self, 5, NAME_VA, 0x1388, 0, &fx.w, &fx.host) == fx.self);
        set32(exp_self, 0, 0x52cb5c);
        set32(exp_self, 0x36, OBJ_VA);
        set32(exp_self, 0x3e, 0);
        set32(exp_self, 0x3a, 0xffffffffu);
        set32(exp_self, 0x42, 3);
        memcpy(exp_self + 4, "f", 2);
        set32(exp_obj, 0x24, 1);
        CKN(base + 3);
        CKC(2, 0x51ed8c, OBJ_VA, 4, 0, 0);
        if (k >= 1) CKC(3, 0x52a2ac, 0, 0x1234abcdu, 0x1388);
        if (k == 2) CKC(4, 0x52a284, 0, 0x1234abcdu);
        CKC0(base, VT_STUB_B, OBJ_VA);
        CKC(base + 1, 0x4264e8, 0x583979, msg[k]);
        CKC0(base + 2, 0x4c97b4, 0x5cf659);
        /* the vtable was read from the object, the entry from the vtable: nothing is written */
        expect_end();
    }
    /* the debug word: a word (movsx), 1, 0x100, 0x8000, 0xffff are on; the trace gets the host buffer, the format, [+0x3a] (= [obj+0x2c]) and self + 4 */
    {
        static const int16_t on[] = {1, 0x100, -32768, -1};
        for (k = 0; k < 5; k++) {
            setup();
            ctor_object();
            put_name("dbg");
            ctor_scripts(0x30000000u, OBJ_VA, 1, 5, 0);
            fx.w.word_63a4cd = k < 4 ? on[k] : 0;
            expect_begin();
            CK(m4497a0_construct(fx.self, 5, NAME_VA, 0x1388, 4, &fx.w, &fx.host) == fx.self);
            CKN(k < 4 ? 6 : 4);
            if (k < 4) {
                CKC(4, 0x50ca3e, 0, L.c[4].a[0], 0x548968, 0x0badf00du, SELFP + 4);
                CKC(5, 0x44a2b7, 0, L.c[4].a[0]);
                CK(L.c[4].a[0] > 0xffffffffu || sizeof(void *) == 4);
                /* the trace sees the updated [+0x3a] */
                CK(get32(L.c[4].snap_self, 0x3a) == 0x0badf00du);
            }
        }
    }
    /* native rejection: a callee cleared [self+0x36] (the original would fault); each re-read is guarded */
    {
        static const struct { uint32_t at, init, wait, resume, flags; } cases[] = {
            {0x51ed8c, 0, 3, 0, 0}, {0x51ed8c, 1, 3, 0, 0}, {0x52a2ac, 1, 0, 0, 0}, {0x52a2ac, 1, 3, 0, 4},
            {0x52a284, 1, 3, 0xffffffffu, 0}, {0x52a284, 1, 3, 5, 0},
        };
        for (k = 0; k < sizeof cases / sizeof cases[0]; k++) {
            setup();
            ctor_object();
            put_name("r");
            ctor_scripts(0x30000000u, OBJ_VA, cases[k].init, cases[k].wait, cases[k].resume);
            g_clear_at = cases[k].at;
            g_effect = clear_self_at_call;
            CK(m4497a0_construct(fx.self, 5, NAME_VA, 0x1388, cases[k].flags, &fx.w, &fx.host) == NULL);
            CK(get32(fx.self, 0x36) == 0);
        }
    }
}

/*TESTS*/

/* ---- sweep (for the sanitiser builds) -------------------------------------------------------------------------------------------- */

static uint32_t rng_state = 0x1234567u;
static uint32_t rnd(void)
{
    rng_state = rng_state * 1664525u + 1013904223u;
    return rng_state >> 8;
}

static void test_sweep_bounded(void)
{
    int i;
    for (i = 0; i < 300; i++) {
        uint32_t results[1];
        size_t b;
        setup();
        ctor_object();
        for (b = 0; b < 0x3f; b++) fx.name[b] = (uint8_t)(1 + rnd() % 255);
        fx.name[rnd() % 0x3f] = 0;
        results[0] = rnd() & 1 ? 0 : 0x30000000u;
        script(0x51dc43, 1, results);
        results[0] = rnd() & 1 ? 0 : OBJ_VA;
        script(0x524aff, 1, results);
        results[0] = rnd() % 3;
        script(0x51ed8c, 1, results);
        results[0] = rnd() % 3;
        script(0x52a2ac, 1, results);
        results[0] = rnd() % 3 == 0 ? 0xffffffffu : rnd() % 3;
        script(0x52a284, 1, results);
        fx.w.word_63a4cd = (int16_t)(rnd() % 3);
        (void)m4497a0_construct(fx.self, rnd(), NAME_VA, rnd(), rnd() % 3 == 0 ? 4 : rnd(), &fx.w, &fx.host);
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
    RUN(test_m4497a0_construct);
    /*RUNS*/
    RUN(test_sweep_bounded);
    return failures;
}
