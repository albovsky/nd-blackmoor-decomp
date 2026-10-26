#define _POSIX_C_SOURCE 200809L
#include "native_cel_resources.h"

#include <dirent.h>
#include <errno.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_SURFACES (CONVO3F_CEL_SLOTS * CONVO3F_CEL_SLOT_LAYERS)
#define MAX_SHEET_BYTES (CONVO3F_CEL_HEADER_BYTES + 32768u * CONVO3F_CEL_FRAME_STRIDE)

typedef struct CelTree {
    char name[33];
    cif_tree *tree;
    uint8_t kind;
    uint8_t transparency;
} CelTree;

typedef struct CelSurface {
    uint32_t handle;
    cif_image image;
} CelSurface;

struct NativeCelResources {
    GameResources *headers;
    cif_decode_context *decoder;
    char *directory;
    CelTree trees[NATIVE_CEL_MAX_TREES];
    size_t tree_count;
    GameResourceBytes header;
    char header_name[33];
    int header_borrowed;
    CelSurface surfaces[MAX_SURFACES];
    uint32_t next_handle;
};

static int fail(int status, char *error, size_t capacity, const char *message)
{
    if (error && capacity) (void)snprintf(error, capacity, "%s", message);
    return status;
}

static void clear_error(char *error, size_t capacity)
{
    if (error && capacity) error[0] = 0;
}

static unsigned char upper(unsigned char ch)
{
    return ch >= 'a' && ch <= 'z' ? (unsigned char)(ch - 'a' + 'A') : ch;
}

/* Same bounded printable-ASCII/no-separators policy as GameResources. */
static int normalize(const char *name, char out[33])
{
    size_t i;
    if (!name || !name[0]) return 0;
    for (i = 0; i < 33u && name[i]; ++i) {
        unsigned char ch = (unsigned char)name[i];
        if (ch < 32u || ch >= 128u || ch == '/' || ch == '\\') return 0;
        out[i] = (char)upper(ch);
    }
    if (i == 33u) return 0;
    out[i] = 0;
    return 1;
}

static int equal_folded(const char *a, const char *b)
{
    while (upper((unsigned char)*a) == upper((unsigned char)*b)) {
        if (!*a) return 1;
        ++a; ++b;
    }
    return 0;
}

static uint16_t u16(const uint8_t *p)
{
    return (uint16_t)((uint16_t)p[0] | ((uint16_t)p[1] << 8));
}

static int32_t s32(const uint8_t *p)
{
    uint32_t value = (uint32_t)p[0] | ((uint32_t)p[1] << 8) |
                     ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
    return value <= INT32_MAX ? (int32_t)value : (int32_t)((int64_t)value - INT64_C(4294967296));
}

static int layer_metadata(const cif_entry_info *entry, Convo3fCelLayer *layer,
    char *error, size_t capacity)
{
    const uint8_t *m = entry->metadata_41_80;
    uint16_t width = u16(m + 32), pitch = u16(m + 34), height = u16(m + 36);
    if (entry->type != 2u || m[38] != 16u || m[39] != 2u)
        return fail(NATIVE_CEL_ERR_UNSUPPORTED, error, capacity, "CAL requires type-2 compressed RGB555 images");
    if (!width || !height || (uint32_t)width * 2u != pitch ||
        (uint64_t)pitch * height != entry->output_size || pitch > INT16_MAX)
        return fail(NATIVE_CEL_ERR_FORMAT, error, capacity, "CAL image dimensions/pitch/output size disagree");
    memset(layer, 0, sizeof(*layer));
    for (size_t i = 0; i < 4u; ++i) {
        layer->src[i] = s32(m + i * 4u);
        layer->dst[i] = s32(m + 16u + i * 4u);
    }
    if (layer->src[0] < 0 || layer->src[1] < 0 ||
        layer->src[2] < layer->src[0] || layer->src[3] < layer->src[1] ||
        layer->src[2] >= width || layer->src[3] >= height ||
        layer->dst[2] < layer->dst[0] || layer->dst[3] < layer->dst[1])
        return fail(NATIVE_CEL_ERR_FORMAT, error, capacity, "CAL image rectangles are outside their source");
    layer->key_2f = (int16_t)pitch; /* 0x417d36 -> header+0x2f; source byte stride */
    return NATIVE_CEL_OK;
}

