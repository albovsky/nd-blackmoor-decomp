#include "session_bindings_a3f.h"

#include <stdlib.h>
#include <string.h>

#include "action_family_3e.h"
#include "action_family_3f.h"

typedef enum { ROW_NONE = 0, ROW_READY, ROW_BAD, ROW_RELEASED } RowState;

typedef struct {
    RowState state;
    const char *reason;
    uint8_t *arena;
    size_t arena_bytes;
} A3fRow;

struct SessionA3fBinding {
    SessionA3fHost host;
    Convo3fHookBuilders hooks;
    uint64_t rows_revision;
    Convo3fManager manager;
    Convo3fWorld world;
    A3fRow *rows;
    size_t count;
    const char *failure;
    Convo3fStepResult last;
    int has_last;
};

/* Keys are NUL terminated (the typed decoder guarantees it).
 * 0x41c7f4: the embedded text used when the CONVO lookup 0x423259 finds no key
 * (debug flag [0x63a4cd] == 0 branch). */
static const uint8_t MISSING_TEXT[] = "Missing closed captioning text string<h><n><o>";
#define ARENA_HANDLE_BASE 1u

SessionA3fBinding *session_a3f_create(const SessionA3fHost *host)
{
    SessionA3fBinding *b;
    if (host == NULL) {
        return NULL;
    }
    b = (SessionA3fBinding *)calloc(1u, sizeof(*b));
    if (b != NULL) {
        b->host = *host;
        b->failure = "none";
        convo3f_manager_reset(&b->manager);
        b->world.held_item = -1;
        b->world.selected_570374 = CONVO3F_NO_SELECTION;
    }
    return b;
}

static void clear_rows(SessionA3fBinding *b)
{
    size_t i;
    for (i = 0; i < b->count; ++i) {
        free(b->rows[i].arena);
    }
    free(b->rows);
    b->rows = NULL;
    b->count = 0u;
}

int session_a3f_set_response_hooks(SessionA3fBinding *b, const Convo3fHookBuilders *hooks)
{
    if (!b || !hooks || !hooks->build || b->manager.row >= 0) return CONVO3F_ERR_ARGUMENT;
    b->hooks = *hooks;
    return CONVO3F_OK;
}

void session_a3f_destroy(SessionA3fBinding *b)
{
    if (b != NULL) {
        (void)convo3f_cel_release_all(&b->manager, &b->host.kernel, &b->failure);
        clear_rows(b);
        free(b);
    }
}

static void resolve(const SessionA3fBinding *b, const uint8_t *key, const uint8_t **bytes,
                    size_t *length_out)
{
    const uint8_t *text = NULL;
    size_t length = 0u;
    if (b->host.resolve_text != NULL &&
        b->host.resolve_text(b->host.kernel.context, key, strlen((const char *)key), &text,
                             &length) == 0 &&
        (text != NULL || length == 0u)) {
        *bytes = text;
        *length_out = length;
    } else {
        *bytes = MISSING_TEXT;
        *length_out = sizeof(MISSING_TEXT) - 1u;
    }
}

