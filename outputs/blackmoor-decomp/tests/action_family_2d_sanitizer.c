/* Exact-size heap storage for valid, truncated, ragged and count-corrupted raw-0x2d bodies.
 * Every case is judged by an independent reference walk written in this file. */
#include "action_family_2d.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static size_t valid_cases;
static size_t rejected_cases;
static size_t pointer_checks;
static size_t construct_cases;
static uint32_t random_state = UINT32_C(0x2d0b17e1);

static uint32_t next_random(void)
{
    random_state = random_state * UINT32_C(1664525) + UINT32_C(1013904223);
    return random_state;
}

static int16_t get_i16(const uint8_t *p)
{
    return (int16_t)((uint16_t)p[0] | ((uint16_t)p[1] << 8));
}

static void put_i16(uint8_t *p, int16_t v)
{
    p[0] = (uint8_t)(uint16_t)v;
    p[1] = (uint8_t)((uint16_t)v >> 8);
}

/* Reference: returns the expected status and, when OK, the typed length. */
static ActionFamily2DStatus reference(const uint8_t *raw, size_t length, size_t *typed,
                                      size_t *entries_out, size_t *total_out, size_t *groups_out)
{
    size_t cursor = 39u;
    size_t total = 0u;
    int16_t a;
    int16_t b;
    if (length < 39u) {
        return ACTION_FAMILY_2D_ERR_BODY;
    }
    a = get_i16(raw + 0x23);
    b = get_i16(raw + 0x25);
    if (a < 0 || b < 0) {
        return ACTION_FAMILY_2D_ERR_COUNT;
    }
    for (int i = 0; i < a; ++i) {
        int16_t n;
        if (cursor + 49u > length) {
            return ACTION_FAMILY_2D_ERR_BODY;
        }
        n = get_i16(raw + cursor + 0x2f);
        if (n < 0) {
            return ACTION_FAMILY_2D_ERR_COUNT;
        }
        if (cursor + 49u + 35u * (size_t)n > length) {
            return ACTION_FAMILY_2D_ERR_BODY;
        }
        cursor += 49u + 35u * (size_t)n;
        total += (size_t)n;
    }
    cursor += 34u * (size_t)b;
    if (cursor > length) {
        return ACTION_FAMILY_2D_ERR_BODY;
    }
    if ((length - cursor) % 16u != 0u) {
        return ACTION_FAMILY_2D_ERR_TAIL;
    }
    *typed = cursor;
    *entries_out = (size_t)a;
    *total_out = total;
    *groups_out = (size_t)b;
    return ACTION_FAMILY_2D_OK;
}