static char *archive_path(NativeCelResources *r, const char *name, int *status,
    char *error, size_t capacity)
{
    char target[38];
    char *match = NULL;
    DIR *directory = opendir(r->directory);
    struct dirent *entry;
    *status = NATIVE_CEL_OK;
    if (!directory) { *status = fail(NATIVE_CEL_ERR_IO, error, capacity, "cannot enumerate CAL directory"); return NULL; }
    (void)snprintf(target, sizeof(target), "%s.CAL", name);
    errno = 0;
    while ((entry = readdir(directory)) != NULL) {
        size_t a, b;
        if (!equal_folded(target, entry->d_name)) continue;
        if (match) {
            *status = fail(NATIVE_CEL_ERR_FORMAT, error, capacity, "ambiguous case-insensitive CAL filename");
            break;
        }
        a = strlen(r->directory); b = strlen(entry->d_name);
        if (a > SIZE_MAX - b - 2u || !(match = (char *)malloc(a + b + 2u))) {
            *status = fail(NATIVE_CEL_ERR_MEMORY, error, capacity, "cannot allocate CAL path"); break;
        }
        memcpy(match, r->directory, a); match[a] = '/';
        memcpy(match + a + 1u, entry->d_name, b + 1u);
    }
    if (errno && *status == NATIVE_CEL_OK)
        *status = fail(NATIVE_CEL_ERR_IO, error, capacity, "cannot read CAL directory");
    if (closedir(directory) && *status == NATIVE_CEL_OK)
        *status = fail(NATIVE_CEL_ERR_IO, error, capacity, "cannot close CAL directory");
    if (*status != NATIVE_CEL_OK) { free(match); return NULL; }
    if (!match) *status = fail(NATIVE_CEL_ERR_NOT_FOUND, error, capacity, "named CAL archive is absent");
    return match;
}

static int open_tree(NativeCelResources *r, const char *name, int16_t *index,
    char *error, size_t capacity)
{
    uint8_t header[32];
    int status;
    char *path;
    FILE *file;
    cif_tree *tree;
    if (native_cel_resources_tree_index(r, name, index) == NATIVE_CEL_OK) return NATIVE_CEL_OK;
    if (r->tree_count == NATIVE_CEL_MAX_TREES)
        return fail(NATIVE_CEL_ERR_BOUNDS, error, capacity, "CAL directory exceeds 30 trees");
    path = archive_path(r, name, &status, error, capacity);
    if (!path) return status;
    file = fopen(path, "rb");
    if (!file) { free(path); return fail(NATIVE_CEL_ERR_IO, error, capacity, "cannot open CAL header"); }
    status = fread(header, 1, sizeof(header), file) == sizeof(header) && !ferror(file);
    if (fclose(file)) status = 0;
    if (!status) { free(path); return fail(NATIVE_CEL_ERR_IO, error, capacity, "cannot read CAL header"); }
    if (header[30] > 3u || (header[31] != 1u && header[31] != 2u)) {
        free(path); return fail(NATIVE_CEL_ERR_UNSUPPORTED, error, capacity, "unsupported CAL kind/transparency");
    }
    tree = cif_tree_open_file(path, error, capacity);
    free(path);
    if (!tree) return NATIVE_CEL_ERR_FORMAT;
    CelTree *slot = &r->trees[r->tree_count];
    memcpy(slot->name, name, strlen(name) + 1u);
    slot->tree = tree; slot->kind = header[30]; slot->transparency = header[31];
    *index = (int16_t)r->tree_count++;
    return NATIVE_CEL_OK;
}

