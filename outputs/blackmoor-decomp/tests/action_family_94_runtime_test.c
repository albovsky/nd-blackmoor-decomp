/* RT-32 unit tests of raw 0x94 "make a screen file": the pure module (src/action_family_94_runtime.c) and the session
 * binding (src/session_bindings_a94.c). Prints "PASS <name>" / "FAIL <name>: <message>"; the exit status is the failure
 * count. Fixtures are synthetic (no original bytes). tests/test_action_family_94_runtime.py builds and runs this plainly,
 * under ASan/UBSan and under source mutations. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "session_bindings_a94.h"

static int g_failed;
static char g_msg[320];
#define CHECK(cond)                                                       \
    do {                                                                  \
        if (!(cond) && !g_failed) {                                       \
            g_failed = 1;                                                 \
            snprintf(g_msg, sizeof g_msg, "line %d: %s", __LINE__, #cond); \
        }                                                                 \
    } while (0)

#define W 8
#define H 6

static A94Screen screen565(void)
{
    A94Screen s;
    memset(&s, 0, sizeof s);
    s.width = W;
    s.height = H;
    s.bytes_per_pixel = 2;
    s.bits_per_pixel = 16;
    s.shifts[0] = 0; s.shifts[1] = 5; s.shifts[2] = 11;
    s.masks[0] = 0x1f; s.masks[1] = 0x3f; s.masks[2] = 0x1f;
    s.channel_bits[0] = 5; s.channel_bits[1] = 6; s.channel_bits[2] = 5;
    return s;
}

static A94Screen screen555(void)
{
    A94Screen s = screen565();
    s.shifts[1] = 5; s.shifts[2] = 10;
    s.masks[1] = 0x1f;
    s.channel_bits[1] = 5;
    return s;
}

static void body_of(uint8_t body[50], const char *name, int32_t x0, int32_t y0, int32_t x1, int32_t y1, uint8_t format)
{
    memset(body, 0, 50);
    memcpy(body, name, strlen(name));
    memcpy(body + 0x21, &x0, 4);
    memcpy(body + 0x25, &y0, 4);
    memcpy(body + 0x29, &x1, 4);
    memcpy(body + 0x2d, &y1, 4);
    body[0x31] = format;
}

static void pixels(uint8_t *p)
{
    size_t i;
    for (i = 0; i < (size_t)W * H; ++i) {
        const uint16_t v = (uint16_t)(0x1234u + i * 0x0b3du);
        p[2 * i] = (uint8_t)v;
        p[2 * i + 1] = (uint8_t)(v >> 8);
    }
}

static void request_decoding_and_domain(void)
{
    uint8_t body[50];
    A94Request r;
    A94Screen s = screen565();
    body_of(body, "Award", 52, 18, 587, 309, 0);
    a94_request_from_body(body, &r);
    CHECK(strcmp(r.name, "Award") == 0 && r.x0 == 52 && r.y0 == 18 && r.x1 == 587 && r.y1 == 309 && r.format == 0);
    body_of(body, "A", -1, 0, 8, 6, 7);
    a94_request_from_body(body, &r);
    CHECK(r.x0 == -1 && r.format == 7);
    /* reachable: signed y1 <= height and x1 <= width */
    body_of(body, "A", 0, 0, W, H, 0);
    a94_request_from_body(body, &r);
    CHECK(a94_capture_reachable(&s, &r) && a94_request_valid(&s, &r));
    r.x1 = W + 1;
    CHECK(!a94_capture_reachable(&s, &r) && !a94_request_valid(&s, &r));
    r.x1 = W; r.y1 = H + 1;
    CHECK(!a94_capture_reachable(&s, &r));
    r.y1 = INT32_MIN; /* signed compare: a negative bound is "reachable" but outside the native domain */
    CHECK(a94_capture_reachable(&s, &r) && !a94_request_valid(&s, &r));
    r.y1 = H; r.x0 = -1;
    CHECK(a94_capture_reachable(&s, &r) && !a94_request_valid(&s, &r));
    r.x0 = W; r.y0 = 0;
    CHECK(!a94_request_valid(&s, &r)); /* empty width */
    r.x0 = 0; r.y0 = H;
    CHECK(!a94_request_valid(&s, &r)); /* empty height */
    r.y0 = 0; s.bytes_per_pixel = 4;
    CHECK(!a94_request_valid(&s, &r));
}

