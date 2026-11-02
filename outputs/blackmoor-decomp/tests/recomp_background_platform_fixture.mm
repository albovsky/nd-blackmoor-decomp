/* Opt-in background acceptance fixture. Never invokes the foreground opener,
 * audio, game code, OS input, window ordering or an activation request.
 * Requires an explicit unlocked-desktop authorization before execution. */
#import <AppKit/AppKit.h>
#import <CoreGraphics/CoreGraphics.h>
#include "macos_platform_background.h"
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <exception>
#include <sys/types.h>
#include <vector>

struct PointerRecord {
    BlackmoorPointerKind kind;
    int32_t x, y;
    unsigned button;
};

struct PointerCase {
    NSEventType type;
    CGFloat view_x, view_y;
    BlackmoorPointerKind kind;
    int32_t fit_x, stretch_x, logical_y;
    unsigned button;
};

/* At 960x480, fit has a 640x480 surface at x=160; stretch uses all 960x480.
 * Expected coordinates are fixed here, not obtained from the mapping helper. */
static const PointerCase pointer_cases[] = {
    {NSEventTypeMouseMoved,          0,   0, BLACKMOOR_POINTER_MOVE, -160,   0,   0, 0},
    {NSEventTypeLeftMouseDown,     160,  10, BLACKMOOR_POINTER_DOWN,    0, 106,  10, 0},
    {NSEventTypeLeftMouseDragged,  480, 240, BLACKMOOR_POINTER_MOVE,  320, 320, 240, 0},
    {NSEventTypeLeftMouseUp,       799, 479, BLACKMOOR_POINTER_UP,    639, 532, 479, 0},
    {NSEventTypeRightMouseDown,     80, 120, BLACKMOOR_POINTER_DOWN,  -80,  53, 120, 1},
    {NSEventTypeRightMouseDragged, 880, 360, BLACKMOOR_POINTER_MOVE,  720, 586, 360, 1},
    {NSEventTypeRightMouseUp,      800,  20, BLACKMOOR_POINTER_UP,    640, 533,  20, 1},
    {NSEventTypeMouseMoved,        159,  30, BLACKMOOR_POINTER_MOVE,   -1, 106,  30, 0},
    {NSEventTypeRightMouseDown,    480,   0, BLACKMOOR_POINTER_DOWN,  320, 320,   0, 1},
    {NSEventTypeRightMouseUp,      480, 480, BLACKMOOR_POINTER_UP,    320, 320, 480, 1},
};
static const size_t pointer_case_count = sizeof pointer_cases / sizeof pointer_cases[0];

