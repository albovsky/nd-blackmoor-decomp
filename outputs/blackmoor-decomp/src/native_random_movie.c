#include "native_random_movie.h"

#include "bink_player.h"

#include <dirent.h>
#include <errno.h>
#include <limits.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

#include <libavcodec/codec_id.h>
#include <libavformat/avformat.h>
#include <libavutil/dict.h>
#include <libavutil/error.h>

#define MOVIE_MAX_PATH 4096u
#define MOVIE_MAX_DIMENSION 4096u
#define MOVIE_MAX_FRAMES 32768u
#define MOVIE_MAX_FILE_BYTES (INT64_C(256) * 1024 * 1024)

typedef struct MovieInfo {
    uint32_t width, height, frames, period_ms;
} MovieInfo;

struct NativeRandomMovie {
    char *directory;
    NativeRandomMovieHost host;
    BinkPlayer *player;
    MovieInfo info;
    uint32_t next_handle, player_handle, surface_handle;
    uint8_t *pixels;
    size_t pixel_bytes;
    uint32_t width, height, stride;
    uint64_t generation;
    int32_t current_frame;
    BinkPlayerFrame staged_frame;
    int staged, decoded, has_frame;
    char failure[384];
};

static int fail(NativeRandomMovie *m, const char *format, ...)
{
    va_list args;
    if (m != NULL) {
        va_start(args, format);
        (void)vsnprintf(m->failure, sizeof(m->failure), format, args);
        va_end(args);
    }
    return 1;
}

const char *native_random_movie_failure(const NativeRandomMovie *m)
{
    return m == NULL ? "random-movie provider unavailable" : m->failure;
}

static unsigned char ascii_lower(unsigned char c)
{
    return c >= 'A' && c <= 'Z' ? (unsigned char)(c + ('a' - 'A')) : c;
}

static int ascii_equal(const char *a, const char *b)
{
    while (*a != '\0' && *b != '\0') {
        if (ascii_lower((unsigned char)*a) != ascii_lower((unsigned char)*b)) return 0;
        ++a;
        ++b;
    }
    return *a == *b;
}

/* Names are 33-byte typed-body fields, not paths. Reject Windows-unsafe
 * components, traversal, control/non-ASCII characters and truncated names. */
static int name_valid(const char *name)
{
    size_t n;
    if (name == NULL) return 0;
    for (n = 0u; n < D2_NAME_BYTES; ++n) {
        unsigned char c = (unsigned char)name[n];
        if (c == 0u) {
            return n > 0u && name[0] != '.' && name[n - 1u] != '.' && name[n - 1u] != ' ';
        }
        if (c < 32u || c >= 127u || strchr("<>:\"/\\|?*", c) != NULL) return 0;
    }
    return 0;
}

static char *join_path(const char *directory, const char *name)
{
    size_t a = strlen(directory), b = strlen(name);
    char *path;
    if (a >= MOVIE_MAX_PATH || b >= MOVIE_MAX_PATH || a + b + 2u > MOVIE_MAX_PATH) return NULL;
    path = malloc(a + b + 2u);
    if (path != NULL) (void)snprintf(path, a + b + 2u, "%s/%s", directory, name);
    return path;
}

/* Return 0 for a unique match or absence (*out == NULL), 1 for a diagnostic
 * failure. Each priority tier is independent: an HD and CD copy is allowed. */
