/* Win32 stand-ins: the subset of KERNEL32, USER32, GDI32, ADVAPI32, SHELL32, SHLWAPI, VERSION and WINMM that GAME.EXE and its MFC/CRT
 * statically linked code call. A port of the Python spike's shim (tasks/spike-recompile/driver.py), which stays as the oracle. */
#define _GNU_SOURCE
#include <ctype.h>
#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <pthread.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <time.h>
#include <unistd.h>
#include "rc.h"

#define API(name) static int api_##name(Fl41Regs *r, const uint32_t *a, uint32_t *ret)
#define UNUSED (void)r; (void)a; (void)ret
#define RET(v) do { *ret = (uint32_t)(v); return 0; } while (0)
#define SARG(i) ((int32_t)a[i])

RcPlatform rc_plat;
static int have_plat;
static volatile int stop_requested;

void rc_set_platform(const RcPlatform *p) { rc_plat = *p; have_plat = 1; }
void rc_request_stop(void) { stop_requested = 1; }
const char *rc_game_dir(void) { return have_plat && rc_plat.game_dir ? rc_plat.game_dir : "."; }

void rc_platform_log(const char *line)
{
    if (have_plat && rc_plat.log) rc_plat.log(rc_plat.user, line);
}

/* ------------------------------------------------------------------ clock
 * Virtual mode keeps microseconds: a GetTickCount is 1 ms, a counter read 50 us and an idle message poll 5 ms, so a loop that waits on any of
 * them ends. With a platform clock the same calls return real time. */
static uint64_t vus = 1000u * 1000u;
static uint64_t real_origin;
static uint64_t qpc_calls;

int rc_clock_is_virtual(void) { return !(have_plat && rc_plat.now_ms); }

uint32_t rc_clock(void)
{
    if (!rc_clock_is_virtual()) return (uint32_t)(rc_plat.now_ms(rc_plat.user) - real_origin + 1000u);
    return (uint32_t)(vus / 1000u);
}

void rc_clock_advance(uint32_t ms) { if (rc_clock_is_virtual()) vus += (uint64_t)ms * 1000u; }
static void vus_add(uint32_t us) { if (rc_clock_is_virtual()) vus += us; }

static void do_sleep(uint32_t ms)
{
    if (!rc_clock_is_virtual() && rc_plat.sleep_ms) rc_plat.sleep_ms(rc_plat.user, ms);
}

static void check_stop(void)
{
    if (stop_requested) rc_abort("stop requested");
}

/* ------------------------------------------------------------------ state */
static uint32_t tls_vals[256];
static uint32_t tls_next;
static uint32_t last_error;
static uint32_t cmdline_ptr;
static uint32_t dc_handle, cursor_h, icon_h, image_h, accel_h, gdi_h, menu_h, key_h;
static int32_t cursor_count;

typedef struct SeenFile { char name[64]; uint32_t at; } SeenFile;
static SeenFile seen[256];
static int seen_count;

static void note_file(const char *win)
{
    const char *b = strrchr(win, '\\');
    b = b ? b + 1 : win;
    char name[64];
    size_t i = 0;
    for (; b[i] && i < sizeof name - 1; i++) name[i] = (char)toupper((unsigned char)b[i]);
    name[i] = 0;
    for (int k = 0; k < seen_count; k++) if (!strcmp(seen[k].name, name)) return;
    if (seen_count < 256) { strcpy(seen[seen_count].name, name); seen[seen_count++].at = rc_clock(); }
}

int rc_seen_at(const char *name, uint32_t *at)
{
    for (int k = 0; k < seen_count; k++) if (!strcasecmp(seen[k].name, name)) { *at = seen[k].at; return 1; }
    return 0;
}

static char file_first_data[260];
static uint32_t files_opened;
const char *rc_first_data_file(void) { return file_first_data[0] ? file_first_data : NULL; }
uint32_t rc_files_opened(void) { return files_opened; }

static void fs_log(const char *what, const char *win)
{
    rc_log("  FILE %s %s  [virtual %u ms]", what, win, rc_clock());
    note_file(win);
}

/* ------------------------------------------------------------------ the virtual file system: a host folder stands for C:\GAME */
static int fs_path(const char *win0, int must_exist, char *out, size_t cap)
{
    char win[1024];
    size_t n = 0;
    for (; win0[n] && n < sizeof win - 1; n++) win[n] = win0[n] == '/' ? '\\' : win0[n];
    win[n] = 0;
    const char *w = win;
    if (n > 1 && win[1] == ':') w = win + 2;
    char cur[1536];
    snprintf(cur, sizeof cur, "%s", rc_game_dir());
    char *parts[64];
    int np = 0;
    char buf[1024];
    snprintf(buf, sizeof buf, "%s", w);
    for (char *tok = buf, *next; tok && *tok != 0 + 0 + 0; tok = next) {
        next = strchr(tok, '\\');
        if (next) *next++ = 0;
        if (!*tok || !strcmp(tok, ".")) { if (!next) break; continue; }
        if (!strcmp(tok, "..")) return 0;
        if (np < 64) parts[np++] = tok;
        if (!next) break;
    }
    int start = 0;
    if (np && !strcmp(parts[0], "GAME")) start = 1;
    if (have_plat && rc_plat.save_dir && start < np && !strncasecmp(parts[start], "Documents", 9)) snprintf(cur, sizeof cur, "%s", rc_plat.save_dir);
    for (int i = start; i < np; i++) {
        char hit[256] = "";
        DIR *d = opendir(cur);
        if (d) {
            struct dirent *e;
            while ((e = readdir(d))) if (!strcasecmp(e->d_name, parts[i])) { snprintf(hit, sizeof hit, "%s", e->d_name); break; }
            closedir(d);
        }
        if (!hit[0]) {
            if (must_exist || i < np - 1) return 0;
            snprintf(hit, sizeof hit, "%s", parts[i]);
        }
        size_t l = strlen(cur);
        snprintf(cur + l, sizeof cur - l, "/%s", hit);
    }
    if (strlen(cur) >= cap) return 0;
    strcpy(out, cur);
    return 1;
}

int rc_fs_resolve(const char *win, int must_exist, char *out, size_t cap) { return fs_path(win, must_exist, out, cap); }
void rc_fs_log(const char *what, const char *win) { fs_log(what, win); }

/* ------------------------------------------------------------------ INI files */
static int ini_get(const char *path, const char *section, const char *key, char *out, size_t cap)
{
    FILE *f = fopen(path, "rb");
    if (!f) return 0;
    char line[1024], cur[256] = "";
    int found = 0;
    while (fgets(line, sizeof line, f)) {
        char *s = line;
        while (*s == ' ' || *s == '\t') s++;
        size_t len = strlen(s);
        while (len && (s[len - 1] == '\n' || s[len - 1] == '\r' || s[len - 1] == ' ' || s[len - 1] == '\t')) s[--len] = 0;
        if (!*s || *s == ';' || *s == '#') continue;
        if (*s == '[') {
            char *e = strchr(s, ']');
            if (e) { *e = 0; snprintf(cur, sizeof cur, "%s", s + 1); }
            continue;
        }
        char *eq = s + strcspn(s, "=:");
        if (!*eq) continue;
        *eq = 0;
        char *k = s;
        size_t kl = strlen(k);
        while (kl && (k[kl - 1] == ' ' || k[kl - 1] == '\t')) k[--kl] = 0;
        char *v = eq + 1;
        while (*v == ' ' || *v == '\t') v++;
        if (!strcasecmp(cur, section) && !strcasecmp(k, key)) {       /* a later duplicate wins, as in the Python reader */
            snprintf(out, cap, "%s", v);
            found = 1;
        }
    }
    fclose(f);
    return found;
}

/* ------------------------------------------------------------------ messages and windows */
typedef struct Msg { uint32_t hwnd, msg, wp, lp; } Msg;
#define MSGQ 8192
static Msg msgq[MSGQ];
static uint32_t mq_head, mq_tail;
static pthread_mutex_t mq_lock = PTHREAD_MUTEX_INITIALIZER;

typedef struct Timer { uint32_t hwnd, id, elapse, proc, last; int used; } Timer;
static Timer timers[64];

typedef struct Window {
    uint32_t hwnd, proc, style, ex, parent, user, id;
    char cls[64], title[128];
    int32_t rect[4];
    int visible;
} Window;
static Window *windows[64];
static int window_count;
uint32_t rc_main_hwnd;

typedef struct WndClass { char name[64]; uint32_t atom, proc; } WndClass;
static WndClass classes[32];
static int class_count;
static uint32_t hooks[16];

static uint32_t vk_down_until[256];
static uint32_t btn_until;
static int btn_flag;                 /* real input: the left button is held */
static int key_flag[256];
static int32_t cursor_x = 320, cursor_y = 240;
static uint32_t focus;
static uint32_t idle_polls, max_idle_polls = 20000;
static uint32_t msg_log;
static void (*poll_hook)(void);

void rc_set_poll_hook(void (*hook)(void)) { poll_hook = hook; }
void rc_set_max_idle_polls(uint32_t n) { max_idle_polls = n; }

static void mq_push_front(Msg m)
{
    pthread_mutex_lock(&mq_lock);
    mq_head = (mq_head - 1u) % MSGQ;
    msgq[mq_head] = m;
    pthread_mutex_unlock(&mq_lock);
}

static int mq_pop(Msg *m)
{
    pthread_mutex_lock(&mq_lock);
    int got = mq_head != mq_tail;
    if (got) { *m = msgq[mq_head]; mq_head = (mq_head + 1u) % MSGQ; }
    pthread_mutex_unlock(&mq_lock);
    return got;
}

void rc_msg_post(uint32_t hwnd, uint32_t msg, uint32_t wp, uint32_t lp)
{
    pthread_mutex_lock(&mq_lock);
    if ((mq_tail + 1u) % MSGQ != mq_head) { msgq[mq_tail] = (Msg){hwnd, msg, wp, lp}; mq_tail = (mq_tail + 1u) % MSGQ; }
    pthread_mutex_unlock(&mq_lock);
}

static int mq_has(uint32_t hwnd, uint32_t msg)
{
    pthread_mutex_lock(&mq_lock);
    int found = 0;
    for (uint32_t i = mq_head; i != mq_tail; i = (i + 1u) % MSGQ)
        if (msgq[i].hwnd == hwnd && msgq[i].msg == msg && !msgq[i].wp && !msgq[i].lp) { found = 1; break; }
    pthread_mutex_unlock(&mq_lock);
    return found;
}

static Window *wnd(uint32_t hwnd) { return rc_handle_kind(hwnd) == RC_H_WINDOW ? (Window *)rc_handle_obj(hwnd, RC_H_WINDOW) : NULL; }

