#ifndef BLACKMOOR_ORIGINAL_METHODS_FL16_H
#define BLACKMOOR_ORIGINAL_METHODS_FL16_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* FL-16: small methods of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, each as its own symbol that cites the
 * original address in its leading comment. They are the getters, setters, resets, stores and thin forwarding methods that the
 * recorded oracle runs already execute completely (function-execution.json) but that no native symbol isolated, because the
 * runtime kernels inline them or work on typed structs.
 *
 * Conventions, the same for every function:
 *  - `self` is the original `this` object as raw bytes. The offsets are the original ones (each function's comment lists the
 *    ones it touches); the buffer must reach the highest offset. Nothing is bounds-checked: the originals do not check
 *    either, and the callers own the object.
 *  - Multi-byte fields are little-endian and may be unaligned, as in the original object layout.
 *  - Global variables of the original that a function reads or writes live in Fl16World (named by their address); a
 *    function that needs a value only reads it from there. Calls into original code that is not ported yet, calls into
 *    Windows (GetTickCount, BinkClose) and the surface manager go through Fl16Host, so the tests can see them, in order.
 *    A call to another function of this file is a direct call.
 *
 * Nothing here claims original source structure. */

/* The original globals the ported methods touch. */
typedef struct Fl16World {
    int32_t origin_x_583186;           /* added to the x values of the rectangle shifters */
    int32_t origin_y_58318a;           /* added to the y values of the rectangle shifters */
    uint32_t value_55cd94;             /* read by 0x4ee5cd */
    uint32_t value_583204;             /* cleared by 0x4e7757 */
    const uint8_t *deadlines_61eee1;   /* 0x61eee1: dword deadline of slot i at deadlines_61eee1 + i * 0x37 (0x4b8e42) */
    /* 0x42e560 reads these... */
    int16_t src_5bb57b, src_5bb57f, src_5bb50b, src_5bb593;
    uint32_t src_5bb5a7, src_5bb5ab, src_5bb5af;
    /* ...and writes this block: words at +0, +2, +4, +6, +8 and dwords at +0xa and +0xe (0x5c3a05..0x5c3a16). */
    uint8_t block_5c3a05[0x12];
} Fl16World;

/* The calls out of the ported methods. Every callback receives `context` first. A NULL callback is a no-op (or returns 0). */
typedef struct Fl16Host {
    void *context;
    uint32_t (*tick)(void *context);                                /* GetTickCount, import 0x52a23c */
    void (*bink_close)(void *context, uint32_t handle);             /* BinkClose, import 0x52a504 */
    void (*call_43dbd5)(void *context);                             /* 0x43dbd5 */
    void (*call_4d36ed)(void *context);                             /* 0x4d36ed */
    void (*call_4d3bef)(void *context, uint8_t *self);              /* 0x4d3bef, this = self */
    void (*call_4b8a27)(void *context, uint8_t *self, int32_t arg); /* 0x4b8a27, this = self */
    void (*call_4ccdab)(void *context, uint8_t *self);              /* 0x4ccdab, this = self */
    void (*call_4edfaf)(void *context, uint8_t *self, uint32_t arg); /* 0x4edfaf, this = self */
    /* 0x4c2dfb on the surface manager object 0x5cf659; `slot` points at the dword the caller owns (self + 0x212). */
    void (*release_surface)(void *context, uint8_t *slot);
    int32_t (*call_4fadc4)(void *context, uint8_t *self, uintptr_t arg1, uint16_t arg2); /* 0x4fadc4, this = self; arg1 is a char pointer in the original */
    void (*call_4fb2e3)(void *context, uint8_t *self, uint16_t arg);                  /* 0x4fb2e3, this = self */
} Fl16Host;

/* The vtable pointer 0x4ccd70 stores into its object. */
#define FL16_VTABLE_52E2D0 0x0052e2d0u

void m4234c8_depth_reset(uint8_t *self);
uint8_t *m423000_init_pair(uint8_t *self);
uint8_t *m423097_clear_table(uint8_t *self);
void m47d77d_noop(void);
uint32_t m4ee5cd_get_global(const Fl16World *world);
uint32_t m4f709c_get_ready(const uint8_t *self);
void m4edf96_set_value(uint8_t *self, uint32_t value);
uint32_t m493a47_zero(void);
uint32_t m434773_is_data_tag(const uint8_t *text);
uint32_t m4347b8_read_be32(const uint8_t *bytes);
void m43f04b_copy_rows(uint8_t *dst, const uint8_t *src, int32_t rows, uint32_t row_bytes, int32_t src_stride);
void m44d9b5_shift_rect(const int32_t *src, int32_t *dst, const Fl16World *world);
void m45b568_shift_rect(const int32_t *src, int32_t *dst, const Fl16World *world);
void m47e25a_reset_fields(uint8_t *self);
void m4bedb5_clear_state(uint8_t *self);
void m4bede7_clear_state(uint8_t *self);
void m4bedfa_close_and_clear(uint8_t *self, uint32_t *handle, const Fl16Host *host);
void m4bf38c_clear_2c0(uint8_t *self);
uint32_t m4c0c18_get_22a(const uint8_t *self);
uint32_t m4c0c2c_get_240(const uint8_t *self);
int32_t m4c0c54_get_244(const uint8_t *self);
uint32_t m4c0c69_get_24a(const uint8_t *self);
uint32_t m4d3c31_get_1c(const uint8_t *self);
void m4e76d5_clear_991(uint8_t *self);
void m4e76ed_clear_991(uint8_t *self);
void m4e7ba7_view_reset(uint8_t *self);
void m42e560_save_block(Fl16World *world, uint16_t value);
void m4d3d20_stamp_tick(uint8_t *self, const Fl16Host *host);
void m4b8e42_expire_slot(uint8_t *self, int16_t slot, const Fl16World *world, const Fl16Host *host);
void m4d3c42_set_flag(uint8_t *self, const Fl16Host *host);
void m4e7786_forward(uint8_t *self, uint32_t arg, const Fl16Host *host);
void m4faf98_visit(uint8_t *self, uintptr_t arg1, uint16_t arg2, const Fl16Host *host);
void m4ccfbd_release_surface(uint8_t *self, const Fl16Host *host);
uint8_t *m4ccd70_construct(uint8_t *self, const Fl16Host *host);
void m4e7728_open(uint8_t *self, uint32_t value, const Fl16Host *host);
void m4e7757_close(uint8_t *self, const Fl16Host *host, Fl16World *world);

#ifdef __cplusplus
}
#endif

#endif
