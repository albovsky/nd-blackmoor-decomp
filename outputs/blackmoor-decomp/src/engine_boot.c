#include "engine_boot.h"

#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ENGINE_BOOT_UICL_COUNT_OFFSET 0xD9Fu
#define ENGINE_BOOT_UICL_ROWS_OFFSET 0xDA1u

struct EngineBoot {
    uint8_t *bytes;
    size_t length;
    Hiff *hiff;
    size_t boot_data_index;
    EngineBootSummary summary;
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

static uint16_t read_le16(const uint8_t *bytes)
{
    return (uint16_t)((uint16_t)bytes[0] | ((uint16_t)bytes[1] << 8));
}

static int16_t read_les16(const uint8_t *bytes)
{
    uint16_t value = read_le16(bytes);
    int32_t signed_value = value <= (uint16_t)INT16_MAX
                               ? (int32_t)value
                               : (int32_t)value - 65536;
    return (int16_t)signed_value;
}

static int chunk_bytes(const EngineBoot *boot,
                       size_t index,
                       HiffChunkInfo *info,
                       const uint8_t **payload,
                       size_t *payload_size)
{
    HiffChunkInfo local_info;

    if (boot == NULL) {
        return ENGINE_BOOT_ERR_ARGUMENT;
    }
    if (hiff_chunk_at(boot->hiff, index, &local_info) != HIFF_OK) {
        return ENGINE_BOOT_ERR_NOT_FOUND;
    }
    if (local_info.payload_offset > boot->length ||
        (size_t)local_info.payload_size > boot->length - local_info.payload_offset) {
        return ENGINE_BOOT_ERR_BOUNDS;
    }
    if (info != NULL) {
        *info = local_info;
    }
    if (payload != NULL) {
        *payload = boot->bytes + local_info.payload_offset;
    }
    if (payload_size != NULL) {
        *payload_size = (size_t)local_info.payload_size;
    }
    return ENGINE_BOOT_OK;
}

static int find_chunk(const EngineBoot *boot,
                      const char *id,
                      size_t *chunk_index,
                      HiffChunkInfo *info,
                      const uint8_t **payload,
                      size_t *payload_size)
{
    size_t index;
    size_t count;

    if (boot == NULL || id == NULL) {
        return ENGINE_BOOT_ERR_ARGUMENT;
    }
    count = hiff_chunk_count(boot->hiff);
    for (index = 0u; index < count; ++index) {
        HiffChunkInfo candidate;

        if (hiff_chunk_at(boot->hiff, index, &candidate) == HIFF_OK &&
            strcmp(candidate.id, id) == 0) {
            break;
        }
    }
    if (index == count) {
        return ENGINE_BOOT_ERR_NOT_FOUND;
    }
    if (chunk_index != NULL) {
        *chunk_index = index;
    }
    return chunk_bytes(boot, index, info, payload, payload_size);
}

static int find_chunk_in_data(const EngineBoot *boot,
                              size_t data_index,
                              const char *id,
                              HiffChunkInfo *info,
                              const uint8_t **payload,
                              size_t *payload_size)
{
    size_t index;
    size_t count;

    if (boot == NULL || id == NULL) {
        return ENGINE_BOOT_ERR_ARGUMENT;
    }
    count = hiff_chunk_count(boot->hiff);
    for (index = 0u; index < count; ++index) {
        HiffChunkInfo candidate;

        if (hiff_chunk_at(boot->hiff, index, &candidate) == HIFF_OK &&
            candidate.data_index == data_index &&
            strcmp(candidate.id, id) == 0) {
            return chunk_bytes(boot, index, info, payload, payload_size);
        }
    }
    return ENGINE_BOOT_ERR_NOT_FOUND;
}

static int get_phone_table(const EngineBoot *boot,
                           const uint8_t **rows,
                           size_t *count)
{
    const uint8_t *payload;
    size_t payload_size;
    size_t row_count;
    size_t required_size;
    int16_t signed_count;
    int status;

    if (boot == NULL || rows == NULL || count == NULL) {
        return ENGINE_BOOT_ERR_ARGUMENT;
    }
    status = find_chunk_in_data(boot, boot->boot_data_index, "UICL", NULL,
                                &payload, &payload_size);
    if (status != ENGINE_BOOT_OK) {
        return status;
    }
    if (payload_size < ENGINE_BOOT_UICL_ROWS_OFFSET) {
        return ENGINE_BOOT_ERR_BOUNDS;
    }

    signed_count = read_les16(payload + ENGINE_BOOT_UICL_COUNT_OFFSET);
    if (signed_count < 0) {
        return ENGINE_BOOT_ERR_FORMAT;
    }
    row_count = (size_t)signed_count;
    if (row_count >
        (SIZE_MAX - ENGINE_BOOT_UICL_ROWS_OFFSET) / ENGINE_BOOT_PHONE_ROW_SIZE) {
        return ENGINE_BOOT_ERR_BOUNDS;
    }
    required_size = ENGINE_BOOT_UICL_ROWS_OFFSET +
                    row_count * ENGINE_BOOT_PHONE_ROW_SIZE;
    if (required_size > payload_size) {
        return ENGINE_BOOT_ERR_BOUNDS;
    }

    *rows = payload + ENGINE_BOOT_UICL_ROWS_OFFSET;
    *count = row_count;
    return ENGINE_BOOT_OK;
}

static int read_descriptor_chunk(const EngineBoot *boot,
                                 const char *id,
                                 EngineBootImageDescriptor *descriptor)
{
    HiffChunkInfo chunk;
    const uint8_t *payload;
    size_t payload_size;
    size_t chunk_index;
    int status;

    status = find_chunk(boot, id, &chunk_index, &chunk, &payload, &payload_size);
    if (status != ENGINE_BOOT_OK) {
        return status;
    }
    if (payload_size < ENGINE_BOOT_IMAGE_DESCRIPTOR_SIZE) {
        return ENGINE_BOOT_ERR_BOUNDS;
    }
    memset(descriptor, 0, sizeof(*descriptor));
    memcpy(descriptor->raw, payload, sizeof(descriptor->raw));
    memcpy(descriptor->filename, payload, 33u);
    descriptor->filename[33] = '\0';
    descriptor->nominal_width = read_le16(payload + 33u);
    descriptor->nominal_height = read_le16(payload + 35u);
    descriptor->source_chunk_index = chunk_index;
    descriptor->payload_offset = chunk.payload_offset;
    return ENGINE_BOOT_OK;
}

EngineBoot *engine_boot_open_memory(const void *decoded_boot,
                                   size_t length,
                                   char *error,
                                   size_t error_capacity)
{
    EngineBoot *boot;
    HiffSelectionInfo data_selection;
    HiffChunkInfo bsum_chunk;
    const uint8_t *bsum;
    size_t bsum_size;
    int status;

    clear_error(error, error_capacity);
    if ((decoded_boot == NULL && length != 0u) || length == 0u) {
        set_error(error, error_capacity, "decoded BOOT input must be non-empty");
        return NULL;
    }
    boot = (EngineBoot *)calloc(1u, sizeof(*boot));
    if (boot == NULL) {
        set_error(error, error_capacity, "unable to allocate EngineBoot state");
        return NULL;
    }
    boot->bytes = (uint8_t *)malloc(length);
    if (boot->bytes == NULL) {
        set_error(error, error_capacity, "unable to copy %zu decoded BOOT bytes", length);
        free(boot);
        return NULL;
    }
    memcpy(boot->bytes, decoded_boot, length);
    boot->length = length;
    boot->hiff = hiff_open_memory(boot->bytes, length, error, error_capacity);
    if (boot->hiff == NULL) {
        free(boot->bytes);
        free(boot);
        return NULL;
    }
    if (hiff_select_data(boot->hiff, "BOOT") != HIFF_OK ||
        hiff_get_selected_data(boot->hiff, NULL, NULL, &data_selection) != HIFF_OK) {
        set_error(error, error_capacity, "decoded input has no BOOT DATA record");
        engine_boot_close(boot);
        return NULL;
    }
    boot->boot_data_index = data_selection.data_index;

    status = find_chunk(boot, "BSUM", NULL, &bsum_chunk, &bsum, &bsum_size);
    if (status != ENGINE_BOOT_OK) {
        set_error(error, error_capacity, "BOOT has no BSUM chunk");
        engine_boot_close(boot);
        return NULL;
    }
    if (bsum_chunk.data_index != boot->boot_data_index ||
        bsum_size < ENGINE_BOOT_BSUM_SIZE) {
        set_error(error, error_capacity,
                  "BOOT BSUM must contain at least %u bytes in the selected BOOT DATA record",
                  ENGINE_BOOT_BSUM_SIZE);
        engine_boot_close(boot);
        return NULL;
    }

    /* FUN_00435015 copies these 402 bytes into the startup globals; the two
     * counts and signed words below are the fields it reads from that copy. */
    memcpy(boot->summary.bsum_raw, bsum, sizeof(boot->summary.bsum_raw));
    boot->summary.logo_count = bsum[242u];
    boot->summary.object_count = bsum[243u];
    boot->summary.font_count = read_les16(bsum + 337u);
    boot->summary.initial_scene = read_les16(bsum + 221u);
    if (find_chunk(boot, "BSUM", &boot->summary.bsum_chunk_index,
                   NULL, NULL, NULL) != ENGINE_BOOT_OK) {
        set_error(error, error_capacity, "unable to index BOOT BSUM chunk");
        engine_boot_close(boot);
        return NULL;
    }
    boot->summary.bsum_payload_offset = bsum_chunk.payload_offset;
    return boot;
}

void engine_boot_close(EngineBoot *boot)
{
    if (boot != NULL) {
        hiff_close(boot->hiff);
        free(boot->bytes);
        free(boot);
    }
}

int engine_boot_get_summary(const EngineBoot *boot, EngineBootSummary *summary)
{
    if (boot == NULL || summary == NULL) {
        return ENGINE_BOOT_ERR_ARGUMENT;
    }
    *summary = boot->summary;
    return ENGINE_BOOT_OK;
}

int engine_boot_get_startup_settings(const EngineBoot *boot,
                                    EngineBootStartupSettings *settings)
{
    const uint8_t *bsum;

    if (boot == NULL || settings == NULL) {
        return ENGINE_BOOT_ERR_ARGUMENT;
    }
    bsum = boot->summary.bsum_raw;
    settings->ordinary_initial_scene = read_les16(bsum + 221u);
    settings->ordinary_coordinate_word_a = read_les16(bsum + 223u);
    settings->ordinary_coordinate_word_b = read_les16(bsum + 225u);
    settings->initial_hour = read_les16(bsum + 227u);
    settings->initial_minute = read_les16(bsum + 229u);
    settings->first_day_event_hour = read_les16(bsum + 231u);
    settings->first_day_event_flag_id = read_les16(bsum + 233u);
    settings->alternate_initial_scene = read_les16(bsum + 235u);
    settings->alternate_coordinate_word_a = read_les16(bsum + 237u);
    settings->alternate_coordinate_word_b = read_les16(bsum + 239u);
    settings->clock_update_interval_ms = read_les16(bsum + 365u);
    return ENGINE_BOOT_OK;
}

int engine_boot_get_phone_count(const EngineBoot *boot, size_t *count)
{
    const uint8_t *rows;
    size_t row_count;
    int status;

    if (boot == NULL || count == NULL) {
        return ENGINE_BOOT_ERR_ARGUMENT;
    }
    status = get_phone_table(boot, &rows, &row_count);
    if (status != ENGINE_BOOT_OK) {
        return status;
    }
    (void)rows;
    *count = row_count;
    return ENGINE_BOOT_OK;
}

int engine_boot_phone_row_at(const EngineBoot *boot,
                             size_t index,
                             uint8_t raw_row[ENGINE_BOOT_PHONE_ROW_SIZE])
{
    const uint8_t *rows;
    size_t row_count;
    int status;

    if (boot == NULL || raw_row == NULL) {
        return ENGINE_BOOT_ERR_ARGUMENT;
    }
    status = get_phone_table(boot, &rows, &row_count);
    if (status != ENGINE_BOOT_OK) {
        return status;
    }
    if (index >= row_count) {
        return ENGINE_BOOT_ERR_NOT_FOUND;
    }
    memcpy(raw_row, rows + index * ENGINE_BOOT_PHONE_ROW_SIZE,
           ENGINE_BOOT_PHONE_ROW_SIZE);
    return ENGINE_BOOT_OK;
}

size_t engine_boot_chunk_count(const EngineBoot *boot)
{
    return boot == NULL ? 0u : hiff_chunk_count(boot->hiff);
}

int engine_boot_chunk_at(const EngineBoot *boot,
                         size_t index,
                         HiffChunkInfo *info,
                         const uint8_t **payload,
                         size_t *payload_size)
{
    if (boot == NULL) {
        return ENGINE_BOOT_ERR_ARGUMENT;
    }
    return chunk_bytes(boot, index, info, payload, payload_size);
}

size_t engine_boot_logo_count(const EngineBoot *boot)
{
    return boot == NULL ? 0u : (size_t)boot->summary.logo_count;
}

size_t engine_boot_object_count(const EngineBoot *boot)
{
    return boot == NULL ? 0u : (size_t)boot->summary.object_count;
}

static int descriptor_at(const EngineBoot *boot,
                         const char *prefix,
                         size_t index,
                         EngineBootImageDescriptor *descriptor)
{
    char id[32];

    if (boot == NULL || descriptor == NULL) {
        return ENGINE_BOOT_ERR_ARGUMENT;
    }
    if (index >= (prefix[0] == 'L' ? engine_boot_logo_count(boot)
                                  : engine_boot_object_count(boot))) {
        return ENGINE_BOOT_ERR_NOT_FOUND;
    }
    (void)snprintf(id, sizeof(id), "%s%zu", prefix, index);
    return read_descriptor_chunk(boot, id, descriptor);
}

int engine_boot_logo_at(const EngineBoot *boot,
                        size_t index,
                        EngineBootImageDescriptor *descriptor)
{
    return descriptor_at(boot, "LG", index, descriptor);
}

int engine_boot_object_at(const EngineBoot *boot,
                          size_t index,
                          EngineBootImageDescriptor *descriptor)
{
    return descriptor_at(boot, "OB", index, descriptor);
}

int engine_boot_get_menu(const EngineBoot *boot, EngineBootMenuInfo *info)
{
    const uint8_t *payload;
    size_t payload_size;
    size_t chunk_index;
    int status;

    if (boot == NULL || info == NULL) {
        return ENGINE_BOOT_ERR_ARGUMENT;
    }
    status = find_chunk(boot, "MENU", &chunk_index,
                        &info->chunk, &payload, &payload_size);
    if (status != ENGINE_BOOT_OK) {
        return status;
    }
    if (info->chunk.data_index != boot->boot_data_index) {
        return ENGINE_BOOT_ERR_NOT_FOUND;
    }
    if (payload_size < ENGINE_BOOT_IMAGE_DESCRIPTOR_SIZE) {
        return ENGINE_BOOT_ERR_BOUNDS;
    }
    info->raw = payload;
    info->raw_size = payload_size;
    info->chunk_index = chunk_index;
    memcpy(info->first_image_filename, payload, 33u);
    info->first_image_filename[33] = '\0';
    info->first_image_nominal_width = read_le16(payload + 33u);
    info->first_image_nominal_height = read_le16(payload + 35u);
    return ENGINE_BOOT_OK;
}

int engine_boot_get_plgo(const EngineBoot *boot, EngineBootPlgoInfo *info)
{
    const uint8_t *payload;
    size_t payload_size;
    size_t chunk_index;
    int status;

    if (boot == NULL || info == NULL) {
        return ENGINE_BOOT_ERR_ARGUMENT;
    }
    status = find_chunk(boot, "PLGO", &chunk_index,
                        &info->chunk, &payload, &payload_size);
    if (status != ENGINE_BOOT_OK) {
        return status;
    }
    if (info->chunk.data_index != boot->boot_data_index) {
        return ENGINE_BOOT_ERR_NOT_FOUND;
    }
    if (payload_size < ENGINE_BOOT_PLGO_SOUND_NAME_OFFSET + 9u) {
        return ENGINE_BOOT_ERR_BOUNDS;
    }
    info->raw = payload;
    info->raw_size = payload_size;
    info->chunk_index = chunk_index;
    memcpy(info->filename, payload, 33u);
    info->filename[33] = '\0';
    info->byte_at_66 = payload[66u];
    memcpy(info->sound_name_at_111,
           payload + ENGINE_BOOT_PLGO_SOUND_NAME_OFFSET,
           sizeof(info->sound_name_at_111) - 1u);
    info->sound_name_at_111[9] = '\0';
    return ENGINE_BOOT_OK;
}

const char *engine_boot_status_string(int status)
{
    switch (status) {
    case ENGINE_BOOT_OK:
        return "success";
    case ENGINE_BOOT_ERR_ARGUMENT:
        return "invalid argument";
    case ENGINE_BOOT_ERR_MEMORY:
        return "out of memory";
    case ENGINE_BOOT_ERR_FORMAT:
        return "invalid BOOT record";
    case ENGINE_BOOT_ERR_BOUNDS:
        return "BOOT field is out of bounds";
    case ENGINE_BOOT_ERR_NOT_FOUND:
        return "requested BOOT record is not present";
    case ENGINE_BOOT_ERR_LIMIT:
        return "original BOOT record limit exceeded";
    default:
        return "unknown EngineBoot error";
    }
}
