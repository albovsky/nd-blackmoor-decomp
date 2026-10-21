#ifndef BLACKMOOR_ORIGINAL_METHODS_FL37_H
#define BLACKMOOR_ORIGINAL_METHODS_FL37_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-37: 57 flag-toggle handlers of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, near-copies of the ten flag toggles 0x4067a5..0x406af8 of FL-34 batch b (original_methods_fl34b.h) and of
 * the three of FL-32 batch a (see original_methods_fl32a.h, whose conventions apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_toggle_<flag>` that
 * cites the original address, the flag address and the word constant of its own row, `self` is the original object (ecx) kept only to be passed on, nothing is bounds checked,
 * and the effects keep the order of the original. The names are descriptive hints, not recovered source names.
 *
 * The one call goes through Fl18Host.call (callee address, ecx value, stack arguments; here none). The globals of the original image are the fields of Fl37World (named by
 * their original address). A callee that changes a global that the function reads again afterwards is not exercised (tasks/fl37-handoff.md). Nothing here claims original
 * source structure. */

typedef struct Fl37World {
    uint16_t word_5e335e;                               /* all 57: the signed word that is compared with the row's constant and set to 0xffff */
    uint32_t dword_5e353e, dword_5e3542, dword_5e3546;  /* 0x406b3f, 0x406b86, 0x406bcd */
    uint32_t dword_5e354a, dword_5e354e, dword_5e3552;  /* 0x406c14, 0x406c5b, 0x406ca2 */
    uint32_t dword_5e3556, dword_5e355a, dword_5e355e;  /* 0x406ce9, 0x406d30, 0x406d77 */
    uint32_t dword_5e3562, dword_5e3566, dword_5e356a;  /* 0x406dbe, 0x406e05, 0x406e4c */
    uint32_t dword_5e356e, dword_5e3572, dword_5e3576;  /* 0x406e93, 0x406eda, 0x406f21 */
    uint32_t dword_5e357a, dword_5e357e, dword_5e3582;  /* 0x406f68, 0x406faf, 0x406ff6 */
    uint32_t dword_5e3586, dword_5e358a, dword_5e358e;  /* 0x40703d, 0x407084, 0x4070cb */
    uint32_t dword_5e3592, dword_5e3596, dword_5e359a;  /* 0x407112, 0x407159, 0x4071a0 */
    uint32_t dword_5e359e, dword_5e35a2, dword_5e35a6;  /* 0x4071e7, 0x40722e, 0x407275 */
    uint32_t dword_5e35aa, dword_5e35ae, dword_5e35b2;  /* 0x4072bc, 0x407303, 0x40734a */
    uint32_t dword_5e35b6, dword_5e35ba, dword_5e35be;  /* 0x407391, 0x4073d8, 0x40741f */
    uint32_t dword_5e35c2, dword_5e35c6, dword_5e35ca;  /* 0x407466, 0x4074ad, 0x4074f4 */
    uint32_t dword_5e35ce, dword_5e35d2, dword_5e35d6;  /* 0x40753b, 0x407582, 0x4075c9 */
    uint32_t dword_5e35da, dword_5e35de, dword_5e35e2;  /* 0x407610, 0x407657, 0x40769e */
    uint32_t dword_5e35e6, dword_5e35ea, dword_5e35ee;  /* 0x4076e5, 0x40772c, 0x407773 */
    uint32_t dword_5e35f2, dword_5e35f6, dword_5e35fa;  /* 0x4077ba, 0x407801, 0x407848 */
    uint32_t dword_5e35fe, dword_5e3602, dword_5e3606;  /* 0x40788f, 0x4078d6, 0x40791d */
    uint32_t dword_5e360a, dword_5e360e, dword_5e3612;  /* 0x407964, 0x4079ab, 0x4079f2 */
    uint32_t dword_5e3616, dword_5e361a, dword_5e361e;  /* 0x407a39, 0x407a80, 0x407ac7 */
} Fl37World;

/* 0x406b3f (71 bytes), thiscall, plain `ret`: when dword [0x5e353e] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0xd (`movsx eax, word ptr [0x5e335e]; cmp eax, 0xd; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m406b3f_toggle_5e353e(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x406b86 (71 bytes), thiscall, plain `ret`: when dword [0x5e3542] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0xe (`movsx eax, word ptr [0x5e335e]; cmp eax, 0xe; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m406b86_toggle_5e3542(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x406bcd (71 bytes), thiscall, plain `ret`: when dword [0x5e3546] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0xf (`movsx eax, word ptr [0x5e335e]; cmp eax, 0xf; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m406bcd_toggle_5e3546(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x406c14 (71 bytes), thiscall, plain `ret`: when dword [0x5e354a] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x10 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x10; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m406c14_toggle_5e354a(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x406c5b (71 bytes), thiscall, plain `ret`: when dword [0x5e354e] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x11 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x11; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m406c5b_toggle_5e354e(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x406ca2 (71 bytes), thiscall, plain `ret`: when dword [0x5e3552] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x12 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x12; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m406ca2_toggle_5e3552(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x406ce9 (71 bytes), thiscall, plain `ret`: when dword [0x5e3556] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x13 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x13; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m406ce9_toggle_5e3556(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x406d30 (71 bytes), thiscall, plain `ret`: when dword [0x5e355a] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x14 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x14; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m406d30_toggle_5e355a(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x406d77 (71 bytes), thiscall, plain `ret`: when dword [0x5e355e] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x15 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x15; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m406d77_toggle_5e355e(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x406dbe (71 bytes), thiscall, plain `ret`: when dword [0x5e3562] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x16 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x16; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m406dbe_toggle_5e3562(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x406e05 (71 bytes), thiscall, plain `ret`: when dword [0x5e3566] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x17 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x17; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m406e05_toggle_5e3566(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x406e4c (71 bytes), thiscall, plain `ret`: when dword [0x5e356a] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x18 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x18; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m406e4c_toggle_5e356a(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x406e93 (71 bytes), thiscall, plain `ret`: when dword [0x5e356e] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x19 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x19; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m406e93_toggle_5e356e(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x406eda (71 bytes), thiscall, plain `ret`: when dword [0x5e3572] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x1a (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x1a; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m406eda_toggle_5e3572(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x406f21 (71 bytes), thiscall, plain `ret`: when dword [0x5e3576] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x1b (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x1b; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m406f21_toggle_5e3576(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x406f68 (71 bytes), thiscall, plain `ret`: when dword [0x5e357a] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x1c (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x1c; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m406f68_toggle_5e357a(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x406faf (71 bytes), thiscall, plain `ret`: when dword [0x5e357e] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x1d (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x1d; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m406faf_toggle_5e357e(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x406ff6 (71 bytes), thiscall, plain `ret`: when dword [0x5e3582] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x1e (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x1e; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m406ff6_toggle_5e3582(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x40703d (71 bytes), thiscall, plain `ret`: when dword [0x5e3586] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x1f (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x1f; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m40703d_toggle_5e3586(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x407084 (71 bytes), thiscall, plain `ret`: when dword [0x5e358a] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x20 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x20; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m407084_toggle_5e358a(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x4070cb (71 bytes), thiscall, plain `ret`: when dword [0x5e358e] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x21 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x21; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m4070cb_toggle_5e358e(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x407112 (71 bytes), thiscall, plain `ret`: when dword [0x5e3592] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x22 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x22; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m407112_toggle_5e3592(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x407159 (71 bytes), thiscall, plain `ret`: when dword [0x5e3596] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x23 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x23; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m407159_toggle_5e3596(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x4071a0 (71 bytes), thiscall, plain `ret`: when dword [0x5e359a] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x24 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x24; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m4071a0_toggle_5e359a(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x4071e7 (71 bytes), thiscall, plain `ret`: when dword [0x5e359e] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x25 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x25; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m4071e7_toggle_5e359e(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x40722e (71 bytes), thiscall, plain `ret`: when dword [0x5e35a2] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x26 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x26; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m40722e_toggle_5e35a2(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x407275 (71 bytes), thiscall, plain `ret`: when dword [0x5e35a6] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x27 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x27; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m407275_toggle_5e35a6(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x4072bc (71 bytes), thiscall, plain `ret`: when dword [0x5e35aa] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x28 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x28; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m4072bc_toggle_5e35aa(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x407303 (71 bytes), thiscall, plain `ret`: when dword [0x5e35ae] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x29 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x29; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m407303_toggle_5e35ae(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x40734a (71 bytes), thiscall, plain `ret`: when dword [0x5e35b2] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x2a (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x2a; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m40734a_toggle_5e35b2(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x407391 (71 bytes), thiscall, plain `ret`: when dword [0x5e35b6] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x2b (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x2b; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m407391_toggle_5e35b6(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x4073d8 (71 bytes), thiscall, plain `ret`: when dword [0x5e35ba] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x2c (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x2c; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m4073d8_toggle_5e35ba(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x40741f (71 bytes), thiscall, plain `ret`: when dword [0x5e35be] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x2d (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x2d; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m40741f_toggle_5e35be(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x407466 (71 bytes), thiscall, plain `ret`: when dword [0x5e35c2] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x2e (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x2e; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m407466_toggle_5e35c2(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x4074ad (71 bytes), thiscall, plain `ret`: when dword [0x5e35c6] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x2f (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x2f; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m4074ad_toggle_5e35c6(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x4074f4 (71 bytes), thiscall, plain `ret`: when dword [0x5e35ca] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x30 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x30; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m4074f4_toggle_5e35ca(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x40753b (71 bytes), thiscall, plain `ret`: when dword [0x5e35ce] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x31 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x31; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m40753b_toggle_5e35ce(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x407582 (71 bytes), thiscall, plain `ret`: when dword [0x5e35d2] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x32 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x32; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m407582_toggle_5e35d2(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x4075c9 (71 bytes), thiscall, plain `ret`: when dword [0x5e35d6] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x33 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x33; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m4075c9_toggle_5e35d6(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x407610 (71 bytes), thiscall, plain `ret`: when dword [0x5e35da] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x34 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x34; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m407610_toggle_5e35da(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x407657 (71 bytes), thiscall, plain `ret`: when dword [0x5e35de] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x35 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x35; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m407657_toggle_5e35de(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x40769e (71 bytes), thiscall, plain `ret`: when dword [0x5e35e2] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x36 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x36; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m40769e_toggle_5e35e2(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x4076e5 (71 bytes), thiscall, plain `ret`: when dword [0x5e35e6] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x37 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x37; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m4076e5_toggle_5e35e6(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x40772c (71 bytes), thiscall, plain `ret`: when dword [0x5e35ea] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x38 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x38; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m40772c_toggle_5e35ea(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x407773 (71 bytes), thiscall, plain `ret`: when dword [0x5e35ee] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x39 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x39; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m407773_toggle_5e35ee(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x4077ba (71 bytes), thiscall, plain `ret`: when dword [0x5e35f2] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x3a (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x3a; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m4077ba_toggle_5e35f2(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x407801 (71 bytes), thiscall, plain `ret`: when dword [0x5e35f6] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x3b (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x3b; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m407801_toggle_5e35f6(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x407848 (71 bytes), thiscall, plain `ret`: when dword [0x5e35fa] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x3c (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x3c; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m407848_toggle_5e35fa(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x40788f (71 bytes), thiscall, plain `ret`: when dword [0x5e35fe] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x3d (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x3d; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m40788f_toggle_5e35fe(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x4078d6 (71 bytes), thiscall, plain `ret`: when dword [0x5e3602] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x3e (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x3e; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m4078d6_toggle_5e3602(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x40791d (71 bytes), thiscall, plain `ret`: when dword [0x5e3606] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x3f (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x3f; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m40791d_toggle_5e3606(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x407964 (71 bytes), thiscall, plain `ret`: when dword [0x5e360a] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x40 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x40; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m407964_toggle_5e360a(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x4079ab (71 bytes), thiscall, plain `ret`: when dword [0x5e360e] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x41 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x41; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m4079ab_toggle_5e360e(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x4079f2 (71 bytes), thiscall, plain `ret`: when dword [0x5e3612] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x42 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x42; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m4079f2_toggle_5e3612(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x407a39 (71 bytes), thiscall, plain `ret`: when dword [0x5e3616] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x43 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x43; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m407a39_toggle_5e3616(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x407a80 (71 bytes), thiscall, plain `ret`: when dword [0x5e361a] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x44 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x44; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m407a80_toggle_5e361a(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* 0x407ac7 (73 bytes: 71 code bytes plus two `int3`), thiscall, plain `ret`: when dword [0x5e361e] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x45 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x45; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m407ac7_toggle_5e361e(uint8_t *self, Fl37World *world, const Fl18Host *host);

/* FNS-END */

#ifdef __cplusplus
}
#endif

#endif
