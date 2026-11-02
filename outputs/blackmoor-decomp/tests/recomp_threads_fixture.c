/* Guest-thread integration fixtures. These are small lifted-style callbacks,
 * not translated game code; all imports and scheduling use the actual host. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "rc_internal.h"

#define CHECK(expression) do { \
    if (!(expression)) { \
        fprintf(stderr, "%s:%d: CHECK(%s) failed\n", __FILE__, __LINE__, #expression); \
        exit(1); \
    } \
} while (0)

#define INFINITE 0xffffffffu
#define WAIT_TIMEOUT 258u
#define STILL_ACTIVE 259u
#define CREATE_SUSPENDED 4u
#define PARENT_VA 0x600000u
#define WORKER_VA 0x600100u
#define OTHER_VA 0x600200u
#define LEAF_VA 0x600300u

enum Import {
    CREATE_THREAD, RESUME_THREAD, SUSPEND_THREAD, THREAD_ID, EXIT_CODE,
    EXIT_THREAD, CLOSE_HANDLE, CREATE_EVENT, SET_EVENT, WAIT_ONE, WAIT_MANY,
    SLEEP, TLS_ALLOC, TLS_SET, TLS_GET, TLS_FREE, SET_ERROR, GET_ERROR,
    INIT_CS, ENTER_CS, LEAVE_CS, DELETE_CS, IMPORT_COUNT
};

static struct {
    const char *name;
    int nargs;
    uint32_t address;
} imports[IMPORT_COUNT] = {
    {"CreateThread", 6, 0}, {"ResumeThread", 1, 0}, {"SuspendThread", 1, 0},
    {"GetCurrentThreadId", 0, 0}, {"GetExitCodeThread", 2, 0},
    {"ExitThread", 1, 0}, {"CloseHandle", 1, 0}, {"CreateEventA", 4, 0},
    {"SetEvent", 1, 0}, {"WaitForSingleObject", 2, 0},
    {"WaitForMultipleObjects", 4, 0}, {"Sleep", 1, 0},
    {"TlsAlloc", 0, 0}, {"TlsSetValue", 2, 0}, {"TlsGetValue", 1, 0},
    {"TlsFree", 1, 0}, {"SetLastError", 1, 0}, {"GetLastError", 0, 0},
    {"InitializeCriticalSection", 1, 0}, {"EnterCriticalSection", 1, 0},
    {"LeaveCriticalSection", 1, 0}, {"DeleteCriticalSection", 1, 0}
};

static uint32_t api(Fl41Regs *r, enum Import which, const uint32_t *args)
{
    return rc_call_from(r, imports[which].address, imports[which].nargs, args);
}

#define API0(r, name) api((r), (name), NULL)
#define API(r, name, ...) api((r), (name), (const uint32_t[]){__VA_ARGS__})

static uint32_t event(Fl41Regs *r, int manual)
{
    uint32_t h = API(r, CREATE_EVENT, 0, (uint32_t)manual, 0, 0);
    CHECK(h != 0);
    return h;
}

static uint32_t thread(Fl41Regs *r, uint32_t entry, uint32_t parameter,
                       uint32_t flags, uint32_t id_out)
{
    uint32_t h = API(r, CREATE_THREAD, 0, 0, entry, parameter, flags, id_out);
    CHECK(h != 0);
    CHECK(rc_u32(id_out) != 0);
    CHECK(rc_u32(id_out) != API0(r, THREAD_ID));
    return h;
}

static uint32_t exit_code(Fl41Regs *r, uint32_t handle)
{
    uint32_t out = r->esp + 0x20u;
    rc_w32(out, 0xdeadbeefu);
    CHECK(API(r, EXIT_CODE, handle, out) == 1);
    return rc_u32(out);
}

static void close_handle(Fl41Regs *r, uint32_t handle)
{
    CHECK(API(r, CLOSE_HANDLE, handle) == 1);
}

static void finish(Fl41Regs *r, uint32_t entry_sp, uint32_t result, int nargs)
{
    r->eax = result;
    r->esp = entry_sp + 4u * (uint32_t)(nargs + 1);
}

/* Match the CRT/MFC ready/release protocol, including the parent's second
 * suspension and a packet that ceases to exist after ready is observed. */
static uint32_t startup_id, startup_started, startup_finished;

