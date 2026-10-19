#ifndef BLACKMOOR_ORIGINAL_METHODS_FL20A_H
#define BLACKMOOR_ORIGINAL_METHODS_FL20A_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-20 (batch a): more functions of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-18 and FL-19 (see
 * original_methods_fl18.h, whose Fl18Host is reused unchanged, and original_methods_fl19b.h): each is its own symbol that cites the
 * original address in its leading comment, `self` is the original `this` object as raw bytes at the original offsets, nothing is
 * bounds-checked, and the effects keep the order of the original.
 *
 * Calls into original code (also into functions that are ported in this batch: the port stays one to one) go through Fl18Host.call
 * (callee address, ecx value, stack arguments with args[0] the LAST one pushed). A stack argument the original pushed from a 16-bit
 * register is a "word": only its low 16 bits are meaningful. A pointer that the original passes to a callee is a host pointer: of an
 * object field (self + n), or of one of the function's own stack arguments (the four sibling methods 0x43ec4a, 0x43ec85, 0x43ecc0 and
 * 0x43ed71, which pass the addresses of their first two stack arguments, three consecutive dwords, to the callee). A 32-bit original
 * address that the function reads through goes through Fl18Host.resolve. GetTickCount (0x52a23c) is Fl18Host.tick.
 *
 * Nothing here claims original source structure. */

/* The globals and tables of the original that the batch touches (named by their address). A table pointer points at the byte that the
 * original address names; the index of the record table is a signed word and the caller leaves slack below it. */
typedef struct Fl20aWorld {
    uint8_t *records_5bb5e5;       /* dwords of stride 0x8d: address of the object of record n; record +0x4d (0x5bb632) is used in place */
    int32_t origin_x_583186, origin_y_58318a, corner_x_58318e, corner_y_583192;
    int16_t word_585d51, word_585d4f, word_5b0280;
    uint32_t value_585d4b, value_585d55;
    uint8_t byte_61c6ad;
} Fl20aWorld;

void m4d3c88_clear_flag(Fl20aWorld *world);
void m4d3c5f_set_ready(uint8_t *self, const Fl18Host *host);
void m41c509_init_fields(uint8_t *arg);
void m43ec4a_forward_4db000(uintptr_t self, uint32_t first, uint32_t second, uint32_t third, const Fl18Host *host);
void m43ec85_forward_4dafc3(uintptr_t self, uint32_t first, uint32_t second, uint32_t third, const Fl18Host *host);
void m43ecc0_forward_4db04f(uintptr_t self, uint32_t first, uint32_t second, uint32_t third, const Fl18Host *host);
void m43ed71_forward_4daf9f(uintptr_t self, uint32_t first, uint32_t second, uint32_t third, const Fl18Host *host);
void m475885_release(uint8_t *self, const Fl18Host *host);
void m4caf03_reset(uint8_t *self);
void m41c770_init_fields(uint8_t *arg);
void m4757da_clear_grid(uint8_t *self);
void m48bb86_release(uint8_t *self, const Fl18Host *host);
void m483fb5_release_all(uint8_t *self, const Fl18Host *host);
int32_t m4343a2_find_name(uint8_t *self, const uint8_t *name, const Fl18Host *host);
void m44727a_start_record(uint8_t *self, int16_t index, const Fl20aWorld *world, const Fl18Host *host);
void m42b87a_apply_record(int16_t index, Fl20aWorld *world, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
