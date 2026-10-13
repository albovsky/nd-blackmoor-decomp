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
#include <libavutil/dict.h>
#include <libavutil/error.h>
#include <libavutil/pixfmt.h>
#include <libswscale/swscale.h>

#define BINK_ADAPTER_MAX_DIMENSION 4096
#define BINK_ADAPTER_MAX_PIXELS \
    ((int64_t)BINK_ADAPTER_MAX_DIMENSION * (int64_t)BINK_ADAPTER_MAX_DIMENSION)
#define BINK_ADAPTER_MAX_INPUT_BYTES (256LL * 1024LL * 1024LL)

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
        width > BINK_ADAPTER_MAX_DIMENSION ||
        height > BINK_ADAPTER_MAX_DIMENSION) {
        return 0;
    }
    pixels = (int64_t)width * (int64_t)height;
    return pixels <= BINK_ADAPTER_MAX_PIXELS;
}

int bink_adapter_decode_first_frame(const char *path,
                                    BinkFrame *frame,
                                    char *error,
                                    size_t error_capacity)
{
    struct stat file_status;
    AVFormatContext *format = NULL;
    AVCodecContext *codec = NULL;
    AVCodecParameters *parameters;
    const AVCodec *decoder;
    AVPacket *packet = NULL;
    AVFrame *decoded = NULL;
    struct SwsContext *scaler = NULL;
    AVDictionary *options = NULL;
    int video_stream;
    int result;
    int status = BINK_ADAPTER_ERR_DECODE;
    int have_frame = 0;
    uint8_t *rgba = NULL;
    size_t byte_count;
    uint32_t stride;
    char ffmpeg_error[AV_ERROR_MAX_STRING_SIZE];

    clear_error(error, error_capacity);
    if (frame != NULL) {
        memset(frame, 0, sizeof(*frame));
    }
    if (path == NULL || path[0] == '\0' || frame == NULL) {
        set_error(error, error_capacity, "a local Bink path and output frame are required");
        return BINK_ADAPTER_ERR_ARGUMENT;
    }
    if (stat(path, &file_status) != 0) {
        set_error(error, error_capacity, "input is not a readable regular file: %s",
                  strerror(errno));
        return BINK_ADAPTER_ERR_FILE;
    }
    if (!S_ISREG(file_status.st_mode)) {
        set_error(error, error_capacity, "input is not a regular local file");
        return BINK_ADAPTER_ERR_FILE;
    }
    if (file_status.st_size <= 0 ||
        file_status.st_size > BINK_ADAPTER_MAX_INPUT_BYTES) {
        set_error(error, error_capacity,
                  "input file size is outside the supported range (1..%" PRId64 " bytes)",
                  (int64_t)BINK_ADAPTER_MAX_INPUT_BYTES);
        return BINK_ADAPTER_ERR_BOUNDS;
    }

    /* FFmpeg must not open URLs or network protocols for this host adapter. */
    result = av_dict_set(&options, "protocol_whitelist", "file", 0);
    if (result < 0) {
        set_error(error, error_capacity, "cannot configure FFmpeg file-only input: %s",
                  av_error_string(result, ffmpeg_error, sizeof(ffmpeg_error)));
        status = BINK_ADAPTER_ERR_MEMORY;
        goto cleanup;
    }
    result = avformat_open_input(&format, path, NULL, &options);
    av_dict_free(&options);
    if (result < 0) {
        set_error(error, error_capacity, "cannot open Bink input: %s",
                  av_error_string(result, ffmpeg_error, sizeof(ffmpeg_error)));
        status = BINK_ADAPTER_ERR_FORMAT;
        goto cleanup;
    }
    result = avformat_find_stream_info(format, NULL);
    if (result < 0) {
        set_error(error, error_capacity, "cannot read media stream information: %s",
                  av_error_string(result, ffmpeg_error, sizeof(ffmpeg_error)));
        status = BINK_ADAPTER_ERR_FORMAT;
        goto cleanup;
    }
    video_stream = av_find_best_stream(format, AVMEDIA_TYPE_VIDEO, -1, -1, NULL, 0);
    if (video_stream < 0) {
        set_error(error, error_capacity, "input has no decodable video stream: %s",
                  av_error_string(video_stream, ffmpeg_error, sizeof(ffmpeg_error)));
        status = BINK_ADAPTER_ERR_FORMAT;
        goto cleanup;
    }
    parameters = format->streams[video_stream]->codecpar;
    if (parameters->codec_id != AV_CODEC_ID_BINKVIDEO) {
        set_error(error, error_capacity,
                  "input video codec is %s; only Bink video is supported",
                  avcodec_get_name(parameters->codec_id));
        status = BINK_ADAPTER_ERR_FORMAT;
        goto cleanup;
    }
    if (!frame_dimensions_valid(parameters->width, parameters->height)) {
        set_error(error, error_capacity,
                  "Bink dimensions exceed the %d-by-%d adapter limit (%d by %d)",
                  BINK_ADAPTER_MAX_DIMENSION, BINK_ADAPTER_MAX_DIMENSION,
                  parameters->width, parameters->height);
        status = BINK_ADAPTER_ERR_BOUNDS;
        goto cleanup;
    }

    decoder = avcodec_find_decoder(parameters->codec_id);
    if (decoder == NULL) {
        set_error(error, error_capacity, "FFmpeg has no Bink video decoder");
        status = BINK_ADAPTER_ERR_FORMAT;
        goto cleanup;
    }
    codec = avcodec_alloc_context3(decoder);
    if (codec == NULL) {
        set_error(error, error_capacity, "cannot allocate FFmpeg decoder context");
        status = BINK_ADAPTER_ERR_MEMORY;
        goto cleanup;
    }
    result = avcodec_parameters_to_context(codec, parameters);
    if (result < 0) {
        set_error(error, error_capacity, "cannot initialize Bink decoder: %s",
                  av_error_string(result, ffmpeg_error, sizeof(ffmpeg_error)));
        status = BINK_ADAPTER_ERR_DECODE;
        goto cleanup;
    }
    codec->max_pixels = BINK_ADAPTER_MAX_PIXELS;
    codec->thread_count = 1;
    result = avcodec_open2(codec, decoder, NULL);
    if (result < 0) {
        set_error(error, error_capacity, "cannot open Bink decoder: %s",
                  av_error_string(result, ffmpeg_error, sizeof(ffmpeg_error)));
        status = BINK_ADAPTER_ERR_DECODE;
        goto cleanup;
    }
    packet = av_packet_alloc();
    decoded = av_frame_alloc();
    if (packet == NULL || decoded == NULL) {
        set_error(error, error_capacity, "cannot allocate FFmpeg packet/frame buffers");
        status = BINK_ADAPTER_ERR_MEMORY;
        goto cleanup;
    }

    while ((result = av_read_frame(format, packet)) >= 0) {
        if (packet->stream_index == video_stream) {
            result = avcodec_send_packet(codec, packet);
            av_packet_unref(packet);
            if (result < 0) {
                set_error(error, error_capacity, "cannot submit Bink frame packet: %s",
                          av_error_string(result, ffmpeg_error, sizeof(ffmpeg_error)));
                status = BINK_ADAPTER_ERR_DECODE;
                goto cleanup;
            }
            result = avcodec_receive_frame(codec, decoded);
            if (result == 0) {
                have_frame = 1;
                break;
            }
            if (result != AVERROR(EAGAIN) && result != AVERROR_EOF) {
                set_error(error, error_capacity, "cannot decode Bink video frame: %s",
                          av_error_string(result, ffmpeg_error, sizeof(ffmpeg_error)));
                status = BINK_ADAPTER_ERR_DECODE;
                goto cleanup;
            }
        } else {
            av_packet_unref(packet);
        }
    }
    av_packet_unref(packet);
    if (result < 0 && result != AVERROR_EOF && !have_frame) {
        set_error(error, error_capacity, "cannot read Bink frame packet: %s",
                  av_error_string(result, ffmpeg_error, sizeof(ffmpeg_error)));
        status = BINK_ADAPTER_ERR_DECODE;
        goto cleanup;
    }
    if (!have_frame) {
        result = avcodec_send_packet(codec, NULL);
        if (result < 0 && result != AVERROR_EOF) {
            set_error(error, error_capacity, "cannot flush Bink decoder: %s",
                      av_error_string(result, ffmpeg_error, sizeof(ffmpeg_error)));
            status = BINK_ADAPTER_ERR_DECODE;
            goto cleanup;
        }
        result = avcodec_receive_frame(codec, decoded);
        if (result == 0) {
            have_frame = 1;
        } else {
            set_error(error, error_capacity, "Bink stream contains no decodable video frame: %s",
                      av_error_string(result, ffmpeg_error, sizeof(ffmpeg_error)));
            status = BINK_ADAPTER_ERR_DECODE;
            goto cleanup;
        }
    }

    if (!frame_dimensions_valid(decoded->width, decoded->height) ||
        decoded->width != parameters->width || decoded->height != parameters->height) {
        set_error(error, error_capacity,
                  "decoded Bink frame dimensions are invalid or inconsistent (%d by %d)",
                  decoded->width, decoded->height);
        status = BINK_ADAPTER_ERR_BOUNDS;
        goto cleanup;
    }
    if (decoded->width > (int)(UINT32_MAX / 4u)) {
        set_error(error, error_capacity, "decoded Bink row size overflows the adapter format");
        status = BINK_ADAPTER_ERR_BOUNDS;
        goto cleanup;
    }
    stride = (uint32_t)decoded->width * 4u;
    if ((size_t)decoded->height > SIZE_MAX / (size_t)stride) {
        set_error(error, error_capacity, "decoded Bink frame size overflows host memory limits");
        status = BINK_ADAPTER_ERR_BOUNDS;
        goto cleanup;
    }
    byte_count = (size_t)stride * (size_t)decoded->height;
    rgba = (uint8_t *)malloc(byte_count);
    if (rgba == NULL) {
        set_error(error, error_capacity, "cannot allocate %zu RGBA frame bytes", byte_count);
        status = BINK_ADAPTER_ERR_MEMORY;
        goto cleanup;
    }
    scaler = sws_getContext(decoded->width,
                            decoded->height,
                            (enum AVPixelFormat)decoded->format,
                            decoded->width,
                            decoded->height,
                            AV_PIX_FMT_RGBA,
                            SWS_BICUBIC,
                            NULL,
                            NULL,
                            NULL);
    if (scaler == NULL) {
        set_error(error, error_capacity, "cannot create FFmpeg RGBA pixel converter");
        status = BINK_ADAPTER_ERR_DECODE;
        goto cleanup;
    }
    {
        uint8_t *destination[4] = { rgba, NULL, NULL, NULL };
        int destination_stride[4] = { (int)stride, 0, 0, 0 };
        result = sws_scale(scaler,
                           (const uint8_t * const *)decoded->data,
                           decoded->linesize,
                           0,
                           decoded->height,
                           destination,
                           destination_stride);
    }
    if (result != decoded->height) {
        set_error(error, error_capacity, "FFmpeg converted %d of %d Bink frame rows",
                  result, decoded->height);
        status = BINK_ADAPTER_ERR_DECODE;
        goto cleanup;
    }

    frame->width = (uint32_t)decoded->width;
    frame->height = (uint32_t)decoded->height;
    frame->stride = stride;
    frame->rgba = rgba;
    rgba = NULL;
    status = BINK_ADAPTER_OK;

cleanup:
    free(rgba);
    sws_freeContext(scaler);
    av_frame_free(&decoded);
    av_packet_free(&packet);
    avcodec_free_context(&codec);
    avformat_close_input(&format);
    av_dict_free(&options);
    return status;
}

void bink_adapter_destroy(BinkFrame *frame)
{
    if (frame != NULL) {
        free(frame->rgba);
        memset(frame, 0, sizeof(*frame));
    }
}

const char *bink_adapter_status_string(int status)
{
    switch (status) {
    case BINK_ADAPTER_OK:
        return "success";
    case BINK_ADAPTER_ERR_ARGUMENT:
        return "invalid argument";
    case BINK_ADAPTER_ERR_FILE:
        return "local file unavailable";
    case BINK_ADAPTER_ERR_FORMAT:
        return "unsupported media format";
    case BINK_ADAPTER_ERR_DECODE:
        return "frame decode failed";
    case BINK_ADAPTER_ERR_MEMORY:
        return "memory allocation failed";
    case BINK_ADAPTER_ERR_BOUNDS:
        return "input exceeds adapter bounds";
    default:
        return "unknown adapter status";
    }
}
