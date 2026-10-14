#include "action_family_44.h"

#include <string.h>

static int valid_span(const void *p, size_t n)
{
    return p != NULL && (uintmax_t)n <=
        (uintmax_t)UINTPTR_MAX - (uintmax_t)(uintptr_t)p;
}

static int overlap(const void *a, size_t an, const void *b, size_t bn)
{
    uintptr_t x = (uintptr_t)a, y = (uintptr_t)b;
    return an != 0u && bn != 0u && x < y + bn && y < x + an;
}

static uint16_t le16(const uint8_t *p)
{
    return (uint16_t)((uint16_t)p[0] | ((uint16_t)p[1] << 8));
}

static ActionFamily44Status validate_spans(const uint8_t *raw, size_t n,
                                          const void *out, size_t out_n)
{
    if (raw == NULL || out == NULL) {
        return ACTION_FAMILY_44_ERR_ARGUMENT;
    }
    if (!valid_span(raw, n) || !valid_span(out, out_n)) {
        return ACTION_FAMILY_44_ERR_BOUNDS;
    }
    if (overlap(raw, n, out, out_n)) {
        return ACTION_FAMILY_44_ERR_OVERLAP;
    }
    return ACTION_FAMILY_44_OK;
}

static ActionFamily44Status parse(const uint8_t *raw, size_t n,
                                 ActionFamily44Decoded *d)
{
    size_t body_bytes = ACTION_FAMILY_44_HEADER_BYTES;
    const uint8_t *text, *nul;
    size_t extent;
    uint16_t count, word;
    if (n < ACTION_FAMILY_44_HEADER_BYTES) {
        return ACTION_FAMILY_44_ERR_BODY;
    }
    count = le16(raw + 526u);
    word = le16(raw + 2u);
    if (raw[492u] == 0u) {
        /* 0x411697 signed WORD >2 diagnostics; negative WORDs pass. */
        if ((word > 2u && word < UINT16_C(0x8000)) || count >= UINT16_C(0x8000)) {
            return ACTION_FAMILY_44_ERR_BODY;
        }
        if ((size_t)count > n - body_bytes) {
            return ACTION_FAMILY_44_ERR_BODY;
        }
        body_bytes += (size_t)count;
        text = raw + ACTION_FAMILY_44_HEADER_BYTES;
        extent = count;
    } else {
        text = raw + 493u;
        extent = 33u;
    }
    nul = memchr(text, 0, extent);
    if (nul == NULL) {
        return ACTION_FAMILY_44_ERR_TEXT;
    }
    if ((n - body_bytes) % ACTION_FAMILY_44_DEPENDENCY_BYTES != 0u) {
        return ACTION_FAMILY_44_ERR_TAIL;
    }
    memset(d, 0, sizeof(*d));
    d->header = raw;
    d->text = text;
    d->text_bytes = (size_t)(nul - text);
    d->word_02 = word;
    d->word_20e = count;
    d->option_1ec = raw[492u];
    d->raw_type = ACTION_FAMILY_44_RAW_TYPE;
    d->runtime_type = ACTION_FAMILY_44_RUNTIME_TYPE;
    d->dependency_records = raw + body_bytes;
    d->dependency_count = (n - body_bytes) / ACTION_FAMILY_44_DEPENDENCY_BYTES;
    d->dependency_bytes = n - body_bytes;
    d->body_bytes = body_bytes;
    d->available_body_bytes = n;
    return ACTION_FAMILY_44_OK;
}

ActionFamily44Status action_family_44_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily44Decoded *out)
{
    ActionFamily44Decoded decoded;
    ActionFamily44Status status = validate_spans(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_44_OK) {
        return status;
    }
    status = parse(raw_body, raw_body_length, &decoded);
    if (status == ACTION_FAMILY_44_OK) {
        memcpy(out, &decoded, sizeof(decoded));
    }
    return status;
}

ActionFamily44Status action_family_44_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *out)
{
    ActionFamily44Decoded decoded;
    ActionFamily44Status status = validate_spans(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_44_OK) {
        return status;
    }
    status = parse(raw_body, raw_body_length, &decoded);
    if (status == ACTION_FAMILY_44_OK) {
        *out = decoded.body_bytes;
    }
    return status;
}

