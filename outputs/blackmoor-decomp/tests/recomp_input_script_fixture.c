/* Finite device-free checks of the proposed shared INPUT module only. */
#include <stdint.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "rc_internal.h"
#include "rc_input_script.h"

#define CHECK(condition) do { if (!(condition)) { \
    fprintf(stderr, "%s:%d: CHECK(%s) failed\n", __FILE__, __LINE__, #condition); \
    exit(1); \
} } while (0)
#define MAX_POLLS 128u

typedef struct Event {
    char type;
    uint32_t now, kind, buttons, key;
    int32_t x, y;
    int down;
    unsigned number;
} Event;
static Event events[64];
static unsigned nevents, polls, stop_calls, log_count, shot_calls;
static uint32_t now, anchor_time;
static int main_thread = 1, anchor_known, shot_ok = 1;
static char logs[64][1024];
static int shot_cookie;
uint32_t rc_main_hwnd = 1;
uint8_t *rc_pages[RC_NPAGES];
static uint8_t page583[RC_PAGE], page587[RC_PAGE], page5bb[RC_PAGE];

uint32_t rc_clock(void) { return now; }
int rc_thread_is_main(void) { return main_thread; }
int rc_seen_at(const char *name, uint32_t *at)
{
    if (!anchor_known || strcmp(name, "LATE.CIF")) return 0;
    *at = anchor_time;
    return 1;
}
void rc_request_stop(void) { stop_calls++; }
uint32_t rc_rd_slow(uint32_t address, int bytes)
{
    (void)address; (void)bytes;
    CHECK(0 && "unexpected synthetic-memory read");
    return 0;
}
void rc_log(const char *format, ...)
{
    CHECK(log_count < 64);
    va_list args;
    va_start(args, format);
    int count = vsnprintf(logs[log_count], sizeof logs[0], format, args);
    va_end(args);
    CHECK(count >= 0 && (size_t)count < sizeof logs[0]);
    log_count++;
}
static Event *record(char type)
{
    CHECK(main_thread && nevents < 64);
    Event *event = &events[nevents++];
    memset(event, 0, sizeof *event);
    event->type = type; event->now = now;
    return event;
}
void rc_input_event(uint32_t kind, int32_t x, int32_t y, uint32_t buttons, uint32_t key)
{
    Event *event = record('I');
    event->kind = kind; event->x = x; event->y = y;
    event->buttons = buttons; event->key = key;
}
void rc_input_key(uint32_t key, int down)
{
    Event *event = record('K');
    event->key = key; event->down = down;
}
static int shot(void *user, unsigned number, uint32_t at)
{
    CHECK(user == &shot_cookie && at == now && main_thread);
    Event *event = record('S');
    event->number = number;
    shot_calls++;
    rc_input_script_log_observation();
    return shot_ok;
}
static void put(uint32_t address, int bytes, uint32_t value)
{
    uint8_t *page = rc_pages[address >> 12];
    CHECK(page && (address & (RC_PAGE - 1u)) + (uint32_t)bytes <= RC_PAGE);
    memcpy(page + (address & (RC_PAGE - 1u)), &value, (size_t)bytes);
}
static void reset_host(void)
{
    now = 0; nevents = 0; stop_calls = 0; log_count = 0; shot_calls = 0;
    main_thread = 1; anchor_known = 0; anchor_time = 0; shot_ok = 1; rc_main_hwnd = 1;
    CHECK(unsetenv("SCRIPT_TAIL_MS") == 0);
    CHECK(unsetenv("RC_FLAGS") == 0);
    memset(page583, 0, sizeof page583); memset(page587, 0, sizeof page587);
    memset(page5bb, 0, sizeof page5bb);
    rc_pages[0x583] = page583; rc_pages[0x587] = page587; rc_pages[0x5bb] = page5bb;
    put(0x5bb57b, 2, 2348); put(0x5bb57f, 2, 2348);
    put(0x5bb50b, 2, 0); put(0x583a29, 2, 0xffffu);
    put(0x585801u + 4u * 2002u, 4, 1);
}
static RcInputScript *parse(const char *text)
{
    char error[128] = "not cleared";
    RcInputScript *script = rc_input_script_parse(text, shot, &shot_cookie, error, sizeof error);
    if (!script) fprintf(stderr, "parse refused: %s\n", error);
    CHECK(script != NULL && error[0] == 0);
    return script;
}
static void poll_at(RcInputScript *script, uint32_t at)
{
    CHECK(++polls <= MAX_POLLS);
    now = at;
    rc_input_script_poll(script);
}
static void status(RcInputScript *script, unsigned total, unsigned consumed,
                   unsigned delivered, unsigned shots, int requested, int failed)
{
    RcInputScriptStatus s = rc_input_script_status(script);
    CHECK(s.total == total && s.consumed == consumed && s.delivered == delivered);
    CHECK(s.shots == shots && s.requested_stop == requested && s.failed == failed);
}
static void input(unsigned index, uint32_t at, uint32_t kind, int32_t x, int32_t y,
                  uint32_t buttons, uint32_t key)
{
    CHECK(index < nevents);
    Event e = events[index];
    CHECK(e.type == 'I' && e.now == at && e.kind == kind && e.x == x && e.y == y);
    CHECK(e.buttons == buttons && e.key == key);
}
static void key(unsigned index, uint32_t at, uint32_t value, int down)
{
    CHECK(index < nevents);
    Event e = events[index];
    CHECK(e.type == 'K' && e.now == at && e.key == value && e.down == down);
}
static int logged(const char *wanted)
{
    for (unsigned i = 0; i < log_count; i++) if (!strcmp(logs[i], wanted)) return 1;
    return 0;
}

