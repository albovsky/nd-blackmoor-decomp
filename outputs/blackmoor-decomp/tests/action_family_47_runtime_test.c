/* RT-42 unit cases for raw 0x47 (journal entry add): the kernel (src/action_family_47_runtime.c) and the binding
 * (src/session_bindings_a47.c). Bodies are written here; prints "PASS name" / "FAIL name: reason" per case. */
#include <stdio.h>
#include <string.h>

#include "session_bindings_a47.h"

static int failures;

#define CHECK(name, cond)                                      \
    do {                                                       \
        if (!(cond)) {                                         \
            printf("FAIL %s: %s (line %d)\n", name, #cond, __LINE__); \
            ++failures;                                        \
            return;                                            \
        }                                                      \
    } while (0)

typedef struct {
    unsigned calls;
    char last_key[40];
    int answer;                 /* 1 present, 0 absent, -1 failure */
    unsigned miss_from_call;    /* answer 0 from this call on (1-based); 0 = never */
} Lookup;

static int lookup(void *context, const uint8_t *key, size_t length)
{
    Lookup *l = (Lookup *)context;
    ++l->calls;
    snprintf(l->last_key, sizeof l->last_key, "%.*s", (int)length, (const char *)key);
    if (l->answer < 0) return -1;
    if (l->miss_from_call != 0u && l->calls >= l->miss_from_call) return 0;
    return l->answer;
}

static void body(uint8_t out[A47_BODY_BYTES], int16_t kind, const char *name, int16_t code, int16_t value)
{
    memset(out, 0, A47_BODY_BYTES);
    out[0] = (uint8_t)kind;
    out[1] = (uint8_t)((uint16_t)kind >> 8);
    memcpy(out + 2, name, strlen(name));
    out[0x23] = (uint8_t)code;
    out[0x24] = (uint8_t)((uint16_t)code >> 8);
    out[0x25] = (uint8_t)value;
    out[0x26] = (uint8_t)((uint16_t)value >> 8);
}

static int visit(SessionA47Binding *b, uint8_t *raw, size_t raw_bytes, SceneActionHandlerResult *result)
{
    SceneActionInfo info;
    SceneActionRuntimeState before = {0u, 5u};
    memset(&info, 0, sizeof info);
    info.type = SESSION_A47_TYPE;
    info.subtype = 1u;
    info.raw_body = raw;
    info.raw_body_length = raw_bytes;
    result->disposition = SCENE_ACTION_HANDLER_PENDING;
    result->phase = 9u;
    return session_a47_handler(b, 0u, &info, &before, result);
}

static SessionA47Binding *make_unbound(void)
{
    SessionA47Host host;
    memset(&host, 0, sizeof host);
    return session_a47_create(&host);
}

/* The binding's own lookup type returns text; wrap the unit lookup into that shape. */
static ActionFamily51LookupStatus wrapped(void *context, const uint8_t *key, size_t length, const uint8_t **text, size_t *text_length)
{
    int r = lookup(context, key, length);
    *text = (const uint8_t *)"";
    *text_length = 0u;
    return r < 0 ? ACTION_FAMILY_51_LOOKUP_ERROR : r == 0 ? ACTION_FAMILY_51_LOOKUP_NOT_FOUND : ACTION_FAMILY_51_LOOKUP_FOUND;
}

static SessionA47Binding *make_bound(Lookup *l)
{
    SessionA47Host host;
    memset(&host, 0, sizeof host);
    host.lookup = wrapped;
    host.lookup_context = l;
    return session_a47_create(&host);
}

static void test_first_entries(void)
{
    Lookup l = {0, "", 1, 0};
    SessionA47Binding *b = make_bound(&l);
    uint8_t raw[A47_BODY_BYTES];
    SceneActionHandlerResult r;
    const A47Tables *t;
    const A47Outcome *o;

    CHECK("first_entries", b != NULL);
    t = session_a47_tables(b);
    o = session_a47_last_outcome(b);
    /* an empty table needs no lookup; kind 4 -> table 1, code 0 stores 9999; the flag call sets slot 0 */
    body(raw, 4, "CURJ00", 0, -1);
    CHECK("first_entries", visit(b, raw, sizeof raw, &r) == SCENE_ACTION_HANDLER_OK);
    CHECK("first_entries", r.disposition == SCENE_ACTION_HANDLER_COMPLETED && r.phase == 0u);
    CHECK("first_entries", l.calls == 0u && o->appended && o->table == 1 && o->index == 0 && o->flag_slot == 0);
    CHECK("first_entries", t->count[1] == 1 && strcmp((const char *)t->name[1][0], "CURJ00") == 0);
    CHECK("first_entries", t->code[1][0] == 0 && t->link_value[1][0] == A47_NO_LINK);
    CHECK("first_entries", t->page2_any == 1u && t->page2_slot[0] == 1u && t->page2_slot[1] == 0u);
    /* kind 3 -> table 0, code 7 keeps the value; the lookup runs once for the one stored entry (it is another name) */
    body(raw, 3, "CURJ01", 7, 123);
    CHECK("first_entries", visit(b, raw, sizeof raw, &r) == SCENE_ACTION_HANDLER_OK);
    CHECK("first_entries", l.calls == 0u && o->appended && o->table == 0 && t->count[0] == 1 && t->link_value[0][0] == 123);
    CHECK("first_entries", t->page2_slot[1] == 1u && o->flag_slot == 1);
    /* kind 3 again with another name: one stored entry in table 0, one lookup */
    body(raw, 3, "CURJ02", 12, 55);
    CHECK("first_entries", visit(b, raw, sizeof raw, &r) == SCENE_ACTION_HANDLER_OK);
    CHECK("first_entries", l.calls == 1u && strcmp(l.last_key, "CURJ02") == 0 && o->lookups == 1u && o->index == 1);
    CHECK("first_entries", t->count[0] == 2 && t->code[0][1] == 12 && t->link_value[0][1] == 55);
    CHECK("first_entries", session_a47_adds(b) == 3ul && session_a47_visits(b) == 3ul);
    session_a47_destroy(b);
}

static void test_link_value_rule(void)
{
    Lookup l = {0, "", 1, 0};
    SessionA47Binding *b = make_bound(&l);
    uint8_t raw[A47_BODY_BYTES];
    SceneActionHandlerResult r;
    const A47Tables *t = session_a47_tables(b);
    const int16_t codes[] = {-5, 0, 6, 7, 8, 9, 10, 11, 300};
    const int expect_kept[] = {0, 0, 0, 1, 0, 0, 1, 1, 1};
    size_t i;

    CHECK("link_value_rule", b != NULL);
    for (i = 0; i < sizeof codes / sizeof codes[0]; ++i) {
        char name[16];
        snprintf(name, sizeof name, "N%zu", i);
        body(raw, 5, name, codes[i], (int16_t)(1000 + (int)i));
        CHECK("link_value_rule", visit(b, raw, sizeof raw, &r) == SCENE_ACTION_HANDLER_OK);
    }
    for (i = 0; i < sizeof codes / sizeof codes[0]; ++i) {
        CHECK("link_value_rule", t->code[2][i] == codes[i]);
        CHECK("link_value_rule", t->link_value[2][i] == (expect_kept[i] ? 1000 + (int)i : A47_NO_LINK));
    }
    /* kind 5 makes no flag call */
    CHECK("link_value_rule", t->page2_any == 0u && t->page2_slot[0] == 0u && t->page2_slot[1] == 0u);
    session_a47_destroy(b);
}

static void test_duplicates_and_misses(void)
{
    Lookup l = {0, "", 1, 0};
    SessionA47Binding *b = make_bound(&l);
    uint8_t raw[A47_BODY_BYTES];
    SceneActionHandlerResult r;
    const A47Tables *t = session_a47_tables(b);
    const A47Outcome *o = session_a47_last_outcome(b);

    CHECK("duplicates_and_misses", b != NULL);
    body(raw, 4, "AAA", 0, 0);
    visit(b, raw, sizeof raw, &r);
    body(raw, 4, "BBB", 0, 0);
    visit(b, raw, sizeof raw, &r);
    body(raw, 4, "CCC", 0, 0);
    visit(b, raw, sizeof raw, &r);
    CHECK("duplicates_and_misses", t->count[1] == 3);
    /* BBB is stored second: one lookup (against AAA), then the equal entry ends the visit without an add */
    l.calls = 0u;
    body(raw, 4, "BBB", 0, 0);
    CHECK("duplicates_and_misses", visit(b, raw, sizeof raw, &r) == SCENE_ACTION_HANDLER_OK && r.disposition == SCENE_ACTION_HANDLER_COMPLETED);
    CHECK("duplicates_and_misses", o->duplicate && !o->appended && l.calls == 1u && o->lookups == 1u && t->count[1] == 3);
    /* a name that is stored nowhere: three lookups, then the add */
    l.calls = 0u;
    body(raw, 4, "DDD", 0, 0);
    visit(b, raw, sizeof raw, &r);
    CHECK("duplicates_and_misses", o->appended && l.calls == 3u && t->count[1] == 4);
    /* the case matters: the compare is exact */
    body(raw, 4, "ddd", 0, 0);
    visit(b, raw, sizeof raw, &r);
    CHECK("duplicates_and_misses", o->appended && t->count[1] == 5);
    /* a miss on the second lookup ends the visit without an add, completed */
    l.calls = 0u;
    l.miss_from_call = 2u;
    body(raw, 4, "EEE", 0, 0);
    CHECK("duplicates_and_misses", visit(b, raw, sizeof raw, &r) == SCENE_ACTION_HANDLER_OK && r.disposition == SCENE_ACTION_HANDLER_COMPLETED);
    CHECK("duplicates_and_misses", o->lookup_miss && !o->appended && l.calls == 2u && t->count[1] == 5);
    /* the tables are separate: the same name in kind 3 is new */
    l.miss_from_call = 0u;
    body(raw, 3, "AAA", 0, 0);
    visit(b, raw, sizeof raw, &r);
    CHECK("duplicates_and_misses", o->appended && o->table == 0 && t->count[0] == 1);
    session_a47_destroy(b);
}

static void test_strcpy_keeps_stale_bytes(void)
{
    Lookup l = {0, "", 1, 0};
    SessionA47Binding *b = make_bound(&l);
    uint8_t raw[A47_BODY_BYTES];
    SceneActionHandlerResult r;
    A47Tables *t;
    uint8_t expected[A47_NAME_BYTES];

    CHECK("strcpy_stale", b != NULL);
    t = (A47Tables *)session_a47_tables(b);
    memset(t->name[1][0], 'x', A47_NAME_BYTES);
    body(raw, 4, "ab", 0, 0);
    CHECK("strcpy_stale", visit(b, raw, sizeof raw, &r) == SCENE_ACTION_HANDLER_OK);
    memset(expected, 'x', sizeof expected);
    memcpy(expected, "ab", 3u);
    CHECK("strcpy_stale", memcmp(t->name[1][0], expected, A47_NAME_BYTES) == 0);
    session_a47_destroy(b);
}

static void test_rejections_change_nothing(void)
{
    Lookup l = {0, "", 1, 0};
    SessionA47Binding *b = make_bound(&l);
    SessionA47Binding *unbound = make_unbound();
    uint8_t raw[A47_BODY_BYTES];
    SceneActionHandlerResult r;
    A47Tables *t;
    A47Tables snapshot;
    unsigned i;

    CHECK("rejections", b != NULL && unbound != NULL);
    t = (A47Tables *)session_a47_tables(b);
    body(raw, 4, "AAA", 0, 0);
    visit(b, raw, sizeof raw, &r);
    snapshot = *t;
    /* kinds 2, 6 and -1 are not tables */
    for (i = 0; i < 3u; ++i) {
        const int16_t kinds[] = {2, 6, -1};
        body(raw, kinds[i], "ZZZ", 0, 0);
        CHECK("rejections", visit(b, raw, sizeof raw, &r) == SCENE_ACTION_HANDLER_ERROR);
        CHECK("rejections", memcmp(&snapshot, t, sizeof snapshot) == 0);
    }
    /* a short body and a name without a NUL */
    body(raw, 4, "ZZZ", 0, 0);
    CHECK("rejections", visit(b, raw, A47_BODY_BYTES - 1u, &r) == SCENE_ACTION_HANDLER_ERROR);
    memset(raw + 2, 'q', A47_NAME_BYTES);
    CHECK("rejections", visit(b, raw, sizeof raw, &r) == SCENE_ACTION_HANDLER_ERROR);
    CHECK("rejections", memcmp(&snapshot, t, sizeof snapshot) == 0);
    /* a failing lookup */
    l.answer = -1;
    body(raw, 4, "NEW", 0, 0);
    CHECK("rejections", visit(b, raw, sizeof raw, &r) == SCENE_ACTION_HANDLER_ERROR);
    CHECK("rejections", memcmp(&snapshot, t, sizeof snapshot) == 0);
    /* a visit that needs the lookup while none is bound: UNSUPPORTED; an empty table needs none */
    body(raw, 4, "AAA", 0, 0);
    CHECK("rejections", visit(unbound, raw, sizeof raw, &r) == SCENE_ACTION_HANDLER_OK);
    body(raw, 4, "BBB", 0, 0);
    CHECK("rejections", visit(unbound, raw, sizeof raw, &r) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    CHECK("rejections", session_a47_tables(unbound)->count[1] == 1);
    /* a wrong type and missing arguments */
    {
        SceneActionInfo info;
        SceneActionRuntimeState before = {0u, 0u};
        body(raw, 4, "AAA", 0, 0);   /* a stored name: the visit needs no lookup, so only the type check can refuse it */
        memset(&info, 0, sizeof info);
        info.type = 0x48;
        info.raw_body = raw;
        info.raw_body_length = sizeof raw;
        CHECK("rejections", session_a47_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_ERROR);
        info.type = SESSION_A47_TYPE;
        CHECK("rejections", session_a47_handler(NULL, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_ERROR);
    }
    session_a47_destroy(b);
    session_a47_destroy(unbound);
}

static void test_full_table(void)
{
    Lookup l = {0, "", 1, 0};
    SessionA47Binding *b = make_bound(&l);
    uint8_t raw[A47_BODY_BYTES];
    SceneActionHandlerResult r;
    const A47Tables *t = session_a47_tables(b);
    A47Tables snapshot;
    unsigned i;

    CHECK("full_table", b != NULL);
    for (i = 0; i < A47_MAX_ENTRIES; ++i) {
        char name[16];
        snprintf(name, sizeof name, "E%u", i);
        body(raw, 3, name, 7, (int16_t)i);
        CHECK("full_table", visit(b, raw, sizeof raw, &r) == SCENE_ACTION_HANDLER_OK);
    }
    CHECK("full_table", t->count[0] == (int16_t)A47_MAX_ENTRIES && t->link_value[0][399] == 399);
    snapshot = *t;
    /* a 401st name: the original reports and overruns; native refuses with an error and changes nothing */
    body(raw, 3, "OVER", 7, 1);
    CHECK("full_table", visit(b, raw, sizeof raw, &r) == SCENE_ACTION_HANDLER_ERROR);
    CHECK("full_table", memcmp(&snapshot, t, sizeof snapshot) == 0);
    /* but a name that is already stored still completes: the loop ends before the full check */
    body(raw, 3, "E5", 7, 1);
    CHECK("full_table", visit(b, raw, sizeof raw, &r) == SCENE_ACTION_HANDLER_OK && r.disposition == SCENE_ACTION_HANDLER_COMPLETED);
    session_a47_destroy(b);
}

static void test_reset(void)
{
    Lookup l = {0, "", 1, 0};
    SessionA47Binding *b = make_bound(&l);
    uint8_t raw[A47_BODY_BYTES];
    SceneActionHandlerResult r;

    CHECK("reset", b != NULL);
    body(raw, 4, "AAA", 0, 0);
    visit(b, raw, sizeof raw, &r);
    session_a47_reset(b);
    CHECK("reset", session_a47_tables(b)->count[1] == 0 && session_a47_tables(b)->page2_any == 0u);
    session_a47_destroy(b);
}

int main(void)
{
    struct { const char *name; void (*fn)(void); } cases[] = {
        {"first_entries", test_first_entries},
        {"link_value_rule", test_link_value_rule},
        {"duplicates_and_misses", test_duplicates_and_misses},
        {"strcpy_stale", test_strcpy_keeps_stale_bytes},
        {"rejections", test_rejections_change_nothing},
        {"full_table", test_full_table},
        {"reset", test_reset},
    };
    size_t i;
    for (i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        const int before = failures;
        cases[i].fn();
        if (failures == before) printf("PASS %s\n", cases[i].name);
    }
    return failures == 0 ? 0 : 1;
}