static int find_component(NativeRandomMovie *m, const char *directory,
    const char *name, int is_directory, char **out)
{
    DIR *dir;
    struct dirent *entry;
    char *match = NULL;
    int read_error = 0;
    *out = NULL;
    dir = opendir(directory);
    if (dir == NULL) {
        if (errno == ENOENT || errno == ENOTDIR) return 0;
        return fail(m, "cannot read movie directory: %s", strerror(errno));
    }
    for (;;) {
        char *candidate;
        struct stat info;
        errno = 0;
        entry = readdir(dir);
        if (entry == NULL) { read_error = errno; break; }
        if (!ascii_equal(entry->d_name, name)) continue;
        candidate = join_path(directory, entry->d_name);
        if (candidate == NULL) {
            free(match);
            (void)closedir(dir);
            return fail(m, "movie path exceeds bound or cannot be allocated");
        }
        if (stat(candidate, &info) != 0) {
            int saved = errno;
            free(candidate);
            free(match);
            (void)closedir(dir);
            return fail(m, "cannot inspect movie path: %s", strerror(saved));
        }
        if (!(is_directory ? S_ISDIR(info.st_mode) : S_ISREG(info.st_mode))) {
            free(candidate);
            continue;
        }
        if (match != NULL) {
            free(candidate);
            free(match);
            (void)closedir(dir);
            return fail(m, "ambiguous ASCII-case movie path component: %s", name);
        }
        match = candidate;
    }
    if (closedir(dir) != 0 && read_error == 0) read_error = errno;
    if (read_error != 0) {
        free(match);
        return fail(m, "cannot scan movie directory: %s", strerror(read_error));
    }
    *out = match;
    return 0;
}

static int resolve_variant(NativeRandomMovie *m, const char *name, int variant, char **out)
{
    char file[D2_NAME_BYTES + 4u];
    char *directory = NULL;
    int status;
    *out = NULL;
    if (!name_valid(name) || variant < 0 || variant > 3)
        return fail(m, "invalid movie name or file-probe variant");
    status = find_component(m, m->directory, (variant & 1) == 0 ? "HDVideo" : "CDVideo", 1, &directory);
    if (status != 0 || directory == NULL) return status;
    (void)snprintf(file, sizeof(file), "%s.%s", name, variant < 2 ? "BIK" : "AVF");
    status = find_component(m, directory, file, 0, out);
    free(directory);
    return status;
}

static int resolve_movie(NativeRandomMovie *m, const char *name, char **out, int *variant)
{
    *out = NULL;
    for (*variant = 0; *variant < 4; ++*variant) {
        if (resolve_variant(m, name, *variant, out) != 0) return 1;
        if (*out != NULL) return 0;
    }
    return fail(m, "movie asset missing: %s", name);
}

/* The Bink demuxer reads the complete header in open_input. It exposes the
 * container frame count as stream duration, in a one-frame time base (not
 * nb_frames). See FFmpeg libavformat/bink.c read_header. Dimensions, count,
 * rate and soundtrack streams need neither find_stream_info (which may
 * decode) nor opening all 49 timed players. */
