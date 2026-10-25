#include "macos_platform.h"
#include "native_display_geometry.h"

#import <AppKit/AppKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Carbon/Carbon.h>
#include <cmath>
#include <cstdio>
#include <new>
#include <time.h>

@class BlackmoorFrameView;
@class BlackmoorWindowOwner;

struct BlackmoorMacPlatform {
    uint32_t width;
    uint32_t height;
    BlackmoorPlatformCallbacks callbacks;
    void *context;
    bool stopped;
    NativeDisplayMode display_mode;
    __strong BlackmoorFrameView *view;
    __strong BlackmoorWindowOwner *owner;
};

@interface BlackmoorFrameView : NSView
@property(nonatomic, strong) NSImage *frameImage;
@property(nonatomic, assign) BlackmoorMacPlatform *platform;
@property(nonatomic, assign) NSEventModifierFlags previousModifiers;
@end

@interface BlackmoorWindowOwner : NSObject <NSWindowDelegate>
@property(nonatomic, strong) NSWindow *window;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, assign) BlackmoorMacPlatform *platform;
@property(nonatomic, strong) NSMenuItem *displayMenu;
@property(nonatomic, strong) NSMenuItem *fitItem;
@property(nonatomic, strong) NSMenuItem *stretchItem;
- (void)chooseFit:(id)sender;
- (void)chooseStretch:(id)sender;
@end

static NSRect surface_rect(BlackmoorMacPlatform *platform, NSRect bounds)
{
    NativeDisplayRect rect{};
    if (!native_display_layout(platform->width, platform->height,
                               bounds.size.width, bounds.size.height,
                               platform->display_mode, &rect)) return NSZeroRect;
    return NSMakeRect(bounds.origin.x + rect.x, bounds.origin.y + rect.y, rect.width, rect.height);
}

static void set_display_mode(BlackmoorMacPlatform *platform, NativeDisplayMode mode)
{
    if (platform == nullptr || platform->stopped || ![NSThread isMainThread]) return;
    platform->display_mode = mode;
    [[NSUserDefaults standardUserDefaults] setBool:mode == NATIVE_DISPLAY_STRETCH
                                           forKey:@"BlackmoorDisplayStretch"];
    platform->owner.fitItem.state = mode == NATIVE_DISPLAY_FIT ? NSControlStateValueOn : NSControlStateValueOff;
    platform->owner.stretchItem.state = mode == NATIVE_DISPLAY_STRETCH ? NSControlStateValueOn : NSControlStateValueOff;
    platform->view.needsDisplay = YES;
}

static void install_display_menu(BlackmoorMacPlatform *platform)
{
    NSMenu *main = NSApp.mainMenu;
    if (main == nil) {
        main = [[NSMenu alloc] initWithTitle:@""];
        NSMenuItem *appItem = [[NSMenuItem alloc] initWithTitle:@"Blackmoor Reconstruction" action:NULL keyEquivalent:@""];
        NSMenu *appMenu = [[NSMenu alloc] initWithTitle:@"Blackmoor Reconstruction"];
        NSMenuItem *quit = [[NSMenuItem alloc] initWithTitle:@"Quit Blackmoor Reconstruction"
            action:@selector(terminate:) keyEquivalent:@"q"];
        quit.target = NSApp;
        [appMenu addItem:quit];
        appItem.submenu = appMenu;
        [main addItem:appItem];
        NSApp.mainMenu = main;
    }
    NSMenu *viewMenu = [[NSMenu alloc] initWithTitle:@"View"];
    viewMenu.autoenablesItems = NO;
    NSMenuItem *fit = [[NSMenuItem alloc] initWithTitle:@"Proportional" action:@selector(chooseFit:) keyEquivalent:@"1"];
    NSMenuItem *stretch = [[NSMenuItem alloc] initWithTitle:@"Stretch to Fill" action:@selector(chooseStretch:) keyEquivalent:@"2"];
    for (NSMenuItem *item in @[fit, stretch]) {
        item.target = platform->owner;
        item.keyEquivalentModifierMask = NSEventModifierFlagCommand | NSEventModifierFlagOption;
        [viewMenu addItem:item];
    }
    platform->owner.fitItem = fit;
    platform->owner.stretchItem = stretch;
    fit.state = platform->display_mode == NATIVE_DISPLAY_FIT ? NSControlStateValueOn : NSControlStateValueOff;
    stretch.state = platform->display_mode == NATIVE_DISPLAY_STRETCH ? NSControlStateValueOn : NSControlStateValueOff;
    NSMenuItem *view = [[NSMenuItem alloc] initWithTitle:@"View" action:NULL keyEquivalent:@""];
    view.submenu = viewMenu;
    platform->owner.displayMenu = view;
    [main addItem:view];
}

