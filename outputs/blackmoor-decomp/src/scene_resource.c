#include "scene_resource.h"

#include "hiff.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SCENE_TSUM_BYTES 126u
#define SCENE_ACTION_HEADER_BYTES 50u

typedef struct scene_action {
    SceneActionInfo info;
} SceneAction;

struct SceneResource {
    Hiff *hiff;
    SceneResourceSummary summary;
    SceneAction *actions;
};

static void set_error(char *error, size_t capacity, const char *message)
{
    if (error != NULL && capacity != 0u) {
        (void)snprintf(error, capacity, "%s", message);
    }
}

static uint16_t read_u16le(const uint8_t *bytes)
{
    return (uint16_t)((uint16_t)bytes[0] | ((uint16_t)bytes[1] << 8));
}

static int16_t read_i16le(const uint8_t *bytes)
{
    uint16_t value = read_u16le(bytes);
    int32_t signed_value = value < 0x8000u ? (int32_t)value : (int32_t)value - 0x10000;
    return (int16_t)signed_value;
}

static int copy_fixed_string(char *output, size_t output_capacity,
                             const uint8_t *input, size_t field_length)
{
    const uint8_t *terminator;
    size_t string_length;

    if (output == NULL || input == NULL || output_capacity == 0u) {
        return 0;
    }
    terminator = (const uint8_t *)memchr(input, 0, field_length);
    if (terminator == NULL) {
        return 0;
    }
    string_length = (size_t)(terminator - input);
    if (string_length >= output_capacity) {
        return 0;
    }
    memcpy(output, input, string_length);
    output[string_length] = '\0';
    return 1;
}

static int count_data_type(const Hiff *hiff, const char *type,
                           size_t *count, size_t *only_index)
{
    size_t index;
    size_t found = 0u;

    for (index = 0u; index < hiff_data_count(hiff); ++index) {
        HiffDataInfo data;
        if (hiff_data_at(hiff, index, &data) != HIFF_OK) {
            return 0;
        }
        if (strcmp(data.type, type) == 0) {
            ++found;
            if (only_index != NULL) {
                *only_index = index;
            }
        }
    }
    if (count != NULL) {
        *count = found;
    }
    return 1;
}

static int selected_chunk(Hiff *hiff, const uint8_t **bytes, size_t *length,
                          HiffSelectionInfo *selection)
{
    return hiff_get_selected_chunk(hiff, bytes, length, selection) == HIFF_OK;
}

static int copy_summary(SceneResource *scene, const uint8_t *payload, size_t length)
{
    if (length < SCENE_TSUM_BYTES ||
        !copy_fixed_string(scene->summary.title, sizeof(scene->summary.title),
                           payload, SCENE_RESOURCE_TITLE_BYTES) ||
        !copy_fixed_string(scene->summary.background, sizeof(scene->summary.background),
                           payload + 50u, SCENE_RESOURCE_STEM_BYTES) ||
        !copy_fixed_string(scene->summary.audio, sizeof(scene->summary.audio),
                           payload + 83u, SCENE_RESOURCE_STEM_BYTES)) {
        return 0;
    }
    memcpy(scene->summary.raw_tail, payload + 116u,
           SCENE_RESOURCE_TSUM_TAIL_BYTES);
    return 1;
}

/* Return the body size only for layouts recovered from the original loader.
 * Unknown types deliberately remain wholly opaque, including any bytes that
 * could otherwise be mistaken for dependency records. */
