/* RT-26 unit tests of raw 0x95 "Set Volume": decoder, visit, session binding and the 0x4fca60 /
 * 0x4f684a kernel sound_control_set_scalars. Prints "PASS <name>" / "FAIL <name>: <message>"; the
 * exit status is the failure count. Fixtures are synthetic bodies (no original bytes).
 * tests/test_action_family_95.py builds and runs this plainly, under ASan/UBSan and under source
 * mutations. */
#include <math.h>
#include <stdio.h>
#include <string.h>

#include "action_family_95.h"
#include "session_bindings_a95.h"
#include "sound_control.h"

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
    int calls;
    uint16_t channel;
    float first, second;
    int result;
} Probe;

static int probe_set(void *context, uint16_t channel, float first, float second)
{
    Probe *p = context;
    ++p->calls;
    p->channel = channel;
    p->first = first;
    p->second = second;
    return p->result;
}

typedef struct {
    int calls;
    uint16_t channel;
    int32_t attenuation;
    SoundControlHostStatus status;
    int32_t hresult;
} Volume;

static SoundControlHostStatus volume_set(void *context, uint16_t channel, int32_t attenuation,
                                         int32_t *host_result)
{
    Volume *v = context;
    ++v->calls;
    v->channel = channel;
    v->attenuation = attenuation;
    *host_result = v->hresult;
    return v->status;
}

static void ready_state(SoundControlState *s, uint16_t channel, uint16_t category)
{
    memset(s, 0, sizeof *s);
    s->device_ready = 1u;
    s->channels[channel].volume_category = category;
    s->channels[channel].buffer_available = 1u;
    for (unsigned i = 0; i < SOUND_CONTROL_CATEGORY_COUNT; ++i) s->master[i] = 1.0f;
}

static void decode_fields(void)
{
    const uint8_t body[3] = {4u, 0u, 25u};
    ActionFamily95Decoded d;
    CHECK(action_family_95_decode(body, 3u, &d) == ACTION_FAMILY_95_OK);
    CHECK(d.channel == 4 && d.volume_percent == 25u && d.scalar == 0.25f);
}

static void decode_every_byte_and_sign(void)
{
    uint8_t body[3] = {0xffu, 0xffu, 0u};
    ActionFamily95Decoded d;
    for (unsigned v = 0; v < 256u; ++v) {
        volatile double q = (double)v / 100.0;
        body[2] = (uint8_t)v;
        CHECK(action_family_95_decode(body, 3u, &d) == ACTION_FAMILY_95_OK);
        CHECK(d.channel == -1 && d.scalar == (float)q);
    }
    body[2] = 100u;
    CHECK(action_family_95_decode(body, 3u, &d) == ACTION_FAMILY_95_OK && d.scalar == 1.0f);
}

static void decode_rejects(void)
{
    const uint8_t body[3] = {0u, 0u, 0u};
    ActionFamily95Decoded d;
    CHECK(action_family_95_decode(NULL, 3u, &d) == ACTION_FAMILY_95_ERR_ARGUMENT);
    CHECK(action_family_95_decode(body, 3u, NULL) == ACTION_FAMILY_95_ERR_ARGUMENT);
    CHECK(action_family_95_decode(body, 2u, &d) == ACTION_FAMILY_95_ERR_BODY);
    CHECK(action_family_95_decode(body, 0u, &d) == ACTION_FAMILY_95_ERR_BODY);
    CHECK(action_family_95_decode(body, 19u, &d) == ACTION_FAMILY_95_OK); /* tail is not the body */
}

static void visit_passes_both_scalars(void)
{
    Probe p = {0, 0, 0.0f, 0.0f, 0};
    ActionFamily95Host host = {&p, probe_set};
    ActionFamily95Decoded d = {12, 45u, 0.45f};
    CHECK(action_family_95_visit(&d, &host) == ACTION_FAMILY_95_OK);
    CHECK(p.calls == 1 && p.channel == 12u && p.first == 0.45f && p.second == 0.45f);
}

