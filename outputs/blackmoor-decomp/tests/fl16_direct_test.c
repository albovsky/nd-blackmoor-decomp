/* FL-16 direct tests of the small GAME.EXE methods in src/original_methods_fl16.c. Prints "PASS <name>" / "FAIL <name>: <msg>";
 * the exit status is the failure count. Fixtures are synthetic (no original bytes). Expected values come from the Ghidra
 * pseudocode and the disassembly of GAME.EXE, not from running the native code:
 *   0x4234c8  [this+4] := 0 (dword)
 *   0x423000  [this] := 0; [this+0x25] := 0; returns this
 *   0x423097  0x400 dwords at this := 0; returns this
 *   0x47d77d  nothing
 *   0x4ee5cd  returns dword [0x55cd94]
 *   0x4f709c  returns dword [this+0x1a0]
 *   0x4edf96  [this+0x4b3] := arg
 *   0x493a47  returns 0
 *   0x434773  1 iff the four signed chars at the argument are 'D' 'A' 'T' 'A'
 *   0x4347b8  bytes 0..3 as a big-endian dword
 *   0x43f04b  rows (signed) times: copy row_bytes forward (dwords then bytes), src += stride, dst += row_bytes
 *   0x44d9b5 / 0x45b568  dst[1] := src[1] + [0x58318a]; dst[3] := src[3] + [0x58318a]; dst[0] := src[0] + [0x583186]; dst[2] := src[2] + [0x583186]
 *   0x47e25a  words +0x1e and +0x1c := 0xffff; dword +0x13c5 := 0; bytes +0x13c9, +0x13ce := 0; dword +0x1344 := 0
 *   0x4bedb5  dwords +0xbc, +0x2c0, +0x2c4 := 0;  0x4bede7  = 0x4bedb5
 *   0x4bedfa  if (*arg != 0) { BinkClose(*arg); *arg := 0 }; then 0x4bedb5 on this
 *   0x4bf38c  dword +0x2c0 := 0
 *   0x4c0c18  returns dword +0x22a;  0x4c0c2c  dword +0x240;  0x4c0c54  signed word +0x244, sign-extended;  0x4c0c69  dword +0x24a
 *   0x4d3c31  returns dword +0x1c
 *   0x4e76d5  dword +0x991 := 0;  0x4e76ed = 0x4e76d5
 *   0x4e7ba7  dwords +0x764c, +0x7650 := 0; +0x8232, +0x8236 := 0xffffffff; +0x8252 := 0
 *   0x42e560  words 0x5c3a05..0x5c3a0b from words 0x5bb57b, 0x5bb57f, 0x5bb50b, 0x5bb593; word 0x5c3a0d := arg; dword 0x5c3a0f :=
 *             dword 0x5bb5a7; dword 0x5c3a13 := dword 0x5bb5ab and then := dword 0x5bb5af
 *   0x4d3d20  dword +0x456 := GetTickCount() - 5
 *   0x4b8e42  if (GetTickCount() >= dword [0x61eee1 + slot*0x37] (unsigned)) { dword [this + slot*0x37 + 0x7d] := 3; word +0x48 -= 1; 0x4b8a27(this, 2) }
 *   0x4d3c42  dword +0x1c := 1; then 0x4d3bef on this
 *   0x4e7786  0x4edfaf on this with the stack argument
 *   0x4faf98  r = 0x4fadc4(this, a1, word a2); if (r != 0) 0x4fb2e3(this, word a2)
 *   0x4ccfbd  if (dword +0x212 != 0) { 0x4c2dfb(manager 0x5cf659, this+0x212); dword +0x212 := 0 }
 *   0x4ccd70  dword [this] := 0x52e2d0; 0x4ccdab on this; returns this
 *   0x4e7728  0x43dbd5(); 0x4d36ed(); dword +0x991 := arg; 0x4edf96 on this with arg
 *   0x4e7757  dword +0x991 := 1; 0x4e76ed on this; 0x4d36ed(); dword [0x583204] := 0
 * Every test fills the object with a position-dependent pattern first and compares the whole object afterwards, so a store at a
 * wrong offset or width is caught. */
