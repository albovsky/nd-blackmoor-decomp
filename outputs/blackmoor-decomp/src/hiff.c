#include "hiff.h"

#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct hiff_data_record {
    HiffDataInfo info;
} hiff_data_record;

typedef struct hiff_chunk_record {
    HiffChunkInfo info;
    int used;
} hiff_chunk_record;

struct Hiff {
    uint8_t *bytes;
    size_t length;
    hiff_data_record data[HIFF_MAX_DATA_RECORDS];
    hiff_chunk_record chunks[HIFF_MAX_CHUNKS];
    size_t data_count;
    size_t chunk_count;
    size_t selected_data_index;
    size_t selected_chunk_index;
    hiff_selection_kind last_selection_kind;
};

static void clear_error(char *error, size_t capacity)
{
    if (error != NULL && capacity != 0u) {
        error[0] = '\0';
    }
}

static void set_error(char *error, size_t capacity, const char *format, ...)
{
    va_list arguments;

    if (error == NULL || capacity == 0u) {
        return;
    }
    va_start(arguments, format);
    (void)vsnprintf(error, capacity, format, arguments);
    va_end(arguments);
}

static uint32_t read_be32(const uint8_t *bytes)
{
    return ((uint32_t)bytes[0] << 24) |
           ((uint32_t)bytes[1] << 16) |
           ((uint32_t)bytes[2] << 8) |
           (uint32_t)bytes[3];
}

/* FUN_00434814 copies up to four bytes, stops at the first NUL, then appends
 * a NUL.  The original callers compare that temporary string with strcmp.
 */
static void copy_fourcc(char output[5], const uint8_t *input)
{
    size_t index;

    for (index = 0u; index < 4u && input[index] != 0u; ++index) {
        output[index] = (char)input[index];
    }
    output[index] = '\0';
    while (++index < 5u) {
        output[index] = '\0';
    }
}

static int fourcc_matches(const uint8_t field[4], const char *name)
{
    char stored_name[5];

    copy_fourcc(stored_name, field);
    return strcmp(stored_name, name) == 0;
}

static size_t find_data_at(const Hiff *hiff, size_t offset)
{
    size_t index;

    for (index = 0u; index < hiff->data_count; ++index) {
        if (hiff->data[index].info.record_offset == offset) {
            return index;
        }
    }
    return SIZE_MAX;
}

static int scan_data_records(Hiff *hiff, char *error, size_t error_capacity)
{
    size_t offset = 0u;

    while (offset <= hiff->length && hiff->length - offset >= 4u) {
        HiffDataInfo *record;
        uint32_t declared_size;
        size_t remaining;

        if (memcmp(hiff->bytes + offset, "DATA", 4u) != 0) {
            ++offset;
            continue;
        }

        remaining = hiff->length - offset;
        if (remaining < 8u) {
            set_error(error, error_capacity,
                      "DATA signature at offset 0x%zx has a truncated size field", offset);
            return HIFF_ERR_BOUNDS;
        }
        declared_size = read_be32(hiff->bytes + offset + 4u);
        if (declared_size < 4u) {
            set_error(error, error_capacity,
                      "DATA record at offset 0x%zx is too small to contain its four-byte type",
                      offset);
            return HIFF_ERR_FORMAT;
        }
        if (declared_size > remaining - 8u) {
            set_error(error, error_capacity,
                      "DATA record at offset 0x%zx declares 0x%x bytes past input end",
                      offset, (unsigned int)declared_size);
            return HIFF_ERR_BOUNDS;
        }
        if (hiff->data_count >= HIFF_MAX_DATA_RECORDS) {
            set_error(error, error_capacity,
                      "DATA record limit (%u) exceeded at offset 0x%zx",
                      HIFF_MAX_DATA_RECORDS, offset);
            return HIFF_ERR_LIMIT;
        }

        record = &hiff->data[hiff->data_count].info;
        record->record_offset = offset;
        record->type_offset = offset + 8u;
        record->body_offset = offset + 12u;
        record->extent_size = (size_t)declared_size + 8u;
        record->declared_size = declared_size;
        copy_fourcc(record->type, hiff->bytes + record->type_offset);
        ++hiff->data_count;

        /* FUN_00433eaa resumes byte scanning at the found signature + 16. */
        if (hiff->length - offset <= 16u) {
            break;
        }
        offset += 16u;
    }
    return HIFF_OK;
}