static void startup_worker(Fl41Regs *r, const Fl41Host *h)
{
    (void)h;
    uint32_t entry_sp = r->esp, packet = rc_u32(entry_sp + 4u);
    uint32_t ready = rc_u32(packet), release = rc_u32(packet + 4u);
    uint32_t payload = rc_u32(packet + 8u);
    r->esp -= 0x200u;
    CHECK(!rc_thread_is_main());
    CHECK(rc_thread_current() != NULL);
    CHECK(API0(r, THREAD_ID) == startup_id);
    startup_started++;
    CHECK(API(r, SET_EVENT, ready) == 1);
    CHECK(API(r, WAIT_ONE, release, INFINITE) == 0);
    CHECK(payload == 0xcafed00du);
    startup_finished++;
    finish(r, entry_sp, 0, 1);
}

static void startup_parent(Fl41Regs *r, const Fl41Host *h)
{
    (void)h;
    uint32_t entry_sp = r->esp;
    r->esp -= 0x300u;
    uint32_t ready = event(r, 1), release = event(r, 1);
    uint32_t packet = r->esp + 0x80u, id_out = r->esp + 0xc0u;
    rc_w32(packet, ready);
    rc_w32(packet + 4u, release);
    rc_w32(packet + 8u, 0xcafed00du);
    uint32_t worker = thread(r, WORKER_VA, packet, CREATE_SUSPENDED, id_out);
    startup_id = rc_u32(id_out);
    CHECK(exit_code(r, worker) == STILL_ACTIVE);
    CHECK(API(r, WAIT_ONE, worker, 0) == WAIT_TIMEOUT);
    API(r, SLEEP, 0);
    CHECK(startup_started == 0);
    CHECK(API(r, SUSPEND_THREAD, worker) == 1);
    CHECK(API(r, RESUME_THREAD, worker) == 2);
    API(r, SLEEP, 0);
    CHECK(startup_started == 0);
    CHECK(API(r, RESUME_THREAD, worker) == 1);
    CHECK(API(r, WAIT_ONE, ready, INFINITE) == 0);
    CHECK(startup_started == 1 && startup_finished == 0);
    CHECK(API(r, SUSPEND_THREAD, worker) == 0);
    close_handle(r, ready);
    rc_zero(packet, 12);                  /* worker must retain its own copy */
    CHECK(API(r, SET_EVENT, release) == 1);
    API(r, SLEEP, 0);
    CHECK(startup_finished == 0);
    CHECK(exit_code(r, worker) == STILL_ACTIVE);
    CHECK(API(r, RESUME_THREAD, worker) == 1);
    CHECK(API(r, WAIT_ONE, worker, INFINITE) == 0);
    CHECK(startup_finished == 1);
    CHECK(exit_code(r, worker) == 0);
    close_handle(r, worker);
    close_handle(r, release);
    finish(r, entry_sp, 0, 0);
}

/* Different live native continuations must retain their guest stack frames,
 * TIB/SEH, TLS, last error, x87 stack/control/status and floating return value. */
static uint32_t tls_slot, isolation_release, isolation_ready[2];
static uint32_t stack_low[3], stack_high[3], stack_local[3], context_id[3];

static void fpu_leaf(Fl41Regs *r, const Fl41Host *h)
{
    uint32_t owner = rc_u32(r->esp + 4u);
    Fl41Fpu *fp = h->fpu;
    fp->cw = (uint16_t)(FL41_FCW_WIN32 | (owner << 10));
    fp->sw = (uint16_t)(((owner + 1u) << 11) | (owner + 1u));
    for (unsigned i = 0; i < 8; i++) {
        fp->st[i] = (long double)(owner * 16u + i) + 0.25L;
        fp->valid[i] = (uint8_t)((owner + i) & 1u);
    }
    fp->valid[FL41_FTOP(fp)] = 1;
    finish(r, r->esp, owner, 1);
}

static void check_fpu(const Fl41Fpu *actual, const Fl41Fpu *expected)
{
    CHECK(actual->cw == expected->cw && actual->sw == expected->sw);
    for (unsigned i = 0; i < 8; i++) {
        CHECK(actual->valid[i] == expected->valid[i]);
        CHECK(actual->st[i] == expected->st[i]);
    }
}

static void record_stack(Fl41Regs *r, uint32_t owner)
{
    stack_low[owner] = rc_u32(RC_TIB + 8u);
    stack_high[owner] = rc_u32(RC_TIB + 4u);
    stack_local[owner] = r->esp + 0x100u;
    context_id[owner] = API0(r, THREAD_ID);
    CHECK(context_id[owner] == rc_thread_id());
    CHECK(rc_u32(RC_TIB + 0x18u) == RC_TIB);
    CHECK(rc_u32(RC_TIB + 0x24u) == context_id[owner]);
    CHECK(stack_low[owner] < r->esp && r->esp < stack_high[owner]);
    CHECK(stack_local[owner] + 8u < stack_high[owner]);
    CHECK(rc_u32(RC_TIB) == 0xffffffffu);
    rc_w32(stack_local[owner], 0xffffffffu);
    rc_w32(stack_local[owner] + 4u, 0xabc00000u + owner);
    rc_w32(RC_TIB, stack_local[owner]);
    rc_w32(RC_TIB + 0x100u, 0xdef00000u + owner);
}

