#ifndef BLACKMOOR_ACTION_FAMILY_2D_H
#define BLACKMOOR_ACTION_FAMILY_2D_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Raw action type 0x2d. Loader arm 0x40c0e0 (reached through the 0x410ca4 /
 * 0x410e9c dispatch tables of FUN_0040b34a) calls FUN_004cd243 with
 * this = 0x63821d. The arm never writes the type byte: the raw and the runtime
 * type stay 0x2d. This is an isolated Track N C11 value reconstruction with
 * original-x86 behavioural evidence; it is not original C++ source, compiler
 * provenance or byte-match coverage, and it implements no lifecycle or
 * rendering behaviour. */
#define ACTION_FAMILY_2D_RAW_TYPE UINT8_C(0x2d)
#define ACTION_FAMILY_2D_RUNTIME_TYPE UINT8_C(0x2d)
#define ACTION_FAMILY_2D_NAME_BYTES 33u
#define ACTION_FAMILY_2D_HEADER_BYTES 39u        /* 0x27: 9 DWORDs + WORD + BYTE copied */
#define ACTION_FAMILY_2D_ENTRY_FILE_BYTES 49u    /* 0x31 bytes copied per entry */
#define ACTION_FAMILY_2D_ENTRY_OBJECT_BYTES 53u  /* 0x35: file bytes + 4-byte pointer at +0x31 */
#define ACTION_FAMILY_2D_RECORD35_BYTES 35u      /* 0x23 */
#define ACTION_FAMILY_2D_RECORD34_BYTES 34u      /* 0x22 */
#define ACTION_FAMILY_2D_DEPENDENCY_BYTES 16u
#define ACTION_FAMILY_2D_MAX_COUNT 32767u        /* counts are signed 16-bit words */

/* Native safety results, not original x86 return values. */
typedef enum {
    ACTION_FAMILY_2D_OK = 0,
    ACTION_FAMILY_2D_ERR_ARGUMENT = 1,
    ACTION_FAMILY_2D_ERR_BODY = 2,
    ACTION_FAMILY_2D_ERR_COUNT = 3,
    ACTION_FAMILY_2D_ERR_TAIL = 4,
    ACTION_FAMILY_2D_ERR_BOUNDS = 5,
    ACTION_FAMILY_2D_ERR_OVERLAP = 6,
    ACTION_FAMILY_2D_ERR_CAPACITY = 7,
    ACTION_FAMILY_2D_ERR_INDEX = 8
} ActionFamily2DStatus;

/* Typed body (FUN_004cd243):
 *   header, 39 bytes: 33-byte name span (copied as raw bytes, never scanned
 *     for a NUL), word_21, signed word entry_count at +0x23, signed word
 *     record34_count at +0x25;
 *   entry_count entries, each 49 bytes (33-byte span, word_21, word_23,
 *     dword_25, dword_29, word_2d, signed word record35_count at +0x2f)
 *     followed by record35_count * 35 bytes;
 *   record34_count * 34 bytes.
 * Everything after is the generic 16-byte dependency tail. Negative counts
 * make the original request an allocation of at least 0xFFE58000 bytes (more
 * than 2 GiB; the oracle models its failure as NULL); the native decoder
 * rejects them (ERR_COUNT) instead of modelling that failure.
 * Pointers below are borrowed views into raw_body. */
typedef struct {
    uint8_t name[ACTION_FAMILY_2D_NAME_BYTES]; /* exact bytes; not a C string */
    uint16_t word_21;
    int16_t entry_count;
    int16_t record34_count;
    const uint8_t *entries;      /* raw_body + 39 */
    size_t entries_bytes;        /* all entries including their 35-byte records */
    size_t record35_total;       /* sum of record35_count over all entries */
    const uint8_t *records_34;   /* raw_body + 39 + entries_bytes */
    size_t records_34_bytes;
    const uint8_t *dependency_records; /* raw_body + body_bytes, even when empty */
    size_t dependency_count;
    size_t dependency_bytes;
    size_t available_body_bytes;
    size_t body_bytes;
    uint8_t raw_type;
    uint8_t runtime_type;
} ActionFamily2DDecoded;

