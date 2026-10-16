/* RT-27 unit tests of raw 0x4f "compare a value, set an event flag": decoder, visit and session binding.
 * Prints "PASS <name>" / "FAIL <name>: <message>"; the exit status is the failure count. Fixtures are synthetic
 * bodies (no original bytes). tests/test_action_family_4f.py builds and runs this plainly, under ASan/UBSan and
 * under source mutations. */
#include <math.h>
#include <stdio.h>
#include <string.h>

#include "action_family_4f.h"
#include "session_bindings_a4f.h"

static int g_failed;
static char g_msg[160];
#define CHECK(cond)                                                       \
    do {                                                                  \
        if (!(cond) && !g_failed) {                                       \
            g_failed = 1;                                                 \
            snprintf(g_msg, sizeof g_msg, "line %d: %s", __LINE__, #cond); \
        }                                                                 \
    } while (0)

#define FLAGS 16u
#define UNSET 9999.0f

typedef struct {
    ActionCoreWorld world;
    int32_t flags[FLAGS];
} Fixture;

static void fixture_init(Fixture *f)
{
    unsigned i;
    memset(f, 0, sizeof *f);
    for (i = 0; i < ACTION_CORE_SHORT_SLOT_COUNT; ++i) f->world.short_values[i] = 9999;
    for (i = 0; i < ACTION_CORE_FLOAT_SLOT_COUNT; ++i) f->world.float_values[i] = UNSET;
    f->world.event_flags = f->flags;
    f->world.event_flag_count = FLAGS;
}

/* body: attribute, mode, op, five operands, flag index */
static ActionFamily4FStatus run_body(Fixture *f, const uint8_t b[10], ActionFamily4FResult *r)
{
    ActionFamily4FDecoded d;
    if (action_family_4f_decode(b, 10u, &d) != ACTION_FAMILY_4F_OK) return ACTION_FAMILY_4F_ERR_BODY;
    return action_family_4f_visit(&d, &f->world, r);
}

static void make(uint8_t b[10], uint8_t attribute, uint8_t mode, uint8_t op, const uint8_t v[5], int16_t flag)
{
    unsigned i;
    b[0] = attribute;
    b[1] = mode;
    b[2] = op;
    for (i = 0; i < 5u; ++i) b[3 + i] = v[i];
    b[8] = (uint8_t)((uint16_t)flag & 0xffu);
    b[9] = (uint8_t)((uint16_t)flag >> 8);
}

static int flag_set(const Fixture *f, unsigned i) { return f->flags[i] == 1; }

static void decode_fields(void)
{
    const uint8_t b[10] = {20u, 3u, 2u, 1u, 2u, 3u, 4u, 5u, 0xe8u, 0xfdu}; /* flag -536 */
    ActionFamily4FDecoded d;
    CHECK(action_family_4f_decode(b, 10u, &d) == ACTION_FAMILY_4F_OK);
    CHECK(d.attribute == 20u && d.mode == 3u && d.op == 2u && d.operand[0] == 1u && d.operand[4] == 5u);
    CHECK(d.flag == -536 && memcmp(d.raw, b, 10u) == 0);
    CHECK(action_family_4f_decode(b, 11u, &d) == ACTION_FAMILY_4F_OK); /* tail ignored */
}

static void decode_rejects(void)
{
    const uint8_t b[10] = {0};
    ActionFamily4FDecoded d;
    CHECK(action_family_4f_decode(NULL, 10u, &d) == ACTION_FAMILY_4F_ERR_ARGUMENT);
    CHECK(action_family_4f_decode(b, 10u, NULL) == ACTION_FAMILY_4F_ERR_ARGUMENT);
    CHECK(action_family_4f_decode(b, 9u, &d) == ACTION_FAMILY_4F_ERR_BODY);
    CHECK(action_family_4f_visit(NULL, NULL, NULL) == ACTION_FAMILY_4F_ERR_ARGUMENT);
}

static void literal_operators(void)
{
    /* attribute 3 = 10: operators 0..4 against the literals 10, 11, 9 */
    static const uint8_t lit[3] = {10u, 11u, 9u};
    static const int expect[5][3] = {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}, {1, 0, 1}, {1, 1, 0}};
    unsigned op, k;
    for (op = 0; op < 5u; ++op) {
        for (k = 0; k < 3u; ++k) {
            Fixture f;
            uint8_t v[5] = {99u, 99u, 99u, 99u, 99u}, b[10];
            ActionFamily4FResult r;
            fixture_init(&f);
            f.world.short_values[3] = 10;
            v[k] = lit[k];
            make(b, 3u, 3u, (uint8_t)op, v, 5);
            CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_OK);
            CHECK(r.found == (uint8_t)expect[op][k] && flag_set(&f, 5) == expect[op][k]);
        }
    }
}

