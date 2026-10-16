/* RT-24 oracle driver: exposes the native raw 0xd9 Mouselight kernel
 * (src/action_family_d9_runtime.c) to tests/action_family_d9_runtime_original_oracle.py through ctypes.
 *
 * The driver owns one D9Object, one D9World and a SCRIPTED host. Every D9Host callback applies to a
 * model of the generic Z entry table (0x5d1591, stride 0x4a, 0x58 entries) the exact stores the
 * original external (0x4d39f9 / 0x4d3992 / the inline entry stores of 0x47d788 / 0x47d640) makes, and the
 * kernel's ordered D9_FX_* observer log is exported. The Python side runs the unmodified x86 with hooks
 * that record the same effects and compares both logs, the object image, the entry table bytes, the
 * alpha map / mask bytes and the render plans.
 *
 * Test code only: portable C11, no original bytes. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_d9_runtime.h"

#define ENTRY_STRIDE 0x4au
#define ENTRY_COUNT 0x58u
#define MAX_LOG 256
#define MAX_NAMES 16
#define MAX_HANDLES 32

/* entry field offsets relative to 0x5d1591 */
#define E_TYPE 0x00
#define E_CALLBACK 0x04
#define E_SURFACE 0x08
#define E_F0C 0x0c
#define E_F10 0x10
#define E_DIRTY 0x14
#define E_BUSY 0x18
#define E_WORD 0x1c
#define E_LABEL 0x22

typedef struct D9o {
    D9Object obj;
    D9World world;
    D9Host host;
    D9View view;
    uint8_t entries[ENTRY_COUNT][ENTRY_STRIDE];
    int32_t log[MAX_LOG][3];
    int nlog;
    char names[MAX_NAMES][64];
    int nnames;
    uint32_t handles[MAX_HANDLES];
    int nhandles, ihandle;
    const char *why;
    int bad_slot_calls;
} D9o;

static void put32(uint8_t *p, uint32_t v) { memcpy(p, &v, 4); }
static uint32_t get32(const uint8_t *p) { uint32_t v; memcpy(&v, p, 4); return v; }

static uint8_t *entry(D9o *o, int16_t slot)
{
    if (slot < 0 || (unsigned)slot >= ENTRY_COUNT) {
        o->bad_slot_calls++;
        return NULL;
    }
    return o->entries[slot];
}

static void observe(void *c, int effect, int32_t a, int32_t b)
{
    D9o *o = c;
    if (o->nlog < MAX_LOG) {
        o->log[o->nlog][0] = effect;
        o->log[o->nlog][1] = a;
        o->log[o->nlog][2] = b;
        o->nlog++;
    }
}

static int h_alloc_slot(void *c, int16_t *slot)
{
    D9o *o = c;
    for (int i = D9_SLOT_FIRST; i <= D9_SLOT_LAST; ++i)
        if (get32(o->entries[i] + E_BUSY) == 0u) {
            *slot = (int16_t)i;
            return 0;
        }
    return 1; /* the original reaches the fatal path 0x52139c here */
}

static int h_register_slot(void *c, int16_t slot, uint32_t surface, const char *label)
{
    D9o *o = c;
    uint8_t *e = entry(o, slot);
    if (e == NULL) return 1;
    put32(e + E_TYPE, 10u);
    put32(e + E_CALLBACK, 0x47df57u);
    put32(e + E_SURFACE, surface);
    put32(e + E_F0C, 0u);
    put32(e + E_F10, 0u);
    put32(e + E_DIRTY, 1u);
    put32(e + E_BUSY, 1u);
    e[E_WORD] = 0;
    e[E_WORD + 1] = 0;
    memcpy(e + E_LABEL, label, strlen(label) + 1u); /* the inline repne scasb / rep movs copy */
    return 0;
}

static int h_load_surface(void *c, const char *name, uint32_t *surface)
{
    D9o *o = c;
    if (o->nnames < MAX_NAMES) {
        strncpy(o->names[o->nnames], name, sizeof o->names[0] - 1u);
        o->names[o->nnames][sizeof o->names[0] - 1u] = '\0';
        o->nnames++;
    }
    *surface = o->ihandle < o->nhandles ? o->handles[o->ihandle] : 0u;
    o->ihandle++;
    return 0;
}

static int h_set_slot_surface(void *c, int16_t slot, uint32_t surface)
{
    uint8_t *e = entry(c, slot);
    if (e == NULL) return 1;
    put32(e + E_SURFACE, surface);
    return 0;
}

static int h_release_surface(void *c, uint32_t surface)
{
    (void)c;
    (void)surface;
    return 0;
}

