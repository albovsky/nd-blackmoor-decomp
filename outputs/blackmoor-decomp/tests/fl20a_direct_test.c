/* FL-20 (batch a) direct tests of the functions of GAME.EXE in src/original_methods_fl20a.c. Prints "PASS <name>" / "FAIL <name>: <msg>";
 * the exit status is the failure count. Fixtures are synthetic (no original bytes). Expected values come from the disassembly of
 * GAME.EXE, not from running the native code; tests/test_fl20a_differential.py additionally runs the original bytes on random fixtures.
 *   0x4d3c88  byte 0x61c6ad := 0
 *   0x4d3c5f  0x4d3c31 on this; non-zero -> 0x4d3d20 on this; byte [this+0x326] := 1
 *   0x41c509  record arg: words +0x21 = 0xc, +0x23 = 2, +0x25 = 1, +0x27 = 1, dword +0x29 = 1
 *   0x43ec4a / 0x43ec85 / 0x43ecc0 / 0x43ed71  callee (0x4db000 / 0x4dafc3 / 0x4db04f / 0x4daf9f) on 0x5830a6 with the addresses of the first two stack arguments, then 0x51ab4b on this
 *   0x475885  dword [+0x24], [+0x28] non-zero -> 0x4c2dfb on 0x5cf659 with the field address; word [+0x20] != -1 -> 0x4d3992(word); 0x4757da on this
 *   0x4caf03  eleven field stores (0 / 0xffff / 0xffffffff)
 *   0x41c770  record arg: ten field stores at +0x1b7 .. +0x1cf
 *   0x4757da  words +0x22 / +0x20 := 0xffff, dwords +0x89a / +0x89e / +0x1c := 0, ten rows of ten cells of five dwords cleared at +0x30 + i*0xc8 + j*0x14
 *   0x48bb86  [+0x22] != [+0x1e] -> 0x4c2dfb(+0x22); [+0x1e] != 0 and byte [+0x45] 0 -> 0x4c2dfb(+0x1e), byte 1 -> [+0x1e] := 0; words [+0x2e], [+0x30] != -1 -> 0x4d3992; 0x48bb17
 *   0x483fb5  [+0x1e], [+0x22] non-zero -> 0x4c2dfb(field), := 0; 20 x 4 cells at +0x4c + i*0x85 + j*0x18 likewise; word [+0x1c] != -1 -> 0x4d3992; 0x483f6a
 *   0x4343a2  as 0x434630 without the flag dword: first i with 0x434814(rec) equal to name -> [+0x112c] := 0x4347b8(rec+4), [+0x1120] := rec+8, strcpy(+0x1130), return 1
 *   0x44727a  record state (record +0x4d): 0 -> (byte [+0x1c] clear) copy 0x15 bytes to +0x49, rectangle from the origin globals or shifted, 0x4473a9, state := 2; 2 -> 0x42ba3a(word)
 *   0x42b87a  byte of the record object - 1 in 0..5: 0 / 4 set words 0x585d51 / 0x585d4f, 1 / 5 add them, 2 -> 0x4d3c5f, 3 / 4 / 5 -> 0x4d3c88 first; then 0x585d4b, GetTickCount + 0x5b0280 -> 0x585d55, 0x42ba3a(word) */
#include "../src/original_methods_fl20a.h"

#include <stdio.h>
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

#if defined(__GNUC__) || defined(__clang__)
#define UNUSED_OK __attribute__((unused))
#else
#define UNUSED_OK
#endif

#define OBJ 0x8400u
#define REC 0x8du

static void fill(uint8_t *o, size_t n, uint8_t seed)
{
    size_t i;
    for (i = 0; i < n; i++) o[i] = (uint8_t)(i * 7u + seed + (i >> 8));
}

UNUSED_OK static void set32(uint8_t *o, size_t off, uint32_t v) { memcpy(o + off, &v, 4); }
UNUSED_OK static void set16(uint8_t *o, size_t off, uint16_t v) { memcpy(o + off, &v, 2); }

UNUSED_OK static uint32_t get32(const uint8_t *o, size_t off)
{
    uint32_t v;
    memcpy(&v, o + off, 4);
    return v;
}

UNUSED_OK static uint16_t get16(const uint8_t *o, size_t off)
{
    uint16_t v;
    memcpy(&v, o + off, 2);
    return v;
}

/* ---- the call log of the host ----------------------------------------------------------------------------------------------- */

typedef struct Call {
    uint32_t callee;
    uintptr_t this_ptr;
    int n;
    uintptr_t a[8];
    uint8_t snap[32];       /* the bytes behind args[snap_arg] of the callee snap_callee, when asked for */
} Call;

typedef struct Region {
    uint32_t va;
    uint8_t *ptr;
    uint32_t len;
} Region;

typedef struct OutWrite {
    uint32_t callee;
    int call, arg, off, size;
    uint32_t value;
} OutWrite;

static struct {
    int n;
    Call c[512];
    uint32_t ret_callee[8], ret_value[8][64];  /* per-callee queue of return values (index by position) */
    int ret_count[8], ret_used[8];
    uint32_t snap_callee;
    int snap_arg, snap_len;
    OutWrite w[16];
    int nw;
    int calls_of[16];       /* per callee slot: how many calls were made (for OutWrite.call) */
    uint32_t calls_callee[16];
    Region regions[8];
    int nregions;
    uint32_t tick;
    int ticks;
} L;

