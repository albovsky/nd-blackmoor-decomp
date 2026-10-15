#include "action_family_79_runtime.h"

#include <string.h>

static void observe(const Action79Host *host, int effect, int32_t value)
{
    if (host != NULL && host->observe != NULL) {
        host->observe(host->context, effect, value);
    }
}

static int fail(const char **why, const char *message, int status)
{
    if (why != NULL) {
        *why = message;
    }
    return status;
}

int action79_visit(uint16_t item_word, const Action79Model *model,
                   const Action79Host *host, Action79Result *result,
                   const char **why)
{
    int16_t id;
    int32_t count, scan, found = -1;
    int32_t kept, written;
    int32_t index;

    if (why != NULL) {
        *why = "none";
    }
    if (result == NULL || model == NULL || model->held_item == NULL ||
        model->item_count == NULL || model->items == NULL ||
        model->presence == NULL) {
        return fail(why, "invalid runtime arguments", ACTION79_ERR_ARGUMENT);
    }
    memset(result, 0, sizeof(*result));
    result->found_index = -1;
    /* Every read and write below is checked first: 0x4ea06c scans and then
     * rewrites `count` words of 0x583a31, and writes 0x583bd5[id]. */
    count = (int32_t)*model->item_count;
    if (count > 0 && (size_t)count > model->item_capacity) {
        return fail(why, "inventory count exceeds the modeled item array bounds",
                    ACTION79_ERR_BOUNDS);
    }
    /* 0x4ea0a2..0x4ea0db: signed compare against the signed count word, so a
     * negative count scans nothing. The id compares sign-extended. */
    id = (int16_t)(item_word <= (uint16_t)INT16_MAX ? (int32_t)item_word
                                                    : (int32_t)item_word - 65536);
    for (scan = 0; scan < count; ++scan) {
        if ((int16_t)(model->items[scan] <= (uint16_t)INT16_MAX
                          ? (int32_t)model->items[scan]
                          : (int32_t)model->items[scan] - 65536) == id) {
            found = scan;
            break;
        }
    }
    if (found >= 0) {
        if (id < 0 || (size_t)id >= model->presence_capacity) {
            return fail(why, "removed item id outside the modeled presence array bounds",
                        ACTION79_ERR_BOUNDS);
        }
        if (host == NULL || host->rebuild_view == NULL) {
            return fail(why, "inventory view rebuild provider (0x4e812f)",
                        ACTION79_ERR_UNSUPPORTED);
        }
    }
    observe(host, ACTION79_EFFECT_VISIT, id);
    if (found >= 0) {
        /* 0x4ea17f stores the new count (= count - 1) before 0x4ea1a3 copies
         * the kept words back. The original compacts into view scratch first;
         * in place, front to back, the result is identical: a write never
         * lands past a not-yet-read entry. Only the first match is skipped.
         * Words beyond the kept ones keep their old values. */
        kept = count - 1;
        *model->item_count = (int16_t)kept;
        observe(host, ACTION79_EFFECT_COUNT, kept);
        for (index = 0, written = 0; index < count; ++index) {
            if (index != found) {
                model->items[written++] = model->items[index];
            }
        }
        if (written != 0) {
            observe(host, ACTION79_EFFECT_LIST, written);
        }
        model->presence[id] = 0;
        observe(host, ACTION79_EFFECT_PRESENCE, id);
        result->found = 1u;
        result->found_index = found;
        result->rebuild_called = 1u;
        observe(host, ACTION79_EFFECT_REBUILD, id);
        if (host->rebuild_view(host->context, id) != 0) {
            return fail(why, "inventory view rebuild failed after the list was committed",
                        ACTION79_ERR_HOST);
        }
    }
    /* 0x4eac79..0x4eac88: signed word equality with the held item. */
    if (*model->held_item == id) {
        *model->held_item = -1;
        result->held_cleared = 1u;
        observe(host, ACTION79_EFFECT_HELD, -1);
    }
    result->completed = 1u;
    observe(host, ACTION79_EFFECT_COMPLETE, 1);
    return ACTION79_OK;
}
