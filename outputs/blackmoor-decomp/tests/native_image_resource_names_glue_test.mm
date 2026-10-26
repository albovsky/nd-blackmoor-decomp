/* NATIVE19: actual native image callback with owner-local artwork.
 * Direct component setup only; no window, audio device or campaign claim. */
#define main blackmoor_app_entry_for_image_names_test
#ifndef NATIVE_IMAGE_APP_SOURCE
#define NATIVE_IMAGE_APP_SOURCE "../src/blackmoor_app.mm"
#endif
#include NATIVE_IMAGE_APP_SOURCE
#undef main
#include <csignal>

#define CHECK(condition, message) do { if (!(condition)) { \
    std::fprintf(stderr, "CHECK failed: %s\n", message); return 1; } } while (0)

struct ImageNameFixture {
    NativeApp app{};
    GameResources *reference_resources = nullptr;
    cif_image reference = CIF_IMAGE_INIT;
    ~ImageNameFixture()
    {
        cif_image_destroy(&reference);
        game_resources_close(reference_resources);
        game_resources_close(app.resources);
        if (app.log != nullptr) std::fclose(app.log);
    }
    bool initialize(const char *directory)
    {
        app.game_directory = directory;
        app.log = std::tmpfile();
        if (app.log == nullptr) return false;
        int external = 0;
        if (!game_ini_configuration(app.game_directory, &external, &app.closed_captioning)) return false;
        char error[256]{};
        const std::string resources = app.game_directory + "/Ciftree";
        app.resources = game_resources_open(resources.c_str(), external, error, sizeof error);
        reference_resources = game_resources_open(resources.c_str(), external, error, sizeof error);
        if (app.resources == nullptr || reference_resources == nullptr) return false;
        /* Explicit identity RGB555 destination. Expected pixels below are
         * derived from direct source words, without the native conversion. */
        for (size_t channel = 0; channel < 3u; ++channel) {
            app.captions.pixel_format.channel_bits[channel] = 5;
            app.captions.pixel_format.shifts[channel] = static_cast<uint8_t>(channel * 5u);
        }
        return true;
    }
};

static int long_resource_name(ImageNameFixture &fixture)
{
    char name[] = "BLU_FoodTrayButterOne_OVL";
    const char missing_prefix[] = "BLU_FoodTrayButterOne_OV";
    GameResourceSource source = GAME_RESOURCE_ARCHIVE;
    char error[256]{};
    CHECK(game_resources_load_image(fixture.reference_resources, name, &fixture.reference,
                                    &source, error, sizeof error),
          "independent full-stem GameResources load finds actual butter artwork");
    const cif_image &expected = fixture.reference;
    CHECK(expected.depth == 16u && expected.width > 0u && expected.height > 0u &&
          expected.pixels != nullptr && expected.byte_count > 0u && (expected.byte_count & 1u) == 0u,
          "direct owner-local artwork provides complete RGB555 source pixels");
    const uint32_t handle = native_caption_load_image(&fixture.app, name, "image-name-regression");
    std::printf("IMAGE_NAME stem_bytes=%zu direct_width=%u direct_height=%u direct_pitch=%u handle=%u\n",
                std::strlen(name), expected.width, expected.height, expected.pitch, handle);
    CHECK(handle != 0u, "native image callback must load the full 25-character butter resource name");
    CHECK(std::strcmp(name, "BLU_FoodTrayButterOne_OVL") == 0, "native lookup preserves the caller's full stem");
    const auto found = fixture.app.captions.raw_images.find(handle);
    CHECK(found != fixture.app.captions.raw_images.end(), "returned native handle owns decoded image pixels");
    const NativeRaw555Image &actual = found->second;
    CHECK(actual.width == expected.width && actual.height == expected.height &&
          actual.pitch == expected.pitch && actual.pixels.size() == expected.byte_count,
          "full-name native dimensions and byte span match independent source metadata");
    for (size_t offset = 0; offset < expected.byte_count; offset += 2u) {
        CHECK(actual.pixels[offset] == expected.pixels[offset] &&
              actual.pixels[offset + 1u] == (expected.pixels[offset + 1u] & 0x7fu),
              "native RGB555 pixels match every independent source word");
    }
    const uint8_t *owned_pixels = actual.pixels.data();
    const uint32_t repeated = native_caption_load_image(&fixture.app, name, "repeated-full-name");
    const auto repeated_image = fixture.app.captions.raw_images.find(handle);
    CHECK(repeated == handle && repeated_image != fixture.app.captions.raw_images.end() &&
          fixture.app.captions.raw_images.size() == 1u &&
          repeated_image->second.pixels.data() == owned_pixels,
          "repeated full-name load reuses its handle and owned pixel allocation");
    cif_image missing = CIF_IMAGE_INIT;
    const bool prefix_exists = game_resources_load_image(fixture.reference_resources, missing_prefix,
                                                         &missing, &source, error, sizeof error) != 0;
    cif_image_destroy(&missing);
    CHECK(!prefix_exists, "independent provider confirms the old 24-character prefix is missing");
    CHECK(native_caption_load_image(&fixture.app, missing_prefix, "missing-prefix") == 0u,
          "missing prefix must not alias the loaded full-name image");
    const uint32_t after_miss = native_caption_load_image(&fixture.app, name, "full-name-after-miss");
    const auto after_miss_image = fixture.app.captions.raw_images.find(handle);
    CHECK(after_miss == handle && after_miss_image != fixture.app.captions.raw_images.end() &&
          fixture.app.captions.raw_images.size() == 1u &&
          after_miss_image->second.pixels.data() == owned_pixels,
          "missing prefix leaves the full-name handle and pixel ownership intact");
    std::printf("IMAGE_NAME_CACHE repeated_handle=%u missing_prefix=0 owned_images=1 pixels_match=1\n", handle);
    return 0;
}

static void image_name_fixture_signal(int number)
{
    static const char prefix[] = "image-name fixture/native signal failure number=";
    const char digits[] = {static_cast<char>('0' + number / 10), static_cast<char>('0' + number % 10), '\n'};
    (void)write(STDERR_FILENO, prefix, sizeof(prefix) - 1u);
    (void)write(STDERR_FILENO, digits, sizeof digits);
    _exit(128 + number);
}

int main(int argc, char **argv)
{
    std::signal(SIGBUS, image_name_fixture_signal); std::signal(SIGSEGV, image_name_fixture_signal);
    std::signal(SIGABRT, image_name_fixture_signal); std::signal(SIGILL, image_name_fixture_signal);
    @autoreleasepool {
        CHECK(argc == 2, "owner-local game directory required");
        ImageNameFixture fixture;
        CHECK(fixture.initialize(argv[1]), "owner-local image providers initialize");
        return long_resource_name(fixture);
    }
}
