#include "session_bindings_a3f.h"

#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define CHECK(expr) do { if (!(expr)) { \
    fprintf(stderr, "CHECK line=%d expression=%s\n", __LINE__, #expr); return 1; \
} } while (0)

typedef struct Fixture {
    SessionA3fBinding *binding;
    SceneResource *source, *incoming, *too_long, *cel;
    Convo3fWorld world;
    ActionSoundBackend sound;
    int32_t events[4], presence[4];
    unsigned resolves, loads, plays, polls, unloads, world_loads, world_stores, transitions;
    unsigned headers, released_headers, readers, resumes, destroyed_readers, layers, freed_layers;
    uint8_t header[CONVO3F_CEL_HEADER_BYTES + 2u * CONVO3F_CEL_FRAME_STRIDE];
} Fixture;

typedef struct Snapshot {
    const uint8_t *image;
    uint8_t bytes[CONVO3F_IMAGE_BYTES];
    Convo3fManager manager;
    Convo3fWorld world;
    Convo3fStepResult last;
    unsigned loads, plays, polls, unloads, world_loads, world_stores, transitions;
    int modal;
} Snapshot;

static void unexpected_signal(int signum)
{
    static const char message[] = "CHECK unexpected native signal\n";
    (void)signum; (void)write(STDERR_FILENO, message, sizeof(message) - 1u); _exit(1);
}

static SceneResource *open_scene(const char *path)
{
    uint8_t bytes[8192];
    char error[160];
    FILE *file = fopen(path, "rb");
    size_t count;
    SceneResource *scene;
    if (file == NULL) return NULL;
    count = fread(bytes, 1u, sizeof(bytes), file);
    if (ferror(file) || !feof(file)) { (void)fclose(file); return NULL; }
    (void)fclose(file);
    scene = scene_resource_open_memory(bytes, count, error, sizeof(error));
    if (scene == NULL) fprintf(stderr, "CHECK scene parser: %s\n", error);
    return scene;
}

static int load_world(void *context, Convo3fWorld *world)
{
    Fixture *f = context; ++f->world_loads; *world = f->world; return 0;
}
static void store_world(void *context, const Convo3fWorld *world)
{
    Fixture *f = context; ++f->world_stores; f->world = *world;
}
static int resolve_text(void *context, const uint8_t *key, size_t key_length,
    const uint8_t **text, size_t *length)
{
    static const uint8_t ordinary[] = "A supported caption";
    Fixture *f = context;
    ++f->resolves;
    if (key_length == 4u && memcmp(key, "LONG", 4u) == 0) {
        /* Valid text metadata exceeds the constructor's 1499-byte field.
         * The declared span is complete; no invalid memory is presented. */
        static uint8_t visible[1500];
        memset(visible, 'x', sizeof(visible));
        *text = visible; *length = sizeof(visible);
    } else { *text = ordinary; *length = sizeof(ordinary) - 1u; }
    return 0;
}
static int transition(void *context, const SceneTransitionRequest *request)
{ Fixture *f = context; (void)request; ++f->transitions; return 0; }
static ActionSoundBackendStatus sound_load(void *context, const ActionSoundAudioCommand *command)
{ Fixture *f = context; (void)command; ++f->loads; return ACTION_SOUND_BACKEND_OK; }
static ActionSoundBackendStatus sound_play(void *context, uint16_t channel)
{ Fixture *f = context; (void)channel; ++f->plays; return ACTION_SOUND_BACKEND_OK; }
static ActionSoundBackendStatus sound_poll(void *context, uint16_t channel, int *playing)
{ Fixture *f = context; (void)channel; ++f->polls; *playing = 0; return ACTION_SOUND_BACKEND_OK; }
static ActionSoundBackendStatus sound_unload(void *context, uint16_t channel)
{ Fixture *f = context; (void)channel; ++f->unloads; return ACTION_SOUND_BACKEND_OK; }

/* Metadata-only cel host: no decoder, device, thread or render surface is
 * created. These are the ordinary callback results used by the native model. */
