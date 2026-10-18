#ifndef BLACKMOOR_ORIGINAL_METHODS_FL17_H
#define BLACKMOOR_ORIGINAL_METHODS_FL17_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl16.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-17: more small methods of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-16
 * (original_methods_fl16.h): each is its own symbol that cites the original address in its leading comment, `self` is the
 * original `this` object as raw bytes at the original offsets, and nothing is bounds-checked.
 *
 * What is new here:
 *  - A dword inside an object or record that holds a pointer is an original 32-bit address. The functions read it as a dword
 *    and, where they need the object it points to, ask Fl17Host.resolve for the host memory behind that address.
 *  - A global of the original that holds a pointer is a native pointer in Fl17World (the world is not an original image).
 *  - Functions of FL-16 that these ones call (0x4ccfbd, 0x4d3c31, 0x4d3d20) are called directly, through Fl17Host.fl16.
 *  - Other calls into original code that is not ported yet, the heap and Windows calls (UnmapViewOfFile, CloseHandle) and the
 *    surface manager go through Fl17Host callbacks, so the tests can see them in order.
 *
 *  - Required host fields: `fl16` (0x4cd218, 0x44d107, 0x44d154) and `resolve` (0x424035, 0x48c0ac, 0x4eac4c) must be set when those
 *    functions run; they are dereferenced without a check. The other callbacks follow the NULL-is-a-no-op convention.
 *  - World memory is separate from the object images, so an index that is negative in the original (0x48c0ac and 0x4eac4c take
 *    record -1 after a reset; 0x42ca22 may index the table at 0x585801 below its start) needs slack before the array in the buffer
 *    the caller supplies; a negative index in the original can also land on another global, which this model does not mirror.
 * Nothing here claims original source structure. */

/* The original globals the ported methods touch (named by their address). */
typedef struct Fl17World {
    uint32_t value_583204;       /* cleared by 0x4e303b, 0x4e7d04, 0x4eb96e */
    uint32_t value_5831c8;       /* := 1 by 0x4d36ed */
    uint16_t value_5831c6;       /* := 0 by 0x4d36ed */
    uint32_t value_5bb22a;       /* cleared by 0x4e303b */
    uint32_t slot_5d039f;        /* released through the surface manager by 0x4e303b when non-zero */
    uint32_t slot_5d03a3;        /* same, by 0x4eb96e */
    uint32_t slot_5d03a7;        /* same, by 0x4eb96e */
    uint16_t value_5b451f;       /* read by 0x4fc05d */
    uint32_t value_5c39e5;       /* read by 0x48c0ac */
    int16_t value_583a29;        /* compared with, and possibly := 0xffff by, 0x4eac4c */
    uint8_t *records_5bb5e5;     /* the records of stride 0x8d whose first dword lies at 0x5bb5e5 (0x48c0ac, 0x4eac4c) */
    const uint8_t *table_5b4ea5; /* dword at 0x5b4ea5: the 6-byte records read by 0x42ca22 */
    const uint8_t *owner_5b4ead; /* dword at 0x5b4ead: the object whose word +0x6d is the record count */
    int16_t key_5b4e00;          /* word at 0x5b4e00, compared with the first word of each record */
    uint8_t *flags_585801;       /* the dword table at 0x585801 that 0x42ca22 fills (index = a signed word, so it may be negative) */
    uint32_t value_638433;       /* 0x4cf749 */
    uint32_t value_638423;
    uint32_t value_5d1a39, value_5cf665, value_5d1a3d, value_5d1a41;
    uint8_t block_5a0545[0x18];  /* dword 0x5a0545 and the five dwords at 0x5a0549 (0x47591f) */
    uint8_t *object_61c387;      /* the object at 0x61c387 (0x44d107 calls 0x4d3c31 and 0x4d3d20 on it) */
} Fl17World;

