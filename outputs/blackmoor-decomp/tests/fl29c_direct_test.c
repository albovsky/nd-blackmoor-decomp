/* FL-29 (batch c) direct tests of the ten methods of GAME.EXE in src/original_methods_fl29c.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the failure
 * count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl29c_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl29c.h"

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

static uint32_t get32(const uint8_t *o, size_t off) { uint32_t v; memcpy(&v, o + off, 4); return v; }
static uint16_t get16(const uint8_t *o, size_t off) { uint16_t v; memcpy(&v, o + off, 2); return v; }
static void set32(uint8_t *o, size_t off, uint32_t v) { memcpy(o + off, &v, 4); }
static void set16(uint8_t *o, size_t off, uint16_t v) { memcpy(o + off, &v, 2); }

/* the host: a log of the calls, scripted results per callee, and the memory behind original addresses */
#define MAXCALL 4096
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[6];
    } c[MAXCALL];
} L;
static struct {
    uint32_t callee;
    uint32_t results[1100];
    int n, used;
} S[8];
static int g_nscript;
static void script(uint32_t callee, int n, const uint32_t *results)
{
    int i;
    S[g_nscript].callee = callee;
    S[g_nscript].n = n;
    S[g_nscript].used = 0;
    for (i = 0; i < n; i++) S[g_nscript].results[i] = results[i];
    g_nscript++;
}
static struct {
    uint32_t va;
    uint8_t *ptr;
    uint32_t len;
} R[8];
static int g_nregion;
static void region(uint32_t va, uint8_t *ptr, uint32_t len)
{
    R[g_nregion].va = va;
    R[g_nregion].ptr = ptr;
    R[g_nregion].len = len;
    g_nregion++;
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
        for (k = 0; k < nargs && k < 6; k++) L.c[i].a[k] = args[k];
        L.n++;
    }
    for (k = 0; k < g_nscript; k++)
        if (S[k].callee == callee) {
            result = S[k].results[S[k].used < S[k].n ? S[k].used : S[k].n - 1];
            S[k].used++;
        }
    return result;
}

static const uint8_t *host_resolve(void *ctx, uint32_t address)
{
    int i;
    (void)ctx;
    for (i = 0; i < g_nregion; i++)
        if (address >= R[i].va && address < R[i].va + R[i].len) return R[i].ptr + (address - R[i].va);
    return NULL;
}

static Fl18Host g_host;
static Fl29cWorld g_w;

static void reset(void)
{
    memset(&L, 0, sizeof L);
    memset(S, 0, sizeof S);
    g_nscript = 0;
    g_nregion = 0;
    memset(&g_w, 0, sizeof g_w);
    memset(&g_host, 0, sizeof g_host);
    g_host.call = host_call;
    g_host.resolve = host_resolve;
}

/* ---- 0x4bf19a ---- */
static void test_m4bf19a_bink_goto(void)
{
    static uint8_t self[0x300], handle[0x20];
    uint32_t r;
    reset();
    /* no handle: the thiscall 0x4bf38c(self), then [self+0x2c0] = 0xfffffffd and 0 (nothing else) */
    r = m4bf19a_bink_goto(self, NULL, 5, &g_host);
    CK(r == 0 && get32(self, 0x2c0) == 0xfffffffdu);
    CK(L.n == 1 && L.c[0].callee == 0x4bf38c && L.c[0].this_ptr == (uintptr_t)self && L.c[0].nargs == 0);
    /* frame below 1 (signed): 0 without the import, and the word stays */
    set32(self, 0x2c0, 7);
    set32(handle, 8, 10);
    reset();
    CK(m4bf19a_bink_goto(self, handle, 0, &g_host) == 0 && m4bf19a_bink_goto(self, handle, 0xffffffffu, &g_host) == 0 && L.n == 2);
    CK(get32(self, 0x2c0) == 7);
    /* frame above the count (unsigned): 0 */
    reset();
    CK(m4bf19a_bink_goto(self, handle, 11, &g_host) == 0 && L.n == 1);
    /* frame == count: the import _BinkGoto(handle, frame, 0), result 1 */
    reset();
    CK(m4bf19a_bink_goto(self, handle, 10, &g_host) == 1);
    CK(L.n == 2 && L.c[1].callee == 0x52a530 && L.c[1].nargs == 3 && L.c[1].a[0] == (uintptr_t)handle && L.c[1].a[1] == 10 && L.c[1].a[2] == 0);
    /* the count 0x80000000 is large when compared unsigned */
    set32(handle, 8, 0x80000000u);
    reset();
    CK(m4bf19a_bink_goto(self, handle, 1, &g_host) == 1 && L.n == 2);
    reset();
    CK(m4bf19a_bink_goto(self, handle, 0x80000001u, &g_host) == 0 && L.n == 1);
    if (!g_failed) g_msg[0] = 0;
}

