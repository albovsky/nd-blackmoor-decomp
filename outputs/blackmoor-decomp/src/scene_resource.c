#include "scene_resource.h"

#include "hiff.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SCENE_TSUM_BYTES 126u
#define SCENE_ACTION_HEADER_BYTES 50u

typedef struct scene_action {
    SceneActionInfo info;
} SceneAction;

struct SceneResource {
    Hiff *hiff;
    SceneResourceSummary summary;
    SceneAction *actions;
};

static void set_error(char *error, size_t capacity, const char *message)
{
    if (error != NULL && capacity != 0u) {
        (void)snprintf(error, capacity, "%s", message);
    }
}

static uint16_t read_u16le(const uint8_t *bytes)
{
    return (uint16_t)((uint16_t)bytes[0] | ((uint16_t)bytes[1] << 8));
}

static int16_t read_i16le(const uint8_t *bytes)
{
    uint16_t value = read_u16le(bytes);
    int32_t signed_value = value < 0x8000u ? (int32_t)value : (int32_t)value - 0x10000;
    return (int16_t)signed_value;
}

static int copy_fixed_string(char *output, size_t output_capacity,
                             const uint8_t *input, size_t field_length)
{
    const uint8_t *terminator;
    size_t string_length;

    if (output == NULL || input == NULL || output_capacity == 0u) {
        return 0;
    }
    terminator = (const uint8_t *)memchr(input, 0, field_length);
    if (terminator == NULL) {
        return 0;
    }
    string_length = (size_t)(terminator - input);
    if (string_length >= output_capacity) {
        return 0;
    }
    memcpy(output, input, string_length);
    output[string_length] = '\0';
    return 1;
}

static int count_data_type(const Hiff *hiff, const char *type,
                           size_t *count, size_t *only_index)
{
    size_t index;
    size_t found = 0u;

    for (index = 0u; index < hiff_data_count(hiff); ++index) {
        HiffDataInfo data;
        if (hiff_data_at(hiff, index, &data) != HIFF_OK) {
            return 0;
        }
        if (strcmp(data.type, type) == 0) {
            ++found;
            if (only_index != NULL) {
                *only_index = index;
            }
        }
    }
    if (count != NULL) {
        *count = found;
    }
    return 1;
}

static int selected_chunk(Hiff *hiff, const uint8_t **bytes, size_t *length,
                          HiffSelectionInfo *selection)
{
    return hiff_get_selected_chunk(hiff, bytes, length, selection) == HIFF_OK;
}

static int copy_summary(SceneResource *scene, const uint8_t *payload, size_t length)
{
    if (length < SCENE_TSUM_BYTES ||
        !copy_fixed_string(scene->summary.title, sizeof(scene->summary.title),
                           payload, SCENE_RESOURCE_TITLE_BYTES) ||
        !copy_fixed_string(scene->summary.background, sizeof(scene->summary.background),
                           payload + 50u, SCENE_RESOURCE_STEM_BYTES) ||
        !copy_fixed_string(scene->summary.audio, sizeof(scene->summary.audio),
                           payload + 83u, SCENE_RESOURCE_STEM_BYTES)) {
        return 0;
    }
    memcpy(scene->summary.raw_tail, payload + 116u,
           SCENE_RESOURCE_TSUM_TAIL_BYTES);
    return 1;
}

/* Return the body size only for layouts recovered from the original loader.
 * Unknown types deliberately remain wholly opaque, including any bytes that
 * could otherwise be mistaken for dependency records. */
