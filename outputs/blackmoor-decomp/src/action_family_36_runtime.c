#include "action_family_36_runtime.h"

#include <math.h>
#include <string.h>

static const char NO_SOUND[9] = {'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', '\0'};
static const char AUTOTEXT[3][14] = {
    "USE_AUTOTEXT1", "USE_AUTOTEXT2", "USE_AUTOTEXT3"};

static uint16_t rd16(const uint8_t *image, size_t offset)
{
    return (uint16_t)((uint16_t)image[offset] | ((uint16_t)image[offset + 1u] << 8));
}

static int16_t rds16(const uint8_t *image, size_t offset)
{
    const uint16_t bits = rd16(image, offset);
    return bits <= (uint16_t)INT16_MAX ? (int16_t)bits
                                       : (int16_t)(-1 - (int32_t)(UINT16_MAX - bits));
}

static uint32_t rd32(const uint8_t *image, size_t offset)
{
    return (uint32_t)image[offset] | ((uint32_t)image[offset + 1u] << 8) |
           ((uint32_t)image[offset + 2u] << 16) | ((uint32_t)image[offset + 3u] << 24);
}

static int32_t rds32(const uint8_t *image, size_t offset)
{
    const uint32_t bits = rd32(image, offset);
    return bits <= (uint32_t)INT32_MAX ? (int32_t)bits
                                       : (int32_t)(-1 - (int32_t)(UINT32_MAX - bits));
}

static void wr16(uint8_t *image, size_t offset, uint16_t value)
{
    image[offset] = (uint8_t)value;
    image[offset + 1u] = (uint8_t)(value >> 8);
}

static void wr32(uint8_t *image, size_t offset, uint32_t value)
{
    image[offset] = (uint8_t)value;
    image[offset + 1u] = (uint8_t)(value >> 8);
    image[offset + 2u] = (uint8_t)(value >> 16);
    image[offset + 3u] = (uint8_t)(value >> 24);
}

static void fx(const Overlay36Host *host, int effect, int32_t a, int32_t b)
{
    if (host != NULL && host->observe != NULL) {
        host->observe(host->context, effect, a, b);
    }
}

static int reject(const char **why, const char *message, int status)
{
    if (why != NULL) {
        *why = message;
    }
    return status;
}

void overlay36_manager_reset(Overlay36Manager *manager)
{
    int i;
    if (manager == NULL) {
        return;
    }
    memset(manager, 0, sizeof(*manager));
    manager->current_row = -1;
    manager->current_record = -1;
    for (i = 0; i < OVERLAY36_SLOTS; ++i) {
        manager->render[i].row = -1;
    }
}

static uint8_t *image_of(const Overlay36Rows *rows, int32_t row)
{
    if (rows == NULL || rows->images == NULL || row < 0 || (size_t)row >= rows->count) {
        return NULL;
    }
    return rows->images[row];
}

/* Number of primary records the A-36.1 constructor copied: signed word
 * (+0x35 - +0x33 + 1) narrowed to 16 bits when the marker is 2, else +0x2b. */
static int32_t primary_count(const uint8_t *image)
{
    if (rds16(image, OV36_MARKER) == 2) {
        const int32_t difference = (int32_t)rds16(image, OV36_FRAME_LAST) -
                                   (int32_t)rds16(image, OV36_FRAME_FIRST) + 1;
        const uint16_t narrowed = (uint16_t)(uint32_t)difference;
        return narrowed <= (uint16_t)INT16_MAX
                   ? (int32_t)narrowed
                   : -1 - (int32_t)(UINT16_MAX - narrowed);
    }
    return rds16(image, OV36_PRIMARY_COUNT);
}

static int name_terminated(const uint8_t *image)
{
    return memchr(image + OV36_NAME, 0, OVERLAY36_NAME_BYTES) != NULL;
}

static char upper(char c)
{
    /* 0x50d0bc in the C locale ([0x63cb1c] == 0): 'a'..'z' only. */
    return (c >= 'a' && c <= 'z') ? (char)(c - 0x20) : c;
}

static int names_equal_ignore_case(const uint8_t *a, const uint8_t *b)
{
    size_t i;
    for (i = 0; i < OVERLAY36_NAME_BYTES; ++i) {
        const char ca = upper((char)a[OV36_NAME + i]);
        const char cb = upper((char)b[OV36_NAME + i]);
        if (ca != cb) {
            return 0;
        }
        if (ca == '\0') {
            return 1;
        }
    }
    return 0; /* callers guarantee a terminator inside the field */
}

