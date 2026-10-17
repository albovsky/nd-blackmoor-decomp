/* RT-44 unit cases for raw 0x4e (recompute a float value from percentages): the kernel (src/action_family_4e_runtime.c) and the
 * binding (src/session_bindings_a4e.c). Bodies are written here; prints "PASS name" / "FAIL name: reason" per case. */
#include <math.h>
#include <stdio.h>
#include <string.h>

#include "session_bindings_a4e.h"

static int failures;

#define CHECK(name, cond)                                      \
    do {                                                       \
        if (!(cond)) {                                         \
            printf("FAIL %s: %s (line %d)\n", name, #cond, __LINE__); \
            ++failures;                                        \
            return;                                            \
        }                                                      \
    } while (0)

typedef struct {
    uint8_t selector;
    int16_t amount;
} Triple;

/* 31 typed bytes, then `tail_records` 16-byte dependency records (zeroed). Unlisted triples are "no term" (99). */
static size_t body(uint8_t *out, uint8_t target, const Triple *t, size_t n, size_t tail_records)
{
    size_t i;
    memset(out, 0, ACTION_FAMILY_4E_BODY_BYTES + 16u * tail_records);
    out[0] = target;
    for (i = 0; i < ACTION_FAMILY_4E_ENTRY_COUNT; ++i) {
        const uint8_t selector = i < n ? t[i].selector : 99u;
        const int16_t amount = i < n ? t[i].amount : 0;
        out[1 + 3 * i] = selector;
        out[2 + 3 * i] = (uint8_t)(uint16_t)amount;
        out[3 + 3 * i] = (uint8_t)((uint16_t)amount >> 8);
    }
    return ACTION_FAMILY_4E_BODY_BYTES + 16u * tail_records;
}

static int visit(SessionA4EBinding *b, const uint8_t *raw, size_t raw_bytes, SceneActionHandlerResult *result)
{
    SceneActionInfo info;
    SceneActionRuntimeState before = {0u, 5u};
    memset(&info, 0, sizeof info);
    info.type = SESSION_A4E_TYPE;
    info.subtype = 1u;
    info.raw_body = raw;
    info.raw_body_length = raw_bytes;
    result->disposition = SCENE_ACTION_HANDLER_PENDING;
    result->phase = 9u;
    return session_a4e_handler(b, 0u, &info, &before, result);
}

static void fresh(ActionCoreWorld *w)
{
    memset(w, 0, sizeof *w);
    action_core_initialize_values(w);
}

static void test_literals_and_skips(void)
{
    ActionCoreWorld w;
    SessionA4EBinding *b;
    uint8_t raw[ACTION_FAMILY_4E_BODY_BYTES];
    SceneActionHandlerResult r;
    const Triple t[] = {{100, 5}, {99, 7}, {100, -2}, {100, 32767}};
    const ActionFamily4ERuntimeOutcome *o;

    fresh(&w);
    w.float_values[3] = 123.0f;   /* slot 33 is overwritten: the target starts at 0 */
    b = session_a4e_create(&w);
    CHECK("literals_and_skips", b != NULL);
    o = session_a4e_last_outcome(b);
    CHECK("literals_and_skips", visit(b, raw, body(raw, 33, t, 4, 0), &r) == SCENE_ACTION_HANDLER_OK);
    CHECK("literals_and_skips", r.disposition == SCENE_ACTION_HANDLER_COMPLETED && r.phase == 0u);
    CHECK("literals_and_skips", w.float_values[3] == 5.0f - 2.0f + 32767.0f);
    CHECK("literals_and_skips", o->target_valid && o->terms_added == 3u && o->reports == 0u && o->unset_terms == 0u);
    CHECK("literals_and_skips", w.float_values[0] == 9999.0f && w.float_values[9] == 9999.0f && w.short_values[0] == 9999);
    session_a4e_destroy(b);
}

static void test_percent_of_slots(void)
{
    ActionCoreWorld w;
    SessionA4EBinding *b;
    uint8_t raw[ACTION_FAMILY_4E_BODY_BYTES];
    SceneActionHandlerResult r;
    /* short slot 2 (=50), float slot 31 (=8.0), the unset short slot 5 and the unset float slot 36 */
    const Triple t[] = {{2, 10}, {31, 250}, {5, 100}, {36, 100}, {2, -100}};
    const ActionFamily4ERuntimeOutcome *o;

    fresh(&w);
    w.short_values[2] = 50;
    w.float_values[1] = 8.0f;
    b = session_a4e_create(&w);
    CHECK("percent_of_slots", b != NULL);
    o = session_a4e_last_outcome(b);
    CHECK("percent_of_slots", visit(b, raw, body(raw, 30, t, 5, 0), &r) == SCENE_ACTION_HANDLER_OK);
    /* 10% of 50 = 5, 250% of 8 = 20, two unset slots add nothing, -100% of 50 = -50 */
    CHECK("percent_of_slots", w.float_values[0] == 5.0f + 20.0f - 50.0f);
    CHECK("percent_of_slots", o->terms_added == 5u && o->unset_terms == 2u);
    session_a4e_destroy(b);
}

static void test_slot_edges_and_ten_triples(void)
{
    ActionCoreWorld w;
    SessionA4EBinding *b;
    uint8_t raw[ACTION_FAMILY_4E_BODY_BYTES];
    SceneActionHandlerResult r;
    /* nine skipped entries, then short slot 29 (200) at 50%: the tenth triple counts */
    const Triple tenth[] = {{99, 1}, {99, 1}, {99, 1}, {99, 1}, {99, 1}, {99, 1}, {99, 1}, {99, 1}, {99, 1}, {29, 50}};
    /* the last short slot, the first float slot and the last float slot */
    const Triple edges[] = {{29, 100}, {30, 100}, {39, 100}, {0, 100}};

    fresh(&w);
    w.short_values[29] = 200;
    w.short_values[0] = 4;
    w.float_values[0] = 0.5f;
    w.float_values[9] = 70.0f;
    b = session_a4e_create(&w);
    CHECK("slot_edges", b != NULL);
    CHECK("slot_edges", visit(b, raw, body(raw, 35, tenth, 10, 0), &r) == SCENE_ACTION_HANDLER_OK);
    CHECK("slot_edges", w.float_values[5] == 100.0f);
    CHECK("slot_edges", visit(b, raw, body(raw, 36, edges, 4, 0), &r) == SCENE_ACTION_HANDLER_OK);
    CHECK("slot_edges", w.float_values[6] == 200.0f + 0.5f + 70.0f + 4.0f);
    CHECK("slot_edges", session_a4e_last_outcome(b)->unset_terms == 0u && session_a4e_last_outcome(b)->reports == 0u);
    session_a4e_destroy(b);
}

static void test_target_range(void)
{
    ActionCoreWorld w;
    SessionA4EBinding *b;
    uint8_t raw[ACTION_FAMILY_4E_BODY_BYTES];
    SceneActionHandlerResult r;
    const Triple t[] = {{100, 4}};
    const uint8_t targets[] = {0, 29, 40, 99, 255};
    const uint8_t edges[] = {30, 39};
    size_t i, j;

    fresh(&w);
    b = session_a4e_create(&w);
    CHECK("target_range", b != NULL);
    for (i = 0; i < sizeof targets; ++i) {
        CHECK("target_range", visit(b, raw, body(raw, targets[i], t, 1, 0), &r) == SCENE_ACTION_HANDLER_OK);
        CHECK("target_range", r.disposition == SCENE_ACTION_HANDLER_COMPLETED && r.phase == 0u);   /* an invalid target still completes */
        CHECK("target_range", !session_a4e_last_outcome(b)->target_valid);
        for (j = 0; j < ACTION_CORE_FLOAT_SLOT_COUNT; ++j) CHECK("target_range", w.float_values[j] == 9999.0f);
    }
    for (i = 0; i < sizeof edges; ++i) {
        CHECK("target_range", visit(b, raw, body(raw, edges[i], t, 1, 0), &r) == SCENE_ACTION_HANDLER_OK);
        CHECK("target_range", w.float_values[edges[i] - 30u] == 4.0f);
    }
    session_a4e_destroy(b);
}

static void test_target_named_as_operand(void)
{
    ActionCoreWorld w;
    SessionA4EBinding *b;
    uint8_t raw[ACTION_FAMILY_4E_BODY_BYTES];
    SceneActionHandlerResult r;
    /* the target is cleared first, so its own slot reads 0 for the first operand and the running sum afterwards */
    const Triple t[] = {{34, 100}, {100, 8}, {34, 50}, {34, 200}};

    fresh(&w);
    w.float_values[4] = 1000.0f;
    b = session_a4e_create(&w);
    CHECK("target_operand", b != NULL);
    CHECK("target_operand", visit(b, raw, body(raw, 34, t, 4, 0), &r) == SCENE_ACTION_HANDLER_OK);
    /* 0 + 0, + 8, + 50% of 8 = 4 -> 12, + 200% of 12 = 24 -> 36 */
    CHECK("target_operand", w.float_values[4] == 36.0f);
    session_a4e_destroy(b);
}

static void test_x87_rounding(void)
{
    ActionCoreWorld w;
    SessionA4EBinding *b;
    uint8_t raw[ACTION_FAMILY_4E_BODY_BYTES];
    SceneActionHandlerResult r;
    const Triple t[] = {{30, 33}, {100, 1}};
    float expect;

    fresh(&w);
    w.float_values[0] = 3.3333333f;
    b = session_a4e_create(&w);
    CHECK("x87_rounding", b != NULL);
    CHECK("x87_rounding", visit(b, raw, body(raw, 31, t, 2, 0), &r) == SCENE_ACTION_HANDLER_OK);
    /* 33 / 100 in double, times the float slot in double, rounded once to float; the sum is double then float */
    expect = (float)((double)(float)(((double)33.0f / 100.0) * (double)3.3333333f) + 1.0);
    CHECK("x87_rounding", w.float_values[1] == expect);
    session_a4e_destroy(b);
}

static void test_rounding_witness(void)
{
    ActionCoreWorld w;
    SessionA4EBinding *b;
    uint8_t raw[ACTION_FAMILY_4E_BODY_BYTES];
    SceneActionHandlerResult r;
    const Triple from_float[] = {{31, 31252}};
    const Triple from_short[] = {{3, -25615}};
    const uint32_t float_slot = 0xb94efb80u, float_result = 0xbd7cae25u;   /* a * slot / 100 would round to ...26 */
    const uint32_t short_result = 0x4affa853u;                              /* ... and to ...54 */
    uint32_t bits;

    fresh(&w);
    memcpy(&w.float_values[1], &float_slot, sizeof float_slot);
    w.short_values[3] = -32705;
    b = session_a4e_create(&w);
    CHECK("rounding_witness", b != NULL);
    CHECK("rounding_witness", visit(b, raw, body(raw, 30, from_float, 1, 0), &r) == SCENE_ACTION_HANDLER_OK);
    memcpy(&bits, &w.float_values[0], sizeof bits);
    CHECK("rounding_witness", bits == float_result);
    CHECK("rounding_witness", visit(b, raw, body(raw, 32, from_short, 1, 0), &r) == SCENE_ACTION_HANDLER_OK);
    memcpy(&bits, &w.float_values[2], sizeof bits);
    CHECK("rounding_witness", bits == short_result);
    session_a4e_destroy(b);
}

static void test_non_finite_slots(void)
{
    ActionCoreWorld w;
    SessionA4EBinding *b;
    uint8_t raw[ACTION_FAMILY_4E_BODY_BYTES];
    SceneActionHandlerResult r;
    const Triple nan_term[] = {{30, 50}, {100, 1}};
    const Triple inf_term[] = {{31, 50}};
    const Triple inf_zero[] = {{31, 0}};

    fresh(&w);
    w.float_values[0] = NAN;          /* the x87 compare is unordered: treated like the unset marker */
    w.float_values[1] = INFINITY;
    b = session_a4e_create(&w);
    CHECK("non_finite", b != NULL);
    CHECK("non_finite", visit(b, raw, body(raw, 32, nan_term, 2, 0), &r) == SCENE_ACTION_HANDLER_OK);
    CHECK("non_finite", w.float_values[2] == 1.0f && session_a4e_last_outcome(b)->unset_terms == 1u);
    CHECK("non_finite", visit(b, raw, body(raw, 33, inf_term, 1, 0), &r) == SCENE_ACTION_HANDLER_OK);
    CHECK("non_finite", isinf(w.float_values[3]) && w.float_values[3] > 0.0f);
    CHECK("non_finite", visit(b, raw, body(raw, 34, inf_zero, 1, 0), &r) == SCENE_ACTION_HANDLER_OK);
    CHECK("non_finite", isnan(w.float_values[4]));   /* 0 / 100 * inf */
    session_a4e_destroy(b);
}

static void test_selector_reports(void)
{
    ActionCoreWorld w;
    SessionA4EBinding *b;
    uint8_t raw[ACTION_FAMILY_4E_BODY_BYTES];
    SceneActionHandlerResult r;
    const Triple t[] = {{40, 5}, {100, 3}, {101, 9}, {255, 1}};
    const ActionFamily4ERuntimeOutcome *o;

    fresh(&w);
    b = session_a4e_create(&w);
    CHECK("selector_reports", b != NULL);
    o = session_a4e_last_outcome(b);
    CHECK("selector_reports", visit(b, raw, body(raw, 38, t, 4, 0), &r) == SCENE_ACTION_HANDLER_OK);
    CHECK("selector_reports", r.disposition == SCENE_ACTION_HANDLER_COMPLETED);   /* the original reports, adds 0 and goes on */
    CHECK("selector_reports", w.float_values[8] == 3.0f);
    CHECK("selector_reports", o->reports == 3u && o->report_selector[0] == 40u && o->report_selector[1] == 101u && o->report_selector[2] == 255u);
    CHECK("selector_reports", session_a4e_reports(b) == 3ul && session_a4e_visits(b) == 1ul);
    session_a4e_destroy(b);
}

static void test_body_and_tail(void)
{
    ActionCoreWorld w;
    SessionA4EBinding *b;
    uint8_t raw[ACTION_FAMILY_4E_BODY_BYTES + 32];
    SceneActionHandlerResult r;
    const Triple t[] = {{100, 6}};
    size_t n;

    fresh(&w);
    b = session_a4e_create(&w);
    CHECK("body_and_tail", b != NULL);
    n = body(raw, 30, t, 1, 2);   /* two dependency records after the typed body are accepted */
    CHECK("body_and_tail", visit(b, raw, n, &r) == SCENE_ACTION_HANDLER_OK && w.float_values[0] == 6.0f);
    CHECK("body_and_tail", visit(b, raw, ACTION_FAMILY_4E_BODY_BYTES - 1u, &r) == SCENE_ACTION_HANDLER_ERROR);   /* too short */
    CHECK("body_and_tail", visit(b, raw, ACTION_FAMILY_4E_BODY_BYTES + 5u, &r) == SCENE_ACTION_HANDLER_ERROR);   /* fractional tail */
    CHECK("body_and_tail", strcmp(session_a4e_failure(b), "invalid raw-0x4e body") == 0);
    {
        SceneActionInfo info;
        SceneActionRuntimeState before = {0u, 0u};
        memset(&info, 0, sizeof info);
        info.type = 0x4fu;
        info.raw_body = raw;
        info.raw_body_length = ACTION_FAMILY_4E_BODY_BYTES;
        CHECK("body_and_tail", session_a4e_handler(b, 0u, &info, &before, &r) == SCENE_ACTION_HANDLER_ERROR);   /* wrong type */
    }
    session_a4e_destroy(b);
}

int main(void)
{
    test_literals_and_skips();
    if (!failures) printf("PASS literals_and_skips\n");
    test_percent_of_slots();
    if (!failures) printf("PASS percent_of_slots\n");
    test_slot_edges_and_ten_triples();
    if (!failures) printf("PASS slot_edges\n");
    test_target_range();
    if (!failures) printf("PASS target_range\n");
    test_target_named_as_operand();
    if (!failures) printf("PASS target_operand\n");
    test_x87_rounding();
    if (!failures) printf("PASS x87_rounding\n");
    test_rounding_witness();
    if (!failures) printf("PASS rounding_witness\n");
    test_non_finite_slots();
    if (!failures) printf("PASS non_finite\n");
    test_selector_reports();
    if (!failures) printf("PASS selector_reports\n");
    test_body_and_tail();
    if (!failures) printf("PASS body_and_tail\n");
    return failures == 0 ? 0 : 1;
}
