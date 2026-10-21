#include "original_methods_fl34b.h"

/* FL-34 (batch b): see original_methods_fl34b.h. The ten rows are written out one by one (no shared helper): each carries its own address, flag and word constant. */

static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, NULL, 0) : 0;
}

/* ---- 0x4067a5 toggle_5e350a: flag dword [0x5e350a], word [0x5e335e] tested with `test eax, eax` (k = 0) ---- */
void m4067a5_toggle_5e350a(uint8_t *self, Fl34bWorld *world, const Fl18Host *host)
{
    if (world->dword_5e350a == 1) {
        world->dword_5e350a = 0;
    } else {
        world->dword_5e350a = 1;
        if ((int16_t)world->word_5e335e == 0x0) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x4068c0 toggle_5e351a: flag dword [0x5e351a], word [0x5e335e] tested with `cmp eax, 0x4` ---- */
void m4068c0_toggle_5e351a(uint8_t *self, Fl34bWorld *world, const Fl18Host *host)
{
    if (world->dword_5e351a == 1) {
        world->dword_5e351a = 0;
    } else {
        world->dword_5e351a = 1;
        if ((int16_t)world->word_5e335e == 0x4) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x406907 toggle_5e351e: flag dword [0x5e351e], word [0x5e335e] tested with `cmp eax, 0x5` ---- */
void m406907_toggle_5e351e(uint8_t *self, Fl34bWorld *world, const Fl18Host *host)
{
    if (world->dword_5e351e == 1) {
        world->dword_5e351e = 0;
    } else {
        world->dword_5e351e = 1;
        if ((int16_t)world->word_5e335e == 0x5) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x40694e toggle_5e3522: flag dword [0x5e3522], word [0x5e335e] tested with `cmp eax, 0x6` ---- */
void m40694e_toggle_5e3522(uint8_t *self, Fl34bWorld *world, const Fl18Host *host)
{
    if (world->dword_5e3522 == 1) {
        world->dword_5e3522 = 0;
    } else {
        world->dword_5e3522 = 1;
        if ((int16_t)world->word_5e335e == 0x6) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x406995 toggle_5e3526: flag dword [0x5e3526], word [0x5e335e] tested with `cmp eax, 0x7` ---- */
void m406995_toggle_5e3526(uint8_t *self, Fl34bWorld *world, const Fl18Host *host)
{
    if (world->dword_5e3526 == 1) {
        world->dword_5e3526 = 0;
    } else {
        world->dword_5e3526 = 1;
        if ((int16_t)world->word_5e335e == 0x7) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x4069dc toggle_5e352a: flag dword [0x5e352a], word [0x5e335e] tested with `cmp eax, 0x8` ---- */
void m4069dc_toggle_5e352a(uint8_t *self, Fl34bWorld *world, const Fl18Host *host)
{
    if (world->dword_5e352a == 1) {
        world->dword_5e352a = 0;
    } else {
        world->dword_5e352a = 1;
        if ((int16_t)world->word_5e335e == 0x8) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x406a23 toggle_5e352e: flag dword [0x5e352e], word [0x5e335e] tested with `cmp eax, 0x9` ---- */
void m406a23_toggle_5e352e(uint8_t *self, Fl34bWorld *world, const Fl18Host *host)
{
    if (world->dword_5e352e == 1) {
        world->dword_5e352e = 0;
    } else {
        world->dword_5e352e = 1;
        if ((int16_t)world->word_5e335e == 0x9) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x406a6a toggle_5e3532: flag dword [0x5e3532], word [0x5e335e] tested with `cmp eax, 0xa` ---- */
void m406a6a_toggle_5e3532(uint8_t *self, Fl34bWorld *world, const Fl18Host *host)
{
    if (world->dword_5e3532 == 1) {
        world->dword_5e3532 = 0;
    } else {
        world->dword_5e3532 = 1;
        if ((int16_t)world->word_5e335e == 0xa) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x406ab1 toggle_5e3536: flag dword [0x5e3536], word [0x5e335e] tested with `cmp eax, 0xb` ---- */
void m406ab1_toggle_5e3536(uint8_t *self, Fl34bWorld *world, const Fl18Host *host)
{
    if (world->dword_5e3536 == 1) {
        world->dword_5e3536 = 0;
    } else {
        world->dword_5e3536 = 1;
        if ((int16_t)world->word_5e335e == 0xb) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x406af8 toggle_5e353a: flag dword [0x5e353a], word [0x5e335e] tested with `cmp eax, 0xc` ---- */
void m406af8_toggle_5e353a(uint8_t *self, Fl34bWorld *world, const Fl18Host *host)
{
    if (world->dword_5e353a == 1) {
        world->dword_5e353a = 0;
    } else {
        world->dword_5e353a = 1;
        if ((int16_t)world->word_5e335e == 0xc) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* FNS-END */