static int known_body_length(uint8_t type, const uint8_t *body, size_t length,
                             size_t *body_length, SceneActionPayloadKind *kind)
{
    size_t fixed_length;

    switch (type) {
    case 0x0a: fixed_length = 20u; break; /* AT_SCENE_CHANGE */
    case 0x0b: fixed_length = 24u; break; /* loader advances source by 0x18 */
    case 0x15: fixed_length = 20u; break; /* original decoder consumes 20 bytes */
    case 0x1d: fixed_length = 8u;  break; /* AT_CONTROL */
    case 0x4d: fixed_length = 4u;  break; /* AT_SET_VALUE */
    case 0x37: fixed_length = 69u; break; /* 0x4895cc consumes the 69-byte static overlay prefix */
    case 0x28: fixed_length = 21u; break; /* CSpecialEffect consumes the 21-byte payload */
    case 0x61: fixed_length = 8u;  break; /* AT_EVENT_FLAGS variant */
    case 0xf6: fixed_length = 4934u; break; /* 0x45ddd0 copies 4,934 bytes (A-F6.1) */
    case 0xea: fixed_length = 3847u; break; /* 0x484110 copies 3,847 bytes (A-EA.1) */
    case 0xf5: fixed_length = 1390u; break; /* 0x4b80d9 copies 1,390 bytes (A-F5.1) */
    case 0xd3: fixed_length = 855u; break; /* 0x461903 copies 855 bytes (A-D3.1) */
    case 0xee: fixed_length = 5826u; break; /* 0x47b3f0 copies 5,826 bytes (A-EE.1) */
    case 0xda: fixed_length = 2958u; break; /* 0x45b4ae copies 2,958 bytes (A-DA.1) */
    case 0x77: fixed_length = 731u; break; /* inline arm 0x40db66 copies 731 bytes (A-77.1) */
    case 0x1c: fixed_length = 105u; break; /* 0x4caff5 copies 105 bytes (A-1C.1) */
    case 0xeb: fixed_length = 2612u; break; /* 0x47e477 copies 2,612 bytes (A-EB.1) */
    case 0xd0: fixed_length = 1979u; break; /* 0x48d12d copies 1,979 bytes (A-D0.1) */
    case 0xe0:
        /* 0x470e8e (flag 1) copies 294 bytes (A-E0.1). Scene S2705 (resource
         * 1737) has a 292-byte body, two short of the copy: the original's
         * dependency stage hits its ragged-tail exit there (error box, then a
         * quit request), so that record stays opaque. */
        if (length < 294u) {
            return 0;
        }
        fixed_length = 294u;
        break;
    case 0x7d: fixed_length = 1u;  break; /* 0x40e61e copies one byte (A-7D.1) */
    case 0x69: fixed_length = 1u;  break; /* 0x40d428 copies one byte (A-69.1) */
    case 0x65: fixed_length = 1u;  break; /* 0x40d116 copies one byte (A-65.1) */
    case 0x68: fixed_length = 1u;  break; /* 0x40d364 copies one byte (A-68.1) */
    case 0x83: fixed_length = 74u; break; /* 0x40e995 copies 74 bytes (A-83.1) */
    case 0x4e: fixed_length = 31u; break; /* 0x44b102 copies 31 bytes (A-4E.1) */
    case 0x2e: fixed_length = 15u; break; /* 0x4cd645 copies 15 bytes (A-2E.1) */
    case 0x94: fixed_length = 50u; break; /* 0x40ea5e copies 50 bytes (A-94.1) */
    case 0xd1: fixed_length = 927u; break; /* 0x4b5c5c copies 927 bytes (A-D1.1) */
    case 0x67: fixed_length = 1u;  break; /* 0x40d29f copies one byte (A-67.1) */
    case 0x6f: fixed_length = 1u;  break; /* 0x40e314 copies one byte (A-6F.1) */
    case 0x6e: fixed_length = 1u;  break; /* 0x40e250 copies one byte (A-6E.1) */
    case 0x79: fixed_length = 2u;  break; /* 0x4e9add copies one word (A-79.1) */
    case 0x64: fixed_length = 5u;  break; /* constructor 0x40b34a copies exactly five bytes */
    case 0x6b: fixed_length = 40u; break; /* AT_EVENTFLAGS */
    case 0x51: {
        int16_t selector;
        if (length < 12u) {
            return -1;
        }
        selector = read_i16le(body + 10u);
        if (selector == -1) {
            *body_length = 45u; /* loader copies the 33-byte AUTOTEXT key */
        } else if (selector >= 0 && selector <= 9999) {
            *body_length = 12u + (size_t)selector;
        } else {
            return -1;
        }
        *kind = SCENE_ACTION_PAYLOAD_VARIABLE;
        return 1;
    }
    case 0x71: fixed_length = 6u;  break; /* AT_DIFFICULTY_LEVEL */
    case 0x82: fixed_length = 41u; break; /* AT_CELLPHONE_NUMBER */
    case 0x4f: fixed_length = 10u; break; /* 0x44b1b4 advances source by 10 */
    case 0x47: fixed_length = 39u; break; /* 0x411a22 advances source by 0x27 */
    case 0x78: fixed_length = 6u;  break; /* 0x4e9c2f advances source by 6 */
    case 0x95: fixed_length = 3u;  break; /* loader advances source by 3 */
    case 0xd9: fixed_length = 35u; break; /* 0x47d682 advances source by 0x23 */
    case 0x62: {
        int16_t count;
        size_t typed_length;

        /* The constructor reads a signed short at +10 and narrows its
         * 12 + count*18 result to signed short before copying. Validate the
         * complete 12-byte prefix before the read, reject negative/unrepresentable
         * counts, then let parse_action bound the typed span against this row. */
        if (length < 12u) {
            return -1;
        }
        count = read_i16le(body + 10u);
        if (count < 0) {
            return -1;
        }
        typed_length = 12u + (size_t)count * 18u;
        if (typed_length > (size_t)INT16_MAX) {
            return -1;
        }
        *body_length = typed_length;
        *kind = SCENE_ACTION_PAYLOAD_VARIABLE;
        return 1;
    }
    case 0x9f: {
        uint16_t selector;
        if (length < 48u) {
            return -1;
        }
        selector = read_u16le(body + 46u);
        if (selector == UINT16_MAX) {
            /* Auto-text selector: original source cursor advances 0x51. */
            *body_length = 0x51u;
        } else {
            /* Numeric selector at +0x2e; loader rejects values above 9999. */
            if (selector > 9999u) {
                return -1;
            }
            *body_length = (size_t)selector + 0x30u;
        }
        *kind = SCENE_ACTION_PAYLOAD_VARIABLE;
        return 1;
    }
    case 0x97: {
        int16_t count;
        size_t offset;
        size_t sum = 0u;
        size_t entry;

        /* 0x40f532..0x40fd17: signed count at +0 (original accepts < 10;
         * zero/negative counts are unsafe there and rejected here), n 33-byte
         * names from +2, 13 neutral bytes, then n selector entries. A -1
         * entry consumes 0x23 bytes, a non-negative one 2 + selector; the
         * original narrows the entry sum to int16, so reject sums above it. */
        if (length < 2u) {
            return -1;
        }
        count = read_i16le(body);
        if (count < 1 || count > 9) {
            return -1;
        }
        offset = 15u + 33u * (size_t)count;
        for (entry = 0u; entry < (size_t)count; ++entry) {
            int16_t selector;
            if (length < offset + sum + 2u) {
                return -1;
            }
            selector = read_i16le(body + offset + sum);
            if (selector == -1) {
                sum += 35u;
            } else if (selector >= 0) {
                sum += 2u + (size_t)selector;
            } else {
                return -1;
            }
            if (sum > (size_t)INT16_MAX) {
                return -1;
            }
        }
        *body_length = offset + sum;
        *kind = SCENE_ACTION_PAYLOAD_VARIABLE;
        return 1;
    }
    case 0xa1: {
        int16_t selector;
        if (length < 51u) {
            return -1;
        }
        selector = read_i16le(body + 49u);
        if (selector == -1) {
            *body_length = 84u; /* 0x40f0cd key form: 0x2743 - 0x26ef */
        } else if (selector >= 0 && selector <= 9999) {
            *body_length = 51u + (size_t)selector;
        } else {
            return -1;
        }
        *kind = SCENE_ACTION_PAYLOAD_VARIABLE;
        return 1;
    }
    case 0x2d: {
        int16_t entries;
        int16_t groups;
        size_t cursor = 39u;
        size_t entry;

        /* 0x4cd243 (A-2D.1): 39-byte header with signed words at +0x23
         * (entries) and +0x25 (34-byte records); each entry is 49 bytes plus
         * 35 bytes times the signed word at entry+0x2f; then 34 bytes per
         * record. Nothing is NUL-scanned. Negative counts are unsafe in the
         * original (>2 GiB allocation) and rejected here. */
        if (length < cursor) {
            return -1;
        }
        entries = read_i16le(body + 0x23u);
        groups = read_i16le(body + 0x25u);
        if (entries < 0 || groups < 0) {
            return -1;
        }
        for (entry = 0u; entry < (size_t)entries; ++entry) {
            int16_t records;
            if (length - cursor < 49u) {
                return -1;
            }
            records = read_i16le(body + cursor + 0x2fu);
            if (records < 0 || length - cursor - 49u < 35u * (size_t)records) {
                return -1;
            }
            cursor += 49u + 35u * (size_t)records;
        }
        if (length - cursor < 34u * (size_t)groups) {
            return -1;
        }
        *body_length = cursor + 34u * (size_t)groups;
        *kind = SCENE_ACTION_PAYLOAD_VARIABLE;
        return 1;
    }
    case 0x35: {
        int16_t count_6;
        int16_t count_34;
        size_t count_34_offset;
        size_t typed;

        /* 0x4bf8c2: signed words at +59 (n) and +61+6n (m) widen into 32-bit
         * arithmetic, size 63 + 6n + 34m with no later narrowing or bound.
         * Negative counts are unsafe in the original and rejected here. */
        if (length < 61u) {
            return -1;
        }
        count_6 = read_i16le(body + 59u);
        if (count_6 < 0) {
            return -1;
        }
        count_34_offset = 61u + (size_t)count_6 * 6u;
        if (length < count_34_offset + 2u) {
            return -1;
        }
        count_34 = read_i16le(body + count_34_offset);
        if (count_34 < 0) {
            return -1;
        }
        typed = count_34_offset + 2u + (size_t)count_34 * 34u;
        if (length < typed) {
            return -1;
        }
        *body_length = typed;
        *kind = SCENE_ACTION_PAYLOAD_VARIABLE;
        return 1;
    }
    case 0x38: {
        int32_t count;

        /* 0x48905b: NUL-terminated 33-byte name, signed 16-bit endpoints at
         * +0x33/+0x35 give a 32-bit frame count (no narrowing), 16 bytes each
         * after the 71-byte prefix. The 100-row bound is the native safety
         * limit for the original's dedicated frame table. */
        if (length < 71u || memchr(body, 0, 33u) == NULL) {
            return -1;
        }
        count = (int32_t)read_i16le(body + 0x35u) -
                (int32_t)read_i16le(body + 0x33u) + 1;
        if (count < 0 || count > 100) {
            return -1;
        }
        *body_length = 71u + (size_t)count * 16u;
        *kind = SCENE_ACTION_PAYLOAD_VARIABLE;
        return 1;
    }
    case 0x43: {
        /* 0x41137f: 301-byte prefix; a nonzero byte at +265 selects the
         * keyed form (33-byte key at +266), otherwise the inline text count
         * at +299 extends the body. Unterminated key/text and negative counts
         * are native safety rejections mirrored from action_family_43_decode. */
        size_t typed_length = 301u;
        if (length < typed_length) {
            return -1;
        }
        if (body[0x109u] == 0u) {
            int16_t count = read_i16le(body + 0x12bu);
            if (read_i16le(body + 2u) > 2 || count < 0) {
                return -1;
            }
            typed_length += (size_t)count;
            if (length < typed_length ||
                memchr(body + 301u, 0, (size_t)count) == NULL) {
                return -1;
            }
        } else if (memchr(body + 0x10au, 0, 33u) == NULL) {
            return -1;
        }
        *body_length = typed_length;
        *kind = SCENE_ACTION_PAYLOAD_VARIABLE;
        return 1;
    }
    case 0x45: {
        /* 0x40d4ed: 196-byte prefix (97 neutral words, signed count at +194)
         * and count four-byte entries; counts above 10 are rejected by the
         * original arm, negatives are a native safety rejection. */
        int16_t count;
        if (length < 196u) {
            return -1;
        }
        count = read_i16le(body + 194u);
        if (count < 0 || count > 10) {
            return -1;
        }
        *body_length = 196u + (size_t)count * 4u;
        *kind = SCENE_ACTION_PAYLOAD_VARIABLE;
        return 1;
    }
    case 0x44: {
        /* 0x41166e: 528-byte prefix; a nonzero byte at +492 selects the keyed
         * form (33-byte key at +493), otherwise the inline text count at +526
         * extends the body. Native safety rejections mirror the decoder. */
        size_t typed = 528u;
        if (length < typed) {
            return -1;
        }
        if (body[492u] == 0u) {
            int16_t count = read_i16le(body + 526u);
            if (read_i16le(body + 2u) > 2 || count < 0 ||
                (size_t)count > length - typed) {
                return -1;
            }
            if (memchr(body + typed, 0, (size_t)count) == NULL) {
                return -1;
            }
            typed += (size_t)count;
        } else if (memchr(body + 493u, 0, 33u) == NULL) {
            return -1;
        }
        *body_length = typed;
        *kind = SCENE_ACTION_PAYLOAD_VARIABLE;
        return 1;
    }
    case 0x36: {
        /* 0x488e9c: 172-byte prefix, primary rows of 16 bytes (direct count
         * or signed-WORD-narrowed endpoint difference) and secondary rows of
         * 38 bytes; the 100/25 limits are native safety bounds. */
        int32_t primary;
        int32_t secondary;
        size_t typed;
        if (length < 0xacu) {
            return -1;
        }
        if (read_i16le(body + 0x29u) == 2) {
            /* Original DWORD subtraction/addition narrows to a signed WORD. */
            uint16_t bits = (uint16_t)((int32_t)read_i16le(body + 0x35u) -
                                      (int32_t)read_i16le(body + 0x33u) + 1);
            primary = bits <= 0x7fffu ? (int32_t)bits : (int32_t)bits - 0x10000;
        } else {
            primary = (int32_t)read_i16le(body + 0x2bu);
        }
        secondary = (int32_t)read_i16le(body + 0xaau);
        /* Native safety limits keep the original unchecked copies inside
         * their tables: [0xac,0x6ec), [0x6ec,0xaa2). */
        if (primary < 0 || primary > 100 || secondary < 0 || secondary > 25) {
            return -1;
        }
        typed = 0xacu + (size_t)primary * 16u + (size_t)secondary * 38u;
        if (length < typed) {
            return -1;
        }
        *body_length = typed;
        *kind = SCENE_ACTION_PAYLOAD_VARIABLE;
        return 1;
    }
    case 0x1b: {
        int16_t primary_count;
        int16_t secondary_count;
        size_t cursor;

        /* Loader arm 0x40bbed -> 0x414692 (A-1B.1). Layout: signed WORD count
         * at +0, count * 22 bytes, a 22-byte fixed block, a signed WORD count,
         * count * 18 bytes. Negative counts, truncation and ragged tails are
         * native safety rejections; the original has no such guards and no
         * body strings. Counts are at most 32767 so no multiplication wraps. */
        if (length < 2u) {
            return -1;
        }
        primary_count = read_i16le(body);
        if (primary_count < 0) {
            return -1;
        }
        cursor = 2u + (size_t)primary_count * 22u;
        if (length < cursor || length - cursor < 24u) {
            return -1;
        }
        secondary_count = read_i16le(body + cursor + 22u);
        if (secondary_count < 0) {
            return -1;
        }
        cursor += 24u + (size_t)secondary_count * 18u;
        if (length < cursor || (length - cursor) % 16u != 0u) {
            return -1;
        }
        *body_length = cursor;
        *kind = SCENE_ACTION_PAYLOAD_VARIABLE;
        return 1;
    }
    case 0x33: {
        /* 0x40c186: counts at +0x6d/+0x6f, 113 + 6*count_6d + 66*count_6f
         * bytes copied verbatim (A-33.1). The original narrows the size to a
         * signed WORD; native safety rejects negative counts and any size
         * above 32767 instead of reproducing the wrap. */
        int16_t count_6d;
        int16_t count_6f;
        size_t typed;
        if (length < 113u) {
            return -1;
        }
        count_6d = read_i16le(body + 109u);
        count_6f = read_i16le(body + 111u);
        if (count_6d < 0 || count_6f < 0) {
            return -1;
        }
        typed = 113u + 6u * (size_t)count_6d + 66u * (size_t)count_6f;
        if (typed > 32767u || typed > length || (length - typed) % 16u != 0u) {
            return -1;
        }
        *body_length = typed;
        *kind = SCENE_ACTION_PAYLOAD_VARIABLE;
        return 1;
    }
    case 0x4b: {
        int16_t selector;
        size_t typed_length;

        /* 0x40c625: selector -1 selects the 33-byte AUTOTEXT key form (35 bytes
         * with the selector), otherwise the selector is the inline text length.
         * Other negative selectors read uninitialised data in the original and
         * are native safety rejections; the key must be NUL-terminated. */
        if (length < 2u) {
            return -1;
        }
        selector = read_i16le(body);
        if (selector == -1) {
            typed_length = 35u;
            if (length < typed_length || memchr(body + 2u, 0, 33u) == NULL) {
                return -1;
            }
        } else {
            if (selector < 0 || selector > 9999) {
                return -1;
            }
            typed_length = 2u + (size_t)selector;
            if (length < typed_length) {
                return -1;
            }
        }
        *body_length = typed_length;
        *kind = SCENE_ACTION_PAYLOAD_VARIABLE;
        return 1;
    }
    case 0x0c: {
        int16_t count_18;
        size_t typed;

        /* 0x40bafd: signed count at +8, size 10 + 18 * count narrowed to a
         * signed WORD in the original; counts outside 0..1819 are native
         * safety rejections (no size wrap). */
        if (length < 10u) {
            return -1;
        }
        count_18 = read_i16le(body + 8u);
        if (count_18 < 0 || count_18 > 1819) {
            return -1;
        }
        typed = 10u + (size_t)count_18 * 18u;
        if (length < typed) {
            return -1;
        }
        *body_length = typed;
        *kind = SCENE_ACTION_PAYLOAD_VARIABLE;
        return 1;
    }
    case 0x16: /* raw 0x16..0x19 share loader arm 0x40b98f (A-16.1, A-17.1) */
    case 0x17: {
        int16_t count;
        /* 0x40b998..0x40b9a9 narrows size to signed int16 before allocation.
         * Reject negative counts and any size wrap; no string fields. */
        if (length < 22u) {
            return -1;
        }
        count = read_i16le(body + 20u);
        if (count < 0 || count > 1819) {
            return -1;
        }
        *body_length = 22u + 18u * (size_t)count;
        *kind = SCENE_ACTION_PAYLOAD_VARIABLE;
        return 1;
    }
    case 0x3e: {
        int16_t primary_count;
        size_t secondary_count;
        size_t cursor = 178u;
        size_t entry;

        /* 0x41c7f4 with the 0x3e prefix arm: 178-byte prefix (five 33-byte
         * name/key fields at 0, 33, 66, 101 and 136), signed word primary
         * count at +176, low-signed-byte condition counts (high byte skipped).
         * Negative counts and unterminated names are native safety rejections,
         * mirrored from action_family_3e_decode. */
        if (length < cursor) {
            return -1;
        }
        if (memchr(body, 0, 33u) == NULL || memchr(body + 33u, 0, 33u) == NULL ||
            memchr(body + 66u, 0, 33u) == NULL || memchr(body + 101u, 0, 33u) == NULL ||
            memchr(body + 136u, 0, 33u) == NULL) {
            return -1;
        }
        primary_count = read_i16le(body + 176u);
        if (primary_count < 0) {
            return -1;
        }
        for (entry = 0u; entry < (size_t)primary_count; ++entry) {
            size_t count;
            size_t extent;
            if (length - cursor < 2u) {
                return -1;
            }
            count = body[cursor];
            if (count > 127u) {
                return -1;
            }
            extent = 70u + 5u * count;
            if (extent > length - cursor) {
                return -1;
            }
            if (memchr(body + cursor + 2u + 5u * count, 0, 33u) == NULL ||
                memchr(body + cursor + 35u + 5u * count, 0, 33u) == NULL) {
                return -1;
            }
            cursor += extent;
        }
        if (length - cursor < 2u) {
            return -1;
        }
        secondary_count = body[cursor];
        if (secondary_count > 127u) {
            return -1;
        }
        cursor += 2u;
        for (entry = 0u; entry < secondary_count; ++entry) {
            size_t count;
            size_t extent;
            if (length - cursor < 2u) {
                return -1;
            }
            count = body[cursor];
            if (count > 127u) {
                return -1;
            }
            extent = 6u + 5u * count;
            if (extent > length - cursor) {
                return -1;
            }
            cursor += extent;
        }
        *body_length = cursor;
        *kind = SCENE_ACTION_PAYLOAD_VARIABLE;
        return 1;
    }
    case 0x3f: {
        /* 0x41cd3c..0x41dac8: 77-byte prefix, signed word primary count at +75,
         * low-signed-byte condition counts (high byte skipped); negative or
         * unterminated-name cases are native safety rejections. */
        int16_t primary_count;
        size_t secondary_count;
        size_t cursor = 77u;
        size_t entry;
        if (length < cursor) {
            return -1;
        }
        /* The decoder requires NUL-terminated 33-byte name and key fields. */
        if (memchr(body, 0, 33u) == NULL || memchr(body + 35u, 0, 33u) == NULL) {
            return -1;
        }
        primary_count = read_i16le(body + 75u);
        if (primary_count < 0) {
            return -1;
        }
        for (entry = 0u; entry < (size_t)primary_count; ++entry) {
            size_t count;
            size_t extent;
            if (length - cursor < 2u) {
                return -1;
            }
            count = body[cursor]; /* original movsx reads LOW signed byte */
            if (count > 127u) {
                return -1;
            }
            extent = 70u + 5u * count;
            if (extent > length - cursor) {
                return -1;
            }
            if (memchr(body + cursor + 2u + 5u * count, 0, 33u) == NULL ||
                memchr(body + cursor + 35u + 5u * count, 0, 33u) == NULL) {
                return -1;
            }
            cursor += extent;
        }
        if (length - cursor < 2u) {
            return -1;
        }
        secondary_count = body[cursor]; /* high byte is skipped */
        if (secondary_count > 127u) {
            return -1;
        }
        cursor += 2u;
        for (entry = 0u; entry < secondary_count; ++entry) {
            size_t count;
            size_t extent;
            if (length - cursor < 2u) {
                return -1;
            }
            count = body[cursor];
            if (count > 127u) {
                return -1;
            }
            extent = 6u + 5u * count;
            if (extent > length - cursor) {
                return -1;
            }
            cursor += extent;
        }
        *body_length = cursor;
        *kind = SCENE_ACTION_PAYLOAD_VARIABLE;
        return 1;
    }
    case 0x6a: {
        uint16_t count;
        if (length < 42u) {
            return -1;
        }
        count = read_u16le(body + 40u);
        /* Original arithmetic uses a signed 16-bit count; reject negative
         * values and overflow before applying its 42 + count * 18 layout. */
        if (count > INT16_MAX || (size_t)count > (SIZE_MAX - 42u) / 18u) {
            return -1;
        }
        *body_length = 42u + (size_t)count * 18u;
        *kind = SCENE_ACTION_PAYLOAD_HOTSPOT_ARRAY;
        return 1;
    }
    default:
        return 0;
    }
    *body_length = fixed_length;
    *kind = SCENE_ACTION_PAYLOAD_FIXED;
    return 1;
}

