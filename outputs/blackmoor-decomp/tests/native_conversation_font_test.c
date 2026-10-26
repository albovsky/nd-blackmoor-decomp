#include "native_conversation_caption.h"

#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define WIDTH 64
#define HEIGHT 64
#define FONT_COUNT 10
#define PIXEL_BYTES (WIDTH * HEIGHT * 2)
#define CHECK(expr) do { if (!(expr)) { \
    fprintf(stderr, "CHECK line=%d expression=%s\n", __LINE__, #expr); return 1; \
} } while (0)
#define EXPECT(call, expected) do { int actual_ = (call); if (actual_ != (expected)) { \
    fprintf(stderr, "CHECK line=%d status=%d expected=%d expression=%s\n", __LINE__, actual_, (expected), #call); return 1; \
} } while (0)

typedef struct Event { char kind; int16_t font; } Event;
typedef struct Fixture {
    CaptionFonts fonts;
    CaptionGeometry geometry;
    CaptionPixelFormat format;
    CaptionGlobals globals;
    CaptionBackend backend;
    CaptionSurface targets[2];
    uint8_t pixels[2][PIXEL_BYTES];
    uint8_t sheets[FONT_COUNT][2 * 18 * 2];
    Event events[32];
    size_t event_count;
    unsigned loads[FONT_COUNT];
    uint8_t live[FONT_COUNT];
    int fail_font, callback_bad, check_old_flush;
} Fixture;

static void unexpected_signal(int signum)
{
    static const char message[] = "CHECK unexpected native signal\n";
    (void)signum; (void)write(STDERR_FILENO, message, sizeof(message) - 1u); _exit(1);
}
static void put16(uint8_t *p, int value)
{ p[0] = (uint8_t)value; p[1] = (uint8_t)((unsigned)value >> 8); }
static void put32(uint8_t *p, int value)
{ for (unsigned i = 0; i < 4u; ++i) p[i] = (uint8_t)((unsigned)value >> (8u * i)); }
static uint16_t get16(const uint8_t *p)
{ return (uint16_t)(p[0] | ((uint16_t)p[1] << 8)); }
static uint16_t pixel(const Fixture *f, unsigned pass, unsigned x, unsigned y)
{ return get16(f->pixels[pass] + (y * WIDTH + x) * 2u); }
static uint16_t ink(unsigned font, unsigned color)
{ return (uint16_t)(0x0400u + font + color * 0x100u); }
static int font_height(int font) { return font == 2 ? 9 : 3; }
static CaptionSurface sheet_view(Fixture *f, int font)
{ return (CaptionSurface){ f->sheets[font], 2, (int16_t)(2 * font_height(font)), 4 }; }
static void event(Fixture *f, char kind, int16_t font)
{
    if (f->event_count >= sizeof(f->events) / sizeof(f->events[0])) { f->callback_bad = 1; return; }
    f->events[f->event_count++] = (Event){ kind, font };
}
static CaptionBackendStatus load_sheet(void *context, int16_t font, const char *name,
    CaptionSurface *sheet)
{
    Fixture *f = context;
    if (font < 0 || font >= FONT_COUNT || name == NULL) { f->callback_bad = 1; return CAPTION_BACKEND_ERROR; }
    event(f, 'L', font);
    if (f->check_old_flush && font == 2) {
        unsigned pass = f->loads[font];
        if (pass > 1u || pixel(f, pass, 2u, 10u) != ink(8u + pass, 0u)) f->callback_bad = 1;
    }
    ++f->loads[font];
    if (f->globals.sheet_refcount[font] != 0 || f->live[font]) f->callback_bad = 1;
    if (font == f->fail_font) return CAPTION_BACKEND_ERROR;
    f->live[font] = 1u;
    *sheet = sheet_view(f, font);
    return CAPTION_BACKEND_OK;
}
static void release_sheet(void *context, int16_t font, CaptionSurface *sheet)
{
    Fixture *f = context;
    if (font < 0 || font >= FONT_COUNT) { f->callback_bad = 1; return; }
    event(f, 'R', font);
    if (!f->live[font] || sheet->pixels != f->sheets[font] || f->globals.sheet_refcount[font] != 0)
        f->callback_bad = 1;
    f->live[font] = 0u;
}

