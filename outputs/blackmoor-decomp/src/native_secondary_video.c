#define _XOPEN_SOURCE 700
#include "native_secondary_video.h"
#include "avf_decoder.h"

#include <dirent.h>
#include <errno.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

/* NATIVE-23: native resources for the already-recovered A33 controller.
 * Original 0x44cde2..0x44cf01 SHA256:
 * 9214383339341af5d603e5c4481117f7830ce587c50391d1263e8eb3e89dd563.
 * REA ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0.
 * Original0x42e72c selects the slot; this adapter never chooses a page/frame. */
#define SECONDARY_MAX_FILE (UINT64_C(256) * 1024u * 1024u)
#define SECONDARY_MAX_DIMENSION 4096
#define SECONDARY_HANDLE_FIRST UINT32_C(0x33000001)
#define SECONDARY_HANDLE_LAST UINT32_C(0x33ffffff)

typedef struct SecondaryStream {
    uint8_t *bytes, *slots[2], *scratch;
    AvfFile file;
    AvfStream decoder;
    AvfLzssState lzss;
    uint32_t handles[2];
    uint8_t retired[2], decoded[2];
    int16_t frame[2];
    size_t result_bytes[2];
} SecondaryStream;

struct NativeSecondaryVideo {
    char *directory;
    SecondaryStream stream;
    uint32_t next_handle, surface, thread;
    uint64_t generation;
    int visible_slot, ready, runnable, parked, handshake, registered, failed;
    char failure[384];
};

static int fail(NativeSecondaryVideo *m, const char *format, ...)
{
    if (m != NULL) {
        va_list args;
        va_start(args, format);
        (void)vsnprintf(m->failure, sizeof(m->failure), format, args);
        va_end(args);
    }
    return 1;
}

const char *native_secondary_video_failure(const NativeSecondaryVideo *m)
{
    return m == NULL ? "secondary-video owner unavailable" : m->failure;
}

static unsigned char lower_ascii(unsigned char c)
{
    return c >= 'A' && c <= 'Z' ? (unsigned char)(c + ('a' - 'A')) : c;
}

static int equal_ascii(const char *a, const char *b)
{
    while (*a && *b) {
        if (lower_ascii((unsigned char)*a++) != lower_ascii((unsigned char)*b++)) return 0;
    }
    return *a == *b;
}

static int valid_name(const char *name)
{
    if (name == NULL) return 0;
    for (size_t i = 0; i < A33_NAME_BYTES; ++i) {
        unsigned char c = (unsigned char)name[i];
        if (c == 0) return i != 0 && name[0] != '.' && name[i - 1] != '.' && name[i - 1] != ' ';
        if (c < 32 || c >= 127 || strchr("<>:\"/\\|?*", c) != NULL) return 0;
    }
    return 0;
}

static char *join(const char *a, const char *b)
{
    size_t n = strlen(a), k = strlen(b);
    if (n > 4096 || k > 4096 || n + k + 2 > 4096) return NULL;
    char *p = malloc(n + k + 2);
    if (p != NULL) (void)snprintf(p, n + k + 2, "%s/%s", a, b);
    return p;
}

/* A missing tier is allowed; ambiguity or an unreadable tier is not. */
static int component(NativeSecondaryVideo *m, const char *parent, const char *name,
    int directory, char **out)
{
    *out = NULL;
    DIR *d = opendir(parent);
    if (d == NULL) {
        if (errno == ENOENT || errno == ENOTDIR) return 0;
        return fail(m, "cannot read AVF directory: %s", strerror(errno));
    }
    int error = 0;
    for (;;) {
        errno = 0;
        struct dirent *e = readdir(d);
        if (e == NULL) { error = errno; break; }
        if (!equal_ascii(e->d_name, name)) continue;
        char *p = join(parent, e->d_name);
        struct stat info;
        if (p == NULL || stat(p, &info) != 0) {
            free(p); error = errno != 0 ? errno : ENOMEM; break;
        }
        if (!(directory ? S_ISDIR(info.st_mode) : S_ISREG(info.st_mode))) { free(p); continue; }
        if (*out != NULL) {
            free(p); free(*out); *out = NULL; (void)closedir(d);
            return fail(m, "ambiguous Windows-case AVF component: %s", name);
        }
        *out = p;
    }
    if (closedir(d) != 0 && error == 0) error = errno;
    if (error != 0) { free(*out); *out = NULL; return fail(m, "cannot scan AVF directory: %s", strerror(error)); }
    return 0;
}

