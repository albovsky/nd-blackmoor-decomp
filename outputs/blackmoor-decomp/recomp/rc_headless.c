/* Linux headless harness for the native host: runs the recompiled GAME.EXE on a game folder with the deterministic virtual clock, the
 * scripted INPUT of the Python spike (virtual_ms:move|click|key|shot:args;...), PPM frame dumps and a run log.
 *
 *   GAME_EXE=work/original/GAME.EXE RC_GAMEDIR=gamedir INPUT="9000:click:290,46" MAX_IMPORTS=1500000 rc_headless
 *
 * Output goes to $RC_OUT (default ./out): run.log and frames/frameNNN.ppm. */
#define _GNU_SOURCE
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <time.h>
#include <unistd.h>
#include "rc.h"
#include "rc_internal.h"

static FILE *logf;
static char out_dir[512];
static int frames_dumped;

static void plat_log(void *u, const char *line) { (void)u; if (logf) { fputs(line, logf); fputc('\n', logf); } }

/* ---- Bink through the ffmpeg tool, as the Python spike did ---- */
typedef struct Movie { uint32_t w, h, frames; uint8_t *raw; uint32_t decoded; char path[1536]; } Movie;

static int bink_open(void *u, const char *path, RcBinkInfo *info, void **movie)
{
    (void)u;
    char cmd[2048];
    snprintf(cmd, sizeof cmd, "ffprobe -v error -select_streams v:0 -count_packets -show_entries stream=width,height,r_frame_rate,nb_read_packets -of default=nw=1 '%s' 2>/dev/null", path);
    FILE *p = popen(cmd, "r");
    if (!p) return -1;
    uint32_t w = 0, h = 0, frames = 0, num = 0, den = 1;
    char line[256];
    while (fgets(line, sizeof line, p)) {
        if (sscanf(line, "width=%u", &w) == 1) continue;
        if (sscanf(line, "height=%u", &h) == 1) continue;
        if (sscanf(line, "nb_read_packets=%u", &frames) == 1) continue;
        if (sscanf(line, "r_frame_rate=%u/%u", &num, &den) >= 1) continue;
    }
    pclose(p);
    if (!w || !h) return -1;
    Movie *m = (Movie *)calloc(1, sizeof *m);
    m->w = w; m->h = h; m->frames = frames ? frames : 1;
    snprintf(m->path, sizeof m->path, "%s", path);
    info->width = w; info->height = h; info->frames = m->frames; info->rate = num; info->rate_div = den ? den : 1;
    *movie = m;
    return 0;
}

static int bink_frame(void *u, void *movie, uint32_t frame, uint16_t *rgb565, uint32_t pitch)
{
    (void)u;
    Movie *m = (Movie *)movie;
    if (!m->raw) {
        char cmd[2048];
        snprintf(cmd, sizeof cmd, "ffmpeg -v error -i '%s' -frames:v 400 -f rawvideo -pix_fmt rgb565le - 2>/dev/null", m->path);
        FILE *p = popen(cmd, "r");
        size_t fsz = (size_t)m->w * m->h * 2, cap = fsz * 400, got = 0;
        m->raw = (uint8_t *)calloc(1, cap);
        if (p) { size_t n; while (got < cap && (n = fread(m->raw + got, 1, cap - got, p)) > 0) got += n; pclose(p); }
        m->decoded = (uint32_t)(got / fsz);
        if (!m->decoded) m->decoded = 1;
    }
    uint32_t idx = frame ? frame - 1 : 0;
    if (idx >= m->decoded) idx = m->decoded - 1;
    for (uint32_t j = 0; j < m->h; j++) memcpy(rgb565 + (size_t)j * pitch, m->raw + ((size_t)idx * m->h + j) * m->w * 2, (size_t)m->w * 2);
    return 0;
}

static void bink_close(void *u, void *movie) { (void)u; Movie *m = (Movie *)movie; free(m->raw); free(m); }

/* ---- frames ---- */
static void dump_frame_as(const char *prefix, int number)
{
    const uint16_t *px;
    uint32_t w, h, pitch;
    if (!rc_get_primary(&px, &w, &h, &pitch)) return;
    char path[700];
    snprintf(path, sizeof path, "%s/frames/%s%03d.ppm", out_dir, prefix, number);
    FILE *f = fopen(path, "wb");
    if (!f) return;
    fprintf(f, "P6 %u %u 255\n", w, h);
    for (uint32_t y = 0; y < h; y++) {
        const uint16_t *row = (const uint16_t *)((const uint8_t *)px + (size_t)y * pitch);
        for (uint32_t x = 0; x < w; x++) {
            uint8_t rgb[3] = {(uint8_t)((row[x] >> 11) << 3), (uint8_t)(((row[x] >> 5) & 0x3f) << 2), (uint8_t)((row[x] & 0x1f) << 3)};
            fwrite(rgb, 1, 3, f);
        }
    }
    fclose(f);
    rc_log("  %s %d dumped (%ux%u)", prefix[0] == 's' ? "SHOTFILE" : "FRAME", number, w, h);
}
static void dump_frame(int number) { dump_frame_as("frame", number); }

