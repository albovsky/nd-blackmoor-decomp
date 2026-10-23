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

/* GAME.EXE 0x4a3beb (853 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4a3beb_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4a3beb: push ebp */
    ebp = esp;  /* 0x4a3bec: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0xcu, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4a3bee: sub esp, 0xc */
    WR32((uint32_t)(ebp + 0xfffffff4u), ecx);  /* 0x4a3bf1: mov dword ptr [ebp - 0xc], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3bf4: mov eax, dword ptr [ebp - 0xc] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3bf7: mov ecx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(eax + 0x288u));  /* 0x4a3bfa: mov eax, dword ptr [eax + 0x288] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(ecx + 0x280u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4a3c00: sub eax, dword ptr [ecx + 0x280] */
    edx = (eax & 0x80000000u) ? 0xffffffffu : 0u;  /* 0x4a3c06: cdq  */
    { uint32_t a_ = eax, b_ = edx, r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4a3c07: sub eax, edx */
    { uint32_t a_ = eax, n_ = 0x1u, r_; if (n_ != 0u) { FL41_SAR(r_, a_, n_, 32); eax = r_; } }  /* 0x4a3c09: sar eax, 1 */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3c0b: mov edx, dword ptr [ebp - 0xc] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(edx + 0x280u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4a3c0e: add eax, dword ptr [edx + 0x280] */
    WR32((uint32_t)(ebp + 0xfffffff8u), eax);  /* 0x4a3c14: mov dword ptr [ebp - 8], eax */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3c17: mov eax, dword ptr [ebp - 0xc] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3c1a: mov ecx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(eax + 0x28cu));  /* 0x4a3c1d: mov eax, dword ptr [eax + 0x28c] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(ecx + 0x284u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4a3c23: sub eax, dword ptr [ecx + 0x284] */
    edx = (eax & 0x80000000u) ? 0xffffffffu : 0u;  /* 0x4a3c29: cdq  */
    { uint32_t a_ = eax, b_ = edx, r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4a3c2a: sub eax, edx */
    { uint32_t a_ = eax, n_ = 0x1u, r_; if (n_ != 0u) { FL41_SAR(r_, a_, n_, 32); eax = r_; } }  /* 0x4a3c2c: sar eax, 1 */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3c2e: mov edx, dword ptr [ebp - 0xc] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(edx + 0x284u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4a3c31: add eax, dword ptr [edx + 0x284] */
    WR32((uint32_t)(ebp + 0xfffffffcu), eax);  /* 0x4a3c37: mov dword ptr [ebp - 4], eax */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3c3a: mov eax, dword ptr [ebp - 0xc] */
    { uint32_t a_ = RD32((uint32_t)(eax + 0x272u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4a3c3d: cmp dword ptr [eax + 0x272], 0 */
    if (zf) goto L_4a3db3;  /* 0x4a3c44: je 0x4a3db3 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3c4a: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3c4d: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0x22cu));  /* 0x4a3c50: mov eax, dword ptr [edx + 0x22c] */
    WR32((uint32_t)(ecx + 0x21cu), eax);  /* 0x4a3c56: mov dword ptr [ecx + 0x21c], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3c5c: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3c5f: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0x234u));  /* 0x4a3c62: mov eax, dword ptr [edx + 0x234] */
    WR32((uint32_t)(ecx + 0x224u), eax);  /* 0x4a3c68: mov dword ptr [ecx + 0x224], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3c6e: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3c71: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0x228u));  /* 0x4a3c74: mov eax, dword ptr [edx + 0x228] */
    WR32((uint32_t)(ecx + 0x218u), eax);  /* 0x4a3c7a: mov dword ptr [ecx + 0x218], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3c80: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3c83: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0x230u));  /* 0x4a3c86: mov eax, dword ptr [edx + 0x230] */
    WR32((uint32_t)(ecx + 0x220u), eax);  /* 0x4a3c8c: mov dword ptr [ecx + 0x220], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3c92: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3c95: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0x24cu));  /* 0x4a3c98: mov eax, dword ptr [edx + 0x24c] */
    WR32((uint32_t)(ecx + 0x23cu), eax);  /* 0x4a3c9e: mov dword ptr [ecx + 0x23c], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3ca4: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3ca7: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0x254u));  /* 0x4a3caa: mov eax, dword ptr [edx + 0x254] */
    WR32((uint32_t)(ecx + 0x244u), eax);  /* 0x4a3cb0: mov dword ptr [ecx + 0x244], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3cb6: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3cb9: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0x248u));  /* 0x4a3cbc: mov eax, dword ptr [edx + 0x248] */
    WR32((uint32_t)(ecx + 0x238u), eax);  /* 0x4a3cc2: mov dword ptr [ecx + 0x238], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3cc8: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3ccb: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0x250u));  /* 0x4a3cce: mov eax, dword ptr [edx + 0x250] */
    WR32((uint32_t)(ecx + 0x240u), eax);  /* 0x4a3cd4: mov dword ptr [ecx + 0x240], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3cda: mov ecx, dword ptr [ebp - 0xc] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + 0x836u)))) & 0xffffffffu;  /* 0x4a3cdd: movsx edx, word ptr [ecx + 0x836] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4a3ce4: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = eax, b_ = edx, r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4a3ce7: sub eax, edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3ce9: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ecx + 0x22cu), eax);  /* 0x4a3cec: mov dword ptr [ecx + 0x22c], eax */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3cf2: mov edx, dword ptr [ebp - 0xc] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x832u)))) & 0xffffffffu;  /* 0x4a3cf5: movsx eax, word ptr [edx + 0x832] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3cfc: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0x22cu));  /* 0x4a3cff: mov edx, dword ptr [ecx + 0x22c] */
    { uint32_t a_ = edx, b_ = eax, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a3d05: add edx, eax */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3d07: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0x234u), edx);  /* 0x4a3d0a: mov dword ptr [eax + 0x234], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3d10: mov ecx, dword ptr [ebp - 0xc] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + 0x834u)))) & 0xffffffffu;  /* 0x4a3d13: movsx edx, word ptr [ecx + 0x834] */
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4a3d1a: mov eax, dword ptr [ebp - 8] */
    { uint32_t a_ = eax, b_ = edx, r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4a3d1d: sub eax, edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3d1f: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ecx + 0x228u), eax);  /* 0x4a3d22: mov dword ptr [ecx + 0x228], eax */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3d28: mov edx, dword ptr [ebp - 0xc] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x830u)))) & 0xffffffffu;  /* 0x4a3d2b: movsx eax, word ptr [edx + 0x830] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3d32: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0x228u));  /* 0x4a3d35: mov edx, dword ptr [ecx + 0x228] */
    { uint32_t a_ = edx, b_ = eax, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a3d3b: add edx, eax */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3d3d: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0x230u), edx);  /* 0x4a3d40: mov dword ptr [eax + 0x230], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3d46: mov ecx, dword ptr [ebp - 0xc] */
    esp -= 4u; WR32(esp, 0x4a3d4eu); FL41_CALL(0x4a3aecu); esp += 4u;  /* 0x4a3d49: call 0x4a3aec */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3d4e: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0x22cu));  /* 0x4a3d51: mov edx, dword ptr [ecx + 0x22c] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a3d57: add edx, dword ptr [0x58318a] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3d5d: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0x24cu), edx);  /* 0x4a3d60: mov dword ptr [eax + 0x24c], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3d66: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0x234u));  /* 0x4a3d69: mov edx, dword ptr [ecx + 0x234] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a3d6f: add edx, dword ptr [0x58318a] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3d75: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0x254u), edx);  /* 0x4a3d78: mov dword ptr [eax + 0x254], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3d7e: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0x228u));  /* 0x4a3d81: mov edx, dword ptr [ecx + 0x228] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a3d87: add edx, dword ptr [0x583186] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3d8d: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0x248u), edx);  /* 0x4a3d90: mov dword ptr [eax + 0x248], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3d96: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0x230u));  /* 0x4a3d99: mov edx, dword ptr [ecx + 0x230] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a3d9f: add edx, dword ptr [0x583186] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3da5: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0x250u), edx);  /* 0x4a3da8: mov dword ptr [eax + 0x250], edx */
    goto L_4a3f3c;  /* 0x4a3dae: jmp 0x4a3f3c */
