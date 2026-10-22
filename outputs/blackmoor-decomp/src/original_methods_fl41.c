/* FL-41: GAME.EXE functions at or above 0x480000, translated instruction by instruction by scripts/lift_fl41.py (see original_methods_fl41.h for the model).
 * GENERATED: regenerate with scripts/fl41_generate.py; do not edit by hand. Each symbol `m<va>_lifted` is the original function at <va>; the comment above
 * it gives the address and the size. These are machine translations: they carry no names and no restructuring of the original. */
#include "original_methods_fl41.h"

/* GAME.EXE 0x490d50 (1146 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m490d50_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x490d50: push ebp */
    ebp = esp;  /* 0x490d51: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0x30u, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x490d53: sub esp, 0x30 */
    WR32((uint32_t)(ebp + 0xffffffd0u), ecx);  /* 0x490d56: mov dword ptr [ebp - 0x30], ecx */
    ecx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x490d59: mov ecx, dword ptr [ebp - 0x30] */
    esp -= 4u; WR32(esp, 0x490d61u); FL41_CALL(0x491422u); esp += 4u;  /* 0x490d5c: call 0x491422 */
    WR32((uint32_t)(ebp + 0xfffffff8u), 0x0u);  /* 0x490d61: mov dword ptr [ebp - 8], 0 */
    goto L_490d73;  /* 0x490d68: jmp 0x490d73 */
