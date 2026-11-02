/* Shared host-only INPUT driver. No game-resource payload or state writes. */
#include "rc_input_script.h"
#include "rc_internal.h"
#include <ctype.h>
#include <errno.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum { MAX_STEPS = 512, MAX_TEXT = 65536 };
typedef struct Step { char at[64], kind[8]; int32_t arg[4]; int nargs; } Step;
struct RcInputScript {
    Step steps[MAX_STEPS];
    unsigned nsteps, next_step, delivered, shots;
    uint32_t done_at, tail, prev_off, prev_delivered;
    int tail_init, requested_stop, failed;
    char prev_anchor[64];
    RcInputScriptShot shot;
    void *user;
};

static void set_error(char *error, size_t capacity, const char *message)
{
    if (error && capacity) snprintf(error, capacity, "%s", message);
}

static int decimal32(const char *text)
{
    if (!*text) return 0;
    uint64_t n = 0;
    for (; *text; ++text) {
        if (*text < '0' || *text > '9') return 0;
        n = n * 10u + (unsigned)(*text - '0');
        if (n > UINT32_MAX) return 0;
    }
    return 1;
}

static int valid_at(const char *text)
{
    if (!*text || strlen(text) >= 64) return 0;
    if (*text >= '0' && *text <= '9') return decimal32(text);
    const char *plus = strchr(text, '+');
    for (const char *p = text; p != (plus ? plus : text + strlen(text)); ++p)
        if (isspace((unsigned char)*p)) return 0;
    return !plus || (plus != text && decimal32(plus + 1));
}

RcInputScript *rc_input_script_parse(const char *text, RcInputScriptShot shot,
                                    void *user, char *error, size_t capacity)
{
    set_error(error, capacity, "");
    if (!text || strnlen(text, MAX_TEXT + 1u) > MAX_TEXT) {
        set_error(error, capacity, "INPUT missing or exceeds 65536 bytes"); return NULL;
    }
    RcInputScript *s = (RcInputScript *)calloc(1, sizeof *s);
    char *copy = strdup(text);
    if (!s || !copy) { free(s); free(copy); set_error(error, capacity, "cannot allocate INPUT"); return NULL; }
    s->tail = 5000; s->shot = shot; s->user = user;
    char *start = copy;
    while (isspace((unsigned char)*start)) ++start;
    size_t length = strlen(start);
    while (length && isspace((unsigned char)start[length - 1])) start[--length] = 0;
    char *outer = NULL;
    for (char *part = strtok_r(start, ";", &outer); part; part = strtok_r(NULL, ";", &outer)) {
        if (s->nsteps == MAX_STEPS) goto invalid;
        Step *st = &s->steps[s->nsteps];
        char *c1 = strchr(part, ':'), *c2 = c1 ? strchr(c1 + 1, ':') : NULL;
        if (!c2 || strchr(c2 + 1, ':')) goto invalid;
        *c1 = 0; *c2 = 0;
        if (!valid_at(part) || strlen(c1 + 1) >= sizeof st->kind) goto invalid;
        strcpy(st->at, part); strcpy(st->kind, c1 + 1);
        int point = !strcmp(st->kind, "move") || !strcmp(st->kind, "click");
        int key = !strcmp(st->kind, "key") || !strcmp(st->kind, "keydown") ||
                  !strcmp(st->kind, "keyup") || !strcmp(st->kind, "keyhold");
        if (!point && !key && strcmp(st->kind, "shot")) goto invalid;
        char *arg = c2 + 1;
        if (*arg) for (;;) {
            if (st->nargs == 4 || !*arg) goto invalid;
            char *comma = strchr(arg, ','); if (comma) *comma = 0;
            errno = 0; char *end;
            long long value = strtoll(arg, &end, 0);
            if (errno || end == arg || *end || value < INT32_MIN || value > UINT32_MAX) goto invalid;
            st->arg[st->nargs++] = (int32_t)(uint32_t)value;
            if (!comma) break;
            arg = comma + 1;
        }
        if ((point && st->nargs < 2) || (key && (st->nargs < 1 || st->arg[0] < 0 || st->arg[0] > 255))) goto invalid;
        ++s->nsteps;
    }
    free(copy);
    if (!s->nsteps) { free(s); set_error(error, capacity, "INPUT contains no steps"); return NULL; }
    return s;
invalid:
    if (error && capacity) snprintf(error, capacity, "invalid or truncated INPUT step %u", s->nsteps + 1u);
    free(copy); free(s); return NULL;
}

RcInputScript *rc_input_script_load_file(const char *path, RcInputScriptShot shot,
                                        void *user, char *error, size_t capacity)
{
    FILE *file = path && *path ? fopen(path, "rb") : NULL;
    if (!file) { set_error(error, capacity, "cannot open INPUT file"); return NULL; }
    char *text = (char *)malloc(MAX_TEXT + 1u);
    if (!text) { fclose(file); set_error(error, capacity, "cannot allocate INPUT file"); return NULL; }
    size_t length = fread(text, 1, MAX_TEXT + 1u, file);
    int bad = ferror(file); if (fclose(file)) bad = 1;
    if (bad || length > MAX_TEXT || memchr(text, 0, length)) {
        free(text); set_error(error, capacity, "INPUT file read failed, exceeds 65536 bytes or contains NUL"); return NULL;
    }
    text[length] = 0;
    RcInputScript *s = rc_input_script_parse(text, shot, user, error, capacity);
    free(text); return s;
}