/* The calls out of the ported methods. Every callback receives `context` first. A NULL callback is a no-op (or returns 0). */
typedef struct Fl17Host {
    void *context;
    const Fl16Host *fl16;  /* the host of the FL-16 methods that these ones call directly */
    /* host memory behind an original 32-bit address stored in an object or record */
    const uint8_t *(*resolve)(void *context, uint32_t address);
    /* 0x4c2dfb on the surface manager object 0x5cf659; `slot` points at the dword the caller owns */
    void (*release_surface)(void *context, uint8_t *slot);
    void (*call_4edb97)(void *context, uint8_t *self);                      /* this = self */
    void (*call_4e2faa)(void *context, uint8_t *self);
    void (*call_4e7bf3)(void *context, uint8_t *self);
    void (*call_4eba54)(void *context, uint8_t *self);
    void (*call_4ccef1)(void *context, uint8_t *self);
    void (*call_4ccff5)(void *context, uint8_t *self);
    void (*call_4ccdab)(void *context, uint8_t *self);
    void (*call_4cbb00)(void *context, uint8_t *self);
    void (*call_4caf03)(void *context, uint8_t *self);
    void (*call_4fc808)(void *context, uint8_t *self, uint16_t value);      /* this = self; the pushed dword is read as a word */
    void (*call_4ea06c)(void *context, uint8_t *self, uint16_t value);
    void (*call_4d3992)(void *context, uint16_t value);                     /* cdecl */
    /* 0x4c5377 on the object 0x5cf659 with five stack arguments (callee cleans up), first argument first */
    void (*call_4c5377)(void *context, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5);
    void (*free_51dc6c)(void *context, uint32_t address);                   /* 0x51dc6c (the C free), cdecl */
    void (*unmap_view)(void *context, uint32_t address);                    /* import 0x52a2b4, UnmapViewOfFile */
    void (*close_handle)(void *context, uint32_t handle);                   /* import 0x52a2b8, CloseHandle */
} Fl17Host;

int32_t m424035_selected_slot(const uint8_t *arg, const Fl17Host *host);
uint32_t m42405a_get_control(const uint8_t *arg);
void m42ca22_apply_event_flags(const Fl17World *world);
void m4d36ed_set_flags(Fl17World *world);
void m4cd218_destruct(uint8_t *self, const Fl17Host *host);
void m4fba69_forward_word(uint8_t *self, const uint8_t *arg, const Fl17Host *host);
void m4fc05d_forward_global(uint8_t *self, const Fl17World *world, const Fl17Host *host);
void m4e303b_close(uint8_t *self, Fl17World *world, const Fl17Host *host);
void m4e7d04_close(uint8_t *self, Fl17World *world, const Fl17Host *host);
void m4eb96e_close(uint8_t *self, Fl17World *world, const Fl17Host *host);
void m4caf8a_reset(uint8_t *self, const Fl17Host *host);
void m4cf749_notify(const Fl17World *world, const Fl17Host *host);
void m48c0ac_accept_piece(uint8_t *self, const Fl17World *world, const Fl17Host *host);
void m415011_close_handles(uint8_t *arg, const Fl17Host *host);
void m4eac4c_use_item(uint8_t *self, int16_t index, Fl17World *world, const Fl17Host *host);
void m48d067_cleanup(uint8_t *self);
void m461827_cleanup(uint8_t *self);
void m4b5b8a_cleanup(uint8_t *self);
void m45b3ea_cleanup(uint8_t *self);
void m483f6a_cleanup(uint8_t *self);
void m44d107_cleanup(uint8_t *self, const Fl17World *world, const Fl17Host *host);
void m44d154_begin_scene(uint8_t *self, const Fl17World *world, const Fl17Host *host);
void m45b42e_begin_scene(uint8_t *self, const Fl17Host *host);
void m461862_begin_scene(uint8_t *self, const Fl17Host *host);
void m48d09c_begin_scene(uint8_t *self, const Fl17Host *host);
void m4b5bc8_begin_scene(uint8_t *self, const Fl17Host *host);
void m47591f_clear_block(Fl17World *world);

#ifdef __cplusplus
}
#endif

#endif
