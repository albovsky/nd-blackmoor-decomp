// macOS front end for the recompiled GAME.EXE.
//
// The lifted game runs on its own thread inside the native host (rc_*.c). This file gives it a window, input and sound from the app's
// existing platform layer (macos_platform.mm: the window, the fit/stretch display with 640x480 logical pointer coordinates, keys) and
// the bink_player/bink_audio FFmpeg adapters, and an AVAudioEngine source node that pulls the DirectSound mix. It replaces none of the
// host: GAME.EXE is read at start-up (read only) and never written.
//
//   BlackmoorRecompiled [--game-dir DIR] [--exe GAME.EXE] [--save-dir DIR] [--mute] [--capture-audio FILE.wav] [--log FILE] [--background] [--stop-after-ms N] [--snapshot FILE.ppm]
//
// DIR is the game folder (Ciftree, CDSound, CDVideo, Game.ini ...); GAME.EXE defaults to DIR/GAME.EXE.
#import <AppKit/AppKit.h>
#import <AVFAudio/AVFAudio.h>
#import <Foundation/Foundation.h>

#include <dispatch/dispatch.h>
#include <errno.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <time.h>
#include <atomic>
#include <chrono>
#include <thread>
#include <unistd.h>
#include <string>
#include <vector>
#include "audio_capture.h"

extern "C" {
#include "bink_audio.h"
#include "bink_player.h"
#include "macos_platform.h"
#include "macos_platform_background.h"
#include "rc_platform.h"
}

namespace {

constexpr uint32_t kLogicalWidth = 640, kLogicalHeight = 480;
constexpr uint32_t kAudioRate = 44100;
constexpr uint32_t kDefaultBackgroundStopMs = 5000, kMaxStopAfterMs = 600000;

struct Recomp {
    BlackmoorMacPlatform *platform = nullptr;
    pthread_t game_thread{};
    bool game_thread_started = false;
    std::atomic<bool> game_done{false};
    std::vector<uint8_t> rgba;
    uint64_t last_serial = ~0ull;
    int left_down = 0;
    int32_t pointer_x = 0, pointer_y = 0;
    bool muted = false;
    bool background = false, terminate_requested = false;
    uint32_t stop_after_ms = 0;
    uint64_t stop_deadline_ms = 0;
    std::string snapshot_path;
    std::atomic<bool> background_failed{false};
    std::atomic<unsigned> background_activations{0};
    id activation_observer = nil;
    FILE *log = nullptr;
    std::string game_dir, exe, save_dir;
    AVAudioEngine *engine = nil;
    std::atomic<bool> audio_stopping{false};
    std::atomic<unsigned> audio_callbacks{0};
    std::atomic<bool> capture_failed{false};
    bool capture_enabled = false, capture_reported = false;
    std::thread silent_thread;
    AudioCapture capture;
};

Recomp g;

uint64_t now_ms(void *)
{
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC, &t);
    return (uint64_t)t.tv_sec * 1000u + (uint64_t)t.tv_nsec / 1000000u;
}

void sleep_ms(void *, uint32_t ms)
{
    struct timespec t = {(time_t)(ms / 1000u), (long)(ms % 1000u) * 1000000L};
    nanosleep(&t, nullptr);
}

void log_line(void *, const char *line)
{
    if (g.log) { fputs(line, g.log); fputc('\n', g.log); }
}

// Background diagnostics observe only this process; no system input is posted.
void frontend_message(const char *message)
{
    fprintf(stderr, "%s\n", message);
    if (g.log) { fprintf(g.log, "%s\n", message); fflush(g.log); }
}

bool parse_stop_after_ms(const char *text, uint32_t *result)
{
    if (!text || !*text) return false;
    uint32_t value = 0;
    for (const char *p = text; *p; ++p) {
        if (*p < '0' || *p > '9') return false;
        uint32_t digit = (uint32_t)(*p - '0');
        if (value > kMaxStopAfterMs / 10u ||
            (value == kMaxStopAfterMs / 10u && digit > kMaxStopAfterMs % 10u)) return false;
        value = value * 10u + digit;
    }
    if (!value) return false;
    *result = value;
    return true;
}

