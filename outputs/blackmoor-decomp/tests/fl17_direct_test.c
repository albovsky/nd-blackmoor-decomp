/* FL-17 direct tests of the small GAME.EXE methods in src/original_methods_fl17.c. Prints "PASS <name>" / "FAIL <name>: <msg>";
 * the exit status is the failure count. Fixtures are synthetic (no original bytes). Expected values come from the disassembly of
 * GAME.EXE, not from running the native code:
 *   0x424035  arg: dword +0x24 == 0 -> -1; else the signed word at +0x12 of the object that dword addresses
 *   0x42405a  arg: returns dword +0x30
 *   0x42ca22  table 0x5b4ea5 of 6-byte records, count = signed word [[0x5b4ead]+0x6d]; for each i < count (signed): when signed
 *             word rec+2 != -1 and signed word rec+0 == signed word 0x5b4e00: dword [0x585801 + rec[+2]*4] := signed word rec+4
 *   0x4d36ed  dword 0x5831c8 := 1; word 0x5831c6 := 0
 *   0x4cd218  0x4ccef1, 0x4ccfbd, 0x4ccff5, 0x4ccdab on this, in that order
 *   0x4fba69  0x4fc808 on this with the word [arg+0x21];  0x4fc05d  0x4fc808 on this with the word at 0x5b451f
 *   0x4e303b  0x4edb97, 0x4e2faa; [0x583204] := 0; 0x4d36ed; [0x5bb22a] := 0; word [this+0x6b2] := 0x270f; release dword 0x5d039f if set
 *   0x4e7d04  0x4edb97, 0x4e7bf3; [0x583204] := 0; 0x4d36ed
 *   0x4eb96e  0x4edb97, 0x4eba54; [0x583204] := 0; 0x4d36ed; release dword 0x5d03a3 if set, then 0x5d03a7 if set
 *   0x4caf8a  0x4cbb00 on this; 0x4d3992(word [this+0xc]) when that word != -1; 0x4caf03 on this
 *   0x4cf749  nothing when [0x638433] == 0 or [0x638423] == 0; else 0x4c5377(0x5cf659; [0x5d1a39], [0x5cf665], [0x5d1a3d], [0x5d1a41], 0x559d94)
 *   0x48c0ac  rec = 0x5bb5e5 + word[this+0x26] * 0x8d; [0x5c39e5] == 0x27a9: byte [this+0x47] := 1, dword rec+0x4d := 2;
 *             == 0x27a8: word [this+0x54] := word at (dword rec+0) + word[this+0x28]*0x12 + 0x160, dword rec+0x4d := 2; always byte [this+0x1c] := 0xff, byte [this+0x40] := 0
 *   0x415011  arg: free dword +0x21 and clear it; byte +0x4d := 0; UnmapViewOfFile dword +0x2d, CloseHandle dword +0x29, CloseHandle dword +0x25 (each only when set, then cleared)
 *   0x4eac4c  w = word at (dword rec+0); 0x4ea06c(this, w); [0x583a29] := 0xffff when it equals w (signed); byte rec+0x40 := 1
 *   0x48d067 / 0x461827 / 0x4b5b8a / 0x45b3ea / 0x483f6a / 0x44d107  the cleanups (offsets in the cases below)
 *   0x44d154 / 0x45b42e / 0x461862 / 0x48d09c / 0x4b5bc8  release this+0x20 when [this+0x20] != 0; 0x4d3992(word [this+0x1c]) when != -1; the cleanup
 *   0x47591f  dword 0x5a0545 := 0; five dwords from 0x5a0549 := 0
 * Every object test fills the object with a position-dependent pattern first and compares the whole object afterwards, so a store
 * at a wrong offset or width is caught. */
#include "../src/original_methods_fl17.h"

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

#define OBJ 0x1000u

