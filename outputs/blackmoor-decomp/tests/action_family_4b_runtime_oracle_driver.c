/* RT-39 native side of the raw 0x4b oracle (tests/action_family_4b_runtime_original_oracle.py).
 *
 * One handle owns the real session binding, the scene it was started on, an AUTOTEXT lookup (the decoded AUTOTEXT resource plus
 * the synthetic entries the oracle inserted into the original table as well) and the log of caption writes (in call order: the
 * row index and the text bytes the writer was asked to present). a4bo_visit() performs what the executor does for a true gate:
 * it calls the binding handler for the row and derives the completion byte, the dependency reset request and the phase from the
 * returned disposition with the executor's own helper (action_core_finish_action, scene_executor.c apply_external_handler). */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_core.h"
#include "autotext.h"
#include "session_bindings_a4b.h"

#define EXTRA_MAX 64

typedef struct {
    uint8_t key[40];
    size_t key_length;
    uint8_t *value;
    size_t value_length;
} Extra;

typedef struct {
    int index;
    size_t length;
    uint8_t *bytes;
} Write;

typedef struct {
    AutoText *autotext;
    unsigned char *autotext_bytes;
    Extra extra[EXTRA_MAX];
    unsigned extra_count;
    unsigned char *scene_bytes;
    SceneResource *scene;
    SessionA4bBinding *binding;
    Write *writes;
    unsigned write_count, write_cap;
    int current_row;
    int writer_status;
} Handle;

static int ascii_lower(int c)
{
    return c >= 'A' && c <= 'Z' ? c + 32 : c;
}

static ActionFamily51LookupStatus lookup(void *context, const uint8_t *key, size_t key_length, const uint8_t **text, size_t *length)
{
    Handle *h = (Handle *)context;
    unsigned i;
    size_t k, raw = 0u;
    int status;
    for (i = 0; i < h->extra_count; ++i) {
        const Extra *e = &h->extra[i];
        if (e->key_length != key_length) continue;
        for (k = 0; k < key_length && ascii_lower(e->key[k]) == ascii_lower(key[k]); ++k) {}
        if (k == key_length) {
            *text = e->value;
            *length = e->value_length;
            return ACTION_FAMILY_51_LOOKUP_FOUND;
        }
    }
    status = autotext_lookup(h->autotext, key, key_length, text, &raw, length);
    if (status == AUTOTEXT_OK) return ACTION_FAMILY_51_LOOKUP_FOUND;
    return status == AUTOTEXT_ERR_NOT_FOUND ? ACTION_FAMILY_51_LOOKUP_NOT_FOUND : ACTION_FAMILY_51_LOOKUP_ERROR;
}

static SessionA4bWriteStatus write_caption(void *context, const uint8_t *text, size_t length)
{
    Handle *h = (Handle *)context;
    Write *w;
    if (h->write_count == h->write_cap) {
        h->write_cap = h->write_cap ? h->write_cap * 2u : 64u;
        h->writes = (Write *)realloc(h->writes, h->write_cap * sizeof(Write));
    }
    w = &h->writes[h->write_count++];
    w->index = h->current_row;
    w->length = length;
    w->bytes = (uint8_t *)malloc(length ? length : 1u);
    memcpy(w->bytes, text, length);
    return (SessionA4bWriteStatus)h->writer_status;
}

Handle *a4bo_new(const char *autotext_path)
{
    Handle *h = (Handle *)calloc(1u, sizeof(*h));
    SessionA4bHost host;
    FILE *f;
    long n;
    char err[128] = {0};
    if (h == NULL) return NULL;
    f = fopen(autotext_path, "rb");
    if (f == NULL) return NULL;
    fseek(f, 0, SEEK_END);
    n = ftell(f);
    fseek(f, 0, SEEK_SET);
    h->autotext_bytes = (unsigned char *)malloc((size_t)n);
    if (h->autotext_bytes == NULL || fread(h->autotext_bytes, 1, (size_t)n, f) != (size_t)n) return NULL;
    fclose(f);
    if (autotext_open_memory(h->autotext_bytes, (size_t)n, 0, &h->autotext, err, sizeof err) != AUTOTEXT_OK) return NULL;
    memset(&host, 0, sizeof host);
    host.context = h;
    host.lookup = lookup;
    host.lookup_context = h;
    host.write_caption = write_caption;
    h->binding = session_a4b_create(&host);
    return h->binding != NULL ? h : NULL;
}

void a4bo_free(Handle *h)
{
    unsigned i;
    if (h == NULL) return;
    for (i = 0; i < h->write_count; ++i) free(h->writes[i].bytes);
    for (i = 0; i < h->extra_count; ++i) free(h->extra[i].value);
    free(h->writes);
    session_a4b_destroy(h->binding);
    if (h->scene != NULL) scene_resource_close(h->scene);
    free(h->scene_bytes);
    autotext_close(h->autotext);
    free(h->autotext_bytes);
    free(h);
}

