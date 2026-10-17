/* RT-40 native side of the raw 0x1b oracle (tests/action_family_1b_runtime_original_oracle.py).
 *
 * One handle owns the real session binding, the scene it was started on, the host world cells (selector 0x5bb50b, held item
 * 0x583a29, start flag 0x5bb1ca) and the log of effects the kernel reported (in order: row, Action17Effect, value), including the
 * pre-gate request clears. a1bo_pregate() and a1bo_visit() perform what the executor does for an open row (pre-gate before the
 * gate, handler after a true gate); a1bo_cascade() runs the production pointer scan over the binding's rows and derives the hover
 * cursor of the hit. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "session_bindings_a1b.h"
#include "session_input.h"

typedef struct {
    size_t row;
    int effect;
    int32_t value;
} Effect;

typedef struct {
    unsigned char *scene_bytes;
    SceneResource *scene;
    SessionA1bBinding *binding;
    Action1bWorld world;
    Effect *fx;
    unsigned fx_count, fx_cap;
    unsigned transitions;
    SceneTransitionRequest last;
} Handle;

static int load_world(void *context, Action1bWorld *world)
{
    *world = ((Handle *)context)->world;
    return 0;
}

static void store_world(void *context, const Action1bWorld *world)
{
    ((Handle *)context)->world.start_flag_5bb1ca = world->start_flag_5bb1ca;
}

static int transition(void *context, const SceneTransitionRequest *request)
{
    Handle *h = (Handle *)context;
    ++h->transitions;
    h->last = *request;
    return 0;
}

static void observe(void *context, size_t row, int effect, int32_t value)
{
    Handle *h = (Handle *)context;
    if (h->fx_count == h->fx_cap) {
        h->fx_cap = h->fx_cap ? h->fx_cap * 2u : 256u;
        h->fx = (Effect *)realloc(h->fx, h->fx_cap * sizeof(*h->fx));
        if (h->fx == NULL) abort();
    }
    h->fx[h->fx_count].row = row;
    h->fx[h->fx_count].effect = effect;
    h->fx[h->fx_count].value = value;
    ++h->fx_count;
}

void *a1bo_new(void)
{
    Handle *h = (Handle *)calloc(1u, sizeof(*h));
    SessionA1bHost host;
    if (h == NULL) return NULL;
    memset(&host, 0, sizeof host);
    host.context = h;
    host.load_world = load_world;
    host.store_world = store_world;
    host.transition = transition;
    host.observe = observe;
    h->binding = session_a1b_create(&host);
    if (h->binding == NULL) {
        free(h);
        return NULL;
    }
    h->world.held_item = -1;
    return h;
}

void a1bo_free(void *handle)
{
    Handle *h = (Handle *)handle;
    if (h == NULL) return;
    session_a1b_destroy(h->binding);
    if (h->scene != NULL) scene_resource_close(h->scene);
    free(h->scene_bytes);
    free(h->fx);
    free(h);
}

int a1bo_begin(void *handle, const unsigned char *scene, unsigned length)
{
    Handle *h = (Handle *)handle;
    char err[128] = {0};
    unsigned char *copy = (unsigned char *)malloc(length);
    SceneResource *opened;
    int status;
    if (copy == NULL) return -1;
    memcpy(copy, scene, length);
    opened = scene_resource_open_memory(copy, length, err, sizeof err);
    if (opened == NULL) {
        free(copy);
        return -2;
    }
    status = session_a1b_begin_scene(h->binding, opened);
    if (status != ACTION17_OK) {
        scene_resource_close(opened);
        free(copy);
        return status;
    }
    if (h->scene != NULL) scene_resource_close(h->scene);
    free(h->scene_bytes);
    h->scene = opened;
    h->scene_bytes = copy;
    h->fx_count = 0u;
    h->transitions = 0u;
    return 0;
}

void a1bo_set_world(void *handle, int selector, int held, int start_flag)
{
    Handle *h = (Handle *)handle;
    h->world.selector = (int16_t)selector;
    h->world.held_item = (int16_t)held;
    h->world.start_flag_5bb1ca = start_flag;
}

int a1bo_start_flag(void *handle)
{
    return ((Handle *)handle)->world.start_flag_5bb1ca;
}

void a1bo_pregate(void *handle, unsigned row)
{
    Handle *h = (Handle *)handle;
    SceneActionInfo info;
    SceneActionRuntimeState st = {0u, 0u};
    if (scene_resource_action_at(h->scene, row, &info) != SCENE_RESOURCE_OK) return;
    session_a1b_pre_gate(h->binding, row, &info, &st);
}

/* Returns the handler status; *disposition and *phase_out as returned, *done_out the completion byte the executor would store. */
int a1bo_visit(void *handle, unsigned row, int completed, unsigned phase, int *disposition, unsigned *phase_out, int *done_out)
{
    Handle *h = (Handle *)handle;
    SceneActionInfo info;
    SceneActionRuntimeState before;
    SceneActionHandlerResult out = {SCENE_ACTION_HANDLER_PENDING, 0u};
    int status;
    before.completed = (uint8_t)completed;
    before.phase = phase;
    if (scene_resource_action_at(h->scene, row, &info) != SCENE_RESOURCE_OK) return -1;
    status = session_a1b_handler(h->binding, row, &info, &before, &out);
    *disposition = (int)out.disposition;
    *phase_out = out.phase;
    *done_out = completed || out.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED ? 1 : 0;
    return status;
}

