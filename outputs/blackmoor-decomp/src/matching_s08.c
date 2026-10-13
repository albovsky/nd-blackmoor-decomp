/*
 * Independently reconstructed x86 leaf functions for S08 matching.
 * The function names remain address-based because ownership/field semantics
 * are not yet established beyond the observed offsets and calling convention.
 * Compile for i686-pc-windows-msvc at -O0 to test a source reconstruction against the original.
 */
#include <stdint.h>

#define THISCALL __attribute__((thiscall, noinline))

typedef uint32_t u32;

typedef struct FUN_004dae66_receiver FUN_004dae66_receiver;
u32 THISCALL FUN_004dae66(FUN_004dae66_receiver *self) {
    return *(const u32 *)((const unsigned char *)self + 0x18);
}

typedef struct FUN_004dae77_receiver FUN_004dae77_receiver;
u32 THISCALL FUN_004dae77(FUN_004dae77_receiver *self) {
    return *(const u32 *)((const unsigned char *)self + 0x1c);
}

typedef struct FUN_004daef1_receiver FUN_004daef1_receiver;
u32 THISCALL FUN_004daef1(FUN_004daef1_receiver *self) {
    return *(const u32 *)((const unsigned char *)self + 0x0c);
}

typedef struct FUN_004daf02_receiver FUN_004daf02_receiver;
void THISCALL FUN_004daf02(FUN_004daf02_receiver *self, u32 value) {
    *(u32 *)((unsigned char *)self + 0x0c) = value;
}

typedef struct FUN_004daf18_receiver FUN_004daf18_receiver;
u32 THISCALL FUN_004daf18(FUN_004daf18_receiver *self) {
    return *(const u32 *)((const unsigned char *)self + 0x10);
}

typedef struct FUN_004daf29_receiver FUN_004daf29_receiver;
void THISCALL FUN_004daf29(FUN_004daf29_receiver *self, u32 value) {
    *(u32 *)((unsigned char *)self + 0x10) = value;
}
