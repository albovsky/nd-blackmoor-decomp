/* FL-14 group x direct tests: the score / time display setters and resets, the typing quiz (raw 0xf5) key, click, invalidate,
 * new-game reset and character helper, the password character filter, the scene restore saver, and the 0xd0 / 0xd1 invalidate
 * methods. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the failure count. Fixtures are synthetic (no
 * original bytes). Expected values come from the Ghidra pseudocode and the disassembly of GAME.EXE, not from running the native
 * code:
 *   0x445f53  zero +4, +0xc, +0x23c, bytes +0x25c and +0x27a, 10 dwords at +0x14 and +0x3c, 0x2e dwords at +0xbc
 *   0x445fc5  zero +8, +0x10, +0xb4, +0xb8, +0x240, +0x244, bytes +0x248 +0x252 +0x266 +0x270, 10 dwords at +0x64 and +0x8c,
 *             0x32 dwords at +0x174
 *   0x446532  [this+4] := arg;  0x446548  [this+8] := arg
 *   0x44655e  [this+0x23c] := arg; sprintf(this+0x25c, "%d", arg)       (format at 0x548238)
 *   0x446598  [this+0x240] := a; [this+0x244] := b; sprintf(this+0x248, "%02d", a); sprintf(this+0x252, "%02d", b)
 *   0x4b8087  dword [0x5a4c0a] := 0; word [0x5a4c0e] := 0
 *   0x4b80a5  if (this[0x14] != 0 && (short)this[4] != -1) dword [0x5d15a5 + slot * 0x4a] := 1
 *   0x4b8193  if (this[0x14] != 0 && this[0x10] == 0 && this[0x637] == 0 && row phase == 1 && 0x437ea1(ch)) { this[0x636] := ch;
 *             this[0x637] := 1 }
 *   0x4b82cd  if (this[0x14] != 0 && this[0x20] == 0 && this[0x10] == 0 && row phase == 1 && [0x5c39e5] == 0x27eb) row phase := 2
 *   0x4b8520  letters; digits when body[0x432] != 0; else any of body[0x434 .. 0x452) when body[0x434] != 0
 *   0x437ea1  see ref_437ea1 below (the literal ladder of the pseudocode, signed char compares)
 *   0x4eb70f  word [0x5c3a1b] := word [0x5bb57b]; word [0x5c3a1d] := word [0x5bb57f]; word [0x5c3a1f] := word [0x5bb50b];
 *             word [0x5c3a21] := word [0x5bb593]; word [0x5c3a23] := low word of the stack argument; dword [0x5c3a25] :=
 *             dword [0x5bb5a7]; dword [0x5c3a29] := dword [0x5bb5ab] and then := dword [0x5bb5af]
 *   0x4b5c11  if (this[0x225] != 0 && (short)this[0x1c] != -1) dword [0x5d15a5 + slot * 0x4a] := 1
 *   0x48d0e5  if (this[0x33] != 0 && (short)this[0x1c] != -1) dword [0x5d15a5 + slot * 0x4a] := 1
 * The redraw store of the three invalidate methods is the host's mark_dirty callback here, the row phase of 0x4b8193 and
 * 0x4b82cd is a parameter, and the candidate 0x5c39e5 of 0x4b82cd is a parameter. The kernel of 0xf5 is pulled in as a
 * translation unit (as tests/fl11_f5_direct_test.c does) to reach the static char_allowed. */
#include "../src/action_family_f5_runtime.c"

#include "../src/action_family_76_runtime.h"
#include "../src/action_family_7d_runtime.h"
#include "../src/action_family_d0_runtime.h"
#include "../src/action_family_d1_runtime.h"

#include <stddef.h>
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

/* ---- the score / time display (0x638603 object; the native struct starts at object offset 4) ------------------------------ */

#define OBJ_BASE 4u
#define FILL 0xa5

enum { STD_BYTES = (int)sizeof(StdDisplay) };

static void std_fill(StdDisplay *d)
{
    memset(d, FILL, sizeof *d);
}

/* Zero `bytes` bytes at original object offset `off` of the expected image. */
static void zero_at(uint8_t *img, unsigned off, unsigned bytes)
{
    CK(off >= OBJ_BASE && off - OBJ_BASE + bytes <= sizeof(StdDisplay));
    memset(img + (off - OBJ_BASE), 0, bytes);
}