static int setup(Fixture *f)
{
    uint8_t records[FONT_COUNT * CAPTION_FONT_RECORD_BYTES] = {0};
    uint8_t tbox[CAPTION_TBOX_BYTES] = {0};
    const uint8_t transparent[3] = {31, 0, 31};
    memset(f, 0, sizeof(*f)); f->fail_font = -1;
    for (int font = 0; font < FONT_COUNT; ++font) {
        uint8_t *r = records + (size_t)font * CAPTION_FONT_RECORD_BYTES;
        int h = font_height(font);
        (void)snprintf((char *)r, CAPTION_FONT_NAME_BYTES, "synthetic%d", font);
        put32(r + 0x4b, h); /* Color1 source y; color0 uses (0,0). */
        put16(r + 0x4f, 2); put16(r + 0x53, 0); put16(r + 0x55, 26); put16(r + 0x57, 52);
        for (size_t glyph = 0; glyph < CAPTION_FONT_GLYPHS; ++glyph) {
            uint8_t *rect = r + 0xc3 + glyph * 16u;
            put32(rect + 8, 1); put32(rect + 12, h - 1);
        }
        for (int y = 0; y < h * 2; ++y) for (int x = 0; x < 2; ++x)
            put16(f->sheets[font] + (size_t)(y * 2 + x) * 2u, ink((unsigned)font, (unsigned)(y / h)));
    }
    EXPECT(caption_fonts_init(records, sizeof(records), FONT_COUNT, &f->fonts), CAPTION_OK);
    /* Fonts1/8/9 deliberately share ALL glyph metrics, as in the owned data.
     * Their pixel words differ: selecting the wrong sheet remains observable. */
    CHECK(memcmp(f->fonts.glyph_size[1], f->fonts.glyph_size[8], sizeof(f->fonts.glyph_size[1])) == 0);
    CHECK(memcmp(f->fonts.glyph_size[1], f->fonts.glyph_size[9], sizeof(f->fonts.glyph_size[1])) == 0);
    put32(tbox + 0x0c, HEIGHT - 1); put32(tbox + 0x18, WIDTH - 1); put32(tbox + 0x1c, HEIGHT - 1);
    put16(tbox + 0x20, 12); put16(tbox + 0x22, 1); put16(tbox + 0x24, 2); put16(tbox + 0x26, 2);
    put32(tbox + 0x40, WIDTH - 1); put32(tbox + 0x44, HEIGHT - 1);
    put16(tbox + 0x54, 8); put16(tbox + 0x56, 9);
    EXPECT(caption_geometry_init(tbox, sizeof(tbox), &f->geometry), CAPTION_OK);
    EXPECT(caption_pixel_format_from_masks(0x7c00, 0x03e0, 0x001f, transparent, &f->format), CAPTION_OK);
    memset(f->pixels, 0xa5, sizeof(f->pixels));
    for (unsigned i = 0; i < 2u; ++i) f->targets[i] = (CaptionSurface){ f->pixels[i], WIDTH, HEIGHT, WIDTH * 2 };
    f->backend.context = f; f->backend.load_font_sheet = load_sheet; f->backend.release_font_sheet = release_sheet;
    return 0;
}
static int write_text(Fixture *f, const char *text, NativeConversationCaptionResult *result)
{
    return native_conversation_caption_write((const uint8_t *)text, strlen(text), &f->fonts,
        &f->geometry, &f->format, &f->globals, &f->backend, f->targets, result);
}
static int balanced(const Fixture *f, int held_font)
{
    CHECK(!f->callback_bad);
    for (int font = 0; font < FONT_COUNT; ++font) {
        CHECK(f->globals.sheet_refcount[font] == (font == held_font ? 1 : 0));
        CHECK((f->globals.sheets[font].pixels != NULL) == (font == held_font));
        CHECK(f->live[font] == (font == held_font));
    }
    return 0;
}
static int events_are(const Fixture *f, const int *fonts, size_t count)
{
    CHECK(f->event_count == count * 2u);
    for (size_t i = 0; i < count; ++i) {
        CHECK(f->events[2u * i].kind == 'L' && f->events[2u * i].font == fonts[i]);
        CHECK(f->events[2u * i + 1u].kind == 'R' && f->events[2u * i + 1u].font == fonts[i]);
    }
    return 0;
}

