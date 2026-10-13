#define _POSIX_C_SOURCE 200809L

#include "cif_archive.h"

#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static int read_entire_file(const char *path, uint8_t **bytes, size_t *size)
{
    FILE *file;
    long end_position;
    uint8_t *buffer;

    *bytes = NULL;
    *size = 0;
    file = fopen(path, "rb");
    if (file == NULL) {
        (void)fprintf(stderr, "ciftool: cannot open '%s': %s\n", path, strerror(errno));
        return 0;
    }
    if (fseek(file, 0, SEEK_END) != 0 || (end_position = ftell(file)) < 0 ||
        (uintmax_t)end_position > (uintmax_t)CIF_MAX_ARCHIVE_SIZE ||
        fseek(file, 0, SEEK_SET) != 0) {
        (void)fprintf(stderr, "ciftool: invalid or oversized input file '%s'\n", path);
        (void)fclose(file);
        return 0;
    }
    if (end_position == 0) {
        (void)fprintf(stderr, "ciftool: input file '%s' is empty\n", path);
        (void)fclose(file);
        return 0;
    }
    buffer = (uint8_t *)malloc((size_t)end_position);
    if (buffer == NULL) {
        (void)fprintf(stderr, "ciftool: out of memory reading '%s'\n", path);
        (void)fclose(file);
        return 0;
    }
    if (fread(buffer, 1, (size_t)end_position, file) != (size_t)end_position ||
        ferror(file) != 0) {
        (void)fprintf(stderr, "ciftool: failed while reading '%s'\n", path);
        free(buffer);
        (void)fclose(file);
        return 0;
    }
    if (fclose(file) != 0) {
        (void)fprintf(stderr, "ciftool: failed while closing '%s'\n", path);
        free(buffer);
        return 0;
    }
    *bytes = buffer;
    *size = (size_t)end_position;
    return 1;
}

static void print_json_string(const char *value)
{
    const unsigned char *cursor = (const unsigned char *)value;

    (void)putchar('"');
    while (*cursor != 0) {
        switch (*cursor) {
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
            if (*cursor < 0x20u) {
                (void)printf("\\u%04x", (unsigned int)*cursor);
            } else {
                (void)putchar((int)*cursor);
            }
            break;
        }
        ++cursor;
    }
    (void)putchar('"');
}

static int command_list(const char *archive_path)
{
    char error[192];
    cif_tree *tree = cif_tree_open_file(archive_path, error, sizeof(error));
    size_t count;
    size_t index;

    if (tree == NULL) {
        (void)fprintf(stderr, "ciftool: %s: %s\n", archive_path, error);
        return 1;
    }
    count = cif_tree_entry_count(tree);
    for (index = 0; index < count; ++index) {
        cif_entry_info entry;
        if (cif_tree_entry_at(tree, index, &entry) != CIF_OK) {
            (void)fprintf(stderr, "ciftool: failed to read validated entry %zu\n", index);
            cif_tree_close(tree);
            return 1;
        }
        (void)printf("{\"index\":%zu,\"name\":", index);
        print_json_string(entry.name);
        (void)printf(",\"id\":%u,\"type\":%u,\"data_offset\":%" PRIu32
                    ",\"compressed_size\":%" PRIu32 ",\"output_size\":%" PRIu32
                    ",\"next_index\":%u}\n",
                    (unsigned int)entry.id,
                    (unsigned int)entry.type,
                    entry.data_offset,
                    entry.compressed_size,
                    entry.output_size,
                    (unsigned int)entry.next_index);
    }
    if (fflush(stdout) != 0 || ferror(stdout) != 0) {
        (void)fprintf(stderr, "ciftool: unable to write listing to stdout\n");
        cif_tree_close(tree);
        return 1;
    }
    cif_tree_close(tree);
    return 0;
}

static int write_new_file(const char *path, const uint8_t *bytes, size_t size)
{
    int descriptor;
    size_t written = 0;
    int failed = 0;

    descriptor = open(path, O_WRONLY | O_CREAT | O_EXCL, 0666);
    if (descriptor < 0) {
        if (errno == EEXIST) {
            (void)fprintf(stderr, "ciftool: output already exists: '%s'\n", path);
        } else {
            (void)fprintf(stderr, "ciftool: cannot create '%s': %s\n", path, strerror(errno));
        }
        return 0;
    }
    while (written < size) {
        ssize_t amount = write(descriptor, bytes + written, size - written);
        if (amount < 0 && errno == EINTR) {
            continue;
        }
        if (amount <= 0) {
            failed = 1;
            break;
        }
        written += (size_t)amount;
    }
    if (close(descriptor) != 0) {
        failed = 1;
    }
    if (failed) {
        int saved_errno = errno;
        (void)unlink(path);
        (void)fprintf(stderr, "ciftool: failed writing '%s': %s\n", path, strerror(saved_errno));
        return 0;
    }
    return 1;
}

