#ifndef BLACKMOOR_ORIGINAL_METHODS_FL27A_H
#define BLACKMOOR_ORIGINAL_METHODS_FL27A_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-27 (batch a): sixteen small methods of the action 0x35 (movie) runtime of GAME.EXE (SHA-256 afd337a2...5c45), ported one to one in
 * the style of FL-26 (see original_methods_fl26a.h, whose conventions apply unchanged; Fl18Host from original_methods_fl18.h is reused):
 * each is its own symbol that cites the original address in its leading comment, `self` is the original `this` object (ecx) as raw bytes
 * at the original offsets, and the effects keep the order of the original.
 *
 * Calls into original code and the imports go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST
 * one pushed, i.e. the first argument of the callee). An import is named by its IAT slot address: Sleep 0x52a2b0, _BinkOpen@8 0x52a518,
 * _BinkNextFrame@4 0x52a520, _BinkCopyToBuffer@28 0x52a524, _BinkDoFrame@4 0x52a528, _BinkWait@4 0x52a52c, _BinkGoto@12 0x52a530,
 * _BinkGetSummary@8 0x52a508. A pointer or handle that the original passes on is passed as the 32-bit original value; one that the
 * function reads or writes through (a Bink handle, a string, a slot, the state dword) goes through Fl18Host.resolve (original address ->
 * host memory; writable where the function writes). `self` is a host pointer, so a callee that is given `this` or a pointer into
 * `self` receives the host pointer cast to uintptr_t (an original callee gets the same object).
 *
 * Callees inside this batch are called natively: 0x4de1f5 from 0x4de214, 0x4de214 from 0x4de2d8, 0x44c479 from 0x4c0c7d. Every
 * other callee is a host call (recording stubs in the oracle) and its effect on `self`, the Bink handle, or a global that the function
 * reads again afterwards is the host's to supply (the tests do not exercise a callee that changes them), except where the function
 * itself re-reads such a value and the port re-reads it too (0x44c479, 0x4c2dfb, 0x4159db: stated in the comments).
 *
 * Native rejection (documented apart from the valid-input behaviour; it changes no valid input): 0x44c479 and 0x4c0c7d wait in a loop that
 * another thread ends. Fl27aWorld.native_spin_limit (0 = FL27A_SPIN_LIMIT) bounds the Sleep calls of one wait without the awaited change;
 * when it is reached the port stops and returns FL27A_REJECTED. The original would spin without end.
 * Caller-validated, as in FL-26 (the port does not check, like the original): every address that Fl18Host.resolve is called with must
 * resolve (a NULL result is dereferenced) and the memory behind it must cover the bytes read or written through it (stated per function).
 * Nothing here claims original source structure. */

#define FL27A_SPIN_LIMIT 1000000u
#define FL27A_REJECTED ((int32_t)-1)   /* native rejection; 0x44c479 returns only 1 or 2 and 0x4c0c7d never returns in the original */

typedef struct Fl27aWorld {
    uint32_t value_5b15d6, value_5d17f5;   /* 0x4de2d8: cleared */
    uint32_t value_63a58a;                 /* 0x4159db: set to 4 */
    uint32_t native_spin_limit;            /* native only (not an original global): the bound of the waiting loops, 0 = FL27A_SPIN_LIMIT */
    uint8_t byte_5a161f;                   /* 0x4de1f5: cleared */
} Fl27aWorld;

/* 0x4de1f5: thiscall, plain `ret`: [self + 0x991] = 0 (a dword at an odd offset) and the byte [0x5a161f] = 0. */
void m4de1f5_clear_flags(uint8_t *self, Fl27aWorld *world);

/* 0x4de214: thiscall, plain `ret`: calls 0x4de1f5 (this = self), i.e. m4de1f5_clear_flags. */
void m4de214_clear_flags_thunk(uint8_t *self, Fl27aWorld *world);

