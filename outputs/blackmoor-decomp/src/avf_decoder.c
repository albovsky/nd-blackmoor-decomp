#include "avf_decoder.h"

#include <string.h>

/*
 * Recovered from GAME.EXE (SHA-256 afd337a2...5c45). See avf_decoder.h for
 * the address map and the failure contract. Every decode validates first and
 * writes second, so an error never leaves a partly decoded frame behind.
 */

static const uint8_t k_signature[15] = {
    'A', 'V', 'F', ' ', 'W', 'a', 'y', 'n', 'e', 'S', 'i', 'k', 'e', 's', 0
};

static uint16_t rd16(const uint8_t *p)
{
    return (uint16_t)(p[0] | (p[1] << 8));
}

static uint32_t rd32(const uint8_t *p)
{
    return (uint32_t)p[0] | ((uint32_t)p[1] << 8) | ((uint32_t)p[2] << 16) |
           ((uint32_t)p[3] << 24);
}

static void wr16(uint8_t *p, uint16_t value)
{
    p[0] = (uint8_t)value;
    p[1] = (uint8_t)(value >> 8);
}

static void parse_record(const uint8_t *p, AvfRecord *record)
{
    record->index = rd16(p);
    record->offset = rd32(p + 0x2);
    record->packed_bytes = rd32(p + 0x6);
    record->unpacked_bytes = rd32(p + 0xa);
    record->type = p[0xe];
    record->reserved = rd32(p + 0xf);
}

/* ------------------------------------------------------------------------ */
/* Container: 0x414ceb                                                      */
/* ------------------------------------------------------------------------ */

AvfStatus avf_open(const uint8_t *data, size_t size, AvfFile *file)
{
    int16_t count;
    int16_t width;
    int16_t height;
    size_t table_end;
    uint32_t max_unpacked = 0;
    int32_t index;

    if (file == NULL || (data == NULL && size != 0)) {
        return AVF_ERR_ARGUMENT;
    }
    memset(file, 0, sizeof(*file));
    /* The original copies 33 header bytes from the mapped view. */
    if (size < AVF_HEADER_BYTES) {
        return AVF_ERR_TRUNCATED;
    }
    if (memcmp(data, k_signature, sizeof(k_signature)) != 0) {
        return AVF_ERR_SIGNATURE;
    }
    if ((int16_t)rd16(data + 0x10) != 2 || (int16_t)rd16(data + 0x12) != 0) {
        return AVF_ERR_VERSION;
    }
    count = (int16_t)rd16(data + 0x15);
    width = (int16_t)rd16(data + 0x17);
    height = (int16_t)rd16(data + 0x19);
    /* Native rejections: the original sizes allocations from these fields. */
    if (count < 0 || width <= 0 || height <= 0) {
        return AVF_ERR_CORRUPT;
    }
    if (data[0x1b] != 16) {
        return AVF_ERR_UNSUPPORTED;
    }
    table_end = AVF_HEADER_BYTES + (size_t)count * AVF_RECORD_BYTES;
    if (table_end > size) {
        return AVF_ERR_TRUNCATED;
    }
    for (index = 0; index < count; ++index) {
        uint32_t unpacked = rd32(data + AVF_HEADER_BYTES + (size_t)index * AVF_RECORD_BYTES + 0xa);
        if (unpacked > max_unpacked) {
            max_unpacked = unpacked;
        }
    }
    file->data = data;
    file->size = size;
    file->frame_count = count;
    file->width = width;
    file->height = height;
    file->bits_per_pixel = data[0x1b];
    file->header_1c = rd32(data + 0x1c);
    file->compression = data[0x20];
    /* +0x41 = width * height * (bpp >> 3); at most 32767 * 32767 * 2. */
    file->frame_bytes = (uint32_t)width * (uint32_t)height * 2u;
    file->max_unpacked = max_unpacked;
    return AVF_OK;
}

AvfStatus avf_record(const AvfFile *file, int32_t index, AvfRecord *record)
{
    if (file == NULL || file->data == NULL || record == NULL) {
        return AVF_ERR_ARGUMENT;
    }
    if (index < 0 || index >= file->frame_count) {
        return AVF_ERR_RANGE;
    }
    parse_record(file->data + AVF_HEADER_BYTES + (size_t)index * AVF_RECORD_BYTES, record);
    return AVF_OK;
}