static void check_context(Fl41Regs *r, const Fl41Host *h, uint32_t owner,
                          const Fl41Fpu *saved_fpu, uint64_t saved_fret)
{
    CHECK(API0(r, GET_ERROR) == 0x700u + owner);
    CHECK(API(r, TLS_GET, tls_slot) == 0x900u + owner);
    CHECK(API0(r, THREAD_ID) == context_id[owner]);
    CHECK(rc_u32(RC_TIB + 4u) == stack_high[owner]);
    CHECK(rc_u32(RC_TIB + 8u) == stack_low[owner]);
    CHECK(rc_u32(RC_TIB + 0x24u) == context_id[owner]);
    CHECK(rc_u32(RC_TIB) == stack_local[owner]);
    CHECK(rc_u32(stack_local[owner]) == 0xffffffffu);
    CHECK(rc_u32(stack_local[owner] + 4u) == 0xabc00000u + owner);
    CHECK(rc_u32(RC_TIB + 0x100u) == 0xdef00000u + owner);
    check_fpu(h->fpu, saved_fpu);
    CHECK(h->fret(h->ctx) == saved_fret);
}

static void isolation_worker(Fl41Regs *r, const Fl41Host *h)
{
    uint32_t entry_sp = r->esp, owner = rc_u32(entry_sp + 4u);
    r->esp -= 0x300u;
    CHECK(owner == 1 || owner == 2);
    CHECK(h->fpu->cw == FL41_FCW_WIN32);
    for (unsigned i = 0; i < 8; i++) CHECK(h->fpu->valid[i] == 0);
    CHECK(API(r, TLS_GET, tls_slot) == 0);
    CHECK(API(r, TLS_SET, tls_slot, 0x900u + owner) == 1);
    record_stack(r, owner);
    CHECK(rc_call_from(r, LEAF_VA, 1, &owner) == owner);
    Fl41Fpu saved_fpu = *h->fpu;
    uint64_t saved_fret = h->fret(h->ctx);
    API(r, SET_ERROR, 0x700u + owner);
    CHECK(API(r, SET_EVENT, isolation_ready[owner - 1u]) == 1);
    CHECK(API(r, WAIT_ONE, isolation_release, INFINITE) == 0);
    check_context(r, h, owner, &saved_fpu, saved_fret);
    finish(r, entry_sp, owner, 1);
}

static void isolation_parent(Fl41Regs *r, const Fl41Host *h)
{
    uint32_t entry_sp = r->esp;
    r->esp -= 0x300u;
    CHECK(rc_thread_is_main());
    tls_slot = API0(r, TLS_ALLOC);
    CHECK(tls_slot != 0xffffffffu);
    CHECK(API(r, TLS_SET, tls_slot, 0x900u) == 1);
    record_stack(r, 0);
    uint32_t owner = 0;
    CHECK(rc_call_from(r, LEAF_VA, 1, &owner) == 0);
    Fl41Fpu saved_fpu = *h->fpu;
    uint64_t saved_fret = h->fret(h->ctx);
    isolation_release = event(r, 1);
    uint32_t handles = r->esp + 0x80u, ready_list = r->esp + 0x90u;
    for (unsigned i = 0; i < 2; i++) {
        isolation_ready[i] = event(r, 1);
        rc_w32(ready_list + 4u * i, isolation_ready[i]);
        rc_w32(handles + 4u * i, thread(r, WORKER_VA, i + 1u, 0, r->esp + 0xb0u + 4u * i));
    }
    API(r, SET_ERROR, 0x700u);
    CHECK(API(r, WAIT_MANY, 2, ready_list, 1, INFINITE) == 0);
    check_context(r, h, 0, &saved_fpu, saved_fret);
    for (unsigned i = 0; i < 3; i++) {
        for (unsigned j = i + 1; j < 3; j++) {
            CHECK(context_id[i] != context_id[j]);
            CHECK(stack_high[i] <= stack_low[j] || stack_high[j] <= stack_low[i]);
        }
        CHECK(rc_u32(stack_local[i] + 4u) == 0xabc00000u + i);
    }
    CHECK(API(r, SET_EVENT, isolation_release) == 1);
    CHECK(API(r, WAIT_MANY, 2, handles, 1, INFINITE) == 0);
    API(r, SET_ERROR, 0x700u);        /* TlsGetValue above cleared last error */
    check_context(r, h, 0, &saved_fpu, saved_fret);
    for (unsigned i = 0; i < 2; i++) {
        CHECK(exit_code(r, rc_u32(handles + 4u * i)) == i + 1u);
        close_handle(r, rc_u32(handles + 4u * i));
        close_handle(r, isolation_ready[i]);
    }
    close_handle(r, isolation_release);
    CHECK(API(r, TLS_FREE, tls_slot) == 1);
    finish(r, entry_sp, 0, 0);
}

