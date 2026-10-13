#include "bink_player.h"

#include "bink_adapter.h"

#include <errno.h>
#include <inttypes.h>
#include <limits.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libavutil/buffer.h>
#include <libavutil/dict.h>
#include <libavutil/error.h>
#include <libavutil/pixdesc.h>
#include <libavutil/rational.h>
#include <libswscale/swscale.h>

#define BINK_PLAYER_MAX_DIMENSION 4096
#define BINK_PLAYER_MAX_PIXELS \
    ((int64_t)BINK_PLAYER_MAX_DIMENSION * (int64_t)BINK_PLAYER_MAX_DIMENSION)
#define BINK_PLAYER_MAX_INPUT_BYTES (256LL * 1024LL * 1024LL)
#define BINK_PLAYER_MAX_STORED_BYTES (256ULL * 1024ULL * 1024ULL)
#define BINK_PLAYER_MAX_FRAMES 100000U
#define BINK_PLAYER_MAX_TRACKED_BUFFERS 1000000U
#define BINK_PLAYER_MAX_BUFFERS_PER_FRAME 256
#define BINK_PLAYER_MAX_TIMESTAMP_NS (24LL * 60LL * 60LL * 1000000000LL)
#define BINK_PLAYER_NANO_TIME_BASE ((AVRational){ 1, 1000000000 })

typedef struct bink_stored_frame {
    AVFrame *decoded;
    int64_t pts_ns;
} bink_stored_frame;

typedef struct bink_buffer_allocation {
    const AVBuffer *identity;
    uint64_t size;
} bink_buffer_allocation;

struct BinkPlayer {
    BinkFrame first_adapter_frame;
    bink_stored_frame *frames;
    size_t frame_capacity;
    bink_buffer_allocation *buffer_allocations;
    size_t buffer_table_capacity;
    size_t tracked_buffer_count;
    uint32_t frame_count;
    uint32_t width;
    uint32_t height;
    uint32_t stride;
    size_t rgba_bytes;
    uint8_t *rgba;
    uint64_t decoded_storage_bytes;
    int32_t frame_rate_num;
    int32_t frame_rate_den;
    int32_t time_base_num;
    int32_t time_base_den;
    int32_t mode;
    int32_t current_index;
    int has_mode;
    int frame_pending;
    int timeline_anchored;
    int ended;
    uint64_t timeline_origin_ns;
    int64_t timeline_origin_pts_ns;
    struct SwsContext *scaler;
};

static void clear_error(char *error, size_t capacity)
{
    if (error != NULL && capacity != 0u) {
        error[0] = '\0';
    }
}

static void set_error(char *error, size_t capacity, const char *format, ...)
{
    va_list arguments;

    if (error == NULL || capacity == 0u) {
        return;
    }
    va_start(arguments, format);
    (void)vsnprintf(error, capacity, format, arguments);
    va_end(arguments);
}

static const char *av_error_string(int code, char *buffer, size_t capacity)
{
    if (av_strerror(code, buffer, capacity) < 0) {
        (void)snprintf(buffer, capacity, "FFmpeg error %d", code);
    }
    return buffer;
}

static int frame_dimensions_valid(int width, int height)
{
    int64_t pixels;

    if (width <= 0 || height <= 0 ||
        width > BINK_PLAYER_MAX_DIMENSION ||
        height > BINK_PLAYER_MAX_DIMENSION) {
        return 0;
    }
    pixels = (int64_t)width * (int64_t)height;
    return pixels <= BINK_PLAYER_MAX_PIXELS;
}

static int rational_is_valid(AVRational value)
{
    return value.num > 0 && value.den > 0;
}

static int reduce_positive_rational(AVRational value,
                                    int32_t *out_num,
                                    int32_t *out_den)
{
    int numerator;
    int denominator;

    if (!rational_is_valid(value) || out_num == NULL || out_den == NULL) {
        return 0;
    }
    av_reduce(&numerator, &denominator, value.num, value.den, INT32_MAX);
    if (numerator <= 0 || denominator <= 0) {
        return 0;
    }
    *out_num = numerator;
    *out_den = denominator;
    return 1;
}

static int decoded_frame_layout_valid(const AVFrame *frame)
{
    const AVPixFmtDescriptor *descriptor;
    uint64_t plane_rows[4] = { 0u, 0u, 0u, 0u };
    int plane_count;
    int component;
    int plane;

    if (frame == NULL || frame->format < 0 ||
        frame->width <= 0 || frame->height <= 0) {
        return 0;
    }
    descriptor = av_pix_fmt_desc_get((enum AVPixelFormat)frame->format);
    plane_count = av_pix_fmt_count_planes((enum AVPixelFormat)frame->format);
    if (descriptor == NULL || plane_count <= 0 || plane_count > 4) {
        return 0;
    }
    for (component = 0; component < descriptor->nb_components; ++component) {
        int component_plane = descriptor->comp[component].plane;
        uint64_t rows = (uint64_t)frame->height;

        if (component_plane < 0 || component_plane >= plane_count) {
            return 0;
        }
        if ((component == 1 || component == 2) &&
            descriptor->log2_chroma_h > 0) {
            uint64_t divisor = UINT64_C(1) << descriptor->log2_chroma_h;
            rows = (rows + divisor - 1u) / divisor;
        }
        if (rows > plane_rows[component_plane]) {
            plane_rows[component_plane] = rows;
        }
    }
    for (plane = 0; plane < plane_count; ++plane) {
        int64_t line_size = frame->linesize[plane];

        if (plane_rows[plane] == 0u || frame->data[plane] == NULL ||
            line_size == 0 || line_size == INT_MIN) {
            return 0;
        }
    }
    return 1;
}

