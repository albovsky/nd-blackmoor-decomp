#include "inventory_view_runtime.h"

#include <string.h>

#define UIIV_RELATIVE_OFFSET 0x67u        /* view +0x6b87 - 0x6b20 */
#define UIIV_RECT_OFFSET 0x3f0u           /* view +0x6f10 - 0x6b20 */
#define UIIV_SLOT_FLAG_OFFSET 0x4f0u      /* view +0x7010 - 0x6b20 */
#define UIIV_CLOSE_FLAG_OFFSET 0x4f1u     /* view +0x7011 */
#define UIIV_PANEL_OFFSET 0x4f2u          /* view +0x7012 */
#define UIIV_PANEL_STRIDE 0xf7u
#define UIIV_PANEL_ID_OFFSET 4u           /* view +0x7016 - 0x7012 */
#define INV_RECORD_BASE 0xb1u             /* view +0x74e - 0x69d */
#define INV_RECORD_STRIDE 0x16du
#define INV_KIND_OFFSET 0x30u             /* view +0x77e - 0x74e */
#define INV_TEXT_OFFSET 0x32u
#define LIST_LIMIT 0x46                   /* 0x4e8554: index below 70 */
#define KIND_TEXT 3
#define TEXT_NONE_NORMAL 0x270f
#define HOT_MARGIN_X 11
#define HOT_MARGIN_Y 10

static int32_t rd32(const uint8_t *p)
{
    return (int32_t)((uint32_t)p[0] | ((uint32_t)p[1] << 8) | ((uint32_t)p[2] << 16) |
                     ((uint32_t)p[3] << 24));
}

static int16_t rd16(const uint8_t *p)
{
    return (int16_t)(uint16_t)((uint32_t)p[0] | ((uint32_t)p[1] << 8));
}

int inventory_view_layout_from_uiiv(const uint8_t *uiiv, size_t length, int32_t origin_x,
                                    int32_t origin_y, InventoryViewLayout *out)
{
    size_t i;
    if (uiiv == NULL || out == NULL || length < INVVIEW_UIIV_BYTES) {
        return INVVIEW_ERR_ARGUMENT;
    }
    memset(out, 0, sizeof(*out));
    out->relative = rd32(uiiv + UIIV_RELATIVE_OFFSET);
    out->slot_flag = uiiv[UIIV_SLOT_FLAG_OFFSET];
    out->close_flag = uiiv[UIIV_CLOSE_FLAG_OFFSET];
    out->first_tab = -1;
    for (i = 0; i < INVVIEW_SLOTS; ++i) {
        const uint8_t *r = uiiv + UIIV_RECT_OFFSET + 16u * i;
        /* 0x4e86ea: nonzero flag -> left/right += [0x583186], top/bottom += [0x58318a]
         * (x0 at +0, y0 at +4, x1 at +8, y1 at +0xc); zero -> the four dwords unchanged. */
        const int32_t dx = out->relative != 0 ? origin_x : 0;
        const int32_t dy = out->relative != 0 ? origin_y : 0;
        out->rect[i][0] = (int32_t)((uint32_t)rd32(r) + (uint32_t)dx);
        out->rect[i][1] = (int32_t)((uint32_t)rd32(r + 4) + (uint32_t)dy);
        out->rect[i][2] = (int32_t)((uint32_t)rd32(r + 8) + (uint32_t)dx);
        out->rect[i][3] = (int32_t)((uint32_t)rd32(r + 12) + (uint32_t)dy);
    }
    for (i = 0; i < INVVIEW_PANELS; ++i) {
        const uint8_t *panel = uiiv + UIIV_PANEL_OFFSET + UIIV_PANEL_STRIDE * i;
        if (rd32(panel) != 0) {
            out->first_tab = rd32(panel + UIIV_PANEL_ID_OFFSET);
            break;
        }
    }
    return INVVIEW_OK;
}

int inventory_view_items_from_inv(const uint8_t *inv, size_t length,
                                  int16_t kind[INVVIEW_ITEMS], int16_t text[INVVIEW_ITEMS])
{
    size_t i;
    if (inv == NULL || kind == NULL || text == NULL ||
        length < INV_RECORD_BASE + INV_RECORD_STRIDE * INVVIEW_ITEMS) {
        return INVVIEW_ERR_ARGUMENT;
    }
    for (i = 0; i < INVVIEW_ITEMS; ++i) {
        const uint8_t *rec = inv + INV_RECORD_BASE + INV_RECORD_STRIDE * i;
        kind[i] = rd16(rec + INV_KIND_OFFSET);
        text[i] = rd16(rec + INV_TEXT_OFFSET);
    }
    return INVVIEW_OK;
}