/* The outer leave cannot make a recursively held section available. A
 * contending Enter must release the execution token so its owner can leave. */
static uint32_t section, contention_ready, contention_acquired;

static void contention_worker(Fl41Regs *r, const Fl41Host *h)
{
    (void)h;
    uint32_t entry_sp = r->esp;
    r->esp -= 0x200u;
    CHECK(API(r, SET_EVENT, contention_ready) == 1);
    API(r, ENTER_CS, section);
    contention_acquired++;
    API(r, LEAVE_CS, section);
    finish(r, entry_sp, 0, 1);
}

static void contention_parent(Fl41Regs *r, const Fl41Host *h)
{
    (void)h;
    uint32_t entry_sp = r->esp;
    r->esp -= 0x200u;
    section = rc_alloc(32);
    contention_ready = event(r, 1);
    API(r, INIT_CS, section);
    API(r, ENTER_CS, section);
    API(r, ENTER_CS, section);
    uint32_t worker = thread(r, WORKER_VA, 0, 0, r->esp + 0x80u);
    CHECK(API(r, WAIT_ONE, contention_ready, INFINITE) == 0);
    API(r, SLEEP, 0);
    CHECK(contention_acquired == 0);
    API(r, LEAVE_CS, section);
    API(r, SLEEP, 0);
    CHECK(contention_acquired == 0);
    CHECK(exit_code(r, worker) == STILL_ACTIVE);
    API(r, LEAVE_CS, section);
    CHECK(API(r, WAIT_ONE, worker, INFINITE) == 0);
    CHECK(contention_acquired == 1 && exit_code(r, worker) == 0);
    API(r, DELETE_CS, section);
    close_handle(r, worker);
    close_handle(r, contention_ready);
    finish(r, entry_sp, 0, 0);
}

static uint32_t after_exit_api, after_exit_nested, normal_returned;
static uint32_t lifetime_ready, lifetime_release, lifetime_done, lifetime_progress;

static void exit_leaf(Fl41Regs *r, const Fl41Host *h)
{
    (void)h;
    API(r, EXIT_THREAD, 42);
    after_exit_api++;                 /* ExitThread must unwind this C frame */
    finish(r, r->esp, 99, 0);
}

static void completion_worker(Fl41Regs *r, const Fl41Host *h)
{
    (void)h;
    uint32_t entry_sp = r->esp, kind = rc_u32(entry_sp + 4u);
    r->esp -= 0x200u;
    if (kind == 1) {
        rc_call_from(r, LEAF_VA, 0, NULL);
        after_exit_nested++;
    }
    normal_returned++;
    finish(r, entry_sp, STILL_ACTIVE, 1); /* completion cannot be inferred from code */
}

static void detached_worker(Fl41Regs *r, const Fl41Host *h)
{
    (void)h;
    uint32_t entry_sp = r->esp;
    r->esp -= 0x200u;
    lifetime_progress = 1;
    CHECK(API(r, SET_EVENT, lifetime_ready) == 1);
    CHECK(API(r, WAIT_ONE, lifetime_release, INFINITE) == 0);
    uint32_t before_sleep = rc_clock();
    API(r, SLEEP, 1);
    CHECK(rc_clock() - before_sleep >= 1u);
    lifetime_progress = 2;
    CHECK(API(r, SET_EVENT, lifetime_done) == 1);
    lifetime_progress = 3;
    finish(r, entry_sp, 0, 1);
}

