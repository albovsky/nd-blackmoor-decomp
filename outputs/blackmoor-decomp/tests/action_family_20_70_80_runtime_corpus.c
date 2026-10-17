/* RT-48 corpus check: runs every raw 0x20, 0x70 and 0x80 row of the decoded scene resources given on the command line through
 * the production parser and the session bindings (stand-in hosts that accept everything). Output is derived counts only (the
 * resource bytes stay in work/): one "ROW_FAIL ..." line per failing row and a final "SUMMARY ..." line. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_resource.h"
#include "session_bindings_a20_a70_a80.h"

typedef struct {
    unsigned long erased_calls, unload_calls, transitions, store20, last_target;
    int32_t last_scene_dword;
} Stand;

static int s_erase(void *c, uint32_t *n)
{
    Stand *s = (Stand *)c;
    ++s->erased_calls;
    *n = 1u;
    return 0;
}

static int s_load20(void *c, Action20World *w)
{
    (void)c;
    memset(w, 0, sizeof *w);
    w->scene_5bb57f = 100;
    return 0;
}

static void s_store20(void *c, const Action20World *w)
{
    Stand *s = (Stand *)c;
    ++s->store20;
    s->last_scene_dword = w->view_cell_63aa10;
}

static int s_unload(void *c)
{
    ++((Stand *)c)->unload_calls;
    return 0;
}

static int s_load_object(void *c, int uses, Action80Object *o)
{
    (void)c;
    (void)uses;
    memset(o, 0, sizeof *o);
    o->scene_6ba = 1234;
    return 0;
}

static int s_transition(void *c, const SceneTransitionRequest *r)
{
    Stand *s = (Stand *)c;
    ++s->transitions;
    s->last_target = (unsigned long)(unsigned short)r->target_scene;
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
    SessionA20Host h20;
    SessionA70Host h70;
    SessionA80Host h80;
    SessionA20Binding *b20;
    SessionA70Binding *b70;
    SessionA80Binding *b80;
    unsigned long scenes = 0, rows = 0, ok = 0, bad = 0, tail_rows = 0, sub1 = 0, n20 = 0, n70 = 0, n80 = 0, w9999 = 0, w_literal = 0;
    int a;

    if (argc < 2) return 2;
    memset(&stand, 0, sizeof stand);
    memset(&h20, 0, sizeof h20);
    memset(&h70, 0, sizeof h70);
    memset(&h80, 0, sizeof h80);
    h20.context = h70.context = h80.context = &stand;
    h20.load_world = s_load20;
    h20.store_world = s_store20;
    h20.erase_rows = s_erase;
    h70.unload_scene_sound = s_unload;
    h80.load_object = s_load_object;
    h80.transition = s_transition;
    b20 = session_a20_create(&h20);
    b70 = session_a70_create(&h70);
    b80 = session_a80_create(&h80);
    if (b20 == NULL || b70 == NULL || b80 == NULL) return 2;
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
                int status = -1;
                if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) continue;
                if (info.type != SESSION_A20_TYPE && info.type != SESSION_A70_TYPE && info.type != SESSION_A80_TYPE) continue;
                has = 1;
                ++rows;
                tail_rows += info.dependency_count != 0u;
                sub1 += info.subtype == 1u;
                if (info.type == SESSION_A20_TYPE) {
                    ++n20;
                    status = session_a20_handler(b20, i, &info, &before, &r);
                } else if (info.type == SESSION_A70_TYPE) {
                    ++n70;
                    status = session_a70_handler(b70, i, &info, &before, &r);
                } else {
                    const int word = (int16_t)(info.raw_body[0] | (info.raw_body[1] << 8));
                    ++n80;
                    w9999 += word == 9999;
                    w_literal += word != 9999;
                    status = session_a80_handler(b80, i, &info, &before, &r);
                }
                if (status == SCENE_ACTION_HANDLER_OK && r.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED) {
                    ++ok;
                } else {
                    ++bad;
                    printf("ROW_FAIL %s row=%zu type=%02x status=%d\n", argv[a], i, info.type, status);
                }
            }
            scene_resource_close(scene);
        }
        scenes += has;
        free(bytes);
    }
    printf("SUMMARY scenes=%lu rows=%lu ok=%lu bad=%lu tail_rows=%lu sub1=%lu n20=%lu n70=%lu n80=%lu w9999=%lu w_literal=%lu "
           "erase_calls=%lu unloads=%lu transitions=%lu\n",
           scenes, rows, ok, bad, tail_rows, sub1, n20, n70, n80, w9999, w_literal, stand.erased_calls, stand.unload_calls,
           stand.transitions);
    session_a20_destroy(b20);
    session_a70_destroy(b70);
    session_a80_destroy(b80);
    return bad == 0 ? 0 : 1;
}
