#include "avf_player.h"

#include <string.h>

/*
 * Recovered from GAME.EXE (afd337a2...5c45). Each function names the
 * original routine it follows; statements keep the source order because
 * host callbacks observe it.
 */

#define CHECK_HOST(call) do { if ((call) != 0) { return AVF_PLAYER_ERR_HOST; } } while (0)

static void lifecycle(const AvfPlayer *p, AvfLifecycleEvent event)
{
    if (p->host.lifecycle != NULL) {
        p->host.lifecycle(p->host.context, event);
    }
}

static uint32_t now(const AvfPlayer *p)
{
    return p->host.clock(p->host.context);
}

static int event(const AvfPlayer *p, AvfFrameEventKind kind, int16_t frame, int32_t record)
{
    AvfFrameEvent e;
    e.generation = p->generation;
    e.kind = kind;
    e.frame_index = frame;
    e.record = record;
    return p->host.frame_event(p->host.context, &e);
}

static int present(const AvfPlayer *p, AvfPresentKind kind, const uint8_t *pixels,
                   size_t bytes, int slot, int16_t frame)
{
    AvfPresentation v;
    v.generation = p->generation;
    v.kind = kind;
    v.pixels = pixels;
    v.bytes = bytes;
    v.slot = slot;
    v.frame_index = frame;
    return p->host.present(p->host.context, &v);
}

/* u32 GetTickCount arithmetic: deadline = now + delay, wrapping. */
static uint32_t arm(const AvfPlayer *p)
{
    return now(p) + (uint32_t)p->delay;
}

/* Index of the frame buffer the consumer shows (CChunk +0x18a toggle). */
static int shown_slot(const AvfPlayer *p)
{
    return (int)p->stream->toggle;
}

/* ------------------------------------------------------------------------ */
/* Handshake 0x44c479 / 0x44c4ab                                            */
/* ------------------------------------------------------------------------ */

/* Sequential model: H is never 1 when another party acquires. */
static int acquire(AvfPlayer *p)
{
    if (p->handshake == 2) {
        return 2;
    }
    p->handshake = 1;
    lifecycle(p, AVF_LIFE_ACQUIRE);
    return 1;
}

/* 0x44c4ab (FUN_0044c4ab): handshake release. */
static void release(AvfPlayer *p)
{
    if (p->handshake != 2) {
        p->handshake = 0;
    }
    lifecycle(p, AVF_LIFE_RELEASE);
}

/* ------------------------------------------------------------------------ */
/* Start / stop                                                             */
/* ------------------------------------------------------------------------ */

static AvfPlayerStatus check_config(const AvfPlayerConfig *c, const AvfStream *stream,
                                    const uint8_t *slot0, const uint8_t *slot1,
                                    size_t slot_bytes)
{
    const AvfFile *file;

    if (stream == NULL || stream->file == NULL || stream->file->data == NULL) {
        return AVF_PLAYER_ERR_ARGUMENT;
    }
    file = stream->file;
    if (c->kind == AVF_PLAYER_SECONDARY_VIDEO) {
        size_t need = file->frame_bytes > file->max_unpacked ? file->frame_bytes
                                                              : file->max_unpacked;
        if (slot0 == NULL || slot1 == NULL || slot0 == slot1 || slot_bytes < need) {
            return AVF_PLAYER_ERR_ARGUMENT;
        }
        if (c->start_mode != 1 && c->start_mode != 2) {
            /* 0x42c221 leaves the index and mode stale for other values. */
            return AVF_PLAYER_ERR_UNSUPPORTED;
        }
        return AVF_PLAYER_OK;
    }
    if (c->kind < AVF_PLAYER_RANDOM_MOVIE || c->kind > AVF_PLAYER_PARTNER_LOGO) {
        return AVF_PLAYER_ERR_ARGUMENT;
    }
    /* 0x4161d1 allocates nothing for other modes; the consumer would then
       present a NULL buffer. */
    if (c->mode != 0 && c->mode != 1) {
        return AVF_PLAYER_ERR_UNSUPPORTED;
    }
    /* 0x4dc182 case 0 always plays the partner animation single-buffered. */
    if (c->kind == AVF_PLAYER_PARTNER_LOGO && c->mode != 0) {
        return AVF_PLAYER_ERR_UNSUPPORTED;
    }
    if (stream->buffers[0] == NULL || (c->mode == 1 && stream->buffers[1] == NULL)) {
        return AVF_PLAYER_ERR_ARGUMENT;
    }
    if (c->kind == AVF_PLAYER_RANDOM_MOVIE &&
        (c->surface_bytes == 0 || c->surface_bytes > stream->buffer_bytes)) {
        return AVF_PLAYER_ERR_ARGUMENT;
    }
    return AVF_PLAYER_OK;
}

