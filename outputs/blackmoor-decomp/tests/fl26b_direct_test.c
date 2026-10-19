/* FL-26 (batch b) direct tests of the 0x62 interaction path functions of GAME.EXE in src/original_methods_fl26b.c. Prints "PASS <name>" /
 * "FAIL <name>: <msg>"; the exit status is the failure count. Fixtures are synthetic (no original bytes). Expected values were derived by
 * hand from the disassembly of GAME.EXE, not from running the native code; tests/test_fl26b_differential.py additionally runs the original
 * bytes on generated fixtures. Every function is checked three ways: each guard failing in turn (object and call log untouched), each arm with the
 * stores and the ordered host calls spelled out, and the native rejections of the unsafe cases (an unresolved address, a node of an unknown
 * kind, a cycle of the chain) which have no counterpart in the original. */
#include "../src/original_methods_fl26b.h"

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

#define ARENA_VA 0x20000000u
#define ARENA_SZ 0x4000
#define NODE 0x48
#define SELF_SZ 0x20000
#define REC 0x8d

static uint8_t arena[ARENA_SZ];
static uint8_t self_buf[SELF_SZ];
static uint8_t rectab[REC * 6 + 8];
static uint8_t flags_tab[0x200];
static Fl26bWorld world;
static Fl18Host host;

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

/* guest address of the arena offset */
#define VA(off) (ARENA_VA + (uint32_t)(off))
#define A32(off, v) set32(arena, (off), (v))

static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[4];
    } c[16];
} L;
static uint32_t g_ret_4235fd[4];
static int g_n_4235fd;

static uint32_t host_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int i;
    (void)ctx;
    if (L.n >= 16) return 0;
    L.c[L.n].callee = callee;
    L.c[L.n].this_ptr = this_ptr;
    L.c[L.n].nargs = nargs;
    for (i = 0; i < nargs && i < 4; i++) L.c[L.n].a[i] = args[i];
    L.n++;
    if (callee == 0x4235fd) {
        uint32_t r = g_ret_4235fd[g_n_4235fd < 3 ? g_n_4235fd : 3];
        g_n_4235fd++;
        return r;
    }
    return 0;
}

static const uint8_t *host_resolve(void *ctx, uint32_t a)
{
    (void)ctx;
    if (a >= ARENA_VA && a < ARENA_VA + ARENA_SZ) return arena + (a - ARENA_VA);
    return NULL;
}

static uint32_t host_tick(void *ctx)
{
    (void)ctx;
    return 0;
}

static void setup(void)
{
    memset(arena, 0xA5, sizeof arena);
    memset(self_buf, 0xA5, sizeof self_buf);
    memset(rectab, 0xCC, sizeof rectab);
    memset(flags_tab, 0x77, sizeof flags_tab);
    memset(&world, 0, sizeof world);
    world.records_5bb5e5 = rectab + REC + 8;
    world.flags_585801 = flags_tab + 0x40;
    memset(&host, 0, sizeof host);
    host.call = host_call;
    host.resolve = host_resolve;
    host.tick = host_tick;
    memset(&L, 0, sizeof L);
    memset(g_ret_4235fd, 0, sizeof g_ret_4235fd);
    g_n_4235fd = 0;
}

static int call_is(int i, uint32_t callee, uintptr_t this_ptr, int nargs) { return i < L.n && L.c[i].callee == callee && L.c[i].this_ptr == this_ptr && L.c[i].nargs == nargs; }

/* ---- 0x423fbb ------------------------------------------------------------------------------------------------------------- */

