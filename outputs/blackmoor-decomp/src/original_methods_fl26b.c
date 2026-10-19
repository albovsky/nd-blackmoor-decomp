#include "original_methods_fl26b.h"

#include <string.h>

static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

static void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
{
    memcpy(base + off, &v, sizeof v);
}

static uint16_t rd16(const uint8_t *base, ptrdiff_t off)
{
    uint16_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

static void wr16(uint8_t *base, ptrdiff_t off, uint16_t v)
{
    memcpy(base + off, &v, sizeof v);
}

/* a signed word, sign-extended (movsx) */
static int32_t rds16(const uint8_t *base, ptrdiff_t off)
{
    return (int16_t)rd16(base, off);
}

static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, NULL, 0) : 0;
}

static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    uintptr_t args[1];
    args[0] = a0;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 1) : 0;
}

static uint32_t call2(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1)
{
    uintptr_t args[2];
    args[0] = a0;
    args[1] = a1;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 2) : 0;
}

static uint32_t call3(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2)
{
    uintptr_t args[3];
    args[0] = a0;
    args[1] = a1;
    args[2] = a2;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 3) : 0;
}

/* ---- guest memory behind original addresses --------------------------------------------------------------------------------- */

typedef struct Ctx {
    const Fl18Host *host;
    int bad;     /* an address could not be resolved: the original would have touched wild memory */
} Ctx;

static uint8_t *at(Ctx *c, uint32_t address)
{
    uint8_t *p = (uint8_t *)c->host->resolve(c->host->context, address);
    if (p == NULL) c->bad = 1;
    return p;
}

static uint32_t g32(Ctx *c, uint32_t a, uint32_t off)
{
    const uint8_t *p = at(c, a + off);
    return p != NULL ? rd32(p, 0) : 0;
}

static int32_t g16s(Ctx *c, uint32_t a, uint32_t off)
{
    const uint8_t *p = at(c, a + off);
    return p != NULL ? rds16(p, 0) : 0;
}

static uint16_t g16(Ctx *c, uint32_t a, uint32_t off)
{
    const uint8_t *p = at(c, a + off);
    return p != NULL ? rd16(p, 0) : 0;
}

static void s32(Ctx *c, uint32_t a, uint32_t off, uint32_t v)
{
    uint8_t *p = at(c, a + off);
    if (p != NULL) wr32(p, 0, v);
}

static void finish(Ctx *c, int32_t *reject)
{
    if (reject != NULL) *reject = c->bad ? FL26B_REJECT_UNRESOLVED : 0;
}

/* a loop of the original that does not end by itself is stopped after this many passes (native rejection) */
#define STEP_LIMIT 0x100000u

/* ---- 0x423fbb -------------------------------------------------------------------------------------------------------------- */

/* 0x423fbb, thiscall, `ret 4`: node is the argument [ebp+8] (the address of an object; ecx is stored in a local and never used). */
int32_t m423fbb_leaf_word(uint32_t node, const Fl18Host *host, int32_t *reject)
{
    Ctx c = {host, 0};
    uint32_t leaf;
    int32_t result = 0;
    leaf = g32(&c, node, 0x1c);
    if (!c.bad) {
        if (leaf == 0) {
            s32(&c, node, 0x20, 0);
            result = -1;
        } else {
            s32(&c, node, 0x20, g32(&c, leaf, 0x40));
            result = g16s(&c, g32(&c, node, 0x1c), 0x12);
        }
    }
    finish(&c, reject);
    return c.bad ? INT32_MIN : result;      /* (INT32_MIN is outside the range of a word and of -1: a rejection is visible even without `reject`) */
}

/* ---- 0x4eb107 -------------------------------------------------------------------------------------------------------------- */

/* 0x4eb107, thiscall, `ret 4`: arg is the dword [ebp+8]; the item is the signed word 0x583a29 (movsx, then a 32-bit compare). The signed word of
 * self at item * 0x16d + 0x77e is read twice (the test against 0 and the test against 2); nothing writes it in between. The first stack
 * argument of 0x4e9e84 is `mov cx, word [0x583a29]; push ecx`: ecx still holds item * 0x16d (imul) in its upper half. */