/* Fields every frame-mode start sets: 0x4161d1 flags, R = 0, resume. */
static void begin_stream(AvfPlayer *p, int keep_toggle)
{
    uint16_t toggle = p->stream->toggle;
    avf_stream_reset(p->stream);    /* 0x414ceb +0x45/+0x49, 0x4161d1 flags */
    if (keep_toggle) {
        p->stream->toggle = toggle;
    }
    p->delay = (int32_t)p->stream->file->header_1c;
}

AvfPlayerStatus avf_player_start(AvfPlayer *player, const AvfPlayerConfig *config,
                                 AvfStream *stream, uint8_t *slot0, uint8_t *slot1,
                                 size_t slot_bytes, const AvfPlayerHost *host)
{
    AvfPlayerStatus status;
    uint32_t generation;

    if (player == NULL || config == NULL || host == NULL) {
        return AVF_PLAYER_ERR_ARGUMENT;
    }
    if (player->running) {
        return AVF_PLAYER_ERR_STATE;   /* the original stops the old stream first */
    }
    if (host->clock == NULL || host->present == NULL || host->frame_event == NULL) {
        return AVF_PLAYER_ERR_UNSUPPORTED;
    }
    status = check_config(config, stream, slot0, slot1, slot_bytes);
    if (status != AVF_PLAYER_OK) {
        return status;
    }
    generation = player->generation + 1u;
    memset(player, 0, sizeof(*player));
    player->generation = generation;
    player->kind = config->kind;
    player->config = *config;
    player->host = *host;
    player->stream = stream;
    player->decoder_status = AVF_OK;
    player->running = 1;
    player->record = -1;
    player->presented = -1;

    switch (config->kind) {
    case AVF_PLAYER_RANDOM_MOVIE:
        /* 0x4cd6ff state 0: toggle +0x192 = 0, mode; then 0x4cdfd3. */
        stream->toggle = 0;
        begin_stream(player, 1);
        player->index = config->first;              /* seq +0x21 */
        player->ready = 0;
        lifecycle(player, AVF_LIFE_RESUME);
        player->substate = 0;                       /* +0x1da */
        player->flag20a = 0;
        player->done = 0;                           /* +0x20e */
        player->presented = -1;                     /* +0x232 */
        break;
    case AVF_PLAYER_MOVIE:
        /* 0x4bf9bb state 0 (AVF). */
        player->shown = 1;                          /* +0x240 = 1 */
        stream->toggle = 0;                         /* +0x192 = 0 */
        player->visible = 0;                        /* 0x5d19fb */
        player->substate = 0;
        player->dirty = 0;                          /* +0x216 */
        player->flag21a = 0;
        player->done = 0;                           /* +0x21e */
        player->presented = -1;                     /* +0x244 = 0xffff */
        player->record = -1;                        /* +0x24a = NULL */
        begin_stream(player, 1);
        if (config->mode == 0) {
            /* single buffer: the surface shows +0x17a directly */
            if (present(player, AVF_PRESENT_SELECT, stream->buffers[0],
                        stream->file->frame_bytes, 0, -1) != 0) {
                player->running = 0;
                return AVF_PLAYER_ERR_HOST;
            }
        }
        player->index = config->direction == 1 ? config->first : config->last;
        player->ready = 0;
        lifecycle(player, AVF_LIFE_RESUME);
        player->shown = 3;                          /* +0x240 = 3 */
        break;
    case AVF_PLAYER_PARTNER_LOGO:
        /* 0x4dc182 case 0 (animated AVF). */
        stream->toggle = 0;                         /* 0x4dc2f8 */
        player->substate = 0;                       /* 0x6381a9 */
        player->dirty = 0;                          /* 0x6381e5 */
        begin_stream(player, 1);
        if (config->mode == 0) {
            if (present(player, AVF_PRESENT_SELECT, stream->buffers[0],
                        stream->file->frame_bytes, 0, -1) != 0) {
                player->running = 0;
                return AVF_PLAYER_ERR_HOST;
            }
        }
        player->index = config->direction == 1 ? config->first : config->last;
        player->ready = 0;
        lifecycle(player, AVF_LIFE_RESUME);
        player->started_at = now(player);           /* +0x20, logo timer */
        break;
    case AVF_PLAYER_SECONDARY_VIDEO:
        /* 0x42c221 state 0. */
        player->slot_toggle = 0;                    /* 0x5b4dc8 */
        player->slots[0] = slot0;
        player->slots[1] = slot1;
        player->slot_bytes = slot_bytes;
        begin_stream(player, 0);
        if (config->start_mode == 1) {
            player->index = config->first;          /* rec +0x4c */
            player->secondary_mode = 0;
        } else {
            player->index = config->hold_start;     /* rec +0x54 */
            player->secondary_mode = 3;
        }
        player->substate = 0;                       /* 0x5b4e10 */
        player->ready = 0;                          /* 0x5b4e0a */
        lifecycle(player, AVF_LIFE_RESUME);
        break;
    }
    return AVF_PLAYER_OK;
}

