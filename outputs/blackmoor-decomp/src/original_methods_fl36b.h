#ifndef BLACKMOOR_ORIGINAL_METHODS_FL36B_H
#define BLACKMOOR_ORIGINAL_METHODS_FL36B_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-36 (batch b): 129 small functions of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-35 (see original_methods_fl35b.h, whose conventions apply
 * unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original address in its leading comment, `self` is the original
 * object (ecx) as raw bytes at the original offsets, nothing is bounds checked, and the effects keep the order of the original. The names are descriptive hints, not recovered
 * source names.
 *
 * get      112 rows: getters that return one constant (`mov eax, imm32`).
 * empty     17 rows: methods that do nothing.
 * The constants of every row (the returned value, the vtable dword, the callee, the stored constant) were read from that row's own disassembly by the generator, which also
 * asserted that every row of a kind has the identical masked instruction stream. A callee that changes `self` or a global that the function reads again afterwards is not
 * exercised (the functions read nothing again). */

/* 0x40104e, thiscall, plain `ret`: returns the constant 0x52a550u in eax; `this` is only saved in a local and not read. */
uint32_t m40104e_get_constant(uint8_t *self);

/* 0x4010b0, thiscall, plain `ret`: returns the constant 0x80u in eax; `this` is only saved in a local and not read. */
uint32_t m4010b0_get_constant(uint8_t *self);

/* 0x40148a, thiscall, plain `ret`: returns the constant 0x52a688u in eax; `this` is only saved in a local and not read. */
uint32_t m40148a_get_constant(uint8_t *self);

/* 0x40167f, thiscall, plain `ret`: returns the constant 0x52a6a0u in eax; `this` is only saved in a local and not read. */
uint32_t m40167f_get_constant(uint8_t *self);

/* 0x402952, thiscall, plain `ret`: returns the constant 0x52ac60u in eax; `this` is only saved in a local and not read. */
uint32_t m402952_get_constant(uint8_t *self);

/* 0x4030aa, thiscall, plain `ret`: returns the constant 0x52af90u in eax; `this` is only saved in a local and not read. */
uint32_t m4030aa_get_constant(uint8_t *self);

/* 0x40339b, thiscall, plain `ret`: returns the constant 0x52afa8u in eax; `this` is only saved in a local and not read. */
uint32_t m40339b_get_constant(uint8_t *self);

/* 0x4033cb, thiscall, plain `ret`: returns the constant 0x1u in eax; `this` is only saved in a local and not read. */
uint32_t m4033cb_get_constant(uint8_t *self);

/* 0x404aba, thiscall, plain `ret`: returns the constant 0x52b358u in eax; `this` is only saved in a local and not read. */
uint32_t m404aba_get_constant(uint8_t *self);

/* 0x404b39, thiscall, plain `ret`: returns the constant 0x1u in eax; `this` is only saved in a local and not read. */
uint32_t m404b39_get_constant(uint8_t *self);

/* 0x405b62, thiscall, plain `ret`: returns the constant 0x52b370u in eax; `this` is only saved in a local and not read. */
uint32_t m405b62_get_constant(uint8_t *self);

/* 0x407baa, thiscall, plain `ret`: returns the constant 0x52bb28u in eax; `this` is only saved in a local and not read. */
uint32_t m407baa_get_constant(uint8_t *self);

/* 0x407c97, thiscall, plain `ret`: returns the constant 0x52bb40u in eax; `this` is only saved in a local and not read. */
uint32_t m407c97_get_constant(uint8_t *self);

/* 0x407d90, thiscall, plain `ret`: returns the constant 0x1u in eax; `this` is only saved in a local and not read. */
uint32_t m407d90_get_constant(uint8_t *self);

/* 0x408a1a, thiscall, plain `ret`: returns the constant 0x52bfc8u in eax; `this` is only saved in a local and not read. */
uint32_t m408a1a_get_constant(uint8_t *self);

/* 0x40906b, thiscall, plain `ret`: returns the constant 0x52bfe0u in eax; `this` is only saved in a local and not read. */
uint32_t m40906b_get_constant(uint8_t *self);

/* 0x40909b, thiscall, plain `ret`: returns the constant 0x1u in eax; `this` is only saved in a local and not read. */
uint32_t m40909b_get_constant(uint8_t *self);

/* 0x414527, thiscall, plain `ret`: returns the constant 0x52c4b8u in eax; `this` is only saved in a local and not read. */
uint32_t m414527_get_constant(uint8_t *self);

