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

#ifdef __cplusplus
}
#endif
#endif
