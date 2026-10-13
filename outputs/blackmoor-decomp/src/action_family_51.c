#include "action_family_51.h"

#include <stdio.h>
#include <string.h>

static uint16_t read_u16(const uint8_t *bytes)
{
    return (uint16_t)(bytes[0] | ((uint16_t)bytes[1] << 8));
}

static int16_t read_i16(const uint8_t *bytes)
{
    return (int16_t)read_u16(bytes);
}

static uint32_t read_u32(const uint8_t *bytes)
{
    return (uint32_t)bytes[0] | ((uint32_t)bytes[1] << 8) |
           ((uint32_t)bytes[2] << 16) | ((uint32_t)bytes[3] << 24);
}

static void write_u16(uint8_t *bytes, uint16_t value)
{
    bytes[0] = (uint8_t)value;
    bytes[1] = (uint8_t)(value >> 8);
}

static void write_i16(uint8_t *bytes, int16_t value)
{
    write_u16(bytes, (uint16_t)value);
}

static size_t bounded_strlen(const uint8_t *bytes, size_t limit)
{
    const void *terminator = memchr(bytes, 0, limit);
    return terminator == NULL ? limit : (size_t)((const uint8_t *)terminator - bytes);
}

/* 0x40cabb: the selector is the signed word at body +10. */
static int selector_body_length(int16_t selector, size_t *body_length)
{
    if (selector == ACTION_FAMILY_51_AUTO_TEXT_SELECTOR) {
        /* 0x40cbce: local cursor advance is the constant 0x2d. */
        *body_length = ACTION_FAMILY_51_AUTO_TEXT_BODY_BYTES;
        return ACTION_FAMILY_51_OK;
    }
    /* 0x40cd92 rejects >= 10000 as fatal. Other negative selectors give a
     * cursor advance below the header or a negative copy, which the
     * original does not handle; they are rejected here. */
    if (selector < 0 || selector > ACTION_FAMILY_51_MAX_INLINE_BYTES) {
        return ACTION_FAMILY_51_ERR_BODY;
    }
    /* 0x40cd7d and 0x40ce98: (L + 3 + 12) - 3. */
    *body_length = ACTION_FAMILY_51_TEXT_OFFSET + (size_t)selector;
    return ACTION_FAMILY_51_OK;
}

int action_family_51_body_length(const uint8_t *raw_body,
                                 size_t raw_body_length,
                                 size_t *body_length)
{
    size_t length = 0u;
    int status;

    if (raw_body == NULL || body_length == NULL) {
        return ACTION_FAMILY_51_ERR_ARGUMENT;
    }
    if (raw_body_length < ACTION_FAMILY_51_TEXT_OFFSET) {
        return ACTION_FAMILY_51_ERR_BODY;
    }
    status = selector_body_length(
        read_i16(raw_body + ACTION_FAMILY_51_SELECTOR_OFFSET), &length);
    if (status != ACTION_FAMILY_51_OK) {
        return status;
    }
    if (length > raw_body_length) {
        return ACTION_FAMILY_51_ERR_BODY;
    }
    *body_length = length;
    return ACTION_FAMILY_51_OK;
}

static void fill_header(ActionFamily51Decoded *decoded, const uint8_t *body,
                        int16_t selector, size_t body_length)
{
    memset(decoded, 0, sizeof(*decoded));
    decoded->selector = selector;
    decoded->renderer = read_i16(body);
    decoded->wait = read_i16(body + 2);
    decoded->sound_channel = read_i16(body + 4);
    decoded->wait_milliseconds = read_u32(body + 6);
    decoded->body_length = body_length;
}

