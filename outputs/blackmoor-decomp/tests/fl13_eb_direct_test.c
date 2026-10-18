/* FL-13 direct tests of the static helpers of the raw 0xeb Multibuild puzzle kernel (src/action_family_eb_runtime.c):
 *   top_piece_47e8fe (original 0x47e8fe), top_piece_47e9d3 (its twin 0x47e9d3), sound_pick_4809a7 (0x4809a7),
 *   sound_rotate_480abe (0x480abe) and sound_good (0x480a1d, which calls 0x480b34 save_and_check).
 * The kernel is pulled in as a translation unit (same pattern as tests/fl11_eb_direct_test.c). Prints "PASS <name>" /
 * "FAIL <name>: <msg>"; the exit status is the failure count. Fixtures are synthetic. Expected values are derived by hand from the
 * original pseudocode (this = object, body = *(0x5bb5e5 + slot * 0x8d)), not by running the kernel; every offset below is the
 * original's displacement written as a literal:
 *   0x47e8fe: count word this+0x1441, list this+0x1419 (words), piece z word this+0x7b4+idx*0x25; -1 when empty; the first
 *             piece of the maximum z (strict less-than replaces).  0x47e9d3: same over count this+0x1417, list this+0x13ef.
 *   0x4809a7: record body+0x746 vs "NO SOUND\0" (9 bytes); different -> play(word body+0x767), this+0x13e7 := tick + 300,
 *             this+0x13ca := 1.   0x480abe: record body+0x715, word body+0x736, delay 0x15e, otherwise the same.
 *   0x480a1d: record body+0x777; equal -> this+0x13e7 := tick; different -> play(word body+0x798), this+0x13e7 := tick + 300;
 *             then 0x480b34; then this+0x13ca := 4; this+0x13eb := tick + 100. */
#include "../src/action_family_eb_runtime.c"

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
    EbObject o;
    uint8_t body[EB_BODY_BYTES];
    EbWorld w;
    EbHost host;
    uint32_t ticks[4];
    int nticks, iticks;
    char log[256];
} TF;

static void t_put16(uint8_t *b, size_t off, int v)
{
    b[off] = (uint8_t)v;
    b[off + 1] = (uint8_t)((unsigned)v >> 8);
}
static int t_get16(const uint8_t *b, size_t off)
{
    return (int16_t)(uint16_t)(b[off] | (b[off + 1] << 8));
}
static uint32_t t_get32(const uint8_t *b, size_t off)
{
    return (uint32_t)b[off] | ((uint32_t)b[off + 1] << 8) | ((uint32_t)b[off + 2] << 16) | ((uint32_t)b[off + 3] << 24);
}
static void t_log(TF *f, const char *fmt, int a, int b)
{
    char tmp[48];
    size_t used = strlen(f->log);
    snprintf(tmp, sizeof tmp, fmt, a, b);
    snprintf(f->log + used, sizeof f->log - used, "%s%s", used == 0 ? "" : ",", tmp);
}
static int m_play(void *c, int16_t channel)
{
    t_log((TF *)c, "play:%d%.0d", channel, 0);
    return 0;
}
static uint32_t m_tick(void *c)
{
    TF *f = (TF *)c;
    t_log(f, "tick%.0d%.0d", 0, 0);
    return f->iticks < f->nticks ? f->ticks[f->iticks++] : 0xdeadu;
}
static int m_flag_invalid(void *c, int16_t index)
{
    (void)c;
    (void)index;
    return 0;
}
static int m_store_flag(void *c, int16_t index, uint32_t value)
{
    t_log((TF *)c, "flag:%d=%d", index, (int)value);
    return 0;
}

static void tf_init(TF *f)
{
    memset(f, 0, sizeof *f);
    memset(f->o.b, 0x5a, sizeof f->o.b);
    f->host.context = f;
    f->host.sound_play = m_play;
    f->host.tick = m_tick;
    f->host.event_flag_invalid = m_flag_invalid;
    f->host.store_event_flag = m_store_flag;
}
static void t_name(uint8_t *body, size_t off, const char *s)
{
    memset(body + off, 0, 0x21);
    memcpy(body + off, s, strlen(s));
}
#define QPIECE_Z(i) ((size_t)0x7b4 + (size_t)(i) * 0x25u)

