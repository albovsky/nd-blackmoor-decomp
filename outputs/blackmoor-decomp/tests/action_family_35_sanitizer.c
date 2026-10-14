/* Exact input allocations, malformed count sweep and transactional failures. */
#include "action_family_35.h"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static size_t cases;
static size_t rejected;
static size_t accepted;

static void put16(uint8_t *p, uint16_t n)
{
    p[0] = (uint8_t)n;
    p[1] = (uint8_t)(n >> 8);
}

static void check(const uint8_t *data, size_t length)
{
    uint8_t *input = malloc(length == 0u ? 1u : length);
    uint8_t *object = malloc(ACTION_FAMILY_35_MAX_BODY_BYTES + 16u);
    ActionFamily35Decoded decoded;
    ActionFamily35Constructed constructed;
    ActionFamily35Record6 r6;
    ActionFamily35Record34 r34;
    uint8_t dec_before[sizeof(decoded)];
    uint8_t meta_before[sizeof(constructed)];
    uint8_t r6_before[sizeof(r6)];
    uint8_t r34_before[sizeof(r34)];
    ActionFamily35Status status;
    ActionFamily35Status cs;
    size_t i;
    assert(input != NULL && object != NULL);
    memcpy(input, data, length);
    memset(object, 0xa5, ACTION_FAMILY_35_MAX_BODY_BYTES + 16u);
    memset(&decoded, 0xa5, sizeof(decoded));
    memset(&constructed, 0xa5, sizeof(constructed));
    memset(&r6, 0xa5, sizeof(r6));
    memset(&r34, 0xa5, sizeof(r34));
    memcpy(dec_before, &decoded, sizeof(decoded));
    memcpy(meta_before, &constructed, sizeof(constructed));
    memcpy(r6_before, &r6, sizeof(r6));
    memcpy(r34_before, &r34, sizeof(r34));
    status = action_family_35_decode(input, length, &decoded);
    cs = action_family_35_construct(input, length, UINT32_MAX - 15u, 1u,
        object, ACTION_FAMILY_35_MAX_BODY_BYTES + 16u, &constructed);
    assert(status == cs);
    assert(memcmp(input, data, length) == 0);
    if (status != ACTION_FAMILY_35_OK) {
        assert(memcmp(&decoded, dec_before, sizeof(decoded)) == 0);
        assert(memcmp(&constructed, meta_before, sizeof(constructed)) == 0);
        assert(action_family_35_record6_at(input, length, 0u, &r6) == status);
        assert(action_family_35_record34_at(input, length, 0u, &r34) == status);
        assert(memcmp(&r6, r6_before, sizeof(r6)) == 0);
        assert(memcmp(&r34, r34_before, sizeof(r34)) == 0);
        ++rejected;
    } else {
        assert(decoded.body_bytes == constructed.allocation_bytes);
        assert(decoded.body_bytes <= length);
        assert(memcmp(object, data, decoded.body_bytes) == 0);
        assert(constructed.payload_offset_after == UINT32_MAX - 15u + (uint32_t)decoded.body_bytes);
        assert(action_family_35_record6_at(input, length, (size_t)decoded.count_6, &r6) == ACTION_FAMILY_35_ERR_INDEX);
        assert(action_family_35_record34_at(input, length, (size_t)decoded.count_34, &r34) == ACTION_FAMILY_35_ERR_INDEX);
        assert(memcmp(&r6, r6_before, sizeof(r6)) == 0);
        assert(memcmp(&r34, r34_before, sizeof(r34)) == 0);
        ++accepted;
    }
    for (i = status == ACTION_FAMILY_35_OK ? constructed.allocation_bytes : 0u;
            i < ACTION_FAMILY_35_MAX_BODY_BYTES + 16u; ++i) {
        assert(object[i] == 0xa5u);
    }
    ++cases;
    free(object);
    free(input);
}

static void small_reject(const uint8_t *data, size_t length, ActionFamily35Status expected)
{
    uint8_t *input = malloc(length);
    uint8_t object[256];
    uint8_t before[256];
    ActionFamily35Decoded d;
    ActionFamily35Constructed c;
    uint8_t db[sizeof(d)];
    uint8_t cb[sizeof(c)];
    assert(input != NULL);
    memcpy(input, data, length);
    memset(object, 0xa5, sizeof(object));memcpy(before, object, sizeof(object));
    memset(&d, 0xa5, sizeof(d));memcpy(db, &d, sizeof(d));
    memset(&c, 0xa5, sizeof(c));memcpy(cb, &c, sizeof(c));
    assert(action_family_35_decode(input, length, &d) == expected);
    assert(action_family_35_construct(input, length, 50u, 1u, object, sizeof(object), &c) == expected);
    assert(memcmp(input, data, length) == 0 && memcmp(object, before, sizeof(object)) == 0);
    assert(memcmp(&d, db, sizeof(d)) == 0 && memcmp(&c, cb, sizeof(c)) == 0);
    ++cases;++rejected;
    free(input);
}

