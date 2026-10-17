/* RT-46 binding-level cases for raw 0x33: the scene parser, session_bindings_a33.c (media gate, phase mapping, the finish
 * branch's scene-change request, the pre-gate request clear and the pointer row) over a scripted host. The scene comes from
 * tests/test_action_family_33_runtime.py. Prints "PASS"/"FAIL <reason>". */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "session_bindings_a33.h"

#define EXPECT(cond)                                       \
    do {                                                   \
        if (!(cond)) {                                     \
            printf("FAIL line %d: %s\n", __LINE__, #cond); \
            return 1;                                      \
        }                                                  \
    } while (0)

typedef struct {
    int media;
    int refuse_transition;
    int transitions;
    SceneTransitionRequest last;
    int ops;
    int ready;
    int loads, stores;
} Ctx;

static int op_cb(void *c, int op, const A33OpArgs *args, int32_t *ret)
{
    Ctx *x = (Ctx *)c;
    (void)args;
    ++x->ops;
    *ret = (op == A33_OP_SURFACE_CREATE || op == A33_OP_THREAD_CREATE) ? 0x100 : 0;
    return 0;
}

static void load_cb(void *c, A33State *st)
{
    Ctx *x = (Ctx *)c;
    ++x->loads;
    st->selector_5bb50b = 3;
    st->clip_5bb583[2] = 639;
    st->clip_5bb583[3] = 479;
    st->ready_5b4e0a = (int16_t)x->ready;
}

static void store_cb(void *c, const A33State *st)
{
    (void)st;
    ++((Ctx *)c)->stores;
}

static int transition_cb(void *c, const SceneTransitionRequest *request)
{
    Ctx *x = (Ctx *)c;
    ++x->transitions;
    x->last = *request;
    return x->refuse_transition;
}

static int media_cb(void *c)
{
    return ((Ctx *)c)->media;
}

int main(int argc, char **argv)
{
    FILE *f;
    unsigned char *bytes;
    long n;
    char err[128] = {0};
    SceneResource *scene;
    SceneActionInfo info;
    SceneActionRuntimeState before = {0u, 0u};
    SceneActionHandlerResult out;
    SessionA33Host host;
    SessionA33Binding *b;
    SessionInputHotspot hot;
    Ctx ctx;

    if (argc != 2 || (f = fopen(argv[1], "rb")) == NULL) return 2;
    fseek(f, 0, SEEK_END);
    n = ftell(f);
    fseek(f, 0, SEEK_SET);
    bytes = (unsigned char *)malloc((size_t)n);
    if (bytes == NULL || fread(bytes, 1, (size_t)n, f) != (size_t)n) return 2;
    fclose(f);
    scene = scene_resource_open_memory(bytes, (size_t)n, err, sizeof err);
    EXPECT(scene != NULL);
    EXPECT(scene_resource_action_at(scene, 0u, &info) == SCENE_RESOURCE_OK && info.type == SESSION_A33_TYPE);

    memset(&ctx, 0, sizeof ctx);
    memset(&host, 0, sizeof host);
    host.kernel.context = &ctx;
    host.kernel.op = op_cb;
    host.load_world = load_cb;
    host.store_world = store_cb;
    host.transition = transition_cb;
    host.media_available = media_cb;
    b = session_a33_create(&host);
    EXPECT(b != NULL);
    EXPECT(session_a33_begin_scene(b, scene) == A33_OK && session_a33_row_count(b) == 1u);
    EXPECT(session_a33_row(b, 0u) != NULL);

    /* no media backend: phase 0 is refused before any effect */
    EXPECT(session_a33_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    EXPECT(ctx.ops == 0 && ctx.loads == 0);

    /* phase 0 runs the init and the first play pass: PENDING, phase 1 */
    ctx.media = 1;
    EXPECT(session_a33_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_OK);
    EXPECT(out.disposition == SCENE_ACTION_HANDLER_PENDING && out.phase == 1u && ctx.ops > 0);
    EXPECT(ctx.loads == 1 && ctx.stores == 1);
    EXPECT(session_a33_state(b)->active_5c39f1 == 1 && session_a33_state(b)->thread_5b4e0c == 0x100u);

    /* a scene load runs the scene clear: latch, row/kind words and the surface go, the reader thread stays for the next phase 0 */
    EXPECT(session_a33_state(b)->surface_5d03bf == 0x100u);
    EXPECT(session_a33_begin_scene(b, scene) == A33_OK && session_a33_state(b)->active_5c39f1 == 0);
    EXPECT(session_a33_state(b)->thread_5b4e0c == 0x100u && session_a33_state(b)->surface_5d03bf == 0u);
    EXPECT(session_a33_state(b)->row_5b4e89 == -1 && session_a33_state(b)->kind_5b4e8b == 1 && session_a33_state(b)->latch_5c39e5 == -1);

    /* the executor restarts the action at phase 0 on the new scene */
    before.phase = 0u;
    ctx.ready = 0;
    EXPECT(session_a33_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_OK && out.phase == 1u);

    /* a flagged frame with a matching hotspot: the first pass runs the rectangles (kind 2 request cells) */
    before.phase = 1u;
    ctx.ready = 1;
    EXPECT(session_a33_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_OK);
    EXPECT(out.disposition == SCENE_ACTION_HANDLER_PENDING && out.phase == 1u);
    EXPECT(session_a33_pointer_row(b, 0u, &hot) == 1 && hot.index == 0 && hot.active == 1u);
    session_a33_pre_gate(b, 0u, &info, &before);
    EXPECT(session_a33_pointer_row(b, 0u, &hot) == 0);

    /* phase 2 without a flagged frame stays open; with one it asks for the scene change and completes with phase 0 */
    before.phase = 2u;
    ctx.ready = 0;
    EXPECT(session_a33_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_OK);
    EXPECT(out.disposition == SCENE_ACTION_HANDLER_PENDING && out.phase == 2u && ctx.transitions == 0);
    ctx.ready = 1;
    ctx.refuse_transition = 1;
    EXPECT(session_a33_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    EXPECT(ctx.transitions == 1);
    ctx.refuse_transition = 0;
    EXPECT(session_a33_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_OK);
    EXPECT(out.disposition == SCENE_ACTION_HANDLER_COMPLETED && out.phase == 0u && ctx.transitions == 2);
    EXPECT(ctx.last.target_scene == 1234 && ctx.last.opaque_words[0] == 5 && ctx.last.opaque_words[1] == 6 &&
           ctx.last.opaque_words[2] == 7 && ctx.last.opaque_dwords[0] == 70 && ctx.last.opaque_dwords[1] == 80 &&
           ctx.last.opaque_dwords[2] == 90);

    /* a row index the binding does not own */
    EXPECT(session_a33_handler(b, 1u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);

    /* a row of another type is refused */
    info.type = 0x34;
    EXPECT(session_a33_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    info.type = SESSION_A33_TYPE;

    /* a failed parse leaves no row owned */
    bytes[0x1f + 6] = 0;
    EXPECT(session_a33_begin_scene(b, scene) == A33_OK && session_a33_row_count(b) == 1u);
    for (size_t i = 0; i < (size_t)n - 33u; ++i) {
        if (memcmp(bytes + i, "CLIP01", 6) == 0) { memset(bytes + i, 'x', 33); break; }
    }
    {
        char err2[128] = {0};
        SceneResource *bad = scene_resource_open_memory(bytes, (size_t)n, err2, sizeof err2);
        EXPECT(bad != NULL);
        EXPECT(session_a33_begin_scene(b, bad) != A33_OK && session_a33_row_count(b) == 0u && session_a33_row(b, 0u) == NULL);
        scene_resource_close(bad);
    }

    session_a33_destroy(b);
    scene_resource_close(scene);
    free(bytes);
    printf("PASS\n");
    return 0;
}
