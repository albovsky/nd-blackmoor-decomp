#include "autotext.h"

#include "hiff.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct autotext_entry {
    size_t key_offset;
    size_t value_offset;
    size_t raw_value_length;
    size_t caption_length;
    size_t next;
} AutoTextEntry;

struct AutoText {
    Hiff *hiff;
    const uint8_t *payload;
    size_t payload_length;
    AutoTextEntry *entries;
    size_t entry_count;
    size_t buckets[AUTOTEXT_BUCKET_COUNT];
    size_t tails[AUTOTEXT_BUCKET_COUNT];
};

static void set_error(char *error, size_t capacity, const char *message)
{
    if (error != NULL && capacity != 0u) {
        (void)snprintf(error, capacity, "%s", message);
    }
}

static uint16_t read_u16le(const uint8_t *bytes)
{
    return (uint16_t)((uint16_t)bytes[0] | ((uint16_t)bytes[1] << 8));
}

static int is_ascii_space(uint8_t byte)
{
    return byte == (uint8_t)' ' || byte == (uint8_t)'\t' ||
           byte == (uint8_t)'\n' || byte == (uint8_t)'\r' ||
           byte == (uint8_t)'\v' || byte == (uint8_t)'\f';
}

static int is_ascii_digit(uint8_t byte)
{
    return byte >= (uint8_t)'0' && byte <= (uint8_t)'9';
}

/* FUN_0050ca90 parses a signed decimal prefix and wraps in 32 bits. */
static uint32_t parse_decimal_prefix(const uint8_t *bytes,
                                     size_t length,
                                     size_t offset)
{
    uint32_t value = 0u;
    int negative = 0;

    while (offset < length && is_ascii_space(bytes[offset])) {
        ++offset;
    }
    if (offset < length && (bytes[offset] == (uint8_t)'-' ||
                            bytes[offset] == (uint8_t)'+')) {
        negative = bytes[offset] == (uint8_t)'-';
        ++offset;
    }
    while (offset < length && is_ascii_digit(bytes[offset])) {
        value = value * UINT32_C(10) +
                (uint32_t)(bytes[offset] - (uint8_t)'0');
        ++offset;
    }
    return negative ? UINT32_C(0) - value : value;
}

static int32_t original_bucket_from_hash(uint32_t value)
{
    uint32_t bucket = value & UINT32_C(0x800003ff);

    if ((bucket & UINT32_C(0x80000000)) != 0u) {
        bucket = ((bucket - 1u) | UINT32_C(0xfffffc00)) + 1u;
    }
    return (int32_t)bucket;
}

/* FUN_00423368 hashes a decimal suffix beginning at byte 3, then falls back
 * to the first digit in the key or the first signed byte. */
static int original_bucket(const uint8_t *key, size_t key_length, int32_t *bucket)
{
    size_t index;
    int32_t result = original_bucket_from_hash(
        parse_decimal_prefix(key, key_length, key_length < 3u ? key_length : 3u));

    if (result == 0) {
        int found_digit = 0;
        size_t fallback_limit = key_length;

        for (index = 0u; index < fallback_limit; ++index) {
            if (is_ascii_digit(key[index])) {
                result = original_bucket_from_hash(
                    parse_decimal_prefix(key, key_length, index));
                found_digit = 1;
                break;
            }
        }
        if (!found_digit) {
            int8_t first = key_length == 0u ? 0 : (int8_t)key[0];
            result = (int32_t)first;
        }
    }

    if (result < 0 || (uint32_t)result >= AUTOTEXT_BUCKET_COUNT) {
        return 0;
    }
    *bucket = result;
    return 1;
}

static uint8_t ascii_upper(uint8_t byte)
{
    if (byte >= (uint8_t)'a' && byte <= (uint8_t)'z') {
        return (uint8_t)(byte - (uint8_t)'a' + (uint8_t)'A');
    }
    return byte;
}

static int folded_key_equal(const uint8_t *query,
                            size_t query_length,
                            const uint8_t *stored)
{
    size_t index;

    for (index = 0u; index < query_length; ++index) {
        if (stored[index] == 0u ||
            ascii_upper(query[index]) != ascii_upper(stored[index])) {
            return 0;
        }
    }
    return stored[query_length] == 0u;
}

