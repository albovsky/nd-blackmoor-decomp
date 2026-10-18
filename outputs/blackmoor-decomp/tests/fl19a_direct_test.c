/* FL-19 batch a: direct tests of the methods of GAME.EXE in src/original_methods_fl19a.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the
 * exit status is the failure count. Fixtures are synthetic (no original bytes). Expected values come from the disassembly of GAME.EXE, not
 * from running the native code; tests/test_fl19a_differential.py additionally runs the original bytes on random fixtures.
 *   0x4ceb3b  [this+0x216] := 0; 0x5d1a45 := 0; 0x5839a9 := [this+0x202]; 0x4d36ed; 0x4cd218 on this; byte [0x5bb625 + i*0x8d] := 1
 *   0x423f57  0x4234c8; [this+0x614] := value; [entry+4] != 0: 0x424201 (entry), 0x5c3a47 := ([entry] == 0), result [entry]; else result 1
 *   0x4cecf7  the descriptor block at 0x5d1a31 and the string 0x559b18 copied (terminator included) to 0x5d1a53
 *   0x4ea269  0x4e9e84 / 0x4eb70f on the word 0x583f1d; the word := piece or 0xffff; 0x4ea06c; 0x4fb2e3; the globals from [this + piece*0x16d + 0x780]
 *   0x4ccdab  the object reset (zero fill [this+8, this+0x1d6), constants)
 *   0x47e2a5  0x4c2dfb on every non-zero surface slot, 0x4d3992 on the word [this+0x1c], 0x47e25a
 *   0x423259  0x423368 picks the chain, 0x50d0bc on two local copies, the unrolled strcmp, the node's first dword is the result
 *   0x4e89eb  the slot layout from the tables 0x5b30cc / 0x5b3e40 / 0x5b3ae8 and 0x4e22fd per used slot
 *   0x4e444d  the name search over the tables 0x5a2664 (stride 0x4a) and 0x5a434c (stride 0x29)
 *   0x4b617a  arming of a piece (gates, 0x276d, 0x276c)
 *   0x4ccff5  freeing of a piece (0x51dc6c), the record fields and 0x423b51
 *   0x48d1e8 / 0x475da4 / 0x48bd91  rectangle hit tests; 0x4ee2a9 the slot hit test with the table-driven rectangle */
#include "../src/original_methods_fl19a.h"

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

#define OBJ 0x8400u
#define REC 0x8du

static void fill(uint8_t *o, size_t n, uint8_t seed)
{
    size_t i;
    for (i = 0; i < n; i++) o[i] = (uint8_t)(i * 7u + seed + (i >> 8));
}

static void set32(uint8_t *o, size_t off, uint32_t v) { memcpy(o + off, &v, 4); }
static void set16(uint8_t *o, size_t off, uint16_t v) { memcpy(o + off, &v, 2); }

static uint32_t get32(const uint8_t *o, size_t off)
{
    uint32_t v;
    memcpy(&v, o + off, 4);
    return v;
}

static uint16_t get16(const uint8_t *o, size_t off)
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
    char text[40];          /* 0x50d0bc: the string that args[0] pointed at when the call was made */
} Call;

typedef struct Region {
    uint32_t va;
    uint8_t *ptr;
    uint32_t len;
} Region;

static struct {
    int n;
    Call c[48];
    uint32_t ret_callee[6], ret_value[6][8];  /* per-callee queue of return values */
    int ret_count[6], ret_used[6];
    Region regions[8];
    int nregions;
    int lower;              /* 0x50d0bc turns the string into lower case, as the original callee does */
} L;

static void reset_log(void) { memset(&L, 0, sizeof L); }

static void queue_return(uint32_t callee, uint32_t v)
{
    int i;
    for (i = 0; i < 6; i++) {
        if (L.ret_count[i] == 0 || L.ret_callee[i] == callee) {
            L.ret_callee[i] = callee;
            L.ret_value[i][L.ret_count[i]++] = v;
            return;
        }
    }
}

static uint32_t h_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int i, k;
    (void)ctx;
    if (L.n < 48) {
        Call *c = &L.c[L.n];
        c->callee = callee;
        c->this_ptr = this_ptr;
        c->n = nargs;
        for (k = 0; k < nargs && k < 8; k++) c->a[k] = args[k];
        if (callee == 0x50d0bc) {
            strncpy(c->text, (const char *)args[0], sizeof c->text - 1);
            c->text[sizeof c->text - 1] = 0;
        }
    }
    L.n++;
    if (callee == 0x50d0bc && L.lower) {
        char *s = (char *)args[0];
        for (; *s != 0; s++)
            if (*s >= 'A' && *s <= 'Z') *s = (char)(*s + 32);
    }
    for (i = 0; i < 6; i++)
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

static void add_region(uint32_t va, uint8_t *ptr, uint32_t len)
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
    return h;
}