static void numbered_dump(void)         /* the spike's policy: the first 60 pictures and pictures 100 to 139 */
{
    frames_dumped++;
    if (frames_dumped > 60 && !(frames_dumped >= 100 && frames_dumped < 140)) return;
    dump_frame(frames_dumped);
}

static void frame_hook(int is_flip, uint64_t blits)
{
    if (is_flip) { numbered_dump(); return; }
    if (blits == 1 || blits == 300 || blits == 3000 || blits % 20000 == 0) numbered_dump();
}

/* ---- scripted input ---- */
typedef struct Step { char at[64]; char kind[8]; int32_t arg[4]; int nargs; } Step;
static Step steps[512];
static int nsteps, next_step, shots;

static void parse_input(const char *s)
{
    char *copy = strdup(s), *outer = NULL;
    for (char *part = strtok_r(copy, ";", &outer); part && nsteps < 512; part = strtok_r(NULL, ";", &outer)) {
        Step *st = &steps[nsteps];
        char *c1 = strchr(part, ':');
        char *c2 = c1 ? strchr(c1 + 1, ':') : NULL;
        if (!c2) continue;
        *c1 = 0; *c2 = 0;
        snprintf(st->at, sizeof st->at, "%s", part);
        snprintf(st->kind, sizeof st->kind, "%s", c1 + 1);
        char *inner = NULL;
        for (char *tok = strtok_r(c2 + 1, ",", &inner); tok && st->nargs < 4; tok = strtok_r(NULL, ",", &inner)) st->arg[st->nargs++] = (int32_t)strtol(tok, NULL, 0);
        nsteps++;
    }
    free(copy);
}

static uint32_t script_done_at;                  /* virtual ms at which the last step was delivered */