static unsigned virtual_key(NSEvent *event)
{
    /* Physical ANSI mapping keeps press/release identity independent of Shift.
     * Text composition is a separate engine boundary, not a virtual-key event. */
    switch (event.keyCode) {
#define KEY(mac, win) case mac: return win
    KEY(kVK_ANSI_A, 'A'); KEY(kVK_ANSI_B, 'B'); KEY(kVK_ANSI_C, 'C');
    KEY(kVK_ANSI_D, 'D'); KEY(kVK_ANSI_E, 'E'); KEY(kVK_ANSI_F, 'F');
    KEY(kVK_ANSI_G, 'G'); KEY(kVK_ANSI_H, 'H'); KEY(kVK_ANSI_I, 'I');
    KEY(kVK_ANSI_J, 'J'); KEY(kVK_ANSI_K, 'K'); KEY(kVK_ANSI_L, 'L');
    KEY(kVK_ANSI_M, 'M'); KEY(kVK_ANSI_N, 'N'); KEY(kVK_ANSI_O, 'O');
    KEY(kVK_ANSI_P, 'P'); KEY(kVK_ANSI_Q, 'Q'); KEY(kVK_ANSI_R, 'R');
    KEY(kVK_ANSI_S, 'S'); KEY(kVK_ANSI_T, 'T'); KEY(kVK_ANSI_U, 'U');
    KEY(kVK_ANSI_V, 'V'); KEY(kVK_ANSI_W, 'W'); KEY(kVK_ANSI_X, 'X');
    KEY(kVK_ANSI_Y, 'Y'); KEY(kVK_ANSI_Z, 'Z');
    KEY(kVK_ANSI_0, '0'); KEY(kVK_ANSI_1, '1'); KEY(kVK_ANSI_2, '2');
    KEY(kVK_ANSI_3, '3'); KEY(kVK_ANSI_4, '4'); KEY(kVK_ANSI_5, '5');
    KEY(kVK_ANSI_6, '6'); KEY(kVK_ANSI_7, '7'); KEY(kVK_ANSI_8, '8'); KEY(kVK_ANSI_9, '9');
    KEY(kVK_ANSI_Comma, 0xbc); KEY(kVK_ANSI_Period, 0xbe); KEY(kVK_ANSI_Slash, 0xbf);
    KEY(kVK_ANSI_Semicolon, 0xba); KEY(kVK_ANSI_Quote, 0xde);
    KEY(kVK_ANSI_LeftBracket, 0xdb); KEY(kVK_ANSI_RightBracket, 0xdd);
    KEY(kVK_ANSI_Backslash, 0xdc); KEY(kVK_ANSI_Grave, 0xc0);
    KEY(kVK_ANSI_Minus, 0xbd); KEY(kVK_ANSI_Equal, 0xbb); KEY(kVK_ISO_Section, 0xe2);
    KEY(kVK_Return, 0x0d); KEY(kVK_Tab, 0x09); KEY(kVK_Space, 0x20);
    KEY(kVK_Delete, 0x08); KEY(kVK_ForwardDelete, 0x2e); KEY(kVK_Escape, 0x1b);
    KEY(kVK_LeftArrow, 0x25); KEY(kVK_UpArrow, 0x26); KEY(kVK_RightArrow, 0x27); KEY(kVK_DownArrow, 0x28);
    KEY(kVK_Home, 0x24); KEY(kVK_End, 0x23); KEY(kVK_PageUp, 0x21); KEY(kVK_PageDown, 0x22);
    KEY(kVK_F1, 0x70); KEY(kVK_F2, 0x71); KEY(kVK_F3, 0x72); KEY(kVK_F4, 0x73);
    KEY(kVK_F5, 0x74); KEY(kVK_F6, 0x75); KEY(kVK_F7, 0x76); KEY(kVK_F8, 0x77);
    KEY(kVK_F9, 0x78); KEY(kVK_F10, 0x79); KEY(kVK_F11, 0x7a); KEY(kVK_F12, 0x7b);
    KEY(kVK_ANSI_Keypad0, 0x60); KEY(kVK_ANSI_Keypad1, 0x61); KEY(kVK_ANSI_Keypad2, 0x62);
    KEY(kVK_ANSI_Keypad3, 0x63); KEY(kVK_ANSI_Keypad4, 0x64); KEY(kVK_ANSI_Keypad5, 0x65);
    KEY(kVK_ANSI_Keypad6, 0x66); KEY(kVK_ANSI_Keypad7, 0x67); KEY(kVK_ANSI_Keypad8, 0x68);
    KEY(kVK_ANSI_Keypad9, 0x69); KEY(kVK_ANSI_KeypadDecimal, 0x6e); KEY(kVK_ANSI_KeypadMultiply, 0x6a);
    KEY(kVK_ANSI_KeypadPlus, 0x6b); KEY(kVK_ANSI_KeypadMinus, 0x6d); KEY(kVK_ANSI_KeypadDivide, 0x6f);
    KEY(kVK_ANSI_KeypadEnter, 0x0d);
#undef KEY
    default: return 0;
    }
}