/* 0x41a4be, thiscall, plain `ret`: does nothing; `this` is only saved in a local (eax is not set). */
void m41a4be_empty_method(uint8_t *self);

/* 0x41be0a, thiscall, plain `ret`: returns the constant 0x52c5f0u in eax; `this` is only saved in a local and not read. */
uint32_t m41be0a_get_constant(uint8_t *self);

/* 0x4229fa, thiscall, plain `ret`: returns the constant 0x52c608u in eax; `this` is only saved in a local and not read. */
uint32_t m4229fa_get_constant(uint8_t *self);

/* 0x426510, thiscall, plain `ret`: returns the constant 0x52c690u in eax; `this` is only saved in a local and not read. */
uint32_t m426510_get_constant(uint8_t *self);

/* 0x43eb1a, thiscall, plain `ret`: returns the constant 0x52c7c0u in eax; `this` is only saved in a local and not read. */
uint32_t m43eb1a_get_constant(uint8_t *self);

/* 0x43eb2a, thiscall, plain `ret`: returns the constant 0x52c7d8u in eax; `this` is only saved in a local and not read. */
uint32_t m43eb2a_get_constant(uint8_t *self);

/* 0x43ef00, thiscall, plain `ret`: returns the constant 0x52c9f8u in eax; `this` is only saved in a local and not read. */
uint32_t m43ef00_get_constant(uint8_t *self);

/* 0x446f67, thiscall, plain `ret`: returns the constant 0x52ca20u in eax; `this` is only saved in a local and not read. */
uint32_t m446f67_get_constant(uint8_t *self);

/* 0x447e17, thiscall, plain `ret`: returns the constant 0x52cad0u in eax; `this` is only saved in a local and not read. */
uint32_t m447e17_get_constant(uint8_t *self);

/* 0x447e78, thiscall, plain `ret`: does nothing; `this` is only saved in a local (eax is not set). */
void m447e78_empty_method(uint8_t *self);

/* 0x448853, thiscall, plain `ret`: does nothing; `this` is only saved in a local (eax is not set). */
void m448853_empty_method(uint8_t *self);

/* 0x448871, thiscall, plain `ret`: does nothing; `this` is only saved in a local (eax is not set). */
void m448871_empty_method(uint8_t *self);

/* 0x44afa7, thiscall, plain `ret`: returns the constant 0x52cb60u in eax; `this` is only saved in a local and not read. */
uint32_t m44afa7_get_constant(uint8_t *self);

/* 0x44d087, thiscall, plain `ret`: returns the constant 0x52cc00u in eax; `this` is only saved in a local and not read. */
uint32_t m44d087_get_constant(uint8_t *self);

/* 0x44e025, thiscall, plain `ret`: returns the constant 0x52cc18u in eax; `this` is only saved in a local and not read. */
uint32_t m44e025_get_constant(uint8_t *self);

/* 0x44e6e7, thiscall, plain `ret`: returns the constant 0x52cc88u in eax; `this` is only saved in a local and not read. */
uint32_t m44e6e7_get_constant(uint8_t *self);

/* 0x44e80b, thiscall, plain `ret`: does nothing; `this` is only saved in a local (eax is not set). */
void m44e80b_empty_method(uint8_t *self);

/* 0x44f4ea, thiscall, plain `ret`: returns the constant 0x52cca0u in eax; `this` is only saved in a local and not read. */
uint32_t m44f4ea_get_constant(uint8_t *self);

/* 0x454d0a, thiscall, plain `ret`: returns the constant 0x52cd18u in eax; `this` is only saved in a local and not read. */
uint32_t m454d0a_get_constant(uint8_t *self);

/* 0x456506, thiscall, plain `ret`: returns the constant 0x52cd30u in eax; `this` is only saved in a local and not read. */
uint32_t m456506_get_constant(uint8_t *self);

/* 0x456c87, thiscall, plain `ret`: returns the constant 0x52cda0u in eax; `this` is only saved in a local and not read. */
uint32_t m456c87_get_constant(uint8_t *self);

/* 0x457bc8, thiscall, plain `ret`: returns the constant 0x52cdb8u in eax; `this` is only saved in a local and not read. */
uint32_t m457bc8_get_constant(uint8_t *self);

