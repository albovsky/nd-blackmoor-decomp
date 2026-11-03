#ifndef BLACKMOOR_MACOS_GAME_DATA_H
#define BLACKMOOR_MACOS_GAME_DATA_H
#include <string>

// Null means absent; an explicitly supplied empty directory is an error.
struct BlackmoorGameDataOptions {
    const char *argument_directory = nullptr;
    const char *environment_directory = nullptr;
    std::string seed_directory;
    std::string support_directory; // Application Support/Blackmoor Recompiled; not --save-dir.
    std::string save_directory;    // Only checked against the original; never selected or created here.
    std::string expected_executable_sha256;
};
struct BlackmoorGameDataSelection {
    std::string directory;
    bool default_clone = false;
    bool created = false;
};
// Startup only. Never launches guest code or writes the seed. Default copies
// exclude Documents* directories and *.SAV files; explicit scratch stays in place.
bool blackmoor_select_game_data(const BlackmoorGameDataOptions &options,
                               BlackmoorGameDataSelection *selection,
                               std::string *error);
#endif
