#ifndef BLACKMOOR_ORIGINAL_METHODS_FL39D_H
#define BLACKMOOR_ORIGINAL_METHODS_FL39D_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-39 (batch d): 139 functions of GAME.EXE (SHA-256 afd337a2...5c45) at or above 0x480000 ported one to one, in the style of FL-36 (see original_methods_fl36f.h, whose conventions
 * apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original address in its leading comment, `self` is the
 * original object (ecx) as raw bytes at the original offsets, nothing is bounds checked, and the effects keep the order of the original. The names are descriptive hints, not
 * recovered source names. The constants of every row (field offsets, callees, stored values, sizes) were read from that row's own disassembly by the generator, which also
 * asserted that every row of a kind has the identical masked instruction stream. A dword of `self` that holds an address of the original goes through Fl18Host.resolve;
 * a callee that changes `self` or a global that the function reads again afterwards is not exercised. */

typedef struct Fl39dWorld {
    uint32_t value_5b44f0; /* the dword at the original address 0x5b44f0 */
    uint32_t value_5b44f4; /* the dword at the original address 0x5b44f4 */
    uint32_t value_5c39e5; /* the dword at the original address 0x5c39e5 */
    uint32_t value_5d0377; /* the dword at the original address 0x5d0377 */
    uint32_t value_5d162d; /* the dword at the original address 0x5d162d */
    uint32_t value_5d1631; /* the dword at the original address 0x5d1631 */
    uint32_t value_5d1639; /* the dword at the original address 0x5d1639 */
    uint32_t value_583186; /* the dword at the original address 0x583186 */
    uint32_t value_58318a; /* the dword at the original address 0x58318a */
    uint32_t value_583102; /* the dword at the original address 0x583102 */
    uint32_t value_583106; /* the dword at the original address 0x583106 */
    uint32_t value_58310a; /* the dword at the original address 0x58310a */
    uint32_t value_58310e; /* the dword at the original address 0x58310e */
    uint8_t byte_58322d; /* the byte at the original address 0x58322d */
    uint8_t *table_594d82; /* bytes of the table at the original address 0x594d82, indexed by a computed offset (the caller leaves slack on both sides) */
    uint16_t word_594d80; /* the word at the original address 0x594d80 */
    uint16_t word_58c94f; /* the word at the original address 0x58c94f */
    uint8_t *table_5bb5e5; /* bytes of the table at the original address 0x5bb5e5, indexed by a computed offset (the caller leaves slack on both sides) */
    uint32_t value_5cf665; /* the dword at the original address 0x5cf665 */
    uint32_t value_5d15e3; /* the dword at the original address 0x5d15e3 */
    uint32_t value_61d3d1; /* the dword at the original address 0x61d3d1 */
    uint32_t value_61d3e5; /* the dword at the original address 0x61d3e5 */
    uint32_t value_61d3ed; /* the dword at the original address 0x61d3ed */
    uint16_t word_61d3bf; /* the word at the original address 0x61d3bf */
    uint32_t value_583196; /* the dword at the original address 0x583196 */
    uint32_t value_58319a; /* the dword at the original address 0x58319a */
    uint32_t value_58319e; /* the dword at the original address 0x58319e */
    uint32_t value_5831a2; /* the dword at the original address 0x5831a2 */
    uint16_t word_5957c5; /* the word at the original address 0x5957c5 */
    uint16_t word_5957c7; /* the word at the original address 0x5957c7 */
    uint16_t word_5957c9; /* the word at the original address 0x5957c9 */
    uint32_t value_5d19fb; /* the dword at the original address 0x5d19fb */
    uint16_t word_639895; /* the word at the original address 0x639895 */
    uint32_t value_63a8dc; /* the dword at the original address 0x63a8dc */
    uint16_t word_63a8d8; /* the word at the original address 0x63a8d8 */
    uint16_t word_63a4cd; /* the word at the original address 0x63a4cd */
    uint32_t value_5bb57b; /* the dword at the original address 0x5bb57b */
    uint16_t word_5c39e3; /* the word at the original address 0x5c39e3 */
    uint16_t word_5bb1c4; /* the word at the original address 0x5bb1c4 */
    uint32_t value_5d1c4b; /* the dword at the original address 0x5d1c4b */
    uint8_t byte_61c6ae; /* the byte at the original address 0x61c6ae */
    uint32_t value_583981; /* the dword at the original address 0x583981 */
    uint32_t value_583985; /* the dword at the original address 0x583985 */
    uint32_t value_5839a1; /* the dword at the original address 0x5839a1 */
    uint32_t value_5839a5; /* the dword at the original address 0x5839a5 */
    uint16_t word_5b451f; /* the word at the original address 0x5b451f */
    uint8_t byte_58320d; /* the byte at the original address 0x58320d */
    uint32_t value_5d17f5; /* the dword at the original address 0x5d17f5 */
    uint16_t word_63a998; /* the word at the original address 0x63a998 */
    uint32_t value_5bb1e2; /* the dword at the original address 0x5bb1e2 */
    uint32_t value_5d2ecb; /* the dword at the original address 0x5d2ecb */
    uint32_t value_5d1683; /* the dword at the original address 0x5d1683 */
    uint32_t value_5d16cd; /* the dword at the original address 0x5d16cd */
    uint32_t value_5d2d4d; /* the dword at the original address 0x5d2d4d */
    uint32_t value_5d2e75; /* the dword at the original address 0x5d2e75 */
    uint16_t word_616872; /* the word at the original address 0x616872 */
    uint32_t value_5d03b7; /* the dword at the original address 0x5d03b7 */
    uint32_t value_5d02ab; /* the dword at the original address 0x5d02ab */
    uint32_t value_5835da; /* the dword at the original address 0x5835da */
    uint32_t value_5bb202; /* the dword at the original address 0x5bb202 */
    uint32_t value_5bb206; /* the dword at the original address 0x5bb206 */
    uint32_t value_5d2819; /* the dword at the original address 0x5d2819 */
    uint32_t value_5d298b; /* the dword at the original address 0x5d298b */
    uint16_t word_5835d8; /* the word at the original address 0x5835d8 */
    uint32_t value_5a1e58; /* the dword at the original address 0x5a1e58 */
    uint32_t value_5bb5a7; /* the dword at the original address 0x5bb5a7 */
    uint32_t value_5bb5ab; /* the dword at the original address 0x5bb5ab */
    uint32_t value_5bb5af; /* the dword at the original address 0x5bb5af */
    uint16_t word_5bb50b; /* the word at the original address 0x5bb50b */
    uint16_t word_5bb57b; /* the word at the original address 0x5bb57b */
    uint16_t word_5bb57f; /* the word at the original address 0x5bb57f */
    uint16_t word_5bb593; /* the word at the original address 0x5bb593 */
    uint32_t value_5d1717; /* the dword at the original address 0x5d1717 */
    uint32_t value_585d37; /* the dword at the original address 0x585d37 */
    uint32_t value_5b1602; /* the dword at the original address 0x5b1602 */
    uint8_t byte_583232; /* the byte at the original address 0x583232 */
    uint32_t value_583999; /* the dword at the original address 0x583999 */
    uint32_t value_5bb1ca; /* the dword at the original address 0x5bb1ca */
    uint32_t value_5bb57f; /* the dword at the original address 0x5bb57f */
    uint32_t value_5bb59b; /* the dword at the original address 0x5bb59b */
    uint32_t value_5bb59f; /* the dword at the original address 0x5bb59f */
    uint32_t value_5bb5a3; /* the dword at the original address 0x5bb5a3 */
    uint32_t value_5c3a25; /* the dword at the original address 0x5c3a25 */
    uint32_t value_5c3a29; /* the dword at the original address 0x5c3a29 */
    uint32_t value_5c3a2d; /* the dword at the original address 0x5c3a2d */
    uint16_t word_583f1d; /* the word at the original address 0x583f1d */
    uint16_t word_5bb595; /* the word at the original address 0x5bb595 */
    uint16_t word_5bb599; /* the word at the original address 0x5bb599 */
    uint16_t word_5c39ff; /* the word at the original address 0x5c39ff */
    uint16_t word_5c3a1b; /* the word at the original address 0x5c3a1b */
    uint16_t word_5c3a1d; /* the word at the original address 0x5c3a1d */
    uint16_t word_5c3a1f; /* the word at the original address 0x5c3a1f */
    uint16_t word_5c3a21; /* the word at the original address 0x5c3a21 */
    uint16_t word_5c3a23; /* the word at the original address 0x5c3a23 */
    uint32_t value_55cd94; /* the dword at the original address 0x55cd94 */
    uint32_t value_63aa10; /* the dword at the original address 0x63aa10 */
    uint8_t *table_583381; /* bytes of the table at the original address 0x583381, indexed by a computed offset (the caller leaves slack on both sides) */
    uint16_t word_5b00d9; /* the word at the original address 0x5b00d9 */
} Fl39dWorld;