int action_family_51_decode(const uint8_t *body,
                            size_t body_length,
                            ActionFamily51AutoTextLookup lookup,
                            void *lookup_context,
                            uint8_t *payload,
                            size_t payload_capacity,
                            ActionFamily51Decoded *decoded)
{
    ActionFamily51Decoded local;
    size_t consumed = 0u;
    int16_t selector;
    int status;

    if (body == NULL || decoded == NULL ||
        (payload == NULL && payload_capacity != 0u)) {
        return ACTION_FAMILY_51_ERR_ARGUMENT;
    }
    if (body_length < ACTION_FAMILY_51_TEXT_OFFSET) {
        return ACTION_FAMILY_51_ERR_BODY;
    }
    selector = read_i16(body + ACTION_FAMILY_51_SELECTOR_OFFSET);
    status = selector_body_length(selector, &consumed);
    if (status != ACTION_FAMILY_51_OK) {
        return status;
    }
    if (consumed > body_length) {
        return ACTION_FAMILY_51_ERR_BODY;
    }
    fill_header(&local, body, selector, consumed);

    if (selector != ACTION_FAMILY_51_AUTO_TEXT_SELECTOR) {
        /* Inline: malloc(L + 15), copy body[0 .. L+12), then append "<e>"
         * without a NUL and add 3 to the stored length (0x40cdec..0x40cf42). */
        size_t inline_bytes = (size_t)selector;

        local.source = ACTION_FAMILY_51_TEXT_INLINE;
        local.payload_length = consumed + ACTION_FAMILY_51_TERMINATOR_BYTES;
        local.text_length =
            (uint16_t)(inline_bytes + ACTION_FAMILY_51_TERMINATOR_BYTES);
        if (payload != NULL) {
            if (payload_capacity < local.payload_length) {
                return ACTION_FAMILY_51_ERR_LIMIT;
            }
            memcpy(payload, body, consumed);
            memcpy(payload + consumed, ACTION_FAMILY_51_TERMINATOR,
                   ACTION_FAMILY_51_TERMINATOR_BYTES);
            write_u16(payload + ACTION_FAMILY_51_SELECTOR_OFFSET,
                      local.text_length);
        }
        *decoded = local;
        return ACTION_FAMILY_51_OK;
    }

    {
        const uint8_t *key = body + ACTION_FAMILY_51_TEXT_OFFSET;
        size_t key_length = bounded_strlen(key, ACTION_FAMILY_51_AUTO_TEXT_KEY_BYTES);
        char missing[sizeof(ACTION_FAMILY_51_MISSING_FORMAT) +
                     ACTION_FAMILY_51_AUTO_TEXT_KEY_BYTES];
        const uint8_t *text = NULL;
        size_t text_length = 0u;
        ActionFamily51LookupStatus lookup_status;

        /* The loader copies all 33 bytes and passes them as a C string. A key
         * without a terminator makes the original read past its stack copy. */
        if (key_length == ACTION_FAMILY_51_AUTO_TEXT_KEY_BYTES) {
            return ACTION_FAMILY_51_ERR_BODY;
        }
        memcpy(local.auto_text_key, key, key_length);
        local.auto_text_key[key_length] = '\0';

        /* 0x40caeb always calls 0x423259, even for an empty key. */
        if (lookup == NULL) {
            return ACTION_FAMILY_51_ERR_UNSUPPORTED;
        }
        lookup_status = lookup(lookup_context, key, key_length,
                               &text, &text_length);
        if (lookup_status == ACTION_FAMILY_51_LOOKUP_ERROR ||
            (lookup_status == ACTION_FAMILY_51_LOOKUP_FOUND && text == NULL &&
             text_length != 0u)) {
            return ACTION_FAMILY_51_ERR_BACKEND;
        }
        if (lookup_status == ACTION_FAMILY_51_LOOKUP_FOUND) {
            if (text == NULL) {
                text = (const uint8_t *)"";
            }
            /* Caption bytes are a C string in the original table. */
            text_length = bounded_strlen(text, text_length);
            /* 0x40cb7f: strlen above 40000 quits without advancing. */
            if (text_length > ACTION_FAMILY_51_MAX_AUTO_TEXT_BYTES) {
                return ACTION_FAMILY_51_ERR_LIMIT;
            }
            local.source = ACTION_FAMILY_51_TEXT_AUTO_TEXT;
        } else {
            /* 0x40cb44: sprintf(local, 0x53f568, key). */
            int written = snprintf(missing, sizeof(missing),
                                   ACTION_FAMILY_51_MISSING_FORMAT,
                                   local.auto_text_key);
            if (written < 0 || (size_t)written >= sizeof(missing)) {
                return ACTION_FAMILY_51_ERR_LIMIT;
            }
            text = (const uint8_t *)missing;
            text_length = (size_t)written;
            local.source = ACTION_FAMILY_51_TEXT_MISSING_AUTO_TEXT;
        }

        /* 0x40cbfc: malloc((short)(strlen + 3 + 13)); a negative 16-bit size
         * makes the allocation fail, which the loader treats as fatal. */
        if (text_length + 16u > ACTION_FAMILY_51_MAX_PAYLOAD_BYTES) {
            return ACTION_FAMILY_51_ERR_LIMIT;
        }
        local.payload_length = text_length + 16u;
        local.text_length =
            (uint16_t)(text_length + ACTION_FAMILY_51_TERMINATOR_BYTES);
        if (payload != NULL) {
            if (payload_capacity < local.payload_length) {
                return ACTION_FAMILY_51_ERR_LIMIT;
            }
            /* 0x40cca2: words 0..2 and the dword at +6. */
            memcpy(payload, body, ACTION_FAMILY_51_HEADER_BYTES);
            write_u16(payload + ACTION_FAMILY_51_SELECTOR_OFFSET,
                      local.text_length);
            if (text_length != 0u) {
                memcpy(payload + ACTION_FAMILY_51_TEXT_OFFSET, text, text_length);
            }
            /* 0x40cd55: the dword "<e>\0" overwrites the copied NUL. */
            memcpy(payload + ACTION_FAMILY_51_TEXT_OFFSET + text_length,
                   ACTION_FAMILY_51_TERMINATOR,
                   ACTION_FAMILY_51_TERMINATOR_BYTES + 1u);
        }
    }
    *decoded = local;
    return ACTION_FAMILY_51_OK;
}

