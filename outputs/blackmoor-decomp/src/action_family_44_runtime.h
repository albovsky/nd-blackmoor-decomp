#ifndef BLACKMOOR_ACTION_FAMILY_44_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_44_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0x44 (AT_SCROLL_LIST_ENTRY, RT-34): the record builder of 0x411b16.
 *
 * Original code (GAME.EXE, SHA-256 afd337a2...5c45), confirmed in the disassembly:
 *   0x427a50  dispatcher arm 0x44 (gate mode 0): gate 0x423f57(deps, 0), then 0x4121b8(ECX = 0x619a41, row).
 *   0x4121b8  [0x619a41 + 0x102a] := 0; 0x413187(object, object + 0x210, 0, 0) renders the text; 0x42ba3a(row);
 *             0x411b16(object, row, 0).
 *   0x411b16  builds the 0xd8 record (see action_family_d8_runtime.h) from the 0x44 object (the 0x41166e
 *             constructor output of A-44.1, header 0x210 bytes plus text) and the link table the text writer left
 *             behind, frees the old row object, stores the new record as the row's pData, sets the row type 0xd8,
 *             subtype 1, completion byte 0 and phase 0.
 * The renderer 0x413187 itself is not part of this module (it belongs to the text writer port); its outputs that
 * 0x411b16 reads are A44TextResult. Nothing here claims original source structure. */

#define A44_RAW_TYPE UINT8_C(0x44)
#define A44_OBJECT_HEADER_BYTES 0x210u
#define A44_LINK_MAX 400u   /* the link table rows of 0x59fbe1 are 0x320 bytes */
#define A44_NO_LINK 9999    /* a table value that is skipped (0x270f) */

typedef enum A44Status {
    A44_OK = 0,
    A44_ERR_ARGUMENT = 1,
    A44_ERR_BODY = 2,
    A44_ERR_BOUNDS = 3
} A44Status;

/* What 0x411b16 reads after the text writer ran with table index 0. */
typedef struct A44TextResult {
    uint8_t has_links;                    /* [0x619a41 + 0x102a] != 0 */
    int16_t link_count;                   /* word [0x59fbdb] */
    int16_t link_value[A44_LINK_MAX];     /* words [0x59fbe1 + 2 * i] */
    uint8_t link_rect[A44_LINK_MAX][16];  /* bytes [0x619a41 + 0x102e + 16 * i] */
} A44TextResult;

/* Length of the record a build produces for `object`/`text`, or 0 when it is invalid (same checks as the build). */
size_t a44_record_length(const uint8_t *object, size_t object_bytes, const A44TextResult *text);

/* 0x411b16: writes the record into `out` (capacity >= 0x868 is always enough). Rejects before any output:
 * an object shorter than 0x211 bytes, a second name (header + 0xea) not terminated within 0x21 bytes, more than
 * 100 accepted link entries (the original overflows its 0x868-byte buffer), a link count above 400. */
int a44_build_record(const uint8_t *object, size_t object_bytes, const A44TextResult *text, uint8_t *out,
                     size_t capacity, size_t *out_bytes);

#ifdef __cplusplus
}
#endif
#endif