AvfPlayerStatus avf_player_restart(AvfPlayer *player, const AvfPlayerConfig *config)
{
    if (player == NULL || config == NULL) {
        return AVF_PLAYER_ERR_ARGUMENT;
    }
    if (player->kind != AVF_PLAYER_RANDOM_MOVIE || config->kind != AVF_PLAYER_RANDOM_MOVIE) {
        return AVF_PLAYER_ERR_UNSUPPORTED;
    }
    if (player->running) {
        return AVF_PLAYER_ERR_STATE;  /* 0x4cd6ff state 3 stops first (0x4ccef1) */
    }
    if (check_config(config, player->stream, NULL, NULL, 0) != AVF_PLAYER_OK ||
        config->mode != player->config.mode) {
        /* +0x17a is set only in 0x4cd6ff state 0; 0x4cdfd3 keeps it. */
        return AVF_PLAYER_ERR_ARGUMENT;
    }
    player->generation += 1u;
    player->config = *config;
    player->running = 1;
    player->failed = 0;
    player->exit_flag = 0;
    player->decoder_status = AVF_OK;
    begin_stream(player, 1);    /* toggle survives: only state 0 resets +0x192 */
    player->index = config->first;
    player->ready = 0;
    lifecycle(player, AVF_LIFE_RESUME);
    player->substate = 0;
    player->flag20a = 0;
    player->done = 0;
    player->presented = -1;
    player->finished = 0;
    return AVF_PLAYER_OK;
}

AvfPlayerStatus avf_player_stop(AvfPlayer *player)
{
    if (player == NULL) {
        return AVF_PLAYER_ERR_ARGUMENT;
    }
    if (!player->running) {
        return AVF_PLAYER_ERR_STATE;
    }
    /* 0x4ccef1 / 0x4bf773 / 0x4dc043 / 0x42c221: acquire, H = 2, kill,
       release (no-op), H = 0. Callers stop only at the quiescence boundary:
       no decode is in flight, so the original acquire never has to wait for
       H == 1 and nothing is forced to 2 over a running decode. */
    (void)acquire(player);
    player->handshake = 2;
    lifecycle(player, AVF_LIFE_HALT);
    player->exit_flag = 1;
    lifecycle(player, AVF_LIFE_KILL);
    release(player);
    player->handshake = 0;
    lifecycle(player, AVF_LIFE_IDLE);
    if (player->kind != AVF_PLAYER_SECONDARY_VIDEO) {
        /* 0x41632b clears the reader flags; the frame buffers it frees stay
           caller-owned here and keep whatever the host still shows. */
        player->stream->flags[0] = 0;
        player->stream->flags[1] = 0;
    }
    player->running = 0;
    player->generation += 1u;
    return AVF_PLAYER_OK;
}

