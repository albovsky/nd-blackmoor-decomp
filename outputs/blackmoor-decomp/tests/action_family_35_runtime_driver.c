/* Deterministic host boundaries for lifecycle contracts and original oracle.
 * No decoder/session decision is substituted on the original side. */
#include "action_family_35_runtime.h"
#include "session_bindings_a35.h"
#include <stdlib.h>
#include <string.h>

typedef struct Fixture {
    A35World world;
    A35Runtime *runtime;
    uint8_t *body;
    size_t length;
    int32_t flags[3000];
    A35Result result;
    int32_t status, opened, closed, rects, decoded, next_calls;
    int due, more, fail_due;
    int16_t frame;
    SessionA35Binding *binding;
    AvfFile file;
    AvfStream stream;
    uint8_t *avf_bytes, *buffer0, *buffer1, *scratch;
    uint32_t generation, now;
} Fixture;

static int open_movie(void *v, const ActionFamily35Decoded *d, AvfStream **stream)
{
    Fixture *f = (Fixture *)v;
    if (d->words[0] != 1u) {
        if (f->avf_bytes == NULL) return A35_RUNTIME_UNSUPPORTED;
        *stream = &f->stream;
    }
    ++f->opened;
    return 0;
}
static void close_movie(void *v) { ++((Fixture *)v)->closed; }
static int due_movie(void *v, int *due)
{ *due = ((Fixture *)v)->due; return ((Fixture *)v)->fail_due; }
static int decode_movie(void *v, int16_t *frame)
{ Fixture *f = (Fixture *)v; ++f->decoded; *frame = f->frame; return 0; }
static int next_movie(void *v, int *more)
{
    Fixture *f = (Fixture *)v;
    const int reverse = f->body[0x29] == 2;
    ++f->next_calls;
    *more = f->more < 0 ? (reverse ? f->frame != 0 : f->frame != 2) : f->more;
    if (*more) f->frame = (int16_t)(f->frame + (reverse ? -1 : 1));
    return 0;
}
static int rect_movie(void *v, const A35Rect *s, const A35Rect *d)
{ (void)s; (void)d; ++((Fixture *)v)->rects; return 0; }
static uint32_t clock_movie(void *v) { return ((Fixture *)v)->now; }
static int present_movie(void *v, const AvfPresentation *p)
{ ((Fixture *)v)->generation = p->generation; return 0; }

void *rt35_new(const uint8_t *body, size_t length)
{
    Fixture *f = (Fixture *)calloc(1, sizeof(*f));
    A35Host host;
    if (f == NULL) return NULL;
    f->body = (uint8_t *)malloc(length);
    if (f->body == NULL) { free(f); return NULL; }
    memcpy(f->body, body, length); f->length = length;
    f->world.event_flags = f->flags; f->world.event_flag_count = 3000;
    f->world.modal = 7; f->world.layers[0] = 11; f->world.layers[1] = 12; f->world.layers[2] = 13;
    memset(&host, 0, sizeof(host)); host.context = f;
    host.open = open_movie; host.close = close_movie;
    host.bink_due = due_movie; host.bink_decode = decode_movie;
    host.bink_next = next_movie; host.rect = rect_movie;
    host.avf.context = f; host.avf.clock = clock_movie; host.avf.present = present_movie;
    f->runtime = action35_runtime_create(&f->world, &host);
    if (f->runtime == NULL) { free(f->body); free(f); return NULL; }
    return f;
}

int rt35_step(void *v, int32_t phase, int32_t view, int32_t due, int32_t frame, int32_t more)
{
    Fixture *f = (Fixture *)v;
    A35Input input = {(int16_t)view, 10, 20};
    f->due = due; f->frame = (int16_t)frame; f->more = more;
    f->status = action35_runtime_step(f->runtime, f->body, f->length,
                                      (uint32_t)phase, &input, &f->result);
    return f->status;
}

/* Configure a deliberately missing provider before start. */
void rt35_missing(void *v, int which)
{
    Fixture *f = (Fixture *)v;
    A35Host host;
    if (which == 0) {
        action35_runtime_destroy(f->runtime);
        memset(&host, 0, sizeof(host));
        host.context = f;
        f->runtime = action35_runtime_create(&f->world, &host);
    } else {
        action35_runtime_destroy(f->runtime);
        memset(&host, 0, sizeof(host)); host.context = f;
        host.open = open_movie; host.close = close_movie;
        host.bink_due = due_movie; host.bink_next = next_movie; host.rect = rect_movie;
        f->runtime = action35_runtime_create(&f->world, &host);
    }
}