/* Dependency-tail content checks the original runs before building the tree
 * (0x424cb0..0x424e98, A-TAIL.2): opcode 0x12 opens and 0x13 closes a group.
 * The original logs a message and aborts the load for an open immediately
 * followed by a close, for an open, one leaf and a close, for an adjacent
 * 0x0b pair whose first record has a zero word at +6, and for unbalanced
 * open/close counts. Opcodes are signed 16-bit words at the start of each
 * 16-byte record; the first failure in scan order is final. Ordering of
 * opens and closes is not checked at this stage. */
static int dependency_prescan_ok(const uint8_t *records, size_t count)
{
    size_t row;
    size_t opens = 0u;
    size_t closes = 0u;

    for (row = 0u; row < count; ++row) {
        int16_t opcode = read_i16le(records + row * SCENE_RESOURCE_DEPENDENCY_BYTES);

        if (opcode == 0x12) {
            ++opens;
            if (row + 1u < count &&
                read_i16le(records + (row + 1u) * SCENE_RESOURCE_DEPENDENCY_BYTES) == 0x13) {
                return 0;
            }
            if (row + 2u < count &&
                read_i16le(records + (row + 2u) * SCENE_RESOURCE_DEPENDENCY_BYTES) == 0x13) {
                return 0;
            }
        } else if (opcode == 0x13) {
            ++closes;
        } else if (opcode == 0x0b) {
            if (row + 1u < count &&
                read_i16le(records + (row + 1u) * SCENE_RESOURCE_DEPENDENCY_BYTES) == 0x0b &&
                read_i16le(records + row * SCENE_RESOURCE_DEPENDENCY_BYTES + 6u) == 0) {
                return 0;
            }
        }
    }
    return opens == closes;
}