@implementation BlackmoorFrameView
- (BOOL)isFlipped { return YES; }
- (BOOL)acceptsFirstResponder { return YES; }
- (void)drawRect:(NSRect)dirtyRect
{
    (void)dirtyRect;
    [[NSColor blackColor] setFill];
    NSRectFill(self.bounds);
    if (self.frameImage != nil && self.platform != nullptr) {
        [self.frameImage drawInRect:surface_rect(self.platform, self.bounds)
                          fromRect:NSZeroRect operation:NSCompositingOperationCopy
                          fraction:1 respectFlipped:YES
                             hints:@{NSImageHintInterpolation: @(NSImageInterpolationNone)}];
    }
}
- (void)pointer:(NSEvent *)event kind:(BlackmoorPointerKind)kind
{
    BlackmoorMacPlatform *p = self.platform;
    if (p == nullptr || p->callbacks.pointer == nullptr) return;
    NSRect surface = surface_rect(p, self.bounds);
    if (surface.size.width <= 0 || surface.size.height <= 0) return;
    NSPoint point = [self convertPoint:event.locationInWindow fromView:nil];
    const NativeDisplayRect rect{surface.origin.x, surface.origin.y, surface.size.width, surface.size.height};
    int32_t x, y;
    if (!native_display_map_point(p->width, p->height, &rect, point.x, point.y, &x, &y)) return;
    p->callbacks.pointer(p->context, kind, x, y, (unsigned)event.buttonNumber);
}
- (void)mouseMoved:(NSEvent *)e { [self pointer:e kind:BLACKMOOR_POINTER_MOVE]; }
- (void)mouseDragged:(NSEvent *)e { [self pointer:e kind:BLACKMOOR_POINTER_MOVE]; }
- (void)rightMouseDragged:(NSEvent *)e { [self pointer:e kind:BLACKMOOR_POINTER_MOVE]; }
- (void)mouseDown:(NSEvent *)e { [self pointer:e kind:BLACKMOOR_POINTER_DOWN]; }
- (void)mouseUp:(NSEvent *)e { [self pointer:e kind:BLACKMOOR_POINTER_UP]; }
- (void)rightMouseDown:(NSEvent *)e { [self pointer:e kind:BLACKMOOR_POINTER_DOWN]; }
- (void)rightMouseUp:(NSEvent *)e { [self pointer:e kind:BLACKMOOR_POINTER_UP]; }
- (void)keyDown:(NSEvent *)e
{
    if (self.platform && self.platform->callbacks.key)
        self.platform->callbacks.key(self.platform->context, virtual_key(e), 1, e.isARepeat);
    if (self.platform && self.platform->callbacks.character &&
        !(e.modifierFlags & (NSEventModifierFlagCommand | NSEventModifierFlagControl))) {
        NSString *typed = e.characters;
        for (NSUInteger i = 0; typed != nil && i < typed.length; ++i) {
            unichar c = [typed characterAtIndex:i];
            if (c == 0x7f) c = 8; /* Backspace reaches WM_CHAR as 8 */
            if (c <= 0xff) self.platform->callbacks.character(self.platform->context, (int8_t)(uint8_t)c);
        }
    }
}
- (void)keyUp:(NSEvent *)e
{
    if (self.platform && self.platform->callbacks.key)
        self.platform->callbacks.key(self.platform->context, virtual_key(e), 0, 0);
}
- (void)flagsChanged:(NSEvent *)e
{
    const NSEventModifierFlags masks[] = {NSEventModifierFlagShift,
        NSEventModifierFlagControl, NSEventModifierFlagOption, NSEventModifierFlagCommand};
    const unsigned keys[] = {0x10, 0x11, 0x12, 0x5b};
    NSEventModifierFlags changed = self.previousModifiers ^ e.modifierFlags;
    self.previousModifiers = e.modifierFlags;
    if (!self.platform || !self.platform->callbacks.key) return;
    for (size_t i = 0; i < sizeof(keys) / sizeof(keys[0]); ++i) {
        if (changed & masks[i]) self.platform->callbacks.key(self.platform->context,
            keys[i], (e.modifierFlags & masks[i]) != 0, 0);
    }
    if (e.keyCode == kVK_CapsLock) {
        self.platform->callbacks.key(self.platform->context, 0x14, 1, 0);
        self.platform->callbacks.key(self.platform->context, 0x14, 0, 0);
    }
}
@end

