/* Presentation-boundary regression against the actual app receiver. No assets,
 * output device, window, deliberate fault or original-x86 execution. */
#define main blackmoor_app_entry_for_display_test
#include "../src/blackmoor_app.mm"
#undef main
#include <csignal>

static void fixture_signal(int number) { _exit(128 + number); }

int main(void)
{
    std::signal(SIGBUS, fixture_signal);
    std::signal(SIGSEGV, fixture_signal);
    std::signal(SIGABRT, fixture_signal);
    std::signal(SIGILL, fixture_signal);
    @autoreleasepool {
        NativeApp app;
        app.log = std::tmpfile();
        if (app.log == nullptr) return 2;
        /* taskbar_active only tests this identity for nonnull; no session call
         * occurs. The ready synthetic bar isolates the stale-hover receiver. */
        app.session = reinterpret_cast<SceneSession *>(&app);
        app.bar_ready = true;
        app.bar.state = 1;
        const int32_t points[][2] = {{-1, 460}, {320, -1}, {640, 460}, {320, 480},
                                    {INT32_MIN, 460}, {INT32_MAX, 460}};
        bool passed = true;
        for (const auto &point : points) {
            app.bar.button[0].hovered = 1;
            app.bar.button[0].state = TASKBAR_STATE_HOVER;
            app.bar.event = TASKBAR_EVENT_BUTTON;
            app.bar_swallow_up = false;
            const bool consumed = taskbar_pointer_event(&app, BLACKMOOR_POINTER_DOWN, 0,
                                                        point[0], point[1]);
            if (consumed || app.bar.button[0].state != TASKBAR_STATE_HOVER || app.bar_swallow_up) {
                std::fprintf(stderr, "CHECK failed: outside press reused taskbar hover at %d,%d\n",
                             point[0], point[1]);
                passed = false;
            }
            /* A press owned inside the surface must still swallow its release
             * outside, otherwise its ownership can stick across later clicks. */
            app.bar_swallow_up = true;
            if (!taskbar_pointer_event(&app, BLACKMOOR_POINTER_UP, 0, point[0], point[1]) ||
                app.bar_swallow_up) passed = false;
        }
        app.session = nullptr;
        std::fclose(app.log);
        std::printf("DISPLAY_TASKBAR outside_cases=6 release_ownership=6 passed=%d\n", passed);
        return passed ? 0 : 1;
    }
}
