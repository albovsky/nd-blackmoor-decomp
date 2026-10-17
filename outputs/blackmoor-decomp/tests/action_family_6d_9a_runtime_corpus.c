/* RT-57 corpus check: runs every raw 0x6d and 0x9a row of the decoded scene resources given on the command line through the
 * production parser and the session bindings (stand-in hosts that accept everything). Output is derived counts only (the
 * resource bytes stay in work/): one "ROW_FAIL ..." line per failing row and a final "SUMMARY ..." line. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_resource.h"
#include "session_bindings_a6d_a9a.h"

typedef struct {
    unsigned long unloads, teardowns, stops, stop_low, stop_high, flag_queries, flag_stores, transitions, store6d, store9a;
    int last_target;
} Stand;

static int s_load6d(void *c, Action6DWorld *w)
{
    (void)c;
    memset(w, 0, sizeof *w);
    return 0;
}

static void s_store6d(void *c, const Action6DWorld *w)
{
    (void)w;
    ++((Stand *)c)->store6d;
}

static int s_unload(void *c)
{
    ++((Stand *)c)->unloads;
    return 0;
}

static int s_stop(void *c, uint16_t channel)
{
    Stand *s = (Stand *)c;
    ++s->stops;
    s->stop_low += channel < 14u;
    s->stop_high += channel >= 14u;
    return 0;
}

static int s_invalid(void *c, int16_t index)
{
    ++((Stand *)c)->flag_queries;
    return index < 0 || index >= 0x400;
}

static int s_store_flag(void *c, int16_t index, uint32_t value)
{
    (void)index;
    (void)value;
    ++((Stand *)c)->flag_stores;
    return 0;
}

static void s_store9a(void *c, const Action9AWorld *w)
{
    (void)w;
    ++((Stand *)c)->store9a;
}

static int s_transition(void *c, const SceneTransitionRequest *r)
{
    Stand *s = (Stand *)c;
    ++s->transitions;
    s->last_target = r->target_scene;
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
    Stand stand;
    SessionA6dHost h6d;
    SessionA9aHost h9a;
    SessionA6dBinding *b6d;
    SessionA9aBinding *b9a;
    unsigned long scenes = 0, rows = 0, ok = 0, bad = 0, tail_rows = 0, sub1 = 0, n6d = 0, n9a = 0, scene_rows = 0, no_scene_rows = 0,
                  sound_all = 0, sound_from1 = 0, sound_single = 0, flag_rows = 0, pending_ok = 0;
    int a;

    if (argc < 2) return 2;
    memset(&stand, 0, sizeof stand);
    memset(&h6d, 0, sizeof h6d);
    memset(&h9a, 0, sizeof h9a);
    h6d.context = h9a.context = &stand;
    h6d.load_world = s_load6d;
    h6d.store_world = s_store6d;
    h6d.unload_scene_sound = s_unload;
    h9a.store_world = s_store9a;
    h9a.stop_channel = s_stop;
    h9a.event_flag_invalid = s_invalid;
    h9a.store_event_flag = s_store_flag;
    h9a.transition = s_transition;
    b6d = session_a6d_create(&h6d);
    b9a = session_a9a_create(&h9a);
    if (b6d == NULL || b9a == NULL) return 2;
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
                SceneActionRuntimeState before = {0u, 0u};
                SceneActionHandlerResult r;
                int status;
                if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) continue;
                if (info.type != SESSION_A6D_TYPE && info.type != SESSION_A9A_TYPE) continue;
                has = 1;
                ++rows;
                tail_rows += info.dependency_count != 0u;
                sub1 += info.subtype == 1u;
                if (info.type == SESSION_A6D_TYPE) {
                    ++n6d;
                    status = session_a6d_handler(b6d, i, &info, &before, &r);
                    if (status == SCENE_ACTION_HANDLER_OK && r.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED &&
                        r.phase == before.phase) {
                        ++ok;
                    } else {
                        ++bad;
                        printf("ROW_FAIL %s row=%zu type=%02x status=%d\n", argv[a], i, info.type, status);
                    }
                } else {
                    const int sound = (int16_t)(info.raw_body[0] | (info.raw_body[1] << 8));
                    const int scene_word = (int16_t)(info.raw_body[2] | (info.raw_body[3] << 8));
                    const int flag = (int16_t)(info.raw_body[22] | (info.raw_body[23] << 8));
                    ++n9a;
                    sound_all += sound == 0x14;
                    sound_from1 += sound == 0x15;
                    sound_single += sound != 0x14 && sound != 0x15;
                    scene_rows += scene_word != 9999;
                    no_scene_rows += scene_word == 9999;
                    flag_rows += flag != -1;
                    status = session_a9a_handler(b9a, i, &info, &before, &r);          /* phase 0: pending with phase 2 */
                    if (status == SCENE_ACTION_HANDLER_OK && r.disposition == SCENE_ACTION_HANDLER_PENDING && r.phase == 2u) {
                        ++pending_ok;
                        before.phase = 2u;
                        status = session_a9a_handler(b9a, i, &info, &before, &r);       /* phase 2: the work, direct completion */
                        if (status == SCENE_ACTION_HANDLER_OK && r.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED &&
                            r.phase == 2u) {
                            ++ok;
                        } else {
                            ++bad;
                            printf("ROW_FAIL %s row=%zu type=%02x phase2 status=%d\n", argv[a], i, info.type, status);
                        }
                    } else {
                        ++bad;
                        printf("ROW_FAIL %s row=%zu type=%02x phase0 status=%d\n", argv[a], i, info.type, status);
                    }
                }
            }
            scene_resource_close(scene);
        }
        scenes += has;
        free(bytes);
    }
    printf("SUMMARY scenes=%lu rows=%lu ok=%lu bad=%lu tail_rows=%lu sub1=%lu n6d=%lu n9a=%lu pending_ok=%lu scene_rows=%lu "
           "no_scene_rows=%lu sound_all=%lu sound_from1=%lu sound_single=%lu flag_rows=%lu unloads=%lu stops=%lu stop_low=%lu "
           "stop_high=%lu flag_queries=%lu flag_stores=%lu transitions=%lu store6d=%lu store9a=%lu target=%d\n",
           scenes, rows, ok, bad, tail_rows, sub1, n6d, n9a, pending_ok, scene_rows, no_scene_rows, sound_all, sound_from1,
           sound_single, flag_rows, stand.unloads, stand.stops, stand.stop_low, stand.stop_high, stand.flag_queries,
           stand.flag_stores, stand.transitions, stand.store6d, stand.store9a, stand.last_target);
    session_a6d_destroy(b6d);
    session_a9a_destroy(b9a);
    return bad == 0 ? 0 : 1;
}