static int probe_movie(NativeRandomMovie *m, const char *path, MovieInfo *out)
{
    AVFormatContext *format = NULL;
    AVDictionary *options = NULL;
    const AVInputFormat *bink = av_find_input_format("bink");
    AVStream *video = NULL;
    struct stat info;
    AVRational rate;
    char error[AV_ERROR_MAX_STRING_SIZE];
    uint64_t period;
    int result, status = 1;
    if (stat(path, &info) != 0 || !S_ISREG(info.st_mode))
        return fail(m, "movie input is not a readable regular local file");
    if (info.st_size <= 0 || (int64_t)info.st_size > MOVIE_MAX_FILE_BYTES)
        return fail(m, "movie input exceeds 1..256 MiB file bound");
    if (bink == NULL) return fail(m, "FFmpeg Bink demuxer unavailable");
    format = avformat_alloc_context();
    if (format == NULL) return fail(m, "cannot allocate movie metadata probe");
    format->max_streams = 16;
    if (av_dict_set(&options, "protocol_whitelist", "file", 0) < 0) {
        fail(m, "cannot configure file-only movie probe");
        goto done;
    }
    result = avformat_open_input(&format, path, bink, &options);
    if (result < 0) {
        if (av_strerror(result, error, sizeof(error)) < 0) (void)snprintf(error, sizeof(error), "error %d", result);
        fail(m, "cannot probe Bink movie: %s", error);
        goto done;
    }
    for (unsigned int i = 0u; i < format->nb_streams; ++i) {
        AVStream *stream = format->streams[i];
        if (stream->codecpar->codec_type == AVMEDIA_TYPE_AUDIO) {
            fail(m, "random-movie soundtracks are unsupported (silent Bink only)");
            goto done;
        }
        if (stream->codecpar->codec_type != AVMEDIA_TYPE_VIDEO || video != NULL ||
            stream->codecpar->codec_id != AV_CODEC_ID_BINKVIDEO) {
            fail(m, "movie must contain exactly one Bink video stream");
            goto done;
        }
        video = stream;
    }
    if (video == NULL || video->codecpar->width <= 0 || video->codecpar->height <= 0 ||
        video->codecpar->width > (int)MOVIE_MAX_DIMENSION || video->codecpar->height > (int)MOVIE_MAX_DIMENSION ||
        video->duration <= 0 || video->duration > MOVIE_MAX_FRAMES) {
        fail(m, "movie dimensions/frame count exceed 4096x4096 / 32768 bounds");
        goto done;
    }
    if ((video->codecpar->codec_tag & UINT32_C(0xffffff)) !=
            ((uint32_t)'B' | ((uint32_t)'I' << 8) | ((uint32_t)'K' << 16)) ||
        (video->codecpar->codec_tag >> 24) == 0u ||
        strchr("bfghik", (int)(video->codecpar->codec_tag >> 24)) == NULL) {
        fail(m, "unsupported Bink container signature/revision");
        goto done;
    }
    rate = video->avg_frame_rate;
    if (rate.num <= 0 || rate.den <= 0) rate = video->r_frame_rate;
    if (rate.num <= 0 || rate.den <= 0) {
        rate.num = video->time_base.den;
        rate.den = video->time_base.num;
    }
    if (rate.num <= 0 || rate.den <= 0 || video->time_base.num <= 0 || video->time_base.den <= 0) {
        fail(m, "movie has no usable frame rate/time base");
        goto done;
    }
    /* Only AVF uses this kernel field. Report whole milliseconds for Bink
     * metadata; Bink pacing uses its actual nanosecond source timestamps. */
    period = UINT64_C(1000) * (uint32_t)rate.den / (uint32_t)rate.num;
    if (period == 0u || period > UINT32_MAX) {
        fail(m, "movie frame period exceeds millisecond metadata range");
        goto done;
    }
    out->width = (uint32_t)video->codecpar->width;
    out->height = (uint32_t)video->codecpar->height;
    out->frames = (uint32_t)video->duration;
    out->period_ms = (uint32_t)period;
    status = 0;
done:
    av_dict_free(&options);
    avformat_close_input(&format);
    return status;
}

int native_random_movie_create(const char *directory,
    const NativeRandomMovieHost *host, NativeRandomMovie **out)
{
    NativeRandomMovie *m;
    struct stat info;
    size_t length = 0u;
    if (out != NULL) *out = NULL;
    if (out == NULL || directory == NULL || directory[0] != '/' || host == NULL ||
        host->clock_ns == NULL || host->tick_ms == NULL || host->next_random == NULL) return 1;
    while (length < MOVIE_MAX_PATH && directory[length] != '\0') ++length;
    if (length == MOVIE_MAX_PATH || stat(directory, &info) != 0 || !S_ISDIR(info.st_mode)) return 1;
    m = calloc(1u, sizeof(*m));
    if (m == NULL) return 1;
    m->directory = malloc(length + 1u);
    if (m->directory == NULL) { free(m); return 1; }
    memcpy(m->directory, directory, length + 1u);
    m->host = *host;
    m->next_handle = 1u;
    m->current_frame = -1;
    (void)snprintf(m->failure, sizeof(m->failure), "none");
    *out = m;
    return 0;
}

void native_random_movie_destroy(NativeRandomMovie *m)
{
    if (m == NULL) return;
    bink_player_close(m->player);
    free(m->pixels);
    free(m->directory);
    free(m);
}

