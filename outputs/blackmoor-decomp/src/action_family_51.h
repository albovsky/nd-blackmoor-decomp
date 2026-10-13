#ifndef BLACKMOOR_ACTION_FAMILY_51_H
#define BLACKMOOR_ACTION_FAMILY_51_H

/* Raw action 0x51, the original AT_MULTI_TEXTBOX_WRITE action.
 *
 * Loader: case 0x51 of 0x40b34a (code 0x40caac..0x40cf87).
 * Runtime: case 0x51 of 0x427a50 (code 0x4281d3..0x42842c).
 * The loader stores the raw ACT type byte unchanged in the action slot
 * (0x40b415); there is no runtime-type alias for this family.
 */

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_51_TYPE UINT8_C(0x51)

/* Body: five header words copied verbatim, then the signed text selector. */
#define ACTION_FAMILY_51_HEADER_BYTES 10u
#define ACTION_FAMILY_51_SELECTOR_OFFSET 10u
#define ACTION_FAMILY_51_TEXT_OFFSET 12u
/* Selector -1 names a 33-byte AUTOTEXT key; the loader advances 0x2d bytes. */
#define ACTION_FAMILY_51_AUTO_TEXT_SELECTOR INT16_C(-1)
#define ACTION_FAMILY_51_AUTO_TEXT_KEY_BYTES 33u
#define ACTION_FAMILY_51_AUTO_TEXT_BODY_BYTES 45u
/* Any other selector is an inline byte count; 10000 and above is fatal. */
#define ACTION_FAMILY_51_MAX_INLINE_BYTES 9999
/* Resolved AUTOTEXT longer than 40000 bytes is fatal in the loader. */
#define ACTION_FAMILY_51_MAX_AUTO_TEXT_BYTES 40000u
/* The loader appends this marker (0x53f650..0x53f700 constants). */
#define ACTION_FAMILY_51_TERMINATOR "<e>"
#define ACTION_FAMILY_51_TERMINATOR_BYTES 3u
/* sprintf format at 0x53f568, used when the AUTOTEXT key is missing. */
#define ACTION_FAMILY_51_MISSING_FORMAT \
    "Game Error (please contact Tech Support) missing auto text: %s<n>"
/* Largest runtime record whose 16-bit allocation size stays positive. */
#define ACTION_FAMILY_51_MAX_PAYLOAD_BYTES 32767u

typedef enum action_family_51_status {
    ACTION_FAMILY_51_OK = 0,
    ACTION_FAMILY_51_ERR_ARGUMENT = 1,
    /* Truncated body or a selector the original treats as fatal/undefined. */
    ACTION_FAMILY_51_ERR_BODY = 2,
    /* The original would fail its 16-bit sized allocation or overflow. */
    ACTION_FAMILY_51_ERR_LIMIT = 3,
    ACTION_FAMILY_51_ERR_UNSUPPORTED = 4,
    ACTION_FAMILY_51_ERR_BACKEND = 5
} ActionFamily51Status;

typedef enum action_family_51_text_source {
    ACTION_FAMILY_51_TEXT_INLINE = 0,
    ACTION_FAMILY_51_TEXT_AUTO_TEXT = 1,
    /* Key absent from AUTOTEXT: the 0x53f568 message replaces the text. */
    ACTION_FAMILY_51_TEXT_MISSING_AUTO_TEXT = 2
} ActionFamily51TextSource;

/* Header word 0. The runtime overwrites 0 with 1 or 2 on first execution. */
typedef enum action_family_51_renderer {
    ACTION_FAMILY_51_RENDERER_AUTO = 0,
    /* 0x4de24f(2, text) on the 0x61f864 frame text-box object. */
    ACTION_FAMILY_51_RENDERER_FRAME_TEXT_BOX = 1,
    /* 0x448d11(*0x5d03b3, text, -1, 0) on the 0x619a05 caption object. */
    ACTION_FAMILY_51_RENDERER_CAPTION_TEXT_BOX = 2
} ActionFamily51Renderer;

