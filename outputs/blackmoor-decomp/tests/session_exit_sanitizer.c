/* ASan/UBSan fixture for the RT-5 scene-exit module and the 0x28 binding.
 * Bounded malformed input only: random and boundary exit-state values
 * (including invalid game states, stages, effect types and rectangles), hosts
 * that fail at every boundary, hostile 0x28 bodies and phases, and random
 * caption geometry for the ClearSceneData caption block. */
#include "../src/session_bindings_a28.h"
#include "../src/session_exit.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define CHECK(condition, label) do { \
    if (!(condition)) { \
        fprintf(stderr, "sanitizer fixture failed: %s\n", label); \
        return 1; \
    } \
} while (0)

static uint32_t random_state = UINT32_C(0x52543543);
static unsigned cases, host_failures, unsupported_count, ok_count, ran_count;
static unsigned a28_ok, a28_error;

static uint32_t next_random(void)
{
    uint32_t value = random_state;
    value ^= value << 13;
    value ^= value >> 17;
    value ^= value << 5;
    random_state = value;
    return value;
}

typedef struct {
    unsigned fail_at;      /* 1-based boundary call that fails; 0 = never */
    unsigned calls;
    uint32_t tick;
    uint32_t sources[6];
    uint32_t destinations[6];
} Host;

static int boundary(Host *host)
{
    ++host->calls;
    return host->fail_at != 0u && host->calls == host->fail_at ? 7 : 0;
}

static int nested(void *context) { return boundary((Host *)context); }
static int capture(void *context, SessionExitCapture which)
{
    (void)which;
    return boundary((Host *)context);
}
static int clear_destination(void *context) { return boundary((Host *)context); }

static int get_tick(void *context, uint32_t *out)
{
    Host *host = (Host *)context;
    host->tick += 1u + (next_random() & 3u);
    *out = host->tick;
    return 0;
}
static int blend(void *context, const ActionFamily28SequenceFrame *frame)
{
    (void)context;
    (void)frame;
    return 0;
}
static int pump(void *context)
{
    (void)context;
    return 0;
}

static int run_sequence(void *context, ActionFamily28SequenceState *state)
{
    Host *host = (Host *)context;
    ActionFamily28SequenceCallbacks callbacks;
    ActionFamily28SequenceReport report;
    const uint16_t words[2] = {0x027f, 0x037f};
    if (boundary(host) != 0) {
        return 7;
    }
    state->source_capture.data = (const uint8_t *)host->sources;
    state->source_capture.byte_length = sizeof(host->sources);
    state->destination_capture.data = (const uint8_t *)host->destinations;
    state->destination_capture.byte_length = sizeof(host->destinations);
    state->capture_width_pixels = 2u;
    state->capture_height_pixels = 1u;
    state->capture_stride_pixels = 2u;
    state->capture_offset_x_pixels = next_random() % 3u;
    state->capture_offset_y_pixels = next_random() % 2u;
    state->primary_target = (uint8_t)(next_random() % 3u);
    memset(&callbacks, 0, sizeof(callbacks));
    callbacks.context = host;
    callbacks.get_tick_count = get_tick;
    callbacks.blend_present = blend;
    callbacks.system_audio_pump = pump;
    /* The kernel validates the capture span and the control word itself;
     * errors (bad offsets, primary_target) map to a host failure. */
    return action_family28_run_sequence(state, &callbacks, words[next_random() & 1u],
                                        &report) == ACTION_FAMILY28_OK ? 0 : 9;
}

