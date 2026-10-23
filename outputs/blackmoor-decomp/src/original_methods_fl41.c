/* FL-41: GAME.EXE functions at or above 0x480000, translated instruction by instruction by scripts/lift_fl41.py (see original_methods_fl41.h for the model).
 * GENERATED: regenerate with scripts/fl41_generate.py; do not edit by hand. Each symbol `m<va>_lifted` is the original function at <va>; the comment above
 * it gives the address and the size. These are machine translations: they carry no names and no restructuring of the original. */
#include "original_methods_fl41.h"

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

/* GAME.EXE 0x4cd645 (186 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4cd645_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4cd645: push ebp */
    ebp = esp;  /* 0x4cd646: mov ebp, esp */
    esp -= 4u; WR32(esp, ecx);  /* 0x4cd648: push ecx */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4cd649: mov dword ptr [ebp - 4], ecx */
    esp -= 4u; WR32(esp, 0xfu);  /* 0x4cd64c: push 0xf */
    eax = RD32((uint32_t)(ebp + 0x8u));  /* 0x4cd64e: mov eax, dword ptr [ebp + 8] */
    esp -= 4u; WR32(esp, eax);  /* 0x4cd651: push eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4cd652: mov ecx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, 0x4cd65au); FL41_CALL(0x4cf1e4u); esp += 8u; esp += 4u;  /* 0x4cd655: call 0x4cf1e4 */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4cd65a: test eax, eax */
    if (!zf) goto L_4cd69f;  /* 0x4cd65c: jne 0x4cd69f */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x5c39e3u)))) & 0xffffffffu;  /* 0x4cd65e: movsx ecx, word ptr [0x5c39e3] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4cd665: push ecx */
    edx = RD32((uint32_t)(0x5bb57bu));  /* 0x4cd666: mov edx, dword ptr [0x5bb57b] */
    esp -= 4u; WR32(esp, edx);  /* 0x4cd66c: push edx */
    esp -= 4u; WR32(esp, 0x559290u);  /* 0x4cd66d: push 0x559290 */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x4cd672: push 0x63888b */
    esp -= 4u; WR32(esp, 0x4cd67cu); FL41_CALL(0x50ca3eu); esp += 4u;  /* 0x4cd677: call 0x50ca3e */
    { uint32_t a_ = esp, b_ = 0x10u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4cd67c: add esp, 0x10 */
    esp -= 4u; WR32(esp, 0x63888bu);  /* 0x4cd67f: push 0x63888b */
    esp -= 4u; WR32(esp, 0x5592bcu);  /* 0x4cd684: push 0x5592bc */
    ecx = 0x583979u;  /* 0x4cd689: mov ecx, 0x583979 */
    esp -= 4u; WR32(esp, 0x4cd693u); FL41_CALL(0x42639du); esp += 8u; esp += 4u;  /* 0x4cd68e: call 0x42639d */
    ecx = 0x5cf659u;  /* 0x4cd693: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4cd69du); FL41_CALL(0x4c97b4u); esp += 4u;  /* 0x4cd698: call 0x4c97b4 */
    goto L_4cd6f9;  /* 0x4cd69d: jmp 0x4cd6f9 */
L_4cd69f:
    eax = RD32((uint32_t)(ebp + 0xcu));  /* 0x4cd69f: mov eax, dword ptr [ebp + 0xc] */
    ecx = RD32((uint32_t)(eax));  /* 0x4cd6a2: mov ecx, dword ptr [eax] */
    edx = RD32((uint32_t)(ebp + 0x8u));  /* 0x4cd6a4: mov edx, dword ptr [ebp + 8] */
    eax = RD32((uint32_t)(edx));  /* 0x4cd6a7: mov eax, dword ptr [edx] */
    edx = RD32((uint32_t)(ecx));  /* 0x4cd6a9: mov edx, dword ptr [ecx] */
    WR32((uint32_t)(eax), edx);  /* 0x4cd6ab: mov dword ptr [eax], edx */
    edx = RD32((uint32_t)(ecx + 0x4u));  /* 0x4cd6ad: mov edx, dword ptr [ecx + 4] */
    WR32((uint32_t)(eax + 0x4u), edx);  /* 0x4cd6b0: mov dword ptr [eax + 4], edx */
    edx = RD32((uint32_t)(ecx + 0x8u));  /* 0x4cd6b3: mov edx, dword ptr [ecx + 8] */
    WR32((uint32_t)(eax + 0x8u), edx);  /* 0x4cd6b6: mov dword ptr [eax + 8], edx */
    edx = (edx & 0xffff0000u) | ((RD16((uint32_t)(ecx + 0xcu))) & 0xffffu);  /* 0x4cd6b9: mov dx, word ptr [ecx + 0xc] */
    WR16((uint32_t)(eax + 0xcu), (edx & 0xffffu));  /* 0x4cd6bd: mov word ptr [eax + 0xc], dx */
    ecx = (ecx & 0xffffff00u) | ((RD8((uint32_t)(ecx + 0xeu))) & 0xffu);  /* 0x4cd6c1: mov cl, byte ptr [ecx + 0xe] */
    WR8((uint32_t)(eax + 0xeu), (ecx & 0xffu));  /* 0x4cd6c4: mov byte ptr [eax + 0xe], cl */
    edx = RD32((uint32_t)(ebp + 0x10u));  /* 0x4cd6c7: mov edx, dword ptr [ebp + 0x10] */
    eax = RD32((uint32_t)(edx));  /* 0x4cd6ca: mov eax, dword ptr [edx] */
    { uint32_t a_ = eax, b_ = 0xfu, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4cd6cc: add eax, 0xf */
    ecx = RD32((uint32_t)(ebp + 0x10u));  /* 0x4cd6cf: mov ecx, dword ptr [ebp + 0x10] */
    WR32((uint32_t)(ecx), eax);  /* 0x4cd6d2: mov dword ptr [ecx], eax */
    edx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4cd6d4: mov edx, dword ptr [ebp + 0xc] */
    eax = RD32((uint32_t)(edx));  /* 0x4cd6d7: mov eax, dword ptr [edx] */
    { uint32_t a_ = eax, b_ = 0xfu, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4cd6d9: add eax, 0xf */
    ecx = RD32((uint32_t)(ebp + 0xcu));  /* 0x4cd6dc: mov ecx, dword ptr [ebp + 0xc] */
    WR32((uint32_t)(ecx), eax);  /* 0x4cd6df: mov dword ptr [ecx], eax */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x63a4cdu)))) & 0xffffffffu;  /* 0x4cd6e1: movsx edx, word ptr [0x63a4cd] */
    { uint32_t a_ = edx, b_ = edx, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4cd6e8: test edx, edx */
    if (zf) goto L_4cd6f9;  /* 0x4cd6ea: je 0x4cd6f9 */
    esp -= 4u; WR32(esp, 0x5592d8u);  /* 0x4cd6ec: push 0x5592d8 */
    esp -= 4u; WR32(esp, 0x4cd6f6u); FL41_CALL(0x44a2b7u); esp += 4u;  /* 0x4cd6f1: call 0x44a2b7 */
    { uint32_t a_ = esp, b_ = 0x4u, r_; FL41_ADD(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4cd6f6: add esp, 4 */
L_4cd6f9:
    esp = ebp;  /* 0x4cd6f9: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4cd6fb: pop ebp */
    esp += 16u; goto done;  /* 0x4cd6fc: ret 0xc */
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

/* GAME.EXE 0x4d3d48 (79 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4d3d48_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4d3d48: push ebp */
    ebp = esp;  /* 0x4d3d49: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0x8u, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4d3d4b: sub esp, 8 */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4d3d4e: mov dword ptr [ebp - 4], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d3d51: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0x462u));  /* 0x4d3d54: mov ecx, dword ptr [eax + 0x462] */
    WR32((uint32_t)(ebp + 0xfffffff8u), ecx);  /* 0x4d3d5a: mov dword ptr [ebp - 8], ecx */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xfffffff8u)), b_ = 0x3u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4d3d5d: cmp dword ptr [ebp - 8], 3 */
    if ((!cf && !zf)) goto L_4d3d93;  /* 0x4d3d61: ja 0x4d3d93 */
    edx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4d3d63: mov edx, dword ptr [ebp - 8] */
    /* 0x4d3d66: jmp dword ptr [edx*4 + 0x4d3d97] */
    { uint32_t t_ = RD32((uint32_t)(edx * 4u + 0x4d3d97u));
    switch (t_) {
    case 0x4d3d6du: goto L_4d3d6d;
    case 0x4d3d77u: goto L_4d3d77;
    case 0x4d3d81u: goto L_4d3d81;
    case 0x4d3d8bu: goto L_4d3d8b;
    default: FL41_TRAP;
    } }
