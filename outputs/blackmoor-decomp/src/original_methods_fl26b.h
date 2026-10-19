#ifndef BLACKMOOR_ORIGINAL_METHODS_FL26B_H
#define BLACKMOOR_ORIGINAL_METHODS_FL26B_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-26 (batch b, the 0x62 interaction path): functions of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one in the style of FL-25 (see
 * original_methods_fl25a.h, whose conventions apply unchanged and whose Fl18Host from original_methods_fl18.h is reused): each is its own symbol
 * that cites the original address in its leading comment, `self` is the original `this` object (ecx) as raw bytes at the original offsets,
 * and the effects keep the order of the original. Calls into original code go through Fl18Host.call (callee address, ecx value (0 for a
 * cdecl or stdcall callee), stack arguments with args[0] the LAST one pushed). A pointer that an object or argument keeps is the 32-bit
 * original address; Fl18Host.resolve turns it into host memory (a function that writes through it casts the const away, as in FL-25).
 *
 * Unsafe original behaviour is rejected explicitly, not reproduced: an address that Fl18Host.resolve cannot resolve (the original would read
 * or write wild memory), an endless loop of the original (a node of an unknown kind, a cycle of the chain, a string longer than the local
 * buffer). The functions with such a case take `int32_t *reject`: it is set to 0 for valid input, else to one of the
 * FL26B_REJECT_ codes (NULL is allowed except for m423fbb, whose rejection also returns INT32_MIN, a value its sign-extended word can never have, so it is never
 * invisible); a rejected call stops at that point (effects already made stay made) and returns 0 (m423fbb: INT32_MIN). This is a native-only
 * behaviour, documented in tasks/fl26b-handoff.md; the original has no such branch.
 *
 * Caller-validated (the port does not check, like the original): the record index of 0x42ea87 (-1 .. 4 are exercised; the record table pointer needs two
 * bytes of slack below it), the signed-word index `a` of its flag table 0x585801 (`flags_585801[a * 4]`: the host must supply a table that covers every
 * value of a word that its objects can hold), the item of 0x4eb107 (the row `self + item * 0x16d + 0x77e` must exist) and the record number n of 0x4eb184
 * (n >= 0 is tested, `self + n * 0x16d` and the record table must cover it). Resolve width contract: Fl18Host.resolve(a) must return memory that is valid
 * for as many bytes as the function reads from `a`: 1 to 4 bytes for a field, up to 0x7d bytes for a string of 0x4eb184 (0x3d for a translated text).
 * Integration blocker for 0x4eb184: its calls mix host pointers (the local structure, the buffer, a row of `self`) with original addresses (the record
 * text 0x583f5c + n * 0x6e); the host adapter must translate the first kind and know the second.
 *
 * Host contract (as in FL-25): the Fl26bWorld scalars are a snapshot. A host that backs a callee with real original code must flush the
 * world to the original's memory BEFORE each Fl18Host.call and resync it AFTER the call. A callee that changes `self`, a node or a global
 * that the function re-reads is not exercised by the tests of this slice. Nothing here claims original source structure. */

#define FL26B_REJECT_UNRESOLVED 1   /* Fl18Host.resolve returned NULL for an address the original dereferences */
#define FL26B_REJECT_ENDLESS 2      /* the original would never return (unknown kind, cycle) */
#define FL26B_REJECT_OVERRUN 3      /* the original would write past a local buffer (a string that does not fit) */

typedef struct Fl26bWorld {
    uint8_t *records_5bb5e5;   /* records of stride 0x8d (the byte at -2 of record n is its kind); the dword at +0 is the address of the object of the record */
    uint8_t *flags_585801;     /* 0x42ea87: dwords, indexed by a signed word */
    uint32_t value_5bb1ca;     /* 0x42ea87: set to 1 in state 0 */
    int16_t word_5bb50b;       /* 0x42ea87: the key that the list entries are compared with */
    int16_t word_583a29;       /* 0x4eb107: the current item (a signed word), written -1 */
    int16_t word_63a4cd;       /* 0x424201: tested as a signed word on the error path */
    uint8_t *records_583f1f;   /* 0x4eb184: records of stride 0x6e: the byte at +0 is a flag, the string at +0x3d (original address 0x583f5c + n * 0x6e) */
    const uint8_t *bytes_55cba0, *bytes_55cbac, *bytes_55cbb8;   /* 0x4eb184: the nine-byte constants that the strings are compared with */
    const uint8_t *bytes_63aa00, *bytes_63aa04;                   /* 0x4eb184: the one-byte constants */
    uint32_t value_5bb202, value_55cbc4, value_5d03b3, value_585d37;   /* 0x4eb184: the text flag, the dword appended to the text, two dwords of the display call */
} Fl26bWorld;

