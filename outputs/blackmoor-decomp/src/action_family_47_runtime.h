#ifndef BLACKMOOR_ACTION_FAMILY_47_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_47_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0x47 (journal entry add, RT-42): the entry appender 0x412787.
 *
 * Original code (GAME.EXE, SHA-256 afd337a2...5c45), confirmed in the disassembly:
 *   0x411a22  loader: the row's pData is a 0x27-byte copy of the raw body (A-47; scene_resource.c fixed length 39).
 *   0x427a50  dispatcher arm 0x428515 (type 0x47, gate mode 0): gate 0x423f57(deps, 0), then 0x412787(ECX = 0x619a41, row).
 *   0x412787  with body = pData: table t = body word 0 - 3 (kinds 3, 4 and 5 are the three tables; the layout is 0x5957cb
 *             names, 0x59f27b codes, 0x59fbdb counts, 0x59fbe1 link values, see A47Tables).
 *             For each stored entry j below the count word [0x59fbdb + 2t]: an entry whose name equals body + 2 ends the
 *             visit (no add); otherwise the AUTOTEXT lookup 0x423259(0x619a6b, body + 2) runs and a miss (0) also ends the
 *             visit. After the loop a full table (count == 400) reports "AUTOTEXT error - too many list entries on page"
 *             through 0x52139c and the original then goes on to write entry 400 (aliasing the next table). Otherwise
 *             (and after the report) the entry is added: name copied with strcpy semantics, the code word (body + 0x23)
 *             stored, and the link value word (body + 0x25) stored when the code is >= 10 or 7, else 9999 (0x270f); the
 *             count grows by one; kind 4 then calls 0x4e0559(0x570508, 2, 1, 0) and kind 3 calls 0x4e0559(.., 2, 1, 1),
 *             which set the "new entry" flags of page 2 ([0x5a17b4 + 2 * 0x1a4] and the dword of that slot).
 *             Every path ends with the generic completion 0x42ba3a(row).
 * Nothing here claims original source structure. */

#define A47_RAW_TYPE UINT8_C(0x47)
#define A47_BODY_BYTES 39u        /* 0x27: the loader copy */
#define A47_NAME_BYTES 33u
#define A47_TABLES 3u             /* body kinds 3, 4 and 5 */
#define A47_FIRST_KIND 3
#define A47_MAX_ENTRIES 400u      /* names: 400 * 0x21 = 0x3390 per table, words: 0x320 per table */
#define A47_NO_LINK 9999          /* the stored link value for a code below 10 other than 7 (0x270f) */
#define A47_PAGE_SLOTS 3u

typedef enum A47Status {
    A47_OK = 0,
    A47_ERR_ARGUMENT = 1,
    A47_ERR_BODY = 2,       /* shorter than 39 bytes, or a name not terminated within its 33 bytes */
    A47_ERR_KIND = 3,       /* a kind other than 3, 4 or 5: the original indexes memory outside the three tables */
    A47_ERR_FULL = 4,       /* count == 400: the original reports and overruns into the next table; native refuses */
    A47_ERR_STATE = 5,      /* a count word outside 0..400 (never produced by this module) */
    A47_ERR_UNBOUND = 6,    /* the visit needs the AUTOTEXT lookup and none is bound; nothing was changed */
    A47_ERR_LOOKUP = 7      /* the lookup failed; nothing was changed */
} A47Status;

/* The 0x27-byte row body. */
typedef struct A47Body {
    int16_t kind;                       /* +0: 3, 4 or 5 */
    uint8_t name[A47_NAME_BYTES];       /* +2: NUL-terminated key, also the AUTOTEXT key */
    int16_t code;                       /* +0x23 */
    int16_t value;                      /* +0x25 */
} A47Body;

/* The tables the appender works on, in the original's memory order. */
typedef struct A47Tables {
    int16_t count[A47_TABLES];                                        /* words [0x59fbdb + 2t] */
    uint8_t name[A47_TABLES][A47_MAX_ENTRIES][A47_NAME_BYTES];        /* [0x5957cb + 0x3390 t + 0x21 j] */
    int16_t code[A47_TABLES][A47_MAX_ENTRIES];                        /* words [0x59f27b + 0x320 t + 2 j] */
    int16_t link_value[A47_TABLES][A47_MAX_ENTRIES];                  /* words [0x59fbe1 + 0x320 t + 2 j] */
    uint32_t page2_any;                                               /* dword [0x5a17b4 + 0x348] */
    uint32_t page2_slot[A47_PAGE_SLOTS];                              /* dwords [0x5a17b8 + 0x348 + 4 i] */
} A47Tables;

/* 0x423259 on 0x619a6b: 1 when the key is present, 0 when it is not, negative on a failure. `key` is the NUL-terminated name. */
typedef int (*A47KeyLookup)(void *context, const uint8_t *key, size_t key_length);

typedef struct A47Outcome {
    uint8_t duplicate;      /* an entry with the same name ended the visit */
    uint8_t lookup_miss;    /* a failed AUTOTEXT lookup ended the visit */
    uint8_t appended;
    uint8_t flag_call;      /* 0x4e0559 ran */
    int8_t flag_slot;       /* its slot argument (0 or 1), or -1 */
    uint16_t lookups;       /* how many times 0x423259 ran */
    int16_t table;          /* table index t, or -1 when the body kind was not accepted */
    int16_t index;          /* the added entry's index, or -1 */
} A47Outcome;

/* Copies the typed 0x27 bytes of `raw`. The kind is not checked here (a47_step does). */
int a47_decode(const uint8_t *raw, size_t raw_bytes, A47Body *out);

/* One visit of 0x412787. Nothing is changed unless A47_OK is returned (the lookup runs before any store). */
int a47_step(A47Tables *tables, const A47Body *body, A47KeyLookup lookup, void *context, A47Outcome *outcome);

#ifdef __cplusplus
}
#endif
#endif