static uint32_t send_msg(uint32_t hwnd, uint32_t msg, uint32_t wp, uint32_t lp)
{
    Window *w = wnd(hwnd);
    uint32_t proc = w ? w->proc : 0;
    if (!proc) return 0;
    if (msg_log < 400 || (msg != 0x0113 && msg != 0x000f && msg != 0x0020 && msg != 0x0084 && msg != 0x0200)) {
        msg_log++;
        rc_log("  -> WndProc 0x%x(hwnd=0x%x, msg=0x%04x, wp=0x%x, lp=0x%x)", proc, hwnd, msg, wp, lp);
    }
    uint32_t args[4] = {hwnd, msg, wp, lp};
    return rc_call(proc, 4, args, 0);
}

/* Input from the platform. kind: 0 move, 1 click (press and release; buttons = hold ms), 2 key (key = virtual key; buttons = hold ms),
 * 3 mouse state (real input: x, y and buttons bit 0), 4 key state (key, buttons = down). */
void rc_input_event(uint32_t kind, int32_t x, int32_t y, uint32_t buttons, uint32_t key)
{
    uint32_t hwnd = rc_main_hwnd;
    uint32_t lp = ((uint32_t)y << 16) | ((uint32_t)x & 0xffffu);
    switch (kind) {
    case 0: case 1:
        cursor_x = x; cursor_y = y;
        if (hwnd) rc_msg_post(hwnd, 0x0200, 0, lp);
        if (kind == 1) {
            btn_until = rc_clock() + buttons;
            if (hwnd) { rc_msg_post(hwnd, 0x0201, 1, lp); rc_msg_post(hwnd, 0x0202, 0, lp); }
        }
        break;
    case 2:
        if (hwnd) { rc_msg_post(hwnd, 0x0100, key, 0); rc_msg_post(hwnd, 0x0101, key, 0xc0000000u); }
        if (key < 256) vk_down_until[key] = rc_clock() + buttons;
        break;
    case 3: {
        int was = btn_flag;
        int now = (int)(buttons & 1u);
        cursor_x = x; cursor_y = y;
        btn_flag = now;
        if (hwnd) {
            if (!was && now) { rc_msg_post(hwnd, 0x0200, 0, lp); rc_msg_post(hwnd, 0x0201, 1, lp); }
            else if (was && !now) rc_msg_post(hwnd, 0x0202, 0, lp);
            else rc_msg_post(hwnd, 0x0200, now ? 1u : 0u, lp);
        }
        break; }
    case 4:
        if (key < 256) key_flag[key] = (int)buttons;
        if (hwnd) rc_msg_post(hwnd, buttons ? 0x0100u : 0x0101u, key, buttons ? 0u : 0xc0000000u);
        break;
    default: break;
    }
}

void rc_input_mouse(int32_t x, int32_t y, int left_down) { rc_input_event(3, x, y, (uint32_t)(left_down != 0), 0); }
void rc_input_key(uint32_t vk, int down) { rc_input_event(4, 0, 0, 0, 0); if (vk < 256) { key_flag[vk] = down; if (rc_main_hwnd) rc_msg_post(rc_main_hwnd, down ? 0x0100u : 0x0101u, vk, down ? 0u : 0xc0000000u); } }
void rc_set_input_state(int32_t x, int32_t y, uint32_t buttons) { cursor_x = x; cursor_y = y; btn_flag = (int)(buttons & 1u); }

static int next_message(Msg *m)
{
    check_stop();
    if (poll_hook) poll_hook();
    if (mq_pop(m)) return 1;
    if (rc_clock_is_virtual()) vus += 5000u;
    else do_sleep(1);
    idle_polls++;
    rc_dsound_tick();
    uint32_t now = rc_clock();
    for (int i = 0; i < 64; i++) {
        Timer *t = &timers[i];
        if (t->used && now - t->last >= t->elapse) {
            t->last = now;
            *m = (Msg){t->hwnd, 0x0113, t->id, t->proc};
            return 1;
        }
    }
    return 0;
}

static void fill_msg(uint32_t p, Msg m)
{
    uint32_t v[7] = {m.hwnd, m.msg, m.wp, m.lp, rc_clock(), (uint32_t)cursor_x, (uint32_t)cursor_y};
    rc_write(p, v, sizeof v);
}


/* ------------------------------------------------------------------ resources (the PE's own directory) */
static uint32_t res_root;

static void res_init(void)
{
    uint32_t pe = RC_IMAGE_BASE + rc_u32(RC_IMAGE_BASE + 0x3c);
    uint32_t rva = rc_u32(pe + 0x78 + 16);                 /* data directory 2: resources */
    res_root = rva ? RC_IMAGE_BASE + rva : 0;
}

/* One level of the resource tree: the entry for a name or an id, as the offset field of the entry. */
static int res_entry(uint32_t dir, const char *sname, uint32_t id, uint32_t *off)
{
    uint32_t named = rc_u16(dir + 12), ids = rc_u16(dir + 14);
    for (uint32_t i = 0; i < named + ids; i++) {
        uint32_t e = dir + 16u + 8u * i, nm = rc_u32(e);
        int is_named = (nm & 0x80000000u) != 0;
        if (is_named) {
            if (!sname) continue;
            uint32_t sp = res_root + (nm & 0x7fffffffu), len = rc_u16(sp);
            char buf[128];
            uint32_t k = 0;
            for (; k < len && k < sizeof buf - 1; k++) buf[k] = (char)rc_u16(sp + 2u + 2u * k);
            buf[k] = 0;
            if (strcmp(buf, sname)) continue;
        } else if (sname || nm != id) continue;
        *off = rc_u32(e + 4);
        return 1;
    }
    return 0;
}

static int res_first(uint32_t dir, uint32_t *off)
{
    uint32_t n = rc_u16(dir + 12) + rc_u16(dir + 14);
    if (!n) return 0;
    *off = rc_u32(dir + 16u + 4u);
    return 1;
}

/* type and name given as strings or ids; returns the data's guest address and size */
static int res_find(const char *tname, uint32_t tid, const char *nname, uint32_t nid, uint32_t *va, uint32_t *size)
{
    uint32_t off;
    if (!res_root) return 0;
    if (!res_entry(res_root, tname, tid, &off) || !(off & 0x80000000u)) return 0;
    uint32_t d1 = res_root + (off & 0x7fffffffu);
    if (!res_entry(d1, nname, nid, &off) || !(off & 0x80000000u)) return 0;
    uint32_t d2 = res_root + (off & 0x7fffffffu);
    if (!res_first(d2, &off) || (off & 0x80000000u)) return 0;
    uint32_t de = res_root + off;
    *va = RC_IMAGE_BASE + rc_u32(de);
    *size = rc_u32(de + 4);
    return 1;
}

static int res_first_of_type(uint32_t tid, uint32_t *va, uint32_t *size)
{
    uint32_t off;
    if (!res_root || !res_entry(res_root, NULL, tid, &off) || !(off & 0x80000000u)) return 0;
    uint32_t d1 = res_root + (off & 0x7fffffffu);
    if (!res_first(d1, &off) || !(off & 0x80000000u)) return 0;
    uint32_t d2 = res_root + (off & 0x7fffffffu);
    if (!res_first(d2, &off) || (off & 0x80000000u)) return 0;
    uint32_t de = res_root + off;
    *va = RC_IMAGE_BASE + rc_u32(de);
    *size = rc_u32(de + 4);
    return 1;
}

/* ------------------------------------------------------------------ helpers */
static void str_arg(uint32_t p, char *out, size_t cap)
{
    if (p >= 0x10000u) rc_cstr(p, out, cap); else snprintf(out, cap, "#%u", p);
}

static void put_buf(uint32_t dst, const char *s, uint32_t cap)       /* the bytes of s (with its NUL) cut at cap */
{
    uint32_t n = (uint32_t)strlen(s) + 1u;
    if (n > cap) n = cap;
    rc_write(dst, s, n);
}

static int wild(const char *pat, const char *s)
{
    for (; *pat; pat++) {
        if (*pat == '*') {
            while (pat[1] == '*') pat++;
            for (const char *t = s;; t++) { if (wild(pat + 1, t)) return 1; if (!*t) return 0; }
        }
        if (!*s || (*pat != '?' && tolower((unsigned char)*pat) != tolower((unsigned char)*s))) return 0;
        s++;
    }
    return !*s;
}

/* ------------------------------------------------------------------ KERNEL32: process, heap, memory */
API(GetVersion) { UNUSED; RET(0x0a280105u); }                       /* Windows XP 5.1 build 2600, platform NT */
API(GetVersionExA)
{
    (void)r;
    rc_w32(a[0] + 4, 5); rc_w32(a[0] + 8, 1); rc_w32(a[0] + 12, 2600); rc_w32(a[0] + 16, 2);
    rc_put_cstr(a[0] + 20, "Service Pack 3");
    RET(1);
}
API(HeapCreate) { (void)r; (void)a; RET(rc_handle_new(RC_H_HEAP, NULL)); }
API(HeapDestroy) { UNUSED; RET(1); }
API(GetProcessHeap) { UNUSED; RET(0x100); }
API(HeapAlloc) { (void)r; RET(rc_heap_get(a[2], (int)(a[1] & 8))); }
API(HeapReAlloc)
{
    (void)r;
    uint32_t q = rc_heap_get(a[3], (int)(a[1] & 8)), old = rc_heap_size(a[2]);
    if (old) { uint32_t n = old < a[3] ? old : a[3]; uint8_t *tmp = (uint8_t *)malloc(n); rc_read(a[2], tmp, n); rc_write(q, tmp, n); free(tmp); }
    rc_heap_put(a[2]);
    RET(q);
}
API(HeapFree) { (void)r; rc_heap_put(a[2]); RET(1); }
API(HeapSize) { (void)r; RET(rc_heap_size(a[2])); }
API(VirtualAlloc)
{
    (void)r;
    if ((a[2] & 0x1000u) && a[0] && rc_is_mapped(a[0])) RET(a[0]);     /* committing inside a reserved range */
    RET(rc_alloc(a[1]));
}
API(VirtualFree) { UNUSED; RET(1); }
API(GlobalAlloc) { (void)r; RET(rc_heap_get(a[1], (int)(a[0] & 0x40))); }
API(LocalAlloc) { (void)r; RET(rc_heap_get(a[1], (int)(a[0] & 0x40))); }
API(GlobalLock) { (void)r; RET(a[0]); }
API(GlobalUnlock) { UNUSED; RET(1); }
API(GlobalFree) { (void)r; rc_heap_put(a[0]); RET(0); }
API(GlobalHandle) { (void)r; RET(a[0]); }
API(LocalReAlloc)
{
    (void)r;
    uint32_t q = rc_heap_get(a[1], 0), old = rc_heap_size(a[0]);
    if (old) { uint32_t n = old < a[1] ? old : a[1]; uint8_t *tmp = (uint8_t *)malloc(n); rc_read(a[0], tmp, n); rc_write(q, tmp, n); free(tmp); }
    rc_heap_put(a[0]);
    RET(q);
}
API(GlobalReAlloc) { return api_LocalReAlloc(r, a, ret); }
API(LocalLock) { (void)r; RET(a[0]); }
API(LocalUnlock) { UNUSED; RET(0); }
API(LocalSize) { (void)r; RET(rc_heap_size(a[0])); }
API(GlobalFlags) { UNUSED; RET(0); }
API(LocalFree) { (void)r; rc_heap_put(a[0]); RET(0); }