static int h_release_slot(void *c, int16_t slot)
{
    uint8_t *e = entry(c, slot);
    if (e == NULL) return 1;
    put32(e + E_DIRTY, 0u);
    put32(e + E_BUSY, 0u);
    return 0;
}

static int h_mark_dirty(void *c, int16_t slot)
{
    uint8_t *e = entry(c, slot);
    if (e == NULL) return 1;
    put32(e + E_DIRTY, 1u);
    return 0;
}

static int h_view(void *c, D9View *out)
{
    *out = ((D9o *)c)->view;
    return 0;
}

void *d9o_new(void)
{
    D9o *o = calloc(1, sizeof *o);
    if (o == NULL) return NULL;
    d9_object_reset(&o->obj);
    o->host.context = o;
    o->host.alloc_slot = h_alloc_slot;
    o->host.register_slot = h_register_slot;
    o->host.load_surface = h_load_surface;
    o->host.set_slot_surface = h_set_slot_surface;
    o->host.release_surface = h_release_surface;
    o->host.release_slot = h_release_slot;
    o->host.mark_dirty = h_mark_dirty;
    o->host.view = h_view;
    o->host.observe = observe;
    return o;
}

void d9o_free(void *h)
{
    D9o *o = h;
    if (o == NULL) return;
    free(o->obj.composite);
    free(o->obj.alpha);
    free(o->obj.mask);
    free(o);
}

void d9o_set_view(void *h, int32_t ox, int32_t oy, int32_t bottom, int32_t max_x, int32_t max_y)
{
    D9o *o = h;
    o->view.origin_x = ox;
    o->view.origin_y = oy;
    o->view.bottom = bottom;
    o->view.max_x = max_x;
    o->view.max_y = max_y;
}

void d9o_set_world_flag(void *h, int32_t v) { ((D9o *)h)->world.start_flag_5bb1ca = v; }
int32_t d9o_get_world_flag(void *h) { return ((D9o *)h)->world.start_flag_5bb1ca; }

void d9o_set_handles(void *h, const uint32_t *hs, int n)
{
    D9o *o = h;
    o->nhandles = n > MAX_HANDLES ? MAX_HANDLES : n;
    memcpy(o->handles, hs, (size_t)o->nhandles * sizeof(uint32_t));
    o->ihandle = 0;
}

void d9o_set_busy(void *h, int slot, int busy)
{
    D9o *o = h;
    if (slot >= 0 && (unsigned)slot < ENTRY_COUNT) put32(o->entries[slot] + E_BUSY, busy ? 1u : 0u);
}

/* The saved scene frame [0x5d15e3] is entry 1's surface field (0x5d1591 + 0x4a + 8). */
void d9o_set_entry_u32(void *h, int slot, int offset, uint32_t value)
{
    D9o *o = h;
    if (slot >= 0 && (unsigned)slot < ENTRY_COUNT && offset >= 0 && offset + 4 <= (int)ENTRY_STRIDE)
        put32(o->entries[slot] + offset, value);
}

void d9o_clear_log(void *h)
{
    D9o *o = h;
    o->nlog = 0;
    o->nnames = 0;
    o->bad_slot_calls = 0;
}

int d9o_step(void *h, const uint8_t *body, int row, uint32_t phase, uint32_t *result)
{
    D9o *o = h;
    D9Result r;
    int status;
    memset(&r, 0, sizeof r);
    o->why = "none";
    status = d9_step(&o->obj, body, D9_BODY_BYTES, (int16_t)row, phase, &o->world, &o->host, &r, &o->why);
    result[0] = r.phase_after;
    result[1] = r.initialized;
    return status;
}

const char *d9o_why(void *h) { return ((D9o *)h)->why; }
int d9o_bad_slot_calls(void *h) { return ((D9o *)h)->bad_slot_calls; }
int d9o_pointer(void *h, int x, int y) { return d9_pointer_move(&((D9o *)h)->obj, (int16_t)x, (int16_t)y); }
int d9o_invalidate(void *h) { D9o *o = h; return d9_invalidate(&o->obj, &o->host); }
int d9o_cleanup(void *h) { D9o *o = h; return d9_cleanup(&o->obj, &o->host); }

int d9o_log_count(void *h) { return ((D9o *)h)->nlog; }
void d9o_log(void *h, int i, int32_t *out) { memcpy(out, ((D9o *)h)->log[i], 3u * sizeof(int32_t)); }
int d9o_name_count(void *h) { return ((D9o *)h)->nnames; }
const char *d9o_name(void *h, int i) { return ((D9o *)h)->names[i]; }

