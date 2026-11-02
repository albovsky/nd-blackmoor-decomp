#ifndef RC_INPUT_CONTROL_H
#define RC_INPUT_CONTROL_H
#include "rc_input_script.h"
#include <stdint.h>
#ifdef __cplusplus
extern "C" {
#endif

#define RC_CONTROL_MAX_BATCH_BYTES 65536u
#define RC_CONTROL_MAX_REQUESTS 4096u /* includes the terminal finish request */
#define RC_CONTROL_MAX_STREAM_BYTES (16u * 1024u * 1024u)

typedef struct RcInputControl RcInputControl;
typedef struct RcInputControlStatus {
    unsigned requests, acknowledged, active_id, finish_id;
    unsigned total_steps, delivered, shots;
    uint64_t bytes_read;
    size_t pending_bytes;
    int writer_seen, requested_stop, complete, failed;
    char error[192];
} RcInputControlStatus;
/* Caller creates a private FIFO and keeps its writer open until finish. Opens
 * read-only/nonblocking, verifies fstat FIFO; never creates or removes paths.
 * Pass the existing INPUT value to enforce mutual exclusion atomically. */
RcInputControl *rc_input_control_open(const char *path, const char *input,
                                     RcInputScriptShot shot, void *user,
                                     char *error, size_t capacity);
/* MAIN guest poll only: at most one nonblocking read (4096 bytes), one request
 * start and one script_poll. Worker calls do nothing. No sleep or clock writes.
 * Completed scripts are destroyed before any automatic script-tail poll. */
void rc_input_control_poll(RcInputControl *control);
/* Host output errors request controlled stop; this never calls rc_abort. */
void rc_input_control_fail(RcInputControl *control, const char *reason);
/* Status only under MAIN token, or after all guest threads have joined. */
RcInputControlStatus rc_input_control_status(const RcInputControl *control);
/* After all guest threads join: fail incomplete sessions, emit one terminal
 * summary, return true only for explicit finish with all prior batches ACKed. */
int rc_input_control_end(RcInputControl *control);
void rc_input_control_destroy(RcInputControl *control);
#ifdef __cplusplus
}
#endif
#endif
