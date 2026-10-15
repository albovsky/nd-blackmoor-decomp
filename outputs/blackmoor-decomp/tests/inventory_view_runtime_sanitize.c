/* RT-22: ASan/UBSan driver over bounded malformed inputs for inventory_view_runtime. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../src/inventory_view_runtime.h"

static unsigned long long state = 0x9e3779b97f4a7c15ull;
static unsigned rnd(void)
{
    state ^= state << 13;
    state ^= state >> 7;
    state ^= state << 17;
    return (unsigned)(state >> 16);
}

static int rebuild(void *c, int16_t item) { (void)c; (void)item; return (int)(rnd() % 11u == 0u); }
static int sound(void *c, uint16_t s) { (void)c; (void)s; return (int)(rnd() % 13u == 0u); }
static int ui(void *c, int16_t a, int32_t b, int16_t d) { (void)c; (void)a; (void)b; (void)d; return 0; }
static int closev(void *c) { (void)c; return (int)(rnd() % 17u == 0u); }

int main(void)
{
    enum { CAP = 70, GUARD = 8 };
    static uint8_t uiiv[INVVIEW_UIIV_BYTES + 64], inv[INVVIEW_INV_BYTES + 64];
    long iterations = 0, statuses[8] = {0};
    int round;
    {   /* wrapping extremes the original's 32-bit add/sub/imul tolerate (no signed-overflow UB) */
        InventoryViewLayout edge;
        InventoryView edge_view;
        int16_t edge_held = -1, edge_count = 3;
        uint16_t edge_items[CAP] = {0};
        int32_t edge_presence[CAP] = {0};
        Action79Model edge_model;
        const char *edge_why = NULL;
        const int32_t pages[] = {0x10000000, 0x7fffffff, INT32_MIN, -1, 0x08000000};
        size_t p;
        memset(&edge, 0, sizeof(edge));
        edge.rect[0][0] = INT32_MAX; edge.rect[0][2] = INT32_MAX; edge.rect[0][3] = INT32_MIN + 3;
        edge.rect[1][1] = INT32_MAX; edge.rect[1][3] = INT32_MAX;
        if (inventory_view_slot_hit(&edge, 0, 5, 5) != 0) return 2;
        if (inventory_view_slot_hit(&edge, 1, 5, 5) != 0) return 2;
        memset(&edge_model, 0, sizeof(edge_model));
        edge_model.held_item = &edge_held; edge_model.item_count = &edge_count;
        edge_model.items = edge_items; edge_model.item_capacity = CAP;
        edge_model.presence = edge_presence; edge_model.presence_capacity = CAP;
        for (p = 0; p < sizeof(pages) / sizeof(pages[0]); ++p) {
            inventory_view_init(&edge_view);
            edge_view.page = pages[p];
            (void)inventory_view_rebuild(&edge_view, &edge_model, &edge_why);
        }
    }
    for (round = 0; round < 20000; ++round) {
        InventoryViewLayout layout;
        InventoryView view;
        int16_t held, count, kind[INVVIEW_ITEMS], text[INVVIEW_ITEMS];
        uint16_t items[CAP + GUARD];
        int32_t presence[CAP + GUARD];
        uint32_t aux_a[CAP], aux_b[CAP];
        size_t i, len;
        Action78Model model;
        InventoryViewItemData data;
        InventoryViewHost host;
        InventoryViewClickResult result;
        const char *why = NULL;
        int opened, ran, status;

        for (i = 0; i < sizeof(uiiv); ++i) uiiv[i] = (uint8_t)rnd();
        for (i = 0; i < sizeof(inv); ++i) inv[i] = (uint8_t)rnd();
        len = (rnd() % 4u == 0u) ? rnd() % (INVVIEW_UIIV_BYTES + 32u) : INVVIEW_UIIV_BYTES;
        status = inventory_view_layout_from_uiiv(uiiv, len, (int32_t)rnd(), (int32_t)rnd(), &layout);
        if (status != INVVIEW_OK) { statuses[status & 7]++; memset(&layout, 0, sizeof(layout)); }
        len = (rnd() % 4u == 0u) ? rnd() % (INVVIEW_INV_BYTES + 32u) : INVVIEW_INV_BYTES;
        if (inventory_view_items_from_inv(inv, len, kind, text) != INVVIEW_OK) {
            memset(kind, 0, sizeof(kind)); memset(text, 0, sizeof(text));
        }
        for (i = 0; i < CAP + GUARD; ++i) { items[i] = (uint16_t)rnd(); presence[i] = (int32_t)(rnd() & 3u); }
        for (i = 0; i < CAP; ++i) { aux_a[i] = rnd() % 3u; aux_b[i] = rnd() % 3u; }
        held = (int16_t)((rnd() % 3u == 0u) ? -1 : (int)(rnd() % 80u) - 5);
        count = (int16_t)((int)(rnd() % 90u) - 8);
        memset(&model, 0, sizeof(model));
        model.inventory.held_item = &held;
        model.inventory.item_count = &count;
        model.inventory.items = items;
        model.inventory.item_capacity = CAP;
        model.inventory.presence = presence;
        model.inventory.presence_capacity = CAP;
        memset(&host, 0, sizeof(host));
        host.inventory.inventory.rebuild_view = (rnd() % 9u) ? rebuild : NULL;
        host.inventory.request_sound = sound;
        host.inventory.request_ui_animation = ui;
        host.request_sound = (rnd() % 9u) ? sound : NULL;
        host.close_view = closev;
        data.kind = kind; data.text = text; data.aux_a = aux_a; data.aux_b = aux_b;
        data.aux_count = CAP;
        inventory_view_init(&view);
        view.tab = (rnd() % 5u == 0u) ? (int32_t)(0x60 + rnd() % 14u) : -1;
        status = inventory_view_rebuild(&view, &model.inventory, &why);
        statuses[status & 7]++;
        view.tab = -1;
        for (i = 0; i < INVVIEW_SLOTS; ++i) view.slot_item[i] = (rnd() % 4u) ? (int32_t)(rnd() % 90u) - 10 : -1;
        view.screen_state = (rnd() % 8u) ? INVVIEW_STATE_NONE : INVVIEW_STATE_INVENTORY;
        (void)inventory_view_open(&view, &layout, &opened);
        if (rnd() % 4u == 0u) view.mode = (int32_t)(rnd() % 6u);
        (void)inventory_view_hover(&view, &layout, (int32_t)(rnd() % 400u), (int32_t)(rnd() % 400u),
                                   held, (int)(rnd() % 8u == 0u), &ran);
        if (rnd() % 5u == 0u) view.hot = (int32_t)(rnd() % 100u) - 20;
        view.event = (rnd() % 2u) ? INVVIEW_EVENT_PICK : INVVIEW_EVENT_PUT;
        model.view.mode = view.mode;
        model.view.slot_flag = layout.slot_flag;
        status = inventory_view_click(&view, &layout, &data, &model, &host, (int)(rnd() % 10u == 0u),
                                      &result, &why);
        statuses[status & 7]++;
        ++iterations;
        for (i = CAP; i < CAP + GUARD; ++i) {
            if (items[i] == 0xdead) { /* guards are random here; the run is for ASan/UBSan */ }
        }
    }
    printf("inventory_view_runtime sanitizer rounds=%ld statuses ok=%ld arg=%ld unsup=%ld bounds=%ld host=%ld unmodeled=%ld tab=%ld\n",
           iterations, statuses[0], statuses[1], statuses[2], statuses[3], statuses[4], statuses[5], statuses[6]);
    return 0;
}
