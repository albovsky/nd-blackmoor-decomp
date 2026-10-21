/* FL-32 (batch a) direct tests of the toggle and text-field handlers of GAME.EXE in src/original_methods_fl32a.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl32a_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl32a.h"

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

static uint8_t g_self[0x400];
static uint8_t g_tbl[0x100];
#define TBL_ZERO 0x40          /* byte offset of the dword index 0 of the original address 0x5e60da in g_tbl (room for negative indices) */
static Fl32aWorld g_w;
static Fl18Host g_host;
#define SELFP ((uintptr_t)g_self)

static void set32(uint8_t *b, size_t off, uint32_t v) { memcpy(b + off, &v, 4); }
static uint32_t get32(const uint8_t *b, size_t off) { uint32_t v; memcpy(&v, b + off, 4); return v; }

#define MAXCALL 16
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[3];
        uint8_t buf[0x13];       /* the 0x13 bytes behind the first argument of 0x50cb1b at the call */
        Fl32aWorld w;            /* the world at the call */
        uint8_t tbl[sizeof g_tbl];
    } c[MAXCALL];
} L;
static uint8_t g_text[0x13];     /* what the text callee 0x51d5b2 stores through its first argument */
static uint32_t g_atoi;          /* what 0x50cb1b returns */

static uint32_t host_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int k, i = L.n;
    (void)ctx;
    if (L.n < MAXCALL) {
        L.c[i].callee = callee;
        L.c[i].this_ptr = this_ptr;
        L.c[i].nargs = nargs;
        for (k = 0; k < nargs && k < 3; k++) L.c[i].a[k] = args[k];
        if (callee == 0x50cb1b) memcpy(L.c[i].buf, (const void *)args[0], sizeof L.c[i].buf);
        L.c[i].w = g_w;
        memcpy(L.c[i].tbl, g_tbl, sizeof g_tbl);
    }
    L.n++;
    if (callee == 0x51d5b2) {
        memcpy((void *)args[0], g_text, sizeof g_text);
        return 0;
    }
    if (callee == 0x50cb1b) return g_atoi;
    return 0;
}

static void setup(void)
{
    size_t i;
    for (i = 0; i < sizeof g_self; i++) g_self[i] = (uint8_t)(i * 7 + 3);
    memset(g_tbl, 0x5a, sizeof g_tbl);
    memset(&g_w, 0, sizeof g_w);
    g_w.table_5e60da = g_tbl + TBL_ZERO;
    g_w.word_5ec33e = 0x1111;
    g_w.word_5ec340 = 0x2222;
    g_w.word_5e5688 = 0x3333;
    g_w.word_5e335e = 0x4444;
    g_w.dword_5e350e = 0xa0a0a0a0u;
    g_w.dword_5e3512 = 0xb0b0b0b0u;
    g_w.dword_5e3516 = 0xc0c0c0c0u;
    memset(&g_host, 0, sizeof g_host);
    g_host.call = host_call;
    g_host.context = NULL;
    L.n = 0;
    memset(g_text, 0, sizeof g_text);
    g_atoi = 0;
}

/* ---- 0x40425d, 0x404298, 0x4042d3 ---------------------------------------------------------------------------------------------- */
typedef void (*TextFn)(uint8_t *, Fl32aWorld *, const Fl18Host *);