static int parse_action(SceneAction *action, const uint8_t *payload, size_t length)
{
    size_t typed_length;
    size_t remaining;
    SceneActionPayloadKind kind = SCENE_ACTION_PAYLOAD_OPAQUE;

    if (length < SCENE_ACTION_HEADER_BYTES ||
        !copy_fixed_string(action->info.description,
                           sizeof(action->info.description), payload,
                           SCENE_RESOURCE_ACTION_NAME_BYTES)) {
        return 0;
    }
    action->info.type = payload[48u];
    action->info.subtype = payload[49u];
    action->info.raw_body = payload + SCENE_ACTION_HEADER_BYTES;
    action->info.raw_body_length = length - SCENE_ACTION_HEADER_BYTES;
    action->info.typed_body = NULL;
    action->info.typed_body_length = 0u;
    action->info.dependency_records = NULL;
    action->info.dependency_count = 0u;

    {
        int layout = known_body_length(action->info.type, action->info.raw_body,
                                       action->info.raw_body_length,
                                       &typed_length, &kind);
        if (layout == 0) {
            return 1;
        }
        if (layout < 0) {
            return 0;
        }
    }
    if (typed_length > action->info.raw_body_length) {
        return 0;
    }
    remaining = action->info.raw_body_length - typed_length;
    if (remaining % SCENE_RESOURCE_DEPENDENCY_BYTES != 0u ||
        !dependency_prescan_ok(action->info.raw_body + typed_length,
                               remaining / SCENE_RESOURCE_DEPENDENCY_BYTES)) {
        return 0;
    }
    action->info.payload_kind = kind;
    action->info.typed_body = action->info.raw_body;
    action->info.typed_body_length = typed_length;
    action->info.dependency_records = action->info.raw_body + typed_length;
    action->info.dependency_count = remaining / SCENE_RESOURCE_DEPENDENCY_BYTES;
    return 1;
}

