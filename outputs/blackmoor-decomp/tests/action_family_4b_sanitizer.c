#include "action_family_4b.h"

#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static size_t valid_cases, rejected_cases, pointer_checks;
static uint32_t random_state = UINT32_C(0x4b1473);

static uint32_t next_random(void)
{
    random_state ^= random_state << 13;
    random_state ^= random_state >> 17;
    random_state ^= random_state << 5;
    return random_state;
}

static uint8_t *allocate(size_t n)
{
    uint8_t *p = malloc(n == 0u ? 1u : n);
    assert(p != NULL);
    return p;
}

static uint32_t checksum(const uint8_t *p, size_t n)
{
    uint32_t value = 0u;
    for (size_t i = 0u; i < n; ++i) {
        value = value * UINT32_C(37) + p[i];
    }
    return value;
}

static int unchanged(const void *p, size_t n)
{
    const uint8_t *bytes = p;
    for (size_t i = 0u; i < n; ++i) {
        if (bytes[i] != UINT8_C(0xa5)) {
            return 0;
        }
    }
    return 1;
}

static ActionFamily4BStatus expected_status(const uint8_t *body, size_t n, size_t *typed)
{
    if (n < 2u) {
        return ACTION_FAMILY_4B_ERR_BODY;
    }
    uint32_t bits = (uint32_t)body[0] | ((uint32_t)body[1] << 8);
    int32_t selector = bits < UINT32_C(32768) ? (int32_t)bits : (int32_t)bits - INT32_C(65536);
    if (selector == -1) {
        *typed = 35u;
    } else if (selector < 0 || selector > 9999) {
        return ACTION_FAMILY_4B_ERR_COUNT;
    } else {
        *typed = (size_t)selector + 2u;
    }
    if (n < *typed) {
        return ACTION_FAMILY_4B_ERR_BODY;
    }
    if (selector == -1 && memchr(body + 2u, 0, 33u) == NULL) {
        return ACTION_FAMILY_4B_ERR_KEY;
    }
    return (n - *typed) % 16u == 0u ? ACTION_FAMILY_4B_OK : ACTION_FAMILY_4B_ERR_TAIL;
}

static void check(const uint8_t *body, size_t n)
{
    ActionFamily4BDecoded decoded;
    ActionFamily4BConstructed *out = malloc(sizeof(*out));
    size_t length = 123456u, typed = 0u;
    assert(out != NULL);
    memset(&decoded, 0xa5, sizeof(decoded));
    memset(out, 0xa5, sizeof(*out));
    uint32_t before = checksum(body, n);
    ActionFamily4BStatus expected = expected_status(body, n, &typed);
    assert(action_family_4b_decode(body, n, &decoded) == expected);
    assert(action_family_4b_body_length(body, n, &length) == expected);
    assert(action_family_4b_construct(body, n, NULL, 0u, UINT32_MAX, 7u, out) == expected);
    if (expected == ACTION_FAMILY_4B_OK) {
        assert(length == typed && decoded.body_bytes == typed);
        assert(decoded.dependency_records == body + typed);
        assert(decoded.dependency_count == (n - typed) / 16u);
        assert(out->body_bytes_consumed == typed);
        assert(out->payload_offset_after == UINT32_MAX + (uint32_t)typed);
        assert(out->result_slot_handle == 7u);
        assert(out->dependency_bytes == n - typed && out->available_body_bytes == n);
        assert(out->dependency_records == body + typed);
        if (decoded.text_selector == -1) {
            assert(out->allocation_bytes == 6u);
            assert(memcmp(out->object_bytes, "\x03\0<e>", 6u) == 0);
        } else {
            size_t text_bytes = (size_t)decoded.text_selector;
            assert(out->allocation_bytes == text_bytes + 5u);
            assert(out->object_bytes[0] == (uint8_t)((text_bytes + 3u) & 255u));
            assert(out->object_bytes[1] == (uint8_t)((text_bytes + 3u) >> 8));
            assert(memcmp(out->object_bytes + 2u, body + 2u, text_bytes) == 0);
            assert(memcmp(out->object_bytes + 2u + text_bytes, "<e>", 3u) == 0);
        }
        ++valid_cases;
    } else {
        assert(length == 123456u && unchanged(&decoded, sizeof(decoded)) && unchanged(out, sizeof(*out)));
        ++rejected_cases;
    }
    assert(checksum(body, n) == before);
    free(out);
}

