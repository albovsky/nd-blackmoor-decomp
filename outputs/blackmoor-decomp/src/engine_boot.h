#ifndef ENGINE_BOOT_H
#define ENGINE_BOOT_H

#include "hiff.h"

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ENGINE_BOOT_BSUM_SIZE 402u
#define ENGINE_BOOT_IMAGE_DESCRIPTOR_SIZE 37u
#define ENGINE_BOOT_PLGO_SOUND_NAME_OFFSET 111u
#define ENGINE_BOOT_PHONE_ROW_SIZE 41u

typedef enum engine_boot_status {
    ENGINE_BOOT_OK = 0,
    ENGINE_BOOT_ERR_ARGUMENT = 1,
    ENGINE_BOOT_ERR_MEMORY = 2,
    ENGINE_BOOT_ERR_FORMAT = 3,
    ENGINE_BOOT_ERR_BOUNDS = 4,
    ENGINE_BOOT_ERR_NOT_FOUND = 5,
    ENGINE_BOOT_ERR_LIMIT = 6
} engine_boot_status;

typedef struct EngineBoot EngineBoot;

typedef struct engine_boot_summary {
    uint8_t logo_count;
    uint8_t object_count;
    int16_t font_count;
    int16_t initial_scene;
    size_t bsum_chunk_index;
    size_t bsum_payload_offset;
    uint8_t bsum_raw[ENGINE_BOOT_BSUM_SIZE];
} EngineBootSummary;

/* BOOT inputs consumed by the original full New Game initializer. Coordinate
 * words are preserved as opaque signed words; their axis names and units are
 * not established by the recovered copy path. */
typedef struct engine_boot_startup_settings {
    int16_t ordinary_initial_scene;
    int16_t ordinary_coordinate_word_a;
    int16_t ordinary_coordinate_word_b;
    int16_t alternate_initial_scene;
    int16_t alternate_coordinate_word_a;
    int16_t alternate_coordinate_word_b;
    int16_t initial_hour;
    int16_t initial_minute;
    int16_t first_day_event_hour;
    int16_t first_day_event_flag_id;
    int16_t clock_update_interval_ms;
} EngineBootStartupSettings;

typedef struct engine_boot_image_descriptor {
    char filename[34];
    uint16_t nominal_width;
    uint16_t nominal_height;
    size_t source_chunk_index;
    size_t payload_offset;
    uint8_t raw[ENGINE_BOOT_IMAGE_DESCRIPTOR_SIZE];
} EngineBootImageDescriptor;

typedef struct engine_boot_menu_info {
    HiffChunkInfo chunk;
    size_t chunk_index;
    const uint8_t *raw;
    size_t raw_size;
    char first_image_filename[34];
    uint16_t first_image_nominal_width;
    uint16_t first_image_nominal_height;
} EngineBootMenuInfo;

typedef struct engine_boot_plgo_info {
    HiffChunkInfo chunk;
    size_t chunk_index;
    const uint8_t *raw;
    size_t raw_size;
    char filename[34];
    uint8_t byte_at_66;
    char sound_name_at_111[10];
} EngineBootPlgoInfo;

/* The decoded boot buffer and its Hiff index are both owned until close. */
EngineBoot *engine_boot_open_memory(const void *decoded_boot,
                                   size_t length,
                                   char *error,
                                   size_t error_capacity);
void engine_boot_close(EngineBoot *boot);

int engine_boot_get_summary(const EngineBoot *boot, EngineBootSummary *summary);
int engine_boot_get_startup_settings(const EngineBoot *boot,
                                    EngineBootStartupSettings *settings);
/* UICL rows are returned in source order as the original 41 raw bytes. The
 * UICL payload bound is checked before access; it is not a global table
 * capacity declaration. */
int engine_boot_get_phone_count(const EngineBoot *boot, size_t *count);
int engine_boot_phone_row_at(const EngineBoot *boot,
                             size_t index,
                             uint8_t raw_row[ENGINE_BOOT_PHONE_ROW_SIZE]);
size_t engine_boot_chunk_count(const EngineBoot *boot);
int engine_boot_chunk_at(const EngineBoot *boot,
                         size_t index,
                         HiffChunkInfo *info,
                         const uint8_t **payload,
                         size_t *payload_size);
size_t engine_boot_logo_count(const EngineBoot *boot);
size_t engine_boot_object_count(const EngineBoot *boot);
int engine_boot_logo_at(const EngineBoot *boot,
                        size_t index,
                        EngineBootImageDescriptor *descriptor);
int engine_boot_object_at(const EngineBoot *boot,
                          size_t index,
                          EngineBootImageDescriptor *descriptor);
int engine_boot_get_menu(const EngineBoot *boot, EngineBootMenuInfo *info);
int engine_boot_get_plgo(const EngineBoot *boot, EngineBootPlgoInfo *info);

const char *engine_boot_status_string(int status);

#ifdef __cplusplus
}
#endif

#endif
