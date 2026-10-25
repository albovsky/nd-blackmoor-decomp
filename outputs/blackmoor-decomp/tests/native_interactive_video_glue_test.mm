/* NATIVE-04 app regression. Normal mode forwards to the actual app entry with
 * the runner's real headless route. --unknown-owner is a separate ownership
 * component fixture; it never executes an opaque CF row or invents IV state.
 * No window/output device, assert, deliberate fault or original-x86 execution. */
#define main blackmoor_app_entry_for_iv_test
#include "../src/blackmoor_app.mm"
#undef main
#include <csignal>

struct OwnershipFixture {
    NativeApp app;
    std::vector<uint8_t> original;
    SceneResource *plain = nullptr;
    SceneResource *unknown = nullptr;
    ~OwnershipFixture()
    {
        session_a1c_destroy(app.a1c);
        scene_resource_close(unknown);
        scene_resource_close(plain);
        game_resources_close(app.resources);
        if (app.log != nullptr) std::fclose(app.log);
    }

    bool load(const char *game_directory)
    {
        app.game_directory = game_directory;
        app.log = std::tmpfile();
        if (app.log == nullptr) return false;
        int external = 0;
        if (!game_ini_configuration(app.game_directory, &external, &app.closed_captioning)) return false;
        char error[256]{};
        app.resources = game_resources_open((app.game_directory + "/Ciftree").c_str(), external,
                                             error, sizeof(error));
        if (app.resources == nullptr) {
            std::fprintf(stderr, "ownership resource open: %s\n", error);
            return false;
        }
        GameResourceBytes bytes = GAME_RESOURCE_BYTES_INIT;
        if (!game_resources_load_bytes(app.resources, "S2186", &bytes, error, sizeof(error))) {
            std::fprintf(stderr, "ownership S2186 load: %s\n", error);
            return false;
        }
        original.assign(bytes.bytes, bytes.bytes + bytes.length);
        game_resource_bytes_destroy(&bytes);
        plain = scene_resource_open_memory(original.data(), original.size(), error, sizeof(error));
        if (plain == nullptr) return false;

        /* Synthetic ownership metadata only. Original scene bytes are read in
         * place and copied only in memory; no resource payload is published. */
        std::vector<uint8_t> augmented = original;
        if (augmented.size() < 12 || std::memcmp(augmented.data(), "DATA", 4) != 0 ||
            std::memcmp(augmented.data() + 8, "SCEN", 4) != 0) return false;
        const size_t offset = augmented.size();
        augmented.resize(offset + 58u, 0);
        std::memcpy(augmented.data() + offset, "ACT", 3);
        augmented[offset + 7] = 50;
        const char label[] = "NATIVE-04 opaque earlier owner";
        std::memcpy(augmented.data() + offset + 8, label, sizeof(label));
        augmented[offset + 56] = 0xcf;
        augmented[offset + 57] = 1;
        const uint32_t length = static_cast<uint32_t>(augmented.size() - 8u);
        for (unsigned i = 0; i < 4; ++i) augmented[4u + i] = static_cast<uint8_t>(length >> (24u - 8u * i));
        unknown = scene_resource_open_memory(augmented.data(), augmented.size(), error, sizeof(error));
        if (unknown == nullptr) return false;
        C1cHost host{};
        app.a1c = session_a1c_create(&host); /* ownership only; no handler visit */
        if (app.a1c == nullptr) return false;
        app.scene_destination = {10, 10, 629, 384};
        app.pointer_x = 330;
        app.pointer_y = 160;
        return true;
    }

    int project(SceneResource *scene, SceneExecutorFrameInput *frame)
    {
        app.scene = scene;
        std::vector<uint8_t> types;
        size_t iv_rows = 0;
        for (size_t row = 0; row < scene_resource_action_count(scene); ++row) {
            SceneActionInfo action{};
            if (scene_resource_action_at(scene, row, &action) != SCENE_RESOURCE_OK)
                return SESSION_INPUT_INVALID_ARGUMENT;
            types.push_back(action.type);
            if (action.type == SESSION_A1C_TYPE) ++iv_rows;
        }
        if (iv_rows != 1u) return SESSION_INPUT_INVALID_ARGUMENT;
        app.nav_members_idle = session_navigation_members_idle(types.data(), types.size()) != 0;
        if (session_input_init(&app.input_state) != SESSION_INPUT_OK) return SESSION_INPUT_INVALID_ARGUMENT;
        SessionInputContext input{};
        native_pointer_context(&app, &input); /* actual app context, no new helper dependency */
        return session_input_tick(&app.input_state, &input, frame);
    }
};

static int check_ownership(const char *game_directory)
{
    OwnershipFixture fixture;
    if (!fixture.load(game_directory)) {
        std::fprintf(stderr, "ownership fixture initialization failed\n");
        return 2;
    }
    SceneExecutorFrameInput plain{}, unknown{};
    const int plain_status = fixture.project(fixture.plain, &plain);
    const int unknown_status = fixture.project(fixture.unknown, &unknown);
    const int32_t candidate = fixture.app.input_state.candidate;
    std::printf("IV_SCOPE plain_status=%d plain_valid=%u unknown_status=%d unknown_valid=%u candidate=%d\n",
                plain_status, plain.pointer_valid, unknown_status, unknown.pointer_valid, candidate);
    bool passed = true;
    if (plain_status != SESSION_INPUT_OK || plain.pointer_valid != 1u) {
        std::fprintf(stderr, "CHECK failed: one real IV owner must permit guarded projection\n");
        passed = false;
    }
    if (unknown_status != SESSION_INPUT_LIMIT_PRIORITY_PATH || unknown.pointer_valid != 0u || candidate != -1) {
        std::fprintf(stderr, "CHECK failed: an opaque earlier owner must retain explicit priority limit and absent candidate\n");
        passed = false;
    }
    return passed ? 0 : 1;
}

static void fixture_signal(int number)
{
    static const char prefix[] = "IV fixture/native signal failure number=";
    const char digits[] = {static_cast<char>('0' + number / 10), static_cast<char>('0' + number % 10), '\n'};
    (void)write(STDERR_FILENO, prefix, sizeof(prefix) - 1u);
    (void)write(STDERR_FILENO, digits, sizeof(digits));
    _exit(128 + number);
}

int main(int argc, char **argv)
{
    std::signal(SIGBUS, fixture_signal);
    std::signal(SIGSEGV, fixture_signal);
    std::signal(SIGABRT, fixture_signal);
    std::signal(SIGILL, fixture_signal);
    @autoreleasepool {
        if (argc >= 2 && std::strcmp(argv[1], "--unknown-owner") == 0) {
            if (argc != 3) return 2;
            return check_ownership(argv[2]);
        }
        return blackmoor_app_entry_for_iv_test(argc, argv);
    }
}
