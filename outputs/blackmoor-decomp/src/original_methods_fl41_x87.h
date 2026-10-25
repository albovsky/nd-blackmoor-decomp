#ifndef BLACKMOOR_ORIGINAL_METHODS_FL41_X87_H
#define BLACKMOOR_ORIGINAL_METHODS_FL41_X87_H

#include <stdint.h>
#include <string.h>

/* FL-52: the x87 model of the translated rows at or above 0x480000 (scripts/lift_fl41.py), a copy of src/original_methods_fl40_x87.h (FL-51) under the Fl41/fl41_ names. The registers of the FPU live in a Fl41Fpu that the host passes in (`h->fpu`), so a callee that
 * is translated as well, and the host that plays a callee returning a value in st(0), see the same stack. The model is the Win32 process state the game runs in:
 * the control word is 0x27f (53-bit precision, round to nearest, every exception masked), the stack is empty and TOP is 0 when a function is entered, and the sticky
 * exception flags and the condition codes C0..C3 are kept in `sw` the way the hardware keeps them. Every arithmetic step runs on the host's x87 unit (inline assembly,
 * so that the hardware, not the compiler, rounds and raises the exception flags); on a host without an x87 unit the model falls back to plain `long double` arithmetic
 * (not bit-exact, no flags) and the differential tests skip. A value is held in 80 bits (`long double` on x86); only the low 10 bytes of it count. */

typedef struct Fl41Fpu {
    long double st[8];        /* the eight physical registers, st(i) is st[(TOP + i) & 7] */
    uint16_t sw;              /* status word: exception flags 0..5, C1 (bit 9), C0 C2 C3 (bits 8 10 14), TOP in bits 11..13 */
    uint16_t cw;              /* control word */
    uint8_t valid[8];         /* 1 while a register holds a value */
} Fl41Fpu;

#define FL41_FCW_WIN32 0x027fu

#define FL41_FTOP(f) (((f)->sw >> 11) & 7u)
#define FL41_FST(f, i) ((f)->st[(FL41_FTOP(f) + (unsigned)(i)) & 7u])

static inline void fl41_fpush(Fl41Fpu *f, long double v)
{
    unsigned t = (FL41_FTOP(f) - 1u) & 7u;
    f->sw = (uint16_t)((f->sw & ~0x3800u) | (t << 11));
    f->st[t] = v;
    f->valid[t] = 1;
}

static inline long double fl41_fpop(Fl41Fpu *f)
{
    unsigned t = FL41_FTOP(f);
    long double v = f->st[t];
    f->valid[t] = 0;
    f->sw = (uint16_t)((f->sw & ~0x3800u) | (((t + 1u) & 7u) << 11));
    return v;
}

#define FL41_FEXC 0x003fu     /* IE DE ZE OE UE PE */
#define FL41_FCC 0x4700u      /* C0 C1 C2 C3 */

/* the two halves of an 80-bit value: mantissa (bit 63 is the integer bit) and sign|exponent */
static inline uint64_t fl41_fmant(long double v) { uint64_t m; memcpy(&m, &v, 8); return m; }
static inline uint16_t fl41_fexp(long double v) { uint16_t e; memcpy(&e, (const unsigned char *)&v + 8, 2); return e; }
static inline long double fl41_fmake(uint64_t mant, uint16_t se)
{
    long double v = 0;
    memcpy(&v, &mant, 8);
    memcpy((unsigned char *)&v + 8, &se, 2);
    return v;
}

/* The oracle (Unicorn, QEMU's softfloat) and the hardware differ on the conversion of a NaN to or from a memory format: the oracle keeps the quiet bit as it is (it neither
 * sets it nor requires it) and takes the top bits of the significand, a NaN that would lose all its bits becomes the default NaN. The translation follows the oracle there. */
static inline long double fl41_nan_from_f32(uint32_t bits) { return fl41_fmake(0x8000000000000000ull | ((uint64_t)(bits & 0x7fffffu) << 40), (uint16_t)(((bits >> 31) << 15) | 0x7fffu)); }
static inline long double fl41_nan_from_f64(uint64_t bits) { return fl41_fmake(0x8000000000000000ull | ((bits & 0xfffffffffffffull) << 11), (uint16_t)(((bits >> 63) << 15) | 0x7fffu)); }
static inline int fl41_is_nan(long double v) { return (fl41_fexp(v) & 0x7fffu) == 0x7fffu && (fl41_fmant(v) << 1) != 0; }
static inline uint32_t fl41_nan_to_f32(long double v)
{
    uint32_t m = (uint32_t)((fl41_fmant(v) << 1) >> 41);
    return m ? (uint32_t)(((fl41_fexp(v) >> 15) << 31) | 0x7f800000u | m) : 0xffc00000u;
}
static inline uint64_t fl41_nan_to_f64(long double v)
{
    uint64_t m = (fl41_fmant(v) << 1) >> 12;
    return m ? ((uint64_t)(fl41_fexp(v) >> 15) << 63) | 0x7ff0000000000000ull | m : 0xfff8000000000000ull;
}
static inline int fl41_is_zero(long double v) { return (fl41_fexp(v) & 0x7fffu) == 0 && fl41_fmant(v) == 0; }

