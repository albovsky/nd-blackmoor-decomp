// Exercise the real app startup ordering without preferences, guest, GUI or audio.
#import <AppKit/AppKit.h>
#import <objc/runtime.h>
#include "macos_game_data.h"
extern "C" {
#include "rc_platform.h"
#include "rc_input_script.h"
#include "macos_platform.h"
}

static constexpr const char *fixture_hash =
    "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"; // SHA256("abc")
static NSArray *fixture_support_paths;
static NSString *fixture_home;
static unsigned selections, gates, guest_boundaries, preference_removals;
static std::string selected_directory;
struct GuestBoundary {};
[[noreturn]] static int stop_before_guest() { ++guest_boundaries; throw GuestBoundary{}; }
[[noreturn]] static void unexpected_host_call() { abort(); }
static void destroy_unused_input_script(RcInputScript *) {}
static bool observe_selection(const BlackmoorGameDataOptions &options,
                              BlackmoorGameDataSelection *selection, std::string *error) {
    ++selections;
    const bool okay = blackmoor_select_game_data(options, selection, error);
    if (okay) selected_directory = selection->directory;
    return okay;
}
static bool observe_gate(const std::string &executable, const std::string &hash,
                         const std::string &saves, std::string *error) {
    ++gates;
    return blackmoor_check_startup(executable, hash, saves, error);
}

// Only the external startup context and the post-validation guest boundary are
// substituted. Selection, destination checks and the executable/save gate stay real.
// The noreturn boundary also lets the linker omit the unrelated runtime adapters.
#define BLACKMOOR_GAME_SHA256 fixture_hash
#define NSSearchPathForDirectoriesInDomains(...) fixture_support_paths
#define NSHomeDirectory() fixture_home
#define blackmoor_select_game_data observe_selection
#define blackmoor_check_startup observe_gate
#define rc_input_script_load_file(...) nullptr
#define rc_input_script_destroy destroy_unused_input_script
#define rc_set_platform(...) ((void)0)
#define rc_start(...) stop_before_guest()
#define rc_request_stop() unexpected_host_call()
#define blackmoor_macos_stop(...) unexpected_host_call()
#define main blackmoor_application_main
#include "macos_recomp.mm"
#undef main
#undef blackmoor_macos_stop
#undef rc_request_stop
#undef rc_start
#undef rc_set_platform
#undef rc_input_script_destroy
#undef rc_input_script_load_file
#undef blackmoor_check_startup
#undef blackmoor_select_game_data
#undef NSHomeDirectory
#undef NSSearchPathForDirectoriesInDomains
#undef BLACKMOOR_GAME_SHA256

@interface StartupMemoryDefaults : NSObject
@property(nonatomic, strong) NSMutableDictionary *values;
@end
@implementation StartupMemoryDefaults
- (id)objectForKey:(NSString *)key { return self.values[key]; }
- (BOOL)boolForKey:(NSString *)key { return [self.values[key] boolValue]; }
- (void)setObject:(id)value forKey:(NSString *)key { self.values[key] = value; }
- (void)removeObjectForKey:(NSString *)key {
    ++preference_removals;
    [self.values removeObjectForKey:key];
}
@end
static StartupMemoryDefaults *memory_defaults;
static id only_memory_defaults(id, SEL) { return memory_defaults; }
static NSString *fixture_ns(const std::string &value) {
    return [NSString stringWithUTF8String:value.c_str()];
}

int main(int argc, char **argv) {
    @autoreleasepool {
        if (argc != 7 || strcmp(argv[1], "--mute") || strcmp(argv[2], "--background")) return 90;
        const std::string root = argv[3], original = argv[4], remembered = argv[5], saves = argv[6];
        fixture_home = fixture_ns(root + "/home");
        fixture_support_paths = @[fixture_ns(root + "/support")];
        const std::string support = root + "/support/Blackmoor Recompiled Data";
        BlackmoorGameDataOptions options;
        options.seed_directory = original;
        options.support_directory = support;
        options.save_directory = root + "/cache-preparation-saves";
        options.expected_executable_sha256 = fixture_hash;
        options.protected_seed_directories = {original};
        BlackmoorGameDataSelection cache;
        std::string error;
        if (!blackmoor_select_game_data(options, &cache, &error)) {
            fprintf(stderr, "FIXTURE_CACHE: %s\n", error.c_str());
            return 91;
        }

        memory_defaults = [[StartupMemoryDefaults alloc] init];
        memory_defaults.values = [NSMutableDictionary dictionary];
        memory_defaults.values[kGameFolderPreference] = fixture_ns(remembered);
        Method method = class_getClassMethod(NSUserDefaults.class, @selector(standardUserDefaults));
        IMP prior = method_setImplementation(method, (IMP)only_memory_defaults);
        std::vector<std::string> arguments = {argv[0], "--mute", "--background", "--save-dir", saves,
                                              "--log", root + "/startup.log", "--stop-after-ms", "1"};
        std::vector<char *> raw;
        for (auto &argument : arguments) raw.push_back(argument.data());
        int result = -1;
        try {
            result = blackmoor_application_main((int)raw.size(), raw.data());
        } catch (const GuestBoundary &) {
            // A successful gate stops here; no guest, window or audio can start.
            if (g.log) fclose(g.log);
        }
        g.log = nullptr;
        method_setImplementation(method, prior);
        NSString *retained = memory_defaults.values[kGameFolderPreference];
        NSDictionary *record = @{@"application_return":@(result), @"selection_calls":@(selections),
            @"gate_calls":@(gates), @"guest_boundaries":@(guest_boundaries),
            @"preference_removals":@(preference_removals),
            @"remembered_retained":@([retained isEqualToString:fixture_ns(remembered)]),
            @"selected_directory":fixture_ns(selected_directory), @"cache_directory":fixture_ns(cache.directory),
            @"cache_created":@(cache.created), @"save_directory_exists":@([[NSFileManager defaultManager]
                fileExistsAtPath:fixture_ns(saves)]), @"real_guest_GUI_audio":@NO};
        NSData *json = [NSJSONSerialization dataWithJSONObject:record options:0 error:nullptr];
        puts([[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding].UTF8String);
        return 0;
    }
}