/* ------------------------------------------------------------------------ */
/* Counter-obfuscated LZSS: 0x415db9                                        */
/* ------------------------------------------------------------------------ */

AvfStatus avf_lzss_expand(const uint8_t *src, uint32_t src_bytes,
                          uint8_t *dst, size_t dst_capacity,
                          AvfLzssState *state)
{
    /* 4 KiB ring: 0xfee bytes of ' ', 18 bytes the original never sets. */
    uint8_t ring[AVF_RING_BYTES];
    uint8_t defined[AVF_RING_BYTES];
    uint32_t position = AVF_RING_START;
    uint32_t flags = 0;
    uint8_t counter = 0;
    int64_t input = -1;
    size_t produced = 0;
    AvfStatus status = AVF_OK;

    if (src == NULL && src_bytes != 0) {
        return AVF_ERR_ARGUMENT;
    }
    memset(ring, ' ', AVF_RING_START);
    memset(ring + AVF_RING_START, 0, AVF_RING_BYTES - AVF_RING_START);
    memset(defined, 1, AVF_RING_START);
    memset(defined + AVF_RING_START, 0, AVF_RING_BYTES - AVF_RING_START);

    for (;;) {
        uint8_t lo;
        uint8_t hi;
        uint32_t offset;
        uint32_t length;
        uint32_t k;

        flags >>= 1;
        if ((flags & 0x100u) == 0) {
            if (++input == (int64_t)src_bytes) {
                break;
            }
            flags = 0xff00u | (uint8_t)(src[input] - counter);
            ++counter;
        }
        if ((flags & 1u) != 0) {
            uint8_t value;
            if (++input == (int64_t)src_bytes) {
                break;
            }
            value = (uint8_t)(src[input] - counter);
            ++counter;
            if (produced >= dst_capacity) {
                status = AVF_ERR_CORRUPT;
                break;
            }
            if (dst != NULL) {
                dst[produced] = value;
            }
            ++produced;
            ring[position] = value;
            defined[position] = 1;
            position = (position + 1u) & (AVF_RING_BYTES - 1u);
            continue;
        }
        if (++input == (int64_t)src_bytes) {
            break;
        }
        lo = (uint8_t)(src[input] - counter);
        ++counter;
        if (++input == (int64_t)src_bytes) {
            break;
        }
        hi = (uint8_t)(src[input] - counter);
        ++counter;
        offset = (uint32_t)lo | (((uint32_t)hi & 0xf0u) << 4);
        length = ((uint32_t)hi & 0xfu) + 3u;
        for (k = 0; k < length; ++k) {
            uint32_t from = (offset + k) & (AVF_RING_BYTES - 1u);
            uint8_t value;
            /* Native rejection: the original reads uninitialized stack. */
            if (!defined[from] || produced >= dst_capacity) {
                status = AVF_ERR_CORRUPT;
                break;
            }
            value = ring[from];
            if (dst != NULL) {
                dst[produced] = value;
            }
            ++produced;
            ring[position] = value;
            defined[position] = 1;
            position = (position + 1u) & (AVF_RING_BYTES - 1u);
        }
        if (status != AVF_OK) {
            break;
        }
    }

    if (state != NULL) {
        memcpy(state->ring, ring, sizeof(ring));
        memcpy(state->ring_defined, defined, sizeof(defined));
        state->ring_position = position;
        state->counter = counter;
        state->flag_bits = flags;
        state->input_position = (int32_t)input;
        state->produced = (uint32_t)produced;
    }
    return status;
}

/* ------------------------------------------------------------------------ */
/* Command expansion: 0x416af3 with fill helper 0x43ef77                    */
/* ------------------------------------------------------------------------ */

static void convert_span(const AvfStream *stream, uint8_t *pixels, uint32_t byte_count)
{
    /* 0x4c7314 converts byte_count >> 1 words; below two bytes it is a no-op. */
    if (stream->convert != NULL && byte_count >= 2u) {
        stream->convert(stream->convert_context, pixels, byte_count);
    }
}

/* Destination byte offset of a pixel index: 32-bit pointer arithmetic wraps. */
static uint32_t pixel_offset(uint32_t pixel)
{
    return pixel * 2u;
}

static int span_fits(uint32_t offset, uint64_t bytes, uint32_t frame_bytes)
{
    return bytes == 0 || (uint64_t)offset + bytes <= frame_bytes;
}

