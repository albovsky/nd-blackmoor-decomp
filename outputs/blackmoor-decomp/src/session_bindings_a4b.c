#include "session_bindings_a4b.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct SessionA4bRow {
    SessionA4bRowState state;
    uint8_t *object;       /* the allocation 0x40c774 / 0x40c8a7 makes: length word, text, "<e>" (key form: and a NUL) */
    size_t object_bytes;
    size_t text_bytes;     /* the length word: text length + 3 */
} SessionA4bRow;

struct SessionA4bBinding {
    SessionA4bHost host;
    SessionA4bRow *rows;
    size_t row_count;
    unsigned long writes;
    const char *failure;
};

SessionA4bBinding *session_a4b_create(const SessionA4bHost *host)
{
    SessionA4bBinding *binding;
    if (host == NULL) {
        return NULL;
    }
    binding = (SessionA4bBinding *)calloc(1u, sizeof(*binding));
    if (binding != NULL) {
        binding->host = *host;
        binding->failure = "none";
    }
    return binding;
}

static void release_rows(SessionA4bBinding *binding)
{
    size_t index;
    for (index = 0u; index < binding->row_count; ++index) {
        free(binding->rows[index].object);
    }
    free(binding->rows);
    binding->rows = NULL;
    binding->row_count = 0u;
}

void session_a4b_destroy(SessionA4bBinding *binding)
{
    if (binding == NULL) {
        return;
    }
    release_rows(binding);
    free(binding);
}

static size_t bounded_strlen(const uint8_t *bytes, size_t limit)
{
    const void *terminator = memchr(bytes, 0, limit);
    return terminator == NULL ? limit : (size_t)((const uint8_t *)terminator - bytes);
}

/* Loader construction of one row (0x40c625..0x40caac). Returns an ACTION_FAMILY_4B_* status (UNSUPPORTED is reported as
 * ACTION_FAMILY_4B_ERR_ARGUMENT with *deferred set), or 100 + the lookup status on a lookup failure. */
static int build_row(const SessionA4bBinding *binding, const SceneActionInfo *info, ActionFamily4BConstructed *scratch,
                     SessionA4bRow *row, int *deferred)
{
    ActionFamily4BDecoded decoded;
    const uint8_t *resolved = NULL;
    size_t resolved_bytes = 0u;
    char missing[sizeof(ACTION_FAMILY_51_MISSING_FORMAT) + ACTION_FAMILY_51_AUTO_TEXT_KEY_BYTES];
    ActionFamily4BStatus status;

    *deferred = 0;
    status = action_family_4b_decode(info->raw_body, info->raw_body_length, &decoded);
    if (status != ACTION_FAMILY_4B_OK) {
        return (int)status;
    }
    if (decoded.text_selector == -1) {
        const size_t key_length = bounded_strlen(decoded.text_key, sizeof(decoded.text_key));
        ActionFamily51LookupStatus lookup_status;

        if (binding->host.lookup == NULL) {
            *deferred = 1;   /* 0x40c65e always calls 0x423259: a named blocker if the row is visited */
            return (int)ACTION_FAMILY_4B_ERR_ARGUMENT;
        }
        lookup_status = binding->host.lookup(binding->host.lookup_context, decoded.text_key, key_length, &resolved, &resolved_bytes);
        if (lookup_status == ACTION_FAMILY_51_LOOKUP_ERROR ||
            (lookup_status == ACTION_FAMILY_51_LOOKUP_FOUND && resolved == NULL && resolved_bytes != 0u)) {
            return 100 + (int)ACTION_FAMILY_51_LOOKUP_ERROR;
        }
        if (lookup_status == ACTION_FAMILY_51_LOOKUP_FOUND) {
            if (resolved == NULL) {
                resolved = (const uint8_t *)"";
            }
            /* The table value is a C string. The original quits above 0x9c40 bytes (0x40c6f7); the native construct rejects
             * anything above 32,761 resolved bytes (ACTION_FAMILY_4B_ERR_TEXT), which covers that. */
            resolved_bytes = bounded_strlen(resolved, resolved_bytes);
        } else {
            /* 0x40c6c2: sprintf(local, 0x53f398, key) */
            int written = snprintf(missing, sizeof(missing), ACTION_FAMILY_51_MISSING_FORMAT, (const char *)decoded.text_key);
            if (written < 0 || (size_t)written >= sizeof(missing)) {
                return (int)ACTION_FAMILY_4B_ERR_TEXT;
            }
            resolved = (const uint8_t *)missing;
            resolved_bytes = (size_t)written;
        }
    }
    status = action_family_4b_construct(info->raw_body, info->raw_body_length, resolved, resolved_bytes, 0u, 1u, scratch);
    if (status != ACTION_FAMILY_4B_OK) {
        return (int)status;
    }
    row->object = (uint8_t *)malloc(scratch->allocation_bytes);
    if (row->object == NULL) {
        return -1;
    }
    memcpy(row->object, scratch->object_bytes, scratch->allocation_bytes);
    row->object_bytes = scratch->allocation_bytes;
    row->text_bytes = (size_t)row->object[0] | ((size_t)row->object[1] << 8);
    row->state = SESSION_A4B_ROW_READY;
    return 0;
}

