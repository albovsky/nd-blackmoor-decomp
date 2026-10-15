#include "bink_audio.h"

#include <errno.h>
#include <inttypes.h>
#include <limits.h>
#include <math.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libavutil/channel_layout.h>
#include <libavutil/dict.h>
#include <libavutil/error.h>
#include <libavutil/samplefmt.h>
#include <libswresample/swresample.h>

/* Override only to exercise the production allocation guard in offline tests. */
#ifndef BINK_AUDIO_MAX_PCM_BYTES
#define BINK_AUDIO_MAX_PCM_BYTES (256u * 1024u * 1024u)
#endif
#define BINK_AUDIO_MAX_INPUT_BYTES (256LL * 1024LL * 1024LL)
#define BINK_AUDIO_MAX_SAMPLE_RATE 192000

typedef struct AudioDecode {
    struct SwrContext *converter;
    AVChannelLayout layout;
    enum AVSampleFormat input_format;
    int sample_rate;
    int channels;
    float *pcm;
    size_t frames;
    size_t capacity;
    char *error;
    size_t error_capacity;
} AudioDecode;

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

static int ffmpeg_failure(AudioDecode *state, int status, int result,
                          const char *operation)
{
    char detail[AV_ERROR_MAX_STRING_SIZE];
    if (av_strerror(result, detail, sizeof(detail)) < 0) {
        (void)snprintf(detail, sizeof(detail), "FFmpeg error %d", result);
    }
    set_error(state->error, state->error_capacity, "%s: %s", operation, detail);
    return status;
}

static int valid_audio_format(int rate, int channels)
{
    return rate > 0 && rate <= BINK_AUDIO_MAX_SAMPLE_RATE &&
           (channels == 1 || channels == 2);
}

/* Forcing a demuxer bypasses FFmpeg's signature probe, and EOF alone does not
 * distinguish complete Bink input from a truncated final packet. Check both
 * before handing the local path to the demuxer. Bink's size word excludes its
 * first eight bytes; all 907 installed Binks obey this container invariant. */
static int validate_container(const char *path, int64_t file_size,
                               const AVInputFormat *bink_format,
                               char *error, size_t error_capacity)
{
    uint8_t header[64u + AVPROBE_PADDING_SIZE] = {0};
    AVProbeData probe = {0};
    FILE *input = fopen(path, "rb");
    size_t count;
    uint32_t declared;
    int failed;
    int score = 0;

    if (input == NULL) {
        set_error(error, error_capacity, "cannot read local Bink file: %s", strerror(errno));
        return BINK_AUDIO_ERR_FILE;
    }
    count = fread(header, 1u, 64u, input);
    failed = ferror(input);
    (void)fclose(input);
    if (failed) {
        set_error(error, error_capacity, "cannot read local Bink header");
        return BINK_AUDIO_ERR_FILE;
    }
    if (count < 8u) {
        set_error(error, error_capacity, "Bink header is truncated");
        return BINK_AUDIO_ERR_FORMAT;
    }
    probe.filename = "";
    probe.buf = header;
    probe.buf_size = (int)count;
    if (av_probe_input_format3(&probe, 1, &score) != bink_format || score == 0) {
        set_error(error, error_capacity, "input does not have a recognized Bink signature");
        return BINK_AUDIO_ERR_FORMAT;
    }
    declared = (uint32_t)header[4] | ((uint32_t)header[5] << 8u) |
               ((uint32_t)header[6] << 16u) | ((uint32_t)header[7] << 24u);
    if ((int64_t)declared + 8 != file_size) {
        set_error(error, error_capacity,
                  "Bink file length disagrees with its header (truncated or trailing input)");
        return BINK_AUDIO_ERR_FORMAT;
    }
    return BINK_AUDIO_OK;
}

/* Allocate only the retained output, and convert directly into its free tail.
 * No second full-size PCM copy is held by this adapter. */
static int reserve_frames(AudioDecode *state, int additional)
{
    size_t maximum = (size_t)BINK_AUDIO_MAX_PCM_BYTES /
                     ((size_t)state->channels * sizeof(float));
    size_t required;
    size_t capacity;
    float *allocation;

    if (additional < 0 || state->frames > maximum ||
        (size_t)additional > maximum - state->frames) {
        set_error(state->error, state->error_capacity,
                  "decoded Bink PCM exceeds the %zu-byte limit",
                  (size_t)BINK_AUDIO_MAX_PCM_BYTES);
        return BINK_AUDIO_ERR_BOUNDS;
    }
    required = state->frames + (size_t)additional;
    if (required <= state->capacity) {
        return BINK_AUDIO_OK;
    }
    capacity = state->capacity == 0u ? 4096u : state->capacity;
    if (capacity > maximum) {
        capacity = maximum;
    }
    while (capacity < required) {
        capacity = capacity > maximum / 2u ? maximum : capacity * 2u;
    }
    allocation = (float *)realloc(state->pcm,
                                  capacity * (size_t)state->channels * sizeof(float));
    if (allocation == NULL) {
        set_error(state->error, state->error_capacity, "cannot allocate Bink PCM");
        return BINK_AUDIO_ERR_MEMORY;
    }
    state->pcm = allocation;
    state->capacity = capacity;
    return BINK_AUDIO_OK;
}

