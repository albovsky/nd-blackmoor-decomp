/* Finite actual-host checks of the guest file replacement path (rc_win32.c): a failed, short or interrupted overwrite must leave the previous
 * file byte-for-byte intact. No game, guest memory, GUI or audio; synthetic files in a private temp directory. */
#ifndef RC_TEST_WIN32_SOURCE
#define RC_TEST_WIN32_SOURCE "../recomp/rc_win32.c"
#endif
#include RC_TEST_WIN32_SOURCE
#include <signal.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <ftw.h>

static unsigned checks, failures;
#define EXPECT(cond, what) do { checks++; if (!(cond)) { failures++; fprintf(stderr, "FAIL %s (line %d)\n", what, __LINE__); } } while (0)

static char dir[256];

static int remove_one(const char *path, const struct stat *st, int flag, struct FTW *ftw) { (void)st; (void)flag; (void)ftw; return remove(path); }
static void remove_tree(const char *root) { nftw(root, remove_one, 16, FTW_DEPTH | FTW_PHYS); }

static void put(const char *name, const void *data, size_t n)
{
    char path[512];
    snprintf(path, sizeof path, "%s/%s", dir, name);
    FILE *f = fopen(path, "wb");
    if (!f || fwrite(data, 1, n, f) != n || fclose(f)) { fprintf(stderr, "fixture write failed\n"); exit(2); }
}
static size_t get(const char *name, uint8_t *out, size_t cap)
{
    char path[512];
    snprintf(path, sizeof path, "%s/%s", dir, name);
    FILE *f = fopen(path, "rb");
    if (!f) return (size_t)-1;
    size_t n = fread(out, 1, cap, f);
    fclose(f);
    return n;
}
static int temps_left(void)
{
    int n = 0;
    DIR *d = opendir(dir);
    struct dirent *e;
    while (d && (e = readdir(d))) if (!strncmp(e->d_name, TMP_PREFIX, sizeof TMP_PREFIX - 1)) n++;
    if (d) closedir(d);
    return n;
}
/* What CreateFileA(CREATE_ALWAYS, GENERIC_WRITE) does for an existing or new host path. */
static int begin(const char *name, FileObj *f)
{
    char h[512];
    snprintf(h, sizeof h, "%s/%s", dir, name);
    struct stat st;
    int exists = stat(h, &st) == 0;
    memset(f, 0, sizeof *f);
    snprintf(f->path, sizeof f->path, "%s", h);
    return tx_open(h, exists, exists ? st.st_mode & 07777 : 0644, f->tmp, sizeof f->tmp, &f->fd);
}


/* A flat fake guest: 0x10000..0x110000 backed by host memory, plus a tiny handle table. Only what the file APIs touch. */
uint8_t *rc_pages[RC_NPAGES];
static uint8_t guest[0x100000];
#define GUEST_BASE 0x10000u
static void guest_init(void)
{
    for (uint32_t i = 0; i < sizeof guest / RC_PAGE; i++) rc_pages[(GUEST_BASE >> 12) + i] = guest + (size_t)i * RC_PAGE;
}
static uint8_t *gp(uint32_t va) { return guest + (va - GUEST_BASE); }
uint32_t rc_rd_slow(uint32_t a, int bytes) { uint32_t v = 0; memcpy(&v, gp(a), (size_t)bytes); return v; }
void rc_wr_slow(uint32_t a, int bytes, uint32_t v) { memcpy(gp(a), &v, (size_t)bytes); }
void *rc_ptr(uint32_t va, uint32_t bytes) { (void)bytes; return gp(va); }
void rc_read(uint32_t va, void *dst, size_t n) { memcpy(dst, gp(va), n); }
void rc_write(uint32_t va, const void *src, size_t n) { memcpy(gp(va), src, n); }
size_t rc_cstr(uint32_t va, char *out, size_t cap) { snprintf(out, cap, "%s", (const char *)gp(va)); return strlen(out); }
void rc_thread_close(RcGuestThread *t) { (void)t; }
static struct { int kind; void *obj; } handles[64];
uint32_t rc_handle_new(int kind, void *obj) { for (uint32_t i = 1; i < 64; i++) if (!handles[i].kind) { handles[i].kind = kind; handles[i].obj = obj; return 0x100 + i * 4; } return 0; }
void *rc_handle_obj(uint32_t h, int kind) { uint32_t i = (h - 0x100) / 4; return h >= 0x104 && i < 64 && handles[i].kind == kind ? handles[i].obj : NULL; }
int rc_handle_kind(uint32_t h) { uint32_t i = (h - 0x100) / 4; return h >= 0x104 && i < 64 ? handles[i].kind : 0; }
void rc_handle_close(uint32_t h) { uint32_t i = (h - 0x100) / 4; if (h >= 0x104 && i < 64) handles[i].kind = 0; }