int native_random_movie_validate_set(NativeRandomMovie *m, const D2Set *set)
{
    uint32_t width = 0u, height = 0u;
    if (m == NULL || set == NULL) return fail(m, "movie set argument unavailable");
    if (set->entry_count <= 0 || set->entries == NULL || set->group_count < 0 ||
        (set->group_count > 0 && set->groups == NULL) || memchr(set->name, 0, D2_NAME_BYTES) == NULL)
        return fail(m, "invalid random-movie set");
    for (int i = 0; i < set->entry_count; ++i) {
        const D2Entry *entry = &set->entries[i];
        MovieInfo info;
        char *path = NULL;
        int variant;
        if (resolve_movie(m, entry->name, &path, &variant) != 0) return 1;
        if (variant >= 2) {
            free(path);
            return fail(m, "AVF random movies are unsupported (silent Bink only)");
        }
        if (probe_movie(m, path, &info) != 0) { free(path); return 1; }
        free(path);
        if (entry->word_21 < 0 || entry->word_23 < entry->word_21 || (uint32_t)entry->word_23 >= info.frames)
            return fail(m, "movie entry frame bounds exceed its container: %s", entry->name);
        if (i != 0 && (width != info.width || height != info.height))
            return fail(m, "movie set changes dimensions of its retained surface");
        width = info.width;
        height = info.height;
    }
    (void)snprintf(m->failure, sizeof(m->failure), "none");
    return 0;
}

static int allocate_handle(NativeRandomMovie *m, uint32_t *out)
{
    if (m->next_handle > INT32_MAX) return fail(m, "movie opaque handle range exhausted");
    *out = m->next_handle++;
    return 0;
}

static void clear_staging(NativeRandomMovie *m)
{
    memset(&m->staged_frame, 0, sizeof(m->staged_frame));
    m->staged = m->decoded = 0;
}

static int stream_reset(NativeRandomMovie *m, const D2Object *state)
{
    BinkPlayer *player = NULL;
    BinkPlayerInfo decoded_info;
    MovieInfo info;
    char *path = NULL;
    char error[256] = "";
    uint32_t handle;
    int variant, status;
    if (state == NULL || state->kind_21a != 1) return fail(m, "AVF stream reset is unsupported");
    if (m->player != NULL) return fail(m, "movie stream reset requires prior Bink release");
    if (resolve_movie(m, state->name_159, &path, &variant) != 0) return 1;
    if (variant >= 2) { free(path); return fail(m, "AVF stream reset is unsupported"); }
    if (probe_movie(m, path, &info) != 0) { free(path); return 1; }
    status = bink_player_open(path, &player, &decoded_info, error, sizeof(error));
    free(path);
    if (status != BINK_PLAYER_OK) return fail(m, "Bink open status=%d: %s", status, error);
    if (decoded_info.width != info.width || decoded_info.height != info.height || decoded_info.total_frames != info.frames) {
        bink_player_close(player);
        return fail(m, "decoded Bink dimensions/frame count differ from preflight metadata");
    }
    if (allocate_handle(m, &handle) != 0) { bink_player_close(player); return 1; }
    m->player = player;
    m->player_handle = handle;
    m->info = info;
    clear_staging(m);
    return 0;
}

static int player_required(NativeRandomMovie *m, int32_t handle)
{
    if (m->player == NULL || handle <= 0 || (uint32_t)handle != m->player_handle)
        return fail(m, "invalid or absent Bink player handle");
    return 0;
}

static int surface_create(NativeRandomMovie *m, const D2OpArgs *a, int32_t *ret)
{
    uint8_t *pixels;
    uint32_t handle, stride;
    size_t bytes;
    if (m->surface_handle != 0u || m->player == NULL || a->a <= 0 || a->b <= 0 ||
        (uint32_t)a->a > MOVIE_MAX_DIMENSION || (uint32_t)a->b > MOVIE_MAX_DIMENSION ||
        (uint32_t)a->a != m->info.width || (uint32_t)a->b != m->info.height || a->c != 8 || a->d != 1)
        return fail(m, "unsupported movie surface request (Bink RGBA, maximum 4096x4096)");
    stride = (uint32_t)a->a * 4u;
    bytes = (size_t)stride * (uint32_t)a->b;
    pixels = calloc(1u, bytes);
    if (pixels == NULL) return fail(m, "cannot allocate retained movie surface");
    if (allocate_handle(m, &handle) != 0) { free(pixels); return 1; }
    m->pixels = pixels;
    m->pixel_bytes = bytes;
    m->width = (uint32_t)a->a;
    m->height = (uint32_t)a->b;
    m->stride = stride;
    m->surface_handle = handle;
    m->has_frame = 0;
    m->current_frame = -1;
    *ret = (int32_t)handle;
    return 0;
}