/* 0x48217a, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x1c]/2, [self+0x1e]/2, [self+0x20]/4, [self+0xa8]/1. Returns this. */
uint8_t * m48217a_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4821ab, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x20]/4, [self+0x24]/4, [self+0x1c]/2. Calls (in code order): 0x48217a(this, 0 args), 0x4c2dfb(this, 1 arg), 0x4d3992(1 arg). Returns eax. */
uint32_t m4821ab_lifted(uint8_t *self, const Fl18Host *host);

/* 0x487dcf, this = ecx (self), `ret 0x8`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword, a1 dword. Reads [self+0x65]/1. Stores to [self+0x24]/1, [self+0x66]/2. Globals: 0x5b44f0/4 (written), 0x5b44f4/4 (written), 0x5c39e5/4 (written), 0x5d0377/4, 0x5d162d/4 (written), 0x5d1631/4 (written), 0x5d1639/4 (written). eax is left-over and not meaningful. */
uint32_t m487dcf_lifted(uint8_t *self, uint32_t a0, uint32_t a1, const Fl18Host *host, Fl39dWorld *world);

/* 0x488e54, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x2c]/4, [self+0xcc]/4. eax is left-over and not meaningful. */
uint32_t m488e54_lifted(uint8_t *self, const Fl18Host *host);

/* 0x48a70a, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x1c]/2, [self+0x1e]/2, [self+0x20]/4, [self+0x24]/1, [self+0x2e]/2, [self+0x42]/2, [self+0x44]/4, [self+0x4e]/4. ... Returns eax. */
uint32_t m48a70a_lifted(uint8_t *self, const Fl18Host *host);

/* 0x48aa66, this = ecx (self), `ret 0x8`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword, a1 dword. Stores to [self+0x1b0]/2. Globals: 0x5b44f0/4 (written), 0x5b44f4/4 (written), 0x5c39e5/4 (written), 0x5d0377/4, 0x5d162d/4 (written), 0x5d1631/4 (written), 0x5d1639/4 (written). Returns eax. */
uint32_t m48aa66_lifted(uint8_t *self, uint32_t a0, uint32_t a1, const Fl18Host *host, Fl39dWorld *world);

/* 0x48e28a, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x1c]/2, [self+0x1e]/2, [self+0x3fe]/2, [self+0x451]/1, [self+0x45a]/1, [self+0x45b]/1, [self+0x45c]/1, [self+0x45d]/4. ... Returns this. */
uint8_t * m48e28a_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4911ca, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x1f3f]/4. Stores to [self+0x1f47]/4, [self+0x1f4b]/4, [self+0x1f4f]/4, [self+0x1f53]/4, [self+0x1f57]/4, [self+0x1f5b]/4, [self+0x1f5f]/4, [self+0x1f63]/4. ... Calls (in code order): 0x4c97b4(this, 0 args), 0x51dc43(1 arg), 0x52139c(3 args). Returns eax. */
uint32_t m4911ca_lifted(uint8_t *self, const Fl18Host *host);

/* 0x491422, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x1f47]/4, [self+0x1f4b]/4, [self+0x1f4f]/4, [self+0x1f53]/4, [self+0x1f57]/4, [self+0x1f5b]/4, [self+0x1f5f]/4, [self+0x1f63]/4. ... Stores to [self+0x1f47]/4, [self+0x1f4b]/4, [self+0x1f4f]/4, [self+0x1f53]/4, [self+0x1f57]/4, [self+0x1f5b]/4, [self+0x1f5f]/4, [self+0x1f63]/4. ... Calls (in code order): 0x51dc6c(1 arg). eax is left-over and not meaningful. */
uint32_t m491422_lifted(uint8_t *self, const Fl18Host *host);

/* 0x491885, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x50f3]/4, [self+0x50f7]/4. Stores to [self+0x50f3]/4, [self+0x50f7]/4, [self+0x50fc]/1, [self+0x50fd]/1. Calls (in code order): 0x49192b(this, 0 args), 0x4c97b4(this, 0 args), 0x51dc43(1 arg), 0x51dc6c(1 arg), 0x52139c(3 args). Returns eax. */
uint32_t m491885_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4921a1, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x4791]/4, [self+0x4775]/4, [self+0x4771]/4, [self+0x477d]/4, [self+0x4779]/4, [self+0x4785]/4, [self+0x4781]/4, [self+0x4799]/4. ... Stores to [self+0x4771]/4, [self+0x4775]/4, [self+0x4779]/4, [self+0x477d]/4, [self+0x4781]/4, [self+0x4785]/4, [self+0x4789]/4, [self+0x478d]/4. ... Globals: 0x583186/4, 0x58318a/4. Returns this. */
uint8_t * m4921a1_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x493a54, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x1f77]/4, [self+0x479d]/4, [self+0x47a5]/4, [self+0x4799]/4, [self+0x47a1]/4. Stores to [self+0x200b]/4. Globals: 0x583102/4, 0x583106/4, 0x58310a/4, 0x58310e/4. Returns eax. */
uint32_t m493a54_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x493af0, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x2003]/4, [self+0x2007]/4, [self+0x200b]/4. Calls (in code order): 0x4dae66(this, 0 args), 0x4dae77(this, 0 args). Returns eax. */
uint32_t m493af0_lifted(uint8_t *self, const Fl18Host *host);