/* ------------------------------------------------------------------------ */
/* Worker: 0x4cf687, 0x4c0c7d (frames), 0x44cde2 (chunks)                    */
/* ------------------------------------------------------------------------ */

AvfPlayerStatus avf_player_worker_poll(AvfPlayer *player, int *decoded)
{
    AvfStatus status = AVF_OK;

    if (decoded != NULL) {
        *decoded = 0;
    }
    if (player == NULL) {
        return AVF_PLAYER_ERR_ARGUMENT;
    }
    if (!player->running || player->exit_flag || player->failed) {
        return AVF_PLAYER_ERR_STATE;            /* AfxEndThread */
    }
    if (player->ready != 0 || acquire(player) == 2) {
        return AVF_PLAYER_OK;                   /* Sleep(1) */
    }
    if (player->kind == AVF_PLAYER_SECONDARY_VIDEO) {
        /* toggle 0 refills 0x5b4dbc (slot 1); otherwise 0x5b4db8 (slot 0).
           The original frees that slot's previous chunk first. */
        int slot = player->slot_toggle == 0 ? 1 : 0;
        const uint8_t *result = NULL;
        size_t bytes = 0;
        AvfRecord record;
        if (avf_record(player->stream->file, player->index, &record) == AVF_OK &&
            record.packed_bytes == 0 && record.unpacked_bytes == 0) {
            /* The original checks the delta sequence first (fatal). */
            if (record.type == AVF_TYPE_DELTA &&
                !(player->stream->chunk_previous != NULL &&
                  player->stream->last_index != -1 &&
                  player->stream->last_index == (int32_t)player->index - 1)) {
                player->decoder_status = AVF_ERR_SEQUENCE;
                player->failed = 1;
                release(player);
                return AVF_PLAYER_ERR_DECODER;
            }
            /* GetChunk would return the shown predecessor, which the next
               refill frees while it is on screen (use after free). */
            player->failed = 1;
            release(player);
            return AVF_PLAYER_ERR_UNSUPPORTED;
        }
        status = avf_get_chunk(player->stream, player->index, player->slots[slot],
                               player->slot_bytes, NULL, 0, 0, NULL, &result, &bytes, NULL);
        if (status == AVF_OK) {
            player->slot_result[slot] = result;
            player->slot_result_bytes[slot] = bytes;
        }
    } else if (player->config.mode == 0) {
        status = avf_decode_single(player->stream, player->index, NULL);
    } else if (player->config.mode == 1) {
        int written;
        status = avf_decode_double(player->stream, player->index, &written, NULL);
    }
    if (status != AVF_OK) {
        /* Original: report and quit. The port keeps R = 0. */
        player->decoder_status = status;
        player->failed = 1;
        release(player);
        return AVF_PLAYER_ERR_DECODER;
    }
    if (decoded != NULL) {
        *decoded = 1;
    }
    release(player);
    player->ready = 1;
    return AVF_PLAYER_OK;
}

/* ------------------------------------------------------------------------ */
/* RANDOM_MOVIE: 0x4cd6ff state 1 gate + 0x4ce602                           */
/* ------------------------------------------------------------------------ */

static AvfPlayerStatus random_present(AvfPlayer *p)
{
    int slot = p->config.mode != 0 ? shown_slot(p) : 0;
    CHECK_HOST(present(p, AVF_PRESENT_COPY, p->stream->buffers[slot], p->config.surface_bytes,
                       slot, p->index));
    p->presented = p->index;                    /* +0x232 */
    return AVF_PLAYER_OK;
}

