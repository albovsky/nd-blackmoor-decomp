#include "inventory_examine_runtime.h"

#include <string.h>

#define INV_RECORD_BASE 0xb1u             /* view +0x74e - 0x69d (see inventory_view_runtime.c) */
#define INV_RECORD_STRIDE 0x16du
#define DRY_CAPACITY 128u

static int16_t rd16(const uint8_t *p)
{
    return (int16_t)(uint16_t)((uint32_t)p[0] | ((uint32_t)p[1] << 8));
}

int inventory_examine_words_from_inv(const uint8_t *inv, size_t length, int16_t flag_word[INVEXAM_ITEMS])
{
    size_t i;
    if (inv == NULL || flag_word == NULL || length < INV_RECORD_BASE + INV_RECORD_STRIDE * INVEXAM_ITEMS) {
        return INVVIEW_ERR_ARGUMENT;
    }
    for (i = 0; i < INVEXAM_ITEMS; ++i) {
        flag_word[i] = rd16(inv + INV_RECORD_BASE + INV_RECORD_STRIDE * i + INVEXAM_FLAG_OFFSET);
    }
    return INVVIEW_OK;
}

static void observe(const InventoryViewHost *host, int effect, int32_t value)
{
    if (host->inventory.inventory.observe != NULL) {
        host->inventory.inventory.observe(host->inventory.inventory.context, effect, value);
    }
}

/* Stand-ins for the dry run: a provider the real host lacks stays NULL so the shared steps report it themselves. */
static int dry_rebuild(void *context, int16_t item)
{
    (void)context;
    (void)item;
    return 0;
}

static int dry_sound(void *context, uint16_t slot)
{
    (void)context;
    (void)slot;
    return 0;
}

static int dry_ui(void *context, int16_t index, int32_t enable, int16_t sub)
{
    (void)context;
    (void)index;
    (void)enable;
    (void)sub;
    return 0;
}

/* Steps 1 and 4 on private copies of the inventory: whatever the add or remove step would refuse is refused here,
 * before step 1 commits anything. */
static int dry_run(const Action78Model *model, const InventoryViewHost *host, int put_back, int16_t selector,
                   int16_t item, const char **failure)
{
    uint16_t items[DRY_CAPACITY];
    int32_t presence[DRY_CAPACITY];
    int16_t held, count;
    Action78Model local;
    Action78Host dry;
    Action78Result added;
    Action79Result removed;
    int status;

    if (model->inventory.item_capacity > DRY_CAPACITY || model->inventory.presence_capacity > DRY_CAPACITY) {
        *failure = "inventory capacity above the dry-run buffer";
        return INVVIEW_ERR_ARGUMENT;
    }
    held = *model->inventory.held_item;
    count = *model->inventory.item_count;
    memcpy(items, model->inventory.items, model->inventory.item_capacity * sizeof(items[0]));
    memcpy(presence, model->inventory.presence, model->inventory.presence_capacity * sizeof(presence[0]));
    local = *model;
    local.inventory.held_item = &held;
    local.inventory.item_count = &count;
    local.inventory.items = items;
    local.inventory.presence = presence;
    memset(&dry, 0, sizeof(dry));
    dry.inventory.rebuild_view = host->inventory.inventory.rebuild_view != NULL ? dry_rebuild : NULL;
    dry.request_sound = host->inventory.request_sound != NULL ? dry_sound : NULL;
    dry.request_ui_animation = host->inventory.request_ui_animation != NULL ? dry_ui : NULL;
    if (put_back) {
        status = action78_add_item(selector, 1, &local, &dry, &added, failure);
        if (status != ACTION78_OK) {
            return status;
        }
    }
    status = action79_remove_item((uint16_t)item, &local.inventory, &dry.inventory, &removed, failure);
    return status;
}

