/* Synthetic fixtures only. Every advertised input has exact heap backing. */
#include "action_family_33.h"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static uint32_t random_state = UINT32_C(0x33123456);
static size_t valid_cases, malformed_cases;
static uint32_t next_random(void)
{
    random_state = random_state * UINT32_C(1664525) + UINT32_C(1013904223);
    return random_state;
}
static void put16(uint8_t *p, uint16_t v)
{
    p[0] = (uint8_t)v; p[1] = (uint8_t)(v >> 8);
}
static uint8_t *fixture(size_t a, size_t b, size_t tails, size_t *n)
{
    size_t i;
    uint8_t *p;
    *n = 113u + 6u*a + 66u*b + 16u*tails;
    p = malloc(*n);
    assert(p != NULL);
    for (i = 0u; i < *n; ++i) p[i] = (uint8_t)(i*29u+7u);
    put16(p+109u, (uint16_t)a); put16(p+111u, (uint16_t)b);
    return p;
}
static void check(const uint8_t *source, size_t n, int expected)
{
    uint8_t *p = malloc(n != 0u ? n : 1u);
    uint8_t *object;
    size_t capacity, i, typed = SIZE_MAX;
    ActionFamily33Decoded d, before;
    ActionFamily33Constructed out, out_before;
    ActionFamily33Status status, constructed_status;
    assert(p != NULL);
    memcpy(p, source, n);
    memset(&d, 0xa5, sizeof(d)); memcpy(&before, &d, sizeof(d));
    status = action_family_33_decode(p, n, &d);
    if (expected >= 0) assert(status == (ActionFamily33Status)expected);
    assert(action_family_33_body_length(p, n, &typed) == status);
    if (status == ACTION_FAMILY_33_OK) {
        ++valid_cases;
        assert(typed == d.body_bytes && typed <= n && typed >= 113u && typed <= 32767u);
        assert(typed == 113u+6u*d.count_6d+66u*d.count_6f);
        assert(d.raw_type == 0x33u && d.runtime_type == 0x33u);
        assert(d.typed_body == p && d.dependency_records == p+typed);
        assert(d.dependency_bytes == n-typed && d.dependency_count == (n-typed)/16u);
        capacity = typed; /* Exact allocation for valid constructor input. */
    } else {
        ++malformed_cases;
        assert(memcmp(&d, &before, sizeof(d)) == 0 && typed == SIZE_MAX);
        capacity = 32767u;
    }
    object = malloc(capacity);
    assert(object != NULL);
    memset(object, 0xcd, capacity);
    memset(&out, 0x96, sizeof(out)); memcpy(&out_before, &out, sizeof(out));
    constructed_status = action_family_33_construct(p, n, UINT32_C(0xfffffff0),
        UINT32_C(0x330001), object, capacity, &out);
    assert(constructed_status == status);
    if (status == ACTION_FAMILY_33_OK) {
        assert(memcmp(object, p, typed) == 0);
        assert(out.object_bytes == object && out.body_bytes_consumed == typed);
        assert(out.payload_offset_after == UINT32_C(0xfffffff0)+(uint32_t)typed);
        assert(out.output_allocation_bytes == typed && out.result_slot_handle == UINT32_C(0x330001));
        assert(out.dependency_records == d.dependency_records && out.dependency_count == d.dependency_count);
    } else {
        assert(memcmp(&out, &out_before, sizeof(out)) == 0);
        for (i = 0u; i < capacity; ++i) assert(object[i] == 0xcdu);
    }
    assert(memcmp(p, source, n) == 0);
    free(object); free(p);
}
int main(void)
{
    size_t i, n, b;
    uint8_t *p;
    const uint16_t bad[][2] = {{0x8000u,0u},{0xffffu,0u},{0u,0x8000u},{0u,0xffffu},
        {5443u,0u},{0u,495u},{5442u,1u},{10923u,0u},{32767u,32767u},
        {0xffffu,2u},{0xfffau,10u}};
    p = fixture(4u, 1u, 0u, &n);
    for (i = 0u; i < n; ++i) check(p, i, ACTION_FAMILY_33_ERR_BODY);
    free(p);
    p = fixture(0u, 0u, 1u, &n);
    for (i = 1u; i < 16u; ++i) check(p, 113u+i, ACTION_FAMILY_33_ERR_TAIL);
    for (i = 0u; i < sizeof(bad)/sizeof(bad[0]); ++i) {
        put16(p+109u,bad[i][0]); put16(p+111u,bad[i][1]);
        check(p,113u,ACTION_FAMILY_33_ERR_COUNT);
    }
    free(p);
    for (i = 0u; i <= 5442u; ++i) {
        p = fixture(i,0u,i%3u,&n); check(p,n,ACTION_FAMILY_33_OK); free(p);
    }
    for (b = 0u; b <= 494u; ++b) {
        size_t a = (32767u-113u-66u*b)/6u;
        p = fixture(a,b,b%3u,&n); check(p,n,ACTION_FAMILY_33_OK); free(p);
    }
    for (i = 0u; i < 20000u; ++i) {
        size_t a;
        b = next_random()%495u;
        a = next_random()%((32767u-113u-66u*b)/6u+1u);
        p = fixture(a,b,next_random()%4u,&n);
        check(p,n,ACTION_FAMILY_33_OK); free(p);
    }
    for (i = 0u; i < 30000u; ++i) {
        size_t j, advertised;
        p = fixture(next_random()%21u,next_random()%11u,next_random()%4u,&n);
        for (j = 0u; j <= i%4u; ++j) p[next_random()%n] ^= (uint8_t)(next_random()|1u);
        advertised = i%3u == 0u ? next_random()%(n+1u) : n;
        check(p,advertised,-1); free(p);
    }
    {
        ActionFamily33Decoded d;
        ActionFamily33Constructed out;
        uint8_t *object = malloc(113u);
        uint8_t *bad_pointer = (uint8_t *)(uintptr_t)(UINTPTR_MAX-3u);
        size_t typed;
        p = fixture(0u,0u,0u,&n); assert(object != NULL);
        assert(action_family_33_decode(NULL,n,&d) == ACTION_FAMILY_33_ERR_ARGUMENT);
        assert(action_family_33_decode(p,n,NULL) == ACTION_FAMILY_33_ERR_ARGUMENT);
        assert(action_family_33_decode(bad_pointer,n,&d) == ACTION_FAMILY_33_ERR_BOUNDS);
        assert(action_family_33_decode(p,SIZE_MAX,&d) == ACTION_FAMILY_33_ERR_BOUNDS);
        assert(action_family_33_decode(p,n,(ActionFamily33Decoded *)(void *)p) == ACTION_FAMILY_33_ERR_OVERLAP);
        assert(action_family_33_body_length(p,n,(size_t *)(void *)p) == ACTION_FAMILY_33_ERR_OVERLAP);
        assert(action_family_33_body_length(p,n,&typed) == ACTION_FAMILY_33_OK);
        assert(action_family_33_construct(p,n,50u,0u,object,n,&out) == ACTION_FAMILY_33_ERR_ARGUMENT);
        assert(action_family_33_construct(p,n,50u,1u,p,n,&out) == ACTION_FAMILY_33_ERR_OVERLAP);
        assert(action_family_33_construct(p,n,50u,1u,object,n-1u,&out) == ACTION_FAMILY_33_ERR_CAPACITY);
        assert(action_family_33_construct(p,n,50u,1u,bad_pointer,n,&out) == ACTION_FAMILY_33_ERR_BOUNDS);
        free(object); free(p);
    }
    printf("{\"valid_cases\":%zu,\"malformed_cases\":%zu,\"bounded_mutations\":30000,\"pointer_checks\":11}\n",
        valid_cases,malformed_cases);
    return 0;
}