static void check_case(const uint8_t *source, size_t length)
{
    size_t allocation = length == 0u ? 1u : length;
    uint8_t *raw = malloc(allocation);
    uint8_t *before = malloc(allocation);
    ActionFamily2DDecoded d, d_before;
    ActionFamily2DEntry e, e_before;
    ActionFamily2DRecord35 r35, r35_before;
    ActionFamily2DRecord34 r34, r34_before;
    ActionFamily2DConstructed c, c_before;
    size_t typed = SIZE_MAX;
    size_t expected_typed = 0u, entries = 0u, total = 0u, groups = 0u;
    ActionFamily2DStatus expected;
    ActionFamily2DStatus status;
    uint32_t offset = next_random();
    assert(raw != NULL && before != NULL);
    memcpy(raw, source, length);
    memcpy(before, raw, length);
    memset(&d, 0xa5, sizeof(d)); memcpy(&d_before, &d, sizeof(d));
    memset(&e, 0xa5, sizeof(e)); memcpy(&e_before, &e, sizeof(e));
    memset(&r35, 0xa5, sizeof(r35)); memcpy(&r35_before, &r35, sizeof(r35));
    memset(&r34, 0xa5, sizeof(r34)); memcpy(&r34_before, &r34, sizeof(r34));
    memset(&c, 0x5a, sizeof(c)); memcpy(&c_before, &c, sizeof(c));
    expected = reference(raw, length, &expected_typed, &entries, &total, &groups);
    assert(action_family_2d_decode(raw, length, &d) == expected);
    assert(action_family_2d_body_length(raw, length, &typed) == expected);
    status = action_family_2d_entry_at(raw, length, 0u, &e);
    assert(expected != ACTION_FAMILY_2D_OK ? status == expected :
           status == (entries == 0u ? ACTION_FAMILY_2D_ERR_INDEX : ACTION_FAMILY_2D_OK));
    status = action_family_2d_record35_at(raw, length, 0u, 0u, &r35);
    if (expected != ACTION_FAMILY_2D_OK) {
        assert(status == expected);
    }
    status = action_family_2d_record34_at(raw, length, 0u, &r34);
    assert(expected != ACTION_FAMILY_2D_OK ? status == expected :
           status == (groups == 0u ? ACTION_FAMILY_2D_ERR_INDEX : ACTION_FAMILY_2D_OK));
    if (expected == ACTION_FAMILY_2D_OK) {
        size_t image_bytes = 39u + 53u * entries + 35u * total + 34u * groups;
        size_t handle_count = 3u + entries;
        uint32_t *handles = malloc(handle_count * sizeof(*handles));
        uint8_t *image = malloc(image_bytes);
        uint8_t *small = malloc(image_bytes);
        assert(handles != NULL && image != NULL && small != NULL);
        for (size_t i = 0u; i < handle_count; ++i) {
            handles[i] = UINT32_C(0x600001) + (uint32_t)(i * 64u);
        }
        assert(typed == expected_typed && d.body_bytes == typed && d.available_body_bytes == length);
        assert(d.dependency_records == raw + typed && d.dependency_bytes == length - typed);
        assert(d.dependency_count == (length - typed) / 16u);
        assert((size_t)d.entry_count == entries && d.record35_total == total &&
               (size_t)d.record34_count == groups);
        assert(memcmp(d.name, raw, 33u) == 0);
        assert(d.entries == raw + 39u && d.records_34 == raw + typed - 34u * groups);
        if (entries > 0u) {
            assert(e.records_35 == raw + 39u + 49u && memcmp(e.name, raw + 39u, 33u) == 0);
            assert(e.records_35_bytes == 35u * (size_t)e.record35_count);
        }
        if (entries > 0u && e.record35_count > 0) {
            assert(action_family_2d_record35_at(raw, length, 0u, 0u, &r35) == ACTION_FAMILY_2D_OK);
            assert(memcmp(r35.bytes, raw + 39u + 49u, 35u) == 0);
            assert(action_family_2d_record35_at(raw, length, 0u, (size_t)e.record35_count, &r35)
                   == ACTION_FAMILY_2D_ERR_INDEX);
        }
        assert(action_family_2d_entry_at(raw, length, entries, &e) == ACTION_FAMILY_2D_ERR_INDEX);
        assert(action_family_2d_record34_at(raw, length, groups, &r34) == ACTION_FAMILY_2D_ERR_INDEX);
        assert(action_family_2d_construct(raw, length, offset, (int16_t)offset, handles, handle_count,
                                          image, image_bytes, &c) == ACTION_FAMILY_2D_OK);
        assert(c.image_bytes == image_bytes && c.allocation_count == handle_count);
        assert(c.payload_offset_after == offset + (uint32_t)typed);
        assert(c.owner_action_index == (int32_t)(int16_t)offset);
        assert(memcmp(image, raw, 39u) == 0);
        assert(c.result_slot_handle == handles[0] && c.owner_entry_table_handle == handles[1] &&
               c.owner_group_handle == handles[handle_count - 1u]);
        if (image_bytes > 0u) {
            memset(&c_before, 0x5a, sizeof(c_before));
            memset(&c, 0x5a, sizeof(c));
            assert(action_family_2d_construct(raw, length, offset, 0, handles, handle_count, small,
                                              image_bytes - 1u, &c) == ACTION_FAMILY_2D_ERR_CAPACITY);
            assert(memcmp(&c, &c_before, sizeof(c)) == 0);
            assert(action_family_2d_construct(raw, length, offset, 0, handles, handle_count - 1u, small,
                                              image_bytes, &c) == ACTION_FAMILY_2D_ERR_ARGUMENT);
            handles[handle_count - 1u] = 0u;
            assert(action_family_2d_construct(raw, length, offset, 0, handles, handle_count, small,
                                              image_bytes, &c) == ACTION_FAMILY_2D_ERR_ARGUMENT);
            assert(memcmp(&c, &c_before, sizeof(c)) == 0);
        }
        free(small);
        free(image);
        free(handles);
        ++construct_cases;
        ++valid_cases;
    } else {
        uint32_t handles[8] = {1u, 2u, 3u, 4u, 5u, 6u, 7u, 8u};
        uint8_t image[4096];
        assert(typed == SIZE_MAX);
        assert(action_family_2d_construct(raw, length, offset, 1, handles, 8u, image, sizeof(image), &c)
               == expected);
        assert(memcmp(&d, &d_before, sizeof(d)) == 0 && memcmp(&c, &c_before, sizeof(c)) == 0);
        assert(memcmp(&e, &e_before, sizeof(e)) == 0 && memcmp(&r34, &r34_before, sizeof(r34)) == 0);
        assert(memcmp(&r35, &r35_before, sizeof(r35)) == 0);
        ++rejected_cases;
    }
    assert(memcmp(raw, before, length) == 0);
    free(before);
    free(raw);
}

