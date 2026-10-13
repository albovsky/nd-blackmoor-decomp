#include "action_family_62.h"

#include <limits.h>
#include <string.h>

enum {
    ACTION_FAMILY_62_PHASE_SCAN = 1,
    ACTION_FAMILY_62_PHASE_FINISH = 2,
    ACTION_FAMILY_62_FINISH_THRESHOLD = 35
};

static uint16_t read_u16le(const uint8_t *bytes)
{
    return (uint16_t)((uint16_t)bytes[0] | ((uint16_t)bytes[1] << 8));
}

static int16_t read_i16le(const uint8_t *bytes)
{
    uint16_t bits = read_u16le(bytes);
    int32_t signed_value = (bits & UINT16_C(0x8000)) != 0u
                               ? (int32_t)bits - INT32_C(0x10000)
                               : (int32_t)bits;
    return (int16_t)signed_value;
}

static ActionFamily62Status validate_decoded_view(
    const ActionFamily62Decoded *decoded,
    ActionFamily62Decoded *validated)
{
    if (decoded == NULL || validated == NULL) {
        return ACTION_FAMILY_62_ERR_ARGUMENT;
    }
    return action_family_62_decode(decoded->raw_type,
                                   decoded->raw_body,
                                   decoded->raw_body_length,
                                   validated);
}

ActionFamily62Status action_family_62_decode(uint8_t raw_type,
                                            const uint8_t *raw_body,
                                            size_t raw_body_length,
                                            ActionFamily62Decoded *decoded)
{
    ActionFamily62Decoded value;
    int16_t count;
    size_t typed_length;
    size_t entry_bytes;

    if (decoded == NULL) {
        return ACTION_FAMILY_62_ERR_ARGUMENT;
    }
    if (raw_type != ACTION_FAMILY_62_RAW_TYPE) {
        return ACTION_FAMILY_62_ERR_TYPE;
    }
    if (raw_body == NULL || raw_body_length < ACTION_FAMILY_62_PREFIX_BYTES) {
        return ACTION_FAMILY_62_ERR_BODY;
    }

    count = read_i16le(raw_body + 10u);
    if (count < 0) {
        return ACTION_FAMILY_62_ERR_COUNT;
    }

    /* Original 0x40b34a narrows the constructor length to a signed short
     * before allocation/copy/cursor advance. Keep only lengths representable
     * by that proven path (12 + count*18 <= INT16_MAX). */
    if ((size_t)count > ((size_t)INT16_MAX - ACTION_FAMILY_62_PREFIX_BYTES) /
                            ACTION_FAMILY_62_ENTRY_BYTES) {
        return ACTION_FAMILY_62_ERR_COUNT;
    }
    entry_bytes = (size_t)count * ACTION_FAMILY_62_ENTRY_BYTES;
    typed_length = ACTION_FAMILY_62_PREFIX_BYTES + entry_bytes;
    if (typed_length > raw_body_length) {
        return ACTION_FAMILY_62_ERR_BODY;
    }

    memset(&value, 0, sizeof(value));
    value.raw_type = raw_type;
    value.event_ids[0] = read_i16le(raw_body + 0u);
    value.event_values[0] = read_i16le(raw_body + 2u);
    value.event_ids[1] = read_i16le(raw_body + 4u);
    value.event_values[1] = read_i16le(raw_body + 6u);
    value.threshold = read_i16le(raw_body + 8u);
    value.entry_count = count;
    value.typed_body_length = typed_length;
    value.raw_body = raw_body;
    value.raw_body_length = raw_body_length;
    value.dependency_bytes = raw_body + typed_length;
    value.dependency_length = raw_body_length - typed_length;
    *decoded = value;
    return ACTION_FAMILY_62_OK;
}

ActionFamily62Status action_family_62_entry_at(
    const ActionFamily62Decoded *decoded,
    size_t entry_index,
    ActionFamily62Entry *entry)
{
    ActionFamily62Decoded validated;
    ActionFamily62Status status;
    size_t word;
    const uint8_t *entry_bytes;

    if (entry == NULL) {
        return ACTION_FAMILY_62_ERR_ARGUMENT;
    }
    status = validate_decoded_view(decoded, &validated);
    if (status != ACTION_FAMILY_62_OK) {
        return status;
    }
    if (entry_index >= (size_t)validated.entry_count) {
        return ACTION_FAMILY_62_ERR_BODY;
    }

    entry_bytes = validated.raw_body + ACTION_FAMILY_62_PREFIX_BYTES +
                  entry_index * ACTION_FAMILY_62_ENTRY_BYTES;
    for (word = 0u; word < ACTION_FAMILY_62_ENTRY_WORDS; ++word) {
        entry->words[word] = read_i16le(entry_bytes + word * 2u);
    }
    return ACTION_FAMILY_62_OK;
}