static void literal_scan_order_and_unused(void)
{
    Fixture f;
    uint8_t b[10], r0[5] = {99u, 99u, 99u, 99u, 7u}, r1[5] = {99u, 99u, 99u, 99u, 99u};
    ActionFamily4FResult r;
    fixture_init(&f);
    f.world.short_values[0] = 7;
    make(b, 0u, 3u, 0u, r0, 1); /* only the fifth literal matches */
    CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_OK && r.found && flag_set(&f, 1));
    fixture_init(&f);
    f.world.short_values[0] = 99; /* 99 is the unused marker, never a literal */
    make(b, 0u, 3u, 0u, r1, 2);
    CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_OK && !r.found && !flag_set(&f, 2));
}

static void percent_operators(void)
{
    /* b3 * b4 / 100: 30 * 50 / 100 = 15; only the first operand pair is used, then the scan ends */
    static const uint8_t v[5] = {30u, 50u, 15u, 15u, 15u};
    unsigned op;
    for (op = 5; op < 8u; ++op) {
        static const int16_t value[3] = {15, 16, 14};
        static const int expect[3][3] = {{1, 0, 0}, {1, 1, 0}, {1, 0, 1}}; /* ==, >=, <= for 15, 16, 14 */
        unsigned k;
        for (k = 0; k < 3u; ++k) {
            Fixture f;
            uint8_t b[10];
            ActionFamily4FResult r;
            fixture_init(&f);
            f.world.short_values[2] = value[k];
            make(b, 2u, 3u, (uint8_t)op, v, 4);
            CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_OK);
            CHECK(r.found == (uint8_t)expect[op - 5][k]);
        }
    }
    {
        /* the scan ends after the first pair: a later literal that would match is never used; an unused first
         * operand (99) skips the row entirely */
        Fixture f;
        uint8_t b[10], w[5] = {99u, 50u, 15u, 15u, 15u};
        ActionFamily4FResult r;
        fixture_init(&f);
        f.world.short_values[2] = 15;
        make(b, 2u, 3u, 5u, w, 4);
        CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_OK && !r.found);
        f.world.float_values[0] = 49.5f; /* 99 * 50 / 100: only a scan that reuses the unused first operand finds it */
        make(b, 30u, 3u, 5u, w, 4);
        CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_OK && !r.found && !flag_set(&f, 4));
        w[0] = 3u; /* 3 * 50 / 100 = 1.5 is not 15 and the scan does not continue */
        make(b, 2u, 3u, 5u, w, 4);
        CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_OK && !r.found && !flag_set(&f, 4));
        /* (float)(150/100.0) rounding: 255 * 255 / 100 = 650.25 exactly representable */
        f.world.float_values[0] = 650.25f;
        w[0] = 255u;
        w[1] = 255u;
        make(b, 30u, 3u, 5u, w, 4);
        CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_OK && r.found && flag_set(&f, 4));
    }
}