/* 0x493b2e, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x1f77]/4. Stores to [self+0x2003]/4, [self+0x2007]/4, [self+0x200b]/4. Calls (in code order): 0x4dae66(this, 0 args), 0x4dae77(this, 0 args). eax is left-over and not meaningful. */
uint32_t m493b2e_lifted(uint8_t *self, const Fl18Host *host);

/* 0x493c34, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x1ef7]/4, [self+0x47d1]/4, [self+0x1efb]/4. Stores to [self+0x1eff]/4, [self+0x1f03]/4, [self+0x1f07]/4, [self+0x1f0b]/4. Returns eax. */
uint32_t m493c34_lifted(uint8_t *self, const Fl18Host *host);

/* 0x495a5b, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x4791]/4, [self+0x4795]/4. Stores to [self+0x4791]/4, [self+0x4795]/4. Globals: 0x58322d/1 (written). Calls (in code order): 0x49192b(this, 0 args), 0x4921a1(this, 0 args), 0x4922f4(this, 0 args), 0x4d36ed(0 args). Returns eax. */
uint32_t m495a5b_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x49c46c, ecx unused, plain `ret`, lifted mechanically from the instruction stream; not original source structure. Calls (in code order): 0x494ccc(this, 0 args), 0x4c952f(this, 1 arg). Returns eax. */
uint32_t m49c46c_lifted(const Fl18Host *host);

/* 0x49c68a, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0xde0]/4, [self+0xde4]/4, [self+0xdec]/4, [self+0xe30]/4, [self+0xe34]/4, [self+0xe38]/4, [self+0xe3c]/4, [self+0xe40]/4. ... Stores to [self+0xde0]/4, [self+0xde4]/4, [self+0xdec]/4, [self+0xe30]/4, [self+0xe34]/4, [self+0xe38]/4, [self+0xe3c]/4, [self+0xe40]/4. ... Calls (in code order): 0x49c5f0(this, 0 args), 0x51dc6c(1 arg). Returns eax. */
uint32_t m49c68a_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4a1d14, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x594d80/2 (written). Returns eax. */
uint32_t m4a1d14_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4a1e93, this = ecx (self), `ret 0x4`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword. Globals: 0x5b44f0/4 (written), 0x5b44f4/4 (written), 0x5c39e5/4 (written), 0x5d0377/4, 0x5d162d/4 (written), 0x5d1631/4 (written), 0x5d1639/4 (written). Returns eax. */
uint32_t m4a1e93_lifted(uint8_t *self, uint32_t a0, const Fl18Host *host, Fl39dWorld *world);

/* 0x4a1fd1, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x20]/4, [r1+0x14f]/2, [r1+0x151]/2, [r1+0x14d]/2. Stores to [self+0x4c]/4, [self+0x58]/1. Globals: 0x58c94f/2. Returns this. */
uint8_t * m4a1fd1_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4a378a, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x1c]/2, [self+0x1e]/2, [self+0x200]/4, [self+0x210]/2, [self+0x212]/2, [self+0x214]/2, [self+0x216]/2, [self+0x258]/4. ... eax is left-over and not meaningful. */
uint32_t m4a378a_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4a39c4, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x210]/2, [self+0x212]/2, [self+0x214]/2, [self+0x216]/2, [self+0x258]/4, [self+0x25c]/4, [self+0x260]/4, [self+0x272]/4. Returns this. */
uint8_t * m4a39c4_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4a3beb, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x288]/4, [self+0x280]/4, [self+0x28c]/4, [self+0x284]/4, [self+0x272]/4, [self+0x22c]/4, [self+0x234]/4, [self+0x228]/4. ... Stores to [self+0x218]/4, [self+0x21c]/4, [self+0x220]/4, [self+0x224]/4, [self+0x228]/4, [self+0x22c]/4, [self+0x230]/4, [self+0x234]/4. ... Globals: 0x583186/4, 0x58318a/4. Calls (in code order): 0x4a3aec(this, 0 args). Returns this. */
uint8_t * m4a3beb_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4a63dc, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x34]/4, [self+0x38]/4, [self+0x3c]/4, [self+0x1c]/2. Stores to [self+0x34]/4, [self+0x38]/4, [self+0x3c]/4. Calls (in code order): 0x4a638a(this, 0 args), 0x4c2dfb(this, 1 arg), 0x4d3992(1 arg). Returns eax. */
uint32_t m4a63dc_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4a7994, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x5cf665/4, 0x5d15e3/4, 0x61d3d1/4, 0x61d3e5/4, 0x61d3ed/4, 0x61d3bf/2. Calls (in code order): 0x4c5377(this, 5 args). Returns eax. */
uint32_t m4a7994_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4a7c7a, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x1c]/2, [self+0x1e]/2, [self+0xe10]/2, [self+0xe56]/4, [self+0xe5a]/4, [self+0xe5e]/4, [self+0xe62]/4, [self+0xe72]/4. ... Returns this. */
uint8_t * m4a7c7a_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4a7d1d, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0xe6a]/4, [self+0xe6e]/4, [self+0x1c]/2. Stores to [self+0xe6a]/4, [self+0xe6e]/4. Calls (in code order): 0x4a7c7a(this, 0 args), 0x4c2dfb(this, 1 arg), 0x4d3992(1 arg). Returns eax. */
uint32_t m4a7d1d_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4a7df9, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0xe0c]/2, [self+0xe0e]/2, [self+0xe56]/4, [self+0xe5a]/4, [self+0xe5e]/4, [self+0xe76]/4. Returns this. */
uint8_t * m4a7df9_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4a8007, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0xe8c]/4, [self+0xe84]/4, [self+0xe90]/4, [self+0xe88]/4, [self+0xe76]/4, [self+0xe2a]/4, [self+0xe32]/4, [self+0xe26]/4. ... Stores to [self+0xe16]/4, [self+0xe1a]/4, [self+0xe1e]/4, [self+0xe22]/4, [self+0xe26]/4, [self+0xe2a]/4, [self+0xe2e]/4, [self+0xe32]/4. ... Globals: 0x583186/4, 0x58318a/4. Calls (in code order): 0x4a7f08(this, 0 args). Returns this. */
uint8_t * m4a8007_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4a9f63, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x1d]/4, [self+0x29]/2. Calls (in code order): 0x4a9f27(this, 0 args), 0x4c2dfb(this, 1 arg), 0x4d3992(1 arg). Returns eax. */
uint32_t m4a9f63_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4ab706, this = ecx (self), `ret 0x8`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword, a1 dword. Stores to [self+0x32]/2. Globals: 0x5b44f0/4 (written), 0x5b44f4/4 (written), 0x5c39e5/4 (written), 0x5d0377/4, 0x5d162d/4 (written), 0x5d1631/4 (written), 0x5d1639/4 (written). eax is left-over and not meaningful. */
uint32_t m4ab706_lifted(uint8_t *self, uint32_t a0, uint32_t a1, const Fl18Host *host, Fl39dWorld *world);