/* 0x4de2d8: thiscall, plain `ret`: [self + 0x991] = 1; calls 0x4e053f (ecx 0x570508, argument 1) and 0x4e1113 (ecx 0x570508); [0x5b15d6] = 0;
 * [0x5d17f5] = 0; then 0x4de214 (this = self, native: clears [self + 0x991] and [0x5a161f]). The effects of the two callees (their own
 * writes to the caption objects, the globals 0x5b1602 / 0x5b1606) are the host's: not modelled here (receipt items A-51 #1 and #5). */
void m4de2d8_reset_caption(uint8_t *self, Fl27aWorld *world, const Fl18Host *host);

/* 0x449d90: cdecl, one argument `path` (an original address, only passed on): file = 0x50d0a9(path, 0x548aac); returns 0 when file is zero,
 * otherwise calls 0x50cee4(file) and returns 1. Both callees are host calls (their stack is cleaned by the caller in the original). */
int32_t m449d90_file_exists(uint32_t path, const Fl18Host *host);

/* 0x44c479: cdecl, one argument `state` (the original address of a state dword, odd in the program: 0x637fd3): while it is 1, Sleep(1) (import
 * 0x52a2b0) and read it again; then returns 2 when it is 2, otherwise stores 1 into it and returns 1 (the original sets only ax). Native
 * rejection: FL27A_REJECTED after Fl27aWorld.native_spin_limit (0 = FL27A_SPIN_LIMIT) Sleep calls with the dword still 1. */
int32_t m44c479_wait_state(uint32_t state, const Fl27aWorld *world, const Fl18Host *host);

/* 0x4bee2c: thiscall, `ret 4`, one argument `handle` (an original address): calls 0x4bf38c (this = self); handle zero: [self + 0x2c0] =
 * 0xfffffffd, returns -1; otherwise returns the dword [handle + 0xc] (read through resolve, 0x10 bytes). */
int32_t m4bee2c_get_field(uint8_t *self, uint32_t handle, const Fl18Host *host);

/* 0x4bef85: thiscall, `ret 4`, one argument `handle` (only passed on): calls 0x4bf38c (this = self); handle zero: [self + 0x2c0] =
 * 0xfffffffd, returns 0; otherwise _BinkWait@4 (import 0x52a52c): returns 0 when it answers non-zero, else 1. */
int32_t m4bef85_bink_wait(uint8_t *self, uint32_t handle, const Fl18Host *host);

/* 0x4bee5f: thiscall, `ret 4`, one argument `handle` (only passed on): calls 0x4bf38c (this = self); handle zero: the 124 bytes at self + 8
 * are cleared, [self + 0x2c0] = 0xfffffffd, returns NULL (0); otherwise _BinkGetSummary@8 (import 0x52a508: handle, self + 8; its answer is
 * ignored; it fills the summary at self + 8, which is the host's) and returns self + 8. */
uint8_t *m4bee5f_bink_summary(uint8_t *self, uint32_t handle, const Fl18Host *host);

/* 0x4befc8: thiscall, `ret 4`, one argument `handle` (only passed on): calls 0x4bf38c (this = self); [self + 0xbc] = 0; handle zero:
 * [self + 0x2c0] = 0xfffffffd, returns [self + 0xbc] (0); otherwise [self + 0xbc] = _BinkDoFrame@4 (import 0x52a528) and returns it. */
int32_t m4befc8_bink_do_frame(uint8_t *self, uint32_t handle, const Fl18Host *host);

/* 0x4bef11: thiscall, `ret 8` (handle, mode; only the handle is read through resolve, 12 bytes, and only for mode 1): calls 0x4bf38c
 * (this = self); handle zero: [self + 0x2c0] = 0xfffffffd, returns -3; otherwise [self + 0x2c4] = mode; mode 1: _BinkGoto@12 (import
 * 0x52a530: handle, [handle + 8], 0); any other mode (a dword compare): _BinkGoto@12(handle, 1, 0); returns 0. */
int32_t m4bef11_bink_goto(uint8_t *self, uint32_t handle, uint32_t mode, const Fl18Host *host);

/* 0x4bf098: thiscall, `ret 0x18` (six stack arguments; only the handle is tested, all are passed on): calls 0x4bf38c (this = self);
 * [self + 0xbc] = 0; handle zero: [self + 0x2c0] = 0xfffffffd, returns [self + 0xbc] (0); otherwise [self + 0xbc] = _BinkCopyToBuffer@28
 * (import 0x52a524: handle, dest, pitch, height, x, y, [self + 4]) and returns it. */