static void expect_image(const StdDisplay *d, const uint8_t *img)
{
    const uint8_t *p = (const uint8_t *)d;
    size_t i;
    for (i = 0; i < sizeof *d; ++i) {
        if (p[i] != img[i] && !g_failed) {
            g_failed = 1;
            snprintf(g_msg, sizeof g_msg, "object offset 0x%x: native 0x%02x expected 0x%02x", (unsigned)(i + OBJ_BASE), p[i],
                     img[i]);
        }
    }
}

static int test_std_reset_score(void)
{
    StdDisplay d;
    uint8_t img[sizeof(StdDisplay)];
    unsigned i;

    CK(offsetof(StdDisplay, score_str) + OBJ_BASE == 0x25c && offsetof(StdDisplay, prev_score_str) + OBJ_BASE == 0x27a);
    CK(offsetof(StdDisplay, score_block) + OBJ_BASE == 0xbc && offsetof(StdDisplay, score) + OBJ_BASE == 0x23c);
    std_fill(&d);
    memset(img, FILL, sizeof img);
    zero_at(img, 0x4, 4);
    zero_at(img, 0xc, 4);
    zero_at(img, 0x23c, 4);
    zero_at(img, 0x25c, 1);
    zero_at(img, 0x27a, 1);
    zero_at(img, 0x14, 40);
    zero_at(img, 0x3c, 40);
    zero_at(img, 0xbc, 0x2e * 4);
    std_reset_score(&d);
    expect_image(&d, img);
    /* the clock half and the strings' later bytes are untouched */
    CK(d.clock_enabled == (int32_t)0xa5a5a5a5 && d.clock_ready == (int32_t)0xa5a5a5a5 && d.minutes == (int32_t)0xa5a5a5a5);
    CK((uint8_t)d.score_str[1] == FILL && (uint8_t)d.prev_score_str[9] == FILL);
    /* from a live state: only the first byte of each string is cleared, the rest of the old text stays */
    std_fill(&d);
    for (i = 0; i < STD_DIGITS; ++i) d.score_w[i] = (int32_t)(i + 1);
    d.score = 1234;
    d.score_enabled = 1;
    d.score_ready = 1;
    memcpy(d.score_str, "1234", 5);
    memcpy(d.prev_score_str, "999", 4);
    memcpy(img, &d, sizeof img);
    zero_at(img, 0x4, 4);
    zero_at(img, 0xc, 4);
    zero_at(img, 0x23c, 4);
    zero_at(img, 0x25c, 1);
    zero_at(img, 0x27a, 1);
    zero_at(img, 0x14, 40);
    zero_at(img, 0x3c, 40);
    zero_at(img, 0xbc, 0x2e * 4);
    std_reset_score(&d);
    expect_image(&d, img);
    CK(d.score_str[1] == '2' && d.prev_score_str[1] == '9');
    return g_failed;
}

static int test_std_reset_clock(void)
{
    StdDisplay d;
    uint8_t img[sizeof(StdDisplay)];

    CK(offsetof(StdDisplay, clock_block) + OBJ_BASE == 0x174 && offsetof(StdDisplay, colon_w) + OBJ_BASE == 0xb4);
    CK(offsetof(StdDisplay, minutes_str) + OBJ_BASE == 0x248 && offsetof(StdDisplay, prev_seconds_str) + OBJ_BASE == 0x270);
    std_fill(&d);
    memset(img, FILL, sizeof img);
    zero_at(img, 0x8, 4);
    zero_at(img, 0x10, 4);
    zero_at(img, 0xb4, 4);
    zero_at(img, 0xb8, 4);
    zero_at(img, 0x240, 4);
    zero_at(img, 0x244, 4);
    zero_at(img, 0x248, 1);
    zero_at(img, 0x252, 1);
    zero_at(img, 0x266, 1);
    zero_at(img, 0x270, 1);
    zero_at(img, 0x64, 40);
    zero_at(img, 0x8c, 40);
    zero_at(img, 0x174, 0x32 * 4);
    std_reset_clock(&d);
    expect_image(&d, img);
    CK(d.score_enabled == (int32_t)0xa5a5a5a5 && d.score_ready == (int32_t)0xa5a5a5a5 && d.score == (int32_t)0xa5a5a5a5);
    CK((uint8_t)d.minutes_str[1] == FILL && (uint8_t)d.prev_seconds_str[9] == FILL);
    return g_failed;
}

