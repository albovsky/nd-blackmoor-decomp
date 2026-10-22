#ifndef BLACKMOOR_ORIGINAL_METHODS_FL41_H
#define BLACKMOOR_ORIGINAL_METHODS_FL41_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* FL-41: GAME.EXE functions below 0x480000 translated instruction by instruction (scripts/lift_fl41.py) into C over the original 32-bit address space.
 * Every symbol `m<va>_lifted` is the original function at <va>: the eight registers and the arithmetic flags are locals, each memory access (the stack
 * included) goes through the host at the original 32-bit address, and each direct call pushes its return address and goes through `call`, which plays the
 * callee (it reads the arguments from the stack at regs->esp + 4 and returns the callee's eax and clobbers ecx and edx (ebx, esi, edi and ebp are kept); the stack cleanup of the callee
 * is already in the translation). The function is entered with regs->esp pointing at the return address, as the original is, and leaves with regs->esp
 * after its own `ret`. Nothing here names or restructures the original; the translation is only credited after tests/fl41_world.py (original-only oracle,
 * differential test, mutation check). The direction flag is assumed clear; AF is not modelled (no translated instruction reads it). */

typedef struct Fl41Regs {
    uint32_t eax, ecx, edx, ebx, esp, ebp, esi, edi;
} Fl41Regs;

typedef struct Fl41Host {
    void *ctx;
    uint32_t (*rd)(void *ctx, uint32_t address, int bytes);
    void (*wr)(void *ctx, uint32_t address, int bytes, uint32_t value);
    void (*call)(void *ctx, uint32_t callee, Fl41Regs *regs);
} Fl41Host;

#define FL41_PROLOGUE                                                                                                                          \
    uint32_t eax = r->eax, ecx = r->ecx, edx = r->edx, ebx = r->ebx, esp = r->esp, ebp = r->ebp, esi = r->esi, edi = r->edi;                    \
    uint32_t cf = 0u, zf = 0u, sf = 0u, of = 0u, pf = 0u;                                                                                      \
    (void)cf; (void)zf; (void)sf; (void)of; (void)pf; (void)ebx; (void)ebp; (void)esi; (void)edi;
#define FL41_EPILOGUE                                                                                                                          \
    r->eax = eax; r->ecx = ecx; r->edx = edx; r->ebx = ebx; r->esp = esp; r->ebp = ebp; r->esi = esi; r->edi = edi;

#define RD8(a) h->rd(h->ctx, (a), 1)
#define RD16(a) h->rd(h->ctx, (a), 2)
#define RD32(a) h->rd(h->ctx, (a), 4)
#define WR8(a, v) h->wr(h->ctx, (a), 1, (v))
#define WR16(a, v) h->wr(h->ctx, (a), 2, (v))
#define WR32(a, v) h->wr(h->ctx, (a), 4, (v))

#define FL41_CALL(target)                                                                                                                      \
    do {                                                                                                                                       \
        Fl41Regs rr_ = {eax, ecx, edx, ebx, esp, ebp, esi, edi};                                                                               \
        h->call(h->ctx, (target), &rr_);                                                                                                       \
        eax = rr_.eax; ecx = rr_.ecx; edx = rr_.edx;                                                                                                       \
    } while (0)

/* the address the thread information block (fs:[0]) has in the model, and the divide error: the host sees a call to 0xffffffff and the function stops */
#define FL41_TIB 0x7d000000u
#define FL41_TRAP                                                                                                                              \
    do {                                                                                                                                       \
        Fl41Regs rr_ = {eax, ecx, edx, ebx, esp, ebp, esi, edi};                                                                               \
        h->call(h->ctx, 0xffffffffu, &rr_);                                                                                                    \
        goto done;                                                                                                                             \
    } while (0)

/* a callee that is translated as well (the stack probe `__chkstk`, which takes its size in eax and lowers esp): run natively on the registers */
#define FL41_CALL_LIFTED(fn)                                                                                                                   \
    do {                                                                                                                                       \
        Fl41Regs rr_ = {eax, ecx, edx, ebx, esp, ebp, esi, edi};                                                                               \
        fn(&rr_, h);                                                                                                                           \
        eax = rr_.eax; ecx = rr_.ecx; edx = rr_.edx; ebx = rr_.ebx; esp = rr_.esp; ebp = rr_.ebp; esi = rr_.esi; edi = rr_.edi;                  \
    } while (0)

void m50c920_lifted(Fl41Regs *r, const Fl41Host *h);

