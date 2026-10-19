/* FL-19 (batch b) direct tests of the functions of GAME.EXE in src/original_methods_fl19b.c. Prints "PASS <name>" / "FAIL <name>: <msg>";
 * the exit status is the failure count. Fixtures are synthetic (no original bytes). Expected values come from the disassembly of
 * GAME.EXE, not from running the native code; tests/test_fl19b_differential.py additionally runs the original bytes on random fixtures.
 *   0x41f986  per slot k < 0x1e: 0x51e745, 0x51ea75 (0x190) whose result buffer is cleared (0x190 bytes), 0x51eac4 (-1); then 0x51e745 on this + 0xf1d
 *   0x4d00f4  per k < word [rec+0x21] of record word 0x5b5159: the rectangle at rec + k*16 + 0x123 (+ origin); 0x4c5377 on 0x5cf659 with byte 0x5b5128[k] ? (0x5d1a83, 0x5cf665, rec+k*16+0x23, &r, 0x559f30) : (0x5d15e3, 0x5cf665, rec+k*16+0x123, &r, 0x559f4c)
 *   0x447ac7  0x4c3efb fills a local (p = dword +0x24, stride = dword +0x10); rows [this+0x41] x cols [this+0x45] step 2: words at p + col split into 3 dwords per entry by the shifts / masks 0x5d2f1b/1f, 1a/1e, 19/1d; p += stride per row; 0x4c4202
 *   0x45b872  gates on [this+0x166], [this+0x16a], [this+0x24], record +0x4d; selector 0x5c39e5: 0x27bb -> 0x45be7f(rec+0x7e9, 4, 0) then [this+0x1b5]/[this+0x16e] or record +0x4d := 2; 0x27ba -> [this+0x28], [this+0x2c], [this+0x2e], [this+0x32], 0x4f6334 / 0x4fb2e3 on the text compare
 *   0x434630  i < dword [this+0x5f68]: s = 0x434814(this; dword [this+i*4+0x20e4]) compared with name; on equal and dword [this+i*4+0x4fc4] != 1: that := 1, [this+0x112c] := 0x4347b8(rec+4), [this+0x1120] := rec+8, strcpy(this+0x1130, s), return 1
 *   0x4c7481  pixels of buf (size >> 1 words) rebuilt in place as (a << 10) | (b << 5) | c from the shifts / masks / flags at [this+0x38c0..0x38ca]
 *   0x4d3836  width (ax) over the characters of text: 0x4d214b(c, font, &local) else the CRT predicates 0x50d651/0x50d67f, 0x50d651/0x50d6a7, 0x50d6cf with the glyph word c + font[0x53/0x55/0x57] - 0x41/0x61/0x30; glyph adds table word + font[0x51], otherwise font[0x4f]
 *   0x4460d6  0x2e dwords of src -> this+0xbc; per n < 10: dwords this+n*4+0x14 / +0x3c := extents of the rectangles at this+n*16+0xbc; record [this+0x16c] of the stride-0x4a table at 0x5d1591 filled; string 0x548218 copied; fields cleared / set
 *   0x48ded7  gates byte 0x61d369 and dword 0x61d374; k = word 0x61d36c (byte 0x61d36b, k != -1): rectangle of the record -> 0x4c5377 (table dword, 0x5cf665, rec+k*16+0x23, &r, 0x54e8e0), dword 0x61d370 := 0; else j = word 0x61d36e (byte 0x61d36a, j != -1): 0x4c5377 (0x5d15e3, 0x5cf665, rec+j*16+0x113, &r, 0x54e8fc), byte 0x61d36a := 0, 0x48d89e on 0x61d345; byte 0x61d369 := 0
 *   0x45b5bb  gates [this+0x166] / [this+0x28] / byte [rec+0x27] with word 0x6247ee; boxes A (0x321..0x329, 0x31d..0x325 -> 0x45b7a8(0x27ba, 0)), B (word [this+0xba] 1 or 3, 0x331.., 0x32d.. -> (0x27ba, 1)), C (0x341.. -> (0x27ba, 2)), D (0xb82.. -> (0x27bb, 0))
 *   0x4462d3  0x32 dwords of src -> this+0x174; per n < 10: dwords this+n*4+0x64 / +0x8c := extents of the rectangles at this+n*16+0x174; [this+0xb4] / [this+0xb8] from 0x214..0x220; record [this+0x234] of the 0x5d1591 table filled (0x4468fe); string 0x548228 copied; fields cleared / set
 *   0x412787  entry string rec+2 of record `index` looked up in group g = word [rec] - 3 (strings 0x5957cb + g*0x3390 + k*0x21, count word 0x59fbdb[g]); equal / 0x423259 == 0 -> 0x42ba3a(index); else append (strcpy, 0x59f27b / 0x59fbe1 words, count + 1; count 0x190 -> 0x52139c), 0x4e0559 for [rec] 4 / 3, 0x42ba3a(index)
 *   0x4fca60  [e+0x138], [e+0x13c] := the float arguments (e = this + channel*0x5bb); [e+0x140] / [e+0x144] := 0x50ce04(f * float[this+word[e+0x10c]*4+0xb764] * 0x52e4e0 + 0x52e4d8); 0x4f684a on 0x5cf1eb
 *   0x44d597  rec = object of record [this+0x1e]; globals 0x5b44f0.. and 0x5c39e5 := 0x276e; [this+0x24] := 1; [this+0x31] := arg */
#include "../src/original_methods_fl19b.h"

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
static uint8_t g_records[REC * 8];

/* ---- tests ---------------------------------------------------------------------------------------------------------------- */

static void test_m44d597_press(void)
{
    static uint8_t rec[0x300];
    Fl19bWorld w;
    Fl18Host h = host();
    memset(&w, 0, sizeof w);
    memset(g_records, 0, sizeof g_records);
    fill(g_obj, OBJ, 5);
    fill(rec, sizeof rec, 77);
    set16(g_obj, 0x1e, 3);
    set32(g_records, 3 * REC, 0x00c00000u);
    set16(rec, 0x263, 0x0007);
    add_region(0x00c00000u, rec, sizeof rec);
    w.records_5bb5e5 = g_records;
    w.value_5d0377 = 0xa1b2c3d4u;
    w.value_5b44f4 = 0x55;
    w.value_5d1631 = 0x1234;
    memcpy(g_exp, g_obj, OBJ);
    m44d597_press(g_obj, (int32_t)0x80000123, &w, &h);
    g_exp[0x24] = 1;
    set32(g_exp, 0x31, 0x80000123u);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    CK(w.value_5b44f0 == 7 && w.value_5b44f4 == 1 && w.value_5d162d == 0xa1b2c3d4u);
    CK(w.value_5d1631 == 0x5b160cu + (7u << 5) + 16u);  /* 0x5b16fc */
    CK(w.value_5d1639 == 1 && w.value_5c39e5 == 0x276e && L.n == 0);
    /* a negative signed word sign-extends into the dword and shifts as a 32-bit value */
    memset(g_records, 0, sizeof g_records);
    set32(g_records, 0, 0x00c00000u);
    set16(g_obj, 0x1e, 0);
    set16(rec, 0x263, 0xfffe);
    m44d597_press(g_obj, 0, &w, &h);
    CK(w.value_5b44f0 == 0xfffffffeu && w.value_5d1631 == 0x5b160cu + (0xfffffffeu << 5) + 16u);
    CK(get32(g_obj, 0x31) == 0 && get16(g_obj, 0x1e) == 0);
}

