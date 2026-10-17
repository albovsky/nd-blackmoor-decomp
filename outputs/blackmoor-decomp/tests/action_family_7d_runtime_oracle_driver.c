/* RT-41 native side of the raw 0x7d oracle (tests/action_family_7d_runtime_original_oracle.py).
 *
 * One handle owns the second saved-scene record, the selector word 0x583f1d, the inventory arrays of the add step, the view
 * bytes it reads and the real session binding. a7do_visit() performs what the executor does for a true gate: it calls the
 * binding handler and derives the row's completion byte, the dependency reset request and the phase from the returned
 * disposition with the executor's own helper (action_core_finish_action, scene_executor.c apply_external_handler). The host
 * callbacks log their calls in order (R view rebuild with a snapshot of the inventory, U UI request, C scene change, O
 * inventory flag). The record crosses the boundary as the 22 bytes at 0x5c3a1b..0x5c3a30 in the original's memory order. */
#include <stdlib.h>
#include <string.h>

#include "action_core.h"
#include "session_bindings_a7d.h"

#define CAP 70

typedef struct {
    SceneRestoreSlot slot;
    SceneStackCurrent current;
    int16_t selector;
    int16_t held, count;
    uint16_t items[CAP];
    int32_t presence[CAP];
    uint8_t close_flag;
    Action78Model inventory;
    int refuse_change;
    int applies, opens;
    SceneStackPop last_pop;
    SceneTransitionRequest last_request;
    char events[16];
    /* snapshot at the (last) rebuild call */
    int rebuilds;
    int16_t snap_item, snap_count;
    uint16_t snap_items[CAP];
    int32_t snap_presence[CAP];
    int16_t snap_held;
    int ui_calls;
    int16_t ui_index;
    int32_t ui_enable;
    int16_t ui_sub;
    SessionA7DBinding *bind;
} Handle;

static void note(Handle *h, char c)
{
    size_t n = strlen(h->events);
    if (n + 1 < sizeof h->events) {
        h->events[n] = c;
        h->events[n + 1] = '\0';
    }
}

static int apply(void *context, const SceneStackPop *pop, const SceneTransitionRequest *request)
{
    Handle *h = (Handle *)context;
    ++h->applies;
    note(h, 'C');
    h->last_pop = *pop;
    h->last_request = *request;
    return h->refuse_change;
}

static int open_inventory(void *context)
{
    Handle *h = (Handle *)context;
    ++h->opens;
    note(h, 'O');
    return 0;
}

static int rebuild(void *context, int16_t item)
{
    Handle *h = (Handle *)context;
    ++h->rebuilds;
    note(h, 'R');
    h->snap_item = item;
    h->snap_count = h->count;
    h->snap_held = h->held;
    memcpy(h->snap_items, h->items, sizeof h->items);
    memcpy(h->snap_presence, h->presence, sizeof h->presence);
    return 0;
}

static int request_ui(void *context, int16_t index, int32_t enable, int16_t sub)
{
    Handle *h = (Handle *)context;
    ++h->ui_calls;
    note(h, 'U');
    h->ui_index = index;
    h->ui_enable = enable;
    h->ui_sub = sub;
    return 0;
}

Handle *a7do_new(void)
{
    SessionA7DHost host;
    Handle *h = calloc(1u, sizeof(*h));
    if (h == NULL) return NULL;
    h->selector = -1;
    h->held = -1;
    h->inventory.inventory.held_item = &h->held;
    h->inventory.inventory.item_count = &h->count;
    h->inventory.inventory.items = h->items;
    h->inventory.inventory.item_capacity = CAP;
    h->inventory.inventory.presence = h->presence;
    h->inventory.inventory.presence_capacity = CAP;
    memset(&host, 0, sizeof host);
    host.context = h;
    host.apply = apply;
    host.open_inventory = open_inventory;
    host.rebuild_view = rebuild;
    host.request_ui_animation = request_ui;
    h->bind = session_a7d_create(&host, &h->slot, &h->selector, &h->inventory, &h->close_flag);
    if (h->bind == NULL) {
        free(h);
        return NULL;
    }
    return h;
}