int native_random_movie_op(NativeRandomMovie *m, const D2Object *state,
    int op, const D2OpArgs *args, int32_t *ret)
{
    const D2OpArgs none = { 0, 0, 0, 0, NULL };
    int32_t ignored = 0;
    char error[256] = "";
    int status;
    if (m == NULL) return 1;
    if (args == NULL) args = &none;
    if (ret == NULL) ret = &ignored;
    *ret = 0;
    switch (op) {
    case D2_OP_RAND: {
        uint32_t value;
        if (m->host.next_random(m->host.context, &value) != 0) return fail(m, "canonical movie RNG failed");
        memcpy(ret, &value, sizeof(value));
        return 0;
    }
    case D2_OP_TICK: {
        uint32_t value = m->host.tick_ms(m->host.context);
        memcpy(ret, &value, sizeof(value));
        return 0;
    }
    case D2_OP_FILE_EXISTS: {
        char *path = NULL;
        if (resolve_variant(m, args->name, args->a, &path) != 0) return 1;
        *ret = path != NULL;
        free(path);
        return 0;
    }
    case D2_OP_Z_UNREGISTER_A:
    case D2_OP_Z_UNREGISTER_B:
        /* Silent Bink never registers an AVF decoder/buffer-ring owner. */
        return 0;
    case D2_OP_BINK_RELEASE:
        if (m->player == NULL) {
            if (args->a != 0) return fail(m, "release of an absent Bink player handle");
            return 0;
        }
        if (player_required(m, args->a) != 0) return 1;
        clear_staging(m);
        bink_player_close(m->player);
        m->player = NULL;
        m->player_handle = 0u;
        memset(&m->info, 0, sizeof(m->info));
        /* Keep the independent surface and its last copied frame for idle. */
        return 0;
    case D2_OP_SURFACE_RELEASE:
        if (args->a == 0 && m->surface_handle == 0u) return 0;
        if (args->a <= 0 || (uint32_t)args->a != m->surface_handle)
            return fail(m, "invalid movie surface release handle");
        free(m->pixels);
        m->pixels = NULL;
        m->pixel_bytes = 0u;
        m->surface_handle = 0u;
        m->width = m->height = m->stride = 0u;
        m->has_frame = 0;
        m->current_frame = -1;
        return 0;
    case D2_OP_STREAM_RESET:
        return stream_reset(m, state);
    case D2_OP_SURFACE_CREATE:
        return surface_create(m, args, ret);
    case D2_OP_BINK_OPEN:
        if (player_required(m, args->a) != 0) return 1;
        status = bink_player_set_mode(m->player, 0, m->host.clock_ns(m->host.context), error, sizeof(error));
        if (status != BINK_PLAYER_OK) return fail(m, "Bink mode status=%d: %s", status, error);
        clear_staging(m);
        return 0; /* Original set-mode result: zero succeeds. */
    case D2_OP_BINK_PREPARE:
        if (player_required(m, args->a) != 0) return 1;
        if (args->b <= 0) return fail(m, "Bink seek requires a one-based positive frame");
        status = bink_player_seek(m->player, (uint32_t)args->b, m->host.clock_ns(m->host.context), error, sizeof(error));
        if (status != BINK_PLAYER_OK) return fail(m, "Bink seek status=%d: %s", status, error);
        clear_staging(m);
        *ret = 1;
        return 0;
    case D2_OP_BINK_READY:
        if (player_required(m, args->a) != 0) return 1;
        if (m->staged) { *ret = 1; return 0; }
        /* BinkWait stages privately; only DoFrame followed by BLIT publishes
         * the frame. NOT_DUE cannot change any retained surface pixel. */
        status = bink_player_advance(m->player, m->host.clock_ns(m->host.context), &m->staged_frame, error, sizeof(error));
        if (status == BINK_PLAYER_NOT_DUE) return 0;
        if (status != BINK_PLAYER_OK) return fail(m, "Bink readiness status=%d: %s", status, error);
        m->staged = 1;
        *ret = 1;
        return 0;
    case D2_OP_BINK_NEXT: /* Historical name: 0x4befc8 is BinkDoFrame. */
        if (player_required(m, args->a) != 0) return 1;
        if (!m->staged || m->decoded) return fail(m, "Bink DoFrame requires one staged, undecoded frame");
        m->decoded = 1;
        return 0;
    case D2_OP_BINK_BLIT:
        if (player_required(m, args->a) != 0) return 1;
        if (!m->decoded || args->b <= 0 || (uint32_t)args->b != m->surface_handle ||
            m->staged_frame.rgba == NULL || m->staged_frame.width != m->width ||
            m->staged_frame.height != m->height || m->staged_frame.stride != m->stride ||
            m->staged_frame.rgba_bytes != m->pixel_bytes || m->staged_frame.current_frame < 0 ||
            m->staged_frame.current_frame > INT16_MAX || m->generation == UINT64_MAX)
            return fail(m, "Bink BLIT requires a decoded frame and matching owned surface");
        memcpy(m->pixels, m->staged_frame.rgba, m->pixel_bytes);
        m->current_frame = m->staged_frame.current_frame;
        ++m->generation;
        m->has_frame = 1;
        return 0;
    case D2_OP_BINK_FRAME:
        if (player_required(m, args->a) != 0) return 1;
        if (!m->decoded) return fail(m, "Bink frame query requires DoFrame");
        *ret = m->staged_frame.current_frame + 1;
        return 0;
    case D2_OP_BINK_MORE:
        if (player_required(m, args->a) != 0) return 1;
        if (!m->decoded) return fail(m, "Bink NextFrame requires DoFrame");
        *ret = !m->staged_frame.is_terminal;
        clear_staging(m); /* Consume only; READY stages the next due frame. */
        return 0;
    default:
        return fail(m, "unsupported random-movie media op %d (AVF/thread/frame-copy unavailable)", op);
    }
}