static int convert_samples(AudioDecode *state, const uint8_t **input, int count)
{
    int limit = swr_get_out_samples(state->converter, count);
    int result;
    uint8_t *destination[1];
    size_t first;
    size_t end;
    int status;

    if (limit < 0) {
        return ffmpeg_failure(state, BINK_AUDIO_ERR_DECODE, limit,
                               "cannot size converted Bink PCM");
    }
    if (limit == 0) {
        return BINK_AUDIO_OK;
    }
    status = reserve_frames(state, limit);
    if (status != BINK_AUDIO_OK) {
        return status;
    }
    first = state->frames * (size_t)state->channels;
    destination[0] = (uint8_t *)(state->pcm + first);
    result = swr_convert(state->converter, destination, limit, input, count);
    if (result < 0) {
        return ffmpeg_failure(state, BINK_AUDIO_ERR_DECODE, result,
                               "cannot convert Bink PCM");
    }
    end = first + (size_t)result * (size_t)state->channels;
    for (size_t i = first; i < end; ++i) {
        if (!isfinite(state->pcm[i])) {
            set_error(state->error, state->error_capacity,
                      "decoded Bink PCM contains a nonfinite sample");
            return BINK_AUDIO_ERR_DECODE;
        }
    }
    state->frames += (size_t)result;
    return BINK_AUDIO_OK;
}

static int append_frame(AudioDecode *state, const AVFrame *frame)
{
    int result;
    if (!valid_audio_format(frame->sample_rate, frame->ch_layout.nb_channels) ||
        frame->sample_rate != state->sample_rate ||
        frame->ch_layout.nb_channels != state->channels ||
        !av_channel_layout_check(&frame->ch_layout) || frame->nb_samples <= 0 ||
        av_get_bytes_per_sample((enum AVSampleFormat)frame->format) <= 0 ||
        frame->extended_data == NULL) {
        set_error(state->error, state->error_capacity,
                  "decoded Bink audio format is invalid or changes during playback");
        return BINK_AUDIO_ERR_UNSUPPORTED;
    }
    if (state->converter == NULL) {
        result = av_channel_layout_copy(&state->layout, &frame->ch_layout);
        if (result < 0) {
            return ffmpeg_failure(state, BINK_AUDIO_ERR_MEMORY, result,
                                   "cannot copy Bink channel layout");
        }
        state->input_format = (enum AVSampleFormat)frame->format;
        result = swr_alloc_set_opts2(&state->converter,
                                      &state->layout, AV_SAMPLE_FMT_FLT, state->sample_rate,
                                      &state->layout, state->input_format, state->sample_rate,
                                      0, NULL);
        if (result < 0) {
            return ffmpeg_failure(state, BINK_AUDIO_ERR_MEMORY, result,
                                   "cannot allocate Bink PCM converter");
        }
        result = swr_init(state->converter);
        if (result < 0) {
            return ffmpeg_failure(state, BINK_AUDIO_ERR_DECODE, result,
                                   "cannot initialize Bink PCM converter");
        }
    } else if (frame->format != state->input_format ||
               av_channel_layout_compare(&state->layout, &frame->ch_layout) != 0) {
        set_error(state->error, state->error_capacity,
                  "Bink audio sample format or channel layout changes during playback");
        return BINK_AUDIO_ERR_UNSUPPORTED;
    }
    return convert_samples(state, (const uint8_t **)frame->extended_data, frame->nb_samples);
}

/* Drain every output frame before the next send, as required by libavcodec.
 * A flushed decoder must reach EOF rather than asking for another packet. */
static int receive_frames(AudioDecode *state, AVCodecContext *codec,
                           AVFrame *frame, int flushing)
{
    int result;
    int status;
    while ((result = avcodec_receive_frame(codec, frame)) >= 0) {
        status = append_frame(state, frame);
        av_frame_unref(frame);
        if (status != BINK_AUDIO_OK) {
            return status;
        }
    }
    if (result == AVERROR_EOF || (result == AVERROR(EAGAIN) && !flushing)) {
        return BINK_AUDIO_OK;
    }
    return ffmpeg_failure(state, BINK_AUDIO_ERR_DECODE, result,
                           "cannot receive Bink audio frame");
}