static size_t buffer_hash(const AVBuffer *identity)
{
    uint64_t value = (uint64_t)(uintptr_t)identity;

    value ^= value >> 33;
    value *= UINT64_C(0xff51afd7ed558ccd);
    value ^= value >> 33;
    value *= UINT64_C(0xc4ceb9fe1a85ec53);
    value ^= value >> 33;
    return (size_t)value;
}

static void insert_buffer_allocation(bink_buffer_allocation *table,
                                    size_t capacity,
                                    bink_buffer_allocation allocation)
{
    size_t index = buffer_hash(allocation.identity) & (capacity - 1u);

    while (table[index].identity != NULL) {
        index = (index + 1u) & (capacity - 1u);
    }
    table[index] = allocation;
}

static int reserve_buffer_table(BinkPlayer *player, size_t requested_count)
{
    size_t capacity = player->buffer_table_capacity;
    bink_buffer_allocation *replacement;
    size_t index;

    if (requested_count > BINK_PLAYER_MAX_TRACKED_BUFFERS) {
        return 0;
    }
    if (capacity == 0u) {
        capacity = 16u;
    }
    while (requested_count > capacity - capacity / 3u) {
        if (capacity > SIZE_MAX / 2u) {
            return 0;
        }
        capacity *= 2u;
    }
    if (capacity == player->buffer_table_capacity) {
        return 1;
    }
    if (capacity > SIZE_MAX / sizeof(*replacement)) {
        return 0;
    }
    replacement = (bink_buffer_allocation *)calloc(capacity, sizeof(*replacement));
    if (replacement == NULL) {
        return -1;
    }
    for (index = 0u; index < player->buffer_table_capacity; ++index) {
        if (player->buffer_allocations[index].identity != NULL) {
            insert_buffer_allocation(replacement, capacity,
                                     player->buffer_allocations[index]);
        }
    }
    free(player->buffer_allocations);
    player->buffer_allocations = replacement;
    player->buffer_table_capacity = capacity;
    return 1;
}

static int account_buffer_reference(BinkPlayer *player,
                                   const AVBufferRef *reference,
                                   uint64_t max_bytes)
{
    size_t index;
    uint64_t size;
    int reserve_result;

    if (reference == NULL || reference->buffer == NULL ||
        reference->data == NULL || reference->size == 0u) {
        return BINK_PLAYER_ERR_FORMAT;
    }
    size = (uint64_t)reference->size;
    if ((size_t)size != reference->size ||
        player->decoded_storage_bytes > max_bytes) {
        return BINK_PLAYER_ERR_BOUNDS;
    }
    if (player->buffer_table_capacity != 0u) {
        index = buffer_hash(reference->buffer) &
                (player->buffer_table_capacity - 1u);
        while (player->buffer_allocations[index].identity != NULL) {
            bink_buffer_allocation *allocation = &player->buffer_allocations[index];
            if (allocation->identity == reference->buffer) {
                uint64_t increase = size > allocation->size
                    ? size - allocation->size : 0u;
                if (increase > max_bytes - player->decoded_storage_bytes) {
                    return BINK_PLAYER_ERR_BOUNDS;
                }
                if (increase != 0u) {
                    allocation->size = size;
                    player->decoded_storage_bytes += increase;
                }
                return BINK_PLAYER_OK;
            }
            index = (index + 1u) & (player->buffer_table_capacity - 1u);
        }
    }
    if (player->tracked_buffer_count >= BINK_PLAYER_MAX_TRACKED_BUFFERS ||
        size > max_bytes - player->decoded_storage_bytes) {
        return BINK_PLAYER_ERR_BOUNDS;
    }
    reserve_result = reserve_buffer_table(player, player->tracked_buffer_count + 1u);
    if (reserve_result == 0) {
        return BINK_PLAYER_ERR_BOUNDS;
    }
    if (reserve_result < 0) {
        return BINK_PLAYER_ERR_MEMORY;
    }
    {
        bink_buffer_allocation allocation;
        allocation.identity = reference->buffer;
        allocation.size = size;
        insert_buffer_allocation(player->buffer_allocations,
                                 player->buffer_table_capacity, allocation);
    }
    player->tracked_buffer_count += 1u;
    player->decoded_storage_bytes += size;
    return BINK_PLAYER_OK;
}

static int account_decoded_frame_storage(BinkPlayer *player,
                                         const AVFrame *frame,
                                         uint64_t max_bytes)
{
    int references = 0;
    int index;
    int status;

    if (player == NULL || frame == NULL || !decoded_frame_layout_valid(frame)) {
        return BINK_PLAYER_ERR_FORMAT;
    }
    if (frame->nb_extended_buf < 0 ||
        frame->nb_extended_buf > BINK_PLAYER_MAX_BUFFERS_PER_FRAME ||
        (frame->nb_extended_buf > 0 && frame->extended_buf == NULL)) {
        return BINK_PLAYER_ERR_FORMAT;
    }
    for (index = 0; index < AV_NUM_DATA_POINTERS; ++index) {
        if (frame->buf[index] != NULL) {
            status = account_buffer_reference(player, frame->buf[index], max_bytes);
            if (status != BINK_PLAYER_OK) {
                return status;
            }
            references += 1;
        }
    }
    for (index = 0; index < frame->nb_extended_buf; ++index) {
        if (frame->extended_buf[index] == NULL) {
            return BINK_PLAYER_ERR_FORMAT;
        }
        status = account_buffer_reference(player, frame->extended_buf[index], max_bytes);
        if (status != BINK_PLAYER_OK) {
            return status;
        }
        references += 1;
    }
    return references > 0 ? BINK_PLAYER_OK : BINK_PLAYER_ERR_FORMAT;
}