static void test_m423fbb_leaf_word(void)
{
    int32_t rej, r;
    setup();
    /* node at arena+0, leaf at arena+0x100; the leaf pointer is 0: [node+0x20] = 0, returns -1, no calls */
    A32(0x1c, 0);
    A32(0x20, 0xdeadbeef);
    r = m423fbb_leaf_word(VA(0), &host, &rej);
    CK(r == -1 && rej == 0 && get32(arena, 0x20) == 0 && L.n == 0 && get32(arena, 0x1c) == 0);
    /* a leaf: [node+0x20] = [leaf+0x40]; the signed word [leaf+0x12] (the bytes after it are ignored) */
    A32(0x1c, VA(0x100));
    set16(arena, 0x112, 0x8001);
    set16(arena, 0x114, 0xffff);
    A32(0x140, 0x11223344);
    r = m423fbb_leaf_word(VA(0), &host, &rej);
    CK(r == -32767 && rej == 0 && get32(arena, 0x20) == 0x11223344 && get32(arena, 0x1c) == VA(0x100));
    set16(arena, 0x112, 0x7fff);
    r = m423fbb_leaf_word(VA(0), &host, NULL);
    CK(r == 32767);
    set16(arena, 0x112, 0xffff);
    r = m423fbb_leaf_word(VA(0), &host, &rej);
    CK(r == -1 && rej == 0);
    set16(arena, 0x112, 0);
    A32(0x140, 0);
    r = m423fbb_leaf_word(VA(0), &host, &rej);
    CK(r == 0 && get32(arena, 0x20) == 0);
    /* native rejections: the node, then the leaf, cannot be resolved */
    r = m423fbb_leaf_word(0x1000, &host, &rej);
    CK(r == 0 && rej == FL26B_REJECT_UNRESOLVED);
    A32(0x1c, 0x30000000u);
    r = m423fbb_leaf_word(VA(0), &host, &rej);
    CK(r == 0 && rej == FL26B_REJECT_UNRESOLVED);
    CK(L.n == 0);
}

/* ---- 0x4eb107 ------------------------------------------------------------------------------------------------------------- */

static void test_m4eb107_item_use_feedback(void)
{
    static const struct {
        int16_t item;
        uint32_t ecx;     /* args[0] of 0x4e9e84: item * 0x16d with its low word replaced by the item */
    } T[] = {{2, 2}, {0, 0}, {300, 0x1012c}, {-1, 0xffffffffu}, {-5, 0xfffffffbu}, {172, 0x0000ac}, {1, 1}};
    size_t i;
    int j;
    setup();
    /* the item differs from the argument (also in the upper half only): nothing happens */
    world.word_583a29 = 2;
    set16(self_buf, 2 * 0x16d + 0x77e, 2);
    m4eb107_item_use_feedback(self_buf, 3, &world, &host);
    m4eb107_item_use_feedback(self_buf, 2 | 0x10000, &world, &host);
    m4eb107_item_use_feedback(self_buf, -2, &world, &host);
    CK(L.n == 0 && world.word_583a29 == 2);
    for (i = 0; i < sizeof T / sizeof T[0]; i++) {
        size_t at = (size_t)((ptrdiff_t)T[i].item * 0x16d + 0x77e);
        /* word 0: the item is cleared, only 0x4d36ed is called */
        setup();
        world.word_583a29 = T[i].item;
        set16(self_buf, at, 0);
        m4eb107_item_use_feedback(self_buf, T[i].item, &world, &host);
        CK(world.word_583a29 == -1 && L.n == 1 && call_is(0, 0x4d36ed, 0, 0));
        /* word 2: 0x4e9e84(self; ecx, 1) first, then the item is cleared, then 0x4d36ed */
        setup();
        world.word_583a29 = T[i].item;
        set16(self_buf, at, 2);
        m4eb107_item_use_feedback(self_buf, T[i].item, &world, &host);
        CK(world.word_583a29 == -1 && L.n == 2 && call_is(0, 0x4e9e84, (uintptr_t)self_buf, 2) && L.c[0].a[0] == T[i].ecx && L.c[0].a[1] == 1 && call_is(1, 0x4d36ed, 0, 0));
        /* any other word: the item stays, 0x4d36ed is called */
        for (j = 0; j < 6; j++) {
            static const uint16_t others[] = {1, 3, 0xffff, 0x7fff, 0x8000, 0x102};
            setup();
            world.word_583a29 = T[i].item;
            set16(self_buf, at, others[j]);
            m4eb107_item_use_feedback(self_buf, T[i].item, &world, &host);
            CK(world.word_583a29 == T[i].item && L.n == 1 && call_is(0, 0x4d36ed, 0, 0));
        }
    }
    /* the word is a signed 16-bit read: 0x0002 with garbage above it still counts as 2 */
    setup();
    world.word_583a29 = 1;
    set32(self_buf, 0x16d + 0x77e, 0xffff0002u);
    m4eb107_item_use_feedback(self_buf, 1, &world, &host);
    CK(L.n == 2 && call_is(0, 0x4e9e84, (uintptr_t)self_buf, 2));
    set32(self_buf, 0x16d + 0x77e, 0x00010000u);     /* low word 0, high word 1: the word is 0 */
    world.word_583a29 = 1;
    L.n = 0;
    m4eb107_item_use_feedback(self_buf, 1, &world, &host);
    CK(L.n == 1 && world.word_583a29 == -1);
}

