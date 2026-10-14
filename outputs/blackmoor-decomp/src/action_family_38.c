#include "action_family_38.h"

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

static uint32_t read_u32(const uint8_t *p)
{
    return (uint32_t)p[0] | ((uint32_t)p[1] << 8) |
        ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
}

static int32_t read_i32(const uint8_t *p)
{
    uint32_t bits = read_u32(p);
    return bits <= INT32_MAX ? (int32_t)bits :
        -1 - (int32_t)(UINT32_MAX - bits);
}

static void write_u16(uint8_t *p, uint16_t v)
{
    p[0] = (uint8_t)v;
    p[1] = (uint8_t)(v >> 8);
}

static void write_u32(uint8_t *p, uint32_t v)
{
    p[0] = (uint8_t)v;
    p[1] = (uint8_t)(v >> 8);
    p[2] = (uint8_t)(v >> 16);
    p[3] = (uint8_t)(v >> 24);
}

/* This validates address arithmetic, not arbitrary-address mappedness. */
static ActionFamily38Status check_spans(const void *input, size_t input_length,
                                       const void *out, size_t out_length)
{
    uintptr_t a = (uintptr_t)input;
    uintptr_t b = (uintptr_t)out;
    if (input == NULL || out == NULL) {
        return ACTION_FAMILY_38_ERR_ARGUMENT;
    }
    if (input_length > UINTPTR_MAX - a || out_length > UINTPTR_MAX - b) {
        return ACTION_FAMILY_38_ERR_BOUNDS;
    }
    if (input_length != 0u && a < b + out_length && b < a + input_length) {
        return ACTION_FAMILY_38_ERR_OVERLAP;
    }
    return ACTION_FAMILY_38_OK;
}

static ActionFamily38Status validate_body(const uint8_t *raw, size_t length,
                                         const void *out, size_t out_length,
                                         size_t *body_bytes, size_t *frames)
{
    int32_t count;
    ActionFamily38Status status = check_spans(raw, length, out, out_length);
    if (status != ACTION_FAMILY_38_OK) {
        return status;
    }
    if (length < ACTION_FAMILY_38_PREFIX_BYTES) {
        return ACTION_FAMILY_38_ERR_BODY;
    }
    /* MOVSX at 0x4893b8/0x4893c2; SUB/ADD are DWORD operations. */
    count = (int32_t)read_i16(raw + 0x35u) -
        (int32_t)read_i16(raw + 0x33u) + 1;
    if (count < 0 || count > (int32_t)ACTION_FAMILY_38_MAX_FRAMES) {
        return ACTION_FAMILY_38_ERR_COUNT;
    }
    *frames = (size_t)count;
    *body_bytes = ACTION_FAMILY_38_PREFIX_BYTES +
        *frames * ACTION_FAMILY_38_FRAME_BYTES;
    if (length < *body_bytes) {
        return ACTION_FAMILY_38_ERR_BODY;
    }
    if (memchr(raw, 0, 33u) == NULL) {
        return ACTION_FAMILY_38_ERR_NAME;
    }
    if ((length - *body_bytes) % ACTION_FAMILY_38_DEPENDENCY_BYTES != 0u) {
        return ACTION_FAMILY_38_ERR_TAIL;
    }
    return ACTION_FAMILY_38_OK;
}

static void decode_validated(const uint8_t *raw, size_t length,
                             size_t body_bytes, size_t frames,
                             ActionFamily38Decoded *d)
{
    size_t name_length = (size_t)((const uint8_t *)memchr(raw, 0, 33u) - raw);
    size_t i;
    memset(d, 0, sizeof(*d));
    memcpy(d->name, raw, name_length + 1u);
    d->option_21 = read_u16(raw + 0x21u);
    d->option_23 = read_u16(raw + 0x23u);
    d->option_25 = read_u16(raw + 0x25u);
    d->option_27 = read_u16(raw + 0x27u);
    d->option_29 = read_u16(raw + 0x29u);
    d->option_2b = read_u16(raw + 0x2bu);
    d->option_2d = read_u16(raw + 0x2du);
    d->option_2f = read_u16(raw + 0x2fu);
    d->option_31 = read_u16(raw + 0x31u);
    d->frame_start = read_i16(raw + 0x33u);
    d->frame_end = read_i16(raw + 0x35u);
    for (i = 0u; i < 4u; ++i) {
        d->fixed_rect[i] = read_i32(raw + 0x37u + i * 4u);
    }
    d->frame_records = raw + ACTION_FAMILY_38_PREFIX_BYTES;
    d->frame_count = frames;
    d->dependency_records = raw + body_bytes;
    d->dependency_count = (length - body_bytes) / ACTION_FAMILY_38_DEPENDENCY_BYTES;
    d->available_body_bytes = length;
    d->body_bytes = body_bytes;
    d->dependency_bytes = length - body_bytes;
}