void m4eb107_item_use_feedback(uint8_t *self, int32_t arg, Fl26bWorld *world, const Fl18Host *host)
{
    int32_t item = world->word_583a29;
    if (item != arg) return;
    {
        ptrdiff_t at_ = (ptrdiff_t)(item * 0x16d) + 0x77e;
        if (rds16(self, at_) == 0) {
            world->word_583a29 = -1;
        } else if (rds16(self, at_) == 2) {
            uint32_t ecx = ((uint32_t)(item * 0x16d) & 0xffff0000u) | (uint16_t)world->word_583a29;
            call2(host, 0x4e9e84, (uintptr_t)self, ecx, 1);
            world->word_583a29 = -1;
        }
    }
    call0(host, 0x4d36ed, 0);
}

/* ---- 0x42406d -------------------------------------------------------------------------------------------------------------- */

/* 0x42406d, thiscall, `ret 4`: node is [ebp+8] (ecx stored, unused). p = [ebp-4], nx = [ebp-0x10], ch = [ebp-8], cnt = [ebp-0x14], count = [ebp-0xc].
 * [p + 4] of the head is read without a test (a zero [node + 4] is an unresolved address here: rejected). */
void m42406d_propagate(uint32_t node, const Fl18Host *host, int32_t *reject)
{
    Ctx c = {host, 0};
    uint32_t p, nx, ch, cnt = 0, count;
    uint32_t steps = 0;
    p = g32(&c, node, 4);
    for (;;) {
        if (c.bad) break;
        if (++steps > STEP_LIMIT) {
            if (reject != NULL) *reject = FL26B_REJECT_ENDLESS;
            return;
        }
        nx = g32(&c, p, 0x38);
        ch = g32(&c, p, 0x34);
        if (c.bad) break;
        if (ch != 0 && g16s(&c, ch, 0x16) == 1) {
            if (g32(&c, p, 4) == 0 && g32(&c, ch, 4) != 0) {
                s32(&c, p, 4, 1);
                cnt++;
            } else if (g32(&c, p, 4) != 0 && g32(&c, ch, 4) == 0) {
                s32(&c, ch, 4, 1);
                cnt++;
            }
        }
        if (c.bad) break;
        if (nx != 0) {
            if (g16s(&c, p, 0x16) == 1) {
                if (g32(&c, p, 4) == 0 && g32(&c, nx, 4) != 0) {
                    s32(&c, p, 4, 1);
                    cnt++;
                } else if (g32(&c, p, 4) != 0 && g32(&c, nx, 4) == 0) {
                    s32(&c, nx, 4, 1);
                    cnt++;
                }
            }
            p = nx;
        } else if (cnt != 0) {
            cnt = 0;
            p = g32(&c, node, 4);
        } else {
            break;
        }
    }
    if (c.bad) {
        finish(&c, reject);
        return;
    }
    count = 0;
    p = g32(&c, node, 4);
    for (;;) {
        if (g32(&c, p, 4) != 0) count++;
        p = g32(&c, p, 0x38);
        if (c.bad) break;
        if (p == 0) break;
    }
    if (!c.bad) {
        if (g32(&c, node, 0x18) == count) {
            s32(&c, node, 0, 1);
            if (g32(&c, node, 0xc) != 0) s32(&c, g32(&c, node, 0xc), 4, 1);
        } else {
            s32(&c, node, 0, 0);
            if (g32(&c, node, 0xc) != 0) s32(&c, g32(&c, node, 0xc), 4, 0);
        }
    }
    finish(&c, reject);
}

/* ---- 0x424201 -------------------------------------------------------------------------------------------------------------- */

