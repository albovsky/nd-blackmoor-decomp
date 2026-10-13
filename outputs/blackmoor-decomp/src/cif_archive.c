#include "cif_archive.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define CIF_TREE_HEADER_SIZE 32u
#define CIF_HASH_TABLE_SIZE 2048u
#define CIF_BUCKET_COUNT 1024u
#define CIF_ENTRY_SIZE 94u
#define CIF_TREE_PREFIX_SIZE (CIF_TREE_HEADER_SIZE + CIF_HASH_TABLE_SIZE)
#define CIF_CIF_HEADER_SIZE 81u

struct cif_tree {
    uint8_t *archive;
    size_t archive_size;
    uint16_t buckets[CIF_BUCKET_COUNT];
    cif_entry_info *entries;
    size_t entry_count;
};

static const uint8_t cif_tree_magic[20] = "CIF TREE WayneSikes";
static const uint8_t cif_file_magic[20] = "CIF FILE WayneSikes";

static uint16_t read_u16le(const uint8_t *bytes)
{
    return (uint16_t)((uint16_t)bytes[0] | ((uint16_t)bytes[1] << 8));
}

static uint32_t read_u32le(const uint8_t *bytes)
{
    return (uint32_t)bytes[0] |
           ((uint32_t)bytes[1] << 8) |
           ((uint32_t)bytes[2] << 16) |
           ((uint32_t)bytes[3] << 24);
}

static void set_error(char *error, size_t capacity, const char *message)
{
    size_t length;

    if (error == NULL || capacity == 0) {
        return;
    }
    length = strlen(message);
    if (length >= capacity) {
        length = capacity - 1;
    }
    memcpy(error, message, length);
    error[length] = '\0';
}

static void clear_error(char *error, size_t capacity)
{
    if (error != NULL && capacity != 0) {
        error[0] = '\0';
    }
}

static unsigned char ascii_upper(unsigned char value)
{
    if (value >= (unsigned char)'a' && value <= (unsigned char)'z') {
        return (unsigned char)(value - (unsigned char)'a' + (unsigned char)'A');
    }
    return value;
}

static int name_hash(const char *name)
{
    int16_t sum = 0;
    size_t index;

    for (index = 0; name[index] != '\0'; ++index) {
        /* Names are validated as 7-bit ASCII before this signed-char sum. */
        sum = (int16_t)(sum + (int16_t)(int8_t)name[index]);
    }
    return (int)(sum % (int16_t)CIF_BUCKET_COUNT);
}

void cif_decode_context_init(cif_decode_context *context)
{
    if (context != NULL) {
        memset(context->ring, 0, sizeof(context->ring));
    }
}

