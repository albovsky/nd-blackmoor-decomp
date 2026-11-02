/* Declarations shared between the host's modules (not part of the platform interface). */
#ifndef RC_INTERNAL_H
#define RC_INTERNAL_H
#include <stdint.h>
#include "rc.h"

#ifdef __cplusplus
extern "C" {
#endif

extern RcPlatform rc_plat;

/* DirectDraw */
uint32_t rc_surf_alloc(uint32_t bytes);
void rc_surf_free(uint32_t p, uint32_t bytes);
void rc_set_frame_hook(void (*hook)(int is_flip, uint64_t blits));

/* DirectSound mixer: a movie's soundtrack plays as a voice beside the sound buffers */
int rc_voice_start(const float *pcm, uint64_t frames, uint32_t channels, uint32_t rate, uint64_t start_frame);
void rc_voice_stop(int id);

/* Win32 */
int rc_fs_resolve(const char *win, int must_exist, char *out, size_t cap);
void rc_fs_log(const char *what, const char *win);
int rc_unimpl_api(Fl41Regs *r, const uint32_t *a, uint32_t *ret);
void rc_event_set(uint32_t handle);
int rc_seen_at(const char *name, uint32_t *at);
const char *rc_first_data_file(void);
uint32_t rc_files_opened(void);
void rc_set_poll_hook(void (*hook)(void));
void rc_set_max_idle_polls(uint32_t n);
int rc_is_stub_name(const char *name);

/* Serialized native continuations for guest Win32 threads. All calls below
 * run with the guest execution token, except enter/leave at the process root. */
typedef struct RcGuestThread RcGuestThread;
void rc_threads_enter(void);
void rc_threads_leave(void);
void rc_threads_yield(void);
uint32_t rc_thread_id(void);
int rc_thread_is_main(void);
RcGuestThread *rc_thread_create(uint32_t entry, uint32_t parameter, uint32_t stack_size, uint32_t flags, uint32_t *id);
uint32_t rc_thread_resume(RcGuestThread *thread);
uint32_t rc_thread_suspend(RcGuestThread *thread);
RcGuestThread *rc_thread_current(void);
uint32_t rc_thread_exit_code(RcGuestThread *thread);
int rc_thread_finished(RcGuestThread *thread);
void rc_thread_close(RcGuestThread *thread);
void rc_thread_exit(uint32_t code) __attribute__((noreturn));

/* The scheduler swaps these under the token; lifted C still sees rc_host.fpu
 * and FL41_TIB at their original stable addresses. */
void *rc_context_create(uint32_t stack_size, uint32_t id);
void rc_context_save(void *context);
void rc_context_restore(void *context);
void rc_context_destroy(void *context);

#ifdef __cplusplus
}
#endif
#endif
