/* What the recompiled game needs from the machine it runs on. The macOS app and the Linux headless harness each fill one in. */
#ifndef RC_PLATFORM_H
#define RC_PLATFORM_H

#include <stdint.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct RcBinkInfo {
    uint32_t width, height, frames;
    uint32_t rate, rate_div;          /* frames per second = rate / rate_div */
} RcBinkInfo;

typedef struct RcPlatform {
    void *user;
    /* The folder that stands for C:\GAME (Ciftree, CDSound, CDVideo, Game.ini, ...). Writes (saves, the per-user Game.ini) land beside it. */
    const char *game_dir;
    /* Where the game writes (C:\GAME\Documents*: its per-user Game.ini and saves). NULL: beside game_dir. */
    const char *save_dir;
    /* Real time. NULL selects the deterministic virtual clock: every empty message poll and every GetTickCount moves time on, as in the Python spike. */
    uint64_t (*now_ms)(void *user);
    void (*sleep_ms)(void *user, uint32_t ms);
    /* Bink video: decode frame `frame` (1-based) as RGB565 into rgb565 (width x height, pitch in pixels). Return 0 on success. */
    int (*bink_open)(void *user, const char *path, RcBinkInfo *info, void **movie);
    int (*bink_frame)(void *user, void *movie, uint32_t frame, uint16_t *rgb565, uint32_t pitch_pixels);
    void (*bink_close)(void *user, void *movie);
    /* The movie's soundtrack as interleaved float PCM (owned by the platform until bink_close). Return 0 when there is one. May be NULL. */
    int (*bink_audio)(void *user, void *movie, const float **pcm, uint64_t *frames, uint32_t *channels, uint32_t *rate);
    /* A line for the run log (may be NULL). */
    void (*log)(void *user, const char *line);
} RcPlatform;

/* Set once before rc_start. The structure is copied. */
void rc_set_platform(const RcPlatform *platform);

/* Load GAME.EXE (read only), map the machine, register the lifted functions and the host stubs. Returns 0, or -1 with *error set. */
int rc_start(const char *game_exe, char *error, size_t error_capacity);
/* Run the game from its entry point until it exits, aborts or is asked to stop. Returns the stop reason in *why. */
int rc_main(char *why, size_t why_capacity);
/* Ask the running game to end (any thread). */
void rc_request_stop(void);
/* Statistics for the run log. */
void rc_get_stats(uint64_t *native_calls, uint64_t *fallback_calls, uint64_t *imports);

/* Input, from any thread. Coordinates are the game's 640x480 client coordinates. */
void rc_input_mouse(int32_t x, int32_t y, int left_down);
void rc_input_key(uint32_t virtual_key, int down);

/* The primary surface as the game last drew it: RGB565, width x height, pitch in bytes. The pointer stays valid while the game runs. */
int rc_get_primary(const uint16_t **pixels, uint32_t *width, uint32_t *height, uint32_t *pitch_bytes);
/* Number of times the game has completed a drawing step on the primary surface (BltFast, Blt, Flip). */
uint64_t rc_primary_serial(void);

/* Sound: mix every playing DirectSound buffer into interleaved stereo 16-bit at `rate` Hz (any thread; returns the frames written). */
uint32_t rc_audio_render(int16_t *stereo, uint32_t frames, uint32_t rate);
/* Headless: advance the sound clock by this many milliseconds without rendering (virtual clock only). */
void rc_audio_skip(uint32_t ms);

#ifdef __cplusplus
}
#endif
#endif