/* 0x424201, thiscall, `ret 4`: node is [ebp+8] (changed in the kind 1 arm), p = [ebp-8], done = [ebp-0xc], q = [ebp-4], this = [ebp-0x10]. */
void m424201_walk(uint8_t *self, uint32_t node, const Fl26bWorld *world, const Fl18Host *host, int32_t *reject)
{
    Ctx c = {host, 0};
    uint32_t p, q, done = 0, steps = 0;
    p = g32(&c, node, 4);
    while (done == 0) {
        uint32_t kind;
        if (c.bad) break;
        if (++steps > STEP_LIMIT) {
            if (reject != NULL) *reject = FL26B_REJECT_ENDLESS;
            return;
        }
        kind = g32(&c, p, 0);
        if (c.bad) break;
        if (kind == 2) {
            s32(&c, p, 8, g32(&c, p, 4));
            call1(host, 0x424346, (uintptr_t)self, p);
            p = g32(&c, p, 0x38);
            if (p == 0) {
                call1(host, 0x42406d, (uintptr_t)self, node);
                done = 1;
            }
        } else if (kind == 1) {
            s32(&c, p, 8, g32(&c, p, 4));
            call2(host, 0x42356d, (uintptr_t)self, node, p);
            call1(host, 0x424201, (uintptr_t)self, g32(&c, p, 0x44));
            q = call0(host, 0x4235fd, (uintptr_t)self);
            if (q != 0) {
                p = g32(&c, q, 8);
                node = g32(&c, q, 0);
                p = g32(&c, p, 0x38);
                if (c.bad) break;
                if (p == 0) {
                    call1(host, 0x42406d, (uintptr_t)self, node);
                    done = 1;
                } else {
                    done = 0;
                }
            } else {
                call2(host, 0x50ca3e, 0, 0x63888b, 0x544964);
                call3(host, 0x52139c, 0, 0x63888b, 0, 0);
                if ((int16_t)world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x63888b);
                call0(host, 0x4c97b4, 0x5cf659);
                break;
            }
        } else {
            if (reject != NULL) *reject = FL26B_REJECT_ENDLESS;
            return;
        }
    }
    finish(&c, reject);
}

/* ---- 0x42ea87 -------------------------------------------------------------------------------------------------------------- */

/* 0x42ea87, cdecl, plain `ret`: index is the word [ebp+8], movsx and multiplied by 0x8d. rec = the record at 0x5bb5e5 + index * 0x8d: dword [rec]
 * the address of its object, byte [rec - 2] (0x5bb5e3) its kind (0x63 or other), dword [rec + 0x4d] (0x5bb632) its state, dword [rec + 0x41] and byte
 * [rec + 0x40] flags, words [rec + 0x45 .. 0x4b] results. w8 is the word [ebp-8] (object word 0x28 or 8, signed). */
void m42ea87_record_state(int16_t index, Fl26bWorld *world, const Fl18Host *host, int32_t *reject)
{
    Ctx c = {host, 0};
    uint8_t *rec = world->records_5bb5e5 + (ptrdiff_t)((int32_t)index * 0x8d);
    uint32_t obj = rd32(rec, 0);
    int is63 = rec[-2] == 0x63;
    int32_t w8 = g16s(&c, obj, is63 ? 0x28 : 8);
    uint32_t state = rd32(rec, 0x4d);
    if (c.bad) {
        finish(&c, reject);
        return;
    }
    if (state == 0 || state == 1) {
        int16_t k;
        uint32_t list;
        if (state == 0) {
            world->value_5bb1ca = 1;
            wr32(rec, 0x4d, 1);
        }
        wr32(rec, 0x41, 0);
        list = obj + (is63 ? 0x2a : 0xa);
        for (k = 0; !c.bad && (int32_t)k < g16s(&c, list, 0); k++) {
            uint32_t e = list + (uint32_t)((int32_t)k * 0x12);
            if (g16s(&c, e, 2) == (int32_t)world->word_5bb50b) {
                wr32(rec, 0x41, 1);
                wr16(rec, 0x45, g16(&c, e, 4));
                wr16(rec, 0x47, g16(&c, e, 8));
                wr16(rec, 0x49, g16(&c, e, 0xc));
                wr16(rec, 0x4b, g16(&c, e, 0x10));
                break;
            }
        }
    } else if (state == 2) {
        if ((int16_t)w8 < 0x23) {
            int16_t k, bound;
            rec[0x40] = 1;
            wr32(rec, 0x41, 0);
            bound = is63 ? 10 : 2;
            for (k = 0; (int32_t)k < (int32_t)bound; k++) {
                int32_t a = g16s(&c, obj, (uint32_t)((int32_t)k * 4));
                if (a != -1) {
                    int32_t b = g16s(&c, obj, (uint32_t)((int32_t)k * 4 + 2));
                    wr32(world->flags_585801, (ptrdiff_t)a * 4, (uint32_t)b);
                }
            }
            call1(host, 0x42ba3a, 0, (uint16_t)index);
        } else {
            wr32(rec, 0x4d, 1);
        }
    }
    finish(&c, reject);
}

