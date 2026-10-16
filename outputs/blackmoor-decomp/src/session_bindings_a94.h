#ifndef BLACKMOOR_SESSION_BINDINGS_A94_H
#define BLACKMOOR_SESSION_BINDINGS_A94_H

#include <stddef.h>
#include <stdint.h>

#include "action_family_94.h"
#include "action_family_94_runtime.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A94_TYPE ACTION_FAMILY_94_RAW_TYPE

typedef struct SessionA94Binding SessionA94Binding;

/* Display state of one capture: the pixel layout plus the two strings the original passes to _makepath as drive and
 * directory (DAT_00639a9f, DAT_00639aa2). */
typedef struct session_a94_display {
    A94Screen screen;
    char drive[8];
    char dir[256];
} SessionA94Display;

typedef struct session_a94_host {
    void *context;
    /* All REQUIRED; without one the visit is UNSUPPORTED before any effect. */
    /* DAT_005839a9 (written 1 at phase 0 and 0 when the capture ends). */
    void (*set_capture_flag)(void *context, int32_t value);
    /* 0x4d36ed: dword 0x5831c8 := 1, word 0x5831c6 := 0 (a full redraw is requested). */
    void (*request_refresh)(void *context);
    /* The display state read by the capture; nonzero = unavailable. */
    int (*display)(void *context, SessionA94Display *out);
    /* The front buffer as 0x4c4067 + 0x43f04b deliver it: width * height * bytes_per_pixel bytes, rows packed. */
    int (*capture)(void *context, uint8_t *dst, size_t bytes);
    /* fopen(path, "wb") + fwrite + fclose of the whole file; nonzero = the file could not be created (the original
     * ignores that silently). */
    int (*write_file)(void *context, const char *path, const uint8_t *bytes, size_t length);
} SessionA94Host;

/* Raw 0x94 (RT-32; dispatcher arm 0x429747, gate mode 0, handler 0x4c36b2). Phase 0: capture flag := 1, refresh
 * request, phase := 2. Phase 2: while the rectangle exceeds the screen nothing happens; otherwise the front buffer is
 * captured, cropped, written as a BMP (body format 0) or TGA file, the capture flag is cleared and phase := 3. Phase 3:
 * the generic completion 0x42ba3a (subtype behaviour, phase := 0). Any other phase value does nothing. */
SessionA94Binding *session_a94_create(const SessionA94Host *host);
void session_a94_destroy(SessionA94Binding *);
int session_a94_handler(void *, size_t, const SceneActionInfo *, const SceneActionRuntimeState *,
                        SceneActionHandlerResult *);
const char *session_a94_failure(const SessionA94Binding *);
/* Diagnostics: files the host accepted, files it refused, and the last path written. */
unsigned long session_a94_files_written(const SessionA94Binding *);
unsigned long session_a94_files_refused(const SessionA94Binding *);
const char *session_a94_last_path(const SessionA94Binding *);

#ifdef __cplusplus
}
#endif
#endif