void a7do_free(Handle *h)
{
    if (h != NULL) {
        session_a7d_destroy(h->bind);
        free(h);
    }
}

void a7do_set_current(Handle *h, int32_t s57b, int32_t s57f, int w50b, int w593, int32_t d5a7, int32_t d5ab, int32_t d5af)
{
    h->current.scene_5bb57b = s57b;
    h->current.scene_5bb57f = s57f;
    h->current.word_5bb50b = (int16_t)w50b;
    h->current.word_5bb593 = (int16_t)w593;
    h->current.dword_5bb5a7 = d5a7;
    h->current.dword_5bb5ab = d5ab;
    h->current.dword_5bb5af = d5af;
}

void a7do_set_refuse(Handle *h, int refuse) { h->refuse_change = refuse; }
int a7do_applies(const Handle *h) { return h->applies; }
int a7do_opens(const Handle *h) { return h->opens; }

void a7do_get_slot(const Handle *h, uint8_t out[22])
{
    const SceneRestoreSlot *s = &h->slot;
    memcpy(out + 0, &s->marker_5c3a1b, 2);
    memcpy(out + 2, &s->scene_5c3a1d, 2);
    memcpy(out + 4, &s->word_5c3a1f, 2);
    memcpy(out + 6, &s->word_5c3a21, 2);
    memcpy(out + 8, &s->word_5c3a23, 2);
    memcpy(out + 10, &s->dword_5c3a25, 4);
    memcpy(out + 14, &s->dword_5c3a29, 4);
    memcpy(out + 18, &s->dword_5c3a2d, 4);
}

void a7do_set_slot(Handle *h, const uint8_t in[22])
{
    SceneRestoreSlot *s = &h->slot;
    memcpy(&s->marker_5c3a1b, in + 0, 2);
    memcpy(&s->scene_5c3a1d, in + 2, 2);
    memcpy(&s->word_5c3a1f, in + 4, 2);
    memcpy(&s->word_5c3a21, in + 6, 2);
    memcpy(&s->word_5c3a23, in + 8, 2);
    memcpy(&s->dword_5c3a25, in + 10, 4);
    memcpy(&s->dword_5c3a29, in + 14, 4);
    memcpy(&s->dword_5c3a2d, in + 18, 4);
}

/* selector 0x583f1d, held 0x583a29, count 0x583a2b, list 0x583a31 (70 words), presence 0x583bd5 (70 dwords), view mode
 * +0x764c, view byte +0x7010, close flag +0x7011. */
void a7do_set_world(Handle *h, int selector, int held, int count, const uint16_t *items, const int32_t *presence, int32_t mode,
                    int slot_flag, int close_flag)
{
    h->selector = (int16_t)selector;
    h->held = (int16_t)held;
    h->count = (int16_t)count;
    memcpy(h->items, items, sizeof h->items);
    memcpy(h->presence, presence, sizeof h->presence);
    h->inventory.view.mode = mode;
    h->inventory.view.slot_flag = (uint8_t)slot_flag;
    h->close_flag = (uint8_t)close_flag;
}

void a7do_get_world(const Handle *h, int16_t out_words[3], uint16_t *items, int32_t *presence)
{
    out_words[0] = h->selector;
    out_words[1] = h->held;
    out_words[2] = h->count;
    memcpy(items, h->items, sizeof h->items);
    memcpy(presence, h->presence, sizeof h->presence);
}

void a7do_clear_events(Handle *h)
{
    h->events[0] = '\0';
    h->rebuilds = 0;
    h->ui_calls = 0;
}

void a7do_get_events(const Handle *h, char out[16]) { memcpy(out, h->events, 16); }

void a7do_get_snapshot(const Handle *h, int16_t out_words[3], uint16_t *items, int32_t *presence)
{
    out_words[0] = h->snap_item;
    out_words[1] = h->snap_count;
    out_words[2] = h->snap_held;
    memcpy(items, h->snap_items, sizeof h->snap_items);
    memcpy(presence, h->snap_presence, sizeof h->snap_presence);
}

