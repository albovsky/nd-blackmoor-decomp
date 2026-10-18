#ifndef BLACKMOOR_ORIGINAL_METHODS_FL19A_H
#define BLACKMOOR_ORIGINAL_METHODS_FL19A_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-19 batch a: more methods of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-18 (see
 * original_methods_fl18.h, which this header builds on and whose Fl18Host it uses unchanged): each function is its own symbol that
 * cites the original address in its leading comment, `self` is the original `this` object as raw bytes at the original offsets,
 * nothing is bounds-checked and every call into original code that is not ported here goes through Fl18Host.call (callee address,
 * ecx value, stack arguments with args[0] the LAST one pushed; a word that the original pushes from a 16-bit register is passed
 * with only its low 16 bits meaningful).
 *
 * What is new here:
 *  - Fl19aWorld.self_address is the original 32-bit address of the object `self`: 0x4cecf7 stores addresses derived from its
 *    `this` into globals, and a host pointer cannot be stored in a dword. An address derived from `self` that is only PASSED to a
 *    callee (0x47e2a5) is the host pointer cast to uintptr_t, as in FL-18.
 *  - An object that the original reaches through a dword address stored in memory (a record of the table 0x5bb5e5, the object
 *    [self+0x222], the array [self+0x226]) is reached through Fl18Host.resolve. The result is host memory of the original address;
 *    where the function writes through it (0x4ccff5) the const is cast away.
 *  - The string and record pointers a function takes as stack arguments are host pointers.
 *  - 0x423259 and 0x4e444d compare strings with the unrolled strcmp of the original (two bytes per pass, a result of -1, 0 or 1).
 *  - Nothing here claims original source structure. */

/* The original globals and tables the FL-19 batch-a methods touch (named by their address). A table pointer points at the byte that
 * the original address names; for a table that a signed index addresses the caller leaves slack below it. */
typedef struct Fl19aWorld {
    uint32_t self_address;           /* the original address of *self (0x4cecf7) */
    uint8_t *records_5bb5e5;         /* the records of stride 0x8d; fields below the pointer (0x5bb5e3) need slack under it */
    uint8_t *globals_5d1a31;         /* the bytes at 0x5d1a31 ... (0x4ceb3b: dword at 0x5d1a45, 0x4cecf7: the block and the string at 0x5d1a53) */
    const uint8_t *string_559b18;    /* the zero-terminated string at 0x559b18 (0x4cecf7) */
    const uint8_t *bytes_551b18;     /* the nine bytes at 0x551b18 (0x4b617a) */
    const uint8_t *table_5a2664;     /* records of stride 0x4a that start with a name (0x4e444d) */
    const uint8_t *table_5a434c;     /* records of stride 0x29 that start with a name (0x4e444d) */
    int16_t word_5a1e5e, word_5a1e60; /* the counts of those two tables */
    const uint8_t *table_5b30cc;     /* dword pairs, addressed by (dword 0x5b44f0 << 4) + dword 0x5b44f4 * 8 */
    const uint8_t *table_5b3e40;     /* the same shape (0x5b3e40, 0x5b3e44) */
    const uint8_t *table_5b3ae8;     /* signed word pairs, addressed by dword 0x5b44f4 * 4 + dword 0x5b44f0 * 8 */
    uint32_t value_583102, value_583106;
    uint32_t value_5b44f0, value_5b44f4, value_5b44f8;
    uint32_t value_5c39e5, value_5c39e9, value_5c3a47, value_5c3a5b, value_5c3a5f;
    uint32_t value_5bb1ca, value_5839a9, value_5bb57b, value_5bb59b, value_5bb59f, value_5bb5a3, value_583999;
    uint32_t value_5d0377, value_5d162d, value_5d1631, value_5d1639, value_571ad3;
    int16_t word_583a29;
    uint16_t word_583f1d, word_5bb599, word_5bb595, word_5c39ff;
} Fl19aWorld;

void m4ceb3b_reset_state(uint8_t *self, int16_t index, Fl19aWorld *world, const Fl18Host *host);
uint32_t m423f57_load_entry(uint8_t *self, const uint8_t *entry, uint32_t value, Fl19aWorld *world, const Fl18Host *host);
void m4cecf7_init_descriptor(uint8_t *self, const Fl19aWorld *world);
void m4ea269_select_piece(uint8_t *self, int16_t piece, int16_t mode, uint32_t flag, Fl19aWorld *world, const Fl18Host *host);
void m4ccdab_reset_object(uint8_t *self, Fl19aWorld *world);
void m47e2a5_release_surfaces(uint8_t *self, const Fl18Host *host);
uint32_t m423259_find_by_name(uint8_t *self, const uint8_t *name, const Fl18Host *host);
void m4e89eb_layout_slots(uint8_t *self, Fl19aWorld *world, const Fl18Host *host);
uint32_t m4e444d_find_name(int16_t kind, uint8_t *out, const uint8_t *name, const Fl19aWorld *world);
void m4b617a_arm_piece(uint8_t *self, Fl19aWorld *world, const Fl18Host *host);
void m4ccff5_free_piece(uint8_t *self, Fl19aWorld *world, const Fl18Host *host);
uint32_t m48d1e8_hit_test(uint8_t *self, int16_t x, int16_t y, Fl19aWorld *world, const Fl18Host *host);
uint32_t m475da4_hit_test(uint8_t *self, int16_t x, int16_t y, Fl19aWorld *world, const Fl18Host *host);
uint32_t m4ee2a9_hit_slots(uint8_t *self, Fl19aWorld *world, const Fl18Host *host);
uint32_t m48bd91_hit_test(uint8_t *self, int16_t x, int16_t y, Fl19aWorld *world, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
