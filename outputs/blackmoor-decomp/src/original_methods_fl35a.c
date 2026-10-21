#include "original_methods_fl35a.h"

#include <string.h>

#if defined(__GNUC__)
#define FL35A_UNUSED __attribute__((unused))
#else
#define FL35A_UNUSED
#endif

FL35A_UNUSED static void wr16(uint8_t *base, ptrdiff_t off, uint16_t v)
{
    memcpy(base + off, &v, sizeof v);
}

/* host memory behind an original address (the host owns the memory; the interface only says const) */
FL35A_UNUSED static const uint8_t *res(const Fl18Host *host, uint32_t address)
{
    return host->resolve(host->context, address);
}

FL35A_UNUSED static uint32_t callv(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int n)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, n > 0 ? args : NULL, n) : 0;
}

FL35A_UNUSED static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return callv(host, callee, this_ptr, NULL, 0);
}

FL35A_UNUSED static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    const uintptr_t a[1] = {a0};
    return callv(host, callee, this_ptr, a, 1);
}

/* ---- 0x40a5c1 shared body of the 28 rows ------------------------------------------------------------------------------------------------------ */
/* `field` is the offset of the string field, `tag` the original address of the four bytes that the local buffer is compared with (the compare ends at the first differing byte; only
 * the final "all four equal" decides), `out` the world word that receives the low 16 bits of the CRT result. The word store happens before the last call, as in the original. */
static uint32_t read_tag_word(uint8_t *self, uint16_t *out, uint32_t field, uint32_t tag, const Fl18Host *host)
{
    uint8_t buf[0x14];
    uintptr_t a[2];
    memset(buf, 0, sizeof buf);                               /* the original leaves the local uninitialised; the callee below fills it */
    a[0] = (uintptr_t)buf;
    a[1] = 0x13;
    callv(host, 0x51d5b2, (uintptr_t)self + field, a, 2);
    if (memcmp(buf, res(host, tag), 4) != 0) *out = (uint16_t)call1(host, 0x50cb1b, 0, (uintptr_t)buf);
    return call0(host, 0x4090ab, (uintptr_t)self);
}

/* ---- 0x40a5c1 read_tag_word ---------------------------------------------------------------------------------------------------- */
/* 0x40a5c1 m40a5c1_read_tag_word: string field self + 0x8c, tag at the original address 0x53ec58, word 0x5ec2d6 (see read_tag_word above) */
uint32_t m40a5c1_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host)
{
    return read_tag_word(self, &world->word_5ec2d6, 0x8c, 0x53ec58, host);
}

/* ---- 0x40a6b7 read_tag_word ---------------------------------------------------------------------------------------------------- */
/* 0x40a6b7 m40a6b7_read_tag_word: string field self + 0x14c, tag at the original address 0x53ec64, word 0x5ec2dc (see read_tag_word above) */
uint32_t m40a6b7_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host)
{
    return read_tag_word(self, &world->word_5ec2dc, 0x14c, 0x53ec64, host);
}

/* ---- 0x40a709 read_tag_word ---------------------------------------------------------------------------------------------------- */
/* 0x40a709 m40a709_read_tag_word: string field self + 0x18c, tag at the original address 0x53ec68, word 0x5ec2de (see read_tag_word above) */
uint32_t m40a709_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host)
{
    return read_tag_word(self, &world->word_5ec2de, 0x18c, 0x53ec68, host);
}

/* ---- 0x40a75b read_tag_word ---------------------------------------------------------------------------------------------------- */
/* 0x40a75b m40a75b_read_tag_word: string field self + 0x1cc, tag at the original address 0x53ec6c, word 0x5ec2e0 (see read_tag_word above) */
uint32_t m40a75b_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host)
{
    return read_tag_word(self, &world->word_5ec2e0, 0x1cc, 0x53ec6c, host);
}

/* ---- 0x40a7ad read_tag_word ---------------------------------------------------------------------------------------------------- */
/* 0x40a7ad m40a7ad_read_tag_word: string field self + 0x20c, tag at the original address 0x53ec70, word 0x5ec2e2 (see read_tag_word above) */
uint32_t m40a7ad_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host)
{
    return read_tag_word(self, &world->word_5ec2e2, 0x20c, 0x53ec70, host);
}

/* ---- 0x40a7ff read_tag_word ---------------------------------------------------------------------------------------------------- */
/* 0x40a7ff m40a7ff_read_tag_word: string field self + 0x24c, tag at the original address 0x53ec74, word 0x5ec2e4 (see read_tag_word above) */
uint32_t m40a7ff_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host)
{
    return read_tag_word(self, &world->word_5ec2e4, 0x24c, 0x53ec74, host);
}