static int known_body_length(uint8_t type, const uint8_t *body, size_t length,
                             size_t *body_length, SceneActionPayloadKind *kind)
{
    size_t fixed_length;

    switch (type) {
    case 0x0a: fixed_length = 20u; break; /* AT_SCENE_CHANGE */
    case 0x0b: fixed_length = 24u; break; /* loader advances source by 0x18 */
    case 0x15: fixed_length = 20u; break; /* original decoder consumes 20 bytes */
    case 0x1d: fixed_length = 8u;  break; /* AT_CONTROL */
    case 0x4d: fixed_length = 4u;  break; /* AT_SET_VALUE */
    case 0x37: fixed_length = 69u; break; /* 0x4895cc consumes the 69-byte static overlay prefix */
    case 0x28: fixed_length = 21u; break; /* CSpecialEffect consumes the 21-byte payload */
    case 0x61: fixed_length = 8u;  break; /* AT_EVENT_FLAGS variant */
    case 0x64: fixed_length = 5u;  break; /* constructor 0x40b34a copies exactly five bytes */
    case 0x6b: fixed_length = 40u; break; /* AT_EVENTFLAGS */
    case 0x51: {
        int16_t selector;
        if (length < 12u) {
            return -1;
        }
        selector = read_i16le(body + 10u);
        if (selector == -1) {
            *body_length = 45u; /* loader copies the 33-byte AUTOTEXT key */
        } else if (selector >= 0 && selector <= 9999) {
            *body_length = 12u + (size_t)selector;
        } else {
            return -1;
        }
        *kind = SCENE_ACTION_PAYLOAD_VARIABLE;
        return 1;
    }
    case 0x71: fixed_length = 6u;  break; /* AT_DIFFICULTY_LEVEL */
    case 0x82: fixed_length = 41u; break; /* AT_CELLPHONE_NUMBER */
    case 0x4f: fixed_length = 10u; break; /* 0x44b1b4 advances source by 10 */
    case 0x47: fixed_length = 39u; break; /* 0x411a22 advances source by 0x27 */
    case 0x78: fixed_length = 6u;  break; /* 0x4e9c2f advances source by 6 */
    case 0x95: fixed_length = 3u;  break; /* loader advances source by 3 */
    case 0xd9: fixed_length = 35u; break; /* 0x47d682 advances source by 0x23 */
    case 0x62: {
        int16_t count;
        size_t typed_length;

        /* The constructor reads a signed short at +10 and narrows its
         * 12 + count*18 result to signed short before copying. Validate the
         * complete 12-byte prefix before the read, reject negative/unrepresentable
         * counts, then let parse_action bound the typed span against this row. */
        if (length < 12u) {
            return -1;
        }
        count = read_i16le(body + 10u);
        if (count < 0) {
            return -1;
        }
        typed_length = 12u + (size_t)count * 18u;
        if (typed_length > (size_t)INT16_MAX) {
            return -1;
        }
        *body_length = typed_length;
        *kind = SCENE_ACTION_PAYLOAD_VARIABLE;
        return 1;
    }
    case 0x9f: {
        uint16_t selector;
        if (length < 48u) {
            return -1;
        }
        selector = read_u16le(body + 46u);
        if (selector == UINT16_MAX) {
            /* Auto-text selector: original source cursor advances 0x51. */
            *body_length = 0x51u;
        } else {
            /* Numeric selector at +0x2e; loader rejects values above 9999. */
            if (selector > 9999u) {
                return -1;
            }
            *body_length = (size_t)selector + 0x30u;
        }
        *kind = SCENE_ACTION_PAYLOAD_VARIABLE;
        return 1;
    }
    case 0x6a: {
        uint16_t count;
        if (length < 42u) {
            return -1;
        }
        count = read_u16le(body + 40u);
        /* Original arithmetic uses a signed 16-bit count; reject negative
         * values and overflow before applying its 42 + count * 18 layout. */
        if (count > INT16_MAX || (size_t)count > (SIZE_MAX - 42u) / 18u) {
            return -1;
        }
        *body_length = 42u + (size_t)count * 18u;
        *kind = SCENE_ACTION_PAYLOAD_HOTSPOT_ARRAY;
        return 1;
    }
    default:
        return 0;
    }
    *body_length = fixed_length;
    *kind = SCENE_ACTION_PAYLOAD_FIXED;
    return 1;
}

