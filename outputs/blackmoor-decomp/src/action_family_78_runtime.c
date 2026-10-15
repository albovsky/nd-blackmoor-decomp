#include "action_family_78_runtime.h"

#include <stdlib.h>
#include <string.h>

#define SHADOW_LIMIT 32768u /* the count is a signed word and ids are signed words */

typedef struct {
    const Action79Model *inventory;
    Action78View view;
    const Action78Host *host;
    int dry;                /* private copies, no observer, no provider calls */
    Action78Result *result;
    const char **why;
} Run;

static int fail(const Run *run, const char *message, int status)
{
    if (run->why != NULL) {
        *run->why = message;
    }
    return status;
}

static void emit(const Run *run, int effect, int32_t value)
{
    if (!run->dry && run->host != NULL && run->host->inventory.observe != NULL) {
        run->host->inventory.observe(run->host->inventory.context, effect, value);
    }
}

static int16_t as_id(uint16_t word)
{
    return (int16_t)(word <= (uint16_t)INT16_MAX ? (int32_t)word : (int32_t)word - 65536);
}

static int dry_rebuild(void *context, int16_t removed_item)
{
    (void)context;
    (void)removed_item;
    return 0;
}

/* 0x4ea06c through the shared RT-13 step. */
static int remove_item(Run *run, uint16_t word)
{
    Action79Result inner;
    Action79Host dry_host;
    const Action79Host *host = run->host != NULL ? &run->host->inventory : NULL;
    int status;
    if (run->dry) {
        memset(&dry_host, 0, sizeof(dry_host));
        dry_host.rebuild_view = host != NULL && host->rebuild_view != NULL ? dry_rebuild : NULL;
        host = &dry_host;
    }
    status = action79_remove_item(word, run->inventory, host, &inner, run->why);
    if (status == ACTION79_OK && inner.found) {
        run->result->removed = 1u;
    }
    return status;
}

static int held_store(Run *run, uint16_t word)
{
    *run->inventory->held_item = as_id(word);
    run->result->held_changed = (uint8_t)(run->result->held_changed + 1u);
    emit(run, ACTION78_EFFECT_HELD, as_id(word));
    return ACTION78_OK;
}

/* 0x4e9e84(item, flag). */
static int add_item(Run *run, int16_t id, int flag)
{
    const Action79Model *inv = run->inventory;
    const Action78Host *host = run->host;
    int32_t count, scan, new_count, index;
    const int append = run->view.slot_flag != 0 && run->view.mode == 2;
    const int animate = flag && run->view.mode != 2;

    emit(run, flag ? ACTION78_EFFECT_ADD_FLAGGED : ACTION78_EFFECT_ADD, id);
    count = (int32_t)*inv->item_count;
    /* 0x4e9e9c..0x4e9edc: signed compare against the signed count word. */
    if (count > 0 && (size_t)count > inv->item_capacity) {
        return fail(run, "inventory count exceeds the modeled item array bounds",
                    ACTION78_ERR_BOUNDS);
    }
    for (scan = 0; scan < count; ++scan) {
        if (as_id(inv->items[scan]) == id) {
            run->result->duplicates = (uint8_t)(run->result->duplicates + 1u);
            emit(run, ACTION78_EFFECT_DUPLICATE, scan);
            return ACTION78_OK;
        }
    }
    new_count = count + 1;
    if (count < -1) {
        return fail(run, "negative inventory count would copy a negative length",
                    ACTION78_ERR_BOUNDS);
    }
    if (new_count > 0 && (size_t)new_count > inv->item_capacity) {
        return fail(run, "inventory is full: the original would write past the item array",
                    ACTION78_ERR_BOUNDS);
    }
    if (id < 0 || (size_t)id >= inv->presence_capacity) {
        return fail(run, "added item id outside the modeled presence array bounds",
                    ACTION78_ERR_BOUNDS);
    }
    if (host == NULL || host->inventory.rebuild_view == NULL) {
        return fail(run, "inventory view rebuild provider (0x4e812f)", ACTION78_ERR_UNSUPPORTED);
    }
    if (flag && host->request_sound == NULL) {
        return fail(run, "sound request provider (0x4fb2e3)", ACTION78_ERR_UNSUPPORTED);
    }
    if (animate && host->request_ui_animation == NULL) {
        return fail(run, "UI animation provider (0x4e0559)", ACTION78_ERR_UNSUPPORTED);
    }
    if (flag) {
        run->result->sound_requests = (uint8_t)(run->result->sound_requests + 1u);
        emit(run, ACTION78_EFFECT_SOUND, (int32_t)ACTION78_SOUND_SLOT);
        if (!run->dry && host->request_sound(host->context, (uint16_t)ACTION78_SOUND_SLOT) != 0) {
            return fail(run, "sound request failed before the item was added", ACTION78_ERR_HOST);
        }
    }
    /* 0x4e9f89 (item first) or 0x4e9f14 (item last, only for slot flag + mode 2),
     * then 0x4ea006 stores the count and 0x4ea022/0x4ea02b copy count*2 bytes
     * back. In place and front to back the result is identical. */
    if (append) {
        if (count >= 0) {
            inv->items[count] = (uint16_t)id;
        }
    } else if (new_count > 0) {
        for (index = new_count - 1; index > 0; --index) {
            inv->items[index] = inv->items[index - 1];
        }
        inv->items[0] = (uint16_t)id;
    }
    *inv->item_count = (int16_t)new_count;
    emit(run, ACTION78_EFFECT_COUNT, new_count);
    if (new_count > 0) {
        emit(run, ACTION78_EFFECT_LIST, new_count);
    }
    inv->presence[id] = 1;
    emit(run, ACTION78_EFFECT_PRESENCE, id);
    run->result->added = (uint8_t)(run->result->added + 1u);
    emit(run, ACTION79_EFFECT_REBUILD, id);
    if (!run->dry && host->inventory.rebuild_view(host->inventory.context, id) != 0) {
        return fail(run, "inventory view rebuild failed after the list was committed",
                    ACTION78_ERR_HOST);
    }
    if (animate) {
        run->result->ui_requests = (uint8_t)(run->result->ui_requests + 1u);
        emit(run, ACTION78_EFFECT_UI, 1);
        if (!run->dry && host->request_ui_animation(host->context, 1, 1, 0) != 0) {
            return fail(run, "UI animation request failed after the item was added",
                        ACTION78_ERR_HOST);
        }
    }
    return ACTION78_OK;
}

