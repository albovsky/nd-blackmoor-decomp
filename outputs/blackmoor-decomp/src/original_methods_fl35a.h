#ifndef BLACKMOOR_ORIGINAL_METHODS_FL35A_H
#define BLACKMOOR_ORIGINAL_METHODS_FL35A_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-35 (batch a): the 28 tag readers of GAME.EXE (SHA-256 afd337a2...5c45) from 0x40a5c1 to 0x40af0b that FL-32 batch b did not take (its 0x40a613 and 0x40a665 are the two
 * rows in between), ported one to one in the style of FL-32 batch b (see original_methods_fl32b.h, whose conventions apply unchanged, and the Fl18Host of original_methods_fl18.h):
 * each is its own symbol `m<va>_read_tag_word` that cites the original address in its leading comment, `self` is the original object (ecx) as raw bytes at the original offsets,
 * nothing is bounds checked, and the effects keep the order of the original. The names are descriptive hints, not recovered source names.
 *
 * Every row has the same body with three constants (the string field offset, the original address of a 4-byte tag, the original address of a word that receives a value):
 * a local buffer b of 0x14 bytes (zero here: the original leaves it uninitialised and the callee fills it); 0x51d5b2(this = self + field, b, 0x13) (thiscall, 2 stack arguments, the
 * callee pops them); the 4 bytes b[0..3] are compared with the 4 bytes at the original address `tag` (the compare ends at the first differing byte); when they are NOT all equal,
 * x = 0x50cb1b(b) (cdecl, 1 argument) and the word [word] = low 16 bits of x; finally the function returns 0x4090ab(this self) (thiscall, no arguments). The tag bytes go through
 * Fl18Host.resolve. The constants of every row were read from its own disassembly; the rows are not assumed to follow a pattern (the tag addresses and word addresses do advance
 * by 4 and 2, with the field offset advancing by 0x40, from the second row on). A callee that changes `self` or a global that the function reads again afterwards is not exercised. */

typedef struct Fl35aWorld {
    /* the thirty words 0x5ec2d6 .. 0x5ec310: each row stores one of them (0x40a613 and 0x40a665, FL-32, store 0x5ec2d8 and 0x5ec2da); the others are carried so that a store of the wrong width or at the wrong place shows */
    uint16_t word_5ec2d6, word_5ec2d8, word_5ec2da, word_5ec2dc, word_5ec2de, word_5ec2e0;
    uint16_t word_5ec2e2, word_5ec2e4, word_5ec2e6, word_5ec2e8, word_5ec2ea, word_5ec2ec;
    uint16_t word_5ec2ee, word_5ec2f0, word_5ec2f2, word_5ec2f4, word_5ec2f6, word_5ec2f8;
    uint16_t word_5ec2fa, word_5ec2fc, word_5ec2fe, word_5ec300, word_5ec302, word_5ec304;
    uint16_t word_5ec306, word_5ec308, word_5ec30a, word_5ec30c, word_5ec30e, word_5ec310;
} Fl35aWorld;

/* 0x40a5c1, thiscall, plain `ret`, returns eax of its last callee: the shared body with the object field self + 0x8c, the tag at the original address 0x53ec58 and the word [0x5ec2d6]. */
uint32_t m40a5c1_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host);

/* 0x40a6b7, thiscall, plain `ret`, returns eax of its last callee: the shared body with the object field self + 0x14c, the tag at the original address 0x53ec64 and the word [0x5ec2dc]. */
uint32_t m40a6b7_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host);

/* 0x40a709, thiscall, plain `ret`, returns eax of its last callee: the shared body with the object field self + 0x18c, the tag at the original address 0x53ec68 and the word [0x5ec2de]. */
uint32_t m40a709_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host);

/* 0x40a75b, thiscall, plain `ret`, returns eax of its last callee: the shared body with the object field self + 0x1cc, the tag at the original address 0x53ec6c and the word [0x5ec2e0]. */
uint32_t m40a75b_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host);

/* 0x40a7ad, thiscall, plain `ret`, returns eax of its last callee: the shared body with the object field self + 0x20c, the tag at the original address 0x53ec70 and the word [0x5ec2e2]. */
uint32_t m40a7ad_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host);

/* 0x40a7ff, thiscall, plain `ret`, returns eax of its last callee: the shared body with the object field self + 0x24c, the tag at the original address 0x53ec74 and the word [0x5ec2e4]. */
uint32_t m40a7ff_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host);

/* 0x40a851, thiscall, plain `ret`, returns eax of its last callee: the shared body with the object field self + 0x28c, the tag at the original address 0x53ec78 and the word [0x5ec2e6]. */
uint32_t m40a851_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host);

/* 0x40a8a3, thiscall, plain `ret`, returns eax of its last callee: the shared body with the object field self + 0x2cc, the tag at the original address 0x53ec7c and the word [0x5ec2e8]. */
uint32_t m40a8a3_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host);

