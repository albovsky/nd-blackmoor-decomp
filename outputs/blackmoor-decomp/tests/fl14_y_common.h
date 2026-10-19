/* Shared helpers of the FL-14 group-y direct tests (tests/fl14_y_*_direct_test.c): the PASS/FAIL reporter and a recording
 * mark_dirty host callback. Include after the kernel source. Fixtures are synthetic (no original bytes). */
#ifndef FL14_Y_COMMON_H
#define FL14_Y_COMMON_H

#include <stdio.h>

static int g_failed;
static char g_msg[256];
static int g_fail_count;
#define CK(cond)                                                               \
    do {                                                                       \
        if (!(cond) && !g_failed) {                                            \
            g_failed = 1;                                                      \
            snprintf(g_msg, sizeof g_msg, "line %d: %.200s", __LINE__, #cond); \
        }                                                                      \
    } while (0)
#define RUN_TEST(fn)                                      \
    do {                                                  \
        g_failed = 0;                                     \
        g_msg[0] = 0;                                     \
        fn();                                             \
        if (g_failed) {                                   \
            printf("FAIL %s: %s\n", #fn, g_msg);          \
            ++g_fail_count;                               \
        } else {                                          \
            printf("PASS %s\n", #fn);                     \
        }                                                 \
    } while (0)

/* Records every mark_dirty(slot) call in order. */
typedef struct {
    int calls;
    int16_t slot[8];
} Rec;
static int rec_mark_dirty(void *context, int16_t slot)
{
    Rec *r = (Rec *)context;
    if (r->calls < 8) r->slot[r->calls] = slot;
    r->calls++;
    return 0;
}

/* Cases of the invalidate functions: the original stores 1 in the entry of `slot` only when active != 0 and slot != -1. */
typedef struct {
    int32_t active;
    int16_t slot;
    int expect_call;
} InvCase;
static const InvCase k_inv_cases[] = {
    {0, 5, 0},           /* inactive: nothing */
    {0, -1, 0},          /* inactive and no slot */
    {0, 0, 0},           /* inactive, slot 0 */
    {1, -1, 0},          /* active, slot == -1: nothing */
    {1, 5, 1},           /* both set: one call with the slot */
    {1, 0, 1},           /* slot 0 is a real slot */
    {0x100, 7, 1},       /* any nonzero dword counts (low byte zero) */
    {0x01000000, 9, 1},  /* high byte only */
    {-1, 3, 1},          /* all bits set */
    {1, -2, 1},          /* only -1 means none */
};
#define N_INV_CASES (sizeof k_inv_cases / sizeof k_inv_cases[0])

#endif