L_490d6a:
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x490d6a: mov eax, dword ptr [ebp - 8] */
    { uint32_t a_ = eax, b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x490d6d: add eax, 1 */
    WR32((uint32_t)(ebp + 0xfffffff8u), eax);  /* 0x490d70: mov dword ptr [ebp - 8], eax */
L_490d73:
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xfffffff8u)), b_ = 0x55u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x490d73: cmp dword ptr [ebp - 8], 0x55 */
    if ((sf == of)) goto L_490da3;  /* 0x490d77: jge 0x490da3 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x490d79: mov ecx, dword ptr [ebp - 8] */
    edx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x490d7c: mov edx, dword ptr [ebp - 0x30] */
    { uint32_t a_ = RD32((uint32_t)(edx + ecx * 4u + 0x20e5u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x490d7f: cmp dword ptr [edx + ecx*4 + 0x20e5], 0 */
    if (zf) goto L_490da1;  /* 0x490d87: je 0x490da1 */
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x490d89: mov eax, dword ptr [ebp - 8] */
    ecx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x490d8c: mov ecx, dword ptr [ebp - 0x30] */
    edx = (uint32_t)(ecx + eax * 4u + 0x20e5u);  /* 0x490d8f: lea edx, [ecx + eax*4 + 0x20e5] */
    esp -= 4u; WR32(esp, edx);  /* 0x490d96: push edx */
    ecx = 0x5cf659u;  /* 0x490d97: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x490da1u); FL41_CALL(0x4c2dfbu); esp += 4u; esp += 4u;  /* 0x490d9c: call 0x4c2dfb */
L_490da1:
    goto L_490d6a;  /* 0x490da1: jmp 0x490d6a */
L_490da3:
    WR32((uint32_t)(ebp + 0xfffffff8u), 0x0u);  /* 0x490da3: mov dword ptr [ebp - 8], 0 */
    goto L_490db5;  /* 0x490daa: jmp 0x490db5 */
L_490dac:
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x490dac: mov eax, dword ptr [ebp - 8] */
    { uint32_t a_ = eax, b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x490daf: add eax, 1 */
    WR32((uint32_t)(ebp + 0xfffffff8u), eax);  /* 0x490db2: mov dword ptr [ebp - 8], eax */
L_490db5:
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xfffffff8u)), b_ = 0x28u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x490db5: cmp dword ptr [ebp - 8], 0x28 */
    if ((sf == of)) goto L_490de5;  /* 0x490db9: jge 0x490de5 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x490dbb: mov ecx, dword ptr [ebp - 8] */
    edx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x490dbe: mov edx, dword ptr [ebp - 0x30] */
    { uint32_t a_ = RD32((uint32_t)(edx + ecx * 4u + 0x2239u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x490dc1: cmp dword ptr [edx + ecx*4 + 0x2239], 0 */
    if (zf) goto L_490de3;  /* 0x490dc9: je 0x490de3 */
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x490dcb: mov eax, dword ptr [ebp - 8] */
    ecx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x490dce: mov ecx, dword ptr [ebp - 0x30] */
    edx = (uint32_t)(ecx + eax * 4u + 0x2239u);  /* 0x490dd1: lea edx, [ecx + eax*4 + 0x2239] */
    esp -= 4u; WR32(esp, edx);  /* 0x490dd8: push edx */
    ecx = 0x5cf659u;  /* 0x490dd9: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x490de3u); FL41_CALL(0x4c2dfbu); esp += 4u; esp += 4u;  /* 0x490dde: call 0x4c2dfb */
L_490de3:
    goto L_490dac;  /* 0x490de3: jmp 0x490dac */
L_490de5:
    WR32((uint32_t)(ebp + 0xfffffff8u), 0x0u);  /* 0x490de5: mov dword ptr [ebp - 8], 0 */
    goto L_490df7;  /* 0x490dec: jmp 0x490df7 */
L_490dee:
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x490dee: mov eax, dword ptr [ebp - 8] */
    { uint32_t a_ = eax, b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x490df1: add eax, 1 */
    WR32((uint32_t)(ebp + 0xfffffff8u), eax);  /* 0x490df4: mov dword ptr [ebp - 8], eax */
L_490df7:
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xfffffff8u)), b_ = 0x55u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x490df7: cmp dword ptr [ebp - 8], 0x55 */
    if ((sf == of)) goto L_490e27;  /* 0x490dfb: jge 0x490e27 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x490dfd: mov ecx, dword ptr [ebp - 8] */
    edx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x490e00: mov edx, dword ptr [ebp - 0x30] */
    { uint32_t a_ = RD32((uint32_t)(edx + ecx * 4u + 0x22d9u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x490e03: cmp dword ptr [edx + ecx*4 + 0x22d9], 0 */
    if (zf) goto L_490e25;  /* 0x490e0b: je 0x490e25 */
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x490e0d: mov eax, dword ptr [ebp - 8] */
    ecx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x490e10: mov ecx, dword ptr [ebp - 0x30] */
    edx = (uint32_t)(ecx + eax * 4u + 0x22d9u);  /* 0x490e13: lea edx, [ecx + eax*4 + 0x22d9] */
    esp -= 4u; WR32(esp, edx);  /* 0x490e1a: push edx */
    ecx = 0x5cf659u;  /* 0x490e1b: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x490e25u); FL41_CALL(0x4c2dfbu); esp += 4u; esp += 4u;  /* 0x490e20: call 0x4c2dfb */
L_490e25:
    goto L_490dee;  /* 0x490e25: jmp 0x490dee */
L_490e27:
    WR32((uint32_t)(ebp + 0xfffffff8u), 0x0u);  /* 0x490e27: mov dword ptr [ebp - 8], 0 */
    goto L_490e39;  /* 0x490e2e: jmp 0x490e39 */
L_490e30:
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x490e30: mov eax, dword ptr [ebp - 8] */
    { uint32_t a_ = eax, b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x490e33: add eax, 1 */
    WR32((uint32_t)(ebp + 0xfffffff8u), eax);  /* 0x490e36: mov dword ptr [ebp - 8], eax */
L_490e39:
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xfffffff8u)), b_ = 0x19u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x490e39: cmp dword ptr [ebp - 8], 0x19 */
    if ((sf == of)) goto L_490e69;  /* 0x490e3d: jge 0x490e69 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x490e3f: mov ecx, dword ptr [ebp - 8] */
    edx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x490e42: mov edx, dword ptr [ebp - 0x30] */
    { uint32_t a_ = RD32((uint32_t)(edx + ecx * 4u + 0x242du)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x490e45: cmp dword ptr [edx + ecx*4 + 0x242d], 0 */
    if (zf) goto L_490e67;  /* 0x490e4d: je 0x490e67 */
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x490e4f: mov eax, dword ptr [ebp - 8] */
    ecx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x490e52: mov ecx, dword ptr [ebp - 0x30] */
    edx = (uint32_t)(ecx + eax * 4u + 0x242du);  /* 0x490e55: lea edx, [ecx + eax*4 + 0x242d] */
    esp -= 4u; WR32(esp, edx);  /* 0x490e5c: push edx */
    ecx = 0x5cf659u;  /* 0x490e5d: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x490e67u); FL41_CALL(0x4c2dfbu); esp += 4u; esp += 4u;  /* 0x490e62: call 0x4c2dfb */
L_490e67:
    goto L_490e30;  /* 0x490e67: jmp 0x490e30 */
L_490e69:
    WR32((uint32_t)(ebp + 0xfffffff8u), 0x1u);  /* 0x490e69: mov dword ptr [ebp - 8], 1 */
    goto L_490e7b;  /* 0x490e70: jmp 0x490e7b */
L_490e72:
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x490e72: mov eax, dword ptr [ebp - 8] */
    { uint32_t a_ = eax, b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x490e75: add eax, 1 */
    WR32((uint32_t)(ebp + 0xfffffff8u), eax);  /* 0x490e78: mov dword ptr [ebp - 8], eax */
L_490e7b:
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xfffffff8u)), b_ = 0x8u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x490e7b: cmp dword ptr [ebp - 8], 8 */
    if ((sf == of)) goto L_49106d;  /* 0x490e7f: jge 0x49106d */
    WR32((uint32_t)(ebp + 0xfffffffcu), 0x0u);  /* 0x490e85: mov dword ptr [ebp - 4], 0 */
    goto L_490e97;  /* 0x490e8c: jmp 0x490e97 */
L_490e8e:
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x490e8e: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x490e91: add ecx, 1 */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x490e94: mov dword ptr [ebp - 4], ecx */
L_490e97:
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xfffffffcu)), b_ = 0x55u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x490e97: cmp dword ptr [ebp - 4], 0x55 */
    if ((sf == of)) goto L_490f00;  /* 0x490e9b: jge 0x490f00 */
    edx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x490e9d: mov edx, dword ptr [ebp - 8] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x154u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x490ea0: imul edx, edx, 0x154 */
    eax = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x490ea6: mov eax, dword ptr [ebp - 0x30] */
    ecx = (uint32_t)(eax + edx + 0x2491u);  /* 0x490ea9: lea ecx, [eax + edx + 0x2491] */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x490eb0: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(ecx + edx * 4u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x490eb3: cmp dword ptr [ecx + edx*4], 0 */
    if (zf) goto L_490efe;  /* 0x490eb7: je 0x490efe */
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x490eb9: mov eax, dword ptr [ebp - 8] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x154u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x490ebc: imul eax, eax, 0x154 */
    ecx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x490ec2: mov ecx, dword ptr [ebp - 0x30] */
    edx = (uint32_t)(ecx + eax + 0x2491u);  /* 0x490ec5: lea edx, [ecx + eax + 0x2491] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x490ecc: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(edx + eax * 4u));  /* 0x490ecf: mov ecx, dword ptr [edx + eax*4] */
    WR32((uint32_t)(ebp + 0xfffffff4u), ecx);  /* 0x490ed2: mov dword ptr [ebp - 0xc], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x490ed5: mov edx, dword ptr [ebp - 0xc] */
    esp -= 4u; WR32(esp, edx);  /* 0x490ed8: push edx */
    esp -= 4u; WR32(esp, 0x490edeu); FL41_CALL(0x51dc6cu); esp += 4u;  /* 0x490ed9: call 0x51dc6c */
    { uint32_t a_ = esp, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x490ede: add esp, 4 */
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x490ee1: mov eax, dword ptr [ebp - 8] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x154u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x490ee4: imul eax, eax, 0x154 */
    ecx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x490eea: mov ecx, dword ptr [ebp - 0x30] */
    edx = (uint32_t)(ecx + eax + 0x2491u);  /* 0x490eed: lea edx, [ecx + eax + 0x2491] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x490ef4: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + eax * 4u), 0x0u);  /* 0x490ef7: mov dword ptr [edx + eax*4], 0 */
L_490efe:
    goto L_490e8e;  /* 0x490efe: jmp 0x490e8e */
L_490f00:
    WR32((uint32_t)(ebp + 0xfffffffcu), 0x0u);  /* 0x490f00: mov dword ptr [ebp - 4], 0 */
    goto L_490f12;  /* 0x490f07: jmp 0x490f12 */
L_490f09:
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x490f09: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x490f0c: add ecx, 1 */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x490f0f: mov dword ptr [ebp - 4], ecx */
L_490f12:
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xfffffffcu)), b_ = 0x28u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x490f12: cmp dword ptr [ebp - 4], 0x28 */
    if ((sf == of)) goto L_490f7b;  /* 0x490f16: jge 0x490f7b */
    edx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x490f18: mov edx, dword ptr [ebp - 8] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0xa0u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x490f1b: imul edx, edx, 0xa0 */
    eax = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x490f21: mov eax, dword ptr [ebp - 0x30] */
    ecx = (uint32_t)(eax + edx + 0x2f31u);  /* 0x490f24: lea ecx, [eax + edx + 0x2f31] */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x490f2b: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(ecx + edx * 4u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x490f2e: cmp dword ptr [ecx + edx*4], 0 */
    if (zf) goto L_490f79;  /* 0x490f32: je 0x490f79 */
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x490f34: mov eax, dword ptr [ebp - 8] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0xa0u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x490f37: imul eax, eax, 0xa0 */
    ecx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x490f3d: mov ecx, dword ptr [ebp - 0x30] */
    edx = (uint32_t)(ecx + eax + 0x2f31u);  /* 0x490f40: lea edx, [ecx + eax + 0x2f31] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x490f47: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(edx + eax * 4u));  /* 0x490f4a: mov ecx, dword ptr [edx + eax*4] */
    WR32((uint32_t)(ebp + 0xfffffff0u), ecx);  /* 0x490f4d: mov dword ptr [ebp - 0x10], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x490f50: mov edx, dword ptr [ebp - 0x10] */
    esp -= 4u; WR32(esp, edx);  /* 0x490f53: push edx */
    esp -= 4u; WR32(esp, 0x490f59u); FL41_CALL(0x51dc6cu); esp += 4u;  /* 0x490f54: call 0x51dc6c */
    { uint32_t a_ = esp, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x490f59: add esp, 4 */
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x490f5c: mov eax, dword ptr [ebp - 8] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0xa0u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x490f5f: imul eax, eax, 0xa0 */
    ecx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x490f65: mov ecx, dword ptr [ebp - 0x30] */
    edx = (uint32_t)(ecx + eax + 0x2f31u);  /* 0x490f68: lea edx, [ecx + eax + 0x2f31] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x490f6f: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + eax * 4u), 0x0u);  /* 0x490f72: mov dword ptr [edx + eax*4], 0 */
L_490f79:
    goto L_490f09;  /* 0x490f79: jmp 0x490f09 */
L_490f7b:
    WR32((uint32_t)(ebp + 0xfffffffcu), 0x0u);  /* 0x490f7b: mov dword ptr [ebp - 4], 0 */
    goto L_490f8d;  /* 0x490f82: jmp 0x490f8d */
L_490f84:
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x490f84: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x490f87: add ecx, 1 */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x490f8a: mov dword ptr [ebp - 4], ecx */
L_490f8d:
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xfffffffcu)), b_ = 0x55u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x490f8d: cmp dword ptr [ebp - 4], 0x55 */
    if ((sf == of)) goto L_490ff6;  /* 0x490f91: jge 0x490ff6 */
    edx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x490f93: mov edx, dword ptr [ebp - 8] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x154u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x490f96: imul edx, edx, 0x154 */
    eax = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x490f9c: mov eax, dword ptr [ebp - 0x30] */
    ecx = (uint32_t)(eax + edx + 0x3431u);  /* 0x490f9f: lea ecx, [eax + edx + 0x3431] */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x490fa6: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(ecx + edx * 4u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x490fa9: cmp dword ptr [ecx + edx*4], 0 */
    if (zf) goto L_490ff4;  /* 0x490fad: je 0x490ff4 */
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x490faf: mov eax, dword ptr [ebp - 8] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x154u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x490fb2: imul eax, eax, 0x154 */
    ecx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x490fb8: mov ecx, dword ptr [ebp - 0x30] */
    edx = (uint32_t)(ecx + eax + 0x3431u);  /* 0x490fbb: lea edx, [ecx + eax + 0x3431] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x490fc2: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(edx + eax * 4u));  /* 0x490fc5: mov ecx, dword ptr [edx + eax*4] */
    WR32((uint32_t)(ebp + 0xffffffecu), ecx);  /* 0x490fc8: mov dword ptr [ebp - 0x14], ecx */
    edx = RD32((uint32_t)(ebp + 0xffffffecu));  /* 0x490fcb: mov edx, dword ptr [ebp - 0x14] */
    esp -= 4u; WR32(esp, edx);  /* 0x490fce: push edx */
    esp -= 4u; WR32(esp, 0x490fd4u); FL41_CALL(0x51dc6cu); esp += 4u;  /* 0x490fcf: call 0x51dc6c */
    { uint32_t a_ = esp, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x490fd4: add esp, 4 */
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x490fd7: mov eax, dword ptr [ebp - 8] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x154u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x490fda: imul eax, eax, 0x154 */
    ecx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x490fe0: mov ecx, dword ptr [ebp - 0x30] */
    edx = (uint32_t)(ecx + eax + 0x3431u);  /* 0x490fe3: lea edx, [ecx + eax + 0x3431] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x490fea: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + eax * 4u), 0x0u);  /* 0x490fed: mov dword ptr [edx + eax*4], 0 */
L_490ff4:
    goto L_490f84;  /* 0x490ff4: jmp 0x490f84 */
L_490ff6:
    WR32((uint32_t)(ebp + 0xfffffffcu), 0x0u);  /* 0x490ff6: mov dword ptr [ebp - 4], 0 */
    goto L_491008;  /* 0x490ffd: jmp 0x491008 */
L_490fff:
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x490fff: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x491002: add ecx, 1 */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x491005: mov dword ptr [ebp - 4], ecx */
L_491008:
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xfffffffcu)), b_ = 0x19u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x491008: cmp dword ptr [ebp - 4], 0x19 */
    if ((sf == of)) goto L_491068;  /* 0x49100c: jge 0x491068 */
    edx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x49100e: mov edx, dword ptr [ebp - 8] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x64u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x491011: imul edx, edx, 0x64 */
    eax = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x491014: mov eax, dword ptr [ebp - 0x30] */
    ecx = (uint32_t)(eax + edx + 0x3ed1u);  /* 0x491017: lea ecx, [eax + edx + 0x3ed1] */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x49101e: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(ecx + edx * 4u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x491021: cmp dword ptr [ecx + edx*4], 0 */
    if (zf) goto L_491066;  /* 0x491025: je 0x491066 */
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x491027: mov eax, dword ptr [ebp - 8] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x64u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x49102a: imul eax, eax, 0x64 */
    ecx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x49102d: mov ecx, dword ptr [ebp - 0x30] */
    edx = (uint32_t)(ecx + eax + 0x3ed1u);  /* 0x491030: lea edx, [ecx + eax + 0x3ed1] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x491037: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(edx + eax * 4u));  /* 0x49103a: mov ecx, dword ptr [edx + eax*4] */
    WR32((uint32_t)(ebp + 0xffffffe8u), ecx);  /* 0x49103d: mov dword ptr [ebp - 0x18], ecx */
    edx = RD32((uint32_t)(ebp + 0xffffffe8u));  /* 0x491040: mov edx, dword ptr [ebp - 0x18] */
    esp -= 4u; WR32(esp, edx);  /* 0x491043: push edx */
    esp -= 4u; WR32(esp, 0x491049u); FL41_CALL(0x51dc6cu); esp += 4u;  /* 0x491044: call 0x51dc6c */
    { uint32_t a_ = esp, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x491049: add esp, 4 */
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x49104c: mov eax, dword ptr [ebp - 8] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x64u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x49104f: imul eax, eax, 0x64 */
    ecx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x491052: mov ecx, dword ptr [ebp - 0x30] */
    edx = (uint32_t)(ecx + eax + 0x3ed1u);  /* 0x491055: lea edx, [ecx + eax + 0x3ed1] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x49105c: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + eax * 4u), 0x0u);  /* 0x49105f: mov dword ptr [edx + eax*4], 0 */
L_491066:
    goto L_490fff;  /* 0x491066: jmp 0x490fff */
L_491068:
    goto L_490e72;  /* 0x491068: jmp 0x490e72 */
L_49106d:
    ecx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x49106d: mov ecx, dword ptr [ebp - 0x30] */
    { uint32_t a_ = RD32((uint32_t)(ecx + 0x2035u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x491070: cmp dword ptr [ecx + 0x2035], 0 */
    if (zf) goto L_49108d;  /* 0x491077: je 0x49108d */
    edx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x491079: mov edx, dword ptr [ebp - 0x30] */
    { uint32_t a_ = edx, b_ = 0x2035u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x49107c: add edx, 0x2035 */
    esp -= 4u; WR32(esp, edx);  /* 0x491082: push edx */
    ecx = 0x5cf659u;  /* 0x491083: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x49108du); FL41_CALL(0x4c2dfbu); esp += 4u; esp += 4u;  /* 0x491088: call 0x4c2dfb */
L_49108d:
    eax = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x49108d: mov eax, dword ptr [ebp - 0x30] */
    { uint32_t a_ = RD32((uint32_t)(eax + 0x2039u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x491090: cmp dword ptr [eax + 0x2039], 0 */
    if (zf) goto L_4910ad;  /* 0x491097: je 0x4910ad */
    ecx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x491099: mov ecx, dword ptr [ebp - 0x30] */
    { uint32_t a_ = ecx, b_ = 0x2039u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x49109c: add ecx, 0x2039 */
    esp -= 4u; WR32(esp, ecx);  /* 0x4910a2: push ecx */
    ecx = 0x5cf659u;  /* 0x4910a3: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4910adu); FL41_CALL(0x4c2dfbu); esp += 4u; esp += 4u;  /* 0x4910a8: call 0x4c2dfb */
L_4910ad:
    edx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x4910ad: mov edx, dword ptr [ebp - 0x30] */
    { uint32_t a_ = RD32((uint32_t)(edx + 0x50f3u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4910b0: cmp dword ptr [edx + 0x50f3], 0 */
    if (zf) goto L_4910de;  /* 0x4910b7: je 0x4910de */
    eax = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x4910b9: mov eax, dword ptr [ebp - 0x30] */
    ecx = RD32((uint32_t)(eax + 0x50f3u));  /* 0x4910bc: mov ecx, dword ptr [eax + 0x50f3] */
    WR32((uint32_t)(ebp + 0xffffffe4u), ecx);  /* 0x4910c2: mov dword ptr [ebp - 0x1c], ecx */
    edx = RD32((uint32_t)(ebp + 0xffffffe4u));  /* 0x4910c5: mov edx, dword ptr [ebp - 0x1c] */
    esp -= 4u; WR32(esp, edx);  /* 0x4910c8: push edx */
    esp -= 4u; WR32(esp, 0x4910ceu); FL41_CALL(0x51dc6cu); esp += 4u;  /* 0x4910c9: call 0x51dc6c */
    { uint32_t a_ = esp, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4910ce: add esp, 4 */
    eax = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x4910d1: mov eax, dword ptr [ebp - 0x30] */
    WR32((uint32_t)(eax + 0x50f3u), 0x0u);  /* 0x4910d4: mov dword ptr [eax + 0x50f3], 0 */
L_4910de:
    ecx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x4910de: mov ecx, dword ptr [ebp - 0x30] */
    { uint32_t a_ = RD32((uint32_t)(ecx + 0x20b5u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4910e1: cmp dword ptr [ecx + 0x20b5], 0 */
    if (zf) goto L_49110f;  /* 0x4910e8: je 0x49110f */
    edx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x4910ea: mov edx, dword ptr [ebp - 0x30] */
    eax = RD32((uint32_t)(edx + 0x20b5u));  /* 0x4910ed: mov eax, dword ptr [edx + 0x20b5] */
    WR32((uint32_t)(ebp + 0xffffffe0u), eax);  /* 0x4910f3: mov dword ptr [ebp - 0x20], eax */
    ecx = RD32((uint32_t)(ebp + 0xffffffe0u));  /* 0x4910f6: mov ecx, dword ptr [ebp - 0x20] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4910f9: push ecx */
    esp -= 4u; WR32(esp, 0x4910ffu); FL41_CALL(0x51dc6cu); esp += 4u;  /* 0x4910fa: call 0x51dc6c */
    { uint32_t a_ = esp, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4910ff: add esp, 4 */
    edx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x491102: mov edx, dword ptr [ebp - 0x30] */
    WR32((uint32_t)(edx + 0x20b5u), 0x0u);  /* 0x491105: mov dword ptr [edx + 0x20b5], 0 */
L_49110f:
    eax = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x49110f: mov eax, dword ptr [ebp - 0x30] */
    { uint32_t a_ = RD32((uint32_t)(eax + 0x200fu)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x491112: cmp dword ptr [eax + 0x200f], 0 */
    if (zf) goto L_491140;  /* 0x491119: je 0x491140 */
    ecx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x49111b: mov ecx, dword ptr [ebp - 0x30] */
    edx = RD32((uint32_t)(ecx + 0x200fu));  /* 0x49111e: mov edx, dword ptr [ecx + 0x200f] */
    WR32((uint32_t)(ebp + 0xffffffdcu), edx);  /* 0x491124: mov dword ptr [ebp - 0x24], edx */
    eax = RD32((uint32_t)(ebp + 0xffffffdcu));  /* 0x491127: mov eax, dword ptr [ebp - 0x24] */
    esp -= 4u; WR32(esp, eax);  /* 0x49112a: push eax */
    esp -= 4u; WR32(esp, 0x491130u); FL41_CALL(0x51dc6cu); esp += 4u;  /* 0x49112b: call 0x51dc6c */
    { uint32_t a_ = esp, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x491130: add esp, 4 */
    ecx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x491133: mov ecx, dword ptr [ebp - 0x30] */
    WR32((uint32_t)(ecx + 0x200fu), 0x0u);  /* 0x491136: mov dword ptr [ecx + 0x200f], 0 */
L_491140:
    edx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x491140: mov edx, dword ptr [ebp - 0x30] */
    { uint32_t a_ = RD32((uint32_t)(edx + 0x2013u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x491143: cmp dword ptr [edx + 0x2013], 0 */
    if (zf) goto L_491171;  /* 0x49114a: je 0x491171 */
    eax = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x49114c: mov eax, dword ptr [ebp - 0x30] */
    ecx = RD32((uint32_t)(eax + 0x2013u));  /* 0x49114f: mov ecx, dword ptr [eax + 0x2013] */
    WR32((uint32_t)(ebp + 0xffffffd8u), ecx);  /* 0x491155: mov dword ptr [ebp - 0x28], ecx */
    edx = RD32((uint32_t)(ebp + 0xffffffd8u));  /* 0x491158: mov edx, dword ptr [ebp - 0x28] */
    esp -= 4u; WR32(esp, edx);  /* 0x49115b: push edx */
    esp -= 4u; WR32(esp, 0x491161u); FL41_CALL(0x51dc6cu); esp += 4u;  /* 0x49115c: call 0x51dc6c */
    { uint32_t a_ = esp, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x491161: add esp, 4 */
    eax = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x491164: mov eax, dword ptr [ebp - 0x30] */
    WR32((uint32_t)(eax + 0x2013u), 0x0u);  /* 0x491167: mov dword ptr [eax + 0x2013], 0 */
L_491171:
    ecx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x491171: mov ecx, dword ptr [ebp - 0x30] */
    { uint32_t a_ = RD32((uint32_t)(ecx + 0x2017u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x491174: cmp dword ptr [ecx + 0x2017], 0 */
    if (zf) goto L_4911a2;  /* 0x49117b: je 0x4911a2 */
    edx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x49117d: mov edx, dword ptr [ebp - 0x30] */
    eax = RD32((uint32_t)(edx + 0x2017u));  /* 0x491180: mov eax, dword ptr [edx + 0x2017] */
    WR32((uint32_t)(ebp + 0xffffffd4u), eax);  /* 0x491186: mov dword ptr [ebp - 0x2c], eax */
    ecx = RD32((uint32_t)(ebp + 0xffffffd4u));  /* 0x491189: mov ecx, dword ptr [ebp - 0x2c] */
    esp -= 4u; WR32(esp, ecx);  /* 0x49118c: push ecx */
    esp -= 4u; WR32(esp, 0x491192u); FL41_CALL(0x51dc6cu); esp += 4u;  /* 0x49118d: call 0x51dc6c */
    { uint32_t a_ = esp, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x491192: add esp, 4 */
    edx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x491195: mov edx, dword ptr [ebp - 0x30] */
    WR32((uint32_t)(edx + 0x2017u), 0x0u);  /* 0x491198: mov dword ptr [edx + 0x2017], 0 */
L_4911a2:
    eax = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x4911a2: mov eax, dword ptr [ebp - 0x30] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(eax + 0x1cu)))) & 0xffffffffu;  /* 0x4911a5: movsx ecx, word ptr [eax + 0x1c] */
    { uint32_t a_ = ecx, b_ = 0xffffffffu, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4911a9: cmp ecx, -1 */
    if (zf) goto L_4911be;  /* 0x4911ac: je 0x4911be */
    edx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x4911ae: mov edx, dword ptr [ebp - 0x30] */
    eax = (eax & 0xffff0000u) | ((RD16((uint32_t)(edx + 0x1cu))) & 0xffffu);  /* 0x4911b1: mov ax, word ptr [edx + 0x1c] */
    esp -= 4u; WR32(esp, eax);  /* 0x4911b5: push eax */
    esp -= 4u; WR32(esp, 0x4911bbu); FL41_CALL(0x4d3992u); esp += 4u;  /* 0x4911b6: call 0x4d3992 */
    { uint32_t a_ = esp, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4911bb: add esp, 4 */
L_4911be:
    ecx = RD32((uint32_t)(ebp + 0xffffffd0u));  /* 0x4911be: mov ecx, dword ptr [ebp - 0x30] */
    esp -= 4u; WR32(esp, 0x4911c6u); FL41_CALL(0x490598u); esp += 4u;  /* 0x4911c1: call 0x490598 */
    esp = ebp;  /* 0x4911c6: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4911c8: pop ebp */
    esp += 4u; goto done;  /* 0x4911c9: ret  */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x494ccc (136 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m494ccc_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x494ccc: push ebp */
    ebp = esp;  /* 0x494ccd: mov ebp, esp */
    esp -= 4u; WR32(esp, ecx);  /* 0x494ccf: push ecx */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x494cd0: mov dword ptr [ebp - 4], ecx */
    ecx = 0x5830a6u;  /* 0x494cd3: mov ecx, 0x5830a6 */
    esp -= 4u; WR32(esp, 0x494cddu); FL41_CALL(0x4dadffu); esp += 4u;  /* 0x494cd8: call 0x4dadff */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x494cdd: mov ecx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, 0x494ce5u); FL41_CALL(0x494d54u); esp += 4u;  /* 0x494ce0: call 0x494d54 */
    esp -= 4u; WR32(esp, 0x54f800u);  /* 0x494ce5: push 0x54f800 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x494cea: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = eax, b_ = 0x1f83u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x494ced: add eax, 0x1f83 */
    esp -= 4u; WR32(esp, eax);  /* 0x494cf2: push eax */
    esp -= 4u; WR32(esp, 0x583186u);  /* 0x494cf3: push 0x583186 */
    ecx = RD32((uint32_t)(0x5cf665u));  /* 0x494cf8: mov ecx, dword ptr [0x5cf665] */
    esp -= 4u; WR32(esp, ecx);  /* 0x494cfe: push ecx */
    ecx = 0x5cf659u;  /* 0x494cff: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x494d09u); FL41_CALL(0x4c3efbu); esp += 16u; esp += 4u;  /* 0x494d04: call 0x4c3efb */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x494d09: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x494d0c: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0x1fa7u));  /* 0x494d0f: mov ecx, dword ptr [eax + 0x1fa7] */
    WR32((uint32_t)(edx + 0x1f7fu), ecx);  /* 0x494d15: mov dword ptr [edx + 0x1f7f], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x494d1b: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x494d1e: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0x1f93u));  /* 0x494d21: mov ecx, dword ptr [eax + 0x1f93] */
    WR32((uint32_t)(edx + 0x1fffu), ecx);  /* 0x494d27: mov dword ptr [edx + 0x1fff], ecx */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x494d2d: mov ecx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, 0x494d35u); FL41_CALL(0x496410u); esp += 4u;  /* 0x494d30: call 0x496410 */
    esp -= 4u; WR32(esp, 0x54f82cu);  /* 0x494d35: push 0x54f82c */
    esp -= 4u; WR32(esp, 0x583186u);  /* 0x494d3a: push 0x583186 */
    edx = RD32((uint32_t)(0x5cf665u));  /* 0x494d3f: mov edx, dword ptr [0x5cf665] */
    esp -= 4u; WR32(esp, edx);  /* 0x494d45: push edx */
    ecx = 0x5cf659u;  /* 0x494d46: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x494d50u); FL41_CALL(0x4c4202u); esp += 12u; esp += 4u;  /* 0x494d4b: call 0x4c4202 */
    esp = ebp;  /* 0x494d50: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x494d52: pop ebp */
    esp += 4u; goto done;  /* 0x494d53: ret  */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x49d039 (389 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m49d039_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x49d039: push ebp */
    ebp = esp;  /* 0x49d03a: mov ebp, esp */
    esp -= 4u; WR32(esp, ecx);  /* 0x49d03c: push ecx */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x49d03d: mov dword ptr [ebp - 4], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x49d040: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(0x6329c9u));  /* 0x49d043: mov ecx, dword ptr [0x6329c9] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(RD32((uint32_t)(eax + 0x1cu))); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x49d049: imul ecx, dword ptr [eax + 0x1c] */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x49d04d: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + 0xe38u));  /* 0x49d050: mov eax, dword ptr [edx + 0xe38] */
    ecx = (uint32_t)(eax + ecx * 4u);  /* 0x49d056: lea ecx, [eax + ecx*4] */
    edx = RD32((uint32_t)(0x6329cdu));  /* 0x49d059: mov edx, dword ptr [0x6329cd] */
    { uint32_t a_ = RD32((uint32_t)(ecx + edx * 4u + 0x4u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x49d05f: cmp dword ptr [ecx + edx*4 + 4], 0 */
    if (!zf) goto L_49d09b;  /* 0x49d064: jne 0x49d09b */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x49d066: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(0x6329c9u));  /* 0x49d069: mov ecx, dword ptr [0x6329c9] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(RD32((uint32_t)(eax + 0x1cu))); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x49d06f: imul ecx, dword ptr [eax + 0x1c] */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x49d073: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + 0xe38u));  /* 0x49d076: mov eax, dword ptr [edx + 0xe38] */
    ecx = (uint32_t)(eax + ecx * 4u);  /* 0x49d07c: lea ecx, [eax + ecx*4] */
    edx = RD32((uint32_t)(0x6329cdu));  /* 0x49d07f: mov edx, dword ptr [0x6329cd] */
    { uint32_t a_ = RD32((uint32_t)(ecx + edx * 4u + 0x8u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x49d085: cmp dword ptr [ecx + edx*4 + 8], 0 */
    if (!zf) goto L_49d09b;  /* 0x49d08a: jne 0x49d09b */
    eax = RD32((uint32_t)(0x6329a9u));  /* 0x49d08c: mov eax, dword ptr [0x6329a9] */
    WR32((uint32_t)(0x6329d1u), eax);  /* 0x49d091: mov dword ptr [0x6329d1], eax */
    goto L_49d1ba;  /* 0x49d096: jmp 0x49d1ba */
L_49d09b:
    ecx = RD32((uint32_t)(0x6329c9u));  /* 0x49d09b: mov ecx, dword ptr [0x6329c9] */
    { uint32_t a_ = ecx, b_ = 0x1u, r_; FL41_SUB(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x49d0a1: sub ecx, 1 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x49d0a4: mov edx, dword ptr [ebp - 4] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(RD32((uint32_t)(edx + 0x1cu))); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x49d0a7: imul ecx, dword ptr [edx + 0x1c] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x49d0ab: mov eax, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(eax + 0xe38u));  /* 0x49d0ae: mov edx, dword ptr [eax + 0xe38] */
    eax = (uint32_t)(edx + ecx * 4u);  /* 0x49d0b4: lea eax, [edx + ecx*4] */
    ecx = RD32((uint32_t)(0x6329cdu));  /* 0x49d0b7: mov ecx, dword ptr [0x6329cd] */
    { uint32_t a_ = RD32((uint32_t)(eax + ecx * 4u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x49d0bd: cmp dword ptr [eax + ecx*4], 0 */
    if (!zf) goto L_49d0fa;  /* 0x49d0c1: jne 0x49d0fa */
    edx = RD32((uint32_t)(0x6329c9u));  /* 0x49d0c3: mov edx, dword ptr [0x6329c9] */
    { uint32_t a_ = edx, b_ = 0x2u, r_; FL41_SUB(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x49d0c9: sub edx, 2 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x49d0cc: mov eax, dword ptr [ebp - 4] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(RD32((uint32_t)(eax + 0x1cu))); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x49d0cf: imul edx, dword ptr [eax + 0x1c] */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x49d0d3: mov ecx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(ecx + 0xe38u));  /* 0x49d0d6: mov eax, dword ptr [ecx + 0xe38] */
    ecx = (uint32_t)(eax + edx * 4u);  /* 0x49d0dc: lea ecx, [eax + edx*4] */
    edx = RD32((uint32_t)(0x6329cdu));  /* 0x49d0df: mov edx, dword ptr [0x6329cd] */
    { uint32_t a_ = RD32((uint32_t)(ecx + edx * 4u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x49d0e5: cmp dword ptr [ecx + edx*4], 0 */
    if (!zf) goto L_49d0fa;  /* 0x49d0e9: jne 0x49d0fa */
    eax = RD32((uint32_t)(0x6329b1u));  /* 0x49d0eb: mov eax, dword ptr [0x6329b1] */
    WR32((uint32_t)(0x6329d1u), eax);  /* 0x49d0f0: mov dword ptr [0x6329d1], eax */
    goto L_49d1ba;  /* 0x49d0f5: jmp 0x49d1ba */
L_49d0fa:
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x49d0fa: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(0x6329c9u));  /* 0x49d0fd: mov edx, dword ptr [0x6329c9] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(RD32((uint32_t)(ecx + 0x1cu))); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x49d103: imul edx, dword ptr [ecx + 0x1c] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x49d107: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0xe38u));  /* 0x49d10a: mov ecx, dword ptr [eax + 0xe38] */
    edx = (uint32_t)(ecx + edx * 4u);  /* 0x49d110: lea edx, [ecx + edx*4] */
    eax = RD32((uint32_t)(0x6329cdu));  /* 0x49d113: mov eax, dword ptr [0x6329cd] */
    { uint32_t a_ = RD32((uint32_t)(edx + eax * 4u + 0xfffffffcu)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x49d118: cmp dword ptr [edx + eax*4 - 4], 0 */
    if (!zf) goto L_49d152;  /* 0x49d11d: jne 0x49d152 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x49d11f: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(0x6329c9u));  /* 0x49d122: mov edx, dword ptr [0x6329c9] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(RD32((uint32_t)(ecx + 0x1cu))); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x49d128: imul edx, dword ptr [ecx + 0x1c] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x49d12c: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0xe38u));  /* 0x49d12f: mov ecx, dword ptr [eax + 0xe38] */
    edx = (uint32_t)(ecx + edx * 4u);  /* 0x49d135: lea edx, [ecx + edx*4] */
    eax = RD32((uint32_t)(0x6329cdu));  /* 0x49d138: mov eax, dword ptr [0x6329cd] */
    { uint32_t a_ = RD32((uint32_t)(edx + eax * 4u + 0xfffffff8u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x49d13d: cmp dword ptr [edx + eax*4 - 8], 0 */
    if (!zf) goto L_49d152;  /* 0x49d142: jne 0x49d152 */
    ecx = RD32((uint32_t)(0x6329b9u));  /* 0x49d144: mov ecx, dword ptr [0x6329b9] */
    WR32((uint32_t)(0x6329d1u), ecx);  /* 0x49d14a: mov dword ptr [0x6329d1], ecx */
    goto L_49d1ba;  /* 0x49d150: jmp 0x49d1ba */
L_49d152:
    edx = RD32((uint32_t)(0x6329c9u));  /* 0x49d152: mov edx, dword ptr [0x6329c9] */
    { uint32_t a_ = edx, b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x49d158: add edx, 1 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x49d15b: mov eax, dword ptr [ebp - 4] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(RD32((uint32_t)(eax + 0x1cu))); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x49d15e: imul edx, dword ptr [eax + 0x1c] */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x49d162: mov ecx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(ecx + 0xe38u));  /* 0x49d165: mov eax, dword ptr [ecx + 0xe38] */
    ecx = (uint32_t)(eax + edx * 4u);  /* 0x49d16b: lea ecx, [eax + edx*4] */
    edx = RD32((uint32_t)(0x6329cdu));  /* 0x49d16e: mov edx, dword ptr [0x6329cd] */
    { uint32_t a_ = RD32((uint32_t)(ecx + edx * 4u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x49d174: cmp dword ptr [ecx + edx*4], 0 */
    if (!zf) goto L_49d1ae;  /* 0x49d178: jne 0x49d1ae */
    eax = RD32((uint32_t)(0x6329c9u));  /* 0x49d17a: mov eax, dword ptr [0x6329c9] */
    { uint32_t a_ = eax, b_ = 0x2u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x49d17f: add eax, 2 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x49d182: mov ecx, dword ptr [ebp - 4] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(RD32((uint32_t)(ecx + 0x1cu))); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x49d185: imul eax, dword ptr [ecx + 0x1c] */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x49d189: mov edx, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(edx + 0xe38u));  /* 0x49d18c: mov ecx, dword ptr [edx + 0xe38] */
    edx = (uint32_t)(ecx + eax * 4u);  /* 0x49d192: lea edx, [ecx + eax*4] */
    eax = RD32((uint32_t)(0x6329cdu));  /* 0x49d195: mov eax, dword ptr [0x6329cd] */
    { uint32_t a_ = RD32((uint32_t)(edx + eax * 4u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x49d19a: cmp dword ptr [edx + eax*4], 0 */
    if (!zf) goto L_49d1ae;  /* 0x49d19e: jne 0x49d1ae */
    ecx = RD32((uint32_t)(0x6329bdu));  /* 0x49d1a0: mov ecx, dword ptr [0x6329bd] */
    WR32((uint32_t)(0x6329d1u), ecx);  /* 0x49d1a6: mov dword ptr [0x6329d1], ecx */
    goto L_49d1ba;  /* 0x49d1ac: jmp 0x49d1ba */
L_49d1ae:
    edx = RD32((uint32_t)(0x6329adu));  /* 0x49d1ae: mov edx, dword ptr [0x6329ad] */
    WR32((uint32_t)(0x6329d1u), edx);  /* 0x49d1b4: mov dword ptr [0x6329d1], edx */
L_49d1ba:
    esp = ebp;  /* 0x49d1ba: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x49d1bc: pop ebp */
    esp += 4u; goto done;  /* 0x49d1bd: ret  */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4a1d3a (220 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4a1d3a_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4a1d3a: push ebp */
    ebp = esp;  /* 0x4a1d3b: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0x10u, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4a1d3d: sub esp, 0x10 */
    esp -= 4u; WR32(esp, esi);  /* 0x4a1d40: push esi */
    esp -= 4u; WR32(esp, edi);  /* 0x4a1d41: push edi */
    WR32((uint32_t)(ebp + 0xfffffff0u), ecx);  /* 0x4a1d42: mov dword ptr [ebp - 0x10], ecx */
    eax = RD32((uint32_t)(ebp + 0xcu));  /* 0x4a1d45: mov eax, dword ptr [ebp + 0xc] */
    ecx = RD32((uint32_t)(eax));  /* 0x4a1d48: mov ecx, dword ptr [eax] */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4a1d4a: mov dword ptr [ebp - 4], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4a1d4d: mov edx, dword ptr [ebp - 4] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x151u)))) & 0xffffffffu;  /* 0x4a1d50: movsx eax, word ptr [edx + 0x151] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x1e5u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4a1d57: imul eax, eax, 0x1e5 */
    { uint32_t a_ = eax, b_ = 0x153u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4a1d5d: add eax, 0x153 */
    WR32((uint32_t)(ebp + 0xfffffff8u), eax);  /* 0x4a1d62: mov dword ptr [ebp - 8], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4a1d65: mov ecx, dword ptr [ebp - 8] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4a1d68: push ecx */
    esp -= 4u; WR32(esp, 0x4a1d6eu); FL41_CALL(0x51dc43u); esp += 4u;  /* 0x4a1d69: call 0x51dc43 */
    { uint32_t a_ = esp, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4a1d6e: add esp, 4 */
    WR32((uint32_t)(ebp + 0xfffffff4u), eax);  /* 0x4a1d71: mov dword ptr [ebp - 0xc], eax */
    edx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4a1d74: mov edx, dword ptr [ebp + 8] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a1d77: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(edx), eax);  /* 0x4a1d7a: mov dword ptr [edx], eax */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xfffffff4u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4a1d7c: cmp dword ptr [ebp - 0xc], 0 */
    if (!zf) goto L_4a1dc1;  /* 0x4a1d80: jne 0x4a1dc1 */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x5c39e3u)))) & 0xffffffffu;  /* 0x4a1d82: movsx ecx, word ptr [0x5c39e3] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4a1d89: push ecx */
    edx = RD32((uint32_t)(0x5bb57bu));  /* 0x4a1d8a: mov edx, dword ptr [0x5bb57b] */
    esp -= 4u; WR32(esp, edx);  /* 0x4a1d90: push edx */
    esp -= 4u; WR32(esp, 0x5502dcu);  /* 0x4a1d91: push 0x5502dc */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x4a1d96: push 0x63888b */
    esp -= 4u; WR32(esp, 0x4a1da0u); FL41_CALL(0x50ca3eu); esp += 4u;  /* 0x4a1d9b: call 0x50ca3e */
    { uint32_t a_ = esp, b_ = 0x10u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4a1da0: add esp, 0x10 */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x4a1da3: push 0x63888b */
    esp -= 4u; WR32(esp, 0x550308u);  /* 0x4a1da8: push 0x550308 */
    ecx = 0x583979u;  /* 0x4a1dad: mov ecx, 0x583979 */
    esp -= 4u; WR32(esp, 0x4a1db7u); FL41_CALL(0x42639du); esp += 8u; esp += 4u;  /* 0x4a1db2: call 0x42639d */
    ecx = 0x5cf659u;  /* 0x4a1db7: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4a1dc1u); FL41_CALL(0x4c97b4u); esp += 4u;  /* 0x4a1dbc: call 0x4c97b4 */
L_4a1dc1:
    ecx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4a1dc1: mov ecx, dword ptr [ebp - 8] */
    eax = RD32((uint32_t)(ebp + 0xcu));  /* 0x4a1dc4: mov eax, dword ptr [ebp + 0xc] */
    esi = RD32((uint32_t)(eax));  /* 0x4a1dc7: mov esi, dword ptr [eax] */
    edx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4a1dc9: mov edx, dword ptr [ebp + 8] */
    edi = RD32((uint32_t)(edx));  /* 0x4a1dcc: mov edi, dword ptr [edx] */
    eax = ecx;  /* 0x4a1dce: mov eax, ecx */
    { uint32_t a_ = ecx, n_ = 0x2u, r_; if (n_ != 0u) { FL41_SHR(r_, a_, n_, 32); ecx = r_; } }  /* 0x4a1dd0: shr ecx, 2 */
    /* 0x4a1dd3: rep movsd dword ptr es:[edi], dword ptr [esi] */
    while (ecx != 0u) {
    WR32(edi, RD32(esi));
    esi += 4u; edi += 4u;
    ecx -= 1u;
    }
    ecx = eax;  /* 0x4a1dd5: mov ecx, eax */
    { uint32_t a_ = ecx, b_ = 0x3u, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); ecx = r_; }  /* 0x4a1dd7: and ecx, 3 */
    /* 0x4a1dda: rep movsb byte ptr es:[edi], byte ptr [esi] */
    while (ecx != 0u) {
    WR8(edi, RD8(esi));
    esi += 1u; edi += 1u;
    ecx -= 1u;
    }
    ecx = RD32((uint32_t)(ebp + 0x10u));  /* 0x4a1ddc: mov ecx, dword ptr [ebp + 0x10] */
    edx = RD32((uint32_t)(ecx));  /* 0x4a1ddf: mov edx, dword ptr [ecx] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(ebp + 0xfffffff8u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a1de1: add edx, dword ptr [ebp - 8] */
    eax = RD32((uint32_t)(ebp + 0x10u));  /* 0x4a1de4: mov eax, dword ptr [ebp + 0x10] */
    WR32((uint32_t)(eax), edx);  /* 0x4a1de7: mov dword ptr [eax], edx */
    ecx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4a1de9: mov ecx, dword ptr [ebp + 0xc] */
    edx = RD32((uint32_t)(ecx));  /* 0x4a1dec: mov edx, dword ptr [ecx] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(ebp + 0xfffffff8u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a1dee: add edx, dword ptr [ebp - 8] */
    eax = RD32((uint32_t)(ebp + 0xcu));  /* 0x4a1df1: mov eax, dword ptr [ebp + 0xc] */
    WR32((uint32_t)(eax), edx);  /* 0x4a1df4: mov dword ptr [eax], edx */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x63a4cdu)))) & 0xffffffffu;  /* 0x4a1df6: movsx ecx, word ptr [0x63a4cd] */
    { uint32_t a_ = ecx, b_ = ecx, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4a1dfd: test ecx, ecx */
    if (zf) goto L_4a1e0e;  /* 0x4a1dff: je 0x4a1e0e */
    esp -= 4u; WR32(esp, 0x550324u);  /* 0x4a1e01: push 0x550324 */
    esp -= 4u; WR32(esp, 0x4a1e0bu); FL41_CALL(0x44a2b7u); esp += 4u;  /* 0x4a1e06: call 0x44a2b7 */
    { uint32_t a_ = esp, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4a1e0b: add esp, 4 */
L_4a1e0e:
    edi = RD32(esp); esp += 4u;  /* 0x4a1e0e: pop edi */
    esi = RD32(esp); esp += 4u;  /* 0x4a1e0f: pop esi */
    esp = ebp;  /* 0x4a1e10: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4a1e12: pop ebp */
    esp += 16u; goto done;  /* 0x4a1e13: ret 0xc */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4a35d7 (144 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4a35d7_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4a35d7: push ebp */
    ebp = esp;  /* 0x4a35d8: mov ebp, esp */
    esp -= 4u; WR32(esp, 0x5504b0u);  /* 0x4a35da: push 0x5504b0 */
    esp -= 4u; WR32(esp, 0x61d305u);  /* 0x4a35df: push 0x61d305 */
    eax = RD32((uint32_t)(0x61d2fdu));  /* 0x4a35e4: mov eax, dword ptr [0x61d2fd] */
    { uint32_t a_ = eax, b_ = 0x6u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4a35e9: add eax, 6 */
    esp -= 4u; WR32(esp, eax);  /* 0x4a35ec: push eax */
    ecx = RD32((uint32_t)(0x5cf665u));  /* 0x4a35ed: mov ecx, dword ptr [0x5cf665] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4a35f3: push ecx */
    edx = RD32((uint32_t)(0x5d15e3u));  /* 0x4a35f4: mov edx, dword ptr [0x5d15e3] */
    esp -= 4u; WR32(esp, edx);  /* 0x4a35fa: push edx */
    ecx = 0x5cf659u;  /* 0x4a35fb: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4a3605u); FL41_CALL(0x4c5377u); esp += 20u; esp += 4u;  /* 0x4a3600: call 0x4c5377 */
    esp -= 4u; WR32(esp, 0x0u);  /* 0x4a3605: push 0 */
    eax = RD32((uint32_t)(0x5cf665u));  /* 0x4a3607: mov eax, dword ptr [0x5cf665] */
    esp -= 4u; WR32(esp, eax);  /* 0x4a360c: push eax */
    ecx = RD32((uint32_t)(0x61d2fdu));  /* 0x4a360d: mov ecx, dword ptr [0x61d2fd] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx)))) & 0xffffffffu;  /* 0x4a3613: movsx edx, word ptr [ecx] */
    eax = RD32((uint32_t)(edx * 4u + 0x5d032fu));  /* 0x4a3616: mov eax, dword ptr [edx*4 + 0x5d032f] */
    esp -= 4u; WR32(esp, eax);  /* 0x4a361d: push eax */
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(0x61d311u))) & 0xffffu);  /* 0x4a361e: mov cx, word ptr [0x61d311] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4a3625: push ecx */
    edx = (edx & 0xffff0000u) | ((RD16((uint32_t)(0x61d305u))) & 0xffffu);  /* 0x4a3626: mov dx, word ptr [0x61d305] */
    esp -= 4u; WR32(esp, edx);  /* 0x4a362d: push edx */
    eax = RD32((uint32_t)(0x61d2fdu));  /* 0x4a362e: mov eax, dword ptr [0x61d2fd] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(eax)))) & 0xffffffffu;  /* 0x4a3633: movsx ecx, word ptr [eax] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x1d0u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4a3636: imul ecx, ecx, 0x1d0 */
    { uint32_t a_ = ecx, b_ = 0x5adb3au, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4a363c: add ecx, 0x5adb3a */
    esp -= 4u; WR32(esp, ecx);  /* 0x4a3642: push ecx */
    edx = RD32((uint32_t)(0x61d2fdu));  /* 0x4a3643: mov edx, dword ptr [0x61d2fd] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx)))) & 0xffffffffu;  /* 0x4a3649: movsx eax, word ptr [edx] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0x7f3u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4a364c: imul eax, eax, 0x7f3 */
    { uint32_t a_ = eax, b_ = 0x5a4c24u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4a3652: add eax, 0x5a4c24 */
    esp -= 4u; WR32(esp, eax);  /* 0x4a3657: push eax */
    esp -= 4u; WR32(esp, 0x61d315u);  /* 0x4a3658: push 0x61d315 */
    esp -= 4u; WR32(esp, 0x4a3662u); FL41_CALL(0x4d2c20u); esp += 4u;  /* 0x4a365d: call 0x4d2c20 */
    { uint32_t a_ = esp, b_ = 0x20u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4a3662: add esp, 0x20 */
    ebp = RD32(esp); esp += 4u;  /* 0x4a3665: pop ebp */
    esp += 4u; goto done;  /* 0x4a3666: ret  */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4ab85a (63 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4ab85a_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4ab85a: push ebp */
    ebp = esp;  /* 0x4ab85b: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0xcu, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4ab85d: sub esp, 0xc */
    WR32((uint32_t)(ebp + 0xfffffff4u), ecx);  /* 0x4ab860: mov dword ptr [ebp - 0xc], ecx */
    WR16((uint32_t)(ebp + 0xfffffff8u), 0x0u);  /* 0x4ab863: mov word ptr [ebp - 8], 0 */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4ab869: mov eax, dword ptr [ebp - 0xc] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(eax + 0x1eu)))) & 0xffffffffu;  /* 0x4ab86c: movsx ecx, word ptr [eax + 0x1e] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4ab870: imul ecx, ecx, 0x8d */
    edx = RD32((uint32_t)(ecx + 0x5bb5e5u));  /* 0x4ab876: mov edx, dword ptr [ecx + 0x5bb5e5] */
    WR32((uint32_t)(ebp + 0xfffffffcu), edx);  /* 0x4ab87c: mov dword ptr [ebp - 4], edx */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0x8u)))) & 0xffffffffu;  /* 0x4ab87f: movsx eax, word ptr [ebp + 8] */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ab883: mov ecx, dword ptr [ebp - 4] */
    edx = (edx & 0xffff0000u) | ((RD16((uint32_t)(ecx + eax * 2u + 0x31u))) & 0xffffu);  /* 0x4ab886: mov dx, word ptr [ecx + eax*2 + 0x31] */
    WR16((uint32_t)(ebp + 0xfffffff8u), (edx & 0xffffu));  /* 0x4ab88b: mov word ptr [ebp - 8], dx */
    eax = (eax & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0xfffffff8u))) & 0xffffu);  /* 0x4ab88f: mov ax, word ptr [ebp - 8] */
    esp = ebp;  /* 0x4ab893: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4ab895: pop ebp */
    esp += 8u; goto done;  /* 0x4ab896: ret 4 */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4ac3d2 (182 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4ac3d2_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4ac3d2: push ebp */
    ebp = esp;  /* 0x4ac3d3: mov ebp, esp */
    esp -= 4u; WR32(esp, ecx);  /* 0x4ac3d5: push ecx */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4ac3d6: mov dword ptr [ebp - 4], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ac3d9: mov eax, dword ptr [ebp - 4] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(eax + 0x32u)))) & 0xffffffffu;  /* 0x4ac3dc: movsx ecx, word ptr [eax + 0x32] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0xcu); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4ac3e0: imul ecx, ecx, 0xc */
    edx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4ac3e3: mov edx, dword ptr [ebp + 8] */
    eax = RD32((uint32_t)(ebp + 0xcu));  /* 0x4ac3e6: mov eax, dword ptr [ebp + 0xc] */
    ecx = RD32((uint32_t)(eax + ecx + 0x225u));  /* 0x4ac3e9: mov ecx, dword ptr [eax + ecx + 0x225] */
    WR32((uint32_t)(edx + 0x4u), ecx);  /* 0x4ac3f0: mov dword ptr [edx + 4], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ac3f3: mov edx, dword ptr [ebp - 4] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x32u)))) & 0xffffffffu;  /* 0x4ac3f6: movsx eax, word ptr [edx + 0x32] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0xcu); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4ac3fa: imul eax, eax, 0xc */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ac3fd: mov ecx, dword ptr [ebp - 4] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + 0x32u)))) & 0xffffffffu;  /* 0x4ac400: movsx edx, word ptr [ecx + 0x32] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0xcu); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4ac404: imul edx, edx, 0xc */
    ecx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4ac407: mov ecx, dword ptr [ebp + 0xc] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + edx + 0x22bu)))) & 0xffffffffu;  /* 0x4ac40a: movsx edx, word ptr [ecx + edx + 0x22b] */
    ecx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4ac412: mov ecx, dword ptr [ebp + 0xc] */
    eax = RD32((uint32_t)(ecx + eax + 0x225u));  /* 0x4ac415: mov eax, dword ptr [ecx + eax + 0x225] */
    { uint32_t a_ = eax, b_ = edx, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4ac41c: add eax, edx */
    ecx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4ac41e: mov ecx, dword ptr [ebp + 8] */
    WR32((uint32_t)(ecx + 0xcu), eax);  /* 0x4ac421: mov dword ptr [ecx + 0xc], eax */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ac424: mov edx, dword ptr [ebp - 4] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x32u)))) & 0xffffffffu;  /* 0x4ac427: movsx eax, word ptr [edx + 0x32] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0xcu); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4ac42b: imul eax, eax, 0xc */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ac42e: mov ecx, dword ptr [ebp - 4] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + 0x32u)))) & 0xffffffffu;  /* 0x4ac431: movsx edx, word ptr [ecx + 0x32] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0xcu); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4ac435: imul edx, edx, 0xc */
    ecx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4ac438: mov ecx, dword ptr [ebp + 0xc] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + edx + 0x229u)))) & 0xffffffffu;  /* 0x4ac43b: movsx edx, word ptr [ecx + edx + 0x229] */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ac443: mov ecx, dword ptr [ebp - 4] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + 0x34u)))) & 0xffffffffu;  /* 0x4ac446: movsx ecx, word ptr [ecx + 0x34] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(ecx); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4ac44a: imul edx, ecx */
    ecx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4ac44d: mov ecx, dword ptr [ebp + 0xc] */
    eax = RD32((uint32_t)(ecx + eax + 0x221u));  /* 0x4ac450: mov eax, dword ptr [ecx + eax + 0x221] */
    { uint32_t a_ = eax, b_ = edx, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4ac457: add eax, edx */
    ecx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4ac459: mov ecx, dword ptr [ebp + 8] */
    WR32((uint32_t)(ecx), eax);  /* 0x4ac45c: mov dword ptr [ecx], eax */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ac45e: mov edx, dword ptr [ebp - 4] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x32u)))) & 0xffffffffu;  /* 0x4ac461: movsx eax, word ptr [edx + 0x32] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0xcu); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4ac465: imul eax, eax, 0xc */
    ecx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4ac468: mov ecx, dword ptr [ebp + 0xc] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + eax + 0x229u)))) & 0xffffffffu;  /* 0x4ac46b: movsx edx, word ptr [ecx + eax + 0x229] */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4ac473: mov eax, dword ptr [ebp + 8] */
    ecx = RD32((uint32_t)(eax));  /* 0x4ac476: mov ecx, dword ptr [eax] */
    edx = (uint32_t)(ecx + edx + 0xfffffffeu);  /* 0x4ac478: lea edx, [ecx + edx - 2] */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4ac47c: mov eax, dword ptr [ebp + 8] */
    WR32((uint32_t)(eax + 0x8u), edx);  /* 0x4ac47f: mov dword ptr [eax + 8], edx */
    esp = ebp;  /* 0x4ac482: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4ac484: pop ebp */
    esp += 12u; goto done;  /* 0x4ac485: ret 8 */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4ba13d (241 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4ba13d_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4ba13d: push ebp */
    ebp = esp;  /* 0x4ba13e: mov ebp, esp */
    esp -= 4u; WR32(esp, ecx);  /* 0x4ba140: push ecx */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4ba141: mov dword ptr [ebp - 4], ecx */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ba144: mov ecx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, 0x4ba14cu); FL41_CALL(0x4be18bu); esp += 4u;  /* 0x4ba147: call 0x4be18b */
    esp -= 4u; WR32(esp, 0x4ba152u);  /* call [KERNEL32.dll!GetTickCount] */ FL41_CALL(0x52a23cu); esp += 4u;  /* 0x4ba14c: call dword ptr [0x52a23c] */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ba152: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x2dcu), eax);  /* 0x4ba155: mov dword ptr [ecx + 0x2dc], eax */
    esp -= 4u; WR32(esp, 0x4ba161u);  /* call [KERNEL32.dll!GetTickCount] */ FL41_CALL(0x52a23cu); esp += 4u;  /* 0x4ba15b: call dword ptr [0x52a23c] */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ba161: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0x2e0u), eax);  /* 0x4ba164: mov dword ptr [edx + 0x2e0], eax */
    esp -= 4u; WR32(esp, 0x4ba170u);  /* call [KERNEL32.dll!GetTickCount] */ FL41_CALL(0x52a23cu); esp += 4u;  /* 0x4ba16a: call dword ptr [0x52a23c] */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ba170: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x2e4u), eax);  /* 0x4ba173: mov dword ptr [ecx + 0x2e4], eax */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ba179: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0x2e8u), 0x0u);  /* 0x4ba17c: mov dword ptr [edx + 0x2e8], 0 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ba186: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x2ecu), 0x0u);  /* 0x4ba189: mov dword ptr [eax + 0x2ec], 0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ba193: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x2f0u), 0x0u);  /* 0x4ba196: mov dword ptr [ecx + 0x2f0], 0 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ba1a0: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0x2c4u), 0x0u);  /* 0x4ba1a3: mov dword ptr [edx + 0x2c4], 0 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ba1ad: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x2ccu), 0x0u);  /* 0x4ba1b0: mov dword ptr [eax + 0x2cc], 0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ba1ba: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x2d0u), 0x3u);  /* 0x4ba1bd: mov dword ptr [ecx + 0x2d0], 3 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ba1c7: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0x44u), 0x0u);  /* 0x4ba1ca: mov dword ptr [edx + 0x44], 0 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ba1d1: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x38u), 0x0u);  /* 0x4ba1d4: mov dword ptr [eax + 0x38], 0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ba1db: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x3cu), 0x0u);  /* 0x4ba1de: mov dword ptr [ecx + 0x3c], 0 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ba1e5: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0x40u), 0x0u);  /* 0x4ba1e8: mov dword ptr [edx + 0x40], 0 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ba1ef: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x48u), 0x0u);  /* 0x4ba1f2: mov dword ptr [eax + 0x48], 0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ba1f9: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x54u), 0x0u);  /* 0x4ba1fc: mov dword ptr [ecx + 0x54], 0 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ba203: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0x200u), 0x3f800000u);  /* 0x4ba206: mov dword ptr [edx + 0x200], 0x3f800000 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ba210: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x1fcu), 0x0u);  /* 0x4ba213: mov dword ptr [eax + 0x1fc], 0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ba21d: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x1f4u), 0x0u);  /* 0x4ba220: mov dword ptr [ecx + 0x1f4], 0 */
    esp = ebp;  /* 0x4ba22a: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4ba22c: pop ebp */
    esp += 4u; goto done;  /* 0x4ba22d: ret  */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4c9b25 (65 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4c9b25_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4c9b25: push ebp */
    ebp = esp;  /* 0x4c9b26: mov ebp, esp */
    esp -= 4u; WR32(esp, ecx);  /* 0x4c9b28: push ecx */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4c9b29: mov dword ptr [ebp - 4], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4c9b2c: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0xc62u));  /* 0x4c9b2f: mov ecx, dword ptr [eax + 0xc62] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4c9b35: push ecx */
    esp -= 4u; WR32(esp, 0x557c74u);  /* 0x4c9b36: push 0x557c74 */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x4c9b3b: push 0x63888b */
    esp -= 4u; WR32(esp, 0x4c9b45u); FL41_CALL(0x50ca3eu); esp += 4u;  /* 0x4c9b40: call 0x50ca3e */
    { uint32_t a_ = esp, b_ = 0xcu, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4c9b45: add esp, 0xc */
    esp -= 4u; WR32(esp, 0x639897u);  /* 0x4c9b48: push 0x639897 */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x4c9b4d: push 0x63888b */
    esp -= 4u; WR32(esp, 0x557c78u);  /* 0x4c9b52: push 0x557c78 */
    esp -= 4u; WR32(esp, 0x557c88u);  /* 0x4c9b57: push 0x557c88 */
    esp -= 4u; WR32(esp, 0x4c9b62u);  /* call [KERNEL32.dll!WritePrivateProfileStringA] */ FL41_CALL(0x52a26cu); esp += 16u; esp += 4u;  /* 0x4c9b5c: call dword ptr [0x52a26c] */
    esp = ebp;  /* 0x4c9b62: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4c9b64: pop ebp */
    esp += 4u; goto done;  /* 0x4c9b65: ret  */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4c9ca0 (61 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4c9ca0_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4c9ca0: push ebp */
    ebp = esp;  /* 0x4c9ca1: mov ebp, esp */
    esp -= 4u; WR32(esp, ecx);  /* 0x4c9ca3: push ecx */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4c9ca4: mov dword ptr [ebp - 4], ecx */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4c9ca7: mov eax, dword ptr [ebp + 8] */
    esp -= 4u; WR32(esp, eax);  /* 0x4c9caa: push eax */
    esp -= 4u; WR32(esp, 0x557cbcu);  /* 0x4c9cab: push 0x557cbc */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x4c9cb0: push 0x63888b */
    esp -= 4u; WR32(esp, 0x4c9cbau); FL41_CALL(0x50ca3eu); esp += 4u;  /* 0x4c9cb5: call 0x50ca3e */
    { uint32_t a_ = esp, b_ = 0xcu, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4c9cba: add esp, 0xc */
    esp -= 4u; WR32(esp, 0x639897u);  /* 0x4c9cbd: push 0x639897 */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x4c9cc2: push 0x63888b */
    esp -= 4u; WR32(esp, 0x557cc0u);  /* 0x4c9cc7: push 0x557cc0 */
    esp -= 4u; WR32(esp, 0x557ce0u);  /* 0x4c9ccc: push 0x557ce0 */
    esp -= 4u; WR32(esp, 0x4c9cd7u);  /* call [KERNEL32.dll!WritePrivateProfileStringA] */ FL41_CALL(0x52a26cu); esp += 16u; esp += 4u;  /* 0x4c9cd1: call dword ptr [0x52a26c] */
    esp = ebp;  /* 0x4c9cd7: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4c9cd9: pop ebp */
    esp += 8u; goto done;  /* 0x4c9cda: ret 4 */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4cc962 (172 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4cc962_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4cc962: push ebp */
    ebp = esp;  /* 0x4cc963: mov ebp, esp */
    esp -= 4u; WR32(esp, ecx);  /* 0x4cc965: push ecx */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4cc966: mov dword ptr [ebp - 4], ecx */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4cc969: mov eax, dword ptr [ebp + 8] */
    WR32((uint32_t)(eax + 0x1cu), 0x0u);  /* 0x4cc96c: mov dword ptr [eax + 0x1c], 0 */
    ecx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4cc973: mov ecx, dword ptr [ebp + 8] */
    WR32((uint32_t)(ecx + 0x18u), 0x0u);  /* 0x4cc976: mov dword ptr [ecx + 0x18], 0 */
    edx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4cc97d: mov edx, dword ptr [ebp + 8] */
    WR32((uint32_t)(edx + 0x10u), 0x0u);  /* 0x4cc980: mov dword ptr [edx + 0x10], 0 */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4cc987: mov eax, dword ptr [ebp + 8] */
    WR32((uint32_t)(eax + 0xcu), 0x0u);  /* 0x4cc98a: mov dword ptr [eax + 0xc], 0 */
    ecx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4cc991: mov ecx, dword ptr [ebp + 8] */
    WR32((uint32_t)(ecx + 0x8u), 0x0u);  /* 0x4cc994: mov dword ptr [ecx + 8], 0 */
    edx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4cc99b: mov edx, dword ptr [ebp + 8] */
    WR32((uint32_t)(edx + 0x4u), 0x0u);  /* 0x4cc99e: mov dword ptr [edx + 4], 0 */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4cc9a5: mov eax, dword ptr [ebp + 8] */
    WR32((uint32_t)(eax + 0x38u), 0x0u);  /* 0x4cc9a8: mov dword ptr [eax + 0x38], 0 */
    ecx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4cc9af: mov ecx, dword ptr [ebp + 8] */
    WR32((uint32_t)(ecx + 0x34u), 0x0u);  /* 0x4cc9b2: mov dword ptr [ecx + 0x34], 0 */
    edx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4cc9b9: mov edx, dword ptr [ebp + 8] */
    WR32((uint32_t)(edx + 0x30u), 0x0u);  /* 0x4cc9bc: mov dword ptr [edx + 0x30], 0 */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4cc9c3: mov eax, dword ptr [ebp + 8] */
    WR32((uint32_t)(eax + 0x2cu), 0x0u);  /* 0x4cc9c6: mov dword ptr [eax + 0x2c], 0 */
    ecx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4cc9cd: mov ecx, dword ptr [ebp + 8] */
    WR32((uint32_t)(ecx + 0x24u), 0x0u);  /* 0x4cc9d0: mov dword ptr [ecx + 0x24], 0 */
    edx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4cc9d7: mov edx, dword ptr [ebp + 8] */
    WR32((uint32_t)(edx + 0x20u), 0x0u);  /* 0x4cc9da: mov dword ptr [edx + 0x20], 0 */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4cc9e1: mov eax, dword ptr [ebp + 8] */
    WR32((uint32_t)(eax + 0x3cu), 0x3f800000u);  /* 0x4cc9e4: mov dword ptr [eax + 0x3c], 0x3f800000 */
    ecx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4cc9eb: mov ecx, dword ptr [ebp + 8] */
    WR32((uint32_t)(ecx + 0x28u), 0x3f800000u);  /* 0x4cc9ee: mov dword ptr [ecx + 0x28], 0x3f800000 */
    edx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4cc9f5: mov edx, dword ptr [ebp + 8] */
    WR32((uint32_t)(edx + 0x14u), 0x3f800000u);  /* 0x4cc9f8: mov dword ptr [edx + 0x14], 0x3f800000 */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4cc9ff: mov eax, dword ptr [ebp + 8] */
    WR32((uint32_t)(eax), 0x3f800000u);  /* 0x4cca02: mov dword ptr [eax], 0x3f800000 */
    esp = ebp;  /* 0x4cca08: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4cca0a: pop ebp */
    esp += 8u; goto done;  /* 0x4cca0b: ret 4 */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4d51c0 (42 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4d51c0_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4d51c0: push ebp */
    ebp = esp;  /* 0x4d51c1: mov ebp, esp */
    esp -= 4u; WR32(esp, ecx);  /* 0x4d51c3: push ecx */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4d51c4: mov dword ptr [ebp - 4], ecx */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4d51c7: mov eax, dword ptr [ebp + 8] */
    esp -= 4u; WR32(esp, eax);  /* 0x4d51ca: push eax */
    esp -= 4u; WR32(esp, 0x84u);  /* 0x4d51cb: push 0x84 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d51d0: mov ecx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, 0x4d51d8u); FL41_CALL(0x51e08bu); esp += 8u; esp += 4u;  /* 0x4d51d3: call 0x51e08b */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d51d8: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx), 0x52e380u);  /* 0x4d51db: mov dword ptr [ecx], 0x52e380 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d51e1: mov eax, dword ptr [ebp - 4] */
    esp = ebp;  /* 0x4d51e4: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4d51e6: pop ebp */
    esp += 8u; goto done;  /* 0x4d51e7: ret 4 */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4d5207 (29 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4d5207_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4d5207: push ebp */
    ebp = esp;  /* 0x4d5208: mov ebp, esp */
    esp -= 4u; WR32(esp, ecx);  /* 0x4d520a: push ecx */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4d520b: mov dword ptr [ebp - 4], ecx */
    WR32((uint32_t)(0x5bb1c6u), 0x1u);  /* 0x4d520e: mov dword ptr [0x5bb1c6], 1 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5218: mov ecx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, 0x4d5220u); FL41_CALL(0x51e446u); esp += 4u;  /* 0x4d521b: call 0x51e446 */
    esp = ebp;  /* 0x4d5220: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4d5222: pop ebp */
    esp += 4u; goto done;  /* 0x4d5223: ret  */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4d58eb (617 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4d58eb_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4d58eb: push ebp */
    ebp = esp;  /* 0x4d58ec: mov ebp, esp */
    esp -= 4u; WR32(esp, ecx);  /* 0x4d58ee: push ecx */
    esp -= 4u; WR32(esp, edi);  /* 0x4d58ef: push edi */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4d58f0: mov dword ptr [ebp - 4], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d58f3: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x4u), 0x0u);  /* 0x4d58f6: mov dword ptr [eax + 4], 0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d58fd: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x455u), 0x0u);  /* 0x4d5900: mov dword ptr [ecx + 0x455], 0 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d590a: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0x461u), 0x0u);  /* 0x4d590d: mov dword ptr [edx + 0x461], 0 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5917: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x955eu), 0xffffffffu);  /* 0x4d591a: mov dword ptr [eax + 0x955e], 0xffffffff */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5924: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x9562u), 0xffffffffu);  /* 0x4d5927: mov dword ptr [ecx + 0x9562], 0xffffffff */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5931: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0x955au), 0x0u);  /* 0x4d5934: mov dword ptr [edx + 0x955a], 0 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d593e: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x9556u), 0x0u);  /* 0x4d5941: mov dword ptr [eax + 0x9556], 0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d594b: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x459u), 0x0u);  /* 0x4d594e: mov dword ptr [ecx + 0x459], 0 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5958: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0x45du), 0x0u);  /* 0x4d595b: mov dword ptr [edx + 0x45d], 0 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5965: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x445u), 0x0u);  /* 0x4d5968: mov dword ptr [eax + 0x445], 0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5972: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x449u), 0x0u);  /* 0x4d5975: mov dword ptr [ecx + 0x449], 0 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d597f: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0x44du), 0x0u);  /* 0x4d5982: mov dword ptr [edx + 0x44d], 0 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d598c: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x94d2u), 0x0u);  /* 0x4d598f: mov dword ptr [eax + 0x94d2], 0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5999: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x951au), 0x0u);  /* 0x4d599c: mov dword ptr [ecx + 0x951a], 0 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d59a6: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0x951eu), 0x0u);  /* 0x4d59a9: mov dword ptr [edx + 0x951e], 0 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d59b3: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x9532u), 0x0u);  /* 0x4d59b6: mov dword ptr [eax + 0x9532], 0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d59c0: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x9536u), 0x0u);  /* 0x4d59c3: mov dword ptr [ecx + 0x9536], 0 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d59cd: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0x953au), 0x0u);  /* 0x4d59d0: mov dword ptr [edx + 0x953a], 0 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d59da: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x9532u), 0x0u);  /* 0x4d59dd: mov dword ptr [eax + 0x9532], 0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d59e7: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x94d6u), 0x0u);  /* 0x4d59ea: mov dword ptr [ecx + 0x94d6], 0 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d59f4: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0x94dau), 0x0u);  /* 0x4d59f7: mov dword ptr [edx + 0x94da], 0 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5a01: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x94deu), 0x0u);  /* 0x4d5a04: mov dword ptr [eax + 0x94de], 0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5a0e: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x950au), 0x0u);  /* 0x4d5a11: mov dword ptr [ecx + 0x950a], 0 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5a1b: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0x950eu), 0x0u);  /* 0x4d5a1e: mov dword ptr [edx + 0x950e], 0 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5a28: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x9512u), 0x0u);  /* 0x4d5a2b: mov dword ptr [eax + 0x9512], 0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5a35: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x9546u), 0x0u);  /* 0x4d5a38: mov dword ptr [ecx + 0x9546], 0 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5a42: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0x954au), 0x0u);  /* 0x4d5a45: mov dword ptr [edx + 0x954a], 0 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5a4f: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x98a8u), 0x0u);  /* 0x4d5a52: mov dword ptr [eax + 0x98a8], 0 */
    goto L_4d5a73;  /* 0x4d5a5c: jmp 0x4d5a73 */
