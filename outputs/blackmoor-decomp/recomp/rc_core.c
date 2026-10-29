/* The machine: guest address space, call dispatcher over the lifted functions, host stubs for imports and COM methods, guest heap, handles, clock. */
#define _GNU_SOURCE
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <setjmp.h>
#include <sys/mman.h>
#include "rc.h"
#include "rc_internal.h"

#define TABLE_SIZE 0x300000u           /* lifted functions cover 0x400000 .. 0x700000 */
#define MAX_STUBS 8192u

uint8_t *rc_pages[RC_NPAGES];
typedef void (*lifted_fn)(Fl41Regs *, const Fl41Host *);
static lifted_fn table[TABLE_SIZE];

static RcStub stubs[MAX_STUBS];
static uint32_t stub_count;
typedef struct Thunk { uint32_t va, stub; } Thunk;
static Thunk *thunks;
static size_t thunk_count, thunk_cap;

static Fl41Fpu fpu;
static uint64_t fret_last;
static jmp_buf *abort_env;
static char abort_reason[512];
static int depth;
static uint64_t calls_native, calls_fallback;
static uint32_t cstack[4096];

/* ------------------------------------------------------------------ log */
void rc_log(const char *fmt, ...)
{
    char line[1024];
    va_list ap;
    va_start(ap, fmt);
    vsnprintf(line, sizeof line, fmt, ap);
    va_end(ap);
    rc_platform_log(line);
}

/* ------------------------------------------------------------------ abort */
const char *rc_abort_reason(void) { return abort_reason; }

void rc_abort(const char *fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
    vsnprintf(abort_reason, sizeof abort_reason, fmt, ap);
    va_end(ap);
    size_t n = strlen(abort_reason);
    /* the innermost native frames, for the post-mortem */
    for (int i = depth; i > 0 && i > depth - 8 && n + 12 < sizeof abort_reason; i--)
        n += (size_t)snprintf(abort_reason + n, sizeof abort_reason - n, " <%x", cstack[i & 4095]);
    if (abort_env) longjmp(*abort_env, 1);
    fprintf(stderr, "host abort outside a run: %s\n", abort_reason);
    exit(3);
}

/* ------------------------------------------------------------------ memory */
int rc_map(uint32_t va, uint32_t size, void *mem)
{
    if (va & (RC_PAGE - 1u)) return -1;
    uint8_t *p = (uint8_t *)mem;
    for (uint32_t off = 0; off < size; off += RC_PAGE) {
        uint32_t idx = (va + off) >> 12;
        if (idx >= RC_NPAGES) return -1;
        rc_pages[idx] = p + off;
    }
    return 0;
}

void *rc_map_new(uint32_t va, uint32_t size)
{
    size = (size + RC_PAGE - 1u) & ~(RC_PAGE - 1u);
    for (uint32_t off = 0; off < size; off += RC_PAGE)
        if (rc_pages[(va + off) >> 12]) return NULL;
    void *m = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANON | MAP_NORESERVE, -1, 0);
    if (m == MAP_FAILED) return NULL;
    if (rc_map(va, size, m)) { munmap(m, size); return NULL; }
    return m;
}

int rc_is_mapped(uint32_t va) { return rc_pages[va >> 12] != NULL; }

static int on_demand_pages;

/* An access to an unmapped page: the game's CRT and string routines read a few bytes past a block now and then; map a page there once
 * (a bounded number of times) instead of stopping, as the Python spike did. */
static int fault(uint32_t a, int bytes, int write)
{
    (void)bytes;
    if (a >= 0xfff00000u || on_demand_pages > 64) return 0;
    uint32_t page = a & ~(RC_PAGE - 1u);
    if (!rc_map_new(page, RC_PAGE)) return 0;
    on_demand_pages++;
    if (on_demand_pages <= 20) rc_log("on-demand page 0x%08x (%s %d)", page, write ? "write" : "read", bytes);
    return 1;
}