/* ---- 0x42406d ------------------------------------------------------------------------------------------------------------- */

/* nodes at arena + 0x100 + NODE * k; the node argument at arena + 0, the aux object at arena + 0x40 */
#define ND(k) (0x100 + NODE * (k))
static void node_init(int k, uint32_t flag, int16_t word, int next, int ch)
{
    set32(arena, ND(k) + 4, flag);
    set16(arena, ND(k) + 0x16, (uint16_t)word);
    set32(arena, ND(k) + 0x34, ch < 0 ? 0 : VA(ND(ch)));
    set32(arena, ND(k) + 0x38, next < 0 ? 0 : VA(ND(next)));
}

static void arg_init(int head, uint32_t expected, int aux)
{
    A32(0, 0x55);
    A32(4, VA(ND(head)));
    A32(0xc, aux ? VA(0x40) : 0);
    A32(0x18, expected);
    A32(0x44, 0x9999);
}

static void test_m42406d_propagate(void)
{
    int32_t rej = -1;
    setup();
    /* one node with a clear flag, no links: the pass changes nothing; count 0 */
    node_init(0, 0, 1, -1, -1);
    arg_init(0, 0, 1);
    m42406d_propagate(VA(0), &host, &rej);
    CK(rej == 0 && get32(arena, 0) == 1 && get32(arena, 0x44) == 1 && get32(arena, ND(0) + 4) == 0 && L.n == 0);
    /* count mismatch: [node] = 0 and [aux + 4] = 0; without the aux object nothing else is written */
    arg_init(0, 1, 1);
    m42406d_propagate(VA(0), &host, &rej);
    CK(get32(arena, 0) == 0 && get32(arena, 0x44) == 0);
    arg_init(0, 1, 0);
    set32(arena, 0x44, 0x1234);
    m42406d_propagate(VA(0), &host, &rej);
    CK(get32(arena, 0) == 0 && get32(arena, 0x44) == 0x1234);
    /* next link, word 1: a clear flag takes a set next flag; the pass restarts; count 2 */
    node_init(0, 0, 1, 1, -1);
    node_init(1, 5, 0, -1, -1);
    arg_init(0, 2, 1);
    m42406d_propagate(VA(0), &host, &rej);
    CK(get32(arena, ND(0) + 4) == 1 && get32(arena, ND(1) + 4) == 5 && get32(arena, 0) == 1 && get32(arena, 0x44) == 1);
    /* the same with a set flag and a clear next flag: the next flag becomes 1 */
    node_init(0, 7, 1, 1, -1);
    node_init(1, 0, 0, -1, -1);
    arg_init(0, 2, 1);
    m42406d_propagate(VA(0), &host, &rej);
    CK(get32(arena, ND(0) + 4) == 7 && get32(arena, ND(1) + 4) == 1 && get32(arena, 0) == 1);
    /* the word of p is not 1 (0, 2, 0x101 low word...): the next link propagates nothing; count 1 */
    node_init(0, 7, 2, 1, -1);
    node_init(1, 0, 1, -1, -1);
    arg_init(0, 1, 1);
    m42406d_propagate(VA(0), &host, &rej);
    CK(get32(arena, ND(1) + 4) == 0 && get32(arena, 0) == 1);
    /* the second link [+0x34] is tested with the word of the LINKED node: node 2 (word 1) has a set flag, node 0 is clear -> node 0 set */
    node_init(0, 0, 9, -1, 2);
    node_init(2, 3, 1, -1, -1);
    arg_init(0, 1, 1);
    m42406d_propagate(VA(0), &host, &rej);
    CK(get32(arena, ND(0) + 4) == 1 && get32(arena, ND(2) + 4) == 3 && get32(arena, 0) == 1);
    /* the linked node's word is not 1: nothing; set flag on p and clear flag on the linked node with word 1: the linked flag becomes 1 */
    node_init(0, 4, 9, -1, 2);
    node_init(2, 0, 2, -1, -1);
    arg_init(0, 1, 1);
    m42406d_propagate(VA(0), &host, &rej);
    CK(get32(arena, ND(2) + 4) == 0 && get32(arena, 0) == 1);
    node_init(2, 0, 1, -1, -1);
    arg_init(0, 1, 1);
    m42406d_propagate(VA(0), &host, &rej);
    CK(get32(arena, ND(2) + 4) == 1 && get32(arena, 0) == 1);
    /* both flags set or both clear: no change in either direction */
    node_init(0, 1, 1, 1, 2);
    node_init(1, 9, 1, -1, -1);
    node_init(2, 8, 1, -1, -1);
    arg_init(0, 2, 0);
    m42406d_propagate(VA(0), &host, &rej);
    CK(get32(arena, ND(0) + 4) == 1 && get32(arena, ND(1) + 4) == 9 && get32(arena, ND(2) + 4) == 8 && get32(arena, 0) == 1);
    /* native rejections: the head is zero; an unresolved link; a cycle of the chain (the original never returns) */
    A32(4, 0);
    m42406d_propagate(VA(0), &host, &rej);
    CK(rej == FL26B_REJECT_UNRESOLVED);
    node_init(0, 0, 1, -1, 3);
    set32(arena, ND(3) + 0x34, 0);
    set32(arena, ND(0) + 0x34, 0x30000000u);
    set16(arena, ND(3) + 0x16, 1);
    arg_init(0, 0, 0);
    m42406d_propagate(VA(0), &host, &rej);
    CK(rej == FL26B_REJECT_UNRESOLVED);
    node_init(0, 0, 1, 0, -1);
    arg_init(0, 0, 0);
    m42406d_propagate(VA(0), &host, &rej);
    CK(rej == FL26B_REJECT_ENDLESS);
    m42406d_propagate(0x1000, &host, &rej);
    CK(rej == FL26B_REJECT_UNRESOLVED);
}

