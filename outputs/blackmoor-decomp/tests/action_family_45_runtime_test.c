/* RT-38 unit tests of raw 0x45 (timer control): the session binding. Prints "PASS <name>" / "FAIL <name>: <message>"; the exit
 * status is the failure count. Fixtures are synthetic (no original bytes). tests/test_action_family_45_runtime.py builds and
 * runs this plainly, under ASan/UBSan and under source mutations. */
#include <stdio.h>
#include <string.h>

#include "session_bindings_a45.h"

static int g_failed;
static char g_msg[160];
#define CHECK(cond)                                                       \
    do {                                                                  \
        if (!(cond) && !g_failed) {                                       \
            g_failed = 1;                                                 \
            snprintf(g_msg, sizeof g_msg, "line %d: %s", __LINE__, #cond); \
        }                                                                 \
    } while (0)

#define MAX_BODY (ACTION_FAMILY_45_PREFIX_BYTES + 4u * ACTION_FAMILY_45_MAX_ENTRIES)

typedef struct {
    uint8_t records[SESSION_TIMER_RECORD_COUNT][SESSION_TIMER_RECORD_BYTES];
    int16_t words[32768];
    unsigned asked, word_asked;
} Host;

static uint8_t *time_record(void *context, unsigned index)
{
    Host *h = (Host *)context;
    ++h->asked;
    return index < SESSION_TIMER_RECORD_COUNT ? h->records[index] : NULL;
}

static int variable_word(void *context, int16_t index, int16_t *value)
{
    Host *h = (Host *)context;
    ++h->word_asked;
    if (index < 5000) return 0;
    *value = h->words[index];
    return 1;
}

static SessionA45Binding *make(Host *host, int with_records, int with_words)
{
    SessionA45Host h;
    memset(&h, 0, sizeof h);
    h.context = host;
    h.time_record = with_records ? time_record : NULL;
    h.variable_word = with_words ? variable_word : NULL;
    return session_a45_create(&h);
}

static void put16(uint8_t *p, int v)
{
    p[0] = (uint8_t)v;
    p[1] = (uint8_t)(v >> 8);
}

static uint32_t get32(const uint8_t *p)
{
    return (uint32_t)p[0] | ((uint32_t)p[1] << 8) | ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
}

static void put32(uint8_t *p, uint32_t v)
{
    p[0] = (uint8_t)v;
    p[1] = (uint8_t)(v >> 8);
    p[2] = (uint8_t)(v >> 16);
    p[3] = (uint8_t)(v >> 24);
}

/* A raw 0x45 body: timer `record`, sub-case `mode`, hours/minutes/seconds words and `count` entries; returns its length. */
static size_t build(uint8_t *body, int record, int mode, int hours, int minutes, int seconds, int count)
{
    unsigned i;
    memset(body, 0, MAX_BODY);
    put16(body + SESSION_A45_BODY_RECORD, record);
    put16(body + SESSION_A45_BODY_MODE, mode);
    put16(body + SESSION_A45_BODY_HOURS, hours);
    put16(body + SESSION_A45_BODY_MINUTES, minutes);
    put16(body + SESSION_A45_BODY_SECONDS, seconds);
    for (i = 0; i < 49u; ++i) body[SESSION_A45_BODY_NAME + i] = (uint8_t)(0x10 + i);
    for (i = 0; i < 33u; ++i) body[SESSION_A45_BODY_TEXT + i] = (uint8_t)(0x40 + i);
    for (i = 0; i < 100u; ++i) body[SESSION_A45_BODY_PAYLOAD + i] = (uint8_t)(0x70 + i);
    put16(body + SESSION_A45_BODY_COUNT, count);
    for (i = 0; i < 4u * (unsigned)(count > 0 ? count : 0); ++i) body[SESSION_A45_BODY_ENTRIES + i] = (uint8_t)(0xc0 + i);
    return ACTION_FAMILY_45_PREFIX_BYTES + 4u * (size_t)(count > 0 ? count : 0);
}

typedef struct {
    int status;
    SceneActionHandlerResult out;
} Visit;

static Visit visit(SessionA45Binding *b, const uint8_t *body, size_t length, unsigned phase)
{
    Visit v;
    SceneActionInfo info;
    SceneActionRuntimeState before;
    memset(&info, 0, sizeof info);
    info.type = SESSION_A45_TYPE;
    info.subtype = 1u;
    info.typed_body = body;
    info.typed_body_length = length;
    before.completed = 0u;
    before.phase = phase;
    v.out.disposition = SCENE_ACTION_HANDLER_PENDING;
    v.out.phase = 0xdeadu;
    v.status = session_a45_handler(b, 0u, &info, &before, &v.out);
    return v;
}

static int done(Visit v, unsigned phase)
{
    return v.status == SCENE_ACTION_HANDLER_OK && v.out.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED && v.out.phase == phase;
}

static int pending(Visit v, unsigned phase)
{
    return v.status == SCENE_ACTION_HANDLER_OK && v.out.disposition == SCENE_ACTION_HANDLER_PENDING && v.out.phase == phase;
}

static void fill(Host *h, uint8_t value)
{
    memset(h->records, value, sizeof h->records);
}

static void modes_0_1_2(void)
{
    uint8_t body[MAX_BODY];
    Host h;
    SessionA45Binding *b;
    uint8_t want[SESSION_TIMER_RECORD_BYTES];
    size_t n;
    memset(&h, 0, sizeof h);
    b = make(&h, 1, 1);
    fill(&h, 0x5a);
    n = build(body, 4, 1, 9, 9, 9, 0);
    CHECK(done(visit(b, body, n, 3u), 3u));                          /* mode 1: only the state dword */
    memset(want, 0x5a, sizeof want);
    put32(want, 1u);
    CHECK(memcmp(h.records[4], want, sizeof want) == 0);
    n = build(body, 4, 2, 9, 9, 9, 0);
    CHECK(done(visit(b, body, n, 8u), 8u));
    put32(want, 2u);
    CHECK(memcmp(h.records[4], want, sizeof want) == 0);
    n = build(body, 4, 0, 9, 9, 9, 0);                               /* mode 0: the 0x433bd2 clear */
    CHECK(done(visit(b, body, n, 1u), 1u));
    session_timer_record_clear(want);
    CHECK(memcmp(h.records[4], want, sizeof want) == 0);
    CHECK(h.records[3][0] == 0x5a && h.records[5][0] == 0x5a && h.records[3][0x105] == 0x5a && h.records[5][0x105] == 0x5a);
    CHECK(session_a45_completed(b) == 3ul && session_a45_pending(b) == 0ul);
    session_a45_destroy(b);
}

static void add_and_subtract(void)
{
    uint8_t body[MAX_BODY];
    Host h;
    SessionA45Binding *b;
    uint8_t *r;
    size_t n;
    unsigned state;
    memset(&h, 0, sizeof h);
    b = make(&h, 1, 1);
    r = h.records[2];
    /* the state gate: 1, 2, 5 and 6 count, everything else leaves the row pending and the record unchanged */
    for (state = 0u; state < 9u; ++state) {
        int counts = state == 1u || state == 2u || state == 5u || state == 6u;
        fill(&h, 0);
        put32(r, state);
        put32(r + SESSION_TIMER_SECONDS, 10u);
        n = build(body, 2, 3, 0, 0, 5, 0);
        if (counts) {
            CHECK(done(visit(b, body, n, 2u), 2u));
            CHECK(get32(r + SESSION_TIMER_SECONDS) == 15u && get32(r + SESSION_TIMER_ELAPSED_MS) == 15000u);
        } else {
            CHECK(pending(visit(b, body, n, 2u), 2u));
            CHECK(get32(r + SESSION_TIMER_SECONDS) == 10u && get32(r + SESSION_TIMER_ELAPSED_MS) == 0u);
        }
        n = build(body, 2, 4, 0, 0, 5, 0);
        put32(r + SESSION_TIMER_SECONDS, 10u);
        put32(r + SESSION_TIMER_ELAPSED_MS, 0u);
        if (counts) {
            CHECK(done(visit(b, body, n, 2u), 2u));
            CHECK(get32(r + SESSION_TIMER_SECONDS) == 5u && get32(r + SESSION_TIMER_ELAPSED_MS) == 5000u);
        } else {
            CHECK(pending(visit(b, body, n, 2u), 2u));
            CHECK(get32(r + SESSION_TIMER_SECONDS) == 10u);
        }
    }
    /* all three fields, signed body words, millisecond sum */
    fill(&h, 0);
    put32(r, 1u);
    put32(r + SESSION_TIMER_HOURS, 1u);
    put32(r + SESSION_TIMER_MINUTES, 20u);
    put32(r + SESSION_TIMER_SECONDS, 30u);
    n = build(body, 2, 3, 2, -5, 4000, 0);
    CHECK(done(visit(b, body, n, 0u), 0u));
    CHECK(get32(r + SESSION_TIMER_HOURS) == 3u && get32(r + SESSION_TIMER_MINUTES) == 15u && get32(r + SESSION_TIMER_SECONDS) == 4030u);
    CHECK(get32(r + SESSION_TIMER_ELAPSED_MS) == 3u * 3600000u + 15u * 60000u + 4030u * 1000u);
    /* no clamping on addition: a negative result stays negative and the sum wraps */
    n = build(body, 2, 3, -10, -100, -32768, 0);
    CHECK(done(visit(b, body, n, 0u), 0u));
    CHECK((int32_t)get32(r + SESSION_TIMER_HOURS) == -7 && (int32_t)get32(r + SESSION_TIMER_MINUTES) == -85);
    CHECK((int32_t)get32(r + SESSION_TIMER_SECONDS) == 4030 - 32768);
    CHECK(get32(r + SESSION_TIMER_ELAPSED_MS) == (uint32_t)(-7) * 3600000u + (uint32_t)(-85) * 60000u + (uint32_t)(4030 - 32768) * 1000u);
    /* subtraction clamps each field at zero, independently, and the sum uses the clamped values */
    put32(r + SESSION_TIMER_HOURS, 5u);
    put32(r + SESSION_TIMER_MINUTES, 2u);
    put32(r + SESSION_TIMER_SECONDS, 50u);
    n = build(body, 2, 4, 1, 3, 20, 0);
    CHECK(done(visit(b, body, n, 0u), 0u));
    CHECK(get32(r + SESSION_TIMER_HOURS) == 4u && get32(r + SESSION_TIMER_MINUTES) == 0u && get32(r + SESSION_TIMER_SECONDS) == 30u);
    CHECK(get32(r + SESSION_TIMER_ELAPSED_MS) == 4u * 3600000u + 30000u);
    n = build(body, 2, 4, 9, 9, 99, 0);
    CHECK(done(visit(b, body, n, 0u), 0u));
    CHECK(get32(r + SESSION_TIMER_HOURS) == 0u && get32(r + SESSION_TIMER_MINUTES) == 0u && get32(r + SESSION_TIMER_SECONDS) == 0u);
    CHECK(get32(r + SESSION_TIMER_ELAPSED_MS) == 0u);
    session_a45_destroy(b);
}

static void loader_word_table(void)
{
    uint8_t body[MAX_BODY];
    Host h;
    SessionA45Binding *b, *without;
    uint8_t *r, snapshot[sizeof h.records];
    size_t n;
    memset(&h, 0, sizeof h);
    h.words[5000] = 300;
    h.words[5001] = -60;
    h.words[32767] = 7;
    b = make(&h, 1, 1);
    r = h.records[6];
    fill(&h, 0);
    put32(r, 1u);
    put32(r + SESSION_TIMER_SECONDS, 1000u);
    n = build(body, 6, 3, 1, 1, 5000, 0);                            /* 5000 is the first table index (signed compare) */
    CHECK(done(visit(b, body, n, 0u), 0u) && h.word_asked == 1u);
    CHECK(get32(r + SESSION_TIMER_SECONDS) == 1300u && get32(r + SESSION_TIMER_HOURS) == 1u && get32(r + SESSION_TIMER_MINUTES) == 1u);
    n = build(body, 6, 4, 0, 0, 5001, 0);                            /* the table word is signed: subtracting -60 adds 60 */
    CHECK(done(visit(b, body, n, 0u), 0u));
    CHECK(get32(r + SESSION_TIMER_SECONDS) == 1360u);
    n = build(body, 6, 3, 0, 0, 4999, 0);                            /* 4999 is a plain value, no lookup */
    h.word_asked = 0u;
    CHECK(done(visit(b, body, n, 0u), 0u) && h.word_asked == 0u && get32(r + SESSION_TIMER_SECONDS) == 1360u + 4999u);
    /* a word the host cannot source: unsupported before any effect (hours and minutes are not applied either) */
    {
        SessionA45Host sh;
        memset(&sh, 0, sizeof sh);
        sh.context = &h;
        sh.time_record = time_record;
        without = session_a45_create(&sh);                           /* no variable_word hook at all */
    }
    memset(h.records, 0x11, sizeof h.records);
    put32(r, 1u);
    memcpy(snapshot, h.records, sizeof snapshot);
    n = build(body, 6, 3, 2, 2, 5000, 0);
    CHECK(visit(without, body, n, 4u).status == SCENE_ACTION_HANDLER_UNSUPPORTED);
    CHECK(memcmp(h.records, snapshot, sizeof snapshot) == 0);
    n = build(body, 6, 5, 2, 2, 5000, 0);
    CHECK(visit(without, body, n, 4u).status == SCENE_ACTION_HANDLER_UNSUPPORTED);
    CHECK(memcmp(h.records, snapshot, sizeof snapshot) == 0);
    CHECK(strstr(session_a45_failure(without), "0x5adb81") != NULL);
    n = build(body, 6, 3, 2, 2, 100, 0);                             /* a plain value needs no hook */
    CHECK(done(visit(without, body, n, 4u), 4u));
    session_a45_destroy(without);
    session_a45_destroy(b);
}

static void configure_modes(void)
{
    uint8_t body[MAX_BODY], want[SESSION_TIMER_RECORD_BYTES];
    Host h;
    SessionA45Binding *b;
    uint8_t *r;
    size_t n;
    unsigned mode, i, count;
    memset(&h, 0, sizeof h);
    b = make(&h, 1, 1);
    r = h.records[7];
    for (mode = 5u; mode <= 6u; ++mode) {
        for (count = 0u; count <= 10u; count += 5u) {
            n = build(body, 7, (int)mode, 2, 3, 4, (int)count);
            fill(&h, 0x9c);
            put32(r, 1u);
            memcpy(want, r, sizeof want);
            put32(want + SESSION_TIMER_LIMIT_HOURS, 2u);
            put32(want + SESSION_TIMER_LIMIT_MINUTES, 3u);
            put32(want + SESSION_TIMER_LIMIT_SECONDS, 4u);
            put32(want + SESSION_TIMER_LIMIT_MS, 2u * 3600000u + 3u * 60000u + 4000u);
            memcpy(want + 0x28, body + SESSION_A45_BODY_NAME, 49u);
            memcpy(want + 0x59, body + SESSION_A45_BODY_TEXT, 33u);
            memcpy(want + 0x7a, body + SESSION_A45_BODY_PAYLOAD, 100u);
            for (i = 0u; i < 10u; ++i) {
                want[0xde + 4u * i] = 0xff;
                want[0xde + 4u * i + 1u] = 0xff;                      /* words only: the high word keeps its old bytes */
            }
            for (i = 0u; i < count; ++i) memcpy(want + 0xde + 4u * i, body + SESSION_A45_BODY_ENTRIES + 4u * i, 4u);
            put32(want + SESSION_TIMER_RESERVED_14, 0u);
            put32(want, mode);
            CHECK(done(visit(b, body, n, 9u), 9u));
            CHECK(memcmp(r, want, sizeof want) == 0);
            CHECK(h.records[6][0] == 0x9c && h.records[8][0] == 0x9c && h.records[6][0x105] == 0x9c && h.records[8][0x105] == 0x9c);
            /* a second visit finds the state 5/6 and does nothing: only state 1 is accepted */
            memcpy(want, r, sizeof want);
            CHECK(pending(visit(b, body, n, 9u), 9u));
            CHECK(memcmp(r, want, sizeof want) == 0);
        }
    }
    {
        static const uint32_t states[] = {0u, 2u, 3u, 5u, 6u, 0xffffffffu};
        for (i = 0u; i < sizeof states / sizeof states[0]; ++i) {
            n = build(body, 7, 5, 2, 3, 4, 2);
            fill(&h, 0x9c);
            put32(r, states[i]);
            memcpy(want, r, sizeof want);
            CHECK(pending(visit(b, body, n, 1u), 1u) && memcmp(r, want, sizeof want) == 0);
        }
    }
    session_a45_destroy(b);
}

static void refusals_and_unknown_modes(void)
{
    uint8_t body[MAX_BODY];
    Host h;
    SessionA45Binding *b, *no_records;
    SceneActionInfo info;
    SceneActionRuntimeState before = {0u, 4u};
    SceneActionHandlerResult out = {SCENE_ACTION_HANDLER_PENDING, 4u};
    uint8_t snapshot[sizeof h.records];
    size_t n;
    int idx;
    memset(&h, 0, sizeof h);
    b = make(&h, 1, 1);
    no_records = make(&h, 0, 1);
    fill(&h, 0x33);
    put32(h.records[1], 1u);                                          /* a running timer: a mode that wrongly applied would act */
    memcpy(snapshot, h.records, sizeof snapshot);
    /* modes outside 0..6 (and negative ones: the `ja` is unsigned) change nothing and leave the row pending */
    {
        static const int modes[] = {7, 8, 100, 32767, -1, -32768};
        unsigned i;
        for (i = 0u; i < sizeof modes / sizeof modes[0]; ++i) {
            n = build(body, 1, modes[i], 1, 1, 1, 0);
            CHECK(pending(visit(b, body, n, 6u), 6u));
            CHECK(memcmp(h.records, snapshot, sizeof snapshot) == 0);
        }
    }
    /* a timer index the port does not hold (the original indexes with a signed word) */
    for (idx = -3; idx <= 12; ++idx) {
        if (idx >= 0 && idx < 10) continue;
        n = build(body, idx, 1, 1, 1, 1, 0);
        CHECK(visit(b, body, n, 6u).status == SCENE_ACTION_HANDLER_UNSUPPORTED);
        CHECK(memcmp(h.records, snapshot, sizeof snapshot) == 0);
    }
    n = build(body, 32767, 0, 0, 0, 0, 0);
    CHECK(visit(b, body, n, 6u).status == SCENE_ACTION_HANDLER_UNSUPPORTED);
    n = build(body, -32768, 0, 0, 0, 0, 0);
    CHECK(visit(b, body, n, 6u).status == SCENE_ACTION_HANDLER_UNSUPPORTED);
    n = build(body, 1, 0, 0, 0, 0, 0);
    CHECK(visit(no_records, body, n, 6u).status == SCENE_ACTION_HANDLER_UNSUPPORTED);
    CHECK(memcmp(h.records, snapshot, sizeof snapshot) == 0);
    /* body contract: type, body pointer, length and count are checked before anything else */
    info.type = SESSION_A45_TYPE;
    info.subtype = 1u;
    info.typed_body = body;
    info.typed_body_length = n;
    CHECK(session_a45_handler(b, 0u, NULL, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_a45_handler(b, 0u, &info, NULL, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_a45_handler(b, 0u, &info, &before, NULL) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_a45_handler(NULL, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    info.type = 0x44u;
    CHECK(session_a45_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    info.type = SESSION_A45_TYPE;
    info.typed_body_length = ACTION_FAMILY_45_PREFIX_BYTES - 1u;
    CHECK(session_a45_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    info.typed_body_length = n + 4u;                                  /* count 0 but a longer body */
    CHECK(session_a45_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    n = build(body, 1, 1, 0, 0, 0, 3);
    info.typed_body_length = n - 4u;                                  /* count 3 but a shorter body */
    CHECK(session_a45_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    put16(body + SESSION_A45_BODY_COUNT, 11);
    info.typed_body_length = ACTION_FAMILY_45_PREFIX_BYTES + 44u;
    CHECK(session_a45_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    put16(body + SESSION_A45_BODY_COUNT, -1);
    info.typed_body_length = ACTION_FAMILY_45_PREFIX_BYTES;
    CHECK(session_a45_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    info.typed_body = NULL;
    CHECK(session_a45_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(memcmp(h.records, snapshot, sizeof snapshot) == 0);
    CHECK(session_a45_create(NULL) == NULL);
    session_a45_destroy(no_records);
    session_a45_destroy(b);
}

typedef void (*Case)(void);

int main(void)
{
    static const struct {
        const char *name;
        Case fn;
    } cases[] = {
        {"modes_0_1_2", modes_0_1_2},
        {"add_and_subtract", add_and_subtract},
        {"loader_word_table", loader_word_table},
        {"configure_modes_5_6", configure_modes},
        {"refusals_and_unknown_modes", refusals_and_unknown_modes},
    };
    int failures = 0;
    size_t i;
    for (i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        g_failed = 0;
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
