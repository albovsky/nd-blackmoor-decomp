/* RT-39 unit tests of raw 0x4b (caption text row): the session binding. Prints "PASS <name>" / "FAIL <name>: <message>"; the
 * exit status is the failure count. The scene file (argv[1]) is written by tests/test_action_family_4b_runtime.py from
 * synthetic rows: 0 inline "Hi there" (subtype 1), 1 key KEYHIT (subtype 1), 2 key NOSUCH (subtype 2), 3 inline empty
 * (subtype 1), 4 a 0x45 row the binding must ignore. Fixtures are synthetic (no original bytes). The python test builds and
 * runs this plainly, under ASan/UBSan and under source mutations. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "session_bindings_a4b.h"

static int g_failed;
static char g_msg[160];
static const char *g_scene_path;
#define CHECK(cond)                                                       \
    do {                                                                  \
        if (!(cond) && !g_failed) {                                       \
            g_failed = 1;                                                 \
            snprintf(g_msg, sizeof g_msg, "line %d: %s", __LINE__, #cond); \
        }                                                                 \
    } while (0)

#define MISSING_PREFIX "Game Error (please contact Tech Support) missing auto text: "

typedef struct {
    int lookup_mode;           /* 0 table, 1 error, 2 found with a NUL in the value, 3 found 40000 bytes, 4 found 40001, 5 found 32761 */
    SessionA4bWriteStatus write_status;
    unsigned lookups, writes;
    uint8_t last_text[64];
    size_t last_length;
    char last_key[40];
    uint8_t *big;
} Host;

static ActionFamily51LookupStatus lookup(void *context, const uint8_t *key, size_t key_length, const uint8_t **text, size_t *length)
{
    Host *h = (Host *)context;
    ++h->lookups;
    memset(h->last_key, 0, sizeof h->last_key);
    memcpy(h->last_key, key, key_length < 39u ? key_length : 39u);
    if (h->lookup_mode == 1) return ACTION_FAMILY_51_LOOKUP_ERROR;
    if (h->lookup_mode == 2) {
        *text = (const uint8_t *)"AB\0CD";
        *length = 5u;
        return ACTION_FAMILY_51_LOOKUP_FOUND;
    }
    if (h->lookup_mode >= 3) {
        size_t n = h->lookup_mode == 3 ? 40000u : h->lookup_mode == 4 ? 40001u : 32761u;
        h->big = (uint8_t *)realloc(h->big, n);
        memset(h->big, 'x', n);
        *text = h->big;
        *length = n;
        return ACTION_FAMILY_51_LOOKUP_FOUND;
    }
    if (key_length == 6u && memcmp(key, "KEYHIT", 6u) == 0) {
        *text = (const uint8_t *)"Found text";
        *length = 10u;
        return ACTION_FAMILY_51_LOOKUP_FOUND;
    }
    return ACTION_FAMILY_51_LOOKUP_NOT_FOUND;
}

static SessionA4bWriteStatus write_caption(void *context, const uint8_t *text, size_t length)
{
    Host *h = (Host *)context;
    ++h->writes;
    h->last_length = length;
    memset(h->last_text, 0, sizeof h->last_text);
    memcpy(h->last_text, text, length < sizeof h->last_text ? length : sizeof h->last_text);
    return h->write_status;
}

static SessionA4bBinding *make(Host *host, int with_lookup)
{
    SessionA4bHost h;
    memset(&h, 0, sizeof h);
    h.context = host;
    h.lookup = with_lookup ? lookup : NULL;
    h.lookup_context = host;
    h.write_caption = write_caption;
    return session_a4b_create(&h);
}

static unsigned char *g_bytes;
static long g_bytes_length;

static SceneResource *open_scene(void)
{
    char err[128] = {0};
    if (g_bytes == NULL) {
        FILE *f = fopen(g_scene_path, "rb");
        if (f == NULL) return NULL;
        fseek(f, 0, SEEK_END);
        g_bytes_length = ftell(f);
        fseek(f, 0, SEEK_SET);
        g_bytes = (unsigned char *)malloc((size_t)g_bytes_length);
        if (g_bytes == NULL || fread(g_bytes, 1, (size_t)g_bytes_length, f) != (size_t)g_bytes_length) return NULL;
        fclose(f);
    }
    return scene_resource_open_memory(g_bytes, (size_t)g_bytes_length, err, sizeof err);
}

