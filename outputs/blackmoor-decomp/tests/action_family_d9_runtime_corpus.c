/* RT-24 corpus check: runs every raw 0xd9 row of the decoded scene resources given on the
 * command line through the production parser, the session binding and the kernel with a
 * scripted host (free slots from 0x18, every image loads, a fixed view). For each row the
 * handler is visited for phase 0, then for phase 1 with the pointer at three positions, a
 * render plan is taken, and the scene is cleared. Output is derived counts only: one
 * "ROW ..." line per row and a final "SUMMARY ..." line. Resource bytes stay in work/. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_resource.h"
#include "session_bindings_ad9.h"

typedef struct { int slots, loads, releases, dirty; } Ctx;

static int alloc_slot(void *c, int16_t *s) { (void)c; *s = 0x18; return 0; }
static int register_slot(void *c, int16_t s, uint32_t surf, const char *label)
{
    (void)c; (void)s; (void)surf;
    return strcmp(label, "MOUSELIGHT PUZZLE BITMAP") != 0;
}
static int load_surface(void *c, const char *n, uint32_t *s) { ((Ctx *)c)->loads++; *s = n[0] != '\0' ? 5u : 0u; return 0; }
static int set_slot_surface(void *c, int16_t s, uint32_t surf) { (void)c; (void)s; (void)surf; return 0; }
static int release_surface(void *c, uint32_t s) { (void)s; ((Ctx *)c)->releases++; return 0; }
static int release_slot(void *c, int16_t s) { (void)c; (void)s; return 0; }
static int mark_dirty(void *c, int16_t s) { (void)s; ((Ctx *)c)->dirty++; return 0; }
static int view(void *c, D9View *v) { (void)c; *v = (D9View){0, 0, 340, 639, 339}; return 0; }

int main(int argc, char **argv)
{
    static Ctx ctx;
    SessionAd9Host host;
    unsigned long rows = 0, ok = 0, error = 0, alpha = 0, mask = 0, scenes = 0, multi = 0;
    unsigned long radius[256] = {0};
    int a;
    memset(&host, 0, sizeof host);
    host.kernel.context = &ctx;
    host.kernel.alloc_slot = alloc_slot;
    host.kernel.register_slot = register_slot;
    host.kernel.load_surface = load_surface;
    host.kernel.set_slot_surface = set_slot_surface;
    host.kernel.release_surface = release_surface;
    host.kernel.release_slot = release_slot;
    host.kernel.mark_dirty = mark_dirty;
    host.kernel.view = view;
    for (a = 1; a < argc; ++a) {
        FILE *f = fopen(argv[a], "rb");
        long n;
        unsigned char *bytes;
        char err[128] = {0};
        SceneResource *scene;
        size_t count, d9rows = 0;
        SessionAd9Binding *binding;
        if (f == NULL) continue;
        fseek(f, 0, SEEK_END);
        n = ftell(f);
        fseek(f, 0, SEEK_SET);
        bytes = (unsigned char *)malloc((size_t)n);
        if (bytes == NULL || fread(bytes, 1, (size_t)n, f) != (size_t)n) { fclose(f); free(bytes); continue; }
        fclose(f);
        scene = scene_resource_open_memory(bytes, (size_t)n, err, sizeof err);
        if (scene == NULL) { free(bytes); continue; }
        count = scene_resource_action_count(scene);
        for (size_t i = 0; i < count; ++i) {
            SceneActionInfo info;
            if (scene_resource_action_at(scene, i, &info) == 0 && info.type == SESSION_AD9_TYPE) ++d9rows;
        }
        if (d9rows == 0) { scene_resource_close(scene); free(bytes); continue; }
        ++scenes;
        if (d9rows > 1) ++multi;
        binding = session_ad9_create(&host);
        if (binding == NULL || session_ad9_begin_scene(binding, scene) != D9_OK) {
            printf("SCENE_FAIL %s %s\n", argv[a], binding ? session_ad9_failure(binding) : "create");
            error += d9rows;
            rows += d9rows;
            session_ad9_destroy(binding);
            scene_resource_close(scene);
            free(bytes);
            continue;
        }
        for (size_t i = 0; i < count; ++i) {
            SceneActionInfo info;
            SceneActionRuntimeState st;
            SceneActionHandlerResult out;
            D9RenderPlan plan;
            static const int16_t px[3][2] = {{320, 170}, {0, 0}, {639, 339}};
            int good = 1;
            if (scene_resource_action_at(scene, i, &info) != 0 || info.type != SESSION_AD9_TYPE) continue;
            ++rows;
            memset(&st, 0, sizeof st);
            memset(&out, 0, sizeof out);
            st.phase = 0;
            good = session_ad9_handler(binding, i, &info, &st, &out) == SCENE_ACTION_HANDLER_OK &&
                   out.phase == 1u && out.disposition == SCENE_ACTION_HANDLER_PENDING;
            for (int p = 0; good && p < 3; ++p) {
                st.phase = 1;
                session_ad9_pointer_move(binding, px[p][0], px[p][1]);
                good = session_ad9_handler(binding, i, &info, &st, &out) == SCENE_ACTION_HANDLER_OK &&
                       out.phase == 1u && out.disposition == SCENE_ACTION_HANDLER_PENDING &&
                       session_ad9_render_plan(binding, &plan) == D9_OK && plan.valid == 1u;
            }
            if (good) {
                ++ok;
                if (info.typed_body[0x22] != 0) ++alpha; else ++mask;
                ++radius[info.typed_body[0x21]];
            } else {
                ++error;
                printf("ROW_FAIL %s %zu %s\n", argv[a], i, session_ad9_failure(binding));
            }
        }
        session_ad9_destroy(binding);
        scene_resource_close(scene);
        free(bytes);
    }
    printf("SUMMARY scenes=%lu multi_row_scenes=%lu rows=%lu ok=%lu error=%lu alpha=%lu mask=%lu loads=%d releases=%d\n",
           scenes, multi, rows, ok, error, alpha, mask, ctx.loads, ctx.releases);
    for (int r = 0; r < 256; ++r)
        if (radius[r] != 0) printf("RADIUS %d %lu\n", r, radius[r]);
    return error == 0 ? 0 : 1;
}