L_4a3db3:
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3db3: mov ecx, dword ptr [ebp - 0xc] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + 0x836u)))) & 0xffffffffu;  /* 0x4a3db6: movsx edx, word ptr [ecx + 0x836] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4a3dbd: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = eax, b_ = edx, r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4a3dc0: sub eax, edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3dc2: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ecx + 0x22cu), eax);  /* 0x4a3dc5: mov dword ptr [ecx + 0x22c], eax */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3dcb: mov edx, dword ptr [ebp - 0xc] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x832u)))) & 0xffffffffu;  /* 0x4a3dce: movsx eax, word ptr [edx + 0x832] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3dd5: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0x22cu));  /* 0x4a3dd8: mov edx, dword ptr [ecx + 0x22c] */
    { uint32_t a_ = edx, b_ = eax, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a3dde: add edx, eax */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3de0: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0x234u), edx);  /* 0x4a3de3: mov dword ptr [eax + 0x234], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3de9: mov ecx, dword ptr [ebp - 0xc] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + 0x834u)))) & 0xffffffffu;  /* 0x4a3dec: movsx edx, word ptr [ecx + 0x834] */
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4a3df3: mov eax, dword ptr [ebp - 8] */
    { uint32_t a_ = eax, b_ = edx, r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4a3df6: sub eax, edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3df8: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ecx + 0x228u), eax);  /* 0x4a3dfb: mov dword ptr [ecx + 0x228], eax */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3e01: mov edx, dword ptr [ebp - 0xc] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x830u)))) & 0xffffffffu;  /* 0x4a3e04: movsx eax, word ptr [edx + 0x830] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3e0b: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0x228u));  /* 0x4a3e0e: mov edx, dword ptr [ecx + 0x228] */
    { uint32_t a_ = edx, b_ = eax, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a3e14: add edx, eax */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3e16: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0x230u), edx);  /* 0x4a3e19: mov dword ptr [eax + 0x230], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3e1f: mov ecx, dword ptr [ebp - 0xc] */
    esp -= 4u; WR32(esp, 0x4a3e27u); FL41_CALL(0x4a3aecu); esp += 4u;  /* 0x4a3e22: call 0x4a3aec */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3e27: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3e2a: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0x22cu));  /* 0x4a3e2d: mov eax, dword ptr [edx + 0x22c] */
    WR32((uint32_t)(ecx + 0x21cu), eax);  /* 0x4a3e33: mov dword ptr [ecx + 0x21c], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3e39: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3e3c: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0x234u));  /* 0x4a3e3f: mov eax, dword ptr [edx + 0x234] */
    WR32((uint32_t)(ecx + 0x224u), eax);  /* 0x4a3e45: mov dword ptr [ecx + 0x224], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3e4b: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3e4e: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0x228u));  /* 0x4a3e51: mov eax, dword ptr [edx + 0x228] */
    WR32((uint32_t)(ecx + 0x218u), eax);  /* 0x4a3e57: mov dword ptr [ecx + 0x218], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3e5d: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3e60: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0x230u));  /* 0x4a3e63: mov eax, dword ptr [edx + 0x230] */
    WR32((uint32_t)(ecx + 0x220u), eax);  /* 0x4a3e69: mov dword ptr [ecx + 0x220], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3e6f: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0x22cu));  /* 0x4a3e72: mov edx, dword ptr [ecx + 0x22c] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a3e78: add edx, dword ptr [0x58318a] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3e7e: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0x24cu), edx);  /* 0x4a3e81: mov dword ptr [eax + 0x24c], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3e87: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0x234u));  /* 0x4a3e8a: mov edx, dword ptr [ecx + 0x234] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a3e90: add edx, dword ptr [0x58318a] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3e96: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0x254u), edx);  /* 0x4a3e99: mov dword ptr [eax + 0x254], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3e9f: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0x228u));  /* 0x4a3ea2: mov edx, dword ptr [ecx + 0x228] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a3ea8: add edx, dword ptr [0x583186] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3eae: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0x248u), edx);  /* 0x4a3eb1: mov dword ptr [eax + 0x248], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3eb7: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0x230u));  /* 0x4a3eba: mov edx, dword ptr [ecx + 0x230] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a3ec0: add edx, dword ptr [0x583186] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3ec6: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0x250u), edx);  /* 0x4a3ec9: mov dword ptr [eax + 0x250], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3ecf: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0x21cu));  /* 0x4a3ed2: mov edx, dword ptr [ecx + 0x21c] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a3ed8: add edx, dword ptr [0x58318a] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3ede: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0x23cu), edx);  /* 0x4a3ee1: mov dword ptr [eax + 0x23c], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3ee7: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0x224u));  /* 0x4a3eea: mov edx, dword ptr [ecx + 0x224] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a3ef0: add edx, dword ptr [0x58318a] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3ef6: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0x244u), edx);  /* 0x4a3ef9: mov dword ptr [eax + 0x244], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3eff: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0x218u));  /* 0x4a3f02: mov edx, dword ptr [ecx + 0x218] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a3f08: add edx, dword ptr [0x583186] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3f0e: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0x238u), edx);  /* 0x4a3f11: mov dword ptr [eax + 0x238], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3f17: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0x220u));  /* 0x4a3f1a: mov edx, dword ptr [ecx + 0x220] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a3f20: add edx, dword ptr [0x583186] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3f26: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0x240u), edx);  /* 0x4a3f29: mov dword ptr [eax + 0x240], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a3f2f: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ecx + 0x272u), 0x1u);  /* 0x4a3f32: mov dword ptr [ecx + 0x272], 1 */
L_4a3f3c:
    esp = ebp;  /* 0x4a3f3c: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4a3f3e: pop ebp */
    esp += 4u; goto done;  /* 0x4a3f3f: ret  */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4a8007 (853 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4a8007_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4a8007: push ebp */
    ebp = esp;  /* 0x4a8008: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0xcu, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4a800a: sub esp, 0xc */
    WR32((uint32_t)(ebp + 0xfffffff4u), ecx);  /* 0x4a800d: mov dword ptr [ebp - 0xc], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a8010: mov eax, dword ptr [ebp - 0xc] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a8013: mov ecx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(eax + 0xe8cu));  /* 0x4a8016: mov eax, dword ptr [eax + 0xe8c] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(ecx + 0xe84u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4a801c: sub eax, dword ptr [ecx + 0xe84] */
    edx = (eax & 0x80000000u) ? 0xffffffffu : 0u;  /* 0x4a8022: cdq  */
    { uint32_t a_ = eax, b_ = edx, r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4a8023: sub eax, edx */
    { uint32_t a_ = eax, n_ = 0x1u, r_; if (n_ != 0u) { FL41_SAR(r_, a_, n_, 32); eax = r_; } }  /* 0x4a8025: sar eax, 1 */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a8027: mov edx, dword ptr [ebp - 0xc] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(edx + 0xe84u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4a802a: add eax, dword ptr [edx + 0xe84] */
    WR32((uint32_t)(ebp + 0xfffffff8u), eax);  /* 0x4a8030: mov dword ptr [ebp - 8], eax */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a8033: mov eax, dword ptr [ebp - 0xc] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a8036: mov ecx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(eax + 0xe90u));  /* 0x4a8039: mov eax, dword ptr [eax + 0xe90] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(ecx + 0xe88u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4a803f: sub eax, dword ptr [ecx + 0xe88] */
    edx = (eax & 0x80000000u) ? 0xffffffffu : 0u;  /* 0x4a8045: cdq  */
    { uint32_t a_ = eax, b_ = edx, r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4a8046: sub eax, edx */
    { uint32_t a_ = eax, n_ = 0x1u, r_; if (n_ != 0u) { FL41_SAR(r_, a_, n_, 32); eax = r_; } }  /* 0x4a8048: sar eax, 1 */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a804a: mov edx, dword ptr [ebp - 0xc] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(edx + 0xe88u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4a804d: add eax, dword ptr [edx + 0xe88] */
    WR32((uint32_t)(ebp + 0xfffffffcu), eax);  /* 0x4a8053: mov dword ptr [ebp - 4], eax */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a8056: mov eax, dword ptr [ebp - 0xc] */
    { uint32_t a_ = RD32((uint32_t)(eax + 0xe76u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4a8059: cmp dword ptr [eax + 0xe76], 0 */
    if (zf) goto L_4a81cf;  /* 0x4a8060: je 0x4a81cf */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a8066: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a8069: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0xe2au));  /* 0x4a806c: mov eax, dword ptr [edx + 0xe2a] */
    WR32((uint32_t)(ecx + 0xe1au), eax);  /* 0x4a8072: mov dword ptr [ecx + 0xe1a], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a8078: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a807b: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0xe32u));  /* 0x4a807e: mov eax, dword ptr [edx + 0xe32] */
    WR32((uint32_t)(ecx + 0xe22u), eax);  /* 0x4a8084: mov dword ptr [ecx + 0xe22], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a808a: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a808d: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0xe26u));  /* 0x4a8090: mov eax, dword ptr [edx + 0xe26] */
    WR32((uint32_t)(ecx + 0xe16u), eax);  /* 0x4a8096: mov dword ptr [ecx + 0xe16], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a809c: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a809f: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0xe2eu));  /* 0x4a80a2: mov eax, dword ptr [edx + 0xe2e] */
    WR32((uint32_t)(ecx + 0xe1eu), eax);  /* 0x4a80a8: mov dword ptr [ecx + 0xe1e], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a80ae: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a80b1: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0xe4au));  /* 0x4a80b4: mov eax, dword ptr [edx + 0xe4a] */
    WR32((uint32_t)(ecx + 0xe3au), eax);  /* 0x4a80ba: mov dword ptr [ecx + 0xe3a], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a80c0: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a80c3: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0xe52u));  /* 0x4a80c6: mov eax, dword ptr [edx + 0xe52] */
    WR32((uint32_t)(ecx + 0xe42u), eax);  /* 0x4a80cc: mov dword ptr [ecx + 0xe42], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a80d2: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a80d5: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0xe46u));  /* 0x4a80d8: mov eax, dword ptr [edx + 0xe46] */
    WR32((uint32_t)(ecx + 0xe36u), eax);  /* 0x4a80de: mov dword ptr [ecx + 0xe36], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a80e4: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a80e7: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0xe4eu));  /* 0x4a80ea: mov eax, dword ptr [edx + 0xe4e] */
    WR32((uint32_t)(ecx + 0xe3eu), eax);  /* 0x4a80f0: mov dword ptr [ecx + 0xe3e], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a80f6: mov ecx, dword ptr [ebp - 0xc] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + 0x13aau)))) & 0xffffffffu;  /* 0x4a80f9: movsx edx, word ptr [ecx + 0x13aa] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4a8100: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = eax, b_ = edx, r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4a8103: sub eax, edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a8105: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ecx + 0xe2au), eax);  /* 0x4a8108: mov dword ptr [ecx + 0xe2a], eax */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a810e: mov edx, dword ptr [ebp - 0xc] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x13a6u)))) & 0xffffffffu;  /* 0x4a8111: movsx eax, word ptr [edx + 0x13a6] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a8118: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0xe2au));  /* 0x4a811b: mov edx, dword ptr [ecx + 0xe2a] */
    { uint32_t a_ = edx, b_ = eax, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a8121: add edx, eax */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a8123: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0xe32u), edx);  /* 0x4a8126: mov dword ptr [eax + 0xe32], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a812c: mov ecx, dword ptr [ebp - 0xc] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + 0x13a8u)))) & 0xffffffffu;  /* 0x4a812f: movsx edx, word ptr [ecx + 0x13a8] */
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4a8136: mov eax, dword ptr [ebp - 8] */
    { uint32_t a_ = eax, b_ = edx, r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4a8139: sub eax, edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a813b: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ecx + 0xe26u), eax);  /* 0x4a813e: mov dword ptr [ecx + 0xe26], eax */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a8144: mov edx, dword ptr [ebp - 0xc] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x13a4u)))) & 0xffffffffu;  /* 0x4a8147: movsx eax, word ptr [edx + 0x13a4] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a814e: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0xe26u));  /* 0x4a8151: mov edx, dword ptr [ecx + 0xe26] */
    { uint32_t a_ = edx, b_ = eax, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a8157: add edx, eax */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a8159: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0xe2eu), edx);  /* 0x4a815c: mov dword ptr [eax + 0xe2e], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a8162: mov ecx, dword ptr [ebp - 0xc] */
    esp -= 4u; WR32(esp, 0x4a816au); FL41_CALL(0x4a7f08u); esp += 4u;  /* 0x4a8165: call 0x4a7f08 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a816a: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0xe2au));  /* 0x4a816d: mov edx, dword ptr [ecx + 0xe2a] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a8173: add edx, dword ptr [0x58318a] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a8179: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0xe4au), edx);  /* 0x4a817c: mov dword ptr [eax + 0xe4a], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a8182: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0xe32u));  /* 0x4a8185: mov edx, dword ptr [ecx + 0xe32] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a818b: add edx, dword ptr [0x58318a] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a8191: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0xe52u), edx);  /* 0x4a8194: mov dword ptr [eax + 0xe52], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a819a: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0xe26u));  /* 0x4a819d: mov edx, dword ptr [ecx + 0xe26] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a81a3: add edx, dword ptr [0x583186] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a81a9: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0xe46u), edx);  /* 0x4a81ac: mov dword ptr [eax + 0xe46], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a81b2: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0xe2eu));  /* 0x4a81b5: mov edx, dword ptr [ecx + 0xe2e] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a81bb: add edx, dword ptr [0x583186] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a81c1: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0xe4eu), edx);  /* 0x4a81c4: mov dword ptr [eax + 0xe4e], edx */
    goto L_4a8358;  /* 0x4a81ca: jmp 0x4a8358 */
