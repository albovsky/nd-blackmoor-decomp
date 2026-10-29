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
/* Hosts without the x87 (arm64 macOS, where long double is double): the same operations over libm. Results are not bit-exact with the x87's
 * 64-bit mantissa; the rounding control in the control word is honoured. */
#include <math.h>
static inline long double fl57_round_cw(const Fl41Fpu *f, long double a)
{
    switch ((f->cw >> 10) & 3u) {
    case 1: return floorl(a);
    case 2: return ceill(a);
    case 3: return truncl(a);
    default: return nearbyintl(a);       /* ties to even, as the default control word */
    }
}
static inline long double fl57_frndint(Fl41Fpu *f, long double a) { return fl57_round_cw(f, a); }
static inline long double fl57_fsqrt(Fl41Fpu *f, long double a) { (void)f; return sqrtl(a); }
static inline long double fl57_fabs(Fl41Fpu *f, long double a) { (void)f; return fabsl(a); }
static inline long double fl57_fsin(Fl41Fpu *f, long double a) { f->sw = (uint16_t)(f->sw & ~0x0400u); return sinl(a); }
static inline long double fl57_fcos(Fl41Fpu *f, long double a) { f->sw = (uint16_t)(f->sw & ~0x0400u); return cosl(a); }
static inline long double fl57_f2xm1(Fl41Fpu *f, long double a) { (void)f; return expm1l(a * (long double)M_LN2); }
static inline long double fl57_fprem(Fl41Fpu *f, long double a, long double b) { f->sw = (uint16_t)(f->sw & ~0x4700u); return fmodl(a, b); }
static inline long double fl57_fprem1(Fl41Fpu *f, long double a, long double b) { f->sw = (uint16_t)(f->sw & ~0x4700u); return remainderl(a, b); }
static inline long double fl57_fpatan(Fl41Fpu *f, long double a, long double b) { (void)f; return atan2l(b, a); }
static inline long double fl57_fyl2x(Fl41Fpu *f, long double a, long double b) { (void)f; return b * log2l(a); }
static inline long double fl57_fscale(Fl41Fpu *f, long double a, long double b) { (void)f; return ldexpl(a, (int)truncl(b)); }
static inline void fl57_fxam(Fl41Fpu *f, long double a)
{
    uint16_t c = 0;
    switch (fpclassify(a)) {
    case FP_NAN: c = 0x0100; break;
    case FP_NORMAL: c = 0x0400; break;
    case FP_INFINITE: c = 0x0500; break;
    case FP_ZERO: c = 0x4000; break;
    default: c = 0x4400; break;          /* denormal */
    }
    if (signbit(a)) c |= 0x0200;
    f->sw = (uint16_t)((f->sw & ~0x4700u) | c);
}
/* fist/fistp: round by the control word; an unrepresentable value stores the integer indefinite (the most negative value) */
static inline uint64_t fl57_fist(Fl41Fpu *f, long double v, int bytes)
{
    long double r = fl57_round_cw(f, v);
    if (bytes == 2) return (isnan(r) || r < -32768.0L || r > 32767.0L) ? 0x8000u : (uint16_t)(int16_t)r;
    if (bytes == 4) return (isnan(r) || r < -2147483648.0L || r > 2147483647.0L) ? 0x80000000u : (uint32_t)(int32_t)r;
    return (isnan(r) || r < -9223372036854775808.0L || r >= 9223372036854775808.0L) ? 0x8000000000000000ull : (uint64_t)(int64_t)r;
}
#endif
#endif