static uint8_t *valid_body(int32_t selector, size_t tails, size_t *n)
{
    size_t typed = selector == -1 ? 35u : 2u + (size_t)selector;
    *n = typed + tails * 16u;
    uint8_t *body = allocate(*n);
    for (size_t i = 0u; i < *n; ++i) {
        body[i] = (uint8_t)(i * 37u + 11u);
    }
    uint16_t bits = (uint16_t)selector;
    body[0] = (uint8_t)(bits & UINT16_C(255));
    body[1] = (uint8_t)(bits >> 8);
    if (selector == -1) {
        memset(body + 2u, 'k', 33u);
        body[34] = 0u;
    }
    return body;
}

static void pointer_probes(void)
{
    size_t n;
    uint8_t *body = valid_body(-1, 0u, &n);
    ActionFamily4BDecoded d;
    ActionFamily4BConstructed *out = malloc(sizeof(*out));
    size_t length = 123456u;
    assert(out != NULL);
    memset(&d, 0xa5, sizeof(d)); memset(out, 0xa5, sizeof(*out));
#define PROBE(expression, expected) do { assert((expression) == (expected)); ++pointer_checks; } while (0)
    PROBE(action_family_4b_decode(NULL, n, &d), ACTION_FAMILY_4B_ERR_ARGUMENT);
    PROBE(action_family_4b_decode(body, n, NULL), ACTION_FAMILY_4B_ERR_ARGUMENT);
    PROBE(action_family_4b_body_length(NULL, n, &length), ACTION_FAMILY_4B_ERR_ARGUMENT);
    PROBE(action_family_4b_body_length(body, n, NULL), ACTION_FAMILY_4B_ERR_ARGUMENT);
    PROBE(action_family_4b_construct(NULL, n, NULL, 0u, 50u, 7u, out), ACTION_FAMILY_4B_ERR_ARGUMENT);
    PROBE(action_family_4b_construct(body, n, NULL, 0u, 50u, 7u, NULL), ACTION_FAMILY_4B_ERR_ARGUMENT);
    PROBE(action_family_4b_construct(body, n, NULL, 0u, 50u, 0u, out), ACTION_FAMILY_4B_ERR_ARGUMENT);
    PROBE(action_family_4b_decode(body, SIZE_MAX, &d), ACTION_FAMILY_4B_ERR_BOUNDS);
    PROBE(action_family_4b_decode((const uint8_t *)(UINTPTR_MAX - 1u), 4u, &d), ACTION_FAMILY_4B_ERR_BOUNDS);
    PROBE(action_family_4b_body_length(body, n, (size_t *)(UINTPTR_MAX - 1u)), ACTION_FAMILY_4B_ERR_BOUNDS);
    PROBE(action_family_4b_decode(body, n, (ActionFamily4BDecoded *)(UINTPTR_MAX - 1u)), ACTION_FAMILY_4B_ERR_BOUNDS);
    PROBE(action_family_4b_construct(body, n, NULL, 0u, 50u, 7u,
          (ActionFamily4BConstructed *)(UINTPTR_MAX - 1u)), ACTION_FAMILY_4B_ERR_BOUNDS);
    PROBE(action_family_4b_construct(body, n, (const uint8_t *)(UINTPTR_MAX - 1u), 4u,
          50u, 7u, out), ACTION_FAMILY_4B_ERR_BOUNDS);
    PROBE(action_family_4b_construct(body, n, NULL, 1u, 50u, 7u, out), ACTION_FAMILY_4B_ERR_TEXT);
    PROBE(action_family_4b_construct(body, n, body, 35u, 50u, 7u, out), ACTION_FAMILY_4B_ERR_TEXT);
    PROBE(action_family_4b_construct(body, n, (const uint8_t *)out, 1u, 50u, 7u, out), ACTION_FAMILY_4B_ERR_OVERLAP);
    assert(unchanged(&d, sizeof(d)) && unchanged(out, sizeof(*out)) && length == 123456u);
    uint8_t *overlap = allocate(sizeof(*out) + 64u);
    memset(overlap, 0xa5, sizeof(*out) + 64u);
    overlap[0] = 0xffu; overlap[1] = 0xffu; overlap[34] = 0u;
    uint32_t before = checksum(overlap, sizeof(*out) + 64u);
    PROBE(action_family_4b_decode(overlap, 35u, (ActionFamily4BDecoded *)overlap), ACTION_FAMILY_4B_ERR_OVERLAP);
    PROBE(action_family_4b_body_length(overlap, 35u, (size_t *)overlap), ACTION_FAMILY_4B_ERR_OVERLAP);
    PROBE(action_family_4b_construct(overlap, 35u, NULL, 0u, 50u, 7u,
          (ActionFamily4BConstructed *)overlap), ACTION_FAMILY_4B_ERR_OVERLAP);
    assert(checksum(overlap, sizeof(*out) + 64u) == before);
    free(overlap); free(out); free(body);
#undef PROBE
}

