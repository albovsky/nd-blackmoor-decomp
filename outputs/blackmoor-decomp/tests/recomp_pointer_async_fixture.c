/* Finite actual-host async-state regression. No rc_core/rc_main, assets,
 * guest memory, GUI, audio, device calls or mocks. Unused host functions and
 * their unavailable dependencies are discarded by the native linker. */
#ifndef RC_TEST_WIN32_SOURCE
#define RC_TEST_WIN32_SOURCE "../recomp/rc_win32.c"
#endif
#include RC_TEST_WIN32_SOURCE

static unsigned regression_checks, regression_failures;
static void expect_state(const char *name, uint32_t vk, uint32_t expected)
{
    uint32_t args[] = {vk}, actual = 0xdeadbeefu;
    int result = api_GetAsyncKeyState(NULL, args, &actual);
    regression_checks++;
    if (result != 0 || actual != expected) {
        fprintf(stderr, "CHECK %s: vk=%u expected=0x%x actual=0x%x api=%d\n",
                name, vk, expected, actual, result);
        regression_failures++;
    }
}
int main(void)
{
    /* Isolated host input globals only. No Win32/guest initialization. */
    have_plat = 0; vus = 0; rc_main_hwnd = 0;
    real_buttons = 0; btn_until = 0;
    memset(key_flag, 0, sizeof key_flag);
    memset(vk_down_until, 0, sizeof vk_down_until);

    expect_state("released", 2, 0);
    rc_input_pointer_mask(10, 20, RC_POINTER_RIGHT);
    expect_state("physical right only has no low bit", 2, 0x8000);
    rc_input_pointer_mask(10, 20, 0);
    expect_state("physical release", 2, 0);

    rc_input_key(2, 1);
    expect_state("legacy key2 flag", 2, 0x8001);
    rc_input_pointer_mask(10, 20, RC_POINTER_RIGHT);
    expect_state("key2 flag and physical overlap", 2, 0x8001);
    rc_input_key(2, 0);
    expect_state("key2 release retains physical right", 2, 0x8000);
    rc_input_pointer_mask(10, 20, 0);
    expect_state("both released", 2, 0);

    rc_input_event(2, 0, 0, 10, 2);
    expect_state("legacy timed2", 2, 0x8001);
    rc_input_pointer_mask(10, 20, RC_POINTER_RIGHT);
    expect_state("timed2 and physical overlap", 2, 0x8001);
    rc_clock_advance(10);
    expect_state("timed2 expires while physical held", 2, 0x8000);
    rc_input_pointer_mask(10, 20, 0);
    expect_state("timed2 and physical released", 2, 0);

    rc_input_mouse(10, 20, 1);
    expect_state("ordinary left", 1, 0x8001);
    rc_input_mouse(10, 20, 0);
    expect_state("ordinary left release", 1, 0);
    rc_input_event(1, 10, 20, 7, 0);
    expect_state("legacy timed left", 1, 0x8001);
    rc_clock_advance(7);
    expect_state("legacy timed left expiration", 1, 0);
    rc_input_key('A', 1);
    expect_state("ordinary key", 'A', 0x8001);
    rc_input_key('A', 0);
    expect_state("ordinary key release", 'A', 0);
    rc_input_event(2, 0, 0, 9, 'A');
    expect_state("ordinary timed key", 'A', 0x8001);
    rc_clock_advance(9);
    expect_state("ordinary timed key expiration", 'A', 0);

    printf("RIGHT_POINTER_ASYNC checks=%u failures=%u\n", regression_checks, regression_failures);
    return regression_failures ? 1 : 0;
}
