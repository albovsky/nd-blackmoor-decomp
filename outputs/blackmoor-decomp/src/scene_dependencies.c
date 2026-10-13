#include "scene_dependencies.h"

int scene_dependencies_reduce(int32_t *conditions, const uint16_t *or_after,
                               size_t count, int *satisfied)
{
    size_t changed, i;
    if (!satisfied) return 1;
    *satisfied = 0;
    if (count > SCENE_DEPENDENCY_MAX_LEAVES) return 2;
    if (count && (!conditions || !or_after)) return 1;
    do {
        changed = 0;
        for (i = 0; i < count; ++i) {
            if (i && or_after[i - 1] == 1) {
                if (!conditions[i] && conditions[i - 1]) {
                    conditions[i] = 1; ++changed;
                } else if (conditions[i] && !conditions[i - 1]) {
                    conditions[i - 1] = 1; ++changed;
                }
            }
            if (i + 1 < count && or_after[i] == 1) {
                if (!conditions[i] && conditions[i + 1]) {
                    conditions[i] = 1; ++changed;
                } else if (conditions[i] && !conditions[i + 1]) {
                    conditions[i + 1] = 1; ++changed;
                }
            }
        }
    } while (changed);
    for (i = 0; i < count; ++i) if (!conditions[i]) return 0;
    *satisfied = 1;
    return 0;
}
