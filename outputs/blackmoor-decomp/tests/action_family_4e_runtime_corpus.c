/* RT-44 corpus check: runs every raw 0x4e row of the decoded scene resources given on the command line through the production
 * parser and the session binding, from freshly initialized value slots (9999 / 9999.0f, as the world initializer 0x44aff2
 * leaves them). Output is derived counts only (the resource bytes stay in work/): one "ROW_FAIL ..." line per failing row and a
 * final "SUMMARY ..." line.
 * With --dump as the first argument it instead prints "<subtype> <raw body bytes in hex>" per row for the original-x86 oracle
 * (consumed in memory by tests/action_family_4e_runtime_original_oracle.py, never stored). */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_resource.h"
#include "session_bindings_a4e.h"

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
    ActionCoreWorld world;
    SessionA4EBinding *binding;
    unsigned long scenes = 0, rows = 0, ok = 0, bad = 0, tail_rows = 0, sub[4] = {0}, valid = 0, terms = 0, unset = 0, reports = 0,
                  literal = 0, short_terms = 0, float_terms = 0;
    int a, dump = argc > 1 && strcmp(argv[1], "--dump") == 0;

    if (argc < 2) return 2;
    memset(&world, 0, sizeof world);
    binding = session_a4e_create(&world);
    if (binding == NULL) return 2;
    for (a = dump ? 2 : 1; a < argc; ++a) {
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
            action_core_initialize_values(&world);   /* a scene's rows run against freshly initialized values */
            for (i = 0; i < count; ++i) {
                SceneActionInfo info;
                size_t k;
                if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) continue;
                if (info.type != SESSION_A4E_TYPE) continue;
                has = 1;
                ++rows;
                if (dump) {
                    printf("%u ", (unsigned)info.subtype);
                    for (k = 0; k < info.raw_body_length; ++k) printf("%02x", info.raw_body[k]);
                    printf("\n");
                    continue;
                }
                {
                    SceneActionHandlerResult out;
                    SceneActionRuntimeState before = {0u, 0u};
                    const ActionFamily4ERuntimeOutcome *o;
                    memset(&out, 0, sizeof out);
                    if (session_a4e_handler(binding, i, &info, &before, &out) == SCENE_ACTION_HANDLER_OK &&
                        out.disposition == SCENE_ACTION_HANDLER_COMPLETED && out.phase == 0u) {
                        ++ok;
                        o = session_a4e_last_outcome(binding);
                        valid += o->target_valid;
                        terms += o->terms_added;
                        unset += o->unset_terms;
                        reports += o->reports;
                        for (k = 0; k < ACTION_FAMILY_4E_ENTRY_COUNT; ++k) {
                            const uint8_t sel = info.raw_body[1u + 3u * k];
                            if (sel == 100u) ++literal;
                            else if (sel < 30u) ++short_terms;
                            else if (sel < 40u) ++float_terms;
                        }
                    } else {
                        ++bad;
                        printf("ROW_FAIL %s row %zu: %s\n", argv[a], i, session_a4e_failure(binding));
                    }
                    if (info.raw_body_length > info.typed_body_length) ++tail_rows;
                    if (info.subtype < 3u) ++sub[info.subtype]; else ++sub[3];
                }
            }
            scene_resource_close(scene);
        }
        free(bytes);
        scenes += has;
    }
    if (!dump) {
        printf("SUMMARY scenes=%lu rows=%lu ok=%lu bad=%lu tail_rows=%lu sub0=%lu sub1=%lu sub2=%lu sub_other=%lu target_valid=%lu "
               "terms=%lu unset=%lu reports=%lu literal=%lu short_sel=%lu float_sel=%lu\n",
               scenes, rows, ok, bad, tail_rows, sub[0], sub[1], sub[2], sub[3], valid, terms, unset, reports, literal, short_terms,
               float_terms);
    }
    session_a4e_destroy(binding);
    return bad == 0ul ? 0 : 1;
}