/* 0x4cec6c */
static void random_step_index(AvfPlayer *p)
{
    p->index = (int16_t)(p->index + 1);
    if (p->config.last < p->index) {
        p->index = p->config.last;
    }
}

static AvfPlayerStatus random_step(AvfPlayer *p)
{
    if (p->substate == 0) {
        if (p->ready == 0) {
            return AVF_PLAYER_OK;
        }
        if (random_present(p) != AVF_PLAYER_OK) {
            return AVF_PLAYER_ERR_HOST;
        }
        p->flag206 = 1;
        p->flag20a = 1;
        CHECK_HOST(event(p, AVF_EVENT_RECT, -1, p->record));   /* 0x4ceb8c */
        random_step_index(p);
        p->deadline = arm(p);
        if (p->presented == (int32_t)p->config.last) {
            p->done = 1;
        }
        if (p->done == 0) {
            p->ready = 0;
        }
        p->substate = 4;
        return AVF_PLAYER_OK;
    }
    if (p->substate != 4 || now(p) < p->deadline) {
        return AVF_PLAYER_OK;
    }
    if (p->done != 0) {
        p->finished = 1;                        /* +0x1de = 3 */
        return AVF_PLAYER_OK;
    }
    if (p->ready == 0) {
        return AVF_PLAYER_OK;
    }
    if (random_present(p) != AVF_PLAYER_OK) {
        return AVF_PLAYER_ERR_HOST;
    }
    p->flag206 = 1;
    CHECK_HOST(event(p, AVF_EVENT_RECT, -1, p->record));
    if (p->presented == (int32_t)p->config.last) {
        p->done = 1;
    }
    p->deadline = arm(p);
    if (p->done == 0) {
        random_step_index(p);
        p->ready = 0;
    }
    return AVF_PLAYER_OK;
}

static AvfPlayerStatus random_tick(AvfPlayer *p, const AvfPlayerGate *g)
{
    /* 0x4cd6ff state 1: first matching view record. */
    p->visible = 0;                             /* +0x236, 0x5d1a45 */
    p->record = -1;                             /* +0x24a */
    if (g->record_count != 0) {
        p->visible = 1;
        p->record = g->records[0];
    }
    if (p->finished || !p->visible) {
        return AVF_PLAYER_OK;                   /* +0x1de != 0 or not visible */
    }
    return random_step(p);
}

/* ------------------------------------------------------------------------ */
/* MOVIE: 0x4bf9bb state 1 gate + 0x4c0205, render ack 0x4c0d3f             */
/* ------------------------------------------------------------------------ */

/* 0x4c09fe */
static void movie_step_index(AvfPlayer *p)
{
    if (p->config.direction == 1) {
        p->index = (int16_t)(p->index + 1);
        if (p->config.last < p->index) {
            p->index = p->config.last;
        }
    } else {
        p->index = (int16_t)(p->index - 1);
        if (p->index < p->config.first) {
            p->index = p->config.first;
        }
    }
}

static AvfPlayerStatus movie_select(AvfPlayer *p)
{
    if (p->config.mode == 1) {
        int slot = shown_slot(p);
        CHECK_HOST(present(p, AVF_PRESENT_SELECT, p->stream->buffers[slot],
                           p->stream->file->frame_bytes, slot, p->index));
    }
    p->presented = (int16_t)p->index;           /* +0x244 */
    return AVF_PLAYER_OK;
}

