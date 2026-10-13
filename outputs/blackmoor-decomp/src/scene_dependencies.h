#ifndef BLACKMOOR_SCENE_DEPENDENCIES_H
#define BLACKMOOR_SCENE_DEPENDENCIES_H
#include <stddef.h>
#include <stdint.h>
#ifdef __cplusplus
extern "C" {
#endif

#define SCENE_DEPENDENCY_MAX_LEAVES 512u
/* Recovered branch reduction from GAME.EXE 0x42406d. Conditions are the
 * already evaluated signed 32-bit leaf states. A link value of exactly one
 * joins that leaf to its successor with OR; other values leave an AND boundary.
 * Reduction mutates zero states to one as the original does. Nonzero states
 * retain their exact values. Nested branch construction/evaluation and action
 * dispatch remain separate engine work. Empty branches follow 0x424aa8's
 * no-dependencies path, rather than invoking 0x42406d on a null child pointer.
 * Return 0 on success, 1 for invalid pointers, 2 for exceeding the loader limit.
 */
int scene_dependencies_reduce(int32_t *conditions, const uint16_t *or_after,
                               size_t count, int *satisfied);
#ifdef __cplusplus
}
#endif
#endif