int cif_decode(cif_decode_context *context,
               const uint8_t *compressed,
               size_t compressed_size,
               uint8_t *output,
               size_t output_capacity,
               size_t *written,
               size_t *consumed)
{
    size_t input_position = 0;
    size_t output_position = 0;
    uint16_t flags = 0;
    uint16_t ring_position = 0x0fee;
    uint8_t counter = 0;

    if (written != NULL) {
        *written = 0;
    }
    if (consumed != NULL) {
        *consumed = 0;
    }
    if (context == NULL || (compressed_size != 0 && compressed == NULL) ||
        (output_capacity != 0 && output == NULL)) {
        return CIF_ERR_ARGUMENT;
    }
    if (compressed_size > CIF_MAX_ARCHIVE_SIZE ||
        output_capacity > CIF_MAX_RESOURCE_SIZE) {
        return CIF_ERR_BOUNDS;
    }

    /* The original routine clears 0xfee bytes; its last 18 bytes persist. */
    memset(context->ring, 0x20, CIF_RING_INITIALIZED);

    while (input_position < compressed_size) {
        uint8_t value;

        flags = (uint16_t)(flags >> 1);
        if ((flags & 0x0100u) == 0) {
            value = (uint8_t)(compressed[input_position] - counter);
            ++input_position;
            counter = (uint8_t)(counter + 1u);
            flags = (uint16_t)(0xff00u | value);
        }

        if ((flags & 1u) != 0) {
            if (input_position == compressed_size) {
                /* A final flag byte with no token is harmless in the original. */
                break;
            }
            if (output_position == output_capacity) {
                if (written != NULL) {
                    *written = output_position;
                }
                if (consumed != NULL) {
                    *consumed = input_position;
                }
                return CIF_ERR_OUTPUT_SIZE;
            }
            value = (uint8_t)(compressed[input_position] - counter);
            ++input_position;
            counter = (uint8_t)(counter + 1u);
            output[output_position++] = value;
            context->ring[ring_position] = value;
            ring_position = (uint16_t)((ring_position + 1u) & 0x0fffu);
        } else {
            uint8_t low;
            uint8_t high;
            size_t length;
            size_t index;
            uint16_t source_position;

            if (input_position == compressed_size) {
                /* An empty final flag group is accepted just like a literal group. */
                break;
            }
            low = (uint8_t)(compressed[input_position] - counter);
            ++input_position;
            counter = (uint8_t)(counter + 1u);
            if (input_position == compressed_size) {
                if (written != NULL) {
                    *written = output_position;
                }
                if (consumed != NULL) {
                    *consumed = input_position;
                }
                return CIF_ERR_MALFORMED;
            }
            high = (uint8_t)(compressed[input_position] - counter);
            ++input_position;
            counter = (uint8_t)(counter + 1u);

            length = (size_t)(high & 0x0fu) + 3u;
            if (length > output_capacity - output_position) {
                if (written != NULL) {
                    *written = output_position;
                }
                if (consumed != NULL) {
                    *consumed = input_position;
                }
                return CIF_ERR_OUTPUT_SIZE;
            }
            source_position = (uint16_t)((uint16_t)low |
                                         ((uint16_t)(high & 0xf0u) << 4));
            for (index = 0; index < length; ++index) {
                value = context->ring[(source_position + (uint16_t)index) & 0x0fffu];
                output[output_position++] = value;
                context->ring[ring_position] = value;
                ring_position = (uint16_t)((ring_position + 1u) & 0x0fffu);
            }
        }
    }

    if (written != NULL) {
        *written = output_position;
    }
    if (consumed != NULL) {
        *consumed = input_position;
    }
    if (output_position != output_capacity) {
        return CIF_ERR_MALFORMED;
    }
    if (input_position != compressed_size) {
        return CIF_ERR_MALFORMED;
    }
    return CIF_OK;
}

static void cif_tree_destroy_partial(cif_tree *tree)
{
    if (tree != NULL) {
        free(tree->entries);
        free(tree->archive);
        free(tree);
    }
}

static int validate_entry_name(cif_entry_info *entry)
{
    const uint8_t *raw_name = (const uint8_t *)entry->name;
    const uint8_t *terminator = memchr(raw_name, 0, sizeof(entry->name));
    size_t length;
    size_t index;

    if (terminator == NULL) {
        return 0;
    }
    length = (size_t)(terminator - raw_name);
    for (index = 0; index < length; ++index) {
        if (raw_name[index] >= 0x80u) {
            return 0;
        }
    }
    return 1;
}

