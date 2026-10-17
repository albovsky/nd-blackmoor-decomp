#include "action_family_1c_runtime.h"

#include <stdlib.h>
#include <string.h>

void c1c_object_reset(C1cObject *object)
{
    if (object != NULL) {
        memset(object, 0, sizeof(*object));
    }
}

void c1c_free_iv(C1cObject *object)                                       /* 0x4cbb00 */
{
    int32_t i;
    if (object == NULL || object->iv == NULL) {
        return;
    }
    for (i = 0; i < object->iv->count; ++i) {
        free(object->iv->entries[i].rects);
    }
    free(object->iv->entries);
    free(object->iv);
    object->iv = NULL;
    object->record = NULL;
}

static int read_exact(const C1cHost *host, void *file, void *buffer, size_t size)
{
    return host->read(host->context, file, buffer, size) == size;
}

static int16_t le16(const uint8_t *p)
{
    return (int16_t)(uint16_t)(p[0] | (p[1] << 8));
}

static int32_t le32(const uint8_t *p)
{
    return (int32_t)((uint32_t)p[0] | ((uint32_t)p[1] << 8) | ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24));
}

/* 0x4cbba9 LoadIVFile. On any refusal nothing stays loaded. */
static int load_iv(C1cObject *object, const uint8_t *body, const C1cHost *host)
{
    char name[C1C_BODY_BYTES];
    void *file = NULL;
    C1cIv *iv;
    uint8_t raw[C1C_RECT_BYTES];
    int32_t i, j;
    size_t length;

    c1c_free_iv(object);
    for (length = 0u; length < C1C_BODY_BYTES && body[length] != 0u; ++length) {
    }
    if (length == 0u || length >= C1C_BODY_BYTES) {                      /* 0x4cbbd1: empty name; unterminated is native-only */
        return C1C_ERR_FILE;
    }
    memcpy(name, body, length + 1u);
    if (host->open_iv(host->context, name, &file) != 0 || file == NULL) { /* 0x4cbc58 */
        return C1C_ERR_FILE;
    }
    iv = (C1cIv *)calloc(1u, sizeof(*iv));
    if (iv == NULL) {
        host->close(host->context, file);
        return C1C_ERR_HOST;
    }
    {
        uint8_t count_bytes[4];
        if (!read_exact(host, file, iv->name, C1C_NAME_BYTES) || !read_exact(host, file, count_bytes, 4u)) {   /* 0x4cbcb9, 0x4cbcde */
            goto fail;
        }
        iv->count = le32(count_bytes);
    }
    if (iv->count < 0 || iv->count > C1C_MAX_ENTRIES) {
        goto fail;
    }
    iv->entries = (C1cEntry *)calloc((size_t)iv->count + 1u, sizeof(C1cEntry));
    if (iv->entries == NULL) {
        goto fail;
    }
    {
        for (i = 0; i < iv->count; ++i) {
            C1cEntry *e = &iv->entries[i];
            uint8_t b2[2];
            uint8_t b1[1];
            if (!read_exact(host, file, b2, 2u)) goto fail_entries;     /* 0x4cbd9c: id */
            e->id = le16(b2);
            if (!read_exact(host, file, b2, 2u)) goto fail_entries;     /* 0x4cbdc8: hotspot count */
            e->count = le16(b2);
            if (!read_exact(host, file, b1, 1u)) goto fail_entries;     /* 0x4cbdf0 */
            e->byte_4 = b1[0];
            if (!read_exact(host, file, b2, 2u)) goto fail_entries;     /* 0x4cbe18 */
            e->word_5 = le16(b2);
            if (!read_exact(host, file, b2, 2u)) goto fail_entries;     /* 0x4cbe40 */
            e->word_7 = le16(b2);
            if (e->count <= 0 || e->count > C1C_MAX_RECTS) goto fail_entries;
            e->rects = (C1cRect *)calloc((size_t)e->count, sizeof(C1cRect));
            if (e->rects == NULL) goto fail_entries;
            for (j = 0; j < e->count; ++j) {                             /* one fread of count * 24 bytes (0x4cbec5) */
                int k;
                if (!read_exact(host, file, raw, C1C_RECT_BYTES)) goto fail_entries;
                for (k = 0; k < 6; ++k) {
                    e->rects[j].d[k] = le32(raw + 4 * k);
                }
            }
        }
    }
    host->close(host->context, file);                                    /* 0x4cbf06 */
    object->iv = iv;
    return C1C_OK;
fail_entries:
    for (i = 0; i < iv->count; ++i) {
        free(iv->entries[i].rects);
    }
fail:
    free(iv->entries);
    free(iv);
    host->close(host->context, file);
    return C1C_ERR_FILE;
}

