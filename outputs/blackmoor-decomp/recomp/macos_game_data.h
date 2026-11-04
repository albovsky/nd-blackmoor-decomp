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

// Startup only. Hashes the executable that will actually be started (after --exe, GAME_EXE and the data directory are resolved) and refuses
// anything but the trusted original. The error names the file, its SHA-256 and the required SHA-256.
bool blackmoor_verify_executable(const std::string &path, const std::string &expected_sha256, std::string *error);

// Startup only. Creates the save directory when missing, then refuses it, with a path-specific message, when the game could not write
// under it: the directory, an existing Documents*/ subfolder or an existing game save folder inside it that is not writable. Existing
// saves are never opened for writing here. It also sweeps the temp files of dead processes that an interrupted save left behind.
bool blackmoor_prepare_save_directory(const std::string &directory, std::string *error);

// The whole startup gate in its required order: the resolved executable first (so a refusal creates nothing), then the save directory. The error
// is already prefixed "GAME_EXE: " or "SAVE_DIR: " for the launcher's stderr.
bool blackmoor_check_startup(const std::string &executable, const std::string &expected_sha256, const std::string &save_directory,
                             std::string *error);
#endif
