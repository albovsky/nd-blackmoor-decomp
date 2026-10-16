/* RT-27 corpus check: runs every raw 0x4f row of the decoded scene resources given on the command line through the
 * production parser, the decoder and the session binding on a world whose values make most tests true. Output is
 * derived counts only (the resource bytes stay in work/): one "ROW_FAIL ..." line per failing row and a final
 * "SUMMARY ..." line. With --dump as the first argument it instead prints "<subtype> <10 body bytes in hex>" per row for the
 * original-x86 oracle (consumed in memory by tests/action_family_4f_runtime_original_oracle.py, never stored). */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_resource.h"
#include "session_bindings_a4f.h"

#define FLAGS 1600u

int main(int argc, char **argv)
{
    static int32_t flags[FLAGS];
    ActionCoreWorld world;
    SessionA4FBinding *binding;
    unsigned long scenes = 0, rows = 0, ok = 0, error = 0, tail_rows = 0, mode3 = 0, other_mode = 0, op_count[8] = {0},
                  subtype1 = 0, flag_none = 0, flag_max = 0, flag_min = 100000, found_rows = 0, unused_operands = 0;
    int a, dump = argc > 1 && strcmp(argv[1], "--dump") == 0;

    memset(&world, 0, sizeof world);
    world.event_flags = flags;
    world.event_flag_count = FLAGS;
    action_core_initialize_values(&world);
    binding = session_a4f_create(&world);
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
                SceneActionRuntimeState before = {0u, 3u};
                SceneActionHandlerResult out = {SCENE_ACTION_HANDLER_PENDING, 3u};
                ActionFamily4FDecoded d;
                unsigned k;
                if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK || info.type != SESSION_A4F_TYPE) continue;
                has = 1;
                ++rows;
                if (dump) {
                    printf("%u ", (unsigned)info.subtype);
                    for (k = 0; k < info.typed_body_length; ++k) printf("%02x", info.typed_body[k]);
                    printf("\n");
                    continue;
                }
                subtype1 += info.subtype == 1u;
                if (info.raw_body_length > info.typed_body_length) ++tail_rows;
                if (info.typed_body_length != ACTION_FAMILY_4F_BODY_BYTES ||
                    action_family_4f_decode(info.typed_body, info.typed_body_length, &d) != ACTION_FAMILY_4F_OK) {
                    ++error;
                    printf("ROW_FAIL decode %s row %zu\n", argv[a], i);
                    continue;
                }
                if (d.mode == 3u) ++mode3; else ++other_mode;
                if (d.op < 8u) ++op_count[d.op];
                if (d.flag == -1) ++flag_none;
                else {
                    if ((unsigned long)d.flag > flag_max) flag_max = (unsigned long)d.flag;
                    if ((unsigned long)d.flag < flag_min) flag_min = (unsigned long)d.flag;
                }
                for (k = 0; k < ACTION_FAMILY_4F_OPERAND_COUNT; ++k) unused_operands += d.operand[k] == 99u;
                /* Make attribute d.attribute true against its first literal where it is a value slot. */
                if (d.attribute < ACTION_CORE_SHORT_SLOT_COUNT) world.short_values[d.attribute] = (int16_t)d.operand[0];
                else if (d.attribute < ACTION_CORE_SHORT_SLOT_COUNT + ACTION_CORE_FLOAT_SLOT_COUNT)
                    world.float_values[d.attribute - ACTION_CORE_SHORT_SLOT_COUNT] = (float)d.operand[0];
                memset(flags, 0, sizeof flags);
                if (session_a4f_handler(binding, i, &info, &before, &out) == SCENE_ACTION_HANDLER_OK && out.phase == 0u &&
                    out.disposition == SCENE_ACTION_HANDLER_COMPLETED) {
                    ++ok;
                    if (d.flag != -1 && flags[d.flag] == 1) ++found_rows;
                } else {
                    ++error;
                    printf("ROW_FAIL handler %s row %zu\n", argv[a], i);
                }
                action_core_initialize_values(&world);
            }
            scene_resource_close(scene);
        }
        free(bytes);
        scenes += has;
    }
    if (!dump) {
        printf("SUMMARY scenes=%lu rows=%lu ok=%lu error=%lu mode3=%lu other_mode=%lu op0=%lu op1=%lu op2=%lu op3=%lu op_other=%lu "
               "subtype1=%lu tail_rows=%lu flag_none=%lu flag_min=%lu flag_max=%lu found=%lu\n",
               scenes, rows, ok, error, mode3, other_mode, op_count[0], op_count[1], op_count[2], op_count[3],
               op_count[4] + op_count[5] + op_count[6] + op_count[7], subtype1, tail_rows, flag_none, flag_min, flag_max,
               found_rows);
        (void)unused_operands;
    }
    session_a4f_destroy(binding);
    return error == 0ul ? 0 : 1;
}
