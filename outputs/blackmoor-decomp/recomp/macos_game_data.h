#ifndef BLACKMOOR_MACOS_GAME_DATA_H
#define BLACKMOOR_MACOS_GAME_DATA_H
#include <string>
#include <vector>

inline constexpr const char *BLACKMOOR_GAME_SHA256 =
    "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45";

// Read-only validation. Accept the installed game folder or its GOG Mac .app.
// resolved receives the actual directory containing GAME.EXE, never a clone.
bool blackmoor_validate_game_seed(const std::string &directory, const std::string &hash,
                                  std::string *resolved, std::string *error);
// Remembered choice takes priority, followed by known locations in order.
bool blackmoor_find_game_seed(const std::string &remembered,
                              const std::vector<std::string> &known, const std::string &hash,
                              std::string *resolved, std::string *error);

// Null means absent; an explicitly supplied empty directory is an error.
struct BlackmoorGameDataOptions {
    const char *argument_directory = nullptr;
    const char *environment_directory = nullptr;
    std::string seed_directory;
    std::string support_directory; // Application Support/Blackmoor Recompiled; not --save-dir.
    std::string save_directory;    // Only checked against the original; never selected or created here.
    std::string expected_executable_sha256;
    std::vector<std::string> protected_seed_directories;
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
