/* Actual Win32 ShowCursor adapter only; no guest, assets, GUI or audio. */
#include "../recomp/rc_win32.c"
#ifdef __APPLE__
extern int rc_system_cursor_visible(void) __attribute__((weak_import));
#else
extern int rc_system_cursor_visible(void) __attribute__((weak));
#endif

static unsigned checks, failures;
static void expect(int okay, const char *message)
{
    ++checks;
    if (!okay) { ++failures; fprintf(stderr, "CURSOR_COUNTER failure: %s\n", message); }
}

static int visible(void)
{
    int (*query)(void) = rc_system_cursor_visible;
    return query ? query() : -1;
}

int main(void)
{
    const struct { uint32_t show; int32_t result; int visible; } cases[] = {
        {0, -1, 0}, {0, -2, 0}, {1, -1, 0}, {1, 0, 1}, {1, 1, 1},
        {0, 0, 1}, {0, -1, 0}, {7, 0, 1}
    };
    expect(visible() == 1, "initial zero counter requests the system cursor");
    for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        uint32_t arguments[] = {cases[i].show};
        uint32_t result = 0;
        expect(api_ShowCursor(NULL, arguments, &result) == 0, "ShowCursor succeeds");
        expect((int32_t)result == cases[i].result, "Win32 return count is preserved");
        expect(visible() == cases[i].visible, "host predicate follows the signed counter");
    }
    printf("CURSOR_COUNTER checks=%u failures=%u\n", checks, failures);
    return failures ? 1 : 0;
}
