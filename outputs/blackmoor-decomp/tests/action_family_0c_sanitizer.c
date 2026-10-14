/* Exact-size heap inputs expose overreads to ASan. No original/resource bytes. */
#include "action_family_0c.h"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static size_t checks;
static void put_word(uint8_t *p, uint16_t n)
{
    p[0] = (uint8_t)n;
    p[1] = (uint8_t)(n >> 8);
}

static void reject(const uint8_t *input, size_t length, ActionFamily0cStatus expected)
{
    ActionFamily0cDecoded decoded, before_d;
    ActionFamily0cConstructed constructed, before_c;
    ActionFamily0cRecord18 record, before_r;
    size_t extent = 0xa5a5u;
    uint8_t *object = malloc(10u);
    assert(object != NULL);
    memset(object, 0xcd, 10u);
    memset(&decoded, 0xa5, sizeof(decoded));
    memcpy(&before_d, &decoded, sizeof(decoded));
    memset(&constructed, 0xa5, sizeof(constructed));
    memcpy(&before_c, &constructed, sizeof(constructed));
    memset(&record, 0xa5, sizeof(record));
    memcpy(&before_r, &record, sizeof(record));
    assert(action_family_0c_decode(input, length, &decoded) == expected);
    assert(memcmp(&before_d, &decoded, sizeof(decoded)) == 0);
    assert(action_family_0c_body_length(input, length, &extent) == expected);
    assert(extent == 0xa5a5u);
    assert(action_family_0c_record18_at(input, length, 0u, &record) == expected);
    assert(memcmp(&before_r, &record, sizeof(record)) == 0);
    assert(action_family_0c_construct(input, length, 50u, 1u, object, 10u, &constructed) == expected);
    assert(memcmp(&before_c, &constructed, sizeof(constructed)) == 0);
    for (size_t i = 0u; i < 10u; ++i) { assert(object[i] == 0xcdu); }
    checks += 4u;
    free(object);
}