/* Build a valid body with the given counts into a fresh heap buffer. */
static uint8_t *build(size_t entries, const uint16_t *record35, size_t groups, size_t tail_rows,
                      size_t *length_out)
{
    size_t length = 39u + 34u * groups + 16u * tail_rows;
    uint8_t *body;
    size_t cursor = 39u;
    for (size_t i = 0u; i < entries; ++i) {
        length += 49u + 35u * record35[i];
    }
    body = malloc(length);
    assert(body != NULL);
    for (size_t i = 0u; i < length; ++i) {
        body[i] = (uint8_t)(next_random() >> 16);
    }
    put_i16(body + 0x23, (int16_t)entries);
    put_i16(body + 0x25, (int16_t)groups);
    for (size_t i = 0u; i < entries; ++i) {
        put_i16(body + cursor + 0x2f, (int16_t)record35[i]);
        cursor += 49u + 35u * record35[i];
    }
    *length_out = length;
    return body;
}

static void check_pointers(void)
{
    uint16_t counts[2] = {2u, 1u};
    size_t length;
    uint8_t *raw = build(2u, counts, 1u, 0u, &length);
    ActionFamily2DDecoded d, d_before;
    ActionFamily2DConstructed c, c_before;
    uint32_t handles[5] = {1u, 2u, 3u, 4u, 5u};
    uint8_t image[1024];
    size_t typed = SIZE_MAX;
    memset(&d, 0xa5, sizeof(d)); memcpy(&d_before, &d, sizeof(d));
    memset(&c, 0x5a, sizeof(c)); memcpy(&c_before, &c, sizeof(c));
    assert(action_family_2d_decode(NULL, length, &d) == ACTION_FAMILY_2D_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_2d_decode(raw, length, NULL) == ACTION_FAMILY_2D_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_2d_body_length(NULL, length, &typed) == ACTION_FAMILY_2D_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_2d_body_length(raw, length, NULL) == ACTION_FAMILY_2D_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_2d_construct(NULL, length, 0u, 1, handles, 5u, image, sizeof(image), &c)
           == ACTION_FAMILY_2D_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_2d_construct(raw, length, 0u, 1, NULL, 5u, image, sizeof(image), &c)
           == ACTION_FAMILY_2D_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_2d_construct(raw, length, 0u, 1, handles, 5u, NULL, sizeof(image), &c)
           == ACTION_FAMILY_2D_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_2d_construct(raw, length, 0u, 1, handles, 5u, image, sizeof(image), NULL)
           == ACTION_FAMILY_2D_ERR_ARGUMENT); ++pointer_checks;
    assert(action_family_2d_decode((const uint8_t *)UINTPTR_MAX, length, &d) == ACTION_FAMILY_2D_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_2d_decode(raw, SIZE_MAX, &d) == ACTION_FAMILY_2D_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_2d_body_length(raw, SIZE_MAX, &typed) == ACTION_FAMILY_2D_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_2d_decode(raw, length, (ActionFamily2DDecoded *)UINTPTR_MAX) == ACTION_FAMILY_2D_ERR_BOUNDS);
    ++pointer_checks;
    assert(action_family_2d_construct(raw, length, 0u, 1, handles, SIZE_MAX, image, sizeof(image), &c)
           == ACTION_FAMILY_2D_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_2d_construct(raw, length, 0u, 1, handles, 5u, (uint8_t *)UINTPTR_MAX, sizeof(image), &c)
           == ACTION_FAMILY_2D_ERR_BOUNDS); ++pointer_checks;
    assert(action_family_2d_decode((const uint8_t *)&d + 1u, length, &d) == ACTION_FAMILY_2D_ERR_OVERLAP); ++pointer_checks;
    assert(action_family_2d_body_length(raw, length, (size_t *)(void *)raw) == ACTION_FAMILY_2D_ERR_OVERLAP); ++pointer_checks;
    assert(action_family_2d_construct(raw, length, 0u, 1, handles, 5u, raw + 10, 512u, &c)
           == ACTION_FAMILY_2D_ERR_OVERLAP); ++pointer_checks;
    assert(typed == SIZE_MAX);
    assert(memcmp(&d, &d_before, sizeof(d)) == 0 && memcmp(&c, &c_before, sizeof(c)) == 0);
    free(raw);
}