/* ---- 0x40a851 read_tag_word ---------------------------------------------------------------------------------------------------- */
/* 0x40a851 m40a851_read_tag_word: string field self + 0x28c, tag at the original address 0x53ec78, word 0x5ec2e6 (see read_tag_word above) */
uint32_t m40a851_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host)
{
    return read_tag_word(self, &world->word_5ec2e6, 0x28c, 0x53ec78, host);
}

/* ---- 0x40a8a3 read_tag_word ---------------------------------------------------------------------------------------------------- */
/* 0x40a8a3 m40a8a3_read_tag_word: string field self + 0x2cc, tag at the original address 0x53ec7c, word 0x5ec2e8 (see read_tag_word above) */
uint32_t m40a8a3_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host)
{
    return read_tag_word(self, &world->word_5ec2e8, 0x2cc, 0x53ec7c, host);
}

/* ---- 0x40a8f5 read_tag_word ---------------------------------------------------------------------------------------------------- */
/* 0x40a8f5 m40a8f5_read_tag_word: string field self + 0x30c, tag at the original address 0x53ec80, word 0x5ec2ea (see read_tag_word above) */
uint32_t m40a8f5_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host)
{
    return read_tag_word(self, &world->word_5ec2ea, 0x30c, 0x53ec80, host);
}

/* ---- 0x40a947 read_tag_word ---------------------------------------------------------------------------------------------------- */
/* 0x40a947 m40a947_read_tag_word: string field self + 0x34c, tag at the original address 0x53ec84, word 0x5ec2ec (see read_tag_word above) */
uint32_t m40a947_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host)
{
    return read_tag_word(self, &world->word_5ec2ec, 0x34c, 0x53ec84, host);
}

/* ---- 0x40a999 read_tag_word ---------------------------------------------------------------------------------------------------- */
/* 0x40a999 m40a999_read_tag_word: string field self + 0x38c, tag at the original address 0x53ec88, word 0x5ec2ee (see read_tag_word above) */
uint32_t m40a999_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host)
{
    return read_tag_word(self, &world->word_5ec2ee, 0x38c, 0x53ec88, host);
}

/* ---- 0x40a9eb read_tag_word ---------------------------------------------------------------------------------------------------- */
/* 0x40a9eb m40a9eb_read_tag_word: string field self + 0x3cc, tag at the original address 0x53ec8c, word 0x5ec2f0 (see read_tag_word above) */
uint32_t m40a9eb_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host)
{
    return read_tag_word(self, &world->word_5ec2f0, 0x3cc, 0x53ec8c, host);
}

/* ---- 0x40aa3d read_tag_word ---------------------------------------------------------------------------------------------------- */
/* 0x40aa3d m40aa3d_read_tag_word: string field self + 0x40c, tag at the original address 0x53ec90, word 0x5ec2f2 (see read_tag_word above) */
uint32_t m40aa3d_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host)
{
    return read_tag_word(self, &world->word_5ec2f2, 0x40c, 0x53ec90, host);
}

/* ---- 0x40aa8f read_tag_word ---------------------------------------------------------------------------------------------------- */
/* 0x40aa8f m40aa8f_read_tag_word: string field self + 0x44c, tag at the original address 0x53ec94, word 0x5ec2f4 (see read_tag_word above) */
uint32_t m40aa8f_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host)
{
    return read_tag_word(self, &world->word_5ec2f4, 0x44c, 0x53ec94, host);
}

/* ---- 0x40aae1 read_tag_word ---------------------------------------------------------------------------------------------------- */
/* 0x40aae1 m40aae1_read_tag_word: string field self + 0x48c, tag at the original address 0x53ec98, word 0x5ec2f6 (see read_tag_word above) */
uint32_t m40aae1_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host)
{
    return read_tag_word(self, &world->word_5ec2f6, 0x48c, 0x53ec98, host);
}

/* ---- 0x40ab33 read_tag_word ---------------------------------------------------------------------------------------------------- */
/* 0x40ab33 m40ab33_read_tag_word: string field self + 0x4cc, tag at the original address 0x53ec9c, word 0x5ec2f8 (see read_tag_word above) */
uint32_t m40ab33_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host)
{
    return read_tag_word(self, &world->word_5ec2f8, 0x4cc, 0x53ec9c, host);
}

/* ---- 0x40ab85 read_tag_word ---------------------------------------------------------------------------------------------------- */
/* 0x40ab85 m40ab85_read_tag_word: string field self + 0x50c, tag at the original address 0x53eca0, word 0x5ec2fa (see read_tag_word above) */
uint32_t m40ab85_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host)
{
    return read_tag_word(self, &world->word_5ec2fa, 0x50c, 0x53eca0, host);
}

