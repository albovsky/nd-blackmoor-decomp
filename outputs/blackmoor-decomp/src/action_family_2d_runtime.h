#ifndef BLACKMOOR_ACTION_FAMILY_2D_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_2D_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#include "session_bindings_a2e.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0x2d, the random-movie set (RT-36). Raw 0x2d owns the random-movie object at 0x63821d that raw 0x2e
 * (RT-33, src/session_bindings_a2e.[ch]) controls. Original code (GAME.EXE, SHA-256 afd337a2...5c45), confirmed in the
 * disassembly; Ghidra pseudocode was navigation only:
 *   0x427f27  dispatcher arm of 0x427a50: gate 0x423f57(deps, 0), then 0x4cd6ff(ECX = 0x63821d, row word).
 *   0x4cd243  loader (src/action_family_2d.[ch]): the typed body becomes three heap blocks (header +0x222, entry table
 *             +0x226, group table +0x22a); the object is one static singleton, so a scene holds one 0x2d row.
 *   0x4cd6ff  the handler. It stores the row in +0x23e and the row's header pointer in +0x222 on every visit, then
 *             switches on the row phase (0x5bb632 + row * 0x8d):
 *             phase 0 (0x4cd76d) init: fatal if the object is already active (+0x216), teardown 0x4ccef1, surface
 *               release 0x4ccfbd, active := 1, start flag 0x5bb1ca := 1, 0x4d36ed, save 0x5839a9 into +0x202; header
 *               word +0x21 == 1: 0x5839a9 := 0, +0x17a := 1, otherwise 0x5839a9 := 1, +0x17a := 0 and three entry
 *               globals := 0; clip +0x246: a header named "RandomMovie" picks entry 0 (count 1) or rand % count
 *               (0x4cf0a9), any other name is looked up among the entry names (0x4cf026, strcmp); the clip is loaded
 *               by 0x4cdfd3; group +0x24a := -1, 0x5d1a39 := surface, state +0x1de := 0, row phase := 1.
 *             phase 1 (0x4cdb26) every pass: the group scan (the group whose key word equals the word 0x5bb50b
 *               sets +0x236 and 0x5d1a45 := 1 and +0x24a), then a switch on +0x1de: 0 plays the clip (0x4ce602 for an
 *               AVF clip, 0x4ce8ea for a Bink clip, chosen by +0x21a) while +0x236 is set; 1 waits for the tick
 *               deadline +0x24e; 3 stops the stream, picks the next record with the weights (0x4cf0ce) and either
 *               loops the main clip (random delay between the entry dwords +0x25 and +0x29) or loads the clip the
 *               record names; 2 (paused by raw 0x2e) does nothing.
 *             phase 2 (0x4cdfb7): the stop 0x4ceb3b.
 *   0x4ceb3b  stop: active := 0, 0x5d1a45 := 0, 0x5839a9 := +0x202, 0x4d36ed, the destructor 0x4cd218 (teardown
 *             0x4ccef1, surface release 0x4ccfbd, row erase 0x4ccff5, reset 0x4ccdab), then the completion byte of
 *             the row given as argument := 1. Raw 0x2e mode 0 calls it with +0x23e.
 *   0x4ccef1 / 0x4ccfbd / 0x4ccff5 / 0x4ccdab  teardown, surface release, row erase (frees the tables, row type := 0,
 *             completion := 0, phase := 0, dependency reset 0x423b51), reset (memset +8..+0x1d6, then fields).
 *   0x4cdfd3  clip load: four file probes (BIK, BIK in the second directory, AVF, AVF in the second directory;
 *             the first hit sets +0x21a to 1 for BIK or 0 for AVF), name copy to +0x159, +0x1cc := 1, +0x1ce := 2,
 *             stream reset 0x44c4c1, surface size check, then per kind the surface create, the Bink open/prepare
 *             (0x4bef11 / 0x4bf19a on the Bink player 0x6201f9) or the AVF decode thread (0x4497a0, proc 0x4cf687).
 *   0x4ceb8c  group rectangles; 0x4cec6c frame advance; 0x4cecf7 render entry (fixed Z slot 16 at 0x5d1a31, type 0xb,
 *             callback 0x4cf749 = one 0x4c5377 blit of the movie surface); the world init 0x4381f4 runs 0x4cd218 (0x4383f2) and 0x4cecf7 (0x439500) once; a scene load does neither.
 *
 * Every engine, media and OS call whose body lies outside this slice is one D2Op of D2Host in the original order.
 * The AVF decode thread (0x4cf687) is host behaviour: it owns the stream sub-object fields (+0x24, +0x172, +0x182,
 * +0x18e, +0x192, the video rectangle +0x1b2..+0x1be and the frame-ready word +0x1d4) that this kernel only reads (it
 * clears +0x1d4 itself). Nothing here claims original source structure. */

