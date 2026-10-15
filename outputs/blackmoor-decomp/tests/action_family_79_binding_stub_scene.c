/* RT-13 test double: a scriptable stand-in for the two scene_resource entry
 * points session_a79_begin_scene uses. The real parser (scene_resource.c)
 * validates every raw-0x79 row before a SceneResource exists, so the binding's
 * own malformed-row rejection (a defence in depth) is reachable only through
 * this double. It replaces no decision the original makes: it only lets a test
 * hand the binding rows the parser would have refused. */
#include "scene_resource.h"

#include <stdlib.h>
#include <string.h>

#define STUB_ROWS 8u

static struct {
    uint8_t type;
    uint8_t *body; /* exact-size heap copy, so a sanitizer sees any overread */
    size_t length;
    int unreadable;
} rows[STUB_ROWS];
static size_t row_count;

void stub_scene_reset(void)
{
    size_t i;
    for (i = 0u; i < STUB_ROWS; ++i) {
        free(rows[i].body);
    }
    memset(rows, 0, sizeof(rows));
    row_count = 0u;
}

int stub_scene_add(uint8_t type, const uint8_t *body, size_t length, int unreadable)
{
    if (row_count >= STUB_ROWS) {
        return -1;
    }
    rows[row_count].body = (uint8_t *)malloc(length != 0u ? length : 1u);
    if (rows[row_count].body == NULL) {
        return -1;
    }
    rows[row_count].type = type;
    rows[row_count].length = length;
    rows[row_count].unreadable = unreadable;
    if (length != 0u) {
        memcpy(rows[row_count].body, body, length);
    }
    return (int)row_count++;
}

size_t scene_resource_action_count(const SceneResource *scene)
{
    (void)scene;
    return row_count;
}

int scene_resource_action_at(const SceneResource *scene, size_t index, SceneActionInfo *out)
{
    (void)scene;
    if (index >= row_count || rows[index].unreadable) {
        return SCENE_RESOURCE_ERR_ARGUMENT;
    }
    memset(out, 0, sizeof(*out));
    out->type = rows[index].type;
    out->raw_body = rows[index].length != 0u ? rows[index].body : NULL;
    out->raw_body_length = rows[index].length;
    return SCENE_RESOURCE_OK;
}
