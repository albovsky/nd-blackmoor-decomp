/* RT-26 corpus check: runs every raw 0x95 row of the decoded scene resources given on the command line
 * through the production parser, the decoder, the session binding and the volume host with a recording
 * stand-in. Output is derived counts only (the resource bytes stay in work/): one "ROW ..." line per row
 * and a final "SUMMARY ..." line. */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_resource.h"
#include "session_bindings_a95.h"

typedef struct {
    unsigned long calls;
    unsigned long per_channel[32];
    unsigned long per_volume[256];
    uint16_t last_channel;
    float last_first, last_second;
} Ctx;

static int set_scalars(void *c, uint16_t channel, float first, float second)
{
    Ctx *ctx = c;
    ++ctx->calls;
    if (channel < 32u) ++ctx->per_channel[channel];
    ctx->last_channel = channel;
    ctx->last_first = first;
    ctx->last_second = second;
    return 0;
}

int main(int argc, char **argv)
{
    static Ctx ctx;
    ActionFamily95Host host;
    SessionA95Binding *binding;
    unsigned long scenes = 0, rows = 0, ok = 0, error = 0, equal = 0, over_channel = 0, subtype[256] = {0}, tail_rows = 0,
                  completed_dispositions = 0;
    unsigned volumes_seen = 0, channels_seen = 0, max_channel = 0;
    int a;
    memset(&host, 0, sizeof host);
    host.context = &ctx;
    host.set_channel_scalars = set_scalars;
    binding = session_a95_create(&host);
    if (binding == NULL) return 2;
    for (a = 1; a < argc; ++a) {
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
                ActionFamily95Decoded d;
                int status;
                if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK || info.type != SESSION_A95_TYPE) continue;
                has = 1;
                ++rows;
                ++subtype[info.subtype];
                if (info.raw_body_length > info.typed_body_length) ++tail_rows;
                status = action_family_95_decode(info.typed_body, info.typed_body_length, &d);
                if (status != ACTION_FAMILY_95_OK || info.typed_body_length != 3u) {
                    ++error;
                    printf("ROW_FAIL decode %s row %zu\n", argv[a], i);
                    continue;
                }
                if (d.channel > (int)max_channel) max_channel = (unsigned)d.channel;
                if (d.channel < 0 || d.channel >= 32) ++over_channel;
                if (session_a95_handler(binding, i, &info, &before, &out) == SCENE_ACTION_HANDLER_OK && out.phase == 0u &&
                    out.disposition == SCENE_ACTION_HANDLER_COMPLETED) {
                    ++ok;
                    ++completed_dispositions;
                    ++ctx.per_volume[d.volume_percent];
                    if (ctx.last_first == ctx.last_second && ctx.last_first == d.scalar && ctx.last_channel == (uint16_t)d.channel)
                        ++equal;
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
    {
        unsigned k;
        for (k = 0; k < 256u; ++k) volumes_seen += ctx.per_volume[k] != 0ul;
        for (k = 0; k < 32u; ++k) channels_seen += ctx.per_channel[k] != 0ul;
    }
    printf("SUMMARY scenes=%lu rows=%lu ok=%lu error=%lu equal=%lu out_of_range=%lu volumes=%u channels=%u max_channel=%u "
           "subtype1=%lu subtype2=%lu tail_rows=%lu completed=%lu\n",
           scenes, rows, ok, error, equal, over_channel, volumes_seen, channels_seen, max_channel, subtype[1], subtype[2], tail_rows,
           completed_dispositions);
    session_a95_destroy(binding);
    return error == 0ul ? 0 : 1;
}
