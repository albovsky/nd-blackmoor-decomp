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

/* Owned copy of the last Bink frame observed before a resource-driven scene
 * transition. `rgba` is allocated by the inspector and remains valid until
 * scene_inspector_frame_snapshot_destroy; it is the decoded background only,
 * not the original composed DirectDraw surface. */
typedef struct scene_inspector_frame_snapshot {
    uint8_t *rgba;
    size_t byte_length;
    uint32_t width;
    uint32_t height;
    uint32_t stride;
    int32_t frame_index;
} SceneInspectorFrameSnapshot;

/* Borrowed decoded frame at inspector entry. The inspector copies it before
 * advancing the player so a transition on the first dispatch still returns
 * the actual current scene image. */
typedef struct scene_inspector_frame_view {
    const uint8_t *rgba;
    size_t byte_length;
    uint32_t width;
    uint32_t height;
    size_t stride;
    int32_t frame_index;
} SceneInspectorFrameView;

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
                         const SceneInspectorFrameView *initial_frame,
                         SceneTransitionRequest *transition,
                         SceneInspectorFrameSnapshot *current_frame);
void scene_inspector_frame_snapshot_destroy(SceneInspectorFrameSnapshot *frame);

#ifdef __cplusplus
}
#endif
#endif
