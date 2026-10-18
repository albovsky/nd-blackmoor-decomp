#include "action_family_7d_runtime.h"

#include <string.h>

void scene_restore_slot_clear(SceneRestoreSlot *slot)
{
    if (slot != NULL) {
        memset(slot, 0, sizeof(*slot));
    }
}

void scene_restore_slot_init_words(SceneRestoreSlot *slot)
{
    if (slot == NULL) {
        return;
    }
    slot->marker_5c3a1b = SCENE_RESTORE_EMPTY_MARKER;   /* 0x437011 */
    slot->scene_5c3a1d = SCENE_RESTORE_EMPTY_MARKER;    /* 0x43701a */
    slot->word_5c3a1f = 0;                              /* 0x437023 */
    slot->word_5c3a21 = 0;                              /* 0x43702c */
    slot->word_5c3a23 = 2;                              /* 0x437035 */
}

/* original GAME.EXE 0x4eb70f (FUN_004eb70f): saver of the second "return to this scene" record 0x5c3a1b..0x5c3a2f from the running-scene globals and the one stack argument (low word). */
void scene_restore_slot_save(SceneRestoreSlot *slot, const SceneStackCurrent *current, int32_t type_argument)
{
    if (slot == NULL || current == NULL) {
        return;
    }
    slot->marker_5c3a1b = (int16_t)current->scene_5bb57b;   /* 0x4eb716: mov ax, word [0x5bb57b] */
    slot->scene_5c3a1d = (int16_t)current->scene_5bb57f;    /* 0x4eb722 */
    slot->word_5c3a1f = current->word_5bb50b;               /* 0x4eb730 */
    slot->word_5c3a21 = current->word_5bb593;               /* 0x4eb73e */
    slot->word_5c3a23 = (int16_t)type_argument;             /* 0x4eb74a: mov cx, word [ebp + 8] */
    slot->dword_5c3a25 = current->dword_5bb5a7;             /* 0x4eb755 */
    slot->dword_5c3a29 = current->dword_5bb5ab;             /* 0x4eb761..0x4eb766 */
    slot->dword_5c3a29 = current->dword_5bb5af;             /* 0x4eb76b..0x4eb771 overwrites the line above */
}

int scene_restore_slot_pop(SceneRestoreSlot *slot, SceneStackPop *out)
{
    SceneStackPop r;
    int status = SCENE_RESTORE_POP_OK;
    if (slot == NULL || out == NULL) {
        return SCENE_RESTORE_POP_ARGUMENT;
    }
    if (slot->marker_5c3a1b == SCENE_RESTORE_EMPTY_MARKER) {   /* 0x4eb5f9..0x4eb605 */
        status = SCENE_RESTORE_POP_EMPTY;                       /* 0x4eb620: [0x5c3a1b] := 0, and carry on */
    }
    r.scene_5bb57b = slot->scene_5c3a1d;                        /* 0x4eb629: movsx edx, word [0x5c3a1d] */
    r.scene_5bb57f = slot->scene_5c3a1d;                        /* 0x4eb636: the same word again */
    r.word_5bb599 = slot->word_5c3a1f;                          /* 0x4eb642 */
    r.word_5bb595 = slot->word_5c3a21;                          /* 0x4eb650 */
    r.dword_5bb59b = slot->dword_5c3a25;                        /* 0x4eb65e */
    r.dword_5bb59f = slot->dword_5c3a29;                        /* 0x4eb668 */
    r.dword_5bb5a3 = slot->dword_5c3a2d;                        /* 0x4eb674 */
    r.word_5c39ff = 1;                                          /* 0x4eb680 */
    r.start_5bb1ca = slot->word_5c3a23 == 1 ? 0 : 1;            /* 0x4eb689..0x4eb6a1 */
    r.mode_583999 = 4;                                          /* 0x4eb6d9 */
    *out = r;
    slot->marker_5c3a1b = SCENE_RESTORE_EMPTY_MARKER;           /* 0x4eb6e3 */
    slot->scene_5c3a1d = SCENE_RESTORE_EMPTY_MARKER;            /* 0x4eb6ec */
    return status;
}

int action7d_visit(const Action7dModel *model, const Action7dHost *host, Action7dResult *result, const char **failure)
{
    const char *why = "none";
    SceneRestoreSlot popped;
    SceneStackPop pop;
    Action78Result added;
    int16_t item;
    int taken;
    int open_inventory;

    if (failure == NULL) {
        failure = &why;
    }
    if (model == NULL || host == NULL || result == NULL || model->slot == NULL || model->held_selector == NULL ||
        model->view_close_flag == NULL) {
        *failure = "invalid argument";
        return ACTION7D_ERR_ARGUMENT;
    }
    if (host->scene_change == NULL) {
        *failure = "scene-change provider (0x4eb5f2 starts a scene change: mode 4, start flag 0x5bb1ca)";
        return ACTION7D_ERR_UNSUPPORTED;
    }
    item = *model->held_selector;
    taken = item != -1;                                  /* 0x4eb6ab: cmp ecx, -1 */
    open_inventory = *model->view_close_flag == 0u;      /* 0x4eb6fa..0x4eb702 */
    if (taken && host->inventory.request_ui_animation == NULL) {
        *failure = "UI animation provider (0x4e0559 after the item is re-added)";
        return ACTION7D_ERR_UNSUPPORTED;
    }
    if (open_inventory && host->open_inventory == NULL) {
        *failure = "inventory-open provider (byte 0x583232)";
        return ACTION7D_ERR_UNSUPPORTED;
    }
    popped = *model->slot;                               /* the record changes only once the host accepted the scene change */
    if (scene_restore_slot_pop(&popped, &pop) != SCENE_RESTORE_POP_OK) {
        *failure = "the second saved-scene record is empty (nothing was saved by the examine branch 0x4ea269)";
        return ACTION7D_ERR_EMPTY;
    }
    memset(result, 0, sizeof(*result));
    result->pop = pop;
    if (taken) {
        int status = action78_add_item(item, 0, &model->inventory, &host->inventory, &added, failure);   /* 0x4eb6c4 */
        if (status != ACTION78_OK) {
            return status == ACTION78_ERR_UNSUPPORTED ? ACTION7D_ERR_UNSUPPORTED : status;
        }
        result->item_taken_along = 1u;
        result->item = item;
        result->readded = added.added != 0u;
        if (host->inventory.request_ui_animation(host->inventory.context, 1, 0, 0) != 0) {   /* 0x4eb6cf */
            *failure = "UI animation request was refused";
            return ACTION7D_ERR_HOST;
        }
    }
    if (host->scene_change(host->context, &pop) != 0) {
        *failure = "scene-change request was refused";
        return ACTION7D_ERR_HOST;
    }
    *model->slot = popped;
    if (open_inventory) {
        if (host->open_inventory(host->context) != 0) {                                          /* 0x4eb704 */
            *failure = "inventory-open request was refused";
            return ACTION7D_ERR_HOST;
        }
        result->inventory_open_requested = 1u;
    }
    *model->held_selector = -1;                          /* 0x429539 */
    result->selector_cleared = 1u;
    result->completed = 1u;                              /* 0x42954f */
    *failure = "none";
    return ACTION7D_OK;
}
