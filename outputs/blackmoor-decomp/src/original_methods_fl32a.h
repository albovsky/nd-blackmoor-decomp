#ifndef BLACKMOOR_ORIGINAL_METHODS_FL32A_H
#define BLACKMOOR_ORIGINAL_METHODS_FL32A_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-32 (batch a): nine small toggle and text-field handlers of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-31 batch a (see
 * original_methods_fl31a.h, whose conventions apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the
 * original address in its leading comment, `self` is the original object (ecx) as raw bytes at the original offsets, nothing is bounds checked, and the effects keep
 * the order of the original. The names are descriptive hints, not recovered source names.
 *
 * Calls into original code, the CRT and MFC go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one pushed = the first
 * argument of a C prototype). The address of a field of `self` or of a local buffer that the original passes to a callee is passed as the host pointer of it. The
 * globals of the original image are the fields of Fl32aWorld (named by their original address). A callee that changes `self` or a global that the function reads
 * again afterwards is not exercised (tasks/fl32a-handoff.md). Nothing here claims original source structure. */

typedef struct Fl32aWorld {
    uint8_t *table_5e60da;                              /* 0x4029a9, 0x4029f0, 0x402a37: the host memory of the original address 0x5e60da (dwords); the caller leaves slack for a negative index */
    uint16_t word_5ec33e, word_5ec340, word_5e5688;     /* 0x40425d, 0x404298, 0x4042d3: the word each one stores */
    uint16_t word_5e335e;                               /* 0x4067eb, 0x406832, 0x406879 */
    uint32_t dword_5e350e, dword_5e3512, dword_5e3516;  /* 0x4067eb, 0x406832, 0x406879: the flag each one toggles */
} Fl32aWorld;

/* 0x40425d, thiscall, plain `ret` (the stack is not used: ecx is stored and not used again). A local buffer of 0x14 bytes (zero here: the original leaves it uninitialised and the callee fills it):
 * 0x51d5b2(this self + 0xcc, buffer, 0x13) (thiscall, 2 arguments, callee pops 8: the first is the buffer, the second 0x13), then r = 0x50cb1b(buffer) (cdecl, 1 argument), word [0x5ec33e] = low word of r,
 * then 0x4033db(this self) (thiscall, no arguments). */
void m40425d_read_text_cc(uint8_t *self, Fl32aWorld *world, const Fl18Host *host);

/* 0x404298: the same as 0x40425d with the field self + 0x10c and the word [0x5ec340]. */
void m404298_read_text_10c(uint8_t *self, Fl32aWorld *world, const Fl18Host *host);

/* 0x4042d3: the same as 0x40425d with the field self + 0x1cc and the word [0x5e5688]. */
void m4042d3_read_text_1cc(uint8_t *self, Fl32aWorld *world, const Fl18Host *host);

/* 0x4029a9, thiscall, plain `ret`: i = dword [self+0x5c] (a 32-bit index; the table address wraps in 32 bits in the original, this port takes it as a signed index); when dword [0x5e60da + i*4] == 1
 * (a dword compare) it is set to 0, otherwise to 1; then 0x40236a(this self) (thiscall, no arguments). The index is read again for the store. */
void m4029a9_toggle_5e60da(uint8_t *self, Fl32aWorld *world, const Fl18Host *host);

/* 0x4029f0: the same as 0x4029a9 with the table at 0x5e60de. */
void m4029f0_toggle_5e60de(uint8_t *self, Fl32aWorld *world, const Fl18Host *host);

/* 0x402a37: the same as 0x4029a9 with the table at 0x5e60e2. */
void m402a37_toggle_5e60e2(uint8_t *self, Fl32aWorld *world, const Fl18Host *host);

/* 0x4067eb, thiscall, plain `ret`: when dword [0x5e350e] == 1 it is set to 0 and nothing else is stored. Otherwise it is set to 1 and, when the signed word [0x5e335e] == 1, that word is set to 0xffff.
 * Then 0x404be1(this self) (thiscall, no arguments). */
void m4067eb_toggle_5e350e(uint8_t *self, Fl32aWorld *world, const Fl18Host *host);

/* 0x406832: the same as 0x4067eb with the flag [0x5e3512] and the word compared with 2. */
void m406832_toggle_5e3512(uint8_t *self, Fl32aWorld *world, const Fl18Host *host);

/* 0x406879: the same as 0x4067eb with the flag [0x5e3516] and the word compared with 3. */
void m406879_toggle_5e3516(uint8_t *self, Fl32aWorld *world, const Fl18Host *host);

/* FNS-END */

#ifdef __cplusplus
}
#endif

#endif
