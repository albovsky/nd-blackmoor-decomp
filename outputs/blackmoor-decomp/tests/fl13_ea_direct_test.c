/* FL-13 direct tests of the raw 0xea Onebuild puzzle kernel helpers that FL-11 rejected as merged, now split into one
 * native symbol per original function (src/action_family_ea_runtime.c):
 *   0x484622 top_piece_placed      0x4846c2 top_piece_unplaced
 *   0x485ca1 pick_sound            0x485f12 rotate_sound          0x485d52 drop_sound
 *   0x485fb6 bad_drop_feedback     0x48633c good_drop_feedback
 *
 * The helpers are `static`, so this test includes the kernel source (same precedent as tests/fl11_ea_direct_test.c)
 * and calls each helper itself. Prints "PASS <name>" / "FAIL <name>: <message>"; the exit status is the failure count.
 * Fixtures are synthetic object and body byte images (no original bytes). All offsets are literal and hand-derived from
 * the Ghidra pseudocode of the original GAME.EXE functions (this = obj; the body is *(DAT_005bb5e5 + obj[0x26] * 0x8d)),
 * not taken from the kernel's own enums. Every case also checks that no byte outside the fields the original writes
 * was changed. */
#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "../src/action_family_ea_runtime.c"

static int g_failed;
static char g_msg[400];

static void note(int line, const char *fmt, ...)
{
    char tmp[300];
    va_list ap;
    if (g_failed) return;
    g_failed = 1;
    va_start(ap, fmt);
    vsnprintf(tmp, sizeof tmp, fmt, ap);
    va_end(ap);
    snprintf(g_msg, sizeof g_msg, "line %d: %s", line, tmp);
}

