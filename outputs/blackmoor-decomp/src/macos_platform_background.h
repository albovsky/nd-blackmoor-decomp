#ifndef BLACKMOOR_MACOS_PLATFORM_BACKGROUND_H
#define BLACKMOOR_MACOS_PLATFORM_BACKGROUND_H

#include "macos_platform.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Opt-in native host launch with an unshown window and no ordering, keying or
 * activation request. Uses the same main-thread, callback/context and lifecycle
 * contract as blackmoor_macos_open. The legacy opener remains foreground. */
BlackmoorMacPlatform *blackmoor_macos_open_background(
    const char *title, uint32_t logical_width, uint32_t logical_height,
    const BlackmoorPlatformCallbacks *callbacks, void *context,
    char *error, size_t error_capacity);

#ifdef __cplusplus
}
#endif
#endif
