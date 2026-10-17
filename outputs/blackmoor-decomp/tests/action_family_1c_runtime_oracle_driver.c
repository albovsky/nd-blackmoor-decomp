/* RT-57 native side of the raw 0x1c oracle (tests/action_family_1c_runtime_original_oracle.py).
 *
 * One handle owns a scripted CInteractiveVideo host: the movie player at 0x637fcf (state, clip name, hotspot index, origin object),
 * a store of ".IV" files (name -> bytes), the word cell [0x583a29], the generic z entry table (0x58 entries of 0x4a bytes at
 * 0x5d1591: a model with the original's allocator rule, the registration stores and the release stores) and an ordered log of
 * every host call. The driver decides nothing the kernel decides. a1co_visit() performs what the executor does for a true gate
 * (scene_executor.c apply_external_handler): it calls the real session binding and derives the row's completion byte, the
 * dependency reset request and the phase from the returned disposition with action_core_finish_action.
 *
 * Event kinds of the log (same numbers as the oracle's original-side log): 1 player state, 2 player name, 3 player hotspot,
 * 4 player origin, 5 open (a = index of the file in the store or -1), 6 read (a = requested, b = returned), 7 close,
 * 8 alloc slot (a = slot), 9 register slot (a = slot), 10 release slot (a = slot), 11 cell [0x583a29]. */
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "action_core.h"
#include "session_bindings_a1c.h"

#define Z_ENTRIES 0x58
#define Z_STRIDE 0x4a
#define Z_FIRST 0x18
#define Z_LAST 0x3f
#define MAX_FILES 8
#define MAX_EVENTS 16384

/* Every allocation of the library (kernel, binding, driver) goes through the linker wrappers below (-Wl,--wrap=calloc,malloc,free), so
 * the oracle can compare the live block count with the file tables the original keeps. */
extern void *__real_calloc(size_t, size_t);
extern void *__real_malloc(size_t);
extern void __real_free(void *);
static long g_live;
static long g_fail_alloc;     /* > 0: the N-th calloc from now on fails */
static int g_alloc_failed;

void a1co_fail_alloc_after(long n) { g_fail_alloc = n; g_alloc_failed = 0; }
int a1co_alloc_failed(void) { return g_alloc_failed; }

void *__wrap_calloc(size_t n, size_t s)
{
    void *p;
    if (g_fail_alloc > 0 && --g_fail_alloc == 0) {
        g_alloc_failed = 1;
        return NULL;
    }
    p = __real_calloc(n, s);
    if (p != NULL) ++g_live;
    return p;
}

void *__wrap_malloc(size_t n)
{
    void *p = __real_malloc(n);
    if (p != NULL) ++g_live;
    return p;
}

void __wrap_free(void *p)
{
    if (p != NULL) --g_live;
    __real_free(p);
}

long a1co_live(void) { return g_live; }

typedef struct {
    char name[112];
    uint8_t *data;
    size_t length;
} File;

typedef struct {
    int open;
    int file;
    size_t position;
} Stream;

typedef struct {
    SessionA1cBinding *binding;
    int32_t p_state;
    uint8_t p_name[C1C_NAME_BYTES];
    int16_t p_hotspot;
    int p_origin;
    int32_t p_dx, p_dy;
    int16_t cell;
    File files[MAX_FILES];
    int nfiles;
    Stream stream;
    unsigned long opens, closes;
    uint8_t z[Z_ENTRIES * Z_STRIDE];
    int32_t ev[MAX_EVENTS][3];
    int nev;
    long fail_countdown; /* > 0: the N-th host call from now on fails (1 = the next one); 0 = off */
    int failed;          /* a host call was failed by the countdown */
    int failed_kind;     /* the event kind of that call */
    int open_quirk;      /* 1: open_iv returns 0 with a NULL file; 2: open_iv returns 1 with a valid file */
} Handle;

static void log_event(Handle *h, int kind, int32_t a, int32_t b)
{
    if (h->nev < MAX_EVENTS) {
        h->ev[h->nev][0] = kind;
        h->ev[h->nev][1] = a;
        h->ev[h->nev][2] = b;
        ++h->nev;
    }
}

static int should_fail(Handle *h, int kind)
{
    if (h->fail_countdown > 0 && --h->fail_countdown == 0) {
        h->failed = 1;
        h->failed_kind = kind;
        return 1;
    }
    return 0;
}