static AvfPlayerStatus movie_step(AvfPlayer *p)
{
    if (p->substate == 0) {
        if (p->ready == 0) {
            return AVF_PLAYER_OK;
        }
        if (movie_select(p) != AVF_PLAYER_OK) {
            return AVF_PLAYER_ERR_HOST;
        }
        CHECK_HOST(event(p, AVF_EVENT_TRIGGERS, (int16_t)p->presented, -1));   /* 0x4c0ab1 */
        p->dirty = 1;
        p->shown = 2;
        p->flag21a = 1;
        CHECK_HOST(event(p, AVF_EVENT_RECT, -1, p->record));                   /* 0x4c08d3 */
        movie_step_index(p);
        p->deadline = arm(p);
        p->substate = 4;
        return AVF_PLAYER_OK;
    }
    if (p->substate != 4 || now(p) < p->deadline) {
        return AVF_PLAYER_OK;
    }
    if (p->done != 0) {
        CHECK_HOST(event(p, AVF_EVENT_TRIGGERS, (int16_t)p->presented, -1));
        p->finished = 1;                        /* slot state 2 */
        return AVF_PLAYER_OK;
    }
    if (p->ready == 0) {
        return AVF_PLAYER_OK;
    }
    if (movie_select(p) != AVF_PLAYER_OK) {
        return AVF_PLAYER_ERR_HOST;
    }
    CHECK_HOST(event(p, AVF_EVENT_TRIGGERS, (int16_t)p->presented, -1));
    p->dirty = 1;
    CHECK_HOST(event(p, AVF_EVENT_RECT, -1, p->record));
    p->shown = 2;
    if (((int16_t)p->presented == p->config.last && p->config.direction == 1) ||
        ((int16_t)p->presented == p->config.first && p->config.direction == 2)) {
        p->done = 1;
    }
    p->deadline = arm(p);
    if (p->done == 0) {
        movie_step_index(p);
    }
    return AVF_PLAYER_OK;
}

static AvfPlayerStatus movie_tick(AvfPlayer *p, const AvfPlayerGate *g)
{
    size_t i;

    /* 0x4bf9bb state 1 (the action slot state is 1 until finished). */
    if (p->finished) {
        return AVF_PLAYER_OK;
    }
    p->visible = 0;                             /* 0x5d19fb */
    p->dirty = 0;                               /* +0x216 */
    p->record = -1;                             /* +0x24a = NULL */
    p->matched = 0;                             /* +0x246 */
    for (i = 0; i < g->record_count; ++i) {
        AvfPlayerStatus status;
        p->visible = 1;
        p->record = g->records[i];
        status = movie_step(p);
        if (status != AVF_PLAYER_OK) {
            return status;
        }
        p->matched = 1;
    }
    if (p->matched == 0) {
        p->shown = 3;                           /* +0x240 */
    }
    return AVF_PLAYER_OK;
}

AvfPlayerStatus avf_player_render_ack(AvfPlayer *player, uint32_t generation, int *blitted)
{
    if (blitted != NULL) {
        *blitted = 0;
    }
    if (player == NULL || blitted == NULL) {
        return AVF_PLAYER_ERR_ARGUMENT;
    }
    if (generation != player->generation) {
        return AVF_PLAYER_ERR_STALE;
    }
    if (!player->running || player->failed) {
        return AVF_PLAYER_ERR_STATE;
    }
    if (player->kind != AVF_PLAYER_MOVIE) {
        return AVF_PLAYER_ERR_UNSUPPORTED;
    }
    /* 0x4c0d3f */
    if (player->dirty != 0) {
        player->dirty = 0;
        *blitted = 1;
        if (player->done == 0) {
            player->ready = 0;
        }
    }
    return AVF_PLAYER_OK;
}

/* ------------------------------------------------------------------------ */
/* PARTNER_LOGO: 0x4dc182 case 2 + 0x4dcdd3                                  */
/* ------------------------------------------------------------------------ */

/* 0x4dd28d */
static void partner_step_index(AvfPlayer *p)
{
    movie_step_index(p);
}

static AvfPlayerStatus partner_select(AvfPlayer *p)
{
    if (p->config.mode == 1) {
        int slot = shown_slot(p);
        CHECK_HOST(present(p, AVF_PRESENT_SELECT, p->stream->buffers[slot],
                           p->stream->file->frame_bytes, slot, p->index));
    }
    return AVF_PLAYER_OK;
}