static int resolve(NativeSecondaryVideo *m, const char *name, char **out)
{
    *out = NULL;
    if (!valid_name(name)) return fail(m, "invalid AVF clip component");
    char filename[A33_NAME_BYTES + 4];
    (void)snprintf(filename, sizeof(filename), "%s.AVF", name);
    static const char *tiers[] = {"HDVideo", "CDVideo"};
    for (size_t i = 0; i < 2; ++i) {
        char *directory = NULL;
        if (component(m, m->directory, tiers[i], 1, &directory) != 0) return 1;
        if (directory == NULL) continue;
        int status = component(m, directory, filename, 0, out);
        free(directory);
        if (status != 0 || *out != NULL) return status;
    }
    return fail(m, "secondary AVF missing (Bink is unsupported): %s", name);
}

static int open_metadata(NativeSecondaryVideo *m, const char *name, uint8_t **bytes, AvfFile *file)
{
    char *path = NULL;
    *bytes = NULL;
    if (resolve(m, name, &path) != 0) return 1;
    struct stat info;
    if (stat(path, &info) != 0 || info.st_size <= 0 || (uint64_t)info.st_size > SECONDARY_MAX_FILE) {
        free(path); return fail(m, "secondary AVF file size unavailable or exceeds bound");
    }
    FILE *input = fopen(path, "rb");
    free(path);
    if (input == NULL) return fail(m, "cannot open secondary AVF");
    size_t size = (size_t)info.st_size;
    uint8_t *data = malloc(size);
    int read_ok = data != NULL && fread(data, 1, size, input) == size;
    int close_ok = fclose(input) == 0;
    if (!read_ok || !close_ok) { free(data); return fail(m, "cannot read secondary AVF"); }
    AvfStatus status = avf_open(data, size, file);
    if (status != AVF_OK) { free(data); return fail(m, "secondary AVF metadata: %s", avf_status_name(status)); }
    if (file->frame_count <= 0 || file->width > SECONDARY_MAX_DIMENSION || file->height > SECONDARY_MAX_DIMENSION ||
        file->compression != 2 || file->header_1c == 0 || file->header_1c > INT32_MAX) {
        free(data); return fail(m, "unsupported secondary AVF dimensions, compression or period");
    }
    for (int32_t i = 0; i < file->frame_count; ++i) {
        AvfRecord r;
        if (avf_record(file, i, &r) != AVF_OK || r.type != AVF_TYPE_KEY ||
            r.unpacked_bytes != file->frame_bytes || r.packed_bytes == 0 ||
            r.offset > size || r.packed_bytes > size - r.offset) {
            free(data); return fail(m, "unsupported secondary AVF record %d (full type0 keyframes required)", i);
        }
    }
    *bytes = data;
    return 0;
}

static void clear_stream(SecondaryStream *s)
{
    free(s->bytes); free(s->slots[0]); free(s->slots[1]); free(s->scratch);
    memset(s, 0, sizeof(*s));
}

static uint32_t handle(NativeSecondaryVideo *m)
{
    if (m->next_handle > SECONDARY_HANDLE_LAST) return 0;
    return m->next_handle++;
}

int native_secondary_video_create(const char *directory, NativeSecondaryVideo **out)
{
    if (out == NULL) return 1;
    *out = NULL;
    if (directory == NULL) return 1;
    char *resolved = realpath(directory, NULL);
    struct stat info;
    if (resolved == NULL || stat(resolved, &info) != 0 || !S_ISDIR(info.st_mode)) { free(resolved); return 1; }
    NativeSecondaryVideo *m = calloc(1, sizeof(*m));
    if (m == NULL) { free(resolved); return 1; }
    m->directory = resolved; m->next_handle = SECONDARY_HANDLE_FIRST;
    m->visible_slot = -1; m->parked = 1;
    (void)snprintf(m->failure, sizeof(m->failure), "none");
    *out = m;
    return 0;
}

void native_secondary_video_destroy(NativeSecondaryVideo *m)
{
    if (m == NULL) return;
    m->runnable = 0; /* no in-flight work exists between sequential calls */
    clear_stream(&m->stream);
    free(m->directory); free(m);
}