static uint8_t *slow_ptr(uint32_t a, int write)
{
    for (;;) {
        uint8_t *p = rc_pages[a >> 12];
        if (p) return p + (a & (RC_PAGE - 1u));
        if (!fault(a, 1, write)) rc_abort("%s at unmapped 0x%08x", write ? "write" : "read", a);
    }
}

uint32_t rc_rd_slow(uint32_t a, int bytes)
{
    uint32_t v = 0;
    for (int i = 0; i < bytes; i++) v |= (uint32_t)*slow_ptr(a + (uint32_t)i, 0) << (8 * i);
    return v;
}

void rc_wr_slow(uint32_t a, int bytes, uint32_t v)
{
    for (int i = 0; i < bytes; i++) *slow_ptr(a + (uint32_t)i, 1) = (uint8_t)(v >> (8 * i));
}

void *rc_ptr(uint32_t va, uint32_t bytes)
{
    if (!bytes) bytes = 1;
    uint8_t *p = rc_pages[va >> 12];
    if (!p) return NULL;
    uint32_t last = (va + bytes - 1u) >> 12;
    for (uint32_t pg = (va >> 12) + 1u; pg <= last; pg++)
        if (rc_pages[pg] != rc_pages[pg - 1u] + RC_PAGE) return NULL;
    return p + (va & (RC_PAGE - 1u));
}

void rc_read(uint32_t va, void *dst, size_t n)
{
    uint8_t *d = (uint8_t *)dst;
    while (n) {
        uint8_t *p = slow_ptr(va, 0);
        size_t chunk = RC_PAGE - (va & (RC_PAGE - 1u));
        if (chunk > n) chunk = n;
        memcpy(d, p, chunk);
        d += chunk; va += (uint32_t)chunk; n -= chunk;
    }
}

void rc_write(uint32_t va, const void *src, size_t n)
{
    const uint8_t *s = (const uint8_t *)src;
    while (n) {
        uint8_t *p = slow_ptr(va, 1);
        size_t chunk = RC_PAGE - (va & (RC_PAGE - 1u));
        if (chunk > n) chunk = n;
        memcpy(p, s, chunk);
        s += chunk; va += (uint32_t)chunk; n -= chunk;
    }
}

void rc_zero(uint32_t va, size_t n)
{
    while (n) {
        uint8_t *p = slow_ptr(va, 1);
        size_t chunk = RC_PAGE - (va & (RC_PAGE - 1u));
        if (chunk > n) chunk = n;
        memset(p, 0, chunk);
        va += (uint32_t)chunk; n -= chunk;
    }
}

size_t rc_cstr(uint32_t va, char *out, size_t cap)
{
    size_t n = 0;
    if (!cap) return 0;
    while (n + 1 < cap) {
        uint8_t c = *slow_ptr(va + (uint32_t)n, 0);
        if (!c) break;
        out[n++] = (char)c;
    }
    out[n] = 0;
    return n;
}

size_t rc_wstr(uint32_t va, char *out, size_t cap)
{
    size_t n = 0;
    if (!cap) return 0;
    while (n + 1 < cap) {
        uint32_t c = rc_u16(va + 2u * (uint32_t)n);
        if (!c) break;
        out[n++] = (char)(c > 255u ? '?' : c);
    }
    out[n] = 0;
    return n;
}

void rc_put_cstr(uint32_t va, const char *s) { rc_write(va, s, strlen(s) + 1u); }

/* ------------------------------------------------------------------ host stubs */
uint32_t rc_stub_for(const char *name, const char *dll, RcApiFn fn, uint32_t cleanup)
{
    if (stub_count >= MAX_STUBS) rc_abort("out of host stubs");
    stubs[stub_count] = (RcStub){name, dll, fn, cleanup, 0};
    return RC_MAGIC + 0x10u * (++stub_count);
}

void rc_thunk_add(uint32_t va, uint32_t stub_addr)
{
    if (thunk_count == thunk_cap) {
        thunk_cap = thunk_cap ? thunk_cap * 2 : 64;
        thunks = (Thunk *)realloc(thunks, thunk_cap * sizeof *thunks);
    }
    thunks[thunk_count++] = (Thunk){va, stub_addr};
}