int a7do_rebuilds(const Handle *h) { return h->rebuilds; }
int a7do_ui_calls(const Handle *h) { return h->ui_calls; }

void a7do_get_ui(const Handle *h, int32_t out[3])
{
    out[0] = h->ui_index;
    out[1] = h->ui_enable;
    out[2] = h->ui_sub;
}

static void put_pop(const SceneStackPop *p, int32_t out[10])
{
    out[0] = p->scene_5bb57b;
    out[1] = p->scene_5bb57f;
    out[2] = p->word_5bb599;
    out[3] = p->word_5bb595;
    out[4] = p->word_5c39ff;
    out[5] = p->dword_5bb59b;
    out[6] = p->dword_5bb59f;
    out[7] = p->dword_5bb5a3;
    out[8] = p->start_5bb1ca;
    out[9] = p->mode_583999;
}

void a7do_get_pop(const Handle *h, int32_t out[10]) { put_pop(&h->last_pop, out); }

void a7do_get_request(const Handle *h, int32_t out[7])
{
    out[0] = h->last_request.target_scene;
    out[1] = h->last_request.opaque_words[0];
    out[2] = h->last_request.opaque_words[1];
    out[3] = h->last_request.opaque_words[2];
    out[4] = h->last_request.opaque_dwords[0];
    out[5] = h->last_request.opaque_dwords[1];
    out[6] = h->last_request.opaque_dwords[2];
}

/* scene_restore_slot_pop on the handle's slot (direct, no binding): returns SCENE_RESTORE_POP_*, fills out for OK and EMPTY. */
int a7do_pop_direct(Handle *h, int32_t out[10])
{
    SceneStackPop p;
    int rc = scene_restore_slot_pop(&h->slot, &p);
    if (rc == SCENE_RESTORE_POP_OK || rc == SCENE_RESTORE_POP_EMPTY) put_pop(&p, out);
    return rc;
}

void a7do_save_direct(Handle *h, int32_t argument) { scene_restore_slot_save(&h->slot, &h->current, argument); }
void a7do_init_words(Handle *h) { scene_restore_slot_init_words(&h->slot); }

/* Returns the handler status (SCENE_ACTION_HANDLER_*) or 100 + the executor-side failure. */
int a7do_visit(Handle *h, int subtype, int completed_before, uint32_t phase_before, int *completed_after, int *reset,
               uint32_t *phase_after, int *disposition)
{
    static const uint8_t body[1] = {0u};
    SceneActionInfo info;
    SceneActionRuntimeState before;
    SceneActionHandlerResult out;
    ActionCoreActionResult finish;
    int status;
    memset(&info, 0, sizeof(info));
    info.type = SESSION_A7D_TYPE;
    info.subtype = (uint8_t)subtype;
    info.typed_body = body;
    info.typed_body_length = 1u;
    before.completed = (uint8_t)completed_before;
    before.phase = phase_before;
    out.disposition = SCENE_ACTION_HANDLER_PENDING;
    out.phase = phase_before;
    *completed_after = completed_before;
    *reset = 0;
    *phase_after = phase_before;
    status = session_a7d_handler(h->bind, 0u, &info, &before, &out);
    *disposition = (int)out.disposition;
    if (status != SCENE_ACTION_HANDLER_OK) return status;
    /* scene_executor.c apply_external_handler */
    switch (out.disposition) {
    case SCENE_ACTION_HANDLER_PENDING:
        *phase_after = out.phase;
        break;
    case SCENE_ACTION_HANDLER_COMPLETED:
        if (action_core_finish_action((uint8_t)subtype, (uint8_t)completed_before, &finish) != ACTION_CORE_OK)
            return 101;
        *completed_after = finish.completed;
        *reset = finish.reset_dependencies;
        *phase_after = out.phase;
        break;
    case SCENE_ACTION_HANDLER_DIRECT_COMPLETED:
        *completed_after = 1;
        *phase_after = out.phase;
        break;
    case SCENE_ACTION_HANDLER_RESET_DEPENDENCIES:
        *phase_after = 0u;
        *reset = 1;
        break;
    default:
        return 102;
    }
    return 0;
}
