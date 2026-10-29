/* DirectSound stand-in. Buffers live in guest memory. The play cursor follows the virtual clock (deterministic runs, as in the Python spike)
 * or, with a platform clock, the audio mixer that rc_audio_render feeds to the sound device. Notification events are signalled from the
 * game thread (rc_dsound_tick) when the cursor passes their positions. */
#define _GNU_SOURCE
#include <math.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "rc.h"
#include "rc_internal.h"

#define API(name) static int api_##name(Fl41Regs *r, const uint32_t *a, uint32_t *ret)
#define UNUSED (void)r; (void)a; (void)ret
#define RET(v) do { *ret = (uint32_t)(v); return 0; } while (0)

typedef struct DSData { uint32_t buf, bytes; int owners; } DSData;
typedef struct Notify { uint32_t offset, event; } Notify;

typedef struct DSBuf {
    DSData *data;
    uint32_t size, flags, guest;
    uint8_t fmt[18];
    int fmt_len;
    uint32_t playing;               /* 0x10 | looping(1) while playing */
    uint32_t pos, start, gen;       /* start cursor in bytes, clock at Play, play generation */
    int32_t volume, pan;
    uint32_t freq, refs;
    uint64_t mixed_src_frames_x16;  /* real clock: source frames consumed by the mixer since Play, in 1/16 frames */
    double src_done;                /* real clock: the same, exact */
    int primary;
    struct DSBuf *next_active;
    int registered;
} DSBuf;

typedef struct DSNotify { DSBuf *buf; Notify list[16]; int count; uint32_t gen, last_t; int was_playing; uint32_t ended_gen; int have_gen, have_ended; } DSNotify;

static pthread_mutex_t ds_lock = PTHREAD_MUTEX_INITIALIZER;
static DSBuf **all_bufs;
static int buf_count, buf_cap;
static DSNotify **notifies;
static int notify_count, notify_cap;

static DSBuf *dsb(uint32_t this_) { return (DSBuf *)rc_com_obj(this_); }
static uint32_t bytes_per_sec(const DSBuf *b)
{
    uint32_t v = (uint32_t)b->fmt[8] | (uint32_t)b->fmt[9] << 8 | (uint32_t)b->fmt[10] << 16 | (uint32_t)b->fmt[11] << 24;
    return v ? v : 88200u;
}
static uint32_t fmt_rate(const uint8_t *f) { return (uint32_t)f[4] | (uint32_t)f[5] << 8 | (uint32_t)f[6] << 16 | (uint32_t)f[7] << 24; }

/* unwrapped play position in bytes since the buffer's start: pos + elapsed */
static uint64_t elapsed_bytes(const DSBuf *b)
{
    if (rc_clock_is_virtual()) return (uint64_t)(rc_clock() - b->start) * bytes_per_sec(b) / 1000u;
    uint32_t block = (uint32_t)(b->fmt[12] | b->fmt[13] << 8);
    return ((uint64_t)b->src_done) * (block ? block : 4u);
}

static uint32_t dsb_pos(DSBuf *b)
{
    if (!b->playing) return b->pos;
    uint64_t pos = (uint64_t)b->pos + elapsed_bytes(b);
    if (b->playing & 1u) return (uint32_t)(pos % b->size);
    if (pos >= b->size) { b->playing = 0; b->pos = 0; return 0; }
    return (uint32_t)pos;
}

/* ------------------------------------------------------------------ the mixer */
static void register_buf(DSBuf *b)
{
    if (b->registered) return;
    if (buf_count == buf_cap) { buf_cap = buf_cap ? buf_cap * 2 : 64; all_bufs = (DSBuf **)realloc(all_bufs, (size_t)buf_cap * sizeof *all_bufs); }
    all_bufs[buf_count++] = b;
    b->registered = 1;
}

static void unregister_buf(DSBuf *b)
{
    for (int i = 0; i < buf_count; i++) if (all_bufs[i] == b) { all_bufs[i] = all_bufs[--buf_count]; break; }
    b->registered = 0;
}