static int parse_payload(AutoText *autotext, char *error, size_t error_capacity)
{
    uint16_t count;
    size_t offset = sizeof(uint16_t);
    size_t index;

    if (autotext->payload_length < sizeof(uint16_t)) {
        set_error(error, error_capacity, "AUTOTEXT CVTX payload is shorter than its count");
        return AUTOTEXT_ERR_BOUNDS;
    }
    count = read_u16le(autotext->payload);
    if (count != 0u) {
        autotext->entries = (AutoTextEntry *)calloc((size_t)count,
                                                     sizeof(*autotext->entries));
        if (autotext->entries == NULL) {
            set_error(error, error_capacity, "cannot allocate AUTOTEXT entry index");
            return AUTOTEXT_ERR_MEMORY;
        }
    }
    autotext->entry_count = (size_t)count;

    for (index = 0u; index < AUTOTEXT_BUCKET_COUNT; ++index) {
        autotext->buckets[index] = SIZE_MAX;
        autotext->tails[index] = SIZE_MAX;
    }

    for (index = 0u; index < (size_t)count; ++index) {
        const uint8_t *record;
        const uint8_t *key_end;
        const uint8_t *value;
        size_t key_length;
        size_t remaining;
        size_t declared_value_length;
        size_t visible_value_length;
        const uint8_t *value_end;
        int32_t bucket;
        AutoTextEntry *entry;

        if (offset > autotext->payload_length) {
            set_error(error, error_capacity, "AUTOTEXT record offset exceeds CVTX payload");
            return AUTOTEXT_ERR_BOUNDS;
        }
        remaining = autotext->payload_length - offset;
        if (remaining < AUTOTEXT_KEY_BYTES + sizeof(uint16_t)) {
            set_error(error, error_capacity, "AUTOTEXT record header is truncated");
            return AUTOTEXT_ERR_BOUNDS;
        }
        record = autotext->payload + offset;
        key_end = (const uint8_t *)memchr(record, 0, AUTOTEXT_KEY_BYTES);
        if (key_end == NULL) {
            set_error(error, error_capacity, "AUTOTEXT key has no NUL within its 33-byte field");
            return AUTOTEXT_ERR_FORMAT;
        }
        key_length = (size_t)(key_end - record);
        if (!original_bucket(record, key_length, &bucket)) {
            set_error(error, error_capacity,
                      "AUTOTEXT key hashes outside the original 1024-bucket table");
            return AUTOTEXT_ERR_UNSUPPORTED;
        }

        declared_value_length = (size_t)read_u16le(record + AUTOTEXT_KEY_BYTES);
        if (declared_value_length > AUTOTEXT_MAX_VALUE_BYTES) {
            set_error(error, error_capacity,
                      "AUTOTEXT value exceeds the bounded original text buffer");
            return AUTOTEXT_ERR_UNSUPPORTED;
        }
        if (declared_value_length >
            remaining - AUTOTEXT_KEY_BYTES - sizeof(uint16_t)) {
            set_error(error, error_capacity, "AUTOTEXT value extends past CVTX payload");
            return AUTOTEXT_ERR_BOUNDS;
        }
        value = record + AUTOTEXT_KEY_BYTES + sizeof(uint16_t);
        value_end = (const uint8_t *)memchr(value, 0, declared_value_length);
        visible_value_length = value_end == NULL
            ? declared_value_length : (size_t)(value_end - value);

        entry = &autotext->entries[index];
        entry->key_offset = offset;
        entry->value_offset = (size_t)(value - autotext->payload);
        entry->raw_value_length = declared_value_length;
        entry->caption_length = visible_value_length;
        entry->next = SIZE_MAX;

        if (autotext->buckets[(size_t)bucket] == SIZE_MAX) {
            autotext->buckets[(size_t)bucket] = index;
        } else {
            autotext->entries[autotext->tails[(size_t)bucket]].next = index;
        }
        autotext->tails[(size_t)bucket] = index;
        offset += AUTOTEXT_KEY_BYTES + sizeof(uint16_t) + declared_value_length;
    }

    if (offset != autotext->payload_length) {
        set_error(error, error_capacity, "AUTOTEXT CVTX payload has trailing bytes");
        return AUTOTEXT_ERR_FORMAT;
    }
    return AUTOTEXT_OK;
}

