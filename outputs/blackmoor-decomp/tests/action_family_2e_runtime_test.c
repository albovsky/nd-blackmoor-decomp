/* RT-33 unit tests of raw 0x2e "random movie" control: the session binding. Prints "PASS <name>" / "FAIL <name>: <message>";
 * the exit status is the failure count. Fixtures are synthetic (no original bytes). tests/test_action_family_2e_runtime.py
 * builds and runs this plainly, under ASan/UBSan and under source mutations. */
#include <stdio.h>
#include <string.h>

#include "session_bindings_a2e.h"

#define TABLE 64u

static int g_failed;
static char g_msg[320];
#define CHECK(cond)                                                       \
    do {                                                                  \
        if (!(cond) && !g_failed) {                                       \
            g_failed = 1;                                                 \
            snprintf(g_msg, sizeof g_msg, "line %d: %s", __LINE__, #cond); \
        }                                                                 \
    } while (0)

typedef struct {
    int32_t flags[TABLE];
    ActionCoreWorld world;
    int32_t start_flag;
    unsigned start_calls;
    unsigned transitions;
    SceneTransitionRequest request;
    int refuse_transition;
    int effects[40];
    int32_t values[40];
    unsigned nfx;
} Rig;

static void set_start_flag(void *context, int32_t value)
{
    Rig *r = (Rig *)context;
    r->start_flag = value;
    ++r->start_calls;
}

static int transition(void *context, const SceneTransitionRequest *request)
{
    Rig *r = (Rig *)context;
    if (r->refuse_transition) return 1;
    r->request = *request;
    ++r->transitions;
    return 0;
}

static void observe(void *context, size_t row, int effect, int32_t value)
{
    Rig *r = (Rig *)context;
    (void)row;
    if (r->nfx < 40u) {
        r->effects[r->nfx] = effect;
        r->values[r->nfx] = value;
        ++r->nfx;
    }
}

static SessionA2EBinding *make(Rig *r, int with_start, int with_transition)
{
    SessionA2EHost host;
    memset(r, 0, sizeof *r);
    r->start_flag = -9;
    r->world.event_flags = r->flags;
    r->world.event_flag_count = TABLE;
    memset(&host, 0, sizeof host);
    host.context = r;
    host.set_start_flag = with_start ? set_start_flag : NULL;
    host.transition = with_transition ? transition : NULL;
    host.observe = observe;
    return session_a2e_create(&host, &r->world);
}

static void put16(uint8_t *body, unsigned offset, int v)
{
    body[offset] = (uint8_t)((unsigned)v & 0xffu);
    body[offset + 1u] = (uint8_t)(((unsigned)v >> 8) & 0xffu);
}

/* leading byte (the mode) and the seven words: scene, three transfer words, flag index, flag value, start flag word */
static void make_body(uint8_t *body, int mode, int scene, int w3, int w5, int w7, int flag, int value, int startword)
{
    memset(body, 0, 15u);
    body[0] = (uint8_t)mode;
    put16(body, 1u, scene);
    put16(body, 3u, w3);
    put16(body, 5u, w5);
    put16(body, 7u, w7);
    put16(body, 9u, flag);
    put16(body, 11u, value);
    put16(body, 13u, startword);
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

static int visit(SessionA2EBinding *b, size_t index, uint8_t subtype, const uint8_t *body, uint32_t phase,
                 SceneActionHandlerResult *out)
{
    SceneActionInfo info = row(0x2e, subtype, body, 15u);
    SceneActionRuntimeState before;
    before.completed = 0u;
    before.phase = phase;
    out->disposition = SCENE_ACTION_HANDLER_PENDING;
    out->phase = 0xdeadu;
    return session_a2e_handler(b, index, &info, &before, out);
}

static void inactive_object_only_stores_row_and_mode(void)
{
    Rig r;
    SessionA2EBinding *b = make(&r, 1, 1);
    const int modes[] = {0, 1, 2, 3, 127, 128, 255};
    unsigned i;
    CHECK(b != NULL);
    for (i = 0; i < sizeof modes / sizeof modes[0]; ++i) {
        uint8_t body[15];
        SceneActionHandlerResult out;
        const SessionA2EMovie *m;
        make_body(body, modes[i], 12, 3, 4, 5, 6, 7, 8);
        r.nfx = 0u;
        CHECK(visit(b, 5u + i, (uint8_t)i, body, 9u + i, &out) == SCENE_ACTION_HANDLER_OK);
        CHECK(out.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED && out.phase == 9u + i);
        m = session_a2e_movie(b);
        CHECK(m->row == (int32_t)(5u + i) && m->mode == (int32_t)(int8_t)modes[i]);
        CHECK(m->active == 0 && m->state_1de == 0 && m->flag_206 == 0 && m->pending_25a == 0);
        /* ordered stores: row, mode, completion byte; nothing else (no flag, no scene, no start flag) */
        CHECK(r.nfx == 3u && r.effects[0] == SESSION_A2E_FX_ROW && r.effects[1] == SESSION_A2E_FX_MODE &&
              r.effects[2] == SESSION_A2E_FX_DONE);
        CHECK(r.values[1] == (int32_t)(int8_t)modes[i]);
        CHECK(r.transitions == 0u && r.start_calls == 0u && r.flags[6] == 0);
    }
    CHECK(session_a2e_visits(b) == sizeof modes / sizeof modes[0]);
    session_a2e_destroy(b);
}

static void inactive_needs_no_provider(void)
{
    Rig r;
    SessionA2EBinding *b = make(&r, 0, 0);
    uint8_t body[15];
    SceneActionHandlerResult out;
    make_body(body, 1, 12, 3, 4, 5, 6, 7, 8);
    CHECK(b != NULL);
    CHECK(visit(b, 1u, 1u, body, 0u, &out) == SCENE_ACTION_HANDLER_OK);
    CHECK(out.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED);
    session_a2e_destroy(b);
}

static void active_mode_1_applies_the_block_in_order(void)
{
    Rig r;
    SessionA2EBinding *b = make(&r, 1, 1);
    SessionA2EMovie m = {1, 77, 77, 9, 9, 5};
    uint8_t body[15];
    SceneActionHandlerResult out;
    const int expect[] = {SESSION_A2E_FX_ROW, SESSION_A2E_FX_MODE, SESSION_A2E_FX_EVENT_FLAG, SESSION_A2E_FX_EVENT_VALUE,
                          SESSION_A2E_FX_XFER_5BB57B, SESSION_A2E_FX_XFER_5BB599, SESSION_A2E_FX_XFER_5BB595,
                          SESSION_A2E_FX_XFER_5C39FF, SESSION_A2E_FX_XFER_5BB59B, SESSION_A2E_FX_XFER_5BB59F,
                          SESSION_A2E_FX_XFER_5BB5A3, SESSION_A2E_FX_ENGINE_MODE, SESSION_A2E_FX_START_FLAG,
                          SESSION_A2E_FX_STATE_1DE, SESSION_A2E_FX_FLAG_206, SESSION_A2E_FX_DONE};
    unsigned i;
    session_a2e_set_movie(b, &m);
    make_body(body, 1, 0x1234, -2, 300, -400, 17, -3, 2);
    CHECK(visit(b, 3u, 1u, body, 4u, &out) == SCENE_ACTION_HANDLER_OK);
    CHECK(r.nfx == sizeof expect / sizeof expect[0]);
    for (i = 0; i < r.nfx && i < sizeof expect / sizeof expect[0]; ++i) CHECK(r.effects[i] == expect[i]);
    CHECK(r.flags[17] == -3);                                  /* sign-extended word */
    CHECK(r.transitions == 1u && r.request.target_scene == 0x1234 && r.request.opaque_words[0] == -2 &&
          r.request.opaque_words[1] == 300 && r.request.opaque_words[2] == -400);
    CHECK(r.request.opaque_dwords[0] == 0 && r.request.opaque_dwords[1] == 0 && r.request.opaque_dwords[2] == 1);
    CHECK(r.start_flag == 1 && r.start_calls == 1u);          /* word 2 != 1 */
    CHECK(session_a2e_movie(b)->state_1de == 2 && session_a2e_movie(b)->flag_206 == 0 && session_a2e_movie(b)->pending_25a == 5);
    CHECK(session_a2e_movie(b)->row == 3 && session_a2e_movie(b)->mode == 1);
    CHECK(out.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED && out.phase == 4u);
    session_a2e_destroy(b);
}

static void active_mode_1_optional_parts(void)
{
    Rig r;
    SessionA2EBinding *b = make(&r, 1, 1);
    SessionA2EMovie m = {2, 0, 0, 0, 0, 0};
    uint8_t body[15];
    SceneActionHandlerResult out;
    session_a2e_set_movie(b, &m);
    /* start flag word 1 stores 0; scene 9999 and flag -1 are skipped */
    make_body(body, 1, 9999, 1, 2, 3, -1, 55, 1);
    r.flags[0] = 123;
    CHECK(visit(b, 0u, 1u, body, 0u, &out) == SCENE_ACTION_HANDLER_OK);
    CHECK(r.transitions == 0u && r.flags[0] == 123 && r.start_flag == 0 && r.start_calls == 1u);
    CHECK(r.nfx == 6u);                                        /* row, mode, start flag, 1de, 206, done */
    /* the start flag is stored, not or-ed: any other word gives 1 (including 0 and -1) */
    make_body(body, 1, 9999, 0, 0, 0, -1, 0, 0);
    CHECK(visit(b, 0u, 1u, body, 0u, &out) == SCENE_ACTION_HANDLER_OK && r.start_flag == 1);
    make_body(body, 1, 9999, 0, 0, 0, -1, 0, -1);
    CHECK(visit(b, 0u, 1u, body, 0u, &out) == SCENE_ACTION_HANDLER_OK && r.start_flag == 1);
    /* flag index 0 is a real flag; scene 0 and -1 are real scene words */
    make_body(body, 1, 0, 0, 0, 0, 0, 9, 1);
    CHECK(visit(b, 0u, 1u, body, 0u, &out) == SCENE_ACTION_HANDLER_OK && r.flags[0] == 9 && r.transitions == 1u);
    make_body(body, 1, -1, 0, 0, 0, -1, 0, 1);
    CHECK(visit(b, 0u, 1u, body, 0u, &out) == SCENE_ACTION_HANDLER_OK && r.transitions == 2u && r.request.target_scene == -1);
    session_a2e_destroy(b);
}

static void active_mode_2_toggles_state(void)
{
    Rig r;
    SessionA2EBinding *b = make(&r, 0, 0);       /* mode 2 needs no provider */
    SessionA2EMovie m = {1, 0, 0, 7, 9, 0};
    uint8_t body[15];
    SceneActionHandlerResult out;
    session_a2e_set_movie(b, &m);
    make_body(body, 2, 5, 5, 5, 5, 5, 5, 5);
    CHECK(visit(b, 2u, 2u, body, 6u, &out) == SCENE_ACTION_HANDLER_OK);
    CHECK(session_a2e_movie(b)->state_1de == 0 && session_a2e_movie(b)->flag_206 == 1 && session_a2e_movie(b)->pending_25a == 0);
    CHECK(out.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED && out.phase == 6u);
    m.pending_25a = -4;
    m.state_1de = 8;
    session_a2e_set_movie(b, &m);
    r.nfx = 0u;
    CHECK(visit(b, 2u, 2u, body, 6u, &out) == SCENE_ACTION_HANDLER_OK);
    CHECK(session_a2e_movie(b)->state_1de == 3 && session_a2e_movie(b)->flag_206 == 1 && session_a2e_movie(b)->pending_25a == 0);
    CHECK(r.nfx == 6u && r.effects[2] == SESSION_A2E_FX_STATE_1DE && r.effects[3] == SESSION_A2E_FX_PENDING_25A &&
          r.effects[4] == SESSION_A2E_FX_FLAG_206);
    CHECK(r.flags[5] == 0 && r.start_calls == 0u && r.transitions == 0u);
    session_a2e_destroy(b);
}

static void active_other_modes_do_nothing(void)
{
    Rig r;
    SessionA2EBinding *b = make(&r, 1, 1);
    SessionA2EMovie m = {1, 0, 0, 4, 4, 4};
    const int modes[] = {3, 4, 100, 127, 128, 200, 255};
    unsigned i;
    for (i = 0; i < sizeof modes / sizeof modes[0]; ++i) {
        uint8_t body[15];
        SceneActionHandlerResult out;
        make_body(body, modes[i], 1, 2, 3, 4, 5, 6, 7);
        session_a2e_set_movie(b, &m);
        r.nfx = 0u;
        CHECK(visit(b, 1u, 1u, body, 0u, &out) == SCENE_ACTION_HANDLER_OK);
        CHECK(r.nfx == 3u && session_a2e_movie(b)->state_1de == 4 && session_a2e_movie(b)->flag_206 == 4 &&
              session_a2e_movie(b)->pending_25a == 4);
        CHECK(r.transitions == 0u && r.start_calls == 0u && r.flags[5] == 0);
    }
    session_a2e_destroy(b);
}

static void active_mode_0_is_refused_before_any_effect(void)
{
    Rig r;
    SessionA2EBinding *b = make(&r, 1, 1);
    SessionA2EMovie m = {1, 11, 12, 13, 14, 15};
    uint8_t body[15];
    SceneActionHandlerResult out;
    session_a2e_set_movie(b, &m);
    make_body(body, 0, 12, 3, 4, 5, 6, 7, 8);
    CHECK(visit(b, 9u, 1u, body, 0u, &out) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    CHECK(strcmp(session_a2e_failure(b), "none") != 0);
    CHECK(r.nfx == 0u && r.transitions == 0u && r.start_calls == 0u && r.flags[6] == 0);
    CHECK(memcmp(session_a2e_movie(b), &m, sizeof m) == 0 && session_a2e_visits(b) == 0ul);
    session_a2e_destroy(b);
}

static void active_mode_1_refusals_and_refused_transition(void)
{
    Rig r;
    SessionA2EBinding *no_start = make(&r, 0, 1), *b;
    SessionA2EMovie m = {1, 11, 12, 13, 14, 15};
    uint8_t body[15];
    SceneActionHandlerResult out;
    Rig r2, r3;
    SessionA2EBinding *no_trans = make(&r2, 1, 0);
    SessionA2EBinding *refuse = make(&r3, 1, 1);
    session_a2e_set_movie(no_start, &m);
    session_a2e_set_movie(no_trans, &m);
    session_a2e_set_movie(refuse, &m);
    make_body(body, 1, 12, 3, 4, 5, 6, 7, 8);
    CHECK(visit(no_start, 9u, 1u, body, 0u, &out) == SCENE_ACTION_HANDLER_UNSUPPORTED && r.nfx == 0u &&
          memcmp(session_a2e_movie(no_start), &m, sizeof m) == 0);
    CHECK(visit(no_trans, 9u, 1u, body, 0u, &out) == SCENE_ACTION_HANDLER_UNSUPPORTED && r2.nfx == 0u && r2.flags[6] == 0 &&
          memcmp(session_a2e_movie(no_trans), &m, sizeof m) == 0);
    /* no scene change in the row: the transition provider is not needed */
    make_body(body, 1, 9999, 3, 4, 5, 6, 7, 8);
    CHECK(visit(no_trans, 9u, 1u, body, 0u, &out) == SCENE_ACTION_HANDLER_OK && r2.flags[6] == 7);
    /* a refused request: error; the stores made before it (row, mode, event flag) are kept, as in the original order, none after */
    make_body(body, 1, 12, 3, 4, 5, 6, 7, 8);
    r3.refuse_transition = 1;
    CHECK(visit(refuse, 9u, 1u, body, 0u, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(r3.start_calls == 0u && session_a2e_visits(refuse) == 0ul);
    /* event flag index outside the table or below -1: refused before any effect */
    b = make(&r, 1, 1);
    session_a2e_set_movie(b, &m);
    make_body(body, 1, 12, 3, 4, 5, (int)TABLE, 7, 8);
    CHECK(visit(b, 9u, 1u, body, 0u, &out) == SCENE_ACTION_HANDLER_ERROR && r.nfx == 0u && r.start_calls == 0u);
    make_body(body, 1, 12, 3, 4, 5, -2, 7, 8);
    CHECK(visit(b, 9u, 1u, body, 0u, &out) == SCENE_ACTION_HANDLER_ERROR && r.nfx == 0u && r.start_calls == 0u);
    make_body(body, 1, 12, 3, 4, 5, -32768, 7, 8);
    CHECK(visit(b, 9u, 1u, body, 0u, &out) == SCENE_ACTION_HANDLER_ERROR && r.nfx == 0u);
    make_body(body, 1, 12, 3, 4, 5, 32767, 7, 8);
    CHECK(visit(b, 9u, 1u, body, 0u, &out) == SCENE_ACTION_HANDLER_ERROR && r.nfx == 0u);
    make_body(body, 1, 12, 3, 4, 5, (int)TABLE - 1, 7, 8);
    CHECK(visit(b, 9u, 1u, body, 0u, &out) == SCENE_ACTION_HANDLER_OK && r.flags[TABLE - 1u] == 7);
    CHECK(memcmp(session_a2e_movie(b), &m, sizeof m) != 0);
    session_a2e_destroy(no_start);
    session_a2e_destroy(no_trans);
    session_a2e_destroy(refuse);
    session_a2e_destroy(b);
}

static void argument_failures(void)
{
    Rig r;
    SessionA2EBinding *b = make(&r, 1, 1);
    uint8_t body[15];
    uint8_t shorter[14] = {0};
    uint8_t longer[16] = {0};
    uint8_t with_tail[31] = {0};
    SceneActionInfo info;
    SceneActionRuntimeState before = {0u, 4u};
    SceneActionHandlerResult out = {SCENE_ACTION_HANDLER_PENDING, 4u};
    SessionA2EHost host;
    ActionCoreWorld world;
    memset(&host, 0, sizeof host);
    memset(&world, 0, sizeof world);
    CHECK(session_a2e_create(NULL, &r.world) == NULL);
    CHECK(session_a2e_create(&host, NULL) == NULL);
    make_body(body, 2, 0, 0, 0, 0, 0, 0, 0);
    info = row(0x6e, 1u, body, 15u);
    CHECK(session_a2e_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    info = row(0x2e, 1u, shorter, 14u);
    CHECK(session_a2e_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    info = row(0x2e, 1u, longer, 16u);
    CHECK(session_a2e_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    info = row(0x2e, 1u, with_tail, 31u);   /* a body plus one dependency record is decodable but is not the typed body */
    CHECK(session_a2e_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    info = row(0x2e, 1u, NULL, 15u);
    CHECK(session_a2e_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    info = row(0x2e, 1u, body, 15u);
    CHECK(session_a2e_handler(NULL, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_a2e_handler(b, 0u, NULL, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_a2e_handler(b, 0u, &info, NULL, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_a2e_handler(b, 0u, &info, &before, NULL) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(r.nfx == 0u && session_a2e_visits(b) == 0ul && session_a2e_movie(b)->row == 0);
    CHECK(session_a2e_movie(NULL) == NULL && session_a2e_visits(NULL) == 0ul);
    CHECK(session_a2e_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_OK);
    session_a2e_destroy(b);
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
    run("inactive_object_only_stores_row_and_mode", inactive_object_only_stores_row_and_mode, &failures);
    run("inactive_needs_no_provider", inactive_needs_no_provider, &failures);
    run("active_mode_1_applies_the_block_in_order", active_mode_1_applies_the_block_in_order, &failures);
    run("active_mode_1_optional_parts", active_mode_1_optional_parts, &failures);
    run("active_mode_2_toggles_state", active_mode_2_toggles_state, &failures);
    run("active_other_modes_do_nothing", active_other_modes_do_nothing, &failures);
    run("active_mode_0_is_refused_before_any_effect", active_mode_0_is_refused_before_any_effect, &failures);
    run("active_mode_1_refusals_and_refused_transition", active_mode_1_refusals_and_refused_transition, &failures);
    run("argument_failures", argument_failures, &failures);
    return failures;
}
