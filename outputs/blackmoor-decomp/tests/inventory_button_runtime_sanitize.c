/* RT-22 follow-up: bounded randomized and malformed inputs for the task bar kernel under
 * ASan/UBSan. Layouts are random byte chunks (rectangles, flags, delays, any sound name), the
 * lock table holds random words, and every entry point runs with random pointers, scene
 * requests, tick times (including wrap-around) and host answers. */
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "../src/inventory_button_runtime.h"

static uint64_t rng_state = UINT64_C(0x9e3779b97f4a7c15);

static uint32_t rnd(void)
{
    rng_state ^= rng_state << 13;
    rng_state ^= rng_state >> 7;
    rng_state ^= rng_state << 17;
    return (uint32_t)(rng_state >> 16);
}

static int fail_sound;
static int busy_answer;

static int hot(void *context, int32_t index, int32_t variant, int32_t *dx, int32_t *dy)
{
    (void)context;
    if (index < 0 || index > 106 || variant < 0 || variant > 1) return 1;
    *dx = (int32_t)(rnd() % 40u) - 10;
    *dy = (int32_t)(rnd() % 40u) - 10;
    return 0;
}

static int sound(void *context, const char *name, uint16_t slot)
{
    (void)context; (void)slot;
    if (name[TASKBAR_SOUND_NAME_BYTES] != 0) return 2;     /* always terminated */
    return fail_sound;
}

static int busy(void *context, uint16_t slot, int *out)
{
    (void)context; (void)slot;
    *out = busy_answer;
    return 0;
}

int main(void)
{
    uint8_t chunk[TASKBAR_CHUNK_BYTES + 8];
    unsigned short_rejected = 0, built = 0, presses = 0, flags = 0, host_errors = 0;
    TaskbarHost host = {hot, sound, busy, NULL};
    for (unsigned round = 0; round < 20000u; ++round) {
        for (size_t i = 0; i < sizeof(chunk); ++i) chunk[i] = (uint8_t)rnd();
        if ((round & 3u) == 0u) {
            /* plausible geometry so some presses succeed */
            for (unsigned b = 0; b < TASKBAR_BUTTONS; ++b) {
                uint8_t *r = chunk + TASKBAR_RECORDS_OFFSET + b * TASKBAR_RECORD_BYTES;
                const int32_t v[4] = {(int32_t)(rnd() % 300u), (int32_t)(380u + rnd() % 80u),
                                      (int32_t)(300u + rnd() % 340u), (int32_t)(460u + rnd() % 20u)};
                for (unsigned k = 0; k < 4u; ++k) memcpy(r + 0x96 + 4u * k, &v[k], 4);
                memset(r + 0xaa, 1, 1); memset(r + 0xae, 1, 1);
                memset(r + 0xb6, 0, 4); memset(r + 0xba, 0x10, 1);
            }
        }
        TaskbarLayout layout;
        const size_t length = (round % 17u == 0u) ? (size_t)(rnd() % TASKBAR_CHUNK_BYTES)
                                                  : sizeof(chunk);
        const int status = taskbar_layout_from_task(chunk, length, (int32_t)rnd(), (int32_t)rnd(),
                                                    &layout);
        if (length < TASKBAR_CHUNK_BYTES) {
            if (status != TASKBAR_ERR_FORMAT) { fprintf(stderr, "short chunk accepted\n"); return 1; }
            ++short_rejected;
            continue;
        }
        if (status != TASKBAR_OK) { fprintf(stderr, "layout rejected\n"); return 1; }
        ++built;
        for (unsigned b = 0; b < TASKBAR_BUTTONS; ++b) {
            if (layout.button[b].sound_name[TASKBAR_SOUND_NAME_BYTES] != 0) return 1;
        }
        Taskbar bar;
        if (taskbar_init(&bar, &layout) != TASKBAR_OK) return 1;
        /* random lock table and starting states (including values the original never stores) */
        for (unsigned b = 0; b < TASKBAR_BUTTONS; ++b) {
            bar.lock[b].kind = (int32_t)(rnd() % 4u);
            for (unsigned k = 0; k < TASKBAR_LOCK_RANGES; ++k) {
                bar.lock[b].lo[k] = (int16_t)rnd();
                bar.lock[b].hi[k] = (int16_t)rnd();
            }
            if (rnd() % 5u == 0u) bar.button[b].state = (int32_t)(rnd() % 7u) - 1;
        }
        uint32_t now = rnd();
        fail_sound = (round % 29u == 0u) ? 1 : 0;
        for (unsigned step = 0; step < 24u; ++step) {
            now += rnd() % 400u;
            if (step == 0u && rnd() % 8u == 0u) now = 0xfffffff0u;   /* wrap around */
            busy_answer = (int)(rnd() % 3u == 0u);
            bar.cursor_index = (int32_t)(rnd() % 120u) - 4;
            bar.cursor_variant = (int32_t)(rnd() % 4u) - 1;
            int32_t rect[4];
            rect[0] = (int32_t)(rnd() % 700u) - 30;
            rect[1] = (int32_t)(rnd() % 520u) - 20;
            rect[2] = rect[0] + (int32_t)(rnd() % 3u);
            rect[3] = rect[1] + (int32_t)(rnd() % 3u);
            TaskbarHoverResult hover;
            const int hs = taskbar_hover(&bar, &layout, rect, &host, &hover);
            if (hs != TASKBAR_OK && hs != TASKBAR_ERR_HOST) return 1;
            if (hs == TASKBAR_OK && (hover.hit < -1 || hover.hit >= (int32_t)TASKBAR_BUTTONS)) return 1;
            if (hs == TASKBAR_ERR_HOST) ++host_errors;
            TaskbarClickResult click;
            const int cs = taskbar_click(&bar, &layout, now, &host, &click);
            if (cs != TASKBAR_OK && cs != TASKBAR_ERR_HOST) return 1;
            if (cs == TASKBAR_ERR_HOST) ++host_errors;
            if (click.pressed >= 0) ++presses;
            TaskbarProcessResult proc;
            const int ps = taskbar_process(&bar, &layout, (int16_t)rnd(), now, &host, &proc);
            if (ps != TASKBAR_OK && ps != TASKBAR_ERR_HOST) return 1;
            for (unsigned b = 0; b < TASKBAR_BUTTONS; ++b) flags += proc.flag_set[b];
            if (ps == TASKBAR_OK && bar.state > 1) return 1;
        }
    }
    /* argument checks must fail cleanly */
    TaskbarLayout layout = {0};
    Taskbar bar = {0};
    TaskbarHoverResult hover;
    TaskbarClickResult click;
    TaskbarProcessResult proc;
    int32_t rect[4] = {0, 0, 0, 0};
    if (taskbar_hover(NULL, &layout, rect, &host, &hover) != TASKBAR_ERR_ARGUMENT) return 1;
    if (taskbar_hover(&bar, &layout, NULL, &host, &hover) != TASKBAR_ERR_ARGUMENT) return 1;
    if (taskbar_click(&bar, NULL, 0, &host, &click) != TASKBAR_ERR_ARGUMENT) return 1;
    if (taskbar_process(&bar, &layout, 0, 0, &host, NULL) != TASKBAR_ERR_ARGUMENT) return 1;
    if (taskbar_apply_locks(NULL, 0) != TASKBAR_ERR_ARGUMENT) return 1;
    (void)proc;
    printf("inventory_button_runtime sanitizer ok: layouts=%u short_rejected=%u presses=%u "
           "flags=%u host_errors=%u\n", built, short_rejected, presses, flags, host_errors);
    return presses == 0u || flags == 0u ? 1 : 0;
}
