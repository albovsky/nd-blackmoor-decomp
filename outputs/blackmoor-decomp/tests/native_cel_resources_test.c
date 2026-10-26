#include "native_cel_resources.h"

#include <stdio.h>
#include <string.h>

#define CHECK(test) do { if (!(test)) { \
    fprintf(stderr, "CHECK failed at %d: %s (%s)\n", __LINE__, #test, error); \
    return 1; } } while (0)

static int check_generic_resources(const char *directory)
{
    char error[256] = "";
    cif_decode_context decoder;
    NativeCelRequest request = {"sheet", {"motion", ""}, 0, 1};
    Convo3fCelLayer a = {0}, b = {0};
    int16_t tree = -1;
    uint8_t kind = 0, transparency = 0;
    const uint8_t *header = NULL;
    size_t bytes = 0;
    GameResources *game = game_resources_open(directory, 1, error, sizeof(error));
    CHECK(game != NULL);
    cif_decode_context_init(&decoder);
    NativeCelResources *resources = native_cel_resources_create(game, directory,
        &decoder, error, sizeof(error));
    CHECK(resources != NULL);
    CHECK(native_cel_resources_preflight(resources, &request, error, sizeof(error)) == NATIVE_CEL_OK);
    CHECK(native_cel_resources_load_header(resources, "SHEET", &header, &bytes, error, sizeof(error)) == NATIVE_CEL_OK);
    CHECK(bytes == 322 && header[38] == 77);
    CHECK(native_cel_resources_tree_index(resources, "MOTION", &tree) == NATIVE_CEL_OK);
    CHECK(native_cel_resources_tree_info(resources, tree, &kind, &transparency) == NATIVE_CEL_OK);
    CHECK(kind == 2 && transparency == 1);
    CHECK(native_cel_resources_load_layer(resources, tree, "f0", &a, error, sizeof(error)) == NATIVE_CEL_OK);
    CHECK(a.key_2f == 6 && a.src[0] == 1 && a.src[2] == 2 && a.src[3] == 1);
    CHECK(a.dst[0] == -8 && a.dst[1] == -3 && a.dst[2] == -7 && a.dst[3] == -2);
    CHECK(native_cel_resources_load_layer(resources, tree, "f1", &b, error, sizeof(error)) == NATIVE_CEL_OK);
    const cif_image *first = native_cel_resources_image(resources, a.surface);
    const cif_image *second = native_cel_resources_image(resources, b.surface);
    CHECK(first && second && first->byte_count == 12 && second->byte_count == 12);
    CHECK(first->pixels[0] == 1 && first->pixels[10] == 6);
    CHECK(memcmp(first->pixels, second->pixels, 12) == 0); /* retained decoder ring */
    CHECK(native_cel_resources_free_layer(resources, a.surface) == NATIVE_CEL_OK);
    CHECK(native_cel_resources_free_layer(resources, b.surface) == NATIVE_CEL_OK);
    CHECK(native_cel_resources_release_header(resources) == NATIVE_CEL_OK);
    CHECK(native_cel_resources_reset(resources, error, sizeof(error)) == NATIVE_CEL_OK);
    native_cel_resources_destroy(resources);
    game_resources_close(game);
    return 0;
}

