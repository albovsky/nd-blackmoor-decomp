/* RT-33 corpus check: runs every raw 0x2e row of the decoded scene resources given on the command line through the
 * production parser and the session binding (object inactive, then active in each of the modes the corpus carries).
 * Output is derived counts only (the resource bytes stay in work/): one "ROW_FAIL ..." line per failing row and a final
 * "SUMMARY ..." line. With --dump as the first argument it instead prints "<subtype> <typed body bytes in hex>" per row for
 * the original-x86 oracle (consumed in memory by tests/action_family_2e_runtime_original_oracle.py, never stored). */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_resource.h"
#include "session_bindings_a2e.h"

#define TABLE 4096u

static int32_t g_flags[TABLE];
static int32_t g_start;
static unsigned g_transitions;

static void set_start_flag(void *context, int32_t value)
{
    (void)context;
    g_start = value;
}

static int transition(void *context, const SceneTransitionRequest *request)
{
    (void)context;
    (void)request;
    ++g_transitions;
    return 0;
}

int main(int argc, char **argv)
{
    SessionA2EHost host;
    SessionA2EBinding *binding;
    ActionCoreWorld world;
    unsigned long scenes = 0, rows = 0, ok = 0, error = 0, tail_rows = 0, sub1 = 0, sub_other = 0, mode[4] = {0}, mode_other = 0;
    unsigned long active_ok = 0, active_refused = 0;
    int a, dump = argc > 1 && strcmp(argv[1], "--dump") == 0;

    memset(&world, 0, sizeof world);
    world.event_flags = g_flags;
    world.event_flag_count = TABLE;
    memset(&host, 0, sizeof host);
    host.set_start_flag = set_start_flag;
    host.transition = transition;
    binding = session_a2e_create(&host, &world);
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
                SessionA2EMovie movie;
                unsigned k;
                int8_t m;
                if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK || info.type != SESSION_A2E_TYPE) continue;
                has = 1;
                ++rows;
                if (dump) {
                    printf("%u ", (unsigned)info.subtype);
                    for (k = 0; k < info.typed_body_length; ++k) printf("%02x", info.typed_body[k]);
                    printf("\n");
                    continue;
                }
                if (info.subtype == 1u) ++sub1; else ++sub_other;
                if (info.raw_body_length > info.typed_body_length) ++tail_rows;
                m = (int8_t)info.typed_body[0];
                if (m >= 0 && m < 4) ++mode[m]; else ++mode_other;
                memset(&movie, 0, sizeof movie);
                session_a2e_set_movie(binding, &movie);
                if (session_a2e_handler(binding, i, &info, &before, &out) == SCENE_ACTION_HANDLER_OK && out.phase == 7u &&
                    out.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED && session_a2e_movie(binding)->row == (int32_t)i &&
                    session_a2e_movie(binding)->mode == m) {
                    ++ok;
                } else {
                    ++error;
                    printf("ROW_FAIL handler %s row %zu\n", argv[a], i);
                }
                /* the same row with the object active: refused only in mode 0, otherwise it completes */
                movie.active = 1;
                session_a2e_set_movie(binding, &movie);
                memset(g_flags, 0, sizeof g_flags);
                out.disposition = SCENE_ACTION_HANDLER_PENDING;
                {
                    const int status = session_a2e_handler(binding, i, &info, &before, &out);
                    if (m == 0 && status == SCENE_ACTION_HANDLER_UNSUPPORTED) ++active_refused;
                    else if (m != 0 && status == SCENE_ACTION_HANDLER_OK && out.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED) ++active_ok;
                    else {
                        ++error;
                        printf("ROW_FAIL active %s row %zu status %d\n", argv[a], i, status);
                    }
                }
            }
            scene_resource_close(scene);
        }
        free(bytes);
        scenes += has;
    }
    if (!dump) {
        printf("SUMMARY scenes=%lu rows=%lu ok=%lu error=%lu sub1=%lu sub_other=%lu tail_rows=%lu mode0=%lu mode1=%lu mode2=%lu "
               "mode3=%lu mode_other=%lu active_ok=%lu active_refused=%lu visits=%lu\n",
               scenes, rows, ok, error, sub1, sub_other, tail_rows, mode[0], mode[1], mode[2], mode[3], mode_other, active_ok,
               active_refused, session_a2e_visits(binding));
    }
    session_a2e_destroy(binding);
    return error == 0ul ? 0 : 1;
}