static int append_chunk(Hiff *hiff,
                        size_t data_index,
                        size_t header_offset,
                        uint32_t payload_size,
                        char *error,
                        size_t error_capacity)
{
    HiffChunkInfo *chunk;

    if (hiff->chunk_count >= HIFF_MAX_CHUNKS) {
        set_error(error, error_capacity,
                  "chunk limit (%u) exceeded at offset 0x%zx",
                  HIFF_MAX_CHUNKS, header_offset);
        return HIFF_ERR_LIMIT;
    }
    chunk = &hiff->chunks[hiff->chunk_count].info;
    chunk->data_index = data_index;
    chunk->header_offset = header_offset;
    chunk->payload_offset = header_offset + 8u;
    chunk->payload_size = payload_size;
    chunk->padded_extent_size = 8u + (size_t)payload_size + (size_t)(payload_size & 1u);
    copy_fourcc(chunk->id, hiff->bytes + header_offset);
    hiff->chunks[hiff->chunk_count].used = 0;
    ++hiff->chunk_count;
    return HIFF_OK;
}

static int index_chunks(Hiff *hiff, char *error, size_t error_capacity)
{
    size_t data_index;

    for (data_index = 0u; data_index < hiff->data_count; ++data_index) {
        const HiffDataInfo *record = &hiff->data[data_index].info;
        size_t position;
        size_t end;

        /* The original reports DATA blocks smaller than nine as invalid. */
        if (record->declared_size < 9u) {
            set_error(error, error_capacity,
                      "DATA record %zu at offset 0x%zx is smaller than 9 bytes",
                      data_index, record->record_offset);
            return HIFF_ERR_FORMAT;
        }

        position = record->body_offset;
        end = record->record_offset + record->extent_size;
        while (position < end) {
            size_t remaining = end - position;
            int status;

            if (remaining < 4u) {
                set_error(error, error_capacity,
                          "DATA record %zu ends with a short chunk identifier at 0x%zx",
                          data_index, position);
                return HIFF_ERR_BOUNDS;
            }
            if (memcmp(hiff->bytes + position, "DATA", 4u) == 0) {
                size_t nested_index = find_data_at(hiff, position);
                size_t nested_extent;

                if (nested_index == SIZE_MAX) {
                    set_error(error, error_capacity,
                              "nested DATA at offset 0x%zx was not indexed by byte scan",
                              position);
                    return HIFF_ERR_FORMAT;
                }
                nested_extent = hiff->data[nested_index].info.extent_size;
                if (nested_extent > remaining) {
                    set_error(error, error_capacity,
                              "nested DATA at offset 0x%zx extends past parent DATA record %zu",
                              position, data_index);
                    return HIFF_ERR_BOUNDS;
                }
                position += nested_extent;
                if (position >= end) {
                    break;
                }
                /* The original jumps over one nested DATA and then falls
                 * through to its ordinary chunk insertion path.  In an
                 * adjacent-DATA sequence the following DATA header is thus
                 * indexed as a chunk; do not recursively skip it here.
                 */
                remaining = end - position;
            }

            if (remaining < 8u) {
                set_error(error, error_capacity,
                          "DATA record %zu has a truncated chunk header at 0x%zx",
                          data_index, position);
                return HIFF_ERR_BOUNDS;
            }
            {
                uint32_t payload_size = read_be32(hiff->bytes + position + 4u);
                size_t padded_size = (size_t)payload_size + (size_t)(payload_size & 1u);

                if (padded_size > remaining - 8u) {
                    set_error(error, error_capacity,
                              "chunk at offset 0x%zx declares 0x%x payload bytes past DATA record %zu",
                              position, (unsigned int)payload_size, data_index);
                    return HIFF_ERR_BOUNDS;
                }
                status = append_chunk(hiff, data_index, position, payload_size,
                                      error, error_capacity);
                if (status != HIFF_OK) {
                    return status;
                }
                position += 8u + padded_size;
            }
        }
    }
    return HIFF_OK;
}