static void test_m41f986_init_strings(void)
{
    static uint8_t buffers[0x3c00 + 0x100];
    int k;
    Fl19bWorld w;
    Fl18Host h = host();
    memset(&w, 0, sizeof w);
    fill(g_obj, OBJ, 9);
    fill(buffers, sizeof buffers, 33);
    memcpy(g_exp, buffers, sizeof buffers);
    add_region(0x00d00000u, buffers, sizeof buffers);
    for (k = 0; k < 0x1e; k++) queue_return(0x51ea75, 0x00d00000u + (uint32_t)k * 0x200u + 8u);
    m41f986_init_strings(g_obj, &h);
    CK(L.n == 0x1e * 3 + 1);
    for (k = 0; k < 0x1e; k++) {
        uintptr_t slot = (uintptr_t)(g_obj + k * 4 + 0xea5);
        CK(is_call(3 * k, 0x51e745, slot, 0));
        CK(is_call(3 * k + 1, 0x51ea75, slot, 1) && L.c[3 * k + 1].a[0] == 0x190);
        CK(is_call(3 * k + 2, 0x51eac4, slot, 1) && L.c[3 * k + 2].a[0] == 0xffffffffu);
        memset(g_exp + k * 0x200 + 8, 0, 0x190);
    }
    CK(is_call(0x1e * 3, 0x51e745, (uintptr_t)(g_obj + 0xf1d), 0));
    CK(memcmp(buffers, g_exp, sizeof buffers) == 0);  /* exactly 0x190 bytes per buffer: neighbours and the byte after are untouched */
}

static void test_m4d00f4_draw_list(void)
{
    static uint8_t rec[0x300];
    static const uint8_t flags[8] = {1, 0, 7, 0, 0, 0, 0, 0};
    uint32_t va = 0x00c10000u, k;
    Fl19bWorld w;
    Fl18Host h = host();
    memset(&w, 0, sizeof w);
    memset(g_records, 0, sizeof g_records);
    fill(rec, sizeof rec, 41);
    set16(rec, 0x21, 3);
    for (k = 0; k < 3; k++) {
        set32(rec, 0x123 + k * 16, 100 + k);
        set32(rec, 0x127 + k * 16, 200 + k);
        set32(rec, 0x12b + k * 16, 0xfffffff0u + k);  /* + origin wraps */
        set32(rec, 0x12f + k * 16, 400 + k);
    }
    set32(g_records, 2 * REC, va);
    add_region(va, rec, sizeof rec);
    L.snap_callee = 0x4c5377;
    L.snap_arg = 3;
    L.snap_len = 16;
    w.records_5bb5e5 = g_records;
    w.word_5b5159 = 2;
    w.bytes_5b5128 = flags;
    w.origin_x_583186 = 0x20;
    w.origin_y_58318a = -5;
    w.value_5cf665 = 0xc0de0001u;
    w.value_5d1a83 = 0xc0de0002u;
    w.value_5d15e3 = 0xc0de0003u;
    m4d00f4_draw_list(&w, &h);
    CK(L.n == 3);
    CK(is_call(0, 0x4c5377, 0x5cf659, 5) && L.c[0].a[0] == 0xc0de0002u && L.c[0].a[1] == 0xc0de0001u && L.c[0].a[2] == va + 0x23 &&
       L.c[0].a[4] == 0x559f30);
    CK(is_call(1, 0x4c5377, 0x5cf659, 5) && L.c[1].a[0] == 0xc0de0003u && L.c[1].a[1] == 0xc0de0001u && L.c[1].a[2] == va + 16 + 0x123 &&
       L.c[1].a[4] == 0x559f4c);
    CK(is_call(2, 0x4c5377, 0x5cf659, 5) && L.c[2].a[0] == 0xc0de0002u && L.c[2].a[2] == va + 32 + 0x23 && L.c[2].a[4] == 0x559f30);
    for (k = 0; k < 3; k++) {
        CK(get32(L.c[k].snap, 0) == 100 + k + 0x20 && get32(L.c[k].snap, 4) == 200 + k - 5);
        CK(get32(L.c[k].snap, 8) == 0xfffffff0u + k + 0x20 && get32(L.c[k].snap, 12) == 400 + k - 5);
    }
    /* count 0 and a negative count: nothing is drawn */
    reset_log();
    add_region(va, rec, sizeof rec);
    set16(rec, 0x21, 0);
    m4d00f4_draw_list(&w, &h);
    CK(L.n == 0);
    set16(rec, 0x21, 0xffff);
    m4d00f4_draw_list(&w, &h);
    CK(L.n == 0);
}

static void test_m447ac7_split_pixels(void)
{
    static uint8_t pix[0x100], dst[0x100], expect[0x100];
    uint32_t va = 0x00c20000u;
    Fl19bWorld w;
    Fl18Host h = host();
    memset(&w, 0, sizeof w);
    fill(g_obj, OBJ, 12);
    memset(pix, 0, sizeof pix);
    set16(pix, 0x10, 0xabcd);
    set16(pix, 0x12, 0x0123);
    set16(pix, 0x14, 0xffff);  /* col 4 is not reached when cols = 4 */
    set16(pix, 0x16, 0x8001);  /* second row: p + stride (6) = 0x16 */
    set16(pix, 0x18, 0xf81f);
    set32(g_obj, 0x41, 2);
    set32(g_obj, 0x45, 4);
    w.shift_5d2f1b = 11 + 32;  /* only the low 5 bits count */
    w.mask_5d2f1f = 0x1f;
    w.shift_5d2f1a = 5;
    w.mask_5d2f1e = 0x3f;
    w.shift_5d2f19 = 0;
    w.mask_5d2f1d = 0x1f;
    add_region(va, pix, sizeof pix);
    queue_write(0x4c3efb, 0, 2, 0x24, 4, va + 0x10);
    queue_write(0x4c3efb, 0, 2, 0x10, 4, 6);
    memset(dst, 0xee, sizeof dst);
    memset(expect, 0xee, sizeof expect);
    memcpy(g_exp, g_obj, OBJ);
    m447ac7_split_pixels(g_obj, 0x1234, dst, &w, &h);
    /* 0xabcd -> 0x15, 0x1e, 0x0d; 0x0123 -> 0, 0x09, 0x03; 0x8001 -> 0x10, 0, 0x01; 0xf81f -> 0x1f, 0x00, 0x1f */
    {
        static const uint32_t e[4][3] = {{0x15, 0x1e, 0x0d}, {0x00, 0x09, 0x03}, {0x10, 0x00, 0x01}, {0x1f, 0x00, 0x1f}};
        int i;
        for (i = 0; i < 4; i++) memcpy(expect + i * 12, e[i], 12);
    }
    CK(memcmp(dst, expect, sizeof dst) == 0 && memcmp(g_obj, g_exp, OBJ) == 0);
    CK(L.n == 2 && is_call(0, 0x4c3efb, 0x5cf659, 4) && L.c[0].a[0] == 0x1234 && L.c[0].a[1] == 0x583186 && L.c[0].a[3] == 0x5485b4);
    CK(is_call(1, 0x4c4202, 0x5cf659, 3) && L.c[1].a[0] == 0x1234 && L.c[1].a[1] == 0x583186 && L.c[1].a[2] == 0x5485f4);
    /* an odd column count still reads the word at the last even column; rows <= 0 or cols <= 0 write nothing */
    reset_log();
    add_region(va, pix, sizeof pix);
    queue_write(0x4c3efb, 0, 2, 0x24, 4, va + 0x10);
    queue_write(0x4c3efb, 0, 2, 0x10, 4, 6);
    set32(g_obj, 0x45, 1);
    set32(g_obj, 0x41, 1);
    memset(dst, 0xee, sizeof dst);
    m447ac7_split_pixels(g_obj, 0x77, dst, &w, &h);
    CK(get32(dst, 0) == 0x15 && get32(dst, 12) == 0xeeeeeeeeu);
    reset_log();
    add_region(va, pix, sizeof pix);
    queue_write(0x4c3efb, 0, 2, 0x24, 4, va + 0x10);
    set32(g_obj, 0x41, 0xffffffffu);
    memset(dst, 0xee, sizeof dst);
    m447ac7_split_pixels(g_obj, 0x77, dst, &w, &h);
    CK(get32(dst, 0) == 0xeeeeeeeeu && L.n == 2);
    set32(g_obj, 0x41, 3);
    set32(g_obj, 0x45, 0);
    m447ac7_split_pixels(g_obj, 0x77, dst, &w, &h);
    CK(get32(dst, 0) == 0xeeeeeeeeu);
}