static int command_extract(const char *archive_path, const char *name, const char *output_path)
{
    char error[192];
    cif_tree *tree = cif_tree_open_file(archive_path, error, sizeof(error));
    size_t index;
    cif_entry_info entry;
    cif_decode_context context;
    uint8_t *output;
    size_t written = 0;
    size_t consumed = 0;
    int status;

    if (tree == NULL) {
        (void)fprintf(stderr, "ciftool: %s: %s\n", archive_path, error);
        return 1;
    }
    status = cif_tree_find(tree, name, &index);
    if (status != CIF_OK) {
        (void)fprintf(stderr, "ciftool: resource '%s': %s\n", name, cif_status_string(status));
        cif_tree_close(tree);
        return 1;
    }
    status = cif_tree_entry_at(tree, index, &entry);
    if (status != CIF_OK) {
        (void)fprintf(stderr, "ciftool: entry lookup failed: %s\n", cif_status_string(status));
        cif_tree_close(tree);
        return 1;
    }
    if (entry.output_size == 0u) {
        output = (uint8_t *)malloc(1);
    } else {
        output = (uint8_t *)malloc((size_t)entry.output_size);
    }
    if (output == NULL) {
        (void)fprintf(stderr, "ciftool: unable to allocate %" PRIu32 " output bytes\n",
                      entry.output_size);
        cif_tree_close(tree);
        return 1;
    }
    cif_decode_context_init(&context);
    status = cif_tree_extract(tree,
                              index,
                              &context,
                              output,
                              (size_t)entry.output_size,
                              &written,
                              &consumed);
    if (status != CIF_OK) {
        (void)fprintf(stderr, "ciftool: resource '%s': %s\n", name, cif_status_string(status));
        free(output);
        cif_tree_close(tree);
        return 1;
    }
    if (written != (size_t)entry.output_size || consumed != (size_t)entry.compressed_size) {
        (void)fprintf(stderr, "ciftool: resource '%s' did not decode to its declared lengths\n", name);
        free(output);
        cif_tree_close(tree);
        return 1;
    }
    if (!write_new_file(output_path, output, written)) {
        free(output);
        cif_tree_close(tree);
        return 1;
    }
    free(output);
    cif_tree_close(tree);
    return 0;
}

static int command_decode_cif(const char *input_path, const char *output_path)
{
    uint8_t *file_bytes = NULL;
    size_t file_size = 0;
    size_t required_output = 0;
    size_t written = 0;
    size_t consumed = 0;
    uint8_t *output;
    cif_decode_context context;
    int status;

    if (!read_entire_file(input_path, &file_bytes, &file_size)) {
        return 1;
    }
    cif_decode_context_init(&context);
    status = cif_decode_cif_memory(&context,
                                  file_bytes,
                                  file_size,
                                  NULL,
                                  0,
                                  &required_output,
                                  &written,
                                  &consumed);
    if (status != CIF_OK && status != CIF_ERR_OUTPUT_SIZE) {
        (void)fprintf(stderr, "ciftool: %s: %s\n", input_path, cif_status_string(status));
        free(file_bytes);
        return 1;
    }
    output = (uint8_t *)malloc(required_output == 0 ? 1 : required_output);
    if (output == NULL) {
        (void)fprintf(stderr, "ciftool: unable to allocate %zu output bytes\n", required_output);
        free(file_bytes);
        return 1;
    }
    cif_decode_context_init(&context);
    status = cif_decode_cif_memory(&context,
                                  file_bytes,
                                  file_size,
                                  output,
                                  required_output,
                                  &required_output,
                                  &written,
                                  &consumed);
    free(file_bytes);
    if (status != CIF_OK) {
        (void)fprintf(stderr, "ciftool: %s: %s\n", input_path, cif_status_string(status));
        free(output);
        return 1;
    }
    if (written != required_output) {
        (void)fprintf(stderr, "ciftool: decoded output size differs from its header\n");
        free(output);
        return 1;
    }
    if (!write_new_file(output_path, output, written)) {
        free(output);
        return 1;
    }
    free(output);
    return 0;
}

static void print_usage(const char *program)
{
    (void)fprintf(stderr,
                  "Usage:\n"
                  "  %s list ARCHIVE\n"
                  "  %s extract ARCHIVE NAME OUTPUT\n"
                  "  %s decode-cif FILE OUTPUT\n",
                  program,
                  program,
                  program);
}

int main(int argc, char **argv)
{
    if (argc == 3 && strcmp(argv[1], "list") == 0) {
        return command_list(argv[2]);
    }
    if (argc == 5 && strcmp(argv[1], "extract") == 0) {
        return command_extract(argv[2], argv[3], argv[4]);
    }
    if (argc == 4 && strcmp(argv[1], "decode-cif") == 0) {
        return command_decode_cif(argv[2], argv[3]);
    }
    print_usage(argv[0]);
    return 2;
}
