#include "action_family_44_runtime.h"

#include <stdio.h>
#include <string.h>

#include "action_family_d8_runtime.h"

#define OBJ_WORD0 0x00u
#define OBJ_WORD2 0x02u
#define OBJ_WORD_C 0x0cu
#define OBJ_WORD_E 0x0eu
#define OBJ_NAME2 0xeau
#define OBJ_SRC_RECT 0x10bu
#define OBJ_DST_RECT 0x11bu
#define OBJ_BUTTONS 0x12bu
#define OBJ_DOWN 0x16bu
#define OBJ_INACTIVE 0x1abu
#define OBJ_FPS 0x1ebu

static int16_t rds16(const uint8_t *p) { return (int16_t)(uint16_t)(p[0] | (p[1] << 8)); }

static void put16(uint8_t *p, uint16_t v)
{
    p[0] = (uint8_t)v;
    p[1] = (uint8_t)(v >> 8);
}

static void put32(uint8_t *p, uint32_t v)
{
    p[0] = (uint8_t)v;
    p[1] = (uint8_t)(v >> 8);
    p[2] = (uint8_t)(v >> 16);
    p[3] = (uint8_t)(v >> 24);
}

/* Accepted link entries (value != 0x270f), or -1 when the input is invalid. */
static int accepted_links(const A44TextResult *text)
{
    int count = 0;
    if (text->has_links == 0u) return 0;
    if (text->link_count < 0) return 0; /* the original loop does not run */
    if ((size_t)text->link_count > A44_LINK_MAX) return -1;
    for (int16_t i = 0; i < text->link_count; ++i) {
        if (text->link_value[i] != A44_NO_LINK) ++count;
    }
    return count > (int)D8_ENTRY_MAX ? -1 : count;
}

static int check(const uint8_t *object, size_t object_bytes, const A44TextResult *text, int *links)
{
    if (object == NULL || text == NULL) return A44_ERR_ARGUMENT;
    if (object_bytes <= A44_OBJECT_HEADER_BYTES) return A44_ERR_BODY;
    if (memchr(object + OBJ_NAME2, 0, D8_NAME_BYTES) == NULL) return A44_ERR_BODY;
    *links = accepted_links(text);
    return *links < 0 ? A44_ERR_BOUNDS : A44_OK;
}

size_t a44_record_length(const uint8_t *object, size_t object_bytes, const A44TextResult *text)
{
    int links;
    if (check(object, object_bytes, text, &links) != A44_OK) return 0u;
    return d8_record_bytes(links);
}

int a44_build_record(const uint8_t *object, size_t object_bytes, const A44TextResult *text, uint8_t *out,
                     size_t capacity, size_t *out_bytes)
{
    int links;
    int status = check(object, object_bytes, text, &links);
    uint8_t record[D8_RECORD_MAX_BYTES];
    char number[16];
    size_t length;
    size_t used;
    int written = 0;
    if (status != A44_OK) return status;
    length = d8_record_bytes(links);
    if (out == NULL || out_bytes == NULL || capacity < length) return A44_ERR_ARGUMENT;

    memset(record, 0, sizeof(record));
    memcpy(record, "USE_LISTPAGE", 12u);
    (void)snprintf(number, sizeof(number), "%d", (int)rds16(object + OBJ_WORD2) - 2); /* itoa(value, buf, 10) */
    memcpy(record + 12, number, strlen(number) + 1u);                                 /* strcat */
    used = strlen((const char *)(object + OBJ_NAME2)) + 1u;
    memcpy(record + D8_NAME_BYTES, object + OBJ_NAME2, used);                         /* strcpy */
    memcpy(record + 0x42, object + OBJ_WORD0, 2u);
    put32(record + 0x50, (uint32_t)(int32_t)rds16(object + OBJ_WORD_E));
    put32(record + 0x4c, (uint32_t)(int32_t)rds16(object + OBJ_WORD_C));
    memcpy(record + 0x54, object + OBJ_SRC_RECT, 16u);
    memcpy(record + 0x64, object + OBJ_DST_RECT, 16u);
    memcpy(record + 0x74, object + OBJ_BUTTONS, 64u);
    memcpy(record + 0xb4, object + OBJ_DOWN, 64u);
    memcpy(record + 0xf4, object + OBJ_INACTIVE, 64u);
    record[0x134] = object[OBJ_FPS];
    if (text->has_links != 0u && text->link_count > 0) {
        for (int16_t i = 0; i < text->link_count; ++i) {
            uint8_t *entry;
            if (text->link_value[i] == A44_NO_LINK) continue;
            entry = record + D8_RECORD_FIXED_BYTES + (size_t)written * D8_ENTRY_BYTES;
            put16(entry, (uint16_t)text->link_value[i]);
            memcpy(entry + 2, text->link_rect[i], 16u);
            ++written;
        }
    }
    put16(record + 0x15e, (uint16_t)written);
    memcpy(out, record, length);
    *out_bytes = length;
    return A44_OK;
}
