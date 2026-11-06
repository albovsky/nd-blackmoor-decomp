// Hidden synthetic view only: no game, audio, window ordering, mouse movement
// or NSCursor set/hide calls. Observe the actual view's cursor registration.
#include "../src/macos_platform.mm"
#import <objc/runtime.h>
#include <dlfcn.h>
#include <vector>

static unsigned checks, failures;
static void check(bool value, const char *message)
{
    ++checks;
    if (!value) { ++failures; fprintf(stderr, "CURSOR failure: %s\n", message); }
}

@interface CursorRecordingView : BlackmoorFrameView
@property(nonatomic, strong) NSMutableArray<NSValue *> *regions;
@property(nonatomic, strong) NSMutableArray<NSCursor *> *cursors;
@property(nonatomic, assign) BOOL clipped;
@property(nonatomic, assign) NSRect clip;
@end
@implementation CursorRecordingView
- (void)addCursorRect:(NSRect)rect cursor:(NSCursor *)cursor
{
    // Do not register a cursor with the window server in this fixture.
    [self.regions addObject:[NSValue valueWithRect:rect]];
    [self.cursors addObject:cursor];
}
- (NSRect)visibleRect
{
    NSRect visible = [super visibleRect];
    return self.clipped ? NSIntersectionRect(visible, self.clip) : visible;
}
@end

@interface CursorRecordingWindow : NSWindow
@property(nonatomic, assign) unsigned invalidations;
@end
@implementation CursorRecordingWindow
- (void)invalidateCursorRectsForView:(NSView *)view
{
    ++self.invalidations;
    [super invalidateCursorRectsForView:view];
}
@end

static void reset(CursorRecordingWindow *window, CursorRecordingView *view)
{
    [view.regions removeAllObjects];
    [view.cursors removeAllObjects];
    [window resetCursorRects];
}

static void expect_region(CursorRecordingWindow *window, CursorRecordingView *view,
                          NSRect expected, const char *message)
{
    reset(window, view);
    check(view.regions.count == 1, message);
    if (view.regions.count == 1) check(NSEqualRects(view.regions[0].rectValue, expected), message);
}

static void ignore_display_preference(id, SEL, BOOL, NSString *) {}
static void change_mode(BlackmoorMacPlatform *platform, NativeDisplayMode mode)
{
    // Substitute only the persistent preferences write; real layout/menu and
    // cursor invalidation still execute. No owner or fixture defaults change.
    Method method = class_getInstanceMethod(NSUserDefaults.class, @selector(setBool:forKey:));
    IMP prior = method_setImplementation(method, (IMP)ignore_display_preference);
    set_display_mode(platform, mode);
    method_setImplementation(method, prior);
}

