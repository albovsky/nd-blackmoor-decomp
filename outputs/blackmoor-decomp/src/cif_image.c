#include "cif_image.h"

#include "cif_pixels.h"

#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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

int cif_image_decode_tree_entry(const cif_tree *tree,
                                size_t entry_index,
                                cif_decode_context *context,
                                cif_image *image,
                                char *error,
                                size_t error_capacity)
{
    cif_entry_info entry;
    uint16_t width;
    uint16_t pitch;
    uint16_t height;
    uint16_t depth;
    size_t expected_pitch;
    size_t expected_size;
    size_t written = 0u;
    size_t consumed = 0u;
    uint8_t *pixels;
    int status;

    clear_error(error, error_capacity);
    if (image != NULL) {
        memset(image, 0, sizeof(*image));
    }
    if (tree == NULL || context == NULL || image == NULL) {
        set_error(error, error_capacity,
                  "tree, persistent decode context, and image output are required");
        return CIF_IMAGE_ERR_ARGUMENT;
    }
    status = cif_tree_entry_at(tree, entry_index, &entry);
    if (status != CIF_OK) {
        set_error(error, error_capacity, "TREE entry %zu: %s",
                  entry_index, cif_status_string(status));
        return status == CIF_ERR_BOUNDS ? CIF_IMAGE_ERR_BOUNDS
                                        : CIF_IMAGE_ERR_NOT_FOUND;
    }
    if (entry.type != 2u) {
        set_error(error, error_capacity,
                  "TREE entry '%s' has type %u; only original type-2 images are supported",
                  entry.name, (unsigned int)entry.type);
        return CIF_IMAGE_ERR_TYPE;
    }

    /* FUN_004181c6 reads little-endian words at TREE record offsets 73, 75,
     * and 77. Depth is the single byte at offset 79. */
    width = read_le16(entry.metadata_41_80 + 32u);
    pitch = read_le16(entry.metadata_41_80 + 34u);
    height = read_le16(entry.metadata_41_80 + 36u);
    depth = entry.metadata_41_80[38u];

    expected_pitch = (size_t)width * 2u;
    if (width == 0u || height == 0u || pitch == 0u || depth != 16u ||
        expected_pitch > (size_t)UINT16_MAX || (size_t)pitch != expected_pitch) {
        set_error(error, error_capacity,
                  "TREE entry '%s' has unsupported image metadata (width=%u pitch=%u height=%u depth=%u)",
                  entry.name,
                  (unsigned int)width,
                  (unsigned int)pitch,
                  (unsigned int)height,
                  (unsigned int)depth);
        return CIF_IMAGE_ERR_METADATA;
    }
    if ((size_t)height > SIZE_MAX / (size_t)pitch) {
        set_error(error, error_capacity,
                  "TREE entry '%s' image dimensions overflow the host size range", entry.name);
        return CIF_IMAGE_ERR_BOUNDS;
    }
    expected_size = (size_t)height * (size_t)pitch;
    if (expected_size > CIF_MAX_RESOURCE_SIZE ||
        expected_size != (size_t)entry.output_size) {
        set_error(error, error_capacity,
                  "TREE entry '%s' output size %u does not match height*pitch (%zu)",
                  entry.name,
                  (unsigned int)entry.output_size,
                  expected_size);
        return CIF_IMAGE_ERR_METADATA;
    }

    pixels = (uint8_t *)malloc(expected_size);
    if (pixels == NULL) {
        set_error(error, error_capacity,
                  "unable to allocate %zu decoded image bytes for '%s'",
                  expected_size, entry.name);
        return CIF_IMAGE_ERR_MEMORY;
    }
    status = cif_tree_extract(tree,
                              entry_index,
                              context,
                              pixels,
                              expected_size,
                              &written,
                              &consumed);
    if (status != CIF_OK || written != expected_size) {
        set_error(error, error_capacity,
                  "decoding TREE image '%s' failed: %s (written=%zu expected=%zu consumed=%zu)",
                  entry.name,
                  cif_status_string(status),
                  written,
                  expected_size,
                  consumed);
        free(pixels);
        return status == CIF_ERR_BOUNDS ? CIF_IMAGE_ERR_BOUNDS : CIF_IMAGE_ERR_DECODE;
    }

    memcpy(image->name, entry.name, sizeof(image->name));
    image->id = entry.id;
    image->width = width;
    image->pitch = pitch;
    image->height = height;
    image->depth = depth;
    image->pixels = pixels;
    image->byte_count = expected_size;
    return CIF_IMAGE_OK;
}