#if defined(BINK_PLAYER_TESTING)
int bink_player_test_buffer_accounting(uint64_t primary_bytes,
                                       uint64_t extended_bytes,
                                       int shared,
                                       uint64_t budget,
                                       uint64_t *out_used)
{
    AVFrame *frame = NULL;
    AVFrame *clone = NULL;
    BinkPlayer player = { 0 };
    int status = BINK_PLAYER_ERR_MEMORY;

    if (out_used == NULL || primary_bytes == 0u ||
        primary_bytes > SIZE_MAX || extended_bytes > SIZE_MAX ||
        (shared != 0 && shared != 1)) {
        return BINK_PLAYER_ERR_ARGUMENT;
    }
    *out_used = 0u;
    frame = av_frame_alloc();
    if (frame == NULL) {
        goto cleanup;
    }
    frame->format = AV_PIX_FMT_GRAY8;
    frame->width = 1;
    frame->height = 1;
    frame->linesize[0] = 1;
    frame->buf[0] = av_buffer_alloc((size_t)primary_bytes);
    if (frame->buf[0] == NULL) {
        goto cleanup;
    }
    frame->data[0] = frame->buf[0]->data;
    if (shared || extended_bytes != 0u) {
        frame->extended_buf = av_calloc(1u, sizeof(*frame->extended_buf));
        if (frame->extended_buf == NULL) {
            goto cleanup;
        }
        frame->nb_extended_buf = 1;
        if (shared) {
            frame->extended_buf[0] = av_buffer_ref(frame->buf[0]);
        } else {
            frame->extended_buf[0] = av_buffer_alloc((size_t)extended_bytes);
        }
        if (frame->extended_buf[0] == NULL) {
            goto cleanup;
        }
    }
    clone = av_frame_clone(frame);
    if (clone == NULL) {
        goto cleanup;
    }

    status = account_decoded_frame_storage(&player, frame, budget);
    if (status == BINK_PLAYER_OK) {
        status = account_decoded_frame_storage(&player, clone, budget);
    }
    *out_used = player.decoded_storage_bytes;

cleanup:
    av_frame_free(&clone);
    av_frame_free(&frame);
    free(player.buffer_allocations);
    return status;
}
#endif

static int reserve_frame_slot(BinkPlayer *player)
{
    size_t next_capacity;
    bink_stored_frame *replacement;

    if (player->frame_count >= BINK_PLAYER_MAX_FRAMES) {
        return 0;
    }
    if ((size_t)player->frame_count < player->frame_capacity) {
        return 1;
    }
    next_capacity = player->frame_capacity == 0u ? 16u : player->frame_capacity * 2u;
    if (next_capacity > BINK_PLAYER_MAX_FRAMES) {
        next_capacity = BINK_PLAYER_MAX_FRAMES;
    }
    if (next_capacity <= player->frame_capacity ||
        next_capacity > SIZE_MAX / sizeof(*replacement)) {
        return 0;
    }
    replacement = (bink_stored_frame *)realloc(
        player->frames, next_capacity * sizeof(*replacement));
    if (replacement == NULL) {
        return -1;
    }
    memset(replacement + player->frame_capacity, 0,
           (next_capacity - player->frame_capacity) * sizeof(*replacement));
    player->frames = replacement;
    player->frame_capacity = next_capacity;
    return 1;
}

static int append_decoded_frame(BinkPlayer *player,
                                const AVFrame *decoded,
                                AVRational time_base,
                                char *error,
                                size_t error_capacity)
{
    int64_t pts;
    int64_t pts_ns;
    AVFrame *retained;
    int reserve_result;
    int storage_status;

    if (decoded->width != (int)player->width ||
        decoded->height != (int)player->height ||
        !frame_dimensions_valid(decoded->width, decoded->height)) {
        set_error(error, error_capacity,
                  "decoded Bink frame dimensions changed or exceed the player limit");
        return BINK_PLAYER_ERR_BOUNDS;
    }
    storage_status = account_decoded_frame_storage(
        player, decoded, BINK_PLAYER_MAX_STORED_BYTES);
    if (storage_status != BINK_PLAYER_OK) {
        if (storage_status == BINK_PLAYER_ERR_BOUNDS) {
            set_error(error, error_capacity,
                      "decoded Bink buffers exceed the %llu MiB retained-payload limit",
                      (unsigned long long)(BINK_PLAYER_MAX_STORED_BYTES / (1024u * 1024u)));
        } else if (storage_status == BINK_PLAYER_ERR_MEMORY) {
            set_error(error, error_capacity,
                      "cannot allocate the decoded Bink buffer index");
        } else {
            set_error(error, error_capacity,
                      "decoded Bink frame has an unsupported pixel or buffer layout");
        }
        return storage_status;
    }
    pts = decoded->best_effort_timestamp;
    if (pts == AV_NOPTS_VALUE) {
        pts = decoded->pts;
    }
    if (pts == AV_NOPTS_VALUE || !rational_is_valid(time_base)) {
        set_error(error, error_capacity,
                  "decoded Bink frame is missing a usable source timestamp");
        return BINK_PLAYER_ERR_TIMESTAMP;
    }
    pts_ns = av_rescale_q(pts, time_base, BINK_PLAYER_NANO_TIME_BASE);
    if (pts_ns == INT64_MIN || pts_ns == INT64_MAX ||
        pts_ns < -BINK_PLAYER_MAX_TIMESTAMP_NS ||
        pts_ns > BINK_PLAYER_MAX_TIMESTAMP_NS) {
        set_error(error, error_capacity,
                  "decoded Bink timestamp exceeds the 24-hour pacing bound");
        return BINK_PLAYER_ERR_TIMESTAMP;
    }
    if (player->frame_count > 0u &&
        pts_ns < player->frames[player->frame_count - 1u].pts_ns) {
        set_error(error, error_capacity,
                  "Bink frame timestamps are not in presentation order");
        return BINK_PLAYER_ERR_TIMESTAMP;
    }
    reserve_result = reserve_frame_slot(player);
    if (reserve_result == 0) {
        set_error(error, error_capacity,
                  "Bink frame count exceeds the %u-frame player limit",
                  BINK_PLAYER_MAX_FRAMES);
        return BINK_PLAYER_ERR_BOUNDS;
    }
    if (reserve_result < 0) {
        set_error(error, error_capacity,
                  "cannot allocate retained Bink frame index");
        return BINK_PLAYER_ERR_MEMORY;
    }
    retained = av_frame_clone(decoded);
    if (retained == NULL) {
        set_error(error, error_capacity,
                  "cannot retain decoded Bink frame %u", player->frame_count);
        return BINK_PLAYER_ERR_MEMORY;
    }
    player->frames[player->frame_count].decoded = retained;
    player->frames[player->frame_count].pts_ns = pts_ns;
    player->frame_count += 1u;
    return BINK_PLAYER_OK;
}