typedef struct {
    uint8_t name[ACTION_FAMILY_2D_NAME_BYTES]; /* exact bytes; not a C string */
    uint16_t word_21;
    uint16_t word_23;
    uint32_t dword_25;
    uint32_t dword_29;
    uint16_t word_2d;
    int16_t record35_count;
    const uint8_t *records_35;   /* borrowed; record35_count * 35 bytes */
    size_t records_35_bytes;
} ActionFamily2DEntry;

typedef struct { uint8_t bytes[ACTION_FAMILY_2D_RECORD35_BYTES]; } ActionFamily2DRecord35;
typedef struct { uint8_t bytes[ACTION_FAMILY_2D_RECORD34_BYTES]; } ActionFamily2DRecord34;

/* Model of FUN_004cd243's allocations and cursor effects on its success path.
 * The original makes 3 + entry_count allocations in this order, each through
 * FUN_004cf1e4 (malloc, store the pointer, zero-fill):
 *   [0] 39-byte header block   (pointer stored in the action slot, action+0x32)
 *   [1] entry_count*53-byte entry table (pointer stored at owner+0x226)
 *   [2+i] record35_count_i*35-byte block of entry i (pointer stored at
 *         entry i + 0x31 inside the table), allocated while walking entries
 *   [2+entry_count] record34_count*34-byte block (pointer at owner+0x22a)
 * and every byte of every block is overwritten by the copies. image receives
 * the concatenation of the final block contents in allocation order, so
 * image_bytes = 39 + 53*entry_count + 35*record35_total + 34*record34_count.
 * handles[k] is the opaque nonzero x86 address of block k (never a host
 * pointer); the table's +0x31 pointer fields are written from it. A block of
 * zero size still has a handle. Owner fields are separate metadata for the
 * owner object at 0x63821d (+0x222 header, +0x226 table, +0x23e action index
 * sign-extended). The owner's already-built flag (+0x216) is a state input
 * the original checks first; it is not modelled here (zero is assumed). */
typedef struct {
    size_t allocation_count;
    size_t image_bytes;
    size_t body_bytes_consumed;
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t available_body_bytes;
    uint32_t payload_offset_before;
    uint32_t payload_offset_after; /* before + body_bytes, modulo 2^32 */
    uint32_t result_slot_handle;       /* handles[0] */
    uint32_t owner_header_handle;      /* owner+0x222 == handles[0] */
    uint32_t owner_entry_table_handle; /* owner+0x226 == handles[1] */
    uint32_t owner_group_handle;       /* owner+0x22a == last handle */
    int32_t owner_action_index;        /* owner+0x23e, word sign-extended */
    uint8_t raw_type;
    uint8_t runtime_type;
} ActionFamily2DConstructed;

/* Caller supplies readable raw_body[raw_body_length] (the ACT body after the
 * 50-byte header, including any dependency tail) and writable outputs.
 * Address-span arithmetic cannot prove mappedness. Every failure leaves all
 * outputs and the input unchanged and is decided before any output write.
 * Outputs may not overlap the input or each other. */
ActionFamily2DStatus action_family_2d_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily2DDecoded *out);

/* Same validation as decode; sets *body_bytes to the typed length only on
 * success. No input bytes beyond the typed body are interpreted. */
ActionFamily2DStatus action_family_2d_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *body_bytes);

/* Each accessor validates the whole body first (walking entries is O(index)). */
ActionFamily2DStatus action_family_2d_entry_at(
    const uint8_t *raw_body, size_t raw_body_length, size_t index,
    ActionFamily2DEntry *out);
ActionFamily2DStatus action_family_2d_record35_at(
    const uint8_t *raw_body, size_t raw_body_length, size_t entry_index,
    size_t record_index, ActionFamily2DRecord35 *out);
ActionFamily2DStatus action_family_2d_record34_at(
    const uint8_t *raw_body, size_t raw_body_length, size_t index,
    ActionFamily2DRecord34 *out);

/* handle_count must equal 3 + entry_count and every handle be nonzero
 * (ERR_ARGUMENT otherwise); image_capacity < image_bytes gives ERR_CAPACITY.
 * Bytes of image beyond image_bytes are untouched. */
ActionFamily2DStatus action_family_2d_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, int16_t action_index,
    const uint32_t *handles, size_t handle_count,
    uint8_t *image, size_t image_capacity, ActionFamily2DConstructed *out);

#ifdef __cplusplus
}
#endif
#endif