int bink_audio_decode_file(const char *path, BinkAudio *audio,
                           char *error, size_t error_capacity)
{
    struct stat file_status;
    AVFormatContext *format = NULL;
    AVCodecContext *codec = NULL;
    AVPacket *packet = NULL;
    AVFrame *frame = NULL;
    AVDictionary *options = NULL;
    const AVCodec *decoder;
    const AVInputFormat *bink_format;
    AVCodecParameters *parameters = NULL;
    AudioDecode state = {0};
    int audio_stream = -1;
    int video_streams = 0;
    int audio_streams = 0;
    int result;
    int status = BINK_AUDIO_ERR_DECODE;

    state.error = error;
    state.error_capacity = error_capacity;
    if (error != NULL && error_capacity != 0u) {
        error[0] = '\0';
    }
    if (path == NULL || path[0] == '\0' || audio == NULL) {
        set_error(error, error_capacity, "a local Bink path and empty output are required");
        return BINK_AUDIO_ERR_ARGUMENT;
    }
    if (audio->pcm != NULL || audio->frame_count != 0u ||
        audio->sample_rate != 0u || audio->channels != 0u) {
        set_error(error, error_capacity, "destroy the previous Bink audio before reuse");
        return BINK_AUDIO_ERR_ARGUMENT;
    }
    if (stat(path, &file_status) != 0) {
        set_error(error, error_capacity, "cannot stat local Bink file: %s", strerror(errno));
        return BINK_AUDIO_ERR_FILE;
    }
    if (!S_ISREG(file_status.st_mode)) {
        set_error(error, error_capacity, "Bink input must be a regular local file");
        return BINK_AUDIO_ERR_FILE;
    }
    if (file_status.st_size <= 0 || file_status.st_size > BINK_AUDIO_MAX_INPUT_BYTES) {
        set_error(error, error_capacity,
                  "Bink input size exceeds the supported range (1..%" PRId64 " bytes)",
                  (int64_t)BINK_AUDIO_MAX_INPUT_BYTES);
        return BINK_AUDIO_ERR_BOUNDS;
    }
    bink_format = av_find_input_format("bink");
    if (bink_format == NULL) {
        set_error(error, error_capacity, "FFmpeg has no Bink demuxer");
        return BINK_AUDIO_ERR_UNSUPPORTED;
    }
    status = validate_container(path, file_status.st_size, bink_format,
                                  error, error_capacity);
    if (status != BINK_AUDIO_OK) {
        return status;
    }
    result = av_dict_set(&options, "protocol_whitelist", "file", 0);
    if (result < 0) {
        status = ffmpeg_failure(&state, BINK_AUDIO_ERR_MEMORY, result,
                                 "cannot restrict Bink input to local files");
        goto cleanup;
    }
    /* Bink's demuxer reads all stream parameters from its header. Avoid probing
     * video decoders: this adapter must decode only the soundtrack. */
    result = avformat_open_input(&format, path, bink_format, &options);
    av_dict_free(&options);
    if (result < 0) {
        status = ffmpeg_failure(&state, BINK_AUDIO_ERR_FORMAT, result,
                                 "cannot read Bink header");
        goto cleanup;
    }
    for (unsigned int i = 0; i < format->nb_streams; ++i) {
        AVCodecParameters *candidate = format->streams[i]->codecpar;
        if (candidate->codec_type == AVMEDIA_TYPE_AUDIO) {
            ++audio_streams;
            audio_stream = (int)i;
            parameters = candidate;
        } else if (candidate->codec_type == AVMEDIA_TYPE_VIDEO &&
                   candidate->codec_id == AV_CODEC_ID_BINKVIDEO) {
            ++video_streams;
        }
    }
    if (video_streams != 1) {
        set_error(error, error_capacity, "input does not contain one Bink video stream");
        status = BINK_AUDIO_ERR_FORMAT;
        goto cleanup;
    }
    if (audio_streams > 1) {
        set_error(error, error_capacity,
                  "multiple Bink soundtracks are unsupported; default track selection is unproven");
        status = BINK_AUDIO_ERR_UNSUPPORTED;
        goto cleanup;
    }
    if (audio_streams == 0) {
        status = BINK_AUDIO_NO_SOUNDTRACK;
        goto cleanup;
    }
    if (parameters->codec_id != AV_CODEC_ID_BINKAUDIO_DCT &&
        parameters->codec_id != AV_CODEC_ID_BINKAUDIO_RDFT) {
        set_error(error, error_capacity, "unsupported embedded Bink audio codec");
        status = BINK_AUDIO_ERR_UNSUPPORTED;
        goto cleanup;
    }
    state.sample_rate = parameters->sample_rate;
    state.channels = parameters->ch_layout.nb_channels;
    if (!valid_audio_format(state.sample_rate, state.channels)) {
        set_error(error, error_capacity,
                  "unsupported Bink sample rate or channel count (%d Hz, %d channels)",
                  state.sample_rate, state.channels);
        status = BINK_AUDIO_ERR_BOUNDS;
        goto cleanup;
    }
    decoder = avcodec_find_decoder(parameters->codec_id);
    if (decoder == NULL) {
        set_error(error, error_capacity, "FFmpeg has no embedded Bink audio decoder");
        status = BINK_AUDIO_ERR_UNSUPPORTED;
        goto cleanup;
    }
    codec = avcodec_alloc_context3(decoder);
    packet = av_packet_alloc();
    frame = av_frame_alloc();
    if (codec == NULL || packet == NULL || frame == NULL) {
        set_error(error, error_capacity, "cannot allocate Bink audio decoder buffers");
        status = BINK_AUDIO_ERR_MEMORY;
        goto cleanup;
    }
    result = avcodec_parameters_to_context(codec, parameters);
    if (result < 0) {
        status = ffmpeg_failure(&state, BINK_AUDIO_ERR_DECODE, result,
                                 "cannot configure Bink audio decoder");
        goto cleanup;
    }
    codec->thread_count = 1;
    codec->err_recognition = AV_EF_EXPLODE;
    result = avcodec_open2(codec, decoder, NULL);
    if (result < 0) {
        status = ffmpeg_failure(&state, BINK_AUDIO_ERR_DECODE, result,
                                 "cannot open Bink audio decoder");
        goto cleanup;
    }
    while ((result = av_read_frame(format, packet)) >= 0) {
        if ((packet->flags & AV_PKT_FLAG_CORRUPT) != 0) {
            set_error(error, error_capacity, "Bink input contains a corrupt packet");
            status = BINK_AUDIO_ERR_DECODE;
            goto cleanup;
        }
        if (packet->stream_index == audio_stream) {
            result = avcodec_send_packet(codec, packet);
            av_packet_unref(packet);
            if (result < 0) {
                status = ffmpeg_failure(&state, BINK_AUDIO_ERR_DECODE, result,
                                         "cannot submit Bink audio packet");
                goto cleanup;
            }
            status = receive_frames(&state, codec, frame, 0);
            if (status != BINK_AUDIO_OK) {
                goto cleanup;
            }
        } else {
            av_packet_unref(packet);
        }
    }
    if (result != AVERROR_EOF) {
        status = ffmpeg_failure(&state, BINK_AUDIO_ERR_DECODE, result,
                                 "cannot read Bink audio packet");
        goto cleanup;
    }
    result = avcodec_send_packet(codec, NULL);
    if (result < 0 && result != AVERROR_EOF) {
        status = ffmpeg_failure(&state, BINK_AUDIO_ERR_DECODE, result,
                                 "cannot flush Bink audio decoder");
        goto cleanup;
    }
    status = receive_frames(&state, codec, frame, 1);
    if (status != BINK_AUDIO_OK) {
        goto cleanup;
    }
    if (state.converter != NULL) {
        status = convert_samples(&state, NULL, 0);
        if (status != BINK_AUDIO_OK) {
            goto cleanup;
        }
    }
    if (state.frames == 0u) {
        set_error(error, error_capacity, "Bink soundtrack contains no decoded PCM frames");
        status = BINK_AUDIO_ERR_DECODE;
        goto cleanup;
    }
    audio->pcm = state.pcm;
    audio->frame_count = state.frames;
    audio->sample_rate = (uint32_t)state.sample_rate;
    audio->channels = (uint32_t)state.channels;
    state.pcm = NULL;
    status = BINK_AUDIO_OK;

cleanup:
    free(state.pcm);
    swr_free(&state.converter);
    av_channel_layout_uninit(&state.layout);
    av_frame_free(&frame);
    av_packet_free(&packet);
    avcodec_free_context(&codec);
    avformat_close_input(&format);
    av_dict_free(&options);
    return status;
}

void bink_audio_destroy(BinkAudio *audio)
{
    if (audio != NULL) {
        free(audio->pcm);
        memset(audio, 0, sizeof(*audio));
    }
}