API(GetCommandLineA)
{
    UNUSED;
    if (!cmdline_ptr) cmdline_ptr = rc_guest_string("\"C:\\GAME\\GAME.EXE\"");
    RET(cmdline_ptr);
}
API(GetEnvironmentStrings) { UNUSED; uint32_t p = rc_alloc(64); rc_write(p, "PATH=C:\\GAME\0", 14); RET(p); }
API(GetEnvironmentStringsW)
{
    UNUSED;
    uint32_t p = rc_alloc(128);
    const char *s = "PATH=C:\\GAME";
    uint32_t i = 0;
    for (; s[i]; i++) rc_w16(p + 2u * i, (uint32_t)(unsigned char)s[i]);
    RET(p);
}
API(FreeEnvironmentStrings) { UNUSED; RET(1); }
API(GetStartupInfoA) { (void)r; rc_zero(a[0], 68); rc_w32(a[0], 68); RET(0); }
API(GetModuleHandleA)
{
    (void)r;
    if (!a[0]) RET(RC_IMAGE_BASE);
    RET(rc_handle_new(RC_H_MODULE, NULL));
}
API(GetModuleFileNameA) { (void)r; put_buf(a[1], "C:\\GAME\\GAME.EXE", a[2]); RET(15); }
API(GetProcAddress)
{
    (void)r;
    char s[128];
    str_arg(a[1], s, sizeof s);
    rc_log("  GetProcAddress(%s)", s);
    RET(0);
}
API(LoadLibraryA) { (void)r; char s[260]; rc_cstr(a[0], s, sizeof s); rc_log("  LoadLibraryA(%s)", s); RET(0); }
API(GetCurrentThreadId) { UNUSED; RET(0x5678); }
API(GetCurrentProcessId) { UNUSED; RET(0x1234); }
API(GetCurrentProcess) { UNUSED; RET(0xffffffffu); }
API(GetCurrentThread) { UNUSED; RET(0xfffffffeu); }
API(TlsAlloc) { UNUSED; if (tls_next >= 256) RET(0xffffffffu); tls_vals[tls_next] = 0; RET(tls_next++); }
API(TlsSetValue) { (void)r; if (a[0] < 256) tls_vals[a[0]] = a[1]; RET(1); }
API(TlsGetValue) { (void)r; RET(a[0] < 256 ? tls_vals[a[0]] : 0); }
API(TlsFree) { UNUSED; RET(1); }
API(CriticalSection) { UNUSED; RET(0); }
API(GetLastError) { UNUSED; RET(last_error); }
API(SetLastError) { (void)r; last_error = a[0]; RET(0); }
API(SetUnhandledExceptionFilter) { UNUSED; RET(0); }
API(UnhandledExceptionFilter) { UNUSED; RET(1); }
API(GetACP) { UNUSED; RET(1252); }
API(GetOEMCP) { UNUSED; RET(437); }
API(GetCPInfo) { (void)r; rc_zero(a[1], 20); rc_w32(a[1], 1); RET(1); }
API(GetStdHandle) { (void)r; RET(0x300u + (a[0] & 0xffu)); }
API(GetFileType) { UNUSED; RET(2); }
API(SetHandleCount) { (void)r; RET(a[0]); }
API(ExitProcess) { (void)r; (void)ret; rc_abort("ExitProcess(%d)", SARG(0)); }
API(TerminateProcess) { (void)r; (void)ret; rc_abort("TerminateProcess(%d)", SARG(1)); }
API(GetSystemInfo) { (void)r; rc_zero(a[0], 36); rc_w32(a[0] + 4, RC_PAGE); rc_w32(a[0] + 20, 1); RET(0); }
API(QueryPerformanceFrequency) { (void)r; rc_w32(a[0], 1000000u); rc_w32(a[0] + 4, 0); RET(1); }
API(QueryPerformanceCounter)
{
    (void)r;
    uint64_t t;
    if (rc_clock_is_virtual()) { vus += 50u; t = vus; } else t = (uint64_t)rc_clock() * 1000u + (qpc_calls++ & 0x3ffu);
    rc_w32(a[0], (uint32_t)t); rc_w32(a[0] + 4, (uint32_t)(t >> 32));
    RET(1);
}
API(GetTickCount) { UNUSED; vus_add(1000u); RET(rc_clock()); }       /* a game that busy-waits on the tick count makes time pass */
API(Sleep) { (void)r; if (!rc_clock_is_virtual()) { check_stop(); do_sleep(a[0]); } RET(0); }
API(GetKeyboardType) { (void)r; RET(a[0] == 0 ? 4 : 0); }
API(GetSystemMetrics)
{
    (void)r;
    switch (a[0]) {
    case 0: case 16: RET(1024); case 1: case 17: RET(768); case 4: RET(19); case 6: case 7: case 80: RET(1); case 15: RET(4);
    default: RET(0);
    }
}
API(GetDC) { UNUSED; if (!dc_handle) dc_handle = rc_handle_new(RC_H_DC, NULL); RET(dc_handle); }
API(ReleaseDC) { UNUSED; RET(1); }
API(GetDeviceCaps)
{
    (void)r;
    switch (a[1]) { case 8: RET(1024); case 10: RET(768); case 12: RET(32); case 14: RET(1); case 88: case 90: RET(96); default: RET(0); }
}
API(RegOpenKeyExA) { (void)r; char s[260]; rc_cstr(a[1], s, sizeof s); rc_log("  RegOpenKeyExA(%s)", s); RET(2); }
API(RegCreateKeyExA)
{
    (void)r;
    char s[260];
    rc_cstr(a[1], s, sizeof s);
    rc_log("  RegCreateKeyExA(%s)", s);
    if (!key_h) key_h = rc_handle_new(RC_H_KEY, NULL);
    rc_w32(a[7], key_h);
    RET(0);
}
API(RegQueryValueExA) { (void)r; char s[260] = ""; if (a[1]) rc_cstr(a[1], s, sizeof s); rc_log("  RegQueryValueExA(%s)", s); RET(2); }
API(Zero) { UNUSED; RET(0); }
API(One) { UNUSED; RET(1); }
API(GetCurrentDirectoryA) { (void)r; put_buf(a[1], "C:\\GAME", a[0]); RET(7); }
API(SetCurrentDirectoryA) { (void)r; char s[260]; rc_cstr(a[0], s, sizeof s); rc_log("  SetCurrentDirectoryA(%s)", s); RET(1); }
API(GetWindowsDirectoryA) { (void)r; put_buf(a[0], "C:\\WINDOWS", a[1]); RET(10); }
API(GetSystemDirectoryA) { (void)r; put_buf(a[0], "C:\\WINDOWS\\SYSTEM32", a[1]); RET(19); }

/* ------------------------------------------------------------------ files */
typedef struct FileObj { char path[1536]; int fd; int64_t pos; } FileObj;

API(GetFileAttributesA)
{
    (void)r;
    char win[1024], h[1536];
    rc_cstr(a[0], win, sizeof win);
    int ok = fs_path(win, 1, h, sizeof h);
    fs_log("attr", win);
    if (!ok) { last_error = 2; RET(0xffffffffu); }
    struct stat st;
    RET(stat(h, &st) == 0 && S_ISDIR(st.st_mode) ? 0x10 : 0x80);
}
API(PathFileExistsA) { (void)r; char win[1024], h[1536]; rc_cstr(a[0], win, sizeof win); RET(fs_path(win, 1, h, sizeof h) ? 1 : 0); }
API(PathAppendA)
{
    (void)r;
    char x[1024], y[1024];
    rc_cstr(a[0], x, sizeof x); rc_cstr(a[1], y, sizeof y);
    size_t n = strlen(x);
    while (n && x[n - 1] == '\\') x[--n] = 0;
    const char *yy = y;
    while (*yy == '\\') yy++;
    char out[2100];
    snprintf(out, sizeof out, "%s\\%s", x, yy);
    rc_put_cstr(a[0], out);
    RET(1);
}
API(CopyFileA)
{
    (void)r;
    char src[1024], dst[1024], hs[1536], hd[1536];
    rc_cstr(a[0], src, sizeof src); rc_cstr(a[1], dst, sizeof dst);
    char what[1100];
    snprintf(what, sizeof what, "copy %s ->", src);
    fs_log(what, dst);
    if (!fs_path(src, 1, hs, sizeof hs)) { last_error = 2; RET(0); }
    if (!fs_path(dst, 0, hd, sizeof hd)) { last_error = 3; RET(0); }
    struct stat st;
    if (stat(hd, &st) == 0 && a[2]) { last_error = 80; RET(0); }
    FILE *in = fopen(hs, "rb");
    if (!in) { last_error = 2; RET(0); }
    FILE *out = fopen(hd, "wb");
    if (!out) { fclose(in); last_error = 5; RET(0); }
    char buf[65536];
    size_t n;
    while ((n = fread(buf, 1, sizeof buf, in)) > 0) fwrite(buf, 1, n, out);
    fclose(in); fclose(out);
    RET(1);
}
API(DeleteFileA) { (void)r; char s[1024]; rc_cstr(a[0], s, sizeof s); fs_log("delete", s); RET(1); }
API(CreateFileA)
{
    (void)r;
    char win[1024], h[1536];
    rc_cstr(a[0], win, sizeof win);
    uint32_t acc = a[1], disp = a[4];
    fs_log("open", win);
    int ok = fs_path(win, disp == 3, h, sizeof h);
    struct stat st;
    int exists = ok && stat(h, &st) == 0;
    if (!ok || (disp == 1 && exists)) { last_error = !ok ? 2 : 80; RET(0xffffffffu); }
    if (!exists || disp == 2 || disp == 5) {
        if (!(acc & 0x40000000u)) { last_error = 2; RET(0xffffffffu); }
        int fd = open(h, O_RDWR | O_CREAT | O_TRUNC, 0644);
        if (fd < 0) { last_error = 5; RET(0xffffffffu); }
        close(fd);
    }
    int fd = open(h, (acc & 0x40000000u) ? O_RDWR : O_RDONLY);
    if (fd < 0) { last_error = 5; RET(0xffffffffu); }
    files_opened++;
    if (!file_first_data[0]) {
        const char *dot = strrchr(win, '.');
        if (!dot || (strcasecmp(dot, ".ini") && strcasecmp(dot, ".exe") && strcasecmp(dot, ".dll"))) snprintf(file_first_data, sizeof file_first_data, "%s", win);
    }
    FileObj *f = (FileObj *)calloc(1, sizeof *f);
    snprintf(f->path, sizeof f->path, "%s", h);
    f->fd = fd;
    RET(rc_handle_new(RC_H_FILE, f));
}
static FileObj *file_of(uint32_t h) { return (FileObj *)rc_handle_obj(h, RC_H_FILE); }
API(ReadFile)
{
    (void)r;
    FileObj *f = file_of(a[0]);
    if (!f) { last_error = 6; RET(0); }
    uint32_t want = a[2], got = 0;
    void *direct = want ? rc_ptr(a[1], want) : NULL;
    if (direct) {
        ssize_t n = pread(f->fd, direct, want, (off_t)f->pos);
        got = n < 0 ? 0 : (uint32_t)n;
    } else {
        uint8_t tmp[65536];
        while (got < want) {
            uint32_t chunk = want - got < sizeof tmp ? want - got : (uint32_t)sizeof tmp;
            ssize_t n = pread(f->fd, tmp, chunk, (off_t)(f->pos + got));
            if (n <= 0) break;
            rc_write(a[1] + got, tmp, (size_t)n);
            got += (uint32_t)n;
            if ((uint32_t)n < chunk) break;
        }
    }
    f->pos += got;
    if (a[3]) rc_w32(a[3], got);
    RET(1);
}
API(WriteFile)
{
    (void)r;
    FileObj *f = file_of(a[0]);
    if (!f) {
        if (a[0] == 0x13 || a[0] == 0x17) RET(1);
        last_error = 6; RET(0);
    }
    uint32_t n = a[2];
    uint8_t *tmp = (uint8_t *)malloc(n ? n : 1u);
    rc_read(a[1], tmp, n);
    ssize_t w = pwrite(f->fd, tmp, n, (off_t)f->pos);
    free(tmp);
    if (w < 0) { last_error = 29; RET(0); }
    f->pos += n;
    if (a[3]) rc_w32(a[3], n);
    RET(1);
}
API(SetFilePointer)
{
    (void)r;
    FileObj *f = file_of(a[0]);
    if (!f) { last_error = 6; RET(0xffffffffu); }
    int64_t d = (int32_t)a[1];
    struct stat st;
    int64_t size = fstat(f->fd, &st) == 0 ? (int64_t)st.st_size : 0;
    int64_t base = a[3] == 0 ? 0 : a[3] == 1 ? f->pos : size;
    f->pos = base + d < 0 ? 0 : base + d;
    if (a[2]) rc_w32(a[2], 0);
    RET((uint32_t)f->pos);
}
API(GetFileSize)
{
    (void)r;
    FileObj *f = file_of(a[0]);
    if (!f) { last_error = 6; RET(0xffffffffu); }
    struct stat st;
    if (a[1]) rc_w32(a[1], 0);
    RET(fstat(f->fd, &st) == 0 ? (uint32_t)st.st_size : 0);
}
API(CloseHandle)
{
    (void)r;
    FileObj *f = file_of(a[0]);
    if (f) { close(f->fd); free(f); }
    else if (rc_handle_kind(a[0]) == RC_H_EVENT) free(rc_handle_obj(a[0], RC_H_EVENT));
    rc_handle_close(a[0]);
    RET(1);
}