static int visit_chunks(Hiff *hiff, const char *id, size_t data_index,
                        size_t *matches, SceneResource *scene,
                        int is_summary)
{
    const uint8_t *payload;
    size_t length;
    HiffSelectionInfo selection;
    size_t found = 0u;
    size_t action_index = 0u;
    int status = hiff_select_first(hiff, id);

    while (status == HIFF_OK) {
        if (!selected_chunk(hiff, &payload, &length, &selection)) {
            return 0;
        }
        if (selection.data_index == data_index) {
            if (is_summary) {
                if (!copy_summary(scene, payload, length)) {
                    return 0;
                }
            } else if (scene != NULL) {
                if (scene->actions == NULL ||
                    action_index >= scene->summary.action_count ||
                    !parse_action(&scene->actions[action_index], payload, length)) {
                    return 0;
                }
                ++action_index;
            }
            ++found;
        }
        status = hiff_select_next(hiff, id);
    }
    if (matches != NULL) {
        *matches = found;
    }
    return is_summary || scene == NULL || action_index == scene->summary.action_count;
}

SceneResource *scene_resource_open_memory(const void *bytes, size_t length,
                                          char *error, size_t error_capacity)
{
    SceneResource *scene;
    size_t scen_count = 0u;
    size_t scen_index = 0u;
    size_t tsum_count = 0u;
    size_t action_count = 0u;

    if (error != NULL && error_capacity != 0u) {
        error[0] = '\0';
    }
    if (bytes == NULL || length == 0u) {
        set_error(error, error_capacity, "scene resource input is empty");
        return NULL;
    }
    scene = (SceneResource *)calloc(1u, sizeof(*scene));
    if (scene == NULL) {
        set_error(error, error_capacity, "cannot allocate scene resource");
        return NULL;
    }
    scene->hiff = hiff_open_memory(bytes, length, error, error_capacity);
    if (scene->hiff == NULL) {
        free(scene);
        return NULL;
    }
    if (!count_data_type(scene->hiff, "SCEN", &scen_count, &scen_index) ||
        scen_count != 1u) {
        set_error(error, error_capacity, "scene resource must contain one SCEN DATA record");
        scene_resource_close(scene);
        return NULL;
    }
    if (!visit_chunks(scene->hiff, "TSUM", scen_index, &tsum_count, scene, 1) ||
        tsum_count != 1u) {
        set_error(error, error_capacity, "SCEN must contain one valid TSUM chunk");
        scene_resource_close(scene);
        return NULL;
    }
    if (!visit_chunks(scene->hiff, "ACT", scen_index, &action_count, NULL, 0) ||
        action_count > SCENE_RESOURCE_MAX_ACTIONS) {
        set_error(error, error_capacity, "SCEN action count exceeds parser limit");
        scene_resource_close(scene);
        return NULL;
    }
    scene->summary.action_count = action_count;
    if (action_count != 0u) {
        scene->actions = (SceneAction *)calloc(action_count, sizeof(*scene->actions));
        if (scene->actions == NULL) {
            set_error(error, error_capacity, "cannot allocate scene action table");
            scene_resource_close(scene);
            return NULL;
        }
        if (!visit_chunks(scene->hiff, "ACT", scen_index, NULL, scene, 0)) {
            set_error(error, error_capacity, "invalid ACT chunk or typed action boundary");
            scene_resource_close(scene);
            return NULL;
        }
    }
    return scene;
}

