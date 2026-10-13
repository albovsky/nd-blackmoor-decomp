#ifndef CIF_IMAGE_H
#define CIF_IMAGE_H

#include "cif_archive.h"

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum cif_image_status {
    CIF_IMAGE_OK = 0,
    CIF_IMAGE_ERR_ARGUMENT = 1,
    CIF_IMAGE_ERR_MEMORY = 2,
    CIF_IMAGE_ERR_NOT_FOUND = 3,
    CIF_IMAGE_ERR_TYPE = 4,
    CIF_IMAGE_ERR_METADATA = 5,
    CIF_IMAGE_ERR_DECODE = 6,
    CIF_IMAGE_ERR_BOUNDS = 7
} cif_image_status;

/*
 * Pixels retain the decoder's raw little-endian RGB555 words. Width, pitch,
 * height, depth, and byte_count come from the original CIF TREE metadata,
 * not from nominal dimensions in BOOT/MENU descriptors.
 *
 * Initialize an output with CIF_IMAGE_INIT before decoding. Destroy it before
 * reusing it; a failed decode leaves it zeroed. The caller owns pixels after
 * success and releases them with cif_image_destroy().
 */
#define CIF_IMAGE_INIT { { 0 }, 0u, 0u, 0u, 0u, 0u, NULL, 0u }

typedef struct cif_image {
    char name[33];
    uint16_t id;
    uint16_t width;
    uint16_t pitch;
    uint16_t height;
    uint16_t depth;
    uint8_t *pixels;
    size_t byte_count;
} cif_image;

/* The caller supplies and owns one persistent decode context for the engine. */
int cif_image_decode_tree_entry(const cif_tree *tree,
                                size_t entry_index,
                                cif_decode_context *context,
                                cif_image *image,
                                char *error,
                                size_t error_capacity);
/* Decode an explicitly supplied standalone CIF FILE type-2 image. Its name is
 * external to the CIF header and is therefore left empty for the caller. */
int cif_image_decode_cif_memory(const void *file_bytes,
                                size_t file_size,
                                cif_decode_context *context,
                                cif_image *image,
                                char *error,
                                size_t error_capacity);
void cif_image_destroy(cif_image *image);

/* Host-side adapter only; source bytes and image metadata stay unchanged. */
int cif_image_to_rgba(const cif_image *image,
                      uint8_t *rgba,
                      size_t rgba_capacity);

const char *cif_image_status_string(int status);

#ifdef __cplusplus
}
#endif

#endif