/* 0x423fbb (thiscall, `ret 4`, ecx unused; `reject` should not be NULL: a rejection returns INT32_MIN, never a valid value): accessor of the leaf behind the dword [node + 0x1c]. When it is 0: dword [node + 0x20] = 0, returns -1.
 * Else dword [node + 0x20] = dword [leaf + 0x40] and returns the signed word [leaf + 0x12] (movsx). */
int32_t m423fbb_leaf_word(uint32_t node, const Fl18Host *host, int32_t *reject);

/* 0x4eb107 (thiscall, `ret 4`): item-use feedback. When the signed word 0x583a29 (the item) equals the dword `arg`: the signed word at
 * self + item * 0x16d + 0x77e is 0 -> word 0x583a29 = -1; 2 -> 0x4e9e84(this = self; args[0] = (item * 0x16d with its low word replaced by the
 * item's), args[1] = 1), then word 0x583a29 = -1; anything else leaves it. Then (in all three cases) calls 0x4d36ed (no `this`). */
void m4eb107_item_use_feedback(uint8_t *self, int32_t arg, Fl26bWorld *world, const Fl18Host *host);

/* 0x42406d (thiscall, `ret 4`, ecx unused): propagates the flag dword [+4] along the chain of the nodes behind [node + 4] (link [+0x38], second
 * link [+0x34] when its word [+0x16] is 1), restarting from the head while a pass set a flag; then counts the nodes with [+4] non-zero and
 * compares the count with [node + 0x18]: dword [node] = 1 and [[node + 0xc] + 4] = 1 (if [node + 0xc] is non-zero) when equal, else 0 and 0. */
void m42406d_propagate(uint32_t node, const Fl18Host *host, int32_t *reject);

/* 0x424201 (thiscall, `ret 4`): walks the nodes from [node + 4]; kind [+0] 2: [+8] = [+4], 0x424346(self, p), then p = [p + 0x38]; kind 1:
 * [+8] = [+4], 0x42356d(self, node, p), 0x424201(self, [p + 0x44]) (recursion, through the host), q = 0x4235fd(self), and when q is non-zero p =
 * [[q + 8] + 0x38], node = [q]; a zero q goes to the error path (0x50ca3e, 0x52139c, 0x44a2b7 if the word 0x63a4cd, 0x4c97b4). When the chain ends
 * (p == 0) 0x42406d(self, node). Rejected explicitly: a node of any other kind (the original loops forever). */
void m424201_walk(uint8_t *self, uint32_t node, const Fl26bWorld *world, const Fl18Host *host, int32_t *reject);

/* 0x42ea87 (cdecl, plain `ret`): record state machine for the record `index` (a signed word, rec = 0x5bb5e5 + index * 0x8d). */
void m42ea87_record_state(int16_t index, Fl26bWorld *world, const Fl18Host *host, int32_t *reject);

/* 0x4eb184 (thiscall, `ret 4`): item-use feedback for the record n (a signed dword, negative returns). Record byte 0x583f1f + n * 0x6e == 0: picks a row
 * j (1..3) of the strings of self + n * 0x16d + 0x74e + j * 0x5d + 0x56 (9-byte compare with 0x55cba0, one byte with 0x63aa00), idx = rand() % j via 0x50cd50.
 * Then 0x4f6334(this = 0x5cf1eb, 0x11) != 0 returns. A text is chosen (record string at 0x583f5c + n * 0x6e, or the row idx of self, which is announced
 * through 0x4fb77a(this = 0x5c3a67) with a local structure) and, when 0x5bb202 is set, translated through 0x423259(this = 0x619a6b) into the local buffer (the original's frame lets a copy run to 0x7c bytes)
 * that is shown with 0x448d11(this = 0x619a05; [0x5d03b3], buffer, -1, 0) after the dword [0x55cbc4] is appended; [self + 0x8256] = 1 and
 * [self + 0x8286] = [0x585d37] + the signed word [self + 0x69d]; finally 0x4fb2e3(this = 0x5c3a67, 0x11). Rejected explicitly: a string that does not fit the
 * local frame of the original: a copy of 0x7c or more characters into the buffer (its NUL would be the live flag's low byte), a structure copy of 0x38 or more characters (saved ebp). A translated text is used only when its length is at most 0x3c (the original's own guard). */
void m4eb184_use_feedback(uint8_t *self, int32_t n, Fl26bWorld *world, const Fl18Host *host, int32_t *reject);

#ifdef __cplusplus
}
#endif

#endif