L_4d3d6d:
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d3d6d: mov ecx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, 0x4d3d75u); FL41_CALL(0x4d3da7u); esp += 4u;  /* 0x4d3d70: call 0x4d3da7 */
    goto L_4d3d93;  /* 0x4d3d75: jmp 0x4d3d93 */
L_4d3d77:
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d3d77: mov ecx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, 0x4d3d7fu); FL41_CALL(0x4d3ebau); esp += 4u;  /* 0x4d3d7a: call 0x4d3eba */
    goto L_4d3d93;  /* 0x4d3d7f: jmp 0x4d3d93 */
L_4d3d81:
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d3d81: mov ecx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, 0x4d3d89u); FL41_CALL(0x4d3fa9u); esp += 4u;  /* 0x4d3d84: call 0x4d3fa9 */
    goto L_4d3d93;  /* 0x4d3d89: jmp 0x4d3d93 */
L_4d3d8b:
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d3d8b: mov ecx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, 0x4d3d93u); FL41_CALL(0x4d3ffeu); esp += 4u;  /* 0x4d3d8e: call 0x4d3ffe */
L_4d3d93:
    esp = ebp;  /* 0x4d3d93: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4d3d95: pop ebp */
    esp += 4u; goto done;  /* 0x4d3d96: ret  */
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