static float sample_at(const DSBuf *b, uint32_t bytepos, int ch, int bits, int channels)
{
    const uint8_t *base = (const uint8_t *)rc_ptr(b->data->buf, b->data->bytes);
    if (!base) return 0.0f;
    uint32_t per = (uint32_t)(bits / 8), block = per * (uint32_t)channels;
    uint32_t at = bytepos + (uint32_t)(ch < channels ? ch : 0) * per;
    if (bytepos + block > b->size) return 0.0f;
    if (bits == 8) return ((float)base[at] - 128.0f) / 128.0f;
    int16_t s;
    memcpy(&s, base + at, 2);
    return (float)s / 32768.0f;
}

typedef struct Voice { const float *pcm; uint64_t frames; uint32_t channels, rate; double pos; int active; } Voice;
static Voice voices[8];

int rc_voice_start(const float *pcm, uint64_t frames, uint32_t channels, uint32_t rate, uint64_t start_frame)
{
    if (!pcm || !frames || channels < 1 || channels > 2 || !rate) return -1;
    pthread_mutex_lock(&ds_lock);
    int id = -1;
    for (int i = 0; i < 8; i++) if (!voices[i].active) { id = i; break; }
    if (id >= 0) voices[id] = (Voice){pcm, frames, channels, rate, (double)start_frame, 1};
    pthread_mutex_unlock(&ds_lock);
    return id;
}

void rc_voice_stop(int id)
{
    if (id < 0 || id >= 8) return;
    pthread_mutex_lock(&ds_lock);
    voices[id].active = 0;
    pthread_mutex_unlock(&ds_lock);
}

uint32_t rc_audio_render(int16_t *out, uint32_t frames, uint32_t rate)
{
    memset(out, 0, (size_t)frames * 4);
    float *mix = (float *)calloc((size_t)frames * 2, sizeof(float));
    if (!mix) return 0;
    pthread_mutex_lock(&ds_lock);
    for (int i = 0; i < buf_count; i++) {
        DSBuf *b = all_bufs[i];
        if (!b->playing || b->primary || !b->data || b->size == 0) continue;
        int channels = b->fmt[2] | b->fmt[3] << 8, bits = b->fmt[14] | b->fmt[15] << 8;
        if (channels < 1 || channels > 2 || (bits != 8 && bits != 16)) continue;
        uint32_t block = (uint32_t)(bits / 8 * channels);
        double step = (double)b->freq / (double)rate;
        double done = rc_clock_is_virtual() ? (double)((uint64_t)elapsed_bytes(b) / block) : b->src_done;
        float gl = powf(10.0f, (float)(b->volume > 0 ? 0 : b->volume) / 2000.0f), gr = gl;
        if (b->pan > 0) gl *= powf(10.0f, -(float)b->pan / 2000.0f);
        if (b->pan < 0) gr *= powf(10.0f, (float)b->pan / 2000.0f);
        int looping = (b->playing & 1u) != 0;
        for (uint32_t f = 0; f < frames; f++, done += step) {
            uint64_t idx = (uint64_t)done;
            uint64_t bytepos = (uint64_t)b->pos + idx * block;
            if (looping) bytepos %= b->size;
            else if (bytepos + block > b->size) break;
            double frac = done - (double)idx;
            uint64_t next = bytepos + block;
            if (looping && next + block > b->size) next = 0;
            float l0 = sample_at(b, (uint32_t)bytepos, 0, bits, channels), r0 = sample_at(b, (uint32_t)bytepos, 1, bits, channels);
            float l1 = next + block <= b->size ? sample_at(b, (uint32_t)next, 0, bits, channels) : l0;
            float r1 = next + block <= b->size ? sample_at(b, (uint32_t)next, 1, bits, channels) : r0;
            mix[2 * f] += (l0 + (l1 - l0) * (float)frac) * gl;
            mix[2 * f + 1] += (r0 + (r1 - r0) * (float)frac) * gr;
        }
        if (!rc_clock_is_virtual()) b->src_done = done;
    }
    for (int i = 0; i < 8; i++) {
        Voice *v = &voices[i];
        if (!v->active) continue;
        double step = (double)v->rate / (double)rate;
        for (uint32_t f = 0; f < frames; f++, v->pos += step) {
            uint64_t idx = (uint64_t)v->pos;
            if (idx + 1 >= v->frames) { v->active = 0; break; }
            float frac = (float)(v->pos - (double)idx);
            const float *p0 = v->pcm + idx * v->channels, *p1 = p0 + v->channels;
            float l = p0[0] + (p1[0] - p0[0]) * frac;
            float r = v->channels > 1 ? p0[1] + (p1[1] - p0[1]) * frac : l;
            mix[2 * f] += l;
            mix[2 * f + 1] += r;
        }
    }
    pthread_mutex_unlock(&ds_lock);
    for (uint32_t f = 0; f < frames * 2; f++) {
        float v = mix[f];
        if (v > 1.0f) v = 1.0f;
        if (v < -1.0f) v = -1.0f;
        out[f] = (int16_t)(v * 32767.0f);
    }
    free(mix);
    return frames;
}

