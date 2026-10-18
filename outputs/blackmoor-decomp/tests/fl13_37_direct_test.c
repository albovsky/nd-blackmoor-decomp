/* FL-13 direct test of the object defaults initializer of the raw 0x37 kernel (src/action_family_37.c).
 *
 * initialize_original_defaults is `static`, so this test includes the kernel source and calls it. Prints "PASS <name>" /
 * "FAIL <name>: <message>"; the exit status is the failure count. Expected bytes are built here from the Ghidra pseudocode of
 * GAME.EXE 0x48945b FUN_0048945b(param_1 = object, param_2 = int[4] rectangle), thiscall on the owner (ECX), with literal
 * offsets: owner+0x20 := param_1; object +0x25 := 2 (u16), +0x3d := 9999, +0x39 := 0xffff, +0x21 := 2, +0x29 := 1, ten u16
 * 0xffff at +0x51 + 4*i, the 9 bytes "NO SOUND\0" at +0x79, +0x43 := 1 (u16), +0x4d := 1 (u32), +0x2b := 1 (u16), +0xaa := 1
 * (u16), +0x6ec := 0, +0x6ee := 0, +0x6f0 := 2 (u16), +0x702/+0x706/+0x70a/+0x70e := rect[0..3], +0x6f6 := 0, +0x6f2 := 0
 * (u32), +0x6fe := rect[3] - rect[1], +0x6fa := rect[2] - rect[0] (32-bit wrap). Nothing else is written. The whole 0xaba byte
 * object is compared against a sentinel-filled image with only those stores applied. */
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "../src/action_family_37.c"

static int g_failed;
static char g_msg[400];

#define EXPECT(cond)                                                                       \
    do {                                                                                   \
        if (!g_failed && !(cond)) {                                                        \
            g_failed = 1;                                                                  \
            snprintf(g_msg, sizeof g_msg, "line %d: %s", __LINE__, #cond);                 \
        }                                                                                  \
    } while (0)

static void p16(uint8_t *b, unsigned o, uint16_t v)
{
    b[o] = (uint8_t)v;
    b[o + 1] = (uint8_t)(v >> 8);
}

static void p32(uint8_t *b, unsigned o, uint32_t v)
{
    p16(b, o, (uint16_t)v);
    p16(b, o + 2, (uint16_t)(v >> 16));
}

/* The image the original leaves behind, from the pseudocode. */
static void expected_image(uint8_t *e, const int32_t *r)
{
    unsigned i;
    p16(e, 0x25, 2);
    p16(e, 0x3d, 9999);
    p16(e, 0x39, 0xffff);
    p16(e, 0x21, 2);
    p16(e, 0x29, 1);
    for (i = 0; i < 10; ++i) p16(e, 0x51 + i * 4, 0xffff);
    memcpy(e + 0x79, "NO SOUND", 9);
    p16(e, 0x43, 1);
    p32(e, 0x4d, 1);
    p16(e, 0x2b, 1);
    p16(e, 0xaa, 1);
    p16(e, 0x6ec, 0);
    p16(e, 0x6ee, 0);
    p16(e, 0x6f0, 2);
    p32(e, 0x702, (uint32_t)r[0]);
    p32(e, 0x706, (uint32_t)r[1]);
    p32(e, 0x70a, (uint32_t)r[2]);
    p32(e, 0x70e, (uint32_t)r[3]);
    p32(e, 0x6f6, 0);
    p32(e, 0x6f2, 0);
    p32(e, 0x6fe, (uint32_t)r[3] - (uint32_t)r[1]);
    p32(e, 0x6fa, (uint32_t)r[2] - (uint32_t)r[0]);
}

static void run_case(const int32_t *r, uint32_t handle)
{
    uint8_t object[0xaba], want[0xaba];
    ActionFamily37Decoded decoded;
    uint32_t link = 0x77777777u;

    memset(object, 0xa5, sizeof object);
    memset(want, 0xa5, sizeof want);
    memset(&decoded, 0, sizeof decoded);
    memcpy(decoded.fixed_rect, r, sizeof decoded.fixed_rect);
    /* decoy values elsewhere in the decoded struct must not reach the object */
    decoded.initial_geometry[0] = 0x1111;
    decoded.option_21 = 0x2222;
    decoded.option_23 = 0x3333;
    expected_image(want, r);
    initialize_original_defaults(object, &decoded, handle, &link);
    EXPECT(memcmp(object, want, sizeof object) == 0);
    EXPECT(link == handle);
}

static void t_initialize_original_defaults(void)
{
    const int32_t plain[4] = {10, 20, 110, 70};
    const int32_t neg[4] = {-5, -9, 3, 4};
    const int32_t wrap[4] = {0x7fffffff, 0x7fffffff, (int32_t)0x80000000, (int32_t)0x80000001};
    const int32_t zero[4] = {0, 0, 0, 0};
    run_case(plain, 0x37000001u);
    run_case(neg, 0xdeadbeefu);
    run_case(wrap, 1u);
    run_case(zero, 0x37a70001u);
    /* the link cell is written even when its value was already the handle, and for handle 0xffffffff */
    run_case(plain, 0xffffffffu);
}

typedef struct Case {
    const char *name;
    void (*fn)(void);
} Case;

int main(void)
{
    static const Case cases[] = {{"initialize_original_defaults", t_initialize_original_defaults}};
    int failures = 0;
    for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        g_failed = 0;
        g_msg[0] = '\0';
        cases[i].fn();
        if (g_failed) {
            printf("FAIL %s: %s\n", cases[i].name, g_msg);
            ++failures;
        } else {
            printf("PASS %s\n", cases[i].name);
        }
    }
    return failures;
}