static int is_call(int k, uint32_t callee, uintptr_t this_ptr, int n)
{
    return k < L.n && k < 48 && L.c[k].callee == callee && L.c[k].this_ptr == this_ptr && L.c[k].n == n;
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
static uint8_t g_recs[REC * 8];
static uint8_t g_glob[0x80];

/* ---- tests ---------------------------------------------------------------------------------------------------------------- */

static void test_m4ceb3b_reset_state(void)
{
    static const int indexes[2] = {2, -1};
    Fl19aWorld w;
    Fl18Host h = host();
    int k;
    for (k = 0; k < 2; k++) {
        uint8_t recs_exp[sizeof g_recs];
        size_t at;
        reset_log();
        memset(&w, 0, sizeof w);
        fill(g_obj, OBJ, 3);
        fill(g_recs, sizeof g_recs, 5);
        memset(g_glob, 0xaa, sizeof g_glob);
        set32(g_obj, 0x202, 0xcafebabeu);
        memcpy(g_exp, g_obj, OBJ);
        memcpy(recs_exp, g_recs, sizeof g_recs);
        w.records_5bb5e5 = g_recs + REC;
        w.globals_5d1a31 = g_glob;
        w.value_5839a9 = 0x11111111u;
        m4ceb3b_reset_state(g_obj, (int16_t)indexes[k], &w, &h);
        set32(g_exp, 0x216, 0);
        CK(memcmp(g_obj, g_exp, OBJ) == 0);
        at = REC + (size_t)(indexes[k] * (int)REC) + 0x40;
        recs_exp[at] = 1;
        CK(memcmp(g_recs, recs_exp, sizeof g_recs) == 0);
        CK(get32(g_glob, 0x14) == 0 && g_glob[0x13] == 0xaa && g_glob[0x18] == 0xaa);
        CK(w.value_5839a9 == 0xcafebabeu);
        CK(L.n == 2 && is_call(0, 0x4d36ed, 0, 0) && is_call(1, 0x4cd218, (uintptr_t)g_obj, 0));
    }
}

static void test_m423f57_load_entry(void)
{
    uint8_t entry[16];
    Fl19aWorld w;
    Fl18Host h = host();
    uint32_t r;
    int k;
    for (k = 0; k < 3; k++) {
        reset_log();
        memset(&w, 0, sizeof w);
        w.value_5c3a47 = 0x77u;
        fill(g_obj, OBJ, 4);
        memcpy(g_exp, g_obj, OBJ);
        memset(entry, 0, sizeof entry);
        set32(entry, 0, k == 0 ? 0u : 0x1234u);
        set32(entry, 4, k == 2 ? 0u : 9u);
        r = m423f57_load_entry(g_obj, entry, 0xdeadbeefu, &w, &h);
        set32(g_exp, 0x614, 0xdeadbeefu);
        CK(memcmp(g_obj, g_exp, OBJ) == 0);
        CK(is_call(0, 0x4234c8, (uintptr_t)g_obj, 0));
        if (k == 2) {
            CK(L.n == 1 && r == 1 && w.value_5c3a47 == 0);
        } else {
            CK(L.n == 2 && is_call(1, 0x424201, (uintptr_t)g_obj, 1) && L.c[1].a[0] == (uintptr_t)entry);
            CK(r == (k == 0 ? 0u : 0x1234u) && w.value_5c3a47 == (k == 0 ? 1u : 0u));
        }
    }
    /* [entry+4] == 0 and [entry] == 0: flag 1, result 1 */
    reset_log();
    memset(entry, 0, sizeof entry);
    r = m423f57_load_entry(g_obj, entry, 1, &w, &h);
    CK(r == 1 && w.value_5c3a47 == 1 && L.n == 1);
}

static void test_m4cecf7_init_descriptor(void)
{
    static const char *strings[5] = {"", "a", "abc", "abcd", "abcdefgh"};
    uint8_t exp[sizeof g_glob];
    Fl19aWorld w;
    int k;
    for (k = 0; k < 5; k++) {
        size_t len = strlen(strings[k]) + 1;
        memset(&w, 0, sizeof w);
        memset(g_glob, 0x5a, sizeof g_glob);
        memcpy(exp, g_glob, sizeof exp);
        w.globals_5d1a31 = g_glob;
        w.string_559b18 = (const uint8_t *)strings[k];
        w.self_address = 0x20000000u;
        m4cecf7_init_descriptor(g_obj, &w);
        set32(exp, 0, 0xb);
        set32(exp, 4, 0x4cf749);
        set32(exp, 8, 0);
        set32(exp, 0xc, 0x200001e2u);
        set32(exp, 0x10, 0x200001f2u);
        set32(exp, 0x14, 0);
        set32(exp, 0x18, 1);
        set16(exp, 0x1c, 0);
        memcpy(exp + 0x22, strings[k], len);
        CK(memcmp(g_glob, exp, sizeof exp) == 0);
    }
}

static void test_m4ea269_select_piece(void)
{
    Fl19aWorld w;
    Fl18Host h = host();
    uint8_t *self = g_obj + 0x400;
    int k;
    for (k = 0; k < 3; k++) {
        int16_t piece = k == 2 ? -1 : 2;
        ptrdiff_t base = (ptrdiff_t)piece * 0x16d;
        reset_log();
        memset(&w, 0, sizeof w);
        fill(g_obj, OBJ, 6);
        set16(self, (size_t)(base + 0x780), 0xfff0);
        set16(self, (size_t)(base + 0x782), 0x1234);
        memcpy(g_exp, g_obj, OBJ);
        w.word_583f1d = k == 1 ? 0xffff : 7;
        w.value_5bb57b = w.value_5bb59b = w.value_5bb59f = 0x99999999u;
        w.word_5bb599 = w.word_5bb595 = w.word_5c39ff = 0x4444;
        w.value_5bb5a3 = w.value_583999 = 0x55555555u;
        m4ea269_select_piece(self, piece, k == 1 ? 0 : 1, k == 1 ? 0u : 5u, &w, &h);
        CK(memcmp(g_obj, g_exp, OBJ) == 0);
        CK(w.value_5bb57b == 0xfffffff0u && w.word_5bb599 == 0 && w.word_5bb595 == 0 && w.word_5c39ff == 0x1234 && w.value_5bb59b == 0 &&
           w.value_5bb59f == 0 && w.value_5bb5a3 == 1 && w.value_583999 == 4);
        if (k == 1) {
            CK(w.word_583f1d == 0xffff && L.n == 3);
            CK(is_call(0, 0x4eb70f, (uintptr_t)self, 1) && L.c[0].a[0] == 2);
            CK(is_call(1, 0x4ea06c, (uintptr_t)self, 1) && (L.c[1].a[0] & 0xffff) == 2);
            CK(is_call(2, 0x4e7d04, (uintptr_t)self, 0));
        } else {
            CK(w.word_583f1d == (uint16_t)piece && L.n == 4);
            CK(is_call(0, 0x4e9e84, (uintptr_t)self, 2) && (L.c[0].a[0] & 0xffff) == 7 && L.c[0].a[1] == 1);
            CK(is_call(1, 0x4ea06c, (uintptr_t)self, 1) && (L.c[1].a[0] & 0xffff) == (uint16_t)piece);
            CK(is_call(2, 0x4fb2e3, 0x5c3a67, 1) && L.c[2].a[0] == 0x17);
            CK(is_call(3, 0x4e7d04, (uintptr_t)self, 0));
        }
    }
    /* mode 2 stores 0xffff although a piece is given */
    reset_log();
    w.word_583f1d = 3;
    m4ea269_select_piece(self, 1, 2, 0, &w, &h);
    CK(w.word_583f1d == 0xffff && L.n == 3);
}

static void test_m4ccdab_reset_object(void)
{
    static const struct { size_t off; uint32_t v; } sets[] = {
        {0x216, 0}, {0x236, 0}, {0x206, 0}, {0x20a, 0}, {0x20e, 0}, {0x212, 0}, {0x1d6, 0}, {0x17a, 1}, {0x17e, 0}, {0x1de, 0},
        {0x232, 0xffffffffu}, {0x23a, 2}, {0x23e, 0xffffffffu}, {0x242, 0xffffffffu}, {0x222, 0}, {0x226, 0}, {0x22a, 0},
        {0x246, 0xffffffffu}, {0x24a, 0xffffffffu}, {0x24e, 0}, {0x256, 0xffffffffu}};
    Fl19aWorld w;
    size_t i;
    memset(&w, 0, sizeof w);
    fill(g_obj, OBJ, 8);
    memset(g_glob, 0xaa, sizeof g_glob);
    memcpy(g_exp, g_obj, OBJ);
    w.globals_5d1a31 = g_glob;
    m4ccdab_reset_object(g_obj, &w);
    for (i = 8; i < 8 + 0x73 * 4 + 2; i++) g_exp[i] = 0;
    for (i = 0; i < sizeof sets / sizeof sets[0]; i++) set32(g_exp, sets[i].off, sets[i].v);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    CK(get32(g_glob, 0x14) == 0 && g_glob[0x13] == 0xaa && g_glob[0x18] == 0xaa);
}

static void test_m47e2a5_release_surfaces(void)
{
    static const size_t slots[6] = {0x13a4, 0x13ac, 0x20, 0x68, 0x20 + 5 * 0x60 + 0x30, 0x20 + 19 * 0x60 + 0x48};
    Fl18Host h = host();
    int k;
    for (k = 0; k < 2; k++) {
        size_t i;
        reset_log();
        memset(g_obj, 0, OBJ);
        for (i = 0; i < 6; i++) set32(g_obj, slots[i], 0x100u + (uint32_t)i);
        set32(g_obj, 0x20 + 19 * 0x60 + 0x50, 0);   /* (19, 4) is outside the loop: untouched */
        set32(g_obj, 0x20 + 20 * 0x60, 0x5555);     /* i == 20 is outside: untouched */
        set16(g_obj, 0x1c, k == 0 ? 3 : 0xffff);
        memcpy(g_exp, g_obj, OBJ);
        m47e2a5_release_surfaces(g_obj, &h);
        for (i = 0; i < 6; i++) set32(g_exp, slots[i], 0);
        CK(memcmp(g_obj, g_exp, OBJ) == 0);
        CK(L.n == (k == 0 ? 8 : 7));
        for (i = 0; i < 6; i++) CK(is_call((int)i, 0x4c2dfb, 0x5cf659, 1) && L.c[i].a[0] == (uintptr_t)(g_obj + slots[i]));
        if (k == 0) CK(is_call(6, 0x4d3992, 0, 1) && (L.c[6].a[0] & 0xffff) == 3);
        CK(is_call(L.n - 1, 0x47e25a, (uintptr_t)g_obj, 0));
    }
}

static void test_m423259_find_by_name(void)
{
    static uint8_t na[0x80], nb[0x80], nc[0x80];
    Fl18Host h = host();
    uint8_t name[16];
    uint32_t r;
    memset(na, 0, sizeof na);
    memset(nb, 0, sizeof nb);
    memset(nc, 0, sizeof nc);
    set32(na, 0, 0x1111);
    memcpy(na + 4, "Foo", 4);
    set32(na, 0x25, 0x00900100u);
    set32(nb, 0, 0x2222);
    memcpy(nb + 4, "Fob", 4);
    set32(nb, 0x25, 0x00900200u);
    set32(nc, 0, 0x3333);
    memcpy(nc + 4, "bar", 4);
    set32(nc, 0x25, 0);
    memset(g_obj, 0, OBJ);
    set32(g_obj, 3 * 4, 0x00900000u);
    /* "BAR" lower-cased is "bar": the third node matches, after two mismatches on the first byte and the third */
    L.lower = 1;
    add_region(0x00900000u, na, sizeof na);
    add_region(0x00900100u, nb, sizeof nb);
    add_region(0x00900200u, nc, sizeof nc);
    queue_return(0x423368, 3);
    memcpy(name, "BAR", 4);
    r = m423259_find_by_name(g_obj, name, &h);
    CK(r == 0x3333 && L.n == 7);
    CK(is_call(0, 0x423368, (uintptr_t)g_obj, 1) && L.c[0].a[0] == (uintptr_t)name);
    CK(is_call(1, 0x50d0bc, 0, 1) && strcmp(L.c[1].text, "BAR") == 0 && is_call(2, 0x50d0bc, 0, 1) && strcmp(L.c[2].text, "Foo") == 0);
    CK(strcmp(L.c[5].text, "BAR") == 0 && strcmp(L.c[6].text, "bar") == 0);
    CK(L.c[1].a[0] != L.c[2].a[0] && memcmp(name, "BAR", 4) == 0);
    /* "fOb" matches the second node */
    reset_log();
    L.lower = 1;
    add_region(0x00900000u, na, sizeof na);
    add_region(0x00900100u, nb, sizeof nb);
    add_region(0x00900200u, nc, sizeof nc);
    queue_return(0x423368, 3);
    memcpy(name, "fOb", 4);
    CK(m423259_find_by_name(g_obj, name, &h) == 0x2222 && L.n == 5);
    /* a prefix and a longer name do not match; nothing matches: 0 after every node */
    reset_log();
    L.lower = 1;
    add_region(0x00900000u, na, sizeof na);
    add_region(0x00900100u, nb, sizeof nb);
    add_region(0x00900200u, nc, sizeof nc);
    queue_return(0x423368, 3);
    memcpy(name, "fo", 3);
    CK(m423259_find_by_name(g_obj, name, &h) == 0 && L.n == 7);
    /* an empty chain: only the index call */
    reset_log();
    queue_return(0x423368, 5);
    CK(m423259_find_by_name(g_obj, name, &h) == 0 && L.n == 1);
}

static void test_m4e89eb_layout_slots(void)
{
    static uint8_t t30[0x400], t3e[0x400], t3a[0x400];
    Fl19aWorld w;
    Fl18Host h = host();
    uint8_t *self = g_obj;
    int k;
    for (k = 0; k < 4; k++) {
        reset_log();
        memset(&w, 0, sizeof w);
        memset(t30, 0, sizeof t30);
        memset(t3e, 0, sizeof t3e);
        memset(t3a, 0, sizeof t3a);
        fill(g_obj, OBJ, 12);
        w.value_5b44f0 = 2;
        w.value_5b44f4 = 1;   /* o = (2 << 4) + 1 * 8 = 40, p = 1 * 4 + 2 * 8 = 20 */
        w.value_583102 = 0x10000;
        w.value_583106 = 0x20000;
        set32(t30, 40, 0x100);
        set32(t30, 44, 0x200);
        set32(t3e, 40, 0x300);
        set32(t3e, 44, 0x400);
        set16(t3a, 20, 0xfffb);
        set16(t3a, 22, 7);
        w.table_5b30cc = t30;
        w.table_5b3e40 = t3e;
        w.table_5b3ae8 = t3a;
        set32(self, 0x764c, k == 0 ? 1u : (k == 1 ? 2u : 3u));
        for (int s = 0; s < 6; s++) set32(self, 0x7012 + (size_t)s * 0xf7, (s == 1 || s == 4) ? 1u : 0u);
        queue_return(0x4ee2a9, k == 1 ? 1u : 0u);
        memcpy(g_exp, g_obj, OBJ);
        m4e89eb_layout_slots(self, &w, &h);
        if (k == 0) {
            CK(L.n == 0 && memcmp(g_obj, g_exp, OBJ) == 0);
        } else if (k == 1) {
            CK(L.n == 1 && is_call(0, 0x4ee2a9, (uintptr_t)self, 0) && memcmp(g_obj, g_exp, OBJ) == 0 && w.value_5c3a5b == 0);
        } else {
            set32(g_exp, 0x823a, 0x10100);
            set32(g_exp, 0x823e, 0x20200);
            set32(g_exp, 0x8242, 0x10300);
            set32(g_exp, 0x824a, 0x102fa);
            set32(g_exp, 0x8246, 0x20400);
            set32(g_exp, 0x824e, 0x20406);
            set32(g_exp, 0x822e, 6);
            CK(memcmp(g_obj, g_exp, OBJ) == 0);
            CK(w.value_5c3a5b == 0x10100 && w.value_5c3a5f == 0x20200);
            CK(L.n == 4 && is_call(0, 0x4ee2a9, (uintptr_t)self, 0));
            CK(is_call(1, 0x4e22fd, (uintptr_t)(self + 0x18f + 0x7654), 2) && L.c[1].a[0] == 0x0100 && L.c[1].a[1] == 0x0200);
            CK(is_call(2, 0x4e22fd, (uintptr_t)(self + 4 * 0x18f + 0x7654), 2) && L.c[2].a[0] == 0x0100 && L.c[2].a[1] == 0x0200);
            CK(is_call(3, 0x4e8bb4, (uintptr_t)self, 0));
        }
    }
}

static void test_m4e444d_find_name(void)
{
    static uint8_t t26[0x4a * 4], t43[0x29 * 4];
    Fl19aWorld w;
    uint8_t out[2];
    memset(&w, 0, sizeof w);
    memset(t26, 0, sizeof t26);
    memset(t43, 0, sizeof t43);
    memcpy(t26, "ab", 3);
    memcpy(t26 + 0x4a, "cd", 3);
    memcpy(t26 + 2 * 0x4a, "ef", 3);
    memcpy(t43, "xy", 3);
    memcpy(t43 + 0x29, "zw", 3);
    w.table_5a2664 = t26;
    w.table_5a434c = t43;
    w.word_5a1e5e = 3;
    w.word_5a1e60 = 2;
    set16(out, 0, 0x7777);
    CK(m4e444d_find_name(0, out, (const uint8_t *)"cd", &w) == 1 && get16(out, 0) == 1);
    set16(out, 0, 0x7777);
    CK(m4e444d_find_name(0, out, (const uint8_t *)"ab", &w) == 1 && get16(out, 0) == 0);
    set16(out, 0, 0x7777);
    CK(m4e444d_find_name(0, out, (const uint8_t *)"ef", &w) == 1 && get16(out, 0) == 2);
    set16(out, 0, 0x7777);
    CK(m4e444d_find_name(0, out, (const uint8_t *)"cde", &w) == 0 && get16(out, 0) == 0);
    set16(out, 0, 0x7777);
    CK(m4e444d_find_name(0, out, (const uint8_t *)"c", &w) == 0 && get16(out, 0) == 0);
    set16(out, 0, 0x7777);
    CK(m4e444d_find_name(1, out, (const uint8_t *)"zw", &w) == 1 && get16(out, 0) == 1);
    set16(out, 0, 0x7777);
    CK(m4e444d_find_name(7, out, (const uint8_t *)"xy", &w) == 1 && get16(out, 0) == 0);
    set16(out, 0, 0x7777);
    CK(m4e444d_find_name(1, out, (const uint8_t *)"ab", &w) == 0 && get16(out, 0) == 0);
    /* the count is a signed word: a negative count searches nothing; the count of the other table does not apply */
    w.word_5a1e5e = -1;
    set16(out, 0, 0x7777);
    CK(m4e444d_find_name(0, out, (const uint8_t *)"ab", &w) == 0 && get16(out, 0) == 0);
    w.word_5a1e60 = 1;
    set16(out, 0, 0x7777);
    CK(m4e444d_find_name(1, out, (const uint8_t *)"zw", &w) == 0 && get16(out, 0) == 0);
}

static void test_m4b617a_arm_piece(void)
{
    static uint8_t rec[0x400];
    static const uint8_t other[9] = {1, 2, 3, 4, 5, 6, 7, 8, 9};
    uint8_t recs_exp[sizeof g_recs];
    Fl19aWorld w;
    Fl18Host h = host();
    int k;
    for (k = 0; k < 9; k++) {
        reset_log();
        memset(&w, 0, sizeof w);
        fill(g_obj, OBJ, 14);
        memset(g_recs, 0, sizeof g_recs);
        memset(rec, 0, sizeof rec);
        set16(g_obj, 0x1e, 1);
        set32(g_obj, 0x225, 1);
        g_obj[0x22a] = 0;
        set32(g_obj, 0x274, 0);
        set32(g_recs, REC + 1 * REC, 0x00a00000u);   /* record 1 (slack of one record below the pointer) */
        set32(g_recs, REC + 1 * REC + 0x4d, 1);
        add_region(0x00a00000u, rec, sizeof rec);
        w.records_5bb5e5 = g_recs + REC;
        w.value_5c39e5 = 0x276c;
        w.bytes_551b18 = other;
        memcpy(rec + 0x2d9, other, 9);
        set16(rec, 0x2fa, 0xfffe);
        set16(rec, 0x21, 3);
        set16(g_obj, 0x252, 1);
        memcpy(rec + 0x254 + 8, "\0\0\2\0\0\0\3\0", 8);
        if (k == 0) set32(g_obj, 0x225, 0);
        if (k == 1) g_obj[0x22a] = 1;
        if (k == 2) set32(g_obj, 0x274, 5);
        if (k == 3) set32(g_recs, REC + 1 * REC + 0x4d, 3);
        if (k == 4) w.value_5c39e5 = 0x1111;
        if (k == 5) queue_return(0x4f6334, 1);
        if (k == 6) w.value_5c39e5 = 0x276d;
        if (k == 7) w.value_5bb1ca = 1;
        if (k == 8) {
            w.value_5bb1ca = 1;
            rec[0x2d9 + 8] = 0x77;
        }
        memcpy(g_exp, g_obj, OBJ);
        memcpy(recs_exp, g_recs, sizeof g_recs);
        m4b617a_arm_piece(g_obj, &w, &h);
        if (k <= 4) {
            CK(L.n == 0 && memcmp(g_obj, g_exp, OBJ) == 0 && memcmp(g_recs, recs_exp, sizeof g_recs) == 0);
        } else if (k == 5) {
            CK(L.n == 1 && is_call(0, 0x4f6334, 0x5cf1eb, 1) && L.c[0].a[0] == 0xfffffffeu);
            CK(memcmp(g_obj, g_exp, OBJ) == 0);
        } else if (k == 6) {
            g_exp[0x229] = 1;
            set32(recs_exp, REC + 1 * REC + 0x4d, 2);
            CK(L.n == 0 && memcmp(g_obj, g_exp, OBJ) == 0 && memcmp(g_recs, recs_exp, sizeof g_recs) == 0);
        } else {
            set32(g_exp, 0x274, 2);
            set16(g_exp, 0x232, 0);
            set16(g_exp, 0x234, 1);
            set16(g_exp, 0x236, 1);   /* the second loop sets word 0x230 + 3 * 2 after the first loop wrote 0 there */
            set16(g_exp, 0x22c, 1);
            CK(memcmp(g_obj, g_exp, OBJ) == 0 && memcmp(g_recs, recs_exp, sizeof g_recs) == 0);
            CK(is_call(0, 0x4f6334, 0x5cf1eb, 1));
            if (k == 7) {
                CK(L.n == 1);
            } else {
                CK(L.n == 2 && is_call(1, 0x4fb2e3, 0x5c3a67, 1) && (L.c[1].a[0] & 0xffff) == 0xfffe);
            }
        }
    }
}

static void test_m4ccff5_free_piece(void)
{
    static uint8_t arr[0x35 * 3 + 0x40], obj[0x40];
    uint8_t recs_exp[sizeof g_recs], arr_exp[sizeof arr];
    Fl19aWorld w;
    Fl18Host h = host();
    int k;
    for (k = 0; k < 3; k++) {
        size_t r = REC + 2 * REC;
        reset_log();
        memset(&w, 0, sizeof w);
        fill(g_obj, OBJ, 15);
        fill(g_recs, sizeof g_recs, 16);
        memset(arr, 0, sizeof arr);
        memset(obj, 0, sizeof obj);
        w.records_5bb5e5 = g_recs + REC;
        add_region(0x00b00000u, arr, sizeof arr);
        add_region(0x00c00000u, obj, sizeof obj);
        set32(g_obj, 0x23e, 2);
        set32(g_obj, 0x222, 0x00c00000u);
        set16(obj, 0x23, 3);   /* the element count of the array, read through the object [self+0x222] */
        set32(g_obj, 0x226, 0x00b00000u);
        set32(g_obj, 0x22a, 0x800);
        set32(g_recs, r, 0x900);
        set32(arr, 0 * 0x35 + 0x31, 0x500);
        set32(arr, 1 * 0x35 + 0x31, 0);
        set32(arr, 2 * 0x35 + 0x31, 0x700);
        if (k == 1) {
            set32(g_obj, 0x226, 0);
            set32(g_obj, 0x22a, 0);
            set32(g_recs, r, 0);
        }
        if (k == 2) set32(g_obj, 0x23e, 0xffffffffu);
        memcpy(g_exp, g_obj, OBJ);
        memcpy(recs_exp, g_recs, sizeof g_recs);
        memcpy(arr_exp, arr, sizeof arr);
        m4ccff5_free_piece(g_obj, &w, &h);
        if (k == 2) {
            CK(L.n == 0 && memcmp(g_obj, g_exp, OBJ) == 0 && memcmp(g_recs, recs_exp, sizeof g_recs) == 0);
            continue;
        }
        recs_exp[r - 2] = 0;
        recs_exp[r + 0x40] = 0;
        set32(recs_exp, r + 0x41, 0);
        set32(recs_exp, r + 0x4d, 0);
        set16(recs_exp, r + 0x51, 0xffff);
        set32(recs_exp, r + 0x53, 1);
        set32(recs_exp, r + 0x57, 0);
        set32(recs_exp, r, 0);
        set32(g_exp, 0x222, 0);
        set32(g_exp, 0x23e, 0xffffffffu);
        if (k == 0) {
            set32(arr_exp, 0x31, 0);
            set32(arr_exp, 2 * 0x35 + 0x31, 0);
            set32(g_exp, 0x226, 0);
            set32(g_exp, 0x22a, 0);
        }
        CK(memcmp(g_obj, g_exp, OBJ) == 0 && memcmp(g_recs, recs_exp, sizeof g_recs) == 0 && memcmp(arr, arr_exp, sizeof arr) == 0);
        if (k == 0) {
            CK(L.n == 6);
            CK(is_call(0, 0x51dc6c, 0, 1) && L.c[0].a[0] == 0x500);
            CK(is_call(1, 0x51dc6c, 0, 1) && L.c[1].a[0] == 0x700);
            CK(is_call(2, 0x51dc6c, 0, 1) && L.c[2].a[0] == 0x00b00000u);
            CK(is_call(3, 0x51dc6c, 0, 1) && L.c[3].a[0] == 0x800);
            CK(is_call(4, 0x51dc6c, 0, 1) && L.c[4].a[0] == 0x900);
            CK(is_call(5, 0x423b51, 0x63786d, 1) && L.c[5].a[0] == 2);
        } else {
            CK(L.n == 1 && is_call(0, 0x423b51, 0x63786d, 1) && L.c[0].a[0] == 2);
        }
    }
}

static void test_m48d1e8_hit_test(void)
{
    static uint8_t rec[0x900];
    Fl19aWorld w;
    Fl18Host h = host();
    uint32_t r;
    int k;
    static const struct { int16_t x, y; int gate, sel; int ret; int call; int flag24; } cases[] = {
        /* x, y, [self+0x33]!=0, [self+0x26], result, call (0 none, 1 main, 2 entry), byte 0x24 */
        {15, 25, 0, 0, 0, 0, 0}, {15, 25, 1, 0, 1, 1, 0},  {-5, 25, 1, 0, 1, 1, 0}, {205, 205, 1, 0, 1, 2, 0},
        {500, 25, 1, 0, 0, 0, 0}, {15, 25, 1, 1, 0, 0, 0}, {205, 205, 1, 1, 1, 2, 0}, {305, 305, 1, 1, 0, 0, 1},
        {305, 305, 1, 0, 0, 0, 0}, {0, 0, 1, 1, 0, 0, 1}};
    for (k = 0; k < (int)(sizeof cases / sizeof cases[0]); k++) {
        uint8_t exp_byte;
        reset_log();
        memset(&w, 0, sizeof w);
        fill(g_obj, OBJ, 17);
        memset(g_recs, 0, sizeof g_recs);
        memset(rec, 0, sizeof rec);
        set16(g_obj, 0x1e, 1);
        set32(g_obj, 0x33, cases[k].gate ? 0x1234u : 0u);
        g_obj[0x26] = (uint8_t)(cases[k].sel ? 0x40 : 0);
        g_obj[0x24] = 0;
        set16(g_obj, 0x27, k == 9 ? 0 : 1);
        set32(g_recs, REC + REC, 0x00d00000u);
        add_region(0x00d00000u, rec, sizeof rec);
        w.records_5bb5e5 = g_recs + REC;
        set32(rec, 0x7ab, 10);
        set32(rec, 0x7af, 20);
        set32(rec, 0x7b3, 30);
        set32(rec, 0x7b7, 40);
        if (k == 2) set32(rec, 0x7ab, (uint32_t)-10);
        set16(rec, 0x21, 2);
        set32(rec, 0x203, 50);
        set32(rec, 0x207, 50);
        set32(rec, 0x20b, 60);
        set32(rec, 0x20f, 60);
        set32(rec, 0x203 + 16, 200);
        set32(rec, 0x207 + 16, 200);
        set32(rec, 0x20b + 16, 210);
        set32(rec, 0x20f + 16, 210);
        set32(rec, 0x113 + 16, 300);
        set32(rec, 0x117 + 16, 300);
        set32(rec, 0x11b + 16, 310);
        set32(rec, 0x11f + 16, 310);
        memcpy(g_exp, g_obj, OBJ);
        r = m48d1e8_hit_test(g_obj, cases[k].x, cases[k].y, &w, &h);
        exp_byte = (uint8_t)(cases[k].flag24 ? 1 : 0);
        g_exp[0x24] = exp_byte;
        CK(r == (uint32_t)cases[k].ret);
        CK(memcmp(g_obj, g_exp, OBJ) == 0);
        if (cases[k].call == 0) CK(L.n == 0);
        if (cases[k].call == 1) CK(L.n == 1 && is_call(0, 0x48d3cb, (uintptr_t)g_obj, 2) && L.c[0].a[0] == 0x2766 && L.c[0].a[1] == 0);
        if (cases[k].call == 2)
            CK(L.n == 1 && is_call(0, 0x48d3cb, (uintptr_t)g_obj, 2) && L.c[0].a[0] == 0x2765 && (L.c[0].a[1] & 0xffff) == 1);
    }
}

static void test_m475da4_hit_test(void)
{
    static uint8_t rec[0x900];
    Fl19aWorld w;
    Fl18Host h = host();
    static const struct { int16_t x, y; uint32_t ret, call; } cases[] = {
        {110, 210, 1, 0x27d5}, {103, 203, 1, 0x27d5}, {102, 203, 0, 0}, {103, 202, 0, 0}, {147, 257, 1, 0x27d5}, {148, 257, 0, 0},
        {147, 258, 0, 0},      {510, 610, 1, 0x27d7}, {705, 805, 1, 0x27d6}, {1000, 1000, 0, 0}, {-3, -3, 0, 0}};
    int k;
    for (k = 0; k < (int)(sizeof cases / sizeof cases[0]); k++) {
        uint8_t *e;
        uint32_t r;
        reset_log();
        memset(&w, 0, sizeof w);
        fill(g_obj, OBJ, 18);
        memset(g_recs, 0, sizeof g_recs);
        memset(rec, 0, sizeof rec);
        set32(g_obj, 0x89a, 1);
        set32(g_obj, 0x2c, 0);
        set16(g_obj, 0x22, 1);
        set32(g_recs, REC + REC, 0x00d00000u);
        add_region(0x00d00000u, rec, sizeof rec);
        w.records_5bb5e5 = g_recs + REC;
        set16(rec, 0x42, 2);
        set16(rec, 0x44, 2);
        e = g_obj + 0x30 + 1 * 0xc8 + 1 * 0x14;
        memset(g_obj + 0x30, 0, 0xc8 * 2);
        set32(e, 4, 100);
        set32(e, 8, 200);
        set32(e, 0xc, 150);
        set32(e, 0x10, 260);
        set32(rec, 0x678, 500);
        set32(rec, 0x67c, 600);
        set32(rec, 0x680, 520);
        set32(rec, 0x684, 620);
        set32(rec, 0x7e2, 700);
        set32(rec, 0x7e6, 800);
        set32(rec, 0x7ea, 710);
        set32(rec, 0x7ee, 810);
        memcpy(g_exp, g_obj, OBJ);
        r = m475da4_hit_test(g_obj, cases[k].x, cases[k].y, &w, &h);
        CK(r == cases[k].ret);
        if (cases[k].call == 0x27d5) {
            set32(g_exp, 0x8be, 1);
            set32(g_exp, 0x8ba, 1);
        }
        CK(memcmp(g_obj, g_exp, OBJ) == 0);
        if (cases[k].call == 0) CK(L.n == 0);
        else CK(L.n == 1 && is_call(0, 0x475fb1, (uintptr_t)g_obj, 1) && L.c[0].a[0] == cases[k].call);
    }
    /* the two gates */
    reset_log();
    set32(g_obj, 0x89a, 0);
    CK(m475da4_hit_test(g_obj, 110, 210, &w, &h) == 0 && L.n == 0);
    set32(g_obj, 0x89a, 1);
    set32(g_obj, 0x2c, 2);
    CK(m475da4_hit_test(g_obj, 110, 210, &w, &h) == 0 && L.n == 0);
}

static void test_m4ee2a9_hit_slots(void)
{
    static uint8_t t30[0x800], t3e[0x800], t3a[0x800];
    Fl19aWorld w;
    Fl18Host h = host();
    /* case: 5c39e9, word 583a29, 5b44f8, expected a, b, 5d162d */
    static const struct { uint32_t f9; int16_t word; uint32_t f8, a, src; } cases[] = {
        {1, 3, 0, 4, 0x1234}, {0, -1, 5, 4, 0x1234}, {0, 3, 1, 9, 0x1234}, {0, 3, 0, 0x28, 0x5678}, {0, -3, 0, 0x22, 0x5678}};
    int k;
    for (k = 0; k < 5; k++) {
        uint32_t a = cases[k].a, o = a << 4, p = a * 8;
        uint32_t t;
        reset_log();
        memset(&w, 0, sizeof w);
        memset(t30, 0, sizeof t30);
        memset(t3e, 0, sizeof t3e);
        memset(t3a, 0, sizeof t3a);
        fill(g_obj, OBJ, 19);
        w.value_5c39e9 = cases[k].f9;
        w.word_583a29 = cases[k].word;
        w.value_5b44f8 = cases[k].f8;
        w.value_5b44f0 = 0x77;
        w.value_5b44f4 = 0x66;
        w.value_5d0377 = 0x1234;
        w.value_571ad3 = 0x5678;
        w.value_583102 = 0x10000;
        w.value_583106 = 0x20000;
        w.table_5b30cc = t30;
        w.table_5b3e40 = t3e;
        w.table_5b3ae8 = t3a;
        set32(t30, o, 0x100 + k);
        set32(t30, o + 4, 0x200 + k);
        set32(t3e, o, 0x300 + k);
        set32(t3e, o + 4, 0x400 + k);
        set16(t3a, p, k == 3 ? 0xfff0 : 0x20);
        set16(t3a, p + 2, 9);
        set32(g_obj, 0x4af, 1);
        memcpy(g_exp, g_obj, OBJ);
        CK(m4ee2a9_hit_slots(g_obj, &w, &h) == 0 && L.n == 0);
        CK(w.value_5b44f0 == a && w.value_5b44f4 == 0 && w.value_5d162d == cases[k].src);
        t = 0x5b160cu + (a << 5);
        CK(w.value_5d1631 == t && w.value_5d1639 == 1);
        set32(g_exp, 4, 0x10100 + (uint32_t)k);
        set32(g_exp, 8, 0x20200 + (uint32_t)k);
        set32(g_exp, 0xc, 0x10300 + (uint32_t)k);
        set32(g_exp, 0x14, 0x10300 + (uint32_t)k + (k == 3 ? (uint32_t)-16 : 0x20u) - 1u);
        set32(g_exp, 0x10, 0x20400 + (uint32_t)k);
        set32(g_exp, 0x18, 0x20400 + (uint32_t)k + 9u - 1u);
        CK(memcmp(g_obj, g_exp, OBJ) == 0);
        CK(w.value_5c3a5b == 0x10100u + (uint32_t)k && w.value_5c3a5f == 0x20200u + (uint32_t)k);
    }
    /* the hit tests on the slots */
    for (k = 0; k < 6; k++) {
        uint32_t r;
        reset_log();
        memset(&w, 0, sizeof w);
        memset(t30, 0, sizeof t30);
        memset(t3e, 0, sizeof t3e);
        memset(t3a, 0, sizeof t3a);
        fill(g_obj, OBJ, 20);
        w.value_5c39e9 = 1;
        w.table_5b30cc = t30;
        w.table_5b3e40 = t3e;
        w.table_5b3ae8 = t3a;
        set32(g_obj, 0x4af, k == 0 ? 1u : (k == 1 ? 2u : 3u));
        set32(g_obj, 0x15f, (k == 1 || k == 2) ? 0u : 1u);
        set32(g_obj, 0x252, (k == 1 || k == 3) ? 0u : 1u);
        queue_return(0x4e22fd, k == 4 ? 1u : 0u);
        queue_return(0x4ef2d1, k == 5 ? 1u : 0u);
        set32(t30, 64, 0x1230000u + 0x7777u);
        set32(t30, 68, 0x4560000u + 0x8888u);
        r = m4ee2a9_hit_slots(g_obj, &w, &h);
        if (k <= 1) CK(r == 0 && L.n == 0);
        if (k == 2) CK(r == 0 && L.n == 1 && is_call(0, 0x4ef2d1, (uintptr_t)(g_obj + 0x4b7), 2));
        if (k == 3) CK(r == 0 && L.n == 1 && is_call(0, 0x4e22fd, (uintptr_t)(g_obj + 0x31c), 2));
        if (k == 4) CK(r == 1 && L.n == 1 && is_call(0, 0x4e22fd, (uintptr_t)(g_obj + 0x31c), 2));
        if (k == 5) CK(r == 1 && L.n == 2 && is_call(1, 0x4ef2d1, (uintptr_t)(g_obj + 0x4b7), 2));
        if (k >= 2 && L.n > 0) CK(L.c[L.n - 1].a[0] == 0x7777 && L.c[L.n - 1].a[1] == 0x8888);
    }
}

static void test_m48bd91_hit_test(void)
{
    static uint8_t rec[0x300];
    Fl19aWorld w;
    Fl18Host h = host();
    /* x, y, byte [self+0x46], word 583a29, dword 5b44f8, result, expected 5b44f0, 5b44f4, 5c39e5, word [self+0x28], 5d162d */
    static const struct { int16_t x, y; int gate; int16_t word; uint32_t f8; uint32_t ret, a, b, id; uint16_t w28, src; } cases[] = {
        {15, 25, 0, -1, 0, 0, 0x77, 0x66, 0, 0x4242, 0x1111},
        {15, 25, 1, -1, 0, 1, 9, 1, 0x27a9, 0x4242, 0x1234},
        {105, 105, 1, -1, 0, 1, 0, 1, 0x27a7, 2, 0x1111},
        {105, 105, 1, 5, 0, 1, 0x2a, 1, 0x27a7, 2, 0x5678},
        {105, 105, 1, 5, 1, 1, 0x77, 1, 0x27a7, 2, 0x1111},
        {105, 105, 1, -1, 1, 1, 0x77, 1, 0x27a7, 2, 0x1111},
        {310, 312, 1, 5, 0, 1, 0, 1, 0x27a8, 1, 0x1111},
        {1000, 1000, 1, 5, 0, 0, 0x77, 0x66, 0, 0xffff, 0x1111},
        {305, 307, 1, 5, 0, 1, 0, 1, 0x27a8, 1, 0x1111},
        {304, 307, 1, 5, 0, 0, 0x77, 0x66, 0, 0xffff, 0x1111},
        {315, 317, 1, 5, 0, 1, 0, 1, 0x27a8, 1, 0x1111},
        {315, 318, 1, 5, 0, 0, 0x77, 0x66, 0, 0xffff, 0x1111}};
    int k;
    for (k = 0; k < (int)(sizeof cases / sizeof cases[0]); k++) {
        uint32_t r;
        reset_log();
        memset(&w, 0, sizeof w);
        fill(g_obj, OBJ, 21);
        memset(g_recs, 0, sizeof g_recs);
        memset(rec, 0, sizeof rec);
        set16(g_obj, 0x26, 1);
        g_obj[0x46] = (uint8_t)(cases[k].gate ? 0x10 : 0);
        set16(g_obj, 0x28, 0x4242);
        set32(g_recs, REC + REC, 0x00e00000u);
        add_region(0x00e00000u, rec, sizeof rec);
        w.records_5bb5e5 = g_recs + REC;
        w.word_583a29 = cases[k].word;
        w.value_5b44f8 = cases[k].f8;
        w.value_5b44f0 = 0x77;
        w.value_5b44f4 = 0x66;
        w.value_5d0377 = 0x1234;
        w.value_571ad3 = 0x5678;
        w.value_5d162d = 0x1111;
        w.value_5c39e5 = 0;
        set32(rec, 0x14e, 10);
        set32(rec, 0x152, 20);
        set32(rec, 0x156, 30);
        set32(rec, 0x15a, 40);
        set32(rec, 0x74 + 32, 100);
        set32(rec, 0x78 + 32, 100);
        set32(rec, 0x7c + 32, 110);
        set32(rec, 0x80 + 32, 110);
        set16(rec, 0x15e, 2);
        set32(rec, 0x162 + 0x12, 300);
        set32(rec, 0x166 + 0x12, 300);
        set32(rec, 0x16a + 0x12, 310);
        set32(rec, 0x16e + 0x12, 310);
        set32(rec, 0x64, 5);
        set32(rec, 0x68, 7);
        memcpy(g_exp, g_obj, OBJ);
        r = m48bd91_hit_test(g_obj, cases[k].x, cases[k].y, &w, &h);
        CK(r == cases[k].ret);
        CK(L.n == 0);
        if (cases[k].gate) set16(g_exp, 0x28, cases[k].w28);
        CK(memcmp(g_obj, g_exp, OBJ) == 0);
        CK(w.value_5b44f0 == cases[k].a && w.value_5b44f4 == cases[k].b && w.value_5c39e5 == cases[k].id);
        CK(w.value_5d162d == cases[k].src);
        if (cases[k].ret) CK(w.value_5d1639 == 1 && w.value_5d1631 == 0x5b160cu + (cases[k].a << 5) + (cases[k].b << 4));
        else CK(w.value_5d1639 == 0 && w.value_5d1631 == 0);
    }
}

int main(void)
{
    int failures = 0;
    RUN(test_m4ceb3b_reset_state);
    RUN(test_m423f57_load_entry);
    RUN(test_m4cecf7_init_descriptor);
    RUN(test_m4ea269_select_piece);
    RUN(test_m4ccdab_reset_object);
    RUN(test_m47e2a5_release_surfaces);
    RUN(test_m423259_find_by_name);
    RUN(test_m4e89eb_layout_slots);
    RUN(test_m4e444d_find_name);
    RUN(test_m4b617a_arm_piece);
    RUN(test_m4ccff5_free_piece);
    RUN(test_m48d1e8_hit_test);
    RUN(test_m475da4_hit_test);
    RUN(test_m4ee2a9_hit_slots);
    RUN(test_m48bd91_hit_test);
    return failures;
}
