#ifndef BLACKMOOR_ACTION_FAMILY_80_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_80_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#include "action_family_80.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0x80, "scene change that carries the return tuple of the overlay object" (RT-48; 2 corpus rows in 2 scenes).
 *
 * Original code (GAME.EXE, SHA-256 afd337a2...5c45), confirmed in the disassembly and by the original-x86 oracle:
 *   0x40e73f  loader arm (action_family_80.c): the 2-byte body is one word.
 *   0x427a50  dispatcher arm 0x42960b (type 0x80, gate 0x423f57 mode 0): for a true gate 0x4e386e(ECX = the object 0x57975c,
 *             row), then the row's completion byte := 1 directly (0x42964e): no generic completion, no dependency reset, the
 *             phase word is not written.
 *   0x4e386e  w = signed body word. w != 9999 (0x270f): [0x5bb57b] := [0x5bb57f] := w and the transition words are zeroed
 *             (0x5bb599, 0x5bb595, 0x5bb59b, 0x5bb59f := 0, 0x5bb5a3 := 1, 0x5c39ff := 1); w == 9999: [0x5bb57b] := [0x5bb57f]
 *             := signed object word +0x6ba. Then (both ways) the transition words are taken from the object: 0x5bb599 := word
 *             +0x6bc, 0x5bb595 := word +0x6be, 0x5bb59b := dword +0x6c2, 0x5bb59f := dword +0x6c6, 0x5bb5a3 := dword +0x6ca,
 *             0x5c39ff := 1, and the engine mode [0x583999] := 4 (scene change).
 *             If the object's state dword +0x4528 is 2 or 3: [0x583204] := 5, [0x5bb22a] := 0, object +0x4530 := 0 and, when
 *             the signed object word +0x6b2 is not 9999, it becomes 9999 and, when the object dword +0x6b4 is nonzero, object
 *             +0x65d2 := 1 and +0x6b4 := 0.
 *             With the debug flag 0x63a4cd set the method first logs; the native module models the flag as 0.
 * The object is a large UI singleton the app does not model; the fields below are the ones this method reads or writes. Who sets
 * the return tuple (+0x6ba..+0x6ca, written by 0x4e3a64) is host behaviour.
 * Nothing here claims original source structure. */

#define ACTION_FAMILY_80_RUNTIME_OK 0
#define ACTION_FAMILY_80_RUNTIME_ERR_ARGUMENT 1

#define ACTION_FAMILY_80_SCENE_NONE 0x270f   /* a scene word of 9999 means "use the stored return tuple" */
#define ACTION_FAMILY_80_MODE_SCENE_CHANGE 4

/* The fields of the object at 0x57975c this method touches (offsets in the names). */
typedef struct {
    int16_t scene_6ba;
    int16_t word_6bc;
    int16_t word_6be;
    int32_t dword_6c2;
    int32_t dword_6c6;
    int32_t dword_6ca;
    int32_t state_4528;
    int16_t word_6b2;
    int32_t dword_6b4;
    int32_t dword_4530;
    int32_t dword_65d2;
} Action80Object;

/* Process globals the method writes. */
typedef struct {
    int32_t scene_5bb57b;
    int32_t scene_5bb57f;
    int16_t word_5bb599;
    int16_t word_5bb595;
    int32_t dword_5bb59b;
    int32_t dword_5bb59f;
    int32_t dword_5bb5a3;
    int16_t word_5c39ff;
    int32_t engine_mode_583999;
    int32_t cell_583204;
    int32_t cell_5bb22a;
} Action80World;

/* One true-gate visit of 0x4e386e. ACTION_FAMILY_80_RUNTIME_OK; _ERR_ARGUMENT on a null pointer. Nothing changes on an error. */
int action_family_80_runtime_visit(const ActionFamily80Decoded *decoded, Action80Object *object, Action80World *world);

#ifdef __cplusplus
}
#endif
#endif