/* Shared check of a "top piece" original: list at `list`, count word at `count`; a decoy list is filled with other indices. */
static void check_top(int16_t (*fn)(const uint8_t *), size_t list, size_t count, size_t dlist, size_t dcount)
{
    TF f;
    int i;
    /* empty list: -1 whatever the list words hold */
    tf_init(&f);
    t_put16(f.o.b, dcount, 0);
    t_put16(f.o.b, count, 0);
    t_put16(f.o.b, list, 7);
    CK(fn(f.o.b) == -1);
    /* one entry: that entry, its z is irrelevant */
    tf_init(&f);
    t_put16(f.o.b, dcount, 0);
    t_put16(f.o.b, count, 1);
    t_put16(f.o.b, list, 12);
    t_put16(f.o.b, QPIECE_Z(12), -9);
    CK(fn(f.o.b) == 12);
    /* greatest z wins wherever it sits; list entries are piece indices, not positions; z compares as signed words */
    tf_init(&f);
    t_put16(f.o.b, dcount, 0);
    t_put16(f.o.b, count, 4);
    {
        const int idx[4] = {3, 30, 5, 79};
        const int z[4] = {-5, 7, 6, -20};
        for (i = 0; i < 4; ++i) {
            t_put16(f.o.b, list + (size_t)i * 2u, idx[i]);
            t_put16(f.o.b, QPIECE_Z(idx[i]), z[i]);
        }
    }
    CK(fn(f.o.b) == 30);
    /* the maximum is the last entry; an entry beyond the count is ignored */
    t_put16(f.o.b, QPIECE_Z(79), 8);
    CK(fn(f.o.b) == 79);
    t_put16(f.o.b, count, 3);
    CK(fn(f.o.b) == 30);
    /* a tie keeps the first piece (strict less-than) */
    tf_init(&f);
    t_put16(f.o.b, dcount, 0);
    t_put16(f.o.b, count, 3);
    for (i = 0; i < 3; ++i) t_put16(f.o.b, list + (size_t)i * 2u, 10 + i);
    t_put16(f.o.b, QPIECE_Z(10), 4);
    t_put16(f.o.b, QPIECE_Z(11), 4);
    t_put16(f.o.b, QPIECE_Z(12), 3);
    CK(fn(f.o.b) == 10);
    t_put16(f.o.b, QPIECE_Z(11), 5);
    t_put16(f.o.b, QPIECE_Z(12), 5);
    CK(fn(f.o.b) == 11);
    /* z bytes above 0x7f of the low byte: 0x0100 > 0x00ff, -1 < 0 */
    t_put16(f.o.b, QPIECE_Z(10), 0x00ff);
    t_put16(f.o.b, QPIECE_Z(11), 0x0100);
    t_put16(f.o.b, QPIECE_Z(12), -1);
    CK(fn(f.o.b) == 11);
    /* the other twin's list and count are not read: a decoy list with a clear winner elsewhere */
    tf_init(&f);
    t_put16(f.o.b, count, 2);
    t_put16(f.o.b, list, 20);
    t_put16(f.o.b, list + 2, 21);
    t_put16(f.o.b, QPIECE_Z(20), 1);
    t_put16(f.o.b, QPIECE_Z(21), 2);
    t_put16(f.o.b, QPIECE_Z(40), 99);
    t_put16(f.o.b, dcount, 3);
    t_put16(f.o.b, dlist, 40);
    t_put16(f.o.b, dlist + 2, 40);
    t_put16(f.o.b, dlist + 4, 40);
    CK(fn(f.o.b) == 21);
    /* nothing is written */
    {
        uint8_t before[EB_OBJECT_BYTES];
        memcpy(before, f.o.b, sizeof before);
        (void)fn(f.o.b);
        CK(memcmp(before, f.o.b, sizeof before) == 0);
    }
}
static void test_top_piece_47e8fe(void)
{
    check_top(top_piece_47e8fe, 0x1419, 0x1441, 0x13ef, 0x1417);
}
static void test_top_piece_47e9d3(void)
{
    check_top(top_piece_47e9d3, 0x13ef, 0x1417, 0x1419, 0x1441);
}

