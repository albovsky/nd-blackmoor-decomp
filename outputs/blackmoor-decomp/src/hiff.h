#ifndef HIFF_H
#define HIFF_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define HIFF_MAX_DATA_RECORDS 999u
#define HIFF_MAX_CHUNKS 999u

typedef enum hiff_status {
    HIFF_OK = 0,
    HIFF_ERR_ARGUMENT = 1,
    HIFF_ERR_MEMORY = 2,
    HIFF_ERR_FORMAT = 3,
    HIFF_ERR_BOUNDS = 4,
    HIFF_ERR_LIMIT = 5,
    HIFF_ERR_NOT_FOUND = 6
} hiff_status;

typedef enum hiff_selection_kind {
    HIFF_SELECTION_NONE = 0,
    HIFF_SELECTION_DATA = 1,
    HIFF_SELECTION_CHUNK = 2
} hiff_selection_kind;

typedef struct Hiff Hiff;

typedef struct hiff_data_info {
    size_t record_offset;
    size_t type_offset;
    size_t body_offset;
    size_t extent_size;
    uint32_t declared_size;
    char type[5];
} HiffDataInfo;

typedef struct hiff_chunk_info {
    size_t data_index;
    size_t header_offset;
    size_t payload_offset;
    size_t padded_extent_size;
    uint32_t payload_size;
    char id[5];
} HiffChunkInfo;

typedef struct hiff_selection_info {
    hiff_selection_kind kind;
    size_t index;
    size_t data_index;
    size_t record_offset;
    size_t header_offset;
    size_t payload_offset;
    size_t length;
    char name[5];
} HiffSelectionInfo;

/* The returned parser owns a copy of bytes until hiff_close. */
Hiff *hiff_open_memory(const void *bytes,
                       size_t length,
                       char *error,
                       size_t error_capacity);
void hiff_close(Hiff *hiff);

size_t hiff_data_count(const Hiff *hiff);
size_t hiff_chunk_count(const Hiff *hiff);
int hiff_data_at(const Hiff *hiff, size_t index, HiffDataInfo *info);
int hiff_chunk_at(const Hiff *hiff, size_t index, HiffChunkInfo *info);

/* Inputs are case-sensitive NUL-terminated names, compared like the original
 * four-byte field copier followed by strcmp (fields may terminate early).
 * A failed selection leaves the previous selected resource unchanged.
 */
int hiff_select_data(Hiff *hiff, const char *type);
int hiff_select_chunk(Hiff *hiff, const char *id);
int hiff_select_first(Hiff *hiff, const char *id);
int hiff_select_next(Hiff *hiff, const char *id);
int hiff_get_selected_data(const Hiff *hiff,
                           const uint8_t **bytes,
                           size_t *length,
                           HiffSelectionInfo *info);
int hiff_get_selected_chunk(const Hiff *hiff,
                            const uint8_t **bytes,
                            size_t *length,
                            HiffSelectionInfo *info);
/* Convenience getter for the most recently successful selection. */
int hiff_get_selected(const Hiff *hiff,
                      const uint8_t **bytes,
                      size_t *length,
                      HiffSelectionInfo *info);

const char *hiff_status_string(int status);

#ifdef __cplusplus
}
#endif

#endif