L_4d5a5e:
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5a5e: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ecx + 0x98a8u));  /* 0x4d5a61: mov edx, dword ptr [ecx + 0x98a8] */
    { uint32_t a_ = edx, b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4d5a67: add edx, 1 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5a6a: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x98a8u), edx);  /* 0x4d5a6d: mov dword ptr [eax + 0x98a8], edx */
L_4d5a73:
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5a73: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(ecx + 0x98a8u)), b_ = 0x5u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4d5a76: cmp dword ptr [ecx + 0x98a8], 5 */
    if ((sf == of)) goto L_4d5a98;  /* 0x4d5a7d: jge 0x4d5a98 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5a7f: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + 0x98a8u));  /* 0x4d5a82: mov eax, dword ptr [edx + 0x98a8] */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5a88: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + eax * 4u + 0x956eu), 0x0u);  /* 0x4d5a8b: mov dword ptr [ecx + eax*4 + 0x956e], 0 */
    goto L_4d5a5e;  /* 0x4d5a96: jmp 0x4d5a5e */
L_4d5a98:
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5a98: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0x98a8u), 0x0u);  /* 0x4d5a9b: mov dword ptr [edx + 0x98a8], 0 */
    goto L_4d5abc;  /* 0x4d5aa5: jmp 0x4d5abc */