static int test_std_enable(void)
{
    static const int32_t values[] = {0, 1, -1, 2, (int32_t)0x80000000, 0x12345678};
    size_t i;
    for (i = 0; i < sizeof values / sizeof values[0]; ++i) {
        StdDisplay d, before;
        std_fill(&d);
        before = d;
        std_enable_score(&d, values[i]); /* 0x446532: [this+4] := arg */
        before.score_enabled = values[i];
        CK(memcmp(&d, &before, sizeof d) == 0);
        std_fill(&d);
        before = d;
        std_enable_clock(&d, values[i]); /* 0x446548: [this+8] := arg */
        before.clock_enabled = values[i];
        CK(memcmp(&d, &before, sizeof d) == 0);
    }
    CK(offsetof(StdDisplay, score_enabled) + OBJ_BASE == 4 && offsetof(StdDisplay, clock_enabled) + OBJ_BASE == 8);
    return g_failed;
}

static int test_std_enable_score(void)
{
    return test_std_enable();
}

static int test_std_enable_clock(void)
{
    return test_std_enable();
}

static int test_std_set_score(void)
{
    static const struct {
        int32_t score;
        const char *text;
    } ok[] = {{0, "0"}, {7, "7"}, {10, "10"}, {1234, "1234"}, {65536, "65536"}, {99999999, "99999999"}};
    static const int32_t refused[] = {-1, -99999999, 100000000, 2147483647};
    size_t i;
    for (i = 0; i < sizeof ok / sizeof ok[0]; ++i) {
        StdDisplay d;
        uint8_t img[sizeof(StdDisplay)];
        const size_t n = strlen(ok[i].text) + 1;
        std_fill(&d);
        memset(img, FILL, sizeof img);
        memcpy(img + (0x23c - OBJ_BASE), &ok[i].score, 4);     /* score dword */
        memcpy(img + (0x25c - OBJ_BASE), ok[i].text, n);       /* sprintf "%d" with its NUL; later bytes stay */
        CK(std_set_score(&d, ok[i].score) == STD_OK);
        expect_image(&d, img);
    }
    /* Native-only guard: the original has none and would store the value and format it; the native refuses before any store. */
    for (i = 0; i < sizeof refused / sizeof refused[0]; ++i) {
        StdDisplay d, before;
        std_fill(&d);
        before = d;
        CK(std_set_score(&d, refused[i]) == STD_ERR_BOUNDS);
        CK(memcmp(&d, &before, sizeof d) == 0);
    }
    return g_failed;
}

static int test_std_set_clock(void)
{
    static const struct {
        int32_t m, s;
        const char *mt, *st;
    } ok[] = {{0, 0, "00", "00"}, {5, 9, "05", "09"}, {12, 34, "12", "34"}, {59, 59, "59", "59"}, {99, 99, "99", "99"},
              {0, 99, "00", "99"}, {99, 0, "99", "00"}, {7, 10, "07", "10"}};
    static const int32_t pairs[][2] = {{-1, 0}, {0, -1}, {100, 0}, {0, 100}, {-5, 120}, {2147483647, 5}};
    size_t i;
    for (i = 0; i < sizeof ok / sizeof ok[0]; ++i) {
        StdDisplay d;
        uint8_t img[sizeof(StdDisplay)];
        std_fill(&d);
        memset(img, FILL, sizeof img);
        memcpy(img + (0x240 - OBJ_BASE), &ok[i].m, 4);
        memcpy(img + (0x244 - OBJ_BASE), &ok[i].s, 4);
        memcpy(img + (0x248 - OBJ_BASE), ok[i].mt, 3);         /* sprintf "%02d" with its NUL */
        memcpy(img + (0x252 - OBJ_BASE), ok[i].st, 3);
        CK(std_set_clock(&d, ok[i].m, ok[i].s) == STD_OK);
        expect_image(&d, img);
    }
    /* Native-only guard (either value outside 0..99), refused before any store. */
    for (i = 0; i < sizeof pairs / sizeof pairs[0]; ++i) {
        StdDisplay d, before;
        std_fill(&d);
        before = d;
        CK(std_set_clock(&d, pairs[i][0], pairs[i][1]) == STD_ERR_BOUNDS);
        CK(memcmp(&d, &before, sizeof d) == 0);
    }
    return g_failed;
}

/* ---- typing quiz (raw 0xf5) ----------------------------------------------------------------------------------------------- */