int native_secondary_video_validate_set(NativeSecondaryVideo *m, const A33Set *set)
{
    if (m == NULL || set == NULL) return fail(m, "secondary preflight argument");
    if (set->kind_46 != 1 || set->w44 != 2 || set->anim_48 != 1 || set->w4a != 2)
        return fail(m, "unsupported secondary-video kind/present/animation/mode");
    uint8_t *bytes = NULL;
    AvfFile file;
    if (open_metadata(m, set->clip, &bytes, &file) != 0) return 1;
    const int16_t ranges[] = {set->w4c, set->w4e, set->w50, set->w52, set->w54, set->w56};
    int valid = ranges[0] <= ranges[1] && ranges[2] <= ranges[3] && ranges[4] <= ranges[5];
    for (size_t i = 0; i < 6; ++i) valid = valid && ranges[i] >= 0 && ranges[i] < file.frame_count;
    free(bytes);
    return valid ? 0 : fail(m, "secondary frame range outside AVF");
}

static int reset_stream(NativeSecondaryVideo *m, const A33State *state)
{
    if (m->thread != 0 || m->surface != 0 || m->runnable)
        return fail(m, "secondary stream reset before reader/surface retirement");
    if (state->kind_5b4e8b != 1 || state->present_5b4e04 != 2)
        return fail(m, "unsupported secondary stream kind/present");
    SecondaryStream fresh = {0};
    if (open_metadata(m, state->clip_5b4d8f, &fresh.bytes, &fresh.file) != 0) return 1;
    fresh.slots[0] = calloc(1, fresh.file.frame_bytes);
    fresh.slots[1] = calloc(1, fresh.file.frame_bytes);
    fresh.scratch = malloc(fresh.file.max_unpacked);
    if (fresh.slots[0] == NULL || fresh.slots[1] == NULL || fresh.scratch == NULL ||
        m->next_handle > SECONDARY_HANDLE_LAST - 1u) {
        clear_stream(&fresh); return fail(m, "secondary decode storage or handle allocation");
    }
    fresh.handles[0] = handle(m); fresh.handles[1] = handle(m);
    clear_stream(&m->stream);
    m->stream = fresh;
    AvfStatus status = avf_stream_init(&m->stream.decoder, &m->stream.file,
        m->stream.slots[0], m->stream.slots[1], m->stream.file.frame_bytes,
        m->stream.scratch, m->stream.file.max_unpacked, NULL, NULL);
    if (status != AVF_OK) { clear_stream(&m->stream); return fail(m, "secondary stream init: %s", avf_status_name(status)); }
    m->ready = 0; m->visible_slot = -1; m->parked = 1;
    m->registered = 1; m->failed = 0; m->handshake = 0;
    return 0;
}

int native_secondary_video_op(NativeSecondaryVideo *m, const A33State *state,
    int opcode, const A33OpArgs *args, int32_t *ret)
{
    if (m == NULL || state == NULL || args == NULL || ret == NULL) return fail(m, "secondary op argument");
    *ret = 0;
    switch (opcode) {
    case A33_OP_STREAM_LOCK:
        if (m->handshake != 2) m->handshake = 1;
        *ret = m->handshake; return 0;
    case A33_OP_STREAM_UNLOCK:
        if (m->handshake != 2) m->handshake = 0;
        return 0;
    case A33_OP_THREAD_STOP:
        if ((uint32_t)args->a != m->thread || m->thread == 0) break;
        m->runnable = 0; m->parked = 1; m->handshake = 2; return 0;
    case A33_OP_THREAD_DELETE:
        if ((uint32_t)args->a != m->thread || m->thread == 0 || m->runnable) break;
        m->thread = 0; return 0;
    case A33_OP_FREE:
        for (int i = 0; i < 2; ++i) if ((uint32_t)args->a == m->stream.handles[i] && args->a != 0 && !m->runnable) {
            m->stream.retired[i] = 1; return 0; /* defer actual free past borrowed surface lifetime */
        }
        break;
    case A33_OP_Z_UNREGISTER: m->registered = 0; return 0;
    case A33_OP_SURFACE_RELEASE:
        if (args->b != 0 || (uint32_t)args->a != m->surface || m->surface == 0) break;
        m->surface = 0; m->visible_slot = -1; m->parked = 1; return 0;
    case A33_OP_STREAM_RESET: return reset_stream(m, state);
    case A33_OP_SURFACE_CREATE:
        if (m->stream.bytes == NULL || m->surface != 0 || args->a != m->stream.file.width || args->b != m->stream.file.height) break;
        m->surface = handle(m); if (m->surface == 0) break;
        m->visible_slot = -1; *ret = (int32_t)m->surface; return 0;
    case A33_OP_THREAD_CREATE:
        if (m->stream.bytes == NULL || m->surface == 0 || m->thread != 0) break;
        m->thread = handle(m); if (m->thread == 0) break;
        m->runnable = 0; m->parked = 1; *ret = (int32_t)m->thread; return 0;
    case A33_OP_THREAD_RESUME:
        if ((uint32_t)args->a != m->thread || m->thread == 0 || m->surface == 0 || m->failed) break;
        m->runnable = 1; m->parked = 0; m->handshake = 0; return 0;
    case A33_OP_SURFACE_PIXELS:
        if ((uint32_t)args->a != m->surface || m->surface == 0 || !m->ready) break;
        for (int i = 0; i < 2; ++i) if ((uint32_t)args->b == m->stream.handles[i] &&
            !m->stream.retired[i] && m->stream.decoded[i]) {
            m->visible_slot = i; ++m->generation; return 0;
        }
        break;
    default: return fail(m, "unsupported secondary media op %d", opcode);
    }
    return fail(m, "secondary media op %d in invalid lifecycle/handle state", opcode);
}

