#define _POSIX_C_SOURCE 200809L

#include "hiff.h"

#include <errno.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int read_entire_file(const char *path, uint8_t **bytes, size_t *length)
{
    FILE *file;
    long end_position;
    uint8_t *buffer;

    *bytes = NULL;
    *length = 0u;
    file = fopen(path, "rb");
    if (file == NULL) {
        (void)fprintf(stderr, "hifftool: cannot open '%s': %s\n", path, strerror(errno));
        return 0;
    }
    if (fseek(file, 0, SEEK_END) != 0 || (end_position = ftell(file)) < 0 ||
        fseek(file, 0, SEEK_SET) != 0) {
        (void)fprintf(stderr, "hifftool: cannot size input '%s'\n", path);
        (void)fclose(file);
        return 0;
    }
    if ((uintmax_t)end_position > (uintmax_t)SIZE_MAX) {
        (void)fprintf(stderr, "hifftool: input '%s' is too large for this process\n", path);
        (void)fclose(file);
        return 0;
    }
    buffer = (uint8_t *)malloc(end_position == 0 ? 1u : (size_t)end_position);
    if (buffer == NULL) {
        (void)fprintf(stderr, "hifftool: unable to allocate %ld input bytes\n", end_position);
        (void)fclose(file);
        return 0;
    }
    if (end_position > 0 &&
        (fread(buffer, 1u, (size_t)end_position, file) != (size_t)end_position ||
         ferror(file) != 0)) {
        (void)fprintf(stderr, "hifftool: failed while reading '%s'\n", path);
        free(buffer);
        (void)fclose(file);
        return 0;
    }
    if (fclose(file) != 0) {
        (void)fprintf(stderr, "hifftool: failed while closing '%s'\n", path);
        free(buffer);
        return 0;
    }
    *bytes = buffer;
    *length = (size_t)end_position;
    return 1;
}

static void print_json_bytes(const char *value, size_t length)
{
    size_t index;

    (void)putchar('"');
    for (index = 0u; index < length && value[index] != '\0'; ++index) {
        unsigned char byte = (unsigned char)value[index];
        switch (byte) {
        case '"':
            (void)fputs("\\\"", stdout);
            break;
        case '\\':
            (void)fputs("\\\\", stdout);
            break;
        case '\b':
            (void)fputs("\\b", stdout);
            break;
        case '\f':
            (void)fputs("\\f", stdout);
            break;
        case '\n':
            (void)fputs("\\n", stdout);
            break;
        case '\r':
            (void)fputs("\\r", stdout);
            break;
        case '\t':
            (void)fputs("\\t", stdout);
            break;
        default:
            if (byte < 0x20u || byte >= 0x80u) {
                (void)printf("\\u%04x", (unsigned int)byte);
            } else {
                (void)putchar((int)byte);
            }
            break;
        }
    }
    (void)putchar('"');
}

static int command_list(const char *path)
{
    uint8_t *input;
    size_t input_length;
    char error[192];
    Hiff *hiff;
    size_t index;

    if (!read_entire_file(path, &input, &input_length)) {
        return 1;
    }
    hiff = hiff_open_memory(input, input_length, error, sizeof(error));
    free(input);
    if (hiff == NULL) {
        (void)fprintf(stderr, "hifftool: %s: %s\n", path, error);
        return 1;
    }

    (void)printf("{\"input_size\":%zu,\"data_count\":%zu,\"chunk_count\":%zu,\"data\":[",
                 input_length, hiff_data_count(hiff), hiff_chunk_count(hiff));
    for (index = 0u; index < hiff_data_count(hiff); ++index) {
        HiffDataInfo record;
        if (hiff_data_at(hiff, index, &record) != HIFF_OK) {
            (void)fprintf(stderr, "hifftool: internal DATA listing failure at %zu\n", index);
            hiff_close(hiff);
            return 1;
        }
        if (index != 0u) {
            (void)putchar(',');
        }
        (void)printf("{\"index\":%zu,\"record_offset\":%zu,\"type_offset\":%zu,"
                     "\"body_offset\":%zu,\"declared_size\":%" PRIu32
                     ",\"extent_size\":%zu,\"body_size\":%" PRIu32 ",\"type\":",
                     index, record.record_offset, record.type_offset, record.body_offset,
                     record.declared_size, record.extent_size, record.declared_size - 4u);
        print_json_bytes(record.type, 4u);
        (void)putchar('}');
    }
    (void)fputs("],\"chunks\":[", stdout);
    for (index = 0u; index < hiff_chunk_count(hiff); ++index) {
        HiffChunkInfo chunk;
        if (hiff_chunk_at(hiff, index, &chunk) != HIFF_OK) {
            (void)fprintf(stderr, "hifftool: internal chunk listing failure at %zu\n", index);
            hiff_close(hiff);
            return 1;
        }
        if (index != 0u) {
            (void)putchar(',');
        }
        (void)printf("{\"index\":%zu,\"data_index\":%zu,\"header_offset\":%zu,"
                     "\"payload_offset\":%zu,\"payload_size\":%" PRIu32
                     ",\"padded_extent_size\":%zu,\"id\":",
                     index, chunk.data_index, chunk.header_offset, chunk.payload_offset,
                     chunk.payload_size, chunk.padded_extent_size);
        print_json_bytes(chunk.id, 4u);
        (void)putchar('}');
    }
    (void)fputs("]}\n", stdout);
    if (fflush(stdout) != 0 || ferror(stdout) != 0) {
        (void)fprintf(stderr, "hifftool: unable to write JSON listing\n");
        hiff_close(hiff);
        return 1;
    }
    hiff_close(hiff);
    return 0;
}

int main(int argc, char **argv)
{
    if (argc == 3 && strcmp(argv[1], "list") == 0) {
        return command_list(argv[2]);
    }
    (void)fprintf(stderr, "usage: %s list <decoded-resource.bin>\n", argv[0]);
    return 2;
}