#if defined(__x86_64__) || defined(__i386__)

#define FL41_X87_EXACT 1
#define FL41_FPU_RESTORE_HOST_CW() do { static const uint16_t host_cw_ = 0x037f; __asm__ volatile("fldcw %0" : : "m"(host_cw_)); } while (0)

/* the host's cw is set from the model before every operation, and the host's own flags are cleared first and read after */
#define FL41_ASM_ARITH(OPS)                                                                                                                    \
    long double r;                                                                                                                             \
    uint16_t s;                                                                                                                                \
    __asm__ volatile("fldcw %4\n\tfldt %2\n\tfldt %3\n\tfnclex\n\t" OPS "\n\tfnstsw %1\n\tfstpt %0"                                           \
                     : "=m"(r), "=m"(s)                                                                                                        \
                     : "m"(a), "m"(b), "m"(f->cw)                                                                                              \
                     : "st", "st(1)", "cc");                                                                                                   \
    (void)s;                                                                                                                                   \
    return r;

/* a op b, with a loaded first: after the two loads st(0) = b and st(1) = a; the result is left in st(1) and st(0) is popped */
static inline long double fl41_fx_add(Fl41Fpu *f, long double a, long double b) { FL41_ASM_ARITH("faddp %%st, %%st(1)") }
static inline long double fl41_fx_mul(Fl41Fpu *f, long double a, long double b) { FL41_ASM_ARITH("fmulp %%st, %%st(1)") }
/* the AT&T mnemonics of the reversed forms are swapped (the assembler's long-standing quirk): `fsubrp` here is Intel's fsubp (st(1) = st(1) - st(0)) */
static inline long double fl41_fx_sub(Fl41Fpu *f, long double a, long double b) { FL41_ASM_ARITH("fsubrp %%st, %%st(1)") }
static inline long double fl41_fx_div_hw(Fl41Fpu *f, long double a, long double b) { FL41_ASM_ARITH("fdivrp %%st, %%st(1)") }
/* the oracle raises ZE for a zero divisor, whatever the dividend (it raises no other exception flag), and the model keeps no other */
static inline long double fl41_fx_div(Fl41Fpu *f, long double a, long double b)
{
    if (fl41_is_zero(b))
        f->sw |= 4u;
    return fl41_fx_div_hw(f, a, b);
}

/* conversions from the memory formats */
static inline long double fl41_ld_f32(Fl41Fpu *f, uint32_t bits)
{
    float x;
    long double r;
    uint16_t s;
    if ((bits & 0x7f800000u) == 0x7f800000u && (bits & 0x7fffffu))
        return fl41_nan_from_f32(bits);
    memcpy(&x, &bits, 4);
    __asm__ volatile("fldcw %3\n\tfnclex\n\tflds %2\n\tfnstsw %1\n\tfstpt %0" : "=m"(r), "=m"(s) : "m"(x), "m"(f->cw) : "st", "cc");
    (void)s;
    return r;
}

static inline long double fl41_ld_f64(Fl41Fpu *f, uint64_t bits)
{
    double x;
    long double r;
    uint16_t s;
    if ((bits & 0x7ff0000000000000ull) == 0x7ff0000000000000ull && (bits & 0xfffffffffffffull))
        return fl41_nan_from_f64(bits);
    memcpy(&x, &bits, 8);
    __asm__ volatile("fldcw %3\n\tfnclex\n\tfldl %2\n\tfnstsw %1\n\tfstpt %0" : "=m"(r), "=m"(s) : "m"(x), "m"(f->cw) : "st", "cc");
    (void)s;
    return r;
}

static inline long double fl41_ld_i16(Fl41Fpu *f, uint32_t bits)
{
    int16_t x = (int16_t)bits;
    long double r;
    uint16_t s;
    __asm__ volatile("fldcw %3\n\tfnclex\n\tfilds %2\n\tfnstsw %1\n\tfstpt %0" : "=m"(r), "=m"(s) : "m"(x), "m"(f->cw) : "st", "cc");
    (void)s;
    return r;
}

static inline long double fl41_ld_i32(Fl41Fpu *f, uint32_t bits)
{
    int32_t x = (int32_t)bits;
    long double r;
    uint16_t s;
    __asm__ volatile("fldcw %3\n\tfnclex\n\tfildl %2\n\tfnstsw %1\n\tfstpt %0" : "=m"(r), "=m"(s) : "m"(x), "m"(f->cw) : "st", "cc");
    (void)s;
    return r;
}