int native_secondary_video_load_world(NativeSecondaryVideo *m, A33State *state)
{
    if (m == NULL || state == NULL) return fail(m, "secondary load argument");
    int open = m->stream.bytes != NULL;
    state->ready_5b4e0a = (int16_t)m->ready;
    state->delay_5b4c5a = open ? (int32_t)m->stream.file.header_1c : 0;
    state->buf_5b4db8 = m->stream.retired[0] ? 0 : m->stream.handles[0];
    state->buf_5b4dbc = m->stream.retired[1] ? 0 : m->stream.handles[1];
    state->flags_5b4dc0 = state->flags_5b4dc2 = 0;
    state->vrect_5b4de8 = state->vrect_5b4dec = 0;
    state->vrect_5b4df0 = open ? m->stream.file.width - 1 : 0;
    state->vrect_5b4df4 = open ? m->stream.file.height - 1 : 0;
    state->w_5b4e02 = open ? 1 : 0;
    return 0;
}

int native_secondary_video_store_world(NativeSecondaryVideo *m, const A33State *state)
{
    if (m == NULL || state == NULL) return fail(m, "secondary store argument");
    if (state->ready_5b4e0a != 0 && !m->ready) return fail(m, "secondary ready published without decode");
    if (state->ready_5b4e0a == 0) m->ready = 0;
    m->parked = state->active_5c39f1 == 0 || state->row_5b4e89 < 0 || m->surface == 0;
    return 0;
}

int native_secondary_video_reader_pass(NativeSecondaryVideo *m, const A33State *state, int *ran)
{
    if (ran != NULL) *ran = 0;
    if (m == NULL || state == NULL) return fail(m, "secondary reader argument");
    if (m->failed) return fail(m, "secondary decoder is terminally failed");
    if (!m->runnable || m->parked || m->ready || m->surface == 0 ||
        state->active_5c39f1 == 0 || state->row_5b4e89 < 0 || m->handshake == 2) return 0;
    int slot = state->page_5b4dc8 == 0 ? 1 : 0;
    if (slot == m->visible_slot || m->stream.retired[slot] || m->stream.bytes == NULL)
        return fail(m, "secondary reader target is not an owned hidden slot");
    const uint8_t *result = NULL;
    size_t bytes = 0;
    m->handshake = 1;
    AvfStatus status = avf_get_chunk(&m->stream.decoder, state->frame_5b4e00,
        m->stream.slots[slot], m->stream.file.frame_bytes, NULL, 0, 0, NULL,
        &result, &bytes, &m->stream.lzss);
    m->handshake = 0;
    if (status != AVF_OK || result != m->stream.slots[slot] || bytes != m->stream.file.frame_bytes) {
        m->failed = 1;
        return fail(m, "secondary AVF frame %d decode: %s", state->frame_5b4e00, avf_status_name(status));
    }
    m->stream.decoded[slot] = 1; m->stream.frame[slot] = state->frame_5b4e00;
    m->stream.result_bytes[slot] = bytes;
    m->ready = 1; /* original publishes R after releasing H */
    if (ran != NULL) *ran = 1;
    return 0;
}

int native_secondary_video_frame(NativeSecondaryVideo *m, uint32_t surface, NativeSecondaryVideoFrame *frame)
{
    if (m == NULL || frame == NULL) return fail(m, "secondary frame argument");
    if (surface == 0 || surface != m->surface || m->visible_slot < 0)
        return fail(m, "secondary surface has no visible decoded frame");
    int slot = m->visible_slot;
    NativeSecondaryVideoFrame value = {m->stream.slots[slot], m->stream.result_bytes[slot],
        (uint32_t)m->stream.file.width, (uint32_t)m->stream.file.height,
        (uint32_t)m->stream.file.width * 2u, m->generation, m->stream.frame[slot]};
    *frame = value;
    return 0;
}