int main()
{
    @autoreleasepool {
        [NSApplication sharedApplication];
        [NSApp setActivationPolicy:NSApplicationActivationPolicyAccessory];
        __block unsigned activations = 0;
        id observer = [NSNotificationCenter.defaultCenter
            addObserverForName:NSApplicationDidBecomeActiveNotification object:NSApp queue:nil
            usingBlock:^(NSNotification *) { ++activations; }];
        auto *platform = new BlackmoorMacPlatform{};
        platform->width = 640;
        platform->height = 480;
        platform->display_mode = NATIVE_DISPLAY_FIT;
        platform->owner = [[BlackmoorWindowOwner alloc] init];
        platform->owner.platform = platform;
        CursorRecordingView *view = [[CursorRecordingView alloc] initWithFrame:NSMakeRect(0, 0, 960, 480)];
        view.regions = [NSMutableArray array];
        view.cursors = [NSMutableArray array];
        view.platform = platform;
        platform->view = view;
        CursorRecordingWindow *window = [[CursorRecordingWindow alloc]
            initWithContentRect:view.frame styleMask:NSWindowStyleMaskTitled
            backing:NSBackingStoreBuffered defer:NO];
        window.releasedWhenClosed = NO;
        window.contentView = view;
        platform->owner.window = window;

        using SetSoftwareCursor = void (*)(BlackmoorMacPlatform *, int);
        auto enable = (SetSoftwareCursor)dlsym(RTLD_DEFAULT, "blackmoor_macos_set_software_cursor");
        reset(window, view);
        check(view.regions.count == 0, "default clients keep their system cursor");
        if (enable) enable(platform, 1);
        reset(window, view);
        check(view.regions.count == 0, "system cursor stays visible until first frame");

        std::vector<uint8_t> rgba(640 * 480 * 4, 255);
        unsigned before = window.invalidations;
        check(blackmoor_macos_present(platform, rgba.data(), rgba.size(), 640 * 4), "first frame accepted");
        check(window.invalidations > before, "first frame refreshes cursor rectangles");
        expect_region(window, view, NSMakeRect(160, 0, 640, 480), "fit leaves left and right bars uncovered");
        if (view.cursors.count == 1) {
            NSCursor *cursor = view.cursors[0];
            NSBitmapImageRep *image = [[NSBitmapImageRep alloc] initWithData:cursor.image.TIFFRepresentation];
            check(image != nil && image.hasAlpha, "cursor image decodes with alpha");
            bool transparent = image != nil;
            for (NSInteger y = 0; y < image.pixelsHigh; ++y)
                for (NSInteger x = 0; x < image.pixelsWide; ++x)
                    transparent = transparent && [image colorAtX:x y:y].alphaComponent == 0;
            check(transparent, "cursor image is fully transparent");
        }
        before = window.invalidations;
        blackmoor_macos_present(platform, rgba.data(), rgba.size(), 640 * 4);
        check(window.invalidations == before, "ordinary frames do not churn cursor rectangles");

        before = window.invalidations;
        [window setContentSize:NSMakeSize(320, 480)];
        check(window.invalidations > before, "resize refreshes cursor rectangles");
        expect_region(window, view, NSMakeRect(0, 120, 320, 240), "narrow fit leaves top and bottom bars uncovered");
        [window setContentSize:NSMakeSize(1920, 480)];
        expect_region(window, view, NSMakeRect(640, 0, 640, 480), "very wide fit leaves bars uncovered");
        before = window.invalidations;
        change_mode(platform, NATIVE_DISPLAY_STRETCH);
        check(window.invalidations > before, "display-mode change refreshes cursor rectangles");
        expect_region(window, view, NSMakeRect(0, 0, 1920, 480), "stretch uses the full picture");
        view.clipped = YES;
        view.clip = NSMakeRect(20, 30, 100, 110);
        expect_region(window, view, view.clip, "cursor rectangle is confined to visible view");
        view.clipped = NO;

        if (enable) enable(platform, 0);
        reset(window, view);
        check(view.regions.count == 0, "disabling restores the system cursor");
        if (enable) enable(platform, 1);
        expect_region(window, view, NSMakeRect(0, 0, 1920, 480), "reenabling restores software-cursor policy");
        before = window.invalidations;
        blackmoor_macos_stop(platform);
        check(window.invalidations > before, "stopping refreshes cursor rectangles");
        reset(window, view);
        check(view.regions.count == 0, "stopped view no longer suppresses system cursor");
        if (enable) enable(platform, 1);
        reset(window, view);
        check(view.regions.count == 0, "stopped platform cannot reenable suppression");
        blackmoor_macos_close(platform);
        check(view.platform == nullptr, "close detaches the view from platform state");
        check(!window.visible && !window.keyWindow, "fixture window never becomes visible or key");
        check(activations == 0, "fixture makes no activation request");
        [NSNotificationCenter.defaultCenter removeObserver:observer];
        printf("SOFTWARE_CURSOR checks=%u failures=%u activations=%u visible=%d key=%d\n",
               checks, failures, activations, (int)window.visible, (int)window.keyWindow);
        return failures ? 1 : 0;
    }
}