/* GAME.EXE 0x4d42e0 (127 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4d42e0_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4d42e0: push ebp */
    ebp = esp;  /* 0x4d42e1: mov ebp, esp */
    esp -= 4u; WR32(esp, ecx);  /* 0x4d42e3: push ecx */
    eax = RD32((uint32_t)(0x583991u));  /* 0x4d42e4: mov eax, dword ptr [0x583991] */
    WR32((uint32_t)(ebp + 0xfffffffcu), eax);  /* 0x4d42e9: mov dword ptr [ebp - 4], eax */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xfffffffcu)), b_ = 0x5u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4d42ec: cmp dword ptr [ebp - 4], 5 */
    if ((!cf && !zf)) goto L_4d435b;  /* 0x4d42f0: ja 0x4d435b */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4d42f2: mov ecx, dword ptr [ebp - 4] */
    /* 0x4d42f5: jmp dword ptr [ecx*4 + 0x4d435f] */
    { uint32_t t_ = RD32((uint32_t)(ecx * 4u + 0x4d435fu));
    switch (t_) {
    case 0x4d42fcu: goto L_4d42fc;
    case 0x4d430du: goto L_4d430d;
    case 0x4d4323u: goto L_4d4323;
    case 0x4d4339u: goto L_4d4339;
    case 0x4d4340u: goto L_4d4340;
    case 0x4d4356u: goto L_4d4356;
    default: FL41_TRAP;
    } }
L_4d42fc:
    esp -= 4u; WR32(esp, 0x4d4301u); FL41_CALL(0x4d4377u); esp += 4u;  /* 0x4d42fc: call 0x4d4377 */
    WR32((uint32_t)(0x583991u), 0x1u);  /* 0x4d4301: mov dword ptr [0x583991], 1 */
    goto L_4d435b;  /* 0x4d430b: jmp 0x4d435b */
L_4d430d:
    ecx = 0x5c3a67u;  /* 0x4d430d: mov ecx, 0x5c3a67 */
    esp -= 4u; WR32(esp, 0x4d4317u); FL41_CALL(0x4fc05du); esp += 4u;  /* 0x4d4312: call 0x4fc05d */
    WR32((uint32_t)(0x583991u), 0x2u);  /* 0x4d4317: mov dword ptr [0x583991], 2 */
    goto L_4d435b;  /* 0x4d4321: jmp 0x4d435b */
L_4d4323:
    ecx = 0x5c3a67u;  /* 0x4d4323: mov ecx, 0x5c3a67 */
    esp -= 4u; WR32(esp, 0x4d432du); FL41_CALL(0x4fbaafu); esp += 4u;  /* 0x4d4328: call 0x4fbaaf */
    WR32((uint32_t)(0x583991u), 0x3u);  /* 0x4d432d: mov dword ptr [0x583991], 3 */
    goto L_4d435b;  /* 0x4d4337: jmp 0x4d435b */
L_4d4339:
    esp -= 4u; WR32(esp, 0x4d433eu); FL41_CALL(0x4d4410u); esp += 4u;  /* 0x4d4339: call 0x4d4410 */
    goto L_4d435b;  /* 0x4d433e: jmp 0x4d435b */
L_4d4340:
    ecx = 0x5c3a67u;  /* 0x4d4340: mov ecx, 0x5c3a67 */
    esp -= 4u; WR32(esp, 0x4d434au); FL41_CALL(0x4fbd7eu); esp += 4u;  /* 0x4d4345: call 0x4fbd7e */
    WR32((uint32_t)(0x583991u), 0x5u);  /* 0x4d434a: mov dword ptr [0x583991], 5 */
    goto L_4d435b;  /* 0x4d4354: jmp 0x4d435b */
L_4d4356:
    esp -= 4u; WR32(esp, 0x4d435bu); FL41_CALL(0x4d4645u); esp += 4u;  /* 0x4d4356: call 0x4d4645 */
