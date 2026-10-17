/* RT-57 executor-level check: the production scene executor (dependency gate mode 1, handler dispatch, pending phases, generic
 * completion) drives the real raw-0x1c binding with a scripted movie player and a synthetic ".IV" file. Arguments: scenes 1, 2
 * and 3 (written by tests/test_action_family_1c_runtime.py). Prints "PASS" / "FAIL <reason>".
 *
 *  scene 1   row 0: raw 0x1c (subtype 0), clip "CLIP", render word 1, ungated.
 *            tick 1 player idle (state 0): the file is opened and read, the row waits in phase 0;
 *            tick 2 player in state 2 with the clip and hotspot 11: z entry allocated and registered, phase 1, the render callback
 *            draws 2 rectangles;  tick 3 state 3: still phase 1, no hotspot lookup;  tick 4 state 2, hotspot 10: another change;
 *            tick 5 player gone: phase 2, still pending;  tick 6 phase 2: z entry released, file freed, generic completion;
 *            tick 7: a completed row is not visited again. The completion byte is stored directly (the generic completion would leave
 *            a subtype-0 byte alone) and the phase word reads 0.
 *  scene 2   row 0: raw 0x1c behind event flag 3 == 1: not visited (and nothing opened) until the flag is set.
 *  scene 3   row 0: raw 0x1c with subtype 2: the generic completion resets the completion byte and the row starts over. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_executor.h"
#include "session_bindings_a1c.h"

#define FLAGS 8u
#define EXPECT(cond)                                       \
    do {                                                   \
        if (!(cond)) {                                     \
            printf("FAIL line %d: %s\n", __LINE__, #cond); \
            return 1;                                      \
        }                                                  \
    } while (0)

typedef struct {
    int32_t *flags;
    uint8_t file[512];
    size_t file_len, pos;
    uint8_t clip[C1C_NAME_BYTES];
    int32_t state;
    int16_t hotspot;
    unsigned long opens, closes, allocs, registers, releases, state_reads;
    int16_t released_slot, registered_slot;
} Ctx;

static void put16(uint8_t *p, size_t at, uint16_t v)
{
    p[at] = (uint8_t)v;
    p[at + 1u] = (uint8_t)(v >> 8);
}

static void put32(uint8_t *p, size_t at, uint32_t v)
{
    put16(p, at, (uint16_t)v);
    put16(p, at + 2u, (uint16_t)(v >> 16));
}

/* "CLIP", entries 10 and 11 with 2 rectangles each (rectangle fields d[k] = 100 * entry + 10 * rect + k). */
static void build_file(Ctx *c)
{
    size_t at = C1C_NAME_BYTES;
    int i, j, k;
    memset(c->file, 0, sizeof c->file);
    memcpy(c->file, "CLIP", 4u);
    memcpy(c->clip, c->file, C1C_NAME_BYTES);
    put32(c->file, at, 2u);
    at += 4u;
    for (i = 0; i < 2; ++i) {
        put16(c->file, at, (uint16_t)(10 + i));
        put16(c->file, at + 2u, 2u);
        at += 9u;
        for (j = 0; j < 2; ++j) {
            for (k = 0; k < 6; ++k) put32(c->file, at + 4u * (size_t)k, (uint32_t)(100 * i + 10 * j + k));
            at += C1C_RECT_BYTES;
        }
    }
    c->file_len = at;
}

static int c_state(void *x, int32_t *v)
{
    Ctx *c = (Ctx *)x;
    ++c->state_reads;
    *v = c->state;
    return 0;
}

static int c_name(void *x, uint8_t name[C1C_NAME_BYTES])
{
    memcpy(name, ((Ctx *)x)->clip, C1C_NAME_BYTES);
    return 0;
}

static int c_hotspot(void *x, int16_t *v)
{
    *v = ((Ctx *)x)->hotspot;
    return 0;
}

static int c_origin(void *x, int *present, int32_t *dx, int32_t *dy)
{
    (void)x;
    *present = 1;
    *dx = 1000;
    *dy = 2000;
    return 0;
}

static int c_open(void *x, const char *name, void **file)
{
    Ctx *c = (Ctx *)x;
    ++c->opens;
    c->pos = 0u;
    if (strcmp(name, "CLIP") != 0) return 1;
    *file = c;
    return 0;
}

static size_t c_read(void *x, void *file, void *buffer, size_t size)
{
    Ctx *c = (Ctx *)x;
    size_t n = size < c->file_len - c->pos ? size : c->file_len - c->pos;
    (void)file;
    memcpy(buffer, c->file + c->pos, n);
    c->pos += n;
    return n;
}

static void c_close(void *x, void *file)
{
    (void)file;
    ++((Ctx *)x)->closes;
}

static int c_alloc(void *x, int16_t *slot)
{
    ++((Ctx *)x)->allocs;
    *slot = 0x1b;
    return 0;
}

