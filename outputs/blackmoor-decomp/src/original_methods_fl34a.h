#ifndef BLACKMOOR_ORIGINAL_METHODS_FL34A_H
#define BLACKMOOR_ORIGINAL_METHODS_FL34A_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-34 (batch a): 21 table-toggle handlers of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-32 batch a (see original_methods_fl32a.h, whose conventions apply
 * unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original address in its leading comment, `self` is the original object (ecx) as raw bytes
 * at the original offsets, nothing is bounds checked, and the effects keep the order of the original. The names are descriptive hints, not recovered source names.
 *
 * All 21 have the same body (read from each one's own disassembly, base by base): `push ebp; mov ebp,esp; push ecx; mov [ebp-4],ecx; ecx = [self+0x5c]; cmp dword [ecx*4 + base], 1; jne else;
 * [self+0x5c]*4 + base := 0; jmp done; else: [self+0x5c]*4 + base := 1; done: ecx = self; call 0x40236a; mov esp,ebp; pop ebp; ret` (20 instructions); only the base differs.
 * The index is read from `self` again for each store, as in the original. Calls into original code go through Fl18Host.call (callee address, ecx value, stack arguments). A callee that changes
 * `self` or the table is not exercised (tasks/fl34a-handoff.md). Nothing here claims original source structure. */

typedef struct Fl34aWorld {
    /* The host memory of the original address 0x5e60da (a dword array). The bases of the 21 toggles run from 0x5e60d6 (element -1 of this array; the caller leaves slack below) to 0x5e6132
     * (element 22); the tables of FL-32a at 0x5e60da / 0x5e60de / 0x5e60e2 are the elements 0 to 2 of the same array. */
    uint8_t *table_5e60da;
} Fl34aWorld;

/* 0x402962, thiscall, plain `ret`: i = dword [self+0x5c]; when dword [0x5e60d6 + i*4] == 1 (a dword compare) it is set to 0, otherwise to 1; then 0x40236a(this self). Table base 0x5e60d6 = 0x5e60da - 4 bytes. */
void m402962_toggle_5e60d6(uint8_t *self, Fl34aWorld *world, const Fl18Host *host);

/* 0x402a7e, thiscall, plain `ret`: i = dword [self+0x5c]; when dword [0x5e60e6 + i*4] == 1 (a dword compare) it is set to 0, otherwise to 1; then 0x40236a(this self). Table base 0x5e60e6 = 0x5e60da + 12 bytes. */
void m402a7e_toggle_5e60e6(uint8_t *self, Fl34aWorld *world, const Fl18Host *host);

/* 0x402ac5, thiscall, plain `ret`: i = dword [self+0x5c]; when dword [0x5e60ea + i*4] == 1 (a dword compare) it is set to 0, otherwise to 1; then 0x40236a(this self). Table base 0x5e60ea = 0x5e60da + 16 bytes. */
void m402ac5_toggle_5e60ea(uint8_t *self, Fl34aWorld *world, const Fl18Host *host);

/* 0x402b0c, thiscall, plain `ret`: i = dword [self+0x5c]; when dword [0x5e60ee + i*4] == 1 (a dword compare) it is set to 0, otherwise to 1; then 0x40236a(this self). Table base 0x5e60ee = 0x5e60da + 20 bytes. */
void m402b0c_toggle_5e60ee(uint8_t *self, Fl34aWorld *world, const Fl18Host *host);

/* 0x402b53, thiscall, plain `ret`: i = dword [self+0x5c]; when dword [0x5e60f2 + i*4] == 1 (a dword compare) it is set to 0, otherwise to 1; then 0x40236a(this self). Table base 0x5e60f2 = 0x5e60da + 24 bytes. */
void m402b53_toggle_5e60f2(uint8_t *self, Fl34aWorld *world, const Fl18Host *host);

/* 0x402b9a, thiscall, plain `ret`: i = dword [self+0x5c]; when dword [0x5e60f6 + i*4] == 1 (a dword compare) it is set to 0, otherwise to 1; then 0x40236a(this self). Table base 0x5e60f6 = 0x5e60da + 28 bytes. */
void m402b9a_toggle_5e60f6(uint8_t *self, Fl34aWorld *world, const Fl18Host *host);

/* 0x402be1, thiscall, plain `ret`: i = dword [self+0x5c]; when dword [0x5e60fa + i*4] == 1 (a dword compare) it is set to 0, otherwise to 1; then 0x40236a(this self). Table base 0x5e60fa = 0x5e60da + 32 bytes. */
void m402be1_toggle_5e60fa(uint8_t *self, Fl34aWorld *world, const Fl18Host *host);

/* 0x402c28, thiscall, plain `ret`: i = dword [self+0x5c]; when dword [0x5e60fe + i*4] == 1 (a dword compare) it is set to 0, otherwise to 1; then 0x40236a(this self). Table base 0x5e60fe = 0x5e60da + 36 bytes. */
void m402c28_toggle_5e60fe(uint8_t *self, Fl34aWorld *world, const Fl18Host *host);

/* 0x402c6f, thiscall, plain `ret`: i = dword [self+0x5c]; when dword [0x5e6102 + i*4] == 1 (a dword compare) it is set to 0, otherwise to 1; then 0x40236a(this self). Table base 0x5e6102 = 0x5e60da + 40 bytes. */
void m402c6f_toggle_5e6102(uint8_t *self, Fl34aWorld *world, const Fl18Host *host);

/* 0x402cb6, thiscall, plain `ret`: i = dword [self+0x5c]; when dword [0x5e6106 + i*4] == 1 (a dword compare) it is set to 0, otherwise to 1; then 0x40236a(this self). Table base 0x5e6106 = 0x5e60da + 44 bytes. */
void m402cb6_toggle_5e6106(uint8_t *self, Fl34aWorld *world, const Fl18Host *host);

/* 0x402cfd, thiscall, plain `ret`: i = dword [self+0x5c]; when dword [0x5e610a + i*4] == 1 (a dword compare) it is set to 0, otherwise to 1; then 0x40236a(this self). Table base 0x5e610a = 0x5e60da + 48 bytes. */
void m402cfd_toggle_5e610a(uint8_t *self, Fl34aWorld *world, const Fl18Host *host);

/* 0x402d44, thiscall, plain `ret`: i = dword [self+0x5c]; when dword [0x5e610e + i*4] == 1 (a dword compare) it is set to 0, otherwise to 1; then 0x40236a(this self). Table base 0x5e610e = 0x5e60da + 52 bytes. */
void m402d44_toggle_5e610e(uint8_t *self, Fl34aWorld *world, const Fl18Host *host);

/* 0x402d8b, thiscall, plain `ret`: i = dword [self+0x5c]; when dword [0x5e6112 + i*4] == 1 (a dword compare) it is set to 0, otherwise to 1; then 0x40236a(this self). Table base 0x5e6112 = 0x5e60da + 56 bytes. */
void m402d8b_toggle_5e6112(uint8_t *self, Fl34aWorld *world, const Fl18Host *host);

/* 0x402dd2, thiscall, plain `ret`: i = dword [self+0x5c]; when dword [0x5e6116 + i*4] == 1 (a dword compare) it is set to 0, otherwise to 1; then 0x40236a(this self). Table base 0x5e6116 = 0x5e60da + 60 bytes. */
void m402dd2_toggle_5e6116(uint8_t *self, Fl34aWorld *world, const Fl18Host *host);

/* 0x402e19, thiscall, plain `ret`: i = dword [self+0x5c]; when dword [0x5e611a + i*4] == 1 (a dword compare) it is set to 0, otherwise to 1; then 0x40236a(this self). Table base 0x5e611a = 0x5e60da + 64 bytes. */
void m402e19_toggle_5e611a(uint8_t *self, Fl34aWorld *world, const Fl18Host *host);

/* 0x402e60, thiscall, plain `ret`: i = dword [self+0x5c]; when dword [0x5e611e + i*4] == 1 (a dword compare) it is set to 0, otherwise to 1; then 0x40236a(this self). Table base 0x5e611e = 0x5e60da + 68 bytes. */
void m402e60_toggle_5e611e(uint8_t *self, Fl34aWorld *world, const Fl18Host *host);

/* 0x402ea7, thiscall, plain `ret`: i = dword [self+0x5c]; when dword [0x5e6122 + i*4] == 1 (a dword compare) it is set to 0, otherwise to 1; then 0x40236a(this self). Table base 0x5e6122 = 0x5e60da + 72 bytes. */
void m402ea7_toggle_5e6122(uint8_t *self, Fl34aWorld *world, const Fl18Host *host);

/* 0x402eee, thiscall, plain `ret`: i = dword [self+0x5c]; when dword [0x5e6126 + i*4] == 1 (a dword compare) it is set to 0, otherwise to 1; then 0x40236a(this self). Table base 0x5e6126 = 0x5e60da + 76 bytes. */
void m402eee_toggle_5e6126(uint8_t *self, Fl34aWorld *world, const Fl18Host *host);

/* 0x402f35, thiscall, plain `ret`: i = dword [self+0x5c]; when dword [0x5e612a + i*4] == 1 (a dword compare) it is set to 0, otherwise to 1; then 0x40236a(this self). Table base 0x5e612a = 0x5e60da + 80 bytes. */
void m402f35_toggle_5e612a(uint8_t *self, Fl34aWorld *world, const Fl18Host *host);

/* 0x402f7c, thiscall, plain `ret`: i = dword [self+0x5c]; when dword [0x5e612e + i*4] == 1 (a dword compare) it is set to 0, otherwise to 1; then 0x40236a(this self). Table base 0x5e612e = 0x5e60da + 84 bytes. */
void m402f7c_toggle_5e612e(uint8_t *self, Fl34aWorld *world, const Fl18Host *host);

/* 0x402fc3, thiscall, plain `ret`: i = dword [self+0x5c]; when dword [0x5e6132 + i*4] == 1 (a dword compare) it is set to 0, otherwise to 1; then 0x40236a(this self). Table base 0x5e6132 = 0x5e60da + 88 bytes. */
void m402fc3_toggle_5e6132(uint8_t *self, Fl34aWorld *world, const Fl18Host *host);

/* FNS-END */

#ifdef __cplusplus
}
#endif

#endif