static void visit_refuses_before_any_effect(void)
{
    Probe p = {0, 0, 0.0f, 0.0f, 0};
    ActionFamily95Host host = {&p, probe_set};
    ActionFamily95Decoded d = {-1, 10u, 0.1f};
    CHECK(action_family_95_visit(&d, &host) == ACTION_FAMILY_95_ERR_BOUNDS);
    d.channel = 32;
    CHECK(action_family_95_visit(&d, &host) == ACTION_FAMILY_95_ERR_BOUNDS);
    d.channel = 31;
    CHECK(action_family_95_visit(&d, &host) == ACTION_FAMILY_95_OK && p.calls == 1 && p.channel == 31u);
    CHECK(action_family_95_visit(NULL, &host) == ACTION_FAMILY_95_ERR_ARGUMENT);
    CHECK(action_family_95_visit(&d, NULL) == ACTION_FAMILY_95_ERR_ARGUMENT);
    host.set_channel_scalars = NULL;
    CHECK(action_family_95_visit(&d, &host) == ACTION_FAMILY_95_ERR_UNSUPPORTED);
}

static void visit_reports_host_failure(void)
{
    Probe p = {0, 0, 0.0f, 0.0f, 7};
    ActionFamily95Host host = {&p, probe_set};
    ActionFamily95Decoded d = {5, 15u, 0.15f};
    CHECK(action_family_95_visit(&d, &host) == ACTION_FAMILY_95_ERR_HOST && p.calls == 1);
}

static SceneActionInfo row(uint8_t subtype, const uint8_t *body, size_t length)
{
    SceneActionInfo info;
    memset(&info, 0, sizeof info);
    info.type = 0x95u;
    info.subtype = subtype;
    info.typed_body = body;
    info.typed_body_length = length;
    return info;
}

static void binding_dispositions(void)
{
    const uint8_t body[3] = {6u, 0u, 50u};
    Probe p = {0, 0, 0.0f, 0.0f, 0};
    ActionFamily95Host host = {&p, probe_set};
    SessionA95Binding *b = session_a95_create(&host);
    SceneActionRuntimeState before = {0u, 7u};
    SceneActionHandlerResult out;
    CHECK(b != NULL);
    for (unsigned subtype = 0; subtype < 5u && b != NULL; ++subtype) {
        SceneActionInfo info = row((uint8_t)subtype, body, 3u);
        out.disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;
        out.phase = 99u;
        CHECK(session_a95_handler(b, 3u, &info, &before, &out) == SCENE_ACTION_HANDLER_OK);
        CHECK(out.phase == 0u);
        CHECK(out.disposition == SCENE_ACTION_HANDLER_COMPLETED);
    }
    CHECK(p.calls == 5 && p.channel == 6u && p.first == 0.5f && session_a95_visits(b) == 5ul);
    session_a95_destroy(b);
}