/* 0x43ef77: store `count` 16-bit words of `value` (a signed count; zero or negative stores nothing). */
static void fill16(uint8_t *dst, uint16_t value, int32_t count)
{
    int32_t k;
    for (k = 0; k < count; ++k) {
        wr16(dst + (uint64_t)k * 2u, value);
    }
}

/*
 * One traversal shared by validation (apply == 0, dst unused) and output.
 * Type 2 converts every written span; type 1 converts nothing here.
 */
static AvfStatus run_commands(const AvfStream *stream, const uint8_t *cmd, uint32_t size,
                              uint8_t type, uint8_t *dst, uint32_t frame_bytes, int apply)
{
    uint64_t pos = 0;

    while (pos < size) {
        uint8_t op = cmd[pos];

        if (op == AVF_CMD_COPY) {
            uint32_t offset;
            uint64_t bytes;
            if (pos + 9u > size) {
                return AVF_ERR_CORRUPT;
            }
            offset = pixel_offset(rd32(cmd + pos + 1));
            /* Copy length, conversion length and advance all drop bit 31. */
            bytes = (uint64_t)(rd32(cmd + pos + 5) & 0x7fffffffu) * 2u;
            if (pos + 9u + bytes > size || !span_fits(offset, bytes, frame_bytes)) {
                return AVF_ERR_CORRUPT;
            }
            if (apply && bytes != 0) {
                memcpy(dst + offset, cmd + pos + 9, (size_t)bytes);
                if (type == AVF_TYPE_DELTA) {
                    convert_span(stream, dst + offset, (uint32_t)bytes);
                }
            }
            pos += 9u + bytes;
        } else if (op == AVF_CMD_FILL) {
            uint16_t value;
            uint32_t offset;
            int32_t count;
            uint64_t fill_bytes;
            uint32_t convert_bytes = 0;
            uint64_t span;
            if (pos + 11u > size) {
                return AVF_ERR_CORRUPT;
            }
            value = rd16(cmd + pos + 1);
            offset = pixel_offset(rd32(cmd + pos + 3));
            count = (int32_t)rd32(cmd + pos + 7);
            /*
             * 0x43ef77 compares signed; type 2 converts (uint32)(count << 1),
             * which 0x4c7314 skips entirely when conversion is disabled.
             */
            fill_bytes = count > 0 ? (uint64_t)count * 2u : 0u;
            if (type == AVF_TYPE_DELTA && stream->convert != NULL) {
                convert_bytes = (uint32_t)count << 1;
            }
            span = fill_bytes > convert_bytes ? fill_bytes : convert_bytes;
            if (!span_fits(offset, span, frame_bytes)) {
                return AVF_ERR_CORRUPT;
            }
            if (apply) {
                fill16(dst + offset, value, count);
                if (convert_bytes >= 2u) {
                    convert_span(stream, dst + offset, convert_bytes);
                }
            }
            pos += 11u;
        } else if (op == AVF_CMD_REPEAT) {
            uint32_t bytes;
            int32_t runs;
            uint64_t data;
            uint64_t table;
            uint32_t run_count;
            uint32_t run;
            if (pos + 6u > size) {
                return AVF_ERR_CORRUPT;
            }
            bytes = (uint32_t)cmd[pos + 1] * 2u;
            runs = (int32_t)rd32(cmd + pos + 2);
            run_count = runs > 0 ? (uint32_t)runs : 0u;
            data = pos + 6u;
            table = data + bytes;
            if (table + (uint64_t)run_count * 4u > size) {
                return AVF_ERR_CORRUPT;
            }
            for (run = 0; run < run_count; ++run) {
                uint32_t offset = pixel_offset(rd32(cmd + table + (uint64_t)run * 4u));
                if (!span_fits(offset, bytes, frame_bytes)) {
                    return AVF_ERR_CORRUPT;
                }
                if (apply && bytes != 0) {
                    memcpy(dst + offset, cmd + data, bytes);
                    if (type == AVF_TYPE_DELTA) {
                        convert_span(stream, dst + offset, bytes);
                    }
                }
            }
            pos = table + (uint64_t)run_count * 4u;
        } else {
            /* The original never advances: an endless loop. */
            return AVF_ERR_UNSUPPORTED;
        }
    }
    return AVF_OK;
}

/* ------------------------------------------------------------------------ */
/* Readers: 0x41546f, 0x4156ea, 0x415176                                    */
/* ------------------------------------------------------------------------ */

