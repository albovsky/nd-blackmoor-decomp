/* FL-29 (batch b) direct tests of the ten small methods of GAME.EXE in src/original_methods_fl29b.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the failure
 * count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl29b_differential.py additionally runs the original bytes on generated fixtures. One flat arena stands for the memory of the original at ARENA_VA. */
#include "../src/original_methods_fl29b.h"

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

#define ARENA_VA 0x20000000u
#define ARENA_SZ 0x20000
#define SELF_OFF 0x0000u        /* an object of 0xc800 bytes */
#define CELL_OFF 0xd000u        /* small objects: cells, chains, characters */
#define SRC_OFF 0xe000u         /* a source of 0x9000 bytes */
#define DST_OFF 0x18000u
#define TAB_OFF 0x1a000u
#define REC_OFF 0x1b000u        /* the base of the record table is REC_OFF + 0x400, so that negative indices stay inside */

static uint8_t g_mem[ARENA_SZ];
static Fl29bWorld g_w;
static Fl18Host g_host;
#define VA(off) (ARENA_VA + (uint32_t)(off))
#define HP(off) (g_mem + (off))

static void set32(size_t off, uint32_t v) { memcpy(g_mem + off, &v, 4); }
static void set16(size_t off, uint16_t v) { memcpy(g_mem + off, &v, 2); }
static uint32_t get32(size_t off) { uint32_t v; memcpy(&v, g_mem + off, 4); return v; }
static uint16_t get16(size_t off) { uint16_t v; memcpy(&v, g_mem + off, 2); return v; }

#define MAXCALL 64
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
    uint32_t callee, results[4];
    int n, used;
} S[8];
static int g_nscript;
static int g_repair;            /* the call to 0x4c97b4 stores g_repair_val in the dword at arena offset g_repair_cell */
static size_t g_repair_cell;
static uint32_t g_repair_val;

static void script(uint32_t callee, uint32_t r0, uint32_t r1)
{
    S[g_nscript].callee = callee;
    S[g_nscript].results[0] = r0;
    S[g_nscript].results[1] = r1;
    S[g_nscript].n = 2;
    S[g_nscript].used = 0;
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
        for (k = 0; k < nargs && k < 6; k++) L.c[i].a[k] = args[k];
    }
    L.n++;
    if (callee == 0x4c97b4 && g_repair) set32(g_repair_cell, g_repair_val);
    for (k = 0; k < g_nscript; k++)
        if (S[k].callee == callee) {
            result = S[k].results[S[k].used < S[k].n ? S[k].used : S[k].n - 1];
            S[k].used++;
        }
    return result;
}

static const uint8_t *host_resolve(void *ctx, uint32_t a)
{
    (void)ctx;
    if (a >= ARENA_VA && a < ARENA_VA + ARENA_SZ) return g_mem + (a - ARENA_VA);
    return NULL;
}

static void setup(void)
{
    memset(g_mem, 0xee, sizeof g_mem);
    memset(&g_w, 0, sizeof g_w);
    g_w.table_5a1e64 = HP(TAB_OFF);
    g_w.records_5bb5e5 = HP(REC_OFF + 0x400);
    memset(&g_host, 0, sizeof g_host);
    g_host.call = host_call;
    g_host.resolve = host_resolve;
    L.n = 0;
    g_nscript = 0;
    g_repair = 0;
}

static void ck_call(int line, int idx, uint32_t callee, uintptr_t this_ptr, int nargs, const uintptr_t *want)
{
    int k;
    if (g_failed) return;
    if (idx >= L.n || idx >= MAXCALL || L.c[idx].callee != callee || L.c[idx].this_ptr != this_ptr || L.c[idx].nargs != nargs) {
        g_failed = 1;
        snprintf(g_msg, sizeof g_msg, "line %d: call %d is not %x this %lx nargs %d (log has %d)", line, idx, (unsigned)callee, (unsigned long)this_ptr, nargs, L.n);
        return;
    }
    for (k = 0; k < nargs; k++)
        if (L.c[idx].a[k] != want[k]) {
            g_failed = 1;
            snprintf(g_msg, sizeof g_msg, "line %d: call %d arg %d is %lx, want %lx", line, idx, k, (unsigned long)L.c[idx].a[k], (unsigned long)want[k]);
            return;
        }
}
#define CKC(idx, callee, thisp, nargs, ...)                              \
    do {                                                                 \
        const uintptr_t w_[] = {__VA_ARGS__};                            \
        ck_call(__LINE__, (idx), (callee), (thisp), (nargs), w_);       \
    } while (0)
#define CKC0(idx, callee, thisp) ck_call(__LINE__, (idx), (callee), (thisp), 0, NULL)
#define NCALLS(cnt) CK(L.n == (cnt))