/* events: manual/auto reset flag and signalled state; the single guest thread waits on the virtual clock or on real time */
typedef struct Event { int manual, set; } Event;
API(CreateEventA)
{
    (void)r;
    Event *e = (Event *)calloc(1, sizeof *e);
    e->manual = (int)a[1]; e->set = (int)a[2];
    RET(rc_handle_new(RC_H_EVENT, e));
}
static Event *event_of(uint32_t h) { return (Event *)rc_handle_obj(h, RC_H_EVENT); }
void rc_event_set(uint32_t h) { Event *e = event_of(h); if (e) e->set = 1; }
static int wait_one(uint32_t h)
{
    Event *e = event_of(h);
    if (e) {
        if (e->set) { if (!e->manual) e->set = 0; return 1; }
        return 0;
    }
    return 1;                                                 /* other handles (threads, processes) count as signalled */
}
API(SetEvent) { (void)r; Event *e = event_of(a[0]); if (e) e->set = 1; RET(1); }
API(ResetEvent) { (void)r; Event *e = event_of(a[0]); if (e) e->set = 0; RET(1); }

/* a wait that did not succeed at once: virtual time just passes; real time polls until the timeout */
static uint32_t wait_timeout_loop(uint32_t ms, int (*test)(const uint32_t *, int *), const uint32_t *ctx, int *which)
{
    if (rc_clock_is_virtual()) { rc_clock_advance(ms != 0xffffffffu ? ms : 5u); return 0x102; }
    uint32_t start = rc_clock();
    for (;;) {
        check_stop();
        if (poll_hook) poll_hook();
        rc_dsound_tick();
        if (test(ctx, which)) return 0;
        if (ms != 0xffffffffu && rc_clock() - start >= ms) return 0x102;
        do_sleep(1);
    }
}
static int test_one(const uint32_t *ctx, int *which) { (void)which; return wait_one(ctx[0]); }
API(WaitForSingleObject)
{
    (void)r;
    rc_dsound_tick();
    if (wait_one(a[0])) RET(0);
    uint32_t ctx[1] = {a[0]};
    RET(wait_timeout_loop(a[1], test_one, ctx, NULL));
}
static int wait_many_test(uint32_t n, uint32_t ptr, int wait_all, int *which)
{
    uint32_t hs[64];
    if (n > 64) n = 64;
    for (uint32_t i = 0; i < n; i++) hs[i] = rc_u32(ptr + 4u * i);
    if (wait_all) {
        for (uint32_t i = 0; i < n; i++) { Event *e = event_of(hs[i]); if (e && !e->set) return 0; }
        for (uint32_t i = 0; i < n; i++) wait_one(hs[i]);
        *which = 0;
        return 1;
    }
    for (uint32_t i = 0; i < n; i++) if (wait_one(hs[i])) { *which = (int)i; return 1; }
    return 0;
}
API(WaitForMultipleObjects)
{
    (void)r;
    rc_dsound_tick();
    int which = 0;
    if (wait_many_test(a[0], a[1], (int)a[2], &which)) RET((uint32_t)which);
    if (rc_clock_is_virtual()) RET(wait_timeout_loop(a[3], NULL, NULL, NULL));
    uint32_t start = rc_clock();
    for (;;) {
        check_stop();
        if (poll_hook) poll_hook();
        rc_dsound_tick();
        if (wait_many_test(a[0], a[1], (int)a[2], &which)) RET((uint32_t)which);
        if (a[3] != 0xffffffffu && rc_clock() - start >= a[3]) RET(0x102);
        do_sleep(1);
    }
}

typedef struct FindObj { char dir[1536]; char **names; int count, idx; } FindObj;
static void find_data(uint32_t out, const char *dir, const char *name)
{
    char path[2048];
    snprintf(path, sizeof path, "%s/%s", dir, name);
    struct stat st;
    uint8_t buf[318];
    memset(buf, 0, sizeof buf);
    uint32_t attr = 0x80, size = 0;
    if (stat(path, &st) == 0) { attr = S_ISDIR(st.st_mode) ? 0x10 : 0x80; size = (uint32_t)st.st_size; }
    memcpy(buf, &attr, 4);
    memcpy(buf + 32, &size, 4);
    strncpy((char *)buf + 44, name, 259);
    rc_write(out, buf, sizeof buf);
}
static int name_cmp(const void *x, const void *y) { return strcmp(*(char *const *)x, *(char *const *)y); }
API(FindFirstFileA)
{
    (void)r;
    char win[1024], hd[1536];
    rc_cstr(a[0], win, sizeof win);
    fs_log("find", win);
    char *bs = strrchr(win, '\\');
    char dirpart[1024] = "", pat[260];
    if (bs) { snprintf(pat, sizeof pat, "%s", bs + 1); *bs = 0; snprintf(dirpart, sizeof dirpart, "%s", win); }
    else snprintf(pat, sizeof pat, "%s", win);
    if (!fs_path(dirpart[0] ? dirpart : "C:\\GAME", 1, hd, sizeof hd)) { last_error = 2; RET(0xffffffffu); }
    DIR *d = opendir(hd);
    char **names = NULL;
    int count = 0, cap = 0;
    if (d) {
        struct dirent *e;
        while ((e = readdir(d))) {
            if (!strcmp(e->d_name, ".") || !strcmp(e->d_name, "..")) continue;
            if (!wild(pat, e->d_name)) continue;
            if (count == cap) { cap = cap ? cap * 2 : 16; names = (char **)realloc(names, (size_t)cap * sizeof *names); }
            names[count++] = strdup(e->d_name);
        }
        closedir(d);
    }
    if (!count) { free(names); last_error = 2; RET(0xffffffffu); }
    qsort(names, (size_t)count, sizeof *names, name_cmp);
    FindObj *f = (FindObj *)calloc(1, sizeof *f);
    snprintf(f->dir, sizeof f->dir, "%s", hd);
    f->names = names; f->count = count; f->idx = 1;
    find_data(a[1], hd, names[0]);
    RET(rc_handle_new(RC_H_FIND, f));
}
API(FindNextFileA)
{
    (void)r;
    FindObj *f = (FindObj *)rc_handle_obj(a[0], RC_H_FIND);
    if (!f || f->idx >= f->count) { last_error = 18; RET(0); }
    find_data(a[1], f->dir, f->names[f->idx++]);
    RET(1);
}
API(FindClose) { UNUSED; RET(1); }
API(GetPrivateProfileIntA)
{
    (void)r;
    char sec[128], key[128], path[1024], h[1536], v[512];
    rc_cstr(a[0], sec, sizeof sec); rc_cstr(a[1], key, sizeof key);
    if (a[3] && rc_cstr(a[3], path, sizeof path) && fs_path(path, 1, h, sizeof h) && ini_get(h, sec, key, v, sizeof v)) {
        char *end;
        long x = strtol(v, &end, 0);
        while (*end == ' ') end++;
        if (end != v && !*end) RET((uint32_t)x);
    }
    RET(a[2]);
}
API(GetPrivateProfileStringA)
{
    (void)r;
    char sec[128] = "", key[128] = "", path[1024], h[1536], v[1024], dflt[1024] = "";
    int found = 0;
    if (a[0] && a[1]) {
        rc_cstr(a[0], sec, sizeof sec); rc_cstr(a[1], key, sizeof key);
        if (a[5] && rc_cstr(a[5], path, sizeof path) && fs_path(path, 1, h, sizeof h)) found = ini_get(h, sec, key, v, sizeof v);
    }
    if (!found) { if (a[2]) rc_cstr(a[2], dflt, sizeof dflt); snprintf(v, sizeof v, "%s", dflt); }
    uint32_t cap = a[4], n = (uint32_t)strlen(v);
    if (cap == 0) RET(0);
    if (n > cap - 1) n = cap - 1;
    rc_write(a[3], v, n);
    rc_wr(a[3] + n, 1, 0);
    RET(n);
}
API(WritePrivateProfileStringA) { UNUSED; RET(1); }
API(GetDriveTypeA) { UNUSED; RET(3); }
API(GetLogicalDrives) { UNUSED; RET(4); }
API(MessageBoxA)
{
    (void)r; (void)ret;
    char text[512] = "", cap[128] = "";
    if (a[1]) rc_cstr(a[1], text, sizeof text);
    if (a[2]) rc_cstr(a[2], cap, sizeof cap);
    rc_log("  MessageBoxA('%s', '%s')", text, cap);
    rc_abort("MessageBoxA: '%s'", text);
}
API(SHGetSpecialFolderPathA)
{
    (void)r;
    char win[64], h[1536];
    snprintf(win, sizeof win, "C:\\GAME\\Documents%d", SARG(2));
    rc_put_cstr(a[1], win);
    if (fs_path(win, 0, h, sizeof h)) mkdir(h, 0755);
    RET(1);
}
API(CreateDirectoryA)
{
    (void)r;
    char win[1024], h[1536];
    rc_cstr(a[0], win, sizeof win);
    fs_log("mkdir", win);
    if (!fs_path(win, 0, h, sizeof h)) { last_error = 3; RET(0); }
    struct stat st;
    if (stat(h, &st) == 0) { last_error = 183; RET(0); }
    RET(mkdir(h, 0755) == 0 ? 1 : 0);
}
static void systemtime(uint32_t out)
{
    time_t now = time(NULL);
    struct tm t;
    localtime_r(&now, &t);
    uint16_t v[8] = {(uint16_t)(t.tm_year + 1900), (uint16_t)(t.tm_mon + 1), (uint16_t)t.tm_wday, (uint16_t)t.tm_mday, (uint16_t)t.tm_hour, (uint16_t)t.tm_min, (uint16_t)t.tm_sec, 0};
    rc_write(out, v, sizeof v);
}
API(GetLocalTime) { (void)r; systemtime(a[0]); RET(0); }