static int is_empty(const AvfRecord *record)
{
    return record->packed_bytes == 0 && record->unpacked_bytes == 0;
}

static uint16_t type_flag(uint8_t type)
{
    return type == AVF_TYPE_KEY ? AVF_FLAG_KEY
         : type == AVF_TYPE_FULL ? AVF_FLAG_FULL : AVF_FLAG_DELTA;
}

static AvfStatus load(const AvfStream *stream, int16_t index, AvfRecord *record)
{
    if (stream == NULL || stream->file == NULL || stream->file->data == NULL) {
        return AVF_ERR_ARGUMENT;
    }
    return avf_record(stream->file, index, record);
}

/*
 * Checks shared by every non-empty record, in original order: the chunk
 * read (0x4159db: compression byte), then the record type.
 */
static AvfStatus check_data(const AvfStream *stream, const AvfRecord *record)
{
    const AvfFile *file = stream->file;

    if ((uint64_t)record->offset + record->packed_bytes > file->size) {
        return AVF_ERR_TRUNCATED;
    }
    if (file->compression != 2) {
        return AVF_ERR_UNSUPPORTED;
    }
    if (record->unpacked_bytes > 0x7fffffffu || record->packed_bytes > 0x7fffffffu) {
        return AVF_ERR_CORRUPT;
    }
    if (record->type > AVF_TYPE_DELTA) {
        return AVF_ERR_UNSUPPORTED;
    }
    return AVF_OK;
}

static const uint8_t *packed(const AvfStream *stream, const AvfRecord *record)
{
    return stream->file->data + record->offset;
}

/*
 * Types 1/2 expand into scratch and then read it as commands, so the
 * stream must fill exactly unpacked_bytes (native rejection: the original
 * would read uninitialized heap bytes).
 */
static AvfStatus expand_exact(const AvfStream *stream, const AvfRecord *record,
                              uint8_t *dst, AvfLzssState *lzss)
{
    AvfLzssState local;
    AvfLzssState *state = lzss != NULL ? lzss : &local;
    AvfStatus status = avf_lzss_expand(packed(stream, record), record->packed_bytes, dst,
                                       record->unpacked_bytes, state);
    if (status != AVF_OK) {
        return status;
    }
    return state->produced == record->unpacked_bytes ? AVF_OK : AVF_ERR_CORRUPT;
}

/*
 * Type 0 into dst: dry run, then output and the 0x4c7314 call over
 * unpacked_bytes. The original decompresses until the input ends, so any
 * output length up to `capacity` (the destination allocation) is valid;
 * bytes it does not write keep their previous contents. The caller ensures
 * unpacked_bytes <= capacity.
 */
static AvfStatus decode_key(const AvfStream *stream, const AvfRecord *record, uint8_t *dst,
                            size_t capacity, AvfLzssState *lzss)
{
    AvfStatus status = avf_lzss_expand(packed(stream, record), record->packed_bytes, NULL,
                                       capacity, NULL);
    if (status != AVF_OK) {
        return status;
    }
    status = avf_lzss_expand(packed(stream, record), record->packed_bytes, dst, capacity, lzss);
    if (status != AVF_OK) {
        return status;
    }
    convert_span(stream, dst, record->unpacked_bytes);
    return AVF_OK;
}

/* Single/double: key frames decompress into the frame buffer itself. */
static AvfStatus decode_key_frame(const AvfStream *stream, const AvfRecord *record,
                                  uint8_t *dst, AvfLzssState *lzss)
{
    /*
     * The original decompresses into the frame buffer (bounded by the frame
     * size) and then calls 0x4c7314(buffer, unpacked_bytes), which converts
     * unpacked_bytes >> 1 words and returns at once when conversion is
     * disabled. A declared size above the frame is therefore valid without a
     * conversion hook, and with one only the touched extent
     * (unpacked_bytes >> 1) * 2 must fit. Native rejection otherwise: the
     * original would convert past the frame. Checked before any write.
     */
    if (stream->convert != NULL &&
        (uint64_t)(record->unpacked_bytes >> 1) * 2u > stream->file->frame_bytes) {
        return AVF_ERR_CORRUPT;
    }
    return decode_key(stream, record, dst, stream->file->frame_bytes, lzss);
}