static void test_m45b872_click(void)
{
    static uint8_t rec[0x1000];
    static const uint8_t pat_a[9] = {1, 2, 3, 4, 5, 6, 7, 8, 9}, pat_b[9] = {1, 2, 3, 4, 5, 6, 7, 8, 0};
    uint32_t va = 0x00c30000u;
    Fl19bWorld w;
    Fl18Host h = host();
    memset(&w, 0, sizeof w);
    memset(g_records, 0, sizeof g_records);
    fill(g_obj, OBJ, 21);
    fill(rec, sizeof rec, 22);
    set16(g_obj, 0x1e, 2);
    set32(g_obj, 0x166, 1);
    set32(g_obj, 0x16a, 0);
    set32(g_obj, 0x24, 0);
    set32(g_records, 2 * REC, va);
    set32(g_records, 2 * REC + 0x4d, 1);
    add_region(va, rec, sizeof rec);
    w.records_5bb5e5 = g_records;
    w.bytes_54ab5c = pat_a;
    /* selector 0x27bb, 0x45be7f non-zero: [this+0x1b5] := 0xb, [this+0x16e] := tick + 0x320 (wraps) */
    w.value_5c39e5 = 0x27bb;
    L.tick = 0xfffffff0u;
    queue_return(0x45be7f, 1);
    memcpy(g_exp, g_obj, OBJ);
    m45b872_click(g_obj, &w, &h);
    set32(g_exp, 0x1b5, 0xb);
    set32(g_exp, 0x16e, 0xfffffff0u + 0x320u);
    CK(memcmp(g_obj, g_exp, OBJ) == 0 && L.ticks == 1 && get32(g_records, 2 * REC + 0x4d) == 1);
    CK(L.n == 1 && is_call(0, 0x45be7f, (uintptr_t)g_obj, 3) && L.c[0].a[0] == va + 0x7e9 && L.c[0].a[1] == 4 && L.c[0].a[2] == 0);
    /* 0x45be7f returns 0: record +0x4d := 2, the object is untouched */
    reset_log();
    add_region(va, rec, sizeof rec);
    memcpy(g_exp, g_obj, OBJ);
    m45b872_click(g_obj, &w, &h);
    CK(memcmp(g_obj, g_exp, OBJ) == 0 && L.ticks == 0 && get32(g_records, 2 * REC + 0x4d) == 2 && L.n == 1);
    /* the record is no longer 1: nothing at all */
    reset_log();
    add_region(va, rec, sizeof rec);
    m45b872_click(g_obj, &w, &h);
    CK(L.n == 0 && L.ticks == 0 && get32(g_records, 2 * REC + 0x4d) == 2);
    set32(g_records, 2 * REC + 0x4d, 1);
    /* selector 0x27ba with the text compare off (0x5bb1ca clear) */
    w.value_5c39e5 = 0x27ba;
    set16(g_obj, 0x172, 0xffff);  /* s = -1: rec + 0x4fe - 0x31 */
    L.tick = 1000;
    memcpy(g_exp, g_obj, OBJ);
    m45b872_click(g_obj, &w, &h);
    set32(g_exp, 0x28, 1);
    set16(g_exp, 0x2c, 0xffff);
    set32(g_exp, 0x2e, 1000 + 0xfa);
    set32(g_exp, 0x32, 1);
    CK(memcmp(g_obj, g_exp, OBJ) == 0 && L.n == 0 && L.ticks == 1);
    /* 0x5bb1ca set, equal text: still no call; different text (ninth byte only): 0x4f6334 with the signed word, zero -> 0x4fb2e3 */
    w.value_5bb1ca = 1;
    memcpy(rec + 0x4fe - 0x31, pat_a, 9);
    set16(rec, 0x51f - 0x31, 0xfff0);
    reset_log();
    add_region(va, rec, sizeof rec);
    m45b872_click(g_obj, &w, &h);
    CK(L.n == 0);
    memcpy(rec + 0x4fe - 0x31, pat_b, 9);
    m45b872_click(g_obj, &w, &h);
    CK(L.n == 2 && is_call(0, 0x4f6334, 0x5cf1eb, 1) && L.c[0].a[0] == 0xfffffff0u && is_call(1, 0x4fb2e3, 0x5c3a67, 1) &&
       (L.c[1].a[0] & 0xffff) == 0xfff0);
    reset_log();
    add_region(va, rec, sizeof rec);
    queue_return(0x4f6334, 5);
    m45b872_click(g_obj, &w, &h);
    CK(L.n == 1 && L.c[0].callee == 0x4f6334);
    /* each gate alone stops it, and any other selector does nothing */
    memcpy(g_exp, g_obj, OBJ);
    reset_log();
    add_region(va, rec, sizeof rec);
    set32(g_obj, 0x166, 0);
    m45b872_click(g_obj, &w, &h);
    set32(g_obj, 0x166, 1);
    set32(g_obj, 0x16a, 4);
    m45b872_click(g_obj, &w, &h);
    set32(g_obj, 0x16a, 0);
    set32(g_obj, 0x24, 4);
    m45b872_click(g_obj, &w, &h);
    set32(g_obj, 0x24, 0);
    w.value_5c39e5 = 0x27b9;
    memcpy(g_exp, g_obj, OBJ);
    m45b872_click(g_obj, &w, &h);
    CK(L.n == 0 && L.ticks == 0 && memcmp(g_obj, g_exp, OBJ) == 0);
}