L_4a81cf:
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a81cf: mov ecx, dword ptr [ebp - 0xc] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + 0x13aau)))) & 0xffffffffu;  /* 0x4a81d2: movsx edx, word ptr [ecx + 0x13aa] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4a81d9: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = eax, b_ = edx, r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4a81dc: sub eax, edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a81de: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ecx + 0xe2au), eax);  /* 0x4a81e1: mov dword ptr [ecx + 0xe2a], eax */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a81e7: mov edx, dword ptr [ebp - 0xc] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x13a6u)))) & 0xffffffffu;  /* 0x4a81ea: movsx eax, word ptr [edx + 0x13a6] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a81f1: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0xe2au));  /* 0x4a81f4: mov edx, dword ptr [ecx + 0xe2a] */
    { uint32_t a_ = edx, b_ = eax, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a81fa: add edx, eax */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a81fc: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0xe32u), edx);  /* 0x4a81ff: mov dword ptr [eax + 0xe32], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a8205: mov ecx, dword ptr [ebp - 0xc] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + 0x13a8u)))) & 0xffffffffu;  /* 0x4a8208: movsx edx, word ptr [ecx + 0x13a8] */
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4a820f: mov eax, dword ptr [ebp - 8] */
    { uint32_t a_ = eax, b_ = edx, r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4a8212: sub eax, edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a8214: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ecx + 0xe26u), eax);  /* 0x4a8217: mov dword ptr [ecx + 0xe26], eax */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a821d: mov edx, dword ptr [ebp - 0xc] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x13a4u)))) & 0xffffffffu;  /* 0x4a8220: movsx eax, word ptr [edx + 0x13a4] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a8227: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0xe26u));  /* 0x4a822a: mov edx, dword ptr [ecx + 0xe26] */
    { uint32_t a_ = edx, b_ = eax, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a8230: add edx, eax */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a8232: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0xe2eu), edx);  /* 0x4a8235: mov dword ptr [eax + 0xe2e], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a823b: mov ecx, dword ptr [ebp - 0xc] */
    esp -= 4u; WR32(esp, 0x4a8243u); FL41_CALL(0x4a7f08u); esp += 4u;  /* 0x4a823e: call 0x4a7f08 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a8243: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a8246: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0xe2au));  /* 0x4a8249: mov eax, dword ptr [edx + 0xe2a] */
    WR32((uint32_t)(ecx + 0xe1au), eax);  /* 0x4a824f: mov dword ptr [ecx + 0xe1a], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a8255: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a8258: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0xe32u));  /* 0x4a825b: mov eax, dword ptr [edx + 0xe32] */
    WR32((uint32_t)(ecx + 0xe22u), eax);  /* 0x4a8261: mov dword ptr [ecx + 0xe22], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a8267: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a826a: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0xe26u));  /* 0x4a826d: mov eax, dword ptr [edx + 0xe26] */
    WR32((uint32_t)(ecx + 0xe16u), eax);  /* 0x4a8273: mov dword ptr [ecx + 0xe16], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a8279: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a827c: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0xe2eu));  /* 0x4a827f: mov eax, dword ptr [edx + 0xe2e] */
    WR32((uint32_t)(ecx + 0xe1eu), eax);  /* 0x4a8285: mov dword ptr [ecx + 0xe1e], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a828b: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0xe2au));  /* 0x4a828e: mov edx, dword ptr [ecx + 0xe2a] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a8294: add edx, dword ptr [0x58318a] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a829a: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0xe4au), edx);  /* 0x4a829d: mov dword ptr [eax + 0xe4a], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a82a3: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0xe32u));  /* 0x4a82a6: mov edx, dword ptr [ecx + 0xe32] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a82ac: add edx, dword ptr [0x58318a] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a82b2: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0xe52u), edx);  /* 0x4a82b5: mov dword ptr [eax + 0xe52], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a82bb: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0xe26u));  /* 0x4a82be: mov edx, dword ptr [ecx + 0xe26] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a82c4: add edx, dword ptr [0x583186] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a82ca: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0xe46u), edx);  /* 0x4a82cd: mov dword ptr [eax + 0xe46], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a82d3: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0xe2eu));  /* 0x4a82d6: mov edx, dword ptr [ecx + 0xe2e] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a82dc: add edx, dword ptr [0x583186] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a82e2: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0xe4eu), edx);  /* 0x4a82e5: mov dword ptr [eax + 0xe4e], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a82eb: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0xe1au));  /* 0x4a82ee: mov edx, dword ptr [ecx + 0xe1a] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a82f4: add edx, dword ptr [0x58318a] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a82fa: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0xe3au), edx);  /* 0x4a82fd: mov dword ptr [eax + 0xe3a], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a8303: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0xe22u));  /* 0x4a8306: mov edx, dword ptr [ecx + 0xe22] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a830c: add edx, dword ptr [0x58318a] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a8312: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0xe42u), edx);  /* 0x4a8315: mov dword ptr [eax + 0xe42], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a831b: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0xe16u));  /* 0x4a831e: mov edx, dword ptr [ecx + 0xe16] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a8324: add edx, dword ptr [0x583186] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a832a: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0xe36u), edx);  /* 0x4a832d: mov dword ptr [eax + 0xe36], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a8333: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0xe1eu));  /* 0x4a8336: mov edx, dword ptr [ecx + 0xe1e] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4a833c: add edx, dword ptr [0x583186] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a8342: mov eax, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(eax + 0xe3eu), edx);  /* 0x4a8345: mov dword ptr [eax + 0xe3e], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4a834b: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ecx + 0xe76u), 0x1u);  /* 0x4a834e: mov dword ptr [ecx + 0xe76], 1 */
L_4a8358:
    esp = ebp;  /* 0x4a8358: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4a835a: pop ebp */
    esp += 4u; goto done;  /* 0x4a835b: ret  */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4a9f63 (104 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4a9f63_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4a9f63: push ebp */
    ebp = esp;  /* 0x4a9f64: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0x8u, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4a9f66: sub esp, 8 */
    WR32((uint32_t)(ebp + 0xfffffff8u), ecx);  /* 0x4a9f69: mov dword ptr [ebp - 8], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4a9f6c: mov eax, dword ptr [ebp - 8] */
    { uint32_t a_ = RD32((uint32_t)(eax + 0x1du)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4a9f6f: cmp dword ptr [eax + 0x1d], 0 */
    if (zf) goto L_4a9f86;  /* 0x4a9f73: je 0x4a9f86 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4a9f75: mov ecx, dword ptr [ebp - 8] */
    { uint32_t a_ = ecx, b_ = 0x1du, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4a9f78: add ecx, 0x1d */
    esp -= 4u; WR32(esp, ecx);  /* 0x4a9f7b: push ecx */
    ecx = 0x5cf659u;  /* 0x4a9f7c: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4a9f86u); FL41_CALL(0x4c2dfbu); esp += 4u; esp += 4u;  /* 0x4a9f81: call 0x4c2dfb */
L_4a9f86:
    edx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4a9f86: mov edx, dword ptr [ebp - 8] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x29u)))) & 0xffffffffu;  /* 0x4a9f89: movsx eax, word ptr [edx + 0x29] */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4a9f8d: test eax, eax */
    if (!zf) goto L_4a9f98;  /* 0x4a9f8f: jne 0x4a9f98 */
    WR32((uint32_t)(ebp + 0xfffffffcu), 0x1u);  /* 0x4a9f91: mov dword ptr [ebp - 4], 1 */