static void check_text(TextFn fn, size_t field, uint16_t *word, int which)
{
    uint8_t before[sizeof g_self];
    Fl32aWorld w0;
    uint16_t other[3];
    int k;
    const uint16_t olds[3] = {0x1111, 0x2222, 0x3333};
    static const uint32_t results[] = {0x12345678u, 0xffff8000u, 0x10000u, 0x0001ffffu, 0};
    static const uint16_t words[] = {0x5678, 0x8000, 0, 0xffff, 0};
    static const char *texts[] = {"12345", "-7", "0", "99999999999999999"};
    int r;
    for (r = 0; r < 5; r++) {
        setup();
        memcpy(before, g_self, sizeof before);
        w0 = g_w;
        memset(g_text, 0x7e, sizeof g_text);
        memcpy(g_text, texts[r % 4], strlen(texts[r % 4]) + 1);
        g_atoi = results[r];
        fn(g_self, &g_w, &g_host);
        CK(L.n == 3);
        /* 0x51d5b2(this = self + field, buffer, 0x13): thiscall, two arguments (the buffer is the LAST one pushed = args[0]) */
        CK(L.c[0].callee == 0x51d5b2 && L.c[0].this_ptr == SELFP + field && L.c[0].nargs == 2 && L.c[0].a[1] == 0x13 && L.c[0].a[0] != 0 && L.c[0].a[0] > 0xffffffffu);
        /* 0x50cb1b(buffer): cdecl, one argument, the same buffer, holding what the text callee wrote; the word is not stored yet */
        CK(L.c[1].callee == 0x50cb1b && L.c[1].this_ptr == 0 && L.c[1].nargs == 1 && L.c[1].a[0] == L.c[0].a[0]);
        CK(memcmp(L.c[1].buf, g_text, sizeof g_text) == 0);
        CK(memcmp(&L.c[1].w, &w0, sizeof w0) == 0);
        /* 0x4033db(this = self): thiscall, no arguments; the word is stored (low 16 bits of the result) before the call, nothing else changed */
        CK(L.c[2].callee == 0x4033db && L.c[2].this_ptr == SELFP && L.c[2].nargs == 0);
        CK(*word == words[r]);
        CK(L.c[2].w.word_5ec33e == g_w.word_5ec33e && L.c[2].w.word_5ec340 == g_w.word_5ec340 && L.c[2].w.word_5e5688 == g_w.word_5e5688);
        other[0] = g_w.word_5ec33e;
        other[1] = g_w.word_5ec340;
        other[2] = g_w.word_5e5688;
        for (k = 0; k < 3; k++)
            if (k != which) CK(other[k] == olds[k]);          /* the other two words keep their values: a dword store would change the neighbour */
        CK(g_w.word_5e335e == 0x4444 && g_w.dword_5e350e == 0xa0a0a0a0u && g_w.dword_5e3512 == 0xb0b0b0b0u && g_w.dword_5e3516 == 0xc0c0c0c0u);
        CK(memcmp(g_self, before, sizeof before) == 0);
        CK(g_w.table_5e60da == w0.table_5e60da);
    }
}
static void test_m40425d_read_text_cc(void) { setup(); check_text(m40425d_read_text_cc, 0xcc, &g_w.word_5ec33e, 0); }
static void test_m404298_read_text_10c(void) { setup(); check_text(m404298_read_text_10c, 0x10c, &g_w.word_5ec340, 1); }
static void test_m4042d3_read_text_1cc(void) { setup(); check_text(m4042d3_read_text_1cc, 0x1cc, &g_w.word_5e5688, 2); }

/* ---- 0x4029a9, 0x4029f0, 0x402a37 ---------------------------------------------------------------------------------------------- */
typedef void (*ToggleFn)(uint8_t *, Fl32aWorld *, const Fl18Host *);

static void check_toggle(ToggleFn fn, size_t delta)
{
    static const int32_t idx[] = {0, 3, -2, 0x20};
    static const uint32_t first[] = {1, 0, 0x100, 0x10001u, 0x01000001u, 0xffffffffu, 2};
    uint8_t want[sizeof g_tbl];
    int i, j;
    for (i = 0; i < 4; i++)
        for (j = 0; j < 7; j++) {
            size_t at = (size_t)((ptrdiff_t)TBL_ZERO + (ptrdiff_t)idx[i] * 4 + (ptrdiff_t)delta);
            setup();
            set32(g_self, 0x5c, (uint32_t)idx[i]);
            set32(g_tbl, at, first[j]);
            memcpy(want, g_tbl, sizeof want);
            set32(want, at, first[j] == 1 ? 0 : 1);        /* the dword compare: only exactly 1 becomes 0, everything else (also 0x100, 0x10001) becomes 1 */
            fn(g_self, &g_w, &g_host);
            CK(memcmp(g_tbl, want, sizeof want) == 0);      /* only that one dword changed */
            CK(L.n == 1 && L.c[0].callee == 0x40236a && L.c[0].this_ptr == SELFP && L.c[0].nargs == 0);
            CK(memcmp(L.c[0].tbl, want, sizeof want) == 0);  /* the store is done before the call */
        }
    /* the index is a signed dword: -1 reaches the dword below index 0, not 0x3fffffffc bytes above */
    setup();
    set32(g_self, 0x5c, 0xffffffffu);
    set32(g_tbl, (size_t)((ptrdiff_t)TBL_ZERO - 4 + (ptrdiff_t)delta), 1);
    fn(g_self, &g_w, &g_host);
    CK(get32(g_tbl, (size_t)((ptrdiff_t)TBL_ZERO - 4 + (ptrdiff_t)delta)) == 0);
}
static void test_m4029a9_toggle_5e60da(void) { check_toggle(m4029a9_toggle_5e60da, 0); }
static void test_m4029f0_toggle_5e60de(void) { check_toggle(m4029f0_toggle_5e60de, 4); }
static void test_m402a37_toggle_5e60e2(void) { check_toggle(m402a37_toggle_5e60e2, 8); }