L_4d435b:
    esp = ebp;  /* 0x4d435b: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4d435d: pop ebp */
    esp += 4u; goto done;  /* 0x4d435e: ret  */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4d4377 (153 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4d4377_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4d4377: push ebp */
    ebp = esp;  /* 0x4d4378: mov ebp, esp */
    ecx = 0x5830a6u;  /* 0x4d437a: mov ecx, 0x5830a6 */
    esp -= 4u; WR32(esp, 0x4d4384u); FL41_CALL(0x4dad60u); esp += 4u;  /* 0x4d437f: call 0x4dad60 */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ ^ b_; FL41_LOGIC(r_, 32); eax = r_; }  /* 0x4d4384: xor eax, eax */
    eax = (eax & 0xffffff00u) | ((RD8((uint32_t)(0x58320du))) & 0xffu);  /* 0x4d4386: mov al, byte ptr [0x58320d] */
    { uint32_t a_ = eax, b_ = eax, r_; r_ = a_ & b_; FL41_LOGIC(r_, 32); }  /* 0x4d438b: test eax, eax */
    if (zf) goto L_4d439b;  /* 0x4d438d: je 0x4d439b */
    WR8((uint32_t)(0x58320du), 0x0u);  /* 0x4d438f: mov byte ptr [0x58320d], 0 */
    esp -= 4u; WR32(esp, 0x4d439bu); FL41_CALL(0x425fc0u); esp += 4u;  /* 0x4d4396: call 0x425fc0 */
L_4d439b:
    WR32((uint32_t)(0x5b010fu), 0x0u);  /* 0x4d439b: mov dword ptr [0x5b010f], 0 */
    WR16((uint32_t)(0x5b00e7u), 0xffffu);  /* 0x4d43a5: mov word ptr [0x5b00e7], 0xffff */
    WR16((uint32_t)(0x5b00e9u), 0x0u);  /* 0x4d43ae: mov word ptr [0x5b00e9], 0 */
    esp -= 4u; WR32(esp, 0x4d43bdu);  /* call [KERNEL32.dll!GetTickCount] */ FL41_CALL(0x52a23cu); esp += 4u;  /* 0x4d43b7: call dword ptr [0x52a23c] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x5b00b4u)))) & 0xffffffffu;  /* 0x4d43bd: movsx ecx, word ptr [0x5b00b4] */
    { uint32_t a_ = eax, b_ = ecx, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4d43c4: add eax, ecx */
    WR32((uint32_t)(0x5b00ebu), eax);  /* 0x4d43c6: mov dword ptr [0x5b00eb], eax */
    esp -= 4u; WR32(esp, 0x5d0387u);  /* 0x4d43cb: push 0x5d0387 */
    ecx = 0x5cf659u;  /* 0x4d43d0: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4d43dau); FL41_CALL(0x4c2dfbu); esp += 4u; esp += 4u;  /* 0x4d43d5: call 0x4c2dfb */
    esp -= 4u; WR32(esp, 0x5d038bu);  /* 0x4d43da: push 0x5d038b */
    ecx = 0x5cf659u;  /* 0x4d43df: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4d43e9u); FL41_CALL(0x4c2dfbu); esp += 4u; esp += 4u;  /* 0x4d43e4: call 0x4c2dfb */
    esp -= 4u; WR32(esp, 0x55a538u);  /* 0x4d43e9: push 0x55a538 */
    esp -= 4u; WR32(esp, 0x6u);  /* 0x4d43ee: push 6 */
    esp -= 4u; WR32(esp, 0x5b0032u);  /* 0x4d43f0: push 0x5b0032 */
    esp -= 4u; WR32(esp, 0x55a54cu);  /* 0x4d43f5: push 0x55a54c */
    ecx = 0x5cf659u;  /* 0x4d43fa: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4d4404u); FL41_CALL(0x4c2790u); esp += 16u; esp += 4u;  /* 0x4d43ff: call 0x4c2790 */
    WR32((uint32_t)(0x5d0387u), eax);  /* 0x4d4404: mov dword ptr [0x5d0387], eax */
    esp -= 4u; WR32(esp, 0x4d440eu); FL41_CALL(0x4d46b3u); esp += 4u;  /* 0x4d4409: call 0x4d46b3 */
    ebp = RD32(esp); esp += 4u;  /* 0x4d440e: pop ebp */
    esp += 4u; goto done;  /* 0x4d440f: ret  */
done:
    FL41_EPILOGUE
}