static void random_exit(SessionExit *x)
{
    ActionFamily28Rect view = {10, 10, 629, 384};
    static const int32_t interesting[] = {0, 1, -1, 2, 3, 4, 5, 255, 256, INT32_MAX,
                                          INT32_MIN};
    size_t i;
    session_exit_init(x, &view);
    x->g.game_state = (next_random() % 10u < 7u) ? 3u + next_random() % 2u : next_random() % 7u;
    x->g.load_game_flag = (next_random() & 7u) == 0u;
    x->g.popup_flag = (next_random() & 7u) != 0u;
    x->g.modal_input = interesting[next_random() % 11u];
    x->g.cursor_layer = interesting[next_random() % 11u];
    x->g.redraw_request = interesting[next_random() % 11u];
    x->effect.busy = (uint8_t)(next_random() % 4u != 0u);
    x->effect.sequence_counter = (next_random() % 10u < 8u) ? next_random() % 3u : next_random() % 7u;
    x->effect.current_rect.left = interesting[next_random() % 11u];
    x->effect.current_rect.top = interesting[next_random() % 11u];
    x->effect.current_rect.right = interesting[next_random() % 11u];
    x->effect.current_rect.bottom = interesting[next_random() % 11u];
    if (next_random() & 1u) {
        x->effect.current_rect = (ActionFamily28Rect){10, 0, 11, 0};
    }
    for (i = 0; i < sizeof(x->effect.active_payload); ++i) {
        x->effect.active_payload[i] = (uint8_t)next_random();
    }
    x->effect.active_payload[0] = (next_random() % 10u < 8u) ? (uint8_t)(1u + next_random() % 3u)
                                                              : (uint8_t)(next_random() % 6u);
}

static int exit_cases(void)
{
    unsigned iteration;
    for (iteration = 0; iteration < 20000u; ++iteration) {
        SessionExit x;
        Host host;
        SessionExitHost vtable;
        SessionExitStepInfo info;
        int status;
        memset(&host, 0, sizeof(host));
        host.fail_at = (next_random() % 4u == 0u) ? 1u + next_random() % 4u : 0u;
        host.tick = next_random();
        for (unsigned i = 0; i < 6u; ++i) {
            host.sources[i] = next_random();
            host.destinations[i] = next_random();
        }
        memset(&vtable, 0, sizeof(vtable));
        vtable.context = &host;
        vtable.nested_scene_tick = nested;
        vtable.capture = capture;
        vtable.clear_destination_capture = clear_destination;
        vtable.run_sequence = run_sequence;
        random_exit(&x);
        switch (iteration % 4u) {
        case 0u: status = session_exit_state4(&x, &vtable, &info); break;
        case 1u: status = session_exit_effect_gate(&x, &vtable, &info); break;
        case 2u: status = session_exit_controller(&x, &vtable, &info); break;
        default: status = session_exit_render_pass(&x, &vtable, &info); break;
        }
        ++cases;
        if (status == SESSION_EXIT_OK) {
            ++ok_count;
            if (info.controller_ran != 0u) {
                ++ran_count;
            }
        } else if (status == SESSION_EXIT_ERR_UNSUPPORTED) {
            ++unsupported_count;
            CHECK(info.unsupported != SESSION_EXIT_UNSUPPORTED_NONE, "unsupported reason set");
        } else {
            ++host_failures;
            CHECK(status == SESSION_EXIT_ERR_HOST && info.failed_boundary != 0,
                  "host failure names its boundary");
        }
        CHECK(session_exit_status_string(status) != NULL, "status string");
        if (iteration % 7u == 0u) {
            SceneTransitionRequest request;
            memset(&request, 0, sizeof(request));
            request.target_scene = (int16_t)next_random();
            request.opaque_words[2] = (int16_t)next_random();
            CHECK(session_exit_request_transition(&x, &request) == SESSION_EXIT_OK &&
                  x.g.game_state == SESSION_EXIT_STATE_EXIT, "request");
            CHECK(session_exit_begin_load(&x) == SESSION_EXIT_OK, "begin_load");
            CHECK(session_exit_clear_latches(&x) == SESSION_EXIT_OK &&
                  x.g.input_latch == -1, "latches");
            CHECK(session_exit_finish_intro(&x) == SESSION_EXIT_OK, "intro");
        }
    }
    CHECK(session_exit_state4(NULL, NULL, NULL) == SESSION_EXIT_ERR_ARGUMENT, "null args");
    CHECK(session_exit_controller(NULL, NULL, NULL) == SESSION_EXIT_ERR_ARGUMENT, "null args 2");
    CHECK(session_exit_clear_caption(NULL, NULL, NULL) == SESSION_EXIT_ERR_ARGUMENT, "null args 3");
    return 0;
}

