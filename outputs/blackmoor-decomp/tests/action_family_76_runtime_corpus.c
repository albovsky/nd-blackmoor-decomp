/* RT-58 corpus check: runs every raw 0x76 row of the decoded scene resources given on the command line through the production
 * parser, the session binding and the kernel with a scripted host. Per row: begin_scene validates the body; a run types a wrong
 * word (one that contains no accepted word, chosen from the body), leaves through the wrong sound and the wrong exit; every
 * accepted word is typed in three letter cases with extra letters around it and leaves through the success sound and the
 * correct exit; Backspace and the cursor blink are exercised; the cancel strip is hit on its edges and misses just outside, the
 * click leaves through the cancel exit, and a click after a correct answer does nothing. Output is derived counts only: one
 * "ROW_FAIL ..." line per failing check and a final "SUMMARY ..." line. The accepted words and resource bytes stay in work/. */
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_resource.h"
#include "session_bindings_a76.h"

typedef struct {
    uint32_t now;
    int prepares, plays, stops, busy_calls, busy_left, transitions, flag_stores, completes, widths, releases, acquires;
    int16_t scene;
    int16_t flag_index;
    uint32_t flag_value;
    int32_t start_flag;
} Ctx;

static int view_origin(void *c, int32_t *x, int32_t *y) { (void)c; *x = 7; *y = 11; return 0; }
static int font_acquire(void *c, int16_t f) { (void)f; ((Ctx *)c)->acquires++; return 0; }
static int font_release(void *c, int16_t f) { (void)f; ((Ctx *)c)->releases++; return 0; }
static int text_width(void *c, int16_t f, const char *t, int16_t *w)
{
    (void)f;
    ((Ctx *)c)->widths++;
    *w = (int16_t)(strlen(t) * 8u);
    return 0;
}
static uint32_t tick(void *c) { return ((Ctx *)c)->now; }
static int sound_prepare(void *c, const uint8_t *r) { (void)r; ((Ctx *)c)->prepares++; return 0; }
static int sound_stop(void *c, const uint8_t *r) { (void)r; ((Ctx *)c)->stops++; return 0; }
static int sound_play(void *c, int16_t ch) { (void)ch; ((Ctx *)c)->plays++; return 0; }
static int sound_busy(void *c, int16_t ch, int32_t *res)
{
    Ctx *x = (Ctx *)c;
    (void)ch;
    x->busy_calls++;
    *res = x->busy_left > 0 ? x->busy_left-- : 0;
    return 0;
}
static int flag_invalid(void *c, int16_t i) { (void)c; return i < 0 || i >= 4096; }
static int transition(void *c, const PwdTransition *t)
{
    Ctx *x = (Ctx *)c;
    x->transitions++;
    x->scene = t->scene;
    return 0;
}
static int store_flag(void *c, int16_t i, uint32_t v)
{
    Ctx *x = (Ctx *)c;
    x->flag_stores++;
    x->flag_index = i;
    x->flag_value = v;
    return 0;
}
static void observe(void *c, int effect, int32_t a, int32_t b)
{
    Ctx *x = (Ctx *)c;
    (void)b;
    if (effect == PWD_FX_COMPLETE) x->completes++;
    (void)a;
}
static void store_world(void *c, int32_t flag) { ((Ctx *)c)->start_flag = flag; }

enum {
    O_FONT = 0, O_BLINK = 2, O_RF1 = 4, O_RBG = 0x24, O_CA = 0x34, O_WA = 0x36, O_CB = 0xdb, O_WB = 0xdd, O_OK = 0x182,
    O_OKSND = 0x19b, O_BAD = 0x1cc, O_BADSND = 0x1e5, O_CANCEL = 0x216, O_CRECT = 0x22f
};

static int16_t rd16(const uint8_t *b, size_t o) { return (int16_t)(uint16_t)(b[o] | (b[o + 1] << 8)); }
static int32_t rd32(const uint8_t *b, size_t o)
{
    return (int32_t)((uint32_t)b[o] | ((uint32_t)b[o + 1] << 8) | ((uint32_t)b[o + 2] << 16) | ((uint32_t)b[o + 3] << 24));
}

typedef struct {
    SessionA76Binding *b;
    const SceneActionInfo *info;
    const uint8_t *body;
    size_t row;
    uint32_t phase;
    Ctx *ctx;
    unsigned long failures;
    int row_printed;
} Run;

