#include "original_methods_fl26c.h"

#include <string.h>

static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

static uint16_t rd16(const uint8_t *base, ptrdiff_t off)
{
    uint16_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

static void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
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

static uint32_t call4(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3)
{
    uintptr_t args[4];
    args[0] = a0;
    args[1] = a1;
    args[2] = a2;
    args[3] = a3;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 4) : 0;
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

static void s32(Ctx *c, uint32_t a, uint32_t off, uint32_t v)
{
    uint8_t *p = at(c, a + off);
    if (p != NULL) wr32(p, 0, v);
}

/* ---- 0x424346 -------------------------------------------------------------------------------------------------------------- */

/* A failed read returns 0 and sets c.bad. CHK() stops at once where the zero could start a host call, a store or a pointer dereference (after the node
 * fields, the mode of kind 9, the pointer chain of kind 0xb); where only a pure compare follows, the single CHK() before the result store is enough. */

/* the 0x424346 tables and globals (original addresses) */
#define TAB_583BD5 0x583bd5u    /* dwords, indexed by a (kind 1) */
#define TAB_585801 0x585801u    /* dwords, indexed by a (kind 2) */
#define TAB_581A71 0x581a71u    /* dwords, indexed by a (kind 3) */
#define TAB_587B2D 0x587b2du    /* signed words, indexed by the signed word [q] (kind 9) */
#define TAB_585D65 0x585d65u    /* records of stride 0x106: dword at +0, dword at +4 (kinds 0xd, 0xe, 0x16) */
#define REC_STRIDE 0x106

/* the record kinds 1, 5 and 6 of the table at 0x585d65 (kinds 0xd, 0xe, 0x16): the original reads the dword up to three times */
static int rec_live(Ctx *c, uint32_t rec)
{
    return g32(c, rec, 0) == 1 || g32(c, rec, 0) == 5 || g32(c, rec, 0) == 6;
}

/* the diagnostic path that the kind 9 mode and the kind 6 b share: 0x50ca3e(0x63888b, format, [0x5bb57b]); 0x52139c(0x63888b, 0, 0); 0x4c97b4 */
static void diagnostic(const Fl18Host *host, const Fl26cWorld *world, uint32_t format)
{
    call3(host, 0x50ca3e, 0, 0x63888b, format, world->value_5bb57b);
    call3(host, 0x52139c, 0, 0x63888b, 0, 0);
    call0(host, 0x4c97b4, 0x5cf659);
}

/* 0x424a02: the kinds without a case, and every kind above 0x16 (a negative kind too): 0x50ca3e(0x63888b, 0x544a80, kind); 0x42639d(this = 0x583979;
 * 0x544a88, 0x63888b); 0x4c97b4 */
static void kind_diagnostic(const Fl18Host *host, int32_t kind)
{
    call3(host, 0x50ca3e, 0, 0x63888b, 0x544a80, (uint32_t)kind);
    call2(host, 0x42639d, 0x583979, 0x544a88, 0x63888b);
    call0(host, 0x4c97b4, 0x5cf659);
}

/* 0x424346, thiscall, `ret 4`: node is the argument [ebp+8]; ecx (self) is kept in a local and read only by the kind 0xb. The locals of the original:
 * kind [ebp-0x14], a [ebp-8], b [ebp-0x20], [ebp-0x2c] (word [+0x16], never read again), q [ebp-0x1c], d [ebp-0x28], e [ebp-0x24], f [ebp-0x18]. */
void m424346_node_condition(uint8_t *self, uint32_t node, const Fl26cWorld *world, const Fl18Host *host, int32_t *reject)
{
    Ctx c = {host, 0};
    int32_t kind, a, b, d, e, f;
    uint32_t q;
    uint32_t flag;
    int res = -1;      /* 1 or 0: stored into [node + 4] after the switch; -1: this arm stores nothing there itself */

#define CHK()                      \
    do {                           \
        if (c.bad) goto done;      \
    } while (0)

    if (host == NULL || host->call == NULL || host->resolve == NULL) {      /* no host: every access and call would be wild */
        if (reject != NULL) *reject = FL26C_REJECT_UNRESOLVED;
        return;
    }
    kind = g16s(&c, node, 0x10);
    a = g16s(&c, node, 0x12);
    b = g16s(&c, node, 0x14);
    (void)g16s(&c, node, 0x16);
    q = node + 0x18;
    d = (int32_t)g32(&c, node, 0x20);
    e = (int32_t)g32(&c, node, 0x24);
    f = (int32_t)g32(&c, node, 0x28);
    CHK();

    if ((uint32_t)kind > 0x16u) {
        kind_diagnostic(host, kind);
        goto done;
    }
    switch (kind) {
    case 0:     /* 0x4249f6 */
        res = 1;
        break;
    case 1:     /* 0x4243b5 */
        if (b == 1) {
            uint32_t t = g32(&c, TAB_583BD5 + (uint32_t)a * 4u, 0);
            res = (t == 1 || (int32_t)world->word_583a29 == a) ? 1 : 0;
        } else if (b == 0) {        /* 0x4243d4 */
            uint32_t t = g32(&c, TAB_583BD5 + (uint32_t)a * 4u, 0);
            res = (t == 0 && (int32_t)world->word_583a29 != a) ? 1 : 0;
        } else {
            res = 0;
        }
        break;
    case 0xb: { /* 0x42440e */
        uint32_t obj, rr;
        obj = g32(&c, node, 0x48);
        rr = g32(&c, obj, 0x14);     /* (a failed read of obj returns 0 and leaves c.bad set: the CHK() below stops before any use of rr) */
        CHK();
        if (self == NULL) {
            c.bad = 1;
            goto done;
        }
        if (rd32(self, 0x614) != 0) {
            s32(&c, node, 4, 1);
            s32(&c, rr, 0x24, 0);
        } else if ((int32_t)world->word_583a29 == a) {
            s32(&c, node, 4, 1);
            s32(&c, rr, 0x24, node);
        } else {
            s32(&c, node, 4, 0);
            if (g32(&c, rr, 0x24) == node) s32(&c, rr, 0x24, 0);
        }
        break;
    }
    case 2:     /* 0x424481 */
        res = (int32_t)g32(&c, TAB_585801 + (uint32_t)a * 4u, 0) == b ? 1 : 0;
        break;
    case 0x11: { /* 0x4244ab */
        uint32_t r = call1(host, 0x4f6334, 0x5cf1eb, (uint32_t)a);
        if (b == 1 && r != 0) res = 1;
        else if (b == 0 && r == 0) res = 1;
        else res = 0;
        break;
    }
    case 3:     /* 0x4244ef */
        res = (int32_t)g32(&c, TAB_581A71 + (uint32_t)a * 4u, 0) == b ? 1 : 0;
        break;
    case 0xf:   /* 0x424519 */
        res = (int32_t)world->word_58c94f == b ? 1 : 0;
        break;
    case 0x10:  /* 0x424540 */
        if (b == 1 && world->value_5bb202 == 0) res = 1;
        else if (b == 2 && world->value_5bb202 != 0) res = 1;
        else res = 0;
        break;
    case 9: {   /* 0x424579 */
        int32_t mode = g16s(&c, q, 6);
        CHK();
        if (mode == 1 || mode == 2 || mode == 3) {
            int32_t t, w;
            if (mode == 3) {
                w = g16s(&c, q, 2);
                t = g16s(&c, TAB_587B2D + (uint32_t)g16s(&c, q, 0) * 2u, 0);
            } else {
                t = g16s(&c, TAB_587B2D + (uint32_t)g16s(&c, q, 0) * 2u, 0);
                w = g16s(&c, q, 2);
            }
            if (mode == 1) res = t < w ? 1 : 0;
            else if (mode == 2) res = t > w ? 1 : 0;
            else res = w == t ? 1 : 0;
        } else {
            diagnostic(host, world, 0x5449a8);
        }
        break;
    }
    case 0xc:   /* 0x424666 */
        res = a == (int32_t)world->word_5bb20a ? 1 : 0;
        break;
    case 4:     /* 0x42468d */
        res = world->value_585d37 >= d ? 1 : 0;
        break;
    case 0xd: { /* 0x4246b2 */
        uint32_t rec = TAB_585D65 + (uint32_t)(a * REC_STRIDE);
        if (rec_live(&c, rec) && (int32_t)g32(&c, rec, 4) <= d) res = 1;
        else res = 0;
        break;
    }
    case 0xe: { /* 0x424717 */
        uint32_t rec = TAB_585D65 + (uint32_t)(a * REC_STRIDE);
        if (rec_live(&c, rec) && (int32_t)g32(&c, rec, 4) > d) res = 1;
        else res = 0;
        break;
    }
    case 0x16: { /* 0x42477c */
        uint32_t rec = TAB_585D65 + (uint32_t)(a * REC_STRIDE);
        res = rec_live(&c, rec) ? 1 : 0;
        break;
    }
    case 5:     /* 0x4247cd */
        res = world->value_585d41 >= d ? 1 : 0;
        break;
    case 6:     /* 0x4247f3 */
        if ((uint32_t)b > 3u) {
            diagnostic(host, world, 0x5449e8);
        } else if (b == 0) {
            res = world->value_585d4b >= d ? 1 : 0;
        } else if (b == 1) {
            res = world->value_585d4b <= d ? 1 : 0;
        } else if (b == 2) {
            res = world->value_585d4b == d ? 1 : 0;
        } else if (e <= f) {       /* 0x42487c */
            res = (world->value_585d4b >= e && world->value_585d4b <= f) ? 1 : 0;
        } else {
            int32_t limit = 0x59f;
            if (world->value_585d4b >= e && world->value_585d4b <= limit) res = 1;
            else if (world->value_585d4b >= 0 && world->value_585d4b <= f) res = 1;
            else res = 0;
        }
        break;
    case 0x14:  /* 0x424930 */
        flag = g32(&c, node, 0x2c);       /* (a failed read leaves c.bad set: the preflight CHK() below stops before the draw) */
        if (flag == 0) {
            int32_t r;
            uint32_t drawn;
            /* native rejection preflight: the three stores of this arm ([node + 4], [node + 0x30], [node + 0x2c]) must resolve before any host call is made
             * (the original would fault at the store after the calls) */
            (void)at(&c, node + 4);
            (void)at(&c, node + 0x30);
            CHK();
            r = (int32_t)call0(host, 0x50cd50, 0);
            s32(&c, node, 0x30, (uint32_t)(r % 100));
            if ((int16_t)world->word_63a4cd != 0 && (b < 1 || b > 100)) {
                call4(host, 0x50ca3e, 0, 0x63888b, 0x544a34, world->value_5bb57b, (uint32_t)b);
                call3(host, 0x52139c, 0, 0x63888b, 0, 0);
                call1(host, 0x44a2b7, 0, 0x63888b);
                call0(host, 0x4c97b4, 0x5cf659);
            }
            drawn = g32(&c, node, 0x30);      /* (resolved by the preflight and the store above) */
            s32(&c, node, 4, (int32_t)drawn < b ? 1u : 0u);
            s32(&c, node, 0x2c, 1);
        }
        break;
    case 0x15:  /* 0x4249d5 */
        res = world->value_5c3a47 != 0 ? 1 : 0;
        break;
    default:    /* 0x424a02: the kinds 7, 8, 0xa, 0x12 and 0x13 (the jump table points them at the same code) */
        kind_diagnostic(host, kind);
        break;
    }
    CHK();
    if (res >= 0) s32(&c, node, 4, (uint32_t)res);
done:
    if (reject != NULL) *reject = c.bad ? FL26C_REJECT_UNRESOLVED : 0;
#undef CHK
}
