#ifndef BLACKMOOR_SCORE_TIME_DISPLAY_H
#define BLACKMOOR_SCORE_TIME_DISPLAY_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* The engine's score / time display widget (RT-55), one static object at 0x638603 shared by several puzzle families (the
 * typing quiz 0xf5 uses it; 0x452576 and 0x4bca71 are further callers). It draws a number (score) and a minutes:seconds
 * clock from digit sprites cut out of a puzzle surface; each half has its own generic z entry (type from the body, the
 * render callback 0x446688 for the score and 0x4468fe for the clock).
 *
 * Original code (GAME.EXE, SHA-256 afd337a2...5c45), confirmed in the disassembly:
 *   0x445f53 / 0x445fc5  reset of the score half / the clock half (zero the digit tables and the sprite block)
 *   0x4460d6 / 0x4462d3  init of the score half (184-byte block) / the clock half (200-byte block): copy the block, derive the
 *                        digit widths and heights, fill the z entry, clear the strings and mark the half ready
 *   0x446532 / 0x446548  enable the score half / the clock half
 *   0x44655e             set the score: store it and format "%d" into the 10-byte string at +0x25c
 *   0x446598             set the clock: store minutes and seconds and format "%02d" into the strings at +0x248 / +0x252
 *   0x446688 / 0x4468fe  the z entry render callbacks: erase the digits of the previous string (restore background), draw
 *                        the digits of the current string, then copy the current strings over the previous ones
 *
 * Object offsets (from 0x638603): +4 score half enabled, +8 clock half enabled, +0xc score ready, +0x10 clock ready,
 * +0x14 score digit widths[10], +0x3c score digit heights[10], +0x64 clock digit widths[10], +0x8c clock digit heights[10],
 * +0xb4 colon width, +0xb8 colon height, +0xbc score block (ten digit rectangles, then x, y, gap, surface, slot, kind),
 * +0x174 clock block (ten digit rectangles, the colon rectangle, then x, y, gap, surface, slot, kind), +0x23c score,
 * +0x240 minutes, +0x244 seconds, +0x248 minutes string, +0x252 seconds string, +0x25c score string, +0x266 previous
 * minutes string, +0x270 previous seconds string, +0x27a previous score string (all 10 bytes), +0x284 loop counter of the
 * init functions (left at 10).
 *
 * Nothing here claims original source structure. */

#define STD_DIGITS 10
#define STD_STRING_BYTES 10
#define STD_MAX_BLITS 64

typedef enum StdStatus {
    STD_OK = 0,
    STD_ERR_ARGUMENT = 1,
    STD_ERR_HOST = 4,
    STD_ERR_BOUNDS = 5
} StdStatus;

/* z entry render callback identifiers handed to the host. */
enum { STD_CALLBACK_SCORE = 2, STD_CALLBACK_CLOCK = 3 };

/* Blit kinds (each is one call site and label of the original). */
typedef enum StdBlitKind {
    STD_BLIT_SCORE_ERASE = 1,   /* 0x4c5377 "Score Time Display - Background Restoration" (0x548288) */
    STD_BLIT_SCORE_DIGIT = 2,   /* 0x4c5d4b "Score Display" (0x5482b4) */
    STD_BLIT_CLOCK_ERASE_MIN = 3, /* 0x4c5377 label 0x5482c4 */
    STD_BLIT_CLOCK_ERASE_COLON = 4, /* 0x4c5377 label 0x5482f0 */
    STD_BLIT_CLOCK_ERASE_SEC = 5, /* 0x4c5377 label 0x54831c */
    STD_BLIT_CLOCK_MIN = 6,     /* 0x4c5d4b "Minutes Display" (0x548348) */
    STD_BLIT_CLOCK_COLON = 7,   /* 0x4c5d4b "Colon Display" (0x548358) */
    STD_BLIT_CLOCK_SEC = 8      /* 0x4c5d4b "Seconds Display" (0x548368) */
} StdBlitKind;

typedef struct StdBlit {
    int32_t kind;         /* StdBlitKind, or a family kind >= 100 */
    uint32_t surface;     /* source surface of a draw; 0 = the host's generic entry 1 surface (0x5d15e3) for a restore */
    int32_t src[4];       /* left top right bottom */
    int32_t dst[4];
    int32_t a;            /* kind specific: the digit for the digit kinds, the character for a text draw */
    int32_t b;
    int32_t c;
} StdBlit;

