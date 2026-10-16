#include "scene_stack.h"

#include <string.h>

void scene_stack_slot_clear(SceneStackSlot *slot)
{
    if (slot != NULL) {
        memset(slot, 0, sizeof(*slot));
    }
}

void scene_stack_slot_init_words(SceneStackSlot *slot)
{
    if (slot == NULL) {
        return;
    }
    slot->scene_5c3a05 = SCENE_STACK_EMPTY_MARKER;
    slot->scene_5c3a07 = SCENE_STACK_EMPTY_MARKER;
    slot->word_5c3a09 = 0;
    slot->word_5c3a0b = 0;
    slot->word_5c3a0d = 2;
}

void scene_stack_push(SceneStackSlot *slot, const SceneStackCurrent *current, int32_t type_argument)
{
    if (slot == NULL || current == NULL) {
        return;
    }
    slot->scene_5c3a05 = (int16_t)current->scene_5bb57b;   /* 0x42e563: mov ax, word [0x5bb57b] */
    slot->scene_5c3a07 = (int16_t)current->scene_5bb57f;   /* 0x42e56f */
    slot->word_5c3a09 = current->word_5bb50b;              /* 0x42e57d */
    slot->word_5c3a0b = current->word_5bb593;              /* 0x42e58b */
    slot->word_5c3a0d = (int16_t)type_argument;            /* 0x42e597: mov cx, word [ebp + 8] */
    slot->dword_5c3a0f = current->dword_5bb5a7;            /* 0x42e5a2 */
    slot->dword_5c3a13 = current->dword_5bb5ab;            /* 0x42e5ae..0x42e5b3 */
    slot->dword_5c3a13 = current->dword_5bb5af;            /* 0x42e5b8..0x42e5be overwrites the line above */
}