#define D2_RUNTIME_TYPE UINT8_C(0x2d)
#define D2_NAME_BYTES 33u
#define D2_MAX_RECTS 8
#define D2_NO_ROW (-1)

/* Parsed typed body of a raw 0x2d row: what 0x4cd243 builds. Strings are NUL terminated inside their 33-byte spans
 * (native check; the original scans past a missing NUL). */
typedef struct D2Record {
    char name[D2_NAME_BYTES]; /* the clip this record names (record35, +0) */
    int16_t weight;           /* record35 word +0x21 */
} D2Record;

typedef struct D2Entry {
    char name[D2_NAME_BYTES];
    int16_t word_21;   /* first frame / initial +0x1ca */
    int16_t word_23;   /* last frame */
    int32_t delay_min; /* dword +0x25 */
    int32_t delay_max; /* dword +0x29 */
    int16_t weight;    /* word +0x2d, the weight of staying on this clip */
    int16_t record_count;
    D2Record *records;
} D2Entry;

typedef struct D2Group {
    int16_t key; /* group record34 word +0, compared with the word 0x5bb50b */
    int32_t src[4]; /* +2, +6, +0xa, +0xe */
    int32_t dst[4]; /* +0x12, +0x16, +0x1a, +0x1e (view origin added at use) */
} D2Group;

typedef struct D2Set {
    char name[D2_NAME_BYTES];
    int16_t mode_word; /* header word +0x21: 1 = the buffer ring (+0x17a := 1), else the single buffer */
    int16_t entry_count;
    int16_t group_count;
    D2Entry *entries;
    D2Group *groups;
} D2Set;

/* Native checks that the original does not make: counts are non-negative (the original allocates >= 2 GiB and dies),
 * every name has its NUL inside the 33-byte span, the body fits. */
int d2_set_parse(const uint8_t *body, size_t length, D2Set *out, const char **why);
void d2_set_free(D2Set *set);

/* The object at 0x63821d (offsets in comments). Shared fields live in `movie` (raw 0x2e touches them). */
typedef struct D2Object {
    SessionA2EMovie movie; /* active +0x216, mode +0x23a, row +0x242, state_1de +0x1de, flag_206 +0x206,
                              pending_25a +0x25a */
    int32_t stream_state_4;   /* +0x4: 2 while the stream is being torn down */
    uint32_t period_24;       /* +0x24 (host: frame period of the stream) */
    int32_t decoder_172;      /* +0x172 (host) */
    uint32_t buffers_182[3];  /* +0x182.. (host: frame buffer addresses) */
    int32_t ring_17a;         /* +0x17a: 1 = frames come from the buffer ring (+0x182[+0x192]), 0 = the one buffer +0x182 */
    int32_t kind_17e;         /* +0x17e: copy of +0x21a */
    char name_159[D2_NAME_BYTES]; /* +0x159: the clip name */
    int32_t bink_id_18e;      /* +0x18e (host) */
    int16_t buffer_192;       /* +0x192: ring index (host advances it; init writes 0) */
    int32_t rect_1b2, rect_1b6, rect_1ba, rect_1be; /* host: video rectangle */
    uint32_t deadline_1c6;
    int16_t frame_1ca;
    int16_t word_1cc, word_1ce;
    int16_t ready_1d4;        /* host sets, the kernel clears */
    uint32_t thread_1d6;      /* decode thread handle (0 = none) */
    int32_t state_1da;
    int32_t rects[D2_MAX_RECTS]; /* +0x1e2 src (l, t, r, b), +0x1f2 dst (l, t, r, b) */
    int32_t saved_202;
    int32_t flag_20a, flag_20e;
    uint32_t surface_212;
    int32_t kind_21a;
    const D2Set *set;         /* +0x222 / +0x226 / +0x22a (NULL = freed or none) */
    int32_t scan_22e;
    int32_t frame_232;
    int32_t group_hit_236;
    int32_t action_23e;
    int32_t clip_246;
    int32_t group_24a;
    uint32_t deadline_24e;
    int32_t delay_252;
    int32_t record_256;
} D2Object;

