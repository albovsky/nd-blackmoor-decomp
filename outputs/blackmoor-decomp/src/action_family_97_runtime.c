#include "action_family_97_runtime.h"

#include <string.h>

static uint16_t u16(const uint8_t *p)
{ return (uint16_t)((uint16_t)p[0] | ((uint16_t)p[1] << 8)); }
static int16_t s16(const uint8_t *p)
{
    uint16_t v = u16(p);
    return (int16_t)(v <= INT16_MAX ? (int32_t)v : (int32_t)v - 65536);
}
static uint32_t u32(const uint8_t *p)
{ return (uint32_t)p[0] | ((uint32_t)p[1] << 8) | ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24); }
static float gain(int16_t p)
{ return p <= 0 ? 0.0f : p >= 100 ? 1.0f : (float)p / 100.0f; }

/* CSound::InitSoundSystem 0x4faa03: the channel categories are process
 * defaults, independent of this action's control and mode fields. */
static uint8_t category(uint16_t ch)
{
    static const uint8_t categories[32] = {
        1,1,1,2,2,2,2,2,2,2,2,2,0,0,3,3,
        3,2,2,1,2,2,2,2,2,2,1,1,3,1,0,2
    };
    return categories[ch];
}

static int fail(const char **why, const char *message, int status)
{ if (why != NULL) *why = message; return status; }

static int backend_status(ActionSoundBackendStatus status, const char **why,
                           const char *message)
{
    return fail(why, message, status == ACTION_SOUND_BACKEND_UNSUPPORTED
                               ? ACTION_SOUND_ERR_UNSUPPORTED : ACTION_SOUND_ERR_BACKEND);
}

/* One visit of 0x432d1a. allow_event selects the raw-0xa1 reading of object +0xa5/+0xa7
 * (RT-21); without it only the raw-97 constructor default -1 is accepted (RT-8). */