static int visit(SessionA4bBinding *b, SceneResource *scene, size_t index, int *disposition, uint32_t *phase)
{
    SceneActionInfo info;
    SceneActionRuntimeState before = {0u, 9u};
    SceneActionHandlerResult out = {SCENE_ACTION_HANDLER_PENDING, 77u};
    int status;
    if (scene_resource_action_at(scene, index, &info) != SCENE_RESOURCE_OK) return -1;
    status = session_a4b_handler(b, index, &info, &before, &out);
    if (disposition != NULL) *disposition = (int)out.disposition;
    if (phase != NULL) *phase = out.phase;
    return status;
}

static void objects(void)
{
    Host h;
    SessionA4bBinding *b;
    SceneResource *scene = open_scene();
    size_t length = 0u, bad = 99u;
    int kernel = 99;
    const uint8_t *text;
    memset(&h, 0, sizeof h);
    b = make(&h, 1);
    CHECK(b != NULL && scene != NULL);
    CHECK(session_a4b_begin_scene(b, scene, &bad, &kernel) == SESSION_A4B_OK && bad == SIZE_MAX && kernel == 0);
    CHECK(session_a4b_row_state(b, 0u) == SESSION_A4B_ROW_READY && session_a4b_row_state(b, 4u) == SESSION_A4B_ROW_NOT_A4B);
    text = session_a4b_row_text(b, 0u, &length);
    CHECK(text != NULL && length == 8u + 3u && memcmp(text, "Hi there<e>", 11u) == 0);
    text = session_a4b_row_text(b, 1u, &length);
    CHECK(text != NULL && length == 10u + 3u && memcmp(text, "Found text<e>\0", 14u) == 0);
    text = session_a4b_row_text(b, 2u, &length);
    CHECK(text != NULL && length == sizeof(MISSING_PREFIX) - 1u + 6u + 3u + 3u);
    CHECK(text != NULL && memcmp(text, MISSING_PREFIX "NOSUCH<n><e>\0", length + 1u) == 0);
    text = session_a4b_row_text(b, 3u, &length);
    CHECK(text != NULL && length == 3u && memcmp(text, "<e>", 3u) == 0);
    CHECK(session_a4b_row_text(b, 4u, &length) == NULL && length == 0u);
    CHECK(h.lookups == 2u && strcmp(h.last_key, "NOSUCH") == 0);
    session_a4b_destroy(b);
    scene_resource_close(scene);
}

