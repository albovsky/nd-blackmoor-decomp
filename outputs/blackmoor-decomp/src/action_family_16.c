/* Behavioral reconstructed C; no original C++ or x86 byte-matching claim.
 * Original 0x410e9c[0x16-10] selects 0x40b98f, the same allocation/copy arm
 * as raw 0x17. Neither arm rewrites the runtime type. */
#include "action_family_16.h"

ActionFamily16Status action_family_16_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily16Decoded *out)
{
    ActionFamily16Status status = action_family_17_decode(raw_body, raw_body_length, out);
    if (status == ACTION_FAMILY_16_OK) {
        out->raw_type = ACTION_FAMILY_16_RAW_TYPE;
        out->runtime_type = ACTION_FAMILY_16_RUNTIME_TYPE;
    }
    return status;
}

ActionFamily16Status action_family_16_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *out)
{
    return action_family_17_body_length(raw_body, raw_body_length, out);
}

ActionFamily16Status action_family_16_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    uint8_t *object_bytes, size_t object_capacity, ActionFamily16Constructed *out)
{
    ActionFamily16Status status = action_family_17_construct(raw_body, raw_body_length,
        payload_offset_before, output_handle, object_bytes, object_capacity, out);
    if (status == ACTION_FAMILY_16_OK) {
        out->raw_type = ACTION_FAMILY_16_RAW_TYPE;
        out->runtime_type = ACTION_FAMILY_16_RUNTIME_TYPE;
    }
    return status;
}