static void completion_parent(Fl41Regs *r, const Fl41Host *h)
{
    (void)h;
    uint32_t entry_sp = r->esp;
    r->esp -= 0x200u;
    uint32_t list = r->esp + 0x80u, id_out = r->esp + 0x90u;
    uint32_t normal = thread(r, WORKER_VA, 0, CREATE_SUSPENDED, id_out);
    uint32_t exiting = thread(r, WORKER_VA, 1, CREATE_SUSPENDED, id_out + 4u);
    CHECK(rc_u32(id_out) != rc_u32(id_out + 4u));
    rc_w32(list, normal);
    rc_w32(list + 4u, exiting);
    CHECK(API(r, WAIT_MANY, 2, list, 1, 0) == WAIT_TIMEOUT);
    CHECK(API(r, RESUME_THREAD, normal) == 1);
    CHECK(API(r, RESUME_THREAD, exiting) == 1);
    CHECK(API(r, WAIT_MANY, 2, list, 1, INFINITE) == 0);
    CHECK(normal_returned == 1);
    CHECK(exit_code(r, normal) == STILL_ACTIVE && exit_code(r, exiting) == 42);
    CHECK(after_exit_api == 0 && after_exit_nested == 0);
    CHECK(API(r, WAIT_ONE, normal, 0) == 0);
    CHECK(API(r, WAIT_ONE, exiting, 0) == 0);
    uint32_t unsignaled = event(r, 1);
    rc_w32(list, unsignaled);
    CHECK(API(r, WAIT_MANY, 2, list, 0, 0) == 1);
    close_handle(r, normal);
    close_handle(r, exiting);
    close_handle(r, unsignaled);

    lifetime_ready = event(r, 1);
    lifetime_release = event(r, 1);
    lifetime_done = event(r, 0);
    uint32_t detached = thread(r, OTHER_VA, 0, 0, id_out);
    CHECK(API(r, WAIT_ONE, lifetime_ready, INFINITE) == 0);
    CHECK(lifetime_progress == 1 && exit_code(r, detached) == STILL_ACTIVE);
    close_handle(r, detached);
    CHECK(API(r, SET_EVENT, lifetime_release) == 1);
    CHECK(API(r, WAIT_ONE, lifetime_done, INFINITE) == 0);
    API(r, SLEEP, 0);
    CHECK(lifetime_progress == 3);
    CHECK(API(r, WAIT_ONE, lifetime_done, 0) == WAIT_TIMEOUT); /* auto reset */
    CHECK(API(r, WAIT_ONE, lifetime_ready, 0) == 0);
    CHECK(API(r, WAIT_ONE, lifetime_ready, 0) == 0);           /* manual reset */
    close_handle(r, lifetime_ready);
    close_handle(r, lifetime_release);
    close_handle(r, lifetime_done);
    finish(r, entry_sp, 0, 0);
}

int main(int argc, char **argv)
{
    CHECK(argc == 2);
    rc_core_init();
    CHECK(rc_map_new(RC_IMAGE_BASE, RC_PAGE) != NULL); /* empty synthetic PE header */
    rc_win32_init();
    for (unsigned i = 0; i < IMPORT_COUNT; i++) {
        RcApiFn fn = NULL;
        if (!rc_win32_resolve("KERNEL32.dll", imports[i].name, &fn) || !fn || fn == rc_unimpl_api) {
            fprintf(stderr, "missing actual Win32 API: %s\n", imports[i].name);
            return 1;
        }
        imports[i].address = rc_stub_for(imports[i].name, "KERNEL32.dll", fn,
                                        4u * (uint32_t)imports[i].nargs);
    }
    if (!strcmp(argv[1], "startup")) {
        rc_register(PARENT_VA, startup_parent);
        rc_register(WORKER_VA, startup_worker);
    } else if (!strcmp(argv[1], "isolation")) {
        rc_register(PARENT_VA, isolation_parent);
        rc_register(WORKER_VA, isolation_worker);
        rc_register(LEAF_VA, fpu_leaf);
    } else if (!strcmp(argv[1], "critical-section")) {
        rc_register(PARENT_VA, contention_parent);
        rc_register(WORKER_VA, contention_worker);
    } else if (!strcmp(argv[1], "completion")) {
        rc_register(PARENT_VA, completion_parent);
        rc_register(WORKER_VA, completion_worker);
        rc_register(OTHER_VA, detached_worker);
        rc_register(LEAF_VA, exit_leaf);
    } else {
        fprintf(stderr, "unknown fixture: %s\n", argv[1]);
        return 1;
    }
    rc_threads_enter();
    uint32_t result = 0xffffffffu;
    int aborted = rc_call_raw(PARENT_VA, 0, NULL, 0, &result);
    if (aborted) fprintf(stderr, "guest aborted: %s\n", rc_abort_reason());
    CHECK(aborted == 0 && result == 0);
    rc_threads_leave();
    printf("RECOMP_THREADS %s ok\n", argv[1]);
    return 0;
}
