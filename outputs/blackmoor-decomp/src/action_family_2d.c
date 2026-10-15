/* Behavioural reconstruction from original x86 FUN_004cd243 (loader arm
 * 0x40c0e0) and its allocation wrapper FUN_004cf1e4. This does not claim
 * original C++ provenance or an x86 byte-matching rebuild. */
#include "action_family_2d.h"

#include <string.h>

typedef struct {
    int16_t entry_count;
    int16_t record34_count;
    size_t record35_total;
    size_t entries_bytes;
    size_t records_34_bytes;
    size_t body_bytes;
} Layout;

static uint16_t read_u16_le(const uint8_t *p)
{
    return (uint16_t)((uint16_t)p[0] | ((uint16_t)p[1] << 8));
}

static int16_t read_i16_le(const uint8_t *p)
{
    return (int16_t)read_u16_le(p);
}

static uint32_t read_u32_le(const uint8_t *p)
{
    return (uint32_t)p[0] | ((uint32_t)p[1] << 8) | ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
}

static void write_u32_le(uint8_t *p, uint32_t v)
{
    p[0] = (uint8_t)v;
    p[1] = (uint8_t)(v >> 8);
    p[2] = (uint8_t)(v >> 16);
    p[3] = (uint8_t)(v >> 24);
}

static int span_valid(const void *pointer, size_t length)
{
    return pointer != NULL && (uintmax_t)length <=
        (uintmax_t)UINTPTR_MAX - (uintmax_t)(uintptr_t)pointer;
}

/* Called only after span_valid for both spans. */
static int overlap(const void *a, size_t na, const void *b, size_t nb)
{
    uintptr_t aa = (uintptr_t)a;
    uintptr_t bb = (uintptr_t)b;
    return na != 0u && nb != 0u && aa < bb + nb && bb < aa + na;
}

static ActionFamily2DStatus validate_spans(
    const uint8_t *raw, size_t length, const void *out, size_t out_size)
{
    if (raw == NULL || out == NULL) {
        return ACTION_FAMILY_2D_ERR_ARGUMENT;
    }
    if (!span_valid(raw, length) || !span_valid(out, out_size)) {
        return ACTION_FAMILY_2D_ERR_BOUNDS;
    }
    if (overlap(raw, length, out, out_size)) {
        return ACTION_FAMILY_2D_ERR_OVERLAP;
    }
    return ACTION_FAMILY_2D_OK;
}

/* All reads are bounded by length before they happen. FUN_004cd243 widens each
 * signed word with MOVSX/IMUL into 32-bit arithmetic and requests that many
 * bytes without any bound against the ACT; negative counts become allocation
 * requests of at least 0xFFE58000 bytes, which are rejected here instead.
 * Nonnegative int16 counts keep every product below 1,736,704 bytes. */
static ActionFamily2DStatus scan_body(const uint8_t *raw, size_t length, Layout *lay)
{
    int16_t entries;
    int16_t groups;
    size_t cursor = ACTION_FAMILY_2D_HEADER_BYTES;
    size_t total = 0u;
    size_t i;

    if (length < ACTION_FAMILY_2D_HEADER_BYTES) {
        return ACTION_FAMILY_2D_ERR_BODY;
    }
    entries = read_i16_le(raw + 0x23u);
    groups = read_i16_le(raw + 0x25u);
    if (entries < 0 || groups < 0) {
        return ACTION_FAMILY_2D_ERR_COUNT;
    }
    for (i = 0u; i < (size_t)entries; ++i) {
        int16_t n;
        size_t need;
        if (length - cursor < ACTION_FAMILY_2D_ENTRY_FILE_BYTES) {
            return ACTION_FAMILY_2D_ERR_BODY;
        }
        n = read_i16_le(raw + cursor + 0x2fu);
        if (n < 0) {
            return ACTION_FAMILY_2D_ERR_COUNT;
        }
        need = ACTION_FAMILY_2D_ENTRY_FILE_BYTES + ACTION_FAMILY_2D_RECORD35_BYTES * (size_t)n;
        if (length - cursor < need) {
            return ACTION_FAMILY_2D_ERR_BODY;
        }
        cursor += need;
        total += (size_t)n;
    }
    lay->entries_bytes = cursor - ACTION_FAMILY_2D_HEADER_BYTES;
    lay->records_34_bytes = ACTION_FAMILY_2D_RECORD34_BYTES * (size_t)groups;
    if (length - cursor < lay->records_34_bytes) {
        return ACTION_FAMILY_2D_ERR_BODY;
    }
    lay->body_bytes = cursor + lay->records_34_bytes;
    if ((length - lay->body_bytes) % ACTION_FAMILY_2D_DEPENDENCY_BYTES != 0u) {
        return ACTION_FAMILY_2D_ERR_TAIL;
    }
    lay->entry_count = entries;
    lay->record34_count = groups;
    lay->record35_total = total;
    return ACTION_FAMILY_2D_OK;
}

