/* Synthetic CRT rand adapter for the function-ledger fixture. Not game code. */
#include <stdint.h>

/* Host adapter for FUN_00406000 (CRT rand), contract-tested. */
uint32_t fixture_rand(uint32_t *state) {
    *state = *state * 214013u + 2531011u;
    return (*state >> 16) & 0x7fffu;
}