void start_background_observation()
{
    if (!g.background) return;
    const pid_t process = getpid();
    g.activation_observer = [[[NSWorkspace sharedWorkspace] notificationCenter]
        addObserverForName:NSWorkspaceDidActivateApplicationNotification
        object:nil queue:nil usingBlock:^(NSNotification *notification) {
            NSRunningApplication *application = notification.userInfo[NSWorkspaceApplicationKey];
            if (application.processIdentifier == process) {
                // Delivery may be on another thread; do not touch FILE handles.
                g.background_activations.fetch_add(1, std::memory_order_relaxed);
                g.background_failed.store(true, std::memory_order_release);
            }
        }];
}

void stop_background_observation()
{
    if (!g.activation_observer) return;
    [[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:g.activation_observer];
    g.activation_observer = nil;
}

void record_background_status(const char *stage)
{
    if (!g.background) return;
    bool active = NSApp.isActive, key = NSApp.keyWindow != nil, visible = false;
    for (NSWindow *window in NSApp.windows) {
        key = key || window.isKeyWindow;
        visible = visible || window.isVisible;
    }
    unsigned activations = g.background_activations.load(std::memory_order_acquire);
    if (active || key || visible || activations)
        g.background_failed.store(true, std::memory_order_release);
    char line[256];
    snprintf(line, sizeof line,
             "BACKGROUND stage=%s active=%d key=%d visible=%d activations=%u",
             stage, (int)active, (int)key, (int)visible, activations);
    frontend_message(line);
}

// ---- Bink movies through the app's FFmpeg adapters --------------------------------------------------------------------------------
struct Movie {
    BinkPlayer *player = nullptr;
    BinkPlayerInfo info{};
    BinkAudio audio = BINK_AUDIO_INIT;
    bool audio_tried = false;
    char path[1536];
};

int bink_open_cb(void *, const char *path, RcBinkInfo *info, void **movie)
{
    Movie *m = new Movie();
    char error[256] = {};
    if (bink_player_open(path, &m->player, &m->info, error, sizeof error) != BINK_PLAYER_OK) {
        if (g.log) fprintf(g.log, "bink_player_open(%s): %s\n", path, error);
        delete m;
        return -1;
    }
    snprintf(m->path, sizeof m->path, "%s", path);
    info->width = m->info.width; info->height = m->info.height; info->frames = m->info.total_frames;
    info->rate = (uint32_t)m->info.frame_rate_num; info->rate_div = (uint32_t)(m->info.frame_rate_den > 0 ? m->info.frame_rate_den : 1);
    *movie = m;
    return 0;
}

int bink_frame_cb(void *, void *movie, uint32_t frame, uint16_t *rgb565, uint32_t pitch)
{
    Movie *m = static_cast<Movie *>(movie);
    char error[256] = {};
    if (frame < 1 || frame > m->info.total_frames) frame = 1;
    if (bink_player_seek(m->player, frame, 0, error, sizeof error) != BINK_PLAYER_OK) return -1;
    BinkPlayerFrame out;
    if (bink_player_advance(m->player, UINT64_MAX / 2, &out, error, sizeof error) != BINK_PLAYER_OK) return -1;
    for (uint32_t y = 0; y < out.height && y < m->info.height; y++) {
        const uint8_t *src = out.rgba + (size_t)y * out.stride;
        uint16_t *dst = rgb565 + (size_t)y * pitch;
        for (uint32_t x = 0; x < out.width && x < m->info.width; x++, src += 4)
            dst[x] = (uint16_t)(((src[0] >> 3) << 11) | ((src[1] >> 2) << 5) | (src[2] >> 3));
    }
    return 0;
}

int bink_audio_cb(void *, void *movie, const float **pcm, uint64_t *frames, uint32_t *channels, uint32_t *rate)
{
    Movie *m = static_cast<Movie *>(movie);
    if (!m->audio_tried) {
        m->audio_tried = true;
        char error[256] = {};
        if (bink_audio_decode_file(m->path, &m->audio, error, sizeof error) != BINK_AUDIO_OK && g.log) fprintf(g.log, "bink audio: %s\n", error);
    }
    if (!m->audio.pcm) return -1;
    *pcm = m->audio.pcm; *frames = m->audio.frame_count; *channels = m->audio.channels; *rate = m->audio.sample_rate;
    return 0;
}

void bink_close_cb(void *, void *movie)
{
    Movie *m = static_cast<Movie *>(movie);
    bink_player_close(m->player);
    bink_audio_destroy(&m->audio);
    delete m;
}

// ---- the game thread -----------------------------------------------------------------------------------------------------------------
void *game_main(void *)
{
    char why[600] = {};
    int rc = rc_main(why, sizeof why);
    if (g.log) { fprintf(g.log, "game stopped (%d): %s\n", rc, why); fflush(g.log); }
    g.game_done.store(true, std::memory_order_release);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (g.platform) blackmoor_macos_stop(g.platform);
    });
    return nullptr;
}