/* ---- 0x434814 ---- */
static void test_m434814_copy_name(void)
{
    uint8_t buf[8];
    uint32_t r;
    static const uint8_t two[] = {'a', 'b', 0, 'x', 'y'}, six[] = {'a', 'b', 'c', 'd', 'e', 'f', 0}, high[] = {0xff, 0x80, 0, 'z'}, none[] = {0, 'q'}, four[] = {'w', 'x', 'y', 'z', 'v', 0};
    reset();
    g_w.buf_63a590 = buf;
    memset(buf, 0x55, sizeof buf);
    r = m434814_copy_name(two, &g_w);
    CK(r == 0x63a590 && buf[0] == 'a' && buf[1] == 'b' && buf[2] == 0 && buf[3] == 0x55 && buf[4] == 0x55);
    memset(buf, 0x55, sizeof buf);
    CK(m434814_copy_name(six, &g_w) == 0x63a590 && memcmp(buf, "abcd\0\x55", 6) == 0);      /* four bytes copied, the terminator at 4 */
    memset(buf, 0x55, sizeof buf);
    m434814_copy_name(four, &g_w);
    CK(memcmp(buf, "wxyz\0\x55", 6) == 0);
    memset(buf, 0x55, sizeof buf);
    m434814_copy_name(high, &g_w);          /* bytes 0xff and 0x80 are non-zero when sign-extended */
    CK(buf[0] == 0xff && buf[1] == 0x80 && buf[2] == 0 && buf[3] == 0x55);
    memset(buf, 0x55, sizeof buf);
    m434814_copy_name(none, &g_w);
    CK(buf[0] == 0 && buf[1] == 0x55);
    if (!g_failed) g_msg[0] = 0;
}

/* ---- 0x4471ca, 0x45b4ae, 0x461903, 0x4b5c5c ---- */
typedef void (*CopyFn)(uint8_t *, uint8_t *, uint8_t *, const Fl29cWorld *, const Fl18Host *);