void rc_audio_skip(uint32_t ms) { rc_clock_advance(ms); }

/* ------------------------------------------------------------------ notification events */
static void fire_stop_events(DSNotify *n)
{
    for (int i = 0; i < n->count; i++)
        if (n->list[i].offset == 0xffffffffu) rc_event_set(n->list[i].event);
}

/* the cursor has moved on: signal the notify events whose positions have passed (and DSBPN_OFFSETSTOP when a one-shot buffer ends); the
 * lock is held */
static void tick_locked(void)
{
    for (int k = 0; k < notify_count; k++) {
        DSNotify *n = notifies[k];
        DSBuf *b = n->buf;
        if (!n->count || !b || !b->data) continue;
        if (!b->playing) {
            if ((!n->have_ended || n->ended_gen != b->gen) && n->was_playing) {
                n->ended_gen = b->gen; n->have_ended = 1; n->was_playing = 0;
                fire_stop_events(n);
            }
            continue;
        }
        uint64_t t = (uint64_t)b->pos + elapsed_bytes(b);
        int loop = (b->playing & 1u) != 0;
        if (!n->have_gen || n->gen != b->gen) { n->gen = b->gen; n->have_gen = 1; n->last_t = b->pos; n->was_playing = 1; }
        uint64_t last = n->last_t;
        if (!loop && t >= b->size) t = b->size;
        for (int i = 0; i < n->count; i++) {
            uint32_t off = n->list[i].offset;
            if (off == 0xffffffffu) continue;
            int64_t kn = t >= off ? (int64_t)((t - off) / b->size) : -1;
            int64_t kl = last >= off ? (int64_t)((last - off) / b->size) : -1;
            if (kn > kl && (loop || kl < 0)) rc_event_set(n->list[i].event);
        }
        n->last_t = (uint32_t)t;
        if (!loop && t >= b->size) {
            b->playing = 0; b->pos = 0; n->was_playing = 0; n->ended_gen = b->gen; n->have_ended = 1;
            fire_stop_events(n);
        }
    }
}

void rc_dsound_tick(void)
{
    if (!notify_count) return;
    pthread_mutex_lock(&ds_lock);
    tick_locked();
    pthread_mutex_unlock(&ds_lock);
}

/* ------------------------------------------------------------------ IDirectSound */
static uint32_t new_ds_obj(void);
static uint32_t new_buffer_obj(DSBuf *b);
static uint32_t new_notify_obj(DSNotify *n);
static uint32_t new_3dbuf_obj(void);
static uint32_t new_3dlistener_obj(void);