static int parse_action(SceneAction *action, const uint8_t *payload, size_t length)
{
    size_t typed_length;
    size_t remaining;
    SceneActionPayloadKind kind = SCENE_ACTION_PAYLOAD_OPAQUE;

    if (length < SCENE_ACTION_HEADER_BYTES ||
        !copy_fixed_string(action->info.description,
                           sizeof(action->info.description), payload,
                           SCENE_RESOURCE_ACTION_NAME_BYTES)) {
        return 0;
    }
    action->info.type = payload[48u];
    action->info.subtype = payload[49u];
    action->info.raw_body = payload + SCENE_ACTION_HEADER_BYTES;
    action->info.raw_body_length = length - SCENE_ACTION_HEADER_BYTES;
    action->info.typed_body = NULL;
    action->info.typed_body_length = 0u;
    action->info.dependency_records = NULL;
    action->info.dependency_count = 0u;

    {
        int layout = known_body_length(action->info.type, action->info.raw_body,
                                       action->info.raw_body_length,
                                       &typed_length, &kind);
        if (layout == 0) {
            return 1;
        }
        if (layout < 0) {
            return 0;
        }
    }
    if (typed_length > action->info.raw_body_length) {
        return 0;
    }
    remaining = action->info.raw_body_length - typed_length;
    if (remaining % SCENE_RESOURCE_DEPENDENCY_BYTES != 0u) {
        return 0;
    }
    action->info.payload_kind = kind;
    action->info.typed_body = action->info.raw_body;
    action->info.typed_body_length = typed_length;
    action->info.dependency_records = action->info.raw_body + typed_length;
    action->info.dependency_count = remaining / SCENE_RESOURCE_DEPENDENCY_BYTES;
    return 1;
}

static int visit_chunks(Hiff *hiff, const char *id, size_t data_index,
                        size_t *matches, SceneResource *scene,
                        int is_summary)
{
    const uint8_t *payload;
    size_t length;
    HiffSelectionInfo selection;
    size_t found = 0u;
    size_t action_index = 0u;
    int status = hiff_select_first(hiff, id);

    while (status == HIFF_OK) {
        if (!selected_chunk(hiff, &payload, &length, &selection)) {
            return 0;
        }
        if (selection.data_index == data_index) {
            if (is_summary) {
                if (!copy_summary(scene, payload, length)) {
                    return 0;
                }
            } else if (scene != NULL) {
                if (scene->actions == NULL ||
                    action_index >= scene->summary.action_count ||
                    !parse_action(&scene->actions[action_index], payload, length)) {
                    return 0;
                }
                ++action_index;
            }
            ++found;
        }
        status = hiff_select_next(hiff, id);
    }
    if (matches != NULL) {
        *matches = found;
    }
    return is_summary || scene == NULL || action_index == scene->summary.action_count;
}

SceneResource *scene_resource_open_memory(const void *bytes, size_t length,
                                          char *error, size_t error_capacity)
{
    SceneResource *scene;
    size_t scen_count = 0u;
    size_t scen_index = 0u;
    size_t tsum_count = 0u;
    size_t action_count = 0u;

    if (error != NULL && error_capacity != 0u) {
        error[0] = '\0';
    }
    if (bytes == NULL || length == 0u) {
        set_error(error, error_capacity, "scene resource input is empty");
        return NULL;
    }
    scene = (SceneResource *)calloc(1u, sizeof(*scene));
    if (scene == NULL) {
        set_error(error, error_capacity, "cannot allocate scene resource");
        return NULL;
    }
    scene->hiff = hiff_open_memory(bytes, length, error, error_capacity);
    if (scene->hiff == NULL) {
        free(scene);
        return NULL;
    }
    if (!count_data_type(scene->hiff, "SCEN", &scen_count, &scen_index) ||
        scen_count != 1u) {
        set_error(error, error_capacity, "scene resource must contain one SCEN DATA record");
        scene_resource_close(scene);
        return NULL;
    }
    if (!visit_chunks(scene->hiff, "TSUM", scen_index, &tsum_count, scene, 1) ||
        tsum_count != 1u) {
        set_error(error, error_capacity, "SCEN must contain one valid TSUM chunk");
        scene_resource_close(scene);
        return NULL;
    }
    if (!visit_chunks(scene->hiff, "ACT", scen_index, &action_count, NULL, 0) ||
        action_count > SCENE_RESOURCE_MAX_ACTIONS) {
        set_error(error, error_capacity, "SCEN action count exceeds parser limit");
        scene_resource_close(scene);
        return NULL;
    }
    scene->summary.action_count = action_count;
    if (action_count != 0u) {
        scene->actions = (SceneAction *)calloc(action_count, sizeof(*scene->actions));
        if (scene->actions == NULL) {
            set_error(error, error_capacity, "cannot allocate scene action table");
            scene_resource_close(scene);
            return NULL;
        }
        if (!visit_chunks(scene->hiff, "ACT", scen_index, NULL, scene, 0)) {
            set_error(error, error_capacity, "invalid ACT chunk or typed action boundary");
            scene_resource_close(scene);
            return NULL;
        }
    }
    return scene;
}

