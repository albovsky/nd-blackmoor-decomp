#ifndef BLACKMOOR_ORIGINAL_METHODS_FL22A_H
#define BLACKMOOR_ORIGINAL_METHODS_FL22A_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-22 (batch a): four of the largest functions of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-21 (see
 * original_methods_fl21a.h, whose conventions apply unchanged): each is its own symbol that cites the original address in its leading
 * comment, `self` is the original `this` object as raw bytes at the original offsets, nothing is bounds-checked, and the effects keep the
 * order of the original. Fl18Host from original_methods_fl18.h is reused: Fl18Host.call (callee address, ecx value, stack arguments with
 * args[0] the LAST one pushed), Fl18Host.resolve (the original address kept in a record -> host memory, called unchecked) and Fl18Host.tick
 * (GetTickCount). A stack argument that the original pushes from a 16-bit register is a "word": only its low 16 bits are meaningful.
 *
 * Fl22aWorld holds by-value snapshots of the original's globals and pointers to its tables: a ported function reads and writes them in the
 * same order as the original, but an integration host that backs a callee with real original code must resync the world from the original's
 * memory after each Fl18Host.call and flush it to the original's memory before each call (0x463392 state 2 writes 0x5bb57b ... 0x583999
 * and 0x5bb1ca before it calls 0x42ba3a).
 *
 * Nothing here claims original source structure. */

/* The globals and tables of the original that the batch touches (named by their address). A table pointer points at the byte that the
 * original address names; for a table that a signed index addresses the caller leaves slack below it. */
typedef struct Fl22aWorld {
    uint8_t *records_5bb5e5;       /* records of stride 0x8d (record n is addressed by a signed word): +0 dword = the address of the object of the record,
                                      +0x4d dword = state (0x5bb632) */
    uint8_t *table_5d1591;         /* records of stride 0x4a, record n at 0x5d1591 + n * 0x4a (n = a signed word; the caller leaves slack) */
    const uint8_t *data_54b164;    /* 0x463392: the constant bytes of the image from 0x54b164 (a zero-terminated string) up to 0x54b210 (0xac bytes): the
                                      nine-byte patterns at 0x54b1a4, 0x54b1b0, 0x54b1bc, 0x54b1c8, 0x54b1d4, 0x54b1e0, 0x54b1ec, 0x54b1f8, 0x54b204 */
    uint8_t *flags_585801;         /* dwords at 0x585801, indexed by a signed word (the caller leaves slack on both sides) */
    uint8_t *cells_594db5;         /* 0x461d82: cells of stride 0x28 in rows of 0x140 bytes, cell(r, c) = 0x594db5 + r * 0x140 + c * 0x28 (r, c signed words; the caller
                                      leaves slack): +0 dword, +0x14 / +0x18 / +0x1c / +0x20 dwords (0x594dc9 ... 0x594dd5), +0x24 / +0x26 words (0x594dd9, 0x594ddb) */
    const uint8_t *table_622fd2;   /* 0x4778df: rows of 0xc8 bytes with entries of 0x14 bytes, entry(i, j) = 0x622fd2 + i * 0xc8 + j * 0x14: +0 byte, +1 byte, +2 word, +4 = the
                                      start of the data whose original address is handed to the draw call */
    const uint8_t *table_5d1599;   /* 0x4778df: the dword at 0x5d1599 + n * 0x4a (n = the signed word word_622fc2) */
    const uint8_t *dwords_5a0549;  /* 0x4778df: five dwords at 0x5a0549 */
    int16_t word_622fc4, word_622fc2;                                                /* 0x4778df: read */
    uint32_t value_5cf665, value_5d15e3, value_622fce, value_622fca;                 /* 0x4778df: read */
    int32_t origin_x_583186, origin_y_58318a;                                        /* 0x4778df: read */
    uint8_t byte_6237a2, byte_6237a3, byte_6237a4, byte_6237a5, byte_62383a, byte_62383b;   /* 0x4778df: read; 0x6237a3, 0x6237a4, 0x6237a5 and 0x62383b are cleared */
    uint8_t byte_6237f8, byte_63a88c, byte_63a890, byte_623819, byte_63a894;         /* 0x4778df: read (the bytes that the record bytes and each other are compared with) */
    int16_t word_624752, word_624750;                                                /* 0x45d2c6: read (the record index, the index of the table at 0x5d1599) */
    int16_t word_6247ec, word_6247ea, word_6247ee, word_624760, word_624890;         /* 0x45d2c6: read */
    uint32_t value_624892, value_62475c, value_624896, value_624758, value_624766;   /* 0x45d2c6: read; 0x62475c is cleared */
    uint32_t value_624840, value_624844, value_624848, value_62484c;                 /* 0x45d2c6: 0x624848 is read, all four are cleared */
    uint32_t value_624810, value_624814, value_624818, value_62481c;                 /* 0x45d2c6: 0x624818 is read, all four are cleared */
    uint32_t value_5bb1ca, value_583999;                                    /* 0x463392: written */
    uint32_t value_5bb57b, value_5bb59b, value_5bb59f, value_5bb5a3;       /* 0x463392: written */
    uint16_t word_5bb599, word_5bb595, word_5c39ff;                         /* 0x463392: written */
} Fl22aWorld;

/* 0x461d82: no stack argument, plain `ret`; returns 1 when the step completed a cell, otherwise 0. The divisions of the original are unguarded: when
 * the divisor (the signed word [rec+0x24a]) is 0 or the quotient overflows (dividend INT32_MIN, divisor -1) the original raises a divide fault; the
 * port returns 0 at that point instead (an explicit rejection: every store made before the division stays made, nothing after it happens). */
int32_t m461d82_move_step(uint8_t *self, Fl22aWorld *world, const Fl18Host *host);
/* 0x4778df: no stack argument, plain `ret`, no result (cdecl). Every callee is a host call (0x4c5377 thiscall on 0x5cf659 with five arguments, 0x475cc4 thiscall
 * on 0x622fa2 with two, 0x4d3836 and 0x50ca3e cdecl with three); the rectangles and the text buffer that the original keeps in its frame are host pointers to
 * locals of the port (the rectangle is four dwords left, top, right, bottom; the buffer is 0x24 bytes, zeroed at entry where the original's stack is
 * uninitialised). Nothing is bounds-checked: the loop limits are the signed words [rec+0x42] and [rec+0x44]. */
void m4778df_render(Fl22aWorld *world, const Fl18Host *host);
/* 0x45d2c6: no stack argument, plain `ret`, no result (cdecl). Every callee is a host call: B = 0x45b568 (thiscall on 0x624734, two arguments: a source address and
 * the address of a 16-byte rectangle that B fills), C = 0x4c5377 and D = 0x4c5d4b (thiscall on 0x5cf659, five arguments, the fourth is the rectangle). The rectangle
 * is a zeroed local of the port (the original's is uninitialised stack until B fills it). Nothing is bounds-checked. */
void m45d2c6_render(Fl22aWorld *world, const Fl18Host *host);
void m463392_step_scene(uint8_t *self, int16_t index, Fl22aWorld *world, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
