/* RT-18: lists every raw 0x36/0x37/0x38 row of the decoded scene resources given on the
 * command line through the production parser (scene_resource.c). One line per row:
 * "<resource> <row> <rows-in-scene> <raw-type> <raw-body-length> <dependency-count> <body hex>
 * <dependency hex...>". Resource bytes stay in work/; only the derived listing is printed. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_resource.h"

static void hex(const uint8_t *bytes, size_t length)
{
    size_t k;
    for (k = 0; k < length; ++k) {
        printf("%02x", bytes[k]);
    }
}

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
            for (i = 0; i < count; ++i) {
                SceneActionInfo info;
                if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK ||
                    (info.type != 0x36 && info.type != 0x37 && info.type != 0x38)) {
                    continue;
                }
                printf("%s %zu %zu 0x%02x %zu %zu ", argv[a], i, count, info.type,
                       info.raw_body_length, info.dependency_count);
                hex(info.raw_body, info.raw_body_length > 0x45u && info.type == 0x37
                                       ? 0x45u
                                       : (info.raw_body_length < 0xacu ? info.raw_body_length
                                                                       : 0xacu));
                for (k = 0; k < info.dependency_count; ++k) {
                    printf(" ");
                    hex(info.dependency_records + 16u * k, 16u);
                }
                printf("\n");
            }
            scene_resource_close(scene);
        }
        free(buf);
    }
    return 0;
}
