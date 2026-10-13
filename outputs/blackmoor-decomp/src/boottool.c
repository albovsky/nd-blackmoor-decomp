#define _POSIX_C_SOURCE 200809L

#include "cif_image.h"
#include "engine_boot.h"

#include <dirent.h>
#include <errno.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

#define BOOTTOOL_MAX_INPUT_SIZE ((size_t)1u << 30)

typedef struct input_file {
    uint8_t *bytes;
    size_t size;
} input_file;

static int read_file(const char *path, input_file *file, char *error, size_t error_capacity)
{
    FILE *stream;
    long end_position;
    uint8_t *bytes;

    file->bytes = NULL;
    file->size = 0u;
    stream = fopen(path, "rb");
    if (stream == NULL) {
        (void)snprintf(error, error_capacity, "cannot open '%s': %s", path, strerror(errno));
        return 0;
    }
    if (fseek(stream, 0, SEEK_END) != 0 ||
        (end_position = ftell(stream)) < 0 ||
        (uintmax_t)end_position > (uintmax_t)BOOTTOOL_MAX_INPUT_SIZE ||
        fseek(stream, 0, SEEK_SET) != 0) {
        (void)snprintf(error, error_capacity, "invalid or oversized input '%s'", path);
        (void)fclose(stream);
        return 0;
    }
    bytes = (uint8_t *)malloc(end_position == 0 ? 1u : (size_t)end_position);
    if (bytes == NULL) {
        (void)snprintf(error, error_capacity, "unable to allocate input '%s'", path);
        (void)fclose(stream);
        return 0;
    }
    if (end_position != 0 &&
        (fread(bytes, 1u, (size_t)end_position, stream) != (size_t)end_position ||
         ferror(stream) != 0)) {
        (void)snprintf(error, error_capacity, "failed while reading '%s'", path);
        free(bytes);
        (void)fclose(stream);
        return 0;
    }
    if (fclose(stream) != 0) {
        (void)snprintf(error, error_capacity, "failed while closing '%s'", path);
        free(bytes);
        return 0;
    }
    file->bytes = bytes;
    file->size = (size_t)end_position;
    return 1;
}

