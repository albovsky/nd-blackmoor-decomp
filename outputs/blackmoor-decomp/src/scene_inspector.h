#ifndef BLACKMOOR_SCENE_INSPECTOR_H
#define BLACKMOOR_SCENE_INSPECTOR_H

#include "engine_boot.h"
#include "bink_player.h"
#include "game_resources.h"
#include "scene_executor.h"
#include "world_init.h"
#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Automated integration fixture, with no window or output audio device.
 * Uses the caller's bounded New Game snapshot, recovered BOOT phone inputs,
 * decoded sound and timed Action64 clock; then selects the first active flag
 * hotspot in resource order. This exercises selected scene boundaries, not
 * the complete original world initializer, timed media player, caption
 * renderer or game loop. */
int scene_inspector_run(GameResources *resources, const EngineBoot *boot,
                         const SceneResource *scene, BinkPlayer *video,
                         const char *game_directory,
                         WorldInitState *new_game_state,
                         ActionFamily64World *action64_world, FILE *log,
                         SceneTransitionRequest *transition);

#ifdef __cplusplus
}
#endif
#endif
