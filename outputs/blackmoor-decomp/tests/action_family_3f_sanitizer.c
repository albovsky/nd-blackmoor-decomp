/* Bounded synthetic input checks; no original resource bytes. */
#include "action_family_3f.h"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static uint32_t random_state = UINT32_C(0x3f123456);
static uint32_t next_random(void)
{
    random_state = random_state * UINT32_C(1664525) + UINT32_C(1013904223);
    return random_state;
}
static size_t fixture(uint8_t *p, size_t primary, size_t secondary, size_t tails)
{
    size_t cursor = 77u;
    size_t i;
    memset(p, 0, 2048u);
    memcpy(p, "NAME", 4u); memcpy(p + 35u, "KEY", 3u);
    p[33] = 0x23u; p[34] = 0x81u;
    p[68] = 0x91u; p[69] = 0x82u; p[70] = 0x73u;
    p[75] = (uint8_t)primary;
    for (i = 0u; i < primary; ++i) {
        size_t n = next_random() % 5u;
        p[cursor] = (uint8_t)n; p[cursor + 1u] = 0xa7u;
        cursor += 2u;
        memset(p + cursor, 0x6bu, n * 5u); cursor += n * 5u;
        memcpy(p + cursor, "KEY", 3u); memcpy(p + cursor + 33u, "CHOICE", 6u);
        p[cursor + 66u] = 0x34u; p[cursor + 67u] = 0xf1u;
        cursor += 68u;
    }
    p[cursor] = (uint8_t)secondary; p[cursor + 1u] = 0xb8u; cursor += 2u;
    for (i = 0u; i < secondary; ++i) {
        size_t n = next_random() % 5u;
        p[cursor] = (uint8_t)n; p[cursor + 1u] = 0xc9u; cursor += 2u;
        memset(p + cursor, 0x7cu, n * 5u); cursor += n * 5u;
        memset(p + cursor, 0xf1u, 4u); cursor += 4u;
    }
    memset(p + cursor, 0xe7u, tails * 16u);
    return cursor + tails * 16u;
}

static void check(const uint8_t *input, size_t n, int require_valid)
{
    uint8_t *p = malloc(n != 0u ? n : 1u);
    ActionFamily3fDecoded d;
    ActionFamily3fDecoded before;
    ActionFamily3fConstructed out;
    ActionFamily3fConstructed out_before;
    ActionFamily3fText texts[6];
    uint8_t arena[10000];
    size_t length = SIZE_MAX;
    ActionFamily3fStatus status;
    size_t i;
    assert(p != NULL);
    memcpy(p, input, n);
    memset(&d, 0xa5, sizeof(d)); memcpy(&before, &d, sizeof(d));
    status = action_family_3f_decode(p, n, &d);
    if (require_valid) assert(status == ACTION_FAMILY_3F_OK);
    if (status != ACTION_FAMILY_3F_OK) assert(memcmp(&d, &before, sizeof(d)) == 0);
    else {
        assert(d.body_bytes <= n && (n - d.body_bytes) % 16u == 0u);
        assert(d.dependency_records == p + d.body_bytes);
        assert(d.primary_records == p + 77u);
        assert(d.secondary_records >= p && d.secondary_records <= p + n);
    }
    assert(action_family_3f_body_length(p, n, &length) == status);
    if (status != ACTION_FAMILY_3F_OK) assert(length == SIZE_MAX);
    else assert(length == d.body_bytes);
    for (i = 0u; i < 6u; ++i) { texts[i].bytes = (const uint8_t *)"caption"; texts[i].length = 7u; }
    memset(&out, 0x6b, sizeof(out)); memcpy(&out_before, &out, sizeof(out));
    memset(arena, 0xcd, sizeof(arena));
    status = action_family_3f_construct(p, n, texts,
        length != SIZE_MAX && d.primary_count < 6 ? (size_t)d.primary_count + 1u : 6u,
        UINT32_C(0xfffffff0), UINT32_C(0x26000000), arena, sizeof(arena), &out);
    if (require_valid) assert(status == ACTION_FAMILY_3F_OK);
    if (status != ACTION_FAMILY_3F_OK) {
        assert(memcmp(&out, &out_before, sizeof(out)) == 0);
        for (i = 0u; i < sizeof(arena); ++i) assert(arena[i] == 0xcdu);
    } else {
        assert(out.arena_bytes <= sizeof(arena));
        for (i = out.arena_bytes; i < sizeof(arena); ++i) assert(arena[i] == 0xcdu);
    }
    free(p);
}

