/* RT-28 unit tests of raw 0x6e "save the running scene": the saved scene record, the push 0x42e560 and the session
 * binding. Prints "PASS <name>" / "FAIL <name>: <message>"; the exit status is the failure count. Fixtures are synthetic
 * (no original bytes). tests/test_action_family_6e_runtime.py builds and runs this plainly, under ASan/UBSan and under source
 * mutations. */
#include <stdio.h>
#include <string.h>

#include "session_bindings_a6e.h"

static int g_failed;
static char g_msg[160];
#define CHECK(cond)                                                       \
    do {                                                                  \
        if (!(cond) && !g_failed) {                                       \
            g_failed = 1;                                                 \
            snprintf(g_msg, sizeof g_msg, "line %d: %s", __LINE__, #cond); \
        }                                                                 \
    } while (0)

static SceneStackCurrent sample(void)
{
    SceneStackCurrent c;
    c.scene_5bb57b = 4700;
    c.scene_5bb57f = 4710;
    c.word_5bb50b = 11;
    c.word_5bb593 = -12;
    c.dword_5bb5a7 = 0x01020304;
    c.dword_5bb5ab = 0x0a0b0c0d;
    c.dword_5bb5af = 0x7a7b7c7d;
    return c;
}

typedef struct {
    SceneStackCurrent current;
    int fail;
} Provider;

static int provide(void *context, SceneStackCurrent *out)
{
    Provider *p = (Provider *)context;
    if (p->fail) return 1;
    *out = p->current;
    return 0;
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

static void slot_start_and_init(void)
{
    SceneStackSlot s;
    memset(&s, 0x5a, sizeof s);
    scene_stack_slot_clear(&s);
    CHECK(s.scene_5c3a05 == 0 && s.word_5c3a0d == 0 && s.dword_5c3a13 == 0 && s.dword_5c3a17 == 0);
    s.dword_5c3a0f = 77;
    s.dword_5c3a13 = 88;
    s.dword_5c3a17 = 99;
    scene_stack_slot_init_words(&s);
    CHECK(s.scene_5c3a05 == 0x270f && s.scene_5c3a07 == 0x270f);
    CHECK(s.word_5c3a09 == 0 && s.word_5c3a0b == 0 && s.word_5c3a0d == 2);
    CHECK(s.dword_5c3a0f == 77 && s.dword_5c3a13 == 88 && s.dword_5c3a17 == 99); /* the initializer leaves the dwords */
}

static void push_copies_the_running_scene(void)
{
    SceneStackSlot s;
    SceneStackCurrent c = sample();
    scene_stack_slot_clear(&s);
    scene_stack_push(&s, &c, 2);
    CHECK(s.scene_5c3a05 == 4700 && s.scene_5c3a07 == 4710);
    CHECK(s.word_5c3a09 == 11 && s.word_5c3a0b == -12 && s.word_5c3a0d == 2);
    CHECK(s.dword_5c3a0f == 0x01020304);
}

static void push_dword_13_takes_the_last_store(void)
{
    SceneStackSlot s;
    SceneStackCurrent c = sample();
    scene_stack_slot_clear(&s);
    s.dword_5c3a17 = 1234;
    scene_stack_push(&s, &c, 2);
    CHECK(s.dword_5c3a13 == 0x7a7b7c7d); /* 0x5bb5af overwrites the 0x5bb5ab copy */
    CHECK(s.dword_5c3a17 == 1234);       /* never written by the push */
}

static void push_stores_low_words(void)
{
    SceneStackSlot s;
    SceneStackCurrent c = sample();
    scene_stack_slot_clear(&s);
    c.scene_5bb57b = 0x12345678;
    c.scene_5bb57f = (int32_t)0xfffffffe;
    scene_stack_push(&s, &c, 0x10003);
    CHECK(s.scene_5c3a05 == 0x5678 && s.scene_5c3a07 == -2);
    CHECK(s.word_5c3a0d == 3); /* only the low word of the argument */
    scene_stack_push(&s, &c, -1);
    CHECK(s.word_5c3a0d == -1);
}

static void a_second_push_overwrites(void)
{
    SceneStackSlot s;
    SceneStackCurrent a = sample(), b = sample();
    scene_stack_slot_clear(&s);
    b.scene_5bb57b = b.scene_5bb57f = 6400;
    b.word_5bb50b = 0;
    scene_stack_push(&s, &a, 2);
    scene_stack_push(&s, &b, 2);
    CHECK(s.scene_5c3a05 == 6400 && s.scene_5c3a07 == 6400 && s.word_5c3a09 == 0);
    scene_stack_push(NULL, &a, 2);
    scene_stack_push(&s, NULL, 2);
    CHECK(s.scene_5c3a05 == 6400); /* null arguments change nothing */
}

static void binding_dispositions(void)
{
    static const uint8_t body[1] = {0u};
    const uint8_t subtypes[] = {0u, 1u, 2u, 3u, 255u};
    Provider p = {sample(), 0};
    SessionA6EHost host;
    SceneStackSlot s;
    SessionA6EBinding *bind;
    unsigned i;
    memset(&host, 0, sizeof host);
    host.context = &p;
    host.load_current = provide;
    scene_stack_slot_init_words(&s);
    bind = session_a6e_create(&host, &s);
    CHECK(bind != NULL);
    for (i = 0; i < sizeof subtypes; ++i) {
        SceneActionInfo info = row(0x6e, subtypes[i], body, 1u);
        SceneActionRuntimeState before = {0u, 9u + i};
        SceneActionHandlerResult out = {SCENE_ACTION_HANDLER_PENDING, 0u};
        scene_stack_slot_clear(&s);
        CHECK(session_a6e_handler(bind, i, &info, &before, &out) == SCENE_ACTION_HANDLER_OK);
        /* the arm sets the completion byte itself: no 0x42ba3a, no dependency reset, whatever the subtype, and the
         * phase word is not written */
        CHECK(out.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED);
        CHECK(out.phase == 9u + i);
        CHECK(s.scene_5c3a05 == 4700 && s.word_5c3a0d == 2 && s.dword_5c3a13 == 0x7a7b7c7d);
    }
    CHECK(session_a6e_pushes(bind) == sizeof subtypes);
    CHECK(strcmp(session_a6e_failure(bind), "none") == 0);
    session_a6e_destroy(bind);
}

static void body_byte_is_never_read(void)
{
    uint8_t body[1];
    Provider p = {sample(), 0};
    SessionA6EHost host;
    SceneStackSlot s;
    SessionA6EBinding *bind;
    unsigned v;
    memset(&host, 0, sizeof host);
    host.context = &p;
    host.load_current = provide;
    scene_stack_slot_clear(&s);
    bind = session_a6e_create(&host, &s);
    for (v = 0; v < 256u; v += 85u) {
        SceneActionInfo info;
        SceneActionRuntimeState before = {0u, 0u};
        SceneActionHandlerResult out = {SCENE_ACTION_HANDLER_PENDING, 0u};
        SceneStackSlot snapshot;
        body[0] = (uint8_t)v;
        info = row(0x6e, 1u, body, 1u);
        scene_stack_slot_clear(&s);
        CHECK(session_a6e_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_OK);
        snapshot = s;
        body[0] = 0u;
        scene_stack_slot_clear(&s);
        CHECK(session_a6e_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_OK);
        CHECK(memcmp(&snapshot, &s, sizeof s) == 0);
    }
    session_a6e_destroy(bind);
}

static void binding_failures(void)
{
    static const uint8_t body[1] = {0u};
    static const uint8_t two[2] = {0u, 0u};
    Provider p = {sample(), 0};
    SessionA6EHost host, missing;
    SceneStackSlot s, untouched;
    SessionA6EBinding *bind, *no_provider;
    SceneActionInfo info;
    SceneActionRuntimeState before = {0u, 4u};
    SceneActionHandlerResult out = {SCENE_ACTION_HANDLER_PENDING, 4u};
    memset(&host, 0, sizeof host);
    memset(&missing, 0, sizeof missing);
    host.context = &p;
    host.load_current = provide;
    scene_stack_slot_init_words(&s);
    untouched = s;
    CHECK(session_a6e_create(NULL, &s) == NULL && session_a6e_create(&host, NULL) == NULL);
    bind = session_a6e_create(&host, &s);
    no_provider = session_a6e_create(&missing, &s);
    CHECK(bind != NULL && no_provider != NULL);
    info = row(0x6e, 1u, body, 1u);
    /* the host cannot supply the scene words: unsupported before any effect */
    CHECK(session_a6e_handler(no_provider, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    p.fail = 1;
    CHECK(session_a6e_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    CHECK(memcmp(&untouched, &s, sizeof s) == 0 && session_a6e_pushes(bind) == 0ul);
    CHECK(strcmp(session_a6e_failure(bind), "none") != 0);
    p.fail = 0;
    /* wrong type or body length */
    info = row(0x6f, 1u, body, 1u);
    CHECK(session_a6e_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    info = row(0x6e, 1u, two, 2u);
    CHECK(session_a6e_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    info = row(0x6e, 1u, body, 0u);
    CHECK(session_a6e_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    info = row(0x6e, 1u, body, 1u);
    CHECK(session_a6e_handler(NULL, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_a6e_handler(bind, 0u, NULL, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_a6e_handler(bind, 0u, &info, NULL, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_a6e_handler(bind, 0u, &info, &before, NULL) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(memcmp(&untouched, &s, sizeof s) == 0);
    CHECK(session_a6e_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_OK);
    session_a6e_destroy(bind);
    session_a6e_destroy(no_provider);
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
    run("slot_start_and_init", slot_start_and_init, &failures);
    run("push_copies_the_running_scene", push_copies_the_running_scene, &failures);
    run("push_dword_13_takes_the_last_store", push_dword_13_takes_the_last_store, &failures);
    run("push_stores_low_words", push_stores_low_words, &failures);
    run("a_second_push_overwrites", a_second_push_overwrites, &failures);
    run("binding_dispositions", binding_dispositions, &failures);
    run("body_byte_is_never_read", body_byte_is_never_read, &failures);
    run("binding_failures", binding_failures, &failures);
    return failures;
}
