/* RT-29 unit tests of raw 0x6f "return to the saved scene": the pop 0x42e493 (src/scene_stack.c) and the session
 * binding (src/session_bindings_a6f.c). Prints "PASS <name>" / "FAIL <name>: <message>"; the exit status is the failure
 * count. Fixtures are synthetic (no original bytes). tests/test_action_family_6f_runtime.py builds and runs this plainly,
 * under ASan/UBSan and under source mutations. */
#include <stdio.h>
#include <string.h>

#include "session_bindings_a6e.h"
#include "session_bindings_a6f.h"

static int g_failed;
static char g_msg[160];
#define CHECK(cond)                                                       \
    do {                                                                  \
        if (!(cond) && !g_failed) {                                       \
            g_failed = 1;                                                 \
            snprintf(g_msg, sizeof g_msg, "line %d: %s", __LINE__, #cond); \
        }                                                                 \
    } while (0)

static SceneStackSlot sample_slot(void)
{
    SceneStackSlot s;
    s.scene_5c3a05 = 4700;
    s.scene_5c3a07 = 4710;
    s.word_5c3a09 = 11;
    s.word_5c3a0b = -12;
    s.word_5c3a0d = 2;
    s.dword_5c3a0f = 0x01020304;
    s.dword_5c3a13 = 0x0a0b0c0d;
    s.dword_5c3a17 = 0x7a7b7c7d;
    return s;
}

typedef struct {
    int refuse;
    int calls;
    SceneStackPop pop;
    SceneTransitionRequest request;
    const SceneStackSlot *watch; /* the slot as the host sees it during the call */
    SceneStackSlot seen;
} Host;

static int apply(void *context, const SceneStackPop *pop, const SceneTransitionRequest *request)
{
    Host *h = (Host *)context;
    ++h->calls;
    h->pop = *pop;
    h->request = *request;
    if (h->watch != NULL) h->seen = *h->watch;
    return h->refuse;
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

static void pop_reads_the_record(void)
{
    SceneStackSlot s = sample_slot();
    SceneStackPop p;
    memset(&p, 0x77, sizeof p);
    CHECK(scene_stack_pop(&s, &p) == SCENE_STACK_POP_OK);
    CHECK(p.scene_5bb57b == 4710 && p.scene_5bb57f == 4710); /* both from word 0x5c3a07, never from 0x5c3a05 */
    CHECK(p.word_5bb599 == 11 && p.word_5bb595 == -12 && p.word_5c39ff == 1);
    CHECK(p.dword_5bb59b == 0x01020304 && p.dword_5bb59f == 0x0a0b0c0d && p.dword_5bb5a3 == 0x7a7b7c7d);
    CHECK(p.start_5bb1ca == 1 && p.mode_583999 == 4);
    /* the record is marked empty; the other words stay */
    CHECK(s.scene_5c3a05 == 0x270f && s.scene_5c3a07 == 0x270f);
    CHECK(s.word_5c3a09 == 11 && s.word_5c3a0b == -12 && s.word_5c3a0d == 2);
    CHECK(s.dword_5c3a0f == 0x01020304 && s.dword_5c3a13 == 0x0a0b0c0d && s.dword_5c3a17 == 0x7a7b7c7d);
}

static void pop_sign_extends_the_scene_word(void)
{
    SceneStackSlot s = sample_slot();
    SceneStackPop p;
    s.scene_5c3a07 = -2;
    CHECK(scene_stack_pop(&s, &p) == SCENE_STACK_POP_OK);
    CHECK(p.scene_5bb57b == -2 && p.scene_5bb57f == -2);
    s = sample_slot();
    s.scene_5c3a07 = 0x270f; /* a saved scene word of 9999 is popped like any other: only 0x5c3a05 is tested */
    CHECK(scene_stack_pop(&s, &p) == SCENE_STACK_POP_OK && p.scene_5bb57b == 0x270f);
}

static void pop_start_flag_follows_the_type_word(void)
{
    static const int16_t types[] = {1, 0, 2, -1, 3, 0x100, (int16_t)0x8001};
    static const int32_t expect[] = {0, 1, 1, 1, 1, 1, 1};
    unsigned i;
    for (i = 0; i < sizeof types / sizeof types[0]; ++i) {
        SceneStackSlot s = sample_slot();
        SceneStackPop p;
        s.word_5c3a0d = types[i];
        CHECK(scene_stack_pop(&s, &p) == SCENE_STACK_POP_OK);
        CHECK(p.start_5bb1ca == expect[i]);
    }
}

static void pop_of_an_empty_record_changes_nothing(void)
{
    SceneStackSlot s = sample_slot(), before;
    SceneStackPop p, marker;
    memset(&p, 0x5a, sizeof p);
    marker = p;
    s.scene_5c3a05 = 0x270f;
    before = s;
    CHECK(scene_stack_pop(&s, &p) == SCENE_STACK_POP_EMPTY);
    CHECK(memcmp(&s, &before, sizeof s) == 0 && memcmp(&p, &marker, sizeof p) == 0);
    s = sample_slot();
    s.scene_5c3a05 = (int16_t)0xf70f; /* only the exact word 9999 counts as empty */
    CHECK(scene_stack_pop(&s, &p) == SCENE_STACK_POP_OK);
    CHECK(scene_stack_pop(NULL, &p) == SCENE_STACK_POP_ARGUMENT);
    CHECK(scene_stack_pop(&s, NULL) == SCENE_STACK_POP_ARGUMENT);
}

static void push_then_pop_round_trip(void)
{
    SceneStackSlot s;
    SceneStackCurrent c;
    SceneStackPop p;
    memset(&c, 0, sizeof c);
    c.scene_5bb57b = 4700;
    c.scene_5bb57f = 4701;
    c.word_5bb50b = 9;
    c.word_5bb593 = 8;
    c.dword_5bb5a7 = 7;
    c.dword_5bb5ab = 6;
    c.dword_5bb5af = 5;
    scene_stack_slot_clear(&s);
    scene_stack_slot_init_words(&s);
    CHECK(scene_stack_pop(&s, &p) == SCENE_STACK_POP_EMPTY); /* nothing pushed yet: the initializer's marker */
    scene_stack_push(&s, &c, 2);
    CHECK(scene_stack_pop(&s, &p) == SCENE_STACK_POP_OK);
    /* the pop returns to 0x5bb57f's scene (the push stored it at 0x5c3a07) with the saved words */
    CHECK(p.scene_5bb57b == 4701 && p.word_5bb599 == 9 && p.word_5bb595 == 8);
    CHECK(p.dword_5bb59b == 7 && p.dword_5bb59f == 5 && p.dword_5bb5a3 == 0); /* 0x5c3a13 holds 0x5bb5af, 0x5c3a17 never written */
    CHECK(p.start_5bb1ca == 1);
    CHECK(scene_stack_pop(&s, &p) == SCENE_STACK_POP_EMPTY); /* one pop per push */
}

static void binding_dispositions_and_request(void)
{
    static const uint8_t body[1] = {0u};
    const uint8_t subtypes[] = {0u, 1u, 2u, 3u, 255u};
    Host h;
    SessionA6FHost host;
    SceneStackSlot s;
    SessionA6FBinding *bind;
    unsigned i;
    memset(&h, 0, sizeof h);
    h.watch = &s;
    memset(&host, 0, sizeof host);
    host.context = &h;
    host.apply = apply;
    bind = session_a6f_create(&host, &s);
    CHECK(bind != NULL);
    for (i = 0; i < sizeof subtypes; ++i) {
        SceneActionInfo info = row(0x6f, subtypes[i], body, 1u);
        SceneActionRuntimeState before = {0u, 9u + i};
        SceneActionHandlerResult out = {SCENE_ACTION_HANDLER_PENDING, 0u};
        s = sample_slot();
        CHECK(session_a6f_handler(bind, i, &info, &before, &out) == SCENE_ACTION_HANDLER_OK);
        /* the arm sets the completion byte itself: no 0x42ba3a, no dependency reset, whatever the subtype, and the
         * phase word is not written */
        CHECK(out.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED);
        CHECK(out.phase == 9u + i);
        CHECK(h.calls == (int)i + 1);
        CHECK(h.request.target_scene == 4710);
        CHECK(h.request.opaque_words[0] == 11 && h.request.opaque_words[1] == -12 && h.request.opaque_words[2] == 1);
        CHECK(h.request.opaque_dwords[0] == 0x01020304 && h.request.opaque_dwords[1] == 0x0a0b0c0d &&
              h.request.opaque_dwords[2] == 0x7a7b7c7d);
        CHECK(h.pop.start_5bb1ca == 1 && h.pop.mode_583999 == 4);
        CHECK(h.seen.scene_5c3a05 == 4700); /* still saved while the host runs */
        CHECK(s.scene_5c3a05 == 0x270f && s.scene_5c3a07 == 0x270f); /* cleared once it accepted */
    }
    CHECK(session_a6f_pops(bind) == sizeof subtypes);
    CHECK(strcmp(session_a6f_failure(bind), "none") == 0);
    session_a6f_destroy(bind);
}

static void body_byte_is_never_read(void)
{
    uint8_t body[1];
    Host h;
    SessionA6FHost host;
    SceneStackSlot s;
    SessionA6FBinding *bind;
    unsigned v;
    memset(&h, 0, sizeof h);
    memset(&host, 0, sizeof host);
    host.context = &h;
    host.apply = apply;
    bind = session_a6f_create(&host, &s);
    for (v = 0; v < 256u; v += 85u) {
        SceneActionInfo info;
        SceneActionRuntimeState before = {0u, 0u};
        SceneActionHandlerResult out = {SCENE_ACTION_HANDLER_PENDING, 0u};
        SceneTransitionRequest first;
        body[0] = (uint8_t)v;
        info = row(0x6f, 1u, body, 1u);
        s = sample_slot();
        CHECK(session_a6f_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_OK);
        first = h.request;
        body[0] = 0u;
        s = sample_slot();
        CHECK(session_a6f_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_OK);
        CHECK(memcmp(&first, &h.request, sizeof first) == 0);
    }
    session_a6f_destroy(bind);
}

static void binding_failures(void)
{
    static const uint8_t body[1] = {0u};
    static const uint8_t two[2] = {0u, 0u};
    Host h;
    SessionA6FHost host, missing;
    SceneStackSlot s, untouched;
    SessionA6FBinding *bind, *no_host;
    SceneActionInfo info;
    SceneActionRuntimeState before = {0u, 4u};
    SceneActionHandlerResult out = {SCENE_ACTION_HANDLER_PENDING, 4u};
    memset(&h, 0, sizeof h);
    memset(&host, 0, sizeof host);
    memset(&missing, 0, sizeof missing);
    host.context = &h;
    host.apply = apply;
    s = sample_slot();
    untouched = s;
    CHECK(session_a6f_create(NULL, &s) == NULL && session_a6f_create(&host, NULL) == NULL);
    bind = session_a6f_create(&host, &s);
    no_host = session_a6f_create(&missing, &s);
    CHECK(bind != NULL && no_host != NULL);
    info = row(0x6f, 1u, body, 1u);
    /* no scene-change provider: unsupported before any effect */
    CHECK(session_a6f_handler(no_host, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    CHECK(memcmp(&untouched, &s, sizeof s) == 0);
    /* the host refuses: error, the saved record stays */
    h.refuse = 1;
    CHECK(session_a6f_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(h.calls == 1 && memcmp(&untouched, &s, sizeof s) == 0 && session_a6f_pops(bind) == 0ul);
    CHECK(strcmp(session_a6f_failure(bind), "none") != 0);
    h.refuse = 0;
    /* wrong type or body length */
    info = row(0x6e, 1u, body, 1u);
    CHECK(session_a6f_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    info = row(0x6f, 1u, two, 2u);
    CHECK(session_a6f_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    info = row(0x6f, 1u, body, 0u);
    CHECK(session_a6f_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    info = row(0x6f, 1u, body, 1u);
    CHECK(session_a6f_handler(NULL, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_a6f_handler(bind, 0u, NULL, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_a6f_handler(bind, 0u, &info, NULL, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_a6f_handler(bind, 0u, &info, &before, NULL) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(h.calls == 1 && memcmp(&untouched, &s, sizeof s) == 0);
    /* an empty record: the original aborts; here an error before the host is asked */
    s.scene_5c3a05 = 0x270f;
    untouched = s;
    CHECK(session_a6f_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(h.calls == 1 && memcmp(&untouched, &s, sizeof s) == 0);
    CHECK(strstr(session_a6f_failure(bind), "empty") != NULL);
    s = sample_slot();
    CHECK(session_a6f_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_OK);
    session_a6f_destroy(bind);
    session_a6f_destroy(no_host);
}

typedef struct {
    SceneStackCurrent current;
} Provider;

static int provide(void *context, SceneStackCurrent *out)
{
    *out = ((Provider *)context)->current;
    return 0;
}

static void push_pop_round_trip_through_both_bindings(void)
{
    static const uint8_t body[1] = {0u};
    Provider p;
    Host h;
    SessionA6EHost push_host;
    SessionA6FHost pop_host;
    SceneStackSlot s;
    SessionA6EBinding *push;
    SessionA6FBinding *pop;
    SceneActionInfo push_row = row(0x6e, 1u, body, 1u), pop_row = row(0x6f, 1u, body, 1u);
    SceneActionRuntimeState before = {0u, 0u};
    SceneActionHandlerResult out = {SCENE_ACTION_HANDLER_PENDING, 0u};
    memset(&p, 0, sizeof p);
    memset(&h, 0, sizeof h);
    p.current.scene_5bb57b = 5900;
    p.current.scene_5bb57f = 5901;
    p.current.word_5bb50b = 3;
    p.current.word_5bb593 = 4;
    p.current.dword_5bb5a7 = 100;
    p.current.dword_5bb5ab = 200;
    p.current.dword_5bb5af = 300;
    memset(&push_host, 0, sizeof push_host);
    push_host.context = &p;
    push_host.load_current = provide;
    memset(&pop_host, 0, sizeof pop_host);
    pop_host.context = &h;
    pop_host.apply = apply;
    scene_stack_slot_clear(&s);
    scene_stack_slot_init_words(&s);
    push = session_a6e_create(&push_host, &s);
    pop = session_a6f_create(&pop_host, &s);
    CHECK(push != NULL && pop != NULL);
    /* a pop before any push is the original's fatal empty-stack case */
    CHECK(session_a6f_handler(pop, 0u, &pop_row, &before, &out) == SCENE_ACTION_HANDLER_ERROR && h.calls == 0);
    CHECK(session_a6e_handler(push, 1u, &push_row, &before, &out) == SCENE_ACTION_HANDLER_OK);
    CHECK(session_a6f_handler(pop, 2u, &pop_row, &before, &out) == SCENE_ACTION_HANDLER_OK);
    CHECK(h.request.target_scene == 5901); /* the push saved 0x5bb57f at 0x5c3a07 and the pop reads that word */
    CHECK(h.request.opaque_words[0] == 3 && h.request.opaque_words[1] == 4 && h.request.opaque_words[2] == 1);
    CHECK(h.request.opaque_dwords[0] == 100 && h.request.opaque_dwords[1] == 300 && h.request.opaque_dwords[2] == 0);
    CHECK(h.pop.start_5bb1ca == 1); /* the push stores type 2 */
    /* a second pop finds the record empty again; a second push-pop works once more */
    CHECK(session_a6f_handler(pop, 3u, &pop_row, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    p.current.scene_5bb57f = 6400;
    CHECK(session_a6e_handler(push, 4u, &push_row, &before, &out) == SCENE_ACTION_HANDLER_OK);
    CHECK(session_a6f_handler(pop, 5u, &pop_row, &before, &out) == SCENE_ACTION_HANDLER_OK && h.request.target_scene == 6400);
    CHECK(h.calls == 2 && session_a6f_pops(pop) == 2ul && session_a6e_pushes(push) == 2ul);
    session_a6e_destroy(push);
    session_a6f_destroy(pop);
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
    run("pop_reads_the_record", pop_reads_the_record, &failures);
    run("pop_sign_extends_the_scene_word", pop_sign_extends_the_scene_word, &failures);
    run("pop_start_flag_follows_the_type_word", pop_start_flag_follows_the_type_word, &failures);
    run("pop_of_an_empty_record_changes_nothing", pop_of_an_empty_record_changes_nothing, &failures);
    run("push_then_pop_round_trip", push_then_pop_round_trip, &failures);
    run("binding_dispositions_and_request", binding_dispositions_and_request, &failures);
    run("body_byte_is_never_read", body_byte_is_never_read, &failures);
    run("binding_failures", binding_failures, &failures);
    run("push_pop_round_trip_through_both_bindings", push_pop_round_trip_through_both_bindings, &failures);
    return failures;
}