static RcStub *stub_at(uint32_t target)
{
    if (target <= RC_MAGIC || target > RC_MAGIC + 0x10u * stub_count || (target & 15u)) return NULL;
    return &stubs[(target - RC_MAGIC) / 0x10u - 1u];
}

/* import address table slots: a lifted `call dword ptr [slot]` reaches the host with the slot's address as the target */
static uint32_t slot_stub[TABLE_SIZE / 4];

void rc_slot_add(uint32_t slot, uint32_t stub_addr)
{
    if (slot - RC_IMAGE_BASE < TABLE_SIZE && !(slot & 3u)) slot_stub[(slot - RC_IMAGE_BASE) / 4u] = stub_addr;
}

static RcStub *slot_at(uint32_t target)
{
    if (target - RC_IMAGE_BASE >= TABLE_SIZE || (target & 3u)) return NULL;
    uint32_t s = slot_stub[(target - RC_IMAGE_BASE) / 4u];
    return s ? stub_at(s) : NULL;
}

static RcStub *thunk_at(uint32_t target)
{
    for (size_t i = 0; i < thunk_count; i++)
        if (thunks[i].va == target) return stub_at(thunks[i].stub);
    return NULL;
}

/* ------------------------------------------------------------------ dispatcher */
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

static uint32_t host_rd(void *ctx, uint32_t a, int bytes) { (void)ctx; return rc_rd(a, bytes); }
static void host_wr(void *ctx, uint32_t a, int bytes, uint32_t v) { (void)ctx; rc_wr(a, bytes, v); }

static uint64_t imports_called;
static uint64_t import_budget = UINT64_MAX;
void rc_set_import_budget(uint64_t n) { import_budget = n; }

int rc_unimpl_api(Fl41Regs *r, const uint32_t *a, uint32_t *ret) { (void)r; (void)a; *ret = 0; return 0; }

static uint32_t live_esp;          /* esp of the innermost host function being played (0 outside one): nested guest calls run below it */

static void call_stub(RcStub *s, Fl41Regs *regs)
{
    uint32_t a[13];
    for (int i = 0; i < 13; i++) a[i] = rc_rd(regs->esp + 4u + 4u * (uint32_t)i, 4);
    if (++imports_called > import_budget) rc_abort("import budget exhausted");
    s->calls++;
    if (s->calls <= 5) {
        char args[160] = "";
        size_t n = 0;
        uint32_t cnt = s->cleanup / 4u;
        for (uint32_t i = 0; i < cnt && i < 13 && n + 14 < sizeof args; i++) n += (size_t)snprintf(args + n, sizeof args - n, "%s0x%x", i ? "," : "", a[i]);
        if (s->fn == rc_unimpl_api) { if (s->calls <= 3) rc_log("IMPORT %s!%s(%s) -> unimplemented, returns 0", s->dll, s->name, args); }
        else rc_log("IMPORT %s!%s(%s)", s->dll, s->name, args);
    }
    uint32_t ret = 0, saved_live = live_esp;
    live_esp = regs->esp;
    int never = s->fn(regs, a, &ret);
    live_esp = saved_live;
    if (never) { regs->esp = 0xfffffff0u; return; }                     /* a call that never returns */
    regs->eax = ret;
}

static void host_call(void *ctx, uint32_t target, Fl41Regs *regs)
{
    (void)ctx;
    lifted_fn fn = NULL;
    if (target - RC_IMAGE_BASE < TABLE_SIZE) fn = table[target - RC_IMAGE_BASE];
    if (depth > 4000) rc_abort("call depth over 4000");
    depth++;
    cstack[depth & 4095] = target;
    if (fn) {
        calls_native++;
        /* the callee starts on the caller's x87 stack (`__ftol` and friends consume the caller's st(0)) */
        fn(regs, &rc_host);
        capture_fret();
    } else {
        calls_fallback++;
        RcStub *s = stub_at(target);
        if (!s) s = slot_at(target);
        if (!s) s = thunk_at(target);
        if (s) call_stub(s, regs);
        else if (target == 0xffffffffu) rc_abort("divide error / trap in lifted code");
        else if (target >= RC_IMAGE_BASE && target < 0x700000u) rc_abort("call to 0x%08x: not lifted and no host port", target);
        else rc_abort("call to 0x%08x: not lifted, not an import, not in the image", target);
    }
    depth--;
}