static int h_state(void *c, int32_t *state)
{
    Handle *h = (Handle *)c;
    log_event(h, 1, 0, 0);
    if (should_fail(h, 1)) return 1;
    *state = h->p_state;
    return 0;
}

static int h_name(void *c, uint8_t name[C1C_NAME_BYTES])
{
    Handle *h = (Handle *)c;
    log_event(h, 2, 0, 0);
    if (should_fail(h, 2)) return 1;
    memcpy(name, h->p_name, C1C_NAME_BYTES);
    return 0;
}

static int h_hotspot(void *c, int16_t *index)
{
    Handle *h = (Handle *)c;
    log_event(h, 3, 0, 0);
    if (should_fail(h, 3)) return 1;
    *index = h->p_hotspot;
    return 0;
}

static int h_origin(void *c, int *present, int32_t *dx, int32_t *dy)
{
    Handle *h = (Handle *)c;
    log_event(h, 4, 0, 0);
    if (should_fail(h, 4)) return 1;
    *present = h->p_origin;
    *dx = h->p_dx;
    *dy = h->p_dy;
    return 0;
}

static int h_open(void *c, const char *name, void **file)
{
    Handle *h = (Handle *)c;
    int i;
    if (should_fail(h, 5)) {
        log_event(h, 5, -1, 0);
        return 1;
    }
    for (i = 0; i < h->nfiles; ++i) {
        if (strcmp(h->files[i].name, name) == 0) {
            h->stream.open = h->open_quirk == 0;           /* a quirky answer never hands over a usable stream */
            h->stream.file = i;
            h->stream.position = 0u;
            ++h->opens;
            log_event(h, 5, i, 0);
            if (h->open_quirk == 1) return 0;              /* success without a file */
            *file = &h->stream;
            return h->open_quirk == 2 ? 1 : 0;              /* failure with a file */
        }
    }
    log_event(h, 5, -1, 0);
    return 1;
}

static size_t h_read(void *c, void *file, void *buffer, size_t size)
{
    Handle *h = (Handle *)c;
    Stream *s = (Stream *)file;
    size_t left, got;
    if (s != &h->stream || !s->open) abort();
    if (should_fail(h, 6)) {
        log_event(h, 6, (int32_t)size, 0);
        return 0u;
    }
    left = h->files[s->file].length - s->position;
    got = size < left ? size : left;
    memcpy(buffer, h->files[s->file].data + s->position, got);
    s->position += got;
    log_event(h, 6, (int32_t)size, (int32_t)got);
    return got;
}

static void h_close(void *c, void *file)
{
    Handle *h = (Handle *)c;
    if ((Stream *)file != &h->stream || !h->stream.open) abort();
    h->stream.open = 0;
    ++h->closes;
    log_event(h, 7, 0, 0);
}

static uint32_t zd(const Handle *h, int slot, int off)
{
    uint32_t v;
    memcpy(&v, h->z + (size_t)slot * Z_STRIDE + (size_t)off, 4u);
    return v;
}

static void zset(Handle *h, int slot, int off, uint32_t v)
{
    memcpy(h->z + (size_t)slot * Z_STRIDE + (size_t)off, &v, 4u);
}

/* 0x4d39f9: the first entry from 0x18 to 0x3f whose dword at +0x18 is 0. */
static int h_alloc(void *c, int16_t *slot)
{
    Handle *h = (Handle *)c;
    int i;
    if (should_fail(h, 8)) return 1;
    for (i = Z_FIRST; i <= Z_LAST; ++i) {
        if (zd(h, i, 0x18) == 0u) {
            *slot = (int16_t)i;
            log_event(h, 8, i, 0);
            return 0;
        }
    }
    return 1;
}

static int h_register(void *c, int16_t slot, const char *label)
{
    Handle *h = (Handle *)c;
    uint16_t zero = 0u;
    size_t n;
    if (should_fail(h, 9)) return 1;
    if (slot < 0 || slot >= Z_ENTRIES) return 1;
    zset(h, slot, 0x00, 15u);
    zset(h, slot, 0x04, 0x4cc79au);
    zset(h, slot, 0x08, 0u);
    zset(h, slot, 0x0c, 0u);
    zset(h, slot, 0x10, 0u);
    zset(h, slot, 0x14, 1u);
    zset(h, slot, 0x18, 1u);
    memcpy(h->z + (size_t)slot * Z_STRIDE + 0x1c, &zero, 2u);
    n = strlen(label) + 1u;
    if (0x22u + n > Z_STRIDE) return 1;
    memcpy(h->z + (size_t)slot * Z_STRIDE + 0x22, label, n);
    log_event(h, 9, slot, 0);
    return 0;
}