int main(int argc, char **argv)
{
    char error[256] = "";
    cif_decode_context decoder;
    NativeCelRequest request = {"JPJ00a", {"JPJBody", "JPJHead"}, 0, 171};
    NativeCelStats stats;
    const uint8_t *header = NULL, *again = NULL;
    size_t bytes = 0, again_bytes = 0;
    int16_t body = -1, head = -1, same = -1;
    uint8_t kind = 0, transparency = 0;
    Convo3fCelLayer a = {0}, b = {0}, c = {0};
    const cif_image *image;
    CHECK(argc == 3);
    GameResources *game = game_resources_open(argv[1], 1, error, sizeof(error));
    CHECK(game != NULL);
    cif_decode_context_init(&decoder);
    NativeCelResources *resources = native_cel_resources_create(game, argv[1],
        &decoder, error, sizeof(error));
    CHECK(resources != NULL);
    CHECK(native_cel_resources_preflight(resources, &request, error, sizeof(error)) == NATIVE_CEL_OK);
    CHECK(native_cel_resources_load_header(resources, "jpj00A", &header, &bytes,
        error, sizeof(error)) == NATIVE_CEL_OK);
    CHECK(bytes == 24122 && header != NULL);
    CHECK(native_cel_resources_load_header(resources, "JPJ00a", &again, &again_bytes,
        error, sizeof(error)) == NATIVE_CEL_OK);
    CHECK(header == again && bytes == again_bytes);
    CHECK(native_cel_resources_tree_index(resources, "jpjbody", &body) == NATIVE_CEL_OK);
    CHECK(native_cel_resources_tree_index(resources, "JPJHead", &head) == NATIVE_CEL_OK);
    CHECK(body != head && body >= 0 && head >= 0);
    CHECK(native_cel_resources_tree_index(resources, "JPJBODY", &same) == NATIVE_CEL_OK && same == body);
    CHECK(native_cel_resources_tree_info(resources, head, &kind, &transparency) == NATIVE_CEL_OK);
    CHECK(kind == 1 && transparency == 2);
    CHECK(native_cel_resources_load_layer(resources, body, "JJBAA00", &a, error, sizeof(error)) == NATIVE_CEL_OK);
    CHECK(a.loaded == 1 && a.surface >= NATIVE_CEL_SURFACE_FIRST && a.key_2f == 352);
    CHECK(a.src[0] == 0 && a.src[1] == 0 && a.src[2] == 175 && a.src[3] == 214);
    CHECK(a.dst[0] == 197 && a.dst[1] == 135 && a.dst[2] == 372 && a.dst[3] == 349);
    image = native_cel_resources_image(resources, a.surface);
    CHECK(image && image->width == 176 && image->height == 215 && image->pitch == 352);
    CHECK(image->pixels && image->byte_count == 75680);
    CHECK(native_cel_resources_load_layer(resources, head, "jjmaa00", &b, error, sizeof(error)) == NATIVE_CEL_OK);
    CHECK(b.loaded && b.surface != a.surface && b.key_2f == 224);
    CHECK(b.src[2] == 111 && b.src[3] == 105);
    CHECK(b.dst[0] == 250 && b.dst[1] == 29 && b.dst[2] == 361 && b.dst[3] == 134);
    CHECK(native_cel_resources_load_layer(resources, head, "JJOAA00", &c, error, sizeof(error)) == NATIVE_CEL_OK);
    CHECK(c.surface != b.surface);
    CHECK(memcmp(native_cel_resources_image(resources, b.surface)->pixels,
                 native_cel_resources_image(resources, c.surface)->pixels, 23744) != 0);
    CHECK(native_cel_resources_reset(resources, error, sizeof(error)) == NATIVE_CEL_ERR_BUSY);
    NativeCelRequest next = {"JPJ02", {"JPJBody", "JPJHead"}, 0, 36};
    CHECK(native_cel_resources_preflight(resources, &next, error, sizeof(error)) == NATIVE_CEL_ERR_BUSY);
    CHECK(native_cel_resources_release_header(resources) == NATIVE_CEL_OK);
    CHECK(native_cel_resources_reset(resources, error, sizeof(error)) == NATIVE_CEL_ERR_BUSY);
    CHECK(native_cel_resources_image(resources, a.surface) != NULL);
    CHECK(native_cel_resources_free_layer(resources, a.surface) == NATIVE_CEL_OK);
    CHECK(native_cel_resources_image(resources, a.surface) == NULL);
    CHECK(native_cel_resources_free_layer(resources, a.surface) == NATIVE_CEL_OK);
    CHECK(native_cel_resources_free_layer(resources, b.surface) == NATIVE_CEL_OK);
    CHECK(native_cel_resources_free_layer(resources, c.surface) == NATIVE_CEL_OK);
    CHECK(native_cel_resources_release_header(resources) == NATIVE_CEL_OK);
    native_cel_resources_stats(resources, &stats);
    CHECK(stats.headers == 0 && stats.layers == 0 && stats.layer_bytes == 0 && stats.header_bytes == 0);
    CHECK(native_cel_resources_reset(resources, error, sizeof(error)) == NATIVE_CEL_OK);
    native_cel_resources_stats(resources, &stats);
    CHECK(stats.trees == 0);
    CHECK(native_cel_resources_preflight(resources, &request, error, sizeof(error)) == NATIVE_CEL_OK);
    CHECK(native_cel_resources_tree_index(resources, "JPJHead", &head) == NATIVE_CEL_OK);
    memset(&b, 0, sizeof(b));
    CHECK(native_cel_resources_load_layer(resources, head, "JJMAA00", &b, error, sizeof(error)) == NATIVE_CEL_OK);
    CHECK(b.surface > c.surface && native_cel_resources_image(resources, c.surface) == NULL);
    CHECK(native_cel_resources_free_layer(resources, b.surface) == NATIVE_CEL_OK);
    CHECK(native_cel_resources_reset(resources, error, sizeof(error)) == NATIVE_CEL_OK);
    native_cel_resources_destroy(resources);
    game_resources_close(game);
    CHECK(check_generic_resources(argv[2]) == 0);
    puts("native cel resource checks passed");
    return 0;
}