static int build_row(const SessionA3fBinding *b, const SceneActionInfo *info, A3fRow *row)
{
    ActionFamily3fDecoded d;
    ActionFamily3fText *texts;
    ActionFamily3fConstructed layout, built;
    const uint8_t *record;
    size_t i;
    int status;
    status = action_family_3f_decode(info->raw_body, info->raw_body_length, &d);
    if (status != ACTION_FAMILY_3F_OK) {
        row->reason = "raw 0x3f body rejected by the typed decoder";
        return 0;
    }
    texts = (ActionFamily3fText *)calloc((size_t)d.primary_count + 1u, sizeof(*texts));
    if (texts == NULL) {
        row->reason = "text table allocation failed";
        return 0;
    }
    resolve(b, d.text_key, &texts[0].bytes, &texts[0].length);
    record = d.primary_records;
    for (i = 0; i < (size_t)d.primary_count; ++i) {
        const size_t conditions = (size_t)record[0] * 5u;
        resolve(b, record + 2u + conditions, &texts[i + 1u].bytes, &texts[i + 1u].length);
        record += 70u + conditions;
    }
    status = action_family_3f_construct(info->raw_body, info->raw_body_length, texts,
                                        (size_t)d.primary_count + 1u, 0u, ARENA_HANDLE_BASE, NULL,
                                        0u, &layout);
    if (status != ACTION_FAMILY_3F_OK) {
        free(texts);
        row->reason = "resolved text does not fit its object field (or layout rejected)";
        return 0;
    }
    row->arena = (uint8_t *)calloc(layout.arena_bytes, 1u);
    if (row->arena == NULL) {
        free(texts);
        row->reason = "object arena allocation failed";
        return 0;
    }
    row->arena_bytes = layout.arena_bytes;
    status = action_family_3f_construct(info->raw_body, info->raw_body_length, texts,
                                        (size_t)d.primary_count + 1u, 0u, ARENA_HANDLE_BASE,
                                        row->arena, row->arena_bytes, &built);
    free(texts);
    if (status != ACTION_FAMILY_3F_OK) {
        free(row->arena);
        row->arena = NULL;
        row->reason = "object construction failed";
        return 0;
    }
    return 1;
}

static int build_row_3e(const SessionA3fBinding *b, const SceneActionInfo *info, A3fRow *row)
{
    ActionFamily3eDecoded d;
    ActionFamily3eText *texts;
    ActionFamily3eConstructed layout, built;
    const uint8_t *record;
    size_t i;
    int status;
    status = action_family_3e_decode(info->raw_body, info->raw_body_length, &d);
    if (status != ACTION_FAMILY_3E_OK) {
        row->reason = "raw 0x3e body rejected by the typed decoder";
        return 0;
    }
    texts = (ActionFamily3eText *)calloc((size_t)d.primary_count + 1u, sizeof(*texts));
    if (texts == NULL) {
        row->reason = "text table allocation failed";
        return 0;
    }
    resolve(b, d.text_key, &texts[0].bytes, &texts[0].length);
    record = d.primary_records;
    for (i = 0; i < (size_t)d.primary_count; ++i) {
        const size_t conditions = (size_t)record[0] * 5u;
        resolve(b, record + 2u + conditions, &texts[i + 1u].bytes, &texts[i + 1u].length);
        record += 70u + conditions;
    }
    status = action_family_3e_construct(info->raw_body, info->raw_body_length, texts,
                                        (size_t)d.primary_count + 1u, 0u, ARENA_HANDLE_BASE, NULL,
                                        0u, &layout);
    if (status != ACTION_FAMILY_3E_OK) {
        free(texts);
        row->reason = "resolved text does not fit its object field (or layout rejected)";
        return 0;
    }
    row->arena = (uint8_t *)calloc(layout.arena_bytes, 1u);
    if (row->arena == NULL) {
        free(texts);
        row->reason = "object arena allocation failed";
        return 0;
    }
    row->arena_bytes = layout.arena_bytes;
    status = action_family_3e_construct(info->raw_body, info->raw_body_length, texts,
                                        (size_t)d.primary_count + 1u, 0u, ARENA_HANDLE_BASE,
                                        row->arena, row->arena_bytes, &built);
    free(texts);
    if (status != ACTION_FAMILY_3E_OK) {
        free(row->arena);
        row->arena = NULL;
        row->reason = "object construction failed";
        return 0;
    }
    return 1;
}