static int visit(const uint8_t *p, size_t length, const A97Input *in,
                 ActionSoundBackend *host, const A97EventTable *events, int allow_event,
                 ActionSoundObjectResult *object, const char **why)
{
    ActionSoundAudioCommand command;
    ActionSoundBackendStatus status;
    size_t caption_length;
    const uint8_t *nul;
    int show_caption;
    int16_t event_id;
    A97Result *out;
    if (why != NULL) *why = "none";
    if (p == NULL || in == NULL || object == NULL)
        return fail(why, "invalid runtime arguments", ACTION_SOUND_ERR_ARGUMENT);
    out = &object->visit;
    if (length < 0xacu || length > ACTION_FAMILY_97_MAX_ALLOCATION ||
        memchr(p, 0, 33u) == NULL || u16(p + 0xaa) > length - 0xacu)
        return fail(why, "invalid constructed allocation", ACTION_SOUND_ERR_BODY);
    memset(object, 0, sizeof(*object));
    out->phase = in->phase;
    out->completed = in->completed;
    if (in->phase > 2u) return ACTION_SOUND_OK;
    if (u16(p + 0x21) >= ACTION_SOUND_CHANNEL_COUNT)
        return fail(why, "sound channel outside recovered table", ACTION_SOUND_ERR_UNSUPPORTED);
    event_id = s16(p + 0xa5);
    if (event_id != -1 && !allow_event)
        return fail(why, "non-default event field outside raw-97 constructor", ACTION_SOUND_ERR_UNSUPPORTED);

    memset(&command, 0, sizeof(command));
    memcpy(command.asset_stem, p, 33u);
    command.channel = u16(p + 0x21);
    command.volume_category = category(command.channel);
    command.control_word = u32(p + 0x27);
    command.first_percent = s16(p + 0x2b);
    command.second_percent = s16(p + 0x2d);
    command.first_gain = gain(command.first_percent);
    command.second_gain = gain(command.second_percent);
    command.mode = p[0x90];
    command.transition_scene = s16(p + 0x91);

    /* The signed +aa gate precedes the C-string writer boundary (0x448d11).
     * An inline embedded NUL truncates visible text, not the allocation. */
    caption_length = u16(p + 0xaa);
    show_caption = in->captions != 0u && s16(p + 0xaa) > 0;
    if (in->phase == 0u) {
        if (host == NULL || host->load_sound == NULL || host->play_sound == NULL)
            return fail(why, "sound load/play provider", ACTION_SOUND_ERR_UNSUPPORTED);
        if (show_caption && host->present_caption == NULL)
            return fail(why, "caption presentation provider", ACTION_SOUND_ERR_UNSUPPORTED);
        /* 0x432e0e..0x432e35 indexes the dword table at 0x585801 with the signed
         * word unchecked; native code needs the host's view and rejects ids outside
         * it (and negative ids other than -1) before any effect of the visit. */
        if (event_id != -1 && (events == NULL || events->flags == NULL || event_id < 0 ||
                               (size_t)event_id >= events->count))
            return fail(why, "event table provider missing or event id outside host view",
                        ACTION_SOUND_ERR_UNSUPPORTED);
        if (show_caption) {
            ActionSoundCaptionRequest request;
            nul = memchr(p + 0xac, 0, caption_length);
            request.kind = ACTION_SOUND_CAPTION_LITERAL;
            request.bytes = p + 0xac;
            request.length = nul != NULL ? (size_t)(nul - (p + 0xac)) : caption_length;
            request.terminator = "";
            request.terminator_length = 0u;
            status = host->present_caption(host->context, &request);
            if (status != ACTION_SOUND_BACKEND_OK)
                return backend_status(status, why, "caption presentation failed");
        }
        /* 0x432e08..0x432e35: dword [0x585801 + id*4] := byte +0xa7, after the caption
         * and before the channel-state copies, load and play. */
        if (event_id != -1) {
            object->event_stored = 1u;
            object->event_id = event_id;
            object->event_value = (int32_t)p[0xa7];
            object->event_previous = events->flags[event_id];
            events->flags[event_id] = object->event_value;
        }
        /* 0x432d1a copies defaults to channel state, then 0x4fc62d builds
         * the path and 0x4faf98 loads/plays. Decoder/device remain providers. */
        status = host->load_sound(host->context, &command);
        if (status != ACTION_SOUND_BACKEND_OK && status != ACTION_SOUND_BACKEND_NO_RESOURCE)
            return backend_status(status, why, "sound load failed");
        if (status == ACTION_SOUND_BACKEND_OK) {
            status = host->play_sound(host->context, command.channel);
            if (status != ACTION_SOUND_BACKEND_OK && status != ACTION_SOUND_BACKEND_NO_RESOURCE)
                return backend_status(status, why, "sound play failed");
        }
        if (command.transition_scene == 9999 && event_id == -1 && command.control_word == 0u) {
            /* 0x4334e1..0x43351d: scene 9999 and event -1 and control 0: direct byte
             * store, no 0x42ba3a/subtype reset. */
            out->direct = 1u;
            out->completed = 1u;
        } else out->phase = 1u;
        return ACTION_SOUND_OK;
    }
    if (in->phase == 1u) {
        int playing = 0;
        if (command.mode == 1u) { out->phase = 2u; return ACTION_SOUND_OK; }
        if (host == NULL || host->is_playing == NULL)
            return fail(why, "sound playing query provider", ACTION_SOUND_ERR_UNSUPPORTED);
        status = host->is_playing(host->context, command.channel, &playing);
        if (status == ACTION_SOUND_BACKEND_NO_RESOURCE) playing = 0;
        else if (status != ACTION_SOUND_BACKEND_OK)
            return backend_status(status, why, "sound query failed");
        if (playing != 0 && playing != 1)
            return fail(why, "invalid playing query value", ACTION_SOUND_ERR_BACKEND);
        if (playing == 0) out->phase = 2u;
        return ACTION_SOUND_OK;
    }
    if (command.mode == 0u && (host == NULL || host->unload_sound == NULL))
        return fail(why, "sound unload provider", ACTION_SOUND_ERR_UNSUPPORTED);
    if (command.transition_scene != 9999) {
        out->transition = 1u;
        out->request.target_scene = command.transition_scene;
        out->request.opaque_words[0] = s16(p + 0x93);
        out->request.opaque_words[1] = s16(p + 0x95);
        out->request.opaque_words[2] = s16(p + 0x97);
        /* Raw-97 constructor zeroes these three dwords. */
        memcpy(out->request.opaque_dwords, p + 0x99, 12u);
        out->request.scene_flag_value = (uint8_t)(s16(p + 0xa8) != 1);
        out->request.engine_state_value = 4u;
    }
    if (command.mode == 0u) {
        status = host->unload_sound(host->context, command.channel);
        if (status != ACTION_SOUND_BACKEND_OK && status != ACTION_SOUND_BACKEND_NO_RESOURCE)
            return backend_status(status, why, "sound unload failed");
    }
    /* 0x42ba3a: subtype 1 completes; subtype 2 clears/reset deps; all reset phase. */
    out->phase = 0u;
    out->finish = 1u;
    if (in->subtype == 1u) out->completed = 1u;
    else if (in->subtype == 2u) { out->completed = 0u; out->reset = 1u; }
    return ACTION_SOUND_OK;
}

int action_sound_object_step(const uint8_t *payload, size_t length, const A97Input *in,
                             ActionSoundBackend *host, const A97EventTable *events,
                             ActionSoundObjectResult *out, const char **why)
{
    /* Unlike the RT-8 entry point, every path leaves *out defined (all zero before a visit
     * starts), so a caller never reads stale event fields after a rejection. */
    if (out != NULL) memset(out, 0, sizeof(*out));
    return visit(payload, length, in, host, events, 1, out, why);
}

int action97_runtime_step(const uint8_t *p, size_t length, const A97Input *in,
                          ActionSoundBackend *host, A97Result *out, const char **why)
{
    ActionSoundObjectResult object;
    int status;
    if (out == NULL) return fail(why, "invalid runtime arguments", ACTION_SOUND_ERR_ARGUMENT);
    /* Early validation failures leave the caller's result untouched, as before RT-21. */
    memset(&object, 0, sizeof(object));
    object.visit = *out;
    status = visit(p, length, in, host, NULL, 0, &object, why);
    *out = object.visit;
    return status;
}
