#include "interactive_video_input.h"
#include <limits.h>
#include <string.h>

/* GAME.EXE 0x4cb058 hover and 0x4cb3ab release. Original bytes/annotated
 * assembly govern this typed reconstruction; no new x86 oracle claim. */
static int16_t signed_word(uint16_t value)
{
    return value <= INT16_MAX ? (int16_t)value : (int16_t)(-1 - (int32_t)(UINT16_MAX - value));
}

static int16_t body_word(const uint8_t *body, size_t offset)
{
    return signed_word((uint16_t)((uint16_t)body[offset] | ((uint16_t)body[offset + 1u] << 8)));
}

static void clear_selection(InteractiveVideoInputState *state)
{
    state->object = NULL;
    state->iv = NULL;
    state->body = NULL;
    state->entry_index = SIZE_MAX;
    state->rectangle_index = SIZE_MAX;
    state->selection = IVI_NONE;
}

static void clear_result(InteractiveVideoInputResult *result)
{
    memset(result, 0, sizeof(*result));
    result->candidate = -1;
    result->rectangle_index = -1;
    result->flag_index = -1;
}

static int valid_body(const InteractiveVideoInputView *view)
{
    return view->object->body != NULL && view->body_length == C1C_BODY_BYTES;
}

/* Native borrowed-array bounds. Membership is checked by pointer equality,
 * never subtraction/ordering of unrelated pointers or a truncated address. */
static int current_entry(const C1cObject *object, size_t *index)
{
    int32_t i;
    if (object->iv == NULL) return IVI_ERR_STALE;
    if (object->iv->count < 0 || object->iv->count > C1C_MAX_ENTRIES) return IVI_ERR_BOUNDS;
    if (object->iv->count != 0 && object->iv->entries == NULL) return IVI_ERR_ARGUMENT;
    for (i = 0; i < object->iv->count; ++i) {
        if (object->record == &object->iv->entries[i]) {
            *index = (size_t)i;
            return IVI_OK;
        }
    }
    return IVI_ERR_STALE;
}

static int valid_rectangles(const C1cEntry *entry)
{
    if (entry->count < 0 || entry->count > C1C_MAX_RECTS) return IVI_ERR_BOUNDS;
    if (entry->count != 0 && entry->rects == NULL) return IVI_ERR_ARGUMENT;
    return IVI_OK;
}

static int cursor(InteractiveVideoInputWorld *world, const C1cObject *object,
                  int16_t selector, uint32_t variant, int held_allowed)
{
    int32_t index;
    int held;
    if (selector == -1) return IVI_OK;
    if (selector < 0 || selector >= 5) return IVI_ERR_BOUNDS;
    index = body_word(object->body, 0x5fu + (size_t)selector * 2u);
    held = held_allowed && index == 200 && object->word_152 != -1;
    /* Original stores: index, variant, surface source, table address, enable.
     * The native table address is represented as a wrapping relative offset. */
    world->cursor_index = held ? (int32_t)object->word_152 + 0x25 : index;
    world->cursor_variant = variant;
    world->cursor_source = held ? IVI_CURSOR_HELD_ITEM : IVI_CURSOR_STANDARD;
    world->cursor_table_offset = ((uint32_t)world->cursor_index << 5) + (variant << 4);
    world->cursor_enabled = 1u;
    return IVI_OK;
}

static void retain(InteractiveVideoInputState *state, const C1cObject *object,
                    size_t entry, size_t rectangle, uint32_t selection)
{
    state->object = object;
    state->iv = object->iv;
    state->body = object->body;
    state->entry_index = entry;
    state->rectangle_index = rectangle;
    state->selection = selection;
}

void interactive_video_input_reset(InteractiveVideoInputState *state, uint64_t generation)
{
    if (state == NULL) return;
    memset(state, 0, sizeof(*state));
    state->generation = generation;
    clear_selection(state);
}

