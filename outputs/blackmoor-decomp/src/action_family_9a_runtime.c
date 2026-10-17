#include "action_family_9a_runtime.h"

#define STOP_ALL_FROM_0 0x14
#define STOP_ALL_FROM_1 0x15
#define STOP_CHANNEL_END 14

static uint32_t body_dword(const ActionFamily9ADecoded *d, unsigned word_index)
{
    return (uint32_t)d->word[word_index] | ((uint32_t)d->word[word_index + 1u] << 16);
}

int action_family_9a_runtime_visit(const ActionFamily9ADecoded *decoded, uint32_t phase, Action9AWorld *world,
                                   const Action9AHost *host, Action9AOutcome *outcome)
{
    int16_t sound, scene, flag_index;
    Action9AWorld next;
    int16_t channel;

    if (decoded == NULL || world == NULL || host == NULL || outcome == NULL || host->stop_channel == NULL ||
        host->event_flag_invalid == NULL || host->store_event_flag == NULL) {
        return ACTION_FAMILY_9A_RUNTIME_ERR_ARGUMENT;
    }
    outcome->phase = phase;
    outcome->disposition = SCENE_ACTION_HANDLER_PENDING;
    outcome->worked = 0;
    outcome->transition = 0;
    if (phase == 0u) {                                                   /* 0x4336ea: state := 2 */
        outcome->phase = 2u;
        return ACTION_FAMILY_9A_RUNTIME_OK;
    }
    if (phase != 2u) {                                                   /* 0x4336e5: any other state does nothing */
        return ACTION_FAMILY_9A_RUNTIME_OK;
    }
    sound = (int16_t)decoded->word[0];
    scene = (int16_t)decoded->word[1];
    flag_index = (int16_t)decoded->word[11];
    if (flag_index != -1 && host->event_flag_invalid(host->context, flag_index) != 0) {
        return ACTION_FAMILY_9A_RUNTIME_ERR_FLAG;
    }
    if (sound == STOP_ALL_FROM_0 || sound == STOP_ALL_FROM_1) {          /* 0x433709, 0x43370e */
        for (channel = (int16_t)(sound != STOP_ALL_FROM_0); channel < STOP_CHANNEL_END; ++channel) {
            if (host->stop_channel(host->context, (uint16_t)channel) != 0) {
                return ACTION_FAMILY_9A_RUNTIME_ERR_HOST;
            }
        }
    } else if (host->stop_channel(host->context, (uint16_t)sound) != 0) {
        return ACTION_FAMILY_9A_RUNTIME_ERR_HOST;
    }
    next = *world;
    if (scene != ACTION_FAMILY_9A_SCENE_NONE) {                          /* 0x4337f4 */
        next.scene_5bb57b = scene;
        next.word_5bb599 = (int16_t)decoded->word[2];
        next.word_5bb595 = (int16_t)decoded->word[3];
        next.word_5c39ff = (int16_t)decoded->word[4];
        next.dword_5bb59b = (int32_t)body_dword(decoded, 5u);
        next.dword_5bb59f = (int32_t)body_dword(decoded, 7u);
        next.dword_5bb5a3 = (int32_t)body_dword(decoded, 9u);
        /* The word at bytes 25..26: high byte of word 12 and the last body byte. */
        next.start_flag_5bb1ca = ((int16_t)(uint16_t)((decoded->word[12] >> 8) | ((uint16_t)decoded->byte_26 << 8)) != 1);
        next.engine_mode_583999 = 4;
        outcome->transition = 1;
    }
    if (flag_index != -1 &&
        host->store_event_flag(host->context, flag_index, (uint32_t)(decoded->word[12] & 0xffu)) != 0) { /* 0x43889f */
        return ACTION_FAMILY_9A_RUNTIME_ERR_HOST;
    }
    *world = next;
    outcome->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;        /* 0x4338b0: completion byte := 1 */
    outcome->worked = 1;
    return ACTION_FAMILY_9A_RUNTIME_OK;
}