static void file_paths(void)
{
    char path[64];
    CHECK(a94_make_path(path, sizeof path, "C", "SHOTS", "Award", ".BMP") == A94_OK && strcmp(path, "C:SHOTS\\Award.BMP") == 0);
    CHECK(a94_make_path(path, sizeof path, "CD", "SHOTS\\", "Award", ".TGA") == A94_OK && strcmp(path, "C:SHOTS\\Award.TGA") == 0);
    CHECK(a94_make_path(path, sizeof path, "", "a/b/", "n", ".BMP") == A94_OK && strcmp(path, "a/b/n.BMP") == 0);
    CHECK(a94_make_path(path, sizeof path, NULL, NULL, "n", "TGA") == A94_OK && strcmp(path, "n.TGA") == 0);
    CHECK(a94_make_path(path, sizeof path, NULL, "", "n", "") == A94_OK && strcmp(path, "n") == 0);
    CHECK(a94_make_path(path, 6u, NULL, NULL, "name", ".BMP") == A94_ERR_CAPACITY);
    CHECK(a94_make_path(path, 9u, NULL, NULL, "name", ".BMP") == A94_OK && strcmp(path, "name.BMP") == 0);
    CHECK(a94_make_path(path, 8u, NULL, NULL, "name", ".BMP") == A94_ERR_CAPACITY);
    CHECK(a94_make_path(NULL, 8u, NULL, NULL, "name", ".BMP") == A94_ERR_ARGUMENT);
    {
        uint8_t body[50];
        A94Request r;
        body_of(body, "x", 0, 0, 1, 1, 0);
        a94_request_from_body(body, &r);
        CHECK(strcmp(a94_extension(&r), ".BMP") == 0);
        r.format = 1;
        CHECK(strcmp(a94_extension(&r), ".TGA") == 0);
        r.format = 255;
        CHECK(strcmp(a94_extension(&r), ".TGA") == 0);
    }
}

static void bmp_encoding(void)
{
    uint8_t body[50], px[W * H * 2], out[512];
    A94Request r;
    A94Screen s = screen555();
    size_t len = 0, want = 0, i;
    pixels(px);
    body_of(body, "t", 1, 2, 4, 5, 0); /* 3 x 3 pixels: 9 bytes per row padded to 12 */
    a94_request_from_body(body, &r);
    CHECK(a94_encode(&s, &r, NULL, NULL, 0, &want) == A94_OK && want == 54u + 12u * 3u);
    CHECK(a94_encode(&s, &r, px, out, sizeof out, &len) == A94_OK && len == want);
    CHECK(out[0] == 'B' && out[1] == 'M');
    CHECK(out[2] == (uint8_t)(12 * 3 + 0x36) && out[3] == 0 && out[10] == 0x36 && out[14] == 0x28);
    CHECK(out[18] == 3 && out[22] == 3 && out[26] == 1 && out[28] == 0x18 && out[34] == 36);
    /* rows are bottom-up: file row 2 holds screen row 2 (y0 = 2), file row 0 holds screen row 4 */
    for (i = 0; i < 3; ++i) {
        const size_t sx = 1 + i, sy_top = 2, sy_bottom = 4;
        const uint16_t top = (uint16_t)(px[2 * (sy_top * W + sx)] | (px[2 * (sy_top * W + sx) + 1] << 8));
        const uint16_t bot = (uint16_t)(px[2 * (sy_bottom * W + sx)] | (px[2 * (sy_bottom * W + sx) + 1] << 8));
        CHECK(out[54 + 24 + 3 * i] == (uint8_t)(top << 3) && out[54 + 24 + 3 * i + 1] == (uint8_t)((top >> 5) << 3) &&
              out[54 + 24 + 3 * i + 2] == (uint8_t)((top >> 10) << 3));
        CHECK(out[54 + 3 * i] == (uint8_t)(bot << 3) && out[54 + 3 * i + 2] == (uint8_t)((bot >> 10) << 3));
    }
    CHECK(out[54 + 9] == 0 && out[54 + 10] == 0 && out[54 + 11] == 0); /* row padding */
    /* capacity */
    CHECK(a94_encode(&s, &r, px, out, want - 1u, &len) == A94_ERR_CAPACITY);
    /* a 5-6-5 display is brought to 5-5-5 first: green loses its low bit */
    {
        A94Screen s565 = screen565();
        uint8_t one[W * H * 2];
        uint16_t v = 0xFFFFu;
        memset(one, 0, sizeof one);
        one[2 * (2 * W + 1)] = (uint8_t)v;
        one[2 * (2 * W + 1) + 1] = (uint8_t)(v >> 8);
        a94_request_from_body(body, &r);
        CHECK(a94_encode(&s565, &r, one, out, sizeof out, &len) == A94_OK);
        CHECK(out[54 + 24] == 0xf8 && out[54 + 25] == 0xf8 && out[54 + 26] == 0xf8);
        v = 0x07E0u; /* full green 6 bits: 0x3f >> 1 == 0x1f */
        one[2 * (2 * W + 1)] = (uint8_t)v;
        one[2 * (2 * W + 1) + 1] = (uint8_t)(v >> 8);
        CHECK(a94_encode(&s565, &r, one, out, sizeof out, &len) == A94_OK);
        CHECK(out[54 + 24] == 0 && out[54 + 25] == 0xf8 && out[54 + 26] == 0);
    }
}