static inline long double fl41_ld_i64(Fl41Fpu *f, uint64_t bits)
{
    int64_t x = (int64_t)bits;
    long double r;
    uint16_t s;
    __asm__ volatile("fldcw %3\n\tfnclex\n\tfildll %2\n\tfnstsw %1\n\tfstpt %0" : "=m"(r), "=m"(s) : "m"(x), "m"(f->cw) : "st", "cc");
    (void)s;
    return r;
}

static inline uint32_t fl41_st_f32(Fl41Fpu *f, long double v)
{
    float x;
    uint32_t bits;
    uint16_t s;
    if (fl41_is_nan(v))
        return fl41_nan_to_f32(v);
    __asm__ volatile("fldcw %3\n\tfldt %2\n\tfnclex\n\tfstps %0\n\tfnstsw %1" : "=m"(x), "=m"(s) : "m"(v), "m"(f->cw) : "st", "cc");
    (void)s;
    memcpy(&bits, &x, 4);
    return bits;
}

static inline uint64_t fl41_st_f64(Fl41Fpu *f, long double v)
{
    double x;
    uint64_t bits;
    uint16_t s;
    if (fl41_is_nan(v))
        return fl41_nan_to_f64(v);
    __asm__ volatile("fldcw %3\n\tfldt %2\n\tfnclex\n\tfstpl %0\n\tfnstsw %1" : "=m"(x), "=m"(s) : "m"(v), "m"(f->cw) : "st", "cc");
    (void)s;
    memcpy(&bits, &x, 8);
    return bits;
}

/* compare a with b (fcom: a is st(0)): C0 C2 C3 of the result replace those of the status word */
static inline void fl41_fx_cmp(Fl41Fpu *f, long double a, long double b)
{
    uint16_t s;
    __asm__ volatile("fldcw %3\n\tfldt %2\n\tfldt %1\n\tfnclex\n\tfcom %%st(1)\n\tfnstsw %0\n\tfstp %%st(0)\n\tfstp %%st(0)"
                     : "=m"(s)
                     : "m"(a), "m"(b), "m"(f->cw)
                     : "st", "st(1)", "cc");
    f->sw = (uint16_t)((f->sw & ~0x4700u) | (s & 0x4500u));
}

#else

#define FL41_X87_EXACT 0
#define FL41_FPU_RESTORE_HOST_CW() ((void)0)

static inline long double fl41_fx_add(Fl41Fpu *f, long double a, long double b) { (void)f; return a + b; }
static inline long double fl41_fx_mul(Fl41Fpu *f, long double a, long double b) { (void)f; return a * b; }
static inline long double fl41_fx_sub(Fl41Fpu *f, long double a, long double b) { (void)f; return a - b; }
static inline long double fl41_fx_div(Fl41Fpu *f, long double a, long double b) { (void)f; return a / b; }
static inline long double fl41_ld_f32(Fl41Fpu *f, uint32_t bits) { float x; (void)f; memcpy(&x, &bits, 4); return x; }
static inline long double fl41_ld_f64(Fl41Fpu *f, uint64_t bits) { double x; (void)f; memcpy(&x, &bits, 8); return x; }
static inline long double fl41_ld_i16(Fl41Fpu *f, uint32_t bits) { (void)f; return (int16_t)bits; }
static inline long double fl41_ld_i32(Fl41Fpu *f, uint32_t bits) { (void)f; return (int32_t)bits; }
static inline long double fl41_ld_i64(Fl41Fpu *f, uint64_t bits) { (void)f; return (int64_t)bits; }
static inline uint32_t fl41_st_f32(Fl41Fpu *f, long double v) { float x = (float)v; uint32_t bits; (void)f; memcpy(&bits, &x, 4); return bits; }
static inline uint64_t fl41_st_f64(Fl41Fpu *f, long double v) { double x = (double)v; uint64_t bits; (void)f; memcpy(&bits, &x, 8); return bits; }
static inline void fl41_fx_cmp(Fl41Fpu *f, long double a, long double b)
{
    unsigned cc = (a != a || b != b) ? 0x4500u : a > b ? 0u : a < b ? 0x0100u : 0x4000u;
    f->sw = (uint16_t)((f->sw & ~0x4700u) | cc);
}

#endif

/* fchs: flip the sign of st(0) (a bit operation: no flag, C1 clear) */
static inline long double fl41_fchs(long double v)
{
    unsigned char b[sizeof(long double)];
    memcpy(b, &v, sizeof v);
    b[9] ^= 0x80u;
    memcpy(&v, b, sizeof v);
    return v;
}

#endif