static void fill(uint8_t *o, uint8_t seed)
{
    size_t i;
    for (i = 0; i < OBJ; i++) o[i] = (uint8_t)(i * 7u + seed + (i >> 8));
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

/* ---- the call log of the host --------------------------------------------------------------------------------------------- */

enum {
    C_EDB97 = 1, C_E2FAA, C_E7BF3, C_EBA54, C_CCEF1, C_CCFF5, C_CCDAB, C_CBB00, C_CAF03, C_FC808, C_EA06C, C_D3992, C_C5377,
    C_FREE, C_UNMAP, C_CLOSE, C_RELEASE, C_RELEASE16, C_TICK, C_RESOLVE
};

typedef struct Log {
    int n;
    int id[24];
    const void *p[24];       /* self / slot / address pointer of the call */
    uint32_t a[24], b[24], c[24], d[24], e[24];
    uint32_t snap[24][4];    /* per call: world->value_583204, value_5831c8, value_5bb22a, word [watch+0x6b2] */
    const Fl17World *world;  /* when set, snapshot its three dwords at every callback */
    const uint8_t *watch;    /* when set, snapshot the word at watch + 0x6b2 and the dword at watch + 0x212 */
    uint32_t seen_slot[24];  /* the dword at the slot when a release ran */
    uint32_t seen_212[24];
    uint32_t tick;
    uint32_t resolve_address;
    const uint8_t *resolve_result;
    int resolve_calls;
} Log;

static void note(Log *l, int id, const void *p, uint32_t a, uint32_t b, uint32_t c, uint32_t d, uint32_t e)
{
    if (l->n < 24) {
        int k = l->n;
        l->id[k] = id;
        l->p[k] = p;
        l->a[k] = a;
        l->b[k] = b;
        l->c[k] = c;
        l->d[k] = d;
        l->e[k] = e;
        if (l->world != NULL) {
            l->snap[k][0] = l->world->value_583204;
            l->snap[k][1] = l->world->value_5831c8;
            l->snap[k][2] = l->world->value_5bb22a;
        }
        if (l->watch != NULL) {
            l->snap[k][3] = get16(l->watch, 0x6b2);
            l->seen_212[k] = get32(l->watch, 0x212);
        }
    }
    l->n++;
}

#define L(c) ((Log *)(c))
static void h_edb97(void *c, uint8_t *s) { note(L(c), C_EDB97, s, 0, 0, 0, 0, 0); }
static void h_e2faa(void *c, uint8_t *s) { note(L(c), C_E2FAA, s, 0, 0, 0, 0, 0); }
static void h_e7bf3(void *c, uint8_t *s) { note(L(c), C_E7BF3, s, 0, 0, 0, 0, 0); }
static void h_eba54(void *c, uint8_t *s) { note(L(c), C_EBA54, s, 0, 0, 0, 0, 0); }
static void h_ccef1(void *c, uint8_t *s) { note(L(c), C_CCEF1, s, 0, 0, 0, 0, 0); }
static void h_ccff5(void *c, uint8_t *s) { note(L(c), C_CCFF5, s, 0, 0, 0, 0, 0); }
static void h_ccdab(void *c, uint8_t *s) { note(L(c), C_CCDAB, s, 0, 0, 0, 0, 0); }
static void h_cbb00(void *c, uint8_t *s) { note(L(c), C_CBB00, s, 0, 0, 0, 0, 0); }
static void h_caf03(void *c, uint8_t *s) { note(L(c), C_CAF03, s, 0, 0, 0, 0, 0); }
static void h_fc808(void *c, uint8_t *s, uint16_t v) { note(L(c), C_FC808, s, v, 0, 0, 0, 0); }
static void h_ea06c(void *c, uint8_t *s, uint16_t v) { note(L(c), C_EA06C, s, v, 0, 0, 0, 0); }
static void h_d3992(void *c, uint16_t v) { note(L(c), C_D3992, NULL, v, 0, 0, 0, 0); }
static void h_c5377(void *c, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
    note(L(c), C_C5377, NULL, a1, a2, a3, a4, a5);
}
static void h_free(void *c, uint32_t a) { note(L(c), C_FREE, NULL, a, 0, 0, 0, 0); }
static void h_unmap(void *c, uint32_t a) { note(L(c), C_UNMAP, NULL, a, 0, 0, 0, 0); }
static void h_close(void *c, uint32_t a) { note(L(c), C_CLOSE, NULL, a, 0, 0, 0, 0); }
static void h_release(void *c, uint8_t *slot)
{
    Log *l = L(c);
    if (l->n < 24) l->seen_slot[l->n] = get32(slot, 0);
    note(l, C_RELEASE, slot, 0, 0, 0, 0, 0);
}
static void h_release16(void *c, uint8_t *slot)
{
    Log *l = L(c);
    if (l->n < 24) l->seen_slot[l->n] = get32(slot, 0);
    note(l, C_RELEASE16, slot, 0, 0, 0, 0, 0);
}
static uint32_t h_tick(void *c)
{
    note(L(c), C_TICK, NULL, 0, 0, 0, 0, 0);
    return L(c)->tick;
}
static const uint8_t *h_resolve(void *c, uint32_t address)
{
    Log *l = L(c);
    l->resolve_calls++;
    l->resolve_address = address;
    return l->resolve_result;
}

static void host_init(Fl17Host *h, Fl16Host *h16, Log *l)
{
    memset(l, 0, sizeof *l);
    memset(h, 0, sizeof *h);
    memset(h16, 0, sizeof *h16);
    h16->context = l;
    h16->tick = h_tick;
    h16->release_surface = h_release16;
    h->context = l;
    h->fl16 = h16;
    h->resolve = h_resolve;
    h->release_surface = h_release;
    h->call_4edb97 = h_edb97;
    h->call_4e2faa = h_e2faa;
    h->call_4e7bf3 = h_e7bf3;
    h->call_4eba54 = h_eba54;
    h->call_4ccef1 = h_ccef1;
    h->call_4ccff5 = h_ccff5;
    h->call_4ccdab = h_ccdab;
    h->call_4cbb00 = h_cbb00;
    h->call_4caf03 = h_caf03;
    h->call_4fc808 = h_fc808;
    h->call_4ea06c = h_ea06c;
    h->call_4d3992 = h_d3992;
    h->call_4c5377 = h_c5377;
    h->free_51dc6c = h_free;
    h->unmap_view = h_unmap;
    h->close_handle = h_close;
}

static uint8_t g_obj[OBJ], g_exp[OBJ], g_arg[OBJ], g_arg_exp[OBJ], g_other[OBJ];

/* ---- 0x424035, 0x42405a ---------------------------------------------------------------------------------------------------- */

static int test_m424035_selected_slot(void)
{
    Fl17Host h;
    Fl16Host h16;
    Log l;
    host_init(&h, &h16, &l);
    fill(g_arg, 1);
    memcpy(g_arg_exp, g_arg, OBJ);
    set32(g_arg, 0x24, 0);
    set32(g_arg_exp, 0x24, 0);
    CK(m424035_selected_slot(g_arg, &h) == -1);
    CK(l.resolve_calls == 0);
    CK(memcmp(g_arg, g_arg_exp, OBJ) == 0);
    fill(g_other, 9);
    set32(g_arg, 0x24, 0x00ABCDEFu);
    l.resolve_result = g_other;
    set16(g_other, 0x12, 0x7fff);
    CK(m424035_selected_slot(g_arg, &h) == 0x7fff);
    CK(l.resolve_calls == 1 && l.resolve_address == 0x00ABCDEFu);
    set16(g_other, 0x12, 0x8000);
    CK(m424035_selected_slot(g_arg, &h) == -32768);
    set16(g_other, 0x12, 0xffff);
    CK(m424035_selected_slot(g_arg, &h) == -1);
    set16(g_other, 0x12, 0);
    CK(m424035_selected_slot(g_arg, &h) == 0);
    set16(g_other, 0x12, 0x1234);
    set16(g_other, 0x10, 0xeeee);
    set16(g_other, 0x14, 0xeeee);
    CK(m424035_selected_slot(g_arg, &h) == 0x1234);
    return g_failed;
}

static int test_m42405a_get_control(void)
{
    fill(g_arg, 2);
    set32(g_arg, 0x30, 0xdeadbeefu);
    CK(m42405a_get_control(g_arg) == 0xdeadbeefu);
    set32(g_arg, 0x30, 0);
    CK(m42405a_get_control(g_arg) == 0);
    set32(g_arg, 0x30, 0x80000001u);
    CK(m42405a_get_control(g_arg) == 0x80000001u);
    return g_failed;
}

/* ---- 0x42ca22 -------------------------------------------------------------------------------------------------------------- */

static void rec(uint8_t *table, int i, int16_t w0, int16_t w2, int16_t w4)
{
    set16(table, (size_t)i * 6, (uint16_t)w0);
    set16(table, (size_t)i * 6 + 2, (uint16_t)w2);
    set16(table, (size_t)i * 6 + 4, (uint16_t)w4);
}

static int test_m42ca22_apply_event_flags(void)
{
    enum { N = 64, ZERO = 32 };
    uint32_t flags[N], want[N];
    uint8_t table[6 * 8];
    uint8_t owner[0x80];
    Fl17World w;
    int i;
    memset(&w, 0, sizeof w);
    memset(owner, 0xa5, sizeof owner);
    for (i = 0; i < N; i++) flags[i] = want[i] = 0x11110000u + (uint32_t)i;
    memset(table, 0x5a, sizeof table);
    w.flags_585801 = (uint8_t *)&flags[ZERO]; /* index 0 of the original table; negative indexes reach below it */
    w.key_5b4e00 = 5;
    w.owner_5b4ead = owner;
    w.table_5b4ea5 = table;
    set16(owner, 0x6d, 6);
    rec(table, 0, 5, 3, 0x1234);        /* matches: flags[3] := 0x1234 */
    rec(table, 1, 4, 7, 0x1111);        /* key differs: skipped */
    rec(table, 2, 5, -1, 0x2222);       /* index -1: skipped even though the key matches */
    rec(table, 3, 5, -2, (int16_t)0x8001); /* negative index other than -1 writes below the base; value is sign-extended */
    rec(table, 4, 5, 3, -7);            /* later record overwrites flags[3] */
    rec(table, 5, 5, 9, 0x4444);        /* matches: flags[9] */
    rec(table, 6, 5, 11, 0x5555);       /* records 6 and 7 lie beyond the count of 6: untouched */
    rec(table, 7, 5, 12, 0x6666);
    want[ZERO + 3] = (uint32_t)(int32_t)-7;
    want[ZERO - 2] = 0xffff8001u;
    want[ZERO + 9] = 0x4444;
    m42ca22_apply_event_flags(&w);
    CK(memcmp(flags, want, sizeof flags) == 0);
    CK(w.key_5b4e00 == 5 && w.owner_5b4ead == owner && w.table_5b4ea5 == table);
    /* a negative count does nothing, a zero count does nothing, a null table does nothing */
    for (i = 0; i < N; i++) flags[i] = want[i] = 0x22220000u + (uint32_t)i;
    set16(owner, 0x6d, (uint16_t)-3);
    m42ca22_apply_event_flags(&w);
    CK(memcmp(flags, want, sizeof flags) == 0);
    set16(owner, 0x6d, 0);
    m42ca22_apply_event_flags(&w);
    CK(memcmp(flags, want, sizeof flags) == 0);
    set16(owner, 0x6d, 6);
    w.table_5b4ea5 = NULL;
    m42ca22_apply_event_flags(&w);
    CK(memcmp(flags, want, sizeof flags) == 0);
    /* the key compares as a signed word: 0x8000 against 0x8000 matches, and the count 1 stops before the second record */
    w.table_5b4ea5 = table;
    w.key_5b4e00 = (int16_t)0x8000;
    set16(owner, 0x6d, 1);
    rec(table, 0, (int16_t)0x8000, 20, 0x0007);
    rec(table, 1, (int16_t)0x8000, 21, 0x0008);
    want[ZERO + 20] = 7;
    m42ca22_apply_event_flags(&w);
    CK(memcmp(flags, want, sizeof flags) == 0);
    return g_failed;
}

/* ---- 0x4d36ed --------------------------------------------------------------------------------------------------------------- */

static int test_m4d36ed_set_flags(void)
{
    Fl17World w, before;
    memset(&w, 0x6c, sizeof w);
    before = w;
    m4d36ed_set_flags(&w);
    before.value_5831c8 = 1;
    before.value_5831c6 = 0;
    CK(memcmp(&w, &before, sizeof w) == 0);
    return g_failed;
}

/* ---- 0x4cd218 --------------------------------------------------------------------------------------------------------------- */

static int test_m4cd218_destruct(void)
{
    Fl17Host h;
    Fl16Host h16;
    Log l;
    host_init(&h, &h16, &l);
    fill(g_obj, 3);
    memcpy(g_exp, g_obj, OBJ);
    set32(g_obj, 0x212, 0x1357u);
    l.watch = g_obj;
    m4cd218_destruct(g_obj, &h);
    CK(l.n == 4);
    CK(l.id[0] == C_CCEF1 && l.p[0] == g_obj);
    CK(l.id[1] == C_RELEASE16 && l.p[1] == g_obj + 0x212 && l.seen_slot[1] == 0x1357u); /* released through the FL-16 host while still set */
    CK(l.id[2] == C_CCFF5 && l.p[2] == g_obj && l.seen_212[2] == 0);                    /* and cleared before the next call */
    CK(l.id[3] == C_CCDAB && l.p[3] == g_obj);
    set32(g_exp, 0x212, 0);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    /* with the dword already 0 there is no release */
    host_init(&h, &h16, &l);
    set32(g_obj, 0x212, 0);
    m4cd218_destruct(g_obj, &h);
    CK(l.n == 3 && l.id[0] == C_CCEF1 && l.id[1] == C_CCFF5 && l.id[2] == C_CCDAB);
    return g_failed;
}

/* ---- 0x4fba69, 0x4fc05d ----------------------------------------------------------------------------------------------------- */

static int test_m4fba69_forward_word(void)
{
    Fl17Host h;
    Fl16Host h16;
    Log l;
    host_init(&h, &h16, &l);
    fill(g_obj, 4);
    fill(g_arg, 5);
    memcpy(g_exp, g_obj, OBJ);
    memcpy(g_arg_exp, g_arg, OBJ);
    set16(g_arg, 0x21, 0xfedc);
    set16(g_arg_exp, 0x21, 0xfedc);
    m4fba69_forward_word(g_obj, g_arg, &h);
    CK(l.n == 1 && l.id[0] == C_FC808 && l.p[0] == g_obj && l.a[0] == 0xfedcu);
    CK(memcmp(g_obj, g_exp, OBJ) == 0 && memcmp(g_arg, g_arg_exp, OBJ) == 0);
    set16(g_arg, 0x21, 0);
    m4fba69_forward_word(g_obj, g_arg, &h);
    CK(l.n == 2 && l.a[1] == 0);
    return g_failed;
}

static int test_m4fc05d_forward_global(void)
{
    Fl17Host h;
    Fl16Host h16;
    Log l;
    Fl17World w, before;
    host_init(&h, &h16, &l);
    memset(&w, 0x33, sizeof w);
    w.value_5b451f = 0xbeef;
    before = w;
    fill(g_obj, 6);
    memcpy(g_exp, g_obj, OBJ);
    m4fc05d_forward_global(g_obj, &w, &h);
    CK(l.n == 1 && l.id[0] == C_FC808 && l.p[0] == g_obj && l.a[0] == 0xbeefu);
    CK(memcmp(g_obj, g_exp, OBJ) == 0 && memcmp(&w, &before, sizeof w) == 0);
    w.value_5b451f = 0;
    m4fc05d_forward_global(g_obj, &w, &h);
    CK(l.n == 2 && l.a[1] == 0);
    return g_failed;
}

/* ---- 0x4e303b, 0x4e7d04, 0x4eb96e ------------------------------------------------------------------------------------------- */

static void world_pattern(Fl17World *w)
{
    memset(w, 0x4d, sizeof *w);
    w->value_583204 = 0x70000001u;
    w->value_5831c8 = 0x70000002u;
    w->value_5831c6 = 0x7003;
    w->value_5bb22a = 0x70000004u;
}

static int test_m4e303b_close(void)
{
    Fl17Host h;
    Fl16Host h16;
    Log l;
    Fl17World w, want;
    host_init(&h, &h16, &l);
    world_pattern(&w);
    w.slot_5d039f = 0x6789u;
    want = w;
    fill(g_obj, 7);
    memcpy(g_exp, g_obj, OBJ);
    l.world = &w;
    l.watch = g_obj;
    m4e303b_close(g_obj, &w, &h);
    CK(l.n == 3);
    CK(l.id[0] == C_EDB97 && l.p[0] == g_obj && l.snap[0][0] == 0x70000001u && l.snap[0][2] == 0x70000004u);
    CK(l.id[1] == C_E2FAA && l.p[1] == g_obj && l.snap[1][0] == 0x70000001u && l.snap[1][2] == 0x70000004u);
    /* the release is last: the stores before it are visible to it, and it sees the slot value still set */
    CK(l.id[2] == C_RELEASE && l.p[2] == (void *)&w.slot_5d039f && l.seen_slot[2] == 0x6789u);
    CK(l.snap[2][0] == 0 && l.snap[2][1] == 1 && l.snap[2][2] == 0 && l.snap[2][3] == 0x270fu);
    want.value_583204 = 0;
    want.value_5831c8 = 1;
    want.value_5831c6 = 0;
    want.value_5bb22a = 0;
    set16(g_exp, 0x6b2, 0x270f);
    CK(memcmp(&w, &want, sizeof w) == 0 && memcmp(g_obj, g_exp, OBJ) == 0);
    /* a zero slot is not released */
    host_init(&h, &h16, &l);
    w.slot_5d039f = 0;
    m4e303b_close(g_obj, &w, &h);
    CK(l.n == 2 && l.id[0] == C_EDB97 && l.id[1] == C_E2FAA);
    return g_failed;
}

static int test_m4e7d04_close(void)
{
    Fl17Host h;
    Fl16Host h16;
    Log l;
    Fl17World w, want;
    host_init(&h, &h16, &l);
    world_pattern(&w);
    w.slot_5d039f = w.slot_5d03a3 = w.slot_5d03a7 = 0x1u; /* untouched by this method */
    want = w;
    fill(g_obj, 8);
    memcpy(g_exp, g_obj, OBJ);
    l.world = &w;
    m4e7d04_close(g_obj, &w, &h);
    CK(l.n == 2);
    CK(l.id[0] == C_EDB97 && l.p[0] == g_obj && l.snap[0][0] == 0x70000001u && l.snap[0][1] == 0x70000002u);
    CK(l.id[1] == C_E7BF3 && l.p[1] == g_obj && l.snap[1][0] == 0x70000001u && l.snap[1][1] == 0x70000002u);
    want.value_583204 = 0;
    want.value_5831c8 = 1;
    want.value_5831c6 = 0;
    CK(memcmp(&w, &want, sizeof w) == 0 && memcmp(g_obj, g_exp, OBJ) == 0);
    return g_failed;
}

static int test_m4eb96e_close(void)
{
    Fl17Host h;
    Fl16Host h16;
    Log l;
    Fl17World w, want;
    host_init(&h, &h16, &l);
    world_pattern(&w);
    w.slot_5d03a3 = 0x1111u;
    w.slot_5d03a7 = 0x2222u;
    want = w;
    fill(g_obj, 9);
    memcpy(g_exp, g_obj, OBJ);
    l.world = &w;
    m4eb96e_close(g_obj, &w, &h);
    CK(l.n == 4);
    CK(l.id[0] == C_EDB97 && l.p[0] == g_obj && l.snap[0][0] == 0x70000001u);
    CK(l.id[1] == C_EBA54 && l.p[1] == g_obj && l.snap[1][0] == 0x70000001u);
    CK(l.id[2] == C_RELEASE && l.p[2] == (void *)&w.slot_5d03a3 && l.seen_slot[2] == 0x1111u && l.snap[2][0] == 0 && l.snap[2][1] == 1);
    CK(l.id[3] == C_RELEASE && l.p[3] == (void *)&w.slot_5d03a7 && l.seen_slot[3] == 0x2222u);
    want.value_583204 = 0;
    want.value_5831c8 = 1;
    want.value_5831c6 = 0;
    CK(memcmp(&w, &want, sizeof w) == 0 && memcmp(g_obj, g_exp, OBJ) == 0);
    /* each slot is released only when set */
    host_init(&h, &h16, &l);
    w.slot_5d03a3 = 0;
    m4eb96e_close(g_obj, &w, &h);
    CK(l.n == 3 && l.id[2] == C_RELEASE && l.p[2] == (void *)&w.slot_5d03a7);
    host_init(&h, &h16, &l);
    w.slot_5d03a3 = 5;
    w.slot_5d03a7 = 0;
    m4eb96e_close(g_obj, &w, &h);
    CK(l.n == 3 && l.id[2] == C_RELEASE && l.p[2] == (void *)&w.slot_5d03a3);
    host_init(&h, &h16, &l);
    w.slot_5d03a3 = 0;
    m4eb96e_close(g_obj, &w, &h);
    CK(l.n == 2);
    return g_failed;
}

/* ---- 0x4caf8a, 0x4cf749 ----------------------------------------------------------------------------------------------------- */

static int test_m4caf8a_reset(void)
{
    Fl17Host h;
    Fl16Host h16;
    Log l;
    host_init(&h, &h16, &l);
    fill(g_obj, 10);
    memcpy(g_exp, g_obj, OBJ);
    set16(g_obj, 0xc, 0x0042);
    set16(g_exp, 0xc, 0x0042);
    m4caf8a_reset(g_obj, &h);
    CK(l.n == 3 && l.id[0] == C_CBB00 && l.p[0] == g_obj && l.id[1] == C_D3992 && l.a[1] == 0x42 && l.id[2] == C_CAF03 && l.p[2] == g_obj);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    /* a word of 0xffff skips 0x4d3992; 0x8000 (negative, not -1) does not */
    host_init(&h, &h16, &l);
    set16(g_obj, 0xc, 0xffff);
    m4caf8a_reset(g_obj, &h);
    CK(l.n == 2 && l.id[0] == C_CBB00 && l.id[1] == C_CAF03);
    host_init(&h, &h16, &l);
    set16(g_obj, 0xc, 0x8000);
    m4caf8a_reset(g_obj, &h);
    CK(l.n == 3 && l.id[1] == C_D3992 && l.a[1] == 0x8000u);
    return g_failed;
}

static int test_m4cf749_notify(void)
{
    Fl17Host h;
    Fl16Host h16;
    Log l;
    Fl17World w, before;
    host_init(&h, &h16, &l);
    memset(&w, 0x21, sizeof w);
    w.value_638433 = 1;
    w.value_638423 = 2;
    w.value_5d1a39 = 0xa1;
    w.value_5cf665 = 0xa2;
    w.value_5d1a3d = 0xa3;
    w.value_5d1a41 = 0xa4;
    before = w;
    m4cf749_notify(&w, &h);
    CK(l.n == 1 && l.id[0] == C_C5377 && l.a[0] == 0xa1 && l.b[0] == 0xa2 && l.c[0] == 0xa3 && l.d[0] == 0xa4 && l.e[0] == 0x559d94u);
    CK(memcmp(&w, &before, sizeof w) == 0);
    host_init(&h, &h16, &l);
    w.value_638423 = 0;
    m4cf749_notify(&w, &h);
    CK(l.n == 0);
    w.value_638423 = 2;
    w.value_638433 = 0;
    m4cf749_notify(&w, &h);
    CK(l.n == 0);
    return g_failed;
}

/* ---- 0x48c0ac --------------------------------------------------------------------------------------------------------------- */

static int test_m48c0ac_accept_piece(void)
{
    enum { R = 0x8d };
    Fl17Host h;
    Fl16Host h16;
    Log l;
    Fl17World w;
    static uint8_t records[R * 8], records_exp[R * 8];
    uint8_t source[0x400];
    host_init(&h, &h16, &l);
    memset(&w, 0, sizeof w);
    fill(g_obj, 11);
    memset(records, 0x3c, sizeof records);
    memset(source, 0xc3, sizeof source);
    w.records_5bb5e5 = records;
    l.resolve_result = source;
    /* 0x27a9: byte +0x47 := 1, record 2 field +0x4d := 2, no object is resolved */
    set16(g_obj, 0x26, 2);
    set16(g_obj, 0x28, 3);
    set32(records, 2 * R, 0x00400000u);
    memcpy(g_exp, g_obj, OBJ);
    memcpy(records_exp, records, sizeof records);
    w.value_5c39e5 = 0x27a9;
    m48c0ac_accept_piece(g_obj, &w, &h);
    g_exp[0x47] = 1;
    g_exp[0x1c] = 0xff;
    g_exp[0x40] = 0;
    set32(records_exp, 2 * R + 0x4d, 2);
    CK(memcmp(g_obj, g_exp, OBJ) == 0 && memcmp(records, records_exp, sizeof records) == 0 && l.resolve_calls == 0);
    /* 0x27a8: word +0x54 := word at object + 3 * 0x12 + 0x160 */
    memcpy(records_exp, records, sizeof records);
    fill(g_obj, 12);
    set16(g_obj, 0x26, 5);
    set16(g_obj, 0x28, 3);
    set32(records, 5 * R, 0x00500000u);
    set16(source, 0x160 + 3 * 0x12, 0xabcd);
    memcpy(g_exp, g_obj, OBJ);
    memcpy(records_exp, records, sizeof records);
    w.value_5c39e5 = 0x27a8;
    m48c0ac_accept_piece(g_obj, &w, &h);
    set16(g_exp, 0x54, 0xabcd);
    g_exp[0x1c] = 0xff;
    g_exp[0x40] = 0;
    set32(records_exp, 5 * R + 0x4d, 2);
    CK(memcmp(g_obj, g_exp, OBJ) == 0 && memcmp(records, records_exp, sizeof records) == 0);
    CK(l.resolve_calls == 1 && l.resolve_address == 0x00500000u);
    /* any other value: only the always-stores */
    fill(g_obj, 13);
    set16(g_obj, 0x26, 1);
    memcpy(g_exp, g_obj, OBJ);
    memcpy(records_exp, records, sizeof records);
    w.value_5c39e5 = 0x27aa;
    l.resolve_calls = 0;
    m48c0ac_accept_piece(g_obj, &w, &h);
    g_exp[0x1c] = 0xff;
    g_exp[0x40] = 0;
    CK(memcmp(g_obj, g_exp, OBJ) == 0 && memcmp(records, records_exp, sizeof records) == 0 && l.resolve_calls == 0);
    return g_failed;
}

/* ---- 0x415011 --------------------------------------------------------------------------------------------------------------- */

static int test_m415011_close_handles(void)
{
    Fl17Host h;
    Fl16Host h16;
    Log l;
    host_init(&h, &h16, &l);
    fill(g_arg, 14);
    memcpy(g_arg_exp, g_arg, OBJ);
    set32(g_arg, 0x21, 0x1001);
    set32(g_arg, 0x2d, 0x1002);
    set32(g_arg, 0x29, 0x1003);
    set32(g_arg, 0x25, 0x1004);
    memcpy(g_arg_exp, g_arg, OBJ);
    m415011_close_handles(g_arg, &h);
    CK(l.n == 4);
    CK(l.id[0] == C_FREE && l.a[0] == 0x1001 && l.id[1] == C_UNMAP && l.a[1] == 0x1002 && l.id[2] == C_CLOSE && l.a[2] == 0x1003 &&
       l.id[3] == C_CLOSE && l.a[3] == 0x1004);
    set32(g_arg_exp, 0x21, 0);
    set32(g_arg_exp, 0x2d, 0);
    set32(g_arg_exp, 0x29, 0);
    set32(g_arg_exp, 0x25, 0);
    g_arg_exp[0x4d] = 0;
    CK(memcmp(g_arg, g_arg_exp, OBJ) == 0);
    /* nothing set: no calls, byte +0x4d still cleared, the rest untouched */
    host_init(&h, &h16, &l);
    fill(g_arg, 15);
    set32(g_arg, 0x21, 0);
    set32(g_arg, 0x2d, 0);
    set32(g_arg, 0x29, 0);
    set32(g_arg, 0x25, 0);
    memcpy(g_arg_exp, g_arg, OBJ);
    g_arg_exp[0x4d] = 0;
    m415011_close_handles(g_arg, &h);
    CK(l.n == 0 && memcmp(g_arg, g_arg_exp, OBJ) == 0);
    /* each handle on its own */
    host_init(&h, &h16, &l);
    set32(g_arg, 0x29, 0x77);
    memcpy(g_arg_exp, g_arg, OBJ);
    set32(g_arg_exp, 0x29, 0);
    m415011_close_handles(g_arg, &h);
    CK(l.n == 1 && l.id[0] == C_CLOSE && l.a[0] == 0x77 && memcmp(g_arg, g_arg_exp, OBJ) == 0);
    host_init(&h, &h16, &l);
    set32(g_arg, 0x2d, 0x88);
    memcpy(g_arg_exp, g_arg, OBJ);
    set32(g_arg_exp, 0x2d, 0);
    m415011_close_handles(g_arg, &h);
    CK(l.n == 1 && l.id[0] == C_UNMAP && l.a[0] == 0x88 && memcmp(g_arg, g_arg_exp, OBJ) == 0);
    host_init(&h, &h16, &l);
    set32(g_arg, 0x25, 0x99);
    memcpy(g_arg_exp, g_arg, OBJ);
    set32(g_arg_exp, 0x25, 0);
    m415011_close_handles(g_arg, &h);
    CK(l.n == 1 && l.id[0] == C_CLOSE && l.a[0] == 0x99 && memcmp(g_arg, g_arg_exp, OBJ) == 0);
    host_init(&h, &h16, &l);
    set32(g_arg, 0x21, 0x55);
    memcpy(g_arg_exp, g_arg, OBJ);
    set32(g_arg_exp, 0x21, 0);
    m415011_close_handles(g_arg, &h);
    CK(l.n == 1 && l.id[0] == C_FREE && l.a[0] == 0x55 && memcmp(g_arg, g_arg_exp, OBJ) == 0);
    return g_failed;
}

/* ---- 0x4eac4c --------------------------------------------------------------------------------------------------------------- */

static int test_m4eac4c_use_item(void)
{
    enum { R = 0x8d };
    Fl17Host h;
    Fl16Host h16;
    Log l;
    Fl17World w;
    static uint8_t records[R * 8], records_exp[R * 8];
    uint8_t source[0x20];
    host_init(&h, &h16, &l);
    memset(&w, 0, sizeof w);
    fill(g_obj, 16);
    memcpy(g_exp, g_obj, OBJ);
    memset(records, 0x2b, sizeof records);
    memset(source, 0x9d, sizeof source);
    w.records_5bb5e5 = records;
    l.resolve_result = source;
    set32(records, 3 * R, 0x00600000u);
    set16(source, 0, 0x8765);
    memcpy(records_exp, records, sizeof records);
    w.value_583a29 = 0x1234; /* differs: kept */
    m4eac4c_use_item(g_obj, 3, &w, &h);
    records_exp[3 * R + 0x40] = 1;
    CK(l.resolve_calls == 1 && l.resolve_address == 0x00600000u);
    CK(l.n == 1 && l.id[0] == C_EA06C && l.p[0] == g_obj && l.a[0] == 0x8765u);
    CK(w.value_583a29 == 0x1234 && memcmp(records, records_exp, sizeof records) == 0 && memcmp(g_obj, g_exp, OBJ) == 0);
    /* equal as signed words: reset to -1 */
    host_init(&h, &h16, &l);
    l.resolve_result = source;
    w.value_583a29 = (int16_t)0x8765;
    m4eac4c_use_item(g_obj, 3, &w, &h);
    CK(w.value_583a29 == -1 && l.n == 1);
    /* the compare is made after the call: a callee that changes the global is seen */
    host_init(&h, &h16, &l);
    l.resolve_result = source;
    w.value_583a29 = 0x4321;
    set16(source, 0, 0x4321);
    m4eac4c_use_item(g_obj, 3, &w, &h);
    CK(w.value_583a29 == -1);
    return g_failed;
}

/* ---- the cleanups ----------------------------------------------------------------------------------------------------------- */

typedef struct Edit {
    size_t off;
    int width;
    uint32_t value;
} Edit;

static int check_edits(const Edit *e, int count)
{
    int i;
    for (i = 0; i < count; i++) {
        if (e[i].width == 1) g_exp[e[i].off] = (uint8_t)e[i].value;
        else if (e[i].width == 2) set16(g_exp, e[i].off, (uint16_t)e[i].value);
        else set32(g_exp, e[i].off, e[i].value);
    }
    return memcmp(g_obj, g_exp, OBJ) == 0;
}

#define EDITS(arr) (arr), (int)(sizeof(arr) / sizeof((arr)[0]))

static int test_m48d067_cleanup(void)
{
    static const Edit e[] = {{0x1e, 2, 0xffff}, {0x1c, 2, 0xffff}, {0x33, 4, 0}, {0x37, 1, 0}, {0x38, 1, 0}};
    fill(g_obj, 17);
    memcpy(g_exp, g_obj, OBJ);
    m48d067_cleanup(g_obj);
    CK(check_edits(EDITS(e)));
    return g_failed;
}

static int test_m461827_cleanup(void)
{
    static const Edit e[] = {{0x1e, 2, 0xffff}, {0x1c, 2, 0xffff}, {0x3f, 4, 0}, {0x43, 4, 0}, {0x47, 4, 0}};
    fill(g_obj, 18);
    memcpy(g_exp, g_obj, OBJ);
    m461827_cleanup(g_obj);
    CK(check_edits(EDITS(e)));
    return g_failed;
}

static int test_m4b5b8a_cleanup(void)
{
    static const Edit e[] = {{0x1e, 2, 0xffff}, {0x1c, 2, 0xffff}, {0x225, 4, 0}, {0x229, 1, 0}, {0x22a, 1, 0}};
    fill(g_obj, 19);
    memcpy(g_exp, g_obj, OBJ);
    m4b5b8a_cleanup(g_obj);
    CK(check_edits(EDITS(e)));
    return g_failed;
}

static int test_m45b3ea_cleanup(void)
{
    static const Edit e[] = {{0x1e, 2, 0xffff}, {0x1c, 2, 0xffff}, {0x166, 4, 0}, {0x16a, 4, 0}, {0x162, 4, 0}};
    fill(g_obj, 20);
    memcpy(g_exp, g_obj, OBJ);
    m45b3ea_cleanup(g_obj);
    CK(check_edits(EDITS(e)));
    return g_failed;
}

static int test_m483f6a_cleanup(void)
{
    static const Edit e[] = {{0x26, 2, 0xffff}, {0x1c, 2, 0xffff}, {0xba7, 4, 0}, {0xbab, 1, 0}, {0xbb0, 1, 0}, {0xa92, 4, 0}};
    fill(g_obj, 21);
    memcpy(g_exp, g_obj, OBJ);
    m483f6a_cleanup(g_obj);
    CK(check_edits(EDITS(e)));
    return g_failed;
}

static int test_m44d107_cleanup(void)
{
    static const Edit e[] = {{0x1e, 2, 0xffff}, {0x1c, 2, 0xffff}, {0x25, 4, 0}, {0x49, 1, 0}, {0x4a, 1, 0}};
    Fl17Host h;
    Fl16Host h16;
    Log l;
    Fl17World w;
    uint8_t shared[0x600];
    host_init(&h, &h16, &l);
    memset(&w, 0, sizeof w);
    fill(g_obj, 22);
    memcpy(g_exp, g_obj, OBJ);
    memset(shared, 0x44, sizeof shared);
    w.object_61c387 = shared;
    /* the shared object's dword +0x1c is non-zero: its +0x456 is stamped with GetTickCount() - 5 */
    set32(shared, 0x1c, 1);
    l.tick = 1000;
    m44d107_cleanup(g_obj, &w, &h);
    CK(check_edits(EDITS(e)));
    CK(l.n == 1 && l.id[0] == C_TICK && get32(shared, 0x456) == 995u);
    /* zero: nothing else happens */
    host_init(&h, &h16, &l);
    set32(shared, 0x1c, 0);
    set32(shared, 0x456, 0x12345678u);
    fill(g_obj, 23);
    memcpy(g_exp, g_obj, OBJ);
    m44d107_cleanup(g_obj, &w, &h);
    CK(check_edits(EDITS(e)));
    CK(l.n == 0 && get32(shared, 0x456) == 0x12345678u);
    return g_failed;
}

/* ---- the begin-scene wrappers ----------------------------------------------------------------------------------------------- */

typedef void (*BeginFn)(uint8_t *, const Fl17Host *);

/* shared checker: `edits` are the cleanup stores that must follow the release and the 0x4d3992 call */
static int check_begin(BeginFn fn, const Edit *edits, int count)
{
    Fl17Host h;
    Fl16Host h16;
    Log l;
    host_init(&h, &h16, &l);
    /* both the slot and the word set */
    fill(g_obj, 24);
    set32(g_obj, 0x20, 0x4141);
    set16(g_obj, 0x1c, 0x0017);
    memcpy(g_exp, g_obj, OBJ);
    fn(g_obj, &h);
    CK(l.n == 2 && l.id[0] == C_RELEASE && l.p[0] == g_obj + 0x20 && l.seen_slot[0] == 0x4141u);
    CK(l.id[1] == C_D3992 && l.a[1] == 0x17);
    CK(check_edits(edits, count)); /* the word at +0x1c was read before the cleanup reset it */
    /* slot 0, word -1: no calls */
    host_init(&h, &h16, &l);
    fill(g_obj, 25);
    set32(g_obj, 0x20, 0);
    set16(g_obj, 0x1c, 0xffff);
    memcpy(g_exp, g_obj, OBJ);
    fn(g_obj, &h);
    CK(l.n == 0 && check_edits(edits, count));
    /* slot set, word -1 */
    host_init(&h, &h16, &l);
    fill(g_obj, 26);
    set32(g_obj, 0x20, 1);
    set16(g_obj, 0x1c, 0xffff);
    memcpy(g_exp, g_obj, OBJ);
    fn(g_obj, &h);
    CK(l.n == 1 && l.id[0] == C_RELEASE && check_edits(edits, count));
    /* slot 0, word 0x8000 (negative but not -1) */
    host_init(&h, &h16, &l);
    fill(g_obj, 27);
    set32(g_obj, 0x20, 0);
    set16(g_obj, 0x1c, 0x8000);
    memcpy(g_exp, g_obj, OBJ);
    fn(g_obj, &h);
    CK(l.n == 1 && l.id[0] == C_D3992 && l.a[0] == 0x8000u && check_edits(edits, count));
    return g_failed;
}

static void wrap_44d154(uint8_t *self, const Fl17Host *h)
{
    Fl17World w;
    uint8_t shared[0x600];
    memset(&w, 0, sizeof w);
    memset(shared, 0, sizeof shared); /* dword +0x1c == 0: 0x44d107 stamps nothing */
    w.object_61c387 = shared;
    m44d154_begin_scene(self, &w, h);
}

static int test_m44d154_begin_scene(void)
{
    static const Edit e[] = {{0x1e, 2, 0xffff}, {0x1c, 2, 0xffff}, {0x25, 4, 0}, {0x49, 1, 0}, {0x4a, 1, 0}};
    check_begin(wrap_44d154, EDITS(e));
    /* the chained 0x44d107 stamps the shared object when its dword +0x1c is set, after the release and the 0x4d3992 call */
    {
        Fl17Host h;
        Fl16Host h16;
        Log l;
        Fl17World w;
        uint8_t shared[0x600];
        host_init(&h, &h16, &l);
        memset(&w, 0, sizeof w);
        memset(shared, 0, sizeof shared);
        set32(shared, 0x1c, 9);
        w.object_61c387 = shared;
        l.tick = 50;
        fill(g_obj, 28);
        set32(g_obj, 0x20, 3);
        set16(g_obj, 0x1c, 5);
        m44d154_begin_scene(g_obj, &w, &h);
        CK(l.n == 3 && l.id[0] == C_RELEASE && l.id[1] == C_D3992 && l.id[2] == C_TICK && get32(shared, 0x456) == 45u);
    }
    return g_failed;
}

static int test_m45b42e_begin_scene(void)
{
    static const Edit e[] = {{0x1e, 2, 0xffff}, {0x1c, 2, 0xffff}, {0x166, 4, 0}, {0x16a, 4, 0}, {0x162, 4, 0}};
    return check_begin(m45b42e_begin_scene, EDITS(e));
}

static int test_m461862_begin_scene(void)
{
    static const Edit e[] = {{0x1e, 2, 0xffff}, {0x1c, 2, 0xffff}, {0x3f, 4, 0}, {0x43, 4, 0}, {0x47, 4, 0}};
    return check_begin(m461862_begin_scene, EDITS(e));
}

static int test_m48d09c_begin_scene(void)
{
    static const Edit e[] = {{0x1e, 2, 0xffff}, {0x1c, 2, 0xffff}, {0x33, 4, 0}, {0x37, 1, 0}, {0x38, 1, 0}};
    return check_begin(m48d09c_begin_scene, EDITS(e));
}

static int test_m4b5bc8_begin_scene(void)
{
    static const Edit e[] = {{0x1e, 2, 0xffff}, {0x1c, 2, 0xffff}, {0x225, 4, 0}, {0x229, 1, 0}, {0x22a, 1, 0}};
    return check_begin(m4b5bc8_begin_scene, EDITS(e));
}

/* ---- 0x47591f --------------------------------------------------------------------------------------------------------------- */

static int test_m47591f_clear_block(void)
{
    Fl17World w, want;
    memset(&w, 0x5e, sizeof w);
    want = w;
    memset(want.block_5a0545, 0, sizeof want.block_5a0545); /* dword 0x5a0545 and five dwords from 0x5a0549: all 0x18 bytes */
    m47591f_clear_block(&w);
    CK(memcmp(&w, &want, sizeof w) == 0);
    return g_failed;
}

typedef int (*TestFn)(void);
static int run_one(const char *name, TestFn fn)
{
    g_failed = 0;
    memset(g_msg, 0, sizeof g_msg);
    if (fn() == 0) {
        printf("PASS %s\n", name);
        return 0;
    }
    printf("FAIL %s: %s\n", name, g_msg);
    return 1;
}

#define RUN(fn) failures += run_one(#fn, fn)

int main(void)
{
    int failures = 0;
    RUN(test_m424035_selected_slot);
    RUN(test_m42405a_get_control);
    RUN(test_m42ca22_apply_event_flags);
    RUN(test_m4d36ed_set_flags);
    RUN(test_m4cd218_destruct);
    RUN(test_m4fba69_forward_word);
    RUN(test_m4fc05d_forward_global);
    RUN(test_m4e303b_close);
    RUN(test_m4e7d04_close);
    RUN(test_m4eb96e_close);
    RUN(test_m4caf8a_reset);
    RUN(test_m4cf749_notify);
    RUN(test_m48c0ac_accept_piece);
    RUN(test_m415011_close_handles);
    RUN(test_m4eac4c_use_item);
    RUN(test_m48d067_cleanup);
    RUN(test_m461827_cleanup);
    RUN(test_m4b5b8a_cleanup);
    RUN(test_m45b3ea_cleanup);
    RUN(test_m483f6a_cleanup);
    RUN(test_m44d107_cleanup);
    RUN(test_m44d154_begin_scene);
    RUN(test_m45b42e_begin_scene);
    RUN(test_m461862_begin_scene);
    RUN(test_m48d09c_begin_scene);
    RUN(test_m4b5bc8_begin_scene);
    RUN(test_m47591f_clear_block);
    return failures;
}