static int cel_header(void *context, const uint8_t *name, const uint8_t **block, size_t *bytes)
{ Fixture *f = context; (void)name; ++f->headers; *block = f->header; *bytes = sizeof(f->header); return 0; }
static int cel_index(void *context, const uint8_t *name, int16_t *index)
{ (void)context; (void)name; *index = 1; return 0; }
static int cel_info(void *context, int16_t index, uint8_t *kind, uint8_t *transparency)
{ (void)context; (void)index; *kind = 0u; *transparency = 2u; return 0; }
static int cel_layer(void *context, int16_t index, const uint8_t *name, Convo3fCelLayer *layer)
{
    Fixture *f = context; (void)index; (void)name;
    ++f->layers; memset(layer, 0, sizeof(*layer)); layer->loaded = 1u; layer->surface = f->layers;
    layer->src[2] = layer->src[3] = layer->dst[2] = layer->dst[3] = 1;
    return 0;
}
static int cel_free(void *context, int16_t slot, int layer, uint32_t surface)
{ Fixture *f = context; (void)slot; (void)layer; (void)surface; ++f->freed_layers; return 0; }
static int cel_release(void *context) { ++((Fixture *)context)->released_headers; return 0; }
static int reader_create(void *context) { ++((Fixture *)context)->readers; return 0; }
static int reader_resume(void *context) { ++((Fixture *)context)->resumes; return 0; }
static int reader_destroy(void *context) { ++((Fixture *)context)->destroyed_readers; return 0; }
static int sync_init(void *context, uint16_t channel, uint16_t frames, uint32_t param)
{ (void)context; (void)channel; (void)frames; (void)param; return 0; }
static int sync_frame(void *context, uint16_t channel, int *playing, int32_t *frame)
{ (void)context; (void)channel; *playing = 1; *frame = 0; return 0; }

static int setup(Fixture *f, char **paths)
{
    SessionA3fHost host;
    memset(f, 0, sizeof(*f)); memset(&host, 0, sizeof(host));
    f->source = open_scene(paths[0]); f->incoming = open_scene(paths[1]);
    f->too_long = open_scene(paths[2]); f->cel = open_scene(paths[3]);
    CHECK(f->source && f->incoming && f->too_long && f->cel);
    f->world.events = f->events; f->world.event_count = 4u;
    f->world.presence = f->presence; f->world.presence_count = 4u;
    f->world.held_item = -1; f->world.mode_583999 = 3;
    f->world.selected_570374 = CONVO3F_NO_SELECTION;
    f->world.ui_5b0a76 = 100; f->world.ui_5b0a1e = 50; f->world.ui_5b0a16 = 10;
    f->sound.context = f; f->sound.load_sound = sound_load; f->sound.play_sound = sound_play;
    f->sound.is_playing = sound_poll; f->sound.unload_sound = sound_unload;
    host.kernel.context = f; host.kernel.sound = &f->sound;
    host.load_world = load_world; host.store_world = store_world;
    host.resolve_text = resolve_text; host.transition = transition;
    host.kernel.cel_load_header = cel_header; host.kernel.cel_tree_index = cel_index;
    host.kernel.cel_tree_info = cel_info; host.kernel.cel_load_layer = cel_layer;
    host.kernel.cel_free_layer = cel_free; host.kernel.cel_release_header = cel_release;
    host.kernel.cel_reader_create = reader_create; host.kernel.cel_reader_resume = reader_resume;
    host.kernel.cel_reader_destroy = reader_destroy;
    host.kernel.sound_sync_init = sync_init; host.kernel.sound_sync_frame = sync_frame;
    f->header[0x24] = 1u;
    memcpy(f->header + CONVO3F_CEL_HEADER_BYTES, "frame0", 7u);
    memcpy(f->header + CONVO3F_CEL_HEADER_BYTES + CONVO3F_CEL_FRAME_STRIDE, "frame1", 7u);
    f->binding = session_a3f_create(&host);
    CHECK(f->binding && session_a3f_begin_scene(f->binding, f->source) == CONVO3F_OK);
    CHECK(session_a3f_image(f->binding, 0u) && session_a3f_image(f->binding, 2u));
    return 0;
}

static void cleanup(Fixture *f)
{
    session_a3f_destroy(f->binding);
    scene_resource_close(f->source); scene_resource_close(f->incoming);
    scene_resource_close(f->too_long); scene_resource_close(f->cel);
}

