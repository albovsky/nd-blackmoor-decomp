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

int scene_stack_pop(SceneStackSlot *slot, SceneStackPop *out)
{
    SceneStackPop r;
    if (slot == NULL || out == NULL) {
        return SCENE_STACK_POP_ARGUMENT;
    }
    if (slot->scene_5c3a05 == SCENE_STACK_EMPTY_MARKER) { /* 0x42e496..0x42e4a2: movsx, cmp 0x270f */
        return SCENE_STACK_POP_EMPTY;
    }
    r.scene_5bb57b = slot->scene_5c3a07;                  /* 0x42e4c1: movsx ecx, word [0x5c3a07] */
    r.scene_5bb57f = slot->scene_5c3a07;                  /* 0x42e4ce: the same word again */
    r.word_5bb599 = slot->word_5c3a09;                    /* 0x42e4db */
    r.word_5bb595 = slot->word_5c3a0b;                    /* 0x42e4e7 */
    r.dword_5bb59b = slot->dword_5c3a0f;                  /* 0x42e4f5 */
    r.dword_5bb59f = slot->dword_5c3a13;                  /* 0x42e501 */
    r.dword_5bb5a3 = slot->dword_5c3a17;                  /* 0x42e50b */
    r.word_5c39ff = 1;                                    /* 0x42e517 */
    r.start_5bb1ca = slot->word_5c3a0d == 1 ? 0 : 1;      /* 0x42e520..0x42e53c */
    r.mode_583999 = 4;                                    /* 0x42e542 */
    *out = r;
    slot->scene_5c3a05 = SCENE_STACK_EMPTY_MARKER;        /* 0x42e54c */
    slot->scene_5c3a07 = SCENE_STACK_EMPTY_MARKER;        /* 0x42e555 */
    return SCENE_STACK_POP_OK;
}
