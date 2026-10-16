#ifndef BLACKMOOR_SCENE_STACK_H
#define BLACKMOOR_SCENE_STACK_H

/* RT-28: the saved-scene slot written by raw action 0x6e (dispatcher arm 0x42916f) through 0x42e560.
 *
 * GAME.EXE keeps three small "return to this scene" records (0x5c3a05, 0x5c3a1b and 0x5c3a31); only the first is
 * written by 0x42e560 and read back by its pair 0x42e493 (raw action 0x6f and two other callers). This module owns
 * the first record and the one function that fills it. The pop 0x42e493 is NOT here (it is the next family, 0x6f).
 *
 * The record is not a stack: a second push overwrites the first. Words keep the original widths and addresses, but the C struct is padded (sizeof 24, the original record is 22
 * bytes): never memcpy it to or from original memory; a pop must copy field by field. */

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define SCENE_STACK_EMPTY_MARKER 0x270f /* a scene word of 9999 means "nothing saved" */

/* The scene words of the running scene that 0x42e560 reads (process globals). After a successful load, 0x5bb57b and
 * 0x5bb57f hold the loaded scene, and 0x439f20..0x439f64 copied the transition request words into the rest:
 * 0x5bb599 -> 0x5bb50b, 0x5bb595 -> 0x5bb593, 0x5bb59b -> 0x5bb5a7, 0x5bb59f -> 0x5bb5ab, 0x5bb5a3 -> 0x5bb5af. */
typedef struct scene_stack_current {
    int32_t scene_5bb57b;
    int32_t scene_5bb57f;
    int16_t word_5bb50b;
    int16_t word_5bb593;
    int32_t dword_5bb5a7;
    int32_t dword_5bb5ab;
    int32_t dword_5bb5af;
} SceneStackCurrent;

/* The record at 0x5c3a05..0x5c3a1a. dword_5c3a17 is read by the pop but never written by 0x42e560 (it stays 0). */
typedef struct scene_stack_slot {
    int16_t scene_5c3a05;
    int16_t scene_5c3a07;
    int16_t word_5c3a09;
    int16_t word_5c3a0b;
    int16_t word_5c3a0d;
    int32_t dword_5c3a0f;
    int32_t dword_5c3a13;
    int32_t dword_5c3a17;
} SceneStackSlot;

/* Process start state of the record: all zero (the image holds zeros there). */
void scene_stack_slot_clear(SceneStackSlot *slot);

/* 0x436fe4..0x437008, run by the game initializer: the two scene words become 9999, the two words 0, the type
 * word 2. The three dwords are not touched. */
void scene_stack_slot_init_words(SceneStackSlot *slot);

/* 0x42e560 (cdecl, one stack argument whose low word is stored): copies the running scene's words into the record.
 * The original copies 0x5bb5ab to 0x5c3a13 and then overwrites it with 0x5bb5af (the dword at 0x5c3a17 is not
 * written); both stores are reproduced, so the surviving value is 0x5bb5af. */
void scene_stack_push(SceneStackSlot *slot, const SceneStackCurrent *current, int32_t type_argument);

#ifdef __cplusplus
}
#endif
#endif