const Fl41Host rc_host = { NULL, host_rd, host_wr, host_call, host_fret, &fpu };

/* a tail jump: the same as a call for the host (the target runs on the stack as it is, its return is the jumper's return) */
void host_tailjump(uint32_t target, Fl41Regs *regs) { host_call(NULL, target, regs); }

Fl41Fpu *rc_fpu(void) { return &fpu; }

void rc_register(uint32_t va, lifted_fn fn) { if (va - RC_IMAGE_BASE < TABLE_SIZE) table[va - RC_IMAGE_BASE] = fn; }
int rc_has(uint32_t va) { return va - RC_IMAGE_BASE < TABLE_SIZE && table[va - RC_IMAGE_BASE] != NULL; }

void rc_stats(uint64_t out[4]) { out[0] = calls_native; out[1] = calls_fallback; out[2] = imports_called; out[3] = (uint64_t)on_demand_pages; }

int rc_run(uint32_t target, Fl41Regs *regs)
{
    jmp_buf env, *outer = abort_env;
    int saved_depth = depth;
    uint32_t saved_live = live_esp;
    abort_env = &env;
    abort_reason[0] = 0;
    if (setjmp(env)) { abort_env = outer; depth = saved_depth; live_esp = saved_live; return 1; }
    host_call(NULL, target, regs);
    abort_env = outer;
    return 0;
}

/* run a guest function and report how it ended instead of unwinding: the outermost caller (rc_main) uses this */
int rc_call_raw(uint32_t target, int nargs, const uint32_t *args, uint32_t ecx, uint32_t *eax_out)
{
    Fl41Regs r;
    memset(&r, 0, sizeof r);
    /* below the guest stack as it stands: the esp of the host function that is calling, or the top of the stack for the outermost call */
    uint32_t sp = live_esp ? ((live_esp - 0x100u) & ~15u) : RC_STACK_BASE + RC_STACK_SIZE - 0x1000u;
    sp -= 4u * (uint32_t)(nargs + 1);
    rc_w32(sp, RC_STOP);
    for (int i = 0; i < nargs; i++) rc_w32(sp + 4u + 4u * (uint32_t)i, args[i]);
    r.esp = sp; r.ecx = ecx;
    uint32_t saved_live = live_esp;
    live_esp = 0;
    int rc = rc_run(target, &r);
    live_esp = saved_live;
    if (eax_out) *eax_out = r.eax;
    return rc;
}

uint32_t rc_call_from(const Fl41Regs *regs, uint32_t target, int nargs, const uint32_t *args)
{
    uint32_t saved = live_esp;
    live_esp = regs->esp;
    uint32_t eax = rc_call(target, nargs, args, 0);
    live_esp = saved;
    return eax;
}

uint32_t rc_call(uint32_t target, int nargs, const uint32_t *args, uint32_t ecx)
{
    uint32_t eax = 0;
    if (rc_call_raw(target, nargs, args, ecx, &eax)) {
        /* unwind the whole chain of nested runs: the reason stays set */
        char why[512];
        snprintf(why, sizeof why, "%s", abort_reason);
        rc_abort("%s", why);
    }
    return eax;
}

/* ------------------------------------------------------------------ guest heap */
static uint32_t heap_next = RC_HEAP_BASE + 0x1000u;

uint32_t rc_alloc(uint32_t size)
{
    size = (size + 15u) & ~15u;
    uint32_t p = heap_next;
    if ((uint64_t)heap_next + size > (uint64_t)RC_HEAP_BASE + RC_HEAP_SIZE) rc_abort("heap exhausted");
    heap_next += size;
    return p;
}

/* freed blocks wait on a LIFO list per rounded size, as the Python spike's did; the size of each live block sits in a host hash table */
typedef struct SizeEnt { uint32_t p, size; } SizeEnt;
static SizeEnt *sizes;
static uint32_t size_cap, size_used;
typedef struct FreeCls { uint32_t rounded, head; } FreeCls;
static FreeCls *classes;
static uint32_t class_cap, class_used;