L_4a9f98:
    ecx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4a9f98: mov ecx, dword ptr [ebp - 8] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + 0x29u)))) & 0xffffffffu;  /* 0x4a9f9b: movsx edx, word ptr [ecx + 0x29] */
    { uint32_t a_ = edx, b_ = 0xffffffffu, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4a9f9f: cmp edx, -1 */
    if (zf) goto L_4a9fbf;  /* 0x4a9fa2: je 0x4a9fbf */
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4a9fa4: mov eax, dword ptr [ebp - 8] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(eax + 0x29u)))) & 0xffffffffu;  /* 0x4a9fa7: movsx ecx, word ptr [eax + 0x29] */
    { uint32_t a_ = ecx, b_ = ecx, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4a9fab: test ecx, ecx */
    if (zf) goto L_4a9fbf;  /* 0x4a9fad: je 0x4a9fbf */
    edx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4a9faf: mov edx, dword ptr [ebp - 8] */
    eax = (eax & 0xffff0000u) | ((RD16((uint32_t)(edx + 0x29u))) & 0xffffu);  /* 0x4a9fb2: mov ax, word ptr [edx + 0x29] */
    esp -= 4u; WR32(esp, eax);  /* 0x4a9fb6: push eax */
    esp -= 4u; WR32(esp, 0x4a9fbcu); FL41_CALL(0x4d3992u); esp += 4u;  /* 0x4a9fb7: call 0x4d3992 */
    { uint32_t a_ = esp, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4a9fbc: add esp, 4 */
L_4a9fbf:
    ecx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4a9fbf: mov ecx, dword ptr [ebp - 8] */
    esp -= 4u; WR32(esp, 0x4a9fc7u); FL41_CALL(0x4a9f27u); esp += 4u;  /* 0x4a9fc2: call 0x4a9f27 */
    esp = ebp;  /* 0x4a9fc7: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4a9fc9: pop ebp */
    esp += 4u; goto done;  /* 0x4a9fca: ret  */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4accab (279 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4accab_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4accab: push ebp */
    ebp = esp;  /* 0x4accac: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0x10u, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4accae: sub esp, 0x10 */
    WR32((uint32_t)(ebp + 0xfffffff0u), ecx);  /* 0x4accb1: mov dword ptr [ebp - 0x10], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4accb4: mov eax, dword ptr [ebp - 0x10] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(eax + 0x24u)))) & 0xffffffffu;  /* 0x4accb7: movsx ecx, word ptr [eax + 0x24] */
    { int64_t w_ = (int64_t)(int32_t)(ecx) * (int32_t)(0xc7u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); ecx = r_; }  /* 0x4accbb: imul ecx, ecx, 0xc7 */
    edx = RD32((uint32_t)(ebp + 0xfffffff0u));  /* 0x4accc1: mov edx, dword ptr [ebp - 0x10] */
    eax = (uint32_t)(edx + ecx + 0x6eu);  /* 0x4accc4: lea eax, [edx + ecx + 0x6e] */
    WR32((uint32_t)(ebp + 0xfffffff4u), eax);  /* 0x4accc8: mov dword ptr [ebp - 0xc], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4acccb: mov ecx, dword ptr [ebp - 0xc] */
    { uint32_t a_ = ecx, b_ = 0x2u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4accce: add ecx, 2 */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4accd1: mov dword ptr [ebp - 4], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4accd4: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + 0x4u));  /* 0x4accd7: mov eax, dword ptr [edx + 4] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(0x58319au)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4accda: cmp eax, dword ptr [0x58319a] */
    if ((sf == of)) goto L_4acd11;  /* 0x4acce0: jge 0x4acd11 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4acce2: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(0x58319au));  /* 0x4acce5: mov edx, dword ptr [0x58319a] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(ecx + 0x4u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4acceb: sub edx, dword ptr [ecx + 4] */
    WR32((uint32_t)(ebp + 0xfffffff8u), edx);  /* 0x4accee: mov dword ptr [ebp - 8], edx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4accf1: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0x4u));  /* 0x4accf4: mov ecx, dword ptr [eax + 4] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(ebp + 0xfffffff8u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4accf7: add ecx, dword ptr [ebp - 8] */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4accfa: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0x4u), ecx);  /* 0x4accfd: mov dword ptr [edx + 4], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4acd00: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0xcu));  /* 0x4acd03: mov ecx, dword ptr [eax + 0xc] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(ebp + 0xfffffff8u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4acd06: add ecx, dword ptr [ebp - 8] */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4acd09: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0xcu), ecx);  /* 0x4acd0c: mov dword ptr [edx + 0xc], ecx */
    goto L_4acd4c;  /* 0x4acd0f: jmp 0x4acd4c */
L_4acd11:
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4acd11: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0xcu));  /* 0x4acd14: mov ecx, dword ptr [eax + 0xc] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(0x5831a2u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4acd17: cmp ecx, dword ptr [0x5831a2] */
    if ((zf || sf != of)) goto L_4acd4c;  /* 0x4acd1d: jle 0x4acd4c */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4acd1f: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + 0xcu));  /* 0x4acd22: mov eax, dword ptr [edx + 0xc] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(0x5831a2u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4acd25: sub eax, dword ptr [0x5831a2] */
    WR32((uint32_t)(ebp + 0xfffffff8u), eax);  /* 0x4acd2b: mov dword ptr [ebp - 8], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4acd2e: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ecx + 0x4u));  /* 0x4acd31: mov edx, dword ptr [ecx + 4] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(ebp + 0xfffffff8u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4acd34: sub edx, dword ptr [ebp - 8] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4acd37: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x4u), edx);  /* 0x4acd3a: mov dword ptr [eax + 4], edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4acd3d: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ecx + 0xcu));  /* 0x4acd40: mov edx, dword ptr [ecx + 0xc] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(ebp + 0xfffffff8u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4acd43: sub edx, dword ptr [ebp - 8] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4acd46: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0xcu), edx);  /* 0x4acd49: mov dword ptr [eax + 0xc], edx */
L_4acd4c:
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4acd4c: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ecx));  /* 0x4acd4f: mov edx, dword ptr [ecx] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(0x583196u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4acd51: cmp edx, dword ptr [0x583196] */
    if ((sf == of)) goto L_4acd85;  /* 0x4acd57: jge 0x4acd85 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4acd59: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(0x583196u));  /* 0x4acd5c: mov ecx, dword ptr [0x583196] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(eax)), r_; FL41_SUB(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4acd62: sub ecx, dword ptr [eax] */
    WR32((uint32_t)(ebp + 0xfffffff8u), ecx);  /* 0x4acd64: mov dword ptr [ebp - 8], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4acd67: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx));  /* 0x4acd6a: mov eax, dword ptr [edx] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(ebp + 0xfffffff8u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4acd6c: add eax, dword ptr [ebp - 8] */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4acd6f: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx), eax);  /* 0x4acd72: mov dword ptr [ecx], eax */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4acd74: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + 0x8u));  /* 0x4acd77: mov eax, dword ptr [edx + 8] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(ebp + 0xfffffff8u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4acd7a: add eax, dword ptr [ebp - 8] */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4acd7d: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x8u), eax);  /* 0x4acd80: mov dword ptr [ecx + 8], eax */
    goto L_4acdbe;  /* 0x4acd83: jmp 0x4acdbe */
L_4acd85:
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4acd85: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + 0x8u));  /* 0x4acd88: mov eax, dword ptr [edx + 8] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(0x58319eu)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4acd8b: cmp eax, dword ptr [0x58319e] */
    if ((zf || sf != of)) goto L_4acdbe;  /* 0x4acd91: jle 0x4acdbe */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4acd93: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ecx + 0x8u));  /* 0x4acd96: mov edx, dword ptr [ecx + 8] */
    { uint32_t a_ = edx, b_ = RD32((uint32_t)(0x58319eu)), r_; FL41_SUB(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4acd99: sub edx, dword ptr [0x58319e] */
    WR32((uint32_t)(ebp + 0xfffffff8u), edx);  /* 0x4acd9f: mov dword ptr [ebp - 8], edx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4acda2: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax));  /* 0x4acda5: mov ecx, dword ptr [eax] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(ebp + 0xfffffff8u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4acda7: sub ecx, dword ptr [ebp - 8] */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4acdaa: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx), ecx);  /* 0x4acdad: mov dword ptr [edx], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4acdaf: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0x8u));  /* 0x4acdb2: mov ecx, dword ptr [eax + 8] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(ebp + 0xfffffff8u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4acdb5: sub ecx, dword ptr [ebp - 8] */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4acdb8: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0x8u), ecx);  /* 0x4acdbb: mov dword ptr [edx + 8], ecx */
