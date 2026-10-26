#define _POSIX_C_SOURCE 200809L
#include "game_resources.h"

#include <dirent.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct GameResources {
    char *directory;
    cif_tree *tree;
    cif_decode_context decoder;
    int external_enabled;
};

cif_decode_context *game_resources_decode_context(GameResources *resources)
{
    return resources != NULL ? &resources->decoder : NULL;
}

static void fail(char *error, size_t cap, const char *message)
{
    if (error && cap) (void)snprintf(error, cap, "%s", message);
}

static unsigned char upper(unsigned char ch)
{
    return ch >= 'a' && ch <= 'z' ? (unsigned char)(ch - 'a' + 'A') : ch;
}

static int normalize_name(const char *name, char output[33])
{
    size_t i;
    if (!name || !name[0]) return 0;
    for (i = 0; i < 33 && name[i]; ++i) {
        unsigned char ch = (unsigned char)name[i];
        if (ch >= 128 || ch < 32 || ch == '/' || ch == '\\') return 0;
        output[i] = (char)upper(ch);
    }
    if (i == 33) return 0;
    output[i] = 0;
    return 1;
}

static int equal_folded(const char *a, const char *b)
{
    for (;;) {
        if (upper((unsigned char)*a) != upper((unsigned char)*b)) return 0;
        if (!*a) return 1;
        ++a; ++b;
    }
}

static char *join_path(const char *directory, const char *name)
{
    size_t a = strlen(directory), b = strlen(name);
    char *path;
    if (a > SIZE_MAX - b - 2) return NULL;
    path = (char *)malloc(a + b + 2);
    if (path) {
        memcpy(path, directory, a);
        path[a] = '/';
        memcpy(path + a + 1, name, b + 1);
    }
    return path;
}

/* Match Windows case-insensitive names even on a case-sensitive Mac volume.
 * A duplicate case-folded name is rejected instead of choosing arbitrarily. */
static int external_path(GameResources *resources, const char *name, char **path,
                          char *error, size_t cap)
{
    char target[38];
    DIR *directory;
    struct dirent *entry;
    char *match = NULL;
    int result = 0;
    *path = NULL;
    if (!resources->external_enabled) return 0;
    (void)snprintf(target, sizeof(target), "%s.CIF", name);
    directory = opendir(resources->directory);
    if (!directory) { fail(error, cap, "cannot enumerate external CIF directory"); return -1; }
    errno = 0;
    while ((entry = readdir(directory)) != NULL) {
        if (!equal_folded(entry->d_name, target)) continue;
        if (match) {
            fail(error, cap, "ambiguous case-insensitive external CIF filename");
            result = -1;
            break;
        }
        match = join_path(resources->directory, entry->d_name);
        if (!match) { fail(error, cap, "cannot allocate external CIF path"); result = -1; break; }
    }
    if (errno != 0 && result != -1) {
        fail(error, cap, "failed while enumerating external CIF directory"); result = -1;
    }
    if (closedir(directory) != 0 && result != -1) {
        fail(error, cap, "failed while closing external CIF directory"); result = -1;
    }
    if (result == -1) free(match);
    else if (match) { *path = match; result = 1; }
    return result;
}

static uint32_t u32le(const uint8_t *b)
{
    return (uint32_t)b[0] | ((uint32_t)b[1] << 8) |
           ((uint32_t)b[2] << 16) | ((uint32_t)b[3] << 24);
}

static int read_file(const char *path, uint8_t **bytes, size_t *length,
                      char *error, size_t cap)
{
    FILE *file = fopen(path, "rb");
    long end;
    uint8_t *buffer;
    *bytes = NULL; *length = 0;
    if (!file) { fail(error, cap, "cannot open external CIF file"); return 0; }
    if (fseek(file, 0, SEEK_END) || (end = ftell(file)) < 81 ||
        (uintmax_t)end > CIF_MAX_ARCHIVE_SIZE || fseek(file, 0, SEEK_SET)) {
        (void)fclose(file); fail(error, cap, "invalid external CIF file length"); return 0;
    }
    buffer = (uint8_t *)malloc((size_t)end);
    if (!buffer) { (void)fclose(file); fail(error, cap, "cannot allocate external CIF buffer"); return 0; }
    if (fread(buffer, 1, (size_t)end, file) != (size_t)end || ferror(file)) {
        free(buffer); (void)fclose(file); fail(error, cap, "cannot read external CIF file"); return 0;
    }
    if (fclose(file)) { free(buffer); fail(error, cap, "cannot close external CIF file"); return 0; }
    *bytes = buffer; *length = (size_t)end;
    return 1;
}