static cif_tree *cif_tree_open_owned(uint8_t *archive,
                                     size_t archive_size,
                                     char *error,
                                     size_t error_capacity)
{
    cif_tree *tree = NULL;
    size_t metadata_size;
    size_t entry_count;
    size_t index;
    uint8_t *visited = NULL;

    clear_error(error, error_capacity);
    if (archive == NULL) {
        set_error(error, error_capacity, "archive bytes are missing");
        return NULL;
    }
    if (archive_size > CIF_MAX_ARCHIVE_SIZE) {
        set_error(error, error_capacity, "archive exceeds the 1 GiB safety limit");
        free(archive);
        return NULL;
    }
    if (archive_size < CIF_TREE_PREFIX_SIZE) {
        set_error(error, error_capacity, "archive is shorter than the tree header and hash table");
        free(archive);
        return NULL;
    }
    if (memcmp(archive, cif_tree_magic, sizeof(cif_tree_magic)) != 0) {
        set_error(error, error_capacity, "invalid CIF TREE magic");
        free(archive);
        return NULL;
    }
    if (read_u16le(archive + 24) != 2u || read_u16le(archive + 26) != 1u) {
        set_error(error, error_capacity, "unsupported CIF TREE version");
        free(archive);
        return NULL;
    }

    entry_count = (size_t)read_u16le(archive + 28);
    if (entry_count > (SIZE_MAX - CIF_TREE_PREFIX_SIZE) / CIF_ENTRY_SIZE) {
        set_error(error, error_capacity, "tree entry table size overflows");
        free(archive);
        return NULL;
    }
    metadata_size = CIF_TREE_PREFIX_SIZE + entry_count * CIF_ENTRY_SIZE;
    if (metadata_size > archive_size) {
        set_error(error, error_capacity, "tree entry table is truncated");
        free(archive);
        return NULL;
    }

    tree = (cif_tree *)calloc(1, sizeof(*tree));
    if (tree == NULL) {
        set_error(error, error_capacity, "unable to allocate tree metadata");
        free(archive);
        return NULL;
    }
    tree->archive = archive;
    tree->archive_size = archive_size;
    tree->entry_count = entry_count;
    if (entry_count != 0) {
        tree->entries = (cif_entry_info *)calloc(entry_count, sizeof(*tree->entries));
        visited = (uint8_t *)calloc(entry_count, sizeof(*visited));
        if (tree->entries == NULL || visited == NULL) {
            set_error(error, error_capacity, "unable to allocate tree entry table");
            free(visited);
            cif_tree_destroy_partial(tree);
            return NULL;
        }
    }

    for (index = 0; index < CIF_BUCKET_COUNT; ++index) {
        tree->buckets[index] = read_u16le(archive + CIF_TREE_HEADER_SIZE + index * 2u);
        if (tree->buckets[index] != UINT16_MAX &&
            (size_t)tree->buckets[index] >= entry_count) {
            set_error(error, error_capacity, "hash table contains an out-of-range entry index");
            free(visited);
            cif_tree_destroy_partial(tree);
            return NULL;
        }
    }

    for (index = 0; index < entry_count; ++index) {
        const uint8_t *raw = archive + CIF_TREE_PREFIX_SIZE + index * CIF_ENTRY_SIZE;
        cif_entry_info *entry = &tree->entries[index];
        memcpy(entry->name, raw, sizeof(entry->name));
        if (!validate_entry_name(entry)) {
            set_error(error, error_capacity, "tree entry name is not NUL-terminated ASCII");
            free(visited);
            cif_tree_destroy_partial(tree);
            return NULL;
        }
        entry->id = read_u16le(raw + 33);
        entry->data_offset = read_u32le(raw + 35);
        entry->next_index = read_u16le(raw + 39);
        memcpy(entry->metadata_41_80, raw + 41, sizeof(entry->metadata_41_80));
        entry->output_size = read_u32le(raw + 81);
        memcpy(entry->metadata_85_88, raw + 85, sizeof(entry->metadata_85_88));
        entry->compressed_size = read_u32le(raw + 89);
        entry->type = raw[93];

        if (entry->type != 2u && entry->type != 3u && entry->type != 4u) {
            set_error(error, error_capacity, "tree entry has an unsupported resource type");
            free(visited);
            cif_tree_destroy_partial(tree);
            return NULL;
        }
        if (entry->output_size > CIF_MAX_RESOURCE_SIZE ||
            (size_t)entry->data_offset > archive_size ||
            (size_t)entry->compressed_size > archive_size - (size_t)entry->data_offset) {
            set_error(error, error_capacity, "tree entry payload range is outside the archive");
            free(visited);
            cif_tree_destroy_partial(tree);
            return NULL;
        }
        if (entry->type == 4u &&
            (entry->output_size != 0u || entry->compressed_size != 0u)) {
            set_error(error, error_capacity, "marker entry has a nonzero payload size");
            free(visited);
            cif_tree_destroy_partial(tree);
            return NULL;
        }
    }

    for (index = 0; index < CIF_BUCKET_COUNT; ++index) {
        uint16_t item = tree->buckets[index];
        while (item != UINT16_MAX) {
            cif_entry_info *entry;

            if ((size_t)item >= entry_count) {
                set_error(error, error_capacity, "hash chain contains an out-of-range index");
                free(visited);
                cif_tree_destroy_partial(tree);
                return NULL;
            }
            if (visited[item] != 0) {
                set_error(error, error_capacity, "hash chains contain a cycle or duplicate entry");
                free(visited);
                cif_tree_destroy_partial(tree);
                return NULL;
            }
            visited[item] = 1;
            entry = &tree->entries[item];
            if (name_hash(entry->name) != (int)index) {
                set_error(error, error_capacity, "entry is stored in the wrong hash bucket");
                free(visited);
                cif_tree_destroy_partial(tree);
                return NULL;
            }
            item = entry->next_index;
        }
    }
    for (index = 0; index < entry_count; ++index) {
        if (visited[index] == 0) {
            set_error(error, error_capacity, "one or more entries are unreachable from the hash table");
            free(visited);
            cif_tree_destroy_partial(tree);
            return NULL;
        }
    }
    free(visited);
    return tree;
}

