/* Spike host for the lifted GAME.EXE: a flat 32-bit address space in host memory, a call dispatcher over the lifted
 * functions, and a Python fallback for imports and the few functions the lifter refused. Built as a shared library and
 * driven from driver.py through ctypes. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <setjmp.h>
#include "original_methods_fl41.h"

#define PAGE 4096u
#define NPAGES (1u << 20)
#define IMAGE_BASE 0x400000u
#define TABLE_SIZE 0x300000u            /* covers 0x400000 .. 0x700000 */

static uint8_t *pages[NPAGES];
typedef void (*lifted_fn)(Fl41Regs *, const Fl41Host *);
static lifted_fn table[TABLE_SIZE];

/* python callbacks */
typedef int (*fallback_fn)(uint32_t target, Fl41Regs *regs);     /* 0: handled and returned, -1: never returns */
typedef int (*fault_fn)(uint32_t address, int bytes, int write);  /* 1: page now mapped, retry; 0: give up */
typedef void (*trace_fn)(uint32_t target, int enter);
static fallback_fn py_fallback;
static fault_fn py_fault;
static trace_fn py_trace;

static Fl41Fpu fpu;
static uint64_t fret_last;
static jmp_buf *abort_env;
static char abort_reason[320];
static int depth;
static uint64_t calls_native, calls_fallback, reads, writes;

static uint32_t cstack[4096];

static void host_abort(const char *why)
{
    if (why != abort_reason) snprintf(abort_reason, sizeof abort_reason, "%s", why);
    /* the innermost native frames, for the post-mortem */
    size_t n = strlen(abort_reason);
    for (int i = depth; i > 0 && i > depth - 8 && n + 12 < sizeof abort_reason; i--)
        n += (size_t)snprintf(abort_reason + n, sizeof abort_reason - n, " <%x", cstack[i & 4095]);
    if (abort_env) longjmp(*abort_env, 1);
    fprintf(stderr, "host abort outside a run: %s\n", why);
    exit(3);
}

int host_map(uint32_t va, uint32_t size, void *mem)
{
    if (va & (PAGE - 1)) return -1;
    uint8_t *p = (uint8_t *)mem;
    for (uint32_t off = 0; off < size; off += PAGE) {
        uint32_t idx = (va + off) >> 12;
        if (idx >= NPAGES) return -1;
        pages[idx] = p + off;
    }
    return 0;
}

int host_is_mapped(uint32_t va) { return pages[va >> 12] != NULL; }

static uint8_t *ptr(uint32_t a, int bytes, int write)
{
    for (;;) {
        uint8_t *p = pages[a >> 12];
        if (p && ((a & (PAGE - 1)) + (uint32_t)bytes <= PAGE)) return p + (a & (PAGE - 1));
        if (p) return NULL;                                   /* straddles a page: slow path */
        if (!py_fault || !py_fault(a, bytes, write)) {
            char buf[96];
            snprintf(buf, sizeof buf, "%s of %d bytes at unmapped 0x%08x", write ? "write" : "read", bytes, a);
            host_abort(buf);
        }
    }
}

uint32_t host_rd(void *ctx, uint32_t a, int bytes)
{
    (void)ctx;
    reads++;
    uint8_t *p = ptr(a, bytes, 0);
    uint32_t v = 0;
    if (p) {
        memcpy(&v, p, (size_t)bytes);          /* little-endian host */
        return v;
    }
    for (int i = 0; i < bytes; i++) v |= (uint32_t)*ptr(a + (uint32_t)i, 1, 0) << (8 * i);
    return v;
}

void host_wr(void *ctx, uint32_t a, int bytes, uint32_t v)
{
    (void)ctx;
    writes++;
    { static int w = -1; static uint32_t wa; if (w < 0) { const char *e = getenv("WATCH_ADDR"); w = e != NULL; if (e) wa = (uint32_t)strtoul(e, NULL, 16); }
      if (w && a <= wa && wa < a + (uint32_t)bytes) fprintf(stderr, "WRITE %x bytes %d val %x in %x <%x <%x\n", a, bytes, v, cstack[depth & 4095], cstack[(depth - 1) & 4095], cstack[(depth - 2) & 4095]); }
    uint8_t *p = ptr(a, bytes, 1);
    if (p) { memcpy(p, &v, (size_t)bytes); return; }
    for (int i = 0; i < bytes; i++) *ptr(a + (uint32_t)i, 1, 1) = (uint8_t)(v >> (8 * i));
}

static uint64_t host_fret(void *ctx) { (void)ctx; return fret_last; }

static void capture_fret(void)
{
    /* the value the callee left in st(0), as the bits of a double; 0 when the callee left the stack empty */
    unsigned top = FL41_FTOP(&fpu);
    if (fpu.valid[top]) {
        double d = (double)fpu.st[top];
        memcpy(&fret_last, &d, 8);
    } else {
        fret_last = 0;
    }
}

static const Fl41Host host;