L_4acdbe:
    esp = ebp;  /* 0x4acdbe: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4acdc0: pop ebp */
    esp += 4u; goto done;  /* 0x4acdc1: ret  */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4b3f98 (827 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4b3f98_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4b3f98: push ebp */
    ebp = esp;  /* 0x4b3f99: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0xcu, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4b3f9b: sub esp, 0xc */
    WR32((uint32_t)(ebp + 0xfffffff4u), ecx);  /* 0x4b3f9e: mov dword ptr [ebp - 0xc], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b3fa1: mov eax, dword ptr [ebp - 0xc] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(eax + 0x750u)))) & 0xffffffffu;  /* 0x4b3fa4: movsx ecx, word ptr [eax + 0x750] */
    { uint32_t a_ = ecx, b_ = ecx, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4b3fab: test ecx, ecx */
    if (!zf) goto L_4b3fb4;  /* 0x4b3fad: jne 0x4b3fb4 */
    goto L_4b42cf;  /* 0x4b3faf: jmp 0x4b42cf */
L_4b3fb4:
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b3fb4: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0x75eu));  /* 0x4b3fb7: mov eax, dword ptr [edx + 0x75e] */
    WR32((uint32_t)(ebp + 0xfffffff8u), eax);  /* 0x4b3fbd: mov dword ptr [ebp - 8], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b3fc0: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0x762u));  /* 0x4b3fc3: mov edx, dword ptr [ecx + 0x762] */
    WR32((uint32_t)(ebp + 0xfffffffcu), edx);  /* 0x4b3fc9: mov dword ptr [ebp - 4], edx */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b3fcc: mov eax, dword ptr [ebp - 0xc] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(eax + 0x752u)))) & 0xffffffffu;  /* 0x4b3fcf: movsx ecx, word ptr [eax + 0x752] */
    { uint32_t a_ = ecx, b_ = ecx, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4b3fd6: test ecx, ecx */
    if (zf) goto L_4b4147;  /* 0x4b3fd8: je 0x4b4147 */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b3fde: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b3fe1: mov eax, dword ptr [ebp - 0xc] */
    ecx = RD32((uint32_t)(eax + 0x6e0u));  /* 0x4b3fe4: mov ecx, dword ptr [eax + 0x6e0] */
    WR32((uint32_t)(edx + 0x6f0u), ecx);  /* 0x4b3fea: mov dword ptr [edx + 0x6f0], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b3ff0: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b3ff3: mov eax, dword ptr [ebp - 0xc] */
    ecx = RD32((uint32_t)(eax + 0x6e8u));  /* 0x4b3ff6: mov ecx, dword ptr [eax + 0x6e8] */
    WR32((uint32_t)(edx + 0x6f8u), ecx);  /* 0x4b3ffc: mov dword ptr [edx + 0x6f8], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4002: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4005: mov eax, dword ptr [ebp - 0xc] */
    ecx = RD32((uint32_t)(eax + 0x6dcu));  /* 0x4b4008: mov ecx, dword ptr [eax + 0x6dc] */
    WR32((uint32_t)(edx + 0x6ecu), ecx);  /* 0x4b400e: mov dword ptr [edx + 0x6ec], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4014: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4017: mov eax, dword ptr [ebp - 0xc] */
    ecx = RD32((uint32_t)(eax + 0x6e4u));  /* 0x4b401a: mov ecx, dword ptr [eax + 0x6e4] */
    WR32((uint32_t)(edx + 0x6f4u), ecx);  /* 0x4b4020: mov dword ptr [edx + 0x6f4], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4026: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4029: mov eax, dword ptr [ebp - 0xc] */
    ecx = RD32((uint32_t)(eax + 0x700u));  /* 0x4b402c: mov ecx, dword ptr [eax + 0x700] */
    WR32((uint32_t)(edx + 0x710u), ecx);  /* 0x4b4032: mov dword ptr [edx + 0x710], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4038: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b403b: mov eax, dword ptr [ebp - 0xc] */
    ecx = RD32((uint32_t)(eax + 0x708u));  /* 0x4b403e: mov ecx, dword ptr [eax + 0x708] */
    WR32((uint32_t)(edx + 0x718u), ecx);  /* 0x4b4044: mov dword ptr [edx + 0x718], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b404a: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b404d: mov eax, dword ptr [ebp - 0xc] */
    ecx = RD32((uint32_t)(eax + 0x6fcu));  /* 0x4b4050: mov ecx, dword ptr [eax + 0x6fc] */
    WR32((uint32_t)(edx + 0x70cu), ecx);  /* 0x4b4056: mov dword ptr [edx + 0x70c], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b405c: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b405f: mov eax, dword ptr [ebp - 0xc] */
    ecx = RD32((uint32_t)(eax + 0x704u));  /* 0x4b4062: mov ecx, dword ptr [eax + 0x704] */
    WR32((uint32_t)(edx + 0x714u), ecx);  /* 0x4b4068: mov dword ptr [edx + 0x714], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b406e: mov edx, dword ptr [ebp - 0xc] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x724u)))) & 0xffffffffu;  /* 0x4b4071: movsx eax, word ptr [edx + 0x724] */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4b4078: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = eax, r_; FL41_SUB(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4b407b: sub ecx, eax */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b407d: mov edx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(edx + 0x6e0u), ecx);  /* 0x4b4080: mov dword ptr [edx + 0x6e0], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4086: mov eax, dword ptr [ebp - 0xc] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(eax + 0x722u)))) & 0xffffffffu;  /* 0x4b4089: movsx ecx, word ptr [eax + 0x722] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4090: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0x6e0u));  /* 0x4b4093: mov eax, dword ptr [edx + 0x6e0] */
    { uint32_t a_ = eax, b_ = ecx, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4b4099: add eax, ecx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b409b: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ecx + 0x6e8u), eax);  /* 0x4b409e: mov dword ptr [ecx + 0x6e8], eax */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b40a4: mov edx, dword ptr [ebp - 0xc] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x720u)))) & 0xffffffffu;  /* 0x4b40a7: movsx eax, word ptr [edx + 0x720] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4b40ae: mov ecx, dword ptr [ebp - 8] */
    { uint32_t a_ = ecx, b_ = eax, r_; FL41_SUB(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4b40b1: sub ecx, eax */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b40b3: mov edx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(edx + 0x6dcu), ecx);  /* 0x4b40b6: mov dword ptr [edx + 0x6dc], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b40bc: mov eax, dword ptr [ebp - 0xc] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(eax + 0x71eu)))) & 0xffffffffu;  /* 0x4b40bf: movsx ecx, word ptr [eax + 0x71e] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b40c6: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0x6dcu));  /* 0x4b40c9: mov eax, dword ptr [edx + 0x6dc] */
    { uint32_t a_ = eax, b_ = ecx, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4b40cf: add eax, ecx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b40d1: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ecx + 0x6e4u), eax);  /* 0x4b40d4: mov dword ptr [ecx + 0x6e4], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b40da: mov ecx, dword ptr [ebp - 0xc] */
    esp -= 4u; WR32(esp, 0x4b40e2u); FL41_CALL(0x4b3e99u); esp += 4u;  /* 0x4b40dd: call 0x4b3e99 */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b40e2: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0x6e0u));  /* 0x4b40e5: mov eax, dword ptr [edx + 0x6e0] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4b40eb: add eax, dword ptr [0x58318a] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b40f1: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ecx + 0x700u), eax);  /* 0x4b40f4: mov dword ptr [ecx + 0x700], eax */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b40fa: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0x6e8u));  /* 0x4b40fd: mov eax, dword ptr [edx + 0x6e8] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4b4103: add eax, dword ptr [0x58318a] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4109: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ecx + 0x708u), eax);  /* 0x4b410c: mov dword ptr [ecx + 0x708], eax */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4112: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0x6dcu));  /* 0x4b4115: mov eax, dword ptr [edx + 0x6dc] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4b411b: add eax, dword ptr [0x583186] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4121: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ecx + 0x6fcu), eax);  /* 0x4b4124: mov dword ptr [ecx + 0x6fc], eax */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b412a: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0x6e4u));  /* 0x4b412d: mov eax, dword ptr [edx + 0x6e4] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4b4133: add eax, dword ptr [0x583186] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4139: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ecx + 0x704u), eax);  /* 0x4b413c: mov dword ptr [ecx + 0x704], eax */
    goto L_4b42cf;  /* 0x4b4142: jmp 0x4b42cf */
L_4b4147:
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4147: mov edx, dword ptr [ebp - 0xc] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x724u)))) & 0xffffffffu;  /* 0x4b414a: movsx eax, word ptr [edx + 0x724] */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4b4151: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = eax, r_; FL41_SUB(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4b4154: sub ecx, eax */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4156: mov edx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(edx + 0x6e0u), ecx);  /* 0x4b4159: mov dword ptr [edx + 0x6e0], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b415f: mov eax, dword ptr [ebp - 0xc] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(eax + 0x722u)))) & 0xffffffffu;  /* 0x4b4162: movsx ecx, word ptr [eax + 0x722] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4169: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0x6e0u));  /* 0x4b416c: mov eax, dword ptr [edx + 0x6e0] */
    { uint32_t a_ = eax, b_ = ecx, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4b4172: add eax, ecx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4174: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ecx + 0x6e8u), eax);  /* 0x4b4177: mov dword ptr [ecx + 0x6e8], eax */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b417d: mov edx, dword ptr [ebp - 0xc] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x720u)))) & 0xffffffffu;  /* 0x4b4180: movsx eax, word ptr [edx + 0x720] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4b4187: mov ecx, dword ptr [ebp - 8] */
    { uint32_t a_ = ecx, b_ = eax, r_; FL41_SUB(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4b418a: sub ecx, eax */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b418c: mov edx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(edx + 0x6dcu), ecx);  /* 0x4b418f: mov dword ptr [edx + 0x6dc], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4195: mov eax, dword ptr [ebp - 0xc] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(eax + 0x71eu)))) & 0xffffffffu;  /* 0x4b4198: movsx ecx, word ptr [eax + 0x71e] */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b419f: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0x6dcu));  /* 0x4b41a2: mov eax, dword ptr [edx + 0x6dc] */
    { uint32_t a_ = eax, b_ = ecx, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4b41a8: add eax, ecx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b41aa: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ecx + 0x6e4u), eax);  /* 0x4b41ad: mov dword ptr [ecx + 0x6e4], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b41b3: mov ecx, dword ptr [ebp - 0xc] */
    esp -= 4u; WR32(esp, 0x4b41bbu); FL41_CALL(0x4b3e99u); esp += 4u;  /* 0x4b41b6: call 0x4b3e99 */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b41bb: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b41be: mov eax, dword ptr [ebp - 0xc] */
    ecx = RD32((uint32_t)(eax + 0x6e0u));  /* 0x4b41c1: mov ecx, dword ptr [eax + 0x6e0] */
    WR32((uint32_t)(edx + 0x6f0u), ecx);  /* 0x4b41c7: mov dword ptr [edx + 0x6f0], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b41cd: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b41d0: mov eax, dword ptr [ebp - 0xc] */
    ecx = RD32((uint32_t)(eax + 0x6e8u));  /* 0x4b41d3: mov ecx, dword ptr [eax + 0x6e8] */
    WR32((uint32_t)(edx + 0x6f8u), ecx);  /* 0x4b41d9: mov dword ptr [edx + 0x6f8], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b41df: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b41e2: mov eax, dword ptr [ebp - 0xc] */
    ecx = RD32((uint32_t)(eax + 0x6dcu));  /* 0x4b41e5: mov ecx, dword ptr [eax + 0x6dc] */
    WR32((uint32_t)(edx + 0x6ecu), ecx);  /* 0x4b41eb: mov dword ptr [edx + 0x6ec], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b41f1: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b41f4: mov eax, dword ptr [ebp - 0xc] */
    ecx = RD32((uint32_t)(eax + 0x6e4u));  /* 0x4b41f7: mov ecx, dword ptr [eax + 0x6e4] */
    WR32((uint32_t)(edx + 0x6f4u), ecx);  /* 0x4b41fd: mov dword ptr [edx + 0x6f4], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4203: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0x6e0u));  /* 0x4b4206: mov eax, dword ptr [edx + 0x6e0] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4b420c: add eax, dword ptr [0x58318a] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4212: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ecx + 0x700u), eax);  /* 0x4b4215: mov dword ptr [ecx + 0x700], eax */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b421b: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0x6e8u));  /* 0x4b421e: mov eax, dword ptr [edx + 0x6e8] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4b4224: add eax, dword ptr [0x58318a] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b422a: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ecx + 0x708u), eax);  /* 0x4b422d: mov dword ptr [ecx + 0x708], eax */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4233: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0x6dcu));  /* 0x4b4236: mov eax, dword ptr [edx + 0x6dc] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4b423c: add eax, dword ptr [0x583186] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4242: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ecx + 0x6fcu), eax);  /* 0x4b4245: mov dword ptr [ecx + 0x6fc], eax */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b424b: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0x6e4u));  /* 0x4b424e: mov eax, dword ptr [edx + 0x6e4] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4b4254: add eax, dword ptr [0x583186] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b425a: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ecx + 0x704u), eax);  /* 0x4b425d: mov dword ptr [ecx + 0x704], eax */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4263: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0x6f0u));  /* 0x4b4266: mov eax, dword ptr [edx + 0x6f0] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4b426c: add eax, dword ptr [0x58318a] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4272: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ecx + 0x710u), eax);  /* 0x4b4275: mov dword ptr [ecx + 0x710], eax */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b427b: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0x6f8u));  /* 0x4b427e: mov eax, dword ptr [edx + 0x6f8] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4b4284: add eax, dword ptr [0x58318a] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b428a: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ecx + 0x718u), eax);  /* 0x4b428d: mov dword ptr [ecx + 0x718], eax */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4293: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0x6ecu));  /* 0x4b4296: mov eax, dword ptr [edx + 0x6ec] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4b429c: add eax, dword ptr [0x583186] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b42a2: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ecx + 0x70cu), eax);  /* 0x4b42a5: mov dword ptr [ecx + 0x70c], eax */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b42ab: mov edx, dword ptr [ebp - 0xc] */
    eax = RD32((uint32_t)(edx + 0x6f4u));  /* 0x4b42ae: mov eax, dword ptr [edx + 0x6f4] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4b42b4: add eax, dword ptr [0x583186] */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b42ba: mov ecx, dword ptr [ebp - 0xc] */
    WR32((uint32_t)(ecx + 0x714u), eax);  /* 0x4b42bd: mov dword ptr [ecx + 0x714], eax */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b42c3: mov edx, dword ptr [ebp - 0xc] */
    WR16((uint32_t)(edx + 0x752u), 0x1u);  /* 0x4b42c6: mov word ptr [edx + 0x752], 1 */