static void test_m434630_find_name(void)
{
    static uint8_t names[0x200];
    static uint8_t big[0x6400], expect[0x6400];
    Fl19bWorld w;
    Fl18Host h = host();
    uint32_t va = 0x00c40000u;
    int32_t r;
    memset(&w, 0, sizeof w);
    fill(big, sizeof big, 3);
    memset(names, 0, sizeof names);
    memcpy(names + 0x00, "ab", 3);      /* 0: prefix of the name */
    memcpy(names + 0x20, "abcd", 5);    /* 1: equal, but already marked */
    memcpy(names + 0x40, "abxd", 5);    /* 2: differs in the 3rd byte */
    memcpy(names + 0x60, "abcd", 5);    /* 3: equal and free */
    memcpy(names + 0x80, "abcdxx", 7);  /* 4: never reached */
    add_region(va, names, sizeof names);
    set32(big, 0x5f68, 5);
    set32(big, 0x20e4, 0x1000);
    set32(big, 0x20e8, 0x2000);
    set32(big, 0x20ec, 0x3000);
    set32(big, 0x20f0, 0x4000);
    set32(big, 0x20f4, 0x5000);
    set32(big, 0x4fc4 + 4, 1);
    set32(big, 0x4fc4 + 12, 0);
    queue_return(0x434814, va);
    queue_return(0x434814, va + 0x20);
    queue_return(0x434814, va + 0x40);
    queue_return(0x434814, va + 0x60);
    queue_return(0x434814, va + 0x80);
    queue_return(0x4347b8, 0x0badf00du);
    memcpy(expect, big, sizeof big);
    r = m434630_find_name(big, (const uint8_t *)"abcd", &h);
    set32(expect, 0x4fc4 + 12, 1);
    set32(expect, 0x112c, 0x0badf00du);
    set32(expect, 0x1120, 0x4000 + 8);
    memcpy(expect + 0x1130, "abcd", 5);
    CK(r == 1 && memcmp(big, expect, sizeof big) == 0);
    CK(L.n == 5 && is_call(0, 0x434814, (uintptr_t)big, 1) && L.c[0].a[0] == 0x1000 && L.c[1].a[0] == 0x2000 && L.c[2].a[0] == 0x3000 &&
       L.c[3].a[0] == 0x4000);
    CK(is_call(4, 0x4347b8, (uintptr_t)big, 1) && L.c[4].a[0] == 0x4000 + 4);
    /* the string longer than the name, the name longer than the string, and the empty name */
    reset_log();
    add_region(va, names, sizeof names);
    queue_return(0x434814, va);
    set32(big, 0x5f68, 1);
    memcpy(expect, big, sizeof big);
    CK(m434630_find_name(big, (const uint8_t *)"abc", &h) == 0 && L.n == 1 && memcmp(big, expect, sizeof big) == 0);
    reset_log();
    add_region(va, names, sizeof names);
    queue_return(0x434814, va + 0x20);
    CK(m434630_find_name(big, (const uint8_t *)"abcde", &h) == 0 && memcmp(big, expect, sizeof big) == 0);
    reset_log();
    add_region(va, names, sizeof names);
    queue_return(0x434814, va + 0x100);
    CK(m434630_find_name(big, (const uint8_t *)"", &h) == 1 && get32(big, 0x4fc4) == 1 && big[0x1130] == 0);
    /* a count of 0 or a negative count: nothing is called */
    reset_log();
    set32(big, 0x5f68, 0);
    CK(m434630_find_name(big, (const uint8_t *)"", &h) == 0 && L.n == 0);
    set32(big, 0x5f68, 0xffffffffu);
    CK(m434630_find_name(big, (const uint8_t *)"", &h) == 0 && L.n == 0);
}

static void test_m4c7481_pack_555(void)
{
    static uint8_t buf[16], expect[16];
    memset(g_obj, 0, OBJ);
    /* RGB565 -> 555: a = bits 11..15, b = bits 5..10 (halved), c = bits 0..4 */
    g_obj[0x38c2] = 11;
    g_obj[0x38c1] = 5;
    g_obj[0x38c0] = 0;
    g_obj[0x38c6] = 0x1f;
    g_obj[0x38c5] = 0x3f;
    g_obj[0x38c4] = 0x1f;
    g_obj[0x38ca] = 5;
    g_obj[0x38c9] = 6;
    g_obj[0x38c8] = 5;
    memset(buf, 0xee, sizeof buf);
    set16(buf, 0, 0xabcd);
    set16(buf, 2, 0xffff);
    set16(buf, 4, 0x0000);
    set16(buf, 6, 0x07e0);
    memcpy(expect, buf, sizeof buf);
    set16(expect, 0, 0x55ed);  /* a 0x15, b 0x1e >> 1 = 0xf, c 0xd */
    set16(expect, 2, 0x7fff);  /* a 0x1f, b 0x3f >> 1 = 0x1f, c 0x1f */
    set16(expect, 4, 0);
    set16(expect, 6, 0x03e0);  /* a 0, b 0x3f >> 1 = 0x1f, c 0 */
    m4c7481_pack_555(g_obj, buf, 8);
    CK(memcmp(buf, expect, sizeof buf) == 0);
    /* an odd size converts size >> 1 words; size 1 converts none */
    set16(buf, 0, 0xabcd);
    set16(buf, 2, 0xabcd);
    set16(buf, 4, 0xabcd);
    m4c7481_pack_555(g_obj, buf, 5);
    CK(get16(buf, 0) == 0x55ed && get16(buf, 2) == 0x55ed && get16(buf, 4) == 0xabcd);
    set16(buf, 0, 0xabcd);
    m4c7481_pack_555(g_obj, buf, 1);
    CK(get16(buf, 0) == 0xabcd);
    /* the flag chain: a first, then b, then c; all three equal to 5 leaves everything */
    g_obj[0x38ca] = 6;
    set16(buf, 0, 0xabcd);
    m4c7481_pack_555(g_obj, buf, 2);
    CK(get16(buf, 0) == ((0x15 >> 1) << 10 | 0x1e << 5 | 0xd));  /* only a is halved, even though the b flag is 6 too */
    g_obj[0x38ca] = 5;
    g_obj[0x38c9] = 5;
    g_obj[0x38c8] = 7;
    set16(buf, 0, 0xabcd);
    m4c7481_pack_555(g_obj, buf, 2);
    CK(get16(buf, 0) == (0x15 << 10 | 0x1e << 5 | (0xd >> 1)));
    g_obj[0x38c8] = 5;
    set16(buf, 0, 0xabcd);
    m4c7481_pack_555(g_obj, buf, 2);
    CK(get16(buf, 0) == (0x15 << 10 | 0x1e << 5 | 0xd));
    /* 16-bit shift counts: 16..31 clear the value, 32 and up count modulo 32 (the shift by 32 + 11 equals 11) */
    g_obj[0x38c2] = 16;
    g_obj[0x38c1] = 11 + 32;
    g_obj[0x38c0] = 31;
    set16(buf, 0, 0xffff);
    m4c7481_pack_555(g_obj, buf, 2);
    CK(get16(buf, 0) == ((0 << 10) | (0x1f << 5) | 0));
    /* the masks apply before the halving */
    g_obj[0x38c2] = 0;
    g_obj[0x38c6] = 0xff;
    g_obj[0x38ca] = 0;
    set16(buf, 0, 0x01ff);
    m4c7481_pack_555(g_obj, buf, 2);
    CK(get16(buf, 0) == (uint16_t)((0xffu >> 1) << 10));
}

