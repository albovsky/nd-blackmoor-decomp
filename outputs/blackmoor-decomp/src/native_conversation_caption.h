#ifndef BLACKMOOR_NATIVE_CONVERSATION_CAPTION_H
#define BLACKMOOR_NATIVE_CONVERSATION_CAPTION_H
#include "caption_layout.h"
#ifdef __cplusplus
extern "C" {
#endif
typedef struct {
    uint32_t glyphs[2];
    int16_t scroll_lines;
    int16_t bottom[2];
} NativeConversationCaptionResult;
/* Zero-response branch of 0x41e3c0/0x41e647/0x41f5b1. Uses the original
 * TBOX/FONT and glyph primitives. Supported markup: i/o (no-op), c, n, w, e.
 * Other markup and non-progressing word wrapping are explicitly refused.
 * Callers supply private staging surfaces; publish them only on success.
 * No response/hotspot, scrolling-input or complete original UI parity claim. */
/* Geometry/markup preflight; no sheet callbacks or visible effects. */
int native_conversation_caption_validate(const uint8_t *text, size_t length,
    const CaptionFonts *fonts, const CaptionGeometry *geometry,
    const CaptionPixelFormat *format);
int native_conversation_caption_write(const uint8_t *text, size_t length,
    const CaptionFonts *fonts, const CaptionGeometry *geometry,
    const CaptionPixelFormat *format, CaptionGlobals *globals,
    const CaptionBackend *backend, CaptionSurface surfaces[2],
    NativeConversationCaptionResult *result);
#ifdef __cplusplus
}
#endif
#endif