static void tga_encoding(void)
{
    uint8_t body[50], px[W * H * 2], out[512];
    A94Request r;
    A94Screen s = screen555();
    size_t len = 0, want = 0, x, y;
    pixels(px);
    body_of(body, "t", 2, 1, 7, 4, 1); /* 5 x 3 */
    a94_request_from_body(body, &r);
    CHECK(a94_encode(&s, &r, NULL, NULL, 0, &want) == A94_OK && want == 18u + 5u * 3u * 2u);
    CHECK(a94_encode(&s, &r, px, out, sizeof out, &len) == A94_OK && len == want);
    CHECK(out[0] == 0 && out[1] == 0 && out[2] == 2 && out[16] == 16 && out[17] == 0x20);
    CHECK(out[12] == 5 && out[13] == 0 && out[14] == 3 && out[15] == 0);
    for (y = 0; y < 3; ++y) {
        for (x = 0; x < 5; ++x) {
            const size_t src = 2 * ((y + 1) * W + (x + 2));
            /* the 5-5-5 conversion keeps fifteen bits of the word */
            CHECK(out[18 + 2 * (y * 5 + x)] == px[src] && out[18 + 2 * (y * 5 + x) + 1] == (px[src + 1] & 0x7f));
        }
    }
    s.bits_per_pixel = 15;
    CHECK(a94_encode(&s, &r, px, out, sizeof out, &len) == A94_OK && out[16] == 15);
    /* x1 and y1 are exclusive bounds: the full screen is a valid rectangle */
    body_of(body, "t", 0, 0, W, H, 1);
    a94_request_from_body(body, &r);
    CHECK(a94_encode(&s, &r, px, out, sizeof out, &len) == A94_OK && len == 18u + W * H * 2u);
    /* a 5-6-5 display: red and blue pass, green loses its low bit */
    {
        A94Screen s565 = screen565();
        uint8_t one[W * H * 2];
        memset(one, 0, sizeof one);
        one[0] = 0xE0; one[1] = 0x07; /* green 0x3f */
        CHECK(a94_encode(&s565, &r, one, out, sizeof out, &len) == A94_OK && out[18] == 0xE0 && out[19] == 0x03);
        one[0] = 0x1F; one[1] = 0xF8; /* red 0x1f, blue 0x1f */
        CHECK(a94_encode(&s565, &r, one, out, sizeof out, &len) == A94_OK && out[18] == 0x1F && out[19] == 0x7C);
    }
}