/* ---- 0x4eb184 -------------------------------------------------------------------------------------------------------------- */

/* The frame of the original, from the low addresses: this [ebp-0x84], the buffer [ebp-0x80, ebp-0x44), idx (word, ebp-0x44), j (word, ebp-0x40),
 * the string pointer (ebp-0x3c), the structure [ebp-0x38, ebp-4), the flag (dword, ebp-4), the saved ebp and the return address. idx, j and the pointer are read
 * only BEFORE the copy into the buffer and never after it, and the structure is dead after 0x4fb77a, so a copy into the buffer may run on over them up to the flag
 * (the only live local above the buffer): BUF_SZ is that distance, 0x7c bytes. The structure copy may run into the flag (4 bytes), which the original rewrites to 1
 * right after the field stores: LOCAL_SZ is 0x38. Anything longer would clobber the flag while it is live or the saved ebp / return address: rejected natively.
 * The guard of the translated text (`ja` at 0x4eb2f9 / 0x4eb4c4: length <= 0x3c) is the original's own and is kept. */
#define BUF_SZ 0x7c          /* what a copy into the buffer may take: its NUL included, 0x7b characters */
#define BUF_ALLOC (BUF_SZ + 4)   /* + the flag slot: the append after the flag test (the flag is dead then) may reach it */
#define TEXT_MAX 0x3c
#define LOCAL_SZ 0x38

/* strlen(s) + 1 when it is at most `limit`, else 0 (no NUL within `limit` bytes: the original's copy would not fit) */
static size_t fits(const uint8_t *s, size_t limit)
{
    size_t i;
    for (i = 0; i < limit; i++)
        if (s[i] == 0) return i + 1;
    return 0;
}

/* `repne scasb` + `rep movsd` + `rep movsb`: copies the string with its NUL into buf; 0 (nothing copied) when it does not fit */
static int copy_string(uint8_t *dst, size_t limit, const uint8_t *src)
{
    size_t n = fits(src, limit);
    if (n == 0) return 0;
    memcpy(dst, src, n);
    return 1;
}

/* 0x4eb184, thiscall, `ret 4`: n is [ebp+8] (a signed compare with 0), this = [ebp-0x84]. The original keeps idx (the word at ebp-0x44) uninitialised on
 * the arm that does not set it; it is not read there. */