typedef struct {
    int calls;
    int16_t slot;
} Dirty;

static int dirty_cb(void *context, int16_t slot)
{
    Dirty *d = (Dirty *)context;
    d->calls += 1;
    d->slot = slot;
    return 0;
}

static int test_tqz_world_new_game(void)
{
    TqzWorld w, before;
    memset(&w, FILL, sizeof w);
    w.played_5a4c0a = 1;
    w.best_5a4c0e = 321;
    before = w;
    tqz_world_new_game(&w);
    before.played_5a4c0a = 0; /* dword [0x5a4c0a] := 0 */
    before.best_5a4c0e = 0;   /* word [0x5a4c0e] := 0 */
    CK(memcmp(&w, &before, sizeof w) == 0);
    CK(w.start_flag_5bb1ca == (int32_t)0xa5a5a5a5 && w.display.score == (int32_t)0xa5a5a5a5);
    w.played_5a4c0a = -1;
    w.best_5a4c0e = -1;
    tqz_world_new_game(&w);
    CK(w.played_5a4c0a == 0 && w.best_5a4c0e == 0);
    return g_failed;
}

static int test_tqz_invalidate(void)
{
    static const struct {
        int32_t active;
        int16_t slot;
        int calls;
    } cases[] = {{0, 5, 0},    {0, -1, 0},     {1, -1, 0},     {1, 5, 1},      {1, 0, 1},       {-1, 63, 1},
                 {0x100, 24, 1}, {1, -2, 1},   {1, 32767, 1},  {1, -32768, 1}, {0, 0, 0}};
    size_t i;
    for (i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        TqzObject o, before;
        TqzHost host;
        Dirty dirty = {0, 0x5a5a};
        memset(&o, 0x5c, sizeof o);
        o.active = cases[i].active;
        o.slot = cases[i].slot;
        before = o;
        memset(&host, 0, sizeof host);
        host.context = &dirty;
        host.mark_dirty = dirty_cb;
        CK(tqz_invalidate(&o, &host) == TQZ_OK);
        CK(dirty.calls == cases[i].calls);
        if (cases[i].calls) CK(dirty.slot == cases[i].slot);
        CK(memcmp(&o, &before, sizeof o) == 0);
    }
    return g_failed;
}

/* The pseudocode of 0x437ea1 is one conjunction of "!=" / range tests on a signed char (the negative constants are signed
 * compares); it returns 0 when every test holds and 1 otherwise. */
static int ref_437ea1(char c)
{
    const int none = (c < 'A' || 'Z' < c) && (c < 'a' || 'z' < c) && (c < '0' || '9' < c) && c != '\b' && c != '\r' &&
                     c != ' ' && c != '.' && c != ',' && c != '?' && c != '!' && c != '/' && c != '$' && c != '(' && c != ')' &&
                     c != '&' && c != ':' && c != ';' && c != '+' && c != '%' && c != '=' && c != '-' && c != -0x20 &&
                     c != -0x19 && c != -0x18 && c != -0x17 && c != -0x16 && c != -0x15 && c != -0xc && c != -0x40 &&
                     c != -0x1e && c != -0x12 && c != -7 && c != -0x3c && c != -0x1c && c != -0x2a && c != -10 && c != -0x24 &&
                     c != -4 && c != -0x5f && c != -0x41 && c != -0x2f && c != -0xf && c != -0x37 && c != -0x1f &&
                     c != -0x13 && c != -0xd && c != -6 && c != -0x21;
    return none ? 0 : 1;
}