static void json_string(const char *value)
{
    const unsigned char *cursor = (const unsigned char *)value;

    (void)putchar('"');
    while (*cursor != 0u) {
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

static int decode_boot_cif(const input_file *cif,
                           cif_decode_context *context,
                           uint8_t **decoded,
                           size_t *decoded_size,
                           char *error,
                           size_t error_capacity)
{
    size_t required = 0u;
    size_t written = 0u;
    size_t consumed = 0u;
    uint8_t *output;
    int status;

    if (cif->size < 81u || cif->bytes[80u] != 3u) {
        (void)snprintf(error, error_capacity,
                       "--boot-cif requires an explicit standalone CIF type-3 resource");
        return 0;
    }
    status = cif_decode_cif_memory(context,
                                   cif->bytes,
                                   cif->size,
                                   NULL,
                                   0u,
                                   &required,
                                   &written,
                                   &consumed);
    if (status != CIF_ERR_OUTPUT_SIZE || required == 0u ||
        required > BOOTTOOL_MAX_INPUT_SIZE) {
        (void)snprintf(error, error_capacity, "invalid standalone BOOT CIF: %s",
                       cif_status_string(status));
        return 0;
    }
    output = (uint8_t *)malloc(required);
    if (output == NULL) {
        (void)snprintf(error, error_capacity,
                       "unable to allocate %zu decoded BOOT bytes", required);
        return 0;
    }
    status = cif_decode_cif_memory(context,
                                   cif->bytes,
                                   cif->size,
                                   output,
                                   required,
                                   NULL,
                                   &written,
                                   &consumed);
    if (status != CIF_OK || written != required) {
        (void)snprintf(error, error_capacity,
                       "standalone BOOT CIF decode failed: %s (written=%zu expected=%zu)",
                       cif_status_string(status), written, required);
        free(output);
        return 0;
    }
    *decoded = output;
    *decoded_size = required;
    return 1;
}

static void print_descriptor(const char *kind,
                             size_t index,
                             const EngineBootImageDescriptor *descriptor,
                             int *first)
{
    if (!*first) {
        (void)putchar(',');
    }
    *first = 0;
    (void)printf("{\"kind\":");
    json_string(kind);
    (void)printf(",\"index\":%zu,\"filename\":", index);
    json_string(descriptor->filename);
    (void)printf(",\"nominal_width\":%u,\"nominal_height\":%u,"
                 "\"source_chunk_index\":%zu,\"payload_offset\":%zu}",
                 (unsigned int)descriptor->nominal_width,
                 (unsigned int)descriptor->nominal_height,
                 descriptor->source_chunk_index,
                 descriptor->payload_offset);
}

static void print_unresolved_descriptor(const char *kind,
                                        size_t index,
                                        int status,
                                        int *first)
{
    if (!*first) {
        (void)putchar(',');
    }
    *first = 0;
    (void)printf("{\"kind\":");
    json_string(kind);
    (void)printf(",\"index\":%zu,\"status\":\"unresolved\",\"error\":", index);
    json_string(engine_boot_status_string(status));
    (void)putchar('}');
}

static void print_unresolved_asset(const char *kind,
                                   size_t index,
                                   int status,
                                   int *first)
{
    if (!*first) {
        (void)putchar(',');
    }
    *first = 0;
    (void)printf("{\"kind\":");
    json_string(kind);
    (void)printf(",\"index\":%zu,\"source\":\"boot-descriptor\","
                 "\"status\":\"declared-record-unresolved\",\"error\":", index);
    json_string(engine_boot_status_string(status));
    (void)putchar('}');
}

static unsigned char ascii_upper(unsigned char value)
{
    return value >= (unsigned char)'a' && value <= (unsigned char)'z'
               ? (unsigned char)(value - (unsigned char)'a' + (unsigned char)'A')
               : value;
}

static int equal_ascii_folded(const char *left, const char *right)
{
    for (;;) {
        if (ascii_upper((unsigned char)*left) != ascii_upper((unsigned char)*right)) {
            return 0;
        }
        if (*left == '\0') {
            return 1;
        }
        ++left;
        ++right;
    }
}

static int asset_filename(const char *directory,
                          const char *name,
                          char *path,
                          size_t path_capacity)
{
    size_t directory_length;
    size_t name_length;
    int separator;
    int amount;

    if (directory == NULL || name == NULL || path == NULL ||
        strchr(name, '/') != NULL || strchr(name, '\\') != NULL ||
        strcmp(name, ".") == 0 || strcmp(name, "..") == 0) {
        return 0;
    }
    directory_length = strlen(directory);
    name_length = strlen(name);
    separator = directory_length != 0u && directory[directory_length - 1u] != '/';
    if (name_length > SIZE_MAX - directory_length - (size_t)separator - 5u) {
        return 0;
    }
    amount = snprintf(path, path_capacity, "%s%s%s.CIF", directory,
                      separator ? "/" : "", name);
    return amount >= 0 && (size_t)amount < path_capacity;
}

/* Resolve the Windows-style external filename on case-sensitive filesystems.
 * Keep the actual spelling for reads and reject ambiguous ASCII-fold matches. */
static int resolve_external_filename(const char *directory,
                                     const char *name,
                                     char *path,
                                     size_t path_capacity,
                                     char *error,
                                     size_t error_capacity)
{
    char target[38];
    DIR *stream;
    struct dirent *entry;
    size_t directory_length;
    int separator;
    int amount;
    int result = 0;
    int matches = 0;

    if (!asset_filename(directory, name, path, path_capacity)) {
        (void)snprintf(error, error_capacity, "invalid-candidate-path");
        return -1;
    }
    amount = snprintf(target, sizeof(target), "%s.CIF", name);
    if (amount < 0 || (size_t)amount >= sizeof(target)) {
        (void)snprintf(error, error_capacity, "invalid-candidate-name");
        return -1;
    }
    stream = opendir(directory);
    if (stream == NULL) {
        (void)snprintf(error, error_capacity, "cannot-enumerate-external-cif-directory");
        return -1;
    }
    directory_length = strlen(directory);
    separator = directory_length != 0u && directory[directory_length - 1u] != '/';
    errno = 0;
    while ((entry = readdir(stream)) != NULL) {
        if (!equal_ascii_folded(entry->d_name, target)) {
            continue;
        }
        ++matches;
        if (matches > 1) {
            (void)snprintf(error, error_capacity,
                           "ambiguous-case-insensitive-external-cif-filename");
            result = -1;
            break;
        }
        amount = snprintf(path, path_capacity, "%s%s%s", directory,
                          separator ? "/" : "", entry->d_name);
        if (amount < 0 || (size_t)amount >= path_capacity) {
            (void)snprintf(error, error_capacity, "external-cif-path-too-long");
            result = -1;
            break;
        }
        result = 1;
    }
    if (errno != 0 && result != -1) {
        (void)snprintf(error, error_capacity, "external-cif-directory-enumeration-failed");
        result = -1;
    }
    if (closedir(stream) != 0 && result != -1) {
        (void)snprintf(error, error_capacity, "external-cif-directory-close-failed");
        result = -1;
    }
    if (result == -1) {
        return -1;
    }
    return result;
}

static void print_asset_result(const char *kind,
                               size_t index,
                               const char *name,
                               uint16_t nominal_width,
                               uint16_t nominal_height,
                               const char *source,
                               const char *source_path,
                               const char *external_candidate_path,
                               const char *status,
                               const cif_image *image,
                               int *first)
{
    if (!*first) {
        (void)putchar(',');
    }
    *first = 0;
    (void)printf("{\"kind\":");
    json_string(kind);
    (void)printf(",\"index\":%zu,\"filename\":", index);
    json_string(name);
    (void)printf(",\"nominal_width\":%u,\"nominal_height\":%u,\"source\":",
                 (unsigned int)nominal_width,
                 (unsigned int)nominal_height);
    json_string(source);
    if (source_path != NULL) {
        (void)fputs(",\"source_path\":", stdout);
        json_string(source_path);
    }
    if (external_candidate_path != NULL) {
        (void)fputs(",\"external_candidate_path\":", stdout);
        json_string(external_candidate_path);
    }
    (void)fputs(",\"status\":", stdout);
    json_string(status);
    if (image != NULL && image->pixels != NULL) {
        (void)printf(",\"actual_width\":%u,\"actual_pitch\":%u,"
                     "\"actual_height\":%u,\"actual_depth\":%u,\"decoded_bytes\":%zu",
                     (unsigned int)image->width,
                     (unsigned int)image->pitch,
                     (unsigned int)image->height,
                     (unsigned int)image->depth,
                     image->byte_count);
    }
    (void)putchar('}');
}

static int inspect_asset(const char *kind,
                         size_t index,
                         const char *name,
                         uint16_t nominal_width,
                         uint16_t nominal_height,
                         const cif_tree *tree,
                         const char *external_directory,
                         cif_decode_context *context,
                         int *first)
{
    cif_image image = CIF_IMAGE_INIT;
    char error[256];
    char path[4096];
    char candidate_path[4096];
    char status_text[96];
    const char *source = "not-checked";
    const char *source_path = NULL;
    const char *external_candidate_path = NULL;
    size_t entry_index;
    int status;

    if (external_directory != NULL) {
        struct stat file_status;
        int path_status;

        if (!asset_filename(external_directory, name,
                            candidate_path, sizeof(candidate_path))) {
            print_asset_result(kind, index, name, nominal_width, nominal_height,
                               "external-cif", NULL, NULL,
                               "invalid-candidate-path", NULL, first);
            return 1;
        }
        external_candidate_path = candidate_path;
        path_status = resolve_external_filename(external_directory, name,
                                                path, sizeof(path),
                                                error, sizeof(error));
        if (path_status < 0) {
            (void)snprintf(status_text, sizeof(status_text), "external-path-error:%s",
                           error);
            print_asset_result(kind, index, name, nominal_width, nominal_height,
                               "external-cif", NULL, external_candidate_path,
                               status_text, NULL, first);
            return 1;
        }
        if (path_status > 0) {
            input_file external;
            source = "external-cif";
            source_path = path;
            if (stat(path, &file_status) != 0) {
                print_asset_result(kind, index, name, nominal_width, nominal_height,
                                   source, source_path, external_candidate_path,
                                   "stat-error", NULL, first);
                return 1;
            }
            if (!read_file(path, &external, error, sizeof(error))) {
                print_asset_result(kind, index, name, nominal_width, nominal_height,
                                   source, source_path, external_candidate_path,
                                   "read-error", NULL, first);
                return 1;
            }
            status = cif_image_decode_cif_memory(external.bytes,
                                                 external.size,
                                                 context,
                                                 &image,
                                                 error,
                                                 sizeof(error));
            free(external.bytes);
            if (status != CIF_IMAGE_OK) {
                (void)snprintf(status_text, sizeof(status_text), "decode-error:%s",
                               cif_image_status_string(status));
                print_asset_result(kind, index, name, nominal_width, nominal_height,
                                   source, source_path, external_candidate_path,
                                   status_text, NULL, first);
                return 1;
            }
        } else {
            source = "tree-after-external-miss";
            source_path = NULL;
        }
    }

    if (image.pixels == NULL && tree != NULL) {
        status = cif_tree_find(tree, name, &entry_index);
        if (status == CIF_OK) {
            cif_entry_info entry;
            if (cif_tree_entry_at(tree, entry_index, &entry) != CIF_OK || entry.type != 2u) {
                print_asset_result(kind, index, name, nominal_width, nominal_height,
                                   "tree", NULL, external_candidate_path,
                                   "not-a-type-2-image", NULL, first);
                return 1;
            }
            source = external_directory == NULL ? "tree" : "tree-after-external-miss";
            status = cif_image_decode_tree_entry(tree, entry_index, context,
                                                 &image, error, sizeof(error));
            if (status != CIF_IMAGE_OK) {
                (void)snprintf(status_text, sizeof(status_text), "decode-error:%s",
                               cif_image_status_string(status));
                print_asset_result(kind, index, name, nominal_width, nominal_height,
                                   source, NULL, external_candidate_path,
                                   status_text, NULL, first);
                return 1;
            }
        } else {
            source = external_directory == NULL ? "tree" : "tree-after-external-miss";
            print_asset_result(kind, index, name, nominal_width, nominal_height,
                               source, NULL, external_candidate_path,
                               "not-found", NULL, first);
            return 1;
        }
    } else if (image.pixels == NULL) {
        source = external_directory == NULL ? "not-checked" : "external-cif-miss";
        print_asset_result(kind, index, name, nominal_width, nominal_height,
                           source, NULL, external_candidate_path,
                           "no-image-source-supplied", NULL, first);
        return 0;
    }

    print_asset_result(kind, index, name, nominal_width, nominal_height,
                       source, source_path, external_candidate_path,
                       "decoded", &image, first);
    cif_image_destroy(&image);
    return 0;
}

static int inspect_boot(const char *boot_path,
                        int boot_is_cif,
                        const char *tree_path,
                        const char *external_directory)
{
    input_file input;
    uint8_t *decoded_boot = NULL;
    size_t decoded_size = 0u;
    const uint8_t *boot_bytes;
    size_t boot_size;
    char error[256];
    EngineBoot *boot;
    EngineBootSummary summary;
    EngineBootMenuInfo menu;
    EngineBootPlgoInfo plgo;
    cif_tree *tree = NULL;
    cif_decode_context image_context;
    size_t index;
    int first;
    int failures = 0;
    int asset_failures = 0;

    if (!read_file(boot_path, &input, error, sizeof(error))) {
        (void)fprintf(stderr, "boottool: %s\n", error);
        return 1;
    }
    cif_decode_context_init(&image_context);
    if (boot_is_cif) {
        if (!decode_boot_cif(&input, &image_context,
                             &decoded_boot, &decoded_size, error, sizeof(error))) {
            (void)fprintf(stderr, "boottool: %s\n", error);
            free(input.bytes);
            return 1;
        }
        boot_bytes = decoded_boot;
        boot_size = decoded_size;
    } else {
        boot_bytes = input.bytes;
        boot_size = input.size;
    }
    boot = engine_boot_open_memory(boot_bytes, boot_size, error, sizeof(error));
    if (boot == NULL) {
        (void)fprintf(stderr, "boottool: %s\n", error);
        free(decoded_boot);
        free(input.bytes);
        return 1;
    }
    if (engine_boot_get_summary(boot, &summary) != ENGINE_BOOT_OK) {
        (void)fprintf(stderr, "boottool: unable to read BOOT summary\n");
        engine_boot_close(boot);
        free(decoded_boot);
        free(input.bytes);
        return 1;
    }

    if (tree_path != NULL) {
        tree = cif_tree_open_file(tree_path, error, sizeof(error));
        if (tree == NULL) {
            (void)fprintf(stderr, "boottool: %s: %s\n", tree_path, error);
            engine_boot_close(boot);
            free(decoded_boot);
            free(input.bytes);
            return 1;
        }
    }

    (void)fputs("{\"kind\":\"engine-boot\",\"boot_source\":{\"kind\":", stdout);
    json_string(boot_is_cif ? "standalone-cif" : "decoded-resource");
    (void)fputs(",\"path\":", stdout);
    json_string(boot_path);
    (void)printf("},\"decoded_size\":%zu,\"summary\":{\"logo_count\":%u,"
                 "\"object_count\":%u,\"font_count\":%d,\"initial_scene\":%d,"
                 "\"bsum_raw_size\":%u,\"bsum_chunk_index\":%zu,"
                 "\"bsum_payload_offset\":%zu},\"menu\":",
                 boot_size,
                 (unsigned int)summary.logo_count,
                 (unsigned int)summary.object_count,
                 (int)summary.font_count,
                 (int)summary.initial_scene,
                 ENGINE_BOOT_BSUM_SIZE,
                 summary.bsum_chunk_index,
                 summary.bsum_payload_offset);
    if (engine_boot_get_menu(boot, &menu) == ENGINE_BOOT_OK) {
        (void)printf("{\"raw_size\":%zu,\"first_image\":", menu.raw_size);
        json_string(menu.first_image_filename);
        (void)printf(",\"nominal_width\":%u,\"nominal_height\":%u}",
                     (unsigned int)menu.first_image_nominal_width,
                     (unsigned int)menu.first_image_nominal_height);
    } else {
        (void)fputs("null", stdout);
    }
    (void)fputs(",\"plgo\":", stdout);
    if (engine_boot_get_plgo(boot, &plgo) == ENGINE_BOOT_OK) {
        (void)printf("{\"raw_size\":%zu,\"filename\":", plgo.raw_size);
        json_string(plgo.filename);
        (void)printf(",\"byte_at_66\":%u,\"sound_name_at_111\":",
                     (unsigned int)plgo.byte_at_66);
        json_string(plgo.sound_name_at_111);
        (void)putchar('}');
    } else {
        (void)fputs("null", stdout);
    }

    (void)fputs(",\"chunks\":[", stdout);
    for (index = 0u; index < engine_boot_chunk_count(boot); ++index) {
        HiffChunkInfo chunk;
        const uint8_t *payload;
        size_t payload_size;

        if (engine_boot_chunk_at(boot, index, &chunk, &payload, &payload_size) != ENGINE_BOOT_OK) {
            continue;
        }
        if (index != 0u) {
            (void)putchar(',');
        }
        (void)printf("{\"index\":%zu,\"data_index\":%zu,\"id\":", index,
                     chunk.data_index);
        json_string(chunk.id);
        (void)printf(",\"header_offset\":%zu,\"payload_offset\":%zu,"
                     "\"payload_size\":%zu,\"padded_extent_size\":%zu}",
                     chunk.header_offset, chunk.payload_offset, payload_size,
                     chunk.padded_extent_size);
    }
    (void)fputs("],\"descriptors\":[", stdout);
    first = 1;
    if (engine_boot_get_menu(boot, &menu) == ENGINE_BOOT_OK) {
        EngineBootImageDescriptor descriptor;
        memset(&descriptor, 0, sizeof(descriptor));
        (void)memcpy(descriptor.filename, menu.first_image_filename,
                     sizeof(descriptor.filename));
        descriptor.nominal_width = menu.first_image_nominal_width;
        descriptor.nominal_height = menu.first_image_nominal_height;
        descriptor.source_chunk_index = menu.chunk_index;
        descriptor.payload_offset = menu.chunk.payload_offset;
        print_descriptor("menu", 0u, &descriptor, &first);
    }
    for (index = 0u; index < engine_boot_logo_count(boot); ++index) {
        EngineBootImageDescriptor descriptor;
        int descriptor_status = engine_boot_logo_at(boot, index, &descriptor);
        if (descriptor_status == ENGINE_BOOT_OK) {
            print_descriptor("logo", index, &descriptor, &first);
        } else {
            print_unresolved_descriptor("logo", index, descriptor_status, &first);
            ++failures;
        }
    }
    for (index = 0u; index < engine_boot_object_count(boot); ++index) {
        EngineBootImageDescriptor descriptor;
        int descriptor_status = engine_boot_object_at(boot, index, &descriptor);
        if (descriptor_status == ENGINE_BOOT_OK) {
            print_descriptor("object", index, &descriptor, &first);
        } else {
            print_unresolved_descriptor("object", index, descriptor_status, &first);
            ++failures;
        }
    }
    (void)fputs("],\"assets\":[", stdout);
    if (tree != NULL || external_directory != NULL) {
        first = 1;
        if (engine_boot_get_menu(boot, &menu) == ENGINE_BOOT_OK) {
            int asset_status = inspect_asset("menu", 0u,
                                             menu.first_image_filename,
                                             menu.first_image_nominal_width,
                                             menu.first_image_nominal_height,
                                             tree, external_directory,
                                             &image_context, &first);
            failures += asset_status;
            asset_failures += asset_status;
        }
        for (index = 0u; index < engine_boot_logo_count(boot) && asset_failures == 0; ++index) {
            EngineBootImageDescriptor descriptor;
            int descriptor_status = engine_boot_logo_at(boot, index, &descriptor);
            if (descriptor_status == ENGINE_BOOT_OK) {
                int asset_status = inspect_asset("logo", index,
                                                 descriptor.filename,
                                                 descriptor.nominal_width,
                                                 descriptor.nominal_height,
                                                 tree, external_directory,
                                                 &image_context, &first);
                failures += asset_status;
                asset_failures += asset_status;
            } else {
                print_unresolved_asset("logo", index, descriptor_status, &first);
            }
        }
        for (index = 0u; index < engine_boot_object_count(boot) && asset_failures == 0; ++index) {
            EngineBootImageDescriptor descriptor;
            int descriptor_status = engine_boot_object_at(boot, index, &descriptor);
            if (descriptor_status == ENGINE_BOOT_OK) {
                int asset_status = inspect_asset("object", index,
                                                 descriptor.filename,
                                                 descriptor.nominal_width,
                                                 descriptor.nominal_height,
                                                 tree, external_directory,
                                                 &image_context, &first);
                failures += asset_status;
                asset_failures += asset_status;
            } else {
                print_unresolved_asset("object", index, descriptor_status, &first);
            }
        }
    }
    (void)printf("],\"asset_load_stopped_on_error\":%s,\"tree_source\":",
                 asset_failures == 0 ? "false" : "true");
    if (tree_path == NULL) {
        (void)fputs("null", stdout);
    } else {
        json_string(tree_path);
    }
    (void)fputs(",\"external_cif_preference\":", stdout);
    if (external_directory == NULL) {
        (void)fputs("null", stdout);
    } else {
        (void)fputs("{\"enabled_by_cli\":true,\"directory\":", stdout);
        json_string(external_directory);
        (void)putchar('}');
    }
    (void)fputs("}\n", stdout);

    if (fflush(stdout) != 0 || ferror(stdout) != 0) {
        failures += 1;
    }
    cif_tree_close(tree);
    engine_boot_close(boot);
    free(decoded_boot);
    free(input.bytes);
    return failures == 0 ? 0 : 1;
}

static int inspect_standalone_image(const char *path)
{
    input_file input;
    cif_decode_context context;
    cif_image image = CIF_IMAGE_INIT;
    char error[256];
    int status;

    if (!read_file(path, &input, error, sizeof(error))) {
        (void)fprintf(stderr, "boottool: %s\n", error);
        return 1;
    }
    cif_decode_context_init(&context);
    status = cif_image_decode_cif_memory(input.bytes, input.size, &context,
                                         &image, error, sizeof(error));
    if (status != CIF_IMAGE_OK) {
        (void)fprintf(stderr, "boottool: %s\n", error);
        free(input.bytes);
        return 1;
    }
    (void)fputs("{\"kind\":\"standalone-cif-image\",\"path\":", stdout);
    json_string(path);
    (void)printf(",\"width\":%u,\"pitch\":%u,\"height\":%u,\"depth\":%u,"
                 "\"decoded_bytes\":%zu}\n",
                 (unsigned int)image.width,
                 (unsigned int)image.pitch,
                 (unsigned int)image.height,
                 (unsigned int)image.depth,
                 image.byte_count);
    cif_image_destroy(&image);
    free(input.bytes);
    return 0;
}

static void usage(const char *program)
{
    (void)fprintf(stderr,
                  "Usage:\n"
                  "  %s inspect --boot-resource DECODED_BOOT [--tree CIFTREE] [--external-cif-dir DIR]\n"
                  "  %s inspect --boot-cif BOOT.CIF [--tree CIFTREE] [--external-cif-dir DIR]\n"
                  "  %s inspect-cif IMAGE.CIF\n",
                  program, program, program);
}

int main(int argc, char **argv)
{
    const char *boot_path = NULL;
    const char *tree_path = NULL;
    const char *external_directory = NULL;
    int boot_is_cif = 0;
    int index;

    if (argc == 3 && strcmp(argv[1], "inspect-cif") == 0) {
        return inspect_standalone_image(argv[2]);
    }
    if (argc < 4 || strcmp(argv[1], "inspect") != 0) {
        usage(argv[0]);
        return 2;
    }
    for (index = 2; index < argc; ++index) {
        if (strcmp(argv[index], "--boot-resource") == 0 ||
            strcmp(argv[index], "--boot-cif") == 0) {
            int is_cif = strcmp(argv[index], "--boot-cif") == 0;
            if (index + 1 >= argc || boot_path != NULL) {
                usage(argv[0]);
                return 2;
            }
            boot_path = argv[++index];
            boot_is_cif = is_cif;
        } else if (strcmp(argv[index], "--tree") == 0) {
            if (index + 1 >= argc || tree_path != NULL) {
                usage(argv[0]);
                return 2;
            }
            tree_path = argv[++index];
        } else if (strcmp(argv[index], "--external-cif-dir") == 0) {
            if (index + 1 >= argc || external_directory != NULL) {
                usage(argv[0]);
                return 2;
            }
            external_directory = argv[++index];
        } else {
            usage(argv[0]);
            return 2;
        }
    }
    if (boot_path == NULL) {
        usage(argv[0]);
        return 2;
    }
    return inspect_boot(boot_path, boot_is_cif, tree_path, external_directory);
}
