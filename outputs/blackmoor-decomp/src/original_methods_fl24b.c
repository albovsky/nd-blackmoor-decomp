#include "original_methods_fl24b.h"

#include <string.h>

#if defined(__GNUC__) || defined(__clang__)
#define FL24B_UNUSED __attribute__((unused))
#else
#define FL24B_UNUSED
#endif

FL24B_UNUSED static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL24B_UNUSED static void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
{
    memcpy(base + off, &v, sizeof v);
}

FL24B_UNUSED static uint16_t rd16(const uint8_t *base, ptrdiff_t off)
{
    uint16_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL24B_UNUSED static void wr16(uint8_t *base, ptrdiff_t off, uint16_t v)
{
    memcpy(base + off, &v, sizeof v);
}

/* a signed word, sign-extended (movsx) */
FL24B_UNUSED static int32_t rds16(const uint8_t *base, ptrdiff_t off)
{
    return (int16_t)rd16(base, off);
}

FL24B_UNUSED static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, NULL, 0) : 0;
}

FL24B_UNUSED static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    uintptr_t args[1];
    args[0] = a0;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 1) : 0;
}

FL24B_UNUSED static uint32_t call2(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1)
{
    uintptr_t args[2];
    args[0] = a0;
    args[1] = a1;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 2) : 0;
}

FL24B_UNUSED static uint32_t call3(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2)
{
    uintptr_t args[3];
    args[0] = a0;
    args[1] = a1;
    args[2] = a2;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 3) : 0;
}

/* the object of an original address (an address that a record keeps), as host memory */
FL24B_UNUSED static const uint8_t *object_at(const Fl18Host *host, uint32_t address)
{
    return host->resolve(host->context, address);
}

/* repe cmpsb with ecx = 9: 1 when the nine bytes at a and b are equal */
FL24B_UNUSED static int nine_bytes_equal(const uint8_t *a, const uint8_t *b)
{
    int k;
    for (k = 0; k < 9; k++)
        if (a[k] != b[k]) return 0;
    return 1;
}

/* `movsx ecx, word [self + idx]; imul ecx, ecx, 0x8d`: the byte offset of the record n in the table at 0x5bb5e5 */
FL24B_UNUSED static ptrdiff_t rec_offset(const uint8_t *self, ptrdiff_t idx_off)
{
    return (ptrdiff_t)(rds16(self, idx_off) * 0x8d);
}

/* `cmp dword [n * 0x8d + 0x5bb632], 1` */
FL24B_UNUSED static int record_state_is_1(const Fl24bWorld *world, const uint8_t *self, ptrdiff_t idx_off)
{
    return rd32(world->records_5bb5e5, rec_offset(self, idx_off) + 0x4d) == 1;
}

/* `mov dword [n * 0x8d + 0x5bb632], 2` (the index word is read again, as the original does) */
FL24B_UNUSED static void set_record_state_2(const Fl24bWorld *world, const uint8_t *self, ptrdiff_t idx_off)
{
    wr32(world->records_5bb5e5, rec_offset(self, idx_off) + 0x4d, 2);
}

/* `mov eax, [n * 0x8d + 0x5bb5e5]`: the original address of the object of record n */
FL24B_UNUSED static uint32_t record_object_address(const Fl24bWorld *world, const uint8_t *self, ptrdiff_t idx_off)
{
    return rd32(world->records_5bb5e5, rec_offset(self, idx_off));
}

/* ---- 0x4dad60 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4dad60, thiscall, plain `ret`, eax = this on return. Clears the dwords [+0xc], [+0x10], [+0], [+4], [+8] and the bytes 0x58321d and
 * 0x58321e, calls the import in slot 0x52a498 (stdcall, one argument 0x17) and stores its result at [+0x14]; a non-zero result gives
 * [+0x20] = 2, [+0x24] = 1, zero gives [+0x20] = 1, [+0x24] = 2; then clears [+0x18] and [+0x1c]. The result is re-read from the object
 * as the original does. */
void m4dad60_init_swap_buttons(uint8_t *self, Fl24bWorld *world, const Fl18Host *host)
{
    uint32_t r;
    wr32(self, 0xc, 0);
    wr32(self, 0x10, 0);
    wr32(self, 0, 0);
    wr32(self, 4, 0);
    wr32(self, 8, 0);
    world->value_58321d = 0;
    world->value_58321e = 0;
    r = call1(host, 0x52a498, 0, 0x17);
    wr32(self, 0x14, r);
    if (rd32(self, 0x14) != 0) {
        wr32(self, 0x20, 2);
        wr32(self, 0x24, 1);
    } else {
        wr32(self, 0x20, 1);
        wr32(self, 0x24, 2);
    }
    wr32(self, 0x18, 0);
    wr32(self, 0x1c, 0);
}

/* FL24B-END */