int interactive_video_input_hover(InteractiveVideoInputState *state,
    const InteractiveVideoInputView *view, InteractiveVideoInputWorld *world,
    const InteractiveVideoInputHost *host, int16_t x, int16_t y,
    InteractiveVideoInputResult *result)
{
    C1cObject *object;
    const C1cEntry *entry;
    size_t entry_index;
    int32_t i;
    int status;
    if (state == NULL || view == NULL || view->object == NULL || world == NULL || result == NULL)
        return IVI_ERR_ARGUMENT;
    object = view->object;
    clear_result(result);
    clear_selection(state); /* original +0x154 := 0; native identity lives here */
    object->dword_14e = 0;
    if (state->generation != view->generation) return IVI_ERR_STALE;
    if (object->armed == 0) return IVI_OK;

    /* The held-item restoration precedes the later record/body/origin guards.
     * A successful host effect is not rolled back by a subsequent refusal. */
    if (object->word_152 != world->held_item) {
        if (!valid_body(view)) return IVI_ERR_ARGUMENT;
        if (body_word(object->body, 0x5fu) == 200 && object->word_152 != -1) {
            if (host == NULL || host->restore_held_item == NULL ||
                host->restore_held_item(host->context, object->word_152) != 0)
                return IVI_ERR_HOST;
            world->held_item = object->word_152;
        }
    }
    if (object->record == NULL || object->body == NULL || object->origin_present == 0) return IVI_OK;
    if (!valid_body(view)) return IVI_ERR_ARGUMENT;
    status = current_entry(object, &entry_index);
    if (status != IVI_OK) return status;
    entry = object->record;
    status = valid_rectangles(entry);
    if (status != IVI_OK) return status;
    for (i = 0; i < entry->count; ++i) {
        const C1cRect *rectangle = &entry->rects[i];
        if ((int32_t)y >= rectangle->d[2] && (int32_t)y <= rectangle->d[4] &&
            (int32_t)x >= rectangle->d[1] && (int32_t)x <= rectangle->d[3]) {
            const int16_t selector = signed_word((uint16_t)((uint32_t)rectangle->d[5] >> 16));
            retain(state, object, entry_index, (size_t)i, IVI_RECTANGLE);
            status = cursor(world, object, selector, 1u, 1);
            if (status != IVI_OK) {
                clear_selection(state);
                return status;
            }
            world->candidate = 0x27b0; /* published after all cursor stores */
            result->hit = 1u;
            result->candidate = 0x27b0;
            result->rectangle_index = i;
            return IVI_OK;
        }
    }
    if (entry->byte_4 == 0 || (int32_t)y < view->player_rectangle[1] ||
        (int32_t)y > view->player_rectangle[3] || (int32_t)x < view->player_rectangle[0] ||
        (int32_t)x > view->player_rectangle[2]) return IVI_OK;
    object->dword_14e = 1;
    retain(state, object, entry_index, SIZE_MAX, IVI_OUTER);
    status = cursor(world, object, entry->word_7, 0u, 0);
    if (status != IVI_OK) {
        object->dword_14e = 0;
        clear_selection(state);
        return status;
    }
    world->candidate = 0x27b2;
    result->hit = 1u;
    result->candidate = 0x27b2;
    return IVI_OK;
}

int interactive_video_input_release(InteractiveVideoInputState *state,
    const InteractiveVideoInputView *view, InteractiveVideoInputWorld *world,
    InteractiveVideoInputResult *result)
{
    C1cObject *object;
    size_t current_index;
    int16_t selector, flag, value;
    int status;
    if (state == NULL || view == NULL || view->object == NULL || world == NULL || result == NULL)
        return IVI_ERR_ARGUMENT;
    clear_result(result);
    object = view->object;
    if (object->armed == 0 || object->record == NULL || object->body == NULL || object->origin_present == 0)
        return IVI_OK;
    if (state->selection == IVI_NONE) return IVI_OK;
    if (state->generation != view->generation || state->object != object || state->iv != object->iv ||
        state->body != object->body) return IVI_ERR_STALE;
    if (!valid_body(view)) return IVI_ERR_ARGUMENT;
    status = current_entry(object, &current_index);
    if (status != IVI_OK) return status;
    if (state->selection == IVI_RECTANGLE) {
        const C1cEntry *retained;
        if (state->entry_index >= (size_t)object->iv->count) return IVI_ERR_STALE;
        retained = &object->iv->entries[state->entry_index];
        status = valid_rectangles(retained);
        if (status != IVI_OK) return status;
        if (state->rectangle_index >= (size_t)retained->count) return IVI_ERR_STALE;
        selector = signed_word((uint16_t)(uint32_t)retained->rects[state->rectangle_index].d[5]);
    } else if (state->selection == IVI_OUTER) {
        if (object->dword_14e == 0) return IVI_OK;
        selector = object->iv->entries[current_index].word_5;
    } else {
        return IVI_ERR_STALE;
    }
    if (selector == -1) return IVI_OK;
    if (selector < 0 || selector >= 15) return IVI_ERR_BOUNDS;
    /* Original +0x158 was body + 0x23 + selector*4. Resolve that pair from
     * the bounded body directly; never write a host address to dword_158. */
    flag = body_word(object->body, 0x23u + (size_t)selector * 4u);
    if (flag == -1) return IVI_OK;
    if (flag < 0 || (size_t)flag >= world->event_flag_count) return IVI_ERR_BOUNDS;
    if (world->event_flags == NULL) return IVI_ERR_ARGUMENT;
    value = body_word(object->body, 0x25u + (size_t)selector * 4u);
    world->event_flags[flag] = value; /* sign-extended word, no boolean coercion */
    result->flag_written = 1u;
    result->flag_index = flag;
    result->flag_value = value;
    return IVI_OK;
}