/* ---- 0x4ee69e ------------------------------------------------------------------------------------------------------------------ */
static void test_m4ee69e_forward_if_set(void)
{
    setup();
    set32(0x252, 0);
    CK(m4ee69e_forward_if_set(HP(SELF_OFF), &g_host) == 0);
    NCALLS(0);                                      /* the dword is zero: nothing is called, eax = 0 */
    set32(0x252, 0x100);                            /* a non-zero dword that is zero in its low word */
    script(0x4ef516, 0xdeadbeefu, 0xdeadbeefu);
    CK(m4ee69e_forward_if_set(HP(SELF_OFF), &g_host) == 0xdeadbeefu);
    NCALLS(1);
    CKC0(0, 0x4ef516, (uintptr_t)(HP(SELF_OFF) + 0x4b7));       /* ecx = self + 0x4b7, the result goes back whole */
    set32(0x252, 0x80000000u);
    L.n = 0;
    CK(m4ee69e_forward_if_set(HP(SELF_OFF), &g_host) == 0xdeadbeefu);
    NCALLS(1);
}

/* ---- 0x423aae ------------------------------------------------------------------------------------------------------------------ */
static void test_m423aae_chain_end(void)
{
    uint32_t o0 = VA(CELL_OFF), o1 = VA(CELL_OFF + 0x40), o2 = VA(CELL_OFF + 0x80), o3 = VA(CELL_OFF + 0xc0);
    setup();
    memset(HP(CELL_OFF), 0, 0x100);
    CK(m423aae_chain_end(0, &g_host) == 0);                    /* a null argument */
    CK(m423aae_chain_end(o0, &g_host) == 0);                   /* [arg + 4] is 0 */
    set32(CELL_OFF + 4, o1);
    CK(m423aae_chain_end(o0, &g_host) == o1);                  /* q = o1, [q + 0x38] = 0: q itself */
    set32(CELL_OFF + 0x40 + 0x38, o2);
    CK(m423aae_chain_end(o0, &g_host) == o2);                  /* one link */
    set32(CELL_OFF + 0x80 + 0x38, o3);
    CK(m423aae_chain_end(o0, &g_host) == o3);                  /* two links; [arg + 0x38] of the argument itself is never followed */
    set32(CELL_OFF + 0x38, o2);
    CK(m423aae_chain_end(o0, &g_host) == o3);
    /* native rejections (the original faults or never returns) */
    CK(m423aae_chain_end(0x1234, &g_host) == 0);               /* the argument is not resolvable */
    set32(CELL_OFF + 4, 0x4321);
    CK(m423aae_chain_end(o0, &g_host) == 0);                   /* q is not resolvable */
    set32(CELL_OFF + 4, o1);
    set32(CELL_OFF + 0xc0 + 0x38, o1);                        /* o1 -> o2 -> o3 -> o1: a cycle */
    CK(m423aae_chain_end(o0, &g_host) == 0);
}

/* ---- 0x4fccf2 ------------------------------------------------------------------------------------------------------------------ */
static float getf(size_t off) { float f; memcpy(&f, g_mem + off, 4); return f; }
static void test_m4fccf2_store_percent(void)
{
    setup();
    script(0x4fcb5c, 0x55aa55aau, 0x55aa55aau);
    CK(m4fccf2_store_percent(HP(SELF_OFF), 250, 3, &g_w, &g_host) == 0x55aa55aau);        /* the callee's eax */
    CK(getf(0xb764 + 12) == 2.5f);                                                       /* 250 / 100 at self + 0xb764 + 3 * 4 */
    NCALLS(1);
    CKC(0, 0x4fcb5c, (uintptr_t)HP(SELF_OFF), 1, 3);
    CK(m4fccf2_store_percent(HP(SELF_OFF), 0x1ffff, 0xffffffffu, &g_w, &g_host) == 0x55aa55aau);
    CK(getf(0xb764 - 4) == 655.35f);                                                     /* the word argument is masked to 0xffff; index -1 */
    CK(getf(0xb764 + 12) == 2.5f);
    CK(m4fccf2_store_percent(HP(SELF_OFF), 0x10000, 0, &g_w, &g_host) == 0x55aa55aau);
    CK(getf(0xb764) == 0.0f);                                                            /* the low word 0 */
    CK(m4fccf2_store_percent(HP(SELF_OFF), 1, 0, &g_w, &g_host) == 0x55aa55aau);
    CK(getf(0xb764) == 0.01f);
    L.n = 0;
    g_w.word_63a4cd = (int16_t)0x8000;                                                   /* any non-zero word turns the trace on, the trace call comes first */
    CK(m4fccf2_store_percent(HP(SELF_OFF), 100, 0, &g_w, &g_host) == 0x55aa55aau);
    NCALLS(2);
    CKC(0, 0x44a2b7, 0, 1, 0x5609d4);
    CKC(1, 0x4fcb5c, (uintptr_t)HP(SELF_OFF), 1, 0);
    CK(getf(0xb764) == 1.0f);
}

