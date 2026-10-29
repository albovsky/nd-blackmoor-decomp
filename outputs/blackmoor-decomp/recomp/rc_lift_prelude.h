/* Every generated rc_lifted_NN.c starts with this: the FL41 lifter's header, the x87 helpers, and the host's inline memory access in place of
 * the call through the Fl41Host table (the same loads and stores, without an indirect call). */
#ifndef RC_LIFT_PRELUDE_H
#define RC_LIFT_PRELUDE_H
#include "original_methods_fl41.h"
#include "original_methods_fl41_x87.h"
#include "rc_fl57_helpers.h"
#include "rc.h"

#undef RD8
#undef RD16
#undef RD32
#undef WR8
#undef WR16
#undef WR32
#define RD8(a) rc_rd((a), 1)
#define RD16(a) rc_rd((a), 2)
#define RD32(a) rc_rd((a), 4)
#define WR8(a, v) rc_wr((a), 1, (v))
#define WR16(a, v) rc_wr((a), 2, (v))
#define WR32(a, v) rc_wr((a), 4, (v))

/* a tail jump out of a function: the target runs on the same stack and its return is this function's return */
void host_tailjump(uint32_t target, Fl41Regs *regs);
#define FL41_TAILJMP(target)                                                                        \
    do {                                                                                            \
        Fl41Regs rr_ = {eax, ecx, edx, ebx, esp, ebp, esi, edi};                                    \
        host_tailjump((target), &rr_);                                                              \
        eax = rr_.eax; ecx = rr_.ecx; edx = rr_.edx; esp = rr_.esp;                                 \
        goto done;                                                                                  \
    } while (0)
/* a call through a register or pointer: the callee's `ret N` decides the stack; a host-played import leaves esp alone, so it gets the lifter's guess */
#define FL41_ICALL(target, guess)                                                                   \
    do {                                                                                            \
        Fl41Regs rr_ = {eax, ecx, edx, ebx, esp, ebp, esi, edi};                                    \
        uint32_t e0_ = esp;                                                                         \
        h->call(h->ctx, (target), &rr_);                                                            \
        eax = rr_.eax; ecx = rr_.ecx; edx = rr_.edx;                                                \
        if (rr_.esp == 0xfffffff0u) goto done;                                                      \
        esp = (rr_.esp == e0_) ? e0_ + 4u + (guess) : rr_.esp;                                      \
    } while (0)
#endif