static int sound_named(const uint8_t *image)
{
    return memcmp(image + OV36_SOUND, NO_SOUND, sizeof(NO_SOUND)) != 0;
}

/* 0x50ce04 is the CRT float-to-integer helper: FISTP to a 64-bit integer with
 * truncation, EAX = low dword. Values outside +-2^63, infinities and NaN store
 * the "integer indefinite" 0x8000000000000000, whose low dword is zero; finite
 * values beyond 32 bits wrap to their low 32 bits. */
static int32_t ftol(double value)
{
    int64_t whole;
    if (!(value > -9223372036854775809.0 && value < 9223372036854775808.0)) {
        return 0;
    }
    whole = (int64_t)value;
    return (int32_t)(uint32_t)((uint64_t)whole & UINT32_MAX);
}

typedef struct {
    int mode;           /* 0 cache reuse, 1 autotext, 2 load */
    int cache_slot;
    uint32_t surface;
    int autotext;
} SurfacePlan;

static int plan_surface(const Overlay36Manager *manager, const Overlay36Rows *rows,
                        const uint8_t *image, const Overlay36World *world,
                        SurfacePlan *plan, const char **why)
{
    int slot, k, free_cache = -1;
    memset(plan, 0, sizeof(*plan));
    plan->cache_slot = -1;
    for (slot = OVERLAY36_FIRST_SLOT; slot < OVERLAY36_SLOTS; ++slot) {
        const Overlay36Render *entry = &manager->render[slot];
        const uint8_t *other;
        if (entry->active == 0) {
            continue;
        }
        if (memcmp(entry->tag, OVERLAY36_TAG, sizeof(OVERLAY36_TAG)) != 0) {
            continue;
        }
        other = image_of(rows, entry->row);
        if (other == NULL || !name_terminated(other)) {
            return reject(why, "registered overlay render entry without a terminated image name",
                          OVERLAY36_ERR_BOUNDS);
        }
        if (!names_equal_ignore_case(image, other)) {
            continue;
        }
        for (k = 0; k < OVERLAY36_CACHE_SLOTS; ++k) {
            if (manager->cache[k] != 0u && manager->cache[k] == entry->surface) {
                plan->mode = 0;
                plan->cache_slot = k;
                plan->surface = manager->cache[k];
                return OVERLAY36_OK;
            }
        }
    }
    for (k = 0; k < 3; ++k) {
        if (memcmp(image + OV36_NAME, AUTOTEXT[k], sizeof(AUTOTEXT[k])) == 0) {
            plan->mode = 1;
            plan->autotext = k + 1;
            plan->surface = world->autotext_surface[k];
            return OVERLAY36_OK;
        }
    }
    for (k = 0; k < OVERLAY36_CACHE_SLOTS; ++k) {
        if (manager->cache[k] == 0u) {
            free_cache = k;
            break;
        }
    }
    if (free_cache < 0) {
        return reject(why, "surface cache exhausted (0x4c948f reports an error and tears down)",
                      OVERLAY36_ERR_BOUNDS);
    }
    plan->mode = 2;
    plan->cache_slot = free_cache;
    return OVERLAY36_OK;
}

static int event_index_ok(int16_t index, const Overlay36World *world)
{
    return index >= 0 && (size_t)index < world->event_count;
}