int inventory_examine(InventoryView *view, const InventoryViewItemData *data, const Action78Model *model,
                      const InventoryViewHost *host, const InventoryExamine *examine, int16_t item, int16_t take,
                      int32_t sound, InventoryExamineResult *result, const char **failure)
{
    const char *why = "none";
    InventoryExamineResult *out = result;
    SceneStackCurrent current;
    int16_t selector;
    int put_back;
    int status;

    if (failure == NULL) {
        failure = &why;
    }
    *failure = "none";
    if (view == NULL || data == NULL || data->text == NULL || model == NULL || host == NULL || examine == NULL ||
        result == NULL || examine->selector == NULL || examine->slot == NULL || examine->flag_word == NULL ||
        model->inventory.held_item == NULL || model->inventory.item_count == NULL ||
        model->inventory.items == NULL || model->inventory.presence == NULL) {
        *failure = "invalid examine arguments";
        return INVVIEW_ERR_ARGUMENT;
    }
    memset(out, 0, sizeof(*out));
    if (item < 0 || (size_t)item >= INVEXAM_ITEMS) {
        *failure = "examined item outside the 70 item records";
        return INVVIEW_ERR_BOUNDS;
    }
    if (examine->host.scene_change == NULL) {
        *failure = "scene-change provider (0x4ea269 starts a scene change: mode 4)";
        return INVVIEW_ERR_UNSUPPORTED;
    }
    if (sound != 0 && host->request_sound == NULL) {
        *failure = "sound request provider (0x4fb2e3)";
        return INVVIEW_ERR_UNSUPPORTED;
    }
    selector = *examine->selector;                       /* 0x4ea270 */
    put_back = selector != -1;                           /* 0x4ea277..0x4ea28e */
    if (!put_back) {
        if (examine->host.load_current == NULL) {
            *failure = "running-scene words provider (saver 0x4eb70f)";
            return INVVIEW_ERR_UNSUPPORTED;
        }
    }
    status = dry_run(model, host, put_back, selector, item, failure);
    if (status != INVVIEW_OK) {
        return status;
    }
    memset(&current, 0, sizeof(current));
    if (!put_back && examine->host.load_current(examine->host.context, &current) != 0) {
        *failure = "running-scene words were refused; nothing changed";
        return INVVIEW_ERR_HOST;
    }

    observe(host, INVEXAM_EFFECT_ENTER, item);
    if (put_back) {
        Action78Result added;
        status = action78_add_item(selector, 1, model, &host->inventory, &added, failure);   /* 0x4ea289 */
        if (status != ACTION78_OK) {
            return status;
        }
        out->put_back = 1u;
        out->added = added.added;
    } else {
        scene_restore_slot_save(examine->slot, &current, INVEXAM_SAVE_TYPE);                  /* 0x4ea29f */
        observe(host, INVEXAM_EFFECT_SAVE, examine->slot->marker_5c3a1b);
        out->saved = 1u;
    }
    *examine->selector = take == 1 ? item : (int16_t)-1;                                      /* 0x4ea2b1 / 0x4ea2ba */
    observe(host, INVEXAM_EFFECT_SELECTOR, *examine->selector);
    {
        Action79Result removed;
        status = action79_remove_item((uint16_t)item, &model->inventory, &host->inventory.inventory, &removed,
                                      failure);                                               /* 0x4ea2cb */
        if (status != ACTION79_OK) {
            return status;
        }
        out->removed = removed.found;
    }
    if (sound != 0) {
        observe(host, INVEXAM_EFFECT_SOUND, (int32_t)INVEXAM_SOUND_SLOT);
        out->sound_requested = 1u;
        if (host->request_sound(host->context, (uint16_t)INVEXAM_SOUND_SLOT) != 0) {          /* 0x4ea2dd */
            *failure = "sound request failed after the item was removed";
            return INVVIEW_ERR_HOST;
        }
    }
    out->request.scene_5bb57b = data->text[item];                                              /* 0x4ea2ef..0x4ea2f7 */
    out->request.word_5bb599 = 0;
    out->request.word_5bb595 = 0;
    out->request.word_5c39ff = examine->flag_word[item];                                       /* 0x4ea31c..0x4ea324 */
    out->request.dword_5bb59b = 0;
    out->request.dword_5bb59f = 0;
    out->request.dword_5bb5a3 = 1;
    out->request.mode_583999 = 4;                                                              /* 0x4ea349 */
    observe(host, INVEXAM_EFFECT_SCENE, out->request.scene_5bb57b);
    out->request_made = 1u;
    if (examine->host.scene_change(examine->host.context, &out->request) != 0) {
        *failure = "scene-change request was refused after the item was removed";
        return INVVIEW_ERR_HOST;
    }
    observe(host, INVEXAM_EFFECT_CLOSE, 0);                                                   /* 0x4ea356 */
    if (host->close_view != NULL && host->close_view(host->context) != 0) {
        *failure = "view teardown failed";
        inventory_view_close(view);
        out->closed = 1u;
        return INVVIEW_ERR_HOST;
    }
    inventory_view_close(view);
    out->closed = 1u;
    return INVVIEW_OK;
}