// ---- platform callbacks (main thread) --------------------------------------------------------------------------------------------------
void present_primary()
{
    const uint16_t *px;
    uint32_t w, h, pitch;
    uint64_t serial = rc_primary_serial();
    if (serial == g.last_serial || !rc_get_primary(&px, &w, &h, &pitch)) return;
    g.last_serial = serial;
    if (w != kLogicalWidth || h != kLogicalHeight) return;     // the game's display mode is 640x480; anything else is not shown
    if (g.rgba.size() != (size_t)w * h * 4) g.rgba.assign((size_t)w * h * 4, 0xff);
    for (uint32_t y = 0; y < h; y++) {
        const uint16_t *src = (const uint16_t *)((const uint8_t *)px + (size_t)y * pitch);
        uint8_t *dst = g.rgba.data() + (size_t)y * w * 4;
        for (uint32_t x = 0; x < w; x++, dst += 4) {
            uint16_t v = src[x];
            uint8_t r = (uint8_t)((v >> 11) & 31), gr = (uint8_t)((v >> 5) & 63), b = (uint8_t)(v & 31);
            dst[0] = (uint8_t)((r << 3) | (r >> 2)); dst[1] = (uint8_t)((gr << 2) | (gr >> 4)); dst[2] = (uint8_t)((b << 3) | (b >> 2)); dst[3] = 0xff;
        }
    }
    blackmoor_macos_present(g.platform, g.rgba.data(), g.rgba.size(), (size_t)w * 4);
}

void on_tick(void *, uint32_t)
{
    if (g.capture_failed.load(std::memory_order_acquire) && !g.capture_reported) {
        g.capture_reported = true;
        const char *message = "audio capture stopped accepting samples; details at shutdown\n";
        fputs(message, stderr);
        if (g.log) fputs(message, g.log);
    }
    present_primary();
    if (g.stop_deadline_ms && !g.terminate_requested && now_ms(nullptr) >= g.stop_deadline_ms) {
        g.terminate_requested = true;
        frontend_message("STOP_AFTER action=NSApp.terminate requested_once=1");
        // Exercise the same delegate and cleanup path as the actual Cmd-Q menu.
        [NSApp terminate:nil];
    }
}

int32_t clamp_coordinate(int32_t v, int32_t limit) { return v < 0 ? 0 : (v >= limit ? limit - 1 : v); }

void on_pointer(void *, BlackmoorPointerKind kind, int32_t x, int32_t y, unsigned button)
{
    if (button != 0) return;
    g.pointer_x = clamp_coordinate(x, (int32_t)kLogicalWidth);
    g.pointer_y = clamp_coordinate(y, (int32_t)kLogicalHeight);
    if (kind == BLACKMOOR_POINTER_DOWN) g.left_down = 1;
    if (kind == BLACKMOOR_POINTER_UP) g.left_down = 0;
    rc_input_mouse(g.pointer_x, g.pointer_y, g.left_down);
}

void on_key(void *, unsigned virtual_key, int down, int repeat)
{
    if (repeat) return;
    rc_input_key(virtual_key, down);
}

void on_closed(void *)
{
    rc_request_stop();
}