cif_tree *cif_tree_open_memory(const void *archive,
                               size_t archive_size,
                               char *error,
                               size_t error_capacity)
{
    uint8_t *copy;

    clear_error(error, error_capacity);
    if (archive == NULL && archive_size != 0) {
        set_error(error, error_capacity, "archive bytes are missing");
        return NULL;
    }
    if (archive_size == 0 || archive_size > CIF_MAX_ARCHIVE_SIZE) {
        set_error(error, error_capacity, "archive size is empty or exceeds the 1 GiB safety limit");
        return NULL;
    }
    copy = (uint8_t *)malloc(archive_size);
    if (copy == NULL) {
        set_error(error, error_capacity, "unable to allocate archive bytes");
        return NULL;
    }
    memcpy(copy, archive, archive_size);
    return cif_tree_open_owned(copy, archive_size, error, error_capacity);
}

cif_tree *cif_tree_open_file(const char *path,
                             char *error,
                             size_t error_capacity)
{
    FILE *file;
    long end_position;
    size_t size;
    uint8_t *bytes;
    cif_tree *tree;

    clear_error(error, error_capacity);
    if (path == NULL || path[0] == '\0') {
        set_error(error, error_capacity, "archive path is empty");
        return NULL;
    }
    file = fopen(path, "rb");
    if (file == NULL) {
        set_error(error, error_capacity, "unable to open archive file");
        return NULL;
    }
    if (fseek(file, 0, SEEK_END) != 0 || (end_position = ftell(file)) < 0 ||
        (uintmax_t)end_position > (uintmax_t)CIF_MAX_ARCHIVE_SIZE ||
        fseek(file, 0, SEEK_SET) != 0) {
        (void)fclose(file);
        set_error(error, error_capacity, "archive file size is invalid or exceeds the 1 GiB safety limit");
        return NULL;
    }
    size = (size_t)end_position;
    if (size == 0) {
        (void)fclose(file);
        set_error(error, error_capacity, "archive file is empty");
        return NULL;
    }
    bytes = (uint8_t *)malloc(size);
    if (bytes == NULL) {
        (void)fclose(file);
        set_error(error, error_capacity, "unable to allocate archive bytes");
        return NULL;
    }
    if (fread(bytes, 1, size, file) != size || ferror(file) != 0) {
        free(bytes);
        (void)fclose(file);
        set_error(error, error_capacity, "unable to read complete archive file");
        return NULL;
    }
    if (fclose(file) != 0) {
        free(bytes);
        set_error(error, error_capacity, "unable to close archive file");
        return NULL;
    }
    tree = cif_tree_open_owned(bytes, size, error, error_capacity);
    return tree;
}

void cif_tree_close(cif_tree *tree)
{
    cif_tree_destroy_partial(tree);
}

size_t cif_tree_entry_count(const cif_tree *tree)
{
    return tree == NULL ? 0 : tree->entry_count;
}

int cif_tree_entry_at(const cif_tree *tree,
                      size_t index,
                      cif_entry_info *entry)
{
    if (tree == NULL || entry == NULL) {
        return CIF_ERR_ARGUMENT;
    }
    if (index >= tree->entry_count) {
        return CIF_ERR_BOUNDS;
    }
    *entry = tree->entries[index];
    return CIF_OK;
}

int cif_tree_find(const cif_tree *tree, const char *name, size_t *index)
{
    char uppercase_name[33];
    size_t length = 0;
    int bucket;
    uint16_t item;

    if (tree == NULL || name == NULL || index == NULL) {
        return CIF_ERR_ARGUMENT;
    }
    while (length < sizeof(uppercase_name) && name[length] != '\0') {
        unsigned char value = (unsigned char)name[length];
        if (value >= 0x80u) {
            return CIF_ERR_UNSUPPORTED;
        }
        uppercase_name[length] = (char)ascii_upper(value);
        ++length;
    }
    if (length == sizeof(uppercase_name)) {
        return CIF_ERR_BOUNDS;
    }
    uppercase_name[length] = '\0';

    bucket = name_hash(uppercase_name);
    item = tree->buckets[(size_t)bucket];
    while (item != UINT16_MAX) {
        const cif_entry_info *entry = &tree->entries[item];
        if (strcmp(entry->name, uppercase_name) == 0) {
            *index = item;
            return CIF_OK;
        }
        item = entry->next_index;
    }
    return CIF_ERR_NOT_FOUND;
}

