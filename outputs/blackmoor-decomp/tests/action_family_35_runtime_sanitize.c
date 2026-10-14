/* Offline sanitizer entrypoint. Inputs stay private; print only case counts. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

void *rt35_new(const uint8_t *, size_t);
int rt35_step(void *, int32_t, int32_t, int32_t, int32_t, int32_t);
void rt35_free(void *);

int main(void)
{
    uint8_t size[4];
    unsigned cases = 0;
    while (fread(size, 1, 4, stdin) == 4) {
        size_t n = (size_t)size[0] | (size_t)size[1] << 8 |
                   (size_t)size[2] << 16 | (size_t)size[3] << 24;
        uint8_t *data;
        void *fixture;
        if (n > 2u * 1024u * 1024u) return 2;
        data = (uint8_t *)malloc(n != 0 ? n : 1);
        if (data == NULL || fread(data, 1, n, stdin) != n) return 3;
        fixture = rt35_new(data, n);
        if (fixture == NULL) return 4;
        if (rt35_step(fixture, 0, 0, 0, 0, 0) == 0) {
            (void)rt35_step(fixture, 1, 0, 1, 0, 1);
            (void)rt35_step(fixture, 1, 9, 0, 1, 1);
            (void)rt35_step(fixture, 2, 0, 1, 2, 0);
        }
        rt35_free(fixture);
        free(data);
        ++cases;
    }
    printf("cases=%u\n", cases);
    return ferror(stdin) ? 5 : 0;
}
