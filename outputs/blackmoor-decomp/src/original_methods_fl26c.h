#ifndef BLACKMOOR_ORIGINAL_METHODS_FL26C_H
#define BLACKMOOR_ORIGINAL_METHODS_FL26C_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-26 (batch c, the 0x62 interaction path): the function 0x424346 of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one in the style of
 * FL-25 / FL-26 batch b (see original_methods_fl26b.h, whose conventions apply unchanged and whose Fl18Host from original_methods_fl18.h is
 * reused): it is its own symbol that cites the original address in its leading comment, `self` is the original `this` object (ecx) as raw
 * bytes at the original offsets, and the effects keep the order of the original. Calls into original code go through Fl18Host.call
 * (callee address, ecx value (0 for a cdecl or stdcall callee), stack arguments with args[0] the LAST one pushed). A pointer that an
 * object or argument keeps is the 32-bit original address; Fl18Host.resolve turns it into host memory. The global tables that the
 * original indexes by a signed word (0x583bd5, 0x585801, 0x581a71, 0x587b2d, 0x585d65) are read through Fl18Host.resolve at their
 * original addresses too, so that a wild index is an unresolved address, not a wild host read.
 *
 * Unsafe original behaviour is rejected explicitly, not reproduced: an address that Fl18Host.resolve cannot resolve (the original would
 * read or write wild memory) sets *reject to FL26C_REJECT_UNRESOLVED; the call stops at that point (effects already made stay made). This
 * is a native-only behaviour, documented in tasks/fl26c-handoff.md; the original has no such branch. The function has no loop and no
 * buffer, so there is no endless-loop or overrun rejection.
 *
 * Host contract (as in FL-25): the Fl26cWorld scalars are a snapshot. A host that backs a callee with real original code must flush the
 * world to the original's memory BEFORE each Fl18Host.call and resync it AFTER the call. A callee that changes `self`, the node or a global
 * that the function re-reads is not exercised by the tests of this slice. Nothing here claims original source structure. */

#define FL26C_REJECT_UNRESOLVED 1   /* Fl18Host.resolve returned NULL for an address the original dereferences (or `self` is NULL where it is read) */

typedef struct Fl26cWorld {
    int16_t word_583a29;       /* the current item (a signed word) */
    int16_t word_58c94f;       /* kind 0xf */
    int16_t word_5bb20a;       /* kind 0xc */
    int16_t word_63a4cd;       /* kind 0x14: tested as a signed word before the range check */
    uint32_t value_5bb202;     /* kind 0x10 */
    uint32_t value_5bb57b;     /* the dword that the diagnostic format calls receive */
    int32_t value_585d37;      /* kind 4 */
    int32_t value_585d41;      /* kind 5 */
    int32_t value_585d4b;      /* kind 6 */
    uint32_t value_5c3a47;     /* kind 0x15 */
} Fl26cWorld;

/* 0x424346 (thiscall, `ret 4`): evaluates the condition of the node `node` (the argument [ebp+8], an original address of a 0x48+ byte object).
 * Reads the signed words kind [+0x10], a [+0x12], b [+0x14] (and [+0x16], which the original loads and never uses), the address q = node + 0x18,
 * and the dwords d [+0x20], e [+0x24], f [+0x28]; then switches on the kind (unsigned compare against 0x16 first: a negative kind is out of range):
 * stores 1 or 0 into the dword [node + 4] (kinds 0 to 6, 9, 0xb to 0x11, 0x15, 0x16; kind 0 always 1), except that kind 0xb also
 * writes through [[node + 0x48] + 0x14] and kind 0x14 draws a random number once (0x50cd50, flag [node + 0x2c]). Out-of-range kinds, the kinds 7, 8,
 * 0xa, 0x12, 0x13, a bad mode of kind 9 and a bad b of kind 6 call the diagnostic path (0x50ca3e, 0x42639d or 0x52139c, then 0x4c97b4 with this = 0x5cf659). */
void m424346_node_condition(uint8_t *self, uint32_t node, const Fl26cWorld *world, const Fl18Host *host, int32_t *reject);

#ifdef __cplusplus
}
#endif

#endif
