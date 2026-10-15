/* RT-20: lists every raw 0x0c row (typed body, dependency count, scene title) of the decoded
 * scene resources in a directory through the production parser (scene_resource.c). Output:
 * one line per row "<resource> <row> <rows-in-scene> <typed-length> <dependency-count> <title> <hex>".
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
            size_t count = scene_resource_action_count(scene), i, k;
            SceneResourceSummary summary;
            memset(&summary, 0, sizeof(summary));
            (void)scene_resource_get_summary(scene, &summary);
            for (i = 0; i < count; ++i) {
                SceneActionInfo info;
                if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK || info.type != 0x0c) {
                    continue;
                }
                printf("%s %zu %zu %zu %zu %s ", argv[a], i, count, info.typed_body_length,
                       info.dependency_count, summary.title[0] != '\0' ? summary.title : "-");
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