/* The 0x4809a7 / 0x480abe family: record, channel word, delay. `other` are the records of the two other sounds (decoys). */
static void check_blip(int (*fn)(uint8_t *, const uint8_t *, const EbHost *), size_t rec, size_t chan, uint32_t delay)
{
    TF f;
    uint8_t before[EB_OBJECT_BYTES];
    const size_t decoys[3] = {0x715u == rec ? 0x746u : 0x715u, 0x777u, 0x7a8u};
    int rc, i;

    /* "NO SOUND": nothing happens (no host call, no store) */
    tf_init(&f);
    t_name(f.body, rec, "NO SOUND");
    for (i = 0; i < 3; ++i) t_name(f.body, decoys[i], "REAL");
    t_put16(f.body, chan, 4);
    f.ticks[0] = 100;
    f.nticks = 1;
    memcpy(before, f.o.b, sizeof before);
    rc = fn(f.o.b, f.body, &f.host);
    CK(rc == EB_OK && f.log[0] == '\0' && memcmp(before, f.o.b, sizeof before) == 0);

    /* a real name: play(channel), then tick; deadline := tick + delay; state := 1; nothing else changes */
    tf_init(&f);
    t_name(f.body, rec, "CLICK");
    for (i = 0; i < 3; ++i) t_name(f.body, decoys[i], "NO SOUND");
    t_put16(f.body, chan, 0x1234);
    f.ticks[0] = 1000;
    f.nticks = 1;
    memcpy(before, f.o.b, sizeof before);
    rc = fn(f.o.b, f.body, &f.host);
    CK(rc == EB_OK);
    CK(strcmp(f.log, "play:4660,tick") == 0);
    CK(t_get32(f.o.b, 0x13e7) == 1000u + delay);
    CK(t_get32(f.o.b, 0x13ca) == 1);
    for (i = 0; i < (int)sizeof before; ++i) { /* only state (0x13ca..0x13cd) and deadline (0x13e7..0x13ea) change */
        if ((i >= 0x13ca && i < 0x13ce) || (i >= 0x13e7 && i < 0x13eb)) continue;
        CK(f.o.b[i] == before[i]);
    }

    /* negative channel word; deadline wraps in 32 bits */
    tf_init(&f);
    t_name(f.body, rec, "CLICK");
    t_put16(f.body, chan, -3);
    f.ticks[0] = 0xfffffff0u;
    f.nticks = 1;
    rc = fn(f.o.b, f.body, &f.host);
    CK(rc == EB_OK && strcmp(f.log, "play:-3,tick") == 0);
    CK(t_get32(f.o.b, 0x13e7) == (uint32_t)(0xfffffff0u + delay));

    /* the comparison covers 9 bytes including the terminator: "NO SOUNDS" and "NO SOUNE" are real names, a name that
     * is "NO SOUND" followed by bytes after the NUL is still "NO SOUND" */
    tf_init(&f);
    t_name(f.body, rec, "NO SOUNDS");
    f.ticks[0] = 5;
    f.nticks = 1;
    CK(fn(f.o.b, f.body, &f.host) == EB_OK && f.log[0] != '\0' && t_get32(f.o.b, 0x13ca) == 1);
    tf_init(&f);
    t_name(f.body, rec, "NO SOUNE");
    CK(fn(f.o.b, f.body, &f.host) == EB_OK && f.log[0] != '\0');
    tf_init(&f);
    t_name(f.body, rec, "no sound");
    CK(fn(f.o.b, f.body, &f.host) == EB_OK && f.log[0] != '\0');
    tf_init(&f);
    t_name(f.body, rec, "NO SOUND");
    f.body[rec + 12] = 'X';
    CK(fn(f.o.b, f.body, &f.host) == EB_OK && f.log[0] == '\0');
}
static void test_sound_pick_4809a7(void)
{
    check_blip(sound_pick_4809a7, 0x746, 0x767, 300);
}
static void test_sound_rotate_480abe(void)
{
    check_blip(sound_rotate_480abe, 0x715, 0x736, 0x15e);
}

static void put_ids(TF *f)
{
    t_name(f->body, 0x777, "GOOD");
    t_put16(f->body, 0x798, 0x0102);
}

/* 0x480a1d: sound, then 0x480b34, then state := 4 and the second deadline. Cases cover both name branches and both outcomes of
 * 0x480b34 (target not reached / reached with the win sound), the latter showing that the state := 4 store comes after it. */