/* 0x4accab, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x24]/2. Globals: 0x583196/4, 0x58319a/4, 0x58319e/4, 0x5831a2/4. eax is left-over and not meaningful. */
uint32_t m4accab_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4ad1e5, this = ecx (self), `ret 0x4`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword. Globals: 0x5b44f0/4 (written), 0x5b44f4/4 (written), 0x5c39e5/4 (written), 0x5d0377/4, 0x5d162d/4 (written), 0x5d1631/4 (written), 0x5d1639/4 (written). Returns eax. */
uint32_t m4ad1e5_lifted(uint8_t *self, uint32_t a0, const Fl18Host *host, Fl39dWorld *world);

/* 0x4b3c5a, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x71c]/2, [self+0x71e]/2, [self+0x720]/2, [self+0x722]/2, [self+0x724]/2, [self+0x726]/2, [self+0x728]/2, [self+0x72a]/2. ... Returns this. */
uint8_t * m4b3c5a_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4b3f98, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x750]/2, [self+0x75e]/4, [self+0x762]/4, [self+0x752]/2, [self+0x6e0]/4, [self+0x6e8]/4, [self+0x6dc]/4, [self+0x6e4]/4. ... Stores to [self+0x6dc]/4, [self+0x6e0]/4, [self+0x6e4]/4, [self+0x6e8]/4, [self+0x6ec]/4, [self+0x6f0]/4, [self+0x6f4]/4, [self+0x6f8]/4. ... Globals: 0x583186/4, 0x58318a/4. Calls (in code order): 0x4b3e99(this, 0 args). eax is left-over and not meaningful. */
uint32_t m4b3f98_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4b450f, this = ecx (self), `ret 0x4`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword. Stores to [self+0x758]/2. Globals: 0x5b44f0/4 (written), 0x5b44f4/4 (written), 0x5c39e5/4 (written), 0x5d0377/4, 0x5d162d/4 (written), 0x5d1631/4 (written), 0x5d1639/4 (written). Returns this. */
uint8_t * m4b450f_lifted(uint8_t *self, uint32_t a0, const Fl18Host *host, Fl39dWorld *world);

/* 0x4b72a9, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x5957c5/2 (written), 0x5957c7/2 (written), 0x5957c9/2 (written). eax is left-over and not meaningful. */
uint32_t m4b72a9_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4b9e3b, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x4]/2, [self+0x6]/2, [self+0x8]/4, [self+0xc]/4, [self+0x10]/4, [self+0x14]/4, [self+0x18]/4, [self+0x34]/4. ... Returns eax. */
uint32_t m4b9e3b_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4ba07f, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x8]/4, [self+0xc]/4, [self+0x10]/4, [self+0x14]/4, [self+0x4]/2, [self+0x2bc]/4, [self+0x2bc]/2. Calls (in code order): 0x4b9e3b(this, 0 args), 0x4be18b(this, 0 args), 0x4c2dfb(this, 1 arg), 0x4d3992(1 arg). Returns eax. */
uint32_t m4ba07f_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4ba262, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x34]/4, [self+0x5c]/4, [self+0x64]/4, [self+0x58]/4, [self+0x60]/4. Globals: 0x583102/4, 0x583106/4, 0x58310a/4, 0x58310e/4. Returns eax. */
uint32_t m4ba262_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4ba486, this = ecx (self), `ret 0x4`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword. Stores to [self+0x2d4]/4. Globals: 0x5b44f0/4 (written), 0x5b44f4/4 (written), 0x5c39e5/4 (written), 0x5d0377/4, 0x5d162d/4 (written), 0x5d1631/4 (written), 0x5d1639/4 (written). Returns eax. */
uint32_t m4ba486_lifted(uint8_t *self, uint32_t a0, const Fl18Host *host, Fl39dWorld *world);

/* 0x4be2c6, this = ecx (self), `ret 0x4`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 host pointer (read through). Reads [a0+0x38]/4, [self+0x1a4]/4, [self+0x1a8]/4. Stores to [self+0x1a4]/4, [self+0x1a8]/4. Calls (in code order): 0x51dc6c(1 arg). eax is left-over and not meaningful. */
uint32_t m4be2c6_lifted(uint8_t *self, uint8_t *a0, const Fl18Host *host);

/* 0x4bed70, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x0]/4, [self+0x4]/4. Calls (in code order): 0x4bedb5(this, 0 args). Returns this. */
uint8_t * m4bed70_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4bf63b, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x29]/4, [self+0x2d]/4, [self+0x31]/4, [self+0x35]/4, [self+0x55]/1, [self+0x17a]/4, [self+0x17e]/4, [self+0x182]/4. ... Globals: 0x5d19fb/4 (written). Returns this. */
uint8_t * m4bf63b_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4bf8a7, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Calls (in code order): 0x4bf63b(this, 0 args), 0x4bf773(this, 0 args). Returns eax. */
uint32_t m4bf8a7_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4c139a, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x1f24]/4, [self+0x1f28]/4. Stores to [self+0x0]/4, [self+0x1f24]/4, [self+0x1f28]/4. Calls (in code order): 0x43ef27(this, 0 args), 0x51dc6c(1 arg). Returns eax. The structured-exception frame is linked and unlinked (not modelled). */
uint32_t m4c139a_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4c4b12, this = ecx (self), `ret 0xc`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 host pointer (read through), a1 dword, a2 host pointer (read through). Reads [a0+0x2f]/2, [a2+0x4]/4, [a0+0x0]/4, [a2+0x0]/4, [a2+0xc]/4, [a2+0x8]/4. Globals: 0x639895/2. Calls (in code order): 0x4264e8(this, 1 arg), 0x43ef77(this, 3 args), 0x43efb6(this, 3 args), 0x4c97b4(this, 0 args). Returns eax. */
uint32_t m4c4b12_lifted(uint8_t *self, uint8_t *a0, uint32_t a1, uint8_t *a2, const Fl18Host *host, Fl39dWorld *world);