static void test_m4d3836_text_width(void)
{
    static uint8_t font[0x80], table[0x400];
    Fl19bWorld w;
    Fl18Host h = host();
    int16_t width;
    memset(&w, 0, sizeof w);
    memset(font, 0, sizeof font);
    memset(table, 0, sizeof table);
    set16(font, 0x4f, 3);
    set16(font, 0x51, 0xffff);  /* -1 */
    set16(font, 0x53, 10);
    set16(font, 0x55, 20);
    set16(font, 0x57, 0xfffd);  /* -3 */
    set16(table, 4 * 10 + 0x100, 100);    /* glyph 10: 'A' */
    set16(table, 4 * 21 + 0x100, 200);    /* glyph 21: 'b' (0x62 + 20 - 0x61) */
    set16(table, 4 * 0x2c + 0x100, 300);  /* glyph 0x2c: '9' (0x39 - 3 - 0x30 = 6) -> use 6 below */
    set16(table, 4 * 6 + 0x100, 400);
    set16(table, 4 * 7 + 0x100, 500);     /* glyph 7, written by the callee */
    /* "Ab9 \xe9A7": 'A' upper+alpha; 'b' lower; '9' digit; ' ' none; 0xe9 negative char (never a glyph by the CRT tests); 'A' via the
     * callee; '7' none (the digit predicate says no) */
    queue_return(0x4d214b, 0);  /* A */
    queue_return(0x4d214b, 0);  /* b */
    queue_return(0x4d214b, 0);  /* 9 */
    queue_return(0x4d214b, 0);  /* ' ' */
    queue_return(0x4d214b, 0);  /* 0xe9 */
    queue_return(0x4d214b, 1);  /* A again: glyph from the callee */
    queue_return(0x4d214b, 0);  /* 7 */
    queue_write(0x4d214b, 5, 2, 0, 4, 0xaaaa0007u);
    queue_return(0x50d651, 1);  /* A: isalpha */
    queue_return(0x50d651, 0);  /* b: first test (50d651) fails ... */
    queue_return(0x50d651, 1);  /* b: ... second test 50d651 passes */
    queue_return(0x50d651, 0);  /* 9: first */
    queue_return(0x50d651, 0);  /* 9: second */
    queue_return(0x50d651, 0);  /* ' ' first */
    queue_return(0x50d651, 0);  /* ' ' second */
    queue_return(0x50d651, 1);  /* 0xe9 first (passes, then the byte >= 0x80 stops it) */
    queue_return(0x50d651, 1);  /* 0xe9 second (idem) */
    queue_return(0x50d651, 0);  /* 7 first */
    queue_return(0x50d651, 0);  /* 7 second */
    queue_return(0x50d67f, 1);  /* A: isupper */
    queue_return(0x50d67f, 1);  /* 0xe9: isupper says yes but the byte is >= 0x80 */
    queue_return(0x50d6a7, 1);  /* b: islower */
    queue_return(0x50d6a7, 1);  /* 0xe9 */
    queue_return(0x50d6cf, 1);  /* 9 */
    queue_return(0x50d6cf, 0);  /* ' ' */
    queue_return(0x50d6cf, 1);  /* 0xe9: isdigit says yes, byte >= 0x80 */
    queue_return(0x50d6cf, 0);  /* 7 */
    width = m4d3836_text_width((const uint8_t *)"Ab9 \xe9" "A7", font, table + 0x100, &h);
    /* A: 100-1, b: 200-1, '9': 400-1, ' ': 3, 0xe9: 3, A (callee glyph 7): 500-1, '7': 3 */
    CK(width == (int16_t)(99 + 199 + 399 + 3 + 3 + 499 + 3));
    CK(L.c[0].callee == 0x4d214b && L.c[0].this_ptr == 0 && L.c[0].n == 3 && (L.c[0].a[0] & 0xff) == 'A' && L.c[0].a[1] == (uintptr_t)font);
    CK(L.n > 20);
    /* a glyph index below zero reads below the table; the empty string returns 0 without a call */
    reset_log();
    CK(m4d3836_text_width((const uint8_t *)"", font, table + 0x100, &h) == 0 && L.n == 0);
    queue_return(0x4d214b, 1);
    queue_write(0x4d214b, 0, 2, 0, 2, 0xfffe);
    set16(table, 0x100 - 8, 1000);
    CK(m4d3836_text_width((const uint8_t *)"x", font, table + 0x100, &h) == 999);
    /* 16-bit wrap of the width */
    reset_log();
    set16(font, 0x4f, 0x7fff);
    CK(m4d3836_text_width((const uint8_t *)"~~", font, table + 0x100, &h) == (int16_t)0xfffe);
}

static void test_m4460d6_load_layout(void)
{
    static uint8_t src[0xb8], table[0x4a * 6], expect[0x4a * 6];
    static const uint8_t text[] = "Hello layout";
    int n;
    Fl19bWorld w;
    memset(&w, 0, sizeof w);
    fill(g_obj, OBJ, 14);
    fill(table, sizeof table, 60);
    memcpy(expect, table, sizeof table);
    memset(src, 0, sizeof src);
    for (n = 0; n < 10; n++) {  /* rectangle n at src + n*16: left, top, right, bottom */
        set32(src, (size_t)n * 16 + 0x00, 5u * (uint32_t)n);
        set32(src, (size_t)n * 16 + 0x04, 100u + (uint32_t)n);
        set32(src, (size_t)n * 16 + 0x08, 7u * (uint32_t)n + 3u);
        set32(src, (size_t)n * 16 + 0x0c, 90u + (uint32_t)n);  /* 90 - 100 + 1 = -9 + ... wraps to a negative dword */
    }
    set32(src, 0x168 - 0xbc, 0x11223344u);
    set32(src, 0x16c - 0xbc, 3);
    set32(src, 0x170 - 0xbc, 0x55667788u);
    w.table_5d1591 = table;
    w.string_548218 = text;
    memcpy(g_exp, g_obj, OBJ);
    m4460d6_load_layout(g_obj, src, &w);
    memcpy(g_exp + 0xbc, src, sizeof src);
    for (n = 0; n < 10; n++) {
        set32(g_exp, (size_t)n * 4 + 0x14, (7u * (uint32_t)n + 3u) - 5u * (uint32_t)n + 1u);
        set32(g_exp, (size_t)n * 4 + 0x3c, (90u + (uint32_t)n) - (100u + (uint32_t)n) + 1u);
    }
    set32(g_exp, 0x284, 10);
    set32(g_exp, 0x23c, 0);
    g_exp[0x25c] = 0;
    g_exp[0x27a] = 0;
    set32(g_exp, 4, 0);
    set32(g_exp, 0xc, 1);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    /* record 3 at table + 3*0x4a */
    set32(expect, 3 * 0x4a + 0x00, 0x55667788u);
    set32(expect, 3 * 0x4a + 0x04, 0x446688);
    set32(expect, 3 * 0x4a + 0x08, 0x11223344u);
    set32(expect, 3 * 0x4a + 0x0c, 0);
    set32(expect, 3 * 0x4a + 0x10, 0);
    set32(expect, 3 * 0x4a + 0x14, 1);
    set32(expect, 3 * 0x4a + 0x18, 1);
    set16(expect, 3 * 0x4a + 0x1c, 0);
    memcpy(expect + 3 * 0x4a + 0x22, text, sizeof text);
    CK(memcmp(table, expect, sizeof table) == 0);
    CK(get32(g_obj, 0x14) == 4u && get32(g_obj, 0x3c) == 0xfffffff7u);  /* n = 0: 3 - 0 + 1, 90 - 100 + 1 */
    /* a negative record number: the record below the table */
    set32(src, 0x16c - 0xbc, 0xffffffffu);
    w.table_5d1591 = table + 0x4a * 3;
    memcpy(expect, table, sizeof table);
    m4460d6_load_layout(g_obj, src, &w);
    CK(get32(table + 0x4a * 2, 0x04) == 0x446688 && get32(table + 0x4a * 2, 0x08) == 0x11223344u);
}

