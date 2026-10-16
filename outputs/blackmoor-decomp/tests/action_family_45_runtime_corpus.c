/* RT-38 corpus check: runs every raw 0x45 row of the decoded scene resources given on the command line through the production
 * parser and the session binding. Output is derived counts only (the resource bytes stay in work/): one "ROW_FAIL ..." line
 * per failing row and a final "SUMMARY ..." line. With --dump as the first argument it instead prints
 * "<type hex> <subtype> <typed body bytes in hex> <tail bytes>" per row for the original-x86 oracle (consumed in memory by
 * tests/action_family_45_runtime_original_oracle.py, never stored). */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_resource.h"
#include "session_bindings_a45.h"

typedef struct {
    uint8_t records[SESSION_TIMER_RECORD_COUNT][SESSION_TIMER_RECORD_BYTES];
} Host;

static uint8_t *time_record(void *context, unsigned index)
{
    Host *h = (Host *)context;
    return index < SESSION_TIMER_RECORD_COUNT ? h->records[index] : NULL;
}

static int variable_word(void *context, int16_t index, int16_t *value)
{
    (void)context;
    *value = (int16_t)(index - 4900); /* a stand-in table word: the real words are the app's BSUM-backed ones */
    return 1;
}

int main(int argc, char **argv)
{
    static Host host;
    SessionA45Host hooks;
    SessionA45Binding *binding;
    unsigned long scenes = 0, rows = 0, ok = 0, unsupported = 0, error = 0, tail_rows = 0, sub1 = 0, sub_other = 0, table_rows = 0;
    unsigned long modes[8] = {0}, max_record = 0, max_count = 0;
    int a, dump = argc > 1 && strcmp(argv[1], "--dump") == 0;

    memset(&hooks, 0, sizeof hooks);
    hooks.context = &host;
    hooks.time_record = time_record;
    hooks.variable_word = variable_word;
    binding = session_a45_create(&hooks);
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
                int status;
                int16_t mode, seconds;
                if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) continue;
                if (info.type != SESSION_A45_TYPE) continue;
                has = 1;
                ++rows;
                if (dump) {
                    printf("%02x %u ", (unsigned)info.type, (unsigned)info.subtype);
                    for (k = 0; k < info.typed_body_length; ++k) printf("%02x", info.typed_body[k]);
                    printf(" %zu\n", info.raw_body_length - info.typed_body_length);
                    continue;
                }
                if (info.subtype == 1u) ++sub1; else ++sub_other;
                if (info.raw_body_length > info.typed_body_length) ++tail_rows;
                mode = (int16_t)(info.typed_body[2] | (info.typed_body[3] << 8));
                seconds = (int16_t)(info.typed_body[8] | (info.typed_body[9] << 8));
                if (mode >= 0 && mode < 8) ++modes[mode]; else ++modes[7];
                if (seconds >= SESSION_A45_VARIABLE_BASE && mode >= 3 && mode <= 6) ++table_rows;
                if (info.typed_body[0] > max_record) max_record = info.typed_body[0];
                if (info.typed_body[194] > max_count) max_count = info.typed_body[194];
                memset(&host, 0, sizeof host);
                host.records[info.typed_body[0] % SESSION_TIMER_RECORD_COUNT][0] = 1; /* a running timer, so modes 3..6 act */
                status = session_a45_handler(binding, i, &info, &before, &out);
                if (status == SCENE_ACTION_HANDLER_OK && out.phase == 7u) {
                    ++ok;
                } else if (status == SCENE_ACTION_HANDLER_UNSUPPORTED) {
                    ++unsupported;
                    printf("ROW_UNSUPPORTED handler %s row %zu detail=%s\n", argv[a], i, session_a45_failure(binding));
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
        printf("SUMMARY scenes=%lu rows=%lu ok=%lu unsupported=%lu error=%lu sub1=%lu sub_other=%lu tail_rows=%lu "
               "mode0=%lu mode1=%lu mode2=%lu mode3=%lu mode4=%lu mode5=%lu mode6=%lu mode_other=%lu table_rows=%lu "
               "max_record=%lu max_count=%lu completed=%lu pending=%lu\n",
               scenes, rows, ok, unsupported, error, sub1, sub_other, tail_rows, modes[0], modes[1], modes[2], modes[3], modes[4],
               modes[5], modes[6], modes[7], table_rows, max_record, max_count, session_a45_completed(binding), session_a45_pending(binding));
    }
    session_a45_destroy(binding);
    return error == 0ul && unsupported == 0ul ? 0 : 1;
}
