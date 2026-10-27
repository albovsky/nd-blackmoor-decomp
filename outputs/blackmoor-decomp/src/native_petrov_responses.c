#include "native_petrov_responses.h"

/* Hook 6: semantic reconstruction from immutable GAME.EXE instructions.
 * 0x443ad8..0x443ecd SHA-256:
 * 003d1c006f2bce0f6cb419255632b51a43106ad64a1cb6242be7d16c45a5d52a
 * 0x4458d4..0x4459fd SHA-256:
 * 55aa7ec89e87a0f668319546da2912321ba1d04160eac1e9658d8458dcc1842c
 * REA: ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
 * and ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520.
 * Identity follows the original BOOT UICL contact targeting scene 1600.
 * The short identifiers select owner-local CONVO and sound resources;
 * no response text or resource payload is embedded here. */

_Static_assert(NATIVE_PETROV_MAX_ENTRIES >= 7u, "Petrov plan needs six candidates plus hook B");

static void append(NativePetrovResponsePlan *plan, const char *key,
                   int16_t scene, uint8_t kind)
{
    /* Only the six fixed A blocks and one B block below can append. count is
     * initialized here, never supplied by the caller. */
    NativePetrovResponseEntry *entry = &plan->entries[plan->count++];
    entry->key = key;
    entry->scene = scene;
    entry->kind = kind;
}

static void plan_a(const NativePetrovResponseWorld *world, NativePetrovResponsePlan *plan)
{
    const int32_t *e = world->events;

    if (e[1416] == 0 && e[1610] == 0) /* 0x443ae3 */
        append(plan, "NMP50", 1650, NATIVE_PETROV_ADD);
    if (e[1498] == 1 && e[1878] == 0 && e[1609] == 0) /* 0x443b89 */
        append(plan, "NMP53", 1653, NATIVE_PETROV_ADD);
    if (e[1601] == 0) /* 0x443c3c */
        append(plan, "NMP55", 1655, NATIVE_PETROV_ADD);
    if (e[1242] == 1 && e[1606] == 0) /* 0x443cd5 */
        append(plan, "NMP56", 1656, NATIVE_PETROV_ADD);
    if (e[1493] == 1 && e[1611] == 0) /* 0x443d7b */
        append(plan, "NMP58", 1658, NATIVE_PETROV_ADD);
    if (e[2014] == 1 && e[1605] == 0) /* 0x443e21 */
        append(plan, "NMP62", 1662, NATIVE_PETROV_ADD);
}

int native_petrov_responses_plan(const NativePetrovResponseWorld *world,
    uint8_t hook_a, uint8_t hook_b, int32_t crt_return,
    NativePetrovResponsePlan *plan)
{
    NativePetrovResponsePlan built = {0};

    if (plan == NULL)
        return NATIVE_PETROV_ERR_ARGUMENT;
    if ((hook_a != NATIVE_PETROV_HOOK && hook_a != NATIVE_PETROV_NO_HOOK) ||
        (hook_b != NATIVE_PETROV_HOOK && hook_b != NATIVE_PETROV_NO_HOOK))
        return NATIVE_PETROV_ERR_UNSUPPORTED;
    if (hook_a == NATIVE_PETROV_HOOK) {
        if (world == NULL || world->events == NULL)
            return NATIVE_PETROV_ERR_ARGUMENT;
        if (world->event_count < NATIVE_PETROV_EVENT_COUNT)
            return NATIVE_PETROV_ERR_BOUNDS;
    }
    if (hook_b == NATIVE_PETROV_HOOK && (crt_return < 0 || crt_return > 32767))
        return NATIVE_PETROV_ERR_BOUNDS;

    if (hook_a == NATIVE_PETROV_HOOK)
        plan_a(world, &built);
    if (hook_b == NATIVE_PETROV_HOOK) {
        /* 0x4458df..0x4459f2: genuine CRT returns are nonnegative, so the
         * original signed remainder and three-case switch reduce to this. */
        append(&built, "NMP90", (int16_t)(1690 + crt_return % 3), NATIVE_PETROV_REPLACE);
    }
    *plan = built;
    return NATIVE_PETROV_OK;
}
