/* FL-11 direct test of write_alarm (src/action_family_aa_runtime.c), the native form of GAME.EXE 0x44d946 (raw 0xaa, the Alarm
 * Clock). The kernel is pulled in as a translation unit (shim pattern of tests/action_family_28_x87_division_fixture.c) so the
 * test calls the static function itself. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the failure count.
 * Expected values are derived by hand from the Ghidra pseudocode of 0x44d946, not by running the kernel. */
#include "../src/action_family_aa_runtime.c"

#include <stdio.h>

static int g_failed;
static char g_msg[256];
#define CK(cond)                                                               \
    do {                                                                       \
        if (!(cond) && !g_failed) {                                            \
            g_failed = 1;                                                      \
            snprintf(g_msg, sizeof g_msg, "line %d: %.200s", __LINE__, #cond); \
        }                                                                      \
    } while (0)

typedef struct {
    int effect[8];
    int32_t a[8], b[8];
    int n;
} TLog;

static void t_observe(void *context, int effect, int32_t a, int32_t b)
{
    TLog *l = (TLog *)context;
    if (l->n < 8) {
        l->effect[l->n] = effect;
        l->a[l->n] = a;
        l->b[l->n] = b;
    }
    ++l->n;
}

/* Runs write_alarm for one alarm (hour index, AM flag) with the clock preset to hour 99 / minute 37 and checks the ordered stores:
 * the hour word first, then the minute word := 0. */
static int t_run(int16_t alarm_hour, int32_t alarm_am, int expect_hour)
{
    AlcObject o;
    AlcWorld w;
    AlcHost host;
    TLog log;
    memset(&o, 0, sizeof o);
    memset(&w, 0, sizeof w);
    memset(&host, 0, sizeof host);
    memset(&log, 0, sizeof log);
    host.context = &log;
    host.observe = t_observe;
    o.alarm_hour = alarm_hour;
    o.alarm_am = alarm_am;
    o.alarm_quarter = 3;
    w.hour_585d51 = 99;
    w.minute_585d4f = 37;
    w.start_flag_5bb1ca = 77;
    write_alarm(&o, &w, &host);
    return w.hour_585d51 == expect_hour && w.minute_585d4f == 0 && w.start_flag_5bb1ca == 77 && o.alarm_hour == alarm_hour &&
           o.alarm_am == alarm_am && log.n == 2 && log.effect[0] == ALC_FX_HOUR_STORE && log.a[0] == expect_hour &&
           log.effect[1] == ALC_FX_MINUTE_STORE && log.a[1] == 0;
}

/* 0x44d946: if the alarm AM word (obj+0x41) is 0 (PM): hour index 11 stores 12, otherwise index + 13; if it is nonzero (AM): index
 * 11 stores 0, otherwise index + 1. Then the minute word := 0, after the hour store. */
static void test_write_alarm(void)
{
    /* PM (word 0) */
    CK(t_run(0, 0, 13));
    CK(t_run(5, 0, 18));
    CK(t_run(10, 0, 23));
    CK(t_run(11, 0, 12));
    /* AM (nonzero) */
    CK(t_run(0, 1, 1));
    CK(t_run(5, 1, 6));
    CK(t_run(10, 1, 11));
    CK(t_run(11, 1, 0));
    /* any nonzero 32-bit AM word counts as AM, including one whose low 16 bits are zero */
    CK(t_run(3, 0x10000, 4));
    CK(t_run(11, -1, 0));
    {
        /* no observer: the clock words are still stored */
        AlcObject o;
        AlcWorld w;
        AlcHost host;
        memset(&o, 0, sizeof o);
        memset(&w, 0, sizeof w);
        memset(&host, 0, sizeof host);
        o.alarm_hour = 2;
        o.alarm_am = 0;
        w.minute_585d4f = 59;
        write_alarm(&o, &w, &host);
        CK(w.hour_585d51 == 15 && w.minute_585d4f == 0);
    }
    if (!g_failed) printf("PASS test_write_alarm\n");
    else printf("FAIL test_write_alarm: %s\n", g_msg);
}

int main(void)
{
    g_failed = 0;
    test_write_alarm();
    return g_failed;
}
