/* Real app callbacks + recovered kernel, synthetic pixels/codec/host boundary.
 * No window, assets, audio device, or original codec claims. */
#define main blackmoor_app_entry_for_test
#ifndef RT9_APP_SOURCE
#define RT9_APP_SOURCE "../src/blackmoor_app.mm"
#endif
#include RT9_APP_SOURCE
#undef main
#include <cassert>
#include <fstream>
#include <sys/stat.h>

static bool bus_active;
static int host_open(MacAudioMode mode, uint32_t, uint32_t, MacAudioHost **h, char *, size_t)
{ assert(mode == MAC_AUDIO_MODE_OFFLINE); *h = reinterpret_cast<MacAudioHost *>(1); return 0; }
static int host_close(MacAudioHost *, char *, size_t) { return 0; }
static int host_play(MacAudioHost *, uint32_t slot, const float *, uint64_t, uint32_t,
                     uint32_t, float, int, char *, size_t)
{ assert(slot == 64); bus_active = true; return 0; }
static int host_stop(MacAudioHost *, uint32_t slot, char *, size_t)
{ assert(slot == 64); bus_active = false; return 0; }
static int host_gain(MacAudioHost *, uint32_t, float, char *, size_t) { return 0; }
static int host_playing(MacAudioHost *, uint32_t, int *p, char *, size_t)
{ *p = bus_active; return 0; }
static int host_render(MacAudioHost *, uint32_t, MacAudioRender *, char *, size_t) { return 1; }
static void host_render_free(MacAudioRender *) {}
static int kernel_open(void *, const ActionFamily35Decoded *, AvfStream **) { return 0; }
static void kernel_close(void *) {}
static int kernel_due(void *, int *due) { *due = 1; return 0; }
static int kernel_decode(void *, int16_t *frame) { *frame = 0; return 0; }
static int kernel_next(void *, int *more) { *more = 0; return 0; }
static int kernel_rect(void *, const A35Rect *, const A35Rect *) { return 0; }