static void check_copy(CopyFn fn, uint32_t size, uint32_t fmt, uint32_t msg, uint32_t trace)
{
    static uint8_t cells[16], src[0xc00], dst[0xc00], nullpage[0xc00];
    uint32_t k, res;
    for (k = 0; k < sizeof src; k++) src[k] = (uint8_t)(k * 7 + 3);
    /* allocation succeeds, no debug: malloc(size); [a] = p; the bytes copied; [c] += size, [b] += size (nothing else) */
    reset();
    memset(dst, 0, sizeof dst);
    region(0x20010000u, src, sizeof src);
    region(0x20020000u, dst, sizeof dst);
    region(0x20030000u, cells, sizeof cells);
    set32(cells, 0, 0xabcdu);
    set32(cells, 4, 0x20010000u);
    set32(cells, 8, 0x1000u);
    res = 0x20020000u;
    script(0x51dc43, 1, &res);
    fn(cells, cells + 4, cells + 8, &g_w, &g_host);
    CK(L.n == 1 && L.c[0].callee == 0x51dc43 && L.c[0].nargs == 1 && L.c[0].a[0] == size);
    CK(get32(cells, 0) == 0x20020000u && get32(cells, 4) == 0x20010000u + size && get32(cells, 8) == 0x1000u + size);
    CK(memcmp(dst, src, size) == 0 && dst[size] == 0);
    /* the debug word: the trace call comes last, after the cells have advanced */
    reset();
    memset(dst, 0, sizeof dst);
    region(0x20010000u, src, sizeof src);
    region(0x20020000u, dst, sizeof dst);
    region(0x20030000u, cells, sizeof cells);
    set32(cells, 4, 0x20010000u);
    script(0x51dc43, 1, &res);
    g_w.word_63a4cd = 0x100;
    fn(cells, cells + 4, cells + 8, &g_w, &g_host);
    CK(L.n == 2 && L.c[1].callee == 0x44a2b7 && L.c[1].nargs == 1 && L.c[1].a[0] == trace);
    /* c aliasing b: the cell advances twice */
    reset();
    memset(dst, 0, sizeof dst);
    region(0x20010000u, src, sizeof src);
    region(0x20020000u, dst, sizeof dst);
    set32(cells, 4, 0x20010000u);
    script(0x51dc43, 1, &res);
    fn(cells, cells + 4, cells + 4, &g_w, &g_host);
    CK(get32(cells, 4) == 0x20010000u + 2 * size);
    /* allocation fails (0): the report calls, then the copy goes to the address 0 (here a scratch page the host maps; a host without it makes the port return) */
    reset();
    memset(nullpage, 0, sizeof nullpage);
    region(0x20010000u, src, sizeof src);
    region(0u, nullpage, sizeof nullpage);
    set32(cells, 0, 0x1234u);
    set32(cells, 4, 0x20010000u);
    set32(cells, 8, 0u);
    g_w.word_5c39e3 = -3;
    g_w.value_5bb57b = 0xdeadbeefu;
    res = 0;
    script(0x51dc43, 1, &res);
    fn(cells, cells + 4, cells + 8, &g_w, &g_host);
    CK(L.n == 4 && L.c[0].callee == 0x51dc43 && L.c[1].callee == 0x50ca3e && L.c[1].nargs == 4);
    CK(L.c[1].a[0] == 0x63888b && L.c[1].a[1] == fmt && L.c[1].a[2] == 0xdeadbeefu && L.c[1].a[3] == 0xfffffffdu);
    CK(L.c[2].callee == 0x42639d && L.c[2].this_ptr == 0x583979 && L.c[2].nargs == 2 && L.c[2].a[0] == msg && L.c[2].a[1] == 0x63888b);
    CK(L.c[3].callee == 0x4c97b4 && L.c[3].this_ptr == 0x5cf659 && L.c[3].nargs == 0);
    CK(get32(cells, 0) == 0 && memcmp(nullpage, src, size) == 0 && get32(cells, 8) == size);
    /* the same without the scratch page: the port rejects (no copy, no advance) */
    reset();
    region(0x20010000u, src, sizeof src);
    set32(cells, 4, 0x20010000u);
    set32(cells, 8, 0u);
    script(0x51dc43, 1, &res);
    fn(cells, cells + 4, cells + 8, &g_w, &g_host);
    CK(get32(cells, 0) == 0 && get32(cells, 4) == 0x20010000u && get32(cells, 8) == 0 && L.n == 4);
}

static void test_m4471ca_copy_record15(void)
{
    check_copy(m4471ca_copy_record15, 0x15, 0x548450, 0x54847c, 0x548498);
    if (!g_failed) g_msg[0] = 0;
}

static void test_m45b4ae_copy_record_b8e(void)
{
    check_copy(m45b4ae_copy_record_b8e, 0xb8e, 0x54aae4, 0x54ab10, 0x54ab2c);
    if (!g_failed) g_msg[0] = 0;
}