/* ---- 0x424201 ------------------------------------------------------------------------------------------------------------- */

static void walk_init(int head_kind, int head, int next)
{
    A32(4, VA(ND(head)));
    A32(ND(head), (uint32_t)head_kind);
    A32(ND(head) + 4, 0x4444);
    A32(ND(head) + 0x38, next < 0 ? 0 : VA(ND(next)));
    A32(ND(head) + 0x44, 0xabc0 + (uint32_t)head);
}

static void test_m424201_walk(void)
{
    int32_t rej = -1;
    uintptr_t self = (uintptr_t)self_buf;
    setup();
    /* kind 2, no next: [+8] = [+4]; 0x424346(self, p), then 0x42406d(self, node) */
    walk_init(2, 0, -1);
    m424201_walk(self_buf, VA(0), &world, &host, &rej);
    CK(rej == 0 && L.n == 2 && call_is(0, 0x424346, self, 1) && L.c[0].a[0] == VA(ND(0)) && call_is(1, 0x42406d, self, 1) && L.c[1].a[0] == VA(0));
    CK(get32(arena, ND(0) + 8) == 0x4444);
    /* a chain of two kind-2 nodes */
    setup();
    walk_init(2, 0, 1);
    walk_init(2, 1, -1);
    A32(4, VA(ND(0)));
    m424201_walk(self_buf, VA(0), &world, &host, &rej);
    CK(L.n == 3 && call_is(0, 0x424346, self, 1) && L.c[0].a[0] == VA(ND(0)) && call_is(1, 0x424346, self, 1) && L.c[1].a[0] == VA(ND(1)) && call_is(2, 0x42406d, self, 1));
    CK(get32(arena, ND(1) + 8) == 0x4444);
    /* kind 1: 0x42356d(self; node, p), 0x424201(self; [p + 0x44]), 0x4235fd(self) -> q; q[8] = r with a zero link: 0x42406d(self, q[0]) */
    setup();
    walk_init(1, 0, -1);
    A32(0x2000, 0x31313131);              /* q[0] */
    A32(0x2008, VA(ND(5)));               /* q[8] = r */
    A32(ND(5) + 0x38, 0);
    g_ret_4235fd[0] = VA(0x2000);
    m424201_walk(self_buf, VA(0), &world, &host, &rej);
    CK(rej == 0 && L.n == 4 && call_is(0, 0x42356d, self, 2) && L.c[0].a[0] == VA(0) && L.c[0].a[1] == VA(ND(0)));
    CK(call_is(1, 0x424201, self, 1) && L.c[1].a[0] == 0xabc0 && call_is(2, 0x4235fd, self, 0) && call_is(3, 0x42406d, self, 1) && L.c[3].a[0] == 0x31313131);
    CK(get32(arena, ND(0) + 8) == 0x4444);
    /* kind 1 whose r has a next node of kind 2: the loop goes on with that node (0x424346), then 0x42406d with the NEW node argument q[0] */
    setup();
    walk_init(1, 0, -1);
    A32(0x2000, 0x32323232);
    A32(0x2008, VA(ND(5)));
    A32(ND(5) + 0x38, VA(ND(6)));
    A32(ND(6), 2);
    A32(ND(6) + 0x38, 0);
    g_ret_4235fd[0] = VA(0x2000);
    m424201_walk(self_buf, VA(0), &world, &host, &rej);
    CK(L.n == 5 && call_is(3, 0x424346, self, 1) && L.c[3].a[0] == VA(ND(6)) && call_is(4, 0x42406d, self, 1) && L.c[4].a[0] == 0x32323232);
    /* the error path: q == 0 -> 0x50ca3e, 0x52139c, 0x44a2b7 only when the signed word 0x63a4cd is non-zero, 0x4c97b4(this = 0x5cf659) */
    setup();
    walk_init(1, 0, -1);
    m424201_walk(self_buf, VA(0), &world, &host, &rej);
    CK(rej == 0 && L.n == 6 && call_is(3, 0x50ca3e, 0, 2) && L.c[3].a[0] == 0x63888b && L.c[3].a[1] == 0x544964);
    CK(call_is(4, 0x52139c, 0, 3) && L.c[4].a[0] == 0x63888b && L.c[4].a[1] == 0 && L.c[4].a[2] == 0 && call_is(5, 0x4c97b4, 0x5cf659, 0));
    setup();
    walk_init(1, 0, -1);
    world.word_63a4cd = -32768;
    m424201_walk(self_buf, VA(0), &world, &host, &rej);
    CK(L.n == 7 && call_is(5, 0x44a2b7, 0, 1) && L.c[5].a[0] == 0x63888b && call_is(6, 0x4c97b4, 0x5cf659, 0));
    /* native rejections: an unknown kind, an unresolved node, an unresolved head */
    setup();
    walk_init(3, 0, -1);
    m424201_walk(self_buf, VA(0), &world, &host, &rej);
    CK(rej == FL26B_REJECT_ENDLESS && L.n == 0);
    A32(4, 0);
    m424201_walk(self_buf, VA(0), &world, &host, &rej);
    CK(rej == FL26B_REJECT_UNRESOLVED && L.n == 0);
    m424201_walk(self_buf, 0x1000, &world, &host, &rej);
    CK(rej == FL26B_REJECT_UNRESOLVED);
}

