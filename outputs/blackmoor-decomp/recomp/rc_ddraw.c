/* DirectDraw 7 stand-in: RGB565 surfaces in guest memory, software blits, no hardware. Ported from the Python spike (driver.py), whose
 * quirks are kept where the game's behaviour depends on them (the capability bits it reports, a primary surface that is drawn on directly). */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "rc.h"
#include "rc_internal.h"

#define API(name) static int api_##name(Fl41Regs *r, const uint32_t *a, uint32_t *ret)
#define UNUSED (void)r; (void)a; (void)ret
#define RET(v) do { *ret = (uint32_t)(v); return 0; } while (0)

typedef struct Surface {
    uint32_t w, h, pitch, buf, caps;
    int primary, has_ckey, client;
    uint32_t ckey, back, refs, guest, blits, bytes;
} Surface;

typedef struct DDraw { uint32_t refs; } DDraw;

static uint32_t display_w = 640, display_h = 480;
static Surface *primary_surface;
static uint64_t serial;
static uint64_t prim_blits;
static void (*frame_hook)(int is_flip, uint64_t blits);

void rc_set_frame_hook(void (*hook)(int is_flip, uint64_t blits)) { frame_hook = hook; }
uint64_t rc_primary_serial(void) { return serial; }

int rc_get_primary(const uint16_t **pixels, uint32_t *width, uint32_t *height, uint32_t *pitch_bytes)
{
    if (!primary_surface) return 0;
    void *p = rc_ptr(primary_surface->buf, primary_surface->pitch * primary_surface->h);
    if (!p) return 0;
    *pixels = (const uint16_t *)p;
    *width = primary_surface->w; *height = primary_surface->h; *pitch_bytes = primary_surface->pitch;
    return 1;
}

/* ------------------------------------------------------------------ surface memory: pages from the surface region, recycled by size */
typedef struct FreeRun { uint32_t bytes, head; } FreeRun;
static FreeRun runs[256];
static int run_count;
static uint32_t surf_next = RC_SURF_BASE;

uint32_t rc_surf_alloc(uint32_t bytes)
{
    bytes = (bytes + 0xfffu) & ~0xfffu;
    for (int i = 0; i < run_count; i++)
        if (runs[i].bytes == bytes && runs[i].head) {
            uint32_t p = runs[i].head;
            runs[i].head = rc_u32(p);
            rc_zero(p, bytes);
            return p;
        }
    if ((uint64_t)surf_next + bytes > (uint64_t)RC_SURF_BASE + RC_SURF_SIZE) rc_abort("surface memory exhausted");
    uint32_t p = surf_next;
    surf_next += bytes;
    return p;
}

void rc_surf_free(uint32_t p, uint32_t bytes)
{
    bytes = (bytes + 0xfffu) & ~0xfffu;
    if (getenv("RC_NO_SURFACE_FREE")) return;
    for (int i = 0; i < run_count; i++)
        if (runs[i].bytes == bytes) { rc_w32(p, runs[i].head); runs[i].head = p; return; }
    if (run_count < 256) { runs[run_count].bytes = bytes; rc_w32(p, 0); runs[run_count++].head = p; }
}

/* ------------------------------------------------------------------ objects */
static uint32_t new_ddraw_obj(DDraw *d);
static uint32_t new_surface_obj(Surface *s);
static uint32_t new_clipper_obj(void);
static uint32_t new_palette_obj(void);

static Surface *surf(uint32_t this_) { return (Surface *)rc_com_obj(this_); }

static uint32_t surface_new(uint32_t w, uint32_t h, uint32_t caps, int primary)
{
    Surface *s = (Surface *)calloc(1, sizeof *s);
    s->w = w; s->h = h; s->pitch = (w * 2 + 7) & ~7u; s->caps = caps; s->primary = primary; s->refs = 1;
    s->bytes = s->pitch * h;
    s->buf = rc_surf_alloc(s->bytes);
    s->guest = new_surface_obj(s);
    if (primary) primary_surface = s;
    return s->guest;
}

static void fill_desc(uint32_t desc, const Surface *o)
{
    rc_zero(desc, 0x7c);
    rc_w32(desc, 0x7c);
    rc_w32(desc + 4, 0x1 | 0x2 | 0x4 | 0x8 | 0x800 | 0x1000);        /* CAPS HEIGHT WIDTH PITCH LPSURFACE PIXELFORMAT */
    rc_w32(desc + 8, o->h); rc_w32(desc + 0xc, o->w); rc_w32(desc + 0x10, o->pitch);
    rc_w32(desc + 0x24, o->buf);
    rc_w32(desc + 0x48, 32); rc_w32(desc + 0x4c, 0x40);                 /* DDPF_RGB */
    rc_w32(desc + 0x54, 16); rc_w32(desc + 0x58, 0xf800); rc_w32(desc + 0x5c, 0x07e0); rc_w32(desc + 0x60, 0x001f);
    rc_w32(desc + 0x68, o->caps);
}