struct Fixture {
    BlackmoorMacPlatform *platform = nullptr;
    std::vector<uint8_t> rgba;
    std::vector<PointerRecord> pointers;
    pid_t pid = 0;
    unsigned ticks = 0, presentations = 0, activations = 0, failures = 0;
    unsigned pointer_checks = 0;
    bool closed = false, stretch = false, pointer_exercised = false;
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

/* Borrow the actual hidden content view only during each operation. */
static NSWindow *fixture_window(Fixture &f)
{
    NSWindow *found = nil;
    for (NSWindow *window in NSApp.windows) {
        if (![window.title isEqualToString:@"Blackmoor background acceptance"]) continue;
        if (found) { fail(f, "view", "duplicate fixture window"); return nil; }
        found = window;
    }
    if (!found || !found.contentView) fail(f, "view", "fixture content view absent");
    return found;
}

static void resize_hidden_view(Fixture &f)
{
    check_background(f, "before_resize", true);
    NSWindow *window = fixture_window(f);
    if (!window || !window.contentView) return;
    [window setContentSize:NSMakeSize(960, 480)];
    [window.contentView layoutSubtreeIfNeeded];
    if (!NSEqualRects(window.contentView.bounds, NSMakeRect(0, 0, 960, 480)))
        fail(f, "resize", "hidden content bounds are not 960x480 at origin zero");
    if (![window.contentView isFlipped]) fail(f, "resize", "content origin is not top left");
    check_background(f, "after_resize", true);
}

static void on_pointer(void *context, BlackmoorPointerKind kind,
                       int32_t x, int32_t y, unsigned button) noexcept
{
    Fixture &f = *static_cast<Fixture *>(context);
    guarded(f, "pointer callback", [&] {
        if (![NSThread isMainThread]) fail(f, "pointer callback", "not on main thread");
        f.pointers.push_back({kind, x, y, button});
        std::printf("BACKGROUND_POINTER mode=%s callback=%lu kind=%d x=%d y=%d button=%u\n",
                    f.stretch ? "stretch" : "fit", (unsigned long)f.pointers.size(),
                    (int)kind, (int)x, (int)y, button);
    });
}

static void exercise_pointer(Fixture &f)
{
    f.pointer_exercised = true;
    check_background(f, "before_pointer", true);
    NSWindow *window = fixture_window(f);
    NSView *view = window.contentView;
    if (!window || !view) return;
    if (!NSEqualRects(view.bounds, NSMakeRect(0, 0, 960, 480))) {
        fail(f, "pointer", "content bounds changed after resize"); return;
    }
    if (!f.pointers.empty()) { fail(f, "pointer", "unexpected prior pointer callback"); return; }
    for (size_t i = 0; i < pointer_case_count; ++i) {
        const PointerCase &c = pointer_cases[i];
        NSPoint location = [view convertPoint:NSMakePoint(c.view_x, c.view_y) toView:nil];
        const bool pressed = c.type == NSEventTypeLeftMouseDown ||
            c.type == NSEventTypeRightMouseDown || c.type == NSEventTypeLeftMouseDragged ||
            c.type == NSEventTypeRightMouseDragged;
        NSEvent *event = [NSEvent mouseEventWithType:c.type location:location
            modifierFlags:0 timestamp:0.001 * (double)(i + 1) windowNumber:window.windowNumber
            context:nil eventNumber:(NSInteger)(i + 1)
            clickCount:(c.kind == BLACKMOOR_POINTER_MOVE ? 0 : 1) pressure:(pressed ? 1.0 : 0.0)];
        /* The AppKit factory has no button-number argument. Set the public
         * Quartz field on a private copy; this event is never posted. */
        if (event && c.button) {
            CGEventRef quartz = event.CGEvent ? CGEventCreateCopy(event.CGEvent) : nullptr;
            if (!quartz) { fail(f, "pointer", "synthetic Quartz event copy failed"); return; }
            CGEventSetIntegerValueField(quartz, kCGMouseEventButtonNumber, c.button);
            event = [NSEvent eventWithCGEvent:quartz];
            CFRelease(quartz);
        }
        if (!event || event.type != c.type || (unsigned)event.buttonNumber != c.button ||
            event.windowNumber != window.windowNumber || !NSEqualPoints(event.locationInWindow, location)) {
            std::fprintf(stderr, "BACKGROUND_POINTER construction case=%lu expected_type=%lu actual_type=%lu expected_button=%u actual_button=%ld expected_window=%ld actual_window=%ld expected_location=%.1f,%.1f actual_location=%.1f,%.1f\n",
                         (unsigned long)i, (unsigned long)c.type, (unsigned long)event.type,
                         c.button, (long)event.buttonNumber, (long)window.windowNumber,
                         (long)event.windowNumber, (double)location.x, (double)location.y,
                         (double)event.locationInWindow.x, (double)event.locationInWindow.y);
            fail(f, "pointer", "synthetic event type/button construction failed"); return;
        }
        const size_t before = f.pointers.size();
        /* These are direct view calls. Never enqueue or post an OS event. */
        switch (c.type) {
        case NSEventTypeMouseMoved: [view mouseMoved:event]; break;
        case NSEventTypeLeftMouseDown: [view mouseDown:event]; break;
        case NSEventTypeLeftMouseDragged: [view mouseDragged:event]; break;
        case NSEventTypeLeftMouseUp: [view mouseUp:event]; break;
        case NSEventTypeRightMouseDown: [view rightMouseDown:event]; break;
        case NSEventTypeRightMouseDragged: [view rightMouseDragged:event]; break;
        case NSEventTypeRightMouseUp: [view rightMouseUp:event]; break;
        default: fail(f, "pointer", "unexpected event-table type"); return;
        }
        if (f.pointers.size() != before + 1) {
            fail(f, "pointer", "expected one synchronous callback per direct view event"); return;
        }
        const PointerRecord &actual = f.pointers.back();
        const int32_t expected_x = f.stretch ? c.stretch_x : c.fit_x;
        if (actual.kind != c.kind || actual.x != expected_x ||
            actual.y != c.logical_y || actual.button != c.button) {
            std::fprintf(stderr, "BACKGROUND_POINTER case=%lu expected_kind=%d x=%d y=%d button=%u\n",
                         (unsigned long)i, (int)c.kind, (int)expected_x, (int)c.logical_y, c.button);
            fail(f, "pointer", "logical callback did not match fixed expectation");
        } else ++f.pointer_checks;
    }
    check_background(f, "after_pointer", true);
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
        if (f.ticks == 1) exercise_pointer(f);
    });
    if (f.ticks >= 4 || f.failures) stop_safely(f);
}