int overlay36_step(Overlay36Manager *manager, const Overlay36Rows *rows, int32_t row,
                   uint32_t phase, Overlay36World *world, const Overlay36Host *host,
                   Overlay36StepResult *result, const char **why)
{
    uint8_t *image;
    SurfacePlan plan;
    int free_slot = -1;
    int i;
    int status;
    int goto_phase2 = 0;

    if (why != NULL) {
        *why = "none";
    }
    if (manager == NULL || rows == NULL || world == NULL || host == NULL || result == NULL) {
        return reject(why, "invalid runtime arguments", OVERLAY36_ERR_ARGUMENT);
    }
    memset(result, 0, sizeof(*result));
    result->phase_after = phase;
    image = image_of(rows, row);
    if (image == NULL) {
        return reject(why, "row has no overlay image", OVERLAY36_ERR_ARGUMENT);
    }
    if (world->events == NULL && world->event_count != 0u) {
        return reject(why, "event array missing", OVERLAY36_ERR_ARGUMENT);
    }
    fx(host, OV36_FX_BEGIN, row, (int32_t)phase);
    if (phase > 2u) {
        /* 0x489a27: no case matches; only the scratch pointers were stored. */
        manager->current_row = row;
        return OVERLAY36_OK;
    }

    /* ---- validation: everything the visit could need, before any effect ---- */
    if (phase == 0u) {
        if (!name_terminated(image)) {
            return reject(why, "image name is not terminated inside its 33-byte field",
                          OVERLAY36_ERR_BOUNDS);
        }
        if (manager->count < 0 || manager->count >= OVERLAY36_LIST_LIMIT) {
            return reject(why, "overlay list is full (0x4899ca reports ActionCount and tears down)",
                          OVERLAY36_ERR_BOUNDS);
        }
        if (row < 0 || row > INT16_MAX) {
            return reject(why, "row outside the 16-bit row argument", OVERLAY36_ERR_BOUNDS);
        }
        for (i = OVERLAY36_FIRST_SLOT; i < OVERLAY36_SLOTS; ++i) {
            if (manager->render[i].active == 0) {
                free_slot = i;
                break;
            }
        }
        if (free_slot < 0) {
            return reject(why, "render table full (0x4d39f9 reports an error and tears down)",
                          OVERLAY36_ERR_BOUNDS);
        }
        status = plan_surface(manager, rows, image, world, &plan, why);
        if (status != OVERLAY36_OK) {
            return status;
        }
        if (plan.mode == 2 && host->load_surface == NULL) {
            return reject(why, "surface provider (0x4c2790)", OVERLAY36_ERR_UNSUPPORTED);
        }
        if (plan.mode == 1 && plan.surface == 0u) {
            /* RT-18: the surface globals 0x5d0397/9b/9f belong to the AUTOTEXT subsystem,
             * which the host has not provided: refuse instead of drawing from nothing. */
            return reject(why, "AUTOTEXT surface global (0x5d0397/0x5d039b/0x5d039f) is not provided",
                          OVERLAY36_ERR_UNSUPPORTED);
        }
    }
    if (phase <= 1u) {
        const int16_t event_index = rds16(image, OV36_EVENT_INDEX);
        if (event_index != -1 && !event_index_ok(event_index, world)) {
            return reject(why, "event index outside the modeled event array", OVERLAY36_ERR_BOUNDS);
        }
        if (rds16(image, OV36_MARKER) == 2) {
            const int16_t secondary = rds16(image, OV36_SECONDARY_COUNT);
            if (host->tick_count == NULL) {
                return reject(why, "GetTickCount provider", OVERLAY36_ERR_UNSUPPORTED);
            }
            if (secondary < 0 || secondary > 25) {
                return reject(why, "secondary record count outside the image table",
                              OVERLAY36_ERR_BOUNDS);
            }
        }
        if (sound_named(image)) {
            if ((phase == 0u && host->sound_start == NULL) || host->sound_is_playing == NULL) {
                return reject(why, "sound provider (0x4fb77a / 0x4f6334)",
                              OVERLAY36_ERR_UNSUPPORTED);
            }
        }
    }
    if (phase == 2u) {
        if (sound_named(image) && host->sound_stop == NULL) {
            return reject(why, "sound provider (0x4fba69)", OVERLAY36_ERR_UNSUPPORTED);
        }
        for (i = 0; i < OVERLAY36_EVENT_PAIRS; ++i) {
            const int16_t index = rds16(image, OV36_EVENT_PAIRS + 4u * (size_t)i);
            if (index != -1 && !event_index_ok(index, world)) {
                return reject(why, "event write index outside the modeled event array",
                              OVERLAY36_ERR_BOUNDS);
            }
        }
    }

    manager->current_row = row; /* 0x4899ca stores ECX+0x1c / +0x20 first */

    if (phase == 0u) {
        const int slot = free_slot;
        result->registered = 1u;
        wr16(image, OV36_RT_ROW, (uint16_t)(int16_t)row);
        wr16(image, OV36_RT_SLOT, 0xffffu);
        wr16(image, OV36_RT_CACHE, 0xffffu);
        wr32(image, OV36_RT_NEXT, 0u);
        wr16(image, OV36_RT_FRAME, 0u);
        wr32(image, OV36_RT_ENABLED, 1u);
        fx(host, OV36_FX_IMAGE_INIT, row, 0);
        manager->list[manager->count] = row;
        fx(host, OV36_FX_LIST_PUSH, manager->count, row);
        ++manager->count;
        if (sound_named(image)) {
            if (host->sound_start(host->context, image + OV36_SOUND,
                                  rd16(image, OV36_SOUND_WORD)) != 0) {
                return reject(why, "sound start failed", OVERLAY36_ERR_HOST);
            }
            fx(host, OV36_FX_SOUND_START, row, rd16(image, OV36_SOUND_WORD));
        }
        world->start_flag_5bb1ca = 1;
        fx(host, OV36_FX_START_FLAG, 1, 0);
        world->redraw_5831c8 = 1; /* 0x4d36ed */
        world->redraw_5831c6 = 0;
        fx(host, OV36_FX_REDRAW, 1, 0);
        fx(host, OV36_FX_REQUEST_CLEAR, row, 0);

        if (plan.mode == 0) {
            wr32(image, OV36_RT_SURFACE, plan.surface);
            wr16(image, OV36_RT_CACHE, (uint16_t)(int16_t)plan.cache_slot);
            fx(host, OV36_FX_CACHE_REUSE, plan.cache_slot, (int32_t)plan.surface);
        } else if (plan.mode == 1) {
            wr32(image, OV36_RT_SURFACE, plan.surface);
            fx(host, OV36_FX_AUTOTEXT, plan.autotext, (int32_t)plan.surface);
        } else {
            uint32_t surface = 0u;
            wr16(image, OV36_RT_CACHE, (uint16_t)(int16_t)plan.cache_slot);
            if (host->load_surface(host->context, (const char *)(image + OV36_NAME),
                                   &surface) != 0) {
                return reject(why, "surface load failed", OVERLAY36_ERR_HOST);
            }
            wr32(image, OV36_RT_SURFACE, surface);
            manager->cache[plan.cache_slot] = surface;
            fx(host, OV36_FX_SURFACE_LOAD, plan.cache_slot, (int32_t)surface);
        }
        wr16(image, OV36_RT_SLOT, (uint16_t)(int16_t)slot);
        fx(host, OV36_FX_SLOT, slot, 0);
        manager->render[slot].layer = rds16(image, OV36_LAYER);
        manager->render[slot].callback = 1;
        manager->render[slot].surface = rd32(image, OV36_RT_SURFACE);
        manager->render[slot].field_0c = 0;
        manager->render[slot].field_10 = 0;
        manager->render[slot].visible = 1;
        manager->render[slot].active = 1;
        manager->render[slot].row = row;
        memcpy(manager->render[slot].tag, OVERLAY36_TAG, sizeof(OVERLAY36_TAG));
        fx(host, OV36_FX_RENDER_STORE, slot, manager->render[slot].layer);
        if (rds16(image, OV36_MARKER) == 2) {
            uint32_t now = 0u;
            int32_t interval;
            const int16_t fps = rds16(image, OV36_FPS);
            wr16(image, OV36_RT_FRAME, rd16(image, OV36_FRAME_INIT));
            interval = ftol((1.0 / (double)(float)fps) * 1000.0);
            wr32(image, OV36_RT_INTERVAL, (uint32_t)interval);
            if (host->tick_count(host->context, &now) != 0) {
                return reject(why, "tick provider failed", OVERLAY36_ERR_HOST);
            }
            wr32(image, OV36_RT_NEXT, now + (uint32_t)interval);
            fx(host, OV36_FX_ANIM_INIT, interval, (int32_t)(now + (uint32_t)interval));
        }
        phase = 1u;
        result->phase_after = 1u;
        fx(host, OV36_FX_PHASE, 1, 0);
    }

    if (phase == 1u) {
        const int16_t event_index = rds16(image, OV36_EVENT_INDEX);
        if (event_index != -1 &&
            world->events[event_index] == (int32_t)rds16(image, OV36_EVENT_VALUE)) {
            goto_phase2 = 1;
        } else if (rds16(image, OV36_MARKER) == 2) {
            const int16_t frame = rds16(image, OV36_RT_FRAME);
            const int16_t direction = rds16(image, OV36_DIRECTION);
            const int16_t loop = rds16(image, OV36_LOOP);
            int at_end = 0;
            if (frame == rds16(image, OV36_FRAME_LAST) && direction == 1 && loop == 1) {
                at_end = 1;
            } else if (frame == rds16(image, OV36_FRAME_FIRST) && direction == 2 && loop == 1) {
                at_end = 1;
            }
            if (at_end) {
                if (!sound_named(image)) {
                    goto_phase2 = 1;
                } else {
                    int playing = 0;
                    if (host->sound_is_playing(host->context, rd16(image, OV36_SOUND_WORD),
                                               &playing) != 0) {
                        return reject(why, "sound query failed", OVERLAY36_ERR_HOST);
                    }
                    if (playing == 0) {
                        goto_phase2 = 1;
                    }
                }
            }
            if (!goto_phase2) {
                uint32_t now = 0u;
                const int16_t count = rds16(image, OV36_SECONDARY_COUNT);
                int16_t index;
                if (host->tick_count(host->context, &now) != 0) {
                    return reject(why, "tick provider failed", OVERLAY36_ERR_HOST);
                }
                manager->tick = now;
                for (index = 0; index < count; ++index) {
                    const uint8_t *record = image + OV36_SECONDARY + (size_t)index * 38u;
                    if (rds16(record, OV36_SEC_FRAME) != world->selector) {
                        continue;
                    }
                    if (manager->tick >= rd32(image, OV36_RT_NEXT)) {
                        int16_t next = rds16(image, OV36_RT_FRAME);
                        wr32(image, OV36_RT_NEXT, manager->tick + rd32(image, OV36_RT_INTERVAL));
                        if (direction == 1) {
                            next = (int16_t)(uint16_t)(next + 1);
                            if (next > rds16(image, OV36_FRAME_LAST)) {
                                next = (loop == 2) ? rds16(image, OV36_FRAME_FIRST)
                                                   : rds16(image, OV36_FRAME_LAST);
                            }
                        } else {
                            next = (int16_t)(uint16_t)(next - 1);
                            if (next < rds16(image, OV36_FRAME_FIRST)) {
                                next = (loop == 2) ? rds16(image, OV36_FRAME_LAST)
                                                   : rds16(image, OV36_FRAME_FIRST);
                            }
                        }
                        wr16(image, OV36_RT_FRAME, (uint16_t)next);
                        fx(host, OV36_FX_ANIM_STEP, next, (int32_t)rd32(image, OV36_RT_NEXT));
                    }
                    break;
                }
            }
        }
        if (goto_phase2) {
            result->phase_after = 2u;
            fx(host, OV36_FX_PHASE, 2, 0);
        }
        return OVERLAY36_OK;
    }

    /* phase == 2: 0x48a27e */
    if (sound_named(image)) {
        if (host->sound_stop(host->context, image + OV36_SOUND) != 0) {
            return reject(why, "sound stop failed", OVERLAY36_ERR_HOST);
        }
        fx(host, OV36_FX_SOUND_STOP, row, 0);
    }
    for (i = 0; i < OVERLAY36_EVENT_PAIRS; ++i) {
        const int16_t index = rds16(image, OV36_EVENT_PAIRS + 4u * (size_t)i);
        if (index != -1) {
            const int16_t value = rds16(image, OV36_EVENT_PAIRS + 4u * (size_t)i + 2u);
            world->events[index] = (int32_t)value;
            fx(host, OV36_FX_EVENT_WRITE, index, value);
        }
    }
    if (rds16(image, OV36_ACTION_25) == 1) {
        world->xfer_5bb57b = rds16(image, OV36_XFER_3D);
        world->xfer_5bb599 = rds16(image, OV36_XFER_3F);
        world->xfer_5bb595 = rds16(image, OV36_XFER_41);
        world->xfer_5c39ff = rds16(image, OV36_XFER_43);
        world->xfer_5bb59b = rds32(image, OV36_XFER_45);
        world->xfer_5bb59f = rds32(image, OV36_XFER_49);
        world->xfer_5bb5a3 = rds32(image, OV36_XFER_4D);
        world->mode_583999 = 4;
        fx(host, OV36_FX_TRANSFER, world->xfer_5bb57b, 0);
    }
    world->start_flag_5bb1ca = rds16(image, OV36_FLAG_21) == 1 ? 0 : 1;
    fx(host, OV36_FX_START_FLAG, world->start_flag_5bb1ca, 0);
    world->redraw_5831c8 = 1;
    world->redraw_5831c6 = 0;
    fx(host, OV36_FX_REDRAW, 1, 0);
    fx(host, OV36_FX_FINISH, row, 0);
    result->finished = 1u;
    result->phase_after = 0u;
    return OVERLAY36_OK;
}

