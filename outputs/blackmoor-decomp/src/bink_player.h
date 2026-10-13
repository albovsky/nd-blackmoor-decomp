#ifndef BINK_PLAYER_H
#define BINK_PLAYER_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct BinkPlayer BinkPlayer;

typedef enum bink_player_status {
    BINK_PLAYER_OK = 0,
    BINK_PLAYER_NOT_DUE = 1,
    BINK_PLAYER_EOS = 2,
    BINK_PLAYER_ERR_ARGUMENT = -1,
    BINK_PLAYER_ERR_FILE = -2,
    BINK_PLAYER_ERR_FORMAT = -3,
    BINK_PLAYER_ERR_DECODE = -4,
    BINK_PLAYER_ERR_MEMORY = -5,
    BINK_PLAYER_ERR_BOUNDS = -6,
    BINK_PLAYER_ERR_TIMESTAMP = -7
} bink_player_status;

typedef struct BinkPlayerInfo {
    uint32_t width;
    uint32_t height;
    uint32_t total_frames;
    int32_t frame_rate_num;
    int32_t frame_rate_den;
    int32_t time_base_num;
    int32_t time_base_den;
    /* Sum of unique retained AVBufferRef payload sizes, including extended_buf. */
    uint64_t decoded_frame_storage_bytes;
} BinkPlayerInfo;

/*
 * Returned RGBA storage is borrowed from the player and is invalidated by the
 * next advance, mode change, seek, or close. current_frame is zero-based, as
 * GAME.EXE's 0x005BB50B current-frame global; seek's argument is one-based,
 * matching BinkGoto's target frame.
 *
 * pts_ns is the decoded frame's FFmpeg timestamp rescaled to nanoseconds.
 * duration_ns is the absolute timestamp interval to the next frame in the
 * selected direction (zero for a terminal frame). is_terminal identifies
 * the last frame at this mode's boundary; advance returns EOS on its next
 * call. FFmpeg timestamps provide the native host pacing adaptation, not
 * evidence of BinkWait clock parity.
 */
typedef struct BinkPlayerFrame {
    const uint8_t *rgba;
    size_t rgba_bytes;
    uint32_t width;
    uint32_t height;
    uint32_t stride;
    int32_t current_frame;
    int64_t pts_ns;
    int64_t duration_ns;
    uint8_t is_terminal;
} BinkPlayerFrame;

/*
 * Opens and decodes a bounded local Bink video. The existing first-frame
 * adapter is used to establish/retain frame zero; the timed player retains
 * decoded video frames for deterministic forward/reverse stepping and seek.
 * Audio packets are ignored. The player supports at most 256 MiB of unique
 * retained decoded AVBufferRef payload bytes (buf and extended_buf identities
 * counted once), 100,000 frames, and 4096x4096 dimensions. The byte metric
 * excludes RGBA staging and frame/index bookkeeping. Exceeding a limit is an
 * explicit bounds error.
 */
int bink_player_open(const char *path,
                     BinkPlayer **out_player,
                     BinkPlayerInfo *out_info,
                     char *error,
                     size_t error_capacity);

/*
 * Matches FUN_004bef11: mode 1 starts at the final frame and steps backward;
 * every other mode starts at frame zero and steps forward. It does not loop.
 * now_ns is the caller's monotonic-clock sample used as the pacing origin.
 */
int bink_player_set_mode(BinkPlayer *player,
                         int32_t original_mode,
                         uint64_t now_ns,
                         char *error,
                         size_t error_capacity);

/* Matches FUN_004bf19a's one-based BinkGoto range check (1..total_frames). */
int bink_player_seek(BinkPlayer *player,
                     uint32_t frame_1based,
                     uint64_t now_ns,
                     char *error,
                     size_t error_capacity);

/*
 * Returns BINK_PLAYER_OK with one frame, NOT_DUE while its timestamp interval
 * has not elapsed, EOS after the selected mode reaches its first/last frame,
 * or a negative error. The caller controls time; this function has no timer,
 * thread, UI, audio-device, or scene-controller dependency.
 */
int bink_player_advance(BinkPlayer *player,
                        uint64_t now_ns,
                        BinkPlayerFrame *out_frame,
                        char *error,
                        size_t error_capacity);

void bink_player_close(BinkPlayer *player);
const char *bink_player_status_string(int status);

#ifdef __cplusplus
}
#endif

#endif