/* ---- 0x423a30 ------------------------------------------------------------------------------------------------------------------ */
static void test_m423a30_free_cell(void)
{
    setup();
    set32(CELL_OFF, 0);
    m423a30_free_cell(HP(CELL_OFF), &g_w, &g_host);
    NCALLS(3);                                                    /* null cell: the format report, the stdcall report, the 0x4c97b4 call */
    CKC(0, 0x50ca3e, 0, 2, 0x63888b, 0x544820);
    CKC(1, 0x52139c, 0, 3, 0x63888b, 0, 0);
    CKC0(2, 0x4c97b4, 0x5cf659);
    CK(get32(CELL_OFF) == 0);
    L.n = 0;
    g_w.word_63a4cd = 0x100;
    m423a30_free_cell(HP(CELL_OFF), &g_w, &g_host);
    NCALLS(4);
    CKC(2, 0x44a2b7, 0, 1, 0x63888b);                             /* the trace call sits between 0x52139c and 0x4c97b4 */
    CKC0(3, 0x4c97b4, 0x5cf659);
    L.n = 0;
    set32(CELL_OFF, 0x20001234u);
    m423a30_free_cell(HP(CELL_OFF), &g_w, &g_host);
    NCALLS(1);
    CKC(0, 0x51dc6c, 0, 1, 0x20001234u);
    CK(get32(CELL_OFF) == 0);                                     /* freed and cleared, no trace call on this path */
}

/* ---- 0x42e72c ------------------------------------------------------------------------------------------------------------------ */
static void test_m42e72c_toggle_state(void)
{
    setup();
    g_w.value_5d03bf = 0;
    g_w.word_5b4dc8 = 5;
    m42e72c_toggle_state(&g_w, &g_host);
    NCALLS(0);                                                    /* no destination: nothing, and the word is not touched */
    CK(g_w.word_5b4dc8 == 5);
    g_w.word_63a4cd = 1;
    m42e72c_toggle_state(&g_w, &g_host);
    NCALLS(1);
    CKC(0, 0x44a2b7, 0, 1, 0x545aac);
    L.n = 0;
    g_w.value_5d03bf = VA(CELL_OFF + 8);
    g_w.value_5b4db8 = 0x11111111u;
    g_w.value_5b4dbc = 0x22222222u;
    g_w.word_5b4e04 = 2;
    g_w.word_5b4dc8 = 0;                                          /* 0 -> 1: the table entry 1 */
    set32(CELL_OFF + 8, 0);
    m42e72c_toggle_state(&g_w, &g_host);
    NCALLS(2);
    CKC(0, 0x44c479, 0, 1, 0x5b4c3a);
    CKC(1, 0x44c4ab, 0, 1, 0x5b4c3a);                             /* the trace call is only on the no-destination path */
    CK(g_w.word_5b4dc8 == 1);
    CK(get32(CELL_OFF + 8) == 0x22222222u);
    g_w.word_5b4dc8 = (int16_t)0x8000;                            /* a non-zero word -> 0: the table entry 0 */
    m42e72c_toggle_state(&g_w, &g_host);
    CK(g_w.word_5b4dc8 == 0);
    CK(get32(CELL_OFF + 8) == 0x11111111u);
    g_w.word_5b4e04 = 3;                                          /* not mode 2: toggled, nothing stored */
    set32(CELL_OFF + 8, 0x77u);
    m42e72c_toggle_state(&g_w, &g_host);
    CK(g_w.word_5b4dc8 == 1 && get32(CELL_OFF + 8) == 0x77u);
    g_w.word_5b4e04 = (int16_t)0x8002;                            /* the sign extension of 0x8002 is not 2 */
    m42e72c_toggle_state(&g_w, &g_host);
    CK(get32(CELL_OFF + 8) == 0x77u);
    g_w.word_5b4e04 = 2;                                          /* native rejection: an unresolvable destination is not written */
    g_w.value_5d03bf = 0x1234;
    m42e72c_toggle_state(&g_w, &g_host);
}