/* ---- 0x4067eb, 0x406832, 0x406879 ---------------------------------------------------------------------------------------------- */
static void check_flag(ToggleFn fn, uint32_t k, int which)
{
    static const uint32_t flags[] = {1, 0, 2, 0x100, 0x10001u, 0xffffffffu, 0x80000001u};
    static const uint16_t words[] = {0, 1, 2, 3, 0xffff, 0x8000, 0x8001, 0x8002, 0x8003, 0x101, 0x102, 0x103, 0xfffe};
    int i, j;
    for (i = 0; i < 7; i++)
        for (j = 0; j < 13; j++) {
            uint32_t *flags_of[3];
            uint32_t *flag;
            uint32_t flag_now;
            uint16_t word_now = words[j], word_want;
            Fl32aWorld w0;
            int m;
            setup();
            flag = which == 0 ? &g_w.dword_5e350e : (which == 1 ? &g_w.dword_5e3512 : &g_w.dword_5e3516);
            flags_of[0] = &g_w.dword_5e350e;
            flags_of[1] = &g_w.dword_5e3512;
            flags_of[2] = &g_w.dword_5e3516;
            *flag = flags[i];
            g_w.word_5e335e = word_now;
            w0 = g_w;
            fn(g_self, &g_w, &g_host);
            flag_now = flags[i] == 1 ? 0 : 1;
            word_want = flags[i] == 1 ? word_now : ((uint16_t)word_now == k ? 0xffff : word_now);
            CK(*flag == flag_now);
            CK(g_w.word_5e335e == word_want);
            for (m = 0; m < 3; m++)
                if (m != which) CK(*flags_of[m] == (m == 0 ? w0.dword_5e350e : (m == 1 ? w0.dword_5e3512 : w0.dword_5e3516)));
            CK(g_w.word_5ec33e == 0x1111 && g_w.word_5ec340 == 0x2222 && g_w.word_5e5688 == 0x3333);
            CK(L.n == 1 && L.c[0].callee == 0x404be1 && L.c[0].this_ptr == SELFP && L.c[0].nargs == 0);
            CK(L.c[0].w.word_5e335e == word_want);        /* both stores are done before the call */
            CK(*(&L.c[0].w.dword_5e350e + which) == flag_now);
        }
}
static void test_m4067eb_toggle_5e350e(void) { check_flag(m4067eb_toggle_5e350e, 1, 0); }
static void test_m406832_toggle_5e3512(void) { check_flag(m406832_toggle_5e3512, 2, 1); }
static void test_m406879_toggle_5e3516(void) { check_flag(m406879_toggle_5e3516, 3, 2); }

/* CASES-END */

/* ---- bounded sweep ------------------------------------------------------------------------------------------------------------- */
static void test_sweep_bounded(void)
{
    unsigned seed = 4242;
    int n, i;
    for (n = 0; n < 300 && !g_failed; n++) {
        setup();
        for (i = 0; i < (int)sizeof g_self; i++) {
            seed = seed * 1103515245u + 12345u;
            g_self[i] = (uint8_t)(seed >> 16);
        }
        seed = seed * 1103515245u + 12345u;
        for (i = 0; i < (int)sizeof g_tbl; i++) g_tbl[i] = (uint8_t)(seed >> (i & 15));
        /* the table index is kept inside g_tbl: -16 .. 0x2b dwords (the offsets +4 and +8 stay inside as well) */
        set32(g_self, 0x5c, (uint32_t)((int)(seed % 0x3c) - 16));
        g_w.dword_5e350e = seed & 1;
        g_w.dword_5e3512 = (seed >> 1) & 1;
        g_w.dword_5e3516 = (seed >> 2) & 1;
        g_w.word_5e335e = (uint16_t)((seed >> 3) % 5);
        memset(g_text, (int)(seed >> 9), sizeof g_text);
        g_atoi = seed;
        m40425d_read_text_cc(g_self, &g_w, &g_host);
        m404298_read_text_10c(g_self, &g_w, &g_host);
        m4042d3_read_text_1cc(g_self, &g_w, &g_host);
        m4029a9_toggle_5e60da(g_self, &g_w, &g_host);
        m4029f0_toggle_5e60de(g_self, &g_w, &g_host);
        m402a37_toggle_5e60e2(g_self, &g_w, &g_host);
        m4067eb_toggle_5e350e(g_self, &g_w, &g_host);
        m406832_toggle_5e3512(g_self, &g_w, &g_host);
        m406879_toggle_5e3516(g_self, &g_w, &g_host);
        L.n = 0;
        /* SWEEP-END */
    }
}

#define RUN(fn)                                       \
    do {                                              \
        g_failed = 0;                                 \
        g_msg[0] = 0;                                 \
        fn();                                         \
        if (g_failed) {                               \
            printf("FAIL %s: %s\n", #fn, g_msg);      \
            failures++;                               \
        } else {                                      \
            printf("PASS %s\n", #fn);                 \
        }                                             \
    } while (0)

int main(void)
{
    int failures = 0;
    RUN(test_m40425d_read_text_cc);
    RUN(test_m404298_read_text_10c);
    RUN(test_m4042d3_read_text_1cc);
    RUN(test_m4029a9_toggle_5e60da);
    RUN(test_m4029f0_toggle_5e60de);
    RUN(test_m402a37_toggle_5e60e2);
    RUN(test_m4067eb_toggle_5e350e);
    RUN(test_m406832_toggle_5e3512);
    RUN(test_m406879_toggle_5e3516);
    /* RUN-END */
    RUN(test_sweep_bounded);
    return failures;
}