static int drain_decoder(BinkPlayer *player,
                         AVCodecContext *codec,
                         AVFrame *decoded,
                         AVRational time_base,
                         int *out_received,
                         char *error,
                         size_t error_capacity)
{
    int result;

    if (out_received != NULL) {
        *out_received = 0;
    }
    while ((result = avcodec_receive_frame(codec, decoded)) >= 0) {
        int status = append_decoded_frame(player, decoded, time_base,
                                          error, error_capacity);
        av_frame_unref(decoded);
        if (status != BINK_PLAYER_OK) {
            return status;
        }
        if (out_received != NULL) {
            *out_received += 1;
        }
    }
    if (result == AVERROR(EAGAIN) || result == AVERROR_EOF) {
        return BINK_PLAYER_OK;
    }
    {
        char ffmpeg_error[AV_ERROR_MAX_STRING_SIZE];
        set_error(error, error_capacity, "cannot receive decoded Bink frame: %s",
                  av_error_string(result, ffmpeg_error, sizeof(ffmpeg_error)));
    }
    return BINK_PLAYER_ERR_DECODE;
}

static int decode_all_frames(BinkPlayer *player,
                             AVFormatContext *format,
                             AVCodecContext *codec,
                             int video_stream,
                             AVRational time_base,
                             char *error,
                             size_t error_capacity)
{
    AVPacket *packet = av_packet_alloc();
    AVFrame *decoded = av_frame_alloc();
    int status = BINK_PLAYER_ERR_DECODE;
    int result;

    if (packet == NULL || decoded == NULL) {
        set_error(error, error_capacity,
                  "cannot allocate Bink decode packet/frame buffers");
        status = BINK_PLAYER_ERR_MEMORY;
        goto cleanup;
    }
    while ((result = av_read_frame(format, packet)) >= 0) {
        if (packet->stream_index == video_stream) {
            result = avcodec_send_packet(codec, packet);
            if (result == AVERROR(EAGAIN)) {
                status = drain_decoder(player, codec, decoded, time_base, NULL,
                                       error, error_capacity);
                if (status != BINK_PLAYER_OK) {
                    av_packet_unref(packet);
                    goto cleanup;
                }
                result = avcodec_send_packet(codec, packet);
            }
            if (result < 0) {
                char ffmpeg_error[AV_ERROR_MAX_STRING_SIZE];
                set_error(error, error_capacity,
                          "cannot submit Bink video packet: %s",
                          av_error_string(result, ffmpeg_error,
                                          sizeof(ffmpeg_error)));
                status = BINK_PLAYER_ERR_DECODE;
                av_packet_unref(packet);
                goto cleanup;
            }
            status = drain_decoder(player, codec, decoded, time_base, NULL,
                                   error, error_capacity);
            if (status != BINK_PLAYER_OK) {
                av_packet_unref(packet);
                goto cleanup;
            }
        }
        av_packet_unref(packet);
    }
    if (result != AVERROR_EOF) {
        char ffmpeg_error[AV_ERROR_MAX_STRING_SIZE];
        set_error(error, error_capacity, "cannot read Bink video stream: %s",
                  av_error_string(result, ffmpeg_error, sizeof(ffmpeg_error)));
        status = BINK_PLAYER_ERR_DECODE;
        goto cleanup;
    }
    result = avcodec_send_packet(codec, NULL);
    if (result < 0 && result != AVERROR_EOF) {
        char ffmpeg_error[AV_ERROR_MAX_STRING_SIZE];
        set_error(error, error_capacity, "cannot flush Bink decoder: %s",
                  av_error_string(result, ffmpeg_error, sizeof(ffmpeg_error)));
        status = BINK_PLAYER_ERR_DECODE;
        goto cleanup;
    }
    status = drain_decoder(player, codec, decoded, time_base, NULL,
                           error, error_capacity);
    if (status != BINK_PLAYER_OK) {
        goto cleanup;
    }
    if (player->frame_count == 0u) {
        set_error(error, error_capacity,
                  "Bink stream contains no decoded video frames");
        status = BINK_PLAYER_ERR_DECODE;
        goto cleanup;
    }
    status = BINK_PLAYER_OK;

cleanup:
    av_frame_free(&decoded);
    av_packet_free(&packet);
    return status;
}

