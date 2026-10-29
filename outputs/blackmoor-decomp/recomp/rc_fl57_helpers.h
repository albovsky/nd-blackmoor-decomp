#ifndef RC_FL57_HELPERS_H
#define RC_FL57_HELPERS_H
#include "original_methods_fl41_x87.h"
#if FL41_X87_EXACT
#define FL57_UNARY(NAME, INSN)                                                                                                                 \
    static inline long double NAME(Fl41Fpu *f, long double a)                                                                                  \
    {                                                                                                                                          \
        long double r;                                                                                                                         \
        uint16_t s;                                                                                                                            \
        __asm__ volatile("fldcw %3\n\tfldt %2\n\tfnclex\n\t" INSN "\n\tfnstsw %1\n\tfstpt %0" : "=m"(r), "=m"(s) : "m"(a), "m"(f->cw) : "st", "cc");     \
        f->sw = (uint16_t)((f->sw & ~0x0400u) | (s & 0x0400u));                                                                                 \
        return r;                                                                                                                              \
    }
FL57_UNARY(fl57_frndint, "frndint")
FL57_UNARY(fl57_fsqrt, "fsqrt")
FL57_UNARY(fl57_fabs, "fabs")
FL57_UNARY(fl57_fsin, "fsin")
FL57_UNARY(fl57_fcos, "fcos")
FL57_UNARY(fl57_f2xm1, "f2xm1")
/* a (st(0)) and b (st(1)) in, the result in st(0) after the operation: fprem and fprem1 leave the remainder, fpatan atan2(b, a) and fyl2x b * log2(a) (both pop), fscale a * 2^trunc(b) */
#define FL57_BINARY(NAME, INSN, CLEANUP)                                                                                                       \
    static inline long double NAME(Fl41Fpu *f, long double a, long double b)                                                                    \
    {                                                                                                                                          \
        long double r;                                                                                                                         \
        uint16_t s;                                                                                                                            \
        __asm__ volatile("fldcw %4\n\tfldt %3\n\tfldt %2\n\tfnclex\n\t" INSN "\n\tfnstsw %1\n\tfstpt %0" CLEANUP : "=m"(r), "=m"(s) : "m"(a), "m"(b), "m"(f->cw) : "st", "st(1)", "cc"); \
        f->sw = (uint16_t)((f->sw & ~0x4700u) | (s & 0x4700u));                                                                                \
        return r;                                                                                                                              \
    }
/* fprem, fprem1 and fscale leave a second value on the host stack (st(1)) that is dropped; fpatan and fyl2x pop it themselves */
FL57_BINARY(fl57_fprem, "fprem", "\n\tfstp %%st(0)")
FL57_BINARY(fl57_fprem1, "fprem1", "\n\tfstp %%st(0)")
FL57_BINARY(fl57_fpatan, "fpatan", "")
FL57_BINARY(fl57_fyl2x, "fyl2x", "")
FL57_BINARY(fl57_fscale, "fscale", "\n\tfstp %%st(0)")
static inline void fl57_fxam(Fl41Fpu *f, long double a)
{
    uint16_t s;
    __asm__ volatile("fldt %1\n\tfxam\n\tfnstsw %0\n\tfstp %%st(0)" : "=m"(s) : "m"(a) : "st", "cc");
    f->sw = (uint16_t)((f->sw & ~0x4700u) | (s & 0x4700u));
}
static inline uint64_t fl57_fist(Fl41Fpu *f, long double v, int bytes)
{
    uint64_t r = 0;
    uint16_t s;
    if (bytes == 2) { int16_t x; __asm__ volatile("fldcw %3\n\tfldt %2\n\tfnclex\n\tfistps %0\n\tfnstsw %1" : "=m"(x), "=m"(s) : "m"(v), "m"(f->cw) : "st", "cc"); r = (uint16_t)x; }
    else if (bytes == 4) { int32_t x; __asm__ volatile("fldcw %3\n\tfldt %2\n\tfnclex\n\tfistpl %0\n\tfnstsw %1" : "=m"(x), "=m"(s) : "m"(v), "m"(f->cw) : "st", "cc"); r = (uint32_t)x; }
    else { int64_t x; __asm__ volatile("fldcw %3\n\tfldt %2\n\tfnclex\n\tfistpll %0\n\tfnstsw %1" : "=m"(x), "=m"(s) : "m"(v), "m"(f->cw) : "st", "cc"); r = (uint64_t)x; }
    (void)s;
    return r;
}
#else
#include "original_methods_fl57_portable.h"
#endif
#endif
