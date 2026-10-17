#ifndef BLACKMOOR_MACOS_PLATFORM_H
#define BLACKMOOR_MACOS_PLATFORM_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct BlackmoorMacPlatform BlackmoorMacPlatform;
typedef enum blackmoor_pointer_kind {
    BLACKMOOR_POINTER_MOVE = 0,
    BLACKMOOR_POINTER_DOWN = 1,
    BLACKMOOR_POINTER_UP = 2
} BlackmoorPointerKind;

typedef struct blackmoor_platform_callbacks {
    void (*tick)(void *context, uint32_t monotonic_ms);
    /* Logical surface coordinates, with origin at top left. Button 0 is left,
     * 1 is right. Coordinates outside a letterboxed surface remain outside. */
    void (*pointer)(void *context, BlackmoorPointerKind kind,
                    int32_t x, int32_t y, unsigned button);
    /* Windows-style virtual-key values at the recovered engine boundary. */
    void (*key)(void *context, unsigned virtual_key, int down, int repeat);
    /* Typed ANSI characters (the WM_CHAR level): one call per character of the key event, high-bit characters as negative
     * values. Optional (may be NULL). */
    void (*character)(void *context, int8_t ch);
    void (*closed)(void *context);
} BlackmoorPlatformCallbacks;

/* Native host adapter, not recovered original engine code. All functions must
 * be called on the main thread. Context remains borrowed until close. */
BlackmoorMacPlatform *blackmoor_macos_open(
    const char *title, uint32_t logical_width, uint32_t logical_height,
    const BlackmoorPlatformCallbacks *callbacks, void *context,
    char *error, size_t error_capacity);
/* Copy an opaque RGBA8 engine framebuffer; source may be released afterwards. */
int blackmoor_macos_present(BlackmoorMacPlatform *platform,
                            const uint8_t *rgba, size_t capacity, size_t row_bytes);
void blackmoor_macos_run(BlackmoorMacPlatform *platform);
void blackmoor_macos_stop(BlackmoorMacPlatform *platform);
void blackmoor_macos_set_title(BlackmoorMacPlatform *platform, const char *title);
/* Destroy only after run has returned, never from an engine callback. */
void blackmoor_macos_close(BlackmoorMacPlatform *platform);
uint32_t blackmoor_macos_monotonic_ms(void);

#ifdef __cplusplus
}
#endif
#endif
