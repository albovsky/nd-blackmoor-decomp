/* Native host for the recompiled GAME.EXE.
 *
 * The lifted C (scripts/lift_fl41.py, driven by recomp/lift_recomp.py) is the game's own code over its own 32-bit address space. This host
 * supplies that address space, the call dispatcher, and the Win32, DirectDraw, DirectSound and Bink stand-ins the game imports, backed by a
 * small platform interface (rc_platform.h) that the macOS app or the headless harness implements. Nothing here is the Python spike's
 * Win32 shim any more: tasks/spike-recompile/driver.py stays only as the oracle the native host is compared with.
 */
#ifndef RC_H
#define RC_H

#include <stdint.h>
#include <stddef.h>
#include <string.h>
#include "original_methods_fl41.h"
#include "rc_platform.h"

#ifdef __cplusplus
extern "C" {
#endif

#define RC_PAGE 4096u
#define RC_NPAGES (1u << 20)
#define RC_IMAGE_BASE 0x400000u
#define RC_STACK_BASE 0x7c000000u
#define RC_STACK_SIZE 0x100000u
#define RC_TIB 0x7d000000u
#define RC_MAGIC 0x7e000000u          /* import and COM method stubs, 16 bytes each */
#define RC_HEAP_BASE 0x10000000u
#define RC_HEAP_SIZE 0x30000000u
#define RC_SURF_BASE 0x40000000u      /* DirectDraw surface and DirectSound buffer memory */
#define RC_SURF_SIZE 0x30000000u
#define RC_STOP 0x7f000000u           /* return address that ends a host-initiated call */

/* ---- guest memory: a page table over host memory, so lifted loads and stores are two loads and a branch ---- */
extern uint8_t *rc_pages[RC_NPAGES];
uint32_t rc_rd_slow(uint32_t address, int bytes);
void rc_wr_slow(uint32_t address, int bytes, uint32_t value);

static inline uint32_t rc_rd(uint32_t a, int bytes)
{
    uint8_t *p = rc_pages[a >> 12];
    uint32_t off = a & (RC_PAGE - 1u);
    if (p && off + (uint32_t)bytes <= RC_PAGE) {
        uint32_t v = 0;
        memcpy(&v, p + off, (size_t)bytes);      /* little-endian host */
        return v;
    }
    return rc_rd_slow(a, bytes);
}

static inline void rc_wr(uint32_t a, int bytes, uint32_t v)
{
    uint8_t *p = rc_pages[a >> 12];
    uint32_t off = a & (RC_PAGE - 1u);
    if (p && off + (uint32_t)bytes <= RC_PAGE) { memcpy(p + off, &v, (size_t)bytes); return; }
    rc_wr_slow(a, bytes, v);
}

int rc_map(uint32_t va, uint32_t size, void *mem);        /* map host memory (page aligned, contiguous) at va */
void *rc_map_new(uint32_t va, uint32_t size);             /* map fresh zeroed anonymous memory; NULL when va is taken */
int rc_is_mapped(uint32_t va);
void *rc_ptr(uint32_t va, uint32_t bytes);                /* host pointer to [va, va+bytes) when it is contiguous in host memory, else NULL */
void rc_read(uint32_t va, void *dst, size_t n);
void rc_write(uint32_t va, const void *src, size_t n);
void rc_zero(uint32_t va, size_t n);
size_t rc_cstr(uint32_t va, char *out, size_t cap);       /* NUL-terminated copy of a guest string, returns its length */
size_t rc_wstr(uint32_t va, char *out, size_t cap);       /* guest UTF-16 string narrowed to Latin-1 */
void rc_put_cstr(uint32_t va, const char *s);
#define rc_u32(va) rc_rd((va), 4)
#define rc_u16(va) rc_rd((va), 2)
#define rc_w32(va, v) rc_wr((va), 4, (v))
#define rc_w16(va, v) rc_wr((va), 2, (v))

/* ---- the machine ---- */
typedef int (*RcApiFn)(Fl41Regs *r, const uint32_t *a, uint32_t *ret);   /* 0: returned; nonzero: the run is over (never returns) */

typedef struct RcStub {
    const char *name;
    const char *dll;
    RcApiFn fn;
    uint32_t cleanup;              /* stdcall bytes the stub pops */
    uint32_t calls;
} RcStub;

void rc_core_init(void);
void rc_register(uint32_t va, void (*fn)(Fl41Regs *, const Fl41Host *));
void rc_register_all(void);                        /* generated: every lifted function */
int rc_run(uint32_t target, Fl41Regs *regs);        /* run one guest function to its return: 0 ok, 1 aborted (reason set) */
uint32_t rc_call(uint32_t target, int nargs, const uint32_t *args, uint32_t ecx);
uint32_t rc_call_from(const Fl41Regs *regs, uint32_t target, int nargs, const uint32_t *args);   /* from a hand port: nest below its esp */
int rc_call_raw(uint32_t target, int nargs, const uint32_t *args, uint32_t ecx, uint32_t *eax_out);   /* call a guest function from a shim (a window procedure, a callback) */
void rc_abort(const char *fmt, ...) __attribute__((noreturn, format(printf, 1, 2)));
const char *rc_abort_reason(void);
void rc_stats(uint64_t out[4]);
extern const Fl41Host rc_host;
uint32_t rc_stub_for(const char *name, const char *dll, RcApiFn fn, uint32_t cleanup);   /* allocate a stub address for a host-played function */
void rc_log(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
void rc_platform_log(const char *line);
void rc_thunk_add(uint32_t va, uint32_t stub_addr);
void rc_slot_add(uint32_t slot, uint32_t stub_addr);
int rc_has(uint32_t va);
void rc_set_import_budget(uint64_t n);
void rc_heap_note(uint32_t p, uint32_t size);
int rc_trace_enabled(void);

/* x87 stack handed to a host function that needs it (hand ports of refused bodies) */
Fl41Fpu *rc_fpu(void);

/* ---- the process: heap, handles, clocks ---- */
uint32_t rc_alloc(uint32_t size);                  /* bump allocation in the guest heap (never freed) */
uint32_t rc_heap_get(uint32_t size, int zero);
void rc_heap_put(uint32_t p);
uint32_t rc_heap_size(uint32_t p);
uint32_t rc_handle_new(int kind, void *obj);
void *rc_handle_obj(uint32_t h, int kind);
int rc_handle_kind(uint32_t h);
void rc_handle_close(uint32_t h);
enum { RC_H_NONE = 0, RC_H_HEAP, RC_H_MODULE, RC_H_DC, RC_H_CURSOR, RC_H_ICON, RC_H_IMAGE, RC_H_WINDOW, RC_H_ACCEL, RC_H_DWP, RC_H_MENU,
       RC_H_KEY, RC_H_FILE, RC_H_EVENT, RC_H_FIND, RC_H_HOOK, RC_H_RES, RC_H_GDI, RC_H_SURFDC, RC_H_MAP };
uint32_t rc_guest_string(const char *s);           /* a NUL-terminated string in the guest heap */

/* time: real milliseconds when the platform has a clock, otherwise the deterministic virtual clock the Python spike used */
uint32_t rc_clock(void);                           /* milliseconds, advances with the platform clock or with explicit waits */
void rc_clock_advance(uint32_t ms);                /* virtual clock only: idle polls and timed-out waits */
int rc_clock_is_virtual(void);

/* ---- Win32 ---- */
void rc_win32_init(void);
int rc_win32_resolve(const char *dll, const char *name, RcApiFn *fn);
const char *rc_game_dir(void);
extern uint32_t rc_main_hwnd;
void rc_msg_post(uint32_t hwnd, uint32_t msg, uint32_t wp, uint32_t lp);
void rc_set_input_state(int32_t x, int32_t y, uint32_t buttons);
void rc_input_event(uint32_t kind, int32_t x, int32_t y, uint32_t buttons, uint32_t key);

/* ---- DirectX stand-ins ---- */
void rc_ddraw_init(void);
int rc_ddraw_resolve(const char *name, RcApiFn *fn);
void rc_dsound_init(void);
int rc_dsound_resolve(const char *name, RcApiFn *fn);
void rc_dsound_tick(void);                          /* signal notification events whose positions have passed */
void rc_bink_init(void);
int rc_bink_resolve(const char *name, RcApiFn *fn);
int rc_com_resolve(const char *iface, const char *method, RcApiFn *fn);

/* COM objects: the guest sees [vtable][host index]; the host keeps its state in a table */
typedef struct RcMethod { const char *name; int nargs; RcApiFn fn; } RcMethod;
uint32_t rc_com_vtable(const char *iface, const RcMethod *methods, int count);
uint32_t rc_com_new(const char *iface, const RcMethod *methods, int count, void *obj);
void *rc_com_obj(uint32_t this_);

/* hand ports of the bodies the lifter refused */
void rc_unlifted_register(void);

#ifdef __cplusplus
}
#endif
#endif
