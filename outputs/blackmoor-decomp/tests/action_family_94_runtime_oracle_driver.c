/* RT-32 native side of the raw 0x94 oracle (tests/action_family_94_runtime_original_oracle.py).
 *
 * One handle owns a stand-in display (size, pixel layout, frame pixels, drive and directory strings) and the real session
 * binding. a94o_visit() performs what the executor does for a true gate: it calls the binding handler and derives the
 * row's completion byte, the dependency reset request and the phase from the returned disposition with the executor's own
 * helper (action_core_finish_action, scene_executor.c apply_external_handler). Every host callback is logged so the oracle
 * can compare the order of the effects with the original's flag stores, redraw request and file calls. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_core.h"
#include "session_bindings_a94.h"

#define MAX_EVENTS 64
enum { EV_FLAG = 1, EV_REFRESH = 2, EV_CAPTURE = 3, EV_FILE = 4 };

typedef struct {
    int kind;
    int32_t value;
} Event;

typedef struct {
    SessionA94Binding *binding;
    SessionA94Display display;
    uint8_t *pixels;
    size_t pixel_bytes;
    int fail_write;
    Event events[MAX_EVENTS];
    unsigned event_count;
    char path[A94_PATH_BYTES];
    uint8_t *file;
    size_t file_length;
} Handle;

static void log_event(Handle *h, int kind, int32_t value)
{
    if (h->event_count < MAX_EVENTS) {
        h->events[h->event_count].kind = kind;
        h->events[h->event_count].value = value;
        ++h->event_count;
    }
}

static void set_flag(void *c, int32_t v) { log_event((Handle *)c, EV_FLAG, v); }
static void refresh(void *c) { log_event((Handle *)c, EV_REFRESH, 0); }
static int display(void *c, SessionA94Display *d)
{
    *d = ((Handle *)c)->display;
    return 0;
}
static int capture(void *c, uint8_t *dst, size_t n)
{
    Handle *h = (Handle *)c;
    log_event(h, EV_CAPTURE, 0);
    if (n != h->pixel_bytes) return 1;
    memcpy(dst, h->pixels, n);
    return 0;
}
static int write_file(void *c, const char *path, const uint8_t *bytes, size_t n)
{
    Handle *h = (Handle *)c;
    log_event(h, EV_FILE, h->fail_write ? 1 : 0);
    snprintf(h->path, sizeof h->path, "%s", path);
    free(h->file);
    h->file = (uint8_t *)malloc(n);
    h->file_length = h->file == NULL ? 0u : n;
    if (h->file != NULL) memcpy(h->file, bytes, n);
    return h->fail_write ? 1 : 0;
}

Handle *a94o_new(void)
{
    SessionA94Host host;
    Handle *h = calloc(1u, sizeof(*h));
    if (h == NULL) return NULL;
    memset(&host, 0, sizeof host);
    host.context = h;
    host.set_capture_flag = set_flag;
    host.request_refresh = refresh;
    host.display = display;
    host.capture = capture;
    host.write_file = write_file;
    h->binding = session_a94_create(&host);
    if (h->binding == NULL) {
        free(h);
        return NULL;
    }
    return h;
}

void a94o_free(Handle *h)
{
    if (h != NULL) {
        session_a94_destroy(h->binding);
        free(h->pixels);
        free(h->file);
        free(h);
    }
}

/* shifts/masks/bits: three bytes each, index 0 blue, 1 green, 2 red. */
int a94o_setup(Handle *h, int width, int height, int bytes_per_pixel, int bits_per_pixel, const uint8_t *shifts,
               const uint8_t *masks, const uint8_t *bits, const char *drive, const char *dir, const uint8_t *pixels,
               size_t pixel_bytes, int fail_write)
{
    A94Screen *s = &h->display.screen;
    memset(&h->display, 0, sizeof h->display);
    s->width = (int16_t)width;
    s->height = (int16_t)height;
    s->bytes_per_pixel = (int16_t)bytes_per_pixel;
    s->bits_per_pixel = (uint8_t)bits_per_pixel;
    memcpy(s->shifts, shifts, 3);
    memcpy(s->masks, masks, 3);
    memcpy(s->channel_bits, bits, 3);
    snprintf(h->display.drive, sizeof h->display.drive, "%s", drive);
    snprintf(h->display.dir, sizeof h->display.dir, "%s", dir);
    free(h->pixels);
    h->pixels = (uint8_t *)malloc(pixel_bytes);
    if (h->pixels == NULL) return 1;
    memcpy(h->pixels, pixels, pixel_bytes);
    h->pixel_bytes = pixel_bytes;
    h->fail_write = fail_write;
    h->event_count = 0u;
    h->path[0] = '\0';
    free(h->file);
    h->file = NULL;
    h->file_length = 0u;
    return 0;
}

unsigned a94o_event_count(const Handle *h) { return h->event_count; }
int a94o_event_kind(const Handle *h, unsigned i) { return h->events[i].kind; }
int32_t a94o_event_value(const Handle *h, unsigned i) { return h->events[i].value; }
void a94o_clear_events(Handle *h) { h->event_count = 0u; }
const char *a94o_path(const Handle *h) { return h->path; }
size_t a94o_file_length(const Handle *h) { return h->file_length; }
const uint8_t *a94o_file(const Handle *h) { return h->file; }
unsigned long a94o_written(const Handle *h) { return session_a94_files_written(h->binding); }
unsigned long a94o_refused(const Handle *h) { return session_a94_files_refused(h->binding); }

/* Returns the handler status (SCENE_ACTION_HANDLER_*) or 100 + the executor-side failure. */
int a94o_visit(Handle *h, int subtype, const uint8_t *body, int completed_before, uint32_t phase_before,
               int *completed_after, int *reset, uint32_t *phase_after, int *disposition)
{
    SceneActionInfo info;
    SceneActionRuntimeState before;
    SceneActionHandlerResult out;
    ActionCoreActionResult finish;
    int status;
    memset(&info, 0, sizeof(info));
    info.type = ACTION_FAMILY_94_RAW_TYPE;
    info.subtype = (uint8_t)subtype;
    info.typed_body = body;
    info.typed_body_length = A94_BODY_BYTES;
    before.completed = (uint8_t)completed_before;
    before.phase = phase_before;
    out.disposition = SCENE_ACTION_HANDLER_PENDING;
    out.phase = phase_before;
    *completed_after = completed_before;
    *reset = 0;
    *phase_after = phase_before;
    status = session_a94_handler(h->binding, 0u, &info, &before, &out);
    *disposition = (int)out.disposition;
    if (status != SCENE_ACTION_HANDLER_OK) return status;
    switch (out.disposition) {
    case SCENE_ACTION_HANDLER_PENDING:
        *phase_after = out.phase;
        break;
    case SCENE_ACTION_HANDLER_COMPLETED:
        if (action_core_finish_action((uint8_t)subtype, (uint8_t)completed_before, &finish) != ACTION_CORE_OK) return 101;
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