int a4bo_add_entry(Handle *h, const uint8_t *key, unsigned key_length, const uint8_t *value, unsigned value_length)
{
    Extra *e;
    if (h->extra_count == EXTRA_MAX || key_length >= sizeof e->key) return 0;
    e = &h->extra[h->extra_count++];
    memcpy(e->key, key, key_length);
    e->key_length = key_length;
    e->value = (uint8_t *)malloc(value_length ? value_length : 1u);
    memcpy(e->value, value, value_length);
    e->value_length = value_length;
    return 1;
}

/* Returns SESSION_A4B_* (3 = a fatal row; *failed_row and *kernel name it). */
int a4bo_begin(Handle *h, const uint8_t *scene_bytes, unsigned length, unsigned *failed_row, int *kernel)
{
    char err[128] = {0};
    size_t failed = 0u;
    int status;
    if (h->scene != NULL) scene_resource_close(h->scene);
    free(h->scene_bytes);
    h->scene = NULL;
    h->scene_bytes = (unsigned char *)malloc(length);
    memcpy(h->scene_bytes, scene_bytes, length);
    h->scene = scene_resource_open_memory(h->scene_bytes, length, err, sizeof err);
    if (h->scene == NULL) return 100;
    *kernel = 0;
    status = session_a4b_begin_scene(h->binding, h->scene, &failed, kernel);
    *failed_row = (unsigned)failed;
    return status;
}

/* The object text of a row (length word, then the text including the marker); returns its byte count or -1. */
int a4bo_row_object(Handle *h, unsigned index, uint8_t *out, unsigned capacity)
{
    size_t length = 0u;
    const uint8_t *text = session_a4b_row_text(h->binding, index, &length);
    if (text == NULL || length + 2u > capacity) return -1;
    out[0] = (uint8_t)length;
    out[1] = (uint8_t)(length >> 8);
    memcpy(out + 2, text, length);
    return (int)(length + 2u);
}

void a4bo_set_writer_status(Handle *h, int status) { h->writer_status = status; }
unsigned a4bo_log_count(const Handle *h) { return h->write_count; }
int a4bo_log_row(const Handle *h, unsigned i) { return h->writes[i].index; }
unsigned a4bo_log_length(const Handle *h, unsigned i) { return (unsigned)h->writes[i].length; }
void a4bo_log_copy(const Handle *h, unsigned i, uint8_t *out) { memcpy(out, h->writes[i].bytes, h->writes[i].length); }
void a4bo_log_clear(Handle *h)
{
    unsigned i;
    for (i = 0; i < h->write_count; ++i) free(h->writes[i].bytes);
    h->write_count = 0u;
}

/* Returns the handler status (SCENE_ACTION_HANDLER_*) or 100 + the executor-side failure. */
int a4bo_visit(Handle *h, int index, int completed_before, uint32_t phase_before, int *completed_after, int *reset,
               uint32_t *phase_after, int *disposition)
{
    SceneActionInfo info;
    SceneActionRuntimeState before;
    SceneActionHandlerResult out;
    ActionCoreActionResult finish;
    int status;
    if (scene_resource_action_at(h->scene, (size_t)index, &info) != SCENE_RESOURCE_OK) return 103;
    before.completed = (uint8_t)completed_before;
    before.phase = phase_before;
    out.disposition = SCENE_ACTION_HANDLER_PENDING;
    out.phase = phase_before;
    *completed_after = completed_before;
    *reset = 0;
    *phase_after = phase_before;
    h->current_row = index;
    status = session_a4b_handler(h->binding, (size_t)index, &info, &before, &out);
    *disposition = (int)out.disposition;
    if (status != SCENE_ACTION_HANDLER_OK) return status;
    /* scene_executor.c apply_external_handler */
    switch (out.disposition) {
    case SCENE_ACTION_HANDLER_PENDING:
        *phase_after = out.phase;
        break;
    case SCENE_ACTION_HANDLER_COMPLETED:
        if (action_core_finish_action(info.subtype, (uint8_t)completed_before, &finish) != ACTION_CORE_OK) return 101;
        *completed_after = finish.completed;
        *reset = finish.reset_dependencies;
        *phase_after = out.phase;
        break;
    case SCENE_ACTION_HANDLER_DIRECT_COMPLETED:
        *completed_after = 1;
        *phase_after = out.phase;
        break;
    case SCENE_ACTION_HANDLER_RESET_DEPENDENCIES:
        *phase_after = 0u;
        *reset = 1;
        break;
    default:
        return 102;
    }
    return 0;
}
