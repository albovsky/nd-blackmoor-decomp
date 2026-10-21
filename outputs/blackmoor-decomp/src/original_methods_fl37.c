#include "original_methods_fl37.h"

/* FL-37: see original_methods_fl37.h. The 57 rows are written out one by one (no shared helper): each carries its own address, flag and word constant. */

static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, NULL, 0) : 0;
}

/* ---- 0x406b3f toggle_5e353e: flag dword [0x5e353e], word [0x5e335e] tested with `cmp eax, 0xd` ---- */
void m406b3f_toggle_5e353e(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e353e == 1) {
        world->dword_5e353e = 0;
    } else {
        world->dword_5e353e = 1;
        if ((int16_t)world->word_5e335e == 0xd) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x406b86 toggle_5e3542: flag dword [0x5e3542], word [0x5e335e] tested with `cmp eax, 0xe` ---- */
void m406b86_toggle_5e3542(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e3542 == 1) {
        world->dword_5e3542 = 0;
    } else {
        world->dword_5e3542 = 1;
        if ((int16_t)world->word_5e335e == 0xe) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x406bcd toggle_5e3546: flag dword [0x5e3546], word [0x5e335e] tested with `cmp eax, 0xf` ---- */
void m406bcd_toggle_5e3546(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e3546 == 1) {
        world->dword_5e3546 = 0;
    } else {
        world->dword_5e3546 = 1;
        if ((int16_t)world->word_5e335e == 0xf) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x406c14 toggle_5e354a: flag dword [0x5e354a], word [0x5e335e] tested with `cmp eax, 0x10` ---- */
void m406c14_toggle_5e354a(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e354a == 1) {
        world->dword_5e354a = 0;
    } else {
        world->dword_5e354a = 1;
        if ((int16_t)world->word_5e335e == 0x10) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x406c5b toggle_5e354e: flag dword [0x5e354e], word [0x5e335e] tested with `cmp eax, 0x11` ---- */
void m406c5b_toggle_5e354e(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e354e == 1) {
        world->dword_5e354e = 0;
    } else {
        world->dword_5e354e = 1;
        if ((int16_t)world->word_5e335e == 0x11) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x406ca2 toggle_5e3552: flag dword [0x5e3552], word [0x5e335e] tested with `cmp eax, 0x12` ---- */
void m406ca2_toggle_5e3552(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e3552 == 1) {
        world->dword_5e3552 = 0;
    } else {
        world->dword_5e3552 = 1;
        if ((int16_t)world->word_5e335e == 0x12) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x406ce9 toggle_5e3556: flag dword [0x5e3556], word [0x5e335e] tested with `cmp eax, 0x13` ---- */
void m406ce9_toggle_5e3556(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e3556 == 1) {
        world->dword_5e3556 = 0;
    } else {
        world->dword_5e3556 = 1;
        if ((int16_t)world->word_5e335e == 0x13) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x406d30 toggle_5e355a: flag dword [0x5e355a], word [0x5e335e] tested with `cmp eax, 0x14` ---- */
void m406d30_toggle_5e355a(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e355a == 1) {
        world->dword_5e355a = 0;
    } else {
        world->dword_5e355a = 1;
        if ((int16_t)world->word_5e335e == 0x14) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x406d77 toggle_5e355e: flag dword [0x5e355e], word [0x5e335e] tested with `cmp eax, 0x15` ---- */
void m406d77_toggle_5e355e(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e355e == 1) {
        world->dword_5e355e = 0;
    } else {
        world->dword_5e355e = 1;
        if ((int16_t)world->word_5e335e == 0x15) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x406dbe toggle_5e3562: flag dword [0x5e3562], word [0x5e335e] tested with `cmp eax, 0x16` ---- */
void m406dbe_toggle_5e3562(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e3562 == 1) {
        world->dword_5e3562 = 0;
    } else {
        world->dword_5e3562 = 1;
        if ((int16_t)world->word_5e335e == 0x16) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x406e05 toggle_5e3566: flag dword [0x5e3566], word [0x5e335e] tested with `cmp eax, 0x17` ---- */
void m406e05_toggle_5e3566(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e3566 == 1) {
        world->dword_5e3566 = 0;
    } else {
        world->dword_5e3566 = 1;
        if ((int16_t)world->word_5e335e == 0x17) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x406e4c toggle_5e356a: flag dword [0x5e356a], word [0x5e335e] tested with `cmp eax, 0x18` ---- */
void m406e4c_toggle_5e356a(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e356a == 1) {
        world->dword_5e356a = 0;
    } else {
        world->dword_5e356a = 1;
        if ((int16_t)world->word_5e335e == 0x18) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x406e93 toggle_5e356e: flag dword [0x5e356e], word [0x5e335e] tested with `cmp eax, 0x19` ---- */
void m406e93_toggle_5e356e(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e356e == 1) {
        world->dword_5e356e = 0;
    } else {
        world->dword_5e356e = 1;
        if ((int16_t)world->word_5e335e == 0x19) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x406eda toggle_5e3572: flag dword [0x5e3572], word [0x5e335e] tested with `cmp eax, 0x1a` ---- */
void m406eda_toggle_5e3572(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e3572 == 1) {
        world->dword_5e3572 = 0;
    } else {
        world->dword_5e3572 = 1;
        if ((int16_t)world->word_5e335e == 0x1a) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x406f21 toggle_5e3576: flag dword [0x5e3576], word [0x5e335e] tested with `cmp eax, 0x1b` ---- */
void m406f21_toggle_5e3576(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e3576 == 1) {
        world->dword_5e3576 = 0;
    } else {
        world->dword_5e3576 = 1;
        if ((int16_t)world->word_5e335e == 0x1b) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x406f68 toggle_5e357a: flag dword [0x5e357a], word [0x5e335e] tested with `cmp eax, 0x1c` ---- */
void m406f68_toggle_5e357a(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e357a == 1) {
        world->dword_5e357a = 0;
    } else {
        world->dword_5e357a = 1;
        if ((int16_t)world->word_5e335e == 0x1c) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x406faf toggle_5e357e: flag dword [0x5e357e], word [0x5e335e] tested with `cmp eax, 0x1d` ---- */
void m406faf_toggle_5e357e(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e357e == 1) {
        world->dword_5e357e = 0;
    } else {
        world->dword_5e357e = 1;
        if ((int16_t)world->word_5e335e == 0x1d) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x406ff6 toggle_5e3582: flag dword [0x5e3582], word [0x5e335e] tested with `cmp eax, 0x1e` ---- */
void m406ff6_toggle_5e3582(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e3582 == 1) {
        world->dword_5e3582 = 0;
    } else {
        world->dword_5e3582 = 1;
        if ((int16_t)world->word_5e335e == 0x1e) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x40703d toggle_5e3586: flag dword [0x5e3586], word [0x5e335e] tested with `cmp eax, 0x1f` ---- */
void m40703d_toggle_5e3586(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e3586 == 1) {
        world->dword_5e3586 = 0;
    } else {
        world->dword_5e3586 = 1;
        if ((int16_t)world->word_5e335e == 0x1f) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x407084 toggle_5e358a: flag dword [0x5e358a], word [0x5e335e] tested with `cmp eax, 0x20` ---- */
void m407084_toggle_5e358a(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e358a == 1) {
        world->dword_5e358a = 0;
    } else {
        world->dword_5e358a = 1;
        if ((int16_t)world->word_5e335e == 0x20) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x4070cb toggle_5e358e: flag dword [0x5e358e], word [0x5e335e] tested with `cmp eax, 0x21` ---- */
void m4070cb_toggle_5e358e(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e358e == 1) {
        world->dword_5e358e = 0;
    } else {
        world->dword_5e358e = 1;
        if ((int16_t)world->word_5e335e == 0x21) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x407112 toggle_5e3592: flag dword [0x5e3592], word [0x5e335e] tested with `cmp eax, 0x22` ---- */
void m407112_toggle_5e3592(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e3592 == 1) {
        world->dword_5e3592 = 0;
    } else {
        world->dword_5e3592 = 1;
        if ((int16_t)world->word_5e335e == 0x22) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x407159 toggle_5e3596: flag dword [0x5e3596], word [0x5e335e] tested with `cmp eax, 0x23` ---- */
void m407159_toggle_5e3596(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e3596 == 1) {
        world->dword_5e3596 = 0;
    } else {
        world->dword_5e3596 = 1;
        if ((int16_t)world->word_5e335e == 0x23) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x4071a0 toggle_5e359a: flag dword [0x5e359a], word [0x5e335e] tested with `cmp eax, 0x24` ---- */
void m4071a0_toggle_5e359a(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e359a == 1) {
        world->dword_5e359a = 0;
    } else {
        world->dword_5e359a = 1;
        if ((int16_t)world->word_5e335e == 0x24) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x4071e7 toggle_5e359e: flag dword [0x5e359e], word [0x5e335e] tested with `cmp eax, 0x25` ---- */
void m4071e7_toggle_5e359e(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e359e == 1) {
        world->dword_5e359e = 0;
    } else {
        world->dword_5e359e = 1;
        if ((int16_t)world->word_5e335e == 0x25) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x40722e toggle_5e35a2: flag dword [0x5e35a2], word [0x5e335e] tested with `cmp eax, 0x26` ---- */
void m40722e_toggle_5e35a2(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e35a2 == 1) {
        world->dword_5e35a2 = 0;
    } else {
        world->dword_5e35a2 = 1;
        if ((int16_t)world->word_5e335e == 0x26) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x407275 toggle_5e35a6: flag dword [0x5e35a6], word [0x5e335e] tested with `cmp eax, 0x27` ---- */
void m407275_toggle_5e35a6(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e35a6 == 1) {
        world->dword_5e35a6 = 0;
    } else {
        world->dword_5e35a6 = 1;
        if ((int16_t)world->word_5e335e == 0x27) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x4072bc toggle_5e35aa: flag dword [0x5e35aa], word [0x5e335e] tested with `cmp eax, 0x28` ---- */
void m4072bc_toggle_5e35aa(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e35aa == 1) {
        world->dword_5e35aa = 0;
    } else {
        world->dword_5e35aa = 1;
        if ((int16_t)world->word_5e335e == 0x28) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x407303 toggle_5e35ae: flag dword [0x5e35ae], word [0x5e335e] tested with `cmp eax, 0x29` ---- */
void m407303_toggle_5e35ae(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e35ae == 1) {
        world->dword_5e35ae = 0;
    } else {
        world->dword_5e35ae = 1;
        if ((int16_t)world->word_5e335e == 0x29) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x40734a toggle_5e35b2: flag dword [0x5e35b2], word [0x5e335e] tested with `cmp eax, 0x2a` ---- */
void m40734a_toggle_5e35b2(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e35b2 == 1) {
        world->dword_5e35b2 = 0;
    } else {
        world->dword_5e35b2 = 1;
        if ((int16_t)world->word_5e335e == 0x2a) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x407391 toggle_5e35b6: flag dword [0x5e35b6], word [0x5e335e] tested with `cmp eax, 0x2b` ---- */
void m407391_toggle_5e35b6(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e35b6 == 1) {
        world->dword_5e35b6 = 0;
    } else {
        world->dword_5e35b6 = 1;
        if ((int16_t)world->word_5e335e == 0x2b) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x4073d8 toggle_5e35ba: flag dword [0x5e35ba], word [0x5e335e] tested with `cmp eax, 0x2c` ---- */
void m4073d8_toggle_5e35ba(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e35ba == 1) {
        world->dword_5e35ba = 0;
    } else {
        world->dword_5e35ba = 1;
        if ((int16_t)world->word_5e335e == 0x2c) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x40741f toggle_5e35be: flag dword [0x5e35be], word [0x5e335e] tested with `cmp eax, 0x2d` ---- */
void m40741f_toggle_5e35be(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e35be == 1) {
        world->dword_5e35be = 0;
    } else {
        world->dword_5e35be = 1;
        if ((int16_t)world->word_5e335e == 0x2d) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x407466 toggle_5e35c2: flag dword [0x5e35c2], word [0x5e335e] tested with `cmp eax, 0x2e` ---- */
void m407466_toggle_5e35c2(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e35c2 == 1) {
        world->dword_5e35c2 = 0;
    } else {
        world->dword_5e35c2 = 1;
        if ((int16_t)world->word_5e335e == 0x2e) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x4074ad toggle_5e35c6: flag dword [0x5e35c6], word [0x5e335e] tested with `cmp eax, 0x2f` ---- */
void m4074ad_toggle_5e35c6(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e35c6 == 1) {
        world->dword_5e35c6 = 0;
    } else {
        world->dword_5e35c6 = 1;
        if ((int16_t)world->word_5e335e == 0x2f) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x4074f4 toggle_5e35ca: flag dword [0x5e35ca], word [0x5e335e] tested with `cmp eax, 0x30` ---- */
void m4074f4_toggle_5e35ca(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e35ca == 1) {
        world->dword_5e35ca = 0;
    } else {
        world->dword_5e35ca = 1;
        if ((int16_t)world->word_5e335e == 0x30) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x40753b toggle_5e35ce: flag dword [0x5e35ce], word [0x5e335e] tested with `cmp eax, 0x31` ---- */
void m40753b_toggle_5e35ce(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e35ce == 1) {
        world->dword_5e35ce = 0;
    } else {
        world->dword_5e35ce = 1;
        if ((int16_t)world->word_5e335e == 0x31) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x407582 toggle_5e35d2: flag dword [0x5e35d2], word [0x5e335e] tested with `cmp eax, 0x32` ---- */
void m407582_toggle_5e35d2(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e35d2 == 1) {
        world->dword_5e35d2 = 0;
    } else {
        world->dword_5e35d2 = 1;
        if ((int16_t)world->word_5e335e == 0x32) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x4075c9 toggle_5e35d6: flag dword [0x5e35d6], word [0x5e335e] tested with `cmp eax, 0x33` ---- */
void m4075c9_toggle_5e35d6(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e35d6 == 1) {
        world->dword_5e35d6 = 0;
    } else {
        world->dword_5e35d6 = 1;
        if ((int16_t)world->word_5e335e == 0x33) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x407610 toggle_5e35da: flag dword [0x5e35da], word [0x5e335e] tested with `cmp eax, 0x34` ---- */
void m407610_toggle_5e35da(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e35da == 1) {
        world->dword_5e35da = 0;
    } else {
        world->dword_5e35da = 1;
        if ((int16_t)world->word_5e335e == 0x34) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x407657 toggle_5e35de: flag dword [0x5e35de], word [0x5e335e] tested with `cmp eax, 0x35` ---- */
void m407657_toggle_5e35de(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e35de == 1) {
        world->dword_5e35de = 0;
    } else {
        world->dword_5e35de = 1;
        if ((int16_t)world->word_5e335e == 0x35) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x40769e toggle_5e35e2: flag dword [0x5e35e2], word [0x5e335e] tested with `cmp eax, 0x36` ---- */
void m40769e_toggle_5e35e2(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e35e2 == 1) {
        world->dword_5e35e2 = 0;
    } else {
        world->dword_5e35e2 = 1;
        if ((int16_t)world->word_5e335e == 0x36) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x4076e5 toggle_5e35e6: flag dword [0x5e35e6], word [0x5e335e] tested with `cmp eax, 0x37` ---- */
void m4076e5_toggle_5e35e6(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e35e6 == 1) {
        world->dword_5e35e6 = 0;
    } else {
        world->dword_5e35e6 = 1;
        if ((int16_t)world->word_5e335e == 0x37) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x40772c toggle_5e35ea: flag dword [0x5e35ea], word [0x5e335e] tested with `cmp eax, 0x38` ---- */
void m40772c_toggle_5e35ea(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e35ea == 1) {
        world->dword_5e35ea = 0;
    } else {
        world->dword_5e35ea = 1;
        if ((int16_t)world->word_5e335e == 0x38) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x407773 toggle_5e35ee: flag dword [0x5e35ee], word [0x5e335e] tested with `cmp eax, 0x39` ---- */
void m407773_toggle_5e35ee(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e35ee == 1) {
        world->dword_5e35ee = 0;
    } else {
        world->dword_5e35ee = 1;
        if ((int16_t)world->word_5e335e == 0x39) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x4077ba toggle_5e35f2: flag dword [0x5e35f2], word [0x5e335e] tested with `cmp eax, 0x3a` ---- */
void m4077ba_toggle_5e35f2(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e35f2 == 1) {
        world->dword_5e35f2 = 0;
    } else {
        world->dword_5e35f2 = 1;
        if ((int16_t)world->word_5e335e == 0x3a) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x407801 toggle_5e35f6: flag dword [0x5e35f6], word [0x5e335e] tested with `cmp eax, 0x3b` ---- */
void m407801_toggle_5e35f6(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e35f6 == 1) {
        world->dword_5e35f6 = 0;
    } else {
        world->dword_5e35f6 = 1;
        if ((int16_t)world->word_5e335e == 0x3b) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x407848 toggle_5e35fa: flag dword [0x5e35fa], word [0x5e335e] tested with `cmp eax, 0x3c` ---- */
void m407848_toggle_5e35fa(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e35fa == 1) {
        world->dword_5e35fa = 0;
    } else {
        world->dword_5e35fa = 1;
        if ((int16_t)world->word_5e335e == 0x3c) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x40788f toggle_5e35fe: flag dword [0x5e35fe], word [0x5e335e] tested with `cmp eax, 0x3d` ---- */
void m40788f_toggle_5e35fe(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e35fe == 1) {
        world->dword_5e35fe = 0;
    } else {
        world->dword_5e35fe = 1;
        if ((int16_t)world->word_5e335e == 0x3d) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x4078d6 toggle_5e3602: flag dword [0x5e3602], word [0x5e335e] tested with `cmp eax, 0x3e` ---- */
void m4078d6_toggle_5e3602(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e3602 == 1) {
        world->dword_5e3602 = 0;
    } else {
        world->dword_5e3602 = 1;
        if ((int16_t)world->word_5e335e == 0x3e) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x40791d toggle_5e3606: flag dword [0x5e3606], word [0x5e335e] tested with `cmp eax, 0x3f` ---- */
void m40791d_toggle_5e3606(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e3606 == 1) {
        world->dword_5e3606 = 0;
    } else {
        world->dword_5e3606 = 1;
        if ((int16_t)world->word_5e335e == 0x3f) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x407964 toggle_5e360a: flag dword [0x5e360a], word [0x5e335e] tested with `cmp eax, 0x40` ---- */
void m407964_toggle_5e360a(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e360a == 1) {
        world->dword_5e360a = 0;
    } else {
        world->dword_5e360a = 1;
        if ((int16_t)world->word_5e335e == 0x40) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x4079ab toggle_5e360e: flag dword [0x5e360e], word [0x5e335e] tested with `cmp eax, 0x41` ---- */
void m4079ab_toggle_5e360e(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e360e == 1) {
        world->dword_5e360e = 0;
    } else {
        world->dword_5e360e = 1;
        if ((int16_t)world->word_5e335e == 0x41) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x4079f2 toggle_5e3612: flag dword [0x5e3612], word [0x5e335e] tested with `cmp eax, 0x42` ---- */
void m4079f2_toggle_5e3612(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e3612 == 1) {
        world->dword_5e3612 = 0;
    } else {
        world->dword_5e3612 = 1;
        if ((int16_t)world->word_5e335e == 0x42) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x407a39 toggle_5e3616: flag dword [0x5e3616], word [0x5e335e] tested with `cmp eax, 0x43` ---- */
void m407a39_toggle_5e3616(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e3616 == 1) {
        world->dword_5e3616 = 0;
    } else {
        world->dword_5e3616 = 1;
        if ((int16_t)world->word_5e335e == 0x43) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x407a80 toggle_5e361a: flag dword [0x5e361a], word [0x5e335e] tested with `cmp eax, 0x44` ---- */
void m407a80_toggle_5e361a(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e361a == 1) {
        world->dword_5e361a = 0;
    } else {
        world->dword_5e361a = 1;
        if ((int16_t)world->word_5e335e == 0x44) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x407ac7 toggle_5e361e: flag dword [0x5e361e], word [0x5e335e] tested with `cmp eax, 0x45` ---- */
void m407ac7_toggle_5e361e(uint8_t *self, Fl37World *world, const Fl18Host *host)
{
    if (world->dword_5e361e == 1) {
        world->dword_5e361e = 0;
    } else {
        world->dword_5e361e = 1;
        if ((int16_t)world->word_5e335e == 0x45) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}
