#ifndef SPIKE_MACROS_H
#define SPIKE_MACROS_H
#include "original_methods_fl41.h"
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
