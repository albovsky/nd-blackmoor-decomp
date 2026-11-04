/* Finite actual-host checks of the guest file replacement path (rc_win32.c): a failed, short or interrupted overwrite must leave the previous
 * file byte-for-byte intact. No game, guest memory, GUI or audio; synthetic files in a private temp directory. */
#ifndef RC_TEST_WIN32_SOURCE
#define RC_TEST_WIN32_SOURCE "../recomp/rc_win32.c"
#endif
#include RC_TEST_WIN32_SOURCE
#include <signal.h>
#include <sys/resource.h>
#include <sys/wait.h>

static unsigned checks, failures;
#define EXPECT(cond, what) do { checks++; if (!(cond)) { failures++; fprintf(stderr, "FAIL %s (line %d)\n", what, __LINE__); } } while (0)

static char dir[256];

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

void rc_log(const char *fmt, ...) { (void)fmt; }

static uint8_t pattern(size_t i) { return (uint8_t)(i * 31u + 7u); }

int main(void)
{
    signal(SIGXFSZ, SIG_IGN);
    snprintf(dir, sizeof dir, "/private/tmp/blackmoor-save-fixture.XXXXXX");
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

    printf("SAVE_FIXTURE checks=%u failures=%u\n", checks, failures);
    return failures ? 1 : 0;
}
