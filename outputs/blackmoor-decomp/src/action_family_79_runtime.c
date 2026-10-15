#include "action_family_79_runtime.h"

#include <string.h>

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
    int32_t kept = 0;
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
        /* 0x4ea0eb..0x4ea1a7: compact into the view scratch skipping ONLY the
         * first match, then copy back exactly the kept entries. Words beyond
         * them keep their old values. In place, front to back, this is the
         * same result: a write never lands past a not-yet-read entry. */
        for (index = 0; index < count; ++index) {
            if (index != found) {
                model->items[kept++] = model->items[index];
            }
        }
        *model->item_count = (int16_t)kept;
        model->presence[id] = 0;
        result->found = 1u;
        result->found_index = found;
        result->rebuild_called = 1u;
        if (host->rebuild_view(host->context, id) != 0) {
            return fail(why, "inventory view rebuild failed after the list was committed",
                        ACTION79_ERR_HOST);
        }
    }
    /* 0x4eac79..0x4eac88: signed word equality with the held item. */
    if (*model->held_item == id) {
        *model->held_item = -1;
        result->held_cleared = 1u;
    }
    result->completed = 1u;
    return ACTION79_OK;
}
