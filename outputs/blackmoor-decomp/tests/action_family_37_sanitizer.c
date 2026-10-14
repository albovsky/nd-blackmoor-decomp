#include "../src/action_family_37.h"

#include <inttypes.h>
#include <stdio.h>
#include <string.h>

#define CHECK(condition, label) do { \
    if (!(condition)) { \
        fprintf(stderr, "sanitizer fixture failed: %s\n", label); \
        return 1; \
    } \
} while (0)

static uint32_t random_state = UINT32_C(0x37a2f10d);
static unsigned valid_cases;
static unsigned malformed_cases;

static uint32_t next_random(void)
{
    uint32_t value = random_state;
    value ^= value << 13;
    value ^= value >> 17;
    value ^= value << 5;
    random_state = value;
    return value;
}

static void write_u16(uint8_t *bytes, size_t offset, uint16_t value)
{
    bytes[offset] = (uint8_t)value;
    bytes[offset + 1u] = (uint8_t)(value >> 8);
}

static void write_u32(uint8_t *bytes, size_t offset, uint32_t value)
{
    bytes[offset] = (uint8_t)value;
    bytes[offset + 1u] = (uint8_t)(value >> 8);
    bytes[offset + 2u] = (uint8_t)(value >> 16);
    bytes[offset + 3u] = (uint8_t)(value >> 24);
}

static int valid_extreme_case(void)
{
    uint8_t body[ACTION_FAMILY_37_BODY_BYTES + 8u * ACTION_FAMILY_37_DEPENDENCY_BYTES];
    ActionFamily37Decoded decoded;
    ActionFamily37Constructed constructed;
    uint32_t width;
    uint32_t height;
    size_t index;

    memset(body, 0x5a, sizeof(body));
    body[0] = 0u;
    for (index = 1u; index < 33u; ++index) {
        body[index] = 0xceu;
    }
    write_u16(body, 0x21u, UINT16_C(0x80ff));
    write_u16(body, 0x23u, UINT16_C(0xfe01));
    write_u32(body, 0x25u, UINT32_C(0x80000000));
    write_u32(body, 0x29u, UINT32_C(0x7fffffff));
    write_u32(body, 0x2du, UINT32_C(0x7fffffff));
    write_u32(body, 0x31u, UINT32_C(0x80000000));
    write_u32(body, 0x35u, UINT32_C(0x80000000));
    write_u32(body, 0x39u, UINT32_MAX);
    write_u32(body, 0x3du, UINT32_C(0x12345678));
    write_u32(body, 0x41u, UINT32_C(0x7fffffff));

    CHECK(action_family_37_decode(body, sizeof(body), &decoded) == ACTION_FAMILY_37_OK,
          "extreme decode");
    CHECK(decoded.name[0] == '\0' && decoded.name[1] == '\0',
          "name terminator and normalized suffix");
    CHECK(decoded.option_21 == UINT16_C(0x80ff) &&
          decoded.option_23 == UINT16_C(0xfe01), "little-endian options");
    CHECK(decoded.fixed_rect[0] == INT32_MIN && decoded.fixed_rect[1] == INT32_MAX &&
          decoded.fixed_rect[2] == INT32_MAX && decoded.fixed_rect[3] == INT32_MIN,
          "signed rectangle decoding");
    CHECK(action_family_37_construct(body, sizeof(body), UINT32_C(0xfffffffb),
                                     UINT32_C(0x37000001), &constructed) ==
              ACTION_FAMILY_37_OK,
          "extreme construct");
    width = UINT32_C(0x7fffffff) - UINT32_C(0x80000000);
    height = UINT32_C(0x80000000) - UINT32_C(0x7fffffff);
    CHECK(constructed.object_bytes[0x6fau] == (uint8_t)width &&
          constructed.object_bytes[0x6fbu] == (uint8_t)(width >> 8) &&
          constructed.object_bytes[0x6fcu] == (uint8_t)(width >> 16) &&
          constructed.object_bytes[0x6fdu] == (uint8_t)(width >> 24),
          "x86 wrapping width");
    CHECK(constructed.object_bytes[0x6feu] == (uint8_t)height &&
          constructed.object_bytes[0x6ffu] == (uint8_t)(height >> 8) &&
          constructed.object_bytes[0x700u] == (uint8_t)(height >> 16) &&
          constructed.object_bytes[0x701u] == (uint8_t)(height >> 24),
          "x86 wrapping height");
    CHECK(constructed.payload_offset_after == UINT32_C(0x40),
          "DWORD payload offset wrap");
    CHECK(constructed.owner_links.result_slot_handle == UINT32_C(0x37000001) &&
          constructed.owner_links.owner_slot_1c_handle == UINT32_C(0x37000001) &&
          constructed.owner_links.owner_slot_20_handle == UINT32_C(0x37000001),
          "separate external owner-link aliases");
    CHECK(constructed.owner_links.output_allocation_bytes == ACTION_FAMILY_37_OBJECT_BYTES,
          "bounded allocation size metadata");
    ++valid_cases;
    return 0;
}