@implementation BlackmoorWindowOwner
- (void)chooseFit:(id)sender { (void)sender; set_display_mode(self.platform, NATIVE_DISPLAY_FIT); }
- (void)chooseStretch:(id)sender { (void)sender; set_display_mode(self.platform, NATIVE_DISPLAY_STRETCH); }
- (void)windowWillClose:(NSNotification *)notification
{
    (void)notification;
    BlackmoorMacPlatform *p = self.platform;
    if (p == nullptr) return;
    blackmoor_macos_stop(p);
    if (p->callbacks.closed) p->callbacks.closed(p->context);
}
@end

uint32_t blackmoor_macos_monotonic_ms(void)
{
    struct timespec now;
    if (clock_gettime(CLOCK_MONOTONIC, &now) != 0) return 0;
    uint64_t milliseconds = (uint64_t)now.tv_sec * 1000 + (uint64_t)now.tv_nsec / 1000000;
    return (uint32_t)milliseconds;
}

void blackmoor_macos_set_title(BlackmoorMacPlatform *platform, const char *title)
{
    if (![NSThread isMainThread] || platform == nullptr || title == nullptr) return;
    NSString *value = [NSString stringWithUTF8String:title];
    if (value != nil) platform->owner.window.title = value;
}

BlackmoorMacPlatform *blackmoor_macos_open(
    const char *title, uint32_t width, uint32_t height,
    const BlackmoorPlatformCallbacks *callbacks, void *context,
    char *error, size_t error_capacity)
{
    if (error && error_capacity) error[0] = '\0';
    if (![NSThread isMainThread] || width == 0 || height == 0 || width > 8192 || height > 8192) {
        if (error && error_capacity) std::snprintf(error, error_capacity, "invalid surface dimensions or non-main-thread call");
        return nullptr;
    }
    BlackmoorMacPlatform *p = new (std::nothrow) BlackmoorMacPlatform{};
    if (p == nullptr) return nullptr;
    p->width = width; p->height = height; p->context = context;
    p->display_mode = [[NSUserDefaults standardUserDefaults] boolForKey:@"BlackmoorDisplayStretch"]
        ? NATIVE_DISPLAY_STRETCH : NATIVE_DISPLAY_FIT;
    if (callbacks) p->callbacks = *callbacks;
    [NSApplication sharedApplication];
    [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
    p->owner = [[BlackmoorWindowOwner alloc] init];
    p->owner.platform = p;
    install_display_menu(p);
    p->view = [[BlackmoorFrameView alloc] initWithFrame:NSMakeRect(0, 0, width, height)];
    p->view.platform = p;
    p->view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    NSWindow *window = [[NSWindow alloc] initWithContentRect:p->view.frame
        styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskClosable |
                  NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable
        backing:NSBackingStoreBuffered defer:NO];
    window.releasedWhenClosed = NO;
    window.title = title ? [NSString stringWithUTF8String:title] : @"Nancy Drew";
    if (window.title == nil) window.title = @"Nancy Drew";
    window.contentView = p->view;
    window.delegate = p->owner;
    window.acceptsMouseMovedEvents = YES;
    p->owner.window = window;
    [window center];
    [window makeKeyAndOrderFront:nil];
    [window makeFirstResponder:p->view];
    if (@available(macOS 14.0, *)) [NSApp activate];
    else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [NSApp activateIgnoringOtherApps:YES];
#pragma clang diagnostic pop
    }
    __weak BlackmoorWindowOwner *owner = p->owner;
    p->owner.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 / 60.0 repeats:YES block:^(NSTimer *timer) {
        (void)timer;
        BlackmoorMacPlatform *current = owner.platform;
        if (current && !current->stopped && current->callbacks.tick)
            current->callbacks.tick(current->context, blackmoor_macos_monotonic_ms());
    }];
    return p;
}