static void mixed_trace(void)
{
    reset_host();
    CHECK(setenv("RC_FLAGS", "2002,2080", 1) == 0);
    RcInputScript *s = parse("1000:move:-2,0x10,0x77,0x88;1010:click:3,4;1020:key:65;"
                            "1030:keydown:16;1040:keyup:16;1050:keyhold:66;1060:keyhold:67,25;"
                            "LATE.CIF+100:move:9,10;LATE.CIF+1100:click:9,10,123;"
                            "LATE.CIF+1100:shot:0,0");
    main_thread = 0; poll_at(s, 1000); status(s, 10, 0, 0, 0, 0, 0);
    CHECK(nevents == 0); main_thread = 1;
    for (uint32_t at = 1000; at <= 1060; at += 10) poll_at(s, at);
    status(s, 10, 7, 7, 0, 0, 0);
    poll_at(s, 5000); status(s, 10, 7, 7, 0, 0, 0); /* anchor absent */
    anchor_known = 1; anchor_time = 1100;
    poll_at(s, 5000); status(s, 10, 8, 8, 0, 0, 0);
    poll_at(s, 5000); poll_at(s, 5999); status(s, 10, 8, 8, 0, 0, 0);
    poll_at(s, 6000); status(s, 10, 9, 9, 0, 0, 0); /* one step per poll */
    poll_at(s, 6000); status(s, 10, 10, 10, 1, 0, 0);
    CHECK(nevents == 11 && shot_calls == 1 && !rc_input_script_completed(s));
    input(0, 1000, 0, -2, 16, 0x77, 0);
    input(1, 1010, 1, 3, 4, 300, 0);
    key(2, 1020, 65, 1); key(3, 1020, 65, 0);
    key(4, 1030, 16, 1); key(5, 1040, 16, 0);
    input(6, 1050, 2, 0, 0, 300, 66); input(7, 1060, 2, 0, 0, 25, 67);
    input(8, 5000, 0, 9, 10, 300, 0); input(9, 6000, 1, 9, 10, 123, 0);
    CHECK(events[10].type == 'S' && events[10].number == 1 && events[10].now == 6000);
    CHECK(logged("  STATE requested_scene=2348 art_scene=2348 view=0 held_item=-1"));
    CHECK(logged("  RC_FLAGS 2002,2080") && logged("  FLAGS 2002=1"));
    poll_at(s, 10999); CHECK(stop_calls == 0 && !rc_input_script_completed(s));
    poll_at(s, 11000); status(s, 10, 10, 10, 1, 1, 0);
    CHECK(stop_calls == 1 && rc_input_script_completed(s));
    rc_input_script_destroy(s);
}

static void completion_guards(void)
{
    reset_host(); status(NULL, 0, 0, 0, 0, 0, 0);
    poll_at(NULL, 100); CHECK(!rc_input_script_completed(NULL));
    RcInputScript *s = parse("100:move:1,2;200:shot:0,0");
    rc_main_hwnd = 0; poll_at(s, 100); status(s, 2, 1, 0, 0, 0, 0);
    rc_main_hwnd = 1; poll_at(s, 200); status(s, 2, 2, 1, 1, 0, 0);
    poll_at(s, 5200); CHECK(stop_calls == 1 && !rc_input_script_completed(s));
    rc_input_script_destroy(s);

    reset_host(); s = parse("100:shot:0,0"); shot_ok = 0;
    poll_at(s, 100); status(s, 1, 1, 1, 1, 0, 1);
    poll_at(s, 5100); CHECK(stop_calls == 1 && !rc_input_script_completed(s));
    rc_input_script_destroy(s);

    reset_host(); s = parse("100:click:1,2");
    CHECK(setenv("SCRIPT_TAIL_MS", "0", 1) == 0);
    poll_at(s, 100); poll_at(s, 100000);
    status(s, 1, 1, 1, 0, 0, 0); CHECK(!stop_calls && !rc_input_script_completed(s));
    rc_input_script_destroy(s);

    reset_host(); s = parse("LATE.CIF+0:key:65");
    poll_at(s, 1000); rc_request_stop();
    status(s, 1, 0, 0, 0, 0, 0); CHECK(!rc_input_script_completed(s));
    rc_input_script_destroy(s);

    reset_host(); s = parse("100:click:1,2"); poll_at(s, 100);
    CHECK(setenv("SCRIPT_TAIL_MS", "25", 1) == 0); /* lazy tail selection */
    poll_at(s, 124); CHECK(!stop_calls && !rc_input_script_completed(s));
    poll_at(s, 125); CHECK(stop_calls == 1 && rc_input_script_completed(s));
    rc_input_script_destroy(s);
}