/* 0x4dcdd3 ProcessSecondaryMovieSequence: substate 0 starts the first frame, substate 4 steps on
 * the deadline or finishes. The debug log lines are not modelled; the finish stands for
 * +0x1c = 3 plus the 0x4dad60 input reset, which the caller performs. */
static AvfPlayerStatus partner_step(AvfPlayer *p, const AvfPlayerGate *g)
{
    if (p->substate == 0) {
        if (p->ready == 0) {
            return AVF_PLAYER_OK;
        }
        if (partner_select(p) != AVF_PLAYER_OK) {
            return AVF_PLAYER_ERR_HOST;
        }
        partner_step_index(p);
        p->deadline = arm(p);
        if (p->config.sound != 0) {
            CHECK_HOST(event(p, AVF_EVENT_SOUND, -1, p->config.sound_id));    /* 0x4fb2e3 */
        }
        p->dirty = 1;
        p->substate = 4;
        return AVF_PLAYER_OK;
    }
    if (p->substate != 4 || now(p) < p->deadline) {
        return AVF_PLAYER_OK;
    }
    if (((p->index == p->config.last && p->config.direction == 1) ||
         (p->index == p->config.first && p->config.direction == 2)) &&
        (p->config.sound == 0 || g->sound_busy == 0)) {
        p->finished = 1;                        /* +0x1c = 3, 0x4dad60 */
        return AVF_PLAYER_OK;
    }
    if (p->ready == 0) {
        return AVF_PLAYER_OK;
    }
    if (partner_select(p) != AVF_PLAYER_OK) {
        return AVF_PLAYER_ERR_HOST;
    }
    partner_step_index(p);
    p->deadline = arm(p);
    p->dirty = 1;
    return AVF_PLAYER_OK;
}

static AvfPlayerStatus partner_tick(AvfPlayer *p, const AvfPlayerGate *g)
{
    AvfPlayerStatus status;

    if (p->finished) {
        return AVF_PLAYER_OK;
    }
    status = partner_step(p, g);
    if (status != AVF_PLAYER_OK || p->finished) {
        return status;
    }
    if (p->dirty != 0) {
        CHECK_HOST(event(p, AVF_EVENT_BLIT, -1, -1));
        p->dirty = 0;
        p->ready = 0;
    }
    /* Skip input finishes a running animation (substate 4 or 5). */
    if (g->skip != 0 && (p->substate == 4 || p->substate == 5)) {
        p->finished = 1;
    }
    return AVF_PLAYER_OK;
}

/* ------------------------------------------------------------------------ */
/* SECONDARY_VIDEO: 0x42c221 state 1, 0x42e72c, 0x42d215                    */
/* ------------------------------------------------------------------------ */

/* 0x42e72c: acquire, flip, select, release (acquire result ignored). */
static AvfPlayerStatus secondary_swap(AvfPlayer *p)
{
    (void)acquire(p);
    p->slot_toggle = (int16_t)(p->slot_toggle == 0);
    if (p->config.present_mode == 2) {
        int slot = p->slot_toggle;
        if (present(p, AVF_PRESENT_SELECT, p->slot_result[slot], p->slot_result_bytes[slot],
                    slot, p->index) != 0) {
            release(p);
            return AVF_PLAYER_ERR_HOST;
        }
    }
    release(p);
    return AVF_PLAYER_OK;
}

/* 0x42d215 */
static void secondary_step_index(AvfPlayer *p, const AvfPlayerGate *g)
{
    const AvfPlayerConfig *c = &p->config;

    switch (p->secondary_mode) {
    case 0:
        p->index = (int16_t)(p->index + 1);
        if (c->loop_last < p->index) {
            p->index = c->first;
        }
        break;
    case 1:
        p->index = (int16_t)(p->index + 1);
        if (c->hold_last < p->index) {
            p->index = c->hold_last;
        }
        break;
    case 2:
        p->index = (int16_t)(p->index - 1);
        if (p->index < c->first) {
            p->index = c->first;
            p->secondary_mode = 0;
        }
        break;
    case 3:
        p->index = (int16_t)(p->index + 1);
        if (c->end_last < p->index) {
            p->index = c->end_last;
        }
        break;
    default:
        break;
    }
    if (p->secondary_mode == 1 && !g->slot_current) {
        p->secondary_mode = 2;
    }
}