static void test_m461903_copy_record_357(void)
{
    check_copy(m461903_copy_record_357, 0x357, 0x54b0dc, 0x54b108, 0x54b124);
    if (!g_failed) g_msg[0] = 0;
}

static void test_m4b5c5c_copy_record_39f(void)
{
    check_copy(m4b5c5c_copy_record_39f, 0x39f, 0x551a9c, 0x551ac8, 0x551ae4);
    if (!g_failed) g_msg[0] = 0;
}

/* ---- 0x45bbd8 ---- */
static void test_m45bbd8_roll_rects(void)
{
    static uint8_t selfm[0x400], rec[0x500], records[3 * 0x8d];
    uint8_t *self = selfm + 0x200;
    uint32_t k, r;
    /* rolls (two per pass): 1,2 | 0x80000001,0x80000003 | 3,3 | 2,0x80000000.
     * pass 0: w2 = 1 (count 1), w4 = 2 -> source rec+0x36d+64+16 -> self+0x36+arg*64+0
     * pass 1: 0x80000001 -> dec 0x80000000, or 0xfffffffe, inc -> -1 ; 0x80000003 -> dec 0x80000002, or 0xfffffffc = 0xfffffffe, inc -> -1: source rec+0x36d-32-16
     * pass 2: w2 = 3 & 1 = 1 (count 2), w4 = 3 -> rec+0x36d+96+16 ; pass 3: w2 = 0, 0x80000000 -> dec 0x7fffffff, or -> 0xffffffff, inc -> 0: rec+0x36d */
    static const uint32_t rolls[8] = {1, 2, 0x80000001u, 0x80000003u, 3, 3, 2, 0x80000000u};
    static const int srcoff[4] = {0x36d + 64 + 16, 0x36d - 32 - 16, 0x36d + 96 + 16, 0x36d};
    reset();
    for (k = 0; k < sizeof rec; k++) rec[k] = (uint8_t)(k * 5 + 1);
    memset(selfm, 0xee, sizeof selfm);
    memset(records, 0, sizeof records);
    set16(self, 0x1e, 1);
    set32(records, 0x8d + 0x8d, 0x20010000u);     /* record 1, with records_5bb5e5 pointing at the record 0 */
    g_w.records_5bb5e5 = records + 0x8d;
    region(0x20010000u, rec, sizeof rec);
    script(0x50cd50, 8, rolls);
    r = m45bbd8_roll_rects(self, 0xabcd0001u, &g_w, &g_host);        /* the word argument is 1: the upper half is left-over */
    CK((r & 0xffff) == 2);
    CK(L.n == 8 && L.c[0].callee == 0x50cd50 && L.c[0].nargs == 0);
    for (k = 0; k < 4; k++) CK(memcmp(self + 0x36 + 64 + 16 * k, rec + srcoff[k], 16) == 0);
    CK(self[0x36 + 64 - 1] == 0xee && self[0x36 + 64 + 64] == 0xee);
    /* no roll is 1 (word values 0, -1 and 2): count 0 gives 5; a negative word argument moves the destination down */
    {
        static const uint32_t none[2] = {2, 0x80000001u};
        reset();
        memset(selfm, 0xee, sizeof selfm);
        set16(self, 0x1e, 0);
        memset(records, 0, sizeof records);
        set32(records, 0x8d, 0x20010000u);
        g_w.records_5bb5e5 = records + 0x8d;
        region(0x20010000u, rec, sizeof rec);
        script(0x50cd50, 2, none);
        r = m45bbd8_roll_rects(self, 0xffffu, &g_w, &g_host);         /* arg = -1 */
        CK((r & 0xffff) == 5);
        /* pass 0: w2 = 0, w4 = -3 (0x80000001 & 0x80000003 = 0x80000001: dec, or 0xfffffffc, inc = 0xfffffffd); the later passes repeat the last roll: w2 = -1 */
        CK(memcmp(self + 0x36 - 64, rec + 0x36d - 96, 16) == 0 && memcmp(self + 0x36 - 64 + 16, rec + 0x36d - 96 - 16, 16) == 0);
        CK(self[0x36 - 64 - 1] == 0xee && self[0x36 - 64 + 64] == 0xee);
    }
    if (!g_failed) g_msg[0] = 0;
}