int overlay36_hit_test(Overlay36Manager *manager, const Overlay36Rows *rows,
                       int16_t x, int16_t y, Overlay36World *world,
                       const Overlay36Host *host, int *hit, int32_t *row_out,
                       const char **why)
{
    int32_t i;
    if (why != NULL) {
        *why = "none";
    }
    if (manager == NULL || rows == NULL || world == NULL || host == NULL ||
        host->row_phase == NULL || hit == NULL || row_out == NULL) {
        return reject(why, "invalid hit-test arguments", OVERLAY36_ERR_ARGUMENT);
    }
    *hit = 0;
    *row_out = -1;
    if (manager->count == 0) {
        return OVERLAY36_OK;
    }
    if (manager->count < 0 || manager->count > OVERLAY36_LIST_LIMIT) {
        return reject(why, "overlay list count outside the table", OVERLAY36_ERR_BOUNDS);
    }
    /* Validate the whole walk first: nothing may change on a rejection. */
    for (i = 0; i < manager->count; ++i) {
        const uint8_t *image = image_of(rows, manager->list[i]);
        int16_t secondary;
        if (image == NULL) {
            return reject(why, "overlay list entry without an image", OVERLAY36_ERR_BOUNDS);
        }
        secondary = rds16(image, OV36_SECONDARY_COUNT);
        if (rd32(image, OV36_RT_ENABLED) != 0u &&
            (secondary < 0 || secondary > 25 ||
             image_of(rows, rds16(image, OV36_RT_ROW)) == NULL)) {
            return reject(why, "overlay runtime fields outside the image tables",
                          OVERLAY36_ERR_BOUNDS);
        }
    }
    for (i = 0; i < manager->count; ++i) {
        const uint8_t *image = image_of(rows, manager->list[i]);
        const int32_t owner = rds16(image, OV36_RT_ROW);
        uint32_t phase = 0u;
        int16_t record_index;
        const int16_t secondary = rds16(image, OV36_SECONDARY_COUNT);
        manager->current_row = manager->list[i];
        if (rd32(image, OV36_RT_ENABLED) == 0u) {
            continue;
        }
        if (host->row_phase(host->context, owner, &phase) != 0) {
            return reject(why, "row phase provider failed", OVERLAY36_ERR_HOST);
        }
        if (phase != 1u) {
            continue;
        }
        for (record_index = 0; record_index < secondary; ++record_index) {
            const uint8_t *record = image + OV36_SECONDARY + (size_t)record_index * 38u;
            manager->current_record = record_index;
            if (rds16(record, OV36_SEC_FRAME) != world->selector ||
                rds16(record, OV36_SEC_HOT) != 1) {
                continue;
            }
            if ((int32_t)y < rds32(record, OV36_SEC_DST_TOP) ||
                (int32_t)y > rds32(record, OV36_SEC_DST_BOTTOM) ||
                (int32_t)x < rds32(record, OV36_SEC_DST_LEFT) ||
                (int32_t)x > rds32(record, OV36_SEC_DST_RIGHT)) {
                continue;
            }
            if (world->held_item != -1 && world->item_flag_5b44f8 == 0) {
                world->cursor_index_5b44f0 = (int32_t)world->held_item + 0x25;
                world->cursor_surface_5d162d = world->cursor_surface_held_571ad3;
            } else if (world->held_item == -1 && world->item_flag_5b44f8 == 0) {
                world->cursor_index_5b44f0 = 0;
                world->cursor_surface_5d162d = world->cursor_surface_default_5d0377;
            }
            world->cursor_variant_5b44f4 = 1;
            world->cursor_table_5d1631 = (int32_t)(((uint32_t)world->cursor_index_5b44f0 << 5) +
                                                   ((uint32_t)world->cursor_variant_5b44f4 << 4) +
                                                   0x5b160cu);
            world->cursor_layer_5d1639 = 1;
            world->candidate_5c39e5 = owner;
            *hit = 1;
            *row_out = owner;
            fx(host, OV36_FX_HIT, owner, record_index);
            fx(host, OV36_FX_CURSOR, world->cursor_index_5b44f0, world->cursor_variant_5b44f4);
            return OVERLAY36_OK;
        }
    }
    return OVERLAY36_OK;
}

