#ifndef BLACKMOOR_NATIVE_INVENTORY_RENDER_H
#define BLACKMOOR_NATIVE_INVENTORY_RENDER_H

#include "inventory_view_runtime.h"

#define NATIVE_INV_BLITS 32u
#define NATIVE_INV_CLOSE_SOUND 0x1f5u

typedef struct { int32_t left, top, right, bottom; } NativeInventoryRect;
typedef struct {
    unsigned items;
    NativeInventoryRect source, destination;
} NativeInventoryBlit;
typedef struct {
    NativeInventoryBlit blits[NATIVE_INV_BLITS];
    size_t count;
} NativeInventoryPlan;
typedef struct {
    unsigned enabled;
    NativeInventoryRect rectangle;
    uint32_t delay_ms;
    uint16_t channel;
} NativeInventoryClose;

enum { NATIVE_INV_OK, NATIVE_INV_INVALID, NATIVE_INV_UNSUPPORTED };

#ifdef __cplusplus
extern "C" {
#endif
/* Host composition plan for the shipped mode 2/3, tab 100, page 0. Rectangles
 * and opaque-copy order follow 0x4e97ad/0x4ee86f. No frame-animation, derived
 * tab, paging, cursor-sprite or complete original framebuffer parity claim. */
int native_inventory_names(const uint8_t *uiiv, size_t uiiv_bytes,
                           const uint8_t *inv, size_t inv_bytes,
                           char frame[33], char items[33]);
int native_inventory_close_control(const uint8_t *uiiv, size_t bytes,
                                   int32_t origin_x, int32_t origin_y,
                                   NativeInventoryClose *out);
/* Entire plan is validated before publication; failure leaves out unchanged. */
int native_inventory_plan(const uint8_t *uiiv, size_t uiiv_bytes,
                          const uint8_t *inv, size_t inv_bytes,
                          const InventoryView *view, const InventoryViewLayout *layout,
                          int32_t origin_x, int32_t origin_y, int close_state,
                          uint32_t frame_width, uint32_t frame_height,
                          uint32_t item_width, uint32_t item_height,
                          NativeInventoryPlan *out);
#ifdef __cplusplus
}
#endif
#endif