static ActionFamily2DStatus validate_and_scan(
    const uint8_t *raw, size_t length, const void *out, size_t out_size, Layout *lay)
{
    ActionFamily2DStatus status = validate_spans(raw, length, out, out_size);
    if (status != ACTION_FAMILY_2D_OK) {
        return status;
    }
    return scan_body(raw, length, lay);
}

ActionFamily2DStatus action_family_2d_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily2DDecoded *out)
{
    Layout lay;
    ActionFamily2DDecoded d;
    ActionFamily2DStatus status = validate_and_scan(
        raw_body, raw_body_length, out, sizeof(*out), &lay);
    if (status != ACTION_FAMILY_2D_OK) {
        return status;
    }
    memset(&d, 0, sizeof(d));
    memcpy(d.name, raw_body, sizeof(d.name));
    d.word_21 = read_u16_le(raw_body + 0x21u);
    d.entry_count = lay.entry_count;
    d.record34_count = lay.record34_count;
    d.entries = raw_body + ACTION_FAMILY_2D_HEADER_BYTES;
    d.entries_bytes = lay.entries_bytes;
    d.record35_total = lay.record35_total;
    d.records_34 = d.entries + lay.entries_bytes;
    d.records_34_bytes = lay.records_34_bytes;
    d.dependency_records = raw_body + lay.body_bytes;
    d.dependency_bytes = raw_body_length - lay.body_bytes;
    d.dependency_count = d.dependency_bytes / ACTION_FAMILY_2D_DEPENDENCY_BYTES;
    d.available_body_bytes = raw_body_length;
    d.body_bytes = lay.body_bytes;
    d.raw_type = ACTION_FAMILY_2D_RAW_TYPE;
    d.runtime_type = ACTION_FAMILY_2D_RUNTIME_TYPE;
    memcpy(out, &d, sizeof(d));
    return ACTION_FAMILY_2D_OK;
}

ActionFamily2DStatus action_family_2d_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *body_bytes)
{
    Layout lay;
    ActionFamily2DStatus status = validate_and_scan(
        raw_body, raw_body_length, body_bytes, sizeof(*body_bytes), &lay);
    if (status != ACTION_FAMILY_2D_OK) {
        return status;
    }
    *body_bytes = lay.body_bytes;
    return ACTION_FAMILY_2D_OK;
}

/* Offset of entry `index` within raw (validated layout, index < entry_count). */
static size_t entry_offset(const uint8_t *raw, size_t index)
{
    size_t cursor = ACTION_FAMILY_2D_HEADER_BYTES;
    size_t i;
    for (i = 0u; i < index; ++i) {
        cursor += ACTION_FAMILY_2D_ENTRY_FILE_BYTES +
            ACTION_FAMILY_2D_RECORD35_BYTES * (size_t)read_i16_le(raw + cursor + 0x2fu);
    }
    return cursor;
}