/* ---- 0x4630a3 ---- */
static void test_m4630a3_select_action(void)
{
    static uint8_t self[0x100];
    static const struct { uint32_t arg, before, expect; } arms[] = {
        {0x2780, 7, 0x19}, {0x2781, 7, 0x17}, {0x2782, 7, 0x18}, {0x2783, 7, 0x1a}, {0x2784, 7, 7}, {0x277e, 7, 7}, {0xffffu, 7, 7}, {0x8000u, 7, 7}};
    unsigned i;
    reset();
    /* 0x277f: the fixed values, [self+0x57] untouched */
    memset(self, 0x11, sizeof self);
    g_w.value_5d0377 = 0x1357;
    g_w.value_5b44f0 = 3;
    g_w.value_5b44f4 = 4;
    m4630a3_select_action(self, 0xaaaa277fu, &g_w);
    CK(g_w.value_5b44f0 == 9 && g_w.value_5b44f4 == 1 && g_w.value_5d162d == 0x1357 && g_w.value_5d1631 == 0x5b160cu + 0x120 + 0x10);
    CK(g_w.value_5d1639 == 1 && g_w.value_5c39e5 == 0x277f && get16(self, 0x57) == 0x1111);
    for (i = 0; i < sizeof arms / sizeof arms[0]; i++) {
        reset();
        set16(self, 0x57, 0);
        g_w.value_5b44f0 = arms[i].before;
        g_w.value_5d0377 = 0x2468;
        m4630a3_select_action(self, arms[i].arg, &g_w);
        CK(g_w.value_5b44f0 == arms[i].expect);
        CK(g_w.value_5b44f4 == 1 && g_w.value_5d162d == 0x2468 && g_w.value_5d1639 == 1);
        CK(g_w.value_5d1631 == 0x5b160cu + (arms[i].expect << 5) + 0x10);
        CK(g_w.value_5c39e5 == (uint32_t)(int32_t)(int16_t)arms[i].arg);
        CK(get16(self, 0x57) == (uint16_t)arms[i].arg);          /* [self+0x57] was zero: it takes the argument */
    }
    /* a non-zero word (also with a zero low byte) is kept */
    reset();
    set16(self, 0x57, 0x100);
    m4630a3_select_action(self, 0x2781, &g_w);
    CK(get16(self, 0x57) == 0x100);
    if (!g_failed) g_msg[0] = 0;
}

/* ---- 0x43423d and 0x4344bf ---- */
#define SELF_SZ 0x6100
static uint8_t g_self[SELF_SZ];

static void setup_names(uint8_t *name, uint8_t *sa, uint8_t *sb, const char *n, const char *a, const char *b)
{
    strcpy((char *)name, n);
    strcpy((char *)sa, a);
    strcpy((char *)sb, b);
    region(0x20010000u, name, 0x40);
    region(0x20020000u, sa, 0x40);
    region(0x20030000u, sb, 0x40);
}