/* Process globals the kernel reads or writes. Inputs are set by the host before a step. */
typedef struct D2World {
    int32_t start_flag;       /* 0x5bb1ca */
    int32_t g_5839a9;
    int32_t g_5d16cd, g_5d1683, g_5d1639;
    int32_t g_5831c8;         /* 0x4d36ed */
    int16_t g_5831c6;         /* 0x4d36ed */
    uint32_t entry_surface;   /* 0x5d1a39 */
    int32_t entry_flag;       /* 0x5d1a45 */
    /* Z entry slot 16 (0x5d1a31) as 0x4cecf7 writes it; zero until registered. */
    int32_t entry_type;       /* 0x5d1a31 */
    int32_t entry_flag_49;    /* 0x5d1a49 */
    int16_t entry_word_4d;    /* 0x5d1a4d */
    char entry_label[16];     /* 0x5d1a53 */
    /* Inputs. */
    int16_t scene_key;        /* word 0x5bb50b */
    int32_t view_x, view_y;   /* 0x583186, 0x58318a */
    int16_t thread_arg;       /* word 0x5b016f */
    uint32_t back_buffer;     /* 0x5cf665 */
} D2World;

typedef enum D2OpCode {
    D2_OP_RAND = 1,           /* 0x50cd50 -> value */
    D2_OP_TICK = 2,           /* GetTickCount (call [0x52a23c]) -> value */
    D2_OP_FILE_EXISTS = 3,    /* 0x449d90(path): name, a = variant 0 BIK, 1 BIK dir 2, 2 AVF, 3 AVF dir 2 -> nonzero = exists */
    D2_OP_STREAM_POLL = 4,    /* 0x44c479(obj+4) (value ignored) */
    D2_OP_THREAD_STOP = 5,    /* 0x449a94, a = thread handle */
    D2_OP_THREAD_DELETE = 6,  /* virtual destructor of the thread object (flag 1), a = handle */
    D2_OP_STREAM_RELEASE = 7, /* 0x44c4ab(obj+4) */
    D2_OP_Z_UNREGISTER_A = 8, /* 0x415011(0x5e2dbe, obj+8) */
    D2_OP_Z_UNREGISTER_B = 9, /* 0x41632b(0x5e2dbe, obj+8) */
    D2_OP_BINK_RELEASE = 10,  /* 0x4bedfa(0x6201f9, &obj+0x18e), a = +0x18e */
    D2_OP_SURFACE_RELEASE = 11, /* 0x4c2dfb(&obj+0x212), a = handle */
    D2_OP_STREAM_RESET = 12,  /* 0x44c4c1(obj+8) */
    D2_OP_SURFACE_CREATE = 13, /* 0x4c2a8d(w, h, 8, label): a = w, b = h, c = 8, d = 0 AVF label / 1 Bink label -> handle */
    D2_OP_Z_REGISTER = 14,    /* 0x4161d1(0x5e2dbe, obj+8) */
    D2_OP_THREAD_CREATE = 15, /* malloc 0x46 + 0x4497a0(proc 0x4cf687, a = word 0x5b016f, 4) -> handle, 0 = failure */
    D2_OP_THREAD_RESUME = 16, /* 0x449bff, a = handle */
    D2_OP_BINK_OPEN = 17,     /* 0x4bef11(id, 0): a = id -> nonzero = failure */
    D2_OP_BINK_PREPARE = 18,  /* 0x4bf19a(id, frames + 1): a = id, b = count -> nonzero = ok */
    D2_OP_BINK_READY = 19,    /* 0x4bef85(id) -> nonzero = a frame is ready */
    D2_OP_BINK_NEXT = 20,     /* 0x4befc8(id) */
    D2_OP_BINK_BLIT = 21,     /* 0x4bf098(id, pixels, w, h, 0, 0): a = id, b = surface handle */
    D2_OP_BINK_FRAME = 22,    /* 0x4bee2c(id) -> frame number */
    D2_OP_BINK_MORE = 23,     /* 0x4bf10f(id) -> nonzero = frames remain */
    D2_OP_FRAME_COPY = 24     /* inline copy of one decoded frame into the surface: a = -1 single buffer, else ring index */
} D2OpCode;