static int visit(Fixture *f, const SceneResource *source, size_t local, size_t global,
    SceneActionRuntimeState *state)
{
    SceneActionInfo action;
    SceneActionHandlerResult result;
    CHECK(!state->completed && scene_resource_action_at(source, local, &action) == SCENE_RESOURCE_OK);
    CHECK(session_a3f_handler(f->binding, global, &action, state, &result) == SCENE_ACTION_HANDLER_OK);
    state->phase = result.phase;
    state->completed = result.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED;
    return 0;
}

static void take_snapshot(Fixture *f, Snapshot *s)
{
    s->image = session_a3f_image(f->binding, 0u);
    memcpy(s->bytes, s->image, sizeof(s->bytes));
    memcpy(&s->manager, session_a3f_manager(f->binding), sizeof(s->manager));
    memcpy(&s->world, &f->world, sizeof(s->world));
    memcpy(&s->last, session_a3f_last_result(f->binding), sizeof(s->last));
    s->loads = f->loads; s->plays = f->plays; s->polls = f->polls; s->unloads = f->unloads;
    s->world_loads = f->world_loads; s->world_stores = f->world_stores; s->transitions = f->transitions;
    s->modal = session_a3f_modal_active(f->binding);
}
static int unchanged(Fixture *f, const Snapshot *s)
{
    CHECK(session_a3f_image(f->binding, 0u) == s->image);
    CHECK(memcmp(session_a3f_image(f->binding, 0u), s->bytes, sizeof(s->bytes)) == 0);
    CHECK(memcmp(session_a3f_manager(f->binding), &s->manager, sizeof(s->manager)) == 0);
    CHECK(memcmp(&f->world, &s->world, sizeof(s->world)) == 0);
    CHECK(memcmp(session_a3f_last_result(f->binding), &s->last, sizeof(s->last)) == 0);
    CHECK(session_a3f_modal_active(f->binding) == s->modal);
    CHECK(f->loads == s->loads && f->plays == s->plays && f->polls == s->polls && f->unloads == s->unloads);
    CHECK(f->world_loads == s->world_loads && f->world_stores == s->world_stores && f->transitions == s->transitions);
    return 0;
}

static SceneActionSlotPlan retained_contract_plan(size_t incoming)
{
    SceneActionSlotPlan plan = {0};
    plan.source_high_water = 3u; plan.retained_high_water = 2u;
    plan.final_high_water = 2u + incoming; plan.incoming_count = incoming;
    plan.retired[2] = 1u;
    for (size_t i = 0; i < incoming; ++i) plan.assigned[i] = (uint16_t)(2u + i);
    return plan;
}

static int retained_contract(Fixture *f)
{
    /* Provider ownership contract only: the supplied plan retains row0.
     * Canonical 43e484 retires every runtime3f/3e and is tested separately. */
    SceneActionSlotPlan plan = retained_contract_plan(1u);
    SceneActionRuntimeState state = {0};
    SessionA3fAppend *append = NULL;
    Snapshot snapshot;
    unsigned resolves;
    CHECK(visit(f, f->source, 0u, 0u, &state) == 0 && state.phase == 1u);
    take_snapshot(f, &snapshot);
    resolves = f->resolves;
    CHECK(snapshot.modal && snapshot.manager.row == 0);
    CHECK(session_a3f_prepare_no_art(f->binding, f->incoming, &plan, &append) == CONVO3F_OK);
    CHECK(f->resolves == resolves + 1u); /* Incoming caption only. */
    CHECK(session_a3f_can_commit_no_art(f->binding, append) && unchanged(f, &snapshot) == 0);
    CHECK(session_a3f_can_commit_no_art(f->binding, append) && unchanged(f, &snapshot) == 0);
    CHECK(session_a3f_commit_no_art(f->binding, append) == CONVO3F_OK);
    CHECK(f->resolves == resolves + 1u);
    CHECK(!session_a3f_can_commit_no_art(f->binding, append));
    session_a3f_discard_no_art(append);
    CHECK(unchanged(f, &snapshot) == 0 && session_a3f_image(f->binding, 2u));
    CHECK(visit(f, f->source, 0u, 0u, &state) == 0 && state.phase == 1u);
    return 0;
}