static int test_pwd_char_accepted(void)
{
    int c, count = 0;
    /* spot checks that do not depend on the ladder transcription */
    CK(pwd_char_accepted('A') && pwd_char_accepted('Z') && pwd_char_accepted('a') && pwd_char_accepted('z'));
    CK(pwd_char_accepted('0') && pwd_char_accepted('9') && pwd_char_accepted('\b') && pwd_char_accepted('\r'));
    CK(pwd_char_accepted(' ') && pwd_char_accepted('-') && pwd_char_accepted('%'));
    CK(pwd_char_accepted((int8_t)0xe0) && pwd_char_accepted((int8_t)0xdf) && pwd_char_accepted((int8_t)0xa1));
    CK(!pwd_char_accepted('@') && !pwd_char_accepted('[') && !pwd_char_accepted('`') && !pwd_char_accepted('{'));
    CK(!pwd_char_accepted('\n') && !pwd_char_accepted(0));
    CK(!pwd_char_accepted('\'') && !pwd_char_accepted('"') && !pwd_char_accepted('#') && !pwd_char_accepted('_'));
    CK(!pwd_char_accepted((int8_t)0x80) && !pwd_char_accepted((int8_t)0xff) && !pwd_char_accepted((int8_t)0xd7));
    /* all 256 bytes against the transcribed ladder */
    for (c = -128; c < 128; ++c) {
        const int expected = ref_437ea1((char)c);
        if (pwd_char_accepted((int8_t)c) != expected && !g_failed) {
            g_failed = 1;
            snprintf(g_msg, sizeof g_msg, "char %d: native %d original %d", c, pwd_char_accepted((int8_t)c), expected);
        }
        count += expected;
    }
    CK(count == 62 + 18 + 27); /* letters and digits, 18 punctuation bytes (incl. \b \r), 27 accented bytes */
    return g_failed;
}

static int test_tqz_key(void)
{
    /* 0x4b8193: gate on active, state, pending key and row phase; the stored byte is the character. */
    static const struct {
        int32_t active, state, pending;
        uint32_t phase;
        int stores;
    } gates[] = {{1, 0, 0, 1, 1}, {0, 0, 0, 1, 0}, {1, 1, 0, 1, 0}, {1, -1, 0, 1, 0}, {1, 0, 1, 1, 0},
                 {1, 0, 0, 0, 0}, {1, 0, 0, 2, 0}, {1, 0, 0, 3, 0}, {-1, 0, 0, 1, 1}, {1, 0, 0x100, 1, 0}};
    size_t i;
    int c;
    for (i = 0; i < sizeof gates / sizeof gates[0]; ++i) {
        TqzObject o, before;
        memset(&o, 0x5c, sizeof o);
        o.active = gates[i].active;
        o.state = gates[i].state;
        o.key_pending = gates[i].pending;
        o.key_char = 0x17;
        before = o;
        CK(tqz_key(&o, gates[i].phase, 'q') == gates[i].stores);
        if (gates[i].stores) {
            before.key_char = 'q';
            before.key_pending = 1;
        }
        CK(memcmp(&o, &before, sizeof o) == 0);
    }
    /* every character against the filter 0x437ea1: stored only when accepted */
    for (c = -128; c < 128; ++c) {
        TqzObject o, before;
        const int accepted = ref_437ea1((char)c);
        memset(&o, 0x5c, sizeof o);
        o.active = 1;
        o.state = 0;
        o.key_pending = 0;
        o.key_char = 0x17;
        before = o;
        CK(tqz_key(&o, 1u, (int8_t)c) == accepted);
        if (accepted) {
            before.key_char = (uint8_t)c;
            before.key_pending = 1;
        }
        if (memcmp(&o, &before, sizeof o) != 0 && !g_failed) {
            g_failed = 1;
            snprintf(g_msg, sizeof g_msg, "char %d: object differs (accepted %d)", c, accepted);
        }
    }
    return g_failed;
}

static int test_tqz_click(void)
{
    /* 0x4b82cd: active, finishing (+0x20), state (+0x10), row phase 1, candidate 0x5c39e5 == 0x27eb -> phase 2. */
    static const struct {
        int32_t active, finishing, state;
        uint32_t phase;
        int32_t candidate;
        int fires;
    } cases[] = {{1, 0, 0, 1, 0x27eb, 1},  {0, 0, 0, 1, 0x27eb, 0},  {1, 1, 0, 1, 0x27eb, 0}, {1, -1, 0, 1, 0x27eb, 0},
                 {1, 0, 1, 1, 0x27eb, 0},  {1, 0, 0, 0, 0x27eb, 0},  {1, 0, 0, 2, 0x27eb, 0}, {1, 0, 0, 1, 0x27ea, 0},
                 {1, 0, 0, 1, 0x27ec, 0},  {1, 0, 0, 1, -1, 0},      {1, 0, 0, 1, 0, 0},      {-1, 0, 0, 1, 0x27eb, 1},
                 {1, 0, 0, 7, 0x27eb, 0},  {1, 0, 0, 1, 0x127eb, 0}};
    size_t i;
    for (i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        TqzObject o, before;
        uint32_t phase_out = 0xdeadbeefu;
        memset(&o, 0x5c, sizeof o);
        o.active = cases[i].active;
        o.finishing = cases[i].finishing;
        o.state = cases[i].state;
        before = o;
        CK(tqz_click(&o, cases[i].phase, cases[i].candidate, &phase_out) == cases[i].fires);
        CK(phase_out == (cases[i].fires ? 2u : cases[i].phase));
        CK(memcmp(&o, &before, sizeof o) == 0);
    }
    return g_failed;
}