/* 0x4d3992: clears the dwords +0x14 and +0x18. */
static int h_release(void *c, int16_t slot)
{
    Handle *h = (Handle *)c;
    if (should_fail(h, 10)) return 1;
    if (slot < 0 || slot >= Z_ENTRIES) return 1;
    zset(h, slot, 0x14, 0u);
    zset(h, slot, 0x18, 0u);
    log_event(h, 10, slot, 0);
    return 0;
}

static int h_cell(void *c, int16_t *value)
{
    Handle *h = (Handle *)c;
    log_event(h, 11, 0, 0);
    if (should_fail(h, 11)) return 1;
    *value = h->cell;
    return 0;
}

Handle *a1co_new(int omit_callback)
{
    C1cHost host;
    Handle *h = (Handle *)calloc(1u, sizeof(*h));
    if (h == NULL) return NULL;
    memset(&host, 0, sizeof host);
    host.context = h;
    host.player_state = h_state;
    host.player_name = h_name;
    host.player_hotspot = h_hotspot;
    host.player_origin = h_origin;
    host.open_iv = h_open;
    host.read = h_read;
    host.close = h_close;
    host.alloc_slot = h_alloc;
    host.register_slot = h_register;
    host.release_slot = h_release;
    host.cell_583a29 = h_cell;
    /* omit_callback 1..11 leaves out the corresponding host callback (the binding must refuse before any effect) */
    switch (omit_callback) {
    case 1: host.player_state = NULL; break;
    case 2: host.player_name = NULL; break;
    case 3: host.player_hotspot = NULL; break;
    case 4: host.player_origin = NULL; break;
    case 5: host.open_iv = NULL; break;
    case 6: host.read = NULL; break;
    case 7: host.close = NULL; break;
    case 8: host.alloc_slot = NULL; break;
    case 9: host.register_slot = NULL; break;
    case 10: host.release_slot = NULL; break;
    case 11: host.cell_583a29 = NULL; break;
    default: break;
    }
    h->binding = session_a1c_create(&host);
    if (h->binding == NULL) {
        free(h);
        return NULL;
    }
    return h;
}

void a1co_free(Handle *h)
{
    int i;
    if (h == NULL) return;
    session_a1c_destroy(h->binding);
    for (i = 0; i < h->nfiles; ++i) free(h->files[i].data);
    free(h);
}

void a1co_clear_files(Handle *h)
{
    int i;
    for (i = 0; i < h->nfiles; ++i) free(h->files[i].data);
    h->nfiles = 0;
}

int a1co_add_file(Handle *h, const char *name, const uint8_t *data, size_t length)
{
    File *f;
    int i;
    for (i = 0; i < h->nfiles; ++i) {
        if (strcmp(h->files[i].name, name) == 0) {
            free(h->files[i].data);
            h->files[i].data = (uint8_t *)malloc(length ? length : 1u);
            memcpy(h->files[i].data, data, length);
            h->files[i].length = length;
            return i;
        }
    }
    if (h->nfiles >= MAX_FILES || strlen(name) >= sizeof(h->files[0].name)) return -1;
    f = &h->files[h->nfiles];
    strcpy(f->name, name);
    f->data = (uint8_t *)malloc(length ? length : 1u);
    memcpy(f->data, data, length);
    f->length = length;
    return h->nfiles++;
}

void a1co_set_player(Handle *h, int32_t state, const uint8_t *name33, int16_t hotspot, int origin, int32_t dx, int32_t dy)
{
    h->p_state = state;
    memcpy(h->p_name, name33, C1C_NAME_BYTES);
    h->p_hotspot = hotspot;
    h->p_origin = origin;
    h->p_dx = dx;
    h->p_dy = dy;
}