static CaptionLifecycleBackendStatus blit_ok(void *context, const CaptionBlit *blit)
{
    (void)context;
    (void)blit;
    return CAPTION_LIFECYCLE_BACKEND_OK;
}

static int caption_cases(void)
{
    unsigned iteration;
    for (iteration = 0; iteration < 4000u; ++iteration) {
        static CaptionLifecycle life;
        CaptionGeometry geometry;
        CaptionGlobals shared;
        CaptionLifecycleBackend backend;
        SessionExit x;
        ActionFamily28Rect view = {10, 10, 629, 384};
        size_t i;
        memset(&life, 0, sizeof(life));
        memset(&geometry, 0, sizeof(geometry));
        memset(&shared, 0, sizeof(shared));
        memset(&backend, 0, sizeof(backend));
        for (i = 0; i < sizeof(geometry.tbox); ++i) {
            geometry.tbox[i] = (uint8_t)next_random();
        }
        geometry.framed_surface_height = (int16_t)next_random();
        life.shared = &shared;
        life.geometry = &geometry;
        life.taskbar.saved_surface = (next_random() & 3u) == 0u ? 0u : 0x1000u;
        backend.blit = blit_ok;
        session_exit_init(&x, &view);
        {
            const int status = session_exit_clear_caption(&x, &life, &backend);
            CHECK(status == SESSION_EXIT_OK || status == SESSION_EXIT_ERR_CAPTION, "caption");
        }
    }
    return 0;
}

static int a28_cases(void)
{
    unsigned iteration;
    for (iteration = 0; iteration < 20000u; ++iteration) {
        SessionExit x;
        SessionA28Binding *binding;
        SceneActionInfo action;
        SceneActionRuntimeState state;
        SceneActionHandlerResult result;
        uint8_t body[64];
        size_t length = next_random() % 48u;
        size_t i;
        random_exit(&x);
        binding = session_a28_create(&x);
        CHECK(binding != NULL, "create");
        for (i = 0; i < sizeof(body); ++i) {
            body[i] = (uint8_t)next_random();
        }
        memset(&action, 0, sizeof(action));
        action.type = (next_random() & 7u) == 0u ? (uint8_t)next_random() : SESSION_A28_TYPE;
        action.subtype = (uint8_t)(next_random() % 5u);
        action.typed_body = body;
        action.typed_body_length = length;
        state.completed = (uint8_t)(next_random() & 1u);
        state.phase = next_random() % 4u;
        memset(&result, 0, sizeof(result));
        if (session_a28_handler(binding, 0u, &action, &state, &result) ==
            SCENE_ACTION_HANDLER_OK) {
            ++a28_ok;
            CHECK(result.disposition == SCENE_ACTION_HANDLER_PENDING ||
                  result.disposition == SCENE_ACTION_HANDLER_COMPLETED, "disposition");
        } else {
            ++a28_error;
        }
        CHECK(session_a28_failure_string(session_a28_last_failure(binding)) != NULL, "failure");
        session_a28_destroy(binding);
    }
    CHECK(session_a28_create(NULL) == NULL, "null exit");
    return 0;
}

int main(void)
{
    if (exit_cases() != 0 || caption_cases() != 0 || a28_cases() != 0) {
        return 1;
    }
    printf("RT-5 sanitizer cases: exit=%u (ok=%u ran=%u unsupported=%u host_failure=%u) "
           "caption=4000 a28=20000 (ok=%u error=%u)\n", cases, ok_count, ran_count,
           unsupported_count, host_failures, a28_ok, a28_error);
    return 0;
}