static int test_char_allowed(void)
{
    uint8_t body[TQZ_BODY_BYTES];

    /* digits flag clear, no extras: letters only */
    memset(body, 0, sizeof body);
    CK(char_allowed(body, 'A') && char_allowed(body, 'Z') && char_allowed(body, 'a') && char_allowed(body, 'z'));
    CK(!char_allowed(body, 0x40) && !char_allowed(body, 0x5b) && !char_allowed(body, 0x60) && !char_allowed(body, 0x7b));
    CK(!char_allowed(body, '0') && !char_allowed(body, '9') && !char_allowed(body, ' ') && !char_allowed(body, 0));
    CK(!char_allowed(body, 0xe0) && !char_allowed(body, 0xff));
    /* digits flag set (any nonzero byte): digits 0x30..0x39 allowed */
    body[0x432] = 1;
    CK(char_allowed(body, '0') && char_allowed(body, '5') && char_allowed(body, '9'));
    CK(!char_allowed(body, 0x2f) && !char_allowed(body, 0x3a) && char_allowed(body, 'A'));
    body[0x432] = 2;
    CK(char_allowed(body, '7') && !char_allowed(body, 0x3a));
    body[0x432] = 0xff;
    CK(char_allowed(body, '7') && !char_allowed(body, 0x2f));
    /* extras: only when the first extra byte is nonzero; 30 bytes are searched */
    memset(body, 0, sizeof body);
    body[0x434] = '#';
    body[0x434 + 7] = 0xe9;
    body[0x434 + 29] = '$'; /* last searched */
    body[0x434 + 30] = '%'; /* first byte past the table: not searched */
    CK(char_allowed(body, '#') && char_allowed(body, 0xe9) && char_allowed(body, '$'));
    CK(!char_allowed(body, '%') && !char_allowed(body, '!') && !char_allowed(body, '0'));
    CK(char_allowed(body, 0)); /* the table holds zero bytes after its first entry, and the original compares them too */
    /* first extra byte zero: the table is skipped even when later entries are set */
    memset(body, 0, sizeof body);
    body[0x434 + 5] = '#';
    CK(!char_allowed(body, '#') && !char_allowed(body, 0));
    return g_failed;
}

/* ---- the scene restore saver ---------------------------------------------------------------------------------------------- */

static int test_scene_restore_slot_save(void)
{
    SceneRestoreSlot slot, before;
    SceneStackCurrent cur;

    memset(&slot, 0x33, sizeof slot);
    memset(&cur, 0x44, sizeof cur);
    cur.scene_5bb57b = 0x12345678; /* the dword global: the saver reads its low word */
    cur.scene_5bb57f = (int32_t)0x9abcdef0;
    cur.word_5bb50b = (int16_t)0x7001;
    cur.word_5bb593 = (int16_t)0x8002;
    cur.dword_5bb5a7 = (int32_t)0xa1b2c3d4;
    cur.dword_5bb5ab = 0x11111111; /* overwritten in the original by the next store */
    cur.dword_5bb5af = (int32_t)0xdeadbeef;
    before = slot;
    scene_restore_slot_save(&slot, &cur, 0x7fff0001); /* only the low word of the stack argument is stored */
    before.marker_5c3a1b = 0x5678;
    before.scene_5c3a1d = (int16_t)0xdef0;
    before.word_5c3a1f = (int16_t)0x7001;
    before.word_5c3a21 = (int16_t)0x8002;
    before.word_5c3a23 = 1;
    before.dword_5c3a25 = (int32_t)0xa1b2c3d4;
    before.dword_5c3a29 = (int32_t)0xdeadbeef;
    /* dword_5c3a2d is never written */
    CK(slot.marker_5c3a1b == before.marker_5c3a1b && slot.scene_5c3a1d == before.scene_5c3a1d);
    CK(slot.word_5c3a1f == before.word_5c3a1f && slot.word_5c3a21 == before.word_5c3a21 && slot.word_5c3a23 == 1);
    CK(slot.dword_5c3a25 == before.dword_5c3a25 && slot.dword_5c3a29 == before.dword_5c3a29);
    CK(slot.dword_5c3a2d == 0x33333333);
    /* the intermediate store of 0x5bb5ab is not visible: changing it changes nothing */
    {
        SceneRestoreSlot again;
        memset(&again, 0x33, sizeof again);
        cur.dword_5bb5ab = 0x22222222;
        scene_restore_slot_save(&again, &cur, 0x7fff0001);
        CK(again.dword_5c3a29 == slot.dword_5c3a29);
    }
    /* negative argument, low word 0xffff */
    scene_restore_slot_save(&slot, &cur, -1);
    CK(slot.word_5c3a23 == -1);
    scene_restore_slot_save(&slot, &cur, 2);
    CK(slot.word_5c3a23 == 2);
    scene_restore_slot_save(&slot, &cur, 0x10000);
    CK(slot.word_5c3a23 == 0);
    return g_failed;
}