/* 0x457efa, thiscall, plain `ret`: returns the constant 0x52ce28u in eax; `this` is only saved in a local and not read. */
uint32_t m457efa_get_constant(uint8_t *self);

/* 0x4595e1, thiscall, plain `ret`: returns the constant 0x52ce40u in eax; `this` is only saved in a local and not read. */
uint32_t m4595e1_get_constant(uint8_t *self);

/* 0x459a6a, thiscall, plain `ret`: returns the constant 0x52ceb0u in eax; `this` is only saved in a local and not read. */
uint32_t m459a6a_get_constant(uint8_t *self);

/* 0x45ae5e, thiscall, plain `ret`: returns the constant 0x52cec8u in eax; `this` is only saved in a local and not read. */
uint32_t m45ae5e_get_constant(uint8_t *self);

/* 0x45b36a, thiscall, plain `ret`: returns the constant 0x52cf38u in eax; `this` is only saved in a local and not read. */
uint32_t m45b36a_get_constant(uint8_t *self);

/* 0x45d2b6, thiscall, plain `ret`: returns the constant 0x52cf50u in eax; `this` is only saved in a local and not read. */
uint32_t m45d2b6_get_constant(uint8_t *self);

/* 0x45dc0a, thiscall, plain `ret`: returns the constant 0x52cfc0u in eax; `this` is only saved in a local and not read. */
uint32_t m45dc0a_get_constant(uint8_t *self);

/* 0x460f16, thiscall, plain `ret`: returns the constant 0x52cfd8u in eax; `this` is only saved in a local and not read. */
uint32_t m460f16_get_constant(uint8_t *self);

/* 0x4617a7, thiscall, plain `ret`: returns the constant 0x52d048u in eax; `this` is only saved in a local and not read. */
uint32_t m4617a7_get_constant(uint8_t *self);

/* 0x463b00, thiscall, plain `ret`: returns the constant 0x52d060u in eax; `this` is only saved in a local and not read. */
uint32_t m463b00_get_constant(uint8_t *self);

/* 0x463f9a, thiscall, plain `ret`: returns the constant 0x52d0d0u in eax; `this` is only saved in a local and not read. */
uint32_t m463f9a_get_constant(uint8_t *self);

/* 0x4657d7, thiscall, plain `ret`: returns the constant 0x52d0e8u in eax; `this` is only saved in a local and not read. */
uint32_t m4657d7_get_constant(uint8_t *self);

/* 0x465a87, thiscall, plain `ret`: returns the constant 0x52d158u in eax; `this` is only saved in a local and not read. */
uint32_t m465a87_get_constant(uint8_t *self);

/* 0x465bd3, thiscall, plain `ret`: does nothing; `this` is only saved in a local (eax is not set). */
void m465bd3_empty_method(uint8_t *self);

/* 0x466e04, thiscall, plain `ret`: returns the constant 0x52d170u in eax; `this` is only saved in a local and not read. */
uint32_t m466e04_get_constant(uint8_t *self);

/* 0x468dda, thiscall, plain `ret`: returns the constant 0x52d1e8u in eax; `this` is only saved in a local and not read. */
uint32_t m468dda_get_constant(uint8_t *self);

/* 0x46ab6f, thiscall, plain `ret`: returns the constant 0x52d200u in eax; `this` is only saved in a local and not read. */
uint32_t m46ab6f_get_constant(uint8_t *self);

/* 0x46b50a, thiscall, plain `ret`: returns the constant 0x52d2b0u in eax; `this` is only saved in a local and not read. */
uint32_t m46b50a_get_constant(uint8_t *self);

/* 0x46dea0, thiscall, plain `ret`: returns the constant 0x52d2c8u in eax; `this` is only saved in a local and not read. */
uint32_t m46dea0_get_constant(uint8_t *self);

/* 0x46e5ea, thiscall, plain `ret`: returns the constant 0x52d338u in eax; `this` is only saved in a local and not read. */
uint32_t m46e5ea_get_constant(uint8_t *self);

/* 0x470a63, thiscall, plain `ret`: returns the constant 0x52d350u in eax; `this` is only saved in a local and not read. */
uint32_t m470a63_get_constant(uint8_t *self);

/* 0x470cfa, thiscall, plain `ret`: returns the constant 0x52d3c0u in eax; `this` is only saved in a local and not read. */
uint32_t m470cfa_get_constant(uint8_t *self);