static const C1cEntry *find_entry(const C1cObject *object, int32_t index)  /* 0x4cb944 */
{
    int32_t i;
    if (object->iv == NULL) {
        return NULL;
    }
    for (i = 0; i < object->iv->count; ++i) {
        if (object->iv->entries[i].id == index) {
            return &object->iv->entries[i];
        }
    }
    return NULL;
}

static int names_equal(const uint8_t *a, const uint8_t *b)               /* 0x4cb600..0x4cb664: strcmp on the 33 bytes */
{
    size_t i;
    for (i = 0; i < C1C_NAME_BYTES; ++i) {
        if (a[i] != b[i]) return 0;
        if (a[i] == 0) return 1;
    }
    return 1;
}

int c1c_visit(C1cObject *object, const uint8_t body[C1C_BODY_BYTES], uint32_t phase, const C1cHost *host, C1cOutcome *outcome)
{
    int32_t state, index32;
    int16_t index;
    int origin_present;
    int32_t dx = 0, dy = 0;
    int status;

    if (object == NULL || body == NULL || host == NULL || outcome == NULL || host->player_state == NULL ||
        host->player_name == NULL || host->player_hotspot == NULL || host->player_origin == NULL || host->open_iv == NULL ||
        host->read == NULL || host->close == NULL || host->alloc_slot == NULL || host->register_slot == NULL ||
        host->release_slot == NULL || host->cell_583a29 == NULL) {
        return C1C_ERR_ARGUMENT;
    }
    outcome->phase = phase;
    outcome->disposition = SCENE_ACTION_HANDLER_PENDING;
    object->body = body;                                                 /* 0x4cb5a4: stored on every visit */
    if (phase > 2u) {                                                    /* 0x4cb5c4: any other state does nothing */
        return C1C_OK;
    }
    if (phase == 2u) {                                                   /* 0x4cb8a4 */
        if (object->slot != -1) {
            if (host->release_slot(host->context, object->slot) != 0) return C1C_ERR_HOST;
        }
        c1c_free_iv(object);
        object->body = NULL;
        object->slot = -1;
        object->armed = 0;
        object->changed = 0;
        object->record = NULL;
        object->dword_14e = 0;
        object->dword_154 = 0;
        object->dword_158 = 0;
        object->last_index = -1;
        object->origin_present = 0;
        outcome->phase = 0u;                                             /* 0x42ba3a leaves the phase word 0 */
        outcome->disposition = SCENE_ACTION_HANDLER_COMPLETED;           /* 0x42ba3a */
        return C1C_OK;
    }
    if (phase == 0u) {
        uint8_t name[C1C_NAME_BYTES];
        if (object->iv == NULL) {
            status = load_iv(object, body, host);                        /* 0x4cb5ec */
            if (status != C1C_OK) return status;
        }
        if (host->player_state(host->context, &state) != 0) return C1C_ERR_HOST;
        if (state != 2) return C1C_OK;                                   /* 0x4cb5fd */
        if (host->player_name(host->context, name) != 0) return C1C_ERR_HOST;
        if (!names_equal(object->iv->name, name)) return C1C_OK;         /* 0x4cb664 */
        object->slot = -1;                                               /* 0x4cb66a */
        if (le16(body + C1C_BODY_RENDER_WORD) != 0) {
            int16_t slot;
            if (host->alloc_slot(host->context, &slot) != 0) return C1C_ERR_HOST;       /* 0x4cb690 */
            object->slot = slot;
            if (host->register_slot(host->context, slot, C1C_LABEL) != 0) return C1C_ERR_HOST;
        }
        if (host->cell_583a29(host->context, &object->word_152) != 0) return C1C_ERR_HOST; /* 0x4cb76f */
        object->last_index = -1;                                         /* 0x4cb79a */
        object->changed = 0;
        object->record = NULL;
        object->dword_154 = 0;
        object->dword_14e = 0;
        object->armed = 1;
        object->origin_present = 0;
        phase = 1u;
        outcome->phase = 1u;                                             /* 0x4cb7e5: state := 1 */
    }
    /* phase 1 (also the tail of phase 0) */
    object->changed = 0;                                                 /* 0x4cb7ff */
    object->record = NULL;
    if (host->player_state(host->context, &state) != 0) return C1C_ERR_HOST;
    if (state == 2 || state == 3) {                                      /* 0x4cb81d */
        if (state == 2) {
            if (host->player_hotspot(host->context, &index) != 0) return C1C_ERR_HOST;
            index32 = index;
            if (index32 != -1) {
                object->record = find_entry(object, index32);            /* 0x4cb865 */
                if (object->record != NULL && index32 != object->last_index) {
                    if (host->player_origin(host->context, &origin_present, &dx, &dy) != 0) return C1C_ERR_HOST;
                    object->origin_present = origin_present != 0;        /* 0x4cb9d1 */
                    if (object->origin_present) {
                        int16_t k;
                        C1cRect *rects = object->record->rects;
                        for (k = 0; k < object->record->count; ++k) {
                            rects[k].d[1] = (int32_t)((uint32_t)rects[k].d[1] + (uint32_t)dx);
                            rects[k].d[3] = (int32_t)((uint32_t)rects[k].d[3] + (uint32_t)dx);
                            rects[k].d[2] = (int32_t)((uint32_t)rects[k].d[2] + (uint32_t)dy);
                            rects[k].d[4] = (int32_t)((uint32_t)rects[k].d[4] + (uint32_t)dy);
                        }
                    }
                    object->changed = 1;                                 /* 0x4cb89f */
                    object->last_index = index32;
                }
            }
        }
    } else {
        outcome->phase = 2u;                                             /* 0x4cb8b2 */
    }
    return C1C_OK;
}