static void reset_state(InventoryView *view)
{
    /* 0x4e7ba7 */
    view->mode = 0;
    view->tab = -1;
    view->tab_applied = -1;
    view->page = 0;
}

void inventory_view_init(InventoryView *view)
{
    size_t i;
    if (view == NULL) {
        return;
    }
    memset(view, 0, sizeof(*view));
    reset_state(view);
    view->hot = -1;
    view->event = -1;
    for (i = 0; i < INVVIEW_SLOTS; ++i) {
        view->slot_item[i] = -1;
        view->slot_lit[i] = 0;
    }
}

int inventory_view_rebuild(InventoryView *view, const Action79Model *inventory, const char **failure)
{
    size_t i;
    int32_t base, count;
    if (failure != NULL) {
        *failure = "none";
    }
    if (view == NULL || inventory == NULL || inventory->item_count == NULL || inventory->items == NULL) {
        if (failure != NULL) {
            *failure = "invalid rebuild arguments";
        }
        return INVVIEW_ERR_ARGUMENT;
    }
    if (view->tab >= 0x65 && view->tab <= 0x69) {
        if (failure != NULL) {
            *failure = "tab list 0x65..0x69 (derived lists 0x583abd/0x583b49) is not modelled";
        }
        return INVVIEW_ERR_TAB;
    }
    count = (int32_t)*inventory->item_count;
    base = (int32_t)((uint32_t)view->page * 16u);     /* 32-bit imul/add wrap, no signed UB */
    for (i = 0; i < INVVIEW_SLOTS; ++i) {
        view->slot_item[i] = -1;                      /* 0x4e8177 */
    }
    for (i = 0; i < INVVIEW_SLOTS; ++i) {
        const int32_t index = (int32_t)((uint32_t)base + (uint32_t)i);   /* [ebp-4] */
        if (index < LIST_LIMIT && index < count) {    /* 0x4e8554, signed compares */
            if (index < 0 || (size_t)index >= inventory->item_capacity) {
                if (failure != NULL) {
                    *failure = "slot index outside the modeled item array";
                }
                return INVVIEW_ERR_BOUNDS;
            }
            view->slot_item[i] = (int16_t)inventory->items[index];   /* movsx word */
        }
    }
    return INVVIEW_OK;
}

int inventory_view_open(InventoryView *view, const InventoryViewLayout *layout, int *opened)
{
    if (view == NULL || layout == NULL || opened == NULL) {
        return INVVIEW_ERR_ARGUMENT;
    }
    *opened = 0;
    if (view->screen_state != INVVIEW_STATE_NONE) {
        return INVVIEW_OK;                            /* 0x43a862: state must be 0 */
    }
    view->screen_state = INVVIEW_STATE_INVENTORY;     /* 0x43a87c */
    reset_state(view);                                /* 0x4e8622 -> 0x4e7ba7 */
    /* 0x4e88fc: tab := first enabled panel's id when the tab is still -1; the
     * applied tab is set to the same value, so no rebuild follows. */
    if (view->tab == -1) {
        view->tab = layout->first_tab;
        view->tab_applied = layout->first_tab;
    }
    view->mode = INVVIEW_MODE_OPEN;                   /* end state of 0x4e94c1 (transition not recovered) */
    *opened = 1;
    return INVVIEW_OK;
}

int inventory_view_slot_hit(const InventoryViewLayout *layout, size_t slot, int32_t px, int32_t py)
{
    if (layout == NULL || slot >= INVVIEW_SLOTS) {
        return 0;
    }
    /* 0x4e8c62..0x4e8cea, signed compares on dwords. */
    /* The add and sub wrap in 32 bits like the original's; done unsigned to avoid signed UB. */
    if (px < (int32_t)((uint32_t)layout->rect[slot][0] + (uint32_t)HOT_MARGIN_X)) return 0;
    if (px > layout->rect[slot][2]) return 0;
    if (py < (int32_t)((uint32_t)layout->rect[slot][1] + (uint32_t)HOT_MARGIN_Y)) return 0;
    if (py > (int32_t)((uint32_t)layout->rect[slot][3] - (uint32_t)HOT_MARGIN_Y)) return 0;
    return 1;
}

void inventory_view_cursor_choice(int16_t held_item, int32_t override, int32_t held_flag,
                                  int32_t *index, int32_t *variant)
{
    int32_t i, v = 0;
    if (override != 0 || held_item == -1) {
        i = 4;                                         /* 0x4ee2b9 / 0x4ee2e8 */
    } else if (held_flag != 0) {
        i = 9;                                         /* 0x4ee31f */
    } else {
        i = (int32_t)held_item + 0x25;                 /* 0x4ee356 */
    }
    if (index != NULL) *index = i;
    if (variant != NULL) *variant = v;
}