int main(void)
{
    /* Each advertised valid extent has exactly that many heap bytes. */
    for (uint32_t bits = 0u; bits <= UINT32_C(65535); ++bits) {
        int32_t selector = bits < UINT32_C(32768) ? (int32_t)bits : (int32_t)bits - INT32_C(65536);
        size_t n;
        uint8_t *body;
        if (selector == -1 || (selector >= 0 && selector <= 9999)) {
            body = valid_body(selector, bits % 3u, &n);
        } else {
            n = 2u;
            body = allocate(n);
            body[0] = (uint8_t)(bits & UINT32_C(255)); body[1] = (uint8_t)(bits >> 8);
        }
        check(body, n);
        free(body);
    }
    for (int32_t selector = -1; selector <= 20; ++selector) {
        size_t full;
        uint8_t *valid = valid_body(selector, 0u, &full);
        for (size_t n = 0u; n < full; ++n) {
            uint8_t *short_body = allocate(n);
            if (n != 0u) { memcpy(short_body, valid, n); }
            check(short_body, n); free(short_body);
        }
        for (size_t tail = 1u; tail <= 40u; ++tail) {
            size_t n = full + tail;
            uint8_t *body = allocate(n);
            memcpy(body, valid, full); memset(body + full, 0x91, tail);
            check(body, n); free(body);
        }
        free(valid);
    }
    /* 30,000 bounded mutations; no padded backing hides a short read. */
    for (size_t i = 0u; i < 30000u; ++i) {
        size_t full;
        int32_t selector = i % 7u == 0u ? -1 : (int32_t)(next_random() % 64u);
        uint8_t *valid = valid_body(selector, next_random() % 4u, &full);
        size_t n = i % 3u == 0u ? next_random() % (full + 1u) : full;
        uint8_t *body = allocate(n);
        if (n != 0u) {
            memcpy(body, valid, n);
            body[next_random() % n] ^= (uint8_t)(1u + next_random() % 255u);
        }
        check(body, n); free(body); free(valid);
    }
    /* Signed allocation boundary and exact-size resolved buffers. */
    size_t n;
    uint8_t *body = valid_body(-1, 0u, &n);
    ActionFamily4BConstructed *out = malloc(sizeof(*out));
    assert(out != NULL);
    const size_t lengths[] = {0u, 1u, 32761u, 32762u, 40000u};
    for (size_t i = 0u; i < sizeof(lengths) / sizeof(lengths[0]); ++i) {
        size_t length = lengths[i];
        uint8_t *text = allocate(length);
        memset(text, 'z', length); memset(out, 0xa5, sizeof(*out));
        ActionFamily4BStatus got = action_family_4b_construct(body, n, text, length, 50u, 7u, out);
        if (length <= 32761u) {
            assert(got == ACTION_FAMILY_4B_OK && out->allocation_bytes == length + 6u);
            assert(memcmp(out->object_bytes + 2u, text, length) == 0);
            assert(memcmp(out->object_bytes + 2u + length, "<e>", 4u) == 0);
            ++valid_cases;
        } else {
            assert(got == ACTION_FAMILY_4B_ERR_TEXT && unchanged(out, sizeof(*out)));
            ++rejected_cases;
        }
        free(text);
    }
    free(body); free(out);
    pointer_probes();
    printf("{\"status\":\"pass\",\"valid_cases\":%zu,\"rejected_cases\":%zu,"
           "\"bounded_mutations\":30000,\"selector_patterns\":65536,\"pointer_checks\":%zu}\n",
           valid_cases, rejected_cases, pointer_checks);
    return 0;
}