int overlay36_hot_rects(const Overlay36Manager *manager, const Overlay36Rows *rows,
                        int16_t selector, const Overlay36Host *host,
                        Overlay36HotRect *out, size_t capacity, size_t *count)
{
    int32_t i;
    size_t used = 0u;
    if (manager == NULL || rows == NULL || host == NULL || host->row_phase == NULL ||
        count == NULL || (capacity != 0u && out == NULL)) {
        return OVERLAY36_ERR_ARGUMENT;
    }
    *count = 0u;
    if (manager->count < 0 || manager->count > OVERLAY36_LIST_LIMIT) {
        return OVERLAY36_ERR_BOUNDS;
    }
    for (i = 0; i < manager->count; ++i) {
        const uint8_t *image = image_of(rows, manager->list[i]);
        uint32_t phase = 0u;
        int16_t secondary, record_index;
        int32_t owner;
        if (image == NULL) {
            return OVERLAY36_ERR_BOUNDS;
        }
        if (rd32(image, OV36_RT_ENABLED) == 0u) {
            continue;
        }
        owner = rds16(image, OV36_RT_ROW);
        secondary = rds16(image, OV36_SECONDARY_COUNT);
        if (secondary < 0 || secondary > 25 || image_of(rows, owner) == NULL) {
            return OVERLAY36_ERR_BOUNDS;
        }
        if (host->row_phase(host->context, owner, &phase) != 0) {
            return OVERLAY36_ERR_HOST;
        }
        if (phase != 1u) {
            continue;
        }
        for (record_index = 0; record_index < secondary; ++record_index) {
            const uint8_t *record = image + OV36_SECONDARY + (size_t)record_index * 38u;
            if (rds16(record, OV36_SEC_FRAME) != selector ||
                rds16(record, OV36_SEC_HOT) != 1) {
                continue;
            }
            if (used < capacity) {
                out[used].row = owner;
                out[used].record = record_index;
                out[used].left = rds32(record, OV36_SEC_DST_LEFT);
                out[used].top = rds32(record, OV36_SEC_DST_TOP);
                out[used].right = rds32(record, OV36_SEC_DST_RIGHT);
                out[used].bottom = rds32(record, OV36_SEC_DST_BOTTOM);
            }
            ++used;
        }
    }
    *count = used;
    return used > capacity ? OVERLAY36_ERR_BOUNDS : OVERLAY36_OK;
}

