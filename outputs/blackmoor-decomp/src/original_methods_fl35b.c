#include "original_methods_fl35b.h"

#include <string.h>

#if defined(__GNUC__)
#define FL35B_UNUSED __attribute__((unused))
#else
#define FL35B_UNUSED
#endif

FL35B_UNUSED static void wr16(uint8_t *base, ptrdiff_t off, uint16_t v)
{
    memcpy(base + off, &v, sizeof v);
}

/* host memory behind an original address (the host owns the memory; the interface only says const) */
FL35B_UNUSED static const uint8_t *res(const Fl18Host *host, uint32_t address)
{
    return host->resolve(host->context, address);
}

FL35B_UNUSED static uint32_t callv(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int n)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, n > 0 ? args : NULL, n) : 0;
}

FL35B_UNUSED static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return callv(host, callee, this_ptr, NULL, 0);
}

FL35B_UNUSED static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    const uintptr_t a[1] = {a0};
    return callv(host, callee, this_ptr, a, 1);
}

/* ---- 0x4080fc toggle_5ec28c ----------------------------------------------------------------------------------------------------- */
/* 0x4080fc, thiscall, plain `ret`, returns eax of its last callee: the word [0x5ec28c] (read as a signed 16-bit value) is set to 0 when it is non-zero and to 1 when it is zero;
 * then 0x407ca7(this self) (thiscall, no arguments). */
/* 0x4080fc m4080fc_toggle_5ec28c */
uint32_t m4080fc_toggle_5ec28c(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    world->word_5ec28c = world->word_5ec28c != 0 ? 0 : 1;
    return call0(host, 0x407ca7, (uintptr_t)self);
}

/* ---- 0x40812e shared body of the 35 readers ---------------------------------------------------------------------------------------------------- */
/* `field` is the offset of the string field, `out` the world word that receives the low 16 bits of the CRT result. The word store happens before the last call, as in the original. */
static uint32_t read_text_word(uint8_t *self, uint16_t *out, uint32_t field, const Fl18Host *host)
{
    uint8_t buf[0x14];
    uintptr_t a[2];
    memset(buf, 0, sizeof buf);                               /* the original leaves the local uninitialised; the callee below fills it */
    a[0] = (uintptr_t)buf;
    a[1] = 0x13;
    callv(host, 0x51d5b2, (uintptr_t)self + field, a, 2);
    *out = (uint16_t)call1(host, 0x50cb1b, 0, (uintptr_t)buf);
    return call0(host, 0x407ca7, (uintptr_t)self);
}

/* ---- 0x40812e read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x40812e m40812e_read_text_word: string field self + 0x8c, word 0x5ec28e (see read_text_word above) */
uint32_t m40812e_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec28e, 0x8c, host);
}

/* ---- 0x408169 read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x408169 m408169_read_text_word: string field self + 0xcc, word 0x5ec290 (see read_text_word above) */
uint32_t m408169_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec290, 0xcc, host);
}

/* ---- 0x4081a4 read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x4081a4 m4081a4_read_text_word: string field self + 0x10c, word 0x5ec292 (see read_text_word above) */
uint32_t m4081a4_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec292, 0x10c, host);
}

/* ---- 0x4081df read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x4081df m4081df_read_text_word: string field self + 0x14c, word 0x5ec294 (see read_text_word above) */
uint32_t m4081df_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec294, 0x14c, host);
}

/* ---- 0x40821a read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x40821a m40821a_read_text_word: string field self + 0x18c, word 0x5ec296 (see read_text_word above) */
uint32_t m40821a_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec296, 0x18c, host);
}

/* ---- 0x408255 read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x408255 m408255_read_text_word: string field self + 0x1cc, word 0x5ec298 (see read_text_word above) */
uint32_t m408255_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec298, 0x1cc, host);
}

/* ---- 0x408290 read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x408290 m408290_read_text_word: string field self + 0x20c, word 0x5ec29a (see read_text_word above) */
uint32_t m408290_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec29a, 0x20c, host);
}

/* ---- 0x4082cb read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x4082cb m4082cb_read_text_word: string field self + 0x24c, word 0x5ec29c (see read_text_word above) */
uint32_t m4082cb_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec29c, 0x24c, host);
}

/* ---- 0x408306 read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x408306 m408306_read_text_word: string field self + 0x28c, word 0x5ec29e (see read_text_word above) */
uint32_t m408306_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec29e, 0x28c, host);
}

/* ---- 0x408341 read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x408341 m408341_read_text_word: string field self + 0x2cc, word 0x5ec2a0 (see read_text_word above) */
uint32_t m408341_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec2a0, 0x2cc, host);
}

/* ---- 0x40837c read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x40837c m40837c_read_text_word: string field self + 0x30c, word 0x5ec2a2 (see read_text_word above) */
uint32_t m40837c_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec2a2, 0x30c, host);
}

/* ---- 0x4083b7 read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x4083b7 m4083b7_read_text_word: string field self + 0x34c, word 0x5ec2a4 (see read_text_word above) */
uint32_t m4083b7_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec2a4, 0x34c, host);
}

/* ---- 0x4083f2 read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x4083f2 m4083f2_read_text_word: string field self + 0x38c, word 0x5ec2a6 (see read_text_word above) */
uint32_t m4083f2_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec2a6, 0x38c, host);
}

