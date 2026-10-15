#include "action_family_83_runtime.h"

#include <limits.h>
#include <string.h>

static uint16_t word(const uint8_t *p)
{
    return (uint16_t)((uint16_t)p[0] | (uint16_t)((uint16_t)p[1] << 8));
}

static int32_t signed_word(const uint8_t *p)
{
    const uint16_t bits = word(p);
    return bits < 0x8000u ? (int32_t)bits : (int32_t)bits - 65536;
}

static void dword(uint8_t *p, uint32_t v)
{
    for (size_t i = 0u; i < 4u; ++i) p[i] = (uint8_t)(v >> (8u * i));
}

static size_t string_bytes(const uint8_t *p)
{
    const uint8_t *end = (const uint8_t *)memchr(p, 0, 33u);
    return end == NULL ? 0u : (size_t)(end - p) + 1u;
}

static int fail(const char **failure, const char *why, int status)
{
    if (failure != NULL) *failure = why;
    return status;
}

static int valid_table(const void *rows, size_t capacity, int16_t count)
{
    return rows != NULL && capacity <= INT16_MAX && count >= 0 &&
           (size_t)count <= capacity;
}

int action83_initialize(A83World *world, const uint8_t *uicl, size_t length)
{
    size_t subject = 0u, text = 0u, link = 0u;
    if (world == NULL || uicl == NULL) return A83_ERR_ARGUMENT;
    if (length < A83_UICL_MIN_BYTES) return A83_ERR_BODY;
    if (uicl[0xccbu] != 0u) {
        subject = string_bytes(uicl + 0xccbu);
        text = string_bytes(uicl + 0xcecu);
        if (subject == 0u || text == 0u) return A83_ERR_BODY;
        if (world->mail == NULL || world->mail_capacity == 0u) return A83_ERR_CAPACITY;
    }
    if (uicl[0xd11u] != 0u) {
        link = string_bytes(uicl + 0xd11u);
        if (link == 0u) return A83_ERR_BODY;
        if (world->web == NULL || world->web_capacity == 0u) return A83_ERR_CAPACITY;
    }
    /* 0x4e2e81..0x4e2f11: copy only through each NUL, retaining suffixes. */
    world->mail_count = subject == 0u ? 0 : 1;
    if (subject != 0u) {
        memcpy(world->mail[0], uicl + 0xccbu, subject);
        memcpy(world->mail[0] + 33u, uicl + 0xcecu, text);
        memcpy(world->mail[0] + 66u, uicl + 0xd0du, 4u);
        dword(world->mail[0] + 70u, 0u);
    }
    /* 0x4e2f33..0x4e2f9b: UICL has a signed WORD, runtime stores DWORD. */
    world->web_count = link == 0u ? 0 : 1;
    if (link != 0u) {
        memcpy(world->web[0], uicl + 0xd11u, link);
        dword(world->web[0] + 37u, (uint32_t)signed_word(uicl + 0xd32u));
        memcpy(world->web[0] + 33u, uicl + 0xd34u, 4u);
    }
    return A83_OK;
}

int action83_runtime_step(const uint8_t *body, size_t length,
                          const A83Input *input, A83World *world,
                          const A83Backend *backend, A83Result *out,
                          const char **failure)
{
    A83Result result;
    uint8_t *rows, *record;
    size_t capacity, stride, key_bytes, text_bytes = 0u;
    int16_t count, selected = -1;
    int web;
    if (failure != NULL) *failure = NULL;
    if (input == NULL || out == NULL)
        return fail(failure, "0x83-argument", A83_ERR_ARGUMENT);
    memset(&result, 0, sizeof(result));
    result.phase = input->phase;
    result.completed = input->completed;
    result.selected = -1;
    if (input->eligible == 0u || input->completed != 0u) {
        *out = result;
        return A83_OK;
    }
    if (world == NULL) return fail(failure, "0x83-world-unbound", A83_ERR_UNSUPPORTED);
    if (backend == NULL || backend->refresh == NULL)
        return fail(failure, "0x83-refresh-unbound", A83_ERR_UNSUPPORTED);
    if (body == NULL || length < 74u)
        return fail(failure, "0x83-body", A83_ERR_BODY);
    web = word(body) != 0u; /* 0x4e731c..0x4e7321, not equality with 1. */
    key_bytes = string_bytes(body + 2u);
    if (key_bytes == 0u) return fail(failure, "0x83-key-unterminated", A83_ERR_BODY);
    if (!web) {
        text_bytes = string_bytes(body + 35u);
        if (text_bytes == 0u) return fail(failure, "0x83-body-key-unterminated", A83_ERR_BODY);
    }
    rows = web ? (uint8_t *)world->web : (uint8_t *)world->mail;
    capacity = web ? world->web_capacity : world->mail_capacity;
    count = web ? world->web_count : world->mail_count;
    stride = web ? A83_WEB_BYTES : A83_MAIL_BYTES;
    if (!valid_table(rows, capacity, count))
        return fail(failure, "0x83-list-state", A83_ERR_STATE);
    /* 0x4e444d: first exact byte-string match. Only traversed rows matter. */
    for (int16_t i = 0; i < count; ++i) {
        const uint8_t *key = rows + (size_t)i * stride;
        const size_t existing = string_bytes(key);
        if (existing == 0u) return fail(failure, "0x83-existing-key", A83_ERR_STATE);
        if (existing == key_bytes && memcmp(key, body + 2u, key_bytes) == 0) {
            selected = i;
            break;
        }
    }
    if (selected < 0) {
        if ((size_t)count == capacity || count == INT16_MAX)
            return fail(failure, "0x83-list-capacity", A83_ERR_CAPACITY);
        result.inserted = 1u;
        if (web) {
            selected = count; /* 0x4e746b: append. */
            world->web_count = (int16_t)(count + 1);
        } else {
            /* 0x4e7340..0x4e7398: shift entire 74-byte records downward. */
            memmove(rows + stride, rows, (size_t)count * stride);
            selected = 0;
            world->mail_count = (int16_t)(count + 1);
        }
    }
    record = rows + (size_t)selected * stride;
    memcpy(record, body + 2u, key_bytes);
    if (web) {
        memcpy(record + 33u, body + 70u, 4u);
        dword(record + 37u, (uint32_t)signed_word(body + 68u));
    } else {
        memcpy(record + 33u, body + 35u, text_bytes);
        memcpy(record + 66u, body + 70u, 4u);
        dword(record + 70u, 0u);
    }
    /* 0x4e7448/0x4e7505: all list stores precede UI refresh. */
    if (backend->refresh(backend->context, 3, 1, web ? 2 : 1) != 0)
        return fail(failure, "0x83-refresh-failed", A83_ERR_HOST);
    result.applied = 1u;
    result.completed = 1u; /* direct store 0x42973b; no 0x42ba3a. */
    result.selected = selected;
    result.list = (uint8_t)web;
    *out = result;
    return A83_OK;
}
