/* RT-40 unit tests of raw 0x1b (two-table scene-change hotspot): kernel and session binding. Prints "PASS <name>" / "FAIL <name>:
 * <message>"; the exit status is the failure count. The scene file (argv[1]) is written by tests/test_action_family_1b_runtime.py
 * from synthetic rows (no original bytes): row 0 a 0x1b row with primary keys {5, 9} and secondary selectors {7, 3, 7}, row 1 a 0x1b
 * row with no records, row 2 a 0x45 row the binding must ignore. See that file for the exact values. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "session_bindings_a1b.h"

static int g_failed;
static char g_msg[160];
static const char *g_scene_path;
#define CHECK(cond)                                                       \
    do {                                                                  \
        if (!(cond) && !g_failed) {                                       \
            g_failed = 1;                                                 \
            snprintf(g_msg, sizeof g_msg, "line %d: %s", __LINE__, #cond); \
        }                                                                 \
    } while (0)

typedef struct {
    Action1bWorld world;
    int load_fails;
    int transition_fails;
    unsigned loads, stores, transitions;
    SceneTransitionRequest last;
    struct { size_t row; int effect; int32_t value; } fx[40];
    unsigned fx_count;
} Host;

static int load_world(void *context, Action1bWorld *world)
{
    Host *h = (Host *)context;
    ++h->loads;
    if (h->load_fails) return 1;
    *world = h->world;
    return 0;
}

static void store_world(void *context, const Action1bWorld *world)
{
    Host *h = (Host *)context;
    ++h->stores;
    h->world.start_flag_5bb1ca = world->start_flag_5bb1ca;
}

static int transition(void *context, const SceneTransitionRequest *request)
{
    Host *h = (Host *)context;
    ++h->transitions;
    h->last = *request;
    return h->transition_fails;
}

static void observe(void *context, size_t row, int effect, int32_t value)
{
    Host *h = (Host *)context;
    if (h->fx_count < 40u) {
        h->fx[h->fx_count].row = row;
        h->fx[h->fx_count].effect = effect;
        h->fx[h->fx_count].value = value;
    }
    ++h->fx_count;
}

static SessionA1bBinding *make(Host *host, int with_transition)
{
    SessionA1bHost h;
    memset(&h, 0, sizeof h);
    h.context = host;
    h.load_world = load_world;
    h.store_world = store_world;
    h.transition = with_transition ? transition : NULL;
    h.observe = observe;
    return session_a1b_create(&h);
}

static unsigned char *g_bytes;
static long g_bytes_length;

static SceneResource *open_scene(void)
{
    char err[128] = {0};
    if (g_bytes == NULL) {
        FILE *f = fopen(g_scene_path, "rb");
        if (f == NULL) return NULL;
        fseek(f, 0, SEEK_END);
        g_bytes_length = ftell(f);
        fseek(f, 0, SEEK_SET);
        g_bytes = (unsigned char *)malloc((size_t)g_bytes_length);
        if (g_bytes == NULL || fread(g_bytes, 1, (size_t)g_bytes_length, f) != (size_t)g_bytes_length) return NULL;
        fclose(f);
    }
    return scene_resource_open_memory(g_bytes, (size_t)g_bytes_length, err, sizeof err);
}

static int visit(SessionA1bBinding *b, SceneResource *scene, size_t index, uint32_t phase, int *disposition, uint32_t *phase_out)
{
    SceneActionInfo info;
    SceneActionRuntimeState before = {0u, phase};
    SceneActionHandlerResult out = {SCENE_ACTION_HANDLER_COMPLETED, 77u};
    int status;
    if (scene_resource_action_at(scene, index, &info) != SCENE_RESOURCE_OK) return -1;
    status = session_a1b_handler(b, index, &info, &before, &out);
    if (disposition != NULL) *disposition = (int)out.disposition;
    if (phase_out != NULL) *phase_out = out.phase;
    return status;
}

static void world_init(Host *h, int16_t selector, int16_t held)
{
    memset(h, 0, sizeof *h);
    h->world.selector = selector;
    h->world.held_item = held;
}

/* phase 0 registers the row, phase 1 scans the secondary table on the selector (first hit wins), a miss clears the request */
static void hover_phases(void)
{
    Host h;
    SessionA1bBinding *b;
    SceneResource *scene = open_scene();
    SessionInputHotspot row;
    Action17Slot slot;
    int disposition = -1;
    uint32_t phase = 0u;
    world_init(&h, 7, -1);
    b = make(&h, 1);
    CHECK(b != NULL && scene != NULL);
    CHECK(session_a1b_begin_scene(b, scene) == ACTION17_OK && session_a1b_row_count(b) == 3u);
    CHECK(session_a1b_pointer_row(b, 0u, &row) == 0 && session_a1b_pointer_row(b, 2u, &row) == 0);
    /* phase 0: start flag, phase 1, then the phase-1 scan in the same call */
    CHECK(visit(b, scene, 0u, 0u, &disposition, &phase) == SCENE_ACTION_HANDLER_OK);
    CHECK(disposition == SCENE_ACTION_HANDLER_PENDING && phase == 1u);
    CHECK(h.world.start_flag_5bb1ca == 1 && h.stores == 1u);
    CHECK(h.fx_count == 8u && h.fx[0].effect == ACTION17_FX_START_FLAG && h.fx[1].effect == ACTION17_FX_PHASE && h.fx[1].value == 1 &&
          h.fx[2].effect == ACTION17_FX_REQUEST && h.fx[2].value == 0 && h.fx[3].effect == ACTION17_FX_REQUEST && h.fx[3].value == 1 &&
          h.fx[4].effect == ACTION17_FX_LEFT && h.fx[5].effect == ACTION17_FX_TOP && h.fx[6].effect == ACTION17_FX_RIGHT &&
          h.fx[7].effect == ACTION17_FX_BOTTOM);
    /* the FIRST secondary record with selector 7 supplies the rectangle (low words of the dwords) */
    CHECK(session_a1b_slot(b, 0u, &slot) == ACTION17_OK && slot.request == 1 && slot.left == 0x0111 && slot.top == 0x0222 &&
          slot.right == 0x0333 && slot.bottom == 0x0444 && slot.done == 0u);
    CHECK(session_a1b_pointer_row(b, 0u, &row) == 1 && row.index == 0 && row.active == 1u && row.rectangle.left == 0x0111 &&
          row.rectangle.bottom == 0x0444);
    /* phase 1 again with another selector: a miss clears the request and leaves the rectangle */
    h.world.selector = 3;
    h.fx_count = 0u;
    CHECK(visit(b, scene, 0u, 1u, &disposition, &phase) == SCENE_ACTION_HANDLER_OK && phase == 1u);
    CHECK(session_a1b_slot(b, 0u, &slot) == ACTION17_OK && slot.request == 1 && slot.left == 0x0555);
    h.world.selector = 99;
    CHECK(visit(b, scene, 0u, 1u, &disposition, &phase) == SCENE_ACTION_HANDLER_OK && phase == 1u);
    CHECK(session_a1b_slot(b, 0u, &slot) == ACTION17_OK && slot.request == 0 && slot.left == 0x0555);
    CHECK(session_a1b_pointer_row(b, 0u, &row) == 0);
    /* the pre-gate clears the request (0x427ad4) */
    h.world.selector = 3;
    CHECK(visit(b, scene, 0u, 1u, &disposition, &phase) == SCENE_ACTION_HANDLER_OK);
    CHECK(session_a1b_slot(b, 0u, &slot) == ACTION17_OK && slot.request == 1);
    session_a1b_pre_gate(b, 0u, NULL, NULL);
    CHECK(session_a1b_slot(b, 0u, &slot) == ACTION17_OK && slot.request == 0);
    /* an empty row never matches; a row of another type is not ours */
    h.world.selector = 0;
    CHECK(visit(b, scene, 1u, 0u, &disposition, &phase) == SCENE_ACTION_HANDLER_OK && phase == 1u);
    CHECK(session_a1b_slot(b, 1u, &slot) == ACTION17_OK && slot.request == 0);
    h.world.selector = 7;
    CHECK(visit(b, scene, 1u, 1u, &disposition, &phase) == SCENE_ACTION_HANDLER_OK);
    CHECK(session_a1b_slot(b, 1u, &slot) == ACTION17_OK && slot.request == 0);
    CHECK(visit(b, scene, 2u, 0u, &disposition, &phase) == SCENE_ACTION_HANDLER_ERROR);
    session_a1b_destroy(b);
    scene_resource_close(scene);
}