/* Header word 1. Other values never complete from this handler. */
typedef enum action_family_51_wait {
    ACTION_FAMILY_51_WAIT_NONE = 0,
    /* Completes once 0x4f6334(word 2) reports the channel is not playing. */
    ACTION_FAMILY_51_WAIT_SOUND_CHANNEL = 1,
    /* Completes once GetTickCount() exceeds the shared 0x5bb226 deadline. */
    ACTION_FAMILY_51_WAIT_TIMER = 2
} ActionFamily51Wait;

/* Executor phase stored at slot +0x4f (0x5bb632). */
typedef enum action_family_51_phase {
    ACTION_FAMILY_51_PHASE_START = 0,
    ACTION_FAMILY_51_PHASE_WAIT = 1,
    ACTION_FAMILY_51_PHASE_FINISH = 2
} ActionFamily51Phase;

typedef enum action_family_51_lookup_status {
    ACTION_FAMILY_51_LOOKUP_FOUND = 0,
    ACTION_FAMILY_51_LOOKUP_NOT_FOUND = 1,
    ACTION_FAMILY_51_LOOKUP_ERROR = 2
} ActionFamily51LookupStatus;

/* Resolves a key (original 0x423259 on table 0x619a6b). The key is NUL-free
 * and may be empty; the original always performs the lookup. Matching must
 * follow the original ASCII case-insensitive comparison (0x50d0bc on both
 * strings), as autotext_lookup does. Returned bytes are the C-string caption
 * (excluding NUL), borrowed for the duration of the call. */
typedef ActionFamily51LookupStatus (*ActionFamily51AutoTextLookup)(
    void *context, const uint8_t *key, size_t key_length,
    const uint8_t **text, size_t *text_length);

/* Decoded view of the original runtime record. The record itself is the
 * exact allocation the loader builds:
 *   +0  int16 renderer, +2 int16 wait, +4 int16 sound channel,
 *   +6  uint32 wait milliseconds (GetTickCount delta),
 *   +10 uint16 text length (includes the "<e>" marker),
 *   +12 text bytes, then a NUL for AUTOTEXT sources only. */
typedef struct action_family_51_decoded {
    ActionFamily51TextSource source;
    int16_t selector;
    int16_t renderer;
    int16_t wait;
    int16_t sound_channel;
    uint32_t wait_milliseconds;
    /* Bytes of the typed body consumed by the original loader cursor. */
    size_t body_length;
    /* Size of the original malloc'd runtime record. */
    size_t payload_length;
    uint16_t text_length;
    /* Bounded key copied from the body (AUTOTEXT sources only). */
    char auto_text_key[ACTION_FAMILY_51_AUTO_TEXT_KEY_BYTES + 1u];
} ActionFamily51Decoded;

/* Original loader cursor advance for a raw body that may include trailing
 * 16-byte dependency records. Does not resolve AUTOTEXT. */
int action_family_51_body_length(const uint8_t *raw_body,
                                 size_t raw_body_length,
                                 size_t *body_length);

/* Runs the original loader construction. `payload` receives the runtime
 * record and must hold `decoded->payload_length` bytes; pass NULL with
 * capacity 0 to query the size. On error nothing is written to `payload`.
 * `lookup` is required only for selector -1. */
int action_family_51_decode(const uint8_t *body,
                            size_t body_length,
                            ActionFamily51AutoTextLookup lookup,
                            void *lookup_context,
                            uint8_t *payload,
                            size_t payload_capacity,
                            ActionFamily51Decoded *decoded);

/* Original process globals this family reads or writes. One deadline is
 * shared by every 0x51 slot; a later timed start replaces an earlier one.
 * 0x5bb226 is used only by this family. 0x5b1606 and 0x5b1602 are shared
 * with the caption renderer and other UI code: 0x448d11 itself clears
 * 0x5b1602 when drawing (0x448ecf) and can set 0x5b1606 (0x4496ff). A
 * faithful backend applies those writes to this same structure; the step
 * function never restores a value saved before a backend call. */
