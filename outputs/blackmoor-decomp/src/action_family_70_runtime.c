#include "action_family_70_runtime.h"

int action_family_70_runtime_visit(const ActionFamily70Decoded *decoded, Action70World *world, const Action70Host *host)
{
    if (decoded == NULL || world == NULL || host == NULL || host->unload_scene_sound == NULL) {
        return ACTION_FAMILY_70_RUNTIME_ERR_ARGUMENT;
    }
    if (host->unload_scene_sound(host->context) != 0) {                  /* 0x429220 */
        return ACTION_FAMILY_70_RUNTIME_ERR_HOST;
    }
    world->next_state_583985 = 6;                                        /* 0x429225 */
    world->outer_state_583981 = 5;                                       /* 0x42922f */
    world->cell_583991 = 0;                                              /* 0x429239 */
    world->first_render_5bb1c4 = 1;                                      /* 0x429243 -> 0x43dbd5 */
    world->engine_mode_583999 = 0;                                       /* 0x429248 */
    world->cell_5bb1e2 = 0;                                              /* 0x429252 */
    return ACTION_FAMILY_70_RUNTIME_OK;
}