int c1c_render(C1cObject *object, int32_t view_x, int32_t view_y, C1cFill *fills, size_t capacity, size_t *count)
{
    uint16_t color = C1C_COLOR_FIRST;
    int16_t i;
    size_t n = 0u;

    if (object == NULL || count == NULL || (capacity != 0u && fills == NULL)) {
        return C1C_ERR_ARGUMENT;
    }
    *count = 0u;
    if (object->changed == 0) {                                          /* 0x4cc7bc */
        return C1C_OK;
    }
    if (object->record == NULL) {
        return C1C_ERR_BODY;                                             /* the original would read through a null pointer */
    }
    for (i = 0; i < object->record->count; ++i) {
        const C1cRect *r = &object->record->rects[i];
        if (n < capacity) {
            fills[n].left = (int32_t)((uint32_t)r->d[1] + (uint32_t)view_x);
            fills[n].right = (int32_t)((uint32_t)r->d[3] + (uint32_t)view_x);
            fills[n].top = (int32_t)((uint32_t)r->d[2] + (uint32_t)view_y);
            fills[n].bottom = (int32_t)((uint32_t)r->d[4] + (uint32_t)view_y);
            fills[n].color = color;
        }
        ++n;
        color = (uint16_t)(color + C1C_COLOR_STEP);
    }
    *count = n;
    object->changed = 0;
    return C1C_OK;
}