L_4d5aa7:
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5aa7: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0x98a8u));  /* 0x4d5aaa: mov ecx, dword ptr [eax + 0x98a8] */
    { uint32_t a_ = ecx, b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4d5ab0: add ecx, 1 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5ab3: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0x98a8u), ecx);  /* 0x4d5ab6: mov dword ptr [edx + 0x98a8], ecx */
L_4d5abc:
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5abc: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(eax + 0x98a8u)), b_ = 0xau, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4d5abf: cmp dword ptr [eax + 0x98a8], 0xa */
    if ((sf == of)) goto L_4d5b0f;  /* 0x4d5ac6: jge 0x4d5b0f */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5ac8: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ecx + 0x98a8u));  /* 0x4d5acb: mov edx, dword ptr [ecx + 0x98a8] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5ad1: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + edx * 4u + 0x94e2u), 0x0u);  /* 0x4d5ad4: mov dword ptr [eax + edx*4 + 0x94e2], 0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5adf: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ecx + 0x98a8u));  /* 0x4d5ae2: mov edx, dword ptr [ecx + 0x98a8] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x21u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4d5ae8: imul edx, edx, 0x21 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5aeb: mov eax, dword ptr [ebp - 4] */
    WR8((uint32_t)(eax + edx + 0x95aau), 0x0u);  /* 0x4d5aee: mov byte ptr [eax + edx + 0x95aa], 0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5af6: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ecx + 0x98a8u));  /* 0x4d5af9: mov edx, dword ptr [ecx + 0x98a8] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5aff: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + edx * 4u + 0x9582u), 0x0u);  /* 0x4d5b02: mov dword ptr [eax + edx*4 + 0x9582], 0 */
    goto L_4d5aa7;  /* 0x4d5b0d: jmp 0x4d5aa7 */