int session_a4b_begin_scene(SessionA4bBinding *binding, const SceneResource *scene, size_t *failed_row, int *kernel_status)
{
    SessionA4bRow *rows = NULL;
    ActionFamily4BConstructed *scratch;
    size_t count, index, other;

    if (failed_row != NULL) {
        *failed_row = SIZE_MAX;
    }
    if (kernel_status != NULL) {
        *kernel_status = ACTION_FAMILY_4B_OK;
    }
    if (binding == NULL || scene == NULL) {
        return SESSION_A4B_ERR_ARGUMENT;
    }
    count = scene_resource_action_count(scene);
    if (count != 0u) {
        rows = (SessionA4bRow *)calloc(count, sizeof(*rows));
        if (rows == NULL) {
            return SESSION_A4B_ERR_MEMORY;
        }
    }
    scratch = (ActionFamily4BConstructed *)malloc(sizeof(*scratch));
    if (scratch == NULL) {
        free(rows);
        return SESSION_A4B_ERR_MEMORY;
    }
    for (index = 0u; index < count; ++index) {
        SceneActionInfo info;
        int deferred;
        int status;

        if (scene_resource_action_at(scene, index, &info) != SCENE_RESOURCE_OK) {
            status = (int)ACTION_FAMILY_4B_ERR_BODY;
            deferred = 0;
        } else if (info.type != SESSION_A4B_TYPE) {
            continue;
        } else {
            status = build_row(binding, &info, scratch, &rows[index], &deferred);
        }
        if (status == 0) {
            continue;
        }
        if (deferred) {
            rows[index].state = SESSION_A4B_ROW_UNSUPPORTED;
            continue;
        }
        for (other = 0u; other < count; ++other) {
            free(rows[other].object);
        }
        free(rows);
        free(scratch);
        if (failed_row != NULL) {
            *failed_row = index;
        }
        if (kernel_status != NULL) {
            *kernel_status = status;
        }
        return status == -1 ? SESSION_A4B_ERR_MEMORY : SESSION_A4B_ERR_SCENE;
    }
    free(scratch);
    release_rows(binding);
    binding->rows = rows;
    binding->row_count = count;
    binding->failure = "none";
    return SESSION_A4B_OK;
}

int session_a4b_handler(void *context, size_t action_index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *state_before, SceneActionHandlerResult *result)
{
    SessionA4bBinding *binding = (SessionA4bBinding *)context;
    const SessionA4bRow *row;
    SessionA4bWriteStatus written;

    if (binding == NULL || action == NULL || state_before == NULL || result == NULL || action->type != SESSION_A4B_TYPE ||
        action_index >= binding->row_count || binding->host.write_caption == NULL) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    row = &binding->rows[action_index];
    if (row->state == SESSION_A4B_ROW_UNSUPPORTED) {
        binding->failure = "AUTOTEXT lookup 0x423259 is not bound (key row)";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    if (row->state != SESSION_A4B_ROW_READY) {
        binding->failure = "no loader object for the row";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    /* 0x4281a3: the writer's text is the object + 2 (past the length word); the writer is thiscall on 0x619a05 with the
     * caption surface [0x5d03b3], mode -1, measure 0. */
    written = binding->host.write_caption(binding->host.context, row->object + 2u, row->text_bytes);
    if (written == SESSION_A4B_WRITE_UNSUPPORTED) {
        binding->failure = "caption writer 0x448d11 is not bound";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    if (written != SESSION_A4B_WRITE_OK) {
        binding->failure = "caption writer 0x448d11 failed";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    ++binding->writes;
    /* 0x4281c6: 0x42ba3a(row) */
    result->disposition = SCENE_ACTION_HANDLER_COMPLETED;
    result->phase = 0u;
    return SCENE_ACTION_HANDLER_OK;
}

SessionA4bRowState session_a4b_row_state(const SessionA4bBinding *binding, size_t action_index)
{
    return binding == NULL || action_index >= binding->row_count ? SESSION_A4B_ROW_NOT_A4B : binding->rows[action_index].state;
}

const uint8_t *session_a4b_row_text(const SessionA4bBinding *binding, size_t action_index, size_t *length)
{
    const SessionA4bRow *row;
    if (length != NULL) {
        *length = 0u;
    }
    if (binding == NULL || action_index >= binding->row_count || binding->rows[action_index].state != SESSION_A4B_ROW_READY) {
        return NULL;
    }
    row = &binding->rows[action_index];
    if (length != NULL) {
        *length = row->text_bytes;
    }
    return row->object + 2u;
}

unsigned long session_a4b_writes(const SessionA4bBinding *binding)
{
    return binding == NULL ? 0ul : binding->writes;
}

const char *session_a4b_failure(const SessionA4bBinding *binding)
{
    return binding == NULL ? "no binding" : binding->failure;
}
