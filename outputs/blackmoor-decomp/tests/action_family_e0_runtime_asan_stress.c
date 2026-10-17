/* RT-51 bounded malformed-input stress for the raw 0xd6 / 0xe0 kernel under ASan + UBSan.
 *
 * Build and run (from outputs/blackmoor-decomp):
 *   cc -std=c11 -Wall -Wextra -Wpedantic -Werror -O1 -g -fsanitize=address,undefined -fno-sanitize-recover=undefined \
 *      -Isrc tests/action_family_e0_runtime_asan_stress.c tests/action_family_e0_runtime_oracle_driver.c \
 *      src/action_family_e0_runtime.c -lm -o /tmp/e0_stress && /tmp/e0_stress [iterations] [seed]
 *
 * Bodies are random bytes with structured corruption (bad lengths, N, K, cols, rows, event flag indices, channels); every
 * body goes through e0_validate_body; accepted bodies and, deliberately, rejected ones (pointer / click / render do not
 * validate, the executor does) drive 80 random operations on a scripted host. The test passes when the sanitizers stay
 * silent and every status is one of the documented E0Status values. Test code only, no original bytes. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_e0_runtime.h"

extern void *e0o_new(void);
extern void e0o_free(void *);
extern void e0o_set_view(void *, int32_t, int32_t);
extern void e0o_set_world(void *, int32_t, int32_t, int32_t);
extern void e0o_set_queues(void *, const uint32_t *, int, const int32_t *, int);
extern void e0o_set_handles(void *, const uint32_t *, int);
extern int e0o_load_body(void *, int, int, const uint8_t *, int);
extern int e0o_step(void *, int, uint32_t, uint32_t *);
extern int e0o_pointer(void *, int, int, int, int32_t *);
extern int e0o_click(void *, int, uint32_t, int32_t, int32_t, uint32_t *);
extern int e0o_invalidate(void *);
extern int e0o_cleanup(void *);
extern void e0o_scene_reset(void *);
extern int e0o_plan(void *, int, int32_t *);
extern int e0o_validate(int, const uint8_t *, int);
extern void e0o_set_image(void *, const uint8_t *);
extern void e0o_image(void *, uint8_t *, uint8_t *);
extern void e0o_clear_log(void *);

static uint64_t rs;
static uint32_t rnd(void)
{
    rs = rs * 6364136223846793005ull + 1442695040888963407ull;
    return (uint32_t)(rs >> 33);
}

static void put16(uint8_t *b, size_t o, int v) { b[o] = (uint8_t)v; b[o + 1] = (uint8_t)(v >> 8); }

static int status_ok(int s) { return s >= 0 && s <= E0_ERR_BOUNDS; }

int main(int argc, char **argv)
{
    const int iterations = argc > 1 ? atoi(argv[1]) : 3000;
    static uint8_t body[E0_BODY_CAPACITY];
    static uint32_t ticks[4096];
    static int32_t busy[4096];
    static int32_t plan[3 + 10 * E0_MAX_BLITS];
    uint32_t handles[4] = {0x7001, 0x7002, 0x7003, 0x7004};
    long steps = 0, accepted = 0, bad = 0;
    rs = argc > 2 ? strtoull(argv[2], NULL, 10) : 51u;
    for (int it = 0; it < iterations; ++it) {
        void *h = e0o_new();
        const int flag = (int)(rnd() & 1u);
        const int len = flag ? 294 : 1733;
        const int mode = (int)(rnd() % 4u);
        memset(body, 0, sizeof body);
        if (mode == 0) {
            for (int i = 0; i < len; ++i) body[i] = (uint8_t)rnd();
        } else {
            memcpy(body, "KEYPAD", 7);
            put16(body, 0x21, (int)(rnd() % 40u));
            body[0x23] = (uint8_t)(rnd() & 1u);
            body[0x24] = (uint8_t)(rnd() & 1u);
            put16(body, 0x45, (int)(rnd() % 8u));
            for (int i = 0; i < 30; ++i) body[0x48 + i] = (uint8_t)(rnd() % 12u);
            if (flag) {
                put16(body, 0x10e, 1 + (int)(rnd() % 8u));
                put16(body, 0x110, 1 + (int)(rnd() % 4u));
                for (size_t o = 0x112; o < 0x126; o += 2) put16(body, o, (int)(rnd() % 40u) - 5);
            } else {
                for (int r = 0; r < 4; ++r) put16(body, 0x24f + 33u * (unsigned)r, (int)(rnd() % 6u));
            }
            put16(body, 0x10c, (int)(rnd() % 6u));
            if (mode == 3) {
                for (int k = 0; k < 6; ++k) body[rnd() % (unsigned)len] = (uint8_t)rnd();
                put16(body, 0x21, (int)(rnd() & 0xffffu));
            }
        }
        if (!status_ok(e0o_validate(flag, body, len))) ++bad;
        if (e0o_load_body(h, 0, flag, body, len) != 0) {
            e0o_free(h);
            continue;
        }
        if (e0o_validate(flag, body, len) == E0_OK) ++accepted;
        for (int i = 0; i < 4096; ++i) {
            ticks[i] = i < 2000 ? 1000u + 37u * (unsigned)i : rnd();
            busy[i] = (int32_t)(rnd() & 1u);
        }
        e0o_set_queues(h, ticks, 4096, busy, 4096);
        e0o_set_handles(h, handles, 4);
        e0o_set_view(h, (int32_t)(rnd() % 50u) - 20, (int32_t)(rnd() % 50u) - 20);
        e0o_set_world(h, (int32_t)(rnd() & 1u), 0x1111, 0x55);
        {
            uint32_t res[3];
            int s = e0o_step(h, 0, 0, res);
            if (!status_ok(s)) ++bad;
            ++steps;
        }
        for (int op = 0; op < 80; ++op) {
            uint32_t res[3];
            int32_t out[3];
            int s;
            switch (rnd() % 8u) {
            case 0: case 1: case 2:
                s = e0o_step(h, 0, 1u + (rnd() % 6u == 0u), res);
                break;
            case 3:
                s = e0o_pointer(h, 0, (int)(rnd() % 700u) - 20, (int)(rnd() % 500u) - 20, out);
                break;
            case 4:
                s = e0o_click(h, 0, 1u, (rnd() & 1u) ? E0_CANDIDATE_KEY : (int32_t)(rnd() & 1u ? E0_CANDIDATE_EXIT : 0), 1, res);
                break;
            case 5:
                s = e0o_plan(h, 0, plan);
                break;
            case 6:
                s = (rnd() % 5u == 0u) ? e0o_cleanup(h) : e0o_invalidate(h);
                break;
            default:
                e0o_scene_reset(h);
                s = 0;
                break;
            }
            if (!status_ok(s)) ++bad;
            ++steps;
        }
        e0o_free(h);
    }
    printf("iterations=%d steps=%ld accepted_bodies=%ld bad_status=%ld\n", iterations, steps, accepted, bad);
    return bad == 0 ? 0 : 1;
}
