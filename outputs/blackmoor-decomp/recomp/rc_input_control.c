/* Opt-in headless ordinary-input batches. No guest memory reads or writes. */
#include "rc_input_control.h"
#include "rc_internal.h"
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

enum { READ_CHUNK = 4096, BUFFER_BYTES = RC_CONTROL_MAX_BATCH_BYTES + 12u };
struct RcInputControl {
    int fd, writer_seen, eof, finishing, requested_stop, complete, failed, ended;
    char buffer[BUFFER_BYTES + 1u], error[192];
    size_t used;
    uint64_t bytes_read;
    unsigned next_id, requests, acknowledged, active_id, finish_id;
    unsigned total_steps, delivered, shots;
    RcInputScript *active;
    RcInputScriptShot shot;
    void *user;
};
static void error_text(char *error, size_t capacity, const char *text)
{
    if (error && capacity) snprintf(error, capacity, "%s", text);
}
static void request_stop(RcInputControl *c)
{
    if (!c->requested_stop) { c->requested_stop = 1; rc_request_stop(); }
}
void rc_input_control_fail(RcInputControl *c, const char *reason)
{
    if (!c || c->failed) return;
    c->failed = 1; c->complete = 0;
    snprintf(c->error, sizeof c->error, "%s", reason && *reason ? reason : "control failed");
    rc_log("  CONTROL ERROR id=%u clock_ms=%u reason=%s", c->active_id ? c->active_id : c->next_id, rc_clock(), c->error);
    request_stop(c);
}
RcInputControl *rc_input_control_open(const char *path, const char *input,
                                     RcInputScriptShot shot, void *user,
                                     char *error, size_t capacity)
{
    error_text(error, capacity, "");
    if (!path || !*path || (input && *input)) {
        error_text(error, capacity, "RC_CONTROL_FIFO requires a path and is mutually exclusive with nonempty INPUT"); return NULL;
    }
    int flags = O_RDONLY | O_NONBLOCK | O_CLOEXEC;
#ifdef O_NOFOLLOW
    flags |= O_NOFOLLOW;
#endif
    int fd = open(path, flags);
    if (fd < 0) { error_text(error, capacity, "cannot open RC_CONTROL_FIFO read-only/nonblocking"); return NULL; }
    struct stat st;
    if (fstat(fd, &st) || !S_ISFIFO(st.st_mode)) {
        close(fd); error_text(error, capacity, "RC_CONTROL_FIFO is not a FIFO"); return NULL;
    }
    RcInputControl *c = calloc(1, sizeof *c);
    if (!c) { close(fd); error_text(error, capacity, "cannot allocate input control"); return NULL; }
    c->fd = fd; c->next_id = 1; c->shot = shot; c->user = user;
    return c;
}
static int control_shot(void *user, unsigned local_number, uint32_t now)
{
    RcInputControl *c = user;
    (void)local_number;
    /* At most 4095 batches * 512 steps, below UINT_MAX on supported hosts. */
    ++c->shots;
    return c->shot && c->shot(c->user, c->shots, now);
}
/* One bounded nonblocking read per main poll. A full buffer containing complete
 * requests applies ordinary FIFO backpressure until its active batch finishes. */