static void test_m43423d_find_name_a(void)
{
    static uint8_t name[0x40], sa[0x40], sb[0x40];
    uint32_t sres[2], nres[2];
    reset();
    memset(g_self, 0x99, sizeof g_self);
    set32(g_self, 0x5f64, 2);
    set32(g_self, 0x1144, 0x1000);
    set32(g_self, 0x1148, 0x2000);
    setup_names(name, sa, sb, "abc", "abc", "abd");
    sres[0] = 0x20030000u;      /* "abd": no match */
    sres[1] = 0x20020000u;      /* "abc": match at i = 1 */
    nres[0] = 9;
    nres[1] = 3;                /* <= 8: the report */
    script(0x434814, 2, sres);
    script(0x4347b8, 2, nres);
    CK(m43423d_find_name_a(g_self, name, &g_host) == 1);
    /* pass 0: 0x4347b8(self, 0x1000+4), 0x434814(self, 0x1000+8); pass 1: 0x4347b8(self, 0x2004), report 0x42639d(0x545f04, 0x545ef8) and 0x4c97b4, 0x434814(self, 0x2008) */
    CK(L.n == 6);
    CK(L.c[0].callee == 0x4347b8 && L.c[0].this_ptr == (uintptr_t)g_self && L.c[0].a[0] == 0x1004);
    CK(L.c[1].callee == 0x434814 && L.c[1].a[0] == 0x1008);
    CK(L.c[2].callee == 0x4347b8 && L.c[2].a[0] == 0x2004);
    CK(L.c[3].callee == 0x42639d && L.c[3].this_ptr == 0x583979 && L.c[3].nargs == 2 && L.c[3].a[0] == 0x545f04 && L.c[3].a[1] == 0x545ef8);
    CK(L.c[4].callee == 0x4c97b4 && L.c[4].this_ptr == 0x5cf659);
    CK(L.c[5].callee == 0x434814 && L.c[5].a[0] == 0x2008);
    CK(get32(g_self, 0x111c) == 0x2008 + 4 && get32(g_self, 0x1128) == 0xffffffffu);      /* 3 - 4 */
    CK(memcmp(g_self + 0x1136, "abc", 4) == 0 && g_self[0x113a] == 0x99);
    /* no entry matches: 0 and no store; the loop bound is read every pass (a negative count: no pass) */
    reset();
    memset(g_self, 0x99, sizeof g_self);
    set32(g_self, 0x5f64, 1);
    setup_names(name, sa, sb, "abc", "abc", "ab");
    sres[0] = 0x20030000u;
    script(0x434814, 1, sres);
    CK(m43423d_find_name_a(g_self, name, &g_host) == 0 && get32(g_self, 0x111c) == 0x99999999u && L.n == 4);   /* n = 0 (unscripted) <= 8: the report too */
    reset();
    set32(g_self, 0x5f64, 0xffffffffu);
    CK(m43423d_find_name_a(g_self, name, &g_host) == 0 && L.n == 0);
    /* native rejection: a string address the host cannot resolve gives 0 (the original would read an unmapped address) */
    reset();
    set32(g_self, 0x5f64, 1);
    sres[0] = 0x7777u;
    script(0x434814, 1, sres);
    CK(m43423d_find_name_a(g_self, name, &g_host) == 0 && get32(g_self, 0x111c) == 0x99999999u);
    if (!g_failed) g_msg[0] = 0;
}