/* ---- 0x4e9c2f ------------------------------------------------------------------------------------------------------------------ */
static void test_m4e9c2f_copy_six(void)
{
    int i;
    setup();
    for (i = 0; i < 16; i++) g_mem[SRC_OFF + i] = (uint8_t)(0x10 + i);
    set32(CELL_OFF, 0);                                                  /* out cell */
    set32(CELL_OFF + 4, VA(SRC_OFF + 2));                                /* src cell */
    set32(CELL_OFF + 8, 0x100);                                          /* adv cell */
    script(0x51dc43, VA(DST_OFF + 1), 0);
    m4e9c2f_copy_six(HP(CELL_OFF), HP(CELL_OFF + 4), HP(CELL_OFF + 8), &g_w, &g_host);
    NCALLS(1);
    CKC(0, 0x51dc43, 0, 1, 6);
    CK(get32(CELL_OFF) == VA(DST_OFF + 1));                              /* *out = the allocation */
    CK(memcmp(HP(DST_OFF + 1), HP(SRC_OFF + 2), 6) == 0);                /* six bytes: a dword and a word */
    CK(g_mem[DST_OFF] == 0xee && g_mem[DST_OFF + 7] == 0xee);
    CK(get32(CELL_OFF + 4) == VA(SRC_OFF + 8) && get32(CELL_OFF + 8) == 0x106);
    /* the failed allocation: reports, then the copy goes on (the report returned) into the cell that it left */
    setup();
    for (i = 0; i < 16; i++) g_mem[SRC_OFF + i] = (uint8_t)(0x10 + i);
    set32(CELL_OFF + 4, VA(SRC_OFF));
    set32(CELL_OFF + 8, 0xfffffffeu);
    g_w.value_5bb57b = 0xabcdef01u;
    g_w.word_5c39e3 = -2;
    g_w.word_63a4cd = 1;
    script(0x51dc43, 0, 0);
    g_repair = 1;
    g_repair_cell = CELL_OFF;
    g_repair_val = VA(DST_OFF + 0x20);
    m4e9c2f_copy_six(HP(CELL_OFF), HP(CELL_OFF + 4), HP(CELL_OFF + 8), &g_w, &g_host);
    NCALLS(5);
    CKC(1, 0x50ca3e, 0, 4, 0x63888b, 0x55c934, 0xabcdef01u, 0xfffffffeu);          /* the sign-extended word is the last argument */
    CKC(2, 0x42639d, 0x583979, 2, 0x55c960, 0x63888b);
    CKC0(3, 0x4c97b4, 0x5cf659);
    CKC(4, 0x44a2b7, 0, 1, 0x55c97c);
    CK(memcmp(HP(DST_OFF + 0x20), HP(SRC_OFF), 6) == 0);
    CK(get32(CELL_OFF + 8) == 4);                                         /* 0xfffffffe + 6 wraps */
    /* native rejection: the cell still holds 0 after the report (the original would write to address 0) */
    setup();
    set32(CELL_OFF + 4, VA(SRC_OFF));
    set32(CELL_OFF + 8, 1);
    script(0x51dc43, 0, 0);
    m4e9c2f_copy_six(HP(CELL_OFF), HP(CELL_OFF + 4), HP(CELL_OFF + 8), &g_w, &g_host);
    CK(get32(CELL_OFF) == 0 && get32(CELL_OFF + 4) == VA(SRC_OFF) && get32(CELL_OFF + 8) == 1);
    /* overlap: the destination two bytes above the source, the word at source + 4 is read after the dword store */
    setup();
    for (i = 0; i < 16; i++) g_mem[DST_OFF + i] = (uint8_t)(0x40 + i);
    set32(CELL_OFF + 4, VA(DST_OFF));
    script(0x51dc43, VA(DST_OFF + 2), 0);
    m4e9c2f_copy_six(HP(CELL_OFF), HP(CELL_OFF + 4), HP(CELL_OFF + 8), &g_w, &g_host);
    /* dword at DST+0 = 40 41 42 43 goes to DST+2..5; the word at DST+4 is then 40 41 */
    CK(g_mem[DST_OFF + 2] == 0x40 && g_mem[DST_OFF + 3] == 0x41 && g_mem[DST_OFF + 4] == 0x42 && g_mem[DST_OFF + 5] == 0x43);
    CK(g_mem[DST_OFF + 6] == 0x42 && g_mem[DST_OFF + 7] == 0x43);       /* the word at DST+4 was 42 43 after the store: it is 42 43, not the old 44 45 */
}

