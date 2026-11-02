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
#include "rc_input_script.h"
#include "rc_input_control.h"
#include "diagnostic_result.h"

static FILE *logf;
static char out_dir[512];
static int frames_dumped;
static int control_mode, control_log_failed;

static void plat_log(void *u, const char *line)
{
    (void)u;
    if (logf) {
        int bad = fputs(line, logf) == EOF;
        if (fputc('\n', logf) == EOF) bad = 1;
        /* ACKs and captures must be observable while this process is running.
         * Preserve the old buffering policy when control mode is unset. */
        if (control_mode && (fflush(logf) || bad)) control_log_failed = 1;
    }
}

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

/* ---- shared scripted input ---- */
static RcInputScript *input_script;
static RcInputControl *input_control;
static int script_shot(void *user, unsigned number, uint32_t now)
{
    (void)user;
    dump_frame_as("shot", (int)number);
    rc_log("  SHOT %u at virtual %u ms", number, now);
    rc_input_script_log_observation();
    return 1; /* Existing headless frame I/O policy is unchanged. */
}
/* Strict capture is opt-in only; static INPUT keeps its prior frame-I/O policy.
 * Exclusive creation prevents an old frame or another batch being overwritten. */
static int control_shot_checked(void *user, unsigned number, uint32_t now)
{
    (void)user;
    const uint16_t *pixels = NULL;
    uint32_t w = 0, h = 0, pitch = 0;
    if (!rc_get_primary(&pixels, &w, &h, &pitch) || !pixels || !w || !h ||
        w > 8192u || h > 8192u || (uint64_t)w * 2u > pitch ||
        (uint64_t)pitch * h > SIZE_MAX) return 0;
    char path[700];
    int length = snprintf(path, sizeof path, "%s/frames/shot%03u.ppm", out_dir, number);
    if (length < 0 || (size_t)length >= sizeof path) return 0;
    uint8_t *rgb = malloc((size_t)w * 3u);
    if (!rgb) return 0;
    FILE *file = fopen(path, "wbx");
    if (!file) { free(rgb); return 0; }
    int ok = fprintf(file, "P6 %u %u 255\n", w, h) > 0;
    for (uint32_t y = 0; ok && y < h; ++y) {
        const uint16_t *row = (const uint16_t *)((const uint8_t *)pixels + (size_t)y * pitch);
        for (uint32_t x = 0; x < w; ++x) {
            rgb[3u*x] = (uint8_t)((row[x] >> 11) << 3);
            rgb[3u*x+1u] = (uint8_t)(((row[x] >> 5) & 0x3f) << 2);
            rgb[3u*x+2u] = (uint8_t)((row[x] & 0x1f) << 3);
        }
        if (fwrite(rgb, 1, (size_t)w * 3u, file) != (size_t)w * 3u) ok = 0;
    }
    free(rgb);
    if (fclose(file)) ok = 0;
    if (!ok) return 0;
    rc_log("  SHOTFILE %u dumped (%ux%u)", number, w, h);
    rc_log("  SHOT %u at virtual %u ms", number, now);
    rc_input_script_log_observation(); /* guest MAIN token; read-only */
    return !control_log_failed;
}
static void poll_hook(void)
{
    if (input_control) {
        if (!rc_thread_is_main()) return;
        if (control_log_failed) rc_input_control_fail(input_control, "control log write/flush failed");
        rc_input_control_poll(input_control);
        if (control_log_failed) rc_input_control_fail(input_control, "control log write/flush failed");
    } else rc_input_script_poll(input_script);
}

/* ---- real time (RC_REAL=1) ---- */
static uint64_t real_now(void *u) { (void)u; struct timespec t; clock_gettime(CLOCK_MONOTONIC, &t); return (uint64_t)t.tv_sec * 1000u + (uint64_t)t.tv_nsec / 1000000u; }
static void real_sleep(void *u, uint32_t ms) { (void)u; struct timespec t = {ms / 1000u, (long)(ms % 1000u) * 1000000L}; nanosleep(&t, NULL); }

