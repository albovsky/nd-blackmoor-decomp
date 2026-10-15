/* RT-21: lists every raw 0xa1 row of the decoded scene resources given on the
 * command line through the production parser (scene_resource.c). One line per row:
 * "<resource> <scene-title> <row> <rows> <subtype> <typed-length> <dependency-count> <hex typed body>".
 * Resource bytes stay in work/; only the derived listing is printed. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_resource.h"

int main(int argc, char **argv)
{
    int a;
    for (a = 1; a < argc; ++a) {
        FILE *f = fopen(argv[a], "rb");
        long n;
        unsigned char *buf;
        char error[128] = {0};
        SceneResource *scene;
        if (f == NULL) {
            continue;
        }
        fseek(f, 0, SEEK_END);
        n = ftell(f);
        fseek(f, 0, SEEK_SET);
        buf = (unsigned char *)malloc((size_t)n);
        if (buf == NULL || fread(buf, 1, (size_t)n, f) != (size_t)n) {
            fclose(f);
            free(buf);
            continue;
        }
        fclose(f);
        scene = scene_resource_open_memory(buf, (size_t)n, error, sizeof(error));
        if (scene != NULL) {
            SceneResourceSummary summary;
            size_t count = scene_resource_action_count(scene), i, k;
            memset(&summary, 0, sizeof(summary));
            (void)scene_resource_get_summary(scene, &summary);
            for (i = 0; i < count; ++i) {
                SceneActionInfo info;
                if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK || info.type != 0xa1) {
                    continue;
                }
                printf("%s [%s] %zu %zu %u %zu %zu ", argv[a], summary.title, i, count,
                       (unsigned)info.subtype, info.typed_body_length, info.dependency_count);
                for (k = 0; k < info.typed_body_length; ++k) {
                    printf("%02x", info.typed_body[k]);
                }
                printf("\n");
            }
            scene_resource_close(scene);
        }
        free(buf);
    }
    return 0;
}
