/* Test-only shim for exact intermediate checks of the static x87 helper. */
#include "../src/action_family_28.c"

int action_family28_test_divide_one_third(unsigned precision,
                                          uint64_t *out_high,
                                          uint64_t *out_low,
                                          int32_t *out_exponent)
{
    ActionFamily28X87Value result;

    if (out_high == NULL || out_low == NULL || out_exponent == NULL ||
        (precision != 53u && precision != 64u)) {
        return 1;
    }
    result = divide_x87_values(x87_value_from_i32(1),
                               x87_value_from_i32(3), precision);
    *out_high = (uint64_t)(result.significand >> 64);
    *out_low = (uint64_t)result.significand;
    *out_exponent = result.exponent;
    return result.sign == 1 ? 0 : 1;
}