ActionFamily2DStatus action_family_2d_entry_at(
    const uint8_t *raw_body, size_t raw_body_length, size_t index, ActionFamily2DEntry *out)
{
    Layout lay;
    ActionFamily2DEntry e;
    const uint8_t *p;
    ActionFamily2DStatus status = validate_and_scan(
        raw_body, raw_body_length, out, sizeof(*out), &lay);
    if (status != ACTION_FAMILY_2D_OK) {
        return status;
    }
    if (index >= (size_t)lay.entry_count) {
        return ACTION_FAMILY_2D_ERR_INDEX;
    }
    p = raw_body + entry_offset(raw_body, index);
    memset(&e, 0, sizeof(e));
    memcpy(e.name, p, sizeof(e.name));
    e.word_21 = read_u16_le(p + 0x21u);
    e.word_23 = read_u16_le(p + 0x23u);
    e.dword_25 = read_u32_le(p + 0x25u);
    e.dword_29 = read_u32_le(p + 0x29u);
    e.word_2d = read_u16_le(p + 0x2du);
    e.record35_count = read_i16_le(p + 0x2fu);
    e.records_35 = p + ACTION_FAMILY_2D_ENTRY_FILE_BYTES;
    e.records_35_bytes = ACTION_FAMILY_2D_RECORD35_BYTES * (size_t)e.record35_count;
    memcpy(out, &e, sizeof(e));
    return ACTION_FAMILY_2D_OK;
}

ActionFamily2DStatus action_family_2d_record35_at(
    const uint8_t *raw_body, size_t raw_body_length, size_t entry_index,
    size_t record_index, ActionFamily2DRecord35 *out)
{
    Layout lay;
    ActionFamily2DRecord35 r;
    const uint8_t *p;
    ActionFamily2DStatus status = validate_and_scan(
        raw_body, raw_body_length, out, sizeof(*out), &lay);
    if (status != ACTION_FAMILY_2D_OK) {
        return status;
    }
    if (entry_index >= (size_t)lay.entry_count) {
        return ACTION_FAMILY_2D_ERR_INDEX;
    }
    p = raw_body + entry_offset(raw_body, entry_index);
    if (record_index >= (size_t)read_i16_le(p + 0x2fu)) {
        return ACTION_FAMILY_2D_ERR_INDEX;
    }
    memcpy(r.bytes, p + ACTION_FAMILY_2D_ENTRY_FILE_BYTES +
           record_index * ACTION_FAMILY_2D_RECORD35_BYTES, sizeof(r.bytes));
    memcpy(out, &r, sizeof(r));
    return ACTION_FAMILY_2D_OK;
}

ActionFamily2DStatus action_family_2d_record34_at(
    const uint8_t *raw_body, size_t raw_body_length, size_t index, ActionFamily2DRecord34 *out)
{
    Layout lay;
    ActionFamily2DRecord34 r;
    ActionFamily2DStatus status = validate_and_scan(
        raw_body, raw_body_length, out, sizeof(*out), &lay);
    if (status != ACTION_FAMILY_2D_OK) {
        return status;
    }
    if (index >= (size_t)lay.record34_count) {
        return ACTION_FAMILY_2D_ERR_INDEX;
    }
    memcpy(r.bytes, raw_body + lay.body_bytes - lay.records_34_bytes +
           index * ACTION_FAMILY_2D_RECORD34_BYTES, sizeof(r.bytes));
    memcpy(out, &r, sizeof(r));
    return ACTION_FAMILY_2D_OK;
}