/* 0x40a8f5, thiscall, plain `ret`, returns eax of its last callee: the shared body with the object field self + 0x30c, the tag at the original address 0x53ec80 and the word [0x5ec2ea]. */
uint32_t m40a8f5_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host);

/* 0x40a947, thiscall, plain `ret`, returns eax of its last callee: the shared body with the object field self + 0x34c, the tag at the original address 0x53ec84 and the word [0x5ec2ec]. */
uint32_t m40a947_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host);

/* 0x40a999, thiscall, plain `ret`, returns eax of its last callee: the shared body with the object field self + 0x38c, the tag at the original address 0x53ec88 and the word [0x5ec2ee]. */
uint32_t m40a999_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host);

/* 0x40a9eb, thiscall, plain `ret`, returns eax of its last callee: the shared body with the object field self + 0x3cc, the tag at the original address 0x53ec8c and the word [0x5ec2f0]. */
uint32_t m40a9eb_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host);

/* 0x40aa3d, thiscall, plain `ret`, returns eax of its last callee: the shared body with the object field self + 0x40c, the tag at the original address 0x53ec90 and the word [0x5ec2f2]. */
uint32_t m40aa3d_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host);

/* 0x40aa8f, thiscall, plain `ret`, returns eax of its last callee: the shared body with the object field self + 0x44c, the tag at the original address 0x53ec94 and the word [0x5ec2f4]. */
uint32_t m40aa8f_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host);

/* 0x40aae1, thiscall, plain `ret`, returns eax of its last callee: the shared body with the object field self + 0x48c, the tag at the original address 0x53ec98 and the word [0x5ec2f6]. */
uint32_t m40aae1_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host);

/* 0x40ab33, thiscall, plain `ret`, returns eax of its last callee: the shared body with the object field self + 0x4cc, the tag at the original address 0x53ec9c and the word [0x5ec2f8]. */
uint32_t m40ab33_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host);

/* 0x40ab85, thiscall, plain `ret`, returns eax of its last callee: the shared body with the object field self + 0x50c, the tag at the original address 0x53eca0 and the word [0x5ec2fa]. */
uint32_t m40ab85_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host);

/* 0x40abd7, thiscall, plain `ret`, returns eax of its last callee: the shared body with the object field self + 0x54c, the tag at the original address 0x53eca4 and the word [0x5ec2fc]. */
uint32_t m40abd7_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host);

/* 0x40ac29, thiscall, plain `ret`, returns eax of its last callee: the shared body with the object field self + 0x58c, the tag at the original address 0x53eca8 and the word [0x5ec2fe]. */
uint32_t m40ac29_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host);

/* 0x40ac7b, thiscall, plain `ret`, returns eax of its last callee: the shared body with the object field self + 0x5cc, the tag at the original address 0x53ecac and the word [0x5ec300]. */
uint32_t m40ac7b_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host);

/* 0x40accd, thiscall, plain `ret`, returns eax of its last callee: the shared body with the object field self + 0x60c, the tag at the original address 0x53ecb0 and the word [0x5ec302]. */
uint32_t m40accd_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host);

/* 0x40ad1f, thiscall, plain `ret`, returns eax of its last callee: the shared body with the object field self + 0x64c, the tag at the original address 0x53ecb4 and the word [0x5ec304]. */
uint32_t m40ad1f_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host);

/* 0x40ad71, thiscall, plain `ret`, returns eax of its last callee: the shared body with the object field self + 0x68c, the tag at the original address 0x53ecb8 and the word [0x5ec306]. */
uint32_t m40ad71_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host);

/* 0x40adc3, thiscall, plain `ret`, returns eax of its last callee: the shared body with the object field self + 0x6cc, the tag at the original address 0x53ecbc and the word [0x5ec308]. */
uint32_t m40adc3_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host);

/* 0x40ae15, thiscall, plain `ret`, returns eax of its last callee: the shared body with the object field self + 0x70c, the tag at the original address 0x53ecc0 and the word [0x5ec30a]. */
uint32_t m40ae15_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host);

/* 0x40ae67, thiscall, plain `ret`, returns eax of its last callee: the shared body with the object field self + 0x74c, the tag at the original address 0x53ecc4 and the word [0x5ec30c]. */
uint32_t m40ae67_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host);

/* 0x40aeb9, thiscall, plain `ret`, returns eax of its last callee: the shared body with the object field self + 0x78c, the tag at the original address 0x53ecc8 and the word [0x5ec30e]. */
uint32_t m40aeb9_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host);

/* 0x40af0b, thiscall, plain `ret`, returns eax of its last callee: the shared body with the object field self + 0x7cc, the tag at the original address 0x53eccc and the word [0x5ec310]. */
uint32_t m40af0b_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host);

/* FNS-END */

#ifdef __cplusplus
}
#endif

#endif