// ---- sound: the DirectSound mix pulled by an AVAudioSourceNode ------------------------------------------------------------------------
// Tap the actual PCM16 mix before float conversion or muted playback suppression.
// The capture queue copies samples here; only its writer thread touches the file.
void render_audio(int16_t *stereo, uint32_t frames, const std::atomic<bool> *source_enabled = nullptr)
{
    // Keep the gate and in-flight counter in one atomic ordering: a callback that
    // arrives after shutdown observes the gate; an earlier one is waited for.
    g.audio_callbacks.fetch_add(1);
    if (g.audio_stopping.load() || (source_enabled && !source_enabled->load())) memset(stereo, 0, (size_t)frames * 4);
    else {
        rc_audio_render(stereo, frames, kAudioRate);
        if (g.capture_enabled && !g.capture.append(stereo, frames))
            g.capture_failed.store(true, std::memory_order_release);
    }
    g.audio_callbacks.fetch_sub(1);
}

void await_audio_callbacks()
{
    while (g.audio_callbacks.load()) sleep_ms(nullptr, 1);
}

// Muted, or no audio engine: the mixer still drives DirectSound positions and
// notifications. Capture its samples and discard playback without opening a device.
void start_silent_clock()
{
    g.silent_thread = std::thread([] {
        std::vector<int16_t> scratch(2 * (size_t)(kAudioRate / 100));
        while (!g.audio_stopping.load(std::memory_order_acquire)) {
            render_audio(scratch.data(), (uint32_t)(kAudioRate / 100));
            // Preserve the prior cadence instead of bursting after a stall.
            std::this_thread::sleep_for(std::chrono::milliseconds(10));
        }
    });
}

void start_audio()
{
    if (g.muted) { start_silent_clock(); return; }
    g.engine = [[AVAudioEngine alloc] init];
    AVAudioFormat *format = [[AVAudioFormat alloc] initStandardFormatWithSampleRate:kAudioRate channels:2];
    auto source_enabled = std::make_shared<std::atomic<bool>>(true);
    AVAudioSourceNode *source = [[AVAudioSourceNode alloc] initWithFormat:format
        renderBlock:^OSStatus(BOOL *isSilence, const AudioTimeStamp *timestamp, AVAudioFrameCount frameCount, AudioBufferList *audioBufferList) {
            (void)timestamp;
            static thread_local std::vector<int16_t> scratch;
            if (scratch.size() < (size_t)frameCount * 2) scratch.resize((size_t)frameCount * 2);
            render_audio(scratch.data(), frameCount, source_enabled.get());
            *isSilence = NO;
            float *left = (float *)audioBufferList->mBuffers[0].mData;
            float *right = audioBufferList->mNumberBuffers > 1 ? (float *)audioBufferList->mBuffers[1].mData : left;
            for (AVAudioFrameCount i = 0; i < frameCount; i++) {
                left[i] = (float)scratch[2 * i] / 32768.0f;
                right[i] = (float)scratch[2 * i + 1] / 32768.0f;
            }
            return noErr;
        }];
    [g.engine attachNode:source];
    NSError *error = nil;
    if (![g.engine connect:source to:g.engine.mainMixerNode format:format error:&error] || ![g.engine startAndReturnError:&error]) {
        if (g.log) fprintf(g.log, "audio engine: %s\n", error.localizedDescription.UTF8String);
        source_enabled->store(false);
        [g.engine stop];
        await_audio_callbacks();
        g.engine = nil;
        start_silent_clock();
    }
}

bool stop_audio()
{
    g.audio_stopping.store(true);
    if (g.engine) [g.engine stop];
    if (g.silent_thread.joinable()) g.silent_thread.join();
    // A callback already rendering must leave the capture queue before finalization.
    // Later callbacks see audio_stopping and produce silence without touching it.
    await_audio_callbacks();
    std::string error;
    if (!g.capture.finish(error)) {
        fprintf(stderr, "audio capture: %s\n", error.c_str());
        if (g.log) fprintf(g.log, "audio capture: %s\n", error.c_str());
        return false;
    }
    return true;
}

bool file_exists(const std::string &path)
{
    struct stat st;
    return stat(path.c_str(), &st) == 0;
}

