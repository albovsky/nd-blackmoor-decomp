#ifndef BLACKMOOR_SCENE_INSPECTOR_H
#define BLACKMOOR_SCENE_INSPECTOR_H

#include "engine_boot.h"
#include "game_resources.h"
#include "scene_executor.h"
#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Automated integration fixture, with no window or output audio device.
 * Uses recovered BOOT inputs, real captions and real decoded sound; then
 * selects the first active flag hotspot in resource order. This exercises
 * selected scene boundaries, not the complete original world initializer,
 * timed media player, caption renderer or game loop. */
int scene_inspector_run(GameResources *resources, const EngineBoot *boot,
                         const SceneResource *scene, const char *game_directory,
                         FILE *log, SceneTransitionRequest *transition);

#ifdef __cplusplus
}
#endif
#endif