static void test_m4344bf_find_name_b(void)
{
    static uint8_t name[0x40], sa[0x40], sb[0x40];
    uint32_t sres[1100], nres[1];
    int i;
    reset();
    memset(g_self, 0x99, sizeof g_self);
    set32(g_self, 0x5f68, 2);
    set32(g_self, 0x20e4, 0x1000);
    set32(g_self, 0x20e8, 0x2000);
    setup_names(name, sa, sb, "abc", "abc", "abcd");
    sres[0] = 0x20030000u;      /* "abcd": no match */
    sres[1] = 0x20020000u;      /* "abc": match at i = 1 */
    nres[0] = 0x77;
    script(0x434814, 2, sres);
    script(0x4347b8, 1, nres);
    CK(m4344bf_find_name_b(g_self, name, &g_host) == 1);
    CK(L.n == 3 && L.c[0].callee == 0x434814 && L.c[0].a[0] == 0x1000 && L.c[1].callee == 0x434814 && L.c[1].a[0] == 0x2000);
    CK(L.c[2].callee == 0x4347b8 && L.c[2].this_ptr == (uintptr_t)g_self && L.c[2].a[0] == 0x2004);
    for (i = 0; i < 0x3e8; i++) CK(get32(g_self, 0x4fc4 + 4 * i) == (i == 1 ? 1u : 0u));
    CK(get32(g_self, 0x112c) == 0x77 && get32(g_self, 0x1120) == 0x2008 && memcmp(g_self + 0x1130, "abc", 4) == 0);
    /* the flag dwords behind the cleared range: i = 1000 is [self+0x5f64] (here 1: that match is skipped), i = 1001 is the count [self+0x5f68] (1002: the match is taken and the count becomes 1) */
    reset();
    memset(g_self, 0x99, sizeof g_self);
    for (i = 0; i < 1100; i++) sres[i] = 0x20030000u;
    sres[1000] = 0x20020000u;
    sres[1001] = 0x20020000u;
    set32(g_self, 0x5f68, 1002);
    set32(g_self, 0x5f64, 1);
    for (i = 0; i < 1002; i++) set32(g_self, 0x20e4 + 4 * i, 0x100 + (uint32_t)i);
    setup_names(name, sa, sb, "abc", "abc", "abcd");
    script(0x434814, 1100, sres);
    CK(m4344bf_find_name_b(g_self, name, &g_host) == 1);
    CK(get32(g_self, 0x5f68) == 1 && get32(g_self, 0x5f64) == 1 && get32(g_self, 0x1120) == 0x100 + 1001 + 8);
    CK(L.n == 1002 + 1);                 /* 1002 string lookups and the one 0x4347b8 call */
    reset();
    memset(g_self, 0x99, sizeof g_self);
    set32(g_self, 0x5f68, 1);
    sres[0] = 0x7777u;
    script(0x434814, 1, sres);
    CK(m4344bf_find_name_b(g_self, name, &g_host) == 0 && get32(g_self, 0x112c) == 0x99999999u);          /* native rejection */
    /* the strcmp: prefix and different strings are not equal, empty strings are */
    {
        static const char *pairs[][2] = {{"ab", "abc"}, {"abc", "ab"}, {"a", "b"}, {"", "x"}, {"x", ""}, {"abcdef", "abcdeg"}, {"abcdefg", "abcdefg"}, {"", ""}, {"a", "a"}};
        static const int equal[] = {0, 0, 0, 0, 0, 0, 1, 1, 1};
        unsigned k;
        for (k = 0; k < sizeof equal / sizeof equal[0]; k++) {
            reset();
            memset(g_self, 0x99, sizeof g_self);
            set32(g_self, 0x5f68, 1);
            set32(g_self, 0x20e4, 0x55);
            setup_names(name, sa, sb, pairs[k][1], pairs[k][0], "zz");
            sres[0] = 0x20020000u;
            script(0x434814, 1, sres);
            CK(m4344bf_find_name_b(g_self, name, &g_host) == (uint32_t)equal[k]);
        }
    }
    if (!g_failed) g_msg[0] = 0;
}

/* ---- the bounded sweep: every port on random in-bounds buffers (meant for the sanitiser builds) ---- */
static uint32_t g_rng = 0x12345678u;
static uint32_t rnd(void) { g_rng = g_rng * 1664525u + 1013904223u; return g_rng >> 8; }