void rt35_values(void *v, int32_t *out)
{
    Fixture *f = (Fixture *)v;
    A35Snapshot s;
    (void)action35_runtime_snapshot(f->runtime, &s);
    {
        const int32_t values[] = {(int32_t)f->result.phase, f->result.finish,
            s.substate,s.presented,s.dirty,s.shown,s.flag21a,s.matched,s.record,
            f->world.active,f->world.modal,f->world.start,f->world.visible,
            f->world.redraw,f->world.cursor,f->world.layers[0],f->world.layers[1],f->world.layers[2],
            f->result.transition,f->result.scene,f->result.frame,f->result.vertical,f->result.word,
            f->result.dwords[0],f->result.dwords[1],f->result.dwords[2],f->result.engine,
            s.saved_modal,f->status,f->opened,f->closed,f->rects,f->decoded,f->next_calls,
            s.source.left,s.source.top,s.source.right,s.source.bottom,
            s.destination.left,s.destination.top,s.destination.right,s.destination.bottom};
        memcpy(out, values, sizeof(values));
    }
}
int32_t rt35_flag(void *v, int index)
{ return index >= 0 && index < 3000 ? ((Fixture *)v)->flags[index] : -99999; }
void rt35_free(void *v)
{
    Fixture *f = (Fixture *)v;
    session_a35_destroy(f->binding); action35_runtime_destroy(f->runtime);
    free(f->avf_bytes); free(f->buffer0); free(f->buffer1); free(f->scratch);
    free(f->body); free(f);
}

int rt35_avf(void *v, const uint8_t *data, size_t length)
{
    Fixture *f = (Fixture *)v;
    f->avf_bytes = (uint8_t *)malloc(length);
    if (f->avf_bytes == NULL) return 1;
    memcpy(f->avf_bytes, data, length);
    if (avf_open(f->avf_bytes, length, &f->file) != AVF_OK) return 1;
    f->buffer0 = (uint8_t *)calloc(1, f->file.frame_bytes);
    f->buffer1 = (uint8_t *)calloc(1, f->file.frame_bytes);
    f->scratch = (uint8_t *)calloc(1, f->file.max_unpacked);
    if (f->buffer0 == NULL || f->buffer1 == NULL || f->scratch == NULL) return 1;
    return avf_stream_init(&f->stream, &f->file, f->buffer0, f->buffer1,
        f->file.frame_bytes, f->scratch, f->file.max_unpacked, NULL, NULL);
}
int rt35_poll(void *v) { return action35_runtime_worker_poll(((Fixture *)v)->runtime); }
int rt35_ack(void *v)
{ Fixture *f = (Fixture *)v; int blitted; return action35_runtime_render_ack(f->runtime, f->generation, &blitted); }
void rt35_now(void *v, uint32_t now) { ((Fixture *)v)->now = now; }
void rt35_fail_due(void *v) { ((Fixture *)v)->fail_due = 1; }

static int binding_input(void *v, A35Input *input)
{ (void)v; *input = (A35Input){0,10,20}; return 0; }
static void binding_world(void *v, A35World *w) { (void)v; (void)w; }
static void binding_store(void *v, const A35World *w) { (void)v; (void)w; }
void *rt35_binding(void *v, const SceneResource *scene, int missing)
{
    Fixture *f = (Fixture *)v;
    SessionA35Host host;
    memset(&host, 0, sizeof(host));
    host.movie.context = f; host.movie.open = open_movie; host.movie.close = close_movie;
    host.movie.bink_due = due_movie; host.movie.bink_next = next_movie;
    host.movie.bink_decode = missing ? NULL : decode_movie; host.movie.rect = rect_movie;
    host.input = binding_input; host.load_world = binding_world; host.store_world = binding_store;
    f->binding = session_a35_create(&f->world, &host);
    if (f->binding == NULL || session_a35_begin_scene(f->binding, scene) != A35_RUNTIME_OK) return NULL;
    f->due = 1; f->frame = 2; f->more = 0;
    return f->binding;
}
