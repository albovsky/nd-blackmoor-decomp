/* Focused device-free checks: real planner plus the existing fake INPUT host. */
#include "rc_pointer_input.h"
/* Reuse the base fixture's helpers, with this fixture's full pointer planner. */
#define RECOMP_INPUT_SCRIPT_CUSTOM_POINTER 1
#define main rc_input_script_base_fixture_main
#include "recomp_input_script_fixture.c"
#undef main
#undef RECOMP_INPUT_SCRIPT_CUSTOM_POINTER

struct ExpectedMessage { uint32_t message, wparam; };
struct PlanCase {
    const char *name;
    uint32_t before, after;
    unsigned count;
    struct ExpectedMessage expected[3];
};
static const struct PlanCase transitions[] = {
    {"hover",          0, 0, 1, {{0x200, 0}}},
    {"left down",      0, 1, 2, {{0x200, 0}, {0x201, 1}}},
    {"right down",     0, 2, 2, {{0x200, 0}, {0x204, 2}}},
    {"both down",      0, 3, 3, {{0x200, 0}, {0x201, 1}, {0x204, 3}}},
    {"left up",        1, 0, 1, {{0x202, 0}}},
    {"left held",      1, 1, 1, {{0x200, 1}}},
    {"left to right",  1, 2, 3, {{0x200, 1}, {0x202, 0}, {0x204, 2}}},
    {"add right",      1, 3, 2, {{0x200, 1}, {0x204, 3}}},
    {"right up",       2, 0, 1, {{0x205, 0}}},
    {"right to left",  2, 1, 3, {{0x200, 2}, {0x201, 3}, {0x205, 1}}},
    {"right held",     2, 2, 1, {{0x200, 2}}},
    {"add left",       2, 3, 2, {{0x200, 2}, {0x201, 3}}},
    {"both up",        3, 0, 2, {{0x202, 2}, {0x205, 0}}},
    {"release right",  3, 1, 1, {{0x205, 1}}},
    {"release left",   3, 2, 1, {{0x202, 2}}},
    {"both held",      3, 3, 1, {{0x200, 3}}},
};
static unsigned plans_checked, messages_checked;

static void check_plan(const struct PlanCase *c, uint32_t modifiers,
                       uint32_t expected_modifiers, int32_t x, int32_t y, uint32_t lp)
{
    RcPointerMessage messages[3] = {{0}};
    unsigned count = rc_pointer_plan(c->before, c->after, modifiers, x, y, messages);
    if (count != c->count) fprintf(stderr, "planner case=%s count=%u expected=%u\n", c->name, count, c->count);
    CHECK(count <= 3 && count == c->count);
    for (unsigned i = 0; i < count; ++i) {
        uint32_t wp = c->expected[i].wparam | expected_modifiers;
        if (messages[i].message != c->expected[i].message || messages[i].wparam != wp || messages[i].lparam != lp)
            fprintf(stderr, "planner case=%s message=%u got=%x/%x/%08x expected=%x/%x/%08x\n",
                    c->name, i, (unsigned)messages[i].message, (unsigned)messages[i].wparam,
                    (unsigned)messages[i].lparam, (unsigned)c->expected[i].message, (unsigned)wp, (unsigned)lp);
        CHECK(messages[i].message == c->expected[i].message && messages[i].wparam == wp && messages[i].lparam == lp);
    }
    plans_checked++; messages_checked += count;
}

static void planner_table(void)
{
    static const uint32_t modifiers[] = {0, 4, 8, 12};
    for (unsigned i = 0; i < sizeof transitions / sizeof transitions[0]; ++i)
        for (unsigned j = 0; j < sizeof modifiers / sizeof modifiers[0]; ++j)
            check_plan(&transitions[i], modifiers[j], modifiers[j], 7, 9, 0x00090007u);
    static const struct { int32_t x, y; uint32_t packed; } coordinates[] = {
        {-1, -1, 0xffffffffu},
        {-32768, 32767, 0x7fff8000u},
        {32767, -32768, 0x80007fffu},
        {65537, -65538, 0xfffe0001u},
        {INT32_MIN, INT32_MAX, 0xffff0000u},
        {INT32_MAX, INT32_MIN, 0x0000ffffu},
    };
    for (unsigned i = 0; i < sizeof coordinates / sizeof coordinates[0]; ++i)
        check_plan(&transitions[2], 0, 0, coordinates[i].x, coordinates[i].y, coordinates[i].packed);
    static const struct PlanCase ignored_bits = {
        "unknown bits ignored", 0x81, 0x43, 2, {{0x200, 1}, {0x204, 3}}
    };
    check_plan(&ignored_bits, 0x803f, 12, -1, -1, 0xffffffffu);
    CHECK(plans_checked == 71 && messages_checked == 122);
    printf("RIGHT_POINTER planner ok plans=%u messages=%u\n", plans_checked, messages_checked);
}