/* 0x4c4c2b, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0xe88]/2, [self+0x8]/4, [self+0xc]/4, [self+0xe86]/2. Stores to [self+0xe86]/2. Globals: 0x63a8dc/4 (written), 0x63a8d8/2 (written). Calls (in code order): 0x4c500c(this, 6 args), 0x4c94ec(this, 0 args), 0x4c9805(this, 0 args). Returns eax. */
uint32_t m4c4c2b_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4c9428, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Calls (in code order): 0x4c2dfb(this, 1 arg). eax is left-over and not meaningful. */
uint32_t m4c9428_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4c9b66, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x1f28]/4. Stores to [self+0x1f34]/4. Calls (in code order): 0x50cd72(5 args), 0x50cee4(1 arg), 0x50cf61(4 args), 0x50d0a9(2 args). Returns eax. */
uint32_t m4c9b66_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4c9c10, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x1f24]/4. Calls (in code order): 0x50cd72(5 args), 0x50cee4(1 arg), 0x50d0a9(2 args), 0x50e493(4 args). Returns eax. */
uint32_t m4c9c10_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4ca92e, this = ecx (self), `ret 0x4`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 host pointer (read through). Reads [a0+0x4]/4, [a0+0x8]/4, [a0+0xc]/4, [a0+0x10]/4, [a0+0x14]/4, [a0+0x16c]/4, [a0+0x3c]/4, [a0+0x40]/4. ... Calls (in code order): 0x44a2b7(1 arg), 0x50ca3e(3 args). Returns eax. */
uint32_t m4ca92e_lifted(uint8_t *self, uint8_t *a0, const Fl18Host *host);

/* 0x4caec0, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. eax is left-over and not meaningful. */
uint32_t m4caec0_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4caff5, this = ecx (self), `ret 0xc`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 host pointer (read through), a1 host pointer (read through), a2 host pointer (read through). Reads [a1+0x0]/4, [a0+0x0]/4, [a2+0x0]/4. Stores to [a1+0x0]/4, [a2+0x0]/4, [r2+0x0]/104, [r2+0x68]/1. Globals: 0x63a4cd/2. Calls (in code order): 0x44a2b7(1 arg), 0x4cc70f(this, 2 args). Returns eax. */
uint32_t m4caff5_lifted(uint8_t *self, uint8_t *a0, uint8_t *a1, uint8_t *a2, const Fl18Host *host, Fl39dWorld *world);

/* 0x4cca0e, this = ecx (self), `ret 0x10`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 host pointer (read through), a1 dword, a2 dword, a3 dword. Stores to [a0+0x30]/4, [a0+0x34]/4, [a0+0x38]/4. Calls (in code order): 0x4cc962(this, 1 arg). Returns eax. */
uint32_t m4cca0e_lifted(uint8_t *self, uint8_t *a0, uint32_t a1, uint32_t a2, uint32_t a3, const Fl18Host *host);

/* 0x4ccc50, this = ecx (self), `ret 0xc`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword, a1 dword, a2 host pointer (read through). Reads [a2+0x8]/4, [a2+0x4]/4, [a2+0x0]/4. Calls (in code order): 0x4ccc81(this, 5 args). Returns eax. */
uint32_t m4ccc50_lifted(uint8_t *self, uint32_t a0, uint32_t a1, uint8_t *a2, const Fl18Host *host);

/* 0x4cd645, this = ecx (self), `ret 0xc`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 host pointer (read through), a1 host pointer (read through), a2 host pointer (read through). Reads [a1+0x0]/4, [a0+0x0]/4, [r1+0x0]/4, [r1+0x4]/4, [r1+0x8]/4, [r1+0xc]/2, [r1+0xe]/1, [a2+0x0]/4. Stores to [a1+0x0]/4, [a2+0x0]/4, [r2+0x0]/4, [r2+0x4]/4, [r2+0x8]/4, [r2+0xc]/2, [r2+0xe]/1. Globals: 0x5bb57b/4, 0x5c39e3/2, 0x63a4cd/2. Calls (in code order): 0x42639d(this, 2 args), 0x44a2b7(1 arg), 0x4c97b4(this, 0 args), 0x4cf1e4(this, 2 args), 0x50ca3e(4 args). Returns eax. */
uint32_t m4cd645_lifted(uint8_t *self, uint8_t *a0, uint8_t *a1, uint8_t *a2, const Fl18Host *host, Fl39dWorld *world);

/* 0x4d00d2, ecx unused, plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x5bb1c4/2 (written). Calls (in code order): 0x4e0742(this, 0 args), 0x4e119b(this, 0 args). Returns eax. */
uint32_t m4d00d2_lifted(const Fl18Host *host, Fl39dWorld *world);

/* 0x4d3723, ecx unused, plain `ret`, lifted mechanically from the instruction stream; not original source structure. eax is left-over and not meaningful. */
uint32_t m4d3723_lifted(const Fl18Host *host);

/* 0x4d3b95, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x1c]/4, [self+0x43e]/2, [self+0x440]/4, [self+0x444]/4, [self+0x45e]/4. Globals: 0x5d1c4b/4 (written). Calls (in code order): 0x4d3bef(this, 0 args). Returns eax. */
uint32_t m4d3b95_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4d3c9a, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x61c6ae/1, 0x5d1c4b/4 (written). Returns eax. */
uint32_t m4d3c9a_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4d3cba, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x45e]/4. Stores to [self+0x45a]/4, [self+0x45e]/4. Globals: 0x5d1c4b/4. Returns this. */
uint8_t * m4d3cba_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4d3ced, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x45e]/4, [self+0x45a]/4. Stores to [self+0x45e]/4. Globals: 0x5d1c4b/4 (written). Returns this. */
uint8_t * m4d3ced_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4d4043, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x5cf665/4, 0x5d0377/4. Calls (in code order): 0x4c5377(this, 5 args). Returns eax. */
uint32_t m4d4043_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4d4645, ecx unused, plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x583981/4 (written), 0x583985/4 (written), 0x5839a1/4 (written). Calls (in code order): 0x43dbd5(0 args), 0x4c2dfb(this, 1 arg), 0x4dad60(this, 0 args), 0x4db870(this, 0 args). Returns eax. */
uint32_t m4d4645_lifted(const Fl18Host *host, Fl39dWorld *world);

/* 0x4d47b0, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x5839a5/4 (written), 0x5b451f/2. Calls (in code order): 0x4d4803(0 args), 0x4d4c24(0 args), 0x4fb2a6(this, 2 args). Returns eax. */
uint32_t m4d47b0_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4d56e2, this = ecx (self), `ret 0xc`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 host pointer (read through), a1 host pointer (read through), a2 host pointer (read through). Reads [a2+0x0]/4, [a1+0x0]/4, [a2+0x8]/4, [a1+0x8]/4, [a2+0x4]/4, [a1+0x4]/4, [a2+0xc]/4, [a1+0xc]/4. ... Stores to [a0+0x0]/4, [a0+0x4]/4, [a0+0x8]/4, [a0+0xc]/4, [a1+0x0]/4, [a1+0x4]/4, [a1+0x8]/4, [a1+0xc]/4. Returns eax. */
uint32_t m4d56e2_lifted(uint8_t *self, uint8_t *a0, uint8_t *a1, uint8_t *a2, const Fl18Host *host);

