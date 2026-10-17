#ifndef BLACKMOOR_ACTION_FAMILY_33_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_33_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0x33, the "secondary video" with hotspots (RT-46). Original code (GAME.EXE, SHA-256 afd337a2...5c45),
 * confirmed in the disassembly; Ghidra pseudocode was navigation only:
 *   0x40c186  loader arm (src/action_family_33.[ch], A-33.1): body = 113 + 6 * count_6d + 66 * count_6f bytes.
 *   0x42c221  the handler (dispatcher arm of 0x427a50, gate 0x423f57 mode 1; argument = the row word). Every visit it
 *             points 0x5b4ead at the body, 0x5b4ea5 at the 6-byte table (NULL when count_6d <= 0) and 0x5b4ea9 at the
 *             66-byte hotspot table (count_6f <= 0 is fatal: "ERROR - Missing video hotspot data"), then switches on the
 *             row phase (0x5bb632 + row * 0x8d):
 *             phase 0 (init): the object is a singleton, so 0x5c39f1 != 0 is fatal ("trying to play a Secondary
 *               video ..."); sets the page word 0x5b4dc8, the row word 0x5b4e89, kind 0x5b4e8b (body +0x46), 0x5b4ea3
 *               (body +0x4a), 0x5c39f1 := 1, the request dword of the row := 0, 0x5d1967 := 0, 0x5b4e8d := 0; stops
 *               and deletes a previous decode thread (0x5b4e0c) under the stream lock 0x5b4c3a; frees the two decode
 *               buffers 0x5b4db8 / 0x5b4dbc (unless flag bit 8); unregisters 0x5b4c3e from the Z list (0x415011); releases
 *               the surfaces 0x5d03bf / 0x5d03c7; copies the clip name to 0x5b4d8f, body words +0x42 / +0x44 to
 *               0x5b4e02 / 0x5b4e04; resets the stream (0x44c4c1); kind 2 copies the overlay name to 0x5b4e68 and loads
 *               the overlay surface (0x44c2e0(1)); creates the "SEC_0_VIDEO_0" surface, 0x5d195b := it; starts the
 *               reader thread (0x4497a0 with proc 0x44cde2) or is fatal; the animation word +0x48 picks frame / state
 *               0x5b4e00 / 0x5b4e10 / 0x5b4e14 (1: +0x4c, 0, 0; 2: +0x54, 0, 3); 0x5b4e0a := 0; resumes the thread;
 *               phase := 1; then falls into the phase 1 code in the same visit.
 *             phase 1 (every visit): request dword := 0, 0x5d1967 := 0, 0x5b4e8d := 0, then on 0x5b4e10: 0 (waiting
 *               for the first frame): when the reader flagged a frame (0x5b4e0a) the first hotspot whose key equals the
 *               selector word 0x5bb50b sets the start flag 0x5bb1ca, runs 0x42ca22 (event flags from the 6-byte
 *               table), 0x42e72c (page flip), 0x42d215 (frame advance), 0x42caa8 (hotspot rectangles, request cells),
 *               clears 0x5b4e0a and arms the deadline 0x5b4dfc = tick + 0x5b4c5a; then 0x5b4e10 := 4. State 4:
 *               before the deadline 0x42caa8 is re-run for the first hit; after it the first hit (the scan stops at the
 *               first hit) runs, when a frame is flagged, 0x42e72c, 0x42ca22, 0x42d215, a new deadline and the clear of
 *               0x5b4e0a, then 0x42caa8.
 *             phase 2: returns while no frame is flagged (0x5b4e0a == 0); then clears the object (0x5b4e89 := 0xffff,
 *               0x5b4e8b := 1, 0x5b4ea3 := 1, 0x5c39f1 := 0), pushes the saved-scene record (0x42e560(2), body byte
 *               +0x6c == 1), stores the scene-change cells (0x5bb57b from body word +0x58, 0x5bb599, 0x5bb595,
 *               0x5c39ff, 0x5bb59b, 0x5bb59f, 0x5bb5a3) and engine mode 0x583999 := 4, and completes the row (0x42ba3a).
 *   0x42ca22  event flags: each 6-byte table entry whose key word equals the frame word 0x5b4e00 and whose index word is
 *             not -1 stores dword [0x585801 + 4 * index] := the value word.
 *   0x42e72c  page flip (under the stream lock, acquire result ignored): 0x5b4dc8 toggles 0/1; kind (0x5b4e04) 2 makes the
 *             surface 0x5d03bf show the buffer [0x5b4db8 + 4 * page].
 *   0x42d215  frame advance on 0x5b4e14: 0 loop (+1, > body +0x4e wraps to +0x4c), 1 hold (+1, > +0x52 stays at +0x52),
 *             2 reverse (-1, < +0x4c snaps to +0x4c and state 0), 3 end (+1, > +0x56 stays); afterwards state 1 with
 *             0x5c39e5 != row word becomes 2.
 *   0x42caa8  hotspot rectangles (source / destination, clipped against the 4-word rect 0x5bb583..0x5bb58f, view origin
 *             0x583186 / 0x58318a added), the request cells of the row (kind 2), 0x42cecd the same for the second
 *             rectangle pair (kind 2 sets 0x5b4e8d := 1).
 *   0x42e560  the saved-scene push (src/scene_stack.[ch], host op A33_OP_PUSH_SCENE here).
 *   0x44cde2  the reader thread proc: host behaviour (it owns the buffers 0x5b4db8 / 0x5b4dbc, sets the ready word
 *             0x5b4e0a and the delay 0x5b4c5a; see src/avf_player.[ch], SECONDARY_VIDEO).
 *
 * Every engine, media and OS call whose body lies outside this slice is one A33Op of A33Host, in the original order.
 * Nothing here claims original source structure. */

#define A33_RUNTIME_TYPE UINT8_C(0x33)
#define A33_NAME_BYTES 33u
#define A33_NO_ROW (-1)

/* One 6-byte entry (0x5b4ea5 table) and one 66-byte hotspot (0x5b4ea9 table) of the typed body. */
typedef struct A33Entry {
    int16_t key;   /* compared with the frame word 0x5b4e00 */
    int16_t index; /* event flag index; -1 = none */
    int16_t value; /* stored sign-extended */
} A33Entry;

typedef struct A33Hotspot {
    int16_t key;     /* compared with the selector word 0x5bb50b */
    int32_t src1[4]; /* +2 +6 +0xa +0xe  (left, top, right, bottom) */
    int32_t dst1[4]; /* +0x12 +0x16 +0x1a +0x1e */
    int32_t src2[4]; /* +0x22 +0x26 +0x2a +0x2e */
    int32_t dst2[4]; /* +0x32 +0x36 +0x3a +0x3e */
} A33Hotspot;

/* Parsed typed body (what 0x40c186 copies). Names are NUL terminated inside their 33-byte spans (native check; the
 * original scans past a missing NUL); counts are non-negative (the original allocates >= 2 GiB and dies). */
typedef struct A33Set {
    char clip[A33_NAME_BYTES];    /* +0x00 */
    char overlay[A33_NAME_BYTES]; /* +0x21 */
    int16_t w42, w44;             /* -> 0x5b4e02, 0x5b4e04 (w44 == 2: pages) */
    int16_t kind_46;              /* -> 0x5b4e8b; 2 = overlay surface + hotspot rectangles */
    int16_t anim_48;              /* 1 loop, 2 hold */
    int16_t w4a;                  /* -> 0x5b4ea3 */
    int16_t w4c, w4e, w50, w52, w54, w56; /* frame ranges */
    int16_t scene_58, w5a, w5c, w5e;      /* -> 0x5bb57b (sign-extended), 0x5bb599, 0x5bb595, 0x5c39ff */
    int32_t d60, d64, d68;                /* -> 0x5bb59b, 0x5bb59f, 0x5bb5a3 */
    uint8_t push_6c;                      /* 1: push the saved-scene record before leaving */
    int16_t entry_count;                  /* word +0x6d */
    int16_t hotspot_count;                /* word +0x6f */
    A33Entry *entries;
    A33Hotspot *hotspots;
} A33Set;

int a33_set_parse(const uint8_t *body, size_t length, A33Set *out, const char **why);
void a33_set_free(A33Set *set);

/* The process globals the handler reads or writes (address in the comment). Fields the host owns are filled before a
 * step by the binding and read back after it; the kernel only reads them (inputs) or clears them as noted. */
typedef struct A33State {
    /* object state */
    int16_t page_5b4dc8;
    int16_t row_5b4e89;       /* word */
    int16_t kind_5b4e8b;      /* word */
    int16_t mode_5b4ea3;      /* word */
    int32_t active_5c39f1;
    int32_t latch_5d1967;
    int16_t flag_5b4e8d;
    int16_t frame_5b4e00;     /* word */
    int16_t w_5b4e02, present_5b4e04;
    int32_t state_5b4e10;     /* 0, 4 */
    int32_t anim_5b4e14;      /* 0..3 */
    uint32_t deadline_5b4dfc;
    char clip_5b4d8f[A33_NAME_BYTES];
    char overlay_5b4e68[A33_NAME_BYTES];
    int32_t start_5bb1ca;
    /* handles */
    uint32_t thread_5b4e0c;   /* reader thread object, 0 = none */
    int32_t stream_5b4c3a;    /* lock / state word: 2 while the thread is torn down */
    uint32_t buf_5b4db8, buf_5b4dbc;     /* decode buffers (host allocates) */
    uint16_t flags_5b4dc0, flags_5b4dc2; /* bit 8 = not freeable */
    uint32_t surface_5d03bf, surface_5d03c7, surface_5d195b;
    /* hotspot working rectangles */
    int32_t src1_5b4e18[4];   /* 0x5b4e18 0x5b4e1c 0x5b4e20 0x5b4e24 */
    int32_t dst1_5b4e28[4];   /* 0x5b4e28 0x5b4e2c 0x5b4e30 0x5b4e34 */
    int32_t src2_5b4e38[4];   /* 0x5b4e38 0x5b4e3c 0x5b4e40 0x5b4e44 */
    int32_t dst2_5b4e48[4];   /* 0x5b4e48 0x5b4e4c 0x5b4e50 0x5b4e54 */
    int32_t rel_dst1_5b4e58[4]; /* 0x5b4e58 (left) 0x5b4e5c (top) 0x5b4e60 (right) 0x5b4e64 (bottom) */
    int32_t rel_dst2_5b4e93[4]; /* 0x5b4e93 (left) 0x5b4e97 (top) 0x5b4e9b (right) 0x5b4e9f (bottom) */
    /* scene-change cells written by phase 2 */
    int32_t scene_5bb57b;
    int16_t w_5bb599, w_5bb595, w_5c39ff;
    int32_t d_5bb59b, d_5bb59f, d_5bb5a3;
    int32_t mode_583999;
    /* table pointers (0x5b4ea5 / 0x5b4ea9 nonzero) */
    int32_t has_entries_5b4ea5;
    int32_t has_hotspots_5b4ea9;
    /* inputs the host provides */
    int16_t selector_5bb50b;
    int32_t view_x_583186, view_y_58318a;
    int16_t thread_arg_5b016f;
    int32_t latch_5c39e5;         /* the pointer cascade's candidate (read by 0x42d215) */
    int32_t delay_5b4c5a;         /* reader: frame period in ms */
    int16_t ready_5b4e0a;         /* reader: a frame is flagged; the kernel clears it */
    int32_t vrect_5b4de8, vrect_5b4dec, vrect_5b4df0, vrect_5b4df4; /* video rectangle (l, t, r, b) */
    int32_t clip_5bb583[4];       /* 0x5bb583 0x5bb587 0x5bb58b 0x5bb58f: the clip rectangle */
} A33State;

/* The row cells the handler writes (row slot +0x41 request dword 0x5bb626, +0x45..0x4b words 0x5bb62a..0x5bb630). */
typedef struct A33Row {
    int32_t request;
    int16_t rect[4]; /* 0x5bb62a 0x5bb62c 0x5bb62e 0x5bb630 */
} A33Row;

typedef enum A33OpCode {
    A33_OP_LOG = 1,            /* 0x50ca3e (+ 0x52139c on the fatal paths): a = message id (A33LogId) */
    A33_OP_STREAM_LOCK = 2,    /* 0x44c479(0x5b4c3a), value ignored */
    A33_OP_STREAM_UNLOCK = 3,  /* 0x44c4ab(0x5b4c3a) */
    A33_OP_THREAD_STOP = 4,    /* 0x449a94, a = thread */
    A33_OP_THREAD_DELETE = 5,  /* virtual destructor (flag 1), a = thread */
    A33_OP_FREE = 6,           /* 0x51dc6c, a = buffer handle */
    A33_OP_Z_UNREGISTER = 7,   /* 0x415011(0x5e2dbe, 0x5b4c3e) */
    A33_OP_SURFACE_RELEASE = 8, /* 0x4c2dfb(&global): a = handle, b = 0 for 0x5d03bf, 1 for 0x5d03c7; the global becomes 0 */
    A33_OP_STREAM_RESET = 9,   /* 0x44c4c1(0x5b4c3e) */
    A33_OP_OVERLAY_LOAD = 10,  /* 0x44c2e0(1): loads the overlay surface -> handle, stored in 0x5d03c7 */
    A33_OP_SURFACE_CREATE = 11, /* 0x4c2c3a(w, h, 8, 1, "SEC_0_VIDEO_0"): a = w, b = h -> handle */
    A33_OP_THREAD_CREATE = 12, /* malloc 0x46 + 0x4497a0(0x44cde2, 0x63888b, word 0x5b016f, 4): a = word -> handle, 0 = failure */
    A33_OP_THREAD_RESUME = 13, /* 0x449bff, a = thread */
    A33_OP_TICK = 14,          /* GetTickCount -> value */
    A33_OP_SURFACE_PIXELS = 15, /* [surface] := buffer (0x42e792..0x42e7a5): a = surface 0x5d03bf, b = buffer */
    A33_OP_EVENT_FLAG = 16,    /* dword [0x585801 + 4 * a] := b */
    A33_OP_PUSH_SCENE = 17     /* 0x42e560(2): a = 2 */
} A33OpCode;

typedef enum A33LogId {
    A33_LOG_MISSING_HOTSPOTS = 1,  /* "ERROR - Missing video hotspot data": fatal */
    A33_LOG_SECOND_VIDEO = 2,      /* "ERROR - trying to play a Secondary video ...": fatal */
    A33_LOG_THREAD_START = 3,      /* "Secondary Video Reader Thread ...", b = scene word 0x5bb57b */
    A33_LOG_THREAD_MEMORY = 4      /* "Unable to get memory for thread": fatal */
} A33LogId;

typedef struct A33OpArgs {
    int32_t a, b;
} A33OpArgs;

typedef struct A33Host {
    void *context;
    /* One engine call; nonzero return = the host failed (the visit stops with A33_ERR_HOST, there is no recovery in the
     * original). `ret` is set for the ops that return a value. */
    int (*op)(void *context, int op, const A33OpArgs *args, int32_t *ret);
} A33Host;

typedef enum A33Status {
    A33_OK = 0,
    A33_ERR_ARGUMENT = 1,
    A33_ERR_BODY = 2,
    A33_ERR_HOST = 3,
    A33_ERR_FATAL = 4,      /* the original reaches the fatal path 0x4c97b4 */
    A33_ERR_UNSUPPORTED = 5
} A33Status;

typedef struct A33StepResult {
    uint32_t phase_after; /* the row phase after the visit */
    uint8_t initialized;  /* phase 0 ran */
    uint8_t finished;     /* phase 2 ran to the completion 0x42ba3a */
} A33StepResult;

/* Power-on state of the globals (all zero except nothing: the image holds zeros there). */
void a33_state_init(A33State *state);

/* One true-gate visit of 0x42c221 (row = the word argument, phase = the row's phase dword). `set` is the visiting row's
 * parsed body, `row_cells` the row's request cells. `failure` is optional. A host or fatal failure after effects leaves the
 * effects in place (the original does not recover); the session must stop. */
int a33_step(A33State *state, const A33Set *set, int16_t row, A33Row *row_cells, uint32_t phase, const A33Host *host,
             A33StepResult *result, const char **failure);

#ifdef __cplusplus
}
#endif
#endif
