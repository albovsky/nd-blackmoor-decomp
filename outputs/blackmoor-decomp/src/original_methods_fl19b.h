#ifndef BLACKMOOR_ORIGINAL_METHODS_FL19B_H
#define BLACKMOOR_ORIGINAL_METHODS_FL19B_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-19 (batch b): more functions of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-18 (see
 * original_methods_fl18.h, whose Fl18Host is reused unchanged): each is its own symbol that cites the original address in its leading
 * comment, `self` is the original `this` object as raw bytes at the original offsets, nothing is bounds-checked, and the effects keep
 * the order of the original.
 *
 * Calls into original code that is not ported here go through Fl18Host.call (callee address, ecx value, stack arguments with args[0]
 * the LAST one pushed); a stack argument the original pushed from a 16-bit register is a "word": only its low 16 bits are meaningful
 * (the rest of the pushed dword is whatever the register held). An address that the original keeps in an object or a record is a
 * 32-bit original address: Fl18Host.resolve turns it into host memory where the function reads through it. A buffer or string that
 * the caller passes by pointer, and the locals the original hands to a callee, are host pointers.
 *
 * The x87 code of 0x4fca60 is ported with C double arithmetic (the original runs with the 53-bit precision control of the Microsoft
 * runtime, so every x87 operation rounds like an IEEE double), and its calls of the truncating float-to-int routine 0x50ce04 (which
 * takes st0) go through Fl18Host.call with args[0] = the bit pattern of that double (a 64-bit uintptr_t is required). The host's
 * 0x50ce04 must act like fistp qword and return the low dword of the int64 truncation (out of range, NaN and Inf give 0, 2^31..2^63
 * wraps to the low 32 bits); a saturating (int32_t) cast is wrong. Build original_methods_fl19b.c with -ffp-contract=off.
 *
 * Nothing here claims original source structure. */

/* The globals and tables of the original that the batch touches (named by their address). A table pointer points at the byte that the
 * original address names; for a table that a signed index addresses the caller leaves slack below it. */
typedef struct Fl19bWorld {
    uint8_t *records_5bb5e5;       /* dwords of stride 0x8d: address of the object of record n; record +0x4d is also used in place */
    uint8_t *table_5d1591;         /* records of stride 0x4a (0x4460d6, 0x4462d3 write them, 0x48ded7 reads the dword at +8) */
    const uint8_t *string_548218;  /* zero-terminated strings that 0x4460d6 and 0x4462d3 copy into the table above */
    const uint8_t *string_548228;
    const uint8_t *bytes_5b5128;   /* bytes indexed by a signed word (0x4d00f4) */
    const uint8_t *bytes_54ab5c;   /* the nine bytes that 0x45b872 compares a record field with */
    uint8_t *strings_5957cb;       /* 0x412787: strings of 0x21 bytes, groups of 0x3390 bytes */
    uint8_t *words_59fbdb;         /* 0x412787: one count (signed word) per group */
    uint8_t *words_59f27b;         /* 0x412787: groups of 0x320 bytes of words */
    uint8_t *words_59fbe1;         /* 0x412787: groups of 0x320 bytes of words */
    int32_t origin_x_583186, origin_y_58318a;
    uint32_t value_5cf665, value_5d1a83, value_5d15e3;
    uint32_t value_5b44f0, value_5b44f4, value_5d0377, value_5d162d, value_5d1631, value_5d1639, value_5c39e5;
    uint32_t value_5bb1ca;
    uint32_t value_61d374, value_61d370;
    int16_t word_5b5159, word_61d363, word_61d36c, word_61d36e, word_61d361, word_6247ee;
    uint8_t byte_61d369, byte_61d36b, byte_61d36a;
    float scale_52e4e0;            /* 0x4fca60: the float at 0x52e4e0 ... */
    double bias_52e4d8;            /* ... and the double at 0x52e4d8 */
    uint8_t shift_5d2f1b, mask_5d2f1f, shift_5d2f1a, mask_5d2f1e, shift_5d2f19, mask_5d2f1d;
} Fl19bWorld;

void m44d597_press(uint8_t *self, int32_t arg, Fl19bWorld *world, const Fl18Host *host);
void m41f986_init_strings(uint8_t *self, const Fl18Host *host);
void m4d00f4_draw_list(const Fl19bWorld *world, const Fl18Host *host);
void m45b872_click(uint8_t *self, Fl19bWorld *world, const Fl18Host *host);
int32_t m434630_find_name(uint8_t *self, const uint8_t *name, const Fl18Host *host);
void m4c7481_pack_555(const uint8_t *self, uint8_t *buf, uint32_t size);
int16_t m4d3836_text_width(const uint8_t *text, const uint8_t *font, const uint8_t *table, const Fl18Host *host);
void m4460d6_load_layout(uint8_t *self, const uint8_t *src, Fl19bWorld *world);
void m48ded7_draw_hover(Fl19bWorld *world, const Fl18Host *host);
int32_t m45b5bb_pointer_move(uint8_t *self, int16_t x, int16_t y, const Fl19bWorld *world, const Fl18Host *host);
void m4462d3_load_layout(uint8_t *self, const uint8_t *src, Fl19bWorld *world);
void m412787_register_name(int16_t index, const Fl19bWorld *world, const Fl18Host *host);
void m4fca60_set_channel_scalars(uint8_t *self, int16_t channel, uint32_t first, uint32_t second, const Fl19bWorld *world,
                                 const Fl18Host *host);
void m447ac7_split_pixels(uint8_t *self, uintptr_t arg, uint8_t *dst, const Fl19bWorld *world, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
