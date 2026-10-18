#ifndef BLACKMOOR_ORIGINAL_METHODS_FL18_H
#define BLACKMOOR_ORIGINAL_METHODS_FL18_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl17.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-18: more methods of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-16 and FL-17 (see
 * original_methods_fl16.h and original_methods_fl17.h): each is its own symbol that cites the original address in its leading
 * comment, `self` is the original `this` object as raw bytes at the original offsets, and nothing is bounds-checked.
 *
 * What is new here:
 *  - Calls into original code that is not ported yet, the CRT and the surface managers go through ONE callback, Fl18Host.call,
 *    instead of one typed callback per callee: `callee` is the original address, `this_ptr` is the value of ecx at the call (0
 *    for a cdecl or stdcall callee), `args[0..nargs-1]` are the stack arguments as the callee sees them (args[0] is the value at
 *    [esp+4] on entry, i.e. the LAST one pushed). A value is a 32-bit original value (a dword, or a word that the original
 *    pushed in a 32-bit register: only its low 16 bits are meaningful where the comment says "word") or, for an address of
 *    memory that this module owns (an object, a record, a local), a host pointer cast to uintptr_t. The singleton objects and the
 *    tables of the original that the callee reaches itself are passed by their original address (0x5cf659, 0x5c3a67, 0x5cf1eb,
 *    0x570508, 0x5a4c24 + n * 0x7f3, ...). The return value is eax. A NULL `call` returns 0.
 *  - A dword inside an object or record that holds an address of the original is read as a dword; Fl18Host.resolve turns it
 *    into host memory when the function has to read through it.
 *  - Functions of FL-17 that these ones call (0x4b7f3b) are called directly.
 *
 * Nothing here claims original source structure. */

/* The original globals and tables the ported methods touch (named by their address). A table pointer points at the byte that the
 * original address names; for a table that a signed index addresses the caller leaves slack below it. */
typedef struct Fl18World {
    uint8_t *records_5bb5e5;     /* records of stride 0x8d */
    uint8_t *words_5afbda;       /* words, indexed by a signed word (0x4c924d) */
    uint8_t *dwords_5d032f;      /* dwords, indexed by a signed word (0x4c924d) */
    uint32_t value_5cf665;       /* read by 0x4b7051, 0x4cc79a */
    int16_t word_61d467;         /* 0x4b7051: record index */
    int16_t word_61d465;         /* 0x4b7051: index of the dword table at 0x5d1599 (stride 0x4a) */
    const uint8_t *table_5d1599; /* dwords of stride 0x4a, indexed by the signed word 0x61d465 */
    uint8_t *table_5a1e62;       /* records of 0x29 bytes (0x4e7253) */
    uint16_t word_5a1e5c;        /* count of the records at 0x5a1e62 (0x4e7253) */
    uint32_t value_5c39e5, value_5d0377, value_5d162d, value_5b44f0, value_5b44f4, value_5d1631, value_5d1639;
    uint32_t value_638483;       /* 0x4cc79a: cleared */
    uint32_t value_63848d;       /* 0x4cc79a: address of the list object */
    int32_t origin_x_583186, origin_y_58318a;
    uint32_t value_5bb1ca;       /* 0x44d624, 0x4631d1 */
    const uint8_t *bytes_5495b0; /* the nine bytes at 0x5495b0 (0x44d624) and ... */
    const uint8_t *bytes_54b158; /* ...at 0x54b158 (0x4631d1) that those functions compare a record field with */
    uint8_t *flags_585801;       /* the dword table at 0x585801, indexed by a signed word (0x4c0774) */
    uint32_t value_5d19fb, value_5839a9, value_5c39f9, value_5bb57b, value_5bb59b, value_5bb59f, value_5bb5a3, value_583999;
    uint16_t word_5bb599, word_5bb595, word_5c39ff;  /* 0x4c0774 writes these globals */
    int16_t word_5b61b0;         /* 0x4d07e7: index of the record */
    uint32_t value_5d15e3;
    uint16_t word_5b61dd, word_5b61d1, word_5b61e1, word_5b61ed;
    const uint8_t *string_5b618e; /* the zero-terminated string at 0x5b618e (0x4d07e7 tests whether it is empty) */
} Fl18World;

typedef struct Fl18Host {
    void *context;
    uint32_t (*call)(void *context, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs);
    /* host memory behind an original 32-bit address stored in an object or record */
    const uint8_t *(*resolve)(void *context, uint32_t address);
    uint32_t (*tick)(void *context); /* GetTickCount, import 0x52a23c */
} Fl18Host;

void m4c924d_count_up(int16_t index, const Fl18World *world, const Fl18Host *host);
void m4121b8_start_piece(uint8_t *self, int16_t index, const Fl18World *world, const Fl18Host *host);
void m4e7bf3_close_slots(uint8_t *self, const Fl18Host *host);
void m4b7051_draw_list(const Fl18World *world, const Fl18Host *host);
void m4b7f3b_reset(uint8_t *self);
void m4b7ff4_release(uint8_t *self, const Fl18Host *host);
void m4e7253_store_record(uint8_t *self, int16_t index, Fl18World *world, const Fl18Host *host);
void m4e8dc8_check_slots(uint8_t *self, const Fl18Host *host);
void m45b7a8_arm_hotspot(uint8_t *self, int16_t a, int16_t b, Fl18World *world);
int32_t m4b81ff_hit_test(uint8_t *self, int16_t x, int16_t y, Fl18World *world, const Fl18Host *host);
void m423b51_reset_record(uint8_t *self, int32_t index, const Fl18World *world, const Fl18Host *host);
void m4cc79a_draw_rects(Fl18World *world, const Fl18Host *host);
void m4b6097_arm_hotspot(uint8_t *self, int16_t a, int16_t b, Fl18World *world);
void m4b8d5e_expire_slots(uint8_t *self, const Fl18Host *host);
void m410f99_init_entry(uint8_t *dst, const uint8_t *src, int16_t a, uint8_t b);
void m44d624_arm_timer(uint8_t *self, const Fl18World *world, const Fl18Host *host);
void m4631d1_check_piece(uint8_t *self, const Fl18World *world, const Fl18Host *host);
void m41632b_free_buffers(uint8_t *arg, const Fl18Host *host);
void m4c08d3_shift_rects(uint8_t *self, const Fl18World *world, const Fl18Host *host);
void m4c0774_open_piece(uint8_t *self, int16_t a, Fl18World *world, const Fl18Host *host);
void m4d07e7_draw_texts(const Fl18World *world, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
