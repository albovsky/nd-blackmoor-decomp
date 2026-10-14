#include "action_family_43.h"

#include <limits.h>
#include <string.h>

static uint16_t read_u16(const uint8_t *p)
{
    return (uint16_t)((uint16_t)p[0] | ((uint16_t)p[1] << 8));
}

static int16_t read_i16(const uint8_t *p)
{
    uint16_t bits = read_u16(p);
    return bits <= INT16_MAX ? (int16_t)bits :
        (int16_t)(-1 - (int32_t)(UINT16_MAX - bits));
}

static void write_u16(uint8_t *p, uint16_t value)
{
    p[0] = (uint8_t)value;
    p[1] = (uint8_t)(value >> 8);
}

static ActionFamily43Status check_spans(const void *input, size_t input_length,
                                       const void *out, size_t out_length)
{
    uintptr_t a = (uintptr_t)input;
    uintptr_t b = (uintptr_t)out;
    if (input == NULL || out == NULL) {
        return ACTION_FAMILY_43_ERR_ARGUMENT;
    }
    if (input_length > UINTPTR_MAX - a || out_length > UINTPTR_MAX - b) {
        return ACTION_FAMILY_43_ERR_BOUNDS;
    }
    if (input_length != 0u && out_length != 0u && a < b + out_length && b < a + input_length) {
        return ACTION_FAMILY_43_ERR_OVERLAP;
    }
    return ACTION_FAMILY_43_OK;
}

static ActionFamily43Status decode_checked(const uint8_t *raw, size_t length,
    const void *out, size_t out_length, ActionFamily43Decoded *d)
{
    size_t typed = ACTION_FAMILY_43_PREFIX_BYTES;
    size_t visible = 0u;
    const uint8_t *terminator;
    ActionFamily43Status status = check_spans(raw, length, out, out_length);
    if (status != ACTION_FAMILY_43_OK) {
        return status;
    }
    if (length < ACTION_FAMILY_43_PREFIX_BYTES) {
        return ACTION_FAMILY_43_ERR_BODY;
    }
    if (raw[0x109u] == 0u) {
        /* 0x4113a8 and 0x41142c: signed word reads, DWORD size addition.
         * Original's comparison against 40000 cannot bound positive int16. */
        int16_t count = read_i16(raw + 0x12bu);
        if (read_i16(raw + 0x02u) > 2 || count < 0) {
            return ACTION_FAMILY_43_ERR_COUNT;
        }
        typed += (size_t)count;
        if (length < typed) {
            return ACTION_FAMILY_43_ERR_BODY;
        }
        terminator = memchr(raw + ACTION_FAMILY_43_PREFIX_BYTES, 0, (size_t)count);
        if (terminator == NULL) {
            return ACTION_FAMILY_43_ERR_STRING;
        }
        visible = (size_t)(terminator - (raw + ACTION_FAMILY_43_PREFIX_BYTES));
    } else if (memchr(raw + 0x10au, 0, 33u) == NULL) {
        return ACTION_FAMILY_43_ERR_STRING;
    }
    if ((length - typed) % ACTION_FAMILY_43_DEPENDENCY_BYTES != 0u) {
        return ACTION_FAMILY_43_ERR_TAIL;
    }
    memset(d, 0, sizeof(*d));
    d->word_00 = read_u16(raw);
    d->option_02 = read_i16(raw + 0x02u);
    d->option_109 = raw[0x109u];
    if (d->option_109 != 0u) {
        size_t key_length = (size_t)((const uint8_t *)memchr(raw + 0x10au, 0, 33u) - (raw + 0x10au));
        memcpy(d->key, raw + 0x10au, key_length + 1u);
    }
    d->word_12b = read_u16(raw + 0x12bu);
    d->prefix = raw;
    d->inline_text = d->option_109 == 0u ? raw + ACTION_FAMILY_43_PREFIX_BYTES : NULL;
    d->inline_visible_length = visible;
    d->dependency_records = raw + typed;
    d->dependency_count = (length - typed) / ACTION_FAMILY_43_DEPENDENCY_BYTES;
    d->dependency_bytes = length - typed;
    d->body_bytes = typed;
    d->available_body_bytes = length;
    return ACTION_FAMILY_43_OK;
}

ActionFamily43Status action_family_43_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily43Decoded *out)
{
    ActionFamily43Decoded decoded;
    ActionFamily43Status status = decode_checked(raw_body, raw_body_length, out, sizeof(*out), &decoded);
    if (status != ACTION_FAMILY_43_OK) {
        return status;
    }
    memcpy(out, &decoded, sizeof(decoded));
    return ACTION_FAMILY_43_OK;
}