L_4d5b0f:
    ecx = 0x28u;  /* 0x4d5b0f: mov ecx, 0x28 */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x4d5b14: xor eax, eax */
    edi = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5b16: mov edi, dword ptr [ebp - 4] */
    { uint32_t a_ = edi, b_ = 0x9754u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edi = r_; }  /* 0x4d5b19: add edi, 0x9754 */
    /* 0x4d5b1f: rep stosd dword ptr es:[edi], eax */
    while (ecx != 0u) {
    WR32(edi, eax);
    edi += 4u;
    ecx -= 1u;
    }
    WR32((uint32_t)(0x5d2ecbu), 0x0u);  /* 0x4d5b21: mov dword ptr [0x5d2ecb], 0 */
    ecx = 0x2417u;  /* 0x4d5b2b: mov ecx, 0x2417 */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x4d5b30: xor eax, eax */
    edi = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5b32: mov edi, dword ptr [ebp - 4] */
    { uint32_t a_ = edi, b_ = 0x476u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edi = r_; }  /* 0x4d5b35: add edi, 0x476 */
    /* 0x4d5b3b: rep stosd dword ptr es:[edi], eax */
    while (ecx != 0u) {
    WR32(edi, eax);
    edi += 4u;
    ecx -= 1u;
    }
    ecx = 0x29u;  /* 0x4d5b3d: mov ecx, 0x29 */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x4d5b42: xor eax, eax */
    edi = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5b44: mov edi, dword ptr [ebp - 4] */
    { uint32_t a_ = edi, b_ = 0x9804u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edi = r_; }  /* 0x4d5b47: add edi, 0x9804 */
    /* 0x4d5b4d: rep stosd dword ptr es:[edi], eax */
    while (ecx != 0u) {
    WR32(edi, eax);
    edi += 4u;
    ecx -= 1u;
    }
    edi = RD32(esp); esp += 4u;  /* 0x4d5b4f: pop edi */
    esp = ebp;  /* 0x4d5b50: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4d5b52: pop ebp */
    esp += 4u; goto done;  /* 0x4d5b53: ret  */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4d9302 (264 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4d9302_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4d9302: push ebp */
    ebp = esp;  /* 0x4d9303: mov ebp, esp */
    esp -= 4u; WR32(esp, ecx);  /* 0x4d9305: push ecx */
    esp -= 4u; WR32(esp, esi);  /* 0x4d9306: push esi */
    esp -= 4u; WR32(esp, edi);  /* 0x4d9307: push edi */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4d9308: mov dword ptr [ebp - 4], ecx */
    edi = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d930b: mov edi, dword ptr [ebp - 4] */
    { uint32_t a_ = edi, b_ = 0x476u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edi = r_; }  /* 0x4d930e: add edi, 0x476 */
    ecx = 0x1eu;  /* 0x4d9314: mov ecx, 0x1e */
    esi = 0x5839b1u;  /* 0x4d9319: mov esi, 0x5839b1 */
    /* 0x4d931e: rep movsd dword ptr es:[edi], dword ptr [esi] */
    while (ecx != 0u) {
    WR32(edi, RD32(esi));
    esi += 4u; edi += 4u;
    ecx -= 1u;
    }
    ecx = 0x8c2u;  /* 0x4d9320: mov ecx, 0x8c2 */
    esi = 0x583a29u;  /* 0x4d9325: mov esi, 0x583a29 */
    edi = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d932a: mov edi, dword ptr [ebp - 4] */
    { uint32_t a_ = edi, b_ = 0x4eeu, r_; FL41_ADD(a_, b_, 0u, r_, 32); edi = r_; }  /* 0x4d932d: add edi, 0x4ee */
    /* 0x4d9333: rep movsd dword ptr es:[edi], dword ptr [esi] */
    while (ecx != 0u) {
    WR32(edi, RD32(esi));
    esi += 4u; edi += 4u;
    ecx -= 1u;
    }
    WR16(edi, RD16(esi)); esi += 2u; edi += 2u;  /* 0x4d9335: movsw word ptr es:[edi], word ptr [esi] */
    edi = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d9337: mov edi, dword ptr [ebp - 4] */
    { uint32_t a_ = edi, b_ = 0x27f8u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edi = r_; }  /* 0x4d933a: add edi, 0x27f8 */
    ecx = 0x29bu;  /* 0x4d9340: mov ecx, 0x29b */
    esi = 0x585d33u;  /* 0x4d9345: mov esi, 0x585d33 */
    /* 0x4d934a: rep movsd dword ptr es:[edi], dword ptr [esi] */
    while (ecx != 0u) {
    WR32(edi, RD32(esi));
    esi += 4u; edi += 4u;
    ecx -= 1u;
    }
    WR16(edi, RD16(esi)); esi += 2u; edi += 2u;  /* 0x4d934c: movsw word ptr es:[edi], word ptr [esi] */
    ecx = 0x4e3u;  /* 0x4d934e: mov ecx, 0x4e3 */
    esi = 0x5867a1u;  /* 0x4d9353: mov esi, 0x5867a1 */
    edi = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d9358: mov edi, dword ptr [ebp - 4] */
    { uint32_t a_ = edi, b_ = 0x3266u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edi = r_; }  /* 0x4d935b: add edi, 0x3266 */
    /* 0x4d9361: rep movsd dword ptr es:[edi], dword ptr [esi] */
    while (ecx != 0u) {
    WR32(edi, RD32(esi));
    esi += 4u; edi += 4u;
    ecx -= 1u;
    }
    ecx = 0x1388u;  /* 0x4d9363: mov ecx, 0x1388 */
    esi = 0x587b2du;  /* 0x4d9368: mov esi, 0x587b2d */
    edi = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d936d: mov edi, dword ptr [ebp - 4] */
    { uint32_t a_ = edi, b_ = 0x45f2u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edi = r_; }  /* 0x4d9370: add edi, 0x45f2 */
    /* 0x4d9376: rep movsd dword ptr es:[edi], dword ptr [esi] */
    while (ecx != 0u) {
    WR32(edi, RD32(esi));
    esi += 4u; edi += 4u;
    ecx -= 1u;
    }
    WR16(edi, RD16(esi)); esi += 2u; edi += 2u;  /* 0x4d9378: movsw word ptr es:[edi], word ptr [esi] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d937a: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(0x58c951u));  /* 0x4d937d: mov ecx, dword ptr [0x58c951] */
    WR32((uint32_t)(eax + 0x9414u), ecx);  /* 0x4d9383: mov dword ptr [eax + 0x9414], ecx */
    edx = RD32((uint32_t)(0x58c955u));  /* 0x4d9389: mov edx, dword ptr [0x58c955] */
    WR32((uint32_t)(eax + 0x9418u), edx);  /* 0x4d938f: mov dword ptr [eax + 0x9418], edx */
    edi = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d9395: mov edi, dword ptr [ebp - 4] */
    { uint32_t a_ = edi, b_ = 0x941cu, r_; FL41_ADD(a_, b_, 0u, r_, 32); edi = r_; }  /* 0x4d9398: add edi, 0x941c */
    ecx = 0x12u;  /* 0x4d939e: mov ecx, 0x12 */
    esi = 0x591990u;  /* 0x4d93a3: mov esi, 0x591990 */
    /* 0x4d93a8: rep movsd dword ptr es:[edi], dword ptr [esi] */
    while (ecx != 0u) {
    WR32(edi, RD32(esi));
    esi += 4u; edi += 4u;
    ecx -= 1u;
    }
    WR16(edi, RD16(esi)); esi += 2u; edi += 2u;  /* 0x4d93aa: movsw word ptr es:[edi], word ptr [esi] */
    edi = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d93ac: mov edi, dword ptr [ebp - 4] */
    { uint32_t a_ = edi, b_ = 0x9466u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edi = r_; }  /* 0x4d93af: add edi, 0x9466 */
    ecx = 0x19u;  /* 0x4d93b5: mov ecx, 0x19 */
    esi = 0x58c959u;  /* 0x4d93ba: mov esi, 0x58c959 */
    /* 0x4d93bf: rep movsd dword ptr es:[edi], dword ptr [esi] */
    while (ecx != 0u) {
    WR32(edi, RD32(esi));
    esi += 4u; edi += 4u;
    ecx -= 1u;
    }
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d93c1: mov eax, dword ptr [ebp - 4] */
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(0x5bb57fu))) & 0xffffu);  /* 0x4d93c4: mov cx, word ptr [0x5bb57f] */
    WR16((uint32_t)(eax + 0x94ccu), (ecx & 0xffffu));  /* 0x4d93cb: mov word ptr [eax + 0x94cc], cx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d93d2: mov edx, dword ptr [ebp - 4] */
    eax = (eax & 0xffff0000u) | ((RD16((uint32_t)(0x5bb597u))) & 0xffffu);  /* 0x4d93d5: mov ax, word ptr [0x5bb597] */
    WR16((uint32_t)(edx + 0x94ceu), (eax & 0xffffu));  /* 0x4d93db: mov word ptr [edx + 0x94ce], ax */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d93e2: mov ecx, dword ptr [ebp - 4] */
    edx = (edx & 0xffff0000u) | ((RD16((uint32_t)(0x5bb593u))) & 0xffffu);  /* 0x4d93e5: mov dx, word ptr [0x5bb593] */
    WR16((uint32_t)(ecx + 0x94d0u), (edx & 0xffffu));  /* 0x4d93ec: mov word ptr [ecx + 0x94d0], dx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d93f3: mov eax, dword ptr [ebp - 4] */
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(0x58c94fu))) & 0xffffu);  /* 0x4d93f6: mov cx, word ptr [0x58c94f] */
    WR16((uint32_t)(eax + 0x94cau), (ecx & 0xffffu));  /* 0x4d93fd: mov word ptr [eax + 0x94ca], cx */
    edi = RD32(esp); esp += 4u;  /* 0x4d9404: pop edi */
    esi = RD32(esp); esp += 4u;  /* 0x4d9405: pop esi */
    esp = ebp;  /* 0x4d9406: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4d9408: pop ebp */
    esp += 4u; goto done;  /* 0x4d9409: ret  */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4e048f (100 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4e048f_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4e048f: push ebp */
    ebp = esp;  /* 0x4e0490: mov ebp, esp */
    esp -= 4u; WR32(esp, 0xffffffffu);  /* 0x4e0492: push -1 */
    esp -= 4u; WR32(esp, 0x528990u);  /* 0x4e0494: push 0x528990 */
    eax = RD32((uint32_t)(FL41_TIB));  /* 0x4e0499: mov eax, dword ptr fs:[0] */
    esp -= 4u; WR32(esp, eax);  /* 0x4e049f: push eax */
    WR32((uint32_t)(FL41_TIB), esp);  /* 0x4e04a0: mov dword ptr fs:[0], esp */
    esp -= 4u; WR32(esp, ecx);  /* 0x4e04a7: push ecx */
    WR32((uint32_t)(ebp + 0xfffffff0u), ecx);  /* 0x4e04a8: mov dword ptr [ebp - 0x10], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4e04ab: mov eax, dword ptr [ebp - 0x10] */
    WR32((uint32_t)(eax), 0x52e4e4u);  /* 0x4e04ae: mov dword ptr [eax], 0x52e4e4 */
    WR32((uint32_t)(ebp + 0xfffffffcu), 0x0u);  /* 0x4e04b4: mov dword ptr [ebp - 4], 0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4e04bb: mov ecx, dword ptr [ebp - 0x10] */
    esp -= 4u; WR32(esp, 0x4e04c3u); FL41_CALL(0x4e0619u); esp += 4u;  /* 0x4e04be: call 0x4e0619 */
    WR32((uint32_t)(ebp + 0xfffffffcu), 0xffffffffu);  /* 0x4e04c3: mov dword ptr [ebp - 4], 0xffffffff */
    esp -= 4u; WR32(esp, 0x4e1c83u);  /* 0x4e04ca: push 0x4e1c83 */
    esp -= 4u; WR32(esp, 0x5u);  /* 0x4e04cf: push 5 */
    esp -= 4u; WR32(esp, 0x18fu);  /* 0x4e04d1: push 0x18f */
    ecx = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4e04d6: mov ecx, dword ptr [ebp - 0x10] */
    { uint32_t a_ = ecx, b_ = 0x757u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4e04d9: add ecx, 0x757 */
    esp -= 4u; WR32(esp, ecx);  /* 0x4e04df: push ecx */
    esp -= 4u; WR32(esp, 0x4e04e5u); FL41_CALL(0x50cba8u); esp += 16u; esp += 4u;  /* 0x4e04e0: call 0x50cba8 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4e04e5: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(FL41_TIB), ecx);  /* 0x4e04e8: mov dword ptr fs:[0], ecx */
    esp = ebp;  /* 0x4e04ef: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4e04f1: pop ebp */
    esp += 4u; goto done;  /* 0x4e04f2: ret  */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4e2ce0 (131 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4e2ce0_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4e2ce0: push ebp */
    ebp = esp;  /* 0x4e2ce1: mov ebp, esp */
    esp -= 4u; WR32(esp, 0xffffffffu);  /* 0x4e2ce3: push -1 */
    esp -= 4u; WR32(esp, 0x5289c4u);  /* 0x4e2ce5: push 0x5289c4 */
    eax = RD32((uint32_t)(FL41_TIB));  /* 0x4e2cea: mov eax, dword ptr fs:[0] */
    esp -= 4u; WR32(esp, eax);  /* 0x4e2cf0: push eax */
    WR32((uint32_t)(FL41_TIB), esp);  /* 0x4e2cf1: mov dword ptr fs:[0], esp */
    esp -= 4u; WR32(esp, ecx);  /* 0x4e2cf8: push ecx */
    WR32((uint32_t)(ebp + 0xfffffff0u), ecx);  /* 0x4e2cf9: mov dword ptr [ebp - 0x10], ecx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4e2cfc: mov ecx, dword ptr [ebp - 0x10] */
    esp -= 4u; WR32(esp, 0x4e2d04u); FL41_CALL(0x4eda10u); esp += 4u;  /* 0x4e2cff: call 0x4eda10 */
    WR32((uint32_t)(ebp + 0xfffffffcu), 0x0u);  /* 0x4e2d04: mov dword ptr [ebp - 4], 0 */
    esp -= 4u; WR32(esp, 0x4e1c83u);  /* 0x4e2d0b: push 0x4e1c83 */
    esp -= 4u; WR32(esp, 0x4e1c50u);  /* 0x4e2d10: push 0x4e1c50 */
    esp -= 4u; WR32(esp, 0x1au);  /* 0x4e2d15: push 0x1a */
    esp -= 4u; WR32(esp, 0x18fu);  /* 0x4e2d17: push 0x18f */
    eax = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4e2d1c: mov eax, dword ptr [ebp - 0x10] */
    { uint32_t a_ = eax, b_ = 0x1ca2u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4e2d1f: add eax, 0x1ca2 */
    esp -= 4u; WR32(esp, eax);  /* 0x4e2d24: push eax */
    esp -= 4u; WR32(esp, 0x4e2d2au); FL41_CALL(0x50cb26u); esp += 20u; esp += 4u;  /* 0x4e2d25: call 0x50cb26 */
    WR8((uint32_t)(ebp + 0xfffffffcu), 0x1u);  /* 0x4e2d2a: mov byte ptr [ebp - 4], 1 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4e2d2e: mov ecx, dword ptr [ebp - 0x10] */
    WR32((uint32_t)(ecx), 0x52e4ecu);  /* 0x4e2d31: mov dword ptr [ecx], 0x52e4ec */
    ecx = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4e2d37: mov ecx, dword ptr [ebp - 0x10] */
    esp -= 4u; WR32(esp, 0x4e2d3fu); FL41_CALL(0x4e2dd3u); esp += 4u;  /* 0x4e2d3a: call 0x4e2dd3 */
    edx = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4e2d3f: mov edx, dword ptr [ebp - 0x10] */
    WR16((uint32_t)(edx + 0x6b2u), 0x270fu);  /* 0x4e2d42: mov word ptr [edx + 0x6b2], 0x270f */
    WR32((uint32_t)(ebp + 0xfffffffcu), 0xffffffffu);  /* 0x4e2d4b: mov dword ptr [ebp - 4], 0xffffffff */
    eax = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4e2d52: mov eax, dword ptr [ebp - 0x10] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4e2d55: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(FL41_TIB), ecx);  /* 0x4e2d58: mov dword ptr fs:[0], ecx */
    esp = ebp;  /* 0x4e2d5f: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4e2d61: pop ebp */
    esp += 4u; goto done;  /* 0x4e2d62: ret  */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4ee644 (47 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4ee644_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4ee644: push ebp */
    ebp = esp;  /* 0x4ee645: mov ebp, esp */
    esp -= 4u; WR32(esp, ecx);  /* 0x4ee647: push ecx */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4ee648: mov dword ptr [ebp - 4], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4ee64b: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = eax, b_ = 0x1cu, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4ee64e: add eax, 0x1c */
    ecx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4ee651: mov ecx, dword ptr [ebp + 8] */
    edx = RD32((uint32_t)(eax));  /* 0x4ee654: mov edx, dword ptr [eax] */
    WR32((uint32_t)(ecx), edx);  /* 0x4ee656: mov dword ptr [ecx], edx */
    edx = RD32((uint32_t)(eax + 0x4u));  /* 0x4ee658: mov edx, dword ptr [eax + 4] */
    WR32((uint32_t)(ecx + 0x4u), edx);  /* 0x4ee65b: mov dword ptr [ecx + 4], edx */
    edx = RD32((uint32_t)(eax + 0x8u));  /* 0x4ee65e: mov edx, dword ptr [eax + 8] */
    WR32((uint32_t)(ecx + 0x8u), edx);  /* 0x4ee661: mov dword ptr [ecx + 8], edx */
    eax = RD32((uint32_t)(eax + 0xcu));  /* 0x4ee664: mov eax, dword ptr [eax + 0xc] */
    WR32((uint32_t)(ecx + 0xcu), eax);  /* 0x4ee667: mov dword ptr [ecx + 0xc], eax */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4ee66a: mov eax, dword ptr [ebp + 8] */
    esp = ebp;  /* 0x4ee66d: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4ee66f: pop ebp */
    esp += 8u; goto done;  /* 0x4ee670: ret 4 */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4fad50 (116 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4fad50_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4fad50: push ebp */
    ebp = esp;  /* 0x4fad51: mov ebp, esp */
    esp -= 4u; WR32(esp, ecx);  /* 0x4fad53: push ecx */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4fad54: mov dword ptr [ebp - 4], ecx */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x63a4cdu)))) & 0xffffffffu;  /* 0x4fad57: movsx eax, word ptr [0x63a4cd] */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4fad5e: test eax, eax */
    if (zf) goto L_4fad6f;  /* 0x4fad60: je 0x4fad6f */
    esp -= 4u; WR32(esp, 0x560578u);  /* 0x4fad62: push 0x560578 */
    esp -= 4u; WR32(esp, 0x4fad6cu); FL41_CALL(0x44a2b7u); esp += 4u;  /* 0x4fad67: call 0x44a2b7 */
    { uint32_t a_ = esp, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4fad6c: add esp, 4 */
L_4fad6f:
    ecx = 0x5cf1ebu;  /* 0x4fad6f: mov ecx, 0x5cf1eb */
    esp -= 4u; WR32(esp, 0x4fad79u); FL41_CALL(0x4f3415u); esp += 4u;  /* 0x4fad74: call 0x4f3415 */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4fad79: test eax, eax */
    if (!zf) goto L_4fadc0;  /* 0x4fad7b: jne 0x4fadc0 */
    ecx = 0x5cf1ebu;  /* 0x4fad7d: mov ecx, 0x5cf1eb */
    esp -= 4u; WR32(esp, 0x4fad87u); FL41_CALL(0x4fa2a8u); esp += 4u;  /* 0x4fad82: call 0x4fa2a8 */
    esp -= 4u; WR32(esp, eax);  /* 0x4fad87: push eax */
    esp -= 4u; WR32(esp, 0x560598u);  /* 0x4fad88: push 0x560598 */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x4fad8d: push 0x63888b */
    esp -= 4u; WR32(esp, 0x4fad97u); FL41_CALL(0x50ca3eu); esp += 4u;  /* 0x4fad92: call 0x50ca3e */
    { uint32_t a_ = esp, b_ = 0xcu, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4fad97: add esp, 0xc */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x63a4cdu)))) & 0xffffffffu;  /* 0x4fad9a: movsx ecx, word ptr [0x63a4cd] */
    { uint32_t a_ = ecx, b_ = ecx, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4fada1: test ecx, ecx */
    if (zf) goto L_4fadb2;  /* 0x4fada3: je 0x4fadb2 */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x4fada5: push 0x63888b */
    esp -= 4u; WR32(esp, 0x4fadafu); FL41_CALL(0x44a2b7u); esp += 4u;  /* 0x4fadaa: call 0x44a2b7 */
    { uint32_t a_ = esp, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4fadaf: add esp, 4 */
L_4fadb2:
    esp -= 4u; WR32(esp, 0x0u);  /* 0x4fadb2: push 0 */
    esp -= 4u; WR32(esp, 0x0u);  /* 0x4fadb4: push 0 */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x4fadb6: push 0x63888b */
    esp -= 4u; WR32(esp, 0x4fadc0u); FL41_CALL(0x52139cu); esp += 12u; esp += 4u;  /* 0x4fadbb: call 0x52139c */
L_4fadc0:
    esp = ebp;  /* 0x4fadc0: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4fadc2: pop ebp */
    esp += 4u; goto done;  /* 0x4fadc3: ret  */
done:
    FL41_EPILOGUE
}

