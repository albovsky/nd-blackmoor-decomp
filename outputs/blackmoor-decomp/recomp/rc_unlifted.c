/* Hand ports of the GAME.EXE bodies the lifter refused: CRT helpers with jump tables, a `std`, or an SEH frame the per-function lifter does
 * not model. Each has the signature of a lifted function and is registered at the original address; it reads its arguments from the guest
 * stack at r->esp + 4, leaves the result in eax, and returns with r->esp past its own `ret` (cdecl: the return address only). The Python
 * spike ran these on the Unicorn emulator; the behaviour here is the C library routine they are, checked against the original code. */
#include <string.h>
#include "rc.h"

#define ARG(i) rc_u32(r->esp + 4u + 4u * (uint32_t)(i))

/* 0x50db50 _strrchr(const char *s, int c): the last occurrence of the low byte of c in s, the terminator included, or NULL */
static void port_strrchr(Fl41Regs *r, const Fl41Host *h)
{
    (void)h;
    uint32_t s = ARG(0), found = 0;
    uint8_t c = (uint8_t)ARG(1);
    for (uint32_t p = s;; p++) {
        uint8_t b = (uint8_t)rc_rd(p, 1);
        if (b == c) found = p;
        if (!b) break;
    }
    r->eax = found;
    r->ecx = 0;
    r->esp += 4u;
}

/* 0x5130f0 strcmp(const char *a, const char *b): the sign of the first differing byte (unsigned), as -1, 0 or 1 */
static void port_strcmp(Fl41Regs *r, const Fl41Host *h)
{
    (void)h;
    uint32_t a = ARG(0), b = ARG(1);
    int32_t out = 0;
    for (;; a++, b++) {
        uint32_t x = rc_rd(a, 1), y = rc_rd(b, 1);
        if (x != y) { out = x < y ? -1 : 1; break; }
        if (!x) break;
    }
    r->eax = (uint32_t)out;
    r->ecx = 0;
    r->esp += 4u;
}

/* 0x50fa90 memmove(void *dst, const void *src, size_t n): the CRT's overlap-safe copy; returns dst */
static void port_memmove(Fl41Regs *r, const Fl41Host *h)
{
    (void)h;
    uint32_t dst = ARG(0), src = ARG(1), n = ARG(2);
    void *d = rc_ptr(dst, n), *s = rc_ptr(src, n);
    if (n && d && s) {
        memmove(d, s, n);
    } else if (n) {
        if (dst <= src || dst >= src + n) for (uint32_t i = 0; i < n; i++) rc_wr(dst + i, 1, rc_rd(src + i, 1));
        else for (uint32_t i = n; i-- > 0;) rc_wr(dst + i, 1, rc_rd(src + i, 1));
    }
    r->eax = dst;
    r->ecx = 0;
    r->esp += 4u;
}

/* The two C-runtime locale wrappers pick the wide or the ANSI form of the Win32 call once and cache the choice (0x63caa0 and 0x63cc54:
 * 0 undecided, 1 wide, 2 ANSI). The host answers LCMapStringW with 0, so the ANSI form is what these ports serve; the wide form
 * (converted through MultiByteToWideChar) of __crtGetStringTypeA is kept because the host does answer GetStringTypeW. */
#define IMP_LCMAPSTRINGW 0x52a170u
#define IMP_LCMAPSTRINGA 0x52a16cu
#define IMP_GETSTRINGTYPEW 0x52a1b0u
#define IMP_GETSTRINGTYPEA 0x52a1acu
#define IMP_MULTIBYTETOWIDECHAR 0x52a1f0u
#define F_USE_LCMAP 0x63caa0u
#define F_USE_STRTYPE 0x63cc54u
#define STR_ONE_W 0x5304f4u          /* the one-character probe strings in .rdata */
#define STR_ONE_A 0x5304f0u

