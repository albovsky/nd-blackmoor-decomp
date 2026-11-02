/* Opt-in background acceptance fixture. Never invokes the foreground opener,
 * audio, game code, OS input, window ordering or an activation request.
 * Requires an explicit unlocked-desktop authorization before execution. */
#import <AppKit/AppKit.h>
#include "macos_platform_background.h"
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <exception>
#include <sys/types.h>
#include <vector>

struct Fixture {
    BlackmoorMacPlatform *platform = nullptr;
    std::vector<uint8_t> rgba;
    pid_t pid = 0;
    unsigned ticks = 0, presentations = 0, activations = 0, failures = 0;
    bool closed = false;
};

static void fail(Fixture &f, const char *where, const char *reason) noexcept
{
    ++f.failures;
    std::fprintf(stderr, "BACKGROUND_PLATFORM failure where=%s reason=%s\n",
                 where, reason ? reason : "unknown");
}

/* No exception may escape an AppKit callback or leave the fixture uncaught. */
template<class Work> static void guarded(Fixture &f, const char *where, Work work) noexcept
{
    try {
        @try { work(); }
        @catch (NSException *exception) {
            fail(f, where, exception.reason.UTF8String);
        }
    } catch (const std::exception &exception) {
        fail(f, where, exception.what());
    } catch (...) {
        fail(f, where, "unknown C++ exception");
    }
}

static void stop_safely(Fixture &f) noexcept
{
    guarded(f, "stop", [&] {
        if (f.platform && [NSThread isMainThread]) blackmoor_macos_stop(f.platform);
    });
}

static void check_background(Fixture &f, const char *where, bool require_window)
{
    if (![NSThread isMainThread]) fail(f, where, "not on main thread");
    if (!NSApp) { fail(f, where, "NSApplication absent"); return; }
    if (NSApp.activationPolicy != NSApplicationActivationPolicyAccessory)
        fail(f, where, "activation policy is not Accessory");
    if (NSApp.isActive || NSRunningApplication.currentApplication.isActive)
        fail(f, where, "application became active");
    NSRunningApplication *front = NSWorkspace.sharedWorkspace.frontmostApplication;
    if (front && front.processIdentifier == f.pid) fail(f, where, "process became frontmost");
    NSArray<NSWindow *> *windows = NSApp.windows;
    if (require_window && windows.count == 0) fail(f, where, "retained window absent");
    if (NSApp.keyWindow) fail(f, where, "application has a key window");
    for (NSWindow *window in windows) {
        if (window.isVisible) fail(f, where, "window became visible");
        if (window.isKeyWindow) fail(f, where, "window became key");
    }
    if (f.activations) fail(f, where, "own-process workspace activation observed");
    std::printf("BACKGROUND_PLATFORM check=%s ticks=%u windows=%lu active=%d policy=%ld activations=%u\n",
                where, f.ticks, (unsigned long)windows.count, (int)NSApp.isActive,
                (long)NSApp.activationPolicy, f.activations);
}

static void present_frame(Fixture &f)
{
    if (!blackmoor_macos_present(f.platform, f.rgba.data(), f.rgba.size(), 640u * 4u))
        fail(f, "present", "640x480 RGBA frame rejected");
    else ++f.presentations;
}

static void on_tick(void *context, uint32_t monotonic_ms) noexcept
{
    (void)monotonic_ms;
    Fixture &f = *static_cast<Fixture *>(context);
    guarded(f, "tick", [&] {
        ++f.ticks;
        if (f.ticks > 4) fail(f, "tick", "more than four callbacks");
        check_background(f, "tick", true);
        present_frame(f);
    });
    if (f.ticks >= 4 || f.failures) stop_safely(f);
}

static void on_closed(void *context) noexcept
{
    Fixture &f = *static_cast<Fixture *>(context);
    fail(f, "closed callback", "window closed before fixture teardown");
    stop_safely(f);
}