/* ---- 0x42ea87 ------------------------------------------------------------------------------------------------------------- */

/* record i at rectab + REC + 8 + i * REC; its object at arena + 0x1000 */
#define RECP(i) (rectab + REC + 8 + (i) * REC)
static uint8_t *obj_ptr(void) { return arena + 0x1000; }

static void rec_init(int i, uint8_t kind, uint32_t state)
{
    memset(RECP(i), 0x5a, REC);
    set32(RECP(i), 0, VA(0x1000));
    RECP(i)[-2] = kind;
    set32(RECP(i), 0x4d, state);
    memset(obj_ptr(), 0x6b, 0x100);
}

static void test_m42ea87_record_state(void)
{
    int32_t rej = -1;
    uint8_t before[REC];
    int i;
    /* state 0, kind != 0x63: 0x5bb1ca = 1, state 1, flag [+0x41] cleared; list at obj + 0xa: count 3; entry 1 matches the key -> its four words */
    setup();
    rec_init(2, 0x62, 0);
    set16(obj_ptr(), 0xa, 3);
    for (i = 0; i < 3; i++) set16(obj_ptr(), 0xa + i * 0x12 + 2, (uint16_t)(0x100 + i));
    set16(obj_ptr(), 0xa + 0x12 + 4, 0x1111);
    set16(obj_ptr(), 0xa + 0x12 + 8, 0x2222);
    set16(obj_ptr(), 0xa + 0x12 + 0xc, 0x3333);
    set16(obj_ptr(), 0xa + 0x12 + 0x10, 0x4444);
    set16(obj_ptr(), 0xa + 3 * 0x12 + 2, 0x101);     /* the entry after the count: never looked at */
    world.word_5bb50b = 0x101;
    world.value_5bb1ca = 0;
    m42ea87_record_state(2, &world, &host, &rej);
    CK(rej == 0 && world.value_5bb1ca == 1 && get32(RECP(2), 0x4d) == 1 && get32(RECP(2), 0x41) == 1);
    CK(get16(RECP(2), 0x45) == 0x1111 && get16(RECP(2), 0x47) == 0x2222 && get16(RECP(2), 0x49) == 0x3333 && get16(RECP(2), 0x4b) == 0x4444 && L.n == 0);
    /* state 1, kind 0x63 (list at obj + 0x2a, 0x28 for the word), no entry matches: [+0x41] stays 0; the global 0x5bb1ca is not touched */
    rec_init(0, 0x63, 1);
    set16(obj_ptr(), 0x2a, 2);
    set16(obj_ptr(), 0x2a + 2, 7);
    set16(obj_ptr(), 0x2a + 0x12 + 2, 8);
    world.word_5bb50b = 9;
    world.value_5bb1ca = 0x55;
    set32(RECP(0), 0x41, 0xffffffffu);
    m42ea87_record_state(0, &world, &host, &rej);
    CK(world.value_5bb1ca == 0x55 && get32(RECP(0), 0x41) == 0 && get32(RECP(0), 0x4d) == 1);
    /* a count of 0 and a negative count run the loop zero times; the second entry of count 2 matches the signed word key -1 */
    set16(obj_ptr(), 0x2a, (uint16_t)-1);
    set16(obj_ptr(), 0x2a + 2, 9);
    world.word_5bb50b = 9;
    m42ea87_record_state(0, &world, &host, &rej);
    CK(get32(RECP(0), 0x41) == 0);
    set16(obj_ptr(), 0x2a, 2);
    set16(obj_ptr(), 0x2a + 0x12 + 2, 0xffff);
    set16(obj_ptr(), 0x2a + 0x12 + 8, 0x7777);
    world.word_5bb50b = -1;
    m42ea87_record_state(0, &world, &host, &rej);
    CK(get32(RECP(0), 0x41) == 1 && get16(RECP(0), 0x47) == 0x7777);
    /* state 2, word 0x22 (< 0x23): byte [+0x40] = 1, dword [+0x41] = 0, kind != 0x63 -> two table words; -1 is skipped; then 0x42ba3a(index) */
    setup();
    rec_init(3, 0x01, 2);
    set16(obj_ptr(), 8, 0x22);
    set16(obj_ptr(), 0, 5);
    set16(obj_ptr(), 2, 0x7fff);
    set16(obj_ptr(), 4, 0xffff);       /* a = -1: skipped */
    set16(obj_ptr(), 6, 0x1234);
    set16(obj_ptr(), 0x10, 0);         /* entry 4 would be read only for kind 0x63 */
    memcpy(before, RECP(3), REC);
    m42ea87_record_state((int16_t)3, &world, &host, &rej);
    CK(rej == 0 && RECP(3)[0x40] == 1 && get32(RECP(3), 0x41) == 0 && get32(RECP(3), 0x4d) == 2);
    CK(get32(world.flags_585801, 5 * 4) == 0x7fff && L.n == 1 && call_is(0, 0x42ba3a, 0, 1) && L.c[0].a[0] == 3);
    CK(memcmp(RECP(3), before, 0x40) == 0 && memcmp(RECP(3) + 0x45, before + 0x45, 8) == 0);
    /* kind 0x63 loops ten times (entries 2..9 too); a negative a indexes below the table; b is sign-extended */
    setup();
    rec_init(1, 0x63, 2);
    set16(obj_ptr(), 0x28, 0xffff);        /* -1 < 0x23 */
    for (i = 0; i < 10; i++) {
        set16(obj_ptr(), 4 * i, 0xffff);
        set16(obj_ptr(), 4 * i + 2, 0);
    }
    set16(obj_ptr(), 4 * 9, (uint16_t)-3);
    set16(obj_ptr(), 4 * 9 + 2, 0x8000);
    set16(obj_ptr(), 4 * 2, 17);
    set16(obj_ptr(), 4 * 2 + 2, 1);
    m42ea87_record_state(1, &world, &host, &rej);
    CK(get32(world.flags_585801, -3 * 4) == 0xffff8000u && get32(world.flags_585801, 17 * 4) == 1 && L.n == 1 && L.c[0].a[0] == 1);
    /* the word >= 0x23 (also the signed boundary: 0x7fff): state 1, no call, no table store, nothing else changed */
    setup();
    rec_init(4, 0x63, 2);
    set16(obj_ptr(), 0x28, 0x23);
    set16(obj_ptr(), 0, 1);
    set16(obj_ptr(), 2, 2);
    memcpy(before, RECP(4), REC);
    m42ea87_record_state(4, &world, &host, &rej);
    CK(get32(RECP(4), 0x4d) == 1 && L.n == 0 && get32(world.flags_585801, 4) == 0x77777777u && memcmp(RECP(4), before, 0x4d) == 0);
    /* any other state: nothing is written; native rejection when the object cannot be resolved */
    for (i = 0; i < 4; i++) {
        static const uint32_t others[] = {3, 0xffffffffu, 0x100, 0x10000};
        setup();
        rec_init(1, 0x63, others[i]);
        memcpy(before, RECP(1), REC);
        m42ea87_record_state(1, &world, &host, &rej);
        CK(rej == 0 && memcmp(RECP(1), before, REC) == 0 && L.n == 0 && world.value_5bb1ca == 0);
    }
    setup();
    rec_init(1, 0x63, 0);
    set32(RECP(1), 0, 0x30000000u);
    m42ea87_record_state(1, &world, &host, &rej);
    CK(rej == FL26B_REJECT_UNRESOLVED && get32(RECP(1), 0x4d) == 0 && L.n == 0);
}