/* ---- 0x40842d read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x40842d m40842d_read_text_word: string field self + 0x3cc, word 0x5ec2a8 (see read_text_word above) */
uint32_t m40842d_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec2a8, 0x3cc, host);
}

/* ---- 0x408468 read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x408468 m408468_read_text_word: string field self + 0x40c, word 0x5ec2aa (see read_text_word above) */
uint32_t m408468_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec2aa, 0x40c, host);
}

/* ---- 0x4084a3 read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x4084a3 m4084a3_read_text_word: string field self + 0x44c, word 0x5ec2ac (see read_text_word above) */
uint32_t m4084a3_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec2ac, 0x44c, host);
}

/* ---- 0x4084de read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x4084de m4084de_read_text_word: string field self + 0x48c, word 0x5ec2ae (see read_text_word above) */
uint32_t m4084de_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec2ae, 0x48c, host);
}

/* ---- 0x408519 read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x408519 m408519_read_text_word: string field self + 0x4cc, word 0x5ec2b0 (see read_text_word above) */
uint32_t m408519_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec2b0, 0x4cc, host);
}

/* ---- 0x408554 read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x408554 m408554_read_text_word: string field self + 0x50c, word 0x5ec2b2 (see read_text_word above) */
uint32_t m408554_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec2b2, 0x50c, host);
}

/* ---- 0x40858f read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x40858f m40858f_read_text_word: string field self + 0x54c, word 0x5ec2b4 (see read_text_word above) */
uint32_t m40858f_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec2b4, 0x54c, host);
}

/* ---- 0x4085ca read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x4085ca m4085ca_read_text_word: string field self + 0x58c, word 0x5ec2b6 (see read_text_word above) */
uint32_t m4085ca_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec2b6, 0x58c, host);
}

/* ---- 0x408605 read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x408605 m408605_read_text_word: string field self + 0x5cc, word 0x5ec2b8 (see read_text_word above) */
uint32_t m408605_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec2b8, 0x5cc, host);
}

/* ---- 0x408640 read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x408640 m408640_read_text_word: string field self + 0x60c, word 0x5ec2ba (see read_text_word above) */
uint32_t m408640_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec2ba, 0x60c, host);
}

/* ---- 0x40867b read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x40867b m40867b_read_text_word: string field self + 0x64c, word 0x5ec2bc (see read_text_word above) */
uint32_t m40867b_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec2bc, 0x64c, host);
}

/* ---- 0x4086b6 read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x4086b6 m4086b6_read_text_word: string field self + 0x68c, word 0x5ec2be (see read_text_word above) */
uint32_t m4086b6_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec2be, 0x68c, host);
}

/* ---- 0x4086f1 read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x4086f1 m4086f1_read_text_word: string field self + 0x6cc, word 0x5ec2c0 (see read_text_word above) */
uint32_t m4086f1_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec2c0, 0x6cc, host);
}

/* ---- 0x40872c read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x40872c m40872c_read_text_word: string field self + 0x70c, word 0x5ec2c2 (see read_text_word above) */
uint32_t m40872c_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec2c2, 0x70c, host);
}

/* ---- 0x408767 read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x408767 m408767_read_text_word: string field self + 0x74c, word 0x5ec2c4 (see read_text_word above) */
uint32_t m408767_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec2c4, 0x74c, host);
}

/* ---- 0x4087a2 read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x4087a2 m4087a2_read_text_word: string field self + 0x78c, word 0x5ec2c6 (see read_text_word above) */
uint32_t m4087a2_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec2c6, 0x78c, host);
}

/* ---- 0x4087dd read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x4087dd m4087dd_read_text_word: string field self + 0x7cc, word 0x5ec2c8 (see read_text_word above) */
uint32_t m4087dd_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec2c8, 0x7cc, host);
}

/* ---- 0x408818 read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x408818 m408818_read_text_word: string field self + 0x80c, word 0x5ec2ca (see read_text_word above) */
uint32_t m408818_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec2ca, 0x80c, host);
}

/* ---- 0x408853 read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x408853 m408853_read_text_word: string field self + 0x84c, word 0x5ec2cc (see read_text_word above) */
uint32_t m408853_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec2cc, 0x84c, host);
}

/* ---- 0x40888e read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x40888e m40888e_read_text_word: string field self + 0x88c, word 0x5ec2ce (see read_text_word above) */
uint32_t m40888e_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec2ce, 0x88c, host);
}

/* ---- 0x4088c9 read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x4088c9 m4088c9_read_text_word: string field self + 0x8cc, word 0x5ec2d0 (see read_text_word above) */
uint32_t m4088c9_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec2d0, 0x8cc, host);
}

/* ---- 0x408904 read_text_word ---------------------------------------------------------------------------------------------------- */
/* 0x408904 m408904_read_text_word: string field self + 0x90c, word 0x5ec2d2 (see read_text_word above) */
uint32_t m408904_read_text_word(uint8_t *self, Fl35bWorld *world, const Fl18Host *host)
{
    return read_text_word(self, &world->word_5ec2d2, 0x90c, host);
}