static void on_closed(void *context) noexcept
{
    Fixture &f = *static_cast<Fixture *>(context);
    fail(f, "closed callback", "window closed before fixture teardown");
    stop_safely(f);
}

static int run_fixture(bool stretch)
{
    Fixture f;
    f.stretch = stretch;
    __strong id observer = nil;
    __strong NSTimer *watchdog = nil;
    Fixture *state = &f;
    guarded(f, "setup/run", [&] {
        if (![NSThread isMainThread]) { fail(f, "setup", "not on main thread"); return; }
        /* The argument domain is volatile and process-local, unlike saved preferences.
         * Set the mode before opening; each mode runs in a separate process. */
        NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
        NSMutableDictionary *arguments = [[defaults volatileDomainForName:NSArgumentDomain] mutableCopy];
        if (!arguments) arguments = [NSMutableDictionary dictionary];
        arguments[@"BlackmoorDisplayStretch"] = @(stretch);
        [defaults setVolatileDomain:arguments forName:NSArgumentDomain];
        if ([defaults boolForKey:@"BlackmoorDisplayStretch"] != stretch) {
            fail(f, "setup", "volatile display-mode override was not applied"); return;
        }
        f.pointers.reserve(pointer_case_count);
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
        callbacks.pointer = on_pointer;
        callbacks.closed = on_closed;
        char error[256] = {0};
        f.platform = blackmoor_macos_open_background("Blackmoor background acceptance",
            640, 480, &callbacks, &f, error, sizeof error);
        if (!f.platform) { fail(f, "open_background", error[0] ? error : "null result"); return; }
        check_background(f, "immediate", true);
        resize_hidden_view(f);
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
    if (!f.pointer_exercised || f.pointer_checks != pointer_case_count ||
        f.pointers.size() != pointer_case_count)
        fail(f, "result", "expected ten checked direct-view pointer callbacks");
    std::printf("BACKGROUND_PLATFORM ticks=%u presentations=%u activations=%u failures=%u closed=%d\n",
                f.ticks, f.presentations, f.activations, f.failures, (int)f.closed);
    std::printf("BACKGROUND_POINTER mode=%s content=960x480 events=%lu checked=%u\n",
                f.stretch ? "stretch" : "fit", (unsigned long)f.pointers.size(), f.pointer_checks);
    return f.failures ? 1 : 0;
}

int main(int argc, char **argv)
{
    const char *opt_in = std::getenv("BLACKMOOR_BACKGROUND_UI_TEST");
    if (!opt_in || std::strcmp(opt_in, "1") != 0) {
        std::printf("BACKGROUND_PLATFORM skipped: explicit UI-test opt-in absent\n");
        return 0;
    }
    if (argc != 3 || std::strcmp(argv[1], "--display") != 0 ||
        (std::strcmp(argv[2], "fit") != 0 && std::strcmp(argv[2], "stretch") != 0)) {
        std::fprintf(stderr, "BACKGROUND_PLATFORM expected --display fit|stretch\n");
        return 1;
    }
    try {
        @try {
            @autoreleasepool { return run_fixture(std::strcmp(argv[2], "stretch") == 0); }
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