/* 0x472a4c, thiscall, plain `ret`: returns the constant 0x52d3d8u in eax; `this` is only saved in a local and not read. */
uint32_t m472a4c_get_constant(uint8_t *self);

/* 0x47575a, thiscall, plain `ret`: returns the constant 0x52d458u in eax; `this` is only saved in a local and not read. */
uint32_t m47575a_get_constant(uint8_t *self);

/* 0x4778cf, thiscall, plain `ret`: returns the constant 0x52d470u in eax; `this` is only saved in a local and not read. */
uint32_t m4778cf_get_constant(uint8_t *self);

/* 0x47817a, thiscall, plain `ret`: returns the constant 0x52d4e0u in eax; `this` is only saved in a local and not read. */
uint32_t m47817a_get_constant(uint8_t *self);

/* 0x47ac23, thiscall, plain `ret`: returns the constant 0x52d4f8u in eax; `this` is only saved in a local and not read. */
uint32_t m47ac23_get_constant(uint8_t *self);

/* 0x47d477, thiscall, plain `ret`: returns the constant 0x52d570u in eax; `this` is only saved in a local and not read. */
uint32_t m47d477_get_constant(uint8_t *self);

/* 0x47d677, thiscall, plain `ret`: does nothing; `this` is only saved in a local (eax is not set). */
void m47d677_empty_method(uint8_t *self);

/* 0x47df47, thiscall, plain `ret`: returns the constant 0x52d588u in eax; `this` is only saved in a local and not read. */
uint32_t m47df47_get_constant(uint8_t *self);

/* 0x47e1da, thiscall, plain `ret`: returns the constant 0x52d5f8u in eax; `this` is only saved in a local and not read. */
uint32_t m47e1da_get_constant(uint8_t *self);

/* 0x481ca9, thiscall, plain `ret`: returns the constant 0x52d610u in eax; `this` is only saved in a local and not read. */
uint32_t m481ca9_get_constant(uint8_t *self);

/* 0x4820fa, thiscall, plain `ret`: returns the constant 0x52d680u in eax; `this` is only saved in a local and not read. */
uint32_t m4820fa_get_constant(uint8_t *self);

/* 0x483ac9, thiscall, plain `ret`: returns the constant 0x52d698u in eax; `this` is only saved in a local and not read. */
uint32_t m483ac9_get_constant(uint8_t *self);

/* 0x483eea, thiscall, plain `ret`: returns the constant 0x52d708u in eax; `this` is only saved in a local and not read. */
uint32_t m483eea_get_constant(uint8_t *self);

/* 0x4876dd, thiscall, plain `ret`: returns the constant 0x52d720u in eax; `this` is only saved in a local and not read. */
uint32_t m4876dd_get_constant(uint8_t *self);

/* 0x487a9a, thiscall, plain `ret`: returns the constant 0x52d790u in eax; `this` is only saved in a local and not read. */
uint32_t m487a9a_get_constant(uint8_t *self);

/* 0x487bcc, thiscall, plain `ret`: does nothing; `this` is only saved in a local (eax is not set). */
void m487bcc_empty_method(uint8_t *self);

/* 0x4889e0, thiscall, plain `ret`: returns the constant 0x52d7a8u in eax; `this` is only saved in a local and not read. */
uint32_t m4889e0_get_constant(uint8_t *self);

/* 0x488d5a, thiscall, plain `ret`: returns the constant 0x52d818u in eax; `this` is only saved in a local and not read. */
uint32_t m488d5a_get_constant(uint8_t *self);

/* 0x48a3cb, thiscall, plain `ret`: returns the constant 0x52d830u in eax; `this` is only saved in a local and not read. */
uint32_t m48a3cb_get_constant(uint8_t *self);

/* 0x48a68a, thiscall, plain `ret`: returns the constant 0x52d8a0u in eax; `this` is only saved in a local and not read. */
uint32_t m48a68a_get_constant(uint8_t *self);

/* 0x48b720, thiscall, plain `ret`: returns the constant 0x52d8b8u in eax; `this` is only saved in a local and not read. */
uint32_t m48b720_get_constant(uint8_t *self);

/* 0x48ba97, thiscall, plain `ret`: returns the constant 0x52d928u in eax; `this` is only saved in a local and not read. */
uint32_t m48ba97_get_constant(uint8_t *self);

/* 0x48bc9b, thiscall, plain `ret`: does nothing; `this` is only saved in a local (eax is not set). */
void m48bc9b_empty_method(uint8_t *self);