/* RC_FLAGS="1000-1030,1716,2075": the game's event flags (dwords at 0x585801 + 4 * n, the table of its scene scripts) that are not zero, logged at every shot */
static void dump_flags(void)
{
    const char *e = getenv("RC_FLAGS");
    if (!e) return;
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

static void poll_hook(void)
{
    if (next_step >= nsteps) {
        /* the script is over: stop SCRIPT_TAIL_MS (default 5000, 0 = never) of virtual time later, so a route does not run on to the idle limit */
        static uint32_t tail = 5000;
        static int tail_init;
        if (!tail_init) { tail_init = 1; if (getenv("SCRIPT_TAIL_MS")) tail = (uint32_t)strtoul(getenv("SCRIPT_TAIL_MS"), NULL, 10); }
        if (nsteps && tail && script_done_at && rc_clock() >= script_done_at + tail) rc_request_stop();
        return;
    }
    Step *st = &steps[next_step];
    static char prev_anchor[64];
    static uint32_t prev_off, prev_delivered;
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
    /* the game can run ahead of the script (a scene load takes longer on the virtual clock than it did when the script was written): steps of
     * one anchor keep the spacing they have in the script, so a hover is not delivered in the same instant as the click that follows it */
    if (next_step > 0 && !strcmp(anchor, prev_anchor) && off >= prev_off && now < prev_delivered + (off - prev_off)) return;
    snprintf(prev_anchor, sizeof prev_anchor, "%s", anchor);
    prev_off = off;
    prev_delivered = now;
    next_step++;
    if (next_step >= nsteps) script_done_at = now;
    if (!rc_main_hwnd) return;
    if (!strcmp(st->kind, "shot")) {
        shots++;
        dump_frame_as("shot", shots);                       /* frames/shotNNN.ppm, numbered from 1 (the numbered flip dumps use frameNNN) */
        rc_log("  SHOT %d at virtual %u ms", shots, now);
        dump_flags();
    } else if (!strcmp(st->kind, "move") || !strcmp(st->kind, "click")) {
        int click = !strcmp(st->kind, "click");
        rc_input_event(click ? 1 : 0, st->arg[0], st->arg[1], st->nargs > 2 ? (uint32_t)st->arg[2] : 300u, 0);
        rc_log("  INPUT %s at virtual %u ms", st->kind, now);
    } else if (!strcmp(st->kind, "key")) {                 /* a key press and release as the platform sends them: a printable one makes a WM_CHAR */
        rc_input_key((uint32_t)st->arg[0], 1);
        rc_input_key((uint32_t)st->arg[0], 0);
        rc_log("  INPUT key %d at virtual %u ms", st->arg[0], now);
    } else if (!strcmp(st->kind, "keydown") || !strcmp(st->kind, "keyup")) {     /* keydown:16 before a letter makes it a capital, keyup:16 after */
        rc_input_key((uint32_t)st->arg[0], !strcmp(st->kind, "keydown"));
        rc_log("  INPUT %s %d at virtual %u ms", st->kind, st->arg[0], now);
    } else if (!strcmp(st->kind, "keyhold")) {             /* the key stays down for arg[1] virtual ms, for a game that polls the key state */
        rc_input_event(2, 0, 0, st->nargs > 1 ? (uint32_t)st->arg[1] : 300u, (uint32_t)st->arg[0]);
        rc_log("  INPUT keyhold %d at virtual %u ms", st->arg[0], now);
    }
}

/* ---- real time (RC_REAL=1) ---- */
static uint64_t real_now(void *u) { (void)u; struct timespec t; clock_gettime(CLOCK_MONOTONIC, &t); return (uint64_t)t.tv_sec * 1000u + (uint64_t)t.tv_nsec / 1000000u; }
static void real_sleep(void *u, uint32_t ms) { (void)u; struct timespec t = {ms / 1000u, (long)(ms % 1000u) * 1000000L}; nanosleep(&t, NULL); }

int main(void)
{
    const char *exe = getenv("GAME_EXE");
    const char *gamedir = getenv("RC_GAMEDIR");
    const char *out = getenv("RC_OUT");
    snprintf(out_dir, sizeof out_dir, "%s", out ? out : "out");
    char path[700];
    mkdir(out_dir, 0755);
    snprintf(path, sizeof path, "%s/frames", out_dir);
    mkdir(path, 0755);
    snprintf(path, sizeof path, "%s/run.log", out_dir);
    logf = fopen(path, "w");
    RcPlatform pl;
    memset(&pl, 0, sizeof pl);
    pl.game_dir = gamedir ? gamedir : "gamedir";
    pl.log = plat_log;
    pl.bink_open = bink_open; pl.bink_frame = bink_frame; pl.bink_close = bink_close;
    if (getenv("RC_REAL")) { pl.now_ms = real_now; pl.sleep_ms = real_sleep; }
    rc_set_platform(&pl);
    if (getenv("INPUT")) parse_input(getenv("INPUT"));
    rc_set_poll_hook(poll_hook);
    rc_set_frame_hook(frame_hook);
    if (getenv("MAX_IMPORTS")) rc_set_import_budget(strtoull(getenv("MAX_IMPORTS"), NULL, 10));
    if (getenv("MAX_IDLE_POLLS")) rc_set_max_idle_polls((uint32_t)strtoul(getenv("MAX_IDLE_POLLS"), NULL, 10));   /* idle polls of the message loop in all (5 virtual ms each) before the run is stopped */
    char error[512];
    if (rc_start(exe ? exe : "../../work/original/GAME.EXE", error, sizeof error)) { fprintf(stderr, "rc_start: %s\n", error); return 2; }
    struct timespec t0, t1;
    clock_gettime(CLOCK_MONOTONIC, &t0);
    char why[600];
    rc_main(why, sizeof why);
    clock_gettime(CLOCK_MONOTONIC, &t1);
    double secs = (double)(t1.tv_sec - t0.tv_sec) + (double)(t1.tv_nsec - t0.tv_nsec) / 1e9;
    frames_dumped = 0;
    dump_frame(1);                                     /* the last picture of the primary surface */
    uint64_t nat, fb, imp;
    rc_get_stats(&nat, &fb, &imp);
    uint32_t virt = rc_clock();
    const char *first = rc_first_data_file();
    char result[1400];
    snprintf(result, sizeof result, "{\"stopped\": \"%s\", \"seconds\": %.2f, \"virtual_ms\": %u, \"native_calls\": %llu, \"fallback_calls\": %llu, \"imports_called\": %llu, \"files_opened\": %u, \"first_data_file\": \"%s\"}",
             why, secs, virt, (unsigned long long)nat, (unsigned long long)fb, (unsigned long long)imp, rc_files_opened(), first ? first : "");
    rc_log("\nRESULT %s", result);
    puts(result);
    if (logf) fclose(logf);
    return 0;
}
