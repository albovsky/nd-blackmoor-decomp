#include "action_family_6d_runtime.h"

Action6DTeardown action_family_6d_runtime_select(const Action6DWorld *world)
{
    if (world->overlay_flag_5bb22a != 0) {                               /* 0x4290e7 */
        return ACTION_FAMILY_6D_TEARDOWN_OVERLAY;
    }
    if (world->popup_mode_583204 == 4) {                                 /* 0x4290fc */
        return ACTION_FAMILY_6D_TEARDOWN_MODE4;
    }
    if (world->popup_mode_583204 == 3) {                                 /* 0x429111 */
        return ACTION_FAMILY_6D_TEARDOWN_MODE3;
    }
    return ACTION_FAMILY_6D_TEARDOWN_NONE;
}

int action_family_6d_runtime_visit(const ActionFamily6DDecoded *decoded, Action6DWorld *world, const Action6DHost *host)
{
    Action6DWorld next;
    Action6DTeardown kind;

    if (decoded == NULL || world == NULL || host == NULL || host->unload_scene_sound == NULL) {
        return ACTION_FAMILY_6D_RUNTIME_ERR_ARGUMENT;
    }
    kind = action_family_6d_runtime_select(world);
    if (kind != ACTION_FAMILY_6D_TEARDOWN_NONE && host->teardown == NULL) {
        return ACTION_FAMILY_6D_RUNTIME_ERR_TEARDOWN;
    }
    next = *world;
    if (kind != ACTION_FAMILY_6D_TEARDOWN_NONE) {
        if (host->teardown(host->context, kind) != 0) {                  /* 0x4290f5, 0x42910a, 0x42911f */
            return ACTION_FAMILY_6D_RUNTIME_ERR_HOST;
        }
        next.popup_mode_583204 = 0;                                      /* in each teardown function */
        if (kind == ACTION_FAMILY_6D_TEARDOWN_OVERLAY) {
            next.overlay_flag_5bb22a = 0;
            next.overlay_return_6b2 = ACTION_FAMILY_6D_STORED_RETURN_SCENE;
        }
    }
    if (host->unload_scene_sound(host->context) != 0) {                  /* 0x429129 */
        return ACTION_FAMILY_6D_RUNTIME_ERR_HOST;
    }
    next.outer_state_583981 = 6;                                         /* 0x42912e */
    next.cell_5839a1 = 0;                                                /* 0x429138 */
    next.engine_mode_583999 = 0;                                         /* 0x429142 */
    next.cell_5bb1e2 = 0;                                                /* 0x42914c */
    *world = next;
    return ACTION_FAMILY_6D_RUNTIME_OK;
}