static int canonical_retirement(Fixture *f)
{
    uint8_t occupied[3] = {1, 1, 1}, types[3] = {0x3f, 0x4d, 0x3f};
    SceneActionSlotPlan plan;
    SceneActionRuntimeState state = {0};
    SessionA3fAppend *append = NULL;
    unsigned unloads;
    for (unsigned i = 0; i < 6u && !state.completed; ++i) CHECK(visit(f, f->source, 0u, 0u, &state) == 0);
    CHECK(state.completed && !session_a3f_image(f->binding, 0u));
    CHECK(strcmp(session_a3f_row_reason(f->binding, 0u), "released") == 0);
    CHECK(session_a3f_image(f->binding, 2u)); /* An incomplete owned arena. */
    unloads = f->unloads;
    CHECK(scene_action_slots_plan_no_art(3u, occupied, types, 0, 1u, &plan) == SCENE_ACTION_SLOTS_OK);
    CHECK(plan.retired[0] && plan.retired[2] && plan.assigned[0] == 0u && plan.final_high_water == 2u);
    CHECK(session_a3f_prepare_no_art(f->binding, f->incoming, &plan, &append) == CONVO3F_OK);
    CHECK(!session_a3f_image(f->binding, 0u) && session_a3f_image(f->binding, 2u));
    CHECK(session_a3f_commit_no_art(f->binding, append) == CONVO3F_OK);
    session_a3f_discard_no_art(append);
    CHECK(session_a3f_image(f->binding, 0u) && !session_a3f_image(f->binding, 2u));
    CHECK(session_a3f_row_reason(f->binding, 0u) == NULL && f->unloads == unloads);
    state = (SceneActionRuntimeState){0};
    for (unsigned i = 0; i < 6u && !state.completed; ++i) CHECK(visit(f, f->incoming, 0u, 0u, &state) == 0);
    CHECK(state.completed && !session_a3f_image(f->binding, 0u));
    CHECK(scene_action_slots_plan_no_art(2u, occupied, types, 0, 1u, &plan) == SCENE_ACTION_SLOTS_OK);
    CHECK(session_a3f_prepare_no_art(f->binding, f->incoming, &plan, &append) == CONVO3F_OK);
    CHECK(session_a3f_commit_no_art(f->binding, append) == CONVO3F_OK);
    session_a3f_discard_no_art(append);
    CHECK(session_a3f_image(f->binding, 0u));
    return 0;
}

static int inert_and_stale(Fixture *f)
{
    SceneActionSlotPlan plan = retained_contract_plan(1u), failed_plan = retained_contract_plan(2u);
    SceneActionRuntimeState state = {0};
    SessionA3fAppend *append = NULL;
    Snapshot snapshot;
    unsigned resolves;
    CHECK(visit(f, f->source, 0u, 0u, &state) == 0);
    take_snapshot(f, &snapshot);
    resolves = f->resolves;
    CHECK(session_a3f_prepare_no_art(f->binding, f->too_long, &failed_plan, &append) == CONVO3F_ERR_UNSUPPORTED);
    CHECK(f->resolves == resolves + 2u); /* First build succeeds, second refuses. */
    CHECK(append == NULL && unchanged(f, &snapshot) == 0 && session_a3f_image(f->binding, 2u));
    CHECK(session_a3f_prepare_no_art(f->binding, f->incoming, &plan, &append) == CONVO3F_OK);
    CHECK(unchanged(f, &snapshot) == 0);
    session_a3f_discard_no_art(append);
    CHECK(unchanged(f, &snapshot) == 0 && session_a3f_image(f->binding, 2u));
    CHECK(session_a3f_prepare_no_art(f->binding, f->incoming, &plan, &append) == CONVO3F_OK);
    CHECK(session_a3f_can_commit_no_art(f->binding, append));
    CHECK(visit(f, f->source, 0u, 0u, &state) == 0);
    take_snapshot(f, &snapshot);
    CHECK(!session_a3f_can_commit_no_art(f->binding, append));
    CHECK(session_a3f_commit_no_art(f->binding, append) == CONVO3F_ERR_ARGUMENT);
    CHECK(unchanged(f, &snapshot) == 0);
    session_a3f_discard_no_art(append);
    CHECK(unchanged(f, &snapshot) == 0);
    return 0;
}