static uint32_t guest_string(uint32_t va, const char *s) { memcpy(gp(va), s, strlen(s) + 1); return va; }
#define NAME_VA 0x20000u
#define NAME2_VA 0x21000u
#define DATA_VA 0x30000u
#define OUT_VA 0x28000u
static uint32_t call(int (*api)(Fl41Regs *, const uint32_t *, uint32_t *), uint32_t a0, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4)
{
    uint32_t args[8] = {a0, a1, a2, a3, a4, 0, 0, 0}, ret = 0xdeadbeefu;
    if (api(NULL, args, &ret) != 0) { fprintf(stderr, "api stopped\n"); exit(2); }
    return ret;
}

void rc_log(const char *fmt, ...) { (void)fmt; }

static uint8_t pattern(size_t i) { return (uint8_t)(i * 31u + 7u); }

int main(void)
{
    signal(SIGXFSZ, SIG_IGN);
    const char *tmpdir = getenv("TMPDIR");
    snprintf(dir, sizeof dir, "%s/blackmoor-save-fixture.XXXXXX", tmpdir && *tmpdir ? tmpdir : "/tmp");
    if (!mkdtemp(dir)) return 2;
    enum { OLD = 170770, NEW = 170770 };
    static uint8_t old_bytes[OLD], new_bytes[NEW], got[NEW + 4096];
    for (size_t i = 0; i < OLD; i++) { old_bytes[i] = pattern(i); new_bytes[i] = (uint8_t)~pattern(i); }
    FileObj f;
    uint32_t done;

    /* 1. an ordinary overwrite replaces the file only at close and leaves no temp behind */
    put("m0.SAV", old_bytes, OLD);
    EXPECT(begin("m0.SAV", &f) == 0, "overwrite opens");
    EXPECT(file_write_all(&f, new_bytes, NEW, &done) == 0 && done == NEW, "full write succeeds");
    EXPECT(get("m0.SAV", got, sizeof got) == OLD && !memcmp(got, old_bytes, OLD), "before close the previous bytes are still the file");
    EXPECT(file_finish(&f) == 1, "close commits");
    EXPECT(get("m0.SAV", got, sizeof got) == NEW && !memcmp(got, new_bytes, NEW), "after close the new bytes are the file");
    EXPECT(temps_left() == 0, "no temp after commit");

    /* 2. a new file is only visible once closed */
    EXPECT(begin("m1.SAV", &f) == 0, "create opens");
    EXPECT(file_write_all(&f, new_bytes, 1000, &done) == 0 && done == 1000, "create write");
    EXPECT(get("m1.SAV", got, sizeof got) == (size_t)-1, "a half-written new file is not visible");
    EXPECT(file_finish(&f) == 1 && get("m1.SAV", got, sizeof got) == 1000, "created on close");

    /* 3. the deterministic short write of the QA report: the size limit stops the write part-way */
    put("m0.SAV", old_bytes, OLD);
    struct rlimit saved, small;
    getrlimit(RLIMIT_FSIZE, &saved);
    small = saved;
    small.rlim_cur = 100000; /* soft limit only: the hard limit could not be raised again */
    EXPECT(begin("m0.SAV", &f) == 0, "overwrite opens before the fault");
    setrlimit(RLIMIT_FSIZE, &small);
    int rc = file_write_all(&f, new_bytes, NEW, &done);
    setrlimit(RLIMIT_FSIZE, &saved);
    EXPECT(rc != 0 && done < NEW, "short write is reported, not counted as complete");
    EXPECT(f.failed, "the file object remembers the failure");
    EXPECT(file_finish(&f) == 0, "close of a failed overwrite reports failure");
    EXPECT(get("m0.SAV", got, sizeof got) == OLD && !memcmp(got, old_bytes, OLD), "short write leaves the previous save byte-for-byte");
    EXPECT(temps_left() == 0, "failed overwrite removes its temp");
    EXPECT(win_error_of(EFBIG) == 112, "size-limit failure maps to ERROR_DISK_FULL");

    /* 4. failed writes keep failing: a later successful write cannot rescue the replacement */
    EXPECT(begin("m0.SAV", &f) == 0, "overwrite opens again");
    setrlimit(RLIMIT_FSIZE, &small);
    rc = file_write_all(&f, new_bytes, NEW, &done);
    setrlimit(RLIMIT_FSIZE, &saved);
    EXPECT(rc != 0, "fault again");
    EXPECT(file_write_all(&f, new_bytes, 10, &done) == 0, "a later small write itself succeeds");
    EXPECT(file_finish(&f) == 0 && get("m0.SAV", got, sizeof got) == OLD && !memcmp(got, old_bytes, OLD), "earlier failure still discards the replacement");

    /* 5. interruption: the process dies in the middle of an overwrite */
    pid_t child = fork();
    if (child == 0) {
        FileObj c;
        if (begin("m0.SAV", &c) != 0) _exit(10);
        uint32_t d;
        if (file_write_all(&c, new_bytes, NEW / 2, &d) != 0) _exit(11);
        raise(SIGKILL);
        _exit(12);
    }
    int status = 0;
    waitpid(child, &status, 0);
    EXPECT(WIFSIGNALED(status) && WTERMSIG(status) == SIGKILL, "child was interrupted mid-overwrite");
    EXPECT(get("m0.SAV", got, sizeof got) == OLD && !memcmp(got, old_bytes, OLD), "interrupted overwrite leaves the previous save selectable");
    EXPECT(temps_left() == 1, "the interrupted temp stays hidden from the slot name");
    {
        DIR *d = opendir(dir);
        struct dirent *e;
        int listed = 0;
        while (d && (e = readdir(d))) if (strcmp(e->d_name, ".") && strcmp(e->d_name, "..") && wild("*.*", e->d_name) && strncmp(e->d_name, TMP_PREFIX, sizeof TMP_PREFIX - 1)) listed++;
        if (d) closedir(d);
        EXPECT(listed == 2, "a *.* search lists the two real slots and not the interrupted temp");
    }

    /* 6. a read-only slot cannot be silently replaced */
    if (geteuid() != 0) {
        char path[512];
        snprintf(path, sizeof path, "%s/m0.SAV", dir);
        chmod(path, 0444);
        EXPECT(begin("m0.SAV", &f) == EACCES, "a read-only slot is refused, not silently replaced");
        EXPECT(get("m0.SAV", got, sizeof got) == OLD && !memcmp(got, old_bytes, OLD), "read-only slot keeps its bytes");
        EXPECT(temps_left() == 1, "refusal leaves no new temp (only the interrupted one)");
        chmod(path, 0644);
    }


    /* 7. the same guarantees through the real KERNEL32 entry points the game calls */
    guest_init();
    {
        char save[300], game[300];
        snprintf(game, sizeof game, "%s/game", dir);
        snprintf(save, sizeof save, "%s/saves", dir);
        mkdir(game, 0755); mkdir(save, 0755);
        char slot_dir[400];
        snprintf(slot_dir, sizeof slot_dir, "%s/Documents5", save); mkdir(slot_dir, 0755);
        snprintf(slot_dir, sizeof slot_dir, "%s/Documents5/The Curse of Blackmoor Manor", save); mkdir(slot_dir, 0755);
        have_plat = 1; rc_plat.game_dir = game; rc_plat.save_dir = save;
        char slot[460];
        snprintf(slot, sizeof slot, "%s/m0.SAV", slot_dir);
        FILE *o = fopen(slot, "wb"); fwrite(old_bytes, 1, OLD, o); fclose(o);
        uint32_t name = guest_string(NAME_VA, "C:\\GAME\\Documents5\\The Curse of Blackmoor Manor\\m0.SAV");
        memcpy(gp(DATA_VA), new_bytes, NEW);
        static uint8_t again[NEW + 4096];
        struct stat sst;

        uint32_t h = call(api_CreateFileA, name, 0x40000000u, 0, 0, 2);
        EXPECT(h != 0xffffffffu, "CreateFileA(CREATE_ALWAYS) opens the replacement");
        EXPECT(stat(slot, &sst) == 0 && sst.st_size == OLD, "CreateFileA no longer truncates the slot");
        EXPECT(call(api_WriteFile, h, DATA_VA, NEW, OUT_VA, 0) == 1 && rc_rd(OUT_VA, 4) == NEW, "WriteFile writes everything");
        EXPECT(call(api_CloseHandle, h, 0, 0, 0, 0) == 1, "CloseHandle commits");
        o = fopen(slot, "rb"); size_t got_n = fread(again, 1, sizeof again, o); fclose(o);
        EXPECT(got_n == NEW && !memcmp(again, new_bytes, NEW), "the slot holds the new bytes after CloseHandle");

        o = fopen(slot, "wb"); fwrite(old_bytes, 1, OLD, o); fclose(o);
        h = call(api_CreateFileA, name, 0x40000000u, 0, 0, 2);
        setrlimit(RLIMIT_FSIZE, &small);
        uint32_t ok = call(api_WriteFile, h, DATA_VA, NEW, OUT_VA, 0);
        setrlimit(RLIMIT_FSIZE, &saved);
        EXPECT(ok == 0 && rc_rd(OUT_VA, 4) < NEW, "WriteFile reports the short write and the count that reached the file");
        EXPECT(last_error == 112, "WriteFile sets ERROR_DISK_FULL");
        EXPECT(call(api_CloseHandle, h, 0, 0, 0, 0) == 0, "CloseHandle reports the failed save");
        o = fopen(slot, "rb"); got_n = fread(again, 1, sizeof again, o); fclose(o);
        EXPECT(got_n == OLD && !memcmp(again, old_bytes, OLD), "the slot keeps the old bytes after the failed API save");

        /* CopyFileA is replace-or-nothing too, and refuses a read-only destination */
        char src[460], dst[460];
        snprintf(src, sizeof src, "%s/GAME.INI", game); snprintf(dst, sizeof dst, "%s/GAME.INI", slot_dir);
        o = fopen(src, "wb"); fwrite("[A]\nx=1\n", 1, 9, o); fclose(o);
        o = fopen(dst, "wb"); fwrite("old ini", 1, 7, o); fclose(o);
        uint32_t from = guest_string(NAME2_VA, "C:\\GAME\\GAME.INI");
        uint32_t to = guest_string(NAME_VA, "C:\\GAME\\Documents5\\The Curse of Blackmoor Manor\\GAME.INI");
        EXPECT(call(api_CopyFileA, from, to, 0, 0, 0) == 1, "CopyFileA replaces an existing writable file");
        o = fopen(dst, "rb"); got_n = fread(again, 1, 64, o); fclose(o);
        EXPECT(got_n == 9 && !memcmp(again, "[A]\nx=1\n", 9), "CopyFileA delivered the new contents");
        if (geteuid() != 0) {
            chmod(dst, 0444);
            EXPECT(call(api_CopyFileA, from, to, 0, 0, 0) == 0 && last_error == 5, "CopyFileA refuses a read-only destination");
            chmod(dst, 0644);
        }

        /* an interrupted overwrite's temp is not listed by the game's file searches */
        char stray[560];
        snprintf(stray, sizeof stray, "%s/.rcsave-999999-0.tmp", slot_dir);
        o = fopen(stray, "wb"); fwrite("partial", 1, 7, o); fclose(o);
        uint32_t pattern = guest_string(NAME_VA, "C:\\GAME\\Documents5\\The Curse of Blackmoor Manor\\*.*");
        unsigned listed = 0, stray_listed = 0;
        uint32_t fh = call(api_FindFirstFileA, pattern, OUT_VA, 0, 0, 0);
        for (int more = fh != 0xffffffffu; more; more = (int)call(api_FindNextFileA, fh, OUT_VA, 0, 0, 0)) {
            listed++;
            if (!strncmp((char *)gp(OUT_VA + 44), TMP_PREFIX, sizeof TMP_PREFIX - 1)) stray_listed++;
        }
        EXPECT(listed == 2 && stray_listed == 0, "FindFirstFileA/FindNextFileA list the slot and GAME.INI but not the temp");
    }

    /* clean up the private directory */
    remove_tree(dir);
    printf("SAVE_FIXTURE checks=%u failures=%u\n", checks, failures);
    return failures ? 1 : 0;
}
