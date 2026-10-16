/* RT-30 unit tests of raw 0x67 "set the start flag": the session binding. Prints "PASS <name>" / "FAIL <name>: <message>";
 * the exit status is the failure count. Fixtures are synthetic (no original bytes). tests/test_action_family_67_runtime.py
 * builds and runs this plainly, under ASan/UBSan and under source mutations. */
#include <stdio.h>
#include <string.h>

#include "session_bindings_a67.h"

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
    int32_t flag;
    unsigned calls;
} Sink;

static void set_flag(void *context, int32_t value)
{
    Sink *s = (Sink *)context;
    s->flag = value;
    ++s->calls;
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

static SessionA67Binding *make(Sink *sink)
{
    SessionA67Host host;
    memset(&host, 0, sizeof host);
    host.context = sink;
    host.set_start_flag = set_flag;
    return session_a67_create(&host);
}

static void binding_dispositions(void)
{
    static const uint8_t body[1] = {0u};
    const uint8_t subtypes[] = {0u, 1u, 2u, 3u, 255u};
    Sink sink = {7, 0};
    SessionA67Binding *bind = make(&sink);
    unsigned i;
    CHECK(bind != NULL);
    CHECK(session_a67_start_flag(bind) == 0);
    for (i = 0; i < sizeof subtypes; ++i) {
        SceneActionInfo info = row(0x67, subtypes[i], body, 1u);
        SceneActionRuntimeState before = {0u, 9u + i};
        SceneActionHandlerResult out = {SCENE_ACTION_HANDLER_PENDING, 0u};
        sink.flag = -5;
        CHECK(session_a67_handler(bind, i, &info, &before, &out) == SCENE_ACTION_HANDLER_OK);
        /* the arm sets the completion byte itself: no 0x42ba3a, no dependency reset, whatever the subtype, and the
         * phase word is not written */
        CHECK(out.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED);
        CHECK(out.phase == 9u + i);
        CHECK(sink.flag == 1); /* stored, not or-ed, whatever the previous value */
    }
    CHECK(sink.calls == sizeof subtypes);
    CHECK(session_a67_visits(bind) == sizeof subtypes && session_a67_start_flag(bind) == 1);
    CHECK(strcmp(session_a67_failure(bind), "none") == 0);
    session_a67_destroy(bind);
}

static void body_byte_is_never_read(void)
{
    uint8_t body[1];
    Sink sink = {0, 0};
    SessionA67Binding *bind = make(&sink);
    unsigned v;
    for (v = 0; v < 256u; v += 51u) {
        SceneActionInfo info;
        SceneActionRuntimeState before = {0u, 3u};
        SceneActionHandlerResult out = {SCENE_ACTION_HANDLER_PENDING, 0u};
        body[0] = (uint8_t)v;
        info = row(0x67, 1u, body, 1u);
        sink.flag = 0;
        CHECK(session_a67_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_OK);
        CHECK(sink.flag == 1 && out.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED && out.phase == 3u);
    }
    session_a67_destroy(bind);
}

static void binding_failures(void)
{
    static const uint8_t body[1] = {0u};
    static const uint8_t two[2] = {0u, 0u};
    Sink sink = {42, 0};
    SessionA67Host missing;
    SessionA67Binding *bind = make(&sink), *no_sink;
    SceneActionInfo info;
    SceneActionRuntimeState before = {0u, 4u};
    SceneActionHandlerResult out = {SCENE_ACTION_HANDLER_PENDING, 4u};
    memset(&missing, 0, sizeof missing);
    CHECK(session_a67_create(NULL) == NULL);
    no_sink = session_a67_create(&missing);
    CHECK(bind != NULL && no_sink != NULL);
    info = row(0x67, 1u, body, 1u);
    /* the host cannot take the flag: unsupported before any effect */
    CHECK(session_a67_handler(no_sink, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    CHECK(session_a67_visits(no_sink) == 0ul && session_a67_start_flag(no_sink) == 0);
    CHECK(strcmp(session_a67_failure(no_sink), "none") != 0);
    /* wrong type or body length */
    info = row(0x6e, 1u, body, 1u);
    CHECK(session_a67_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    info = row(0x67, 1u, two, 2u);
    CHECK(session_a67_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    info = row(0x67, 1u, body, 0u);
    CHECK(session_a67_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    info = row(0x67, 1u, body, 1u);
    CHECK(session_a67_handler(NULL, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_a67_handler(bind, 0u, NULL, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_a67_handler(bind, 0u, &info, NULL, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_a67_handler(bind, 0u, &info, &before, NULL) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(sink.flag == 42 && sink.calls == 0u && session_a67_visits(bind) == 0ul); /* no effect on any refusal */
    CHECK(session_a67_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_OK);
    CHECK(sink.flag == 1 && sink.calls == 1u);
    session_a67_destroy(bind);
    session_a67_destroy(no_sink);
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
    run("binding_dispositions", binding_dispositions, &failures);
    run("body_byte_is_never_read", body_byte_is_never_read, &failures);
    run("binding_failures", binding_failures, &failures);
    return failures;
}