/* 0x48cc60, thiscall, plain `ret`: returns the constant 0x52d940u in eax; `this` is only saved in a local and not read. */
uint32_t m48cc60_get_constant(uint8_t *self);

/* 0x48cfe7, thiscall, plain `ret`: returns the constant 0x52d9b0u in eax; `this` is only saved in a local and not read. */
uint32_t m48cfe7_get_constant(uint8_t *self);

/* 0x48dec7, thiscall, plain `ret`: returns the constant 0x52d9c8u in eax; `this` is only saved in a local and not read. */
uint32_t m48dec7_get_constant(uint8_t *self);

/* 0x48e20a, thiscall, plain `ret`: returns the constant 0x52da38u in eax; `this` is only saved in a local and not read. */
uint32_t m48e20a_get_constant(uint8_t *self);

/* 0x49026c, thiscall, plain `ret`: returns the constant 0x52da50u in eax; `this` is only saved in a local and not read. */
uint32_t m49026c_get_constant(uint8_t *self);

/* 0x4904ea, thiscall, plain `ret`: returns the constant 0x52dac0u in eax; `this` is only saved in a local and not read. */
uint32_t m4904ea_get_constant(uint8_t *self);

/* 0x494f14, thiscall, plain `ret`: does nothing; `this` is only saved in a local (eax is not set). */
void m494f14_empty_method(uint8_t *self);

/* 0x49c45c, thiscall, plain `ret`: returns the constant 0x52dad8u in eax; `this` is only saved in a local and not read. */
uint32_t m49c45c_get_constant(uint8_t *self);

/* 0x49c52a, thiscall, plain `ret`: returns the constant 0x52db90u in eax; `this` is only saved in a local and not read. */
uint32_t m49c52a_get_constant(uint8_t *self);

/* 0x4a1bc7, thiscall, plain `ret`: returns the constant 0x52dc20u in eax; `this` is only saved in a local and not read. */
uint32_t m4a1bc7_get_constant(uint8_t *self);

/* 0x4a35c7, thiscall, plain `ret`: returns the constant 0x52dc38u in eax; `this` is only saved in a local and not read. */
uint32_t m4a35c7_get_constant(uint8_t *self);

/* 0x4a370a, thiscall, plain `ret`: returns the constant 0x52dca8u in eax; `this` is only saved in a local and not read. */
uint32_t m4a370a_get_constant(uint8_t *self);

/* 0x4a5eda, thiscall, plain `ret`: returns the constant 0x52dcc0u in eax; `this` is only saved in a local and not read. */
uint32_t m4a5eda_get_constant(uint8_t *self);

/* 0x4a630a, thiscall, plain `ret`: returns the constant 0x52dd30u in eax; `this` is only saved in a local and not read. */
uint32_t m4a630a_get_constant(uint8_t *self);

/* 0x4a64ae, thiscall, plain `ret`: does nothing; `this` is only saved in a local (eax is not set). */
void m4a64ae_empty_method(uint8_t *self);

/* 0x4a7a19, thiscall, plain `ret`: returns the constant 0x52dd48u in eax; `this` is only saved in a local and not read. */
uint32_t m4a7a19_get_constant(uint8_t *self);

/* 0x4a7bfa, thiscall, plain `ret`: returns the constant 0x52ddb8u in eax; `this` is only saved in a local and not read. */
uint32_t m4a7bfa_get_constant(uint8_t *self);

/* 0x4a9b1b, thiscall, plain `ret`: returns the constant 0x52ddd0u in eax; `this` is only saved in a local and not read. */
uint32_t m4a9b1b_get_constant(uint8_t *self);

/* 0x4a9ea7, thiscall, plain `ret`: returns the constant 0x52de40u in eax; `this` is only saved in a local and not read. */
uint32_t m4a9ea7_get_constant(uint8_t *self);

/* 0x4aaef5, thiscall, plain `ret`: returns the constant 0x52de58u in eax; `this` is only saved in a local and not read. */
uint32_t m4aaef5_get_constant(uint8_t *self);

/* 0x4ab327, thiscall, plain `ret`: returns the constant 0x52dec8u in eax; `this` is only saved in a local and not read. */
uint32_t m4ab327_get_constant(uint8_t *self);

/* 0x4ac488, thiscall, plain `ret`: returns the constant 0x52dee0u in eax; `this` is only saved in a local and not read. */
uint32_t m4ac488_get_constant(uint8_t *self);