static void unset_and_out_of_range_attributes(void)
{
    static const uint8_t v[5] = {0u, 0u, 0u, 0u, 0u};
    Fixture f;
    uint8_t b[10];
    ActionFamily4FResult r;
    fixture_init(&f);
    make(b, 3u, 3u, 0u, v, 1); /* attribute unset (9999) */
    CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_OK && !r.evaluated && !r.found);
    f.world.short_values[3] = 0;
    make(b, 40u, 3u, 0u, v, 1); /* attribute above 39 */
    CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_OK && !r.evaluated);
    make(b, 255u, 3u, 0u, v, 1);
    CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_OK && !r.evaluated);
    make(b, 3u, 4u, 0u, v, 1); /* mode above 3 */
    CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_OK && !r.evaluated && !r.found);
    make(b, 3u, 3u, 8u, v, 1); /* operator above 7 */
    CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_OK && r.evaluated && !r.found);
    make(b, 3u, 3u, 0u, v, 1); /* sanity: the same row with a valid input sets the flag */
    CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_OK && r.found && flag_set(&f, 1));
    for (unsigned i = 0; i < FLAGS; ++i) if (i != 1u) CHECK(f.flags[i] == 0);
}

static void float_attribute_slots(void)
{
    static const uint8_t v[5] = {5u, 99u, 99u, 99u, 99u};
    Fixture f;
    uint8_t b[10];
    ActionFamily4FResult r;
    fixture_init(&f);
    f.world.float_values[4] = 5.0f; /* attribute 34 */
    make(b, 34u, 3u, 0u, v, 9);
    CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_OK && r.found && flag_set(&f, 9));
    f.world.float_values[4] = 5.5f;
    f.flags[9] = 0;
    make(b, 34u, 3u, 2u, v, 9); /* 5.5 > 5 */
    CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_OK && r.found && flag_set(&f, 9));
}

static void mode_zero_compares_float_slots(void)
{
    static const uint8_t v[5] = {0};
    Fixture f;
    uint8_t b[10];
    ActionFamily4FResult r;
    fixture_init(&f);
    f.world.float_values[0] = 2.0f; /* attribute 30 */
    f.world.float_values[1] = 2.0f;
    make(b, 30u, 0u, 0u, v, 3); /* == another float slot: slot 31 */
    CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_OK && r.found && flag_set(&f, 3));
    fixture_init(&f);
    f.world.float_values[0] = 2.0f; /* the attribute does not match itself and unset slots are skipped */
    make(b, 30u, 0u, 0u, v, 3);
    CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_OK && !r.found && !flag_set(&f, 3));
    f.world.short_values[5] = 2; /* int16 slots are not scanned in mode 0 */
    CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_OK && !r.found);
    f.world.float_values[9] = 1.0f;
    make(b, 30u, 0u, 2u, v, 3); /* > slot 39 (1.0) */
    CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_OK && r.found);
    /* operators 3 and 4 read body[3 + 30..] which is outside the body: refused, nothing changed */
    fixture_init(&f);
    f.world.float_values[0] = 2.0f;
    f.world.float_values[1] = 3.0f;
    make(b, 30u, 0u, 3u, v, 3);
    CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_ERR_UNSUPPORTED && !flag_set(&f, 3));
    /* ... unless every other slot is unset or the attribute itself */
    f.world.float_values[1] = UNSET;
    CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_OK && !r.found);
}

static void mode_one_compares_short_slots(void)
{
    Fixture f;
    uint8_t b[10], v[5] = {0};
    ActionFamily4FResult r;
    fixture_init(&f);
    f.world.short_values[0] = 4; /* attribute */
    f.world.short_values[2] = 4;
    make(b, 0u, 1u, 0u, v, 6);
    CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_OK && r.found && flag_set(&f, 6));
    /* operator 3 compares with the body byte at 3 + slot: slot 2 reads b[5] */
    fixture_init(&f);
    f.world.short_values[0] = 4;
    f.world.short_values[2] = 0;
    v[2] = 4u; /* b[5] */
    make(b, 0u, 1u, 3u, v, 6);
    CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_OK && r.found && flag_set(&f, 6));
    /* slot 7 reads b[10], outside the body */
    fixture_init(&f);
    f.world.short_values[0] = 4;
    f.world.short_values[7] = 0;
    memset(v, 0, sizeof v);
    make(b, 0u, 1u, 4u, v, 6);
    CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_ERR_UNSUPPORTED && !flag_set(&f, 6));
}

