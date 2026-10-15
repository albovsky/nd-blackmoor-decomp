#include "action_family_4b.h"

#include <string.h>

static int address_span(const void *pointer, size_t length,
                        uintptr_t *start, uintptr_t *end)
{
    uintmax_t begin = (uintmax_t)(uintptr_t)pointer;
    if (pointer == NULL || (uintmax_t)length > (uintmax_t)UINTPTR_MAX - begin) {
        return 0;
    }
    *start = (uintptr_t)begin;
    *end = (uintptr_t)(begin + (uintmax_t)length);
    return 1;
}

static ActionFamily4BStatus validate_spans(
    const uint8_t *raw_body, size_t length, const void *out, size_t out_length)
{
    uintptr_t input_start, input_end, output_start, output_end;
    if (raw_body == NULL || out == NULL) {
        return ACTION_FAMILY_4B_ERR_ARGUMENT;
    }
    if (length < 2u) {
        return ACTION_FAMILY_4B_ERR_BODY;
    }
    if (!address_span(raw_body, length, &input_start, &input_end) ||
        !address_span(out, out_length, &output_start, &output_end)) {
        return ACTION_FAMILY_4B_ERR_BOUNDS;
    }
    if (input_start < output_end && output_start < input_end) {
        return ACTION_FAMILY_4B_ERR_OVERLAP;
    }
    return ACTION_FAMILY_4B_OK;
}

static uint16_t read_le16(const uint8_t *p)
{
    return (uint16_t)((uint16_t)p[0] | ((uint16_t)p[1] << 8));
}

static void write_le16(uint8_t *p, uint16_t value)
{
    p[0] = (uint8_t)(value & UINT16_C(0xff));
    p[1] = (uint8_t)(value >> 8);
}

/* Do not substitute a uint16 count: 0x40c634/0x40c893 use movsx. */
static ActionFamily4BStatus parse_body(
    const uint8_t *raw_body, size_t length, ActionFamily4BDecoded *decoded)
{
    uint16_t bits = read_le16(raw_body);
    int32_t selector = bits <= UINT16_C(0x7fff) ? (int32_t)bits : (int32_t)bits - INT32_C(65536);
    size_t typed;
    const uint8_t *key_end = NULL;
    if (selector == -1) {
        typed = ACTION_FAMILY_4B_KEY_BODY_BYTES;
    } else if (selector < 0 || (uint32_t)selector > ACTION_FAMILY_4B_MAX_INLINE_BYTES) {
        return ACTION_FAMILY_4B_ERR_COUNT;
    } else {
        typed = 2u + (size_t)selector;
    }
    if (length < typed) {
        return ACTION_FAMILY_4B_ERR_BODY;
    }
    if (selector == -1) {
        key_end = memchr(raw_body + 2u, 0, 33u);
        if (key_end == NULL) {
            return ACTION_FAMILY_4B_ERR_KEY;
        }
    }
    if ((length - typed) % ACTION_FAMILY_4B_DEPENDENCY_BYTES != 0u) {
        return ACTION_FAMILY_4B_ERR_TAIL;
    }
    memset(decoded, 0, sizeof(*decoded));
    decoded->text_selector = (int16_t)selector;
    if (selector == -1) {
        memcpy(decoded->text_key, raw_body + 2u, (size_t)(key_end - (raw_body + 2u)));
    } else {
        decoded->inline_text = raw_body + 2u;
        decoded->inline_text_bytes = (size_t)selector;
    }
    decoded->dependency_records = raw_body + typed;
    decoded->dependency_count = (length - typed) / ACTION_FAMILY_4B_DEPENDENCY_BYTES;
    decoded->body_bytes = typed;
    decoded->dependency_bytes = length - typed;
    decoded->available_body_bytes = length;
    return ACTION_FAMILY_4B_OK;
}

ActionFamily4BStatus action_family_4b_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *out_length)
{
    ActionFamily4BDecoded decoded;
    ActionFamily4BStatus status = validate_spans(raw_body, raw_body_length, out_length, sizeof(*out_length));
    if (status != ACTION_FAMILY_4B_OK) {
        return status;
    }
    status = parse_body(raw_body, raw_body_length, &decoded);
    if (status != ACTION_FAMILY_4B_OK) {
        return status;
    }
    memcpy(out_length, &decoded.body_bytes, sizeof(*out_length));
    return ACTION_FAMILY_4B_OK;
}

