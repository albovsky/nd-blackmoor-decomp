#ifndef BLACKMOOR_ORIGINAL_METHODS_FL35B_H
#define BLACKMOOR_ORIGINAL_METHODS_FL35B_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-35 (batch b): 36 small functions of GAME.EXE (SHA-256 afd337a2...5c45) from 0x4080fc to 0x408904 ported one to one, in the style of FL-32 batch a and b (see
 * original_methods_fl32b.h, whose conventions apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original
 * address in its leading comment, `self` is the original object (ecx) as raw bytes at the original offsets, nothing is bounds checked, and the effects keep the order of the
 * original. The names are descriptive hints, not recovered source names.
 *
 * One toggle (0x4080fc) and 35 text readers (0x40812e to 0x408904). Every reader has the same body with two constants (the string field offset and the original address of a word
 * that receives a value): a local buffer b of 0x14 bytes (zero here: the original leaves it uninitialised and the callee fills it); 0x51d5b2(this = self + field, b, 0x13) (thiscall,
 * 2 stack arguments, the callee pops them); x = 0x50cb1b(b) (cdecl, 1 argument); the word [word] = low 16 bits of x; the function returns 0x407ca7(this self) (thiscall, no
 * arguments). The constants of every row were read from its own disassembly; the field offsets advance by 0x40 and the words by 2 from row to row. A callee that changes `self`
 * or a global that the function reads again afterwards is not exercised (the callee 0x407ca7 reads the word 0x5ec28c that 0x4080fc toggles; it is a stub here). */

typedef struct Fl35bWorld {
    /* the thirty-six words 0x5ec28c .. 0x5ec2d2: 0x4080fc toggles 0x5ec28c, each reader stores one of the others; carried together so that a store of the wrong width or at the wrong place shows */
    uint16_t word_5ec28c, word_5ec28e, word_5ec290, word_5ec292, word_5ec294, word_5ec296;
    uint16_t word_5ec298, word_5ec29a, word_5ec29c, word_5ec29e, word_5ec2a0, word_5ec2a2;
    uint16_t word_5ec2a4, word_5ec2a6, word_5ec2a8, word_5ec2aa, word_5ec2ac, word_5ec2ae;
    uint16_t word_5ec2b0, word_5ec2b2, word_5ec2b4, word_5ec2b6, word_5ec2b8, word_5ec2ba;
    uint16_t word_5ec2bc, word_5ec2be, word_5ec2c0, word_5ec2c2, word_5ec2c4, word_5ec2c6;
    uint16_t word_5ec2c8, word_5ec2ca, word_5ec2cc, word_5ec2ce, word_5ec2d0, word_5ec2d2;
} Fl35bWorld;

/* 0x4080fc, thiscall, plain `ret`, returns eax of its last callee: the word [0x5ec28c] (a signed 16-bit read) becomes 0 when it is non-zero and 1 when it is zero; then 0x407ca7(this self). */
uint32_t m4080fc_toggle_5ec28c(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x40812e, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x8c and the word [0x5ec28e]. */
uint32_t m40812e_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x408169, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0xcc and the word [0x5ec290]. */
uint32_t m408169_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x4081a4, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x10c and the word [0x5ec292]. */
uint32_t m4081a4_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x4081df, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x14c and the word [0x5ec294]. */
uint32_t m4081df_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x40821a, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x18c and the word [0x5ec296]. */
uint32_t m40821a_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x408255, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x1cc and the word [0x5ec298]. */
uint32_t m408255_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x408290, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x20c and the word [0x5ec29a]. */
uint32_t m408290_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x4082cb, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x24c and the word [0x5ec29c]. */
uint32_t m4082cb_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x408306, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x28c and the word [0x5ec29e]. */
uint32_t m408306_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x408341, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x2cc and the word [0x5ec2a0]. */
uint32_t m408341_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x40837c, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x30c and the word [0x5ec2a2]. */
uint32_t m40837c_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x4083b7, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x34c and the word [0x5ec2a4]. */
uint32_t m4083b7_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x4083f2, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x38c and the word [0x5ec2a6]. */
uint32_t m4083f2_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x40842d, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x3cc and the word [0x5ec2a8]. */
uint32_t m40842d_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x408468, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x40c and the word [0x5ec2aa]. */
uint32_t m408468_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x4084a3, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x44c and the word [0x5ec2ac]. */
uint32_t m4084a3_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x4084de, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x48c and the word [0x5ec2ae]. */
uint32_t m4084de_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x408519, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x4cc and the word [0x5ec2b0]. */
uint32_t m408519_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x408554, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x50c and the word [0x5ec2b2]. */
uint32_t m408554_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x40858f, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x54c and the word [0x5ec2b4]. */
uint32_t m40858f_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x4085ca, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x58c and the word [0x5ec2b6]. */
uint32_t m4085ca_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x408605, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x5cc and the word [0x5ec2b8]. */
uint32_t m408605_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x408640, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x60c and the word [0x5ec2ba]. */
uint32_t m408640_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x40867b, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x64c and the word [0x5ec2bc]. */
uint32_t m40867b_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x4086b6, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x68c and the word [0x5ec2be]. */
uint32_t m4086b6_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x4086f1, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x6cc and the word [0x5ec2c0]. */
uint32_t m4086f1_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x40872c, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x70c and the word [0x5ec2c2]. */
uint32_t m40872c_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x408767, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x74c and the word [0x5ec2c4]. */
uint32_t m408767_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x4087a2, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x78c and the word [0x5ec2c6]. */
uint32_t m4087a2_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x4087dd, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x7cc and the word [0x5ec2c8]. */
uint32_t m4087dd_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x408818, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x80c and the word [0x5ec2ca]. */
uint32_t m408818_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x408853, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x84c and the word [0x5ec2cc]. */
uint32_t m408853_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x40888e, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x88c and the word [0x5ec2ce]. */
uint32_t m40888e_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x4088c9, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x8cc and the word [0x5ec2d0]. */
uint32_t m4088c9_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* 0x408904, thiscall, plain `ret`, returns eax of its last callee: the shared reader with the object field self + 0x90c and the word [0x5ec2d2]. */
uint32_t m408904_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host);

/* FNS-END */

#ifdef __cplusplus
}
#endif

#endif
