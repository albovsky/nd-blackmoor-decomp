#include "his_audio.h"

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
#include <libavutil/channel_layout.h>
#include <libavutil/error.h>
#include <libavutil/mem.h>
#include <libavutil/samplefmt.h>
#include <libswresample/swresample.h>

#define HIS_HEADER_BYTES 30u
#define HIS_MAX_INPUT_BYTES (256u * 1024u * 1024u)
#define HIS_MAX_OUTPUT_BYTES (512u * 1024u * 1024u)
#define HIS_MAX_SAMPLE_RATE 192000u
#define HIS_MAX_PADDING_FRAMES 65536u
#define HIS_AVIO_BUFFER_BYTES 32768

typedef struct HisHeader {
    uint32_t sample_rate;
    uint32_t channels;
    uint32_t bytes_per_frame;
    uint32_t decoded_bytes;
    uint16_t bits_per_sample;
    uint16_t storage_kind;
} HisHeader;

typedef struct HisMemoryInput {
    const uint8_t *bytes;
    size_t length;
    size_t position;
} HisMemoryInput;

typedef struct HisDecodeState {
    HisAudio *output;
    uint64_t expected_frames;
    uint64_t decoded_frames;
    uint64_t max_decoded_frames;
    uint32_t channels;
    uint8_t *output_bytes;
    size_t output_capacity;
    size_t output_used;
} HisDecodeState;

