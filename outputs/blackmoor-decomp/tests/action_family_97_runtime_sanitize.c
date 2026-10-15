#include "action_family_97_runtime.h"

#include <assert.h>
#include <stdlib.h>
#include <string.h>

static ActionSoundBackendStatus caption(void *ctx, const ActionSoundCaptionRequest *r)
{ (void)ctx; assert(r->length < 32768u); return ACTION_SOUND_BACKEND_OK; }
static ActionSoundBackendStatus load(void *ctx, const ActionSoundAudioCommand *c)
{ (void)ctx; assert(c->channel < 32u); return ACTION_SOUND_BACKEND_OK; }
static ActionSoundBackendStatus channel(void *ctx, uint16_t ch)
{ (void)ctx; assert(ch < 32u); return ACTION_SOUND_BACKEND_OK; }
static ActionSoundBackendStatus query(void *ctx, uint16_t ch, int *playing)
{ (void)ctx; assert(ch < 32u); *playing = 0; return ACTION_SOUND_BACKEND_OK; }

int main(void)
{
    uint8_t body[50] = {0};
    uint8_t payload[172];
    ActionFamily97Constructed constructed;
    A97Input in = {0, 1, 0, 1};
    A97Result result;
    ActionSoundBackend host = {NULL, NULL, caption, load, channel, query, channel};
    const char *why;
    unsigned i;
    body[0] = 1; body[2] = '*'; body[3] = 'a';
    body[35] = 13; body[37] = 1; body[41] = 75; body[43] = 75;
    body[46] = 15; body[47] = 39; /* no scene: 9999 */
    assert(action_family_97_construct(body, sizeof(body), 1, 50, NULL, NULL,
        payload, sizeof(payload), &constructed) == 0);
    for (i = 0; i < 172u; ++i) {
        uint8_t *short_payload = (uint8_t *)malloc(i != 0u ? i : 1u);
        assert(short_payload != NULL);
        memcpy(short_payload, payload, i);
        assert(action97_runtime_step(short_payload, i, &in, &host, &result, &why) == ACTION_SOUND_ERR_BODY);
        free(short_payload);
    }
    for (i = 0; i < 12000u; ++i) {
        int status;
        uint8_t modified[172];
        memcpy(modified, payload, sizeof(modified));
        modified[0x21] = (uint8_t)(i % 40u);
        modified[0x90] = (uint8_t)(i % 3u);
        in.phase = i % 5u; in.subtype = (uint8_t)(i % 4u);
        status = action97_runtime_step(modified, sizeof(modified), &in, &host, &result, &why);
        assert(status == ACTION_SOUND_OK || status == ACTION_SOUND_ERR_UNSUPPORTED);
    }
    return 0;
}