/* 0x4d57e8, this = ecx (self), `ret 0x8`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 host pointer (read through), a1 host pointer (read through). Reads [a0+0x0]/4, [a1+0x0]/4, [a0+0x8]/4, [a1+0x8]/4, [a0+0x4]/4, [a1+0x4]/4, [a0+0xc]/4, [a1+0xc]/4. Returns eax. */
uint32_t m4d57e8_lifted(uint8_t *self, uint8_t *a0, uint8_t *a1, const Fl18Host *host);

/* 0x4d5834, this = ecx (self), `ret 0x8`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 host pointer (read through), a1 host pointer (read through). Reads [a0+0x8]/4, [a1+0x0]/4, [a0+0x0]/4, [a1+0x8]/4, [a0+0xc]/4, [a1+0x4]/4, [a0+0x4]/4, [a1+0xc]/4. Returns eax. */
uint32_t m4d5834_lifted(uint8_t *self, uint8_t *a0, uint8_t *a1, const Fl18Host *host);

/* 0x4d6787, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x2b4]/2, [self+0x2b6]/2. Stores to [self+0x4]/4, [self+0x955a]/4. Globals: 0x58320d/1 (written), 0x5d17f5/4 (written), 0x63a998/2 (written). Calls (in code order): 0x425fc0(0 args), 0x43da93(0 args), 0x4c924d(this, 1 arg), 0x4d8618(this, 0 args), 0x4d88de(this, 0 args), 0x4d8f0a(this, 0 args), 0x4dad60(this, 0 args). Returns this. */
uint8_t * m4d6787_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4d794d, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x955e]/4. Globals: 0x583981/4 (written), 0x583985/4 (written), 0x5839a1/4 (written), 0x5bb1e2/4. Calls (in code order): 0x4d79c7(this, 0 args), 0x4db870(this, 0 args). Returns eax. */
uint32_t m4d794d_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4d79c7, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x2b4]/2, [self+0x2b6]/2. Globals: 0x5d2ecb/4 (written). Calls (in code order): 0x43dbd5(0 args), 0x4c92c5(this, 1 arg), 0x4dad60(this, 0 args). Returns eax. */
uint32_t m4d79c7_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4d8f8d, this = ecx (self), `ret 0x4`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword. Calls (in code order): 0x51dc6c(1 arg). eax is left-over and not meaningful. */
uint32_t m4d8f8d_lifted(uint8_t *self, uint32_t a0, const Fl18Host *host);

/* 0x4d912a, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x98ac]/4. Stores to [self+0x98ac]/4. Calls (in code order): 0x42639d(this, 2 args), 0x4c97b4(this, 0 args), 0x50ca3e(3 args), 0x50cd72(5 args), 0x50cee4(1 arg), 0x50cf61(4 args), 0x50d0a9(2 args). Returns eax. */
uint32_t m4d912a_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4d920c, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x98ac]/4. Stores to [self+0x98ac]/4. Calls (in code order): 0x42639d(this, 2 args), 0x4c97b4(this, 0 args), 0x50ca3e(3 args), 0x50cd72(5 args), 0x50cee4(1 arg), 0x50d0a9(2 args), 0x50e493(4 args). Returns eax. */
uint32_t m4d920c_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4d9d70, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x5839a1/4 (written), 0x5b451f/2, 0x63a4cd/2. Calls (in code order): 0x44a2b7(1 arg), 0x4d9df3(0 args), 0x4da430(0 args), 0x4fb2a6(this, 2 args). Returns eax. */
uint32_t m4d9d70_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4db066, this = ecx (self), `ret 0x8`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 unused, a1 unused. Reads [self+0x10]/4. Stores to [self+0xc]/4, [self+0x10]/4. Returns this. */
uint8_t * m4db066_lifted(uint8_t *self, uint32_t a0, uint32_t a1, const Fl18Host *host);

/* 0x4db780, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x34]/4, [self+0x3c]/4, [self+0x38]/4, [self+0x40]/4. Stores to [self+0x44]/4, [self+0x48]/4, [self+0x4c]/4, [self+0x50]/4, [self+0x54]/4, [self+0x58]/4, [self+0x5c]/4, [self+0x60]/4. Globals: 0x583186/4, 0x58318a/4, 0x5d1683/4 (written), 0x5d16cd/4 (written). Calls (in code order): 0x493a54(this, 0 args). Returns eax. */
uint32_t m4db780_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4db817, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x34]/4, [self+0x38]/4, [self+0x3c]/4, [self+0x40]/4. Stores to [self+0x24]/4, [self+0x28]/4, [self+0x2c]/4, [self+0x30]/4. Globals: 0x5d1683/4 (written), 0x5d16cd/4 (written). Calls (in code order): 0x493a47(this, 0 args), 0x493af0(this, 0 args). Returns eax. */
uint32_t m4db817_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4dbc77, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x1c]/4, [self+0x20]/4. Returns this. */
uint8_t * m4dbc77_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4dbfbf, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x1c]/4, [self+0x46]/4, [self+0x4a]/4, [self+0xee]/4, [self+0xf2]/4, [self+0xf6]/4, [self+0xfa]/4, [self+0xfe]/4. ... Returns this. */
uint8_t * m4dbfbf_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4dd28d, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0xb7]/2, [self+0xee]/4, [r1+0x1c2]/2, [r1+0x18e]/2, [r1+0x18c]/2. Stores to [r1+0x1c2]/2. eax is left-over and not meaningful. */
uint32_t m4dd28d_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4dd409, this = ecx (self), `ret 0x8`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword, a1 dword. Reads [self+0x4]/4. Stores to [self+0x4]/4. Globals: 0x5b451f/2. Calls (in code order): 0x4dd471(this, 1 arg), 0x4dd8f7(this, 1 arg), 0x4fb2a6(this, 2 args). eax is left-over and not meaningful. */
uint32_t m4dd409_lifted(uint8_t *self, uint32_t a0, uint32_t a1, const Fl18Host *host, Fl39dWorld *world);

/* 0x4de009, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x5cf665/4, 0x5d2d4d/4, 0x5d2e75/4, 0x616872/2, 0x63a4cd/2. Calls (in code order): 0x44a2b7(1 arg), 0x4c5377(this, 5 args). Returns eax. */
uint32_t m4de009_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4de0cf, ecx unused, plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x5cf665/4, 0x5d2d4d/4, 0x63a4cd/2. Calls (in code order): 0x44a2b7(1 arg), 0x4c5377(this, 5 args). Returns eax. */
uint32_t m4de0cf_lifted(const Fl18Host *host, Fl39dWorld *world);