static int convert_frame(BinkPlayer *player,
                         uint32_t index,
                         int use_adapter_first,
                         char *error,
                         size_t error_capacity)
{
    int rows;
    uint8_t *destination[4] = { player->rgba, NULL, NULL, NULL };
    int destination_linesize[4] = { (int)player->stride, 0, 0, 0 };
    AVFrame *decoded;

    if (index >= player->frame_count || player->rgba == NULL) {
        set_error(error, error_capacity, "Bink frame index or output buffer is invalid");
        return BINK_PLAYER_ERR_BOUNDS;
    }
    if (use_adapter_first && index == 0u) {
        memcpy(player->rgba, player->first_adapter_frame.rgba,
               player->rgba_bytes);
        return BINK_PLAYER_OK;
    }
    decoded = player->frames[index].decoded;
    rows = sws_scale(player->scaler,
                     (const uint8_t * const *)decoded->data,
                     decoded->linesize,
                     0,
                     decoded->height,
                     destination,
                     destination_linesize);
    if (rows != decoded->height) {
        set_error(error, error_capacity,
                  "FFmpeg converted %d of %d Bink frame rows",
                  rows, decoded->height);
        return BINK_PLAYER_ERR_DECODE;
    }
    return BINK_PLAYER_OK;
}

static int current_frame_is_terminal(const BinkPlayer *player)
{
    if (player->mode == 1) {
        return player->current_index == 0;
    }
    return (uint32_t)player->current_index + 1u == player->frame_count;
}

static int fill_frame(BinkPlayer *player,
                      BinkPlayerFrame *out_frame,
                      char *error,
                      size_t error_capacity)
{
    uint32_t index;
    int status;
    int terminal;
    int64_t duration_ns = 0;

    if (player->current_index < 0 ||
        (uint32_t)player->current_index >= player->frame_count) {
        set_error(error, error_capacity, "Bink current frame is outside the decoded sequence");
        return BINK_PLAYER_ERR_BOUNDS;
    }
    index = (uint32_t)player->current_index;
    status = convert_frame(player, index, 1, error, error_capacity);
    if (status != BINK_PLAYER_OK) {
        return status;
    }
    terminal = current_frame_is_terminal(player);
    if (!terminal) {
        uint32_t neighbor = player->mode == 1 ? index - 1u : index + 1u;
        int64_t current_pts = player->frames[index].pts_ns;
        int64_t neighbor_pts = player->frames[neighbor].pts_ns;
        duration_ns = player->mode == 1
            ? current_pts - neighbor_pts
            : neighbor_pts - current_pts;
        if (duration_ns < 0) {
            set_error(error, error_capacity,
                      "Bink frame timestamps cannot be paced in the selected direction");
            return BINK_PLAYER_ERR_TIMESTAMP;
        }
    }
    out_frame->rgba = player->rgba;
    out_frame->rgba_bytes = player->rgba_bytes;
    out_frame->width = player->width;
    out_frame->height = player->height;
    out_frame->stride = player->stride;
    out_frame->current_frame = player->current_index;
    out_frame->pts_ns = player->frames[index].pts_ns;
    out_frame->duration_ns = duration_ns;
    out_frame->is_terminal = terminal ? 1u : 0u;
    return BINK_PLAYER_OK;
}

static int reset_timeline(BinkPlayer *player,
                          uint64_t now_ns,
                          int32_t frame_index)
{
    if (frame_index < 0 || (uint32_t)frame_index >= player->frame_count) {
        return 0;
    }
    player->current_index = frame_index;
    player->frame_pending = 1;
    player->timeline_anchored = 1;
    player->timeline_origin_ns = now_ns;
    player->timeline_origin_pts_ns = player->frames[frame_index].pts_ns;
    player->ended = 0;
    return 1;
}

static int timestamp_distance_ns(int64_t first, int64_t second, uint64_t *out_distance)
{
    int64_t distance;

    if (out_distance == NULL ||
        first < -BINK_PLAYER_MAX_TIMESTAMP_NS ||
        first > BINK_PLAYER_MAX_TIMESTAMP_NS ||
        second < -BINK_PLAYER_MAX_TIMESTAMP_NS ||
        second > BINK_PLAYER_MAX_TIMESTAMP_NS) {
        return 0;
    }
    distance = first >= second ? first - second : second - first;
    if (distance < 0) {
        return 0;
    }
    *out_distance = (uint64_t)distance;
    return 1;
}

static int frame_deadline_ns(const BinkPlayer *player,
                             uint32_t target_index,
                             uint64_t *out_deadline)
{
    uint64_t distance;

    if (!player->timeline_anchored || target_index >= player->frame_count ||
        out_deadline == NULL ||
        !timestamp_distance_ns(player->frames[target_index].pts_ns,
                               player->timeline_origin_pts_ns,
                               &distance) ||
        distance > UINT64_MAX - player->timeline_origin_ns) {
        return 0;
    }
    *out_deadline = player->timeline_origin_ns + distance;
    return 1;
}

