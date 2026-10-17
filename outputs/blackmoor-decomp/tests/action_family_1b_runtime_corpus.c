/* RT-40 corpus check: runs every raw 0x1b row of the decoded scene resources given on the command line through the production
 * parser and the session binding (phases 0, 1 and 2 on a host serving every selector and held item the row names). Output is
 * derived counts only (the resource bytes stay in work/): one "ROW_FAIL ..." line per failing row and a final "SUMMARY ..." line.
 * With --dump as the first argument it instead prints "<subtype> <raw body bytes in hex>" per row for the original-x86 oracle
 * (consumed in memory by tests/action_family_1b_runtime_original_oracle.py, never stored). */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_resource.h"
#include "session_bindings_a1b.h"

static unsigned long g_transitions;
static Action1bWorld g_world;

static int load_world(void *c, Action1bWorld *world)
{
    (void)c;
    *world = g_world;
    return 0;
}

static int transition(void *c, const SceneTransitionRequest *request)
{
    (void)c;
    (void)request;
    ++g_transitions;
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

int main(int argc, char **argv)
{
    SessionA1bHost host;
    SessionA1bBinding *binding;
    unsigned long scenes = 0, rows = 0, ok = 0, bad = 0, scene_fail = 0, tail_rows = 0, primary = 0, secondary = 0, hits = 0, sub[4] = {0};
    int a, dump = argc > 1 && strcmp(argv[1], "--dump") == 0;
    char err[128] = {0};

    if (argc < 2 + (dump ? 1 : 0)) return 2;
    memset(&host, 0, sizeof host);
    host.load_world = load_world;
    host.transition = transition;
    binding = session_a1b_create(&host);
    if (binding == NULL) return 2;
    for (a = dump ? 2 : 1; a < argc; ++a) {
        long n = 0;
        unsigned char *bytes = read_file(argv[a], &n);
        SceneResource *scene;
        size_t count, i;
        int has = 0;
        if (bytes == NULL) continue;
        scene = scene_resource_open_memory(bytes, (size_t)n, err, sizeof err);
        if (scene != NULL) {
            count = scene_resource_action_count(scene);
            if (!dump && session_a1b_begin_scene(binding, scene) != ACTION17_OK) {
                ++scene_fail;
                printf("SCENE_FAIL %s: %s\n", argv[a], session_a1b_failure(binding));
                scene_resource_close(scene);
                free(bytes);
                continue;
            }
            for (i = 0; i < count; ++i) {
                SceneActionInfo info;
                size_t k;
                if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) continue;
                if (info.type != SESSION_A1B_TYPE) continue;
                has = 1;
                ++rows;
                if (dump) {
                    printf("%u ", (unsigned)info.subtype);
                    for (k = 0; k < info.raw_body_length; ++k) printf("%02x", info.raw_body[k]);
                    printf("\n");
                    continue;
                }
                {
                    ActionFamily1bDecoded d;
                    int row_ok = 1;
                    SceneActionHandlerResult out;
                    unsigned phase;
                    if (action_family_1b_decode(info.raw_body, info.raw_body_length, &d) != ACTION_FAMILY_1B_OK) row_ok = 0;
                    if (row_ok) {
                        primary += (unsigned long)d.primary_count;
                        secondary += (unsigned long)d.secondary_count;
                        for (phase = 0u; phase < 3u && row_ok; ++phase) {
                            SceneActionRuntimeState before = {0u, phase};
                            Action17Slot slot;
                            memset(&g_world, 0, sizeof g_world);
                            g_world.held_item = -1;
                            if (d.secondary_count > 0) g_world.selector = (int16_t)(d.secondary_records[0] | (d.secondary_records[1] << 8));
                            if (d.primary_count > 0) g_world.held_item = (int16_t)(d.primary_records[0] | (d.primary_records[1] << 8));
                            memset(&out, 0, sizeof out);
                            if (session_a1b_handler(binding, i, &info, &before, &out) != SCENE_ACTION_HANDLER_OK) row_ok = 0;
                            if (phase == 1u && session_a1b_slot(binding, i, &slot) == ACTION17_OK && slot.request == 1) ++hits;
                            if (phase == 2u && (out.disposition != SCENE_ACTION_HANDLER_DIRECT_COMPLETED || out.phase != 2u)) row_ok = 0;
                        }
                    }
                    if (info.raw_body_length > info.typed_body_length) ++tail_rows;
                    if (info.subtype < 3u) ++sub[info.subtype]; else ++sub[3];
                    if (row_ok) {
                        ++ok;
                    } else {
                        ++bad;
                        printf("ROW_FAIL %s row %zu\n", argv[a], i);
                    }
                }
            }
            scene_resource_close(scene);
        }
        free(bytes);
        scenes += has;
    }
    if (!dump) {
        printf("SUMMARY scenes=%lu rows=%lu ok=%lu bad=%lu scene_fail=%lu tail_rows=%lu primary=%lu secondary=%lu hover_hits=%lu "
               "transitions=%lu sub0=%lu sub1=%lu sub2=%lu sub_other=%lu\n",
               scenes, rows, ok, bad, scene_fail, tail_rows, primary, secondary, hits, g_transitions, sub[0], sub[1], sub[2], sub[3]);
    }
    session_a1b_destroy(binding);
    return bad == 0ul && scene_fail == 0ul ? 0 : 1;
}