Hiff *hiff_open_memory(const void *bytes,
                       size_t length,
                       char *error,
                       size_t error_capacity)
{
    Hiff *hiff;
    int status;

    clear_error(error, error_capacity);
    if (bytes == NULL && length != 0u) {
        set_error(error, error_capacity, "non-empty input requires a byte pointer");
        return NULL;
    }

    hiff = (Hiff *)calloc(1u, sizeof(*hiff));
    if (hiff == NULL) {
        set_error(error, error_capacity, "unable to allocate HIFF parser state");
        return NULL;
    }
    hiff->bytes = (uint8_t *)malloc(length == 0u ? 1u : length);
    if (hiff->bytes == NULL) {
        set_error(error, error_capacity, "unable to allocate %zu input bytes", length);
        free(hiff);
        return NULL;
    }
    if (length != 0u) {
        memcpy(hiff->bytes, bytes, length);
    }
    hiff->length = length;
    hiff->selected_data_index = SIZE_MAX;
    hiff->selected_chunk_index = SIZE_MAX;
    hiff->last_selection_kind = HIFF_SELECTION_NONE;

    status = scan_data_records(hiff, error, error_capacity);
    if (status == HIFF_OK) {
        status = index_chunks(hiff, error, error_capacity);
    }
    if (status != HIFF_OK) {
        free(hiff->bytes);
        free(hiff);
        return NULL;
    }
    return hiff;
}

void hiff_close(Hiff *hiff)
{
    if (hiff != NULL) {
        free(hiff->bytes);
        free(hiff);
    }
}

size_t hiff_data_count(const Hiff *hiff)
{
    return hiff == NULL ? 0u : hiff->data_count;
}

size_t hiff_chunk_count(const Hiff *hiff)
{
    return hiff == NULL ? 0u : hiff->chunk_count;
}

int hiff_data_at(const Hiff *hiff, size_t index, HiffDataInfo *info)
{
    if (hiff == NULL || info == NULL) {
        return HIFF_ERR_ARGUMENT;
    }
    if (index >= hiff->data_count) {
        return HIFF_ERR_NOT_FOUND;
    }
    *info = hiff->data[index].info;
    return HIFF_OK;
}

int hiff_chunk_at(const Hiff *hiff, size_t index, HiffChunkInfo *info)
{
    if (hiff == NULL || info == NULL) {
        return HIFF_ERR_ARGUMENT;
    }
    if (index >= hiff->chunk_count) {
        return HIFF_ERR_NOT_FOUND;
    }
    *info = hiff->chunks[index].info;
    return HIFF_OK;
}

int hiff_select_data(Hiff *hiff, const char *type)
{
    size_t index;

    if (hiff == NULL || type == NULL) {
        return HIFF_ERR_ARGUMENT;
    }
    for (index = 0u; index < hiff->data_count; ++index) {
        if (strcmp(hiff->data[index].info.type, type) == 0) {
            hiff->selected_data_index = index;
            hiff->last_selection_kind = HIFF_SELECTION_DATA;
            return HIFF_OK;
        }
    }
    return HIFF_ERR_NOT_FOUND;
}

static int select_chunk_index(Hiff *hiff, const char *id, int require_unused)
{
    size_t index;

    if (hiff == NULL || id == NULL) {
        return HIFF_ERR_ARGUMENT;
    }
    for (index = 0u; index < hiff->chunk_count; ++index) {
        hiff_chunk_record *chunk = &hiff->chunks[index];
        if (fourcc_matches((const uint8_t *)chunk->info.id, id) &&
            (!require_unused || chunk->used == 0)) {
            chunk->used = 1;
            hiff->selected_chunk_index = index;
            hiff->last_selection_kind = HIFF_SELECTION_CHUNK;
            return HIFF_OK;
        }
    }
    return HIFF_ERR_NOT_FOUND;
}

int hiff_select_chunk(Hiff *hiff, const char *id)
{
    size_t index;

    if (hiff == NULL || id == NULL) {
        return HIFF_ERR_ARGUMENT;
    }
    for (index = 0u; index < hiff->chunk_count; ++index) {
        if (fourcc_matches((const uint8_t *)hiff->chunks[index].info.id, id)) {
            hiff->selected_chunk_index = index;
            hiff->last_selection_kind = HIFF_SELECTION_CHUNK;
            return HIFF_OK;
        }
    }
    return HIFF_ERR_NOT_FOUND;
}

int hiff_select_first(Hiff *hiff, const char *id)
{
    size_t index;

    if (hiff == NULL || id == NULL) {
        return HIFF_ERR_ARGUMENT;
    }
    for (index = 0u; index < hiff->chunk_count; ++index) {
        hiff->chunks[index].used = 0;
    }
    return select_chunk_index(hiff, id, 1);
}

