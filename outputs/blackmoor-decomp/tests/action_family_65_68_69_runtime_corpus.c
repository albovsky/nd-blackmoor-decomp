/* RT-37 corpus check: runs every raw 0x65, 0x68 and 0x69 row of the decoded scene resources given on the command line
 * through the production parser and the session binding. Output is derived counts only (the resource bytes stay in work/):
 * one "ROW_FAIL ..." line per failing row and a final "SUMMARY ..." line. With --dump as the first argument it instead prints
 * "<type hex> <subtype> <typed body bytes in hex> <tail bytes>" per row for the original-x86 oracle (consumed in memory by
 * tests/action_family_65_68_69_runtime_original_oracle.py, never stored). */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_resource.h"
#include "session_bindings_a65_a68_a69.h"

typedef struct {
    uint8_t records[SESSION_TIMER_RECORD_COUNT][SESSION_TIMER_RECORD_BYTES];
    unsigned saves;
} Host;

static uint8_t *time_record(void *context, unsigned index)
{
    Host *h = (Host *)context;
    return index < SESSION_TIMER_RECORD_COUNT ? h->records[index] : NULL;
}

static void save_game(void *context, const char *name, int report_failure)
{
    Host *h = (Host *)context;
    (void)name;
    (void)report_failure;
    ++h->saves;
}

int main(int argc, char **argv)
{
    static Host host;
    SessionA65Host hooks;
    SessionA65Binding *binding;
    unsigned long scenes = 0, rows[3] = {0}, ok[3] = {0}, error = 0, tail_rows = 0, sub1 = 0, sub_other = 0, max_index = 0, body_other = 0;
    int a, dump = argc > 1 && strcmp(argv[1], "--dump") == 0;

    memset(&hooks, 0, sizeof hooks);
    hooks.context = &host;
    hooks.time_record = time_record;
    hooks.save_game = save_game;
    binding = session_a65_create(&hooks);
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
                unsigned k, which;
                int status;
                if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) continue;
                if (info.type == SESSION_A65_TYPE) which = 0u;
                else if (info.type == SESSION_A68_TYPE) which = 1u;
                else if (info.type == SESSION_A69_TYPE) which = 2u;
                else continue;
                has = 1;
                ++rows[which];
                if (dump) {
                    printf("%02x %u ", (unsigned)info.type, (unsigned)info.subtype);
                    for (k = 0; k < info.typed_body_length; ++k) printf("%02x", info.typed_body[k]);
                    printf(" %zu\n", info.raw_body_length - info.typed_body_length);
                    continue;
                }
                if (info.subtype == 1u) ++sub1; else ++sub_other;
                if (info.raw_body_length > info.typed_body_length) ++tail_rows;
                if (which != 0u) {
                    if (info.typed_body[0] > max_index) max_index = info.typed_body[0];
                } else if (info.typed_body[0] != 0u) {
                    ++body_other;
                }
                memset(&host, 0, sizeof host);
                status = which == 0u ? session_a65_handler(binding, i, &info, &before, &out)
                       : which == 1u ? session_a68_handler(binding, i, &info, &before, &out)
                                     : session_a69_handler(binding, i, &info, &before, &out);
                if (status == SCENE_ACTION_HANDLER_OK && out.phase == 7u && out.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED &&
                    (which == 0u ? host.saves == 1u : 1)) {
                    ++ok[which];
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
        printf("SUMMARY scenes=%lu rows65=%lu rows68=%lu rows69=%lu ok65=%lu ok68=%lu ok69=%lu error=%lu sub1=%lu sub_other=%lu "
               "tail_rows=%lu max_index=%lu body65_nonzero=%lu visits65=%lu visits68=%lu visits69=%lu\n",
               scenes, rows[0], rows[1], rows[2], ok[0], ok[1], ok[2], error, sub1, sub_other, tail_rows, max_index, body_other,
               session_a65_visits(binding), session_a68_visits(binding), session_a69_visits(binding));
    }
    session_a65_destroy(binding);
    return error == 0ul ? 0 : 1;
}
