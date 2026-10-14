#ifndef BLACKMOOR_SESSION_BINDINGS_CONDITIONS_H
#define BLACKMOOR_SESSION_BINDINGS_CONDITIONS_H

/* RT-4: session binding for the recovered dependency leaves (opcodes 11, 12,
 * 13, 14, 15, 17, 20, 21).
 *
 * The reviewed leaf kernel is condition_extra (S06-2). This module is the
 * app-side adapter that lets the scene executor run it inside the same tree
 * reduction the executor already performs:
 *
 *   - It supplies the host state the kernel leaves open and implements the
 *     SceneConditionExtension hooks (leaf, per-pass reset, post-tree store).
 *   - Process-global 0x5c3a47 lives here: `mov [0x5c3a47], 1` before every
 *     dispatcher pass (0x43cf25) and the wrapper's `(root == 0)` store after
 *     every tree (0x423f57 at 0x423f92 / 0x423faa). Opcode 21 reads it.
 *   - Opcode 17's sound query reproduces the decision logic of original
 *     0x4f6334 over a channel record and its sound-manager mutations
 *     (+0x3c2 error code, +0x3ca host result, +0x3be state). Where the native
 *     audio host cannot supply the record the query reports host-unavailable;
 *     it never defaults to false.
 *   - Opcode 20's random source is a faithful MSVC CRT rand() (see
 *     SessionConditionsCrtRand). The seed is NOT proven (the original calls
 *     srand(time(NULL)) once at 0x43504f); callers state the seed.
 *   - Opcode 15's context word 0x58c94f is the difficulty word that action
 *     0x71 stores (0x4292b3) and New Game zeroes (0x4383af); the host reads
 *     it from the action-core world or reports it unavailable.
 *
 * Everything is borrowed: world, clock and host contexts outlive the binding.
 */

#include "condition_extra.h"
#include "scene_conditions.h"
#include "world_clock.h"

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_CONDITIONS_CHANNEL_COUNT 32u

typedef struct SessionConditions SessionConditions;

typedef enum session_conditions_status {
    SESSION_CONDITIONS_OK = 0,
    SESSION_CONDITIONS_ERR_ARGUMENT = 1,
    SESSION_CONDITIONS_ERR_MEMORY = 2
} SessionConditionsStatus;

/* Values original 0x4f6334 reads for one channel: manager+0x1a0 (device
 * ready), channel +0x162 (resource ready), +0x28f (DirectSound buffer
 * pointer), +0x19e (delayed-repeat marker), +0x16e and +0x172 (pause gates)
 * and, for the GetStatus path, the HRESULT and status word that call
 * returned. The host fills only what is true of its channel; fields that its
 * model cannot resolve make it answer HOST_UNAVAILABLE instead. */
typedef struct session_conditions_channel_record {
    uint32_t device_ready_1a0;
    uint32_t resource_ready_162;
    uint32_t buffer_available_28f;
    uint32_t repeat_marker_19e;
    uint32_t gate_16e;
    uint32_t gate_172;
    int32_t get_status_hresult;
    uint32_t get_status_flags;
} SessionConditionsChannelRecord;

/* HOST_OK fills `record`. HOST_UNAVAILABLE commits nothing. */
typedef ConditionExtraHostStatus (*SessionConditionsChannelFn)(
    void *context, uint16_t channel, SessionConditionsChannelRecord *record);

/* The sound manager's last-query state written by 0x4f6334. */
typedef struct session_conditions_sound_manager {
    uint32_t state_3be;
    uint32_t error_3c2;
    int32_t host_result_3ca;
} SessionConditionsSoundManager;

/* Read the difficulty/context word 0x58c94f. HOST_UNAVAILABLE if absent. */
typedef ConditionExtraHostStatus (*SessionConditionsContextFn)(
    void *context, int16_t *value);

/* Word at 0x5adb81 + 2 * index (loader table for opcode 13/14 seconds).
 * Return 1 with *value, or 0 if the host cannot source it. */