ActionFamily38Status action_family_38_decode(
    const uint8_t *raw_body, size_t raw_body_length,
    ActionFamily38Decoded *out)
{
    ActionFamily38Decoded decoded;
    size_t body_bytes;
    size_t frames;
    ActionFamily38Status status = validate_body(raw_body, raw_body_length,
        out, sizeof(*out), &body_bytes, &frames);
    if (status != ACTION_FAMILY_38_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, body_bytes, frames, &decoded);
    memcpy(out, &decoded, sizeof(decoded));
    return ACTION_FAMILY_38_OK;
}

ActionFamily38Status action_family_38_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    const uint8_t *allocation_before, size_t allocation_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamily38Constructed *out)
{
    ActionFamily38Decoded d;
    ActionFamily38Constructed result;
    ActionFamily38Status status;
    size_t body_bytes;
    size_t frames;
    size_t i;
    uint8_t *object = result.object_bytes;
    if (raw_body == NULL || allocation_before == NULL || out == NULL ||
        output_handle == 0u) {
        return ACTION_FAMILY_38_ERR_ARGUMENT;
    }
    if (allocation_length != ACTION_FAMILY_38_OBJECT_BYTES) {
        return ACTION_FAMILY_38_ERR_ALLOCATION;
    }
    status = check_spans(allocation_before, allocation_length, out, sizeof(*out));
    if (status != ACTION_FAMILY_38_OK) {
        return status;
    }
    status = validate_body(raw_body, raw_body_length, out, sizeof(*out),
        &body_bytes, &frames);
    if (status != ACTION_FAMILY_38_OK) {
        return status;
    }
    decode_validated(raw_body, raw_body_length, body_bytes, frames, &d);
    memset(&result, 0, sizeof(result));
    memcpy(object, allocation_before, ACTION_FAMILY_38_OBJECT_BYTES);
    /* REP STOSD with ECX=0x2b at 0x4890c2 clears only this prefix. */
    memset(object, 0, 0xacu);
    memcpy(object, d.name, strlen(d.name) + 1u);
    write_u16(object + 0x21u, d.option_21);
    write_u16(object + 0x23u, d.option_23);
    write_u16(object + 0x25u, d.option_25);
    write_u16(object + 0x27u, d.option_27);
    write_u16(object + 0x29u, 2u);
    write_u16(object + 0x2du, d.option_29);
    write_u16(object + 0x2fu, d.option_2b);
    write_u16(object + 0x33u, (uint16_t)d.frame_start);
    write_u16(object + 0x35u, (uint16_t)d.frame_end);
    write_u16(object + 0x37u, 15u);
    write_u16(object + 0x39u, UINT16_MAX);
    write_u16(object + 0x3du, d.option_2d);
    write_u16(object + 0x43u, 1u);
    write_u32(object + 0x4du, 1u);
    write_u16(object + 0x51u, d.option_2f);
    write_u16(object + 0x53u, d.option_31);
    for (i = 1u; i < 10u; ++i) {
        write_u16(object + 0x51u + i * 4u, UINT16_MAX);
    }
    memcpy(object + 0x79u, "NO SOUND", 9u);
    write_u16(object + 0xaau, 1u);
    write_u16(object + 0x6ecu, 0u);
    write_u16(object + 0x6eeu, 0u);
    write_u16(object + 0x6f0u, 2u);
    write_u32(object + 0x6f2u, 0u);
    write_u32(object + 0x6f6u, 0u);
    write_u32(object + 0x6fau, (uint32_t)d.fixed_rect[2] - (uint32_t)d.fixed_rect[0]);
    write_u32(object + 0x6feu, (uint32_t)d.fixed_rect[3] - (uint32_t)d.fixed_rect[1]);
    for (i = 0u; i < 4u; ++i) {
        write_u32(object + 0x702u + i * 4u, (uint32_t)d.fixed_rect[i]);
    }
    /* Original frame copy occurs after the rectangle-derived writes. The
     * native 100-frame bound prevents it from overwriting those fields. */
    memcpy(object + 0xacu, d.frame_records, frames * ACTION_FAMILY_38_FRAME_BYTES);
    result.dependency_records = d.dependency_records;
    result.dependency_count = d.dependency_count;
    result.dependency_bytes = d.dependency_bytes;
    result.available_body_bytes = raw_body_length;
    result.body_bytes_consumed = body_bytes;
    result.payload_offset_before = payload_offset_before;
    result.payload_offset_after = payload_offset_before + (uint32_t)body_bytes;
    result.owner_links.output_handle = output_handle;
    result.owner_links.result_slot_handle = output_handle;
    result.owner_links.owner_slot_1c_handle = output_handle;
    result.owner_links.owner_slot_20_handle = output_handle;
    result.owner_links.output_allocation_bytes = ACTION_FAMILY_38_OBJECT_BYTES;
    memcpy(out, &result, sizeof(result));
    return ACTION_FAMILY_38_OK;
}
