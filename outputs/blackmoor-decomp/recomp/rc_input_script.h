#ifndef RC_INPUT_SCRIPT_H
#define RC_INPUT_SCRIPT_H
#include <stddef.h>
#include <stdint.h>
#ifdef __cplusplus
extern "C" {
#endif

typedef struct RcInputScript RcInputScript;
/* Called synchronously under the guest main-thread token. May read observations
 * and primary pixels here; return zero on an output failure. Never call AppKit. */
typedef int (*RcInputScriptShot)(void *user, unsigned number, uint32_t now);
typedef struct RcInputScriptStatus {
    unsigned total, consumed, delivered, shots;
    int requested_stop, failed;
} RcInputScriptStatus;
/* Legacy frontends parse/load before guest execution. Live-control batches may
 * parse synchronously under the MAIN guest token; never parse concurrently.
 * Maximum512 steps,65536 bytes,63-byte time/anchor and7-byte kind; atomic refusal. */
RcInputScript *rc_input_script_parse(const char *text, RcInputScriptShot shot,
                                    void *user, char *error, size_t capacity);
RcInputScript *rc_input_script_load_file(const char *path, RcInputScriptShot shot,
                                        void *user, char *error, size_t capacity);
/* Install a no-argument wrapper through rc_set_poll_hook. Worker polls are
 * ignored. All input uses the existing host queue; no OS input/state writes. */
void rc_input_script_poll(RcInputScript *script);
/* Read status only on the guest thread or after every guest thread is joined. */
RcInputScriptStatus rc_input_script_status(const RcInputScript *script);
/* Verification completion requires every step delivered and its own tail stop.
 * A frontend deadline/timeout, early natural exit or tail=0 is not completion. */
int rc_input_script_completed(const RcInputScript *script);
void rc_input_script_destroy(RcInputScript *script);
/* Existing original scene/view/held-item and RC_FLAGS observations; read-only.
 * Call only from a guest-token shot callback. Legacy RC_FLAGS syntax retained. */
void rc_input_script_log_observation(void);
#ifdef __cplusplus
}
#endif
#endif
