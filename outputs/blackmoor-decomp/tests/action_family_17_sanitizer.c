/* Exact-size heap fixtures for bounds and failure atomicity under ASan/UBSan. */
#include "action_family_17.h"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static size_t cases;
static size_t accepted;
static size_t rejected;

static void probe(uint8_t *body, size_t length)
{
    ActionFamily17Decoded d;
    ActionFamily17Constructed m;
    ActionFamily17Status status;
    uint8_t *before = malloc(length == 0u ? 1u : length);
    uint8_t *image;
    uint8_t ds[sizeof(d)];
    uint8_t ms[sizeof(m)];
    size_t typed = 0xabcdefu;
    size_t capacity;
    assert(before != NULL);
    memcpy(before, body, length);
    memset(&d, 0xa5, sizeof(d));
    memset(&m, 0xa6, sizeof(m));
    memcpy(ds, &d, sizeof(d));
    memcpy(ms, &m, sizeof(m));
    status = action_family_17_decode(body, length, &d);
    assert(action_family_17_body_length(body, length, &typed) == status);
    capacity = status == ACTION_FAMILY_17_OK ? typed : 22u;
    image = malloc(capacity);
    assert(image != NULL);
    memset(image, 0xb7, capacity);
    assert(action_family_17_construct(body,length,0xfffffff0u,1u,image,capacity,&m) == status);
    if (status == ACTION_FAMILY_17_OK) {
        uint8_t *short_image;
        ++accepted;
        assert(typed == d.body_bytes && typed <= length && typed <= 32764u);
        assert(d.records == body + 22u && d.dependency_records == body + typed);
        assert(d.dependency_count == (length-typed)/16u);
        assert(memcmp(image,body,typed) == 0);
        assert(m.allocation_bytes == typed && m.body_bytes_consumed == typed);
        assert(m.payload_offset_after == (uint32_t)(0xfffffff0u+(uint32_t)typed));
        short_image = malloc(typed-1u);
        assert(short_image != NULL);
        memset(short_image,0x5a,typed-1u);
        memset(&m,0xa6,sizeof(m));
        assert(action_family_17_construct(body,length,50u,1u,short_image,typed-1u,&m) ==
               ACTION_FAMILY_17_ERR_CAPACITY);
        assert(memcmp(&m,ms,sizeof(m)) == 0);
        for (size_t i=0u;i<typed-1u;++i) { assert(short_image[i] == 0x5a); }
        free(short_image);
    } else {
        ++rejected;
        assert(memcmp(&d,ds,sizeof(d)) == 0 && memcmp(&m,ms,sizeof(m)) == 0);
        assert(typed == 0xabcdefu);
        for (size_t i=0u;i<capacity;++i) { assert(image[i] == 0xb7); }
    }
    assert(memcmp(before,body,length) == 0);
    ++cases;
    free(image);
    free(before);
}

static uint8_t *fixture(size_t length, unsigned count)
{
    uint8_t *body = malloc(length == 0u ? 1u : length);
    assert(body != NULL);
    for (size_t i=0u;i<length;++i) { body[i]=(uint8_t)(i*37u+11u); }
    if (length >= 22u) {
        body[20]=(uint8_t)count;
        body[21]=(uint8_t)(count>>8);
    }
    return body;
}

int main(void)
{
    uint32_t random_state = 0x17a5b6c7u;
    for (unsigned count=0u;count<=65535u;++count) {
        uint8_t *body=fixture(22u,count);
        probe(body,22u);free(body);
    }
    for (unsigned count=0u;count<=1819u;++count) {
        for (size_t tail=0u;tail<=32u;tail+=16u) {
            size_t n=22u+18u*count+tail;
            uint8_t *body=fixture(n,count);
            probe(body,n);free(body);
        }
    }
    for (size_t n=0u;n<22u+18u*5u;++n) {
        uint8_t *body=fixture(n,5u);
        probe(body,n);free(body);
    }
    for (size_t tail=0u;tail<=40u;++tail) {
        size_t n=76u+tail;
        uint8_t *body=fixture(n,3u);
        probe(body,n);free(body);
    }
    for (size_t trial=0u;trial<20000u;++trial) {
        size_t n;
        uint8_t *body;
        random_state=random_state*1664525u+1013904223u;
        n=(size_t)(random_state%1025u);
        body=fixture(n,(unsigned)(random_state>>16));
        probe(body,n);free(body);
    }
    {
        uint8_t *buffer=fixture(512u,0u);
        uint8_t copy[512];
        ActionFamily17Constructed model;
        ActionFamily17Decoded decoded;
        memcpy(copy,buffer,512u);
        assert(action_family_17_decode(buffer,22u,(ActionFamily17Decoded *)(void *)buffer) == ACTION_FAMILY_17_ERR_OVERLAP);
        assert(action_family_17_body_length(buffer,22u,(size_t *)(void *)buffer) == ACTION_FAMILY_17_ERR_OVERLAP);
        assert(action_family_17_construct(buffer,22u,50u,1u,buffer,22u,&model) == ACTION_FAMILY_17_ERR_OVERLAP);
        assert(action_family_17_construct(buffer,22u,50u,1u,buffer+128u,22u,
            (ActionFamily17Constructed *)(void *)(buffer+128u)) == ACTION_FAMILY_17_ERR_OVERLAP);
        assert(action_family_17_decode(NULL,22u,&decoded) == ACTION_FAMILY_17_ERR_ARGUMENT);
        assert(memcmp(copy,buffer,512u) == 0);
        free(buffer);
    }
    printf("{\"cases\":%zu,\"accepted\":%zu,\"rejected\":%zu,\"overlap_null_checks\":5}\n",cases,accepted,rejected);
    return 0;
}
