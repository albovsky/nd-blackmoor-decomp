#include "session_bindings_a36.h"

#include <stdlib.h>
#include <string.h>

#include "action_family_36.h"
#include "action_family_37.h"

struct SessionA36Binding {
    SessionA36Host host;
    Overlay36Manager manager;
    uint8_t **images; /* per action row; NULL for rows that are not raw 0x36 / 0x37 */
    uint8_t *raw_types; /* per action row: 0x36 or 0x37, 0 for none */
    size_t count;
    Overlay36World world;
    const char *failure;
};

SessionA36Binding *session_a36_create(const SessionA36Host *host)
{
    SessionA36Binding *b;
    if (host == NULL) {
        return NULL;
    }
    b = (SessionA36Binding *)calloc(1u, sizeof(*b));
    if (b != NULL) {
        b->host = *host;
        b->failure = "none";
        overlay36_manager_reset(&b->manager);
    }
    return b;
}

static void clear_rows(SessionA36Binding *b)
{
    size_t i;
    for (i = 0; i < b->count; ++i) {
        free(b->images[i]);
    }
    free(b->images);
    free(b->raw_types);
    b->images = NULL;
    b->raw_types = NULL;
    b->count = 0u;
}

int session_a36_build_image(uint8_t raw_type, const uint8_t *raw_body, size_t raw_body_length,
                            uint8_t image[OVERLAY36_IMAGE_BYTES])
{
    if (raw_body == NULL || image == NULL) {
        return OVERLAY36_ERR_ARGUMENT;
    }
    if (raw_type == SESSION_A36_TYPE) {
        /* The A-36.1 constructor (0x488e9c) leaves the bytes it does not write alone. */
        uint8_t zeros[ACTION_FAMILY_36_OBJECT_BYTES];
        ActionFamily36Constructed constructed;
        memset(zeros, 0, sizeof(zeros));
        if (action_family_36_construct(raw_body, raw_body_length, zeros, sizeof(zeros), 0u, 1u,
                                       &constructed) != ACTION_FAMILY_36_OK) {
            return OVERLAY36_ERR_BOUNDS;
        }
        memcpy(image, constructed.object_bytes, OVERLAY36_IMAGE_BYTES);
        return OVERLAY36_OK;
    }
    if (raw_type == SESSION_A37_TYPE) {
        /* 0x4895cc zeroes the 0xABA allocation, writes the 0x48945b defaults, then the
         * name, the two option words and the primary record from the 69-byte body. */
        ActionFamily37Constructed constructed;
        if (action_family_37_construct(raw_body, raw_body_length, 0u, 1u, &constructed) !=
            ACTION_FAMILY_37_OK) {
            return OVERLAY36_ERR_BOUNDS;
        }
        memcpy(image, constructed.object_bytes, OVERLAY36_IMAGE_BYTES);
        return OVERLAY36_OK;
    }
    return OVERLAY36_ERR_ARGUMENT;
}

void session_a36_destroy(SessionA36Binding *b)
{
    if (b != NULL) {
        clear_rows(b);
        free(b);
    }
}

int session_a36_begin_scene(SessionA36Binding *b, const SceneResource *scene)
{
    size_t i, count;
    uint8_t **images;
    uint8_t *raw_types;
    if (b == NULL || scene == NULL) {
        return OVERLAY36_ERR_ARGUMENT;
    }
    count = scene_resource_action_count(scene);
    images = (uint8_t **)calloc(count != 0u ? count : 1u, sizeof(*images));
    raw_types = (uint8_t *)calloc(count != 0u ? count : 1u, sizeof(*raw_types));
    if (images == NULL || raw_types == NULL) {
        free(images);
        free(raw_types);
        b->failure = "row allocation failed";
        return OVERLAY36_ERR_ARGUMENT;
    }
    for (i = 0; i < count; ++i) {
        SceneActionInfo info;
        if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) {
            b->failure = "overlay scene row unreadable";
            goto fail;
        }
        if (info.type != SESSION_A36_TYPE && info.type != SESSION_A37_TYPE) {
            continue; /* includes raw 0x38 (runtime type 0x36 too, out of scope) */
        }
        images[i] = (uint8_t *)malloc(OVERLAY36_IMAGE_BYTES);
        if (images[i] == NULL) {
            b->failure = "image allocation failed";
            goto fail;
        }
        /* The loader-time constructor of the row's raw type builds the image. */
        if (session_a36_build_image(info.type, info.raw_body, info.raw_body_length, images[i]) !=
            OVERLAY36_OK) {
            b->failure = info.type == SESSION_A37_TYPE ? "invalid raw-0x37 scene row"
                                                        : "invalid raw-0x36 scene row";
            goto fail;
        }
        raw_types[i] = info.type;
    }
    clear_rows(b);
    b->images = images;
    b->raw_types = raw_types;
    b->count = count;
    overlay36_manager_reset(&b->manager);
    b->failure = "none";
    return OVERLAY36_OK;
