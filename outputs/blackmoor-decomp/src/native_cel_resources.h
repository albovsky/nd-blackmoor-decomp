#ifndef BLACKMOOR_NATIVE_CEL_RESOURCES_H
#define BLACKMOOR_NATIVE_CEL_RESOURCES_H

#include "action_family_3f_runtime.h"
#include "game_resources.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Native ownership adapter for 0x418e52 / 0x41a216 / 0x417b04. This supplies
 * resources only; the existing cel kernel owns reader/cache/frame decisions.
 * Single-threaded: finish a reader/render pass before changing ownership. */
#define NATIVE_CEL_SURFACE_FIRST UINT32_C(0xce000001)
#define NATIVE_CEL_SURFACE_LAST UINT32_C(0xceffffff)
#define NATIVE_CEL_MAX_TREES 30u

typedef enum NativeCelStatus {
    NATIVE_CEL_OK = 0,
    NATIVE_CEL_ERR_ARGUMENT,
    NATIVE_CEL_ERR_MEMORY,
    NATIVE_CEL_ERR_IO,
    NATIVE_CEL_ERR_FORMAT,
    NATIVE_CEL_ERR_UNSUPPORTED,
    NATIVE_CEL_ERR_NOT_FOUND,
    NATIVE_CEL_ERR_BOUNDS,
    NATIVE_CEL_ERR_BUSY,
    NATIVE_CEL_ERR_STATE
} NativeCelStatus;

typedef struct NativeCelRequest {
    char header_name[33];
    char layer_names[CONVO3F_CEL_MAX_LAYERS][33];
    int16_t first;
    int16_t last;
} NativeCelRequest;

typedef struct NativeCelStats {
    size_t trees;
    size_t headers;
    size_t header_bytes;
    size_t layers;
    size_t layer_bytes;
} NativeCelStats;

typedef struct NativeCelResources NativeCelResources;

/* Both pointers are borrowed and must outlive this owner. Production passes
 * the same persistent decoder used by GameResources, preserving the original
 * dictionary across header and layer loads. Neither reset nor destroy resets
 * or frees that context. The directory is copied. */
NativeCelResources *native_cel_resources_create(GameResources *headers,
    const char *ciftree_directory, cif_decode_context *shared_decoder,
    char *error, size_t capacity);
/* The caller must run kernel release-all before destroy. */
void native_cel_resources_destroy(NativeCelResources *);
/* Refuses live layer handles or a header borrowed by the kernel. A prepared,
 * unborrowed header is releasable. Tree IDs remain stable until reset; surface
 * handles are never reused within this owner's lifetime, even after reset. */
int native_cel_resources_reset(NativeCelResources *, char *error, size_t capacity);

/* Before phase-0 effects: load through the configured GameResources policy,
 * validate the XSHEET range and all active referenced names/image metadata,
 * and open the case-insensitively selected CAL trees. No image is decoded.
 * A successful prepared header stays owned for phase-0 load_header of the same
 * name, which borrows those identical bytes without a second decode. Opening
 * a new header while another is borrowed is refused. Failed preflight never
 * replaces a held header; successfully opened trees may remain cached. */
int native_cel_resources_preflight(NativeCelResources *, const NativeCelRequest *,
    char *error, size_t capacity);
int native_cel_resources_load_header(NativeCelResources *, const char *name,
    const uint8_t **bytes, size_t *length, char *error, size_t capacity);
int native_cel_resources_release_header(NativeCelResources *);
int native_cel_resources_tree_index(const NativeCelResources *, const char *name,
    int16_t *index);
int native_cel_resources_tree_info(const NativeCelResources *, int16_t index,
    uint8_t *kind, uint8_t *transparency);

/* Output must be empty. A successful layer owns a separate image until free.
 * key_2f is the original source BYTE PITCH, not a transparent color key.
 * Rectangles are exact signed inclusive metadata; no VIEW origin is added.
 * Pixels stay raw RGB555. The app handles display-format conversion/drawing. */
int native_cel_resources_load_layer(NativeCelResources *, int16_t tree_index,
    const char *name, Convo3fCelLayer *layer, char *error, size_t capacity);
int native_cel_resources_free_layer(NativeCelResources *, uint32_t surface);
/* Borrowed until the matching free/reset/destroy; never destroy this image. */
const cif_image *native_cel_resources_image(const NativeCelResources *, uint32_t surface);
void native_cel_resources_stats(const NativeCelResources *, NativeCelStats *);

#ifdef __cplusplus
}
#endif
#endif