int hiff_select_next(Hiff *hiff, const char *id)
{
    return select_chunk_index(hiff, id, 1);
}

static void fill_data_selection(const Hiff *hiff,
                                size_t index,
                                const uint8_t **bytes,
                                size_t *length,
                                HiffSelectionInfo *info)
{
    const HiffDataInfo *record = &hiff->data[index].info;

    if (bytes != NULL) {
        *bytes = hiff->bytes + record->body_offset;
    }
    if (length != NULL) {
        *length = (size_t)record->declared_size - 4u;
    }
    if (info != NULL) {
        memset(info, 0, sizeof(*info));
        info->kind = HIFF_SELECTION_DATA;
        info->index = index;
        info->data_index = index;
        info->record_offset = record->record_offset;
        info->header_offset = record->record_offset;
        info->payload_offset = record->body_offset;
        info->length = (size_t)record->declared_size - 4u;
        memcpy(info->name, record->type, sizeof(info->name));
    }
}

static void fill_chunk_selection(const Hiff *hiff,
                                 size_t index,
                                 const uint8_t **bytes,
                                 size_t *length,
                                 HiffSelectionInfo *info)
{
    const HiffChunkInfo *chunk = &hiff->chunks[index].info;
    const HiffDataInfo *record = &hiff->data[chunk->data_index].info;

    if (bytes != NULL) {
        *bytes = hiff->bytes + chunk->payload_offset;
    }
    if (length != NULL) {
        *length = (size_t)chunk->payload_size;
    }
    if (info != NULL) {
        memset(info, 0, sizeof(*info));
        info->kind = HIFF_SELECTION_CHUNK;
        info->index = index;
        info->data_index = chunk->data_index;
        info->record_offset = record->record_offset;
        info->header_offset = chunk->header_offset;
        info->payload_offset = chunk->payload_offset;
        info->length = (size_t)chunk->payload_size;
        memcpy(info->name, chunk->id, sizeof(info->name));
    }
}

int hiff_get_selected_data(const Hiff *hiff,
                           const uint8_t **bytes,
                           size_t *length,
                           HiffSelectionInfo *info)
{
    if (hiff == NULL) {
        return HIFF_ERR_ARGUMENT;
    }
    if (hiff->selected_data_index == SIZE_MAX) {
        return HIFF_ERR_NOT_FOUND;
    }
    fill_data_selection(hiff, hiff->selected_data_index, bytes, length, info);
    return HIFF_OK;
}

int hiff_get_selected_chunk(const Hiff *hiff,
                            const uint8_t **bytes,
                            size_t *length,
                            HiffSelectionInfo *info)
{
    if (hiff == NULL) {
        return HIFF_ERR_ARGUMENT;
    }
    if (hiff->selected_chunk_index == SIZE_MAX) {
        return HIFF_ERR_NOT_FOUND;
    }
    fill_chunk_selection(hiff, hiff->selected_chunk_index, bytes, length, info);
    return HIFF_OK;
}

int hiff_get_selected(const Hiff *hiff,
                      const uint8_t **bytes,
                      size_t *length,
                      HiffSelectionInfo *info)
{
    if (hiff == NULL) {
        return HIFF_ERR_ARGUMENT;
    }
    if (hiff->last_selection_kind == HIFF_SELECTION_DATA) {
        return hiff_get_selected_data(hiff, bytes, length, info);
    }
    if (hiff->last_selection_kind == HIFF_SELECTION_CHUNK) {
        return hiff_get_selected_chunk(hiff, bytes, length, info);
    }
    return HIFF_ERR_NOT_FOUND;
}

const char *hiff_status_string(int status)
{
    switch (status) {
    case HIFF_OK:
        return "ok";
    case HIFF_ERR_ARGUMENT:
        return "invalid argument";
    case HIFF_ERR_MEMORY:
        return "out of memory";
    case HIFF_ERR_FORMAT:
        return "invalid HIFF format";
    case HIFF_ERR_BOUNDS:
        return "HIFF data exceeds input bounds";
    case HIFF_ERR_LIMIT:
        return "HIFF record limit exceeded";
    case HIFF_ERR_NOT_FOUND:
        return "not found";
    default:
        return "unknown HIFF status";
    }
}