typedef struct StdDisplay {
    int32_t score_enabled;   /* +4 */
    int32_t clock_enabled;   /* +8 */
    int32_t score_ready;     /* +0xc */
    int32_t clock_ready;     /* +0x10 */
    int32_t score_w[STD_DIGITS];  /* +0x14 */
    int32_t score_h[STD_DIGITS];  /* +0x3c */
    int32_t clock_w[STD_DIGITS];  /* +0x64 */
    int32_t clock_h[STD_DIGITS];  /* +0x8c */
    int32_t colon_w;         /* +0xb4 */
    int32_t colon_h;         /* +0xb8 */
    int32_t score_block[0x2e]; /* +0xbc: [0..39] digit rectangles, [40] x, [41] y, [42] gap, [43] surface, [44] slot, [45] kind */
    int32_t clock_block[0x32]; /* +0x174: [0..39] digit rectangles, [40..43] colon rectangle, [44] x, [45] y, [46] gap,
                                  [47] surface, [48] slot, [49] kind */
    int32_t score;           /* +0x23c */
    int32_t minutes;         /* +0x240 */
    int32_t seconds;         /* +0x244 */
    char minutes_str[STD_STRING_BYTES];  /* +0x248 */
    char seconds_str[STD_STRING_BYTES];  /* +0x252 */
    char score_str[STD_STRING_BYTES];    /* +0x25c */
    char prev_minutes_str[STD_STRING_BYTES]; /* +0x266 */
    char prev_seconds_str[STD_STRING_BYTES]; /* +0x270 */
    char prev_score_str[STD_STRING_BYTES];   /* +0x27a */
    int32_t loop_counter;    /* +0x284 */
} StdDisplay;

/* The part of the engine the widget touches. */
typedef struct StdHost {
    void *context;
    /* The z entry stores of the init functions: type (block kind), callback (STD_CALLBACK_*), surface, flags 0 / 0 / 1 / 1,
     * word 0 and the label "SCORE DISPLAY" / "TIME DISPLAY". */
    int (*register_slot)(void *, int16_t slot, int32_t type, int callback, uint32_t surface, const char *label);
    void (*observe)(void *, int effect, int32_t a, int32_t b);
} StdHost;

enum { STD_FX_BASE = 200, STD_FX_INIT_SCORE = 200, STD_FX_INIT_CLOCK = 201 };

/* 0x445f53 / 0x445fc5. */
void std_reset_score(StdDisplay *d);
void std_reset_clock(StdDisplay *d);

/* 0x446532 / 0x446548. */
void std_enable_score(StdDisplay *d, int32_t value);
void std_enable_clock(StdDisplay *d, int32_t value);

/* 0x44655e: store the score and format "%d". A negative score is refused (the original would index the digit table with
 * '-' - '0' when it draws), and so is one above 99999999 (the original would overflow the ten-byte string). */
int std_set_score(StdDisplay *d, int32_t score);
/* 0x446598: store minutes and seconds and format "%02d" (each 0..99; the original formats larger values into ten bytes
 * too, which cannot happen for the clock values the typing quiz computes). */
int std_set_clock(StdDisplay *d, int32_t minutes, int32_t seconds);

/* 0x4460d6 / 0x4462d3: `block` is the 0x2e (score) or 0x32 (clock) dwords the caller built. Registers the half's z entry
 * through the host. The z entry slot is block[44] (score) / block[48] (clock). */
int std_init_score(StdDisplay *d, const int32_t block[0x2e], const StdHost *host);
int std_init_clock(StdDisplay *d, const int32_t block[0x32], const StdHost *host);

/* 0x446688 / 0x4468fe: one render callback; appends the blits in the order of the original and then copies the current
 * strings over the previous ones. `view_x` / `view_y` are 0x583186 / 0x58318a. Returns STD_ERR_BOUNDS when a string holds a
 * character outside '0'..'9' (the original indexes the digit tables with it). */
int std_render_score(StdDisplay *d, int32_t view_x, int32_t view_y, StdBlit *out, size_t capacity, size_t *count);
int std_render_clock(StdDisplay *d, int32_t view_x, int32_t view_y, StdBlit *out, size_t capacity, size_t *count);

#ifdef __cplusplus
}
#endif
#endif
