/* RT-39 corpus check: runs every raw 0x4b row of the decoded scene resources given on the command line through the production
 * parser and the session binding, with the AUTOTEXT lookup served from the decoded AUTOTEXT resource (first argument). Output
 * is derived counts only (the resource bytes stay in work/): one "ROW_FAIL ..." line per failing row and a final "SUMMARY ..."
 * line. With --dump as the first argument it instead prints "<subtype> <raw body bytes in hex>" per row for the original-x86
 * oracle (consumed in memory by tests/action_family_4b_runtime_original_oracle.py, never stored). */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "autotext.h"
#include "scene_resource.h"
#include "session_bindings_a4b.h"

static AutoText *g_text;
static unsigned long g_lookups, g_missing, g_writes, g_text_bytes;

static ActionFamily51LookupStatus lookup(void *c, const uint8_t *key, size_t key_length, const uint8_t **text, size_t *length)
{
    size_t raw = 0u;
    int status;
    (void)c;
    ++g_lookups;
    status = autotext_lookup(g_text, key, key_length, text, &raw, length);
    if (status == AUTOTEXT_OK) return ACTION_FAMILY_51_LOOKUP_FOUND;
    if (status == AUTOTEXT_ERR_NOT_FOUND) {
        ++g_missing;
        return ACTION_FAMILY_51_LOOKUP_NOT_FOUND;
    }
    return ACTION_FAMILY_51_LOOKUP_ERROR;
}

static SessionA4bWriteStatus write_caption(void *c, const uint8_t *text, size_t length)
{
    (void)c;
    (void)text;
    ++g_writes;
    g_text_bytes += (unsigned long)length;
    return SESSION_A4B_WRITE_OK;
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
    SessionA4bHost host;
    SessionA4bBinding *binding;
    unsigned long scenes = 0, rows = 0, ok = 0, bad = 0, keyed = 0, inline_rows = 0, tail_rows = 0, sub[4] = {0}, scene_fail = 0;
    int a, dump = argc > 1 && strcmp(argv[1], "--dump") == 0;
    unsigned char *text_bytes;
    long text_n = 0;
    char err[128] = {0};

    if (argc < 3 + (dump ? 1 : 0)) return 2;
    text_bytes = read_file(argv[dump ? 2 : 1], &text_n);
    if (text_bytes == NULL || autotext_open_memory(text_bytes, (size_t)text_n, 0, &g_text, err, sizeof err) != AUTOTEXT_OK) return 2;
    memset(&host, 0, sizeof host);
    host.lookup = lookup;
    host.write_caption = write_caption;
    binding = session_a4b_create(&host);
    if (binding == NULL) return 2;
    for (a = dump ? 3 : 2; a < argc; ++a) {
        long n = 0;
        unsigned char *bytes = read_file(argv[a], &n);
        SceneResource *scene;
        size_t count, i, failed_row = 0;
        int has = 0, kernel = 0;
        if (bytes == NULL) continue;
        scene = scene_resource_open_memory(bytes, (size_t)n, err, sizeof err);
        if (scene != NULL) {
            count = scene_resource_action_count(scene);
            if (!dump && session_a4b_begin_scene(binding, scene, &failed_row, &kernel) != SESSION_A4B_OK) {
                ++scene_fail;
                printf("SCENE_FAIL %s row %zu kernel=%d\n", argv[a], failed_row, kernel);
                scene_resource_close(scene);
                free(bytes);
                continue;
            }
            for (i = 0; i < count; ++i) {
                SceneActionInfo info;
                SceneActionRuntimeState before = {0u, 7u};
                SceneActionHandlerResult out = {SCENE_ACTION_HANDLER_PENDING, 99u};
                size_t k, length = 0u;
                int status;
                if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) continue;
                if (info.type != SESSION_A4B_TYPE) continue;
                has = 1;
                ++rows;
                if (dump) {
                    printf("%u ", (unsigned)info.subtype);
                    for (k = 0; k < info.raw_body_length; ++k) printf("%02x", info.raw_body[k]);
                    printf("\n");
                    continue;
                }
                if ((int16_t)(info.raw_body[0] | (info.raw_body[1] << 8)) == -1) ++keyed; else ++inline_rows;
                if (info.raw_body_length > info.typed_body_length) ++tail_rows;
                if (info.subtype < 4u) ++sub[info.subtype];
                (void)session_a4b_row_text(binding, i, &length);
                status = session_a4b_handler(binding, i, &info, &before, &out);
                if (status == SCENE_ACTION_HANDLER_OK && out.disposition == SCENE_ACTION_HANDLER_COMPLETED && out.phase == 0u &&
                    length >= 3u) {
                    ++ok;
                } else {
                    ++bad;
                    printf("ROW_FAIL handler %s row %zu status=%d\n", argv[a], i, status);
                }
            }
            scene_resource_close(scene);
        }
        free(bytes);
        scenes += has;
    }
    if (!dump) {
        printf("SUMMARY scenes=%lu rows=%lu ok=%lu bad=%lu scene_fail=%lu keyed=%lu inline=%lu tail_rows=%lu sub0=%lu sub1=%lu sub2=%lu "
               "sub_other=%lu lookups=%lu missing=%lu writes=%lu text_bytes=%lu\n",
               scenes, rows, ok, bad, scene_fail, keyed, inline_rows, tail_rows, sub[0], sub[1], sub[2], sub[3], g_lookups, g_missing,
               g_writes, g_text_bytes);
    }
    session_a4b_destroy(binding);
    autotext_close(g_text);
    free(text_bytes);
    return bad == 0ul && scene_fail == 0ul ? 0 : 1;
}
