#include "session_bindings_a76.h"

#include <stdlib.h>
#include <string.h>

typedef struct A76Row {
    uint8_t present;
    uint8_t body[PWD_BODY_BYTES];
} A76Row;

struct SessionA76Binding {
    SessionA76Host host; /* the caller's callbacks (the caller's context) */
    PwdHost kernel;      /* the trampolines below, context = this binding */
    PwdState state;
    int32_t start_flag;  /* 0x5bb1ca */
    int32_t entry_flag;  /* 0x5d1c01 */
    A76Row *rows;
    size_t count;
    const char *failure;
};

/* The kernel reports its process-cell writes (start flag, entry flag) only through the observer, so every callback goes through a
 * trampoline that gives the kernel this binding as its context. */
#define TRAMPOLINE_OWNER(context) (&((SessionA76Binding *)(context))->host.kernel)

static int t_view_origin(void *c, int32_t *x, int32_t *y)
{
    return TRAMPOLINE_OWNER(c)->view_origin(TRAMPOLINE_OWNER(c)->context, x, y);
}

static int t_font_acquire(void *c, int16_t font)
{
    return TRAMPOLINE_OWNER(c)->font_acquire(TRAMPOLINE_OWNER(c)->context, font);
}

static int t_font_release(void *c, int16_t font)
{
    return TRAMPOLINE_OWNER(c)->font_release(TRAMPOLINE_OWNER(c)->context, font);
}

static int t_text_width(void *c, int16_t font, const char *text, int16_t *width)
{
    return TRAMPOLINE_OWNER(c)->text_width(TRAMPOLINE_OWNER(c)->context, font, text, width);
}

static uint32_t t_tick(void *c)
{
    return TRAMPOLINE_OWNER(c)->tick(TRAMPOLINE_OWNER(c)->context);
}

static int t_sound_prepare(void *c, const uint8_t *record)
{
    return TRAMPOLINE_OWNER(c)->sound_prepare(TRAMPOLINE_OWNER(c)->context, record);
}

static int t_sound_stop(void *c, const uint8_t *record)
{
    return TRAMPOLINE_OWNER(c)->sound_stop(TRAMPOLINE_OWNER(c)->context, record);
}

static int t_sound_play(void *c, int16_t channel)
{
    return TRAMPOLINE_OWNER(c)->sound_play(TRAMPOLINE_OWNER(c)->context, channel);
}

static int t_sound_busy(void *c, int16_t channel, int32_t *result)
{
    return TRAMPOLINE_OWNER(c)->sound_busy(TRAMPOLINE_OWNER(c)->context, channel, result);
}

static int t_event_flag_invalid(void *c, int16_t index)
{
    return TRAMPOLINE_OWNER(c)->event_flag_invalid(TRAMPOLINE_OWNER(c)->context, index);
}

static int t_transition(void *c, const PwdTransition *request)
{
    return TRAMPOLINE_OWNER(c)->transition(TRAMPOLINE_OWNER(c)->context, request);
}

static int t_store_event_flag(void *c, int16_t index, uint32_t value)
{
    return TRAMPOLINE_OWNER(c)->store_event_flag(TRAMPOLINE_OWNER(c)->context, index, value);
}

static void t_observe(void *c, int effect, int32_t a, int32_t b)
{
    SessionA76Binding *binding = (SessionA76Binding *)c;
    if (effect == PWD_FX_START_FLAG) binding->start_flag = a;
    if (effect == PWD_FX_ENTRY_VISIBLE) binding->entry_flag = a;
    if (binding->host.kernel.observe != NULL) binding->host.kernel.observe(binding->host.kernel.context, effect, a, b);
}

SessionA76Binding *session_a76_create(const SessionA76Host *host)
{
    SessionA76Binding *binding;
    if (host == NULL || host->kernel.view_origin == NULL || host->kernel.font_acquire == NULL ||
        host->kernel.font_release == NULL || host->kernel.text_width == NULL || host->kernel.tick == NULL ||
        host->kernel.sound_prepare == NULL || host->kernel.sound_stop == NULL || host->kernel.sound_play == NULL ||
        host->kernel.sound_busy == NULL || host->kernel.event_flag_invalid == NULL || host->kernel.transition == NULL ||
        host->kernel.store_event_flag == NULL)
        return NULL;
    binding = (SessionA76Binding *)calloc(1u, sizeof(*binding));
    if (binding == NULL) return NULL;
    binding->host = *host;
    binding->kernel.context = binding;
    binding->kernel.view_origin = t_view_origin;
    binding->kernel.font_acquire = t_font_acquire;
    binding->kernel.font_release = t_font_release;
    binding->kernel.text_width = t_text_width;
    binding->kernel.tick = t_tick;
    binding->kernel.sound_prepare = t_sound_prepare;
    binding->kernel.sound_stop = t_sound_stop;
    binding->kernel.sound_play = t_sound_play;
    binding->kernel.sound_busy = t_sound_busy;
    binding->kernel.event_flag_invalid = t_event_flag_invalid;
    binding->kernel.transition = t_transition;
    binding->kernel.store_event_flag = t_store_event_flag;
    binding->kernel.observe = t_observe;
    pwd_state_reset(&binding->state);
    binding->failure = "none";
    return binding;
}

void session_a76_cleanup(SessionA76Binding *binding)
{
    if (binding == NULL) return;
    pwd_cleanup(&binding->state);
    binding->entry_flag = 0;
}

void session_a76_destroy(SessionA76Binding *binding)
{
    if (binding == NULL) return;
    session_a76_cleanup(binding);
    free(binding->rows);
    free(binding);
}