static int active_cel_refusal(Fixture *f)
{
    uint8_t occupied = 1u, type = 0x3e;
    SceneActionSlotPlan plan;
    SceneActionRuntimeState state = {0};
    SessionA3fAppend *append = NULL;
    Snapshot snapshot;
    unsigned resolves;
    int ran;
    CHECK(session_a3f_begin_scene(f->binding, f->cel) == CONVO3F_OK);
    CHECK(visit(f, f->cel, 0u, 0u, &state) == 0 && state.phase == 1u);
    CHECK(session_a3f_cel_active(f->binding) && f->readers == 1u && f->resumes == 1u);
    CHECK(session_a3f_cel_reader_pass(f->binding, &ran) == CONVO3F_OK && ran == 1 && f->layers == 1u);
    take_snapshot(f, &snapshot); resolves = f->resolves;
    CHECK(scene_action_slots_plan_no_art(1u, &occupied, &type, 0, 1u, &plan) == SCENE_ACTION_SLOTS_OK);
    CHECK(session_a3f_prepare_no_art(f->binding, f->incoming, &plan, &append) == CONVO3F_ERR_UNSUPPORTED);
    CHECK(append == NULL && unchanged(f, &snapshot) == 0 && f->resolves == resolves);
    CHECK(session_a3f_cel_active(f->binding) && !f->destroyed_readers && !f->released_headers && !f->freed_layers);
    CHECK(session_a3f_cel_reader_pass(f->binding, &ran) == CONVO3F_OK && ran == 1 && f->layers == 2u);
    session_a3f_destroy(f->binding); f->binding = NULL;
    CHECK(f->destroyed_readers == 1u && f->released_headers == 1u && f->freed_layers == 2u);
    return 0;
}

static int active_sound_refusal(Fixture *f)
{
    const uint8_t occupied[3] = {1, 1, 1}, types[3] = {0x3f, 0x4d, 0x3f};
    SceneActionSlotPlan plan;
    SceneActionRuntimeState state = {0};
    SessionA3fAppend *append = NULL;
    Snapshot snapshot;
    unsigned resolves;
    CHECK(visit(f, f->source, 0u, 0u, &state) == 0 && state.phase == 1u);
    take_snapshot(f, &snapshot);
    resolves = f->resolves;
    CHECK(snapshot.modal && snapshot.manager.row == 0);
    CHECK(scene_action_slots_plan_no_art(3u, occupied, types, 0, 1u, &plan) == SCENE_ACTION_SLOTS_OK);
    CHECK(plan.retired[0] && session_a3f_prepare_no_art(f->binding, f->incoming, &plan, &append) == CONVO3F_ERR_UNSUPPORTED);
    CHECK(append == NULL && f->resolves == resolves && unchanged(f, &snapshot) == 0);
    CHECK(session_a3f_image(f->binding, 0u) && session_a3f_modal_active(f->binding));
    return 0;
}

int main(int argc, char **argv)
{
    Fixture fixture;
    int result = 1;
    (void)signal(SIGABRT, unexpected_signal); (void)signal(SIGBUS, unexpected_signal);
    (void)signal(SIGFPE, unexpected_signal); (void)signal(SIGILL, unexpected_signal); (void)signal(SIGSEGV, unexpected_signal);
    if (argc != 6 || setup(&fixture, argv + 2) != 0) return 1;
    if (strcmp(argv[1], "retained") == 0) result = retained_contract(&fixture);
    else if (strcmp(argv[1], "retired") == 0) result = canonical_retirement(&fixture);
    else if (strcmp(argv[1], "inert") == 0) result = inert_and_stale(&fixture);
    else if (strcmp(argv[1], "cel") == 0) result = active_cel_refusal(&fixture);
    else if (strcmp(argv[1], "busy") == 0) result = active_sound_refusal(&fixture);
    cleanup(&fixture);
    if (!result) printf("PASS scene_no_art_a3f %s\n", argv[1]);
    return result;
}
