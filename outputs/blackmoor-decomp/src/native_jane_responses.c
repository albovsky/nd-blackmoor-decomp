#include "native_jane_responses.h"

/* NATIVE-22: semantic reconstruction from immutable GAME.EXE instructions.
 * 0x43ff18..0x440dfc SHA-256:
 * 7ad65087481542ef80cfaef2b87ef47f54858efce2296fb666a2fc03c750c369
 * 0x445253..0x4453a7 SHA-256:
 * 64b906b78c7338014ec32ac956718b9dfe29db91cd5ec1e524c343a328483aeb
 * REA: ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610.
 * The short identifiers select owner-local CONVO and sound resources;
 * no response text or resource payload is embedded here. */

_Static_assert(NATIVE_JANE_MAX_ENTRIES >= 23u, "Jane plan needs 22 candidates plus hook B");

static void append(NativeJaneResponsePlan *plan, const char *key,
                   int16_t scene, uint8_t kind)
{
    /* Only the 22 fixed A blocks and one B block below can append. count is
     * initialized here, never supplied by the caller. */
    NativeJaneResponseEntry *entry = &plan->entries[plan->count++];
    entry->key = key;
    entry->scene = scene;
    entry->kind = kind;
}

static void plan_a(const NativeJaneResponseWorld *world, NativeJaneResponsePlan *plan)
{
    const int32_t *e = world->events;
    const int32_t *p = world->presence;

    if (p[21] == 1 && e[1366] == 0) /* 0x43ff23 */
        append(plan, "NJP45", 1245, NATIVE_JANE_ADD);
    if (e[1494] == 1 && e[1404] == 0) /* 0x43ffc9 */
        append(plan, "NJP50", 1250, NATIVE_JANE_ADD);
    if (e[1435] == 1 && e[1405] == 0) /* 0x44006f */
        append(plan, "NJP57", 1257, NATIVE_JANE_ADD);
    if (e[1968] == 1 && e[1838] == 1 && e[1535] == 0 && e[1333] == 0) /* 0x440115 */
        append(plan, "NJP62", 1262, NATIVE_JANE_ADD);
    if (e[1405] == 1 && p[7] == 0 && e[2058] == 1) /* 0x4401d5 */
        append(plan, "NJP63", 1263, NATIVE_JANE_ADD);
    if (e[1332] == 0) /* 0x440288 */
        append(plan, "NJP65", 1265, NATIVE_JANE_ADD);
    if (e[1567] == 1) /* 0x440321 */
        append(plan, "NJP67", 1268, NATIVE_JANE_ADD);
    if (e[1405] == 1 && e[1971] == 1 && e[1997] == 0 && e[1329] == 0) /* 0x4403ba */
        append(plan, "NJP69", 1269, NATIVE_JANE_ADD);
    if (e[1704] == 1 && e[1430] == 0) /* 0x44047a */
        append(plan, "NJP70", 1270, NATIVE_JANE_ADD);
    if (e[1905] == 1 && e[1424] == 0) /* 0x440520 */
        append(plan, "NJP71", 1271, NATIVE_JANE_ADD);
    if (e[1424] == 1 && e[1980] == 0) /* 0x4405c6 */
        append(plan, "NJP74", 1274, NATIVE_JANE_ADD);
    if (e[2069] == 1 && e[1985] == 0 && e[1385] == 0) /* 0x44066c */
        append(plan, "NJP75", 1275, NATIVE_JANE_ADD);
    if (e[1419] == 0 && e[2069] == 1 && e[1385] == 1 && e[1985] == 0) /* 0x44071f */
        append(plan, "NJP97", 1297, NATIVE_JANE_ADD);
    if (e[1823] == 1 && e[1958] == 0 && e[1316] == 0) /* 0x4407df */
        append(plan, "NJP77", 1277, NATIVE_JANE_ADD);
    if (e[1467] == 1 && e[1774] == 0 && e[1387] == 0) /* 0x440892 */
        append(plan, "NJP78", 1278, NATIVE_JANE_ADD);
    if (e[1383] == 0) /* 0x440945 */
        append(plan, "NJP79", 1279, NATIVE_JANE_ADD);
    if (e[1865] == 1 && e[1349] == 0) /* 0x4409de */
        append(plan, "NJP80", 1280, NATIVE_JANE_ADD);
    if (e[1865] == 1 && e[1349] == 1 && p[5] == 1 && p[13] == 0) /* 0x440a84 */
        append(plan, "NJP82", 1282, NATIVE_JANE_ADD);
    if (e[1944] == 1 && e[1414] == 0) /* 0x440b44 */
        append(plan, "NJP83", 1283, NATIVE_JANE_ADD);
    if (e[1863] == 1 && e[1492] == 1 && e[1400] == 0) /* 0x440bea */
        append(plan, "NJP88", 1288, NATIVE_JANE_ADD);
    if (e[1242] == 1 && e[1399] == 0) /* 0x440c9d */
        append(plan, "NJJ55", 5055, NATIVE_JANE_ADD);
    if (e[1922] == 1 && e[1694] == 0 && e[1403] == 0) /* 0x440d43 */
        append(plan, "NJJ56", 5056, NATIVE_JANE_ADD);
}

int native_jane_responses_plan(const NativeJaneResponseWorld *world,
    uint8_t hook_a, uint8_t hook_b, int32_t crt_return,
    NativeJaneResponsePlan *plan)
{
    NativeJaneResponsePlan built = {0};

    if (plan == NULL)
        return NATIVE_JANE_ERR_ARGUMENT;
    if ((hook_a != NATIVE_JANE_HOOK && hook_a != NATIVE_JANE_NO_HOOK) ||
        (hook_b != NATIVE_JANE_HOOK && hook_b != NATIVE_JANE_NO_HOOK))
        return NATIVE_JANE_ERR_UNSUPPORTED;
    if (hook_a == NATIVE_JANE_HOOK) {
        if (world == NULL || world->events == NULL || world->presence == NULL)
            return NATIVE_JANE_ERR_ARGUMENT;
        if (world->event_count < NATIVE_JANE_EVENT_COUNT ||
            world->presence_count < NATIVE_JANE_PRESENCE_COUNT)
            return NATIVE_JANE_ERR_BOUNDS;
    }
    if (hook_b == NATIVE_JANE_HOOK && (crt_return < 0 || crt_return > 32767))
        return NATIVE_JANE_ERR_BOUNDS;

    if (hook_a == NATIVE_JANE_HOOK)
        plan_a(world, &built);
    if (hook_b == NATIVE_JANE_HOOK) {
        /* 0x445263..0x44538a: genuine CRT returns are nonnegative, so the
         * original signed remainder and four-case switch reduce to this. */
        append(&built, "NJP90", (int16_t)(1290 + crt_return % 4), NATIVE_JANE_REPLACE);
    }
    *plan = built;
    return NATIVE_JANE_OK;
}