int main(void)
{
    static const uint16_t shapes[][6] = {
        {0, 0, 0, 0, 0, 0}, {1, 0, 0, 0, 0, 0}, {2, 3, 0, 0, 0, 0}, {4, 3, 4, 3, 0, 0}, {0, 0, 0, 0, 0, 5},
        {1, 2, 3, 4, 5, 6},
    };
    static const size_t shape_entries[] = {0u, 1u, 2u, 4u, 6u, 6u};
    /* Every prefix and a bounded tail grid of every shape (exact-size heap storage). */
    for (size_t s = 0u; s < sizeof(shapes) / sizeof(shapes[0]); ++s) {
        for (size_t groups = 0u; groups <= 3u; ++groups) {
            for (size_t tail_rows = 0u; tail_rows <= 2u; ++tail_rows) {
                size_t length;
                uint8_t *body = build(shape_entries[s], shapes[s], groups, tail_rows, &length);
                for (size_t cut = 0u; cut <= length; ++cut) {
                    check_case(body, cut);
                }
                for (size_t extra = 1u; extra <= 40u; ++extra) {
                    uint8_t *longer = malloc(length + extra);
                    assert(longer != NULL);
                    memcpy(longer, body, length);
                    memset(longer + length, 0x6b, extra);
                    check_case(longer, length + extra);
                    free(longer);
                }
                free(body);
            }
        }
    }
    /* Every signed-16 count pattern for each of the three counts. */
    for (uint32_t word = 0u; word <= UINT16_MAX; ++word) {
        uint16_t counts[2] = {1u, 2u};
        size_t length;
        uint8_t *body = build(2u, counts, 1u, 1u, &length);
        put_i16(body + 0x23, (int16_t)word);
        check_case(body, length);
        put_i16(body + 0x23, 2);
        put_i16(body + 0x25, (int16_t)word);
        check_case(body, length);
        put_i16(body + 0x25, 1);
        put_i16(body + 39 + 0x2f, (int16_t)word);
        check_case(body, length);
        put_i16(body + 39 + 0x2f, 1);
        put_i16(body + 39 + 49 + 35 + 0x2f, (int16_t)word);
        check_case(body, length);
        free(body);
    }
    /* Bounded random mutations: flip bytes of valid bodies, count positions included. */
    for (size_t i = 0u; i < 30000u; ++i) {
        uint16_t counts[4];
        size_t entries = next_random() % 5u;
        size_t length;
        uint8_t *body;
        for (size_t k = 0u; k < 4u; ++k) {
            counts[k] = (uint16_t)(next_random() % 6u);
        }
        body = build(entries, counts, next_random() % 4u, next_random() % 3u, &length);
        for (size_t flips = next_random() % 4u; flips > 0u; --flips) {
            body[next_random() % length] = (uint8_t)next_random();
        }
        check_case(body, (next_random() & 1u) != 0u ? length : (size_t)(next_random() % (length + 1u)));
        free(body);
    }
    /* Maximum counts. */
    {
        size_t length;
        uint16_t *counts = calloc(32767u, sizeof(*counts));
        uint8_t *body;
        assert(counts != NULL);
        body = build(32767u, counts, 0u, 0u, &length);
        check_case(body, length);
        free(body);
        free(counts);
        counts = calloc(1u, sizeof(*counts));
        assert(counts != NULL);
        counts[0] = 32767u;
        body = build(1u, counts, 32767u, 0u, &length);
        check_case(body, length);
        free(body);
        free(counts);
    }
    check_pointers();
    printf("{\"status\":\"pass\",\"valid_cases\":%zu,\"rejected_cases\":%zu,\"construct_cases\":%zu,"
           "\"bounded_mutations\":30000,\"count_patterns\":%u,\"pointer_checks\":%zu}\n",
           valid_cases, rejected_cases, construct_cases, 4u * 65536u, pointer_checks);
    return 0;
}