/* Fake API boundary records complete masks and queues the REAL planner output.
 * This does not link or claim coverage of rc_win32.c's locks/state/async APIs. */
static RcPointerMessage pointer_queue[8];
static uint32_t pointer_queue_at[8], current_buttons;
static unsigned pointer_calls, queue_count;
void rc_input_pointer_mask(int32_t x, int32_t y, uint32_t buttons)
{
    Event *event = record('P');
    event->x = x; event->y = y; event->buttons = buttons;
    RcPointerMessage messages[3];
    unsigned count = rc_pointer_plan(current_buttons, buttons, 0, x, y, messages);
    CHECK(count <= 3 && queue_count + count <= 8);
    for (unsigned i = 0; i < count; ++i) {
        pointer_queue[queue_count] = messages[i];
        pointer_queue_at[queue_count++] = now;
    }
    current_buttons = buttons & 3u;
    pointer_calls++;
}

static void pointer_script(void)
{
    reset_host();
    RcInputScript *s = parse("10:pointer:-2,0x10,0;20:pointer:1,2,1;"
                             "30:pointer:1,2,0x2;40:pointer:1,2,+3");
    status(s, 4, 0, 0, 0, 0, 0); rc_input_script_destroy(s);
    static const char *bad[] = {
        "10:pointer:1,2,-1", "10:pointer:1,2,4", "10:pointer:1,2,0xffffffff",
        "10:pointer:1,2", "10:pointer:1,2,2,0", "10:click:1,2;20:pointer:1,2,4"
    };
    for (unsigned i = 0; i < sizeof bad / sizeof bad[0]; ++i) invalid(bad[i]);
    CHECK(pointer_calls == 0 && queue_count == 0);
    s = parse("LATE.CIF+10:pointer:-2,10,2;LATE.CIF+20:pointer:30,-4,2;LATE.CIF+30:pointer:30,-4,0");
    anchor_known = 1; anchor_time = 1000;
    poll_at(s, 1009); CHECK(nevents == 0);
    main_thread = 0; poll_at(s, 1010); status(s, 3, 0, 0, 0, 0, 0);
    main_thread = 1; poll_at(s, 1010); status(s, 3, 1, 1, 0, 0, 0);
    poll_at(s, 1019); CHECK(nevents == 1);
    poll_at(s, 1020); poll_at(s, 1030); status(s, 3, 3, 3, 0, 0, 0);
    CHECK(nevents == 3 && pointer_calls == 3 && queue_count == 4 && current_buttons == 0);
    static const struct { uint32_t at, mask; int32_t x, y; } calls[] = {
        {1010, 2, -2, 10}, {1020, 2, 30, -4}, {1030, 0, 30, -4}
    };
    for (unsigned i = 0; i < 3; ++i) {
        CHECK(events[i].type == 'P' && events[i].now == calls[i].at && events[i].buttons == calls[i].mask);
        CHECK(events[i].x == calls[i].x && events[i].y == calls[i].y);
    }
    static const struct { uint32_t at, message, wp, lp; } queued[] = {
        {1010, 0x200, 0, 0x000afffeu}, {1010, 0x204, 2, 0x000afffeu},
        {1020, 0x200, 2, 0xfffc001eu}, {1030, 0x205, 0, 0xfffc001eu}
    };
    for (unsigned i = 0; i < 4; ++i) {
        CHECK(pointer_queue_at[i] == queued[i].at && pointer_queue[i].message == queued[i].message);
        CHECK(pointer_queue[i].wparam == queued[i].wp && pointer_queue[i].lparam == queued[i].lp);
    }
    CHECK(!rc_input_script_completed(s));
    poll_at(s, 6029); CHECK(stop_calls == 0 && !rc_input_script_completed(s));
    poll_at(s, 6030); status(s, 3, 3, 3, 0, 1, 0);
    CHECK(stop_calls == 1 && rc_input_script_completed(s));
    rc_input_script_destroy(s);
    printf("RIGHT_POINTER script ok pointer_calls=3 messages=4 parser_valid_masks=4 parser_rejections=6 polls=%u\n", polls);
}

int main(int argc, char **argv)
{
    CHECK(argc == 2);
    if (!strcmp(argv[1], "planner")) planner_table();
    else if (!strcmp(argv[1], "script")) pointer_script();
    else if (!strcmp(argv[1], "legacy")) {
        mixed_trace();
        CHECK(pointer_calls == 0 && queue_count == 0);
        printf("RIGHT_POINTER legacy ok polls=%u\n", polls);
    } else CHECK(0 && "unknown focused scenario");
    CHECK(polls <= MAX_POLLS);
    return 0;
}