int session_a3f_begin_scene(SessionA3fBinding *b, const SceneResource *scene)
{
    A3fRow *rows;
    size_t count, i;
    if (b == NULL || scene == NULL) {
        return CONVO3F_ERR_ARGUMENT;
    }
    count = scene_resource_action_count(scene);
    rows = (A3fRow *)calloc(count != 0u ? count : 1u, sizeof(*rows));
    if (rows == NULL) {
        b->failure = "0x3f row allocation failed";
        return CONVO3F_ERR_HOST;
    }
    for (i = 0; i < count; ++i) {
        SceneActionInfo info;
        if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) {
            size_t k;
            for (k = 0; k < i; ++k) {
                free(rows[k].arena);
            }
            free(rows);
            b->failure = "0x3f scene row unreadable";
            return CONVO3F_ERR_BOUNDS;
        }
        if (info.type != SESSION_A3F_TYPE && info.type != SESSION_A3E_TYPE) {
            continue;
        }
        rows[i].state = (info.type == SESSION_A3E_TYPE ? build_row_3e(b, &info, &rows[i])
                                                       : build_row(b, &info, &rows[i]))
                            ? ROW_READY
                            : ROW_BAD;
    }
    if (b->rows_revision == UINT64_MAX) {
        for (i = 0; i < count; ++i) free(rows[i].arena);
        free(rows);
        return CONVO3F_ERR_HOST;
    }
    ++b->rows_revision;
    clear_rows(b);
    b->rows = rows;
    b->count = count;
    /* Native cleanup: a cel row in flight when the scene is replaced (see convo3f_cel_release_all). */
    {
        const int released = convo3f_cel_release_all(&b->manager, &b->host.kernel, &b->failure);
        if (released != CONVO3F_OK) {
            return released; /* the old reader, layers or header block are still held: keep the manager state */
        }
    }
    convo3f_manager_reset(&b->manager);
    /* Scene replacement drops a conversation in flight: the original loaders and teardown
     * store 0 to [0x5c39e9]/[0x5c39ed] (0x43e3de, 0x4385c4, 0x422867). */
    b->world.flag_5c39e9 = 0;
    b->world.flag_5c39ed = 0;
    b->world.selected_570374 = CONVO3F_NO_SELECTION;
    memset(b->world.chosen_5839b1, 0, sizeof(b->world.chosen_5839b1));
    b->has_last = 0;
    b->failure = "none";
    return CONVO3F_OK;
}

