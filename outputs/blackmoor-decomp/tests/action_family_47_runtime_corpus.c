/* RT-42 corpus check: runs every raw 0x47 row of the decoded scene resources given on the command line through the production
 * parser and the session binding (a lookup that serves every key). Output is derived counts only (the resource bytes stay in
 * work/): one "ROW_FAIL ..." line per failing row and a final "SUMMARY ..." line.
 * With --dump as the first argument it instead prints "<subtype> <raw body bytes in hex>" per row for the original-x86 oracle
 * (consumed in memory by tests/action_family_47_runtime_original_oracle.py, never stored). */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_resource.h"
#include "session_bindings_a47.h"

static unsigned long g_lookups;

static ActionFamily51LookupStatus lookup(void *c, const uint8_t *key, size_t key_length, const uint8_t **text, size_t *length)
{
    (void)c;
    (void)key;
    (void)key_length;
    ++g_lookups;
    *text = (const uint8_t *)"";
    *length = 0u;
    return ACTION_FAMILY_51_LOOKUP_FOUND;
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
    SessionA47Host host;
    SessionA47Binding *binding;
    unsigned long scenes = 0, rows = 0, ok = 0, bad = 0, tail_rows = 0, sub[4] = {0}, kind[8] = {0}, flagged = 0, dup = 0;
    int a, dump = argc > 1 && strcmp(argv[1], "--dump") == 0;

    if (argc < 2) return 2;
    memset(&host, 0, sizeof host);
    host.lookup = lookup;
    binding = session_a47_create(&host);
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
            session_a47_reset(binding);   /* a scene's rows run against fresh tables */
            for (i = 0; i < count; ++i) {
                SceneActionInfo info;
                size_t k;
                if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) continue;
                if (info.type != SESSION_A47_TYPE) continue;
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
                    const A47Outcome *o;
                    memset(&out, 0, sizeof out);
                    if (session_a47_handler(binding, i, &info, &before, &out) == SCENE_ACTION_HANDLER_OK &&
                        out.disposition == SCENE_ACTION_HANDLER_COMPLETED && out.phase == 0u) {
                        ++ok;
                        o = session_a47_last_outcome(binding);
                        if (o->flag_call) ++flagged;
                        if (o->duplicate) ++dup;
                        if (o->table >= 0 && o->table < 8) ++kind[o->table + 3];
                    } else {
                        ++bad;
                        printf("ROW_FAIL %s row %zu: %s\n", argv[a], i, session_a47_failure(binding));
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
        printf("SUMMARY scenes=%lu rows=%lu ok=%lu bad=%lu tail_rows=%lu sub0=%lu sub1=%lu sub2=%lu sub_other=%lu kind3=%lu kind4=%lu "
               "kind5=%lu flagged=%lu duplicates=%lu adds=%lu lookups=%lu\n",
               scenes, rows, ok, bad, tail_rows, sub[0], sub[1], sub[2], sub[3], kind[3], kind[4], kind[5], flagged, dup,
               session_a47_adds(binding), g_lookups);
    }
    session_a47_destroy(binding);
    return bad == 0ul ? 0 : 1;
}
