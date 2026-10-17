/* RT-41 unit tests of raw 0x7d "return from the examined item's scene": the record pop 0x4eb5f2 (src/action_family_7d_runtime.c)
 * and the session binding (src/session_bindings_a7d.c). Prints "PASS <name>" / "FAIL <name>: <message>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). tests/test_action_family_7d_runtime.py builds and runs this plainly,
 * under ASan/UBSan and under source mutations. */
#include <stdio.h>
#include <string.h>

#include "session_bindings_a7d.h"

static int g_failed;
static char g_msg[160];
#define CHECK(cond)                                                       \
    do {                                                                  \
        if (!(cond) && !g_failed) {                                       \
            g_failed = 1;                                                 \
            snprintf(g_msg, sizeof g_msg, "line %d: %s", __LINE__, #cond); \
        }                                                                 \
    } while (0)

#define CAP 70

static SceneRestoreSlot sample_slot(void)
{
    SceneRestoreSlot s;
    s.marker_5c3a1b = 4700;
    s.scene_5c3a1d = 4710;
    s.word_5c3a1f = 11;
    s.word_5c3a21 = -12;
    s.word_5c3a23 = 2;
    s.dword_5c3a25 = 0x01020304;
    s.dword_5c3a29 = 0x0a0b0c0d;
    s.dword_5c3a2d = 0x7a7b7c7d;
    return s;
}

typedef struct {
    int16_t held, count, selector;
    uint16_t items[CAP];
    int32_t presence[CAP];
    uint8_t close_flag;
    SceneRestoreSlot slot;
    /* what the host saw */
    char order[16];
    int calls[5]; /* rebuild, ui, change, open, apply */
    int refuse_change, refuse_ui, refuse_open, refuse_rebuild;
    int16_t rebuilt_item;
    int16_t ui_index;
    int32_t ui_enable;
    int16_t ui_sub;
    SceneStackPop pop;
    SceneTransitionRequest request;
    SceneRestoreSlot seen_slot;
    int16_t seen_selector;
} World;

static void note(World *w, char c)
{
    size_t n = strlen(w->order);
    if (n + 1 < sizeof w->order) {
        w->order[n] = c;
        w->order[n + 1] = '\0';
    }
}

static void world_init(World *w)
{
    memset(w, 0, sizeof *w);
    w->held = -1;
    w->selector = -1;
    w->slot = sample_slot();
    w->close_flag = 1;
}

static Action78Model model_of(World *w)
{
    Action78Model m;
    memset(&m, 0, sizeof m);
    m.inventory.held_item = &w->held;
    m.inventory.item_count = &w->count;
    m.inventory.items = w->items;
    m.inventory.item_capacity = CAP;
    m.inventory.presence = w->presence;
    m.inventory.presence_capacity = CAP;
    return m;
}

static int rebuild(void *c, int16_t item)
{
    World *w = (World *)c;
    ++w->calls[0];
    note(w, 'R');
    w->rebuilt_item = item;
    return w->refuse_rebuild;
}

static int ui(void *c, int16_t index, int32_t enable, int16_t sub)
{
    World *w = (World *)c;
    ++w->calls[1];
    note(w, 'U');
    w->ui_index = index;
    w->ui_enable = enable;
    w->ui_sub = sub;
    return w->refuse_ui;
}

static int change(void *c, const SceneStackPop *pop)
{
    World *w = (World *)c;
    ++w->calls[2];
    note(w, 'C');
    w->pop = *pop;
    w->seen_slot = w->slot;
    w->seen_selector = w->selector;
    return w->refuse_change;
}

static int open_inv(void *c)
{
    World *w = (World *)c;
    ++w->calls[3];
    note(w, 'O');
    return w->refuse_open;
}

static void kernel_host(World *w, Action7dHost *h)
{
    memset(h, 0, sizeof *h);
    h->context = w;
    h->inventory.inventory.context = w;
    h->inventory.inventory.rebuild_view = rebuild;
    h->inventory.context = w;
    h->inventory.request_ui_animation = ui;
    h->scene_change = change;
    h->open_inventory = open_inv;
}

static Action7dModel kernel_model(World *w, Action78Model *inv)
{
    Action7dModel m;
    *inv = model_of(w);
    m.slot = &w->slot;
    m.held_selector = &w->selector;
    m.inventory = *inv;
    m.view_close_flag = &w->close_flag;
    return m;
}

static void pop_reads_the_record(void)
{
    SceneRestoreSlot s = sample_slot();
    SceneStackPop p;
    CHECK(scene_restore_slot_pop(&s, &p) == SCENE_RESTORE_POP_OK);
    CHECK(p.scene_5bb57b == 4710 && p.scene_5bb57f == 4710); /* both from the second word */
    CHECK(p.word_5bb599 == 11 && p.word_5bb595 == -12 && p.word_5c39ff == 1);
    CHECK(p.dword_5bb59b == 0x01020304 && p.dword_5bb59f == 0x0a0b0c0d && p.dword_5bb5a3 == 0x7a7b7c7d);
    CHECK(p.start_5bb1ca == 1 && p.mode_583999 == 4);
    /* the record is empty again; the other words keep their values */
    CHECK(s.marker_5c3a1b == 0x270f && s.scene_5c3a1d == 0x270f);
    CHECK(s.word_5c3a1f == 11 && s.word_5c3a21 == -12 && s.word_5c3a23 == 2);
    CHECK(s.dword_5c3a25 == 0x01020304 && s.dword_5c3a29 == 0x0a0b0c0d && s.dword_5c3a2d == 0x7a7b7c7d);
}

static void pop_sign_extends_and_start_flag(void)
{
    SceneRestoreSlot s = sample_slot();
    SceneStackPop p;
    s.scene_5c3a1d = -2;
    s.word_5c3a23 = 1;
    CHECK(scene_restore_slot_pop(&s, &p) == SCENE_RESTORE_POP_OK);
    CHECK(p.scene_5bb57b == -2 && p.scene_5bb57f == -2); /* movsx */
    CHECK(p.start_5bb1ca == 0);                          /* type word 1 */
    s = sample_slot();
    s.word_5c3a23 = 0x101;
    CHECK(scene_restore_slot_pop(&s, &p) == SCENE_RESTORE_POP_OK && p.start_5bb1ca == 1); /* the whole word is compared */
    s = sample_slot();
    s.word_5c3a23 = 0;
    CHECK(scene_restore_slot_pop(&s, &p) == SCENE_RESTORE_POP_OK && p.start_5bb1ca == 1);
}

static void pop_of_an_empty_record_carries_on(void)
{
    SceneRestoreSlot s = sample_slot();
    SceneStackPop p;
    s.marker_5c3a1b = 0x270f;                 /* only the first word is tested */
    CHECK(scene_restore_slot_pop(&s, &p) == SCENE_RESTORE_POP_EMPTY);
    CHECK(p.scene_5bb57b == 4710 && p.mode_583999 == 4); /* the original goes on with the values it finds */
    CHECK(s.marker_5c3a1b == 0x270f && s.scene_5c3a1d == 0x270f);
    s = sample_slot();
    s.scene_5c3a1d = 0x270f;                  /* the scene word alone is not the empty test */
    CHECK(scene_restore_slot_pop(&s, &p) == SCENE_RESTORE_POP_OK && p.scene_5bb57b == 0x270f);
    CHECK(scene_restore_slot_pop(NULL, &p) == SCENE_RESTORE_POP_ARGUMENT);
    CHECK(scene_restore_slot_pop(&s, NULL) == SCENE_RESTORE_POP_ARGUMENT);
}

static void save_then_pop_round_trip(void)
{
    SceneRestoreSlot s;
    SceneStackCurrent c;
    SceneStackPop p;
    scene_restore_slot_clear(&s);
    scene_restore_slot_init_words(&s);
    CHECK(s.marker_5c3a1b == 0x270f && s.scene_5c3a1d == 0x270f && s.word_5c3a1f == 0 && s.word_5c3a21 == 0 && s.word_5c3a23 == 2);
    memset(&c, 0, sizeof c);
    c.scene_5bb57b = 4700;
    c.scene_5bb57f = 4701;
    c.word_5bb50b = 3;
    c.word_5bb593 = 4;
    c.dword_5bb5a7 = 100;
    c.dword_5bb5ab = 200;
    c.dword_5bb5af = 300;
    scene_restore_slot_save(&s, &c, 1);
    CHECK(s.marker_5c3a1b == 4700 && s.scene_5c3a1d == 4701 && s.word_5c3a1f == 3 && s.word_5c3a21 == 4 && s.word_5c3a23 == 1);
    CHECK(s.dword_5c3a25 == 100 && s.dword_5c3a29 == 300 && s.dword_5c3a2d == 0); /* the saver overwrites its own store */
    CHECK(scene_restore_slot_pop(&s, &p) == SCENE_RESTORE_POP_OK);
    CHECK(p.scene_5bb57b == 4701 && p.start_5bb1ca == 0);
    CHECK(p.dword_5bb59b == 100 && p.dword_5bb59f == 300 && p.dword_5bb5a3 == 0);
}

static void visit_without_an_item(void)
{
    World w;
    Action78Model inv;
    Action7dModel m;
    Action7dHost h;
    Action7dResult r;
    const char *why = "";
    world_init(&w);
    w.close_flag = 0;
    m = kernel_model(&w, &inv);
    kernel_host(&w, &h);
    CHECK(action7d_visit(&m, &h, &r, &why) == ACTION7D_OK);
    CHECK(strcmp(w.order, "CO") == 0);                 /* no add, no UI request: the scene change, then the inventory flag */
    CHECK(w.pop.scene_5bb57b == 4710 && w.pop.mode_583999 == 4);
    CHECK(w.seen_slot.marker_5c3a1b == 4700);          /* the record is committed only after the host accepted */
    CHECK(w.slot.marker_5c3a1b == 0x270f && w.slot.scene_5c3a1d == 0x270f);
    CHECK(w.selector == -1 && r.selector_cleared && r.completed && r.inventory_open_requested && !r.item_taken_along);
    CHECK(w.count == 0 && w.held == -1);

    /* the close flag set: the inventory is not requested and the provider is not needed */
    world_init(&w);
    w.close_flag = 1;
    m = kernel_model(&w, &inv);
    kernel_host(&w, &h);
    h.open_inventory = NULL;
    CHECK(action7d_visit(&m, &h, &r, &why) == ACTION7D_OK);
    CHECK(strcmp(w.order, "C") == 0 && !r.inventory_open_requested);
    world_init(&w);
    w.close_flag = 0xff;                                 /* any nonzero byte */
    m = kernel_model(&w, &inv);
    kernel_host(&w, &h);
    CHECK(action7d_visit(&m, &h, &r, &why) == ACTION7D_OK && strcmp(w.order, "C") == 0);
}

static void visit_re_adds_the_item(void)
{
    World w;
    Action78Model inv;
    Action7dModel m;
    Action7dHost h;
    Action7dResult r;
    const char *why = "";
    world_init(&w);
    w.close_flag = 0;
    w.selector = 12;
    w.count = 2;
    w.items[0] = 5;
    w.items[1] = 6;
    w.presence[5] = w.presence[6] = 1;
    m = kernel_model(&w, &inv);
    kernel_host(&w, &h);
    CHECK(action7d_visit(&m, &h, &r, &why) == ACTION7D_OK);
    CHECK(strcmp(w.order, "RUCO") == 0);               /* add (rebuild), UI request, scene change, inventory flag */
    CHECK(w.count == 3 && w.items[0] == 12 && w.items[1] == 5 && w.items[2] == 6 && w.presence[12] == 1);
    CHECK(w.rebuilt_item == 12 && w.ui_index == 1 && w.ui_enable == 0 && w.ui_sub == 0);
    CHECK(w.seen_selector == 12);                      /* the selector is cleared after the scene change */
    CHECK(w.selector == -1 && r.item_taken_along && r.readded && r.item == 12 && r.completed);
    CHECK(w.held == -1);                               /* 0x583a29 is not the selector 0x583f1d */
}

static void visit_with_a_duplicate_item(void)
{
    World w;
    Action78Model inv;
    Action7dModel m;
    Action7dHost h;
    Action7dResult r;
    const char *why = "";
    world_init(&w);
    w.selector = 6;
    w.count = 2;
    w.items[0] = 5;
    w.items[1] = 6;
    w.presence[5] = w.presence[6] = 1;
    m = kernel_model(&w, &inv);
    kernel_host(&w, &h);
    CHECK(action7d_visit(&m, &h, &r, &why) == ACTION7D_OK);
    CHECK(strcmp(w.order, "UC") == 0);                 /* the duplicate adds nothing and does not rebuild; the UI request still runs */
    CHECK(w.count == 2 && w.items[0] == 5 && w.items[1] == 6 && !r.readded && r.item_taken_along);
    CHECK(w.selector == -1);
}

static void visit_item_zero_is_an_item(void)
{
    World w;
    Action78Model inv;
    Action7dModel m;
    Action7dHost h;
    Action7dResult r;
    const char *why = "";
    world_init(&w);
    w.selector = 0; /* only -1 means "no item" */
    m = kernel_model(&w, &inv);
    kernel_host(&w, &h);
    CHECK(action7d_visit(&m, &h, &r, &why) == ACTION7D_OK && strcmp(w.order, "RUC") == 0);
    CHECK(w.count == 1 && w.items[0] == 0 && w.presence[0] == 1);
    world_init(&w);
    w.selector = -2; /* any other negative word is an item too (and is refused by the model's bounds) */
    m = kernel_model(&w, &inv);
    kernel_host(&w, &h);
    CHECK(action7d_visit(&m, &h, &r, &why) == ACTION7D_ERR_BOUNDS);
    CHECK(w.order[0] == '\0' && w.selector == -2 && w.slot.marker_5c3a1b == 4700);
}

static void visit_failures(void)
{
    World w;
    Action78Model inv;
    Action7dModel m;
    Action7dHost h;
    Action7dResult r;
    const char *why = "";
    SceneRestoreSlot before;

    /* the empty record: refused before any effect */
    world_init(&w);
    w.selector = 12;
    w.slot.marker_5c3a1b = 0x270f;
    before = w.slot;
    m = kernel_model(&w, &inv);
    kernel_host(&w, &h);
    CHECK(action7d_visit(&m, &h, &r, &why) == ACTION7D_ERR_EMPTY);
    CHECK(w.order[0] == '\0' && w.count == 0 && w.selector == 12 && memcmp(&w.slot, &before, sizeof before) == 0);

    /* missing providers: before any effect */
    world_init(&w);
    w.selector = 12;
    w.close_flag = 0;
    m = kernel_model(&w, &inv);
    kernel_host(&w, &h);
    h.scene_change = NULL;
    CHECK(action7d_visit(&m, &h, &r, &why) == ACTION7D_ERR_UNSUPPORTED && w.order[0] == '\0' && w.count == 0);
    kernel_host(&w, &h);
    h.inventory.request_ui_animation = NULL;
    CHECK(action7d_visit(&m, &h, &r, &why) == ACTION7D_ERR_UNSUPPORTED && w.order[0] == '\0' && w.count == 0);
    kernel_host(&w, &h);
    h.inventory.inventory.rebuild_view = NULL;
    CHECK(action7d_visit(&m, &h, &r, &why) == ACTION7D_ERR_UNSUPPORTED && w.order[0] == '\0' && w.count == 0);
    kernel_host(&w, &h);
    h.open_inventory = NULL;
    CHECK(action7d_visit(&m, &h, &r, &why) == ACTION7D_ERR_UNSUPPORTED && w.order[0] == '\0' && w.count == 0);
    CHECK(w.slot.marker_5c3a1b == 4700 && w.selector == 12);

    /* the host refuses the scene change: the record and the selector are kept (the add stays, as in the original) */
    world_init(&w);
    w.selector = 12;
    w.close_flag = 0;
    w.refuse_change = 1;
    m = kernel_model(&w, &inv);
    kernel_host(&w, &h);
    CHECK(action7d_visit(&m, &h, &r, &why) == ACTION7D_ERR_HOST);
    CHECK(strcmp(w.order, "RUC") == 0 && w.slot.marker_5c3a1b == 4700 && w.selector == 12 && !r.completed);

    /* the UI request is refused: nothing after it runs */
    world_init(&w);
    w.selector = 12;
    w.refuse_ui = 1;
    m = kernel_model(&w, &inv);
    kernel_host(&w, &h);
    CHECK(action7d_visit(&m, &h, &r, &why) == ACTION7D_ERR_HOST && strcmp(w.order, "RU") == 0 && w.slot.marker_5c3a1b == 4700);

    /* the rebuild is refused after the list was committed */
    world_init(&w);
    w.selector = 12;
    w.refuse_rebuild = 1;
    m = kernel_model(&w, &inv);
    kernel_host(&w, &h);
    CHECK(action7d_visit(&m, &h, &r, &why) == ACTION7D_ERR_HOST && strcmp(w.order, "R") == 0 && w.count == 1);

    /* the inventory flag provider refuses after the scene change was accepted */
    world_init(&w);
    w.close_flag = 0;
    w.refuse_open = 1;
    m = kernel_model(&w, &inv);
    kernel_host(&w, &h);
    CHECK(action7d_visit(&m, &h, &r, &why) == ACTION7D_ERR_HOST && strcmp(w.order, "CO") == 0);

    /* argument checks */
    world_init(&w);
    m = kernel_model(&w, &inv);
    kernel_host(&w, &h);
    CHECK(action7d_visit(NULL, &h, &r, &why) == ACTION7D_ERR_ARGUMENT);
    CHECK(action7d_visit(&m, NULL, &r, &why) == ACTION7D_ERR_ARGUMENT);
    CHECK(action7d_visit(&m, &h, NULL, &why) == ACTION7D_ERR_ARGUMENT);
    m.held_selector = NULL;
    CHECK(action7d_visit(&m, &h, &r, &why) == ACTION7D_ERR_ARGUMENT);
}

typedef struct {
    World w;
    SceneTransitionRequest request;
    int applied;
} BHost;

static int b_apply(void *c, const SceneStackPop *pop, const SceneTransitionRequest *request)
{
    BHost *b = (BHost *)c;
    ++b->applied;
    b->w.pop = *pop;
    b->request = *request;
    return b->w.refuse_change;
}

static int b_open(void *c)
{
    return open_inv(&((BHost *)c)->w);
}

static int b_rebuild(void *c, int16_t item)
{
    return rebuild(&((BHost *)c)->w, item);
}

static int b_ui(void *c, int16_t i, int32_t e, int16_t s)
{
    return ui(&((BHost *)c)->w, i, e, s);
}

static SceneActionInfo row(uint8_t subtype, const uint8_t *body, size_t length)
{
    SceneActionInfo info;
    memset(&info, 0, sizeof info);
    info.type = SESSION_A7D_TYPE;
    info.subtype = subtype;
    info.typed_body = body;
    info.typed_body_length = length;
    return info;
}

static void binding_dispositions_and_request(void)
{
    BHost b;
    SessionA7DHost host;
    Action78Model inv;
    SessionA7DBinding *bind;
    const uint8_t body[1] = {0};
    SceneActionInfo info;
    SceneActionRuntimeState before = {0u, 9u};
    SceneActionHandlerResult out;
    unsigned subtype;
    memset(&b, 0, sizeof b);
    world_init(&b.w);
    b.w.close_flag = 0;
    memset(&host, 0, sizeof host);
    host.context = &b;
    host.apply = b_apply;
    host.open_inventory = b_open;
    host.rebuild_view = b_rebuild;
    host.request_ui_animation = b_ui;
    inv = model_of(&b.w);
    bind = session_a7d_create(&host, &b.w.slot, &b.w.selector, &inv, &b.w.close_flag);
    CHECK(bind != NULL);
    for (subtype = 0; subtype < 5u; ++subtype) {
        b.w.slot = sample_slot();
        b.w.selector = (int16_t)(subtype == 3u ? 20 : -1);
        memset(&out, 0, sizeof out);
        info = row((uint8_t)subtype, body, 1u);
        CHECK(session_a7d_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_OK);
        CHECK(out.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED && out.phase == 9u); /* subtype never consulted */
    }
    CHECK(session_a7d_visits(bind) == 5ul);
    CHECK(b.request.target_scene == 4710 && b.request.opaque_words[0] == 11 && b.request.opaque_words[1] == -12 &&
          b.request.opaque_words[2] == 1);
    CHECK(b.request.opaque_dwords[0] == 0x01020304 && b.request.opaque_dwords[1] == 0x0a0b0c0d && b.request.opaque_dwords[2] == 0x7a7b7c7d);
    CHECK(session_a7d_last_result(bind).completed == 1u && b.w.selector == -1);
    CHECK(b.w.count == 1 && b.w.items[0] == 20); /* subtype 3 carried an item along */

    /* the body byte is never read: any value runs the same */
    {
        const uint8_t other[1] = {0xff};
        b.w.slot = sample_slot();
        info = row(1u, other, 1u);
        CHECK(session_a7d_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_OK);
    }
    /* the view mode and flag are read at every visit: the item-last layout (mode 2 with the flag set) */
    b.w.slot = sample_slot();
    b.w.selector = 21;
    b.w.count = 1;
    b.w.items[0] = 7;
    inv.view.mode = 2;
    inv.view.slot_flag = 1;
    info = row(1u, body, 1u);
    CHECK(session_a7d_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_OK);
    CHECK(b.w.count == 2 && b.w.items[0] == 7 && b.w.items[1] == 21);
    /* body length and type are checked (with a record to pop: an empty one would be an error anyway) */
    b.w.slot = sample_slot();
    info = row(1u, body, 2u);
    CHECK(session_a7d_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    info = row(1u, body, 0u);
    CHECK(session_a7d_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    info = row(1u, body, 1u);
    info.type = 0x7c;
    CHECK(session_a7d_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    session_a7d_destroy(bind);
}

static void binding_failures(void)
{
    BHost b;
    SessionA7DHost host;
    Action78Model inv;
    SessionA7DBinding *bind;
    const uint8_t body[1] = {0};
    SceneActionInfo info = row(1u, body, 1u);
    SceneActionRuntimeState before = {0u, 3u};
    SceneActionHandlerResult out;
    int applied;

    memset(&b, 0, sizeof b);
    world_init(&b.w);
    memset(&host, 0, sizeof host);
    host.context = &b;
    host.apply = b_apply;
    host.open_inventory = b_open;
    host.rebuild_view = b_rebuild;
    host.request_ui_animation = b_ui;
    inv = model_of(&b.w);
    CHECK(session_a7d_create(NULL, &b.w.slot, &b.w.selector, &inv, &b.w.close_flag) == NULL);
    CHECK(session_a7d_create(&host, NULL, &b.w.selector, &inv, &b.w.close_flag) == NULL);
    CHECK(session_a7d_create(&host, &b.w.slot, NULL, &inv, &b.w.close_flag) == NULL);
    CHECK(session_a7d_create(&host, &b.w.slot, &b.w.selector, NULL, &b.w.close_flag) == NULL);
    CHECK(session_a7d_create(&host, &b.w.slot, &b.w.selector, &inv, NULL) == NULL);
    bind = session_a7d_create(&host, &b.w.slot, &b.w.selector, &inv, &b.w.close_flag);
    CHECK(bind != NULL);

    /* the empty record is an error before any effect */
    b.w.slot.marker_5c3a1b = 0x270f;
    CHECK(session_a7d_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR && b.applied == 0);
    CHECK(strstr(session_a7d_failure(bind), "empty") != NULL);
    /* the host refuses: error, the record is kept */
    b.w.slot = sample_slot();
    b.w.refuse_change = 1;
    CHECK(session_a7d_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR && b.applied == 1);
    CHECK(b.w.slot.marker_5c3a1b == 4700 && session_a7d_visits(bind) == 0ul);
    b.w.refuse_change = 0;
    /* no scene-change provider: unsupported, nothing happens */
    session_a7d_destroy(bind);
    host.apply = NULL;
    bind = session_a7d_create(&host, &b.w.slot, &b.w.selector, &inv, &b.w.close_flag);
    applied = b.applied;
    CHECK(session_a7d_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_UNSUPPORTED && b.applied == applied);
    CHECK(b.w.slot.marker_5c3a1b == 4700);
    /* the item path needs the two providers; the open path needs its own */
    host.apply = b_apply;
    host.rebuild_view = NULL;
    session_a7d_destroy(bind);
    bind = session_a7d_create(&host, &b.w.slot, &b.w.selector, &inv, &b.w.close_flag);
    b.w.selector = 12;
    CHECK(session_a7d_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_UNSUPPORTED && b.w.count == 0);
    host.rebuild_view = b_rebuild;
    host.open_inventory = NULL;
    session_a7d_destroy(bind);
    bind = session_a7d_create(&host, &b.w.slot, &b.w.selector, &inv, &b.w.close_flag);
    b.w.close_flag = 0;
    b.w.selector = -1;
    CHECK(session_a7d_handler(bind, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_UNSUPPORTED && b.w.slot.marker_5c3a1b == 4700);
    CHECK(session_a7d_handler(NULL, 0u, &info, &before, &out) == SCENE_ACTION_HANDLER_ERROR);
    session_a7d_destroy(bind);
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
    run("pop_reads_the_record", pop_reads_the_record, &failures);
    run("pop_sign_extends_and_start_flag", pop_sign_extends_and_start_flag, &failures);
    run("pop_of_an_empty_record_carries_on", pop_of_an_empty_record_carries_on, &failures);
    run("save_then_pop_round_trip", save_then_pop_round_trip, &failures);
    run("visit_without_an_item", visit_without_an_item, &failures);
    run("visit_re_adds_the_item", visit_re_adds_the_item, &failures);
    run("visit_with_a_duplicate_item", visit_with_a_duplicate_item, &failures);
    run("visit_item_zero_is_an_item", visit_item_zero_is_an_item, &failures);
    run("visit_failures", visit_failures, &failures);
    run("binding_dispositions_and_request", binding_dispositions_and_request, &failures);
    run("binding_failures", binding_failures, &failures);
    return failures;
}