static int absolute_pixels_and_atoi(void)
{
    static const char *arguments[] = { "1", "65537", "  +1tail" };
    const int trace[] = {8, 1, 9, 9, 1, 9};
    for (size_t n = 0; n < sizeof(arguments) / sizeof(arguments[0]); ++n) {
        Fixture f;
        NativeConversationCaptionResult result;
        char text[96];
        CHECK(setup(&f) == 0);
        (void)snprintf(text, sizeof(text), "<i>A<f%s>B<c1><f9>C<n><o>", arguments[n]);
        EXPECT(native_conversation_caption_validate((const uint8_t *)text, strlen(text),
            &f.fonts, &f.geometry, &f.format), CAPTION_OK);
        CHECK(f.event_count == 0u);
        EXPECT(write_text(&f, text, &result), CAPTION_OK);
        CHECK(result.glyphs[0] == 3u && result.glyphs[1] == 3u);
        for (unsigned pass = 0; pass < 2u; ++pass) {
            CHECK(pixel(&f, pass, 2u, 12u) == ink(8u + pass, 0u));
            CHECK(pixel(&f, pass, 4u, 12u) == ink(1u, 0u));
            CHECK(pixel(&f, pass, 6u, 12u) == ink(9u, 1u)); /* Color survives f9. */
            CHECK(pixel(&f, pass, 8u, 12u) == 0u && result.bottom[pass] == 18);
        }
        CHECK(events_are(&f, trace, sizeof(trace) / sizeof(trace[0])) == 0 && balanced(&f, -1) == 0);
    }
    return 0;
}

static int old_font_empty_newline_flush(void)
{
    const char *texts[] = { "<i>A<n><f2>B<n><o>", "<i>A<w><f2>B<n><o>" };
    const int baseline[] = {15, 13}, bottom[] = {28, 26};
    const int trace[] = {8, 2, 9, 2};
    for (unsigned n = 0; n < 2u; ++n) {
        Fixture f;
        NativeConversationCaptionResult result;
        CHECK(setup(&f) == 0); f.check_old_flush = 1;
        EXPECT(write_text(&f, texts[n], &result), CAPTION_OK);
        for (unsigned pass = 0; pass < 2u; ++pass) {
            CHECK(pixel(&f, pass, 2u, (unsigned)baseline[n]) == ink(2u, 0u));
            CHECK(pixel(&f, pass, 2u, (unsigned)baseline[n] + 1u) == 0u);
            CHECK(result.bottom[pass] == bottom[n] && result.glyphs[pass] == 2u);
        }
        CHECK(events_are(&f, trace, sizeof(trace) / sizeof(trace[0])) == 0 && balanced(&f, -1) == 0);
    }
    return 0;
}