static void binding_failures(void)
{
    const uint8_t good[3] = {1u, 0u, 20u}, high[3] = {32u, 0u, 20u};
    Probe p = {0, 0, 0.0f, 0.0f, 0};
    ActionFamily95Host host = {&p, probe_set};
    SessionA95Binding *b = session_a95_create(&host);
    SceneActionRuntimeState before = {0u, 0u};
    SceneActionHandlerResult out = {SCENE_ACTION_HANDLER_PENDING, 0u};
    SceneActionInfo info;
    CHECK(session_a95_create(NULL) == NULL && b != NULL);
    info = row(1u, good, 2u); /* short body */
    CHECK(session_a95_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    info = row(1u, high, 3u); /* channel 32 */
    CHECK(session_a95_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    info = row(1u, good, 3u);
    info.type = 0x96u;
    CHECK(session_a95_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    info.type = 0x95u;
    CHECK(session_a95_handler(NULL, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_a95_handler(b, 0u, &info, NULL, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(p.calls == 0);
    p.result = 3; /* host failure surfaces as an error, the row does not complete */
    CHECK(session_a95_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_a95_visits(b) == 0ul && strcmp(session_a95_failure(b), "none") != 0);
    session_a95_destroy(b);
    host.set_channel_scalars = NULL;
    b = session_a95_create(&host);
    CHECK(session_a95_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    session_a95_destroy(b);
}

static void kernel_values_follow_the_category_master(void)
{
    SoundControlState s;
    Volume v = {0, 0, 0, SOUND_CONTROL_HOST_OK, 0};
    SoundControlHost host;
    SoundControlMasterResult r;
    memset(&host, 0, sizeof host);
    host.context = &v;
    host.set_first_attenuation = volume_set;
    ready_state(&s, 7u, 2u);
    s.master[2] = 0.85f;
    CHECK(sound_control_set_scalars(&s, 7u, 0.25f, 0.5f, 0x027fu, &host, &r) == SOUND_CONTROL_OK);
    /* 0.25f * 0.85f * 2857.142822265625 - 2857.142857142857 = -2249.99..., truncated toward zero
     * (the original's __ftol); 0.5f gives -1642. The oracle compares these with the original code. */
    CHECK(s.channels[7].first_scalar == 0.25f && s.channels[7].second_scalar == 0.5f);
    CHECK(s.channels[7].first_attenuation == -2249 && s.channels[7].second_attenuation == -1642);
    CHECK(v.calls == 1 && v.channel == 7u && v.attenuation == s.channels[7].first_attenuation);
    CHECK(r.volume_calls == 1u && r.updated_channels == 1u && r.has_failed_channel == 0u);
    CHECK(s.device_error == 0x3e8u);
}

static void kernel_clamps_full_scale_and_silence(void)
{
    SoundControlState s;
    Volume v = {0, 0, 0, SOUND_CONTROL_HOST_OK, 0};
    SoundControlHost host;
    SoundControlMasterResult r;
    memset(&host, 0, sizeof host);
    host.context = &v;
    host.set_first_attenuation = volume_set;
    ready_state(&s, 0u, 0u);
    /* 2.55 (volume byte 255): the stored attenuation is positive, the setter clamps it to 0. */
    CHECK(sound_control_set_scalars(&s, 0u, 2.55f, 2.55f, 0x027fu, &host, &r) == SOUND_CONTROL_OK);
    CHECK(s.channels[0].first_attenuation == 0 && s.channels[0].second_attenuation == 0 && v.attenuation == 0);
    /* 0.0: -2857, the floor of the setter */
    CHECK(sound_control_set_scalars(&s, 0u, 0.0f, 0.0f, 0x027fu, &host, &r) == SOUND_CONTROL_OK);
    CHECK(s.channels[0].first_attenuation == SOUND_CONTROL_MIN_ATTENUATION && v.attenuation == -2857);
    /* master 0 with full scalars: also the floor */
    s.master[0] = 0.0f;
    CHECK(sound_control_set_scalars(&s, 0u, 1.0f, 1.0f, 0x027fu, &host, &r) == SOUND_CONTROL_OK);
    CHECK(s.channels[0].first_attenuation == -2857 && v.calls == 3);
}

static void kernel_records_device_states(void)
{
    SoundControlState s;
    Volume v = {0, 0, 0, SOUND_CONTROL_HOST_OK, 0};
    SoundControlHost host;
    SoundControlMasterResult r;
    memset(&host, 0, sizeof host);
    host.context = &v;
    host.set_first_attenuation = volume_set;
    ready_state(&s, 3u, 1u);
    s.device_ready = 0u;
    CHECK(sound_control_set_scalars(&s, 3u, 0.4f, 0.4f, 0x027fu, &host, &r) == SOUND_CONTROL_OK);
    CHECK(s.device_error == 0x3eau && r.original_error == 0x3eau && v.calls == 0);
    CHECK(s.channels[3].first_scalar == 0.4f); /* the scalars are stored before the setter runs */
    ready_state(&s, 3u, 1u);
    s.channels[3].buffer_available = 0u;
    CHECK(sound_control_set_scalars(&s, 3u, 0.4f, 0.4f, 0x027fu, &host, &r) == SOUND_CONTROL_OK);
    CHECK(s.device_error == 0x3efu && r.original_error == 0x3efu && v.calls == 0 && r.volume_calls == 0u);
    ready_state(&s, 3u, 1u);
    v.status = SOUND_CONTROL_HOST_ERROR;
    v.hresult = -1;
    CHECK(sound_control_set_scalars(&s, 3u, 0.4f, 0.4f, 0x027fu, &host, &r) == SOUND_CONTROL_OK);
    CHECK(s.device_error == 0x408u && r.has_failed_channel == 1u && r.failed_channel == 3u && s.host_result == -1);
    v.status = SOUND_CONTROL_HOST_UNSUPPORTED;
    CHECK(sound_control_set_scalars(&s, 3u, 0.4f, 0.4f, 0x027fu, &host, &r) == SOUND_CONTROL_ERR_UNSUPPORTED);
    CHECK(sound_control_set_scalars(&s, 3u, 0.4f, 0.4f, 0x027fu, NULL, &r) == SOUND_CONTROL_ERR_UNSUPPORTED);
}

static void kernel_rejects_before_mutation(void)
{
    SoundControlState s, before;
    Volume v = {0, 0, 0, SOUND_CONTROL_HOST_OK, 0};
    SoundControlHost host;
    SoundControlMasterResult r;
    memset(&host, 0, sizeof host);
    host.context = &v;
    host.set_first_attenuation = volume_set;
    ready_state(&s, 9u, 2u);
    before = s;
    CHECK(sound_control_set_scalars(NULL, 9u, 0.4f, 0.4f, 0x027fu, &host, &r) == SOUND_CONTROL_ERR_ARGUMENT);
    CHECK(sound_control_set_scalars(&s, 9u, 0.4f, 0.4f, 0x027fu, &host, NULL) == SOUND_CONTROL_ERR_ARGUMENT);
    CHECK(sound_control_set_scalars(&s, 32u, 0.4f, 0.4f, 0x027fu, &host, &r) == SOUND_CONTROL_ERR_ARGUMENT);
    CHECK(sound_control_set_scalars(&s, 9u, -0.1f, 0.4f, 0x027fu, &host, &r) == SOUND_CONTROL_ERR_ARGUMENT);
    CHECK(sound_control_set_scalars(&s, 9u, 0.4f, NAN, 0x027fu, &host, &r) == SOUND_CONTROL_ERR_ARGUMENT);
    CHECK(sound_control_set_scalars(&s, 9u, 101.0f, 0.4f, 0x027fu, &host, &r) == SOUND_CONTROL_ERR_ARGUMENT);
    CHECK(sound_control_set_scalars(&s, 9u, 0.4f, 0.4f, 0x0000u, &host, &r) == SOUND_CONTROL_ERR_UNSUPPORTED);
    s.channels[9].volume_category = 4u;
    before = s;
    CHECK(sound_control_set_scalars(&s, 9u, 0.4f, 0.4f, 0x027fu, &host, &r) == SOUND_CONTROL_ERR_ARGUMENT);
    s.channels[9].volume_category = 2u;
    s.master[2] = 1.5f;
    before = s;
    CHECK(sound_control_set_scalars(&s, 9u, 0.4f, 0.4f, 0x027fu, &host, &r) == SOUND_CONTROL_ERR_ARGUMENT);
    CHECK(memcmp(&s, &before, sizeof s) == 0 && v.calls == 0);
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
    run("decode_fields", decode_fields, &failures);
    run("decode_every_byte_and_sign", decode_every_byte_and_sign, &failures);
    run("decode_rejects", decode_rejects, &failures);
    run("visit_passes_both_scalars", visit_passes_both_scalars, &failures);
    run("visit_refuses_before_any_effect", visit_refuses_before_any_effect, &failures);
    run("visit_reports_host_failure", visit_reports_host_failure, &failures);
    run("binding_dispositions", binding_dispositions, &failures);
    run("binding_failures", binding_failures, &failures);
    run("kernel_values_follow_the_category_master", kernel_values_follow_the_category_master, &failures);
    run("kernel_clamps_full_scale_and_silence", kernel_clamps_full_scale_and_silence, &failures);
    run("kernel_records_device_states", kernel_records_device_states, &failures);
    run("kernel_rejects_before_mutation", kernel_rejects_before_mutation, &failures);
    return failures;
}
