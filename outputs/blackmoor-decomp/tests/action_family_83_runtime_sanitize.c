/* RT-12 ASan/UBSan driver: exact-size heap buffers for every input, list and
 * UICL image, so any over-read or overrun is a sanitizer diagnostic. The
 * deterministic PRNG makes the case count fixed. Exit 0 means every loop ran. */
#include "action_family_83_runtime.h"

#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static uint32_t rng_state = 0x83838383u;
static uint32_t rng(void)
{
    rng_state = rng_state * 1664525u + 1013904223u;
    return rng_state >> 8;
}

typedef struct Host { unsigned calls; int fail_at; int32_t last_active; int16_t last_group, last_child; } Host;
static int refresh(void *context, int16_t group, int32_t active, int16_t child)
{
    Host *host = (Host *)context;
    ++host->calls;
    host->last_group = group;
    host->last_active = active;
    host->last_child = child;
    return host->fail_at > 0 && (int)host->calls == host->fail_at ? 7 : 0;
}

static uint8_t *exact(const uint8_t *src, size_t length)
{
    uint8_t *copy = (uint8_t *)malloc(length != 0u ? length : 1u);
    assert(copy != NULL);
    if (length != 0u) memcpy(copy, src, length);
    return copy;
}

int main(void)
{
    unsigned long cases = 0, accepted = 0, rejected = 0, mutations = 0, inits = 0;
    uint8_t seed[74];
    unsigned length, iteration;
    memset(seed, 0, sizeof(seed));
    memcpy(seed + 2, "key", 4);
    memcpy(seed + 35, "text", 5);
    /* Every short length is read-bounded: ASan sees the exact allocation. */
    for (length = 0u; length < 74u; ++length) {
        uint8_t *body = exact(seed, length);
        uint8_t mail[1][A83_MAIL_BYTES], web[1][A83_WEB_BYTES];
        A83World world = {mail, 1u, 0, web, 1u, 0};
        Host host = {0, 0, 0, 0, 0};
        A83Backend backend = {&host, refresh};
        A83Input in = {0, 1, 0, 1};
        A83Result out;
        const char *why;
        memset(mail, 0xA7, sizeof(mail));
        memset(web, 0xA7, sizeof(web));
        assert(action83_runtime_step(body, length, &in, &world, &backend, &out, &why) == A83_ERR_BODY);
        assert(host.calls == 0u && world.mail_count == 0 && world.web_count == 0);
        free(body);
        ++cases; ++rejected;
    }
    for (iteration = 0u; iteration < 60000u; ++iteration) {
        uint8_t raw[74];
        unsigned capacity = rng() % 5u, i;
        int16_t mail_count = (int16_t)((int)(rng() % 9u) - 2), web_count = (int16_t)((int)(rng() % 9u) - 2);
        uint8_t (*mail)[A83_MAIL_BYTES] = (uint8_t (*)[A83_MAIL_BYTES])malloc(capacity != 0u ? capacity * A83_MAIL_BYTES : 1u);
        uint8_t (*web)[A83_WEB_BYTES] = (uint8_t (*)[A83_WEB_BYTES])malloc(capacity != 0u ? capacity * A83_WEB_BYTES : 1u);
        uint8_t *body;
        A83World world;
        Host host = {0, (int)(rng() % 3u), 0, 0, 0};
        A83Backend backend = {&host, refresh};
        A83Input in = {rng(), (uint8_t)rng(), (uint8_t)(rng() % 3u), (uint8_t)(rng() % 4u != 0u)};
        A83Result out;
        const char *why;
        uint8_t before_mail[5 * A83_MAIL_BYTES], before_web[5 * A83_WEB_BYTES];
        int status;
        assert(mail != NULL && web != NULL);
        for (i = 0u; i < 74u; ++i) raw[i] = (uint8_t)rng();
        if (rng() % 3u != 0u) {  /* usually well formed strings */
            raw[2 + rng() % 33u] = 0u; raw[35 + rng() % 33u] = 0u;
            if (rng() % 2u) { raw[0] = 0u; raw[1] = 0u; }
        }
        for (i = 0u; i < capacity * A83_MAIL_BYTES; ++i) ((uint8_t *)mail)[i] = (uint8_t)rng();
        for (i = 0u; i < capacity * A83_WEB_BYTES; ++i) ((uint8_t *)web)[i] = (uint8_t)rng();
        for (i = 0u; i < capacity; ++i) {  /* usually terminated stored keys */
            if (rng() % 4u != 0u) mail[i][rng() % 33u] = 0u;
            if (rng() % 4u != 0u) web[i][rng() % 33u] = 0u;
        }
        memcpy(before_mail, mail, capacity * A83_MAIL_BYTES);
        memcpy(before_web, web, capacity * A83_WEB_BYTES);
        world.mail = mail; world.mail_capacity = capacity; world.mail_count = mail_count;
        world.web = web; world.web_capacity = capacity; world.web_count = web_count;
        body = exact(raw, 74u);
        memset(&out, 0xA5, sizeof(out));
        status = action83_runtime_step(body, 74u, &in, &world, &backend, &out, &why);
        if (status == A83_OK) {
            ++accepted;
            if (out.applied != 0u) {
                const int16_t used = out.list ? world.web_count : world.mail_count;
                const int16_t other = out.list ? world.mail_count : world.web_count;
                const int16_t other_before = out.list ? mail_count : web_count;
                assert(used >= 1 && (size_t)used <= capacity && out.selected < used);
                assert(other == other_before);
            } else {
                assert(host.calls == 0u && world.mail_count == mail_count && world.web_count == web_count);
                assert(memcmp(mail, before_mail, capacity * A83_MAIL_BYTES) == 0);
            }
        } else {
            ++rejected;
            assert(why != NULL);
            if (status != A83_ERR_HOST) {
                assert(host.calls == 0u);
                assert(memcmp(mail, before_mail, capacity * A83_MAIL_BYTES) == 0);
                assert(memcmp(web, before_web, capacity * A83_WEB_BYTES) == 0);
                assert(world.mail_count == mail_count && world.web_count == web_count);
            }
        }
        if (status == A83_OK && out.applied != 0u) {
            assert(host.calls == 1u && host.last_group == 3 && host.last_active == 1);
            assert(host.last_child == (out.list ? 2 : 1) && out.completed == 1u && out.selected >= 0);
        }
        free(body); free(mail); free(web);
        ++cases; ++mutations;
    }
    /* UICL images, exact size, including truncations and unterminated strings. */
    for (iteration = 0u; iteration < 6000u; ++iteration) {
        uint8_t image[A83_UICL_MIN_BYTES + 16u];
        unsigned size = iteration % 2u ? A83_UICL_MIN_BYTES : (rng() % (A83_UICL_MIN_BYTES + 16u));
        uint8_t mail[1][A83_MAIL_BYTES], web[1][A83_WEB_BYTES];
        A83World world = {mail, 1u, 0, web, 1u, 0};
        uint8_t *uicl;
        unsigned i;
        int status;
        for (i = 0u; i < sizeof(image); ++i) image[i] = (uint8_t)(rng() % 5u == 0u ? rng() : 0u);
        if (size >= 0xccbu + 1u && rng() % 2u) memcpy(image + 0xccb, "m\0", 2);
        if (size >= 0xd11u + 1u && rng() % 2u) memcpy(image + 0xd11, "w\0", 2);
        uicl = exact(image, size);
        memset(mail, 0xA7, sizeof(mail)); memset(web, 0xA7, sizeof(web));
        status = action83_initialize(&world, uicl, size);
        if (size < A83_UICL_MIN_BYTES) assert(status == A83_ERR_BODY);
        if (status == A83_OK) assert(world.mail_count <= 1 && world.web_count <= 1);
        free(uicl);
        ++cases; ++inits;
    }
    /* Argument validation. */
    {
        A83Backend backend = {NULL, refresh};
        A83Result out;
        const char *why;
        A83Input in = {0, 1, 0, 1};
        uint8_t body[74] = {0};
        assert(action83_runtime_step(body, 74u, NULL, NULL, &backend, &out, &why) == A83_ERR_ARGUMENT);
        assert(action83_runtime_step(body, 74u, &in, NULL, &backend, NULL, &why) == A83_ERR_ARGUMENT);
        assert(action83_initialize(NULL, body, 74u) == A83_ERR_ARGUMENT);
    }
    printf("RT-12 sanitizer: %lu cases (%lu accepted, %lu rejected), %lu randomized runtime cases, %lu UICL cases\n",
           cases, accepted, rejected, mutations, inits);
    return 0;
}