void m4eb184_use_feedback(uint8_t *self, int32_t n, Fl26bWorld *world, const Fl18Host *host, int32_t *reject)
{
    uint8_t buf[BUF_ALLOC];
    uint8_t local[LOCAL_SZ];
    const uint8_t *rec_str;
    uint8_t *rec = NULL;
    uint32_t str;
    int32_t idx = 0;
    int flag = 0;
    int ok = 1;
    const uint8_t *table = world->records_583f1f + (ptrdiff_t)n * 0x6e;
    uint32_t rec_va = 0x583f5c + (uint32_t)n * 0x6e;
    memset(buf, 0, sizeof buf);
    memset(local, 0, sizeof local);
    if (reject != NULL) *reject = 0;
    if (n < 0) return;
    if (table[0] == 0) {
        int16_t j;
        for (j = 1; (int32_t)j <= 2; j++) {
            const uint8_t *row = self + (ptrdiff_t)n * 0x16d + 0x74e + (ptrdiff_t)j * 0x5d + 0x56;
            if (memcmp(row, world->bytes_55cba0, 9) == 0) break;
            if (row[0] == world->bytes_63aa00[0]) break;
        }
        idx = (int32_t)(int16_t)((int32_t)call0(host, 0x50cd50, 0) % (int32_t)j);
    }
    if (call1(host, 0x4f6334, 0x5cf1eb, 0x11) != 0) return;
    rec_str = table + 0x3d;
    if (table[0] != 0) {
        if (memcmp(rec_str, world->bytes_55cbac, 9) != 0) {
            call1(host, 0x4fb77a, 0x5c3a67, rec_va);
            flag = 1;
            str = 0;
            if (world->value_5bb202 != 0) str = call1(host, 0x423259, 0x619a6b, rec_va);
            if (str != 0) {
                const uint8_t *t = host->resolve(host->context, str);
                if (t == NULL) {
                    if (reject != NULL) *reject = FL26B_REJECT_UNRESOLVED;
                    return;
                }
                if (fits(t, TEXT_MAX + 1) != 0) ok = copy_string(buf, BUF_SZ, t);
                else ok = copy_string(buf, BUF_SZ, rec_str);
            } else {
                ok = copy_string(buf, BUF_SZ, rec_str);
            }
        }
    } else {
        rec = self + (ptrdiff_t)n * 0x16d + 0x74e + (ptrdiff_t)idx * 0x5d + 0x56;
        if (memcmp(rec, world->bytes_55cbb8, 9) != 0 && rec[0] != world->bytes_63aa04[0]) {
            if (!copy_string(local, LOCAL_SZ, rec)) ok = 0;
            wr16(local, 0x21, 0x11);
            wr16(local, 0x23, 1);
            wr16(local, 0x25, 1);
            wr16(local, 0x27, 1);
            wr32(local, 0x29, 1);
            wr16(local, 0x2d, 0x55);
            wr16(local, 0x2f, 0x55);
            if (!ok) {
                if (reject != NULL) *reject = FL26B_REJECT_OVERRUN;
                return;
            }
            call1(host, 0x4fb77a, 0x5c3a67, (uintptr_t)local);
            flag = 1;
            str = 0;
            if (world->value_5bb202 != 0) str = call1(host, 0x423259, 0x619a6b, (uintptr_t)rec);
            if (str != 0) {
                const uint8_t *t = host->resolve(host->context, str);
                if (t == NULL) {
                    if (reject != NULL) *reject = FL26B_REJECT_UNRESOLVED;
                    return;
                }
                if (fits(t, TEXT_MAX + 1) != 0) ok = copy_string(buf, BUF_SZ, t);
                else ok = copy_string(buf, BUF_SZ, rec + 0x21);
            } else {
                ok = copy_string(buf, BUF_SZ, rec + 0x21);
            }
        }
    }
    if (flag == 0) return;
    if (!ok) {
        if (reject != NULL) *reject = FL26B_REJECT_OVERRUN;
        return;
    }
    if (world->value_5bb202 != 0) {
        uintptr_t args[4];
        size_t len = fits(buf, BUF_SZ) - 1;      /* (the copy above left a NUL within BUF_SZ bytes: len <= 0x7b, so len + 4 <= BUF_ALLOC; the flag was tested before) */
        wr32(buf, (ptrdiff_t)len, world->value_55cbc4);
        args[0] = world->value_5d03b3;
        args[1] = (uintptr_t)buf;
        args[2] = 0xffffffffu;
        args[3] = 0;
        if (host->call != NULL) host->call(host->context, 0x448d11, 0x619a05, args, 4);
        wr32(self, 0x8256, 1);
        wr32(self, 0x8286, world->value_585d37 + (uint32_t)rds16(self, 0x69d));
    }
    call1(host, 0x4fb2e3, 0x5c3a67, 0x11);
}
