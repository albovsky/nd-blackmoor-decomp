/* NATIVE-08: presentation-only actual scene loading. Original resources stay
 * in place. No scene executor, world, output device or input state is created.
 * Pixel pins are regression output of the existing native decoder, not a new
 * original-x86/decoder parity claim. Failures use CHECK/ordinary exit1. */
#define main blackmoor_app_entry_for_avf_background_test
#ifndef NATIVE_AVF_BACKGROUND_APP_SOURCE
#define NATIVE_AVF_BACKGROUND_APP_SOURCE "../src/blackmoor_app.mm"
#endif
#include NATIVE_AVF_BACKGROUND_APP_SOURCE
#undef main
#include <csignal>

#define CHECK_BG(condition, message) do { if (!(condition)) { \
    std::fprintf(stderr, "CHECK failed: %s\n", message); return 1; } } while (0)

static uint64_t background_fnv(const std::vector<uint8_t> &pixels)
{
    uint64_t value = UINT64_C(14695981039346656037);
    for (const uint8_t byte : pixels) value = (value ^ byte) * UINT64_C(1099511628211);
    return value;
}

struct BackgroundFixture {
    NativeApp app;
    ~BackgroundFixture()
    {
        bink_player_close(app.video);
        bink_player_close(app.nav_player);
        scene_resource_close(app.scene);
        scene_resource_close(app.retired_scene);
        game_resources_close(app.resources);
        if (app.log != nullptr) std::fclose(app.log);
    }

    bool initialize(const char *original_game, const char *media_game)
    {
        app.game_directory = original_game;
        app.log = std::tmpfile();
        if (app.log == nullptr) return false;
        int external = 0;
        if (!game_ini_configuration(app.game_directory, &external, &app.closed_captioning)) return false;
        char error[256]{};
        app.resources = game_resources_open((app.game_directory + "/Ciftree").c_str(), external, error, sizeof(error));
        if (app.resources == nullptr) {
            std::fprintf(stderr, "background resources: %s\n", error);
            return false;
        }
        /* Real VIEW geometry; storage is allocated before the actual loader
         * calls render_scene_preview/clear_framebuffer. */
        app.framebuffer.resize(640u * 480u * 4u);
        app.scene_source = {0, 0, 619, 374};
        app.scene_destination = {10, 10, 629, 384};
        app.scene_runtime_enabled = false;
        app.game_directory = media_game;
        return true;
    }

    bool viewport_matches() const
    {
        for (size_t y = 0; y < 480; ++y) for (size_t x = 0; x < 640; ++x) {
            const size_t at = (y * 640 + x) * 4;
            if (x >= 10 && x <= 629 && y >= 10 && y <= 384) {
                const size_t source = ((y - 10) * 620 + x - 10) * 4;
                if (std::memcmp(app.framebuffer.data() + at, app.scene_frame.rgba.data() + source, 4) != 0) return false;
            } else if (app.framebuffer[at] != 0 || app.framebuffer[at + 1] != 0 ||
                       app.framebuffer[at + 2] != 0 || app.framebuffer[at + 3] != 255) return false;
        }
        return true;
    }
};