/* ------------------------------------------------------------------ resources, strings, version info */
API(LoadStringA)
{
    (void)r;
    char s[1024] = "";
    uint32_t sid = a[1], va, size;
    if (res_find(NULL, 6, NULL, (sid >> 4) + 1u, &va, &size)) {
        uint32_t pos = va;
        for (uint32_t i = 0; i < 16 && pos < va + size; i++) {
            uint32_t ln = rc_u16(pos);
            pos += 2;
            if (i == (sid & 15u)) {
                size_t k = 0;
                for (; k < ln && k < sizeof s - 1; k++) { uint32_t c = rc_u16(pos + 2u * (uint32_t)k); s[k] = (char)(c > 255u ? '?' : c); }
                s[k] = 0;
                break;
            }
            pos += 2u * ln;
        }
    }
    rc_log("  LoadStringA(%u) -> '%s'", sid, s);
    uint32_t n = (uint32_t)strlen(s);
    if (a[3] == 0) RET(0);
    if (n > a[3] - 1) n = a[3] - 1;
    rc_write(a[2], s, n);
    rc_wr(a[2] + n, 1, 0);
    RET(n);
}
typedef struct ResObj { uint32_t va, size; } ResObj;
API(FindResourceA)
{
    (void)r;
    char n[128], t[128];
    str_arg(a[1], n, sizeof n); str_arg(a[2], t, sizeof t);
    rc_log("  FindResourceA('%s', '%s')", n, t);
    uint32_t va, size;
    if (!res_find(a[2] >= 0x10000u ? t : NULL, a[2], a[1] >= 0x10000u ? n : NULL, a[1], &va, &size)) RET(0);
    ResObj *o = (ResObj *)calloc(1, sizeof *o);
    o->va = va; o->size = size;
    RET(rc_handle_new(RC_H_RES, o));
}
API(LoadResource) { (void)r; RET(a[1]); }
API(LockResource) { (void)r; ResObj *o = (ResObj *)rc_handle_obj(a[0], RC_H_RES); RET(o ? o->va : 0); }
API(SizeofResource) { (void)r; ResObj *o = (ResObj *)rc_handle_obj(a[1], RC_H_RES); RET(o ? o->size : 0); }
API(MultiByteToWideChar)
{
    (void)r;
    uint32_t n = a[3], src = a[2], dst = a[4], dn = a[5], len;
    char tmp[4096];
    if (n == 0xffffffffu) { len = (uint32_t)rc_cstr(src, tmp, sizeof tmp) + 1u; } else { len = n > sizeof tmp ? (uint32_t)sizeof tmp : n; rc_read(src, tmp, len); }
    if (dn) for (uint32_t i = 0; i < len && i < dn; i++) rc_w16(dst + 2u * i, (uint32_t)(unsigned char)tmp[i]);
    RET(len);
}
API(WideCharToMultiByte)
{
    (void)r;
    uint32_t n = a[3], src = a[2], dst = a[4], dn = a[5], len = 0;
    char tmp[4096];
    if (n == 0xffffffffu) { len = (uint32_t)rc_wstr(src, tmp, sizeof tmp) + 1u; }
    else { len = n > sizeof tmp ? (uint32_t)sizeof tmp : n; for (uint32_t i = 0; i < len; i++) { uint32_t c = rc_u16(src + 2u * i); tmp[i] = (char)(c > 255u ? '?' : c); } }
    if (dn) rc_write(dst, tmp, len < dn ? len : dn);
    RET(len);
}
API(GetStringTypeA)
{
    (void)r;
    uint32_t src = a[2], n = a[3], out = a[4];
    for (uint32_t i = 0; i < (n != 0xffffffffu ? n : 0); i++) {
        uint32_t c = rc_rd(src + i, 1), v = 0;
        if (c >= 48 && c <= 57) v |= 0x4 | 0x80;
        if (c >= 65 && c <= 90) v |= 0x1 | 0x100 | 0x80;
        if (c >= 97 && c <= 122) v |= 0x2 | 0x100 | 0x80;
        if (c == 32 || c == 9 || c == 10 || c == 13) v |= 0x8 | 0x40;
        if ((c >= 33 && c <= 47) || (c >= 58 && c <= 64)) v |= 0x10;
        rc_w16(out + 2u * i, v);
    }
    RET(1);
}
API(GetStringTypeW)
{
    uint32_t b[5] = {0, a[0], a[1], a[2], a[3]};
    return api_GetStringTypeA(r, b, ret);
}
API(GetStringTypeExA) { return api_GetStringTypeA(r, a, ret); }
API(LCMapStringA)
{
    (void)r;
    uint32_t flags = a[1], n = a[3], src = a[2], dst = a[4], dn = a[5], len;
    char tmp[4096];
    if (n == 0xffffffffu) len = (uint32_t)rc_cstr(src, tmp, sizeof tmp) + 1u; else { len = n > sizeof tmp ? (uint32_t)sizeof tmp : n; rc_read(src, tmp, len); }
    for (uint32_t i = 0; i < len; i++) {
        if (flags & 0x100) tmp[i] = (char)tolower((unsigned char)tmp[i]);
        if (flags & 0x200) tmp[i] = (char)toupper((unsigned char)tmp[i]);
    }
    if (dn) rc_write(dst, tmp, len < dn ? len : dn);
    RET(len);
}
API(IsBad) { UNUSED; RET(0); }
API(GetUserDefaultLCID) { UNUSED; RET(0x409); }
API(GetLocaleInfoA) { (void)r; if (a[3]) rc_write(a[2], "1\0", a[3] >= 2 ? 2 : a[3]); RET(2); }
API(InterlockedIncrement) { (void)r; uint32_t v = rc_u32(a[0]) + 1u; rc_w32(a[0], v); RET(v); }
API(InterlockedDecrement) { (void)r; uint32_t v = rc_u32(a[0]) - 1u; rc_w32(a[0], v); RET(v); }
API(InterlockedExchange) { (void)r; uint32_t old = rc_u32(a[0]); rc_w32(a[0], a[1]); RET(old); }
API(lstrlenA) { (void)r; char s[4096]; RET(rc_cstr(a[0], s, sizeof s)); }
API(lstrcpyA) { (void)r; char s[4096]; rc_cstr(a[1], s, sizeof s); rc_put_cstr(a[0], s); RET(a[0]); }
API(lstrcpynA)
{
    (void)r;
    char s[4096];
    rc_cstr(a[1], s, sizeof s);
    if (a[2]) { size_t n = strlen(s); if (n > a[2] - 1u) n = a[2] - 1u; rc_write(a[0], s, n); rc_wr(a[0] + (uint32_t)n, 1, 0); }
    RET(a[0]);
}
API(lstrcatA) { (void)r; char d[4096], s[4096]; size_t n = rc_cstr(a[0], d, sizeof d); rc_cstr(a[1], s, sizeof s); rc_put_cstr(a[0] + (uint32_t)n, s); RET(a[0]); }
API(lstrcmpA) { (void)r; char x[4096], y[4096]; rc_cstr(a[0], x, sizeof x); rc_cstr(a[1], y, sizeof y); int c = strcmp(x, y); RET(c < 0 ? -1 : c > 0 ? 1 : 0); }
API(lstrcmpiA) { (void)r; char x[4096], y[4096]; rc_cstr(a[0], x, sizeof x); rc_cstr(a[1], y, sizeof y); int c = strcasecmp(x, y); RET(c < 0 ? -1 : c > 0 ? 1 : 0); }
API(CharUpperA)
{
    (void)r;
    if (a[0] >= 0x10000u) { char s[4096]; rc_cstr(a[0], s, sizeof s); for (char *p = s; *p; p++) *p = (char)toupper((unsigned char)*p); rc_put_cstr(a[0], s); RET(a[0]); }
    RET(toupper((int)(a[0] & 0xffu)));
}
API(CharNextA) { (void)r; RET(a[0] + (rc_rd(a[0], 1) ? 1u : 0u)); }
API(GetTimeZoneInformation) { (void)r; rc_zero(a[0], 172); RET(0); }
API(GetComputerNameA) { (void)r; rc_put_cstr(a[0], "SPIKE"); rc_w32(a[1], 5); RET(1); }
API(GlobalMemoryStatus)
{
    (void)r;
    uint32_t v[8] = {32, 40, 512u << 20, 300u << 20, 1024u << 20, 900u << 20, 2047u << 20, 1900u << 20};
    rc_write(a[0], v, sizeof v);
    RET(0);
}
API(GetProcessVersion) { UNUSED; RET(0x00050001); }
API(RaiseException) { (void)r; (void)ret; rc_abort("RaiseException(0x%08x) (a C++ throw or a fault)", a[0]); }
API(SetThreadPriority) { UNUSED; RET(1); }
API(GetKeyboardLayout) { UNUSED; RET(0x04090409u); }
API(RegisterWindowMessageA)
{
    (void)r;
    char s[256];
    rc_cstr(a[0], s, sizeof s);
    uint32_t h = 5381;
    for (char *p = s; *p; p++) h = h * 33u + (uint8_t)*p;
    RET(0xc100u + (h & 0xffu));
}