fail:
    for (i = 0; i < count; ++i) {
        free(images[i]);
    }
    free(images);
    free(raw_types);
    return OVERLAY36_ERR_BOUNDS;
}

static int16_t image_s16(const uint8_t *image, size_t offset)
{
    const uint16_t bits = (uint16_t)((uint16_t)image[offset] | ((uint16_t)image[offset + 1u] << 8));
    return bits <= (uint16_t)INT16_MAX ? (int16_t)bits
                                       : (int16_t)(-1 - (int32_t)(UINT16_MAX - bits));
}

static int32_t image_s32(const uint8_t *image, size_t offset)
{
    const uint32_t bits = (uint32_t)image[offset] | ((uint32_t)image[offset + 1u] << 8) |
                          ((uint32_t)image[offset + 2u] << 16) | ((uint32_t)image[offset + 3u] << 24);
    return bits <= (uint32_t)INT32_MAX ? (int32_t)bits : (int32_t)(-1 - (int32_t)(UINT32_MAX - bits));
}

static Overlay36Rows rows_of(const SessionA36Binding *b)
{
    Overlay36Rows rows;
    rows.images = (uint8_t *const *)b->images;
    rows.count = b->count;
    return rows;
}

static int load_world(SessionA36Binding *b)
{
    memset(&b->world, 0, sizeof(b->world));
    if (b->host.load_world == NULL ||
        b->host.load_world(b->host.kernel.context, &b->world) != 0) {
        b->failure = "world provider (event array, selector 0x5bb50b, held item)";
        return -1;
    }
    return 0;
}