int blackmoor_macos_present(BlackmoorMacPlatform *p,
                            const uint8_t *rgba, size_t capacity, size_t row_bytes)
{
    if (!p || !rgba || ![NSThread isMainThread] || row_bytes < (size_t)p->width * 4 ||
        row_bytes > SIZE_MAX / p->height || row_bytes * p->height > capacity ||
        row_bytes * p->height > 268435456u) return 0;
    NSData *data = [NSData dataWithBytes:rgba length:row_bytes * p->height];
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    CGColorSpaceRef color = CGColorSpaceCreateWithName(kCGColorSpaceSRGB);
    if (!provider || !color) {
        if (provider) CGDataProviderRelease(provider);
        if (color) CGColorSpaceRelease(color);
        return 0;
    }
    CGImageRef image = CGImageCreate(p->width, p->height, 8, 32, row_bytes, color,
        kCGImageAlphaLast, provider, nullptr, false, kCGRenderingIntentDefault);
    CGDataProviderRelease(provider); CGColorSpaceRelease(color);
    if (!image) return 0;
    p->view.frameImage = [[NSImage alloc] initWithCGImage:image size:NSMakeSize(p->width, p->height)];
    CGImageRelease(image);
    p->view.needsDisplay = YES;
    return 1;
}

void blackmoor_macos_run(BlackmoorMacPlatform *p)
{
    if (p && !p->stopped && [NSThread isMainThread]) [NSApp run];
}

void blackmoor_macos_stop(BlackmoorMacPlatform *p)
{
    if (!p || p->stopped || ![NSThread isMainThread]) return;
    p->stopped = true;
    [p->owner.timer invalidate];
    [NSApp stop:nil];
    NSEvent *wake = [NSEvent otherEventWithType:NSEventTypeApplicationDefined
        location:NSZeroPoint modifierFlags:0 timestamp:0 windowNumber:0
        context:nil subtype:0 data1:0 data2:0];
    [NSApp postEvent:wake atStart:YES];
}

void blackmoor_macos_close(BlackmoorMacPlatform *p)
{
    if (!p || ![NSThread isMainThread]) return;
    blackmoor_macos_stop(p);
    NSMenuItem *display = p->owner.displayMenu;
    if (display.menu != nil) [display.menu removeItem:display];
    p->owner.window.delegate = nil;
    [p->owner.window close];
    p->view.platform = nullptr; p->owner.platform = nullptr;
    delete p;
}