int native_random_movie_load_stream(NativeRandomMovie *m, D2Object *state)
{
    if (m == NULL || state == NULL) return fail(m, "movie stream metadata argument unavailable");
    state->period_24 = m->info.period_ms;
    /* Opaque native handles, never truncated pointers or AVF buffer addresses. */
    state->decoder_172 = (int32_t)m->player_handle;
    memset(state->buffers_182, 0, sizeof(state->buffers_182));
    state->bink_id_18e = (int32_t)m->player_handle;
    state->buffer_192 = 0;
    state->rect_1b2 = state->rect_1b6 = 0;
    state->rect_1ba = m->player == NULL ? 0 : (int32_t)m->info.width - 1;
    state->rect_1be = m->player == NULL ? 0 : (int32_t)m->info.height - 1;
    state->ready_1d4 = 0; /* Only the unsupported AVF thread owns this signal. */
    return 0;
}

int native_random_movie_surface_dims(NativeRandomMovie *m, uint32_t surface,
    int16_t *width, int16_t *height)
{
    if (m == NULL || surface == 0u || surface != m->surface_handle || width == NULL || height == NULL)
        return fail(m, "movie surface dimensions unavailable");
    *width = (int16_t)m->width;
    *height = (int16_t)m->height;
    return 0;
}

int native_random_movie_frame(NativeRandomMovie *m, uint32_t surface, NativeRandomMovieFrame *frame)
{
    if (frame != NULL) memset(frame, 0, sizeof(*frame));
    if (m == NULL || frame == NULL || surface == 0u || surface != m->surface_handle || !m->has_frame)
        return fail(m, "movie surface has no copied frame");
    frame->rgba = m->pixels;
    frame->rgba_bytes = m->pixel_bytes;
    frame->width = m->width;
    frame->height = m->height;
    frame->stride = m->stride;
    frame->generation = m->generation;
    frame->current_frame = m->current_frame;
    return 0;
}