int main(void)
{
    const uint16_t counts[] = {0u, 1u, 3u, 20u, 100u, 1818u, 1819u};
    size_t valid = 0u, truncated = 0u, ragged = 0u, invalid_counts = 0u;
    for (size_t c = 0u; c < sizeof(counts) / sizeof(counts[0]); ++c) {
        size_t typed = 10u + 18u * counts[c];
        for (size_t tail = 0u; tail <= 40u; ++tail) {
            size_t length = typed + tail;
            uint8_t *raw = malloc(length); /* exactly the declared input extent */
            assert(raw != NULL);
            for (size_t i = 0u; i < length; ++i) { raw[i] = (uint8_t)(i * 37u + 11u); }
            put_word(raw + 8u, counts[c]);
            if (tail % 16u != 0u) {
                reject(raw, length, ACTION_FAMILY_0C_ERR_TAIL);
                ++ragged;
            } else {
                uint8_t *object = malloc(typed); /* exact allocation, no spare bytes */
                ActionFamily0cDecoded d;
                ActionFamily0cConstructed out;
                ActionFamily0cRecord18 row;
                size_t extent;
                assert(object != NULL);
                assert(action_family_0c_decode(raw, length, &d) == ACTION_FAMILY_0C_OK);
                assert(action_family_0c_body_length(raw, length, &extent) == ACTION_FAMILY_0C_OK);
                assert(extent == typed && d.body_bytes == typed && d.count_18 == (int16_t)counts[c]);
                assert(d.records_18 == raw + 10u && d.dependency_records == raw + typed);
                assert(d.dependency_count == tail / 16u && d.dependency_bytes == tail);
                assert(action_family_0c_construct(raw, length, UINT32_MAX, 1u, object, typed, &out) == ACTION_FAMILY_0C_OK);
                assert(memcmp(raw, object, typed) == 0 && out.payload_offset_after == typed - 1u);
                if (counts[c] != 0u) {
                    assert(action_family_0c_record18_at(raw, length, counts[c] - 1u, &row) == ACTION_FAMILY_0C_OK);
                }
                memset(&row, 0xa5, sizeof(row));
                ActionFamily0cRecord18 before;
                memcpy(&before, &row, sizeof(row));
                assert(action_family_0c_record18_at(raw, length, counts[c], &row) == ACTION_FAMILY_0C_ERR_INDEX);
                assert(memcmp(&before, &row, sizeof(row)) == 0);
                memset(object, 0xcd, typed);
                memset(&out, 0xa5, sizeof(out));
                ActionFamily0cConstructed before_out;
                memcpy(&before_out, &out, sizeof(out));
                assert(action_family_0c_construct(raw, length, 50u, 1u, object, typed - 1u, &out) == ACTION_FAMILY_0C_ERR_CAPACITY);
                assert(memcmp(&before_out, &out, sizeof(out)) == 0);
                for (size_t i = 0u; i < typed; ++i) { assert(object[i] == 0xcdu); }
                checks += 6u;
                ++valid;
                free(object);
            }
            free(raw);
        }
        /* Every short extent for each count: allocations have no padded backing. */
        for (size_t length = 0u; length < typed; ++length) {
            uint8_t *raw = malloc(length == 0u ? 1u : length);
            assert(raw != NULL);
            memset(raw, 0, length == 0u ? 1u : length);
            if (length >= 10u) { put_word(raw + 8u, counts[c]); }
            reject(raw, length, ACTION_FAMILY_0C_ERR_BODY);
            ++truncated;
            free(raw);
        }
    }
    const uint16_t unsafe[] = {1820u, 3641u, 32767u, 32768u, 65535u};
    for (size_t i = 0u; i < sizeof(unsafe) / sizeof(unsafe[0]); ++i) {
        uint8_t *raw = calloc(10u, 1u);
        assert(raw != NULL);
        put_word(raw + 8u, unsafe[i]);
        reject(raw, 10u, ACTION_FAMILY_0C_ERR_COUNT);
        ++invalid_counts;
        free(raw);
    }
    reject(NULL, 10u, ACTION_FAMILY_0C_ERR_ARGUMENT);
    reject((const uint8_t *)(uintptr_t)UINTPTR_MAX, 10u, ACTION_FAMILY_0C_ERR_BOUNDS);
    uint8_t *raw = calloc(10u, 1u);
    assert(raw != NULL);
    reject(raw, SIZE_MAX, ACTION_FAMILY_0C_ERR_BOUNDS);
    /* Output aliases are rejected before any cast output is dereferenced. */
    assert(action_family_0c_decode(raw, 10u, (ActionFamily0cDecoded *)(void *)raw) == ACTION_FAMILY_0C_ERR_OVERLAP);
    assert(action_family_0c_body_length(raw, 10u, (size_t *)(void *)raw) == ACTION_FAMILY_0C_ERR_OVERLAP);
    assert(action_family_0c_record18_at(raw, 10u, 0u, (ActionFamily0cRecord18 *)(void *)raw) == ACTION_FAMILY_0C_ERR_OVERLAP);
    ActionFamily0cConstructed out;
    assert(action_family_0c_construct(raw, 10u, 50u, 1u, raw, 10u, &out) == ACTION_FAMILY_0C_ERR_OVERLAP);
    assert(action_family_0c_construct(raw, 10u, 50u, 0u, raw, 10u, &out) == ACTION_FAMILY_0C_ERR_ARGUMENT);
    free(raw);
    checks += 5u;
    printf("{\"status\":\"pass\",\"checks\":%zu,\"valid_exact_heap_cases\":%zu,\"short_exact_heap_cases\":%zu,\"ragged_cases\":%zu,\"invalid_count_cases\":%zu}\n",
           checks, valid, truncated, ragged, invalid_counts);
    return 0;
}