static uint8_t *ver_block;
static uint32_t ver_len;
static void ver_load(void)
{
    if (ver_block) return;
    uint32_t va, size;
    ver_block = (uint8_t *)calloc(1, 1);
    if (res_first_of_type(16, &va, &size)) {
        ver_block = (uint8_t *)malloc(size);
        rc_read(va, ver_block, size);
        ver_len = size;
    }
}
API(GetFileVersionInfoSizeA) { (void)r; if (a[1]) rc_zero(a[1], 4); ver_load(); RET(ver_len); }
API(GetFileVersionInfoA)
{
    (void)r;
    ver_load();
    uint32_t n = a[2] < ver_len ? a[2] : ver_len;
    rc_write(a[3], ver_block, n);
    RET(n ? 1 : 0);
}
/* one VS_VERSIONINFO / StringFileInfo / StringTable / String node */
typedef struct VerNode { uint32_t length, vlen, typ, voff, vbytes, coff; char key[128]; } VerNode;
static int ver_node(const uint8_t *blk, uint32_t n, uint32_t off, VerNode *o)
{
    if (off + 8 > n) return 0;
    o->length = blk[off] | (uint32_t)blk[off + 1] << 8;
    o->vlen = blk[off + 2] | (uint32_t)blk[off + 3] << 8;
    o->typ = blk[off + 4] | (uint32_t)blk[off + 5] << 8;
    uint32_t k = off + 6;
    while (k + 1 < n && !(blk[k] == 0 && blk[k + 1] == 0)) k++;
    uint32_t key_end = k;
    if ((key_end - (off + 6)) % 2) key_end++;
    size_t kl = 0;
    for (uint32_t i = off + 6; i + 1 < key_end && kl < sizeof o->key - 1; i += 2) o->key[kl++] = (char)blk[i];
    o->key[kl] = 0;
    o->voff = (key_end + 2 + 3) & ~3u;
    o->vbytes = o->vlen * (o->typ == 1 ? 2u : 1u);
    o->coff = (o->voff + o->vbytes + 3) & ~3u;
    return 1;
}
API(VerQueryValueA)
{
    (void)r;
    uint8_t blk[4096];
    rc_read(a[0], blk, sizeof blk);
    char sub[256], *parts[16];
    rc_cstr(a[1], sub, sizeof sub);
    int np = 0;
    for (char *tok = strtok(sub, "\\"); tok && np < 16; tok = strtok(NULL, "\\")) parts[np++] = tok;
    VerNode root;
    if (!ver_node(blk, sizeof blk, 0, &root)) RET(0);
    uint32_t end = blk[0] | (uint32_t)blk[1] << 8;
    if (!np) { rc_w32(a[2], a[0] + root.voff); rc_w32(a[3], root.vbytes); RET(1); }
    uint32_t node_off = root.coff, node_end = end, last_voff = 0, last_vb = 0;
    for (int i = 0; i < np; i++) {
        int found = 0;
        for (uint32_t o = node_off; o + 6 <= node_end;) {
            VerNode nd;
            if (!ver_node(blk, sizeof blk, o, &nd) || nd.length == 0) break;
            if (!strcasecmp(nd.key, parts[i])) {
                found = 1; last_voff = nd.voff; last_vb = nd.vbytes; node_off = nd.coff; node_end = o + nd.length;
                break;
            }
            o += (nd.length + 3) & ~3u;
        }
        if (!found) RET(0);
    }
    rc_w32(a[2], a[0] + last_voff);
    rc_w32(a[3], strcasecmp(parts[0], "stringfileinfo") ? last_vb : (last_vb / 2 ? last_vb / 2 : last_vb));
    RET(1);
}

/* ------------------------------------------------------------------ USER32: classes, windows, messages */
API(LoadCursorA) { UNUSED; if (!cursor_h) cursor_h = rc_handle_new(RC_H_CURSOR, NULL); RET(cursor_h); }
API(LoadIconA) { UNUSED; if (!icon_h) icon_h = rc_handle_new(RC_H_ICON, NULL); RET(icon_h); }
API(LoadImageA) { UNUSED; if (!image_h) image_h = rc_handle_new(RC_H_IMAGE, NULL); RET(image_h); }
API(LoadAcceleratorsA) { UNUSED; if (!accel_h) accel_h = rc_handle_new(RC_H_ACCEL, NULL); RET(accel_h); }
API(GdiHandle) { UNUSED; if (!gdi_h) gdi_h = rc_handle_new(RC_H_GDI, NULL); RET(gdi_h); }
API(GetSystemMenu) { UNUSED; if (!menu_h) menu_h = rc_handle_new(RC_H_MENU, NULL); RET(menu_h); }

static uint32_t register_class(uint32_t proc, uint32_t name_ptr, const char *what)
{
    char n[64];
    str_arg(name_ptr, n, sizeof n);
    uint32_t atom = 0xc000u + (uint32_t)class_count;
    if (class_count < 32) {
        snprintf(classes[class_count].name, sizeof classes[class_count].name, "%s", n);
        classes[class_count].atom = atom; classes[class_count].proc = proc;
        class_count++;
    }
    rc_log("  %s('%s', proc=0x%x)", what, n, proc);
    return atom;
}
API(RegisterClassA) { (void)r; RET(register_class(rc_u32(a[0] + 4), rc_u32(a[0] + 36), "RegisterClassA")); }
API(RegisterClassExA) { (void)r; RET(register_class(rc_u32(a[0] + 8), rc_u32(a[0] + 40), "RegisterClassExA")); }
static WndClass *class_find(uint32_t name_ptr)
{
    char n[64];
    str_arg(name_ptr, n, sizeof n);
    for (int i = 0; i < class_count; i++)
        if (name_ptr >= 0x10000u ? !strcmp(classes[i].name, n) : classes[i].atom == name_ptr) return &classes[i];
    return NULL;
}
API(GetClassInfoA) { (void)r; RET(class_find(a[1]) ? 1 : 0); }

static void show_window(uint32_t hwnd)
{
    Window *w = wnd(hwnd);
    if (!w || w->visible) return;
    w->visible = 1;
    send_msg(hwnd, 0x0018, 1, 0);                                                    /* WM_SHOWWINDOW */
    send_msg(hwnd, 0x0005, 0, ((uint32_t)(w->rect[3] - w->rect[1]) << 16) | ((uint32_t)(w->rect[2] - w->rect[0]) & 0xffffu));   /* WM_SIZE */
    send_msg(hwnd, 0x001c, 1, 0);                                                    /* WM_ACTIVATEAPP */
    send_msg(hwnd, 0x0086, 1, 0);                                                    /* WM_NCACTIVATE */
    send_msg(hwnd, 0x0006, 1, 0);                                                    /* WM_ACTIVATE */
    send_msg(hwnd, 0x0007, 0, 0);                                                    /* WM_SETFOCUS */
    rc_msg_post(hwnd, 0x000f, 0, 0);                                                 /* WM_PAINT */
}

