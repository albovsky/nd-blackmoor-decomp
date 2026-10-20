#ifndef BLACKMOOR_ORIGINAL_METHODS_FL31A_H
#define BLACKMOOR_ORIGINAL_METHODS_FL31A_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-31 (batch a): small struct methods of GAME.EXE (SHA-256 afd337a2...5c45) around 0x47b200 ported one to one, in the style of FL-29 batch a (see
 * original_methods_fl29a.h, whose conventions apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the
 * original address in its leading comment, `self` is the original object (ecx) as raw bytes at the original offsets, nothing is bounds checked, and the effects keep
 * the order of the original. The names are descriptive hints, not recovered source names.
 *
 * Calls into original code, the CRT and the imports go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one pushed = the first
 * argument of a C prototype); GetTickCount (import 0x52a23c) is Fl18Host.tick. A dword of `self` that holds an address of the original is a 32-bit original address
 * and goes through Fl18Host.resolve; only `self` and the Fl31aWorld table pointer are host pointers. The address of a field of `self` that the original passes to a
 * callee (0x47b321: self + 8) is passed as the host pointer of that field. A callee that changes `self` or a global that the function reads again afterwards is not
 * exercised (tasks/fl31a-handoff.md). Nothing here claims original source structure. */

typedef struct Fl31aWorld {
    uint8_t *table_5d15a5;     /* 0x47b3bc, 0x47d640: records of stride 0x4a at the original address 0x5d15a5 (the dword at +0 is set); the caller leaves slack for a negative index */
    uint32_t value_5c39e5, value_5d0377, value_5d162d, value_5b44f0, value_5b44f4, value_5d1631, value_5d1639;    /* 0x47b709 */
} Fl31aWorld;

/* 0x47b200, thiscall, plain `ret`, returns this (eax): dword [self] = 0x52d568 (the table pointer of the object), then 0x47b23b(this self) (thiscall, no arguments). */
uint8_t *m47b200_construct(uint8_t *self, const Fl18Host *host);

/* 0x47b3bc, thiscall, plain `ret`: when dword [self+0x24] == 0 nothing. Otherwise i = signed word [self+4]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m47b3bc_mark_entry(const uint8_t *self, const Fl31aWorld *world);

/* 0x47d640, thiscall, plain `ret`: when byte [self+0x57] == 0 nothing. Otherwise i = signed word [self+0x23] (unaligned); when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m47d640_mark_entry(const uint8_t *self, const Fl31aWorld *world);

/* FNS-END */

#ifdef __cplusplus
}
#endif

#endif
