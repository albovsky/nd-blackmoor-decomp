#ifndef BLACKMOOR_ORIGINAL_METHODS_FL23B_H
#define BLACKMOOR_ORIGINAL_METHODS_FL23B_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-23 (batch b): the click and state handlers of GAME.EXE (SHA-256 afd337a2...5c45) that 0x43a7ca calls, ported one to one in the
 * style of FL-22 (see original_methods_fl22b.h, whose conventions apply unchanged and whose Fl18Host from original_methods_fl18.h is
 * reused): each is its own symbol that cites the original address in its leading comment, `self` is the original `this` object (ecx) as
 * raw bytes at the original offsets, nothing is bounds-checked, and the effects keep the order of the original.
 *
 * Every handler is a chain of guards on the object, then on the state dword of the record `n` of the table at 0x5bb5e5 (stride 0x8d,
 * the state dword at +0x4d, i.e. 0x5bb632 + 0x8d * n) where n is a signed word of the object, then on the selector 0x5c39e5 (the event
 * that is being dispatched); only then does it store. Calls into original code go through Fl18Host.call (callee address, ecx value,
 * stack arguments with args[0] the LAST one pushed); a stack argument that the original pushes from a 16-bit register is a "word"
 * (only its low 16 bits are meaningful). A pointer into `self` is a host pointer; an address that a record keeps, or the sum of
 * one with an offset, is the 32-bit original address. Fl18Host.resolve turns a record's object address into host memory where the
 * function reads through it. GetTickCount (import 0x52a23c) is Fl18Host.tick. Fl18Host.resolve and Fl18Host.tick are called
 * UNCHECKED; only Fl18Host.call may be NULL (the calls then return 0).
 *
 * Host contract (as in FL-21): the Fl23bWorld scalars are a snapshot. A host that backs a callee with real original code must flush the
 * world to the original's memory BEFORE each Fl18Host.call and resync it AFTER the call. Nothing here claims original source
 * structure. */

typedef struct Fl23bWorld {
    uint8_t *records_5bb5e5;   /* records of stride 0x8d: the dword at +0 is the address of the object of record n, the dword at +0x4d is its state */
    uint32_t value_5c39e5;     /* the selector (the event) that the handler dispatches on */
    uint32_t value_5bb1ca;     /* a flag: non-zero = compare a record field with the constant and maybe announce it through 0x4f6334 / 0x4fb2e3 */
    /* the nine bytes at these addresses of the original are what a field of the record object is compared with (repe cmpsb, ecx = 9) */
    const uint8_t *bytes_54e364, *bytes_550fb8, *bytes_550fc4, *bytes_54a3a8, *bytes_54cb8c, *bytes_551764, *bytes_551770;
} Fl23bWorld;

/* 0x4a1efd: event 0x2760 */
void m4a1efd_click_2760(uint8_t *self, const Fl23bWorld *world);
/* 0x4ba4f2: event 0x276a (reads the tick, calls 0x4fb2e3 with 0x17) */
void m4ba4f2_click_276a(uint8_t *self, const Fl23bWorld *world, const Fl18Host *host);
/* 0x46957d: event 0x272e */
void m46957d_click_272e(uint8_t *self, const Fl23bWorld *world);
/* 0x4b45ed: event 0x2739 */
void m4b45ed_click_2739(uint8_t *self, const Fl23bWorld *world);
/* 0x473ffc: event 0x27a1 (stores the record's object address at +0x76 first, calls 0x4e26fc with this = self + 0x1a6) */
void m473ffc_click_27a1(uint8_t *self, const Fl23bWorld *world, const Fl18Host *host);
/* 0x48e851: events 0x27b9 and 0x27b8 (the second clears the 17-byte string of the item when it is not empty; the original scans for the
 * terminator with repne scasb, which is read here as "the first byte is not zero": the same result, without reading past the object when
 * the string has no terminator) */
void m48e851_click_27b8_27b9(uint8_t *self, const Fl23bWorld *world);
/* 0x45e587: events 0x27ef, 0x27ec and 0x27ed (the last calls 0x45e6bd with this = self) */
void m45e587_click_27ec_27ef(uint8_t *self, const Fl23bWorld *world, const Fl18Host *host);
/* 0x48ab49: events 0x2757 and 0x2756 */
void m48ab49_click_2756_2757(uint8_t *self, const Fl23bWorld *world, const Fl18Host *host);
/* 0x4ab899: events 0x27d0, 0x27ce and 0x27cf */
void m4ab899_click_27ce_27d0(uint8_t *self, const Fl23bWorld *world, const Fl18Host *host);
/* 0x4574e4: events 0x27bd, 0x27be and 0x27bc */
void m4574e4_click_27bc_27be(uint8_t *self, const Fl23bWorld *world, const Fl18Host *host);
/* 0x47a03c: events 0x279d and 0x279c */
void m47a03c_click_279c_279d(uint8_t *self, const Fl23bWorld *world, const Fl18Host *host);
/* 0x4b2a9e: events 0x2793, 0x2792 and every other event */
void m4b2a9e_click_2792_2793(uint8_t *self, const Fl23bWorld *world, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
