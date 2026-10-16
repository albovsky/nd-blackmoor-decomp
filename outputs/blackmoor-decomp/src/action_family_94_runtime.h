#ifndef BLACKMOOR_ACTION_FAMILY_94_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_94_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* RT-32: raw 0x94 "make a screen file" (the original's AT_MAKE_SCREEN_FILE). Handler 0x4c36b2 (thiscall on the
 * CDirectDraw object 0x5cf659) behind dispatcher arm 0x429747. This module is the pure part: the 50-byte body, the
 * rectangle rules, the file name (0x50cd72 _makepath) and the two file encodings. The state machine and the host effects
 * (front-buffer capture, flags, file write) live in session_bindings_a94.c. */

#define A94_BODY_BYTES 50u
#define A94_NAME_BYTES 33u
#define A94_PATH_BYTES 512u
/* Phase word values of the row (0x5bb632): 0 starts, 2 captures, 3 completes. */
#define A94_PHASE_START 0u
#define A94_PHASE_CAPTURE 2u
#define A94_PHASE_DONE 3u

typedef enum {
    A94_OK = 0,
    A94_ERR_ARGUMENT = 1,
    /* The original would read or write outside its buffers (or allocate nothing); native refuses before any effect. */
    A94_ERR_DOMAIN = 2,
    A94_ERR_CAPACITY = 3
} A94Status;

/* Body layout (loader arm 0x40ea5e copies the 50 bytes; handler reads them as below). */
typedef struct {
    char name[A94_NAME_BYTES]; /* +0x00 file name stem, NUL inside the 33 bytes is not required by the loader */
    int32_t x0;                /* +0x21 */
    int32_t y0;                /* +0x25 */
    int32_t x1;                /* +0x29 */
    int32_t y1;                /* +0x2d */
    uint8_t format;            /* +0x31: 0 = 24-bit BMP (0x4c334f), nonzero = TGA (inline in 0x4c36b2) */
} A94Request;

/* Display state the handler reads: DAT_0063988b/0063988d (width, height), DAT_00639895 (bytes per pixel),
 * DAT_00639893 (bits per pixel, TGA header) and the pixel format at CDirectDraw+0x38c0 (shifts, masks) and +0x38c8
 * (channel widths); index 0 is blue, 1 green, 2 red as in caption_pixel_format. */
typedef struct {
    int16_t width;
    int16_t height;
    int16_t bytes_per_pixel;
    uint8_t bits_per_pixel;
    uint8_t shifts[3];
    uint8_t masks[3];
    uint8_t channel_bits[3];
} A94Screen;

void a94_request_from_body(const uint8_t body[A94_BODY_BYTES], A94Request *out);

/* The test at 0x4c36fd..0x4c3777: the capture runs only when y1 <= height and x1 <= width (signed). Otherwise the row
 * stays in phase 2 and does nothing, forever. */
int a94_capture_reachable(const A94Screen *screen, const A94Request *request);

/* Native domain of the capture: 16-bit pixels, 0 <= x0 < x1 <= width, 0 <= y0 < y1 <= height. Outside it the original
 * allocates a buffer of non-positive or mismatched size, or copies from before the screen buffer (undefined). */
int a94_request_valid(const A94Screen *screen, const A94Request *request);

/* ".BMP" (0x554114) for format 0, ".TGA" (0x554238) otherwise. */
const char *a94_extension(const A94Request *request);

/* 0x50cd72 _makepath(path, drive, dir, name, ext) as the original builds the file path. NULL or empty drive and dir
 * are skipped; only the first drive character is used; a dir not ending in a slash gets a backslash; ext gets a
 * leading dot when it lacks one. */
A94Status a94_make_path(char *out, size_t capacity, const char *drive, const char *dir, const char *name,
                        const char *ext);

/* Bytes of the file for the rectangle of the packed screen (width * bytes_per_pixel per row, no padding):
 *   format 0 -> 0x4c334f: 14-byte BM header, 40-byte info header, 24-bit bottom-up rows padded to four bytes (pad bytes
 *               are uninitialised heap in the original; native writes zero);
 *   else     -> 18-byte TGA header (type 2, top-left origin, bits per pixel from the display) then the cropped 16-bit
 *               words, both after the 0x4c7481 conversion to 5-5-5.
 * With out == NULL only the size is returned. */
A94Status a94_encode(const A94Screen *screen, const A94Request *request, const uint8_t *screen_pixels, uint8_t *out,
                     size_t capacity, size_t *length);

#ifdef __cplusplus
}
#endif
#endif