typedef struct D2OpArgs {
    int32_t a, b, c, d;
    const char *name; /* FILE_EXISTS only */
} D2OpArgs;

typedef struct D2Host {
    void *context;
    /* One engine call; nonzero return = the host failed (the visit stops with D2_ERR_HOST, there is no recovery in
     * the original). `ret` is set for the ops that return a value. */
    int (*op)(void *context, int op, const D2OpArgs *args, int32_t *ret);
    /* Pure query (no call in the original: the original reads the surface struct): the surface's width (+0x2b) and
     * height (+0x2d) words. */
    int (*surface_dims)(void *context, uint32_t surface, int16_t *width, int16_t *height);
} D2Host;

typedef enum D2Status {
    D2_OK = 0,
    D2_ERR_ARGUMENT = 1,
    D2_ERR_BODY = 2,
    D2_ERR_HOST = 3,
    D2_ERR_FATAL = 4,      /* the original reaches the fatal path 0x4c97b4 */
    D2_ERR_UNSUPPORTED = 5
} D2Status;

typedef struct D2StepResult {
    uint32_t phase_after;  /* the row phase after the visit */
    int32_t retire_row;    /* D2_NO_ROW, or the row the stop erased and completed (0x4ccff5 + 0x4ceb75) */
    uint8_t initialized;   /* phase 0 ran */
    uint8_t stopped;       /* phase 2 ran the stop */
} D2StepResult;

/* A power-on object: 0x4ccdab over zeroed storage. */
void d2_object_reset(D2Object *object);
void d2_world_init(D2World *world);

/* One true-gate visit of 0x4cd6ff (row = the word argument, phase = the row's phase dword). `set` is the visiting row's
 * parsed body. `failure` is optional. A host or fatal failure after effects leaves the effects in place (the original
 * does not recover); the session must stop. */
int d2_step(D2Object *object, const D2Set *set, int16_t row, uint32_t phase, D2World *world, const D2Host *host,
            D2StepResult *result, const char **failure);

/* 0x4ceb3b without the final completion byte store: the stop. `retire_row` receives the row the destructor erased
 * (the object's +0x23e before the reset), D2_NO_ROW when none; the caller completes it. */
int d2_stop(D2Object *object, D2World *world, const D2Host *host, int32_t *retire_row);

/* 0x4cd218: teardown, surface release, row erase, reset (world init 0x4381f4 and the stop run it, not a scene load). */
int d2_destruct(D2Object *object, const D2Host *host, int32_t *erased_row);

/* 0x4cecf7: register the render entry in Z slot 16. */
void d2_register_entry(const D2Object *object, D2World *world);

/* 0x4cf749: the one blit of the render callback; valid is 0 when the object is inactive or its flag 0x206 is 0. */
typedef struct D2RenderPlan {
    uint8_t valid;
    uint32_t surface;
    uint32_t target;
    int32_t src[4];
    int32_t dst[4];
} D2RenderPlan;
int d2_render_plan(const D2Object *object, const D2World *world, D2RenderPlan *plan);

#ifdef __cplusplus
}
#endif
#endif