int autotext_open_memory(const void *resource,
                         size_t resource_length,
                         int original_nls_mode,
                         AutoText **output,
                         char *error,
                         size_t error_capacity)
{
    AutoText *autotext;
    HiffSelectionInfo data_info;
    HiffSelectionInfo chunk_info;
    int status;

    if (error != NULL && error_capacity != 0u) {
        error[0] = '\0';
    }
    if (output == NULL || *output != NULL || resource == NULL || resource_length == 0u) {
        set_error(error, error_capacity, "invalid AUTOTEXT input or nonempty output");
        return AUTOTEXT_ERR_ARGUMENT;
    }
    if (original_nls_mode != 0) {
        set_error(error, error_capacity,
                  "original NLS uppercase mode is unsupported; ASCII mode is required");
        return AUTOTEXT_ERR_UNSUPPORTED;
    }

    autotext = (AutoText *)calloc(1u, sizeof(*autotext));
    if (autotext == NULL) {
        set_error(error, error_capacity, "cannot allocate AUTOTEXT index");
        return AUTOTEXT_ERR_MEMORY;
    }
    autotext->hiff = hiff_open_memory(resource, resource_length, error, error_capacity);
    if (autotext->hiff == NULL) {
        free(autotext);
        return AUTOTEXT_ERR_FORMAT;
    }
    if (hiff_select_data(autotext->hiff, "TEXT") != HIFF_OK ||
        hiff_get_selected_data(autotext->hiff, NULL, NULL, &data_info) != HIFF_OK) {
        set_error(error, error_capacity, "AUTOTEXT resource has no TEXT DATA record");
        autotext_close(autotext);
        return AUTOTEXT_ERR_NOT_FOUND;
    }
    if (hiff_select_chunk(autotext->hiff, "CVTX") != HIFF_OK ||
        hiff_get_selected_chunk(autotext->hiff, &autotext->payload,
                                &autotext->payload_length, &chunk_info) != HIFF_OK) {
        set_error(error, error_capacity, "AUTOTEXT TEXT record has no CVTX chunk");
        autotext_close(autotext);
        return AUTOTEXT_ERR_NOT_FOUND;
    }
    if (chunk_info.data_index != data_info.index) {
        set_error(error, error_capacity,
                  "first CVTX chunk does not belong to AUTOTEXT TEXT record");
        autotext_close(autotext);
        return AUTOTEXT_ERR_UNSUPPORTED;
    }

    status = parse_payload(autotext, error, error_capacity);
    if (status != AUTOTEXT_OK) {
        autotext_close(autotext);
        return status;
    }
    *output = autotext;
    return AUTOTEXT_OK;
}

void autotext_close(AutoText *autotext)
{
    if (autotext != NULL) {
        free(autotext->entries);
        hiff_close(autotext->hiff);
        free(autotext);
    }
}

int autotext_lookup(const AutoText *autotext,
                    const uint8_t *key,
                    size_t key_length,
                    const uint8_t **value,
                    size_t *raw_value_length,
                    size_t *caption_length)
{
    size_t cursor;
    int32_t bucket;

    if (value != NULL) {
        *value = NULL;
    }
    if (raw_value_length != NULL) {
        *raw_value_length = 0u;
    }
    if (caption_length != NULL) {
        *caption_length = 0u;
    }
    if (autotext == NULL || key == NULL || value == NULL ||
        raw_value_length == NULL || caption_length == NULL ||
        key_length >= AUTOTEXT_KEY_BYTES || memchr(key, 0, key_length) != NULL) {
        return AUTOTEXT_ERR_ARGUMENT;
    }
    if (!original_bucket(key, key_length, &bucket)) {
        return AUTOTEXT_ERR_UNSUPPORTED;
    }

    cursor = autotext->buckets[(size_t)bucket];
    while (cursor != SIZE_MAX) {
        const AutoTextEntry *entry = &autotext->entries[cursor];
        const uint8_t *stored_key = autotext->payload + entry->key_offset;

        if (folded_key_equal(key, key_length, stored_key)) {
            *value = autotext->payload + entry->value_offset;
            *raw_value_length = entry->raw_value_length;
            *caption_length = entry->caption_length;
            return AUTOTEXT_OK;
        }
        cursor = entry->next;
    }

    return AUTOTEXT_ERR_NOT_FOUND;
}

size_t autotext_entry_count(const AutoText *autotext)
{
    return autotext == NULL ? 0u : autotext->entry_count;
}

const char *autotext_status_string(int status)
{
    switch (status) {
    case AUTOTEXT_OK:
        return "ok";
    case AUTOTEXT_ERR_ARGUMENT:
        return "invalid argument";
    case AUTOTEXT_ERR_MEMORY:
        return "out of memory";
    case AUTOTEXT_ERR_FORMAT:
        return "invalid AUTOTEXT format";
    case AUTOTEXT_ERR_BOUNDS:
        return "AUTOTEXT data exceeds input bounds";
    case AUTOTEXT_ERR_UNSUPPORTED:
        return "unsupported AUTOTEXT mode or value";
    case AUTOTEXT_ERR_NOT_FOUND:
        return "AUTOTEXT key not found";
    default:
        return "unknown AUTOTEXT status";
    }
}