NativeCelResources *native_cel_resources_create(GameResources *headers,
    const char *directory, cif_decode_context *decoder, char *error, size_t capacity)
{
    NativeCelResources *r;
    clear_error(error, capacity);
    if (!headers || !directory || !directory[0] || !decoder) {
        fail(NATIVE_CEL_ERR_ARGUMENT, error, capacity, "header manager, directory and persistent decoder are required");
        return NULL;
    }
    r = (NativeCelResources *)calloc(1, sizeof(*r));
    if (!r || !(r->directory = strdup(directory))) {
        free(r); fail(NATIVE_CEL_ERR_MEMORY, error, capacity, "cannot allocate cel resource owner"); return NULL;
    }
    r->headers = headers; r->decoder = decoder; r->next_handle = NATIVE_CEL_SURFACE_FIRST;
    return r;
}

void native_cel_resources_destroy(NativeCelResources *r)
{
    if (!r) return;
    for (size_t i = 0; i < MAX_SURFACES; ++i) cif_image_destroy(&r->surfaces[i].image);
    for (size_t i = 0; i < r->tree_count; ++i) cif_tree_close(r->trees[i].tree);
    game_resource_bytes_destroy(&r->header);
    free(r->directory); free(r);
}

int native_cel_resources_reset(NativeCelResources *r, char *error, size_t capacity)
{
    clear_error(error, capacity);
    if (!r) return fail(NATIVE_CEL_ERR_ARGUMENT, error, capacity, "cel resource owner is required");
    if (r->header_borrowed) return fail(NATIVE_CEL_ERR_BUSY, error, capacity, "kernel still borrows cel header");
    for (size_t i = 0; i < MAX_SURFACES; ++i)
        if (r->surfaces[i].handle) return fail(NATIVE_CEL_ERR_BUSY, error, capacity, "kernel still owns cel layers");
    game_resource_bytes_destroy(&r->header); r->header_name[0] = 0;
    for (size_t i = 0; i < r->tree_count; ++i) cif_tree_close(r->trees[i].tree);
    memset(r->trees, 0, sizeof(r->trees)); r->tree_count = 0;
    return NATIVE_CEL_OK;
}

