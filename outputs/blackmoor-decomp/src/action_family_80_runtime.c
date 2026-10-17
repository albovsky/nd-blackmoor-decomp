#include "action_family_80_runtime.h"

int action_family_80_runtime_visit(const ActionFamily80Decoded *decoded, Action80Object *object, Action80World *world)
{
    int32_t word;

    if (decoded == NULL || object == NULL || world == NULL) {
        return ACTION_FAMILY_80_RUNTIME_ERR_ARGUMENT;
    }
    word = (int32_t)(int16_t)decoded->word_0;                            /* movsx word [body] */
    if (word != ACTION_FAMILY_80_SCENE_NONE) {                           /* 0x4e390a */
        world->scene_5bb57b = word;                                      /* 0x4e3912 */
        world->scene_5bb57f = word;                                      /* 0x4e391e */
        world->word_5bb599 = 0;
        world->word_5bb595 = 0;
        world->dword_5bb59b = 0;
        world->dword_5bb59f = 0;
        world->dword_5bb5a3 = 1;
        world->word_5c39ff = 1;
    } else {
        world->scene_5bb57b = (int32_t)object->scene_6ba;                /* 0x4e3969 */
        world->scene_5bb57f = (int32_t)object->scene_6ba;                /* 0x4e3978 */
    }
    world->word_5bb599 = object->word_6bc;                               /* 0x4e397e.. */
    world->word_5bb595 = object->word_6be;
    world->dword_5bb59b = object->dword_6c2;
    world->dword_5bb59f = object->dword_6c6;
    world->dword_5bb5a3 = object->dword_6ca;
    world->word_5c39ff = 1;
    world->engine_mode_583999 = ACTION_FAMILY_80_MODE_SCENE_CHANGE;      /* 0x4e39d4 */
    if (object->state_4528 == 2 || object->state_4528 == 3) {            /* 0x4e39de..0x4e39f4 */
        world->cell_583204 = 5;
        world->cell_5bb22a = 0;
        object->dword_4530 = 0;
        if ((int32_t)object->word_6b2 != ACTION_FAMILY_80_SCENE_NONE) {
            object->word_6b2 = (int16_t)ACTION_FAMILY_80_SCENE_NONE;
            if (object->dword_6b4 != 0) {
                object->dword_65d2 = 1;
                object->dword_6b4 = 0;
            }
        }
    }
    return ACTION_FAMILY_80_RUNTIME_OK;
}
