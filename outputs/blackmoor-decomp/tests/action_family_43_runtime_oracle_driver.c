/* RT-32 native side of the raw 0x43 oracle (tests/action_family_43_runtime_original_oracle.py).
 *
 * One handle owns a synthetic SCEN resource (the production parser delivers each row's SceneActionInfo), the real 0x36
 * overlay binding, the real 0x43 binding and an AUTOTEXT key table. The recovered text writer is replaced through the
 * binding's write_text seam by a recorder, so the oracle compares what the handler hands to the original 0x413187 (the
 * writer has its own oracle). a43o_visit() performs what the executor does for a true gate: it calls the handler and
 * derives the completion byte, the dependency reset request and the phase from the returned disposition. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_core.h"
#include "scene_resource.h"
#include "session_bindings_a36.h"
#include "session_bindings_a43.h"

#define MAX_KEYS 16
#define MAX_TEXT 70000

typedef struct {
    SessionA36Binding *a36;
    SessionA43Binding *a43;
    SceneResource *scene;
    uint8_t *scene_bytes;
    char key[MAX_KEYS][34];
    uint8_t *key_text[MAX_KEYS];
    size_t key_text_length[MAX_KEYS];
    unsigned key_count;
    int write_fail;
    unsigned write_calls;
    uint8_t entry[ACTION_FAMILY_43_PREFIX_BYTES];
    uint8_t *text;
    size_t text_length;
    size_t text_capacity;
    uint8_t entry_pointer_ok;
} Handle;

static int lookup(void *c, const uint8_t *key, size_t key_length, const uint8_t **text, size_t *length)
{
    Handle *h = (Handle *)c;
    unsigned i;
    for (i = 0u; i < h->key_count; ++i) {
        if (strlen(h->key[i]) == key_length && memcmp(h->key[i], key, key_length) == 0) {
            *text = h->key_text[i];
            *length = h->key_text_length[i];
            return 0;
        }
    }
    return 1;
}

static int write_text(void *c, uint8_t *entry, const char *text, size_t capacity)
{
    Handle *h = (Handle *)c;
    ++h->write_calls;
    memcpy(h->entry, entry, sizeof(h->entry));
    h->entry_pointer_ok = text == (const char *)entry + ACTION_FAMILY_43_PREFIX_BYTES;
    free(h->text);
    h->text_length = strlen(text);
    h->text_capacity = capacity;
    h->text = (uint8_t *)malloc(h->text_length + 1u);
    if (h->text != NULL) memcpy(h->text, text, h->text_length + 1u);
    return h->write_fail ? 1 : 0;
}

static int load_world(void *c, Overlay36World *w) { (void)c; (void)w; return 0; }

Handle *a43o_new(void)
{
    SessionA36Host a36_host;
    SessionA43Host host;
    Handle *h = (Handle *)calloc(1u, sizeof(*h));
    if (h == NULL) return NULL;
    memset(&a36_host, 0, sizeof a36_host);
    a36_host.kernel.context = h;
    a36_host.load_world = load_world;
    h->a36 = session_a36_create(&a36_host);
    memset(&host, 0, sizeof host);
    host.context = h;
    host.lookup = lookup;
    host.write_text = write_text;
    h->a43 = h->a36 != NULL ? session_a43_create(&host, h->a36) : NULL;
    if (h->a43 == NULL) {
        session_a36_destroy(h->a36);
        free(h);
        return NULL;
    }
    return h;
}

static void clear_keys(Handle *h)
{
    unsigned i;
    for (i = 0u; i < h->key_count; ++i) free(h->key_text[i]);
    h->key_count = 0u;
}

void a43o_free(Handle *h)
{
    if (h == NULL) return;
    session_a43_destroy(h->a43);
    session_a36_destroy(h->a36);
    scene_resource_close(h->scene);
    free(h->scene_bytes);
    clear_keys(h);
    free(h->text);
    free(h);
}

int a43o_key(Handle *h, const char *key, const uint8_t *text, size_t length)
{
    if (h->key_count >= MAX_KEYS || strlen(key) > 33u) return 1;
    snprintf(h->key[h->key_count], sizeof h->key[0], "%s", key);
    h->key_text[h->key_count] = (uint8_t *)malloc(length + 1u);
    if (h->key_text[h->key_count] == NULL) return 1;
    memcpy(h->key_text[h->key_count], text, length);
    h->key_text[h->key_count][length] = 0;
    h->key_text_length[h->key_count] = length;
    ++h->key_count;
    return 0;
}

void a43o_clear_keys(Handle *h) { clear_keys(h); }

static size_t put_chunk(uint8_t *out, size_t at, const char *tag, const uint8_t *data, size_t length)
{
    memcpy(out + at, tag, 4);
    out[at + 4] = (uint8_t)(length >> 24);
    out[at + 5] = (uint8_t)(length >> 16);
    out[at + 6] = (uint8_t)(length >> 8);
    out[at + 7] = (uint8_t)length;
    memcpy(out + at + 8, data, length);
    return at + 8 + length + (length & 1u);
}

/* rows: `count` raw bodies (type 0x43 after the 48-byte description) concatenated; lengths[i] is each body's size. */
int a43o_scene(Handle *h, unsigned count, const uint8_t *subtypes, const uint8_t *bodies, const size_t *lengths)
{
    size_t total = 256u, at = 12u, offset = 0u;
    uint8_t tsum[126];
    uint8_t *bytes, *act;
    unsigned i;
    char error[128];
    for (i = 0u; i < count; ++i) total += 80u + lengths[i];
    bytes = (uint8_t *)calloc(total, 1u);
    act = (uint8_t *)calloc(1u, 70000u);
    if (bytes == NULL || act == NULL) {
        free(bytes);
        free(act);
        return 1;
    }
    memset(tsum, 0, sizeof tsum);
    memcpy(tsum, "Oracle", 7);
    memcpy(tsum + 50, "background", 11);
    memcpy(tsum + 83, "sound", 6);
    memcpy(bytes + 8, "SCEN", 4);
    at = put_chunk(bytes, at, "TSUM", tsum, sizeof tsum);
    for (i = 0u; i < count; ++i) {
        memset(act, 0, 70000u);
        memcpy(act, "row", 4);
        act[48] = ACTION_FAMILY_43_RAW_TYPE;
        act[49] = subtypes[i];
        memcpy(act + 50, bodies + offset, lengths[i]);
        at = put_chunk(bytes, at, "ACT\0", act, 50u + lengths[i]);
        offset += lengths[i];
    }
    memcpy(bytes, "DATA", 4);
    bytes[4] = (uint8_t)((at - 8u) >> 24);
    bytes[5] = (uint8_t)((at - 8u) >> 16);
    bytes[6] = (uint8_t)((at - 8u) >> 8);
    bytes[7] = (uint8_t)(at - 8u);
    free(act);
    scene_resource_close(h->scene);
    free(h->scene_bytes);
    h->scene_bytes = bytes;
    h->scene = scene_resource_open_memory(bytes, at, error, sizeof error);
    if (h->scene == NULL) return 2;
    return session_a36_begin_scene(h->a36, h->scene) == OVERLAY36_OK ? 0 : 3;
}