/* 0x4e8d96: return the held item to the list. */
static int put_back(Run *run)
{
    int status;
    const int16_t held = *run->inventory->held_item;
    if (held == -1) {
        return ACTION78_OK;
    }
    emit(run, ACTION78_EFFECT_PUTBACK, held);
    run->result->put_back = 1u;
    status = add_item(run, held, 0);
    if (status != ACTION78_OK) {
        return status;
    }
    return held_store(run, 0xffffu);
}

static int visit(Run *run, const Action78Object *object)
{
    const int16_t id = as_id(object->item_word);
    const Action79Model *inv = run->inventory;
    int status;

    emit(run, ACTION78_EFFECT_ENTER, id);
    if (object->take_flag != 0) {
        const int16_t held = *inv->held_item;
        run->result->took_in_hand = 1u;
        if (held == -1) {
            status = remove_item(run, object->item_word);
            if (status != ACTION78_OK) {
                return status;
            }
            held_store(run, object->item_word);
        } else if (object->swap_flag != 0) {
            if (held != id) {
                status = put_back(run);
                if (status == ACTION78_OK) {
                    status = remove_item(run, object->item_word);
                }
                if (status != ACTION78_OK) {
                    return status;
                }
                held_store(run, object->item_word);
            }
        } else if (held != id) {
            status = add_item(run, id, 0);
            if (status != ACTION78_OK) {
                return status;
            }
        }
    }
    if (*inv->held_item != id) {
        status = add_item(run, id, 1);
        if (status != ACTION78_OK) {
            return status;
        }
    }
    run->result->completed = 1u;
    emit(run, ACTION79_EFFECT_COMPLETE, 1);
    return ACTION78_OK;
}

int action78_object_from_body(const uint8_t *body, size_t length, Action78Object *out)
{
    if (body == NULL || out == NULL || length < ACTION78_BODY_BYTES) {
        return ACTION78_ERR_ARGUMENT;
    }
    out->item_word = (uint16_t)(body[0] | (body[1] << 8));
    out->take_flag = (uint16_t)(body[2] | (body[3] << 8));
    out->swap_flag = (uint16_t)(body[4] | (body[5] << 8));
    return ACTION78_OK;
}

int action78_visit(const Action78Object *object, const Action78Model *model,
                   const Action78Host *host, Action78Result *result, const char **why)
{
    Run run;
    Action78Result scratch;
    Action79Model shadow;
    int16_t shadow_held;
    int16_t shadow_count;
    uint16_t *shadow_items = NULL;
    int32_t *shadow_presence = NULL;
    size_t item_words, presence_words;
    int status;

    if (why != NULL) {
        *why = "none";
    }
    if (object == NULL || model == NULL || result == NULL || model->inventory.held_item == NULL ||
        model->inventory.item_count == NULL || model->inventory.items == NULL ||
        model->inventory.presence == NULL) {
        if (why != NULL) {
            *why = "invalid runtime arguments";
        }
        return ACTION78_ERR_ARGUMENT;
    }
    memset(result, 0, sizeof(*result));

    /* Dry run: every sub-step is predicted on private copies before the first
     * real effect, so a rejection never leaves a half-applied visit. */
    item_words = model->inventory.item_capacity < SHADOW_LIMIT ? model->inventory.item_capacity
                                                               : SHADOW_LIMIT;
    presence_words = model->inventory.presence_capacity < SHADOW_LIMIT
                         ? model->inventory.presence_capacity : SHADOW_LIMIT;
    shadow_items = (uint16_t *)calloc(item_words != 0u ? item_words : 1u, sizeof(*shadow_items));
    shadow_presence = (int32_t *)calloc(presence_words != 0u ? presence_words : 1u,
                                        sizeof(*shadow_presence));
    if (shadow_items == NULL || shadow_presence == NULL) {
        free(shadow_items);
        free(shadow_presence);
        if (why != NULL) {
            *why = "out of memory for the dry run";
        }
        return ACTION78_ERR_ARGUMENT;
    }
    memcpy(shadow_items, model->inventory.items, item_words * sizeof(*shadow_items));
    memcpy(shadow_presence, model->inventory.presence, presence_words * sizeof(*shadow_presence));
    shadow_held = *model->inventory.held_item;
    shadow_count = *model->inventory.item_count;
    shadow.held_item = &shadow_held;
    shadow.item_count = &shadow_count;
    shadow.items = shadow_items;
    shadow.item_capacity = item_words;
    shadow.presence = shadow_presence;
    shadow.presence_capacity = presence_words;
    memset(&scratch, 0, sizeof(scratch));
    run.inventory = &shadow;
    run.view = model->view;
    run.host = host;
    run.dry = 1;
    run.result = &scratch;
    run.why = why;
    status = visit(&run, object);
    free(shadow_items);
    free(shadow_presence);
    if (status != ACTION78_OK) {
        return status;
    }

    run.inventory = &model->inventory;
    run.dry = 0;
    run.result = result;
    status = visit(&run, object);
    return status;
}