/* ---- 0x40abd7 read_tag_word ---------------------------------------------------------------------------------------------------- */
/* 0x40abd7 m40abd7_read_tag_word: string field self + 0x54c, tag at the original address 0x53eca4, word 0x5ec2fc (see read_tag_word above) */
uint32_t m40abd7_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host)
{
    return read_tag_word(self, &world->word_5ec2fc, 0x54c, 0x53eca4, host);
}

/* ---- 0x40ac29 read_tag_word ---------------------------------------------------------------------------------------------------- */
/* 0x40ac29 m40ac29_read_tag_word: string field self + 0x58c, tag at the original address 0x53eca8, word 0x5ec2fe (see read_tag_word above) */
uint32_t m40ac29_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host)
{
    return read_tag_word(self, &world->word_5ec2fe, 0x58c, 0x53eca8, host);
}

/* ---- 0x40ac7b read_tag_word ---------------------------------------------------------------------------------------------------- */
/* 0x40ac7b m40ac7b_read_tag_word: string field self + 0x5cc, tag at the original address 0x53ecac, word 0x5ec300 (see read_tag_word above) */
uint32_t m40ac7b_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host)
{
    return read_tag_word(self, &world->word_5ec300, 0x5cc, 0x53ecac, host);
}

/* ---- 0x40accd read_tag_word ---------------------------------------------------------------------------------------------------- */
/* 0x40accd m40accd_read_tag_word: string field self + 0x60c, tag at the original address 0x53ecb0, word 0x5ec302 (see read_tag_word above) */
uint32_t m40accd_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host)
{
    return read_tag_word(self, &world->word_5ec302, 0x60c, 0x53ecb0, host);
}

/* ---- 0x40ad1f read_tag_word ---------------------------------------------------------------------------------------------------- */
/* 0x40ad1f m40ad1f_read_tag_word: string field self + 0x64c, tag at the original address 0x53ecb4, word 0x5ec304 (see read_tag_word above) */
uint32_t m40ad1f_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host)
{
    return read_tag_word(self, &world->word_5ec304, 0x64c, 0x53ecb4, host);
}

/* ---- 0x40ad71 read_tag_word ---------------------------------------------------------------------------------------------------- */
/* 0x40ad71 m40ad71_read_tag_word: string field self + 0x68c, tag at the original address 0x53ecb8, word 0x5ec306 (see read_tag_word above) */
uint32_t m40ad71_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host)
{
    return read_tag_word(self, &world->word_5ec306, 0x68c, 0x53ecb8, host);
}

/* ---- 0x40adc3 read_tag_word ---------------------------------------------------------------------------------------------------- */
/* 0x40adc3 m40adc3_read_tag_word: string field self + 0x6cc, tag at the original address 0x53ecbc, word 0x5ec308 (see read_tag_word above) */
uint32_t m40adc3_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host)
{
    return read_tag_word(self, &world->word_5ec308, 0x6cc, 0x53ecbc, host);
}

/* ---- 0x40ae15 read_tag_word ---------------------------------------------------------------------------------------------------- */
/* 0x40ae15 m40ae15_read_tag_word: string field self + 0x70c, tag at the original address 0x53ecc0, word 0x5ec30a (see read_tag_word above) */
uint32_t m40ae15_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host)
{
    return read_tag_word(self, &world->word_5ec30a, 0x70c, 0x53ecc0, host);
}

/* ---- 0x40ae67 read_tag_word ---------------------------------------------------------------------------------------------------- */
/* 0x40ae67 m40ae67_read_tag_word: string field self + 0x74c, tag at the original address 0x53ecc4, word 0x5ec30c (see read_tag_word above) */
uint32_t m40ae67_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host)
{
    return read_tag_word(self, &world->word_5ec30c, 0x74c, 0x53ecc4, host);
}

/* ---- 0x40aeb9 read_tag_word ---------------------------------------------------------------------------------------------------- */
/* 0x40aeb9 m40aeb9_read_tag_word: string field self + 0x78c, tag at the original address 0x53ecc8, word 0x5ec30e (see read_tag_word above) */
uint32_t m40aeb9_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host)
{
    return read_tag_word(self, &world->word_5ec30e, 0x78c, 0x53ecc8, host);
}

/* ---- 0x40af0b read_tag_word ---------------------------------------------------------------------------------------------------- */
/* 0x40af0b m40af0b_read_tag_word: string field self + 0x7cc, tag at the original address 0x53eccc, word 0x5ec310 (see read_tag_word above) */
uint32_t m40af0b_read_tag_word(uint8_t *self, Fl35aWorld *world, const Fl18Host *host)
{
    return read_tag_word(self, &world->word_5ec310, 0x7cc, 0x53eccc, host);
}