static int32_t add32(int32_t a, int32_t b)
{
    return (int32_t)((uint32_t)a + (uint32_t)b);
}

int overlay36_draw_slot(Overlay36Manager *manager, const Overlay36Rows *rows, int slot,
                        const Overlay36World *world, const Overlay36Host *host,
                        const char **why)
{
    const uint8_t *image;
    int16_t count, index;
    int32_t primary_limit;
    if (why != NULL) {
        *why = "none";
    }
    if (manager == NULL || rows == NULL || world == NULL || host == NULL ||
        slot < 0 || slot >= OVERLAY36_SLOTS) {
        return reject(why, "invalid draw arguments", OVERLAY36_ERR_ARGUMENT);
    }
    if (host->blit == NULL) {
        return reject(why, "blit provider (0x4c5377 / 0x4c5d4b)", OVERLAY36_ERR_UNSUPPORTED);
    }
    image = image_of(rows, manager->render[slot].row);
    if (image == NULL) {
        return reject(why, "render entry without an overlay image", OVERLAY36_ERR_BOUNDS);
    }
    if ((int32_t)rds16(image, OV36_RT_SLOT) != slot) {
        return reject(why, "render slot does not match the image (0x48a3db reports and tears down)",
                      OVERLAY36_ERR_BOUNDS);
    }
    count = rds16(image, OV36_SECONDARY_COUNT);
    primary_limit = primary_count(image);
    if (count < 0 || count > 25) {
        return reject(why, "secondary record count outside the image table", OVERLAY36_ERR_BOUNDS);
    }
    /* Validate all records before the first blit. */
    for (index = 0; index < count; ++index) {
        const uint8_t *record = image + OV36_SECONDARY + (size_t)index * 38u;
        int32_t primary;
        if (rds16(record, OV36_SEC_FRAME) != world->selector) {
            continue;
        }
        primary = (rds16(image, OV36_MARKER) == 2) ? rds16(image, OV36_RT_FRAME)
                                                   : rds16(record, OV36_SEC_PRIMARY);
        if (primary < 0 || primary >= primary_limit || primary >= 100) {
            return reject(why, "primary record index outside the constructed table",
                          OVERLAY36_ERR_BOUNDS);
        }
    }
    for (index = 0; index < count; ++index) {
        const uint8_t *record = image + OV36_SECONDARY + (size_t)index * 38u;
        const uint8_t *primary_record;
        Overlay36Blit op;
        int32_t primary;
        if (rds16(record, OV36_SEC_FRAME) != world->selector) {
            continue;
        }
        primary = (rds16(image, OV36_MARKER) == 2) ? rds16(image, OV36_RT_FRAME)
                                                   : rds16(record, OV36_SEC_PRIMARY);
        primary_record = image + OV36_PRIMARY + (size_t)primary * 16u;
        memset(&op, 0, sizeof(op));
        op.row = manager->render[slot].row;
        op.slot = slot;
        op.source_surface = rd32(image, OV36_RT_SURFACE);
        op.src[0] = add32(rds32(primary_record, 0), rds32(record, OV36_SEC_SRC_LEFT));
        op.src[1] = add32(rds32(primary_record, 4), rds32(record, OV36_SEC_SRC_TOP));
        op.src[2] = add32(rds32(primary_record, 0), rds32(record, OV36_SEC_SRC_RIGHT));
        op.src[3] = add32(rds32(primary_record, 4), rds32(record, OV36_SEC_SRC_BOTTOM));
        op.dst[0] = add32(rds32(record, OV36_SEC_DST_LEFT), world->view_x_583186);
        op.dst[1] = add32(rds32(record, OV36_SEC_DST_TOP), world->view_y_58318a);
        op.dst[2] = add32(rds32(record, OV36_SEC_DST_RIGHT), world->view_x_583186);
        op.dst[3] = add32(rds32(record, OV36_SEC_DST_BOTTOM), world->view_y_58318a);
        if (rds16(image, OV36_PLAIN_23) == 1) {
            op.kind = OVERLAY36_BLIT_PLAIN;
            op.label = "Overlay AR plain blit";
            fx(host, OV36_FX_BLIT, slot, op.kind);
            if (host->blit(host->context, &op) != 0) {
                return reject(why, "blit failed", OVERLAY36_ERR_HOST);
            }
            continue;
        }
        if (rds16(image, OV36_MARKER) == 2) {
            Overlay36Blit restore = op;
            restore.kind = OVERLAY36_BLIT_PLAIN;
            restore.source_surface = world->background_surface_5d15e3;
            restore.src[0] = rds32(record, OV36_SEC_DST_LEFT);
            restore.src[1] = rds32(record, OV36_SEC_DST_TOP);
            restore.src[2] = rds32(record, OV36_SEC_DST_RIGHT);
            restore.src[3] = rds32(record, OV36_SEC_DST_BOTTOM);
            restore.label = "Overlay AR transparent - restore background";
            fx(host, OV36_FX_BLIT, slot, restore.kind);
            if (host->blit(host->context, &restore) != 0) {
                return reject(why, "blit failed", OVERLAY36_ERR_HOST);
            }
        }
        op.kind = OVERLAY36_BLIT_TRANSPARENT;
        op.label = "Overlay AR transparent blit";
        fx(host, OV36_FX_BLIT, slot, op.kind);
        if (host->blit(host->context, &op) != 0) {
            return reject(why, "blit failed", OVERLAY36_ERR_HOST);
        }
    }
    return OVERLAY36_OK;
}

