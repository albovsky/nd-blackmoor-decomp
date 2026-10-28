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
#endif
