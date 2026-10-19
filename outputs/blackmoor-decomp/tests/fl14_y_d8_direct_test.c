/* FL-14 direct tests of the raw 0xd8 Peephole puzzle kernel (src/action_family_d8_runtime.c): d8_mark_dirty (original
 * 0x48bc38) and d8_press (original 0x48c148). Expected values from the original pseudocode:
 *   0x48bc38: if byte this+0x46 != 0 and word this+0x2e != -1: entry[slot_a].+0x14 := 1; then if byte this+0x46 != 0 and word
 *     this+0x30 != -1: entry[slot_b].+0x14 := 1 (native: host mark_dirty(slot), slot_a first).
 *   0x48c148: when byte this+0x46 != 0, dword [0x5bb632 + row * 0x8d] == 1, [0x5c39e5] == 0x27a7 and byte this+0x34 + hot
 *     != 0: if byte this+0x40 == 0 then dword this+0x50 := GetTickCount(); byte this+0x1c := byte hot; byte this+0x40 := 1. */
#include "../src/action_family_d8_runtime.c"

#include "fl14_y_common.h"

static void test_d8_mark_dirty_48bc38(void)
{
    static const struct {
        uint8_t active;
        int16_t a, b;
        int calls;
        int16_t first, second;
    } c[] = {
        {0, 3, 4, 0, 0, 0},       /* inactive: neither store */
        {0, -1, -1, 0, 0, 0},
        {1, -1, -1, 0, 0, 0},     /* no slots */
        {1, 3, -1, 1, 3, 0},      /* only slot_a */
        {1, -1, 4, 1, 4, 0},      /* only slot_b */
        {1, 3, 4, 2, 3, 4},       /* both, slot_a first */
        {1, 0, 0, 2, 0, 0},       /* slot 0 is real */
        {0xff, 6, 7, 2, 6, 7},    /* any nonzero byte */
        {0x80, 9, -1, 1, 9, 0},
        {1, -2, -3, 2, -2, -3},   /* only -1 means none */
    };
    for (size_t i = 0; i < sizeof c / sizeof c[0]; ++i) {
        D8Object o;
        D8Host host;
        Rec rec;
        memset(&o, 0, sizeof o);
        memset(&host, 0, sizeof host);
        memset(&rec, 0, sizeof rec);
        host.context = &rec;
        host.mark_dirty = rec_mark_dirty;
        o.active = c[i].active;
        o.slot_a = c[i].a;
        o.slot_b = c[i].b;
        CK(d8_mark_dirty(&o, &host) == D8_OK);
        CK(rec.calls == c[i].calls);
        if (c[i].calls >= 1) CK(rec.slot[0] == c[i].first);
        if (c[i].calls >= 2) CK(rec.slot[1] == c[i].second);
        CK(o.active == c[i].active && o.slot_a == c[i].a && o.slot_b == c[i].b);
    }
}

typedef struct {
    uint32_t ticks;
    uint32_t value;
} TickRec;
static uint32_t press_tick(void *context)
{
    TickRec *t = (TickRec *)context;
    t->ticks++;
    return t->value;
}

static D8Object press_object(void)
{
    D8Object o;
    memset(&o, 0, sizeof o);
    o.active = 1;
    o.hot = 2;
    o.can_move[0] = 0;
    o.can_move[1] = 0;
    o.can_move[2] = 1;
    o.can_move[3] = 0;
    o.pressed = 0;
    o.dir = 0xff;
    o.tick = 0x1234;
    return o;
}

static void test_d8_press_48c148(void)
{
    TickRec t = {0, 0xCAFE};
    D8Host host;
    D8Object o;
    memset(&host, 0, sizeof host);
    host.context = &t;
    host.tick = press_tick;

    /* all four conditions true, not pressed yet: tick stored, dir := hot, pressed := 1 */
    o = press_object();
    CK(d8_press(&o, 1u, 0x27a7, &host) == D8_OK);
    CK(t.ticks == 1 && o.tick == 0xCAFEu && o.dir == 2 && o.pressed == 1);

    /* already pressed: the tick is not read and +0x50 keeps its value, dir follows hot */
    t.ticks = 0;
    o = press_object();
    o.pressed = 1;
    o.dir = 3;
    CK(d8_press(&o, 1u, 0x27a7, &host) == D8_OK);
    CK(t.ticks == 0 && o.tick == 0x1234u && o.dir == 2 && o.pressed == 1);

    /* each hot with its own can_move byte */
    for (int16_t hot = 0; hot < 4; ++hot) {
        t.ticks = 0;
        o = press_object();
        memset(o.can_move, 0, sizeof o.can_move);
        o.can_move[hot] = 7; /* any nonzero byte */
        o.hot = hot;
        CK(d8_press(&o, 1u, 0x27a7, &host) == D8_OK);
        CK(t.ticks == 1 && o.dir == (uint8_t)hot && o.pressed == 1 && o.tick == 0xCAFEu);
        /* the other three entries do not enable it */
        for (int16_t other = 0; other < 4; ++other) {
            if (other == hot) continue;
            t.ticks = 0;
            o = press_object();
            memset(o.can_move, 0, sizeof o.can_move);
            o.can_move[other] = 1;
            o.hot = hot;
            CK(d8_press(&o, 1u, 0x27a7, &host) == D8_OK);
            CK(t.ticks == 0 && o.dir == 0xff && o.pressed == 0 && o.tick == 0x1234u);
        }
    }

    /* each condition false on its own: nothing changes and the tick is not read */
    {
        struct {
            uint8_t active;
            uint32_t row_phase;
            int32_t candidate;
            uint8_t can_move;
        } f[] = {
            {0, 1u, 0x27a7, 1},     /* inactive */
            {1, 0u, 0x27a7, 1},     /* row phase 0 */
            {1, 2u, 0x27a7, 1},     /* row phase 2 */
            {1, 0x101u, 0x27a7, 1}, /* the dword must equal 1 (low byte is 1) */
            {1, 1u, 0x27a8, 1},     /* link candidate */
            {1, 1u, 0x27a9, 1},     /* exit candidate */
            {1, 1u, 0, 1},          /* no candidate */
            {1, 1u, 0x27a7, 0},     /* can_move[hot] == 0 */
        };
        for (size_t i = 0; i < sizeof f / sizeof f[0]; ++i) {
            t.ticks = 0;
            o = press_object();
            o.active = f[i].active;
            o.can_move[2] = f[i].can_move;
            CK(d8_press(&o, f[i].row_phase, f[i].candidate, &host) == D8_OK);
            CK(t.ticks == 0 && o.dir == 0xff && o.pressed == 0 && o.tick == 0x1234u);
        }
    }
}

int main(void)
{
    RUN_TEST(test_d8_mark_dirty_48bc38);
    RUN_TEST(test_d8_press_48c148);
    return g_fail_count;
}
