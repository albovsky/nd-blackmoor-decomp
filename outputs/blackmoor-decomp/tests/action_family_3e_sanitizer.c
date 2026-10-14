/* Synthetic bounds checks. Every decoder input and valid arena uses an
 * exact-size heap allocation so ASan catches reads/writes beyond that extent. */
#include "action_family_3e.h"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static uint32_t random_state = UINT32_C(0x3e123456);
static uint32_t next_random(void)
{
    random_state = random_state * UINT32_C(1664525) + UINT32_C(1013904223);
    return random_state;
}
static uint8_t *fixture(size_t primary, size_t secondary, size_t tails,
                        int conditions, size_t *length)
{
    size_t i;
    size_t cursor = 178u;
    size_t size = 180u + primary * 70u + secondary * 6u + tails * 16u;
    uint8_t *counts = malloc(primary + secondary + 1u);
    uint8_t *p;
    assert(counts != NULL);
    for (i = 0u; i < primary + secondary; ++i) {
        counts[i] = conditions < 0 ? (uint8_t)(next_random() % 5u) : (uint8_t)conditions;
        size += (size_t)counts[i] * 5u;
    }
    p = calloc(size, 1u); assert(p != NULL);
    memcpy(p, "NAME", 4u); memcpy(p + 33u, "LEFT", 4u);
    memcpy(p + 66u, "RIGHT", 5u); memcpy(p + 101u, "VOICE", 5u);
    memcpy(p + 136u, "KEY", 3u);
    p[99] = 0x34u; p[100] = 0x92u; p[134] = 0x23u; p[135] = 0x81u;
    p[169] = 0x91u; p[170] = 0x82u; p[171] = 0x73u;
    p[176] = (uint8_t)primary; p[177] = (uint8_t)(primary >> 8);
    for (i = 0u; i < primary; ++i) {
        size_t n = counts[i];
        p[cursor] = (uint8_t)n; p[cursor + 1u] = 0xa7u; cursor += 2u;
        memset(p + cursor, 0x6bu, n * 5u); cursor += n * 5u;
        memcpy(p + cursor, "KEY", 3u); memcpy(p + cursor + 33u, "CHOICE", 6u);
        p[cursor + 66u] = 0x34u; p[cursor + 67u] = 0xf1u; cursor += 68u;
    }
    p[cursor] = (uint8_t)secondary; p[cursor + 1u] = 0xb8u; cursor += 2u;
    for (i = 0u; i < secondary; ++i) {
        size_t n = counts[primary + i];
        p[cursor] = (uint8_t)n; p[cursor + 1u] = 0xc9u; cursor += 2u;
        memset(p + cursor, 0x7cu, n * 5u); cursor += n * 5u;
        memset(p + cursor, 0xf1u, 4u); cursor += 4u;
    }
    memset(p + cursor, 0xe7u, tails * 16u);
    assert(cursor + tails * 16u == size);
    free(counts); *length = size; return p;
}
/* required: 1 accepted, -1 rejected, 0 may be either. */
static void check(const uint8_t *input, size_t n, int required)
{
    uint8_t *p = malloc(n != 0u ? n : 1u);
    ActionFamily3eDecoded d, before;
    ActionFamily3eConstructed out, out_before;
    ActionFamily3eText *texts;
    uint8_t *arena;
    size_t size, count, i, length = SIZE_MAX;
    ActionFamily3eStatus status, constructed;
    assert(p != NULL); memcpy(p, input, n);
    memset(&d, 0xa5, sizeof(d)); memcpy(&before, &d, sizeof(d));
    status = action_family_3e_decode(p, n, &d);
    if (required == 1) assert(status == ACTION_FAMILY_3E_OK);
    if (required == -1) assert(status != ACTION_FAMILY_3E_OK);
    if (status != ACTION_FAMILY_3E_OK) assert(memcmp(&d, &before, sizeof(d)) == 0);
    else {
        assert(d.body_bytes <= n && (n - d.body_bytes) % 16u == 0u);
        assert(d.dependency_records == p + d.body_bytes);
        assert(d.primary_records == p + 178u);
        assert(d.secondary_records >= p && d.secondary_records <= p + n);
    }
    assert(action_family_3e_body_length(p, n, &length) == status);
    if (status != ACTION_FAMILY_3E_OK) assert(length == SIZE_MAX);
    else assert(length == d.body_bytes);
    count = status == ACTION_FAMILY_3E_OK ? (size_t)d.primary_count + 1u : 1u;
    texts = malloc(count * sizeof(*texts)); assert(texts != NULL);
    for (i = 0u; i < count; ++i) {
        texts[i].bytes = (const uint8_t *)"caption"; texts[i].length = 7u;
    }
    memset(&out, 0x6b, sizeof(out)); memcpy(&out_before, &out, sizeof(out));
    constructed = action_family_3e_construct(p, n, texts, count,
        UINT32_C(0xfffffff0), UINT32_C(0x26000000), NULL, 0u, &out);
    assert(constructed == status);
    if (status != ACTION_FAMILY_3E_OK) assert(memcmp(&out, &out_before, sizeof(out)) == 0);
    size = status == ACTION_FAMILY_3E_OK ? out.arena_bytes : ACTION_FAMILY_3E_OBJECT_BYTES;
    arena = malloc(size); assert(arena != NULL); memset(arena, 0xcd, size);
    memset(&out, 0x6b, sizeof(out)); memcpy(&out_before, &out, sizeof(out));
    constructed = action_family_3e_construct(p, n, texts, count,
        UINT32_C(0xfffffff0), UINT32_C(0x26000000), arena, size, &out);
    assert(constructed == status);
    if (status != ACTION_FAMILY_3E_OK) {
        assert(memcmp(&out, &out_before, sizeof(out)) == 0);
        for (i = 0u; i < size; ++i) assert(arena[i] == 0xcdu);
    } else assert(out.arena_bytes == size);
    free(arena); free(texts); free(p);
}
int main(void)
{
    uint8_t *p;
    size_t n, i, valid = 0u, malformed = 0u, mutations = 0u;
    p = fixture(0u, 0u, 1u, 0, &n);
    check(p, n, 1); ++valid;
    for (i = 0u; i < 180u; ++i) { check(p, i, -1); ++malformed; }
    for (i = 1u; i < 16u; ++i) { check(p, 180u + i, -1); ++malformed; }
    p[176] = 0xffu; p[177] = 0x7fu; check(p, n, -1); ++malformed;
    p[177] = 0xffu; check(p, n, -1); ++malformed; free(p);
    p = fixture(2u, 2u, 0u, 2, &n);
    for (i = 178u; i < n; ++i) { check(p, i, -1); ++malformed; } free(p);
    p = fixture(32767u, 0u, 0u, 0, &n); check(p, n, 1); ++valid; free(p);
    p = fixture(0u, 127u, 0u, 0, &n); check(p, n, 1); ++valid; free(p);
    p = fixture(1u, 1u, 0u, 127, &n); check(p, n, 1); ++valid; free(p);
    for (i = 0u; i < 20000u; ++i) {
        size_t a = next_random() % 6u, b = next_random() % 5u, t = next_random() % 5u;
        p = fixture(a, b, t, -1, &n); check(p, n, 1); ++valid; free(p);
    }
    for (i = 0u; i < 30000u; ++i) {
        size_t a = next_random() % 6u, b = next_random() % 5u, t = next_random() % 5u, k;
        p = fixture(a, b, t, -1, &n);
        for (k = 0u; k < 1u + i % 4u; ++k) p[next_random() % n] ^= (uint8_t)(1u << (next_random() % 8u));
        if (i % 3u == 0u) n = next_random() % (n + 1u);
        check(p, n, 0); ++mutations; free(p);
    }
    /* Argument failures return before fake/overlapping spans are dereferenced. */
    {
        ActionFamily3eDecoded d;
        ActionFamily3eConstructed out;
        ActionFamily3eText texts[1] = {{(const uint8_t *)"text", 4u}};
        uint8_t *arena = malloc(1957u);
        size_t size = 1u;
        assert(arena != NULL); p = fixture(0u, 0u, 0u, 0, &n);
        assert(action_family_3e_decode(p, SIZE_MAX, &d) == ACTION_FAMILY_3E_ERR_BOUNDS);
        assert(action_family_3e_decode((const uint8_t *)(UINTPTR_MAX - 15u), 180u, &d) == ACTION_FAMILY_3E_ERR_BOUNDS);
        assert(action_family_3e_decode(p, n, (ActionFamily3eDecoded *)p) == ACTION_FAMILY_3E_ERR_OVERLAP);
        assert(action_family_3e_body_length(p, n, (size_t *)p) == ACTION_FAMILY_3E_ERR_OVERLAP);
        assert(action_family_3e_decode(NULL, n, &d) == ACTION_FAMILY_3E_ERR_ARGUMENT);
        assert(action_family_3e_decode(p, n, NULL) == ACTION_FAMILY_3E_ERR_ARGUMENT);
        assert(action_family_3e_construct(p, n, texts, 1u, 50u, 1u, arena, 2u, &out) == ACTION_FAMILY_3E_ERR_CAPACITY);
        assert(action_family_3e_construct(p, n, texts, SIZE_MAX, 50u, 1u, NULL, 0u, &out) == ACTION_FAMILY_3E_ERR_BOUNDS);
        assert(action_family_3e_construct(p, n, texts, 1u, 50u, UINT32_MAX, NULL, 0u, &out) == ACTION_FAMILY_3E_ERR_BOUNDS);
        assert(action_family_3e_construct(p, n, texts, 1u, 50u, 1u, p, n, &out) == ACTION_FAMILY_3E_ERR_OVERLAP);
        texts[0].bytes = arena; texts[0].length = 4u;
        assert(action_family_3e_construct(p, n, texts, 1u, 50u, 1u, arena, 1957u, &out) == ACTION_FAMILY_3E_ERR_OVERLAP);
        assert(action_family_3e_body_length(NULL, 0u, &size) == ACTION_FAMILY_3E_ERR_ARGUMENT);
        malformed += 12u; free(arena); free(p);
    }
    printf("{\"status\":\"pass\",\"valid_cases\":%zu,\"malformed_cases\":%zu,\"bounded_mutations\":%zu}\n", valid, malformed, mutations);
    return 0;
}