int main(void)
{
    const char *exe = getenv("GAME_EXE");
    const char *gamedir = getenv("RC_GAMEDIR");
    const char *out = getenv("RC_OUT");
    const char *fifo = getenv("RC_CONTROL_FIFO");
    control_mode = fifo && *fifo;
    int out_length = snprintf(out_dir, sizeof out_dir, "%s", out ? out : "out");
    if (control_mode && (out_length < 0 || (size_t)out_length >= sizeof out_dir)) {
        fprintf(stderr, "RC_OUT path too long\n"); return 2;
    }
    char path[700];
    mkdir(out_dir, 0755);
    snprintf(path, sizeof path, "%s/frames", out_dir);
    mkdir(path, 0755);
    snprintf(path, sizeof path, "%s/run.log", out_dir);
    logf = fopen(path, "w");
    if (control_mode && !logf) { fprintf(stderr, "cannot open control run.log\n"); return 2; }
    RcPlatform pl;
    memset(&pl, 0, sizeof pl);
    pl.game_dir = gamedir ? gamedir : "gamedir";
    pl.log = plat_log;
    pl.bink_open = bink_open; pl.bink_frame = bink_frame; pl.bink_close = bink_close;
    if (getenv("RC_REAL")) { pl.now_ms = real_now; pl.sleep_ms = real_sleep; }
    rc_set_platform(&pl);
    char error[512];
    const char *input = getenv("INPUT");
    if (control_mode) {
        input_control = rc_input_control_open(fifo, input, control_shot_checked, NULL, error, sizeof error);
        if (!input_control) { fprintf(stderr, "RC_CONTROL_FIFO: %s\n", error); fclose(logf); return 2; }
        rc_set_poll_hook(poll_hook);
    } else if (input && *input) {
        input_script = rc_input_script_parse(input, script_shot, NULL, error, sizeof error);
        if (!input_script) { fprintf(stderr, "INPUT: %s\n", error); if (logf) fclose(logf); return 2; }
        rc_set_poll_hook(poll_hook);
    }
    rc_set_frame_hook(frame_hook);
    if (getenv("MAX_IMPORTS")) rc_set_import_budget(strtoull(getenv("MAX_IMPORTS"), NULL, 10));
    if (getenv("MAX_IDLE_POLLS")) rc_set_max_idle_polls((uint32_t)strtoul(getenv("MAX_IDLE_POLLS"), NULL, 10));   /* idle polls of the message loop in all (5 virtual ms each) before the run is stopped */
    if (rc_start(exe ? exe : "../../work/original/GAME.EXE", error, sizeof error)) {
        fprintf(stderr, "rc_start: %s\n", error);
        if (input_control) {
            rc_input_control_fail(input_control, "rc_start failed");
            rc_input_control_end(input_control); rc_input_control_destroy(input_control);
            if (logf) fclose(logf);
        }
        return 2;
    }
    struct timespec t0, t1;
    clock_gettime(CLOCK_MONOTONIC, &t0);
    char why[600];
    int guest_result = rc_main(why, sizeof why);
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
    if (input_script) {
        RcInputScriptStatus status = rc_input_script_status(input_script);
        rc_log("  SCRIPT delivered=%u total=%u consumed=%u requested_stop=%d complete=%d",
               status.delivered, status.total, status.consumed, status.requested_stop,
               rc_input_script_completed(input_script));
        rc_input_script_destroy(input_script);
    }
    int control_complete = 1;
    if (input_control) {
        if (!rc_diagnostic_guest_succeeded(guest_result, why)) rc_input_control_fail(input_control, why);
        if (control_log_failed) rc_input_control_fail(input_control, "control log write/flush failed");
        control_complete = rc_input_control_end(input_control);
        rc_input_control_destroy(input_control);
    }
    rc_log("\nRESULT %s", result);
    puts(result);
    if (logf && fclose(logf) && control_mode) control_log_failed = 1;
    return control_mode && (!control_complete || control_log_failed) ? 6 : 0;
}
