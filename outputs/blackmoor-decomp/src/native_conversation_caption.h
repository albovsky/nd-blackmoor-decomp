#ifndef BLACKMOOR_NATIVE_CONVERSATION_CAPTION_H
#define BLACKMOOR_NATIVE_CONVERSATION_CAPTION_H
#include "caption_layout.h"
#include "action_family_3f_runtime.h"
#ifdef __cplusplus
extern "C" {
#endif
typedef struct {
    int16_t rect[4]; /* original signed16 backing-surface rectangle */
    uint8_t sound_name[33];
} NativeConversationChoice;
typedef struct {
    uint32_t glyphs[2];
    int16_t scroll_lines;
    int16_t bottom[2];
    int16_t response_count;
    NativeConversationChoice choices[CONVO3F_MAX_RESPONSES];
} NativeConversationCaptionResult;
/* Caption branch of 0x41e3c0/0x41e647/0x41f5b1. Uses the original
 * TBOX/FONT and glyph primitives. Supported caption markup: i/o, c, n, w, e.
 * Other markup and non-progressing word wrapping are explicitly refused.
 * Callers supply private staging surfaces; publish them only on success.
 * No complete original UI parity claim. */
/* Geometry/markup preflight; no sheet callbacks or visible effects. */
int native_conversation_caption_validate(const uint8_t *text, size_t length,
    const CaptionFonts *fonts, const CaptionGeometry *geometry,
    const CaptionPixelFormat *format);
int native_conversation_caption_write(const uint8_t *text, size_t length,
    const CaptionFonts *fonts, const CaptionGeometry *geometry,
    const CaptionPixelFormat *format, CaptionGlobals *globals,
    const CaptionBackend *backend, CaptionSurface surfaces[2],
    NativeConversationCaptionResult *result);
/* 0x41e3c0 response builder and h/s subset of 0x41e647. Uses the already
 * eligible kernel list; never evaluates story conditions or chooses a response.
 * captions_enabled controls the original i..o caption span. */
int native_conversation_choices_validate(const Convo3fLayoutRequest *request,
    int captions_enabled, const CaptionFonts *fonts, const CaptionGeometry *geometry,
    const CaptionPixelFormat *format);
int native_conversation_choices_write(const Convo3fLayoutRequest *request,
    int captions_enabled, const CaptionFonts *fonts, const CaptionGeometry *geometry,
    const CaptionPixelFormat *format, CaptionGlobals *globals,
    const CaptionBackend *backend, CaptionSurface surfaces[2],
    NativeConversationCaptionResult *result);
#ifdef __cplusplus
}
#endif
#endif