ActionFamily44Status action_family_44_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    const uint8_t *resolved_text, size_t resolved_text_bytes,
    uint32_t payload_offset_before, uint32_t allocation_handle,
    uint8_t *object, size_t capacity, ActionFamily44Constructed *out)
{
    ActionFamily44Decoded decoded;
    ActionFamily44Constructed result;
    const uint8_t *nul;
    size_t object_bytes, text_bytes = 0u;
    ActionFamily44Status status;
    if (allocation_handle == 0u || (object == NULL && capacity != 0u)) {
        return ACTION_FAMILY_44_ERR_ARGUMENT;
    }
    status = validate_spans(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_44_OK) {
        return status;
    }
    if (object != NULL) {
        if (!valid_span(object, capacity)) {
            return ACTION_FAMILY_44_ERR_BOUNDS;
        }
        if (overlap(object, capacity, raw_body, raw_body_length) ||
            overlap(object, capacity, out, sizeof(*out))) {
            return ACTION_FAMILY_44_ERR_OVERLAP;
        }
    }
    status = parse(raw_body, raw_body_length, &decoded);
    if (status != ACTION_FAMILY_44_OK) {
        return status;
    }
    object_bytes = decoded.body_bytes;
    if (decoded.option_1ec != 0u) {
        if (resolved_text == NULL) {
            return ACTION_FAMILY_44_ERR_TEXT;
        }
        if (!valid_span(resolved_text, resolved_text_bytes)) {
            return ACTION_FAMILY_44_ERR_BOUNDS;
        }
        if (overlap(resolved_text, resolved_text_bytes, out, sizeof(*out)) ||
            (object != NULL && overlap(resolved_text, resolved_text_bytes, object, capacity))) {
            return ACTION_FAMILY_44_ERR_OVERLAP;
        }
        /* strlen's first NUL governs the original allocation, including when
         * the caller's supplied view has additional bytes after the NUL. */
        size_t scan = resolved_text_bytes;
        if (scan > ACTION_FAMILY_44_MAX_TEXT_BYTES + 1u) {
            scan = ACTION_FAMILY_44_MAX_TEXT_BYTES + 1u;
        }
        nul = memchr(resolved_text, 0, scan);
        if (nul == NULL) {
            return ACTION_FAMILY_44_ERR_TEXT;
        }
        text_bytes = (size_t)(nul - resolved_text);
        object_bytes = ACTION_FAMILY_44_HEADER_BYTES + text_bytes + 1u;
    }
    if (object != NULL && capacity < object_bytes) {
        return ACTION_FAMILY_44_ERR_BOUNDS;
    }
    memset(&result, 0, sizeof(result));
    result.object_bytes = object_bytes;
    result.body_bytes_consumed = decoded.body_bytes;
    result.dependency_records = decoded.dependency_records;
    result.dependency_count = decoded.dependency_count;
    result.dependency_bytes = decoded.dependency_bytes;
    result.available_body_bytes = decoded.available_body_bytes;
    result.payload_offset_before = payload_offset_before;
    result.payload_offset_after = payload_offset_before + (uint32_t)decoded.body_bytes;
    result.result_slot_handle = allocation_handle;
    result.word_20e_after = decoded.option_1ec == 0u ? decoded.word_20e : (uint16_t)text_bytes;
    result.source_word_20e_after = decoded.option_1ec == 0u ? (uint16_t)decoded.text_bytes : decoded.word_20e;
    result.source_word_20e_written = decoded.option_1ec == 0u ? 1u : 0u;
    result.raw_type = decoded.raw_type;
    result.runtime_type = decoded.runtime_type;
    if (object != NULL) {
        if (decoded.option_1ec == 0u) {
            memcpy(object, raw_body, decoded.body_bytes);
        } else {
            memcpy(object, raw_body, 526u);
            object[526u] = (uint8_t)text_bytes;
            object[527u] = (uint8_t)(text_bytes >> 8);
            memcpy(object + ACTION_FAMILY_44_HEADER_BYTES, resolved_text, text_bytes + 1u);
        }
    }
    memcpy(out, &result, sizeof(result));
    return ACTION_FAMILY_44_OK;
}