void host_call(void *ctx, uint32_t target, Fl41Regs *regs)
{
    (void)ctx;
    lifted_fn fn = NULL;
    if (target - IMAGE_BASE < TABLE_SIZE) fn = table[target - IMAGE_BASE];
    if (depth > 4000) host_abort("call depth over 4000");
    if (target == 0xffffffffu) fprintf(stderr, "TRAP eax=%x ecx=%x edx=%x ebx=%x esi=%x edi=%x ebp=%x esp=%x\n", regs->eax, regs->ecx, regs->edx, regs->ebx, regs->esi, regs->edi, regs->ebp, regs->esp);
    depth++;
    cstack[depth & 4095] = target;
    { static int w = -1; static uint32_t wva; if (w < 0) { const char *e = getenv("WATCH_VA"); w = e != NULL; if (e) wva = (uint32_t)strtoul(e, NULL, 16); }
      if (w && target == wva) { uint32_t e = regs->esp; fprintf(stderr, "WATCH %x in st0=%Lg st1=%Lg top=%u esp=%x args %x %x %x %x ret %x\n", target, FL41_FST(&fpu, 0), FL41_FST(&fpu, 1), FL41_FTOP(&fpu), e, host_rd(NULL, e + 4, 4), host_rd(NULL, e + 8, 4), host_rd(NULL, e + 12, 4), host_rd(NULL, e + 16, 4), host_rd(NULL, e, 4)); } }
    if (fn) {
        calls_native++;
        if (py_trace) py_trace(target, 1);
        /* the callee starts on the caller's x87 stack (`__ftol` and friends consume the caller's st(0)); the caller's own state comes back below */
        fn(regs, &host);
        capture_fret();
        { static int w2 = -1; static uint32_t wv; if (w2 < 0) { const char *e = getenv("WATCH_EAX"); w2 = e != NULL; if (e) wv = (uint32_t)strtoul(e, NULL, 16); }
          if (w2 && regs->eax == wv) fprintf(stderr, "EAX %x returned by %x\n", wv, target); }
        { static int w = -1; static uint32_t wva; if (w < 0) { const char *e = getenv("WATCH_VA"); w = e != NULL; if (e) wva = (uint32_t)strtoul(e, NULL, 16); }
          if (w && target == wva) fprintf(stderr, "WATCH %x returns eax=%x st0=%Lg valid=%d top=%u\n", target, regs->eax, FL41_FST(&fpu, 0), fpu.valid[FL41_FTOP(&fpu)], FL41_FTOP(&fpu)); }
        if (py_trace) py_trace(target, 0);
    } else {
        calls_fallback++;
        int r = py_fallback ? py_fallback(target, regs) : -2;
        if (r == -1) regs->esp = 0xfffffff0u;
        else if (r == -2) host_abort("no fallback");
        else if (r < 0) host_abort(abort_reason[0] ? abort_reason : "fallback failed");
    }
    depth--;
}

static const Fl41Host host = { NULL, host_rd, host_wr, host_call, host_fret, &fpu };

/* a tail jump: the same as a call for the host (the target runs on the stack as it is, its return is the jumper's return) */
void host_tailjump(uint32_t target, Fl41Regs *regs) { host_call(NULL, target, regs); }

void host_init(fallback_fn fb, fault_fn ft, trace_fn tr)
{
    py_fallback = fb; py_fault = ft; py_trace = tr;
    memset(&fpu, 0, sizeof fpu);
    fpu.cw = FL41_FCW_WIN32;
}

/* the host x87 stack as bytes (sw, cw, valid[8], then eight 16-byte long doubles) so the Python side can hand it to the emulator and take it back */
void host_fpu_get(uint8_t *out) { memcpy(out, &fpu.sw, 2); memcpy(out + 2, &fpu.cw, 2); memcpy(out + 4, fpu.valid, 8); memcpy(out + 12, fpu.st, sizeof fpu.st); }
void host_fpu_set(const uint8_t *in) { memcpy(&fpu.sw, in, 2); memcpy(&fpu.cw, in + 2, 2); memcpy(fpu.valid, in + 4, 8); memcpy(fpu.st, in + 12, sizeof fpu.st); }
void host_set_abort(const char *why) { snprintf(abort_reason, sizeof abort_reason, "%s", why); }
const char *host_abort_reason(void) { return abort_reason; }
void host_register(uint32_t va, lifted_fn fn) { if (va - IMAGE_BASE < TABLE_SIZE) table[va - IMAGE_BASE] = fn; }
int host_has(uint32_t va) { return va - IMAGE_BASE < TABLE_SIZE && table[va - IMAGE_BASE] != NULL; }
void host_stats(uint64_t *out) { out[0] = calls_native; out[1] = calls_fallback; out[2] = reads; out[3] = writes; }
int host_depth(void) { return depth; }

/* Run one function (the entry point, a window procedure, a callback) from Python: returns 0, or 1 with the abort reason set. */
int host_run(uint32_t target, Fl41Regs *regs)
{
    jmp_buf env, *outer = abort_env;
    int saved_depth = depth;
    abort_env = &env;
    abort_reason[0] = 0;
    if (setjmp(env)) { abort_env = outer; depth = saved_depth; return 1; }
    host_call(NULL, target, regs);
    abort_env = outer;
    return 0;
}