ActionFamily43Status action_family_43_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    const uint8_t *resolved_text, size_t resolved_text_bytes,
    uint32_t payload_offset_before, uint32_t output_handle,
    uint8_t *object, size_t object_capacity, ActionFamily43Constructed *out)
{
    ActionFamily43Decoded decoded;
    ActionFamily43Constructed constructed;
    ActionFamily43Status status;
    size_t allocation;
    size_t visible = 0u;
    if (output_handle == 0u || (object == NULL && object_capacity != 0u) ||
        (resolved_text == NULL && resolved_text_bytes != 0u)) {
        return ACTION_FAMILY_43_ERR_ARGUMENT;
    }
    /* Check all supplied spans before inspecting input. Read-only spans may
     * alias each other. object/out may not alias even during a size query. */
    status = check_spans(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_43_OK) {
        return status;
    }
    if (resolved_text != NULL) {
        status = check_spans(resolved_text, resolved_text_bytes, out, sizeof(*out));
        if (status != ACTION_FAMILY_43_OK) {
            return status;
        }
    }
    if (object != NULL) {
        status = check_spans(object, object_capacity, out, sizeof(*out));
        if (status == ACTION_FAMILY_43_OK) {
            status = check_spans(raw_body, raw_body_length, object, object_capacity);
        }
        if (status == ACTION_FAMILY_43_OK && resolved_text != NULL) {
            status = check_spans(resolved_text, resolved_text_bytes, object, object_capacity);
        }
        if (status != ACTION_FAMILY_43_OK) {
            return status;
        }
    }
    status = decode_checked(raw_body, raw_body_length, out, sizeof(*out), &decoded);
    if (status != ACTION_FAMILY_43_OK) {
        return status;
    }
    allocation = decoded.body_bytes;
    if (decoded.option_109 != 0u) {
        const uint8_t *terminator;
        if (resolved_text == NULL) {
            return ACTION_FAMILY_43_ERR_ARGUMENT;
        }
        if (resolved_text_bytes > ACTION_FAMILY_43_MAX_RESOLVED_VISIBLE_BYTES + 1u) {
            return ACTION_FAMILY_43_ERR_COUNT;
        }
        if (resolved_text_bytes == 0u) {
            return ACTION_FAMILY_43_ERR_STRING;
        }
        terminator = memchr(resolved_text, 0, resolved_text_bytes);
        if (terminator == NULL || terminator != resolved_text + resolved_text_bytes - 1u) {
            return ACTION_FAMILY_43_ERR_STRING;
        }
        visible = resolved_text_bytes - 1u;
        /* 0x411584 NOT includes the NUL; ADD 301 does not narrow. */
        allocation = ACTION_FAMILY_43_PREFIX_BYTES + resolved_text_bytes;
    } else if (resolved_text != NULL || resolved_text_bytes != 0u) {
        return ACTION_FAMILY_43_ERR_ARGUMENT;
    }
    if (object != NULL && object_capacity < allocation) {
        return ACTION_FAMILY_43_ERR_CAPACITY;
    }
    memset(&constructed, 0, sizeof(constructed));
    constructed.dependency_records = decoded.dependency_records;
    constructed.dependency_count = decoded.dependency_count;
    constructed.dependency_bytes = decoded.dependency_bytes;
    constructed.body_bytes_consumed = decoded.body_bytes;
    constructed.available_body_bytes = decoded.available_body_bytes;
    constructed.allocation_bytes = allocation;
    constructed.payload_offset_before = payload_offset_before;
    constructed.payload_offset_after = payload_offset_before + (uint32_t)decoded.body_bytes;
    constructed.result_slot_handle = output_handle;
    constructed.source_word_12b_after = decoded.option_109 == 0u ?
        (uint16_t)decoded.inline_visible_length : decoded.word_12b;
    constructed.source_word_written = decoded.option_109 == 0u ? 1u : 0u;
    constructed.raw_type = ACTION_FAMILY_43_RAW_TYPE;
    constructed.runtime_type = ACTION_FAMILY_43_RUNTIME_TYPE;
    if (object != NULL) {
        if (decoded.option_109 == 0u) {
            /* Copy precedes original source-word rewrite at 0x4114e4. */
            memcpy(object, raw_body, decoded.body_bytes);
        } else {
            memcpy(object, raw_body, ACTION_FAMILY_43_PREFIX_BYTES);
            write_u16(object + 0x12bu, (uint16_t)visible);
            memcpy(object + ACTION_FAMILY_43_PREFIX_BYTES, resolved_text, resolved_text_bytes);
        }
    }
    memcpy(out, &constructed, sizeof(constructed));
    return ACTION_FAMILY_43_OK;
}