// Called only after successful game-thread join. rc_main has also joined all
// guest workers, and stop_audio has joined the mixer/capture producers.
bool write_primary_snapshot(const std::string &path)
{
    const uint16_t *pixels = nullptr;
    uint32_t width = 0, height = 0, pitch = 0;
    if (!rc_get_primary(&pixels, &width, &height, &pitch) || !pixels ||
        width != kLogicalWidth || height != kLogicalHeight ||
        pitch < kLogicalWidth * 2u || pitch % 2u ||
        pitch > 268435456u / kLogicalHeight) {
        frontend_message("SNAPSHOT kind=logical-framebuffer failed=unavailable-or-invalid-primary");
        return false;
    }
    FILE *file = fopen(path.c_str(), "wb");
    if (!file) {
        const int open_error = errno;
        fprintf(stderr, "SNAPSHOT kind=logical-framebuffer open failed: %s\n", strerror(open_error));
        if (g.log) fprintf(g.log, "SNAPSHOT kind=logical-framebuffer open failed: %s\n", strerror(open_error));
        return false;
    }
    int io_error = 0;
    auto save_io_error = [&] { if (!io_error) io_error = errno ? errno : EIO; };
    if (fprintf(file, "P6\n%u %u\n255\n", width, height) < 0) save_io_error();
    uint8_t row[kLogicalWidth * 3u];
    for (uint32_t y = 0; y < height && !io_error; ++y) {
        const uint8_t *source = (const uint8_t *)pixels + (size_t)y * pitch;
        for (uint32_t x = 0; x < width; ++x) {
            uint16_t value;
            memcpy(&value, source + (size_t)x * 2u, sizeof value);
            uint8_t red = (uint8_t)((value >> 11) & 31u);
            uint8_t green = (uint8_t)((value >> 5) & 63u);
            uint8_t blue = (uint8_t)(value & 31u);
            row[x * 3u] = (uint8_t)((red << 3) | (red >> 2));
            row[x * 3u + 1u] = (uint8_t)((green << 2) | (green >> 4));
            row[x * 3u + 2u] = (uint8_t)((blue << 3) | (blue >> 2));
        }
        if (fwrite(row, 1, sizeof row, file) != sizeof row) save_io_error();
    }
    if (fflush(file) != 0) save_io_error();
    if (fclose(file) != 0) save_io_error();
    if (io_error) {
        fprintf(stderr, "SNAPSHOT kind=logical-framebuffer write failed: %s\n", strerror(io_error));
        if (g.log) fprintf(g.log, "SNAPSHOT kind=logical-framebuffer write failed: %s\n", strerror(io_error));
        return false;
    }
    fprintf(stderr, "SNAPSHOT kind=logical-framebuffer width=%u height=%u path=%s\n", width, height, path.c_str());
    if (g.log) fprintf(g.log, "SNAPSHOT kind=logical-framebuffer width=%u height=%u path=%s\n", width, height, path.c_str());
    return true;
}

void make_directories(const std::string &path)
{
    for (size_t i = 1; i < path.size(); i++)
        if (path[i] == '/') mkdir(path.substr(0, i).c_str(), 0755);
    mkdir(path.c_str(), 0755);
}

}  // namespace

@interface BlackmoorRecompApplicationDelegate : NSObject <NSApplicationDelegate>
@end

@implementation BlackmoorRecompApplicationDelegate
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    (void)sender;
    if (!g.platform) return NSTerminateNow;
    rc_request_stop();
    // Return from AppKit's termination event before stopping its main loop.
    // Main then joins producers and finalizes capture instead of exit() running
    // global destructors while a mixer thread is still joinable.
    BlackmoorMacPlatform *platform = g.platform;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (g.platform == platform) blackmoor_macos_stop(platform);
    });
    return NSTerminateCancel;
}
@end

// NSApplication's delegate is not retained. Keep it alive through the run loop.
static BlackmoorRecompApplicationDelegate *application_delegate;