void scene_resource_close(SceneResource *scene)
{
    if (scene != NULL) {
        free(scene->actions);
        hiff_close(scene->hiff);
        free(scene);
    }
}

int scene_resource_get_summary(const SceneResource *scene,
                               SceneResourceSummary *summary)
{
    if (scene == NULL || summary == NULL) {
        return SCENE_RESOURCE_ERR_ARGUMENT;
    }
    *summary = scene->summary;
    return SCENE_RESOURCE_OK;
}

size_t scene_resource_action_count(const SceneResource *scene)
{
    return scene == NULL ? 0u : scene->summary.action_count;
}

int scene_resource_action_at(const SceneResource *scene, size_t index,
                             SceneActionInfo *info)
{
    if (scene == NULL || info == NULL) {
        return SCENE_RESOURCE_ERR_ARGUMENT;
    }
    if (index >= scene->summary.action_count) {
        return SCENE_RESOURCE_ERR_NOT_FOUND;
    }
    *info = scene->actions[index].info;
    return SCENE_RESOURCE_OK;
}

int scene_resource_dependency_at(const SceneResource *scene,
                                 size_t action_index,
                                 size_t dependency_index,
                                 SceneDependencyInfo *info)
{
    const SceneActionInfo *action;
    const uint8_t *bytes;
    size_t field_index;

    if (scene == NULL || info == NULL) {
        return SCENE_RESOURCE_ERR_ARGUMENT;
    }
    if (action_index >= scene->summary.action_count) {
        return SCENE_RESOURCE_ERR_NOT_FOUND;
    }
    action = &scene->actions[action_index].info;
    if (dependency_index >= action->dependency_count) {
        return SCENE_RESOURCE_ERR_NOT_FOUND;
    }
    bytes = action->dependency_records +
            dependency_index * SCENE_RESOURCE_DEPENDENCY_BYTES;
    for (field_index = 0u; field_index < 8u; ++field_index) {
        info->fields[field_index] = read_i16le(bytes + field_index * 2u);
    }
    info->opcode = read_u16le(bytes);
    /* The original reducer checks the fourth signed 16-bit word and treats
     * exactly one as an OR link. */
    info->or_after = info->fields[3];
    info->raw_bytes = bytes;
    return SCENE_RESOURCE_OK;
}

const char *scene_resource_status_string(int status)
{
    switch (status) {
    case SCENE_RESOURCE_OK: return "ok";
    case SCENE_RESOURCE_ERR_ARGUMENT: return "invalid argument";
    case SCENE_RESOURCE_ERR_MEMORY: return "out of memory";
    case SCENE_RESOURCE_ERR_FORMAT: return "invalid scene resource format";
    case SCENE_RESOURCE_ERR_BOUNDS: return "scene resource field is out of bounds";
    case SCENE_RESOURCE_ERR_LIMIT: return "scene resource limit exceeded";
    case SCENE_RESOURCE_ERR_NOT_FOUND: return "item not found";
    default: return "unknown scene resource status";
    }
}