int session_a76_begin_scene(SessionA76Binding *binding, const SceneResource *scene)
{
    A76Row *rows;
    size_t count;
    if (binding == NULL || scene == NULL) return PWD_ERR_ARGUMENT;
    count = scene_resource_action_count(scene);
    rows = count == 0u ? NULL : (A76Row *)calloc(count, sizeof(*rows));
    if (count != 0u && rows == NULL) {
        binding->failure = "0x76-row-allocation";
        return PWD_ERR_BOUNDS;
    }
    for (size_t i = 0u; i < count; ++i) {
        SceneActionInfo info;
        const char *why = NULL;
        if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) {
            free(rows);
            binding->failure = "0x76-scene-row";
            return PWD_ERR_BODY;
        }
        if (info.type != SESSION_A76_TYPE) continue;
        if (pwd_validate_body(info.typed_body, info.typed_body_length, &why) != PWD_OK) {
            free(rows);
            binding->failure = why != NULL ? why : "0x76-body";
            return PWD_ERR_BODY;
        }
        memcpy(rows[i].body, info.typed_body, PWD_BODY_BYTES);
        rows[i].present = 1u;
    }
    /* The previous scene's clear (0x43dbe3). The start flag is not touched. */
    session_a76_cleanup(binding);
    free(binding->rows);
    binding->rows = rows;
    binding->count = count;
    binding->failure = "none";
    return PWD_OK;
}

int session_a76_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionA76Binding *binding = (SessionA76Binding *)context;
    PwdResult result;
    const char *why = NULL;
    int status;
    if (binding == NULL) return SCENE_ACTION_HANDLER_ERROR;
    if (action == NULL || before == NULL || out == NULL || action->type != SESSION_A76_TYPE || index >= binding->count ||
        binding->rows[index].present == 0u) {
        binding->failure = "0x76-row-not-owned";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    status = pwd_step(&binding->state, binding->rows[index].body, PWD_BODY_BYTES, (int16_t)index, before->phase, &binding->kernel,
                      &result, &why);
    binding->failure = why != NULL ? why : "none";
    if (status == PWD_ERR_UNSUPPORTED) return SCENE_ACTION_HANDLER_UNSUPPORTED;
    if (status != PWD_OK) return SCENE_ACTION_HANDLER_ERROR;
    if ((result.initialized != 0u || result.completed != 0u) && binding->host.store_world != NULL)
        binding->host.store_world(binding->host.kernel.context, binding->start_flag);
    out->phase = result.phase_after;
    out->disposition = result.completed != 0u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_PENDING;
    return SCENE_ACTION_HANDLER_OK;
}

/* The body of the state's row, NULL when the state has no row of this binding. */
static const uint8_t *active_body(const SessionA76Binding *binding)
{
    const int16_t row = pwd_rd16(binding->state.b, PWD_S_ROW);
    if (row < 0 || (size_t)row >= binding->count || binding->rows[row].present == 0u) return NULL;
    return binding->rows[row].body;
}

int session_a76_key(SessionA76Binding *binding, int8_t ch)
{
    if (binding == NULL) return PWD_ERR_ARGUMENT;
    return pwd_key(&binding->state, ch);
}

int session_a76_pointer_move(SessionA76Binding *binding, int32_t x, int32_t y, PwdPointerResult *out)
{
    const uint8_t *body;
    if (binding == NULL || out == NULL) return PWD_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    out->candidate = -1;
    out->cursor_kind = -1;
    if (binding->state.b[PWD_S_ACTIVE] == 0) return PWD_OK; /* 0x4f04b6 does not run: no row owns the puzzle */
    body = active_body(binding);
    if (body == NULL) return PWD_ERR_ARGUMENT;
    return pwd_pointer(&binding->state, body, PWD_BODY_BYTES, x, y, out);
}

int session_a76_click(SessionA76Binding *binding, int32_t candidate, PwdClickResult *out)
{
    if (binding == NULL || out == NULL) return PWD_ERR_ARGUMENT;
    return pwd_click(&binding->state, candidate, out);
}

int session_a76_invalidate(SessionA76Binding *binding)
{
    if (binding == NULL) return PWD_ERR_ARGUMENT;
    if (pwd_invalidate(&binding->state) == 0) return 0;
    binding->entry_flag = 1;
    return 1;
}

void session_a76_new_game(SessionA76Binding *binding)
{
    if (binding != NULL) pwd_new_game(&binding->state);
}

int session_a76_render(SessionA76Binding *binding, PwdRenderResult *out)
{
    const uint8_t *body;
    int status;
    if (binding == NULL || out == NULL) return PWD_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    if (binding->entry_flag == 0) return PWD_OK; /* no render entry: 0x4d07e7 is never called */
    body = active_body(binding);
    if (body == NULL) {
        binding->failure = "0x76-render-row";
        return PWD_ERR_ARGUMENT;
    }
    status = pwd_render(&binding->state, body, PWD_BODY_BYTES, out);
    binding->failure = status == PWD_OK ? "none" : "0x76-render";
    return status;
}

unsigned session_a76_registered(const SessionA76Binding *binding)
{
    return binding != NULL && binding->entry_flag != 0 ? 1u : 0u;
}

const PwdState *session_a76_state(const SessionA76Binding *binding)
{
    return binding == NULL ? NULL : &binding->state;
}

int32_t session_a76_start_flag(const SessionA76Binding *binding)
{
    return binding == NULL ? 0 : binding->start_flag;
}

const char *session_a76_failure(const SessionA76Binding *binding)
{
    return binding == NULL ? "0x76-binding-unbound" : binding->failure;
}