#include "../src/original_methods_fl16.h"

#include <stdio.h>
#include <string.h>

static int g_failed;
static char g_msg[256];
#define CK(cond)                                                               \
    do {                                                                       \
        if (!(cond) && !g_failed) {                                            \
            g_failed = 1;                                                      \
            snprintf(g_msg, sizeof g_msg, "line %d: %.200s", __LINE__, #cond); \
        }                                                                      \
    } while (0)

#define OBJ 0x9000u

static void fill(uint8_t *o, uint8_t seed)
{
    size_t i;
    for (i = 0; i < OBJ; i++) o[i] = (uint8_t)(i * 7u + seed + (i >> 8));
}

static void set32(uint8_t *o, size_t off, uint32_t v)
{
    memcpy(o + off, &v, 4);
}

static void set16(uint8_t *o, size_t off, uint16_t v)
{
    memcpy(o + off, &v, 2);
}

static uint32_t get32(const uint8_t *o, size_t off)
{
    uint32_t v;
    memcpy(&v, o + off, 4);
    return v;
}

/* ---- the call log of the host --------------------------------------------------------------------------------------------- */

typedef struct Log {
    int n;
    int id[16];
    uint32_t a[16];
    uint32_t b[16];
    const uint8_t *self[16];
    uint32_t tick;
    int32_t ret_4fadc4;
    uint32_t seen_212; /* the dword at the slot when release_surface ran */
} Log;

enum { C_BINK = 1, C_43DBD5, C_4D36ED, C_4D3BEF, C_4B8A27, C_4CCDAB, C_4EDFAF, C_RELEASE, C_4FADC4, C_4FB2E3 };

static void note(Log *l, int id, const uint8_t *self, uint32_t a, uint32_t b)
{
    if (l->n < 16) {
        l->id[l->n] = id;
        l->self[l->n] = self;
        l->a[l->n] = a;
        l->b[l->n] = b;
    }
    l->n++;
}

static uint32_t h_tick(void *c) { return ((Log *)c)->tick; }
static void h_bink(void *c, uint32_t h) { note(c, C_BINK, NULL, h, 0); }
static void h_43dbd5(void *c) { note(c, C_43DBD5, NULL, 0, 0); }
static void h_4d36ed(void *c) { note(c, C_4D36ED, NULL, 0, 0); }
static void h_4d3bef(void *c, uint8_t *s) { note(c, C_4D3BEF, s, 0, 0); }
static void h_4b8a27(void *c, uint8_t *s, int32_t a) { note(c, C_4B8A27, s, (uint32_t)a, 0); }
static void h_4ccdab(void *c, uint8_t *s) { note(c, C_4CCDAB, s, 0, 0); }
static void h_4edfaf(void *c, uint8_t *s, uint32_t a) { note(c, C_4EDFAF, s, a, 0); }
static void h_release(void *c, uint8_t *slot)
{
    ((Log *)c)->seen_212 = get32(slot, 0);
    note(c, C_RELEASE, slot, 0, 0);
}
static int32_t h_4fadc4(void *c, uint8_t *s, uint32_t a1, uint16_t a2)
{
    note(c, C_4FADC4, s, a1, a2);
    return ((Log *)c)->ret_4fadc4;
}
static void h_4fb2e3(void *c, uint8_t *s, uint16_t a) { note(c, C_4FB2E3, s, a, 0); }

static void host_init(Fl16Host *h, Log *l)
{
    memset(l, 0, sizeof *l);
    memset(h, 0, sizeof *h);
    h->context = l;
    h->tick = h_tick;
    h->bink_close = h_bink;
    h->call_43dbd5 = h_43dbd5;
    h->call_4d36ed = h_4d36ed;
    h->call_4d3bef = h_4d3bef;
    h->call_4b8a27 = h_4b8a27;
    h->call_4ccdab = h_4ccdab;
    h->call_4edfaf = h_4edfaf;
    h->release_surface = h_release;
    h->call_4fadc4 = h_4fadc4;
    h->call_4fb2e3 = h_4fb2e3;
}

static uint8_t g_obj[OBJ], g_exp[OBJ];

/* ---- getters --------------------------------------------------------------------------------------------------------------- */

static int test_m4f709c_get_ready(void)
{
    fill(g_obj, 1);
    set32(g_obj, 0x1a0, 0xdeadbeefu);
    CK(m4f709c_get_ready(g_obj) == 0xdeadbeefu);
    set32(g_obj, 0x1a0, 0);
    CK(m4f709c_get_ready(g_obj) == 0);
    set32(g_obj, 0x1a0, 0x80000001u);
    CK(m4f709c_get_ready(g_obj) == 0x80000001u);
    return g_failed;
}

static int test_m4c0c18_get_22a(void)
{
    fill(g_obj, 2);
    set32(g_obj, 0x22a, 0x01020304u);
    CK(m4c0c18_get_22a(g_obj) == 0x01020304u);
    set32(g_obj, 0x22a, 0xffffffffu);
    CK(m4c0c18_get_22a(g_obj) == 0xffffffffu);
    return g_failed;
}

static int test_m4c0c2c_get_240(void)
{
    fill(g_obj, 3);
    set32(g_obj, 0x240, 0x11223344u);
    CK(m4c0c2c_get_240(g_obj) == 0x11223344u);
    set32(g_obj, 0x240, 0);
    CK(m4c0c2c_get_240(g_obj) == 0);
    return g_failed;
}

static int test_m4c0c54_get_244(void)
{
    fill(g_obj, 4);
    set32(g_obj, 0x244, 0xaaaa7fffu); /* only the low word counts */
    CK(m4c0c54_get_244(g_obj) == 0x7fff);
    set32(g_obj, 0x244, 0x00008000u);
    CK(m4c0c54_get_244(g_obj) == -32768);
    set32(g_obj, 0x244, 0x5555ffffu);
    CK(m4c0c54_get_244(g_obj) == -1);
    set32(g_obj, 0x244, 0xffff0000u);
    CK(m4c0c54_get_244(g_obj) == 0);
    return g_failed;
}

static int test_m4c0c69_get_24a(void)
{
    fill(g_obj, 5);
    set32(g_obj, 0x24a, 0xcafef00du);
    CK(m4c0c69_get_24a(g_obj) == 0xcafef00du);
    set32(g_obj, 0x24a, 1);
    CK(m4c0c69_get_24a(g_obj) == 1);
    return g_failed;
}

static int test_m4d3c31_get_1c(void)
{
    fill(g_obj, 6);
    set32(g_obj, 0x1c, 0x13572468u);
    CK(m4d3c31_get_1c(g_obj) == 0x13572468u);
    set32(g_obj, 0x1c, 0);
    CK(m4d3c31_get_1c(g_obj) == 0);
    return g_failed;
}

static int test_m4ee5cd_get_global(void)
{
    Fl16World w;
    memset(&w, 0, sizeof w);
    w.value_55cd94 = 0x0badf00du;
    w.value_583204 = 77;
    CK(m4ee5cd_get_global(&w) == 0x0badf00du);
    w.value_55cd94 = 0;
    CK(m4ee5cd_get_global(&w) == 0);
    w.value_55cd94 = 0xffffffffu;
    CK(m4ee5cd_get_global(&w) == 0xffffffffu);
    CK(w.value_583204 == 77);
    return g_failed;
}

static int test_m493a47_zero(void)
{
    CK(m493a47_zero() == 0);
    return g_failed;
}

static int test_m47d77d_noop(void)
{
    m47d77d_noop();
    return g_failed;
}

/* ---- stores ---------------------------------------------------------------------------------------------------------------- */

static int test_m4234c8_depth_reset(void)
{
    fill(g_obj, 7);
    memcpy(g_exp, g_obj, OBJ);
    set32(g_exp, 4, 0);
    m4234c8_depth_reset(g_obj);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    return g_failed;
}

static int test_m423000_init_pair(void)
{
    fill(g_obj, 8);
    memcpy(g_exp, g_obj, OBJ);
    set32(g_exp, 0, 0);
    set32(g_exp, 0x25, 0);
    CK(m423000_init_pair(g_obj) == g_obj);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    return g_failed;
}

static int test_m423097_clear_table(void)
{
    fill(g_obj, 9);
    memcpy(g_exp, g_obj, OBJ);
    memset(g_exp, 0, 0x1000); /* 0x400 dwords, not one more and not one fewer */
    CK(m423097_clear_table(g_obj) == g_obj);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    CK(g_obj[0xfff] == 0 && g_obj[0x1000] == g_exp[0x1000] && g_obj[0x1000] != 0);
    return g_failed;
}

static int test_m4edf96_set_value(void)
{
    uint32_t values[] = {0, 1, 0x80000000u, 0xffffffffu, 0x12345678u};
    size_t i;
    for (i = 0; i < sizeof values / sizeof values[0]; i++) {
        fill(g_obj, 10);
        memcpy(g_exp, g_obj, OBJ);
        set32(g_exp, 0x4b3, values[i]);
        m4edf96_set_value(g_obj, values[i]);
        CK(memcmp(g_obj, g_exp, OBJ) == 0);
    }
    return g_failed;
}

static int test_m47e25a_reset_fields(void)
{
    fill(g_obj, 11);
    memcpy(g_exp, g_obj, OBJ);
    set16(g_exp, 0x1e, 0xffff);
    set16(g_exp, 0x1c, 0xffff);
    set32(g_exp, 0x13c5, 0);
    g_exp[0x13c9] = 0;
    g_exp[0x13ce] = 0;
    set32(g_exp, 0x1344, 0);
    m47e25a_reset_fields(g_obj);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    return g_failed;
}

static int test_m4bedb5_clear_state(void)
{
    fill(g_obj, 12);
    memcpy(g_exp, g_obj, OBJ);
    set32(g_exp, 0xbc, 0);
    set32(g_exp, 0x2c0, 0);
    set32(g_exp, 0x2c4, 0);
    m4bedb5_clear_state(g_obj);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    return g_failed;
}

static int test_m4bede7_clear_state(void)
{
    fill(g_obj, 13);
    memcpy(g_exp, g_obj, OBJ);
    set32(g_exp, 0xbc, 0);
    set32(g_exp, 0x2c0, 0);
    set32(g_exp, 0x2c4, 0);
    m4bede7_clear_state(g_obj);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    return g_failed;
}

static int test_m4bf38c_clear_2c0(void)
{
    fill(g_obj, 14);
    memcpy(g_exp, g_obj, OBJ);
    set32(g_exp, 0x2c0, 0);
    m4bf38c_clear_2c0(g_obj);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    return g_failed;
}

static int test_m4e76d5_clear_991(void)
{
    fill(g_obj, 15);
    memcpy(g_exp, g_obj, OBJ);
    set32(g_exp, 0x991, 0);
    m4e76d5_clear_991(g_obj);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    return g_failed;
}

static int test_m4e76ed_clear_991(void)
{
    fill(g_obj, 16);
    memcpy(g_exp, g_obj, OBJ);
    set32(g_exp, 0x991, 0);
    m4e76ed_clear_991(g_obj);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    return g_failed;
}

static int test_m4e7ba7_view_reset(void)
{
    fill(g_obj, 17);
    memcpy(g_exp, g_obj, OBJ);
    set32(g_exp, 0x764c, 0);
    set32(g_exp, 0x7650, 0);
    set32(g_exp, 0x8232, 0xffffffffu);
    set32(g_exp, 0x8236, 0xffffffffu);
    set32(g_exp, 0x8252, 0);
    m4e7ba7_view_reset(g_obj);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    return g_failed;
}

/* ---- data helpers ---------------------------------------------------------------------------------------------------------- */

static int test_m434773_is_data_tag(void)
{
    uint8_t buf[8];
    size_t i;
    CK(m434773_is_data_tag((const uint8_t *)"DATA") == 1);
    memcpy(buf, "DATAxyz", 8);
    CK(m434773_is_data_tag(buf) == 1); /* only four bytes are read */
    for (i = 0; i < 4; i++) {
        unsigned bit;
        for (bit = 0; bit < 8; bit++) {
            memcpy(buf, "DATA", 4);
            buf[i] ^= (uint8_t)(1u << bit); /* any single changed bit breaks it, including the sign bit */
            CK(m434773_is_data_tag(buf) == 0);
        }
    }
    memcpy(buf, "ATAD", 4);
    CK(m434773_is_data_tag(buf) == 0);
    memcpy(buf, "\0ATA", 4);
    CK(m434773_is_data_tag(buf) == 0);
    memcpy(buf, "dATA", 4);
    CK(m434773_is_data_tag(buf) == 0);
    return g_failed;
}

static int test_m4347b8_read_be32(void)
{
    static const uint8_t a[] = {0x12, 0x34, 0x56, 0x78, 0x9a};
    static const uint8_t b[] = {0xff, 0x00, 0x80, 0x01};
    static const uint8_t c[] = {0, 0, 0, 0};
    static const uint8_t d[] = {0x80, 0, 0, 0};
    CK(m4347b8_read_be32(a) == 0x12345678u);
    CK(m4347b8_read_be32(a + 1) == 0x3456789au);
    CK(m4347b8_read_be32(b) == 0xff008001u);
    CK(m4347b8_read_be32(c) == 0);
    CK(m4347b8_read_be32(d) == 0x80000000u);
    return g_failed;
}

static int test_m43f04b_copy_rows(void)
{
    static const uint32_t widths[] = {0, 1, 2, 3, 4, 5, 7, 8, 9, 13};
    static const int32_t strides[] = {0, 3, 8, 16, -4, 20};
    uint8_t src[512], dst[512], want[512];
    size_t w, s;
    int32_t rows;
    for (w = 0; w < sizeof widths / sizeof widths[0]; w++) {
        for (s = 0; s < sizeof strides / sizeof strides[0]; s++) {
            for (rows = -2; rows <= 4; rows++) {
                const uint8_t *from = src + 100;
                int32_t r;
                size_t i;
                for (i = 0; i < sizeof src; i++) src[i] = (uint8_t)(i * 13u + 5u);
                memset(dst, 0xee, sizeof dst);
                memset(want, 0xee, sizeof want);
                for (r = 0; r < rows; r++) {
                    for (i = 0; i < widths[w]; i++) want[(size_t)r * widths[w] + i] = from[(ptrdiff_t)r * strides[s] + (ptrdiff_t)i];
                }
                m43f04b_copy_rows(dst, from, rows, widths[w], strides[s]);
                CK(memcmp(dst, want, sizeof dst) == 0);
            }
        }
    }
    return g_failed;
}

static int test_m44d9b5_shift_rect(void)
{
    Fl16World w;
    int32_t src[4] = {10, 20, 30, 40}, dst[6] = {-1, -1, -1, -1, 77, 78};
    memset(&w, 0, sizeof w);
    w.origin_x_583186 = 100;
    w.origin_y_58318a = 5000;
    m44d9b5_shift_rect(src, dst, &w);
    CK(dst[0] == 110 && dst[1] == 5020 && dst[2] == 130 && dst[3] == 5040);
    CK(dst[4] == 77 && dst[5] == 78);
    CK(src[0] == 10 && src[1] == 20 && src[2] == 30 && src[3] == 40);
    w.origin_x_583186 = -7;
    w.origin_y_58318a = -9;
    m44d9b5_shift_rect(src, dst, &w);
    CK(dst[0] == 3 && dst[1] == 11 && dst[2] == 23 && dst[3] == 31);
    return g_failed;
}

static int test_m45b568_shift_rect(void)
{
    Fl16World w;
    int32_t src[4] = {-5, 0, 640, 479}, dst[5] = {0, 0, 0, 0, 99};
    memset(&w, 0, sizeof w);
    w.origin_x_583186 = 3;
    w.origin_y_58318a = 11;
    m45b568_shift_rect(src, dst, &w);
    CK(dst[0] == -2 && dst[1] == 11 && dst[2] == 643 && dst[3] == 490 && dst[4] == 99);
    w.origin_x_583186 = 0x7fffffff;
    w.origin_y_58318a = 1;
    m45b568_shift_rect(src, dst, &w);
    CK(dst[0] == 0x7ffffffa && dst[1] == 1 && dst[2] == (int32_t)0x8000027fu && dst[3] == 480);
    return g_failed;
}

/* ---- calls out ------------------------------------------------------------------------------------------------------------- */

static int test_m4bedfa_close_and_clear(void)
{
    Fl16Host h;
    Log l;
    uint32_t handle = 0x1234;
    host_init(&h, &l);
    fill(g_obj, 18);
    memcpy(g_exp, g_obj, OBJ);
    set32(g_exp, 0xbc, 0);
    set32(g_exp, 0x2c0, 0);
    set32(g_exp, 0x2c4, 0);
    m4bedfa_close_and_clear(g_obj, &handle, &h);
    CK(l.n == 1 && l.id[0] == C_BINK && l.a[0] == 0x1234);
    CK(handle == 0);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    /* a zero handle is not closed, the state is cleared all the same */
    host_init(&h, &l);
    fill(g_obj, 19);
    memcpy(g_exp, g_obj, OBJ);
    set32(g_exp, 0xbc, 0);
    set32(g_exp, 0x2c0, 0);
    set32(g_exp, 0x2c4, 0);
    handle = 0;
    m4bedfa_close_and_clear(g_obj, &handle, &h);
    CK(l.n == 0 && handle == 0);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    return g_failed;
}

static int test_m4d3d20_stamp_tick(void)
{
    static const uint32_t ticks[] = {100000u, 5u, 4u, 0u, 0xffffffffu};
    size_t i;
    for (i = 0; i < sizeof ticks / sizeof ticks[0]; i++) {
        Fl16Host h;
        Log l;
        host_init(&h, &l);
        l.tick = ticks[i];
        fill(g_obj, 20);
        memcpy(g_exp, g_obj, OBJ);
        set32(g_exp, 0x456, ticks[i] - 5u);
        m4d3d20_stamp_tick(g_obj, &h);
        CK(memcmp(g_obj, g_exp, OBJ) == 0);
        CK(l.n == 0);
    }
    return g_failed;
}

static int test_m4b8e42_expire_slot(void)
{
    /* the deadline table: slot i at base + i * 0x37 with base = table + 0x37, so slot -1 is addressed too */
    static const int16_t slots[] = {-1, 0, 1, 2, 3};
    static const uint32_t deadlines[] = {900u, 1000u, 1001u, 0u, 0xfffffff0u};
    static const uint32_t ticks[] = {0u, 999u, 1000u, 1001u, 0xfffffff0u, 0xffffffffu};
    uint8_t table[0x37 * 6 + 8];
    size_t i, j;
    for (i = 0; i < sizeof slots / sizeof slots[0]; i++) {
        for (j = 0; j < sizeof ticks / sizeof ticks[0]; j++) {
            Fl16Host h;
            Log l;
            Fl16World w;
            const uint8_t *base = table + 0x37;
            int due = ticks[j] >= deadlines[i];
            memset(&w, 0, sizeof w);
            w.deadlines_61eee1 = base;
            memset(table, 0x5a, sizeof table);
            memcpy(table + 0x37 + (ptrdiff_t)slots[i] * 0x37, &deadlines[i], 4);
            host_init(&h, &l);
            l.tick = ticks[j];
            fill(g_obj, 21);
            set16(g_obj, 0x48, (uint16_t)(j == 0 ? 0 : 7));
            memcpy(g_exp, g_obj, OBJ);
            if (due) {
                set32(g_exp, 0x7d + (ptrdiff_t)slots[i] * 0x37, 3);
                /* the word is decremented after the dword store; for slot -1 the store covers it (offsets 0x46..0x49) */
                {
                    uint16_t cur;
                    memcpy(&cur, g_exp + 0x48, 2);
                    set16(g_exp, 0x48, (uint16_t)(cur - 1u));
                }
            }
            m4b8e42_expire_slot(g_obj, slots[i], &w, &h);
            CK(memcmp(g_obj, g_exp, OBJ) == 0);
            if (due) {
                CK(l.n == 1 && l.id[0] == C_4B8A27 && l.self[0] == g_obj && l.a[0] == 2);
            } else {
                CK(l.n == 0);
            }
        }
    }
    return g_failed;
}

static int test_m4d3c42_set_flag(void)
{
    Fl16Host h;
    Log l;
    host_init(&h, &l);
    fill(g_obj, 22);
    memcpy(g_exp, g_obj, OBJ);
    set32(g_exp, 0x1c, 1);
    m4d3c42_set_flag(g_obj, &h);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    CK(l.n == 1 && l.id[0] == C_4D3BEF && l.self[0] == g_obj);
    return g_failed;
}

static int test_m4e7786_forward(void)
{
    Fl16Host h;
    Log l;
    host_init(&h, &l);
    fill(g_obj, 23);
    memcpy(g_exp, g_obj, OBJ);
    m4e7786_forward(g_obj, 0xfeedfaceu, &h);
    CK(l.n == 1 && l.id[0] == C_4EDFAF && l.self[0] == g_obj && l.a[0] == 0xfeedfaceu);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    return g_failed;
}

static int test_m4faf98_visit(void)
{
    Fl16Host h;
    Log l;
    host_init(&h, &l);
    fill(g_obj, 24);
    memcpy(g_exp, g_obj, OBJ);
    l.ret_4fadc4 = 1;
    m4faf98_visit(g_obj, 0x11223344u, 0xabcdu, &h);
    CK(l.n == 2);
    CK(l.id[0] == C_4FADC4 && l.self[0] == g_obj && l.a[0] == 0x11223344u && l.b[0] == 0xabcdu);
    CK(l.id[1] == C_4FB2E3 && l.self[1] == g_obj && l.a[1] == 0xabcdu);
    l.n = 0;
    l.ret_4fadc4 = -1; /* any non-zero result */
    m4faf98_visit(g_obj, 5, 6, &h);
    CK(l.n == 2 && l.id[1] == C_4FB2E3 && l.a[1] == 6);
    l.n = 0;
    l.ret_4fadc4 = 0;
    m4faf98_visit(g_obj, 7, 0x8001u, &h);
    CK(l.n == 1 && l.id[0] == C_4FADC4 && l.a[0] == 7 && l.b[0] == 0x8001u);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    return g_failed;
}

static int test_m4ccfbd_release_surface(void)
{
    Fl16Host h;
    Log l;
    host_init(&h, &l);
    fill(g_obj, 25);
    set32(g_obj, 0x212, 0x00c0ffeeu);
    memcpy(g_exp, g_obj, OBJ);
    set32(g_exp, 0x212, 0);
    m4ccfbd_release_surface(g_obj, &h);
    CK(l.n == 1 && l.id[0] == C_RELEASE && l.self[0] == g_obj + 0x212);
    CK(l.seen_212 == 0x00c0ffeeu); /* the slot still holds the surface while it is released */
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    /* nothing to release */
    host_init(&h, &l);
    fill(g_obj, 26);
    set32(g_obj, 0x212, 0);
    memcpy(g_exp, g_obj, OBJ);
    m4ccfbd_release_surface(g_obj, &h);
    CK(l.n == 0);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    return g_failed;
}

static int test_m4ccd70_construct(void)
{
    Fl16Host h;
    Log l;
    host_init(&h, &l);
    fill(g_obj, 27);
    memcpy(g_exp, g_obj, OBJ);
    set32(g_exp, 0, 0x0052e2d0u);
    CK(m4ccd70_construct(g_obj, &h) == g_obj);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    CK(l.n == 1 && l.id[0] == C_4CCDAB && l.self[0] == g_obj);
    return g_failed;
}

static int test_m4e7728_open(void)
{
    Fl16Host h;
    Log l;
    host_init(&h, &l);
    fill(g_obj, 28);
    memcpy(g_exp, g_obj, OBJ);
    set32(g_exp, 0x991, 0x600dbeefu);
    set32(g_exp, 0x4b3, 0x600dbeefu);
    m4e7728_open(g_obj, 0x600dbeefu, &h);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    CK(l.n == 2 && l.id[0] == C_43DBD5 && l.id[1] == C_4D36ED); /* in this order */
    return g_failed;
}

static int test_m4e7757_close(void)
{
    Fl16Host h;
    Log l;
    Fl16World w;
    host_init(&h, &l);
    memset(&w, 0, sizeof w);
    w.value_583204 = 9;
    w.value_55cd94 = 4;
    fill(g_obj, 29);
    memcpy(g_exp, g_obj, OBJ);
    set32(g_exp, 0x991, 0); /* set to 1 and then cleared by 0x4e76ed */
    m4e7757_close(g_obj, &h, &w);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    CK(l.n == 1 && l.id[0] == C_4D36ED);
    CK(w.value_583204 == 0 && w.value_55cd94 == 4);
    return g_failed;
}

static int test_m42e560_save_block(void)
{
    Fl16World w;
    uint8_t exp[0x12];
    memset(&w, 0, sizeof w);
    w.src_5bb57b = 0x1111;
    w.src_5bb57f = 0x2222;
    w.src_5bb50b = (int16_t)0x8003;
    w.src_5bb593 = -2;
    w.src_5bb5a7 = 0xa7a7a7a7u;
    w.src_5bb5ab = 0xababababu;
    w.src_5bb5af = 0xafafafafu;
    memset(w.block_5c3a05, 0x77, sizeof w.block_5c3a05);
    memset(exp, 0x77, sizeof exp);
    set16(exp, 0, 0x1111);
    set16(exp, 2, 0x2222);
    set16(exp, 4, 0x8003);
    set16(exp, 6, 0xfffe);
    set16(exp, 8, 0x4321);
    set32(exp, 0xa, 0xa7a7a7a7u);
    set32(exp, 0xe, 0xafafafafu); /* 0x5bb5ab is stored first and overwritten by 0x5bb5af */
    m42e560_save_block(&w, 0x4321);
    CK(memcmp(w.block_5c3a05, exp, sizeof exp) == 0);
    CK(w.src_5bb57b == 0x1111 && w.src_5bb5a7 == 0xa7a7a7a7u && w.src_5bb5ab == 0xababababu);
    return g_failed;
}

typedef int (*TestFn)(void);
static int run_one(const char *name, TestFn fn)
{
    g_failed = 0;
    memset(g_msg, 0, sizeof g_msg);
    if (fn() == 0) {
        printf("PASS %s\n", name);
        return 0;
    }
    printf("FAIL %s: %s\n", name, g_msg);
    return 1;
}

#define RUN(fn) failures += run_one(#fn, fn)

int main(void)
{
    int failures = 0;
    RUN(test_m4234c8_depth_reset);
    RUN(test_m423000_init_pair);
    RUN(test_m423097_clear_table);
    RUN(test_m47d77d_noop);
    RUN(test_m4ee5cd_get_global);
    RUN(test_m4f709c_get_ready);
    RUN(test_m4edf96_set_value);
    RUN(test_m493a47_zero);
    RUN(test_m434773_is_data_tag);
    RUN(test_m4347b8_read_be32);
    RUN(test_m43f04b_copy_rows);
    RUN(test_m44d9b5_shift_rect);
    RUN(test_m45b568_shift_rect);
    RUN(test_m47e25a_reset_fields);
    RUN(test_m4bedb5_clear_state);
    RUN(test_m4bede7_clear_state);
    RUN(test_m4bedfa_close_and_clear);
    RUN(test_m4bf38c_clear_2c0);
    RUN(test_m4c0c18_get_22a);
    RUN(test_m4c0c2c_get_240);
    RUN(test_m4c0c54_get_244);
    RUN(test_m4c0c69_get_24a);
    RUN(test_m4d3c31_get_1c);
    RUN(test_m4e76d5_clear_991);
    RUN(test_m4e76ed_clear_991);
    RUN(test_m4e7ba7_view_reset);
    RUN(test_m42e560_save_block);
    RUN(test_m4d3d20_stamp_tick);
    RUN(test_m4b8e42_expire_slot);
    RUN(test_m4d3c42_set_flag);
    RUN(test_m4e7786_forward);
    RUN(test_m4faf98_visit);
    RUN(test_m4ccfbd_release_surface);
    RUN(test_m4ccd70_construct);
    RUN(test_m4e7728_open);
    RUN(test_m4e7757_close);
    return failures;
}