int cif_image_decode_cif_memory(const void *file_bytes,
                                size_t file_size,
                                cif_decode_context *context,
                                cif_image *image,
                                char *error,
                                size_t error_capacity)
{
    const uint8_t *bytes = (const uint8_t *)file_bytes;
    uint16_t width;
    uint16_t pitch;
    uint16_t height;
    uint16_t depth;
    size_t required_output = 0u;
    size_t written = 0u;
    size_t consumed = 0u;
    size_t expected_pitch;
    size_t expected_size;
    uint8_t *pixels;
    int status;

    clear_error(error, error_capacity);
    if (image != NULL) {
        memset(image, 0, sizeof(*image));
    }
    if (bytes == NULL || context == NULL || image == NULL) {
        set_error(error, error_capacity,
                  "standalone CIF bytes, persistent decode context, and image output are required");
        return CIF_IMAGE_ERR_ARGUMENT;
    }
    if (file_size < 81u) {
        set_error(error, error_capacity, "standalone CIF is shorter than its 81-byte header");
        return CIF_IMAGE_ERR_BOUNDS;
    }
    if (bytes[80u] != 2u) {
        set_error(error, error_capacity,
                  "standalone CIF has type %u; only type-2 images are supported",
                  (unsigned int)bytes[80u]);
        return CIF_IMAGE_ERR_TYPE;
    }

    /* This capacity probe validates the original CIF magic/version and the
     * declared encoded extents without changing the persistent ring context. */
    status = cif_decode_cif_memory(context,
                                   bytes,
                                   file_size,
                                   NULL,
                                   0u,
                                   &required_output,
                                   &written,
                                   &consumed);
    if (status != CIF_ERR_OUTPUT_SIZE || required_output == 0u) {
        set_error(error, error_capacity,
                  "standalone CIF header is invalid or has no output: %s",
                  cif_status_string(status));
        return status == CIF_ERR_BOUNDS ? CIF_IMAGE_ERR_BOUNDS : CIF_IMAGE_ERR_DECODE;
    }

    /* Standalone CIF FILE metadata occupies bytes 28..59. Width, pitch, and
     * height are little-endian words at 60, 62, and 64; depth is the byte at
     * 66 (byte 67 is separate). Output size is the word at offset 68. */
    width = read_le16(bytes + 60u);
    pitch = read_le16(bytes + 62u);
    height = read_le16(bytes + 64u);
    depth = bytes[66u];
    expected_pitch = (size_t)width * 2u;
    if (width == 0u || height == 0u || pitch == 0u || depth != 16u ||
        expected_pitch > (size_t)UINT16_MAX || (size_t)pitch != expected_pitch) {
        set_error(error, error_capacity,
                  "standalone CIF has unsupported image metadata (width=%u pitch=%u height=%u depth=%u)",
                  (unsigned int)width,
                  (unsigned int)pitch,
                  (unsigned int)height,
                  (unsigned int)depth);
        return CIF_IMAGE_ERR_METADATA;
    }
    if ((size_t)height > SIZE_MAX / (size_t)pitch) {
        set_error(error, error_capacity,
                  "standalone CIF image dimensions overflow the host size range");
        return CIF_IMAGE_ERR_BOUNDS;
    }
    expected_size = (size_t)height * (size_t)pitch;
    if (expected_size > CIF_MAX_RESOURCE_SIZE ||
        expected_size != required_output ||
        expected_size != (size_t)((uint32_t)bytes[68u] |
                                  ((uint32_t)bytes[69u] << 8) |
                                  ((uint32_t)bytes[70u] << 16) |
                                  ((uint32_t)bytes[71u] << 24))) {
        set_error(error, error_capacity,
                  "standalone CIF output size %zu does not match height*pitch (%zu)",
                  required_output, expected_size);
        return CIF_IMAGE_ERR_METADATA;
    }

    pixels = (uint8_t *)malloc(expected_size);
    if (pixels == NULL) {
        set_error(error, error_capacity,
                  "unable to allocate %zu standalone CIF image bytes", expected_size);
        return CIF_IMAGE_ERR_MEMORY;
    }
    status = cif_decode_cif_memory(context,
                                   bytes,
                                   file_size,
                                   pixels,
                                   expected_size,
                                   NULL,
                                   &written,
                                   &consumed);
    if (status != CIF_OK || written != expected_size) {
        set_error(error, error_capacity,
                  "standalone CIF image decode failed: %s (written=%zu expected=%zu consumed=%zu)",
                  cif_status_string(status),
                  written,
                  expected_size,
                  consumed);
        free(pixels);
        return status == CIF_ERR_BOUNDS ? CIF_IMAGE_ERR_BOUNDS : CIF_IMAGE_ERR_DECODE;
    }
    image->width = width;
    image->pitch = pitch;
    image->height = height;
    image->depth = depth;
    image->pixels = pixels;
    image->byte_count = expected_size;
    return CIF_IMAGE_OK;
}

void cif_image_destroy(cif_image *image)
{
    if (image != NULL) {
        free(image->pixels);
        memset(image, 0, sizeof(*image));
    }
}

int cif_image_to_rgba(const cif_image *image,
                      uint8_t *rgba,
                      size_t rgba_capacity)
{
    size_t required_capacity;

    if (image == NULL || image->pixels == NULL || rgba == NULL ||
        image->byte_count > SIZE_MAX / 2u) {
        return 0;
    }
    required_capacity = image->byte_count * 2u;
    if (rgba_capacity < required_capacity) {
        return 0;
    }
    return cif_pixels_rgb555_to_rgba(image->pixels,
                                     image->byte_count,
                                     rgba,
                                     rgba_capacity);
}

const char *cif_image_status_string(int status)
{
    switch (status) {
    case CIF_IMAGE_OK:
        return "success";
    case CIF_IMAGE_ERR_ARGUMENT:
        return "invalid image decoder argument";
    case CIF_IMAGE_ERR_MEMORY:
        return "out of memory";
    case CIF_IMAGE_ERR_NOT_FOUND:
        return "TREE entry not found";
    case CIF_IMAGE_ERR_TYPE:
        return "TREE entry is not a type-2 image";
    case CIF_IMAGE_ERR_METADATA:
        return "unsupported or inconsistent TREE image metadata";
    case CIF_IMAGE_ERR_DECODE:
        return "image decode failed";
    case CIF_IMAGE_ERR_BOUNDS:
        return "image dimensions or output extent are out of bounds";
    default:
        return "unknown CifImage error";
    }
}