/* 0x4de4f9, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x991]/4. Calls (in code order): 0x4de2d8(this, 0 args), 0x4de440(this, 0 args), 0x4ee6c7(this, 1 arg). eax is left-over and not meaningful. */
uint32_t m4de4f9_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4de6d7, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x73c]/4, [self+0x740]/4. Returns this. */
uint8_t * m4de6d7_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4de6fc, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x5d03b7/4. Calls (in code order): 0x4c2dfb(this, 1 arg), 0x4de6d7(this, 0 args), 0x4e1d34(this, 0 args), 0x4eead0(this, 0 args). Returns eax. */
uint32_t m4de6fc_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4e01b3, ecx unused, plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x5cf665/4, 0x5d02ab/4, 0x5d03b7/4. Calls (in code order): 0x4c5377(this, 5 args), 0x4e2b99(this, 0 args), 0x4eff03(this, 0 args). eax is left-over and not meaningful. */
uint32_t m4e01b3_lifted(const Fl18Host *host, Fl39dWorld *world);

/* 0x4e023b, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x5835da/4, 0x5bb202/4, 0x5bb206/4, 0x5cf665/4, 0x5d2819/4. Calls (in code order): 0x4c5377(this, 5 args), 0x4c5d4b(this, 5 args). Returns eax. */
uint32_t m4e023b_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4e0377, ecx unused, plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x5cf665/4, 0x5d2819/4, 0x5d298b/4, 0x5835d8/2. Calls (in code order): 0x4c5377(this, 5 args). Returns eax. */
uint32_t m4e0377_lifted(const Fl18Host *host, Fl39dWorld *world);

/* 0x4e0619, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x74f]/4, [self+0x753]/4. Stores to [self+0x753]/4. Calls (in code order): 0x4c2dfb(this, 1 arg), 0x4e04f3(this, 0 args), 0x4e1d34(this, 0 args). Returns eax. */
uint32_t m4e0619_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4e06c0, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x753]/4. Stores to [self+0x753]/4. Calls (in code order): 0x4e04f3(this, 0 args), 0x4e1a7e(this, 0 args), 0x4e1db3(this, 1 arg). Returns eax. */
uint32_t m4e06c0_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4e119b, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0xf2e]/4, [self+0x74f]/4. Stores to [self+0xf2e]/4. Globals: 0x5cf665/4. Calls (in code order): 0x4c5377(this, 5 args). eax is left-over and not meaningful. */
uint32_t m4e119b_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4e1c9f, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x14]/4, [self+0x18]/4, [self+0x1c]/4, [self+0x20]/4, [self+0x24]/4, [self+0x28]/4, [self+0x177]/4, [self+0x17b]/4. ... Returns this. */
uint8_t * m4e1c9f_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4e2913, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x17b]/4. Stores to [self+0x17b]/4. Returns eax. */
uint32_t m4e2913_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4e29b7, this = ecx (self), `ret 0x4`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword. Reads [self+0x1c]/4. Stores to [self+0x1c]/4, [self+0x30]/4. Returns this. */
uint8_t * m4e29b7_lifted(uint8_t *self, uint32_t a0, const Fl18Host *host);

/* 0x4e2dd3, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x4528]/4, [self+0x452c]/4, [self+0x4534]/4. Returns this. */
uint8_t * m4e2dd3_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4e35e8, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x5a1e58/4. Calls (in code order): 0x4e2940(this, 1 arg). eax is left-over and not meaningful. */
uint32_t m4e35e8_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4e364a, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Calls (in code order): 0x4e2940(this, 1 arg). eax is left-over and not meaningful. */
uint32_t m4e364a_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4e3691, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Calls (in code order): 0x4e2940(this, 1 arg). Returns eax. */
uint32_t m4e3691_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4e36fc, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x5a1e58/4. Calls (in code order): 0x4e2940(this, 1 arg). Returns eax. */
uint32_t m4e36fc_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4e3772, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Calls (in code order): 0x4e2940(this, 1 arg). Returns eax. */
uint32_t m4e3772_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4e3a64, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x6b8]/2, [self+0x6ba]/2, [self+0x6bc]/2, [self+0x6be]/2, [self+0x6c2]/4, [self+0x6c6]/4. Globals: 0x5bb5a7/4, 0x5bb5ab/4, 0x5bb5af/4, 0x5bb50b/2, 0x5bb57b/2, 0x5bb57f/2, 0x5bb593/2. Returns this. */
uint8_t * m4e3a64_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4e40a6, this = ecx (self), `ret 0x1c`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword, a1 unused, a2 dword, a3 unused, a4 dword, a5 host pointer (read through), a6 dword. Reads [a5+0x4]/4. Stores to [a5+0x4]/4, [a5+0xc]/4, [self+0x4579]/2. Returns this. */
uint8_t * m4e40a6_lifted(uint8_t *self, uint32_t a0, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint8_t *a5, uint32_t a6, const Fl18Host *host);

/* 0x4e49e2, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x691]/4, [self+0x6a5]/2, [self+0x6a7]/4, [self+0x6ab]/4, [self+0x6af]/2, [self+0x6b1]/1, [self+0x53c1]/4. Calls (in code order): 0x4e354a(this, 0 args), 0x4e364a(this, 0 args). Returns eax. */
uint32_t m4e49e2_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4e7970, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x991]/4. Calls (in code order): 0x4d3137(0 args), 0x4e7757(this, 0 args), 0x4ee6c7(this, 1 arg). eax is left-over and not meaningful. */
uint32_t m4e7970_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4e79ca, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x5cf665/4. Calls (in code order): 0x4c5377(this, 5 args), 0x4ee630(this, 0 args). Returns eax. */
uint32_t m4e79ca_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4e7c72, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x699]/4, [self+0x695]/4, [self+0x691]/4. Stores to [self+0x691]/4, [self+0x695]/4, [self+0x699]/4. Calls (in code order): 0x4c2dfb(this, 1 arg). eax is left-over and not meaningful. */
uint32_t m4e7c72_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4e7dad, this = ecx (self), `ret 0x4`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 host pointer (read through). Reads [a0+0x112c]/4, [a0+0x1120]/4. Stores to [self+0x0]/1, [self+0x69d]/1. Calls (in code order): 0x42639d(this, 2 args), 0x4343a2(this, 1 arg). Returns eax. */
uint32_t m4e7dad_lifted(uint8_t *self, uint8_t *a0, const Fl18Host *host);