int inventory_view_cursor_hotspot(const uint8_t *curs, size_t length, int32_t index,
                                  int32_t variant, int32_t *dx, int32_t *dy)
{
    const size_t offset = 0x1ac0u + (size_t)index * 16u + (size_t)variant * 8u;
    if (curs == NULL || dx == NULL || dy == NULL || index < 0 || index >= 107 || variant < 0 ||
        variant > 1 || length < 8580u) {
        return INVVIEW_ERR_ARGUMENT;
    }
    *dx = rd32(curs + offset);
    *dy = rd32(curs + offset + 4u);
    return INVVIEW_OK;
}

int inventory_view_hover(InventoryView *view, const InventoryViewLayout *layout, int32_t px,
                         int32_t py, int16_t held_item, int frame_consumed, int *hover_ran)
{
    size_t i;
    if (view == NULL || layout == NULL || hover_ran == NULL) {
        return INVVIEW_ERR_ARGUMENT;
    }
    *hover_ran = 0;
    if (view->screen_state != INVVIEW_STATE_INVENTORY ||
        (view->mode != 2 && view->mode != 3)) {
        return INVVIEW_OK;                            /* 0x4d30xx switch, 0x4e89f5 */
    }
    /* 0x4e8a12: 0x4ee2a9 runs first and stores variant 0 into 0x5b44f4 on every one of
     * its paths (0x4ee2c3, 0x4ee2f2, 0x4ee329, 0x4ee365). The RT-22 oracle found the
     * stale 1 of an earlier hit surviving a miss before this store was modeled. */
    view->cursor_variant = 0;
    if (frame_consumed != 0) {
        return INVVIEW_OK;                            /* 0x4e8a17: 0x4ee2a9 != 0, 0x4e8a1b */
    }
    *hover_ran = 1;
    view->hot = -1;                                   /* 0x4e8bbe */
    view->event = held_item == -1 ? INVVIEW_EVENT_PICK : INVVIEW_EVENT_PUT;   /* 0x4e8bc8.. */
    for (i = 0; i < INVVIEW_SLOTS; ++i) {
        if (view->slot_item[i] != -1 && inventory_view_slot_hit(layout, i, px, py)) {
            view->cursor_variant = 1;                 /* 0x4e8cec */
            view->hot = view->slot_item[i];
            view->slot_lit[i] = 1;
            return INVVIEW_OK;                        /* first hit ends the scan */
        }
        view->slot_lit[i] = 0;
    }
    return INVVIEW_OK;
}

static void observe(const InventoryViewHost *host, int effect, int32_t value)
{
    if (host != NULL && host->inventory.inventory.observe != NULL) {
        host->inventory.inventory.observe(host->inventory.inventory.context, effect, value);
    }
}

void inventory_view_close(InventoryView *view)
{
    if (view == NULL) {
        return;
    }
    reset_state(view);                                /* 0x4e7bf3 -> 0x4e7ba7 */
    view->screen_state = INVVIEW_STATE_NONE;          /* 0x4e7d1b */
}

static int sound(const InventoryViewHost *host, uint16_t slot, InventoryViewClickResult *result)
{
    observe(host, INVVIEW_EFFECT_SOUND, (int32_t)slot);
    result->sound_requests = (uint8_t)(result->sound_requests + 1u);
    if (host->request_sound(host->context, slot) != 0) {
        return INVVIEW_ERR_HOST;
    }
    return INVVIEW_OK;
}