int32_t m4bf098_bink_copy_to_buffer(uint8_t *self, uint32_t handle, uint32_t dest, uint32_t pitch, uint32_t height, uint32_t x, uint32_t y,
                                    const Fl18Host *host);

/* 0x4bf10f: thiscall, `ret 4`, one argument `handle` (read through resolve, 0x10 bytes): calls 0x4bf38c (this = self); handle zero:
 * [self + 0x2c0] = 0xfffffffd, returns 0; [self + 0x2c4] not 1 (dword compare): returns 0 when [handle + 0xc] == [handle + 8], else
 * _BinkNextFrame@4 (import 0x52a520: handle) and returns 1; [self + 0x2c4] == 1: returns 0 when [handle + 0xc] == 1, else _BinkGoto@12
 * (import 0x52a530: handle, [handle + 0xc] - 1, 0) and returns 1. */
int32_t m4bf10f_bink_next(uint8_t *self, uint32_t handle, const Fl18Host *host);

/* 0x4bf315: thiscall, `ret 8` (name, flags): calls 0x4bf38c and 0x4bede7 (this = self); an empty zero-terminated name (read through resolve,
 * the first byte; see the .c comment): [self + 0x2c0] = 0xfffffffb, returns 0; otherwise _BinkOpen@8 (import 0x52a518: name, flags): zero
 * result: [self + 0x2c0] = 0xfffffffa, returns 0; else returns the result. */
uint32_t m4bf315_bink_open(uint8_t *self, uint32_t name, uint32_t flags, const Fl18Host *host);

/* 0x4c2dfb: thiscall, `ret 4`, one argument `slot` (the original address of a dword that holds a pointer p, read and written through
 * resolve): p zero: nothing; otherwise bit 0 of the dword [p + 0x55] clear: 0x4c2e5b (this = self, p); set: [p] = 0 (dword); then the
 * slot is read again (the callee may have changed it), 0x51dc6c (cdecl) gets that value and the slot is cleared. */
void m4c2dfb_free_pair(uint8_t *self, uint32_t slot, const Fl18Host *host);

/* 0x4159db: thiscall, `ret 8` (a, word; `a` read through resolve, 0x21 bytes): the byte [a + 0x20] == 2 (a byte compare): calls 0x415db9
 * (this = self; a, word) and ends. Otherwise calls 0x415011 (this = self; a); 0x50ca3e (cdecl: 0x63888b, 0x541dd8, the byte [a + 0x20]
 * read again after the callee, a + 0x151); 0x52139c (stdcall: 0x63888b, 0, 0); [0x63a58a] = 4; 0x4c97b4 (ecx 0x5cf659). The word is the low
 * 16 bits of the second stack argument. */
void m4159db_dispatch_piece(uint8_t *self, uint32_t a, uint16_t word, Fl27aWorld *world, const Fl18Host *host);

/* 0x4c0c7d: thread procedure, one argument `param` (the original address of a dword stop flag). Loop: [param] != 0 (dword): calls 0x51ec84
 * (AfxEndThread, 0, 1) and ends (returns 0; the original thread never returns). Otherwise, when the signed word [0x637fd7 + 0x1cc] is 0:
 * 0x44c479(0x637fd3) (native) and, if its ax is not 2, the dword [0x637fd7 + 0x172] 0 -> 0x41546f, 1 -> 0x4156ea (ecx 0x5e2dbe, argument
 * 0x637fd7), then 0x44c4ab(0x637fd3) and the word [0x637fd7 + 0x1cc] = 1. Each pass ends with Sleep(1). Native rejection: FL27A_REJECTED
 * after native_spin_limit passes (0 = FL27A_SPIN_LIMIT) or when 0x44c479 is rejected. */
int32_t m4c0c7d_movie_thread(uint32_t param, Fl27aWorld *world, const Fl18Host *host);

/*DECLS*/

#ifdef __cplusplus
}
#endif

#endif