/* ---- the 0xd0 / 0xd1 invalidate methods ----------------------------------------------------------------------------------- */

static int test_d1_invalidate(void)
{
    static const struct {
        int32_t active;
        int16_t slot;
        int calls;
    } cases[] = {{0, 5, 0}, {0, -1, 0}, {1, -1, 0}, {1, 5, 1}, {1, 0, 1}, {-1, 63, 1}, {0x100, 24, 1}, {1, -2, 1}, {1, 32767, 1}};
    size_t i;
    for (i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        D1Object o, before;
        D1Host host;
        Dirty dirty = {0, 0x5a5a};
        memset(&o, 0x5c, sizeof o);
        o.active = cases[i].active;
        o.slot = cases[i].slot;
        before = o;
        memset(&host, 0, sizeof host);
        host.context = &dirty;
        host.mark_dirty = dirty_cb;
        CK(d1_invalidate(&o, &host) == D1_OK);
        CK(dirty.calls == cases[i].calls);
        if (cases[i].calls) CK(dirty.slot == cases[i].slot);
        CK(memcmp(&o, &before, sizeof o) == 0);
    }
    return g_failed;
}

static int test_d0_invalidate(void)
{
    static const struct {
        int32_t active;
        int16_t slot;
        int calls;
    } cases[] = {{0, 5, 0}, {0, -1, 0}, {1, -1, 0}, {1, 5, 1}, {1, 0, 1}, {-1, 63, 1}, {0x100, 24, 1}, {1, -2, 1}, {1, 32767, 1}};
    size_t i;
    for (i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        D0Object o, before;
        D0Host host;
        Dirty dirty = {0, 0x5a5a};
        memset(&o, 0x5c, sizeof o);
        o.active = cases[i].active;
        o.slot = cases[i].slot;
        before = o;
        memset(&host, 0, sizeof host);
        host.context = &dirty;
        host.mark_dirty = dirty_cb;
        CK(d0_invalidate(&o, &host) == D0_OK);
        CK(dirty.calls == cases[i].calls);
        if (cases[i].calls) CK(dirty.slot == cases[i].slot);
        CK(memcmp(&o, &before, sizeof o) == 0);
    }
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

int main(void)
{
    int failures = 0;
    failures += run_one("test_std_reset_score", test_std_reset_score);
    failures += run_one("test_std_reset_clock", test_std_reset_clock);
    failures += run_one("test_std_enable_score", test_std_enable_score);
    failures += run_one("test_std_enable_clock", test_std_enable_clock);
    failures += run_one("test_std_set_score", test_std_set_score);
    failures += run_one("test_std_set_clock", test_std_set_clock);
    failures += run_one("test_tqz_world_new_game", test_tqz_world_new_game);
    failures += run_one("test_tqz_invalidate", test_tqz_invalidate);
    failures += run_one("test_tqz_key", test_tqz_key);
    failures += run_one("test_tqz_click", test_tqz_click);
    failures += run_one("test_char_allowed", test_char_allowed);
    failures += run_one("test_pwd_char_accepted", test_pwd_char_accepted);
    failures += run_one("test_scene_restore_slot_save", test_scene_restore_slot_save);
    failures += run_one("test_d1_invalidate", test_d1_invalidate);
    failures += run_one("test_d0_invalidate", test_d0_invalidate);
    return failures;
}