static void reset_log(void) { memset(&L, 0, sizeof L); }

UNUSED_OK static void queue_return(uint32_t callee, uint32_t v)
{
    int i;
    for (i = 0; i < 8; i++) {
        if (L.ret_count[i] == 0 || L.ret_callee[i] == callee) {
            L.ret_callee[i] = callee;
            L.ret_value[i][L.ret_count[i]++] = v;
            return;
        }
    }
}

UNUSED_OK static void queue_write(uint32_t callee, int call, int arg, int off, int size, uint32_t value)
{
    OutWrite *w = &L.w[L.nw++];
    w->callee = callee;
    w->call = call;
    w->arg = arg;
    w->off = off;
    w->size = size;
    w->value = value;
}

static uint32_t h_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int i, k, nth = 0;
    (void)ctx;
    for (i = 0; i < 16; i++) {
        if (L.calls_of[i] == 0 || L.calls_callee[i] == callee) {
            L.calls_callee[i] = callee;
            nth = L.calls_of[i]++;
            break;
        }
    }
    if (L.n < 512) {
        Call *c = &L.c[L.n];
        c->callee = callee;
        c->this_ptr = this_ptr;
        c->n = nargs;
        for (k = 0; k < nargs && k < 8; k++) c->a[k] = args[k];
        if (callee == L.snap_callee && L.snap_len > 0) memcpy(c->snap, (const void *)args[L.snap_arg], (size_t)L.snap_len);
    }
    L.n++;
    for (i = 0; i < L.nw; i++) {
        const OutWrite *w = &L.w[i];
        if (w->callee == callee && w->call == nth) {
            uint8_t *p = (uint8_t *)args[w->arg] + w->off;
            if (w->size == 2) {
                uint16_t v = (uint16_t)w->value;
                memcpy(p, &v, 2);
            } else {
                memcpy(p, &w->value, 4);
            }
        }
    }
    for (i = 0; i < 8; i++)
        if (L.ret_count[i] != 0 && L.ret_callee[i] == callee) {
            uint32_t v = L.ret_value[i][L.ret_used[i] < L.ret_count[i] ? L.ret_used[i] : L.ret_count[i] - 1];
            L.ret_used[i]++;
            return v;
        }
    return 0;
}

static const uint8_t *h_resolve(void *ctx, uint32_t va)
{
    int i;
    (void)ctx;
    for (i = 0; i < L.nregions; i++)
        if (va >= L.regions[i].va && va < L.regions[i].va + L.regions[i].len) return L.regions[i].ptr + (va - L.regions[i].va);
    return NULL;
}

static uint32_t h_tick(void *ctx)
{
    (void)ctx;
    L.ticks++;
    return L.tick;
}

UNUSED_OK static void add_region(uint32_t va, uint8_t *ptr, uint32_t len)
{
    L.regions[L.nregions].va = va;
    L.regions[L.nregions].ptr = ptr;
    L.regions[L.nregions].len = len;
    L.nregions++;
}

static Fl18Host host(void)
{
    Fl18Host h;
    memset(&h, 0, sizeof h);
    h.call = h_call;
    h.resolve = h_resolve;
    h.tick = h_tick;
    return h;
}

UNUSED_OK static int is_call(int k, uint32_t callee, uintptr_t this_ptr, int n)
{
    return k < L.n && k < 512 && L.c[k].callee == callee && L.c[k].this_ptr == this_ptr && L.c[k].n == n;
}