static void encode_refusals(void)
{
    uint8_t body[50], px[W * H * 2], out[512];
    A94Request r;
    A94Screen s = screen555();
    size_t len = 99;
    pixels(px);
    body_of(body, "t", 0, 0, W + 1, H, 0);
    a94_request_from_body(body, &r);
    CHECK(a94_encode(&s, &r, px, out, sizeof out, &len) == A94_ERR_DOMAIN && len == 99u);
    body_of(body, "t", 3, 3, 3, 4, 1);
    a94_request_from_body(body, &r);
    CHECK(a94_encode(&s, &r, px, out, sizeof out, &len) == A94_ERR_DOMAIN);
    CHECK(a94_encode(NULL, &r, px, out, sizeof out, &len) == A94_ERR_ARGUMENT);
    CHECK(a94_encode(&s, NULL, px, out, sizeof out, &len) == A94_ERR_ARGUMENT);
    CHECK(a94_encode(&s, &r, px, out, sizeof out, NULL) == A94_ERR_ARGUMENT);
    CHECK(a94_encode(&s, &r, NULL, out, sizeof out, &len) == A94_ERR_ARGUMENT);
}

typedef struct {
    int32_t flag;
    unsigned flag_calls, refresh_calls, display_calls, capture_calls, write_calls;
    int fail_write, fail_capture, fail_display;
    A94Screen screen;
    char drive[8], dir[40];
    char path[A94_PATH_BYTES];
    uint8_t file[512];
    size_t file_length;
    int order[16];
    unsigned order_n;
} Host;

static void note(Host *h, int what) { if (h->order_n < 16u) h->order[h->order_n++] = what; }
static void h_flag(void *c, int32_t v) { Host *h = (Host *)c; h->flag = v; ++h->flag_calls; note(h, 100 + (int)v); }
static void h_refresh(void *c) { Host *h = (Host *)c; ++h->refresh_calls; note(h, 200); }
static int h_display(void *c, SessionA94Display *d)
{
    Host *h = (Host *)c;
    ++h->display_calls;
    if (h->fail_display) return 1;
    d->screen = h->screen;
    strcpy(d->drive, h->drive);
    strcpy(d->dir, h->dir);
    return 0;
}
static int h_capture(void *c, uint8_t *dst, size_t n)
{
    Host *h = (Host *)c;
    ++h->capture_calls;
    note(h, 300);
    if (h->fail_capture) return 1;
    CHECK(n == (size_t)W * H * 2u);
    pixels(dst);
    return 0;
}
static int h_write(void *c, const char *path, const uint8_t *bytes, size_t n)
{
    Host *h = (Host *)c;
    ++h->write_calls;
    note(h, 400);
    if (h->fail_write) return 1;
    snprintf(h->path, sizeof h->path, "%s", path);
    h->file_length = n < sizeof h->file ? n : sizeof h->file;
    memcpy(h->file, bytes, h->file_length);
    return 0;
}

static SessionA94Binding *make(Host *h)
{
    SessionA94Host host;
    memset(&host, 0, sizeof host);
    host.context = h;
    host.set_capture_flag = h_flag;
    host.request_refresh = h_refresh;
    host.display = h_display;
    host.capture = h_capture;
    host.write_file = h_write;
    memset(h, 0, sizeof *h);
    h->screen = screen555();
    strcpy(h->drive, "D");
    strcpy(h->dir, "OUT");
    return session_a94_create(&host);
}

static SceneActionInfo row(const uint8_t *body, size_t length)
{
    SceneActionInfo info;
    memset(&info, 0, sizeof info);
    info.type = 0x94;
    info.subtype = 1;
    info.typed_body = body;
    info.typed_body_length = length;
    return info;
}

static int visit(SessionA94Binding *b, const SceneActionInfo *info, uint32_t phase, SceneActionHandlerResult *out)
{
    SceneActionRuntimeState before = {0u, phase};
    out->disposition = SCENE_ACTION_HANDLER_PENDING;
    out->phase = 0xdeadu;
    return session_a94_handler(b, 0u, info, &before, out);
}