static ActionFamily62Status apply_backend(const ActionFamily62Backend *backend,
                                          const ActionFamily62Result *result)
{
    if (backend == NULL) {
        return ACTION_FAMILY_62_OK;
    }
    if (backend->apply_result_atomically == NULL) {
        return ACTION_FAMILY_62_ERR_ARGUMENT;
    }
    if (backend->apply_result_atomically(backend->context, result) != 0) {
        return ACTION_FAMILY_62_ERR_BACKEND;
    }
    return ACTION_FAMILY_62_OK;
}

ActionFamily62Status action_family_62_step(
    const ActionFamily62Decoded *decoded,
    const ActionFamily62Input *input,
    const ActionFamily62Backend *backend,
    ActionFamily62Result *result)
{
    ActionFamily62Decoded action;
    ActionFamily62Result next;
    ActionFamily62Status status;

    if (input == NULL || result == NULL) {
        return ACTION_FAMILY_62_ERR_ARGUMENT;
    }
    status = validate_decoded_view(decoded, &action);
    if (status != ACTION_FAMILY_62_OK) {
        return status;
    }

    memset(&next, 0, sizeof(next));
    next.recognized = 1u;
    next.phase_after = input->phase_before;
    next.completed_after = input->completed_before;

    if (input->eligible == 0u) {
        *result = next;
        return ACTION_FAMILY_62_OK;
    }

    if (input->phase_before == 0) {
        next.applied = 1u;
        next.start_global_written = 1u;
        next.start_global_value = 1u;
        next.phase_written = 1u;
        next.phase_after = ACTION_FAMILY_62_PHASE_SCAN;
    } else if (input->phase_before == ACTION_FAMILY_62_PHASE_SCAN) {
        next.applied = 1u;
    } else if (input->phase_before == ACTION_FAMILY_62_PHASE_FINISH) {
        next.applied = 1u;
        if (action.threshold < ACTION_FAMILY_62_FINISH_THRESHOLD) {
            size_t pair;

            next.phase_written = 1u;
            next.phase_after = 0;
            next.request_written = 1u;
            next.request_value = 0u;
            next.completion_written = 1u;
            next.completed_after = input->subtype == 2u ? 0u : 1u;
            next.dependency_reset_requested =
                input->subtype == 2u ? 1u : 0u;

            for (pair = 0u; pair < ACTION_FAMILY_62_EVENT_WRITES; ++pair) {
                if (action.event_ids[pair] != -1) {
                    size_t output_index = next.event_write_count;
                    next.event_writes[output_index].event_id = action.event_ids[pair];
                    next.event_writes[output_index].value = action.event_values[pair];
                    next.event_write_count = (uint8_t)(output_index + 1u);
                }
            }
            *result = next;
            return apply_backend(backend, result);
        }

        next.phase_written = 1u;
        next.phase_after = ACTION_FAMILY_62_PHASE_SCAN;
        *result = next;
        return apply_backend(backend, result);
    } else {
        *result = next;
        return ACTION_FAMILY_62_OK;
    }

    /* Phase zero initializes the shared start flag and then, like phase one,
     * clears the pending request and scans selector-keyed records. */
    next.request_written = 1u;
    next.request_value = 0u;
    {
        size_t entry_index;
        for (entry_index = 0u;
             entry_index < (size_t)action.entry_count;
             ++entry_index) {
            ActionFamily62Entry entry;
            status = action_family_62_entry_at(&action, entry_index, &entry);
            if (status != ACTION_FAMILY_62_OK) {
                return status;
            }
            if (entry.words[0] == input->selector) {
                next.request_value = 1u;
                next.response_written = 1u;
                next.response_words[0] = entry.words[1];
                next.response_words[1] = entry.words[3];
                next.response_words[2] = entry.words[5];
                next.response_words[3] = entry.words[7];
                break;
            }
        }
    }

    *result = next;
    return apply_backend(backend, result);
}

const char *action_family_62_status_string(ActionFamily62Status status)
{
    switch (status) {
    case ACTION_FAMILY_62_OK:
        return "ok";
    case ACTION_FAMILY_62_ERR_ARGUMENT:
        return "invalid argument";
    case ACTION_FAMILY_62_ERR_TYPE:
        return "raw type is not 0x62";
    case ACTION_FAMILY_62_ERR_BODY:
        return "truncated or invalid body";
    case ACTION_FAMILY_62_ERR_COUNT:
        return "negative or unrepresentable count";
    case ACTION_FAMILY_62_ERR_BACKEND:
        return "atomic effect backend rejected the result";
    default:
        return "unknown status";
    }
}
