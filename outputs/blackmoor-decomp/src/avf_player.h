#ifndef AVF_PLAYER_H
#define AVF_PLAYER_H

#include <stddef.h>
#include <stdint.h>

#include "avf_decoder.h"

#ifdef __cplusplus
extern "C" {
#endif

/*
 * AVF playback kernel recovered from GAME.EXE (afd337a2...5c45).
 *
 * The original plays AVF through one worker/consumer protocol shared by
 * four controllers. A reader thread decodes the requested frame whenever the
 * ready short R is clear; the consumer presents it once R is set and the
 * GetTickCount deadline has passed, steps the frame index and re-arms the
 * deadline with the per-frame delay (AVF header +0x1c). The kernel models
 * each controller's own state and acknowledgement rule:
 *
 *   RANDOM_MOVIE    0x4cd6ff state 1 + 0x4ce602; worker 0x4cf687.
 *                   Copies the frame into its surface and clears R itself.
 *   MOVIE           0x4bf9bb state 1 + 0x4c0205; worker 0x4c0c7d.
 *                   Selects the frame buffer; R is cleared by the render
 *                   callback 0x4c0d3f (avf_player_render_ack).
 *   PARTNER_LOGO    0x4dc182 case 2 + 0x4dcdd3; worker 0x4c0c7d.
 *                   Selects the frame buffer; the same tick blits and
 *                   clears R.
 *   SECONDARY_VIDEO 0x42c221 state 1 + 0x42e72c/0x42d215; worker 0x44cde2.
 *                   Random-access chunks in two caller-owned slots; the
 *                   advance swaps the visible slot and clears R.
 *
 * Scheduling is sequential: avf_player_worker_poll is one iteration of the
 * original reader loop and never overlaps a tick. A host that moves the
 * worker to a thread must hold one lock around every call here; that lock
 * stands in for the original spin handshake H (0x44c479/0x44c4ab), whose
 * values and stop ordering the kernel keeps. In single-buffer mode the
 * worker decodes into the buffer the surface shows, as the original does,
 * so a threaded presenter must also hold that lock while it reads it.
 *
 * Failures are terminal, as in the original (which reports and quits):
 * after a tick or poll returns AVF_PLAYER_ERR_HOST, _DECODER or (worker)
 * _UNSUPPORTED, every call except avf_player_stop returns
 * AVF_PLAYER_ERR_STATE. Effects made before the failing point are kept and
 * are never replayed. A start that fails leaves the player stopped.
 *
 * Ownership: the kernel allocates nothing. The caller owns the AVF bytes,
 * the S03-1 AvfStream with its frame buffers and scratch, and (secondary
 * video) the two slot buffers. Stopping never frees or reuses them; a frame
 * the host still shows stays valid until the host itself releases it.
 *
 * Generation tokens are a port safeguard, not an original field: every
 * start and stop takes a new generation; presentations carry it, and
 * acknowledgements naming another generation are rejected as stale.
 */

typedef enum AvfPlayerStatus {
    AVF_PLAYER_OK = 0,
    AVF_PLAYER_ERR_ARGUMENT = 1,    /* NULL pointer, bad config or buffer size */
    AVF_PLAYER_ERR_STATE = 2,       /* not started, or already stopped */
    AVF_PLAYER_ERR_STALE = 3,       /* acknowledgement for another generation */
    AVF_PLAYER_ERR_UNSUPPORTED = 4, /* required host callback missing, Bink
                                       variant, or a source path that the
                                       original cannot execute safely */
    AVF_PLAYER_ERR_DECODER = 5,     /* decoder failure (original: fatal quit);
                                       see AvfPlayer.decoder_status */
    AVF_PLAYER_ERR_HOST = 6         /* a host callback failed; effects made
                                       before that call are kept */
} AvfPlayerStatus;

typedef enum AvfPlayerKind {
    AVF_PLAYER_RANDOM_MOVIE = 0,
    AVF_PLAYER_MOVIE = 1,
    AVF_PLAYER_PARTNER_LOGO = 2,
    AVF_PLAYER_SECONDARY_VIDEO = 3
} AvfPlayerKind;

typedef enum AvfPresentKind {
    AVF_PRESENT_COPY = 1,   /* copy `bytes` into the controller surface */
    AVF_PRESENT_SELECT = 2  /* the surface now points at `pixels` */
} AvfPresentKind;

typedef struct AvfPresentation {
    uint32_t generation;
    AvfPresentKind kind;
    const uint8_t *pixels;
    size_t bytes;
    int slot;               /* frame buffer or chunk slot shown */
    int16_t frame_index;    /* index of the frame the worker decoded */
} AvfPresentation;

typedef enum AvfFrameEventKind {
    AVF_EVENT_RECT = 1,     /* view-record geometry: 0x4ceb8c, 0x4c08d3, 0x42caa8 */
    AVF_EVENT_TRIGGERS = 2, /* per-frame game flags: 0x4c0ab1, 0x42ca22 */
    AVF_EVENT_SOUND = 3,    /* partner sound start 0x4fb2e3 */
    AVF_EVENT_BLIT = 4      /* partner animation blit (0x4dc182 case 2) */
} AvfFrameEventKind;

typedef struct AvfFrameEvent {
    uint32_t generation;
    AvfFrameEventKind kind;
    int16_t frame_index;    /* MOVIE/SECONDARY triggers: frame; PARTNER: -1 */
    int32_t record;         /* view record for RECT; sound id for SOUND; else -1 */
} AvfFrameEvent;

typedef enum AvfLifecycleEvent {
    AVF_LIFE_RESUME = 1,    /* 0x449bff ResumeThread at start */
    AVF_LIFE_ACQUIRE = 2,   /* 0x44c479 returned, H = 1 */
    AVF_LIFE_RELEASE = 3,   /* 0x44c4ab */
    AVF_LIFE_HALT = 4,      /* stop: H = 2 */
    AVF_LIFE_KILL = 5,      /* stop: 0x449a94 + thread delete */
    AVF_LIFE_IDLE = 6       /* stop: H = 0 */
} AvfLifecycleEvent;

typedef struct AvfPlayerHost {
    void *context;
    /* GetTickCount sample, taken at every original call site. Required. */
    uint32_t (*clock)(void *context);
    /* Required. */
    int (*present)(void *context, const AvfPresentation *presentation);
    /* Required whenever the controller emits frame events (start checks). */
    int (*frame_event)(void *context, const AvfFrameEvent *event);
    /* Optional handshake/stop trace. */
    void (*lifecycle)(void *context, AvfLifecycleEvent event);
} AvfPlayerHost;

/* Controller record fields, named after their original storage. */
typedef struct AvfPlayerConfig {
    AvfPlayerKind kind;
    int32_t mode;           /* CChunk +0x172: 0 single, 1 double (others never decode) */
    int16_t first;          /* RANDOM seq+0x21, MOVIE rec+0x2b, PARTNER 0, SECONDARY rec+0x4c */
    int16_t last;           /* RANDOM seq+0x23, MOVIE rec+0x2d, PARTNER count-1 */
    int16_t direction;      /* MOVIE rec+0x29, PARTNER +0xb7: 1 forward, 2 reverse */
    size_t surface_bytes;   /* RANDOM: surface +0x23 copy length */
    int32_t sound;          /* PARTNER +0x102 (sound enabled), sound id +0xde */
    int16_t sound_id;
    /* SECONDARY rec fields (0x42c221 / 0x42d215) */
    int16_t start_mode;     /* rec+0x48: 1 loop from +0x4c, 2 hold from +0x54 */
    int16_t loop_last;      /* rec+0x4e */
    int16_t hold_last;      /* rec+0x52 (mode 1 clamp) */
    int16_t hold_start;     /* rec+0x54 */
    int16_t end_last;       /* rec+0x56 (mode 3 clamp) */
    int16_t present_mode;   /* 0x5b4e04: 2 selects the slot buffer */
} AvfPlayerConfig;

/* Inputs Boot owns, sampled for one tick. */
typedef struct AvfPlayerGate {
    /* RANDOM/MOVIE/SECONDARY: indices of the controller's view records
       whose view equals the current view (0x5bb50b), in record order. */
    const int32_t *records;
    size_t record_count;
    int32_t sound_busy;     /* PARTNER: 0x4f6334 result */
    int32_t skip;           /* PARTNER: 0x58321d == 1 (skip input) */
    int32_t slot_current;   /* SECONDARY: 0x5c39e5 == this slot (0x5b4e89) */
} AvfPlayerGate;

typedef struct AvfPlayer {
    AvfPlayerKind kind;
    AvfPlayerConfig config;
    AvfPlayerHost host;
    AvfStream *stream;              /* caller-owned; buffers +0x17a/+0x17e */
    uint8_t *slots[2];              /* SECONDARY 0x5b4db8 / 0x5b4dbc buffers */
    size_t slot_bytes;
    /* port safeguards (not original fields) */
    uint32_t generation;
    int32_t running;
    int32_t failed;                 /* latched after HOST/DECODER/worker UNSUPPORTED */
    AvfStatus decoder_status;
    /* original state */
    int32_t handshake;              /* H */
    int32_t exit_flag;              /* thread +0x3e */
    int16_t ready;                  /* R: CChunk +0x1cc / 0x5b4e0a */
    int16_t index;                  /* requested frame: CChunk +0x1c2 / 0x5b4e00 */
    int32_t delay;                  /* AVF header +0x1c (obj +0x24 / 0x5b4c5a) */
    int32_t substate;               /* obj +0x1da (0 first, 4 running) / 0x5b4e10 */
    uint32_t deadline;              /* obj +0x1c6 / 0x5b4dfc */
    int32_t presented;              /* RANDOM +0x232 (i32), MOVIE +0x244 (i16) */
    int32_t done;                   /* RANDOM +0x20e, MOVIE +0x21e */
    int32_t finished;               /* RANDOM +0x1de == 3, MOVIE slot state 2,
                                       PARTNER +0x1c == 3 */
    int32_t dirty;                  /* MOVIE +0x216 / PARTNER 0x6381e5 */
    int32_t shown;                  /* MOVIE +0x240 (2 shown, 3 hidden) */
    int32_t visible;                /* RANDOM +0x236 / 0x5d1a45, MOVIE 0x5d19fb */
    int32_t record;                 /* RANDOM +0x24a (-1 none), MOVIE +0x24a */
    int32_t matched;                /* MOVIE +0x246 */
    int32_t flag206, flag20a, flag21a; /* RANDOM +0x206/+0x20a, MOVIE +0x21a */
    uint32_t started_at;            /* PARTNER +0x20 (start-time clock sample) */
    int32_t secondary_mode;         /* 0x5b4e14 */
    int16_t slot_toggle;            /* 0x5b4dc8 */
    const uint8_t *slot_result[2];  /* GetChunk results held in each slot */
    size_t slot_result_bytes[2];
} AvfPlayer;

/*
 * Start a controller over a caller-owned stream (frame modes) or stream +
 * slots (SECONDARY_VIDEO; the stream supplies decoder state and scratch,
 * each slot holds max(frame_bytes, max_unpacked) bytes). The stream must
 * already be initialized with avf_stream_init. Missing required callbacks
 * return AVF_PLAYER_ERR_UNSUPPORTED before any change.
 */
AvfPlayerStatus avf_player_start(AvfPlayer *player, const AvfPlayerConfig *config,
                                 AvfStream *stream, uint8_t *slot0, uint8_t *slot1,
                                 size_t slot_bytes, const AvfPlayerHost *host);

/*
 * RANDOM_MOVIE only: 0x4cdfd3 for the next sequence on the same object.
 * Keeps the double-buffer toggle (the original resets it only on first
 * play); everything else restarts as in avf_player_start.
 */
AvfPlayerStatus avf_player_restart(AvfPlayer *player, const AvfPlayerConfig *config);

/* One worker iteration; *decoded is set when it ran the decoder. */
AvfPlayerStatus avf_player_worker_poll(AvfPlayer *player, int *decoded);

/* One controller step with Boot's gate inputs. */
AvfPlayerStatus avf_player_tick(AvfPlayer *player, const AvfPlayerGate *gate);

/*
 * MOVIE render callback 0x4c0d3f. Returns OK with *blitted = 1 when it
 * consumed a presentation (and requested the next frame unless done), or
 * *blitted = 0 when nothing new was presented (the host redraws as before).
 */
AvfPlayerStatus avf_player_render_ack(AvfPlayer *player, uint32_t generation, int *blitted);

/* SECONDARY_VIDEO: external mode change (0x4f24d9 sets 1). */
AvfPlayerStatus avf_player_set_secondary_mode(AvfPlayer *player, int32_t mode);

/*
 * Stop in source order: acquire, H = 2, kill the worker, release, H = 0.
 * Buffers stay valid and owned by the caller; the generation advances.
 */
AvfPlayerStatus avf_player_stop(AvfPlayer *player);

const char *avf_player_status_name(AvfPlayerStatus status);

#ifdef __cplusplus
}
#endif

#endif
