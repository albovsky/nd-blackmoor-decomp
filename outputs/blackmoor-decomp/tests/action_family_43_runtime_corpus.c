/* RT-32 corpus check: runs every raw 0x43 row of the decoded scene resources given on the command line through the
 * production parser and the session bindings (the recovered writer is replaced by a recorder through the write_text
 * seam), with the AUTOTEXT lookup served from the decoded AUTOTEXT resource (first argument). Output is derived counts
 * only (the resource bytes stay in work/): one "ROW_FAIL ..." line per failing row and a final "SUMMARY ..." line. With
 * --dump as the first argument it prints "<subtype> <raw body hex> <resolved text hex>" per row for the original-x86
 * oracle (consumed in memory by tests/action_family_43_runtime_original_oracle.py, never stored). */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "autotext.h"
#include "scene_resource.h"
#include "session_bindings_a36.h"
#include "session_bindings_a43.h"

static AutoText *g_text;
static unsigned long g_writes;

static int lookup(void *c, const uint8_t *key, size_t key_length, const uint8_t **text, size_t *length)
{
    size_t raw = 0u;
    (void)c;
    return autotext_lookup(g_text, key, key_length, text, &raw, length) == AUTOTEXT_OK ? 0 : 1;
}

static int write_text(void *c, uint8_t *entry, const char *text, size_t capacity)
{
    (void)c; (void)entry;
    if (strlen(text) + 1u > capacity) return 1;
    ++g_writes;
    return 0;
}

static int load_world(void *c, Overlay36World *w) { (void)c; (void)w; return 0; }

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
    SessionA36Host a36_host;
    SessionA43Host host;
    SessionA36Binding *a36;
    SessionA43Binding *a43;
    unsigned long rows = 0, ok = 0, bad = 0, keyed = 0, inline_rows = 0, converted = 0, resets = 0;
    int a, dump = argc > 1 && strcmp(argv[1], "--dump") == 0;
    unsigned char *text_bytes;
    long text_n = 0;
    char err[128] = {0};

    if (argc < 3 + (dump ? 1 : 0)) return 2;
    text_bytes = read_file(argv[dump ? 2 : 1], &text_n);
    if (text_bytes == NULL || autotext_open_memory(text_bytes, (size_t)text_n, 0, &g_text, err, sizeof err) != AUTOTEXT_OK) return 2;
    memset(&a36_host, 0, sizeof a36_host);
    a36_host.load_world = load_world;
    a36 = session_a36_create(&a36_host);
    memset(&host, 0, sizeof host);
    host.lookup = lookup;
    host.write_text = write_text;
    a43 = a36 != NULL ? session_a43_create(&host, a36) : NULL;
    if (a43 == NULL) return 2;
    for (a = dump ? 3 : 2; a < argc; ++a) {
        long n = 0;
        unsigned char *bytes = read_file(argv[a], &n);
        SceneResource *scene;
        size_t count, i;
        if (bytes == NULL) continue;
        scene = scene_resource_open_memory(bytes, (size_t)n, err, sizeof err);
        if (scene != NULL) {
            count = scene_resource_action_count(scene);
            if (!dump && session_a36_begin_scene(a36, scene) != OVERLAY36_OK) {
                scene_resource_close(scene);
                free(bytes);
                continue;
            }
            for (i = 0; i < count; ++i) {
                SceneActionInfo info;
                SceneActionRuntimeState st;
                SceneActionHandlerResult out;
                ActionFamily43Decoded decoded;
                const uint8_t *text = NULL;
                size_t length = 0u, k;
                if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK || info.type != SESSION_A43_TYPE) continue;
                ++rows;
                if (action_family_43_decode(info.raw_body, info.raw_body_length, &decoded) != ACTION_FAMILY_43_OK) {
                    printf("ROW_FAIL decode row %zu\n", i);
                    ++bad;
                    continue;
                }
                if (decoded.option_109 != 0u) {
                    ++keyed;
                    if (lookup(NULL, (const uint8_t *)decoded.key, strlen(decoded.key), &text, &length) != 0) {
                        printf("ROW_FAIL key row %zu\n", i);
                        ++bad;
                        continue;
                    }
                } else {
                    ++inline_rows;
                    text = decoded.inline_text;
                    length = decoded.inline_visible_length;
                }
                if (dump) {
                    printf("%u ", (unsigned)info.subtype);
                    for (k = 0; k < info.raw_body_length; ++k) printf("%02x", info.raw_body[k]);
                    printf(" ");
                    for (k = 0; k < length; ++k) printf("%02x", text[k]);
                    printf("\n");
                    continue;
                }
                memset(&st, 0, sizeof st);
                out.disposition = SCENE_ACTION_HANDLER_PENDING;
                out.phase = 0u;
                out.become_overlay36 = 0u;
                if (session_a43_handler(a43, i, &info, &st, &out) != SCENE_ACTION_HANDLER_OK || !out.become_overlay36 ||
                    out.phase != 0u || session_a36_image(a36, i) == NULL) {
                    printf("ROW_FAIL handler row %zu: %s\n", i, session_a43_failure(a43));
                    ++bad;
                    continue;
                }
                ++converted;
                if (out.disposition == SCENE_ACTION_HANDLER_RESET_DEPENDENCIES) ++resets;
                ++ok;
            }
            scene_resource_close(scene);
        }
        free(bytes);
    }
    if (!dump) printf("SUMMARY rows=%lu ok=%lu bad=%lu keyed=%lu inline=%lu converted=%lu resets=%lu writes=%lu\n", rows, ok, bad, keyed, inline_rows, converted, resets, g_writes);
    session_a43_destroy(a43);
    session_a36_destroy(a36);
    autotext_close(g_text);
    free(text_bytes);
    return bad == 0 ? 0 : 1;
}
