/* FL-11 direct test of action1b_step (src/action_family_1b_runtime.c), the native form of the raw 0x1b object method at
 * GAME.EXE 0x414947. The kernel is pulled in as a translation unit (shim pattern of tests/action_family_28_x87_division_fixture.c)
 * so that the test and the kernel are one compilation unit. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic records (no original bytes); expected values are derived by hand from the Ghidra
 * pseudocode of 0x414947 (primary records 22 bytes at object +2 counted by the word at +0; secondary records 18 bytes counted
 * by the word at +0x1c; fixed block words at +8/+0xa/+0xc/+0xe and dwords at +0x10/+0x14/+0x18), not by running the kernel. */
#include "../src/action_family_1b_runtime.c"

#include <stdio.h>

static int g_failed;
static char g_msg[256];
#define CK(cond)                                                               \
    do {                                                                       \
        if (!(cond) && !g_failed) {                                            \
            g_failed = 1;                                                      \
            snprintf(g_msg, sizeof g_msg, "line %d: %.200s", __LINE__, #cond); \
        }                                                                      \
    } while (0)

typedef struct {
    int effect;
    int32_t value;
} TFx;

typedef struct {
    ActionFamily1bDecoded d;
    uint8_t prim[22 * 4];
    uint8_t sec[18 * 4];
    Action17Slot slot;
    Action1bWorld world;
    Action17Result res;
    Action17Host host;
    TFx fx[32];
    unsigned fx_n;
} TF;

static void t_put16(uint8_t *b, size_t off, int v)
{
    b[off] = (uint8_t)v;
    b[off + 1] = (uint8_t)(v >> 8);
}
static void t_put32(uint8_t *b, size_t off, uint32_t v)
{
    for (int i = 0; i < 4; ++i) b[off + (size_t)i] = (uint8_t)(v >> (8 * i));
}

static void t_observe(void *context, int effect, int32_t value)
{
    TF *f = (TF *)context;
    if (f->fx_n < 32u) {
        f->fx[f->fx_n].effect = effect;
        f->fx[f->fx_n].value = value;
    }
    ++f->fx_n;
}

static void t_prim(TF *f, int i, int key, int target, int w4, int w6, int w8, uint32_t d10, uint32_t d14, uint32_t d18)
{
    uint8_t *r = f->prim + (size_t)i * 22u;
    t_put16(r, 0, key);
    t_put16(r, 2, target);
    t_put16(r, 4, w4);
    t_put16(r, 6, w6);
    t_put16(r, 8, w8);
    t_put32(r, 10, d10);
    t_put32(r, 14, d14);
    t_put32(r, 18, d18);
}

static void t_sec(TF *f, int i, int selector, uint32_t left, uint32_t top, uint32_t right, uint32_t bottom)
{
    uint8_t *r = f->sec + (size_t)i * 18u;
    t_put16(r, 0, selector);
    t_put32(r, 2, left);
    t_put32(r, 6, top);
    t_put32(r, 10, right);
    t_put32(r, 14, bottom);
}

/* Four primary records (keys 5, 9, 9 again, -1), four secondary records (selectors 7, 3, 7 again, -1), a fixed block whose first
 * word (+6, used only by the hover cursor) differs from the target word. */
static void t_setup(TF *f, int16_t selector, int16_t held)
{
    memset(f, 0, sizeof *f);
    t_prim(f, 0, 5, 4005, -2, 3, 4, 50u, (uint32_t)-51, 52u);
    t_prim(f, 1, 9, 4009, -12, 13, 14, 90u, (uint32_t)-91, 92u);
    t_prim(f, 2, 9, 7777, 1, 2, 3, 1u, 2u, 3u);
    t_prim(f, 3, 0xffff, 0x8000, 0xffff, 0x7fff, 0x8000, 0x80000000u, 0x7fffffffu, 0xffffffffu);
    t_sec(f, 0, 7, 0x00010111u, 0x00020222u, 0x00030333u, 0x00040444u);
    t_sec(f, 1, 3, 0x555u, 0x666u, 0x777u, 0x888u);
    t_sec(f, 2, 7, 0x999u, 0xaaau, 0xbbbu, 0xcccu);
    t_sec(f, 3, 0xffff, 0x00008001u, 0xffffu, 0u, 0x7fffu);
    f->d.runtime_type = 0x1b;
    f->d.primary_count = 4;
    f->d.secondary_count = 4;
    f->d.fixed_words[0] = 11;
    f->d.fixed_words[1] = 0xfff0u;
    f->d.fixed_words[2] = 7;
    f->d.fixed_words[3] = 0xfff8u;
    f->d.fixed_words[4] = 9;
    f->d.fixed_dwords[0] = 70000u;
    f->d.fixed_dwords[1] = (uint32_t)-71000;
    f->d.fixed_dwords[2] = 72u;
    f->d.primary_records = f->prim;
    f->d.secondary_records = f->sec;
    f->world.selector = selector;
    f->world.held_item = held;
    f->world.mode_583999 = 99;
    f->world.xfer_5bb57b = 1111;
    f->world.xfer_5bb599 = 11;
    f->world.xfer_5bb595 = 12;
    f->world.xfer_5c39ff = 13;
    f->world.xfer_5bb59b = 2222;
    f->world.xfer_5bb59f = 3333;
    f->world.xfer_5bb5a3 = 4444;
    f->slot.request = 1;
    f->slot.left = 0x1234;
    f->slot.top = 0x2345;
    f->slot.right = 0x3456;
    f->slot.bottom = 0x4567;
    f->slot.done = 0;
    f->host.context = f;
    f->host.observe = t_observe;
}

static int t_slot_rect(const Action17Slot *s, int l, int t, int r, int b)
{
    return s->left == l && s->top == t && s->right == r && s->bottom == b;
}

/* The seven transfer cells in the original's store order: 0x5bb57b, 0x5bb599, 0x5bb595, 0x5c39ff, 0x5bb59b, 0x5bb59f, 0x5bb5a3. */
static int t_xfer_is(const Action1bWorld *w, int32_t c57b, int32_t c599, int32_t c595, int32_t c39ff, int32_t c59b, int32_t c59f,
                     int32_t c5a3)
{
    return w->xfer_5bb57b == c57b && w->xfer_5bb599 == c599 && w->xfer_5bb595 == c595 && w->xfer_5c39ff == c39ff &&
           w->xfer_5bb59b == c59b && w->xfer_5bb59f == c59f && w->xfer_5bb5a3 == c5a3;
}

/* the world is untouched except for the listed groups */
static int t_world_untouched_xfer(const Action1bWorld *w)
{
    return t_xfer_is(w, 1111, 11, 12, 13, 2222, 3333, 4444);
}

/* the nine effects of phase 2 in the original's store order, ending with the mode store */
static int t_phase2_fx(const TF *f, const int32_t v[7])
{
    static const int order[7] = {ACTION17_FX_XFER_5BB57B, ACTION17_FX_XFER_5BB599, ACTION17_FX_XFER_5BB595,
                                 ACTION17_FX_XFER_5C39FF, ACTION17_FX_XFER_5BB59B, ACTION17_FX_XFER_5BB59F,
                                 ACTION17_FX_XFER_5BB5A3};
    if (f->fx_n != 9u || f->fx[0].effect != ACTION17_FX_DONE || f->fx[0].value != 1) return 0;
    for (unsigned k = 0; k < 7u; ++k)
        if (f->fx[1 + k].effect != order[k] || f->fx[1 + k].value != v[k]) return 0;
    return f->fx[8].effect == ACTION17_FX_MODE && f->fx[8].value == 4;
}

/* 0x414947: the raw 0x1b method. Phase dword 0: start flag 0x5bb1ca := 1, phase := 1, then phase 1. Phase 1: request := 0; the
 * FIRST secondary record whose selector word equals 0x5bb50b sets request := 1 and the rectangle words from the low words of its
 * four dwords. Phase 2: completion byte := 1; the FIRST primary record whose key word equals the held-item word 0x583a29 (else
 * the fixed block) supplies the seven transfer cells (target sign-extended); engine mode 0x583999 := 4. Other phases: nothing. */
static void test_action1b_step(void)
{
    TF f;
    int rc;

    /* phase 0, selector 7: start flag, phase := 1, then the FIRST selector-7 record (index 0, not index 2) */
    t_setup(&f, 7, 9);
    f.slot.request = 0; /* the phase-1 part clears it, then sets it again */
    rc = action1b_step(&f.d, 0u, &f.slot, &f.world, &f.host, &f.res);
    CK(rc == ACTION17_OK);
    CK(f.world.start_flag_5bb1ca == 1 && f.res.phase_after == 1u && f.res.matched_record == 0);
    CK(f.res.finished == 0u && f.res.requested == 1u);
    CK(f.slot.request == 1 && t_slot_rect(&f.slot, 0x0111, 0x0222, 0x0333, 0x0444) && f.slot.done == 0u);
    CK(f.fx_n == 8u);
    CK(f.fx[0].effect == ACTION17_FX_START_FLAG && f.fx[0].value == 1);
    CK(f.fx[1].effect == ACTION17_FX_PHASE && f.fx[1].value == 1);
    CK(f.fx[2].effect == ACTION17_FX_REQUEST && f.fx[2].value == 0);
    CK(f.fx[3].effect == ACTION17_FX_REQUEST && f.fx[3].value == 1);
    CK(f.fx[4].effect == ACTION17_FX_LEFT && f.fx[4].value == 0x0111);
    CK(f.fx[5].effect == ACTION17_FX_TOP && f.fx[5].value == 0x0222);
    CK(f.fx[6].effect == ACTION17_FX_RIGHT && f.fx[6].value == 0x0333);
    CK(f.fx[7].effect == ACTION17_FX_BOTTOM && f.fx[7].value == 0x0444);
    /* nothing of phase 2 happened */
    CK(f.world.mode_583999 == 99 && t_world_untouched_xfer(&f.world) && f.world.selector == 7 && f.world.held_item == 9);

    /* phase 0, selector with no record: start flag and phase 1 still happen; the stale request is cleared, the rectangle kept */
    t_setup(&f, 99, 9);
    rc = action1b_step(&f.d, 0u, &f.slot, &f.world, &f.host, &f.res);
    CK(rc == ACTION17_OK && f.world.start_flag_5bb1ca == 1 && f.res.phase_after == 1u && f.res.matched_record == -1);
    CK(f.slot.request == 0 && t_slot_rect(&f.slot, 0x1234, 0x2345, 0x3456, 0x4567) && f.res.requested == 0u);
    CK(f.fx_n == 3u && f.fx[0].effect == ACTION17_FX_START_FLAG && f.fx[1].effect == ACTION17_FX_PHASE &&
       f.fx[2].effect == ACTION17_FX_REQUEST && f.fx[2].value == 0);

    /* phase 1: no start flag, no phase store; selector 3 picks record 1 */
    t_setup(&f, 3, 9);
    rc = action1b_step(&f.d, 1u, &f.slot, &f.world, &f.host, &f.res);
    CK(rc == ACTION17_OK && f.world.start_flag_5bb1ca == 0 && f.res.phase_after == 1u && f.res.matched_record == 1);
    CK(f.slot.request == 1 && t_slot_rect(&f.slot, 0x555, 0x666, 0x777, 0x888) && f.res.requested == 1u && f.res.finished == 0u);
    CK(f.fx_n == 6u && f.fx[0].effect == ACTION17_FX_REQUEST && f.fx[0].value == 0 && f.fx[1].effect == ACTION17_FX_REQUEST &&
       f.fx[1].value == 1 && f.fx[2].effect == ACTION17_FX_LEFT && f.fx[5].effect == ACTION17_FX_BOTTOM);
    CK(f.world.mode_583999 == 99 && t_world_untouched_xfer(&f.world));

    /* phase 1, selector 7 appears twice: the first record wins; the stores are the LOW words of the dwords */
    t_setup(&f, 7, 9);
    rc = action1b_step(&f.d, 1u, &f.slot, &f.world, &f.host, &f.res);
    CK(rc == ACTION17_OK && f.res.matched_record == 0 && t_slot_rect(&f.slot, 0x0111, 0x0222, 0x0333, 0x0444));

    /* phase 1, selector -1 (record 3, word 0xffff): the selector compares sign-extended; words are sign-extended low halves */
    t_setup(&f, -1, 9);
    rc = action1b_step(&f.d, 1u, &f.slot, &f.world, &f.host, &f.res);
    CK(rc == ACTION17_OK && f.res.matched_record == 3 && f.slot.request == 1 && t_slot_rect(&f.slot, -32767, -1, 0, 0x7fff));

    /* phase 1, miss: request cleared (it was 1), rectangle and everything else unchanged */
    t_setup(&f, 5, 9);
    rc = action1b_step(&f.d, 1u, &f.slot, &f.world, &f.host, &f.res);
    CK(rc == ACTION17_OK && f.res.matched_record == -1 && f.slot.request == 0 && f.res.requested == 0u);
    CK(t_slot_rect(&f.slot, 0x1234, 0x2345, 0x3456, 0x4567));
    CK(f.fx_n == 1u && f.fx[0].effect == ACTION17_FX_REQUEST && f.fx[0].value == 0);

    /* phase 1: the scan stops at the secondary count; a record past it never matches; count 0 never matches */
    t_setup(&f, 3, 9);
    f.d.secondary_count = 1;
    rc = action1b_step(&f.d, 1u, &f.slot, &f.world, &f.host, &f.res);
    CK(rc == ACTION17_OK && f.res.matched_record == -1 && f.slot.request == 0);
    t_setup(&f, 3, 9);
    f.d.secondary_count = 2;
    rc = action1b_step(&f.d, 1u, &f.slot, &f.world, &f.host, &f.res);
    CK(rc == ACTION17_OK && f.res.matched_record == 1 && f.slot.request == 1);
    t_setup(&f, 7, 9);
    f.d.secondary_count = 0;
    rc = action1b_step(&f.d, 1u, &f.slot, &f.world, &f.host, &f.res);
    CK(rc == ACTION17_OK && f.res.matched_record == -1 && f.slot.request == 0);

    /* phase 2, held item 9: completion byte, then the FIRST key-9 record (index 1, not 2), then mode 4; the request, the
     * rectangle, the selector and the start flag are not touched */
    t_setup(&f, 7, 9);
    rc = action1b_step(&f.d, 2u, &f.slot, &f.world, &f.host, &f.res);
    CK(rc == ACTION17_OK && f.slot.done == 1u && f.res.finished == 1u && f.res.phase_after == 2u && f.res.matched_record == 1);
    CK(t_xfer_is(&f.world, 4009, -12, 13, 14, 90, -91, 92) && f.world.mode_583999 == 4);
    CK(f.slot.request == 1 && f.res.requested == 1u && t_slot_rect(&f.slot, 0x1234, 0x2345, 0x3456, 0x4567));
    CK(f.world.start_flag_5bb1ca == 0 && f.world.selector == 7 && f.world.held_item == 9);
    {
        const int32_t v[7] = {4009, -12, 13, 14, 90, -91, 92};
        CK(t_phase2_fx(&f, v));
    }

    /* phase 2 leaves a zero request zero (the secondary scan is not part of phase 2) */
    t_setup(&f, 7, 5);
    f.slot.request = 0;
    rc = action1b_step(&f.d, 2u, &f.slot, &f.world, &f.host, &f.res);
    CK(rc == ACTION17_OK && f.slot.request == 0 && f.res.requested == 0u && f.res.matched_record == 0);
    CK(t_xfer_is(&f.world, 4005, -2, 3, 4, 50, -51, 52));

    /* phase 2, held item -1 (record 3, key word 0xffff): every cell sign-extended / extreme */
    t_setup(&f, 7, -1);
    rc = action1b_step(&f.d, 2u, &f.slot, &f.world, &f.host, &f.res);
    CK(rc == ACTION17_OK && f.res.matched_record == 3);
    CK(t_xfer_is(&f.world, -32768, -1, 0x7fff, -32768, INT32_MIN, INT32_MAX, -1) && f.world.mode_583999 == 4);

    /* phase 2, no record for the held item: the fixed block (words +8..+0xe, dwords +0x10..+0x18); the first fixed word
     * (+6, value 11) is not a transfer cell; the target is sign-extended */
    t_setup(&f, 7, 1234);
    rc = action1b_step(&f.d, 2u, &f.slot, &f.world, &f.host, &f.res);
    CK(rc == ACTION17_OK && f.res.matched_record == -1 && f.slot.done == 1u && f.res.finished == 1u);
    CK(t_xfer_is(&f.world, -16, 7, -8, 9, 70000, -71000, 72) && f.world.mode_583999 == 4);
    {
        const int32_t v[7] = {-16, 7, -8, 9, 70000, -71000, 72};
        CK(t_phase2_fx(&f, v));
    }

    /* phase 2, the scan stops at the primary count: key 9 sits at index 1 */
    t_setup(&f, 7, 9);
    f.d.primary_count = 1;
    rc = action1b_step(&f.d, 2u, &f.slot, &f.world, &f.host, &f.res);
    CK(rc == ACTION17_OK && f.res.matched_record == -1 && t_xfer_is(&f.world, -16, 7, -8, 9, 70000, -71000, 72));
    t_setup(&f, 7, 9);
    f.d.primary_count = 2;
    rc = action1b_step(&f.d, 2u, &f.slot, &f.world, &f.host, &f.res);
    CK(rc == ACTION17_OK && f.res.matched_record == 1 && t_xfer_is(&f.world, 4009, -12, 13, 14, 90, -91, 92));
    t_setup(&f, 7, 5);
    f.d.primary_count = 0;
    rc = action1b_step(&f.d, 2u, &f.slot, &f.world, &f.host, &f.res);
    CK(rc == ACTION17_OK && f.res.matched_record == -1 && t_xfer_is(&f.world, -16, 7, -8, 9, 70000, -71000, 72) &&
       f.world.mode_583999 == 4 && f.slot.done == 1u);

    /* any other phase dword does nothing, including values that only share low bits with 0, 1 or 2 */
    {
        static const uint32_t others[] = {3u, 0x10000u, 0x10001u, 0x10002u, 0xffffffffu};
        for (size_t k = 0; k < sizeof others / sizeof others[0]; ++k) {
            t_setup(&f, 7, 9);
            rc = action1b_step(&f.d, others[k], &f.slot, &f.world, &f.host, &f.res);
            CK(rc == ACTION17_OK && f.fx_n == 0u && f.res.phase_after == others[k] && f.res.matched_record == -1);
            CK(f.res.finished == 0u && f.slot.request == 1 && f.slot.done == 0u && t_slot_rect(&f.slot, 0x1234, 0x2345, 0x3456, 0x4567));
            CK(f.world.start_flag_5bb1ca == 0 && f.world.mode_583999 == 99 && t_world_untouched_xfer(&f.world));
        }
    }

    /* the observer is optional: no host, or a host without observe, gives the same cell results and no crash */
    t_setup(&f, 7, 9);
    rc = action1b_step(&f.d, 2u, &f.slot, &f.world, NULL, &f.res);
    CK(rc == ACTION17_OK && t_xfer_is(&f.world, 4009, -12, 13, 14, 90, -91, 92) && f.world.mode_583999 == 4 && f.fx_n == 0u);
    t_setup(&f, 7, 9);
    f.host.observe = NULL;
    rc = action1b_step(&f.d, 0u, &f.slot, &f.world, &f.host, &f.res);
    CK(rc == ACTION17_OK && f.world.start_flag_5bb1ca == 1 && f.slot.request == 1 && f.fx_n == 0u);

    /* null arguments are refused and nothing changes (native contract) */
    t_setup(&f, 7, 9);
    CK(action1b_step(NULL, 2u, &f.slot, &f.world, &f.host, &f.res) == ACTION17_ERR_ARGUMENT);
    CK(action1b_step(&f.d, 2u, NULL, &f.world, &f.host, &f.res) == ACTION17_ERR_ARGUMENT);
    CK(action1b_step(&f.d, 2u, &f.slot, NULL, &f.host, &f.res) == ACTION17_ERR_ARGUMENT);
    CK(action1b_step(&f.d, 2u, &f.slot, &f.world, &f.host, NULL) == ACTION17_ERR_ARGUMENT);
    CK(f.fx_n == 0u && f.slot.done == 0u && f.world.mode_583999 == 99 && t_world_untouched_xfer(&f.world));
}

int main(void)
{
    static const struct {
        const char *name;
        void (*fn)(void);
    } cases[] = {
        {"test_action1b_step", test_action1b_step},
    };
    int failures = 0;
    for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        g_failed = 0;
        g_msg[0] = '\0';
        cases[i].fn();
        if (g_failed) {
            ++failures;
            printf("FAIL %s: %s\n", cases[i].name, g_msg);
        } else {
            printf("PASS %s\n", cases[i].name);
        }
    }
    return failures;
}