ActionFamily4BStatus action_family_4b_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily4BDecoded *out)
{
    ActionFamily4BDecoded decoded;
    ActionFamily4BStatus status = validate_spans(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_4B_OK) {
        return status;
    }
    status = parse_body(raw_body, raw_body_length, &decoded);
    if (status != ACTION_FAMILY_4B_OK) {
        return status;
    }
    memcpy(out, &decoded, sizeof(decoded));
    return ACTION_FAMILY_4B_OK;
}

ActionFamily4BStatus action_family_4b_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    const uint8_t *resolved_text, size_t resolved_text_bytes,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamily4BConstructed *out)
{
    ActionFamily4BDecoded decoded;
    ActionFamily4BConstructed constructed;
    ActionFamily4BStatus status;
    if (output_handle == 0u) {
        return ACTION_FAMILY_4B_ERR_ARGUMENT;
    }
    status = validate_spans(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_4B_OK) {
        return status;
    }
    status = parse_body(raw_body, raw_body_length, &decoded);
    if (status != ACTION_FAMILY_4B_OK) {
        return status;
    }
    if (decoded.text_selector == -1) {
        uintptr_t text_start, text_end, output_start, output_end;
        if (resolved_text_bytes > ACTION_FAMILY_4B_MAX_RESOLVED_BYTES ||
            (resolved_text == NULL && resolved_text_bytes != 0u)) {
            return ACTION_FAMILY_4B_ERR_TEXT;
        }
        if (resolved_text_bytes != 0u) {
            if (!address_span(resolved_text, resolved_text_bytes, &text_start, &text_end) ||
                !address_span(out, sizeof(*out), &output_start, &output_end)) {
                return ACTION_FAMILY_4B_ERR_BOUNDS;
            }
            if (text_start < output_end && output_start < text_end) {
                return ACTION_FAMILY_4B_ERR_OVERLAP;
            }
            if (memchr(resolved_text, 0, resolved_text_bytes) != NULL) {
                return ACTION_FAMILY_4B_ERR_TEXT;
            }
        }
    } else if (resolved_text != NULL || resolved_text_bytes != 0u) {
        return ACTION_FAMILY_4B_ERR_TEXT;
    }
    /* All validation finishes before constructing or writing caller output. */
    memset(&constructed, 0, sizeof(constructed));
    if (decoded.text_selector == -1) {
        /* 0x40c774 allocation l+6; 0x40c841 word l+3;
         * 0x40c867 copy through NUL; 0x40c885 replace NUL with "<e>\0". */
        constructed.allocation_bytes = resolved_text_bytes + 6u;
        write_le16(constructed.object_bytes, (uint16_t)(resolved_text_bytes + 3u));
        if (resolved_text_bytes != 0u) {
            memcpy(constructed.object_bytes + 2u, resolved_text, resolved_text_bytes);
        }
        memcpy(constructed.object_bytes + 2u + resolved_text_bytes, "<e>", 4u);
    } else {
        /* 0x40c8a7 alloc n+5; 0x40c9ec copy only n+2; 0x40ca3c
         * append three bytes without NUL; 0x40ca68 add 3 to the word. */
        constructed.allocation_bytes = decoded.inline_text_bytes + 5u;
        memcpy(constructed.object_bytes, raw_body, decoded.body_bytes);
        memcpy(constructed.object_bytes + 2u + decoded.inline_text_bytes, "<e>", 3u);
        write_le16(constructed.object_bytes, (uint16_t)(decoded.inline_text_bytes + 3u));
    }
    constructed.dependency_records = decoded.dependency_records;
    constructed.dependency_count = decoded.dependency_count;
    constructed.dependency_bytes = decoded.dependency_bytes;
    constructed.available_body_bytes = decoded.available_body_bytes;
    constructed.body_bytes_consumed = decoded.body_bytes;
    constructed.payload_offset_before = payload_offset_before;
    constructed.payload_offset_after = payload_offset_before + (uint32_t)decoded.body_bytes;
    constructed.result_slot_handle = output_handle;
    memcpy(out, &constructed, sizeof(constructed));
    return ACTION_FAMILY_4B_OK;
}
