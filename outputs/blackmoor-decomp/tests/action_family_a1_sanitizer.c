#include "action_family_a1.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define CHECK(x) do { if (!(x)) { \
    fprintf(stderr, "sanitizer assertion failed at line %d\n", __LINE__); \
    return 1; } } while (0)

static unsigned valid_cases;
static unsigned rejected_cases;
static uint32_t rng = UINT32_C(0xa1012026);

static uint32_t random_word(void)
{
    rng ^= rng << 13;
    rng ^= rng >> 17;
    rng ^= rng << 5;
    return rng;
}

static void put_word(uint8_t *p, uint16_t n)
{
    p[0] = (uint8_t)n;
    p[1] = (uint8_t)(n >> 8);
}

/* Allocations are exact sized so ASan can see even a single excess read. */
static int check_input(const uint8_t *bytes, size_t n, int expect_valid)
{
    uint8_t *raw = malloc(n == 0u ? 1u : n);
    ActionFamilyA1Decoded decoded;
    ActionFamilyA1Decoded decoded_before;
    ActionFamilyA1Constructed constructed;
    ActionFamilyA1Constructed constructed_before;
    ActionFamilyA1Status ds;
    ActionFamilyA1Status cs;
    CHECK(raw != NULL);
    if (n != 0u) {
        memcpy(raw, bytes, n);
    }
    memset(&decoded, 0xa5, sizeof(decoded));
    memset(&constructed, 0x69, sizeof(constructed));
    memcpy(&decoded_before, &decoded, sizeof(decoded));
    memcpy(&constructed_before, &constructed, sizeof(constructed));
    ds = action_family_a1_decode(raw, n, &decoded);
    cs = action_family_a1_construct(raw, n, NULL, 0u, UINT32_MAX, 1u, &constructed);
    if (expect_valid >= 0) {
        CHECK((ds == ACTION_FAMILY_A1_OK) == expect_valid);
        CHECK((cs == ACTION_FAMILY_A1_OK) == expect_valid);
    }
    if (ds != ACTION_FAMILY_A1_OK) {
        CHECK(memcmp(&decoded, &decoded_before, sizeof(decoded)) == 0);
        CHECK(cs != ACTION_FAMILY_A1_OK);
        CHECK(memcmp(&constructed, &constructed_before, sizeof(constructed)) == 0);
        ++rejected_cases;
    } else {
        CHECK(cs == ACTION_FAMILY_A1_OK);
        CHECK(decoded.body_bytes <= n);
        CHECK(decoded.dependency_records == raw + decoded.body_bytes);
        CHECK(constructed.allocation_bytes <= ACTION_FAMILY_A1_MAX_OBJECT_BYTES);
        CHECK(constructed.payload_offset_after == (uint32_t)(UINT32_MAX + decoded.body_bytes));
        ++valid_cases;
    }
    if (n != 0u) {
        CHECK(memcmp(raw, bytes, n) == 0);
    }
    free(raw);
    return 0;
}

int main(void)
{
    uint8_t body[10200];
    uint8_t key_body[84];
    uint8_t text[32592];
    ActionFamilyA1Constructed result;
    ActionFamilyA1Constructed before;
    ActionFamilyA1Decoded decoded;
    size_t n;
    size_t i;

    /* Every valid inline count, including binary NUL bytes and random tails. */
    for (n = 0u; n <= 9999u; ++n) {
        size_t tail = (n % 8u) * 16u;
        for (i = 0u; i < 51u+n+tail; ++i) {
            body[i] = (uint8_t)random_word();
        }
        body[n % 33u] = 0u;
        put_word(body+49u, (uint16_t)n);
        CHECK(check_input(body, 51u+n+tail, 1) == 0);
    }
    memset(body, 0, sizeof(body));
    for (n = 0u; n < 51u; ++n) {
        CHECK(check_input(body, n, 0) == 0);
    }
    put_word(body+49u, UINT16_MAX);
    for (n = 51u; n < 84u; ++n) {
        CHECK(check_input(body, n, 0) == 0);
    }
    CHECK(check_input(body, 84u, 1) == 0);
    for (n = 1u; n < 16u; ++n) {
        CHECK(check_input(body, 84u+n, 0) == 0);
    }
    /* All remaining 16-bit selector encodings, on an exact 51-byte span. */
    for (n = 10000u; n < 65535u; ++n) {
        put_word(body+49u, (uint16_t)n);
        CHECK(check_input(body, 51u, 0) == 0);
    }
    for (n = 0u; n < 10000u; ++n) {
        size_t length = random_word() % 2048u;
        for (i = 0u; i < length; ++i) {
            body[i] = (uint8_t)random_word();
        }
        CHECK(check_input(body, length, -1) == 0);
    }
    memset(key_body, 0, sizeof(key_body));
    put_word(key_body+49u, UINT16_MAX);
    memset(text, 'z', sizeof(text));
    for (n = 0u; n <= ACTION_FAMILY_A1_MAX_RESOLVED_BYTES; n += 127u) {
        CHECK(action_family_a1_construct(key_body,84u,text,n,50u,1u,&result) == ACTION_FAMILY_A1_OK);
        ++valid_cases;
    }
    CHECK(action_family_a1_construct(key_body,84u,text,32591u,50u,1u,&result) == ACTION_FAMILY_A1_OK);
    ++valid_cases;
    memcpy(&before, &result, sizeof(before));
    CHECK(action_family_a1_construct(key_body,84u,text,32592u,50u,1u,&result) != ACTION_FAMILY_A1_OK);
    CHECK(memcmp(&before,&result,sizeof(result)) == 0);
    ++rejected_cases;
    text[3] = 0u;
    CHECK(action_family_a1_construct(key_body,84u,text,8u,50u,1u,&result) != ACTION_FAMILY_A1_OK);
    CHECK(memcmp(&before,&result,sizeof(result)) == 0);
    ++rejected_cases;
    CHECK(action_family_a1_decode(NULL,84u,&decoded) != ACTION_FAMILY_A1_OK);
    CHECK(action_family_a1_decode(key_body,84u,NULL) != ACTION_FAMILY_A1_OK);
    CHECK(action_family_a1_decode(key_body,SIZE_MAX,&decoded) != ACTION_FAMILY_A1_OK);
    CHECK(action_family_a1_decode((const uint8_t *)(UINTPTR_MAX-10u),84u,&decoded) != ACTION_FAMILY_A1_OK);
    CHECK(action_family_a1_construct(key_body,84u,(const uint8_t *)&result,1u,50u,1u,&result) != ACTION_FAMILY_A1_OK);
    CHECK(memcmp(&before,&result,sizeof(result)) == 0);
    printf("{\"valid_cases\":%u,\"rejected_cases\":%u,\"special_pointer_checks\":5}\n",valid_cases,rejected_cases);
    return 0;
}