/* 0x4e8d72, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x6b1c]/4. Stores to [self+0x6b1c]/4. Returns this. */
uint8_t * m4e8d72_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4e94a9, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x7011]/1. Returns eax. */
uint32_t m4e94a9_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4ea1cb, this = ecx (self), `ret 0x4`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword. Reads [self+0x699]/4. Stores to [self+0x699]/4. Globals: 0x5d1717/4 (written), 0x63a4cd/2. Calls (in code order): 0x44a2b7(1 arg), 0x4c2790(this, 4 args). eax is left-over and not meaningful. */
uint32_t m4ea1cb_lifted(uint8_t *self, uint32_t a0, const Fl18Host *host, Fl39dWorld *world);

/* 0x4ea361, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x8256]/4, [self+0x8286]/4. Stores to [self+0x8256]/4. Globals: 0x585d37/4, 0x5b1602/4 (written). Returns this. */
uint8_t * m4ea361_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4eb5f2, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x7011]/1. Globals: 0x583232/1 (written), 0x583999/4 (written), 0x5bb1ca/4 (written), 0x5bb57b/4 (written), 0x5bb57f/4 (written), 0x5bb59b/4 (written), 0x5bb59f/4 (written), 0x5bb5a3/4 (written). Calls (in code order): 0x4e0559(this, 3 args), 0x4e9e84(this, 2 args), 0x52139c(3 args). Returns this. */
uint8_t * m4eb5f2_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4eb9c8, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0xca0]/4, [self+0xca4]/4, [self+0xfca]/4, [self+0xfce]/4, [self+0x28da]/2. Returns eax. */
uint32_t m4eb9c8_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4eda10, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x0]/4. Calls (in code order): 0x4e1c50(this, 0 args), 0x4edae5(this, 0 args), 0x4ee980(this, 0 args). Returns this. The structured-exception frame is linked and unlinked (not modelled). */
uint8_t * m4eda10_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4edae5, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x2c]/752, [self+0x4ab]/4, [self+0x4af]/4, [self+0x4b3]/4, [self+0x675]/4, [self+0x679]/4, [self+0x67d]/4, [self+0x681]/4. ... Globals: 0x55cd94/4 (written), 0x63aa10/4 (written). Returns eax. */
uint32_t m4edae5_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4ee517, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x4af]/4, [self+0x15f]/4. Stores to [self+0x685]/4. Calls (in code order): 0x4e26fc(this, 0 args). Returns eax. */
uint32_t m4ee517_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4ee572, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x55cd94/4, 0x63aa10/4. Returns eax. */
uint32_t m4ee572_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4ee598, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x4af]/4. Returns eax. */
uint32_t m4ee598_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4ee5f2, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x63aa10/4. Returns eax. */
uint32_t m4ee5f2_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4ee9bb, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x4]/4, [self+0x8]/4, [self+0xc]/4, [self+0x18]/196, [self+0xdc]/2, [self+0x14e]/4, [self+0x152]/4, [self+0x156]/4. ... Returns eax. */
uint32_t m4ee9bb_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4eead0, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x1a2]/4, [self+0x8]/4, [self+0xc]/4. Calls (in code order): 0x4c2dfb(this, 1 arg), 0x4ee9bb(this, 0 args). Returns eax. */
uint32_t m4eead0_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4ef3ed, this = ecx (self), `ret 0x4`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword. Reads [self+0x10]/4, [self+0xc2]/4, [self+0xca]/4. Stores to [self+0x10]/4, [self+0x19a]/4. Globals: 0x5b44f0/4, 0x5b44f4/4 (written), 0x5c39e5/4 (written), 0x5d1631/4 (written), 0x5d1639/4 (written). Calls (in code order): 0x4d5316(this, 2 args). Returns eax. */
uint32_t m4ef3ed_lifted(uint8_t *self, uint32_t a0, const Fl18Host *host, Fl39dWorld *world);

/* 0x4ef4f0, this = ecx (self), `ret 0x4`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword. Stores to [self+0x162]/4, [self+0x19e]/4. Returns this. */
uint8_t * m4ef4f0_lifted(uint8_t *self, uint32_t a0, const Fl18Host *host);

/* 0x4f67be, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x63a4cd/2. Calls (in code order): 0x44a2b7(1 arg), 0x4f646c(this, 2 args). Returns eax. */
uint32_t m4f67be_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4f6810, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Calls (in code order): 0x4f6624(this, 2 args). Returns eax. */
uint32_t m4f6810_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4f8a17, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x26c]/4, [self+0x268]/4, [self+0x264]/4, [self+0x260]/4, [self+0x25c]/4, [self+0x258]/4. Calls (in code order): 0x4f88de(this, 6 args). Returns eax. */
uint32_t m4f8a17_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4fafc7, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x63a4cd/2. Calls (in code order): 0x44a2b7(1 arg), 0x4fb1c6(this, 1 arg). Returns eax. */
uint32_t m4fafc7_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4fb018, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x63a4cd/2. Calls (in code order): 0x44a2b7(1 arg), 0x4fc05d(this, 0 args), 0x4fc808(this, 1 arg). Returns eax. */
uint32_t m4fb018_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4fb071, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Calls (in code order): 0x4fc808(this, 1 arg). Returns eax. */
uint32_t m4fb071_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4fb086, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Calls (in code order): 0x4fb0bf(this, 1 arg). eax is left-over and not meaningful. */
uint32_t m4fb086_lifted(uint8_t *self, const Fl18Host *host);

/* 0x4fb1c6, this = ecx (self), `ret 0x4`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword. Stores to [self+0x12c]/4, [self+0x132]/2. Globals: 0x63a4cd/2. Calls (in code order): 0x44a2b7(1 arg), 0x4f6334(this, 1 arg), 0x4f646c(this, 2 args), 0x50ca3e(3 args). eax is left-over and not meaningful. */
uint32_t m4fb1c6_lifted(uint8_t *self, uint32_t a0, const Fl18Host *host, Fl39dWorld *world);

/* 0x4fb737, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Calls (in code order): 0x4fc808(this, 1 arg). eax is left-over and not meaningful. */
uint32_t m4fb737_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4fba86, this = ecx (self), `ret 0x4`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 host pointer (read through). Reads [a0+0x21]/2. Calls (in code order): 0x4fb2e3(this, 1 arg), 0x4fb77a(this, 1 arg). Returns eax. */
uint32_t m4fba86_lifted(uint8_t *self, uint8_t *a0, const Fl18Host *host);

/* 0x4fbd7e, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x5b00d9/2. Calls (in code order): 0x4fc808(this, 1 arg). Returns eax. */
uint32_t m4fbd7e_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world);

/* 0x4fce90, this = ecx (self), `ret 0x4`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword. Calls (in code order): 0x4fa9e7(this, 0 args), 0x51dc6c(1 arg). Returns this. */
uint8_t * m4fce90_lifted(uint8_t *self, uint32_t a0, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