int bink_player_open(const char *path,
                     BinkPlayer **out_player,
                     BinkPlayerInfo *out_info,
                     char *error,
                     size_t error_capacity)
{
    struct stat file_status;
    BinkPlayer *player = NULL;
    AVFormatContext *format = NULL;
    AVCodecContext *codec = NULL;
    AVCodecParameters *parameters;
    AVStream *stream;
    const AVCodec *decoder;
    AVDictionary *options = NULL;
    AVRational guessed_frame_rate;
    int video_stream;
    int result;
    int status = BINK_PLAYER_ERR_FORMAT;
    uint32_t index;
    char ffmpeg_error[AV_ERROR_MAX_STRING_SIZE];

    clear_error(error, error_capacity);
    if (out_player != NULL) {
        *out_player = NULL;
    }
    if (out_info != NULL) {
        memset(out_info, 0, sizeof(*out_info));
    }
    if (path == NULL || path[0] == '\0' || out_player == NULL || out_info == NULL) {
        set_error(error, error_capacity,
                  "a local Bink path and player/info outputs are required");
        return BINK_PLAYER_ERR_ARGUMENT;
    }
    if (stat(path, &file_status) != 0) {
        set_error(error, error_capacity,
                  "input is not a readable regular local file: %s", strerror(errno));
        return BINK_PLAYER_ERR_FILE;
    }
    if (!S_ISREG(file_status.st_mode)) {
        set_error(error, error_capacity,
                  "input is not a readable regular local file");
        return BINK_PLAYER_ERR_FILE;
    }
    if (file_status.st_size <= 0 ||
        (int64_t)file_status.st_size > BINK_PLAYER_MAX_INPUT_BYTES) {
        set_error(error, error_capacity,
                  "input file size is outside the supported range (1..%lld bytes)",
                  BINK_PLAYER_MAX_INPUT_BYTES);
        return BINK_PLAYER_ERR_BOUNDS;
    }

    player = (BinkPlayer *)calloc(1u, sizeof(*player));
    if (player == NULL) {
        set_error(error, error_capacity, "cannot allocate timed Bink player state");
        return BINK_PLAYER_ERR_MEMORY;
    }
    player->first_adapter_frame = (BinkFrame)BINK_FRAME_INIT;
    result = bink_adapter_decode_first_frame(path, &player->first_adapter_frame,
                                             error, error_capacity);
    if (result != BINK_ADAPTER_OK) {
        switch (result) {
        case BINK_ADAPTER_ERR_ARGUMENT:
            status = BINK_PLAYER_ERR_ARGUMENT;
            break;
        case BINK_ADAPTER_ERR_FILE:
            status = BINK_PLAYER_ERR_FILE;
            break;
        case BINK_ADAPTER_ERR_DECODE:
            status = BINK_PLAYER_ERR_DECODE;
            break;
        case BINK_ADAPTER_ERR_MEMORY:
            status = BINK_PLAYER_ERR_MEMORY;
            break;
        case BINK_ADAPTER_ERR_BOUNDS:
            status = BINK_PLAYER_ERR_BOUNDS;
            break;
        case BINK_ADAPTER_ERR_FORMAT:
        default:
            status = BINK_PLAYER_ERR_FORMAT;
            break;
        }
        goto cleanup;
    }
    if (player->first_adapter_frame.rgba == NULL) {
        set_error(error, error_capacity,
                  "first-frame adapter returned no RGBA image");
        status = BINK_PLAYER_ERR_DECODE;
        goto cleanup;
    }
    player->width = player->first_adapter_frame.width;
    player->height = player->first_adapter_frame.height;
    player->stride = player->first_adapter_frame.stride;
    if (!frame_dimensions_valid((int)player->width, (int)player->height) ||
        player->stride != player->width * 4u ||
        player->height > SIZE_MAX / player->stride) {
        set_error(error, error_capacity,
                  "first Bink adapter frame has invalid dimensions or stride");
        status = BINK_PLAYER_ERR_BOUNDS;
        goto cleanup;
    }
    player->rgba_bytes = (size_t)player->stride * (size_t)player->height;
    player->rgba = (uint8_t *)malloc(player->rgba_bytes);
    if (player->rgba == NULL) {
        set_error(error, error_capacity,
                  "cannot allocate %zu bytes for the current RGBA frame",
                  player->rgba_bytes);
        status = BINK_PLAYER_ERR_MEMORY;
        goto cleanup;
    }

    result = av_dict_set(&options, "protocol_whitelist", "file", 0);
    if (result < 0) {
        set_error(error, error_capacity, "cannot configure FFmpeg file-only input: %s",
                  av_error_string(result, ffmpeg_error, sizeof(ffmpeg_error)));
        status = BINK_PLAYER_ERR_MEMORY;
        goto cleanup;
    }
    result = avformat_open_input(&format, path, NULL, &options);
    av_dict_free(&options);
    if (result < 0) {
        set_error(error, error_capacity, "cannot open Bink input: %s",
                  av_error_string(result, ffmpeg_error, sizeof(ffmpeg_error)));
        status = BINK_PLAYER_ERR_FORMAT;
        goto cleanup;
    }
    video_stream = av_find_best_stream(format, AVMEDIA_TYPE_VIDEO,
                                       -1, -1, NULL, 0);
    if (video_stream < 0) {
        set_error(error, error_capacity, "input has no decodable video stream: %s",
                  av_error_string(video_stream, ffmpeg_error, sizeof(ffmpeg_error)));
        status = BINK_PLAYER_ERR_FORMAT;
        goto cleanup;
    }
    for (unsigned int stream_index = 0u;
         stream_index < format->nb_streams; ++stream_index) {
        if ((int)stream_index != video_stream) {
            format->streams[stream_index]->discard = AVDISCARD_ALL;
        }
    }
    result = avformat_find_stream_info(format, NULL);
    if (result < 0) {
        set_error(error, error_capacity, "cannot read Bink video stream information: %s",
                  av_error_string(result, ffmpeg_error, sizeof(ffmpeg_error)));
        status = BINK_PLAYER_ERR_FORMAT;
        goto cleanup;
    }
    stream = format->streams[video_stream];
    parameters = stream->codecpar;
    if (parameters->codec_id != AV_CODEC_ID_BINKVIDEO) {
        set_error(error, error_capacity,
                  "input video codec is %s; only Bink video is supported",
                  avcodec_get_name(parameters->codec_id));
        status = BINK_PLAYER_ERR_FORMAT;
        goto cleanup;
    }
    if (!frame_dimensions_valid(parameters->width, parameters->height) ||
        parameters->width != (int)player->width ||
        parameters->height != (int)player->height) {
        set_error(error, error_capacity,
                  "timed Bink dimensions are invalid or differ from its first-frame adapter");
        status = BINK_PLAYER_ERR_BOUNDS;
        goto cleanup;
    }
    if (!rational_is_valid(stream->time_base)) {
        set_error(error, error_capacity,
                  "Bink video stream has an invalid timestamp time base");
        status = BINK_PLAYER_ERR_TIMESTAMP;
        goto cleanup;
    }
    if (!reduce_positive_rational(stream->time_base,
                                  &player->time_base_num,
                                  &player->time_base_den)) {
        set_error(error, error_capacity,
                  "Bink video time base cannot be represented by the player API");
        status = BINK_PLAYER_ERR_TIMESTAMP;
        goto cleanup;
    }
    guessed_frame_rate = av_guess_frame_rate(format, stream, NULL);
    if (!reduce_positive_rational(guessed_frame_rate,
                                  &player->frame_rate_num,
                                  &player->frame_rate_den)) {
        guessed_frame_rate = stream->avg_frame_rate;
        if (!reduce_positive_rational(guessed_frame_rate,
                                      &player->frame_rate_num,
                                      &player->frame_rate_den)) {
            guessed_frame_rate = stream->r_frame_rate;
            if (!reduce_positive_rational(guessed_frame_rate,
                                          &player->frame_rate_num,
                                          &player->frame_rate_den)) {
                set_error(error, error_capacity,
                          "Bink video stream has no usable frame rate");
                status = BINK_PLAYER_ERR_TIMESTAMP;
                goto cleanup;
            }
        }
    }
    decoder = avcodec_find_decoder(parameters->codec_id);
    if (decoder == NULL) {
        set_error(error, error_capacity, "FFmpeg has no Bink video decoder");
        status = BINK_PLAYER_ERR_FORMAT;
        goto cleanup;
    }
    codec = avcodec_alloc_context3(decoder);
    if (codec == NULL) {
        set_error(error, error_capacity,
                  "cannot allocate FFmpeg Bink video decoder context");
        status = BINK_PLAYER_ERR_MEMORY;
        goto cleanup;
    }
    result = avcodec_parameters_to_context(codec, parameters);
    if (result < 0) {
        set_error(error, error_capacity, "cannot initialize Bink decoder: %s",
                  av_error_string(result, ffmpeg_error, sizeof(ffmpeg_error)));
        status = BINK_PLAYER_ERR_DECODE;
        goto cleanup;
    }
    codec->max_pixels = BINK_PLAYER_MAX_PIXELS;
    codec->thread_count = 1;
    result = avcodec_open2(codec, decoder, NULL);
    if (result < 0) {
        set_error(error, error_capacity, "cannot open Bink decoder: %s",
                  av_error_string(result, ffmpeg_error, sizeof(ffmpeg_error)));
        status = BINK_PLAYER_ERR_DECODE;
        goto cleanup;
    }
    status = decode_all_frames(player, format, codec, video_stream,
                               stream->time_base, error, error_capacity);
    if (status != BINK_PLAYER_OK) {
        goto cleanup;
    }
    if (player->frame_count > INT32_MAX) {
        set_error(error, error_capacity,
                  "Bink frame count cannot be represented by current_frame");
        status = BINK_PLAYER_ERR_BOUNDS;
        goto cleanup;
    }
    player->scaler = sws_getContext((int)player->width,
                                    (int)player->height,
                                    (enum AVPixelFormat)player->frames[0].decoded->format,
                                    (int)player->width,
                                    (int)player->height,
                                    AV_PIX_FMT_RGBA,
                                    SWS_BICUBIC,
                                    NULL,
                                    NULL,
                                    NULL);
    if (player->scaler == NULL) {
        set_error(error, error_capacity,
                  "cannot create FFmpeg Bink-to-RGBA converter");
        status = BINK_PLAYER_ERR_MEMORY;
        goto cleanup;
    }
    for (index = 0u; index < player->frame_count; ++index) {
        AVFrame *decoded = player->frames[index].decoded;
        if (decoded->format != player->frames[0].decoded->format) {
            set_error(error, error_capacity,
                      "Bink pixel format changes between video frames");
            status = BINK_PLAYER_ERR_FORMAT;
            goto cleanup;
        }
    }
    status = convert_frame(player, 0u, 0, error, error_capacity);
    if (status != BINK_PLAYER_OK) {
        goto cleanup;
    }
    if (memcmp(player->rgba, player->first_adapter_frame.rgba,
               player->rgba_bytes) != 0) {
        set_error(error, error_capacity,
                  "timed Bink frame zero differs from the existing first-frame adapter");
        status = BINK_PLAYER_ERR_DECODE;
        goto cleanup;
    }
    player->mode = 0;
    player->current_index = 0;
    player->has_mode = 1;
    player->frame_pending = 1;
    player->timeline_anchored = 0;
    out_info->width = player->width;
    out_info->height = player->height;
    out_info->total_frames = player->frame_count;
    out_info->frame_rate_num = player->frame_rate_num;
    out_info->frame_rate_den = player->frame_rate_den;
    out_info->time_base_num = player->time_base_num;
    out_info->time_base_den = player->time_base_den;
    out_info->decoded_frame_storage_bytes = player->decoded_storage_bytes;
    *out_player = player;
    player = NULL;
    status = BINK_PLAYER_OK;

cleanup:
    av_dict_free(&options);
    avcodec_free_context(&codec);
    avformat_close_input(&format);
    if (player != NULL) {
        bink_player_close(player);
    }
    return status;
}

