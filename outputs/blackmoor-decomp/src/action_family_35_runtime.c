#include "action_family_35_runtime.h"

#include <stdlib.h>
#include <string.h>

struct A35Runtime {
    A35World *world;
    A35Host host;
    A35Snapshot state;
    AvfPlayer player;
    ActionFamily35Decoded decoded;
    A35Input input;
    int opened, failed;
    const char *failure;
};

static int16_t signed_word(uint16_t u)
{
    return u <= 32767u ? (int16_t)u : (int16_t)((int32_t)u - 65536);
}

static int16_t word(const uint8_t *p)
{
    const uint16_t u = (uint16_t)p[0] | (uint16_t)((uint16_t)p[1] << 8);
    return signed_word(u);
}

static int32_t dword(const uint8_t *p)
{
    uint32_t u = (uint32_t)p[0] | (uint32_t)p[1] << 8 |
                 (uint32_t)p[2] << 16 | (uint32_t)p[3] << 24;
    int32_t s;
    memcpy(&s, &u, sizeof(s));
    return s;
}

static int refuse(A35Runtime *r, int code, const char *why)
{
    r->failure = why;
    if (code == A35_RUNTIME_HOST) r->failed = 1;
    return code;
}

A35Runtime *action35_runtime_create(A35World *world, const A35Host *host)
{
    A35Runtime *r;
    if (world == NULL || host == NULL ||
        (world->event_flag_count != 0u && world->event_flags == NULL)) return NULL;
    r = (A35Runtime *)calloc(1u, sizeof(*r));
    if (r != NULL) {
        r->world = world;
        r->host = *host;
        r->failure = "none";
    }
    return r;
}

void action35_runtime_destroy(A35Runtime *r)
{
    if (r == NULL) return;
    if (r->player.running) (void)avf_player_stop(&r->player);
    if (r->opened && r->host.close != NULL) r->host.close(r->host.context);
    free(r);
}

static int valid_flag(const A35Runtime *r, int16_t id)
{
    return id == -1 || (id >= 0 && (size_t)id < r->world->event_flag_count);
}

/* 0x4c0ab1: every exact frame match, in body order, including duplicate ids. */
static void triggers(A35Runtime *r, int16_t frame)
{
    int i;
    for (i = 0; i < r->decoded.count_6; ++i) {
        const uint8_t *p = r->decoded.records_6 + (size_t)i * 6u;
        const int16_t id = word(p + 2);
        if (word(p) == frame && id != -1) r->world->event_flags[id] = word(p + 4);
    }
}

/* 0x4c08d3. x86 ADD wraps; avoid signed overflow in the native adapter. */
static int32_t add32(int32_t a, int32_t b)
{
    uint32_t u = (uint32_t)a + (uint32_t)b;
    int32_t s;
    memcpy(&s, &u, sizeof(s));
    return s;
}

static int rect(A35Runtime *r, int32_t index)
{
    const uint8_t *p = r->decoded.records_34 + (size_t)index * 34u;
    A35Snapshot *s = &r->state;
    s->source = (A35Rect){dword(p + 2), dword(p + 6), dword(p + 10), dword(p + 14)};
    s->destination = (A35Rect){add32(dword(p + 18), r->input.origin_x),
        add32(dword(p + 22), r->input.origin_y),
        add32(dword(p + 26), r->input.origin_x),
        add32(dword(p + 30), r->input.origin_y)};
    return r->host.rect(r->host.context, &s->source, &s->destination);
}

static uint32_t avf_clock(void *context)
{
    A35Runtime *r = (A35Runtime *)context;
    return r->host.avf.clock(r->host.avf.context);
}

static int avf_present(void *context, const AvfPresentation *p)
{
    A35Runtime *r = (A35Runtime *)context;
    return r->host.avf.present(r->host.avf.context, p);
}

static int avf_event(void *context, const AvfFrameEvent *e)
{
    A35Runtime *r = (A35Runtime *)context;
    if (e->kind == AVF_EVENT_TRIGGERS) {
        triggers(r, e->frame_index);
        return 0;
    }
    if (e->kind == AVF_EVENT_RECT) return rect(r, e->record);
    return 1;
}

static void avf_life(void *context, AvfLifecycleEvent e)
{
    A35Runtime *r = (A35Runtime *)context;
    if (r->host.avf.lifecycle != NULL)
        r->host.avf.lifecycle(r->host.avf.context, e);
}

static void ui(A35World *w)
{
    w->redraw = 1;
    w->cursor = 0;
}