int native_cel_resources_preflight(NativeCelResources *r, const NativeCelRequest *request,
    char *error, size_t capacity)
{
    char header_name[33], names[CONVO3F_CEL_MAX_LAYERS][33];
    GameResourceBytes candidate = GAME_RESOURCE_BYTES_INIT;
    const uint8_t *bytes;
    size_t length, frame_count;
    uint16_t layers;
    int status = NATIVE_CEL_OK, reuse;
    clear_error(error, capacity);
    if (!r || !request || !normalize(request->header_name, header_name) ||
        request->first < 0 || request->last < request->first)
        return fail(NATIVE_CEL_ERR_ARGUMENT, error, capacity, "invalid cel request/name/frame range");
    reuse = r->header.bytes && !strcmp(header_name, r->header_name);
    if (!reuse && r->header_borrowed)
        return fail(NATIVE_CEL_ERR_BUSY, error, capacity, "cannot replace a borrowed cel header");
    if (!reuse && !game_resources_load_bytes(r->headers, header_name, &candidate, error, capacity))
        return NATIVE_CEL_ERR_NOT_FOUND;
    bytes = reuse ? r->header.bytes : candidate.bytes;
    length = reuse ? r->header.length : candidate.length;
    if (length < CONVO3F_CEL_HEADER_BYTES || length > MAX_SHEET_BYTES ||
        memcmp(bytes, "XSHEET WayneSikes\0\0\0", 20u) ||
        (length - CONVO3F_CEL_HEADER_BYTES) % CONVO3F_CEL_FRAME_STRIDE) {
        status = fail(NATIVE_CEL_ERR_FORMAT, error, capacity, "invalid XSHEET signature/record span"); goto done;
    }
    frame_count = (length - CONVO3F_CEL_HEADER_BYTES) / CONVO3F_CEL_FRAME_STRIDE;
    layers = u16(bytes + 0x24);
    if (!layers || layers > CONVO3F_CEL_MAX_LAYERS || (size_t)request->last >= frame_count) {
        status = fail(NATIVE_CEL_ERR_BOUNDS, error, capacity, "XSHEET layers/frame range outside kernel bounds"); goto done;
    }
    for (size_t l = 0; l < layers; ++l) {
        int16_t tree_id;
        if (!normalize(request->layer_names[l], names[l])) {
            status = fail(NATIVE_CEL_ERR_ARGUMENT, error, capacity, "invalid CAL layer name"); goto done;
        }
        status = open_tree(r, names[l], &tree_id, error, capacity);
        if (status != NATIVE_CEL_OK) goto done;
        for (size_t f = (size_t)request->first; f <= (size_t)request->last; ++f) {
            char frame_name[33];
            size_t entry_index;
            cif_entry_info entry;
            Convo3fCelLayer metadata;
            const uint8_t *name = bytes + CONVO3F_CEL_HEADER_BYTES +
                f * CONVO3F_CEL_FRAME_STRIDE + l * 33u;
            if (!normalize((const char *)name, frame_name) ||
                cif_tree_find(r->trees[tree_id].tree, frame_name, &entry_index) != CIF_OK ||
                cif_tree_entry_at(r->trees[tree_id].tree, entry_index, &entry) != CIF_OK) {
                status = fail(NATIVE_CEL_ERR_NOT_FOUND, error, capacity, "XSHEET frame name is absent from its CAL"); goto done;
            }
            status = layer_metadata(&entry, &metadata, error, capacity);
            if (status != NATIVE_CEL_OK) goto done;
        }
    }
    if (!reuse) {
        game_resource_bytes_destroy(&r->header); r->header = candidate;
        memset(&candidate, 0, sizeof(candidate));
        memcpy(r->header_name, header_name, strlen(header_name) + 1u);
    }
done:
    game_resource_bytes_destroy(&candidate);
    return status;
}

int native_cel_resources_load_header(NativeCelResources *r, const char *name,
    const uint8_t **bytes, size_t *length, char *error, size_t capacity)
{
    char normalized[33];
    clear_error(error, capacity);
    if (bytes) *bytes = NULL;
    if (length) *length = 0;
    if (!r || !bytes || !length || !normalize(name, normalized))
        return fail(NATIVE_CEL_ERR_ARGUMENT, error, capacity, "invalid cel header arguments");
    if (!r->header.bytes || strcmp(normalized, r->header_name))
        return fail(NATIVE_CEL_ERR_STATE, error, capacity, "cel header must pass preflight first");
    r->header_borrowed = 1; *bytes = r->header.bytes; *length = r->header.length;
    return NATIVE_CEL_OK;
}

int native_cel_resources_release_header(NativeCelResources *r)
{
    if (!r) return NATIVE_CEL_ERR_ARGUMENT;
    game_resource_bytes_destroy(&r->header); r->header_name[0] = 0; r->header_borrowed = 0;
    return NATIVE_CEL_OK;
}

int native_cel_resources_tree_index(const NativeCelResources *r, const char *name, int16_t *index)
{
    char normalized[33];
    if (!r || !index || !normalize(name, normalized)) return NATIVE_CEL_ERR_ARGUMENT;
    for (size_t i = 0; i < r->tree_count; ++i)
        if (!strcmp(normalized, r->trees[i].name)) { *index = (int16_t)i; return NATIVE_CEL_OK; }
    *index = -1; return NATIVE_CEL_ERR_NOT_FOUND;
}