int main(int argc, char **argv)
{
    @autoreleasepool {
        assert(argc == 3);
        NativeApp app;
        app.log = tmpfile(); assert(app.log);
        A35World seed{}, loaded{};
        seed.layers[0] = 11; seed.layers[1] = 12; seed.layers[2] = 13;
        seed.visible = 1; seed.modal = 7;
        native_a35_store_world(&app, &seed);
        native_a35_load_world(&app, &loaded);
        assert(loaded.layers[0] == 11 && loaded.layers[1] == 12 && loaded.layers[2] == 13);
        assert(loaded.visible == 1);
        std::ifstream input(argv[1], std::ios::binary);
        std::vector<uint8_t> body((std::istreambuf_iterator<char>(input)), {});
        A35Host host{}; host.open = kernel_open; host.close = kernel_close;
        host.bink_due = kernel_due; host.bink_decode = kernel_decode;
        host.bink_next = kernel_next; host.rect = kernel_rect;
        A35Runtime *runtime = action35_runtime_create(&loaded, &host); assert(runtime);
        A35Input in{0, 10, 20}; A35Result out{};
        assert(!action35_runtime_step(runtime, body.data(), body.size(), 0, &in, &out));
        native_a35_store_world(&app, &loaded);
        loaded = {}; native_a35_load_world(&app, &loaded);
        assert(loaded.layers[0] == 0 && loaded.layers[1] == 0 && loaded.layers[2] == 0);
        assert(!action35_runtime_step(runtime, body.data(), body.size(), 1, &in, &out));
        assert(loaded.visible == 1 && out.phase == 2);
        native_a35_store_world(&app, &loaded);

        /* Asymmetric crop, padded source stride, nonzero destination offset.
         * Compare the entire destination, including untouched sentinel bytes. */
        std::vector<uint8_t> rgba(60, 0);
        const uint8_t colors[16] = {248,0,0,255, 0,248,0,255, 0,0,248,255, 248,248,248,255};
        std::memcpy(rgba.data() + 24, colors, 8);
        std::memcpy(rgba.data() + 44, colors + 8, 8);
        BinkPlayerFrame frame{}; frame.rgba = rgba.data(); frame.rgba_bytes = rgba.size();
        frame.width = 4; frame.height = 3; frame.stride = 20;
        A35Rect src{1,1,2,2}, dst{10,20,11,21};
        app.captions.compositor_format = CAPTION_COMPOSITOR_RGB555_LE;
        for (int c = 0; c < 3; ++c) {
            app.captions.pixel_format.channel_bits[c] = 5;
            app.captions.pixel_format.masks[c] = 31;
            app.captions.pixel_format.shifts[c] = static_cast<uint8_t>(c * 5);
        }
        app.captions.backbuffer_pixels.assign(640 * 480 * 2, 0xaa);
        assert(!native_a35_present(&app, &frame, &src, &dst));
        app.movie_composed = app.movie_generation; // no real codec stats in this fixture
        assert(native_a35_compose(&app));
        std::vector<uint8_t> expected(640 * 480 * 2, 0xaa);
        const uint8_t top[4] = {0,0x7c,0xe0,3}, bottom[4] = {0x1f,0,0xff,0x7f};
        std::memcpy(expected.data() + (20 * 640 + 10) * 2, top, 4);
        std::memcpy(expected.data() + (21 * 640 + 10) * 2, bottom, 4);
        assert(app.captions.backbuffer_pixels == expected);

        /* Unmatched selector AFTER presentation must hide the retained frame. */
        loaded = {}; native_a35_load_world(&app, &loaded);
        in.selector = 99;
        assert(!action35_runtime_step(runtime, body.data(), body.size(), 1, &in, &out));
        native_a35_store_world(&app, &loaded);
        loaded = {}; native_a35_load_world(&app, &loaded);
        assert(loaded.visible == 0);
        app.captions.backbuffer_pixels.assign(expected.size(), 0xaa);
        assert(native_a35_compose(&app));
        assert(app.captions.backbuffer_pixels == std::vector<uint8_t>(expected.size(), 0xaa));
        assert(!action35_runtime_step(runtime, body.data(), body.size(), 2, &in, &out));
        native_a35_store_world(&app, &loaded);
        loaded = {}; native_a35_load_world(&app, &loaded);
        // 0x4c0774 restores modal, never the layer words cleared in phase 1.
        assert(loaded.modal == 7 && loaded.layers[0] == 0 && loaded.layers[1] == 0 && loaded.layers[2] == 0);
        action35_runtime_destroy(runtime);
        native_a35_close(&app);
        assert(app.movie_frame.rgba == nullptr && app.movie_surface.empty());
        seed.visible = 1; native_a35_store_world(&app, &seed);
        assert(native_a35_compose(&app));
        assert(app.captions.backbuffer_pixels == std::vector<uint8_t>(expected.size(), 0xaa));

        LiveAudioHostOps ops{host_open,host_close,host_play,host_stop,host_gain,
                             host_playing,host_render,host_render_free};
        LiveAudioConfig config{}; config.mode = MAC_AUDIO_MODE_OFFLINE;
        config.game_directory = argv[2]; config.host_ops = &ops;
        char error[256] = {}; float pcm[4] = {0.25f,0.25f,0.25f,0.25f};
        assert(!live_audio_create(&config, &app.live_audio, error, sizeof(error)));
        BinkAudio audio{}; audio.pcm = pcm; audio.frame_count = 4;
        audio.channels = 1; audio.sample_rate = 44100;
        assert(!native_a35_audio_start(&app, &audio) && bus_active);
        native_a35_audio_stop(&app);
        assert(!bus_active && !app.failure);
        assert(!live_audio_destroy(app.live_audio)); app.live_audio = nullptr;
        app.game_directory = argv[2];
        const std::string video_dir = app.game_directory + "/CDVideo";
        assert(mkdir(video_dir.c_str(), 0700) == 0 || errno == EEXIST);
        ActionFamily35Decoded missing{}; missing.words[0] = 1;
        std::memcpy(missing.name, "missing", 8);
        AvfStream *stream = nullptr;
        assert(native_a35_open(&app, &missing, &stream) == A35_RUNTIME_UNSUPPORTED);
        std::rewind(app.log);
        std::string log; char line[1024];
        while (std::fgets(line, sizeof(line), app.log)) log += line;
        assert(log.find("scene_a35_open branch=Bink name=missing status=2 detail=missing-file") != std::string::npos);
        std::fclose(app.log); app.log = nullptr;
        puts("RT-9 app glue: world round-trip, kernel layer clearing/visibility, pitched crop/offset, stale close, mixer stop passed");
    }
    return 0;
}