/* phase 2: completion byte, the held-item record or the fixed block, mode 4 through the transition request */
static void finish_phase(void)
{
    Host h;
    SessionA1bBinding *b;
    SceneResource *scene = open_scene();
    Action17Slot slot;
    int disposition = -1;
    uint32_t phase = 0u;
    world_init(&h, 7, 9);
    b = make(&h, 1);
    CHECK(b != NULL && scene != NULL && session_a1b_begin_scene(b, scene) == ACTION17_OK);
    CHECK(visit(b, scene, 0u, 2u, &disposition, &phase) == SCENE_ACTION_HANDLER_OK);
    CHECK(disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED && phase == 2u);
    CHECK(h.transitions == 1u && h.last.target_scene == 4009 && h.last.opaque_words[0] == -2 && h.last.opaque_words[1] == 3 &&
          h.last.opaque_words[2] == 4 && h.last.opaque_dwords[0] == 90 && h.last.opaque_dwords[1] == -91 &&
          h.last.opaque_dwords[2] == 92);
    CHECK(h.fx_count == 9u && h.fx[0].effect == ACTION17_FX_DONE && h.fx[1].effect == ACTION17_FX_XFER_5BB57B &&
          h.fx[1].value == 4009 && h.fx[7].effect == ACTION17_FX_XFER_5BB5A3 && h.fx[8].effect == ACTION17_FX_MODE &&
          h.fx[8].value == 4);
    CHECK(session_a1b_slot(b, 0u, &slot) == ACTION17_OK && slot.done == 1u);
    /* the first record of two with the same key (9) won above; a different key picks its own record */
    h.world.held_item = 5;
    CHECK(visit(b, scene, 0u, 2u, &disposition, &phase) == SCENE_ACTION_HANDLER_OK);
    CHECK(h.last.target_scene == 4005 && h.last.opaque_dwords[0] == 50);
    /* no record: the object's fixed block (words 1..4, dwords 0..2), the target sign-extended */
    h.world.held_item = 1234;
    CHECK(visit(b, scene, 0u, 2u, &disposition, &phase) == SCENE_ACTION_HANDLER_OK);
    CHECK(h.last.target_scene == -3 && h.last.opaque_words[0] == 7 && h.last.opaque_words[1] == -8 && h.last.opaque_words[2] == 9 &&
          h.last.opaque_dwords[0] == 70000 && h.last.opaque_dwords[1] == -71000 && h.last.opaque_dwords[2] == 72);
    /* a row with no records also finishes from the fixed block */
    CHECK(visit(b, scene, 1u, 2u, &disposition, &phase) == SCENE_ACTION_HANDLER_OK && disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED);
    CHECK(h.last.target_scene == -30 && h.last.opaque_dwords[2] == 9);
    /* any other phase has no effect */
    h.fx_count = 0u;
    h.transitions = 0u;
    CHECK(visit(b, scene, 0u, 3u, &disposition, &phase) == SCENE_ACTION_HANDLER_OK);
    CHECK(disposition == SCENE_ACTION_HANDLER_PENDING && phase == 3u && h.fx_count == 0u && h.transitions == 0u);
    session_a1b_destroy(b);
    scene_resource_close(scene);
}