int native_cel_resources_tree_info(const NativeCelResources *r, int16_t index,
    uint8_t *kind, uint8_t *transparency)
{
    if (!r || !kind || !transparency) return NATIVE_CEL_ERR_ARGUMENT;
    if (index < 0 || (size_t)index >= r->tree_count) return NATIVE_CEL_ERR_BOUNDS;
    *kind = r->trees[index].kind; *transparency = r->trees[index].transparency;
    return NATIVE_CEL_OK;
}

int native_cel_resources_load_layer(NativeCelResources *r, int16_t tree_id,
    const char *name, Convo3fCelLayer *layer, char *error, size_t capacity)
{
    char normalized[33];
    size_t index, slot;
    cif_entry_info entry;
    Convo3fCelLayer result;
    cif_image image = CIF_IMAGE_INIT;
    int status;
    clear_error(error, capacity);
    if (!r || !layer || layer->loaded || layer->surface || !normalize(name, normalized))
        return fail(NATIVE_CEL_ERR_ARGUMENT, error, capacity, "invalid CAL layer arguments or nonempty output");
    if (tree_id < 0 || (size_t)tree_id >= r->tree_count)
        return fail(NATIVE_CEL_ERR_BOUNDS, error, capacity, "CAL tree ID is out of range");
    for (slot = 0; slot < MAX_SURFACES && r->surfaces[slot].handle; ++slot) { }
    if (slot == MAX_SURFACES || r->next_handle > NATIVE_CEL_SURFACE_LAST)
        return fail(NATIVE_CEL_ERR_BOUNDS, error, capacity, "cel surface handle capacity exhausted");
    if (cif_tree_find(r->trees[tree_id].tree, normalized, &index) != CIF_OK ||
        cif_tree_entry_at(r->trees[tree_id].tree, index, &entry) != CIF_OK)
        return fail(NATIVE_CEL_ERR_NOT_FOUND, error, capacity, "CAL layer image is absent");
    status = layer_metadata(&entry, &result, error, capacity);
    if (status != NATIVE_CEL_OK) return status;
    if (cif_image_decode_tree_entry(r->trees[tree_id].tree, index, r->decoder,
        &image, error, capacity) != CIF_IMAGE_OK) return NATIVE_CEL_ERR_FORMAT;
    result.loaded = 1u; result.surface = r->next_handle++;
    r->surfaces[slot].handle = result.surface; r->surfaces[slot].image = image;
    *layer = result;
    return NATIVE_CEL_OK;
}

int native_cel_resources_free_layer(NativeCelResources *r, uint32_t surface)
{
    if (!r) return NATIVE_CEL_ERR_ARGUMENT;
    if (!surface) return NATIVE_CEL_OK;
    if (surface < NATIVE_CEL_SURFACE_FIRST || surface > NATIVE_CEL_SURFACE_LAST) return NATIVE_CEL_ERR_ARGUMENT;
    for (size_t i = 0; i < MAX_SURFACES; ++i) if (r->surfaces[i].handle == surface) {
        cif_image_destroy(&r->surfaces[i].image); r->surfaces[i].handle = 0; break;
    }
    return NATIVE_CEL_OK;
}

const cif_image *native_cel_resources_image(const NativeCelResources *r, uint32_t surface)
{
    if (!r || !surface) return NULL;
    for (size_t i = 0; i < MAX_SURFACES; ++i)
        if (r->surfaces[i].handle == surface) return &r->surfaces[i].image;
    return NULL;
}

void native_cel_resources_stats(const NativeCelResources *r, NativeCelStats *stats)
{
    if (!stats) return;
    memset(stats, 0, sizeof(*stats));
    if (!r) return;
    stats->trees = r->tree_count; stats->headers = r->header.bytes != NULL;
    stats->header_bytes = r->header.length;
    for (size_t i = 0; i < MAX_SURFACES; ++i) if (r->surfaces[i].handle) {
        ++stats->layers; stats->layer_bytes += r->surfaces[i].image.byte_count;
    }
}