static void invalid(const char *text)
{
    char error[128] = "";
    RcInputScript *s = rc_input_script_parse(text, shot, &shot_cookie, error, sizeof error);
    CHECK(s == NULL && error[0] != 0);
    CHECK(nevents == 0 && stop_calls == 0 && shot_calls == 0);
}
static void parser_boundaries(void)
{
    reset_host();
    const char *valid[] = {" \n;;1:shot:0,0;;\n", "1:move:-2147483648,4294967295",
        "4294967295:key:255", "LATE.CIF+4294967295:shot:", "1:shot:0,0,1,2",
        "1:keydown:0xff", "1:keyup:0", "1:click:0x10,-2,0xffffffff,7"};
    for (unsigned i = 0; i < sizeof valid / sizeof valid[0]; i++) {
        RcInputScript *s = parse(valid[i]); status(s, 1, 0, 0, 0, 0, 0); rc_input_script_destroy(s);
    }
    const char *bad[] = {NULL, "", ";;", "1:unknown:0", "1:click:1", "1:move:", "1:key:",
        "1:shot:1,2,3,4,5", "1:click:1,,2", "1:click:1,2,", "1:click:,1,2",
        "4294967296:shot:", "1x:shot:", "LATE.CIF+:shot:", "+100:shot:",
        "LATE .CIF+1:shot:", "LATE.CIF+1x:shot:", "1:keydownx:1", "1:move:1x,2",
        "1:move:4294967296,0", "1:move:-2147483649,0", "1:key:256", "1:key:-1",
        "1:key:0x100", "1:key:65:1", "100:move:1,2;broken"};
    for (unsigned i = 0; i < sizeof bad / sizeof bad[0]; i++) invalid(bad[i]);
    char field[100]; memset(field, 'A', 63); strcpy(field + 63, ":shot:0,0");
    RcInputScript *s = parse(field); rc_input_script_destroy(s);
    memset(field, 'A', 64); strcpy(field + 64, ":shot:0,0"); invalid(field);
    char *steps = malloc(8192); CHECK(steps != NULL); steps[0] = 0;
    for (unsigned i = 0; i < 512; i++) strcat(steps, "1:shot:0,0;");
    s = parse(steps); status(s, 512, 0, 0, 0, 0, 0); rc_input_script_destroy(s);
    strcat(steps, "1:shot:0,0;"); invalid(steps); free(steps);
    char *large = malloc(65538); CHECK(large != NULL);
    memset(large, ' ', 65537); memcpy(large, "1:shot:0,0", 10); large[65536] = 0;
    s = parse(large); rc_input_script_destroy(s);
    large[65536] = ' '; large[65537] = 0; invalid(large); free(large);
}

static void file_boundaries(const char *directory)
{
    reset_host(); char path[1024], error[128];
    const char *names[] = {"valid.input", "empty.input", "nul.input", "oversize.input"};
    for (unsigned i = 0; i < 4; i++) {
        int count = snprintf(path, sizeof path, "%s/%s", directory, names[i]);
        CHECK(count > 0 && (size_t)count < sizeof path);
        RcInputScript *s = rc_input_script_load_file(path, shot, &shot_cookie, error, sizeof error);
        if (i) { CHECK(s == NULL && error[0]); continue; }
        CHECK(s && error[0] == 0); status(s, 1, 0, 0, 0, 0, 0);
        poll_at(s, 100); input(0, 100, 0, -3, 32, 300, 0);
        poll_at(s, 5100); CHECK(rc_input_script_completed(s));
        rc_input_script_destroy(s);
    }
}
int main(int argc, char **argv)
{
    CHECK(argc >= 2);
    if (!strcmp(argv[1], "mixed")) mixed_trace();
    else if (!strcmp(argv[1], "completion")) completion_guards();
    else if (!strcmp(argv[1], "parser")) parser_boundaries();
    else if (!strcmp(argv[1], "files")) { CHECK(argc == 3); file_boundaries(argv[2]); }
    else CHECK(0 && "unknown fixture");
    CHECK(polls <= MAX_POLLS);
    printf("INPUT_SCRIPT %s ok polls=%u\n", argv[1], polls);
    return 0;
}