#define EXPECT(run, cond)                                                                                  \
    do {                                                                                                   \
        if (!(cond)) {                                                                                     \
            ++(run)->failures;                                                                             \
            printf("ROW_FAIL row=%zu line=%d check=%s\n", (run)->row, __LINE__, #cond);                    \
        }                                                                                                  \
    } while (0)

/* One handler visit. Returns 1 when the visit completed the row. */
static int visit(Run *r)
{
    SceneActionRuntimeState st;
    SceneActionHandlerResult out;
    memset(&st, 0, sizeof st);
    memset(&out, 0, sizeof out);
    st.phase = r->phase;
    if (session_a76_handler(r->b, r->row, r->info, &st, &out) != SCENE_ACTION_HANDLER_OK) {
        ++r->failures;
        printf("ROW_FAIL row=%zu line=%d check=handler status\n", r->row, __LINE__);
        return 1;
    }
    r->phase = out.phase;
    return out.disposition == SCENE_ACTION_HANDLER_COMPLETED;
}

static void begin(Run *r, SceneResource *scene)
{
    memset(r->ctx, 0, sizeof *r->ctx);
    r->ctx->now = 5000;
    r->phase = 0;
    EXPECT(r, session_a76_begin_scene(r->b, scene) == PWD_OK);
    (void)visit(r); /* phase 0 */
    EXPECT(r, r->phase == 1u && session_a76_registered(r->b) == 1u && session_a76_state(r->b)->b[PWD_S_ACTIVE] == 1);
}

static void type_ch(Run *r, char ch)
{
    (void)session_a76_key(r->b, (int8_t)ch);
    (void)visit(r);
}

static void type_text(Run *r, const char *s)
{
    for (; *s != '\0'; ++s) type_ch(r, *s);
}

/* visit until the row completes; at most 30 visits */
static int finish(Run *r)
{
    for (int i = 0; i < 30; ++i) {
        if (visit(r)) return 1;
    }
    return 0;
}

static int has_word(const uint8_t *body, const char *text)
{
    char up[64];
    size_t n = strlen(text);
    if (n >= sizeof up) return 1;
    for (size_t i = 0; i <= n; ++i) up[i] = (char)toupper((unsigned char)text[i]);
    for (int k = 0; k < 2; ++k) {
        const size_t words = k == 0 ? O_WA : O_WB;
        const int count = rd16(body, k == 0 ? O_CA : O_CB);
        for (int i = 0; i < count; ++i) {
            char w[0x22];
            memcpy(w, body + words + 0x21u * (unsigned)i, 0x21);
            w[0x21] = 0;
            for (char *p = w; *p != '\0'; ++p) *p = (char)toupper((unsigned char)*p);
            if (strstr(up, w) != NULL) return 1;
        }
    }
    return 0;
}

/* Expected exit: scene change count and the event flag count of a block. */
static void expect_exit(Run *r, size_t block, int sound_plays)
{
    const int has_scene = rd16(r->body, block) != 9999;
    const int has_flag = rd16(r->body, block + 22) != -1;
    EXPECT(r, r->ctx->transitions == (has_scene ? 1 : 0));
    if (has_scene) EXPECT(r, r->ctx->scene == rd16(r->body, block));
    EXPECT(r, r->ctx->flag_stores == (has_flag ? 1 : 0));
    if (has_flag) {
        EXPECT(r, r->ctx->flag_index == rd16(r->body, block + 22));
        EXPECT(r, r->ctx->flag_value == r->body[block + 24]);
    }
    EXPECT(r, r->ctx->completes == 1);
    EXPECT(r, r->ctx->releases == 1 && r->ctx->acquires == 1);
    EXPECT(r, r->ctx->plays == sound_plays && r->ctx->prepares == sound_plays && r->ctx->stops == sound_plays);
    EXPECT(r, session_a76_registered(r->b) == 0u && session_a76_state(r->b)->b[PWD_S_ACTIVE] == 0);
}

int main(int argc, char **argv)
{
    static Ctx ctx;
    SessionA76Host host;
    unsigned long rows = 0, validated = 0, error = 0, scenes = 0, words = 0, variants = 0, skipped = 0, wrong_exit = 0;
    unsigned long correct_exit = 0, cancel_exit = 0, cancel_noop = 0, blink_toggles = 0, backspaces = 0, renders = 0;
    memset(&host, 0, sizeof host);
    host.kernel.context = &ctx;
    host.kernel.view_origin = view_origin;
    host.kernel.font_acquire = font_acquire;
    host.kernel.font_release = font_release;
    host.kernel.text_width = text_width;
    host.kernel.tick = tick;
    host.kernel.sound_prepare = sound_prepare;
    host.kernel.sound_stop = sound_stop;
    host.kernel.sound_play = sound_play;
    host.kernel.sound_busy = sound_busy;
    host.kernel.event_flag_invalid = flag_invalid;
    host.kernel.transition = transition;
    host.kernel.store_event_flag = store_flag;
    host.kernel.observe = observe;
    host.store_world = store_world;
    for (int a = 1; a < argc; ++a) {
        FILE *f = fopen(argv[a], "rb");
        long n;
        unsigned char *bytes;
        char err[128] = {0};
        SceneResource *scene;
        size_t count;
        if (f == NULL) continue;
        fseek(f, 0, SEEK_END);
        n = ftell(f);
        fseek(f, 0, SEEK_SET);
        bytes = (unsigned char *)malloc((size_t)n);
        if (bytes == NULL || fread(bytes, 1, (size_t)n, f) != (size_t)n) {
            fclose(f);
            free(bytes);
            continue;
        }
        fclose(f);
        scene = scene_resource_open_memory(bytes, (size_t)n, err, sizeof err);
        if (scene == NULL) {
            printf("SCENE_FAIL file=%d\n", a);
            ++error;
            free(bytes);
            continue;
        }
        ++scenes;
        count = scene_resource_action_count(scene);
        for (size_t row = 0; row < count; ++row) {
            SceneActionInfo info;
            SessionA76Binding *b;
            Run run;
            uint8_t body[PWD_BODY_BYTES];
            if (scene_resource_action_at(scene, row, &info) != SCENE_RESOURCE_OK || info.type != SESSION_A76_TYPE) continue;
            ++rows;
            memcpy(body, info.typed_body, PWD_BODY_BYTES);
            memset(&run, 0, sizeof run);
            b = session_a76_create(&host);
            if (b == NULL) {
                ++error;
                continue;
            }
            run.b = b;
            run.info = &info;
            run.body = body;
            run.row = row;
            run.ctx = &ctx;
            memset(&ctx, 0, sizeof ctx);
            if (pwd_validate_body(body, PWD_BODY_BYTES, NULL) == PWD_OK && session_a76_begin_scene(b, scene) == PWD_OK) ++validated;
            {
                /* a wrong word: leaves through the wrong sound and the wrong block */
                static const char *const fillers[] = {"QXQXQ", "ZZZZZ", "JKJKJ", "1234567"};
                const char *wrong = NULL;
                for (size_t k = 0; k < sizeof fillers / sizeof fillers[0] && wrong == NULL; ++k)
                    if (!has_word(body, fillers[k])) wrong = fillers[k];
                EXPECT(&run, wrong != NULL);
                if (wrong != NULL) {
                    PwdRenderResult rr;
                    begin(&run, scene);
                    EXPECT(&run, session_a76_render(b, &rr) == PWD_OK && rr.count == 2 && rr.op[0].kind == PWD_OP_BLIT);
                    EXPECT(&run, rr.op[1].font == rd16(body, O_FONT) && rr.op[0].dst[0] == rd32(body, O_RBG) + 7);
                    ++renders;
                    type_text(&run, wrong);
                    EXPECT(&run, strncmp((const char *)session_a76_state(b)->b + PWD_S_FIELD1, wrong, strlen(wrong)) == 0);
                    type_ch(&run, '\r');
                    EXPECT(&run, session_a76_state(b)->b[PWD_S_WRONG] == 1 && session_a76_state(b)->b[PWD_S_CORRECT] == 0);
                    ctx.busy_left = 2;
                    EXPECT(&run, finish(&run));
                    expect_exit(&run, O_BAD, memcmp(body + O_BADSND, "NO SOUND", 9) == 0 ? 0 : 1);
                    if (run.failures == 0) ++wrong_exit;
                }
            }
            for (int k = 0; k < 2; ++k) {
                const int cnt = rd16(body, k == 0 ? O_CA : O_CB);
                for (int w = 0; w < cnt; ++w) {
                    char word[0x22], variant[0x60];
                    memcpy(word, body + (k == 0 ? O_WA : O_WB) + 0x21u * (unsigned)w, 0x21);
                    word[0x21] = 0;
                    ++words;
                    for (int style = 0; style < 3; ++style) {
                        const unsigned long before = run.failures;
                        char core[0x22];
                        int typable = 1;
                        for (size_t i = 0; i < strlen(word); ++i) {
                            core[i] = style == 0 ? (char)tolower((unsigned char)word[i])
                                    : style == 1 ? (char)toupper((unsigned char)word[i])
                                                 : (i & 1u ? (char)tolower((unsigned char)word[i]) : (char)toupper((unsigned char)word[i]));
                            if (!pwd_char_accepted((int8_t)core[i])) typable = 0;
                        }
                        core[strlen(word)] = 0;
                        if (!typable || k == 1 || strlen(word) + 4u > 30u) {
                            ++skipped;
                            continue;
                        }
                        snprintf(variant, sizeof variant, "xx%syy", core);
                        begin(&run, scene);
                        type_text(&run, variant);
                        type_ch(&run, '\r');
                        EXPECT(&run, session_a76_state(b)->b[PWD_S_CORRECT] == 1);
                        ctx.busy_left = 1;
                        if (rd16(body, O_CB) != 0) {
                            /* a second field: type the first accepted word of field 2 and answer again */
                            char w2[0x22];
                            memcpy(w2, body + O_WB, 0x21);
                            w2[0x21] = 0;
                            type_text(&run, w2);
                            type_ch(&run, '\r');
                        }
                        EXPECT(&run, session_a76_state(b)->b[PWD_S_WRONG] == 0);
                        EXPECT(&run, finish(&run));
                        expect_exit(&run, O_OK, memcmp(body + O_OKSND, "NO SOUND", 9) == 0 ? 0 : 1);
                        if (run.failures == before) ++variants;
                    }
                }
            }
            if (run.failures == 0 && variants > 0) ++correct_exit;
            {
                /* Backspace and the blink */
                const int period = rd16(body, O_BLINK);
                begin(&run, scene);
                type_text(&run, "ab");
                EXPECT(&run, strcmp((const char *)session_a76_state(b)->b + PWD_S_FIELD1, "ab-") == 0);
                type_ch(&run, '\b');
                EXPECT(&run, strcmp((const char *)session_a76_state(b)->b + PWD_S_FIELD1, "a-") == 0);
                ++backspaces;
                ctx.now += (uint32_t)(period > 0 ? period : 1) + 1u;
                (void)visit(&run); /* the deadline passed: the blink phase flips */
                EXPECT(&run, session_a76_state(b)->b[PWD_S_BLINK] == 1);
                (void)visit(&run); /* the next visit hides the cursor */
                EXPECT(&run, strcmp((const char *)session_a76_state(b)->b + PWD_S_FIELD1, "a") == 0);
                type_ch(&run, '\b');
                EXPECT(&run, session_a76_state(b)->b[PWD_S_FIELD1] == 0);
                ++blink_toggles;
            }
            {
                /* the cancel strip */
                PwdPointerResult pr;
                PwdClickResult cr;
                const int32_t l = rd32(body, O_CRECT), t = rd32(body, O_CRECT + 4), rr = rd32(body, O_CRECT + 8), bt = rd32(body, O_CRECT + 12);
                const unsigned long before = run.failures;
                begin(&run, scene);
                EXPECT(&run, session_a76_pointer_move(b, l, t, &pr) == PWD_OK && pr.hit == 1 && pr.candidate == 0x2724);
                EXPECT(&run, session_a76_pointer_move(b, rr, bt, &pr) == PWD_OK && pr.hit == 1 && pr.cursor_kind == 9);
                EXPECT(&run, session_a76_pointer_move(b, l - 1, t, &pr) == PWD_OK && pr.hit == 0);
                EXPECT(&run, session_a76_pointer_move(b, rr, bt + 1, &pr) == PWD_OK && pr.hit == 0);
                EXPECT(&run, session_a76_click(b, 0x2724 + 1, &cr) == PWD_OK && cr.fired == 0);
                EXPECT(&run, session_a76_click(b, 0x2724, &cr) == PWD_OK && cr.fired == 1 && (size_t)cr.row == row && cr.phase == 2u);
                run.phase = 2u;
                EXPECT(&run, finish(&run));
                expect_exit(&run, O_CANCEL, 0);
                if (run.failures == before) ++cancel_exit;
                /* a click after a correct answer does nothing */
                begin(&run, scene);
                {
                    PwdState *st = (PwdState *)session_a76_state(b);
                    st->b[PWD_S_CORRECT] = 1; /* what a hit stores */
                }
                EXPECT(&run, session_a76_click(b, 0x2724, &cr) == PWD_OK && cr.fired == 0);
                if (run.failures == before) ++cancel_noop;
            }
            error += run.failures;
            session_a76_destroy(b);
        }
        scene_resource_close(scene);
        free(bytes);
    }
    printf("SUMMARY scenes=%lu rows=%lu validated=%lu words=%lu variants=%lu skipped=%lu wrong_exit=%lu correct_exit=%lu "
           "cancel_exit=%lu cancel_noop=%lu blink=%lu backspace=%lu renders=%lu error=%lu\n",
           scenes, rows, validated, words, variants, skipped, wrong_exit, correct_exit, cancel_exit, cancel_noop, blink_toggles,
           backspaces, renders, error);
    return error == 0 ? 0 : 1;
}