int cif_tree_extract(const cif_tree *tree,
                     size_t index,
                     cif_decode_context *context,
                     uint8_t *output,
                     size_t output_capacity,
                     size_t *written,
                     size_t *consumed)
{
    const cif_entry_info *entry;
    size_t output_size;

    if (written != NULL) {
        *written = 0;
    }
    if (consumed != NULL) {
        *consumed = 0;
    }
    if (tree == NULL || context == NULL) {
        return CIF_ERR_ARGUMENT;
    }
    if (index >= tree->entry_count) {
        return CIF_ERR_BOUNDS;
    }
    entry = &tree->entries[index];
    if (entry->type == 4u) {
        return CIF_ERR_UNSUPPORTED;
    }
    output_size = (size_t)entry->output_size;
    if (output_capacity < output_size || (output_size != 0 && output == NULL)) {
        return CIF_ERR_OUTPUT_SIZE;
    }
    return cif_decode(context,
                      tree->archive + entry->data_offset,
                      (size_t)entry->compressed_size,
                      output,
                      output_size,
                      written,
                      consumed);
}

int cif_decode_cif_memory(cif_decode_context *context,
                          const void *file_bytes,
                          size_t file_size,
                          uint8_t *output,
                          size_t output_capacity,
                          size_t *required_output,
                          size_t *written,
                          size_t *consumed)
{
    const uint8_t *bytes = (const uint8_t *)file_bytes;
    uint32_t output_size;
    uint32_t compressed_size;
    uint8_t type;

    if (required_output != NULL) {
        *required_output = 0;
    }
    if (written != NULL) {
        *written = 0;
    }
    if (consumed != NULL) {
        *consumed = 0;
    }
    if (context == NULL || bytes == NULL) {
        return CIF_ERR_ARGUMENT;
    }
    if (file_size < CIF_CIF_HEADER_SIZE) {
        return CIF_ERR_FORMAT;
    }
    if (memcmp(bytes, cif_file_magic, sizeof(cif_file_magic)) != 0 ||
        read_u16le(bytes + 24) != 2u || read_u16le(bytes + 26) != 1u) {
        return CIF_ERR_FORMAT;
    }
    if (bytes[67] != 2u) {
        return CIF_ERR_UNSUPPORTED;
    }
    output_size = read_u32le(bytes + 68);
    compressed_size = read_u32le(bytes + 76);
    type = bytes[80];
    if (type != 2u && type != 3u) {
        return CIF_ERR_UNSUPPORTED;
    }
    if ((size_t)output_size > CIF_MAX_RESOURCE_SIZE ||
        (size_t)compressed_size > file_size - CIF_CIF_HEADER_SIZE) {
        return CIF_ERR_BOUNDS;
    }
    if (required_output != NULL) {
        *required_output = (size_t)output_size;
    }
    if (output_capacity < (size_t)output_size ||
        (output_size != 0u && output == NULL)) {
        return CIF_ERR_OUTPUT_SIZE;
    }
    return cif_decode(context,
                      bytes + CIF_CIF_HEADER_SIZE,
                      (size_t)compressed_size,
                      output,
                      (size_t)output_size,
                      written,
                      consumed);
}

const char *cif_status_string(int status)
{
    switch (status) {
    case CIF_OK:
        return "success";
    case CIF_ERR_ARGUMENT:
        return "invalid argument";
    case CIF_ERR_IO:
        return "I/O error";
    case CIF_ERR_MEMORY:
        return "out of memory";
    case CIF_ERR_FORMAT:
        return "invalid CIF format";
    case CIF_ERR_UNSUPPORTED:
        return "unsupported CIF feature";
    case CIF_ERR_NOT_FOUND:
        return "resource not found";
    case CIF_ERR_BOUNDS:
        return "size or offset is out of bounds";
    case CIF_ERR_MALFORMED:
        return "malformed compressed stream";
    case CIF_ERR_OUTPUT_SIZE:
        return "output size does not fit or match";
    case CIF_ERR_EXISTS:
        return "output file already exists";
    default:
        return "unknown CIF error";
    }
}