/* 0x4ac85a, thiscall, plain `ret`: returns the constant 0x52df50u in eax; `this` is only saved in a local and not read. */
uint32_t m4ac85a_get_constant(uint8_t *self);

/* 0x4afa0e, thiscall, plain `ret`: returns the constant 0x52df68u in eax; `this` is only saved in a local and not read. */
uint32_t m4afa0e_get_constant(uint8_t *self);

/* 0x4afcba, thiscall, plain `ret`: returns the constant 0x52dfd8u in eax; `this` is only saved in a local and not read. */
uint32_t m4afcba_get_constant(uint8_t *self);

/* 0x4afdfe, thiscall, plain `ret`: does nothing; `this` is only saved in a local (eax is not set). */
void m4afdfe_empty_method(uint8_t *self);

/* 0x4b371c, thiscall, plain `ret`: returns the constant 0x52dff0u in eax; `this` is only saved in a local and not read. */
uint32_t m4b371c_get_constant(uint8_t *self);

/* 0x4b3bda, thiscall, plain `ret`: returns the constant 0x52e060u in eax; `this` is only saved in a local and not read. */
uint32_t m4b3bda_get_constant(uint8_t *self);

/* 0x4b5838, thiscall, plain `ret`: returns the constant 0x52e078u in eax; `this` is only saved in a local and not read. */
uint32_t m4b5838_get_constant(uint8_t *self);

/* 0x4b5b0a, thiscall, plain `ret`: returns the constant 0x52e0e8u in eax; `this` is only saved in a local and not read. */
uint32_t m4b5b0a_get_constant(uint8_t *self);

/* 0x4b7041, thiscall, plain `ret`: returns the constant 0x52e100u in eax; `this` is only saved in a local and not read. */
uint32_t m4b7041_get_constant(uint8_t *self);

/* 0x4b7177, thiscall, plain `ret`: returns the constant 0x52e170u in eax; `this` is only saved in a local and not read. */
uint32_t m4b7177_get_constant(uint8_t *self);

/* 0x4b7ddd, thiscall, plain `ret`: returns the constant 0x52e188u in eax; `this` is only saved in a local and not read. */
uint32_t m4b7ddd_get_constant(uint8_t *self);

/* 0x4c0f60, thiscall, plain `ret`: returns the constant 0x52e218u in eax; `this` is only saved in a local and not read. */
uint32_t m4c0f60_get_constant(uint8_t *self);

/* 0x4cc917, thiscall, plain `ret`: returns the constant 0x52e240u in eax; `this` is only saved in a local and not read. */
uint32_t m4cc917_get_constant(uint8_t *self);

/* 0x4d3b0a, thiscall, plain `ret`: returns the constant 0x52e2d8u in eax; `this` is only saved in a local and not read. */
uint32_t m4d3b0a_get_constant(uint8_t *self);

/* 0x4d3b8a, thiscall, plain `ret`: does nothing; `this` is only saved in a local (eax is not set). */
void m4d3b8a_empty_method(uint8_t *self);

/* 0x4d3d3d, thiscall, plain `ret`: does nothing; `this` is only saved in a local (eax is not set). */
void m4d3d3d_empty_method(uint8_t *self);

/* 0x4d4192, thiscall, plain `ret`: returns the constant 0x52e2f0u in eax; `this` is only saved in a local and not read. */
uint32_t m4d4192_get_constant(uint8_t *self);

/* 0x4d51f7, thiscall, plain `ret`: returns the constant 0x52e360u in eax; `this` is only saved in a local and not read. */
uint32_t m4d51f7_get_constant(uint8_t *self);

/* 0x4d529b, thiscall, plain `ret`: does nothing; `this` is only saved in a local (eax is not set). */
void m4d529b_empty_method(uint8_t *self);

/* 0x4dbf0a, thiscall, plain `ret`: returns the constant 0x52e460u in eax; `this` is only saved in a local and not read. */
uint32_t m4dbf0a_get_constant(uint8_t *self);

/* 0x4dd3eb, thiscall, plain `ret`: does nothing; `this` is only saved in a local (eax is not set). */
void m4dd3eb_empty_method(uint8_t *self);

/* 0x4f003b, thiscall, plain `ret`: does nothing; `this` is only saved in a local (eax is not set). */
void m4f003b_empty_method(uint8_t *self);

#ifdef __cplusplus
}
#endif

#endif
