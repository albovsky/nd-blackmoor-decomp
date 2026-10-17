/* RT-57 corpus check: runs every raw 0x1c row of the decoded scene resources given on the command line through the production
 * parser and the session binding. The ".IV" files are game data and are not in the repository: each row gets a synthetic file
 * whose name field and player clip name are the row's own body name (the loader opens the body name, and phase 0 compares the
 * player's clip name with the file's name field). The player is scripted: idle, then playing with a hotspot, then stopped. Output is
 * derived counts only (names and bytes stay in work/): one "ROW_FAIL ..." line per failing row and a final "SUMMARY ..." line. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_resource.h"
#include "session_bindings_a1c.h"

#define FILE_BYTES 4096u
#define ENTRIES 2
#define RECTS 2

typedef struct {
    uint8_t file[FILE_BYTES];
    size_t file_len, pos;
    uint8_t clip[C1C_NAME_BYTES];
    int32_t state;
    int16_t hotspot;
    char opened[C1C_BODY_BYTES + 1u];
    unsigned long opens, closes, allocs, registers, releases, name_mismatch, waits_logged;
} Stand;

static void put16(uint8_t *p, size_t at, uint16_t v)
{
    p[at] = (uint8_t)v;
    p[at + 1u] = (uint8_t)(v >> 8);
}

static void put32(uint8_t *p, size_t at, uint32_t v)
{
    put16(p, at, (uint16_t)v);
    put16(p, at + 2u, (uint16_t)(v >> 16));
}

/* 33-byte name, count, then ENTRIES entries (ids 10, 11) of RECTS rectangles. */
static void build_file(Stand *s, const uint8_t *name, size_t name_len)
{
    size_t at = 0u;
    int i, j, k;
    memset(s->file, 0, sizeof s->file);
    memcpy(s->file, name, name_len > 32u ? 32u : name_len);
    memcpy(s->clip, s->file, C1C_NAME_BYTES);
    at = C1C_NAME_BYTES;
    put32(s->file, at, ENTRIES);
    at += 4u;
    for (i = 0; i < ENTRIES; ++i) {
        put16(s->file, at, (uint16_t)(10 + i));
        put16(s->file, at + 2u, RECTS);
        at += 9u;
        for (j = 0; j < RECTS; ++j) {
            for (k = 0; k < 6; ++k) put32(s->file, at + 4u * (size_t)k, (uint32_t)(100 * i + 10 * j + k));
            at += C1C_RECT_BYTES;
        }
    }
    s->file_len = at;
    s->pos = 0u;
}

static int s_state(void *c, int32_t *v)
{
    *v = ((Stand *)c)->state;
    return 0;
}

static int s_name(void *c, uint8_t name[C1C_NAME_BYTES])
{
    memcpy(name, ((Stand *)c)->clip, C1C_NAME_BYTES);
    return 0;
}

static int s_hotspot(void *c, int16_t *v)
{
    *v = ((Stand *)c)->hotspot;
    return 0;
}

static int s_origin(void *c, int *present, int32_t *dx, int32_t *dy)
{
    (void)c;
    *present = 1;
    *dx = 3;
    *dy = 4;
    return 0;
}

static int s_open(void *c, const char *name, void **file)
{
    Stand *s = (Stand *)c;
    ++s->opens;
    strncpy(s->opened, name, sizeof s->opened - 1u);
    s->pos = 0u;
    *file = s;
    return 0;
}

static size_t s_read(void *c, void *file, void *buffer, size_t size)
{
    Stand *s = (Stand *)c;
    size_t n = size < s->file_len - s->pos ? size : s->file_len - s->pos;
    (void)file;
    memcpy(buffer, s->file + s->pos, n);
    s->pos += n;
    return n;
}

static void s_close(void *c, void *file)
{
    (void)file;
    ++((Stand *)c)->closes;
}

static int s_alloc(void *c, int16_t *slot)
{
    ++((Stand *)c)->allocs;
    *slot = 0x18;
    return 0;
}

static int s_register(void *c, int16_t slot, const char *label)
{
    (void)slot;
    ++((Stand *)c)->registers;
    return strcmp(label, C1C_LABEL) == 0 ? 0 : 1;
}

static int s_release(void *c, int16_t slot)
{
    (void)slot;
    ++((Stand *)c)->releases;
    return 0;
}

static int s_cell(void *c, int16_t *v)
{
    (void)c;
    *v = -1;
    return 0;
}

static unsigned char *read_file(const char *path, long *n)
{
    FILE *f = fopen(path, "rb");
    unsigned char *bytes;
    if (f == NULL) return NULL;
    fseek(f, 0, SEEK_END);
    *n = ftell(f);
    fseek(f, 0, SEEK_SET);
    bytes = (unsigned char *)malloc((size_t)*n);
    if (bytes == NULL || fread(bytes, 1, (size_t)*n, f) != (size_t)*n) {
        fclose(f);
        free(bytes);
        return NULL;
    }
    fclose(f);
    return bytes;
}

#define STEP(cond)                  \
    do {                            \
        ++step;                     \
        if (ok == 0 && !(cond)) ok = step; \
    } while (0)