int main(int argc, char **argv)
{
    @autoreleasepool {
        g.game_dir = getenv("BLACKMOOR_GAME_DIR") ? getenv("BLACKMOOR_GAME_DIR")
            : "/Applications/Nancy Drew - Curse of Blackmoor Manor.app/Contents/Resources/game/"
              "Nancy Drew Curse of the Blackmoor Manor.app/Contents/Resources/drive_c/GOG Games/Nancy Drew - Curse of Blackmoor Manor";
        std::string log_path, capture_path;
        bool capture_requested = false;
        for (int i = 1; i < argc; i++) {
            std::string a = argv[i];
            if (a == "--game-dir" && i + 1 < argc) g.game_dir = argv[++i];
            else if (a == "--exe" && i + 1 < argc) g.exe = argv[++i];
            else if (a == "--save-dir" && i + 1 < argc) g.save_dir = argv[++i];
            else if (a == "--log" && i + 1 < argc) log_path = argv[++i];
            else if (a == "--capture-audio" && i + 1 < argc) { capture_path = argv[++i]; capture_requested = true; }
            else if (a == "--mute") g.muted = true;
            else if (a == "--background") g.background = true;
            else if (a == "--stop-after-ms" && i + 1 < argc) {
                if (!parse_stop_after_ms(argv[++i], &g.stop_after_ms)) {
                    fprintf(stderr, "--stop-after-ms requires decimal milliseconds in 1..%u\n", kMaxStopAfterMs);
                    return 2;
                }
            }
            else if (a == "--snapshot" && i + 1 < argc) {
                g.snapshot_path = argv[++i];
                if (g.snapshot_path.empty()) { fputs("--snapshot requires a nonempty path\n", stderr); return 2; }
            }
            else { fprintf(stderr, "usage: %s [--game-dir DIR] [--exe GAME.EXE] [--save-dir DIR] [--mute] [--capture-audio FILE.wav] [--log FILE] [--background] [--stop-after-ms N] [--snapshot FILE.ppm]\n", argv[0]); return 2; }
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"BlackmoorAudioMuted"]) g.muted = true;
        if (g.background && !g.muted) { fputs("--background requires effective --mute\n", stderr); return 2; }
        if (g.background && !g.stop_after_ms) g.stop_after_ms = kDefaultBackgroundStopMs;
        if (g.exe.empty()) g.exe = getenv("GAME_EXE") ? getenv("GAME_EXE") : g.game_dir + "/GAME.EXE";
        if (g.save_dir.empty()) {
            NSArray *support = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
            g.save_dir = std::string(((NSString *)support.firstObject).fileSystemRepresentation) + "/Blackmoor Recompiled";
        }
        make_directories(g.save_dir);
        if (!file_exists(g.exe)) { fprintf(stderr, "GAME.EXE not found at %s (use --exe)\n", g.exe.c_str()); return 2; }
        if (!log_path.empty()) g.log = fopen(log_path.c_str(), "w");

        RcPlatform plat;
        memset(&plat, 0, sizeof plat);
        plat.game_dir = g.game_dir.c_str();
        plat.save_dir = g.save_dir.c_str();
        plat.now_ms = now_ms;
        plat.sleep_ms = sleep_ms;
        plat.bink_open = bink_open_cb; plat.bink_frame = bink_frame_cb; plat.bink_close = bink_close_cb; plat.bink_audio = bink_audio_cb;
        plat.log = g.log ? log_line : nullptr;
        rc_set_platform(&plat);

        char error[512] = {};
        if (rc_start(g.exe.c_str(), error, sizeof error) != 0) { fprintf(stderr, "cannot start the game: %s\n", error); return 3; }

        BlackmoorPlatformCallbacks callbacks{};
        callbacks.tick = on_tick; callbacks.pointer = on_pointer; callbacks.key = on_key; callbacks.closed = on_closed;
        start_background_observation();
        [NSApplication sharedApplication];
        application_delegate = [[BlackmoorRecompApplicationDelegate alloc] init];
        NSApp.delegate = application_delegate;
        auto open_window = g.background ? blackmoor_macos_open_background : blackmoor_macos_open;
        g.platform = open_window("Nancy Drew: Curse of Blackmoor Manor", kLogicalWidth, kLogicalHeight, &callbacks, nullptr, error, sizeof error);
        if (!g.platform) {
            fprintf(stderr, "cannot open the window: %s\n", error);
            stop_background_observation();
            if (g.log) fclose(g.log);
            return g.background_failed.load(std::memory_order_acquire) ? 6 : 3;
        }
        record_background_status("opened");
        if (g.background_failed.load(std::memory_order_acquire)) {
            blackmoor_macos_close(g.platform);
            g.platform = nullptr;
            stop_background_observation();
            if (g.log) fclose(g.log);
            return 6;
        }
        if (g.stop_after_ms) g.stop_deadline_ms = now_ms(nullptr) + g.stop_after_ms;

        if (capture_requested) {
            std::string capture_error;
            if (!g.capture.start(capture_path.c_str(), kAudioRate, capture_error)) {
                fprintf(stderr, "cannot start audio capture: %s\n", capture_error.c_str());
                blackmoor_macos_close(g.platform);
                g.platform = nullptr;
                stop_background_observation();
                if (g.log) fclose(g.log);
                return g.background_failed.load(std::memory_order_acquire) ? 6 : 3;
            }
            g.capture_enabled = true;
        }
        try { start_audio(); }
        catch (const std::exception &e) {
            fprintf(stderr, "cannot start audio: %s\n", e.what());
            stop_audio();
            blackmoor_macos_close(g.platform);
            g.platform = nullptr;
            stop_background_observation();
            if (g.log) fclose(g.log);
            return g.background_failed.load(std::memory_order_acquire) ? 6 : 3;
        }

        // the guest has a deep call stack of large lifted frames: a 512 MiB stack (reserved, not committed)
        pthread_attr_t attr;
        pthread_attr_init(&attr);
        pthread_attr_setstacksize(&attr, (size_t)512 << 20);
        int thread_error = pthread_create(&g.game_thread, &attr, game_main, nullptr);
        pthread_attr_destroy(&attr);
        if (thread_error != 0) {
            fprintf(stderr, "cannot start the game thread\n");
            stop_audio();
            blackmoor_macos_close(g.platform);
            g.platform = nullptr;
            stop_background_observation();
            if (g.log) fclose(g.log);
            return g.background_failed.load(std::memory_order_acquire) ? 6 : 3;
        }
        g.game_thread_started = true;

        blackmoor_macos_run(g.platform);
        record_background_status("stop");

        // Keep shutdown bounded even if a producer is blocked on a host lock
        // or filesystem I/O. A timeout is an explicit failure, never success.
        auto shutdown_finished = std::make_shared<std::atomic<bool>>(false);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC),
                       dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
            if (!shutdown_finished->load(std::memory_order_acquire)) _exit(5);
        });
        rc_request_stop();
        for (int waited = 0; g.game_thread_started && !g.game_done.load(std::memory_order_acquire) && waited < 300; waited++) sleep_ms(nullptr, 10);
        bool capture_ok = stop_audio();
        if (g.game_thread_started && !g.game_done.load(std::memory_order_acquire)) {
            // The game is inside a long loop that does not poll for the stop request.
            // Capture finalization was attempted; this is not a clean game exit.
            if (g.log) fflush(g.log);
            _exit(5);
        }
        const int join_error = g.game_thread_started ? pthread_join(g.game_thread, nullptr) : 0;
        bool diagnostics_ok = true;
        if (join_error && (g.background || !g.snapshot_path.empty())) {
            frontend_message("diagnostic cleanup: game-thread join failed");
            diagnostics_ok = false;
        }
        // Snapshot reads begin only after the game and all workers are joined.
        if (!g.snapshot_path.empty() && diagnostics_ok)
            diagnostics_ok = write_primary_snapshot(g.snapshot_path);
        blackmoor_macos_close(g.platform);
        g.platform = nullptr;
        stop_background_observation();
        if (g.background_failed.load(std::memory_order_acquire)) {
            frontend_message("BACKGROUND result=failed quiet-mode-contract");
            diagnostics_ok = false;
        }
        if (g.log) fclose(g.log);
        shutdown_finished->store(true, std::memory_order_release);
        if (!diagnostics_ok) return 6;
        if (!capture_ok) return 4;
    }
    return 0;
}
