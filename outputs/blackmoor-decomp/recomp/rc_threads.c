/* Native pthread stacks retain the lifted program's continuations. A single
 * execution token serializes guest memory and host tables; blocking Win32 APIs
 * hand it to the next runnable guest. No lifted code runs concurrently. */
#include <pthread.h>
#include <setjmp.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <time.h>
#include "rc_internal.h"

struct RcGuestThread {
    struct RcGuestThread *next;
    pthread_t native;
    void *context;
    uint32_t id, entry, parameter, suspends, code;
    int finished, closed, main, sleeping;
    jmp_buf exit_env;
};

static pthread_mutex_t token = PTHREAD_MUTEX_INITIALIZER;
static pthread_cond_t changed = PTHREAD_COND_INITIALIZER;
static RcGuestThread *threads, *owner;
static _Thread_local RcGuestThread *current;
static uint32_t next_id = 0x5679;
static int active, stopping;
static char worker_error[512];

uint32_t rc_thread_id(void) { return current ? current->id : 0x5678; }
int rc_thread_is_main(void) { return !current || current->main; }
RcGuestThread *rc_thread_current(void) { return current; }

static RcGuestThread *next_runnable(RcGuestThread *after)
{
    RcGuestThread *p = after->next ? after->next : threads;
    do {
        if (!p->finished && ((!p->suspends && !p->sleeping) || stopping)) return p;
        p = p->next ? p->next : threads;
    } while (p != (after->next ? after->next : threads));
    return NULL;
}

static void reap(void)
{
    RcGuestThread **p = &threads;
    while (*p) {
        RcGuestThread *t = *p;
        if (t != current && !t->main && t->closed && t->finished) {
            *p = t->next;
            pthread_join(t->native, NULL);
            rc_handle_forget(RC_H_THREAD, t);
            rc_context_destroy(t->context);
            free(t);
        } else p = &t->next;
    }
}

static void platform_sleep(uint32_t ms)
{
    if (rc_plat.sleep_ms) rc_plat.sleep_ms(rc_plat.user, ms);
    else {
        struct timespec delay = {ms / 1000u, (long)(ms % 1000u) * 1000000L};
        while (nanosleep(&delay, &delay) && errno == EINTR) {}
    }
}

void rc_threads_sleep(uint32_t ms)
{
    if (!current || !active) { platform_sleep(ms); return; }
    rc_context_save(current->context);
    current->sleeping = 1;
    owner = next_runnable(current);
    pthread_cond_broadcast(&changed);
    pthread_mutex_unlock(&token);
    platform_sleep(ms);
    pthread_mutex_lock(&token);
    current->sleeping = 0;
    if (!owner) owner = current;
    pthread_cond_broadcast(&changed);
    while (owner != current) pthread_cond_wait(&changed, &token);
    rc_context_restore(current->context);
    if (stopping && !current->main) rc_thread_exit(0);
    if (!stopping && current->main && worker_error[0]) rc_abort("guest worker: %s", worker_error);
}

void rc_threads_yield(void)
{
    if (!current || !active) return;
    reap();
    if (current->main && !threads->next) return;
    if (stopping && !current->main) rc_thread_exit(0);
    rc_context_save(current->context);
    RcGuestThread *next;
    while (!(next = next_runnable(current))) pthread_cond_wait(&changed, &token);
    owner = next;
    pthread_cond_broadcast(&changed);
    while (owner != current) pthread_cond_wait(&changed, &token);
    rc_context_restore(current->context);
    if (stopping && !current->main) rc_thread_exit(0);
    if (!stopping && current->main && worker_error[0]) rc_abort("guest worker: %s", worker_error);
}

void rc_thread_exit(uint32_t code)
{
    if (!current || current->main) rc_abort("ExitThread on main guest thread (%u)", code);
    current->code = code;
    longjmp(current->exit_env, 1);
}

