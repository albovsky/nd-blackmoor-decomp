#ifndef AVF_DECODER_H
#define AVF_DECODER_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/*
 * Original AVF ("AVF WayneSikes") container and frame decoder recovered from
 * GAME.EXE:
 *
 *   0x414ceb  open: signature/version check, frame-table copy, frame bytes
 *   0x415db9  counter-obfuscated LZSS (reached through 0x4159db, type 2)
 *   0x416af3  type-1 / type-2 command expansion, fill helper 0x43ef77
 *   0x41546f  single-buffer reader      (avf_decode_single)
 *   0x4156ea  double-buffer reader      (avf_decode_double)
 *   0x415176  random-access chunk getter (avf_get_chunk)
 *
 * Pixels stay in the file's 16-bit little-endian x1r5g5b5 representation.
 * The original converts them for the display with 0x4c7314 at fixed points
 * inside these routines; the decoder calls the optional `convert` hook at
 * exactly those points with exactly the original ranges. Leaving the hook
 * NULL corresponds to a 5/5/5 display (object +0x38a8 == 0): raw pixels.
 * cif_pixels_convert_555() is the validated port of 0x4c7314.
 *
 * Nothing here allocates. The caller owns the file bytes, every frame buffer
 * and the scratch buffer (which replaces the original temporary allocation of
 * the unpacked chunk, object +0x35).
 *
 * Failure contract: every call validates the record, the LZSS stream (with a
 * dry run), the command stream and every destination/conversion range before
 * its first visible write. A failing call returns a non-OK status and leaves
 * frame buffers, flags, the toggle, the last decoded index and the chunk
 * predecessor unchanged; only the scratch buffer may be overwritten. The
 * original treats every one of these failures as fatal (report and quit) or
 * has undefined behavior; see AVF_ERR_* below.
 */

#define AVF_HEADER_BYTES 0x21u
#define AVF_RECORD_BYTES 0x13u
#define AVF_RING_BYTES 0x1000u
#define AVF_RING_START 0xfeeu

/* Status values. */
typedef enum AvfStatus {
    AVF_OK = 0,
    AVF_ERR_ARGUMENT = 1,     /* NULL pointer, short span, uninitialized stream */
    AVF_ERR_SIGNATURE = 2,    /* not "AVF WayneSikes\0" (original: fatal) */
    AVF_ERR_VERSION = 3,      /* +0x10 != 2 or +0x12 != 0 (original: fatal) */
    AVF_ERR_TRUNCATED = 4,    /* header/table/chunk beyond the file (original: reads past the mapping) */
    AVF_ERR_RANGE = 5,        /* frame index outside the table (original: unchecked) */
    AVF_ERR_SEQUENCE = 6,     /* type-2 delta without decoded predecessor (original: fatal) */
    AVF_ERR_CORRUPT = 7,      /* LZSS or command data out of bounds (original: memory
                                 corruption); also negative count or non-positive
                                 width/height at open (native design rejection) */
    AVF_ERR_UNSUPPORTED = 8   /* compression != 2 or record type > 2 with data (original:
                                 fatal), unknown command byte (original: endless loop),
                                 bpp != 16 (native design limit; the original only uses
                                 bpp to size frames) */
} AvfStatus;

/* Frame-table record types (record +0xe). */
enum {
    AVF_TYPE_KEY = 0,    /* LZSS output is the whole frame */
    AVF_TYPE_FULL = 1,   /* commands into the destination, then convert all */
    AVF_TYPE_DELTA = 2   /* previous frame + commands, converting each span */
};

/* Reader flags, original object +0x182 / +0x184. */
enum {
    AVF_FLAG_KEY = 0x1,
    AVF_FLAG_FULL = 0x2,
    AVF_FLAG_DELTA = 0x4,
    AVF_FLAG_NO_DATA = 0xc   /* record has packed == unpacked == 0 */
};

/* Command bytes of the type-1/type-2 stream (0x416af3). */
enum {
    AVF_CMD_COPY = 0x20,     /* ' ' u32 dst_pixel, u32 count, count pixels */
    AVF_CMD_FILL = 0x40,     /* '@' u16 value, i32 dst_pixel, i32 count */
    AVF_CMD_REPEAT = 0x80    /* u8 n, i32 runs, n pixels, runs x i32 dst_pixel */
};

/* One 0x13-byte frame-table record, little-endian. */
typedef struct AvfRecord {
    uint16_t index;          /* +0x0 (not read by the original) */
    uint32_t offset;         /* +0x2 packed data offset from file start */
    uint32_t packed_bytes;   /* +0x6 */
    uint32_t unpacked_bytes; /* +0xa */
    uint8_t type;            /* +0xe */
    uint32_t reserved;       /* +0xf (not read by the original) */
} AvfRecord;

/* Parsed container. Points into the caller's bytes, which must outlive it. */
typedef struct AvfFile {
    const uint8_t *data;
    size_t size;
    int16_t frame_count;     /* +0x15 */
    int16_t width;           /* +0x17 */
    int16_t height;          /* +0x19 */
    uint8_t bits_per_pixel;  /* +0x1b */
    uint32_t header_1c;      /* +0x1c, not read by the decoder */
    uint8_t compression;     /* +0x20, must be 2 */
    uint32_t frame_bytes;    /* original +0x41: width * height * (bpp >> 3) */
    uint32_t max_unpacked;   /* largest record unpacked_bytes: scratch size */
} AvfFile;