int action35_runtime_step(A35Runtime *r, const uint8_t *body, size_t length,
                          uint32_t phase, const A35Input *input, A35Result *out)
{
    ActionFamily35Decoded d;
    A35Result result;
    int i, matches = 0, status;
    int bink;
    if (r == NULL || body == NULL || input == NULL || out == NULL)
        return A35_RUNTIME_ARGUMENT;
    r->failure = "none";
    if (r->failed) return refuse(r, A35_RUNTIME_STATE, "terminal host/decoder failure");
    if (action_family_35_decode(body, length, &d) != ACTION_FAMILY_35_OK)
        return refuse(r, A35_RUNTIME_ARGUMENT, "invalid 0x35 typed body");
    /* Original runtime sign-extends only the LOW BYTE of the view count at
     * 0x4bfa5e, unlike the constructor. Reject its unsafe large-count branch. */
    if (d.count_34 > 127) return refuse(r, A35_RUNTIME_UNSUPPORTED,
                                       "signed-byte view count above 127");
    bink = d.words[0] == 1u;
    if (phase == 0u && memchr(d.name, 0, sizeof(d.name)) == NULL)
        return refuse(r, A35_RUNTIME_ARGUMENT, "unterminated movie name");
    /* Native bounds policy: validate all ids before any open/store/effect. */
    if (!valid_flag(r, signed_word(d.words[11])))
        return refuse(r, A35_RUNTIME_ARGUMENT, "completion event id outside world");
    for (i = 0; i < d.count_6; ++i)
        if (!valid_flag(r, word(d.records_6 + (size_t)i * 6u + 2)))
            return refuse(r, A35_RUNTIME_ARGUMENT, "frame event id outside world");
    for (i = 0; i < d.count_34; ++i)
        if (word(d.records_34 + (size_t)i * 34u) == input->selector) ++matches;
    memset(&result, 0, sizeof(result));
    result.phase = phase;
    if (phase > 2u) { *out = result; return A35_RUNTIME_OK; }
    /* Preflight only the callbacks this visit can reach. */
    if (phase == 0u) {
        if (r->world->active != 0) return refuse(r, A35_RUNTIME_BUSY, "MOVIE controller already active");
        if (r->host.open == NULL || r->host.close == NULL)
            return refuse(r, A35_RUNTIME_UNSUPPORTED, "movie open/close provider");
        if (!bink && (r->host.avf.clock == NULL || r->host.avf.present == NULL || r->host.rect == NULL))
            return refuse(r, A35_RUNTIME_UNSUPPORTED, "AVF clock/presentation/rectangle provider");
    } else if (!r->opened) {
        return refuse(r, A35_RUNTIME_STATE, "movie not initialized for this row");
    } else if (phase == 1u && matches != 0) {
        if (r->host.rect == NULL || (bink && (r->host.bink_due == NULL ||
            r->host.bink_decode == NULL || r->host.bink_next == NULL)))
            return refuse(r, A35_RUNTIME_UNSUPPORTED, "Bink frame/audio or rectangle provider");
    }
    r->decoded = d;
    r->input = *input;
    if (phase == 0u) {
        AvfStream *stream = NULL;
        /* Open is a transactional host allocation boundary. On rejection it
         * leaves this visit without world effects; original fatally quits. */
        status = r->host.open(r->host.context, &d, &stream);
        if (status != A35_RUNTIME_OK) return refuse(r, status, "movie open provider rejected stream");
        r->opened = 1;
        /* 0x4bfbxx resets these fields, but retains +0x246 and the geometry
         * from the previous clip on a repeated row. */
        r->state.substate = 0;
        r->state.dirty = 0;
        r->state.flag21a = 0;
        r->state.saved_modal = r->world->modal;
        r->state.presented = -1;
        r->state.record = -1;
        if (!bink) {
            AvfPlayerConfig cfg;
            AvfPlayerHost host = {r, avf_clock, avf_present, avf_event, avf_life};
            memset(&cfg, 0, sizeof(cfg));
            cfg.kind = AVF_PLAYER_MOVIE;
            cfg.mode = d.words[3] == 1u;
            cfg.direction = signed_word(d.words[4]);
            cfg.first = signed_word(d.words[5]);
            cfg.last = signed_word(d.words[6]);
            status = avf_player_start(&r->player, &cfg, stream, NULL, NULL, 0u, &host);
            if (status != AVF_PLAYER_OK) {
                r->host.close(r->host.context);
                r->opened = 0;
                return refuse(r, A35_RUNTIME_HOST, "AVF start rejected config/stream");
            }
        }
        r->world->start = 1;
        ui(r->world);
        r->world->modal = d.words[3] == 1u ? 0 : 1;
        if (d.words[3] != 1u) memset(r->world->layers, 0, sizeof(r->world->layers));
        r->world->active = 1;
        r->world->visible = 0;
        r->state.shown = 3;
        result.phase = 1u;
    } else if (phase == 1u) {
        r->world->visible = 0;
        r->state.dirty = 0;
        r->state.record = -1;
        r->state.matched = 0;
        if (d.words[3] != 1u) {
            r->world->modal = 1;
            memset(r->world->layers, 0, sizeof(r->world->layers));
        }
        if (bink) {
            for (i = 0; i < d.count_34; ++i) {
                int due, more;
                int16_t frame;
                if (word(d.records_34 + (size_t)i * 34u) != input->selector) continue;
                r->world->visible = 1;
                r->state.record = i;
                if (r->state.substate == 0 || r->state.substate == 4) {
                    if (r->host.bink_due(r->host.context, &due) != 0)
                        return refuse(r, A35_RUNTIME_HOST, "BinkWait provider");
                    if (due) {
                        if (r->host.bink_decode(r->host.context, &frame) != 0)
                            return refuse(r, A35_RUNTIME_HOST, "Bink DoFrame/CopyToBuffer/audio provider");
                        r->state.presented = frame;
                        triggers(r, frame);
                        r->state.dirty = 1;
                        r->state.shown = 2;
                        if (r->state.substate == 0) r->state.flag21a = 1;
                        if (rect(r, i) != 0) return refuse(r, A35_RUNTIME_HOST, "movie rectangle provider");
                        if (r->host.bink_next(r->host.context, &more) != 0)
                            return refuse(r, A35_RUNTIME_HOST, "Bink next-frame provider");
                        if (!more) result.phase = 2u;
                        else if (r->state.substate == 0) r->state.substate = 4;
                    }
                }
                r->state.matched = 1;
            }
            if (!r->state.matched) r->state.shown = 3;
        } else {
            int32_t records[127];
            AvfPlayerGate gate;
            int k = 0;
            for (i = 0; i < d.count_34; ++i)
                if (word(d.records_34 + (size_t)i * 34u) == input->selector) records[k++] = i;
            memset(&gate, 0, sizeof(gate));
            gate.records = records;
            gate.record_count = (size_t)matches;
            status = avf_player_tick(&r->player, &gate);
            if (status != AVF_PLAYER_OK) return refuse(r, A35_RUNTIME_HOST, "AVF tick");
            r->state.substate = r->player.substate;
            r->state.presented = r->player.presented;
            r->state.dirty = r->player.dirty;
            r->state.shown = r->player.shown;
            r->state.flag21a = r->player.flag21a;
            r->state.matched = r->player.matched;
            r->state.record = r->player.record;
            r->world->visible = r->player.visible;
            if (r->player.finished) result.phase = 2u;
        }
    } else if (bink || d.words[0] != 0u || r->player.ready != 0) {
        /* 0x4c0774: event -> transition stores -> UI -> stop -> finish. */
        r->state.shown = 0;
        r->world->visible = 0;
        r->world->modal = r->state.saved_modal;
        r->world->active = 0;
        if (signed_word(d.words[11]) != -1)
            r->world->event_flags[signed_word(d.words[11])] = signed_word(d.words[12]);
        if (d.words[2] == 5u) {
            result.transition = 1;
            result.scene = signed_word(d.words[7]);
            result.frame = signed_word(d.words[8]);
            result.vertical = signed_word(d.words[9]);
            result.word = signed_word(d.words[10]);
            result.dwords[2] = 1;
            result.engine = 4;
        }
        r->world->start = d.words[1] != 1u;
        ui(r->world);
        if (r->player.running) (void)avf_player_stop(&r->player);
        r->host.close(r->host.context);
        r->opened = 0;
        result.phase = 0;
        result.finish = 1;
    }
    *out = result;
    return A35_RUNTIME_OK;
}

int action35_runtime_worker_poll(A35Runtime *r)
{
    int decoded;
    if (r == NULL || !r->opened || r->failed || !r->player.running) return A35_RUNTIME_STATE;
    if (avf_player_worker_poll(&r->player, &decoded) != AVF_PLAYER_OK)
        return refuse(r, A35_RUNTIME_HOST, "AVF sequential reader");
    return A35_RUNTIME_OK;
}

int action35_runtime_render_ack(A35Runtime *r, uint32_t generation, int *blitted)
{
    AvfPlayerStatus status;
    if (r == NULL || r->failed) return A35_RUNTIME_STATE;
    status = avf_player_render_ack(&r->player, generation, blitted);
    if (status == AVF_PLAYER_OK) r->state.dirty = r->player.dirty;
    return status == AVF_PLAYER_OK ? A35_RUNTIME_OK : A35_RUNTIME_STATE;
}

int action35_runtime_snapshot(const A35Runtime *r, A35Snapshot *s)
{
    if (r == NULL || s == NULL) return A35_RUNTIME_ARGUMENT;
    *s = r->state;
    return A35_RUNTIME_OK;
}

const char *action35_runtime_failure(const A35Runtime *r)
{
    return r == NULL ? "invalid controller" : r->failure;
}
