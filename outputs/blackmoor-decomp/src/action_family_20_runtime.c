#include "action_family_20_runtime.h"

int action_family_20_runtime_visit(const ActionFamily20Decoded *decoded, Action20World *world, const Action20Host *host,
                                   Action20Outcome *out)
{
    uint32_t erased = 0u;

    if (decoded == NULL || world == NULL || host == NULL || host->erase_rows == NULL || out == NULL) {
        return ACTION_FAMILY_20_RUNTIME_ERR_ARGUMENT;
    }
    /* The erase reads none of the cells below, so running it first leaves every observable order intact and lets a host
     * failure change nothing. */
    if (host->erase_rows(host->context, &erased) != 0) {
        return ACTION_FAMILY_20_RUNTIME_ERR_HOST;
    }
    world->view_cell_63aa10 = (int32_t)decoded->dword_0;                 /* 0x4293bc */
    world->view_cell_55cd94 = (int32_t)decoded->dword_4;                 /* 0x4293ca */
    world->scene_5bb57b = world->scene_5bb57f;                           /* 0x4293ee..0x4293f4 */
    world->word_5c3a4f = (int16_t)(uint16_t)((uint32_t)world->scene_5bb57b & 0xffffu); /* 0x4293fa..0x429401 */
    out->rows_erased = erased;
    return ACTION_FAMILY_20_RUNTIME_OK;
}