int overlay36_render_layers(Overlay36Manager *manager, const Overlay36Rows *rows,
                            int32_t layer_lo, int32_t layer_hi, const Overlay36World *world,
                            const Overlay36Host *host, size_t *drawn, const char **why)
{
    int32_t layer;
    int slot;
    if (why != NULL) {
        *why = "none";
    }
    if (manager == NULL || rows == NULL || world == NULL || host == NULL) {
        return reject(why, "invalid render arguments", OVERLAY36_ERR_ARGUMENT);
    }
    if (drawn != NULL) {
        *drawn = 0u;
    }
    for (layer = layer_lo; layer <= layer_hi; ++layer) {
        for (slot = 0; slot < OVERLAY36_SLOTS; ++slot) {
            const Overlay36Render *entry = &manager->render[slot];
            int status;
            if (entry->visible == 0 || entry->active == 0 || entry->layer != layer) {
                continue;
            }
            if (entry->callback == 0) {
                return reject(why, "generic render entry (not an overlay)",
                              OVERLAY36_ERR_UNSUPPORTED);
            }
            status = overlay36_draw_slot(manager, rows, slot, world, host, why);
            if (status != OVERLAY36_OK) {
                return status;
            }
            if (drawn != NULL) {
                ++*drawn;
            }
        }
    }
    return OVERLAY36_OK;
}