L_4b42cf:
    esp = ebp;  /* 0x4b42cf: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4b42d1: pop ebp */
    esp += 4u; goto done;  /* 0x4b42d2: ret  */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4b4913 (193 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4b4913_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4b4913: push ebp */
    ebp = esp;  /* 0x4b4914: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0xcu, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4b4916: sub esp, 0xc */
    WR32((uint32_t)(ebp + 0xfffffff4u), ecx);  /* 0x4b4919: mov dword ptr [ebp - 0xc], ecx */
    WR16((uint32_t)(ebp + 0xfffffffcu), 0x0u);  /* 0x4b491c: mov word ptr [ebp - 4], 0 */
    goto L_4b4930;  /* 0x4b4922: jmp 0x4b4930 */
L_4b4924:
    eax = (eax & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0xfffffffcu))) & 0xffffu);  /* 0x4b4924: mov ax, word ptr [ebp - 4] */
    { uint32_t a_ = (eax & 0xffffu), b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 16); eax = (eax & 0xffff0000u) | ((r_) & 0xffffu); }  /* 0x4b4928: add ax, 1 */
    WR16((uint32_t)(ebp + 0xfffffffcu), (eax & 0xffffu));  /* 0x4b492c: mov word ptr [ebp - 4], ax */
L_4b4930:
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4b4930: movsx ecx, word ptr [ebp - 4] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x591a22u)))) & 0xffffffffu;  /* 0x4b4934: movsx edx, word ptr [0x591a22] */
    { uint32_t a_ = ecx, b_ = edx, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4b493b: cmp ecx, edx */
    if ((sf == of)) goto L_4b49ce;  /* 0x4b493d: jge 0x4b49ce */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xcu)))) & 0xffffffffu;  /* 0x4b4943: movsx eax, word ptr [ebp + 0xc] */
    { int64_t w_ = (int64_t)(int32_t)(eax) * (int32_t)(0xcu); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); eax = r_; }  /* 0x4b4947: imul eax, eax, 0xc */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4b494a: movsx ecx, word ptr [ebp - 4] */
    edx = (edx & 0xffff0000u) | ((RD16((uint32_t)(eax + ecx * 2u + 0x5919feu))) & 0xffffu);  /* 0x4b494e: mov dx, word ptr [eax + ecx*2 + 0x5919fe] */
    WR16((uint32_t)(ebp + 0xfffffff8u), (edx & 0xffffu));  /* 0x4b4956: mov word ptr [ebp - 8], dx */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffff8u)))) & 0xffffffffu;  /* 0x4b495a: movsx eax, word ptr [ebp - 8] */
    { uint32_t a_ = eax, b_ = 0xffffffffu, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4b495e: cmp eax, -1 */
    if (!zf) goto L_4b49c9;  /* 0x4b4961: jne 0x4b49c9 */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b4963: mov ecx, dword ptr [ebp - 0xc] */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ecx + 0x728u)))) & 0xffffffffu;  /* 0x4b4966: movsx edx, word ptr [ecx + 0x728] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x8du); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4b496d: imul edx, edx, 0x8d */
    eax = RD32((uint32_t)(edx + 0x5bb5e5u));  /* 0x4b4973: mov eax, dword ptr [edx + 0x5bb5e5] */
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(eax + 0x82bu))) & 0xffffu);  /* 0x4b4979: mov cx, word ptr [eax + 0x82b] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4b4980: push ecx */
    ecx = 0x5c3a67u;  /* 0x4b4981: mov ecx, 0x5c3a67 */
    esp -= 4u; WR32(esp, 0x4b498bu); FL41_CALL(0x4fb2e3u); esp += 4u; esp += 4u;  /* 0x4b4986: call 0x4fb2e3 */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xcu)))) & 0xffffffffu;  /* 0x4b498b: movsx edx, word ptr [ebp + 0xc] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0xcu); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4b498f: imul edx, edx, 0xc */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(ebp + 0xfffffffcu)))) & 0xffffffffu;  /* 0x4b4992: movsx eax, word ptr [ebp - 4] */
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0x8u))) & 0xffffu);  /* 0x4b4996: mov cx, word ptr [ebp + 8] */
    WR16((uint32_t)(edx + eax * 2u + 0x5919feu), (ecx & 0xffffu));  /* 0x4b499a: mov word ptr [edx + eax*2 + 0x5919fe], cx */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b49a2: mov edx, dword ptr [ebp - 0xc] */
    WR16((uint32_t)(edx + 0x74eu), 0x1u);  /* 0x4b49a5: mov word ptr [edx + 0x74e], 1 */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b49ae: mov eax, dword ptr [ebp - 0xc] */
    WR16((uint32_t)(eax + 0x750u), 0x0u);  /* 0x4b49b1: mov word ptr [eax + 0x750], 0 */
    ecx = (ecx & 0xffff0000u) | ((RD16((uint32_t)(ebp + 0xcu))) & 0xffffu);  /* 0x4b49ba: mov cx, word ptr [ebp + 0xc] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4b49be: push ecx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4b49bf: mov ecx, dword ptr [ebp - 0xc] */
    esp -= 4u; WR32(esp, 0x4b49c7u); FL41_CALL(0x4b49d4u); esp += 4u; esp += 4u;  /* 0x4b49c2: call 0x4b49d4 */
    goto L_4b49ce;  /* 0x4b49c7: jmp 0x4b49ce */
L_4b49c9:
    goto L_4b4924;  /* 0x4b49c9: jmp 0x4b4924 */
L_4b49ce:
    esp = ebp;  /* 0x4b49ce: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4b49d0: pop ebp */
    esp += 12u; goto done;  /* 0x4b49d1: ret 8 */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4be18b (82 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4be18b_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4be18b: push ebp */
    ebp = esp;  /* 0x4be18c: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0xcu, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4be18e: sub esp, 0xc */
    WR32((uint32_t)(ebp + 0xfffffff4u), ecx);  /* 0x4be191: mov dword ptr [ebp - 0xc], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4be194: mov eax, dword ptr [ebp - 0xc] */
    { uint32_t a_ = RD32((uint32_t)(eax + 0x4cu)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4be197: cmp dword ptr [eax + 0x4c], 0 */
    if (zf) goto L_4be1cc;  /* 0x4be19b: je 0x4be1cc */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4be19d: mov ecx, dword ptr [ebp - 0xc] */
    edx = RD32((uint32_t)(ecx + 0x4cu));  /* 0x4be1a0: mov edx, dword ptr [ecx + 0x4c] */
    WR32((uint32_t)(ebp + 0xfffffffcu), edx);  /* 0x4be1a3: mov dword ptr [ebp - 4], edx */
L_4be1a6:
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xfffffffcu)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4be1a6: cmp dword ptr [ebp - 4], 0 */
    if (zf) goto L_4be1cc;  /* 0x4be1aa: je 0x4be1cc */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4be1ac: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0x150u));  /* 0x4be1af: mov ecx, dword ptr [eax + 0x150] */
    WR32((uint32_t)(ebp + 0xfffffff8u), ecx);  /* 0x4be1b5: mov dword ptr [ebp - 8], ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4be1b8: mov edx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, edx);  /* 0x4be1bb: push edx */
    ecx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4be1bc: mov ecx, dword ptr [ebp - 0xc] */
    esp -= 4u; WR32(esp, 0x4be1c4u); FL41_CALL(0x4be2c6u); esp += 4u; esp += 4u;  /* 0x4be1bf: call 0x4be2c6 */
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4be1c4: mov eax, dword ptr [ebp - 8] */
    WR32((uint32_t)(ebp + 0xfffffffcu), eax);  /* 0x4be1c7: mov dword ptr [ebp - 4], eax */
    goto L_4be1a6;  /* 0x4be1ca: jmp 0x4be1a6 */