static void fill_display_desc(uint32_t desc)
{
    Surface t = {display_w, display_h, display_w * 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    fill_desc(desc, &t);
}

/* ------------------------------------------------------------------ entry points */
API(DirectDrawEnumerateExA)
{
    (void)r; (void)ret;
    rc_log("  DirectDrawEnumerateExA -> one device");
    uint32_t args[5] = {0, rc_guest_string("Primary Display Driver"), rc_guest_string("display"), a[1], 0};
    rc_call(a[0], 5, args, 0);
    RET(0);
}
static uint32_t ddraw_new(void)
{
    DDraw *d = (DDraw *)calloc(1, sizeof *d);
    d->refs = 1;
    return new_ddraw_obj(d);
}
API(DirectDrawCreateEx) { (void)r; rc_w32(a[1], ddraw_new()); rc_log("  DirectDrawCreateEx -> IDirectDraw7"); RET(0); }
API(DirectDrawCreate) { (void)r; rc_w32(a[1], ddraw_new()); RET(0); }

/* ------------------------------------------------------------------ IDirectDraw7 */
API(DD_QueryInterface) { (void)r; DDraw *d = (DDraw *)rc_com_obj(a[0]); if (d) d->refs++; rc_w32(a[2], a[0]); RET(0); }
API(DD_AddRef) { (void)r; DDraw *d = (DDraw *)rc_com_obj(a[0]); RET(d ? ++d->refs : 1); }
API(DD_Release) { (void)r; DDraw *d = (DDraw *)rc_com_obj(a[0]); RET(d && d->refs ? --d->refs : 0); }
API(DD_SetCooperativeLevel) { (void)r; rc_log("  SetCooperativeLevel(hwnd=0x%x, flags=0x%x)", a[1], a[2]); RET(0); }
API(DD_SetDisplayMode)
{
    (void)r;
    rc_log("  SetDisplayMode(%ux%ux%u)", a[1], a[2], a[3]);
    display_w = a[1]; display_h = a[2];
    RET(0);
}
API(DD_Zero) { UNUSED; RET(0); }
API(DD_GetDisplayMode) { (void)r; fill_display_desc(a[1]); RET(0); }
API(DD_EnumDisplayModes)
{
    (void)r; (void)ret;
    static const uint32_t modes[3][2] = {{640, 480}, {800, 600}, {1024, 768}};
    for (int i = 0; i < 3; i++) {
        uint32_t d = rc_alloc(0x7c);
        Surface t = {modes[i][0], modes[i][1], modes[i][0] * 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
        fill_desc(d, &t);
        rc_w32(d + 0x14, 60);                    /* dwRefreshRate shares the back-buffer-count slot */
        uint32_t args[2] = {d, a[3]};
        if (!rc_call(a[4], 2, args, 0)) break;
    }
    RET(0);
}
API(DD_GetCaps)
{
    (void)r;
    for (int i = 1; i <= 2; i++) {
        uint32_t p = a[i];
        if (!p) continue;
        uint32_t size = rc_u32(p);
        if (size > 4) rc_zero(p + 4, size - 4);
        rc_w32(p + 4, 0x40 | 0x4000000 | 0x8000000 | 0x80 | 0x100);      /* BLT, BLTCOLORFILL, BLTSTRETCH, BLTQUEUE, CANBLTSYSMEM */
        rc_w32(p + 0x14, 64u << 20); rc_w32(p + 0x18, 64u << 20);        /* as the spike reported them: not the DDCAPS memory fields */
    }
    RET(0);
}
API(DD_GetAvailableVidMem) { (void)r; if (a[2]) rc_w32(a[2], 64u << 20); if (a[3]) rc_w32(a[3], 60u << 20); RET(0); }
API(DD_GetDeviceIdentifier)
{
    (void)r;
    rc_zero(a[1], 0x4c0);
    rc_put_cstr(a[1], "display.drv"); rc_put_cstr(a[1] + 0x200, "Primary Display Driver");
    rc_w32(a[1] + 0x400, 0x5000f); rc_w32(a[1] + 0x404, 0x0007000d);
    RET(0);
}
API(DD_GetMonitorFrequency) { (void)r; rc_w32(a[1], 60); RET(0); }
API(DD_GetGDISurface)
{
    (void)r;
    if (!primary_surface) RET(0x887601c2u);
    primary_surface->refs++;
    rc_w32(a[1], primary_surface->guest);
    RET(0);
}
API(DD_CreateClipper) { (void)r; rc_w32(a[2], new_clipper_obj()); RET(0); }
API(DD_CreatePalette) { (void)r; rc_w32(a[3], new_palette_obj()); RET(0); }
API(DD_CreateSurface)
{
    (void)r;
    uint32_t desc = a[1], flags = rc_u32(desc + 4), caps = rc_u32(desc + 0x68);
    uint32_t w = (flags & 4) ? rc_u32(desc + 0xc) : display_w;
    uint32_t h = (flags & 2) ? rc_u32(desc + 8) : display_h;
    uint32_t nback = (flags & 0x20) ? rc_u32(desc + 0x14) : 0;
    if (w == 0 || h == 0 || w > 8192 || h > 8192) { RET(0x887600deu); }       /* DDERR_INVALIDPARAMS */
    uint32_t sg = surface_new(w, h, caps, (caps & 0x200) != 0);
    Surface *s = surf(sg);
    if (nback) {
        uint32_t bg = surface_new(w, h, (caps & ~0x200u) | 0x4u, 0);          /* DDSCAPS_BACKBUFFER */
        s->back = bg;
    }
    rc_w32(a[2], sg);
    rc_log("  CreateSurface(%ux%u caps=0x%x back=%u) -> 0x%x", w, h, caps, nback, sg);
    RET(0);
}

/* ------------------------------------------------------------------ IDirectDrawClipper, IDirectDrawPalette */
API(Obj_AddRef) { UNUSED; RET(1); }
API(Obj_Release) { UNUSED; RET(0); }
API(Obj_QueryInterface) { (void)r; rc_w32(a[2], a[0]); RET(0); }

/* ------------------------------------------------------------------ IDirectDrawSurface7 */
static uint32_t surface_release(Surface *s)
{
    if (!s->refs) return 0;
    if (--s->refs) return s->refs;
    if (s->back) {
        Surface *b = surf(s->back);
        s->back = 0;
        if (b) surface_release(b);
    }
    if (s == primary_surface) primary_surface = NULL;
    if (!s->client && s->buf) rc_surf_free(s->buf, s->bytes);
    s->buf = 0;
    return 0;
}
API(S_QueryInterface) { (void)r; Surface *s = surf(a[0]); if (s) s->refs++; rc_w32(a[2], a[0]); RET(0); }
API(S_AddRef) { (void)r; Surface *s = surf(a[0]); RET(s ? ++s->refs : 1); }
API(S_Release) { (void)r; Surface *s = surf(a[0]); RET(s ? surface_release(s) : 0); }
API(S_GetSurfaceDesc) { (void)r; Surface *s = surf(a[0]); if (s) fill_desc(a[1], s); RET(0); }
API(S_GetPixelFormat)
{
    (void)r;
    Surface *s = surf(a[0]);
    uint8_t tmp[0x7c];
    uint32_t d = rc_alloc(0x7c);
    if (s) fill_desc(d, s);
    rc_read(d + 0x48, tmp, 32);
    rc_write(a[1], tmp, 32);
    RET(0);
}
API(S_GetCaps) { (void)r; Surface *s = surf(a[0]); uint32_t v[4] = {s ? s->caps : 0, 0, 0, 0}; rc_write(a[1], v, 16); RET(0); }
API(S_GetAttachedSurface)
{
    (void)r;
    Surface *s = surf(a[0]);
    if (!s || !s->back) RET(0x887601c2u);
    Surface *b = surf(s->back);
    if (b) b->refs++;
    rc_w32(a[2], s->back);
    RET(0);
}
API(S_Lock)
{
    (void)r;
    Surface *s = surf(a[0]);
    if (!s) RET(0x887601c2u);
    fill_desc(a[2], s);
    if (a[1]) {
        int32_t l = (int32_t)rc_u32(a[1]), t = (int32_t)rc_u32(a[1] + 4);
        rc_w32(a[2] + 0x24, s->buf + (uint32_t)t * s->pitch + (uint32_t)l * 2u);
    }
    RET(0);
}
API(S_SetSurfaceDesc)
{
    (void)r;
    Surface *s = surf(a[0]);
    if (!s) RET(0);
    uint32_t f = rc_u32(a[1] + 4);
    if (f & 0x800) {
        if (!s->client && s->buf) rc_surf_free(s->buf, s->bytes);
        s->buf = rc_u32(a[1] + 0x24); s->client = 1;
    }
    if (f & 0x8) s->pitch = rc_u32(a[1] + 0x10);
    if (f & 0x4) s->w = rc_u32(a[1] + 0xc);
    if (f & 0x2) s->h = rc_u32(a[1] + 8);
    rc_log("  SetSurfaceDesc(0x%x: %ux%u pitch %u buf 0x%x)", a[0], s->w, s->h, s->pitch, s->buf);
    RET(0);
}
API(S_GetDC) { (void)r; rc_w32(a[1], rc_handle_new(RC_H_SURFDC, NULL)); RET(0); }
API(S_SetColorKey)
{
    (void)r;
    Surface *s = surf(a[0]);
    if (!s) RET(0);
    if (a[2]) { s->has_ckey = 1; s->ckey = rc_u32(a[2]); } else s->has_ckey = 0;
    RET(0);
}
API(S_GetColorKey)
{
    (void)r;
    Surface *s = surf(a[0]);
    if (!s || !s->has_ckey) RET(0x8876021bu);
    uint32_t v[2] = {s->ckey, s->ckey};
    rc_write(a[2], v, 8);
    RET(0);
}

/* kind 0: Blt, 1: BltFast, 2: Flip. The game draws straight onto the primary surface with BltFast, so the harness counts those. */
static void present_note(Surface *d, int kind)
{
    if (!d->primary) return;
    serial++;
    if (kind == 1) prim_blits++;
    if (frame_hook && kind) frame_hook(kind == 2, prim_blits);
}
API(S_Flip)
{
    (void)r;
    Surface *o = surf(a[0]);
    if (!o) RET(0);
    Surface *b = o->back ? surf(o->back) : NULL;
    if (b) { uint32_t t = o->buf; o->buf = b->buf; b->buf = t; }
    present_note(o, 2);
    RET(0);
}

static void get_rect(uint32_t p, const Surface *o, int32_t *rc)
{
    if (!p) { rc[0] = 0; rc[1] = 0; rc[2] = (int32_t)o->w; rc[3] = (int32_t)o->h; return; }
    for (int i = 0; i < 4; i++) rc[i] = (int32_t)rc_u32(p + 4u * (uint32_t)i);
}

static uint8_t *surf_row(const Surface *s, int32_t y, int32_t x, uint32_t pixels)
{
    uint8_t *p = (uint8_t *)rc_ptr(s->buf + (uint32_t)y * s->pitch + (uint32_t)x * 2u, pixels * 2u);
    if (!p) rc_abort("surface row at 0x%x not contiguous", s->buf + (uint32_t)y * s->pitch);
    return p;
}

static void blit(Surface *d, int32_t dx, int32_t dy, const Surface *s, int32_t sx, int32_t sy, int32_t w, int32_t h, int use_key, int32_t dw, int32_t dh)
{
    d->blits++;
    if (w <= 0 || h <= 0) return;
    int stretch = (dw != w || dh != h) && dw > 0 && dh > 0;
    int32_t rows = stretch ? dh : h, n = stretch ? dw : w;
    uint16_t key = (uint16_t)s->ckey;
    uint16_t line[8192];
    if (n > 8192) return;
    for (int32_t j = 0; j < rows; j++) {
        int32_t ty = dy + j;
        if (ty < 0 || ty >= (int32_t)d->h) continue;
        int32_t syy = sy + (stretch ? (int32_t)((int64_t)j * h / dh) : j);
        if (syy < 0 || syy >= (int32_t)s->h) continue;
        int32_t x0 = dx > 0 ? dx : 0, x1 = dx + n < (int32_t)d->w ? dx + n : (int32_t)d->w;
        if (x1 <= x0) continue;
        const uint8_t *srow = surf_row(s, syy, sx, (uint32_t)w);
        if (stretch) {
            for (int32_t i = x0; i < x1; i++) {
                int32_t si = (int32_t)((int64_t)(i - dx) * w / dw);
                memcpy(&line[i - x0], srow + 2 * si, 2);
            }
        } else {
            memcpy(line, srow + 2 * (x0 - dx), (size_t)(x1 - x0) * 2);
        }
        uint8_t *dst = surf_row(d, ty, x0, (uint32_t)(x1 - x0));
        if (!use_key) {
            memmove(dst, line, (size_t)(x1 - x0) * 2);
        } else {
            for (int32_t i = 0; i < x1 - x0; i++)
                if (line[i] != key) memcpy(dst + 2 * i, &line[i], 2);
        }
    }
}

API(S_Blt)
{
    (void)r;
    Surface *d = surf(a[0]);
    if (!d) RET(0);
    int32_t dr[4];
    get_rect(a[1], d, dr);
    if (a[4] & 0x400u) {                                      /* DDBLT_COLORFILL */
        uint16_t color = (uint16_t)rc_u32(a[5] + 0x50);
        int32_t x0 = dr[0] > 0 ? dr[0] : 0, x1 = dr[2] < (int32_t)d->w ? dr[2] : (int32_t)d->w;
        for (int32_t y = dr[1] > 0 ? dr[1] : 0; y < dr[3] && y < (int32_t)d->h; y++) {
            if (x1 <= x0) break;
            uint16_t *row = (uint16_t *)surf_row(d, y, x0, (uint32_t)(x1 - x0));
            for (int32_t i = 0; i < x1 - x0; i++) row[i] = color;
        }
        present_note(d, 0);
        RET(0);
    }
    Surface *s = surf(a[2]);
    if (!s) RET(0);
    int32_t sr[4];
    get_rect(a[3], s, sr);
    blit(d, dr[0], dr[1], s, sr[0], sr[1], sr[2] - sr[0], sr[3] - sr[1], (a[4] & 0x8000u) && s->has_ckey, dr[2] - dr[0], dr[3] - dr[1]);
    present_note(d, 0);
    RET(0);
}
API(S_BltFast)
{
    (void)r;
    Surface *d = surf(a[0]), *s = surf(a[3]);
    if (!d || !s) RET(0);
    int32_t sr[4];
    get_rect(a[4], s, sr);
    blit(d, (int32_t)a[1], (int32_t)a[2], s, sr[0], sr[1], sr[2] - sr[0], sr[3] - sr[1], (a[5] & 1u) && s->has_ckey, sr[2] - sr[0], sr[3] - sr[1]);
    present_note(d, 1);
    RET(0);
}

/* ------------------------------------------------------------------ vtables (the order of ddraw.h) */
#define M(n, k, f) {n, k, f}
static const RcMethod dd7_methods[] = {
    M("QueryInterface", 2, api_DD_QueryInterface), M("AddRef", 0, api_DD_AddRef), M("Release", 0, api_DD_Release), M("Compact", 0, NULL),
    M("CreateClipper", 3, api_DD_CreateClipper), M("CreatePalette", 4, api_DD_CreatePalette), M("CreateSurface", 3, api_DD_CreateSurface),
    M("DuplicateSurface", 2, NULL), M("EnumDisplayModes", 4, api_DD_EnumDisplayModes), M("EnumSurfaces", 4, NULL), M("FlipToGDISurface", 0, api_DD_Zero),
    M("GetCaps", 2, api_DD_GetCaps), M("GetDisplayMode", 1, api_DD_GetDisplayMode), M("GetFourCCCodes", 2, NULL), M("GetGDISurface", 1, api_DD_GetGDISurface),
    M("GetMonitorFrequency", 1, api_DD_GetMonitorFrequency), M("GetScanLine", 1, NULL), M("GetVerticalBlankStatus", 1, NULL), M("Initialize", 1, NULL),
    M("RestoreDisplayMode", 0, api_DD_Zero), M("SetCooperativeLevel", 2, api_DD_SetCooperativeLevel), M("SetDisplayMode", 5, api_DD_SetDisplayMode),
    M("WaitForVerticalBlank", 2, api_DD_Zero), M("GetAvailableVidMem", 3, api_DD_GetAvailableVidMem), M("GetSurfaceFromDC", 2, NULL),
    M("RestoreAllSurfaces", 0, api_DD_Zero), M("TestCooperativeLevel", 0, api_DD_Zero), M("GetDeviceIdentifier", 2, api_DD_GetDeviceIdentifier),
    M("StartModeTest", 3, NULL), M("EvaluateMode", 2, NULL),
};
static const RcMethod dds7_methods[] = {
    M("QueryInterface", 2, api_S_QueryInterface), M("AddRef", 0, api_S_AddRef), M("Release", 0, api_S_Release), M("AddAttachedSurface", 1, NULL),
    M("AddOverlayDirtyRect", 1, NULL), M("Blt", 5, api_S_Blt), M("BltBatch", 3, NULL), M("BltFast", 5, api_S_BltFast), M("DeleteAttachedSurface", 2, NULL),
    M("EnumAttachedSurfaces", 2, NULL), M("EnumOverlayZOrders", 3, NULL), M("Flip", 2, api_S_Flip), M("GetAttachedSurface", 2, api_S_GetAttachedSurface),
    M("GetBltStatus", 1, api_DD_Zero), M("GetCaps", 1, api_S_GetCaps), M("GetClipper", 1, NULL), M("GetColorKey", 2, api_S_GetColorKey),
    M("GetDC", 1, api_S_GetDC), M("GetFlipStatus", 1, api_DD_Zero), M("GetOverlayPosition", 2, NULL), M("GetPalette", 1, NULL),
    M("GetPixelFormat", 1, api_S_GetPixelFormat), M("GetSurfaceDesc", 1, api_S_GetSurfaceDesc), M("Initialize", 2, NULL), M("IsLost", 0, api_DD_Zero),
    M("Lock", 4, api_S_Lock), M("ReleaseDC", 1, api_DD_Zero), M("Restore", 0, api_DD_Zero), M("SetClipper", 1, api_DD_Zero), M("SetColorKey", 2, api_S_SetColorKey),
    M("SetOverlayPosition", 2, NULL), M("SetPalette", 1, api_DD_Zero), M("Unlock", 1, api_DD_Zero), M("UpdateOverlay", 5, NULL), M("UpdateOverlayDisplay", 1, NULL),
    M("UpdateOverlayZOrder", 2, NULL), M("GetDDInterface", 1, NULL), M("PageLock", 1, NULL), M("PageUnlock", 1, NULL), M("SetSurfaceDesc", 2, api_S_SetSurfaceDesc),
    M("SetPrivateData", 4, NULL), M("GetPrivateData", 3, NULL), M("FreePrivateData", 1, NULL), M("GetUniquenessValue", 1, NULL), M("ChangeUniquenessValue", 0, NULL),
    M("SetPriority", 1, NULL), M("GetPriority", 1, NULL), M("SetLOD", 1, NULL), M("GetLOD", 1, NULL),
};
static const RcMethod clipper_methods[] = {
    M("QueryInterface", 2, api_Obj_QueryInterface), M("AddRef", 0, api_Obj_AddRef), M("Release", 0, api_Obj_Release), M("GetClipList", 3, NULL),
    M("GetHWnd", 1, NULL), M("Initialize", 2, NULL), M("IsClipListChanged", 1, NULL), M("SetClipList", 2, NULL), M("SetHWnd", 2, api_DD_Zero),
};
static const RcMethod palette_methods[] = {
    M("QueryInterface", 2, api_Obj_QueryInterface), M("AddRef", 0, api_Obj_AddRef), M("Release", 0, api_Obj_Release), M("GetCaps", 1, NULL),
    M("GetEntries", 4, NULL), M("Initialize", 3, NULL), M("SetEntries", 4, NULL),
};

typedef struct DdName { const char *name; RcApiFn fn; } DdName;
static const DdName entry_points[] = {
    {"DirectDrawEnumerateExA", api_DirectDrawEnumerateExA}, {"DirectDrawCreateEx", api_DirectDrawCreateEx}, {"DirectDrawCreate", api_DirectDrawCreate},
};

int rc_ddraw_resolve(const char *name, RcApiFn *fn)
{
    for (size_t i = 0; i < sizeof entry_points / sizeof entry_points[0]; i++)
        if (!strcmp(entry_points[i].name, name)) { *fn = entry_points[i].fn; return 1; }
    return 0;
}

void rc_ddraw_init(void)
{
    display_w = 640; display_h = 480;
    primary_surface = NULL;
}

static uint32_t new_ddraw_obj(DDraw *d) { return rc_com_new("IDirectDraw7", dd7_methods, (int)(sizeof dd7_methods / sizeof dd7_methods[0]), d); }
static uint32_t new_surface_obj(Surface *s) { return rc_com_new("IDirectDrawSurface7", dds7_methods, (int)(sizeof dds7_methods / sizeof dds7_methods[0]), s); }
static uint32_t new_clipper_obj(void) { return rc_com_new("IDirectDrawClipper", clipper_methods, (int)(sizeof clipper_methods / sizeof clipper_methods[0]), NULL); }
static uint32_t new_palette_obj(void) { return rc_com_new("IDirectDrawPalette", palette_methods, (int)(sizeof palette_methods / sizeof palette_methods[0]), NULL); }