int bink_player_set_mode(BinkPlayer *player,
                         int32_t original_mode,
                         uint64_t now_ns,
                         char *error,
                         size_t error_capacity)
{
    int32_t start_frame;

    clear_error(error, error_capacity);
    if (player == NULL || player->frame_count == 0u) {
        set_error(error, error_capacity, "an opened Bink player is required");
        return BINK_PLAYER_ERR_ARGUMENT;
    }
    player->mode = original_mode;
    start_frame = original_mode == 1 ? (int32_t)player->frame_count - 1 : 0;
    if (!reset_timeline(player, now_ns, start_frame)) {
        set_error(error, error_capacity, "cannot position Bink player at mode boundary");
        return BINK_PLAYER_ERR_BOUNDS;
    }
    player->has_mode = 1;
    return BINK_PLAYER_OK;
}

int bink_player_seek(BinkPlayer *player,
                     uint32_t frame_1based,
                     uint64_t now_ns,
                     char *error,
                     size_t error_capacity)
{
    clear_error(error, error_capacity);
    if (player == NULL || player->frame_count == 0u) {
        set_error(error, error_capacity, "an opened Bink player is required");
        return BINK_PLAYER_ERR_ARGUMENT;
    }
    if (frame_1based == 0u || frame_1based > player->frame_count) {
        set_error(error, error_capacity,
                  "one-based Bink seek target %u is outside 1..%u",
                  frame_1based, player->frame_count);
        return BINK_PLAYER_ERR_BOUNDS;
    }
    if (!reset_timeline(player, now_ns, (int32_t)(frame_1based - 1u))) {
        set_error(error, error_capacity, "cannot position Bink player at seek target");
        return BINK_PLAYER_ERR_BOUNDS;
    }
    player->has_mode = 1;
    return BINK_PLAYER_OK;
}

