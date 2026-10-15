/* RT-12 app glue: the real native_a83_refresh / native_a83_handler callbacks
 * from blackmoor_app.mm drive the recovered kernel through a real scene
 * session. No window, assets, audio device or codec is used. argv[1] is a
 * scene file with two raw-0x83 rows (mail key "one", web key "link"). */
#define main blackmoor_app_entry_for_test
#ifndef RT12_APP_SOURCE
#define RT12_APP_SOURCE "../src/blackmoor_app.mm"
#endif
#include RT12_APP_SOURCE
#undef main
#include <cassert>
#include <fstream>
#include <iterator>

static SceneSessionCallbackStatus prepare_ok(void *, SceneConditionState *, SceneExecutorFrameInput *,
                                             SceneSessionFailure *)
{ return SCENE_SESSION_CALLBACK_OK; }
static SceneSessionCallbackStatus media_ok(void *, SceneExecutorFrameInput *, SceneSessionFailure *)
{ return SCENE_SESSION_CALLBACK_OK; }

static std::string log_text(NativeApp &app)
{
    std::fflush(app.log);
    std::rewind(app.log);
    std::string text;
    char line[1024];
    while (std::fgets(line, sizeof(line), app.log)) text += line;
    std::fseek(app.log, 0, SEEK_END);
    return text;
}

static size_t count_of(const std::string &text, const char *needle)
{
    size_t count = 0, at = 0;
    while ((at = text.find(needle, at)) != std::string::npos) { ++count; ++at; }
    return count;
}