static void test_m48ded7_draw_hover(void)
{
    static uint8_t rec[0x300], table[0x4a * 6];
    uint32_t va = 0x00c50000u;
    Fl19bWorld w;
    Fl18Host h = host();
    memset(&w, 0, sizeof w);
    memset(g_records, 0, sizeof g_records);
    fill(rec, sizeof rec, 71);
    memset(table, 0, sizeof table);
    set32(table, 2 * 0x4a + 8, 0xfeed0001u);
    set32(g_records, 1 * REC, va);
    set32(rec, 2 * 16 + 0x113, 10);
    set32(rec, 2 * 16 + 0x117, 20);
    set32(rec, 2 * 16 + 0x11b, 0xffffffffu);
    set32(rec, 2 * 16 + 0x11f, 40);
    set32(rec, 3 * 16 + 0x113, 11);
    set32(rec, 3 * 16 + 0x117, 21);
    set32(rec, 3 * 16 + 0x11b, 31);
    set32(rec, 3 * 16 + 0x11f, 41);
    w.records_5bb5e5 = g_records;
    w.table_5d1591 = table;
    w.word_61d363 = 1;
    w.word_61d361 = 2;
    w.byte_61d369 = 1;
    w.value_61d374 = 5;
    w.byte_61d36b = 1;
    w.word_61d36c = 2;
    w.byte_61d36a = 1;
    w.word_61d36e = 3;
    w.value_61d370 = 99;
    w.origin_x_583186 = 3;
    w.origin_y_58318a = -4;
    w.value_5cf665 = 0xabc00001u;
    w.value_5d15e3 = 0xabc00002u;
    add_region(va, rec, sizeof rec);
    L.snap_callee = 0x4c5377;
    L.snap_arg = 3;
    L.snap_len = 16;
    /* the first branch (byte 0x61d36b and k != -1): the second part is not looked at */
    m48ded7_draw_hover(&w, &h);
    CK(L.n == 1 && is_call(0, 0x4c5377, 0x5cf659, 5) && L.c[0].a[0] == 0xfeed0001u && L.c[0].a[1] == 0xabc00001u &&
       L.c[0].a[2] == va + 32 + 0x23 && L.c[0].a[4] == 0x54e8e0);
    CK(get32(L.c[0].snap, 0) == 13 && get32(L.c[0].snap, 4) == 16 && get32(L.c[0].snap, 8) == 2 && get32(L.c[0].snap, 12) == 36);
    CK(w.value_61d370 == 0 && w.byte_61d369 == 0 && w.byte_61d36a == 1);
    /* byte 0x61d36b clear: the second branch with j = 3 */
    reset_log();
    add_region(va, rec, sizeof rec);
    L.snap_callee = 0x4c5377;
    L.snap_arg = 3;
    L.snap_len = 16;
    w.byte_61d369 = 7;
    w.byte_61d36b = 0;
    w.value_61d370 = 99;
    m48ded7_draw_hover(&w, &h);
    CK(L.n == 2 && is_call(0, 0x4c5377, 0x5cf659, 5) && L.c[0].a[0] == 0xabc00002u && L.c[0].a[1] == 0xabc00001u &&
       L.c[0].a[2] == va + 48 + 0x113 && L.c[0].a[4] == 0x54e8fc);
    CK(get32(L.c[0].snap, 0) == 14 && get32(L.c[0].snap, 4) == 17 && get32(L.c[0].snap, 8) == 34 && get32(L.c[0].snap, 12) == 37);
    CK(is_call(1, 0x48d89e, 0x61d345, 0) && w.byte_61d36a == 0 && w.byte_61d369 == 0 && w.value_61d370 == 99);
    /* k == -1 also falls to the second branch; j == -1 does nothing but clear 0x61d369 */
    reset_log();
    add_region(va, rec, sizeof rec);
    w.byte_61d369 = 1;
    w.byte_61d36b = 1;
    w.word_61d36c = -1;
    w.byte_61d36a = 1;
    w.word_61d36e = -1;
    m48ded7_draw_hover(&w, &h);
    CK(L.n == 0 && w.byte_61d369 == 0 && w.byte_61d36a == 1);
    /* the gates: 0x61d369 clear, or 0x61d374 clear -> nothing changes, 0x61d369 stays */
    w.byte_61d369 = 0;
    w.value_61d374 = 1;
    w.word_61d36c = 2;
    m48ded7_draw_hover(&w, &h);
    CK(L.n == 0 && w.byte_61d369 == 0 && w.value_61d370 == 99);
    w.byte_61d369 = 1;
    w.value_61d374 = 0;
    m48ded7_draw_hover(&w, &h);
    CK(L.n == 0 && w.byte_61d369 == 1);
}

static void test_m45b5bb_pointer_move(void)
{
    static uint8_t rec[0xc00];
    uint32_t va = 0x00c60000u;
    Fl19bWorld w;
    Fl18Host h = host();
    int32_t r;
    memset(&w, 0, sizeof w);
    memset(g_records, 0, sizeof g_records);
    memset(rec, 0, sizeof rec);
    fill(g_obj, OBJ, 31);
    set16(g_obj, 0x1e, 1);
    set32(g_obj, 0x166, 1);
    set32(g_obj, 0x28, 0);
    set16(g_obj, 0xba, 0);
    set32(g_records, 1 * REC, va);
    add_region(va, rec, sizeof rec);
    w.records_5bb5e5 = g_records;
    /* box A: y in [100-5, 110+5], x in [10, 20] */
    rec[0x27] = 1;
    set32(rec, 0x321, 100);
    set32(rec, 0x329, 110);
    set32(rec, 0x31d, 10);
    set32(rec, 0x325, 20);
    r = m45b5bb_pointer_move(g_obj, 10, 95, &w, &h);
    CK(r == 1 && L.n == 1 && is_call(0, 0x45b7a8, (uintptr_t)g_obj, 2) && L.c[0].a[0] == 0x27ba && L.c[0].a[1] == 0);
    reset_log();
    add_region(va, rec, sizeof rec);
    CK(m45b5bb_pointer_move(g_obj, 20, 115, &w, &h) == 1 && L.n == 1);
    /* one unit outside each edge: not in A (other boxes are all zero: x = y = 0 would be in them, so stay away from 0) */
    reset_log();
    add_region(va, rec, sizeof rec);
    CK(m45b5bb_pointer_move(g_obj, 9, 100, &w, &h) == 0 && m45b5bb_pointer_move(g_obj, 21, 100, &w, &h) == 0 &&
       m45b5bb_pointer_move(g_obj, 15, 94, &w, &h) == 0 && m45b5bb_pointer_move(g_obj, 15, 116, &w, &h) == 0 && L.n == 0);
    /* box B needs the word [this+0xba] to be 1 or 3: y in [200+5, 210+5], x in [30+10, 60-10] */
    set32(rec, 0x331, 200);
    set32(rec, 0x339, 210);
    set32(rec, 0x32d, 30);
    set32(rec, 0x335, 60);
    CK(m45b5bb_pointer_move(g_obj, 40, 205, &w, &h) == 0 && L.n == 0);
    set16(g_obj, 0xba, 2);
    CK(m45b5bb_pointer_move(g_obj, 40, 205, &w, &h) == 0 && L.n == 0);
    set16(g_obj, 0xba, 1);
    add_region(va, rec, sizeof rec);
    CK(m45b5bb_pointer_move(g_obj, 40, 205, &w, &h) == 1 && L.n == 1 && is_call(0, 0x45b7a8, (uintptr_t)g_obj, 2) &&
       L.c[0].a[0] == 0x27ba && L.c[0].a[1] == 1);
    reset_log();
    add_region(va, rec, sizeof rec);
    set16(g_obj, 0xba, 3);
    CK(m45b5bb_pointer_move(g_obj, 40, 215, &w, &h) == 1 && L.n == 1 && L.c[0].a[1] == 1);
    reset_log();
    add_region(va, rec, sizeof rec);
    CK(m45b5bb_pointer_move(g_obj, 39, 205, &w, &h) == 0 && m45b5bb_pointer_move(g_obj, 51, 205, &w, &h) == 0 &&
       m45b5bb_pointer_move(g_obj, 45, 204, &w, &h) == 0 && m45b5bb_pointer_move(g_obj, 45, 216, &w, &h) == 0 &&
       m45b5bb_pointer_move(g_obj, 50, 205, &w, &h) == 1);
    CK(L.n == 1);
    /* box C: plain bounds */
    reset_log();
    add_region(va, rec, sizeof rec);
    set32(rec, 0x341, 300);
    set32(rec, 0x349, 310);
    set32(rec, 0x33d, 60);
    set32(rec, 0x345, 70);
    set16(g_obj, 0xba, 0);
    CK(m45b5bb_pointer_move(g_obj, 60, 300, &w, &h) == 1 && L.c[0].a[0] == 0x27ba && L.c[0].a[1] == 2);
    CK(m45b5bb_pointer_move(g_obj, 71, 300, &w, &h) == 0 && m45b5bb_pointer_move(g_obj, 60, 299, &w, &h) == 0 &&
       m45b5bb_pointer_move(g_obj, 60, 311, &w, &h) == 0 && m45b5bb_pointer_move(g_obj, 59, 300, &w, &h) == 0);
    /* box D, with negative coordinates (signed comparisons) */
    reset_log();
    add_region(va, rec, sizeof rec);
    set32(rec, 0xb82, 0xffffff00u);  /* -256 */
    set32(rec, 0xb8a, 0xffffff10u);
    set32(rec, 0xb7e, 0xffff0000u);  /* -65536 */
    set32(rec, 0xb86, 0xffff8000u);  /* -32768 */
    CK(m45b5bb_pointer_move(g_obj, -32768, -256, &w, &h) == 1 && L.c[0].a[0] == 0x27bb && L.c[0].a[1] == 0);
    CK(m45b5bb_pointer_move(g_obj, -32767, -256, &w, &h) == 0 && m45b5bb_pointer_move(g_obj, -32768, -239, &w, &h) == 0);
    /* the gates: the byte [rec+0x27] and the word 0x6247ee, then [this+0x166] and [this+0x28] */
    reset_log();
    add_region(va, rec, sizeof rec);
    rec[0x27] = 0;
    w.word_6247ee = 2;
    CK(m45b5bb_pointer_move(g_obj, 10, 100, &w, &h) == 0 && L.n == 0);
    w.word_6247ee = 1;
    CK(m45b5bb_pointer_move(g_obj, 10, 100, &w, &h) == 1 && L.n == 1);
    w.word_6247ee = -3;
    CK(m45b5bb_pointer_move(g_obj, 10, 100, &w, &h) == 1);
    rec[0x27] = 9;
    w.word_6247ee = 5;
    CK(m45b5bb_pointer_move(g_obj, 10, 100, &w, &h) == 1);
    set32(g_obj, 0x28, 1);
    CK(m45b5bb_pointer_move(g_obj, 10, 100, &w, &h) == 0);
    set32(g_obj, 0x28, 0);
    set32(g_obj, 0x166, 0);
    CK(m45b5bb_pointer_move(g_obj, 10, 100, &w, &h) == 0);
    /* 32-bit wrap of the +5 / -5 offsets: [rec+0x321] = INT_MIN makes the lower bound wrap to a large positive value */
    set32(g_obj, 0x166, 1);
    set32(rec, 0x321, 0x80000000u);
    reset_log();
    add_region(va, rec, sizeof rec);
    CK(m45b5bb_pointer_move(g_obj, 15, -32768, &w, &h) == 0 && L.n == 0);
}

