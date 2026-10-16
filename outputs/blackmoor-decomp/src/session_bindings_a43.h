#ifndef BLACKMOOR_SESSION_BINDINGS_A43_H
#define BLACKMOOR_SESSION_BINDINGS_A43_H

#include <stddef.h>
#include <stdint.h>

#include "action_family_43.h"
#include "autotext_writer.h"
#include "scene_executor.h"
#include "session_bindings_a36.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A43_TYPE ACTION_FAMILY_43_RAW_TYPE

typedef struct SessionA43Binding SessionA43Binding;

/* What the text writer needs from the caption side of the host: the BOOT FONT
 * table, the display pixel format and the shared font-sheet reference state
 * (the same CaptionGlobals the closed-caption writer 0x448d11 uses). */
typedef struct session_a43_render_inputs {
    const CaptionFonts *fonts;
    CaptionPixelFormat format;
    CaptionGlobals *font_state;
} SessionA43RenderInputs;

typedef enum session_a43_effect {
    SESSION_A43_FX_RENDERED = 1, /* a = surface index, b = text bytes */
    SESSION_A43_FX_CONVERTED = 2 /* a = row, b = surface index (0x411f24 tail) */
} SessionA43Effect;

typedef struct session_a43_host {
    void *context;
    /* AUTOTEXT lookup (0x423259) of a keyed row. Returns 0 and a NUL-terminated
     * text of `*length` visible bytes when the key exists; nonzero otherwise. */
    int (*lookup)(void *context, const uint8_t *key, size_t key_length, const uint8_t **text,
                  size_t *length);
    /* Fonts, pixel format and font-sheet state; nonzero = unavailable. */
    int (*render_inputs)(void *context, SessionA43RenderInputs *out);
    /* Surface and font-sheet callbacks of the writer (context field is used as is). */
    AutotextBackend backend;
    /* Optional ordered observer. */
    void (*observe)(void *context, int effect, int32_t a, int32_t b);
    /* Test seam: when set, called INSTEAD of the recovered writer (and of
     * render_inputs) with the object (entry = the 301-byte prefix, text at +301,
     * `text_capacity` bytes including the NUL). Nonzero = the render failed.
     * Production hosts leave it NULL; the 0x411f24 oracle uses it to compare
     * what the handler hands to 0x413187 (the writer has its own oracle). */
    int (*write_text)(void *context, uint8_t *entry, const char *text, size_t text_capacity);
} SessionA43Host;

/* `a36` serves the converted rows afterwards (the original stores runtime type
 * 0x36 and the overlay arm takes over); it must outlive the binding. */
SessionA43Binding *session_a43_create(const SessionA43Host *host, SessionA36Binding *a36);
void session_a43_destroy(SessionA43Binding *);

/* Raw 0x43 (RT-32; dispatcher arm gate mode 0, handler 0x411f24).
 *
 * First visit: the text of the row (inline or AUTOTEXT key) is rendered into
 * the AUTOTEXT surface slot of the row's surface index by the recovered writer
 * 0x413187, the generic completion 0x42ba3a runs (only its subtype-2 dependency
 * reset is observable, because the completion byte is cleared right after), and
 * the row becomes a runtime-0x36 overlay named USE_AUTOTEXT<index+1> with
 * subtype 1 and phase 0 (the 0xABA image is built like the raw 0x37 one:
 * 0x48945b defaults over the row's rectangle at +0xe9, options at +0 and +0xe7,
 * geometry at +0xf9). The result is PENDING_BECOME_OVERLAY36 (or
 * RESET_BECOME_OVERLAY36 for subtype 2). Later visits are served by the 0x36
 * binding; its generic completion uses subtype 1 whatever the raw subtype was.
 * A refused render, a missing key or a missing provider is UNSUPPORTED before
 * any row change. */
int session_a43_handler(void *, size_t, const SceneActionInfo *,
                        const SceneActionRuntimeState *, SceneActionHandlerResult *);
const char *session_a43_failure(const SessionA43Binding *);

/* The AUTOTEXT surface slot k (0..5, globals 0x5d0397 + 4k); pixels NULL = none. */
const CaptionSurface *session_a43_slot(const SessionA43Binding *, size_t k);
unsigned long session_a43_rendered(const SessionA43Binding *);

#ifdef __cplusplus
}
#endif
#endif