static void mode_two_compares_named_slots(void)
{
    Fixture f;
    uint8_t b[10], v[5];
    ActionFamily4FResult r;
    fixture_init(&f);
    f.world.short_values[1] = 8;
    f.world.short_values[9] = 8;
    f.world.float_values[2] = 3.5f; /* slot 32 */
    memset(v, 99, sizeof v);
    v[0] = 9u;
    make(b, 1u, 2u, 0u, v, 7);
    CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_OK && r.found && flag_set(&f, 7));
    fixture_init(&f);
    f.world.short_values[1] = 3;
    f.world.float_values[2] = 3.5f;
    memset(v, 99, sizeof v);
    v[3] = 32u;
    make(b, 1u, 2u, 1u, v, 7); /* 3 < 3.5 */
    CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_OK && r.found && flag_set(&f, 7));
    v[3] = 40u; /* beyond the 40 value slots: the original reads other memory */
    f.flags[7] = 0;
    make(b, 1u, 2u, 1u, v, 7);
    CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_ERR_UNSUPPORTED && !flag_set(&f, 7));
    v[0] = 9u; /* an earlier unset slot is skipped, an earlier match ends the scan before the bad operand */
    v[1] = 1u;
    f.world.short_values[1] = 3;
    f.world.short_values[9] = 9999;
    make(b, 1u, 2u, 0u, v, 7); /* 3 == slot 1 (itself) */
    CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_OK && r.found);
}

static void nan_follows_the_x87_compare(void)
{
    static const uint8_t v[5] = {1u, 99u, 99u, 99u, 99u};
    static const int expect[5] = {1, 1, 0, 0, 1}; /* unordered: C0 and C3 both set */
    unsigned op;
    for (op = 0; op < 5u; ++op) {
        Fixture f;
        uint8_t b[10];
        ActionFamily4FResult r;
        fixture_init(&f);
        f.world.float_values[0] = NAN;
        make(b, 30u, 3u, (uint8_t)op, v, 2);
        CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_OK);
        CHECK(r.found == (uint8_t)expect[op]);
    }
}

static void event_flag_rules(void)
{
    static const uint8_t v[5] = {0u, 99u, 99u, 99u, 99u};
    Fixture f;
    uint8_t b[10];
    ActionFamily4FResult r;
    fixture_init(&f);
    f.world.short_values[0] = 0;
    f.flags[4] = 7;
    make(b, 0u, 3u, 0u, v, -1); /* no flag */
    CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_OK && r.found && !r.flag_set && f.flags[4] == 7);
    make(b, 0u, 3u, 0u, v, 4); /* set to 1, overwriting */
    CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_OK && r.flag_set && f.flags[4] == 1);
    make(b, 0u, 3u, 1u, v, 4); /* false test never clears */
    CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_OK && !r.found && f.flags[4] == 1);
    make(b, 0u, 3u, 0u, v, (int16_t)FLAGS); /* beyond the table */
    CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_ERR_BOUNDS && !r.flag_set);
    make(b, 0u, 3u, 0u, v, -2);
    CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_ERR_BOUNDS);
    make(b, 0u, 3u, 1u, v, (int16_t)FLAGS); /* a false test never touches the flag, so no bounds error */
    CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_OK && !r.found);
    f.world.event_flags = NULL;
    make(b, 0u, 3u, 0u, v, 1);
    CHECK(run_body(&f, b, &r) == ACTION_FAMILY_4F_ERR_BOUNDS);
}

static SceneActionInfo row(uint8_t type, uint8_t subtype, const uint8_t *body, size_t length)
{
    SceneActionInfo info;
    memset(&info, 0, sizeof info);
    info.type = type;
    info.subtype = subtype;
    info.typed_body = body;
    info.typed_body_length = length;
    info.raw_body = body;
    info.raw_body_length = length;
    return info;
}