static void test_m4462d3_load_layout(void)
{
    static uint8_t src[0xc8], table[0x4a * 6], expect[0x4a * 6];
    static const uint8_t text[] = "Second layout text";
    int n;
    Fl19bWorld w;
    memset(&w, 0, sizeof w);
    fill(g_obj, OBJ, 15);
    fill(table, sizeof table, 61);
    memcpy(expect, table, sizeof table);
    memset(src, 0, sizeof src);
    for (n = 0; n < 10; n++) {
        set32(src, (size_t)n * 16 + 0x00, 3u * (uint32_t)n);
        set32(src, (size_t)n * 16 + 0x04, 50u - (uint32_t)n);
        set32(src, (size_t)n * 16 + 0x08, 9u * (uint32_t)n + 1u);
        set32(src, (size_t)n * 16 + 0x0c, 40u - (uint32_t)n);
    }
    set32(src, 0x214 - 0x174, 100);
    set32(src, 0x218 - 0x174, 200);
    set32(src, 0x21c - 0x174, 160);
    set32(src, 0x220 - 0x174, 150);
    set32(src, 0x230 - 0x174, 0x0a0b0c0du);
    set32(src, 0x234 - 0x174, 4);
    set32(src, 0x238 - 0x174, 0x01020304u);
    w.table_5d1591 = table;
    w.string_548228 = text;
    memcpy(g_exp, g_obj, OBJ);
    m4462d3_load_layout(g_obj, src, &w);
    memcpy(g_exp + 0x174, src, sizeof src);
    for (n = 0; n < 10; n++) {
        set32(g_exp, (size_t)n * 4 + 0x64, (9u * (uint32_t)n + 1u) - 3u * (uint32_t)n + 1u);
        set32(g_exp, (size_t)n * 4 + 0x8c, (40u - (uint32_t)n) - (50u - (uint32_t)n) + 1u);
    }
    set32(g_exp, 0x284, 10);
    set32(g_exp, 0xb4, 61);                   /* 160 - 100 + 1 */
    set32(g_exp, 0xb8, 0xffffffcfu);          /* 150 - 200 + 1 = -49 */
    set32(g_exp, 0x240, 0);
    set32(g_exp, 0x244, 0);
    g_exp[0x248] = 0;
    g_exp[0x252] = 0;
    g_exp[0x266] = 0;
    g_exp[0x270] = 0;
    set32(g_exp, 8, 0);
    set32(g_exp, 0x10, 1);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    set32(expect, 4 * 0x4a + 0x00, 0x01020304u);
    set32(expect, 4 * 0x4a + 0x04, 0x4468fe);
    set32(expect, 4 * 0x4a + 0x08, 0x0a0b0c0du);
    set32(expect, 4 * 0x4a + 0x0c, 0);
    set32(expect, 4 * 0x4a + 0x10, 0);
    set32(expect, 4 * 0x4a + 0x14, 1);
    set32(expect, 4 * 0x4a + 0x18, 1);
    set16(expect, 4 * 0x4a + 0x1c, 0);
    memcpy(expect + 4 * 0x4a + 0x22, text, sizeof text);
    CK(memcmp(table, expect, sizeof table) == 0);
    /* a negative record number addresses below the table pointer */
    set32(src, 0x234 - 0x174, 0xfffffffeu);
    w.table_5d1591 = table + 0x4a * 3;
    m4462d3_load_layout(g_obj, src, &w);
    CK(get32(table + 0x4a, 0x04) == 0x4468fe && get32(table + 0x4a, 0x08) == 0x0a0b0c0du);
}