#define EXPECT(cond)                                      \
    do {                                                  \
        if (!(cond)) note(__LINE__, "%s", #cond);         \
    } while (0)
#define EXPECT_EQ(a, b)                                                                \
    do {                                                                               \
        const long long a_ = (long long)(a), b_ = (long long)(b);                      \
        if (a_ != b_) note(__LINE__, "%s = %lld, expected %lld", #a, a_, b_);          \
    } while (0)

/* Little-endian field access, independent of the kernel's rd_s32 / wr_32. */
static int32_t g32(const uint8_t *b, size_t o)
{
    return (int32_t)((uint32_t)b[o] | ((uint32_t)b[o + 1] << 8) | ((uint32_t)b[o + 2] << 16) | ((uint32_t)b[o + 3] << 24));
}
static void p32(uint8_t *b, size_t o, int32_t v)
{
    for (size_t k = 0; k < 4; ++k) b[o + k] = (uint8_t)((uint32_t)v >> (8u * k));
}
static int16_t g16(const uint8_t *b, size_t o) { return (int16_t)(uint16_t)(b[o] | (b[o + 1] << 8)); }
static void p16(uint8_t *b, size_t o, int v)
{
    b[o] = (uint8_t)(v & 0xff);
    b[o + 1] = (uint8_t)((v >> 8) & 0xff);
}

typedef struct Span {
    size_t lo, hi;
} Span;
#define SP(lo, hi) {(size_t)(lo), (size_t)(hi)}

static void only_check(int line, const uint8_t *before, const uint8_t *after, const Span *spans, size_t ns)
{
    for (size_t i = 0; i < EA_OBJECT_BYTES; ++i) {
        int allowed = 0;
        if (before[i] == after[i]) continue;
        for (size_t s = 0; s < ns; ++s)
            if (i >= spans[s].lo && i < spans[s].hi) allowed = 1;
        if (!allowed) {
            note(line, "stray write at object offset 0x%zx", i);
            return;
        }
    }
}
#define EXPECT_NO_CHANGE(before, after) only_check(__LINE__, (before), (after), NULL, 0)
#define EXPECT_ONLY(before, after, ...)                                                    \
    do {                                                                                   \
        const Span s_[] = {__VA_ARGS__};                                                   \
        only_check(__LINE__, (before), (after), s_, sizeof s_ / sizeof s_[0]);             \
    } while (0)

static void obj_fill(uint8_t *o)
{
    for (size_t i = 0; i < EA_OBJECT_BYTES; ++i) o[i] = (uint8_t)(0x31u + i * 13u);
}

/* Literal layout (from the pseudocode): piece i at 0x28 + i * 0x85, its layer word at +0. */
#define XP(i) (0x28u + (size_t)(i) * 0x85u)

/* ------------------------------------------------------------------------------------------------------------- */
/* 0x484622 / 0x4846c2: the piece with the greatest layer word (+0x28 + piece * 0x85), the first on ties, or -1 for an
 * empty list. 0x484622 reads the list at +0xbfb and the count word at +0xc23; 0x4846c2 the list at +0xbd1 and the count
 * word at +0xbf9. The other list is filled with decoys that name different winners. */

typedef int16_t (*TopFn)(const uint8_t *);

static void top_cases(TopFn fn, size_t list, size_t count, size_t dlist, size_t dcount)
{
    uint8_t obj[EA_OBJECT_BYTES], before[EA_OBJECT_BYTES];
    obj_fill(obj);
    /* decoy list: piece 9 has by far the greatest layer and is listed first, count 3. */
    for (int k = 0; k < 20; ++k) p16(obj, dlist + (size_t)k * 2u, 9);
    p16(obj, dcount, 3);
    for (int i = 0; i < 20; ++i) p16(obj, XP(i), 1);
    p16(obj, XP(9), 3000);

    /* list [3,1,4,0,2], layers 5,9,9,2,7: the scan starts at 3 (layer 2), takes 1 (9), keeps 1 against 4 (7), 0 (5) and
     * against 2 (9, a tie, the first stays). */
    {
        static const int16_t l[5] = {3, 1, 4, 0, 2};
        static const int16_t z[5] = {5, 9, 9, 2, 7}; /* layers of pieces 0..4 */
        for (int k = 0; k < 5; ++k) {
            p16(obj, list + (size_t)k * 2u, l[k]);
            p16(obj, XP(k), z[k]);
        }
        p16(obj, count, 5);
        memcpy(before, obj, sizeof obj);
        EXPECT_EQ(fn(obj), 1);
        EXPECT_NO_CHANGE(before, obj);
    }
    /* the greatest layer is the last entry. */
    {
        static const int16_t l[4] = {0, 1, 2, 3};
        for (int k = 0; k < 4; ++k) {
            p16(obj, list + (size_t)k * 2u, l[k]);
            p16(obj, XP(k), k + 1);
        }
        p16(obj, count, 4);
        EXPECT_EQ(fn(obj), 3);
    }
    /* the greatest layer is the first entry: it stays. */
    {
        for (int k = 0; k < 4; ++k) {
            p16(obj, list + (size_t)k * 2u, k);
            p16(obj, XP(k), 10 - k);
        }
        p16(obj, count, 4);
        EXPECT_EQ(fn(obj), 0);
    }
    /* layers are signed words: -3 beats -5 and -9. */
    {
        p16(obj, list, 0);
        p16(obj, list + 2, 1);
        p16(obj, list + 4, 2);
        p16(obj, XP(0), -5);
        p16(obj, XP(1), -3);
        p16(obj, XP(2), -9);
        p16(obj, count, 3);
        EXPECT_EQ(fn(obj), 1);
    }
    /* one entry: that entry, whatever its piece index (17 here). */
    p16(obj, list, 17);
    p16(obj, count, 1);
    EXPECT_EQ(fn(obj), 17);
    /* a zero count is -1 even though the list holds an entry. */
    p16(obj, count, 0);
    EXPECT_EQ(fn(obj), -1);
    /* a negative count word: nonzero, so the first entry, and the signed loop bound ends the scan at once. */
    p16(obj, list, 6);
    p16(obj, list + 2, 7);
    p16(obj, XP(6), 1);
    p16(obj, XP(7), 50);
    p16(obj, count, -1);
    EXPECT_EQ(fn(obj), 6);
    /* the decoy list and count are untouched and unused. */
    EXPECT_EQ(g16(obj, dcount), 3);
    EXPECT_EQ(g16(obj, dlist), 9);
}

static void t_top_piece_placed(void) { top_cases(top_piece_placed, 0xbfb, 0xc23, 0xbd1, 0xbf9); }
static void t_top_piece_unplaced(void) { top_cases(top_piece_unplaced, 0xbd1, 0xbf9, 0xbfb, 0xc23); }

/* ------------------------------------------------------------------------------------------------------------- */
/* Host mock for the sound helpers: a log in call order, scripted ticks, rands, caption switch and AUTOTEXT table. */

typedef struct Sx {
    uint32_t tick;
    int32_t rands[8];
    int nrand, irand;
    int captions;
    const char *lk_key[6];
    const char *lk_text[6];
    int nlk;
    const uint8_t *obj;
    char log[3000];
} Sx;

static void sx_log(Sx *m, const char *fmt, ...)
{
    char tmp[600];
    va_list ap;
    va_start(ap, fmt);
    vsnprintf(tmp, sizeof tmp, fmt, ap);
    va_end(ap);
    if (m->log[0] != '\0') strncat(m->log, ";", sizeof m->log - strlen(m->log) - 1u);
    strncat(m->log, tmp, sizeof m->log - strlen(m->log) - 1u);
}
static uint32_t sx_tick(void *c)
{
    Sx *m = (Sx *)c;
    sx_log(m, "T");
    return m->tick;
}
static int sx_rand(void *c, int32_t *v)
{
    Sx *m = (Sx *)c;
    sx_log(m, "R");
    if (m->irand >= m->nrand) {
        note(__LINE__, "unscripted rand call");
        *v = 0;
        return 0;
    }
    *v = m->rands[m->irand++];
    return 0;
}
/* The record pointer must be the object buffer (id = 0x10000 + object offset); the name is read at call time. */
static int sx_prepare(void *c, uint32_t id, const uint8_t *rec)
{
    Sx *m = (Sx *)c;
    if (id < 0x10000u || rec != m->obj + (id - 0x10000u)) sx_log(m, "PTRBAD");
    sx_log(m, "P%x:%s", (unsigned)id, (const char *)rec);
    return 0;
}
static int sx_play(void *c, int16_t ch)
{
    sx_log((Sx *)c, "L%d", (int)ch);
    return 0;
}
static int sx_caps(void *c, int32_t *e)
{
    Sx *m = (Sx *)c;
    sx_log(m, "C");
    *e = m->captions;
    return 0;
}
static int sx_lookup(void *c, const char *key, const char **text)
{
    Sx *m = (Sx *)c;
    sx_log(m, "K%s", key);
    *text = NULL;
    for (int i = 0; i < m->nlk; ++i)
        if (strcmp(m->lk_key[i], key) == 0) *text = m->lk_text[i];
    return 0;
}
static int sx_show(void *c, const char *text)
{
    sx_log((Sx *)c, "S%s", text);
    return 0;
}

static void sx_init(Sx *m, EaHost *h, const uint8_t *obj, uint32_t tick)
{
    memset(m, 0, sizeof *m);
    memset(h, 0, sizeof *h);
    m->tick = tick;
    m->obj = obj;
    h->context = m;
    h->tick = sx_tick;
    h->rand_value = sx_rand;
    h->sound_prepare = sx_prepare;
    h->sound_play = sx_play;
    h->captions_enabled = sx_caps;
    h->autotext_lookup = sx_lookup;
    h->caption_show = sx_show;
}

static void log_check(int line, const Sx *m, const char *expected)
{
    if (strcmp(m->log, expected) != 0) note(line, "log \"%s\" expected \"%s\"", m->log, expected);
}
#define EXPECT_LOG(m, text) log_check(__LINE__, (m), (text))

/* A 0x31-byte sound record: a NUL-terminated name, filler, and the channel word at +0x21. */
static void put_rec(uint8_t *body, size_t off, const char *name, int chan, uint8_t fill)
{
    memset(body + off, fill, 0x31);
    memcpy(body + off, name, strlen(name) + 1u);
    p16(body, off + 0x21, chan);
}
static void put_no_sound(uint8_t *body, size_t off) { put_rec(body, off, "NO SOUND", 0x55, 0x6e); }
static void put_str(uint8_t *body, size_t off, const char *s) { memcpy(body + off, s, strlen(s) + 1u); }

/* ------------------------------------------------------------------------------------------------------------- */
/* 0x485ca1 / 0x485f12: if the 9 bytes at body+0x6a7 (pick) / body+0x676 (rotate) are not "NO SOUND\0", copy the 0x31
 * byte record to obj+0xb52, prepare it (0x4fb77a), play the channel word at obj+0xb73 (0x4fb2e3), and for the pick
 * store obj+0xbac := 1; both then store obj+0xbc9 := GetTickCount() + 300 and obj+0xb87 := 0. */

typedef int (*SndFn)(uint8_t *, const uint8_t *, const EaHost *);

static void snd_simple(SndFn fn, size_t rec, size_t other, const char *name, int sets_state)
{
    uint8_t obj[EA_OBJECT_BYTES], before[EA_OBJECT_BYTES], body[EA_BODY_BYTES];
    uint8_t want[0x31];
    Sx mk;
    EaHost h;
    char expect[200];

    memset(body, 0x20, sizeof body);
    put_rec(body, rec, name, 7, 0x41);
    put_rec(body, other, "DECOYWAV", 99, 0x42); /* the sibling helper's record: must not be used */

    /* a sound: record copied, prepared, played, deadline = tick + 300, +0xb87 := 0, state only for the pick. */
    obj_fill(obj);
    p32(obj, 0xb87, 77);
    memcpy(before, obj, sizeof obj);
    sx_init(&mk, &h, obj, 1000u);
    EXPECT_EQ(fn(obj, body, &h), EA_OK);
    memcpy(want, body + rec, 0x31);
    EXPECT(memcmp(obj + 0xb52, want, 0x31) == 0);
    EXPECT_EQ(g16(obj, 0xb73), 7);
    EXPECT_EQ(g32(obj, 0xb87), 0);
    EXPECT_EQ(g32(obj, 0xbc9), 1300);
    if (sets_state) {
        EXPECT_EQ(g32(obj, 0xbac), 1);
        EXPECT_ONLY(before, obj, SP(0xb52, 0xb83), SP(0xb87, 0xb8b), SP(0xbac, 0xbb0), SP(0xbc9, 0xbcd));
    } else {
        EXPECT_ONLY(before, obj, SP(0xb52, 0xb83), SP(0xb87, 0xb8b), SP(0xbc9, 0xbcd));
        EXPECT_EQ(g32(obj, 0xbac), g32(before, 0xbac)); /* the rotate leaves the state alone */
    }
    snprintf(expect, sizeof expect, "P10b52:%s;L7;T", name);
    EXPECT_LOG(&mk, expect);

    /* the deadline add wraps in 32 bits like the original's `add`. */
    obj_fill(obj);
    sx_init(&mk, &h, obj, 0xFFFFFF00u);
    EXPECT_EQ(fn(obj, body, &h), EA_OK);
    EXPECT_EQ(g32(obj, 0xbc9), (int32_t)(0xFFFFFF00u + 300u));

    /* the 9-byte test is "NO SOUND\0": the name with the NUL decides, the bytes after it do not. */
    put_no_sound(body, rec);
    obj_fill(obj);
    memcpy(before, obj, sizeof obj);
    sx_init(&mk, &h, obj, 1000u);
    EXPECT_EQ(fn(obj, body, &h), EA_OK);
    EXPECT_NO_CHANGE(before, obj);
    EXPECT_LOG(&mk, "");

    /* "NO SOUNDS" (a longer name starting the same) is a sound: the NUL is part of the comparison. */
    put_rec(body, rec, "NO SOUNDS", 7, 0x41);
    obj_fill(obj);
    sx_init(&mk, &h, obj, 1000u);
    EXPECT_EQ(fn(obj, body, &h), EA_OK);
    EXPECT_LOG(&mk, "P10b52:NO SOUNDS;L7;T");

    /* a sound name that differs only in its last character before the NUL is a sound. */
    put_rec(body, rec, "NO SOUNE", 7, 0x41);
    obj_fill(obj);
    sx_init(&mk, &h, obj, 1000u);
    EXPECT_EQ(fn(obj, body, &h), EA_OK);
    EXPECT_LOG(&mk, "P10b52:NO SOUNE;L7;T");
}

static void t_pick_sound(void) { snd_simple(pick_sound, 0x6a7, 0x676, "PICKWAV", 1); }
static void t_rotate_sound(void) { snd_simple(rotate_sound, 0x676, 0x6a7, "ROTWAV", 0); }

/* ------------------------------------------------------------------------------------------------------------- */
/* 0x485d52: the drop sound. Record at body+0x6d8, copied to obj+0xb52. Then r = rand() % 3; while r > 0 and no alternate
 * was taken: r == 1 and the record at body+0x709 is not "NO SOUND\0" -> its name (strlen + 1 bytes) is copied over the
 * start of obj+0xb52 and the loop ends; r == 2 and the record at body+0x72a is not "NO SOUND\0" -> likewise; otherwise
 * r = rand() % 3 again. Then prepare, play(word obj+0xb73), obj+0xbac := 1, obj+0xbc9 := tick + 300, obj+0xb87 := 1. */

static void drop_case(int line, const char *alt1, const char *alt2, const int32_t *rands, int nrand, const char *want_name,
                      const char *want_log)
{
    uint8_t obj[EA_OBJECT_BYTES], before[EA_OBJECT_BYTES], body[EA_BODY_BYTES];
    uint8_t want[0x31];
    Sx mk;
    EaHost h;
    memset(body, 0x20, sizeof body);
    put_rec(body, 0x6d8, "MAINDROP", 9, 0x43);
    if (alt1) put_rec(body, 0x709, alt1, 4, 0x44); else put_no_sound(body, 0x709);
    if (alt2) put_rec(body, 0x72a, alt2, 5, 0x45); else put_no_sound(body, 0x72a);
    put_rec(body, 0x6a7, "PICKDECOY", 61, 0x46);
    put_rec(body, 0x676, "ROTDECOY", 62, 0x47);
    obj_fill(obj);
    p32(obj, 0xb87, 5);
    memcpy(before, obj, sizeof obj);
    sx_init(&mk, &h, obj, 5000u);
    memcpy(mk.rands, rands, (size_t)nrand * sizeof rands[0]);
    mk.nrand = nrand;
    if (drop_sound(obj, body, &h) != EA_OK) note(line, "drop_sound failed");
    /* expected record: the main record with the chosen name (strlen + 1 bytes) over its start. */
    memcpy(want, body + 0x6d8, 0x31);
    memcpy(want, want_name, strlen(want_name) + 1u);
    if (memcmp(obj + 0xb52, want, 0x31) != 0) note(line, "record at 0xb52 is wrong");
    if (g16(obj, 0xb73) != 9) note(line, "channel word at 0xb73 = %d", g16(obj, 0xb73));
    if (g32(obj, 0xbac) != 1) note(line, "state = %d", g32(obj, 0xbac));
    if (g32(obj, 0xbc9) != 5300) note(line, "deadline = %d", g32(obj, 0xbc9));
    if (g32(obj, 0xb87) != 1) note(line, "+0xb87 = %d", g32(obj, 0xb87));
    if (mk.irand != nrand) note(line, "consumed %d of %d rands", mk.irand, nrand);
    only_check(line, before, obj, (const Span[]){SP(0xb52, 0xb83), SP(0xb87, 0xb8b), SP(0xbac, 0xbb0), SP(0xbc9, 0xbcd)}, 4);
    log_check(line, &mk, want_log);
}

static void t_drop_sound(void)
{
    {
        const int32_t r[] = {3}; /* 3 % 3 == 0: no alternate, one rand */
        drop_case(__LINE__, "ALT1", "ALT2", r, 1, "MAINDROP", "R;P10b52:MAINDROP;L9;T");
    }
    {
        const int32_t r[] = {1}; /* 1: alternate 1 */
        drop_case(__LINE__, "ALT1WAV", "ALT2", r, 1, "ALT1WAV", "R;P10b52:ALT1WAV;L9;T");
    }
    {
        const int32_t r[] = {1000}; /* 1000 % 3 == 1 */
        drop_case(__LINE__, "ALT1WAV", "ALT2", r, 1, "ALT1WAV", "R;P10b52:ALT1WAV;L9;T");
    }
    {
        const int32_t r[] = {2}; /* 2: alternate 2 */
        drop_case(__LINE__, "ALT1", "ALT2LONGERNAME", r, 1, "ALT2LONGERNAME", "R;P10b52:ALT2LONGERNAME;L9;T");
    }
    {
        const int32_t r[] = {1, 2}; /* 1 with no alternate 1: roll again; 2 takes alternate 2 */
        drop_case(__LINE__, NULL, "ALT2", r, 2, "ALT2", "R;R;P10b52:ALT2;L9;T");
    }
    {
        const int32_t r[] = {1, 0}; /* 1 with no alternate 1: roll again; 0 ends the loop on the main name */
        drop_case(__LINE__, NULL, "ALT2", r, 2, "MAINDROP", "R;R;P10b52:MAINDROP;L9;T");
    }
    {
        const int32_t r[] = {2, 1}; /* 2 with no alternate 2: roll again; 1 takes alternate 1 */
        drop_case(__LINE__, "ALT1", NULL, r, 2, "ALT1", "R;R;P10b52:ALT1;L9;T");
    }
    {
        const int32_t r[] = {2, 2, 2, 0}; /* 2 with no alternate 2 repeatedly, then 0 */
        drop_case(__LINE__, "ALT1", NULL, r, 4, "MAINDROP", "R;R;R;R;P10b52:MAINDROP;L9;T");
    }
    {
        const int32_t r[] = {1, 1, 2}; /* both alternates absent: 1, 1, 2 then 2 never succeeds; script ends with 0 */
        const int32_t s[] = {1, 1, 2, 0};
        (void)r;
        drop_case(__LINE__, NULL, NULL, s, 4, "MAINDROP", "R;R;R;R;P10b52:MAINDROP;L9;T");
    }
    {
        const int32_t r[] = {2}; /* alternate 2 present, alternate 1 absent: 2 is not blocked by alternate 1 */
        drop_case(__LINE__, NULL, "ALT2", r, 1, "ALT2", "R;P10b52:ALT2;L9;T");
    }

    /* the first record is "NO SOUND": nothing runs, not even rand or the tick. */
    {
        uint8_t obj[EA_OBJECT_BYTES], before[EA_OBJECT_BYTES], body[EA_BODY_BYTES];
        Sx mk;
        EaHost h;
        memset(body, 0x20, sizeof body);
        put_no_sound(body, 0x6d8);
        put_rec(body, 0x709, "ALT1", 4, 0x44);
        obj_fill(obj);
        memcpy(before, obj, sizeof obj);
        sx_init(&mk, &h, obj, 5000u);
        EXPECT_EQ(drop_sound(obj, body, &h), EA_OK);
        EXPECT_NO_CHANGE(before, obj);
        EXPECT_LOG(&mk, "");
    }
}

/* ------------------------------------------------------------------------------------------------------------- */
/* 0x48633c (good) and 0x485fb6 (bad): same shape, different body offsets. Record at rec, channel word at rec+0x21 (read
 * from the BODY), alternates at alt1 / alt2, keys at key + r * 0x21, texts at text + r * 200, buffer at obj+0xb21.
 *   NO SOUND at rec -> obj+0xbac := 0, return.
 *   copy the record to obj+0xb21; r = rand() % 3 with the alternate loop of 0x485d52 (alternates copied to obj+0xb21);
 *   prepare(obj+0xb21), play(body chan word);
 *   if [0x5bb202] (captions on): if the key string at key + r*0x21 is non-empty and the AUTOTEXT lookup finds a text of
 *     length < 0x9c41, show text+"<e>" and set obj+0xbc1 := 1; if no text was found and the body text at text + r*200 is
 *     non-empty, show it with "<e>" and set obj+0xbc1 := 1;
 *   obj+0xbac := 2; good only: obj+0xbc1 := 1; obj+0xbc9 := tick + 2000. */

typedef struct Fb {
    const char *fn_name;
    int (*fn)(uint8_t *, const uint8_t *, const EaHost *);
    size_t rec, chan, alt1, alt2, key, text;     /* this function's literal offsets */
    size_t orec, oalt1, oalt2, okey, otext;      /* the sibling function's, filled with decoys */
    int good;
} Fb;

static const Fb FB_GOOD = {"good", good_drop_feedback, 0x74b, 0x76c, 0x77c, 0x79d, 0x7be, 0x821,
                           0xa79, 0xaaa, 0xacb, 0xaec, 0xb4f, 1};
static const Fb FB_BAD = {"bad", bad_drop_feedback, 0xa79, 0xa9a, 0xaaa, 0xacb, 0xaec, 0xb4f,
                          0x74b, 0x77c, 0x79d, 0x7be, 0x821, 0};

typedef struct FbSetup {
    const char *alt1, *alt2; /* NULL = NO SOUND */
    const char *key[3];      /* "" = empty */
    const char *text[3];
    int captions;
    int nlk;
    const char *lk_key[3];
    const char *lk_text[3];
} FbSetup;

static void fb_body(uint8_t *body, const Fb *f, const FbSetup *s)
{
    memset(body, 0x20, EA_BODY_BYTES);
    /* the sibling function's area: loud decoys */
    put_rec(body, f->orec, "OTHERMAIN", 81, 0x51);
    put_rec(body, f->oalt1, "OTHERALT1", 82, 0x52);
    put_rec(body, f->oalt2, "OTHERALT2", 83, 0x53);
    for (int r = 0; r < 3; ++r) {
        put_str(body, f->okey + (size_t)r * 0x21u, "OTHERKEY");
        put_str(body, f->otext + (size_t)r * 200u, "OTHERTEXT");
    }
    /* this function's area */
    put_rec(body, f->rec, "FEEDMAIN", 11, 0x61);
    if (s->alt1) put_rec(body, f->alt1, s->alt1, 12, 0x62); else put_no_sound(body, f->alt1);
    if (s->alt2) put_rec(body, f->alt2, s->alt2, 13, 0x63); else put_no_sound(body, f->alt2);
    for (int r = 0; r < 3; ++r) {
        body[f->key + (size_t)r * 0x21u] = 0;
        body[f->text + (size_t)r * 200u] = 0;
        put_str(body, f->key + (size_t)r * 0x21u, s->key[r]);
        put_str(body, f->text + (size_t)r * 200u, s->text[r]);
    }
}

static void fb_case(int line, const Fb *f, const FbSetup *s, const int32_t *rands, int nrand, const char *want_name,
                    const char *want_log, int want_caption /* 1 = obj+0xbc1 written with 1, 0 = untouched */)
{
    uint8_t obj[EA_OBJECT_BYTES], before[EA_OBJECT_BYTES], body[EA_BODY_BYTES];
    uint8_t want[0x31];
    Sx mk;
    EaHost h;
    int rc;
    fb_body(body, f, s);
    obj_fill(obj);
    memcpy(before, obj, sizeof obj);
    sx_init(&mk, &h, obj, 70000u);
    memcpy(mk.rands, rands, (size_t)nrand * sizeof rands[0]);
    mk.nrand = nrand;
    mk.captions = s->captions;
    mk.nlk = s->nlk;
    for (int i = 0; i < s->nlk; ++i) {
        mk.lk_key[i] = s->lk_key[i];
        mk.lk_text[i] = s->lk_text[i];
    }
    rc = f->fn(obj, body, &h);
    if (rc != EA_OK) note(line, "%s feedback returned %d", f->fn_name, rc);
    memcpy(want, body + f->rec, 0x31);
    memcpy(want, want_name, strlen(want_name) + 1u);
    if (memcmp(obj + 0xb21, want, 0x31) != 0) note(line, "%s: record at 0xb21 is wrong", f->fn_name);
    if (g32(obj, 0xbac) != 2) note(line, "%s: state = %d", f->fn_name, g32(obj, 0xbac));
    if (g32(obj, 0xbc9) != 72000) note(line, "%s: deadline = %d", f->fn_name, g32(obj, 0xbc9));
    if (want_caption) {
        if (g32(obj, 0xbc1) != 1) note(line, "%s: caption flag = %d", f->fn_name, g32(obj, 0xbc1));
        only_check(line, before, obj, (const Span[]){SP(0xb21, 0xb52), SP(0xbac, 0xbb0), SP(0xbc1, 0xbc5), SP(0xbc9, 0xbcd)}, 4);
    } else {
        if (g32(obj, 0xbc1) != g32(before, 0xbc1)) note(line, "%s: caption flag changed", f->fn_name);
        only_check(line, before, obj, (const Span[]){SP(0xb21, 0xb52), SP(0xbac, 0xbb0), SP(0xbc9, 0xbcd)}, 3);
    }
    if (mk.irand != nrand) note(line, "%s: consumed %d of %d rands", f->fn_name, mk.irand, nrand);
    log_check(line, &mk, want_log);
}

static void fb_all(const Fb *f)
{
    static char longtext[0x9c42];
    const FbSetup base = {"ALT1", "ALT2", {"KEY0", "KEY1", "KEY2"}, {"TXT0", "TXT1", "TXT2"}, 1, 0, {0}, {0}};
    /* the caption flag: good always sets it (0x486677); bad only when a caption was shown. */
    const int flag_when_silent = f->good;

    /* NO SOUND at the record: state := 0 and nothing else. */
    {
        uint8_t obj[EA_OBJECT_BYTES], before[EA_OBJECT_BYTES], body[EA_BODY_BYTES];
        Sx mk;
        EaHost h;
        fb_body(body, f, &base);
        put_no_sound(body, f->rec);
        obj_fill(obj);
        p32(obj, 0xbac, 4);
        memcpy(before, obj, sizeof obj);
        sx_init(&mk, &h, obj, 70000u);
        EXPECT_EQ(f->fn(obj, body, &h), EA_OK);
        EXPECT_EQ(g32(obj, 0xbac), 0);
        EXPECT_ONLY(before, obj, SP(0xbac, 0xbb0));
        EXPECT_LOG(&mk, "");
    }

    /* captions off: the sound runs, no caption call at all. */
    {
        FbSetup s = base;
        const int32_t r[] = {0};
        s.captions = 0;
        fb_case(__LINE__, f, &s, r, 1, "FEEDMAIN", "R;P10b21:FEEDMAIN;L11;C;T", flag_when_silent);
    }
    /* captions on, r == 0: key 0 found -> that text shown, the body text not. */
    {
        FbSetup s = base;
        const int32_t r[] = {0};
        s.nlk = 1;
        s.lk_key[0] = "KEY0";
        s.lk_text[0] = "FOUND0";
        fb_case(__LINE__, f, &s, r, 1, "FEEDMAIN", "R;P10b21:FEEDMAIN;L11;C;KKEY0;SFOUND0<e>;T", 1);
    }
    /* key not found -> the body text of slot 0 with the suffix. */
    {
        FbSetup s = base;
        const int32_t r[] = {0};
        fb_case(__LINE__, f, &s, r, 1, "FEEDMAIN", "R;P10b21:FEEDMAIN;L11;C;KKEY0;STXT0<e>;T", 1);
    }
    /* empty key and non-empty text: no lookup, the text shown. */
    {
        FbSetup s = base;
        const int32_t r[] = {0};
        s.key[0] = "";
        fb_case(__LINE__, f, &s, r, 1, "FEEDMAIN", "R;P10b21:FEEDMAIN;L11;C;STXT0<e>;T", 1);
    }
    /* empty key and empty text: silent. */
    {
        FbSetup s = base;
        const int32_t r[] = {0};
        s.key[0] = "";
        s.text[0] = "";
        fb_case(__LINE__, f, &s, r, 1, "FEEDMAIN", "R;P10b21:FEEDMAIN;L11;C;T", flag_when_silent);
    }
    /* non-empty key, not found, empty text: the lookup runs and nothing is shown. */
    {
        FbSetup s = base;
        const int32_t r[] = {0};
        s.text[0] = "";
        fb_case(__LINE__, f, &s, r, 1, "FEEDMAIN", "R;P10b21:FEEDMAIN;L11;C;KKEY0;T", flag_when_silent);
    }
    /* r == 1 (alternate 1 present): the alternate name, key slot 1 (+0x21) and text slot 1 (+200). */
    {
        FbSetup s = base;
        const int32_t r[] = {1};
        fb_case(__LINE__, f, &s, r, 1, "ALT1", "R;P10b21:ALT1;L11;C;KKEY1;STXT1<e>;T", 1);
        s.nlk = 1;
        s.lk_key[0] = "KEY1";
        s.lk_text[0] = "FOUND1";
        fb_case(__LINE__, f, &s, r, 1, "ALT1", "R;P10b21:ALT1;L11;C;KKEY1;SFOUND1<e>;T", 1);
    }
    /* r == 2 (alternate 2 present): key slot 2 (+0x42) and text slot 2 (+400). */
    {
        FbSetup s = base;
        const int32_t r[] = {2};
        fb_case(__LINE__, f, &s, r, 1, "ALT2", "R;P10b21:ALT2;L11;C;KKEY2;STXT2<e>;T", 1);
    }
    /* r == 1 with no alternate 1: roll again (2) -> alternate 2 and slot 2. */
    {
        FbSetup s = base;
        const int32_t r[] = {1, 2};
        s.alt1 = NULL;
        fb_case(__LINE__, f, &s, r, 2, "ALT2", "R;R;P10b21:ALT2;L11;C;KKEY2;STXT2<e>;T", 1);
    }
    /* r == 2 with no alternate 2: roll again (1) -> alternate 1 and slot 1. */
    {
        FbSetup s = base;
        const int32_t r[] = {2, 1};
        s.alt2 = NULL;
        fb_case(__LINE__, f, &s, r, 2, "ALT1", "R;R;P10b21:ALT1;L11;C;KKEY1;STXT1<e>;T", 1);
    }
    /* r == 2 with no alternate 2, rolled to 0: the main record and slot 0 (the final r, not the first). */
    {
        FbSetup s = base;
        const int32_t r[] = {2, 0};
        s.alt2 = NULL;
        fb_case(__LINE__, f, &s, r, 2, "FEEDMAIN", "R;R;P10b21:FEEDMAIN;L11;C;KKEY0;STXT0<e>;T", 1);
    }
    /* an AUTOTEXT text of 0x9c41 characters is too long: it is ignored and the body text is used instead. */
    {
        FbSetup s = base;
        const int32_t r[] = {0};
        memset(longtext, 'x', 0x9c41);
        longtext[0x9c41] = '\0';
        s.nlk = 1;
        s.lk_key[0] = "KEY0";
        s.lk_text[0] = longtext;
        fb_case(__LINE__, f, &s, r, 1, "FEEDMAIN", "R;P10b21:FEEDMAIN;L11;C;KKEY0;STXT0<e>;T", 1);
    }
    /* too-long text and empty body text: nothing shown. */
    {
        FbSetup s = base;
        const int32_t r[] = {0};
        s.text[0] = "";
        s.nlk = 1;
        s.lk_key[0] = "KEY0";
        s.lk_text[0] = longtext;
        fb_case(__LINE__, f, &s, r, 1, "FEEDMAIN", "R;P10b21:FEEDMAIN;L11;C;KKEY0;T", flag_when_silent);
    }
}

static void t_good_drop_feedback(void) { fb_all(&FB_GOOD); }
static void t_bad_drop_feedback(void) { fb_all(&FB_BAD); }

/* ------------------------------------------------------------------------------------------------------------- */

typedef struct Case {
    const char *name;
    void (*fn)(void);
} Case;

int main(void)
{
    static const Case cases[] = {
        {"top_piece_placed", t_top_piece_placed},     {"top_piece_unplaced", t_top_piece_unplaced},
        {"pick_sound", t_pick_sound},                 {"rotate_sound", t_rotate_sound},
        {"drop_sound", t_drop_sound},                 {"bad_drop_feedback", t_bad_drop_feedback},
        {"good_drop_feedback", t_good_drop_feedback},
    };
    int failures = 0;
    for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        g_failed = 0;
        g_msg[0] = '\0';
        cases[i].fn();
        if (g_failed) {
            printf("FAIL %s: %s\n", cases[i].name, g_msg);
            ++failures;
        } else {
            printf("PASS %s\n", cases[i].name);
        }
    }
    return failures;
}