static int c_register(void *x, int16_t slot, const char *label)
{
    Ctx *c = (Ctx *)x;
    ++c->registers;
    c->registered_slot = slot;
    return strcmp(label, "INTERACTIVE VIDEO DIAGS") == 0 ? 0 : 1;
}

static int c_release(void *x, int16_t slot)
{
    Ctx *c = (Ctx *)x;
    ++c->releases;
    c->released_slot = slot;
    return 0;
}

static int c_cell(void *x, int16_t *v)
{
    (void)x;
    *v = -1;
    return 0;
}

static unsigned char *load(const char *path, long *n)
{
    FILE *f = fopen(path, "rb");
    unsigned char *bytes;
    if (f == NULL) return NULL;
    fseek(f, 0, SEEK_END);
    *n = ftell(f);
    fseek(f, 0, SEEK_SET);
    bytes = malloc((size_t)*n);
    if (bytes == NULL || fread(bytes, 1, (size_t)*n, f) != (size_t)*n) return NULL;
    fclose(f);
    return bytes;
}

typedef struct {
    int32_t flags[FLAGS];
    ActionCoreWorld world;
    SceneConditionState state;
    SceneResource *scene;
    unsigned char *bytes;
    Ctx ctx;
    SceneActionExecutor *ex;
    SessionA1cBinding *binding;
    SceneActionHandler handler;
} Rig;

static int rig_open(Rig *r, const char *path)
{
    long n = 0;
    char err[128] = {0};
    size_t failed;
    C1cHost host;

    memset(r, 0, sizeof *r);
    r->bytes = load(path, &n);
    if (r->bytes == NULL) return 1;
    r->scene = scene_resource_open_memory(r->bytes, (size_t)n, err, sizeof err);
    if (r->scene == NULL) return 1;
    action_core_initialize_values(&r->world);
    r->world.event_flags = r->flags;
    r->world.event_flag_count = FLAGS;
    r->state.event_flags = r->flags;
    r->state.event_flag_count = FLAGS;
    r->ctx.flags = r->flags;
    build_file(&r->ctx);
    if (scene_executor_create(r->scene, &r->world, 0u, &r->ex, &failed) != SCENE_EXECUTOR_OK) return 1;
    memset(&host, 0, sizeof host);
    host.context = &r->ctx;
    host.player_state = c_state;
    host.player_name = c_name;
    host.player_hotspot = c_hotspot;
    host.player_origin = c_origin;
    host.open_iv = c_open;
    host.read = c_read;
    host.close = c_close;
    host.alloc_slot = c_alloc;
    host.register_slot = c_register;
    host.release_slot = c_release;
    host.cell_583a29 = c_cell;
    r->binding = session_a1c_create(&host);
    if (r->binding == NULL) return 1;
    r->handler.type = SESSION_A1C_TYPE;
    r->handler.callback = session_a1c_handler;
    r->handler.context = r->binding;
    return 0;
}

static void rig_close(Rig *r)
{
    scene_executor_destroy(r->ex);
    scene_resource_close(r->scene);
    session_a1c_destroy(r->binding);
    free(r->bytes);
}

static int rig_tick(Rig *r)
{
    SceneExecutorFrameInput frame;
    SceneExecutorStepInfo info;
    memset(&frame, 0, sizeof frame);
    return scene_executor_step_frame(r->ex, &r->state, &r->handler, 1u, &frame, &info);
}

