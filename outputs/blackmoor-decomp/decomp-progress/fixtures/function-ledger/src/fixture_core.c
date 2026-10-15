/* Synthetic fixture for the function-ledger tests. This is not game code. */
#include <stdint.h>

/* Native port of 0x401000 (fixture entry point). */
uint32_t fixture_entry(uint32_t value) {
    return value + 1u;
}

uint32_t fixture_tests_only(uint32_t value) {
    /* Mirrors FUN_00401100. */
    return value ^ 0x5au;
}

uint32_t fixture_with_parts(uint32_t value) {
    /* Covers 0x401340 and its derived part 0x004013a0. */
    return value * 3u;
}

uint32_t fixture_partial(uint32_t value) {
    return value; /* carries no address: used for the missing-address mutation */
}

uint32_t fixture_candidate_e(uint32_t value) {
    return value - 1u; /* FUN_004014c0, window only mapped */
}

uint32_t fixture_candidate_i(uint32_t value) {
    return value << 1; /* 0x401900 with an open interior blocker */
}

/* Port of 0x00401a00 with one deliberate safety rejection. */
uint32_t fixture_rejects(uint32_t value) {
    if (value > 100u) {
        return 0u;
    }
    return value;
}