/* ---- 0x4e45be ------------------------------------------------------------------------------------------------------------------ */
static void setrow(int row, const uint8_t *b, int n)
{
    memcpy(HP(TAB_OFF + (size_t)row * 0x29), b, (size_t)n);
}
static void test_m4e45be_find_row(void)
{
    const uint8_t key[3] = {0x90, 0x01, 0x7f};
    uint8_t r0[3] = {0x90, 0x01, 0x7e}, r1[3] = {0x90, 0x01, 0x7f}, r2[3] = {0x80, 0x01, 0x7f};
    setup();
    memcpy(HP(CELL_OFF + 0x20), key, 3);
    g_w.word_5a1e5c = 3;
    setrow(0, r0, 3);
    setrow(1, r1, 3);
    setrow(2, r2, 3);
    set16(CELL_OFF, 0x5555);
    CK(m4e45be_find_row(HP(CELL_OFF), HP(CELL_OFF + 0x20), 3, &g_w) == 1);
    CK(get16(CELL_OFF) == 1);                                            /* row 0 differs in its third byte, row 1 matches */
    CK(m4e45be_find_row(HP(CELL_OFF), HP(CELL_OFF + 0x20), 0x10003, &g_w) == 1 && get16(CELL_OFF) == 1);       /* only the low word of the length counts */
    set16(CELL_OFF, 0x5555);
    CK(m4e45be_find_row(HP(CELL_OFF), HP(CELL_OFF + 0x20), 2, &g_w) == 1 && get16(CELL_OFF) == 0);            /* the first two bytes of row 0 match */
    CK(m4e45be_find_row(HP(CELL_OFF), HP(CELL_OFF + 0x20), 0x10000, &g_w) == 0 && get16(CELL_OFF) == 0);      /* length 0: returns 0 */
    set16(CELL_OFF, 0x5555);
    CK(m4e45be_find_row(HP(CELL_OFF), HP(CELL_OFF + 0x20), 0x10000, &g_w) == 0 && get16(CELL_OFF) == 0x5555);   /* ... and does not store */
    g_w.word_5a1e5c = 1;
    CK(m4e45be_find_row(HP(CELL_OFF), HP(CELL_OFF + 0x20), 3, &g_w) == 0);        /* only row 0, which differs: not found, the word stays 0 */
    CK(get16(CELL_OFF) == 0);
    set16(CELL_OFF, 0x5555);
    CK(m4e45be_find_row(HP(CELL_OFF), HP(CELL_OFF + 0x20), 0xffff, &g_w) == 1 && get16(CELL_OFF) == 0);       /* a negative length compares nothing: row 0 matches */
    g_mem[CELL_OFF + 0x20] = 0x00;                                       /* unsigned byte compare: 0x90 against 0x00 and 0x7f against 0xff */
    CK(m4e45be_find_row(HP(CELL_OFF), HP(CELL_OFF + 0x20), 1, &g_w) == 0);
    g_w.word_5a1e5c = 0;                                                 /* native rejection: the original returns an uninitialised local */
    CK(m4e45be_find_row(HP(CELL_OFF), HP(CELL_OFF + 0x20), 1, &g_w) == 0);
}

/* ---- 0x437dcd ------------------------------------------------------------------------------------------------------------------ */
static void test_m437dcd_note_key(void)
{
    uint8_t *self = HP(SELF_OFF);
    setup();
    g_mem[CELL_OFF] = 0xc1;                                              /* a negative char */
    script(0x437ea1, 1, 1);
    m437dcd_note_key(self, HP(CELL_OFF), &g_w, &g_host);
    NCALLS(3);                                                           /* both enables are zero: only the three sign-extended calls */
    CKC(0, 0x4a1f59, 0x61d2dd, 1, 0xffffffc1u);
    CKC(1, 0x48e93e, 0x624dc9, 1, 0xffffffc1u);
    CKC(2, 0x4b8193, 0x61ee6e, 1, 0xffffffc1u);
    CK(g_w.value_5e32de == 0 && g_w.byte_5b616b == 0);
    L.n = 0;
    g_w.value_5e32c9 = 0x100;
    g_mem[CELL_OFF] = 0x61;
    m437dcd_note_key(self, HP(CELL_OFF), &g_w, &g_host);                 /* latches 'a' */
    NCALLS(4);
    CKC(0, 0x437ea1, (uintptr_t)self, 1, 0x61);
    CK(g_w.byte_5e32dd == 0x61 && g_w.value_5e32de == 1);
    L.n = 0;
    g_mem[CELL_OFF] = 0x62;
    m437dcd_note_key(self, HP(CELL_OFF), &g_w, &g_host);                 /* already latched: no call, no change */
    NCALLS(3);
    CK(g_w.byte_5e32dd == 0x61);
    g_w.value_5e32de = 0;
    {
        static const uint8_t excluded[3] = {0x2f, 0x3f, 0x3a};
        int i;
        for (i = 0; i < 3; i++) {
            g_mem[CELL_OFF] = excluded[i];
            L.n = 0;
            m437dcd_note_key(self, HP(CELL_OFF), &g_w, &g_host);
            NCALLS(4);                                                   /* the predicate is asked, then '/', '?' and ':' are refused */
            CK(g_w.value_5e32de == 0 && g_w.byte_5e32dd == 0x61);
        }
    }
    script(0x437ea1, 0, 0);                                              /* a second script entry for the same callee is not used: reset */
    g_nscript = 0;
    script(0x437ea1, 0, 1);
    g_mem[CELL_OFF] = 0x63;
    L.n = 0;
    m437dcd_note_key(self, HP(CELL_OFF), &g_w, &g_host);                 /* the predicate says 0: not latched */
    CK(g_w.value_5e32de == 0);
    g_w.value_5e32c9 = 0;
    g_w.byte_5b61af = 0x80;                                              /* the second latch: asked with an exact byte argument */
    g_w.byte_5b616b = 0;
    script(0x437ea1, 5, 5);
    g_nscript = 0;
    script(0x437ea1, 5, 5);
    g_mem[CELL_OFF] = 0x2f;                                              /* '/' is accepted by the second latch (no character test) */
    L.n = 0;
    m437dcd_note_key(self, HP(CELL_OFF), &g_w, &g_host);
    NCALLS(4);
    CKC(0, 0x437ea1, (uintptr_t)self, 1, 0x2f);
    CK(g_w.byte_5b616c == 0x2f && g_w.byte_5b616b == 1);
    L.n = 0;
    m437dcd_note_key(self, HP(CELL_OFF), &g_w, &g_host);                 /* latched: 3 calls only */
    NCALLS(3);
}