typedef int (*SessionConditionsVariableFn)(void *context, int16_t index,
                                           int16_t *value);

typedef struct session_conditions_host {
    void *context;
    SessionConditionsChannelFn channel_record;
    ConditionExtraNextRandomFn next_random;
    SessionConditionsContextFn read_context_58c94f;
    SessionConditionsVariableFn read_variable_word;
} SessionConditionsHost;

typedef struct session_conditions_config {
    WorldInitState *world;
    WorldClockSession *clock;
    SessionConditionsHost host;
    /* 0x63a4cd: when nonzero, a random leaf whose condition lies outside
     * 1..100 stops in the original's debug path. Release default is zero;
     * what the shipped game holds at run time is unverified. */
    int32_t debug_enabled_63a4cd;
} SessionConditionsConfig;

typedef struct session_conditions_stats {
    uint64_t leaf_evaluations;
    uint64_t sound_queries;
    uint64_t random_draws;
    uint64_t passes_started;
    uint64_t trees_evaluated;
} SessionConditionsStats;

SessionConditions *session_conditions_create(
    const SessionConditionsConfig *config, int *status);
void session_conditions_destroy(SessionConditions *binding);

/* The extension to hand to scene_session_set_condition_extension. Valid for
 * the lifetime of the binding. */
const SceneConditionExtension *session_conditions_extension(
    const SessionConditions *binding);

/* Process global 0x5c3a47 (BSS, so zero before the first pass). */
int32_t session_conditions_global_5c3a47(const SessionConditions *binding);
void session_conditions_set_global_5c3a47(SessionConditions *binding,
                                          int32_t value);

int session_conditions_get_sound_manager(const SessionConditions *binding,
                                         SessionConditionsSoundManager *state);
int session_conditions_get_stats(const SessionConditions *binding,
                                 SessionConditionsStats *stats);

/* Original 0x4f6334 decision logic over a record. Returns the helper's
 * result; `manager` receives the writes it performs, in order. Exposed for
 * tests and the oracle. */
int session_conditions_query_channel_record(
    const SessionConditionsChannelRecord *record,
    SessionConditionsSoundManager *manager);

/* Word of the loader table at 0x5adb81 + 2 * index as seen through the BOOT
 * BSUM chunk. The BOOT loader (0x4356eb..0x4356fc: `mov edi, 0x5b0113;
 * rep movsd/movsb`) copies the 402-byte BSUM payload over 0x5b0113..0x5b02a4,
 * so byte k of BSUM is at 0x5b0113 + k and table word `index` is BSUM byte
 * 2 * index - 9618 (0x5b0113 - 0x5adb81 = 9618). For the corpus indexes
 * 5000..5003 that is BSUM[382..389] = 300, 180, 1500, 60. Returns 1 with
 * *value (signed little-endian) when the word lies inside the payload
 * (indexes 4809..5009), else 0: the rest of that memory is not BSUM and has
 * no recovered source. */
int session_conditions_bsum_variable_word(const uint8_t *bsum, size_t bsum_size,
                                          int16_t index, int16_t *value);

/* MSVC CRT rand(): holdrand = holdrand * 214013 + 2531011;
 * return (holdrand >> 16) & 0x7fff (original 0x50cd50 / srand 0x50cd43).
 * A fresh generator holds 1, the CRT's initial per-thread value. */
typedef struct session_conditions_crt_rand {
    uint32_t holdrand;
} SessionConditionsCrtRand;

void session_conditions_crt_rand_init(SessionConditionsCrtRand *generator);
void session_conditions_crt_srand(SessionConditionsCrtRand *generator,
                                  uint32_t seed);
uint32_t session_conditions_crt_rand(SessionConditionsCrtRand *generator);
/* ConditionExtraNextRandomFn over a SessionConditionsCrtRand context. */
ConditionExtraHostStatus session_conditions_crt_rand_host(
    void *generator_context, uint32_t *raw_rand_value);

const char *session_conditions_status_string(int status);

#ifdef __cplusplus
}
#endif

#endif