#define RUN(fn)                                  \
    do {                                         \
        g_failed = 0;                            \
        g_msg[0] = 0;                            \
        reset_log();                             \
        fn();                                    \
        if (g_failed) {                          \
            printf("FAIL %s: %s\n", #fn, g_msg); \
            failures++;                          \
        } else                                   \
            printf("PASS %s\n", #fn);            \
    } while (0)

static uint8_t g_obj[OBJ], g_exp[OBJ];

/* ---- tests ---------------------------------------------------------------------------------------------------------------- */

static void test_m4d3c88_clear_flag(void)
{
    Fl20aWorld w, e;
    memset(&w, 0x5a, sizeof w);
    w.byte_61c6ad = 0xa5;
    e = w;
    e.byte_61c6ad = 0;
    m4d3c88_clear_flag(&w);
    CK(memcmp(&w, &e, sizeof w) == 0);
    m4d3c88_clear_flag(&w);   /* already clear */
    CK(memcmp(&w, &e, sizeof w) == 0 && L.n == 0);
}

static void test_m4d3c5f_set_ready(void)
{
    Fl18Host h = host();
    fill(g_obj, OBJ, 4);
    memcpy(g_exp, g_obj, OBJ);
    queue_return(0x4d3c31, 1);
    m4d3c5f_set_ready(g_obj, &h);
    g_exp[0x326] = 1;
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    CK(L.n == 2 && is_call(0, 0x4d3c31, (uintptr_t)g_obj, 0) && is_call(1, 0x4d3d20, (uintptr_t)g_obj, 0));
    /* the full eax is tested: 0x100 is non-zero */
    reset_log();
    fill(g_obj, OBJ, 4);
    queue_return(0x4d3c31, 0x100);
    m4d3c5f_set_ready(g_obj, &h);
    CK(memcmp(g_obj, g_exp, OBJ) == 0 && L.n == 2);
    /* zero: the second call is skipped, the byte is still set */
    reset_log();
    fill(g_obj, OBJ, 4);
    queue_return(0x4d3c31, 0);
    m4d3c5f_set_ready(g_obj, &h);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    CK(L.n == 1 && is_call(0, 0x4d3c31, (uintptr_t)g_obj, 0));
}

static void test_m41c509_init_fields(void)
{
    fill(g_obj, OBJ, 21);
    memcpy(g_exp, g_obj, OBJ);
    m41c509_init_fields(g_obj);
    set16(g_exp, 0x21, 0xc);
    set16(g_exp, 0x23, 2);
    set16(g_exp, 0x25, 1);
    set16(g_exp, 0x27, 1);
    set32(g_exp, 0x29, 1);
    CK(memcmp(g_obj, g_exp, OBJ) == 0 && L.n == 0);
    CK(get16(g_obj, 0x21) == 0xc && get32(g_obj, 0x29) == 1);
}

/* the four sibling methods: callee on 0x5830a6 with the addresses of the first two stack arguments, then 0x51ab4b on this */
typedef void (*SiblingFn)(uintptr_t, uint32_t, uint32_t, uint32_t, const Fl18Host *);

static void check_sibling(SiblingFn fn, uint32_t callee)
{
    Fl18Host h = host();
    uint8_t *bytes;
    L.snap_callee = callee;
    L.snap_arg = 0;
    L.snap_len = 12;
    fn(0x00ab1234u, 0x11223344u, 0x55667788u, 0x99aabbccu, &h);
    CK(L.n == 2);
    CK(is_call(0, callee, 0x5830a6, 2));
    CK(L.c[0].a[0] != 0 && L.c[0].a[1] == L.c[0].a[0] + 4);   /* consecutive stack dwords */
    bytes = L.c[0].snap;
    CK(get32(bytes, 0) == 0x11223344u && get32(bytes, 4) == 0x55667788u && get32(bytes, 8) == 0x99aabbccu);
    CK(is_call(1, 0x51ab4b, 0x00ab1234u, 0));
    /* another set of values and another this */
    reset_log();
    L.snap_callee = callee;
    L.snap_arg = 0;
    L.snap_len = 12;
    fn(0x00cd5678u, 0, 0xffffffffu, 7, &h);
    CK(L.n == 2 && is_call(0, callee, 0x5830a6, 2) && is_call(1, 0x51ab4b, 0x00cd5678u, 0));
    CK(get32(L.c[0].snap, 0) == 0 && get32(L.c[0].snap, 4) == 0xffffffffu && get32(L.c[0].snap, 8) == 7);
}

static void test_m43ec4a_forward_4db000(void) { check_sibling(m43ec4a_forward_4db000, 0x4db000); }
static void test_m43ec85_forward_4dafc3(void) { check_sibling(m43ec85_forward_4dafc3, 0x4dafc3); }
static void test_m43ecc0_forward_4db04f(void) { check_sibling(m43ecc0_forward_4db04f, 0x4db04f); }
static void test_m43ed71_forward_4daf9f(void) { check_sibling(m43ed71_forward_4daf9f, 0x4daf9f); }

static void test_m475885_release(void)
{
    Fl18Host h = host();
    fill(g_obj, OBJ, 33);
    set32(g_obj, 0x24, 0x1111);
    set32(g_obj, 0x28, 0x2222);
    set16(g_obj, 0x20, 7);
    memcpy(g_exp, g_obj, OBJ);
    m475885_release(g_obj, &h);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);   /* the object itself is not written */
    CK(L.n == 4);
    CK(is_call(0, 0x4c2dfb, 0x5cf659, 1) && L.c[0].a[0] == (uintptr_t)(g_obj + 0x24));
    CK(is_call(1, 0x4c2dfb, 0x5cf659, 1) && L.c[1].a[0] == (uintptr_t)(g_obj + 0x28));
    CK(is_call(2, 0x4d3992, 0, 1) && (L.c[2].a[0] & 0xffff) == 7);
    CK(is_call(3, 0x4757da, (uintptr_t)g_obj, 0));
    /* only the second field set, the word is -1 (the upper half of the dword is not looked at) */
    reset_log();
    set32(g_obj, 0x24, 0);
    set16(g_obj, 0x20, 0xffff);
    m475885_release(g_obj, &h);
    CK(L.n == 2 && is_call(0, 0x4c2dfb, 0x5cf659, 1) && L.c[0].a[0] == (uintptr_t)(g_obj + 0x28));
    CK(is_call(1, 0x4757da, (uintptr_t)g_obj, 0));
    /* only the first field set, the word is -2: it is called, with 0xfffe */
    reset_log();
    set32(g_obj, 0x24, 0x80000000u);
    set32(g_obj, 0x28, 0);
    set16(g_obj, 0x20, 0xfffe);
    m475885_release(g_obj, &h);
    CK(L.n == 3 && is_call(0, 0x4c2dfb, 0x5cf659, 1) && L.c[0].a[0] == (uintptr_t)(g_obj + 0x24));
    CK(is_call(1, 0x4d3992, 0, 1) && (L.c[1].a[0] & 0xffff) == 0xfffe && is_call(2, 0x4757da, (uintptr_t)g_obj, 0));
    /* nothing set */
    reset_log();
    set32(g_obj, 0x24, 0);
    set16(g_obj, 0x20, 0);
    m475885_release(g_obj, &h);
    CK(L.n == 2 && is_call(0, 0x4d3992, 0, 1) && (L.c[0].a[0] & 0xffff) == 0 && is_call(1, 0x4757da, (uintptr_t)g_obj, 0));
}

static void test_m4caf03_reset(void)
{
    fill(g_obj, OBJ, 99);
    memcpy(g_exp, g_obj, OBJ);
    m4caf03_reset(g_obj);
    set32(g_exp, 0x16, 0);
    set32(g_exp, 0x1a, 0);
    set16(g_exp, 0xc, 0xffff);
    set32(g_exp, 0xe, 0);
    set32(g_exp, 0x8, 0);
    set32(g_exp, 0x14e, 0);
    set32(g_exp, 0x12, 0);
    set32(g_exp, 0x154, 0);
    set32(g_exp, 0x158, 0);
    set32(g_exp, 0x14a, 0xffffffffu);
    set32(g_exp, 0x15c, 0);
    CK(memcmp(g_obj, g_exp, OBJ) == 0 && L.n == 0);
    CK(get16(g_obj, 0xc) == 0xffff && get32(g_obj, 0x14a) == 0xffffffffu && get32(g_obj, 0x15c) == 0);
}

static void test_m41c770_init_fields(void)
{
    fill(g_obj, OBJ, 61);
    memcpy(g_exp, g_obj, OBJ);
    m41c770_init_fields(g_obj);
    g_exp[0x1b7] = 0;
    set16(g_exp, 0x1ba, 0);
    set16(g_exp, 0x1bc, 0);
    set16(g_exp, 0x1be, 1);
    set32(g_exp, 0x1c0, 0);
    set32(g_exp, 0x1c4, 0);
    set32(g_exp, 0x1c8, 1);
    set16(g_exp, 0x1cc, 0xffff);
    g_exp[0x1ce] = 1;
    set16(g_exp, 0x1cf, 2);
    CK(memcmp(g_obj, g_exp, OBJ) == 0 && L.n == 0);
    CK(get32(g_obj, 0x1c8) == 1 && get16(g_obj, 0x1cf) == 2 && g_obj[0x1ce] == 1);
}

static void test_m4757da_clear_grid(void)
{
    memset(g_obj, 0xa5, OBJ);
    memcpy(g_exp, g_obj, OBJ);
    m4757da_clear_grid(g_obj);
    set16(g_exp, 0x22, 0xffff);
    set16(g_exp, 0x20, 0xffff);
    set32(g_exp, 0x89a, 0);
    set32(g_exp, 0x89e, 0);
    set32(g_exp, 0x1c, 0);
    memset(g_exp + 0x30, 0, 10 * 10 * 5 * 4);   /* ten rows of 0xc8 bytes, each ten cells of 0x14 bytes: 0x30 .. 0x7ff */
    CK(memcmp(g_obj, g_exp, OBJ) == 0 && L.n == 0);
    CK(g_obj[0x2f] == 0xa5 && g_obj[0x800] == 0xa5 && g_obj[0x30] == 0 && g_obj[0x7ff] == 0);
}

static void test_m48bb86_release(void)
{
    Fl18Host h = host();
    /* [0x22] differs from [0x1e], [0x1e] set, byte [0x45] = 0: both are released; both words are not -1 */
    fill(g_obj, OBJ, 12);
    set32(g_obj, 0x1e, 0x1000);
    set32(g_obj, 0x22, 0x2000);
    g_obj[0x45] = 0;
    set16(g_obj, 0x2e, 4);
    set16(g_obj, 0x30, 0xfffe);
    memcpy(g_exp, g_obj, OBJ);
    m48bb86_release(g_obj, &h);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    CK(L.n == 5);
    CK(is_call(0, 0x4c2dfb, 0x5cf659, 1) && L.c[0].a[0] == (uintptr_t)(g_obj + 0x22));
    CK(is_call(1, 0x4c2dfb, 0x5cf659, 1) && L.c[1].a[0] == (uintptr_t)(g_obj + 0x1e));
    CK(is_call(2, 0x4d3992, 0, 1) && (L.c[2].a[0] & 0xffff) == 4);
    CK(is_call(3, 0x4d3992, 0, 1) && (L.c[3].a[0] & 0xffff) == 0xfffe);
    CK(is_call(4, 0x48bb17, (uintptr_t)g_obj, 0));
    /* the two dwords are equal, byte [0x45] = 1: [0x1e] := 0 without a call; [0x2e] = -1, [0x30] = 5 */
    reset_log();
    set32(g_obj, 0x22, 0x1000);
    g_obj[0x45] = 1;
    set16(g_obj, 0x2e, 0xffff);
    set16(g_obj, 0x30, 5);
    memcpy(g_exp, g_obj, OBJ);
    m48bb86_release(g_obj, &h);
    set32(g_exp, 0x1e, 0);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    CK(L.n == 2 && is_call(0, 0x4d3992, 0, 1) && (L.c[0].a[0] & 0xffff) == 5 && is_call(1, 0x48bb17, (uintptr_t)g_obj, 0));
    /* [0x1e] = 0 and [0x22] differs: only [0x22] is released, nothing is stored, byte [0x45] does not matter */
    reset_log();
    set32(g_obj, 0x1e, 0);
    set32(g_obj, 0x22, 0x3000);
    g_obj[0x45] = 1;
    set16(g_obj, 0x2e, 0xffff);
    set16(g_obj, 0x30, 0xffff);
    memcpy(g_exp, g_obj, OBJ);
    m48bb86_release(g_obj, &h);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    CK(L.n == 2 && is_call(0, 0x4c2dfb, 0x5cf659, 1) && L.c[0].a[0] == (uintptr_t)(g_obj + 0x22) && is_call(1, 0x48bb17, (uintptr_t)g_obj, 0));
    /* [0x1e] set and equal to [0x22], byte [0x45] = 2: neither a call nor a store */
    reset_log();
    set32(g_obj, 0x1e, 0x4000);
    set32(g_obj, 0x22, 0x4000);
    g_obj[0x45] = 2;
    memcpy(g_exp, g_obj, OBJ);
    m48bb86_release(g_obj, &h);
    CK(memcmp(g_obj, g_exp, OBJ) == 0 && L.n == 1 && is_call(0, 0x48bb17, (uintptr_t)g_obj, 0));
    /* both zero: only the final call */
    reset_log();
    set32(g_obj, 0x1e, 0);
    set32(g_obj, 0x22, 0);
    g_obj[0x45] = 0;
    memcpy(g_exp, g_obj, OBJ);
    m48bb86_release(g_obj, &h);
    CK(memcmp(g_obj, g_exp, OBJ) == 0 && L.n == 1 && is_call(0, 0x48bb17, (uintptr_t)g_obj, 0));
}

static void test_m483fb5_release_all(void)
{
    Fl18Host h = host();
    ptrdiff_t cells[5];
    int k;
    memset(g_obj, 0, OBJ);
    set32(g_obj, 0x1e, 0x1111);
    set32(g_obj, 0x22, 0x2222);
    set16(g_obj, 0x1c, 3);
    cells[0] = 0x4c;                      /* i = 0, j = 0 */
    cells[1] = 0x4c + 3 * 0x18;           /* i = 0, j = 3 */
    cells[2] = 0x4c + 0x85 + 2 * 0x18;    /* i = 1, j = 2 */
    cells[3] = 0x4c + 19 * 0x85 + 3 * 0x18;  /* i = 19, j = 3 */
    cells[4] = 0x4c + 7 * 0x85 + 1 * 0x18;
    for (k = 0; k < 5; k++) set32(g_obj, (size_t)cells[k], 0x100u + (uint32_t)k);
    set32(g_obj, 0x4c + 4 * 0x18, 0x7777);        /* j = 4 of row 0: not in the loop */
    set32(g_obj, 0x4c + 20 * 0x85, 0x8888);       /* i = 20: not in the loop */
    memcpy(g_exp, g_obj, OBJ);
    m483fb5_release_all(g_obj, &h);
    set32(g_exp, 0x1e, 0);
    set32(g_exp, 0x22, 0);
    for (k = 0; k < 5; k++) set32(g_exp, (size_t)cells[k], 0);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    CK(L.n == 2 + 5 + 1 + 1);
    CK(is_call(0, 0x4c2dfb, 0x5cf659, 1) && L.c[0].a[0] == (uintptr_t)(g_obj + 0x1e));
    CK(is_call(1, 0x4c2dfb, 0x5cf659, 1) && L.c[1].a[0] == (uintptr_t)(g_obj + 0x22));
    /* the cells in row-major order: (0,0), (0,3), (1,2), (7,1), (19,3) */
    CK(is_call(2, 0x4c2dfb, 0x5cf659, 1) && L.c[2].a[0] == (uintptr_t)(g_obj + cells[0]));
    CK(is_call(3, 0x4c2dfb, 0x5cf659, 1) && L.c[3].a[0] == (uintptr_t)(g_obj + cells[1]));
    CK(is_call(4, 0x4c2dfb, 0x5cf659, 1) && L.c[4].a[0] == (uintptr_t)(g_obj + cells[2]));
    CK(is_call(5, 0x4c2dfb, 0x5cf659, 1) && L.c[5].a[0] == (uintptr_t)(g_obj + cells[4]));
    CK(is_call(6, 0x4c2dfb, 0x5cf659, 1) && L.c[6].a[0] == (uintptr_t)(g_obj + cells[3]));
    CK(is_call(7, 0x4d3992, 0, 1) && (L.c[7].a[0] & 0xffff) == 3);
    CK(is_call(8, 0x483f6a, (uintptr_t)g_obj, 0));
    /* only [0x22] set, the word is -1, no cell */
    reset_log();
    memset(g_obj, 0, OBJ);
    set32(g_obj, 0x22, 0x2222);
    set16(g_obj, 0x1c, 0xffff);
    memcpy(g_exp, g_obj, OBJ);
    m483fb5_release_all(g_obj, &h);
    set32(g_exp, 0x22, 0);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    CK(L.n == 2 && is_call(0, 0x4c2dfb, 0x5cf659, 1) && L.c[0].a[0] == (uintptr_t)(g_obj + 0x22) && is_call(1, 0x483f6a, (uintptr_t)g_obj, 0));
    /* only [0x1e] set */
    reset_log();
    memset(g_obj, 0, OBJ);
    set32(g_obj, 0x1e, 0x80000000u);
    set16(g_obj, 0x1c, 0xffff);
    memcpy(g_exp, g_obj, OBJ);
    m483fb5_release_all(g_obj, &h);
    set32(g_exp, 0x1e, 0);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    CK(L.n == 2 && L.c[0].a[0] == (uintptr_t)(g_obj + 0x1e) && is_call(1, 0x483f6a, (uintptr_t)g_obj, 0));
}

static void test_m4343a2_find_name(void)
{
    static uint8_t names[0x200];
    static uint8_t big[0x6400], expect[0x6400];
    Fl20aWorld w;
    Fl18Host h = host();
    uint32_t va = 0x00c40000u;
    int32_t r;
    (void)w;
    fill(big, sizeof big, 3);
    memset(names, 0, sizeof names);
    memcpy(names + 0x00, "ab", 3);      /* 0: prefix of the name */
    memcpy(names + 0x20, "abxd", 5);    /* 1: differs in the 3rd byte */
    memcpy(names + 0x40, "abcd", 5);    /* 2: equal, with the flag dword set: still taken (no flag is tested) */
    memcpy(names + 0x60, "abcd", 5);    /* 3: never reached */
    add_region(va, names, sizeof names);
    set32(big, 0x5f68, 4);
    set32(big, 0x20e4, 0x1000);
    set32(big, 0x20e8, 0x2000);
    set32(big, 0x20ec, 0x3000);
    set32(big, 0x20f0, 0x4000);
    set32(big, 0x4fc4 + 8, 1);
    queue_return(0x434814, va);
    queue_return(0x434814, va + 0x20);
    queue_return(0x434814, va + 0x40);
    queue_return(0x434814, va + 0x60);
    queue_return(0x4347b8, 0x0badf00du);
    memcpy(expect, big, sizeof big);
    r = m4343a2_find_name(big, (const uint8_t *)"abcd", &h);
    set32(expect, 0x112c, 0x0badf00du);
    set32(expect, 0x1120, 0x3000 + 8);
    memcpy(expect + 0x1130, "abcd", 5);
    CK(r == 1 && memcmp(big, expect, sizeof big) == 0);   /* [0x4fc4 + 8] stays 1 */
    CK(L.n == 4 && is_call(0, 0x434814, (uintptr_t)big, 1) && L.c[0].a[0] == 0x1000 && L.c[1].a[0] == 0x2000 && L.c[2].a[0] == 0x3000);
    CK(is_call(3, 0x4347b8, (uintptr_t)big, 1) && L.c[3].a[0] == 0x3000 + 4);
    /* nothing equal: the name longer than the string, the string longer than the name */
    reset_log();
    add_region(va, names, sizeof names);
    queue_return(0x434814, va);
    set32(big, 0x5f68, 1);
    memcpy(expect, big, sizeof big);
    CK(m4343a2_find_name(big, (const uint8_t *)"abc", &h) == 0 && L.n == 1 && memcmp(big, expect, sizeof big) == 0);
    reset_log();
    add_region(va, names, sizeof names);
    queue_return(0x434814, va + 0x40);
    CK(m4343a2_find_name(big, (const uint8_t *)"abcde", &h) == 0 && L.n == 1 && memcmp(big, expect, sizeof big) == 0);
    /* the empty name and an empty string: equal; the terminator alone is copied */
    reset_log();
    add_region(va, names, sizeof names);
    queue_return(0x434814, va + 0x100);
    queue_return(0x4347b8, 5);
    memset(big + 0x1130, 0x77, 8);
    CK(m4343a2_find_name(big, (const uint8_t *)"", &h) == 1 && big[0x1130] == 0 && big[0x1131] == 0x77 && get32(big, 0x112c) == 5);
    CK(get32(big, 0x1120) == 0x1000 + 8);
    /* a count of 0 or a negative count: nothing is called */
    reset_log();
    set32(big, 0x5f68, 0);
    CK(m4343a2_find_name(big, (const uint8_t *)"", &h) == 0 && L.n == 0);
    set32(big, 0x5f68, 0xffffffffu);
    CK(m4343a2_find_name(big, (const uint8_t *)"", &h) == 0 && L.n == 0);
}

static void test_m44727a_start_record(void)
{
    static uint8_t rec_table[REC * 8];
    static uint8_t src[0x40], expect_table[REC * 8];
    static const uint32_t va = 0x00c20000u;
    Fl20aWorld w;
    Fl18Host h = host();
    uint8_t *self = g_obj;
    int combo;
    memset(&w, 0, sizeof w);
    w.records_5bb5e5 = rec_table + REC;   /* one record of slack below, for a negative index */
    w.origin_x_583186 = 0x11;
    w.origin_y_58318a = 0x22;
    w.corner_x_58318e = 0x33;
    w.corner_y_583192 = 0x44;
    /* the four combinations of dword[0x5a] - dword[0x52] == 0 and dword[0x56] - dword[0x4e] == 0 */
    for (combo = 0; combo < 4; combo++) {
        int zero_y = combo & 1, zero_x = (combo >> 1) & 1;
        reset_log();
        add_region(va, src, sizeof src);
        fill(self, OBJ, 8);
        fill(src, sizeof src, 90);
        memset(rec_table, 0, sizeof rec_table);
        set32(rec_table, REC + 2 * REC, va);
        set32(rec_table, REC + 2 * REC + 0x4d, 0);
        self[0x1c] = 0;
        set32(src, 5, 10);                 /* -> [self+0x4e] */
        set32(src, 9, 3);                  /* -> [self+0x52] */
        set32(src, 0xd, zero_x ? 10 : 7);  /* -> [self+0x56] */
        set32(src, 0x11, zero_y ? 3 : 5);  /* -> [self+0x5a] */
        set32(self, 0x1d, 100);
        set32(self, 0x21, 200);
        set32(self, 0x25, 0x1234);
        set32(self, 0x29, 0x5678);
        memcpy(g_exp, self, OBJ);
        memcpy(expect_table, rec_table, sizeof rec_table);
        m44727a_start_record(self, 2, &w, &h);
        g_exp[0x1c] = 1;
        memcpy(g_exp + 0x49, src, 0x15);
        if (zero_x || zero_y) {
            set32(g_exp, 0x1d, 0x11);
            set32(g_exp, 0x21, 0x22);
            set32(g_exp, 0x25, 0x33);
            set32(g_exp, 0x29, 0x44);
        } else {
            set32(g_exp, 0x21, 200 + 3);
            set32(g_exp, 0x29, 5 + 0x22);
            set32(g_exp, 0x1d, 100 + 10);
            set32(g_exp, 0x25, 7 + 0x11);
        }
        set32(expect_table, REC + 2 * REC + 0x4d, 2);
        CK(memcmp(self, g_exp, OBJ) == 0);
        CK(memcmp(rec_table, expect_table, sizeof rec_table) == 0);
        CK(L.n == 1 && is_call(0, 0x4473a9, (uintptr_t)self, 0));
    }
    /* byte [0x1c] already set: nothing happens, not even the state */
    reset_log();
    add_region(va, src, sizeof src);
    fill(self, OBJ, 8);
    self[0x1c] = 0x80;
    memcpy(g_exp, self, OBJ);
    memcpy(expect_table, rec_table, sizeof rec_table);
    set32(rec_table, REC + 2 * REC + 0x4d, 0);
    set32(expect_table, REC + 2 * REC + 0x4d, 0);
    m44727a_start_record(self, 2, &w, &h);
    CK(memcmp(self, g_exp, OBJ) == 0 && memcmp(rec_table, expect_table, sizeof rec_table) == 0 && L.n == 0);
    /* state 2: 0x42ba3a with the word; nothing is written */
    reset_log();
    set32(rec_table, REC + 2 * REC + 0x4d, 2);
    set32(expect_table, REC + 2 * REC + 0x4d, 2);
    m44727a_start_record(self, 2, &w, &h);
    CK(memcmp(self, g_exp, OBJ) == 0 && memcmp(rec_table, expect_table, sizeof rec_table) == 0);
    CK(L.n == 1 && is_call(0, 0x42ba3a, 0, 1) && (L.c[0].a[0] & 0xffff) == 2);
    /* a negative index addresses the slack record */
    reset_log();
    set32(rec_table, 0x4d, 2);
    memcpy(expect_table, rec_table, sizeof rec_table);
    m44727a_start_record(self, -1, &w, &h);
    CK(L.n == 1 && is_call(0, 0x42ba3a, 0, 1) && (L.c[0].a[0] & 0xffff) == 0xffff && memcmp(rec_table, expect_table, sizeof rec_table) == 0);
    /* any other state: nothing */
    {
        static const uint32_t states[] = {1, 3, 0x100, 0x80000000u, 0xffffffffu};
        int k;
        for (k = 0; k < 5; k++) {
            reset_log();
            set32(rec_table, REC + 2 * REC + 0x4d, states[k]);
            memcpy(expect_table, rec_table, sizeof rec_table);
            m44727a_start_record(self, 2, &w, &h);
            CK(memcmp(self, g_exp, OBJ) == 0 && memcmp(rec_table, expect_table, sizeof rec_table) == 0 && L.n == 0);
        }
    }
}

static void test_m42b87a_apply_record(void)
{
    static uint8_t rec_table[REC * 8];
    static uint8_t obj[0x20];
    static const uint32_t va = 0x00c30000u;
    Fl20aWorld w, e;
    Fl18Host h = host();
    int kind;
    memset(&w, 0, sizeof w);
    w.records_5bb5e5 = rec_table;
    for (kind = 0; kind <= 8; kind++) {
        int16_t a = 0x7fff, b = (int16_t)0xfffe;   /* the words before: 0x585d51, 0x585d4f */
        int16_t n1 = 0x1234, n3 = (int16_t)0xfedc;  /* the words of the record object at +1, +3 */
        int16_t exp_a = a, exp_b = b;
        int expect_calls = 1, k = 0;
        uint32_t first = 0, second = 0;
        reset_log();
        add_region(va, obj, sizeof obj);
        memset(rec_table, 0, sizeof rec_table);
        set32(rec_table, 3 * REC, va);
        memset(obj, 0xcc, sizeof obj);
        obj[0] = (uint8_t)(kind == 8 ? 0xff : kind);   /* 0, 7 and 0xff: outside the table */
        set16(obj, 1, (uint16_t)n1);
        set16(obj, 3, (uint16_t)n3);
        w.word_585d51 = a;
        w.word_585d4f = b;
        w.word_5b0280 = (int16_t)0xfff0;     /* -16 */
        w.value_585d4b = 0xdeadbeefu;
        w.value_585d55 = 0xdeadbeefu;
        L.tick = 5000;
        e = w;
        if (kind == 1 || kind == 5) { exp_a = n1; exp_b = n3; }
        if (kind == 2 || kind == 6) { exp_a = (int16_t)(a + n1); exp_b = (int16_t)(b + n3); }
        if (kind == 3) { first = 0x4d3c5f; expect_calls = 2; }
        if (kind == 4 || kind == 5 || kind == 6) { first = 0x4d3c88; expect_calls = 2; }
        (void)second;
        m42b87a_apply_record(3, &w, &h);
        e.word_585d51 = exp_a;
        e.word_585d4f = exp_b;
        e.value_585d4b = (uint32_t)((int32_t)exp_a * 0x3c + (int32_t)exp_b);
        e.value_585d55 = 5000u - 16u;
        CK(memcmp(&w, &e, sizeof w) == 0);
        CK(L.n == expect_calls && L.ticks == 1);
        if (first != 0) {
            CK(is_call(k, first, 0x61c387, 0));
            k++;
        }
        CK(is_call(k, 0x42ba3a, 0, 1) && (L.c[k].a[0] & 0xffff) == 3);
        CK(get32(rec_table, 3 * REC) == va && obj[5] == 0xcc);
    }
    /* known values: kind 1 gives 0x1234 * 0x3c + (-292) */
    reset_log();
    add_region(va, obj, sizeof obj);
    obj[0] = 1;
    L.tick = 0xfffffff0u;
    w.word_5b0280 = 0x40;
    m42b87a_apply_record(3, &w, &h);
    CK(w.word_585d51 == 0x1234 && w.word_585d4f == (int16_t)0xfedc && w.value_585d4b == 0x1234u * 0x3cu - 292u);
    CK(w.value_585d4b == 279308u && w.value_585d55 == 0x30u);   /* GetTickCount + 0x40 wraps */
    /* kind 2 adds with 16-bit wrap: 0x7fff + 2 = -32767 */
    reset_log();
    add_region(va, obj, sizeof obj);
    obj[0] = 2;
    set16(obj, 1, 2);
    set16(obj, 3, 0xffff);
    w.word_585d51 = 0x7fff;
    w.word_585d4f = (int16_t)0xfffe;
    m42b87a_apply_record(3, &w, &h);
    CK(w.word_585d51 == -32767 && w.word_585d4f == -3 && w.value_585d4b == (uint32_t)(-32767 * 60 - 3));
    /* a negative index addresses the record below: here the table starts one record up */
    {
        static uint8_t wide[REC * 3];
        reset_log();
        add_region(va, obj, sizeof obj);
        memset(wide, 0, sizeof wide);
        set32(wide, 0, va);
        w.records_5bb5e5 = wide + REC;
        obj[0] = 1;
        set16(obj, 1, 9);
        set16(obj, 3, 8);
        m42b87a_apply_record(-1, &w, &h);
        CK(w.word_585d51 == 9 && w.word_585d4f == 8 && L.n == 1 && is_call(0, 0x42ba3a, 0, 1) && (L.c[0].a[0] & 0xffff) == 0xffff);
    }
}

/* TESTS-END */

int main(void)
{
    int failures = 0;
    RUN(test_m4d3c88_clear_flag);
    RUN(test_m4d3c5f_set_ready);
    RUN(test_m41c509_init_fields);
    RUN(test_m43ec4a_forward_4db000);
    RUN(test_m43ec85_forward_4dafc3);
    RUN(test_m43ecc0_forward_4db04f);
    RUN(test_m43ed71_forward_4daf9f);
    RUN(test_m475885_release);
    RUN(test_m4caf03_reset);
    RUN(test_m41c770_init_fields);
    RUN(test_m4757da_clear_grid);
    RUN(test_m48bb86_release);
    RUN(test_m483fb5_release_all);
    RUN(test_m4343a2_find_name);
    RUN(test_m44727a_start_record);
    RUN(test_m42b87a_apply_record);
    /* RUN-END */
    return failures;
}