/* Reports which callbacks the visit will reach, so a missing callback is
 * rejected before any host call or state change. */
static int backend_supports(const ActionFamily51Backend *backend,
                            uint32_t phase, int16_t renderer, int16_t wait)
{
    if (phase == ACTION_FAMILY_51_PHASE_FINISH) {
        return renderer != ACTION_FAMILY_51_RENDERER_FRAME_TEXT_BOX ||
               backend->close_frame_text != NULL;
    }
    if (phase == ACTION_FAMILY_51_PHASE_START) {
        if (renderer == ACTION_FAMILY_51_RENDERER_AUTO &&
            (backend->measure_caption_lines == NULL ||
             backend->open_frame_text == NULL || backend->write_caption == NULL)) {
            return 0;
        }
        if (renderer == ACTION_FAMILY_51_RENDERER_FRAME_TEXT_BOX &&
            backend->open_frame_text == NULL) {
            return 0;
        }
        if (renderer == ACTION_FAMILY_51_RENDERER_CAPTION_TEXT_BOX &&
            backend->write_caption == NULL) {
            return 0;
        }
    }
    if (wait == ACTION_FAMILY_51_WAIT_SOUND_CHANNEL &&
        backend->is_channel_playing == NULL) {
        return 0;
    }
    if (wait == ACTION_FAMILY_51_WAIT_TIMER && backend->tick_count == NULL) {
        return 0;
    }
    return 1;
}