static int malformed_atomic_cases(void)
{
    uint8_t body[ACTION_FAMILY_37_BODY_BYTES + 1u];
    ActionFamily37Constructed out;
    ActionFamily37Constructed before;
    ActionFamily37Decoded decoded;
    ActionFamily37Decoded decoded_before;
    size_t length;

    memset(body, 0, sizeof(body));
    body[0] = 0u;
    memset(&out, 0xa5, sizeof(out));
    before = out;
    CHECK(action_family_37_construct(body, ACTION_FAMILY_37_BODY_BYTES - 1u,
                                     0x32u, 1u, &out) == ACTION_FAMILY_37_ERR_BODY,
          "short body status");
    CHECK(memcmp(&out, &before, sizeof(out)) == 0, "short body is atomic");
    ++malformed_cases;

    memset(body, 'N', 33u);
    memset(&decoded, 0xa5, sizeof(decoded));
    decoded_before = decoded;
    CHECK(action_family_37_decode(body, ACTION_FAMILY_37_BODY_BYTES, &decoded) ==
              ACTION_FAMILY_37_ERR_NAME,
          "missing terminator status");
    CHECK(memcmp(&decoded, &decoded_before, sizeof(decoded)) == 0,
          "missing terminator is atomic");
    ++malformed_cases;

    body[0] = 0u;
    CHECK(action_family_37_construct(body, sizeof(body), 0x32u, 1u, &out) ==
              ACTION_FAMILY_37_ERR_TAIL,
          "nonmultiple tail status");
    CHECK(memcmp(&out, &before, sizeof(out)) == 0, "nonmultiple tail is atomic");
    ++malformed_cases;

    CHECK(action_family_37_decode(NULL, ACTION_FAMILY_37_BODY_BYTES, &decoded) ==
              ACTION_FAMILY_37_ERR_ARGUMENT,
          "null body status");
    CHECK(action_family_37_decode(body, ACTION_FAMILY_37_BODY_BYTES, NULL) ==
              ACTION_FAMILY_37_ERR_ARGUMENT,
          "null decoded output status");
    CHECK(action_family_37_construct(body, ACTION_FAMILY_37_BODY_BYTES, 0x32u, 1u, NULL) ==
              ACTION_FAMILY_37_ERR_ARGUMENT,
          "null constructor output status");
    CHECK(action_family_37_construct(body, ACTION_FAMILY_37_BODY_BYTES, 0x32u, 0u, &out) ==
              ACTION_FAMILY_37_ERR_ARGUMENT,
          "zero model handle status");

    length = ACTION_FAMILY_37_BODY_BYTES;
    CHECK(action_family_37_decode((const uint8_t *)(uintptr_t)(UINTPTR_MAX - 8u),
                                  length, &decoded) == ACTION_FAMILY_37_ERR_BOUNDS,
          "wrapped input address is rejected before read");
    CHECK(action_family_37_construct(body, length, 0x32u, 1u,
                                     (ActionFamily37Constructed *)(uintptr_t)(UINTPTR_MAX - 1u)) ==
              ACTION_FAMILY_37_ERR_BOUNDS,
          "wrapped output address is rejected before write");

    {
        union {
            max_align_t align;
            uint8_t bytes[sizeof(ActionFamily37Constructed) + 128u];
        } arena;
        uint8_t snapshot[sizeof(arena.bytes)];
        memset(&arena, 0x6b, sizeof(arena));
        arena.bytes[0] = 0u;
        memcpy(snapshot, arena.bytes, sizeof(snapshot));
        CHECK(action_family_37_construct(arena.bytes, ACTION_FAMILY_37_BODY_BYTES,
                                         0x32u, 1u,
                                         (ActionFamily37Constructed *)(void *)arena.bytes) ==
                  ACTION_FAMILY_37_ERR_OVERLAP,
              "overlapping input/output status");
        CHECK(memcmp(snapshot, arena.bytes, sizeof(snapshot)) == 0,
              "overlapping input/output is atomic");
    }
    ++malformed_cases;
    return 0;
}

static int deterministic_fuzz_cases(void)
{
    uint8_t body[ACTION_FAMILY_37_BODY_BYTES + 8u * ACTION_FAMILY_37_DEPENDENCY_BYTES];
    ActionFamily37Decoded decoded;
    ActionFamily37Constructed constructed;
    unsigned index;

    for (index = 0u; index < 20000u; ++index) {
        size_t tail_count = (size_t)(next_random() % 9u);
        size_t length = ACTION_FAMILY_37_BODY_BYTES +
                        tail_count * ACTION_FAMILY_37_DEPENDENCY_BYTES;
        size_t terminator = (size_t)(next_random() % 33u);
        size_t byte_index;

        for (byte_index = 0u; byte_index < length; ++byte_index) {
            body[byte_index] = (uint8_t)next_random();
        }
        body[terminator] = 0u;
        CHECK(action_family_37_decode(body, length, &decoded) == ACTION_FAMILY_37_OK,
              "random valid decode");
        CHECK(action_family_37_construct(body, length, (uint32_t)next_random(),
                                         UINT32_C(0x37000001) + index,
                                         &constructed) == ACTION_FAMILY_37_OK,
              "random valid construct");
        CHECK(constructed.dependency_count == tail_count,
              "random dependency count");
        CHECK(constructed.body_bytes_consumed == ACTION_FAMILY_37_BODY_BYTES,
              "random fixed cursor advance");
        ++valid_cases;
    }
    for (index = 0u; index < 1024u; ++index) {
        size_t length = (size_t)(next_random() % sizeof(body));
        size_t byte_index;
        for (byte_index = 0u; byte_index < sizeof(body); ++byte_index) {
            body[byte_index] = (uint8_t)next_random();
        }
        body[next_random() % 33u] = 0u;
        (void)action_family_37_decode(body, length, &decoded);
        (void)action_family_37_construct(body, length, 0x32u,
                                         UINT32_C(0x38000001) + index,
                                         &constructed);
        ++malformed_cases;
    }
    return 0;
}

int main(void)
{
    if (valid_extreme_case() != 0 || malformed_atomic_cases() != 0 ||
        deterministic_fuzz_cases() != 0) {
        return 1;
    }
    printf("A-37.2 ASan/UBSan passed: %u valid and %u malformed/fuzz cases\n",
           valid_cases, malformed_cases);
    return 0;
}