/* ---- 0x4e4337 ------------------------------------------------------------------------------------------------------------------ */
static void load_src(int16_t sizeword)
{
    int i;
    for (i = 0; i < 0x9000; i++) g_mem[SRC_OFF + i] = (uint8_t)(i * 7 + 1);
    set16(SRC_OFF + 0x2f0 + 0xaaf, (uint16_t)sizeword);               /* lands at self + 0x1471 through the second block */
    memset(g_mem + SELF_OFF, 0xee, 0xc800);
}
static void test_m4e4337_load_blocks(void)
{
    int i, ok;
    setup();
    load_src(3);                                                         /* n = 123 */
    script(0x50ca3e, 0, 0);
    m4e4337_load_blocks(HP(SELF_OFF), HP(SRC_OFF), 0xda1u + 123u, &g_host);
    NCALLS(0);                                                           /* total == limit: jle taken */
    ok = 1;
    for (i = 0; i < 0x2f0; i++) ok &= g_mem[0x6d2 + i] == g_mem[SRC_OFF + i];
    for (i = 0; i < 0xab1; i++) ok &= g_mem[0x9c2 + i] == g_mem[SRC_OFF + 0x2f0 + i];
    for (i = 0; i < 123; i++) ok &= g_mem[0x457b + i] == g_mem[SRC_OFF + 0xda1 + i];
    CK(ok);
    CK(g_mem[0x6d1] == 0xee && g_mem[0x1473] == 0xee && g_mem[0x457a] == 0xee && g_mem[0x457b + 123] == 0xee);
    m4e4337_load_blocks(HP(SELF_OFF), HP(SRC_OFF), 0xda1u + 122u, &g_host);       /* total > limit by one: the error report, in order */
    NCALLS(3);
    CKC(0, 0x50ca3e, 0, 4, 0x63888b, 0x55c0c0, 0xda1u + 123u, 0xda1u + 122u);
    CKC(1, 0x4264e8, 0x583979, 1, 0x63888b);
    CKC0(2, 0x4c97b4, 0x5cf659);
    L.n = 0;
    m4e4337_load_blocks(HP(SELF_OFF), HP(SRC_OFF), 0x80000000u, &g_host);         /* the compare is signed: -2^31 is below every total */
    NCALLS(3);
    L.n = 0;
    m4e4337_load_blocks(HP(SELF_OFF), HP(SRC_OFF), 0x7fffffffu, &g_host);
    NCALLS(0);
    load_src(1601);                                                      /* 1601 * 0x29 = 0x10069: the word is 0x69 = 105 */
    L.n = 0;
    m4e4337_load_blocks(HP(SELF_OFF), HP(SRC_OFF), 0xda1u + 105u, &g_host);
    NCALLS(0);
    CK(g_mem[0x457b + 104] == g_mem[SRC_OFF + 0xda1 + 104] && g_mem[0x457b + 105] == 0xee);
    load_src(0);                                                         /* n = 0: no third copy */
    m4e4337_load_blocks(HP(SELF_OFF), HP(SRC_OFF), 0xda1u, &g_host);
    NCALLS(0);
    CK(g_mem[0x457b] == 0xee);
    load_src(799);                                                       /* 799 * 0x29 = 32759, the largest */
    m4e4337_load_blocks(HP(SELF_OFF), HP(SRC_OFF), 0x7fffffffu, &g_host);
    CK(g_mem[0x457b + 32758] == g_mem[SRC_OFF + 0xda1 + 32758] && g_mem[0x457b + 32759] == 0xee);
    load_src(-1);                                                        /* native rejection: -41 as a word is negative */
    L.n = 0;
    m4e4337_load_blocks(HP(SELF_OFF), HP(SRC_OFF), 0, &g_host);
    NCALLS(0);
    CK(g_mem[0x457b] == 0xee);
}