/* object image: 25 values, same order as the Python side reads the original */
void d9o_object(void *h, int32_t *out)
{
    const D9Object *b = &((D9o *)h)->obj;
    int k = 0;
    out[k++] = b->active;
    out[k++] = b->row;
    out[k++] = (int32_t)b->surface;
    out[k++] = b->slot;
    out[k++] = b->pointer_x;
    out[k++] = b->pointer_y;
    for (int i = 0; i < 4; ++i) out[k++] = b->rect[i];
    for (int i = 0; i < 4; ++i) out[k++] = b->prev[i];
    out[k++] = b->composite != NULL;
    out[k++] = b->alpha != NULL;
    out[k++] = b->mask != NULL;
    out[k++] = b->radius;
    out[k++] = b->tracking;
}

size_t d9o_alpha_bytes(void *h)
{
    const D9Object *b = &((D9o *)h)->obj;
    return b->alpha != NULL ? 16u * (size_t)b->radius * (size_t)b->radius : 0u;
}
size_t d9o_mask_bytes(void *h)
{
    const D9Object *b = &((D9o *)h)->obj;
    return b->mask != NULL ? 4u * (size_t)b->radius * (size_t)b->radius : 0u;
}
void d9o_alpha_copy(void *h, void *out) { memcpy(out, ((D9o *)h)->obj.alpha, d9o_alpha_bytes(h)); }
void d9o_mask_copy(void *h, void *out) { memcpy(out, ((D9o *)h)->obj.mask, d9o_mask_bytes(h)); }
void d9o_entries(void *h, uint8_t *out) { memcpy(out, ((D9o *)h)->entries, sizeof(((D9o *)h)->entries)); }

/* render plan: valid, restore_src[4], restore_dst[4], kind, surface, src[4], dst[4], map[4] = 23 values */
int d9o_plan(void *h, const uint8_t *body, int32_t *out)
{
    D9o *o = h;
    D9RenderPlan p;
    int status = d9_render_plan(&o->obj, body, D9_BODY_BYTES, &o->view, &p);
    int k = 0;
    out[k++] = p.valid;
    for (int i = 0; i < 4; ++i) out[k++] = p.restore_src[i];
    for (int i = 0; i < 4; ++i) out[k++] = p.restore_dst[i];
    out[k++] = (int32_t)p.kind;
    out[k++] = (int32_t)p.surface;
    for (int i = 0; i < 4; ++i) out[k++] = p.src[i];
    for (int i = 0; i < 4; ++i) out[k++] = p.dst[i];
    for (int i = 0; i < 4; ++i) out[k++] = p.map[i];
    return status;
}

float d9o_alpha_at(int32_t radius, int32_t dx, int32_t dy) { return d9_alpha_at(radius, dx, dy); }

/* pixel operations on caller-owned flat 16-bit surfaces */
int d9o_blit_copy(uint8_t *sp, size_t sl, int sp_pitch, uint8_t *dp, size_t dl, int dpitch,
                  const int32_t *src_rect, const int32_t *dst_rect)
{
    D9Surface s = {sp, sl, sp_pitch}, d = {dp, dl, dpitch};
    return d9_blit_copy(&s, &d, src_rect, dst_rect);
}

int d9o_blit_mask(uint8_t *sp, size_t sl, int spitch, uint8_t *dp, size_t dl, int dpitch,
                  const uint8_t *mask, size_t mask_bytes, const int32_t *src_rect,
                  const int32_t *dst_rect, const int32_t *map_rect)
{
    D9Surface s = {sp, sl, spitch}, d = {dp, dl, dpitch};
    return d9_blit_mask(&s, &d, mask, mask_bytes, src_rect, dst_rect, map_rect);
}

int d9o_blit_alpha(uint8_t *pp, size_t pl, int ppitch, uint8_t *bp, size_t bl, int bpitch,
                   uint8_t *dp, size_t dl, int dpitch, const float *alpha, size_t alpha_count,
                   const int32_t *puzzle_rect, const int32_t *bg_rect, const int32_t *dst_rect,
                   const int32_t *map_rect, const uint8_t *shifts, const uint8_t *masks)
{
    D9Surface p = {pp, pl, ppitch}, b = {bp, bl, bpitch}, d = {dp, dl, dpitch};
    D9PixelFormat f;
    memcpy(f.shift, shifts, 3);
    memcpy(f.mask, masks, 3);
    return d9_blit_alpha(&p, &b, &d, alpha, alpha_count, puzzle_rect, bg_rect, dst_rect, map_rect, &f);
}