int inventory_view_click(InventoryView *view, const InventoryViewLayout *layout,
                         const InventoryViewItemData *data, const Action78Model *model,
                         const InventoryViewHost *host, int frame_consumed,
                         InventoryViewClickResult *result, const char **failure)
{
    const Action79Model *inv;
    int32_t hot;
    int status;
    if (failure != NULL) {
        *failure = "none";
    }
    if (view == NULL || layout == NULL || data == NULL || model == NULL || host == NULL ||
        result == NULL || model->inventory.held_item == NULL) {
        if (failure != NULL) {
            *failure = "invalid click arguments";
        }
        return INVVIEW_ERR_ARGUMENT;
    }
    memset(result, 0, sizeof(*result));
    inv = &model->inventory;
    /* 0x4e8dc8: only modes 2 and 3 of the open inventory screen; a nonzero return of
     * 0x4ee517 or of a tab button 0x4e26fc ends the visit before 0x4e8e78. */
    if (view->screen_state != INVVIEW_STATE_INVENTORY || (view->mode != 2 && view->mode != 3) ||
        frame_consumed != 0) {
        return INVVIEW_OK;
    }
    result->gate_open = 1u;
    hot = view->hot;
    if (hot != -1) {
        /* Every table below is indexed by the signed hot item (dword): reject what
         * the original would read outside the recovered 70-entry tables. */
        if (hot < 0 || (size_t)hot >= INVVIEW_ITEMS || data->kind == NULL || data->text == NULL ||
            data->aux_a == NULL || data->aux_b == NULL || (size_t)hot >= data->aux_count) {
            if (failure != NULL) {
                *failure = "hot item outside the item/auxiliary tables";
            }
            return INVVIEW_ERR_BOUNDS;
        }
        /* 0x4e8e97..0x4e8f0c: read/examine branch. */
        if (data->kind[hot] == KIND_TEXT && data->text[hot] != 0 &&
            data->text[hot] != TEXT_NONE_NORMAL && data->aux_a[hot] == 0u) {
            if (failure != NULL) {
                *failure = "read/examine branch 0x4e8f0e (0x4ea269) is not implemented";
            }
            return INVVIEW_ERR_UNMODELED;
        }
        /* 0x4e8f32..0x4e8f67: use branch. */
        if (data->aux_a[hot] == 1u && data->aux_b[hot] == 1u) {
            if (failure != NULL) {
                *failure = "use/text branch 0x4e8f6d is not implemented";
            }
            return INVVIEW_ERR_UNMODELED;
        }
    }
    if (view->event == INVVIEW_EVENT_PICK && hot != -1 && data->aux_a[hot] == 0u &&
        *inv->held_item == -1) {
        /* 0x4e93da..0x4e945a */
        const int16_t old_held = *inv->held_item;
        Action79Result removed;
        const char *why = "none";
        if (host->request_sound == NULL) {
            if (failure != NULL) {
                *failure = "sound request provider (0x4fb2e3)";
            }
            return INVVIEW_ERR_UNSUPPORTED;
        }
        observe(host, INVVIEW_EFFECT_PICK, hot);
        *inv->held_item = (int16_t)hot;               /* 0x4e941b: low word of the dword */
        observe(host, ACTION78_EFFECT_HELD, (int16_t)hot);
        status = action79_remove_item((uint16_t)(int16_t)hot, inv, &host->inventory.inventory,
                                      &removed, &why);
        if (status != ACTION79_OK) {
            if (status != ACTION79_ERR_HOST) {
                *inv->held_item = old_held;           /* rejected before any effect */
            }
            if (failure != NULL) {
                *failure = why;
            }
            return status;
        }
        result->removed = removed.found;
        status = sound(host, INVVIEW_SOUND_PICK, result);
        if (status != INVVIEW_OK) {
            if (failure != NULL) {
                *failure = "sound request failed after the item was picked up";
            }
            return status;
        }
        result->picked = 1u;
        if (layout->close_flag != 0) {                /* 0x4e9443 */
            observe(host, INVVIEW_EFFECT_CLOSE, 0);
            if (host->close_view != NULL && host->close_view(host->context) != 0) {
                if (failure != NULL) {
                    *failure = "view teardown failed";
                }
                inventory_view_close(view);
                return INVVIEW_ERR_HOST;
            }
            inventory_view_close(view);
            result->closed = 1u;
        }
        result->handled = 1u;
        return INVVIEW_OK;
    }
    if (view->event == INVVIEW_EVENT_PUT && *inv->held_item != -1) {
        /* 0x4e9468..0x4e949a */
        Action78Result added;
        const char *why = "none";
        Action78Model local = *model;
        const int16_t held = *inv->held_item;
        local.view.mode = view->mode;                 /* the add step reads the live view */
        local.view.slot_flag = layout->slot_flag;
        if (host->request_sound == NULL) {
            if (failure != NULL) {
                *failure = "sound request provider (0x4fb2e3)";
            }
            return INVVIEW_ERR_UNSUPPORTED;
        }
        observe(host, INVVIEW_EFFECT_PUT, held);
        status = action78_add_item(held, 1, &local, &host->inventory, &added, &why);
        if (status != ACTION78_OK) {
            if (failure != NULL) {
                *failure = why;
            }
            return status;
        }
        result->added = added.added;
        *inv->held_item = -1;                         /* 0x4e9485 */
        observe(host, ACTION78_EFFECT_HELD, -1);
        status = sound(host, INVVIEW_SOUND_PUT, result);
        if (status != INVVIEW_OK) {
            if (failure != NULL) {
                *failure = "sound request failed after the item was put back";
            }
            return status;
        }
        result->put_back = 1u;
        result->handled = 1u;
        return INVVIEW_OK;
    }
    return INVVIEW_OK;                                /* 0x4e94a1 */
}