static void phase_machine(void)
{
    uint8_t body[50];
    Host h;
    SessionA94Binding *b = make(&h);
    SceneActionInfo info;
    SceneActionHandlerResult out;
    body_of(body, "Shot", 1, 1, 5, 4, 0);
    info = row(body, 50u);
    /* phase 0: flag 1, refresh, phase 2; nothing else */
    CHECK(visit(b, &info, 0u, &out) == SCENE_ACTION_HANDLER_OK);
    CHECK(out.disposition == SCENE_ACTION_HANDLER_PENDING && out.phase == 2u);
    CHECK(h.flag == 1 && h.flag_calls == 1u && h.refresh_calls == 1u && h.order[0] == 101 && h.order[1] == 200);
    CHECK(h.display_calls == 0u && h.capture_calls == 0u && h.write_calls == 0u);
    /* phase 2: capture, one file, flag cleared AFTER the write, phase 3 */
    CHECK(visit(b, &info, 2u, &out) == SCENE_ACTION_HANDLER_OK);
    CHECK(out.disposition == SCENE_ACTION_HANDLER_PENDING && out.phase == 3u);
    CHECK(h.flag == 0 && h.capture_calls == 1u && h.write_calls == 1u && h.refresh_calls == 1u);
    CHECK(h.order[2] == 300 && h.order[3] == 400 && h.order[4] == 100);
    CHECK(strcmp(h.path, "D:OUT\\Shot.BMP") == 0 && strcmp(session_a94_last_path(b), h.path) == 0);
    CHECK(h.file[0] == 'B' && h.file[1] == 'M' && h.file_length == 54u + 12u * 3u);
    CHECK(session_a94_files_written(b) == 1ul && session_a94_files_refused(b) == 0ul);
    /* phase 3: the generic completion with phase 0 */
    CHECK(visit(b, &info, 3u, &out) == SCENE_ACTION_HANDLER_OK);
    CHECK(out.disposition == SCENE_ACTION_HANDLER_COMPLETED && out.phase == 0u);
    CHECK(h.flag_calls == 2u && h.write_calls == 1u);
    /* every other phase value changes nothing */
    {
        const uint32_t others[] = {1u, 4u, 5u, 99u, 0xffffffffu};
        unsigned i;
        for (i = 0; i < sizeof others / sizeof others[0]; ++i) {
            CHECK(visit(b, &info, others[i], &out) == SCENE_ACTION_HANDLER_OK);
            CHECK(out.disposition == SCENE_ACTION_HANDLER_PENDING && out.phase == others[i]);
        }
        CHECK(h.flag_calls == 2u && h.refresh_calls == 1u && h.write_calls == 1u);
    }
    /* TGA format */
    body_of(body, "Pic", 0, 0, W, H, 1);
    h.dir[0] = '\0';
    h.drive[0] = '\0';
    CHECK(visit(b, &info, 2u, &out) == SCENE_ACTION_HANDLER_OK && out.phase == 3u);
    CHECK(strcmp(h.path, "Pic.TGA") == 0 && h.file[2] == 2 && h.file_length == 18u + W * H * 2u);
    session_a94_destroy(b);
}

static void rectangle_beyond_the_screen_waits(void)
{
    uint8_t body[50];
    Host h;
    SessionA94Binding *b = make(&h);
    SceneActionInfo info;
    SceneActionHandlerResult out;
    unsigned i;
    body_of(body, "Shot", 0, 0, W + 1, H, 0);
    info = row(body, 50u);
    for (i = 0; i < 3; ++i) {
        CHECK(visit(b, &info, 2u, &out) == SCENE_ACTION_HANDLER_OK);
        CHECK(out.disposition == SCENE_ACTION_HANDLER_PENDING && out.phase == 2u);
    }
    CHECK(h.capture_calls == 0u && h.write_calls == 0u && h.flag_calls == 0u && h.display_calls == 3u);
    body_of(body, "Shot", 0, 0, W, H + 1, 0);
    CHECK(visit(b, &info, 2u, &out) == SCENE_ACTION_HANDLER_OK && out.phase == 2u && h.capture_calls == 0u);
    session_a94_destroy(b);
}

static void file_refused_is_silent(void)
{
    uint8_t body[50];
    Host h;
    SessionA94Binding *b = make(&h);
    SceneActionInfo info;
    SceneActionHandlerResult out;
    body_of(body, "Shot", 0, 0, 2, 2, 1);
    info = row(body, 50u);
    h.fail_write = 1;
    CHECK(visit(b, &info, 2u, &out) == SCENE_ACTION_HANDLER_OK && out.phase == 3u && h.flag == 0 && h.flag_calls == 1u);
    CHECK(session_a94_files_written(b) == 0ul && session_a94_files_refused(b) == 1ul && session_a94_last_path(b)[0] == '\0');
    session_a94_destroy(b);
}

