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
#define FILE_VA 0x20040000u
#define DEST_VA 0x20050000u
#define SMALL_VA 0x80u
#define ARG_SZ 0x200
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
    uint8_t self[SELF_SZ], obj[OBJ_SZ], vt[0x100], name[0x200], arg[ARG_SZ], file[0x400], dest[0x400], big[0x38e0];
    Fl27cWorld w;
    Fl18Host host;
} fx;
static uint8_t exp_self[SELF_SZ], exp_obj[OBJ_SZ], exp_arg[ARG_SZ], exp_dest[0x400];

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
        uint8_t snap_arg[ARG_SZ];
        uint8_t snap_big[0x40];
        uint32_t w_63a58a;
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
        memcpy(L.c[i].snap_arg, fx.arg, ARG_SZ);
        memcpy(L.c[i].snap_big, fx.big + 0x38a0, 0x40);
        L.c[i].w_63a58a = fx.w.value_63a58a;
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
    if (a >= FILE_VA && a < FILE_VA + 0x400) return fx.file + (a - FILE_VA);
    if (a >= SMALL_VA && a < SMALL_VA + 0x400) return fx.file + (a - SMALL_VA);   /* the same file mapped at an address with one non-zero byte */
    if (a >= DEST_VA && a < DEST_VA + 0x400) return fx.dest + (a - DEST_VA);
    return NULL;
}

static void setup(void)
{
    size_t b;
    memset(fx.self, 0xA5, sizeof fx.self);
    for (b = 0; b < OBJ_SZ; b++) fx.obj[b] = (uint8_t)(b * 7 + 3);
    memset(fx.vt, 0x33, sizeof fx.vt);
    memset(fx.name, 0x44, sizeof fx.name);
    for (b = 0; b < ARG_SZ; b++) fx.arg[b] = (uint8_t)(b * 11 + 5);
    for (b = 0; b < 0x400; b++) {
        fx.file[b] = (uint8_t)(b * 3 + 1);
        fx.dest[b] = (uint8_t)(b * 13 + 7);
    }
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
    memcpy(exp_arg, fx.arg, sizeof exp_arg);
    memcpy(exp_dest, fx.dest, sizeof exp_dest);
}

