#include "action_family_33.h"

#include <string.h>

static uint16_t u16(const uint8_t *p)
{
    return (uint16_t)((uint16_t)p[0] | ((uint16_t)p[1] << 8));
}

static int span_valid(const void *p, size_t n)
{
    return n <= UINTPTR_MAX - (uintptr_t)p;
}

static int overlaps(const void *a, size_t an, const void *b, size_t bn)
{
    return an != 0u && bn != 0u && (uintptr_t)a < (uintptr_t)b + bn &&
           (uintptr_t)b < (uintptr_t)a + an;
}

static ActionFamily33Status validate_spans(
    const uint8_t *raw_body, size_t length, const void *out, size_t out_length)
{
    if (raw_body == NULL || out == NULL) return ACTION_FAMILY_33_ERR_ARGUMENT;
    if (!span_valid(raw_body, length) || !span_valid(out, out_length))
        return ACTION_FAMILY_33_ERR_BOUNDS;
    if (overlaps(raw_body, length, out, out_length)) return ACTION_FAMILY_33_ERR_OVERLAP;
    return ACTION_FAMILY_33_OK;
}

static ActionFamily33Status decode_validated(
    const uint8_t *raw_body, size_t length, ActionFamily33Decoded *d)
{
    uint16_t a, b;
    uint32_t extent;
    if (length < ACTION_FAMILY_33_PREFIX_BYTES) return ACTION_FAMILY_33_ERR_BODY;
    a = u16(raw_body + 109u);
    b = u16(raw_body + 111u);
    if (a > INT16_MAX || b > INT16_MAX) return ACTION_FAMILY_33_ERR_COUNT;
    /* At most 2,359,337: no unsigned overflow. Original narrows to a signed
     * WORD at 0x40c1ad; this safety boundary rejects any such size narrowing. */
    extent = UINT32_C(113) + UINT32_C(6) * a + UINT32_C(66) * b;
    if (extent > ACTION_FAMILY_33_MAX_BODY_BYTES) return ACTION_FAMILY_33_ERR_COUNT;
    if ((size_t)extent > length) return ACTION_FAMILY_33_ERR_BODY;
    if ((length - extent) % ACTION_FAMILY_33_DEPENDENCY_BYTES != 0u)
        return ACTION_FAMILY_33_ERR_TAIL;
    memset(d, 0, sizeof(*d));
    d->raw_type = ACTION_FAMILY_33_RAW_TYPE;
    d->runtime_type = ACTION_FAMILY_33_RUNTIME_TYPE;
    d->count_6d = a;
    d->count_6f = b;
    d->typed_body = raw_body;
    d->body_bytes = extent;
    d->dependency_records = raw_body + extent;
    d->dependency_bytes = length - extent;
    d->dependency_count = d->dependency_bytes / ACTION_FAMILY_33_DEPENDENCY_BYTES;
    d->available_body_bytes = length;
    return ACTION_FAMILY_33_OK;
}

ActionFamily33Status action_family_33_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily33Decoded *out)
{
    ActionFamily33Decoded decoded;
    ActionFamily33Status status = validate_spans(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_33_OK) return status;
    status = decode_validated(raw_body, raw_body_length, &decoded);
    if (status != ACTION_FAMILY_33_OK) return status;
    memcpy(out, &decoded, sizeof(decoded));
    return ACTION_FAMILY_33_OK;
}

ActionFamily33Status action_family_33_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *out_body_length)
{
    ActionFamily33Decoded decoded;
    ActionFamily33Status status = validate_spans(raw_body, raw_body_length,
                                                out_body_length, sizeof(*out_body_length));
    if (status != ACTION_FAMILY_33_OK) return status;
    status = decode_validated(raw_body, raw_body_length, &decoded);
    if (status != ACTION_FAMILY_33_OK) return status;
    *out_body_length = decoded.body_bytes;
    return ACTION_FAMILY_33_OK;
}

ActionFamily33Status action_family_33_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    uint8_t *object_bytes, size_t object_capacity, ActionFamily33Constructed *out)
{
    ActionFamily33Decoded decoded;
    ActionFamily33Constructed constructed;
    ActionFamily33Status status;
    if (object_bytes == NULL || output_handle == 0u) return ACTION_FAMILY_33_ERR_ARGUMENT;
    status = validate_spans(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_33_OK) return status;
    if (!span_valid(object_bytes, object_capacity)) return ACTION_FAMILY_33_ERR_BOUNDS;
    if (overlaps(raw_body, raw_body_length, object_bytes, object_capacity) ||
        overlaps(object_bytes, object_capacity, out, sizeof(*out)))
        return ACTION_FAMILY_33_ERR_OVERLAP;
    status = decode_validated(raw_body, raw_body_length, &decoded);
    if (status != ACTION_FAMILY_33_OK) return status;
    if (object_capacity < decoded.body_bytes) return ACTION_FAMILY_33_ERR_CAPACITY;
    memset(&constructed, 0, sizeof(constructed));
    constructed.object_bytes = object_bytes;
    constructed.body_bytes_consumed = decoded.body_bytes;
    constructed.dependency_records = decoded.dependency_records;
    constructed.dependency_count = decoded.dependency_count;
    constructed.dependency_bytes = decoded.dependency_bytes;
    constructed.available_body_bytes = decoded.available_body_bytes;
    constructed.payload_offset_before = payload_offset_before;
    constructed.payload_offset_after = payload_offset_before + (uint32_t)decoded.body_bytes;
    constructed.output_handle = output_handle;
    constructed.result_slot_handle = output_handle;
    constructed.output_allocation_bytes = (uint32_t)decoded.body_bytes;
    /* 0x40c22f..0x40c258: the entire allocation is the typed body's copy.
     * No constructor defaults, pointer fixups or per-field interpretation. */
    memcpy(object_bytes, raw_body, decoded.body_bytes);
    memcpy(out, &constructed, sizeof(constructed));
    return ACTION_FAMILY_33_OK;
}