int main(void)
{
    uint8_t data[256];
    uint8_t *maximum;
    size_t i;
    uint32_t value;
    uint32_t rng = 0x351035u;
    memset(data, 0, sizeof(data));
    put16(data + 59u, 3u);put16(data + 79u, 4u);
    for (i = 0u; i < 256u; ++i) {
        check(data, i);
    }
    /* All 16-bit encodings, with exact short declared source extents. */
    for (value = 0u; value <= UINT16_MAX; ++value) {
        put16(data + 59u, (uint16_t)value);
        small_reject(data, 61u, value > 32767u ? ACTION_FAMILY_35_ERR_COUNT : ACTION_FAMILY_35_ERR_BODY);
        put16(data + 59u, 0u);put16(data + 61u, (uint16_t)value);
        if (value == 0u) {
            check(data, 63u);
        } else {
            small_reject(data, 63u, value > 32767u ? ACTION_FAMILY_35_ERR_COUNT : ACTION_FAMILY_35_ERR_BODY);
        }
    }
    /* Reproducible malformed/valid inputs in bounded exact allocations. */
    for (i = 0u; i < 2048u; ++i) {
        size_t j;
        size_t len;
        rng = rng * 1664525u + 1013904223u;len = rng % sizeof(data);
        for (j = 0u; j < len; ++j) {
            rng = rng * 1664525u + 1013904223u;data[j] = (uint8_t)(rng >> 24);
        }
        check(data, len);
    }
    maximum = calloc(ACTION_FAMILY_35_MAX_BODY_BYTES + 16u, 1u);
    assert(maximum != NULL);
    put16(maximum + 59u, 32767u);
    put16(maximum + 61u + 6u * 32767u, 32767u);
    check(maximum, ACTION_FAMILY_35_MAX_BODY_BYTES + 16u);
    free(maximum);
    /* Null, capacity, range, wrapped address and overlap safety. */
    {
        ActionFamily35Decoded d;
        ActionFamily35Constructed c;
        uint8_t db[sizeof(d)];uint8_t cb[sizeof(c)];uint8_t before[sizeof(data)];
        memset(data, 0, sizeof(data));memcpy(before, data, sizeof(data));
        memset(&d, 0xa5, sizeof(d));memcpy(db, &d, sizeof(d));
        memset(&c, 0xa5, sizeof(c));memcpy(cb, &c, sizeof(c));
        assert(action_family_35_decode(NULL, 63u, &d) == ACTION_FAMILY_35_ERR_ARGUMENT);
        assert(action_family_35_decode(data, 63u, NULL) == ACTION_FAMILY_35_ERR_ARGUMENT);
        assert(action_family_35_decode((const uint8_t *)(UINTPTR_MAX - 31u), 63u, &d) == ACTION_FAMILY_35_ERR_BOUNDS);
        assert(action_family_35_decode(data, SIZE_MAX, &d) == ACTION_FAMILY_35_ERR_BOUNDS);
        assert(action_family_35_decode(data, 63u, (ActionFamily35Decoded *)(void *)data) == ACTION_FAMILY_35_ERR_OVERLAP);
        assert(action_family_35_construct(data, 63u, 50u, 1u, data+128u, 62u, &c) == ACTION_FAMILY_35_ERR_CAPACITY);
        assert(action_family_35_construct(data, 63u, 50u, 1u, data, 63u, &c) == ACTION_FAMILY_35_ERR_OVERLAP);
        assert(action_family_35_construct(data, 63u, 50u, 1u, data+128u, 128u,
            (ActionFamily35Constructed *)(void *)(data+128u)) == ACTION_FAMILY_35_ERR_OVERLAP);
        assert(memcmp(data, before, sizeof(data)) == 0);
        assert(memcmp(&d, db, sizeof(d)) == 0 && memcmp(&c, cb, sizeof(c)) == 0);
        cases += 8u;rejected += 8u;
    }
    printf("{\"cases\":%zu,\"accepted\":%zu,\"rejected\":%zu,\"sanitizers\":\"ASan+UBSan\",\"status\":\"pass\"}\n", cases, accepted, rejected);
    return 0;
}