static void refusals_before_any_effect(void)
{
    uint8_t body[50], twenty[20];
    Host h;
    SessionA94Binding *b = make(&h), *bare;
    SessionA94Host missing;
    SceneActionInfo info;
    SceneActionHandlerResult out;
    memset(&missing, 0, sizeof missing);
    memset(twenty, 0, sizeof twenty);
    CHECK(session_a94_create(NULL) == NULL);
    bare = session_a94_create(&missing);
    CHECK(b != NULL && bare != NULL);
    body_of(body, "Shot", 0, 0, 4, 4, 0);
    info = row(body, 50u);
    CHECK(visit(bare, &info, 0u, &out) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    CHECK(strcmp(session_a94_failure(bare), "none") != 0);
    /* wrong type, wrong body length, null arguments */
    info.type = 0x67;
    CHECK(visit(b, &info, 0u, &out) == SCENE_ACTION_HANDLER_ERROR);
    info = row(twenty, 20u);
    CHECK(visit(b, &info, 0u, &out) == SCENE_ACTION_HANDLER_ERROR);
    info = row(body, 49u);
    CHECK(visit(b, &info, 0u, &out) == SCENE_ACTION_HANDLER_ERROR);
    info = row(body, 50u);
    CHECK(session_a94_handler(NULL, 0u, &info, &(SceneActionRuntimeState){0u, 0u}, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_a94_handler(b, 0u, NULL, &(SceneActionRuntimeState){0u, 0u}, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_a94_handler(b, 0u, &info, NULL, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_a94_handler(b, 0u, &info, &(SceneActionRuntimeState){0u, 0u}, NULL) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(h.flag_calls == 0u && h.refresh_calls == 0u && h.display_calls == 0u);
    /* a rectangle the original cannot capture sanely: refused after the display query, before capture, flag or file */
    body_of(body, "Shot", 4, 0, 2, 4, 0);
    CHECK(visit(b, &info, 2u, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(h.capture_calls == 0u && h.write_calls == 0u && h.flag_calls == 0u);
    body_of(body, "Shot", -3, 0, 2, 4, 0);
    CHECK(visit(b, &info, 2u, &out) == SCENE_ACTION_HANDLER_ERROR && h.capture_calls == 0u);
    /* display or capture failures end the visit with an error and no file */
    body_of(body, "Shot", 0, 0, 2, 2, 0);
    h.fail_display = 1;
    CHECK(visit(b, &info, 2u, &out) == SCENE_ACTION_HANDLER_ERROR && h.write_calls == 0u);
    h.fail_display = 0;
    h.fail_capture = 1;
    CHECK(visit(b, &info, 2u, &out) == SCENE_ACTION_HANDLER_ERROR && h.write_calls == 0u && h.flag_calls == 0u);
    /* a 32-bit display is outside the model (the original hard-codes 16-bit pixels in 0x4c334f) */
    h.fail_capture = 0;
    h.screen.bytes_per_pixel = 4;
    {
        const unsigned captures = h.capture_calls;
        CHECK(visit(b, &info, 2u, &out) == SCENE_ACTION_HANDLER_ERROR && h.capture_calls == captures);
    }
    session_a94_destroy(b);
    session_a94_destroy(bare);
}

static void run(const char *name, void (*fn)(void), int *failures)
{
    g_failed = 0;
    g_msg[0] = '\0';
    fn();
    if (g_failed) {
        printf("FAIL %s: %s\n", name, g_msg);
        ++*failures;
    } else {
        printf("PASS %s\n", name);
    }
}

int main(void)
{
    int failures = 0;
    run("request_decoding_and_domain", request_decoding_and_domain, &failures);
    run("file_paths", file_paths, &failures);
    run("bmp_encoding", bmp_encoding, &failures);
    run("tga_encoding", tga_encoding, &failures);
    run("encode_refusals", encode_refusals, &failures);
    run("phase_machine", phase_machine, &failures);
    run("rectangle_beyond_the_screen_waits", rectangle_beyond_the_screen_waits, &failures);
    run("file_refused_is_silent", file_refused_is_silent, &failures);
    run("refusals_before_any_effect", refusals_before_any_effect, &failures);
    return failures;
}