void a43o_fail_writes(Handle *h, int fail) { h->write_fail = fail; }
unsigned a43o_write_calls(const Handle *h) { return h->write_calls; }
const uint8_t *a43o_entry(const Handle *h) { return h->entry; }
const uint8_t *a43o_text(const Handle *h) { return h->text; }
size_t a43o_text_length(const Handle *h) { return h->text_length; }
size_t a43o_text_capacity(const Handle *h) { return h->text_capacity; }
int a43o_entry_pointer_ok(const Handle *h) { return h->entry_pointer_ok; }
const uint8_t *a43o_image(const Handle *h, size_t row) { return session_a36_image(h->a36, row); }
const char *a43o_failure(const Handle *h) { return session_a43_failure(h->a43); }

/* Returns the handler status (SCENE_ACTION_HANDLER_*) or 100 + an executor-side failure. */
int a43o_visit(Handle *h, unsigned row, int completed_before, uint32_t phase_before, int *completed_after, int *reset,
               uint32_t *phase_after, int *disposition, int *become36)
{
    SceneActionInfo info;
    SceneActionRuntimeState before;
    SceneActionHandlerResult out;
    ActionCoreActionResult finish;
    int status;
    if (scene_resource_action_at(h->scene, row, &info) != SCENE_RESOURCE_OK) return 99;
    memset(&before, 0, sizeof before);
    before.completed = (uint8_t)completed_before;
    before.phase = phase_before;
    out.disposition = SCENE_ACTION_HANDLER_PENDING;
    out.phase = phase_before;
    out.become_overlay36 = 0u;
    *completed_after = completed_before;
    *reset = 0;
    *phase_after = phase_before;
    *become36 = 0;
    h->write_calls = 0u;
    status = session_a43_handler(h->a43, row, &info, &before, &out);
    *disposition = (int)out.disposition;
    *become36 = out.become_overlay36;
    if (status != SCENE_ACTION_HANDLER_OK) return status;
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