static AvfPlayerStatus secondary_tick(AvfPlayer *p, const AvfPlayerGate *g)
{
    int32_t match = g->record_count != 0 ? g->records[0] : -1;

    if (p->substate == 0) {
        if (p->ready != 0) {
            if (match >= 0) {
                CHECK_HOST(event(p, AVF_EVENT_TRIGGERS, p->index, -1));     /* 0x42ca22 */
                if (secondary_swap(p) != AVF_PLAYER_OK) {
                    return AVF_PLAYER_ERR_HOST;
                }
                secondary_step_index(p, g);
                CHECK_HOST(event(p, AVF_EVENT_RECT, -1, match));             /* 0x42caa8 */
                p->ready = 0;
                p->deadline = arm(p);
            }
            p->substate = 4;
        }
        return AVF_PLAYER_OK;
    }
    if (p->substate != 4) {
        return AVF_PLAYER_OK;
    }
    if (now(p) < p->deadline) {
        if (match >= 0) {
            CHECK_HOST(event(p, AVF_EVENT_RECT, -1, match));
        }
        return AVF_PLAYER_OK;
    }
    if (match >= 0) {
        if (p->ready != 0) {
            if (secondary_swap(p) != AVF_PLAYER_OK) {
                return AVF_PLAYER_ERR_HOST;
            }
            CHECK_HOST(event(p, AVF_EVENT_TRIGGERS, p->index, -1));
            secondary_step_index(p, g);
            p->deadline = arm(p);
            p->ready = 0;
        }
        CHECK_HOST(event(p, AVF_EVENT_RECT, -1, match));
    }
    return AVF_PLAYER_OK;
}

AvfPlayerStatus avf_player_set_secondary_mode(AvfPlayer *player, int32_t mode)
{
    if (player == NULL) {
        return AVF_PLAYER_ERR_ARGUMENT;
    }
    if (player->kind != AVF_PLAYER_SECONDARY_VIDEO) {
        return AVF_PLAYER_ERR_UNSUPPORTED;
    }
    if (!player->running || player->failed) {
        return AVF_PLAYER_ERR_STATE;
    }
    player->secondary_mode = mode;
    return AVF_PLAYER_OK;
}

AvfPlayerStatus avf_player_tick(AvfPlayer *player, const AvfPlayerGate *gate)
{
    AvfPlayerStatus status = AVF_PLAYER_ERR_ARGUMENT;
    size_t i;

    if (player == NULL || gate == NULL || (gate->record_count != 0 && gate->records == NULL)) {
        return AVF_PLAYER_ERR_ARGUMENT;
    }
    for (i = 0; i < gate->record_count; ++i) {
        if (gate->records[i] < 0) {
            return AVF_PLAYER_ERR_ARGUMENT;    /* record indices, never "none" */
        }
    }
    if (!player->running || player->failed) {
        return AVF_PLAYER_ERR_STATE;
    }
    switch (player->kind) {
    case AVF_PLAYER_RANDOM_MOVIE:
        status = random_tick(player, gate);
        break;
    case AVF_PLAYER_MOVIE:
        status = movie_tick(player, gate);
        break;
    case AVF_PLAYER_PARTNER_LOGO:
        status = partner_tick(player, gate);
        break;
    case AVF_PLAYER_SECONDARY_VIDEO:
        status = secondary_tick(player, gate);
        break;
    }
    if (status == AVF_PLAYER_ERR_HOST) {
        player->failed = 1;
    }
    return status;
}

const char *avf_player_status_name(AvfPlayerStatus status)
{
    static const char *const names[] = {
        "OK", "ARGUMENT", "STATE", "STALE", "UNSUPPORTED", "DECODER", "HOST"
    };
    if ((unsigned)status < sizeof(names) / sizeof(names[0])) {
        return names[status];
    }
    return "UNKNOWN";
}