void rc_input_script_log_observation(void)
{
    /* Read the original scene/view cells alongside flags so route coordinates
     * can be tied to the actual panorama frame, including retained-art scenes. */
    rc_log("  STATE requested_scene=%u art_scene=%u view=%d held_item=%d",
           rc_u16(0x5bb57b), rc_u16(0x5bb57f),
           (int)(int16_t)rc_u16(0x5bb50b), (int)(int16_t)rc_u16(0x583a29));
    const char *e = getenv("RC_FLAGS");
    if (!e) return;
    rc_log("  RC_FLAGS %s", e);
    char line[1024] = "";
    size_t n = 0;
    while (*e) {
        char *end;
        unsigned lo = (unsigned)strtoul(e, &end, 10), hi = lo;
        if (*end == '-') hi = (unsigned)strtoul(end + 1, &end, 10);
        for (unsigned f = lo; f <= hi && n + 16 < sizeof line; f++) {
            uint32_t v = rc_rd(0x585801u + 4u * f, 4);
            if (v) n += (size_t)snprintf(line + n, sizeof line - n, " %u=%u", f, v);
        }
        e = *end == ',' ? end + 1 : end;
        if (end == e && *e) break;
    }
    rc_log("  FLAGS%s", line);
}

void rc_input_script_poll(RcInputScript *s)
{
    if (!s || !rc_thread_is_main()) return;
    if (s->next_step >= s->nsteps) {
        /* Preserve legacy lazy SCRIPT_TAIL_MS handling, 5000 default, 0 never. */
        if (!s->tail_init) { s->tail_init = 1; if (getenv("SCRIPT_TAIL_MS")) s->tail = (uint32_t)strtoul(getenv("SCRIPT_TAIL_MS"), NULL, 10); }
        if (s->nsteps && s->tail && s->done_at && rc_clock() >= s->done_at + s->tail) {
            s->requested_stop = 1;
            rc_request_stop();
        }
        return;
    }
    Step *st = &s->steps[s->next_step];
    uint32_t due, off;
    char anchor[64] = "";
    if (st->at[0] >= '0' && st->at[0] <= '9') due = off = (uint32_t)strtoul(st->at, NULL, 10);
    else {
        snprintf(anchor, sizeof anchor, "%s", st->at);
        char *plus = strchr(anchor, '+');
        off = 0;
        if (plus) { *plus = 0; off = (uint32_t)strtoul(plus + 1, NULL, 10); }
        uint32_t seen;
        if (!rc_seen_at(anchor, &seen)) return;
        due = seen + off;
    }
    uint32_t now = rc_clock();
    if (now < due) return;
    /* Preserve spacing for steps sharing an anchor, including absolute steps. */
    if (s->next_step > 0 && !strcmp(anchor, s->prev_anchor) && off >= s->prev_off && now < s->prev_delivered + (off - s->prev_off)) return;
    snprintf(s->prev_anchor, sizeof s->prev_anchor, "%s", anchor);
    s->prev_off = off; s->prev_delivered = now;
    s->next_step++;
    if (s->next_step >= s->nsteps) s->done_at = now;
    /* Preserve the old consumed-before-HWND behavior, but never count that as
     * delivery or successful verification. No story state is synthesized. */
    if (!rc_main_hwnd) return;
    s->delivered++;
    if (!strcmp(st->kind, "shot")) {
        s->shots++;
        if (!s->shot || !s->shot(s->user, s->shots, now)) s->failed = 1;
    } else if (!strcmp(st->kind, "move") || !strcmp(st->kind, "click")) {
        int click = !strcmp(st->kind, "click");
        rc_input_event(click ? 1 : 0, st->arg[0], st->arg[1], st->nargs > 2 ? (uint32_t)st->arg[2] : 300u, 0);
        rc_log("  INPUT %s at virtual %u ms", st->kind, now);
    } else if (!strcmp(st->kind, "key")) {
        rc_input_key((uint32_t)st->arg[0], 1); rc_input_key((uint32_t)st->arg[0], 0);
        rc_log("  INPUT key %d at virtual %u ms", st->arg[0], now);
    } else if (!strcmp(st->kind, "keydown") || !strcmp(st->kind, "keyup")) {
        rc_input_key((uint32_t)st->arg[0], !strcmp(st->kind, "keydown"));
        rc_log("  INPUT %s %d at virtual %u ms", st->kind, st->arg[0], now);
    } else if (!strcmp(st->kind, "keyhold")) {
        rc_input_event(2, 0, 0, st->nargs > 1 ? (uint32_t)st->arg[1] : 300u, (uint32_t)st->arg[0]);
        rc_log("  INPUT keyhold %d at virtual %u ms", st->arg[0], now);
    }
}

RcInputScriptStatus rc_input_script_status(const RcInputScript *s)
{
    RcInputScriptStatus status = {0};
    if (s) {
        status.total = s->nsteps; status.consumed = s->next_step;
        status.delivered = s->delivered; status.shots = s->shots;
        status.requested_stop = s->requested_stop; status.failed = s->failed;
    }
    return status;
}
int rc_input_script_completed(const RcInputScript *s)
{
    return s && s->nsteps && s->delivered == s->nsteps && s->requested_stop && !s->failed;
}
void rc_input_script_destroy(RcInputScript *s) { free(s); }
