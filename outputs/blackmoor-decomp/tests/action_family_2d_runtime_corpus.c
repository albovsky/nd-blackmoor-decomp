/* RT-36 corpus check: parses every raw 0x2d row of the decoded scene resources given on the command line with the production
 * parser, binds the scene (the scene clear, the parse, the render entry registration) and runs the row's phase 0 once with no
 * media service (it must be refused before any effect). Output is derived counts only (the resource bytes stay in work/): one
 * "ROW_FAIL ..." line per failing row and a final "SUMMARY ..." line. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_resource.h"
#include "session_bindings_a2d.h"

static unsigned long g_ops;

static int host_op(void *context, int op, const D2OpArgs *args, int32_t *ret)
{
    (void)context;
    (void)op;
    (void)args;
    *ret = 0;
    ++g_ops;
    return 0;
}

static int no_media(void *context)
{
    (void)context;
    return 0;
}

int main(int argc, char **argv)
{
    SessionA2dHost host;
    SessionA2dBinding *binding;
    unsigned long scenes = 0, rows = 0, ok = 0, error = 0, sub1 = 0, sub_other = 0, entries = 0, groups = 0, ring = 0, tail_rows = 0;
    int a;

    memset(&host, 0, sizeof host);
    host.kernel.op = host_op;
    host.media_available = no_media;
    binding = session_a2d_create(&host);
    if (binding == NULL) return 2;
    for (a = 1; a < argc; ++a) {
        FILE *f = fopen(argv[a], "rb");
        unsigned char *bytes;
        long n;
        SceneResource *scene;
        char err[128] = {0};
        size_t count, i;
        int has = 0;
        if (f == NULL) continue;
        fseek(f, 0, SEEK_END);
        n = ftell(f);
        fseek(f, 0, SEEK_SET);
        bytes = malloc((size_t)n);
        if (bytes == NULL || fread(bytes, 1, (size_t)n, f) != (size_t)n) {
            fclose(f);
            free(bytes);
            continue;
        }
        fclose(f);
        scene = scene_resource_open_memory(bytes, (size_t)n, err, sizeof err);
        if (scene != NULL) {
            count = scene_resource_action_count(scene);
            for (i = 0; i < count; ++i) {
                SceneActionInfo info;
                D2Set set;
                const char *why = NULL;
                if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK || info.type != SESSION_A2D_TYPE) continue;
                has = 1;
                ++rows;
                if (info.subtype == 1u) ++sub1; else ++sub_other;
                if (info.raw_body_length > info.typed_body_length) ++tail_rows;
                memset(&set, 0, sizeof set);
                if (d2_set_parse(info.typed_body, info.typed_body_length, &set, &why) != D2_OK) {
                    ++error;
                    printf("ROW_FAIL parse %s row %zu: %s\n", argv[a], i, why != NULL ? why : "?");
                    continue;
                }
                entries += (unsigned long)set.entry_count;
                groups += (unsigned long)set.group_count;
                if (set.mode_word == 1) ++ring;
                d2_set_free(&set);
                {
                    SceneActionRuntimeState before = {0u, 0u};
                    SceneActionHandlerResult out = {SCENE_ACTION_HANDLER_PENDING, 0u};
                    unsigned long ops;
                    const int bound = session_a2d_begin_scene(binding, scene) == D2_OK;
                    ops = g_ops;
                    if (bound &&
                        session_a2d_handler(binding, i, &info, &before, &out) == SCENE_ACTION_HANDLER_UNSUPPORTED &&
                        g_ops == ops && session_a2d_object(binding)->movie.active == 0) {
                        ++ok;
                    } else {
                        ++error;
                        printf("ROW_FAIL bind %s row %zu: %s\n", argv[a], i,
                               session_a2d_failure(binding) != NULL ? session_a2d_failure(binding) : "refusal");
                    }
                }
            }
            scene_resource_close(scene);
        }
        free(bytes);
        scenes += has;
    }
    printf("SUMMARY scenes=%lu rows=%lu ok=%lu error=%lu sub1=%lu sub_other=%lu tail_rows=%lu entries=%lu groups=%lu ring=%lu\n", scenes,
           rows, ok, error, sub1, sub_other, tail_rows, entries, groups, ring);
    session_a2d_destroy(binding);
    return error == 0ul ? 0 : 1;
}