/*
 * Types 1/2 (0x416af3). `previous` is copied first for type 2 when non-NULL
 * (param_6 == 0); single mode passes NULL because dst already holds it.
 */
static AvfStatus decode_commands(const AvfStream *stream, const AvfRecord *record, uint8_t *dst,
                                 const uint8_t *previous, AvfLzssState *lzss)
{
    uint32_t frame_bytes = stream->file->frame_bytes;
    AvfStatus status;

    if (stream->scratch == NULL || stream->scratch_bytes < record->unpacked_bytes) {
        return AVF_ERR_ARGUMENT;
    }
    status = expand_exact(stream, record, stream->scratch, lzss);
    if (status != AVF_OK) {
        return status;
    }
    status = run_commands(stream, stream->scratch, record->unpacked_bytes, record->type, dst,
                          frame_bytes, 0);
    if (status != AVF_OK) {
        return status;
    }
    if (record->type == AVF_TYPE_DELTA && previous != NULL && previous != dst) {
        memmove(dst, previous, frame_bytes);
    }
    run_commands(stream, stream->scratch, record->unpacked_bytes, record->type, dst,
                 frame_bytes, 1);
    if (record->type == AVF_TYPE_FULL) {
        convert_span(stream, dst, frame_bytes);
    }
    return AVF_OK;
}

AvfStatus avf_stream_init(AvfStream *stream, const AvfFile *file,
                          uint8_t *buffer0, uint8_t *buffer1, size_t buffer_bytes,
                          uint8_t *scratch, size_t scratch_bytes,
                          AvfConvertFn convert, void *convert_context)
{
    if (stream == NULL || file == NULL || file->data == NULL || buffer0 == NULL ||
        buffer_bytes < file->frame_bytes || (scratch == NULL && scratch_bytes != 0)) {
        return AVF_ERR_ARGUMENT;
    }
    memset(stream, 0, sizeof(*stream));
    stream->file = file;
    stream->buffers[0] = buffer0;
    stream->buffers[1] = buffer1;
    stream->buffer_bytes = buffer_bytes;
    stream->scratch = scratch;
    stream->scratch_bytes = scratch_bytes;
    stream->convert = convert;
    stream->convert_context = convert_context;
    avf_stream_reset(stream);
    return AVF_OK;
}

void avf_stream_reset(AvfStream *stream)
{
    if (stream == NULL) {
        return;
    }
    stream->last_index = -1;
    stream->toggle = 0;
    stream->flags[0] = 0;
    stream->flags[1] = 0;
    stream->chunk_previous = NULL;
    stream->chunk_previous_bytes = 0;
}

static int follows(int32_t last_index, int16_t index)
{
    return last_index != -1 && last_index == (int32_t)index - 1;
}

/* 0x41546f: single-buffer record decode (type 0 key, 1 and 2 command streams, empty record). */
AvfStatus avf_decode_single(AvfStream *stream, int16_t index, AvfLzssState *lzss)
{
    AvfRecord record;
    AvfStatus status = load(stream, index, &record);
    uint8_t *dst;

    if (status != AVF_OK) {
        return status;
    }
    if (record.type == AVF_TYPE_DELTA && !follows(stream->last_index, index)) {
        return AVF_ERR_SEQUENCE;
    }
    if (is_empty(&record)) {
        stream->flags[0] = AVF_FLAG_NO_DATA;
        stream->last_index = index;
        return AVF_OK;
    }
    status = check_data(stream, &record);
    if (status != AVF_OK) {
        return status;
    }
    dst = stream->buffers[0];
    status = record.type == AVF_TYPE_KEY
        ? decode_key_frame(stream, &record, dst, lzss)
        : decode_commands(stream, &record, dst, NULL, lzss);
    if (status != AVF_OK) {
        return status;
    }
    stream->flags[0] = type_flag(record.type);
    stream->last_index = index;
    return AVF_OK;
}

