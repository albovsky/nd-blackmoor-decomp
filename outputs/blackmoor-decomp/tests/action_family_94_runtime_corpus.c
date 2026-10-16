/* RT-32 corpus check: runs every raw 0x94 row of the decoded scene resources given on the command line through the
 * production parser and the session binding (phase 0, 2, 3) against a 640x480 5-6-5 stand-in display. Output is derived
 * counts only (the resource bytes stay in work/): one "ROW_FAIL ..." line per failing row and a final "SUMMARY ..."
 * line. With --dump as the first argument it instead prints "<subtype> <typed body bytes in hex>" per row for the
 * original-x86 oracle (consumed in memory by tests/action_family_94_runtime_original_oracle.py, never stored). */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_resource.h"
#include "session_bindings_a94.h"

static unsigned long g_flag_calls, g_refresh_calls, g_files, g_bytes;
static int32_t g_flag;
static uint8_t g_last_head[2];

static void set_flag(void *c, int32_t v) { (void)c; ++g_flag_calls; g_flag = v; }
static void refresh(void *c) { (void)c; ++g_refresh_calls; }
static int display(void *c, SessionA94Display *d)
{
    (void)c;
    memset(d, 0, sizeof *d);
    d->screen.width = 640;
    d->screen.height = 480;
    d->screen.bytes_per_pixel = 2;
    d->screen.bits_per_pixel = 16;
    d->screen.shifts[0] = 0; d->screen.shifts[1] = 5; d->screen.shifts[2] = 11;
    d->screen.masks[0] = 0x1f; d->screen.masks[1] = 0x3f; d->screen.masks[2] = 0x1f;
    d->screen.channel_bits[0] = 5; d->screen.channel_bits[1] = 6; d->screen.channel_bits[2] = 5;
    strcpy(d->drive, "C");
    strcpy(d->dir, "SHOTS");
    return 0;
}
static int capture(void *c, uint8_t *dst, size_t n)
{
    size_t i;
    (void)c;
    for (i = 0; i < n; ++i) dst[i] = (uint8_t)(i * 7u);
    return 0;
}
static int write_file(void *c, const char *path, const uint8_t *bytes, size_t n)
{
    (void)c; (void)path;
    ++g_files;
    g_bytes += n;
    g_last_head[0] = bytes[0];
    g_last_head[1] = bytes[1];
    return 0;
}

int main(int argc, char **argv)
{
    SessionA94Host host;
    SessionA94Binding *binding;
    unsigned long scenes = 0, rows = 0, ok = 0, error = 0, tail_rows = 0, sub1 = 0, sub_other = 0, bmp = 0, tga = 0,
                  full = 0, crop = 0, unreachable = 0, invalid = 0;
    int a, dump = argc > 1 && strcmp(argv[1], "--dump") == 0;

    memset(&host, 0, sizeof host);
    host.set_capture_flag = set_flag;
    host.request_refresh = refresh;
    host.display = display;
    host.capture = capture;
    host.write_file = write_file;
    binding = session_a94_create(&host);
    if (binding == NULL) return 2;
    for (a = dump ? 2 : 1; a < argc; ++a) {
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
                SceneActionRuntimeState st = {0u, 0u};
                SceneActionHandlerResult out = {SCENE_ACTION_HANDLER_PENDING, 0u};
                A94Request req;
                A94Screen scr;
                SessionA94Display d;
                unsigned k;
                int good = 1;
                if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK || info.type != SESSION_A94_TYPE) continue;
                has = 1;
                ++rows;
                if (dump) {
                    printf("%u ", (unsigned)info.subtype);
                    for (k = 0; k < info.typed_body_length; ++k) printf("%02x", info.typed_body[k]);
                    printf("\n");
                    continue;
                }
                if (info.subtype == 1u) ++sub1; else ++sub_other;
                if (info.raw_body_length > info.typed_body_length) ++tail_rows;
                display(NULL, &d);
                scr = d.screen;
                a94_request_from_body(info.typed_body, &req);
                if (req.format == 0u) ++bmp; else ++tga;
                if (req.x0 == 0 && req.y0 == 0 && req.x1 == 640 && req.y1 == 480) ++full; else ++crop;
                if (!a94_capture_reachable(&scr, &req)) ++unreachable;
                if (!a94_request_valid(&scr, &req)) ++invalid;
                g_files = 0;
                /* phase 0 -> 2 -> 3 -> completion */
                if (session_a94_handler(binding, i, &info, &st, &out) != SCENE_ACTION_HANDLER_OK || out.phase != 2u ||
                    out.disposition != SCENE_ACTION_HANDLER_PENDING) good = 0;
                st.phase = out.phase;
                if (good && (session_a94_handler(binding, i, &info, &st, &out) != SCENE_ACTION_HANDLER_OK || out.phase != 3u ||
                             g_files != 1ul || g_flag != 0)) good = 0;
                st.phase = out.phase;
                if (good && (session_a94_handler(binding, i, &info, &st, &out) != SCENE_ACTION_HANDLER_OK || out.phase != 0u ||
                             out.disposition != SCENE_ACTION_HANDLER_COMPLETED)) good = 0;
                if (good) ++ok; else { ++error; printf("ROW_FAIL handler %s row %zu: %s\n", argv[a], i, session_a94_failure(binding)); }
            }
            scene_resource_close(scene);
        }
        free(bytes);
        scenes += has;
    }
    if (!dump) {
        printf("SUMMARY scenes=%lu rows=%lu ok=%lu error=%lu sub1=%lu sub_other=%lu tail_rows=%lu bmp=%lu tga=%lu full=%lu crop=%lu "
               "unreachable=%lu invalid=%lu files=%lu\n",
               scenes, rows, ok, error, sub1, sub_other, tail_rows, bmp, tga, full, crop, unreachable, invalid,
               session_a94_files_written(binding));
    }
    session_a94_destroy(binding);
    return error == 0ul ? 0 : 1;
}
