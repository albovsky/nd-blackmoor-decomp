#ifndef BLACKMOOR_SESSION_BINDINGS_A4B_H
#define BLACKMOOR_SESSION_BINDINGS_A4B_H

/* Session binding for raw action 0x4b (RT-39): a caption text row.
 *
 * Loader: case 0x4b of 0x40b34a (inline constructor 0x40c625..0x40caac, native model action_family_4b_construct). The
 * object is the LE16 length word (text length + 3), the text and the three-byte "<e>" marker. Selector -1 resolves a 33-byte
 * AUTOTEXT key through 0x423259 (a missing key becomes the original error string, as for raw 0x51); any other selector is an
 * inline byte count.
 * Runtime: case 0x4b of 0x427a50 (arm 0x428170..0x4281ce), gate mode 0 (the executor evaluates it; the handler runs for a true
 * gate). The arm calls the caption writer 0x448d11 on the text box 0x619a05 with the caption surface [0x5d03b3], the text at
 * object + 2, writer mode -1 (caption) and measure 0, then the generic completion 0x42ba3a(row). The caption writer is a host
 * callback (the app passes native_a51_write_caption, the same writer raw 0x51 uses); the binding owns the per-scene objects. */

#include "action_family_4b.h"
#include "action_family_51.h"
#include "scene_executor.h"
#include "scene_resource.h"

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A4B_TYPE ACTION_FAMILY_4B_RAW_TYPE

typedef struct SessionA4bBinding SessionA4bBinding;

typedef enum session_a4b_status {
    SESSION_A4B_OK = 0,
    SESSION_A4B_ERR_ARGUMENT = 1,
    SESSION_A4B_ERR_MEMORY = 2,
    /* A row's loader construction was fatal in the original (0x4c97b4) or is rejected by a native size limit. */
    SESSION_A4B_ERR_SCENE = 3
} SessionA4bStatus;

typedef enum session_a4b_row_state {
    SESSION_A4B_ROW_NOT_A4B = 0,
    SESSION_A4B_ROW_READY = 1,
    /* A key row while no AUTOTEXT lookup is bound: UNSUPPORTED if visited. */
    SESSION_A4B_ROW_UNSUPPORTED = 2
} SessionA4bRowState;

typedef enum session_a4b_write_status {
    SESSION_A4B_WRITE_OK = 0,
    /* The writer failed after it may have started (fatal in the original). */
    SESSION_A4B_WRITE_ERROR = 1,
    /* The host cannot present a caption (no renderer bound): nothing happened. */
    SESSION_A4B_WRITE_UNSUPPORTED = 2
} SessionA4bWriteStatus;

typedef struct session_a4b_host {
    void *context;
    /* 0x423259 on the AUTOTEXT table; REQUIRED for key rows (a missing hook makes those rows UNSUPPORTED). */
    ActionFamily51AutoTextLookup lookup;
    void *lookup_context;
    /* 0x448d11(0x619a05, [0x5d03b3], text, -1, 0): `text` is the object text including the "<e>" marker, `length` its byte
     * count (the object's length word). REQUIRED. */
    SessionA4bWriteStatus (*write_caption)(void *context, const uint8_t *text, size_t length);
} SessionA4bHost;

SessionA4bBinding *session_a4b_create(const SessionA4bHost *host);
void session_a4b_destroy(SessionA4bBinding *binding);

/* Builds the object of every 0x4b row of `scene`, replacing the previous scene's. On SESSION_A4B_ERR_SCENE, *failed_row and
 * *kernel_status (ACTION_FAMILY_4B_ERR_* or ACTION_FAMILY_51_LOOKUP_ERROR + 100) name the first failing row and the binding
 * keeps no objects. failed_row / kernel_status may be NULL. */
int session_a4b_begin_scene(SessionA4bBinding *binding, const SceneResource *scene, size_t *failed_row, int *kernel_status);

/* SceneActionExternalHandler for type 0x4b: writes the caption, then COMPLETED with phase 0 (the generic completion 0x42ba3a
 * derives the completion byte and the dependency reset from the subtype). A host that cannot present captions leaves the row
 * untouched (UNSUPPORTED); a failing writer is an ERROR. */
int session_a4b_handler(void *context, size_t action_index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *state_before, SceneActionHandlerResult *result);

/* Diagnostics. */
SessionA4bRowState session_a4b_row_state(const SessionA4bBinding *binding, size_t action_index);
/* The row's caption text (object + 2, including "<e>") and its length; NULL when the row has no object. */
const uint8_t *session_a4b_row_text(const SessionA4bBinding *binding, size_t action_index, size_t *length);
unsigned long session_a4b_writes(const SessionA4bBinding *binding);
const char *session_a4b_failure(const SessionA4bBinding *binding);

#ifdef __cplusplus
}
#endif

#endif