unsigned a1bo_fx_count(void *handle)
{
    return ((Handle *)handle)->fx_count;
}

void a1bo_fx_get(void *handle, unsigned i, int *row, int *effect, int *value)
{
    const Effect *e = &((Handle *)handle)->fx[i];
    *row = (int)e->row;
    *effect = e->effect;
    *value = (int)e->value;
}

void a1bo_fx_clear(void *handle)
{
    ((Handle *)handle)->fx_count = 0u;
}

unsigned a1bo_transitions(void *handle)
{
    return ((Handle *)handle)->transitions;
}

int a1bo_slot(void *handle, unsigned row, int *request, int *left, int *top, int *right, int *bottom, int *done)
{
    Action17Slot s;
    if (session_a1b_slot(((Handle *)handle)->binding, row, &s) != ACTION17_OK) return -1;
    *request = s.request;
    *left = s.left;
    *top = s.top;
    *right = s.right;
    *bottom = s.bottom;
    *done = s.done;
    return 0;
}

/* The generic row loop of the pointer cascade over the binding's rows: first hit (the candidate) and its hover cursor. */
int a1bo_cascade(void *handle, int held, int x, int y, int *candidate, int *cursor_index, int *variant, int *held_flag, int *surface,
                 int *table_offset)
{
    Handle *h = (Handle *)handle;
    size_t count = session_a1b_row_count(h->binding), i, n = 0u;
    SessionInputHotspot *spots = (SessionInputHotspot *)calloc(count != 0u ? count : 1u, sizeof(*spots));
    SessionInputState state;
    SessionInputContext ctx;
    Action17Cursor cursor;
    int status;
    if (spots == NULL) return -1;
    for (i = 0u; i < count; ++i) {
        if (session_a1b_pointer_row(h->binding, i, &spots[n]) == 1) ++n;
    }
    memset(&ctx, 0, sizeof ctx);
    ctx.viewport.left = 0;
    ctx.viewport.top = 0;
    ctx.viewport.right = 639;
    ctx.viewport.bottom = 479;
    ctx.cursor.left = ctx.cursor.right = x;
    ctx.cursor.top = ctx.cursor.bottom = y;
    ctx.geometry_ready = 1u;
    ctx.priority_clear = 1u;
    ctx.excluded_0 = -1;
    ctx.excluded_1 = -1;
    session_input_init(&state);
    session_input_publish_candidate(&state, -1);
    status = session_input_scan(&state, &ctx, spots, n);
    free(spots);
    if (status != 0) return status;
    *candidate = state.candidate;
    *cursor_index = *variant = *held_flag = *surface = *table_offset = 0;
    if (state.candidate >= 0 && session_a1b_hover_cursor(h->binding, (size_t)state.candidate, (int16_t)held, &cursor) == ACTION17_OK) {
        *cursor_index = cursor.cursor_index;
        *variant = cursor.variant;
        *held_flag = cursor.held_flag;
        *surface = cursor.surface;
        *table_offset = cursor.table_offset;
    }
    return 0;
}