static void test_m412787_register_name(void)
{
    static uint8_t rec[0x100], strs[0x3390 * 3], w27b[0x320 * 3], counts[8], wbe1[0x320 * 3];
    uint32_t va = 0x00c70000u;
    Fl19bWorld w;
    Fl18Host h = host();
    memset(&w, 0, sizeof w);
    memset(g_records, 0, sizeof g_records);
    memset(rec, 0, sizeof rec);
    memset(strs, 0, sizeof strs);
    memset(w27b, 0xaa, sizeof w27b);
    memset(wbe1, 0xbb, sizeof wbe1);
    memset(counts, 0, sizeof counts);
    set32(g_records, 2 * REC, va);
    add_region(va, rec, sizeof rec);
    w.records_5bb5e5 = g_records;
    w.strings_5957cb = strs;
    w.words_59fbdb = counts;
    w.words_59f27b = w27b;
    w.words_59fbe1 = wbe1;
    /* group 1 (word [rec] = 4) holds two names; the entry "gamma" is new: appended at k = 2, with a word [rec+0x23] of 7 */
    set16(rec, 0, 4);
    memcpy(rec + 2, "gamma", 6);
    set16(rec, 0x23, 7);
    set16(rec, 0x25, 0x1234);
    memcpy(strs + 0x3390, "alpha", 6);
    memcpy(strs + 0x3390 + 0x21, "beta", 5);
    set16(counts, 2, 2);
    queue_return(0x423259, 5);  /* both mismatches go on */
    m412787_register_name(2, &w, &h);
    CK(strcmp((const char *)strs + 0x3390 + 2 * 0x21, "gamma") == 0 && get16(counts, 2) == 3);
    CK(get16(w27b, 0x320 + 4) == 7 && get16(wbe1, 0x320 + 4) == 0x1234 && get16(counts, 0) == 0 && get16(counts, 4) == 0);
    CK(L.n == 4 && is_call(0, 0x423259, 0x619a6b, 1) && L.c[0].a[0] == va + 2 && is_call(1, 0x423259, 0x619a6b, 1));
    CK(is_call(2, 0x4e0559, 0x570508, 3) && L.c[2].a[0] == 2 && L.c[2].a[1] == 1 && L.c[2].a[2] == 0);
    CK(is_call(3, 0x42ba3a, 0, 1) && (L.c[3].a[0] & 0xffff) == 2);
    /* the second time the name is found by the string compare: only 0x42ba3a (the first entry differs, 0x423259 says go on) */
    reset_log();
    add_region(va, rec, sizeof rec);
    queue_return(0x423259, 1);
    m412787_register_name(2, &w, &h);
    CK(get16(counts, 2) == 3 && L.n == 3 && L.c[0].callee == 0x423259 && L.c[1].callee == 0x423259 && is_call(2, 0x42ba3a, 0, 1));
    /* 0x423259 returning 0 on the first mismatch ends the search at once, nothing is stored */
    reset_log();
    add_region(va, rec, sizeof rec);
    memcpy(rec + 2, "delta", 6);
    queue_return(0x423259, 0);
    m412787_register_name(2, &w, &h);
    CK(get16(counts, 2) == 3 && L.n == 2 && is_call(1, 0x42ba3a, 0, 1));
    /* group 0 (word [rec] = 3), word [rec+0x23] = 9 (< 10, not 7): the 0x59fbe1 word is 0x270f; 0x4e0559 with (2, 1, 1) */
    reset_log();
    add_region(va, rec, sizeof rec);
    set16(rec, 0, 3);
    set16(rec, 0x23, 9);
    m412787_register_name(2, &w, &h);
    CK(strcmp((const char *)strs, "delta") == 0 && get16(counts, 0) == 1 && get16(w27b, 0) == 9 && get16(wbe1, 0) == 0x270f);
    CK(L.n == 2 && is_call(0, 0x4e0559, 0x570508, 3) && L.c[0].a[2] == 1 && is_call(1, 0x42ba3a, 0, 1));
    /* group 2 (word [rec] = 5), word [rec+0x23] = 10: stores [rec+0x25]; no 0x4e0559; 0x59f27b gets the word 10 */
    reset_log();
    add_region(va, rec, sizeof rec);
    set16(rec, 0, 5);
    set16(rec, 0x23, 10);
    set16(counts, 4, 0);
    m412787_register_name(2, &w, &h);
    CK(get16(counts, 4) == 1 && get16(w27b, 2 * 0x320) == 10 && get16(wbe1, 2 * 0x320) == 0x1234 && L.n == 1);
    /* a count of 0x190: only 0x52139c is called, nothing is stored, the count still goes up (16-bit) */
    reset_log();
    add_region(va, rec, sizeof rec);
    set16(rec, 0, 4);
    set16(counts, 2, 0x190);
    queue_return(0x423259, 1);
    memset(strs + 0x3390, 'x', 0x3390);   /* no entry matches "delta" */
    {
        uint8_t keep[sizeof w27b];
        memcpy(keep, w27b, sizeof w27b);
        m412787_register_name(2, &w, &h);
        CK(memcmp(keep, w27b, sizeof w27b) == 0);
    }
    CK(get16(counts, 2) == 0x191 && L.n == 0x190 + 3);
    CK(is_call(0x190, 0x52139c, 0, 3) && L.c[0x190].a[0] == 0x54164c && L.c[0x190].a[1] == 0 && L.c[0x190].a[2] == 0);
    CK(is_call(0x190 + 1, 0x4e0559, 0x570508, 3) && is_call(0x190 + 2, 0x42ba3a, 0, 1));
}

static uint32_t float_bits(float f)
{
    uint32_t b;
    memcpy(&b, &f, 4);
    return b;
}

static double double_of(uintptr_t bits)
{
    uint64_t b = bits;
    double d;
    memcpy(&d, &b, 8);
    return d;
}

static void test_m4fca60_set_channel_scalars(void)
{
    static uint8_t self[0xd000], expect[0xd000];
    Fl19bWorld w;
    Fl18Host h = host();
    float t = 4.0f;
    memset(&w, 0, sizeof w);
    fill(self, sizeof self, 17);
    w.scale_52e4e0 = 0.5f;
    w.bias_52e4d8 = 0.25;
    /* channel 2: e = self + 0xb76; the word [e+0x10c] = 3 selects the float at self + 0xb764 + 12 */
    set16(self, 2 * 0x5bb + 0x10c, 3);
    memcpy(self + 0xb764 + 12, &t, 4);
    queue_return(0x50ce04, 123);
    memcpy(expect, self, sizeof self);
    m4fca60_set_channel_scalars(self, 2, float_bits(2.5f), float_bits(-3.0f), &w, &h);
    set32(expect, 2 * 0x5bb + 0x138, float_bits(2.5f));
    set32(expect, 2 * 0x5bb + 0x13c, float_bits(-3.0f));
    set32(expect, 2 * 0x5bb + 0x140, 123);
    set32(expect, 2 * 0x5bb + 0x144, 123);
    CK(memcmp(self, expect, sizeof self) == 0);
    CK(L.n == 3 && is_call(0, 0x50ce04, 0, 1) && is_call(1, 0x50ce04, 0, 1) && is_call(2, 0x4f684a, 0x5cf1eb, 1));
    CK(double_of(L.c[0].a[0]) == 5.25 && double_of(L.c[1].a[0]) == -5.75 && L.c[2].a[0] == 2);  /* 2.5*4*0.5+0.25, -3*4*0.5+0.25 */
    /* a negative channel and a negative table index: the sign extension of both words, the argument -1 as a full dword */
    reset_log();
    memset(self, 0, sizeof self);
    {
        uint8_t *e = self + 0x800;
        float two = 2.0f;
        set16(e - 0x5bb, 0x10c, 0xffff);
        memcpy(e + 0xb764 - 4, &two, 4);
        queue_return(0x50ce04, 0xfffffff0u);
        m4fca60_set_channel_scalars(e, -1, float_bits(1.0f), float_bits(0.0f), &w, &h);
        CK(get32(e - 0x5bb, 0x138) == float_bits(1.0f) && get32(e - 0x5bb, 0x140) == 0xfffffff0u && get32(e - 0x5bb, 0x144) == 0xfffffff0u);
        CK(double_of(L.c[0].a[0]) == 1.25 && double_of(L.c[1].a[0]) == 0.25 && L.c[2].a[0] == 0xffffffffu);
    }
}

/* TESTS-END */

int main(void)
{
    int failures = 0;
    RUN(test_m44d597_press);
    RUN(test_m41f986_init_strings);
    RUN(test_m4d00f4_draw_list);
    RUN(test_m447ac7_split_pixels);
    RUN(test_m45b872_click);
    RUN(test_m434630_find_name);
    RUN(test_m4c7481_pack_555);
    RUN(test_m4d3836_text_width);
    RUN(test_m4460d6_load_layout);
    RUN(test_m48ded7_draw_hover);
    RUN(test_m45b5bb_pointer_move);
    RUN(test_m4462d3_load_layout);
    RUN(test_m412787_register_name);
    RUN(test_m4fca60_set_channel_scalars);
    /* RUN-END */
    return failures;
}
