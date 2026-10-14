#ifndef BLACKMOOR_ACTION_FAMILY_35_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_35_RUNTIME_H

#include "action_family_35.h"
#include "avf_player.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Reconstructed lifecycle, not original C++/codec provenance. See RT-7
 * recovery evidence. Host calls are sequential; no reader thread is created.
 * World storage and the body/stream/surface must outlive the controller.
 * Host failures latch terminally; no retry replays partially committed effects.
 * Missing callbacks are detected before any effect of that visit. */
typedef enum A35RuntimeStatus {
    A35_RUNTIME_OK = 0, A35_RUNTIME_ARGUMENT = 1,
    A35_RUNTIME_UNSUPPORTED = 2, A35_RUNTIME_HOST = 3,
    A35_RUNTIME_STATE = 4, A35_RUNTIME_BUSY = 5
} A35RuntimeStatus;

typedef struct A35Rect { int32_t left, top, right, bottom; } A35Rect;

typedef struct A35World {
    int32_t *event_flags;                /* 0x585801 + id*4 */
    size_t event_flag_count;
    int32_t active;                       /* 0x5c39f9 */
    int32_t modal;                        /* 0x5839a9 */
    int32_t start;                        /* 0x5bb1ca */
    int32_t visible;                      /* 0x5d19fb */
    int32_t redraw, cursor;               /* 0x5831c8 / 0x5831c6, 0x4d36ed */
    int32_t layers[3];                    /* 0x5d1639 / 0x5d16cd / 0x5d1683 */
} A35World;

typedef struct A35Input {
    int16_t selector;                     /* 0x5bb50b, not a movie frame */
    int32_t origin_x, origin_y;           /* 0x583186 / 0x58318a */
} A35Input;

typedef struct A35Result {
    uint32_t phase;
    int32_t finish;                       /* caller runs 0x42ba3a by subtype */
    int32_t transition;                   /* body+0x25 == 5, 0x4c0774 */
    int16_t scene, frame, vertical, word;  /* 0x5bb57b / 599 / 595 / 0x5c39ff */
    int32_t dwords[3];                    /* 0x5bb59b / 59f / 5a3 = 0/0/1 */
    int32_t engine;                       /* 0x583999 = 4 */
} A35Result;

typedef struct A35Host {
    void *context;
    /* Open 0x44c4c1, surface 0x4c2c3a, mode 0x4bef11. For AVF also
     * allocate/init an AvfStream and return it. No Bink DoFrame here: opening
     * does not imply that a host can play embedded audio. A nonzero status is
     * A35_RUNTIME_UNSUPPORTED or A35_RUNTIME_HOST. Must roll back on failure. */
    int (*open)(void *, const ActionFamily35Decoded *, AvfStream **);
    void (*close)(void *);                /* 0x4bf773, releases host resources */
    /* Bink library boundaries; decisions/state/flags remain in this kernel.
     * due = !BinkWait; decode = DoFrame, CopyToBuffer, CurrentFrame - 1;
     * next = 0x4bf10f (both directions). decode must include audio support
     * for a stream with embedded audio. Leave it NULL when unavailable so
     * the visit's preflight rejects it before world/frame effects. */
    int (*bink_due)(void *, int *due);
    int (*bink_decode)(void *, int16_t *frame);
    int (*bink_next)(void *, int *more);
    /* Render-list boundary: preserve separate source/destination rectangles;
     * no write to 0x5bb50b. Missing callbacks never silently discard effects. */
    int (*rect)(void *, const A35Rect *, const A35Rect *);
    /* clock/present/lifecycle. frame_event is handled inside the kernel:
     * event-table writes and rect above, rather than an opaque game hook. */
    AvfPlayerHost avf;
} A35Host;

typedef struct A35Snapshot {
    int32_t substate, presented, dirty, shown, flag21a, matched, record;
    int32_t saved_modal;
    A35Rect source, destination;
} A35Snapshot;

typedef struct A35Runtime A35Runtime;
A35Runtime *action35_runtime_create(A35World *, const A35Host *);
void action35_runtime_destroy(A35Runtime *);
int action35_runtime_step(A35Runtime *, const uint8_t *body, size_t length,
                          uint32_t phase, const A35Input *, A35Result *);
/* Called only between visits, then render_ack after the host has consumed the
 * presentation (0x4c0d3f). This is the S03 sequential reader handshake. */
int action35_runtime_worker_poll(A35Runtime *);
int action35_runtime_render_ack(A35Runtime *, uint32_t generation, int *blitted);
int action35_runtime_snapshot(const A35Runtime *, A35Snapshot *);
const char *action35_runtime_failure(const A35Runtime *);

#ifdef __cplusplus
}
#endif
#endif
