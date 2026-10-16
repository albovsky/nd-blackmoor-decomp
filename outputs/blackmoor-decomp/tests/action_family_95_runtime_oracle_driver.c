/* RT-26 native side of the raw 0x95 oracle (tests/action_family_95_runtime_original_oracle.py).
 *
 * One handle owns a SoundControlState (the recovered CSound channel slots and CDirectSound state), a
 * recording DirectSound SetVolume stand-in and the real session binding. a95o_visit() performs what the
 * executor does for a true gate: it calls the binding handler and derives the row's completion byte,
 * the dependency reset request and the phase from the returned disposition with the executor's own
 * helper (action_core_finish_action, scene_executor.c apply_external_handler). */
#include <stdlib.h>
#include <string.h>

#include "action_core.h"
#include "action_family_95.h"
#include "session_bindings_a95.h"
#include "sound_control.h"

#define MAX_VOLUME_EVENTS 4096

typedef struct {
    SoundControlState state;
    SoundControlHost host;
    SessionA95Binding *binding;
    int volume_status;
    int32_t volume_hresult;
    int volume_count;
    int volume_channel[MAX_VOLUME_EVENTS];
    int32_t volume_attenuation[MAX_VOLUME_EVENTS];
    int set_calls;
    int set_failed;
} Handle;

static SoundControlHostStatus volume_set(void *context, uint16_t channel, int32_t attenuation,
                                         int32_t *host_result)
{
    Handle *h = context;
    if (h->volume_count < MAX_VOLUME_EVENTS) {
        h->volume_channel[h->volume_count] = channel;
        h->volume_attenuation[h->volume_count] = attenuation;
    }
    ++h->volume_count;
    *host_result = h->volume_hresult;
    return (SoundControlHostStatus)h->volume_status;
}

/* ActionFamily95Host.set_channel_scalars: 0x4fca60 + 0x4f684a on the recovered state, x87 CW 0x027f. */
static int set_channel_scalars(void *context, uint16_t channel, float first, float second)
{
    Handle *h = context;
    SoundControlMasterResult result;
    int status;
    ++h->set_calls;
    status = sound_control_set_scalars(&h->state, channel, first, second, 0x027fu, &h->host, &result);
    if (status != SOUND_CONTROL_OK) ++h->set_failed;
    return status;
}

Handle *a95o_new(void)
{
    Handle *h = calloc(1u, sizeof(*h));
    ActionFamily95Host host;
    if (h == NULL) return NULL;
    h->host.context = h;
    h->host.set_first_attenuation = volume_set;
    host.context = h;
    host.set_channel_scalars = set_channel_scalars;
    h->binding = session_a95_create(&host);
    if (h->binding == NULL) {
        free(h);
        return NULL;
    }
    return h;
}

void a95o_free(Handle *h)
{
    if (h != NULL) {
        session_a95_destroy(h->binding);
        free(h);
    }
}

void a95o_reset(Handle *h)
{
    unsigned i;
    memset(&h->state, 0, sizeof(h->state));
    h->state.device_ready = 1u;
    for (i = 0u; i < SOUND_CONTROL_CATEGORY_COUNT; ++i) h->state.master[i] = 1.0f;
    h->volume_status = SOUND_CONTROL_HOST_OK;
    h->volume_hresult = 0;
    h->volume_count = 0;
    h->set_calls = 0;
    h->set_failed = 0;
}

void a95o_seed(Handle *h, int channel, int category, int buffer, uint32_t first_bits, uint32_t second_bits,
               int32_t first_attenuation, int32_t second_attenuation)
{
    SoundControlChannel *c = &h->state.channels[channel];
    c->volume_category = (uint16_t)category;
    c->buffer_available = buffer != 0;
    memcpy(&c->first_scalar, &first_bits, sizeof(float));
    memcpy(&c->second_scalar, &second_bits, sizeof(float));
    c->first_attenuation = first_attenuation;
    c->second_attenuation = second_attenuation;
}

void a95o_master(Handle *h, int category, uint32_t bits) { memcpy(&h->state.master[category], &bits, sizeof(float)); }
void a95o_device_ready(Handle *h, int ready) { h->state.device_ready = (uint32_t)ready; }
void a95o_volume_result(Handle *h, int status, int32_t hresult)
{
    h->volume_status = status;
    h->volume_hresult = hresult;
}

/* Returns the handler status (SCENE_ACTION_HANDLER_*) or 100 + the executor-side failure. */
int a95o_visit(Handle *h, const uint8_t *body, int body_length, int subtype, int completed_before,
               uint32_t phase_before, int *completed_after, int *reset, uint32_t *phase_after, int *disposition)
{
    SceneActionInfo info;
    SceneActionRuntimeState before;
    SceneActionHandlerResult out;
    ActionCoreActionResult finish;
    int status;
    memset(&info, 0, sizeof(info));
    info.type = ACTION_FAMILY_95_RAW_TYPE;
    info.subtype = (uint8_t)subtype;
    info.typed_body = body;
    info.typed_body_length = (size_t)body_length;
    before.completed = (uint8_t)completed_before;
    before.phase = phase_before;
    out.disposition = SCENE_ACTION_HANDLER_PENDING;
    out.phase = phase_before;
    *completed_after = completed_before;
    *reset = 0;
    *phase_after = phase_before;
    status = session_a95_handler(h->binding, 0u, &info, &before, &out);
    *disposition = (int)out.disposition;
    if (status != SCENE_ACTION_HANDLER_OK) return status;
    /* scene_executor.c apply_external_handler */
    switch (out.disposition) {
    case SCENE_ACTION_HANDLER_PENDING:
        *phase_after = out.phase;
        break;
    case SCENE_ACTION_HANDLER_COMPLETED:
        if (action_core_finish_action((uint8_t)subtype, (uint8_t)completed_before, &finish) != ACTION_CORE_OK)
            return 101;
        *completed_after = finish.completed;
        *reset = finish.reset_dependencies;
        *phase_after = out.phase;
        break;
    case SCENE_ACTION_HANDLER_DIRECT_COMPLETED:
        *completed_after = 1;
        *phase_after = out.phase;
        break;
    case SCENE_ACTION_HANDLER_RESET_DEPENDENCIES:
        *phase_after = 0u;
        *reset = 1;
        break;
    default:
        return 102;
    }
    return 0;
}

void a95o_channel(Handle *h, int channel, uint32_t *first_bits, uint32_t *second_bits, int32_t *first_attenuation,
                  int32_t *second_attenuation)
{
    const SoundControlChannel *c = &h->state.channels[channel];
    memcpy(first_bits, &c->first_scalar, sizeof(float));
    memcpy(second_bits, &c->second_scalar, sizeof(float));
    *first_attenuation = c->first_attenuation;
    *second_attenuation = c->second_attenuation;
}

void a95o_device(Handle *h, uint32_t *error, uint32_t *state, int32_t *host_result)
{
    *error = h->state.device_error;
    *state = h->state.device_state;
    *host_result = h->state.host_result;
}

int a95o_volume_count(Handle *h) { return h->volume_count; }
void a95o_volume_at(Handle *h, int i, int *channel, int32_t *attenuation)
{
    *channel = h->volume_channel[i];
    *attenuation = h->volume_attenuation[i];
}
void a95o_volume_clear(Handle *h) { h->volume_count = 0; }
int a95o_set_calls(Handle *h) { return h->set_calls; }
int a95o_set_failed(Handle *h) { return h->set_failed; }