int session_a36_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionA36Binding *b = (SessionA36Binding *)context;
    Overlay36Rows rows;
    Overlay36StepResult result;
    const uint8_t *image;
    int status;
    if (b == NULL || action == NULL || before == NULL || out == NULL ||
        (action->type != SESSION_A36_TYPE && action->type != SESSION_A37_TYPE) ||
        index >= b->count || b->images[index] == NULL || b->raw_types[index] != action->type) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    image = b->images[index];
    b->failure = "none";
    if (before->phase == 2u && image_s16(image, OV36_ACTION_25) == 1 &&
        b->host.transition == NULL) {
        b->failure = "scene-change transition provider (overlay finish option 0x25)";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    if (load_world(b) != 0) {
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    rows = rows_of(b);
    status = overlay36_step(&b->manager, &rows, (int32_t)index, before->phase, &b->world,
                            &b->host.kernel, &result, &b->failure);
    if (status == OVERLAY36_ERR_UNSUPPORTED) {
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    if (status != OVERLAY36_OK) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (b->host.store_world != NULL) {
        b->host.store_world(b->host.kernel.context, &b->world);
    }
    if (result.finished) {
        if (image_s16(image, OV36_ACTION_25) == 1) {
            /* The dispatcher's 0x0a arm shape: target word, three words, three
             * dwords (0x5bb57b, 0x5bb599/0x5bb595/0x5c39ff, 0x5bb59b/9f/a3). */
            SceneTransitionRequest request;
            memset(&request, 0, sizeof(request));
            request.target_scene = image_s16(image, OV36_XFER_3D);
            request.opaque_words[0] = image_s16(image, OV36_XFER_3F);
            request.opaque_words[1] = image_s16(image, OV36_XFER_41);
            request.opaque_words[2] = image_s16(image, OV36_XFER_43);
            request.opaque_dwords[0] = image_s32(image, OV36_XFER_45);
            request.opaque_dwords[1] = image_s32(image, OV36_XFER_49);
            request.opaque_dwords[2] = image_s32(image, OV36_XFER_4D);
            if (b->host.transition(b->host.kernel.context, &request) != 0) {
                b->failure = "scene-change request was refused";
                return SCENE_ACTION_HANDLER_ERROR;
            }
        }
        /* 0x42ba3a: the generic completion with phase := 0. */
        out->disposition = SCENE_ACTION_HANDLER_COMPLETED;
        out->phase = 0u;
    } else {
        out->disposition = SCENE_ACTION_HANDLER_PENDING;
        out->phase = result.phase_after;
    }
    return SCENE_ACTION_HANDLER_OK;
}

const char *session_a36_failure(const SessionA36Binding *b)
{
    return b == NULL ? "invalid binding" : b->failure;
}

int session_a36_priority_rows(SessionA36Binding *b, SessionInputHotspot *rows, size_t capacity,
                              size_t *count)
{
    Overlay36HotRect hot[OVERLAY36_LIST_LIMIT * 25];
    Overlay36Rows view;
    size_t found = 0u, i;
    int status;
    if (b == NULL || count == NULL || (capacity != 0u && rows == NULL)) {
        return OVERLAY36_ERR_ARGUMENT;
    }
    *count = 0u;
    if (b->manager.count == 0) {
        return OVERLAY36_OK;
    }
    if (load_world(b) != 0) {
        return OVERLAY36_ERR_UNSUPPORTED;
    }
    view = rows_of(b);
    status = overlay36_hot_rects(&b->manager, &view, b->world.selector, &b->host.kernel, hot,
                                 sizeof(hot) / sizeof(hot[0]), &found);
    if (status != OVERLAY36_OK) {
        b->failure = "overlay hot rectangles unavailable";
        return status;
    }
    if (found > capacity) {
        b->failure = "overlay hot rectangle capacity";
        return OVERLAY36_ERR_BOUNDS;
    }
    for (i = 0; i < found; ++i) {
        memset(&rows[i], 0, sizeof(rows[i]));
        rows[i].index = hot[i].row;
        rows[i].rectangle.left = hot[i].left;
        rows[i].rectangle.top = hot[i].top;
        rows[i].rectangle.right = hot[i].right;
        rows[i].rectangle.bottom = hot[i].bottom;
        rows[i].active = 1u;
    }
    *count = found;
    return OVERLAY36_OK;
}

int session_a36_hit_test(SessionA36Binding *b, int16_t x, int16_t y, int *hit, int32_t *row)
{
    Overlay36Rows view;
    int status;
    if (b == NULL) {
        return OVERLAY36_ERR_ARGUMENT;
    }
    if (load_world(b) != 0) {
        return OVERLAY36_ERR_UNSUPPORTED;
    }
    view = rows_of(b);
    status = overlay36_hit_test(&b->manager, &view, x, y, &b->world, &b->host.kernel, hit, row,
                                &b->failure);
    if (status == OVERLAY36_OK && b->host.store_world != NULL) {
        b->host.store_world(b->host.kernel.context, &b->world);
    }
    return status;
}

int session_a36_render(SessionA36Binding *b, int32_t layer_lo, int32_t layer_hi, size_t *drawn)
{
    Overlay36Rows view;
    if (b == NULL) {
        return OVERLAY36_ERR_ARGUMENT;
    }
    if (load_world(b) != 0) {
        return OVERLAY36_ERR_UNSUPPORTED;
    }
    view = rows_of(b);
    return overlay36_render_layers(&b->manager, &view, layer_lo, layer_hi, &b->world,
                                   &b->host.kernel, drawn, &b->failure);
}

size_t session_a36_registered(const SessionA36Binding *b)
{
    return b == NULL || b->manager.count < 0 ? 0u : (size_t)b->manager.count;
}

const char *session_a36_row_name(const SessionA36Binding *b, size_t row)
{
    if (b == NULL || row >= b->count || b->images[row] == NULL) {
        return NULL;
    }
    return (const char *)b->images[row] + OV36_NAME;
}

const uint8_t *session_a36_image(const SessionA36Binding *b, size_t row)
{
    if (b == NULL || row >= b->count) {
        return NULL;
    }
    return b->images[row];
}

uint8_t session_a36_row_raw_type(const SessionA36Binding *b, size_t row)
{
    if (b == NULL || row >= b->count || b->images[row] == NULL) {
        return 0u;
    }
    return b->raw_types[row];
}

const Overlay36Manager *session_a36_manager(const SessionA36Binding *b)
{
    return b == NULL ? NULL : &b->manager;
}