/* host refusals leave the row untouched: no world, no transition provider, a refused transition */
static void host_refusals(void)
{
    Host h;
    SessionA1bBinding *b;
    SceneResource *scene = open_scene();
    Action17Slot slot;
    int disposition = -1;
    uint32_t phase = 0u;
    world_init(&h, 7, 9);
    b = make(&h, 1);
    CHECK(b != NULL && scene != NULL && session_a1b_begin_scene(b, scene) == ACTION17_OK);
    h.load_fails = 1;
    CHECK(visit(b, scene, 0u, 0u, &disposition, &phase) == SCENE_ACTION_HANDLER_UNSUPPORTED && h.fx_count == 0u && h.stores == 0u);
    h.load_fails = 0;
    h.transition_fails = 1;
    CHECK(visit(b, scene, 0u, 2u, &disposition, &phase) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_a1b_slot(b, 0u, &slot) == ACTION17_OK && slot.done == 0u && h.stores == 0u);
    CHECK(strstr(session_a1b_failure(b), "refused") != NULL);
    session_a1b_destroy(b);
    b = make(&h, 0);
    CHECK(b != NULL && session_a1b_begin_scene(b, scene) == ACTION17_OK);
    h.fx_count = 0u;
    CHECK(visit(b, scene, 0u, 2u, &disposition, &phase) == SCENE_ACTION_HANDLER_UNSUPPORTED && h.fx_count == 0u);
    CHECK(visit(b, scene, 0u, 1u, &disposition, &phase) == SCENE_ACTION_HANDLER_OK);
    session_a1b_destroy(b);
    scene_resource_close(scene);
}