static int check_background(const char *game, const char *media, const char *mode)
{
    BackgroundFixture fixture;
    const bool reject = std::strncmp(mode, "reject", 6) == 0;
    if (!fixture.initialize(game, reject ? game : media)) return 2;
    NativeApp &app = fixture.app;
    const bool roundtrip = std::strcmp(mode, "roundtrip") == 0;
    std::vector<uint8_t> bink_before;
    if (roundtrip || reject) {
        CHECK_BG(load_scene(&app, 2175) && app.video != nullptr && app.has_scene_frame,
                 "real initial BIK background must load");
        bink_before = app.scene_frame.rgba;
    }
    if (reject) app.game_directory = media;
    const bool loaded = load_scene(&app, 3395);
    const uint64_t pixels = background_fnv(app.scene_frame.rgba);
    std::printf("AVF_BACKGROUND mode=%s loaded=%d has_frame=%d bink=%d size=%ux%u frames=%d current=%d rgba_fnv64=%016llx\n",
        mode, loaded ? 1 : 0, app.has_scene_frame ? 1 : 0, app.video != nullptr ? 1 : 0,
        app.scene_frame.width, app.scene_frame.height, app.scene_native_frames, app.scene_current_frame,
        static_cast<unsigned long long>(pixels));
    if (reject) {
        CHECK_BG(!loaded && !app.has_scene_frame && app.video == nullptr && app.nav_player == nullptr &&
                 app.scene_native_frames == 0 && app.scene_native_width == 0 && app.scene_native_height == 0 &&
                 app.scene_video_path.empty(),
                 "failed load must clear previous BIK visibility, players, geometry and path");
        CHECK_BG(std::fflush(app.log) == 0 && std::fseek(app.log, 0, SEEK_END) == 0,
                 "fixture log must be readable");
        const long length = std::ftell(app.log);
        CHECK_BG(length > 0 && length < 1024 * 1024 && std::fseek(app.log, 0, SEEK_SET) == 0,
                 "fixture log must have bounded content");
        std::string log(static_cast<size_t>(length), '\0');
        CHECK_BG(std::fread(log.data(), 1, log.size(), app.log) == log.size(), "fixture log read");
        CHECK_BG(log.find("scene_media_error") != std::string::npos, "failure must be logged");
        if (std::strncmp(mode, "reject-", 7) == 0) {
            const std::string reason = "branch=AVF-static stage=" + std::string(mode + 7);
            CHECK_BG(log.find(reason) != std::string::npos, "AVF refusal reason must match the requested stage");
        }
        return 0;
    }
    CHECK_BG(loaded && app.has_scene_frame, "real S3395 background must load without a BIK asset");
    CHECK_BG(app.scene_frame.width == 620u && app.scene_frame.height == 375u &&
             app.scene_frame.rgba.size() == 620u * 375u * 4u && app.scene_current_frame == 0 &&
             app.scene_frame.frame_index == 0 && app.scene_native_frames == 1 &&
             app.scene_native_width == 620 && app.scene_native_height == 375,
             "loaded first frame must publish actual dimensions/range/frame0");
    if (std::strcmp(mode, "bik") == 0) {
        CHECK_BG(app.video != nullptr && pixels != UINT64_C(0x96540e5787f9f228),
                 "present valid BIK must win over the AVF fallback");
    } else {
        CHECK_BG(app.video == nullptr && app.nav_player == nullptr,
                 "static AVF must not retain a Bink/AVF decoder worker");
        /* HAL_StairLock_PUZ.avf SHA256 6dfff528...43898fbc6.
         * Existing decoder RGB555 SHA256 8472106c...e8024ed77; manually
         * expanded opaque RGBA SHA256 512b89ac...b95e4096. */
        CHECK_BG(pixels == UINT64_C(0x96540e5787f9f228), "static AVF must publish the pinned actual RGBA pixels");
    }
    CHECK_BG(fixture.viewport_matches(), "real VIEW rectangle must contain exact frame pixels with opaque black margins");
    if (roundtrip || reject) {
        CHECK_BG(load_scene(&app, 2175) && app.video != nullptr && app.has_scene_frame &&
                 app.scene_frame.rgba == bink_before && app.scene_current_frame == 0 &&
                 app.scene_native_frames == 1 && fixture.viewport_matches(),
                 "return to BIK must replace AVF pixels and retain correct first-frame geometry");
        std::printf("AVF_BIK_ROUNDTRIP exact_bik_pixels=1 current=%d\n", app.scene_current_frame);
    }
    return 0;
}

static void background_signal(int number)
{
    static const char prefix[] = "background fixture/native signal failure number=";
    const char digits[] = {static_cast<char>('0' + number / 10), static_cast<char>('0' + number % 10), '\n'};
    (void)write(STDERR_FILENO, prefix, sizeof(prefix) - 1u);
    (void)write(STDERR_FILENO, digits, sizeof(digits));
    _exit(128 + number);
}

int main(int argc, char **argv)
{
    std::signal(SIGBUS, background_signal);
    std::signal(SIGSEGV, background_signal);
    std::signal(SIGABRT, background_signal);
    std::signal(SIGILL, background_signal);
    @autoreleasepool {
        if (argc == 5 && std::strcmp(argv[1], "--background") == 0)
            return check_background(argv[2], argv[3], argv[4]);
        return blackmoor_app_entry_for_avf_background_test(argc, argv);
    }
}