/* ---- 0x411a22 ------------------------------------------------------------------------------------------------------------------ */
static void test_m411a22_alloc_copy(void)
{
    int i;
    setup();
    for (i = 0; i < 0x40; i++) g_mem[SRC_OFF + i] = (uint8_t)(0x20 + i);
    set16(SRC_OFF + 0x23, 9);                                            /* below 10 and from 10 on both give 0x27 */
    set32(CELL_OFF, VA(DST_OFF + 1));
    set32(CELL_OFF + 4, VA(SRC_OFF));
    set32(CELL_OFF + 8, 5);
    g_w.word_5c39e3 = 2;
    script(0x51dc43, 0x12345678u, 0x12345678u);
    m411a22_alloc_copy(HP(CELL_OFF), HP(CELL_OFF + 4), HP(CELL_OFF + 8), &g_w, &g_host);
    NCALLS(1);
    CKC(0, 0x51dc43, 0, 1, 0x27);
    CK(get32(REC_OFF + 0x400 + 2 * 0x8d) == 0x12345678u);               /* the record of index 2 */
    CK(memcmp(HP(DST_OFF + 1), HP(SRC_OFF), 0x27) == 0 && g_mem[DST_OFF] == 0xee && g_mem[DST_OFF + 1 + 0x27] == 0xee);
    CK(get32(CELL_OFF + 4) == VA(SRC_OFF + 0x27) && get32(CELL_OFF + 8) == 5 + 0x27);
    CK(get32(CELL_OFF) == VA(DST_OFF + 1));                              /* the destination cell is not advanced */
    /* index -1 (sign extension), the word at +0x23 above 10, the trace call */
    set16(SRC_OFF + 0x23, 0x7fff);
    L.n = 0;
    g_w.word_5c39e3 = -1;
    g_w.word_63a4cd = 0x100;
    set32(CELL_OFF + 4, VA(SRC_OFF));
    m411a22_alloc_copy(HP(CELL_OFF), HP(CELL_OFF + 4), HP(CELL_OFF + 8), &g_w, &g_host);
    NCALLS(2);
    CKC(1, 0x44a2b7, 0, 1, 0x54144c);
    CK(get32(REC_OFF + 0x400 - 0x8d) == 0x12345678u);
    /* the failed allocation: the record gets 0, the reports follow, the copy goes on */
    g_nscript = 0;
    script(0x51dc43, 0, 0);
    L.n = 0;
    g_w.word_5c39e3 = 1;
    g_w.value_5bb57b = 0x77u;
    g_w.word_63a4cd = 0;
    set32(CELL_OFF + 4, VA(SRC_OFF));
    m411a22_alloc_copy(HP(CELL_OFF), HP(CELL_OFF + 4), HP(CELL_OFF + 8), &g_w, &g_host);
    NCALLS(4);
    CKC(1, 0x50ca3e, 0, 4, 0x63888b, 0x541404, 0x77u, 1);
    CKC(2, 0x42639d, 0x583979, 2, 0x541430, 0x63888b);
    CKC0(3, 0x4c97b4, 0x5cf659);
    CK(get32(REC_OFF + 0x400 + 0x8d) == 0);
    CK(memcmp(HP(DST_OFF + 1), HP(SRC_OFF), 0x27) == 0);
    /* overlap: destination four bytes above the source, copied forward dword by dword (the pattern repeats every four bytes) */
    setup();
    for (i = 0; i < 0x40; i++) g_mem[SRC_OFF + i] = (uint8_t)(0x30 + i);
    set16(SRC_OFF + 0x23, 0);
    set32(CELL_OFF, VA(SRC_OFF + 4));
    set32(CELL_OFF + 4, VA(SRC_OFF));
    script(0x51dc43, 1, 0);
    m411a22_alloc_copy(HP(CELL_OFF), HP(CELL_OFF + 4), HP(CELL_OFF + 8), &g_w, &g_host);
    CK(g_mem[SRC_OFF + 4] == 0x30 && g_mem[SRC_OFF + 8] == 0x30 && g_mem[SRC_OFF + 0x20] == 0x30 && g_mem[SRC_OFF + 0x2a] == 0x32);
    /* native rejection: an unresolvable source ends the function before any call */
    setup();
    set32(CELL_OFF + 4, 0x4000);
    L.n = 0;
    m411a22_alloc_copy(HP(CELL_OFF), HP(CELL_OFF + 4), HP(CELL_OFF + 8), &g_w, &g_host);
    NCALLS(0);
    /* native rejection: an unresolvable destination stops after the allocation and the record store, before the copy and the cell updates */
    setup();
    set32(CELL_OFF, 0x4000);
    set32(CELL_OFF + 4, VA(SRC_OFF));
    set32(CELL_OFF + 8, 9);
    script(0x51dc43, 5, 5);
    m411a22_alloc_copy(HP(CELL_OFF), HP(CELL_OFF + 4), HP(CELL_OFF + 8), &g_w, &g_host);
    NCALLS(1);
    CK(get32(REC_OFF + 0x400) == 5 && get32(CELL_OFF + 4) == VA(SRC_OFF) && get32(CELL_OFF + 8) == 9);
}