int session_a3f_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionA3fBinding *b = (SessionA3fBinding *)context;
    Convo3fObject object;
    Convo3fStepResult result;
    A3fRow *row;
    int status;
    if (b == NULL) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (action == NULL || before == NULL || out == NULL ||
        (action->type != SESSION_A3F_TYPE && action->type != SESSION_A3E_TYPE) ||
        index >= b->count || b->rows[index].state == ROW_NONE) {
        b->failure = "0x3f row not owned";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (b->rows_revision == UINT64_MAX) return SCENE_ACTION_HANDLER_ERROR;
    ++b->rows_revision;
    row = &b->rows[index];
    if (row->state == ROW_BAD) {
        b->failure = row->reason != NULL ? row->reason : "0x3f row could not be built";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    if (row->state == ROW_RELEASED) {
        b->failure = "0x3f object already released (the original dereferences the freed object)";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (b->host.transition == NULL) {
        b->failure = "scene-change transition provider (0x3f finish branches)";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    if (b->host.load_world == NULL) {
        b->failure = "world provider (events, presence, flags, settings)";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    if (b->host.load_world(b->host.kernel.context, &b->world) != 0) {
        b->failure = "world provider refused";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    object.arena = row->arena;
    object.arena_bytes = row->arena_bytes;
    object.handle_base = ARENA_HANDLE_BASE;
    b->failure = "none";
    status = convo3f_step_type_with_hooks(&b->manager, &object, action->type, (int32_t)index, before->phase,
                               &b->world, &b->host.kernel, &b->hooks, &result, &b->failure);
    if (status == CONVO3F_ERR_UNSUPPORTED) {
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    if (status != CONVO3F_OK) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    b->last = result;
    b->has_last = 1;
    if (b->host.store_world != NULL) {
        b->host.store_world(b->host.kernel.context, &b->world);
    }
    if (result.finished != 0u) {
        if (result.scene_change != 0u) {
            SceneTransitionRequest request;
            memset(&request, 0, sizeof(request));
            request.target_scene = (int16_t)b->world.xfer_5bb57b;
            request.opaque_words[0] = b->world.xfer_5bb599;
            request.opaque_words[1] = b->world.xfer_5bb595;
            request.opaque_words[2] = b->world.xfer_5c39ff;
            request.opaque_dwords[0] = b->world.xfer_5bb59b;
            request.opaque_dwords[1] = b->world.xfer_5bb59f;
            request.opaque_dwords[2] = b->world.xfer_5bb5a3;
            if (b->host.transition(b->host.kernel.context, &request) != 0) {
                b->failure = "scene-change request was refused";
                return SCENE_ACTION_HANDLER_ERROR;
            }
        }
        if (result.object_released != 0u) { /* 0x41db40 */
            free(row->arena);
            row->arena = NULL;
            row->arena_bytes = 0u;
            row->state = ROW_RELEASED;
        }
        out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;
        out->phase = 0u;
    } else {
        out->disposition = SCENE_ACTION_HANDLER_PENDING;
        out->phase = result.phase_after;
    }
    return SCENE_ACTION_HANDLER_OK;
}

int session_a3f_cel_active(const SessionA3fBinding *b)
{
    return b != NULL && b->manager.cel_thread != 0;
}

int session_a3f_cel_reader_pass(SessionA3fBinding *b, int *ran)
{
    if (b == NULL) {
        return CONVO3F_ERR_ARGUMENT;
    }
    return convo3f_cel_reader_iteration(&b->manager, &b->host.kernel, ran, &b->failure);
}

int session_a3f_cel_render(SessionA3fBinding *b, Convo3fRenderPlan *plan)
{
    A3fRow *row;
    Convo3fObject object;
    int status;
    if (b == NULL || plan == NULL) {
        return -1;
    }
    memset(plan, 0, sizeof(*plan));
    if (b->manager.type != SESSION_A3E_TYPE || b->manager.cel_thread == 0 || b->world.ui_5d191d == 0 ||
        b->manager.row < 0 || (size_t)b->manager.row >= b->count) {
        return 0;
    }
    row = &b->rows[b->manager.row];
    if (row->state != ROW_READY || b->host.load_world == NULL ||
        b->host.load_world(b->host.kernel.context, &b->world) != 0) {
        b->failure = "cel render: row or world provider unavailable";
        return -1;
    }
    object.arena = row->arena;
    object.arena_bytes = row->arena_bytes;
    object.handle_base = ARENA_HANDLE_BASE;
    b->failure = "none";
    status = convo3f_cel_render(&b->manager, &object, &b->world, &b->host.kernel, plan, &b->failure);
    return status == CONVO3F_OK ? 1 : -1;
}

const char *session_a3f_failure(const SessionA3fBinding *b)
{
    return b == NULL ? "0x3f binding unbound" : b->failure;
}

const Convo3fStepResult *session_a3f_last_result(const SessionA3fBinding *b)
{
    return b == NULL || b->has_last == 0 ? NULL : &b->last;
}

const Convo3fManager *session_a3f_manager(const SessionA3fBinding *b)
{
    return b == NULL ? NULL : &b->manager;
}

const uint8_t *session_a3f_image(const SessionA3fBinding *b, size_t row)
{
    if (b == NULL || row >= b->count || b->rows[row].state != ROW_READY) {
        return NULL;
    }
    return b->rows[row].arena;
}

const char *session_a3f_row_reason(const SessionA3fBinding *b, size_t row)
{
    if (b == NULL || row >= b->count) {
        return NULL;
    }
    if (b->rows[row].state == ROW_BAD) {
        return b->rows[row].reason;
    }
    return b->rows[row].state == ROW_RELEASED ? "released" : NULL;
}

int session_a3f_phase0_guarded(const SessionA3fBinding *b)
{
    return b != NULL && (b->world.flag_5c39e9 != 0 || b->world.flag_5c39ed != 0);
}

int session_a3f_modal_active(const SessionA3fBinding *b)
{
    return b != NULL && b->world.flag_5c39e9 != 0;
}

int session_a3f_choose_response(SessionA3fBinding *b, int index)
{
    int i;
    if (b == NULL || index < 0 || index >= b->manager.response_count ||
        index >= CONVO3F_MAX_RESPONSES) {
        return 1;
    }
    for (i = 0; i < CONVO3F_MAX_RESPONSES; ++i) {
        b->world.chosen_5839b1[i] = 0;
    }
    b->world.chosen_5839b1[index] = 1;
    return 0;
}

int session_a3f_preview_layout(const SessionA3fBinding *b, size_t index,
    Convo3fManager *preview, Convo3fLayoutRequest *request)
{
    if (!b || !preview || !request || index >= b->count ||
        b->rows[index].state != ROW_READY || !b->host.load_world) return CONVO3F_ERR_ARGUMENT;
    Convo3fWorld world = b->world;
    if (b->host.load_world(b->host.kernel.context, &world) != 0) return CONVO3F_ERR_HOST;
    const A3fRow *row = &b->rows[index];
    const Convo3fObject object = {row->arena, row->arena_bytes, ARENA_HANDLE_BASE};
    const uint8_t *text = row->arena + C3F_CAPTION;
    const uint8_t *end = memchr(text, 0, 1500);
    if (!end) return CONVO3F_ERR_BOUNDS;
    const char *why = "none";
    int status = convo3f_preview_responses_with_hooks(&b->manager, &object, &world, &b->hooks, preview, &why);
    if (status != CONVO3F_OK) return status;
    const Convo3fLayoutRequest r = {(int32_t)index, text, (size_t)(end - text),
        preview->response_count, preview->responses, 0, 1};
    *request = r;
    return CONVO3F_OK;
}

int session_a3f_response_count(const SessionA3fBinding *b)
{
    return b == NULL ? 0 : b->manager.response_count;
}

const uint8_t *session_a3f_response_text(const SessionA3fBinding *b, int index)
{
    if (b == NULL || index < 0 || index >= b->manager.response_count ||
        index >= CONVO3F_MAX_RESPONSES) {
        return NULL;
    }
    return b->manager.responses[index].text;
}


struct SessionA3fAppend {
    SessionA3fBinding *owner;
    uint64_t revision;
    A3fRow *rows;
    size_t count;
    uint8_t new_owned[SCENE_ACTION_SLOT_LIMIT];
    uint8_t retired[SCENE_ACTION_SLOT_LIMIT];
};

void session_a3f_discard_no_art(SessionA3fAppend *p)
{
    if (p == NULL) return;
    if (p->rows != NULL) for (size_t i = 0; i < p->count; ++i)
        if (p->new_owned[i]) free(p->rows[i].arena);
    free(p->rows);
    free(p);
}

int session_a3f_prepare_no_art(SessionA3fBinding *b, const SceneResource *source,
    const SceneActionSlotPlan *plan, SessionA3fAppend **out)
{
    SessionA3fAppend *p;
    int status = CONVO3F_ERR_BOUNDS;
    uint8_t assigned[SCENE_ACTION_SLOT_LIMIT] = {0};
    if (out != NULL) *out = NULL;
    if (b == NULL || source == NULL || plan == NULL || out == NULL ||
        b->count > SCENE_ACTION_SLOT_LIMIT || plan->final_high_water > SCENE_ACTION_SLOT_LIMIT ||
        plan->source_high_water > SCENE_ACTION_SLOT_LIMIT ||
        plan->incoming_count != scene_resource_action_count(source) ||
        plan->incoming_count > SCENE_ACTION_SLOT_LIMIT || b->rows_revision == UINT64_MAX)
        return CONVO3F_ERR_ARGUMENT;
    /* A started conversation can still own modal/voice/UI state after its
     * row is removed. That lifetime is not recovered by this bounded loader;
     * reject before constructing/releasing anything instead of soft-locking
     * the next row behind the old phase0 guards. */
    if (session_a3f_phase0_guarded(b) && b->manager.row >= 0 &&
        (size_t)b->manager.row < b->count && (size_t)b->manager.row < plan->source_high_water &&
        plan->retired[b->manager.row] && b->rows[b->manager.row].state == ROW_READY) {
        b->failure = "no-art retirement of a busy conversation is not modelled";
        return CONVO3F_ERR_UNSUPPORTED;
    }
    /* The record release 0x41db40 is not a cel-thread teardown. Do not guess
     * that larger lifetime when an in-flight cel record would be removed. */
    if (b->manager.cel_thread != 0 && b->manager.row >= 0 &&
        (size_t)b->manager.row < plan->source_high_water && plan->retired[b->manager.row]) {
        b->failure = "no-art retirement of an active cel reader is not modelled";
        return CONVO3F_ERR_UNSUPPORTED;
    }
    p = calloc(1u, sizeof(*p));
    if (p == NULL) return CONVO3F_ERR_HOST;
    p->count = plan->final_high_water;
    p->rows = calloc(p->count != 0u ? p->count : 1u, sizeof(*p->rows));
    if (p->rows == NULL) { free(p); return CONVO3F_ERR_HOST; }
    p->owner = b;
    p->revision = b->rows_revision;
    memcpy(p->retired, plan->retired, sizeof(p->retired));
    for (size_t i = 0; i < b->count; ++i) {
        if (i < plan->source_high_water && plan->retired[i]) continue;
        if (i < p->count) p->rows[i] = b->rows[i];
        else if (b->rows[i].arena != NULL) goto fail;
    }
    for (size_t i = 0; i < plan->incoming_count; ++i) {
        SceneActionInfo info;
        const size_t slot = plan->assigned[i];
        if (slot >= p->count || assigned[slot] || p->rows[slot].arena != NULL || p->new_owned[slot] ||
            scene_resource_action_at(source, i, &info) != SCENE_RESOURCE_OK) goto fail;
        assigned[slot] = 1u;
        memset(&p->rows[slot], 0, sizeof(p->rows[slot]));
        if (info.type != SESSION_A3F_TYPE && info.type != SESSION_A3E_TYPE) continue;
        p->new_owned[slot] = 1u;
        if (!(info.type == SESSION_A3E_TYPE ? build_row_3e(b, &info, &p->rows[slot]) :
                                              build_row(b, &info, &p->rows[slot]))) {
            b->failure = p->rows[slot].reason;
            status = CONVO3F_ERR_UNSUPPORTED;
            goto fail;
        }
        p->rows[slot].state = ROW_READY;
    }
    *out = p;
    return CONVO3F_OK;
fail:
    session_a3f_discard_no_art(p);
    return status;
}

int session_a3f_can_commit_no_art(const SessionA3fBinding *b, const SessionA3fAppend *p)
{
    return b != NULL && p != NULL && p->owner == b && p->revision == b->rows_revision &&
        b->rows_revision != UINT64_MAX;
}

int session_a3f_commit_no_art(SessionA3fBinding *b, SessionA3fAppend *p)
{
    if (!session_a3f_can_commit_no_art(b, p)) return CONVO3F_ERR_ARGUMENT;
    /* Completed objects are ROW_RELEASED with a NULL arena; unfinished
     * objects own one flattened native allocation, released exactly once. */
    for (size_t i = 0; i < b->count; ++i) if (p->retired[i]) free(b->rows[i].arena);
    free(b->rows);
    b->rows = p->rows;
    b->count = p->count;
    ++b->rows_revision;
    p->rows = NULL;
    p->owner = NULL;
    return CONVO3F_OK;
}