typedef struct action_family_51_world {
    uint32_t timer_deadline;      /* 0x5bb226 */
    int32_t frame_text_flag;      /* 0x5b1606, cleared on frame text open */
    int32_t caption_finish_flag;  /* 0x5b1602, set on caption finish */
} ActionFamily51World;

typedef enum action_family_51_backend_status {
    ACTION_FAMILY_51_BACKEND_OK = 0,
    ACTION_FAMILY_51_BACKEND_ERROR = 1
} ActionFamily51BackendStatus;

/* Text arguments are the C string at record +12 (bytes up to the first NUL
 * inside the record). */
typedef struct action_family_51_backend {
    void *context;
    /* 0x448d11(*0x5d03b3, text, -1, 1): caption layout line count. Not a
     * pure query: like the draw mode it resets caption-object state
     * (0x448d73..0x448dba), closes the frame text box when byte 0x5a161f is
     * set (0x448ed9) and calls 0x4c92c5. */
    ActionFamily51BackendStatus (*measure_caption_lines)(
        void *context, const uint8_t *text, size_t text_length,
        int16_t *line_count);
    /* 0x448d11(*0x5d03b3, text, -1, 0). Also clears 0x5b1602 (0x448ecf)
     * and shares the side effects listed for measure. */
    ActionFamily51BackendStatus (*write_caption)(
        void *context, const uint8_t *text, size_t text_length);
    /* 0x4de24f(mode, text) with mode 2. */
    ActionFamily51BackendStatus (*open_frame_text)(
        void *context, int32_t mode, const uint8_t *text, size_t text_length);
    /* 0x4de2d8(). */
    ActionFamily51BackendStatus (*close_frame_text)(void *context);
    /* 0x4f6334(channel): nonzero while the channel is playing. */
    ActionFamily51BackendStatus (*is_channel_playing)(
        void *context, int16_t channel, int *playing);
    /* GetTickCount(). */
    ActionFamily51BackendStatus (*tick_count)(void *context, uint32_t *now);
} ActionFamily51Backend;

typedef struct action_family_51_input {
    uint8_t type;
    /* Slot +1 (0x5bb5e4); selects the 0x42ba3a completion branch. */
    uint8_t subtype;
    /* Result of the dependency gate 0x423f57(slot deps, 0). */
    uint8_t eligible;
    uint8_t completed_before;
    uint32_t phase_before;
    /* Mutable runtime record from action_family_51_decode. */
    uint8_t *payload;
    size_t payload_length;
} ActionFamily51Input;

typedef struct action_family_51_result {
    uint8_t recognized;
    uint8_t applied;
    /* 0x42ba3a ran: phase reset, completion flag per subtype. */
    uint8_t completion_called;
    uint8_t completed;
    /* Subtype 2 completion calls 0x423d33 on the dependency tree. */
    uint8_t reset_dependencies;
    /* Record word 0 was rewritten from AUTO to a concrete renderer. */
    uint8_t renderer_selected;
    uint8_t reserved[2];
    uint32_t phase;
} ActionFamily51Result;

/* One executor visit. Invalid input and missing callbacks are rejected
 * before any backend call or state change. Otherwise backend calls happen in
 * original order and state is committed as each step completes: the record's
 * renderer word right after measuring, the frame flag after opening, the
 * deadline after the first tick, phase 1 before the wait check. If a backend
 * call then fails, ACTION_FAMILY_51_ERR_BACKEND is returned with that partial
 * state (result->phase and renderer_selected included). Host effects of the
 * calls that succeeded cannot be undone, so the visit must not be retried as
 * if nothing happened; callers treat ERR_BACKEND as a fatal host error. */
int action_family_51_step(const ActionFamily51Input *input,
                          ActionFamily51World *world,
                          const ActionFamily51Backend *backend,
                          ActionFamily51Result *result);

const char *action_family_51_status_string(int status);

#ifdef __cplusplus
}
#endif

#endif
