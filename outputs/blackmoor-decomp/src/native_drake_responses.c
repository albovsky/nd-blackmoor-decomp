#include "native_drake_responses.h"

/* NATIVE-26: semantic reconstruction from immutable GAME.EXE instructions.
 * 0x43f31a..0x43ff18 SHA-256:
 * e26bc0a579f9612fbee51fda7c6894045caeda446e066557083f13e4ea71c4cc
 * 0x44512a..0x445253 SHA-256:
 * 171912297d43e79143a33a4a528d48a31aa0f6df3f8620737ad2f6f7dedbe950
 * REA: ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610.
 * The short identifiers select owner-local CONVO and sound resources;
 * no response text or resource payload is embedded here. */

_Static_assert(NATIVE_DRAKE_MAX_ENTRIES >= 19u, "Drake plan needs 18 candidates plus hook B");

static void append(NativeDrakeResponsePlan *plan, const char *key,
                   int16_t scene, uint8_t kind)
{
    /* Only the 18 fixed A blocks and one B block below can append. count is
     * initialized here, never supplied by the caller. */
    NativeDrakeResponseEntry *entry = &plan->entries[plan->count++];
    entry->key = key;
    entry->scene = scene;
    entry->kind = kind;
}

static void plan_a(const NativeDrakeResponseWorld *world, NativeDrakeResponsePlan *plan)
{
    const int32_t *e = world->events;

    if (e[1944] == 1 && e[1538] == 0) /* 0x43f325 */
        append(plan, "NMD50", 1050, NATIVE_DRAKE_ADD);
    if (e[1968] == 1 && e[1838] == 1 && e[1535] == 0) /* 0x43f3cb */
        append(plan, "NMD55", 1055, NATIVE_DRAKE_ADD);
    if (e[1576] == 1 && e[1544] == 0) /* 0x43f47e */
        append(plan, "NMD58", 1058, NATIVE_DRAKE_ADD);
    if (e[1395] == 1 && e[1528] == 0) /* 0x43f524 */
        append(plan, "NMD60", 1060, NATIVE_DRAKE_ADD);
    if (e[1519] == 0) /* 0x43f5ca */
        append(plan, "NDC08d", 1061, NATIVE_DRAKE_ADD);
    if (e[1529] == 0) /* 0x43f663 */
        append(plan, "NMD62", 1062, NATIVE_DRAKE_ADD);
    if (e[1528] == 1 && e[1515] == 0) /* 0x43f6fc */
        append(plan, "NMD63", 1063, NATIVE_DRAKE_ADD);
    if (e[1954] == 1 && e[1545] == 0) /* 0x43f7a2 */
        append(plan, "NMD65", 1065, NATIVE_DRAKE_ADD);
    if (e[1569] == 1 && e[1525] == 0) /* 0x43f848 */
        append(plan, "NMD67", 1067, NATIVE_DRAKE_ADD);
    if (e[1467] == 1 && e[1525] == 1 && e[1526] == 0) /* 0x43f8ee */
        append(plan, "NMD68", 1068, NATIVE_DRAKE_ADD);
    if (e[1262] == 1 && e[1523] == 0) /* 0x43f9a1 */
        append(plan, "NMD72", 1072, NATIVE_DRAKE_ADD);
    if (e[1865] == 1 && e[1349] == 0 && e[1522] == 0) /* 0x43fa47 */
        append(plan, "NMD75", 1075, NATIVE_DRAKE_ADD);
    if (e[1941] == 1 && e[1536] == 0) /* 0x43fafa */
        append(plan, "NMD76", 1076, NATIVE_DRAKE_ADD);
    if (e[1857] == 1 && e[1518] == 0) /* 0x43fba0 */
        append(plan, "NMD77", 1077, NATIVE_DRAKE_ADD);
    if (e[2069] == 1 && e[1985] == 0 && e[1385] == 0 && e[1524] == 0) /* 0x43fc46 */
        append(plan, "NMD78", 1078, NATIVE_DRAKE_ADD);
    if (e[1349] == 1 && e[1543] == 0) /* 0x43fd06 */
        append(plan, "NMD82", 1082, NATIVE_DRAKE_ADD);
    if (e[1535] == 1 && e[2080] == 1 && e[2002] == 0 && e[1530] == 0) /* 0x43fdac */
        append(plan, "NMD86", 1086, NATIVE_DRAKE_ADD);
    if (e[2002] == 1 && e[1541] == 0) /* 0x43fe6c */
        append(plan, "NMD88", 1088, NATIVE_DRAKE_ADD);
}

int native_drake_responses_plan(const NativeDrakeResponseWorld *world,
    uint8_t hook_a, uint8_t hook_b, int32_t crt_return,
    NativeDrakeResponsePlan *plan)
{
    NativeDrakeResponsePlan built = {0};

    if (plan == NULL)
        return NATIVE_DRAKE_ERR_ARGUMENT;
    if ((hook_a != NATIVE_DRAKE_HOOK && hook_a != NATIVE_DRAKE_NO_HOOK) ||
        (hook_b != NATIVE_DRAKE_HOOK && hook_b != NATIVE_DRAKE_NO_HOOK))
        return NATIVE_DRAKE_ERR_UNSUPPORTED;
    if (hook_a == NATIVE_DRAKE_HOOK) {
        if (world == NULL || world->events == NULL)
            return NATIVE_DRAKE_ERR_ARGUMENT;
        if (world->event_count < NATIVE_DRAKE_EVENT_COUNT)
            return NATIVE_DRAKE_ERR_BOUNDS;
    }
    if (hook_b == NATIVE_DRAKE_HOOK && (crt_return < 0 || crt_return > 32767))
        return NATIVE_DRAKE_ERR_BOUNDS;

    if (hook_a == NATIVE_DRAKE_HOOK)
        plan_a(world, &built);
    if (hook_b == NATIVE_DRAKE_HOOK) {
        /* 0x44513a..0x44523c: genuine CRT returns are nonnegative, so the
         * original signed remainder and three-case switch reduce to this. */
        append(&built, "NDE90", (int16_t)(1090 + crt_return % 3), NATIVE_DRAKE_REPLACE);
    }
    *plan = built;
    return NATIVE_DRAKE_OK;
}