L_4be1cc:
    { uint32_t a_ = ecx, b_ = ecx, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); ecx = r_; }  /* 0x4be1cc: xor ecx, ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffff4u));  /* 0x4be1ce: mov edx, dword ptr [ebp - 0xc] */
    { uint32_t a_ = edx, b_ = 0x4cu, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4be1d1: add edx, 0x4c */
    WR32((uint32_t)(edx), ecx);  /* 0x4be1d4: mov dword ptr [edx], ecx */
    WR32((uint32_t)(edx + 0x4u), ecx);  /* 0x4be1d6: mov dword ptr [edx + 4], ecx */
    esp = ebp;  /* 0x4be1d9: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4be1db: pop ebp */
    esp += 4u; goto done;  /* 0x4be1dc: ret  */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4d3fa9 (85 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4d3fa9_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4d3fa9: push ebp */
    ebp = esp;  /* 0x4d3faa: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0x8u, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4d3fac: sub esp, 8 */
    WR32((uint32_t)(ebp + 0xfffffff8u), ecx);  /* 0x4d3faf: mov dword ptr [ebp - 8], ecx */
    esp -= 4u; WR32(esp, 0x4d3fb8u);  /* call [KERNEL32.dll!GetTickCount] */ FL41_CALL(0x52a23cu); esp += 4u;  /* 0x4d3fb2: call dword ptr [0x52a23c] */
    WR32((uint32_t)(ebp + 0xfffffffcu), eax);  /* 0x4d3fb8: mov dword ptr [ebp - 4], eax */
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4d3fbb: mov eax, dword ptr [ebp - 8] */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d3fbe: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(eax + 0x456u)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4d3fc1: cmp ecx, dword ptr [eax + 0x456] */
    if ((cf || zf)) goto L_4d3ffa;  /* 0x4d3fc7: jbe 0x4d3ffa */
    edx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4d3fc9: mov edx, dword ptr [ebp - 8] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x324u)))) & 0xffffffffu;  /* 0x4d3fcc: movsx eax, word ptr [edx + 0x324] */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d3fd3: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = eax, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4d3fd6: add ecx, eax */
    edx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4d3fd8: mov edx, dword ptr [ebp - 8] */
    WR32((uint32_t)(edx + 0x452u), ecx);  /* 0x4d3fdb: mov dword ptr [edx + 0x452], ecx */
    esp -= 4u; WR32(esp, 0x14u);  /* 0x4d3fe1: push 0x14 */
    ecx = 0x5c3a67u;  /* 0x4d3fe3: mov ecx, 0x5c3a67 */
    esp -= 4u; WR32(esp, 0x4d3fedu); FL41_CALL(0x4fb2e3u); esp += 4u; esp += 4u;  /* 0x4d3fe8: call 0x4fb2e3 */
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4d3fed: mov eax, dword ptr [ebp - 8] */
    WR32((uint32_t)(eax + 0x462u), 0x1u);  /* 0x4d3ff0: mov dword ptr [eax + 0x462], 1 */