static int drive_row(Stand *s, const SceneActionInfo *info, unsigned long *fills_total, unsigned long *render_rows)
{
    C1cHost h;
    SessionA1cBinding *b;
    SceneActionRuntimeState before = {0u, 0u};
    SceneActionHandlerResult r;
    C1cFill fills[8];
    size_t count = 0u, name_len = 0u;
    const unsigned long allocs0 = s->allocs, releases0 = s->releases;
    const int wants_render = (info->raw_body[C1C_BODY_RENDER_WORD] | info->raw_body[C1C_BODY_RENDER_WORD + 1u]) != 0;
    int ok = 0; /* the number of the first failing step, 0 = none */
    int step = 0;

    while (name_len < C1C_BODY_BYTES && info->raw_body[name_len] != 0u) ++name_len;
    if (name_len == 0u || name_len > 32u) return -1;
    build_file(s, info->raw_body, name_len);
    memset(&h, 0, sizeof h);
    h.context = s;
    h.player_state = s_state;
    h.player_name = s_name;
    h.player_hotspot = s_hotspot;
    h.player_origin = s_origin;
    h.open_iv = s_open;
    h.read = s_read;
    h.close = s_close;
    h.alloc_slot = s_alloc;
    h.register_slot = s_register;
    h.release_slot = s_release;
    h.cell_583a29 = s_cell;
    b = session_a1c_create(&h);
    if (b == NULL) return -2;
    /* idle player: the row loads the file and waits */
    s->state = 0;
    s->hotspot = -1;
    STEP(session_a1c_handler(b, 0u, info, &before, &r) == SCENE_ACTION_HANDLER_OK && r.phase == 0u &&
          r.disposition == SCENE_ACTION_HANDLER_PENDING);
    STEP(strlen(s->opened) == name_len && memcmp(s->opened, info->raw_body, name_len) == 0);
    STEP(session_a1c_object(b)->iv != NULL && session_a1c_object(b)->iv->count == ENTRIES);
    /* a different clip: still waiting */
    s->state = 2;
    s->clip[0] ^= 1u;
    STEP(session_a1c_handler(b, 0u, info, &before, &r) == SCENE_ACTION_HANDLER_OK && r.phase == 0u);
    s->clip[0] ^= 1u;
    /* the right clip with a hotspot: phase 1, z entry only for rows that want it */
    s->hotspot = 11;
    STEP(session_a1c_handler(b, 0u, info, &before, &r) == SCENE_ACTION_HANDLER_OK && r.phase == 1u &&
          r.disposition == SCENE_ACTION_HANDLER_PENDING);
    STEP((s->allocs - allocs0 == 1ul) == (wants_render != 0) && s->registers == s->allocs);
    STEP(session_a1c_object(b)->changed == 1);
    STEP(session_a1c_render(b, 1, 2, fills, 8u, &count) == C1C_OK && count == RECTS && fills[0].color == C1C_COLOR_FIRST);
    STEP(fills[0].left == 101 + 3 + 1 && fills[0].top == 102 + 4 + 2 && session_a1c_object(b)->changed == 0);
    *fills_total += count;
    *render_rows += wants_render != 0;
    before.phase = 1u;
    STEP(session_a1c_handler(b, 0u, info, &before, &r) == SCENE_ACTION_HANDLER_OK && r.phase == 1u);
    /* the movie ends */
    s->state = 4;
    STEP(session_a1c_handler(b, 0u, info, &before, &r) == SCENE_ACTION_HANDLER_OK && r.phase == 2u &&
          r.disposition == SCENE_ACTION_HANDLER_PENDING);
    before.phase = 2u;
    /* the completion byte is stored directly (phase word 0) except for a repeating row (subtype 2: generic completion) */
    STEP(session_a1c_handler(b, 0u, info, &before, &r) == SCENE_ACTION_HANDLER_OK && r.phase == 0u &&
          r.disposition == (info->subtype == 2u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_DIRECT_COMPLETED));
    STEP((s->releases - releases0 == 1ul) == (wants_render != 0) && session_a1c_object(b)->iv == NULL);
    session_a1c_destroy(b);
    return ok;
}

int main(int argc, char **argv)
{
    Stand *stand = (Stand *)calloc(1u, sizeof *stand);
    unsigned long scenes = 0, rows = 0, ok = 0, bad = 0, tail_rows = 0, sub1 = 0, sub2 = 0, render_rows = 0, fills_total = 0, full_body = 0;
    int a;

    if (stand == NULL || argc < 2) return 2;
    for (a = 1; a < argc; ++a) {
        long n = 0;
        unsigned char *bytes = read_file(argv[a], &n);
        SceneResource *scene;
        char err[128] = {0};
        size_t count, i;
        int has = 0;
        if (bytes == NULL) continue;
        scene = scene_resource_open_memory(bytes, (size_t)n, err, sizeof err);
        if (scene != NULL) {
            count = scene_resource_action_count(scene);
            for (i = 0; i < count; ++i) {
                SceneActionInfo info;
                if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) continue;
                if (info.type != SESSION_A1C_TYPE) continue;
                has = 1;
                ++rows;
                tail_rows += info.dependency_count != 0u;
                sub1 += info.subtype == 1u;
                sub2 += info.subtype == 2u;
                full_body += info.raw_body_length >= C1C_BODY_BYTES;
                const int step = drive_row(stand, &info, &fills_total, &render_rows);
                if (step == 0) {
                    ++ok;
                } else {
                    ++bad;
                    printf("ROW_FAIL %s row=%zu type=%02x step=%d\n", argv[a], i, info.type, step);
                }
            }
            scene_resource_close(scene);
        }
        scenes += has;
        free(bytes);
    }
    printf("SUMMARY scenes=%lu rows=%lu ok=%lu bad=%lu tail_rows=%lu sub1=%lu sub2=%lu full_body=%lu render_rows=%lu fills=%lu opens=%lu "
           "closes=%lu allocs=%lu registers=%lu releases=%lu\n",
           scenes, rows, ok, bad, tail_rows, sub1, sub2, full_body, render_rows, fills_total, stand->opens, stand->closes, stand->allocs,
           stand->registers, stand->releases);
    free(stand);
    return bad == 0 ? 0 : 1;
}
