/* RT-30 corpus check: runs every raw 0x67 row of the decoded scene resources given on the command line through the
 * production parser and the session binding. Output is derived counts only (the resource bytes stay in work/): one
 * "ROW_FAIL ..." line per failing row and a final "SUMMARY ..." line. With --dump as the first argument it instead prints
 * "<subtype> <typed body bytes in hex>" per row for the original-x86 oracle (consumed in memory by
 * tests/action_family_67_runtime_original_oracle.py, never stored). */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_resource.h"
#include "session_bindings_a67.h"

static int32_t g_flag;

static void set_flag(void *context, int32_t value)
{
    (void)context;
    g_flag = value;
}

int main(int argc, char **argv)
{
    SessionA67Host host;
    SessionA67Binding *binding;
    unsigned long scenes = 0, rows = 0, ok = 0, error = 0, tail_rows = 0, sub[4] = {0}, sub_other = 0, body_zero = 0, body_other = 0;
    int a, dump = argc > 1 && strcmp(argv[1], "--dump") == 0;

    memset(&host, 0, sizeof host);
    host.set_start_flag = set_flag;
    binding = session_a67_create(&host);
    if (binding == NULL) return 2;
    for (a = dump ? 2 : 1; a < argc; ++a) {
        FILE *f = fopen(argv[a], "rb");
        unsigned char *bytes;
        long n;
        SceneResource *scene;
        size_t count, i;
        int has = 0;
        char err[128] = {0};
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
                SceneActionRuntimeState before = {0u, 7u};
                SceneActionHandlerResult out = {SCENE_ACTION_HANDLER_PENDING, 0u};
                unsigned k;
                if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK || info.type != SESSION_A67_TYPE) continue;
                has = 1;
                ++rows;
                if (dump) {
                    printf("%u ", (unsigned)info.subtype);
                    for (k = 0; k < info.typed_body_length; ++k) printf("%02x", info.typed_body[k]);
                    printf("\n");
                    continue;
                }
                if (info.subtype < 4u) ++sub[info.subtype]; else ++sub_other;
                if (info.raw_body_length > info.typed_body_length) ++tail_rows;
                if (info.typed_body_length == 1u && info.typed_body[0] == 0u) ++body_zero; else ++body_other;
                g_flag = 0;
                if (session_a67_handler(binding, i, &info, &before, &out) == SCENE_ACTION_HANDLER_OK && out.phase == 7u &&
                    out.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED && g_flag == 1) {
                    ++ok;
                } else {
                    ++error;
                    printf("ROW_FAIL handler %s row %zu\n", argv[a], i);
                }
            }
            scene_resource_close(scene);
        }
        free(bytes);
        scenes += has;
    }
    if (!dump) {
        printf("SUMMARY scenes=%lu rows=%lu ok=%lu error=%lu sub0=%lu sub1=%lu sub2=%lu sub3=%lu sub_other=%lu tail_rows=%lu "
               "body_zero=%lu body_other=%lu visits=%lu\n",
               scenes, rows, ok, error, sub[0], sub[1], sub[2], sub[3], sub_other, tail_rows, body_zero, body_other,
               session_a67_visits(binding));
    }
    session_a67_destroy(binding);
    return error == 0ul ? 0 : 1;
}