L_4d3ffa:
    esp = ebp;  /* 0x4d3ffa: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4d3ffc: pop ebp */
    esp += 4u; goto done;  /* 0x4d3ffd: ret  */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4d5661 (129 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4d5661_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4d5661: push ebp */
    ebp = esp;  /* 0x4d5662: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0xcu, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4d5664: sub esp, 0xc */
    esp -= 4u; WR32(esp, esi);  /* 0x4d5667: push esi */
    WR32((uint32_t)(ebp + 0xfffffff4u), ecx);  /* 0x4d5668: mov dword ptr [ebp - 0xc], ecx */
    eax = RD32((uint32_t)(ebp + 0xcu));  /* 0x4d566b: mov eax, dword ptr [ebp + 0xc] */
    ecx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4d566e: mov ecx, dword ptr [ebp + 8] */
    edx = RD32((uint32_t)(ebp + 0x10u));  /* 0x4d5671: mov edx, dword ptr [ebp + 0x10] */
    WR32((uint32_t)(ecx + eax * 4u), edx);  /* 0x4d5674: mov dword ptr [ecx + eax*4], edx */
    eax = RD32((uint32_t)(ebp + 0xcu));  /* 0x4d5677: mov eax, dword ptr [ebp + 0xc] */
    WR32((uint32_t)(ebp + 0xfffffffcu), eax);  /* 0x4d567a: mov dword ptr [ebp - 4], eax */
    goto L_4d5688;  /* 0x4d567d: jmp 0x4d5688 */
L_4d567f:
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d567f: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = 0x1u, r_; FL41_SUB(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4d5682: sub ecx, 1 */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4d5685: mov dword ptr [ebp - 4], ecx */
L_4d5688:
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xfffffffcu)), b_ = 0x1u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4d5688: cmp dword ptr [ebp - 4], 1 */
    if ((sf != of)) goto L_4d56db;  /* 0x4d568c: jl 0x4d56db */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d568e: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4d5691: mov eax, dword ptr [ebp + 8] */
    ecx = RD32((uint32_t)(eax + edx * 4u));  /* 0x4d5694: mov ecx, dword ptr [eax + edx*4] */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d5697: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4d569a: mov eax, dword ptr [ebp + 8] */
    edx = RD32((uint32_t)(eax + edx * 4u + 0xfffffffcu));  /* 0x4d569d: mov edx, dword ptr [eax + edx*4 - 4] */
    eax = RD32((uint32_t)(ecx + 0xcu));  /* 0x4d56a1: mov eax, dword ptr [ecx + 0xc] */
    { uint32_t a_ = eax, b_ = RD32((uint32_t)(edx + 0xcu)), r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4d56a4: cmp eax, dword ptr [edx + 0xc] */
    if ((sf == of)) goto L_4d56d7;  /* 0x4d56a7: jge 0x4d56d7 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d56a9: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4d56ac: mov edx, dword ptr [ebp + 8] */
    eax = RD32((uint32_t)(edx + ecx * 4u + 0xfffffffcu));  /* 0x4d56af: mov eax, dword ptr [edx + ecx*4 - 4] */
    WR32((uint32_t)(ebp + 0xfffffff8u), eax);  /* 0x4d56b3: mov dword ptr [ebp - 8], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d56b6: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4d56b9: mov edx, dword ptr [ebp + 8] */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d56bc: mov eax, dword ptr [ebp - 4] */
    esi = RD32((uint32_t)(ebp + 0x8u));  /* 0x4d56bf: mov esi, dword ptr [ebp + 8] */
    eax = RD32((uint32_t)(esi + eax * 4u));  /* 0x4d56c2: mov eax, dword ptr [esi + eax*4] */
    WR32((uint32_t)(edx + ecx * 4u + 0xfffffffcu), eax);  /* 0x4d56c5: mov dword ptr [edx + ecx*4 - 4], eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d56c9: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4d56cc: mov edx, dword ptr [ebp + 8] */
    eax = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4d56cf: mov eax, dword ptr [ebp - 8] */
    WR32((uint32_t)(edx + ecx * 4u), eax);  /* 0x4d56d2: mov dword ptr [edx + ecx*4], eax */
    goto L_4d56d9;  /* 0x4d56d5: jmp 0x4d56d9 */
L_4d56d7:
    goto L_4d56db;  /* 0x4d56d7: jmp 0x4d56db */
L_4d56d9:
    goto L_4d567f;  /* 0x4d56d9: jmp 0x4d567f */
L_4d56db:
    esi = RD32(esp); esp += 4u;  /* 0x4d56db: pop esi */
    esp = ebp;  /* 0x4d56dc: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4d56de: pop ebp */
    esp += 16u; goto done;  /* 0x4d56df: ret 0xc */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4db29b (220 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4db29b_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4db29b: push ebp */
    ebp = esp;  /* 0x4db29c: mov ebp, esp */
    esp -= 4u; WR32(esp, ecx);  /* 0x4db29e: push ecx */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4db29f: mov dword ptr [ebp - 4], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4db2a2: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x4u), 0x0u);  /* 0x4db2a5: mov dword ptr [eax + 4], 0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4db2ac: mov ecx, dword ptr [ebp - 4] */
    WR32((uint32_t)(ecx + 0x8u), 0x0u);  /* 0x4db2af: mov dword ptr [ecx + 8], 0 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4db2b6: mov edx, dword ptr [ebp - 4] */
    WR32((uint32_t)(edx + 0xcu), 0x0u);  /* 0x4db2b9: mov dword ptr [edx + 0xc], 0 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4db2c0: mov eax, dword ptr [ebp - 4] */
    WR32((uint32_t)(eax + 0x10u), 0x0u);  /* 0x4db2c3: mov dword ptr [eax + 0x10], 0 */
    { uint32_t a_ = ecx, b_ = ecx, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); ecx = r_; }  /* 0x4db2ca: xor ecx, ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4db2cc: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = edx, b_ = 0x14u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4db2cf: add edx, 0x14 */
    WR32((uint32_t)(edx), ecx);  /* 0x4db2d2: mov dword ptr [edx], ecx */
    WR32((uint32_t)(edx + 0x4u), ecx);  /* 0x4db2d4: mov dword ptr [edx + 4], ecx */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x4db2d7: xor eax, eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4db2d9: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = 0x1cu, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4db2dc: add ecx, 0x1c */
    WR32((uint32_t)(ecx), eax);  /* 0x4db2df: mov dword ptr [ecx], eax */
    WR32((uint32_t)(ecx + 0x4u), eax);  /* 0x4db2e1: mov dword ptr [ecx + 4], eax */
    { uint32_t a_ = edx, b_ = edx, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); edx = r_; }  /* 0x4db2e4: xor edx, edx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4db2e6: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = eax, b_ = 0x64u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4db2e9: add eax, 0x64 */
    WR32((uint32_t)(eax), edx);  /* 0x4db2ec: mov dword ptr [eax], edx */
    WR32((uint32_t)(eax + 0x4u), edx);  /* 0x4db2ee: mov dword ptr [eax + 4], edx */
    { uint32_t a_ = ecx, b_ = ecx, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); ecx = r_; }  /* 0x4db2f1: xor ecx, ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4db2f3: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = edx, b_ = 0x6cu, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4db2f6: add edx, 0x6c */
    WR32((uint32_t)(edx), ecx);  /* 0x4db2f9: mov dword ptr [edx], ecx */
    WR32((uint32_t)(edx + 0x4u), ecx);  /* 0x4db2fb: mov dword ptr [edx + 4], ecx */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x4db2fe: xor eax, eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4db300: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = 0x34u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4db303: add ecx, 0x34 */
    WR32((uint32_t)(ecx), eax);  /* 0x4db306: mov dword ptr [ecx], eax */
    WR32((uint32_t)(ecx + 0x4u), eax);  /* 0x4db308: mov dword ptr [ecx + 4], eax */
    WR32((uint32_t)(ecx + 0x8u), eax);  /* 0x4db30b: mov dword ptr [ecx + 8], eax */
    WR32((uint32_t)(ecx + 0xcu), eax);  /* 0x4db30e: mov dword ptr [ecx + 0xc], eax */
    { uint32_t a_ = edx, b_ = edx, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); edx = r_; }  /* 0x4db311: xor edx, edx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4db313: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = eax, b_ = 0x24u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4db316: add eax, 0x24 */
    WR32((uint32_t)(eax), edx);  /* 0x4db319: mov dword ptr [eax], edx */
    WR32((uint32_t)(eax + 0x4u), edx);  /* 0x4db31b: mov dword ptr [eax + 4], edx */
    WR32((uint32_t)(eax + 0x8u), edx);  /* 0x4db31e: mov dword ptr [eax + 8], edx */
    WR32((uint32_t)(eax + 0xcu), edx);  /* 0x4db321: mov dword ptr [eax + 0xc], edx */
    { uint32_t a_ = ecx, b_ = ecx, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); ecx = r_; }  /* 0x4db324: xor ecx, ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4db326: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = edx, b_ = 0x44u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4db329: add edx, 0x44 */
    WR32((uint32_t)(edx), ecx);  /* 0x4db32c: mov dword ptr [edx], ecx */
    WR32((uint32_t)(edx + 0x4u), ecx);  /* 0x4db32e: mov dword ptr [edx + 4], ecx */
    WR32((uint32_t)(edx + 0x8u), ecx);  /* 0x4db331: mov dword ptr [edx + 8], ecx */
    WR32((uint32_t)(edx + 0xcu), ecx);  /* 0x4db334: mov dword ptr [edx + 0xc], ecx */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x4db337: xor eax, eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4db339: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = 0x54u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4db33c: add ecx, 0x54 */
    WR32((uint32_t)(ecx), eax);  /* 0x4db33f: mov dword ptr [ecx], eax */
    WR32((uint32_t)(ecx + 0x4u), eax);  /* 0x4db341: mov dword ptr [ecx + 4], eax */
    WR32((uint32_t)(ecx + 0x8u), eax);  /* 0x4db344: mov dword ptr [ecx + 8], eax */
    WR32((uint32_t)(ecx + 0xcu), eax);  /* 0x4db347: mov dword ptr [ecx + 0xc], eax */
    { uint32_t a_ = edx, b_ = edx, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); edx = r_; }  /* 0x4db34a: xor edx, edx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4db34c: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = eax, b_ = 0x74u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4db34f: add eax, 0x74 */
    WR32((uint32_t)(eax), edx);  /* 0x4db352: mov dword ptr [eax], edx */
    WR32((uint32_t)(eax + 0x4u), edx);  /* 0x4db354: mov dword ptr [eax + 4], edx */
    WR32((uint32_t)(eax + 0x8u), edx);  /* 0x4db357: mov dword ptr [eax + 8], edx */
    WR32((uint32_t)(eax + 0xcu), edx);  /* 0x4db35a: mov dword ptr [eax + 0xc], edx */
    { uint32_t a_ = ecx, b_ = ecx, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); ecx = r_; }  /* 0x4db35d: xor ecx, ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4db35f: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = edx, b_ = 0x84u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4db362: add edx, 0x84 */
    WR32((uint32_t)(edx), ecx);  /* 0x4db368: mov dword ptr [edx], ecx */
    WR32((uint32_t)(edx + 0x4u), ecx);  /* 0x4db36a: mov dword ptr [edx + 4], ecx */
    WR32((uint32_t)(edx + 0x8u), ecx);  /* 0x4db36d: mov dword ptr [edx + 8], ecx */
    WR32((uint32_t)(edx + 0xcu), ecx);  /* 0x4db370: mov dword ptr [edx + 0xc], ecx */
    esp = ebp;  /* 0x4db373: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4db375: pop ebp */
    esp += 4u; goto done;  /* 0x4db376: ret  */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4ac37f (83 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4ac37f_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4ac37f: push ebp */
    ebp = esp;  /* 0x4ac380: mov ebp, esp */
    esp -= 4u; WR32(esp, ecx);  /* 0x4ac382: push ecx */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4ac383: mov dword ptr [ebp - 4], ecx */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4ac386: mov eax, dword ptr [ebp + 8] */
    ecx = RD32((uint32_t)(eax + 0x4u));  /* 0x4ac389: mov ecx, dword ptr [eax + 4] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4ac38c: add ecx, dword ptr [0x58318a] */
    edx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4ac392: mov edx, dword ptr [ebp + 0xc] */
    WR32((uint32_t)(edx + 0x4u), ecx);  /* 0x4ac395: mov dword ptr [edx + 4], ecx */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4ac398: mov eax, dword ptr [ebp + 8] */
    ecx = RD32((uint32_t)(eax + 0xcu));  /* 0x4ac39b: mov ecx, dword ptr [eax + 0xc] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4ac39e: add ecx, dword ptr [0x58318a] */
    edx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4ac3a4: mov edx, dword ptr [ebp + 0xc] */
    WR32((uint32_t)(edx + 0xcu), ecx);  /* 0x4ac3a7: mov dword ptr [edx + 0xc], ecx */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4ac3aa: mov eax, dword ptr [ebp + 8] */
    ecx = RD32((uint32_t)(eax));  /* 0x4ac3ad: mov ecx, dword ptr [eax] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4ac3af: add ecx, dword ptr [0x583186] */
    edx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4ac3b5: mov edx, dword ptr [ebp + 0xc] */
    WR32((uint32_t)(edx), ecx);  /* 0x4ac3b8: mov dword ptr [edx], ecx */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4ac3ba: mov eax, dword ptr [ebp + 8] */
    ecx = RD32((uint32_t)(eax + 0x8u));  /* 0x4ac3bd: mov ecx, dword ptr [eax + 8] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4ac3c0: add ecx, dword ptr [0x583186] */
    edx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4ac3c6: mov edx, dword ptr [ebp + 0xc] */
    WR32((uint32_t)(edx + 0x8u), ecx);  /* 0x4ac3c9: mov dword ptr [edx + 8], ecx */
    esp = ebp;  /* 0x4ac3cc: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4ac3ce: pop ebp */
    esp += 12u; goto done;  /* 0x4ac3cf: ret 8 */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4d3a52 (75 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4d3a52_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4d3a52: push ebp */
    ebp = esp;  /* 0x4d3a53: mov ebp, esp */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4d3a55: mov eax, dword ptr [ebp + 8] */
    ecx = RD32((uint32_t)(eax + 0x4u));  /* 0x4d3a58: mov ecx, dword ptr [eax + 4] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4d3a5b: add ecx, dword ptr [0x58318a] */
    edx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4d3a61: mov edx, dword ptr [ebp + 0xc] */
    WR32((uint32_t)(edx + 0x4u), ecx);  /* 0x4d3a64: mov dword ptr [edx + 4], ecx */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4d3a67: mov eax, dword ptr [ebp + 8] */
    ecx = RD32((uint32_t)(eax + 0xcu));  /* 0x4d3a6a: mov ecx, dword ptr [eax + 0xc] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(0x58318au)), r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4d3a6d: add ecx, dword ptr [0x58318a] */
    edx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4d3a73: mov edx, dword ptr [ebp + 0xc] */
    WR32((uint32_t)(edx + 0xcu), ecx);  /* 0x4d3a76: mov dword ptr [edx + 0xc], ecx */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4d3a79: mov eax, dword ptr [ebp + 8] */
    ecx = RD32((uint32_t)(eax));  /* 0x4d3a7c: mov ecx, dword ptr [eax] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4d3a7e: add ecx, dword ptr [0x583186] */
    edx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4d3a84: mov edx, dword ptr [ebp + 0xc] */
    WR32((uint32_t)(edx), ecx);  /* 0x4d3a87: mov dword ptr [edx], ecx */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4d3a89: mov eax, dword ptr [ebp + 8] */
    ecx = RD32((uint32_t)(eax + 0x8u));  /* 0x4d3a8c: mov ecx, dword ptr [eax + 8] */
    { uint32_t a_ = ecx, b_ = RD32((uint32_t)(0x583186u)), r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4d3a8f: add ecx, dword ptr [0x583186] */
    edx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4d3a95: mov edx, dword ptr [ebp + 0xc] */
    WR32((uint32_t)(edx + 0x8u), ecx);  /* 0x4d3a98: mov dword ptr [edx + 8], ecx */
    ebp = RD32(esp); esp += 4u;  /* 0x4d3a9b: pop ebp */
    esp += 4u; goto done;  /* 0x4d3a9c: ret  */
done:
    FL41_EPILOGUE
}