static void *worker_start(void *arg)
{
    RcGuestThread *t = (RcGuestThread *)arg;
    current = t;
    pthread_mutex_lock(&token);
    while (owner != t) pthread_cond_wait(&changed, &token);
    rc_context_restore(t->context);
    if (!setjmp(t->exit_env) && !stopping) {
        uint32_t result = 0;
        if (rc_call_raw(t->entry, 1, &t->parameter, 0, &result)) {
            snprintf(worker_error, sizeof worker_error, "%s", rc_abort_reason());
            t->code = 1;
        } else t->code = result;
    }
    t->finished = 1;
    rc_log("  THREAD exit id=%u code=%u", t->id, t->code);
    rc_context_save(t->context);
    owner = next_runnable(t);
    pthread_cond_broadcast(&changed);
    pthread_mutex_unlock(&token);
    return NULL;
}

void rc_threads_enter(void)
{
    pthread_mutex_lock(&token);
    if (active) { pthread_mutex_unlock(&token); rc_abort("guest process already running"); }
    RcGuestThread *t = (RcGuestThread *)calloc(1, sizeof *t);
    if (!t) { pthread_mutex_unlock(&token); rc_abort("cannot allocate main thread context"); }
    t->main = 1; t->id = 0x5678; t->context = rc_context_create(0, t->id);
    if (!t->context) { free(t); pthread_mutex_unlock(&token); rc_abort("cannot save main thread context"); }
    current = owner = threads = t;
    stopping = 0; worker_error[0] = 0; active = 1;
}

void rc_threads_leave(void)
{
    if (!current || !current->main) return;
    stopping = 1;
    for (;;) {
        int live = 0;
        for (RcGuestThread *t = threads; t; t = t->next) if (!t->main && !t->finished) live = 1;
        if (!live) break;
        rc_threads_yield();
    }
    for (RcGuestThread *t = threads; t; t = t->next) if (!t->main) t->closed = 1;
    reap();
    RcGuestThread *main_thread = current;
    rc_context_destroy(main_thread->context);
    free(main_thread);
    threads = owner = current = NULL;
    active = 0;
    pthread_mutex_unlock(&token);
}

RcGuestThread *rc_thread_create(uint32_t entry, uint32_t parameter, uint32_t stack_size, uint32_t flags, uint32_t *id)
{
    if (!current || !active || (flags & ~0x10004u)) return NULL;
    reap();
    RcGuestThread *t = (RcGuestThread *)calloc(1, sizeof *t);
    if (!t) return NULL;
    t->id = next_id++; t->entry = entry; t->parameter = parameter;
    t->suspends = (flags & 4u) ? 1u : 0u;
    t->context = rc_context_create(stack_size ? stack_size : RC_STACK_SIZE, t->id);
    if (!t->context) { free(t); return NULL; }
    RcGuestThread **tail = &threads;
    while (*tail) tail = &(*tail)->next;
    *tail = t;
    pthread_attr_t attributes;
    int error = pthread_attr_init(&attributes);
    if (!error) {
        /* Lifted frames have more native locals than the original x86 frames.
         * Reserve enough native stack without changing the guest stack size. */
        error = pthread_attr_setstacksize(&attributes, 8u * 1024u * 1024u);
        if (!error) error = pthread_create(&t->native, &attributes, worker_start, t);
        pthread_attr_destroy(&attributes);
    }
    if (error) { *tail = NULL; rc_context_destroy(t->context); free(t); return NULL; }
    if (id) *id = t->id;
    rc_log("  THREAD create id=%u entry=0x%x parameter=0x%x suspended=%u", t->id, entry, parameter, t->suspends);
    return t;
}

uint32_t rc_thread_resume(RcGuestThread *t)
{
    if (!t || t->finished) return UINT32_MAX;
    uint32_t old = t->suspends;
    if (old) t->suspends--;
    return old;
}

uint32_t rc_thread_suspend(RcGuestThread *t)
{
    if (!t || t->finished || t->suspends == 127u) return UINT32_MAX;
    uint32_t old = t->suspends++;
    if (t == current) rc_threads_yield();
    return old;
}

uint32_t rc_thread_exit_code(RcGuestThread *t) { return t && t->finished ? t->code : 259u; }
int rc_thread_finished(RcGuestThread *t) { return t && t->finished; }
void rc_thread_close(RcGuestThread *t) { if (t && !t->main) { t->closed = 1; reap(); } }