static int run_fixture()
{
    Fixture f;
    __strong id observer = nil;
    __strong NSTimer *watchdog = nil;
    Fixture *state = &f;
    guarded(f, "setup/run", [&] {
        if (![NSThread isMainThread]) { fail(f, "setup", "not on main thread"); return; }
        f.pid = NSProcessInfo.processInfo.processIdentifier;
        observer = [NSWorkspace.sharedWorkspace.notificationCenter
            addObserverForName:NSWorkspaceDidActivateApplicationNotification object:nil
            queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *notification) {
                guarded(*state, "workspace notification", [&] {
                    NSRunningApplication *app = notification.userInfo[NSWorkspaceApplicationKey];
                    if (app && app.processIdentifier == state->pid) {
                        ++state->activations;
                        fail(*state, "workspace notification", "own process activated");
                    }
                });
                if (state->failures) stop_safely(*state);
            }];
        if (!observer) { fail(f, "setup", "workspace observer unavailable"); return; }
        f.rgba.resize(640u * 480u * 4u);
        for (unsigned y = 0; y < 480; ++y) for (unsigned x = 0; x < 640; ++x) {
            size_t offset = ((size_t)y * 640u + x) * 4u;
            f.rgba[offset] = (uint8_t)x;
            f.rgba[offset + 1] = (uint8_t)y;
            f.rgba[offset + 2] = (uint8_t)(x + y);
            f.rgba[offset + 3] = 255;
        }
        BlackmoorPlatformCallbacks callbacks{};
        callbacks.tick = on_tick;
        callbacks.closed = on_closed;
        char error[256] = {0};
        f.platform = blackmoor_macos_open_background("Blackmoor background acceptance",
            640, 480, &callbacks, &f, error, sizeof error);
        if (!f.platform) { fail(f, "open_background", error[0] ? error : "null result"); return; }
        check_background(f, "immediate", true);
        present_frame(f);
        if (f.failures) return;
        watchdog = [NSTimer scheduledTimerWithTimeInterval:2.0 repeats:NO block:^(NSTimer *timer) {
            (void)timer;
            fail(*state, "watchdog", "four platform timer ticks did not complete");
            stop_safely(*state);
        }];
        blackmoor_macos_run(f.platform);
        check_background(f, "after_run", true);
    });
    guarded(f, "invalidate watchdog", [&] { [watchdog invalidate]; watchdog = nil; });
    stop_safely(f);
    guarded(f, "close", [&] {
        BlackmoorMacPlatform *platform = f.platform;
        f.platform = nullptr;
        if (platform) { blackmoor_macos_close(platform); f.closed = true; }
    });
    /* Drain already-enqueued workspace observations before removing the token. */
    guarded(f, "notification drain", [&] {
        [NSRunLoop.currentRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];
        if (NSApp) check_background(f, "after_close", false);
    });
    guarded(f, "remove observer", [&] {
        if (observer) [NSWorkspace.sharedWorkspace.notificationCenter removeObserver:observer];
        observer = nil;
    });
    if (f.ticks != 4) fail(f, "result", "expected exactly four platform timer callbacks");
    if (f.presentations != 5) fail(f, "result", "expected immediate plus four accepted presentations");
    if (!f.closed) fail(f, "result", "platform did not close normally");
    std::printf("BACKGROUND_PLATFORM ticks=%u presentations=%u activations=%u failures=%u closed=%d\n",
                f.ticks, f.presentations, f.activations, f.failures, (int)f.closed);
    return f.failures ? 1 : 0;
}

int main()
{
    const char *opt_in = std::getenv("BLACKMOOR_BACKGROUND_UI_TEST");
    if (!opt_in || std::strcmp(opt_in, "1") != 0) {
        std::printf("BACKGROUND_PLATFORM skipped: explicit UI-test opt-in absent\n");
        return 0;
    }
    try {
        @try {
            @autoreleasepool { return run_fixture(); }
        } @catch (NSException *exception) {
            std::fprintf(stderr, "BACKGROUND_PLATFORM uncaught boundary exception: %s\n",
                         exception.reason.UTF8String ?: "unknown Objective-C exception");
        }
    } catch (const std::exception &exception) {
        std::fprintf(stderr, "BACKGROUND_PLATFORM boundary error: %s\n", exception.what());
    } catch (...) {
        std::fprintf(stderr, "BACKGROUND_PLATFORM unknown boundary error\n");
    }
    return 1;
}
