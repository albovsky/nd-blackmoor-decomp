#ifndef CIF_ARCHIVE_H
#define CIF_ARCHIVE_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define CIF_RING_SIZE 4096u
#define CIF_RING_INITIALIZED 4078u
#define CIF_MAX_ARCHIVE_SIZE ((size_t)1u << 30)
#define CIF_MAX_RESOURCE_SIZE ((size_t)1u << 30)

typedef enum cif_status {
    CIF_OK = 0,
    CIF_ERR_ARGUMENT = 1,
    CIF_ERR_IO = 2,
    CIF_ERR_MEMORY = 3,
    CIF_ERR_FORMAT = 4,
    CIF_ERR_UNSUPPORTED = 5,
    CIF_ERR_NOT_FOUND = 6,
    CIF_ERR_BOUNDS = 7,
    CIF_ERR_MALFORMED = 8,
    CIF_ERR_OUTPUT_SIZE = 9,
    CIF_ERR_EXISTS = 10
} cif_status;

typedef struct cif_decode_context {
    uint8_t ring[CIF_RING_SIZE];
} cif_decode_context;

typedef struct cif_entry_info {
    char name[33];
    uint16_t id;
    uint32_t data_offset;
    uint16_t next_index;
    uint8_t metadata_41_80[40];
    uint32_t output_size;
    uint8_t metadata_85_88[4];
    uint32_t compressed_size;
    uint8_t type;
} cif_entry_info;

typedef struct cif_tree cif_tree;

void cif_decode_context_init(cif_decode_context *context);

/*
 * Decode one counter-obfuscated LZSS stream.  The context retains the final 18
 * ring bytes between calls; the original decoder spaces the first 4078 bytes
 * at the beginning of each call.  Success requires exactly output_capacity
 * bytes and consumes the full compressed input (an empty final flag group is
 * accepted).
 */
int cif_decode(cif_decode_context *context,
               const uint8_t *compressed,
               size_t compressed_size,
               uint8_t *output,
               size_t output_capacity,
               size_t *written,
               size_t *consumed);

/* These functions copy the supplied archive and own that copy until close. */
cif_tree *cif_tree_open_memory(const void *archive,
                               size_t archive_size,
                               char *error,
                               size_t error_capacity);
cif_tree *cif_tree_open_file(const char *path,
                             char *error,
                             size_t error_capacity);
void cif_tree_close(cif_tree *tree);
size_t cif_tree_entry_count(const cif_tree *tree);
int cif_tree_entry_at(const cif_tree *tree,
                      size_t index,
                      cif_entry_info *entry);
int cif_tree_find(const cif_tree *tree, const char *name, size_t *index);

/* Type 4 entries are metadata markers and cannot be extracted. */
int cif_tree_extract(const cif_tree *tree,
                     size_t index,
                     cif_decode_context *context,
                     uint8_t *output,
                     size_t output_capacity,
                     size_t *written,
                     size_t *consumed);

/* Parse and decode a standalone 81-byte CIF FILE header plus payload. */
int cif_decode_cif_memory(cif_decode_context *context,
                          const void *file_bytes,
                          size_t file_size,
                          uint8_t *output,
                          size_t output_capacity,
                          size_t *required_output,
                          size_t *written,
                          size_t *consumed);

const char *cif_status_string(int status);

#ifdef __cplusplus
}
#endif

#endif