static void test_sweep_bounded(void)
{
    static uint8_t selfm[SELF_SZ], rec[0x1000], dst[0xc00], cells[16], records[3 * 0x8d], buf[8], name[0x40], sa[0x40], handle[0x20], nullpage[0xc00];
    int n, k;
    uint32_t res[6];
    for (n = 0; n < 300; n++) {
        reset();
        for (k = 0; k < (int)sizeof rec; k++) rec[k] = (uint8_t)rnd();
        for (k = 0; k < 0x400; k++) selfm[0x4000 + k] = (uint8_t)rnd();
        region(0x20010000u, rec, sizeof rec);
        region(0x20020000u, dst, sizeof dst);
        region(0x20030000u, cells, sizeof cells);
        region(0x20040000u, sa, sizeof sa);
        region(0x20050000u, name, sizeof name);
        if (rnd() & 3) region(0u, nullpage, sizeof nullpage);       /* sometimes unmapped: the native rejection */
        g_w.word_63a4cd = (int16_t)(rnd() & 1);
        g_w.records_5bb5e5 = records + 0x8d;
        g_w.buf_63a590 = buf;
        /* 0x4bf19a, 0x434814, 0x4630a3 */
        set32(handle, 8, rnd() % 20);
        m4bf19a_bink_goto(selfm + 0x100, (rnd() & 7) ? handle : NULL, rnd() % 25, &g_host);
        for (k = 0; k < 6; k++) name[k] = (uint8_t)(rnd() % 4 ? rnd() | 1 : 0);
        name[6] = 0;
        m434814_copy_name(name, &g_w);
        set16(selfm, 0x57, (uint16_t)(rnd() & 1 ? 0 : rnd()));
        m4630a3_select_action(selfm, 0x2775 + rnd() % 14, &g_w);
        /* the copies: the allocation answers 0 (the scratch page) or the buffer */
        res[0] = (rnd() & 3) ? 0x20020000u : 0u;
        script(0x51dc43, 1, res);
        set32(cells, 0, 0);
        set32(cells, 4, 0x20010000u);
        set32(cells, 8, 0x100);
        m4471ca_copy_record15(cells, cells + 4, cells + 8, &g_w, &g_host);
        set32(cells, 4, 0x20010000u);
        m45b4ae_copy_record_b8e(cells, cells + 4, cells + 8, &g_w, &g_host);
        set32(cells, 4, 0x20010000u);
        m461903_copy_record_357(cells, cells + 4, cells + 8, &g_w, &g_host);
        set32(cells, 4, 0x20010000u);
        m4b5c5c_copy_record_39f(cells, cells + 4, cells + 8, &g_w, &g_host);
        /* 0x45bbd8 */
        for (k = 0; k < 6; k++) res[k] = rnd();
        script(0x50cd50, 6, res);
        set16(selfm + 0x200, 0x1e, 1);
        memset(records, 0, sizeof records);
        set32(records, 0x8d + 0x8d, 0x20010000u);
        m45bbd8_roll_rects(selfm + 0x200, rnd() % 4, &g_w, &g_host);
        /* 0x43423d, 0x4344bf */
        set32(selfm, 0x5f64, rnd() % 4);
        set32(selfm, 0x5f68, rnd() % 4);
        for (k = 0; k < 6; k++) { set32(selfm, 0x1144 + 4 * k, rnd()); set32(selfm, 0x20e4 + 4 * k, rnd()); }
        for (k = 0; k < 4; k++) sa[k] = (uint8_t)('a' + rnd() % 2), name[k] = (uint8_t)('a' + rnd() % 2);
        sa[rnd() % 4] = 0;
        name[rnd() % 4] = 0;
        name[4] = sa[4] = 0;
        res[0] = res[1] = res[2] = 0x20040000u;
        script(0x434814, 3, res);
        m43423d_find_name_a(selfm, name, &g_host);
        m4344bf_find_name_b(selfm, name, &g_host);
    }
}

#define RUN(fn)                \
    do {                       \
        g_failed = 0;          \
        g_msg[0] = 0;          \
        fn();                  \
        if (g_failed) {        \
            printf("FAIL %s: %s\n", #fn, g_msg); \
            failures++;        \
        } else {               \
            printf("PASS %s\n", #fn); \
        }                      \
    } while (0)

int main(void)
{
    int failures = 0;
    RUN(test_m4bf19a_bink_goto);
    RUN(test_m434814_copy_name);
    RUN(test_m4471ca_copy_record15);
    RUN(test_m45b4ae_copy_record_b8e);
    RUN(test_m461903_copy_record_357);
    RUN(test_m4b5c5c_copy_record_39f);
    RUN(test_m45bbd8_roll_rects);
    RUN(test_m4630a3_select_action);
    RUN(test_m43423d_find_name_a);
    RUN(test_m4344bf_find_name_b);
    RUN(test_sweep_bounded);
    return failures;
}