API(DirectSoundCreate)
{
    (void)r;
    rc_w32(a[1], new_ds_obj());
    rc_log("  DirectSoundCreate -> IDirectSound");
    RET(0);
}
API(DirectSoundEnumerateA)
{
    (void)r; (void)ret;
    /* the game's callback (0x4fa8d2) skips the null-GUID "Primary Sound Driver" entry and keeps the first real device's GUID */
    uint32_t guid = rc_alloc(16);
    for (int i = 0; i < 16; i++) rc_wr(guid + (uint32_t)i, 1, 0x11);
    uint32_t guids[2] = {0, guid};
    const char *names[2] = {"Primary Sound Driver", "Silent Sound Device"};
    for (int i = 0; i < 2; i++) {
        uint32_t args[4] = {guids[i], rc_guest_string(names[i]), rc_guest_string(""), a[1]};
        if (rc_call(a[0], 4, args, 0) == 0) break;
    }
    RET(0);
}
API(DS_QueryInterface) { (void)r; rc_w32(a[2], a[0]); RET(0); }
API(DS_AddRef) { UNUSED; RET(1); }
API(DS_Release) { UNUSED; RET(0); }
API(DS_Zero) { UNUSED; RET(0); }
API(DS_GetSpeakerConfig) { (void)r; rc_w32(a[1], 4); RET(0); }
API(DS_GetCaps)
{
    (void)r;
    uint32_t size = rc_u32(a[1]);
    if (size > 4) rc_zero(a[1] + 4, size - 4);
    rc_w32(a[1] + 4, 0x1 | 0x20 | 0x40 | 0x80 | 0x100 | 0x200 | 0x400 | 0x800);     /* primary 16/stereo, secondary mono/stereo/8/16 */
    rc_w32(a[1] + 8, 100); rc_w32(a[1] + 0xc, 100000);                              /* min/max secondary rate */
    rc_w32(a[1] + 0x10, 32); rc_w32(a[1] + 0x14, 32); rc_w32(a[1] + 0x18, 32); rc_w32(a[1] + 0x1c, 32);
    RET(0);
}
static DSBuf *buffer_new(uint32_t flags, uint32_t nbytes, const uint8_t *fmt, int fmt_len)
{
    DSBuf *b = (DSBuf *)calloc(1, sizeof *b);
    b->data = (DSData *)calloc(1, sizeof *b->data);
    b->data->bytes = (nbytes + 0xfffu) & ~0xfffu;
    b->data->buf = rc_surf_alloc(nbytes);
    b->data->owners = 1;
    b->size = nbytes; b->flags = flags; b->refs = 1; b->primary = (flags & 1u) != 0;
    memcpy(b->fmt, fmt, (size_t)fmt_len);
    b->fmt_len = fmt_len;
    b->freq = fmt_rate(b->fmt);
    b->guest = new_buffer_obj(b);
    return b;
}
API(DS_CreateSoundBuffer)
{
    (void)r;
    uint32_t flags = rc_u32(a[1] + 4), nbytes = rc_u32(a[1] + 8), fmtp = rc_u32(a[1] + 0x10);
    if ((flags & 1u) || nbytes == 0) nbytes = 0x10000u;
    if (nbytes > (16u << 20)) nbytes = 16u << 20;
    uint8_t fmt[18] = {0};
    int len = 16;
    if (fmtp) { rc_read(fmtp, fmt, 18); len = 18; }
    else { static const uint8_t dflt[16] = {1, 0, 2, 0, 0x22, 0x56, 0, 0, 0x88, 0x58, 1, 0, 4, 0, 16, 0}; memcpy(fmt, dflt, 16); }
    DSBuf *b = buffer_new(flags, nbytes, fmt, len);
    rc_w32(a[2], b->guest);
    static int created;
    if (++created <= 20) rc_log("  CreateSoundBuffer(%u bytes, flags 0x%x)", nbytes, flags);
    RET(0);
}
API(DS_DuplicateSoundBuffer)
{
    (void)r;
    DSBuf *o = dsb(a[1]);
    if (!o || !o->data) RET(0x88780032u);
    DSBuf *b = (DSBuf *)calloc(1, sizeof *b);
    *b = *o;
    b->playing = 0; b->registered = 0; b->refs = 1; b->src_done = 0;
    b->data->owners++;
    b->guest = new_buffer_obj(b);
    rc_w32(a[2], b->guest);
    RET(0);
}