GameResources *game_resources_open(const char *directory, int external_cif_checking,
                                   char *error, size_t cap)
{
    GameResources *resources;
    char *archive;
    if (error && cap) error[0] = 0;
    if (!directory || !directory[0]) { fail(error, cap, "Ciftree directory is missing"); return NULL; }
    resources = (GameResources *)calloc(1, sizeof(*resources));
    if (!resources) { fail(error, cap, "cannot allocate resource manager"); return NULL; }
    resources->directory = strdup(directory);
    archive = join_path(directory, "CIFTREE.DAT");
    if (!resources->directory || !archive) {
        free(archive); game_resources_close(resources); fail(error, cap, "cannot allocate archive path"); return NULL;
    }
    resources->tree = cif_tree_open_file(archive, error, cap);
    free(archive);
    if (!resources->tree) { game_resources_close(resources); return NULL; }
    resources->external_enabled = external_cif_checking != 0;
    cif_decode_context_init(&resources->decoder);
    return resources;
}

void game_resources_close(GameResources *resources)
{
    if (resources) { cif_tree_close(resources->tree); free(resources->directory); free(resources); }
}

void game_resource_bytes_destroy(GameResourceBytes *bytes)
{
    if (bytes) { free(bytes->bytes); memset(bytes, 0, sizeof(*bytes)); }
}

int game_resources_load_bytes(GameResources *resources, const char *name,
                               GameResourceBytes *output, char *error, size_t cap)
{
    char normalized[33], *external = NULL;
    int found, status;
    size_t required, written = 0, consumed = 0;
    uint8_t *file_bytes = NULL;
    size_t file_size = 0, index;
    cif_entry_info entry;
    if (error && cap) error[0] = 0;
    if (!resources || !output || output->bytes || !normalize_name(name, normalized)) {
        fail(error, cap, "invalid resource arguments or nonempty output"); return 0;
    }
    found = external_path(resources, normalized, &external, error, cap);
    if (found < 0) return 0;
    if (found) {
        status = read_file(external, &file_bytes, &file_size, error, cap);
        free(external);
        if (!status) return 0;
        required = u32le(file_bytes + 68);
        if (required > CIF_MAX_RESOURCE_SIZE || (file_bytes[80] != 2 && file_bytes[80] != 3)) {
            free(file_bytes); fail(error, cap, "invalid external CIF payload size or kind"); return 0;
        }
        output->bytes = (uint8_t *)malloc(required ? required : 1);
        if (!output->bytes) { free(file_bytes); fail(error, cap, "cannot allocate resource output"); return 0; }
        status = cif_decode_cif_memory(&resources->decoder, file_bytes, file_size,
            output->bytes, required, &required, &written, &consumed);
        output->type = file_bytes[80];
        output->source = GAME_RESOURCE_EXTERNAL_CIF;
        free(file_bytes);
    } else {
        status = cif_tree_find(resources->tree, normalized, &index);
        if (status != CIF_OK || cif_tree_entry_at(resources->tree, index, &entry) != CIF_OK || entry.type == 4) {
            fail(error, cap, "resource is absent from archive or is a marker"); return 0;
        }
        required = entry.output_size;
        output->bytes = (uint8_t *)malloc(required ? required : 1);
        if (!output->bytes) { fail(error, cap, "cannot allocate resource output"); return 0; }
        status = cif_tree_extract(resources->tree, index, &resources->decoder,
            output->bytes, required, &written, &consumed);
        output->type = entry.type;
        output->source = GAME_RESOURCE_ARCHIVE;
    }
    if (status != CIF_OK || written != required) {
        game_resource_bytes_destroy(output); fail(error, cap, "resource decoding failed"); return 0;
    }
    output->length = written;
    return 1;
}

int game_resources_load_image(GameResources *resources, const char *name,
                               cif_image *output, GameResourceSource *source,
                               char *error, size_t cap)
{
    char normalized[33], *external = NULL;
    int found, status;
    uint8_t *bytes = NULL;
    size_t length = 0, index;
    if (error && cap) error[0] = 0;
    if (!resources || !output || output->pixels || !normalize_name(name, normalized)) {
        fail(error, cap, "invalid image resource arguments or nonempty output"); return 0;
    }
    found = external_path(resources, normalized, &external, error, cap);
    if (found < 0) return 0;
    if (found) {
        status = read_file(external, &bytes, &length, error, cap);
        free(external);
        if (!status) return 0;
        status = cif_image_decode_cif_memory(bytes, length, &resources->decoder, output, error, cap);
        free(bytes);
        if (status != CIF_IMAGE_OK) return 0;
        memcpy(output->name, normalized, strlen(normalized) + 1);
        if (source) *source = GAME_RESOURCE_EXTERNAL_CIF;
    } else {
        if (cif_tree_find(resources->tree, normalized, &index) != CIF_OK) {
            fail(error, cap, "image resource is absent from archive"); return 0;
        }
        status = cif_image_decode_tree_entry(resources->tree, index, &resources->decoder, output, error, cap);
        if (status != CIF_IMAGE_OK) return 0;
        if (source) *source = GAME_RESOURCE_ARCHIVE;
    }
    return 1;
}