void scene_resource_close(SceneResource *scene)
{
    if (scene != NULL) {
        free(scene->actions);
        hiff_close(scene->hiff);
        free(scene);
    }
}

int scene_resource_get_summary(const SceneResource *scene,
                               SceneResourceSummary *summary)
{
    if (scene == NULL || summary == NULL) {
        return SCENE_RESOURCE_ERR_ARGUMENT;
    }
    *summary = scene->summary;
    return SCENE_RESOURCE_OK;
}

size_t scene_resource_action_count(const SceneResource *scene)
{
    return scene == NULL ? 0u : scene->summary.action_count;
}

int scene_resource_action_at(const SceneResource *scene, size_t index,
                             SceneActionInfo *info)
{
    if (scene == NULL || info == NULL) {
        return SCENE_RESOURCE_ERR_ARGUMENT;
    }
    if (index >= scene->summary.action_count) {
        return SCENE_RESOURCE_ERR_NOT_FOUND;
    }
    *info = scene->actions[index].info;
    return SCENE_RESOURCE_OK;
}

int scene_resource_dependency_at(const SceneResource *scene,
                                 size_t action_index,
                                 size_t dependency_index,
                                 SceneDependencyInfo *info)
{
    const SceneActionInfo *action;
    const uint8_t *bytes;
    size_t field_index;

    if (scene == NULL || info == NULL) {
        return SCENE_RESOURCE_ERR_ARGUMENT;
    }
    if (action_index >= scene->summary.action_count) {
        return SCENE_RESOURCE_ERR_NOT_FOUND;
    }
    action = &scene->actions[action_index].info;
    if (dependency_index >= action->dependency_count) {
        return SCENE_RESOURCE_ERR_NOT_FOUND;
    }
    bytes = action->dependency_records +
            dependency_index * SCENE_RESOURCE_DEPENDENCY_BYTES;
    for (field_index = 0u; field_index < 8u; ++field_index) {
        info->fields[field_index] = read_i16le(bytes + field_index * 2u);
    }
    info->opcode = read_u16le(bytes);
    /* The original reducer checks the fourth signed 16-bit word and treats
     * exactly one as an OR link. */
    info->or_after = info->fields[3];
    info->raw_bytes = bytes;
    return SCENE_RESOURCE_OK;
}

const char *scene_resource_status_string(int status)
{
    switch (status) {
    case SCENE_RESOURCE_OK: return "ok";
    case SCENE_RESOURCE_ERR_ARGUMENT: return "invalid argument";
    case SCENE_RESOURCE_ERR_MEMORY: return "out of memory";
    case SCENE_RESOURCE_ERR_FORMAT: return "invalid scene resource format";
    case SCENE_RESOURCE_ERR_BOUNDS: return "scene resource field is out of bounds";
    case SCENE_RESOURCE_ERR_LIMIT: return "scene resource limit exceeded";
    case SCENE_RESOURCE_ERR_NOT_FOUND: return "item not found";
    default: return "unknown scene resource status";
    }
}