static void binding_dispositions(void)
{
    static const uint8_t v[5] = {5u, 99u, 99u, 99u, 99u};
    Fixture f;
    uint8_t body[10];
    SessionA4FBinding *bind;
    SceneActionRuntimeState before = {0u, 7u};
    SceneActionHandlerResult out;
    unsigned subtype;
    fixture_init(&f);
    f.world.short_values[0] = 5;
    make(body, 0u, 3u, 0u, v, 2);
    bind = session_a4f_create(&f.world);
    CHECK(bind != NULL && session_a4f_create(NULL) == NULL);
    for (subtype = 0; subtype < 5u && bind != NULL; ++subtype) {
        SceneActionInfo info = row(0x4f, (uint8_t)subtype, body, 10u);
        f.flags[2] = 0;
        out.disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;
        out.phase = 99u;
        CHECK(session_a4f_handler(bind, 3u, &info, &before, &out) == SCENE_ACTION_HANDLER_OK);
        CHECK(out.phase == 0u && out.disposition == SCENE_ACTION_HANDLER_COMPLETED && f.flags[2] == 1);
    }
    CHECK(session_a4f_visits(bind) == 5ul && session_a4f_flags_set(bind) == 5ul);
    session_a4f_destroy(bind);
}

static void binding_failures(void)
{
    static const uint8_t v[5] = {5u, 99u, 99u, 99u, 99u};
    Fixture f;
    uint8_t good[10], far_flag[10], mode_zero[10];
    SessionA4FBinding *bind;
    SceneActionRuntimeState before = {0u, 0u};
    SceneActionHandlerResult out = {SCENE_ACTION_HANDLER_PENDING, 0u};
    SceneActionInfo info;
    fixture_init(&f);
    f.world.short_values[0] = 5;
    make(good, 0u, 3u, 0u, v, 2);
    make(far_flag, 0u, 3u, 0u, v, 900);
    make(mode_zero, 30u, 0u, 3u, v, 2);
    f.world.float_values[0] = 1.0f;
    f.world.float_values[1] = 2.0f;
    bind = session_a4f_create(&f.world);
    CHECK(bind != NULL);
    info = row(0x4f, 1u, good, 9u); /* short typed body */
    CHECK(session_a4f_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    info = row(0x50, 1u, good, 10u); /* wrong type */
    CHECK(session_a4f_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    info = row(0x4f, 1u, far_flag, 10u);
    CHECK(session_a4f_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(strstr(session_a4f_failure(bind), "event flag") != NULL);
    info = row(0x4f, 1u, mode_zero, 10u);
    CHECK(session_a4f_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    info = row(0x4f, 1u, good, 10u);
    CHECK(session_a4f_handler(NULL, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_a4f_handler(bind, 0u, NULL, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_a4f_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_OK);
    CHECK(strcmp(session_a4f_failure(bind), "none") == 0);
    session_a4f_destroy(bind);
}

static void run(const char *name, void (*fn)(void), int *failures)
{
    g_failed = 0;
    g_msg[0] = '\0';
    fn();
    if (g_failed) {
        printf("FAIL %s: %s\n", name, g_msg);
        ++*failures;
    } else {
        printf("PASS %s\n", name);
    }
}

int main(void)
{
    int failures = 0;
    run("decode_fields", decode_fields, &failures);
    run("decode_rejects", decode_rejects, &failures);
    run("literal_operators", literal_operators, &failures);
    run("literal_scan_order_and_unused", literal_scan_order_and_unused, &failures);
    run("percent_operators", percent_operators, &failures);
    run("unset_and_out_of_range_attributes", unset_and_out_of_range_attributes, &failures);
    run("float_attribute_slots", float_attribute_slots, &failures);
    run("mode_zero_compares_float_slots", mode_zero_compares_float_slots, &failures);
    run("mode_one_compares_short_slots", mode_one_compares_short_slots, &failures);
    run("mode_two_compares_named_slots", mode_two_compares_named_slots, &failures);
    run("nan_follows_the_x87_compare", nan_follows_the_x87_compare, &failures);
    run("event_flag_rules", event_flag_rules, &failures);
    run("binding_dispositions", binding_dispositions, &failures);
    run("binding_failures", binding_failures, &failures);
    return failures;
}
