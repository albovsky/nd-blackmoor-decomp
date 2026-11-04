// Command-line read-only probe of the exact validator used by NSOpenPanel.
#import <Foundation/Foundation.h>
#include "macos_game_data.h"
#include <cstdio>
int main(int argc, char **argv) {
    @autoreleasepool {
        if (argc != 2) return 2;
        std::string resolved, error;
        bool ok = blackmoor_validate_game_seed(argv[1], BLACKMOOR_GAME_SHA256, &resolved, &error);
        printf("GAME_FOLDER accepted=%d %s\n", ok, ok ? resolved.c_str() : error.c_str());
        return ok ? 0 : 1;
    }
}
