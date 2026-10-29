#ifndef BLACKMOOR_ORIGINAL_METHODS_FL57_PORTABLE_H
#define BLACKMOOR_ORIGINAL_METHODS_FL57_PORTABLE_H
/* The x87 transcendental and rounding steps of the translated code on a host without an x87 unit (arm64 macOS: `long double` is a plain double).
 * They follow the instruction semantics through libm: the rounding control of the model's control word picks frndint's and fist's rounding, the
 * condition codes C0..C3 that the instructions set are written to the status word. The results are not bit-exact against the 80-bit hardware (they are
 * rounded to the host's `long double`), which is the precision the rest of the portable model works at. */
#include <math.h>
#include "original_methods_fl41_x87.h"

static inline long double fl57_round(const Fl41Fpu *f, long double a)
{
    switch ((f->cw >> 10) & 3) {
    case 1: return floorl(a);
    case 2: return ceill(a);
    case 3: return truncl(a);
    default: return rintl(a);               /* nearest, ties to even (the host's default rounding mode) */
    }
}
static inline long double fl57_frndint(Fl41Fpu *f, long double a) { return fl57_round(f, a); }
static inline long double fl57_fsqrt(Fl41Fpu *f, long double a) { (void)f; return sqrtl(a); }
static inline long double fl57_fabs(Fl41Fpu *f, long double a) { (void)f; return fabsl(a); }
static inline long double fl57_fsin(Fl41Fpu *f, long double a)
{
    if (!(fabsl(a) < 9.2233720368547758e18L)) { f->sw |= 0x0400u; return a; }       /* out of range: C2 set, st(0) unchanged */
    f->sw &= (uint16_t)~0x0400u;
    return sinl(a);
}
static inline long double fl57_fcos(Fl41Fpu *f, long double a)
{
    if (!(fabsl(a) < 9.2233720368547758e18L)) { f->sw |= 0x0400u; return a; }
    f->sw &= (uint16_t)~0x0400u;
    return cosl(a);
}
static inline long double fl57_f2xm1(Fl41Fpu *f, long double a) { (void)f; return expm1l(a * 0.693147180559945309417232121458176568L); }
/* st(0) = a, st(1) = b. fprem: the remainder of a / b with the quotient truncated (C2 clear: complete), the low three quotient bits in C1, C3, C0 */
static inline long double fl57_fprem_common(Fl41Fpu *f, long double a, long double b, int nearest)
{
    if (b == 0 || isinf(a) || isnan(a) || isnan(b)) { f->sw = (uint16_t)(f->sw & ~0x4700u); return NAN; }
    long double r = nearest ? remainderl(a, b) : fmodl(a, b);
    long double q = fabsl((a - r) / b);
    unsigned qi = (unsigned)(fmodl(q, 8.0L) + 0.5L) & 7u;
    f->sw = (uint16_t)((f->sw & ~0x4700u) | ((qi & 1u) ? 0x0200u : 0u) | ((qi & 2u) ? 0x4000u : 0u) | ((qi & 4u) ? 0x0100u : 0u));
    return r;
}
static inline long double fl57_fprem(Fl41Fpu *f, long double a, long double b) { return fl57_fprem_common(f, a, b, 0); }
static inline long double fl57_fprem1(Fl41Fpu *f, long double a, long double b) { return fl57_fprem_common(f, a, b, 1); }
static inline long double fl57_fpatan(Fl41Fpu *f, long double a, long double b) { (void)f; return atan2l(b, a); }     /* atan(st(1) / st(0)) */
static inline long double fl57_fyl2x(Fl41Fpu *f, long double a, long double b) { (void)f; return b * log2l(a); }     /* st(1) * log2(st(0)) */
static inline long double fl57_fscale(Fl41Fpu *f, long double a, long double b)                                     /* st(0) * 2^trunc(st(1)) */
{
    (void)f;
    if (isnan(b)) return b;
    if (b > 100000.0L) b = 100000.0L;
    if (b < -100000.0L) b = -100000.0L;
    return scalbnl(a, (int)truncl(b));
}
static inline void fl57_fxam(Fl41Fpu *f, long double a)
{
    unsigned cc;
    switch (fpclassify(a)) {
    case FP_NAN: cc = 0x0100u; break;
    case FP_INFINITE: cc = 0x0500u; break;
    case FP_ZERO: cc = 0x4000u; break;
    case FP_SUBNORMAL: cc = 0x4400u; break;
    default: cc = 0x0400u; break;
    }
    if (signbit(a)) cc |= 0x0200u;
    f->sw = (uint16_t)((f->sw & ~0x4700u) | cc);
}
/* fist/fistp: the value rounded by the control word's rounding control; NaN and out of range give the "integer indefinite" (the most negative value) */
static inline uint64_t fl57_fist(Fl41Fpu *f, long double v, int bytes)
{
    long double r = fl57_round(f, v);
    long double lim = bytes == 2 ? 32768.0L : bytes == 4 ? 2147483648.0L : 9223372036854775808.0L;
    if (isnan(r) || r >= lim || r < -lim) return bytes == 2 ? 0x8000u : bytes == 4 ? 0x80000000u : 0x8000000000000000ull;
    return (uint64_t)(int64_t)r;
}
#endif