#define FL41_MASK(bits) ((bits) == 32 ? 0xffffffffu : ((1u << (bits)) - 1u))
static inline uint32_t fl41_parity(uint32_t v)
{
    v &= 0xffu;
    v ^= v >> 4;
    v ^= v >> 2;
    v ^= v >> 1;
    return ~v & 1u;
}
#define FL41_ZSP(res, bits) (zf = ((res) == 0u), sf = (((res) >> ((bits) - 1)) & 1u), pf = fl41_parity(res))
#define FL41_LOGIC(res, bits) (cf = 0u, of = 0u, FL41_ZSP(res, bits))
#define FL41_ADD(a, b, c, res, bits)                                                                                                           \
    do {                                                                                                                                       \
        uint64_t w_ = (uint64_t)(a) + (b) + (c);                                                                                               \
        res = (uint32_t)w_ & FL41_MASK(bits);                                                                                                  \
        cf = (uint32_t)((w_ >> (bits)) & 1u);                                                                                                  \
        of = ((~((a) ^ (b)) & ((a) ^ res)) >> ((bits) - 1)) & 1u;                                                                              \
        FL41_ZSP(res, bits);                                                                                                                   \
    } while (0)
#define FL41_SUB(a, b, c, res, bits)                                                                                                           \
    do {                                                                                                                                       \
        res = ((a) - (b) - (c)) & FL41_MASK(bits);                                                                                             \
        cf = ((uint64_t)(a) < (uint64_t)(b) + (c));                                                                                            \
        of = ((((a) ^ (b)) & ((a) ^ res)) >> ((bits) - 1)) & 1u;                                                                               \
        FL41_ZSP(res, bits);                                                                                                                   \
    } while (0)
/* shifts and rotates by n (1..31): the result goes to res; the flags follow the unit the tests run the original on */
#define FL41_SHL(res, a, n, bits)                                                                                                              \
    do {                                                                                                                                       \
        uint32_t t_ = (uint32_t)((uint64_t)(a) << ((n) - 1)) & FL41_MASK(bits);                                                                 \
        res = (t_ << 1) & FL41_MASK(bits);                                                                                                     \
        cf = (t_ >> ((bits) - 1)) & 1u;                                                                                                        \
        of = ((t_ ^ res) >> ((bits) - 1)) & 1u;                                                                                                \
        FL41_ZSP(res, bits);                                                                                                                   \
    } while (0)
#define FL41_SHR(res, a, n, bits)                                                                                                              \
    do {                                                                                                                                       \
        uint32_t t_ = (uint32_t)(a) >> ((n) - 1);                                                                                              \
        res = t_ >> 1;                                                                                                                         \
        cf = t_ & 1u;                                                                                                                          \
        of = ((t_ ^ res) >> ((bits) - 1)) & 1u;                                                                                                \
        FL41_ZSP(res, bits);                                                                                                                   \
    } while (0)
#define FL41_SAR(res, a, n, bits)                                                                                                              \
    do {                                                                                                                                       \
        int32_t s_ = (int32_t)((uint32_t)(a) << (32 - (bits))) >> (32 - (bits));                                                               \
        int32_t t_ = s_ >> ((n) - 1);                                                                                                          \
        res = (uint32_t)(t_ >> 1) & FL41_MASK(bits);                                                                                           \
        cf = (uint32_t)t_ & 1u;                                                                                                                \
        of = 0u;                                                                                                                               \
        FL41_ZSP(res, bits);                                                                                                                   \
    } while (0)
#define FL41_ROL(res, a, n, bits)                                                                                                              \
    do {                                                                                                                                       \
        uint32_t k_ = (n) % (bits);                                                                                                            \
        res = k_ ? (((a) << k_) | ((a) >> ((bits) - k_))) & FL41_MASK(bits) : (a);                                                             \
        cf = res & 1u;                                                                                                                         \
        of = (((a) ^ res) >> ((bits) - 1)) & 1u;                                                                                               \
    } while (0)
#define FL41_ROR(res, a, n, bits)                                                                                                              \
    do {                                                                                                                                       \
        uint32_t k_ = (n) % (bits);                                                                                                            \
        res = k_ ? (((a) >> k_) | ((a) << ((bits) - k_))) & FL41_MASK(bits) : (a);                                                             \
        cf = (res >> ((bits) - 1)) & 1u;                                                                                                       \
        of = ((res ^ (res << 1)) >> ((bits) - 1)) & 1u;                                                                                        \
    } while (0)

#ifdef __cplusplus
}
#endif

#endif