static void expect_end_at(int line)
{
    if (!g_failed && (memcmp(exp_self, fx.self, sizeof exp_self) != 0 || memcmp(exp_obj, fx.obj, sizeof exp_obj) != 0 || memcmp(exp_arg, fx.arg, sizeof exp_arg) != 0 ||
                      memcmp(exp_dest, fx.dest, sizeof exp_dest) != 0)) {
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

/* ---- 0x414ceb -------------------------------------------------------------------------------------------------------------------- */

#define ARGP ((uintptr_t)fx.arg)

static void open_arg(const char *name, uint32_t pre)
{
    memcpy(fx.arg + 0x4d, name, strlen(name) + 1);
    memcpy(fx.arg + 0x151, "C:/movie/a.avf", 15);
    set32(fx.arg, 0x21, pre);
}

/* the header of the mapped file at FILE_VA + delta */
static void file_header(size_t delta, int sig_flip, uint16_t w10, uint16_t w12, uint16_t w15, uint16_t w17, uint16_t w19, uint8_t b1b)
{
    uint8_t *h = fx.file + delta;
    memcpy(h, "AVF WayneSikes", 15);
    if (sig_flip >= 0) h[sig_flip] ^= 0x20;
    set16(h, 0x10, w10);
    set16(h, 0x12, w12);
    set16(h, 0x15, w15);
    set16(h, 0x17, w17);
    set16(h, 0x19, w19);
    h[0x1b] = b1b;
    h[0x14] = 0xff;     /* a neighbouring byte that a wider read of the word at +0x12 would see */
}

static void map_scripts(uint32_t h, uint32_t m, uint32_t v, uint32_t a)
{
    script(0x52a2bc, 1, &h);
    script(0x52a2c0, 1, &m);
    script(0x52a2c4, 1, &v);
    script(0x51dc43, 1, &a);
}

/* the zero stores of 0x414ceb as the expectation */
static void exp_zeroed(void)
{
    uint32_t off;
    static const uint32_t zeros[] = {0x21, 0x31, 0x35, 0x39, 0x3d, 0x41, 0x25, 0x29, 0x2d, 0x49};
    for (off = 0; off < sizeof zeros / sizeof zeros[0]; off++) set32(exp_arg, zeros[off], 0);
    set32(exp_arg, 0x45, 0xffffffffu);
}

static void ck_report(int n, uint32_t message, uintptr_t text, uint32_t world_value_before)
{
    CKC(n, 0x42639d, 0x583979, message, text);
    CKC0(n + 1, 0x4c97b4, 0x5cf659);
    CK(L.c[n].w_63a58a == world_value_before);
    CK(L.c[n + 1].w_63a58a == 4);
}

static void test_m414ceb_open_map(void)
{
    unsigned k;
    /* the whole success path: header copy, the table copy (57 bytes: 14 dwords and a tail byte), [+0x41] = 7 * -2 * (0x47 >> 3) */
    setup();
    open_arg("movie.avf", 0);
    file_header(0, -1, 2, 0, 3, 7, (uint16_t)-2, 0x47);
    map_scripts(0x11, 0x22, FILE_VA, DEST_VA);
    fx.w.value_63a58a = 0x77;
    expect_begin();
    CK(m414ceb_open_map(fx.self, fx.arg, &fx.w, &fx.host) == 0);
    exp_zeroed();
    memcpy(exp_arg, fx.file, 0x21);
    set32(exp_arg, 0x21, DEST_VA);
    set32(exp_arg, 0x25, 0x11);
    set32(exp_arg, 0x29, 0x22);
    set32(exp_arg, 0x2d, FILE_VA);
    set32(exp_arg, 0x41, (uint32_t)(7 * -2 * 8));
    memcpy(exp_dest, fx.file + 0x21, 57);
    CKN(4);
    CKC(0, 0x52a2bc, 0, ARGP + 0x4d, 0x80000000u, 0, 0, 3, 0x8000000u, 0);
    CKC(1, 0x52a2c0, 0, 0x11, 0, 2, 0, 0, 0);
    CKC(2, 0x52a2c4, 0, 0x22, 4, 0, 0, 0);
    CKC(3, 0x51dc43, 0, 57);
    /* the zero stores happen before the first import, the handles are stored as they come */
    CK(get32(L.c[0].snap_arg, 0x45) == 0xffffffffu && get32(L.c[0].snap_arg, 0x25) == 0 && get32(L.c[0].snap_arg, 0x2d) == 0);
    CK(get32(L.c[1].snap_arg, 0x25) == 0x11 && get32(L.c[1].snap_arg, 0x29) == 0);
    CK(get32(L.c[2].snap_arg, 0x29) == 0x22 && get32(L.c[2].snap_arg, 0x2d) == 0);
    CK(get32(L.c[3].snap_arg, 0x2d) == FILE_VA && get32(L.c[3].snap_arg, 0x21) == 0 && get32(L.c[3].snap_arg, 0x41) == 0);
    CK(fx.w.value_63a58a == 0x77);
    expect_end();
    /* the same at an offset into the mapped view (the header and the table follow the address v) and for tails of 0, 1, 2, 3 bytes and no table at all */
    {
        static const uint16_t counts[] = {0, 1, 2, 3, 4, 5, 16};
        for (k = 0; k < sizeof counts / sizeof counts[0]; k++) {
            size_t delta = 3 * k;
            uint32_t n = counts[k] * 19u;
            setup();
            open_arg("a", 0);
            file_header(delta, -1, 2, 0, counts[k], 0x7fff, 0x8000, 0xff);
            map_scripts(0xfffffffe, 0x80000000u, FILE_VA + (uint32_t)delta, DEST_VA);
            expect_begin();
            CK(m414ceb_open_map(fx.self, fx.arg, &fx.w, &fx.host) == 0);
            exp_zeroed();
            memcpy(exp_arg, fx.file + delta, 0x21);
            set32(exp_arg, 0x21, DEST_VA);
            set32(exp_arg, 0x25, 0xfffffffe);
            set32(exp_arg, 0x29, 0x80000000u);
            set32(exp_arg, 0x2d, FILE_VA + (uint32_t)delta);
            set32(exp_arg, 0x41, (uint32_t)((int64_t)0x7fff * -32768 * 31));
            memcpy(exp_dest, fx.file + delta + 0x21, n);
            CKN(4);
            CKC(3, 0x51dc43, 0, n);
            expect_end();
        }
    }
    /* the first two reports: [+0x21] non-zero (any value, the dword) and an empty name; each ends with [0x63a58a] = 4 and the flow goes on to the import */
    for (k = 0; k < 4; k++) {
        static const uint32_t pre[] = {1, 0x100, 0x01000000u, 0x80000000u};
        setup();
        open_arg("", pre[k]);
        file_header(0, -1, 2, 0, 1, 1, 1, 8);
        map_scripts(0x11, 0x22, FILE_VA, DEST_VA);
        fx.w.value_63a58a = 9;
        expect_begin();
        CK(m414ceb_open_map(fx.self, fx.arg, &fx.w, &fx.host) == 0);
        exp_zeroed();
        memcpy(exp_arg, fx.file, 0x21);
        set32(exp_arg, 0x21, DEST_VA);
        set32(exp_arg, 0x25, 0x11);
        set32(exp_arg, 0x29, 0x22);
        set32(exp_arg, 0x2d, FILE_VA);
        set32(exp_arg, 0x41, 1);
        memcpy(exp_dest, fx.file + 0x21, 19);
        CKN(2 + 2 + 4);
        ck_report(0, 0x5418d0, ARGP + 0x151, 9);
        ck_report(2, 0x541900, ARGP + 0x151, 4);
        /* the first report sees the old [+0x21], the second the zeroed one */
        CK(get32(L.c[0].snap_arg, 0x21) == pre[k] && get32(L.c[2].snap_arg, 0x21) == 0 && get32(L.c[2].snap_arg, 0x45) == 0xffffffffu);
        CKC(4, 0x52a2bc, 0, ARGP + 0x4d, 0x80000000u, 0, 0, 3, 0x8000000u, 0);
        expect_end();
    }
    /* the empty name test: first byte zero (empty, even with a second non-zero byte), a one-character name (no report) */
    {
        static const struct { uint8_t b0, b1; int reported; } names[] = {{0, 0, 1}, {0, 'x', 1}, {'x', 0, 0}, {'x', 'y', 0}, {0x80, 0, 0}, {0xff, 0xff, 0}};
        for (k = 0; k < sizeof names / sizeof names[0]; k++) {
            setup();
            open_arg("", 0);
            fx.arg[0x4d] = names[k].b0;
            fx.arg[0x4e] = names[k].b1;
            fx.arg[0x4f] = 0;
            file_header(0, -1, 2, 0, 0, 1, 1, 8);
            map_scripts(0x11, 0x22, FILE_VA, DEST_VA);
            CK(m414ceb_open_map(fx.self, fx.arg, &fx.w, &fx.host) == 0);
            CKN(names[k].reported ? 6 : 4);
            if (names[k].reported) ck_report(0, 0x541900, ARGP + 0x151, 0);
            CKC(names[k].reported ? 2 : 0, 0x52a2bc, 0, ARGP + 0x4d, 0x80000000u, 0, 0, 3, 0x8000000u, 0);
        }
    }
    /* the three import failures end the function with the name as the text: CreateFile 0xffffffff, mapping 0, view 0 */
    for (k = 0; k < 3; k++) {
        static const uint32_t msg[] = {0x541924, 0x54193c, 0x54195c};
        setup();
        open_arg("n", 0);
        file_header(0, -1, 2, 0, 1, 1, 1, 8);
        map_scripts(k == 0 ? 0xffffffffu : 5, k == 1 ? 0 : 6, k == 2 ? 0 : FILE_VA, DEST_VA);
        fx.w.value_63a58a = 3;
        expect_begin();
        CK(m414ceb_open_map(fx.self, fx.arg, &fx.w, &fx.host) == 0);
        exp_zeroed();
        set32(exp_arg, 0x25, k == 0 ? 0xffffffffu : 5);
        if (k >= 1) set32(exp_arg, 0x29, k == 1 ? 0 : 6);
        if (k == 2) set32(exp_arg, 0x2d, 0);
        CKN((int)k + 1 + 2);
        ck_report((int)k + 1, msg[k], ARGP + 0x4d, 3);
        expect_end();
        CK(fx.w.value_63a58a == 4);
    }
    /* a file handle of 0, 1, 0x80000000 or 0xfffffffe is valid; only 0xffffffff is the failure value */
    {
        static const uint32_t ok_handles[] = {0, 1, 0x80000000u, 0xfffffffeu};
        for (k = 0; k < 4; k++) {
            setup();
            open_arg("n", 0);
            file_header(0, -1, 2, 0, 0, 1, 1, 8);
            map_scripts(ok_handles[k], 1, FILE_VA, DEST_VA);
            CK(m414ceb_open_map(fx.self, fx.arg, &fx.w, &fx.host) == 0);
            CKN(4);
            CK(get32(fx.arg, 0x25) == ok_handles[k]);
        }
    }
    /* the header: every one of the 15 signature bytes (the terminator too), the word at +0x10 (2 only), the word at +0x12 (0 only); the bytes next to them do not count */
    for (k = 0; k < 15 + 5 + 4 + 2; k++) {
        static const uint16_t w10[] = {0, 1, 3, 0x102, 0x200};
        static const uint16_t w12[] = {1, 0x100, 0x101, 0xffff};
        int flip = k < 15 ? (int)k : -1;
        uint16_t a = 2, b = 0;
        int should_pass = 0;
        if (k >= 15 && k < 20) a = w10[k - 15];
        if (k >= 20 && k < 24) b = w12[k - 20];
        if (k >= 24) should_pass = 1;
        setup();
        open_arg("n", 0);
        file_header(0, flip, a, b, 1, 1, 1, 8);
        if (k == 24) fx.file[0xf] ^= 0xff;        /* the byte between the signature and the words is not compared */
        if (k == 25) fx.file[0x20] ^= 0xff;       /* nor the last header byte */
        map_scripts(0x11, 0x22, FILE_VA, DEST_VA);
        expect_begin();
        CK(m414ceb_open_map(fx.self, fx.arg, &fx.w, &fx.host) == 0);
        exp_zeroed();
        memcpy(exp_arg, fx.file, 0x21);
        set32(exp_arg, 0x25, 0x11);
        set32(exp_arg, 0x29, 0x22);
        set32(exp_arg, 0x2d, FILE_VA);
        if (should_pass) {
            set32(exp_arg, 0x21, DEST_VA);
            set32(exp_arg, 0x41, 1);
            memcpy(exp_dest, fx.file + 0x21, 19);
            CKN(4);
        } else {
            CKN(3 + 1 + 2);
            CKC(3, 0x415011, SELFP, ARGP);
            ck_report(4, 0x541988, ARGP + 0x4d, 0);
            CK(L.c[3].w_63a58a == 0);
        }
        expect_end();
    }
    /* the allocation fails: 0x415011 then the report with the two constants; the count is the signed word times 0x13 in 32 bits (-1 -> 0xffffffed, 0x7fff, -0x8000) */
    {
        static const struct { uint16_t w; uint32_t n; } fails[] = {{0, 0}, {1, 19}, {0xffff, 0xffffffedu}, {0x7fff, 0x7fffu * 19u}, {0x8000, (uint32_t)(-32768 * 19)}};
        for (k = 0; k < sizeof fails / sizeof fails[0]; k++) {
            setup();
            open_arg("n", 0);
            file_header(0, -1, 2, 0, fails[k].w, 5, 5, 8);
            map_scripts(0x11, 0x22, FILE_VA, 0);
            expect_begin();
            CK(m414ceb_open_map(fx.self, fx.arg, &fx.w, &fx.host) == 0);
            exp_zeroed();
            memcpy(exp_arg, fx.file, 0x21);
            set32(exp_arg, 0x25, 0x11);
            set32(exp_arg, 0x29, 0x22);
            set32(exp_arg, 0x2d, FILE_VA);
            CKN(4 + 1 + 2);
            CKC(3, 0x51dc43, 0, fails[k].n);
            CKC(4, 0x415011, SELFP, ARGP);
            ck_report(5, 0x5419ec, 0x5419dc, 0);
            expect_end();
        }
    }
    /* a view address whose only non-zero byte is the lowest one (0x80): the dword at +0x2d is non-zero, a read of the dword at +0x2e would be zero */
    setup();
    open_arg("n", 0);
    file_header(0, -1, 2, 0, 1, 3, 3, 0x10);
    map_scripts(0x11, 0x22, SMALL_VA, DEST_VA);
    expect_begin();
    CK(m414ceb_open_map(fx.self, fx.arg, &fx.w, &fx.host) == 0);
    exp_zeroed();
    memcpy(exp_arg, fx.file, 0x21);
    set32(exp_arg, 0x21, DEST_VA);
    set32(exp_arg, 0x25, 0x11);
    set32(exp_arg, 0x29, 0x22);
    set32(exp_arg, 0x2d, SMALL_VA);
    set32(exp_arg, 0x41, 3 * 3 * 2);
    memcpy(exp_dest, fx.file + 0x21, 19);
    CKN(4);
    expect_end();
    /* native rejection: a negative word with a successful allocation would copy 4 GB; the function returns 1 after storing [+0x21] and copies nothing */
    setup();
    open_arg("n", 0);
    file_header(0, -1, 2, 0, 0xffff, 5, 5, 8);
    map_scripts(0x11, 0x22, FILE_VA, DEST_VA);
    expect_begin();
    CK(m414ceb_open_map(fx.self, fx.arg, &fx.w, &fx.host) == 1);
    exp_zeroed();
    memcpy(exp_arg, fx.file, 0x21);
    set32(exp_arg, 0x21, DEST_VA);
    set32(exp_arg, 0x25, 0x11);
    set32(exp_arg, 0x29, 0x22);
    set32(exp_arg, 0x2d, FILE_VA);
    CKN(4);
    expect_end();
}

/* ---- 0x4c2e97 -------------------------------------------------------------------------------------------------------------------- */

#define BIG_SZ 0x38e0
#define big fx.big
static uint8_t exp_big[BIG_SZ];

/* the descriptor the method is to fill: the effect hook copies what the original passes (zeroed, size and flags) and then stores these */
static struct {
    uint32_t hr;
    uint32_t m[3], bpp, flags;
    uint8_t seen[0x7c];
    uintptr_t seen_ptr;
    int called;
} DS;

static void desc_effect(int i, uint32_t callee, const uintptr_t *args)
{
    (void)i;
    if (callee == VT_STUB_B) {
        uint8_t *d = (uint8_t *)args[1];
        memcpy(DS.seen, d, 0x7c);
        DS.seen_ptr = args[1];
        DS.called++;
        if (DS.hr == 0) {
            set32(d, 0x58, DS.m[0]);
            set32(d, 0x5c, DS.m[1]);
            set32(d, 0x60, DS.m[2]);
            set32(d, 0x54, DS.bpp);
            set32(d, 0x4c, DS.flags);
        }
    }
}

static void pf_setup(uint32_t hr, uint32_t m0, uint32_t m1, uint32_t m2, uint32_t bpp, uint32_t flags, uint8_t g57, uint8_t g58, uint8_t g59)
{
    size_t b;
    setup();
    ctor_object();
    set32(fx.vt, 0x58, VT_STUB_B);
    for (b = 0; b < BIG_SZ; b++) big[b] = (uint8_t)(b * 5 + 1);
    memset(&DS, 0, sizeof DS);
    DS.hr = hr;
    DS.m[0] = m0;
    DS.m[1] = m1;
    DS.m[2] = m2;
    DS.bpp = bpp;
    DS.flags = flags;
    script(VT_STUB_B, 1, &hr);
    g_effect = desc_effect;
    fx.w.byte_5b0257 = g57;
    fx.w.byte_5b0258 = g58;
    fx.w.byte_5b0259 = g59;
    memcpy(exp_big, big, BIG_SZ);
    expect_begin();
}

static void pf_end(int line)
{
    if (!g_failed && memcmp(exp_big, big, BIG_SZ) != 0) {
        g_failed = 1;
        snprintf(g_msg, sizeof g_msg, "line %d: the object differs from the expected copy", line);
    }
    expect_end_at(line);
}

static void ck_desc_sent(void)
{
    size_t b;
    CK(DS.called == 1);
    CK(get32(DS.seen, 0) == 0x7c && get32(DS.seen, 4) == 0x1000);
    for (b = 8; b < 0x7c; b++) CK(DS.seen[b] == 0);
}

typedef struct PfRow {
    uint32_t m[3];
    uint8_t g[3];
    uint8_t cnt[3], byte[3], kind[3], gout[3];
    uint16_t word;
    uint32_t a8;
} PfRow;

static const PfRow PFROWS[] = {
    {{0xf800, 0x07e0, 0x001f}, {0xff, 0xff, 0xff}, {11, 5, 0}, {0x1f, 0x3f, 0x1f}, {5, 6, 5}, {0x1f, 0x7e, 0x1f}, 0xffdf, 1},
    {{0x7c00, 0x03e0, 0x001f}, {0xff, 0xff, 0xff}, {10, 5, 0}, {0x1f, 0x1f, 0x1f}, {5, 5, 5}, {0x1f, 0x1f, 0x1f}, 0x7fff, 0},
    {{0xff0000, 0xff00, 0xff}, {0xff, 0xff, 0xff}, {16, 8, 0}, {0xff, 0xff, 0xff}, {6, 6, 6}, {0xfe, 0xfe, 0xfe}, 0xfefe, 1},
    {{0x001f, 0x07e0, 0xf800}, {0x55, 0xaa, 0x0f}, {0, 5, 11}, {0x1f, 0x3f, 0x1f}, {5, 6, 5}, {0x15, 0x54, 0x0f}, 0x7a95, 1},
    {{0x80000000u, 0x70, 1}, {0x81, 0xff, 0x03}, {31, 4, 0}, {1, 7, 1}, {6, 6, 6}, {2, 0xe, 2}, 0x00e2, 1},
    {{0x11f, 0x83e0, 0xf8000000u}, {0xf0, 0x0f, 0xff}, {0, 5, 27}, {0x1f, 0x1f, 0x1f}, {6, 6, 5}, {0x20, 0x1e, 0x1f}, 0x03e0, 1},
    {{0x3e, 0x7c0, 0x1f}, {0x1f, 0x1f, 0x1f}, {1, 6, 0}, {0x1f, 0x1f, 0x1f}, {5, 5, 5}, {0x1f, 0x1f, 0x1f}, 0x07ff, 0},
    {{0xff, 0xff00, 0xff0000}, {0x80, 0xc0, 0x7f}, {0, 8, 16}, {0xff, 0xff, 0xff}, {6, 6, 6}, {0x00, 0x80, 0xfe}, 0x8000, 1},
};

static void exp_pf_rows(const PfRow *r)
{
    static const uint32_t cnt_off[3] = {0x38c2, 0x38c1, 0x38c0}, byte_off[3] = {0x38c6, 0x38c5, 0x38c4}, kind_off[3] = {0x38ca, 0x38c9, 0x38c8};
    int i;
    for (i = 0; i < 3; i++) {
        exp_big[cnt_off[i]] = r->cnt[i];
        exp_big[byte_off[i]] = r->byte[i];
        exp_big[kind_off[i]] = r->kind[i];
    }
    set16(exp_big, 0x38d0, r->word);
    exp_big[0x38d2] = (uint8_t)(r->word & 0xff);
    exp_big[0x38d3] = (uint8_t)(r->word >> 8);
    set32(exp_big, 0x38a8, r->a8);
}

static void test_m4c2e97_read_pixel_format(void)
{
    unsigned k, j;
    /* the rows: masks, the three byte globals, the stored counts, mask bytes and kinds, the globals afterwards, the word, the flag dword */
    for (k = 0; k < sizeof PFROWS / sizeof PFROWS[0]; k++) {
        const PfRow *r = &PFROWS[k];
        pf_setup(0, r->m[0], r->m[1], r->m[2], 0, 0, r->g[0], r->g[1], r->g[2]);
        CK(m4c2e97_read_pixel_format(big, OBJ_VA, &fx.w, &fx.host) == 1);
        exp_pf_rows(r);
        CK(fx.w.byte_5b0257 == r->gout[0] && fx.w.byte_5b0258 == r->gout[1] && fx.w.byte_5b0259 == r->gout[2]);
        CKN(1);
        CKC(0, VT_STUB_B, OBJ_VA, OBJ_VA, DS.seen_ptr);
        CK(DS.seen_ptr > 0xffffffffu || sizeof(void *) == 4);
        ck_desc_sent();
        pf_end(__LINE__);
    }
    /* a failing method: the report with the converted code, nothing else happens (the globals and the object stay) */
    for (k = 0; k < 4; k++) {
        static const uint32_t hrs[] = {1, 0x80004005u, 0xffffffffu, 0x100};
        uint32_t text = 0x1234 + k;
        pf_setup(hrs[k], 1, 2, 4, 0, 0, 0xaa, 0xbb, 0xcc);
        script(0x4c88c7, 1, &text);
        CK(m4c2e97_read_pixel_format(big, OBJ_VA, &fx.w, &fx.host) == 0);
        CKN(3);
        CKC(0, VT_STUB_B, OBJ_VA, OBJ_VA, DS.seen_ptr);
        CKC(1, 0x4c88c7, (uintptr_t)big, hrs[k]);
        CKC(2, 0x42639d, 0x583979, 0x553f14, text);
        CK(fx.w.byte_5b0257 == 0xaa && fx.w.byte_5b0258 == 0xbb && fx.w.byte_5b0259 == 0xcc);
        ck_desc_sent();
        pf_end(__LINE__);
    }
    /* the debug trace: row 0 (565) with a bit depth in the descriptor: the 16 arguments in order, then the format check calls for the flag bits 2, 0x20, 0x40, 0x400 (other bits ignored) */
    for (k = 0; k < 16 + 5; k++) {
        static const int16_t on[] = {0, 1, 0x100, -32768, -1};
        uint32_t flags = (0x03030000u | 0x1b0) & ~(2u | 0x20 | 0x40 | 0x400);
        int want[4], nwant = 0, q;
        static const uint32_t strs[4] = {0x55400c, 0x55403c, 0x554074, 0x5540a0}, bits[4] = {2, 0x20, 0x40, 0x400};
        const PfRow *r = &PFROWS[0];
        int dbg_on = k >= 16 ? on[k - 16] != 0 : 1;
        pf_setup(0, r->m[0], r->m[1], r->m[2], 0x12345678u, 0, r->g[0], r->g[1], r->g[2]);
        if (k < 16) {
            for (q = 0; q < 4; q++)
                if ((k >> q) & 1) flags |= bits[q];
            fx.w.word_63a4cd = 1;
        } else {
            fx.w.word_63a4cd = on[k - 16];
            flags |= 2 | 0x20 | 0x40 | 0x400;
        }
        DS.flags = flags;
        CK(m4c2e97_read_pixel_format(big, OBJ_VA, &fx.w, &fx.host) == 1);
        exp_pf_rows(r);
        for (q = 0; q < 4; q++)
            if (dbg_on && (flags & bits[q])) want[nwant++] = q;
        CKN(1 + (dbg_on ? 2 + nwant : 0));
        if (dbg_on) {
            const uintptr_t t[] = {0x63888b, 0x553f30, 11, 0x1f, 5, 5, 0x3f, 6, 0, 0x1f, 5, 1, 0xffdf, 0xff, 0xdf, 0x12345678u};
            ck_call_at(__LINE__, 1, 0x50ca3e, 0, 16, t);
            CKC(2, 0x44a2b7, 0, 0x63888b);
            for (q = 0; q < nwant; q++) CKC(3 + q, 0x44a2b7, 0, strs[want[q]]);
            /* the trace sees the finished object and globals */
            CK(get32(L.c[1].snap_big, 8) == 1 && get16(L.c[1].snap_big, 0x30) == 0xffdf);
        }
        pf_end(__LINE__);
    }
    /* the kind test is on the whole shifted dword (0x1f), not on its low byte: 0x11f and 0x83e0 are kind 6 with the mask byte 0x1f (rows 5) */
    /* native rejection: a zero mask never ends the original's shift loop; the masks before it are stored, nothing after */
    for (k = 0; k < 3; k++) {
        uint32_t m[3] = {0xf800, 0x07e0, 0x001f};
        m[k] = 0;
        pf_setup(0, m[0], m[1], m[2], 0, 0, 0xff, 0xff, 0xff);
        CK(m4c2e97_read_pixel_format(big, OBJ_VA, &fx.w, &fx.host) == 2);
        if (k >= 1) {
            exp_big[0x38c2] = 11;
            exp_big[0x38c6] = 0x1f;
            exp_big[0x38ca] = 5;
        }
        if (k >= 2) {
            exp_big[0x38c1] = 5;
            exp_big[0x38c5] = 0x3f;
            exp_big[0x38c9] = 6;
        }
        CK(fx.w.byte_5b0257 == 0xff && fx.w.byte_5b0258 == 0xff && fx.w.byte_5b0259 == 0xff);
        CKN(1);
        pf_end(__LINE__);
    }
    /* every single-bit red mask (count = the bit number, the shifted mask 1 is kind 6 with the byte 1); green and blue stay 0x1f */
    for (j = 0; j < 32; j++) {
        pf_setup(0, 1u << j, 0x1f, 0x1f, 0, 0, 0xff, 0xff, 0xff);
        CK(m4c2e97_read_pixel_format(big, OBJ_VA, &fx.w, &fx.host) == 1);
        CK(big[0x38c2] == j && big[0x38c6] == 1 && big[0x38ca] == 6);
        CK(big[0x38c1] == 0 && big[0x38c5] == 0x1f && big[0x38c9] == 5 && big[0x38c0] == 0 && big[0x38c4] == 0x1f && big[0x38c8] == 5);
        CK(fx.w.byte_5b0257 == 2 && fx.w.byte_5b0258 == 0x1f && fx.w.byte_5b0259 == 0x1f);
        CK(get32(big, 0x38a8) == 1);
        CK(get16(big, 0x38d0) == (uint16_t)((2u << j) | (0x1fu) | (0x1fu)));
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
    for (i = 0; i < 300; i++) {
        uint32_t h = rnd() % 4 == 0 ? 0xffffffffu : rnd(), m = rnd() % 4 == 0 ? 0 : rnd(), v = rnd() % 4 == 0 ? 0 : FILE_VA, a = rnd() % 4 == 0 ? 0 : DEST_VA;
        setup();
        file_header(0, rnd() % 5 == 0 ? (int)(rnd() % 15) : -1, rnd() % 5 == 0 ? (uint16_t)rnd() : 2, rnd() % 5 == 0 ? (uint16_t)rnd() : 0, (uint16_t)(rnd() % 17), (uint16_t)rnd(), (uint16_t)rnd(), (uint8_t)rnd());
        open_arg(rnd() % 4 == 0 ? "" : "nm", rnd() % 3 == 0 ? rnd() : 0);
        map_scripts(h, m, v, a);
        (void)m414ceb_open_map(fx.self, fx.arg, &fx.w, &fx.host);
    }
    for (i = 0; i < 300; i++) {
        uint32_t m0 = rnd() % 16 == 0 ? 0 : (rnd() << 8) ^ rnd(), m1 = rnd() % 16 == 0 ? 0 : rnd() << (rnd() % 24), m2 = rnd() % 16 == 0 ? 0 : (rnd() >> 3) << (rnd() % 16);
        pf_setup(rnd() % 8 == 0 ? rnd() | 1 : 0, m0, m1, m2, rnd(), rnd(), (uint8_t)rnd(), (uint8_t)rnd(), (uint8_t)rnd());
        fx.w.word_63a4cd = (int16_t)(rnd() % 3);
        (void)m4c2e97_read_pixel_format(big, OBJ_VA, &fx.w, &fx.host);
    }
    /*SWEEPS*/
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
    RUN(test_m414ceb_open_map);
    RUN(test_m4c2e97_read_pixel_format);
    /*RUNS*/
    RUN(test_sweep_bounded);
    return failures;
}
