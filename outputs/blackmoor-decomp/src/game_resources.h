#ifndef BLACKMOOR_GAME_RESOURCES_H
#define BLACKMOOR_GAME_RESOURCES_H

#include "cif_image.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct GameResources GameResources;
typedef enum game_resource_source {
    GAME_RESOURCE_ARCHIVE = 0,
    GAME_RESOURCE_EXTERNAL_CIF = 1
} GameResourceSource;

typedef struct game_resource_bytes {
    uint8_t *bytes;
    size_t length;
    uint8_t type;
    GameResourceSource source;
} GameResourceBytes;

#define GAME_RESOURCE_BYTES_INIT { NULL, 0u, 0u, GAME_RESOURCE_ARCHIVE }

/* Recover CCif's external-CIF-before-tree lookup from 0x418e52/0x4181c6.
 * directory is the original Ciftree directory. external_cif_checking is the
 * original INI flag, supplied by the engine configuration reader. The supplied
 * GOG Game.ini enables it. One decoder context persists across all loads.
 */
GameResources *game_resources_open(const char *directory, int external_cif_checking,
                                   char *error, size_t error_capacity);
void game_resources_close(GameResources *resources);

/* Raw decoded payload, before renderer-specific image transformation. Outputs
 * must be initialized and empty. Caller owns returned bytes/image pixels. */
int game_resources_load_bytes(GameResources *resources, const char *name,
                               GameResourceBytes *output, char *error, size_t cap);
int game_resources_load_image(GameResources *resources, const char *name,
                               cif_image *output, GameResourceSource *source,
                               char *error, size_t cap);
void game_resource_bytes_destroy(GameResourceBytes *bytes);

#ifdef __cplusplus
}
#endif
#endif