ActionFamily2DStatus action_family_2d_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, int16_t action_index,
    const uint32_t *handles, size_t handle_count,
    uint8_t *image, size_t image_capacity, ActionFamily2DConstructed *out)
{
    Layout lay;
    ActionFamily2DConstructed c;
    ActionFamily2DStatus status;
    size_t image_bytes;
    size_t i;
    size_t cursor;
    size_t table;
    size_t blocks;

    if (raw_body == NULL || out == NULL || image == NULL || handles == NULL) {
        return ACTION_FAMILY_2D_ERR_ARGUMENT;
    }
    if (!span_valid(raw_body, raw_body_length) || !span_valid(out, sizeof(*out)) ||
        !span_valid(image, image_capacity) ||
        (handle_count > SIZE_MAX / sizeof(*handles)) ||
        !span_valid(handles, handle_count * sizeof(*handles))) {
        return ACTION_FAMILY_2D_ERR_BOUNDS;
    }
    if (overlap(raw_body, raw_body_length, out, sizeof(*out)) ||
        overlap(raw_body, raw_body_length, image, image_capacity) ||
        overlap(out, sizeof(*out), image, image_capacity) ||
        overlap(handles, handle_count * sizeof(*handles), out, sizeof(*out)) ||
        overlap(handles, handle_count * sizeof(*handles), image, image_capacity)) {
        return ACTION_FAMILY_2D_ERR_OVERLAP;
    }
    status = scan_body(raw_body, raw_body_length, &lay);
    if (status != ACTION_FAMILY_2D_OK) {
        return status;
    }
    if (handle_count != 3u + (size_t)lay.entry_count) {
        return ACTION_FAMILY_2D_ERR_ARGUMENT;
    }
    for (i = 0u; i < handle_count; ++i) {
        if (handles[i] == 0u) {
            return ACTION_FAMILY_2D_ERR_ARGUMENT;
        }
    }
    image_bytes = ACTION_FAMILY_2D_HEADER_BYTES +
        ACTION_FAMILY_2D_ENTRY_OBJECT_BYTES * (size_t)lay.entry_count +
        ACTION_FAMILY_2D_RECORD35_BYTES * lay.record35_total + lay.records_34_bytes;
    if (image_capacity < image_bytes) {
        return ACTION_FAMILY_2D_ERR_CAPACITY;
    }

    /* Block 0: the 39 header bytes. Block 1: the entry table, each entry's 49
     * copied bytes followed by the 4-byte pointer of its 35-byte record block
     * (the allocation sequence stores that pointer before the block is
     * zero-filled and filled). Blocks 2..: record blocks in entry order, then
     * the 34-byte record block. */
    memcpy(image, raw_body, ACTION_FAMILY_2D_HEADER_BYTES);
    table = ACTION_FAMILY_2D_HEADER_BYTES;
    blocks = table + ACTION_FAMILY_2D_ENTRY_OBJECT_BYTES * (size_t)lay.entry_count;
    cursor = ACTION_FAMILY_2D_HEADER_BYTES;
    for (i = 0u; i < (size_t)lay.entry_count; ++i) {
        size_t records = ACTION_FAMILY_2D_RECORD35_BYTES *
            (size_t)read_i16_le(raw_body + cursor + 0x2fu);
        uint8_t *entry = image + table + i * ACTION_FAMILY_2D_ENTRY_OBJECT_BYTES;
        memcpy(entry, raw_body + cursor, ACTION_FAMILY_2D_ENTRY_FILE_BYTES);
        write_u32_le(entry + ACTION_FAMILY_2D_ENTRY_FILE_BYTES, handles[2u + i]);
        memcpy(image + blocks, raw_body + cursor + ACTION_FAMILY_2D_ENTRY_FILE_BYTES, records);
        blocks += records;
        cursor += ACTION_FAMILY_2D_ENTRY_FILE_BYTES + records;
    }
    memcpy(image + blocks, raw_body + cursor, lay.records_34_bytes);

    memset(&c, 0, sizeof(c));
    c.allocation_count = handle_count;
    c.image_bytes = image_bytes;
    c.body_bytes_consumed = lay.body_bytes;
    c.dependency_records = raw_body + lay.body_bytes;
    c.dependency_bytes = raw_body_length - lay.body_bytes;
    c.dependency_count = c.dependency_bytes / ACTION_FAMILY_2D_DEPENDENCY_BYTES;
    c.available_body_bytes = raw_body_length;
    c.payload_offset_before = payload_offset_before;
    c.payload_offset_after = payload_offset_before + (uint32_t)lay.body_bytes; /* wraps */
    c.result_slot_handle = handles[0];
    c.owner_header_handle = handles[0];
    c.owner_entry_table_handle = handles[1];
    c.owner_group_handle = handles[handle_count - 1u];
    c.owner_action_index = (int32_t)action_index; /* MOVSX of the word at 0x5c39e3 */
    c.raw_type = ACTION_FAMILY_2D_RAW_TYPE;
    c.runtime_type = ACTION_FAMILY_2D_RUNTIME_TYPE;
    memcpy(out, &c, sizeof(c));
    return ACTION_FAMILY_2D_OK;
}