void a1co_set_cell(Handle *h, int16_t value) { h->cell = value; }
void a1co_set_open_quirk(Handle *h, int mode) { h->open_quirk = mode; }
int a1co_failed_kind(const Handle *h) { return h->failed_kind; }
void a1co_set_ztable(Handle *h, const uint8_t *bytes) { memcpy(h->z, bytes, sizeof h->z); }
void a1co_get_ztable(const Handle *h, uint8_t *bytes) { memcpy(bytes, h->z, sizeof h->z); }
void a1co_fail_after(Handle *h, long n) { h->fail_countdown = n; h->failed = 0; }
int a1co_failed(const Handle *h) { return h->failed; }
int a1co_stream_open(const Handle *h) { return h->stream.open; }
unsigned long a1co_opens(const Handle *h) { return h->opens; }
unsigned long a1co_closes(const Handle *h) { return h->closes; }
void a1co_clear_events(Handle *h) { h->nev = 0; }
int a1co_event_count(const Handle *h) { return h->nev; }
void a1co_event(const Handle *h, int i, int32_t *out) { out[0] = h->ev[i][0]; out[1] = h->ev[i][1]; out[2] = h->ev[i][2]; }
unsigned long a1co_visits(const Handle *h) { return session_a1c_visits(h->binding); }
const char *a1co_failure(const Handle *h) { return session_a1c_failure(h->binding); }