/* 0x4156ea: double-buffer record decode; the buffer toggles only on a non-empty success. */
AvfStatus avf_decode_double(AvfStream *stream, int16_t index, int *written,
                            AvfLzssState *lzss)
{
    AvfRecord record;
    AvfStatus status = load(stream, index, &record);
    int slot;
    uint8_t *dst;
    const uint8_t *previous;

    if (status != AVF_OK) {
        return status;
    }
    if (stream->buffers[1] == NULL) {
        return AVF_ERR_ARGUMENT;
    }
    /* toggle 0: write +0x17e (flags +0x184), predecessor +0x17a. */
    slot = stream->toggle == 0 ? 1 : 0;
    dst = stream->buffers[slot];
    previous = stream->buffers[1 - slot];
    if (record.type == AVF_TYPE_DELTA && !follows(stream->last_index, index)) {
        return AVF_ERR_SEQUENCE;
    }
    if (is_empty(&record)) {
        stream->flags[slot] = AVF_FLAG_NO_DATA;
        stream->last_index = index;
        if (written != NULL) {
            *written = slot;
        }
        return AVF_OK;
    }
    status = check_data(stream, &record);
    if (status != AVF_OK) {
        return status;
    }
    status = record.type == AVF_TYPE_KEY
        ? decode_key_frame(stream, &record, dst, lzss)
        : decode_commands(stream, &record, dst, previous, lzss);
    if (status != AVF_OK) {
        return status;
    }
    stream->flags[slot] = type_flag(record.type);
    stream->last_index = index;
    stream->toggle = (uint16_t)(stream->toggle == 0);
    if (written != NULL) {
        *written = slot;
    }
    return AVF_OK;
}

/* 0x415176: chunk fetch (key frame, or delta after its predecessor). */
AvfStatus avf_get_chunk(AvfStream *stream, int16_t index,
                        uint8_t *out, size_t out_capacity,
                        const uint8_t *override_previous, size_t override_previous_bytes,
                        int16_t override_index,
                        uint16_t *flags,
                        const uint8_t **result, size_t *result_bytes,
                        AvfLzssState *lzss)
{
    AvfRecord record;
    AvfStatus status = load(stream, index, &record);
    const uint8_t *previous;
    size_t previous_bytes;
    int32_t last_index;
    size_t out_bytes;

    if (status != AVF_OK) {
        return status;
    }
    if (out == NULL || result == NULL || result_bytes == NULL) {
        return AVF_ERR_ARGUMENT;
    }
    previous = stream->chunk_previous;
    previous_bytes = stream->chunk_previous_bytes;
    last_index = stream->last_index;
    if (override_previous != NULL && override_index != 0) {
        previous = override_previous;
        previous_bytes = override_previous_bytes;
        last_index = override_index;
    }
    if (record.type == AVF_TYPE_DELTA &&
        !(previous != NULL && follows(last_index, index))) {
        return AVF_ERR_SEQUENCE;
    }
    if (is_empty(&record)) {
        if (flags != NULL) {
            *flags |= AVF_FLAG_NO_DATA;
        }
        stream->chunk_previous = previous;
        stream->chunk_previous_bytes = previous_bytes;
        stream->last_index = index;
        *result = previous;
        *result_bytes = previous_bytes;
        return AVF_OK;
    }
    status = check_data(stream, &record);
    if (status != AVF_OK) {
        return status;
    }
    if (record.type == AVF_TYPE_KEY) {
        out_bytes = record.unpacked_bytes;
        if (out_capacity < out_bytes) {
            return AVF_ERR_ARGUMENT;
        }
        /* A fresh new(unpacked_bytes) in the original. */
        status = decode_key(stream, &record, out, out_bytes, lzss);
    } else {
        out_bytes = stream->file->frame_bytes;
        if (out_capacity < out_bytes) {
            return AVF_ERR_ARGUMENT;
        }
        if (record.type == AVF_TYPE_DELTA && previous_bytes < out_bytes) {
            return AVF_ERR_CORRUPT;
        }
        status = decode_commands(stream, &record, out,
                                 record.type == AVF_TYPE_DELTA ? previous : NULL, lzss);
    }
    if (status != AVF_OK) {
        return status;
    }
    if (flags != NULL) {
        *flags |= type_flag(record.type);
    }
    stream->last_index = index;
    stream->chunk_previous = out;
    stream->chunk_previous_bytes = out_bytes;
    *result = out;
    *result_bytes = out_bytes;
    return AVF_OK;
}

const char *avf_status_name(AvfStatus status)
{
    static const char *const names[] = {
        "OK", "ARGUMENT", "SIGNATURE", "VERSION", "TRUNCATED", "RANGE", "SEQUENCE",
        "CORRUPT", "UNSUPPORTED"
    };
    if ((unsigned)status < sizeof(names) / sizeof(names[0])) {
        return names[status];
    }
    return "UNKNOWN";
}