int main(int argc, char **argv)
{
    Rig r;
    SceneActionRuntimeState st;
    C1cFill fills[8];
    size_t count = 0u;

    if (argc != 4) return 2;

    /* scene 1: the whole life of the row */
    EXPECT(rig_open(&r, argv[1]) == 0);
    r.ctx.state = 0;
    r.ctx.hotspot = -1;
    EXPECT(rig_tick(&r) == SCENE_EXECUTOR_OK);
    EXPECT(scene_executor_get_action_state(r.ex, 0u, &st) == SCENE_EXECUTOR_OK && st.completed == 0u && st.phase == 0u);
    EXPECT(r.ctx.opens == 1ul && r.ctx.closes == 1ul && r.ctx.allocs == 0ul && session_a1c_visits(r.binding) == 1ul);
    EXPECT(rig_tick(&r) == SCENE_EXECUTOR_OK);                         /* still idle: nothing is loaded again */
    EXPECT(r.ctx.opens == 1ul && session_a1c_visits(r.binding) == 2ul);
    r.ctx.state = 2;
    r.ctx.hotspot = 11;
    EXPECT(rig_tick(&r) == SCENE_EXECUTOR_OK);
    EXPECT(scene_executor_get_action_state(r.ex, 0u, &st) == SCENE_EXECUTOR_OK && st.completed == 0u && st.phase == 1u);
    EXPECT(r.ctx.allocs == 1ul && r.ctx.registers == 1ul && r.ctx.registered_slot == 0x1b && r.ctx.releases == 0ul);
    EXPECT(session_a1c_object(r.binding)->changed == 1);
    EXPECT(session_a1c_render(r.binding, 5, 6, fills, 8u, &count) == C1C_OK && count == 2u);
    EXPECT(fills[0].left == 101 + 1000 + 5 && fills[0].top == 102 + 2000 + 6 && fills[0].right == 103 + 1000 + 5);
    EXPECT(fills[0].bottom == 104 + 2000 + 6 && fills[0].color == 0x10 && fills[1].color == 0x410);
    EXPECT(session_a1c_render(r.binding, 5, 6, fills, 8u, &count) == C1C_OK && count == 0u); /* cleared by the first call */
    r.ctx.state = 3;
    EXPECT(rig_tick(&r) == SCENE_EXECUTOR_OK);
    EXPECT(scene_executor_get_action_state(r.ex, 0u, &st) == SCENE_EXECUTOR_OK && st.completed == 0u && st.phase == 1u);
    EXPECT(session_a1c_object(r.binding)->changed == 0 && session_a1c_object(r.binding)->record == NULL);
    r.ctx.state = 2;
    r.ctx.hotspot = 10;
    EXPECT(rig_tick(&r) == SCENE_EXECUTOR_OK);
    EXPECT(session_a1c_object(r.binding)->changed == 1 && session_a1c_object(r.binding)->last_index == 10);
    EXPECT(session_a1c_render(r.binding, 0, 0, fills, 8u, &count) == C1C_OK && count == 2u && fills[0].left == 1 + 1000);
    r.ctx.state = 0;
    EXPECT(rig_tick(&r) == SCENE_EXECUTOR_OK);
    EXPECT(scene_executor_get_action_state(r.ex, 0u, &st) == SCENE_EXECUTOR_OK && st.completed == 0u && st.phase == 2u);
    EXPECT(r.ctx.releases == 0ul);
    EXPECT(rig_tick(&r) == SCENE_EXECUTOR_OK);
    EXPECT(scene_executor_get_action_state(r.ex, 0u, &st) == SCENE_EXECUTOR_OK && st.completed == 1u && st.phase == 0u);
    EXPECT(r.ctx.releases == 1ul && r.ctx.released_slot == 0x1b && session_a1c_object(r.binding)->iv == NULL);
    {
        const unsigned long visits = session_a1c_visits(r.binding);
        EXPECT(rig_tick(&r) == SCENE_EXECUTOR_OK);                     /* completed rows are not visited again */
        EXPECT(session_a1c_visits(r.binding) == visits && r.ctx.releases == 1ul && r.ctx.opens == 1ul);
    }
    rig_close(&r);

    /* scene 2: the dependency gate */
    EXPECT(rig_open(&r, argv[2]) == 0);
    r.ctx.state = 2;
    r.ctx.hotspot = 10;
    EXPECT(rig_tick(&r) == SCENE_EXECUTOR_OK);
    EXPECT(session_a1c_visits(r.binding) == 0ul && r.ctx.opens == 0ul);
    EXPECT(scene_executor_get_action_state(r.ex, 0u, &st) == SCENE_EXECUTOR_OK && st.completed == 0u && st.phase == 0u);
    r.flags[3] = 1;
    EXPECT(rig_tick(&r) == SCENE_EXECUTOR_OK);
    EXPECT(session_a1c_visits(r.binding) == 1ul && r.ctx.opens == 1ul);
    EXPECT(scene_executor_get_action_state(r.ex, 0u, &st) == SCENE_EXECUTOR_OK && st.completed == 0u && st.phase == 1u);
    EXPECT(r.ctx.allocs == 1ul && session_a1c_object(r.binding)->changed == 1);
    rig_close(&r);

    /* scene 3: subtype 2 is a repeating row; its generic completion resets the completion byte and the row starts over */
    EXPECT(rig_open(&r, argv[3]) == 0);
    r.ctx.state = 2;
    r.ctx.hotspot = 10;
    EXPECT(rig_tick(&r) == SCENE_EXECUTOR_OK);
    EXPECT(scene_executor_get_action_state(r.ex, 0u, &st) == SCENE_EXECUTOR_OK && st.completed == 0u && st.phase == 1u);
    r.ctx.state = 0;
    EXPECT(rig_tick(&r) == SCENE_EXECUTOR_OK);                         /* the player is gone: phase 2 */
    EXPECT(scene_executor_get_action_state(r.ex, 0u, &st) == SCENE_EXECUTOR_OK && st.completed == 0u && st.phase == 2u);
    EXPECT(rig_tick(&r) == SCENE_EXECUTOR_OK);                         /* completes generically: byte 0, phase 0 */
    EXPECT(scene_executor_get_action_state(r.ex, 0u, &st) == SCENE_EXECUTOR_OK && st.completed == 0u && st.phase == 0u);
    EXPECT(r.ctx.releases == 1ul && session_a1c_object(r.binding)->iv == NULL);
    EXPECT(rig_tick(&r) == SCENE_EXECUTOR_OK);                         /* visited again from phase 0: the file is loaded again */
    EXPECT(r.ctx.opens == 2ul);
    rig_close(&r);
    printf("PASS\n");
    return 0;
}