int bink_player_advance(BinkPlayer *player,
                        uint64_t now_ns,
                        BinkPlayerFrame *out_frame,
                        char *error,
                        size_t error_capacity)
{
    int32_t step;
    int32_t next_index;
    uint64_t deadline_ns;
    int status;

    clear_error(error, error_capacity);
    if (out_frame != NULL) {
        memset(out_frame, 0, sizeof(*out_frame));
    }
    if (player == NULL || out_frame == NULL || !player->has_mode ||
        player->frame_count == 0u) {
        set_error(error, error_capacity,
                  "an opened Bink player and frame output are required");
        return BINK_PLAYER_ERR_ARGUMENT;
    }
    if (player->ended) {
        return BINK_PLAYER_EOS;
    }
    if (player->frame_pending) {
        if (!player->timeline_anchored) {
            player->timeline_anchored = 1;
            player->timeline_origin_ns = now_ns;
            player->timeline_origin_pts_ns = player->frames[player->current_index].pts_ns;
        }
        status = fill_frame(player, out_frame, error, error_capacity);
        if (status == BINK_PLAYER_OK) {
            player->frame_pending = 0;
        }
        return status;
    }
    step = player->mode == 1 ? -1 : 1;
    next_index = player->current_index + step;
    if (next_index < 0 || (uint32_t)next_index >= player->frame_count) {
        player->ended = 1;
        return BINK_PLAYER_EOS;
    }
    if (!frame_deadline_ns(player, (uint32_t)next_index, &deadline_ns)) {
        set_error(error, error_capacity,
                  "Bink timestamp could not be mapped to the monotonic playback clock");
        return BINK_PLAYER_ERR_TIMESTAMP;
    }
    if (now_ns < deadline_ns) {
        return BINK_PLAYER_NOT_DUE;
    }
    {
        int32_t previous_index = player->current_index;
        player->current_index = next_index;
        status = fill_frame(player, out_frame, error, error_capacity);
        if (status != BINK_PLAYER_OK) {
            player->current_index = previous_index;
        }
    }
    return status;
}

void bink_player_close(BinkPlayer *player)
{
    uint32_t index;

    if (player == NULL) {
        return;
    }
    for (index = 0u; index < player->frame_count; ++index) {
        av_frame_free(&player->frames[index].decoded);
    }
    free(player->frames);
    free(player->buffer_allocations);
    free(player->rgba);
    sws_freeContext(player->scaler);
    bink_adapter_destroy(&player->first_adapter_frame);
    memset(player, 0, sizeof(*player));
    free(player);
}

const char *bink_player_status_string(int status)
{
    switch (status) {
    case BINK_PLAYER_OK:
        return "frame ready / success";
    case BINK_PLAYER_NOT_DUE:
        return "next frame is not due";
    case BINK_PLAYER_EOS:
        return "end of selected playback direction";
    case BINK_PLAYER_ERR_ARGUMENT:
        return "invalid argument";
    case BINK_PLAYER_ERR_FILE:
        return "local file unavailable";
    case BINK_PLAYER_ERR_FORMAT:
        return "unsupported Bink format";
    case BINK_PLAYER_ERR_DECODE:
        return "Bink video decode failed";
    case BINK_PLAYER_ERR_MEMORY:
        return "memory allocation failed";
    case BINK_PLAYER_ERR_BOUNDS:
        return "input exceeds player bounds";
    case BINK_PLAYER_ERR_TIMESTAMP:
        return "unsupported or invalid Bink timestamp";
    default:
        return "unknown Bink player status";
    }
}