int main(void)
{
    uint8_t p[2048];
    size_t n;
    size_t i;
    size_t valid = 0u;
    size_t malformed = 0u;
    size_t mutations = 0u;
    n = fixture(p, 0u, 0u, 0u);
    check(p, n, 1); ++valid;
    for (i = 0u; i < n; ++i) { check(p, i, 0); ++malformed; }
    for (i = 1u; i < 16u; ++i) { check(p, n + i, 0); ++malformed; }
    p[75] = 0xffu; p[76] = 0x7fu; check(p, n, 0); ++malformed;
    p[76] = 0xffu; check(p, n, 0); ++malformed;
    n = fixture(p, 2u, 2u, 0u);
    for (i = 77u; i < n; ++i) { check(p, i, 0); ++malformed; }
    for (i = 0u; i < 20000u; ++i) {
        size_t primary = next_random() % 6u;
        size_t secondary = next_random() % 5u;
        size_t tails = next_random() % 5u;
        n = fixture(p, primary, secondary, tails);
        check(p, n, 1); ++valid;
    }
    for (i = 0u; i < 30000u; ++i) {
        size_t primary = next_random() % 6u;
        size_t secondary = next_random() % 5u;
        size_t tails = next_random() % 5u;
        size_t k;
        n = fixture(p, primary, secondary, tails);
        for (k = 0u; k < 1u + i % 4u; ++k) p[next_random() % n] ^= (uint8_t)(1u << (next_random() % 8u));
        if (i % 3u == 0u) n = next_random() % (n + 1u);
        check(p, n, 0); ++mutations;
    }
    /* Fake spans are rejected by integer-range checks before dereference. */
    {
        ActionFamily3fDecoded d;
        ActionFamily3fConstructed out;
        ActionFamily3fText texts[1] = {{(const uint8_t *)"text", 4u}};
        uint8_t arena[3000];
        size_t size = 1u;
        n = fixture(p, 0u, 0u, 0u);
        assert(action_family_3f_decode(p, SIZE_MAX, &d) == ACTION_FAMILY_3F_ERR_BOUNDS);
        assert(action_family_3f_decode((const uint8_t *)(UINTPTR_MAX - 15u), 79u, &d) == ACTION_FAMILY_3F_ERR_BOUNDS);
        assert(action_family_3f_decode(p, n, (ActionFamily3fDecoded *)p) == ACTION_FAMILY_3F_ERR_OVERLAP);
        assert(action_family_3f_body_length(p, n, (size_t *)p) == ACTION_FAMILY_3F_ERR_OVERLAP);
        assert(action_family_3f_decode(NULL, n, &d) == ACTION_FAMILY_3F_ERR_ARGUMENT);
        assert(action_family_3f_decode(p, n, NULL) == ACTION_FAMILY_3F_ERR_ARGUMENT);
        assert(action_family_3f_construct(p, n, texts, 1u, 50u, 1u, arena, 2u, &out) == ACTION_FAMILY_3F_ERR_CAPACITY);
        assert(action_family_3f_construct(p, n, texts, SIZE_MAX, 50u, 1u, NULL, 0u, &out) == ACTION_FAMILY_3F_ERR_BOUNDS);
        assert(action_family_3f_construct(p, n, texts, 1u, 50u, UINT32_MAX, NULL, 0u, &out) == ACTION_FAMILY_3F_ERR_BOUNDS);
        assert(action_family_3f_construct(p, n, texts, 1u, 50u, 1u, p, n, &out) == ACTION_FAMILY_3F_ERR_OVERLAP);
        texts[0].bytes = arena; texts[0].length = 4u;
        assert(action_family_3f_construct(p, n, texts, 1u, 50u, 1u, arena, sizeof(arena), &out) == ACTION_FAMILY_3F_ERR_OVERLAP);
        assert(action_family_3f_body_length(NULL, 0u, &size) == ACTION_FAMILY_3F_ERR_ARGUMENT);
        malformed += 12u;
    }
    printf("{\"status\":\"pass\",\"valid_cases\":%zu,\"malformed_cases\":%zu,\"bounded_mutations\":%zu}\n", valid, malformed, mutations);
    return 0;
}
