// Execute the actual frontend tick with only guest/host boundaries substituted.
// No NSApplication, window, original assets, audio or persistent preferences.
#import <AppKit/AppKit.h>
#include "macos_game_data.h"
extern "C" {
#include "rc.h"
#include "rc_platform.h"
#include "rc_input_script.h"
#include "macos_platform.h"
}
static int requested_visible;
static unsigned calls, failures;
static int last_enabled = -1;
static int token;
static BlackmoorMacPlatform *handle = reinterpret_cast<BlackmoorMacPlatform *>(&token);
static int guest_cursor_visible() { return requested_visible; }
static void record_cursor(BlackmoorMacPlatform *p, int enabled)
{
    if (p != handle) ++failures;
    ++calls;
    last_enabled = enabled;
}
[[noreturn]] static int no_guest() { abort(); }
[[noreturn]] static void no_host_call() { abort(); }
static void no_input_destroy(RcInputScript *) {}

#define rc_system_cursor_visible guest_cursor_visible
#define blackmoor_macos_set_software_cursor record_cursor
#define rc_primary_serial() 0u
#define rc_get_primary(...) 0
#define rc_input_script_load_file(...) nullptr
#define rc_input_script_destroy no_input_destroy
#define rc_set_platform(...) ((void)0)
#define rc_start(...) no_guest()
#define rc_request_stop() no_host_call()
#define blackmoor_macos_stop(...) no_host_call()
#define main unused_frontend_main
#include "../recomp/macos_recomp.mm"
#undef main

int main()
{
    @autoreleasepool {
        g.platform = nullptr;
        on_tick(nullptr, 0);
        if (calls) ++failures;
        g.platform = handle;
        for (int visible : {1, 0, 1}) {
            requested_visible = visible;
            const unsigned before = calls;
            on_tick(nullptr, 0);
            if (calls != before + 1 || last_enabled != !visible) ++failures;
        }
        g.platform = nullptr;
        const unsigned before = calls;
        on_tick(nullptr, 0);
        if (calls != before) ++failures;
        printf("CURSOR_TICK transitions=3 calls=%u failures=%u windows=%lu\n",
               calls, failures, (unsigned long)NSApp.windows.count);
        return failures ? 1 : 0;
    }
}
