#include "action_family_37.h"

#include <limits.h>
#include <string.h>

static uint16_t read_u16_le(const uint8_t *bytes)
{
    return (uint16_t)((uint16_t)bytes[0] |
                      ((uint16_t)bytes[1] << 8));
}

static uint32_t read_u32_le(const uint8_t *bytes)
{
    return (uint32_t)bytes[0] |
           ((uint32_t)bytes[1] << 8) |
           ((uint32_t)bytes[2] << 16) |
           ((uint32_t)bytes[3] << 24);
}

static int32_t signed_i32_from_bits(uint32_t bits)
{
    if (bits <= (uint32_t)INT32_MAX) {
        return (int32_t)bits;
    }
    return -1 - (int32_t)(UINT32_MAX - bits);
}

static void write_u16_le(uint8_t *bytes, uint16_t value)
{
    bytes[0] = (uint8_t)(value & UINT16_C(0x00ff));
    bytes[1] = (uint8_t)(value >> 8);
}

static void write_u32_le(uint8_t *bytes, uint32_t value)
{
    bytes[0] = (uint8_t)(value & UINT32_C(0x000000ff));
    bytes[1] = (uint8_t)((value >> 8) & UINT32_C(0x000000ff));
    bytes[2] = (uint8_t)((value >> 16) & UINT32_C(0x000000ff));
    bytes[3] = (uint8_t)(value >> 24);
}

/* Validate integer-address spans before reading or writing them. This does
 * not claim that an arbitrary non-null address is mapped; callers still own
 * the memory contract. */
static int address_span(const void *pointer,
                        size_t length,
                        uintptr_t *start,
                        uintptr_t *end)
{
    uintmax_t begin_value;
    uintmax_t length_value;
    uintmax_t max_value = (uintmax_t)UINTPTR_MAX;

    if (pointer == NULL) {
        return 0;
    }
    begin_value = (uintmax_t)(uintptr_t)pointer;
    length_value = (uintmax_t)length;
    if (begin_value > max_value || length_value > max_value - begin_value) {
        return 0;
    }
    *start = (uintptr_t)begin_value;
    *end = (uintptr_t)(begin_value + length_value);
    return 1;
}

static int spans_overlap(const void *left,
                         size_t left_length,
                         const void *right,
                         size_t right_length,
                         int *overlap)
{
    uintptr_t left_start;
    uintptr_t left_end;
    uintptr_t right_start;
    uintptr_t right_end;

    *overlap = 0;
    if (!address_span(left, left_length, &left_start, &left_end) ||
        !address_span(right, right_length, &right_start, &right_end)) {
        return 0;
    }
    if (left_length == 0u || right_length == 0u) {
        return 1;
    }
    *overlap = left_start < right_end && right_start < left_end;
    return 1;
}

static ActionFamily37Status validate_body(const uint8_t *raw_body,
                                         size_t raw_body_length,
                                         const void *out,
                                         size_t out_length)
{
    uintptr_t ignored_start;
    uintptr_t ignored_end;
    size_t index;
    int overlap;

    if (raw_body == NULL || out == NULL) {
        return ACTION_FAMILY_37_ERR_ARGUMENT;
    }
    if (raw_body_length < ACTION_FAMILY_37_BODY_BYTES) {
        return ACTION_FAMILY_37_ERR_BODY;
    }
    if (!address_span(raw_body, raw_body_length, &ignored_start, &ignored_end) ||
        !address_span(out, out_length, &ignored_start, &ignored_end)) {
        return ACTION_FAMILY_37_ERR_BOUNDS;
    }
    for (index = 0u; index < 33u; ++index) {
        if (raw_body[index] == 0u) {
            break;
        }
    }
    if (index == 33u) {
        return ACTION_FAMILY_37_ERR_NAME;
    }
    if ((raw_body_length - ACTION_FAMILY_37_BODY_BYTES) %
            ACTION_FAMILY_37_DEPENDENCY_BYTES != 0u) {
        return ACTION_FAMILY_37_ERR_TAIL;
    }
    if (!spans_overlap(raw_body, raw_body_length, out, out_length, &overlap)) {
        return ACTION_FAMILY_37_ERR_BOUNDS;
    }
    if (overlap) {
        return ACTION_FAMILY_37_ERR_OVERLAP;
    }
    return ACTION_FAMILY_37_OK;
}

static void decode_validated(const uint8_t *raw_body,
                             size_t raw_body_length,
                             ActionFamily37Decoded *decoded)
{
    size_t name_bytes = 0u;
    size_t index;

    memset(decoded, 0, sizeof(*decoded));
    while (name_bytes < sizeof(decoded->name) &&
           raw_body[name_bytes] != 0u) {
        ++name_bytes;
    }
    memcpy(decoded->name, raw_body, name_bytes + 1u);
    decoded->option_21 = read_u16_le(raw_body + 0x21u);
    decoded->option_23 = read_u16_le(raw_body + 0x23u);
    for (index = 0u; index < 4u; ++index) {
        decoded->fixed_rect[index] =
            signed_i32_from_bits(read_u32_le(raw_body + 0x25u + index * 4u));
        decoded->initial_geometry[index] =
            signed_i32_from_bits(read_u32_le(raw_body + 0x35u + index * 4u));
    }
    decoded->dependency_records = raw_body + ACTION_FAMILY_37_BODY_BYTES;
    decoded->dependency_bytes =
        raw_body_length - ACTION_FAMILY_37_BODY_BYTES;
    decoded->dependency_count =
        decoded->dependency_bytes / ACTION_FAMILY_37_DEPENDENCY_BYTES;
    decoded->available_body_bytes = raw_body_length;
    decoded->body_bytes = ACTION_FAMILY_37_BODY_BYTES;
}