int action_family_51_step(const ActionFamily51Input *input,
                          ActionFamily51World *world,
                          const ActionFamily51Backend *backend,
                          ActionFamily51Result *result)
{
    const uint8_t *text;
    size_t text_capacity;
    size_t text_length;
    int16_t renderer;
    int16_t wait;

    if (result == NULL) {
        return ACTION_FAMILY_51_ERR_ARGUMENT;
    }
    memset(result, 0, sizeof(*result));
    if (input == NULL || world == NULL || backend == NULL) {
        return ACTION_FAMILY_51_ERR_ARGUMENT;
    }
    result->phase = input->phase_before;
    result->completed = input->completed_before;
    if (input->type != ACTION_FAMILY_51_TYPE) {
        return ACTION_FAMILY_51_ERR_UNSUPPORTED;
    }
    result->recognized = 1u;

    /* 0x4281f4: a false gate skips the handler; no subtype-2 clear here. */
    if (input->eligible == 0u) {
        return ACTION_FAMILY_51_OK;
    }
    if (input->phase_before > ACTION_FAMILY_51_PHASE_FINISH) {
        return ACTION_FAMILY_51_OK;
    }

    /* Words 0..2 and the dword at +6 are the only fields the executor reads
     * besides the text; the stored length at +10 is not consulted. */
    if (input->payload == NULL ||
        input->payload_length < ACTION_FAMILY_51_TEXT_OFFSET) {
        return ACTION_FAMILY_51_ERR_BODY;
    }
    text = input->payload + ACTION_FAMILY_51_TEXT_OFFSET;
    text_capacity = input->payload_length - ACTION_FAMILY_51_TEXT_OFFSET;
    text_length = bounded_strlen(text, text_capacity);
    renderer = read_i16(input->payload);
    wait = read_i16(input->payload + 2);

    /* The renderers read the text as a C string; without a NUL inside the
     * record the original reads past its allocation. Only paths that read
     * the text are rejected. */
    if (input->phase_before == ACTION_FAMILY_51_PHASE_START &&
        renderer >= ACTION_FAMILY_51_RENDERER_AUTO &&
        renderer <= ACTION_FAMILY_51_RENDERER_CAPTION_TEXT_BOX &&
        text_length == text_capacity) {
        return ACTION_FAMILY_51_ERR_BODY;
    }
    if (!backend_supports(backend, input->phase_before, renderer, wait)) {
        return ACTION_FAMILY_51_ERR_UNSUPPORTED;
    }
    result->applied = 1u;

    if (input->phase_before == ACTION_FAMILY_51_PHASE_FINISH) {
        /* 0x4283de: close the renderer, then 0x42ba3a. */
        if (renderer == ACTION_FAMILY_51_RENDERER_FRAME_TEXT_BOX) {
            if (backend->close_frame_text(backend->context) !=
                ACTION_FAMILY_51_BACKEND_OK) {
                return ACTION_FAMILY_51_ERR_BACKEND;
            }
        } else if (renderer == ACTION_FAMILY_51_RENDERER_CAPTION_TEXT_BOX) {
            world->caption_finish_flag = 1;
        }
        result->completion_called = 1u;
        result->phase = ACTION_FAMILY_51_PHASE_START;
        if (input->subtype == 1u) {
            result->completed = 1u;
        } else if (input->subtype == 2u) {
            result->completed = 0u;
            result->reset_dependencies = 1u;
        }
        return ACTION_FAMILY_51_OK;
    }

    /* State is committed in original order as each step completes, so a
     * backend failure leaves exactly the state the original would have at
     * that point. Backend calls may also update `world` themselves (the
     * caption draw clears 0x5b1602 inside 0x448d11). */
    if (input->phase_before == ACTION_FAMILY_51_PHASE_START) {
        if (renderer == ACTION_FAMILY_51_RENDERER_AUTO) {
            int16_t lines = 0;

            if (backend->measure_caption_lines(backend->context, text,
                                               text_length, &lines) !=
                ACTION_FAMILY_51_BACKEND_OK) {
                return ACTION_FAMILY_51_ERR_BACKEND;
            }
            /* 0x42828e: more than two lines selects the frame text box;
             * 0x428299/0x4282a6 store the choice before rendering. */
            renderer = lines > 2 ? ACTION_FAMILY_51_RENDERER_FRAME_TEXT_BOX
                                 : ACTION_FAMILY_51_RENDERER_CAPTION_TEXT_BOX;
            write_i16(input->payload, renderer);
            result->renderer_selected = 1u;
        }
        if (renderer == ACTION_FAMILY_51_RENDERER_FRAME_TEXT_BOX) {
            if (backend->open_frame_text(backend->context, 2, text,
                                         text_length) !=
                ACTION_FAMILY_51_BACKEND_OK) {
                return ACTION_FAMILY_51_ERR_BACKEND;
            }
            world->frame_text_flag = 0;
        } else if (renderer == ACTION_FAMILY_51_RENDERER_CAPTION_TEXT_BOX) {
            if (backend->write_caption(backend->context, text, text_length) !=
                ACTION_FAMILY_51_BACKEND_OK) {
                return ACTION_FAMILY_51_ERR_BACKEND;
            }
        }
        if (wait == ACTION_FAMILY_51_WAIT_TIMER) {
            uint32_t now = 0u;

            if (backend->tick_count(backend->context, &now) !=
                ACTION_FAMILY_51_BACKEND_OK) {
                return ACTION_FAMILY_51_ERR_BACKEND;
            }
            world->timer_deadline = now + read_u32(input->payload + 6);
        }
        /* 0x42834b. */
        result->phase = ACTION_FAMILY_51_PHASE_WAIT;
    }

    /* 0x428355: the wait check also runs in the same visit as the start. */
    if (wait == ACTION_FAMILY_51_WAIT_SOUND_CHANNEL) {
        int playing = 0;

        if (backend->is_channel_playing(backend->context,
                                        read_i16(input->payload + 4),
                                        &playing) !=
            ACTION_FAMILY_51_BACKEND_OK) {
            return ACTION_FAMILY_51_ERR_BACKEND;
        }
        if (playing == 0) {
            result->phase = ACTION_FAMILY_51_PHASE_FINISH;
        }
    } else if (wait == ACTION_FAMILY_51_WAIT_TIMER) {
        uint32_t now = 0u;

        if (backend->tick_count(backend->context, &now) !=
            ACTION_FAMILY_51_BACKEND_OK) {
            return ACTION_FAMILY_51_ERR_BACKEND;
        }
        /* 0x4283bd: unsigned "now > deadline". */
        if (now > world->timer_deadline) {
            result->phase = ACTION_FAMILY_51_PHASE_FINISH;
        }
    }
    return ACTION_FAMILY_51_OK;
}

const char *action_family_51_status_string(int status)
{
    switch (status) {
    case ACTION_FAMILY_51_OK:
        return "ok";
    case ACTION_FAMILY_51_ERR_ARGUMENT:
        return "invalid argument";
    case ACTION_FAMILY_51_ERR_BODY:
        return "invalid action 0x51 body";
    case ACTION_FAMILY_51_ERR_LIMIT:
        return "action 0x51 size limit";
    case ACTION_FAMILY_51_ERR_UNSUPPORTED:
        return "unsupported action 0x51 path";
    case ACTION_FAMILY_51_ERR_BACKEND:
        return "action 0x51 backend failure";
    default:
        return "unknown action 0x51 status";
    }
}