/* Display conversion hook, called with the original 0x4c7314 arguments. */
typedef void (*AvfConvertFn)(void *context, uint8_t *pixels, uint32_t byte_count);

/*
 * Decoder state of one CChunk object. Buffers stay owned by the caller.
 * buffers[0] is object +0x17a, buffers[1] is +0x17e (double mode only).
 */
typedef struct AvfStream {
    const AvfFile *file;
    int32_t last_index;      /* +0x45, -1 after open/reset */
    uint16_t toggle;         /* +0x18a, double mode */
    uint16_t flags[2];       /* +0x182, +0x184 */
    uint8_t *buffers[2];
    size_t buffer_bytes;     /* capacity of each frame buffer */
    uint8_t *scratch;        /* replaces the +0x35 allocation */
    size_t scratch_bytes;
    const uint8_t *chunk_previous; /* +0x49, avf_get_chunk predecessor */
    size_t chunk_previous_bytes;
    AvfConvertFn convert;
    void *convert_context;
} AvfStream;

/* State of the LZSS routine 0x415db9 when it returns. */
typedef struct AvfLzssState {
    uint8_t ring[AVF_RING_BYTES];
    uint8_t ring_defined[AVF_RING_BYTES]; /* 0 for the 18 bytes the original leaves unset */
    uint32_t ring_position;  /* next ring write position */
    uint8_t counter;         /* de-obfuscation counter */
    uint32_t flag_bits;      /* control word, bit 8 marks a loaded flag byte */
    int32_t input_position;  /* last input index examined; equals packed_bytes - 1 or packed_bytes */
    uint32_t produced;       /* output bytes written */
} AvfLzssState;

/* Parse and validate the header and frame table of a whole AVF file. */
AvfStatus avf_open(const uint8_t *data, size_t size, AvfFile *file);

/* Read record `index` (0 <= index < frame_count). */
AvfStatus avf_record(const AvfFile *file, int32_t index, AvfRecord *record);

/*
 * Expand an LZSS stream into dst. Output larger than dst_capacity, and reads
 * of the 18 ring bytes the original never initializes, fail with
 * AVF_ERR_CORRUPT. dst may be NULL for a dry run (dst_capacity still bounds
 * the produced count). `state` may be NULL.
 */
AvfStatus avf_lzss_expand(const uint8_t *src, uint32_t src_bytes,
                          uint8_t *dst, size_t dst_capacity,
                          AvfLzssState *state);

/*
 * Prepare a stream (equivalent of a fresh 0x414ceb open plus 0x4161d1):
 * last_index -1, toggle 0, flags 0, no chunk predecessor. Buffers are not
 * cleared; buffers[1] may be NULL unless avf_decode_double is used. Every
 * buffer needs buffer_bytes >= frame_bytes; scratch needs max_unpacked bytes
 * to decode type-1/type-2 records.
 */
AvfStatus avf_stream_init(AvfStream *stream, const AvfFile *file,
                          uint8_t *buffer0, uint8_t *buffer1, size_t buffer_bytes,
                          uint8_t *scratch, size_t scratch_bytes,
                          AvfConvertFn convert, void *convert_context);

/* Return to the post-open state without touching any buffer. */
void avf_stream_reset(AvfStream *stream);

/*
 * 0x41546f: decode `index` into buffers[0]; result flags in flags[0].
 * A key frame's LZSS output may be any length up to frame_bytes (bytes it
 * does not reach keep the previous frame). unpacked_bytes is what gets
 * converted: with no conversion hook it may exceed frame_bytes (the
 * original's 0x4c7314 returns at once); with a hook its touched extent,
 * (unpacked_bytes >> 1) * 2, must fit in frame_bytes or the call fails with
 * AVF_ERR_CORRUPT before any write. Command records (types 1/2) must expand
 * to exactly unpacked_bytes.
 */
AvfStatus avf_decode_single(AvfStream *stream, int16_t index, AvfLzssState *lzss);

/*
 * 0x4156ea: decode `index` into the buffer selected by the toggle (toggle 0
 * writes buffers[1] with flags[1] and reads buffers[0] as the predecessor;
 * toggle 1 is the reverse). Successful non-empty records flip the toggle.
 * *written receives the buffer slot (0 or 1) whose flags were set.
 */
AvfStatus avf_decode_double(AvfStream *stream, int16_t index, int *written,
                            AvfLzssState *lzss);

/*
 * 0x415176: decode `index` into `out` (a fresh buffer in the original).
 * Type 0 yields unpacked_bytes (which may exceed frame_bytes) and its LZSS
 * output may stop short of that; types 1/2 yield frame_bytes, and type 1
 * leaves pixels it does not cover. Bytes not written keep `out`'s contents
 * (uninitialized in the original).
 * When override_previous is non-NULL and override_index is nonzero, they
 * replace the predecessor and last index first, as the original does with
 * nonzero param_4/param_5. On success *result points to `out`, or to the
 * predecessor for an empty record, and *result_bytes gives its length;
 * `out` becomes the predecessor. `flags` may be NULL; it is OR-ed as in the
 * original.
 */
AvfStatus avf_get_chunk(AvfStream *stream, int16_t index,
                        uint8_t *out, size_t out_capacity,
                        const uint8_t *override_previous, size_t override_previous_bytes,
                        int16_t override_index,
                        uint16_t *flags,
                        const uint8_t **result, size_t *result_bytes,
                        AvfLzssState *lzss);

/* Short stable name for a status value. */
const char *avf_status_name(AvfStatus status);

#ifdef __cplusplus
}
#endif

#endif
