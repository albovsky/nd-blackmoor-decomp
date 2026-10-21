#ifndef BLACKMOOR_ORIGINAL_METHODS_FL34C_H
#define BLACKMOOR_ORIGINAL_METHODS_FL34C_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-34 (batch c): eight small functions of GAME.EXE (SHA-256 afd337a2...5c45), the spill rows of FL-32, ported one to one in the style of FL-32 batch b (see
 * original_methods_fl32b.h, whose conventions apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original
 * address in its leading comment, `self` is the original object (ecx) as raw bytes at the original offsets, nothing is bounds checked, and the effects keep the order of
 * the original. The names are descriptive hints, not recovered source names.
 *
 * Calls into original code go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one pushed = the first argument of a C prototype).
 * A global of the original that the function only reads (0x5d2a1f.., 0x5cf665, 0x61c6ae, the record table at 0x5bb5e5) is read through Fl18Host.resolve at the point of
 * the original's read (before or after a call as the original does; a callee that changes it is therefore honoured). A global that the function writes is a field of
 * Fl34cWorld. The eax that the original leaves at its `ret` is returned. Nothing here claims original source structure. */

typedef struct Fl34cWorld {
    /* the words that 0x4d0abc / 0x4d0c17 / 0x4e01fb store: 0x5bb1c4 (all three, value 2) and 0x63a97c / 0x63a97e / 0x63a9d0 (value 0, one each). The neighbouring words are
     * carried so that a store of the wrong width or at the wrong place shows. */
    uint16_t word_5bb1c2, word_5bb1c4, word_5bb1c6;
    uint16_t word_63a97a, word_63a97c, word_63a97e, word_63a980;
    uint16_t word_63a9ce, word_63a9d0, word_63a9d2;
} Fl34cWorld;

/* 0x4d0abc, plain `ret`, ecx unused, no stack arguments: eax = 0x4c5377 (thiscall, ecx = 0x5cf659, 5 stack arguments, `ret 0x14`) called with, from the first to the last
 * argument: dword [0x5d2a1f], dword [0x5cf665], dword [0x5d2a23], dword [0x5d2a27] and the constant 0x55a05c (the original reads 0x5d2a27 first, then 0x5d2a23, 0x5cf665 and 0x5d2a1f
 * last, and pushes the constant before all of them). Afterwards, in this order: word [0x5bb1c4] = 2, word [0x63a97c] = 0. Returns the eax of the call. */
uint32_t m4d0abc_post_message(Fl34cWorld *world, const Fl18Host *host);

/* 0x4d0c17: the same with the globals 0x5d2bdb / 0x5d2bdf / 0x5d2be3, the constant 0x55a0e8 and the word [0x63a97e] = 0 (the word [0x5bb1c4] = 2 as above). */
uint32_t m4d0c17_post_message(Fl34cWorld *world, const Fl18Host *host);

/* 0x4e01fb: the same with the globals 0x5d2819 / 0x5d281d / 0x5d2821, the constant 0x55ba9c and the word [0x63a9d0] = 0 (the word [0x5bb1c4] = 2 as above). */
uint32_t m4e01fb_post_message(Fl34cWorld *world, const Fl18Host *host);

/* 0x4cca9c, thiscall, `ret 0x10`, four stack arguments (rec = a pointer to an object of at least 0x2c bytes, host pointer here; a1, a2, a3 dwords): calls 0x4cc962 (thiscall
 * with ecx = self, 1 stack argument = rec, `ret 4`), then dword [rec] = a1, dword [rec + 0x14] = a2, dword [rec + 0x28] = a3 (in this order). `rec` may alias `self`. The eax
 * left at the `ret` is a3 (the last register load); it is returned. */
uint32_t m4cca9c_fill_record(uint8_t *self, uint8_t *rec, uint32_t a1, uint32_t a2, uint32_t a3, const Fl18Host *host);

/* 0x446f77, thiscall, plain `ret`: 0x51d716 (thiscall, ecx = self, no stack arguments), then dword [self] = 0x52ca58 (a vtable pointer of the original), dword [self + 0x31] = 0,
 * dword [self + 0x35] = 0 (unaligned, in this order). Returns self. */
uint8_t *m446f77_construct(uint8_t *self, const Fl18Host *host);

/* 0x4fce5e, thiscall (ecx stored and unused), `ret 4`, one stack argument of which only the low word `index` is used (movsx): d = dword at the original address
 * 0x5bb5e5 + (int32)index * 0x8d (32-bit imul, unaligned read through Fl18Host.resolve); returns the eax of 0x4f7e93 (thiscall, ecx = 0x5cf1eb, 1 stack argument = d, `ret 4`). */
uint32_t m4fce5e_call_with_record_dword(int16_t index, const Fl18Host *host);

/* 0x4d3ffe, thiscall, plain `ret`: dword [self + 0x440] = 1; 0x4dad60 (thiscall, ecx = 0x5830a6, no stack arguments); dword [self + 0x462] = 0 (unaligned); then the byte at
 * the original address 0x61c6ae, zero-extended, is read AFTER the call: when it is 0, dword [self + 0x1c] = 0. Returns the eax left at the `ret`: self when the byte is 0, the eax
 * of 0x4dad60 otherwise. */
uintptr_t m4d3ffe_start_flag(uint8_t *self, const Fl18Host *host);

/* 0x47a3d9, thiscall, plain `ret`: x = 0x4789d6 (thiscall, ecx = self, no stack arguments). When the 32-bit x is not 0: dword [self + 0x1576] = 1, dword [self + 0x24] = 1 (in this
 * order, unaligned) and self is returned; when it is 0: dword [self + 0x1576] = 0 and 0 is returned. */
uintptr_t m47a3d9_set_flags(uint8_t *self, const Fl18Host *host);

/* FNS-END */

#ifdef __cplusplus
}
#endif

#endif