/* ------------------------------------------------------------------ IDirectSoundBuffer */
API(B_QueryInterface)
{
    (void)r;
    DSBuf *b = dsb(a[0]);
    uint32_t tag = rc_u32(a[1]);
    if (tag == 0x279afa86u) { rc_w32(a[2], new_3dbuf_obj()); RET(0); }
    if (tag == 0x279afa84u) { rc_w32(a[2], new_3dlistener_obj()); RET(0); }
    if (tag == 0xb0210783u) {
        DSNotify *n = (DSNotify *)calloc(1, sizeof *n);
        n->buf = b;
        if (notify_count == notify_cap) { notify_cap = notify_cap ? notify_cap * 2 : 32; notifies = (DSNotify **)realloc(notifies, (size_t)notify_cap * sizeof *notifies); }
        notifies[notify_count++] = n;
        rc_w32(a[2], new_notify_obj(n));
        RET(0);
    }
    if (b) b->refs++;
    rc_w32(a[2], a[0]);
    RET(0);
}
API(N_SetNotificationPositions)
{
    (void)r;
    DSNotify *n = (DSNotify *)rc_com_obj(a[0]);
    if (!n) RET(0);
    pthread_mutex_lock(&ds_lock);
    n->count = 0;
    for (uint32_t i = 0; i < a[1] && i < 16; i++) { n->list[n->count].offset = rc_u32(a[2] + 8u * i); n->list[n->count].event = rc_u32(a[2] + 8u * i + 4u); n->count++; }
    pthread_mutex_unlock(&ds_lock);
    RET(0);
}
API(B_AddRef) { (void)r; DSBuf *b = dsb(a[0]); RET(b ? ++b->refs : 1); }
API(B_Release)
{
    (void)r;
    DSBuf *b = dsb(a[0]);
    if (!b || !b->refs) RET(0);
    if (--b->refs) RET(b->refs);
    pthread_mutex_lock(&ds_lock);
    unregister_buf(b);
    for (int k = 0; k < notify_count; k++) if (notifies[k]->buf == b) { notifies[k]->buf = NULL; notifies[k]->count = 0; }
    if (b->data && --b->data->owners == 0) { rc_surf_free(b->data->buf, b->data->bytes); free(b->data); }
    b->data = NULL;
    pthread_mutex_unlock(&ds_lock);
    RET(0);
}
API(B_GetCaps) { (void)r; DSBuf *b = dsb(a[0]); uint32_t v[5] = {20, b ? b->flags | 0x8 : 0, b ? b->size : 0, 0, 0}; rc_write(a[1], v, sizeof v); RET(0); }
API(B_GetCurrentPosition)
{
    (void)r;
    DSBuf *b = dsb(a[0]);
    if (!b || !b->data) RET(0x88780032u);
    pthread_mutex_lock(&ds_lock);
    uint32_t pos = dsb_pos(b);
    pthread_mutex_unlock(&ds_lock);
    if (a[1]) rc_w32(a[1], pos);
    if (a[2]) rc_w32(a[2], pos);
    RET(0);
}
API(B_GetFormat)
{
    (void)r;
    DSBuf *b = dsb(a[0]);
    if (!b) RET(0);
    if (a[1]) { uint32_t n = a[2] < (uint32_t)b->fmt_len ? a[2] : (uint32_t)b->fmt_len; rc_write(a[1], b->fmt, n); }
    if (a[3]) rc_w32(a[3], (uint32_t)b->fmt_len);
    RET(0);
}
API(B_SetFormat) { (void)r; DSBuf *b = dsb(a[0]); if (b) { rc_read(a[1], b->fmt, 18); b->fmt_len = 18; } RET(0); }
API(B_GetVolume) { (void)r; DSBuf *b = dsb(a[0]); rc_w32(a[1], b ? (uint32_t)b->volume : 0); RET(0); }
API(B_SetVolume) { (void)r; DSBuf *b = dsb(a[0]); if (b) { pthread_mutex_lock(&ds_lock); b->volume = (int32_t)a[1]; pthread_mutex_unlock(&ds_lock); } RET(0); }
API(B_GetPan) { (void)r; DSBuf *b = dsb(a[0]); rc_w32(a[1], b ? (uint32_t)b->pan : 0); RET(0); }
API(B_SetPan) { (void)r; DSBuf *b = dsb(a[0]); if (b) { pthread_mutex_lock(&ds_lock); b->pan = (int32_t)a[1]; pthread_mutex_unlock(&ds_lock); } RET(0); }
API(B_GetFrequency) { (void)r; DSBuf *b = dsb(a[0]); rc_w32(a[1], b ? b->freq : 0); RET(0); }
API(B_SetFrequency) { (void)r; DSBuf *b = dsb(a[0]); if (b) { pthread_mutex_lock(&ds_lock); b->freq = a[1] ? a[1] : fmt_rate(b->fmt); pthread_mutex_unlock(&ds_lock); } RET(0); }
API(B_GetStatus)
{
    (void)r;
    DSBuf *b = dsb(a[0]);
    pthread_mutex_lock(&ds_lock);
    tick_locked();
    if (b && b->data) dsb_pos(b);
    uint32_t st = b && b->playing ? (0x1u | ((b->playing & 1u) ? 0x4u : 0u)) : 0u;
    pthread_mutex_unlock(&ds_lock);
    rc_w32(a[1], st);
    RET(0);
}
API(B_Lock)
{
    (void)r;
    DSBuf *b = dsb(a[0]);
    if (!b || !b->data) RET(0x88780032u);
    uint32_t offset = a[1], nbytes = a[2];
    if (a[7] & 2u) nbytes = b->size;                    /* DSBLOCK_ENTIREBUFFER */
    pthread_mutex_lock(&ds_lock);
    if (a[7] & 1u) offset = dsb_pos(b);                 /* DSBLOCK_FROMWRITECURSOR */
    pthread_mutex_unlock(&ds_lock);
    offset %= b->size;
    uint32_t first = nbytes < b->size - offset ? nbytes : b->size - offset;
    rc_w32(a[3], b->data->buf + offset); rc_w32(a[4], first);
    if (a[5]) rc_w32(a[5], nbytes > first ? b->data->buf : 0);
    if (a[6]) rc_w32(a[6], nbytes > first ? nbytes - first : 0);
    RET(0);
}
API(B_Play)
{
    (void)r;
    DSBuf *b = dsb(a[0]);
    if (!b || !b->data) RET(0x88780032u);
    pthread_mutex_lock(&ds_lock);
    b->playing = 0x10u | (a[3] & 1u); b->start = rc_clock(); b->gen++; b->src_done = 0;
    register_buf(b);
    pthread_mutex_unlock(&ds_lock);
    RET(0);
}
API(B_Stop)
{
    (void)r;
    DSBuf *b = dsb(a[0]);
    if (!b || !b->data) RET(0);
    pthread_mutex_lock(&ds_lock);
    tick_locked();
    b->pos = dsb_pos(b);
    b->playing = 0;
    for (int k = 0; k < notify_count; k++) if (notifies[k]->buf == b) fire_stop_events(notifies[k]);
    pthread_mutex_unlock(&ds_lock);
    RET(0);
}
API(B_SetCurrentPosition)
{
    (void)r;
    DSBuf *b = dsb(a[0]);
    if (!b || !b->data) RET(0);
    pthread_mutex_lock(&ds_lock);
    b->pos = b->size ? a[1] % b->size : 0; b->start = rc_clock(); b->gen++; b->src_done = 0;
    pthread_mutex_unlock(&ds_lock);
    RET(0);
}