/* ---- bounded sweep ------------------------------------------------------------------------------------------------------------- */
static void test_sweep_bounded(void)
{
    uint32_t seed = 12345u;
    int it, i;
    for (it = 0; it < 300; it++) {
        setup();
        for (i = 0; i < ARENA_SZ; i++) { seed = seed * 1103515245u + 12345u; g_mem[i] = (uint8_t)(seed >> 16); }
        seed = seed * 1103515245u + 12345u;
        g_w.word_63a4cd = (int16_t)(seed >> 3);
        g_w.word_5c39e3 = (int16_t)((seed >> 5) % 5 - 2);
        g_w.word_5a1e5c = (int16_t)((seed >> 7) % 6);
        g_w.value_5d03bf = (seed & 1) ? VA(CELL_OFF + 0x10) : 0;
        g_w.word_5b4e04 = (seed & 2) ? 2 : 3;
        g_w.value_5e32c9 = seed >> 9;
        g_w.byte_5b61af = (uint8_t)(seed >> 11);
        g_w.byte_5b616b = (uint8_t)(seed >> 19);
        set32(0x252, (seed & 4) ? 0 : seed);
        script(0x437ea1, seed, seed >> 1);
        script(0x51dc43, (seed & 8) ? 0 : VA(DST_OFF + 0x100), 0);
        script(0x4ef516, seed, 0);
        m4ee69e_forward_if_set(HP(SELF_OFF), &g_host);
        set32(CELL_OFF, VA(CELL_OFF + 0x40));
        set32(CELL_OFF + 0x44, VA(CELL_OFF + 0x80));
        set32(CELL_OFF + 0x80 + 0x38, (seed & 16) ? VA(CELL_OFF + 0xc0) : 0);
        set32(CELL_OFF + 0xc0 + 0x38, 0);
        (void)m423aae_chain_end(VA(CELL_OFF), &g_host);
        (void)m4fccf2_store_percent(HP(SELF_OFF), seed, seed % 17u - 8u, &g_w, &g_host);
        set32(CELL_OFF + 0x100, (seed & 32) ? 0 : VA(DST_OFF));
        m423a30_free_cell(HP(CELL_OFF + 0x100), &g_w, &g_host);
        m42e72c_toggle_state(&g_w, &g_host);
        set32(CELL_OFF + 0x200, VA(DST_OFF + 0x40));
        set32(CELL_OFF + 0x204, VA(SRC_OFF + (seed & 0xff)));
        set32(CELL_OFF + 0x208, seed);
        m4e9c2f_copy_six(HP(CELL_OFF + 0x200), HP(CELL_OFF + 0x204), HP(CELL_OFF + 0x208), &g_w, &g_host);
        set16(CELL_OFF + 0x300, 0);
        (void)m4e45be_find_row(HP(CELL_OFF + 0x300), HP(SRC_OFF), (seed >> 9) % 6u, &g_w);
        m437dcd_note_key(HP(SELF_OFF), HP(CELL_OFF + 0x30), &g_w, &g_host);
        set16(SRC_OFF + 0x2f0 + 0xaaf, (uint16_t)(seed % 800u));
        m4e4337_load_blocks(HP(SELF_OFF), HP(SRC_OFF), seed, &g_host);
        set32(CELL_OFF + 0x400, VA(DST_OFF + 0x300));
        set32(CELL_OFF + 0x404, VA(SRC_OFF + 0x40));
        set32(CELL_OFF + 0x408, seed);
        m411a22_alloc_copy(HP(CELL_OFF + 0x400), HP(CELL_OFF + 0x404), HP(CELL_OFF + 0x408), &g_w, &g_host);
    }
    CK(1);
}

#define RUN(fn)                                                  \
    do {                                                         \
        g_failed = 0;                                            \
        g_msg[0] = 0;                                            \
        fn();                                                    \
        if (g_failed) { failures++; printf("FAIL %s: %s\n", #fn, g_msg); } \
        else printf("PASS %s\n", #fn);                           \
    } while (0)

int main(void)
{
    int failures = 0;
    RUN(test_m4ee69e_forward_if_set);
    RUN(test_m423aae_chain_end);
    RUN(test_m4fccf2_store_percent);
    RUN(test_m423a30_free_cell);
    RUN(test_m42e72c_toggle_state);
    RUN(test_m4e9c2f_copy_six);
    RUN(test_m4e45be_find_row);
    RUN(test_m437dcd_note_key);
    RUN(test_m4e4337_load_blocks);
    RUN(test_m411a22_alloc_copy);
    RUN(test_sweep_bounded);
    return failures;
}
