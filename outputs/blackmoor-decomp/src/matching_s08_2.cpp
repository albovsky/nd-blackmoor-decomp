/*
 * Source-level C++ reconstruction of six complete x86 thiscall accessors.
 * The neutral field names preserve the observed offsets without claiming
 * recovered domain meanings. This is semantic C++ evidence; its Clang output
 * is compared separately from the original compiler's code generation.
 */
#include <stddef.h>
#include <stdint.h>

#define NOINLINE __attribute__((noinline))
using u32 = uint32_t;

struct FUN_004dae66_receiver {
    unsigned char padding[0x18];
    u32 field_18;
    NOINLINE u32 get();
};
static_assert(offsetof(FUN_004dae66_receiver, field_18) == 0x18);
u32 FUN_004dae66_receiver::get() { return field_18; }

struct FUN_004dae77_receiver {
    unsigned char padding[0x1c];
    u32 field_1c;
    NOINLINE u32 get();
};
static_assert(offsetof(FUN_004dae77_receiver, field_1c) == 0x1c);
u32 FUN_004dae77_receiver::get() { return field_1c; }

struct FUN_004daef1_receiver {
    unsigned char padding[0x0c];
    u32 field_0c;
    NOINLINE u32 get();
};
static_assert(offsetof(FUN_004daef1_receiver, field_0c) == 0x0c);
u32 FUN_004daef1_receiver::get() { return field_0c; }

struct FUN_004daf02_receiver {
    unsigned char padding[0x0c];
    u32 field_0c;
    NOINLINE void set(u32 value);
};
static_assert(offsetof(FUN_004daf02_receiver, field_0c) == 0x0c);
void FUN_004daf02_receiver::set(u32 value) { field_0c = value; }

struct FUN_004daf18_receiver {
    unsigned char padding[0x10];
    u32 field_10;
    NOINLINE u32 get();
};
static_assert(offsetof(FUN_004daf18_receiver, field_10) == 0x10);
u32 FUN_004daf18_receiver::get() { return field_10; }

struct FUN_004daf29_receiver {
    unsigned char padding[0x10];
    u32 field_10;
    NOINLINE void set(u32 value);
};
static_assert(offsetof(FUN_004daf29_receiver, field_10) == 0x10);
void FUN_004daf29_receiver::set(u32 value) { field_10 = value; }
