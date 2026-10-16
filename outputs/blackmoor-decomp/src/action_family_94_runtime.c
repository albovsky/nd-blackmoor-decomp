#include "action_family_94_runtime.h"

#include <string.h>

static uint16_t rd16(const uint8_t *p)
{
    return (uint16_t)(p[0] | (p[1] << 8));
}

static void wr16(uint8_t *p, uint16_t v)
{
    p[0] = (uint8_t)v;
    p[1] = (uint8_t)(v >> 8);
}

static void wr32(uint8_t *p, uint32_t v)
{
    wr16(p, (uint16_t)v);
    wr16(p + 2, (uint16_t)(v >> 16));
}

static int32_t rds32(const uint8_t *p)
{
    return (int32_t)((uint32_t)rd16(p) | ((uint32_t)rd16(p + 2) << 16));
}

void a94_request_from_body(const uint8_t body[A94_BODY_BYTES], A94Request *out)
{
    memcpy(out->name, body, A94_NAME_BYTES);
    out->x0 = rds32(body + 0x21);
    out->y0 = rds32(body + 0x25);
    out->x1 = rds32(body + 0x29);
    out->y1 = rds32(body + 0x2d);
    out->format = body[0x31];
}

int a94_capture_reachable(const A94Screen *screen, const A94Request *request)
{
    /* 0x4c36f0: cmp [body+0x2d], height; 0x4c3715: cmp [body+0x29], width (signed). */
    return request->y1 <= (int32_t)screen->height && request->x1 <= (int32_t)screen->width;
}

int a94_request_valid(const A94Screen *screen, const A94Request *request)
{
    return screen->bytes_per_pixel == 2 && screen->width > 0 && screen->height > 0 && request->x0 >= 0 &&
           request->y0 >= 0 && request->x0 < request->x1 && request->y0 < request->y1 &&
           request->x1 <= (int32_t)screen->width && request->y1 <= (int32_t)screen->height;
}

const char *a94_extension(const A94Request *request)
{
    return request->format == 0u ? ".BMP" : ".TGA";
}

A94Status a94_make_path(char *out, size_t capacity, const char *drive, const char *dir, const char *name,
                        const char *ext)
{
    size_t n = 0u;
    size_t k, len;
    if (out == NULL || capacity == 0u) {
        return A94_ERR_ARGUMENT;
    }
#define PUT(c) do { if (n + 1u >= capacity) { return A94_ERR_CAPACITY; } out[n++] = (char)(c); } while (0)
    if (drive != NULL && drive[0] != '\0') {
        PUT(drive[0]);
        PUT(':');
    }
    if (dir != NULL && dir[0] != '\0') {
        len = strlen(dir);
        for (k = 0u; k < len; ++k) {
            PUT(dir[k]);
        }
        if (dir[len - 1u] != '/' && dir[len - 1u] != '\\') {
            PUT('\\');
        }
    }
    if (name != NULL) {
        for (k = 0u; name[k] != '\0'; ++k) {
            PUT(name[k]);
        }
    }
    if (ext != NULL) {
        if (ext[0] != '\0' && ext[0] != '.') {
            PUT('.');
        }
        for (k = 0u; ext[k] != '\0'; ++k) {
            PUT(ext[k]);
        }
    }
    out[n] = '\0';
#undef PUT
    return A94_OK;
}

/* 0x4c7481: bring a 5-6-5 (or 6-5-5, 5-5-6) word to 5-5-5. The channel with six bits loses its low bit. */
static uint16_t to_555(const A94Screen *s, uint16_t pixel)
{
    uint16_t r = (uint16_t)((pixel >> (s->shifts[2] & 0x1f)) & s->masks[2]);
    uint16_t g = (uint16_t)((pixel >> (s->shifts[1] & 0x1f)) & s->masks[1]);
    uint16_t b = (uint16_t)((pixel >> (s->shifts[0] & 0x1f)) & s->masks[0]);
    if (s->channel_bits[2] == 5u) {
        if (s->channel_bits[1] == 5u) {
            if (s->channel_bits[0] != 5u) {
                b = (uint16_t)(b >> 1);
            }
        } else {
            g = (uint16_t)(g >> 1);
        }
    } else {
        r = (uint16_t)(r >> 1);
    }
    return (uint16_t)((r << 10) | (g << 5) | b);
}

A94Status a94_encode(const A94Screen *screen, const A94Request *request, const uint8_t *screen_pixels, uint8_t *out,
                     size_t capacity, size_t *length)
{
    size_t w, h, stride = 0u, data, total, x, y;
    const size_t screen_stride = screen == NULL ? 0u : (size_t)(uint16_t)screen->width * 2u;

    if (screen == NULL || request == NULL || length == NULL || (out != NULL && screen_pixels == NULL)) {
        return A94_ERR_ARGUMENT;
    }
    if (!a94_request_valid(screen, request)) {
        return A94_ERR_DOMAIN;
    }
    w = (size_t)(request->x1 - request->x0);
    h = (size_t)(request->y1 - request->y0);
    if (request->format == 0u) {
        stride = (3u * w + 3u) & ~(size_t)3u;
        if (stride > 0x7fffu) {
            return A94_ERR_DOMAIN; /* (short) cast in the original */
        }
        data = stride * h;
        total = 14u + 40u + data;
    } else {
        data = w * h * 2u;
        total = 18u + data;
    }
    if (out == NULL) {
        *length = total;
        return A94_OK;
    }
    if (capacity < total) {
        return A94_ERR_CAPACITY;
    }
    memset(out, 0, total);
    if (request->format == 0u) {
        uint8_t *rows = out + 54u;
        out[0] = 'B';
        out[1] = 'M';
        wr32(out + 2, (uint32_t)(data + 0x36u));
        wr32(out + 10, 0x36u);
        wr32(out + 14, 0x28u);
        wr32(out + 18, (uint32_t)w);
        wr32(out + 22, (uint32_t)h);
        wr16(out + 26, 1u);
        wr16(out + 28, 0x18u);
        wr32(out + 34, (uint32_t)data);
        for (y = 0u; y < h; ++y) {
            /* source row y lands on file row h-1-y (0x4c3637 counts local_18 down from the height) */
            uint8_t *dst = rows + (h - 1u - y) * stride;
            const uint8_t *src = screen_pixels + ((size_t)request->y0 + y) * screen_stride + (size_t)request->x0 * 2u;
            for (x = 0u; x < w; ++x) {
                const uint16_t v = to_555(screen, rd16(src + 2u * x));
                dst[3u * x + 0u] = (uint8_t)(v << 3);
                dst[3u * x + 1u] = (uint8_t)((v >> 5) << 3);
                dst[3u * x + 2u] = (uint8_t)((v >> 10) << 3);
            }
        }
    } else {
        uint8_t *rows = out + 18u;
        out[2] = 2u;
        wr16(out + 12, (uint16_t)w);
        wr16(out + 14, (uint16_t)h);
        out[16] = screen->bits_per_pixel;
        out[17] = 0x20u;
        for (y = 0u; y < h; ++y) {
            const uint8_t *src = screen_pixels + ((size_t)request->y0 + y) * screen_stride + (size_t)request->x0 * 2u;
            for (x = 0u; x < w; ++x) {
                wr16(rows + (y * w + x) * 2u, to_555(screen, rd16(src + 2u * x)));
            }
        }
    }
    *length = total;
    return A94_OK;
}
