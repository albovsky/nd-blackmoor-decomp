#ifndef BLACKMOOR_ORIGINAL_METHODS_FL34B_H
#define BLACKMOOR_ORIGINAL_METHODS_FL34B_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-34 (batch b): ten flag-toggle handlers of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, the same shape as the three flag toggles 0x4067eb, 0x406832 and 0x406879 of
 * FL-32 batch a (see original_methods_fl32a.h, whose conventions apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_toggle_<flag>` that
 * cites the original address, the flag address and the word constant of its own row, `self` is the original object (ecx) kept only to be passed on, nothing is bounds checked,
 * and the effects keep the order of the original. The names are descriptive hints, not recovered source names.
 *
 * The one call goes through Fl18Host.call (callee address, ecx value, stack arguments; here none). The globals of the original image are the fields of Fl34bWorld (named by
 * their original address). A callee that changes a global that the function reads again afterwards is not exercised (tasks/fl34b-handoff.md). Nothing here claims original
 * source structure. */

typedef struct Fl34bWorld {
    uint16_t word_5e335e;                               /* all ten: the signed word that is compared with the row's constant and set to 0xffff */
    uint32_t dword_5e350a;                              /* 0x4067a5 */
    uint32_t dword_5e351a, dword_5e351e, dword_5e3522;  /* 0x4068c0, 0x406907, 0x40694e */
    uint32_t dword_5e3526, dword_5e352a, dword_5e352e;  /* 0x406995, 0x4069dc, 0x406a23 */
    uint32_t dword_5e3532, dword_5e3536, dword_5e353a;  /* 0x406a6a, 0x406ab1, 0x406af8 */
} Fl34bWorld;

/* 0x4067a5 (70 bytes), thiscall, plain `ret`: when dword [0x5e350a] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] is 0 (`movsx eax, word ptr [0x5e335e]; test eax, eax; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m4067a5_toggle_5e350a(uint8_t *self, Fl34bWorld *world, const Fl18Host *host);

/* 0x4068c0 (71 bytes), thiscall, plain `ret`: when dword [0x5e351a] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x4 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x4; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m4068c0_toggle_5e351a(uint8_t *self, Fl34bWorld *world, const Fl18Host *host);

/* 0x406907 (71 bytes), thiscall, plain `ret`: when dword [0x5e351e] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x5 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x5; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m406907_toggle_5e351e(uint8_t *self, Fl34bWorld *world, const Fl18Host *host);

/* 0x40694e (71 bytes), thiscall, plain `ret`: when dword [0x5e3522] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x6 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x6; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m40694e_toggle_5e3522(uint8_t *self, Fl34bWorld *world, const Fl18Host *host);

/* 0x406995 (71 bytes), thiscall, plain `ret`: when dword [0x5e3526] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x7 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x7; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m406995_toggle_5e3526(uint8_t *self, Fl34bWorld *world, const Fl18Host *host);

/* 0x4069dc (71 bytes), thiscall, plain `ret`: when dword [0x5e352a] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x8 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x8; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m4069dc_toggle_5e352a(uint8_t *self, Fl34bWorld *world, const Fl18Host *host);

/* 0x406a23 (71 bytes), thiscall, plain `ret`: when dword [0x5e352e] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0x9 (`movsx eax, word ptr [0x5e335e]; cmp eax, 0x9; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m406a23_toggle_5e352e(uint8_t *self, Fl34bWorld *world, const Fl18Host *host);

/* 0x406a6a (71 bytes), thiscall, plain `ret`: when dword [0x5e3532] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0xa (`movsx eax, word ptr [0x5e335e]; cmp eax, 0xa; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m406a6a_toggle_5e3532(uint8_t *self, Fl34bWorld *world, const Fl18Host *host);

/* 0x406ab1 (71 bytes), thiscall, plain `ret`: when dword [0x5e3536] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0xb (`movsx eax, word ptr [0x5e335e]; cmp eax, 0xb; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m406ab1_toggle_5e3536(uint8_t *self, Fl34bWorld *world, const Fl18Host *host);

/* 0x406af8 (71 bytes), thiscall, plain `ret`: when dword [0x5e353a] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 0xc (`movsx eax, word ptr [0x5e335e]; cmp eax, 0xc; jne`), that word is set to
 * 0xffff. Then 0x404be1(this self) (thiscall, no arguments). */
void m406af8_toggle_5e353a(uint8_t *self, Fl34bWorld *world, const Fl18Host *host);

/* FNS-END */

#ifdef __cplusplus
}
#endif

#endif