/* cascade case 0x4f22ad: the first fixed word without a held item, the held item's own cursor otherwise */
static void hover_cursor(void)
{
    Host h;
    SessionA1bBinding *b;
    SceneResource *scene = open_scene();
    Action17Cursor c;
    world_init(&h, 0, -1);
    b = make(&h, 1);
    CHECK(b != NULL && scene != NULL && session_a1b_begin_scene(b, scene) == ACTION17_OK);
    CHECK(session_a1b_hover_cursor(b, 0u, -1, &c) == ACTION17_OK && c.cursor_index == 11 && c.variant == 1 && c.held_flag == 0 &&
          c.surface == ACTION17_SURFACE_UNCHANGED && c.table_offset == 11 * 32 + 16);
    CHECK(session_a1b_hover_cursor(b, 0u, 4, &c) == ACTION17_OK && c.cursor_index == 4 + 0x25 && c.surface == ACTION17_SURFACE_HELD &&
          c.table_offset == (4 + 0x25) * 32 + 16);
    CHECK(session_a1b_hover_cursor(b, 1u, -1, &c) == ACTION17_OK && c.cursor_index == 22);
    CHECK(session_a1b_hover_cursor(b, 2u, -1, &c) != ACTION17_OK);
    session_a1b_destroy(b);
    scene_resource_close(scene);
}

int main(int argc, char **argv)
{
    struct { const char *name; void (*fn)(void); } cases[] = {
        {"hover_phases", hover_phases}, {"finish_phase", finish_phase}, {"host_refusals", host_refusals}, {"hover_cursor", hover_cursor},
    };
    size_t i, failures = 0u;
    if (argc != 2) return 2;
    g_scene_path = argv[1];
    for (i = 0u; i < sizeof cases / sizeof cases[0]; ++i) {
        g_failed = 0;
        g_msg[0] = '\0';
        cases[i].fn();
        if (g_failed) {
            ++failures;
            printf("FAIL %s: %s\n", cases[i].name, g_msg);
        } else {
            printf("PASS %s\n", cases[i].name);
        }
    }
    free(g_bytes);
    return (int)failures;
}
