/* FL-13 direct test of the entry search of the raw 0x1c interactive video kernel (src/action_family_1c_runtime.c).
 *
 * find_entry is `static`, so this test includes the kernel source and calls it. Prints "PASS <name>" / "FAIL <name>: <message>";
 * the exit status is the failure count. Fixtures are synthetic in-memory tables (no original bytes). Expected values are derived
 * from the Ghidra pseudocode of GAME.EXE 0x4cb944 (thiscall, ECX = the singleton, one stack argument):
 *   if (*(this + 0x1a) != 0) {
 *     *(this + 0x136) = 0;
 *     while (*(this + 0x136) < *(*(this + 0x1a) + 0x21)) {
 *       if (*(short *)(*(*(this + 0x1a) + 0x25) + *(this + 0x136) * 0xd) == param_1)   // short sign-extended against an int
 *         return *(this + 0x136) * 0xd + *(*(this + 0x1a) + 0x25);
 *       *(this + 0x136) = *(this + 0x136) + 1; } }
 *   return 0;
 * so the counter at object+0x136 ends at the matching index, or at the entry count when nothing matched, is 0 for an empty
 * table, and stays untouched when no file is loaded. Nothing else of the object is written. */
#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "../src/action_family_1c_runtime.c"

static int g_failed;
static char g_msg[400];

static void note(int line, const char *fmt, ...)
{
    char tmp[300];
    va_list ap;
    if (g_failed) return;
    g_failed = 1;
    va_start(ap, fmt);
    vsnprintf(tmp, sizeof tmp, fmt, ap);
    va_end(ap);
    snprintf(g_msg, sizeof g_msg, "line %d: %s", line, tmp);
}

#define EXPECT(cond)                              \
    do {                                          \
        if (!(cond)) note(__LINE__, "%s", #cond); \
    } while (0)
#define EXPECT_EQ(a, b)                                                       \
    do {                                                                      \
        const long long a_ = (long long)(a), b_ = (long long)(b);             \
        if (a_ != b_) note(__LINE__, "%s = %lld, expected %lld", #a, a_, b_); \
    } while (0)

/* One call; also proves that every object byte other than the counter is unchanged. */
static const C1cEntry *search(C1cObject *o, int32_t index)
{
    C1cObject before = *o;
    const C1cEntry *r = find_entry(o, index);
    before.scan_index = o->scan_index;
    EXPECT(memcmp(&before, o, sizeof before) == 0);
    return r;
}

static void table(C1cObject *o, C1cIv *iv, C1cEntry *entries, const int16_t *ids, int32_t n)
{
    int32_t i;
    memset(o, 0, sizeof *o);
    memset(iv, 0, sizeof *iv);
    memset(entries, 0, 8 * sizeof *entries);
    for (i = 0; i < n; ++i) entries[i].id = ids[i];
    iv->count = n;
    iv->entries = entries;
    o->iv = iv;
    o->scan_index = 0x5a5a;
}

static void t_find_entry(void)
{
    C1cObject o;
    C1cIv iv;
    C1cEntry e[8];
    const int16_t ids[] = {5, 7, 7, -3};

    /* no file loaded: NULL and +0x136 untouched */
    memset(&o, 0, sizeof o);
    o.scan_index = 0x1234;
    EXPECT(search(&o, 5) == NULL);
    EXPECT_EQ(o.scan_index, 0x1234);

    /* first entry matches: counter 0 */
    table(&o, &iv, e, ids, 4);
    EXPECT(search(&o, 5) == &e[0]);
    EXPECT_EQ(o.scan_index, 0);
    /* duplicate ids: the first match, counter 1 */
    table(&o, &iv, e, ids, 4);
    EXPECT(search(&o, 7) == &e[1]);
    EXPECT_EQ(o.scan_index, 1);
    /* last entry, negative id (short compared sign-extended against the int argument) */
    table(&o, &iv, e, ids, 4);
    EXPECT(search(&o, -3) == &e[3]);
    EXPECT_EQ(o.scan_index, 3);
    /* 0xfffd as an int is not -3 */
    table(&o, &iv, e, ids, 4);
    EXPECT(search(&o, 0xfffd) == NULL);
    EXPECT_EQ(o.scan_index, 4);
    /* nothing matches: the loop leaves the counter at the entry count; the entry past the table is never read as a match */
    table(&o, &iv, e, ids, 4);
    e[4].id = 99;
    EXPECT(search(&o, 99) == NULL);
    EXPECT_EQ(o.scan_index, 4);
    /* empty table: counter 0 (stale value overwritten), NULL */
    table(&o, &iv, e, ids, 0);
    e[0].id = 5;
    EXPECT(search(&o, 5) == NULL);
    EXPECT_EQ(o.scan_index, 0);
    /* a second search restarts the counter at 0 */
    table(&o, &iv, e, ids, 4);
    EXPECT(search(&o, -3) == &e[3]);
    EXPECT(search(&o, 5) == &e[0]);
    EXPECT_EQ(o.scan_index, 0);
    /* index -1 is a legitimate id value to look for */
    table(&o, &iv, e, ids, 3);
    EXPECT(search(&o, -1) == NULL);
    EXPECT_EQ(o.scan_index, 3);
}

typedef struct Case {
    const char *name;
    void (*fn)(void);
} Case;

int main(void)
{
    static const Case cases[] = {{"find_entry", t_find_entry}};
    int failures = 0;
    for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        g_failed = 0;
        g_msg[0] = '\0';
        cases[i].fn();
        if (g_failed) {
            printf("FAIL %s: %s\n", cases[i].name, g_msg);
            ++failures;
        } else {
            printf("PASS %s\n", cases[i].name);
        }
    }
    return failures;
}