/* GAME.EXE 0x4d46b3 (248 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4d46b3_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4d46b3: push ebp */
    ebp = esp;  /* 0x4d46b4: mov ebp, esp */
    esp -= 4u; WR32(esp, 0x5d038bu);  /* 0x4d46b6: push 0x5d038b */
    ecx = 0x5cf659u;  /* 0x4d46bb: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4d46c5u); FL41_CALL(0x4c2dfbu); esp += 4u; esp += 4u;  /* 0x4d46c0: call 0x4c2dfb */
    eax = (eax & 0xffff0000u) | ((RD16((uint32_t)(0x5b00e7u))) & 0xffffu);  /* 0x4d46c5: mov ax, word ptr [0x5b00e7] */
    { uint32_t a_ = (eax & 0xffffu), b_ = 0x1u, r_; FL41_ADD(a_, b_, 0u, r_, 16); eax = (eax & 0xffff0000u) | ((r_) & 0xffffu); }  /* 0x4d46cb: add ax, 1 */
    WR16((uint32_t)(0x5b00e7u), (eax & 0xffffu));  /* 0x4d46cf: mov word ptr [0x5b00e7], ax */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x5b00e7u)))) & 0xffffffffu;  /* 0x4d46d5: movsx ecx, word ptr [0x5b00e7] */
    { uint32_t a_ = ecx, b_ = 0x1u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4d46dc: cmp ecx, 1 */
    if ((sf != of)) goto L_4d46ea;  /* 0x4d46df: jl 0x4d46ea */
    WR16((uint32_t)(0x5b00e7u), 0x0u);  /* 0x4d46e1: mov word ptr [0x5b00e7], 0 */
L_4d46ea:
    esp -= 4u; WR32(esp, 0x55a584u);  /* 0x4d46ea: push 0x55a584 */
    esp -= 4u; WR32(esp, 0x6u);  /* 0x4d46ef: push 6 */
    edx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(0x5b00e7u)))) & 0xffffffffu;  /* 0x4d46f1: movsx edx, word ptr [0x5b00e7] */
    { int64_t w_ = (int64_t)(int32_t)(edx) * (int32_t)(0x21u); uint32_t r_ = (uint32_t)w_; cf = of = (w_ != (int64_t)(int32_t)r_); FL41_ZSP(r_, 32); edx = r_; }  /* 0x4d46f8: imul edx, edx, 0x21 */
    { uint32_t a_ = edx, b_ = 0x5b0053u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4d46fb: add edx, 0x5b0053 */
    esp -= 4u; WR32(esp, edx);  /* 0x4d4701: push edx */
    esp -= 4u; WR32(esp, 0x55a59cu);  /* 0x4d4702: push 0x55a59c */
    ecx = 0x5cf659u;  /* 0x4d4707: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4d4711u); FL41_CALL(0x4c2790u); esp += 16u; esp += 4u;  /* 0x4d470c: call 0x4c2790 */
    WR32((uint32_t)(0x5d038bu), eax);  /* 0x4d4711: mov dword ptr [0x5d038b], eax */
    WR32((uint32_t)(0x5b0084u), 0x0u);  /* 0x4d4716: mov dword ptr [0x5b0084], 0 */
    WR32((uint32_t)(0x5b0088u), 0x0u);  /* 0x4d4720: mov dword ptr [0x5b0088], 0 */
    eax = RD32((uint32_t)(0x5d038bu));  /* 0x4d472a: mov eax, dword ptr [0x5d038b] */
    ecx = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(eax + 0x2bu)))) & 0xffffffffu;  /* 0x4d472f: movsx ecx, word ptr [eax + 0x2b] */
    { uint32_t a_ = ecx, b_ = 0x1u, r_; FL41_SUB(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4d4733: sub ecx, 1 */
    WR32((uint32_t)(0x5b008cu), ecx);  /* 0x4d4736: mov dword ptr [0x5b008c], ecx */
    edx = RD32((uint32_t)(0x5d038bu));  /* 0x4d473c: mov edx, dword ptr [0x5d038b] */
    eax = ((uint32_t)(int32_t)(int16_t)(RD16((uint32_t)(edx + 0x2du)))) & 0xffffffffu;  /* 0x4d4742: movsx eax, word ptr [edx + 0x2d] */
    { uint32_t a_ = eax, b_ = 0x1u, r_; FL41_SUB(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4d4746: sub eax, 1 */
    WR32((uint32_t)(0x5b0090u), eax);  /* 0x4d4749: mov dword ptr [0x5b0090], eax */
    ecx = RD32((uint32_t)(0x5b00a4u));  /* 0x4d474e: mov ecx, dword ptr [0x5b00a4] */
    WR32((uint32_t)(0x5b00efu), ecx);  /* 0x4d4754: mov dword ptr [0x5b00ef], ecx */
    edx = RD32((uint32_t)(0x5b00acu));  /* 0x4d475a: mov edx, dword ptr [0x5b00ac] */
    WR32((uint32_t)(0x5b00f7u), edx);  /* 0x4d4760: mov dword ptr [0x5b00f7], edx */
    WR32((uint32_t)(0x5b00f3u), 0x0u);  /* 0x4d4766: mov dword ptr [0x5b00f3], 0 */
    WR32((uint32_t)(0x5b00fbu), 0x1u);  /* 0x4d4770: mov dword ptr [0x5b00fb], 1 */
    eax = RD32((uint32_t)(0x5b0094u));  /* 0x4d477a: mov eax, dword ptr [0x5b0094] */
    WR32((uint32_t)(0x5b00ffu), eax);  /* 0x4d477f: mov dword ptr [0x5b00ff], eax */
    ecx = RD32((uint32_t)(0x5b009cu));  /* 0x4d4784: mov ecx, dword ptr [0x5b009c] */
    WR32((uint32_t)(0x5b0107u), ecx);  /* 0x4d478a: mov dword ptr [0x5b0107], ecx */
    edx = RD32((uint32_t)(0x5b00a0u));  /* 0x4d4790: mov edx, dword ptr [0x5b00a0] */
    { uint32_t a_ = edx, b_ = 0x1u, r_; FL41_SUB(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4d4796: sub edx, 1 */
    WR32((uint32_t)(0x5b0103u), edx);  /* 0x4d4799: mov dword ptr [0x5b0103], edx */
    eax = RD32((uint32_t)(0x5b00a0u));  /* 0x4d479f: mov eax, dword ptr [0x5b00a0] */
    WR32((uint32_t)(0x5b010bu), eax);  /* 0x4d47a4: mov dword ptr [0x5b010b], eax */
    ebp = RD32(esp); esp += 4u;  /* 0x4d47a9: pop ebp */
    esp += 4u; goto done;  /* 0x4d47aa: ret  */
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

/* GAME.EXE 0x4de743 (109 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4de743_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4de743: push ebp */
    ebp = esp;  /* 0x4de744: mov ebp, esp */
    { uint32_t a_ = esp, b_ = 0x8u, r_; FL41_SUB(a_, b_, 0u, r_, 32); esp = r_; }  /* 0x4de746: sub esp, 8 */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4de749: mov dword ptr [ebp - 4], ecx */
    eax = RD32((uint32_t)(0x583995u));  /* 0x4de74c: mov eax, dword ptr [0x583995] */
    WR32((uint32_t)(ebp + 0xfffffff8u), eax);  /* 0x4de751: mov dword ptr [ebp - 8], eax */
    { uint32_t a_ = RD32((uint32_t)(ebp + 0xfffffff8u)), b_ = 0x4u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4de754: cmp dword ptr [ebp - 8], 4 */
    if ((!cf && !zf)) goto L_4de7ac;  /* 0x4de758: ja 0x4de7ac */
    ecx = RD32((uint32_t)(ebp + 0xfffffff8u));  /* 0x4de75a: mov ecx, dword ptr [ebp - 8] */
    /* 0x4de75d: jmp dword ptr [ecx*4 + 0x4de7b0] */
    { uint32_t t_ = RD32((uint32_t)(ecx * 4u + 0x4de7b0u));
    switch (t_) {
    case 0x4de764u: goto L_4de764;
    case 0x4de76eu: goto L_4de76e;
    case 0x4de784u: goto L_4de784;
    case 0x4de78eu: goto L_4de78e;
    case 0x4de7a4u: goto L_4de7a4;
    default: FL41_TRAP;
    } }
L_4de764:
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4de764: mov ecx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, 0x4de76cu); FL41_CALL(0x4de7c4u); esp += 4u;  /* 0x4de767: call 0x4de7c4 */
    goto L_4de7ac;  /* 0x4de76c: jmp 0x4de7ac */
L_4de76e:
    ecx = 0x5c3a67u;  /* 0x4de76e: mov ecx, 0x5c3a67 */
    esp -= 4u; WR32(esp, 0x4de778u); FL41_CALL(0x4fb397u); esp += 4u;  /* 0x4de773: call 0x4fb397 */
    WR32((uint32_t)(0x583995u), 0x3u);  /* 0x4de778: mov dword ptr [0x583995], 3 */
    goto L_4de7ac;  /* 0x4de782: jmp 0x4de7ac */
L_4de784:
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4de784: mov ecx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, 0x4de78cu); FL41_CALL(0x4deed7u); esp += 4u;  /* 0x4de787: call 0x4deed7 */
    goto L_4de7ac;  /* 0x4de78c: jmp 0x4de7ac */
L_4de78e:
    ecx = 0x5c3a67u;  /* 0x4de78e: mov ecx, 0x5c3a67 */
    esp -= 4u; WR32(esp, 0x4de798u); FL41_CALL(0x4fb737u); esp += 4u;  /* 0x4de793: call 0x4fb737 */
    WR32((uint32_t)(0x583995u), 0x4u);  /* 0x4de798: mov dword ptr [0x583995], 4 */
    goto L_4de7ac;  /* 0x4de7a2: jmp 0x4de7ac */
L_4de7a4:
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4de7a4: mov ecx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, 0x4de7acu); FL41_CALL(0x4dfdc9u); esp += 4u;  /* 0x4de7a7: call 0x4dfdc9 */
L_4de7ac:
    esp = ebp;  /* 0x4de7ac: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4de7ae: pop ebp */
    esp += 4u; goto done;  /* 0x4de7af: ret  */
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

/* GAME.EXE 0x4e1d34 (127 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4e1d34_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4e1d34: push ebp */
    ebp = esp;  /* 0x4e1d35: mov ebp, esp */
    esp -= 4u; WR32(esp, ecx);  /* 0x4e1d37: push ecx */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4e1d38: mov dword ptr [ebp - 4], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e1d3b: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(eax + 0x187u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4e1d3e: cmp dword ptr [eax + 0x187], 0 */
    if (!zf) goto L_4e1d6d;  /* 0x4e1d45: jne 0x4e1d6d */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e1d47: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(ecx + 0x18bu)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4e1d4a: cmp dword ptr [ecx + 0x18b], 0 */
    if (!zf) goto L_4e1d6d;  /* 0x4e1d51: jne 0x4e1d6d */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e1d53: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(edx + 0x24u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4e1d56: cmp dword ptr [edx + 0x24], 0 */
    if (zf) goto L_4e1d6d;  /* 0x4e1d5a: je 0x4e1d6d */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e1d5c: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = eax, b_ = 0x24u, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4e1d5f: add eax, 0x24 */
    esp -= 4u; WR32(esp, eax);  /* 0x4e1d62: push eax */
    ecx = 0x5cf659u;  /* 0x4e1d63: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4e1d6du); FL41_CALL(0x4c2dfbu); esp += 4u; esp += 4u;  /* 0x4e1d68: call 0x4c2dfb */
L_4e1d6d:
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e1d6d: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(ecx + 0x28u)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4e1d70: cmp dword ptr [ecx + 0x28], 0 */
    if (zf) goto L_4e1d87;  /* 0x4e1d74: je 0x4e1d87 */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e1d76: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = edx, b_ = 0x28u, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4e1d79: add edx, 0x28 */
    esp -= 4u; WR32(esp, edx);  /* 0x4e1d7c: push edx */
    ecx = 0x5cf659u;  /* 0x4e1d7d: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4e1d87u); FL41_CALL(0x4c2dfbu); esp += 4u; esp += 4u;  /* 0x4e1d82: call 0x4c2dfb */
L_4e1d87:
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e1d87: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(eax + 0x17fu)), b_ = 0x0u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4e1d8a: cmp dword ptr [eax + 0x17f], 0 */
    if (zf) goto L_4e1da7;  /* 0x4e1d91: je 0x4e1da7 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e1d93: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = 0xf6u, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4e1d96: add ecx, 0xf6 */
    esp -= 4u; WR32(esp, ecx);  /* 0x4e1d9c: push ecx */
    ecx = 0x5c3a67u;  /* 0x4e1d9d: mov ecx, 0x5c3a67 */
    esp -= 4u; WR32(esp, 0x4e1da7u); FL41_CALL(0x4fba69u); esp += 4u; esp += 4u;  /* 0x4e1da2: call 0x4fba69 */
L_4e1da7:
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4e1da7: mov ecx, dword ptr [ebp - 4] */
    esp -= 4u; WR32(esp, 0x4e1dafu); FL41_CALL(0x4e1c9fu); esp += 4u;  /* 0x4e1daa: call 0x4e1c9f */
    esp = ebp;  /* 0x4e1daf: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4e1db1: pop ebp */
    esp += 4u; goto done;  /* 0x4e1db2: ret  */
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

/* GAME.EXE 0x4eff03 (200 bytes): machine translation of the original instructions, see the note at the top of this file. */
void m4eff03_lifted(Fl41Regs *r, const Fl41Host *h)
{
    FL41_PROLOGUE
    esp -= 4u; WR32(esp, ebp);  /* 0x4eff03: push ebp */
    ebp = esp;  /* 0x4eff04: mov ebp, esp */
    esp -= 4u; WR32(esp, ecx);  /* 0x4eff06: push ecx */
    WR32((uint32_t)(ebp + 0xfffffffcu), ecx);  /* 0x4eff07: mov dword ptr [ebp - 4], ecx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4eff0a: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(eax + 0x10u)), b_ = 0x4u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4eff0d: cmp dword ptr [eax + 0x10], 4 */
    if (!zf) goto L_4eff18;  /* 0x4eff11: jne 0x4eff18 */
    goto L_4effc7;  /* 0x4eff13: jmp 0x4effc7 */
L_4eff18:
    esp -= 4u; WR32(esp, 0x55cef0u);  /* 0x4eff18: push 0x55cef0 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4eff1d: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = 0x12eu, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4eff20: add ecx, 0x12e */
    esp -= 4u; WR32(esp, ecx);  /* 0x4eff26: push ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4eff27: mov edx, dword ptr [ebp - 4] */
    { uint32_t a_ = edx, b_ = 0x9eu, r_; FL41_ADD(a_, b_, 0u, r_, 32); edx = r_; }  /* 0x4eff2a: add edx, 0x9e */
    esp -= 4u; WR32(esp, edx);  /* 0x4eff30: push edx */
    eax = RD32((uint32_t)(0x5cf665u));  /* 0x4eff31: mov eax, dword ptr [0x5cf665] */
    esp -= 4u; WR32(esp, eax);  /* 0x4eff36: push eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4eff37: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ecx + 0xcu));  /* 0x4eff3a: mov edx, dword ptr [ecx + 0xc] */
    esp -= 4u; WR32(esp, edx);  /* 0x4eff3d: push edx */
    ecx = 0x5cf659u;  /* 0x4eff3e: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4eff48u); FL41_CALL(0x4c5377u); esp += 20u; esp += 4u;  /* 0x4eff43: call 0x4c5377 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4eff48: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = RD32((uint32_t)(eax + 0x14u)), b_ = 0x1u, r_; FL41_SUB(a_, b_, 0u, r_, 32); }  /* 0x4eff4b: cmp dword ptr [eax + 0x14], 1 */
    if (!zf) goto L_4eff8d;  /* 0x4eff4f: jne 0x4eff8d */
    esp -= 4u; WR32(esp, 0x55cf10u);  /* 0x4eff51: push 0x55cf10 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4eff56: mov ecx, dword ptr [ebp - 4] */
    { uint32_t a_ = ecx, b_ = 0x13eu, r_; FL41_ADD(a_, b_, 0u, r_, 32); ecx = r_; }  /* 0x4eff59: add ecx, 0x13e */
    esp -= 4u; WR32(esp, ecx);  /* 0x4eff5f: push ecx */
    edx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4eff60: mov edx, dword ptr [ebp - 4] */
    eax = RD32((uint32_t)(edx + 0x10u));  /* 0x4eff63: mov eax, dword ptr [edx + 0x10] */
    { uint32_t a_ = eax, n_ = 0x4u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); eax = r_; } }  /* 0x4eff66: shl eax, 4 */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4eff69: mov ecx, dword ptr [ebp - 4] */
    edx = (uint32_t)(ecx + eax + 0xdeu);  /* 0x4eff6c: lea edx, [ecx + eax + 0xde] */
    esp -= 4u; WR32(esp, edx);  /* 0x4eff73: push edx */
    eax = RD32((uint32_t)(0x5cf665u));  /* 0x4eff74: mov eax, dword ptr [0x5cf665] */
    esp -= 4u; WR32(esp, eax);  /* 0x4eff79: push eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4eff7a: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ecx + 0x8u));  /* 0x4eff7d: mov edx, dword ptr [ecx + 8] */
    esp -= 4u; WR32(esp, edx);  /* 0x4eff80: push edx */
    ecx = 0x5cf659u;  /* 0x4eff81: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4eff8bu); FL41_CALL(0x4c5d4bu); esp += 20u; esp += 4u;  /* 0x4eff86: call 0x4c5d4b */
    goto L_4effc7;  /* 0x4eff8b: jmp 0x4effc7 */
L_4eff8d:
    esp -= 4u; WR32(esp, 0x55cf30u);  /* 0x4eff8d: push 0x55cf30 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4eff92: mov eax, dword ptr [ebp - 4] */
    { uint32_t a_ = eax, b_ = 0x13eu, r_; FL41_ADD(a_, b_, 0u, r_, 32); eax = r_; }  /* 0x4eff95: add eax, 0x13e */
    esp -= 4u; WR32(esp, eax);  /* 0x4eff9a: push eax */
    ecx = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4eff9b: mov ecx, dword ptr [ebp - 4] */
    edx = RD32((uint32_t)(ecx + 0x10u));  /* 0x4eff9e: mov edx, dword ptr [ecx + 0x10] */
    { uint32_t a_ = edx, n_ = 0x4u, r_; if (n_ != 0u) { FL41_SHL(r_, a_, n_, 32); edx = r_; } }  /* 0x4effa1: shl edx, 4 */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4effa4: mov eax, dword ptr [ebp - 4] */
    ecx = (uint32_t)(eax + edx + 0xdeu);  /* 0x4effa7: lea ecx, [eax + edx + 0xde] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4effae: push ecx */
    edx = RD32((uint32_t)(0x5cf665u));  /* 0x4effaf: mov edx, dword ptr [0x5cf665] */
    esp -= 4u; WR32(esp, edx);  /* 0x4effb5: push edx */
    eax = RD32((uint32_t)(ebp + 0xfffffffcu));  /* 0x4effb6: mov eax, dword ptr [ebp - 4] */
    ecx = RD32((uint32_t)(eax + 0x8u));  /* 0x4effb9: mov ecx, dword ptr [eax + 8] */
    esp -= 4u; WR32(esp, ecx);  /* 0x4effbc: push ecx */
    ecx = 0x5cf659u;  /* 0x4effbd: mov ecx, 0x5cf659 */
    esp -= 4u; WR32(esp, 0x4effc7u); FL41_CALL(0x4c5377u); esp += 20u; esp += 4u;  /* 0x4effc2: call 0x4c5377 */
L_4effc7:
    esp = ebp;  /* 0x4effc7: mov esp, ebp */
    ebp = RD32(esp); esp += 4u;  /* 0x4effc9: pop ebp */
    esp += 4u; goto done;  /* 0x4effca: ret  */
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