static uint32_t hash32(uint32_t x) { x ^= x >> 16; x *= 0x7feb352du; x ^= x >> 15; x *= 0x846ca68bu; x ^= x >> 16; return x; }

static SizeEnt *size_find(uint32_t p, int create)
{
    if (!size_cap) {
        size_cap = 1u << 16;
        sizes = (SizeEnt *)calloc(size_cap, sizeof *sizes);
    }
    if (create && size_used * 2 >= size_cap) {
        SizeEnt *old = sizes; uint32_t oc = size_cap;
        size_cap *= 2; sizes = (SizeEnt *)calloc(size_cap, sizeof *sizes); size_used = 0;
        for (uint32_t i = 0; i < oc; i++)
            if (old[i].p && old[i].p != 1) { SizeEnt *e = size_find(old[i].p, 1); e->size = old[i].size; }
        free(old);
    }
    uint32_t i = hash32(p) & (size_cap - 1u);
    SizeEnt *tomb = NULL;
    for (;;) {
        SizeEnt *e = &sizes[i];
        if (e->p == p) return e;
        if (e->p == 1 && !tomb) tomb = e;                  /* 1 marks a removed entry (no block lives at 1) */
        if (e->p == 0) {
            if (!create) return NULL;
            if (tomb) e = tomb; else size_used++;
            e->p = p;
            return e;
        }
        i = (i + 1u) & (size_cap - 1u);
    }
}

static FreeCls *class_find(uint32_t rounded)
{
    if (!class_cap) { class_cap = 1024; classes = (FreeCls *)calloc(class_cap, sizeof *classes); }
    if (class_used * 2 >= class_cap) {
        FreeCls *old = classes; uint32_t oc = class_cap;
        class_cap *= 2; classes = (FreeCls *)calloc(class_cap, sizeof *classes); class_used = 0;
        for (uint32_t i = 0; i < oc; i++)
            if (old[i].rounded) { FreeCls *c = class_find(old[i].rounded); c->head = old[i].head; }
        free(old);
    }
    uint32_t i = hash32(rounded) & (class_cap - 1u);
    for (;;) {
        FreeCls *c = &classes[i];
        if (c->rounded == rounded) return c;
        if (!c->rounded) { c->rounded = rounded; class_used++; return c; }
        i = (i + 1u) & (class_cap - 1u);
    }
}

uint32_t rc_heap_get(uint32_t size, int zero)
{
    uint32_t rounded = (size ? size + 15u : 16u) & ~15u;
    FreeCls *c = class_find(rounded);
    uint32_t p;
    if (c->head) {
        p = c->head;
        c->head = rc_u32(p);
        if (zero) rc_zero(p, rounded); else rc_w32(p, 0);
    } else {
        p = rc_alloc(rounded);
    }
    size_find(p, 1)->size = size;
    return p;
}

void rc_heap_put(uint32_t p)
{
    SizeEnt *e = size_find(p, 0);
    if (!e) return;
    uint32_t size = e->size, rounded = (size ? size + 15u : 16u) & ~15u;
    e->p = 1;
    FreeCls *c = class_find(rounded);
    rc_w32(p, c->head);
    c->head = p;
}

uint32_t rc_heap_size(uint32_t p)
{
    SizeEnt *e = size_find(p, 0);
    return e ? e->size : 0;
}

void rc_heap_note(uint32_t p, uint32_t size) { size_find(p, 1)->size = size; }

/* ------------------------------------------------------------------ handles */
typedef struct Handle { int kind; void *obj; } Handle;
static Handle *handles;
static uint32_t handle_count, handle_cap;

uint32_t rc_handle_new(int kind, void *obj)
{
    if (handle_count == handle_cap) {
        handle_cap = handle_cap ? handle_cap * 2 : 256;
        handles = (Handle *)realloc(handles, handle_cap * sizeof *handles);
    }
    handles[handle_count] = (Handle){kind, obj};
    return 0x100u + 4u * handle_count++;
}