#define M(n, k, f) {n, k, f}
static const RcMethod ds_methods[] = {
    M("QueryInterface", 2, api_DS_QueryInterface), M("AddRef", 0, api_DS_AddRef), M("Release", 0, api_DS_Release), M("CreateSoundBuffer", 3, api_DS_CreateSoundBuffer),
    M("GetCaps", 1, api_DS_GetCaps), M("DuplicateSoundBuffer", 2, api_DS_DuplicateSoundBuffer), M("SetCooperativeLevel", 2, api_DS_Zero), M("Compact", 0, api_DS_Zero),
    M("GetSpeakerConfig", 1, api_DS_GetSpeakerConfig), M("SetSpeakerConfig", 1, api_DS_Zero), M("Initialize", 1, api_DS_Zero),
};
static const RcMethod ds3db_methods[] = {
    M("QueryInterface", 2, NULL), M("AddRef", 0, api_DS_AddRef), M("Release", 0, api_DS_Release), M("GetAllParameters", 1, NULL), M("GetConeAngles", 2, NULL),
    M("GetConeOrientation", 1, NULL), M("GetConeOutsideVolume", 1, NULL), M("GetMaxDistance", 1, NULL), M("GetMinDistance", 1, NULL), M("GetMode", 1, NULL),
    M("GetPosition", 1, NULL), M("GetVelocity", 1, NULL), M("SetAllParameters", 2, NULL), M("SetConeAngles", 3, NULL), M("SetConeOrientation", 4, NULL),
    M("SetConeOutsideVolume", 2, NULL), M("SetMaxDistance", 2, NULL), M("SetMinDistance", 2, NULL), M("SetMode", 2, NULL), M("SetPosition", 4, NULL), M("SetVelocity", 4, NULL),
};
static const RcMethod ds3dl_methods[] = {
    M("QueryInterface", 2, NULL), M("AddRef", 0, api_DS_AddRef), M("Release", 0, api_DS_Release), M("GetAllParameters", 1, NULL), M("GetDistanceFactor", 1, NULL),
    M("GetDopplerFactor", 1, NULL), M("GetOrientation", 2, NULL), M("GetPosition", 1, NULL), M("GetRolloffFactor", 1, NULL), M("GetVelocity", 1, NULL),
    M("SetAllParameters", 2, NULL), M("SetDistanceFactor", 2, NULL), M("SetDopplerFactor", 2, NULL), M("SetOrientation", 7, NULL), M("SetPosition", 4, NULL),
    M("SetRolloffFactor", 2, NULL), M("SetVelocity", 4, NULL), M("CommitDeferredSettings", 0, NULL),
};
static const RcMethod dsn_methods[] = {
    M("QueryInterface", 2, NULL), M("AddRef", 0, api_DS_AddRef), M("Release", 0, api_DS_Release), M("SetNotificationPositions", 2, api_N_SetNotificationPositions),
};
static const RcMethod dsb_methods[] = {
    M("QueryInterface", 2, api_B_QueryInterface), M("AddRef", 0, api_B_AddRef), M("Release", 0, api_B_Release), M("GetCaps", 1, api_B_GetCaps),
    M("GetCurrentPosition", 2, api_B_GetCurrentPosition), M("GetFormat", 3, api_B_GetFormat), M("GetVolume", 1, api_B_GetVolume), M("GetPan", 1, api_B_GetPan),
    M("GetFrequency", 1, api_B_GetFrequency), M("GetStatus", 1, api_B_GetStatus), M("Initialize", 2, api_DS_Zero), M("Lock", 7, api_B_Lock), M("Play", 3, api_B_Play),
    M("SetCurrentPosition", 1, api_B_SetCurrentPosition), M("SetFormat", 1, api_B_SetFormat), M("SetVolume", 1, api_B_SetVolume), M("SetPan", 1, api_B_SetPan),
    M("SetFrequency", 1, api_B_SetFrequency), M("Stop", 0, api_B_Stop), M("Unlock", 4, api_DS_Zero), M("Restore", 0, api_DS_Zero),
};
#define COUNT(a) ((int)(sizeof(a) / sizeof((a)[0])))
static uint32_t new_ds_obj(void) { return rc_com_new("IDirectSound", ds_methods, COUNT(ds_methods), NULL); }
static uint32_t new_buffer_obj(DSBuf *b) { return rc_com_new("IDirectSoundBuffer", dsb_methods, COUNT(dsb_methods), b); }
static uint32_t new_notify_obj(DSNotify *n) { return rc_com_new("IDirectSoundNotify", dsn_methods, COUNT(dsn_methods), n); }
static uint32_t new_3dbuf_obj(void) { return rc_com_new("IDirectSound3DBuffer", ds3db_methods, COUNT(ds3db_methods), NULL); }
static uint32_t new_3dlistener_obj(void) { return rc_com_new("IDirectSound3DListener", ds3dl_methods, COUNT(ds3dl_methods), NULL); }

int rc_dsound_resolve(const char *name, RcApiFn *fn)
{
    if (!strcmp(name, "#1") || !strcmp(name, "DirectSoundCreate")) { *fn = api_DirectSoundCreate; return 1; }
    if (!strcmp(name, "#2") || !strcmp(name, "DirectSoundEnumerateA")) { *fn = api_DirectSoundEnumerateA; return 1; }
    return 0;
}

void rc_dsound_init(void) {}