static void test_sound_good_480a1d(void)
{
    TF f;
    int rc;

    /* a real name, target not reached: count 3, ntypes 0, target 5 */
    tf_init(&f);
    put_ids(&f);
    t_put16(f.o.b, 0x13a2, 3);
    t_put16(f.body, 0x43, 0);
    t_put16(f.body, 0x45, 5);
    t_put16(f.body, 0xa11, 7);
    f.body[0xa13] = 0;
    t_put16(f.body, 0x8de, -1);
    f.ticks[0] = 1000;
    f.ticks[1] = 2000;
    f.nticks = 2;
    rc = sound_good(f.o.b, f.body, &f.w, 1, &f.host);
    CK(rc == EB_OK);
    CK(strcmp(f.log, "play:258,tick,flag:7=1,tick") == 0);
    CK(t_get32(f.o.b, 0x13e7) == 1300u);
    CK(t_get32(f.o.b, 0x13ca) == 4);
    CK(t_get32(f.o.b, 0x13eb) == 2100u);
    CK(t_get16(f.o.b, 0x1443) == 3); /* 0x480b34: total = count - ntypes */
    CK(f.w.saved_flag == 1 && f.w.saved_total == 3 && f.w.saved_count == 3);
    CK(f.o.b[0x13ce] == 0x5a); /* done flag untouched */

    /* "NO SOUND": no play, first deadline = tick (no delay) */
    tf_init(&f);
    put_ids(&f);
    t_name(f.body, 0x777, "NO SOUND");
    t_put16(f.o.b, 0x13a2, 3);
    t_put16(f.body, 0x45, 5);
    t_put16(f.body, 0xa11, -1);
    t_put16(f.body, 0x8de, -1);
    f.ticks[0] = 1000;
    f.ticks[1] = 2000;
    f.nticks = 2;
    rc = sound_good(f.o.b, f.body, &f.w, 1, &f.host);
    CK(rc == EB_OK);
    CK(strcmp(f.log, "tick,tick") == 0);
    CK(t_get32(f.o.b, 0x13e7) == 1000u);
    CK(t_get32(f.o.b, 0x13ca) == 4);
    CK(t_get32(f.o.b, 0x13eb) == 2100u);
    CK(f.w.saved_flag == 1);

    /* target reached with a win sound: 0x480b34 sets state 6 and done, then state := 4 overrides the state, done stays */
    tf_init(&f);
    put_ids(&f);
    t_put16(f.o.b, 0x13a2, 5);
    t_put16(f.body, 0x43, 0);
    t_put16(f.body, 0x45, 5);
    f.body[0x47] = 1;
    t_put16(f.body, 0xa11, 7);
    f.body[0xa13] = 1;
    t_put16(f.body, 0x8de, 9);
    f.body[0x8e0] = 0;
    f.ticks[0] = 10;
    f.ticks[1] = 20;
    f.nticks = 2;
    rc = sound_good(f.o.b, f.body, &f.w, 1, &f.host);
    CK(rc == EB_OK);
    CK(strcmp(f.log, "play:258,tick,flag:7=1,flag:9=1,flag:9=0,tick") == 0);
    CK(t_get32(f.o.b, 0x13ca) == 4 && f.o.b[0x13ce] == 1);
    CK(t_get32(f.o.b, 0x13e7) == 310u && t_get32(f.o.b, 0x13eb) == 120u);
    CK(f.w.saved_total == 5 && t_get16(f.o.b, 0x1443) == 5);

    /* no win sound, row phase 2: done := 1 by 0x480b34 */
    tf_init(&f);
    put_ids(&f);
    t_put16(f.o.b, 0x13a2, 5);
    t_put16(f.body, 0x45, 5);
    f.body[0x47] = 0;
    t_put16(f.body, 0xa11, -1);
    t_put16(f.body, 0x8de, -1);
    f.ticks[0] = 10;
    f.ticks[1] = 20;
    f.nticks = 2;
    rc = sound_good(f.o.b, f.body, &f.w, 2, &f.host);
    CK(rc == EB_OK && f.o.b[0x13ce] == 1 && t_get32(f.o.b, 0x13ca) == 4);
    tf_init(&f);
    put_ids(&f);
    t_put16(f.o.b, 0x13a2, 5);
    t_put16(f.body, 0x45, 5);
    f.body[0x47] = 0;
    t_put16(f.body, 0xa11, -1);
    t_put16(f.body, 0x8de, -1);
    f.ticks[0] = 10;
    f.ticks[1] = 20;
    f.nticks = 2;
    rc = sound_good(f.o.b, f.body, &f.w, 1, &f.host);
    CK(rc == EB_OK && f.o.b[0x13ce] == 0x5a && t_get32(f.o.b, 0x13ca) == 4);

    /* the sound record read is the good one (0x777), not the pick, rotate or bad record */
    tf_init(&f);
    put_ids(&f);
    t_name(f.body, 0x746, "NO SOUND");
    t_name(f.body, 0x715, "NO SOUND");
    t_name(f.body, 0x7a8, "NO SOUND");
    t_put16(f.body, 0xa11, -1);
    t_put16(f.body, 0x8de, -1);
    f.ticks[0] = 10;
    f.ticks[1] = 20;
    f.nticks = 2;
    rc = sound_good(f.o.b, f.body, &f.w, 1, &f.host);
    CK(rc == EB_OK && strncmp(f.log, "play:258", 8) == 0);
}

int main(void)
{
    static const struct {
        const char *name;
        void (*fn)(void);
    } cases[] = {
        {"test_top_piece_47e8fe", test_top_piece_47e8fe},
        {"test_top_piece_47e9d3", test_top_piece_47e9d3},
        {"test_sound_pick_4809a7", test_sound_pick_4809a7},
        {"test_sound_rotate_480abe", test_sound_rotate_480abe},
        {"test_sound_good_480a1d", test_sound_good_480a1d},
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