API(CreateWindowExA)
{
    (void)r;
    char cls[64], title[128] = "";
    str_arg(a[1], cls, sizeof cls);
    if (a[2]) rc_cstr(a[2], title, sizeof title);
    int32_t x = SARG(4), y = SARG(5), w = SARG(6), h = SARG(7);
    if (a[4] == 0x80000000u) x = 0;
    if (a[5] == 0x80000000u) y = 0;
    if (a[6] == 0x80000000u) w = 640;
    if (a[7] == 0x80000000u) h = 480;
    Window *wn = (Window *)calloc(1, sizeof *wn);
    uint32_t hwnd = rc_handle_new(RC_H_WINDOW, wn);
    WndClass *wc = class_find(a[1]);
    wn->hwnd = hwnd; wn->proc = wc ? wc->proc : 0; wn->style = a[3]; wn->ex = a[0]; wn->parent = a[8];
    wn->id = a[8] ? a[9] : 0;
    snprintf(wn->cls, sizeof wn->cls, "%s", cls);
    snprintf(wn->title, sizeof wn->title, "%s", title);
    wn->rect[0] = x; wn->rect[1] = y; wn->rect[2] = x + w; wn->rect[3] = y + h;
    rc_log("  CreateWindowExA(class='%s', title='%s', style=0x%x, %dx%d) -> hwnd 0x%x", cls, title, a[3], w, h, hwnd);
    if (strstr(title, "Nancy Drew")) rc_main_hwnd = hwnd;
    uint32_t cs = rc_alloc(48);
    rc_w32(cs, a[11]); rc_w32(cs + 4, a[10]); rc_w32(cs + 8, a[9]); rc_w32(cs + 12, a[8]);
    rc_w32(cs + 16, (uint32_t)h); rc_w32(cs + 20, (uint32_t)w); rc_w32(cs + 24, (uint32_t)y); rc_w32(cs + 28, (uint32_t)x);
    rc_w32(cs + 32, a[3]); rc_w32(cs + 36, a[2]); rc_w32(cs + 40, a[1]); rc_w32(cs + 44, a[0]);
    if (hooks[5]) {                                       /* WH_CBT: MFC attaches its CWnd and subclasses here */
        uint32_t cbt = rc_alloc(8);
        rc_w32(cbt, cs); rc_w32(cbt + 4, 0);
        uint32_t args[3] = {3, hwnd, cbt};                /* HCBT_CREATEWND */
        rc_call(hooks[5], 3, args, 0);
    }
    if (wn->proc) {
        send_msg(hwnd, 0x0081, 0, cs);                    /* WM_NCCREATE */
        send_msg(hwnd, 0x0001, 0, cs);                    /* WM_CREATE */
    }
    if (a[3] & 0x10000000u) show_window(hwnd);            /* WS_VISIBLE */
    RET(hwnd);
}
API(DestroyWindow)
{
    (void)r;
    if (wnd(a[0])) { send_msg(a[0], 0x0002, 0, 0); send_msg(a[0], 0x0082, 0, 0); }
    RET(1);
}
API(CallWindowProcA) { (void)r; uint32_t args[4] = {a[1], a[2], a[3], a[4]}; RET(rc_call(a[0], 4, args, 0)); }
API(SetWindowsHookExA)
{
    (void)r;
    if (a[0] < 16) hooks[a[0]] = a[1];
    RET(rc_handle_new(RC_H_HOOK, (void *)(uintptr_t)(a[0] + 1u)));
}
API(UnhookWindowsHookEx)
{
    (void)r;
    uintptr_t k = (uintptr_t)rc_handle_obj(a[0], RC_H_HOOK);
    if (k && k - 1 < 16) hooks[k - 1] = 0;
    RET(1);
}
API(SendMessageA) { (void)r; RET(send_msg(a[0], a[1], a[2], a[3])); }
API(PostMessageA) { (void)r; rc_msg_post(a[0], a[1], a[2], a[3]); RET(1); }
API(PostQuitMessage) { (void)r; rc_msg_post(0, 0x0012, a[0], 0); RET(0); }
API(DefWindowProcA) { (void)r; RET(a[1] == 0x0081 ? 1 : 0); }
static const char *gwl_key(int32_t i) { return i == -4 ? "proc" : i == -16 ? "style" : i == -20 ? "ex" : i == -21 ? "user" : i == -12 ? "id" : NULL; }
static uint32_t *gwl_slot(Window *w, int32_t i)
{
    return i == -4 ? &w->proc : i == -16 ? &w->style : i == -20 ? &w->ex : i == -21 ? &w->user : i == -12 ? &w->id : NULL;
}
API(SetWindowLongA)
{
    (void)r;
    Window *w = wnd(a[0]);
    if (!w) RET(0);
    uint32_t *slot = gwl_slot(w, SARG(1));
    if (!slot) RET(0);
    uint32_t old = *slot;
    *slot = a[2];
    if (SARG(1) == -4) rc_log("  subclass hwnd 0x%x: proc 0x%x -> 0x%x", a[0], old, a[2]);
    (void)gwl_key;
    RET(old);
}
API(GetWindowLongA)
{
    (void)r;
    Window *w = wnd(a[0]);
    if (!w) RET(0);
    uint32_t *slot = gwl_slot(w, SARG(1));
    RET(slot ? *slot : 0);
}
API(ShowWindow) { (void)r; rc_log("  ShowWindow(0x%x, %d)", a[0], SARG(1)); if (a[1] && wnd(a[0])) show_window(a[0]); RET(0); }
API(UpdateWindow) { (void)r; send_msg(a[0], 0x000f, 0, 0); RET(1); }
API(InvalidateRect) { (void)r; if (!mq_has(a[0], 0x000f)) rc_msg_post(a[0], 0x000f, 0, 0); RET(1); }
API(BeginPaint)
{
    (void)r;
    Window *w = wnd(a[0]);
    int32_t wd = w ? w->rect[2] - w->rect[0] : 640, ht = w ? w->rect[3] - w->rect[1] : 480;
    if (!dc_handle) dc_handle = rc_handle_new(RC_H_DC, NULL);
    uint32_t ps[6] = {dc_handle, 0, 0, 0, (uint32_t)wd, (uint32_t)ht};
    rc_zero(a[1], 64);
    rc_write(a[1], ps, sizeof ps);
    RET(dc_handle);
}
API(GetClientRect)
{
    (void)r;
    Window *w = wnd(a[0]);
    int32_t v[4] = {0, 0, w ? w->rect[2] - w->rect[0] : 640, w ? w->rect[3] - w->rect[1] : 480};
    rc_write(a[1], v, sizeof v);
    RET(1);
}
API(GetWindowRect)
{
    (void)r;
    Window *w = wnd(a[0]);
    int32_t d[4] = {0, 0, 640, 480};
    rc_write(a[1], w ? w->rect : d, 16);
    RET(1);
}
API(SetFocus) { (void)r; uint32_t old = focus; focus = a[0]; RET(old); }
API(GetFocus) { UNUSED; RET(focus); }
API(IsWindow) { (void)r; RET(wnd(a[0]) ? 1 : 0); }
API(IsWindowVisible) { (void)r; Window *w = wnd(a[0]); RET(w && w->visible ? 1 : 0); }
API(GetParent) { (void)r; Window *w = wnd(a[0]); RET(w ? w->parent : 0); }
API(SetWindowPos)
{
    (void)r;
    Window *w = wnd(a[0]);
    uint32_t flags = a[6];
    if (w && !(flags & 1u)) {
        int32_t cx = SARG(4), cy = SARG(5), ww = w->rect[2] - w->rect[0], hh = w->rect[3] - w->rect[1];
        w->rect[0] = SARG(2); w->rect[1] = SARG(3);
        w->rect[2] = SARG(2) + ((flags & 2u) ? ww : cx); w->rect[3] = SARG(3) + ((flags & 2u) ? hh : cy);
    }
    RET(1);
}
API(MoveWindow)
{
    (void)r;
    Window *w = wnd(a[0]);
    if (w) { w->rect[0] = SARG(1); w->rect[1] = SARG(2); w->rect[2] = SARG(1) + SARG(3); w->rect[3] = SARG(2) + SARG(4); }
    RET(1);
}
API(GetWindowTextA)
{
    (void)r;
    Window *w = wnd(a[0]);
    const char *t = w ? w->title : "";
    uint32_t n = (uint32_t)strlen(t);
    if (!a[2]) RET(0);
    if (n > a[2] - 1) n = a[2] - 1;
    rc_write(a[1], t, n);
    rc_wr(a[1] + n, 1, 0);
    RET(n);
}
API(GetWindowTextLengthA) { (void)r; Window *w = wnd(a[0]); RET(w ? strlen(w->title) : 0); }
API(SetTimer)
{
    (void)r;
    uint32_t id = a[1];
    int used = 0;
    for (int i = 0; i < 64; i++) if (timers[i].used) used++;
    if (!id) id = (uint32_t)used + 1u;
    int slot = -1;
    for (int i = 0; i < 64; i++) if (timers[i].used && timers[i].hwnd == a[0] && timers[i].id == id) { slot = i; break; }
    for (int i = 0; slot < 0 && i < 64; i++) if (!timers[i].used) slot = i;
    if (slot >= 0) timers[slot] = (Timer){a[0], id, a[2] ? a[2] : 1u, a[3], rc_clock(), 1};
    rc_log("  SetTimer(hwnd=0x%x, id=%u, %u ms)", a[0], id, a[2]);
    RET(id);
}
API(KillTimer)
{
    (void)r;
    for (int i = 0; i < 64; i++) if (timers[i].used && timers[i].hwnd == a[0] && timers[i].id == a[1]) timers[i].used = 0;
    RET(1);
}
API(PeekMessageA)
{
    (void)r;
    Msg m;
    if (!next_message(&m)) {
        if (rc_clock_is_virtual() && idle_polls > max_idle_polls) rc_abort("message loop idle for %u polls", idle_polls);
        RET(0);
    }
    fill_msg(a[0], m);
    if (!(a[4] & 1u)) mq_push_front(m);                   /* PM_NOREMOVE */
    RET(1);
}
API(GetMessageA)
{
    (void)r;
    Msg m;
    while (!next_message(&m))
        if (rc_clock_is_virtual() && idle_polls > max_idle_polls) rc_abort("message loop idle for %u polls", idle_polls);
    fill_msg(a[0], m);
    RET(m.msg == 0x0012 ? 0 : 1);
}
API(TranslateMessage) { UNUSED; RET(0); }
API(DispatchMessageA)
{
    (void)r;
    uint32_t hwnd = rc_u32(a[0]), m = rc_u32(a[0] + 4), wp = rc_u32(a[0] + 8), lp = rc_u32(a[0] + 12);
    if (m == 0x0113 && lp) {                              /* WM_TIMER with a TIMERPROC */
        uint32_t args[4] = {hwnd, m, wp, rc_clock()};
        RET(rc_call(lp, 4, args, 0));
    }
    RET(send_msg(hwnd, m, wp, lp));
}
API(FindWindowA) { UNUSED; RET(0); }
API(GetLastActivePopup) { (void)r; RET(a[0]); }
API(GetDesktopWindow) { UNUSED; RET(0x10); }
API(SystemParametersInfoA)
{
    (void)r;
    if (a[0] == 0x30 && a[2]) { int32_t v[4] = {0, 0, 1024, 768}; rc_write(a[2], v, sizeof v); }
    RET(1);
}
API(GetSysColor) { UNUSED; RET(0xc0c0c0u); }

/* input state the game polls instead of waiting for messages */
API(GetKeyState) { UNUSED; RET(0); }
API(GetAsyncKeyState)
{
    (void)r;
    uint32_t vk = a[0], now = rc_clock();
    if (vk == 1 && (btn_flag || now < btn_until)) RET(0x8001);
    if (vk < 256 && (key_flag[vk] || now < vk_down_until[vk])) RET(0x8001);
    RET(0);
}
API(SetCursorPos) { UNUSED; RET(1); }            /* the game re-centres the cursor every frame; the reported position stays */
API(GetCursorPos) { (void)r; rc_w32(a[0], (uint32_t)cursor_x); rc_w32(a[0] + 4, (uint32_t)cursor_y); RET(1); }
API(SetCursor) { UNUSED; RET(0); }
API(ShowCursor) { (void)r; cursor_count += a[0] ? 1 : -1; RET((uint32_t)cursor_count); }

/* rectangles */
API(SetRect) { (void)r; uint32_t v[4] = {a[1], a[2], a[3], a[4]}; rc_write(a[0], v, 16); RET(1); }
API(CopyRect) { (void)r; uint32_t v[4]; rc_read(a[1], v, 16); rc_write(a[0], v, 16); RET(1); }
API(IntersectRect)
{
    (void)r;
    int32_t p[4], q[4], o[4];
    rc_read(a[1], p, 16); rc_read(a[2], q, 16);
    o[0] = p[0] > q[0] ? p[0] : q[0]; o[1] = p[1] > q[1] ? p[1] : q[1];
    o[2] = p[2] < q[2] ? p[2] : q[2]; o[3] = p[3] < q[3] ? p[3] : q[3];
    if (o[2] <= o[0] || o[3] <= o[1]) { rc_zero(a[0], 16); RET(0); }
    rc_write(a[0], o, 16);
    RET(1);
}
API(PtInRect) { (void)r; int32_t p[4]; rc_read(a[0], p, 16); RET(p[0] <= SARG(1) && SARG(1) < p[2] && p[1] <= SARG(2) && SARG(2) < p[3]); }
API(IsRectEmpty) { (void)r; int32_t p[4]; rc_read(a[0], p, 16); RET(p[2] <= p[0] || p[3] <= p[1]); }
API(OffsetRect) { (void)r; int32_t p[4]; rc_read(a[0], p, 16); p[0] += SARG(1); p[2] += SARG(1); p[1] += SARG(2); p[3] += SARG(2); rc_write(a[0], p, 16); RET(1); }
API(SetRectEmpty) { (void)r; rc_zero(a[0], 16); RET(1); }

