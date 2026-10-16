/* RT-37 unit tests of raw 0x65 (SAVE_CONTINUE), 0x68 (timer start) and 0x69 (timer clear): the session binding. Prints
 * "PASS <name>" / "FAIL <name>: <message>"; the exit status is the failure count. Fixtures are synthetic (no original bytes).
 * tests/test_action_family_65_68_69_runtime.py builds and runs this plainly, under ASan/UBSan and under source mutations. */
#include <stdio.h>
#include <string.h>

#include "session_bindings_a65_a68_a69.h"

static int g_failed;
static char g_msg[160];
#define CHECK(cond)                                                       \
    do {                                                                  \
        if (!(cond) && !g_failed) {                                       \
            g_failed = 1;                                                 \
            snprintf(g_msg, sizeof g_msg, "line %d: %s", __LINE__, #cond); \
        }                                                                 \
    } while (0)

typedef struct {
    uint8_t records[SESSION_TIMER_RECORD_COUNT][SESSION_TIMER_RECORD_BYTES];
    unsigned asked;
    unsigned saves;
    char name[32];
    int report_failure;
} Host;

static uint8_t *time_record(void *context, unsigned index)
{
    Host *h = (Host *)context;
    ++h->asked;
    return index < SESSION_TIMER_RECORD_COUNT ? h->records[index] : NULL;
}

static void save_game(void *context, const char *name, int report_failure)
{
    Host *h = (Host *)context;
    ++h->saves;
    snprintf(h->name, sizeof h->name, "%s", name);
    h->report_failure = report_failure;
}

static SceneActionInfo row(uint8_t type, uint8_t subtype, const uint8_t *body, size_t length)
{
    SceneActionInfo info;
    memset(&info, 0, sizeof info);
    info.type = type;
    info.subtype = subtype;
    info.typed_body = body;
    info.typed_body_length = length;
    return info;
}

static SessionA65Binding *make(Host *host, int with_records, int with_save)
{
    SessionA65Host h;
    memset(&h, 0, sizeof h);
    h.context = host;
    h.time_record = with_records ? time_record : NULL;
    h.save_game = with_save ? save_game : NULL;
    return session_a65_create(&h);
}

typedef int (*Handler)(void *, size_t, const SceneActionInfo *, const SceneActionRuntimeState *, SceneActionHandlerResult *);

/* The expected record after 0x433bd2: zeros, 0xffff in the ten pair index words, "NO SOUND" at +0x28. */
static void expected_clear(uint8_t *record)
{
    unsigned k;
    memset(record, 0, SESSION_TIMER_RECORD_BYTES);
    for (k = 0; k < 10u; ++k) {
        record[0xde + 4u * k] = 0xff;
        record[0xde + 4u * k + 1u] = 0xff;
    }
    memcpy(record + 0x28, "NO SOUND", 9u);
}

static void clear_kernel(void)
{
    uint8_t rec[SESSION_TIMER_RECORD_BYTES], want[SESSION_TIMER_RECORD_BYTES];
    memset(rec, 0xa5, sizeof rec);
    session_timer_record_clear(rec);
    expected_clear(want);
    CHECK(memcmp(rec, want, sizeof rec) == 0);
    /* the pair value words and everything else between the fields are zero, not 0xffff */
    CHECK(rec[0xe0] == 0 && rec[0xe1] == 0 && rec[0x30] == 0 && rec[0x105] == 0 && rec[0] == 0);
}

static void timer_start_and_clear(void)
{
    Host h;
    SessionA65Binding *b;
    unsigned idx, k;
    memset(&h, 0, sizeof h);
    b = make(&h, 1, 1);
    CHECK(b != NULL);
    for (k = 0; k < 2u; ++k) {
        Handler fn = k == 0u ? session_a68_handler : session_a69_handler;
        for (idx = 0; idx < SESSION_TIMER_RECORD_COUNT; ++idx) {
            uint8_t body[1];
            uint8_t want[SESSION_TIMER_RECORD_BYTES];
            SceneActionInfo info;
            SceneActionRuntimeState before = {0u, 11u + idx};
            SceneActionHandlerResult out = {SCENE_ACTION_HANDLER_PENDING, 0u};
            unsigned other;
            body[0] = (uint8_t)idx;
            info = row(k == 0u ? 0x68 : 0x69, 1u, body, 1u);
            memset(h.records, 0x5a, sizeof h.records);
            CHECK(fn(b, idx, &info, &before, &out) == SCENE_ACTION_HANDLER_OK);
            CHECK(out.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED && out.phase == 11u + idx);
            expected_clear(want);
            if (k == 0u) want[0] = 1;
            CHECK(memcmp(h.records[idx], want, sizeof want) == 0);
            for (other = 0; other < SESSION_TIMER_RECORD_COUNT; ++other) {
                unsigned i;
                int untouched = 1;
                if (other == idx) continue;
                for (i = 0; i < SESSION_TIMER_RECORD_BYTES; ++i) untouched &= h.records[other][i] == 0x5a;
                CHECK(untouched);
            }
        }
    }
    CHECK(session_a68_visits(b) == SESSION_TIMER_RECORD_COUNT && session_a69_visits(b) == SESSION_TIMER_RECORD_COUNT);
    CHECK(session_a65_visits(b) == 0ul && h.saves == 0u);
    session_a65_destroy(b);
}

static void subtype_is_ignored(void)
{
    static const uint8_t body[1] = {4u};
    const uint8_t subtypes[] = {0u, 1u, 2u, 3u, 255u};
    Host h;
    SessionA65Binding *b;
    unsigned i;
    memset(&h, 0, sizeof h);
    b = make(&h, 1, 1);
    for (i = 0; i < sizeof subtypes; ++i) {
        unsigned t;
        for (t = 0; t < 3u; ++t) {
            Handler fn = t == 0u ? session_a65_handler : t == 1u ? session_a68_handler : session_a69_handler;
            SceneActionInfo info = row(t == 0u ? 0x65 : t == 1u ? 0x68 : 0x69, subtypes[i], body, 1u);
            SceneActionRuntimeState before = {0u, 5u + i};
            SceneActionHandlerResult out = {SCENE_ACTION_HANDLER_PENDING, 0u};
            CHECK(fn(b, i, &info, &before, &out) == SCENE_ACTION_HANDLER_OK);
            CHECK(out.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED && out.phase == 5u + i);
        }
    }
    CHECK(session_a65_visits(b) == sizeof subtypes && session_a68_visits(b) == sizeof subtypes);
    CHECK(session_a69_visits(b) == sizeof subtypes && h.saves == sizeof subtypes);
    session_a65_destroy(b);
}

static void save_continue_call(void)
{
    uint8_t body[1];
    Host h;
    SessionA65Binding *b;
    unsigned v;
    memset(&h, 0, sizeof h);
    b = make(&h, 1, 1);
    for (v = 0; v < 256u; v += 51u) {
        SceneActionInfo info;
        SceneActionRuntimeState before = {0u, 3u};
        SceneActionHandlerResult out = {SCENE_ACTION_HANDLER_PENDING, 0u};
        body[0] = (uint8_t)v; /* the body byte is never read */
        info = row(0x65, 1u, body, 1u);
        h.report_failure = 7;
        CHECK(session_a65_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_OK);
        CHECK(out.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED && out.phase == 3u);
        CHECK(strcmp(h.name, "SAVE CONTINUE") == 0 && h.report_failure == 0);
    }
    CHECK(h.saves == 6u && h.asked == 0u); /* the save arm never touches a timer record */
    session_a65_destroy(b);
}

static void refusals(void)
{
    static const uint8_t body[1] = {2u};
    static const uint8_t two[2] = {2u, 0u};
    static const uint8_t far_body[1] = {10u};
    static const uint8_t far255[1] = {255u};
    Host h;
    SessionA65Binding *b, *no_host, *only_save, *only_records;
    SessionA65Host none;
    SceneActionInfo info;
    SceneActionRuntimeState before = {0u, 4u};
    SceneActionHandlerResult out = {SCENE_ACTION_HANDLER_PENDING, 4u};
    uint8_t snapshot[sizeof h.records];
    memset(&h, 0, sizeof h);
    memset(h.records, 0x33, sizeof h.records);
    memcpy(snapshot, h.records, sizeof snapshot);
    memset(&none, 0, sizeof none);
    CHECK(session_a65_create(NULL) == NULL);
    b = make(&h, 1, 1);
    no_host = session_a65_create(&none);
    only_save = make(&h, 0, 1);
    only_records = make(&h, 1, 0);
    CHECK(b != NULL && no_host != NULL && only_save != NULL && only_records != NULL);
    /* the host cannot take the effect: unsupported before any effect */
    info = row(0x65, 1u, body, 1u);
    CHECK(session_a65_handler(no_host, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    CHECK(session_a65_handler(only_records, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    info = row(0x68, 1u, body, 1u);
    CHECK(session_a68_handler(no_host, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    CHECK(session_a68_handler(only_save, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    info = row(0x69, 1u, body, 1u);
    CHECK(session_a69_handler(only_save, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    CHECK(strcmp(session_a65_failure(only_save), "none") != 0);
    /* a timer index the port does not hold (the original writes past its table): refused before any write */
    info = row(0x68, 1u, far_body, 1u);
    CHECK(session_a68_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    info = row(0x69, 1u, far255, 1u);
    CHECK(session_a69_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    /* wrong type, body length, null arguments */
    info = row(0x69, 1u, body, 1u);
    CHECK(session_a68_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_a65_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    info = row(0x68, 1u, two, 2u);
    CHECK(session_a68_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    info = row(0x68, 1u, body, 0u);
    CHECK(session_a68_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    info = row(0x65, 1u, two, 2u);
    CHECK(session_a65_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    info = row(0x68, 1u, NULL, 1u);
    CHECK(session_a68_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    info = row(0x68, 1u, body, 1u);
    CHECK(session_a68_handler(NULL, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_a68_handler(b, 0u, NULL, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_a68_handler(b, 0u, &info, NULL, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_a68_handler(b, 0u, &info, &before, NULL) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(memcmp(h.records, snapshot, sizeof snapshot) == 0 && h.saves == 0u);
    CHECK(session_a65_visits(b) == 0ul && session_a68_visits(b) == 0ul && session_a69_visits(b) == 0ul);
    CHECK(session_a68_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_OK);
    CHECK(h.records[2][0] == 1 && session_a68_visits(b) == 1ul);
    session_a65_destroy(b);
    session_a65_destroy(no_host);
    session_a65_destroy(only_save);
    session_a65_destroy(only_records);
}

static void run(const char *name, void (*fn)(void), int *failures)
{
    g_failed = 0;
    g_msg[0] = '\0';
    fn();
    if (g_failed) {
        printf("FAIL %s: %s\n", name, g_msg);
        ++*failures;
    } else {
        printf("PASS %s\n", name);
    }
}

int main(void)
{
    int failures = 0;
    run("clear_kernel", clear_kernel, &failures);
    run("timer_start_and_clear", timer_start_and_clear, &failures);
    run("subtype_is_ignored", subtype_is_ignored, &failures);
    run("save_continue_call", save_continue_call, &failures);
    run("refusals", refusals, &failures);
    return failures;
}
