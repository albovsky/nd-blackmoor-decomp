#include "action_family_97.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static uint32_t state = UINT32_C(0x97a197a1);
static size_t accepted;
static size_t rejected;

static uint32_t next(void)
{
    state = state * UINT32_C(1664525) + UINT32_C(1013904223);
    return state;
}

static void word(uint8_t *p, unsigned v)
{
    p[0] = (uint8_t)v;
    p[1] = (uint8_t)(v >> 8);
}

static ActionFamily97LookupStatus lookup(void *context, const uint8_t *key,
    size_t length, const uint8_t **text, size_t *text_length)
{
    static const uint8_t value[] = "sanitizer text";
    (void)context;
    (void)key;
    (void)length;
    *text = value;
    *text_length = sizeof(value);
    return ACTION_FAMILY_97_LOOKUP_FOUND;
}

static size_t fixture(uint8_t *raw, size_t n)
{
    size_t i;
    size_t p = 15u + 33u * n;
    memset(raw, 0, 2048u);
    word(raw, (unsigned)n);
    for (i = 0u; i < n; ++i) {
        uint8_t *name = raw + 2u + 33u * i;
        name[0] = (uint8_t)((next() % 3u == 0u) ? '*' : 'n');
        name[1] = (uint8_t)('a' + i);
        name[2] = 0;
        /* Nonzero unused bytes exercise raw fixed-field preservation. */
        memset(name + 3u, (int)(next() & 255u), 30u);
    }
    for (i = p - 13u; i < p; ++i) {
        raw[i] = (uint8_t)next();
    }
    for (i = 0u; i < n; ++i) {
        if (next() % 5u == 0u) {
            word(raw + p, 65535u);
            memcpy(raw + p + 2u, "key", 4u);
            p += 35u;
        } else {
            size_t length = next() % 32u;
            size_t j;
            word(raw + p, (unsigned)length);
            for (j = 0u; j < length; ++j) {
                raw[p + 2u + j] = (uint8_t)next();
            }
            p += 2u + length;
        }
    }
    p += 16u * (next() % 4u);
    return p;
}

static int exercise(const uint8_t *raw, size_t length)
{
    ActionFamily97Decoded decoded;
    ActionFamily97Decoded before;
    ActionFamily97Constructed constructed;
    ActionFamily97Constructed state_before;
    uint8_t payload[ACTION_FAMILY_97_MAX_ALLOCATION + 32u];
    ActionFamily97Status dstatus;
    ActionFamily97Status cstatus;
    size_t i;
    memset(&decoded, 0xa5, sizeof(decoded));
    memcpy(&before, &decoded, sizeof(before));
    memset(&constructed, 0xb6, sizeof(constructed));
    memcpy(&state_before, &constructed, sizeof(state_before));
    memset(payload, 0xc7, sizeof(payload));
    dstatus = action_family_97_decode(raw, length, &decoded);
    cstatus = action_family_97_construct(raw, length, next(), UINT32_MAX - 11u,
        lookup, NULL, payload + 16u, ACTION_FAMILY_97_MAX_ALLOCATION, &constructed);
    if (dstatus != ACTION_FAMILY_97_OK) {
        assert(cstatus == dstatus);
        assert(memcmp(&decoded, &before, sizeof(decoded)) == 0);
    } else {
        assert(decoded.body_bytes <= length);
        assert(decoded.dependency_bytes == length - decoded.body_bytes);
        assert(decoded.dependency_bytes % 16u == 0u);
    }
    if (cstatus != ACTION_FAMILY_97_OK) {
        assert(memcmp(&constructed, &state_before, sizeof(constructed)) == 0);
        for (i = 0u; i < sizeof(payload); ++i) {
            assert(payload[i] == 0xc7u);
        }
        ++rejected;
    } else {
        assert(constructed.allocation_bytes >= 172u);
        assert(constructed.allocation_bytes <= ACTION_FAMILY_97_MAX_ALLOCATION);
        for (i = 0u; i < 16u; ++i) {
            assert(payload[i] == 0xc7u);
        }
        for (i = constructed.allocation_bytes + 16u; i < sizeof(payload); ++i) {
            assert(payload[i] == 0xc7u);
        }
        ++accepted;
    }
    return (int)cstatus;
}

int main(void)
{
    uint8_t raw[2048];
    uint8_t saved[2048];
    size_t run;
    size_t truncations = 0u;
    size_t mutations = 0u;
    for (run = 0u; run < 20000u; ++run) {
        size_t n = 1u + next() % 9u;
        size_t length = fixture(raw, n);
        memcpy(saved, raw, sizeof(raw));
        assert(exercise(raw, length) == ACTION_FAMILY_97_OK);
        assert(memcmp(raw, saved, sizeof(raw)) == 0);
        if (run < 50u) {
            size_t cut;
            for (cut = 0u; cut < length; ++cut) {
                (void)exercise(raw, cut);
                ++truncations;
            }
        }
        if (run < 5000u) {
            size_t index = next() % length;
            raw[index] ^= (uint8_t)(1u << (next() % 8u));
            memcpy(saved, raw, sizeof(raw));
            (void)exercise(raw, length);
            assert(memcmp(raw, saved, sizeof(raw)) == 0);
            ++mutations;
        }
    }
    /* Guarded copies of short buffers make truncation an actual ASan bound,
     * not just a claimed length within a larger stack array. */
    {
        size_t length = fixture(raw, 9u);
        size_t cut;
        for (cut = 0u; cut < length; ++cut) {
            uint8_t *short_raw = malloc(cut == 0u ? 1u : cut);
            assert(short_raw != NULL);
            memcpy(short_raw, raw, cut);
            (void)exercise(short_raw, cut);
            free(short_raw);
            ++truncations;
        }
    }
    {
        uint8_t *large = calloc(1u, 33000u);
        size_t i;
        assert(large != NULL);
        word(large, 1u);
        word(large + 48u, 32592u);
        memset(large + 50u, 'x', 32592u);
        assert(exercise(large, 32642u) == ACTION_FAMILY_97_OK);
        word(large + 48u, 32593u);
        assert(exercise(large, 32643u) == ACTION_FAMILY_97_ERR_BOUNDS);
        for (i = 0u; i < 65536u; i += 257u) {
            word(large + 48u, (unsigned)i);
            (void)exercise(large, 33000u);
            ++mutations;
        }
        free(large);
    }
    {
        ActionFamily97Decoded d;
        ActionFamily97Constructed s;
        assert(action_family_97_decode(NULL, 0u, &d) == ACTION_FAMILY_97_ERR_ARGUMENT);
        assert(action_family_97_decode(raw, SIZE_MAX, &d) == ACTION_FAMILY_97_ERR_BOUNDS);
        assert(action_family_97_construct(raw, sizeof(raw), 1u, 50u,
            lookup, NULL, (uint8_t *)&s, sizeof(s), &s) == ACTION_FAMILY_97_ERR_OVERLAP);
    }
    printf("{\"accepted\":%zu,\"safety_rejections\":%zu,\"truncations\":%zu,\"mutations\":%zu}\n",
        accepted, rejected, truncations, mutations);
    return 0;
}
