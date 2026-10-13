#ifndef BLACKMOOR_SCENE_RESOURCE_H
#define BLACKMOOR_SCENE_RESOURCE_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define SCENE_RESOURCE_TITLE_BYTES 50u
#define SCENE_RESOURCE_STEM_BYTES 33u
#define SCENE_RESOURCE_TSUM_TAIL_BYTES 10u
#define SCENE_RESOURCE_ACTION_NAME_BYTES 48u
#define SCENE_RESOURCE_DEPENDENCY_BYTES 16u
/* The action table cannot exceed HIFF's validated 999-chunk bound. */
#define SCENE_RESOURCE_MAX_ACTIONS 999u

typedef struct SceneResource SceneResource;

typedef enum scene_resource_status {
    SCENE_RESOURCE_OK = 0,
    SCENE_RESOURCE_ERR_ARGUMENT = 1,
    SCENE_RESOURCE_ERR_MEMORY = 2,
    SCENE_RESOURCE_ERR_FORMAT = 3,
    SCENE_RESOURCE_ERR_BOUNDS = 4,
    SCENE_RESOURCE_ERR_LIMIT = 5,
    SCENE_RESOURCE_ERR_NOT_FOUND = 6
} scene_resource_status;

typedef struct scene_resource_summary {
    char title[SCENE_RESOURCE_TITLE_BYTES + 1u];
    char background[SCENE_RESOURCE_STEM_BYTES + 1u];
    char audio[SCENE_RESOURCE_STEM_BYTES + 1u];
    /* TSUM bytes 116..125, retained verbatim until their fields are verified. */
    uint8_t raw_tail[SCENE_RESOURCE_TSUM_TAIL_BYTES];
    size_t action_count;
} SceneResourceSummary;

typedef enum scene_action_payload_kind {
    SCENE_ACTION_PAYLOAD_OPAQUE = 0,
    SCENE_ACTION_PAYLOAD_FIXED = 1,
    SCENE_ACTION_PAYLOAD_HOTSPOT_ARRAY = 2,
    SCENE_ACTION_PAYLOAD_VARIABLE = 3
} SceneActionPayloadKind;

typedef struct scene_action_info {
    char description[SCENE_RESOURCE_ACTION_NAME_BYTES + 1u];
    uint8_t type;
    uint8_t subtype;
    SceneActionPayloadKind payload_kind;
    /* Original action data bytes, after the 48-byte description and type pair. */
    const uint8_t *raw_body;
    size_t raw_body_length;
    /* For supported types, excludes the trailing dependency records. */
    const uint8_t *typed_body;
    size_t typed_body_length;
    /* Raw 16-byte dependency records; empty for unknown action formats. */
    const uint8_t *dependency_records;
    size_t dependency_count;
} SceneActionInfo;

typedef struct scene_dependency_info {
    uint16_t opcode;
    int16_t or_after;
    const uint8_t *raw_bytes;
    /* The original dependency loader reads eight signed 16-bit words. */
    int16_t fields[8];
} SceneDependencyInfo;

/* Parses one SCEN DATA record. Returned views remain valid until close. */
SceneResource *scene_resource_open_memory(const void *bytes,
                                          size_t length,
                                          char *error,
                                          size_t error_capacity);
void scene_resource_close(SceneResource *scene);

int scene_resource_get_summary(const SceneResource *scene,
                               SceneResourceSummary *summary);
size_t scene_resource_action_count(const SceneResource *scene);
int scene_resource_action_at(const SceneResource *scene,
                             size_t index,
                             SceneActionInfo *info);
int scene_resource_dependency_at(const SceneResource *scene,
                                 size_t action_index,
                                 size_t dependency_index,
                                 SceneDependencyInfo *info);

const char *scene_resource_status_string(int status);

#ifdef __cplusplus
}
#endif

#endif