static int read_more(RcInputControl *c)
{
    if (c->eof) return 1;
    size_t room = BUFFER_BYTES - c->used;
    if (!room) {
        if (!memchr(c->buffer, '\n', c->used)) rc_input_control_fail(c, "control line exceeds byte limit");
        return 0;
    }
    if (room > READ_CHUNK) room = READ_CHUNK;
    ssize_t count = read(c->fd, c->buffer + c->used, room);
    if (count < 0) {
        if (errno == EAGAIN || errno == EWOULDBLOCK) { c->writer_seen = 1; return 1; }
        if (errno != EINTR) rc_input_control_fail(c, "control FIFO read failed");
        return 0;
    }
    if (!count) {
        if (c->writer_seen) c->eof = 1; /* initial no-writer EOF may wait */
        return c->eof;
    }
    c->writer_seen = 1;
    c->bytes_read += (uint64_t)count;
    if (c->bytes_read > RC_CONTROL_MAX_STREAM_BYTES) { rc_input_control_fail(c, "control stream exceeds byte limit"); return 0; }
    if (memchr(c->buffer + c->used, 0, (size_t)count) || memchr(c->buffer + c->used, '\r', (size_t)count)) {
        rc_input_control_fail(c, "control protocol requires NUL-free LF lines"); return 0;
    }
    c->used += (size_t)count;
    c->buffer[c->used] = 0;
    return 0;
}
static int start_request(RcInputControl *c)
{
    char *end = memchr(c->buffer, '\n', c->used);
    if (!end) return 0;
    size_t length = (size_t)(end - c->buffer);
    *end = 0;
    char *space = strchr(c->buffer, ' ');
    if (!space || space == c->buffer || c->buffer[0] == '0') goto invalid;
    uint64_t id = 0;
    for (char *p = c->buffer; p < space; ++p) {
        if (*p < '0' || *p > '9') goto invalid;
        id = id * 10u + (unsigned)(*p - '0');
        if (id > UINT32_MAX) goto invalid;
    }
    if (id != c->next_id || id > RC_CONTROL_MAX_REQUESTS) goto invalid;
    char *payload = space + 1;
    size_t bytes = length - (size_t)(payload - c->buffer);
    if (!bytes || bytes > RC_CONTROL_MAX_BATCH_BYTES) goto invalid;
    if (!strcmp(payload, "finish")) {
        c->finish_id = (unsigned)id; c->finishing = 1;
    } else {
        if (id == RC_CONTROL_MAX_REQUESTS) { rc_input_control_fail(c, "last control request must be finish"); return 0; }
        char error[192];
        c->active = rc_input_script_parse(payload, control_shot, c, error, sizeof error);
        if (!c->active) { rc_input_control_fail(c, error); return 0; }
        c->active_id = (unsigned)id;
        c->total_steps += rc_input_script_status(c->active).total;
    }
    ++c->requests; ++c->next_id;
    c->used -= length + 1u;
    memmove(c->buffer, end + 1, c->used);
    c->buffer[c->used] = 0;
    return 1;
invalid:
    rc_input_control_fail(c, "invalid control id, sequence or line length");
    return 0;
}
void rc_input_control_poll(RcInputControl *c)
{
    if (!c || !rc_thread_is_main() || c->complete || c->failed || c->ended) return;
    int was_finishing = c->finishing;
    uint64_t before = c->bytes_read;
    int drained = read_more(c);
    if (c->failed) return;
    if (c->finishing) {
        if (c->used || before != c->bytes_read) { rc_input_control_fail(c, "data after finish"); return; }
        /* A separate main poll must confirm the FIFO is drained after finish.
         * EINTR is retried on a later poll, not in a blocking internal loop. */
        if (was_finishing && drained) {
            c->complete = 1; request_stop(c);
        }
        return;
    }
    if (c->eof && !memchr(c->buffer, '\n', c->used)) {
        rc_input_control_fail(c, c->used ? "EOF with partial control line" : "EOF before explicit finish"); return;
    }
    if (!c->active && !start_request(c)) return;
    if (c->failed) return;
    if (c->finishing) {
        if (c->used) rc_input_control_fail(c, "data after finish");
        return; /* Do not discard unread FIFO data or stop in this poll. */
    }
    rc_input_script_poll(c->active); /* exactly once under the main guest token */
    RcInputScriptStatus s = rc_input_script_status(c->active);
    if (s.failed) { rc_input_control_fail(c, "control capture failed"); return; }
    if (s.requested_stop) { rc_input_control_fail(c, "unexpected script tail stop"); return; }
    if (s.consumed != s.delivered) { rc_input_control_fail(c, "control step consumed without HWND delivery"); return; }
    if (s.delivered == s.total) {
        c->delivered += s.delivered;
        ++c->acknowledged;
        unsigned id = c->active_id;
        rc_input_script_destroy(c->active); c->active = NULL; c->active_id = 0;
        rc_log("  CONTROL ACK id=%u steps=%u/%u shots=%u clock_ms=%u total_steps=%u total_shots=%u",
               id, s.delivered, s.total, s.shots, rc_clock(), c->delivered, c->shots);
    }
}
RcInputControlStatus rc_input_control_status(const RcInputControl *c)
{
    RcInputControlStatus s = {0};
    if (!c) return s;
    s.requests = c->requests; s.acknowledged = c->acknowledged;
    s.active_id = c->active_id; s.finish_id = c->finish_id;
    s.total_steps = c->total_steps; s.delivered = c->delivered; s.shots = c->shots;
    if (c->active) s.delivered += rc_input_script_status(c->active).delivered;
    s.bytes_read = c->bytes_read; s.pending_bytes = c->used;
    s.writer_seen = c->writer_seen; s.requested_stop = c->requested_stop;
    s.complete = c->complete && !c->failed; s.failed = c->failed;
    snprintf(s.error, sizeof s.error, "%s", c->error);
    return s;
}
int rc_input_control_end(RcInputControl *c)
{
    if (!c) return 0;
    if (!c->complete || c->active || c->used || !c->finish_id) rc_input_control_fail(c, "control ended without explicit complete finish");
    if (!c->ended) {
        RcInputControlStatus s = rc_input_control_status(c);
        rc_log("  CONTROL SUMMARY complete=%d finish_id=%u acked=%u requests=%u steps=%u/%u shots=%u bytes=%llu pending=%zu clock_ms=%u failed=%d reason=%s",
               s.complete, s.finish_id, s.acknowledged, s.requests, s.delivered, s.total_steps, s.shots,
               (unsigned long long)s.bytes_read, s.pending_bytes, rc_clock(), s.failed, s.error);
        c->ended = 1;
    }
    return c->complete && !c->failed;
}
void rc_input_control_destroy(RcInputControl *c)
{
    if (!c) return;
    rc_input_script_destroy(c->active);
    close(c->fd); free(c);
}