/* wsprintfA: cdecl, the extra arguments follow the format on the stack */
API(wsprintfA)
{
    char fmt[1024], out[4096];
    rc_cstr(a[1], fmt, sizeof fmt);
    uint32_t va = r->esp + 4u + 8u;
    size_t n = 0;
    out[0] = 0;
    for (const char *p = fmt; *p && n + 1 < sizeof out;) {
        if (*p != '%') { out[n++] = *p++; continue; }
        const char *q = p + 1;
        char spec[32];
        size_t sl = 0;
        spec[sl++] = '%';
        while (*q && strchr("-+ 0#", *q) && sl < 8) spec[sl++] = *q++;
        while (isdigit((unsigned char)*q) && sl < 14) spec[sl++] = *q++;
        if (*q == '.') { spec[sl++] = *q++; while (isdigit((unsigned char)*q) && sl < 20) spec[sl++] = *q++; }
        while (*q == 'l' || *q == 'h') q++;
        char conv = *q;
        if (!conv || !strchr("diuxXcsp%", conv)) { out[n++] = *p++; continue; }
        q++;
        if (conv == '%') { out[n++] = '%'; p = q; continue; }
        uint32_t v = rc_u32(va);
        va += 4;
        char piece[2048];
        if (conv == 's') {
            char s[1536] = "(null)";
            if (v) rc_cstr(v, s, sizeof s);
            spec[sl++] = 's'; spec[sl] = 0;
            snprintf(piece, sizeof piece, spec, s);
        } else if (conv == 'c') {
            spec[sl++] = 'c'; spec[sl] = 0;
            snprintf(piece, sizeof piece, spec, (int)(v & 0xffu));
        } else if (conv == 'd' || conv == 'i') {
            spec[sl++] = 'd'; spec[sl] = 0;
            snprintf(piece, sizeof piece, spec, (int)v);
        } else {
            spec[sl++] = conv == 'p' ? 'x' : conv; spec[sl] = 0;
            snprintf(piece, sizeof piece, spec, v);
        }
        for (const char *c = piece; *c && n + 1 < sizeof out; c++) out[n++] = *c;
        p = q;
    }
    out[n] = 0;
    rc_put_cstr(a[0], out);
    RET(n);
}

API(CoInitialize) { UNUSED; RET(0); }
API(GetObjectA) { UNUSED; RET(0); }

/* ------------------------------------------------------------------ the table */
typedef struct ApiEnt { const char *name; RcApiFn fn; } ApiEnt;
#define E(n) {#n, api_##n}
#define EA(n, f) {n, api_##f}
static const ApiEnt api_table[] = {
    E(GetVersion), E(GetVersionExA), E(HeapCreate), E(HeapDestroy), E(GetProcessHeap), E(HeapAlloc), E(HeapReAlloc), E(HeapFree), E(HeapSize),
    E(VirtualAlloc), E(VirtualFree), E(GlobalAlloc), E(LocalAlloc), E(GlobalLock), E(GlobalUnlock), E(GlobalFree), E(GlobalHandle),
    E(LocalReAlloc), E(GlobalReAlloc), E(LocalLock), E(LocalUnlock), E(LocalSize), EA("GlobalSize", LocalSize), E(GlobalFlags), E(LocalFree),
    E(GetCommandLineA), EA("GetEnvironmentStrings", GetEnvironmentStrings), EA("GetEnvironmentStringsA", GetEnvironmentStrings), E(GetEnvironmentStringsW),
    EA("FreeEnvironmentStringsA", FreeEnvironmentStrings), EA("FreeEnvironmentStringsW", FreeEnvironmentStrings), E(GetStartupInfoA),
    E(GetModuleHandleA), E(GetModuleFileNameA), E(GetProcAddress), E(LoadLibraryA), E(GetCurrentThreadId), E(GetCurrentProcessId),
    E(GetCurrentProcess), E(GetCurrentThread), E(TlsAlloc), E(TlsSetValue), E(TlsGetValue), E(TlsFree),
    EA("InitializeCriticalSection", CriticalSection), EA("EnterCriticalSection", CriticalSection), EA("LeaveCriticalSection", CriticalSection),
    EA("DeleteCriticalSection", CriticalSection), E(GetLastError), E(SetLastError), E(SetUnhandledExceptionFilter), E(UnhandledExceptionFilter),
    E(GetACP), E(GetOEMCP), E(GetCPInfo), E(GetStdHandle), E(GetFileType), E(SetHandleCount), E(ExitProcess), E(TerminateProcess), E(GetSystemInfo),
    E(QueryPerformanceFrequency), E(QueryPerformanceCounter), E(GetTickCount), EA("timeGetTime", GetTickCount), E(Sleep), E(GetKeyboardType),
    E(GetSystemMetrics), E(GetDC), EA("ReleaseDC", ReleaseDC), E(GetDeviceCaps), E(RegOpenKeyExA), E(RegCreateKeyExA), E(RegQueryValueExA),
    EA("RegSetValueExA", Zero), EA("RegCloseKey", Zero), E(GetCurrentDirectoryA), E(SetCurrentDirectoryA), E(GetWindowsDirectoryA),
    E(GetSystemDirectoryA), E(GetFileAttributesA), E(PathFileExistsA), E(PathAppendA), E(CopyFileA), E(DeleteFileA), E(CreateFileA), E(ReadFile),
    E(WriteFile), E(SetFilePointer), E(GetFileSize), EA("SetEndOfFile", One), EA("FlushFileBuffers", One), E(CloseHandle), E(CreateEventA),
    E(WaitForSingleObject), E(WaitForMultipleObjects), E(SetEvent), E(ResetEvent), E(FindFirstFileA), E(FindNextFileA), E(FindClose),
    E(GetPrivateProfileIntA), E(GetPrivateProfileStringA), E(WritePrivateProfileStringA), E(GetDriveTypeA), E(GetLogicalDrives), E(MessageBoxA),
    E(LoadCursorA), E(LoadIconA), E(LoadImageA), E(RegisterClassA), E(RegisterClassExA), E(GetClassInfoA), EA("GetClassInfoExA", GetClassInfoA),
    E(CreateWindowExA), E(DestroyWindow), EA("CallNextHookEx", Zero), E(CallWindowProcA), EA("IsWindowEnabled", One), EA("EnableWindow", Zero),
    EA("GetTopWindow", Zero), EA("GetWindow", Zero), EA("GetDlgItem", Zero), E(LoadAcceleratorsA), EA("BeginDeferWindowPos", GdiHandle),
    EA("DeferWindowPos", Zero), EA("EndDeferWindowPos", One), EA("GetCapture", Zero), EA("SetCapture", Zero), EA("ReleaseCapture", One),
    EA("ClientToScreen", One), EA("ScreenToClient", One), E(GetSystemMenu), EA("GetMenu", Zero), EA("SetMenu", One), EA("DrawMenuBar", One),
    EA("SetWindowTextA", One), E(GetWindowTextA), E(GetWindowTextLengthA), E(SetRect), E(CopyRect), E(IntersectRect), E(PtInRect), E(IsRectEmpty),
    E(OffsetRect), E(SetWindowsHookExA), E(UnhookWindowsHookEx), E(SendMessageA), E(PostMessageA), E(PostQuitMessage), E(DefWindowProcA),
    E(SetWindowLongA), E(GetWindowLongA), E(ShowWindow), E(UpdateWindow), E(InvalidateRect), EA("ValidateRect", One), E(BeginPaint),
    EA("EndPaint", One), E(GetClientRect), E(GetWindowRect), E(SetFocus), E(GetFocus), EA("SetActiveWindow", Zero), EA("GetActiveWindow", GetFocus),
    EA("GetForegroundWindow", GetFocus), EA("SetForegroundWindow", One), E(IsWindow), E(IsWindowVisible), E(GetParent), E(SetWindowPos),
    E(MoveWindow), E(SetTimer), E(KillTimer), E(PeekMessageA), E(GetMessageA), E(TranslateMessage), E(DispatchMessageA), E(GetTimeZoneInformation),
    E(GetComputerNameA), E(GlobalMemoryStatus), E(SetRectEmpty), E(FindWindowA), E(LoadStringA), E(FindResourceA), E(LoadResource), E(LockResource),
    E(SizeofResource), EA("FreeResource", Zero), E(MultiByteToWideChar), E(WideCharToMultiByte), E(GetStringTypeA), E(GetStringTypeW),
    E(GetStringTypeExA), E(LCMapStringA), EA("LCMapStringW", Zero), EA("IsBadReadPtr", IsBad), EA("IsBadWritePtr", IsBad), EA("IsBadCodePtr", IsBad),
    EA("IsBadStringPtrA", IsBad), E(GetUserDefaultLCID), EA("GetThreadLocale", GetUserDefaultLCID), E(GetLocaleInfoA), E(InterlockedIncrement),
    E(InterlockedDecrement), E(InterlockedExchange), E(lstrlenA), E(lstrcpyA), E(lstrcpynA), E(lstrcatA), E(lstrcmpA), E(lstrcmpiA), E(CharUpperA),
    E(CharNextA), E(GetKeyState), E(GetAsyncKeyState), E(SetCursorPos), E(GetCursorPos), E(SetCursor), E(ShowCursor), E(GetDesktopWindow),
    E(SystemParametersInfoA), E(GetSysColor), E(SHGetSpecialFolderPathA), E(CreateDirectoryA), EA("RemoveDirectoryA", One), E(GetLocalTime),
    EA("GetSystemTime", GetLocalTime), E(GetFileVersionInfoSizeA), E(GetFileVersionInfoA), E(VerQueryValueA), E(GetKeyboardLayout), E(wsprintfA),
    EA("GetSysColorBrush", GdiHandle), EA("RegisterWindowMessageA", RegisterWindowMessageA), E(GetProcessVersion), EA("SetErrorMode", Zero),
    EA("GetStockObject", GdiHandle), EA("CreateSolidBrush", GdiHandle), EA("DeleteObject", One), E(GetObjectA), EA("CoInitialize", CoInitialize),
    EA("OleInitialize", CoInitialize), E(RaiseException), E(SetThreadPriority), E(GetLastActivePopup),
};

int rc_win32_resolve(const char *dll, const char *name, RcApiFn *fn)
{
    (void)dll;
    for (size_t i = 0; i < sizeof api_table / sizeof api_table[0]; i++)
        if (!strcmp(api_table[i].name, name)) { *fn = api_table[i].fn; return 1; }
    return rc_ddraw_resolve(name, fn) || rc_dsound_resolve(name, fn) || rc_bink_resolve(name, fn);
}

void rc_win32_init(void)
{
    res_init();
    if (have_plat && rc_plat.now_ms) real_origin = rc_plat.now_ms(rc_plat.user);
}