static void handler_effects(void)
{
    Host h;
    SessionA4bBinding *b;
    SceneResource *scene = open_scene();
    int disposition = -1;
    uint32_t phase = 1234u;
    memset(&h, 0, sizeof h);
    b = make(&h, 1);
    CHECK(session_a4b_begin_scene(b, scene, NULL, NULL) == SESSION_A4B_OK);
    CHECK(visit(b, scene, 0u, &disposition, &phase) == SCENE_ACTION_HANDLER_OK);
    CHECK(disposition == SCENE_ACTION_HANDLER_COMPLETED && phase == 0u);
    CHECK(h.writes == 1u && h.last_length == 11u && memcmp(h.last_text, "Hi there<e>", 11u) == 0);
    CHECK(visit(b, scene, 3u, &disposition, &phase) == SCENE_ACTION_HANDLER_OK && h.writes == 2u && h.last_length == 3u);
    CHECK(session_a4b_writes(b) == 2ul);
    /* the writer is the whole effect: a revisit writes again (the executor, not the binding, skips completed rows) */
    CHECK(visit(b, scene, 0u, &disposition, &phase) == SCENE_ACTION_HANDLER_OK && h.writes == 3u);
    /* a host that cannot present captions leaves the row alone; a failing writer is an error */
    h.write_status = SESSION_A4B_WRITE_UNSUPPORTED;
    CHECK(visit(b, scene, 0u, &disposition, &phase) == SCENE_ACTION_HANDLER_UNSUPPORTED && session_a4b_writes(b) == 3ul);
    h.write_status = SESSION_A4B_WRITE_ERROR;
    CHECK(visit(b, scene, 0u, &disposition, &phase) == SCENE_ACTION_HANDLER_ERROR && session_a4b_writes(b) == 3ul);
    /* a row of another type, an index past the scene, or a handler before any scene is an error */
    CHECK(visit(b, scene, 4u, &disposition, &phase) == SCENE_ACTION_HANDLER_ERROR);
    {
        SceneActionInfo info;
        SceneActionRuntimeState before = {0u, 0u};
        SceneActionHandlerResult out = {SCENE_ACTION_HANDLER_PENDING, 0u};
        const unsigned attempts = h.writes;
        CHECK(scene_resource_action_at(scene, 0u, &info) == SCENE_RESOURCE_OK);
        h.write_status = SESSION_A4B_WRITE_OK;
        info.type = 0x45u;   /* a row index the binding owns, but a row of another type */
        CHECK(session_a4b_handler(b, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR && h.writes == attempts);
        CHECK(session_a4b_handler(b, 99u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    }
    session_a4b_destroy(b);
    b = make(&h, 1);
    h.write_status = SESSION_A4B_WRITE_OK;
    CHECK(visit(b, scene, 0u, &disposition, &phase) == SCENE_ACTION_HANDLER_ERROR);
    session_a4b_destroy(b);
    scene_resource_close(scene);
}

static void lookup_cases(void)
{
    Host h;
    SessionA4bBinding *b;
    SceneResource *scene = open_scene();
    size_t length = 0u, bad = 99u;
    int kernel = 0, disposition = -1;
    uint32_t phase = 0u;
    const uint8_t *text;

    /* no AUTOTEXT provider: key rows are a named blocker if visited, inline rows run */
    memset(&h, 0, sizeof h);
    b = make(&h, 0);
    CHECK(session_a4b_begin_scene(b, scene, &bad, &kernel) == SESSION_A4B_OK);
    CHECK(session_a4b_row_state(b, 1u) == SESSION_A4B_ROW_UNSUPPORTED && session_a4b_row_state(b, 2u) == SESSION_A4B_ROW_UNSUPPORTED);
    CHECK(visit(b, scene, 1u, &disposition, &phase) == SCENE_ACTION_HANDLER_UNSUPPORTED && h.writes == 0u);
    CHECK(visit(b, scene, 0u, &disposition, &phase) == SCENE_ACTION_HANDLER_OK && h.writes == 1u);
    session_a4b_destroy(b);

    /* a failing lookup is fatal at scene load, naming the row; the binding keeps no objects */
    memset(&h, 0, sizeof h);
    h.lookup_mode = 1;
    b = make(&h, 1);
    CHECK(session_a4b_begin_scene(b, scene, &bad, &kernel) == SESSION_A4B_ERR_SCENE && bad == 1u && kernel != 0);
    CHECK(session_a4b_row_state(b, 0u) == SESSION_A4B_ROW_NOT_A4B);
    session_a4b_destroy(b);

    /* the table value is a C string: it ends at the first NUL */
    memset(&h, 0, sizeof h);
    h.lookup_mode = 2;
    b = make(&h, 1);
    CHECK(session_a4b_begin_scene(b, scene, &bad, &kernel) == SESSION_A4B_OK);
    text = session_a4b_row_text(b, 1u, &length);
    CHECK(text != NULL && length == 2u + 3u && memcmp(text, "AB<e>", 5u) == 0);
    session_a4b_destroy(b);

    /* 40001 bytes are fatal in the original (0x40c6f7); the native allocation limit is 32761 resolved bytes */
    memset(&h, 0, sizeof h);
    h.lookup_mode = 4;
    b = make(&h, 1);
    CHECK(session_a4b_begin_scene(b, scene, &bad, &kernel) == SESSION_A4B_ERR_SCENE && bad == 1u);
    session_a4b_destroy(b);
    h.lookup_mode = 3;
    b = make(&h, 1);
    CHECK(session_a4b_begin_scene(b, scene, &bad, &kernel) == SESSION_A4B_ERR_SCENE && bad == 1u);
    session_a4b_destroy(b);
    h.lookup_mode = 5;
    b = make(&h, 1);
    CHECK(session_a4b_begin_scene(b, scene, &bad, &kernel) == SESSION_A4B_OK);
    text = session_a4b_row_text(b, 1u, &length);
    CHECK(text != NULL && length == 32761u + 3u && memcmp(text + 32761u, "<e>", 3u) == 0);
    session_a4b_destroy(b);
    free(h.big);

    CHECK(session_a4b_begin_scene(NULL, scene, NULL, NULL) == SESSION_A4B_ERR_ARGUMENT);
    scene_resource_close(scene);
}

typedef void (*Case)(void);

int main(int argc, char **argv)
{
    static const struct {
        const char *name;
        Case fn;
    } cases[] = {
        {"loader_objects", objects},
        {"handler_effects", handler_effects},
        {"autotext_lookup", lookup_cases},
    };
    int failures = 0;
    size_t i;
    if (argc != 2) return 2;
    g_scene_path = argv[1];
    for (i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        g_failed = 0;
        cases[i].fn();
        if (g_failed) {
            printf("FAIL %s: %s\n", cases[i].name, g_msg);
            ++failures;
        } else {
            printf("PASS %s\n", cases[i].name);
        }
    }
    free(g_bytes);
    return failures;
}