static void clear_error(char *error, size_t capacity)
{
    if (error != NULL && capacity > 0u) {
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

static uint16_t read_u16le(const uint8_t *bytes)
{
    return (uint16_t)((uint16_t)bytes[0] | ((uint16_t)bytes[1] << 8));
}

static uint32_t read_u32le(const uint8_t *bytes)
{
    return (uint32_t)bytes[0] |
           ((uint32_t)bytes[1] << 8) |
           ((uint32_t)bytes[2] << 16) |
           ((uint32_t)bytes[3] << 24);
}

static int parse_header(const uint8_t *bytes,
                        size_t length,
                        HisHeader *header,
                        char *error,
                        size_t error_capacity)
{
    uint32_t version;
    uint16_t header_format;
    uint16_t channels;
    uint32_t average_bytes_per_second;
    uint16_t format_bytes_per_frame;
    uint16_t bits_per_sample;
    uint64_t expected_average;
    uint64_t expected_output_bytes;

    if (bytes == NULL || header == NULL || length < HIS_HEADER_BYTES) {
        set_error(error, error_capacity, "HIS input is shorter than its %u-byte header",
                  HIS_HEADER_BYTES);
        return HIS_AUDIO_ERR_FORMAT;
    }
    if (memcmp(bytes, "HIS\0", 4u) != 0) {
        set_error(error, error_capacity, "input does not begin with HIS\\0");
        return HIS_AUDIO_ERR_FORMAT;
    }

    version = read_u32le(bytes + 4u);
    header_format = read_u16le(bytes + 8u);
    channels = read_u16le(bytes + 10u);
    header->sample_rate = read_u32le(bytes + 12u);
    average_bytes_per_second = read_u32le(bytes + 16u);
    format_bytes_per_frame = read_u16le(bytes + 20u);
    bits_per_sample = read_u16le(bytes + 22u);
    header->decoded_bytes = read_u32le(bytes + 24u);
    header->storage_kind = read_u16le(bytes + 28u);

    if (version != 2u || header_format != 1u) {
        set_error(error, error_capacity,
                  "unsupported HIS header version/format (%" PRIu32 "/%u)",
                  version, (unsigned)header_format);
        return HIS_AUDIO_ERR_FORMAT;
    }
    if (channels == 0u || channels > 2u ||
        header->sample_rate == 0u || header->sample_rate > HIS_MAX_SAMPLE_RATE) {
        set_error(error, error_capacity,
                  "HIS channels or sample rate are outside the supported range");
        return HIS_AUDIO_ERR_FORMAT;
    }
    if (bits_per_sample != 8u && bits_per_sample != 16u) {
        set_error(error, error_capacity, "unsupported HIS decoded sample depth: %u bits",
                  (unsigned)bits_per_sample);
        return HIS_AUDIO_ERR_FORMAT;
    }

    header->channels = channels;
    header->bits_per_sample = bits_per_sample;
    header->bytes_per_frame = (uint32_t)channels * (uint32_t)(bits_per_sample / 8u);
    if (format_bytes_per_frame != header->bytes_per_frame) {
        set_error(error, error_capacity,
                  "HIS block alignment %u does not match %u channels at %u bits",
                  (unsigned)format_bytes_per_frame, (unsigned)channels,
                  (unsigned)bits_per_sample);
        return HIS_AUDIO_ERR_FORMAT;
    }
    expected_average = (uint64_t)header->sample_rate * header->bytes_per_frame;
    if (expected_average > UINT32_MAX || average_bytes_per_second != expected_average) {
        set_error(error, error_capacity, "HIS average byte rate is inconsistent with its format");
        return HIS_AUDIO_ERR_FORMAT;
    }
    if (header->decoded_bytes == 0u ||
        header->decoded_bytes % header->bytes_per_frame != 0u) {
        set_error(error, error_capacity, "HIS decoded PCM byte length is empty or misaligned");
        return HIS_AUDIO_ERR_FORMAT;
    }

    expected_output_bytes =
        (uint64_t)(header->decoded_bytes / header->bytes_per_frame) * channels * sizeof(float);
    if (expected_output_bytes > HIS_MAX_OUTPUT_BYTES) {
        set_error(error, error_capacity, "decoded HIS PCM exceeds the adapter memory limit");
        return HIS_AUDIO_ERR_BOUNDS;
    }
    if (length > HIS_MAX_INPUT_BYTES) {
        set_error(error, error_capacity, "HIS input exceeds the adapter memory limit");
        return HIS_AUDIO_ERR_BOUNDS;
    }
    if (header->storage_kind != 1u && header->storage_kind != 2u) {
        set_error(error, error_capacity, "unsupported HIS payload type: %u",
                  (unsigned)header->storage_kind);
        return HIS_AUDIO_ERR_FORMAT;
    }
    if (header->storage_kind == 1u &&
        ((bits_per_sample == 8u && format_bytes_per_frame != channels) ||
         (bits_per_sample == 16u && format_bytes_per_frame != channels * 2u))) {
        set_error(error, error_capacity, "unsupported HIS PCM block alignment");
        return HIS_AUDIO_ERR_FORMAT;
    }

    return HIS_AUDIO_OK;
}

static int decode_pcm(const uint8_t *bytes,
                      size_t length,
                      const HisHeader *header,
                      HisAudio *audio,
                      char *error,
                      size_t error_capacity)
{
    const uint8_t *source = bytes + HIS_HEADER_BYTES;
    size_t payload_bytes = length - HIS_HEADER_BYTES;
    uint64_t expected_frames = header->decoded_bytes / header->bytes_per_frame;
    uint64_t sample_count = expected_frames * header->channels;
    size_t float_bytes;
    float *samples;
    uint64_t sample_index;

    if (payload_bytes != header->decoded_bytes) {
        set_error(error, error_capacity,
                  "raw HIS PCM length is %zu bytes; header declares %" PRIu32,
                  payload_bytes, header->decoded_bytes);
        return HIS_AUDIO_ERR_FORMAT;
    }
    if (sample_count > SIZE_MAX / sizeof(float)) {
        set_error(error, error_capacity, "decoded HIS PCM size overflows this host");
        return HIS_AUDIO_ERR_BOUNDS;
    }
    float_bytes = (size_t)sample_count * sizeof(float);
    samples = (float *)malloc(float_bytes);
    if (samples == NULL) {
        set_error(error, error_capacity, "cannot allocate %zu bytes for HIS PCM", float_bytes);
        return HIS_AUDIO_ERR_MEMORY;
    }

    if (header->bits_per_sample == 8u) {
        for (sample_index = 0u; sample_index < sample_count; ++sample_index) {
            samples[sample_index] = ((float)source[sample_index] - 128.0f) / 128.0f;
        }
    } else {
        for (sample_index = 0u; sample_index < sample_count; ++sample_index) {
            uint16_t raw = read_u16le(source + (size_t)sample_index * 2u);
            int32_t signed_value = raw < 0x8000u ? (int32_t)raw : (int32_t)raw - 0x10000;
            samples[sample_index] = (float)signed_value / 32768.0f;
        }
    }

    audio->sample_rate = header->sample_rate;
    audio->channels = header->channels;
    audio->frame_count = expected_frames;
    audio->interleaved_pcm = samples;
    return HIS_AUDIO_OK;
}

static int memory_read(void *opaque, uint8_t *buffer, int buffer_size)
{
    HisMemoryInput *input = (HisMemoryInput *)opaque;
    size_t remaining;
    size_t requested;

    if (input == NULL || buffer == NULL || buffer_size <= 0) {
        return AVERROR(EINVAL);
    }
    if (input->position >= input->length) {
        return AVERROR_EOF;
    }
    remaining = input->length - input->position;
    requested = (size_t)buffer_size;
    if (requested > remaining) {
        requested = remaining;
    }
    memcpy(buffer, input->bytes + input->position, requested);
    input->position += requested;
    return (int)requested;
}

static int64_t memory_seek(void *opaque, int64_t offset, int whence)
{
    HisMemoryInput *input = (HisMemoryInput *)opaque;
    int origin = whence & ~AVSEEK_FORCE;
    int64_t base;
    int64_t target;

    if (input == NULL) {
        return AVERROR(EINVAL);
    }
    if (origin == AVSEEK_SIZE) {
        return (int64_t)input->length;
    }
    switch (origin) {
        case SEEK_SET:
            base = 0;
            break;
        case SEEK_CUR:
            base = (int64_t)input->position;
            break;
        case SEEK_END:
            base = (int64_t)input->length;
            break;
        default:
            return AVERROR(EINVAL);
    }
    if ((offset > 0 && base > INT64_MAX - offset) ||
        (offset < 0 && base < INT64_MIN - offset)) {
        return AVERROR(EINVAL);
    }
    target = base + offset;
    if (target < 0 || (uint64_t)target > input->length) {
        return AVERROR(EINVAL);
    }
    input->position = (size_t)target;
    return target;
}

static int append_decoded_frame(HisDecodeState *state,
                                SwrContext *resampler,
                                const AVFrame *frame,
                                char *error,
                                size_t error_capacity)
{
    int max_output_frames;
    int output_frames;
    size_t temporary_bytes;
    float *temporary;
    uint8_t *output_planes[1];
    const uint8_t **input_planes;
    uint64_t remaining_target;
    uint64_t frames_to_copy;
    size_t copy_bytes;

    if (frame->nb_samples <= 0 || frame->nb_samples > 1048576) {
        set_error(error, error_capacity, "Vorbis frame sample count is outside the adapter limit");
        return HIS_AUDIO_ERR_BOUNDS;
    }
    max_output_frames = swr_get_out_samples(resampler, frame->nb_samples);
    if (max_output_frames < 0 || max_output_frames > 1048576) {
        set_error(error, error_capacity, "resampled Vorbis frame exceeds the adapter limit");
        return HIS_AUDIO_ERR_BOUNDS;
    }
    if (max_output_frames == 0) {
        return HIS_AUDIO_OK;
    }
    if ((size_t)max_output_frames > SIZE_MAX / state->channels / sizeof(float)) {
        set_error(error, error_capacity, "Vorbis frame allocation overflows this host");
        return HIS_AUDIO_ERR_BOUNDS;
    }
    temporary_bytes = (size_t)max_output_frames * state->channels * sizeof(float);
    temporary = (float *)malloc(temporary_bytes);
    if (temporary == NULL) {
        set_error(error, error_capacity, "cannot allocate %zu bytes for a Vorbis frame",
                  temporary_bytes);
        return HIS_AUDIO_ERR_MEMORY;
    }

    output_planes[0] = (uint8_t *)temporary;
    input_planes = (const uint8_t **)frame->extended_data;
    output_frames = swr_convert(resampler, output_planes, max_output_frames,
                                input_planes, frame->nb_samples);
    if (output_frames < 0) {
        char av_error[AV_ERROR_MAX_STRING_SIZE];
        set_error(error, error_capacity, "cannot convert Vorbis frame to float PCM: %s",
                  av_error_string(output_frames, av_error, sizeof(av_error)));
        free(temporary);
        return HIS_AUDIO_ERR_DECODE;
    }

    if ((uint64_t)output_frames > state->max_decoded_frames - state->decoded_frames) {
        set_error(error, error_capacity, "Vorbis output exceeds the HIS decoded-length allowance");
        free(temporary);
        return HIS_AUDIO_ERR_BOUNDS;
    }
    remaining_target = state->expected_frames - state->output->frame_count;
    frames_to_copy = (uint64_t)output_frames;
    if (frames_to_copy > remaining_target) {
        frames_to_copy = remaining_target;
    }
    if (frames_to_copy > SIZE_MAX / state->channels / sizeof(float)) {
        set_error(error, error_capacity, "Vorbis output size overflows this host");
        free(temporary);
        return HIS_AUDIO_ERR_BOUNDS;
    }
    copy_bytes = (size_t)frames_to_copy * state->channels * sizeof(float);
    if (state->output_used > state->output_capacity ||
        copy_bytes > state->output_capacity - state->output_used) {
        set_error(error, error_capacity, "internal HIS output buffer limit was exceeded");
        free(temporary);
        return HIS_AUDIO_ERR_BOUNDS;
    }
    if (copy_bytes > 0u) {
        memcpy(state->output_bytes + state->output_used, temporary, copy_bytes);
        state->output_used += copy_bytes;
        state->output->frame_count += frames_to_copy;
    }
    state->decoded_frames += (uint64_t)output_frames;
    free(temporary);
    return HIS_AUDIO_OK;
}

static int receive_decoded_frames(AVCodecContext *codec,
                                  AVFrame *frame,
                                  SwrContext *resampler,
                                  HisDecodeState *state,
                                  char *error,
                                  size_t error_capacity)
{
    int result;

    for (;;) {
        result = avcodec_receive_frame(codec, frame);
        if (result == AVERROR(EAGAIN) || result == AVERROR_EOF) {
            return HIS_AUDIO_OK;
        }
        if (result < 0) {
            char av_error[AV_ERROR_MAX_STRING_SIZE];
            set_error(error, error_capacity, "Vorbis decode failed: %s",
                      av_error_string(result, av_error, sizeof(av_error)));
            return HIS_AUDIO_ERR_DECODE;
        }
        result = append_decoded_frame(state, resampler, frame, error, error_capacity);
        av_frame_unref(frame);
        if (result != HIS_AUDIO_OK) {
            return result;
        }
    }
}

static int decode_vorbis(const uint8_t *payload,
                         size_t payload_length,
                         const HisHeader *header,
                         HisAudio *audio,
                         char *error,
                         size_t error_capacity)
{
    HisMemoryInput input;
    HisDecodeState decode_state;
    AVIOContext *io = NULL;
    AVFormatContext *format = NULL;
    AVCodecContext *codec = NULL;
    SwrContext *resampler = NULL;
    AVPacket *packet = NULL;
    AVFrame *frame = NULL;
    const AVCodec *decoder;
    AVStream *stream;
    AVChannelLayout output_layout = { 0 };
    int audio_stream_index = -1;
    int result;
    int status = HIS_AUDIO_ERR_DECODE;
    uint64_t expected_frames;
    uint64_t max_padding;
    size_t output_bytes;
    char av_error[AV_ERROR_MAX_STRING_SIZE];
    unsigned char *io_buffer;

    if (payload_length <= 4u || memcmp(payload, "OggS", 4u) != 0) {
        set_error(error, error_capacity, "HIS Vorbis payload does not start with OggS");
        return HIS_AUDIO_ERR_FORMAT;
    }

    expected_frames = header->decoded_bytes / header->bytes_per_frame;
    if (expected_frames > SIZE_MAX / header->channels / sizeof(float)) {
        set_error(error, error_capacity, "decoded HIS PCM size overflows this host");
        return HIS_AUDIO_ERR_BOUNDS;
    }
    output_bytes = (size_t)expected_frames * header->channels * sizeof(float);
    memset(&decode_state, 0, sizeof(decode_state));
    decode_state.output = audio;
    decode_state.expected_frames = expected_frames;
    decode_state.channels = header->channels;
    decode_state.output_capacity = output_bytes;
    max_padding = header->sample_rate / 2u;
    if (max_padding < HIS_MAX_PADDING_FRAMES) {
        max_padding = HIS_MAX_PADDING_FRAMES;
    }
    if (expected_frames > UINT64_MAX - max_padding) {
        set_error(error, error_capacity, "decoded HIS frame count overflows this host");
        return HIS_AUDIO_ERR_BOUNDS;
    }
    decode_state.max_decoded_frames = expected_frames + max_padding;
    decode_state.output_bytes = (uint8_t *)malloc(output_bytes);
    if (decode_state.output_bytes == NULL) {
        set_error(error, error_capacity, "cannot allocate %zu bytes for decoded HIS PCM",
                  output_bytes);
        return HIS_AUDIO_ERR_MEMORY;
    }

    input.bytes = payload;
    input.length = payload_length;
    input.position = 0u;
    io_buffer = (unsigned char *)av_malloc(HIS_AVIO_BUFFER_BYTES);
    if (io_buffer == NULL) {
        set_error(error, error_capacity, "cannot allocate FFmpeg input buffer");
        status = HIS_AUDIO_ERR_MEMORY;
        goto cleanup;
    }
    io = avio_alloc_context(io_buffer, HIS_AVIO_BUFFER_BYTES, 0, &input,
                            memory_read, NULL, memory_seek);
    if (io == NULL) {
        av_free(io_buffer);
        set_error(error, error_capacity, "cannot allocate FFmpeg memory input");
        status = HIS_AUDIO_ERR_MEMORY;
        goto cleanup;
    }
    format = avformat_alloc_context();
    if (format == NULL) {
        set_error(error, error_capacity, "cannot allocate FFmpeg format context");
        status = HIS_AUDIO_ERR_MEMORY;
        goto cleanup;
    }
    format->pb = io;
    format->flags |= AVFMT_FLAG_CUSTOM_IO;
    format->max_streams = 1;
    result = avformat_open_input(&format, NULL, NULL, NULL);
    if (result < 0) {
        set_error(error, error_capacity, "cannot open HIS Ogg payload: %s",
                  av_error_string(result, av_error, sizeof(av_error)));
        status = HIS_AUDIO_ERR_FORMAT;
        goto cleanup;
    }
    result = avformat_find_stream_info(format, NULL);
    if (result < 0) {
        set_error(error, error_capacity, "cannot inspect HIS Ogg payload: %s",
                  av_error_string(result, av_error, sizeof(av_error)));
        status = HIS_AUDIO_ERR_FORMAT;
        goto cleanup;
    }
    if (format->nb_streams != 1u || format->streams[0]->codecpar->codec_type != AVMEDIA_TYPE_AUDIO) {
        set_error(error, error_capacity, "HIS Ogg payload must contain exactly one audio stream");
        status = HIS_AUDIO_ERR_FORMAT;
        goto cleanup;
    }
    audio_stream_index = av_find_best_stream(format, AVMEDIA_TYPE_AUDIO, -1, -1, NULL, 0);
    if (audio_stream_index < 0) {
        set_error(error, error_capacity, "HIS Ogg payload contains no audio stream");
        status = HIS_AUDIO_ERR_FORMAT;
        goto cleanup;
    }
    stream = format->streams[audio_stream_index];
    if (stream->codecpar->codec_id != AV_CODEC_ID_VORBIS ||
        stream->codecpar->sample_rate != (int)header->sample_rate ||
        stream->codecpar->ch_layout.nb_channels != (int)header->channels) {
        set_error(error, error_capacity,
                  "HIS header metadata does not match the Ogg/Vorbis stream");
        status = HIS_AUDIO_ERR_FORMAT;
        goto cleanup;
    }
    decoder = avcodec_find_decoder(stream->codecpar->codec_id);
    if (decoder == NULL) {
        set_error(error, error_capacity, "FFmpeg has no Vorbis decoder");
        status = HIS_AUDIO_ERR_FORMAT;
        goto cleanup;
    }
    codec = avcodec_alloc_context3(decoder);
    if (codec == NULL) {
        set_error(error, error_capacity, "cannot allocate FFmpeg Vorbis decoder context");
        status = HIS_AUDIO_ERR_MEMORY;
        goto cleanup;
    }
    result = avcodec_parameters_to_context(codec, stream->codecpar);
    if (result < 0) {
        set_error(error, error_capacity, "cannot configure FFmpeg Vorbis decoder");
        status = HIS_AUDIO_ERR_FORMAT;
        goto cleanup;
    }
    result = avcodec_open2(codec, decoder, NULL);
    if (result < 0) {
        set_error(error, error_capacity, "cannot start FFmpeg Vorbis decoder: %s",
                  av_error_string(result, av_error, sizeof(av_error)));
        status = HIS_AUDIO_ERR_DECODE;
        goto cleanup;
    }
    result = av_channel_layout_copy(&output_layout, &codec->ch_layout);
    if (result < 0) {
        set_error(error, error_capacity, "cannot configure the decoded HIS channel layout");
        status = HIS_AUDIO_ERR_MEMORY;
        goto cleanup;
    }
    result = swr_alloc_set_opts2(&resampler, &output_layout, AV_SAMPLE_FMT_FLT,
                                 codec->sample_rate, &codec->ch_layout,
                                 codec->sample_fmt, codec->sample_rate, 0, NULL);
    if (result < 0 || resampler == NULL) {
        set_error(error, error_capacity, "cannot allocate FFmpeg float PCM converter");
        status = result < 0 ? HIS_AUDIO_ERR_MEMORY : HIS_AUDIO_ERR_DECODE;
        goto cleanup;
    }
    result = swr_init(resampler);
    if (result < 0) {
        set_error(error, error_capacity, "cannot initialize FFmpeg float PCM converter");
        status = HIS_AUDIO_ERR_DECODE;
        goto cleanup;
    }

    packet = av_packet_alloc();
    frame = av_frame_alloc();
    if (packet == NULL || frame == NULL) {
        set_error(error, error_capacity, "cannot allocate FFmpeg packet/frame buffers");
        status = HIS_AUDIO_ERR_MEMORY;
        goto cleanup;
    }
    for (;;) {
        result = av_read_frame(format, packet);
        if (result == AVERROR_EOF) {
            break;
        }
        if (result < 0) {
            set_error(error, error_capacity, "cannot read HIS Ogg packet: %s",
                      av_error_string(result, av_error, sizeof(av_error)));
            status = HIS_AUDIO_ERR_DECODE;
            goto cleanup;
        }
        if (packet->stream_index == audio_stream_index) {
            result = avcodec_send_packet(codec, packet);
            if (result == AVERROR(EAGAIN)) {
                status = receive_decoded_frames(codec, frame, resampler, &decode_state,
                                                error, error_capacity);
                if (status != HIS_AUDIO_OK) {
                    av_packet_unref(packet);
                    goto cleanup;
                }
                result = avcodec_send_packet(codec, packet);
            }
            if (result < 0) {
                set_error(error, error_capacity, "cannot submit HIS Ogg packet: %s",
                          av_error_string(result, av_error, sizeof(av_error)));
                status = HIS_AUDIO_ERR_DECODE;
                av_packet_unref(packet);
                goto cleanup;
            }
            status = receive_decoded_frames(codec, frame, resampler, &decode_state,
                                            error, error_capacity);
            if (status != HIS_AUDIO_OK) {
                av_packet_unref(packet);
                goto cleanup;
            }
        }
        av_packet_unref(packet);
    }

    result = avcodec_send_packet(codec, NULL);
    if (result < 0 && result != AVERROR_EOF) {
        set_error(error, error_capacity, "cannot flush HIS Vorbis decoder: %s",
                  av_error_string(result, av_error, sizeof(av_error)));
        status = HIS_AUDIO_ERR_DECODE;
        goto cleanup;
    }
    status = receive_decoded_frames(codec, frame, resampler, &decode_state,
                                    error, error_capacity);
    if (status != HIS_AUDIO_OK) {
        goto cleanup;
    }
    for (;;) {
        int pending = swr_get_out_samples(resampler, 0);
        float *flush_buffer;
        uint8_t *flush_planes[1];
        int flushed;
        uint64_t remaining_target;
        uint64_t copy_frames;
        size_t copy_bytes;
        size_t flush_bytes;

        if (pending <= 0) {
            break;
        }
        if (pending > 1048576 || (size_t)pending > SIZE_MAX / header->channels / sizeof(float)) {
            set_error(error, error_capacity, "Vorbis resampler flush exceeds the adapter limit");
            status = HIS_AUDIO_ERR_BOUNDS;
            goto cleanup;
        }
        flush_bytes = (size_t)pending * header->channels * sizeof(float);
        flush_buffer = (float *)malloc(flush_bytes);
        if (flush_buffer == NULL) {
            set_error(error, error_capacity, "cannot allocate Vorbis resampler flush buffer");
            status = HIS_AUDIO_ERR_MEMORY;
            goto cleanup;
        }
        flush_planes[0] = (uint8_t *)flush_buffer;
        flushed = swr_convert(resampler, flush_planes, pending, NULL, 0);
        if (flushed < 0) {
            set_error(error, error_capacity, "cannot flush Vorbis resampler: %s",
                      av_error_string(flushed, av_error, sizeof(av_error)));
            free(flush_buffer);
            status = HIS_AUDIO_ERR_DECODE;
            goto cleanup;
        }
        if ((uint64_t)flushed > decode_state.max_decoded_frames - decode_state.decoded_frames) {
            set_error(error, error_capacity, "Vorbis resampler output exceeds the HIS decoded length");
            free(flush_buffer);
            status = HIS_AUDIO_ERR_BOUNDS;
            goto cleanup;
        }
        remaining_target = decode_state.expected_frames - audio->frame_count;
        copy_frames = (uint64_t)flushed;
        if (copy_frames > remaining_target) {
            copy_frames = remaining_target;
        }
        copy_bytes = (size_t)copy_frames * header->channels * sizeof(float);
        if (decode_state.output_used > decode_state.output_capacity ||
            copy_bytes > decode_state.output_capacity - decode_state.output_used) {
            set_error(error, error_capacity, "internal HIS output buffer limit was exceeded");
            free(flush_buffer);
            status = HIS_AUDIO_ERR_BOUNDS;
            goto cleanup;
        }
        if (copy_bytes > 0u) {
            memcpy(decode_state.output_bytes + decode_state.output_used, flush_buffer, copy_bytes);
            decode_state.output_used += copy_bytes;
            audio->frame_count += copy_frames;
        }
        decode_state.decoded_frames += (uint64_t)flushed;
        free(flush_buffer);
        if (flushed == 0) {
            break;
        }
    }

    if (audio->frame_count != expected_frames ||
        decode_state.output_used != output_bytes) {
        set_error(error, error_capacity,
                  "Vorbis produced %" PRIu64 " of %" PRIu64 " declared HIS frames",
                  audio->frame_count, expected_frames);
        status = HIS_AUDIO_ERR_DECODE;
        goto cleanup;
    }

    audio->sample_rate = header->sample_rate;
    audio->channels = header->channels;
    audio->interleaved_pcm = (float *)decode_state.output_bytes;
    decode_state.output_bytes = NULL;
    status = HIS_AUDIO_OK;

cleanup:
    free(decode_state.output_bytes);
    av_packet_free(&packet);
    av_frame_free(&frame);
    swr_free(&resampler);
    av_channel_layout_uninit(&output_layout);
    avcodec_free_context(&codec);
    if (format != NULL) {
        avformat_close_input(&format);
    }
    if (io != NULL) {
        av_freep(&io->buffer);
    }
    avio_context_free(&io);
    return status;
}

int his_audio_decode_memory(const uint8_t *bytes,
                            size_t length,
                            HisAudio *audio,
                            char *error,
                            size_t error_capacity)
{
    HisHeader header;
    int status;

    clear_error(error, error_capacity);
    if (audio != NULL) {
        memset(audio, 0, sizeof(*audio));
    }
    if (bytes == NULL || audio == NULL) {
        set_error(error, error_capacity, "HIS bytes and output storage are required");
        return HIS_AUDIO_ERR_ARGUMENT;
    }
    if (length == 0u || length > HIS_MAX_INPUT_BYTES) {
        set_error(error, error_capacity, "HIS input length is outside the supported range");
        return HIS_AUDIO_ERR_BOUNDS;
    }
    status = parse_header(bytes, length, &header, error, error_capacity);
    if (status != HIS_AUDIO_OK) {
        return status;
    }
    if (header.storage_kind == 1u) {
        return decode_pcm(bytes, length, &header, audio, error, error_capacity);
    }
    status = decode_vorbis(bytes + HIS_HEADER_BYTES, length - HIS_HEADER_BYTES,
                           &header, audio, error, error_capacity);
    if (status != HIS_AUDIO_OK) {
        memset(audio, 0, sizeof(*audio));
    }
    return status;
}

int his_audio_decode_file(const char *path,
                          HisAudio *audio,
                          char *error,
                          size_t error_capacity)
{
    struct stat file_status;
    FILE *file = NULL;
    uint8_t *bytes = NULL;
    size_t length;
    size_t bytes_read;
    int extra_byte;
    int status = HIS_AUDIO_ERR_FILE;

    clear_error(error, error_capacity);
    if (audio != NULL) {
        memset(audio, 0, sizeof(*audio));
    }
    if (path == NULL || path[0] == '\0' || audio == NULL) {
        set_error(error, error_capacity, "a local HIS path and output storage are required");
        return HIS_AUDIO_ERR_ARGUMENT;
    }
    file = fopen(path, "rb");
    if (file == NULL) {
        set_error(error, error_capacity, "cannot open HIS file: %s", strerror(errno));
        return HIS_AUDIO_ERR_FILE;
    }
    if (fstat(fileno(file), &file_status) != 0 || !S_ISREG(file_status.st_mode)) {
        set_error(error, error_capacity, "HIS input is not a readable regular local file");
        goto cleanup;
    }
    if (file_status.st_size <= 0 ||
        (uint64_t)file_status.st_size > HIS_MAX_INPUT_BYTES) {
        set_error(error, error_capacity, "HIS file size is outside the adapter limit");
        status = HIS_AUDIO_ERR_BOUNDS;
        goto cleanup;
    }
    length = (size_t)file_status.st_size;
    bytes = (uint8_t *)malloc(length);
    if (bytes == NULL) {
        set_error(error, error_capacity, "cannot allocate %zu bytes for the HIS file", length);
        status = HIS_AUDIO_ERR_MEMORY;
        goto cleanup;
    }
    bytes_read = fread(bytes, 1u, length, file);
    extra_byte = fgetc(file);
    if (bytes_read != length || extra_byte != EOF || ferror(file)) {
        set_error(error, error_capacity, "HIS file changed or could not be read completely");
        status = HIS_AUDIO_ERR_FILE;
        goto cleanup;
    }
    status = his_audio_decode_memory(bytes, length, audio, error, error_capacity);

cleanup:
    free(bytes);
    (void)fclose(file);
    return status;
}

void his_audio_destroy(HisAudio *audio)
{
    if (audio == NULL) {
        return;
    }
    free(audio->interleaved_pcm);
    memset(audio, 0, sizeof(*audio));
}

const char *his_audio_status_string(int status)
{
    switch (status) {
        case HIS_AUDIO_OK:
            return "ok";
        case HIS_AUDIO_ERR_ARGUMENT:
            return "invalid argument";
        case HIS_AUDIO_ERR_FILE:
            return "file error";
        case HIS_AUDIO_ERR_FORMAT:
            return "unsupported or malformed HIS input";
        case HIS_AUDIO_ERR_DECODE:
            return "audio decode error";
        case HIS_AUDIO_ERR_MEMORY:
            return "memory allocation error";
        case HIS_AUDIO_ERR_BOUNDS:
            return "HIS adapter limit exceeded";
        default:
            return "unknown HIS audio error";
    }
}