static int same_font_and_shared_reference(void)
{
    Fixture f;
    NativeConversationCaptionResult result;
    const int trace[] = {8, 8, 9, 8};
    CHECK(setup(&f) == 0);
    f.globals.sheet_refcount[1] = 1;
    f.globals.sheets[1] = sheet_view(&f, 1); f.live[1] = 1u; /* Valid caller-owned reference. */
    EXPECT(write_text(&f, "<i>A<f8>B<f1>C<n><o>", &result), CAPTION_OK);
    for (unsigned pass = 0; pass < 2u; ++pass) {
        CHECK(pixel(&f, pass, 2u, 12u) == ink(8u + pass, 0u));
        CHECK(pixel(&f, pass, 4u, 12u) == ink(8u, 0u));
        CHECK(pixel(&f, pass, 6u, 12u) == ink(1u, 0u));
    }
    CHECK(events_are(&f, trace, sizeof(trace) / sizeof(trace[0])) == 0);
    CHECK(f.loads[8] == 3u && f.loads[1] == 0u && balanced(&f, 1) == 0);
    return 0;
}

static int failures_preserve_ownership(void)
{
    const char *invalid[] = { "<i>A<f10>B<n><o>", "<i>A<f-1>B<n><o>", "<i>A<f65535>B<n><o>" };
    for (size_t n = 0; n < sizeof(invalid) / sizeof(invalid[0]); ++n) {
        Fixture f;
        CaptionGlobals globals;
        NativeConversationCaptionResult result, before;
        CHECK(setup(&f) == 0); globals = f.globals;
        memset(&result, 0x6d, sizeof(result)); before = result;
        EXPECT(native_conversation_caption_validate((const uint8_t *)invalid[n], strlen(invalid[n]),
            &f.fonts, &f.geometry, &f.format), CAPTION_ERR_FONT);
        EXPECT(write_text(&f, invalid[n], &result), CAPTION_ERR_FONT);
        CHECK(f.event_count == 0u && memcmp(&f.globals, &globals, sizeof(globals)) == 0);
        CHECK(memcmp(&result, &before, sizeof(result)) == 0);
        for (size_t i = 0; i < sizeof(f.pixels); ++i) CHECK(((const uint8_t *)f.pixels)[i] == 0xa5u);
    }
    for (unsigned held = 0; held < 2u; ++held) {
        Fixture f;
        NativeConversationCaptionResult result, before;
        CHECK(setup(&f) == 0); f.fail_font = 1;
        if (held) { f.globals.sheet_refcount[8] = 1; f.globals.sheets[8] = sheet_view(&f, 8); f.live[8] = 1u; }
        memset(&result, 0x6d, sizeof(result)); before = result;
        EXPECT(write_text(&f, "<i>A<f1>B<n><o>", &result), CAPTION_ERR_BACKEND);
        CHECK(balanced(&f, held ? 8 : -1) == 0 && memcmp(&result, &before, sizeof(result)) == 0);
        CHECK(pixel(&f, 0u, 2u, 12u) == ink(8u, 0u) && pixel(&f, 0u, 4u, 12u) == 0u);
        for (size_t i = 0; i < sizeof(f.pixels[1]); ++i) CHECK(f.pixels[1][i] == 0xa5u);
        CHECK(f.event_count == (held ? 1u : 3u));
        CHECK(f.events[f.event_count - 1u].kind == 'L' && f.events[f.event_count - 1u].font == 1);
    }
    return 0;
}

int main(int argc, char **argv)
{
    int result = 1;
    (void)signal(SIGABRT, unexpected_signal); (void)signal(SIGBUS, unexpected_signal);
    (void)signal(SIGFPE, unexpected_signal); (void)signal(SIGILL, unexpected_signal); (void)signal(SIGSEGV, unexpected_signal);
    if (argc != 2) return 1;
    if (strcmp(argv[1], "absolute") == 0) result = absolute_pixels_and_atoi();
    else if (strcmp(argv[1], "newline") == 0) result = old_font_empty_newline_flush();
    else if (strcmp(argv[1], "same") == 0) result = same_font_and_shared_reference();
    else if (strcmp(argv[1], "errors") == 0) result = failures_preserve_ownership();
    if (!result) printf("PASS native_conversation_fonts %s\n", argv[1]);
    return result;
}
