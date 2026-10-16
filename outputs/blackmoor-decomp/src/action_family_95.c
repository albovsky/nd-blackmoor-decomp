#include "action_family_95.h"

ActionFamily95Status action_family_95_decode(const uint8_t *body, size_t length,
                                             ActionFamily95Decoded *out)
{
    volatile double quotient;
    uint16_t word;

    if (body == NULL || out == NULL) {
        return ACTION_FAMILY_95_ERR_ARGUMENT;
    }
    if (length < ACTION_FAMILY_95_BODY_BYTES) {
        return ACTION_FAMILY_95_ERR_BODY;
    }
    word = (uint16_t)((uint16_t)body[0] | ((uint16_t)body[1] << 8));
    out->channel = (int16_t)word;
    out->volume_percent = body[2];
    /* fild / fdiv qword [0x52c680] (100.0) / fstp dword: double division
     * rounded once to float. */
    quotient = (double)body[2] / 100.0;
    out->scalar = (float)quotient;
    return ACTION_FAMILY_95_OK;
}

ActionFamily95Status action_family_95_visit(const ActionFamily95Decoded *decoded,
                                            const ActionFamily95Host *host)
{
    if (decoded == NULL || host == NULL) {
        return ACTION_FAMILY_95_ERR_ARGUMENT;
    }
    if (decoded->channel < 0 ||
        (uint32_t)decoded->channel >= ACTION_FAMILY_95_CHANNEL_COUNT) {
        return ACTION_FAMILY_95_ERR_BOUNDS;
    }
    if (host->set_channel_scalars == NULL) {
        return ACTION_FAMILY_95_ERR_UNSUPPORTED;
    }
    if (host->set_channel_scalars(host->context, (uint16_t)decoded->channel,
                                  decoded->scalar, decoded->scalar) != 0) {
        return ACTION_FAMILY_95_ERR_HOST;
    }
    return ACTION_FAMILY_95_OK;
}