/* 0x5129a0 __crtLCMapStringA(LCID, DWORD flags, LPCSTR src, int cchSrc, LPSTR dst, int cchDst, int code_page, BOOL bError) */
static void port_crt_lcmapstring(Fl41Regs *r, const Fl41Host *h)
{
    (void)h;
    uint32_t result = 0;
    uint32_t fuse = rc_u32(F_USE_LCMAP);
    if (!fuse) {
        uint32_t probe_w[6] = {0, 0x100, STR_ONE_W, 1, 0, 0}, probe_a[6] = {0, 0x100, STR_ONE_A, 1, 0, 0};
        if (rc_call_from(r, IMP_LCMAPSTRINGW, 6, probe_w)) fuse = 1;
        else if (rc_call_from(r, IMP_LCMAPSTRINGA, 6, probe_a)) fuse = 2;
        else goto done;
        rc_w32(F_USE_LCMAP, fuse);
    }
    int32_t cch = (int32_t)ARG(3);
    if (cch > 0) {                                    /* strncnt: the length up to the first NUL, at most cch */
        int32_t n = 0;
        while (n < cch && rc_rd(ARG(2) + (uint32_t)n, 1)) n++;
        cch = n;
    }
    if (fuse == 2) {
        uint32_t args[6] = {ARG(0), ARG(1), ARG(2), (uint32_t)cch, ARG(4), ARG(5)};
        result = rc_call_from(r, IMP_LCMAPSTRINGA, 6, args);
    } else {
        rc_abort("__crtLCMapStringA: the wide form is not supported (LCMapStringW answers 0)");
    }
done:
    r->eax = result;
    r->ecx = 0;
    r->esp += 4u;
}

/* 0x515e1e __crtGetStringTypeA(DWORD infoType, LPCSTR src, int cchSrc, LPWORD charType, int code_page, LCID lcid, BOOL bError) */
static void port_crt_getstringtype(Fl41Regs *r, const Fl41Host *h)
{
    (void)h;
    uint32_t result = 0;
    uint32_t fuse = rc_u32(F_USE_STRTYPE);
    uint32_t dummy = rc_heap_get(8, 1);
    if (!fuse) {
        uint32_t probe_w[4] = {1, STR_ONE_W, 1, dummy}, probe_a[5] = {0, 1, STR_ONE_A, 1, dummy};
        if (rc_call_from(r, IMP_GETSTRINGTYPEW, 4, probe_w)) fuse = 1;
        else if (rc_call_from(r, IMP_GETSTRINGTYPEA, 5, probe_a)) fuse = 2;
        else goto done;
        rc_w32(F_USE_STRTYPE, fuse);
    }
    if (fuse == 2) {
        uint32_t lcid = ARG(5) ? ARG(5) : rc_u32(0x63cb1cu);
        uint32_t args[5] = {lcid, ARG(0), ARG(1), ARG(2), ARG(3)};
        result = rc_call_from(r, IMP_GETSTRINGTYPEA, 5, args);
    } else if (fuse == 1) {
        uint32_t cp = ARG(4) ? ARG(4) : rc_u32(0x63cb2cu);
        uint32_t size_args[6] = {cp, ARG(6) ? 9u : 1u, ARG(1), ARG(2), 0, 0};
        uint32_t n = rc_call_from(r, IMP_MULTIBYTETOWIDECHAR, 6, size_args);
        if (!n) goto done;
        uint32_t buf = rc_heap_get(n * 2u + 4u, 1);
        uint32_t conv_args[6] = {cp, 1, ARG(1), ARG(2), buf, n};
        uint32_t got = rc_call_from(r, IMP_MULTIBYTETOWIDECHAR, 6, conv_args);
        if (got) {
            uint32_t args[4] = {ARG(0), buf, got, ARG(3)};
            result = rc_call_from(r, IMP_GETSTRINGTYPEW, 4, args);
        }
        rc_heap_put(buf);
    }
done:
    rc_heap_put(dummy);
    r->eax = result;
    r->ecx = 0;
    r->esp += 4u;
}

static void put(uint32_t va, void (*fn)(Fl41Regs *, const Fl41Host *))
{
    if (!rc_has(va)) rc_register(va, fn);
}

void rc_unlifted_register(void)
{
    put(0x50db50u, port_strrchr);
    put(0x5130f0u, port_strcmp);
    put(0x50fa90u, port_memmove);
    put(0x5129a0u, port_crt_lcmapstring);
    put(0x515e1eu, port_crt_getstringtype);
}