int main(int argc, char **argv)
{
    @autoreleasepool {
        assert(argc == 2);
        std::ifstream input(argv[1], std::ios::binary);
        std::vector<uint8_t> bytes((std::istreambuf_iterator<char>(input)), {});
        assert(!bytes.empty());
        NativeApp app;
        app.log = tmpfile();
        assert(app.log);
        app.phone_lists.mail = app.phone_mail;
        app.phone_lists.mail_capacity = 100u;
        app.phone_lists.web = app.phone_web;
        app.phone_lists.web_capacity = 100u;
        /* Start with one mail and one web entry like the BOOT/UICL initializer. */
        std::vector<uint8_t> uicl(A83_UICL_MIN_BYTES, 0);
        std::memcpy(&uicl[0xccb], "init-mail\0", 10);
        std::memcpy(&uicl[0xcec], "init-text\0", 10);
        std::memcpy(&uicl[0xd11], "init-link\0", 10);
        assert(action83_initialize(&app.phone_lists, uicl.data(), uicl.size()) == A83_OK);
        assert(app.phone_lists.mail_count == 1 && app.phone_lists.web_count == 1);
        SessionA83Host host{&app.phone_lists, {&app, native_a83_refresh}};
        app.a83 = session_a83_create(&host);
        assert(app.a83);

        char error[256] = {};
        SceneResource *scene = scene_resource_open_memory(bytes.data(), bytes.size(), error, sizeof(error));
        assert(scene);
        assert(session_a83_begin_scene(app.a83, scene) == A83_OK);
        int32_t flags[3000] = {};
        ActionCoreWorld world{};
        world.event_flags = flags;
        world.event_flag_count = 3000;
        SceneConditionState conditions{};
        conditions.event_flags = flags;
        conditions.event_flag_count = 3000;
        SceneSessionActionBinding binding{};
        binding.type = SESSION_A83_TYPE;
        binding.provider = SCENE_SESSION_PROVIDER_A83;
        binding.callback = native_a83_handler;
        binding.context = &app;
        SceneSessionConfig config{};
        config.scene = scene;
        config.scene_id = 4808;
        config.action_core_world = &world;
        config.conditions = &conditions;
        config.action_bindings = &binding;
        config.action_binding_count = 1u;
        config.prepare_tick = prepare_ok;
        config.advance_media_one = media_ok;
        SceneSessionFailure failure{};

        /* 1. Real refresh callback: both rows applied, UI table marked, logged. */
        assert(scene_session_create(&config, &app.session, &failure) == SCENE_SESSION_OK);
        SceneSessionTickResult tick{};
        assert(scene_session_tick(app.session, &tick) == SCENE_SESSION_OK);
        assert(app.phone_lists.mail_count == 2 && app.phone_lists.web_count == 2);
        assert(std::memcmp(app.phone_mail[0], "one\0", 4) == 0);
        assert(std::memcmp(app.phone_mail[1], "init-mail\0", 10) == 0);
        assert(std::memcmp(app.phone_web[1], "link\0", 5) == 0);
        const ActionUIWorld *ui = scene_session_get_action_ui(app.session);
        assert(ui->controls[3].availability == 1);
        assert(ui->controls[3].flags[0] == 0 && ui->controls[3].flags[1] == 1 && ui->controls[3].flags[2] == 1);
        for (size_t g = 0; g < ACTION_UI_CONTROL_GROUP_COUNT; ++g) {
            if (g == 3u) continue;
            assert(ui->controls[g].availability == 0);
            assert(ui->controls[g].flags[0] == 0 && ui->controls[g].flags[1] == 0 && ui->controls[g].flags[2] == 0);
        }
        for (size_t row = 0; row < 2; ++row) {
            SceneActionRuntimeState state{};
            assert(scene_session_get_action_state(app.session, row, &state) == SCENE_SESSION_OK);
            assert(state.completed == 1u);
        }
        const std::string first = log_text(app);
        const size_t refresh_a = first.find("scene_a83_refresh group=3 active=1 child=1 mail_count=2 web_count=1 status=0");
        const size_t applied_a = first.find("scene_a83_applied row=0 list=mail selected=0 inserted=1 mail_count=2 web_count=1 disposition=3 phase=0");
        const size_t refresh_b = first.find("scene_a83_refresh group=3 active=1 child=2 mail_count=2 web_count=2 status=0");
        const size_t applied_b = first.find("scene_a83_applied row=1 list=web selected=1 inserted=1 mail_count=2 web_count=2 disposition=3 phase=0");
        assert(refresh_a != std::string::npos && applied_a != std::string::npos);
        assert(refresh_b != std::string::npos && applied_b != std::string::npos);
        assert(refresh_a < applied_a && applied_a < refresh_b && refresh_b < applied_b);
        assert(scene_session_tick(app.session, &tick) == SCENE_SESSION_OK);
        assert(count_of(log_text(app), "scene_a83_refresh") == 2u); /* completed rows do not run again */

        /* 2. Host failure: no session to mark -> refresh rejected, rows retained,
         * nothing completed, explicit blocker logged. */
        SceneSession *second = nullptr;
        assert(scene_session_create(&config, &second, &failure) == SCENE_SESSION_OK);
        SceneSession *good = app.session;
        app.session = nullptr;
        std::memcpy(app.phone_mail[0], "changed\0", 8);
        assert(scene_session_tick(second, &tick) == SCENE_SESSION_ERR_EXECUTOR);
        app.session = good;
        SceneActionRuntimeState state{};
        assert(scene_session_get_action_state(second, 0, &state) == SCENE_SESSION_OK && state.completed == 0u);
        assert(std::memcmp(app.phone_mail[0], "one\0", 4) == 0); /* the write preceded the failed refresh */
        assert(app.phone_lists.mail_count == 3 && state.completed == 0u);
        const std::string second_log = log_text(app);
        assert(second_log.find("scene_a83_blocker row=0 status=2 detail=0x83-refresh-failed") != std::string::npos);
        assert(count_of(second_log, "scene_a83_applied") == 2u);
        scene_session_destroy(second);
        scene_session_destroy(app.session);
        app.session = nullptr;
        scene_resource_close(scene);
        session_a83_destroy(app.a83);
        app.a83 = nullptr;
        std::fclose(app.log);
        app.log = nullptr;
        puts("RT-12 app glue: real refresh/handler callbacks, UI table, ordering, host-failure blocker passed");
    }
    return 0;
}