/* ---- a bounded random sweep (meant for the sanitiser builds) ---------------------------------------------------------------- */

static uint32_t rng_state = 12345;
static uint32_t rnd(void)
{
    rng_state = rng_state * 1664525u + 1013904223u;
    return rng_state >> 8;
}

static void test_sweep(void)
{
    int round;
    for (round = 0; round < 3000; round++) {
        int32_t rej = 0;
        size_t q;
        setup();
        for (q = 0; q < 0x3000; q++) arena[q] = (uint8_t)rnd();
        for (q = 0; q < 0x400; q++) self_buf[0x3000 + q] = (uint8_t)rnd();
        switch (round % 5) {
        case 0:
            set32(arena, 0x1c, rnd() & 1 ? VA(0x100) : (rnd() & 1 ? 0u : rnd()));
            m423fbb_leaf_word(VA(0), &host, &rej);
            break;
        case 1: {
            int16_t item = (int16_t)(rnd() % 7) - 3;
            world.word_583a29 = item;
            set16(self_buf, (size_t)((ptrdiff_t)item * 0x16d + 0x77e), (uint16_t)(rnd() % 4));
            m4eb107_item_use_feedback(self_buf, rnd() & 1 ? item : (int32_t)rnd(), &world, &host);
            break;
        }
        case 2: {
            int k;
            for (k = 0; k < 6; k++) {
                node_init(k, rnd() & 1 ? rnd() : 0u, (int16_t)(rnd() % 3), k < 5 && rnd() % 5 ? k + 1 : -1, rnd() & 1 ? (int)(rnd() % 6) : -1);
            }
            arg_init(0, rnd() % 6, rnd() & 1);
            if (rnd() % 16 == 0) set32(arena, ND(2) + 0x38, VA(ND(rnd() % 6)));      /* a possible cycle: the step limit rejects it */
            m42406d_propagate(VA(0), &host, &rej);
            break;
        }
        case 3: {
            int k;
            for (k = 0; k < 6; k++) {
                A32(ND(k), 1 + rnd() % 3);       /* kind 3 is rejected */
                A32(ND(k) + 0x38, (rnd() % 3 || k == 5) ? 0u : VA(ND(k + 1)));
            }
            A32(4, VA(ND(rnd() % 6)));
            A32(0x2008, VA(ND(rnd() % 6)));
            g_ret_4235fd[0] = rnd() & 1 ? VA(0x2000) : 0;
            g_ret_4235fd[1] = g_ret_4235fd[2] = g_ret_4235fd[3] = 0;
            world.word_63a4cd = (int16_t)(rnd() % 3);
            m424201_walk(self_buf, VA(0), &world, &host, &rej);
            break;
        }
        default: {
            int i = (int)(rnd() % 6) - 1;      /* the records -1 .. 4 */
            uint8_t kind = rnd() & 1 ? 0x63 : 0x62;
            rec_init(i, kind, rnd() % 5);
            for (q = 0; q < 0x40; q += 2) set16(obj_ptr(), q, (uint16_t)(rnd() % 8 == 0 ? 0xffffu : rnd() % 6));
            world.word_5bb50b = (int16_t)(rnd() % 6);
            m42ea87_record_state((int16_t)i, &world, &host, &rej);
            break;
        }
        }
    }
}

/* ---- the table of cases ------------------------------------------------------------------------------------------------------- */

static const struct {
    const char *name;
    void (*fn)(void);
} CASES[] = {
    {"test_m423fbb_leaf_word", test_m423fbb_leaf_word},
    {"test_m4eb107_item_use_feedback", test_m4eb107_item_use_feedback},
    {"test_m42406d_propagate", test_m42406d_propagate},
    {"test_m424201_walk", test_m424201_walk},
    {"test_m42ea87_record_state", test_m42ea87_record_state},
    {"test_sweep_bounded", test_sweep},
};

int main(void)
{
    size_t i;
    int failures = 0;
    for (i = 0; i < sizeof CASES / sizeof CASES[0]; i++) {
        g_failed = 0;
        g_msg[0] = 0;
        CASES[i].fn();
        if (g_failed) {
            printf("FAIL %s: %s\n", CASES[i].name, g_msg);
            failures++;
        } else {
            printf("PASS %s\n", CASES[i].name);
        }
    }
    return failures;
}