ActionFamily37Status action_family_37_decode(
    const uint8_t *raw_body,
    size_t raw_body_length,
    ActionFamily37Decoded *out)
{
    ActionFamily37Decoded decoded;
    ActionFamily37Status status = validate_body(
        raw_body, raw_body_length, out, sizeof(*out));

    if (status != ACTION_FAMILY_37_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, &decoded);
    memcpy(out, &decoded, sizeof(decoded));
    return ACTION_FAMILY_37_OK;
}

static void initialize_original_defaults(uint8_t *object,
                                        const ActionFamily37Decoded *decoded)
{
    static const uint8_t no_sound[9] = {
        'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0u
    };
    size_t index;
    uint32_t left = (uint32_t)decoded->fixed_rect[0];
    uint32_t top = (uint32_t)decoded->fixed_rect[1];
    uint32_t right = (uint32_t)decoded->fixed_rect[2];
    uint32_t bottom = (uint32_t)decoded->fixed_rect[3];

    /* FUN_0048945b's writes, including the rectangle-derived DWORDs. */
    write_u16_le(object + 0x21u, 2u);
    write_u16_le(object + 0x25u, 2u);
    write_u16_le(object + 0x29u, 1u);
    write_u16_le(object + 0x39u, UINT16_MAX);
    write_u16_le(object + 0x3du, 9999u);
    for (index = 0u; index < 10u; ++index) {
        write_u16_le(object + 0x51u + index * 4u, UINT16_MAX);
    }
    memcpy(object + 0x79u, no_sound, sizeof(no_sound));
    write_u16_le(object + 0x2bu, 1u);
    write_u16_le(object + 0x43u, 1u);
    write_u32_le(object + 0x4du, 1u);
    write_u16_le(object + 0xaau, 1u);
    write_u16_le(object + 0x6ecu, 0u);
    write_u16_le(object + 0x6eeu, 0u);
    write_u16_le(object + 0x6f0u, 2u);
    write_u32_le(object + 0x6f2u, 0u);
    write_u32_le(object + 0x6f6u, 0u);
    write_u32_le(object + 0x6fau, right - left);
    write_u32_le(object + 0x6feu, bottom - top);
    for (index = 0u; index < 4u; ++index) {
        write_u32_le(object + 0x702u + index * 4u,
                     (uint32_t)decoded->fixed_rect[index]);
    }
}

ActionFamily37Status action_family_37_construct(
    const uint8_t *raw_body,
    size_t raw_body_length,
    uint32_t payload_offset_before,
    uint32_t output_handle,
    ActionFamily37Constructed *out)
{
    ActionFamily37Decoded decoded;
    ActionFamily37Constructed constructed;
    ActionFamily37Status status;
    size_t name_bytes = 0u;
    size_t index;

    if (out == NULL || raw_body == NULL) {
        return ACTION_FAMILY_37_ERR_ARGUMENT;
    }
    if (output_handle == 0u) {
        return ACTION_FAMILY_37_ERR_ARGUMENT;
    }
    status = validate_body(raw_body, raw_body_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_37_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, &decoded);

    memset(&constructed, 0, sizeof(constructed));
    /* Original allocates and zeroes exactly 0xABA bytes before initializing. */
    initialize_original_defaults(constructed.object_bytes, &decoded);

    while (name_bytes < sizeof(decoded.name) && decoded.name[name_bytes] != '\0') {
        ++name_bytes;
    }
    memcpy(constructed.object_bytes, decoded.name, name_bytes + 1u);
    write_u16_le(constructed.object_bytes + 0x23u, decoded.option_21);
    write_u16_le(constructed.object_bytes + 0x27u, decoded.option_23);
    for (index = 0u; index < 4u; ++index) {
        write_u32_le(constructed.object_bytes + 0xacu + index * 4u,
                     (uint32_t)decoded.initial_geometry[index]);
    }

    constructed.dependency_records = decoded.dependency_records;
    constructed.dependency_count = decoded.dependency_count;
    constructed.dependency_bytes = decoded.dependency_bytes;
    constructed.available_body_bytes = decoded.available_body_bytes;
    constructed.body_bytes_consumed = ACTION_FAMILY_37_BODY_BYTES;
    constructed.payload_offset_before = payload_offset_before;
    /* x86 DWORD addition is defined here as unsigned modulo-2^32 arithmetic. */
    constructed.payload_offset_after =
        payload_offset_before + (uint32_t)ACTION_FAMILY_37_BODY_BYTES;
    constructed.owner_links.output_handle = output_handle;
    constructed.owner_links.result_slot_handle = output_handle;
    constructed.owner_links.owner_slot_1c_handle = output_handle;
    constructed.owner_links.owner_slot_20_handle = output_handle;
    constructed.owner_links.output_allocation_bytes =
        ACTION_FAMILY_37_OBJECT_BYTES;

    memcpy(out, &constructed, sizeof(constructed));
    return ACTION_FAMILY_37_OK;
}