/* Returns the handler status (SCENE_ACTION_HANDLER_*) or 100 + an executor-side failure. */
int a1co_visit(Handle *h, const uint8_t *raw_body, size_t raw_length, int subtype, int completed_before, uint32_t phase_before,
               int *completed_after, int *reset, uint32_t *phase_after, int *disposition)
{
    SceneActionInfo info;
    SceneActionRuntimeState before;
    SceneActionHandlerResult out;
    ActionCoreActionResult finish;
    int status;
    memset(&info, 0, sizeof(info));
    info.type = ACTION_FAMILY_1C_RAW_TYPE;
    info.subtype = (uint8_t)subtype;
    info.raw_body = raw_body;
    info.raw_body_length = raw_length;
    info.typed_body = raw_body;
    info.typed_body_length = raw_length >= C1C_BODY_BYTES ? C1C_BODY_BYTES : raw_length;
    before.completed = (uint8_t)completed_before;
    before.phase = phase_before;
    out.disposition = SCENE_ACTION_HANDLER_PENDING;
    out.phase = phase_before;
    *completed_after = completed_before;
    *reset = 0;
    *phase_after = phase_before;
    *disposition = -1;
    status = session_a1c_handler(h->binding, 0u, &info, &before, &out);
    if (status != SCENE_ACTION_HANDLER_OK) return status;
    *disposition = (int)out.disposition;
    /* scene_executor.c apply_external_handler */
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

/* Object snapshot: 16 int32 values. */
void a1co_object(const Handle *h, int32_t *out)
{
    const C1cObject *o = session_a1c_object(h->binding);
    memset(out, 0, 16u * sizeof(int32_t));
    out[0] = o->body != NULL;
    out[1] = o->iv != NULL;
    out[2] = o->slot;
    out[3] = o->armed;
    out[4] = o->changed;
    out[5] = o->record == NULL || o->iv == NULL ? -1 : (int32_t)(o->record - o->iv->entries);
    out[6] = o->word_152;
    out[7] = o->last_index;
    out[8] = o->dword_14e;
    out[9] = o->dword_154;
    out[10] = o->dword_158;
    out[11] = o->origin_present;
}

int a1co_body(const Handle *h, uint8_t *out)
{
    const C1cObject *o = session_a1c_object(h->binding);
    if (o->body == NULL) return 0;
    memcpy(out, o->body, C1C_BODY_BYTES);
    return 1;
}

/* Loaded table: returns 0 when nothing is loaded; else the number of int32 values written to out (capacity `cap`) and the
 * 33 name bytes. Layout: count, then per entry id, count, byte, word5, word7, then count * 6 rectangle dwords. */
int a1co_table(const Handle *h, uint8_t *name33, int32_t *out, int cap)
{
    const C1cObject *o = session_a1c_object(h->binding);
    int n = 0, i, j, k;
    if (o->iv == NULL) return 0;
    memcpy(name33, o->iv->name, C1C_NAME_BYTES);
    if (n < cap) out[n] = o->iv->count;
    ++n;
    for (i = 0; i < o->iv->count; ++i) {
        const C1cEntry *e = &o->iv->entries[i];
        int32_t head[5];
        head[0] = e->id;
        head[1] = e->count;
        head[2] = e->byte_4;
        head[3] = e->word_5;
        head[4] = e->word_7;
        for (k = 0; k < 5; ++k, ++n)
            if (n < cap) out[n] = head[k];
        for (j = 0; j < e->count; ++j)
            for (k = 0; k < 6; ++k, ++n)
                if (n < cap) out[n] = e->rects[j].d[k];
    }
    return n;
}

/* Render: out gets 5 int32 per fill (left, top, right, bottom, color). Returns the status; *count is the total. */
int a1co_render(Handle *h, int32_t view_x, int32_t view_y, int32_t *out, size_t cap, size_t *count)
{
    C1cFill *fills = (C1cFill *)calloc(cap ? cap : 1u, sizeof(C1cFill));
    size_t i;
    int status;
    if (fills == NULL) return -1;
    status = session_a1c_render(h->binding, view_x, view_y, fills, cap, count);
    for (i = 0; i < cap && i < *count; ++i) {
        out[5 * i + 0] = fills[i].left;
        out[5 * i + 1] = fills[i].top;
        out[5 * i + 2] = fills[i].right;
        out[5 * i + 3] = fills[i].bottom;
        out[5 * i + 4] = fills[i].color;
    }
    free(fills);
    return status;
}

/* Render with NULL arguments, for the argument checks. */
int a1co_render_null(Handle *h, int which)
{
    size_t count = 0u;
    C1cFill fill;
    switch (which) {
    case 0: return session_a1c_render(NULL, 0, 0, &fill, 1u, &count);
    case 1: return session_a1c_render(h->binding, 0, 0, &fill, 1u, NULL);
    default: return session_a1c_render(h->binding, 0, 0, NULL, 1u, &count);
    }
}

/* Direct kernel call for refusal checks of invalid arguments (bypasses the binding): which 0..3 leaves out exactly the object, the body,
 * the host or the outcome; 4 passes a host without callbacks. */
int a1co_kernel_null(Handle *h, int which)
{
    C1cObject o;
    C1cOutcome out;
    uint8_t body[C1C_BODY_BYTES];
    C1cHost host, empty;
    memset(&empty, 0, sizeof empty);
    memset(body, 0, sizeof body);
    c1c_object_reset(&o);
    host.context = h;
    host.player_state = h_state;
    host.player_name = h_name;
    host.player_hotspot = h_hotspot;
    host.player_origin = h_origin;
    host.open_iv = h_open;
    host.read = h_read;
    host.close = h_close;
    host.alloc_slot = h_alloc;
    host.register_slot = h_register;
    host.release_slot = h_release;
    host.cell_583a29 = h_cell;
    switch (which) {
    case 0: return c1c_visit(NULL, body, 0u, &host, &out);
    case 1: return c1c_visit(&o, NULL, 0u, &host, &out);
    case 2: return c1c_visit(&o, body, 0u, NULL, &out);
    case 3: return c1c_visit(&o, body, 0u, &host, NULL);
    default: return c1c_visit(&o, body, 0u, &empty, &out);
    }
}

/* The binding's handler with exactly one invalid argument: which 1 = binding, 2 = action, 3 = state, 4 = result. */
int a1co_binding_null(Handle *h, int which, const uint8_t *raw_body, size_t raw_length)
{
    SceneActionInfo info;
    SceneActionRuntimeState before;
    SceneActionHandlerResult out;
    memset(&info, 0, sizeof info);
    memset(&before, 0, sizeof before);
    memset(&out, 0, sizeof out);
    info.type = ACTION_FAMILY_1C_RAW_TYPE;
    info.raw_body = raw_body;
    info.raw_body_length = raw_length;
    switch (which) {
    case 1: return session_a1c_handler(NULL, 0u, &info, &before, &out);
    case 2: return session_a1c_handler(h->binding, 0u, NULL, &before, &out);
    case 3: return session_a1c_handler(h->binding, 0u, &info, NULL, &out);
    default: return session_a1c_handler(h->binding, 0u, &info, &before, NULL);
    }
}

int a1co_create_null(void) { return session_a1c_create(NULL) == NULL ? 0 : 1; }

/* c1c_render on a corrupt object (changed set, no current entry): the original would read through a null pointer. */
int a1co_render_corrupt(void)
{
    C1cObject o;
    C1cFill fill;
    size_t count = 7u;
    c1c_object_reset(&o);
    o.changed = 1;
    {
        int st = c1c_render(&o, 0, 0, &fill, 1u, &count);
        return st == C1C_ERR_BODY && count == 0u ? st : -1;
    }
}

int a1co_nfiles(const Handle *h) { return h->nfiles; }

/* Kernel call with every callback present except number `omit` (1..11, the order of a1co_new): must be C1C_ERR_ARGUMENT. */
int a1co_kernel_omit(Handle *h, int omit)
{
    C1cObject o;
    C1cOutcome out;
    C1cHost host;
    uint8_t body[C1C_BODY_BYTES];
    memset(body, 0, sizeof body);
    memset(&host, 0, sizeof host);
    c1c_object_reset(&o);
    host.context = h;
    host.player_state = h_state;
    host.player_name = h_name;
    host.player_hotspot = h_hotspot;
    host.player_origin = h_origin;
    host.open_iv = h_open;
    host.read = h_read;
    host.close = h_close;
    host.alloc_slot = h_alloc;
    host.register_slot = h_register;
    host.release_slot = h_release;
    host.cell_583a29 = h_cell;
    switch (omit) {
    case 1: host.player_state = NULL; break;
    case 2: host.player_name = NULL; break;
    case 3: host.player_hotspot = NULL; break;
    case 4: host.player_origin = NULL; break;
    case 5: host.open_iv = NULL; break;
    case 6: host.read = NULL; break;
    case 7: host.close = NULL; break;
    case 8: host.alloc_slot = NULL; break;
    case 9: host.register_slot = NULL; break;
    case 10: host.release_slot = NULL; break;
    default: host.cell_583a29 = NULL; break;
    }
    return c1c_visit(&o, body, 0u, &host, &out);
}

/* A row of another raw type handed to the binding. */
int a1co_wrong_type(Handle *h, int type, const uint8_t *raw_body, size_t raw_length)
{
    SceneActionInfo info;
    SceneActionRuntimeState before;
    SceneActionHandlerResult out;
    memset(&info, 0, sizeof info);
    memset(&before, 0, sizeof before);
    memset(&out, 0, sizeof out);
    info.type = (uint8_t)type;
    info.raw_body = raw_body;
    info.raw_body_length = raw_length;
    return session_a1c_handler(h->binding, 0u, &info, &before, &out);
}

/* The accessors on a NULL binding: returns 0 when they behave. */
int a1co_accessors_null(void)
{
    if (session_a1c_object(NULL) != NULL) return 1;
    if (session_a1c_visits(NULL) != 0ul) return 2;
    if (strcmp(session_a1c_failure(NULL), "invalid binding") != 0) return 3;
    session_a1c_destroy(NULL);
    c1c_free_iv(NULL);
    c1c_object_reset(NULL);
    return 0;
}

/* render with capacity 0 and a NULL fills array is legal. */
int a1co_render_cap0(Handle *h, size_t *count)
{
    return session_a1c_render(h->binding, 0, 0, NULL, 0u, count);
}

static void fill_host(Handle *h, C1cHost *host)
{
    host->context = h;
    host->player_state = h_state;
    host->player_name = h_name;
    host->player_hotspot = h_hotspot;
    host->player_origin = h_origin;
    host->open_iv = h_open;
    host->read = h_read;
    host->close = h_close;
    host->alloc_slot = h_alloc;
    host->register_slot = h_register;
    host->release_slot = h_release;
    host->cell_583a29 = h_cell;
}

/* Phase 0 on a body of exactly C1C_BODY_BYTES bytes without a NUL, in a heap block of exactly that size: a name scan that reads one
 * byte further is caught by the address sanitizer. Returns the kernel status (C1C_ERR_FILE expected). */
int a1co_kernel_unterminated(Handle *h)
{
    C1cObject o;
    C1cOutcome out;
    C1cHost host;
    uint8_t *body = (uint8_t *)malloc(C1C_BODY_BYTES);
    int status;
    if (body == NULL) return -1;
    memset(body, 0x41, C1C_BODY_BYTES);
    fill_host(h, &host);
    c1c_object_reset(&o);
    status = c1c_visit(&o, body, 0u, &host, &out);
    c1c_free_iv(&o);
    free(body);
    return status;
}

/* c1c_free_iv leaves no dangling record: returns 0 when iv and record are NULL afterwards. */
int a1co_free_iv_record(void)
{
    C1cObject o;
    c1c_object_reset(&o);
    o.iv = (C1cIv *)calloc(1u, sizeof(*o.iv));
    if (o.iv == NULL) return -1;
    o.iv->count = 1;
    o.iv->entries = (C1cEntry *)calloc(2u, sizeof(C1cEntry));
    if (o.iv->entries == NULL) return -1;
    o.iv->entries[0].count = 1;
    o.iv->entries[0].rects = (C1cRect *)calloc(1u, sizeof(C1cRect));
    o.record = &o.iv->entries[0];
    c1c_free_iv(&o);
    return o.iv == NULL && o.record == NULL ? 0 : 1;
}