static Handle *handle_at(uint32_t h)
{
    if (h < 0x100u || (h & 3u)) return NULL;
    uint32_t i = (h - 0x100u) / 4u;
    return i < handle_count ? &handles[i] : NULL;
}

void *rc_handle_obj(uint32_t h, int kind)
{
    Handle *e = handle_at(h);
    return e && e->kind == kind ? e->obj : NULL;
}

int rc_handle_kind(uint32_t h) { Handle *e = handle_at(h); return e ? e->kind : RC_H_NONE; }

void rc_handle_close(uint32_t h) { Handle *e = handle_at(h); if (e) { e->kind = RC_H_NONE; e->obj = NULL; } }

uint32_t rc_guest_string(const char *s)
{
    uint32_t p = rc_alloc((uint32_t)strlen(s) + 1u);
    rc_put_cstr(p, s);
    return p;
}

/* ------------------------------------------------------------------ COM objects */
typedef struct ComClass { const char *iface; uint32_t vtable; } ComClass;
static ComClass com_classes[32];
static int com_class_count;
static void **com_objs;
static uint32_t com_obj_count, com_obj_cap;

uint32_t rc_com_vtable(const char *iface, const RcMethod *methods, int count)
{
    for (int i = 0; i < com_class_count; i++)
        if (!strcmp(com_classes[i].iface, iface)) return com_classes[i].vtable;
    uint32_t vt = rc_alloc(4u * (uint32_t)count);
    for (int i = 0; i < count; i++) {
        char *full = (char *)malloc(strlen(iface) + strlen(methods[i].name) + 2u);
        sprintf(full, "%s_%s", iface, methods[i].name);
        rc_w32(vt + 4u * (uint32_t)i, rc_stub_for(full, "COM", methods[i].fn ? methods[i].fn : rc_unimpl_api, 4u * (uint32_t)(methods[i].nargs + 1)));
    }
    com_classes[com_class_count++] = (ComClass){iface, vt};
    return vt;
}

uint32_t rc_com_new(const char *iface, const RcMethod *methods, int count, void *obj)
{
    uint32_t p = rc_alloc(0x40u);
    rc_w32(p, rc_com_vtable(iface, methods, count));
    if (com_obj_count == com_obj_cap) {
        com_obj_cap = com_obj_cap ? com_obj_cap * 2 : 256;
        com_objs = (void **)realloc(com_objs, com_obj_cap * sizeof *com_objs);
    }
    com_objs[com_obj_count] = obj;
    rc_w32(p + 4u, com_obj_count++);
    return p;
}

void *rc_com_obj(uint32_t this_)
{
    if (!rc_is_mapped(this_)) return NULL;
    uint32_t i = rc_u32(this_ + 4u);
    return i < com_obj_count ? com_objs[i] : NULL;
}

/* ------------------------------------------------------------------ init */
void rc_core_init(void)
{
    memset(&fpu, 0, sizeof fpu);
    fpu.cw = FL41_FCW_WIN32;
    rc_map_new(RC_STACK_BASE, RC_STACK_SIZE);
    rc_map_new(RC_TIB, RC_PAGE);
    rc_map_new(RC_HEAP_BASE, RC_HEAP_SIZE);
    rc_map_new(RC_SURF_BASE, RC_SURF_SIZE);
    rc_map_new(RC_STOP, RC_PAGE);
    rc_w32(RC_TIB + 0x00, 0xffffffffu);              /* SEH chain end */
    rc_w32(RC_TIB + 0x04, RC_STACK_BASE + RC_STACK_SIZE);
    rc_w32(RC_TIB + 0x08, RC_STACK_BASE);
    rc_w32(RC_TIB + 0x18, RC_TIB);                   /* self */
    rc_w32(RC_TIB + 0x20, 0x1234u);                  /* pid */
    rc_w32(RC_TIB + 0x24, 0x5678u);                  /* tid */
    rc_w32(RC_TIB + 0x30, RC_TIB + 0x800u);          /* PEB (fake, inside the page) */
}
